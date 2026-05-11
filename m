Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 412E6CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553F46B00AE; Mon, 11 May 2026 17:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5042F6B00AF; Mon, 11 May 2026 17:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F35A6B00B0; Mon, 11 May 2026 17:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7946B00AE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:34:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC28F1C017F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:34:24 +0000 (UTC)
X-FDA: 84756442848.06.F4BA6AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2C08A20007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:34:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z5AwNJFH;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778535263; a=rsa-sha256;
	cv=none;
	b=sBkofij+bU9LFrUNS0n7iUj3gZ1LVQQmAjL/CMk9DvXsyw3LosIan3BaXk83osi4Dmexnj
	m18pjYYwADTC85f1dWd394zhA7rTlNsdk/0I4LkXcyfVKDCUPN2hhLwee7Fv5FNKAgBpyd
	ZBWfz4rFPuKlC5MWaYAhD3HPwGI6f5s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z5AwNJFH;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778535263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHK+oRThZjfzaOTF1CJQWpqSaD0CfU7oQ5Rysn1bV7E=;
	b=PKCUeZAZCgcZGtSkkbbN4dI3KyWLcjiJ4kVF+FFJuVDq7n59kZ4FPJxxQ17JmrV4SDHPB8
	aaElPWdUYNi/uNJK10vUqpJvDdgNEYAXxbai0TwqDmCuASAwkqmqTlkV8sRVAzfvPT/FIg
	nLyz2gCkqbUFoSgiUsN8KEp2agqGtAw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6333460055;
	Mon, 11 May 2026 21:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F033C2BCB0;
	Mon, 11 May 2026 21:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535262;
	bh=UqVonophyFqbSxTsEU+N90w0I2vG1qI/ghSqvSUUGSI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=z5AwNJFHumsQBI/26Qv1iSRJq+NoavFvavQK2LRR3VO3yI8ukXBvVvR+IUjvc+f5c
	 NLsmkapcJI6brRzk3jhvNyWysUuEaQ1NIN2kcVyXL2farfbpLeJB3qxyWfZtHdFkAY
	 gQ0OZAEu8/eVRmUaKxIqnTCYL7Th3e0EkfjJ8bIU=
Date: Mon, 11 May 2026 14:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>, Li Wang
 <li.wang@linux.dev>, Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Luiz Capitulino <luizcap@redhat.com>, Mark Brown
 <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>, Nico Pache
 <npache@redhat.com>, Peter Xu <peterx@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Sarthak Sharma <sarthak.sharma@arm.com>, Shuah Khan
 <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 00/55] make MM selftests more CI friendly
Message-Id: <20260511143420.b1dcf710e99baa48d1c37209@linux-foundation.org>
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i9tdcdbtre1kmc9piwcrht7tsu4zm4yy
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C08A20007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778535263-532369
X-HE-Meta: U2FsdGVkX1/Q5I7d7pj5XW+YoRgYepFVV28xvE56B5Lwt9qvjY9poG0nyaC7389Dnc3YfySfKKz2120CWsT5vyvdbobQPIXxw7jv6zIWYz4WenTsoWrIt7K5thFZ/bzsKVCCIc37vT0IKL5SVlzWYH7YoxZKgqxV4+qiIqv5dwbl7KIVWKbejYQBII1+6EL/M6yHRvM3EWgSrzQ9MJ65ECkJQ2j2TmrxovDi0WgOQQYvuMSJEFKeE8Z7ZbvRxGDBIZO9Mm5f6EAOTy287QnUv3K9bROi2E4gCNtcrWL7dfsUBoQV1OEd9iQowCmPiW9HGNbCAVhhTMJSp09p7tmOsktwfmVR3kVYkgjyT+D37O3hOmarAa9E29t0oBGWnotCmqO0SJfl5JV7LC3xdq+ajSXWdndrReW2iADURDNVOFJARPkB4nSqSiMhFOYEYikF1rpxJamkYSjUhSVFTWz66frriTbcIYnW9oFCBXwWvsisksYj7cDSWY3FrkNdb0fRpR5VBuNcRhZyece6RlRwVo4N1W8ycQ5M4UAS5CYeXO/83uAIYZKTo7w+O9qHNXsZX8Ijb8Gr6IAJKib3hR7BYq5+Mjc2tb6IewUwLOWX6Octp4D/Me/GWieqmxQQ3XMt6V8vtOa406ixVzIANM//LRevYBJnscxFT9GyZXkksU/wqMQnSoAzXtDSIqfRGPf3q9HTHcAxZzAVcOC7sC3txpcPzd688lNWW6C/iqI+Hvw4ef23Yvhc3HXrHi/XXCDoRIT+B2If+L/iQDSEOwxVo5hzYAgZZXg90shZQXkcXfeV/G3fnE1OZsyxGyQfKOQOAEydK99QChjGUGv1x90v5QawLmmISngvw1LzftuAPy5/DwLWckSRe53lwWWsnl2mtE2rV6i5WaqQHvEhk5p8RKI6AvD5KiGhNvx+Vk5HCJo6/5Nm/70091p0LuX1gxvSlLWjJTgn3p+Tlfg0t2N
 xPeHUE3L
 xodxX8umWJMEFqYoZhTcwfBry4O59UvLNclD+CpQJtnh6WZNezCdzldFdz7sjIXpkc+RZzK+pyVi2krZ5MIlpzCXVV0P7E5/AK7Vil5xHgqT2wlqlQGa6W8rQNSzr0ES7fw36dJeDm5BevKIAtcBT0S62l7mDCpvaRRyP0J05am3jjDaNCTrH1RZoklj430Ie93nYf7tjaT43JkXqtIVP/Gj/k4CK9p+ZPrQqPg2kxDQWpRAqAtTWGrjHRvInjgBOURo4e9z5ATTkf0H6sqY+5nZzVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 19:27:44 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> There's a lot of dancing around HugeTLB settings in run_vmtests.sh.
> Some test need just a few default huge pages, some require at least 256 MB, and
> some just skip lots of tests if huge pages of all supported sizes are not
> available.
> 
> The goal of this set is to make tests deal with HugeTLB setup and teardown.
> 
> There are already convenient helpers that allow easy reading and writing of
> /proc and /sysfs, so adding a few APIs that will detect and update HugeTLB
> settings shouldn't be a big deal. But these nice helpers use kselftest
> framework, and many of HugeTLB (and even THP) test don't, so as a result this
> patchset also includes a lot of churn for conversion of those tests to
> kselftest framework (patches 7-19).
> 
> @Andrew, I think it's good to go now.

OK, thanks, I've added this to mm-new.

> I'm sure Sashiko will still have somehting to say, but there is really a lot of
> room for imporvement in our selftests and with Sashiko being overly pedantic
> we'd be stuck forever.

Fair enough ;)



