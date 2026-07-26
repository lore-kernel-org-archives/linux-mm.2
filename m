Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E6EC53200
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB576B00A0; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3666B009D; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9684A6B00A3; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0A66B009D
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CFEC8054E
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:50 +0000 (UTC)
X-FDA: 85031640540.14.F014A2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8E14160009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMoqbUJr;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sG7v9QjVN/SIQic4/p3WnUFMpqViqsUPqy3peyL9No=;
	b=mZZfueVg/ucGTLFios9vXWJCY9AupeylOfuN7LUohsB7RGsKdOQA+x6bHwBkGOzMdvUeH5
	hLUGmPvfI81gqJnpxNNwZM7B37r/QFS8tbQEcWN3cYSQImJLBKCsFEnfd6bALCOPK701Xh
	qg/SbCwbzwoe82hxMWrlfqFcR8hNzAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087589;
	b=Nu+bEi/dYYgROxohn/TE7JSdOczlUm9t7a+G1rn3MrERZJSi3pM789oo65W+tfn9ZgeHT3
	cJWs9HKbs6RMfiOixoXZF9G4rHhltlnT2nPZsSc5xn0KJneyCydBP/U3FV7LVO2vjD213N
	kxe0vtSxKAgoFIsLGuiCP6pPA2RxLxA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMoqbUJr;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33505450D6;
	Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28101F00ACF;
	Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087588;
	bh=+sG7v9QjVN/SIQic4/p3WnUFMpqViqsUPqy3peyL9No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMoqbUJrzk2A7ET22ybfkRlQAv27xty8qK/utLpNogv4PXtneHfbWrkxHRqHp9rk7
	 mUb/95bx6TeZyekyAgb48ZXfybK55vmLlNyPgEfw6BJamenN8PpPWtGeYKGWbFRyDH
	 08Q9bMXLyO1a+lYqHAmnEAioLSqqwnnB4wuhLygYYIprlEzpccbCqpJOP35HkJG1vR
	 L7uZpADib/u15jNK5eOib7CH88T+Neo0FfAAoMkajX+sT6r6ZCkrnzkP7qORwgFMfw
	 ZiFSL2nSpVCoieHVPsx2VeJHcyKMhxJ26OZPiPioRqIzqv5DjGCvvNNAu/KG4UF5IF
	 wbbxrsg6eizmA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 11/17] mm/damon/sysfs: implement probe prep directory
Date: Sun, 26 Jul 2026 10:39:27 -0700
Message-ID: <20260726173935.94046-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8E14160009
X-Stat-Signature: cbz1wuwu74fsadftfnrftq59skckbj8u
X-HE-Tag: 1785087588-439385
X-HE-Meta: U2FsdGVkX1/1kM0LKvEmqfhTsHDuOfN+V2Esj5IEDcwyHjeRzfxzrAfJhc6wlSoggAr7MYIkLt+3XFjOqMBTtWkoh3htS4uGp/mjLXbM5xFDfypGrLuJhNyGU04bLBnkYtnU/JfDmCmlCcwdvfw79XlffqFYHZc5luJxmwiZanWLM3zIUV5j8KEkEweiU+TOUfu3Re9q41VBWrTU9ihQAmXUvgp5Vzqd5d+yaRsQJkAd0PdQwk4gIp40M+KVzcDsPerNhFUDForjO+tEp1UM3gwwxIZ+3jac+yMrr2rpSbkxJd0vgGUhWARSFYHxuwHfF1uTemH1ne4GHYtTzhn23DjSvRmWandlG53iIllMeyHSny5sUrc0apQ1/sP4IAxUg4fwT05BnxUZied+OkT96QvizK31z93L1Vy4SS7FR0JQXBPz7TuWT0A4ujAhzFXLSA/mgHVX6LDH406xnKeu+UD8pTzWnSYuCozgElgLIOWs/yT7YQIfF8Rv89/q75o7zq6eV0ICP4IyvCKRE4pbLIcGCLDCUCDDefR8QrCsULEhFj/mjjPxH02Apc1ZErYx8YAL6SyefCsskPyZD8b7eyuTLydOcQYgGmT7zY6+qhvNntdMgrAat/MUpHKj4IiahJWXb9tFl9tg4PKslMLaIFGN1qs29M5MMQkk9ylswmYe3cXcBRQLG1SHxie2bMZ6pdmiQi8niYzsXAr0JsD6UsteNbUscq4yu0F9OQcssDFlF6A5/EnHzz0owzPd2XOjxQggPOxbbhiMEzCSNvd198aUdD9L5y7VKm0uA+z8GfMkXXQzcuK+gjGayd9DAdFLtZDOpa//vYvXEop2bMxXSjx7bbAuC3FvH52QL6hwHcgT7sBD7tLwQotX5+dGtG54UFqXfDN9iFykhiumgJ0Mg/GByI3vilG5uhQkhJAmp6UhIwlyfpCQpGYWR9gnwUuc8/t7+YRDsEJM6TBcbb8
 JNAbPGFw
 sHj/qq+BERig2Wb6Jcd6+xAH+m3rrLhdpuYGb/RKXA+HG9LqGasdSN+pe5JtaNSJu98/ZqOl3KBEK2IQBCuBWstqcd6NnGnQqo6I+Z59YmIS0CpuzoiT+OtvFbcBKuFdGAsd8yUEw6uTfQV0tMuWp1KbU0TYhoGjSvOyyIipJ4BbpctkdWTeoBin5AOz3v4YgJusMeh0C/ObWZGfncUiayYkASSOhWgvNde5KpILwkwvie4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement DAMON sysfs directory and files for specifying each probe prep
action.  Introduce only preparatory data structure and functions.  The
files are not really being created under the sysfs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 6d3ed80fb2eb1..e348c1feed1ad 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,6 +750,89 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * prep directory
+ */
+
+struct damon_sysfs_prep {
+	struct kobject kobj;
+	enum damon_prep_action action;
+};
+
+struct damon_sysfs_prep_action_name {
+	enum damon_prep_action action;
+	char *name;
+};
+
+static const struct damon_sysfs_prep_action_name
+damon_sysfs_prep_action_names[] = {
+	{
+		.action = DAMON_PREP_SET_PGIDLE,
+		.name = "set_pgidle",
+	},
+};
+
+static ssize_t prep_action_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (action_name->action == prep->action)
+			return sysfs_emit(buf, "%s\n", action_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t prep_action_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (sysfs_streq(buf, action_name->name)) {
+			prep->action = action_name->action;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
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
+static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
+		__ATTR_RW_MODE(prep_action, 0600);
+
+static struct attribute *damon_sysfs_prep_attrs[] = {
+	&damon_sysfs_prep_prep_action_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_prep);
+
+const struct kobj_type damon_sysfs_prep_ktype = {
+	.release = damon_sysfs_prep_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_prep_groups,
+};
+
 /*
  * preps directory
  */
-- 
2.47.3

