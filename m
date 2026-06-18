Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFC5CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C9C6B0093; Thu, 18 Jun 2026 08:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A544C6B0095; Thu, 18 Jun 2026 08:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9445C6B00A0; Thu, 18 Jun 2026 08:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 647586B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:18:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDF0C4066A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:53 +0000 (UTC)
X-FDA: 84892559346.01.945B623
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 056A740003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:48:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VdHFYtt1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781776132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wr6KFUBUKLmL1HFmRhmGjgD46HcpDVoxGUkNMPoznh4=;
	b=8IhSXB3c/kzdyTOa8lYTh84eFRRZl/QGN6ng+bH6OH1bB/+u5qiZLQjhlI+oLHNczaJIq0
	ExJUCy+gJSJ4RgempBMMlakichVMF650cKNZjk3tgOsT4d5xOlXOrK8pRfLyK1ALLbi+/9
	JB3h8xwUp1AY4aAYDRMRsG3rL/uf8t0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VdHFYtt1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781776132;
	b=SiXjvpEC8kp2eHIivBvVRNOLVOObDlJfTBgyRCIDSEav0qmcTXad7bhqV4yypZ+4DE/8y/
	tOTbScZf95kOpjapP1VMGz0BrtzhEvfI8yBsI0nYJ8busA6lzU6f9cCE7EpaVy5pRAaMv/
	CW9veBOqnpQv/Xn2NxHbBPxYhoo1YWI=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1384eb94d20so1852084c88.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781776131; x=1782380931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wr6KFUBUKLmL1HFmRhmGjgD46HcpDVoxGUkNMPoznh4=;
        b=VdHFYtt1fkRQx6cgkoqFzXtLo78ahZ66QE+xljNkmcg/O4ts1YEZAlIk4ArE8+/Wj1
         /hqwiAhN1kuLVIFcP2y2jU5/yGRskqVLi6kF898ECSsXSz2xycrj5WwMp+9IKWihX+N4
         T4lB49U1/7UhsrNW91cmyAteBiey6brCLgRY8Nzlo0PNbypW6jC2YdrtwyWLJxOh3YUC
         T48x0gMyImp/Ux5D4lLa0GjXxcSx3bP4y6h995C9wwIBTkS8wepHEcY/DSqeNsk9wwnh
         MupUNr2dhOZvdf0Da5g3zzhE7rKgpE/qiV7S5SrgcvpWC26mcpPlOokcctFRFrq8xHvQ
         bU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781776131; x=1782380931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wr6KFUBUKLmL1HFmRhmGjgD46HcpDVoxGUkNMPoznh4=;
        b=JqOo6PU14yPtqfpR07K/LIYkLsdBFRplHPaiHRa0ujm7KXMEfcZwtYrv/LE2fWjbAt
         4qinYnnDotkmfughKLifLyViXo8q5vE2E6z/VSyDlUgNcLYoEUH46mSTSBfpsxvDnkNo
         QJm346HD+UHayoIoOeaWvXQqW0KLlmbImvu9EZOZiZv1IiheqNUAsY4aY7d+tgvF5LvI
         OCMNszCcCJyC8L/1ysLtGdBrTUmflkL/JaJJWqwG1rR5NKUxSpgUqBfMs17z/HvwgcmM
         NsIZQBRfzG6XWQYjMmeq8t4xAt8jEPEbnX5LVwrjO5PjIGMK8ZcHAAMT1TlSCJAqJIy+
         9lfQ==
X-Forwarded-Encrypted: i=1; AFNElJ8L/0Pj7o/OVhtpSQEhrKo+wszoZhz02MC7fLSfKm2uQlOz+1cfN0rGBaqbZtTh4D09dXwVRjY1LA==@kvack.org
X-Gm-Message-State: AOJu0YytBXF2qNkjqGI86OCC9EZCR2exwHeoaEYb0KfVjw7Sdq5WP79C
	LsfgpxNXxCWsd1jPlSP4yZgRrgXt6+WzcycvRUMWrf0LcMp7h0DeDlND
X-Gm-Gg: Acq92OE8ly564YAyl5X3MTuH89gTRIOQ6kjv5GWPzsvn1bpvIhBDMa/un2JOHClL2dL
	7MU8Jb01MNywaty8D4owdCYzBeFPsbKvayY/Hs4D+stgIQWjvG9/s/KIOhFtUfO35XMJu65+W7U
	y0/LR20Qx8S+fy8Xg2M9OxPgI2ba1PDmYCicdfvhozYahP+qOZel2KKC+fBVx0VKEIe/lh4d0Sg
	JgDchs5tesnf5rdPhPfdezzT0hl23OKxQlLu2o6M7me1nd1SGhAGmHVlt8l85esWOhMvMmxNR+k
	1wHIejBQw+I4Vn3Ndnb+0gI5CuJeJz5FT7OU6BFWjMiI8DCaSZqxBCSwCFadg/SCaCwYlhdkp8Q
	i/zuQqOVoTc0Egm6ZYMCAZ4rkQQlRff2KQf+joYJtvhoSZPmzvIOXFTke1xt0f6Z+xqy2Ux57Om
	wVSpuNBjFgnZweqY6PVkmvROAH
X-Received: by 2002:a05:7022:238f:b0:138:14dd:16c6 with SMTP id a92af1059eb24-13997c9a7abmr1977944c88.34.1781776130639;
        Thu, 18 Jun 2026 02:48:50 -0700 (PDT)
Received: from localhost.localdomain ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1384b91a4c7sm18069971c88.8.2026.06.18.02.48.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 02:48:50 -0700 (PDT)
From: Wang Lian <lianux.mm@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: npache@redhat.com,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com
Subject: [RFC PATCH 1/6] mm/damon: add target_order field for DAMOS_COLLAPSE
Date: Thu, 18 Jun 2026 17:48:33 +0800
Message-ID: <20260618094838.32805-2-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260618094838.32805-1-lianux.mm@gmail.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 056A740003
X-Stat-Signature: askqxbwhbc7k95nmzi4sqsrfmktpyt3p
X-HE-Tag: 1781776131-755748
X-HE-Meta: U2FsdGVkX1+l+j3v4fJ7qFBxEBYDq59Ng1xCo5O1RNtjDBBaJqZseQfdGcm8kPOh2Kl0Vp0yes0KaR17/KpktFg6FYHVoNGU3eCH+KO0yghbclswImJ8u782DtqdXh2j2ymuF8g0o5Kl9PvMMilOSB1X76bhDiOVUJRcaZAZ/Sy+K/ThjU/EeA6J1WkXp1U1WFPqh8dFYb7tWZZax/UshiDgl3u+X2NAX1s8oOJk2N1HTogdgNKIB5lU+/bBDfpbI6rRCOCYxTxltSBsHe9akz8Ypb2V5odd28T1XbRk7KeB0l36fRPSJAXSIpltFDOaSk1wQPWHA3dgYxVtm+3JVromZTGKWQzy94iIznmQL55UNVQAWrsxCaZAIJTZUW7diD7LNQrJiqGpDQDewEn01HoJW6L/1E5KcqHCg1+9AKRSZaHC4FlmgFYh8rtiEuKSrSmQvhiI4gZFGJjOhwtZsPiiZtpVuH6TlUk3r/MN6smo9v1DMiWEASq3RhPVtZFSK/QASAVOBaKYfOWZxtWXwmtNu/cSWyQZ041uTaajxwvLGW+RBf4XuBypFLE552cr8KesPKahLamAWf08H/xHiJ4pjzIF3NqWBxDgw+LZhX+DVAeXJMvtK8FxN9UnGHTlPZ42KWrByXpZfyyUi+hCoTyeVRSUJZdAMqhhT9IW+jZNE+Rf7/O8WUx+DdY3V93FTrUpo+9r0HwXjJ6PlZFTDCMAqZY8wrwQHm6ImvJayVWj3pwmt5MvKlo7N5+S9GMhQgqGBGtZqSH8E9Vaxkr2eAE02cgrNvWVuOagocSXHzyFTMUNYJsHYKpesf9In54kx1321k+gZHLe8ITlwWRsu95VzfZAYYAlJiHJyAJ1Ry5oQM4YL1rihIbf0kK6rV0scuvFIkPwlDZvIYXz82uD03Sc2/PuzYklXUyHapI8dxkzZfGbsrECASAT5mV8j5iISvSesWqWDoB6PqbZLbM
 QLw1uxJZ
 1UoVL/oN3H4yt9Omvt2Fr3pgK8VUW0lK406Ew85qDE0nzyhzc7IlOtGV0sMgp251u/Rfg1OCek9RfzUAsLEEaNnrQWEYXW2qSHHk1EnpUnMgMtSPy5cZIl0SwHg3eXtbKXbGtgfkoEvqP6nOnXlT2RRz2qxfdOzaQmspjNhbLXphOLov0E6XmKblADr8uswNISe1QBqRIdD2VsmFsiX/Guo4xaSrjhXwh3fC9Rocg1sPVFclxl3zB/Rb79/zpkLH6PDuKjqD51I3FCELKe8LX56MF3qRGMDhenLL4BAAE2oP8QE64Qd9HM2STxz7d2ez4H9/iXeJr6cG1s+AMcfec/zMJ3wINsVdVhY2JHT96IgOtbxOOp9vjkkrpahd54DFxq3FtytpK2Zf2PsvMmU/UYPBWjjm+QTnBllr9qK+S+bPwoDhMq38GE9wboFXLIiv4uZCxJS5d76bDXNk1Hd+L6cnnjXVVNUgzTuQOsY5B7BctOCbd8uIUh4quUrHRJ9zh5LlVygbMpFuGaI/2SlCd75OW9HlYbqHB2JFoTy92AoO6kpTLGkJfTN/ly1fs637y4ANBkiyIyUXzsrn5ArxgROa9Mpit+UV4I7NfuYAPm1Epv6BM943SymuTJ/tTRTSes3eN+86xLzOdnPOsrQOQ26AbuJ+8sjt/Vare
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS_COLLAPSE currently collapses into PMD-size THP only.  Add a
target_order field to express per-order mTHP collapse intent.  Zero
means system default (PMD order, same as current behavior).  Valid
values are 0 and 2..HPAGE_PMD_ORDER.

Wire up the sysfs interface: a per-scheme rw file "target_order".
Validate at store time that the value is in range, and warn at scheme
creation time if DAMOS_COLLAPSE is used with an unsupported non-PMD
order, resetting to 0.

The actual mTHP application via the khugepaged wrapper will be added
in subsequent patches.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
---
 include/linux/damon.h    |  5 +++++
 mm/damon/sysfs-schemes.c | 45 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6f7edb3590ef..5a0587556573 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -572,6 +572,11 @@ struct damos_migrate_dests {
 struct damos {
 	struct damos_access_pattern pattern;
 	enum damos_action action;
+	/*
+	 * @target_order: target order for mTHP actions (DAMOS_COLLAPSE).
+	 * 0 means system default (PMD order).  Valid: 0, 2..HPAGE_PMD_ORDER.
+	 */
+	unsigned int target_order;
 	unsigned long apply_interval_us;
 /* private: internal use only */
 	/*
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f..735970717048 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -6,7 +6,9 @@
  */
 
 #include <linux/slab.h>
+#include <linux/mm.h>
 #include <linux/numa.h>
+#include <linux/huge_mm.h>
 
 #include "sysfs-common.h"
 
@@ -2257,6 +2259,7 @@ struct damon_sysfs_scheme {
 	struct damon_sysfs_stats *stats;
 	struct damon_sysfs_scheme_regions *tried_regions;
 	int target_nid;
+	unsigned int target_order;
 	struct damos_sysfs_dests *dests;
 };
 
@@ -2642,6 +2645,34 @@ static ssize_t target_nid_store(struct kobject *kobj,
 	return err ? err : count;
 }
 
+static ssize_t target_order_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+
+	return sysfs_emit(buf, "%u\n", scheme->target_order);
+}
+
+static ssize_t target_order_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_scheme *scheme = container_of(kobj,
+			struct damon_sysfs_scheme, kobj);
+	unsigned int val;
+	int err;
+
+	err = kstrtouint(buf, 0, &val);
+	if (err)
+		return err;
+
+	if (val != 0 && (val < 2 || val > HPAGE_PMD_ORDER))
+		return -EINVAL;
+
+	scheme->target_order = val;
+	return count;
+}
+
 static void damon_sysfs_scheme_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_scheme, kobj));
@@ -2656,10 +2687,14 @@ static struct kobj_attribute damon_sysfs_scheme_apply_interval_us_attr =
 static struct kobj_attribute damon_sysfs_scheme_target_nid_attr =
 		__ATTR_RW_MODE(target_nid, 0600);
 
+static struct kobj_attribute damon_sysfs_scheme_target_order_attr =
+		__ATTR_RW_MODE(target_order, 0600);
+
 static struct attribute *damon_sysfs_scheme_attrs[] = {
 	&damon_sysfs_scheme_action_attr.attr,
 	&damon_sysfs_scheme_apply_interval_us_attr.attr,
 	&damon_sysfs_scheme_target_nid_attr.attr,
+	&damon_sysfs_scheme_target_order_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_scheme);
@@ -3005,6 +3040,16 @@ static struct damos *damon_sysfs_mk_scheme(
 	if (!scheme)
 		return NULL;
 
+	if (sysfs_scheme->action == DAMOS_COLLAPSE &&
+	    sysfs_scheme->target_order != 0 &&
+	    sysfs_scheme->target_order != HPAGE_PMD_ORDER) {
+		pr_warn("DAMON collapse: target_order %u not supported, only PMD order (%u) is available. Use 0 or %u.\n",
+			sysfs_scheme->target_order,
+			HPAGE_PMD_ORDER, HPAGE_PMD_ORDER);
+		sysfs_scheme->target_order = 0;
+	}
+	scheme->target_order = sysfs_scheme->target_order;
+
 	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
 	if (err) {
 		damon_destroy_scheme(scheme);
-- 
2.50.1 (Apple Git-155)


