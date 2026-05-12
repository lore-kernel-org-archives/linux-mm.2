Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 106AECD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741186B0088; Tue, 12 May 2026 01:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1C76B008A; Tue, 12 May 2026 01:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607A66B008C; Tue, 12 May 2026 01:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F74A6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:13:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03467A037A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:13:26 +0000 (UTC)
X-FDA: 84757599654.10.CF52CB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 564E920009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:13:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WA9ZG85p;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778562805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EJzuAEeo3OJOSPzEVo9N+CmVZdPvmIM3kZ9GA3fOqo=;
	b=n9zmrH00jdaTQ1H8dUrvgBZRSKnoiDO+EppqM+DY5YuoQh6tmGxXk+WNoNooiomMQc9xzO
	/9LHvh8sHoMIw64Qu/DdkSw8mocHKF7kmZ+7gJ8XaRbEMCLgaDsb9eEOC7UknwLgqvGhmS
	O5IFmD+OOvvoL7NQN3OT+y2TWuWVkHs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WA9ZG85p;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778562805; a=rsa-sha256;
	cv=none;
	b=cOKk6NSp1D0gxDPXgEfkjzaaMesXOq55ngV4VwZ/22+92YweKGXhPp+ZrQOsLcQoLycLsG
	CeHkSlf8pTqXb72JckoOJUpZ1ykqSGHzd4npnwn7/w64WpIjNiC6HaqCh3SVoB2ubS9pTy
	6WsjENZ5CfIor3A+QE8pRjJDNp076bU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6DF260121;
	Tue, 12 May 2026 05:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74108C2BD00;
	Tue, 12 May 2026 05:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778562804;
	bh=tOGys+YG4qz5yD/e0NN7zHNw7Mi5/xacrSL440qUgAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WA9ZG85pnCfWjPfH96o1K6ZiJJ208mg1UkHc1vCUk//OBCrfGlcQ8pqSMBaYRarhZ
	 2XasZCK+ij8fanqe3B9b6vRRNk4z67wShmp3szQSZNkA9mr5+1rny1ElWcoHY077Hk
	 c3JC0CHxpbTjD0y3tyqUy0M02WctGXzpwXqWHGUqJKaZeH/eO1ddffhIDEgOljoWdF
	 oBP+Maz4NrrRjsyN12Qm76b4fSY5i5BBjz8mE+f7itKxw3L3jmg7lTdzj5fzbpVdQ+
	 RaekGoq+qHo0bWAWX/hUJ+3Aqar0fC8d/E7L6XKxx4pa+/m40/bEB/zUVlf4GhGi8w
	 rPY8L2zwrrg0w==
Date: Tue, 12 May 2026 14:13:21 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Bill Wendling <morbo@google.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alexander Potapenko <glider@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev
Subject: Re: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM randomness
Message-ID: <3z5unwqxty4qq2siingxdijbk642te7kf26ba4ff2xsmyptgq5@i6bxrvkfbve4>
References: <20260511200136.3201646-1-elver@google.com>
 <20260511200136.3201646-2-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511200136.3201646-2-elver@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 564E920009
X-Stat-Signature: yam6bafnh1rfeuys78c6ng1t5iac5btc
X-HE-Tag: 1778562805-637862
X-HE-Meta: U2FsdGVkX19LTpqNhs54zgwrE0P6D42SVS8+OwPLr4UDhgE5IDn9WKgBrtKugVrtlD5HkotF7LGD10VfGkZYIcEU6ligVmBv71mgNIp6eFMCNzV+uqIpWLWVgWOS7JLc2iSuqOqng5pOIMxmm39GDTvo2uxgtnVSXhOxEt5fv/4cG+mzuj6rR7mgloPXb4DMAWuNqw/X1ySesDH3syHunCbjdE06OePYRu5MkP6gWnAQa7WkFwyQzJ3Wa/pnaUblcnK1TwPkWucPjuju+Fpo4FRzaQA25z7d6h5efdCezkUykkvlF8YuhFPbATHLm6EnfJ2fQyj1Ne3gHDig4t+oInDQSrdGYPJ7cnThLgSpibgFChlTk3f3jkrUB2qywIfyqY4cOFa/sQ+zGv0gBGrup1KlwZZR9MYQlPhEuvesfF7MMZgqRA6yDQd64iZrOt36yqSu/u7XN341KULnyzFxajzqa572ZSlbmG7E5JI6sZ91RzC21sr/M7pF9JRH/X453LezYrio3qo+zeu7wF7hFPXPj4b3LGdxxr0nIQuvQSslJa78mDTmQdJeAjzkvLvOEhdzXCBAY8yy3ZNd8aR1CeASROFfdiwjsU8ctPZmaHnC8ajmgWAuW15K0H8NYBpzkW5ECvM6B4f6DsyrIdIJM04ENoYBo14Odf4j1FVo+q8qDe/v1rh6+f07RIYE+wqoZfINWZBYVoWfVNCPBdZ5Sn368vK5gkvClh03O9D+HRlzWD4dEf3M2Oy0Avt/gYSoonz8GATcz7F/sig5/1VJIquQYXfC2Nws4Mzy6SBNKT+Zy6w1kc3460c2IBnBWqMH24cgLldS4vAngShXZUOqe7IYnLvlg0fZafK3otXCnMoITfHYtg0qqriRzgv0gDWK9y8E9wi/UbYtcVoxY1sm7R3MXJjvF9hDfCRuqrscpFqgPw2ve0FlUDT8JC145X85z9H/JEhzYKmp2iJRjX/
 pbmGFjXW
 CkdHgY/oEwdoVqI6CPhQwmbENzZtcIwb5mBgTDvQMwKTM0HFQYINN1RB8yygzEGSMFAA1SybPuND2rW1eCVcYleLy5UxnBx6fhVvadVlzE80fjhfH+sXAO/2fKRi3ilNvmYAyOhJwSSqJNR0kJo8I28518P/xirRjzGb56KzGoAqGGPVOBR8PTDRSUKR9Soszt8AnYJLSMVf/YoR6XW3qXQ4ZfKFYv0KLUEJiFrUaMUQIAOilaL37CUmmZNH7hvIESqF1w5x5hBsv9NcH81kFzBp7kVw8oS161or7XPzwuKNdBoby6JyvwVXo4CUGUpks0yYRE82pQzOweRLOOOulmKmXAYkXnKwAooxSwf4gKr/7BZu+YcWvTtDdPsxU18tKR0CvS68i3r9Mmtagj+mkkiylUxpuC10kHnwvtax+ffN7RPgO/1xx87F6ORp2Yop6t7CWKdKanRMFRxdMSP39CoL63w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:00:49PM +0200, Marco Elver wrote:
> When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> to identify the allocation site. _RET_IP_, however, evaluates to the
> caller's parent's instruction pointer rather than the actual allocation
> site; this would lead to collisions where a function performs multiple
> allocations.
> 
> With the generalization to kmalloc_token_t, we now generate the token at
> the outermost macro, and using _THIS_IP_ would fix this for all cases.
> 
> Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> the address of a local label, which is considered broken by both GCC [1]
> and Clang [2] because label addresses are only expected to be used with
> computed gotos. While the generic version more or less works today, it
> is known to be brittle. For example, Clang -O2 always returns 1 when
> this function is inlined:
> 
>         static inline unsigned long get_ip(void)
>         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> 
> To provide a reliable unique identifier without breaking architectures
> relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> to _THIS_IP_ where architectures provide a safe implementation, and
> falls back to a zero-cost static marker where _THIS_IP_ is broken.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> Signed-off-by: Marco Elver <elver@google.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

with one suggestion below.

> ---
>  include/linux/instruction_pointer.h | 24 ++++++++++++++++++++++++
>  include/linux/slab.h                |  2 +-
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
> index aa0b3ffea935..ea5bc756bd99 100644
> --- a/include/linux/instruction_pointer.h
> +++ b/include/linux/instruction_pointer.h
> @@ -8,6 +8,30 @@
>  
>  #ifndef _THIS_IP_
>  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> +/*
> + * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
> + * and Clang [2]. In particular, the address of a label is only expected to be
> + * used with a computed goto.
> + *
> + *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
> + *   [2] https://github.com/llvm/llvm-project/issues/138272
> + *
> + * Mark it as broken, so that appropriate fallback options can be implemented
> + * for architectures that do not define their own _THIS_IP_.
> + */
> +#define HAS_BROKEN_THIS_IP
> +#endif
> +
> +/*
> + * _CODE_LOCATION_ provides a unique identifier for the current code location.
> + * When _THIS_IP_ is broken (generic version), we fall back to a static marker
> + * which guarantees uniqueness and resolves to a constant address at link time,
> + * avoiding runtime overhead and compiler optimizations breaking it.
> + */
> +#ifdef HAS_BROKEN_THIS_IP
> +#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })

nit: perhaps it can be __initdata to free these after boot?
... if we want to save actual memory allocated rather than the
vmlinux size.

apparently ".init.bss" is a not thing :(

> +#else
> +#define _CODE_LOCATION_ _THIS_IP_
>  #endif

-- 
Cheers,
Harry / Hyeonggon

