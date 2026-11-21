Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A008C606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5pop92d
Received: by kanga.kvack.org (Postfix)
	id 138596B05B9; Sat, 21 Nov 2026 16:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097C96B05BB; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CC96B05BC; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B54F96B05B9
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 173E716058A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:26 +0000 (UTC)
X-FDA: 85460344452.22.11DE0EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 529F6140007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5pop92d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294824;
	b=Vrd6xP2WTrsWVoatb14dwdCgfROwx+9ri/P8HjhAHRNdCwdiXVfa+/K6mMdYJmcAYk3D1k
	PO4O263EURly8lB/I9Sti1mJdZm05CgxXGmbpRitKD6eqk2l0JZHjlnhaK9IQFbTBxNZdj
	dFwiOXfTOMdPh/PbwmLA+EnZhOnmWFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=en0GKVo205/sJ+JMMbLGyOQzR+GcMBoehXLNhDIZG2Q=;
	b=22EDBgaXtXG2YWqtbXQ5ktit6urniZ7wZ2nM4GxrqdM+iUc4a/OUcodoY2Yi/BfQYgTmbJ
	EW1EhwDWXa1xjjwqKO4YOYr2vLB6LBff7e4Qs6jwDt4GVmK+vBesRKPdVE6cOTfXl0xiAK
	eNFbYNAo0EcKT1g6HrujImOCJeAa/X8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S5pop92d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 996304011D;
	Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C181F000C6;
	Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294823;
	bh=en0GKVo205/sJ+JMMbLGyOQzR+GcMBoehXLNhDIZG2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5pop92dcE5WGRfHwBuE8uAp8IlzVeCeVs8FUv+3/BhFyFlFYfuegkHQwHt4tpdQ0
	 VpQPDfqkPi0hZMRwoJGQOYxDBgO7F+vyP3e1l79ZsfTBMPz96CRre8x9to2IyVFKEF
	 WalKAuO6MWrriiv9OW4r7/3256O/b7uhAGaY4Cd3l9vMk8MJp1sXXAPquf1fCH2YX5
	 y5CPgfnORJN8RlMWwZPJrTyeM6QKfe3l515EH6h4vkOUxbdw9XVoGNoPhMI+G4cdwZ
	 gSAjFn5nfjh1Ux7+eRyvW+1VB1LzaeHGYVVN5NgOdXSOyJgVNApfsGmvNe/dTyQ1zK
	 5oxmy3jPjLLHA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 07/27] mm/damon/sysfs: implement report producer directory
Date: Sat, 21 Nov 2026 12:59:51 -0800
Message-ID: <20261121210013.130397-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 529F6140007
X-Stat-Signature: 1yfhcs97stxg31uk6g3z65qgajt9pkq7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795294824-665643
X-HE-Meta: U2FsdGVkX1/su91/2pVt7Y8n32eyEhX9nYUt24g0cR8H9p38kpF1o9U1SQRIoHFk4tYfPMcFojbYq7nCBPCSTVC2jTjQga6B3nvx5pEnTVxeUtH1riiOA/skltC24dJe4bBCKxQXeFGLaEZZK/cdyuUUsHtOR4Itm1B+ASbtImftF+8NFODCd3ldHXfY64P7W46qspmic4Mw+gzP6mezXkSKbdhGAydw3uHbJvIGkc12Gc7LdP7AGWryeZU67SkwMPejG5zchrTwokG+eg7Y3Pg/fH6soAYylBVz+UHtwoIti5cX3w1C2qCU9A+4yxUTtWWAfolFxH5G8fN/Ha8aK0YQgrlkZsWdCg/hP4hK7tWpRpLFjEkDOXNAbKAw7MLOqSs47EFq+132X0j+WoLaVxMuUXPgfQQE5GVlB0p92nOc3QRHR7KhD/9qmDTeKqEmzz1ONuRamcK20POqskT9YRe8oCLsYxS7Ec/6EQd6ChZfQvr8pEW37/XO1yjIsfL+993Y07Od1QHgO61bhJwiz4sIxF6LL35xjQatG0fifigZQEjHn0jH0D9+AAk6FhoBFpxHXCkmGbPLnWMggsJo37fzRTUxjPgDG2xb+CHluTltETNuFgSpgxq7+WPXNn2mgOM005C9J57x62gIX2ppXRD1vLwk/czTbl5u89mbmiJ3XSTrZ6MQOR067SbXxFivu3YUM1APNxfUEmq4zCcBpFFGS4epslt/yPH0TU9VVlOLfUcjAOtek/9QY0lMUmWX/5g4a6c3Ye0YUZ997cie8o7phdYxIphO4UYKaBjFQF2ZiRVPiXb9/fggJ0kD27RamKbR7QehrER6pUJFnCcBgFJaCBAYLRtIPmcoZdmc35ketX+egOI0a5kOPLJFaSEGPyz9dkUbnjDs5nkxBTVTLtLqc5Dej4NMVBJnLM9yGBx2w06CieBJPAU5dfMtQjIuYe0uydD7VOLTiYopAfM
 bFhCdvgZ
 PVJ7fRn9Td0GGwg8ruWAekeKSg8W7YPouM11sE4XCrcvv7lI+DNPMca2YvJ82i5bXgvbteEfWoIIK+7KF1d7lT5p4YNmiYhWFlDvfyF2AA6dek7Ro2tYzWft8ibli/gbaH40Q11Tnukb6PzAXlY28xiDUgBZOYqLBs3LvI8n0Drjtevm+ftywCRPEqTzeqXS4iKmb/SC0Xxv2Wdw2yp3Ym5BrOH0X6+X0inJOQXdx/WQIFXoDiTOHFaM50/72FtJC2wFfIw/UH1TcsX3gy7hXWoxVnwrS5FVQQDl71MQa0c6Enyt2tDeWHJCNSDCyoX2KKr56CDhUVxjve7pDFEP208L4z9xz6S9HSs/2UlEwO8Bup2h7MGNMqYXtQ5lzUiD+JbmCzAh32K30UPwBZjtXpXCSyURTIceG/YunPZkASis60r/0JZPzaVW8KdQyZ28dE40+VI/gyYvU9AfL0OoxihkWcGWjIKup3/9ewRUNBCVPDvuY9U4xJCYdiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Implement a sysfs directory for each report producer.  Create and remove
the directories for reports/producers/nr_producers file writes.  It is a
placeholder for sysfs files that will be used for controlling each
report producer.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index d3a7cb170975a..7c6bc30c12125 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2979,10 +2979,40 @@ static const struct kobj_type damon_sysfs_kdamonds_ktype = {
 	.default_groups = damon_sysfs_kdamonds_groups,
 };
 
+/* producer dir */
+
+struct damon_sysfs_producer {
+	struct kobject kobj;
+};
+
+static struct damon_sysfs_producer *damon_sysfs_producer_alloc(void)
+{
+	return kzalloc_obj(struct damon_sysfs_producer);
+}
+
+static void damon_sysfs_producer_release(struct kobject *kobj)
+{
+	struct damon_sysfs_producer *producer = container_of(kobj,
+			struct damon_sysfs_producer, kobj);
+	kfree(producer);
+}
+
+static struct attribute *damon_sysfs_producer_attrs[] = {
+	NULL,
+};
+ATTRIBUTE_GROUPS(damon_sysfs_producer);
+
+static const struct kobj_type damon_sysfs_producer_ktype = {
+	.release = damon_sysfs_producer_release,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = damon_sysfs_producer_groups,
+};
+
 /* producers dir */
 
 struct damon_sysfs_producers {
 	struct kobject kobj;
+	struct damon_sysfs_producer **producers_arr;
 	int nr;
 };
 
@@ -2994,14 +3024,53 @@ static struct damon_sysfs_producers *damon_sysfs_producers_alloc(void)
 static void damon_sysfs_producers_rm_dirs(
 		struct damon_sysfs_producers *producers)
 {
+	struct damon_sysfs_producer **producers_arr = producers->producers_arr;
+	int i;
+
+	for (i = 0; i < producers->nr; i++) {
+		kobject_del(&producers_arr[i]->kobj);
+		kobject_put(&producers_arr[i]->kobj);
+	}
 	producers->nr = 0;
+	kfree(producers_arr);
+	producers->producers_arr = NULL;
 }
 
 static int damon_sysfs_producers_add_dirs(
 		struct damon_sysfs_producers *producers, int nr_producers)
 {
+	struct damon_sysfs_producer **producers_arr, *producer;
+	int err, i;
+
 	damon_sysfs_producers_rm_dirs(producers);
-	producers->nr = nr_producers;
+	if (!nr_producers)
+		return 0;
+
+	producers_arr = kmalloc_objs(*producers_arr, nr_producers,
+			GFP_KERNEL | __GFP_NOWARN);
+	if (!producers_arr)
+		return -ENOMEM;
+	producers->producers_arr = producers_arr;
+
+	for (i = 0; i < nr_producers; i++) {
+		producer = damon_sysfs_producer_alloc();
+		if (!producer) {
+			damon_sysfs_producers_rm_dirs(producers);
+			return -ENOMEM;
+		}
+
+		err = kobject_init_and_add(&producer->kobj,
+				&damon_sysfs_producer_ktype, &producers->kobj,
+				"%d", i);
+		if (err) {
+			kobject_put(&producer->kobj);
+			damon_sysfs_producers_rm_dirs(producers);
+			return err;
+		}
+
+		producers_arr[i] = producer;
+		producers->nr++;
+	}
 	return 0;
 }
 
-- 
2.47.3

