Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D217FCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006286B00A7; Wed, 17 Jun 2026 10:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C7A6B00A8; Wed, 17 Jun 2026 10:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6E96B00A9; Wed, 17 Jun 2026 10:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFBDA6B00A7
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E99DC404AC
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:50 +0000 (UTC)
X-FDA: 84889686420.12.5D14989
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6020E2000F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bahdETyk;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84/qqfM7ZmuFKR3xy/NTI5td5S5y80iivZPv289eNEA=;
	b=GiH6SNZvRdpwNOU6W5nD5Kgdl7m5cSCMUHFsrmJe9DAG2qnFsjuSqOCHApkQapqi0mjTtn
	YoEHXBg9DV87sVnIMvxGZ8Vpfy61ggGkYJSFZAjZsGDh/DNdrts91CvqJoDsQ53BuCDsV1
	Uu4ot/ZtaqGr4891iI09bTWH5u5DSBs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bahdETyk;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707729;
	b=C+aG2PkUyqvxgDo6CcCJ2OP+OSbm/Jw68EIzKM7FVCpwYN5j52qQodfmY+0jZ3EyGBnyKv
	/zzrYDp4zR38TPuQa6JVALRZBd92xUlDe0DEPRh1k8z3mb80O226FyNPRoE1FxsmAKKOMQ
	rVxHiUorRnM2kCP0RGu69/DQbANGuCA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B313E43BC7;
	Wed, 17 Jun 2026 14:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F16F1F00A3A;
	Wed, 17 Jun 2026 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707728;
	bh=84/qqfM7ZmuFKR3xy/NTI5td5S5y80iivZPv289eNEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bahdETykUd77T1Yj7mG+QVT9cX9iWRF+x73GqFpmwVMHSxAAzDLHgTyWcZXeCi3Zz
	 /jEkHlOBs1YNKRyu1VCxqM4JmVp8zFlF3v+CqEHhsf+JlfyOrtacjBah/tGgEg/fT1
	 ROgd4LU/nSV2Q+LvRcKYdbtZwjHAx3jZSQ2WZSQ6aW8CWUZuiRWoV4VprN/WShtJBt
	 MKmVnaia7K9diWE5SLN5bXtUlKMyWRDXxOaBo6nG5ZYCJtmf3lQoZEWUHJGnf9M5iZ
	 O8Mnn2psjX52MFFSQHEPU8p2TdSwonMsomDQlur7aYhlvlA6Qx6T3FTl2lximmymQu
	 8gczbC3BtG+oQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 11/11] mm/damon/sysfs-schemes: kobject_del() region for populate_region error
Date: Wed, 17 Jun 2026 07:48:05 -0700
Message-ID: <20260617144807.91441-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6020E2000F
X-Stat-Signature: q4yk3xae3a5e4t4rfuw7mfsmey9p1dgn
X-Rspam-User: 
X-HE-Tag: 1781707729-907107
X-HE-Meta: U2FsdGVkX1+jOtucKL0Pzdiiny8AquvrTrXOOZ/Gq0YCvQ8SlAoJAkeEE62CGeqXB4vqpu50BZBqcXpGdHMizFiSqPrpVdP1Ubw26/G48/i2xOTaSk1vtC0h2fFQpX8hU4X2S1UzKuS1awqtNwRNIzhe9GX2dhwXIeRqTJD4gg+qApt3A5plgbk0siiGD57lS8LJsxQbXJpL9zKS0tEk4DpnkHUvrWPD//EXVhQaSqTsjJIcFXCJC/nLnEkTMMxD2Pu1n5xKgMN6+cRRD0JTfLkaPKDu5G0UM/Mr/0TSZirtGcVXg1qn64L1+ovT0AZS/tXQScPHxw7mVNxQPoYAYnhMIhXdWxEMP5LY4H0s4UZV3AuZJfD8J5G/cXBoICffLBQoAzcjyYQxRJeMdGOtQRwv2XPHdrPIq1EgsrN5Pmc+E1pkz6uWOgy+CWw8WDpQy3avKIcw081u8pDrRiXz9qtwnOTCGDTCFdxxlJ733xVL1wjDB7aTZt6V3VqH3ohAvTUvAQapB4I6em4XI2Lgc4y3rvun+JQx3ncHDjJMWVJJzl9zXdCdnylG0CUoPb2B3lTrYfXM/udE+wz1iKqMlKAkNATosLikbqG+ak6waIIf2zeTDbRmmqDi32IyBzIAzuRlxjWoHMNf2UP7QEIDFkQ9whwo8METyithPcJV7ALBDH+B7ta72+Cr8Yyeds5CpwmVZM6mxjRkfIbfgSL90H9wVt05zWJwB9y2BkIceBVjAhWzzyLWsMCxBhvuoN1aA/d28gn4vDBZRewEKlakLSUn6GnEWx4wMYY+jIE4VhDKFs7/OntxzkbP3XPFbD6qQ7t+GyZFF1FEt2rQTmBXMxAcQKgbEJG9KghABdSB2Qz6AsMRLYDOn4kE6iiLxjAKdtQtikq6gcrsaqoO66Yr7Zp6B7AGRpISTIuUYQ/03wdxoydnQR4F9k/tHTc0pW2+2MnILHpKD5j2P1j+b4x
 LZkb8eUO
 8ZMuaoObUHPo/gO0CpuakuNH/bvBr9eYJVttUNH7VIKMQisyd7csHNWXe7EchNpvvrSPUx5YZsJ/PAjgHduc1vKUCHNkqIdyOlm1zMbOztkMFrM1pMzqFmMPGGSYyQE/Xe2cDee1JUw2IG7/wYu04zwiT410CcgjoSabSlzAWF3BZ/fKAWEGLr+t6ltCkh4HWCIjj5OWBVBolvgzTCZHmLBpFfr05WRx0n3Baku+sgEknfiV5YThuaH6JwuYlBg8ZxU1DQlBlZzInCPUolDhlQlThRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.
Fix the issue for tried region directories in the error handling path of
damon_sysfs_populate_region_dir() by adding a kobject_del() call.

Fixes: b574a82d10de ("mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 0c0c9637b594e..d3b414f7bd205 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -3132,12 +3132,14 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 				sysfs_regions->nr_regions))
 		goto out;
 	if (damos_sysfs_region_add_dirs(region, ctx, r))
-		goto out;
+		goto del_out;
 
 	list_add_tail(&region->list, &sysfs_regions->regions_list);
 	sysfs_regions->nr_regions++;
 	return;
 
+del_out:
+	kobject_del(&region->kobj);
 out:
 	kobject_put(&region->kobj);
 }
-- 
2.47.3

