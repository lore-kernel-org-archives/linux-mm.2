Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DB0CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 05:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82906B0093; Mon, 11 May 2026 01:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33816B0095; Mon, 11 May 2026 01:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70C36B0096; Mon, 11 May 2026 01:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 981E56B0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 01:45:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 382411605F0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:45:53 +0000 (UTC)
X-FDA: 84754052586.11.EF4B29C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7AD01180004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:45:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TkERXVWi;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778478351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTaJZo2FUIHA5eBEN/KfoXMWXoejExf2CBz2KoTrGtI=;
	b=1lGv09oZZ/n1TvS9MeyV2Kj87Sm9w+6Ovd+oCF7JtyXfOK12vCImZeNplkzYTF3P29UeFN
	ZYq0sTOrZqqDkJ8yRyiXXgpZVyJplLriLQjhERGxYLt6dCg62cP1dieS5VSgt88rbull7F
	WvLpx9i5j/wUoVM1JNNQA/YYQ4J7ets=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TkERXVWi;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778478351; a=rsa-sha256;
	cv=none;
	b=1NONJLR16ZRBwwIYqdZVh6/PylvookByzwDXSyQS1FrGitP+97FV19qiKTXYCnIFqt5vIN
	qZ7EtCb0UncYZdh722B1SXSROYcG7Ad90we+rdT+4aqWwm3DPgP/uStr6Q3hHFvzzCauu4
	rpvtmm5TUSTHv/864oGmNVLyQaLnPcA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E3131713;
	Sun, 10 May 2026 22:45:45 -0700 (PDT)
Received: from [10.164.148.37] (MacBook-Pro.blr.arm.com [10.164.148.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41F013F85F;
	Sun, 10 May 2026 22:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778478350; bh=9EDhLSvWK/Jmn9/upRXosyoFua5uh6p4DHHLuigAScA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TkERXVWih2qdiEMBQxeV/tjpHsjfhPhlROD6OXYcvBB/l716tnqC3/KGEjTD1mto0
	 sIn/vBHwrocOYsnql/3RYxXQK+yOSbLja2CoCMKF/5gdctjf58Q9iSvhASiQV1SeMv
	 glT2uv+w9g5wf/qrByl1Zxks5xFy+z5gwFz31SBs=
Message-ID: <efc63390-cfd3-419d-afed-4554f2f2530e@arm.com>
Date: Mon, 11 May 2026 11:15:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag
 due to allocation failure order
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Xin Hao <xhao@linux.alibaba.com>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foudation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260511025408.54035-1-ye.liu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260511025408.54035-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AD01180004
X-Stat-Signature: e894p9i66jogdas9hkj1xm3fm49mgqdd
X-HE-Tag: 1778478351-109942
X-HE-Meta: U2FsdGVkX1/+y98V0R0RsQF0UoNKVORMZKcR57kC9UaeW64ezC0B6DNVwu7t71LwKfXYwsoH5sm/bpnRE+0Od+SERJY6+MRYXZkKWlb9O9s9pTZk4CAxMX4g646n2KZqI9aP5xaO6/ySHWJkF+tlQ6EJFveZFo/PRiPwWmSKDusX5qX7OXFgvZYIcb83Y/x1/OKcfQrzbYpASmg+sRJ79BvtUsMChbniWHHkjEBJVOhutfE0rxzM4lij1+EAIAo7yswOiZVMtTZ4D5e6CLmNVfZKP2HHd0u/5x8oyC7+jU91AE25GN2x0E3ZjyxuJJUroY2MU2t8nyMLpN4ryZai15ZeL8p6TgTCbCqPTXBLydPoo2eLnDaoghmabCEzwU2XTL5to1ETnstiXtBDZRiNY9OHvidkFhxYwDvLr+rNF1KqwtRAFZ2NHaewbu2v3uDZIlbvFl1eTRHKLsH8sV/hHj5lixG1vf3R2p+4epIKhV7TCBFOfrgVaJYrG34B7+n8LxUgl5zjwpo2EMsOby88V8+QGu8ddpagCR6a7Hkke8tdZEk79VtF6za2XJmuOD2RfoWJg27/fNCi51w30Pxgh+vgVVOhrjkpQaysmnCXhCWu5hF1qcxkXW5LrZxSoL4mKPUSoAyZ4QVqoj2p9tMivxMVAUW+l2lI3NZKZyKCE6BdRfuTX0kCBj2R4kdsi2TDi8qtMGwNKI1WznmAS/6iBP2RfAXa/yPFvxvtvDwkRxjFhMbtx9EQkXHviH5R3unLvC5gZStmfpEUZ6d5DMquwOS8O3z7oC42yGwA6zWPQYfIEF+aTxMeAG/BIUsiptOaozbZyn16fCwac6vwwNbYlv3KOTtsOmi8Pd5AnoAb7l6TKSzftf6tiGrxmq+o2jOzk1Vhn3SrfxAG9h3bnIN0O+mD8JceXtGD80jG9m28sYILGC5tRqhzhUFSFliTfcAMiZWengyrtl0siStV1GK
 PoZLDmYh
 V8DHjhEsrJOt+W4C34jTEeyEUIkeHPgg0GafKC3HCQhE7SQfDQaFd3b3dSmJ/qm8+Trcm/wcJx4wEudGqduN1haYfJIGNGn7h+P6x0jLclSndIE36nm3i/5nlnNZMvd0kzbDiHZE3s+70sSH56JpDHw9cWRsaAsdrAkl6kHdJ7aoyS9kv0k0WKXGBP/9nNEPw/JHaR9W7F4GgLwkg+x/X1XDA3aOhGNP3bfPyxCeiOVzGwcYDBOpneHGQ3HmpCLa7LOJ85Jueq5Gd295qzRzngEcOak1sE0ncJQoP6jotKqqDO4goZEuXeQ0mO3uqTOPB7kPEStUk/CbsdcUm6sMyLf2kBKipTt3IXiNb3a/OAi0uJ/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 8:24 am, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures, leaving the mm in an inconsistent
> state where future registration attempts are skipped.
> 
> Fix this by reordering: allocate the mm_slot first, then check and
> set the flag.  If the flag is already set, free the allocated slot
> and return.  This ensures the flag is only set when the mm is
> successfully registered in the khugepaged tracking structures.
> 
> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

> Changes since v2:
> - Reorder to allocate mm_slot first, free it when flag already set,
>   as suggested by David, Dev Jain and Lance Yang
> - Update the subject line to better match the patch.
> - Link: https://lore.kernel.org/all/20260506012130.9306-1-ye.liu@linux.dev/
> 
> Changes since v1:
> - Add Fixes tag as suggested by Dev Jain and Lance Yang
> - Link: https://lore.kernel.org/all/20260501075708.327217-1-ye.liu@linux.dev/
> 
>  mm/khugepaged.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5f4e009593e0..78735f34250a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)
>  
>  	/* __khugepaged_exit() must not run from under us */
>  	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
> -	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
> -		return;
>  
>  	slot = mm_slot_alloc(mm_slot_cache);
>  	if (!slot)
>  		return;
>  
> +	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
> +		mm_slot_free(mm_slot_cache, slot);
> +		return;
> +	}
> +
>  	spin_lock(&khugepaged_mm_lock);
>  	mm_slot_insert(mm_slots_hash, mm, slot);
>  	/*


