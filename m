Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0829BC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 17:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E078C6B008C; Sat, 19 Sep 2026 13:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7E36B0092; Sat, 19 Sep 2026 13:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6216B0093; Sat, 19 Sep 2026 13:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CAD06B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:14:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5825E802DD
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:14:53 +0000 (UTC)
X-FDA: 85231161666.06.2FE81A3
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F2394000C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:14:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMuCeZZK;
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789838091;
	b=Ey6sH5IzHooyV5/MZzBak0shQkfELVuRlATSL/gmJ7BB6uJTgDYgNf5/+DJitUEeHRNhzl
	dH/I1S/1DrI42sTR570sCRgiTTekJKFaX02LpG1TEhO1U479fNQuncCST/jG5zvxPANEWU
	0fbSy8Z3hYtXmO/raRe6qFwVFTiMEpc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMuCeZZK;
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789838091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PO9QkOcRvzbwAD+Es+kdxYQwQzMtVSQSyoVPRMtp9qc=;
	b=eRYIxE26yNgeUn9SH7DhwkzMOu5pNZYPzJEUKq4cIU2LusDt2JTIuPhD/k1edbRAQ/bYQz
	q+iTEeiwPXFZAvLDAo39ywZ67zkSxMFMEOWOv8rfUwrJ8wVlnvVFPZhmVETVvzfyRV6yAp
	PE4ORzTeHvVIcqApoWPToacSSGpTNoQ=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d391aso11700255e9.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789838090; x=1790442890; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PO9QkOcRvzbwAD+Es+kdxYQwQzMtVSQSyoVPRMtp9qc=;
        b=cMuCeZZKOVoLGJL0VqdvhTVO5HH8yDAAoOzeawUkXdC7zpO6I/nUV3nts4pHxSfGT9
         MAfh7NlnHG0IN74lons0flGJCS20RU+aMTq1dEwhTkSjWRIK+ekkiTfDvpUmOhI1NqTp
         OTiPOfsjJCOIXLsZAqzW3jjdmjjPy/NeOZQ3iV3r8GEh4+evVjWliCfkkD56CwPssLLj
         e9yFSamCKDnY7WzaRB3g9XjqREvEkf+iShMGsTFooB/5iiOqhAPI1dG+mV0fTK9+xR4/
         xZY6FEwAdjvR7mvDGQmjBybutjjaRFs183uQZqyTPQrANjJt2sDhU0Jqc3VbtR64q3dE
         W1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789838090; x=1790442890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PO9QkOcRvzbwAD+Es+kdxYQwQzMtVSQSyoVPRMtp9qc=;
        b=wurS46QZqObPwdSRnSQ13EB8yANdg99daFnoUMt54RO6qqEJNYtWEiGbUVCJMqlFnc
         4BtMWhq6aZ5lgDTzU0pRjPRkbltYqa8juyJ5zYhWFjcBDO0zQno2ocdJaVk8c5hoiWrF
         SeJXWO4YTtufpdC5ciRi290HMdzPeWOqH/MKT7Vq8Sfwoe3Pz0Moxdpvg2fhDPRpw05T
         Wev26M0y6pw7HbajdClbRVfnxdKwduIDPf98kZOdPZjDCgOHqfGrPr+734eX0/IBLC39
         l4TCHFbsBTs3AoGeHyiQdKSYAgo7a77qXZlH9pBlrOvLJ38tbxWlpKlAiny076hUHpb1
         T6Ag==
X-Forwarded-Encrypted: i=1; AKwUvByONuiomYJXxuhZBsyjLh7bwad0g0Lbrf8AIzUZkltOsaOwm2O2lThUtuHcNZb7jnTuA1LmvKVayQ==@kvack.org
X-Gm-Message-State: AFuF++kSsnA9T7KNPwJbU59wmEp5QBk48e2R2wH2G1QwWPNeoIgB3j4p
	oOOnC7AVbTPHv1KuSaG6yX7VZwZeIkA8AnSCOAi2nI8tSVenWHPrb14t
X-Gm-Gg: AYBFou26DF0rbS55X3p7Tgau99kijBbZVTIHljwSXoy78u/eZIib2qmtBl95lR4Res8
	5lR4bP5aCVedJQcd+noQB3/JPOjWzj6DM7Ny2sMlAI5zS/MrQGxuynerwbs/U+SZlERIhS4D1qF
	t0lfX0Rymh2xL4+9pu+lDmE4TaaAMIZOFTYhlQzvviz5N4Y4JgH+t808OJk8TLQm9WrHNHKWpGy
	jnZaABnG+WcWM/Fz+LzjnuQyxxP8f9pvxcQolNRkkJmQk1Oyig66LBrWPcTY9AV7Uod6Pg75wfD
	gauI2Obtr9w0DXj3Ff2Yiz9pKxcgWa1Y45znY9SaOteCtxuvsW+wDNWhVO6T44DF51K9FedfRCO
	KAqqWl3+Zk/OS45Hu7MNXfpchqbar1mVCsjVb77lsIuPtFW9t5Rk9/UUN6eUIvtdGq9VgAkiEP5
	Ci1rcZpoIugwtwwWSEihIAq2c6MAqfWFXWZXS/cEs3/UYxpvq2zm/lDy8NxEbbTmTN0eSjHuRjK
	Q1es7KWgO7knqJC03bKlSUYSlqGc2LxcX7N80fpCeIXCLP/AxmZWOb2fNeeCIfzJZL9TbdMs+Tc
	q9tOWEwxcA9lyDONl1q8j0ScFyhKIK5zFMeRJ8JeIU9IkYSSsnVJdG/ZS/y5I7NPtHllgL95Llc
	1MYXBaKVhOjOpAQ0=
X-Received: by 2002:a05:600c:468c:b0:49f:c331:39e4 with SMTP id 5b1f17b1804b1-49fc5671095mr87272955e9.7.1789838089820;
        Sat, 19 Sep 2026 10:14:49 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487244608e7sm8986486f8f.6.2026.09.19.10.14.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 19 Sep 2026 10:14:49 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm: restrict can_spin_trylock() to preemptible context on PREEMPT_RT
Date: Sat, 19 Sep 2026 19:14:43 +0200
Message-Id: <20260919171443.90512-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F2394000C
X-Stat-Signature: aetkwdpbg9j4bai6bftz4k6jqmkdoi65
X-HE-Tag: 1789838091-147377
X-HE-Meta: U2FsdGVkX1/erXNcig2fZWrSEnk4wnKmEeZbnsElJO8L2lqJUVoHKOSHtxpnKZNq27+7uUQy7jg42pE5s4SY/ftTpKu/5I9jLhYVnhVtbOOZQ2bCmNm7g4rTfioBy2x6IfqZJVgQ9M1dvYL7OcdSBw57CqOW2ebxmkmJ7ay/wFSTZc6S6JxQFqUmMHIY4CepFdl70dqB5vEKqEpayga1ug/1yK26RO0s243SB0XqRQQRF+mylWSOFxcv0VOE4ebkQVrhJeeG2um/4oAhLQ7BamMlrVc4J4s3Kar3Qiz09ipuKpRV+S74t5o2VEfT4mIQhTcI9r238GywOCAS0PirEvJsNciQ70cIjIZ5z663wuXQSnwKGKwi3VgdvT+AUu2ISATguH3KT7Q5y7t3+/Baf6tpoL61QDy3eN5viyZo67A7/X1fJo/bheCX9sCFYlzIZs8NviVjR4qC00H8rP15CbcKMEz0FwdRR2+tEwdbfgyfxM7k5V2iQwwqFMqx35uk+AeW5wwu/5qUTSAWIcFFbM6UVpQK1mNaRflAsU65pefJjvOoTaYgk0+N8WEJ4ovthYBo9IkMJVpCgHfR8THxfH7GhQWzjoY//prOpSbBbFSt+lPaNgrOvsjm7zpse+xP4k6tQCp0Jqye9Wmmk+k4qsjE/+3WcRLSrfT0HRpGkrF0hsH/MK46umSrZGN4GoBbvHC7TWOw2OyFtaLlXyIZxfnpwBFmQBUXJUbJkpMQOMQWE3QGpQfPN5Bn7BGf5EiaUHi0Drnx/ec3UgM7RSuE6NS6hHkl0d94/cd+kUTCxmTrBBNcUE40HhX5l4XVMdfPNGOlo9cUM3CTnr7mjqWUWzYY89nVEsy49qNQfXqlLVFy0Ls+xcSgPPuX4U9ejseLRecRLVx1bA2s4DKnmKohd3XKDzILKtvoGeWHYXPPKZ1/Q1aqUosPsmUOv9qLDTnb7X6moqy1jm9QahM2YT5
 GJr48jsC
 +ug5Mq8M2hXFfYU9lquJGVLmd35bgXglS7WhsofJLC9IqMArTiTt6+DfIU+eDH1HvTIJE7LA59TuOGI7UTl5rUsdkzFnnRssUda+lTu+NPuQPYLUKhe1tUJKK3GHtAXob5KOnY2kM6gYtrbPzwqgEBpDEUeEKepcGEG1n7iaArKnjso7d0qM1tfzWuxzK5OZe3Q+Gfbh6XjEKR8L8jVi029d8D5dLa92WFkhBoxKFDlujuOGPfIXd+nS8bZlvRKSg1dvL5nN7ZUD2lHqFe6cFhlq67wleK3EHZP9edBzULqW0ImV24/d0992IifTDDx3S2eeevBiOlsJdzWkRryA58gzRBX1itreja1UMXg5M/WKYRXM1CC27pf5xAVG5CZubG2/2qiDKy+k+CT0iDhI8uQk8IXKc20+PVfzk75aJh1fyUFTcbx4tXCTatClPbyvnJZbqjqzwRMLNnYjDByhtnoZaig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On PREEMPT_RT kmalloc_nolock() deadlocks the machine when the caller
holds a pi_lock. A BPF program which creates task local storage from
the sched_waking tracepoint is enough. With it mainline hangs in 10 of
10 boots on a Raspberry Pi 500+ and in 7 of 28 boots in a 4 CPU x86-64
QEMU guest. The CPUs spin on raw locks with interrupts disabled and
there is no output.

sched_waking fires in try_to_wake_up() with p->pi_lock held.
can_spin_trylock() refuses only NMI and hard interrupt context on
PREEMPT_RT, so kmalloc_nolock() does spin_trylock_irqsave() on
n->list_lock, which is a sleeping lock. Two things go wrong:

 - rt_spin_trylock() takes the rtmutex wait_lock under the pi_lock. A
   regular kmalloc() on another CPU holds wait_lock and takes a
   pi_lock in try_to_take_rt_mutex().

 - If the trylock succeeded and a waiter arrived, rt_spin_unlock() has
   to wake it. That is a try_to_wake_up() inside try_to_wake_up():

     try_to_wake_up               raw_spin_lock_irqsave(&p->pi_lock)
     rt_mutex_slowunlock
     rt_spin_unlock
     spin_unlock_irqrestore(&n->list_lock)
     get_from_partial_node
     ___slab_alloc
     __kmalloc_nolock_noprof
     bpf_local_storage_alloc
     ...
     bpf_trace_run1
     try_to_wake_up               sched_waking, a pi_lock is held

   The pi_lock held there belongs to the woken task, not to current.

Commit 99a3e3a1cfc9 ("slab: fix kmalloc_nolock() context check for
PREEMPT_RT") closed this for v6.19 with a !preemptible() check.
v7.0-rc1 relaxed it again, see the Fixes tag.

Allow preemptible context only, as v6.19 did. A held raw spinlock
implies !preemptible(), so the locks of the caller do not have to be
known. With this change both machines pass 10 of 10 boots.

The nolock allocations then fail on PREEMPT_RT from every context with
preemption or interrupts disabled, also where no scheduler lock is
held. Creation of BPF local storage from such a context fails, as it
did in v6.19.

Fixes: 073d5f156292 ("slab: simplify kmalloc_nolock()")
Assisted-by: LLM
---

Notes:
    RFC because I do not know if that last paragraph is acceptable for
    BPF. 073d5f156292 relaxed the check on purpose.
    
    Harry wrote that the _nolock() helpers can be called under pi_lock at
    least in theory, that it was tough to reproduce, and proposed a check
    of current's pi_lock:
    https://lore.kernel.org/r/apfwshahN_C6jBSn@nixos
    https://lore.kernel.org/r/apfyeYF8IE03aazT@nixos
    That check would not see the pi_lock in the stack above. Sebastian
    described the wait_lock and pi_lock order here:
    https://lore.kernel.org/r/20260831143500.x-saxdAs@linutronix.de
    
    Same config, program and load for all rows. x86-64 QEMU (TCG), 4 CPUs,
    PREEMPT_RT, no lockdep, 60 seconds of load per boot:
    
      v6.18                                  10 pass,  0 hang
      parent of f484f4a3e058                 10 pass,  0 hang
      f484f4a3e058                            0 pass, 10 hang
      v6.19                                  10 pass,  0 hang
      parent of 073d5f156292                 10 pass,  0 hang
      073d5f156292                            0 pass, 10 hang
      mainline 40288c9206c1 (v7.3-rc3)       21 pass,  7 hang
      mainline with this change              10 pass,  0 hang
    
    f484f4a3e058 ("bpf: Replace bpf memory allocator with kmalloc_nolock()
    in local storage") made the path reachable.
    
    Raspberry Pi 500+, arm64 defconfig plus PREEMPT_RT, same mainline
    commit: the output stops 1 to 2 seconds after the load starts. 4 of the
    10 boots were then reset by the hardware watchdog. The other 6 made no
    more progress but still answered ping.
    
    The stacks are from gdb on the hung QEMU guests, I have none from the
    Pi. gdb does not unwind through the JITed program. The frames below it
    are from a raw dump of the stacks. In that capture three of four CPUs
    wait like this for the pi_lock of the same task. The first case looks
    like this, two CPUs from the BPF program against one regular kmalloc():
    
      rt_mutex_slowtrylock           raw_spin_lock(&lock->wait_lock)
      rt_spin_trylock
      spin_trylock_irqsave(&n->list_lock)
      get_from_partial_node
      ___slab_alloc
      __kmalloc_nolock_noprof
    
      try_to_take_rt_mutex           raw_spin_lock(&task->pi_lock)
      rtlock_slowlock_locked
      rtlock_slowlock
      rt_spin_lock
      spin_lock(&n->list_lock)
      get_from_partial_node
      ___slab_alloc
    
    With lockdep and DEBUG_RT_MUTEXES the same program gives "possible
    circular locking dependency detected" for wait_lock and pi_lock on the
    first event.
    
    The program:
    
      struct {
    	__uint(type, BPF_MAP_TYPE_TASK_STORAGE);
    	__uint(map_flags, BPF_F_NO_PREALLOC);
    	__type(key, int);
    	__type(value, long);
      } per_task SEC(".maps");
    
      SEC("tp_btf/sched_waking")
      int BPF_PROG(on_waking, struct task_struct *p)
      {
    	struct task_struct *cur = bpf_get_current_task_btf();
    	long *v;
    
    	v = bpf_task_storage_get(&per_task, cur, 0,
    				 BPF_LOCAL_STORAGE_GET_F_CREATE);
    	if (v)
    		bpf_task_storage_delete(&per_task, cur);
    	return 0;
      }
    
    The delete only makes every event allocate again. The load is a few
    loopback ping floods, tmpfs and block writes, /proc walks and fork/pipe
    loops, so that list_lock sees contention. The program is more
    aggressive than a real tool and the load is synthetic.
    
    can_spin_trylock() is also used by the page allocator. Its nolock free
    paths fall back to their deferred lists. I did not test those
    separately. Kernels before v7.3-rc1 have no can_spin_trylock() and need
    the check in kmalloc_nolock() instead.

 mm/internal.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c94..29646c4afb419 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1641,10 +1641,14 @@ static inline bool can_spin_trylock(void)
 	 * confuse PI logic, so return immediately if called from hard IRQ or
 	 * NMI.
 	 *
-	 * Note, irqs_disabled() case is ok. spin_trylock() can be called
-	 * from raw_spin_lock_irqsave region.
+	 * Task context with a raw spinlock held is not safe either. The
+	 * caller may hold a pi_lock, like a BPF program on a tracepoint in
+	 * try_to_wake_up(). rt_spin_trylock() takes the rtmutex wait_lock
+	 * and can take a pi_lock under it. rt_spin_unlock() wakes a waiter
+	 * if there is one, which takes a pi_lock again. The locks held by
+	 * the caller are not known here, so allow preemptible context only.
 	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
 		return false;
 
 	/* On UP, spin_trylock() always succeeds even when it is locked */

base-commit: 40288c9206c17eb66a603262e06a58d300d0f279
-- 
2.53.0


