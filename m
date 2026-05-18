Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDC5CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13ADE6B0088; Mon, 18 May 2026 04:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112756B008C; Mon, 18 May 2026 04:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD396B0092; Mon, 18 May 2026 04:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D92666B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:06:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 908A312080D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:06:41 +0000 (UTC)
X-FDA: 84779809002.30.7A4977C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D8C5680008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:06:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=INZ5j3KR;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779091599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUZWOPgWLn/EZxMpNyrU2lb/9ipHruzoOy77CIyBgCE=;
	b=jPiJG/MBMyL02YYU/38CSYZQ2/xSshjkh+jGhLv86bcm+8eAS0/4P/K8q1luYYwZ0hMQiP
	Wd9/dFlAC8T0v0ekA2wuFP+AIw4spihBaVmMzk5eiYoEnJBWTRAQ8B3SeblhiI8yLb/OCo
	IkibmjWS9EJXbTzS0C+JWH1pTILxoxc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=INZ5j3KR;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779091599; a=rsa-sha256;
	cv=none;
	b=RLrVeCbArNXyh97AdjlFyjWxJqvUSi2PEo+k57NR4HIE+eKK9IeMj857wxA6nN8vrLIFOY
	bppZTJ7wCdOanzPjaUR4B6rvUAlX3yFFTeaT43GfXj5+qXOiYUJUCQw+5A7wGJlNfCRIz+
	6I+IEhDZ5gvO2sfAERzCTruZ+3zuG1s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FBD66001A;
	Mon, 18 May 2026 08:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ADAC2BCB7;
	Mon, 18 May 2026 08:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779091598;
	bh=kEuniSHQNIJ6L0hPMKHr8wZkzqKyNNWkUVWkXhasdXA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=INZ5j3KRIvy4Z5CGgrdXBCP3zQoo46tl5JhAXKL8QiMoOPlkLJrMDpj+ZxyxCAiHu
	 5QKLn81mMUogW66RPtBBpQDF3XTQVJTQjVhE6Z4lblQ2r192u2SEDMfPxJFblcRJo3
	 g+WzHT7dJ0We8jH0fK9DguWfVQmfppbRhGdrIBZ70HIjztIRzlA7skVOXSps6jK7kt
	 KJcba635Qk44MTDo49U9Tq2XtuCd12/YMTP9VztzEq4SaAhSctg88I9pce7Gh3BMUQ
	 L/1UhjJR92pWAdhnsFqnEozTBxHJg+u3VkpunwomR7JL1DtWvsbMEBRPGVf89x7NPV
	 jXAkwB6IsxfyQ==
Message-ID: <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
Date: Mon, 18 May 2026 10:06:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
To: Tejun Heo <tj@kernel.org>, David Vernet <void@manifault.com>,
 Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-2-tj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260517211232.1670594-2-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D8C5680008
X-Rspam-User: 
X-Stat-Signature: 9b3qkf5sty5juaau5yzp7h3w67zbw6rs
X-HE-Tag: 1779091599-822621
X-HE-Meta: U2FsdGVkX19yQM1Jkf/N5O8QnSzh2tef/1Xz2paxpnncn7rqxRgyfWyV07zHs1xBHyiCL6FVN6b+xd4D5PI/M9zSJ+kmm3oUfIqhZnReuka5RlNVk8nipJ0gZApsGR6Zlx5NEZdXYSzEQEt+qV0vLbf9YcMD1wKiytlrFk1wjl7HGU1HibamYucftpJ744Nkk/OGzL5xZb4RCkBVN6qWQFlIKlZYKhQpodCCzhT7prjgAzpJWf3LipF5mctOrQOuPVmG3N5SQ3NhUN8/iYHIDihJvJjb4hkn9uZBS7zdp+Z/VyaAo3Rbpd/9QAXbNSARtsxQUrY+XmErQKYNoONhq/AwmhglTEvPjw/XbnZcxrSxBt/1UVq1RkyRgn5gibuujmJiOABwJ/sIn4T+4rQWPa3tc9Hu7SGHdbUcrpaPBU34VVokNRtC9ji3qEmaVnbLTySfrg93GfbGuNt9uMH33UJgpRWyvgPZnV2OrMCjuKRn24BQOic0snMIwH8ua/4Rm+1i+M7smfllqS5WVHAA5aFrywi0AS7LV6Q6SMEZpKRPH+F5Ga1niYmDKxrruTSheUZKXNm1vrFTDWOn4C2gyCwIsNgBWuvoErIUq6j8PSyyoXKYc8/UeeNLUJuPj9iXP/IZJL5JNXprFFXVAydy12jqdaGm2HcWrOWUjh3v6fnuz2KPvWO0Z056gfOMWcLO1m469zJaHQhTYtaOhCuPQCmGNLkS03i1t84DP+XFHEx/FKFadcNDnqh66vOR4DdiiRc4WvqDh7O7IwDSzZq1CYi5zQuSfUf97tT4ut3jIMKzLzJTAnw1cHhTH3vpNOEn9dhPXLAgqgmUK1u05U3KlTclWCJbrVHiWtvUB5yyfO3W5fdV0OThR8ZNW6EwtLOOIPLF11hXNW5rmnApUfjU90R5c9WVR+fJhMtvbWIV1L5SGAqX7rBZtIUiaie4+rqNd/JL3fYYEDM+2SE4Hq5
 WrKK5mmB
 ElzvW4RShjBTurTPfMKMraPplWken9PDMQSui704ooVgzkN64aGK3qhQBz7HDx6yVuMkh9Yc7MSqhzohSvicvkoHtMMHkX0+XmRHjHGBAlKJPq3Pn6C92/SG4BofjgCSK2f9NvHB0bhBnmeOak9EOTxGUiwcihx/GOBhAZ1GBYJDfKEtGU1waANTvEFFcQoDcsKLFVITCySENDniq7ro5w0TP5nQH0LVwEkE+E7dnf0/aONu/1JERtk2OxVcLtQS0/xdFXT3KUnaoi7qUjXt+yYqjtTsAQO/xyPXP6bsR7bom51E2nplLqYHlXt9OmbE5a2CNGj5mkSx9cgZo6ECPFhaD+N3AZKBjviqt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/17/26 23:12, Tejun Heo wrote:
> Add ptep_try_install(ptep, new_pte): atomically set *ptep to new_pte
> iff it is currently pte_none(). Returns true on success, false if the
> slot was already populated or the arch has no implementation.
> 
> The intended caller is the upcoming bpf_arena kernel-side fault
> recovery path. The install runs from a page fault and may have to
> contend with locks already held by the faulting kernel caller, so
> keeping it lock-free via cmpxchg is the safe choice.
> 
> The generic version in <linux/pgtable.h> returns false. x86 and arm64
> override with try_cmpxchg-based implementations on the underlying
> pteval. Other architectures get the false stub - the callers there
> already fall through to oops.
> 
> Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---

[...]

>  
> +#ifndef __HAVE_ARCH_PTEP_TRY_INSTALL
> +/**
> + * ptep_try_install - atomically install an empty PTE
> + * @ptep: page table entry
> + * @new_pte: value to install
> + *
> + * Atomically set *@ptep to @new_pte iff *@ptep is pte_none(). Return
> + * true on success. Architectures opt in by providing a cmpxchg-based
> + * override. The generic stub returns false.
> + */
> +static inline bool ptep_try_install(pte_t *ptep, pte_t new_pte)
> +{
> +	return false;
> +}
> +#endif

Ehm, what?

This is a very, very, very bad generic idea/interface.

On which ptes is this supposed to be used? User ptes or kernel ptes?

Surely we don't want this on user ptes.

-- 
Cheers,

David

