Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EF4D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 05:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA496B0089; Wed, 21 Jan 2026 00:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C106B008A; Wed, 21 Jan 2026 00:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB8E6B008C; Wed, 21 Jan 2026 00:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1286B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:41:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 112DC1A074B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:41:18 +0000 (UTC)
X-FDA: 84354873036.29.73F1585
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 588FF100004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:41:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=InFUuGPm;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768974076;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SMjQ5eSdHAJkgpzn5LXYUIIJ8uxMNbOKGPNLi0RqQZk=;
	b=yevYYBmT9xoLgQD5Kks3vruCQPpK8P8FFQ/h5/mWmP5KSNuBcDJoAMjXOQOiNKL0I86G6S
	h53JVqXGd4Zo1/h1wfVtKX04C+8IGTMtGI6HRtA3Q9FGAIxkA55v4Zyn5BZEhSsvzGsIj0
	YaklHUK/vyeeA3r2q0kvQ/uKp9Wi9yQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=InFUuGPm;
	spf=pass (imf14.hostedemail.com: domain of "SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=IiP5=72=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768974076; a=rsa-sha256;
	cv=none;
	b=oof1hpXYDFu1wlVWUxsmzm4zih6iJupv1uV3x6nwlPUCP7ItJXo3QRo9IZzAyhj29CJtFw
	USZJRL45wpCzCSq1sh69DJGt3pgWw8tYYPggML9XNWq2SLV9YZ4SxNHN6tHu2gC4VEM9WS
	tZrmZ2cnPBUWnZP6cSuvwZCJ1vR7awU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6381D42AD2;
	Wed, 21 Jan 2026 05:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D18C116D0;
	Wed, 21 Jan 2026 05:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768974075;
	bh=TPGpxoUPG7Tz2wYQIXtfuwTwWL6aC5OFLJYRNdBjC1o=;
	h=Date:From:To:Cc:Subject:Reply-To:From;
	b=InFUuGPmIUGIGySyKwaoBKtX7ugxm+E9CQzJZB09P8fpmy1Zp5jq7IseSPSGJpJxD
	 QIEWRXJ7YZUE44T+zF3BPPl1CXKrlVHFbZqUw/DfwKohmTf9Cesizmj99t8jvr/sfM
	 zuoFzsdLwL8Yzf6Eg5IqL9TR1pYfLbRv+tdUix5iLXejg8F8udqgqB8pwGQFncr/nA
	 uByL3S55QfmmWFHfIhNT6Je+k7pz3kZEyDo3vO6hNgjVF6F7jJe1Dw8W8Hx1zNOoBK
	 TfWPjlxmgrW6PBOW/zJ/mtNOFdcymycgT9oSvoArE/HrKOpBbAeXXlNUMDjJpaby1Y
	 6USLI81NFLFdg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id D2B4FCE0C56; Tue, 20 Jan 2026 21:41:14 -0800 (PST)
Date: Tue, 20 Jan 2026 21:41:14 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org
Subject: Possible KCSAN/lockdep issue in -next barns
Message-ID: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
Reply-To: paulmck@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 588FF100004
X-Rspam-User: 
X-Stat-Signature: 81ojdgiz4mx6orkwwokh1o3a3ndfi4th
X-Rspamd-Server: rspam08
X-HE-Tag: 1768974076-964454
X-HE-Meta: U2FsdGVkX19rynMSdFG76JZ9qSuUO9ac+MrNCuTHzCwaIhh++3Y1Mdp0gt9ojYTMuVdUKp589MriqaB1OlNw33VormoHq1f5ctJNvcP31kXPOzHucsaKE8Ao6q6jPxxY005zq4tsXfZMaRPiQ4dckc0IuUoj8Y047p9nAA8EX29hagORo0jZO7jn2PnQwCahJ4dbuOd+CkEhoxmYur5EpMx+5HpcCjLMpbWfG69RutUGigoIP3EZYHwdFotWZgCFuRgjby1UVxNnzhtCYjbZI411oFVagQiJ7g1nhBsEpKIs2nd5FQgwKKN7XbtSt6EMbUfGKsEd+S5hsByWQlt9uoYN6JqSaXzNp7dC/LOveppEGv85/ElvAbwLnsG3fHjsARfgJHYBwhMuBxo59Q+LzhIfvSTNIIXZoLBwjuVYvEvT8gSZ4Gyx8xU3ijw3j13KF21cAKpp0wlFKW7MbmQyC92BeHBxinuzBdyYuBRvSzFdMZJq8VzKQMX6pAAmUdStp1B8+n5eojEabzY2MMerwybbrit2db32dl4/qXS6GSYG0gNoHnbHzKbjSqkmFqm7snl3BEpAUaNnzAKxYcu7eYoNtYrA37DyHyjViyEcNSbqGjwxwmeMjUuD9RpzzHij5TGBj614BxewUbWbthEDZMgJqP5sS43W50dwwoaog4BjliDw9Q1UI8rULySGh2KIERpUSRdMlYISZbLaKoBlS2ZOHQrLs+lYcO4YrNbDVZucjx0Gnr8oBD2bHF/A5xMtR32Sjg/YSmecx7XwaS541F2QGLX+FQZMKiB+O/zZqtpgRA+LzsTjctqCM/0o96Zt2+DzkyTSeCxhrMeM/NFp17QAQqACYoTJeBGJ2pSsKwIarSQmLRce5wuhEYaxwfTcSHq0Jpd+VINRla+5dp326MlwlgmIYk/UusuCCZgUTrRYfiHW2ifYg06vdAYOWHkzTeSFUQ4/xLyf4bdBRBg
 8r73TkS4
 GmswdpcbttslTUc5uilDHLBZUA2ctN3OI4dGACHpIAahVZcC1QQBNqIl6Eki/dfPahdNmsEu7R5RaK2xNK8vVol4cqDwZrrV2c6SGIEFm3kMmWZHCrYWomQgSkGOys20WHWfnIYluW56PYtyReU11zSilBAgQAnwl28RGW59y5xTx5Ld6OY2L8i7/hxs0OLltPwRNbMEs2GW87hnm0RNE8FRQ2EHnHx8KMZz9+ZNg5iHLRrR5K7CpYeGIFcOLMq0+jjjDzMoYtustN+HunELravgf4rgk+N7+7VnWFT/VhOa9kcTTDw/ED9G6UzN9XnCEJb5qwzaNzSDnoMlJV7i9gh9wDWKBVt26xeFbrawdsyV+BVQLZqC8eHNGw7OtCy5C20KeoaflXH/i39M27O+PttdvPTvRqp94wbzMFdQJY9r7oDC06syXlzq4c/vu2bFlyEApi8Gl3lxD7oyDF8ZNj1xRbnybm5Z0TU5NneE/LSJynBvoevj4GnZDHqpzqR+gQIe/E1ek4HcEANwW6MRYB4wmmS/Hk2egUAjvirn3+jK3S4Qr0awPCgonLFIGgZHpqbW7N7WSb3vBSQWgnebX4wXnsO9ESjuzjhcHnzt8LMNAGbLls8rH506vR35Ul0MMQwYqBLrG/PSMOTswxiqWJ2j/1keS/+9RWV9tirpm2W4WzHoZLFybBn6zCpbG+HEVyjiJLZBLnETMUDI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Vlastimil,

On the off-chance that this is useful new news.  This happened in
rcutorture's TREE04 scenario running with KCSAN and lockdep enabled.

Thoughts?

						Thanx, Paul

------------------------------------------------------------------------

[  253.872153] =============================
[  253.872271] [ BUG: Invalid wait context ]
[  253.872271] 6.19.0-rc6-next-20260120 #21508 Not tainted
[  253.875774] -----------------------------
[  253.877983] migration/1/23 is trying to lock:
[  253.877983] ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
[  253.877983] other info that might help us debug this:
[  253.877983] context-{5:5}
[  253.877983] 3 locks held by migration/1/23:
[  253.877983]  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
[  253.877983]  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
[  253.877983]  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
[  253.877983] stack backtrace:
[  253.877983] CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
[  253.877983] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[  253.877983] Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
[  253.877983] Call Trace:
[  253.877983]  <TASK>
[  253.877983]  __dump_stack+0x22/0x30
[  253.877983]  dump_stack_lvl+0x60/0x80
[  253.877983]  dump_stack+0x19/0x24
[  253.877983]  __lock_acquire+0xd3a/0x28e0
[  253.877983]  ? __lock_acquire+0x5a9/0x28e0
[  253.877983]  ? __lock_acquire+0x5a9/0x28e0
[  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
[  253.877983]  lock_acquire+0xc3/0x270
[  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
[  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
[  253.877983]  _raw_spin_lock_irqsave+0x47/0x70
[  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
[  253.877983]  barn_get_empty_sheaf+0x1d/0xb0
[  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
[  253.877983]  __kfree_rcu_sheaf+0x19f/0x3d0
[  253.877983]  kvfree_call_rcu+0xaf/0x390
[  253.877983]  set_cpus_allowed_force+0xc8/0xf0
[  253.877983]  ? cpuset_cpus_allowed_fallback+0x27/0x250
[  253.877983]  cpuset_cpus_allowed_fallback+0x15d/0x250
[  253.877983]  select_fallback_rq+0x1d8/0x250
[  253.877983]  ? __pfx___balance_push_cpu_stop+0x10/0x10
[  253.877983]  __balance_push_cpu_stop+0x4f/0x200
[  253.877983]  cpu_stopper_thread+0x147/0x210
[  253.877983]  ? __pfx_cpu_stopper_thread+0x10/0x10
[  253.877983]  smpboot_thread_fn+0x24c/0x390
[  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
[  253.877983]  kthread+0x1fa/0x230
[  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
[  253.877983]  ? __pfx_kthread+0x10/0x10
[  253.877983]  ret_from_fork+0x157/0x2c0
[  253.877983]  ? __pfx_kthread+0x10/0x10
[  253.877983]  ret_from_fork_asm+0x1a/0x30
[  253.877983]  </TASK>

