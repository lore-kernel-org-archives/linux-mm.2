Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CC2CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BDD6B0088; Thu, 30 Apr 2026 15:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CD36B008A; Thu, 30 Apr 2026 15:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A566B008C; Thu, 30 Apr 2026 15:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F63F6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:56:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A50C040131
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:56:58 +0000 (UTC)
X-FDA: 84716280516.24.B3DE314
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id C9C8180005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:56:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AGLXV6He;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777579016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9suyq7OsGoU5hjx6DKCtQZWhNejxcqAH+lNu/8skT/U=;
	b=W3ykA+l0+PLnvYYIGn2hc5lHhhtCy2HfienDmuceAMOKsu/LJK5iqE1WsLpfzVFLXZDRKH
	WisxGyjG/qJE5l6sRrQ/ElUgHiLLwHXWyrjUbSxu17UV0Yi8CDY7VkMltAeaVQIliE0OaL
	j6HWou9PnqROBai/pFOnsBAYcCEhMg0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AGLXV6He;
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777579016; a=rsa-sha256;
	cv=none;
	b=EoWVWsMhkjF+hpWBziJqLy2wievx4nUKI1WYhUb6l4adlNlUuX47BW/ErqDXzlYhCzMcq2
	wzTPOh+bGS9Z7AFhYFp8k4lzZOUiIhp+ln51asS71qIxVDGj/kMwmLDBhfRRYYdMotYDAL
	YZlbC0n/KyMvWq6N2LGdVFAuhn2DwJU=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48896199cbaso11729295e9.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777579015; x=1778183815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9suyq7OsGoU5hjx6DKCtQZWhNejxcqAH+lNu/8skT/U=;
        b=AGLXV6He5Pria7FIPEjPgNWgBpNEN7j4jEgrImTYcQdGDHy3hEypqlOLB4frcfqccS
         UlytjZ/U7eJEhxmrLtfFH7e9lqZjZgq7hfHqGRQlVl7TtW0gEDP0iU+wo7AtFXJVOP3U
         P2FbBEkC4YNigtmyzuPwvmcY1QJTe8uwX9QZH/QYys9bMSjFznmf4uRt9wiby3McbHD2
         6AsYzaQfmPbZRcy0Z/hIk/fcvrbe3lFPEp2AY6kkFDElj4qJMY6EzAjItyImTPXUnm3A
         12g4nxrMkJZmQGu8Avm0/W4E90XtsUiTfJ+hphSDB7njEDdGoNf+9j2isdGPNM+RReEH
         0pPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777579015; x=1778183815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9suyq7OsGoU5hjx6DKCtQZWhNejxcqAH+lNu/8skT/U=;
        b=NP27xv++j5Pk2khpaT5D16VYHv9esDupcteeCuN+BKW1LPzmKAdNXZQujcHjYpY4Ik
         Ut8cnyeDemEdhDgeZUDG8EcOa4a9EwW9d22N2j8V9LTOdGHKru9Ht+4sGC5fStKwkjh2
         +afxYHGqn3qLNgpDtxsvxvZyRADJMHrYvwwBqqJ5ZEYIasDbPDk5Qz5x/uY/DIS+LLQS
         e1quJONVR+0qEu+VLorDsJ09OhL4hD85pc82kULk/0kcekYdOx3VMSb0GuzZlaOlYyjr
         oVCdJ55PkPjuiRdEq+jchXTIJV+8kdoMF1xRHH3duBjvrc1pkhxWju+fRuQ4cj6r9Qug
         9dhw==
X-Forwarded-Encrypted: i=1; AFNElJ8fsGDHShbZ1nPZ9hCe64WHCfMlX+bIq4fbQrAwYKQky8HMRQvs0YLYnGA23mf6mpJfzcpD1ff27g==@kvack.org
X-Gm-Message-State: AOJu0Yy7jMEp365sDn+BvoezJBA3ndYhvhWSTzChE4/dEHLINh7hdZ6Y
	SWu80bU9ix7/BwNEtppCneRzxKwO0pke1XcSexTIP51XNHTssLkxmJnS
X-Gm-Gg: AeBDievA9eylyj9fNiRaNQgj350jCZLjUe1rs3yFR1u+MEBmzKonMokmo6SDs/s4JU9
	08kf1zSE2iv2LIsi2Z/oT7X5nP/GgYVL043XZbUFu+f/GoAWxNm8CYbJpZ8Xgbc7BUivUDhKHHX
	dnfq+tDSYZH980vVfJzdJrYT4gN+GrSttm7NahYguPwO3pVXOy4THc0DQF56Vfnl5H7C9Y2lyMs
	rxguHijwoqzR5iJSBOhRCIYVvcMn3mZlyqTVka1FiahhlH43dL7cxbBaebJtwtlZOyCMXeaqaon
	+QbNp9LKiD9bfaRYpMu9VgghCuoFUenDlZ4oUCNYDl2aC/3nsQkn7iv5+0zwaBHp7savKFPDc63
	oHNH1cAqul5vV5INBo7uRKJ3pR7NFjzC6gAps1s057qc9Hzm+IdSXmfIOaONomoC1deRTAaLDGI
	o3+GyX2sOiEle25EPu/yCAfpyo3GfE6QtZ6LR2fXqN3LK10ByL7ECsSRMlgxffTjO73YhF9ZJx/
	MvorYzz6zlo8/8wjSaxQw==
X-Received: by 2002:a05:600c:26d2:b0:48a:89d9:a419 with SMTP id 5b1f17b1804b1-48a89d9a46emr28797275e9.11.1777579015006;
        Thu, 30 Apr 2026 12:56:55 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb72184sm922615e9.32.2026.04.30.12.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 12:56:54 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Cc: David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm/swap, PM: hibernate: atomically replace hibernation pin
Date: Thu, 30 Apr 2026 20:56:51 +0100
Message-ID: <20260430195651.287659-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9C8180005
X-Rspam-User: 
X-Stat-Signature: pztqweey3e34t1pknz178mnqzz3nu95h
X-HE-Tag: 1777579016-299816
X-HE-Meta: U2FsdGVkX19rSpE045uJetNnNgtRbBjuHqL9XP0rXbILAvXfoz6/bAy21LlAwGd463k8cBma8UAgLrSrld5gfgbp2w5ZaVnn7gFfB9juQWeSrgRxCa03eDiqPNJ7YbEp62Mg/NagOVfw+SjgvdgBr9idQU2OXcSOz6kNFSXnHDdIvE4hwBZxEHuF3HPfCxGyC+BKpuSheTO5ftCFAabzJPWftCUQcrpMzz9dXcupAF7TgPhsY8+Badg0Qd8OAuaAuugwO8ZRerwPivgU17sfYHA2GyKQwXGbcx3IkGzNFloA0jMtZ2yHg53pfmq5lGaXas98f2S/6L2RjDoOjxVQAXMAVp7Sx5JiR3RM7J1pd7P0Mc6GMgVZWmiyaqD3Rkxah+7wcCHLsr0Vx5/B88NU5b6AU02Vq1QjaO0gxQCGrPSMPRVBoCw1DKrVsqJaqC9wQBWMHvwt/H8iNWfB+MI5olZBm4qHMRY4dDeC/QncbF+bfNesGOFo0QOsDsm0GaJoZ89X3k+mcVjTgq0pUyd73XLwTjzB4n4nF6+dlVuVkiEcX9qFSAoOet6c//6d6tj+6L+f6x2k8czbSyeMje5M2lryhMJ9DtYNwSCPBttfAt1c2eswOmWCZ3JGqr0HFH1OtYambNVu/h/G6aGylsJ1ipnSjJ/fGenLEi+Ea9eyn5nUjX6Isk+tnqXZPwT8c/IC38223UJhZLepzjz+8i3NNdLh1UsBaaOTJyua87mKjP5TqwUJ0n5vhk3ekVQ0u+mvGrZQsSpRLcZQZL2WS5t2GIFIPcXBZRiCPK7pHKn45+FA4JtOSm02oW9d4O6GO0mm8us8tEuAkR1HgOfmSIN2kHsKvmTeifXMFj2kF5j8PhRg7zQBO19dvqhNOrFZJAUQwSErwO/Y6RHP+FrCZoiUPNNTWj9pcbu8ZL2vbIeak8hvlN4AEVRpMA2VP9he4Cy+zGsPk8Vj8NsB2RB5PZ+
 gF1LuBPy
 S7fPDW/hFX+x7AG1uqA7+or36XWmjWynWq/i4KMSsQzpjDUXV4EHu+C/Step0TY1QimgnaTARez7Q6kfpYTVqLJ4A8KqBV1iUHE/Y58D33uymUfWjpRup11re8ia29QHT+wpYg6QjTzxr9TKHz/UqiO6nAZm5Jrnk6/NzQBas8DSPzXQ0/bZK1pWLgbZrowH1laDmcUp7a/SVUoZS3lPGP4qnY7poqG6KsVP+poI3emWi14DOSvpKM+qg9ZIRDOJLMY58HAcXsWjpvvijEc01/OobXS7h/YL8Y8R/y3xr9XVg89Vpw2JFL8RNdVm6M1G7N6aW7mHmR2NlYw5cEvyXz/tXzi87p3NJQ5Zp6lsenG/ERvjex988L6LDz9FUCDaWzxtsQKqbioaaPHWAGWxZU7VZOOEx9FXxvCuWPFFLiQdIdL68B0x6+vIO/gDypuNXZSLqEh4OZCrHnUYsnJ4ID3wpHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

snapshot_set_swap_area() unpins the previously selected swap device
and pins the new one in two separate swap_lock critical sections.
In the gap between them, swapoff() observes SWP_HIBERNATION cleared,
bypasses the guard, and tears down the device, reopening the race
the SWP_HIBERNATION pin was meant to close. The window is reachable
on any SNAPSHOT_SET_SWAP_AREA call after the snapshot device is
opened for hibernation, and on any retry after the resume path's
first selection.

Add repin_hibernation_swap_type(), which looks up the new device,
clears the old SWP_HIBERNATION flag and sets the new one under a
single swap_lock acquisition. The same-device case is short-
circuited so userspace can re-select the same swap area without
tripping WARN_ON_ONCE and -EBUSY. Switch snapshot_set_swap_area()
to the new helper.

A failed lookup now preserves the previous pin instead of dropping
it, so a bad SNAPSHOT_SET_SWAP_AREA leaves the prior selection
intact. The open and release paths keep using
pin_hibernation_swap_type() and unpin_hibernation_swap_type().

The race was identified during AI-assisted review of the
SWP_HIBERNATION pinning series.

Fixes: 8e6e0d845823 ("mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device")
Assisted-by: Codex (gpt-5-codex)
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 include/linux/swap.h |  2 ++
 kernel/power/user.c  | 17 ++++--------
 mm/swapfile.c        | 61 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1930f81e6be4..213ecb627a39 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -436,6 +436,8 @@ static inline long get_nr_swap_pages(void)
 extern void si_swapinfo(struct sysinfo *);
 extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
 extern void unpin_hibernation_swap_type(int type);
+extern int repin_hibernation_swap_type(int old_type, dev_t device,
+                                       sector_t offset);
 extern int find_hibernation_swap_type(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
diff --git a/kernel/power/user.c b/kernel/power/user.c
index d0fcfba7ac23..6e4f40e49319 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -218,6 +218,7 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 {
 	sector_t offset;
 	dev_t swdev;
+	int new_type;
 
 	if (swsusp_swap_in_use())
 		return -EPERM;
@@ -238,19 +239,11 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 		offset = swap_area.offset;
 	}
 
-	/*
-	 * Unpin the swap device if a swap area was already
-	 * set by SNAPSHOT_SET_SWAP_AREA.
-	 */
-	unpin_hibernation_swap_type(data->swap);
+	new_type = repin_hibernation_swap_type(data->swap, swdev, offset);
+	if (new_type < 0)
+		return new_type;
 
-	/*
-	 * User space encodes device types as two-byte values,
-	 * so we need to recode them
-	 */
-	data->swap = pin_hibernation_swap_type(swdev, offset);
-	if (data->swap < 0)
-		return swdev ? -ENODEV : -EINVAL;
+	data->swap = new_type;
 	data->dev = swdev;
 	return 0;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c7e173b93e11..4840fd40f36f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2219,6 +2219,67 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	return type;
 }
 
+/**
+ * repin_hibernation_swap_type - Atomically replace the hibernation pin
+ * @old_type: Swap type currently pinned (or < 0 if none).
+ * @device:   Block device of the new resume image.
+ * @offset:   Offset identifying the new swap area.
+ *
+ * Look up the swap device for @device/@offset and atomically transfer
+ * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
+ * all under a single swap_lock critical section. This closes the
+ * swapoff() window that exists when callers unpin and re-pin in two
+ * separate operations.
+ *
+ * If the new device cannot be located, the existing pin on @old_type
+ * is preserved and an error is returned. If @old_type already refers
+ * to the same swap_info_struct as the new lookup, no flag changes are
+ * made and @old_type is returned.
+ *
+ * Return:
+ * >= 0 on success (new swap type).
+ * -EINVAL if @device is invalid.
+ * -ENODEV if the swap device is not found.
+ * -EBUSY  if the new device is already pinned by another context.
+ */
+int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
+{
+	struct swap_info_struct *old_si, *new_si;
+	int new_type;
+
+	spin_lock(&swap_lock);
+
+	new_type = __find_hibernation_swap_type(device, offset);
+	if (new_type < 0) {
+		spin_unlock(&swap_lock);
+		return new_type;
+	}
+
+	new_si = swap_type_to_info(new_type);
+	if (WARN_ON_ONCE(!new_si)) {
+		spin_unlock(&swap_lock);
+		return -ENODEV;
+	}
+
+	old_si = swap_type_to_info(old_type);
+	if (new_si == old_si) {
+		spin_unlock(&swap_lock);
+		return new_type;
+	}
+
+	if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
+		spin_unlock(&swap_lock);
+		return -EBUSY;
+	}
+
+	if (old_si)
+		old_si->flags &= ~SWP_HIBERNATION;
+	new_si->flags |= SWP_HIBERNATION;
+
+	spin_unlock(&swap_lock);
+	return new_type;
+}
+
 /**
  * unpin_hibernation_swap_type - Unpin the swap device for hibernation
  * @type: Swap type previously returned by pin_hibernation_swap_type()
-- 
2.53.0


