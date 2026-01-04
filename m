Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47251C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 11:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1A66B0092; Sun,  4 Jan 2026 06:42:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383506B0093; Sun,  4 Jan 2026 06:42:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF736B0095; Sun,  4 Jan 2026 06:42:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF2B6B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 06:42:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58710C21C1
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 11:42:34 +0000 (UTC)
X-FDA: 84294093828.09.4A42F0C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id C26D31A000A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 11:42:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RpICdXFw;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767526952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOwFX5tiVkgDyyRQLg53zLZoYmPa6rEzkBzCc52YJus=;
	b=VPOVQ/yhroLcuauJ6XY8vEXE9HTUgGJ9ZJ8qmpHwLdi3e9oJCd+polaC9uKq+IFVyU/aPM
	zLJCptomyNRFys0i0nBlMMKVkJzjsXXD1vBcia45XyW1NhPQSPbFrUXMZ0Gba7th0P3LBC
	LivPPfAdQ2gHcxc9IDFtbeNo7WZtuDs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RpICdXFw;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767526952; a=rsa-sha256;
	cv=none;
	b=7nmai++jvKhJ/8HS+1qK3HhOYkv/b4XU8QhB6H4gOGoPxCh/f9ELVmBgvCYYiLZN6fiSBO
	zCaGb/kldlv2WjE1f68nzI4YdBmVn18rISuSdfiv0mwrqiXRFwAh+/RkkBIHZxv+OUFTpR
	hHBLqOWV4eRbmSlTxqyA3NVX1vO02Ec=
Message-ID: <b79c4a9b-2d19-442c-969a-7479a8ed9dc7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767526946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AOwFX5tiVkgDyyRQLg53zLZoYmPa6rEzkBzCc52YJus=;
	b=RpICdXFwM2bpv2uDR71rh9y/MhZPTu5CAXYOzxJZzG778IK7V2psirnGHr197RexXfyoe3
	W2kgrUs/lvzqTxvrecaYIWYJKymJYAfV5aQWnOWJQQMcscf6OfZJpLRj8m2srI6BSQG40/
	pyHgXe5dGBjx7LZzmXzJ4fwwRKh9uS4=
Date: Sun, 4 Jan 2026 19:42:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/6] mm: add folio_is_lazyfree helper
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>, baolin.wang@linux.alibaba.com
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org, david@kernel.org
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-5-yanglincheng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260104054112.4541-5-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C26D31A000A
X-Stat-Signature: a8fdh5k8mzajphxdqrr1nn66gk5enwqp
X-Rspam-User: 
X-HE-Tag: 1767526950-516599
X-HE-Meta: U2FsdGVkX18HGMg3uCCECBe70JD0DP0hIMiVnWbVm6P1kMwoAnb4WUjKGYayjWiYjN9wwO+c4EtCemhz547hj02YyWTQ51zMXoa2tlUp8Jm70QjxTcR8rT21jayGL5GgfyEUr7ZdefdxkLrq7lM2U2lQjEflRwtmfE5HmWERJCcCsa9QE4UM+aXCxxJ0k8fxktHSiSl8RVT8DWtles9oVURWXLc7aMV39UGyEmZkESRUaVRIHB4kroZZGRa5hLL1dHRr+WdjL8AzvvzKON0qcr9wqgeVAfbLvDMLmoPTFQcK/M66kpRiUlEXBC2VCl630ZUy2FObiFfLutgN5z51mnQQp3Yi/bsOm/h8x13IADOc9VeYB+FQ/SBcw6Aq86T2gyVMjiBSAuGbTSTZwbxj1809Q26UTXLAyMajbONBy9dqqdyh4reRPky25/mVmwm0LVQynDoA7bAnsHDODE7Xfj/wNiD02JB04fEJhRVuiaiCTHJyxmkG/MGGPqiLjgvWEonLyTivjfGqXGaSFxRna0GSIBKog+IjPeMy6AzSlirYuEvFC3RUFvpuoAgmeDKq/bZT4QBXLPQGUGnyHbyF70so/oTx2Ldr86PxsiNIuWj24gZdvYcydAE2liXX8aVj5daLsYClN5AmSWtxqrm+XfRwJM//YUUP4HWJuqCQL9YuOFQjFcSGwKla3lDCB9v+EUMHa+dci0hTjNZKIAcUHgnV/xOPkBjSb5UVYtw+3soYmf/ERgvIQd/0WjZHNLDUDDANnhbjZ+CIU2Kv3fnwp5B+lee1Ke2VfyGRvOCdJlcrqJcOmmn4MdlP9V8IN97mwWxu6BWL0DNh6pzWWHFXI9SAZmlzzRztKlMI39cBn+xPWC8HfO81EjSmESiKVwsh397JH7XF1Glwe+gas5PRteLLyXZxRvhoQrYC9XY+nghIRn6wQR3JFb6nAZsDZUPepmVkiy8nW8WxZOIXgZY
 abMYoQGG
 VzUSdTTjtCtkBBjBGym6USAOYFhBKHhgbShL4BpH/f1Ie4r55oUDi46lro2PrcFpxhR8GsxJKLuC1v0zAJ06wAhRz8b+l2VhkE3v2QmwazGZTfFIEBU2SPkROztSQ8C5Su/1DVmu/NsAHEv+jek/zkeqA6ZWD1RGRbCGn03JF/hLPWPvpJ5aSaWFEVsivXmtKOJIghMduTSyAL+5xqnng7R0cHisvfyet8FhJ++xbUEjlapoyY1mNeMedb/PuRs3LG6EOqYgKaTXVdbm2ziOBGMT181CA/TPJebwwQ11iXSDk5jg1auGKULk0tidjbG4Mf0fmA4ctHtI6gMG5FXho/orJqQzybzGauSUVzRYuYWURRvetQkz17l/D2y2c9R0VE31G/TeIdFv/o/W2unhr/WXQjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/4 13:41, Vernon Yang wrote:
> Add folio_is_lazyfree() function to identify lazy-free folios to improve
> code readability.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   include/linux/mm_inline.h | 5 +++++
>   mm/rmap.c                 | 4 ++--
>   mm/vmscan.c               | 5 ++---
>   3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index fa2d6ba811b5..65a4ae52d915 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page)
>   	return folio_is_file_lru(page_folio(page));
>   }
>   
> +static inline int folio_is_lazyfree(const struct folio *folio)
> +{
> +	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
> +}
> +
>   static __always_inline void __update_lru_size(struct lruvec *lruvec,
>   				enum lru_list lru, enum zone_type zid,
>   				long nr_pages)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index f955f02d570e..7241a3fa8574 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1838,7 +1838,7 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>   	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>   
>   	/* We only support lazyfree batching for now ... */
> -	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
> +	if (!folio_is_lazyfree(folio))

Please rebase against mm-new. Commit[1] already supports file folios
batching in folio_unmap_pte_batch()

+	/* We only support lazyfree or file folios batching for now ... */
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))

[1] 
https://lore.kernel.org/all/142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com/

Thanks,
Lance

>   		return 1;
>   	if (pte_unused(pte))
>   		return 1;
> @@ -1934,7 +1934,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   		}
>   
>   		if (!pvmw.pte) {
> -			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
> +			if (folio_is_lazyfree(folio)) {
>   				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>   					goto walk_done;
>   				/*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..f357f74b5a35 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -963,8 +963,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
>   	 * They could be mistakenly treated as file lru. So further anon
>   	 * test is needed.
>   	 */
> -	if (!folio_is_file_lru(folio) ||
> -	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
> +	if (!folio_is_file_lru(folio) || folio_is_lazyfree(folio)) {
>   		*dirty = false;
>   		*writeback = false;
>   		return;
> @@ -1501,7 +1500,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   			}
>   		}
>   
> -		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
> +		if (folio_is_lazyfree(folio)) {
>   			/* follow __remove_mapping for reference */
>   			if (!folio_ref_freeze(folio, 1))
>   				goto keep_locked;


