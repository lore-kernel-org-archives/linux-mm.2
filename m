Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2D1CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 13:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226876B0005; Wed, 20 May 2026 09:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D78B6B008A; Wed, 20 May 2026 09:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F006B008C; Wed, 20 May 2026 09:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB68E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:07:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9C0D402E9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:07:54 +0000 (UTC)
X-FDA: 84787825668.10.403AAC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C961040012
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:07:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dGbVKbMB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+xiaofeng5.xiaomi.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+xiaofeng5.xiaomi.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779282472;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DJi5FqTAjlw9Ue7TOcQ0hAttaB/s7a/XDUarCt2ATdc=;
	b=nlCp/QFNiafT5BPfsqXwL2MjkIu3zJllNcsGeZemv29KJGlVylb+6TSOF1v8n01ANL+VjS
	wK+z/CLdkTT0BDczdVJNIBaSDr6n2Dq+eI0i1QR+qIK8zn8oHmh5lcp/LHlK5wq6CP6dTv
	B2kwHih/DtGVOsbab9Tx+3FWTdmz+a8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779282472; a=rsa-sha256;
	cv=none;
	b=RFAB7HHDJYWDQm2Xz/tq+yi/dOWQeE9mcNedsKARD+3gzMVN0+og7AkVGAyzx23FCKBolk
	MTVgztGX00TdLVyrrgweGpuUPPYvUI/Gt7DBe2BnA1b+tNJxCHlSt/8xsIumE8ki8x5WDT
	Q6yyfmzQiQzlhx+7bxaWBRYuRV8+2Lo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dGbVKbMB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+xiaofeng5.xiaomi.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+xiaofeng5.xiaomi.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46D746014B;
	Wed, 20 May 2026 13:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCBD0C2BCB0;
	Wed, 20 May 2026 13:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779282470;
	bh=dZ8YSndQsoNmx7w+474HEfO6+r4dLksfCHyTRMvIML0=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=dGbVKbMBTmENUTX14fLZKzwa5pqcSaiWefChRqZvL6TxvVckKqG+wE94LQ2K6WF4s
	 4vO2Aj5Gw5oW/PTBLFpvFmGEQsVKe8WphQZRHESeW01eXu4v4X2Peog+xjq5pVHYP+
	 i/3n03MgXXOf/T5xC6AE2oDn6rmBoDmRIqt6MORhCr7jeTWcd07gVcUqYEJNKZ3GYO
	 1OcmlVOPfLzLLZEOjAEuhO02/NwonpUAZN1YJJtDL35CjX9KyZOVRNAFs4Op+dMvCN
	 zZEYKYQPUvW7RMuvo/9tjOmAP9zCYhSoUcDr3VYH6uhc7AmjKNd5GfQT+2Zr+g9B0H
	 mYRtfO5f8GVrQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9493CD4F3D;
	Wed, 20 May 2026 13:07:49 +0000 (UTC)
From: Xiao Feng via B4 Relay <devnull+xiaofeng5.xiaomi.com@kernel.org>
Date: Wed, 20 May 2026 21:07:49 +0800
Subject: [PATCH] sched/fork: Fix timer_slack_ns inheritance for RT tasks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-sched-fork-fix-timer-slack-v1-1-d4fc937245b2@xiaomi.com>
X-B4-Tracking: v=1; b=H4sIACSyDWoC/yXMwQ6CMAyA4VchPdtkbsrBVzEeRtdBRcG0QEgI7
 +6U45f8+TcwVmGDW7WB8iIm41BwPlVAXRxaRknF4J2v3dU7NOo4YR61xywrTvJmRXtF6rFOOVL
 jQkiXAGXwUS7Jf35/HLa5eTJNvyPs+xdtksyYfgAAAA==
X-Change-ID: 20260520-sched-fork-fix-timer-slack-6dfacb033d43
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Felix Moessbauer <felix.moessbauer@siemens.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Xiao Feng <xiaofeng5@xiaomi.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779282468; l=3123;
 i=xiaofeng5@xiaomi.com; s=20260520; h=from:subject:message-id;
 bh=Z8IuJn4aKUWAvDe5Kpak3owHY216za5bjiydkqmvna8=;
 b=Rtvgm49E2Sy9Gr8Xg2UYbouCShW1ZRLMLsLo7cdfQPp9S/JROW01+FZDMIBGw4YacqB4FdSVv
 elHmfiaTdouC2q7Rc3IOCOqsLqa98SPu0n1ej4v8jUXeYQw2zY+URpm
X-Developer-Key: i=xiaofeng5@xiaomi.com; a=ed25519;
 pk=RGje+zXrBTS+7klps4Lhq/+str3IGTgzLwYEkGwZfs0=
X-Endpoint-Received: by B4 Relay for xiaofeng5@xiaomi.com/20260520 with
 auth_id=784
X-Original-From: Xiao Feng <xiaofeng5@xiaomi.com>
Reply-To: xiaofeng5@xiaomi.com
X-Rspam-User: 
X-Rspamd-Queue-Id: C961040012
X-Rspamd-Server: rspam04
X-Stat-Signature: 87u794jyowmoirqgptsbc8y3tntcbtcc
X-HE-Tag: 1779282472-87680
X-HE-Meta: U2FsdGVkX1++xANNQDMX05+ZLOll6wkEMW7gqKcHA4Wacgj7eGRadzoqc4QlXTMbi/v4iny1mDwzv4MpZgSD/2kMJfJ/KGfRUT57otfamSUS1/dq4BiOZ47eBqUR8IpSbXnsl2D3b+dt27/5JTgtOwmuQAqt6G0VRKOC3933kK0U27sjWIeBl+0eBypg33QXOvkA7o9yySHmY7IyJ99LVC3m0LCexPOMp5zy1WMpPeKaJdm6ExQlrYzQHtOe8gYLiuDZP/AnBOEQARdpPjmO7sG3T5kYqigcERHR5MRKoZi6tym+64MPu0lJRn35mRGnYaFb+p94dd0xY7ESs/gcw2tVmw/EEhVgTocwGP7R5DqVzvmZeZ9oxjfaKEJSYWk+3t56fckdPMu3Op6PGdSw5un7bVBIn8hZPKVOE3rjx9hDRy3vvHmSU7aHM07Lcc+uy1SDWwNHT3D5vI2GNWLTKU8rlsjedxyw1Y2ToBxD27vAei/0Veqk3Y3oKwB/oSRyXY+Uul0raq2Sg5MemNZYnwTDRwZU//XC1RhZpcmTIW8ECJivhFQHbV0yjKznHoSx0mmBXERrIGLnLFXk9DVoHqvaDq5JVwXQCF+oQT/X0aBPoFOB0/8mUf172xRZA6HRZYkq4ix54D2RFE20qdLrciQKR8mAlTm0+MDixIn7sGmktrOvXIK27o1p8zIZ/cyCGRDe++ON+0hKdTHpTonu+1CWJwxhH2k6IQbz55Yxm8RWvv8WAEkIeclpBtWDMpxpa182v0mjG95HTYxDKqQdRxfXPHFIQ7kxPNpcqfykfEo4bY56NT7TkWnkeknjc3vJlTKAOUc4mwyb17fSGEg5NoTFc9CmwYPImq4XCMzuAB0nCjzeArDMPLHiqqvU5WEFXXkvNljlbrmvT14BjlBiaMVV8f0zMI4Q28WyYJrpL42E2k2aBv3tJrV6+ioXEHysxgH2iVQC2hRylZg36ah
 D5J2wiKu
 P3RFx91pm4pWsC+DIGsFFl0Yvqlygw7wypqLtaqCBCGeYKi3GbpJECQzIQv+APS4pKShjCncyz2mqK8U1qxWk32QJ5S1q0NB7QFC+E2nOH8B5GaHXx0Kz9hkFI8JMVmK3XDlkZm7F83AX4d/do6/UzvIDxm7TJO290eOhGXvtHPLsCMtmuVsuUT2lCn0iE/5czjnwq+9Ii2pOgHFLLuXu8XydbAIXJ1PebTnq4PG6RlOjLA297sAdrT1eunTdT7/kC0z+MBvgaVqiKi46QFlRr6iRbeBzcqDEFQ/CaMjBVUYGl3F3LbGeyx3mo5CC++JLFES2Irlrt3tvsEsdG8YTNP1Jv6d1bmj2TJizvH7wYykwV/DUEQhfkNySCukHc7Wq2XZIdopT9a2tqx3zDWCoL8UNJUtIqQaaMJTcBuwAbjbgivq4qY4A473s5zQus28Bsy9hIZkoc1m//mw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiao Feng <xiaofeng5@xiaomi.com>

Since commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack
values for realtime tasks"), RT tasks have their timer_slack_ns set to 0
in __setscheduler_params(). This introduces two related problems when RT
tasks fork children that end up running as CFS:

Problem 1: sched_reset_on_fork

When a RT task with sched_reset_on_fork set forks a child:

1. dup_task_struct() copies timer_slack_ns (0) from the RT parent.
2. copy_process() sets:
     p->default_timer_slack_ns = current->timer_slack_ns (= 0)
3. sched_fork() demotes the child to SCHED_NORMAL but does not
   restore timer_slack_ns.

Result: CFS child has timer_slack_ns = 0 and default_timer_slack_ns = 0
permanently.

Problem 2: RT fork followed by later policy change

When a RT task forks a child (without reset_on_fork), the child inherits
RT policy with timer_slack_ns = 0. copy_process() sets
default_timer_slack_ns = current->timer_slack_ns (= 0). If the child is
later demoted to CFS via sched_setscheduler(), __setscheduler_params()
tries to restore timer_slack_ns from default_timer_slack_ns, but it is 0.

Result: same as above.

Both problems prevent timer coalescing for these CFS tasks, causing
unnecessary wakeups and increased power consumption. Writing 0 to
/proc/pid/timerslack_ns also cannot restore a proper default.

Fix both issues:

1. In copy_process(), inherit default_timer_slack_ns from the parent's
   default_timer_slack_ns (which is preserved across RT transitions)
   instead of timer_slack_ns (which is 0 for RT tasks).

2. In sched_fork(), when sched_reset_on_fork demotes RT/DL to CFS,
   explicitly restore timer_slack_ns from the parent's
   default_timer_slack_ns, falling back to 50us if it is also 0.

Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
Signed-off-by: Xiao Feng <xiaofeng5@xiaomi.com>
---
 kernel/fork.c       | 2 +-
 kernel/sched/core.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5f3fdfdb14c7..c3ef5ebb3037 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2174,7 +2174,7 @@ __latent_entropy struct task_struct *copy_process(
 	retval = -EAGAIN;
 #endif
 
-	p->default_timer_slack_ns = current->timer_slack_ns;
+	p->default_timer_slack_ns = current->default_timer_slack_ns;
 
 #ifdef CONFIG_PSI
 	p->psi_flags = 0;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b8871449d3c6..9b63560a45de 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4710,6 +4710,8 @@ int sched_fork(u64 clone_flags, struct task_struct *p)
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
+			p->timer_slack_ns = current->default_timer_slack_ns ?: 50000;
+			p->default_timer_slack_ns = p->timer_slack_ns;
 		} else if (PRIO_TO_NICE(p->static_prio) < 0)
 			p->static_prio = NICE_TO_PRIO(0);
 

---
base-commit: 27fa82620cbaa89a7fc11ac3057701d598813e87
change-id: 20260520-sched-fork-fix-timer-slack-6dfacb033d43

Best regards,
--  
Xiao Feng <xiaofeng5@xiaomi.com>



