Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60AC2CD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 00:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4666C6B008A; Wed, 17 Jun 2026 20:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7F86B008C; Wed, 17 Jun 2026 20:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242206B0092; Wed, 17 Jun 2026 20:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD4D16B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:57:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 477158FA39
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:57:06 +0000 (UTC)
X-FDA: 84891219252.05.2B65379
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B4644C0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:57:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzmToBhb;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781744224;
	b=XtAZLU49s4jcjzc9AehnG+AsgKjHzYDwHY8JfZXPNu2dLfAGErX2x3pewKJqfepBvZdOdz
	1zhp6AGHyTIO63Mu5ed2I03Gdc4fMncUYdAtFAkRGgIe+lmCMayBHG0Z5LrnaTEy1FVxeK
	PSVedKrdFRFSxRWOI4S9WIqT/WXKJ3M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzmToBhb;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781744224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=304b+5TS5ljtcCjsmfNo5OTxh/l/vWic2mRv4DwMcZo=;
	b=gmncmVb0epbHYpW51P8fbfcCIxRlMUfiGFJAeM/Qe77qEF4fpRwHvijHcnvT3NcxpSttD1
	d19G8tZ+UCFynW7jqCRkJ58PZiTCm7dBs95yMnGjkmmKa+j/X+qn524ikssuUztZjZLIKI
	ceLBztO32Dfmxi8J+XW5zTeXQozOeQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41BC860098;
	Thu, 18 Jun 2026 00:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327991F00A3A;
	Thu, 18 Jun 2026 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781744224;
	bh=304b+5TS5ljtcCjsmfNo5OTxh/l/vWic2mRv4DwMcZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzmToBhbEPDBY+34I5Td2vOJPPcGFv3P+z33H/F0dszFDV08x5Iku8EO3z5LM1Czp
	 Gu2FXgmp8KSmKZUOhlhcreMWvx9pT0CtS40+oMElnVDIbqy3CHlN2ZI1eifVmD40jy
	 meGn0AGRMBy4GqPUdmoYs+4RUxTd5rPc6rvTdhY9Zwlp7aEyn2uIa2mXnB1jPyskOz
	 XqrlocC0mjXJ/TAIqBQsYWEcYAvUQtV0zLXMfEInS4km0a3PR6NVWmJqoBm4dfflFs
	 +VWPS+WZ/30opv462SKVYyfBMFLnUC/EZU5DFwOfyJ15H+qa3/iC1v/VVeh7jTou17
	 jtrLPJAS68QGA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()
Date: Wed, 17 Jun 2026 17:56:47 -0700
Message-ID: <20260618005650.83868-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618005650.83868-1-sj@kernel.org>
References: <20260618005650.83868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4644C0009
X-Stat-Signature: 4ikpsfmhxyqw1bek6ak3kw811eru9zuo
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781744224-935344
X-HE-Meta: U2FsdGVkX18CyvN4ewxk+5dIqt3P8XfdcAfQ+S+0af6dI+mt13zQmcLJbty3UAdJLpLX3tnmQ1X+A/QUqVKi+CAfFZ6odVOVzOZ1ffW7LeHvjq+ylJGrKFE+uEHQVaeA4xoOIW/1P6TUZwiGyrveK7edGssUyp26ZMkOhf1TihJrrAP38gts+o4IV+AKVMJR72kXkIPKT4Zl7cKXP132BdfKVVYGuK/TpN51tI+FJGk5i0C1aiM1TlOrsqs0Er7r4lQB2HSOTmqTO0eBiSqfZUK0Fc0ZzNQBKsAFvUVBLihwl8SDIYd7JoTxdsGbJ09tbuIsQTfNkZqGdv4yGzqXPTW3uLQNcUiEDl85r+kryrSnrXwZe/euIxB4hPFoGsH29Em/8XVNBBeu1B0GOShzMpMUQI4jj+xp6kd+Fv4M9s8cgfHeK31qxhpA4wjeyaIKnX6HZ59fo0gUjxDoZUlzuqdYW7jEDDOPEUpstssM9erK3y96SQHOsbSPV4KeYYXKsVX6JHG7HKL9Hg9W8P5PNqjOq5Wli92oPJyefBBBdgmekyA2aTQP5/5MA/q+uk2UyPcWFK696s1/GLirdyKG1r6lmrUN72hHP3h5zpwApQ6IsICxwPBCusWAuQQ0mkr6AcBvHe5oGwFxcQl2dKpJP2wbRaC43gOJKs+OvPHfZX2b5DM8KyYqcYd9mIAWbn6dbd9i66xCG+YucF0g/RzdfcSMBw2bOE1WVo+X8Lur+dKvTh4ZWt+ije+IcsiG8c79+O1VnBqP++Y96mDuFD+LwrQU54on2/y118+ZBUQ4Gxdv9vsuszOHPx9Wfc/fzQT1Wr9OFgQ4Www4OILWsDgOskdxX18c7WKgIsAgf5yeA7dCA8WdVLfJlHmWeBD3dl5SUFiEwgBsXx0DXt7zKhKG/W/GE3QcDRnJxUlAq65ZFXk3s0NzNSgZOS9oeYe8Wl+mZ7O+ifpqSZbbOWMyDcA
 A0y/OTTT
 lX1/BSuNlycFnTRKUTEYUpuczU+mWgidI48AJ+VBlJek69/sB54oi15qkfq9ymQkxmL2L7UJFjMz41jb9M6T+Gq450cbr6oHX1sZgDs2gV99onwZxoI8vVWo5NxLmC0rERqtKxrD1s6lxpldLbvGzNsSPQXSID4FdQOmU1n907DrgEdAagSvbKdOYdz66lLN8TtBR2ThKWbrSNt20kjErBSAEl0mZUkzxigkbzeWpDDpGoM7pG1y7drYMmA9EgsBzOkxc7gmGjvB/ak1EbrZ81sdjGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In access_pattern_add_dirs(), error handling path puts references
starting from setup failed directories.  If the failure happpened from
the initial allication in the setup functions, uninitialized memory
dereference happen.  The allocation failures will not commonly happen,
but the consequence is quite bad.  Fix the wrong reference put orders.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260617060005.86852-1-sj@kernel.org

Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f3..7c00aa78b2f50 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1993,22 +1993,19 @@ static int damon_sysfs_access_pattern_add_dirs(
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->sz, "sz");
 	if (err)
-		goto put_sz_out;
+		return err;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->nr_accesses, "nr_accesses");
 	if (err)
-		goto put_nr_accesses_sz_out;
+		goto put_sz_out;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->age, "age");
 	if (err)
-		goto put_age_nr_accesses_sz_out;
+		goto put_nr_accesses_sz_out;
 	return 0;
 
-put_age_nr_accesses_sz_out:
-	kobject_put(&access_pattern->age->kobj);
-	access_pattern->age = NULL;
 put_nr_accesses_sz_out:
 	kobject_put(&access_pattern->nr_accesses->kobj);
 	access_pattern->nr_accesses = NULL;
-- 
2.47.3

