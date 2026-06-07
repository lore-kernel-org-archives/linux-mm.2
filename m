Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AA7CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 17:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E1F6B0088; Sun,  7 Jun 2026 13:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8546B008A; Sun,  7 Jun 2026 13:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0016B008C; Sun,  7 Jun 2026 13:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 249F16B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:58:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A31C51C25F4
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 17:58:31 +0000 (UTC)
X-FDA: 84853876422.28.30CC94C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id CA36A40007
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 17:58:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFUgLRwL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780855109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2RDc7vwCs214SZmSr6J53htm9NHLBxoNBLD3OPbxYs=;
	b=BefCs4iTtXmzR/4lUETV3n9hOJYOHx3dVCRvStvg0P4Qnz9GFnrrtaYbK2Kx6M8Xt62IRL
	wTDlJ92/xbSYCXUMDgF+4et7F6ksgaMZM9VABXO3hGFgi0uI18nlCKL3WlJc5tabwQfbqq
	SYZdYB0zj/LT/Qskk7C6sjLWtQUjIOc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFUgLRwL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780855109;
	b=ZdYEJo5s5wTiqOBXytT/XV8oPq7BKKy5wlILCO3ggcpFCeO5F9GdTfLbltse8LxeaFCMgW
	pUJX0D+gB7ulIaS6H9IbDBUPBxNsIkM8+9cSN1O8jOJ1ThOn/tbP8yVPXNn8YZtQlU6BPv
	07UtBQsHaMj7ccM1ATF6Afn+Rp0j5x4=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2bf3781ca51so35393065ad.0
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 10:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780855109; x=1781459909; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c2RDc7vwCs214SZmSr6J53htm9NHLBxoNBLD3OPbxYs=;
        b=WFUgLRwLWqdPlz8xQ9gFysh19+iwKNxL8pq7sNGnv+RQl1/56F3jJAg7Q48fDh9JY0
         J6NulSe1DsInJtnfWx+FnRPqVBywyHcbt9IhczzrBM4fbi0i5RNRYdHPBTX901KpQZFa
         OaFcUaEl44t/ApB8z545ZS1jnJVEdmnmbHc3PATZhyGkf4HvNUgbi4J3MO21Lg5mNK0g
         yWt+oIiUB/lbzuDRhLD9XQUnYAiqPBT22fKYkLGT6AiJ17xn34pVEgmmJg33T1tr04uh
         STF5bZEc3j03/Wmg2ODOZMsAmHAZ5BfwfiCoG7WdtPHF/S2U5fKI4V4KrRpwfm0+unJ0
         gRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780855109; x=1781459909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2RDc7vwCs214SZmSr6J53htm9NHLBxoNBLD3OPbxYs=;
        b=CqbtxNKMpNwhnH2kt88x9hySRJkObkk4DffGuu0J8Zg2hl/8iLT5gdUqpSTaOZAEct
         es4bSIyTxd2EF2wh0ptb2TTJkYe7JAhzkN34lJpjxaB8AZAbmhWJcPOjZwdha2DvtbJF
         S77bSOQKMUBnSCBKb61cp3gcbs5dZffL0ydozA0ecg6tp+vUva7Bmeu93L05/210CBbA
         audzgnxPnmbQectww9AzpI5P+1WDY19LJ5Hp8VRLK8MjyfnALHnnrKpEN5irI7ktCVDo
         idpiUriy9qobTCdYYayg+ELLtJhqKDXCXpvsSjnfzT9N9LteTBjF6gmsmVyL+o7PopwG
         5Eag==
X-Forwarded-Encrypted: i=1; AFNElJ/3ltg0AEBbDIFfVz8wCMlsk/Y1m06IPgiphyAWB63zAlndsF6C8ReIG5DIe3q/jFgfCCGPHA3mBw==@kvack.org
X-Gm-Message-State: AOJu0Yz/Ne1qaKjAnLnN//S43ro93pAtaGS4wnfc4lNerLi2hQoaYQVp
	QjD9aNqO6xlKUlxqiIZoFohnbDnV9/i0FUGgUB5UjTaNmX8nxVdXggqd
X-Gm-Gg: Acq92OGt+pFKF8oQGvh+3wcpVdxiDZd2ZLQa7v2ZL7M96y1rz8GnN3ngQFxdIbZt6Pd
	MAPSpCVavPPV5pQxpgtjSNbT+23bcUbeiS79BeR+6XxP3SC6Y7/6NyQ6iKpxbKQ4DbiMfENc34P
	fbLYK5ovRh1n0qmTXT7haAXN3N14rle1rDBiURy96B4FsyH1DNlqElBPnxaKOmx8mE7AFiFU6Ja
	+1hWNAyxms1nlnAgVH18JgKlJEl3uZ/m+N4buyuqxdG+n3eSarNvrQZE3ZJlkGN+1KGtf2GYclV
	hwLwir9S8HrB6R+knP6bK5WfrUTKUpaSC5Tq5E+lA6U0VtuOjdBx//BiYNBjkJNb14Adj0uqsds
	IYfEws6a6lP/3mb7tsbGTjShfx7KB3+9rvKjvxWKbZwiBul8nRRkJeMfYixP86qeyE+sF3ptJj9
	WJvAca8R++MtzVHt/6S3cY53Z5FxBMHgRH8UQhTwY=
X-Received: by 2002:a17:903:8ce:b0:2c0:b4f5:41ea with SMTP id d9443c01a7336-2c1e7e93bf0mr125718445ad.17.1780855108460;
        Sun, 07 Jun 2026 10:58:28 -0700 (PDT)
Received: from localhost ([116.72.144.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629cf89sm156972585ad.56.2026.06.07.10.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 10:58:28 -0700 (PDT)
Date: Sun, 7 Jun 2026 23:28:25 +0530
From: shaikh kamaluddin <shaikhkamal2012@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	pbonzini@redhat.com, skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 0/1] mm/mmu_notifier: Add async OOM cleanup via
 call_srcu()
Message-ID: <aiWxQSlfcAZCZrnw@acer-nitro-anv15-41>
References: <CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com>
 <20260430141639.10815-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260430141639.10815-1-shaikhkamal2012@gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: jkcodo41jazaytiu6ypp9hbh96fpo44f
X-Rspamd-Queue-Id: CA36A40007
X-HE-Tag: 1780855109-482353
X-HE-Meta: U2FsdGVkX19cfRKpU6BRlJpPVdyBt/nQdkA3t1EYWm6LUgqPIyxe4uJrPzgpbP7o2gIM93PlbmTnsCCTBa1gE3mgrBD1HVzUZuQtHGeQen7IQbt7FPwsZ0rzEY0t5taomato5h0nq8pH8+8WisIDvh/S0n8W1GB4kIcSjChmiFhkWhj2Y6kMALCqjswzWTYDc+QXESonuxobLb00bl35cm68KtTA8R9Tw0atc3r9vzo9T5M3bBlVmzkDaBO3K1D/4wmGyw85I1gWWjHLfOypV/pBc9fNwRGfIHmt7WhRFJvJyJjVcYCEDWFVO0UuG95NtewIk+P/5b3QwxRoWSkyeMq4oKMjU6oeTR+5IpH4EwmhHYFTKWypPWIJr7OsvwD1FalFbP/5SBEduh19LGII4tsIuNGEaZJA05Yaq9VYJzsDHbjXfZ7ubq9sMSIudXFXhUWgk4BSuU9qGDK4x+1qqW//IC/8iQCkv4671P4hx0cDSvn/t5z++3zWEiybc8I3AGjgE8V6h0gAsiF8lbrecvVEKNkjunWxCZtz1uQbRzWM+30ieMOqusJ2OVLTjPiJiKMPgau5gkGQbx0CXfxCrqMilpBQtmkMcPELPLV6AiI1w72OxSMI8Z6pJx0h0B2BfuU+k8N/bMNzEuGnj8rDe8uahMRvBq4qObo6dypeUB234Nx62tBnv/6Gh2+K8OuiWDhR3TflphcGdTXkWha+oOD3dl4YxgXnlOceR9nxrjQH3t/BrDB2deIBtCMPLiLOa8iEJbbTAJmDleroJ8i1xYu8ePjPUv9CTl6swCaNKOBMRxHXnzU7SPTmmmChlFprpB+Lh99prKJEcEoZBP7km10nYuN3b5rHe5VLhM4++aWe7c7a8W66eS0dzQ3IHOCEXNlxG0f1SRiNBhpOPoHkx4B76ANI3Yf7ub1FvBJ4J6XvYU9YSRra+oDfj/8ianOnEmzM8UHr/B9s4tg/WYT
 vUFZy6Fl
 2Ay+fo8xV2bS6gYfh5pCbIBP7N6865DHAHV2cSatPvdQcf9U+hSO6bpOTExa4B8RRgRaU3XWByljUBJnFocxc/jGjHz4/rWYXfqRJNtVzl4ZkUig/g9mHQG0AnkkCamGrG3+p3iBKgxHrdRLHB6/Lm1OeH7bbSvuko05IWCzU6JvVhhFenTJn/8VS2xiPmCo5xEkWkI97nCrO0aN/2SSiq+RxQ2ks8EHr1h2lwsQ+vV9beQW5/H7XCmgn+HjpYrJ9+rH9c26MMqiFSFYJ178JZgMw1ge5/82NjenM30jSuIYYLYqXeR8NHcosJAb+qPHx52FWrsyCGiJbyrXzC5C2N6vxxfIdnkMb/dMG77BHPjN0/deOpycsW5OWaQWnbp9cxT/yzD4KArUWIdTwokzGmXPXrND2DZs1uIzv2sB5ORrtNehoDPm+bj9jGJ/dFoOT9+kJE8Z8qVndvQU/mFlr+odkazRwT2rilIVcGzqoT6IOqs04Jy7JnNRCicyRi93NgUwFtgoRzRnKcn90TrqMzvQSM8F7gI0i/MCVAdy0gaDZR1+MkZ671ihjh531obeoJdLk8K2ELn4KEMOk2JCgZGhC+HRFGgoZ4VHggCGQo1cDc7seSJmrabbqlAsXIJjIuHKdk3XYeAdQjwY3NolLLHEBpvytowj1X9ilrgpzVudYvOKO5MrjVujvh5FAvjy8EAoTTFSC3hpeXMddrKsOPDhd8YN1gr1dPvhg/gBa1V23/u87ZtDk9b+6U3N0NzyyqBtz2H/8HEs+2DCzjHBHtDGnDjekdbSmEzGh22YQCLyjhTt39W/OPkaJT9mkA08HVFErUvGbzGbQ4NFM3uncxmZA5lKYA3Dn3/dKmPh/B1o6M9mQ0TalHW7LNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 07:46:39PM +0530, shaikh.kamal wrote:
> This series implements the after_oom_unregister callback design
> proposed by Paolo in v1 review [1].
> 
> The current OOM notifier path calls synchronize_srcu() inline from
> mmu_notifier_oom_enter(), which can deadlock on PREEMPT_RT when
> locks such as siglock are held. This series moves the cleanup to an
> asynchronous context using call_srcu(), allowing the OOM path to
> proceed without waiting for an SRCU grace period.
> 
> Subscribers opt in via a new after_oom_unregister callback in
> struct mmu_notifier_ops.
> 
> KVM is the first (and currently only) user.
> 
> Changes since v1 [1]:
> - Implement after_oom_unregister callback in struct
>   mmu_notifier_ops as proposed by Paolo
> - Add mmu_notifier_oom_enter() to detach subscriptions and
>   schedule cleanup via call_srcu()
> - Add mmu_notifier_barrier() (srcu_barrier wrapper) so consumers
>   can wait for pending callbacks during teardown
> - Move call site from __oom_kill_process() to __oom_reap_task_mm()
>   to fix KASAN vmalloc-out-of-bounds observed in v1
> - Use hlist_del_init() to keep hlist_unhashed() correct for the
>   kvm_destroy_vm() detection path, avoiding use-after-free on the
>   stack-allocated oom_list head
> - Add KVM after_oom_unregister implementation to clear
>   mn_active_invalidate_count
> - Update kvm_destroy_vm() to detect detached subscriptions via
>   hlist_unhashed() and use mmu_notifier_barrier() + mmdrop()
>   instead of mmu_notifier_unregister()
> - Remove pr_err() on GFP_ATOMIC failure per checkpatch; the
>   trade-off is documented inline
> 
> Testing
> -------
> 
> Developed and tested under virtme-ng with PREEMPT_RT, KASAN, and
> lockdep enabled.
> 
> Test setup:
> - simple_kvm.c: minimal userspace program that opens /dev/kvm,
>   creates a VM, registers memory, creates a vCPU, and sleeps
> - CONFIG_DEBUG_VM-only debugfs interface (not part of this
>   submission) at /sys/kernel/debug/oom_reap_task to invoke
>   __oom_reap_task_mm() on a target task
> 
> Test sequence:
>   $ ./simple_kvm &
>   $ echo $! | sudo tee /sys/kernel/debug/oom_reap_task
> 
> Observed with patch applied:
> - __oom_reap_task_mm() completes
> - mmu_notifier_oom_enter() detaches the KVM subscription
> - call_srcu() callback runs after (SRCU grace period)
> - KVM after_oom_unregister clears mn_active_invalidate_count
> - mmu_notifier_barrier() returns cleanly
> - No KASAN reports, no kernel BUGs, lockdep clean
> 
> Stress runs (20 iterations) showed consistent results.
> 
> Reproducing the syzbot-reported issue
> -------------------------------------
> The issue reported by syzbot is reproducible on an unpatched
> PREEMPT_RT kernel, triggering a "sleeping function called from
> invalid context" warning in kvm_mmu_notifier_invalidate_range_start().
> With this patch applied, the warning is no longer observed..
> 
> 
> Known limitations
> -----------------
> 
> Failure of GFP_ATOMIC allocation in mmu_notifier_oom_enter()
> causes the corresponding after_oom_unregister callback to be
> skipped. The OOM path cannot sleep without reintroducing the
> deadlock this series fixes, and synchronous execution would
> require waiting for SRCU readers. Cleanup still occurs later via
> the normal unregister path. A mempool-backed allocator could
> address this in the future.
>
Hi Paolo, Lorenzo, Sean,

Gentle ping on v2, which implements the after_oom_unregister
approach Paolo suggested on v1:
  https://lore.kernel.org/all/20260430141701.10859-1-shaikhkamal2012@gmail.com/

The one outstanding issue was a build failure on !CONFIG_MMU_NOTIFIER
(arc/hexagon allnoconfig) from the kernel test robot, now fixed by
adding the missing mmu_notifier_oom_enter() stub:
  https://lore.kernel.org/all/20260607152830.8775-1-shaikhkamal2012@gmail.com/

So it builds clean and is ready for review whenever you have bandwidth.

Thanks,
Kamal
> [1] https://lore.kernel.org/all/CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com
> 
> Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
> Tested-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> 
> shaikh.kamal (1):
>   mm/mmu_notifier: Add async OOM cleanup via call_srcu()
> 
>  include/linux/mmu_notifier.h |  10 +++
>  mm/mmu_notifier.c            | 123 +++++++++++++++++++++++++++++++++++
>  mm/oom_kill.c                |   3 +
>  virt/kvm/kvm_main.c          |  27 +++++++-
>  4 files changed, 162 insertions(+), 1 deletion(-)
> 
> --
> 2.43.0
> 

