Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699D6FCC9DB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B006B008A; Tue, 10 Mar 2026 04:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29486B008C; Tue, 10 Mar 2026 04:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55716B0092; Tue, 10 Mar 2026 04:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 926046B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:47:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57F5E1C044
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:47:12 +0000 (UTC)
X-FDA: 84529523904.03.2E13D9C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2D86100006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:47:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773132430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n9aBm11mMxtDbOS9OktwbhcCey+gROdEwKJW/GQ9uBY=;
	b=a/XYSdVnrZZP4izkuNA0fpfX8UNOs2cqB49ishfiZd7UvZ7hA3+nTBxAY8KrK6KlyAbPnJ
	TckB/fxHcPwSNDGxs5N4BaG6miGPVCjfnSlYodeQlBCUhz8wCYSbGjPBsgSKAaXOtbUb2n
	GscMrpBvARtxa0aGcwtunO/K3cCxtFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773132430; a=rsa-sha256;
	cv=none;
	b=qxZmHtlpaRb1YGWjM+LHyB+HCcCvNVAZaLG/KhKE2CCSTsjrrs0FXbJPSiyYo/gUWGTCA3
	0IpNzSHD+bR6SNPzUG9vL1onm0R/X5lWf+JqxRAkoflfPqZjQD0WCM8DLZOwnVxfVBkQMD
	958dvwDLBh6dqhzBK9uftMhIci5J/Sg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFD63169C;
	Tue, 10 Mar 2026 01:47:03 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1E0C03F7BD;
	Tue, 10 Mar 2026 01:47:01 -0700 (PDT)
Message-ID: <959607a5-4112-47da-95fb-6388d96af5e7@arm.com>
Date: Tue, 10 Mar 2026 14:16:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 david@kernel.org, hughd@google.com, chrisl@kernel.org, weixugc@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com,
 jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
 willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-7-dev.jain@arm.com>
 <CAMgjq7A1QX2s52aQKQcg0vFAK2t2Xsh8S0THdUC9t9r=DEUQrw@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAMgjq7A1QX2s52aQKQcg0vFAK2t2Xsh8S0THdUC9t9r=DEUQrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2D86100006
X-Stat-Signature: s7y87iq6uob3rrzgozdqffupm9t4ffgj
X-HE-Tag: 1773132430-594976
X-HE-Meta: U2FsdGVkX19fg3KqTjF1jb6a5Xuq9JFpkpRzfT/efCnUbtpIET6H9haW6d7vk06HjY0D+Ry9UnQ5+UThxxGM1E2oxG72rA2XCw7T/4Nad1JeIP4BPINSPlE0IY78o9c8r3x5mhYq9BbplvTVetke9yGMJbBfKWSv2b3sCr2LW88G58OQZDja5Bfd6ISqvTajAE8jz8+zOcvPhy/H1rIi+gLKNyurTTXr1C6pzXRmJg3itcrmspb4TDJihm3AtDNgMjVrmaxQQ5eEpYZwJZOxgVjtaU8mjAqHyLcxTHZFm5bjoT02qS1ozZdLgFrW5LR+OnCIwvy/LfCHyMxAiACgeOidgTHEi+shEFZvIg/5SHbaFFj7RW2o6gFwB9qFVRE+wYXqtdL4Jt+LtgVxSMH9wj4EDKO6GRneYZzzFOzaSofKV3x4y6RI0fOJr8rqCoh7pifEHhCklUjJEdEBS2DMBU5YLASaJL6IVY8qRa1xK36nV4Z6utzcbRhzI8ch/urgXnb0JIOefpDPoELSDetm20pnPOZ2KmrD0ePANhP9608MEEzrIdUa3TmqVhfGILIb/Xeo0k50T3G5gRxA3acmMwOX4VImS75x6CAec4icQ7eCL9HxqrMoxm7CAHJYF0nTL2tFCt+WDwUpuOr6us9id5nhYDe1n3dQRWvg/bg6wuQyhuyjh36Zsfna/0D/Y0XXv9vd2YHgHd9ZqaO8wD2hGlUJJXzThS1XQW21Az349fhsNrimkHNjEJjYqGuqGaLux1YGwirTDehYqpKX6j995CdonDqtO0gtbtek8a5GWb/I9nTQWx5LSeORMruKLZ448b7yOHzG9OhEzivL1U2AVGHYtO6Cl1OLbIe256Frbk2XJ1+SlTzdi/GVTjMzZTXw89hDOFfUrZMasjY3ugP5qwc9IsUyJTL5oO95kRLdHRdkVAjvYX1+u6HC1D40qWQoFGhEP6sHpXU9Bi/iGZw
 5RpeQA5Y
 JU+dbUqGG5q8+OtULOdPjLGSY74zC71fR3VTqv4Mych0CvOq/YsedLLy2MBOID2pnI9EgWGLCxY+D6dZKpjp5KjCXCQTlARBIwpyKNvNC8qaZLBsESp/S5ksi81HXmo9LZaUopxX8fvrwqSu7AsqghKvKHQLWjSK4k9OYr40230aeR/D+YXDg8WIiE9syChACLCjCNWuvBkJ62UCU5eDMAJ3OZ9FUki9SjbXMrm6CKOx1424xJZJlrGBJD/hNcZILljRQYVonoUtqX5tQqEydgWUuZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 1:57 pm, Kairui Song wrote:
> On Tue, Mar 10, 2026 at 3:36 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> Teach folio_dup_swap to handle a batch of consecutive pages. Note that
>> folio_dup_swap already can handle a subset of this: nr_pages == 1 and
>> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> 
> Thanks a lot for doing this. I was thinking it's about time we respin
> the batch unmapping of anon folios idea. Barry tried that before with
> an RFC, and now batching from swap side is easier, so some parts can
> be done cleaner.
> 
>> Currently we have a not-so-nice logic of passing in subpage == NULL if
>> we mean to exercise the logic on the entire folio, and subpage != NULL if
>> we want to exercise the logic on only that subpage. Remove this
>> indirection, and explicitly pass subpage != NULL, and the number of
>> pages required.
> 
> I was hoping most callers will just use the whole folio, but after
> checking your code, yeah, using explicit subpage and nr does fit the
> other parts better.
> 
>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>> index 915bc93964dbd..eaf61ae6c3817 100644
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -1738,7 +1738,8 @@ int folio_alloc_swap(struct folio *folio)
>>  /**
>>   * folio_dup_swap() - Increase swap count of swap entries of a folio.
>>   * @folio: folio with swap entries bounded.
>> - * @subpage: if not NULL, only increase the swap count of this subpage.
>> + * @subpage: Increase the swap count of this subpage till nr number of
>> + * pages forward.
> 
> The new nr_pages parameter isn't documented in the kernel-doc comment?

Oops, will add this in v2, thanks.


