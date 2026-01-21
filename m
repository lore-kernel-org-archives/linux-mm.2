Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36263D4694E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 15:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0126B0088; Wed, 21 Jan 2026 10:58:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847106B0089; Wed, 21 Jan 2026 10:58:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772FF6B008A; Wed, 21 Jan 2026 10:58:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6708F6B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:58:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C42361B0113
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:58:32 +0000 (UTC)
X-FDA: 84356428464.05.A457008
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0CF6A40007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:58:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cq7mrmYa;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769011111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAtR99RzzMhEMGZz3MTLfQ8d5R8YJtN/8eCQLKsHhiY=;
	b=Nq8XygamaIm20l7gS6bqUkokju/+rDW+hXLOJWfNQy5mFaBYbILD9oI/ThIogtx0vnOMhg
	/vhGK91CRRLRce/eEj1iXYyT46OZUxYc8tkU6qA/ckp5feN4mj0JGU3Aavp4i+uRRNkd5j
	4TcjJeqP1id3xQl5vv11ccSR8lp9umQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cq7mrmYa;
	spf=pass (imf17.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769011111; a=rsa-sha256;
	cv=none;
	b=gtqr4TnmgMmKPVX/NTMHZgOBq8TvEzrMytMpQBbbGxo0TRzT5Gn13saakx9SCse7Zt+H2+
	aoT382BHx03uIwplCFOkaO5zdf3Gnqh9Xq1rVLCVRPWG7Pe3Xe0HfstVtDQVJGukkBEFIR
	OVj17mxsCwvbdmhGIpFMbPm2+ydquL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13F3D600AA;
	Wed, 21 Jan 2026 15:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9DBC116D0;
	Wed, 21 Jan 2026 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769011109;
	bh=uuGeztEjRTyZ4X6dicMhfYnZb+UQio2g4s0lGaH28xc=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=Cq7mrmYaoTSG5AQTHZ7INKguBkRZ1GPEILb8Y6d+dWCyqQNqjk/l0ULMs7rBL0OQA
	 4ckmxc+vHxQ0Xsyj4ZL9jhMvJ2TVe1GB/GdZD0YyXAxwQvwZGqHZcWappL/CdJZhKw
	 iAvP65+0w0bQFAuyD8Y7c0p+0bTaWYC2VRt5ec0onBH/z4BWK7rOzKez3iqvVFVNf0
	 z04/EnPGU3RZWDvH0iWrfx15SzwmsVVaYyYcv9kZxdtTIerHYCoQabx7k6XqVrpHYo
	 pxaOnGXliNO+Fz5ekXCUfaY6kA43fqNiQg1uJgmQop1rEsGkJvmVih1P4PJdiJ1I3K
	 +JzvHbUvbjU5Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 6B190CE0B2B; Wed, 21 Jan 2026 07:58:29 -0800 (PST)
Date: Wed, 21 Jan 2026 07:58:29 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: Possible KCSAN/lockdep issue in -next barns
Message-ID: <55e3dd8f-1b56-4f83-8657-7583175de8f4@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
 <aXB68e_DtXsr7OcB@hyeyoo>
 <aXB9hHM3T_Q6KzfA@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXB9hHM3T_Q6KzfA@hyeyoo>
X-Stat-Signature: kfahjokdk8pqpc16yrgs9k3b53bhkogn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0CF6A40007
X-HE-Tag: 1769011110-399242
X-HE-Meta: U2FsdGVkX1+ZII1AQ2mPWp8KIVpx2WVNyIlye/he4yqLJwycvdCvI5dc/v71m5AtIN3MUh9jOve/IOEv+aaOK1z5YE7+TWVpTpPoqWTePTD4Ipc4t0OI3Bo0UMiUQThu/gaNwtEBKRWdmn6rlIaS4aOj8lWA+WDpq9HZIj/5uRkEkPHlTiobU9+qJFBVgxnGpRA7u9QX5RPvi2F0jG0QC7bmjcycWfTE2/ZN3H9H45K6Ge1Hae1rJg+6cpTA1bxx5eIxhvDGC/y5uXhwM7SdYjFnJNNEF8XfOQNPhcswOtllroBzGNYJOfmI9ztVTwFlLanVrAZxtF/8GnIr5WZwzEeQ2f7JHt5nPp3S0HHb7iHqlY0zE405WhbWkZh2GVHgHGDE+zuMliUloaRELdmjuacnL7pVzY9gm+uhpB78NPbtt0PV2PmvFDvvLgENCLSsuevRojWtH6HpY3g+vZ5sLBxnk/Si2mlaETOHAhIWQs52nOwwYOHt8PTEqr1zwOZYD/DfOexrigWmCegN8PkoPUUHYxB5f517Nk78mPc2DDEgbgGthNnagsSD2zkIOLr/UGhPPcEIjgYWhCAspOTRfrB8qq2JoIT2GoItS2AmYsewRlMgk4eZF46bvwQ0Bj78SJWclAnivQOEuyqhAUazkZSgnZmfO8CkXJFhh0WmSHWlf/ClE9pssD/EXQvdpwElLaCYRwMJ6GNMF53Wzg8UeorWt+ULlHJd/dhtpbNj/aGuxHNlLv1QweLKY1UcrJu2bfwWkdAOkvl9i2oSIAg8CSa3sNGMIi0/JWmLfK5zWY4Elpa7vVR5yxtcpkLgacYjArMzW4+mW3U7Dm2dzcftiY6fDjbOQSlinJOkIZ1dc5+UxM2b4n3JCpec1z4CIPaOzLJ1GSkDESs5No+jHXqB/zNytq6tPVlN6i/Bxjs0Tha9apaQttMLNTIQ10Nq9E42hz3/Fz2D1MxwsdwFqbD
 mMCIh/WM
 iQT8ChhYmerxzK3z/LmYxVCpmG78uAoe5cQwDx0VeCKu2cWP59EMepBjKdpbUcK+fdxXWokB5fVqnyAn/E/vdfk9vZRsIVNAh/NIb0JCPRqk6NyMaFu+dia01ILqkFfuaY5rLYqssi+/51iselebhqFuJPBWe59Q+rCW6gjylznKdKQRcwoBX+aXZZOlvI3Pn1uLP/XFkm7+XG4vradmEQwfCyRkJvc8rtQfAwGNjuLW8arbrRRMS4cqAc+Jb4GVSMMSJSETXTL99nHAHvsTLiGEvzny6/kv9N8WG2smjqXwd8YvgKe06ivksM5g2PII7M9MO1ztEMTFZDcQuvmCC99/HhMmIl34qPW64N7e+SDuivX3m2QRs7kO77aD6KS4hpRkJoa473Q3QeJvoFQ6lR+z4SIVMGcqNg4uTOIPDVPgucNSqzt8Zq+NloB3uCBMWo6hqH5Llar8W3h/Jnrf7TriGb3Jims+oLfVFglxC7rBvmahI/yLIIQBZq+Nu44vqdO68nlP2UkpArSKfLo1OdibYszfHLEc7pwe87VcQmKVNOKOGNPxgBMl2g+QYltySNcd2mkKODgsQmpOCCg0H/CBceg3GKsKcpEs6r+2lw3qFBcj10FPFke4qttXvc3DsTX25Eb+rQ8V/aJ7Kvi4FEFrByeyWhqF0lwT8j75tLi+Le+O+UG00mbh4SYMYJWA/CM6gO5Dan10HDRs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 04:17:24PM +0900, Harry Yoo wrote:
> On Wed, Jan 21, 2026 at 04:06:25PM +0900, Harry Yoo wrote:
> > On Tue, Jan 20, 2026 at 09:41:14PM -0800, Paul E. McKenney wrote:
> > > Hello, Vlastimil,
> > > 
> > > On the off-chance that this is useful new news.  This happened in
> > > rcutorture's TREE04 scenario running with KCSAN and lockdep enabled.
> > > 
> > > Thoughts?
> > > 
> > > 						Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > > [  253.872153] =============================
> > > [  253.872271] [ BUG: Invalid wait context ]
> > > [  253.872271] 6.19.0-rc6-next-20260120 #21508 Not tainted
> > > [  253.875774] -----------------------------
> > > [  253.877983] migration/1/23 is trying to lock:
> > > [  253.877983] ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
> > > [  253.877983] other info that might help us debug this:
> > > [  253.877983] context-{5:5}
> > > [  253.877983] 3 locks held by migration/1/23:
> > > [  253.877983]  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
> > > [  253.877983]  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
> > > [  253.877983]  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
> > > [  253.877983] stack backtrace:
> > > [  253.877983] CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
> > > [  253.877983] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> > > [  253.877983] Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
> > > [  253.877983] Call Trace:
> > > [  253.877983]  <TASK>
> > > [  253.877983]  __dump_stack+0x22/0x30
> > > [  253.877983]  dump_stack_lvl+0x60/0x80
> > > [  253.877983]  dump_stack+0x19/0x24
> > > [  253.877983]  __lock_acquire+0xd3a/0x28e0
> > > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > [  253.877983]  lock_acquire+0xc3/0x270
> > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > > [  253.877983]  _raw_spin_lock_irqsave+0x47/0x70
> > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > [  253.877983]  barn_get_empty_sheaf+0x1d/0xb0
> > > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > > [  253.877983]  __kfree_rcu_sheaf+0x19f/0x3d0
> > > [  253.877983]  kvfree_call_rcu+0xaf/0x390
> > > [  253.877983]  set_cpus_allowed_force+0xc8/0xf0
> > 
> > set_cpus_allowed_force() is calling kfree_rcu() with a raw spinlock
> > (pi_lock) held, but barn->lock is normal spinlock, lockdep prints an
> > error because on PREEMPT_RT normal spinlocks are converted to
> > sleeping locks but raw spinlocks are not.
> > 
> > Hmm... but it isn't great to convert barn->lock to
> > a raw spinlock just because of this?
> 
> No, on PREEMPT_RT kfree_call_rcu() doesn't use sheaves.
> Is it benign and it's simply due to PROVE_RAW_LOCK_NESTING?

Unless your kernel is built with CONFIG_PREEMPT_RT=y, in which case it
is a real bug that could call schedule() with preemption disabled.

						Thanx, Paul

> > > [  253.877983]  ? cpuset_cpus_allowed_fallback+0x27/0x250
> > > [  253.877983]  cpuset_cpus_allowed_fallback+0x15d/0x250
> > > [  253.877983]  select_fallback_rq+0x1d8/0x250
> > > [  253.877983]  ? __pfx___balance_push_cpu_stop+0x10/0x10
> > > [  253.877983]  __balance_push_cpu_stop+0x4f/0x200
> > > [  253.877983]  cpu_stopper_thread+0x147/0x210
> > > [  253.877983]  ? __pfx_cpu_stopper_thread+0x10/0x10
> > > [  253.877983]  smpboot_thread_fn+0x24c/0x390
> > > [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
> > > [  253.877983]  kthread+0x1fa/0x230
> > > [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
> > > [  253.877983]  ? __pfx_kthread+0x10/0x10
> > > [  253.877983]  ret_from_fork+0x157/0x2c0
> > > [  253.877983]  ? __pfx_kthread+0x10/0x10
> > > [  253.877983]  ret_from_fork_asm+0x1a/0x30
> > > [  253.877983]  </TASK>

