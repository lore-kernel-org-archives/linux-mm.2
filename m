Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF75CCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913AF6B0167; Mon, 19 Oct 2026 03:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB916B0168; Mon, 19 Oct 2026 03:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8021E6B0169; Mon, 19 Oct 2026 03:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 573456B0167
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:38:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 913E5A0468
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:32:37 +0000 (UTC)
X-FDA: 85338558354.20.8CD0CB1
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2414F140002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:32:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=auGD+Dyd;
	spf=pass (imf09.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792395156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9E2/1RrbNu8/zRm5DyQP/PhhVl988xi9MIrrC75Wnc=;
	b=YL7plsD7tVAVMHObRW6Qx+LiOihD5Mx2BDUSFbanzPxZaJTbF7ZvB0nFJbBkcfQK8e0b54
	0JqmU0fwynBsdqhqq0fvQ00OrgxfM9U+9V/hRJtu3lfT/AxVCS1kyImyYx5X0reXBmNoW+
	qYabW7o7YXneElUU9pDjDcxeH99EIEo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792395156;
	b=fB0SNsb6US2nYvBJqIeYYalwgRkkSVrT8PLviSI5ZgvFaong15jTsze3obixtNi1iTlljz
	Z8GroWv7HWYG63oebiz1ny57NcyJ/9v6hRl4iDxMPupM7NzeeHfK4GYXWlfMtgN4hq+D2g
	c32/GQ7aiZihRTsotOAM7BYksFssExI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=auGD+Dyd;
	spf=pass (imf09.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792395150; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=a9E2/1RrbNu8/zRm5DyQP/PhhVl988xi9MIrrC75Wnc=;
 b=auGD+DydcHIOVO+QmYt0Smo9Fzkyv/WmdWjWy+UYFq3SS198lL+UTzbDeHAhA806wzz1PM
 t0SaQuSq2St9bw2m/2yJcASJ3jFmHAujSzmoSpuo3C6bmp+OZOYfwIKSfOJvD2EmLrtGq4
 HRBUnSCc3mL2v+ac9hxauYNLaWXeUHnR08zFClU8nUfE8HL6XZcCupTu5OlsvhGaHs3uJ0
 ZEtRVE0iimOSM9Kc+LbkH9GdP7rIbScgyZnyxfGWFPsVU9EQWkCvcHbtPqhpZxIGP0CK9o
 89pkETIUWOiRBkUdmqSeZWG4MokhVRIWCVLXqd+Ig9v1CwodIUQTaDyUNJv2Dw==
Subject: Re: [PATCH 5/5] mm: hugetlb: enable CMA allocation for PMD-sized pages
Message-Id: <b8d87b71-c5ca-43d8-8050-72fc14802ae1@bytedance.com>
In-Reply-To: <ddb1e84f-2cfc-4a99-85c4-9a8c6415dbb1@gmail.com>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	"Qi Zheng" <qi.zheng@linux.dev>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>, <akpm@linux-foundation.org>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
Date: Mon, 19 Oct 2026 15:32:13 +0800
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
References: <cover.1792136742.git.zhengqi.arch@bytedance.com> <df6eee954b62f41d65c4d087d17a7a7cf60da791.1792136742.git.zhengqi.arch@bytedance.com> <ddb1e84f-2cfc-4a99-85c4-9a8c6415dbb1@gmail.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
X-Lms-Return-Path: <lba+26ad5c78c+3f8e79+kvack.org+zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2414F140002
X-Rspamd-Server: rspam08
X-Stat-Signature: 6r55fb7w7ubraszhsnqp4xk3mwwb3hqb
X-HE-Tag: 1792395154-9269
X-HE-Meta: U2FsdGVkX18FM/yOck6oTMtc0RXdmnsH9SOX4ufE1Hdv5VESx62wBo2UoleDZ84kOfzBEPUQEqmdJ+qSQJjKKE8GDQtei6CQG28IPcPi6FdYcE/3f8QRJffPHDaRdtw6IBU43gMi1CBFr6VHeyMHulozXDAERmAuEXdqYiMCMGMfjAeEfllhvq9MeA+RNa2UX9OI0MKZ7p2YgaPWyo6b5saRYFCujkPmzKnnn3zl6S+/cOqN+qja14Z/qT6F14BDUEJXVebyBNF+m+Kh1aabJTXoEf4/pfLsGhSYJ++/0/Gtfo3Z9BGo6JOncDUU1gzuZ7fBM+sGZNuSL43fgPaX2ePIHViQrlPfNpcV2Wda/NKfiCTHA+B93lHM+KKgTeQDVwGSJ6BwmgB6ZuB/0JvgqnvFBAEhOxgapLgDi8xvFIxzqB4FgZiJpjFk/YUA5haeQ2HyACSjSRPOYEKppUVlxJJKZoabPbg6o2E/ecxt00zlz7yu8y8cbF2DxaSXjGLhLYCN6otLo5ZN7tgxJqJjPxEJz681j6N36LwW9HmDXTDgxbs8MsYkXovgpoGrEtbInvCzU17DKBpH2qDxAmbkYx44+KQbdkwl4PAR1I+APt7GkafhfoxP7lS+8Hnp4l2rtvhs5EojLSqZXhmwrlxAmrHLyVkd3VvnB2k1kCaTx1hf9jM8ugQQtxMRY7akpaiUP0aSwLlmJ8oVZttNlCNhr/JVsB6u8y1+u+A9ECz557Rhi18I4+lh2savtjd2ecM3NBcMA97et3/6WBsMafz9WM0M7TTAcmIobIhU8K9MmTz2ZoAIJq3t1/xzZb41D+Bq+VMJmIpp+PfBSr84n1Yo7SNvZTGHw4xgJt5692YsBGkA5S2QhAoeI2r8eYt2Y5xlLzSQ4gbxY7qBEv00BbvpVF+W0eYfMxdFKZ1yccYuvXSLH7LjlwLR7F9vNWYVEW8L+ZT1FRzv4UQiMx0/BzO
 xAidsKqw
 rHuLj2WFyU4TVbaUz+Xt2frfm/e0uby/oMuzsKkvQD+6z8wxwr/pz2cZf4cFR4VRdG0gNtCQJ6NyUqMfKA05MPiDKF3jqu35p/Hkdhkum5CJqidjyWO9p4lu+oRvavRbFT/iJB3OWhKt+tk6hMPgFMrrOfWX2aIJtU3RNcOAToWe98NMlCZmZyhHLtjSkh5Q4upUPRUsHf00CJDEFtPtwWiNLP+AR3aXXrs2ybztfme/+tkBr845GdKBozk3CcoZ1jggs3YmUEAPU5OwkIddpwUQ/zfyopYKal/WsdyGQ5ULsAE5NUDhPSM2EHXgZJEMuJf6IFyPYUdpQb/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/18/26 3:07 AM, Jose A. Perez de Azpillaga wrote:
> On 10/16/26 12:07 PM, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Allow hugetlb_cma=<capacity>@<page-size> to select the architecture's PMD
>> size in addition to its existing CMA size. PMD pages are 2M on x86-64 and
>> 2M, 32M or 512M on arm64 with 4K, 16K or 64K base pages.
>>
>> Give PMD pages their own pool without changing the original pool's sharing
>> among other gigantic sizes. On arm64 with 4K base pages, 32M and 1G pages
>> continue to use the default 1G-aligned pool. Unsuffixed arguments and an
>> explicit default size still configure that same pool.
>>
>> PMD requests use only the PMD pool, even when their order is gigantic.
>> Other gigantic requests use only the original pool. Apply this mapping
>> consistently to allocation, CMA-only policy and boot-time accounting.
>>
>> Move CMA allocation into the common fresh HugeTLB allocation path so
>> non-gigantic pages can use CMA. Align reservations to both the selected
>> page size and CMA's minimum alignment, and use a bitmap granularity no
>> larger than the selected order. Keep the original CMA area names and give
>> PMD areas distinct names. Document the syntax and pool selection.
>>
>> Assisted-by: LLM
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> [snip]
> 
>> +	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
>> +	if (!folio) {
> 
> boot-time hugepages= goes through here too, so hugepages=128 with
> hugetlb_cma=512M@2M already uses half of the pool at boot. would buddy
> first and cma as fallback make more sense for PMD?

That makes sense.

Buddy-first can reduce CMA migration and leave more CMA capacity
for later allocations.

I'll use buddy first and CMA as a fallback for non-gigantic PMD pages,
while keeping hugetlb_cma_only=1 restricted to CMA and preserving the
existing gigantic allocation path.

> 
> [snip]
> 
>> +	if (order != PMD_SHIFT - PAGE_SHIFT && order_is_gigantic(order))
>>   		order = hugetlb_cma_default_order;
> 
> doesn't this take gigantic PMD-order pages out of the default pool even
> when no PMD pool is set? would trying the exact order first and then
> falling back to the default pool work?

Good point. Perhaps we should use the following selector with the two
fixed pools:

static struct hugetlb_cma_pool *hugetlb_cma_pool(unsigned int order)
{
	struct hugetlb_cma_pool *pmd_pool = &hugetlb_cma[HUGETLB_CMA_PMD];

	if (order == PMD_SHIFT - PAGE_SHIFT && pmd_pool->size)
		return pmd_pool;

	if (order_is_gigantic(order))
		return &hugetlb_cma[HUGETLB_CMA_DEFAULT];

	return NULL;
}

> 
> I tested it on qemu and saw no issues, but I'm hesitant about the points
> above. I can give a Tested-by tag on the next version :)

Thanks! I'll send out a v2 as soon as possible.


