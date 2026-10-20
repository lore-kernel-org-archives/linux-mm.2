Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8132C60A2604
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=niEunjKd
Received: by kanga.kvack.org (Postfix)
	id A2C0B6B04EC; Tue, 20 Oct 2026 10:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCBC6B04EE; Tue, 20 Oct 2026 10:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919976B04EF; Tue, 20 Oct 2026 10:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 695606B04EC
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:56:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2CAB1C2488
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:56:18 +0000 (UTC)
X-FDA: 85343305236.28.08F8EE3
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id A66E4120004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:56:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=niEunjKd;
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiEwhWr3XYxLbSW4Mrcitwl/6JDMFOEBaL5OtTFKJ9Y=;
	b=8jukASpDYOuLI6Yk6Q3CEvwykuXhgqOwQ/0jnFQpYN4lFU8Iy/A02+ut9regBV9VXUfwtD
	706T9Zi3kfwqU9K8x5IUoMfKjjE/649/YweEAmX9mJR5wX5tNLi7DdU5qAcvMUu8QXh/8n
	6GMZBMlJZjJM3N3IOI0opdnnJVn937I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=niEunjKd;
	spf=pass (imf29.hostedemail.com: domain of elver@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508176;
	b=lmUgh2GkaDOSUigSUwuL/wqrglNCVFm3gYawgn9VTKap772IH5UMu2oXF20CSJELxaPFBd
	BT7U/1Md5xAZsaXtyMFKNX5eTPf1C6LjxGBZ4kDy/t5Lxu89dvjsiyXaRB3eMsFU7yP0ok
	iQ+bhiIU74fBOnfCg5dd+tKv7tF94Qg=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c38ac26cc5dso498687366b.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792508175; x=1793112975; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=eiEwhWr3XYxLbSW4Mrcitwl/6JDMFOEBaL5OtTFKJ9Y=;
        b=niEunjKduQw/oJy7TCM8lVPAMgM7Y82N6HjUbql7WhiMGZRGkFePPB/plBjH0FNEAU
         PeXg6NZvHDnGM7jBHmMn8/8R5++G7BwDQxvszdRQDwAY5asz8tk1ebS4ZJsXd+rvznmR
         LxF21wZBWZ/PRaFkig2tr7w8LMVJK9uTvqeq/53t8j/Cy2DpEjdKpr2Iy5uHNFEZczdq
         q9zdWudknOBSF1bJpL5W+/aAhiXTTRFrk8N7ICEJGEhZKwsR5xh50oO7hD8PVZzOWu23
         Y1woJQ2qcxRxD7Y53oyrzxbYEJXjYbUDXlyiXQpqZORQtTnt5qfwlDyQLYKEKA86xCMq
         BQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792508175; x=1793112975;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eiEwhWr3XYxLbSW4Mrcitwl/6JDMFOEBaL5OtTFKJ9Y=;
        b=No8kAt50/zvKFBa6lPs1OLB1/syUXW0MIQaIIRBPJZ1BBHyYFP2YELq7yOCH3gQi8B
         D4bzc3ITTlzI1Ifq++sKJMn8ezMoumWApr6ZuAbCMvixUt40Z9zKZFFMuS989VqQFh+h
         d14xoWP3MRyqUFQYCU1CXGxKM5e7GsDgxWq7htum5jp1IyIL1NUkpGLyuitdEnbgEqzz
         H7boHuBmGUUpgVpmPoDJMGc1gOXXB/02XJNLCUGTCu8wF2ttPauhNf0oGHLwQ39v6VOY
         6VzgFSRH5oLIRRPOKbxH84PCO6BQtAy2NFwudTKCm61kj7lFjjOBWqGuU1KPTNW/8T4M
         YDaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzsr1fBZUOhDlylS0vNdbXexvmGtd3P2YMdA1qjrs0ZGrUU9DJzVQFuPv8gaOc179OZ+X4HghrqIA==@kvack.org
X-Gm-Message-State: AFq9FYJl9dpimHw6iqZtXzV9qASrhe9gnn6oTP3kDcc2lqlQBVMQptpV
	pKF9UVf9zB+1JAq8mvd6/wLgpwrs8xxYJDCV1Twtz07tf4xMOByGtsExEH5DCwz3AOIpQ1wWxy3
	5Y0Vi4HAf
X-Gm-Gg: AYBFou0MPL2aStw/k/kV9peqen5G6QIVTgx3fh1RvQu6ltfn2+Im1zG8ppIfCLDtYwQ
	KlRsPaX11Oy7Q228R/w0qHozMhFunxzMORi5ElMp1YZQF6RS1WhXpH/afgc9MXbVBgRVVHKaqG+
	fW4g+S4XDWxU1PpNdNRTdQowhcIRWne79Nk1DixMvoSMtnTFy0EVte8R28rZFCiZQn/z/60luq0
	mp+0cuyyjUoNXhLimoPNgFzRKYsbFCcGGAIqmhIbfBI6PUpf9w/h5J+DDY0rP9ogPkOfxf9C0ZX
	W7u3dvn5KeiFIM7TKz1TWgsjq8pJkggIGcgCAwfUXxURMHMOCZT4qkb0r18cWJa6GlMt2QDQjXN
	kE2Udhf/t08UTQtquoYR1ZPW2IPLjdZ2a+V9wH+fJiGy5g09nsdu9XMW6Xe9ATNryT8WnEg4sgI
	+UR9QyErHshvBnSnL7M9S53x5un0MK+uwpA5GZ2rJ/WtiEruG1QR9B1QzNAwXGjkhzTM0a4ssE2
	2OyWE6krytjHLck8PzozBvGweTlbNovS2ue/zCw
X-Received: by 2002:a17:907:5c9:b0:c2e:7fe7:288e with SMTP id a640c23a62f3a-c419ef256camr6224966b.32.1792508174841;
        Tue, 20 Oct 2026 07:56:14 -0700 (PDT)
Received: from elver.google.com (11.26.205.35.bc.googleusercontent.com. [35.205.26.11])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c409239b3acsm502151866b.86.2026.10.20.07.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:56:13 -0700 (PDT)
Date: Tue, 20 Oct 2026 14:56:10 +0000
From: Marco Elver <elver@google.com>
To: Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 09/11] stackdepot: add architecture hooks for
 compact frame storage
Message-ID: <ateBClusB8nSEnAr@elver.google.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <20260908-stackdepot-trie-v2-9-1996d5cef732@cloudflare.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-stackdepot-trie-v2-9-1996d5cef732@cloudflare.com>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A66E4120004
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: h98d7ijdh6mqixwujfrs7kfidon4pb9a
X-HE-Tag: 1792508176-677471
X-HE-Meta: U2FsdGVkX1+EiYgeAq4uZU8OQhIIzXjc7FENL9Z5guaUlUSvVNruqRdBGcIdTmpoDStbbhM5UnCvQMCoPBlj2iIrBCUPK6lsPcVAJIkBryhSBxVi/C1+oBaLfkejfll4brip+ftXLftdJCk00rsse9U2pk6RAi+3JR+46rQW9UlMu3HXFRP+C/9kvBh3gmHZID8+1DMYesh34aQBxS5TPLQjvZ3uQnmGda7nsKfbEoET65KxDQvxXA0B1gb2Y2zds+9we7JsXacwSR4WU9TTebQygruX5cPFIQtghr2zfYocW8iyWhTJ4uMel0CMS9+hSYAvYhIaShPKq7B5D4L0+9vyOmn8GibvBYCMBW9N9/ZsG+PVEfieHwEFlxm3bu+dSDrSP/kE+PeRLCFaKZE3yLz4Wxkm9R4QpWWthiG/91jHjCzIgsSEtIKA5lIwBUb3x7PVO9vQMH2V+bKbYGISq2UGkadPlXucnZTJDf/SKkNdZYKsie9VmWQSj55taUX2DYk259mr9wqhlWA1dM8QtHgi5dnMVFpEdrCaSZO7dDNeNzIiszAkaPlUzdCZy45FfZfTPnIvTvl1wsn8hcAV8bEOTXZio5NXvNnSPLzrl0p5EdvIoT3qx2h5hxIBa1rHJe6Ii63aAOlm/iGWBxC2Wv7b3/COfqdjrgGSOaMJaup+a+PTAvquK4yPRA6utyjX3Gm4Leea4QdrhuHX092fJ+C7wki9F/73X2UlGO/xGNOig2xv7Gvxn8xtRlxXhafl9DTRUXVDcOd9P2MVWKcYUpdw7XLaL0ybXY/IEtt8l2rlxaR2LM9DfRg/HIu4ukqq465QKxcEb4vfmzTU7t8YTU7eFQF3XK/wFygG4nzsVGF25Yvc99YhlVJNbF5eld0Pc20nTlhiHMv7A2kdN5rWerEBO2Ewzrj9xtJOhEerkYMnLLandWkDzdPG8NN+M0IR52ZkPCgTlT6sWrRuoBu
 4AiAPQEu
 W9JPBNYnmufZ9T/MZThTjn3owcKVaAg7/OdG3Now3r2iIzEfiT3DmVyiEjAD7oP1sv7En+rFemTAOI0KgbR3uP/BGGViNJyNScB7XV2vW/WpSIcYFi6Akd/dlPa5cBv2Q6r2dQQK+D4xyP/Fn5lQjd9Te51AkW0brOoQledChtl7ZrH8EX2O/KVPEuq6haR9TaeKCVqNydfs7ObQoSnhwEdd8Y4KDx0u4y43rHUliWNfpFheIrDSmKTatglhnzxjsXQ0C3R/NkeewXMJ0NYO4AjXw6n6tKDxbd6y9x/q9vAVi/rLUNnu445b1IVroOanAeS0FMXf7gPb01U56buqtaGsWIlEqzJkpKZSm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> From: Caleb Kan <ckan@cloudflare.com>
> 
> Path-compressed trie nodes can reduce their frame storage further when an
> architecture can represent kernel text and module addresses in 32 bits.
> Add architecture hooks that compress a frame only when decompression
> reproduces the original address exactly.
> 
> Store arm64 frames as signed 32-bit offsets from _text. This covers the
> 2 GB module relocation window without depending on a 4 GB high-bit
> boundary. On x86-64, store the low 32 bits when the upper 32 bits are all
> set. Keep other frames full-width, and provide a generic implementation
> that always rejects compression.
> 
> Make the generic header available to architectures without a specialized
> implementation and wire it explicitly for UML. Add KUnit coverage for raw
> fallback, arm64 boundary round trips, and native x86-64 prefix compression.
> 
> These hooks do not change stack depot behavior until a later patch adds
> trie storage.
> 
> Signed-off-by: Caleb Kan <ckan@cloudflare.com>
> ---
>  arch/arm64/include/asm/stackdepot.h | 42 ++++++++++++++++++
>  arch/um/include/asm/Kbuild          |  1 +
>  arch/x86/include/asm/stackdepot.h   | 37 ++++++++++++++++
>  include/asm-generic/Kbuild          |  1 +
>  include/asm-generic/stackdepot.h    | 19 ++++++++
>  lib/tests/stackdepot_kunit.c        | 86 +++++++++++++++++++++++++++++++++++++
>  6 files changed, 186 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/stackdepot.h b/arch/arm64/include/asm/stackdepot.h
> new file mode 100644
> index 000000000000..df8959d59336
> --- /dev/null
> +++ b/arch/arm64/include/asm/stackdepot.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_STACKDEPOT_H
> +#define __ASM_STACKDEPOT_H
> +
> +#include <linux/types.h>
> +#include <asm/sections.h>
> +
> +/*
> + * Modules are allocated inside a 2 GB relocation window containing the
> + * kernel image. Store a signed 32-bit offset from _text so compression is
> + * independent of 4 GB high-bit boundaries crossed by that window.
> + */
> +static inline unsigned long arch_stack_depot_frame_from_payload(u32 payload)
> +{
> +	long offset;
> +
> +	offset = (s32)payload;
> +	if (offset < 0)
> +		return (unsigned long)_text - (unsigned long)(-offset);
> +	return (unsigned long)_text + (unsigned long)offset;
> +}

'(unsigned long)_text + (s64)(s32)payload' avoids the branch and the
potential UB if 'offset == S32_MIN' on a 32-bit 'long' (though arm64 is
LP64, sign-extending directly is simpler).

More importantly: why not use these 32-bit frame compression hooks
directly in the existing hash-backed 'struct stack_record'? That gives
most of the memory savings across *all* stackdepot users with almost no
added code.

