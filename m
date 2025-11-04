Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F989CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 05:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1FFA8E00E8; Tue,  4 Nov 2025 00:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD00A8E00E7; Tue,  4 Nov 2025 00:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6708E00E8; Tue,  4 Nov 2025 00:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDF5D8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:26:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25A7F58C02
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:26:47 +0000 (UTC)
X-FDA: 84071790054.16.F6DC401
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B52C100006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:26:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762234005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yuMw5ee23ZZNBX9Qe5ghwRWK8KNaFfk+XtJ08y6pygk=;
	b=5bX+M+rpXd8io+iYYfUD/C35SCwbEo6MIh6poAYZqwWvE70/wS854w9s4kIEYzluSDeZtr
	SBnXfOTOw++AARtSL/pUmW7Tyqqhg63Yft7amvs6R6qqOzFxpCD98jBgnFJjjLNgu2zm8X
	9HjEz402txrYiMNogzaaK1slV7BRUjE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762234005; a=rsa-sha256;
	cv=none;
	b=pzjkEntS9keyPMtzLpXTr2SA2uWGxzUAyGtnJuVdHIg45sQDYN8jsbbgyUgomz/G53YcBV
	pYmf85JsW1BPiG0CYRCE75Nt7VQcYrppGRajYoLerZ5nx0tS9BkrIsVP8EnMbPqt49xUQc
	uZUQTw4hvhVpVM0wlfCpstrG3cUmdBo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BEC51CE0;
	Mon,  3 Nov 2025 21:26:36 -0800 (PST)
Received: from [10.164.18.64] (unknown [10.164.18.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC0BE3F63F;
	Mon,  3 Nov 2025 21:26:40 -0800 (PST)
Message-ID: <5bb311a5-b59f-4897-b4d0-4e06d7d2b3f2@arm.com>
Date: Tue, 4 Nov 2025 10:56:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: prevent infinite loop in kmalloc_nolock() with
 debugging
To: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tbfjjcz5yiqxbw9spxnsytgp3h85x8ii
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B52C100006
X-Rspamd-Server: rspam10
X-HE-Tag: 1762234004-589387
X-HE-Meta: U2FsdGVkX1+O5rUmI2YHOUbKJF4Yj4OFkmvxAvFwp1TUeLgHi9auUpOqO1BwEscx2eDo5sv+MTjAesxSPATj3wlwKEMU1sSyEPAPDwt5Vi6hPt6JrG0gWic1MExksFQ0F0bpw1G7EFGGq3lP76gxmiU2MDR8e1NQgqKH4bU3UT92+jBRITdfrl9lLmYhaA5BPUzN6j+Y5j5ojN5M2uQQb9TUIlFKYoRs2VHQgDw/AB/quc+D2/ESXvcykXg/Ps61LhAhf+MIC+HZ00mGKEVXPVKyoLOugkJ6PTFgbtRihc8Kurx9suoviDgGGr3ZNq8f1hhxzzqXMPpVNbO82XvuVGVhqHIWf2OiY6UGbJpyj4RE70yODO4H9w51UvOcXNc+oMAzLE6UsQIuUINI6ENNlsVA4Dgc7jQIShtMwXQyoXRJ0q9GKR4GtFrN0DBWGcxt2Y5kc+6H4XMbcd0qY1wrCwXHpQ3OsT9OO+r8ys94TuElwqM9ToN/Nnw61E190uWV10WZqgAkJWfJEaCBttCmpSQ2aP5PFbOi6wdcjcVvXCGNZrso5y+IvPT9R6qXFLz2wcNhjpq54X5x/YIEez1DG7gNUhtHDNctkbS0WukZu7524QOlaSqQtDVtifefKB/kyR8bB5yidZTFgDNoOfJRArg3g676R2v/FhXussL08AagEkv0B3umTx/ioWMS5LHPEZZUX3Rr34kvABetEScYwj1Pp2qiFE6IO+dIrH9gbpM/Uwl3hjZ4/A0PWG2+pxyDBWnF8vq+LFWiGPrH3O7vrXNQf+J3dlMPq5TP1r15ru/UGdxEHhP8AKujJv/J0aiJy1ct1Rtzf5Y3XqIlb3JtQ6MHSxc6a9JRxQYAolUVxr+qm14jrEse3/znXg6Guz79xItAULS1ayiMP08t+pLyi+BfyD7uKkcyHvlQoJLq7AV7/zsNtV9fYcfN5y97WggKMHCuCYhOWcSYOd/hFmO
 hkyejGAf
 tKRWkO5rG9sF791DA8qHgUfcJYUqwLXnRFYZL49q8v4uV1x8JkkXmRfrbSwqfPGrvigraLsV7wD9JWG3YVQ/IENAJuW0Wb6zGc7g25xK3TdgmDsEAp/ERLLRfhRIZxVMTU8SpT7QLw0ubCZhLKNVmDr7Wnir/XR8JAwMw+H4E4SMrFdf2OaOuOQaalH/lbYnOgbLm0tq9EKEcDfBC6LbqMTW/90OMxim9479MglWGuBmjwYg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/11/25 5:54 pm, Vlastimil Babka wrote:
> In review of a followup work, Harry noticed a potential infinite loop.
> Upon closed inspection, it already exists for kmalloc_nolock() on a
> cache with debugging enabled, since commit af92793e52c3 ("slab:
> Introduce kmalloc_nolock() and kfree_nolock().")
>
> When alloc_single_from_new_slab() fails to trylock node list_lock, we
> keep retrying to get partial slab or allocate a new slab. If we indeed
> interrupted somebody holding the list_lock, the trylock fill fail

Hi Vlastimil,

I see that we always take n->list_lock spinlock by disabling irqs. So
how can we interrupt someone holding the list_lock?
If we are already in a path holding list_lock, and trigger a slab allocation
and recursively end up in the same path again, we can get the situation
you mention, is that possible?

> deterministically and we end up allocating and defer-freeing slabs
> indefinitely with no progress.
>
> To fix it, fail the allocation if spinning is not allowed. This is
> acceptable in the restricted context of kmalloc_nolock(), especially
> with debugging enabled.
>
> Reported-by: Harry Yoo <harry.yoo@oracle.com>
> Closes: https://lore.kernel.org/all/aQLqZjjq1SPD3Fml@hyeyoo/
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> as we discussed in the linked thread, 6.18 hotfix to be included in
> slab/for-next-fixes
> ---
>   mm/slub.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index d4367f25b20d..f1a5373eee7b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4666,8 +4666,12 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>   	if (kmem_cache_debug(s)) {
>   		freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
>   
> -		if (unlikely(!freelist))
> +		if (unlikely(!freelist)) {
> +			/* This could cause an endless loop. Fail instead. */
> +			if (!allow_spin)
> +				return NULL;
>   			goto new_objects;
> +		}
>   
>   		if (s->flags & SLAB_STORE_USER)
>   			set_track(s, freelist, TRACK_ALLOC, addr,
>
> ---
> base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
> change-id: 20251103-fix-nolock-loop-854e0101672f
>
> Best regards,

