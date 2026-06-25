Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E280CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6CD6B00A1; Thu, 25 Jun 2026 10:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA446B00A2; Thu, 25 Jun 2026 10:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30F36B00A3; Thu, 25 Jun 2026 10:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97BEF6B00A1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:25:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BEC6C04A1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:25:00 +0000 (UTC)
X-FDA: 84918656760.14.47B7101
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6609E80018
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HRu6XGK/";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397498;
	b=V1ZO4m9o2ceEwaN5AhMhOzAbefof5RKPIC0E511a9I1LGY9KAmTqo0pzj0zlT8yyeW2409
	35TVr9QFhG0BuLSalV9az8xHtBMTzC7adjotTKdS6uEPB2yyyQWMtndeifWyTcWb+J2tNl
	wX4/phQg2oyj5YEnt0jQiyP9lomxfKQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQV3GfOG7VWGJtv7W6ZwKyzWFgMIO6rC7OdU4Z34lgE=;
	b=24PaNt5Lo84WzqicDImHultuygA0o6ndjiJBfxhdX0+Sp56esKDgFcSklo5fgEChPt1Q26
	fHo2I1CJySdAmK+QhU1u9jjGbRlXHtw6OKFDqgVMQviBWj5s2zKfYFpujfh7LYK+ulOPkv
	V5BZwBxfJDSV8vxo+iimKxuH/nVWHxc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HRu6XGK/";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7578406CC;
	Thu, 25 Jun 2026 14:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5FC1F00A3E;
	Thu, 25 Jun 2026 14:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397497;
	bh=sQV3GfOG7VWGJtv7W6ZwKyzWFgMIO6rC7OdU4Z34lgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRu6XGK/qCH+dKSN5MszLTK92Z1d/NPfPB2x7DBDMM1CgMtQx7HErEfemIgaBfioC
	 cI4L9vQeWDKIEmkQGvxta3Up0cDBe8ewcQLVDuv61CCH69qBCPJG7aMXVBKIF37ufZ
	 xnhrk3fsMvZq5pda+HfgF7v0so7Th9GXVn4PvHq2SHScvYQAApvdE7p4AgHLvmhnKh
	 q8bdbLYxbuZwQHbvefJ6O27h/idEG7VsLBvnlIq97g6h8J6WcpGSZ3eD97eBQqLQte
	 9pSopfDti6CnyNIYGTZv0P9XP3ZwV9zsFyujmZ0xz/70x3flybnvnq3bbgpCEFpgQg
	 PC+SoymK/NUUg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 11/11] mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
Date: Thu, 25 Jun 2026 07:23:56 -0700
Message-ID: <20260625142357.103500-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6609E80018
X-Rspam-User: 
X-Stat-Signature: ac588n49mh64a54hnzmmnzmccehhsynb
X-HE-Tag: 1782397498-460507
X-HE-Meta: U2FsdGVkX19Iahn7KneuufWM9/r/UqPz9XAgXF6EZ3RavH7nchkfZNqrq99uL2kmcY3lKonVKNC5uQEC3unnnjMesnNrLWWl8c9yNlwsLUjmDIVfFet6PzrLtGgTPR/M0uDwled6IgGWodxh3AnND0oVgt5E2FTSFThMGHaZ71JXJGlPOUyn9vgi+k2Eh+D2JlDFW1ch+ss+6Fm97vWnO64hW3mO2kRxDgrOAKPi7Dr5ZOhUiCFUXO2PjXeVcPq56ogyvPQ/Swpi2gLL+kgGvcxm9A8GGSIdarZreefKvTbVQFGtBSL17YnAQHGXYnVAsQhFOavo9OWkGMiwM1G7dBkw+hXdlcSq65Nv+ZnaTXu9qsX/7SycJ6pNbjRUfKz0eICZa6V4ozWNUH7HCXLFRr6+Yf3a874ocrFzSQWI+yYGMwZIB3jf8fxkrcmoKGeZ+VnCM5zewdHhc7jhcvCBOFGOKjL7v62CvcLZxPQAdlCZ0xyWw5fMURwqG17+1Nk4y9FzDb+EuB8OFvZfTBt++FgYdeZr4aUNJmH2Wy8dsx3ZWQzx18tAuUdVeAmMPnBlGUBJBTUqliFDVWCVVKrdJtekT0DHyNp7OEwg3XdYrRVtmjkvaYKITf+11EmzUAn9x6y/qi8XAmeix2tgBAPusDwnCdAMfZpB6WUpDoGb5TxTXj9CseCbxzQzX5etdPaTaMSMyrzm/cV1suXgMmK6SLyE/h4Jc/rjgQUykEhljbEJgQkBLROMoj1vd/Y18dU4B9Lhp9K02bq3i2qw9+qG7cb/CcPQBJUKOVTAGtvYlDVpYdD4QoTmkmIlxrP5zLAxSgS3HqDAeIFTj697ADNPKWMJkjQ45sImfexeYoTGxDB3x+5Zwo7E7y5R1kJp5vG5HB8OSZfals4GhodjkLrFrF0PA9RKs+k98NWeQSzhFsQZmxWpd4lbDyTwZY17sE9KTC9HSdC2flsNyJ21mIR
 2wA1fsYA
 8YwvYVz04uvEMSeNKZDKxqzbBDWcoOxblEs09ehgoTfqJiQSIkukTfuWfnmAtTG2I0pZVlttS6zD06/MUpOAqINojhhCGvmIzSI5Md1fn4/mm0D3CscVI/dsee42eY6DDykzsos0iCB19R92BZbaDjvAJpmFbHpdwB1FNUeDq4cKxX+Bme4cba4PeF+xr98myWK/P30YFFOUbf259EpZRQKIW6lcfhIrStAH92LnYHX+EMi+Uva72zI6bhAdVSNViVIeWWBh0BS6SUc94p8aubQpy2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_probe_{add,rm}_dirs names a variable for damon_sysf_probe
as 'attr'.  Probably a trivial copy-pasta error, but it makes the code
not pleasant to read.  Fix those.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index f3bb146b204df..36d71f1675426 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1068,7 +1068,7 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
-static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
 	struct damon_sysfs_filters *filters;
 	int err;
@@ -1076,22 +1076,22 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
 	filters = damon_sysfs_filters_alloc();
 	if (!filters)
 		return -ENOMEM;
-	attr->filters = filters;
+	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
-			&attr->kobj, "filters");
+			&probe->kobj, "filters");
 	if (err) {
 		kobject_put(&filters->kobj);
-		attr->filters = NULL;
+		probe->filters = NULL;
 	}
 	return err;
 }
 
-static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (attr->filters) {
-		damon_sysfs_filters_rm_dirs(attr->filters);
-		kobject_put(&attr->filters->kobj);
+	if (probe->filters) {
+		damon_sysfs_filters_rm_dirs(probe->filters);
+		kobject_put(&probe->filters->kobj);
 	}
 }
 
-- 
2.47.3

