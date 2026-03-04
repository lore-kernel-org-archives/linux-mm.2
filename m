Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE4EEB7ED8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396956B0089; Wed,  4 Mar 2026 06:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3448B6B008A; Wed,  4 Mar 2026 06:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250976B008C; Wed,  4 Mar 2026 06:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 117C46B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:56:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5B351C6FB
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:56:09 +0000 (UTC)
X-FDA: 84508227258.23.C92C23C
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9C9AEC0003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:56:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cKcOQ1qd;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772625368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GSFW9HWutiyPhp3WzVGPO7yi4M3/V6mlTS86vxN+yo=;
	b=Sclm7mYXZ1PLzP9E8SkKXM7NWybyEgDGryKIRFQI5p7NFqNi2O/GrlfmL3omzWGMdY5jPq
	aVxtr7dTt2MmX0lwylK1ZYMPJMC3Ac73IXM5nJeokTPtNHmdzUPvk7uViUoLJSTxqoxFZJ
	ezm7I8GvvfuV3YanozKfhR+xsasxQGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772625368; a=rsa-sha256;
	cv=none;
	b=61+EGMwcgvzJGu0PuHNXrmXeQ9DpOp8qIpgK6KpMCoo6NQ7tD+JZR2wddL4clMnP7UWB9v
	syQwZE6kZkZMkkt+TT/ngn7iJ8Let5DMCniMI04BxkWz3XzM8TQVWm6qVO6kt4R1DIhxbe
	WExu4NoM3RJ7wWgy98FNL4zOFQyelH4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cKcOQ1qd;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <498e94a6-08e7-42dc-81e9-113265bf3cff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772625364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GSFW9HWutiyPhp3WzVGPO7yi4M3/V6mlTS86vxN+yo=;
	b=cKcOQ1qdVvdnQejcmemBI4Pq3qOY5VnVc9kwe4KNTg0wcqUPZFubgLA+UZ+vtrX4xkvo9N
	0LseiTbrMFJEX6nLoxhpStCE8IXpZXBTvgwWs/UtvTWYbzeBgnEsX6Hj6op/UWLNSEvgpZ
	/TOscOWi9uf7M4MNwUTzadtAmjmzgqo=
Date: Wed, 4 Mar 2026 14:55:55 +0300
MIME-Version: 1.0
Subject: Re: [RFC v2 12/21] mm: thp: handle split failure in device migration
Content-Language: en-GB
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org,
 fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <20260226113233.3987674-13-usama.arif@linux.dev>
 <CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C9AEC0003
X-Stat-Signature: zaccocwyw86xhi1arkpxwfxc3fh9n8x6
X-HE-Tag: 1772625367-1679
X-HE-Meta: U2FsdGVkX18QkdqlB3Kqc01gXqrXtRJgfW5b7N7JQrSFljFL4YYnrwvroVYv/zypagugcsnYJvD1YrnyPVX0DAEwH6Nk5FHyPMm1A7ke34MkEVI6KtARGoHos6rwRuVk4eET0G63kx+GGvOlGyWdxvwjlZaQAhcZCqOrsvIpllXotvVnspMAlJRQHgDNMY1yxYhJoWHNUWIVzRZ6nnR+k9tiwXM4Xo+41sO13ktzUCW/CXKC0viBeYaZZkOsyghxN/QMiYxYDVMFujqIkgx81r6C5OfbfU4GIbPYUma1bT4a1n+lf9B0+scEpn2WJAMVoqLhn/CM7Nj5b5l2R6bV+64E3X3JC9jTO9E5JdMVIgbi2RXy4bJ+FqS0Odnjfg8P6m/IKS4IuJl2y/mvExv6pqZ8JPVfO/5JvUe3qROUW3+B44MpHqJ88qkWzLP/NnJwLcZlm16r0zgC3ES/ldlJI3bTZ7ZdzITFca1qQUMWAKny9uC7xKxB0jZcX1vnwr1e9pWI30MTaC1aayFE0up0x791y6Px2CvFwWLARHdUmC/Y05aEMIReMvNhIQGUBCz7og7BCXKBXa9xyk/JwlDeubWKoMSh5j89fIRuRB4CcdeINei5asGj3pPUX/8t+ZrYTpKbY3ssfkwxL1AdXUx/j/aYPYk7qPp88z+fmq/6T9UaCHIEdobDP2cl2hbRH6W96AwE3T5+EIJFoaL8TkcFMjJS+GsEx+QffuGZxd1+8DuX7g8eC1wO4rKXJjSqm5rjcjJ396hOXAXJ3ucyqT1/Ip9nrMmR3s1c4NUn46I7jaPVivpynvyhY2WoXoPdSR+XZIr+1zkAnRgwAnwIJmzkCD11/I0mORT9hpI9eKVIXr5CTKwOmGn5sxROjlqIgoq3ZYmcKx8Wh5OWD4LUuRpOuzupzJe2G2bARWMF4021ZyoGh3uofgLSt5MxIlGY51UovI1tDUl5B20+ewghxil
 DzleEYVY
 UoXJY5papfvIZX1qR/W0mdq3/3/bkt2IpanEOK8807xMcK0+DDc7km+NbbApCR+TLSZxVDIZmQtQ+ccXziPYPOnvsRV3dJEwsIAyFtWcpLweSUvNSdm2MAGd9LlY77iAfmhPYLnw5FYry6KDakOEYKRNqgA0LHUclSwT204YsVW4XqBej1RqOoyptPOWIkkgHHMHE30DgKEI+k0M3WVJs4OYcKA755AL2fzANPdRvww/UxQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/03/2026 21:20, Nico Pache wrote:
> On Thu, Feb 26, 2026 at 4:34 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> Device memory migration has two call sites that split huge PMDs:
>>
>> migrate_vma_split_unmapped_folio():
>>   Called from migrate_vma_pages() when migrating a PMD-mapped THP to a
>>   destination that doesn't support compound pages.  It splits the PMD
>>   then splits the folio via folio_split_unmapped().
>>
>>   If the PMD split fails, folio_split_unmapped() would operate on an
>>   unsplit folio with inconsistent page table state.  Propagate -ENOMEM
>>   to skip this page's migration. This is safe as folio_split_unmapped
>>   failure would be propagated in a similar way.
>>
>> migrate_vma_insert_page():
>>   Called from migrate_vma_pages() when inserting a page into a VMA
>>   during migration back from device memory.  If a huge zero PMD exists
>>   at the target address, it must be split before PTE insertion.
>>
>>   If the split fails, the subsequent pte_alloc() and set_pte_at() would
>>   operate on a PMD slot still occupied by the huge zero entry.  Use
>>   goto abort, consistent with other allocation failures in this function.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/migrate_device.c | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 78c7acf024615..bc53e06fd9735 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -909,7 +909,13 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>         int ret = 0;
>>
>>         folio_get(folio);
> 
> Should we be concerned about this folio_get? Are we incrementing a
> reference that was already held if we back out of the split?
> 

Good catch! I think this bug existed even before this patch, if
folio_split_unmapped fails, the reference is still there. Let me
send an independent fix for this.

> -- Nico
> 
>> -       split_huge_pmd_address(migrate->vma, addr, true);
>> +       /*
>> +        * If PMD split fails, folio_split_unmapped would operate on an
>> +        * unsplit folio with inconsistent page table state.
>> +        */
>> +       ret = split_huge_pmd_address(migrate->vma, addr, true);
>> +       if (ret)
>> +               return ret;
>>         ret = folio_split_unmapped(folio, 0);
>>         if (ret)
>>                 return ret;

