Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B61CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BF38E001B; Wed, 12 Nov 2025 06:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3BF8E001A; Wed, 12 Nov 2025 06:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9EB8E001B; Wed, 12 Nov 2025 06:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE9F8E001A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:07:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB1C8C0374
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:07:31 +0000 (UTC)
X-FDA: 84101679102.16.97BACCB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A1DEC0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:07:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LoRQ6ovR;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762945649; a=rsa-sha256;
	cv=none;
	b=AjXTfNkpQksHqJCDl1vBkMj027RzDgUGJ9AB+aVGtWpMUkKS8kXkxS1xIVSycNY/S16Gxh
	XSmG06qCyNZCLE6GqyO50NRWRc/9Suw/nriHr+7VBlpuGbJvLlQ1ITjC848RbzJgbRkzeV
	xDncFmqq5qwAKR6X3RKVBTu6h3mPQFs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LoRQ6ovR;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762945649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVFH6XG0+MNfFYKp/Q4P2dsd/VFw0IA47SArwJQ6BTI=;
	b=w+tPmQoIfbQL7MUZd7Rxx944dkwTLMoc9xlrm7JbEPZo/JLjldCUT7y0WGN1MMCRAvXY5h
	r+TYZJyVhSnh7VQSwlFihiBNd4tZMb5pJ/ua8wUTGO2N5Y7QXiYMvfTTAiXeTe+WQJHvjX
	KjUGeM1ta818TD3goqJK+dHLgvQa8x0=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC7dnSC002270;
	Wed, 12 Nov 2025 11:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PVFH6XG0+MNfFYKp/
	Q4P2dsd/VFw0IA47SArwJQ6BTI=; b=LoRQ6ovRbPWCckMFiKZKVyRS1GcJD8GlU
	Nijsz+8v2/CvGFpXY2e50dj72Taq28bbPFI/Z9NjW406BJuma8KKRLZqhxCieWiR
	nIO5GUpTTUPtimEYiFcU08b/UtPrXWQuXd9D3jOocB5c3nw0MsV2gliXxCKJrsAX
	ZctEU/WAoM/hUUpEKQRjFO0zXB3Fu1lcX7ZsCxngSgWmoerIPfxHGB2v8VAfzY3z
	jiYN6nhIMZk/zvuBCeCIW5XfxhRaktMRtDqZQILcZL+5Xb6anX8CmROsyNm72dpK
	xZR6Z7tl7POBNVhJyWn4FoAkoqLgkzAOp45JTp3lXm9RyH5r3v4yQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wgx0q52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:07:18 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5ACB0Xta019638;
	Wed, 12 Nov 2025 11:07:18 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wgx0q4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:07:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC9l1ZH014762;
	Wed, 12 Nov 2025 11:07:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpk7qd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:07:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ACB7Frd41877778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 11:07:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46B0A2004B;
	Wed, 12 Nov 2025 11:07:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 917A220040;
	Wed, 12 Nov 2025 11:07:10 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.190])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Nov 2025 11:07:10 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
        ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
        willy@infradead.org, dchinner@redhat.com, hch@lst.de
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
        martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH 6/8] xfs: Report atomic write min and max for buf io as well
Date: Wed, 12 Nov 2025 16:36:09 +0530
Message-ID: <9d0ec1039dd3fb40419cef56470ca508f36b8f51.1762945505.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762945505.git.ojaswin@linux.ibm.com>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pufiJPBZmK00VnB_Sp4q2PFNYPTOwycU
X-Proofpoint-ORIG-GUID: gVtj59SvZZWfpitmJWZCYcz7I5_8OHLl
X-Authority-Analysis: v=2.4 cv=VMPQXtPX c=1 sm=1 tr=0 ts=69146a66 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=Xt1C_Ey-aFlpf-Mi6TUA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX4SKeXmIOv3HO
 Ye6oGhayyMmFR3oMpLkif2Y/RFw3/uRw/AW5sl9D2nRirIKN6+6BjrcdjcTDdvrYQKnJTeOaaFE
 qqmgizV5PYhwWexLrotrGlG8yEBCuGbn+2u82vD3qSN5FExI0aXfQDYzSrXhx0l1HqRa6gkSSBe
 2rZjR7Y5IXuEPMjuQ9l5lajhwp9Qyp/1kFVewE/7w6rL5ycO6+EH4MwoKw9khVZimRp9KxMPlGQ
 LuNfAUpMyyycMl0TJMYJRXUl8z7UWioa1ncziuwUKlftUDdGciEas5JzyZyuTFmKyrIDmIjmzHZ
 3BgegXAy8/yRHj+7kd6SHGJN7Xc+zn3/3wl6qsXrZGPjWjnLH7q+5yAoxXowA2gMCLf4+mLY6GW
 b14TkVAhHlBkCy5u1CERwqnHcl/SJg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_03,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022
X-Rspamd-Queue-Id: 8A1DEC0014
X-Rspamd-Server: rspam07
X-Stat-Signature: ypyigrkzah7d69cykp39y3k1ch7dttf1
X-Rspam-User: 
X-HE-Tag: 1762945649-372486
X-HE-Meta: U2FsdGVkX19KD8Uk2PtKh9kJZK87TKoSFewupRwZlTSigT9iweXRwbhCxUvBhTcZgSTMBCJA4aRW5Fapi9BQyepoWMqZBEqd7uRv2CUujV2jJ4aOe0QMcjDnZAJRG2BzIO4DmiyFEPGq2dhBE5r6Pan4VnfA4jLeMm9w4GXFytOfMRrwX141MAB8SnSzeJddAr79B3YKnQAjVNp3PZOf4YPTWIP/uoogYrxJWQqbz5mcoXTvnLX0IVgfpEbmAzIxFZ3u1abA/8NVxY1ZOpgeX1a3veuo4vd9JFdm1RRolyRnerhjxaAKB8adX/33WCMzLTrjnmLbitisZOgOoncsowS4kzmcqmmGVr9/IbxgUOENpNi/FhIgFCetJVDItR3jeFmKafq5HvkI7Iv3OrsKD1lBPz6WZQ2Gl3M3Vu3afWyM5dl95z+/+elwD+TsQr4+OmHA2HSMQfQTa+gsR5c7n4t2vALxpVGfbpELIpvY7h//kQYIi5sX3HL34MBNQifyhXpgeOqLKmYyxce0MghTmxytbzLuImZX+9ZNUFQH6KJDvXKLi04tUMhvESfO0Sf9xgLDHo/A2wCm+aNQSjcj8kuaZHQ8++rfOhcGp9ZsQL01RCBBbduel4Qu8ryNRqWrFDE4Lh/dTMbh2m8zlaZr/njvJferYAoC2uZUHLgkFdZmNDvgB2DrQbHZxXPSyhwLzbWlYYfrop3OtkO3OcoE+JT+DGu1fBXWe5JGcUb4aGk2CeFTjmfHGQdQ8xfFDwUOBeZqczAlmbkmjQfewjXukjYWbl9pGfyNVQ6bstztdxIH+i+5Nw0l5f+pupb547jA1pSL7Rvyh3mJiNKSwJybCzP/UtxNr2DB+36VQJDA3BS8CZ28LHFVRdXnRwL8wIExM8CLvNUSXUys3YhWfCF5ExQpkFYO7DlbmthScYMGegwj3B6aDzctaxZwLJ2usboFKt5NxVQI4p4BY86BZO7
 ujADhjLm
 ydKm5jcQFEr5OOr4DaYiOFgwM593MGvr4GuqWr2fJ6ssBaVZOjKOkTKFAsY3sDoSan55mK7kPaTqmOXVVHoEE8Ulz4n79vBSxHPkZaKDiVO8te798QSG9qCXjV5HCoHTFrID3XwD9MAaEvvtg9d0g6vfw77xRB9njuXinC7PqmitvQ6eBsUZyDGkBR/Y7MZXmenU5sPCF5uYla+YCwduMJ+bNw33cIyLrKnYTm1T16ywZOTNIsJAvtj3bLEWhm0rvdokDDnhZe2AHaeyjV+oprp18QQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we can reliably perform a HW based single block buffered atomic
write for page size == blocksize, start advertising it in XFS.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_iops.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f036c46b19c5..67d370947d95 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -604,9 +604,10 @@ xfs_get_atomic_write_min(
 	struct xfs_inode	*ip,
 	bool			is_dio)
 {
-	if (is_dio) {
-		struct xfs_mount *mp = ip->i_mount;
+	struct xfs_mount *mp = ip->i_mount;
+	uint32_t bs = mp->m_sb.sb_blocksize;
 
+	if (is_dio) {
 		/*
 		 * If we can complete an atomic write via atomic out of place writes,
 		 * then advertise a minimum size of one fsblock.  Without this
@@ -618,10 +619,15 @@ xfs_get_atomic_write_min(
 		 */
 		if (xfs_inode_can_hw_atomic_write(ip) ||
 		    xfs_inode_can_sw_atomic_write(ip))
-			return mp->m_sb.sb_blocksize;
+			return bs;
 	}
+	/*
+	 * Buffered IO only supports hw single block atomic writes and bs == ps
+	 * configurations.
+	 */
+	if (xfs_inode_can_hw_atomic_write(ip) && bs == PAGE_SIZE)
+		return bs;
 
-	/* buffered IO not supported yet so return 0 right away */
 	return 0;
 }
 
@@ -630,7 +636,8 @@ xfs_get_atomic_write_max(
 	struct xfs_inode	*ip,
 	bool			is_dio)
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_mount *mp = ip->i_mount;
+	uint32_t bs = mp->m_sb.sb_blocksize;
 
 	if (is_dio) {
 		/*
@@ -640,7 +647,7 @@ xfs_get_atomic_write_max(
 		 */
 		if (!xfs_inode_can_sw_atomic_write(ip)) {
 			if (xfs_inode_can_hw_atomic_write(ip))
-				return mp->m_sb.sb_blocksize;
+				return bs;
 			return 0;
 		}
 
@@ -653,8 +660,13 @@ xfs_get_atomic_write_max(
 			return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
 		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
 	}
+	/*
+	 * Buffered IO only supports hw single block atomic writes and bs == ps
+	 * configurations.
+	 */
+	if (xfs_inode_can_hw_atomic_write(ip) && bs == PAGE_SIZE)
+		return bs;
 
-	/* buffered IO not supported yet so return 0 right away */
 	return 0;
 }
 
@@ -679,7 +691,7 @@ xfs_get_atomic_write_max_opt(
 		return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
 	}
 
-	/* buffered IO not supported yet so return 0 right away */
+	/* buffered IO for now only supports 1 filesyste block so max_opt is 0 */
 	return 0;
 }
 
-- 
2.51.0


