Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5550CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 21:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D8B6B0092; Thu, 14 May 2026 17:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56106B0093; Thu, 14 May 2026 17:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE4E6B0095; Thu, 14 May 2026 17:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB7D16B0092
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D1D21A0709
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:55 +0000 (UTC)
X-FDA: 84767373390.21.19BC7DE
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id E195918000C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:51:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lVizpkSM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778795513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiFB1XYNEx2p4p1r40wGMJ8MJmpntx+6yGMPM/Sx6+E=;
	b=wTriJMgbforpbnWKeXL8WZjQFVMeuaX4KRllCLUbVgvaesgMfzVMLThqSo0XW2DNubDmVs
	6P4Qeam4Sji7HOUkEZu388LKa4SQZDSYJUrDUwW0H8qWRB6idYRz+pwmsCyUd7ErppPUfC
	d4G4q4siri9CSFuRz2alHV8x5xAbcJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778795513; a=rsa-sha256;
	cv=none;
	b=rLoUFp4iJxs7JTYvXBAATKFo+xH19LdCBAu4OpSRJow3xRvsbe6aLxyCMpoDc5KQp2SEj7
	WVECmz/Vm5ijvmItrFx5sPz54oLi4TARp7lHMkwWMtqKpg1UBNNsVVYvec4EwsPqa3rE17
	pMNH+jNDdwHyIhceBuqRRp+7aFcj0lU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lVizpkSM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf24.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64ELgaxo1544846
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=KiFB
	1XYNEx2p4p1r40wGMJ8MJmpntx+6yGMPM/Sx6+E=; b=lVizpkSMqP3/FNMIKfpJ
	2hYHvrsvlJYHnoo3y0s5a04k3jgVNQAeOD6ig9ZVde/pTJtE5K5rxyPO4de+aDsX
	qH34Q+J7K0T3JD5Mx1wAx0Bz1gRqXXDQtW04vtheDJmQIP/aaCX7y0Jj7pFZylPO
	VV5rlxyWSwj/hMDAXgjPY7e+bDDxuKwJK2VaJsxOfL4PHNQf+4Z7MxCEj2VRgohx
	x4La/cHrHDCpNTUc7iLKyDPFgO+0LerhtZA2C6OymuwDDAG2I7U6yoSzRHVYhKzp
	MEqCS0cxojwtxF5sSKiCMmL5UMtOVIQeReQH7pNSDVe25Xcc6171h3BdIBw5LE5g
	jQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e5m25hdsd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:51:51 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9114ffb5d86so112259285a.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 14:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778795511; x=1779400311;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KiFB1XYNEx2p4p1r40wGMJ8MJmpntx+6yGMPM/Sx6+E=;
        b=mbp/AgjfovrJ6L0GnUhPu60atlGNpimdQ1uQ/FOhmh2EryLLAg3aVI8sw6fW4s1/ad
         GvfkmFkoHHZJQGXG0ab13Y6FVOcEa1qMTTIGxi0ptLQWqZN2shzq3ixlT/1Bw2yiHCm1
         tNJMtBh+XbXT7yNogV/X0rEVQPW/ffUAfxH6AKeLztbm8bmu4e/QEbHRe6BKPcmJq8tk
         QVdzIl6T5R5tny4VwpcXQYMo8UYnZlgRvtDQSuDlpN+yiEv4Ujj6vI8bH9ax/UAemWMf
         MGR74xuZagvoT6Gz0/yp9tlCnkyPg2nUD/y6UvRV90nkB4Jh053C/wpfHG7Q54U3oSLg
         ZnaQ==
X-Forwarded-Encrypted: i=1; AFNElJ/B0dmmFp8qbaPfIZyxVD7hsXKUmn/PEewgdpLVJuxDEe6jjwoxNCmFGdvKXo9cX7WC38xcWeRXdA==@kvack.org
X-Gm-Message-State: AOJu0Yw/DBUZ8qqKm75HIa+2IW/1WhVlJbrOyvz2mBGRnSKj1UgLFeAl
	J084b9aoysnaZVBt50/84CsK2nJNcE9WrmQRX2E/0TWD7TjtwRk8BrDuPIT7/rtQ9xZr3z+z4LB
	ecdwFXnCKWH8pFsc6e54LB0DVNd/5S7wlypjXp5YgU/BSHrZA
X-Gm-Gg: Acq92OHrZ3lc18ICbvM0GzbkPMEKackzPMf0nUtr1y0l5fcOmSthy1iAcsFhAze5bnj
	lmc0TTjDcg7MfKJe5k0x739BQkPtYuvhEeE53L7sQSu1OHzuaZ9P83Dszqz6RtMFLaF8khzI0y1
	M8H69QViXTICYsgBtq6xAYruNv+zT6kTdLC3wiwnlhAUC6fJpeHq1hGn21+5ecsi6uJH2L2q/7c
	Tc8gy/4lb+sLzrcvihNc4q56bf3e1zge6v5s75+abqHF8FdkaTaNDlHJOctCr1OnLH4kYjk0U8K
	7ng53cMZq7IPu4WawTxFHJVrgXh00qgkx/mgk/M9utXK4iKUOqeBndg7Uv2SCzh581s5LRNyR6N
	YrwLxLsfjdwRN7+f+4rVXe/g1tPE9+nstlhWhcr8nRWs=
X-Received: by 2002:a05:620a:31a4:b0:904:f4a5:ab76 with SMTP id af79cd13be357-911cd8572famr230869585a.3.1778795511112;
        Thu, 14 May 2026 14:51:51 -0700 (PDT)
X-Received: by 2002:a05:620a:31a4:b0:904:f4a5:ab76 with SMTP id af79cd13be357-911cd8572famr230865885a.3.1778795510670;
        Thu, 14 May 2026 14:51:50 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.229.175])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910ba18132fsm354966085a.6.2026.05.14.14.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 14:51:50 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 14 May 2026 17:51:15 -0400
Subject: [PATCH v6 2/4] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-blk-dontcache-v6-2-782e2fa7477b@columbia.edu>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
In-Reply-To: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778795507; l=3015;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=cKMEY2qMe+ThIRuTqPtJK/4lqWcAKsfKxgMzaSM3Nxs=;
 b=EUSRdVenMg2q2kdAIUHNovBRSRrki7XEbmF5ULdT5lQWRq5+xfggvWhH1KNRKBXyJKgw/JuBx
 lcJ9tESwNybAtxuwQcAtvSMvqi8D3Ob2J54zMF5tDxhJkwMV4Tpj6IN
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=JOcLdcKb c=1 sm=1 tr=0 ts=6a0643f7 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=nkegbr1AwBRna+m8FBH0UQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=CxwgBoAeUDVvfQxjk70A:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: uaxaU6-EansPXruX2j7NaRcdpzrEbElP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDIxNiBTYWx0ZWRfXwNB4474owgl1
 d5+N1ueDO7oAXEk8JT+vz/oAEOlLmTuJNaJW8soMdF7CTgiz+ZSuRKs/E7dmDj1WMTMH0t+rIPf
 U6Lb98yL/I1QwZCWZWJ8ViuYBEkn/pwT2ObbTBO69p2lZypVt2SGcGPWZ7vbGmbEOom9GeKoA8z
 r7KfdrBU4UX+a0azfOMfDTQcpheayvDrDl12KJ2Gquggc9qw3YwM8+kZWH9cp8Y/+j5UUoZuaNM
 EQFuWttbQvzad6iUn40etLbqE5xb1OnCtW4egob9wNQ9u3FksVE9oO1Q3ZDIoN68P2HBUAnAx4D
 006+Si3m+kzfXIdWRQa7hOo6tA6L+cY6C+6eEvfiS8IYcs+dvOSyATo9rrE/qP+MebrEyb7qk3A
 2gp4YX0DDTcMuKttaLXaUKnH5kUKLOU7jr3LucutBm64Mm/VIJMQHdSLH36JsJnXy7NNYVzGo3F
 zrE5PGFp3s9FeQ8Bv5A==
X-Proofpoint-ORIG-GUID: uaxaU6-EansPXruX2j7NaRcdpzrEbElP
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11786
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 priorityscore=1501 suspectscore=0
 bulkscore=10 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605140216
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E195918000C
X-Stat-Signature: dqe6k11drwwn8o5xaq4jz78d1ajea84x
X-Rspam-User: 
X-HE-Tag: 1778795512-227219
X-HE-Meta: U2FsdGVkX1+DLe7TrMq+UKH+HRPDDCSVdIcZ6Am2lEBulvH7ZbkSS8N31R8oyTnv2K26pLSKRzJgtpa+QdX3J98gQv+n4IgXHKlygZn4tn/kgJVcYDeqEx5R3xVPHSOKma8/PX/EYzFvG70XEBH0bs84NefJU0dk/CvalsbAoawm9H7Pivs3339eW8isQuKuxFsYNPE+w3LwKVHYto/9OTU6rymVTKOdllDlBN1CDgs/5JBFvx1O8cOKtTYkQDKF32CFf+BgRGOttHDTzD1R83Cuaz8U+EKS6+P67VfPIh26GDGw73ALz2cv/rnzqn/vqo0V+LgMut1Vvtn0I6FfBNbMKJPAPQh1/GjRlnFRLIK04BbYVRYer3gsBgt1w7S7yTGFKOzaBLpvabBhOdaklCpWN0w5suSD5m4bra5sre6RL9V2IYQkjGCsltXkPMrnW4P07BsKfu8gMGPnnyHbbf2b7QGHOkFj0IWkiHvFRap0Z+xSFYlOAU8+BVZGhaCQiGYyZejXNrC9kwnqY2KHCncKJCGbTijHNIrdptn6ASGq1ekAOe+udvT4syj4r+GeVy38LxuAQKIC/XfT6s2v4Kfbwa6+WPMlsSJwIo7vSpnuHH16gDG2J3fRIe3Bs8ZKOMsZ+f/cwUITN3p6jxl0S1pr5EC3ysj8311Oz+dfU+MfbcOOAfLOK/Z7tfhDzpWMPqzsf7ZSjTWbd2AaTSgu7FjPfMgxEEoGfnR5jj6cWgaOSgXJUPhbLqTgis3Pjm6hGWQ8OcArBBA5pqvMNpLu5mmtWynYGz6c1/xhYW8YF+cNHdxuJlyzaqKGSeD0i8Z79ae1t5fefEe139+TbJrfAXuq2r44Vt2kElu6OwdnB0bGmmjQZMhwAQomKrrfMA94BgK56vqkB/qwhbogTn2F0Qdvxckcs7Gqlvk1EJNkll9xNtjLHfWZC0PG+Ay6SZ59SU65QJhU7d8SIaZgGla
 dL+lxW9F
 FZ/HqECqch/x6WVG3fQUs1nT8XZnI8ZWrFJk//sr8fdNWuhhxl+RaWrGdsb9XnHLKFZOJp6K8G6ww7RZWKl0lQVpNZkK6EV/hz2j2ixiZc+KkZbCiP3e7GQMbv/MCrEfq+KzcfKNBxn+n2uRwhO+PVB2ZCEjAKptqdfzPMJ/aM3mmBVHu0sqqnNikkCW54m7xiFK/Eenx/hdxDLl4Ev9ac6d4mdAYO46ei64sXHYT0O8lkiN4GX8EG7/VXIE05NOqbHMTmye1b4nTpUPrdoqVZH/eBvplJq6Y6bUjd2EMIYNv3iuMf0m3PU2rk6MyXt+JwEkuJexl/1NB85Kl8YnY/DqmQ8ywGRxOFTjfEdUIxKTc8saZgh9yGrADL/HBdXeD8YJ0HbRcRDOCi+Se2wsQhY+vFNv5X8c2WfbWlywlGBrVUbW3dzmA048q9ckADirmo7lw0OC6W8r7v+A+8P5nnXfab0eRCPAmULsAQcwUC2uKCkY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
is added. This ensures that bi_end_io runs in task context, where
folio_end_dropbehind() can safely invalidate folios.

With the bio layer now handling task-context deferral generically,
IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
route DONTCACHE ioends through its completion workqueue. Remove the flag
and its NOMERGE entry.

Without the NOMERGE, regular I/Os that get merged with a dropbehind
folio will also have their completion deferred to task context.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/iomap/ioend.c      | 5 +++--
 fs/xfs/xfs_aops.c     | 4 ----
 include/linux/iomap.h | 5 +----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index acf3cf98b23a..892dbfc77ae9 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -237,8 +237,6 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 
 	if (wpc->iomap.flags & IOMAP_F_SHARED)
 		ioend_flags |= IOMAP_IOEND_SHARED;
-	if (folio_test_dropbehind(folio))
-		ioend_flags |= IOMAP_IOEND_DONTCACHE;
 	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
 		ioend_flags |= IOMAP_IOEND_BOUNDARY;
 
@@ -255,6 +253,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
 		goto new_ioend;
 
+	if (folio_test_dropbehind(folio))
+		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
+
 	/*
 	 * Clamp io_offset and io_size to the incore EOF so that ondisk
 	 * file size updates in the ioend completion are byte-accurate.
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f279055fcea0..0dcf78beae8a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -511,10 +511,6 @@ xfs_ioend_needs_wq_completion(
 	if (ioend->io_flags & (IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_SHARED))
 		return true;
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE)
-		return true;
-
 	return false;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 2c5685adf3a9..fef04e01116f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -399,16 +399,13 @@ sector_t iomap_bmap(struct address_space *mapping, sector_t bno,
 #define IOMAP_IOEND_BOUNDARY		(1U << 2)
 /* is direct I/O */
 #define IOMAP_IOEND_DIRECT		(1U << 3)
-/* is DONTCACHE I/O */
-#define IOMAP_IOEND_DONTCACHE		(1U << 4)
 
 /*
  * Flags that if set on either ioend prevent the merge of two ioends.
  * (IOMAP_IOEND_BOUNDARY also prevents merges, but only one-way)
  */
 #define IOMAP_IOEND_NOMERGE_FLAGS \
-	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT | \
-	 IOMAP_IOEND_DONTCACHE)
+	(IOMAP_IOEND_SHARED | IOMAP_IOEND_UNWRITTEN | IOMAP_IOEND_DIRECT)
 
 /*
  * Structure for writeback I/O completions.

-- 
2.39.5


