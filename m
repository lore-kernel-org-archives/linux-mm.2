Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFDB3606A338
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=mosuS/Sa;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=IIWOiZyK
Received: by kanga.kvack.org (Postfix)
	id E68746B09C5; Wed, 25 Nov 2026 06:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3F2F6B09C7; Wed, 25 Nov 2026 06:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C9B6B09C8; Wed, 25 Nov 2026 06:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6C0F6B09C5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:37:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B36140EAB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:37:16 +0000 (UTC)
X-FDA: 85473440472.13.4CE0065
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6ED2918000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:37:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="mosuS/Sa";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IIWOiZyK;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795606634;
	b=yVrQfYQdSWalh86ysDWllMuYLqHRJsJnY3w0ucZ7FHKlWLc74+7Cx5FPrAq2QY5V4hwKs6
	KAgVMg36REPRtFZuHb3WBbCicjjOOJx5+73Ai0D5JR38XyY4y85af8EHLTIijJasXbBlJ8
	EN8JE4FIyzzqmP28aAy0vA8Dq/85xaU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795606634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wBVHYYIzQigIlGlhL1E2SXD/0Foprhlk3jXCBGc+m8=;
	b=sMUy0PF8OVjFQLedPs5u2URdkCobRzGxE/R9XwJZm6DvLjbECjGg4ukC/T0RS4ZY1WUUD5
	3P7D4Al96RLQbfGw6ol+HM3sVXajFtPsCWLClkVKcgjLl+i5zf3RqplsyJkcOJRYueTmPt
	AG9w1KOM/r9H3gfZfmg0tQJB5R5ORLc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="mosuS/Sa";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IIWOiZyK;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf06.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
Date: Wed, 25 Nov 2026 12:37:10 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795606632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8wBVHYYIzQigIlGlhL1E2SXD/0Foprhlk3jXCBGc+m8=;
	b=mosuS/Sa03uu1p81hdm9daMU/PDF5wTebZtdy20GzNq+dQs7zU+fhXhPEgTtO49vSbrkiR
	F9OEQgUmttIicOFWl4TAIf4fE1TSLxFSidGP6ZH+JkQwARXzQwGQjGNRSSwFqRyVPBssZG
	4vqcI9rSlOXwZjIyJb/hfHn2X+zZfduVKzVrMoAkoXWqtyNeqfM89ZmV93F+y7FPGPrmh5
	ao0DHWYr5+Pn3g0Gn+WHb4FyqO84qn/zL9S5szQ98QKr56F2uZUV2eNvmLOuaWmMoMl8nf
	wbTSoszajn4bu3INy3TUU2NMUHLqRMr3GFqlw188OYFYq4FCWO3A0xLOYZZuNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795606632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8wBVHYYIzQigIlGlhL1E2SXD/0Foprhlk3jXCBGc+m8=;
	b=IIWOiZyKXQlj4MUc4m9j0OcIvLx6Bi1XM+/DGMN88DCNc6MBcMgKqMoPgvt2TdwF5Te/2M
	TPmm/ck41zKpkhCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jiebin Sun <jiebin.sun@intel.com>
Cc: akpm@linux-foundation.org, dennis@kernel.org, tj@kernel.org,
	cl@gentwo.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	clrkwllms@kernel.org, rostedt@goodmis.org,
	linux-rt-devel@lists.linux.dev, tim.c.chen@linux.intel.com,
	tianyou.li@intel.com, wangyang.guo@intel.com
Subject: Re: [PATCH v2] lib/percpu_counter: allow concurrent sums with an
 rwlock
Message-ID: <20261125113710.Web5Cy2z@linutronix.de>
References: <20261124051952.1059282-1-jiebin.sun@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20261124051952.1059282-1-jiebin.sun@intel.com>
X-Stat-Signature: on9dpzz4ymytxgomiwx76cuwoo41fgoq
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6ED2918000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1795606634-356399
X-HE-Meta: U2FsdGVkX1/Y3Low22WlnFEIoMXbGdd4y5RHVeNL9+dt5wurbhVzgAD/I75kK4I49mI5ttMn4OFw7T5pEE5NbaEeMEesFU2gG/f/q22w2B56JMFIhIe3D05zmxqbGBzN7U3w3/aP6B7eB8eI9k+K9Cay4QJDf3RxQzyZYjbbamX9oqraTHANFdxh/Svyu2RVuy+J/0LYrnmiXOfyUoYYOKY2nujQdBk1fDjmQIepeWucGZ/mX8TkS2Z5PYzNvYhgv7J7HI6MDYs/vOfrX/TUA/4k6t0iLFrJhb0QAAwqCJBFPCzO2DQR9+6i0MvMSOtFM5YJrcsiGdtKKWhkZp2tyHClmQSRKJXcF1qbNclmhmWkz1Lyq+naNYGlPeei+RXY184EX2g2WG7n+GfxxTMSUgxW/H4HCK6vqP/YdCO59/NGvVgTWumdPuAMitt06DnZ1PhY09hf3WPsiwWZRhuXJm6B9yISSrF9yAJPtn3sICdOs/Cc49sfscTx2tQSear1ud9f1NulfmA4ZlMwVaPMyVheuFS7WVfRBrkBnqc1SiP6x4/Dgz95J83oj5529R/MzaHQg8vTFXslaG08czzRSrvvilHHxVwy9K3agH92zAkoB31YvPsQPu5xvFBt5bn2I4lza9YefiivlK2bp9NiJzVqWxaXBIKvV9+soQkpq5GjsTSh2mFzsxR6dz7wiC4jSYr2D1Cb2W+FBoRx8DpvvCMLjyidtcHd8AtE1kyFFKYijY1jo2Gsoea+dUjqJ5xNycXSw6g84ouGAwIejEvxJJYPm3ukIN3kfUEHYazuharO+5kW8NEZ9vg1RvihEc/dxgWIdtIVMmOTD0pk9lPosVPACpP3j+XuvNYDOpxwO9m4Edz79DI34Opw0y7ypWcW31WGnp/eElgGpS9dECHQsg3r1qVggdtuBBCrxu3DrcNgFHdPYmbmgMAGMKuEmCQSjcVcrmRDYtWUbwwi/I1
 7AGLyPWn
 6qeC6uD3W/6UCe8CL4jJYfqdAWIUj6oJE/X/PTLvLd68lXb6a0FFaunFXLGLMW0Prg1sa/r6uTwO2/x0+IWQY46NyYDQWmfUOJGZLEKn2Crg0/2wIAmhFjRBjrO4k5K8lGZwByJFXeCQUf/3/6mzP7Z6dRtQIv2h5blmw2AxGKHkfAKJSTVQMS39dK4UHsM6Hc9hC8QQghwEBPODy7hXlY6u+GSsIdONmwHH6ZGYMXpJpO3uxdD6UrPjzWOd48htCwOcDB3rivfRLRORON2yIMGeQcqqOS3p1cJAISIoHxmoU0DrPPoSmq4Bemhx08ph/21d1FtLltoYgG8PKs3V8i8ys3uOrW8ecx6osne0A4i3nQrZ3UOsNI4DVhGaxwKXrh1VQkvLwHfN3753ga+Knexu2KBgCvHEihY7QQi/jgTxKBVws6FtjJR219rNxeCWWlZ1ja3PMezWlbPffyjBWR4wJ8CMOLf6jVI/kjpSYBpsPN4vcqk/+vVZcnzX0eSIUPDsZv9/YlX/Yp05y/3D6MvImFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-24 13:19:52 [+0800], Jiebin Sun wrote:
> __percpu_counter_sum() holds a raw spinlock while reading the global
> count and per-CPU deltas, serializing concurrent sums of the same
> counter. Since a sum changes neither the global count nor the per-CPU
> deltas, use rwlock_t on !PREEMPT_RT to allow concurrent sums with a
> read lock. Global updates take the write lock. The per-CPU fast path
> remains lockless, so sums keep their existing snapshot semantics.
>=20
> stress-ng dentry reaches this path through ext4_statfs():
>=20
>   statfs -> ext4_statfs -> __percpu_counter_sum
>          -> native_queued_spin_lock_slowpath

Not sure if `df' is considered high performance.

=E2=80=A6
> Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
> Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>

This is fine from PREEMPT_RT/ lockdep point of view. So
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Whether is okay from actual RW-lock vs spinlock point of view is a
different story.

Sebastian

