Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C8AF36B97
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06E66B0088; Thu,  9 Apr 2026 19:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A904B6B0089; Thu,  9 Apr 2026 19:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957E76B008A; Thu,  9 Apr 2026 19:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 801866B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:42:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05202527FF
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:14 +0000 (UTC)
X-FDA: 84640643430.10.CEFA777
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 09AFA4000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WNjqUa3/";
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WNjqUa3/";
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778133; a=rsa-sha256;
	cv=none;
	b=FARcIpL2bMfBvBLmH5UFFDWT+fjq4egM6sot1pk2N3m7q0pkVefAw76t26592Wl5QzloBn
	bEC9Hl90u6jacgbiu2K2zAENNNFFKbQJiEDJnfQZpcLBfm95zlu48PAEZM1eFkIqF+zTk0
	wQ+v3tXOR5qoSTbTixUm/u88/ERbPdQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vAAQPrcpDFpgnoOmQKyoghYQbOEr5qFXKnrLuyiCEzs=;
	b=ph0olPW4Yuly0ZAFcDxRKdCCAkkUt7MbKdf8/7qB5RCrdeSHauJM5XTfiX9VBu+v0WDwBJ
	V1rLiXv4HgG0UPCdceG3rDNrc3U74CAwUR8mR9IIZISkXctP00JBz6QvAMjq/cqZEOLYkX
	aXBTP+Ig3/IkRPbDO9Ge6Me/Twt9Mjs=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtbhH2413294;
	Thu, 9 Apr 2026 23:42:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=vAAQPrcpDFpgnoOmQKyoghYQbOEr5
	qFXKnrLuyiCEzs=; b=WNjqUa3/q48Q4vZVtx1vWH8dMFR2cgv7pl8j1Z6gQLXyG
	tfiPBbaxn0GpISNpnlbN961nhBCl0AyQ6wd6ymuCTcW0QXzp0OZW1B5i1VBf54Kf
	EFa8wue0MOk/3HSktrzkiU6v2benzr6AKBW4MNZjbW/otudg4+UHehNIaKiOOIqr
	RXiI1bPgrZSJT9+dOFQ0M3lhIf+g4k2Zt5Q/1qrg0nkukZihRF7c2QkyDekTuKiW
	vHYaGSYgt82uRVIIYn2werEUBVOzxiwNEG9gxk4oXwwiFSP9BwmauUrGEyYiYOLg
	ebo2vuN7SkdK4afWTfHer03jBc/EcQbQozNhPKxRg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqa8rts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639LPAFW040031;
	Thu, 9 Apr 2026 23:42:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnbj4q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:07 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639Ng6Yl038323;
	Thu, 9 Apr 2026 23:42:06 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dcmnbj4pp-1;
	Thu, 09 Apr 2026 23:42:06 +0000
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] hugetlb: normalize exported interfaces to use base-page indices 
Date: Thu,  9 Apr 2026 17:41:51 -0600
Message-ID: <20260409234158.837786-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=549
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090218
X-Proofpoint-GUID: XsAdDgLcvcNrOLMiD3qE601d0TB1ZPv4
X-Proofpoint-ORIG-GUID: XsAdDgLcvcNrOLMiD3qE601d0TB1ZPv4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIxOSBTYWx0ZWRfXx7eMuPBJMNUL
 mvHDvmxXTaOkc/WNuMscWFKeaQyKyvKIcurfTF7zNgHE0gGjt93KJ/yTvdK7xB2/CuHh3Sn2yB0
 DfmfmFQiQWKYGTokdW+mKm/TP2ohK0idPIrgiNT1W9LDVYwDSYAlZVS9kNMYREzQTf0z6RoVboG
 xUnbLDNpDge9EhH5ryoCJuXIkRHwxdnEkE5Mw6fhQqPxHJhbeD6xVL+JdqCVIDYH8/eGJ2UNk/S
 VPfS/DncccJlG3UQc7M1YP8/c3hyAef+oKc5dM33bh+xUSLA6iRUSZ7pZjtfvrV5HVPFWEX+O0R
 n9nW0lPByP91IhJpkkzlpU5u1/1WHcQGa6KD+MXIpHHw/cBHPOt82fKbskHrOjLwYdINrW0/etu
 Tb4bcBnnh0gSDvYkyfiUIG0fvIi1sRwQSGrnbBmdM7xEgevtlZ8S9HNhzqgGsBN0oB3wnjTwyza
 FjtrchqMtBWaN4EyfAA==
X-Authority-Analysis: v=2.4 cv=DLS/JSNb c=1 sm=1 tr=0 ts=69d8394f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=wwRk9dV_MJEkmqr9MRkA:9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 09AFA4000D
X-Stat-Signature: oagsdhyzu7ja4bdqpx75ynxmg9e8yjx4
X-Rspam-User: 
X-HE-Tag: 1775778132-715918
X-HE-Meta: U2FsdGVkX19PUkxUofpgLPaEaNNSdKOoNAHwmmusMwZjYjblG0AVafA+d5syG7I1qxkQJfFpOWIua0Y2MnYA9+pz4sMKE+D+N6JDWO44sRkXxJS2AAxJbAdjMz32iCXtOmMb8sQBF9IYy+8zTWVL69kPpanLjJ4goXYyG0uiOfOUHtO3pTG6EYhINWMkNzCZHJPCHw8ZwKv410UMp+Fq+Rzg5V1mOh2IaCdjOeWT5WUO1NAn40P/5h1MhcgCVrP+ZOie2NeYg0qpk7eBq7T0ugUWFkaVqw02BbchVEB1BUs+vFLMcvpa9wsM60aMFIOHGtXZmhi8gA4qwxk/nrW0K5pEC70bWknFyFa4N7gHiNRS6JmBOVSaZfWW5tCSZvZQfFg4Tb7zJR02iArm1qMkjtE+VtPMRJ7zhfd11RPizBPwK6FP9nIWhMMvsLQLeqR1I0Xpn44kKMnuGTYHJ+zrYct2SyczxtSh5Bw1pYq2uU6DvcvUXed1vOc5tO6rEykFmZavZ4v8fq0IFg4d9kUpWcuWScoJTnIgXqzyHbjevHIu244lUoARspQhY/L5PeiNN6W+j0lIipvHB0BrYGiwbH0Dtq5xA2A1phDwTEPohOCSW/59LeRyjmwMvDa/EDTwTjoNjf+eskd0ALxQ925bwYG79uP9fhPfnVtZAHhxag9o3JTzmfh48cQdXzYm7gu38hXi6gTdybAwdURDabv+oJnPNAADwDNUx4q1VmFL1/oo2jcaeiVdCSAoXDsCXv++wfg/VFcqr03Xvn4k79IyDEHpL+BD1AQDG4ApZzLYUda4+V8IA9cBFFwLCivuK+THHY9FxYDRSwRKndZR+1iwx70RzmRfjS4IY2nx8zMgKxR7HdHXjKrASPSIS8QypoOARiMLkDPVR1JnRYNb9tI8o/REDBvCD+7gw84ywz2xZfiIjevTX4yly2T/Iv3Dpuj8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series stems from a discussion with David. [1]
The series makes a small cleanup to a few hugetlb interfaces used
outside the subsystem by standardizing them on base-page indices.
Hopefully this makes the interface semantics a bit more coherent with
the rest of mm, while the internal hugetlb code continue to use hugepage
indices where that remains the more natural fit.

It is based off mm-stable, 3/30/2026, b2c31180b9d6.

[1] https://lore.kernel.org/linux-mm/9ec9edd1-0f4c-4da2-ae78-0e7b251a9e25@kernel.org/

Jane Chu (6):
  hugetlb: open-code hugetlb folio lookup index conversion
  hugetlb: remove the hugetlb_linear_page_index() helper
  hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
  hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
  hugetlb: make hugetlb_add_to_page_cache() use PAGE_SIZE-based index
  hugetlb: pass hugetlb reservation ranges in base-page indices

 Documentation/mm/hugetlbfs_reserv.rst |  12 +--
 fs/hugetlbfs/inode.c                  |  60 +++++++-------
 include/linux/hugetlb.h               |  31 +------
 mm/hugetlb.c                          | 112 ++++++++++++++------------
 mm/memfd.c                            |  18 +++--
 mm/userfaultfd.c                      |   6 +-
 6 files changed, 109 insertions(+), 130 deletions(-)

-- 
2.43.5


