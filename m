Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F96DCAC5BB
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 12:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874ED8E0003; Sun,  5 Oct 2025 08:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BE98E0002; Sun,  5 Oct 2025 08:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762558E0003; Sun,  5 Oct 2025 08:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9E68E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 08:44:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20467160328
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 12:44:14 +0000 (UTC)
X-FDA: 83964028428.08.647CF22
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4EC02C0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 12:44:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759668252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=eJl/+aaTuhyrXSrnWnPVGka/1fkCIDhT5kHvNyOretY=;
	b=VgeEGmsWvjyon0h/ZewfhkP5vnODjGjeaqlgE8SnFbh5ECHKtT6ch0/Y41XGRb3eSIZWbv
	FqPzfiUyFIb9Wvuys7bTV3TgYsiB09Q30SUjrJCdLiM5eXjEC1CtlsdI47IssXjCPw3NOx
	P64/Th2qX8mJzHc99wyF9BLEN1wEgk4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759668252; a=rsa-sha256;
	cv=none;
	b=O5jtdYZjiqsKq8JAEVnMmgEpVdKxw6/vDFEwxazefg27XznnCHl4X4wX/51C/+NSDylwlM
	lZbmdqUt/ztamOtkzsd+xKMHdURAr8EdR5q3/sv1yOKAsM8Jn+CCA8chHW77u4beiQbYJd
	hekB5+zr2RQgfFCxFbdaXyrNYBJhuQw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wangfushuai@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=wangfushuai@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
From: Fushuai Wang <wangfushuai@baidu.com>
To: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <david@redhat.com>,
	<mhocko@kernel.org>, <zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>,
	<lorenzo.stoakes@oracle.com>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Fushuai Wang
	<wangfushuai@baidu.com>
Subject: [PATCH] mm/vmscan: Remove redundant __GFP_NOWARN
Date: Sun, 5 Oct 2025 20:43:29 +0800
Message-ID: <20251005124329.28708-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.127.72.13]
X-ClientProxiedBy: bjhj-exc11.internal.baidu.com (172.31.3.21) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Stat-Signature: yns98pn9ek8uha3i3dhhxw8n3nqwbnft
X-Rspamd-Queue-Id: 4EC02C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759668250-504848
X-HE-Meta: U2FsdGVkX19iM9KOlpAX7IFlUhRpAM3w/1NdDqH/o25mfghxVVlUOu3XMnSb4EqgWcSV1PWGsy38fkNw0VYuLmuLWDXTXyJ94Fp37qwFWSxxMutqf7nOsLQLqD8BYpSUvWw5lhHRzeYT9+n8u9nwRTiawFFe1tkgNwkmHxeY6ISv3MVeytkphWsvnQL+i4bhQsNs6QBGKVMAMjTuL/pKPjIjcXoqvCqElQej9235P+YU7cYCLEXi3wLY9ioGsAM6GznWtfaXraNmt+9G6G3TjVYwcKB127C5PCq2lCfHxrJ4QGLJrjo774RpUCr2pNf5LrnHaD6sDmOd4Yb/AqE+RSDadpA0M2sKE/+oD0Tgt9kQ2R8KWYmXPo59l2bvYtN4ZhZYas0DFmOCVYhjGiKfOpffTxLuPgbwCpXRBn1bNB/mngaSt5BuvDpZNLgNlB+EX13LC9DGjX7rKojS+7dcMYaLIrtUC1w/fMKpa2eTnamkMyP6rytjbKrIsqqIqCMaVj8ekCv0hC5gWZcENpobHZtYnx8mmb712+deHp+yDdx5PTwhr4PfXxqMfCUYJefrPNQkGgUh1TbjLzFU268rBC4gwTiIcTIrZJAOKKr7aAuNznvBNvCyJGXt/Pf7sqX7CA5rkmeHpjOI3jqMf8rIFX+1LfSZpAxy/UuM3m13Hwc3JMpZCgu3OUIil6ovvSiEtipoJGxx9zx0c/XlZheQTzCxwRyhEH37KOTynuwasoPMlNOwTkWkRvyw0+9K5xsoPDFaLtEdYeOhkDp56/7EzAg6+iXYSwENpuYbZWvDqnfsRrYLPieTgYpBPtmZ3pta1tWdvcYWYlOWyQtqa5glfNyMAAEXggLrAZh78phliIYjBXD66m7/FuUh4Ed1QEtoir2vh9aVj79zt6PKNQLHEdg6jjvcL+Lr6j9aOkZ83Tix7M+s1tGyFsDX1QnOjEVyMphy1YaUvHZV9PHkASE
 aMydBoiH
 1Cy0I7BTEqxVyWjO2/UDFnYGXBcpSzgaDkRFoRGsbzu0iq0OpyxFJLrOKcZ2bzBqZopYkWcn/R7hcYLr7w8iFvk/LljiB7xckuD4hsQH5ErhGHe/JTkxkpQxG3AYEB8OZ5lS2pP0CsQU5b7v51upV69+xYJMb0rwnV/uS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
remove the redundant __GFP_NOWARN flag.

Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..2acb3c09fe0d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1054,8 +1054,8 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 * When this happens, 'page' will likely just be discarded
 		 * instead of migrated.
 		 */
-		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOWARN |
-			__GFP_NOMEMALLOC | GFP_NOWAIT,
+		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) | __GFP_NOMEMALLOC |
+			GFP_NOWAIT,
 		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
-- 
2.36.1


