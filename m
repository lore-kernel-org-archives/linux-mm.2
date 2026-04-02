Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E75D6AB1A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 23:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26DF66B0088; Thu,  2 Apr 2026 19:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EDD6B0089; Thu,  2 Apr 2026 19:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D7C6B008A; Thu,  2 Apr 2026 19:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 004A86B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:59:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E485E0297
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:59:45 +0000 (UTC)
X-FDA: 84615285930.23.8D9AF70
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4DCB41C0002
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:59:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d7iVicLi;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775174383; a=rsa-sha256;
	cv=none;
	b=Jk0NWsYbJ1+c4Aux/PV3A5mGbSAEIQnMy42WfUu60Ci9IVu/s6+tVwHz2tN4VVoq8vIjZx
	poUrOUbuAAuV5ATlhbrULwpf21JmtCw8JyHGWN+ovFyc+hP37Ih0kkDj1vCgvu6eG3YN4t
	RxmSpSfaG6b0YhBAW2heCir2HoPRO1k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d7iVicLi;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775174383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KgAgI6QiIGv+4vwAVEjIV77rTVYiL2wkbzExgyHD95U=;
	b=T7hmV7rh1TLk3wp24Ib1onW3G2tRsHEFm1ok/HMesM+YDpRlNZFnr9XhIiLjd4HaRGxAOL
	ezBH1UrTWoXlvGS2bZtfvTT7lvqrSQJ3U3ifwL91YByrDOGt4B1ckW6ZKhNxxef2MZllBR
	fGp0IBUIldfvxPZDB3ln53YRyp0C04M=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FBp0I2879374;
	Thu, 2 Apr 2026 23:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=KgAgI6QiIGv+4vwAVEjIV77rTVYiL
	2wkbzExgyHD95U=; b=d7iVicLiRl6O85ptCNGJYVRkUrzi34eMKS6EcHxOp9z1g
	Vq8WmWwDqRsciZ9xn4/TzAUYm40jvtYACN+8KCe4s7ODg01TfBK0GH2j2g+pxVup
	kfL/+r6mynVjxv6rCBwws/vH895XZBemZM8BtmweDV3c9Ib6zE14MHpavvXL0V2j
	A6y7cquNt6Qt9qyY75WOKma9qaD7pD3sAS1pf4K6nzbKnBVH3Ve/xpr/mRC/jQyQ
	cJOWKL5tMbfaxN9XKDXMoFK2j9APa5SyGTbBg7z/bfIBYfyI4m04376xstGYX1Ia
	x8F7RwNMKcQhGjQW8M7fd4HmpNZcEE3HBlz+LxKZg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d65s11dxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:59:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632KoxLO008476;
	Thu, 2 Apr 2026 23:59:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ekna7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:59:37 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 632Nxb6N011992;
	Thu, 2 Apr 2026 23:59:37 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4d65ekna7a-1;
	Thu, 02 Apr 2026 23:59:37 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v2 0/2] fix MAP_DROPPABLE not supported errno
Date: Thu,  2 Apr 2026 16:59:31 -0700
Message-ID: <20260402235933.10588-1-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=896 mlxscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604020214
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDIxNCBTYWx0ZWRfX8YZMLSTNr/lS
 jy4LXzezIKxk0PHM0M50iSwy02pVt0pphOez1gepZoeQVrghTS0L1/PCe7nNDRms/sbET7YhKHQ
 8zhkmC2RTgBsGzLxmRdSRMkObjwJUTiaXMTY/cF8Xm1sPJby1I0po0rfNZ3fgX/N3xTFZ8r8DiU
 hIAd65G7mf8DCoSXJhb+BUl+ZbHtIhRB5YJpNwW/F5N3/d7gwNkwAO8jeImvYI5pbuH+986t6O0
 P1hgRJrPKh0OA7muKD9flYei9Zv/h8ueFqqK+nYMqXSkTse+99B1EdqQZl2eEmqQQCzF8xtF64L
 Ceju3OC0CyepgB2vf9417GjTUO3qjhvNYwaAJ6OprmAraor4ry0Ywjc1W2/FdAha3l06WeJvWZm
 AX680frjPD7Rn+EplRo8wSxn/Lb9zEP3CqIIEUgxueBRv6+yC4fjHXRnSPZ8qX5nj7LhYiHlcZO
 7ZIlcl9SSz7J1fujHCeSLvEpF8DfYixvne6sqmSc=
X-Proofpoint-ORIG-GUID: 857CPNq1TVNNUZDOJnyMECOquKgSaTXY
X-Authority-Analysis: v=2.4 cv=BvOQAIX5 c=1 sm=1 tr=0 ts=69cf02ea b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=hZgukN1trT8sADp7EUgA:9 cc=ntf awl=host:12291
X-Proofpoint-GUID: 857CPNq1TVNNUZDOJnyMECOquKgSaTXY
X-Rspamd-Queue-Id: 4DCB41C0002
X-Stat-Signature: e9henrozuie9xbh7u9oxp7muz43fxufu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775174383-377492
X-HE-Meta: U2FsdGVkX1+U06iabdot5Aa9HDq2NOjeRiI3sav/X6T3QaINYoEv4WvP2hKxq1S7Y+pts7z+yIUw7yf9BcdlO4s+XEvFfrsiq+DtX+y8LY5jA6SAmxrnXZ1zkm1hJc5VVca8HWFnGu5zOTFVJHWsUKdMIkfDJST+hWCMpV565KdwdJNHxTisn+MvgwMAAcfuFciPWTKnuOWt9Z4GgTHobWEesOuD5McpxdyOQo1ZEq0TB7wxg/OlWPAMOMa2/PYSNkbCI22VA7h/4+kcxvLiCDedKplAOiSZ/R33l60mmVy7B9Ciro9kgZp08AwqyuF55gWgcYAbBXOHRTx2Ug5m88uvPU/PckqyPpRtIyPkP37AoWynyJ0z1QGnvIcic7AIDj9M9mMTSrQIHOlhtzNu3VJRWGtY12L2Jd4fCjrL01K2Dz1Uzd47VD8/rpSrUO1UZOVZWxWK6udPQJyl3PYQlKDFqcC2R5l7c/Bofa7urg1kyPym4/JboIpYv6Fhxf9K8oLIRtMpru90lw7nMvWFa4yaTHEvuxo7cAtBnEIHva48MNTCNU3oPvufijjSxyatAWVnluQvcG9jQ6GVulmujrEHVvbMj16upKEbHlrMVBRV375hZA8Bwfwoh4rP+hKfOr0DtDpBoYeWDOeulrF+JQH2oYzWxvJ4r5r1vCmgMSQjckKtygGsTSFxFmTQ4y7L8IzCui4oSHByh2YYIqjx8MzRa0+M1BXCz0G9+ZQZrjUqH3ec/6a5xh08518nbF8mSd5PIJJK4fUMU4on0dSxZw/ZAZfUC9LhAT4NwRIJl8cWYnuOeUBTo6erj+q6w51IqTkEJo9Ec7DPVzfxhiV/KqgNPdqUmHmemtP6YyWC7dPS3yscZmKS2wZBoESerCoqJh1pL71c6fLRBTZoNDQOgIYm2W2+9asGPzYbjDw7pBi+pvRfXzPZVwAPip0txMd+6VTi66a9VU3Fl5wwj8P
 RIrT8B6L
 JOgJUN/uwWEGAzkHLJTAiv6Qaiwx1ncnG+BLkCf1hAfPLKemhfRs+y/F4mOIxnYCzZZ3Qq+aVw+7vwAPveJWRtI8BqZmcU7a/AuQiI9yMb7Ryq8BiX5mrzCsCq6nD4Y2DYqIC19VKjmiQV9DfkooWLlYUM4JfqGAWCWJwyTig6vPgb3P+X+3FOMXXqnrX1E7Mxt53RRA1oywwn/zv6Y/AGUW0pOyqZV5KDFXe10Ts6RnlksSGqXpQ8ctreROIfzC5tcc7NRpSRp29oMMtGt2Q+ftL3j1EmC3DGy1I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark Brown reported seeing a regression in -next on 32 bit arm with the
mlock selftests. Before exiting and marking the tests failed, the following
message was logged after an attempt to create a MAP_DROPPABLE mapping:

Bail out! mmap error: Unknown error 524

It turns out error 524 is ENOTSUPP which is an error that userspace is not
supposed to see, but it indicates in this instance that MAP_DROPPABLE is
not supported.

The first patch changes the errno returned to EOPNOTSUPP. The second patch
is a second version of a prior patch to introduce selftests to verify
locking behavior with droppable mappings with the additonal change to skip
the tests when MAP_DROPPABLE is not supported.

v2:
- Remove unnecessary mlock() call from selftest (DavidH)
- Change tests to not exit on failure (DavidH)

Anthony Yznaga (2):
  mm: fix mmap errno value when MAP_DROPPABLE is not supported
  selftests/mm: verify droppable mappings cannot be locked

 mm/mmap.c                                 |  2 +-
 tools/testing/selftests/mm/mlock2-tests.c | 87 ++++++++++++++++++++---
 2 files changed, 79 insertions(+), 10 deletions(-)

-- 
2.47.3


