Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A389CD13DE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F706B008A; Thu, 30 Apr 2026 11:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6C46B008C; Thu, 30 Apr 2026 11:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34386B0092; Thu, 30 Apr 2026 11:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2CE86B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:16:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E06C146BCB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:17:04 +0000 (UTC)
X-FDA: 84715423968.19.A2D737C
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5159F20010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:17:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Fm/0FQRR";
	spf=pass (imf13.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHo9iPjyCSduKMwgGnNHZX/dT+4HXSckBt2Ukm/+PI4=;
	b=AmO/Xgy6Em4x+Gd2v7tNtRHAvRqkqzX2+0wbAi1HZcqZWk0oBCYmFRBZyjcdeeH5JUPRDb
	t8XA/1I3iTtuFOKJP+82zmls8gW3mbhDJP3axyy+gmjBf9ZkOZmL5kT5SkaIHlnGZqiacM
	uMolunL0Kk1Xbhyf6m7nwBGt9UXLDbw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Fm/0FQRR";
	spf=pass (imf13.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558622; a=rsa-sha256;
	cv=none;
	b=165vhDEqLGM61dLdSUK7LVNuKkueQI/XDjiP+LHf2HA+SjNKT3Z88HT999ufEYSaLpZRtq
	l3LFHAJ2NIIP0t8xi8zOS2zQqA2ZdtQCjEepzfSwVeiZGeTk16U/ZU8QMKo/ek+tLytxsr
	3fvVpZCE8yB6v31vfvWrHz/cRCfh7xA=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c7358a7a8d1so564477a12.3
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777558621; x=1778163421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHo9iPjyCSduKMwgGnNHZX/dT+4HXSckBt2Ukm/+PI4=;
        b=Fm/0FQRRI+ic+PT9/AsG9ynwYGs/h2GJEkbliOppSqDuOPNyrRgqvuPXgH6BNF1ln2
         OG+i6FCC9KPvqL0dKlZHn2R/ic93nTEc4QmZALSdsuDSOYQVU6swOibIIREsSHuHF1A3
         MvN5/pZT070RpxwWSwy452sy/rrxTk9gDDet9whh/Q9X9o70p5hp+ikjlxp3IVWeoSNi
         pijL2svQwnrPnEG9PqpJXRjFD0DqvLshRK8lhEO51Y0CZq5OSJcqiSTFvq31UnZbuzHT
         T1MCw6YIcJHzvTrt2Smzj157Ot1SPcjOa6vuQzqGPQDEpv2y/hZ2WZXRwT4JXkpJJURk
         Tdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777558621; x=1778163421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aHo9iPjyCSduKMwgGnNHZX/dT+4HXSckBt2Ukm/+PI4=;
        b=DW0jwxDEIFApG0zfZEulgmo9pgNzw2FPwhOk10hEwjAr8yiibtnad9CCnkDJhJC/6R
         07Re1ghSz2f8bqocvmUAl619n6NCPTSJp+zaOyasNC5zoRX1aPHWYAUDcmpqi4qePA+C
         9/D/qJC/6fgwzSU2H+EKYh8CeywTDCgAYbsZSvzTQC7VMCJhR3tmirztZ/MFdpUjRQ8X
         oCPQ6Tjls+rCTeuGGuQgBaFd/fv6pqf3s4VUMBQcAisQA/LamEELGrPknIaMvwNPgkK6
         Yz7/u+mccwp9cd2My+bRZz7DLo8CUvR7IRZeHNgXDOxD+sThCLP6dzUptL1Gpa/fVsdd
         Zh7Q==
X-Forwarded-Encrypted: i=1; AFNElJ/7KPQy2YrpLQY3gWqUntAj2xVw8aInjWapfClTYvvdlSqvaGhDKnr8sIuDcNNF0o8wBmDOaOPzRQ==@kvack.org
X-Gm-Message-State: AOJu0YwmQ+xvCipDEalm2BpxnV5cG6+c4+8I1Bkqz7DIcdbgPkXhBetT
	y64/aTbon3P8MX5u2sqv2IPqaL6hCOarWX8Aqs2e/qNKkbkS5PrqBS9DvbwpqKakwno=
X-Gm-Gg: AeBDiesXJBzFbtO9Fk5kJv9Z+xyTkQfCwGv2q9wqpKXGQjYPBwulu3lRtr6uo+gcL7G
	xY4rTA2KcJnbMYcQhUQdDY8RbDhawRnZfMM8g/xiGK3x0c0rPkydlxsOMarPB7bCL+KKRaMw2tf
	9sFnku1N4I1yIyNTzAZcjt3SylpQf+byGFxEIXeCLZsC8RoCHoHYxuDRwYpzvJrmsdYjXWSBxKm
	fCT5izGzECJJkxit4hdzVvMvL6Yn47dOAlv8Ny/f1F4t95G2A2jQ3+4y/mZQMnUb7lO4T2ZjZ0P
	UFc4ryJb1ciLTTdvzTvR836q4cm+DcXhJm5ilIbNtZgLmjQTZjVldEmVmIxmJLIhPx/2luUUGH6
	mgewJq9i5QSmyJywKBmjZ2vUNKTfu4h6qSUWgZUVJuylp8pgEHUSTteIzk5DrDcNgQUdi/rJJy2
	StLjHOr3iur5rXvjaQ1FbSczeVGAiLNlSUpIvOMxB1dDiyQmdnLN8=
X-Received: by 2002:a17:903:3212:b0:2b7:a3bf:b2a0 with SMTP id d9443c01a7336-2b9a23054f1mr22891225ad.5.1777558620563;
        Thu, 30 Apr 2026 07:17:00 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([27.4.92.188])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9887ad80bsm57132495ad.37.2026.04.30.07.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 07:17:00 -0700 (PDT)
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
Date: Thu, 30 Apr 2026 19:46:39 +0530
Message-ID: <20260430141639.10815-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com>
References: <CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5159F20010
X-Rspamd-Server: rspam06
X-Stat-Signature: 7qutzxkcmozytb4pkuxd37bggihaahhm
X-HE-Tag: 1777558622-984733
X-HE-Meta: U2FsdGVkX1+rts3gy0wfMJtSFNBS/6kBDLqK++P3gDTC5qUydS49KQ/2wrSIHfxaPw5m309U2OCzZeM5Rj9PdLdcfEzbzzCeG1MQMc5Vmy9EqMSDaE5ywEYRr7VVhOAB07tcj/83M0hGl1cI+/Om1NpMUMaXuDoRDdYt7xiyZiJETCou4u7V7YQv1sKwy17VdI0CFd8qq+3X7sqhHBEeZ6HfCQqlylCNXx2FZMkM/r1s6jUR7sNO33ldZYDg8uFj1UZ2wIO5cL8bF+ypqyTsnfFyvWKsbTEMToiUJAHKX8FcusSVbRQ5XkOYzH4CrFNcuYKG81gn8twwQpqrpx8lIEVdwKkur7poHnMlPcUClyAQfbmO6SLWr8lkXdUP8Wwl75nOJ1whyT+TYgS6BwJg+F05vEn7qIoWvCVnA/jTeGBbG0gsH9j6T67hQ1iz5gTFCL7eRWR8o5sO58AjozKXYJUKOytYamMpx8TikfK0q90K1Imwl33CUKkfuTfFg63bkEC+yuYidM2ssgw91CZFGKxeLHOIfynbblGIGKYRR1qs25zAt7hk10SvOIFOgjkJVMEX3P8z5nRu4hTVG3YsLqnGYUna6Oj71xW5Lh1Ok90Gmch4S2as0cHBxUBvJVzGvZ2vA63fGySg+cWyN0zltqVJ+rmUIbzfCsFUkQzvMIg6Q7uFhnJNLoHtqK3Sxtb7WoraSOyx3xJn2rc4gkXdD/5MYv3blvKJ1Pm7ghhZp3uPHOTogj7Zs/UGlAKaolhXGQ4Z+6tnkS6dElQnYGUA08j+eFJ+QFhI9JA2B53BfSaB2JI70qKFkMFIkSM0mKx6WO1u09/vxchelf0aFv9ll+UnXgqL/5XMRkgFCUk0fCD6t9P+OgcRYlJwxoY8wAflkNpX3r+srw2pnc2LQvfP1smvswpEVpYxwp2UBh+SQ6trr8ZPd0XS8J9AZQxodx8xKVR36dsC/Iqykf5ufn2
 oMfRl3dQ
 Sm2zGFu9KU5sVpcqEXkZkH12iIJogmuNwim2a5qt/b5Ofm2V+9XPRJRNB7JS3QH/csNMkNuuwFdz52gVppm0YSueLsKv2r/I3/CJVJ36zKrT4m35AFPXy8+NIGD5lihY2FsjuynSBwJ/b0Vy1HlRPa9rmeiTlFsx+1y6H7JvekRja9G5+93G3UxOQRKIuxAXMyVqbTzQe51rfZZQiBKiAL/7YWndYeXxSFcUYiksMjPE1ipQ3EDN5Fo/BufypdIrJ1OIFzcifUAftY3/ERAnBESByQtrd9vUjpC2bef0rJITIWyMxG8LXynEzQOUkUToqrQU+kljDG+7ClUuLZd1TQtndmh3rW5HiWh5HVu2824eosEOCVYf1CO2PM2Uxcgn35Tz5cjNz+79GZkvatH10KD1tSa2U63j8KBAyDb6SR4K6VKfvEtiNa0CjzLF30skO9LomRRm/tZX2akUxu1V8Lxp1n8KyH8W4Py0kismBiwPNdcq/Z3eA5m3uB1SpKHTVKUA/sPe+BtF7sbh5Q6j6i/iro/yesVXdDu7XddZCEwE61GqhxtF0EI4/5afUDmuZ14uLxjWaRM2I3eSkbXWRdGN6T2KU1CkJnfZJyTYunRx1DE5DtYUCHW6X2mgIJNChDQTPQCt1j/dnDcXE93oTZ0nt7w==
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
- __oom_reap_task_mm() completes
- mmu_notifier_oom_enter() detaches the KVM subscription
- call_srcu() callback runs after (SRCU grace period)
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


