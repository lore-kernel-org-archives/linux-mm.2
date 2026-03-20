Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF001099B23
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817A66B00E4; Fri, 20 Mar 2026 13:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EEE06B00E7; Fri, 20 Mar 2026 13:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE0E6B00E8; Fri, 20 Mar 2026 13:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 606C36B00E4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:03:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F22EF160320
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:03:26 +0000 (UTC)
X-FDA: 84567062412.19.CBC148B
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf07.hostedemail.com (Postfix) with ESMTP id CDA5A4000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:03:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774026205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OMPMt9kZ7lI0ejkeJIu6VM3g+BgsGgYlwONj9cANWD8=;
	b=Sx91AbQ5m65X6v/VBGjIxKheHOFGBnPs7tc1KJaLbndb4iUOPfa0CIi18fnYGsDS9pSfZn
	C/0AnPdZonljTLBq/X49Mdfzwtd1d6BW9qC3o3IBWMYPDQ2qzZf4+jAsjPikBh6thKxz7L
	38PeiYs4GYDqwxW8vj4lUpK4M6UYBjs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774026205; a=rsa-sha256;
	cv=none;
	b=YUxNIfDYtBxfEEsck9e+gQ2ykxZnlYuugXX9e1SLDBe8U7UaR2vT6gd+4hPybGa2TobZBX
	OlDP+1HFDn61P1uE8SZyoTuvYrdGhXlTbl3GU6WgK1YeAcnlinGLmGoGCMnvQ/SY6hEmsf
	jQZRFblaXixl1zLtNloslVuFZc5TbZY=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Mar 2026 02:03:21 +0900
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
Subject: [PATCH v6 3/3] PM: hibernate: fix spurious GFP mask WARNING in uswsusp path
Date: Sat, 21 Mar 2026 02:03:13 +0900
Message-Id: <20260320170313.163386-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320170313.163386-1-youngjun.park@lge.com>
References: <20260320170313.163386-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1djbbzzfuonne7z983cfxeohrx9osonb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CDA5A4000E
X-HE-Tag: 1774026204-789094
X-HE-Meta: U2FsdGVkX1/H4eKvlFx2+PbLbXG25WJfz5VuMm8NYWXKd/W5egZ3jpTm9I7rQtIxs6RuYepCWJYsMWig1NiWm9gwPukksd+kK7KKp5OLHP3IFfZ94JU30yud6BoH1QhHDfUq0v6TaTOdKx+NuX2Mr/Tamqj5kV0u7CPiShKsKfqvlz9QuBeP4/csHc/YlQ1K4uaIYypL5aKygsRCS/Sae1oNgi1KSonRFtu441sus/PS5zt3PYfghTWCQmUNvCnwUY1FQRfNaATFexqsJC6F0HDj9EbaWeAGEObjxqQEA1A1EGJWasxOvRLF0ReE7EnLoeq4yLyM6cO6E3DGUWvQZKhX1wenK6QvoU1BfsHkS3uVbDONVjE5gbMsVHIBLo8hf1lS9mK0ExhB/4qdlm6UV7vJH40TQyMI9/al9xQT84IP0LiJWEaV5LGjzZ3xV8JNWLqXNHNo84WNbFYU39Zepf0Fzj9jEygco+NRGwMdw18icvLi3pbkyTyGoOkdTJGmImGArZo5ebnVsgo7lUHGOY6GsIkmQrDPQCMkzRS9mAh7yktgfsI5NuTCyPzqLTFp/1Lvntw2M38yRIDahT1vO7BWtR3BTTGk+TxX+QdEykYh8xbsWEK5RcipWGbtwqU1ivJQp6eO3v0TIbbuYVjPeroEY5HU9h2AzpcQ3HYDapr7FMU19NOtCJ1jbhunY7BqVKuqo7WrWlzVHWZUFATTN9174+0AWZ4Jm4wpnsNRcI0rnBNgUxoW1LTvaS0e3a07z99i9TS08G0hyOLQPxSx5ILwUbYdcbw2R1lTCSX4M2EfzGle7KwskFmN1hdS4XJQkhZuPMS3nWWxn90G56mY8p7pcJD1kpVOrNF/l61W7T7i8wInvEje8BGVlSjL35cFmmcTuNY2N5ysF6K2FpOnaDFbo8LbzfSxhqvwVBj6YVmVLqYrHuDd5xZFABTjLx8aCmGndp4wagF4FJh+teN
 3SVnKjqx
 HZY9+ENR5AAEIlEI7G8DxO/cG1OBTe76rW/EkjEudFk9Ra1R3+mmucE6RFjAZukyjITXoCTwjM9MuQnFm05SSJ7ky5eamE0eq55lG0ZRZs8n2W4GsfQ3ZuNyGN7rueHpC4QB0akcGR2EbSF9wvaTeVwiqfZOuXwa66axz
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
SNAPSHOT_CREATE_IMAGE, SNAPSHOT_UNFREEZE, and snapshot_release(),
where the GFP mask may or may not be restricted depending on the
execution path.

Before the stacking change this was a silent no-op; it now triggers
a WARNING when saved_gfp_count is 0.

Introduce pm_restore_gfp_mask_safe(), which skips the call if
saved_gfp_count is 0. This avoids the warning without requiring
state tracking in snapshot_ioctl, which could otherwise leave the
GFP mask permanently restricted if mismanaged.

Fixes: 35e4a69b2003f ("PM: sleep: Allow pm_restrict_gfp_mask() stacking")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/suspend.h |  1 +
 kernel/power/main.c     | 18 ++++++++++++++++++
 kernel/power/user.c     |  6 +++---
 3 files changed, 22 insertions(+), 3 deletions(-)

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
index 5f8c9e12eaec..90e9bd56a433 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -36,6 +36,24 @@
 static unsigned int saved_gfp_count;
 static gfp_t saved_gfp_mask;
 
+/**
+ * pm_restore_gfp_mask_safe - Conditionally restore the GFP mask
+ *
+ * Call pm_restore_gfp_mask() only if a GFP restriction is active.
+ *
+ * After GFP mask stacking was introduced, calling
+ * pm_restore_gfp_mask() without a matching restriction triggers a
+ * warning. Some hibernation paths invoke restore defensively, so this
+ * helper avoids spurious warnings when no restriction is in place.
+ */
+void pm_restore_gfp_mask_safe(void)
+{
+	WARN_ON(!mutex_is_locked(&system_transition_mutex));
+	if (!saved_gfp_count)
+		return;
+	pm_restore_gfp_mask();
+}
+
 void pm_restore_gfp_mask(void)
 {
 	WARN_ON(!mutex_is_locked(&system_transition_mutex));
diff --git a/kernel/power/user.c b/kernel/power/user.c
index aab9aece1009..88de4b76a9dc 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -119,7 +119,7 @@ static int snapshot_release(struct inode *inode, struct file *filp)
 	free_all_swap_pages(data->swap);
 	unpin_hibernation_swap_type(data->swap);
 	if (data->frozen) {
-		pm_restore_gfp_mask();
+		pm_restore_gfp_mask_safe();
 		free_basic_memory_bitmaps();
 		thaw_processes();
 	} else if (data->free_bitmaps) {
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


