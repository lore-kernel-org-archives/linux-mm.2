Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B1DC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66B66B0092; Wed,  5 Aug 2026 02:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D266B0093; Wed,  5 Aug 2026 02:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05B76B0095; Wed,  5 Aug 2026 02:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 680D36B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:28:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E18B1C039A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:28:48 +0000 (UTC)
X-FDA: 85066237536.30.B337387
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 943BE2000A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:28:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=f58NkVRW;
	spf=pass (imf03.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785911326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BstbCR8L/CfAYlmhbr9LI7ifPPjor2ZWMfhQAtVhUeU=;
	b=lAOs3DGcBzhMDOmhu2zpSVtV1iBQBNCJG0fMgCF/VCuugP2TGlPwSXKVyvOQNB4PDN4Cms
	rIo9MDLHc8zjmsDj47lRVrvvKzZKeBIRWMSj/YbMtcLQIikW0FvxPdQ4lwsk0iLOpZ1Ix1
	oyKy+pNwLr2mnE7xfCcfvL++vVlLyNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785911326;
	b=lnIXzVNscHoQXS79DtPPcU7R7Zp53Hyh/wQbqxEnq0pyy+/66i9hsQz/iuOVCL1mOk2zm3
	aq0jpkD0pQ+a0/hjG0giWmP4daDZQQrmQamo41+4b00JMskFTddLK39bCrHqPIYU6BYGWD
	DhmBPRbFW/SFF6cBwnlR4ZQjjvAXzeU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=f58NkVRW;
	spf=pass (imf03.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755mBOW2909902;
	Wed, 5 Aug 2026 06:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=BstbCR8L/CfAYlmhb
	r9LI7ifPPjor2ZWMfhQAtVhUeU=; b=f58NkVRWqTInkQcnHf2SSWXLsuXe/L+m6
	KQpuSh6Mj3ois+fZgpRLzx06CQmpV5bGl0L3midtZ7x42gq/6nNBd8jyRN1KbmTu
	Wj3+GHncMt5Afl6jPFlgnpsGadNNUbNwSqaIKUYm/PIzaQTmz30jjwlSpm755j9b
	YsZpJIojuGNQIPZVHAKmSnaoLCRjJ0I2DLQuWVBq9QfKv3PdvP1XTzRyUXdWAoaz
	bL1XU7hUWTlaxwHHN2a8KrsUBr+gJrL7RO136gGLPVrct71n3CFkGHqgQ7ncTnz4
	kXsuDvAqviuw4dZ9+6KFBpmrzb5fKOnwZ3IQBbI91umatReza+fag==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77g99mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QGiM028129;
	Wed, 5 Aug 2026 06:28:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fsu4qnfbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756SXT629294948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:33 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DECC62004D;
	Wed,  5 Aug 2026 06:28:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BD5720040;
	Wed,  5 Aug 2026 06:28:28 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:28 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH v3 02/11] mm: Refactor folio_clear_dirty_for_io()
Date: Wed,  5 Aug 2026 11:58:08 +0530
Message-ID: <79acedfb7f3cb1814a68954974da30fd81c655bb.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX8vvbnxdDAfRP
 a6yid2dbDjNjKL+a4utEqt0iJZ4X6j3w7m6yICuI78XPtEaoNKgt1FSRJQ46V9ErM4VcykwAenb
 Qr8uoqWvzw41WmtwjQAvgJpu6dAZitDhHEuRerc8mHEv2R/iPaCBhZ4Ewz0j3QTSGCezeUwthgm
 QN53aN/RalRzgI/30tejS4IpokGLjU0f29YNfKCkXHrwuLtfzH+EshWE2X7/yJvplw7bmzWtavX
 tnx4SKeviPhRdxZbVLhg/JCZmGsSAFq+ocRYkevETa5iWiQs96VK3aYZNm135l9InyejWjl0O1c
 bXiuYjOA7M2vhJfhHQbw7WQ3RI6X6J0wAYFCd3F2zGD3fApwewsPO9BjrK0axBV7Zh3DxL8/qRm
 z3qseVb1OvJxuuEKp3cPeFkD7BcgIezQlA+ft8SDeYSQSHXqg5FEfXQhQKr4f50my6H6LUId9ic
 5GHvHotRelGklvyEuxg==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a72d814 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=GwQEhMSs4eZOB5FW1yQA:9
X-Proofpoint-GUID: _Cu7__fDUJK1eBU0cjcnDPFT61jAT4oL
X-Proofpoint-ORIG-GUID: rCElAljz-VkEQ2Q1yGTn4bfQj2YDmix2
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX9P5Qk2vGZbE6
 xGac7B6zFtoqopEDEkWvw/e3fN7rzlz6TgyWlX1621XLY6+VI7BXaBbzQJi1rrjhSqpQN/+9zx7
 m3HoDAp6JFvJtaSlgIgFLhafxusR3gU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 943BE2000A
X-Stat-Signature: tny81jjgo4uuahzmaxktqem955yc44br
X-Rspam-User: 
X-HE-Tag: 1785911326-828760
X-HE-Meta: U2FsdGVkX19ye6uhVa5KOS+aSBF2yrYdp9XQUjY/Pu97kvG1oaG44W+F4oQDC7aySRo4+kbT8LGlUS5cuGG1HOJajVtF6A+FEzxP3fuxYcUmi7FkqRKlRevx6NN949OrmiGJVqqNTRj7E/vMFwXtEFU3yAWeBTZmgx3xLI+xQ0D0HyXLYRiFtCr5puT6M830z32TgmgTgYJstFT2Sjvj/BSLoKOiUXraiJFD+dR30zfjbMlmtEg/NZgmye6XHe1KWplHr0K8fiq4g6Y9pta5w2tx1lOK9YUdWEMulnLbq1/uRi+WYM3G3h2cNCfLohWxMmpxLRd+AlXn1kBrGOJJBQVDH4T14Z/lxmUTrq4AkKSxyYvoVZjqH2Nh81UE/05ynb2R4Wf1qHoY12z/M3f8suV2AIaNrBwJ3gxl9VZvi9QQY6tuVnSFVx40PYK1/xfHHB30vfwMpxYyai35hzAaS9VXuCrGVoHUwWjWSdnmHZoxz+Eo157GomPJLtRnt1iz70fuQKslacpjCkw8WKvDUoRfcOD3ivsv1e1Qp0TpX5KB6BLp/o3SrS9UFuAPzHQ+vOZUUOkE3YPGWNEnYMt9Vna1QduMyJeGvJ8IfAbVJ0pyg9tH08WrOKHktGz57RXp0DSoX5dntt65SGnoFqQ6K1eCObDyZxPmenT/hkD4YvrWDXrsC7iIyyQDpTn5bTc6/rh/b4wbDWbv6fkJHmMgprPhcBEvzhFrLUBn4P0PYTu8UMPMfFH0tVj5Us3NEOeDO9rZ2SLLLQKwLeFubfXTh6Kr5fvSr2RzAkAl2NttuUi09zTcuXkpIBktL6dkrClRtDQzzNwIQf2L+LGCytLQcvUDGubwVR84gWXLOpUNTYdXldDFOk2pFZIrQspH1IRG/Xf0S0tBQy6cXQGkewkTg4s408cBaXnEC8umcLsyXMWxzjFc7Gjfn05wpRuDi4h6GfusUrCF+JfYJhTkhfo
 wQuaiQJM
 3yNFzWIaHg+RTzw1cNDGLD4PA3G04Wocd9w/XjP+8Ll5HlAscAqtP/WfWDIxPD3XOQBNbyaRycDm3KGnmMArtg+0d6B5uBYLJwHSf3Bh1n++FTCoO48FsjmjwJOhsHUw3vgE2PhdDdD4VkKt+wirNYEfzcRpu7Ba9FnoTxKO0ZsHVknq7k3o9beWavpaDyZf1jf0sa876jYm4isual6t07WB4E/vHIZjjOv/QqzuHBK26c0SSiXLtqR/ZWSOJ85lhNT6WCHlhI2Q5Y60th3E4H6Jz5dOyQyVGZdp5XCkZ2yo9NTqlJ9Q6Eb6J50EOMW62Vzr8CnwB7lotyow11X38gfiJsMdIihGMNBOzcKiEUj6e6q2q3tXglzmFmhLl4fil2RDZ0lbhwAdvsh6Sd36aR8qdHl/j7iIY3oVG3gpMzU7YRgYPFBSEXTdl+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new __folio_clear_dirty_for_io() helper which takes an extra
parameter to indicate folio_mkclean() is needed. This is in preparation
of buffered writethrough support where we already do folio_mkclean()
before calling into this function.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 mm/page-writeback.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e98748112d1e..3d184ca316a8 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2856,20 +2856,12 @@ void __folio_cancel_dirty(struct folio *folio)
 EXPORT_SYMBOL(__folio_cancel_dirty);
 
 /*
- * Clear a folio's dirty flag, while caring for dirty memory accounting.
- * Returns true if the folio was previously dirty.
- *
- * This is for preparing to put the folio under writeout.  We leave
- * the folio tagged as dirty in the xarray so that a concurrent
- * write-for-sync can discover it via a PAGECACHE_TAG_DIRTY walk.
- * The ->writepage implementation will run either folio_start_writeback()
- * or folio_mark_dirty(), at which stage we bring the folio's dirty flag
- * and xarray dirty tag back into sync.
- *
- * This incoherency between the folio's dirty flag and xarray tag is
- * unfortunate, but it only exists while the folio is locked.
+ * Internal helper to take care of clearing dirty bit on a folio in preparation
+ * of an IO. For some cases we might not want to do mkclean, eg, if we've
+ * already taken care of it, hence pass the should_mkclean flag to indicate if
+ * its needed.
  */
-bool folio_clear_dirty_for_io(struct folio *folio)
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool should_mkclean)
 {
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret = false;
@@ -2906,7 +2898,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 * as a serialization point for all the different
 		 * threads doing their things.
 		 */
-		if (folio_mkclean(folio))
+		if (should_mkclean && folio_mkclean(folio))
 			folio_mark_dirty(folio);
 		/*
 		 * We carefully synchronise fault handlers against
@@ -2931,6 +2923,25 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 	}
 	return folio_test_clear_dirty(folio);
 }
+
+/*
+ * Clear a folio's dirty flag, while caring for dirty memory accounting.
+ * Returns true if the folio was previously dirty.
+ *
+ * This is for preparing to put the folio under writeout.  We leave
+ * the folio tagged as dirty in the xarray so that a concurrent
+ * write-for-sync can discover it via a PAGECACHE_TAG_DIRTY walk.
+ * The ->writepage implementation will run either folio_start_writeback()
+ * or folio_mark_dirty(), at which stage we bring the folio's dirty flag
+ * and xarray dirty tag back into sync.
+ *
+ * This incoherency between the folio's dirty flag and xarray tag is
+ * unfortunate, but it only exists while the folio is locked.
+ */
+bool folio_clear_dirty_for_io(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, true);
+}
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
-- 
2.55.0


