Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F5A606C420
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bDYv5s3x
Received: by kanga.kvack.org (Postfix)
	id 243526B05BB; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A786B05BA; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131FA6B05BD; Sun, 15 Nov 2026 15:29:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D558C6B05BA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4301D8083B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
X-FDA: 85438492692.27.CDD3414
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 91B4C40005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDYv5s3x;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774544;
	b=YB+U2g/7rdAwt7FW7uPfZ3Aw6wmm0N2mkD7bg2nYVAOKH+GeTO9UWG4YVS629GBXY1HPnY
	a71ZgPc4tV9iEWLYYim5MudSLNRguXqkH6yjPUPFDwYpnoH1/opP9eL7gKHRBnL2FDDvmr
	hLdxzxhnThg+QppSkKw9llPZLrk3s3U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDYv5s3x;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5c6monTkHFptnJUFGVWxm0WfYIjXGBI118GDWY/b424=;
	b=Mb0cHyvGryRdh24juVqD6Lfo1MHuRYNXitJVFW5PZzcb5IIzL6roHOPuEvjEVNGwJBHPRN
	3cKz8Q0ZG/GabwZYTPHFEla2GXAHOxuPQ5Zno8wrf49xojNxi1FqWx69CozMtsmKuSxMZz
	dBh1iJVjZehXZvSEncEsKm1/AWhOOMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E372043D4D;
	Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43A31F000C4;
	Sun, 15 Nov 2026 20:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774543;
	bh=5c6monTkHFptnJUFGVWxm0WfYIjXGBI118GDWY/b424=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDYv5s3xbVH+cAMBWN79DdYCzSB1wVAZmOj53dHrzr5tNpMNBN8VMPY/t/DEKrB+Y
	 hRb2v0BwOAudikrb9NOLGgDn7KSP6tU8HwzKzjvqNFMugk9iWRxAduZoT2mKJyeU9k
	 +JPPgRRCxeOLge5Z+hRVNqQ1JyMROQWRu0kvbBcib8nlf7MpgbASGKZFAxuKsUo2Tb
	 dH3uO12QBC+BEomWN/1FPZMMAeGacQcogy/XnDw7k1tXJVzVwjXKv4+iFlVaTC3B72
	 fzduUMIihIzqRmwvxGjwER2CpCBEpxYQGHTuQZSyG01kExlmKkf2q/wH2yiCAz+IWh
	 ZUerOJnoJge0Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/27] mm/damon/sysfs: add admin/reports/ directory
Date: Sun, 15 Nov 2026 12:28:22 -0800
Message-ID: <20261115202849.99134-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: axtufx64kraq65yz8gfkapg9r3s5b4ue
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91B4C40005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774544-48017
X-HE-Meta: U2FsdGVkX1/EYMKq10WGWYavSTkJfJod4N8Sikei+Fb+J2KyDu6fQbPUl8mtJx11me0gHgu9sdyDprROtSaUl6LRhmFS6BryTxefAesvlPI48LrJmgrdRvLKobvrqOSKmJibKgaeL1rBPpGjWwSbvRGqFomQVda0Y7YtWia4vCu+AjAxDJ8yWnVSTvTHywyA7NPisRnzklPJFm7Kz+GlEatUTENtNJvIRZCAnkCeJsAziRn9GjAfTIrDp3R73FZyy8VjpVreQcsD8Yyydh9pF9n9OMNVhv3gP0BcZ05RWwSedOMj/j/VLrPffj50uSrFt1mGP7HLGqous+HlwqCfXvxZFkkDnr3Bv9eLkryb7MSnR7UQgYL6FGMAbYne47QyeIdDiqAB4890IYYIoPHUkffsSP73f+tOpYLg1qK9c9gd+ON67UGLgjeZXXQjh1jslni2J/x7TF9mIddobDLzhtxmqiqWbhkUC+ZZXZmdBWwjM7YgRmAwX7rTzcg4/mO+Ko/C2fcNgsWrZVkqk+3lrFbDUu0CBvr1Z6rfHvmjwyQZZlJXRlDKnw09pvoyRo2khiqe40enkKcRKoJdFnMw6ZgurRubPciggAEYXraltsFof1WCEiQYs2HuQq+zvjxyU4WvpziRY9SHA6dPKWJgrG6y8Vcxcxc++Eb5EBrekCTnDH9Xba6O+gdmxkJAiSx/bIL1yGiDz01vVo5kKenQcSSIyLd/1VIwiJ2kUrn1YZSqML0bmG/1a5/+vg44r05VVnEPKqwcniflFit5f4S3IA1fL8qEFaKyDjB7aOH0CyA1UBtupP0BXzpvAmNePjzzZNx66LB4yFxds7ojyZ7EA+I1bwCw9rreh8+AVdTLEEI1SKCuSGm8ojZwfRs4k3Ot80Zqom+huO4g3PhcDlcqQULv49/7CwL+NPJJyv52cKtaXYVzpeqEwVHdte6rR2PqUCtrC/MDjxXUa1w5Mi6
 Pm0MuiM3
 Oq+rBXljLhApraFVHZh7dMk9n0Th6luEkhDh8ecYruDZfeLbYynVkJB5oZYtfewIFvPRo899BFVNqikEkOXH/dFT0ZQ0RQa9RxTiBO+Ml7ufVtRi7AgOfzGc3Ef+dl8xHkQse9leoz8WxF2w+yACa5bLTDYfLQRlVbq4q7rzx0VjYwNIJN1Wt8x9O1QcGkvlDkuqSeMRhk7ZRxJ25/ezHaH0RCz682GktLYtv2mcqkixG1dY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a new sysfs directory, reports/, as a place holder for sysfs files
that will be used for controlling the data attribute report system.  Put
the directory under the admin/ directory, next to kdamonds/ directory.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 63 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 779c98205a94b..76850a4b5b5a7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2979,6 +2979,38 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* reports dir */
+
+struct damon_sysfs_reports {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_reports *damon_sysfs_reports_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_reports);
+}
+
+static int damon_sysfs_reports_add_dirs(struct damon_sysfs_reports *reports)
+{
+	return 0;
+}
+
+static void damon_sysfs_reports_release(struct kobject *kobj)
+{
+	kfree(container_of(kobj, struct damon_sysfs_reports, kobj));
+}
+
+static struct attribute *damon_sysfs_reports_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_reports);
+
+static const struct kobj_type damon_sysfs_reports_ktype = {
+	.release = damon_sysfs_reports_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_reports_groups,
+};
+
 /*
  * damon user interface directory
  */
@@ -2986,6 +3018,7 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 struct damon_sysfs_ui_dir {
 	struct kobject kobj;
 	struct damon_sysfs_kdamonds *kdamonds;
+	struct damon_sysfs_reports *reports;
 };
 
 static struct damon_sysfs_ui_dir *damon_sysfs_ui_dir_alloc(void)
@@ -2996,6 +3029,7 @@ static struct damon_sysfs_ui_dir *damon_sysfs_ui_dir_alloc(void)
 static int damon_sysfs_ui_dir_add_dirs(struct damon_sysfs_ui_dir *ui_dir)
 {
 	struct damon_sysfs_kdamonds *kdamonds;
+	struct damon_sysfs_reports *reports;
 	int err;
 
 	kdamonds = damon_sysfs_kdamonds_alloc();
@@ -3005,11 +3039,32 @@ static int damon_sysfs_ui_dir_add_dirs(struct damon_sysfs_ui_dir *ui_dir)
 	err = kobject_init_and_add(&kdamonds->kobj,
 			&damon_sysfs_kdamonds_ktype, &ui_dir->kobj,
 			"kdamonds");
-	if (err) {
-		kobject_put(&kdamonds->kobj);
-		return err;
-	}
+	if (err)
+		goto put_kdamonds_out;
 	ui_dir->kdamonds = kdamonds;
+
+	reports = damon_sysfs_reports_alloc();
+	if (!reports) {
+		err = -ENOMEM;
+		goto put_kdamonds_out;
+	}
+	ui_dir->reports = reports;
+
+	err = kobject_init_and_add(&reports->kobj, &damon_sysfs_reports_ktype,
+			&ui_dir->kobj, "reports");
+	if (err)
+		goto put_reports_out;
+	err = damon_sysfs_reports_add_dirs(reports);
+	if (err)
+		goto put_reports_out;
+	return err;
+
+put_reports_out:
+	kobject_put(&reports->kobj);
+	ui_dir->reports = NULL;
+put_kdamonds_out:
+	kobject_put(&kdamonds->kobj);
+	ui_dir->kdamonds = NULL;
 	return err;
 }
 
-- 
2.47.3

