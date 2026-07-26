Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FDE2C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2ED06B0098; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98EF46B009D; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1A46B0099; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9B46B009B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA09CC04FD
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:49 +0000 (UTC)
X-FDA: 85031640498.21.57A692B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 293C120008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWzwtaD8;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087588;
	b=RNlwT9OI/Ljl+A1FHZgxk9NxNufbPkZixtqweosAwSpAXAmjTXqqOrlB+vofOZeIGeXKdj
	QoMcoS/uU8b0QPRD+kpBKyLIB+dRTQFBMQrKQCVHy6i5AV0ZuSwhsCeS1gyLnYZqv9VALk
	4A0VknrstK8NiuiPXhuiyfzEt23X+Vs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWzwtaD8;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZqsFhVwCQ90V1mw7pN7W1WQWqn45B9+8ZoH6zkUunU=;
	b=xluETc491u1nMpKM9ZIXu9b2TDDR5o0/PLcqVCI7/B3O6qkBME0P5DiQI9DAOfoSQF5L7I
	vSuKmR7xIUFRYUVVW5vE477l/0E82qgc+GjBu+6HWHNE0uHGuART2Yx954U9yyl6+xldsf
	YACMVaOovbQKfFr3gkQwKEzPcD5BSg8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B27044E93;
	Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4405B1F00A3A;
	Sun, 26 Jul 2026 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087587;
	bh=FZqsFhVwCQ90V1mw7pN7W1WQWqn45B9+8ZoH6zkUunU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FWzwtaD8K5T3PuAtKXT+W3KgcdnBe+NnyadfyoD71hdZgbFt3Lcuce0G/9reZAqCj
	 VIZIhxDyVNRIkxe2EguG7u08Ur0DoCGiuEigYxcNHUgVlIJPsiBz//9bKs17zxS3ml
	 EJFYpcyPFglNNPf/QLi9LDC5EBNNrepqAMzImdRf9uh9ejFXDSsLak6SxU/XbMbM/e
	 gqC+93TdhmHX4dCWpS/apGKB5ogyKiFIBOZrwzNK1SlS6hExvgjDXiHI/a2ke8TqKt
	 J8k7QbAmmV0lULlwQgQhL0lDd/t0UwzEa3VRy5WhnivUsykw19eINsMcmP5OCDkvIs
	 cklT/Q6pptYow==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 09/17] mm/damon/sysfs: implement preps directory
Date: Sun, 26 Jul 2026 10:39:25 -0700
Message-ID: <20260726173935.94046-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 293C120008
X-Stat-Signature: ikwaxoojmnaioanhkzpykmn9xeod5rt6
X-Rspam-User: 
X-HE-Tag: 1785087588-546742
X-HE-Meta: U2FsdGVkX199fPbNwlmbYOKmeqaqsMXh9vzhJh+xA86Ttrz6+uggTtQr3vUoAub9N+PTtsfMdJPekXRnlKyxZXOWcq0mwi+vUROn13yfUtJ9IQJnRTOoQE1b64Yu842qzFsEZPWtOKFxbV1s322x/xLdvfmsZNIQBdoPRLFVl/PZ265qS4+dlkYtsI7PGus9DK6m9jRBi5I/gTbH1z/Hro2tVuNWCedvXCT+yI/2WLjljEMriAiwa1ZbzJ5huO5HgplVf3LMZH6pQw5Wb4qibaBrVcM0sr7raVt6ceJBAvAsZvLQ5a+7PWxrVqpD7UDNODJOH/DEEP4jtxJFsg9Zv1tLWKjUO1MLBuz3iuZXsCpWY+xdWrSSMFjxylrkbaJ63r/mPo63TP6HZa5BjVR8VvkiyddWVLvLNLHuo2wbQc9evRgr2Wb5MexcdOI7JkhWPYxqaHNlbzfSjQrL41FPkaD+wXuHvGhxueyTzp/z5dCk260q6Yrje3GmYWNeAsRQMQaICafBeIs6zsmgoVmDB8nAZhtDKrq/Arb/YwQh4szNaeL8xZtWS/5xkEjIbkTWtkB+4dQQqN11m5t4D2ZC7cCLHcbN/fXty1e/OOpzFwGPxTVa7bW3FGcqt7t5qhuW5qm48awfROU7czjLb2bmv809opSn046Kr6bC940Krjna6CZd8JMwzWD6kzRZpNsEoh908+7S/tykrWD+E6qdsv+62kRqrOI9AXt0q5piseTFUj7DYop0wkTZ2F3T6T8ex7435g0Esd1IG+xnlL8dVENwSp57HdXxdjYIZINMDkPi/reDOu9YzokwkBo3spJ6+z72sB97iyPQb9j/FLztrKyRndf5l+ydZVjVzCiisYh5jXVHUcjBuhIGijouPq3yKrVcLa4wofl0qN6tgU7maL/AViYuYIhdwWTEOcDeKcZtxl4jOtPVlwggH0xKtih4jWWjwdylRYFLNJ0m9R8
 fPow/t0C
 k0rG+mu1PgxTxM5NXk8OTY1NQy+XioeEjwwlJdjfey8sxtD2XfHk/MsDE5AoSiz9HV6uJ8OomIOkLjiQ6UXScFXMXSFX3SllAGEDzc4/5YbU5uUwXBYc8i5Ll/45KBpbv1ULaeNOzKsnfCFEo3rrOwhVH0JQ2NPYwa3bsOovdD3RX4sLaAwce6Mkb8KSIn9+qfpz+iMzU1fqq02majYQj0lRUvNSAUUmOrpfZG1k/XOePkEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a sysfs directory and a file under the directory that will be
used for setting DAMON probe preps.  Implement only preparatory data
structures and functions.  The code is not really generating the
directories at the moment.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 376c6ecbd4bf3..0e4d7a50545e1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -750,6 +750,74 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 	.default_groups = damon_sysfs_intervals_groups,
 };
 
+/*
+ * preps directory
+ */
+
+struct damon_sysfs_preps {
+	struct kobject kobj;
+	int nr;
+};
+
+static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
+		int nr_preps)
+{
+	preps->nr = nr_preps;
+	return 0;
+}
+
+static ssize_t nr_preps_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_preps *preps = container_of(kobj,
+			struct damon_sysfs_preps, kobj);
+
+	return sysfs_emit(buf, "%d\n", preps->nr);
+}
+
+static ssize_t nr_preps_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_preps *preps;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	preps = container_of(kobj, struct damon_sysfs_preps, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_preps_add_dirs(preps, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
+static void damon_sysfs_preps_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
+}
+
+static struct kobj_attribute damon_sysfs_preps_nr_attr =
+		__ATTR_RW_MODE(nr_preps, 0600);
+
+static struct attribute *damon_sysfs_preps_attrs[] = {
+	&damon_sysfs_preps_nr_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_preps);
+
+const struct kobj_type damon_sysfs_preps_ktype = {
+	.release = damon_sysfs_preps_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_preps_groups,
+};
+
 /*
  * filter directory
  */
-- 
2.47.3

