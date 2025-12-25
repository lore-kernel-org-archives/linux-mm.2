Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446B7E7AD41
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A900D6B009F; Thu, 25 Dec 2025 03:23:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A343D6B00A0; Thu, 25 Dec 2025 03:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967326B00A1; Thu, 25 Dec 2025 03:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 82C696B009F
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:23:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52994BA3A4
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:23:12 +0000 (UTC)
X-FDA: 84257303424.30.D671818
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf15.hostedemail.com (Postfix) with ESMTP id EDEA9A0002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:23:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gGRlztR3;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUNVArIPsex5nogpbUGIxGPpwCyLHHmHwDKuXvJThPk=;
	b=AhXm/YyfzYAndggZIU5exzZ4jvRirCT6XHMI+onW4mNRkc+JzAvcKb1iSHZ1YQz1wHLMZm
	6Ryg90a3EMHCxirm0VpnNfj6/pLberMOs+tR/VmrAaKme9gHMv16RtE0JsQJCustkgT7VM
	uTscLk9RefDOP2UvBXkMo0F7iAGINrk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=gGRlztR3;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650988; a=rsa-sha256;
	cv=none;
	b=4pXqcXjqJ2cjFWnFUYgaWgHCxA6kJeu07j55l2irGP7gn6S9KypVoEkLPEXgwsJmGt7LiI
	WbDiK3GCSsXK1+1+86uKrBWhtJRbM+cQBjGk3Yu8/6fRwSA/cBjAPWFm30hmVFqAeXr5bu
	9tnTaP/tnhphsBGyp5F8XWdl9/3c7tQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650981; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=qUNVArIPsex5nogpbUGIxGPpwCyLHHmHwDKuXvJThPk=;
 b=gGRlztR3UjiRFRm4IOTs+IqU445D+8rupQB8fnJSn0F27FJtLkk0e6UqNNeQx+ybxznj3z
 POqIH/2v4/9JyNSNWr14bEeVbIZ+gcR5xbWe+aQ4pDewjMiPP01objFdxZCgQgw7Zokm04
 uhlsvdbWXiQ8ImsWfVSJMkLGFouYWxv3ulVfreB7UcGNQwdptCUSo520OhEjOuMJSHtpi1
 om+2/SfxBX7S8wa3kVO9hT3Kx4aUtdVE8MIR3XRdlwxOOgeNrmW3A0NAer3bN5dVNIkYdm
 mDwe6KAjRAMWWxx4qb5P7h4npE09KqovlDicdBkOHBdkhYi8Q1P4TSHibQnGww==
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
Subject: [PATCH 8/8] mm/hugetlb: limit event generation frequency of function do_zero_free_notify()
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2694cf463+37a4c0+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Date: Thu, 25 Dec 2025 16:20:59 +0800
Message-Id: <20251225082059.1632-9-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Original-From: lizhe.67@bytedance.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDEA9A0002
X-Stat-Signature: 5z6er64hcau1wh66w6cnkxi38o51jf75
X-HE-Tag: 1766650987-29516
X-HE-Meta: U2FsdGVkX19za2qT8nRiaMSaU7aSnozY/zdGUdETc4eZxLpN0GB77zmWOffBILZhSAEC1Q3sTKrMUSp+TGlmGiOId2LXxbiYuGaflaevHMky/qeuSt3yxMJWhC6apvq8XPZgIXR+Avfk/zFfgMwI+vCoA7tV9bV3r19OwVbUusVVvSYg2mgrSS40/RT8paZzS6GexFt4I6gbtL8rCvsfP4SwiJKme84xfHqSLqoP0wC5zXUb3l4vLZ926/c80T+2BO/z/xlK1JbB5T6gK+I+CG3GQRYK7EBirAVsREsmMQ9UiGB4E4nWniKSacibZhrxKGum6QVWueENtAwRx62ba552kGyB8lwR/ZcBLYHEvn53LLDfQK83rWy2LqtWrxt1qR10X1pDRATQmLKJSG3Y8R9hT7fEgr5lYQi8e1RkU7yWI5lDADVjpSky9QYMbZHOqPdSBdME8DyedOEBZDqTki7qeCevHCeFtsi8OZBGeoTRN2a2jPZP2NIy8I0uHKb3qqWx+JRWkkEyVCnb0ssJUQj+Dlys0y+2nX7fOc8/xEg2G+HiesGVta42R+hBsLSAD36kd6mw6PCh+sLWppLrPKT7OM09bEHMdak8dgJ0qJcNwhjoaX/rx9MRIyBPhkxLY5ikkakdCdzO93DKRkiUCuUjtKZcRepD/rkZKzTgiBoqBxz6DqmRsivrPcA3diYOLnK7W1ZcbBETtKBIDsfFqsC8Xzr+TqGA5jTWInoFzSuP0i0cAgAy5tJHjdqtwV28+LK8yK/Ofdo6VSGuA+AbDE2DJ92hS1QzpMFtDTuXbsQDKW5au3liA9sJb7RzaaI1/ucf/DKMaycDahkxClcJ6Ep+BKg9+oYbqUM+dOZFoJoX5W/H23ocEkRn0zLnVxbNdbSpUQ3GhbDlaCgvk16EMwbWZ5NMAav0ruLNLc1bxgeUohyOK8hxIvo/prD/h91hBBtqMeaqGrF7ScesAjE
 Bs4wlUCj
 RP59ZcY7NZZHae+yrO4U8i6ouSz494pqeCyUqnqdtfNHVc7wFbvipNPU62C3UlY8d5QpMjrz/XLMAc46IDzP3BfylMWKEVrPWd3v36Uo9ehRTkU+v2n/mW0v3EHmEpVD4g/SHpvQxFgH3a7NlmbPwpjZiMpCWE2ZmNzcS1FX5msnwc1UmDbs2h83nadqsG8IQ8eXquwFPHtAyokmO94JeLrHIP0A+i/kBKEP62kzWNEZecqrpf5I9LJxr1XIpRGt2HvFSUoxpbHDb+qsE+QwpCnwQ5Ax4KSbxQXflcOVArS99PQ9MC4c0WQ6xnWUJHA5IxxicnAuXYbIX3sTXz+RjAWfyzowuRCpHbQbr13mcr1Uv6YCdswKjvHWgLgC27rV8nhdxjzWYbQrdkqDxUf23l6PvWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

Throttling notifications reduces the number of scheduling notify_work
making the mechanism far more efficient when huge numbers of huge
folios are freed in rapid succession.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb_sysfs.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index c063237249f6..dd47d48fe910 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -341,6 +341,8 @@ static bool hugetlb_sysfs_initialized __ro_after_init;
 struct node_hstate_item {
 	struct kobject *hstate_kobj;
 	struct work_struct notify_work;
+	unsigned long notified_at;
+	spinlock_t notify_lock;
 };
 
 /*
@@ -364,11 +366,30 @@ static void pre_zero_notify_fun(struct work_struct *work)
 	sysfs_notify(item->hstate_kobj, NULL, "zeroable_hugepages");
 }
 
+static void __do_zero_free_notify(struct node_hstate_item *item)
+{
+	unsigned long last;
+	unsigned long next;
+
+#define PRE_ZERO_NOTIFY_MIN_INTV       DIV_ROUND_UP(HZ, 100)
+	spin_lock(&item->notify_lock);
+	last = item->notified_at;
+	next = last + PRE_ZERO_NOTIFY_MIN_INTV;
+	if (time_in_range(jiffies, last, next)) {
+		spin_unlock(&item->notify_lock);
+		return;
+	}
+	item->notified_at = jiffies;
+	spin_unlock(&item->notify_lock);
+
+	schedule_work(&item->notify_work);
+}
+
 void do_zero_free_notify(struct hstate *h, int nid)
 {
 	struct node_hstate *nhs = &node_hstates[nid];
 
-	schedule_work(&nhs->items[hstate_index(h)].notify_work);
+	__do_zero_free_notify(&nhs->items[hstate_index(h)]);
 }
 
 static ssize_t zeroable_hugepages_show(struct kobject *kobj,
@@ -593,6 +614,8 @@ void hugetlb_register_node(struct node *node)
 			break;
 		}
 		INIT_WORK(&item->notify_work, pre_zero_notify_fun);
+		item->notified_at = jiffies;
+		spin_lock_init(&item->notify_lock);
 	}
 }
 
-- 
2.20.1

