Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09441D3C92B
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 16:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A356B0005; Wed, 10 Dec 2025 11:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA546B0006; Wed, 10 Dec 2025 11:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8866B0008; Wed, 10 Dec 2025 11:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B99046B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 11:18:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 570668ABDB
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:18:29 +0000 (UTC)
X-FDA: 84204069138.28.8762F07
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5771140015
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 16:18:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZyRHUrZD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765383507; a=rsa-sha256;
	cv=none;
	b=Pj5nnNBpObeAAl7yVGj00VEfZmqfMPXAtBoEQkRlE9RJ3yzUd6GNRdOU4sMVSwKwPEUbff
	KiiyWqZNEHZ/p4SKOKabe/RB1qlYKGJDuRf6f01mmFa83vc6jEUnfqB2nZaarePXjZ5jBK
	acmhl6RnWSW2472fWN49kEC10w3K268=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZyRHUrZD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765383507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5R7EEgKhSIj0MssK61oG5hvlzLQojw/c9iQ7wtMJnfU=;
	b=JpCd01/eyB1Uk4muI5BGBCnlSs/qEJqoH/rPOvnIY7y3Ex1LmOIxSgB80VglVqfHjRDG88
	3UrYTM9RiH59lg+uvY8uWGVKUSKSEeOn1zMpNZEK3pzNGx1OQRdmYPWhly/aqBpZrrx439
	B1Jl03mbiRJiv5tQsSpLtfEt/Z0d1c4=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso80351935e9.3
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765383506; x=1765988306; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5R7EEgKhSIj0MssK61oG5hvlzLQojw/c9iQ7wtMJnfU=;
        b=ZyRHUrZDfRirg5jc10pCFLGjaVMma1DK1nmllP1F+U7oTY3RK60QvszWZPyzkB2dlM
         yaRApPS2HImd5AzNOvvHov16L73TTDpDWuJZ8gIP1xbFf8ozP72SnYx7dpByY1g8NEIy
         VdctB9eVk683HJp8NTGGqGAbjAMHv5kRgqE8TPA6CI/CsQ53ghjXosceyxEalMC77aAU
         sJXOjGmEN1qPIJ3fdLg7H4ZIvE5hCDnzg+Da+YfzMiUeccsTXb1mJzakWEM3RTxIkeAp
         tnp+y+dTLVyqdLfq592aLaLRxt8rvDs/s5o0haXjA95lPSfGLQKzeWxtZo5tjHwgm3ZI
         5YWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765383506; x=1765988306;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5R7EEgKhSIj0MssK61oG5hvlzLQojw/c9iQ7wtMJnfU=;
        b=mxUCSgSakUnkT2uTjzSixP7vjNLxxto2ZSbAHwAWQ3ERVhHC51yNralJ3uC6EohMFC
         lFFCy7AoCEQId5KO8ZvDBOA25axBcch0GV5AN57Ngp/prdoVJYd1c4Fxqvua3B2M9HRA
         6bE7ZZ1OQlhO20QRcAi3pVOO5rHx1LpV/GxasebIP1TnW8Sicyv/FnlvKh8ECawipnuO
         Un98N+GDPKVh8htbZkEEAlCDkJYkC6cTH4OS+KiQRWcmgXfmNJCvD2ffcii2FEuUCVoD
         Y9H7Z9Qo0PS4qyn0CUoE4jmO04Rmr0klgheA+/s+QbkAyJgCKksiF7yOCKVEwXbEcZ4+
         nYzw==
X-Forwarded-Encrypted: i=1; AJvYcCWZ5CU9X9Khbe2AoM4I87GjGrRnn7IpWXANSE0gh36DbmDMi3ZLBuA5tS+y8lq9Xu6+rEig0lZTVg==@kvack.org
X-Gm-Message-State: AOJu0Yw18KARbjF8faB4jY/Lu32C0ZqMzcg7BRnguECWOGzuCIoqEpuh
	LzwPj24LYqSlWlq3d1EcQyiiBrY5mT3rPnWdwTbtpi9G1IQd9xOfi0H8ajmWpRWIBw==
X-Gm-Gg: ASbGncsp/XkyHuAZxP5SwhAzlN0Wx0+gRfSu/YjRYJpwYoRL4i3NiZE/gMg2vyyBJU0
	pLou2z7/M+ZZtJUj1vC4abO9Mdf1HGy/9hKEDhjtsqspYnNBUZQfYzKmo5NXVQ/hlh/5k8bszxO
	45TXXRufBasqOAmKWoRAFuKrSmatlldkUU7UaUFbY1FHV9Yi+/g7FzZ/gPlCJMmDbDpaWTL/1tm
	L/Ypn2Gonp9MmnAKN+Laiv8AB74Z3W9QxV1k0HR/smeWi92HVOxDlC1ynPm0eOCuGW4fkNS4uCe
	NqRFon+kN2NAqmkq41vF6p4BTFtxM8i9KP9BPdzPJJgkP3XU99aRkdJ6fp/C/iWgvUCJozPIP9o
	Al7vLDqyovZxkeeacZVz2cBDnKxB/LBsnM1Mamo6B3CR9kjP3NZD5ibxRQfjXPkDwEt0/VOWJWN
	hbDpA8t4NZ7nCtlP9xBD98iSG1cY/W39UOyAaH7YonzVVw26s=
X-Google-Smtp-Source: AGHT+IE5gG+0fezF5tzXHFusF2dBV52zxvrbxnDDqwGYfilnFo0IcpTyJU4lWfuQsZFtfQAM3eL7LQ==
X-Received: by 2002:a05:600c:687:b0:46e:59bd:f7d3 with SMTP id 5b1f17b1804b1-47a83cc5528mr15763325e9.20.1765383505415;
        Wed, 10 Dec 2025 08:18:25 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:2834:9:edfc:ec3:194e:c3b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a7d3a75a3sm45109085e9.6.2025.12.10.08.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 08:18:24 -0800 (PST)
Date: Wed, 10 Dec 2025 17:18:16 +0100
From: Marco Elver <elver@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 00/35] Compiler-Based Context- and Locking-Analysis
Message-ID: <aTmdSMuP0LUAdfO_@elver.google.com>
References: <20251120145835.3833031-2-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5771140015
X-Stat-Signature: z3p55oiojydcs3kyuffkeoanquaeoouq
X-Rspam-User: 
X-HE-Tag: 1765383507-83302
X-HE-Meta: U2FsdGVkX1+GiOHLSGbD8eXKm/895Z6cqTaxU7RBIDNAPsSIbxd84FaT37quu3IZSlRNDEVKpHZdy1E9JeSk5dYn6/j6hR+gdfmURnZkAMz6ejJEFR8Ecby/VBxfp+Xho7OmpNBwC9COycF6t7kbU5EVdkuwuM43Fo15VUK3VJ6UYd83pmg3xTYO8xd9akAkMkY2yRLCm+8fdMVyluTbWiwlp51LpuCQfaJOqh38/ugA5aAtEBJWPMpP+J/W06G/GHJdlE2rmQUn2xGesoWPgmrCKuZta8+R6xlA02XMNz0d2Dx19UGYWdG91h8G6GJxKjOTRn2lMjVhX3p8aG8DP39Y+9n3diCbYQNzN74ti2Jt57NAqZKm8dh8mLiNP9ShilpWVUdfBbH4Ngh4BBElukkwkWKV7E39Be62jC9J+wyNF28j7zdihxq5VbsDihNtNKeQIaxVWzFwm1DLzDHme+4EY0RHv72TEJmOfIu5a0ZCf325kLEoadBhOVbwvqCwOLAjmVDh3OHXCD5khNfOUtQlIx8C5SF9SPqNigXLRMn/4U+PXOxoPXBdFT+6CRdkkmMwuE1upOeMgLFdiccaZ8xxGIeuubxgH/v0D0p6hlt46mKNiJcjVjIAFITAGPz0eNOr5773e/xcWFHY9SiBbXm9Z2+GBQULedqUZPI+nJy6qoU3affxH0fouAYaRFfEuFTuuZtt8pan7l4/3zt8yMKmI+so4clWbjWTUIPMUnV4k42lKBzrh95dImgAsOyR2I+Oi6xyMV9S88Rf8fApmuNJQ71JcIOn/hl6xSSdsMx565D/5sohIQ9dHYt1pu6fw/B6WLcRMxQEc5WJJU3QG+DTQ1JpY6BwPTB0kyh8htFGbLUFfFrYGArCzFoI+sLb9bYxYFSLMEB/Tl/2jMfr/YRKu/sz5wZrx66nHG/RBtzrs5Q6Cz/0CfvUE9OFN5AcKuojtet6P96fOkXXQcP
 FlQxKV2T
 +Bcwl2Xnefy0GmzUitOtT88knHDB4x+wkP8PBmW/OU5NUKviEEAPBLqOZK9fwsn7lFbU3nbTUx5VlOMedoQN9AyuMnWOioVTmkuBxcI5auEDiFAxOq1T2LJag38fCYvYuxHGZ79fSoIEDMyGcdTIJlh0wm9445LNDEgmBFjBAPWSMKtyfPAs6SEGsda8nCRPtv19zsboIs9fFKOkPYvlpgL2er59KCXQUeNDgy0J7jEZ0LXN1pNyL7yVITYlZMWnmBHbGi58Gw2fKR6RBTBz/UJRMpcUCV/4Lu07B8ySt0Snrdg5m3VjPxJk8GMtv08Np+ekchqppuUTmux5vnorLKcYHfIiJV4ZXVwuNgPMJvJ77/eV4x9UyY1RHyFn/K0WtxpefnaV8zjIk6EJWVUFfAiJCHh/jW46QHGkEFCTXIzTcqQ8c259SgdfcKpZT3eawhMqJHijCt5WPnzo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All,

On Thu, Nov 20, 2025 at 03:49PM +0100, Marco Elver wrote:
> Context Analysis is a language extension, which enables statically
> checking that required contexts are active (or inactive) by acquiring
> and releasing user-definable "context guards". An obvious application is
> lock-safety checking for the kernel's various synchronization primitives
> (each of which represents a "context guard"), and checking that locking
> rules are not violated.
[...] 
> A Clang version that supports `-Wthread-safety-pointer` and the new
> alias-analysis of context-guard pointers is required (from this version
> onwards):
> 
> 	https://github.com/llvm/llvm-project/commit/7ccb5c08f0685d4787f12c3224a72f0650c5865e
> 
> The minimum required release version will be Clang 22.
> 
> This series is also available at this Git tree:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev
[...] 

I realize that I sent this series at the end of the last release cycle,
and now we're in the merge window, along with LPC going on -- so it
wasn't the best timing (however, it might be something to discuss at
LPC, too :-) .. I'm attending virtually, however :-/).

How to proceed?

I'll be preparing a rebased and retested version of all this when
v6.19-rc1 is out. One outstanding recommendation from Linus was to
investigate compile-times, but as-is, it's unclear there's any notable
overhead per brief investigation: https://lore.kernel.org/all/aR-plHrWDMqRRlcI@elver.google.com/

From what I can tell most of this has to go through the locking tree,
given the potential for conflict there. However, it is possible to split
this up as follows:

Batch 1:

>   compiler_types: Move lock checking attributes to
>     compiler-context-analysis.h
>   compiler-context-analysis: Add infrastructure for Context Analysis
>     with Clang
>   compiler-context-analysis: Add test stub
>   Documentation: Add documentation for Compiler-Based Context Analysis
>   checkpatch: Warn about context_unsafe() without comment
>   cleanup: Basic compatibility with context analysis
>   lockdep: Annotate lockdep assertions for context analysis
>   locking/rwlock, spinlock: Support Clang's context analysis
>   compiler-context-analysis: Change __cond_acquires to take return value
>   locking/mutex: Support Clang's context analysis
>   locking/seqlock: Support Clang's context analysis
>   bit_spinlock: Include missing <asm/processor.h>
>   bit_spinlock: Support Clang's context analysis
>   rcu: Support Clang's context analysis
>   srcu: Support Clang's context analysis
>   kref: Add context-analysis annotations
>   locking/rwsem: Support Clang's context analysis
>   locking/local_lock: Include missing headers
>   locking/local_lock: Support Clang's context analysis
>   locking/ww_mutex: Support Clang's context analysis
>   debugfs: Make debugfs_cancellation a context guard struct
>   compiler-context-analysis: Remove Sparse support
>   compiler-context-analysis: Remove __cond_lock() function-like helper
>   compiler-context-analysis: Introduce header suppressions
>   compiler: Let data_race() imply disabled context analysis
>   MAINTAINERS: Add entry for Context Analysis

Batch 2: Everything below this can wait for the initial support in
mainline, at which point subsystem maintainers can pick them up if
deemed appropriate.

>   kfence: Enable context analysis
>   kcov: Enable context analysis
>   kcsan: Enable context analysis
>   stackdepot: Enable context analysis
>   rhashtable: Enable context analysis
>   printk: Move locking annotation to printk.c
>   security/tomoyo: Enable context analysis
>   crypto: Enable context analysis
>   sched: Enable context analysis for core.c and fair.c

Thanks,
	-- Marco

