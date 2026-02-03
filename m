Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1ED6E6E807
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 11:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098D66B0088; Tue,  3 Feb 2026 06:23:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070F76B0089; Tue,  3 Feb 2026 06:23:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A276B008C; Tue,  3 Feb 2026 06:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD2F66B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 06:23:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 905F114042F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:23:55 +0000 (UTC)
X-FDA: 84402910830.04.B2B7821
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D6BDA000C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:23:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYNSiW0k;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770117833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9CK+57gyxylgnXvGgZfYQ4gb8NRQ2Dah27jPVjSsr8=;
	b=OibSJe8Mot7L/F430jEzjzooer0a8CQD1Y0M1brdNhFJqn/bUr5bmf55HWWgJcreFGtPKy
	9EFza7esxcwajnLTdETmzi2xpRgVlAwwwBBFyllpxFT/sYNtPctA9UXke0ezpOAuatbYhy
	Vi0LSxzyXlpS8mCY/mL4ZfKM/dDRxlw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYNSiW0k;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770117833; a=rsa-sha256;
	cv=none;
	b=Kzy6aKGKLgXmH/JkrA4wx+eUGG0yh8fZDdPnqPG7vT9UuURXVS/kPzX42Qt+4ONd2bKp3m
	hfMh1g9AccOANRF+R/udPyzn1ECcWvIGl2bez4DYeXYcJdRRcbwLdw2r7KQPdJ28hxGiQG
	uOMjR8HZvMpT1MFeTZpbIJSDBrMEMss=
Message-ID: <a5eca294-cb5c-437a-a48d-6c87675c59dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770117831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z9CK+57gyxylgnXvGgZfYQ4gb8NRQ2Dah27jPVjSsr8=;
	b=wYNSiW0kBXQX8yk5biXw6LHBuV/0KwMr2Pj06sAg+HuMQvrtu/cKznpSKwYWvOk/1d+dQd
	fUqmP+DskKb1Zhw+z6hqs8omWok74WNmVXbOpJpdQqGNY22pTyyJO9iASp2CdGsfTyd7I3
	Ack+v+N3Y0KJP+xDcQk5jxPwd5LXlts=
Date: Tue, 3 Feb 2026 19:23:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v6 4/5] mm: khugepaged: skip lazy-free folios
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>, david@kernel.org,
 akpm@linux-foundation.org
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-5-vernon2gm@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260201122554.1470071-5-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D6BDA000C
X-Stat-Signature: tnkuxyyhqt5kr1ho1zpdyxyz4soj8a7o
X-Rspam-User: 
X-HE-Tag: 1770117833-882657
X-HE-Meta: U2FsdGVkX19qe7oaZaxp/weA9yMfV20voNTOm6T+qoTpAO5vq5xWIz8cKDQOw/wdvT+v2mefY23kMKWAhFQ+wxJadBg2A7ZHsg/K54vADrth4r1iiuVGRLT+HJ5rocmDgR5JtWuzgP74Fqly/i9/9goYFF0uivhKemzwk6oCyY7xvRD2Vv3CBBvNkaLCiaaELbZd+TaWOiu74Arx4ZYw/zwmwUGXr4pmp3rTJgl2kCam/pp8+aUqPvHJf7CrpygzKu6uUg0CRLwy2FWTBydwo6otGCT0WyczBuIvCczkerdXYKQ2L3Y0mbLwhidaP3StF473FmsPqonSDP+6Igx4RbL63UK8FlS4QdgiYFaUskfFwy+voBkXpKrxaisaFpcp9aK/Js7Sqxgzlbc8owIgiVykyP2oA8+ZhmEIkMWQDCTWOctQ+AyZiEg3faPCINUEZ46ULyX5YW72XZDyyt+CQSsRQM49bsPtOOtuRnbUQP7snWqN8498VgJIbj8lrvUNuIQmiwRl1e26Q7V/xzEI+LaULsEpKbTVm5mtBfYAYXTTcBtLdtRTS9pys4WC22DFwtG8uPxHB/m3xkcz6ApgdK7Wu5Bh+bC7TSnyVyEGyFewca01HJYEpvqDCHFavvLohJMYY5T3tM/3lc4r8Gv3hqsdt2AUqcO4sS8YG8voN67Wk3Nv/qrh9lg20OsxQEdV4cTljO7t6PF0oDM/TifIBSWGbiolMkDggMrM0st2oL+gSXx95jbjL03QYQvefvv0dgU6e4xdMkkq7VVzs/ZKfc8O0socMpFbJKqbMOGI4Ta+EI0eX9xm2XjDzPRM603So0z/NCLduTUrXI+Wda1EphapYayLbyU7MpoojmjgJibpkJBasfB737/kiFBcOevhg9n2FWhfEbHeas4K1WXotEOYtuXnhjYsSrL+3accEPMMSL3WRF+a41EZlybdPBnuR6bpjQEjRMVt4hl2hCc
 ziQCG9BG
 dLxrjHWf7Ai3jKWgX9WP+A1JjjzV4sxroBh3rgpQxIdQGNLu28aUOydoto+DN8xN+j/9dQdMWTNKi6AhRWlNb0iCVK50Km5gfSqkxTkjjA9x3YfCIy8vA+afC39q02XvLF671rrgvL4maj4GQGJZwPvgvoHb/IVp//FlCp0aStjiHMUE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/1 20:25, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> For example, create three task: hot1 -> cold -> hot2. After all three
> task are created, each allocate memory 128MB. the hot1/hot2 task
> continuously access 128 MB memory, while the cold task only accesses
> its memory briefly andthen call madvise(MADV_FREE). However, khugepaged

s/andthen/and then/

> still prioritizes scanning the cold task and only scans the hot2 task
> after completing the scan of the cold task.
> 
> And if we collapse with a lazyfree page, that content will never be none
> and the deferred shrinker cannot reclaim them.
> 
> So if the user has explicitly informed us via MADV_FREE that this memory
> will be freed, it is appropriate for khugepaged to skip it only, thereby
> avoiding unnecessary scan and collapse operations to reducing CPU
> wastage.
> 
> Here are the performance test results:
> (Throughput bigger is better, other smaller is better)
> 
> Testing on x86_64 machine:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> | cycles per access   |  4.96         |  2.21         | -55.44% |
> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> 
> Testing on qemu-system-x86_64 -enable-kvm:
> 
> | task hot2           | without patch | with patch    |  delta  |
> |---------------------|---------------|---------------|---------|
> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> | cycles per access   |  7.29         |  2.07         | -71.60% |
> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   include/trace/events/huge_memory.h |  1 +
>   mm/khugepaged.c                    | 13 +++++++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 384e29f6bef0..bcdc57eea270 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -25,6 +25,7 @@
>   	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
>   	EM( SCAN_PAGE_LOCK,		"page_locked")			\
>   	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
> +	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
>   	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
>   	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
>   	EM( SCAN_VMA_NULL,		"vma_null")			\
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index df22b2274d92..b4def001ccd0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -46,6 +46,7 @@ enum scan_result {
>   	SCAN_PAGE_LRU,
>   	SCAN_PAGE_LOCK,
>   	SCAN_PAGE_ANON,
> +	SCAN_PAGE_LAZYFREE,
>   	SCAN_PAGE_COMPOUND,
>   	SCAN_ANY_PROCESS,
>   	SCAN_VMA_NULL,
> @@ -583,6 +584,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   		folio = page_folio(page);
>   		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>   
> +		if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +				folio_test_lazyfree(folio)) {
> +			result = SCAN_PAGE_LAZYFREE;
> +			goto out;
> +		}
> +
>   		/* See hpage_collapse_scan_pmd(). */
>   		if (folio_maybe_mapped_shared(folio)) {
>   			++shared;
> @@ -1332,6 +1339,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   		}
>   		folio = page_folio(page);
>   
> +		if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +				folio_test_lazyfree(folio)) {
> +			result = SCAN_PAGE_LAZYFREE;
> +			goto out_unmap;
> +		}
> +
>   		if (!folio_test_anon(folio)) {
>   			result = SCAN_PAGE_ANON;
>   			goto out_unmap;

Nothing else jumped at me, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

