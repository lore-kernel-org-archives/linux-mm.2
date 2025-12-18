Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4260D68BF0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33DEC6B008C; Thu, 18 Dec 2025 04:03:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F456B0092; Thu, 18 Dec 2025 04:03:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213F66B0093; Thu, 18 Dec 2025 04:03:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFF16B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:03:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE39DC10B9
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:03:20 +0000 (UTC)
X-FDA: 84232002960.25.18C0EA2
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC3C5100015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:03:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AqQ6Bcyp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766048598; a=rsa-sha256;
	cv=none;
	b=7DTEsHvWKZlaNT79vLVd6ujiCrMg9hE98TgXishz+gkdpRzp8bRhTHpRmtYdzOSj70kqGw
	kvE+1fXvRyZ7D23Z77ktIDRFJK/d9O2J17nvMLvUnNdlLcA3pqkJNrxC2WraO7frGiJbpu
	FLlABkTCan5s+rhJ2s3cOiDKBA2Widk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AqQ6Bcyp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766048598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDxH7qSfMcvkHLsC5apj9tDI0YXojM/cFgm0fm580dk=;
	b=nRfsQtTd4dvjwLp/XxtDD0NGTsmnEheVVYkquJZL7ZPE8lRc/D3ymkcqnP/irJr+kzxD5Q
	HTTVuM428ddufgb3ptvPLmmYRrMKejg3odytf2UI9cOIRZ0Wk3JAdNkGOA1Mv7pBDGn8uN
	1Y7KpFqx0Em8kCaWH0MPLdXXNBDzzEA=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-430fbb6012bso253547f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:03:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766048597; x=1766653397; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RDxH7qSfMcvkHLsC5apj9tDI0YXojM/cFgm0fm580dk=;
        b=AqQ6BcypuvFf6y9scuNneejdaYFYdQduupCagcfmdftV23jUmAQ5iXvEqJ1uS2sTO4
         gvByNhXaVOyMzWfbHGvU1iJ0KjErTHY1FQkMFRF0AV7ZURtmbmOTxe4HK1ZDH0ZpTfRE
         8JTsMwT51HDUGxldM4443nimyiD43EwSkdAqF3FQPMKAdY5SG4E4IX+jEWWiKUedxfRm
         g6jVXO6C3gREB88Zd8BM9CE4PJmMChbbSWw6GBm3iSaG+xofoDe8rJ1Ajh7hdkjJKrxQ
         8K8EuPw0+RdRA+fdcxyYfQ6FLgwZGsptkEdBKpqGNBc511WIivQz8e1+iVIPP+6HSiXp
         86rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766048597; x=1766653397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RDxH7qSfMcvkHLsC5apj9tDI0YXojM/cFgm0fm580dk=;
        b=LrF22EnEKmrSNXDe681KxcOa1RTK3lfoGsZPI3JAg+vqVIqGZVdEO+eaGDHuNGUntD
         E2zBE9SK2tCCTeJemCH48fISXFgvlJ5rV7zj3SlSi1+HdW4okNpOTsVa0ZpM9bkizx1k
         r+9lgiQxDjELTeUoLCgWBFe1DK4SL3j465gNTwAz7a0zQaSECMHgP8QInHvJz2BVyMCB
         imXtSuNfpqxS1UnZ9zEnkJWIGe8Ehk++GrTklZ2eaOqavbgjW7/NCYI/pSv88jxaA3iC
         nr17zD2pfQ+nV/Icjd9SsBXQP7hyO8qesVbVtW6ECUrGmLPhmOwBSaFmGRFFtuvu3Bi/
         vnCg==
X-Forwarded-Encrypted: i=1; AJvYcCUvSQF0f/1Jq0BqmAXhkOfO9nS3rNIWrFnDca6SQX4lQ/smsBfT3FfJfNHfLvr/Gd9Gtbb9d/52nw==@kvack.org
X-Gm-Message-State: AOJu0YymboRv5ry7m+N6ZLYKbD6ebjJX/nm6OoJM03n3EdTsWS9cdbwX
	YjMpGYJ+R9njhawLImjX+O4n8e5HGmhwYRAZh51xElmD/FSAHMEffCqL
X-Gm-Gg: AY/fxX67vdmj5bIhKAjG29gnMLVeSy+CYmPv6sRsUrNpgWeTmEr8PPS6AdAguH62h+Q
	mJaWTs6bW+N6IZkhZTwdXLgAYQxybaILcJvEnGWnQaeacLGrV1O2beTzDPNNp/PvS2Zey0u/p/9
	/eXmRQ3Y03kaZ2hu6/GzxZEe8fHIcbtt4eiCmJB16Y0oQHzPP5I5Qoi/mTjq1sYx/pY7qt+KO0T
	grWh9s5iZ62/7/LXfWrzGvx6bzlCR5RbzfNEI8SHqzegM56NljEa9Rsn2mlTRwuHqqmb8u6R2uZ
	csxcVI1IXU1R6LG2mbXIsbDIaXe9zLPkJC2+6OSJXDwIDBP5srlVKg8AhOf1EHtU7An9TDZrDxt
	P5Zs6YutoYjUTAHg8FCUvO7peqYaiAfiGE86hFeKBWxiQfF1J5Ico2NgutNrFCzriGgCYdJX96u
	rPsCh5QgmQ28Yj/Um5KwlZbyJZ1h73ViPfPgL+pL0ozhUm7X9goz1c
X-Google-Smtp-Source: AGHT+IEbh0hfUiD9R3GvyhXdWOj5sIjfGCLoQ1ahL8e/00qynhJrsgNXG94C0F/okiDwtop3UZ3GBA==
X-Received: by 2002:a05:6000:1848:b0:430:f97a:6f43 with SMTP id ffacd0b85a97d-430f97a7049mr16299902f8f.53.1766048596303;
        Thu, 18 Dec 2025 01:03:16 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324493fe27sm3770797f8f.12.2025.12.18.01.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 01:03:15 -0800 (PST)
Date: Thu, 18 Dec 2025 09:03:13 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Joel Fernandes
 <joel@joelfernandes.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, Will Deacon <will@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, John Stultz
 <jstultz@google.com>, Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, Andrew Morton
 <akpm@linux-foundation.org>, Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar
 <mingo@redhat.com>, Waiman Long <longman@redhat.com>, Mark Rutland
 <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil
 Babka <vbabka@suse.cz>, maged.michael@gmail.com, Mateusz Guzik
 <mjguzik@gmail.com>, Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
 rcu@vger.kernel.org, linux-mm@kvack.org, lkmm@lists.linux.dev, Gary Guo
 <gary@garyguo.net>, Nikita Popov <github@npopov.com>, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v4 1/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
Message-ID: <20251218090313.33923750@pumpkin>
In-Reply-To: <20251218014531.3793471-2-mathieu.desnoyers@efficios.com>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
	<20251218014531.3793471-2-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AC3C5100015
X-Rspamd-Server: rspam03
X-Stat-Signature: pp385e1hhgqs6ycqwqiwbkxnczpmo7pb
X-Rspam-User: 
X-HE-Tag: 1766048598-37214
X-HE-Meta: U2FsdGVkX1/FrfIU9TibI0JDyABOA5VGwrkQ1JN+4BK25dkkPF5ZspXcsKeRgRR2koU2NGfMDozAlyc4IjkLmNWzZV/VTkqgUsDjUY4NdgzsnJUKgyHSZ6pmSQ/tErZ7O271TwUIpq2sdravOT4Fw+Hy8zOVqNaS7W2YmFDDDddrS0mP9IUdxkxvD5R74XOqbG+Kmx5DbYn70G1Id63ceIrmRGmLSAVjRdGbGyoQ0KIg047evgeNhPtWrf2w+hAZ0xfTZ481In3tMQeF6fwn03oudQKRqoN/3/pMVxq4v4lXdNj1FM8UCpmA0krLlWCKMve1NxjPQ3dGQIa8mQkwoY9HeR1cDBHIIksPL8gkghKBDH6rQ4Pvxtt2GqiRufzMlMdJ+GR0doZm6XB3zZ/fUuT52iwM34T9wohINs2c3Cv0/PxGZpp0Q5pQ9K6eXluuPoUzsLoFXNc1vpc6/0gljlDXOEkmDTqf7VunJBHqrCh8eGiLF1yRqGYtv1IlwSeN2wqWk0UUG2v7z4VQkibOGVocH2Z18ETmylJRK9ZkYpevst9fkAi6y3pA3VZP6SSl2GyfDluztcaoxvaj9+2luEv1MVGOGjWuaUa56P+7fhO/QicHNp8Jj2VoA/Mqle8pDLrXuI74E+UDXGUPgJ4+xQAIA+O8xukaDE3Wzjv6ZUM4OhwTV3qQIbfMsOhQUJ00N5+xb24GNKl0TAzs4gL/86TG6+yL8WC6FEjo1yISUQu5O6aSesffEv+o9EKZ3gAVWvDctx/nO9iO1mxfkcygMUfEp70cvVGJuSMCZTApFJPoRkIlLRur5I2Q0QFjTqV0RaYZ1RkjkyHh8ZwcBoF/8AuxcA22bQDyX8pdVmA1vVwkAhXpYnXfV4mAmNxPIBNqGoAwllUeYWrtae2oeLwcO9gc/Xp/ptqTdpzirPDJChCVeCYzRwjH/sMKu8agWKQ8wGdpsXRCiEHFCsWgEwj
 BwpLBqFl
 YdlOrTbaaG24mp+Pz/3SW5ErZ/UHJg+qjRZrv6p43CdLSfG+gNju+F/zsYnzdLOnx1NA8hJO0CmQHHFzuyUzerApSW5710Yice26K8FNBWONwcGa8lUBaZjPwgOUeDT+DUKWxMfMWCbcgvpriLOz+lg/iYDll3UeexJnnVPmjC+qprqwGW55yiolPzCA7abBl7xQvIn2OYM93fcoVFj0fn8O7euwiyc4D8p45vUBUViVITSvj+EX69LdVvBMOxmxslRIi/PGqsJhh2mq9BCyR40bRUKd3U2feyMWjsvxNxKKc4b+shYUK63siRMUKxxCwYh+7zxkTQRC3Pu8e/lH/sVPctP0URbnPoGKNwPRZUoHoEqZexxfdug9AFoRB9Khy5ZaIrxQumhUlxgN1tDz5POH/w0Yu5lEuE/Qs36qRtm7mUmXpiu2wdfooiCD/g4D5M9d4Qv85rmxLPNxbocWrR8Rc3k5bADLo0zdyCf01+kAZLq0NZ593egQdJZZjUGL3G0t7oC5ejy2aeQTc1/3nGDToMjvUg1MMJm+JK4ih6UySrC7g0OrRT9aSwqseotDpyn3shQw3+RsbeEuHfnNmPQ2OUWICzRpGhlwt/eobfjigHIQ07rlqLFO9Ndzx4Tw2ZDY/gcn1xt8JVub7OifvTARyUIRQVUeBJUWqMG45ZHl84RcU369Hu9kYPXW2AUQh+eaSS67WXXFntkSJ9JjP9VMW8pnt2aqDHTKlwfzHVLdQnn2M5txeeHXclrCJjc9ehs84sqpx6Mg7ADgxT1Cm/8xV8vaj1HcTLiFjRy6t9E1o28xfCsLPvdj7oas84pTF6R7P2oB1qG9dKTPg+K1faTwg96A2T+w2EJdV5FsGEEP5bnXe6aqj03QZImLqbJIaBdOln1dR5Z+2cxsmGpMFBrIKC+i0tZ21OZO5jDV1wbNOwA5VRQq6+nK0Dh3esNVeAim1gUDWNcQGpijJxdzJWQoPifER
 7caFg/ia
 gGOBfENhklqYpvqRbw4q2D0satzmHsHiQEa2rsp3f5PlRF3l50nLD/QnuW+UfiNReShnWvTwENpiSj49AS69UYagIwAvKbrwY8AKLaaex/BfgtnaWP4GNzPlHbvCO6ZT7I1mHe2hqb4l8J8yBONygFRny97QtpRcVLtK34ZXdtGjaZ841c5vvZSnGhb5XtvjaOpR6V6h8MOV6pSwPWk5FqAtThYDKwRlZ54MZbN02bL54XAeA5AJxDzdG9OagAIZpC0deEkdvVVRl48+OQzhSteqfMOTQbR+HFd55JOsaUu2lp3FndB0jBOJ2OBSYMu+sRe4UXv5b9IPjOvabARBoxTptBBLiF5Txrijgo9X3Fc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 20:45:28 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Compiler CSE and SSA GVN optimizations can cause the address dependency
> of addresses returned by rcu_dereference to be lost when comparing those
> pointers with either constants or previously loaded pointers.
> 
> Introduce ptr_eq() to compare two addresses while preserving the address
> dependencies for later use of the address. It should be used when
> comparing an address returned by rcu_dereference().
> 
> This is needed to prevent the compiler CSE and SSA GVN optimizations
> from using @a (or @b) in places where the source refers to @b (or @a)
> based on the fact that after the comparison, the two are known to be
> equal, which does not preserve address dependencies and allows the
> following misordering speculations:
> 
> - If @b is a constant, the compiler can issue the loads which depend
>   on @a before loading @a.
> - If @b is a register populated by a prior load, weakly-ordered
>   CPUs can speculate loads which depend on @a before loading @a.
> 
> The same logic applies with @a and @b swapped.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Acked-by: "Paul E. McKenney" <paulmck@kernel.org>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: John Stultz <jstultz@google.com>
> Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Zqiang <qiang.zhang1211@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: maged.michael@gmail.com
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Gary Guo <gary@garyguo.net>
> Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
> Cc: rcu@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: lkmm@lists.linux.dev
> Cc: Nikita Popov <github@npopov.com>
> Cc: llvm@lists.linux.dev
> ---
> Changes since v0:
> - Include feedback from Alan Stern.
> ---
>  include/linux/compiler.h | 63 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 5b45ea7dff3e..c5ca3b54c112 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -163,6 +163,69 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>  	__asm__ ("" : "=r" (var) : "0" (var))
>  #endif
>  
> +/*
> + * Compare two addresses while preserving the address dependencies for
> + * later use of the address. It should be used when comparing an address
> + * returned by rcu_dereference().
> + *
> + * This is needed to prevent the compiler CSE and SSA GVN optimizations
> + * from using @a (or @b) in places where the source refers to @b (or @a)
> + * based on the fact that after the comparison, the two are known to be
> + * equal, which does not preserve address dependencies and allows the
> + * following misordering speculations:
> + *
> + * - If @b is a constant, the compiler can issue the loads which depend
> + *   on @a before loading @a.
> + * - If @b is a register populated by a prior load, weakly-ordered
> + *   CPUs can speculate loads which depend on @a before loading @a.
> + *
> + * The same logic applies with @a and @b swapped.
> + *
> + * Return value: true if pointers are equal, false otherwise.
> + *
> + * The compiler barrier() is ineffective at fixing this issue. It does
> + * not prevent the compiler CSE from losing the address dependency:
> + *
> + * int fct_2_volatile_barriers(void)
> + * {
> + *     int *a, *b;
> + *
> + *     do {
> + *         a = READ_ONCE(p);
> + *         asm volatile ("" : : : "memory");
> + *         b = READ_ONCE(p);
> + *     } while (a != b);
> + *     asm volatile ("" : : : "memory");  <-- barrier()
> + *     return *b;
> + * }
> + *
> + * With gcc 14.2 (arm64):
> + *
> + * fct_2_volatile_barriers:
> + *         adrp    x0, .LANCHOR0
> + *         add     x0, x0, :lo12:.LANCHOR0
> + * .L2:
> + *         ldr     x1, [x0]  <-- x1 populated by first load.
> + *         ldr     x2, [x0]
> + *         cmp     x1, x2
> + *         bne     .L2
> + *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
> + *         ret
> + *
> + * On weakly-ordered architectures, this lets CPU speculation use the
> + * result from the first load to speculate "ldr w0, [x1]" before
> + * "ldr x2, [x0]".
> + * Based on the RCU documentation, the control dependency does not
> + * prevent the CPU from speculating loads.

I'm not sure that example (of something that doesn't work) is really necessary.
The simple example of, given:
	return a == b ? *a : 0;
the generated code might speculatively dereference 'b' (not a) before returning
zero when the pointers are different.

	David

> + */
> +static __always_inline
> +int ptr_eq(const volatile void *a, const volatile void *b)
> +{
> +	OPTIMIZER_HIDE_VAR(a);
> +	OPTIMIZER_HIDE_VAR(b);
> +	return a == b;
> +}
> +
>  #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
>  
>  /**


