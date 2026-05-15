Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0311CCD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 02:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276E76B009E; Thu, 14 May 2026 22:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227CF6B00A1; Thu, 14 May 2026 22:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E946B00A4; Thu, 14 May 2026 22:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 044176B009E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:05:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A22B78FD2D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:05:13 +0000 (UTC)
X-FDA: 84768011706.29.6979BF0
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id E528740003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:05:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KrfXcqxC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778810712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SBIorJYDy2JphtLdFCSFt8OFwBCOyFtM6YXCh5ThwQA=;
	b=Rz7jmNQg3tOm65P3OW994HmQhEzmcp+E/xoTU0gffT4oVeMJj3eu4AqOYT9pRMUxgiHF89
	QkcRFD4MVr6elADmrzN9meKokDq+StKEJwUrH22dckjzble43WCfZeUv42/MbVRddAv/sA
	RMdLu5tKxf5O8CHs4WtwJwDqjFMJuQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778810712; a=rsa-sha256;
	cv=none;
	b=CvSZhQ92Mis1DZnl+6V5k/0cysWQoU+s068hyrzJWKxB7mKwAJVwH19TWkiLYxQhj5EOsG
	EiSVWdV8tZP3EUzs/j705IAznUnL25Ez6TgL/igJbaU9hoY5GEDJMw2TY+emF7OHA2z/br
	p8sljn+CwBwENDZ46YvSESVrFDQZbV8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KrfXcqxC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-83ec36a13e9so3128505b3a.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 19:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778810711; x=1779415511; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SBIorJYDy2JphtLdFCSFt8OFwBCOyFtM6YXCh5ThwQA=;
        b=KrfXcqxCWkRlHlm3KB88fcUAsZQlUK4q1t7IoLLB/iymldM1uiPauDNp5Ryfq8BVYJ
         DfxBLny85u3V+bl21H8Y+RiRWCBSTJ5XpoyrJ7W3HY/ZdSm8hHXniuZDECkCBDMaoI8H
         9o0zYZ44faD/RwdVPfrpI6hh3Vn0lyQRYr4XY+B4+HnudurJLDfoT4EdMYPQOq5FgLYk
         s2MrIhdO/2hQvs/VCyW1CxNUTqV//jKrSPLr4pVpozoU9KqHxQxVbDPJ7Ln6doGEE24b
         eIrWcaP0Kb+G7NTz1t4eBN3FWgeEAwoKTamEjs29XUACRA8fn0fQOHgBQQ5N/O2HaVk5
         YGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778810711; x=1779415511;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBIorJYDy2JphtLdFCSFt8OFwBCOyFtM6YXCh5ThwQA=;
        b=siTGKgG9JL3iDXM15JQT03kOvrmeR00wnn/pcQALiW2lxqSzmA+XMlys3fwQD5va+e
         PxwibXIGJe2TNzNtrcEeJQ03XSNAQCG9rwDI37aJbojIoIzErkLRbg1Q0e15gudobS2S
         aLtNrqW5wf5M1iP0j6Hinkh/D5qV/v0iOvVOdIVYYADgTMC70Xq5BVtcjyelgOrzX6oW
         1ya65/7LKtw/VefscG/ioXta0ubRJ7Gd+Ua3lyaVowvc+5wboyq73ljdHN7w+8fa+lLa
         gnYbANS/KxE8JRXctveP6NN/girV85JQ6DKIf1fMxBmt2jDTq3N7bYoi9n2lqg33QWhU
         f5iw==
X-Forwarded-Encrypted: i=1; AFNElJ+CFzj1aGDYcjLcPuxsvyaV+sOhREzkhMmNlHCXacGJw7X5rmbCjENqRPpavX5tcuq9z9pg7jxJaA==@kvack.org
X-Gm-Message-State: AOJu0YyTMJgp4YX7TPpYC4v327s/HsND8mEsLvCAMdRAcp1dWhc6Eg3/
	6WsvTRKEdn+QZPq7SccF3sQzaz2IYp5KoQj2/5HP5VSK3jrbBrXqzmtm
X-Gm-Gg: Acq92OFyMJUJzbaZ/FNjOLI/PnDFVPQ99e1oKQ+xJ3LFGsu4dyXJxJxzKNqhZgWNsxq
	DutP86qowFNnRJzKOqbRuTBkRZ2T7XHIGY/NxiGodGYJNX0BFoas33Kpp+De3H75RcnHrsvB1ZG
	OqoAhBYEKvDI3Swyq4SSL0TzdMbyPKOBIlW9akWDrr0dW0VJVIdoQI9dHfP3PivlPVsqeJyKJz6
	3Yus2LDunsp68/t5dx3ymM3TCRBmjL5p5zxamORu+Tupaxn/0QI7MiQZSLn7I3aBzG9LCGd9dne
	yPscZ3N4aY5LafHsFadR0UXYJZWfl3BriVdedw84PMHxXnQSWOBsZ+1TicZQbSH4zeyX63Kzz5p
	IIbmIRLWQy18gRjmt+hoIGDPTm+ZQgn2Ery9p2dF0eOqztkGWclKzW4CyH8OiybvSgP5ja+RAwY
	4bOnxXP8qoBusLLz8xEcvFnLskqmWuyqfLUUg0lgVUilo=
X-Received: by 2002:a05:6a00:2382:b0:82f:8332:4933 with SMTP id d2e1a72fcca58-83f33ab666amr2162641b3a.3.1778810710605;
        Thu, 14 May 2026 19:05:10 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19f61e5dsm4134946b3a.51.2026.05.14.19.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 19:05:10 -0700 (PDT)
Date: Fri, 15 May 2026 11:05:06 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: oleg@redhat.com, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	torvalds@linux-foundation.org, qsa@qualys.com, kees@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, imv4bel@gmail.com
Subject: [PATCH v2] exec: mirror set_dumpable() to thread-group siblings'
 user_dumpable
Message-ID: <agZ_Ug3EzCYn-Jkg@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: E528740003
X-Rspamd-Server: rspam04
X-Stat-Signature: uoneet33ud17unrtxmmjhsio7yj6wcz1
X-HE-Tag: 1778810711-958061
X-HE-Meta: U2FsdGVkX19LhycwRxYChCwE1GIlgcIlChrPvC09JugLrevGOaV1+oJcfk9FbE4Vj2NBD7Qs3aaLvndVLapYZKjrD33X7FQhWTlzj3ByyYIdZNVUCs44VuB4UP0oMFORtktcbsBtBr/d88iq92ePS4S6bUGZy6Q+cPfHLO/bTbtSok2tZ7cStr/IesibXdnfJYKZ1RmOajwcyZ6rY08HE0UTjMWzeyJPm3z46fpTl143orXUK3eFBDuyubZlzgXamTnZfHSYZXssEvV3FVh+lY5DLpeV/PWnacq5FSYYJM7QLuVTlI8YesRhhvzkTU8/1ylavagd5qapFGFgLgDb2CAbCaI/Ia8BWW3mQ41bno+TAvBopYMjkJWhvgB+MU6H7Y6Z1xUCLrsUhArW3i5y3+J1dg/7zDvtW3Apm97IMrZZDfgNkVgZZ1nNfpOtYwQ2ZFiJ/EmAQ2B83mMN1t/yJgXDE0ssVmH5ZiIBcvOr+EdTJXAKB49OLlTudqnDA5hAcBEuQ1OAHyX3dJdSxz3fPq7B00Vmxfav2LA+hfKIH6Fz0wYsgjRrEPsK9dJcM4l5LcKsMqAlFi3JvzhnIemAhFg4Rtg9QsAa62A2Y4QxNsOWcHqAfjmV+oH5/i/UxBOE7DODL1bWUOLB+XDwpH8YuIhwaLOdmGMDzGuR8FPzTV7JeEGxYeS0CEL/5OM/8+jmqcEmV+CVdcebSed82r78zqt7QXUqmM1jpvj6JI7HyxF6tErFM6OAtXapKIflfLtpVTRpD2OFFWChfSMk6U+EAi2LXaDrreioYIg2CaWgpaa3SRgCUgjHOyu20KWKVLfFviV42fWnyWJQ6e0TH5h8SBBncezZfsuLE2tz4ycFUmt6x1YajIhACM8IzKGmKe77bLnfcrr/31mFg/Ap3dzg98OvbMQpv2c8SEqQPMAmISIkcZR4KsEuwA4OJNElfw4tB0WGAb6a5XTdD5LFS3V
 3mgy/Tzh
 zYo+XcOyOl2yMQa7/u1RYHjxYFBaWlwBpqb5Ke7ZLwpzBI8kkjiFA5NFsWe3iiuD1NWNzljXBl+6sPtp+YjwiLPGApJ6nWkFel+3qDRL9aA12zDqT0jCPuDIjCupVCuCHDAN80hWFkyWO4LUF1CNGlGE5LrT69LLGS67BGEdWnfzeONTmjZdDrv11DnuUoWQN8xDfkg9NmWFHhrif/8jXtYQSlaIKigIC4Xx01aFjf55IDkDev5kRHKtSBWBgpI9RAl+ceYVcR23Y1NnbQ5tkkcW/UKIr77UALdJWS9ZajtUk6SuAPbQ+MoRKkAsxO1sWi3bQSCydmucdNTtBgLlDwmi8/deQ+9MQdLP0o+HVBG8vv+DCehBfEJO6A3KEMxsLiJcpX2gg44GpeNQscrnxrqEDv1tqux/MnS8FMVSB6PoRVLwBmeyzT9qMhcNuTG/vVnS8V/6eG5iG0Cyh5UDbVwWjkbm99CUTmePMX9PWwqiIronzYaJ5BouL2E0uOnOPTx8D0CoEihVASps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

task_still_dumpable() reads task->user_dumpable when task->mm is NULL.
That cache is written exactly once in exit_mm(): a single
get_dumpable(mm) load taken just before task->mm is cleared.

The load is not ordered against set_dumpable() writes performed by
CLONE_VM siblings, either via commit_creds() (an euid/egid/fsuid/fsgid
change or a capability gain - !cred_cap_issubset(old, new)) or via
prctl(PR_SET_DUMPABLE). If a sibling stores SUID_DUMP_DISABLE after
the exiting thread observed SUID_DUMP_USER, the live shared mm and the
cached value diverge with no later refresh, so task_still_dumpable()
keeps returning SUID_DUMP_USER for the exiting task.

In set_dumpable(), after the atomic update to mm->flags, walk every
thread in current's thread group under rcu_read_lock() and mirror the
new SUID_DUMP_USER bit into each task's user_dumpable cache. All
in-tree callers of set_dumpable() pass current->mm (commit_creds(),
prctl(PR_SET_DUMPABLE), begin_new_exec()), so for_each_thread(current)
covers exactly the CLONE_VM thread group whose mm was just updated.

The mirror takes task_lock(t) around each per-task write to serialize
with exit_mm()'s own user_dumpable RMW: the bit-field shares a word
with neighbor fields, and without serialization a race-window expansion
between the mirror's store and exit_mm()'s store on the same word can
lose the mirror's update.

This keeps the cache in sync with the latest set_dumpable() result
even after every thread in the group has passed exit_mm().

Fixes: 31e62c2ebbfd ("ptrace: slightly saner 'get_dumpable()' logic")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
Changes in v2:
- Move the update from a read-side sibling walk in task_still_dumpable()
  to a write-side mirror in set_dumpable(); v1 left the cache stale
  when no live sibling mm remained.
- v1: https://lore.kernel.org/all/agZjJdaIGCvf0z_1@v4bel/
---
 fs/exec.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index ba12b4c466f6..9732b38b727f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1910,10 +1910,26 @@ EXPORT_SYMBOL(set_binfmt);
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
+	struct task_struct *t;
+	bool user;
+
 	if (WARN_ON((unsigned)value > SUID_DUMP_ROOT))
 		return;
 
 	__mm_flags_set_mask_dumpable(mm, value);
+
+	/*
+	 * Mirror to every sibling's user_dumpable cache, serialized with
+	 * exit_mm()'s write via task_lock(t) to avoid bit-field RMW races.
+	 */
+	user = (value == SUID_DUMP_USER);
+	rcu_read_lock();
+	for_each_thread(current, t) {
+		task_lock(t);
+		t->user_dumpable = user;
+		task_unlock(t);
+	}
+	rcu_read_unlock();
 }
 
 static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
-- 
2.43.0


