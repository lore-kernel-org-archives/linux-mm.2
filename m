Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73812C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E836B00B4; Fri,  3 Jul 2026 04:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D00F6B00B5; Fri,  3 Jul 2026 04:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE7A6B00B6; Fri,  3 Jul 2026 04:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B05D6B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:46:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89B884048B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:46:03 +0000 (UTC)
X-FDA: 84946833006.13.E0D4EBD
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F43D100007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:46:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2BBHDf7;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783068361;
	b=q9LXSd2n8cTUJTjGXsPbo9owoxRsaArcaz2lSyj9a7Y6YLhoQd73psV/+rdmRHP9Wn9Ojt
	wbM+hz1V/jGlaDkkVgXaYEx37x2s1NI1+0w+xFwJU5os2e5g1CnJUYtPp1Ggm0IM9NEBkq
	nJI6eAMx8Qt3UkmmiVP3IwzMb23ETP0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783068361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60Vpn3H5TSaITeEafUCSZSGw+JUZcFB/W7NF3CJRJro=;
	b=4TKZg++m5CiKFuQOlLCOHSE90m0UuQR8RVgUl0ldNoOc4vXK/L5+jkQ6/aNSezvUxhPvvU
	tgzMXngjB9jAzpkxMZSEjZ9IzdqaMUCxKhKQbZGyW/VP1GSFzpWhrrnopYmOFZwfcdkAlY
	J5LsZYi8+6Fdyh/WAQdq8RJCQci99ZY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2BBHDf7;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <6a547571-e60e-4b36-9968-011e3d880588@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783068359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=60Vpn3H5TSaITeEafUCSZSGw+JUZcFB/W7NF3CJRJro=;
	b=S2BBHDf73puw0tKBLqjZuAEU/CWtMRJAxDqfOYNqFAeo8YjKSh7dR2sR+MoWh+wM1ysj/x
	y05f5fq17vzO2zQPppAjq2CCy6FTcDHSUmRMNOfgx/4ysnNpqGIjegsfguN233t1vfPVtx
	kpopE2aCTEIKLD3MkESUBH8/cJ+luV4=
Date: Fri, 3 Jul 2026 16:45:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Content-Language: en-US
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Lorenzo Stoakes <ljs@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Song Liu <song@kernel.org>,
 Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>,
 Gregg Leventhal <gleventhal@janestreet.com>,
 David Hildenbrand <david@kernel.org>
References: <20260702165409.164568-1-pfalcato@suse.de>
 <110e92b2-f7a6-487a-94a2-25ef1242afb7@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <110e92b2-f7a6-487a-94a2-25ef1242afb7@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7F43D100007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: e7kw75ikbtx3w34odaazktj4d7d4ifi1
X-HE-Tag: 1783068361-566152
X-HE-Meta: U2FsdGVkX1+AimYgODECrsgk9HyMItcnlHrHpPcxaT9K1hXLqUaej7nMTXsdYRRpNwmnEiVD2gcyq/7P6TMrtGA96aPrm41q90YxqlW6jk2ROx6hYEHUaBqt5ENmTwdIbbRAPqsml/lC5/jNs08sGQC50l3A7iaGKijqQ+CWQRteJHO9rKtQrUMx0iZH+7B0oRV3NCVbv+Y8XUb5MCfWJvmPJAJcUcl8lxncicgbzZ3JHq1gfpXbuA0K8U7aeCDWpCrhNT76zYcRUysfqbDgcVBe2o1JBlxJ76yww4QSifQfQy3vxEv3UoBAARn8MOWe8cg6rekFZ+9RRm85S7YKCFmyyAYpvIeK1S/TFHggwzIQzZ13Wi7TJixbEIS9kcYiyfRGVrs0rm3w39Dd3o6wRd86DteM1cbwmw/c2PBBm0RH+T7Urb0eA96vQ/RXKgcO9ZifQqfGc9SeWMtFhLoFjcXgq27dTEuNF/49iFPCvbplf69MFdrgwTY9fGJsd7vT6NOuBQkJ3qUCb+WR3NycuP+eCf4m6W53k3SCAKKp8LzbadgvwjakgaFF4H04uzNAUmjcaMEF5Y1DtrlTGcIbkK36U/XrfvR9/1Dr4m1VzvOQ2pywnz90wXbfUAw7bSWmdRNm+MNRQ4DkNGyStNLQ81p2RsYkwFOzb/gEcaqptQgN4PV83klAtouT7k18oLSAuKpUZ1dDobM2KpHTci9hSrJK3qzjohgiO873gGGSdO3lhD2a8333fhFo78awrsGyPI8EQ4MIo7owk8H4ivugfQDxEdHctnsc4mPV7Gl7wlVG5aqbQ0iFAUtkGtFL0HP9OV2dKigeakEHnn5ZkO2Q1xp9sr8YvqbO5W61ZuT/McLOP+iRCzHX1HfaiMHxuPPajKx50oMrPwBABV3jNHQddE1cXIc75Kxj61qWRfdiILWM178Ft4Os0hiMeMyxDWVNMDEkHbDFXgfVFzcukMX
 ZLSxe4Ck
 FPjfZc1BwPQwriHCI9vdh3OP1unFH3lwoKgqAq3KRumr/NUhvFnd/HH+HLvDUSkOK4OoBwzNYTcsT8EEHBSshI1i7V/7z8iYFcP2FdbXQXQFpBxNU6D2u6cCfbMs1U+bp6Xd7ZluWJJ2h7SkctE9R8us7p2CzknA2ibRp82WB3FBwPDfir0hfPGFcKvHnsmx9FZZPQJ/1r3FwZAQ0sA7SxWA8aqjzJYBSG0mJyt1fwNnotRK/vyD1cJAJN7t1juQ0XoxxQLczPIY4fyeuk0Kt64maClsXKndE8X3DhvuWBbUW6lJfLIxynrskrEpah58W3mgf7T76IsnQciB1gThj4Qhem4qTYHBXBt0y7PG2gRybK8SqFxC5v/tazJ0DIXF3mJTzrzfiw1wkTFkjF1MwAymD3Hq8Qt2t5piFb0vvbeOSCYQF2lo3xfMbOi5HoLy3N4XAZt5KUWha9v9dgRIMj7t4Zipy+icz6tRQe7A54142fcM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/3 11:49, Baolin Wang wrote:
> 
> 
> On 7/3/26 12:54 AM, Pedro Falcato wrote:
>> As-is, khugepaged and writable-file opening exclude each other. A file
>> cannot be open writeable and have THPs (because the filesystem is not 
>> aware
>> of them). khugepaged will never collapse file pages for files that are
>> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
>> particular file is dropped. This is fine because nothing could've been
>> dirtied.
>>
>> However, there is an edge-case: collapse_file() might not be able to
>> coexist with concurrent writers, but it can coexist with dirty folios
>> (from previous writers). Therefore, the following can happen:
>>
>> open(file, O_RDWR)
>> write(file)
>> close(file)
>> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
>> open(file, O_RDWR)
>>   nr_thps > 0
>>    truncate_inode_pages()
>>      /* THPs are cleared out, but so are the dirty folios */
>>
>> When this edge-case happens, there is data loss, as the dirty folios are
>> fully discarded.
>>
>> Fix it by fully writing back the page cache (and waiting) when collapsing
>> file THPs. Doing so provides the guarantee that no dirty folio will be
>> observed while there are active THPs. To fully ensure this is safe, the
>> invalidate_lock needs to be held while doing the writeout, so that
>> do_dentry_open()'s page cache truncation excludes this write-and-wait.
> 
> Thanks for explaining the race, and it looks reasonable to me. One nit 
> below.
> 
>> Cc: stable@vger.kernel.org
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Song Liu <song@kernel.org>
>> Cc: Eric Hagberg <ehagberg@janestreet.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non- 
>> shmem) FS")
>> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
>> Closes: https://lore.kernel.org/linux-mm/ 
>> CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
>> Tested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>> ---
>> This patch is written against 7.1.0 (because the code no longer exists 
>> in mainline).
>>
>> Zi, I kept your Tested-by, but I had to move some things around and
>> use the invalidate lock. Please re-test if you can.
>>
>>   mm/khugepaged.c | 39 +++++++++++++++++++++++++--------------
>>   1 file changed, 25 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..0707d719a270 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct 
>> mm_struct *mm, unsigned long addr,
>>           goto xa_unlocked;
>>       }
>> -    if (!is_shmem) {
>> +xa_locked:
>> +    xas_unlock_irq(&xas);
>> +xa_unlocked:
>> +
>> +    /*
>> +     * If collapse is successful, flush must be done now before copying.
>> +     * If collapse is unsuccessful, does flush actually need to be done?
>> +     * Do it anyway, to clear the state.
>> +     */
>> +    try_to_unmap_flush();
>> +
>> +    if (result == SCAN_SUCCEED && !is_shmem) {
> 
> Actually, the operations below only for those mappings that do not 
> support large folios. For mappings with large folio support, 
> filemap_nr_thps() always returns 0, so the race described in the commit 
> message won't happen. We can add mapping_large_folio_support() here to 
> filter them out.
> 
> if (result == SCAN_SUCCEED && !is_shmem && ! 
> mapping_large_folio_support(mapping)) {
>

Right! nr_thps only gets updated when !mapping_large_folio_support(mapping).

For mappings that do support large folios, writable open won't see
nr_thps > 0, so no truncate_inode_pages() for that case :)


