Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9E5CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D4A6B008C; Wed, 10 Jun 2026 20:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE136B0092; Wed, 10 Jun 2026 20:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB266B0093; Wed, 10 Jun 2026 20:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1816B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:42:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8A471C12FE
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:42:38 +0000 (UTC)
X-FDA: 84865781196.22.65FCF88
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62EB5A0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:42:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bEibuqF8;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781138557;
	b=yiWDjAnvgLsytrYXZp7LQVefhunYn28KdFZusP+DYmz2iFPRiXS7+vn+0xroHp9JzdSDV6
	qP813H+lrZ02XPmQe/KVh8WOopyeX2/+H62437JCnUWkzosYvunGJARk0PORXT1ZO4IWeo
	+47cMIPrPnRyk6IkAA5vHSFrPtkfURs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bEibuqF8;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781138557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPg16XQYQxUB6l1l5BG3Hl3GFHniv7jaa+CBSQKftD4=;
	b=hgegZh5P94XOIm2kYZ2Wx7ATP7tlBcSNNuYxZgpFgusD3WScoKdemJlrfBrWKzVkDdfrzl
	/OuTbffKxUS4rt8MAESAd2hXuXRDGe9g9/IwmoLlYrRN3Rih1LYWU5d+GDWn8Pkrbe+iPr
	muwMre99xA26ITtP9aMnbBrqNq6KhLA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781138552; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HPg16XQYQxUB6l1l5BG3Hl3GFHniv7jaa+CBSQKftD4=;
	b=bEibuqF8ceRNvZcUyQ8n4oqOm4sa8Bd0N/GJm8ys5Jpkqj/f+CjBghOfDqLC0QaZBjKmklNq404RqPOkzPnRZfYbj2G+wVjaT0d9dFygfaa7JRXVpC4Czh+v7t4GSrK+JrnwV3Y6kEiwZiCn6dz1TPa3k1B6T6zgFOcBwMSfAMo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4bqKN2_1781138549;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4bqKN2_1781138549 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 08:42:30 +0800
Message-ID: <0e431c06-b80e-4b4b-aeca-b9a0eacb6252@linux.alibaba.com>
Date: Thu, 11 Jun 2026 08:42:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse
 support
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3895c09794739bbfae99d9e021ffacf8a51fb8e2.1781083630.git.baolin.wang@linux.alibaba.com>
 <20260610124416.46522-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260610124416.46522-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 62EB5A0005
X-Stat-Signature: d5ftwthnhwemo1pnnkh5zd65e3dq3c94
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781138554-667703
X-HE-Meta: U2FsdGVkX19NXzq876aFxR8PPS1q80EqZlOHiFF2477QLlE5UTxHOC0g8vEbD9uwyrq9QfSekefFaraok86kU7QYiTnxG0RfGmNWO/1EDPIQjqboE3xbyBJAyKkkn2iD89fCeWwBIivXEwBG8bvKLp82PpG3RrNy8AFKtgv0wEM+kuqcPP1NoQ1Eg8NgdTZxZHulGaPFA7eDN61QgSdol31V13IXrZJ3brQx9rPlmsc3hBx0zxTfEkpACQ+DGHYme8fWIUxnKsKsKSS9GPqh0kHd7yuqMFtvzxUWoNgSqb+3E3JKVX2rlkKKlKeO3U/1bt1jrP1wE7aWTXszFavuJQvuDrrweUsfCG30aGTfyZDuyxUAsLuympkzsK/vB3GlEyocNDIzDdahNjxcLLkmK4UREFefx24WHm59q2VWNkx1ZwyXtWQaxWL5B50yoEjybpdKNgZpX0erJsJeOZIfgKP7LKW3YKijOtI2W6QSre0uh/xvsG4CRNkUziyTaxPvBuZ9ZFQEjZpZrxk+Vd/FXHPtMbe7SOxHNCmW/RFpm9hTH54ufT60AyLQA5RszhtzoHqO/ZskNvEwKPWTYzvMDa7Mu3ntiKdLCFmaLvXp/k3tdiHnYQveFFOTu29PN59Ny1SQ64zhLK2aG7BbUOXoLZOsl2mNcd2tXneN7IFdDoGSJKQsownhfTqfcSOdstkc/YCJJmGJV3fEKGqXG5tUtFsTM1MyjmFHAXY57LZo/hRgiR21ZEPahyX1DuBGO7crC9UDEp9nZrOxnrT/xf+ojyKM9PolHPDftbhcAfmUWJTtzwVwLatkEb1NdUxagkjD7DVAHGjR3WPblES53tkl+acRhr7S0uGXTQSrwBDmgv4GoE3wprENl3GoSBzGGtTDykTNIuk6J2iFxXysORTtRi97ix9jZBuCfv2DwfeudICqnSiDnhSkBoBWuVlxCGYVM0cLu2XOuKbG6kY1n+g
 uUjrrfmx
 ssnCNTGVTIefDEe8f6C9mKZPBprEQ4Cr/wnovHwr4ZXC9iP8fke50XFgasdhIQQWEeV86qGZ2vJ4jB77KKUQfBf34009RLFQvWxXLOnhr2SqRie2qLcB8oIeIyyi3XFYFtNVCOzZr0SbntluBbn3K/pUt2KOzMpOLdvAsmwFPdhzktz7N5oYzSDSaWLfAvXIkW98LSQwnAR355TpcYmbdMDV1yo601E6RYxg6A0YU1fTYPlMn8AtpX5HO2XoWONpqI8H7j8QZt2JAxGBFDRQsjXIPt8O0tHQ4k7ZMc/CwzozPdOlFsV1jmw6zyZ+tYoOzd8L/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 8:44 PM, Lance Yang wrote:
> 
> On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
> [...]
>> @@ -1512,8 +1517,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>> 			enum scan_result ret;
>>
>> 			collapse_address = address + offset * PAGE_SIZE;
>> -			ret = collapse_huge_page(mm, collapse_address, referenced,
>> -						 unmapped, cc, order);
>> +			if (file)
>> +				ret = collapse_file(mm, collapse_address, file,
>> +						start + offset, cc, order);
>> +			else
>> +				ret = collapse_huge_page(mm, collapse_address,
>> +						referenced, unmapped, cc, order);
>>
>> 			switch (ret) {
>> 			/* Cases where we continue to next collapse candidate */
>> @@ -1521,6 +1530,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>> 				collapsed += nr_ptes;
>> 				fallthrough;
>> 			case SCAN_PTE_MAPPED_HUGEPAGE:
> 
> Looks like SCAN_PTE_MAPPED_HUGEPAGE from collapse_file() get lost for
> the PMD-order case.
> 
> Previously, collapse_file() returned it straight back to
> collapse_single_pmd(), so we would run try_collapse_pte_mapped_thp().
> 
> Now it hits mthp_collapse() fitst, and that case just goes to
> next_offset ...

This is the expected behavior. SCAN_PTE_MAPPED_HUGEPAGE is only returned 
when the MADV_COLLAPSE collapse succeeds. In this case, if 
collapse_file() still returns SCAN_PTE_MAPPED_HUGEPAGE, then 
mthp_collapse() will ultimately return SCAN_FAIL (because collapsed == 
0), even though the MADV_COLLAPSE collapse has already succeeded.

Additionally, the SCAN_PTE_MAPPED_HUGEPAGE logic is already handled in 
collapse_scan_file(), see:

result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);
if (result == SCAN_SUCCEED && !cc->is_khugepaged) {
         /* If MADV_COLLAPSE, adjust result to call 
collapse_pte_mapped_thp(). */
         result = SCAN_PTE_MAPPED_HUGEPAGE;
}

