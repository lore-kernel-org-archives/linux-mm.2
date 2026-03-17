Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D59FEDA00
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2BD6B0099; Tue, 17 Mar 2026 14:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799626B009D; Tue, 17 Mar 2026 14:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3BB6B0099; Tue, 17 Mar 2026 14:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC5A6B0099
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:13:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2035D1A02FD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:13:31 +0000 (UTC)
X-FDA: 84556352622.15.33B5602
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf21.hostedemail.com (Postfix) with ESMTP id E87F61C0006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:13:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773771209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjgnu95mBiJWlOTGSTEE1TkykBAopsDjiebw1pJxzCg=;
	b=kq5TKVeMbmLnTOR0KHBDkK1SDKc6Up7/aFywhY9q0xTxN11iwEACeGdHhOgHno36T4XQbH
	VRrNt8lR44+ytXNhbHhXRXikbW504ewtzMxVHZWZkEsKyPb2y6s64u/l1CEWMDagspP5sM
	g+ln02LMJby9+GFJHeLyGY/lMQP/Bu8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773771209; a=rsa-sha256;
	cv=none;
	b=u96ceIqHYa46vM2WHuxRrW8SrqcxFeSYIqQaqMdBbf7lYxXXpHB06Ngw27Jr/cJviQoJHo
	Qd3B9B78HhicQKDvSaDOY1XwnAJZ80kJp81SshEwDYtUGh4FR1zVMBWCWFyEEwX2SmOPit
	XXi4a8kAUDoZOzMMfB+ljOq3KFt2DIU=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Mar 2026 03:13:26 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: rafael@kernel.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	pavel@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	usama.arif@linux.dev,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 3/3] PM: hibernate: fix spurious GFP mask WARNING in uswsusp path
Date: Wed, 18 Mar 2026 03:13:18 +0900
Message-Id: <20260317181318.2517015-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260317181318.2517015-1-youngjun.park@lge.com>
References: <20260317181318.2517015-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E87F61C0006
X-Stat-Signature: ckpptatsxii8gjgew3hjn6wfzsbzxybx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773771208-21727
X-HE-Meta: U2FsdGVkX1/mPtk6eLR02y2e687lwuaCmRpFm69KgfF2JuhYBIhZXW2k8Wlb8/aebzsYJFcT0IFS9JgXzb5kI+pHqdMj/I8WcT2Rer8GoaPan6eG8Q6TEg3Z+zQ7sEc3Z2EX3j+C2aC9R4OR47VxsGlIoQ0ZTY4WHkp9IRy2kc2KWQDWoyOcbO+8BmD1E80I4dNcaRR9v5v8cQk7vLNFF7cibBJs4SF1EykLeq5xrdzZnD8QmRrBjN6JN1DppTxfEneK5doXsennf4+aQuBQ8TdU+80wtGGIwg5PoA/HrnjM2dHCemvyhgEC0e5Tswj+3HdGp6/U7amb9gQBWsz60JqjQOArxPkOGmd6R1DZOZ6ZWZ1wynsiFxVIYiYlOTL0hR8dNLfTcRHwsrDTDglZWypLHVel+luFA7ZD/xvrsC5FIvrFkbK90AY+WRsd8iQrXqUYp8xdbNgMIOblk+qFli3A8lg1A02nTESSfwFHDKQ8qDAgsVoeIsDWRNEAoq84Eo0Zogy9KqmSAW+YktisUaxCxCvW0K31MTlWSind2eLsuXrX2Nez4oe/KytPAFYSXkoaMFOh/UMBzg2cJjCDFDzfx0GqZz466aoPfsqqLSuwyyZGrU3YBvfoTp72t4kuWAWXB5dmRMshJd5/K4ucOXq2nRn+3WrzCGr7i26751iZUaBWb+O0BKqT3MtkEFzqEeH6Ij00S9b8SeWdCj9HXiW2ch9gQyFRp5BXU/ZGQDLbWRv3GQydXfM3H4qjOhsgBbQkK8Mjdk0uMKGAlZ/J++MNIkrhQOxawbp9uLFWYRydrm+8pADOgIeq2Is1o6dPb93YEnNqHJ8MvKVRGEsqZY7t9pwvxgfxL60udMO2f4VbWwXRv5Gsgduj2I7H3s5i0EcX6CqDKTDvkioZkVrWkKUsqJSYs1/u5496PsQ7Vw3h3UNI0dH29QhYA5R4JYnCYBEMWIZmBzm008e52mq
 8iZ1EKl/
 egP1LYIYPCGM8Vhu0Mwri72Or3WbEEC927Uw/fMVo+ly2+0fbpaDpvrGI82u03yTumAXpOPpixULgEfrXG08wFTSIdF5VuQ4wFlhmffnf79fiPZ99b3ID32AC5VYrBCQwexVkAvqcDAYabQAcq7GJE5PmLGADUjbeDxYB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask()
stacking") introduced refcount-based GFP mask management that warns
when pm_restore_gfp_mask() is called with saved_gfp_count == 0:

  WARNING: kernel/power/main.c:44 at pm_restore_gfp_mask+0xd7/0xf0
  CPU: 0 UID: 0 PID: 373 Comm: s2disk
  Call Trace:
   snapshot_ioctl+0x964/0xbd0
   __x64_sys_ioctl+0x724/0x1320
  ...

The uswsusp path calls pm_restore_gfp_mask() defensively in
SNAPSHOT_CREATE_IMAGE and SNAPSHOT_UNFREEZE where the GFP mask may
or may not be restricted depending on context (first call vs retry,
hibernate vs resume). Before the stacking patch this was a silent
no-op; now it triggers a WARNING.

Introduce pm_restore_gfp_mask_safe() that skips the call when
saved_gfp_count is 0. This is preferred over tracking the restrict
state in snapshot_ioctl, as incorrect tracking risks leaving the
GFP mask permanently restricted.

Fixes: 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask() stacking")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/suspend.h | 1 +
 kernel/power/main.c     | 7 +++++++
 kernel/power/user.c     | 4 ++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index b02876f1ae38..7777931d88a5 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -454,6 +454,7 @@ extern void pm_report_hw_sleep_time(u64 t);
 extern void pm_report_max_hw_sleep(u64 t);
 void pm_restrict_gfp_mask(void);
 void pm_restore_gfp_mask(void);
+void pm_restore_gfp_mask_safe(void);
 
 #define pm_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb =			\
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 5f8c9e12eaec..e610a8c8b7ff 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -36,6 +36,13 @@
 static unsigned int saved_gfp_count;
 static gfp_t saved_gfp_mask;
 
+void pm_restore_gfp_mask_safe(void)
+{
+	if (!saved_gfp_count)
+		return;
+	pm_restore_gfp_mask();
+}
+
 void pm_restore_gfp_mask(void)
 {
 	WARN_ON(!mutex_is_locked(&system_transition_mutex));
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 3e41544b99d5..41cff6a89a1c 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -306,7 +306,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 	case SNAPSHOT_UNFREEZE:
 		if (!data->frozen || data->ready)
 			break;
-		pm_restore_gfp_mask();
+		pm_restore_gfp_mask_safe();
 		free_basic_memory_bitmaps();
 		data->free_bitmaps = false;
 		thaw_processes();
@@ -318,7 +318,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
-		pm_restore_gfp_mask();
+		pm_restore_gfp_mask_safe();
 		error = hibernation_snapshot(data->platform_support);
 		if (!error) {
 			error = put_user(in_suspend, (int __user *)arg);
-- 
2.34.1


