Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DD4F531DD
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2F36B0095; Mon, 13 Apr 2026 18:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6BF66B0096; Mon, 13 Apr 2026 18:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85FA16B0098; Mon, 13 Apr 2026 18:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70FA16B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:40:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A3C4B7862
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:40:05 +0000 (UTC)
X-FDA: 84655001970.06.99D1B14
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 124721C0010
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:40:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pyS0Z/qn";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf21.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776120003; a=rsa-sha256;
	cv=none;
	b=0fv/rrO2msd5ar2w40YDLLRMfiDZ+H+FMrfJwMmzBOjRgm3Vv3CHZbyDqUVTmJ0OwpbH/s
	yScoWM8Eaw9isDzVVO2jb7FOiagwyf+OQIjp5VN6nN9IGTbH/Ff3W3eh3jlJ6nGkpt+Zmp
	qm06h11M6Buc20WyGuWy2p7W/AGXyA0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pyS0Z/qn";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine);
	spf=pass (imf21.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776120003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cc8QYlKcFUttGHudhBfwFdQ1KDV1t/Eqeu+TLpIwudk=;
	b=4WbfCGsPPNKLtczny0TL64/SyrI3F/dhfu6ny4B8lSsWQZ5aUNKgMghHcsgERK3N2Cm6bn
	PUlyzV3cNaMfy42GrBobWFgvCh4rOo3eK93j8ZF5HH+4g+do8FZYrtjjRttOb/wFwm2u8a
	PwVWrCyeGAeDUBrRyreRTp6OKd4uhFY=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2dbb4ad19a5so558449eec.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776120002; x=1776724802; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cc8QYlKcFUttGHudhBfwFdQ1KDV1t/Eqeu+TLpIwudk=;
        b=pyS0Z/qnlFUGlxGO2mfoKCYHKnd9vkps+1CVk5o/3Eef+a8n2urq3MizFYm0HRMlJT
         NVarftiNDgE5gcWZSGWd933yZhS1qTyPiEY6jHoK98Dbvs0TQWhr7ADZA1gKPN2CUh5M
         tAWgzJZppbnnBOvY3eW9qRHTjsSVsiFTQPDDD4PNXD5OE5+bZCcnyiuzuX9Jlo7NF3WW
         mugsY2KfqwrR7xd4cG2xEZnMomUubksCCbymhDAxGwx+EOtdRykeB7PjK+BaWZF4jGW7
         20wl24pGbekCDrF45Dq4Fk2NcxrmcfovZezbufF+6fF3pOvM8TyX0BIqnrkdJmHAPQ5+
         HIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776120002; x=1776724802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cc8QYlKcFUttGHudhBfwFdQ1KDV1t/Eqeu+TLpIwudk=;
        b=oov92UpxCJPM+VtGNB3/lfDyWud+UPV7iqQa0K9XVx7f4Khm4XP0rRiiHWQsQlqzS8
         kZ0I5ZS1hAgapWYGdURQxJjqabMngLyYKOzq0Y7luvaUr2O79K4VQP5onnntBuVDsm2I
         MyzM2k/oLRwJ6EIIDj8XiP7lKHFDcoNaW6E6JkUgYAtVdO3OdOY6oBGad4l2SFg6lnxB
         mp7Wkhco055bk4fQnp2BrfJm1lbfemFb8kc2AO58aqGcct/vI1nxWCPIb/9uL5sb7FTI
         XwvrB/ceGgLC3DqV4O7cbb80x8ec2pq4y8AyQ/EaYXt3mALYYDPXKc+dKTSxHMXOIB7z
         s7BA==
X-Forwarded-Encrypted: i=1; AFNElJ8usxmFI85AN1lOlKUXH2T/HLxHXd2OU5Poodsymc3pLV/wILO2DGc1YB1OpMSoPjm/hFRk66FKKQ==@kvack.org
X-Gm-Message-State: AOJu0Yxr0q7JHZ5795ioOYnK6hlZwOivANzdtgE0kI/T5WRfoXw13s57
	EH4zfx6x8O+7tTGKeORGTqhsRO1M8II+pNwfvcCG3vEeaOm/CcKnrdqE
X-Gm-Gg: AeBDietHPyTq5zW4YDGBXu+BVY8779IpFFUm84wKUfU+m+YaJjjuNUSUYssa+gbV5LO
	6gP5X6qfH58HEhFmGLTymuZsjZWOQiTZXe8/pnG00XDjM6ULInCUTBZ1cAPnwpnGHJKuICJXTM9
	8T2TY+6pbC1VNg2Gn4SojIYbzl1m2eAwo19mUaviSGBEwJHCZKSxJgCtJMkTgT+LqtyOmdJLoJh
	6j078tQN9zd2WnR1H7Bm37pNI+wLGbek0Fc1JQviJno7JJi8NVwnMA7DLUDsgMXN62bMEpyccON
	zhHL1LI8UlAvA1peRe/zJ9ge5i/orlVsdZDoUHxYRHlaK0dLs2u8JO35nYO1mBqQXNK6KKBOzuo
	le8ZD/z3pgsBSjGznHeHTH0lCRDObZl31MBR1Ueff7CiH1j7KgaM7h37tuXdzNFnW7Pmr616Cng
	JblSWBjPq8GTQ4MDQ4nVVQR/92yn7HcdX1L4dYBRMwUNNxrnuyjMuB6TZE5SB3glRzKqI6+6Fep
	+85
X-Received: by 2002:a05:7300:6d03:b0:2c0:d1ad:cd2e with SMTP id 5a478bee46e88-2d587d82e7emr8217072eec.11.1776120001746;
        Mon, 13 Apr 2026 15:40:01 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:c871:4088:5cd5:bd1b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561cd3138sm18577297eec.14.2026.04.13.15.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 15:40:00 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@kernel.org>
Subject: [RFC 3/3] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
Date: Mon, 13 Apr 2026 15:39:48 -0700
Message-ID: <20260413223948.556351-4-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
In-Reply-To: <20260413223948.556351-1-minchan@kernel.org>
References: <20260413223948.556351-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 124721C0010
X-Stat-Signature: jzbst5wktcy7e1grqjm4mkrbknc6n9xa
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspam: Yes
X-HE-Tag: 1776120002-903403
X-HE-Meta: U2FsdGVkX1+pOE827WjZiIXho6QYZGeQF+r9BLcJRCg7G3Jroa55Ptq6TY8IE75SWXWNODjE5OWUM2t9HzGmPFbl1u2Uh/9hjUXTtp6nuYZwKf2fjJUj9X/taCyLXfqsD7ddH9bg6YqyL6cc0e3QRvsVIw5Ij5eZNHur/LYR1Z/ynEub/SBbsZQTYJIyPQ1htpZVDUkB4UjhlIMpuUUy/A/T0JI5JrejE2DDOZFd0G5KScvFQ5KmI+mzQ1Ws9qwoyU/qxtuQgr6W3RW1catINt/qI9H+Ig4TA1hi4SgaJXdCEq/SQimooBC9b7ewuMP28IPMZoimDdwsUI/k7z2IeeZ5sbs1xsJYCKRuEasATKkSAIgV77eJfsS4DSuWLieNYHvYmtukoNRtCOLhV/K1Zsr6Xww6SuO/OJ+6uAj/GG3OBDxcFa+/5EIdbLk+t2cELNtGIne1ZqpmNMkq/+fnmMBzXs8Zq6ORrrYBxzkTmiJo9A+Hu+kiwqca3tlmFlcMiIh70YEoW5BHNiNBoLLstj7t0CBPd/dr2/dcDGVtleOcMaqLzHLNWR9j7Dwf+zO4vU0f1j46e0LWZL3PEE4M5imPHs6q2l69ZT7funoVhH63a9cR+hd17Vw8ExlhQ58DKoYIYjcBG3s4mqqzPEbiSNA3g+OU/ri04F+sr6uKwghcWn7dhZJlpYtPzVQTvA1kWY0VEUjaFerCE3cYXbSDBcH+yrbzG7loMzsmtzCUp+dnWGICqnrkfRXD5vaICJ/LixPoDXDUZ6NI8rzm43Ba7naVOhusAa7zf5PANVTrOc+bTjlxr7Rs5W+v3QE13QW8A64jhjr0UeT48KCHLdgTqa+DEHsMT5H+GJC1QsGObQp1Syr5PtIpZfcYu3zEHutkUmtSwfyepe8ki/JfKNg48AKhEjFWtx1K9K1hQWzpH7+INA0fw7ljIiPaYWj9ofducHkLYShkqnuDB/Swjw+
 gtd/6t4n
 Fibid6HsXcyA+d2UJ3ejFvhQ6GgYDCIyuV4d7ZjdcyuyIgLPTBoP71BW7Qg9aZnIeklq/IVyVH6gnhvZ1E8YTK8oAVn/XTAuyq20eb3iFdsRBaMZiJNfLH6G2H6998VNVWGc7oDcmV0PYSIUyO77dwF3frsviYRxju3bhq95MinCX5LELv+LUHN0GkKHi0tlAIbL9B3QkafGRqTekK3h868nckvqZdhcnNU/8ejSsLP3GKz+R1mX5xjiBcMGd9uBT6tgVb6Thjt6eTL5wZpmtIR8s+yAiwp5OkD0RPmj7nPv3Cul7DTAQNrKmFqefH6qoc3zsIld8wTjvjdHkaePREePGtziSeiwAiZCmtvAnBXysl5yv2qIyJg0777Ynl/+/xWjtlE+5Va1LvaZpBj3Mx9sMQLe8AavURCw9paW3J/VTZFPD6XOpWxe/yneZOtubuaxST7/kxhaL++Db1QeWsD9z4aWxjf0w4HRSOiTpPCvTFiorE2IAlxmiP8P4coKe//+FPgPbYIlJCU6ZgJiiAzv9UPp2PUaXO6b++BTl2O/a5uyuX2+YuxfvU0EhXNcgW9FV7WKCqP8IQ23TDwKDCvgJDFxkmZBhqIV+jo/ME/MxmjNJ+xP9rf0EEQ0AvMsmEATsuw/j/m1/rfTw8T8V8P0hm1YX9Ja3u3DedXegt+5BrjO14cwzHSXNC38asK+esmTUQKv8DhG3fWTNnvU24fZMviynwPpCqlXu7xLivWIAk7yFlmexUVOFqohXHGVsOt54
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, process_mrelease() requires userspace to send a SIGKILL signal
prior to invocation. This separation introduces a race window where the
victim task may receive the signal and enter the exit path before the
reaper can invoke process_mrelease().

In this case, the victim task frees its memory via the standard, unoptimized
exit path, bypassing the expedited clean file folio reclamation optimization
introduced in the previous patch (which relies on the MMF_UNSTABLE flag).

This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
an integrated auto-kill mode. When specified, process_mrelease() directly
injects a SIGKILL into the target task.

Crucially, this patch utilizes a dedicated signal code (KILL_MRELEASE)
during signal injection, belonging to a new SIGKILL si_codes section.
This special code ensures that the kernel's signal delivery path reliably
intercepts the request and marks the target address space as unstable
(MMF_UNSTABLE). This mechanism guarantees that the MMF_UNSTABLE flag is set
before either the victim task or the reaper proceeds, ensuring that the
expedited reclamation optimization is utilized regardless of scheduling
order.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/uapi/asm-generic/siginfo.h |  6 ++++++
 include/uapi/linux/mman.h          |  4 ++++
 kernel/signal.c                    |  4 ++++
 mm/oom_kill.c                      | 20 +++++++++++++++++++-
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 5a1ca43b5fc6..0f59b791dab4 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -252,6 +252,12 @@ typedef struct siginfo {
 #define BUS_MCEERR_AO	5
 #define NSIGBUS		5
 
+/*
+ * SIGKILL si_codes
+ */
+#define KILL_MRELEASE	1	/* sent by process_mrelease */
+#define NSIGKILL	1
+
 /*
  * SIGTRAP si_codes
  */
diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
index e89d00528f2f..4266976b45ad 100644
--- a/include/uapi/linux/mman.h
+++ b/include/uapi/linux/mman.h
@@ -56,4 +56,8 @@ struct cachestat {
 	__u64 nr_recently_evicted;
 };
 
+/* Flags for process_mrelease */
+#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
+#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
+
 #endif /* _UAPI_LINUX_MMAN_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index d65d0fe24bfb..c21b2176dc5e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1134,6 +1134,10 @@ static int __send_signal_locked(int sig, struct kernel_siginfo *info,
 
 out_set:
 	signalfd_notify(t, sig);
+
+	if (sig == SIGKILL && !is_si_special(info) &&
+	    info->si_code == KILL_MRELEASE && t->mm)
+		mm_flags_set(MMF_UNSTABLE, t->mm);
 	sigaddset(&pending->signal, sig);
 
 	/* Let multiprocess signals appear after on-going forks */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..0b5da5208707 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -20,6 +20,8 @@
 
 #include <linux/oom.h>
 #include <linux/mm.h>
+#include <uapi/linux/mman.h>
+#include <linux/capability.h>
 #include <linux/err.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
@@ -1218,13 +1220,29 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	bool reap = false;
 	long ret = 0;
 
-	if (flags)
+	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
 		return -EINVAL;
 
 	task = pidfd_get_task(pidfd, &f_flags);
 	if (IS_ERR(task))
 		return PTR_ERR(task);
 
+	if (flags & PROCESS_MRELEASE_REAP_KILL) {
+		struct kernel_siginfo info;
+
+		if (!capable(CAP_KILL)) {
+			ret = -EPERM;
+			goto put_task;
+		}
+		clear_siginfo(&info);
+		info.si_signo = SIGKILL;
+		info.si_code = KILL_MRELEASE;
+		info.si_pid = task_tgid_vnr(current);
+		info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
+
+		do_send_sig_info(SIGKILL, &info, task, PIDTYPE_TGID);
+	}
+
 	/*
 	 * Make sure to choose a thread which still has a reference to mm
 	 * during the group exit
-- 
2.54.0.rc0.605.g598a273b03-goog


