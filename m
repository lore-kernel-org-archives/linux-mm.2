Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96459606A323
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=oHV+JEw5
Received: by kanga.kvack.org (Postfix)
	id AC30B6B05B7; Sun,  8 Nov 2026 03:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A756D6B05B8; Sun,  8 Nov 2026 03:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967A06B05B9; Sun,  8 Nov 2026 03:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76CCD6B05B7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:41:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13840A0423
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:41:43 +0000 (UTC)
X-FDA: 85411308486.01.BDDA5F4
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2C0FC160003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:41:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=oHV+JEw5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=04OWJWl0q4USzjLVzwemPm053ugbzZoSSOQ6EL5Fbvs=;
	b=2b3IBLMuWk5z0G1UHkZF3MCTFJmYVOVfKciYX2bn505MEDZ9ytUlUj0Fg/BBHV4Em+sUj7
	N/pkmqvyX0x0rbUf7ZCvx/yjZ1hkNgem4jsJoYDF5OfEnxKScLjry1enf6agxzbcdjLwWE
	tiQm+hGC/dkNelij+6rxMCydwi1a1G0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=oHV+JEw5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf08.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.51 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127301;
	b=iEf9HjIZUnnQ2oM2B1jEe8+vblZYBsqKDwbSkf2QI3L+Q0FIV5v6pxdNspmyTlQVTqlNDD
	xhbYmhIV7X1kBXamrPoMkdun44I72h5ANrT8bfGJ5FQ2EnkhuEyLqNBSBFci5PGLPDeqc9
	HYPgtZ+wTURFwfRzLKNUgtvcCPY4cJU=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b0b3754f57so127766a91.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 00:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794127300; x=1794732100; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=04OWJWl0q4USzjLVzwemPm053ugbzZoSSOQ6EL5Fbvs=;
        b=oHV+JEw5Mn4CPBQmTrDWg6klXSN/1wQg2klfzOdIap6q8wGlB/nuGpUKE7pLgWzldx
         z/mYEt5qv43fvbh4rPkmVKT1OCpqKW5ftZ7Igcd0r2UTBrlpkpYR2PvtS51W7pFpYdVw
         e0A48ZkZa88HTa7vZ/LF2VBSTmiZP9KbozVm4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794127300; x=1794732100;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=04OWJWl0q4USzjLVzwemPm053ugbzZoSSOQ6EL5Fbvs=;
        b=zLs0tNvPzz4S5GSQEVwLCL0+bVMX4QzCPOCFGTkfmnSqYQWakfh2nM/Ag8Cc5AVv+4
         wpe+E+17pkpqeMedm0my/LVwf1ixeR6prH4Eo4jL7qH71yk2XWRXTU+cMsKop9oOYND+
         LXhRJTHIeARZEjsQmWRB6Q2ONUuY3OtBtdyNinpeLOfvcqaubctzDEb7Ce7HvlCsER7i
         kLdmeV52/g34Jym4ps8vDZynQ8X0005aTHHfy9pa7mb9FXzcf47NImTT9LATHcV3VvFb
         /dxeL0a2UfHbf0OmeLyKp1jcByaQuz9FwcPtw765vZAAd+BXDSen84e8fSe8OnyzY+Af
         aveA==
X-Forwarded-Encrypted: i=1; AL+hErGRuctm4vsfByxVtofqutWPCWviOFR8XB0UtPqoWAPpQ9blcQSZNSPCKz0Su7WZ+RYI12PVDlZ5IQ==@kvack.org
X-Gm-Message-State: APuU4Z+tfWmSfSeQ7v2xbfv/yKzW6uP/ZfZE3fdAewsP5EpDHSS7pQMD
	M3JVF9v+kfKB9wZwzt7YGFer8uB6xnW9Qs8Y0CMn9xdMsorAzijInBxPan7/uxcjPbs=
X-Gm-Gg: AYBFou3Vib3l1opuJnx/O1/qcHv6yHpxzjFkma/M3ZMtKh4UZ9I8mmArLymGxMJjybq
	Kf6AiLLkxIYHy6hTn7HDgG88+UpS8yWpoTnWXTJE0NaXEbvIje+0r80aUF+Je76wf+PeHOpNGAF
	bm9Bs8h3hn21ZgFbeZwIOS7wMCnONtlcSM6I4C8hm7s5iSByXfInCeG1EE4PNDku1Ry3+zmRdaT
	zgG1rOJvGzW8ix6QB2yqYBunSBSmbdH5DKjC19+YWp5oaLrmJD3mvnxc44QVb2iBZvIP7XoHDd+
	/Um+9zHwB9k69F81zPlrg7gIQRXo3ojG9XxLDmPv2YPLBOeALwWO3g9K4PUdi+txtpZNwkyLEl+
	sWGolB3k3c7fJdqpCbHQsO++BIoFeXm/Uysfq3bh1zqnJg03YjcmgP5+WXnKCl8WUOU8JYqET5t
	qxm6M6Lwu8XeOYtlEO0nZtG37YLraFbBAJyjDGJOXq0n/rs9LEfRNKYKOtqJxuLk14j7rajGmRk
	PLClszllHGS/zaNE5ABcme2wY9wGy4KfkdjbftoakJNLuC69jPANvmT0+pKIvgi/ORGLKLhzPpl
	mYL5lPRBqgFglYQYbuXBVVRcECPtSTW1RyMVKjE7IdV6D9sN+3accyE/EbbAjtfJm894NfdSNRl
	tZjD1DXLKtLBRcMS7JeHpTODHKZ3bGgxS2tLj2g+XCET1tfTlGM6E8UoD/sDXnNuWFhSJP0gPrw
	x5kIlfdCLkU4NtPDDlq/cf9L82luI6hE/YTnNIr+9qs59rruP/W+Wm
X-Received: by 2002:a17:90b:4b83:b0:3b0:ac2c:1619 with SMTP id 98e67ed59e1d1-3b12d3e713amr651515a91.39.1794127299954;
        Sun, 08 Nov 2026 00:41:39 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b101bc4586sm3906321a91.2.2026.11.08.00.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 00:41:39 -0800 (PST)
Date: Sun, 8 Nov 2026 00:41:37 -0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM victims
Message-ID: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C0FC160003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: k9yn618zhu8fwfguugx1nt565y57xp9s
X-HE-Tag: 1794127301-562327
X-HE-Meta: U2FsdGVkX19cSAZJ6pCiA1BB/3r6sf7q8DyXoXWKCTxodl/NoHDlzqDJcY8aukWNem17iXsTujON7Q/C2q0cL7I1Pl+ZyKnCCRwi0Vn3yVEiJM2Sl365qP7i4Tmn92Gbt6dGnsAuf/flBWQZAnveW6XNoHoBUwL4D6OaUU3+e80aObBIx62ZgRtG9tJQ4g69GmiimZdY6OrDoNeY9UbpHB038IkMHtMfeawEKZbHuTKEVLLHqHgQ7LuXl8ashySi7rYss3oSHmhClIZKJscMk94zs5+7EvU3SE3B3aodRXk5RK2nLtW6u5vY7xrQvQeAIlVA7Ja1Kcan2qDwAUokRhm8H7u9jWPcf5GfN0r0gn4ARqTg+0p84JWmwsYkn9fXSjVEYHOquz64mKOxKbiMbPetCvehBYgSF0Xb3BhM86X86XdpY9obhJIpgCW/heqwTa7sEV7eXJmCE6YKWBNQo9wYy0/PBh0K+aCtXoDdL7dJfPZUEAyBMsSX/AX5Bmd8XrQcUJkqgIh4KiBw4VQssw7Tq0mn7CisWKsIvYsXmcHR04Jcu/UkhF2vgkdQkc+l+lJRpLW/FSlBVCVoQiST8N/SQ0KX2y19w6pyFJJvjbPlXd33AZxNoW5sPRZfLFiiv9TL2vWx6K/bbtTAbLMliwwjTl02DmFemlwXI4LF4g5524w5IN9jjIZndasKwPPhspJZwEpg2orPzcTn4CvEanVoykyctSpDvseZCXkhUQM1Abe2DyPo6SS1e3OuON+/knqu7pvT9Ul8JH+l1p3y4LmItsMUfHiFgLGAZS3ALcLk9mrvrRPZMG2NdAtIujFzRA/F/P2+WFGJpkjAwoL7aQIyMlj8Z/Q7DmFH/rzGmGIE9mDmzejsDz6Wj+5DpXpk17nJiGh2o3t33yun+m1b0X89Pwk2fxy8HlFjehi2ca2lUuem9tnT5FxcJm8+Y3EKpX6GRa1A5k4b2KVrXng
 5gwhZbKG
 tSPXJeiMw87kimlAE8Mqu3rqsOsfnizv49QYgk4l/qZ0BJZ9BQSnqS0jPMD8ad0/UOVVe0gUP8J9gJ1HshFQs/FFMILRwo5xoihZOOlSjQuMC/07UJYP3/fbMJDg46SgpVEn7e7ntJ3evYeLj2FB7njQ6mQXbfVKXzjs0p9esWbU5TK85Fw0v04xILwkXRqIiFYGLdBlarRjuD6jpe3W6swEOk+NcMRs9wln8qyENrPJRV8ddblwYH6AdeiNyToNK/JkrU81nK5rUQWX6kcsNfTtkstRpPPIO28JcncqOS2No3DWm4NcngRgZdQ29IsmYNNgfl9VQWAUkChFpPIQcdsp2IZpGn2IvZ3PN2qrS0hIVpzebVeFkQjp5jehMNZYwD5dqX6iMFwnE/6ZUPHtW6AXg9YVih42lS3yydNOPoPEO3iGCXsEKMAEqiisJKzH11eiWWOTjVts0chIed025Os7oTa0bDIrAAC9D7vyy/+fadMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When oom_evaluate_task() comes across a victim we've already killed, it
backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
a chance to free some memory before we kill anything else. However,
since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
css_task_iter skips exiting tasks once signal->live reaches zero. That
happens before exit_mm(), so a single-threaded victim can disappear
from the memcg scan while it still has all its memory.

This can kill another process when the first kill would have been
enough to recover, and we've seen it happen in production. If the
second victim is in a cgroup with memory.oom.group enabled, the extra
kill can take down the whole workload.

In tests I used a 64 MiB memcg with swap disabled. I started a process
that faults in 44 MiB of anonymous memory, submits a 4 KiB direct AIO
read to null_blk, and goes to sleep. I set null_blk to take 10 seconds
to complete the read so the victim would have to wait for it in
exit_aio(). Two seconds after starting the first process, I started a
second one that tries to fault in 40 MiB.

The 40 MiB allocation hits memory.max partway through and triggers an
OOM kill. The OOM killer picks the first process, which has more
resident memory. With the read still pending, the victim blocks in
exit_aio() before it can tear down its address space.

memory.events showed oom_kill 2 in three runs. In one of them the first
process hadn't submitted the read yet when it was killed. The slow read
just makes the window easier to hit.

The cgroup iterator hides these tasks so that cgroup.procs doesn't
show processes that waitpid() may already have reaped. That's fine for
cgroup.procs, but the OOM scan needs to see a victim even after its last
thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
for sched_ext, so use it for mem_cgroup_scan_tasks() as well.

With this applied, OOM selection backs off while the first victim still
has memory to free. The 40 MiB allocation completes and memory.events
shows oom_kill 1 in three test runs.

Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
v2: Give more concrete details in changelog (akpm)

 mm/memcontrol.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..cb7cfae9ce5a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		/*
+		 * An OOM victim can start exiting well before its mm is
+		 * torn down. Keep it visible so oom_evaluate_task() can
+		 * back off while there's still memory to free.
+		 */
+		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
+				    CSS_TASK_ITER_WITH_DEAD, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
 			ret = fn(task, arg);
 			/* Avoid potential softlockup warning */

base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

