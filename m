Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C154CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD646B00AD; Wed, 13 May 2026 13:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DB06B00AF; Wed, 13 May 2026 13:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB2D6B00B0; Wed, 13 May 2026 13:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49CE86B00AD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:27:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE1DC1C031C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:27:15 +0000 (UTC)
X-FDA: 84763077630.26.B1703C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 05DA7160008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:27:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eQE06z6g;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778693234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92buYD1E5Q4TMW/Yz7+DvJ29GQWLz0oZMOFEO4z2Mco=;
	b=MyQ/K8TyFsBJMrjWqfNt4+v4/tKC0g1ntgUEH7O51vsGfKe4v7evgz/rIF40PFll52+FK2
	m73M1jl4MhLoEdso+zUUfl2sioJAtJbtSmCnCbRU7AcduZ9YjZwW2JrGKdh5T/VXCGEPdp
	R3tB7m5u++HQZUpCICpHo7q1djRCAw8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eQE06z6g;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778693234; a=rsa-sha256;
	cv=none;
	b=rm/ZHJV3PdK2Q0q7W8DNyQtf6H3KxWOhcnt6JLeomQf48CRv329hU9M/iC4hCuDkiX+A4Z
	6tVFfFW8HrjG78kU9gDRAlENy5K+Ub3aOX6Rj/kdPg4R1MGu9bKykDiczn8iicw2PGD7C6
	kEURWAcybB3TM0gBXTxZyAhLUNI9YH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA209418C5;
	Wed, 13 May 2026 17:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7413DC2BCB7;
	Wed, 13 May 2026 17:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778693232;
	bh=xbNqFRfEPLDvfnXWBGOb0+DeiVRfeyxliAUWgIwEAjg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eQE06z6gjM3bpDzZDm5424CoAuAbjQ4g/r3MVc8E6oBphcGLkKpJkYplWwSeixdEv
	 YAIVBz8nUCiLXEJu0wNFZATFBujKfKZUtt/AJSL6eZZcG08a5uEpQvxWUaWmzesVhJ
	 dbdVPUleVowZaPXXcNEHPb+ZvoKfzKVQfcgHLG60=
Date: Wed, 13 May 2026 10:27:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Minchan Kim <minchan@kernel.org>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new 301/315] mm/oom_kill.c:922:12: warning:
 'kill_all_shared_mm' defined but not used
Message-Id: <20260513102711.323fed51b7dbb1dfe6217b44@linux-foundation.org>
In-Reply-To: <202605131940.kEzvUaiR-lkp@intel.com>
References: <202605131940.kEzvUaiR-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 05DA7160008
X-Rspamd-Server: rspam06
X-Stat-Signature: 3hobf41h69b617z3tkfhfteg1qu55p56
X-HE-Tag: 1778693233-636302
X-HE-Meta: U2FsdGVkX1+hpJvGvS3QouHS2kCqfPBxgULXQ3GXpz8OoDkP+dGM+rDiyh8DR+BDfunngjULOFgj5y1SX7Vqjfrk+E/IzaoDlA67wpsFdN5sNxKW+TF4/diI/kedgLsaW6BvQ9gYEAAu3o1ZCysiM4G6FZt0ort0CVlHK7IkilMrAyO6dVL7VUFv2w/wA+cwSIPemb9zFUAQXSo7p93Zm++Lg/tP0LYGrO1ZInhGKkSZw0GlUOdAmk1rgfueXsdEEgGvsQSsOEvBaoVcL+OCUL7B2XOEVm47SgVJIng7Xqs6IDb5Wk/TXPj5I7Yd5I+qFkwlMixuTqk8XB77oMHyCX9jaAVCz85siAvgfI2qTS+ErJZvlYyCuXuWDzxBZgOS/zmUP4Bhoi570nmiKqZdhlWgswvO+lL9ezpe615hOK/jviGl0eWi/S/LHbC0Mo7N6SQbRWSjqfN2dDQJn4DRPAi/YqaGoHeMyEuts1KH8hcqhliE2GH7hkhGUnuKwa3Kto/pSE2Gr/RqKqA1XlJLeGmrcRNEe/ur9SQuPRUkFjGtl59bYL4sCmnHyFhMpJp30M8h+83sOJZHGJUG4pdhIjznw5Oq1lX6e2Lyl+v+FvDu25GZIPKnof+yhoak8tv7BFb+Ck8QvDcbXgNb38ciQ63DFZ26oAxGTzQM/at4enitUqi0CQkedGgEW/LszeO1x/wzpYQldD32b1u3tvhue6uDpxnhytD+QrWXv3iSRUtmKkfxcl5e8tqFpMuTvXBW53AZEElw2kqdR925WPs3Y4ceI0MBQaA+xwYPgqL3DQgF22UOHNWJqFR+i98Deu2hsAeHClqfAiJD8euwiWocH021aArs1Dx4KIWjc88BCLSos7mPymfzFFfrj0TligEZutFLuJGNiZOfvr2TXxrDnDif2WexHbHzrzYvGQdEbPluREsuqAB6HU7ibOjNx3PtZI4X8AkgRhb8i/XaZs9
 /yzqQrC7
 mA1IwqBYJt91Tv5iwWMRVpSMBjTe0nnDbBLjjymocAykodH/bY1fDAlNFCpujhoyoovrjxpULXdSMChNv1j0HslA5u8xBW70/VQJxyehFXGUKiGCfrMdvkP4H/clIRNtlNrkbK1t++yyWLEl6adZqZEl0CsoSaI1AjLAhxOwZcdOpOibOZLwLJ/VWrzy7sAsETvGXIQ8p3uGyCLisZNkuBzA3MljHyg/VLUWL29PRIW44foU+swgLDJ4CmgUHGXbNo//UfB+dxHIKa0+AgMD5+dWAA3n54rI3QaYr0FSz4SSANZ0NAhLLDM02SiAuJcJMGNWGU1+mDAiH8DuUnqeQH0J3q4H66qL8BCcWBhT7xhpoYkpWdQPKNLEtI2pm1pGsrQIHtIpJF/4dwV1sKFWqi22r8ERIzuV9UKqyv1CQLzZl+qdp4UkTAohY9OI+TDFx9qUNIIDEIB1+u6nyrrqBGLXwjiKQEHyJ+2ze2IGl/e2zaXGq9qo5ECxo2BJQHG6vIgOtxaxlha3rIdzGHHzPvRCiIAlV7bLuRi5WLIkjU708xvXALM4GzOlxtibkANh8LUla
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 19:48:25 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   2c3f468717231305523ddcd94d91c0d5e4a72419
> commit: def36547cd98fa3f7ecac1bf860479f500bc6b1e [301/315] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]
>      922 | static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)

Thanks. I  did this:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
Date: Wed May 13 10:22:14 AM PDT 2026

move kill_all_shared_mm() inside CONFIG_MMU

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   66 ++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

--- a/mm/oom_kill.c~mm-process_mrelease-introduce-process_mrelease_reap_kill-flag-fix
+++ a/mm/oom_kill.c
@@ -676,6 +676,39 @@ static void wake_oom_reaper(struct timer
 }
 
 /*
+ * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
+ * @victim: the targeted OOM process group leader
+ * @mm:     the virtual memory space being reaped
+ *
+ * Traverse all threads globally and signal any user processes sharing the
+ * identical mm footprints, ensuring no concurrent users pin the memory. Skips
+ * the system global init and kernel worker threads.
+ */
+static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
+{
+	struct task_struct *p;
+	bool failed = false;
+
+	rcu_read_lock();
+	for_each_process(p) {
+		if (!process_shares_mm(p, mm))
+			continue;
+		if (is_global_init(p)) {
+			failed = true;
+			continue;
+		}
+		if (unlikely(p->flags & PF_KTHREAD))
+			continue;
+
+		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
+			failed = true;
+	}
+	rcu_read_unlock();
+
+	return failed ? -EBUSY : 0;
+}
+
+/*
  * Give the OOM victim time to exit naturally before invoking the oom_reaping.
  * The timers timeout is arbitrary... the longer it is, the longer the worst
  * case scenario for the OOM can take. If it is too small, the oom_reaper can
@@ -910,39 +943,6 @@ static bool task_will_free_mem(struct ta
 	return ret;
 }
 
-/*
- * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
- * @victim: the targeted OOM process group leader
- * @mm:     the virtual memory space being reaped
- *
- * Traverse all threads globally and signal any user processes sharing the identical
- * mm footprints, ensuring no concurrent users pin the memory. Skips the system
- * global init and kernel worker threads.
- */
-static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
-{
-	struct task_struct *p;
-	bool failed = false;
-
-	rcu_read_lock();
-	for_each_process(p) {
-		if (!process_shares_mm(p, mm))
-			continue;
-		if (is_global_init(p)) {
-			failed = true;
-			continue;
-		}
-		if (unlikely(p->flags & PF_KTHREAD))
-			continue;
-
-		if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
-			failed = true;
-	}
-	rcu_read_unlock();
-
-	return failed ? -EBUSY : 0;
-}
-
 static void __oom_kill_process(struct task_struct *victim, const char *message)
 {
 	struct task_struct *p;
_


