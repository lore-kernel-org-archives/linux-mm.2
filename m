Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BCACCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00246B008A; Mon, 22 Jun 2026 09:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7FA6B008C; Mon, 22 Jun 2026 09:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDA16B0092; Mon, 22 Jun 2026 09:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 937916B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:06:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3E60C021D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:06:36 +0000 (UTC)
X-FDA: 84907572792.01.5615EC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2B07B20015
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:06:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVO3TrLz;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782133595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLW3835ooF/gyASPq4HfcxuD4xTqS9E83di9vyQnNuU=;
	b=vVcSAxKTPRgvX663UVEhH9pmOesgjfbBx/0x988/fgMjvi6W5Y8Xssbk+GVhpj1/1c/dd5
	2DjtdRCL/I8Awqk3w4HNOQ1cClyqKigi7G5NsjBjH4Do0TVZRGDhPZygJ820wvAnP1tTFe
	mPs9TkOO/cRxnTVCdCkn9XZgOF1J4Z4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782133595;
	b=y/fyKxB4OFNbhrMMbki4r/MO96X47ZB3DfHNR4hhKKk9+QTWgj8f+FhDF85GHBBGADWepI
	9vZt332/WQ8CpajfH61VSelBtHovV1ZcpE3KfihfXX98lHOdFuf27Xe6pGU9lKftZ4oVNZ
	6SzQH5CdJon5DqM5iuEWKFpGhHKsSg4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVO3TrLz;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8465C601F0;
	Mon, 22 Jun 2026 13:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF82F1F000E9;
	Mon, 22 Jun 2026 13:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782133594;
	bh=sLW3835ooF/gyASPq4HfcxuD4xTqS9E83di9vyQnNuU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EVO3TrLz+bQjQqozayKpjazPXBGIy5tAHLEgjkJc5yRgHhuigoWiPudPbB7kB3uSE
	 UtOB7y4258R1S8pmCtLnbYcOTWEOgS1mobD4Vp2ge358defYkyY8pQXmxRNwU15rV1
	 Ei+5Bo4/bRcahmSXjuouj9qFQs4cAbI2gW6BpP00CZ7W46vU8vs/AUyBRerlYuhUeb
	 lN3nggcejKli1r/PdVvLluVgSkDo1kSQNWtxN6jdlzE5spv02okcBDbYdiSjyKf7Z4
	 J49g9/QL5cjv9luKHEhmdvKOLNQpWYbz9+abchACeNQfHOHgZoBWOmOgLYVDgLwj++
	 y8z5oo4KQuOuw==
Message-ID: <c42354f7-4add-4f56-bb7e-d33000db1f1b@kernel.org>
Date: Mon, 22 Jun 2026 15:06:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 03/24] arm64: mm: Enable overlays for all EL1
 indirect permissions
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-3-eaaacdacc67c@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526-kpkeys-v8-3-eaaacdacc67c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: regon6u9kyhdrkbjy6bo1cjwzkzdx8b8
X-Rspamd-Queue-Id: 2B07B20015
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782133595-914886
X-HE-Meta: U2FsdGVkX186V3gALELgzK/ldGfzZq2L3yfj7ZXnNhzUYcpDFzw8Zocg+RT/GnOasbMiAu+pSXHTHOfgyEaKpbd42Fhfk4GXtV5m/mRZfxUf/aNfXnloR7sbuXeHKI85/SfU+zEU7mQewVNcFdV2lf0cKBwdb521DWZRsyu65fqEswCCbKJbDpFUds/Eegb4SERy2k0UWmsEdoCB78pTkF5/V8JrKaQcwlwkjfYsmZjMrtmDaC3uK5JCaUFCKp/Z5/JRXt5E/ci4OY+qNGqyGXmVsbsg2m5sm8MuCwUGFHBxyRrmod67pHf7+RSopmwKQxWGi5pcCI9lXL7sBB6PMifq000lkJnJMVS5HDrXawpcqFleh+57qc+VaNCekzq1+GD+Eq9dtdLFPSW1EZX+kYRYY7wmCss77Tpz4XwHnitcXVsjqXkaN1WZfQ+iBq7/w6Zu/HFb+YmUNXA8LVT7L/bVvLKAbNYG+cmM3BvGLIPazfFp5X5lYvifSO8ZyJK4+p1yDiC5KqkfcwRjekclBRglAIZYAzzRQKzkaXxhjduAh4aRUwAsS8xhaqYUdDZdeKTDhlScflc4JWDitp/FN60iwykHOcghfBfrFM1aM9CLOwbQspJzR6kkdRii0antiby1D3eqK/TD5sKS+I/jguUM3cwwg24ZQUbsWX050rqVGkD4PhQpFDFVb+TvFARe7hBuqNHX9ea/8unAapmuRkHpB0jagkALsDJiJMmEqQFXvsMzYzAJxfGCO3XdqclIAG+EvzOJZSqKXR8n7NpEfLZrua1kEP0B4w/o9QuDHOJa8GIj/cd3hKmJgACl+gd+Aeu7br+QTHH3f7lxkQtpKLLVMVXVw2ufxYRCtVCIpG0dHKz0Igb1R30NVYYWp3xnIaAeWlIccYTwIk4kyjCa+zDFnBa3Yv9Rs0fGCBjh6X0iU3zRP+VM2JUXOcTKDxj6YLuV0RZeGej6RfFio5k
 KfvNJpeJ
 zrV722cWA7MrWcIH29c/bHpq1MC6xkqikAcZdZ8qbX4vgaaLZJxRsdzy0U3b9XtmxBQCpsRgc4tVCYG9UG3gQArJ9P7PzDeZH4TpGd3+DHUSqcbDLXNPaWfwlir//ZciPrUgkSRQ7lMwod2+ClfkoVJ/BzlqgIuKQpMIJxtx6JBX+KJ1Lax7ds6B+yXVGG4mzOmHtmtnQ+1Bj68tl8RydYRm8pGJEDvLNOS6mGsS/IjvXaT70zGpfAWsXkS4GB222JhnSbMuYXPrDoDT33rB7ynHz2cjrposYvXEmb6MRYPlBSGoZTV6aGbcBxAD6SVK1DPmN5/n9o2VZp4rZ6ZxPd4njkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 13:15, Kevin Brodsky wrote:
> In preparation of using POE inside the kernel, enable "Overlay
> applied" for kernel memory types in PIR_EL1. This ensures that the
> permissions set in POR_EL1 affect all kernel mappings.
> 
> User memory types must be left untouched (overlays not applied)
> because any privileged access to user memory (e.g. futex atomic
> without FEAT_LSUI) would then be mistakenly checked against POR_EL1.

That makes sense. Still learning the architecture, but ... leaving the user bits
as is sounds good to me (and unrelated to using overlays for kernel memory).

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 212ce1b02e15..d4d45ab86a5a 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -183,9 +183,9 @@ static inline bool __pure lpa2_is_enabled(void)
>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)   | \
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)  | \
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)    | \
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
>  
>  #endif /* __ASM_PGTABLE_PROT_H */
> 


-- 
Cheers,

David

