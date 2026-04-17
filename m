Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F5CF436B7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2EC6B0125; Fri, 17 Apr 2026 11:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A5B6B0127; Fri, 17 Apr 2026 11:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42126B0128; Fri, 17 Apr 2026 11:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B11756B0125
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:47:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FCE913A1C7
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:47:02 +0000 (UTC)
X-FDA: 84668476284.13.1AD32DF
Received: from mail-m82141.xmail.ntesmail.com (mail-m82141.xmail.ntesmail.com [156.224.82.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id 088B5A0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:46:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.141 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776440820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NGRBYnC0KiR/HMDYQoWZ87cRLJinzLL8/LyR/WV07uA=;
	b=FO1DsU3JTnBDKhjV1ynfvok/A+WEfohfW67BiIpCWPQZIoKEeYKo1eWZUIYgNIzqKKpBQr
	AqG3Hct2njTof08bK4tk3C7rCvhKd3RJH7UwoM1nAfnBYzCqf/zRtLqNcOJFf6afS90ZIF
	XJPrQrIC4mjYVAkkjATcqskUUwEP1I0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776440820; a=rsa-sha256;
	cv=none;
	b=yAsWp65ZEGtr/ZjBAaNPBnQU01H8IHunV0AGTGcZKg1ql7iepip7jVBXkBvpQ6YgsGxi1U
	pxByQ9doyyXvvAKBQDHA6efXga7SKEMRYOtt8qTF4Eh88hJs2ZRXc/8dOsdgwJ5ldKzt1k
	y+m58VbYA1ta+UENRDhIJABc7NduyaE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.141 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 190e229fb;
	Fri, 17 Apr 2026 23:46:54 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH 3/3] mm/page_owner: add NUMA node filter
Date: Fri, 17 Apr 2026 23:46:38 +0800
Message-Id: <20260417154638.22370-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260417154638.22370-1-zhen.ni@easystack.cn>
References: <20260417154638.22370-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d9c1fa9ff0229kunm7c3615e318e5ad
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaSU1NVhhIQk1DTEtNTRgaHVYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspamd-Queue-Id: 088B5A0004
X-Rspamd-Server: rspam07
X-Stat-Signature: a7oiu6zqfx55rxa7bjaqswom9ig9qb8c
X-Rspam-User: 
X-HE-Tag: 1776440819-7069
X-HE-Meta: U2FsdGVkX19a8oUFaeWtMuRsfenaux/RcSJ4GgbM/L24vTzlGLEBowLtLen/xuZDbKgS+u0cbq+6pn6oX8wuF+xjj1aYEIHuDoBglfdqxOOFtio5GD7Rm5FkHrRgPh0PPtS+VSlVKWZtT9Flosm6ml7+hUQzCyQ/sOEJQgXAki8b0VcpK7Uk6c3dwGri0Mb3GsO2xABdocjd/z0xy8f/xkU4UwAAIgwNuifcKpaF48HLeuwb9fhWcU36HHNSEHokM9uTXuZHVYcKjJMSErqR1MNzVHV1pDADZyI9gCZepWoR/HW4h9ugbjVDMH0g/yfQ8oirxO8r5LNj6NVJUWO7YBhQjme2uuRSkBCVcqIGzfbjCV2s+e84nkxypTZN6CgdBYc2fPicvYRinWadMCHzXoc2NCowjSFUqomFjj7tUfFXH4wvTz52OabsjCvfFlwGQIQ1qicz/+KX+U9JikZN9uEprf0mi4BfhclwnIhoT7JB/Yar7GAyW2JmJF3iRCItnYls/rFBdtp7lvVz/5l8wFW9uMOW27EnYyr1CFWtVpL5tGIFRKEeaWz3CKCvlXnUD4nWnAZqp3h9n4APVRnrXRWUM/CktnBv20A1IRg6UyhESZtYv0Lf3bCl3rWAuDTYrFPqFqJnjhUrnT7mknZNBcznVsoNDBjFpvguu5VNcbBO94K2LJNOvXY0yC5tpzm9njFb6hoqnvcyipnbUBrQOnVYMI0dzp2HsFF7tSgQq4mp4ewvPc524RtQLR1HQskAsBXUkU31m8Mg2DcIXRYFdyTbZ8rTPk11TPSVpK2Av+YWLujGDXfTwTfpS2+MGNqh8l95yUGIbVFWNeI90Ymf4mBV5kCkXqrYZhPJec+hCyZM5bIxzV+oxdBPxJmbjKlgx/+S2QtLN2Q+LeKkgjQ1txAkk44id1v6e+Wk2HUguuIexeGgDSDYAsk7xtrRey+TgycuUrohyVUjq5Hq/cK
 DNYYVCyg
 MqEYU/N95k5e/OpJh/i8zvqEiKBb7msuXgRLIjakc4HAwmdFUUX+ObLgDwcndZnZMojGMkq0sK+McVfINN7qN9Uc3f1O0+lHTtglfPmBgyT75/ZhWrquHXKwpJfaVpvF9drw6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add NUMA node filtering functionality to page_owner to allow
filtering pages by specific NUMA node.

The filter allows users to focus on pages from a specific NUMA node,
which is useful for NUMA-aware memory allocation analysis and debugging.
Setting nid to -1 disables filtering (default behavior).

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/page_owner.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 214b58eef3d8..ebc29f3f516d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -726,6 +726,13 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (unlikely(!page_ext))
 			continue;
 
+		if (READ_ONCE(owner_filter.nid) >= 0) {
+			int nid = page_to_nid(page);
+
+			if (nid != READ_ONCE(owner_filter.nid))
+				goto ext_put_continue;
+		}
+
 		/*
 		 * Some pages could be missed by concurrent allocation or free,
 		 * because we don't hold the zone lock.
@@ -987,6 +994,24 @@ static int page_owner_threshold_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
+static int page_owner_nid_filter_get(void *data, u64 *val)
+{
+	*val = READ_ONCE(owner_filter.nid);
+	return 0;
+}
+
+static int page_owner_nid_filter_set(void *data, u64 val)
+{
+	if (val >= MAX_NUMNODES && val != (u64)-1)
+		return -EINVAL;
+	WRITE_ONCE(owner_filter.nid, val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(page_owner_nid_filter_fops,
+			&page_owner_nid_filter_get,
+			&page_owner_nid_filter_set, "%lld");
+
 static int page_owner_compact_get(void *data, u64 *val)
 {
 	*val = READ_ONCE(owner_filter.compact);
@@ -1018,6 +1043,8 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
 
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &page_owner_nid_filter_fops);
 	debugfs_create_file("compact", 0600, filter_dir, NULL,
 			    &page_owner_compact_fops);
 
-- 
2.20.1


