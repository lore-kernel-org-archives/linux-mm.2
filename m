Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28980CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9B36B00A0; Fri, 12 Jun 2026 13:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891E46B00A2; Fri, 12 Jun 2026 13:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE8C6B00A3; Fri, 12 Jun 2026 13:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6EA6B00A0
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:11:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39131140198
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:11:48 +0000 (UTC)
X-FDA: 84871902696.11.230B2D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4CC2318000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:11:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Og5VSvJA;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781284306;
	b=qR7IHUsufbfAdufGS2PFoeuqA5kqGuhAtr8WkSeiVYbPorOO4QBXdvdIHI53ZEwwkt+u1Q
	vHofbDqROoh2YRUQVbDZUp9w/g6sIMV5y/QmfjrJ2wQ4IiXvVeHrnFIMN0XSjw8GUgDEhb
	wDIdKIw/OeKb6rEBidl8Xtppj0gJCN8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Og5VSvJA;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781284306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNS44oiPrquu4J0lSpkL7CosqChcY4bqkca65NGcOAA=;
	b=EcN23wRTD3O5FJykm8Io2qzFxTfy9LxFW0W6jb0y4Dqlrl27JuRbF1c9vMMJ4j0V6ONo4r
	Sql92dL5F0kV1SeCNkGe38eJHwR0IZl5QPw/wdLSCVLLOdcNLKWt0L6iTFXjr8xSeMjPiT
	Pojv5RbpPRemtGv8peIVKvQ8g/RMhuM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 748C032FA;
	Fri, 12 Jun 2026 10:11:40 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A787F3FAA1;
	Fri, 12 Jun 2026 10:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781284305; bh=B8U2SJ40bu19l1Bskx20byRPuGWvv8sRp2tUqOV1an0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Og5VSvJAAlHUGjKrOzD4piBhFGiPI+J5r/NwPCyMSH3gJTspQtQivSq1JH74Z7/eH
	 f7k1bfn4d6+KHKf+m1kvJ0ha6lOeqn20It1hbK7TJSrqkQynn7wQQ8PQYtzm4V0srr
	 AURlD06hsSLGaXiRox4Fc2dDzt+MTNOBGbeEiQhA=
Date: Fri, 12 Jun 2026 18:11:40 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lance.yang@linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Oleg Nesterov <oleg@redhat.com>, Qian Cai <cai@lca.pw>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Message-ID: <aiw9u4BllwZXDH2S@arm.com>
References: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612-kmemleak-stack-resched-v2-1-53240de79e88@debian.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4CC2318000B
X-Rspam-User: 
X-Stat-Signature: 7959qyh84zmrcm1iuuqipq9ab3796mnx
X-HE-Tag: 1781284306-593843
X-HE-Meta: U2FsdGVkX1/Bo9dhyEGQgg+AQPUfX2MbRqUf6SfON8kjJPR2CSMFmBpjqbPp958PGKETjzdnYoeYIVoQKNsoRuM7yGbD0im5NDNskFomhDqDnJJzbIMmfGY0rbSv/E86yG20nB7ivkkfNg9jvWCdBFP4n76NSOKS9Vzx5M+um/bqSGB3xfMjWvVin4bcctcQeyR6zOhvz3TGrf9EXxBElUmmRMchU3j1aD5xS9vAchKr4Sc5YqVbQbp9CsPo2gSUYYYUfs11R6sKvgA/h06PulfiFmpZay/w3uY2ch7ONLmX76oCQUJaonZlM36JE5MNxF3T/shaShlfWtK31VzRtcQHkTAbRUwjKTf2k70ssegUN+z78wJDny8k/jUAQvckFZxsNj1r/kymMtu1+QlzC1mLyGPfYKlIZoRn2BZP3V9C80WFqbt2NnuWsV8Bbb+vNKhBPlGaTVizFupFPSZHKVBcI1rbPWfR9Ni1VgjJYJQzPbuKV0ZCd5WorxGu2nzZoA8kiBPHCKTfECiB1w9hSV/G9fDGadzemF78RRGWP5hPb1tyRt1acJKtf61eTWXVQcnCKlyIRBDv6ISz9GP/HPk4w3E2vZj2wEho+xVPwTM2cS9WAtALnyTi4Hz11Xd2aafLHboYVKXzGgiaox+akKHfceDE0ihZ2REPXpVbB+xkS9gNFUcQx+3geCfRQ7hdb2XZgrNCZMeMZ6p2/C0xS06UylNSBw/6HnpHIeIudKQrIIfjlKAUMp6YEyRrkAn0L5G6uw3Vw8Rj7vZIdJzlLyzMKXKZEwKC0ghYedJgui+Ej+ziCZjx1DwSAvCJASCjlb1oxQ1eOzTWYfypcGAuGIYCz4CNE5ZMbserGGN9V0WhX6wsjzymEPCyZ4Ke3gDXfRUSzkLfK1NshbGcXY0gh8BQcnl3c063LU8EWFVGAY4TgAprByNfexBwbcCJLTqgWWW5BiHKuK0LSAxTMq3
 qXS/5DEE
 4Y/tE4vzrkFESRDrpsQ3koPhiHPlhsR9wlXgU0lfJ0yDY59ctFDU+2f/vCBYtA0VGJYwpb5vb+zoBos6jwURi85sKjk2c74qrhU0dxc7eObMS49sMsRKz6caKx7doidXUEvzcbn9BnCC8vEK5uiH97Fu08Dlm8BTqM72Ogl3lnQsFThO601/ndJRipLFGP0ixhAxosQ7C+N7+Zjym/coh9RUUwtoVNqEttHcFIGWGSOkNoTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

Thanks for addressing this long-standing soft lockup problem.

On Fri, Jun 12, 2026 at 08:16:07AM -0700, Breno Leitao wrote:
> +/*
> + * Briefly drop the RCU read lock to reschedule during the task stack scan.
> + * Both cursors are pinned across the gap; return false if either one was
> + * unhashed meanwhile, so the caller stops this round instead of walking a
> + * stale list.
> + */
> +static bool kmemleak_stack_scan_break(struct task_struct *g,
> +				      struct task_struct *p)
> +{
> +	bool can_cont;
> +
> +	get_task_struct(g);
> +	get_task_struct(p);
> +
> +	rcu_read_unlock();
> +	cond_resched();
> +	rcu_read_lock();
> +
> +	can_cont = pid_alive(g) && pid_alive(p);
> +
> +	put_task_struct(p);
> +	put_task_struct(g);
> +
> +	return can_cont;
> +}

While this matches rcu_lock_break(), it looks to me like we rely too
much on the internals of kernel/exit.c. Ideally this function should be
provided as an API alongside for_each_process_thread() so that we only
have the idiom in one place in case something changes in the future.

Yet anther variant below, untested. Basically, it follows the
next_tgid() or task_seq_get_next() approach (we might as well move this
to a separate function to avoid excessive indentation):

	if (kmemleak_stack_scan) {
		struct pid *pid;
		int nr = 1;

		do {
			struct task_struct *p = NULL;

			rcu_read_lock();
			pid = find_ge_pid(nr, &init_pid_ns);
			if (pid) {
				nr = pid_nr(pid) + 1;
				p = pid_task(pid, PIDTYPE_PID);
				if (p)
					get_task_struct(p);
			}
			rcu_read_unlock();

			if (p) {
				void *stack = try_get_task_stack(p);

				if (stack) {
					scan_block(stack, stack + THREAD_SIZE,
							NULL);
					put_task_stack(p);
				}
				put_task_struct(p);
			}
			cond_resched();
		} while (pid);
	}

-- 
Catalin

