Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2477CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E8076B00A1; Mon, 28 Sep 2026 08:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C3F6B00A2; Mon, 28 Sep 2026 08:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0393F6B00A4; Mon, 28 Sep 2026 08:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCFA26B00A1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 572491401C7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:27 +0000 (UTC)
X-FDA: 85263038574.14.0D2B87D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1080218000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HVGczxfk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYUwO5IkuI0PPlYIBW7PMMCY3n6+3taFNzOhAFbdQXI=;
	b=Ba/xDOMnFSiizpvDnAk/zlEqr0HWCFqfipke2HhU+v2cjRdiw7Kn3MFtyI4aBUc++xTdFX
	9Oyeyou/j6x4v67KglxLDk8ZTVhJvJ9A5bEKUXDncEdalrp+ppu6fUYrGZpyj07zxZ1Q2m
	JW1ztLOl9Wbndr6kVgpR9OMyArzEa0c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HVGczxfk;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597065;
	b=hnoYemBRDeNgK8+l/II/F0QDBWG1QtCjfuczrJvflwNCxbAMVoFm5Y9YHUsi9NEPkQaqBb
	nxqfTPioXsevTX07lMgmD+1KVyJpc0Pk4Unu1cs2fErFlTsBFPc20uJCsqt21IKqBbAB8W
	6BgOHnyvxYkZB51aibm+8FSOVCs6Jhg=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZSEn1011255;
	Mon, 28 Sep 2026 12:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eYUwO5IkuI0PPlYIB
	W7PMMCY3n6+3taFNzOhAFbdQXI=; b=HVGczxfkbwtTwKvkI9wO5Ea5vjih5nhr1
	iuQaJSFTri33kSA6RPlisfC7XuFXC96j134aE9WMYCEPF7luLD82ANJpWJvSsync
	DSCRx3osFu7BFn3E/aBMdiEwKGKhPnd9DQoR0sY9Nx/S6b03XeQ8nIz/xv2MnWBP
	Sd67l4NI37SI0no186ueU3DC/jpg9nroy8GhrrpsKKuBpVfXVopnfkEZIHFzoi7z
	ODMpHSOc55wtgLdFSezsM/rVkIulVB9qz4sCT9S9nil3AIY1Q3z+kqy0Dk0JwESl
	9HyhfhRzOP4agkeggcA+h8SZ/C3VAFllgysyfHRVK04ofkfF2avOg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5pt0qtr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:13 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHWAl017606;
	Mon, 28 Sep 2026 12:04:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsck53b2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC4BYB46530950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:04:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15D6B2004B;
	Mon, 28 Sep 2026 12:04:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28D3E20040;
	Mon, 28 Sep 2026 12:04:06 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:04:05 +0000 (GMT)
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
Subject: [RFC PATCH v4 09/12] fs: Introduce RWF_NOSERIAL flag to indicate parallel reads/writes
Date: Mon, 28 Sep 2026 17:33:10 +0530
Message-ID: <c097ec4d23324ed223fa29bdb43f64d4dabeb3ff.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 50-d__L22Uwuc6rqBDI6ziDGVC7BVx27
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX6B6VQhwmoY7z
 RiCXZRXYFR75ljgYTli6aa3Q6ugu0u5zKb2LsUao3JX/1E5VEwz2OFHVukE+GyqvXKb2p10LyWq
 RyqVs8k9pSh569qpZ6P5swPcbKTKUSCOBIojkFoHX/XMEmPSkqU7Qez4nJHWEwvOyIBhAxu47wF
 8To0VOqj6ySbKW6COMHvJs+W+yFBhVuSsslzrtbJo3NM5bQJyqnhTEn7TL+azbi7ItBoHJebMnO
 zDKZWiAEjULSNWqXLOOW8I0e9dmHEoyRBlNT9FJ3ElZ3zxuXkxD9YMulXhxUtfaBPAVCWW5aSmd
 v1ywK8XPBrLJzOh+jo1/Y+0Fb22vktPLsdrPuHT6Jsdz6mMe/byQUTBtTlbiiv7XfJpbpBg1Csz
 U9OjByHlXEvJLk5/31fUJ+frFaBtpId+pKYW/lBExCtp6JMf0TCcstBqLwqUlvDn9PQcSP0iIq3
 MpOtRZp1mSdZ2GUPz8w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX23CG5JwwlRUY
 w3nGU6aHhWr+ajy7h6Yq0qQNypZ/n2qWJ6BGlj/fRka/x9l7qJgEixlLO0mgOjrLEh7iWrGqug8
 8opjFy3yrB2x79cTGdILok2tgEKxRUQ=
X-Authority-Analysis: v=2.4 cv=EY5d0/mC c=1 sm=1 tr=0 ts=6aba57be cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=PvrWFl4sATcegnk1AMAA:9
X-Proofpoint-GUID: UF5CUcTjUPErWdos58_oxZhQEQt19kSJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280046
X-Stat-Signature: dcwf9qhp5z4zs6bq4aij67553yqfskek
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1080218000C
X-HE-Tag: 1790597064-501510
X-HE-Meta: U2FsdGVkX1/TsLRIysd1anWJ83ohofQTZ8mbP3kly3y1D/mRUX2N4RKhCK8oSiS5x/Ygyj7BgO7uxEGCBqOM416Bwil8cBwcBSj8tYSwH9ajiKsRT7MKQ9Qf2ev+qozdvPP5zdooHMFZFkCjMoQ7OjALc3rmHfY4cBkF6H54QihkqcDgWd4DMQ7/6k3mamnw0FRSlXo5njUxvvQodo4gCc2+ckTXZjLJiUdZc23veU398Igsa258z3AtNFovXD41h1URLiUlGCu9+C3AeH40yK5urxTF70HOf7/E5M23nTM95FSYKKmMVx/bGAobk5fyYnvrnrMvWIWwklou9QYZ58wB9WqTAeTk3OVjROLdyRveuQpMcoM0IId9LDAKmGuCGdLBia1W5K37x3/wYcbcVJZXn/PxXAQrBoZTD3z6ymogsaLI6KnpJD8zn8iWV3O8MiqIugkcETw5fRccR7jdvkbGIS/Heah+JB5yUW1JpjpRgaP1h4CzRUCWr25A05+kYDmITEKK2G7jQdpMl6+VChDm9N3jvJK/bYBQOtkHPPjK3UfvwPz6sq5XouvH7eI535lZ76J1UoWARSW8zSmmVsWvhqKc78KHNK8sC6ROMSgalRNhuCeyppDCzWjOn9PyEkVwxEupcnfkS0/d+o6TcQveWP0Fc2QTsKpdxVwafZD85vsx4aL7XPW1phDLYMv5RLMa6e0J+ZlfCq7kVc9E1DncGLNoctoTewZTWwuH6FbNh8wp8kEFpNy3M8G8dg7zIyq41OGY/wxlPgm6N3pCmlHkePqNk6dk4BtRElDam8FyU08VgEd2Se7z352qIOWoMbVyT9cnJP0/pT8VGM0saK79E3DEcr2KKH66bTLZ8x48Wz+JyFAJGkfMk05cEua3msEVluuKqe2JQ65wMhiFkuT8x2McD0NBQACwqWxMaEogo1oUJY0LoUZ6TX2QvL5cz4j4oF/MTYwnNFpVvBb
 wo2ubNAQ
 So8hwkXtCbXhi9AF2Czxa/G9gj7v2ffeL2AiIj8UN1uPb3TTW+hYGy9TUkwzGkjq5f+M6WZwwylgTe6wY8OHz1dBSPnwpAldK5AjeOVlZ46h3BWRuKDf6a0WEfIC30L0epkcPEpUv3tJdSnfgPu0nxiWP4vdjh27fhFt2c1vMOnO9CYQqQY4H147eIf/G/LRvKrZug2XPFhS4mkgw2xPEelgqaoOKm3eU/ACpVVwPtisViuCJC8XeohR+6AUrsFQm6DuFOpXHQ5koECZo+e0BIQyX2XzfLyf6tSvRGmQi3LSRa7Him1RaMm1qBOaxyvnpc1us0wrx8GncxXHYkVvv3riPGOxp1cieG9Ja
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce RWF_NOSERIAL flag to indicate that the application is
okay with its reads and writes going in parallel to other read/writes.
This flag will allow writes and read to go in parallel (for eg, under a
shared lock) increasing performance at the cost of losing the (loosely
implemented) POSIX guarantees wrt to R/W serialization that various
filesystems provide.

In this patch we just introduce the flag and in upcoming patches we will
use it to implement parallel writes to increase performance of
RWF_WRITETHROUGH

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 include/linux/fs.h            | 10 +++++++++-
 include/uapi/linux/fs.h       |  6 +++++-
 tools/include/uapi/linux/fs.h |  5 ++++-
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index cbaa65e05d9e..6f84bb41f84a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -345,6 +345,7 @@ struct readahead_control;
 #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
 #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
 #define IOCB_WRITETHROUGH	(__force int) RWF_WRITETHROUGH
+#define IOCB_NOSERIAL		(__force int) RWF_NOSERIAL
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -375,7 +376,8 @@ struct readahead_control;
 	{ IOCB_NOIO,		"NOIO" }, \
 	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
 	{ IOCB_AIO_RW,		"AIO_RW" }, \
-	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
+	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }, \
+	{ IOCB_NOSERIAL,	"IOCB_NOSERIAL" }
 
 struct kiocb {
 	struct file		*ki_filp;
@@ -3499,6 +3501,12 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
 		ki->ki_flags &= ~IOCB_APPEND;
 	}
 
+	/*
+	 * Currently, only writethrough supports noserial IO.
+	 */
+	if ((flags & RWF_NOSERIAL) && !(flags & RWF_WRITETHROUGH))
+		return -EOPNOTSUPP;
+
 	ki->ki_flags |= kiocb_flags;
 	return 0;
 }
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 67d8987b343d..b2ad2d8548ac 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -454,10 +454,14 @@ typedef int __bitwise __kernel_rwf_t;
 /* buffered IO that is asynchronously written through to disk after write */
 #define RWF_WRITETHROUGH	((__force __kernel_rwf_t)0x00000200)
 
+/* buffered IO writes that are non sequential because they use a shared lock */
+#define RWF_NOSERIAL	((__force __kernel_rwf_t)0x00000400)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
-			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH)
+			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH |\
+			 RWF_NOSERIAL)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
diff --git a/tools/include/uapi/linux/fs.h b/tools/include/uapi/linux/fs.h
index 63ef6b126b8b..c7a1a1d238f0 100644
--- a/tools/include/uapi/linux/fs.h
+++ b/tools/include/uapi/linux/fs.h
@@ -347,10 +347,13 @@ typedef int __bitwise __kernel_rwf_t;
 /* buffered IO that is asynchronously written through to disk after write */
 #define RWF_WRITETHROUGH	((__force __kernel_rwf_t)0x00000200)
 
+/* buffered IO writes that are non sequential because they use a shared lock */
+#define RWF_NOSERIAL	((__force __kernel_rwf_t)0x00000400)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
-			 RWF_DONTCACHE | RWF_WRITETHROUGH)
+			 RWF_DONTCACHE | RWF_WRITETHROUGH | RWF_NOSERIAL)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
-- 
2.55.0


