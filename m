Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17768D6ACDD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 16:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE3B6B0095; Thu, 18 Dec 2025 11:12:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351B76B0098; Thu, 18 Dec 2025 11:12:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A746B0099; Thu, 18 Dec 2025 11:12:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F38C6B0095
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:12:37 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D2EBC0224
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:12:36 +0000 (UTC)
X-FDA: 84233084712.25.4842A61
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 401DE40011
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:12:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=im+RbLzu;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766074354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MWV/1Pvi/LREO51Q4j2bYTzBTPFXYl3JU+RoWaS0a6Q=;
	b=Ft94b/nnVd8E7vnanDOEAh9s8sP2yfOK55Jk9VNdAvsGbgVxYXLmsZq3VarwagB2+oE6fW
	YlvrM40EmpE9Q9EVGt7hcisuiSXEg9IY8AoSTYQi5OsJdVQKGUz/lWt0xQD8ikSUlCif2m
	TaX4H+02ZxCBg5LefRcvCWj6W6XdBvE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=im+RbLzu;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766074354; a=rsa-sha256;
	cv=none;
	b=W7q+ythQVIX6EWmKv8LJLcfYFLjYKwWqudDpuX952EzOxKJMBbn3yxaUhzMi/NfxwQhSLV
	rIPVFfddX9K4dAkezYHo4pvcg9lWypZV2xDExWEZP8JPA/rlocSDDtvLqvKIMIPTRrGaxA
	lPBSv/VuEUkHB6XzScq5ceK+3JCUL7I=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-431048c4068so507865f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766074353; x=1766679153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWV/1Pvi/LREO51Q4j2bYTzBTPFXYl3JU+RoWaS0a6Q=;
        b=im+RbLzuln94KzGxZMu/7PlYsYzzs7RK4fSBObRODYHH42p4BfB5I1PFPVn9Hp5hu+
         ZE/w5kPAyk8cCrfTGbwNrCvykxOVnNob+FccvSuVZAl9rXMzj80H7iKL1n5SmMLQFazz
         BfBhdWTHfEBpf9TlZq3rCaW9wyX6g5w8xrM43/q96OyQ7tijRYwQdA8hLv7jH+poBml5
         jrKTMKO1lZk2QFp7bhLbXsQbsTeE9fa+Dvz4moDJBXiHL6HARhI4EPW/ElF32zPBxmGP
         cmSgUxECLCRQnCW/80RNMQgTp7t5QmbyWUo5aOMHrAb0NZQdsJPw4gE6tOpaWhN8Lhnn
         pB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766074353; x=1766679153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MWV/1Pvi/LREO51Q4j2bYTzBTPFXYl3JU+RoWaS0a6Q=;
        b=TFzXoCZyQwEMXb2FWXfxO9im+VwKwdTxCDfzydped/W7i3IRpTa07bB76dIoVxsizW
         EnsuNlaqomFmhWuiGfi6EbjcfKLSZ2HIg9MbvQMs/fJtwR/4321+BimVDMYVvtkkHW3X
         BQfjBJfM0LEu1Rr9MOJRdvq3MXumtVqDwchJpWuVB5V6TCXcLIftYMvY1dxRiISYbrfT
         pybs35zXikbgoGN1ATpaiw3x0TXX6VwW+QXBVRJnlICbAeE6Zr8X8IIdcXlT/8rVLZuV
         fhItBebi+5SiG3OOupAiOQbJv20AtdVgvWXAiW2vQ4qS33Ib6YTJytn8P9L1sOoqcFrK
         UGhA==
X-Forwarded-Encrypted: i=1; AJvYcCVwgDXsjSDi2TYWSsBVpP7oAOLe0tdhq7q6EBTQ6S1NvNLpQABts8+huUCbxULvY+15PP4nYxSeng==@kvack.org
X-Gm-Message-State: AOJu0YwRy6g68bqNrugqbwPq62SYi5aHozc3XtaEzXAJ4xuYla1k9RvP
	3wmkM0rtkHra8ZFzLKwN+lhoaHwQmg7SNn+8FBS5RDPTYxjpKjSxec6Y
X-Gm-Gg: AY/fxX4NVtzNzKwUvPRLYocRdf7r+GYCE5tGj0ePVbPCBUdBY7woDpkrBX+beMm+QtN
	rLB/MTyQuv6Uin8aotCjWHoXoxEDUZdp1XrLHUOSU7mVW9zehw7WgQi6UIdfBa/Vtx4akiJ5d0U
	qgJygiMxxI+QiBQrtSdv6p1mdSbOxPL5MvM1Zb9DAAlQIu91tri89NJ2JzYd5cMWAhD0FcFYW7A
	hfHotp0nv7wFTBU0/D031vpxyg3gCx4ZSce5DsNIkwCy+FaET14usg9jUMb0rSck8vTs0+HE/59
	ufYRCAm+tdd0fsgqhBeb4tU24cxkJ/uawsiqAt357WstYODr739tFWVq+13F2lTTf83G9AzAMwT
	oq7tKDcCkhXnrcrGIxJ0RRT8M3k76CL1ILXDbRMQJNcnjU3+0kLGp4lwRB8oJQ/qnxp8erHQGCu
	Cmj7Ow8sM4dlqa/STpi1zsnjgRXkSIXv47aNJ7Tcsy5r+aiiUFpwQy
X-Google-Smtp-Source: AGHT+IF9IwYAhi8+6w3+wxW3M7gEiPdh7t/1OgDyx7SiDKnto2Pyh4pbz29WYRXhF76RKtErZ/OMCg==
X-Received: by 2002:a05:6000:18a8:b0:431:de5:93c7 with SMTP id ffacd0b85a97d-4324479535emr4292777f8f.2.1766074352470;
        Thu, 18 Dec 2025 08:12:32 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432449986f1sm5781954f8f.29.2025.12.18.08.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 08:12:32 -0800 (PST)
Date: Thu, 18 Dec 2025 16:12:29 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Gary Guo <gary@garyguo.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Boqun Feng
 <boqun.feng@gmail.com>, Joel Fernandes <joel@joelfernandes.org>, "Paul E.
 McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org, Nicholas
 Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Sebastian Andrzej Siewior
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
 rcu@vger.kernel.org, linux-mm@kvack.org, lkmm@lists.linux.dev, Nikita Popov
 <github@npopov.com>, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v4 1/4] compiler.h: Introduce ptr_eq() to preserve
 address dependency
Message-ID: <20251218161229.767dafbf@pumpkin>
In-Reply-To: <20251218142736.464b7a4a.gary@garyguo.net>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
	<20251218014531.3793471-2-mathieu.desnoyers@efficios.com>
	<20251218090313.33923750@pumpkin>
	<20251218142736.464b7a4a.gary@garyguo.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xejwssxx7kej39tfjn5yu6knutck54wo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 401DE40011
X-HE-Tag: 1766074354-884873
X-HE-Meta: U2FsdGVkX19LvkvFd4QA81s9KPMRRizJGrXXv7BVMdQJncptQNTRBVlzQwNE1IVOv60rWzibt6AOEZhoXb10Gsx2llc4PrKQ7yAnkf4EmY9r3dxgid/H2KakkpUgEwbUYR6lDdhFAbDBoLlt6M2KaeYzY2DhyQKArtW+HDqCF0e3C4PhRp5O4UbyjQzI10LR7E4aC6TOwGeS5zyi+SGR6iGmR2dxLy+wlYrj/mL435SvMoLms+qRL5x60KtQ5dDnptlhVx7hKt+cwRIm0VRSX4jhb/xWjkvMHjfgjvgst0JV+KcT52ey8XOmjSQyYiNmfghwkfCKwILPwpbaruY8kgJrB9avBI2R/lsVzYXSIeAlym7mOsikD4PfDZZgHn7BiKX9hUeEZ4T/KuV7s9OQuawvUQV8gDUdyTDBT62ktJYqidAtu01z1K/AXKAx69rxUXnWtSr2GMkuf6QkUItNxln48NIYr0E8De3akH8P+9HtRidKQdqjjqHO9krnZbjIGQMlJe2RwVfQJdybGJfBB8MVqpZLC1hyQK6V76JpVtCDszdNheEdoT9Hgv8vM9r78tToVVmJqQW9UPU6Ahce8y0b2E00JkpZY9m9zj/7ndCQp0P6CENcxfxby6Z6l7BSAEYEWJlCZdPaSVAlA9Eii5Wde4JzlI+XvsVFBqkEejdxjAk8+YQXrwshjnrNkMV7bUAwdnHs2fI37XrMyCyqgp6lIgDa99AnOY2o2m5tZ018lSiHlhcCyyIEl9lwpQAENIIMWACT2tjUKjqqDVLY5Y9U+ohDVhy6ZZaTyMvtRlCexnUkjuEzLhc7CTiIOUmm1gEkLaFdMay72Iw6tGYtVDasbifWauk4JLnQJoQ1PUscG7WztUtznMNCWPkwns7muVTkMDp7i6YwrwWsBEWPwugFbehTCcYf6UkYlsrDePPWKJjti5ZpMJsOLRQwO/oYKuumckpC5Su0NM1Gaux
 lNwQcwxc
 2MKvb0qW23L2NWMOU7wpF2l2JTwLBK0pKXuRyvx40AdFzrp7w/AmYO8d8Kds8+ySU1CkMzAjyZSz92Ya9n2emb2GUx7oBJmsqVpcnoOM5p4xnyjjddyOYUms5S2z1mEP5UmgWUZzrdddncuGbS8dCF6nVj1IsNTpcW5j8ZKtTk9FqFoPN7SaUJa8PQxB+XNP601pvt+bnSeZHuFo2MQp/9+kFre/GvEEOu9RTz19pVRdYp2N5yWeTCowWrsk0gUn/t/jj6wwRhN9e/LYCITV3AZvuCOMphrOEYNin2ZdKhus4p7tRZy4DKYxVVRM2DQZ0xx1c8gdBIqwEg2krUUUrmNNXh8FA5bRF9WJBZEZMHXj3cQWpGSjk8EpAlSduAQ70x5TGqujCasLi1eTW5O80GUcMJMwsGENsfV96IFnxV7T2bLIT0XTiR1cvkOtw7imrmOgP0Dy8DHfzNAyDGNq1+IHvt1E7vYGc3rmRs086MAnBrTriRoBlw8qbf+X2f6ekSny/S77Z0qA13D7tRieudSthNKqNbiVczlMR+XjesdtxGblQymguBrV6HgtQAgeEBXYvLD1QMp49rocoJiAnunR7DS4Hb7VYaJTjQokubWnNJnL3NNZQAqDfgFIIwM73G1ehyboblHQJkb9wKxBFyWnfuTKbgHOtvTO+13/VYUP66UeDzc9bGP45/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 14:27:36 +0000
Gary Guo <gary@garyguo.net> wrote:

> On Thu, 18 Dec 2025 09:03:13 +0000
> David Laight <david.laight.linux@gmail.com> wrote:
> 
> > On Wed, 17 Dec 2025 20:45:28 -0500
> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> >   
> > > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> > > index 5b45ea7dff3e..c5ca3b54c112 100644
> > > --- a/include/linux/compiler.h
> > > +++ b/include/linux/compiler.h
> > > @@ -163,6 +163,69 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
> > >  	__asm__ ("" : "=r" (var) : "0" (var))
> > >  #endif
> > >  
> > > +/*
> > > + * Compare two addresses while preserving the address dependencies for
> > > + * later use of the address. It should be used when comparing an address
> > > + * returned by rcu_dereference().
> > > + *
> > > + * This is needed to prevent the compiler CSE and SSA GVN optimizations
> > > + * from using @a (or @b) in places where the source refers to @b (or @a)
> > > + * based on the fact that after the comparison, the two are known to be
> > > + * equal, which does not preserve address dependencies and allows the
> > > + * following misordering speculations:
> > > + *
> > > + * - If @b is a constant, the compiler can issue the loads which depend
> > > + *   on @a before loading @a.
> > > + * - If @b is a register populated by a prior load, weakly-ordered
> > > + *   CPUs can speculate loads which depend on @a before loading @a.
> > > + *
> > > + * The same logic applies with @a and @b swapped.
> > > + *
> > > + * Return value: true if pointers are equal, false otherwise.
> > > + *
> > > + * The compiler barrier() is ineffective at fixing this issue. It does
> > > + * not prevent the compiler CSE from losing the address dependency:
> > > + *
> > > + * int fct_2_volatile_barriers(void)
> > > + * {
> > > + *     int *a, *b;
> > > + *
> > > + *     do {
> > > + *         a = READ_ONCE(p);
> > > + *         asm volatile ("" : : : "memory");
> > > + *         b = READ_ONCE(p);
> > > + *     } while (a != b);
> > > + *     asm volatile ("" : : : "memory");  <-- barrier()
> > > + *     return *b;
> > > + * }
> > > + *
> > > + * With gcc 14.2 (arm64):
> > > + *
> > > + * fct_2_volatile_barriers:
> > > + *         adrp    x0, .LANCHOR0
> > > + *         add     x0, x0, :lo12:.LANCHOR0
> > > + * .L2:
> > > + *         ldr     x1, [x0]  <-- x1 populated by first load.
> > > + *         ldr     x2, [x0]
> > > + *         cmp     x1, x2
> > > + *         bne     .L2
> > > + *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
> > > + *         ret
> > > + *
> > > + * On weakly-ordered architectures, this lets CPU speculation use the
> > > + * result from the first load to speculate "ldr w0, [x1]" before
> > > + * "ldr x2, [x0]".
> > > + * Based on the RCU documentation, the control dependency does not
> > > + * prevent the CPU from speculating loads.    
> > 
> > I'm not sure that example (of something that doesn't work) is really necessary.
> > The simple example of, given:
> > 	return a == b ? *a : 0;
> > the generated code might speculatively dereference 'b' (not a) before returning
> > zero when the pointers are different.  
> 
> I'm not sure I understand what you're saying.
> 
> `b` cannot be speculatively dereferenced by the compiler in code-path
> where pointers are different, as the compiler cannot ascertain that it is
> valid.

The 'validity' doesn't matter for speculative execution.

> The speculative execution on the processor side *does not* matter here as
> it needs to honour address dependency (unless you're Alpha, which is why we
> add a `mb()` in each `READ_ONCE`).

There isn't an 'address dependency', that is the problem.
The issue is that 'a == b ? *a : 0' and 'a == b ? *b : 0' always evaluate
to the same value and the compiler will (effectively) substitute one for the
other.
But sometimes you really do care which pointer is speculatively dereferenced
when the they are different.
Memory barriers can only enforce the order of the reads of 'a', 'b' and '*a',
they won't change whether the generated code contains '*a' or '*b'.

	David


> 
> Best,
> Gary
> 
> 
> 


