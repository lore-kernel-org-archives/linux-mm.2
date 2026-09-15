Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4367C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE926B00BC; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7056B00BD; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB216B00BE; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66E046B00BD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:17:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7864C0307
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:12 +0000 (UTC)
X-FDA: 85214535504.01.EFF26A3
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf21.hostedemail.com (Postfix) with ESMTP id C75DA1C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:17:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789442231;
	b=x/TDOnZOaFIBv6nBm+NSXey1dTJs8k9Tj/diWbfUabRg5z2u1lw0LSK/qDKmnr/zd2fmS/
	Lt4WRd8E1pwb5XOD8LJNHX3ECc+0QbhbG/vyjdFZSf60fb8/whCLrlJM+DqkhhbrTJJfFR
	YGHsCBFUoJ1PBYzIzgy1mdtHQtWYofE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789442231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JHTQW7U9J7P1+a9Acm/17qHIjWu252uQhU1zei30wgw=;
	b=4QMHMZzvouVKVLTjfHU+ZJOn4Lbudnb1hkhiGG5jqCrhvijJJrFy1R5HDgdnAUu+qy1Smm
	CB8gYbwsfsKP/qRQPaMja023sWP/6xxpCRqTZ5q/kD2an/XsQ0W+saC78bweNQcfus+AMn
	p8NG+D3yWmm6a7XWMv4KFmAzA01Cie8=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 15 Sep 2026 12:17:08 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	her0gyugyu@gmail.com,
	youngjun.park@lge.com,
	taejoon.song@lge.com
Subject: [RFC PATCH 09/10] PM: hibernate: tell swap how much space an image needs
Date: Tue, 15 Sep 2026 12:16:57 +0900
Message-Id: <20260915031658.1505680-10-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915031658.1505680-1-youngjun.park@lge.com>
References: <20260915031658.1505680-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C75DA1C0004
X-Stat-Signature: e3hopomea3jmdi8kcmpxtkp1gmyx1t3d
X-HE-Tag: 1789442230-575530
X-HE-Meta: U2FsdGVkX18VA8tTaROoC6DTLJOhh00jUlC6XJ6IOsPHz9o78LrNNTThK2F2GdJ5DFru5I5PjryQs7VVAJV8Ib/VavI12Y2vtTEEMopR3kJhRMyPFZFpBkpJyRiPbHEoarYrpJk3olRpun/1hs3TEmlMwuXMp4lUssAoFzVHEen8XSl/8I9Ru3plYobT0+Z+fYa2YzsewFMdsbwYs/FOKTy0VHqZAEzu2k1MXhiy1xqvTd+r1I3QE/BBLDmdw1dc7aETmMsS8pgsdDM2scd5L48GtcmaudM5RHfsX0eai2fXmH5tKIUivodo2sVnO5yLT2ero10vnSb6xtCM1DpfwgU4a1Iev9Q2uCgH6OCKNiIoBqMCMOmjaI8LVubeqeF+ubaf9NChJ0zhJriA4vorFgU4r78vB3kd0g76xgxIGXk9EoNB+kjCA74vx21EhVaIIhyxxHtAVlaRYFJb/8OtQYgiHy6DiNG5w4VnHmUHLWczM5J5uERdzs791od9cQZDi5quwA6vey1GXJsMdJOaYPnVSVA+5w4MbuDMQ3U7MmNHWkgoB30BnxEnLCsY2DuIu8+FRiXcxBo6zT9oN4tj6j8btESAoLdYy5T80vr9Vo3rTYp8zaXxH/lzfJxDtkTWrXUAw8kOWv1sc2n08rIw06RIckWv5oGcOAFq/OSt39cuRHLKT0BRzNuPnEe9xbwtmGUNBgiqRGGWt1VZAAjUurcWsgEL+cIzjtfKvb9hqc5Ca4j5AUqxfhQHPJ0vK8oMsScySN3hDhD70HCNYQyyof7RAt/2WolqKffGew6CybuwZpvWFG8P3cI7n5rqQU9DTTwZu+IOX7r4QYSyPNjsDOggQYL3C/4B7K69n7M8/wGDx5U2/qYgoT2V9gyMhKhnAxpkmtHiazLTpEjuPiRyn3CuuLS1uqGEspNK8g1juEc9rrycOvkyQ9UKLn8SlMfUc+Q2hXPUi2MvOiCCVyJ
 tMERPEzS
 1CxOGfjWLhPUkkj+tXufc5ZkVr941L6x5gl0yHaMTXFLf1eiqT9elsi0fB3gqXhHixDiRbVWJegK8ZRi/K1c4VJfxVKUx3d+o4NDry6mqjimnyEOgNTe+fIKEHQsnALmHfBVXtrELzkjztogdxpJcb47p/2pIo6VGRD+Z9VbNDFI9sNIWm8ZJ1pAFEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap has no way to ask how big a hibernation image gets.  Add
hibernate=reserve[:<size>] and hibernation_reserve_pages(), which swap
can call at swapon to learn how much space to hold back.

The answer is <size>, or image_size when no size is given.  It is zero
without hibernate=reserve and for any area other than the one named by
resume=.  The image can still outgrow it.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 .../admin-guide/kernel-parameters.txt         |  8 ++++++
 include/linux/suspend.h                       |  3 +++
 kernel/power/hibernate.c                      | 26 +++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..eb2454b73f4b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1980,6 +1980,14 @@ Kernel parameters
 		protect_image	Turn on image protection during restoration
 				(that will set all pages holding image data
 				during restoration read-only).
+		reserve[:<size>]
+				Hold <size> of swap back for the image when the
+				area named by resume= and resume_offset= is
+				swapped on.  Swap cannot use that space.
+				Without <size>, /sys/power/image_size is used.
+				<size> takes K, M or G.  More than half of the
+				area is refused.  Later changes take effect at
+				the next swapon.
 
 	hibernate.compressor= 	[HIBERNATION] Compression algorithm to be
 				used with hibernation.
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index b02876f1ae38..1fb1f5d6ce6a 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -393,6 +393,7 @@ extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
 extern bool hibernation_available(void);
+unsigned long hibernation_reserve_pages(dev_t dev, sector_t offset);
 asmlinkage int swsusp_save(void);
 extern struct pbe *restore_pblist;
 int pfn_is_nosave(unsigned long pfn);
@@ -412,6 +413,8 @@ static inline void hibernation_set_ops(const struct platform_hibernation_ops *op
 static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 static inline bool hibernation_available(void) { return false; }
+static inline unsigned long hibernation_reserve_pages(dev_t dev, sector_t offset)
+{ return 0; }
 
 static inline int hibernate_quiet_exec(int (*func)(void *data), void *data) {
 	return -ENOTSUPP;
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 907d791b85ad..225fe55ee703 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -41,6 +41,8 @@
 static int nocompress;
 static int noresume;
 static int nohibernate;
+static int reserve_swap;
+static unsigned long reserve_size;
 static int resume_wait;
 static unsigned int resume_delay;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
@@ -113,6 +115,26 @@ bool hibernation_available(void)
 		!secretmem_active() && !cxl_mem_active();
 }
 
+/**
+ * hibernation_reserve_pages - How much swap to hold back for an image.
+ * @dev: the block device the swap area lives on.
+ * @offset: the first block of the swap area on that device.
+ *
+ * Only the area named by resume= and resume_offset= holds anything back.
+ * The image can still grow past this amount.
+ *
+ * Return: the number of pages to hold back, or zero when nothing should be.
+ */
+unsigned long hibernation_reserve_pages(dev_t dev, sector_t offset)
+{
+	if (!reserve_swap || !hibernation_available())
+		return 0;
+	if (!dev || dev != swsusp_resume_device || offset != swsusp_resume_block)
+		return 0;
+
+	return DIV_ROUND_UP(reserve_size ? reserve_size : image_size, PAGE_SIZE);
+}
+
 /**
  * hibernation_set_ops - Set the global hibernate operations.
  * @ops: Hibernation operations to use in subsequent hibernation transitions.
@@ -1437,6 +1459,10 @@ static int __init hibernate_setup(char *str)
 	} else if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX)
 		   && !strncmp(str, "protect_image", 13)) {
 		enable_restore_image_protection();
+	} else if (!strncmp(str, "reserve", 7)) {
+		reserve_swap = 1;
+		if (str[7] == ':')
+			reserve_size = memparse(str + 8, NULL);
 	}
 	return 1;
 }
-- 
2.48.1


