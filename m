Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C251FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D836B0088; Thu, 30 Apr 2026 00:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E626B008A; Thu, 30 Apr 2026 00:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76466B008C; Thu, 30 Apr 2026 00:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5EDA6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:43:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 756931B98FA
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:43:17 +0000 (UTC)
X-FDA: 84713978034.01.A008C6D
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD31040003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:43:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nq8YJAmX;
	spf=pass (imf27.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777524195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R56QgG1D9bXIBDN7pmrJ8rb2E5GLXsJR+QR5OWKoEXY=;
	b=imKCKFhSf3FkbpJjkjFigPdPjP0AdBpz0SFVeTiX2T1rbXLkyGOrq9WuIC6oXSWu+pv271
	gNzY1VS4OsNdaHn4w/LyMnMopJS6Se9rZtHMJq1l9a2fNVaTyKZoZDA7D3/I3lXinsYtKh
	jeJpu+GcQCRv6464v4ha3+oEtDx3C0E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nq8YJAmX;
	spf=pass (imf27.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777524195; a=rsa-sha256;
	cv=none;
	b=N+0GrER5nVojqao31v4HMW3tgMZLIM91375nGtOoEjhDC5uCl490JhkcC1k5o3PNvQuMie
	ZbF4rITQymSXZKCEb5RNOHN1UYYQHILyl1ZEqHI+jb8qyQXTtQ4Pd6x6VVF4MVzqjr2aA9
	S9ahPKJOXEwE1YWHKDEKlKod0vYOxpA=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35da8d037a5so193443a91.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777524194; x=1778128994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R56QgG1D9bXIBDN7pmrJ8rb2E5GLXsJR+QR5OWKoEXY=;
        b=Nq8YJAmXVWBGJS6wA5ciTKRJxfiRHFsQQYGe9G44R9hZOnzfXVzqZO9ET8nnc2eJFj
         gFUeXY/en4Lm2M7DE41nsw8Zj0cDJ8fdyHhfUa4tUJDYic3VY9JQjFgV77qE/z0Mqa+S
         ITVq3ineG4JSL4m6CTk+xHpolNk2i1kKhFNSw40aFK7lpWIeYIAPJW6oXvC2gUU7IOz2
         eeuxFM+Ci13gAikXxpRQPrpTzINIPyyguAPcL+SrQunbvn/F5dq667agFj0jjh8CODZX
         E3z7UzVznW7UoETSxqm33plZR9AWltxPN1TETQFE8rYNlBzZNvgw5VZb2qjJizVkpopL
         fpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777524194; x=1778128994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R56QgG1D9bXIBDN7pmrJ8rb2E5GLXsJR+QR5OWKoEXY=;
        b=AzqXLTsmZomojBzTWwcE21IKiWCIPUcIHEYOY9cjpiokXeewDz6M55WLxvF5AuDd1H
         1PjsG8k+5tgPsivjtf6zCbCcHMo9Fr5480zNieJ923WhSXjeDZ8rI6EGfD11Ze/OHARK
         pg261KutaXba5oFd/n2grDquaFP3OZ5q/KNOFuqQKlRT6aGappPS1RUsUZfYGKA6wTp6
         ty3QccOJmf1D2YqIzkeAti86C9oRWwLmROzHaktS6c29NtYIbwmrdLtlEE2wY4UMJtOl
         Aw+LypZcBPwZ5sO6d657St64ibnZWeb+iiypVo46Qk5q0Cv68pNSDvvTClea6FrLJyI1
         uQyg==
X-Forwarded-Encrypted: i=1; AFNElJ+U9Gt/QqB0tX1hhMjF3PSfLlkXvn/zYQtbO0rBHjRjGI4y92KfjKK9pP9NnLOIy0rTv93bdUOF+w==@kvack.org
X-Gm-Message-State: AOJu0Yyc8wG4WDGc0UD4AqvlZXbppiwiH+FvT5/sOZMo/dDf/5rDKdqC
	XxiCbfGbtidTjTAef74PC+XDL5ACADw+BvxFix809ORqPkYcRroNaMYW343++90kF+Q=
X-Gm-Gg: AeBDieuXGJv+srRD4sr0lkCKnSEOc3/9la9zYx3uQ43z7NmfDKdH63/JFMAwG3vu46z
	GfPyx25LB2/gvmF6hYWpdSIvknZIBu5HtlfmvdA1/mmbXvELFfChikPa8Chf+xMn7mWHA9f+4Qg
	txGuHr28WXieOWAopK7HjpuWsIrra1GEK4zrbrkNgmK/OkgIbXTjT69+IQNyosTQPvIEx2bQUhx
	dAs4uRKBkYle7X0Zz5zy4RaHw5y/BX2eiA81v0OyNkNw+Vn9nlYyb7ICW9N0qNXEewCt8gk5HZo
	DM1QV8NaYuftspo/oYZ22hpt8uf1LCgQ/D512+xbDGU/+fTLHdsPNAimvVtV25B/LmnTXRlTUEN
	jCYIcoJPyEFM87pbhPLAr5GALpyk+xmXF+ofWuKukrhRATWESMtKZfIqXOEtr4b/TJ53QcBSkVB
	KqfRx2NPU7ec2ov9uZ2S56oe9fWivXCEHv66hO1wN23fxdqPh4BkU=
X-Received: by 2002:a05:6a21:6d88:b0:39b:da83:91aa with SMTP id adf61e73a8af0-3a3cf8cbdc5mr1452663637.51.1777524194416;
        Wed, 29 Apr 2026 21:43:14 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([27.4.92.188])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fd5e6e830sm3752482a12.6.2026.04.29.21.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 21:43:13 -0700 (PDT)
From: "shaikh.kamal" <shaikhkamal2012@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: kvm@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	pbonzini@redhat.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	"shaikh.kamal" <shaikhkamal2012@gmail.com>,
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Subject: [PATCH v2 0/1] mm/mmu_notifier: Add async OOM cleanup via call_srcu()
Date: Thu, 30 Apr 2026 10:12:29 +0530
Message-ID: <20260430044229.10736-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD31040003
X-Stat-Signature: gqqaowopc4hxziqgkuxx7nmitr4cm7io
X-HE-Tag: 1777524195-980278
X-HE-Meta: U2FsdGVkX19iRFWqAhgbh67bzFWHUwBePzpOuwHn3HbiK8JvMmY75xdGcEDZ92+xGxQGwMm77Ydm0s3OwjCCX5KFnZuSuNE+rsUSDAOVLhi9fUFjr0E+EA9fcIjsfincP7UiKfcUtR52ufJSaQ0e2BQon8PN9CB/gDI7v88eqvthvD1fiQLJupkQYUoHNQ5/foF7pAXf8/Bzgrq/8oN/G2vTw05UubHHIi9HBal/zCxbH5aioJ7ppkNUXo1QW6jN408IFi8pDnGaGhiiBpCBVlI2lnB8ShnvU2JCwRXpnHRF/W36OSqpg0/1N1BHU/MTXfeiAG5ItgzlA/mIYYx/1BFfk7HsQ6d49cVvJEVUZMwag1ugR60OstO5ucl1Fw3x+0wzTi4oHrANpMQti0yEuER1aUT5XJ3FblkzkiYqIYJ21bur1Ed1JHjO9RFWbQjsjTZO7FVytZhW+HuZ4lD5WGKFYJ+dz+xUeyo4Tx7Pq+F4LAs2rw6mnoYvRrbz0+nQjH7o6JODpv3BhClyl1bPkgvbRsGR8gwBoQdo59hpQRTbuR1uckIg5P1WEN1hy+0VEQPOZymLkGCFp0P87qzzvcYnuchqc828yFpWF2EINc4H09gf3Q+Ay736dgoVS0Gpj/ZJpz7VkHeAZJva+7BPvudHskbpgdvRAXCv+ZydrS05Js9+NGPT1arFvx+/9EfHvPHsVoK78T7oU/ioflpUUSmd9WDtKsMoSGaZD9Ek4TjGIVxg+qhZ49Xd/41SgXC8moolZ+KlpbgSWnAy7uMHtpLTt+Lf+kFqDkixk6kQhjvwzNNAkS+SPNPg7YYEAm0VqQWHxd7Se1vpbPcNS1A1sxMFkatL/hyRvkD4kqNdu+8ElSqnlgzXt5MH7S8T3OT4UNMPeroUNHh/C8GNQAMnKGxM4TLAN84U43yGZizJSOU2WzQN/zoqqwmA+ZupnXRkW1OA3wKGkq0EHnVQp8/
 79Cgd+oZ
 KzrSsD+WeSbZP/YVuWos/Lh91OWXB2fU2cA0pfBjfIzb5j30oc0/5tdesDvM32LUZpsfbiYRzPob6OUJJhLXKcPU7gNWvq4Hgto7I2YIQyOQNU2b1fVnwXkJBuBdGMS4goLWFS86eutnH35UHgycUzdXvKE5kay22Kncl4ab1skpDm/NJ/D0p2t7hWyd0eb0t7ngTioSvro+UJnCyUScBqT6Gf+U6DdVn9SkRnmE1xbq25Qz71Sn1LsCsC8qzNbqkZC1fZOEwKh+7Ujz/1QDUo5B8fZ9iuVfil7zZfCAaieqNN2uurS+Mbu5sPAKJ76OcCjSoKuN+bAeeJhFpqg2AiN4+R0mU1kW2YFz5r2kkWEbCpcwEMHl1yeTeYObfXxspHO9WeKENVNfHm4NSZmz9oT9RXMKmJNWE0Gmkc1GRCgHjECx5N1F+55JnYzwWDRUL4yJxz0MWkGTkMBjOfUIAsFh0vAmSawAV9C7TWIE891+x9nHzw6E/2J2X6xia/sYh0vUn9VJVmQo+C3yy8/E5PI3VhVf9sKC8jbXKkUlo3cIxgwVhndawbGAARTM7YJIoXZlf/hOJguiYN02J/TiMU7hAE8xnHyZn5k0GBTIcZNEcOidmOYi6yN5dGV01sFLXx1zd6+/Rhv5pHMhCP2gfaMX20YdXVkELsLbG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series implements the after_oom_unregister callback design
proposed by Paolo in v1 review [1].

The current OOM notifier path calls synchronize_srcu() inline from
mmu_notifier_oom_enter(), which can deadlock on PREEMPT_RT when
locks such as siglock are held. This series moves the cleanup to an
asynchronous context using call_srcu(), allowing the OOM path to
proceed without waiting for an SRCU grace period.

Subscribers opt in via a new after_oom_unregister callback in
struct mmu_notifier_ops.

KVM is the first (and currently only) user.

Changes since v1 [1]:
- Implement after_oom_unregister callback in struct
  mmu_notifier_ops as proposed by Paolo
- Add mmu_notifier_oom_enter() to detach subscriptions and
  schedule cleanup via call_srcu()
- Add mmu_notifier_barrier() (srcu_barrier wrapper) so consumers
  can wait for pending callbacks during teardown
- Move call site from __oom_kill_process() to __oom_reap_task_mm()
  to fix KASAN vmalloc-out-of-bounds observed in v1
- Use hlist_del_init() to keep hlist_unhashed() correct for the
  kvm_destroy_vm() detection path, avoiding use-after-free on the
  stack-allocated oom_list head
- Add KVM after_oom_unregister implementation to clear
  mn_active_invalidate_count
- Update kvm_destroy_vm() to detect detached subscriptions via
  hlist_unhashed() and use mmu_notifier_barrier() + mmdrop()
  instead of mmu_notifier_unregister()
- Remove pr_err() on GFP_ATOMIC failure per checkpatch; the
  trade-off is documented inline

Testing
-------

Developed and tested under virtme-ng with PREEMPT_RT, KASAN, and
lockdep enabled.

Test setup:
- simple_kvm.c: minimal userspace program that opens /dev/kvm,
  creates a VM, registers memory, creates a vCPU, and sleeps
- CONFIG_DEBUG_VM-only debugfs interface (not part of this
  submission) at /sys/kernel/debug/oom_reap_task to invoke
  __oom_reap_task_mm() on a target task

Test sequence:
  $ ./simple_kvm &
  $ echo $! | sudo tee /sys/kernel/debug/oom_reap_task

Observed with patch applied:
- __oom_reap_task_mm() completes in ~3 ms
- mmu_notifier_oom_enter() detaches the KVM subscription
- call_srcu() callback runs after ~57 ms (SRCU grace period)
- KVM after_oom_unregister clears mn_active_invalidate_count
- mmu_notifier_barrier() returns cleanly
- No KASAN reports, no kernel BUGs, lockdep clean

Stress runs (20 iterations) showed consistent results.

Reproducing the syzbot-reported issue
-------------------------------------
The issue reported by syzbot is reproducible on an unpatched
PREEMPT_RT kernel, triggering a "sleeping function called from
invalid context" warning in kvm_mmu_notifier_invalidate_range_start().
With this patch applied, the warning is no longer observed..


Known limitations
-----------------

Failure of GFP_ATOMIC allocation in mmu_notifier_oom_enter()
causes the corresponding after_oom_unregister callback to be
skipped. The OOM path cannot sleep without reintroducing the
deadlock this series fixes, and synchronous execution would
require waiting for SRCU readers. Cleanup still occurs later via
the normal unregister path. A mempool-backed allocator could
address this in the future.

[1] https://lore.kernel.org/all/CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com

Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
Tested-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>

shaikh.kamal (1):
  mm/mmu_notifier: Add async OOM cleanup via call_srcu()

 include/linux/mmu_notifier.h |  10 +++
 mm/mmu_notifier.c            | 123 +++++++++++++++++++++++++++++++++++
 mm/oom_kill.c                |   3 +
 virt/kvm/kvm_main.c          |  27 +++++++-
 4 files changed, 162 insertions(+), 1 deletion(-)

--
2.43.0


