Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4C7FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC5D6B0088; Tue, 28 Apr 2026 03:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DD46B008A; Tue, 28 Apr 2026 03:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973706B008C; Tue, 28 Apr 2026 03:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86F5E6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:39:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A743140565
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:38:09 +0000 (UTC)
X-FDA: 84707161098.20.891A0DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id EE7931C0016
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:38:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z9RrfqiJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777361888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjNBDa9ukGP6XvIb5K+N81tr9d1myfj10z3M9meByZg=;
	b=47rlbwlPoBy1sO5/YxV++l/1aOhUYUe1BLw1ZoKZQDbGo5YyNfloZ0I2XW3Sx4o5DyZrE6
	A6U7HJnxz3l+EuZzOE+0r5ivDEjL9j8vJCwTUI56qeYepwRCEWgavs+ykqaFijyAUJDjE1
	s3EmT5LThrFTrGSW/nj7FmxWJBR2ylc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777361888; a=rsa-sha256;
	cv=none;
	b=x5KFT9zEPUeyrADY3JxZyB+n5WC9Z+qccFVaBCcd3OzK3a4WsMjS3bZxYLx7U1tH1icSNj
	vWBYYtKSDcPsCiueNumpzxvyFveCOM4wvN24LPo5S0XfHqO53VQlq6V2oTS4R6LugSXMSG
	OcNj5iks/JwYimMH3rY5mpoADnoRnig=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z9RrfqiJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D47960180;
	Tue, 28 Apr 2026 07:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28593C2BCAF;
	Tue, 28 Apr 2026 07:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777361887;
	bh=Fs2EdXEHwQhEBs2qS7lBmnFrIG342K7mhWLjyjsir6c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z9RrfqiJuO4KdVG4NwIE8wOsqnLnSGMqhv0BTORUzQkkWJbCRGJtL+TZUO3X0wfo/
	 P32Q4DRtGd2sNV383uRrVpEqPYx/1jmmS6Q7/UYSzdFtD6rjIYET11K5maX0p9rwPJ
	 CxuLATOFhZY/DTbu+0CPHwNHd1lSChmJ4D8PUQuaJZLx+Ctsp/y9m8Q5HxzT8aN6vD
	 nshDqWSk+JkXE5fGiIECqlZnYLVtP3PzUyxveSla35Qg7qq8UOt8IYCQPFYtFpUMxr
	 7BFM3ypibEgUkk5HbUyoPAT+kclA50yhyS1sIB5NbiPTe8H+luqhQhAybLwtiQjvrp
	 LLpXfh29JQn5g==
Message-ID: <4b36424f-218d-46eb-88d2-a25f146fb792@kernel.org>
Date: Tue, 28 Apr 2026 09:38:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] Docs/admin-guide/mm/damon: fix 'parametrs' typo
Content-Language: en-US
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Cheng-Han Wu <hank20010209@gmail.com>, "Liam R. Howlett"
 <liam@infradead.org>, David Hildenbrand <david@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260427233927.146488-1-sj@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260427233927.146488-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE7931C0016
X-Stat-Signature: 4dik7dzgnx44ki1f14ksxjkgq7yf6pq9
X-Rspam-User: 
X-HE-Tag: 1777361887-39004
X-HE-Meta: U2FsdGVkX18jL5XKo9p85Jiztb/rQGuSDLiE6tZJMKg9GpWN1iAxq08mz+3gLcoRLtOhd/WAylPTdD2qgKhv8oBdfbOOVpGZUNDd4AoamYBCiYes2Tn0bhEUXE4AksWd7CbBTo6PgTlsCA1Ksfuloqkqz9Xsy5Rm6wfeWwNxfE4R8PexJgPIM530m6fZs9eG7lJzajZKkZtL25apOfCKRqo99INWjSR5y5XGDMFXy1oUb9npNB+g0ZcWRjjaJnR/uOlBE6Gj3OeMbb6ZwJy1uVJnd3LH6psKCA+0fAmTJCHb+xTTU8BwaBCQq0+/OcgH1Y5wzGAZmPsu88o4K2IGC73oPGSkAW+YYYRrCYJRQqMctFatdT/s/SYTQDGmnDPXKxDf/JuJtt8Le5BKBQQ+9uad9fVkSW9V6ituDOkRqA971Z8x8SO7ap2qOCoYkLAT/RkAMTDu+NwRvmGsJpGCfkfID8S5666vUxj8B8/evtYFXp9oyG25On0kspHTNj+AwvJntADeybd8zUqqfLuXXvXJIb5okR1XKcbXY+UQbWOEN7+01t3Q7qHv3z+kZe3bj0olLjAy+ZItvjA9DuwbMBirqKI88WEezpxH79t4Q1Ab5psR0N1uEaCXEZRv2VZ0Cp1Y0W8Vyz+SYgWdCPzKEIfP96zrQ328nlrl3NcPCJH1JCW0cuWd9+S95DtNN651qvMPFFGnfTUFHVOeIQc/089DesRwHQ+p2INGT9gXll9ldh4vqI9sX+qloVLorTK2RN3Km7lMR/sU0l6RtBq6WAyQowJAi/sHcIt19MCU+htVMQ5hBDmIjA26RxdhULRnP8ZPQslTRAwUreFWtoMkkveNnAyl7UgpxvmgqG4/3lBRVoBeZMkEs/RalI1KlP4Xw9wKh8Tul6Vj7NLxFXQ+su2gvv0jwvqE09lK/eD8n5LRbfaUmxcXyqZnxueeH9XfvdUFXRizyF1BS1HuxOD
 wSDLofhE
 8vj7KmpCufz1/AoRQR/1Ykoldf2Ormy8CpvVLcWGulwHIJLNGbQtDFxl7bEFt1pWh3JYt6laplFKkxz+F/rAm+aKNsxGu0XK4NpnjWHFKQyPEch3jY/t70C2t5dqUEv8sII/Gz5gYBsBCRw3fefU3wNZqZLMw4XePb9/ZUbMEZPGvpxcj8YHadUJ0lLNgUQqR25SKifmr75KiAn9daK42ZLGYM02l3/WXj4gcXlCUWhloKiH7M8UiWi3n/gy4j2cjq/lM9UKYI3esxGTKGlpgzv5MdLigBjsq7PXBEg1Yr3MyUtaCZ9VoQAvjLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 01:39, SeongJae Park wrote:
> On Sun, 26 Apr 2026 16:16:15 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
>> From: Cheng-Han Wu <hank20010209@gmail.com>
>> 
>> Fix the misspelling of "parametrs" as "parameters" in
>> reclaim.rst and lru_sort.rst.
>> 
>> Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
> 
> Oops, I forgot adding my Reviewed-by: tag.
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
> Andrew, could you please add the above my Reviewed-by: tag?

Since you were sending that patch along in you series, there was (as it
must) already your S-o-b tag and that's stronger responsibility than a
Reviewed-by, so it's redundant to add it :)


> Thanks,
> SJ
> 
> [...]


