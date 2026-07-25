Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6F6C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD7B6B009B; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497C16B009E; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275606B009B; Sat, 25 Jul 2026 17:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D19C36B009B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50C6BA13A9
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:40 +0000 (UTC)
X-FDA: 85028522880.10.A8CA50E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDD9B1C000A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiZMyBl1;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UduVFa2f9m90XMStvUkd2JUFPgh2VQgxt8rOrBb+Gjc=;
	b=PYulC7Hh1qrsvt08UX8R1xdd6fKF1yFk7sn9pU0kGiBu/XACOj6X5zzEFmtYvRXu2y5pv8
	StApS2uoSBBpOE/+Xja4juLP4dFEg3/WwkahK7DBTji/Z9ZKCAl+CLIqKWSLK/MvBVEuZ9
	wUJv0J3Yex8Jr0TC2D7lO88ULnNlSo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013358;
	b=Z5aWZvoyzKbDm/xepFhXtA67Fs8rq5/8t76FUZSy7RCJouHCnm4YNfECps1EZA5SkO/we1
	gtGZ8t60ygQ9iWC1lieCSPvaRyeoBUx7aW1HUUG1gU+uygAAsaeaC1sP5jZphfaF1FQ+rS
	1aNCoytgR69ibU6NodAqgRlfZxJR8Gs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiZMyBl1;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 271FE45136;
	Sat, 25 Jul 2026 21:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF621F00A3F;
	Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013358;
	bh=UduVFa2f9m90XMStvUkd2JUFPgh2VQgxt8rOrBb+Gjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GiZMyBl152MTY65nBUjhdwJYsLmBRP2br0p6tqhKfU4Zf94TVQ0K8cnr6yz9X2i5w
	 jYHxFXwbetlDxvGFsiAwRk4++NdbCZM5eZ71DASe9PrxxF++jE+44CBtvNf9BBlfZb
	 k1o7leRxvCtOJuPPQiMVTIYhL46W4gNYJm6SvEAQ7L8Bj1GXP3t/oUXySMKZuMUBiS
	 w+M2K1oqeagPnvcBe5MMfgIj/FRDe4IZIslPZoXFzzozpxBuqchC/tasMz8rNoJKMV
	 sdHxDP0g13PxCSCTFteFmcodC3fGBdzq7FSW3BGMx2UJmY3ZRPWrjtxtXaOezt7Zo8
	 TRywa9UoaSyFA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/17] mm/damon/sysfs: create probe preps directory
Date: Sat, 25 Jul 2026 14:02:14 -0700
Message-ID: <20260725210225.129944-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BDD9B1C000A
X-Stat-Signature: 7367mdii7h8i6kyxqqwbjpthu8srk57a
X-Rspam-User: 
X-HE-Tag: 1785013358-984476
X-HE-Meta: U2FsdGVkX1/pe2f4anygpLY+UxthzCheUZro/X1wgw6Y7Pb65eANUY2xMi50Rh1Z6I7d3214ryKMuMpbVSQLRlrKoYJCTXnZTqkN40zjIFfW1fFW919j/VdrmaD2LHLacRl3bPDB8UYQPmCajifxtXF7maO4a4rZ7IvTqEOFIaCiuaeGQ0U0F3D+F9waJkD+qY2A4cVtxCq/LoURNHhFr9IZWLqozx4dumc1liKhosY/iukcRmLa9zjsX+J0hThZ6SyZxlQ6J2nUdmVKpeB3mb/8sOSnsDGB2y9C8hEYpB2yKRFx/GCVFuoxbi7lRo50DTkxqEPh8Qqa/7uwqFkZs+CszMogJ2xMFfA46wt2uOpiltX6nsPACAtHHTlbppmRbQov92CRKJ4IyS/z0+GPHMo0kuUQsUPAruPLYBoHbaNYQakXq4jb/Bsxdf437WPbjLeO98zPy8IqQ84EfE0c56vyHUa0MTUG8gaX6UK3xVVpMhlaZlCq6BLnS37CBHADMXGzEziXyzpcn/OcPkpY6xdpKpcGhAHrE6BmRsbVc3rHxmKYFsIneYNA05u+SRRdq2VcnA8+SmER9zZZ7OUF9QTikA7y3Q920bWmee8Q4LNytUKIuEfvQEYA76kUAyBhX5TJB3HcXT+sY1YDHBKQkoAC3088HZA8r++gPzJuFhvCwVDr4x8AL2tK0iovz54wJ8DVNIEOFv1AQoE1U77R55S29ThdHbirXxcitd1J1isJZDEHzZhhYGYoV0lniAKf6kCrM15U/bAmsGvo6qIfySBHdq033ipMrBujp1JWNm6W8hq2iVdtJ7IUagMAVRh006EsmgPXwq6BJ4kqWKCkumKJNA22ItXIjofTPWpNSNVJcdo8wta+RIzdI4tq+v14pg3X+EDZ99FtSHsMGPW78bUUUoXDTxDV5mk0VTKGIXPvnoXSbUG7sZeb66YROmBU57KRlm11c37tj4H064v
 rzmx0YCJ
 eWgmmofD24DPTqGhuEz/eN89gnJyGcPQSXPGNvbKPTJTsqb4JmEfEIqI+pbCOfxh/IVXVh6rXHwhPcQcMcGSEK7KwDic46N2/4+71jO95r7R/lGJU/ScbotsyA7EkS3ACaei+VLN0n612FoPoSPqmjD+U0i+zChbSsN31RTMMv7nIl68d6/5sL58QYOWvbwtID5C0ixbDbdTq6L9WZWW+W2lwudPfXpU/srjTDUBt2VaO4Mg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create probe preps directory when the probe directory is generated.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 7b971bfd1169f..6d3ed80fb2eb1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -759,6 +759,16 @@ struct damon_sysfs_preps {
 	int nr;
 };
 
+static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_preps);
+}
+
+static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
+{
+	preps->nr = 0;
+}
+
 static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
 		int nr_preps)
 {
@@ -1138,6 +1148,7 @@ static const struct kobj_type damon_sysfs_filters_ktype = {
 struct damon_sysfs_probe {
 	struct kobject kobj;
 	unsigned int weight;
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 };
 
@@ -1148,25 +1159,50 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 
 static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
+	struct damon_sysfs_preps *preps;
 	struct damon_sysfs_filters *filters;
 	int err;
 
-	filters = damon_sysfs_filters_alloc();
-	if (!filters)
+	preps = damon_sysfs_preps_alloc();
+	if (!preps)
 		return -ENOMEM;
+	probe->preps = preps;
+
+	err = kobject_init_and_add(&preps->kobj, &damon_sysfs_preps_ktype,
+			&probe->kobj, "preps");
+	if (err)
+		goto put_preps_out;
+
+	filters = damon_sysfs_filters_alloc();
+	if (!filters) {
+		err = -ENOMEM;
+		goto del_preps_out;
+	}
 	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
 			&probe->kobj, "filters");
-	if (err) {
-		kobject_put(&filters->kobj);
-		probe->filters = NULL;
-	}
+	if (err)
+		goto put_filters_out;
+	return err;
+
+put_filters_out:
+	kobject_put(&filters->kobj);
+	probe->filters = NULL;
+del_preps_out:
+	kobject_del(&preps->kobj);
+put_preps_out:
+	kobject_put(&preps->kobj);
+	probe->preps = NULL;
 	return err;
 }
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
+	if (probe->preps) {
+		damon_sysfs_preps_rm_dirs(probe->preps);
+		kobject_put(&probe->preps->kobj);
+	}
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

