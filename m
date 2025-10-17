Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6C3CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 07:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB108E0026; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2708E0002; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E86B8E0026; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69FF48E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:53:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06E851A058A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:53:49 +0000 (UTC)
X-FDA: 84006842178.04.A2E7803
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf20.hostedemail.com (Postfix) with ESMTP id DDBCE1C0005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:53:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CeFEqUky;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760687627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0OKcU2IWVvgxpGGM/x3bGo2RcncD8hKQxZ9riDYf6c=;
	b=ENpG4F6s3xJAAeGSVDUjLWPMC84VKWzHT8Tuy+ubJcF6wPOpjf8xt2Xcj5re83EjJV1ctf
	sJlc7A4voMS8/n4W6BweCinxHS90bi35Em9EyHbew2GtSxHQUrQoM19v0L+Y69BYfutAp5
	xc6zU/69/pqP5vMh+t/DvMjhgWeNkHQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CeFEqUky;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760687627; a=rsa-sha256;
	cv=none;
	b=DsxyVEUQC95YvOWUr1kjqHiIzidOYLeSfm4do0qLDgidS3H8LI/YaoXnIkhZ5QyroqiSMz
	WGs5QVgi+K/thh44JAriFW96iU95AtwwHppCBaZcwzCpnP3XT8kd8z2UJ6z3JvqrxiulYd
	QIlo0w/zt/yrkVpLgY5XCJOvFiT3nAA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760687623; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=D0OKcU2IWVvgxpGGM/x3bGo2RcncD8hKQxZ9riDYf6c=;
	b=CeFEqUkyPd2kh2S8BKbobenqkv0L0goNojPFTGtOV+2u7dvOdt2r3Wos/kNaHltYt+f4oNt655wmqnIGcZL2noiOJrY7iMYetqTIerSM+x/J7DyCdvfO6pcjQ3sP4sfexPTabtnE0o/VVH8TSjdlDnCHJq5f45Wyk/jAltw7B7s=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqPAmKl_1760687621 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Oct 2025 15:53:42 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: vmscan: filter out the dirty file folios for node_reclaim()
Date: Fri, 17 Oct 2025 15:53:06 +0800
Message-ID: <c91f5ecc5152b647904c7503618a01885d913928.1760687075.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1760687075.git.baolin.wang@linux.alibaba.com>
References: <cover.1760687075.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDBCE1C0005
X-Stat-Signature: 5o31pp5ctx86bxee8sseg3zjhi7re8ho
X-Rspam-User: 
X-HE-Tag: 1760687625-596059
X-HE-Meta: U2FsdGVkX18c/Z6BkOG3GZYCojSparoV4gLpjen/b5b2O2qWCeD8vcAQZ1Hb6UrNnu36KYRERlv1e6SWIv9wvi31WyftTo8P3gBxGCimNhVA8fR7sZ2pklvIEaS6F6NUgIStLWiVftGhDL1BLiUKMHHjzsCVD6y7iBxPYfAz70uyjTnQ0UVuuts53FEcnM5OqIDnc5ehuMGhBk70Jy37q54aYMlzPUQnudROIWmiMXaTxH8eDIi0GuDpeHrXRr9QtljzCW+pMtAwl3jmrSznvO6WV7kKPeFTMatZVZchS+bgOFrTK7ValmWzwuJkO0gqiOBfeM4coslP57yAXaVCXewxNI7r6By+PC1cpzc/iHK1EZxHflkLw1T+BLWVPB2XXbn+D/rLwIiSc4zza6GOS9J44MSFqSAnKxiTwQ5NyAwd9mcLRsJjkNIgvUuAOhcvTStVbEp1vRFPI9dOTJj+xBqWkJJK9qxBsrAjKI6Z8QuMASsV71xtAB+2+DotZer2cfuAGtorKwHr3z44Q4fvmtFEbk4C/HNPRackEq/+PJCnpSmGCfQxkOF0fDdcJEcDEwAFxEST3/sbH+GCpb/ZQUTBlmbuHyA87F8dXzCv0pz56Jk6ZyQm4ZBZk25VQg3hSSQRY+oipn0wxtBne4a9rPwKo/rHfLyPwYFio184hE7RCHplUaROFkwAnLWCl864IHQABHfsJg7J4WHEs0MX3gxbHZQWl1dNa+YjroJlTjFZH/KAelEa1oJafOGgn7vwAEq1c0FhjIKDv7Mm0qEXt4EgTGLPQmQP1M7MCKuSPL9VBntj4qWcGYJ1yEdq67CUFaTn+rvH8JyqXV0L44/eYP0q3efQugdFODBS+5Juz+K1tH7Z7JidowH7oOPDrlMKALt3t0hVTqUdWcpStFetVCsda9s/Qh61NYlhXgAR4DFlcSxj+PwMh5Iq9tb8n4ibriQlUZXCXg1QRRsDRIh
 FBdI7yrv
 zA/Ge7l8Gc6/ZPwZx/+xFodhpCQcpLNx5VwNQnzZ4iok8ESmVSduYWnGDKa2Dg2dQlVMsQXBiMZho2MjgYjNXPqfTlSq8wrJoYYFXPyxS/A1AIndm+4unS2jwLAcq7YsKIf38Qkw0OzotxLkc9QKfaJ5ACUc5htoBS0PXNzoXdQu3AYBvZDhksXTSkXvpYXlheOS+mMrScoiHg1TP7ChzmEIDGfxylHcNa/LWV1ZXrG6cWI61L0o7fvqeDYeOfb3uv/pqM0nHWcDUMHb+WTCVM0ocHQTyNAbM1Y4/gM8zr08sR0A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
attempt to write back filesystem folios in pageout(), and only tmpfs/shmem
folios and anonymous swapcache folios can be written back. Therefore,
we should also filter out the dirty filesystem folios for node_reclaim()
to avoid unnecessary LRU scans.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c80fcae7f2a1..65f299e4b8f0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7601,9 +7601,11 @@ static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
 	else
 		nr_pagecache_reclaimable = node_unmapped_file_pages(pgdat);
 
-	/* If we can't clean pages, remove dirty pages from consideration */
-	if (!(node_reclaim_mode & RECLAIM_WRITE))
-		delta += node_page_state(pgdat, NR_FILE_DIRTY);
+	/*
+	 * Since we can't clean folios through reclaim, remove dirty file
+	 * folios from consideration.
+	 */
+	delta += node_page_state(pgdat, NR_FILE_DIRTY);
 
 	/* Watch for any possible underflows due to delta */
 	if (unlikely(delta > nr_pagecache_reclaimable))
-- 
2.43.7


