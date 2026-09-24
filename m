Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED1AC9831A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 12:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF8A6B0088; Thu, 24 Sep 2026 08:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90F66B008A; Thu, 24 Sep 2026 08:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F746B008C; Thu, 24 Sep 2026 08:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB616B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:36:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D08F480340
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:36:56 +0000 (UTC)
X-FDA: 85248605232.09.47EB025
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06B49C000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:36:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RfPA0jnX;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790253415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAR7nTOPxRo/mfR2u3OdcokbjHynlMhWcl3pdNDsUgo=;
	b=080XKfmsg9fY+6Zp0mMJi3o0qqi9nfshMBv4mhxFAaWHSEcYOTErDlysUIfj37lnYEmGLm
	Pt7e33AosVtAnsbTdjGgA0WUwWa9FivdA4E6THmpGBOd/ub6fGEx0G/vUmTfSDDstB7vY6
	HfhExfhlvlsYt1ZYl+JRJeCft/xalLY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RfPA0jnX;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790253415;
	b=QVpskdAYPTLSX5DuVkr24f1sMnX1VIqORSpxOgQ5kltS+lZcBsDl+Cmxf1K7NP6+dKrsCh
	EToJEg2WTV8mJ4DMLzFDwzakkBR/BXcAaQG9Z4E6vwnT66rIMzOFW9lYQNY7fFQpOkfH4T
	QrvTnfdCyTQ4SfWG1V602sf/jJ+o+c0=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so15601805e9.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790253413; x=1790858213; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gAR7nTOPxRo/mfR2u3OdcokbjHynlMhWcl3pdNDsUgo=;
        b=RfPA0jnXsTjzUIVyyLWlqtUsjMQurkuSAZzlsWAPcLGBBDstd7qj2K8tlUwHWhjV9A
         15wTMTdrFQsNynpUVb/sYFOfg3qrmuvsQ7orYVfHMzStrYPAb86t0nT20SlcMFe7gIkw
         5k9680Isbr//bK5ailONpbFQhD2Y9yuAE7pucGnZQs8FsgPafhzxRfS/338af+pYcXca
         ac3Pi56l+HZOEOfA04f7mgYhJa2+gS5reBA8Umyfq/0EC1yoQwmENSLvViOxEvqQNa2z
         00xxssXzVHY6zEQWP8rouf0qAUQl/HNdoruNOnO4T3zkFqY78hbc3GdyFlMj1dS4xxgL
         8yWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790253413; x=1790858213;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gAR7nTOPxRo/mfR2u3OdcokbjHynlMhWcl3pdNDsUgo=;
        b=jiIE8uIqAprJCZRhNAbL5zXi/PqvoaTeOLytluRIZeNWoYDcfkX/n9Sb/v7zE32g2b
         tlHAoyJMPFW9/7fq91pUd4pM5JgYkwPZdUAVkvfDKzag0eCdQS0bZB9gyguwmkz1zTrH
         xS9vwvOeTZ1kYUgm96UMjO6y0igvmhegkBbXPMxIhk6Gs6sio/Hvhdj0dvdK7BJMradF
         f/m6KQJXWF0tKKwTt1A9NgAKKbJh54qwOqL5PpCf5cDDtmxMyLqs9I2/Njo3PnSoQNH7
         qg04GPDEZ9M4uvYTArtViToAlvj0bWTr4sxn8HjkpCRV7czJm8AoZlFSgW81p8mXgdZe
         m4Xg==
X-Forwarded-Encrypted: i=1; AKwUvBzeW5JqC0Ymt4ETDudPvj+962pPYz9bNAcn8ISfa4C9IvKNWT9I8X81ux/6I6QutZc3XC7yyfJWgg==@kvack.org
X-Gm-Message-State: AFuF++my4F0rKniRQmxgcOLOcI2qyrEEkjb4tuKLUSphSH6B/H5TNmVi
	jOkyeYFxUyYGd/iaW4H4wgwdMTkViSHQ+dHFfPTtBWn2YlPz01yS8idzQSRVSOtWbQ==
X-Gm-Gg: AYBFou1x7tuOcdXKVl8fid6DPyyihE71e4kgUXAIdKERsHXK0PyNFdzqAHOMrBDD2AZ
	aIZIc7TugR2a6dX8smh3lpG3pIMoZPdTxHf2P8jjXnhK0hzE+/7QNHNySimqiPLnbdxrpp1wwXO
	/ltjcKUxVztwzjbvUEvY4zboV1AoqyD/kDg4hDGmqzWNZoXMP/eXl0tLB+uyfWU0Z5GDiX3I/fN
	da873/PcTJRGxx+KnK80jo3jfYwdvqSFqy9BpU0rmiM/CTm4AUsMBy3/o1CumRbiEsRmML4/vfw
	t0++gJX90KE8tW6NPphEkCNYaionOqUs3b1iEqigMM7/yAhVr43PnP6d3oQw3L+TMS5YC8IeAAH
	Z0gDYypaSau8lN9zcrH+vSgSZ76lcgR5D6DDSpBY13h5hYNcuTCG97+U1Zxe31nvUVWoht35/Ws
	LcRuNZabYnndpyHeqFUPwcqt3oinZXoLtYRI0yDIQ6XFlEHpEKFfb0Z69129HrFSjohFEfZklo9
	j7pLtgzhTyW0lIb7HkatFbUkOqSvtG69JX8v+ld1Q==
X-Received: by 2002:a05:600c:3514:b0:49f:ce72:e931 with SMTP id 5b1f17b1804b1-49fe6701e7emr38631215e9.35.1790253412640;
        Thu, 24 Sep 2026 05:36:52 -0700 (PDT)
Received: from elver.google.com (17.83.155.104.bc.googleusercontent.com. [104.155.83.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe0c4cc01sm56905385e9.3.2026.09.24.05.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 05:36:47 -0700 (PDT)
Date: Thu, 24 Sep 2026 12:36:40 +0000
From: Marco Elver <elver@google.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Bill Wendling <morbo@google.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Justin Stitt <justinstitt@google.com>,
	KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
	Alexander Potapenko <glider@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kasan-dev@googlegroups.com, llvm@lists.linux.dev,
	Guo Ren <guoren@kernel.org>, linux-csky@vger.kernel.org
Subject: Re: csky ICe (was: Re: [PATCH v4 2/3] slab: improve
 KMALLOC_PARTITION_RANDOM randomness)
Message-ID: <arUZWKjKr5I5tlOj@elver.google.com>
References: <20260511200136.3201646-1-elver@google.com>
 <20260511200136.3201646-2-elver@google.com>
 <6106aefa-47c7-4bda-a51f-8a2fba3bf715@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6106aefa-47c7-4bda-a51f-8a2fba3bf715@roeck-us.net>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06B49C000B
X-Stat-Signature: smaqcz9ej5nd6drtea49fujc6yw8dgrc
X-Rspam-User: 
X-HE-Tag: 1790253414-324052
X-HE-Meta: U2FsdGVkX1/Njx+hwWgbuFzyupS8X5QMN29z28B9yz4zSuXtxXW0+pYcFg/dcTJ2B1d+6Zr/7mWe94F5AZTD1XMF3lhwxqOVg7KlYPnnyWWhzwO5jRuZuk0kOMWUXmV8JF8CpLxZeNf9jcAaa0nh7ZqUCoKQM1rw1vHWmASsoC1aqHHYQBSL/ZIKSYzleKGwJza9wBOnQNMXYDWlbzWJdf4O4AjL0q9BWcuZRtDDm30hOfDWpiQBbPy5pvoNQWx1cTRyM9SpDmJ6ISmwpj8gO8NZNiOKXJygbmUHkhOUs25vygksQYGeVMQiE5SFq2a4RQ/sFSDgUXXZ0TkI92Tcsvf928XtTVDHI2Qe8HMYxgi4W9zBdl6CksJfUUn84nwI+UPIh3zBduLnzP6HKpVHUb37YT3+jIVo+z5WlwNbaC3ekXG0TXJj78/R1qVoVuFARtKNtE6kQ+aOOMeCvUcQRUEGWQsJzcYmbW+qw20f+rnJGd4+5cgB+wQ90UFtemVB5qLsST2eawtuQJWF8HxxKtMqHl1hXaAg3hhfo/hFpDggPDTMcif/trp1U4xIPxTtHUb8bTWynqDlB4FPCWQzD3BnwNtuVq7xx4qZLvTeKdUddzpPxi0HxGPShVY9bocGkMozgaKl2p4Z7C8YsQ2soMImkXIwc90GKOAncab2qu4dTQbd18d2TzefGn1RWF7ZmvUcFEV5Ms+vi1RkOvksKuk+ERw1k96g+p6Zg/wFJqMKUfEIJxsHXRFiV/J8YCTyhFXplnyIcogKhtLLKd9wdcyXJmL5+gedxNH77o0CHN94yX84nWw2SoJEXLdmmfi2cSadGMxChN6Vst/2hVfOPRfuUcGpnCoW7AGlp+GSdEoQpuGamUdC59yMFPFcfzlwoqXVZVnl3fXCqBOoTD5O9uHFTgjFSTARB+4atDtxpKMWCMn/Ne1GdKMs6sxa+19ATNSlryDGBr/Ydp6cdL2
 cgyz8jHn
 z8fnS/w19ur+pxNTspU7vsT1wucDkR8xyve8myFmglJh6SsdOmIRuZkQQoQNX62d9svh1w9DHloFUI5PdHb/y9k3NkLlwgYXzlpbf41eyvVmejcbwFw1PW8JtllaOzxsHK+iaWzf+FVa/oF5+HXkbYw8BSZSwxSveshgtQpOgG98/asbIGfZd/vt9ZcFayFzQ7p3o0LrBjKpAGbxebTG3ZUsTsN/nDesHDwJ7beHlpavs/BoJ82JB+dbCLVyroe5zmCGAH8WOSPC8v8DWOHtTYKGbOD9pVHq6WnpNaWpF4zsERYjsiZteU5rbuK/rzCxYMV4KadWNXLJHmGltyeiFg6fE5Wk9CgaQm67wCA9AjLJPH7aPV8JbZXGeHeX/l/3xN21DTMpBmAaj4qWNoS3wWVtYhI+UookZd+jHWQui8F5NwLVn01cIpijMMapdJXKfK+jXvpcjFmsKLq+u5FWlKyZYjvM9lng5JIczh7D4crCnxzkwu5ALYbVgcYTjFH1vXQX5AKwrRPNIoJk+u1XUxGW7gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 07:58AM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Mon, May 11, 2026 at 10:00:49PM +0200, Marco Elver wrote:
> > When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> > to identify the allocation site. _RET_IP_, however, evaluates to the
> > caller's parent's instruction pointer rather than the actual allocation
> > site; this would lead to collisions where a function performs multiple
> > allocations.
> > 
> > With the generalization to kmalloc_token_t, we now generate the token at
> > the outermost macro, and using _THIS_IP_ would fix this for all cases.
> > 
> > Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> > the address of a local label, which is considered broken by both GCC [1]
> > and Clang [2] because label addresses are only expected to be used with
> > computed gotos. While the generic version more or less works today, it
> > is known to be brittle. For example, Clang -O2 always returns 1 when
> > this function is inlined:
> > 
> >         static inline unsigned long get_ip(void)
> >         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> > 
> > To provide a reliable unique identifier without breaking architectures
> > relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> > to _THIS_IP_ where architectures provide a safe implementation, and
> > falls back to a zero-cost static marker where _THIS_IP_ is broken.
> > 
> > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> > Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> > Signed-off-by: Marco Elver <elver@google.com>
> 
> With this patch in the tree, I get ICE erors when trying to build
> csky:allmodconfig.
> 
> Example:
> 
> Error log:
> sound/core/oss/mixer_oss.c: In function 'snd_mixer_oss_proc_write':
> sound/core/oss/mixer_oss.c:1202:1: error: could not split insn
>  1202 | }
>       | ^
> (insn 183 400 184 (set (reg:SI 0 a0 [orig:307 _55 ] [307])
>         (xor:SI (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
>             (const:SI (plus:SI (symbol_ref:SI ("*.LANCHOR0") [flags 0x182])
>                     (const_int 132 [0x84]))))) "include/linux/slab.h":759:52 288 {cskyv2_xorsi3}
>      (expr_list:REG_DEAD (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
>         (nil)))
> during RTL pass: final
> sound/core/oss/mixer_oss.c:1202:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
> 0x779b51e2a1c9 __libc_start_call_main
> 	../sysdeps/nptl/libc_start_call_main.h:58
> 0x779b51e2a28a __libc_start_main_impl
> 	../csu/libc-start.c:360
> 
> This happens with lots of files, not just this one. It is seen with all
> versions of gcc starting with at least v13.x. Reverting this patch fixes
> the problem. Bisect log is attached for reference.
> 
> Any idea what I could do to avoid the problem other than stopping to build
> csky:allmodconfig ?

No idea what gcc is falling over here, but the below patch could be a
workaround/fix. Does that work better?

------ >8 ------

From: Marco Elver <elver@google.com>
Date: Fri, 8 May 2026 14:51:45 +0200
Subject: [PATCH] csky: Implement _THIS_IP_ using inline asm

Both GCC [1] and Clang [2] consider the generic version of _THIS_IP_ to
be broken:

        #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })

In particular, the address of a label is only expected to be used with a
computed goto.

While the generic version more or less works today, it is known to be
brittle and may break with current and future optimizations. For
example, Clang -O2 always returns 1 when this function is inlined:

        static inline unsigned long get_ip(void)
        { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }

Fix it by overriding _THIS_IP_ in <asm/linkage.h> (which is included by
<linux/instruction_pointer.h>) using an architecture-specific inline asm
version. Additionally, avoiding taking the address of a label prevents
compilers from emitting spurious indirect branch targets (e.g. ENDBR or
BTI) under control-flow integrity schemes.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
Link: https://github.com/llvm/llvm-project/issues/138272 [2]
Signed-off-by: Marco Elver <elver@google.com>
---
 arch/csky/include/asm/linkage.h | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 arch/csky/include/asm/linkage.h

diff --git a/arch/csky/include/asm/linkage.h b/arch/csky/include/asm/linkage.h
new file mode 100644
index 000000000000..04afd3583e25
--- /dev/null
+++ b/arch/csky/include/asm/linkage.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_CSKY_LINKAGE_H
+#define __ASM_CSKY_LINKAGE_H
+
+#define _THIS_IP_ ({ unsigned long __ip; asm volatile("grs %0, ." : "=r" (__ip)); __ip; })
+
+#endif /* __ASM_CSKY_LINKAGE_H */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


