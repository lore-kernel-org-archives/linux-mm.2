Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7223FD9E2E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 02:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DDA06B0088; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B036B0089; Thu, 26 Feb 2026 21:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E806B0092; Thu, 26 Feb 2026 21:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D82D26B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:57:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F7A01B6717
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:24 +0000 (UTC)
X-FDA: 84488725608.18.7013880
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 842001C0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:57:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772161042; a=rsa-sha256;
	cv=none;
	b=nk+DQpJVDdaR9UqMauj0u+WkzpAqRC2FupnSutfWkOwlDgRaGpvaDenThU85M0kBSw3R2C
	FXvQFwceYosDuEL+xVnv37A2mEZ4012UacnIY3lUOOKyvgouFOae0oXQpLQHydnTDnm6hH
	xXHkIyBmRU+Qavjbaj+dJKWkYaFwwNM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of yebin@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yebin@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772161042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BnO3ft+Pk0rGB/9WqfxjOSo4cLnldakpwR0V6eyea0M=;
	b=0QwyG5BSfddn/uSskttUe+98nOEK/zZdC3CI2KPKzHY16/SW+BH6H0pdwTN5x8Q+ab/pHp
	bLl/H41qGWHfP5FJHlRzCVDGV/RvRseCjWeiS7NOUni3snHQphCtt2zXEoLZ8yUjjyGvS1
	uSrkt92I5qJk4kDZtcFHh4eJQh6RLjY=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fMXzN5H6mzYQtj0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:56:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2893D40570
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:57:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP4 (Coremail) with SMTP id gCh0CgBXuPgJCKFpsEGdIw--.32070S7;
	Fri, 27 Feb 2026 10:57:15 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@fromorbit.com,
	zhengqi.arch@bytedance.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	yebin10@huawei.com
Subject: [PATCH v3 3/3] Documentation: add instructions for using 'drop_fs_caches sysctl' sysctl
Date: Fri, 27 Feb 2026 10:55:48 +0800
Message-Id: <20260227025548.2252380-4-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227025548.2252380-1-yebin@huaweicloud.com>
References: <20260227025548.2252380-1-yebin@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXuPgJCKFpsEGdIw--.32070S7
X-Coremail-Antispam: 1UD129KBjvJXoW7CrW3Gw18ZrWDZw15WF4fuFg_yoW5JFWrpF
	ZrAryIgw18Xay3WrnxXr47tFyfXay8JFy0q3s7Kr1rZw15CFyj9rsFyw4YqFy7GFW8C3yI
	qrW5Kwn8Ww1DtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI
	0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG
	67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOGQ6
	DUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 842001C0005
X-Stat-Signature: xyjiadc6gd5gq1pk1pfyp8g5j5fswnn3
X-Rspam-User: 
X-HE-Tag: 1772161039-602863
X-HE-Meta: U2FsdGVkX1/MGdABNGPwqjlXXuRopW7uRLs2+sIlMNNZSHAMhP6AjJp3yDh+AQUS4XHSjOQzeF1KySPTp5cogKh1dydZxMDH4PU3WFxW+atvXl72waOAiqHV5xWSqnHUz/8IKgIfB5liJPICvfZVsmKB7mTrSmBp1ap96++vXKJUdl/3vp4sc+xSCNQudhF5OhF4DHuri05fsNTzOBdrZep665+0x18wLVDpekm7UQ3Zu5Bh9KMfVIDwtvtcF+E2DQWr04CJyKhaC6jfcRtavrOr/usI2rFo+bqdawc4pmit9oKao8745cSqngI9bHKAeoENxKmaFiQqrfLjFK+DwwHH3A1Iz8bpTzIadf6m+QV0Hzbu1smfv9OFA9ReCgxhgM2X4vGB63sjOpCUp70ncXPmSxDtjGFgjUU/Lw9n6wqy8JbDJD7u0/KRAaoS+WMFRXQDbMHRygcIEpCyTFiSdLbkS1X4R9mDfHwOnDYhtZ8ReAuAOG6d0Ch3U9fRbaH97caV07TTGazX17+U3jJ5rKun0zh2EEJYnW8YxExLvXKARv7xyJEUP0rLE1KJTfghUtQcxy/wKx1jDcltIT0bqp2dUoGer32ttLW0rKWuWk+lqCah5LxwsqmSmL7gLGYllR4/m+FvuEa7WCQtHiz+xw3ek/QraWwbQey8XcKTXbwL5JHty+VELh0OIXI5duAB7nY21pWh+QBNRPuynNr8Sbz+4HsIEQcekSUWyGdSvWRJ7hLdzMCwr8rKZ1hwyQ8Omk9JsvYIxuNl+OnhsFfCFZsWCZxBXwclyG9S/klQITFZM9Syq91xJdt0cf1608RB6BH7jpfgpffsK29VUyraEWGBTfgjGEGc+Mhq7aP83G2klGC1i/IxeZpVhUsFZHNO0VAVb/1AZYW2bii+I9OYJEcxZ4u/7r12HW+sVqlVCl219H2BDuh6k4DRt4dIFRlAGbrB4YMIjM16eg/gGlR
 XinzUQ/X
 JGHXOnjWMlcK2x5ikeIXENgInHD47H6iFwgrXJFexuxcs4VDCzq7ZZOlC9cBFfJBo2tSVWIW2vvtyOPVsHSK1AgWsMHaVFX8yfqInWkOLr5DyDvnYjVu5Sr4GfePLEH/jNfBV+mfH1IcR0uo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Bin <yebin10@huawei.com>

Add instructions for 'drop_fs_caches sysctl' sysctl in 'vm.rst'.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 44 +++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..76545da53e20 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -37,6 +37,7 @@ Currently, these files are in /proc/sys/vm:
 - dirtytime_expire_seconds
 - dirty_writeback_centisecs
 - drop_caches
+- drop_fs_caches
 - enable_soft_offline
 - extfrag_threshold
 - highmem_is_dirtyable
@@ -286,6 +287,49 @@ used::
 These are informational only.  They do not mean that anything is wrong
 with your system.  To disable them, echo 4 (bit 2) into drop_caches.
 
+drop_fs_caches
+==============
+
+Writing to this will cause the kernel to drop clean for a specific file system
+caches, as well as reclaimable slab objects like dentries and inodes. Once
+dropped, their memory becomes free. Except for specifying the device number
+or file path for a specific file system, everything else is consistent with
+drop_caches. The device number can be viewed through "cat /proc/self/montinfo"
+or 'lsblk'.
+
+To free pagecache::
+
+	echo "1 MAJOR:MINOR" > /proc/sys/vm/drop_fs_caches
+Or
+	echo "1 /mnt/XX" > /proc/sys/vm/drop_fs_caches
+
+To free reclaimable slab objects (includes dentries and inodes)::
+
+	echo "2 MAJOR:MINOR" > /proc/sys/vm/drop_fs_caches
+Or
+	echo "2 /mnt/XX" > /proc/sys/vm/drop_fs_caches
+
+To free slab objects and pagecache::
+
+	echo "3 MAJOR:MINOR" > /proc/sys/vm/drop_fs_caches
+Or
+	echo "3 /mnt/XX" > /proc/sys/vm/drop_fs_caches
+
+You may see error messages in your kernel log when incorrect path or device
+number provided::
+
+	echo (1234): drop_fs_caches: failed to get path(/mnt/XX) ERRNO
+Or
+	echo (1234): drop_fs_caches: failed to get dev(MAJOR:MINOR)'s sb
+
+You may see informational messages in your kernel log when this file is
+used::
+
+	echo (1234): drop_fs_caches: 3 MAJOR:MINOR
+
+These are informational only. They do not mean that anything is wrong
+with your system. To disable them, echo 4 (bit 2) into drop_fs_caches.
+
 enable_soft_offline
 ===================
 Correctable memory errors are very common on servers. Soft-offline is kernel's
-- 
2.34.1


