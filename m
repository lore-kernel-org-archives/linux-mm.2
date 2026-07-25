Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60223C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D9D6B0098; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7916B009F; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E23D6B0098; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 320096B0099
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9ED8CA13D3
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
X-FDA: 85028522880.03.92E7093
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 278C740002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TBKBsr0m;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmA3iKd/w3WhYo4qwFeV2q0iE2mBXogisOL0j6VtBhc=;
	b=r3hBOHPNC1TQ6pdn+il2T1h1VVRW4IExwJZllgzSUJ2sqFOEy2IuRUvuwCkjt4sC6hbARC
	O/ediWNvBkSg1SDMiPFtqgApY/U3tFHMpUyxZwN2Zq3VDf2PTfeUI1VPQq/pjKcOVvrzW2
	fqrf0fw+lzciNK7gyV8s6dDuc7MEU4Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TBKBsr0m;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013359;
	b=xDMd8wz9VpKQc4FeWCthSnuUweVJOvw+4hTIrAqu3YM6+YHrVtY+7tBCUKJv5CsmrFecYe
	Q9X+/PB1nUj4HN6lyYAFArItgWQsCr1qKg6GRgdwMaf2TUpMzD466ksiz2wfoewVnuHRCX
	HMR78CA1HZSvEzl+M7l6POUQ2WKPVrc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0AED60A96;
	Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832F61F00ACA;
	Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013358;
	bh=LmA3iKd/w3WhYo4qwFeV2q0iE2mBXogisOL0j6VtBhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBKBsr0m37fHqDZv+bnQf0ZwWA0bMy5FfmqnyQ4nY0BSsjNvPa0UkKiBBJ8BtOaQF
	 2VPEAvztnLfYZRBsL1BxAqN9+VDKXe/smRPl/eZaFS5BSQsEl5y58ZoG++7evSp9pF
	 aCHsFkxQDEEVTsRTarEIPQQpYjefLIEKRlmlAIrQK82LQkDB3wUUc4YA6e5Ec5vdSH
	 yT66FY989zM3jIcbfkgzhlG6KxmS1WU/zEDtnfECbbSD1tmWa04KtykNj6FAykIeUK
	 7/q4iGI/3sDBYN4SIf3GTpHPLvdD9vGNSJZLbaeIyj5LnF3/xv56M2Lb1pa/IWWGUP
	 njXiLjA7GE4Vg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 12/17] mm/damon/sysfs: create probe prep files for preps/nr file write
Date: Sat, 25 Jul 2026 14:02:16 -0700
Message-ID: <20260725210225.129944-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 278C740002
X-Stat-Signature: fseeiago66z1yos1hmittk4jwo53obwk
X-HE-Tag: 1785013359-151444
X-HE-Meta: U2FsdGVkX1//7OlspUHIZAu3vkJWwnGNNVd3GZaLMTBmiG7AVljt+mnoh8Y7Wl1ONXg5ZWjJdqSCUwJnwn3vTY47rhryVcAbmgZfN1kkcFOMswL2W0kIu/TdnCFwrlhnPD+FbSxrIfbwwAHX79Xk5cV2Ouej4Dv9R5V69RdsYW8f7HnE0zv8wigb/wM08WOWynzGbEMD7ZP7TV75YEQSLFSAFw/uleHiXHENEIHEJE66Tbd/m6gMBWe0Oslgf2UUYodAzV4lPX5Iv3ONkH6c8xGH2mEUoXy6USc4Nu8JeTwD8cRDPVwpQmFhNSvgQ+v0jLWjDxwV+iyr22zHEwQhI4bLQBynar+WqtpcPf4LHnhgV0/ulDzzLPc9c0crkjtauzMmSRHloftZowWB9RXUZ82OpX71OHJwOXSpPHS3BO6ds2XnWmpPUToS3xiB95B82H8ztqxAoTf8K7wyElzhytTKQ3usO5kZDge3GozLcTJvZEFmzavLXEXDdLRkK+v22+gDikY6GXuOc3DhB2xEOOgMs+uYtjWIKbJQfwIKIMTB4oMi3FEeH8jrm0U110Zncr1oEDykaUCOus8OEJ0Y9JqKutfkYSI82As+FnyBGuvAuyiGYlHEhhd36j4Qpa7U3kToshcee8NlYFAWCRJrlMuvgCkzcuWwbEYRDx0tBzytPL3IKvtOSKfBYsaIXtIQVJY6eDUMyDPZRAyAk+CbCaZ52TkFBKrdiNL4OdYHGTC+sDbseQb4rdejT/UaQWd9TtyPB/4yKOTDxW0OUy4812yP7kdSEoZBve5HQNx+ytRLGAo0KF+qxqK5Z9nASJhdijo5Jg3gRmkzV7LfJ51TlCB8qaa0IsYbU1KJLblwnEZ01eKYozXGcxfezur6LMzeLpfWRQf4pVz6bknZa98X5IrUVkApcr2b1hoaMHdcWplIGHzShrQukvPHkUaZO8z7FwK2H2BkViBD85qsAAm
 jghkpLgF
 9/uUQ2TDt+K1ColevmkX2fFPh3HGZXBQh7bpg/Fn04NzxFXwJm57YglH9JF+nuZG1alhPsQyIy5QVLCFahxg+TWDFAVVpbgXws2ooXTYrJ/H52JKW7ZBnEnZ7GfLLOoYTSElwHTRtf6DVYYdPGEn5O0tfaqOI1b1gFdI3LIcUjTGTuZnYTAB9cYXZ9yOBILFINg8mawxi0qi+t+V2HP+rqqLK5LYxuH1ptOF/1zt6U06P/xuM87rFzyvFy8nLlC1+tX5OaGsklax0SeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement preps/nr file write operation to really create the probe prep
directories and their files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b15ec082109b7..f275a6f73eee1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -759,6 +759,17 @@ struct damon_sysfs_prep {
 	enum damon_prep_action action;
 };
 
+static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
+{
+	struct damon_sysfs_prep *prep;
+
+	prep = kzalloc_obj(struct damon_sysfs_prep);
+	if (!prep)
+		return prep;
+	prep->action = DAMON_PREP_SET_PGIDLE;
+	return prep;
+}
+
 struct damon_sysfs_prep_action_name {
 	enum damon_prep_action action;
 	char *name;
@@ -839,6 +850,7 @@ static const struct kobj_type damon_sysfs_prep_ktype = {
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	struct damon_sysfs_prep **preps_arr;
 	int nr;
 };
 
@@ -849,13 +861,53 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 
 static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
 {
+	struct damon_sysfs_prep **preps_arr = preps->preps_arr;
+	int i;
+
+	for (i = 0; i < preps->nr; i++) {
+		kobject_del(&preps_arr[i]->kobj);
+		kobject_put(&preps_arr[i]->kobj);
+	}
 	preps->nr = 0;
+	kfree(preps_arr);
+	preps->preps_arr = NULL;
 }
 
 static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
 		int nr_preps)
 {
-	preps->nr = nr_preps;
+	struct damon_sysfs_prep **preps_arr, *prep;
+	int err, i;
+
+	damon_sysfs_preps_rm_dirs(preps);
+	if (!nr_preps)
+		return 0;
+
+	preps_arr = kmalloc_objs(*preps_arr, nr_preps,
+				   GFP_KERNEL | __GFP_NOWARN);
+	if (!preps_arr)
+		return -ENOMEM;
+	preps->preps_arr = preps_arr;
+
+	for (i = 0; i < nr_preps; i++) {
+		prep = damon_sysfs_prep_alloc();
+		if (!prep) {
+			damon_sysfs_preps_rm_dirs(preps);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&prep->kobj,
+				&damon_sysfs_prep_ktype, &preps->kobj, "%d",
+				i);
+		if (err) {
+			kobject_put(&prep->kobj);
+			damon_sysfs_preps_rm_dirs(preps);
+			return err;
+		}
+
+		preps_arr[i] = prep;
+		preps->nr++;
+	}
 	return 0;
 }
 
-- 
2.47.3

