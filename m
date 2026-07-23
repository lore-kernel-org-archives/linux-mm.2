Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22B9C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 10:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B856B00AB; Thu, 23 Jul 2026 06:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4BC6B00AC; Thu, 23 Jul 2026 06:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C626B00AD; Thu, 23 Jul 2026 06:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 872866B00AB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:23:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DEFC71403FA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:23:07 +0000 (UTC)
X-FDA: 85019653614.12.B9B2B9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3810C40005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:23:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwNYbYnp;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784802186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=go7Y++9i2ovOLRuatKWJusZrB2J2y0mZiW0U9qh+nWA=;
	b=o18JuAUpXqcqH0J7PlEtq+MN1O0IfYPI8SSero+0lWIbE570wlXMcPhnNV4bszhvpumopC
	iW5OKj/MBxL0OwYeUg8oQQfM8ZqvlT29PphaqEPe7M/D7tb+5LXkrf8N3WwTCP8gAiLGCO
	Hdh6eTSxBSJz3o0+ui4wqfFLd+d3opo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784802186;
	b=HAQeSpK3gDmUeIaU/5kdjIhKFDt6c6QiI/fZHVCyzq1AnGW+Kyi63t8eK4i5ZU/eyiKbVO
	LTxavyivoMs4p6yLvk8fs5b+HbEODFTGGUIi7yQDc5Ijeza1wjn4mZ7IkIshldLlXhn6Vp
	MGtALD37Q4jDhjnETGMI2pyM3LGOluU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwNYbYnp;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E090600AD;
	Thu, 23 Jul 2026 10:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C841F00A3A;
	Thu, 23 Jul 2026 10:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802185;
	bh=go7Y++9i2ovOLRuatKWJusZrB2J2y0mZiW0U9qh+nWA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EwNYbYnpJeqhXkEBVp4z5DHKL2WlH3S3PqlMxBJ77F4koUqIBvAMjS3lSxJT/oMbf
	 v5a1dHjfgX71d/JwY4TJbluGAXLVVFyKmZ2oLaRQpFlO2Gt+ABzPpjZkM/Ctnc/8mN
	 +CZ4lYoYf7qgaSVt7LSVyt8TdUAHoB8sS4TRwZ4U4WIpOrO0po4GONGt7tlCBb3kDm
	 IDzPjsvcpeaz1ADvFW7uEFdg/oWxlSJVvmV+7sHYFBeOxzrxA6GM5aKouZaVZ3pH+H
	 tlnT0YsNiM/lr9JdMptl51uMiLPZbaV5fs6je+9bcfmpVfznMWszRR7KcjAH+HOW/u
	 +cnbHEC3Oee0Q==
Message-ID: <67e1219e-9d47-4a30-a8dd-fdcf03229f58@kernel.org>
Date: Thu, 23 Jul 2026 12:22:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
 <20260722162207.31a2c491ffaf36d1e8948c14@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260722162207.31a2c491ffaf36d1e8948c14@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3810C40005
X-Stat-Signature: wfetnqef8u6dqe7abapdjb53y8x91knw
X-HE-Tag: 1784802186-513847
X-HE-Meta: U2FsdGVkX1/olQBxxgGQQV9RcTEulf3/dwM87wyVqTH9z04BybdCC85SMwsf4yjqUPBFW4eBXBQ5ag6ySgD/NFajZ1A1bHOLkbUzYhMuu7qbyzbpCzfRY1yBgxXfw877jAUOFwWceshs3nKgB3/rvqyd1NMG086uyTuOYKOrX2EICiqczy6ilpisY7CvDAx3H0+O0GvkRAKL4otUzp0azDJCrfeX44lqgog0tt+qOZVzehIww2Xa+1hKD5EUGOClJQJxA7k/aa5OhIFcNbA6M17+8rFp6cf0L2FTavYU1gG9zMEl8Z/aZspsAgLw3YwhuPicm0SC/ZNbKRmUSm81HnWjUnQW9JdM6da++phA0lt0/59dd7fPXWZZVxBjJW7+/NoyI1FPcWEL/jvHfjsIBO0z0EcO6MzRoxnqrhFbGtCS93loI1Cq1tqE5uVjPH98vQzWLizhbThv4386jiY/cI/9zY/zsB+3o2ccbTzQq1YLGb1fQBqVNbVed8bh9wLFQA3p3peVzou0GZhX2V6+d4nFXfLUx7SHIoKPm5tMI3kCwrxYMAd6yaHKRf8yKnMmQikHeDIe4r8zZdcHZG1lgoVqWWDql78u53gKAPZ76bwhRfJagAl3VlqTqQIhhxcnArkcnqgXNcj0KejsOCJq0uLlwbicmi6B99yGhQXmnd+GMv+nW1Onm8JYGWGM3xt69M621n2Bsq6CQmXggU1EnvG+jE03maNS5+If1LKOO6izj8+iFgxN9uaCgBuU/IBPDNf7Ugfo6/jGtRl1/cQEB4b9pNbkRUo5s3NhZGR9pGQCdH1C3ubvH+5wEz8TGAE7L4gua5cm+nCjdmQVHxAmwrJIMPeARvxLudkC8CG9XM/HTpfpNdY0ia6YaT0QF7lPoIxPPjJbILs3sOONV1KXisCG3I+sBQw0/LLFVWXACJ3uAANmxEz+RAOTngw/UHFnVo43yosxg1+EFaWoTAM
 GqfwrSvy
 TkM+NHrW8C6QGYpYizsOeq6vNDrUH5x37ijyeAODuN9bLjzYvsfrklSbl2V1I6w3IvzTOBpESJTvjtwPgqcmUczOEcjS8sV5XSqIAejhbYSpte4fwybsLLU9jeXLIeFfz9eaI74B+UngnWOuO4Hf9NjwyMIVpHhZSQgZD3CZRFVDeCGZfXqH3f9epyR+qOqMRIJOrLOBBdkHmIs9bWzHWb1Q4cU9rDGYjpkBYVw3gN1Cc1BSTN7t0RQAZnyKo4Ok7XCC/YycNRC5f1gb/OnBRyDGaxaqGBBMh3OvjkummG1jJz776EcU4LTVdzdKY9W8ntMgoNIgOt/wWT4aPd9FQsP7neyg/bibNnho36BiTXmTluLhzB4KycX23ReCN58waHCiqWaZI4KEWnQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ Greg and Sasha

On 7/23/26 01:22, Andrew Morton wrote:
> On Wed, 22 Jul 2026 10:56:47 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
>> 
>> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> This cc:stable fix doesn't apply to current mainline because the
> preceding non-cc:stable patches get in the way.
> 
> This means that the -stable maintainers will have to ask you to redo
> the fix to make it backportable.  And you'll then be preparing a patch
> which hasn't had standalone testing in mainline.  All very cumbersome.

Or they backport the whole series, even if only 4/4 has a Fixes: tag.

> So is it practical to make the fix come first, as a cc:stable hotfix so
> we can upstream the other patches in the next merge window?

I think it can't come first, it's simply a complex fix that can't be done in
a single patch that would be reviewable. 3/4 is certainly a strict
dependency. I'm not sure if 2/4 as well. Perhaps 2/4 does deserve a Fixes:
tag and Cc: stable on its own, as it also fixes a defrag_mode deficiency.

> (An alternative would be to put cc:stable on all four patches.  That's
> a bit abusive but we do it rarely).

I don't think it's necessary, the stable team are quite capable of figuring
out the deps and backporting them with a Stable-dep-off: tag. IIRC the
"fake" tagging is discouraged? Maybe they can clarify.

> Either way, I'll get these into mm.git for testing while we await
> review on [4/4], thanks.
> 


