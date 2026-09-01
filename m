Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00CEC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBDC6B01A1; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35AB6B01A0; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9618C6B019E; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD116B018D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05E541203CE
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:21 +0000 (UTC)
X-FDA: 85165264842.23.43FD542
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6923480002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y544UEmq;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269119;
	b=oAxg74oq7Da4mCgW9ksBKRwjEwf4XBWDx4yPl+ttVsPY7Yjcx6UClKtFxuDYirY6cYtjk3
	q5DuyI0/BpqCI2pNfKiTBNvr7TjIBpSW1AD8r1Na964Uut2f04HL2bP4DRnB05sAzYvKxK
	TkMrQNiO4ojv/ZEIaqwLdA4qSi3v0R4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y544UEmq;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qO65UFbEI2bWLHkGPNlwAeuwDLu8u+FPN4dY2StdWwY=;
	b=qn9d8UpKJXw+UfJn7JGzIZHmndQo5d+grAHzTphbceK8hiQ0MKNalFTyLB1tVo1XxF9Id9
	v+U91nJ9vsqVu+EcMB4TJ1Loea5agQqBogmRDvFZFudISaQaofgQY1T+ACm05DhmA876kh
	K4rWQrRAJSGEIicPTIWV08WsV0hMFs8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B271942A18;
	Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756FD1F00ADB;
	Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269118;
	bh=qO65UFbEI2bWLHkGPNlwAeuwDLu8u+FPN4dY2StdWwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y544UEmq06y/QuPkg4cwMuzTkvT0xLjiH7VHdCY41q6jOU7ysLzVAILlNrAV7l6vB
	 UXCVYm93Z06PvFaEvKHOLM0mi2nhEzxXmfg7koG8s/9awE/NowsvFFN6v2wqToyxFL
	 sy8gfetg4+mT1drXFg36fLanBWDahKCZRZ+ujuufDWyQItllffscpI8xb8tA32opVJ
	 bOABpNPLTRO/mGN1AkJOXItHmAD/CYQUWyGK7bFFOsj/7lbTK/9iDfXFvszvSErfGG
	 UGcdpk0YbcXF32RntmwUntJelDBrP/U6NDEwISl7eIexUYtVDeuCfZhoXODscaWIjG
	 TjMioLPgQTPHA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 11/17] mm/damon/sysfs: create directories for nr_preps writes
Date: Tue,  1 Sep 2026 06:24:58 -0700
Message-ID: <20260901132506.99243-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wokisupxcmwwk9ctqqopnsdhxbkojykk
X-Rspamd-Queue-Id: 6923480002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788269119-398338
X-HE-Meta: U2FsdGVkX1+TqohcDB+bCUwgYBTJnMqocZP4rMH3SjujJM+qRIZKSYFnsgfyHh2PQ5qVF8tRXAT5cRBq2Ei/ckMQ+3eTucY/JPOJeDv+uV12he0yY2pr0XxWaOdRPF4EzJ1r/Zc3EokRZF1l31ku/fYGvrMJjotyPfoZlzmZ87EuAVXKYOHWdYXiZwBrv30pXVl4ejRBn1thEBEZkvBcDyRJBGBAQi/vZ8r6gFWoimhHvwjipJo1lzd53h3tqSnNGr7m1GotTlwzSACyYNk7BLyyntiGZRaHqUmQed7TOrZOcxxteCG5nYMgxcSjPpeh+8yazfcopC2c16hfVCOQ4ELesOUycOAYz1Er1b8Zz5LWFxJA6UY0xrMn9lr90lGoN7b1+Ikmtr0UjWnN20v969UwE3/w1RWbBgIPZTS6+2Dilj3uBbURxkYSQD6LMdM/o4SHoSedBf5k/LhJ899wFTVOnNgoCvQ9cG4zaytBpn7wG7Va4aicD/QyLXGZ6/JYbt9yAZNpA9ASJn1N5bQS/tnX0AsXhg7xwjT3GRUDZmyEcI6gv7lVJp4YAj1JGqeiXNpUGigjS4Xnub/cgrFoaPVMiDBD82wrJPLvWINZmnrFdXdJntrX4ai33o20D6kSxz92zpJe8OD627SK3V70nlvzwWPY+nlvnk3QHS0yKnXz7ANbMQiTVhr/1eX1G3fdQgU9kHCuww2TJJhwazLfbOiMnWtEljEp3F9PJc6aZQ+V4SclMMFZitKxqQDwrUliuqPaeZ0jcT71G3XyDl0q2MskMr1jKLXT4Y9s1oIdtabdjaGTsHL6Rz7COut4HPQtJSaPD4RZq/HfTz5UPY2fUPXZkOOPGgL3Z/RhsGzhRwTwu0puKSZPey/PcY2OuI5BsEWTgFzgcRJVEMNjcRPrcbX9FBl/A+Xg4a7I+XDGmJNjgLRgHP0CU66XLJ/7AmOGtzaijrFzRR3NiWeYUVi
 D5jwcHKZ
 sET0JKKPw2lI2mWMhLWQoRsqsuUP7A7trmutG8MpqXUYbtzK1rYrze5h9t0UbNBUD2L+aWdfOUO2Abw13sZQJvJEJsV2C5kXWqsCaTUN9ro1lZsKhaQl+8CbmyLth4LsAKU3IMi3YJ2qHuWqWKyYbCWVw3Uw9sTZBkSA4mXjoDL5VSdaG0oQoJBqwCg8QOoR1EsLD2zgZn2/IN0gPx/vbVdVdue2Z/TVki20EU94gRIOm0mJ5tYgZK6aRtQfV4LA0yuj4B/XnH6fYNf3zkK+tizYZwoAZjvUMxXKWxre/ZhcwSwlMEl4486UT1gIUcViQ7ClZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement nr_preps write action to actually create subdirectories of the
number.  Each of the directory will be evolved to represent each probe
preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1d2d9950716e1..3749abb781566 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -749,12 +749,50 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * prep directory
+ */
+
+struct damon_sysfs_prep {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
+{
+	struct damon_sysfs_prep *prep;
+
+	prep = kzalloc_obj(struct damon_sysfs_prep);
+	if (!prep)
+		return prep;
+	return prep;
+}
+
+static void damon_sysfs_prep_release(struct kobject *kobj)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+
+	kfree(prep);
+}
+
+static struct attribute *damon_sysfs_prep_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_prep);
+
+static const struct kobj_type damon_sysfs_prep_ktype = {
+	.release = damon_sysfs_prep_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_prep_groups,
+};
+
 /*
  * preps directory
  */
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	struct damon_sysfs_prep **preps_arr;
 	int nr;
 };
 
@@ -765,13 +803,53 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 
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

