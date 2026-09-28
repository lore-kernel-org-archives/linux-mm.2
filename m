Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12360C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9026B00A2; Mon, 28 Sep 2026 08:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0686B00A4; Mon, 28 Sep 2026 08:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088276B00A5; Mon, 28 Sep 2026 08:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3D096B00A2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6281B1C1B74
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:37 +0000 (UTC)
X-FDA: 85263038994.18.5E53414
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id 05FF21C0009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TCCDprzJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCIXR0Hs9RwjT7rq+PiaxtNUAk0tz5yF4FzPUq4siPY=;
	b=IJ3cM+1AHjgSv6L0lvBaOmhHNx2JPkNtygUQZT/tLqLASRfvA9/Jz0s6Y64ReGt9T6aajr
	5mRVC2WTqCOPQ4k4HEOjweqLPZw3bN4Bg30qI/lYYWiVLbhaT1FgtgzCeA163j9QyAV0rR
	5qM+9XQXOGEXYAyiNMI00x51U/3Eh2Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TCCDprzJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf18.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597075;
	b=090Dpy/U087xxx/Dur3ejzsQKDAW/fXsnBrHjpC1VBsWlwMvFjNrzWekdMoHoHQYWzAp2i
	IW4Cx31JCQSUxziPnuReMwH1lMSmn6OF8kqPmSXWUuPVaozbxKqVBcBTE2YlOOb+8+x7q2
	gmfCy4B+0suCAEI0GWzykVaThvrX/S4=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBa4ai824443;
	Mon, 28 Sep 2026 12:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NCIXR0
	Hs9RwjT7rq+PiaxtNUAk0tz5yF4FzPUq4siPY=; b=TCCDprzJrsGWb3BiDfno8s
	p0DfGH898yK51mcnul2/CUF1ZzOh2rLJUntPENGJ+o7S8LeKpNAN7N+8FtkyirAo
	lLYMJctv3hwSyFAeyMw+PLx/Rpw7QTlBhJORnlr1BZFeTjF7Lf+gixXLe39Edq6/
	9nbL4GS+HH5Y8FsSAMlNrGGRFjmbl+ivLmzVXiOCTKTWc8fLEB8DMZ97OE78/ND+
	wIG5Mmo2kM0ftctCKDoEBAbmEUAG1pGnDvKq9mYQ4ZkmmjljfAU5wqrf1vo3nNiL
	RsqFrjsWbmrEBZAtEOzgNPQpKR+HgNMIi+R03Rn12ibDGLQ938h29PoyuHCJmOBA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx3fk128w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHrjS076685;
	Mon, 28 Sep 2026 12:04:18 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsvhd1mx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC4GcB49938724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:04:16 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49A9220040;
	Mon, 28 Sep 2026 12:04:16 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91AB72004B;
	Mon, 28 Sep 2026 12:04:11 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:04:11 +0000 (GMT)
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
Subject: [RFC PATCH v4 10/12] xfs: Implement RWF_NOSERIAL to parallelize RWF_WRITETHROUGH writes
Date: Mon, 28 Sep 2026 17:33:11 +0530
Message-ID: <6503684dc469fc75724393242184358d520ea4f4.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: rbFL-4xRFsTynGGcC5o_AFrPPoAnm0ek
X-Proofpoint-GUID: czNHwlDBvkAmDd0aNLajzXAhI8YcO-nS
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX/kkxyLuyqH8c
 fwL5pa63SFtfWhkfyo/0jjVr8V3L689JTjLx6h1PLFKUOnCen8kWAS3Nr0PxrgZjW9ur0BU18nb
 5IKfZOMdSPdgfsd4t1Kr6InfjnQvzpc=
X-Authority-Analysis: v=2.4 cv=Vv62kO2n c=1 sm=1 tr=0 ts=6aba57c3 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=7CW_VmIZYsy9TsuLaD4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfXw21nDKiTZzoh
 sWh8kzUMvfdxsqcdqVjqUtKq40zKlWV3gbj19oyd6e3fJATfkKJaUKNGd8XdWT8NhtnHK42qn3Z
 WrcHI6H4oXX1vuJgYtBxwN6aYjQzVXSCKT6dm/emA9HE4leQtIcaaImvZTTJ8wCNUOAGjRfnNQ3
 cTevKMS8p2tTLnnwapgNQZt1JRYZhsHDPemRpqGWcgGw8unIURigNCNBvAVJwhPvhG++1WCCD5n
 9rBuJOocy45Fqnc3x1TmVc79dFN5nAsc0e8OLGeBG6w/1TZNVqkSvICL+buIAN6frctSGX2Jbu5
 SsfG4XXCFh0cPNAOag/UrYtaTlGdfCZD1PBjlkCANDOyiwNq9i29Z8FTzTImFe0Hn2JY6wyE3sC
 7/oZOTkZ2E2gGQ+A/yJx1QRBo5Zlu5ZNzKCRmaMn1n6/i+D7SWn3yUsG1KESvMjDA2CqjIZMLDL
 iHXbHlKf78sVVpE0JYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046
X-Rspam-User: 
X-Stat-Signature: skhy56qfkmgw6rmdmmugywsqnk4kamu8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05FF21C0009
X-HE-Tag: 1790597074-635071
X-HE-Meta: U2FsdGVkX18hMNHUKTVRBFZ9uJrey7+T6H1cajf/Qmk1ysiHp7kxk1Dr5syijKQGNWUelBcJqE5OEnwNc+A4TcPTGN9oZ4iwxAJzOtyTZ0DEQU7zC4Z7j72R+Xn/9ZUYql7sAQiQBngrHssUv1geUpsBFCsLnLNhrOFJ/1IbU7knki8OL6zXn9IuwiTtWNrDuNpmFIewCkPuJ6Y5sqQdDaBRObfcx/hLCtJqCnVTMs6X5pUF7keysvVbVF6b4MufsxPAJJMcwZlbO/e9pM1F8zX1avKU3N8tPosWq5OQ0r7RIcF8LbMEm0SDY9wE0E7yC38+aZbehv3V7q3JZaWYkak8aQjX8/FJveJ8+7dG4ar/pe73b/oSYl86EMWqC4YIrieZ4PFf2mull6BBo1fCZzfeVphXBsTMk0ity/KLWT/scfe14zFVec15p1D1RMMQPijtwVu9qIrVVtLGq8afBj6UXZrhfP+AwOQd0xTN0j6oXO9zSAMlYAA189O7WpEj01W0T3R5FLndscabXPHtjY9zru9m28uqN4zSC+wdKNtNZs5IxvhrJ82ERz1pT1Gx2AoJqBtwaMiqq4ztVGscI/MoAQeAk9TNsCEUiu4SlP6hk7m4R4EiOnnKAHmzrtAq5jDp+rybpV3tWHyeYW4aN/sjI3cpvURfdykVW9DeCU0FSSnUzhgWOdu0NqGgDMQ7tbvZi8XPXlES/P7R8CgM7gwR9djPY7HCOVyvBIUiZ4zvvU9xkksemnlRlCoXoF0v7RMHQ6C1lpbZwTXrsJCB8wSsiBE+H0mUTZKr9HB0FLu+qytm6vOmonhwKyaqkNNTgkDdxMk2N3sYBepmyymZtgvfA8OOt7sr/NdMJ7AfrgkTuD/kkjPjHb133duN0S6PRi8aNaItV5qzaM19Mr4DylNIxfzyvvrIDBceiJkK/7oR9PIS2XcuQbjXUXASEZFBXxSTasXK0jPwMv2w1hf
 C2gNCrDr
 Gd5kvlZ/VTuWE8onN/EsZCTBem6JHURU1Di1JULXkFY/70lyyblqSKGfhHO/9vRWR0Etd/rGSrCGDBVkoXWhuvDQkviveyS8r/HVQZsTFwLu6tz1O68OrvM1Xp6BffWkYIRAoc2fdFWJ3gqbw3Vg/1krpyvWXo4kd2BfnFteYtkyOVxqbXDml/hVw1cB4vevgr5zknd6pIQqeJOAf9Uxr6b+Ef82E2sRNU5pNCDUm7Pd23GJJvIThCa2Q1vALa2mVxkjjFFZ/RWTjV+nmaK1TYGEJ4qB9+gwFf9qugVfae30o4SN34nA9hKwxysfYYjEi01E0szvZvBHXhYw/te0TUfqBLAwoZzXv15d94YErUcV2pctcApf4uAU3a0V2CMoEf37D
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
 fs/xfs/xfs_file.c | 57 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3e25baca22c2..ef3265f3b6b6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -508,6 +508,45 @@ xfs_file_write_checks(
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
+	size_t			orig_count = iov_iter_count(from);
+	xfs_fsize_t		isize = i_size_read(inode);
+	ssize_t		error;
+
+restart:
+	error =  xfs_file_write_checks(iocb, from, iolock, ac);
+	if (error < 0)
+		return error;
+
+	if (*iolock == XFS_IOLOCK_EXCL)
+		return 0;
+
+	 /* Extending IO needs exclusive lock for i_size change */
+	if (iocb->ki_pos + iov_iter_count(from) > isize)
+		goto upgrade_excl;
+
+	return 0;
+
+upgrade_excl:
+	xfs_iunlock(XFS_I(inode), *iolock);
+	*iolock = XFS_IOLOCK_EXCL;
+	error = xfs_ilock_iocb(iocb, *iolock);
+	if (error) {
+		*iolock = 0;
+		return error;
+	}
+	iov_iter_reexpand(from, orig_count);
+	goto restart;
+
+}
+
 static ssize_t
 xfs_zoned_write_space_reserve(
 	struct xfs_mount		*mp,
@@ -1108,23 +1147,29 @@ xfs_file_buffered_write(
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
-- 
2.55.0


