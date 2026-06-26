Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4695ECDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC44F6B00F0; Thu, 25 Jun 2026 20:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E686B00F2; Thu, 25 Jun 2026 20:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63916B00F3; Thu, 25 Jun 2026 20:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83F9B6B00F0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6C4BC19DB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:17 +0000 (UTC)
X-FDA: 84920149314.22.7C6A0E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5BFBC40003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrvUaBIz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433036;
	b=Sua7pydtMT7tpHdTQUOFNyi7tBKO54q+cnlAwseww34rY75sTm57+MrsZD7HU8jkmPhAU7
	KyU01OqUfpFMRo1CwNBQKjwM+u92CKqgQ5YxUnKJZvOnVTvcz4T5gD8Kt9UwAyStVgOGmQ
	TfV+3/70AoX1GRuwjTPUxnLkEDsGLZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQV3GfOG7VWGJtv7W6ZwKyzWFgMIO6rC7OdU4Z34lgE=;
	b=La2DnRUCsGmyoSkZW9BqV8liCUDDXBFlg9qnUulxuBzDZND0XTkNy+qkpA/3zmCAbvDem/
	S+p4TtTEbW+vSZIDFQrVBJPmhedQHa+r6/h4IbyAC4vCUyxMqEDFmOuvIbHC/yEmnLBog4
	aCczOeociID31qqeyU0V4q5TmeE3HAE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrvUaBIz;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBD0F60141;
	Fri, 26 Jun 2026 00:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78661F000E9;
	Fri, 26 Jun 2026 00:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433035;
	bh=sQV3GfOG7VWGJtv7W6ZwKyzWFgMIO6rC7OdU4Z34lgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrvUaBIzRwEe+uBwfCC7oIufVS51AeykE2X0QEdFZSp1HOJZzP1e4BHyYmv0SmjqJ
	 EU3PUAhRB2BBFMHspLiM2bM44Cg1GpfcKXlbans/6qQudaCQRBKsIlGwfLWBQnXkVX
	 WhbTJ6A7DFntoc+YdRX3cBh3hzKZzsgDWhEKVwoR18ATJ902hMCh2VyCs9Re4TWd2b
	 0KLy09RhK5aJPwKGbhx0oUneDF5/b6IzXrdJpMBg9j1lZcR2UJVeiW1fvsKk/Buzo4
	 4fqJUaTwcLYXp6awVscjY9g4odiBap8t8DIFjGm8Fwhh++HB2DlZAhRTiOoPv0eNig
	 XI5OgZQmu5OmA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 11/11] mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
Date: Thu, 25 Jun 2026 17:16:42 -0700
Message-ID: <20260626001644.85825-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4ii4okgar6pfrpyfhzu5to8ohfmfty7g
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BFBC40003
X-HE-Tag: 1782433036-767112
X-HE-Meta: U2FsdGVkX18znlELbAzglOyN74uaiahgOv2DgT6aY/t2Zz32Txi5Me3M0C8nIFtXUStYXHaDsJT4yzwUFpRhCARRiBojSUna9EzPjpxgfF7s3qDyB9Sj7fYLKc29MjmixcpHOSmm73VJxiy+WNDBcsrMSB5X0B76b8i1SrSaEwSFRrKTU1u38LUVLRxANmStp2wiG8W8iXJGwL9kkwHV8o64Xl8fT1NvQMTFNqF1IkT5ji5/4hEmy7DhpbJu9+VXCSsmYgVzF0FPpw0n6VUF2uZ3a9qiXSovJIicAdfUyXZcjnbDIvYucpJ4dnbYvSDqZ4zTAL+GMjQ7ktok/Xz0R6Gmw2T4IfNrHBy6QBWpmkUL9jSuMibpkFRDuoxaWkMiZmx49dOeqpU2CZ4VXI7k4hEc3zGzUEZ59sRlgAmuvnc8sI34Vu5eK7JCacriI1rR0oRE6ynWiLfPud0xvdbqK+3mScLY+290wkSWDU8a5/tdvjzesg+9axlToigGcD2RsTmzmN+K+7HnExXldUJtdMMuv7GAAG4u4yIPtGM7iQ2GTVpxRQ6rX4YHWRoTNzrPpbBtw0PauVrhzFTylIct32JhVyX1mQSrwVL/uDUBE82kMAJ2KY4famkGR20Mtl/8CeU/Ybhzzr0++lVTj7l7IQ6VQSLQkiFSBUXChefwvTyLdMuIUttFJz8rcR4iwRZJvyHqN9lytC6Tl4ZtB6EUROFqfHQ/piQrWHLop//cTM3vUkBY+LiuLbqilKWTRe+INiETPhxvuORgtpIpZHPXyGDbOLsQGJu6/VCRMLRGqQzzq6jJLTgx1u7AkVspD61KT5I6fWNaSKMCcE1lHVhpBp5Oew4TpqGxpGoqllrgVPUeKrNrYlYiHSbem93KWkNdr5fBzbRs9a+zL0sBO2ZiFClz6Vlq/q2vyYbvKulW7wgwb6J/nIijvITfitwytqSkSCMFGj4V65kX8G9VqnV
 5UU9a75i
 Y8MuseZZQ3JVKOpXWRECmv22O4rY23Uo+Y4XqvknL2dLZHdwCcrMfwneKPEejGBYTtH3XrAwefT9SZlgxa22sjAhJnQEQT32Mhe43PN/2aFAsGcHCOv3xxZbd7Pn0CwUjLN5Nq27iN2chysqsUmUBns5LyQNh90KsQpSq3Uk/xUfOOLc6gEDftCmfzJ/QorEtVVVag18UVRr2Ii5vxXGB3lXqMKc4DqWajaNxuWQ81r3KEYxRlPwcTZ9pcILyID7/icgatraeJiBl/0hfz+54ie/tkQ==
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

