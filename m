Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C13F7C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88976B018E; Tue, 18 Aug 2026 10:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B392C6B0190; Tue, 18 Aug 2026 10:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27EA6B0191; Tue, 18 Aug 2026 10:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C82B6B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:40:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 219FC1402F3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:40:38 +0000 (UTC)
X-FDA: 85114651356.14.B40F960
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A9984000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:40:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+L3xNai;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787064036;
	b=KV17ofV7iectO1e2tw1EmNfW5UvNnKUOER0L6YZO0MMfktVJLF+w0EwXn4Xy13e3hTNJ2J
	4q5PRHwoeZv1vSmZtu/VPo9SdelDycUX04p0ngI62WP9KiJhuC3x0rxqL/sbVvPHl+PbEi
	uGIqOy88YuSNC0+7sIWvKm/bixrLN0I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+L3xNai;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787064036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9UqJ0cWMAqLewxt4FiJQdaK8/rUcL8uMobo62GOPdM=;
	b=HQJuAc2/xQuEFxPRBrc+v0lYc9Btv8ikIt9GB48e/FBeUtrGdNskzOLgKqcFdZf3zdYivp
	Ggafb85doZs9ojqxfL+VR6gJESQomQ24govBSrlkdGdEoGg0GSu6S4DUevKCuLdVTjlw5T
	E8dFiQfd+9Id0e56suXWEnst/XaEBnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C850C601DE;
	Tue, 18 Aug 2026 14:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9601F000E9;
	Tue, 18 Aug 2026 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787064035;
	bh=P9UqJ0cWMAqLewxt4FiJQdaK8/rUcL8uMobo62GOPdM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A+L3xNaic+o8mgxR8Q9rxSFb+DQC+7BvLICT5Cm/gRzAsR6J1hyBQfxczjIrVxqui
	 nkWAt0pXXDg3e6aRznzCSR6b3nw6+2shufi9ew9M8NHBNZryAM1OdR3aqFXoNC0dVx
	 X7qi6YCrCbQBYqcfcjERGY0klraT6sN20sE8aycvs0bCA9IzFvW/KiL42RvT+rAvOm
	 1L/ZMAtJDmoEXFhve1PjCrM1iH91jNJpns+0knS4pByoEskvJGOTf759SiKFeEgsSy
	 Bhe8TCCis2ETJVLOJiSa2p/SbpPeix64rauqnl0wyq40NkFOd/M8HYPezkVq98YWbX
	 kXqMR1ao3U/uQ==
Message-ID: <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org>
Date: Tue, 18 Aug 2026 16:40:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/12] mm: add PMD swap entry detection support
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-3-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260818131202.494754-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A9984000B
X-Stat-Signature: rnnghgg5rfagzmdb7fayiq8ahaxh3n83
X-HE-Tag: 1787064036-25969
X-HE-Meta: U2FsdGVkX18m+p+rINMbRmvrgqwHvjmLXcaeVdvX00XkeUbjrKb/Ib3egbX7yq3YvnbaVxXj0JlXCL0gkX/osZUff4gIm9PVDwRrbRs1kBsKYYhcsG75lxSYFxS71KEym6ekLmdxWjawkDavLSaZxjTRoi4C5ZZrvfJzsNGl2hROPgrfnnRZH+zOBITrc+N08JCdsneSG9tYwG5gQdqR5gxEbePditBDF2tzP43OfrCeaJvTzwmfPWS5hMtKZVEqWvY4ethEWfyPAhXW8GcPLHmee1FHtiQUk5ooOhRivy0x84q/TaVpjiN66aEyqwnXoRxYoLn+H4Yc+Ny9EoAut47XDxvd/9R9EgQuSQkbbwfJvMTws5f3N5fBaoLQDaON/kCwbqGsTwbzeU/t459SpPwZcAkpYeRYOP52szSl+pdodvi8BK866ZEjh5/ZPJgxRUqjGaLCuD/6I5ptiQZb0qaJanvaAhtxw5tzOSwe0InMFFISOgys0jO/68uIcn2rqCdByQXf00FCRkM26pbuYeKfEcGAeUxv3LytXPHeMw7TPyRWaY3tjsW8s0cBoTqsfdTp4GaETF01LLCSa9AaEpecbH6VuZ2Q3MLXmLGrpwm9FYNr0kUJf95ynXHH5C9+bEA3YXcIXTF53ef5SHhdcfGXvIuUAim0R4Ycbid7ob/3IkOXLrWvgT+HWkQaLzHzlipteiR7ClhSHYs4yV3/ffpL/Mi6gtR1xoSDdm494qh9pVzP5lAzVZbsr/VJXrph6oD1wd9agcwDtGo/vJHAJZCB255BFyIV57IdJk3nOHpAQEpjgzoPMVYcsr9bVZDhQMU5t+AAbBBOEd+Hhq0Tv3TOX/xN3eFmI9Q8gCSZBQaQkfZiVKh+urzY0n/zdiytsZxEWAID2/dGgr/EQ3gFajnRTPJSp89jMJVAxB2ppIT1Uwm2D2x8+h6cnI1RMZB0Jjw7+eczNv+j0brU0Yd
 d8zxQhiL
 1+PVOxvatZYwkdUwDmwQUWRqFuGsJb0+hJg5P5z0qOuhMIus4S9EjIqfk7imv/X7ir8CZ6yS5isQKhGroaZrRE1mWfiOUpX2x4OxW7/sMtg/V/rNFPf/1r9vy+Ot1cYtLTFaEtoNkwGvjCY+/91nb/XR0Q50yFQFLFsvxOqeA7w2YYBA70dgCiQ9chCvr4qXHjpuv2lpmv68eX0Mg4Lfs8x1Mp2QE5AldhSQGt3xaYAN749lkORE6Wvw7D1PMc2NZmXIz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 15:09, Usama Arif wrote:
> Currently when a PMD-mapped THP is swapped out, the PMD is always
> split into HPAGE_PMD_NR PTE-level swap entries. To preserve huge
> page information across swap cycles, later patches will install a
> single PMD-level swap entry instead. Add the infrastructure to detect
> those entries.
> 
> Teach the softleaf layer to recognise PMD swap entries:
> pmd_is_swap_entry() detects them and softleaf_is_valid_pmd_entry()
> accepts them as a valid non-present type. Because swap entries do not
> encode a PFN, make pmd_softleaf_to_folio() warn and return NULL for them
> instead of passing the swap offset to softleaf_to_folio(). Clear the
> exclusive overlay bit in softleaf_from_pmd() before decoding, matching
> how soft_dirty and uffd bits are already stripped.
> 
> Add pmd_swp_mkexclusive(), pmd_swp_exclusive(), and
> pmd_swp_clear_exclusive() helpers to each architecture that supports
> PMD softleaf entries (x86, arm64, s390, riscv, loongarch, powerpc),
> mirroring the existing PTE swap exclusive helpers in each arch's
> pgtable.h.

Ah, for migration entries we still use a dedicated migratetype. I actually have
on my todo list to move to PTE bits as well.

(likely the _swp_ part should then be renamed to indicate that this is for
softdirty entries, not just swap entries)

> Provide generic no-op PMD swap exclusive fallbacks for
> architectures without PMD softleaf support, matching the generic PMD
> swap soft-dirty fallbacks.

No softleaf implies to migration and no swap, so this would work.

You should extend mm/debug_vm_pgtable.c in a separate commit to test what
pte_swap_exclusive_tests() tests for PMDs.

> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/arm64/include/asm/pgtable.h             |  6 +++++
>  arch/loongarch/include/asm/pgtable.h         | 19 ++++++++++++++
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++
>  arch/riscv/include/asm/pgtable.h             | 15 +++++++++++
>  arch/s390/include/asm/pgtable.h              | 17 +++++++++++++
>  arch/x86/include/asm/pgtable.h               | 17 +++++++++++++

I'm sorry for asking you to compete with Kiryll's series by creating one patch
for each architecture that directly jumps at arch maintainers :)

[...]

>  #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
>  static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>  {
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index 7c13c58a5e218..4a6c52974b305 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
>  		pmd = pmd_swp_clear_soft_dirty(pmd);
>  	if (pmd_swp_uffd(pmd))
>  		pmd = pmd_swp_clear_uffd(pmd);
> +	if (pmd_swp_exclusive(pmd))
> +		pmd = pmd_swp_clear_exclusive(pmd);

Can't we just unconditionally clear these flags?

pmd = pmd_swp_clear_uffd(pmd);
pmd = pmd_swp_clear_exclusive(pmd);

Avoids these rather unnecessary conditionals unless I am missing something.


>  	arch_entry = __pmd_to_swp_entry(pmd);
>  
>  	/* Temporary until swp_entry_t eliminated. */
> @@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
>   */
>  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
>  {
> -	/* Only device private, migration entries valid for PMD. */
> +	/* Device private, migration, and swap entries valid for PMD. */

Can we just drop that comment? I mean, it's as clear as it gets in the code
immediately below :)

>  	return softleaf_is_device_private(entry) ||
> -		softleaf_is_migration(entry);
> +		softleaf_is_migration(entry) ||
> +		softleaf_is_swap(entry);
> +}
> +

-- 
Cheers,

David

