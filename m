Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419C9C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5373A6B0381; Sun, 16 Aug 2026 22:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0936B0384; Sun, 16 Aug 2026 22:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A9C6B0385; Sun, 16 Aug 2026 22:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1308F6B0381
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:25:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 951CDA065C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:25:52 +0000 (UTC)
X-FDA: 85109170944.14.4AF4CCF
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf06.hostedemail.com (Postfix) with ESMTP id 91E74180004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:25:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZUMTekRC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786933551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfjW84M8GBMQrv2tnueF8p968fdREO0psJ4VmpyrVQE=;
	b=QwyRK5V1yndEf6uskL6kWYI8uElm0jvvgt6jC78RkI6UpgRaUJqt/teF+V1tq9A+eXwcBA
	+e2DV9ff3Y+z/zoFWgziPQkeChr5XF0/a1sffcMK4wAj5jeEco25k1rMh5WgphckfNotNz
	vqYDGoldd4Z2ZdJjz55maaKU5uFoqSc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZUMTekRC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786933551;
	b=eEMKSI02n7kZKLEmTZABY38hlks9T2qVBszMa4pHMpaJX7MauMmoPdTHxQ+ZlgqeT6oSKM
	mpNTZRremKnWVRaFoi5YhIvETGwwvTDgibHq2ljBSKyZC+xX1QwJxk1OYJHOEmz3FQUCrd
	9NRwRXjmFjsaXx7Re39rzyyiTpNC+W4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786933546; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WfjW84M8GBMQrv2tnueF8p968fdREO0psJ4VmpyrVQE=;
	b=ZUMTekRCWvdzHRoVvymGZUY4SSgP8ubj9z4khcUffRKeO/cAIAxKIXLr2vE2wrrcd3hhUe5UA5scn713gLitwGt3kUIkzPEXpDQecboO9+sg+tpOjSEW5EBdrTqUkFhmQLcyWRoXJqn3DuAVFvUCdpogkeUXjat0edFEJBKnY6o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X91E0N5_1786933544;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X91E0N5_1786933544 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Aug 2026 10:25:45 +0800
Message-ID: <0c4125f4-fbaa-43ad-9cc6-b9c5ae4af89f@linux.alibaba.com>
Date: Mon, 17 Aug 2026 10:25:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
To: Lance Yang <lance.yang@linux.dev>
Cc: vernon2gm@gmail.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260815174444.4164-1-lance.yang@linux.dev>
 <20260815181632.21453-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260815181632.21453-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9tkfzuujcixppagho8w475sn1spnw1g9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91E74180004
X-HE-Tag: 1786933549-349702
X-HE-Meta: U2FsdGVkX1/RPp4UGa9L0vhQTmR3CIKfHNjaf7JgTbsC4GcciNL7rtuvvuRClmWEUM3D4xnLMq3+3DZnqnD0kM46tcMUpy371x2Ni/bG77dpOC4xxYAXYohmXWQ159gYLgPtK9zSXn0ATFHmWGF9Aef7Tt8PPDMA9ZY3dUrpeUs9fpxnwdH3gYqW6R7xINvnUCDXpe5qFyVxiFeTcnGQmTzk+dWs172iMyddI/nDBRvZ/c26hHZwYhWgY/pDU6ACIHVWGYeUAuqq5B18YRJyrwS6UYLUjW99hqHh+0sYoHrl8PAu+YXL1TZ5gN7UpNJmQhAPGJqGRU3yYZny0XocXM5ADYCCVoXiG0rOO3YjW+M6zqVkQ2797SuYEtq4Z99dnWz02E+ELH9+X26EviJRR/qSlXbs+0Lv6dbwh1joHc1TrYpFU2+C4UilgFj4+n6mkXx5Miv4tKjynJzTBFXycQRGJuE/Ft5l5zvMQBimBdbY81feK/wCVck08CDmA1UWKwV85vikpzn1jZCtM45/2tjHkPCctd35SBMyD+tSwbIk2O9hRQ4mqR6CgQPaMTHW3QDbgu4q949jerlSueb/T38e/3pxUeHFr7UnPfqxKMg/7asadOMn/LdjJLRtbJ8tBfEQHfP7nP6QlAlgXlTHKg1KyuFH8XLvbax3yJeADv8cfPWclb4KwwJH4Ge9SGTR3T5LRnOOMDNOQLlhWvINC2MA8d9xFs+uX+LhGm1P/WgC8Luf7FmZ5OCEcyoZPDNOJYMTd7h/Cd274GjN4j3u77hWxa1k5LfVmrLXPz8nDDlw8ix2DmjEUXKp0+QecbxUkD895YQ1rP9zEmtC8PfFlx6QVN9cuyG6chPemIpKxVUfdCqWYH7KPSoCiqa6+1dId3iDlaDBmk1LZa1Pxr8r0UFy6O331fVWFWLr0Fr2ncERUCzT6ssv5s3GtuO9R4tCXKfBKfFyg1tY+V+1INw
 gAEFWqGc
 ws7iezlsoemu28uVIJOZIP22u7fi1xbDasHc2skS6iFe4KonRewUG3FebTBwuZelfG8mbLgiTdfKMpjGxA1syong3LeivKGVJPQ1cJGYJTDQVa7QpIsxgib8rzVuCXVvR7esWZF4TujRBACEHGeqgY0il5YJVRZOPKKECae9ISQkASwffJoetSS0rrs5yIh+AcXxx9ryvJY6pXYi6+t7bZ78OHx9eUm2Bp9cmppU2KH/9ZbIbITSMCCHgwb3CM01q+obZUGhhjC6EDKn2b2PC3OFETTNZzCsiGxdHmUeJpO5RZnYEANGEIxnRA24ggIy2I1Gj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

On 8/16/26 2:16 AM, Lance Yang wrote:
> +Cc Baolin
> 
> On Sun, Aug 16, 2026 at 01:44:44AM +0800, Lance Yang wrote:
>>
>> On Sat, Aug 15, 2026 at 01:19:21PM +0800, Vernon Yang wrote:
>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>
>>> The khugepaged tracepoints take a folio pointer and call folio_pfn(),
>>> but by then the folio may no longer be valid: freed after folio_put(),
>>> folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
>>> xarray-encoded swap entry. On classic SPARSEMEM, dereferencing it oopses
>>> khugepaged as soon as the trace event is enabled; on other memory models
>>> it merely prints a bogus pfn.
>>>
>>> Pass the pfn to the tracepoints directly, captured while the folio is
>>> still pinned, closing the use-after-free windows in
>>> mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
>>> mm_khugepaged_collapse_file().
>>
>> Well spotted!
>>
>> Gave the series a run on x86_64 (KVM), all good (only classic SPARSEMEM
>> untested) :)
> 
> Hmm ... stumbled over something else while testing this ...
> 
> With tmpfs mounted huge=advise, one MADV_HUGEPAGE isn't enough to get
> an unregistered mm onto khugepaged's list. Do it twice, and khugepaged
> starts scanning right away.
> 
> The pending flags make it into khugepaged just fine:
> 
> int hugepage_madvise(struct vm_area_struct *vma,
> 		     vm_flags_t *vm_flags, int advice)
> {
> 	switch (advice) {
> 	case MADV_HUGEPAGE:
> 		*vm_flags &= ~VM_NOHUGEPAGE;
> 		*vm_flags |= VM_HUGEPAGE;
> ...
> 		khugepaged_enter_vma(vma, *vm_flags);
> 		break;
> ...
> 	}
> 
> 	return 0;
> }
> 
> and survive the common eligibility check:
> 
> unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> 					 vm_flags_t vm_flags,
> 					 enum tva_type type,
> 					 unsigned long orders)
> {
> ...
> 	/*
> 	 * Enabled via shmem mount options or sysfs settings.
> 	 * Must be done before hugepage flags check since shmem has its
> 	 * own flags.
> 	 */
> 	if (!in_pf && shmem_file(vma->vm_file))
> 		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
> 						   vma, vma_start_pgoff(vma), 0,
> 						   forced_collapse);
> ...
> }
> 
> But then the shmem helper reads them back from the VMA:
> 
> unsigned long shmem_allowable_huge_orders(struct inode *inode,
> 				struct vm_area_struct *vma, pgoff_t index,
> 				loff_t write_end, bool shmem_huge_force)
> {
> ...
> 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
> ...
> }
> 
> At that point vma->vm_flags still has the old value, so huge=advise
> quietly gives us no allowable order.
> 
> First madvise still succeeds, of course. The second one works because it
> finds VM_HUGEPAGE already installed by the first call.
> 
> Looked at history too ... we've been here before. 2cf1338454a8 ("mm: fix
> khugepaged with shmem_enabled=advise") fixed this exact ordering bug and
> tagged cd89fb065099 as the culprit. Then 6beeab870e70 was meant to be
> "No functional changes", but moving shmem_huge_global_enabled() into
> shmem_allowable_huge_orders() seems to have wired the stale vma->vm_flags
> read back in.
> 
> So AFAICT, this regressed in v6.12 with 6beeab870e70.
> 
> @Baolin, does that ring a bell? Any reason shmem_allowable_huge_orders()
> can't just take the pending vm_flags as well?

Good catch. Sorry for my mistake. Would you like to send a fix? 
Otherwise, I can fix it. Thanks for your report and analysis.

