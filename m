Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F03CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D402D6B0093; Thu, 11 Jun 2026 07:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF00A6B0095; Thu, 11 Jun 2026 07:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D4A6B0099; Thu, 11 Jun 2026 07:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFE1B6B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:29:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 772C18F405
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:29:30 +0000 (UTC)
X-FDA: 84867411300.15.F5B6A4B
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7AF8710000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:29:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O+VfhrCM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KD5qlvuzor2NppjwzPy6wAZfmryDMLk9wvmW4Ku/6Og=;
	b=6n89X/dxEW9G5aLhVPSNRFCwXlx5JRYu+Int5y+rkB9CRTlhoTdhuFsXxA5hYOtNj+2bK3
	S5PgFJKea4gKk80GdXWs7TnlNzaK9ecFM1M0Nau7ssovFrgvndKoqSONI3Xw4nQX5HbBFQ
	vGSXRgg034INdDdVnUqTShTPl5wDFR4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=O+VfhrCM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177368;
	b=DYRu0xiACq99xX0Loj+qEmc7s82Eyn0w36WIP6EBOmQbzXMWMZ17D2kzcdIkJZWfj6ZY/b
	ZAtP/Cyas639qI/LJVKbarS7WsdTCA0OzVBsmUhH5n173mhZOgUge0c9a/1n3UyTttUefR
	kH2ylKOICY7FcPIXqhBMmEVsF504FQo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781177363; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KD5qlvuzor2NppjwzPy6wAZfmryDMLk9wvmW4Ku/6Og=;
	b=O+VfhrCMHkw6OraGBBWRw3AyBUJALmcGlVI3pLbN+Jj/WWNB0qHmYH4CxXYQKlMCzDHrog8PODgyFhJF42KD0UuSOxfmuqLA9uAqsY4J8sGwUUFKRmFvLcUy6VSoMmML+8t0wsD9HoStpLzKqIo9gmZz2ZRRNYPeD5dzBxWJTMQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4dWSlL_1781177362;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4dWSlL_1781177362 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 19:29:23 +0800
Message-ID: <0f4d30db-d9f9-4598-8bc8-328b48ca017a@linux.alibaba.com>
Date: Thu, 11 Jun 2026 19:29:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 07/11] mm: khugepaged: skip large folios that don't
 need to be collapsed
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <9e05e5ca589e1156f75078951efe874118f88587.1781083630.git.baolin.wang@linux.alibaba.com>
 <20260611045925.36457-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260611045925.36457-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7AF8710000E
X-Rspam-User: 
X-Stat-Signature: 365z7y55c35a17bzeratrbn696apgemi
X-Rspamd-Server: rspam09
X-HE-Tag: 1781177366-487596
X-HE-Meta: U2FsdGVkX18UkJeovjdemMyeWe/JJpSj4G0EoCChF00lljNtiZDTZmkj9i3vXjqbi0L5domCN8AQKpbM6+798Sx09P0GlXL8dn4hP926rPqQXRG6tEcrmGLE/TFYWMeMz1+PzerIE9lqmMSiaoKCNW0DZifoPA1Gz58oG984AeA6IY4couyt7U+7TA0fIZT0dU7Oju/349ty8HLgNipenpShqRtCgvJw86sDurNm0dEvZBgaFYGbaDgJsaDJwqXniH0VdxlWYqdBSsjio3Ck+Sfrem+/BJFwqrWeav9vJKl9gGM2eNVGhsKhmPZx/QyDg2Z6W2Ld4oGvVJIq/U/8PSQ9pmVvaijJxrG0GFlTLqJggLcCd3+U26ZaynkyR5UN0V/IgDMYLwmudAlk3ofurWFxPFuabZfVBmTEOKnZdcFlnudgACgksfod0+p7MY0sxcfP+cZg2FqhBd6XEpjJ3RiBoRdLRIXi9Ln8l2//6W28gcb/6VKzOdJowp8AjEG8OVjWapaXB3kPEoHu0Erg9FfysITy2M9q3oVvqDJCe5YYhZLxg5QUoYwWUQRcjGZAAY/mHoCc2VUasTqPLcBhA2bbH5HQtbgXHcr51jbAIRWBDeSR6Rf6pd1XZQybw/O3MSBgLIwHwerS6LdLwH+UJiCXJlqU0rhsKSR/8qrY5waQMGg/vgIRNg57jfAZkodUxjAeEixDzpkE2Lwpjr6OcCHgcVhSbX0VarnfaRyERRqic7whxKuSXm+qiqgzAzqrCGXgkEPdgR0Xuo/l3P14Q/NlINSIFe5hdObeMjYFt7S10+2vDrAVtPhdmhVTuXJXLOxiznR0S22Gmp1dXxa/rn5ZeS5CivvDoUk/SVCPZWueWqgCE5zjw0zaZo+u43cwz21nM5y7HO6QKaOro+2LxD0t2pUVWArt6EO7tuq8SACbPiP9E5iSWbADm/SvN+Bz2hO/ZO7/xKcJwxaE3MC
 jph3pZsy
 oJaJNv9k5ocFmSAD/G69HUgf7lUy+2vzInkOEYGO80ZILvsynpV6w7BSVnzlINqAYHp4KoH8UURi6/dIYZIHv8exB1qmrS81/RPvBsu21z9NOd8qhsTJJ3tu+nw7PSVKJCbI7jrTBLPlnRpDld7wcMrZPT3r+aS8r9tvp2aFBokF3xYy/dmhFpxVdh1G0BA8R70QT9Uv5TMUn1v3KuBZArGud4AlZQ5gwIdO5W9nZlJNIWSUbHc+gvJwVnuj39Ky+ztMEpifRUCAEHmGhMWWxVBogBfzB7s8pYL2PAfNrqc3Sz2z0geuBbPy6lZzjztpd5SD1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/11/26 12:59 PM, Lance Yang wrote:
> 
> On Wed, Jun 10, 2026 at 06:29:15PM +0800, Baolin Wang wrote:
> [...]
>> @@ -2843,6 +2853,11 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>> 		goto out;
>> 	}
>>
>> +	if (bitmap_empty(cc->mthp_present_ptes, MAX_PTRS_PER_PTE)) {
>> +		result = SCAN_FAIL;
>> +		goto out;
>> +	}
> 
> This check seems to jump the gun a bit for MADV_COLLAPSE ...
> 
> shmem swap entries only bump "swap" during the scan in
> collapse_scan_file():
> 
> 		if (xa_is_value(folio)) {
> 			swap += 1 << xas_get_order(&xas);
> 			if (swap > max_ptes_swap) {
> 				result = SCAN_EXCEED_SWAP_PTE;
> 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> 				break;
> 			}
> 			continue;
> 		}
> 
> Holes don't set the bitmap either. They just show up later through the
> "present" check:
> 
> 	if (present < HPAGE_PMD_NR - max_ptes_none) {
> 		result = SCAN_EXCEED_NONE_PTE;
> 		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> 		count_mthp_stat(HPAGE_PMD_ORDER,
> 				MTHP_STAT_COLLAPSE_EXCEED_NONE);
> 		goto out;
> 	}
> 
> For MADV_COLLAPSE, both max_ptes_none and max_ptes_swap are HPAGE_PMD_NR,
> so those checks still let this through.
> 
> So now we bail with SCAN_FAIL before collapse_file() ever sees the case,
> even though that code still handles both: swap via shmem_get_folio(),
> holes via nr_none.
> 
> Am I reading that right? If so, looks like a regression ...

Thanks for pointing this out. I think I should add a 'cc->is_khugepaged' 
check.

if (cc->is_khugepaged && bitmap_empty(cc->mthp_present_ptes, 
MAX_PTRS_PER_PTE)) {
	......
}

