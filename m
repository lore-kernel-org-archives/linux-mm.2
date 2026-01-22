Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13154D2ED0C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 01:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC4F6B00A0; Wed, 21 Jan 2026 20:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A406B00A1; Wed, 21 Jan 2026 20:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BF36B00A2; Wed, 21 Jan 2026 20:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30AC26B00A0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:35:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD5D81A144E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:35:33 +0000 (UTC)
X-FDA: 84357882546.25.73269EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A8512000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:35:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bel17KRO;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769045732;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNoXPWJR6CFHWVd50NmcS+jtmX+hCs43qT43d0pHuuw=;
	b=q6sAckJk4Ug6npwHOOcezpL5xBBJLvw8w3nbBLaVlqYH3krrEOSkuHfyE2AMem7k06WgOG
	k21A0T+lrroOuZ4ZqOKOxnMfOmEF8YSNeIy6gFfPuHasbE6T5x++as3TbZyN6KhDYgZLdX
	jSgpPBbsgbAYxTua7h4qQW0etG5R1UA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bel17KRO;
	spf=pass (imf13.hostedemail.com: domain of "SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=ucPx=73=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769045732; a=rsa-sha256;
	cv=none;
	b=A8Q01ExXyc0gs/JsZwgBgzC1ARz/fizKaUBDbcX06x3OHXWyEDZXEDCZgB3K5v8bYS7FP6
	Go2dgTXwbpDxWs7NRsmX+ZDVNblwFG5SaP0lUZ5XrwREnd7cB9mgFb3bJmjwEevuI6DD/v
	QmGOxCh/0h6HAkn28wYvbCBMnCi7PPI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65CE8600C3;
	Thu, 22 Jan 2026 01:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C80EC4CEF1;
	Thu, 22 Jan 2026 01:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769045731;
	bh=gEsFl5ZSDbGUzaSg/Rz1mr17yCcatEQw2X7JV/tbYNU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=bel17KRODqdrg/18M63JodZIhOeV8OLvgUZOcgL6cfY+F47bXhb4UzSvotJkTUjLH
	 nusTamJV3dw60qJFPPkx6ROzWPgx+XqdpH+FRvvP0k6m6LrhuUZG+9ppbwRT0OVLe+
	 kqTIXRhvQ8RcJIEPsayuAM6lTDk41kabxP6aqogW6POTHiAWOSu0YlEe2Cxvrw1LkT
	 6kTdx9REFqVII9nfmK0NglLAQGjvmQ/t51MxjjzuzOZdps0zPfPPnb7lsOo22dH/M7
	 Ik3VTNVA9mND8bFBmFmqMhcp3zbAgmT+1ifyMs6uuB1n1XApjPse65oq6/+jGT2kJb
	 kPsFNPButNkkA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id B5B52CE0B2C; Wed, 21 Jan 2026 17:35:30 -0800 (PST)
Date: Wed, 21 Jan 2026 17:35:30 -0800
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: Possible KCSAN/lockdep issue in -next barns
Message-ID: <d37890bd-bd9f-4b49-b553-45858726fb0a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
 <aXB68e_DtXsr7OcB@hyeyoo>
 <aXB9hHM3T_Q6KzfA@hyeyoo>
 <55e3dd8f-1b56-4f83-8657-7583175de8f4@paulmck-laptop>
 <aXF8UAEEa5IuIbGr@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXF8UAEEa5IuIbGr@hyeyoo>
X-Rspamd-Server: rspam12
X-Stat-Signature: tussr894mgjzq9zheo49so43f6nepo47
X-Rspamd-Queue-Id: 3A8512000A
X-Rspam-User: 
X-HE-Tag: 1769045732-556561
X-HE-Meta: U2FsdGVkX19xv5ydfPFAgUP8olVCQ/ZpUsNvjmgoXaBHLwuHDT6K3BJMOZloaqNryrozY82T1QKQHITt/OGwPoDzvUecxoSE0hBvw5J1yvK/hf7aQzwoUkbRow0hnjbTEQ4xJ0EX5yu2IxQ1+AcT8NrmfVMZPmHaFQiCMAFTUoRh/blsl0Qm+40zk28EA+LYIc9dAym+vE7UNFdu4sNaBQFcp5qD/8jYvh3Ls+RirY1j9FFNDPUL/vZm8FH1hkmEESxIftV3BbMvH79guXcK1FAC95MwnPw5y70tjvVzXmspmh1dk/61rG4lANJcEzsAPts3AABoTU2uT3e+wyPTPgzjm50H0bE8c7WGWWOOvee+DzjTgj7ew/yuzu9ZQ6JyZclHK1zlXey/QjakafhIJ7qtdl60v9epcn66d1Dg6k4g6PD230TZq7jFad3fAFF7RD4MP75PcVWSSJV8rJ3ENEeEHShC8Js7CezonTa+eMrwbw7f2zbdG8Ew/X+aSkawcH1z4fXslrt7lsqP9Us76tgJP0pQSet6ISNu7XZhgIerPF4bQDlTTGHw9glwVFA0J9dOo8GrXIIFkIUtaAjymF0AZvoi2D+8+WMGQbHIRfJ01kNxnT+/pWS30lvVYCKM+JCCr6muA9/ZzTDOPPrCYnPaSQo3IEuEU5ZuQbRDgsp3oRHV/Zj6fS5Nu9bzAoU25YrRpK0c88ME/axrVz6pMJvhsh4XNRj41qVPIpkGWCHIj6D/nOnpjG8QWgkRCXuHEG8PSuuJe5q53UUqgZiDrM5bgfA1ddTHwH+9qt/mmOgjXMksHiZW0HddYv/Wu/qqSc3IGaMA/8jZZR71t1s9OT0MaT7fAjw3FhwvXOoxJEvDfy48c5ewDiE2Te4gPYkcLSMaXw5di0mn87iXOirwm/BnCzmFxfoJiu+uw8eKs42WrPbwaEmwkFhIGGhYN84TBDNfHN6RXBzmm9pz9+y
 Dvj9Q/HO
 7zjEy0Kx8ky1nhwWTFUBJ8lp4WKpzXUrDoaxBxw3fdp0OqhJzHZ1SzhICg7jl9lVppvUuUrdlnPAxxsdO6NouO0NrGoazytJL3/a/4jcSdMm8im8r2pPWGPKzTCDAW17LcsEnUCOKKKBQ9YhlJj1kmH82awwxWkZ0l0b4uLBiZFFVCcMq+bpIBp2IVmZU8wCw2at2TlQWNvt4yHwRlokV/b8JbYA0cNeW3A3dk8TFb4G5m3xBCV2wJ87OpOle7skKo1YU12PLSKPnctl0OA974DYP7qTjRHs3cKSMtS74DZTuEp30lpk9UtuWelNZg2mBPUZzF+EWUYAyjWYmqo9Hm31CAuoRza2iZ3G5lt4asGkvqrboN3+tM3GBXSKKWPyzQ9JCRvFuo83n1xgq0fUJUNBSZorSk12uXBKcv8lCy90mJJgQHoPHC+I2ZaH9V5N/Zgr+LJX7XAO1jcj4Du3WP30tta118nlCVnBGz+peSyCFn4EETPxilz1i/E6GjV6SsB8emdt2YXhZu3Ju2bs9kNR0W2uC+YwksLTKdu2WOSYRsgo+bGSa5A++302KJSwbDLHK8CYamQnMfFOUM2eu7IO80cFpWUp+8pzGK6h31UhILBhOEBZmKHrTNczIv7H2/FFkJFxID76jqMZYKfLa+aXuA4/dB1O8jIxiBBgAGW22JNfy+cg9s4w4k6zBTcnx++B3J1GYYWr79kM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:24:32AM +0900, Harry Yoo wrote:
> On Wed, Jan 21, 2026 at 07:58:29AM -0800, Paul E. McKenney wrote:
> > On Wed, Jan 21, 2026 at 04:17:24PM +0900, Harry Yoo wrote:
> > > On Wed, Jan 21, 2026 at 04:06:25PM +0900, Harry Yoo wrote:
> > > > On Tue, Jan 20, 2026 at 09:41:14PM -0800, Paul E. McKenney wrote:
> > > > > Hello, Vlastimil,
> > > > > 
> > > > > On the off-chance that this is useful new news.  This happened in
> > > > > rcutorture's TREE04 scenario running with KCSAN and lockdep enabled.
> > > > > 
> > > > > Thoughts?
> > > > > 
> > > > > 						Thanx, Paul
> > > > > 
> > > > > ------------------------------------------------------------------------
> > > > > 
> > > > > [  253.872153] =============================
> > > > > [  253.872271] [ BUG: Invalid wait context ]
> > > > > [  253.872271] 6.19.0-rc6-next-20260120 #21508 Not tainted
> > > > > [  253.875774] -----------------------------
> > > > > [  253.877983] migration/1/23 is trying to lock:
> > > > > [  253.877983] ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
> > > > > [  253.877983] other info that might help us debug this:
> > > > > [  253.877983] context-{5:5}
> > > > > [  253.877983] 3 locks held by migration/1/23:
> > > > > [  253.877983]  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
> > > > > [  253.877983]  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
> > > > > [  253.877983]  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
> > > > > [  253.877983] stack backtrace:
> > > > > [  253.877983] CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
> > > > > [  253.877983] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> > > > > [  253.877983] Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
> > > > > [  253.877983] Call Trace:
> > > > > [  253.877983]  <TASK>
> > > > > [  253.877983]  __dump_stack+0x22/0x30
> > > > > [  253.877983]  dump_stack_lvl+0x60/0x80
> > > > > [  253.877983]  dump_stack+0x19/0x24
> > > > > [  253.877983]  __lock_acquire+0xd3a/0x28e0
> > > > > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > > > > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > > > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > > > [  253.877983]  lock_acquire+0xc3/0x270
> > > > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > > > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > > > > [  253.877983]  _raw_spin_lock_irqsave+0x47/0x70
> > > > > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > > > > [  253.877983]  barn_get_empty_sheaf+0x1d/0xb0
> > > > > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > > > > [  253.877983]  __kfree_rcu_sheaf+0x19f/0x3d0
> > > > > [  253.877983]  kvfree_call_rcu+0xaf/0x390
> > > > > [  253.877983]  set_cpus_allowed_force+0xc8/0xf0
> > > > 
> > > > set_cpus_allowed_force() is calling kfree_rcu() with a raw spinlock
> > > > (pi_lock) held, but barn->lock is normal spinlock, lockdep prints an
> > > > error because on PREEMPT_RT normal spinlocks are converted to
> > > > sleeping locks but raw spinlocks are not.
> > > > 
> > > > Hmm... but it isn't great to convert barn->lock to
> > > > a raw spinlock just because of this?
> > > 
> > > No, on PREEMPT_RT kfree_call_rcu() doesn't use sheaves.
> > > Is it benign and it's simply due to PROVE_RAW_LOCK_NESTING?
> > 
> > Unless your kernel is built with CONFIG_PREEMPT_RT=y, in which case it
> > is a real bug that could call schedule() with preemption disabled.
> 
> Right, but it's fine because this path is never called with
> CONFIG_PREEMPT_RT=y. Yesterday sent a fix to suppress this warning.

Ah, missed that, apologies!

> Thanks for reporting it, Paul!

Happy to help, whether with one "l" or two.  ;-)

							Thanx, Paul

