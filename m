Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19726D66BA2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 20:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B866B00B8; Wed, 17 Dec 2025 15:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 039D96B00B9; Wed, 17 Dec 2025 15:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D9B6B00BA; Wed, 17 Dec 2025 15:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D33086B00B8
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:23:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DAC0137255
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:23:51 +0000 (UTC)
X-FDA: 84230089062.07.F615222
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id B296540004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:23:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CIkmIv0R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3VBFDaQkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3VBFDaQkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766003029; a=rsa-sha256;
	cv=none;
	b=kb76De4iC6XhsNaXhAO+A/VB3V+azIwAHAROkvdz7NtyFpCDuFMKT62Er8g/6pGBwaLHiI
	lZ9WVFdIIF7YQhkAB0iUEftteQjJUKBwKg3fRPIz4ZVY0n3lIvVtTUIopTM1Db36LAOM4u
	kfNU3u85JVytpP50tPT8W0Lkzc0UQ1E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CIkmIv0R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3VBFDaQkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3VBFDaQkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766003029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDhEke3Pf/QosbPquaV4OeIZU/HBm2+1j+nd/s0NsM0=;
	b=wF7p8R7le8Kqd5P5+HvYLKD4eTI07/bbJMkQj1PMkbq+xbivTzQd+ccMQzLfiZoQ5erj+q
	t+bTTGDG+h6euv1q0Sx4kUigrRUcbb5bUOvdPCtbB3XMiU3xjkmvFsDzZH0MMdOPfyx5tx
	mwwzoZO27MsVp1DZw8aprVAJszRBXT8=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430ffc4dc83so2311519f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766003028; x=1766607828; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDhEke3Pf/QosbPquaV4OeIZU/HBm2+1j+nd/s0NsM0=;
        b=CIkmIv0RBf+OKEz1s7Niaux+7GkfU1CU7bFJsBmAAJmKPya/X2DuzrDUVGKnXubGgg
         Yq0zg/LTfga8/uTLORUMgnkGvZLy16BP5hPblTU8Ao0HLQ+yvIy/U9CBANgyRutagZrc
         av2H2qSDqsoSOPMBjag34LzIT8AaBO5/DK+5Rxn+mGdsV0vJc4BlRAmdVRn+prPcDxqm
         I8W/j4petcVrIGsPHNDhzOYqm9tjgCbdAbfe8Y7RArlK7/kTem1LCi1Fea0h+blnPAfo
         sW98tDVYKDCXSQJfen9FB+ntopuuNAFxYx3WrCFsn9OHzgnLUCpjRfOJQRttQvKmjJgT
         /TaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766003028; x=1766607828;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDhEke3Pf/QosbPquaV4OeIZU/HBm2+1j+nd/s0NsM0=;
        b=WRHDbe0ma7ySLO5R0/Kj95K/bobI2oxMeCYT+Ng+1eZ7YNEcqm9SyG5VwiiTw/KnLL
         POyohinf5jvKy24aFsaUX1CAvosNI7TDt+KdJPGZ95ensT2IKblyeCkU0KL8G4vxyQ6J
         0Z7p5Z+SCBE8ip8KR9dIzTndRf3yNmn7yMF1B6ovT+1qkNoI7lNPptFN9xKAUpbrL1GP
         68rBXfQ50mhd4uN7+sepDBmK/MQfVGkFYn2/37ac/ke/LOpTIiTOHIZDW8ZKbeAc1Cva
         LCVnwkQCT81EWw5jCE2D4KZQQtgaxm1A8ylSeN1wTZwalUwFphUJdQQJem/lqLyVG0rk
         2KWA==
X-Forwarded-Encrypted: i=1; AJvYcCWo5hsn/yOd8fUDExydLeWROtzDY+dtskyIkfr9tWhhCkVv+eG/Nfsw+sYdc/ADhg2z5TEvg9SU4A==@kvack.org
X-Gm-Message-State: AOJu0YzbpzXt3stOq7pjs3lFy3mCWPoga9ddgd3ZTOAq06E/6vCJyfwm
	TYxgAI0VDGhysJcKZicAEgudruBJERO3iO6ofEsIij0vhEO8Sm3O0yZZyW2qzpToAFC96A2ZgeT
	vrPvFosG2aYglaHoZeQ==
X-Google-Smtp-Source: AGHT+IGe1YKA5nJYn157r/8t+8P2Lqp3XAQpgh8jYBuoKq5Q9ybBqIVF49axwtfUPOWQ8rlRijN6+2u3mSKJ2LU=
X-Received: from wrbgv21.prod.google.com ([2002:a05:6000:4615:b0:430:f87c:654f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:438a:b0:430:fa52:9eaf with SMTP id ffacd0b85a97d-430fa52a19emr14329354f8f.60.1766003028201;
 Wed, 17 Dec 2025 12:23:48 -0800 (PST)
Date: Wed, 17 Dec 2025 20:23:47 +0000
In-Reply-To: <rfpdf2suobpchpuw5gqzgivwvon2kd2cub5eltvbburnsus2iy@j26cinzdxxnl>
Mime-Version: 1.0
References: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com> <rfpdf2suobpchpuw5gqzgivwvon2kd2cub5eltvbburnsus2iy@j26cinzdxxnl>
Message-ID: <aUMRU0yKwQVDuUnZ@google.com>
Subject: Re: [PATCH] rust: maple_tree: rcu_read_lock() in destructor to
 silence lockdep
From: Alice Ryhl <aliceryhl@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: B296540004
X-Stat-Signature: c8wirzjbddw5h7etyk9pzmq6a3nqxpwb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766003029-347512
X-HE-Meta: U2FsdGVkX18MvWLeeJHcZnHXjJwFLrW1Ap+auWXVaWENO3Iwy0b7di3kLI2vzPilY1ICjiyKJrbPZTGn+gGrYEKkHVWY+dI7mxPtJkH96Pe1iR3DAFHhwWFCdk4VEgJEjIALWaygIfyPD5h7grIMtkDqP+vGkdyjNHvrhF29h+QYynCZp9DXxoxGjUJi6ChElErkQIcEhNi50Wjakd/foZfbpiTmSipyQuoxxnTZ5ahrxISbwalAP3oGevndIDAlxB4bH4zB7SrkCe+Rcq54bv9N69BRU6eJyJCM3DgwmG/ZkwKMskaBXK504/1d0jkXifLOj7v254d3avnGLaTVKshVh2b77q2U+wxCeSpVO/dsormAgZPz8Y5INrqWB0m00Hjf4xMzO8JMSztcvFXl3qBWLRiwpEemPRpTJ7sM9eF77dUE+f1NWoks9FZJ+rid1H+2zjKLmZgN4I6doneQGcMBSe4lJ/EdoUrvE04YzePzO83HLFOBWzyRza7/9aK+xjdDvj75fewg4y99Uc1ZtF1C1HvQAkPj8lp+dM/W7fQQC2LZMMygYUQs3kP0a5OjDaWZc1JwT21s3HImvgL9ENzgnhisAwJFugZXMKIsv86j46qYVFthzxOh4Y/mYbWM/xal+YnWsd/JU1GvyfA4jEGIAhDRJUZ2cM485mZkUJBuu4sIWeBiv5xl24+lfNY8WYzkaoj2MWs1PJHWl+Nq723iXRD+5p3f1UBzw/AfVRuG8sRx8hEM7MmS9SM81mmRhydKv6yvp4V4GE8qgp5w1r64yxW+9ASqLmfEpYbaU78Cf0m0tnhFIznfy32ldP1UkcwcYohXMFnRDOC3dDY2TTs9fhgLHCF5qTbAEZKHZ5OJeSaQzLyHM+vdAVN4+vLYNZ7jgu6agyQfE1KFt2GR/Qv3bZ2QO6dk1rekVe3q5aqqmKZyHzGyREmMoYiSlldhwhTN6zrt40Ae471iEyY
 oqpIKLcB
 r8DS05kqekk1SUdU0wnzwHYkfl/87Y2LM3+jpS/CLP1ftcV0rtwyHiqaBCICaBRxOmOxM3wNSDeBUhVYD2BkzqZCX8q/epa/Ub2mDdRYj6mSKEDWgCGgUUvQuIjc5hHDuVhNqVPSDDd16H0CoL8VduZw3C+oRWHQ576Qe/eS6p9YqMgpwPxNtPBybmaa3OvO+fZ5Q2cCaCAlJKsWyOtAK799lpeN77ULg+/P5J56HWB+8U97TGYW1xB1K6SPB8R1bM2zCN44CuCvVp00Ll5xeM4r1yGCYywzqkA2K20Brsp4vPavFK9xodvb6KZF67VDjlkLZ8QDjh7US6LKdreVpPhaI7esQ652nlLJf4Se396Ipa5NAbN1hObDvaCtPokTTtlrq0WQWIQ9HWQfJxxTeT51o3we90cEMXR81g7M3uV/RJZ+Eq3lNsnNugmhC85QKbYXx7jG+/zZu7MKR+S3aSuwlAnoffhpTmPvPWJpIpviUskUoKhc3ZUlxpwUAHPeq7T6/tRPSOzsRHfMKA28pjt+5uVgghwzjBlysZgE3gQjnpwKMpshB1QBW9MrSxiorFMwv5/K5mJorJIddAnq0oo/xqjvb+98bJiGlgUg8Hx5V946w8n6705o3lqq/CB6yntTVFreXwBqrYHARJPbvitjAOtsaAfMc7mTwjnb0ZB1vFjs16DPVnTcf7NpWN4BLMzJxGMpkAr/ZhbxWWk5a/tqGICw9YbhFVtjVVcr7VfY5acn2xcfqnMylCVxuB5jv2fjEvr1X1lzLAAZh/qaCJXNe+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 02:49:18PM -0500, Liam R. Howlett wrote:
> * Alice Ryhl <aliceryhl@google.com> [251217 08:10]:
> > When running the Rust maple tree kunit tests with lockdep, you may
> > trigger a warning that looks like this:
> > 
> > 	lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!
> > 
> > 	other info that might help us debug this:
> > 
> > 	rcu_scheduler_active = 2, debug_locks = 1
> > 	no locks held by kunit_try_catch/344.
> > 
> > 	stack backtrace:
> > 	CPU: 3 UID: 0 PID: 344 Comm: kunit_try_catch Tainted: G                 N  6.19.0-rc1+ #2 NONE
> > 	Tainted: [N]=TEST
> > 	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > 	Call Trace:
> > 	 <TASK>
> > 	 dump_stack_lvl+0x71/0x90
> > 	 lockdep_rcu_suspicious+0x150/0x190
> > 	 mas_start+0x104/0x150
> > 	 mas_find+0x179/0x240
> > 	 _RINvNtCs5QSdWC790r4_4core3ptr13drop_in_placeINtNtCs1cdwasc6FUb_6kernel10maple_tree9MapleTreeINtNtNtBL_5alloc4kbox3BoxlNtNtB1x_9allocator7KmallocEEECsgxAQYCfdR72_25doctests_kernel_generated+0xaf/0x130
> > 	 rust_doctest_kernel_maple_tree_rs_0+0x600/0x6b0
> > 	 ? lock_release+0xeb/0x2a0
> > 	 ? kunit_try_catch_run+0x210/0x210
> > 	 kunit_try_run_case+0x74/0x160
> > 	 ? kunit_try_catch_run+0x210/0x210
> > 	 kunit_generic_run_threadfn_adapter+0x12/0x30
> > 	 kthread+0x21c/0x230
> > 	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> > 	 ret_from_fork+0x16c/0x270
> > 	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
> > 	 ret_from_fork_asm+0x11/0x20
> > 	 </TASK>
> > 
> > This is because the destructor of maple tree calls mas_find() without
> 
> The wording of "destructor of maple tree" makes it sound like the tree
> itself is being destroyed, but this is to do with the stored entries
> being destroyed, correct?

Yes, it's the destructor of the Rust MapleTree<T>, which performs a
mas_find() loop to drop each Rust value before it calls mtree_destroy().

> > taking rcu_read_lock() or the spinlock. Doing that is actually ok in
> > this case since the destructor has exclusive access to the entire maple
> > tree, but it triggers a lockdep warning. To fix that, take the rcu read
> > lock.
> > 
> > In the future, it's possible that memory reclaim could gain a feature
> > where it reallocates entries in maple trees even if no user-code is
> > touching it. If that feature is added, then this use of rcu read lock
> > would become load-bearing, so I did not make it conditional on lockdep.
> > 
> > We have to repeatedly take and release rcu because the destructor of T
> > might perform operations that sleep.
> 
> The c side avoids handling the life cycle of the entries because we
> really don't know what is required.  Maybe it would be better to let the
> person storing the data handle the freeing of the entries (and thus the
> locking)?

The general expectation is that dropping a container also drops anything
contained within it. It would be very surprising for a data structure to
violate that in Rust.

The end-user is always welcome to use a type with no destructor if they
don't want the mas_find() loop.

Alice

