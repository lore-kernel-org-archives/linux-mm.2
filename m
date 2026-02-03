Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB23E83071
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28176B0088; Tue,  3 Feb 2026 04:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2726B0092; Tue,  3 Feb 2026 04:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBB56B0093; Tue,  3 Feb 2026 04:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA4316B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:54:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 739FC1A0413
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:54:44 +0000 (UTC)
X-FDA: 84402686088.15.99E1A98
Received: from h3cspam02-ex.h3c.com (smtp.h3c.com [221.12.31.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4819E1C0006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:54:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of qin.yuA@h3c.com designates 221.12.31.56 as permitted sender) smtp.mailfrom=qin.yuA@h3c.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770112481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=g7s5GFDAhOWkxA5W64DwlamRabx/03w/O7nSuN1xE8s=;
	b=xlMnDY05OcJ2ZmM6WZJ8kn028al1zMAoFLzO56G0uXMTy0zZUtPkTQqq4qlk0QnJkwkovk
	CCpmil2pXGrXxgfwBK/PlBoFcixh1uNVY9RGha3QmKuYev6uEbbTzKuq9YkarM/39TMsH6
	2NzcMKSN6+DWUnBS/UT7xHIu1ERvppw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of qin.yuA@h3c.com designates 221.12.31.56 as permitted sender) smtp.mailfrom=qin.yuA@h3c.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770112481; a=rsa-sha256;
	cv=none;
	b=JQcxUXjLUGuaNz8mH+LkucYrlgyf4YLNk1BGN1U+ihx3jgGsYIxaIokEdyPu4OBo+4qDXk
	VFvAuit13XEpxYakk4gIl5epL1VJ9jxQsSn1d3JccWe3cmqq10jAaYW7eUn/OjVD2gyGX3
	NyEmKNd5OgkemZjpO4VO/jo24SdCTbg=
Received: from mail.maildlp.com ([172.25.15.154])
	by h3cspam02-ex.h3c.com with ESMTP id 6139s72e067249;
	Tue, 3 Feb 2026 17:54:07 +0800 (+08)
	(envelope-from qin.yuA@h3c.com)
Received: from DAG6EX08-BJD.srv.huawei-3com.com (unknown [10.153.34.10])
	by mail.maildlp.com (Postfix) with ESMTP id 4B12D2011873;
	Tue,  3 Feb 2026 18:03:53 +0800 (CST)
Received: from localhost.localdomain (10.142.164.51) by
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.27; Tue, 3 Feb 2026 17:54:07 +0800
From: qinyu <qin.yuA@h3c.com>
To: <sj@kernel.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>, qinyu <qin.yuA@h3c.com>
Subject: [PATCH] mm/damon: remove redudnant mmu notifier call in pmdp mkold
Date: Tue, 3 Feb 2026 17:54:00 +0800
Message-ID: <20260203095400.2465255-1-qin.yuA@h3c.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.142.164.51]
X-ClientProxiedBy: BJSMTP02-EX.srv.huawei-3com.com (10.63.20.133) To
 DAG6EX08-BJD.srv.huawei-3com.com (10.153.34.10)
X-DNSRBL: 
X-MAIL:h3cspam02-ex.h3c.com 6139s72e067249
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4819E1C0006
X-Stat-Signature: h37g5zm7zgdyxso8qphioc656rhfpecd
X-Rspam-User: 
X-HE-Tag: 1770112479-863172
X-HE-Meta: U2FsdGVkX1/eDrKfBBTRIIOscIOzRjL+D7m/dk82Cxl5uM2Dc5Lwrl7yhisaY8okkkmcIH7th4X+0/bAr56mMFq9ZyA1dCMuhIqtAj0kePrXrOuMmwCayGzKsU+cjptsW5GLd2/dGY4gdMo87/iWB7nMX+OsMOHQBkL9ZB7k4qzSb9y7Z2Cd4letjRKJWvVJHPprN6Z6wPpPG8cxdlIH39hJIF9i6OQ8Kcsgd714KvsdFN5s+IsZrvUMysBzVXx0sg3u4Sni5ckoJSI3TFh/yZpxIuLUcAryaT6HF9tDzK9OU5mNZ4RdWjdQdUAgESUkCSH6pu17+H1taHaEMrbX/1o1pS5X3kPd8uQdWP9+PHwaLGYaOhrdLFI2p3zuxk6TeUjbQP5dESDrKUZkec2nXX/j4/UFH8gko+g03LeNtGPe8NDO188qgB9A9VFJmP9d6gWSuY4iJ9NqzwxCDB/X4QyjVc9w8iA5ZPtFlDiGqDihLzO4vaWCdXfCJNk9KOjhPkWN6kxEKC8epyW3U+r95hp27CuaqCEpx+yQ12J56RZKb8YNJ7GZGrr86xK9B05iuori9bcxaj530p+v4q1g7pV9GmzDVNSsdC/rkeikBwTts5SuNHEzRUfMZY1sNbzniJokQ3o2avXNgugM+uL9Fp8ho4CcFhRMQMGUR8yFJ7Qt0+2xvEQpMhu1N1VsR/u78x0ayi1c9cpX6v1ORsKhomLrD6wT8jxuAPjMdn0qOVG4H70agi8cZFY6ApTkIW+HbhPTAsS6uS3EGzzH3POm14gEOoDiuYEGp2PXhqSgFhxjcqNyFzz0nHJbGEUJV3CDDuepQ243fLF36/txQUgYRHPYS4L8vy1bxG/cZp1cHQw9/lSorJVn/IYZWokaxv4O3TzXztUtHt+vdSX7Nn16apGM0picQEto41ObfWvmgiytO7pz4thSAnYc74e8qpLp72xl4LUROJZoCzDdCqn
 Gv4r/oiA
 Pbhr3Pbtx7F2Z9Ci1hZHmCxc5fqcpBR0O90frmW0oZaRYdrNoW7OXBkuxREVxz9J0Un8XDh1MDAdOMIeStsFWcvXdU+ckC4BI5I2NDn1qpiiTtRt87N85AktufA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, mmu_notifier_clear_young() is called immediately after
pmdp_clear_young_notify(), which already calls mmu_notifier_clear_young()
internally. This results in a redundant notifier call.

Replace pmdp_clear_young_notify() with the non-notify variant to avoid the
duplicate call and make the pmdp path consistent with the corresponding
ptep_mkold() code.

Signed-off-by: qinyu <qin.yuA@h3c.com>
---
 mm/damon/ops-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index a218d9922..8c6d61342 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -90,7 +90,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
 		return;
 
 	if (likely(pmd_present(pmdval)))
-		young |= pmdp_clear_young_notify(vma, addr, pmd);
+		young |= pmdp_test_and_clear_young(vma, addr, pmd);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE);
 	if (young)
 		folio_set_young(folio);
-- 
2.33.0


