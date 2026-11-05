Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A0AB606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ErzpgnKh
Received: by kanga.kvack.org (Postfix)
	id 4740C6B05B7; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423A96B05B3; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275B76B05B9; Wed,  4 Nov 2026 23:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9B786B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:44:46 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCF02160937
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:45 +0000 (UTC)
X-FDA: 85399824930.12.9CEE56B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 898BB20002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:44:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ErzpgnKh;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793853884;
	b=BgvHLe7g/vl7GWl28VtYn5nX8qeISBSybREGRqG5ijRWWlWigX7jxqXFunXNuKFAz8HVi2
	ZXtQOH2z7NYbsSGUIPB6JuP91DS2BGVSgsCaI+togKKnDqE3j7lHUlIqNsEo63ytovW9mW
	yMhbkMrXV0N4TVjdeKNdmrU1u/pr7Uc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ErzpgnKh;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793853884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAbRG5nmi0Dlv5LNX/DTzBA1Q08jKkTod4f3ioIPBRc=;
	b=6bFKbEEHHL2JGQobdKDoRmTAWTRnuloE0ZzOGl2prMIsS6xvfZx1UFRVpHOuGl7ipmD2Qb
	53NocBIp38BNrPDpTDPcH0Dl3sFMC5ngqtNR7EvCRGuYu9c9lgsWv5yfb/VOLSHY0y2vU7
	GCFh71872CkrzD3GOhTknj/Y0+UXkZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF45F60601;
	Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719B51F00919;
	Thu,  5 Nov 2026 04:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853883;
	bh=ZAbRG5nmi0Dlv5LNX/DTzBA1Q08jKkTod4f3ioIPBRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ErzpgnKhpNjXJQptqM0q6ZwH8gcZHbRs2Yu7ycSRHH3UpU1n8U458+RlKTPspGCX7
	 G0AB0PWCf2Uno+Vk2IyUrwIi+Zkebhcv1tUSIMFn1x0NvxHmIU/V3fuWtLh+NtxvpJ
	 VUTIDCJ79SO6+TkeS+v4NiST4ZfZk0hF9ElKnDSCgMSebmodttae3KI4FB0XopXLrn
	 ECDM1B55/1nM6XIY0m3PwQg5RRzEFaaAYpyv6AF+oGrW7tYcR7Gfli/Vb7MWCQZlNT
	 hBackJ7cUTL5QmMMhdGKbiGt2z67IFutU/7Fm3UjZkw+m502wW4Yh0VgQnwqI+kN86
	 Nn+Vr7hEQx4ig==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/4] mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
Date: Wed,  4 Nov 2026 20:44:22 -0800
Message-ID: <20261105044425.87142-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105044425.87142-1-sj@kernel.org>
References: <20261105044425.87142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: js8auhpmf4nrdd1njask8tkwwnkgayxt
X-Rspamd-Queue-Id: 898BB20002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793853885-258938
X-HE-Meta: U2FsdGVkX1+gZpGcgVt2JoD8rry93WVsoRNvs65j9xFu0Y8aAHz71VUjdUewNP6DFxuAsMCmyC3aSHwLZ6nOPIHnP81JpRQr8MtKqluiTVuzimPPd/rLa8XoI+9ZTzQc5KgT/6ptz2DrKgyt+OEzXPQOSEE6pSySG/JG0/WQl2ykdFXmPrtDV0ihoqQtw8Q9lV1Mq0IVT4sXmFyf/lZjjbxEChmX6iIkoLD0UvVT6sa4nJzZZhTmSwkkbnpszahDUVE+gncbVgoEt5/K7Wlko/5kgbQYhXsOilOqidUJgOMyxRX6KcCWOGGG+RrtchP+v8wvCOVSZ/gTIFo/Adp6bGFjoDfQFub9jcCDdb5vS5yXvQ+RPGhuZKNoM+jM+h2ZGE+0kP68Btqw0Tn6mlKhrT6rLSitPkiXfeE3+YlMlUeUyYzhptx0nTEJ8F+oUT564aomAk53WdfuSuU6l6NSW/yDRgKIA9FzQ/qzxcuymDe3Y3Wm2rpYRss1S82ZEEad1HtCvH11mSaTmkbIzh6qDJReqohB4Tc9UTLHnMlbl/m+8MLm/zqWiMuxfJa/PeHwyn3zvfIK9GRG4+DriNxroyh36J44R0pnAsFpmo5DLSd/BGnQgNLFLNVzhix7aIy6+jbydaLk3D/hdT6RkM8KIfDaQXlaEbqiA+o50LwcM7dkJLyPUxRYmELs4RGMY3FFbW/N0hvoLUZW9GE0zu5zhWWp6GvdlgexdQ/CdtOlgwnEDt/j5ZPFmocKXgFMo1oOR0lDGjfyBC6J9X8LGNsOB2EC30xvrBZHOrVOrKFpCqT7zq4YWONK7odb3Ovgtp/TEr9JN4Ppdp3cq2ugeK1sHJKYw+BYR4WqL/KqHXxzYznPGS3nSILcUYS9YLnswmex32qSB9uvBs6bkK8siJ5V2yfqYcCQxugJ6XkjPjePTtu8CRr6wTwV7MZfhXyPHp0xu6WJgN0tyrOiDVq1/J8
 deqWfy2A
 JMr03lBDDeZlCbgRzTzOBROG1SO+CB6kZjGt2K9VIzKFcEjqeGkGTzWxlbVnRAVhQ4IUiNXDkvwlFwadmuFhYroWzOK30R8+PpZWE0n8/t6o6h1T7DFyZUeNLgAiqb14/ICUxuL4CRntTb/mKcnUiDvLw9t0UF0KKX6Lx1PNDep954X33o6dHuPXM7KgA9McEr0+9xRSKndEKeKRi5fQRdTdsZDgA4rGV+nj7nhFN6SEhDgT5j02oUoLxus0HUJnmRhniWmS+0I9NO+Jx0eteR8b9Rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support use of DAMOS_FILTER_TYPE_AGE_MS via DAMON sysfs ABI.  Add a user
keyword "age_ms" for configuring a filter of the type using the existing
filter configuration interface.  Reuse existing 'min' and 'max' sysfs
files in the filter configuration directory for storing the age range in
milliseconds.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 637f1bd0c950b..230987efac3ac 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -593,6 +593,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
 		.name = "probe_hits_wsum",
 	},
+	{
+		.type = DAMOS_FILTER_TYPE_AGE_MS,
+		.name = "age_ms",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2875,6 +2879,7 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			filter->sz_range.max = sysfs_filter->range_max;
 			break;
 		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		case DAMOS_FILTER_TYPE_AGE_MS:
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
 			break;
-- 
2.47.3

