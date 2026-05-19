Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A00CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7118A6B0005; Tue, 19 May 2026 05:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1446B0088; Tue, 19 May 2026 05:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B03E6B008C; Tue, 19 May 2026 05:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 491636B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:03:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E28AA160155
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:03:25 +0000 (UTC)
X-FDA: 84783580770.04.4E97F4D
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13F46C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:03:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2MK6leB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779181404; a=rsa-sha256;
	cv=none;
	b=7u0EwEzAkGrdD+U+F/RdEAJFh3mpTDjiRyzScHiTr9uC8yDM/yk0WJPLL9N+5B2cyXuToC
	IrhD3p/zalqVwXJjj0gwVmIXEct+1fRJ3j98jBLpvHdn1Xt/oXObDHLGhJTyW3/V9ODZx6
	NYctoJ0n2Mujk19BXO4dSUw0Tvrivto=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k2MK6leB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of william.kucharski@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779181404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSOauER5MyHXpewQdXwKYI24deSOfI/F1xxDMDHNKVI=;
	b=UbACLaoFKUiXWqlfrK7vDk0FWTBUrvkmUjMkej4/2hRlm2jzxPD/bQ692kvNtEfHBdhGhx
	ocAs6zu9ZhxdkRLppKn+o/IJ6xgv+5nQASp+yOGJ9oaY/y5LJSFOXEMXym8AYdAv11BL6Z
	nbTBUKnR6eNiuUZVAA8QKaOoaD5JCyg=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779181394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSOauER5MyHXpewQdXwKYI24deSOfI/F1xxDMDHNKVI=;
	b=k2MK6leBsGW1qoC6eU1zCnoqGY2YmHYRFkY3okuhRQDxBYT0wkz2qYLCOB0Yw6DijQlgXj
	w0yKtQFaSUsGru9C6ZugTi1cNOnUHEo7wfvVP/NCc3c4A7w2KG4Y+4j7gh7yauLBXCoZ/7
	0J8LLapTCDJP9y2SrbaCLE89k7V/1Fg=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2] mm: do not install PMD mappings when handling a COW
 fault
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <a3c8038a-43e9-4427-92dd-8fed619001e8@huaweicloud.com>
Date: Tue, 19 May 2026 03:02:54 -0600
Cc: linux-mm@kvack.org,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 david@redhat.com,
 yi.zhang@huawei.com,
 karol.wachowski@linux.intel.com,
 wangkefeng.wang@huawei.com,
 yangerkun@huawei.com,
 liuyongqiang13@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2381B9B8-FD4D-48FE-BBF3-00D3455A8197@linux.dev>
References: <20251024102237.3332200-1-yi.zhang@huaweicloud.com>
 <a3c8038a-43e9-4427-92dd-8fed619001e8@huaweicloud.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: krnuiu7g9rxmxsmd3s1kcfue8zmkt8m7
X-Rspam-User: 
X-Rspamd-Queue-Id: 13F46C0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1779181403-259315
X-HE-Meta: U2FsdGVkX18txRvYsuFhMrZEKLEp/6+KV1x4qhY2j1pWdG3INIQcmaij/DnVlqf5HfqDjONo6rgnJEewUxVAoixlJSluA/51LrL0M3q5cjwR3TSLG6EZHrJaw4GCh4ym1+vKtMX6+MeWGTJzu8BcEO9aZ1yZDEM+VSic20EOFTVOpkYtzw/thXV/j2DEFkmRcQiouE0Ieu8QxgId5NazRXwyyzwtEjV9T29JxL3SGV5RB6oJM/sMVBOMddGhMtCnqTmCIjtxyp/MucyX3U2SBtOig9WB7lgrUfzZjAg36OJRcjGLYptyygakszxu7Zv0QxWaR1te5J4ofAb/HjNYF2RO+v9WO7zj4rniZAuHYMO5qG833e1slz/zqUCK3s4DP8xMYSXtaq9hAy9UVC5TuXZzFpzreo3EXifDGunY+uA4zvEElwOzLavm0B3fY//UWiX6k9V29l6Hov6GqCErlEMTde8fBWWQ6dR1g7X/FUNPhd3OT+1GMSrQPfi20Lq2RD2AkbMNCsrBOvz0/m2mruxts9krBNE0hYzd4+nMkJBR1yj7iSvA9CZpGlUAzuIjlX6dR18KzLsPiR+LIQCNtXRc9glfbzZKwbC0F3UXmVEV+S4Vm7tfafcgUKXIXB8Ip3mfoPkGbCaPRY0Jf5FLQuXwtPlriYoVwY1C4iN6/5CUvZKjgmm2oht9vb9KRZCezOUIAAKFinr6jEByAQ4G6bR/FB5TSOt4oDcEIJhQ6zDARaG/AkBasYEN9J5OSTyN8M4zvN0BlOftwezjDyNfzYNDHNi4P9KReHVz21/7j0oXQWkwfMocMatsG4bPd0U8J/uifFtpm0PSTJJFBU0Y6Dm+w8Fcy8V0HXaG5UIYuUJ8mKZjnY4bqnmk06Y5yrEOb31dvafEmTRqhMWQYWgkPdVB53omuFH071NlvfrlFmiohAJG6QNCLeyHPl7RGbsxmvwdzZZF54i1lt8bBEe
 PN2r4lxP
 xXrblIDRgCWnjfEfC8cRvc2OoQe9IhbmGoVQCnkxGR1X+iuzPpVZMEWqT5OyBwbnpIHYWDbjAVPd5PtHfTUzKcSQrbz/odef5TzSk5PQnPokqh4hJMHm47b3oeqjE7zNQgXkN2GqVnCBwQN+nO7/Q3+2s6PpSW6Mmh++qRCv4Kbzxh9XS68iQfMvK/Jf4hAFSxuqU23EqfomgWDHeI82gi1xoKKmmoABjQrZvtrYdy1Pe4fU2qto1gThjybFsIm3smK9A7fTu5Kvoc/BwAt2gwevDfyrDat5eg/YZBzlZy0Og4GxEo0MQC+XBqvJzIc6zQVZ1rOFnbHLOyBLtmgKVuHPiuaQyzN0VWPGm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 19, 2026, at 02:36, Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>=20
> Gentle ping =E2=80=93 could anyone take this patch?
>=20
> Thanks,
> Yi.

Could you update the comment to clarify why you shouldn't install PMD =
mappings
while doing CoW rather than just state it should never be done?

>=20
> On 10/24/2025 6:22 PM, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>=20
>> When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
>> (2MB on x86) large folio follow_page_mask() failed to obtain a valid
>> anonymous page, resulting in an infinite loop issue. The specific
>> triggering process is as follows:
>>=20
>> 1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
>>   has a 2MB large folio installed in the page cache.
>>=20
>>   addr =3D mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, =
0);
>>=20
>> 2. The kernel driver pass this mapped address to =
pin_user_pages_fast()
>>   in FOLL_LONGTERM mode.
>>=20
>>   pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);
>>=20
>>  ->  pin_user_pages_fast()
>>  |   gup_fast_fallback()
>>  |    __gup_longterm_locked()
>>  |     __get_user_pages_locked()
>>  |      __get_user_pages()
>>  |       follow_page_mask()
>>  |        follow_p4d_mask()
>>  |         follow_pud_mask()
>>  |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
>>  |                            //huge PMD is installed. This is normal
>>  |                            //in the first round, but it shouldn't
>>  |                            //happen in the second round.
>>  |           follow_huge_pmd() //require an anonymous page
>>  |            return -EMLINK;
>>  |   faultin_page()
>>  |    handle_mm_fault()
>>  |     wp_huge_pmd() //remove PMD and fall back to PTE
>>  |     handle_pte_fault()
>>  |      do_pte_missing()
>>  |       do_fault()
>>  |        do_read_fault() //FAULT_FLAG_WRITE is not set
>>  |         finish_fault()
>>  |          do_set_pmd() //install a huge PMD again, this is wrong!!!
>>  |      do_wp_page() //create private anonymous pages
>>  <-    goto retry;
>>=20
>> Due to an incorrectly large PMD set in do_read_fault(),
>> follow_pmd_mask() always returns -EMLINK, causing an infinite loop.
>>=20
>> David pointed out that we can preallocate a page table and remap the =
PMD
>> to be mapped by a PTE table in wp_huge_pmd() in the future. But now =
we
>> can avoid this issue by not installing PMD mappings when handling a =
COW
>> and unshare fault in do_set_pmd().
>>=20
>> Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when =
R/O-pinning a possibly shared anonymous page")
>> Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
>> Closes: =
https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@li=
nux.intel.com/
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> ---
>> mm/memory.c | 5 +++++
>> 1 file changed, 5 insertions(+)
>>=20
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 0ba4f6b71847..0748a31367df 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5212,6 +5212,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, =
struct folio *folio, struct page *pa
>> if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>> return ret;
>>=20
>> + /* We're about to trigger CoW, so never map it through a PMD. */
>> + if (is_cow_mapping(vma->vm_flags) &&
>> +    (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
>> + return ret;
>> +
>> if (folio_order(folio) !=3D HPAGE_PMD_ORDER)
>> return ret;
>> page =3D &folio->page;
>=20
>=20


