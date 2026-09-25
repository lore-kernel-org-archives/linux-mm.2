Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED12C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 11:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502316B0088; Fri, 25 Sep 2026 07:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA356B008A; Fri, 25 Sep 2026 07:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF826B008C; Fri, 25 Sep 2026 07:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 247C86B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:09:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 975F84057B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:09:21 +0000 (UTC)
X-FDA: 85252013322.08.513DFA0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id BADEE4000A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:09:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KWg+bRtM;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790334559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9+4yAsTkCuOEMniAztosEz09F8ZlUrYk2qoqu20Ki4=;
	b=lHiI5uxmXIVsW+RRwTLiBiZGViwjUTi/z7mNtkyGon7LwoXrKVPY6wDsC5ND/FBgErKy1x
	95zz7k8UIfWR+RswKzJzCRWivtEclNG5uW1VZJ2iu1LJQukfyYNB+Z4JEYLQd5M6/BIx8y
	PMFIAoiS6YJOCJVD0yf8JqLkP4G/Txo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790334559;
	b=IgmJN+kyLIi3BwpeC/rj0VsNPVnNzOvNMuJJvdRAtGUGOEv6CcPd4kUIAIwdsJsYJKtk5G
	ulzfiK1BLQd+J5jTYRXBFb5zpU142d1LEzJVaT9ptpcMS2rkevfrdKGwiC2U0KF82gru0X
	vKAZKoF3zsvlT9uAL7PjBWdlDnxm/hM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KWg+bRtM;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15A71169C;
	Fri, 25 Sep 2026 04:09:15 -0700 (PDT)
Received: from [10.164.19.30] (unknown [10.164.19.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE76F3F86F;
	Fri, 25 Sep 2026 04:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790334558; bh=X+08JXGHDhZk6jkgj/t3kmX/ETkf/ZmKY7HfCywvC/w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KWg+bRtMjGqLoIq2HtiOXrjfQHC2zQacDtIxI3KeL3iVK4BJfstn2lrr+cgLf3Eag
	 QKYCwFFsClUn/oHUOipJJ62RqgGefgj89gJsmuewjX+MGFk89ybtuUOe2321sPOsnz
	 veaCdNDDEw0exuXjycAPli/iYr5NC3odwAerIO+E=
Message-ID: <9c00b28a-8b76-48c9-9318-cf1f4abaf944@arm.com>
Date: Fri, 25 Sep 2026 16:39:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
 davem@davemloft.net, andreas@gaisler.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 jgg@ziepe.ca, thuth@redhat.com, sparclinux@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260924131106.1730494-1-dev.jain@arm.com>
 <20260924131106.1730494-5-dev.jain@arm.com>
 <CAGsJ_4yDZypOxjwmAY_usM+v_OJahShz-_uRSAiUZUAzv14VRA@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4yDZypOxjwmAY_usM+v_OJahShz-_uRSAiUZUAzv14VRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: q4rh8djmmampfhr3kygmghfje4jjjhb8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BADEE4000A
X-HE-Tag: 1790334559-346490
X-HE-Meta: U2FsdGVkX18pm0MTpQppq9dgX5LJp1D6n9jCvtwBP1JzcEpJISW/IX/gY4Qv8nj1+D0Y4K6DGqQ+w3y8/OFgbJ7xeCc+EH9VoNCkqTrLclKIcaVjs5JcDdVb1EVVT20zeUU/ueSTBAhBuvDA1beaMxIrOcI5bTIR+UPkU7hzkELHCYsrq7zyV/8Cp9kjujpk+7reZxTL8UQOvvTy2t/Hckh7w/YYVTp7BfuqLG1YYEQibdOM10+WPdGZ+SnsezKgaIBYrV4d4hYytrImDteMASzU/x1394CNHG/miHhGONZ4Sd3VGxDTKlY4iFFP9X1LZ42LxGACoVpByyKeUrbt6Gj8EeJLFYAszi+82uEvOQOjZiPhmSPCSIlHGjY8ZDE2hZAWX8p1IY82q8SQFyUmDD3FJfEJ/JRw8BxTUCj080f8oKAQ82FLAT7FGct7g5WUi0HT5S6b6PpsCc7uA/I+bDPOzVG+1xNwgCwXojMgfbAESFNZXzSDo/tE38uj5BSn/E5q4vaGLuTbRJuXET7nUSYog7HkYbjhtd7G0NiL5lqfLVZ0xe4Lh/j6JFMocwqCI69EffAQJEaC1MLU4JxGvu/sW8U1xc6weH/oWiF47Gzlt+C6ByLDPUKwPa6UmBfS78dGu+WZ96tE5SbflUS1iaPpAlbia0GBV2Yl1OX0WlGcGodlgFHQaqqjE7Z/YN1jzosluF4LykHWwF3c+v1Qq6JelamqC1jyCEUNqpKhWxpQIYzTrMJ922NtbMlco0NjBTP7PXsozArpPLHcFN93dmoZv/eBix1XUmhpIMcDFzKmfyB4GXc6v5VAkxWqH60wX3v3q74ZCjsb2MkKuZ2xRYb5ts7qPG4I6c6G/MjbKGk1I+pG7qlxRZqa/NxGeYN8qkAMx3D/zXpEDMWVQNAE9+gR2KF2F7FpB6PWaT6DF8aPYZg2EC1L5ASxgZE4SDG6MgXwePqaCJD6XNglyUy
 oUcd6jbi
 J54lIqYjw4INUpOmWtp8IcUGry5KPFJJyWmoHm7qjXdGsba60QMPXcd1sOLVMGXkvRqXR0Y2OLzXPwx9DCV9BvoYxaAmh58JUSOYESV2e+hDTGr68meohhIQQDetfjnM2hB92cki6rXwunQaRFgynzd74bQqOLINdsyQXi5lqYDBp0Hj4qKzV+uIxUGKIBbtNyTQAbUQ3ZZ77YyT5rDl3Uq7IHZ4iv17f+xEgkecL31pZePkJ55bSZnETbeu03m0iEfanJQnAKRtrD4WrruHjXCZM0MmjlLuvR8+a4jcGfOq1RXi+FOLHe2SUmBsSW6Ubp12yPsKuPHoPKSJSv1j/tDMe7od8GLueEeEMorhQPO02bQsPij9wV1nwEW8/hQXbm3FDFGjXS7ffMvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/09/26 11:00 am, Barry Song wrote:
> On Thu, Sep 24, 2026 at 9:11 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> To enable batched unmapping of anonymous folios, we need to handle the
>> sharing of exclusive pages. Hence, a batched version of
>> folio_try_share_anon_rmap_pte is required.
>>
>> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
>> to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
>> batch of nr_pages. Refactor the function such that the clearing of the bit
>> can be done at one place without duplication.
>>
>> Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
>> from the PMD path, but currently we only clear the bit on the head page.
>> Retain this behaviour by setting nr_pages = 1 in case the caller is
>> folio_try_share_anon_rmap_pmd.
>>
>> While at it, convert nr_pages to unsigned long to future-proof from
>> overflow in case P4D-huge mappings etc get supported down the road.
>> I haven't made such a change in each function receiving nr_pages in
>> try_to_unmap_one - perhaps this can be done incrementally.
>>
>> Add two WARN's: check that the batch is entirely exclusive (for PMD
>> callers, need to check only head page), and that there are only
>> PTE/PMD paths converging into __folio_try_share_anon_rmap.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> The patch looks correct to me, but it seems a bit hard to follow
> because of the `pinnable` handling.
> 
>> ---
>>  include/linux/rmap.h | 56 ++++++++++++++++++++++++++++++--------------
>>  1 file changed, 39 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 62ef511a6175a..91b5763ef466f 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -723,17 +723,23 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
>>  }
>>
>>  static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>> -               struct page *page, int nr_pages, enum pgtable_level level)
>> +               struct page *page, unsigned long nr_pages, enum pgtable_level level)
>>  {
>> +       /* device private folios cannot get pinned via GUP. */
>> +       const bool pinnable = !folio_is_device_private(folio);
>> +
> 
> If we make a helper that does:
> 
> for (;;) {
>      ClearPageAnonExclusive(page);
>      if (--nr_pages == 0)
>                break;
>      page++;
> }
> 
> wouldn't that allow us to avoid this ugly `pinnable` variant?
> 
> Then we can make a much smaller modification, which should
> also be much easier to follow? No?

David had suggested here:

https://lore.kernel.org/all/95b8224d-3ed4-4fe3-9954-d5ba0aa373f8@kernel.org/

The argument was that the helper would have no context of the pages we are
operating on. Although you are correct that this makes the function harder
to follow.

Maybe, revert to the original function, and have this helper
folio_clear_pages_anon_exclusive, which will take the folio and do
the page_anon_exclusive_batch = nr_pages sanity check, and add
kerneldoc to it which says pages should be within folio?

The kerneldoc can be saved by calling __folio_rmap_sanity_checks in
folio_clear_pages_anon_exclusive - that will cause duplication, but
then it's all a VM_WARN_ON function so maybe we don't care?


> 
> Best Regards
> Barry


