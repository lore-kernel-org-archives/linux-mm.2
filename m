Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E704CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2808E0001; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C15B8E000B; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FDC48E0001; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56E716B0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15CA31A058F
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:27:41 +0000 (UTC)
X-FDA: 83847411522.03.8CCA572
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E640180013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:27:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf06.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FR2rnc2zMxw4e3WvwUCK7GPVBZkRZuDeutATCY2zyaM=;
	b=B6RHTwdKg/OD61sCwFoCQgRsTzwgwaOG6Ljr5amUirLpsuBC/jrNrq5P/LtEcS0vdVIz//
	7rifvi/AfR62Ate9nQPK8ddhAF8CvqYB9MqL+alk4KhiWK2I9tEcGU21x4FGp/F5d4whb0
	iZ7eLmpzk1uJu9zitmcMybDnr4KBjbU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891659; a=rsa-sha256;
	cv=none;
	b=GomHOqZ+E4z9ALOi8aqDCrekRstnj+3PpRmhJE8ccT25u3itAHxgp2LKWNej5NZVupApiV
	zjzLqMnxHGmmfbALhUqNgVegXcR66GsEZtOHif0oCF86NOgsHJfRODYiGo9Y3qaXN6cOnw
	Bwb/Imp7r1VjzLTshdAAW2AV6pO3Vuk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf06.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cGy1X44FPzYlBd5;
	Wed,  3 Sep 2025 17:27:12 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 17:27:33 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 17:27:33 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>, <surenb@google.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v7 1/2] mm/oom_kill: Thaw victim on a per-process basis instead of per-thread
Date: Wed, 3 Sep 2025 17:27:28 +0800
Message-ID: <20250903092729.10611-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250903092729.10611-1-zhongjinji@honor.com>
References: <20250903092729.10611-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E640180013
X-Stat-Signature: 6hxraibjdtgkf3yc8ch913hqxzpxsr1k
X-Rspam-User: 
X-HE-Tag: 1756891658-466653
X-HE-Meta: U2FsdGVkX19BX/gwr59fgyTGzU0++LJ+PtUTPXrDMtHJWgWVtmyOODoNfFUzVI7hZe9gYPB679JvbGhRVKD6FvZpcqo77DgTe7gGrI+eHne4Hv2UVSStqk9zz8zLmajtYi8TkojzZtG2gfxjf4/dXfAD0Y+00rwEccgkdDgYO91L3pBaUBQCfU0HziPiPxZROjstlbrmVmn1SF/4eDkNf8pFr76QQS6zBdtm7xzqGRdyyLjNnDfx0LOiWsCe+wZJVqCt9u2eEXktYy9Tj5QlZvrwg3pIbob0ppwaJpLX0qqKs/SHAk5YIPREoQ/a0SFdKSfUPuZg/FMt2d66CTwKrpf55BiVcsFAfUYzd5vDGpOrR4DAMPYV3CymcOJWWEmUoMrFezeYJcMKZP5NVmBqQIkOnNbVs+clL4CMGdgyIMVslNVdnFJC3wLos9rD0b9Bn4kw7DKWaN29ZTcXvYXbhYn+aaEvLEWn5VjcXScZfJUQANI3uG3tYSeuT5/KvTRSdJCWsE9n+0FBC/XpLdtU8lXRPmCxzPEDUXaDU8A63xrq9RXCP2NDG5B0ye1py+p+shKRQ1z5pEya04moSVTUGEXhDbgDo390mP2QqgB4GgB9m7j76X5MDVkRruYR1JCf3+mqArkmN7dInZev2T7EhB3jjVD6iWkS5q7lCeGiFje1vOhXF1Pm4vxEpMUbelfnyRbG3ge2YdU3f29J/OTtOvD/+kZfLv3et1+1Rit0+suEDh6I3eoWbtYCOrVMAmh/Pi0Mhnt+WZf4OMQGMR5Cx5MKA3oDir49pWcoHLLyAJ/RGZTKiH0OhC/ezuC5iuwUetcoZVr16pLx0/ubKhPu8bEdvsTCAI3F0iwBxTi7/sOjSKfBhAUUVKiOHVzpVMpUtisTwi0dW++S1HgADvAsGRdwvPsTzwRig1QFNBek8XzLR+Cd0388KKIMbSSqJEFfLaoLQwsfTnNC76F55fa
 +TrDUqv8
 BtC6nZmTrhP0GK4PDFhJVfWO+fPI86mmn45UV8gKmAabAF/yiu7rnQbgN8tdXL1VEz/Q88z5zPbnUgBMDMsg5U1SryhacFWfSpnLNKkM1qANiyp0dIgIrHi1pXvbnN8ZAXBe4RM6BQmIPkk6etHwWriTDX4L0Dbig5KREqmLNZ2GOPGtXl4187HwqPW/eerNx9L/E2ISztQVL+ym+svnX49afPodhNHP5pQs2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OOM killer is a mechanism that selects and kills processes when the system
runs out of memory to reclaim resources and keep the system stable.
However, the oom victim cannot terminate on its own when it is frozen,
because __thaw_task() only thaws one thread of the victim, while
the other threads remain in the frozen state.

This change will thaw the entire victim process when OOM occurs,
ensuring that the oom victim can terminate on its own.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..3caaafc896d4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -747,6 +747,19 @@ static inline void queue_oom_reaper(struct task_struct *tsk)
 }
 #endif /* CONFIG_MMU */
 
+static void thaw_oom_process(struct task_struct *tsk)
+{
+	struct task_struct *t;
+
+	/* protects against  __exit_signal() */
+	read_lock(&tasklist_lock);
+	for_each_thread(tsk, t) {
+		set_tsk_thread_flag(t, TIF_MEMDIE);
+		__thaw_task(t);
+	}
+	read_unlock(&tasklist_lock);
+}
+
 /**
  * mark_oom_victim - mark the given task as OOM victim
  * @tsk: task to mark
@@ -772,12 +785,12 @@ static void mark_oom_victim(struct task_struct *tsk)
 		mmgrab(tsk->signal->oom_mm);
 
 	/*
-	 * Make sure that the task is woken up from uninterruptible sleep
+	 * Make sure that the process is woken up from uninterruptible sleep
 	 * if it is frozen because OOM killer wouldn't be able to free
 	 * any memory and livelock. freezing_slow_path will tell the freezer
-	 * that TIF_MEMDIE tasks should be ignored.
+	 * that TIF_MEMDIE threads should be ignored.
 	 */
-	__thaw_task(tsk);
+	thaw_oom_process(tsk);
 	atomic_inc(&oom_victims);
 	cred = get_task_cred(tsk);
 	trace_mark_victim(tsk, cred->uid.val);
-- 
2.17.1


