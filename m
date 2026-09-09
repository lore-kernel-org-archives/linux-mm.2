Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A36CC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C6C6B008A; Wed,  9 Sep 2026 04:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCF16B008C; Wed,  9 Sep 2026 04:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613606B0092; Wed,  9 Sep 2026 04:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1576B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:59:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBB19140119
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:59:10 +0000 (UTC)
X-FDA: 85193624460.08.6AA0390
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D5D480002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:59:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vn1AoCnz;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788944349;
	b=4+XXQ/KeUj+dJoDUTByix4PCgVm7dRbtBsj0QIxcWZDnGvf0J5kGQ2zNYTcqiUzBFBJG8P
	G7dxdNIzKBXhGzqXEcx/sNd8+3LYS3sJo4+HT4D3oejjNB9Z6vCZUqDEpi14A7/HI3ZOhV
	l4uy7GmFGHE3cMG48vqAaCm7cObwU0s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vn1AoCnz;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788944349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDpmQwFklX/G6t4avKDv0NRZijMTIcQHDsR0pbaZQl0=;
	b=WNeuDo+JLtdYiOABesPyIG+uRIVce4ZmZGywQP+VUnhbxW2BuzLybicZQsW6bObmjjvjB5
	ehIAqZ67lmlDIzqtLRr9mRdoh+DW8yRNPBLSwz1CUgyz1CjvUB00rFyTEDCTEEHJrQKAth
	uUm7IOUKgWxzWIMfMWDcd8yzuvO21u0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788944344; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VDpmQwFklX/G6t4avKDv0NRZijMTIcQHDsR0pbaZQl0=;
	b=vn1AoCnzJnoc9nRWUm1XYMNe8Z6ktFUCQR7/S4ftimY6eUPldKv2/CFSSvKROT8GmER7/zl6MIVUJpxpYDI29Ownd0Lel3/D1tUQE66WFj1ycPpAeVaFRl7tk40v4+xuYt2ytZBFk99tQKDUFrJfrGlMpSnqJ7S0BKozkS/E6/U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAeSzYm_1788944341;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAeSzYm_1788944341 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 16:59:02 +0800
Message-ID: <d489ce9c-f2e5-4daf-9c42-08b56f158e87@linux.alibaba.com>
Date: Wed, 9 Sep 2026 16:59:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] selftests/mm: make the swap cases' swapout
 reliable
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-6-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-6-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D5D480002
X-Stat-Signature: cc7fe16df8kodrhxjdxwwgcusjzzkpfs
X-HE-Tag: 1788944346-52312
X-HE-Meta: U2FsdGVkX19WwsrHRk65vt0XdgdlYJ5QtfRC8V/1waSjug3DrG9GZJVYZ6y4+expGemO2o3oXQGSs2Z/eHmsYiZ20VuUUDgdhBVGj3AwoOarOcvCoouZfIErLV7cynWLXsASipxvvHlXnVpqcQ2keRT6Q3XZbCEztSQHFhVtf6ctYDJlsOgCuyoO9KJ5dluW3jnJramley6jwz43alC8K01bLjxtA+qSiPCKhOrNENj4WcYtbMjpjU/Pimm2V15dxnv1eusdN+fQW+ufVsgilQLKlkufhjwNNxUdmArj8o3EeFKsUohgpnw6jBVs5VP8sNtSY4OcaTr4xpaZKZAJOGkifpBlYN/eTAmnjy15NsOTcIHvZPZzYUQH9SpuCWhNFJfbxRFl9ZpnEEXrv8XSXSWXZktz1GmDoWGLXkQq+p+CxUaB0TgWNHl9uLC4Z5MLBzRwmKVTqMPYrE1LPqXLXhQisKHqkRl9FJxBwEqglxzHd527cXWTWxA7wspT+Mk6YGC0glZLIqOiD6uJHC7qrPCNNu17spJMDmSP1AoLp+GYt+bdrKlRJMtMmSWa4zm5bm9GtGOy9Ysqbqwdk+4pLIh9zNCfaXMtLb64CqVCQpq2SeATP8fuCuiXoehGw+LrmqZiTnSNPckwZdZ78rZBHxtpXoQoqAN/DQjaVRtfQDHQWuxD42bIb2uYUKMXyjjWAFZkuouE3nEjXzNMvS2bbY8d72XfSoKLshcx/LqbTm0qROaWU2cF8ke/0INUyVLtKeNsv6Dsd6zeiTrspbjYRokXFVs5JgPjpasqv4zGuR31upp+GeFc3Oh5Ry3UkqNQytELCos+8yXfEWJmhOZup59r/RSR8CUBdsfqg2xGUQAO2eWp6oaw9yLMFwPFJ2Tb25LyAQIHCRKgszkFfk0w6pnLQcvo0xmm3CUaThCJHsn5VQWW19+ctKO1LFAOZ+JoBGOpvT09QVwdO+sEWxy
 Atq+a6+f
 lMD2HHfbhXABUW8+lmmiNvWPap2roPkTn9SpdzaLW0DdRQGvW10YoSek0xxf4jFAXXr267nMIZn13mIoMApPh/Yz82Xq2t+VGnXUqS9G4Pxf+F9sUmgOrPLj2nUo3zq1fMr0sBucODDVUnkYpQF1NiBGuMLF8EWQ9LX6aEDUeIxn25QFYStY1WV39Uh/WkXmoK8ZSSSq/4W9azI/Cwc+wrNK6leQQeeSCbaDiMS8624aIKkawRDrerVmcGxNo9tw0EDggLab0K0l6/Nr7wC3dtpW2OqEhAnjlyKGM9n6A2UJTPTKs0rR1VVEf6XYMaKInjpPXGKIIKDcuLnT7IxfSUVnNpcPdirIUqNuY8ycqa/ftq0T0NcT1dsAxD6IMYu7Vuoku
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> collapse_swapin_single_pte() and collapse_max_ptes_swap() swap a range out
> and then require smaps to report exactly the count they asked for.  Two
> things keep that count from arriving.
> 
> MADV_PAGEOUT is best effort, so the count often turns up a moment late.
> 
> And wait_for_scan() leaves the range eligible for collapsing, so
> khugepaged is still working on it.  Collapsing reads the swapped-out pages
> back in, so the daemon empties the swap as fast as the case fills it.  On
> arm64 with 64K pages max_ptes_swap is 1024 pages, which is 64M a step, and
> the case loses the race:
> 
>      # Swapout 1024 of 8192 pages... Fail
>      not ok 10 collapse_max_ptes_swap
> 
> Retry for up to two seconds, holding the range out of khugepaged's reach
> meanwhile.  The collapse each case runs next restores MADV_HUGEPAGE, so
> only the setup is affected.
> 
> If the pages still won't swap out, skip: no swap, swap too small or full,
> a memcg cap or busy writeback. None of that is a kernel bug.
> 
> Assisted-by: LLM
> Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Make sense to me. So
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

