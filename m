Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8938FCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93F88E001E; Wed, 12 Nov 2025 06:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B9C8E001A; Wed, 12 Nov 2025 06:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81A38E001E; Wed, 12 Nov 2025 06:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78538E001A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:07:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9350712DAC8
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:07:42 +0000 (UTC)
X-FDA: 84101679564.12.C10CCE3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3936F4000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:07:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pOB7QhmM;
	spf=pass (imf01.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762945660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lS0PV8URMxmmce+9yYxA6ZwV8ssL8Pfv2N3KgoOn0Oc=;
	b=IgFEhlvBkSNoER/UJ6YTrxnL8IfAQW5ralH+NcxGMJOCc5qIPYTdx0DlKXz7ZvkcL1x6Yz
	PzXeL6irFXjuFInC6g1daUR70I8ME1DR7mgFMpPHDgZl4TkQ6N7awjDWj8ORVJRtcLCKkr
	hXmDmVVqdXEZdhXBoFom73gotcOh+ps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762945660; a=rsa-sha256;
	cv=none;
	b=U9PB7482aBvO6kU6bpwaT7QgmmhQ1sFMvEmMLijMJLVMKinrFq47fZGcchZwFKl3FLXKCS
	DMlhJZeoH5j+BIXQtJa+fQyoNPvs9vB8G+aDoAJCTjYUvqbgLcwQhtYnn57Rl8ZfIEZB/P
	yw8A0i3mOD7KvpdV/srYDyeVuzmzcGQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pOB7QhmM;
	spf=pass (imf01.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC6nTkG028520;
	Wed, 12 Nov 2025 11:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lS0PV8URMxmmce+9y
	YxA6ZwV8ssL8Pfv2N3KgoOn0Oc=; b=pOB7QhmMKumE+2Ewk0J81JPbGPU/jfzXZ
	lQgYDaIKG+gR9FpX3LyQ1Df17NPun1GTooeAH52oDLyC3C+QHRc9BFPG+AdHTtRK
	wd3snm2oNdwwbMjZWANEa8pjXp4UVeYb3I35p1dPa9FkbsNLzBVusbf8HneBkgCu
	WWdXYPdOb0shtMsvVEPkhTRbJLESYAZuFF9BVGl2dVaYR7atgSYipSdQ0/6K5ITD
	8jjuzmu7DRI6F2rDTpTwvxzmkJ38HY6rb5/MRfSy6cIMNMotYCAvL+u/xFVOKmiv
	7lCR91WMcv+TU7Cf9jENRnTa+9o3RoEiquKFyM7RakWr9H/okbCow==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjymnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:07:29 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5ACB4SYB022695;
	Wed, 12 Nov 2025 11:07:28 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5tjymnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:07:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC9QpsE014859;
	Wed, 12 Nov 2025 11:07:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpk7qe4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:07:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ACB7Pg551118504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 11:07:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D83932004F;
	Wed, 12 Nov 2025 11:07:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F267120043;
	Wed, 12 Nov 2025 11:07:20 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.190])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Nov 2025 11:07:20 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
        ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
        willy@infradead.org, dchinner@redhat.com, hch@lst.de
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
        martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH 8/8] xfs: Lift the bs == ps restriction for HW buffered atomic writes
Date: Wed, 12 Nov 2025 16:36:11 +0530
Message-ID: <0f1f53d6fad8c25118b0348b0cb91dc2e4ecf456.1762945505.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762945505.git.ojaswin@linux.ibm.com>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ADQK4HD0lQecC7xUBvMAVAknMXJGVpEF
X-Proofpoint-ORIG-GUID: iQAnc7Mvlf5AFos0tKRg3f3C_4ix3pmO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5OSBTYWx0ZWRfX52SSPqtKtk4i
 cOa+6iOjuAAo2h3dK97pN8YCSCEGsYjvxno1zsFcUvQEs8u8QFoS8EVe4pT0zpMsHpPdVwbWA1T
 0zo5RABNZRExM0hTMZPRyOam0cl9R1euNDPgYUagq4a1jUJQXcD4MdbGR+DPYm19JsbetcQDbLp
 IQpdcmM02Hdswz10zt3coYGH2sQxqol1aaRs3Nno9T2vFNe2dBPp59Ks7j3Pe37MrPuoZmS3vVq
 +ks1ZnAEyrV5uifEEGDaPOsLzfMeDcTgtT/VBdftWRhkKkfyZsXRrAFwJW7wHSXcMsDjNIQg+am
 ejhzNtQRfiKZ7AuNzA5NnblMkDmXntu5WTp1V7TrOlqMmUnX3jgGAQAU45KJ5jLteLGR1AUaDQy
 OsFaBLrhNGF97igEbAhLryJJS6zuFA==
X-Authority-Analysis: v=2.4 cv=V6xwEOni c=1 sm=1 tr=0 ts=69146a71 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=PLfzAVb2A4JWLM4niBMA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_03,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080099
X-Stat-Signature: sc7hr55n5zziz7cooxmcn8yc1dikzzje
X-Rspam-User: 
X-Rspamd-Queue-Id: 3936F4000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1762945660-252690
X-HE-Meta: U2FsdGVkX1+Nw03GGGWKDT7iFMJftlyaB/L91W1rzekryDNVm11flX/DwKdpusxE72yJvgZ1Wh/hFBrERji1tjWjWWNMDF04ofFSTZCHgBlPG6m5Sy9l0pomxaUcVL3vE9yiycxRVjm/2IwLhhSTKwKeDQN+XXeSChgcrgjnZjuTFH6UKz7KmnqqmSsv2iWoKClaaxyHESomXKhD91ZjJ/iE7f8Nl6h06RjVsD9RcwPcxldpjHXA4o42ZSKvbede6YKQONAhx62I4WFcYicDZh2PVQeq5of/dt+9cteBOrvQhMuLxFZ0vDnQtFhrVMVanuYjRP0xHgjRQPFF+n6dj7/BURCfnlPEVOGXgb7oKhr6SI1nneTlxyGgaW1GqIDykdXmt/SHzMX71ATk0eXEROR33uhUlVem2Y+sSTLvW6GRDBma7DsoyPOCdZ2Kg2W4K6EhQRTtqB3fxHWmLDXePBDV05WF5Eb/dzQiWMoX77zEK8CXyZ/ICJbIpYi4/Ka3CpKhkizpaCyKzGevRgsPAyyrt6G4AmE0mNXnsQtA/z5AZ912FeXtF97TWWbM/Q/1ba/mVUAcBjJe0uFuivL+Is6MWF1Qsq8KzInqh+Dko+kwWlffY6/crVZ/BHRmsTFr63l+4QAn368iEePCjaR5EoqT62b2hUs2WwS3rFslUycnP604sZ5uwYALwW5d9/7zj3zRn3/4fpL3/AKa2B3IdMy38EcjI+I/jr6JJ6bqU3q2HQtFFITUQMwCPEQxCBz0i/d9thLn6nhEuxKtCxJRoGXOk11/S7ZQYNfHnLO1wprvC7J0CYCV7wEa4qScCVsap9CHRaa5r+xG6jhHiMtBTgGhOnLTcdMOTcTGKGWa69N/f2ol4ltIwutrtLoGAVG6l+KuXaUJ8v3pZ6z+wtWNum+eIqpDnr0bYmB8xred3c4+Ykr502PNvcTxWvz0nPUE7BiOGrBqAH/frzfHApq
 nvgEvCBi
 93/5i8S4aJ6++HMRkjJnfxKvAbi+u29UXK751XgDuQpVK4iANCOpVfOn+YENikFxTWH4SepXImR578VTvq8sVpgm9ke7WLPk29nu8IlV4XhlE/GE1bnKUQSMU/dLfDsdXGDiT8RCdDZOATtIBDcWYXGCZjbSZRvDyFFJR4MBj1JouawkK9C7yRqPaWj5wo8oc0iMTlFWtYHiEFgbKRsLTrFvb5i1+mTzDUPgK+69Jv2lxn5MtMgXQxAeTlEgSl5nbN2ac2sA5wi0OWLE1XsS0BgGUHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we support bs < ps for HW atomic writes, lift this restirction from XFS
statx reporting

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_iops.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 67d370947d95..5bd31aacf514 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -622,10 +622,9 @@ xfs_get_atomic_write_min(
 			return bs;
 	}
 	/*
-	 * Buffered IO only supports hw single block atomic writes and bs == ps
-	 * configurations.
+	 * Buffered IO only supports hw single block atomic writes
 	 */
-	if (xfs_inode_can_hw_atomic_write(ip) && bs == PAGE_SIZE)
+	if (xfs_inode_can_hw_atomic_write(ip))
 		return bs;
 
 	return 0;
@@ -661,10 +660,9 @@ xfs_get_atomic_write_max(
 		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
 	}
 	/*
-	 * Buffered IO only supports hw single block atomic writes and bs == ps
-	 * configurations.
+	 * Buffered IO only supports hw single block atomic writes
 	 */
-	if (xfs_inode_can_hw_atomic_write(ip) && bs == PAGE_SIZE)
+	if (xfs_inode_can_hw_atomic_write(ip))
 		return bs;
 
 	return 0;
-- 
2.51.0


