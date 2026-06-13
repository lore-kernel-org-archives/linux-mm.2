Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFFCCD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DA16B0005; Fri, 12 Jun 2026 20:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927696B008A; Fri, 12 Jun 2026 20:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF086B008C; Fri, 12 Jun 2026 20:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1E56B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:53:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAC251A029B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:53:19 +0000 (UTC)
X-FDA: 84873065718.16.A002049
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 614D7A0006
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:53:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J51QmfVH;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781311998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhowGWyw12bvZh9JeBeCLCL7/SYp3UQQwnsR0tQHv60=;
	b=dR7I4D+4RizJkI22ZYMDr//xu5Oka6vt7y/bCvD2M776lelz1UMA/YaH0gIZ5puIZ2UR3d
	jc+tpVCfaOolXT8H71d5xJ5ZX7Gurzk5jriLzw+FR92ARimx+VsJXd0HD81Zj8QeUefU2d
	pWeMtdp8G+VGygoflY9WkRVUoVExsR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781311998;
	b=yjy7mpihKMLLnAYrMI3RjQSkkb17nI/6+pXvgr2kugpwn1+pnGfupmXY27lTLAsPmUgQ53
	TyemsS2fOQumaFqMzPexJVnoOiRvC8FTc3tNrhBXE4YvTdO5v5FqFigMjbrxqYhw0T4NPb
	KgwpXGkm/WMmvTpN+BsD7wezYp2N3vs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J51QmfVH;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01F4060008;
	Sat, 13 Jun 2026 00:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352481F000E9;
	Sat, 13 Jun 2026 00:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781311997;
	bh=nhowGWyw12bvZh9JeBeCLCL7/SYp3UQQwnsR0tQHv60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J51QmfVHX75UM5QrzmUrUsWsKlvTnDo4hcc+W/tyuE5FmH6ZU5is9fRfnwE0sLGiE
	 SFyvVpCbiFQrdwEFi2gflZ5z1XyQT/MZbmBDV/ie+Zb7PsRagrP1RGrvt65XyWLU/I
	 VRq4KHbS9YQSL7tYaaTuZkfgD6qfW/R0npDo+NfCMrBcvydZEzoWGJmKTzGjYiXMEI
	 ISUzCfHzWEf652McBgivQ0Sv2oJDojH+IP97pijy9k+vrlKUPhOVtpiYT1QGsbnGM7
	 sSKyP/nk1SXjbGTjg1O3dvr14EaSAVIawAudOSA+bMo6r+GTIO/56rJLZKBLo4YOHI
	 xEMO9MRE05Okg==
From: SeongJae Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SeongJae Park <sj@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lance.yang@linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Oleg Nesterov <oleg@redhat.com>,
	Qian Cai <cai@lca.pw>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kmemleak: avoid soft lockup when scanning task stacks
Date: Fri, 12 Jun 2026 17:53:09 -0700
Message-ID: <20260613005310.2120-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 614D7A0006
X-Stat-Signature: ejeqbkmh4ericzjtpmrbq3jb15bmk5cm
X-HE-Tag: 1781311998-987878
X-HE-Meta: U2FsdGVkX19N+sEac753cjg5qTI+Vx6wAQ9JlZ57sgulc/LvbS5N0U0TgycrjbHJrW0ClH6vRQDLoWbAkJIQcB2crI6u0GA82KWVyffscbEDneJMTo5PhIMH5S7UmXWKDSKawxlJillBw52d4r5MPzCB5TaZxoGaKMECAX+4K9fRYg5ktpmIbSdQv1Su56f81R3xFNc+sAAj2ixDh9KZpY42QXy02Yx5+rP8ntKyoyrhsxcoJ5dX7IoPZDkrEckJyiTt3oCkJfi5rgNINXoOhXCPsfjmynvVwyl3OavzbWOP59z7AcqFCY7g2uW6m5e6O99YiZhfsyRKgprkofYAelwMisrcIdvBG24Q579KSuPRh2yLStrqaN58qqr5xN/nRW5mBEvorzJ3SCirnAY0tpX/SX42om9JVtbUWvRIBKiXSV/RZ+1Noq81ASBKCXF1EhoGOhaVsj9QdLjuqm+T2fe/d0Ig8Ty5cyAsxggtnGcbAJR5SYWy6eozz8Dz8rnP+2O2L0LwAFwxK/EzQMHNbKI+XIaKroC1Gyg3+SJwC9VWgjjML5MttbmE1QqN6FgIHaMpxPhmhfkUWMbUOh6DcFVxLMTArEC9003ZZaE2T8B/jJZVmaYk0HHDx428fqnFza9wmIzdGjUbTaccuxw6Q7c70Ayfca12hX4P1WQki+1KtjaxIYGzTP/cB0UnLH+lBs5HlpMeS9YAWCzM4X3Jz0pkb5amge74nG67/0d2Ig46DzR4XscEUYtvywc2ClMXdg8H1rsF5OYtIBuM9+gPGeEB+tOcDBORk6QVtOII54BbRQKrpPME8TH/cOaomQqGlSnz45DmyXVPfzpn25yZxHsqAfCo5u6LmziXvcKU+9hdiymaIQUrBmVpWfpYndMCB64OeehPNZI4aCl4eDuiAvvEF9D2Kh6EGAWGGNwxK3Ree+GmhuoDaX3JbaPUVFbvncFsYMl/4t8famQLmMF
 DzLoGbGG
 GJz8lU5I9ActlVJx4hOkTTXDBgxnvSYaU2EkMCh42Nfg+HxrS26w82x0XI9E0Ee2UUGY26V6Kqy9ot3wtq7T0xMpOhtKUjAxjditmyeoATMvGFiS5tIS1RMsJN5K5K2q/LJ/dSk6fWsb9/bpHbHOHvy5L899Dj2SI1bJTjKl7vJxdzMrLpLvbfgB8XDoarUgCj16EWAHg4R/w983JKOpuu16BxKGz+7sao/quvWE73f8P75/VyyH8+1LQAB+mP/lKmFQQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 08:16:07 -0700 Breno Leitao <leitao@debian.org> wrote:

> kmemleak_scan() walks every thread and scans its kernel stack under a
> single rcu_read_lock() with no reschedule point. On a host with very
> many threads -- amplified by KASAN/lockdep in debug builds -- this loop
> can hog a CPU long enough to trip the soft lockup watchdog:
> 
>   watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
>    scan_block
>    kmemleak_scan
>    kmemleak_scan_thread
>    kthread
> 
> A cond_resched() cannot be added directly: the loop runs inside an RCU
> read-side critical section.
> 
> Borrow the rcu_lock_break() pattern from kernel/hung_task.c: when a
> reschedule is needed, pin the two iteration cursors, drop the RCU read
> lock, cond_resched(), then re-acquire it and continue only if both
> cursors are still hashed.
> 
> If a cursor was unhashed while the lock was dropped, the thread list
> cannot be walked further, so the round is aborted. Such a round scans
> only part of the task stacks, which would make live objects look
> unreferenced, so reuse the existing "scan interrupted" path to skip
> reporting; the next full scan reports the real leaks.
> 
> Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Thank you for fixing this, Breno.  Nothing stood out to me while reading the
patch, other than the below tiny and trivial nit.  Regardless of that, please
feel free to add

Reviewed-by: SeongJae Park <sj@kernel.org>

[...]
> @@ -1890,11 +1917,21 @@ static void kmemleak_scan(void)
>  		rcu_read_lock();
>  		for_each_process_thread(g, p) {
>  			void *stack = try_get_task_stack(p);
> +
>  			if (stack) {
>  				scan_block(stack, stack + THREAD_SIZE, NULL);
>  				put_task_stack(p);
>  			}
> +			/*
> +			 * This is an expensive loop, we must to call the
> +			 * scheduler to avoid lockups

s/must to call/must call/ ?

I saw Lance also provided a suggestion for making this comment better.  I think
that's also good and maybe even better than my suggestion. :)


Thanks,
SJ

[...]

