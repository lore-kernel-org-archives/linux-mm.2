Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D221C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29FE36B008C; Fri, 25 Sep 2026 00:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250446B0092; Fri, 25 Sep 2026 00:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13ED06B0093; Fri, 25 Sep 2026 00:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE2276B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:40:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 716A9404F3
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:40:51 +0000 (UTC)
X-FDA: 85251034302.17.E4FA577
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf10.hostedemail.com (Postfix) with ESMTP id 814E7C0002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:40:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z87PGL+Z;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of groeck7@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790311249;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14MXQzJGNSJiHny7BrCIDsUY2XvMualsJzu7fkY6FZ8=;
	b=IsG4nV2sDkzEDczLOiKPO/zTboFcZnAmdTfJDrr3m6YS8xTu6GhGo0ssQ+RqtN6H0ZkBsS
	Zqh+3rvWGAvgB6E8GAnHPImY+p35PcMUt4WVvE+LEdAqgsMy7hPTwVMFLM+0Qy0FP71DeF
	8bTpUTdaDwhsiOiW+soP0pNr6iYGB0U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z87PGL+Z;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of groeck7@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=groeck7@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790311249;
	b=YOCV1if+p/igoJGJqcMdLJWO94+HdfiShk2I/VG2Aqj0bwlVOYBomJxq38BTjMvvqCd8C7
	1LKGgVItYtmufImpeXhO99Km8vWTz/0aRG0ChJ5z21SMjBG7w9I05lwabpJbRBHnIsbeF6
	MPrEoy2J4Ky0j2cE+USWNVi+yfyywlo=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb65437so342311a91.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790311248; x=1790916048; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=14MXQzJGNSJiHny7BrCIDsUY2XvMualsJzu7fkY6FZ8=;
        b=Z87PGL+ZRqaRKEsaIuy76P/IZY8C8aFZ+FU0mquXjEd326SMb+dfviQ7rgxyvVyBvh
         BAgUcMXb/ztJSwM5HKLQ8j/iakm+1P8wsnf3/Fa4GSQchn+dGNU/CSA+rO7H7sDGPU7v
         ZvIni+B3d90wIO02PYynxW79bFt+bx5N9pfYBuv7kWdR3gG+xgmMutYEmVlVd5IIEL2Q
         tlUUc3WBG3M6VZ8fKBB2ODSHUciJO5z1d7QCbC9EMSM2cKcX/LNbt4VnevR3QdQwxOwo
         rpJgQmD8yN9T+kANtxjiNCTBXtC5q9PSCp+vd5zq7GjRQIdO4x+6lMuH9khf5B2G4gRr
         KbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790311248; x=1790916048;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=14MXQzJGNSJiHny7BrCIDsUY2XvMualsJzu7fkY6FZ8=;
        b=y1F6cPe1UsPaFG1pDGaei+s4+IGEWIBfLjQFLPnW2XO68cLMTIcw/9eM8IPetmZDEA
         l7ZdQGjeVtGAhjc5nzLDkCOvtneK0WqtstoBk/LFDXmg+G+WhCeu6cbdw5n+H6C0Iysk
         MS24THXGbT1AY9MHQFiU+7/nptrLkQEOgRliM1s6/2O3Altwt5qsME4TP+iwZbupfMsN
         ishFOG6kTLSTPEnBTPtnadhisC6cULrw55s/f7JhcdpeHQCQVW9SoU6afgsIJDajYpu8
         daLIVB+J5KDL7BtFeiFm07NH22bY1tXcwzfvo8VjX7ZDq4aPlIEY3JEcns+lAimhTxPN
         Cbow==
X-Forwarded-Encrypted: i=1; AKwUvBwY4/okZLuTl3HtSbV7k/Zhsf/XjlWpkKcgEVpveeHdeGznfqI8Ty6qBmJoHIpCoBOKwuencgSMmQ==@kvack.org
X-Gm-Message-State: AFuF++kXVCyn4Uik1feHwgW+sTiz2McGJF8EZb+gKleDXmbkxbV+Fvqm
	9s2SgqGxCl8ZzsanIvt/6c8GIdWkds7Mlp+tpTIGld57klPAS+s+LhuJ
X-Gm-Gg: AYBFou3nyjyN/Z+4gfHnxXwIqyJ3snJq0nk4nD4UHnaTvmrQDTFgckLdxrNpT4QCzW/
	Rr6QYJW9yoCBAxGlouo1Qke+UfaEFQ14QSfijabhG3bohlHLlGgKR4kfePHuKTG5Rm6UT9rxu/l
	el+i79WAHOXi8JwmT5vtOShGOc05rxxpBxSQFLBF9kI3yDrnXE8y1nK2ULDPqvT4vE4Fn9fGMTW
	QQG/ra60p0w65R6afnLiNsd/or2N1AtwwfT7B9ItlXUapDK9Uf3KqfjW6ewlP7V8L/Rbvj9wvmj
	FqTqTkx90OqqdWn95V7hygjwPLXGmjYyH0+8WPykcOb1vFOni5lOi4os0Q44QjbYxyRLGfqu6ma
	PWxTprQ7Yfk0ChVV/9bbV4lVD+zL8vMDvr7u7H2mThy4hOFANPCF3TOVrjdeGMsjzKozxaqLYrg
	mda7YHP4uDtIYkA439Jg5ce0nQE+nAU4v5HtjRTov+9tB0eICP9MfW5WYdx9LTfa4FD16JtxLER
	FnBiNHMx/jK
X-Received: by 2002:a17:90b:2745:b0:39e:5c75:acbb with SMTP id 98e67ed59e1d1-3a098ad3c68mr3886722a91.11.1790311248198;
        Thu, 24 Sep 2026 21:40:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0c3f74e5bsm192594a91.5.2026.09.24.21.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 21:40:47 -0700 (PDT)
Date: Thu, 24 Sep 2026 21:40:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Marco Elver <elver@google.com>
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
Message-ID: <4e2ea11c-7227-4790-af7c-67ffc86a12b1@roeck-us.net>
References: <20260511200136.3201646-1-elver@google.com>
 <20260511200136.3201646-2-elver@google.com>
 <6106aefa-47c7-4bda-a51f-8a2fba3bf715@roeck-us.net>
 <arUZWKjKr5I5tlOj@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arUZWKjKr5I5tlOj@elver.google.com>
X-Stat-Signature: 95ecy6jot434hw5gy7eoj98gcakz48i8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 814E7C0002
X-HE-Tag: 1790311249-45739
X-HE-Meta: U2FsdGVkX18EQ6IKNtOxU8oSQ9pF5Xs3nFndw4V5JybtnDCyX2VC6E13SuFkhBVY0Vi6ypFRZGckuwl5PiZ4who2/V01qL99XOC43kzLDKGZWWV/r93W+RAPniQeacwMtuw9Z/AV/MmBtIq0Yn8SSBII1O+Lnew6j5GR5cVZCwFayPFpj6kBTrrqcxIrcKTb6LdPjv0yxirRbESEsvI8/0PRvwMxlrciwf/Fn4qde7L5A3MxPRspmpa3BLVDLTBXvHEQasc0sNgE8uGLAzsK0uEe6wKNx5+bub0yD2BL5Y65g+Q9IPd/mN8qygSDzmmztAzxZxvoqOZUGO2d1DSbjWoqwayCSBn0oztb+SPEXLlHf1INn5hF3sKSpteYlTNCZcvzldciFZXqe0zmExlxvYz+ZjOEz85x0IQ+zJlPPJ7/hZZTs5BVg6sAF+FW1eyUpWYRjgYeKfC8WmFaFYc14KGoEH9s616Pz+j0XXtPl08TByEYbZJPhPEzwiiFcGE7BDrvz4LNVYVbUIlqV/TKAcwV6tpJ2q1XBzgVhVzesd4NVvf/S99kv9/fUVlUX5ajXIzHp+6fHy7AUgbLbW7PmBbW71KNRhuWJloF43M598Oe3iBUG2YUPuSJrj284X0f/WyxCDwOD8MkpnpzpEQPEJn9xXwYPXZCmwH27zgMzgB2geYp82BngpfSjhRdEo5zQUL3Wxuf746hFeunDbjfs6NijtowmvrWTxLcfFl41a5NS0qYp3j9oSLYwQupBTmtSB/958bnE6zLSR8Ewu1nTYUbRnSBRau+F15e0ssf9vpEf8+Y2u1z4qj9xS/qNo/tBd9jgsxgLq1ZwrEw48RUeO61GrM5ZENuG1K8YR0ER93iSbjm0sxbIOsYolzywayuJtkM1nq+r5jNUlzZEdYO9C+815trCohglF0Gb69RIeANwxmHf0ZrKd734XqMSkqesrx1OKyrTsu+RkFCCS3
 VTtP8QLi
 NKiri8ixnaGEvSvjCEI3zrNbOq4iG0Et8UuZ0M2ddFExpPp7gKWak8SrAugqDRxr9rMKC7Mjo8BYURbq7mjb4HlMSj6qQYvwKQ/vyTIdGR7DPdG9OoCseWIOxgfzPVf2rBhayFs8lRQHJFKl/RYZ6XbYyJTnEE6ovVTQpVZ7p31Q6RoLzPsEtevRq2rLcFalt+un9Z5GCAHRJ9jqaYplg+F7eh4Vr3Em0gYQCqFBiNr/v/nSvwQuXYIffc9gpl3HFmJz+N25lkTzp5LaDmOtRsSFkkTFsbBnR9mozqLZB3HNTvi5hbRJ+7Xfel+GnHYlWAs5wYuTGOONf2Z6Wt6eJXfK/mIdw4B2x/ytX77xqq93hog5G1sQXgaiqS2x+S40Vu4Mwr17Za5HVcJbH/FUvNTfvqdIGAz9etsVDmKBCa7OrwvWvvUfrUYIb0p9LSIAseRF4SY+Jf0lCWPe/tn9aDJ+38jI2AS+4HJIL9Z4WFxwBdrYS2xYnRcImOr22AQG4RqykCg3f1ju66UvLCd0tO391vHWqwWXtv5RzYe34zzlFxT6oZwNgNDZMi7ZHX9F/rzQ638yGkW1rr6E6mzobUX2fKKlccu7IAFNux7A+vdaCNa6fXIWSOxtb/8jaumD9A2ZK6u8XUsWSNe+bKszHxmoLElrTtmrBSyreQ252cX/S52749ka8EpoWtoNzecAgQGcGOLdqiOMu2a/0hRXGiJ+WCO7GZat8UZ6BN8rv58JKHlWsNW3fqW4h7nkDVdSa+EsaNSZvLr62wO6pkKNrQzIz+tzYFDd3WxHV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 12:36:40PM +0000, Marco Elver wrote:
> On Tue, Sep 22, 2026 at 07:58AM -0700, Guenter Roeck wrote:
> > Hi,
> > 
> > On Mon, May 11, 2026 at 10:00:49PM +0200, Marco Elver wrote:
> > > When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> > > to identify the allocation site. _RET_IP_, however, evaluates to the
> > > caller's parent's instruction pointer rather than the actual allocation
> > > site; this would lead to collisions where a function performs multiple
> > > allocations.
> > > 
> > > With the generalization to kmalloc_token_t, we now generate the token at
> > > the outermost macro, and using _THIS_IP_ would fix this for all cases.
> > > 
> > > Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> > > the address of a local label, which is considered broken by both GCC [1]
> > > and Clang [2] because label addresses are only expected to be used with
> > > computed gotos. While the generic version more or less works today, it
> > > is known to be brittle. For example, Clang -O2 always returns 1 when
> > > this function is inlined:
> > > 
> > >         static inline unsigned long get_ip(void)
> > >         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> > > 
> > > To provide a reliable unique identifier without breaking architectures
> > > relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> > > to _THIS_IP_ where architectures provide a safe implementation, and
> > > falls back to a zero-cost static marker where _THIS_IP_ is broken.
> > > 
> > > Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> > > Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> > > Signed-off-by: Marco Elver <elver@google.com>
> > 
> > With this patch in the tree, I get ICE erors when trying to build
> > csky:allmodconfig.
> > 
> > Example:
> > 
> > Error log:
> > sound/core/oss/mixer_oss.c: In function 'snd_mixer_oss_proc_write':
> > sound/core/oss/mixer_oss.c:1202:1: error: could not split insn
> >  1202 | }
> >       | ^
> > (insn 183 400 184 (set (reg:SI 0 a0 [orig:307 _55 ] [307])
> >         (xor:SI (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
> >             (const:SI (plus:SI (symbol_ref:SI ("*.LANCHOR0") [flags 0x182])
> >                     (const_int 132 [0x84]))))) "include/linux/slab.h":759:52 288 {cskyv2_xorsi3}
> >      (expr_list:REG_DEAD (reg:SI 3 a3 [orig:308 random_kmalloc_seed ] [308])
> >         (nil)))
> > during RTL pass: final
> > sound/core/oss/mixer_oss.c:1202:1: internal compiler error: in final_scan_insn_1, at final.cc:2813
> > 0x779b51e2a1c9 __libc_start_call_main
> > 	../sysdeps/nptl/libc_start_call_main.h:58
> > 0x779b51e2a28a __libc_start_main_impl
> > 	../csu/libc-start.c:360
> > 
> > This happens with lots of files, not just this one. It is seen with all
> > versions of gcc starting with at least v13.x. Reverting this patch fixes
> > the problem. Bisect log is attached for reference.
> > 
> > Any idea what I could do to avoid the problem other than stopping to build
> > csky:allmodconfig ?
> 
> No idea what gcc is falling over here, but the below patch could be a
> workaround/fix. Does that work better?
> 

Yes, it does.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter

> ------ >8 ------
> 
> From: Marco Elver <elver@google.com>
> Date: Fri, 8 May 2026 14:51:45 +0200
> Subject: [PATCH] csky: Implement _THIS_IP_ using inline asm
> 
> Both GCC [1] and Clang [2] consider the generic version of _THIS_IP_ to
> be broken:
> 
>         #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> 
> In particular, the address of a label is only expected to be used with a
> computed goto.
> 
> While the generic version more or less works today, it is known to be
> brittle and may break with current and future optimizations. For
> example, Clang -O2 always returns 1 when this function is inlined:
> 
>         static inline unsigned long get_ip(void)
>         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> 
> Fix it by overriding _THIS_IP_ in <asm/linkage.h> (which is included by
> <linux/instruction_pointer.h>) using an architecture-specific inline asm
> version. Additionally, avoiding taking the address of a label prevents
> compilers from emitting spurious indirect branch targets (e.g. ENDBR or
> BTI) under control-flow integrity schemes.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> Signed-off-by: Marco Elver <elver@google.com>
> ---
>  arch/csky/include/asm/linkage.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>  create mode 100644 arch/csky/include/asm/linkage.h
> 
> diff --git a/arch/csky/include/asm/linkage.h b/arch/csky/include/asm/linkage.h
> new file mode 100644
> index 000000000000..04afd3583e25
> --- /dev/null
> +++ b/arch/csky/include/asm/linkage.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __ASM_CSKY_LINKAGE_H
> +#define __ASM_CSKY_LINKAGE_H
> +
> +#define _THIS_IP_ ({ unsigned long __ip; asm volatile("grs %0, ." : "=r" (__ip)); __ip; })
> +
> +#endif /* __ASM_CSKY_LINKAGE_H */
> -- 
> 2.56.0.rc1.315.gc6ed9934b7-goog
> 

