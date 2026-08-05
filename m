Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25545C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7D26B00A2; Wed,  5 Aug 2026 02:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0196B00A3; Wed,  5 Aug 2026 02:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D9C6B00A4; Wed,  5 Aug 2026 02:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B456B00A2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:29:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A94E380392
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:29:27 +0000 (UTC)
X-FDA: 85066239174.24.9CA9201
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5CF7F1A0004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:29:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=m4KkAuK+;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785911365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWT8aCk7wXj77exlm/RNCevEhNoqqekH+wF/8jAK3ZM=;
	b=vOogWpSxSNHdjfojTC5Wna63TDWm/CQr+cLlymv+qdtCMAY8xNGschUqWBrH+Pwlkmr3fs
	G6l3MDdpmhIQZvU9TBrEwNJgRfiBf9jLqRvR2vz7EgDoDvB0o5OtKvDNdhlg+y6wqE/9V9
	l7Kyyiao0ZJ1Kkkbrl9adhKxYt3cys8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=m4KkAuK+;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785911365;
	b=e38bO2rsrdGLa3txlqy2kaPP5vLwPE4+qU2ygu0SUgsga50KHl+m/Gmbhq1ZC9Ml5EdWWP
	eSQZG1jNlFtG5jswyvoJ12PFJ0h4oOP1LxmRgDfkehKCVjkGy9h9QciBoO2JZQ6AVQBRgB
	iUjg8it6Gnn0DU/orfDK3dfbiJRQspw=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755n0cZ2911541;
	Wed, 5 Aug 2026 06:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=RWT8aC
	k7wXj77exlm/RNCevEhNoqqekH+wF/8jAK3ZM=; b=m4KkAuK+/TxYkgWr+JPiKC
	tSWSRQNv8tCgiD0Go5u/ZzCu/XVBtWg1gGpzsU+3SQMHUO79DA1yt2ChkVqbZwZc
	yeOyr1+Wu9BPO9tmbu3Ct6ewBmjDyIvFAPiqG1E8zSAqPN+fqesBT6BGNu0gtTde
	Ee34g2H62RGS6EPHzZg2L1nSVdE74dAzlk1uI+5lre2v32rC5Yovl6SbU9lBfbcV
	dtHfhQXb1PlSg6hSYpKNNwUfftAgar3IprM5q6vt8t86ShErLgb/XaIvzw9CHkfW
	EaeVR6uwUr+6HISeR66W2Eg7voRh0IKCeYEyU93Xu8uBNWEh2Mj9Fh9vSMS2MAlw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77g99t1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QJe3026819;
	Wed, 5 Aug 2026 06:29:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswbgd4rj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:11 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756T92950135454
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:29:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3C1120043;
	Wed,  5 Aug 2026 06:29:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18E9D20040;
	Wed,  5 Aug 2026 06:29:05 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:29:04 +0000 (GMT)
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
Subject: [RFC PATCH v3 09/11] xfs: Implement RWF_NOSERIAL to parallelize RWF_WRITETHROUGH writes
Date: Wed,  5 Aug 2026 11:58:15 +0530
Message-ID: <945bb8c88a121580cb07d0311c6742a2584ea6b2.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX+dYRnCLDKhvr
 cVev75tHfJWa2pAIU9naHbh2Chgs+f09RgOA/nDPoLhK9mE/YkCkaihttWaHY+hIKozSYZynWg6
 UzucviPoSIoPGyRdslfzvq3pVWNBO+Vx8T/z8ZYNKuGnOFnpXmCejHQ9HaizPwrs9UVc4eNqXc7
 Iu5teIzUvzlmbU8lIKEm0kOljBLgd1PYJ2NJn8fLRVaqx+Iwnp2VrYrKWQhT8gEXNRsgNQwRDh6
 GTXbYNXQg5zJIgthtK/k68BCOwas6UyqWi4IdUqWlSf/lLvLWE9qePkOze06QKuTqqA/o5IwTTk
 QMGy7CZO7PJwh9rTVADWaHqZOKzu3TglqvdKYlBo8pfY1QYzm+Y1XZaKfguxerK3CdFpAiEcwZt
 QWl4VgHKnE4FH/nJuarT99CN99VuU9zOj/MfbTfiU83ks0mpa11a9oCV3Mjr+Pv6ZAAPpHlxW6R
 +3QLoGhrZKNxW9Nni2w==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a72d839 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=ohjDDRDfXa_An5IlpZcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5xmYib4BB9HAko2uCn8GKxJzlikdQjnH
X-Proofpoint-ORIG-GUID: fk7oH1CTDqvVf8GBmrVbweaiXebuZ106
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX5fz3zMi4oL0m
 x9sLx7z2MOXV8NhuQKb77HlAkYPMQVpvEOzEPOp4eTbewqKpD59TSV2aF7XjH4u5BzlF4iAYZI1
 QltBsP9+mcpySN93DXmhMsQKCVIu4C8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047
X-Stat-Signature: b8f8hkp16krdrgqgum7uswmrhw7ao1ek
X-Rspamd-Queue-Id: 5CF7F1A0004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785911365-819392
X-HE-Meta: U2FsdGVkX1/AOI9W7gAGYqgioDzMwyhptVrutSfXAmSc04nquyjN97Dsd/yFN1DKnn9iZx6ddNZJc/6SUJpcOgg04HbrWAvY+FxjdvkXML61KsOAuSnTHTO4+RObGUTn2MN3Zbh43FwiROYR5+lz7BbTFQCqaGLrkuB1cCktXejLWjSnBP9p0RU3NPMSdMLmunbHtW/XXngOlMk8vU/5TGZ49V6SQI24LGXzZSqAzpb0+BaxzlQGivGkycHTRq4HKxXeI2RKneS6EqRgmF2+dhdlrh0gtkmXMqqdiEfEhrtclCstA8mHTFRPATu0lGm2mHPTBvaG+/azSMko6PteQqEuiO/l2UkKGaUR3jfXgrLsQQDkL1AKSgxffEdoPuCFjGhdvQwqNcPiC4Llj7stCNH9iWJw/73rAy1ayt8SnSgZUih7Ky/s8UCjdNKbMc/uET2lV6NtjxYac/qN0I3AuAfYewpjm7yR+u3kf8OC8yqdH+Sw2/8RueyG/PBEoCUfZtqQrYV40SOn8oBjGFeV+Zdu2AgjvvvyExZsiZAzYtIZijxPXlNb13yywUA4+giiy6TQ3mD+Gmbzwt/KmeyCoCqQcOAsfvIknFZu7KlO37K36pNNdqHaacHGrvOd3lBdNcGPrS9jCDjWa1bEBU06VhKCAAvZzGBaKGzRS5wpYx1cCrhJOfLSy3unrZrwrkZcFJDfv6khW/FEVivaRhwjSw9MVFFKrmCWndGGwYi8ls5Nnm5vLin4H+wZPBmYfF0HC6Bv/4A58JpwwPSlTn22O0e3cwRJ6Ui8NzFtKDxiGDx8qs7wsn0LRgB4sWXjWYp5MHuazXkyCal+KRbSb8tHAIk5GKRnjH5QVLRqKunx3zbhuHiqrkMa+0Xn+G1WmVj1h+ud1vsdGAy8KNa1K1ZT8EhKOqZpujlaP/rIiNtJlZN7m9jXWZ/YSI9Y+T9mN/UtTvUT0ALX6+NX/aTakt6
 fr6b+z9t
 PlNoh98/rRXSby7x42M9hb+8ZG+uvGvcHWXiGXWZdN089OP9yfPsuq7UZdPSpN3Cr2ByY36v1tSAbGOsW+bzVakWYFl8JjplcaJxrSAK8qgf47WOATvzrP4oZem59gvDXg6ZW9VPVYPP4siNA8lx+TvrPKoZ8mZj7p8Ocgv1jl4xwN/L2griepZ/ygTMsdfoxcK3ZMmSzrr3TsATYJef/YAMhOf4apUKZjIMMmtMdclImmZN0jzjCLcaSanQYUSmPiLEXgeKat8wJi2MFDGZZHbXvuTn/sysX2I9GVtIE8GDY/gJZQVQqQi+qgadK79vCLZ1rv+fTIsGLyX8NrXpnqYyqbrV0TZHf69IYli1i6Geaim4L9H4NPNrzuVNzKg6lLBb+xmQ/QvqO67mH3jpBU50J10PfVrtLzGac2tz4ogO5XwfoDuMdus/jiNNDwhHVQyX4EBpfOCdxuSKtp2yU7lAp38/blLlsdcND
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In xfs, buffered writethrough writes take an exclusive inode lock
similar to regular buffered write path. However, since writethrough also
submits the write under the inode lock, the increased critical section
really hurts performance when we have parallel writers writing to the
same file.

To mitigate this, implement RWF_NOSERIAL flag which allows us to perform
the write under a shared inode lock, instead of an exclusive lock. This
gives significant performance boost to single file, multiple writer
workloads at the cost of losing write-write serialization and read-write
serialization guarantees which XFS has historically provided.

Let's look at each of the guarantees and what changes with the NOSERIAL
flag:

Write-write guarantee:

Image 2 writers trying to write the same 3 folios. One is write As to
all 3 folios (denoted by AAA) and the other is writing BBB. Then under
exclusive lock the final state of the 3 folios could only be either AAA
or BBB.

However, with NOSERIAL writes, we could end up with mixed data in the
3 folios, like AAB, ABA, BAA etc. Note that this mixing will always
happen at the inter folio level, data contained within the same folio
will not be mixed as it is protected by the folio lock.

Read-write guarantee:

In XFS, reads also take a shared lock, however they don't take a folio
lock when copying from the folio to the user buffer. Due to the shared
lock of read and exclusive lock of write, we are able to guarantee that
the read always reads either completely old data or completely new data.

However, with the NOSERIAL flag, writethrough will take a shared lock for
writes, ie a read can race with a write which is still in middle of
copying data to the folio, hence the read can read a mix of old and new
data.

Despite the above changes in behavior, there might be applications
who would be okay to lose the guarantees because of the nature of their
workloads for example, if they never have multiple readers/writes doing
IO to the same range in the file. Such applications would benefit
significantly by using NOSERIAL writes.

Below are some fio performance numbers of RWF_WRITETHROUGH with and without
NOSERIAL writes.

** Multiple writes, single file (Pure overwrites, DSYNC) **
  Fio Workload:
    libaio, buffered randwrite, bs=4k, size=2G (pre written), O_DSYNC
    iodepth=32

  numjobs  baseline BW  RWF_NOSERIAL BW  Δ%
     1        350           392         +12.0%
     2        526           798         +51.7%
     4        597          1591        +166.5%
     8        630          1839        +191.9%
    16        570          1836        +222.1%

** Multiple writes, single file (Preallocated file, sync_file_range) **
  Fio Workload:
    libaio, buffered randwrite, bs=16k, size=5G (fallocated)
    sync_file_range=wait_before,write:16

  numjobs  baseline BW  RWF_NOSERIAL BW  Δ%
     1       1099          1279        +16.4%
     2       1482          2456        +65.7%
     4       2065          2479        +20.1%
     8       1778          2500        +40.6%
    16       1787          2508        +40.3%

* Multiple writes, single file (Truncated file, DSYNC) *
  Fio Workload:
    libaio, buffered randwrite, bs=4k, size=6.5G (truncated), O_DSYNC
    iodepth=32

  numjobs  baseline BW  RWF_NOSERIAL BW  Δ%
     1        78            80         +2.6%
     2        97            88         -9.3%
     4       100            96         -4.0%
     8       109            97        -11.0%
    16       106           107         +0.9%

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_file.c  | 54 ++++++++++++++++++++++++++++++++++++++++------
 include/linux/fs.h |  7 ++++++
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4b45ceacd461..b79076c15c5f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -520,6 +520,42 @@ xfs_file_write_checks(
 	return kiocb_modified(iocb);
 }
 
+STATIC ssize_t
+xfs_file_writethrough_checks(
+	struct kiocb		*iocb,
+	struct iov_iter		*from,
+	unsigned int		*iolock,
+	struct xfs_zone_alloc_ctx *ac)
+{
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	size_t			isize = i_size_read(inode);
+	size_t			count = iov_iter_count(from);
+	ssize_t			error;
+
+	error =  xfs_file_write_checks(iocb, from, iolock, ac);
+	if (error < 0)
+		return error;
+
+	if (*iolock == XFS_IOLOCK_EXCL)
+		return 0;
+
+	/*
+	 * Extending IO needs exclusive lock for i_size change
+	 */
+	if (iocb->ki_pos > isize || iocb->ki_pos + count >= isize)
+		goto upgrade_excl;
+
+	return 0;
+
+upgrade_excl:
+	xfs_iunlock(XFS_I(inode), *iolock);
+	*iolock = XFS_IOLOCK_EXCL;
+	error = xfs_ilock_iocb(iocb, *iolock);
+	if (error)
+		*iolock = 0;
+	return error;
+}
+
 static ssize_t
 xfs_zoned_write_space_reserve(
 	struct xfs_mount		*mp,
@@ -1108,23 +1144,29 @@ xfs_file_buffered_write(
 	unsigned int		iolock;
 
 write_retry:
-	iolock = XFS_IOLOCK_EXCL;
+	if (iocb->ki_flags & IOCB_NOSERIAL)
+		iolock = XFS_IOLOCK_SHARED;
+	else
+		iolock = XFS_IOLOCK_EXCL;
 	ret = xfs_ilock_iocb(iocb, iolock);
 	if (ret)
 		return ret;
 
-	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
-	if (ret)
-		goto out;
-
 	trace_xfs_file_buffered_write(iocb, from);
 	if (iocb->ki_flags & IOCB_WRITETHROUGH) {
+		ret = xfs_file_writethrough_checks(iocb, from, &iolock, NULL);
+		if (ret)
+			goto out;
 		ret = iomap_file_writethrough_write(iocb, from,
 						    &xfs_writethrough_ops, NULL);
-	} else
+	} else {
+		ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
+		if (ret)
+			goto out;
 		ret = iomap_file_buffered_write(iocb, from,
 						&xfs_buffered_write_iomap_ops,
 						&xfs_iomap_write_ops, NULL);
+	}
 
 	/*
 	 * If we hit a space limit, try to free up some lingering preallocated
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 685ffe8da6ea..ed5144512835 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3495,6 +3495,13 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
 		ki->ki_flags &= ~IOCB_APPEND;
 	}
 
+	/*
+	 * Writethrough implies non-serial writes ie writes can go
+	 * parallelly.
+	 */
+	if (flags & RWF_WRITETHROUGH)
+		kiocb_flags |= IOCB_NOSERIAL;
+
 	ki->ki_flags |= kiocb_flags;
 	return 0;
 }
-- 
2.55.0


