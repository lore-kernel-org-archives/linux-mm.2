Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04DCDCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 11:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D57E8E0013; Wed, 12 Nov 2025 06:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431018E001A; Wed, 12 Nov 2025 06:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FD78E0013; Wed, 12 Nov 2025 06:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 206A68E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:07:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2B894CA44
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:07:14 +0000 (UTC)
X-FDA: 84101678388.02.E6E259B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 60C194000E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:07:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zsp8IGGU;
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762945632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0hJMBz/zYmRWuH4t0r130WbFyOsxHRTCGHuO8OgZVY=;
	b=DACYv6oWrxtCXUqeLIZC94DHoA7WF7JJJ84o0yQj0JF8kMf0gus5Csr3ijNfSbO8qT5EVX
	slHyEs478beSo2WOQikvfP2ihpbozEcQ9C6oXvLKfPd0PzJGXob01YN4ENToJR+UQtQTZM
	2YMVZovmvqgDpG6pIsldwsygvZsSmkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762945632; a=rsa-sha256;
	cv=none;
	b=nfIoISlSy8x33xbma7AxiW4QIG8AYgBgD7kxyfUHFHBQMN/HfZCz1vDReq7YGPYTAaS51L
	IZb389St7x+WyR7sDdDdC8ptO4mGULcyjatbAveVaiEqkUzMNe0vwY3eHsyvaD/zzE1jsL
	Zhpnqmum/G1nF2D12csWVjF8Gj+Zpgg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Zsp8IGGU;
	spf=pass (imf04.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC8Fa48031499;
	Wed, 12 Nov 2025 11:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=w0hJMBz/zYmRWuH4t
	0r130WbFyOsxHRTCGHuO8OgZVY=; b=Zsp8IGGUX0adacqK7k+ZyC2gQLUArA5kD
	P+0u9+6r5JIOnIyHFQxeyhhUP9Kqww/MqrIuT2Lj8BF4R3Cuykd/4HflkKAU0VVD
	jiebOKq6ZfQ/ZYBZTVGF3yhEOjyxGbvyep1sdNt0Kc3i4FsQ6JUKmcznoniSP0yG
	JUwyoIMUodg3UmfGJnsKoz1ybPnxg2pfzxn+0TDNXZtIokV1z+1kzkmZetphg6G9
	dQNQIA+ulOQQoCq99KdZRB0tOn0ZokgTx6XsNUlN63o5KhvGM6JIzd60cvVhWqHd
	Ruaq8bvWXeSgHNIXchpqllc40cx9tp3AVnghct3kvPNA+utXwWqsQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk8a21g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:06:56 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5ACB3dNv020273;
	Wed, 12 Nov 2025 11:06:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk8a21c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:06:55 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AC9llv6011431;
	Wed, 12 Nov 2025 11:06:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw1fe98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Nov 2025 11:06:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ACB6rFc23003476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 11:06:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14C5520043;
	Wed, 12 Nov 2025 11:06:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DFC020040;
	Wed, 12 Nov 2025 11:06:48 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.190])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Nov 2025 11:06:48 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
        ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
        willy@infradead.org, dchinner@redhat.com, hch@lst.de
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
        martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: [RFC PATCH 2/8] mm: Add PG_atomic
Date: Wed, 12 Nov 2025 16:36:05 +0530
Message-ID: <5f0a7c62a3c787f2011ada10abe3826a94f99e17.1762945505.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762945505.git.ojaswin@linux.ibm.com>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX3xol3abUgNip
 VKmyz7/RYq4tsPh3Uh4rPsga9jfsU05AW8tRZQGbW3X6tXhsPNG/YF0HRPqdfGBlttXVt+3+SdO
 NUb8c2JaqU8RymN5dbs5OABEMaoGMm238koxi0/ZUcHsfSiSi0B7fuMijWaugmoq3kObX8iBzhL
 qqOP7xaDCra7Me6fqcTUCpOa6E2wPgesSgh0En0u6lydJC6KXXfus3W1btuuK/NCUjRBZtC+0If
 AIDXIPhF3hIaRtOylujdeiW/UmTt2KK4c5XE8hWi30uZwZWDdbSFrKoTdvASyqGIP67+4RWb8h3
 36wR4zZJ1QOQdG0EKXvrbIFyRjIow1Q6aazKbEhVeZmtjEg9trRXuozyO1Y56SYi/JKgM6KYBrW
 4IbyCo+hDnmmqYMAuoBDVLP2SbldOg==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69146a50 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8
 a=tnb4hg_zOA4vhegj2c4A:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: jBYtFSONvtiNMU_wrHLkJ11-nJl7Gx4o
X-Proofpoint-GUID: xD3cfsMfEHARDSfeDAr-NdTOxU0oXER0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_03,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60C194000E
X-Stat-Signature: p6njumz7n4od6m6qocwhmez5woauneys
X-Rspam-User: 
X-HE-Tag: 1762945632-527500
X-HE-Meta: U2FsdGVkX18KHGzzITVoZc8TWEy6XLLY3u9Loqsh8vBjJilhPShjo3xq82oIw+SGyW6gKrI72pQ+mZfhU5aIRybouONoFscKBKeI/JALDrQVqeX9hdovDRd0vyXgEQ+O+8FXtgq+0R9T+/xlu25Jc2gElcCwQcgo768l7721CxU5AHdXYhnipGpCPRX83kTE405phWbD/4WbAmosYAvfMW8j2nNvTdfj5+9HY7LYfOIUCixGWYczdKMzhPcp2eKysQYyo/6+xAAtiWJJLeDobr78SYD9ov7Huu1UvsAAnRRwslhA5Dbjm0QRpKW1d2UiZ0dg+mF6Tkz6LW08PNZbU2C5Ml6u58er9G6ZJ/NdAKTL8bnDJ+ZlsdmviZgZIP21+2V63q2UliJg9hAXfBlPalkmjUniC9P2Za2vYEbc6/4eWh5zGM5MaWFPS/BT0da+S/gSUJ1MYyhFLP088TYUawdHtGLOa59sxpZ24PfjsYrclkjhtvmiCjG0ShcZHEIL0b6751qYi0Y0dc8vnsC62/nsll3NW/Qf2pABgf9ip6OEkcaZOrohVlFKL16QgKIOCR23OJn3pnqTJAcGesabApa3wNq0KqrtTwO4WIZ/RRct3hlTBd5wseg1rWOJF+TRjQYOP7EtsWfheZtRNJpxve1fAVjT+MHNMhM1ZxqWG1vF6kTIw6rxvfyiMWNyKXeQiTEBXfpbIZwTYrpVHnYHY/min0OVFW8NxhzN3iwTUP2VNrF0TRL0p6WYRyPOAc70q1UqcgVhjYMUBcf7HknetFv/S3skOJ0a9/9U5l8i/3lBF5QecZVsccqJuM3l188AaHBv0zCxUbwGqJ4eg4RcnHLKEmQO2SmHK3ncb76F5hQ72E7PhUdqi8xOKc2BbLs9fdvSGROY1kTYL+7M9Q0EgMfyOXJ52jOewPSTsuCLCA0HMrEiMqqS490Hg3pCZv1Qw1ydcYQx9Mzo47nB+ao
 y+KmjhZu
 PsZwM8I6CMt2e8CGsfa0GyKYpum+gC15VIHLiyndGVAb+KE41RTJkAm8SoTh3lOR8kTnHpEyZxWLBOQvUPAgxrKdi3eMQqjlO0wyBKqblUEAuPzCUCBhnL4688QVc+8zTqzshytyF9BXd276Hz4795MJeAwIuL39Vb41qAEU0l490gVZq/RNhoE1B38yKnK0ahRFepNRYtv3RB/6AO6/ea49w0TMnTLhfCChejSjR8W1CP6HNHhAeUjMGi2ljywNWjUrASK9BxnZxfG0mKGkxKUjC3Kkr3oSKI7G6eHUJCvEHe/A9IJj268oVeuolFS+Mv9H3glYTRKnl+ftnrYtousZqHtR1f40C9UFDacK+XjEOS51MsW8JEx2jOV4aZ1sxkn0EwKZEZtXqQzl+YA6YNXaMSotV/y4oqgHh+iGgN1Hk7e6fLoNB2gFahAkkc/gaEx2EYYIWEuS5CbdsmnF10JvOJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: John Garry <john.g.garry@oracle.com>

Add page flag PG_atomic, meaning that a folio needs to be written back
atomically. This will be used by for handling RWF_ATOMIC buffered IO
in upcoming patches.

Co-developed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/linux/page-flags.h     | 5 +++++
 include/trace/events/mmflags.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0091ad1986bf..bdce0f58a77a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -111,6 +111,7 @@ enum pageflags {
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 	PG_unevictable,		/* Page is "unevictable"  */
 	PG_dropbehind,		/* drop pages on IO completion */
+	PG_atomic,		/* Page is marked atomic for buffered atomic writes */
 #ifdef CONFIG_MMU
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
@@ -644,6 +645,10 @@ FOLIO_FLAG(unevictable, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(unevictable, FOLIO_HEAD_PAGE)
 	FOLIO_TEST_CLEAR_FLAG(unevictable, FOLIO_HEAD_PAGE)
 
+FOLIO_FLAG(atomic, FOLIO_HEAD_PAGE)
+	__FOLIO_CLEAR_FLAG(atomic, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(atomic, FOLIO_HEAD_PAGE)
+
 #ifdef CONFIG_MMU
 FOLIO_FLAG(mlocked, FOLIO_HEAD_PAGE)
 	__FOLIO_CLEAR_FLAG(mlocked, FOLIO_HEAD_PAGE)
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index aa441f593e9a..a8294f6146a5 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -159,7 +159,8 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(reclaim),					\
 	DEF_PAGEFLAG_NAME(swapbacked),					\
 	DEF_PAGEFLAG_NAME(unevictable),					\
-	DEF_PAGEFLAG_NAME(dropbehind)					\
+	DEF_PAGEFLAG_NAME(dropbehind),					\
+	DEF_PAGEFLAG_NAME(atomic)					\
 IF_HAVE_PG_MLOCK(mlocked)						\
 IF_HAVE_PG_HWPOISON(hwpoison)						\
 IF_HAVE_PG_IDLE(idle)							\
-- 
2.51.0


