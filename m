Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CECCA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E44A6B0095; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168D86B0092; Sat, 10 Oct 2026 06:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030306B0098; Sat, 10 Oct 2026 06:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C915E6B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:21:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 532C1160843
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:24 +0000 (UTC)
X-FDA: 85306324488.23.4624AF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51E191C000A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:21:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HefMOBe/";
	spf=pass (imf18.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791627682;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ff0jMo2LbAkmsbsZNYHG+SZtpqWl/5RVX6s9+72qRS0=;
	b=D7suoQpNgYSU/GNTlDTq4T1L7eRXNdGuazEKLKhnJwC0OXKcFIG6bjTFoNQQtcgEaMkVkc
	1Knya65CClRaM/B7hxDpyreYN74YXx8ZBrmyO9yprY9iWj42wi4wf91gYYUv76JHNVaxMA
	L9pnrGSUUDOWBUHpY9buN/vF0tjRRuI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HefMOBe/";
	spf=pass (imf18.hostedemail.com: domain of devnull+me.black-desk.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+me.black-desk.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791627682;
	b=Pnf/SZKx+K5JR75y7BY1XHkEC+LVjFT4A2ZWoX+ZKYaYwfF1cX/j6lVXi2t4ZjSiCffNHH
	lVBf/CyAed4WExM2spmUpFjN5xvru3gDum/Z8VVA3aQx8GW1pv3E8F76PcYP/Z3TfhcK/M
	fIefvSVh2l4T1TzbCTBKf+x3+kR0YyA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F4014479C;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 562F4C2BCB9;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791627681;
	bh=FuZv+/q1fgHer56ZAWw1d0q3ANk/3SFdNvfTLly1e90=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HefMOBe/BnQHO4U5Vnp7s6RmAEVZybkSoKxIpcZsesK+eUqBGd7g7xxvTxpzVpCUB
	 UiLYg5e5m5UbhAP3pifazgFgaeSwpgwtIRYghs8Xi4OAw7SVFoQ4j4kjGsF4xUhlDk
	 4P2dU4gTGoqCl/N4jQfchne6eTwk2A/Int5SdtedGQsfK935sYYeeLl3ZBrr5AXcSc
	 xbON/5uUDq2ac+hACEtyZXc6hHikwMxeQzuximNoX114Hcnjl6/9leH25ARXdNPAaD
	 NdEXX3QXXpYHs33RRQjaJ0DOyPj10xG9mtrlca8VMQT6cJ66fxCwZ7uzPTo7zwmw6X
	 45oBS9RUb59iQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3053ECA6017;
	Sat, 10 Oct 2026 10:21:21 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Sat, 10 Oct 2026 18:20:50 +0800
Subject: [PATCH v3 1/4] pidfd: restrict task access ioctls to the caller's
 pid namespace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261010-pidfd-get-paths-v3-1-f245440b2b30@black-desk.cn>
References: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
In-Reply-To: <20261010-pidfd-get-paths-v3-0-f245440b2b30@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2240; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=ZFhe6igvJd4uMFSrgyXSrlw/Pf3UD8vwdWrIzJThCwk=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqyhGbwdr4RORhdN9GzarNd1upM7l3SBuv2j7+5
 M5Vfu1jfYqJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCasoRmwAKCRB2HuYUOZmu
 i1ZjEADeM+TRIHmXm1K3ljsbCmJXeQECqXkRs4A1DVU3R0hrJUwIoq97CU2fSSgcJ2rl+MtEbDW
 6nX3DGAmt4fIa1MEdyoH0Bd0Z3HPIunFVu7oBNvfCdRFUPoXpJdoLLR6N2qkFTmbol406QnWGD9
 ccDtowKgDXT64e0LGg5A97UYH2tGqHpWroGsgHrg4dIPsoSDydzf9qk9M2yElfq/kCjc0X2XP7p
 rTODO1CgcXD6tdpvBhlE5xfAkxJglbbhyuB39rwv12DVL6yXuR+xxA7u3MX3XwcXim6fBCQBfQA
 BrIu0XBOAUXLvV7V/IW/5g+tbOH/zKkjlWS1CzHi3fs17Uv+GfuGbJ67YC0LzKyhpki1xsh/8IU
 lszpVys3+rnT+b3zw6FuhZhvOgqFibKezDeyieH7R8dYY+07aHp28h7RRIemZnkkQdrRG/MUBcc
 To+qPae2CpHDfzZp2QirkTGXLNIEEV6x5f6HoQlm9Elmgyc7WaGQ0fga8q4TOwVvzMTeCCmRTt4
 od7L8erLn6CwtoKvYXbLeRujmoIFFM2k1kJxeR9CubO51sJH8q4mrRJWwcMo7Tw27yMrT+Ptd9w
 F3UR/Rk1JPvbHy2Oz15U59VFqXgkuDcVyOMXgXypZKtE+ZCth1jX8UHEViu4wW5AWQVw0JV3G1C
 +hOE64bf3nsV8og==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 51E191C000A
X-Rspam-User: 
X-Stat-Signature: cupgrjqjncuarqixqgqbpp3jia3fwgnn
X-HE-Tag: 1791627682-744637
X-HE-Meta: U2FsdGVkX19c4zZCcdvBUfgBE6lNCqLV2EslMRlVMmcJlIJbWOC/i/K0ICk9EBUOeDABZTTsYlR4j/F8JNLDQ6+1qmvXGwy4Xr+N48FViXfIuxjrOGvOT5n05wO+4gpT4HyEBxFJMiypSP6tpBAgnMrbLHIUNJrpyzaggD08pXHRLm59U3TrRMDI/Kx2DQec7Oh51UkNdyWS4+f8jGxJZylTtuitqctcSKCd4DmUXQXY3gd7C7nM4EIiBI1xDT7fQZS0DNnI3JtPPxRitgit+lUzCI+xMM3AwvFaKZKhXCBreV4kQd1YGf+rPFU1ewN7QLKyZffmkQvs44j4/4j6EZjzApPrEgQajW3wlUsukB8N6LJ7z3D44JRHePUJL9l4PVvudOu44p9zrJTTbjtS9Ce8/GgqjTDaZ82dUwT01vJYBr4FuA4EsVhmzaaG/IdHyTU5je6E1aYtyvtXXYs0ZHCjobIudtRmJy0+Aqmj97UmzEyqC4KJPgd4XIQuykPPH3PTBisHDwVajDGbSVYVo3xbw5SEYHXAKoltBRS9voOD+fqBiEcFf4LuVN5GxNT6ulHamEAdebFaH5kxuCnLBIYOGgS0fOYQl9ghUiMntEIxC+Egs6EpZdFhpvnzbxeDRB84lnEJ1w8biKTWdj3mRcFFo4KE23dmZVduV74ZCRWun1dS8wWxrpyBBbqTCubOsSoWRMZlgeQ6nWp/5PMQoTllmod5+1MCQ5n5IvpIwLG35bJuh4KpyNK/SvGiywKyTwEvtF2moJe1tOj2meMyorUstIdP1VMhcrOi85+cP94K7me7qmA/fy1bZFIOwORryHvg/63jtChLNZg8ATMcZ0L3tw0pCj3O0wFOeD82IdWuv/SQAcd4yo4hku/JNUAsYE2ZuMpI0Wt4t7SOeN947X7TFmCGeqErlNwR2Xi3VtrHHfKFxuJ6FN+QNPqva9dIymmNym7QpIUqzJNw612
 O4FJp5Os
 3gSTVtlI/bDQFAXBFU0ucoIJNvYeugU/pxOUJJP+7QG1K31SFHXRHc45toTpHeqYwEthqSopS/tvF/yHrisVUAfkSYhhEd1317efe9MLvbyCCXZtC9fwLt4IU9wvOIlpiuOB1PKFP6SWuPw2/KcMuLI/NxC5KC7q1SKAVRda9NSk6dwrNaC5y9WTW25zrlkI/Fe2kHfM79N05peHvGeNZX9qOjwb3x14bEXteIbH+py+TsCgNkgMGQg3e7evQqZmRh+fOqaue8pDB1n9P/G6fX/1cWar5AIzXL2t7A3IwxyMOR/wpb4/usLzvQ9Wqmjq0lh0WrkU0sT0mlglLR/YM/jRt4H3e2b7jiECWvD43b6JI2Mgw6X7eq9uJHkkaj6D3sAeU5AhdwxXKcV+C7AMHcQN79Hr8yTkc02jg36AStd1dBXPDLUzX7Taz/k06iK+gY9fH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Linxuan <me@black-desk.cn>

pidfds can cross pid namespace boundaries: a task may obtain one for a
process outside of its own pid namespace hierarchy through SO_PASSPIDFD
or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor inheritance.

The namespace ioctls gate access with a ptrace check against the
target's credentials only. That check does not account for the pid
namespace relationship between the caller and the target, so a task
inside a pid namespace can use a pidfd obtained across that boundary to
acquire namespace file descriptors of a task outside of its hierarchy.

procfs exposes the equivalent information only for tasks visible in the
reader's pid namespace, and PIDFD_GET_INFO already answers with -EREMOTE
for targets outside the caller's hierarchy. Extend that policy to the
namespace ioctls: fail with -EREMOTE unless the target is visible in the
caller's active pid namespace. Callers in ancestor pid namespaces are
unaffected.

Unlike PIDFD_GET_INFO, the visibility check is performed after the task
lookup here, so reaped targets outside of the caller's pid namespace
hierarchy answer -ESRCH instead of -EREMOTE.

Link: https://lore.kernel.org/all/CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com
Link: https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: Christian Brauner <brauner@kernel.org>
Assisted-by: LLM
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index a6a643f15d08..791f7efceabe 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -556,6 +556,14 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (arg)
 		return -EINVAL;
 
+	/*
+	 * Require the target to be visible in the caller's pid namespace
+	 * for operations that grant access to its resources, mirroring
+	 * procfs and PIDFD_GET_INFO.
+	 */
+	if (!pid_in_current_pidns(pidfd_pid(file)))
+		return -EREMOTE;
+
 	/*
 	 * We're trying to open a file descriptor to the namespace so perform a
 	 * filesystem cred ptrace check. Hold @task's exec_update_lock for the

-- 
2.55.0



