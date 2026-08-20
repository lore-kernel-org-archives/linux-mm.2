Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA24C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65D456B009B; Thu, 20 Aug 2026 02:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DD36B009D; Thu, 20 Aug 2026 02:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522F46B009E; Thu, 20 Aug 2026 02:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 326916B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:15:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE306C044F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:15:47 +0000 (UTC)
X-FDA: 85120636734.27.33FA0BE
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id 75C3D20002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:15:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787206545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jA5UNKh5zqIyuAUQzbMgVLtKgsCsozrj6fK7Wa4whj0=;
	b=QrtvEY5DlSn/zK4qthXyVdTbzpsq018k2QAftWJ4MxkkXix8suMcMzucCgt3q1v3R+HZem
	u1c9xvkUxY/z+gC9tQ2PXQcbMg5izQn3MKsl7XwF7PRvrq9kMeyL/vmKyFm421ls8vH7ZI
	YDaSvuFKTzeiOOlw9elWnH4WKTZjkAw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787206545;
	b=o9rHb3KlOlzesgxZsnnPO53l63lFl1KgYlAzB4dNDSMmTXlrE96R9QUlEbU1dZqEPfwJ2p
	0nUVzT6ypRxZxP++KPGLDJIjCROIEFENQ4+RQf/Qv+x+yA+IJ8Rgkhec5rvE8Ls/YfIsXu
	WobkKgd2HimZR4QPVr5yJTZjj2p3dsU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
X-UUID: 8f4bcdd29c5e11f19a56ed5b684f684d-20260820
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d8c56ef1-3f0e-4005-987b-25cdc788237c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:d8c56ef1-3f0e-4005-987b-25cdc788237c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:548e8bd7b5f61f1a0f61e7e475775867,BulkI
	D:2608201415408YJ6C13O,BulkQuantity:0,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8f4bcdd29c5e11f19a56ed5b684f684d-20260820
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1493064475; Thu, 20 Aug 2026 14:15:37 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	sarthak.sharma@arm.com,
	usama.anjum@arm.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] selftests/mm: TAP output and global-state fixes
Date: Thu, 20 Aug 2026 14:14:23 +0800
Message-ID: <20260820061426.356869-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ut8rp5gx7pba9ik38euoob3ye7jd954c
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75C3D20002
X-HE-Tag: 1787206544-882005
X-HE-Meta: U2FsdGVkX199B5O7F8pLaE0cKjG00IsWavfBOQwa0qENBLNq4COP6+zUpsMozjShEhN6pwonB+z6INKbB7RdmjtFHK87J2qP6kyV9h28/5ds9JtQd123vv1l/LpDv9jvqnfd+0OkzZP4+xxUU14YWg49Uyk4vi8SO/xirdFOMGyycVudjd2ShESd+M8U+bMNH5AwWzQ04Zvv9XW463+zCKdcCztQgenZpXFdXAMYnrCTZyFiz2sbg1yMZslDK8vGpMke62wgdYlZSj5bjnUMwT3fjd30W4Pu5AKM32DWXEy0GmxWPC34i9f6OpYDFln5cQUjrqCcsZBPMVmG9x/0wuWSPIwcjZznO8jx+ZO3hxedfy2w5A/L6Ln6RSfoR9OZLUeyOgOzWDyzwePQeNqcUMKDWGSczP2F4fqxWy4vJPKkb2PveP37RIfexb3ayM8bCDHkVIdFKOj5czLMtJI0CysiXcakQDrxaSMCXbpxY0d2SjfJBQacnSbuWw20+WVSlIasE1Es28uUv6RPzxZ1wZ+VVyU7omjrPyWzikndUd3Lhm4UVmyQ+ZuNPTW7ryu2q6sXeg8Hc52CuVXaqLwTtt609+hA9tfF7h5RSWjhnk5ysEVPcqCFOjwucW2IOFIr+Sz9YIkydZ7SBoms6kz0YNPT+HgYvlfJKZWRnEXd2h9pCGwfssjXzw895qkR7Qk2smI3vcTRklMpEog8DvNaBnTjjCgQqMfMsJsMK951B+BiYaZ+mZr0N8VQerU6j377g/o6ZDmMrccEYnzWn36eCqnmhLxjVtZ8H32x9j+SMk35QtPxVKS1lMXeKbz2L5/wGJnKnbkTFnuhj787Xvgpool1pn209ZX2WTXs7IH0Tk8RVessJCDaps/pOQzDgNOVo9Gr/H1XL418ZsPsIplytNnZsk8PmWfQjBidKAf6xb219iNnyVHN+I1ZpnpPF5zYp5lVZwX+p8jEwGKuWBH
 uqo1433v
 JK9E11BUGlHGySOgChLFoKnOpvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-wp-mremap and mremap_test never print the TAP header (and mremap_test
skips with a bare exit(KSFT_SKIP) rather than a KTAP skip), so their output
is not valid KTAP; hugetlb-soft-offline toggles enable_soft_offline during
the run and leaves it disabled afterwards.

Tested on x86_64.

Song Hu (3):
  selftests/mm: emit TAP header in uffd-wp-mremap
  selftests/mm: emit TAP header and use TAP skip in mremap_test
  selftests/mm: restore enable_soft_offline in hugetlb-soft-offline

 .../selftests/mm/hugetlb-soft-offline.c       | 35 ++++++----------
 tools/testing/selftests/mm/mremap_test.c      | 43 +++++++++++++----------
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  2 +
 3 files changed, 39 insertions(+), 41 deletions(-)

---

Changes in v3, per Usama Anjum's review of v2 patch 2/3:

- mremap_test: cache mmap_min_addr in main() before ksft_set_plan(),
  so the skip paths in get_mmap_min_addr() are taken before the plan
  is set; a skip after the plan leaves the run with fewer tests than
  planned.

Changes in v2, per review feedback from Mike Rapoport, Sarthak Sharma and
the Sashiko AI review Andrew Morton pointed at:

- mremap_test: save errno before fclose() in get_mmap_min_addr() so
  strerror() reports the actual failure, and split the ksft_*() messages
  embedding "\n\t" so continuation lines get the "# " prefix.

- hugetlb-soft-offline: restore enable_soft_offline from an atexit()
  handler so it also runs on early exits, and use read_num()/write_num()
  from vm_util instead of the hand-rolled helpers.

v2: https://lore.kernel.org/all/20260815080716.3596514-1-husong@kylinos.cn/
v1: https://lore.kernel.org/all/20260812120821.523860-1-husong@kylinos.cn/

