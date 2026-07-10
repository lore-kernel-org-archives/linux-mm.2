Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2526C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D5A6B0093; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEBF6B0096; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70366B0099; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC576B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 393248E778
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
X-FDA: 84972993168.25.38DAB78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B12291A0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+GZnBQF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691222;
	b=fu0FrOP3n0VCC2Z3Fxwz09L11AUpo92AFUtiNnSmErXaZbd3/Dj+SmDfY9w+a1hZId4g/i
	E9ZZkmv2MyjRiM+z4QrduzyyquU+0I0ZnVm+hkveRLwS0ePskQro2RkeLek3krS8yED9un
	I/NxVxUtCnSkR9630/+f0fyhdQuS9y0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h+GZnBQF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IV0EL5uoIkcnMjmKSre6/DXBTN2a0ADkNneX2xN/Zgw=;
	b=fXWg8OAG/JIMPoeW+FMCB2d8eWj7e3nE9U2QTMTmoHjsVNrB3spCqqSNczdtNYyCEtAM/G
	GU8VwAlgegjwOmwQVq6dBgGhdtsKh7kvnw0nmLzQhk5tSM5j5xlfFpwTjXV1OQdDOCzGnK
	pm5AMKBTYjYCijM7dNfrxf8ZkQmZq2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 558EC601D9;
	Fri, 10 Jul 2026 13:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB1E1F00AC4;
	Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691222;
	bh=IV0EL5uoIkcnMjmKSre6/DXBTN2a0ADkNneX2xN/Zgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+GZnBQFWF3S+QHnUQcBAWTNuuqGOYf13WlRZGm34i8t9SEhEAlcnPFh1+SO1dd/g
	 34w1MqXFm3ZOB0BvK6M+AQexvrGwgH7K/1bnWJUtfuxUoT6m3ZU9uTFmkigA2s1ZJ+
	 wRIYf511g+Cq3zCFPVc+fljCJG7Imr4vezVGdfp9ii40+o1bwBAr9+Ff9cdrBFakxr
	 iN9GV/3u/nRz3PQ3QKbxjU6abzvuYrEF23Gp+VFglg1kGtzGpnpYO6A6n/PG/s8xV6
	 CWUBL5ll6VjDcjgTkxZZdLKmN3h3xazG4JublqWzTTvmL571Rb52SLvUideSgvEG+T
	 62g+eDOQGwONQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/19] mm/damon/core: implement damon_probe_hits_wsum()
Date: Fri, 10 Jul 2026 06:46:34 -0700
Message-ID: <20260710134651.18084-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B12291A0004
X-Rspam-User: 
X-Stat-Signature: 1awz8q3jcxsoxau46tjijtez4ezc5gh4
X-Rspamd-Server: rspam03
X-HE-Tag: 1783691222-664407
X-HE-Meta: U2FsdGVkX18UbN/+jVzQzip6Po2hqaAY4r7lTelFj801FuwV/gMVrxBPJSABEZ1QteEJHtVfuSEuBSgT+Wt5P20SFXKEhIRSfOugMSCHwcFJ7L8ukrK37jm7wkLGPAmhElVKaauGoOjFFm27MD918STggS7tyIWbTyn6G9gPhJ7g3JWWCxy+YNg+fVS9c4pTunZMNGmY1no523YkZ8LplyADsk4g5p7lcjsGj4JWrSfd4kEcm+Sdsx5T/tDoeHmL5E9luMtYkESBlsWe+PIrQGzpm2lD6b6OKLFNNTqEMn5tXvZX5iS/+SmBUQ/DS5DgSy0Jm5WByQESXGO6jYthqBoGj4i/Dtpa69Uqn2UFNF/ppKwdbW4BxJxrH1G7ohvurrwuu5/GRTJbJufrUaHaD/i8uPL15anwqb4UdF/NNtobBnuboABingjtszYWhScyZIze73by/BF2+3eJGQ7mXKLHmfo3EExO+Cf1XF7qtZulS4T9Q9WFEa3fiT4Tnua6dx4QBsbW2QX7vf5j2pTG+xpfp0355fZDiXqcTKAuH2NWASTuVIrSYjcPtHbLAkXISIh4+FKhDKAcQSwVC0PB/zyAz4YZOq/M67/uWxY8eMk6mvwe1JEztBJsQLikl0jh3OR876zUa8y7G0z6fUrMtvXM3Gnsm3dNWvuy6hdSVBFdg2oR8DIg3LFZrT46WqWMAx4/w+1phMfM/qM6iVE9gnkkcEbViwKE441f79gXSb7eIfgm/X1Ixjjvv3JQAfCUvqGDDmif49EM7jagRFT6x6mbUMVX6N59/M95xMsp9zMaajAByhvbdEbT+JPvYZTrEwHUNHF2Z+p9o8uE6C4qoAuIPBnLe4IVq6twG3Jxg3/EAWvrp2MaavhbHvW+iW+lPRCxbDLDtQbUBznUHDzndna/WPk+6Y0V9f0MlAbE8kbHv0/vXr1LuyFCA+6pCQir7Zpwp20oz6tC2+3tH0h
 kN+zM+0s
 ezdn5rz9zXTmVBsle/eFY8jwTd6sL+rpXto6y+NNFaSlRiHJmmXGxy6csFUpMKePfQ+EyrI7XoH3PvL9x1Dn2pphnxl7tn4akfZAA7sxYRp/GgMYatQtoP1EkG0YhvEcqSErVKf7D7+4mFIWkTnH26xtFjzB9Myu+nyAxBujuiyGzbos++hrEAP+kgBi7uSSjjZUtFF3zT29xELb6FCeuavV6E0x9/en/D1ynueZ6V09rzSrT8mfjs/1GAJvQ7Af6p/mSbXAfCLxRnraSgMejJL4jCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_probe->weight is set, the weighted sum of probe hits will be
useful.  It will be useful for not only the users but also DAMON
internal logics like regions merging.  Implement a function for
calculating it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e7acd8e610a64..f69442a9d4312 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1012,6 +1012,8 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9f6cdd810bd8a..fea97399b5754 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -393,6 +393,30 @@ static bool damon_is_last_region(struct damon_region *r,
 	return list_is_last(&r->list, &t->regions_list);
 }
 
+/**
+ * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
+ * @r:		region to get the weighted sum of.
+ * @last:	if the request is for last-window aggregated probe hits.
+ * @ctx:	context of &r.
+ *
+ * Return: the weighted sum of probe hits of the region.
+ */
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx)
+{
+	struct damon_probe *probe;
+	unsigned int sum = 0;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx) {
+		if (last)
+			sum += r->last_probe_hits[i++] * probe->weight;
+		else
+			sum += r->probe_hits[i++] * probe->weight;
+	}
+	return sum;
+}
+
 /*
  * Check whether a region is intersecting an address range
  *
-- 
2.47.3

