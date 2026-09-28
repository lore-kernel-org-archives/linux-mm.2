Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1F4CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D1B6B008C; Mon, 28 Sep 2026 08:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E336B0092; Mon, 28 Sep 2026 08:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD236B0093; Mon, 28 Sep 2026 08:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2DB6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 113DE80180
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:03:43 +0000 (UTC)
X-FDA: 85263036726.03.11555FA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id BF3E9A000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:03:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mRJwI6Mh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPrT8PQRwKFYocNOzdGCoruRwlJo+jhllToPk78w6Qw=;
	b=b9B9NbTh/PPs7dASfrjAzQrZJwQigZbeeQHGpXocmY52VxBICQ4UPqiGlHqK4O/N6lTkXG
	mwgKQVllh8rpsCDhJ+uVY2/NLZrVmsxN+oDnbADYOj5TvrAsvYa6eX8PHJ/eyuT2njBXjY
	r969iDzIhp/KspQrhI75cS3qyds0/Ho=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mRJwI6Mh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597020;
	b=ERryyrz2IVtx3GHcf0I+EcRvGh8zKjgomAJE3AW0YrinxWh4q7LxTbe/uWr0pu+98Mu8hy
	7rVsDH0w0K153+pnaueu2GLo5Ovgbvcn1AI3d1UuUQao/UyutXhUAdA6jhwoCbbsKoFcV7
	VpZPAMRrlMVJ+lrbyC4HS9PrKZuG3Oo=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZW223971195;
	Mon, 28 Sep 2026 12:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UPrT8PQRwKFYocNOz
	dGCoruRwlJo+jhllToPk78w6Qw=; b=mRJwI6MhuRRVCv4eYXKFL5hRHURKCG+Vr
	IFkY+2QjfQYbI+nbv7z+YxOjTU8IdKbUrj3jJGZg5857b956vGh5y/a+CTBPXYmQ
	4J1Iq/kq5Cu6SHXdpHtvrO0Z0uuMEMQ4kIUwJAss6BnUSC8AJvCyJa3BZnd/I6sT
	Kqb2JCqrfwmZUPL6dFGKqLkRGIbdj+56q3HsStpruXT1EaAbw25+yHafgFXZ6iWv
	/W0MYBFAsHvEzAlbFDqEPm/BhSEX61vzmBREwCoCXIsjJGp9NpMohPNydjnsQbDz
	Ng5gvqMFQBqT18AEENhjmY2yVgEO/suduQkhitoLbP2QHn+qn6b6w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fe0v2t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHXdf027129;
	Mon, 28 Sep 2026 12:03:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxrrw5616-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3PcF11207118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98EFE20043;
	Mon, 28 Sep 2026 12:03:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF67F20040;
	Mon, 28 Sep 2026 12:03:20 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:20 +0000 (GMT)
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 01/12] xfs: reexpand iter to original count when upgrading to excl ILOCK
Date: Mon, 28 Sep 2026 17:33:02 +0530
Message-ID: <c11cc6fcf1e4f591b3b537c2146d594f5965487b.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6aba5790 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=6jV8uY8xD7bpsU2DslwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX28VdEaHGb8Km
 yS5Vi4dq2fW60Z4UnerhNQ6wM56dYgeyxuh2nW755aW1X+8LODUYWTS6AXKVKeKYJAVh+W9lalf
 vFoyTcPvy0yq7EdXJO1sJ5/tmcpn0lQ=
X-Proofpoint-ORIG-GUID: YNVLW5hGbG0aAVPqOH93EEeN_KZYshBc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX3Fb88wBxXVML
 Ts/ECfXnvbjO6rc3IYYItgYSicJWBiOxZaKU3JPbHpejyP1qEiMtXCL07dU/Af7NLOuwIZq8ZC9
 4uUtX5rMoLH/Mhlo3Dq2dXxlWFszWCIzHnhB76OyVC8Nm1HPCiZ+X+V4UioeBgb+PWq5CuceoKk
 biw2z5GcckxqfalbZy446yR37oBqSKdn4IxfrIKSaQ+EzFPN/5yW9mea6vGiI2IwhOT+dLx9Rhq
 xsWNxk72l14CSK2dRHjwD//fr44xxvSuaSW9EsWeRpugLB8D3rUI2CAT1iT4EMDovAocKlM054M
 khhFSweBArz9Mf45BpuhdSn1XtYqyh2xnNBacP8gEMwTeHG8nAlV9zSZc2qsdXKIR6BhOhtT8wV
 B7sMvXF7m7FYolJ+cE0XJckr9Wo1hzfcHEDw4vySL4laeNhqPWUfRa0hm2FLR7XGy0QCUVu5Gyx
 oN+c7aZLTS0jRnOyOsw==
X-Proofpoint-GUID: z8O8q2NLobKGJbo2TX7Si6d9-UpkKZhC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046
X-Rspamd-Queue-Id: BF3E9A000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 67zuk8uoybkkcy7jx63ey9nchp4y5wba
X-HE-Tag: 1790597020-905110
X-HE-Meta: U2FsdGVkX19V5fnvOgtVWTe1Pbl+lXERUJZqYaDFtIFh3mwGkrjXi2SROiKHM33OArzjIo9e86M5WA1K6pe/cTADh2aVuFyoJdb29PvlwKlDGhfkaED3DHic5N20PTBJ4ZdiYss8cZNTztYSOV4yjpPlRjlQVfk0el+VGu7InUNW/P/qTvtDsr76v99YZbSP/GOnWkSUhRvPKVtsMjp4oLuZtQY+pPNJB+vsMfTa3bVV9Uzh9o2gxowlcTncoxOMW7alKzPZ61hp0HtZh8FTkeh6NMJVlxqn/0qK+9EkBaVB/5Un38iyG4L/0j1F1DB3+tG6eyxsb+e5Fk5is+BB3VUG/tFCeL0D9mi2B5mcGFY7vtulIqpGHEG113YBPs+WWDzNgZ0cVrFBjHTz/1RarAY0Jr02o+05jRPlq+nNYYy5p1d+WUBptFlzKqFUQe8HxwxT8mz7EJ+PLhe2UMR5xOs2qwVclsWvY7NpUVjWqpbwUfFSeDyM2bG2B5oolC5SG9l70ROz5u7H+wmAt7cFI6Rz0dM50YywRZr3WJxMJcPx3a1VAWPmvPKD356vJmUZ6wH11ScJkOI0xCAmLdb7HoPkbAJhN4u4uQ6vVH0xAoY9Ap34zE8V9/kZPFbu8DO/lOGcHvXinbf/HiXeJ6z7bC3LfjOMslJIO0jucqcJxyN7gMnPmfK03O1vM1yXE8TcQWCKVB9LVCfaQz4dODfbH28LBIfbxlMvcUfvEbO3/+MVJgC0JshU2rXurORG0XMcDvaCqO8w9IfLMjpzuT36Ij8PZsaQt0YTAfgTQuKzevIerLaJk7fvP+/VuBQi2r7UyUvVANCIfwM095SF6/3VYtp6jm4Jy7t6t5/n6G0DQvS3lT8dkgp6GMlrFyxoZLrsxLHW6TMzYU97XB4UCMudi4J9e7s8Luzy3V8RE6foJ4iTQED2dVksVwG808T+N2r77bh56wsHzWtZIGbGOUX
 T5gSe0Jj
 RCwphTdwzpqoDjs65Z7yyH3Xttz5CvjW3vJllYnV2JVwhRjhHMb0Z21DPywhSutk8CEWFyw5UdunHh11MYbi3FLa+Dv0Rj+v2H+laJ0me5GUoBZGFzoXmGBWeYCzjXb01RNCZ5KShehJ8tniTxGKZ3y2uV6jne5Cry4MHD+WlF4sEqm7LrA7L9sYalwp2ULSK+E70JMVquMhnmG0yoxGlF3x38a25GQ29gyW41Hd163EwDULTUZ8osZOvt5Q1sis9MUtMecNJeRfRD6bjkMDY/ZS2wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In xfs_file_write_checks() when we upgrade to an exclusive lock, we
correctly redo the write checks, but we should also reexpand the iter to
the original count incase it was trimmed. This is because a parallel
truncation/expansion, in the window where inode was unlocked, could have
changed the isize so its good to recalculate limits based on the original
count.

Also, s/count/orig_count/ while we are at it to better indicate its purpose

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d8202da15aca..d53a329b6a58 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -450,7 +450,7 @@ xfs_file_write_checks(
 	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-	size_t			count = iov_iter_count(from);
+	size_t			orig_count = iov_iter_count(from);
 	bool			drained_dio = false;
 	ssize_t			error;
 
@@ -482,6 +482,7 @@ xfs_file_write_checks(
 			*iolock = 0;
 			return error;
 		}
+		iov_iter_reexpand(from, orig_count);
 		goto restart;
 	}
 
@@ -496,7 +497,7 @@ xfs_file_write_checks(
 	 * the slow path when we are at or beyond the current EOF.
 	 */
 	if (iocb->ki_pos > i_size_read(inode)) {
-		error = xfs_file_write_zero_eof(iocb, from, iolock, count,
+		error = xfs_file_write_zero_eof(iocb, from, iolock, orig_count,
 				&drained_dio, ac);
 		if (error == 1)
 			goto restart;
-- 
2.55.0


