Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131CD606A885
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Es3dFLPb
Received: by kanga.kvack.org (Postfix)
	id B0F576B05C6; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98B26B05CB; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9609D6B05CC; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7233E6B05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 101FA160632
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
X-FDA: 85446641280.06.DA36383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7461E100003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Es3dFLPb;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968558;
	b=8H9QLDfpB+G99r8Jg+jo92Bf3vIYpKXjQzt26fpklI67Uhi+QSzIVTMGq4979s4ywxhdof
	Cxdg3WMHEXGOovYz5tTFcxbw8NdRhZNPqbf/D6npPHjvsxEwxWT7U5jC/9K9JTBKwe78Ew
	6Xo71HrTHUq5iawa53/0KCCBhGQyEOs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Es3dFLPb;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbZTCynxDA8qlWzkpFXejL39caIBFfSg2B35l700hQg=;
	b=bQ4gTRpt1RA7r32ekt41tSdrBvsTohVdmC0Hoh0ofZGkgqSCB6ex2J8dwp6PEZ62yR0mIQ
	5NoLYnRtyY5Q9i07PECKWR2nStyX6RQMnG/sYum34kgcIGtxirZVVUF2RYmuIdL+jy/l/A
	MDRcvV4uhkknpAERB+OyOX9HozaeyKY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1932861EFE;
	Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B755F1F000D4;
	Wed, 18 Nov 2026 02:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968557;
	bh=WbZTCynxDA8qlWzkpFXejL39caIBFfSg2B35l700hQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Es3dFLPbTez9NhDPYj3DPFbNH88TczfMJ58tHJAqZDJuCfkmcQjHGITi69ZUdH/KH
	 aVtgyMeyu3j2+k0A7oOW3wybosmX52+VGcpD6czIJtwNS5oUvpJY35OTKRtCK3C31t
	 m3Zw8g4pb2/Lm5dadlUj+q+TX0q/Cl/GHNsYtluzWKHgFpo1+55TTOrnaaHia2W77x
	 LEAxnK7WhqT1QeP/HKfIEA+NcMUXX4R4DehTGKNVXM0X9R/Kt5UbWDn2Y8OH0m2BI6
	 oMw4KtxpAwPu24RvOS6YZXcTpoYhzohvaH6VM4joTrGEpCxaUSeTzCej9YG7lmC3k7
	 NwpH4jZiM242w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 16/27] mm/damon/sysfs: support REPORT_MADE type probe filter setup
Date: Tue, 17 Nov 2026 18:22:11 -0800
Message-ID: <20261118022225.100659-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7461E100003
X-Stat-Signature: 8qq5x8zp6t7zeqjjymmhgnyc59shp3i7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968558-528588
X-HE-Meta: U2FsdGVkX18SnwwVUvYOVoPNIgZPpzzk/7Zex5zTs0YUdn7qRbH4trYwezcfTP3OvzE3B+Pj+W0+9e8pys4xWbNJLubUEn0bDAj0k9ccwFffBDDtw6Eo0lmXuaCJyBZ0d9kQeXc/8CLXZXOY5hownXbmhpFZZa8uAqo0lIScIBJRo9fyd+OJ2hg5beinwvSRvlaUjw4EFsIHWnjoMRcvM6hzlpPVCZ/E6QYTpgz0OrQRV6ABJeXplpJ06NotbcjCFAF1QYGFbGoVGgPL6Kqhb5RZ6wlnY+qKyO8x+26p+ce3qoNmD1ZK2Lffe3H8KPj7HbwyauIFDl/rVr94/zqKBhaXGiLhoC14PVTQhH9+BweiDhh7OIc93UPtTe7kBQAO6F7mZH04/LdT8PtD+mDItwQSCpXYNDG6ENBLv3V4oKRBhug557+PCj2mUx24FMKa03v/ZLadOGU6L6sRYxB6rQQxrGFfmwd5gv69yhrJpIKlSjLF1/aMD4ZUh5aadHhXFJnBR1ZrB5S5TOG2VXPaRMSNDovODLI+ySU4y230eNupuon5RpMK421nPrGS0wJZm9+7GxnGA04y+RaacQ7KnSikbIbNH39DgbSPmnyZWLjvsWjilZLwwnT73ljCD5cpiHDDYvt+DJ+yKOwi4ybww7JjqQsIugCav0KcJ1we7IOlIficRZ+66nx7lb3W1uJ1W9XDKzWEmCoHuoj6mKcdY+QCix2kYNCK303VfucvFsPE3PApjLSriEFznoJZV5WZ+4o/YT5KALS5eINDN30+ZKyLd1SQYJ46Z0iZwZIPNx31qqqkvRCbmZdrn4SsXniYyKwAHnwG/GTEMo5QuFYUeYw/4Hlw3BK8tXQCNWCxbAXOhxwTSv9jkVu1S03k6VMxNb8FiZwXcYeA8HZLFg98ghGsLetVo0W462xz5pffpdFtB7eOwH9d5MXAyJwvqnJRDDpZ80BJNvotU5yLjxV
 I5qzf2Jw
 0Xx6L6F+PIrbWGsIercApLdFBnfyMBt0PqvOby4eZwXx+48LgkvOFY0mUW2oTaA0wmKWfN6yWCi3DiXjacG07kMw+694bBt9JkVqmAh3KLZ83C/b6+VQP6Oen+o5TvlpFwmdAMV639frkm3xAVv2Ij0czho0AqqK97HTkQIxnjSEgZGRixbU6gxfNg4UoU9p/RhRLUYYsOF3y9UgrMxhgiQO+39X/iug1Cvb9d+cM/P9yo14U2SufMBjgE6/+SZSrzRQNMtGMcJWARK4P0kyTNxyKaUOAw8SFvKo9UepJeRq5F3nPUOvBEIMimqML4EZp6hbClN4+li3sveE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Accept user keyword "report_made" to probe filter type file.  Set the
damon_filter->type as REPORT_MADE for the input.  Setup
damon_filter->report_type with the filter_report_type user input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index ca971cf1dcf6d..1c171af4590a8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1016,6 +1016,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_ACTIVE,
 		.name = "active",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_REPORT_MADE,
+		.name = "report_made",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2336,6 +2340,8 @@ static int damon_sysfs_set_filters(struct damon_probe *probe,
 		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
 			filter->range_min = sys_filter->range_min;
 			filter->range_max = sys_filter->range_max;
+		} else if (filter->type == DAMON_FILTER_TYPE_REPORT_MADE) {
+			filter->report_type = sys_filter->report_type;
 		}
 		damon_add_filter(probe, filter);
 	}
-- 
2.47.3

