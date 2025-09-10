Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D03CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DA28E0013; Wed, 10 Sep 2025 05:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96548E0003; Wed, 10 Sep 2025 05:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84FF8E0013; Wed, 10 Sep 2025 05:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90C408E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:03:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C73D1DEF97
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:03:32 +0000 (UTC)
X-FDA: 83872752264.27.EC9960D
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A23B180002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:03:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757495010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ALO82sQtOSIwfABpAkqnG27rzAZo2nnhXu0oGZxCiv4=;
	b=yBh3nsj9pjkzyHu2cdq9waW59e9rw3eoRP5zrIpWWuSzRgf5Dd62HbNToKDMUfe1fZNkIk
	rJBTsh9hMpZfG40QjhwHooOcZgp7vcTxgFC4BXp0+ClAGjcCVKUR7vI4Lt80np41REtk7T
	CiRVIluLkut2B53HudiRPjciCMG7c6c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757495010; a=rsa-sha256;
	cv=none;
	b=VdDN7x1uj2gZU1FQtopg0kx9bf6im/BDAMIFXwwgayxGzfSs9UbCnFPUbuA4KH1Fd743tJ
	6HW3H1UfmRhW7u6dg0uiALcLz8Mz43G8uXzk7UEzhPoTNO6nNfT5luQrI5eykLN0xt6FIj
	mtpP6NxHVNTeAaLs34eSOFqjH+JyHvQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of lirongqing@baidu.com designates 111.206.215.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/hugetlb: skip report_hugepages() output when no hugepages configured
Date: Wed, 10 Sep 2025 17:03:16 +0800
Message-ID: <20250910090316.3406-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjhj-exc12.internal.baidu.com (172.31.3.22) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6A23B180002
X-Stat-Signature: 6fdcyob3e9et8j9txo3ww5sqh3omzb4x
X-Rspam-User: 
X-HE-Tag: 1757495009-474514
X-HE-Meta: U2FsdGVkX197j7xA0ECkpfJn4Mca6+xOtXlcjxgyo8/yUnE1U4DfvHRkQF0wZ3bTZ+lY674g22rcgH2UhcHKHwYYotYbNh3sCzDgVkHxAwUitA8/mO9J4ZSYwQJi/j+JJQ00TF6fpNNuIe/zo+BgWi2px9Lo1KRYuz/vQl+pjRGDer7GQOMISp4S5Odu5BQJ9oiwwxZxt41M/tT6I7YFWqqyvBY+gITIagxijSF+pfVp17/qgw0HEnnM/dv1HRdzZen+JSeTyQI23WcF/k4V2fozM2LnHM0Goecd6zgh8WKfwIPMZcpW696EaoDJTZidog50HCfYqJWF12HBqy8BxQ3ALAjhTGDo3r10V/cjP8YVupeG0Q+dyyRxyPp/j1UL7I3lTWILYuJ109iyRxn4zK1Dn83vUeDcBxiMSS1nJFb+3PGnByHXV4PSGonz/bpaLqW8QuUu46KzfI587ydndYQ6ltdJOyUimcbx+2uYzL7QqI5b0mcyi4wm/4Mn1CPMp17H9rnbcoMYK2fBbZ8alamfdD6k4Qs9btmvQUBFI/EAmsFBm10WtWkR51QFdq80j2ssjjms2DDUsEyml1VcjlEx3Fdfg6uehtPry45LUUPSyoiRd/4DJC1k2Dt23sVJDFtfD1gXio6L0mgQmy/zaNkyxGQK4jx16BarwulpAfDxUw+4OvDxVTq2F07wzrDqRibbum3VEBYdXCJA8smWiyPddytN421Wqgt+V38N0aJ4q68joH9Q9+NtaZIFo+oyGT9V4yRQp3ZFx0jcav5Pkvcrd6cbVOz3cbP21REYbGlsLbMazKVZngBmI74+1OJYhNdKycA5PhmxoSIDO7u54XYqFNpLRpqgA9HEU+DU0/9/UrinJqOEpXsBxd/sOy3AdVNplHQtuvCVq+l2+8i4PuaKgNbJJogPqvfyuq1zTBEqjUM45sLPQHqhsYI/lzorTUdH8rboFPFdVFK010e
 rerqLRpH
 FkIuFIYSeR+AL0tk7LdcjoGnQcH3Yyx3uy9PLAavKJXuEKBaNAB+ev+3nzOzV5nxNfS++ueMD+ZRUIu546ErQXDSUaRdf24SYeV5xx5IA04vySHaeHxvqBn77tBoTPZscZN7MNd1AZKc5a5Z3qefFgxhjAO1GwFtu5gdl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com> 

Avoid unnecessary report_hugepages() output and processing when
max_huge_pages is 0. This eliminates redundant log messages for
unconfigured hugepage sizes and saves CPU cycles during boot.

Before this change, the kernel would always print registration messages
even for hugepage sizes with zero pre-allocated pages:

[    4.118953] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
[    4.122920] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    4.126920] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
[    4.130920] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page

Now these messages are suppressed when no pages are configured.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 mm/hugetlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index af7c36f..9fb9311 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3733,6 +3733,9 @@ static void __init report_hugepages(void)
 	for_each_hstate(h) {
 		char buf[32];
 
+		if (!h->max_huge_pages)
+			continue;
+
 		nrinvalid = hstate_boot_nrinvalid[hstate_index(h)];
 		h->max_huge_pages -= nrinvalid;
 
-- 
2.9.4


