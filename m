Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6331090233
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685466B04DA; Thu, 19 Mar 2026 10:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659AE6B04DC; Thu, 19 Mar 2026 10:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524096B04DD; Thu, 19 Mar 2026 10:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1FD6B04DA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:24:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C17398C003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:27 +0000 (UTC)
X-FDA: 84563032974.13.F3E1468
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf09.hostedemail.com (Postfix) with ESMTP id 87255140002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773930266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjgnu95mBiJWlOTGSTEE1TkykBAopsDjiebw1pJxzCg=;
	b=zSeb+tPumqS/UOEPlqMO7MYMYCnAYRDlWVr2oINj/of8EmZk1CzncZAaSw+XUXJm61bygs
	fvm+b9qS2QCFXc8LowwmlL8huORL7AZAHZDK5TEr5NDZiYot5KysnD2+hgBBm9+9Jth+4I
	wr3AjHUahKMjyZQ/7Q3Wvfcuy67WfbY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773930266; a=rsa-sha256;
	cv=none;
	b=26c4tVGlaZEpSl56VqIWIrqu8GJck+mBohH3HLTGy1XI9GUbnpcTs1dRmv0O7GDSFBPTp0
	h4EFeU/4bi4x4jXj+yPiURzlDk/ZzDxTq/jUKZzviAQdtc1ZBA1Nm48Cfk7ycckgQLrceH
	s4Au5hZIDq8H07972O9SbUwFRP9I+rs=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 19 Mar 2026 23:24:23 +0900
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
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: [PATCH v5 3/3] PM: hibernate: fix spurious GFP mask WARNING in uswsusp path
Date: Thu, 19 Mar 2026 23:24:04 +0900
Message-Id: <20260319142404.3683019-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319142404.3683019-1-youngjun.park@lge.com>
References: <20260319142404.3683019-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87255140002
X-Rspamd-Server: rspam07
X-Stat-Signature: upg3rezbx83bb43sddpe66xhospa7gt1
X-Rspam-User: 
X-HE-Tag: 1773930265-151798
X-HE-Meta: U2FsdGVkX18FCYxy6d4M8+DSNGBhcTbuBPNqRgjtGucrFfVVOkPTQYvS7UJG9VcEwk9K2CfM/GL5IY0NZjcrZsg0DlJC8f9DolQCXinaKgBYL8BgcNLxVuiwyU6bCppyCtIfalWZVISoBVb2Bw4TcJ1/UKOcpf3JCg1ET5945MIOb0vFcp61UDWSWvwhe9uHVTwtadrZpDyxSRgwGuF7UxTFm4IJ//L8TzihlbozSt0UFMLKvisW1WiGElzvPJn/+9cRZ6Oaj2PnPi3T0K7epBv1a2AeyDl9ZKqu3b70vHPmXrR2qGJLuWqTo+N0agsTcMrT4OG3nTNimVRHf7Pjm9z/distiFw0GX6mZQ0Dvam4LNsJ64duzJRu5/cULtJbgAO0gRU0PWJWuyUjEypju2+DNcJD+r4O+hH34zW/djH4NkqfN+MaIQqQ8eESD+5q+6ow+DTXRyQpA4T0Jeg9XciLhnppugng39bKPIaY+tamlnr8caERCoSFkSFoO7+N7oEe9xuw+mvEDtucMVgDZsKLw9Sbmgdi1USZeXr3jrIE1Da5F4SAxo7lGuhhPYKw2bizKHHRjwLRk+H7DqdjtBEqJLEeZMlMi7tImgGjYeHlQWyt1Lkb9XPrq3+P38PhdJ82O/VZc9npKYa7tAMAj/DMikWAu57su756xxY0rv+r6FfNHbazjfDVIB4U0Sc5+4GhW7qq6b5ARwCqSp0Q3HHdCRiKyPPY1wdz/X13Q2T7IZ0J8uCbNS/KaBpvGKz7KCKgfvsXEZxXcn4ZjIeKjTM4h//XDfmNr9Frp/lTXBzgRiJa+vkt0XruNJOWonF9UI93AwVMYTwQtEHTp2gY+TqmVtLHoePym5qp7VFKeZQxEbokQyK9xJi4bzDYRfgzQlpUjvAIx/JaJz+K82g66YlazaXbhrWWV40k4gzoJLXHXyR8DSWh5APt8QC9k/hdxbiMRfsaVTXIFMKrbQK
 kgDgLm6F
 SOVhLrl5ySvBuX111YxWXLuZYXS/mAYOovN7q1Yg7x5rCujaQdjpdk34YNzjR3V+oyUGWIAC4sUJSXKdH0Itr2Ci3USHjTkhVJMgH397HLumC2OPPtqggqDhv6oeltqKPqyo/EIvjFiJkZg1hFqH3VLmT0+k6PbRgUs2y
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


