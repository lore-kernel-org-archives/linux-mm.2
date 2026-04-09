Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98871F36B99
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0CB6B0088; Thu,  9 Apr 2026 19:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81316B0096; Thu,  9 Apr 2026 19:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F846B0098; Thu,  9 Apr 2026 19:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5CD46B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:49:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61735139FE6
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:49:27 +0000 (UTC)
X-FDA: 84640661574.25.9DF45F4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39E2B100006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:49:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N5dPViyL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dvJ3TU1MWb94kQWr+8Y7dvIzPSH4otBEbOprU5cP+OY=;
	b=jYItOdDkTkPOKXr2zlCre3xIYHH4iDIcR4gpdyi6A0eHuie4L+Czh/vFCjIe0gJt3CkJ9g
	awKrvqEsMAmdzMbJywKL4YjHfYeEtjryvSlfQOOaDRSVuDydNSVTT5cImCZkvg4ROiTnEL
	fDK63wKKZp0Y4OCrBi3pJo5XG9DZXzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778565; a=rsa-sha256;
	cv=none;
	b=r7khfPqOejdwRf5df2uFbn2t4Izxv8WjhLgSgo9Y8C6g0Yfv1TWcQ4eN4mEwJ084ILNELX
	c8Df7wBZjcRVgWg5nf2HMJRFRC0Ob256c0DsRyn3l7NpqlUXHDpysr0rdig9EzyvF77mYd
	b6p+mqF6j9tWY5/U9gmsS4xPwCyHVSw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N5dPViyL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtVp02413200;
	Thu, 9 Apr 2026 23:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=dvJ3TU1MWb94kQWr+8Y7dvIzPSH4o
	tBEbOprU5cP+OY=; b=N5dPViyLNCc/Om5vpWL8pRDmogvqTx99LiGz/SL5akd1F
	k0mTAyLphSYio4Jk32cfGrrTHaQpTnCbJeMiXrm4oaJKmvc48QV0Y/rnrsGDpJfQ
	OBi6XCM2AXZII1g1ktfCwYyC+rPmQGz8qiEIJ56hJDEsZ8tm6DXbzoTVQwyrqIFy
	gVN/N+aWMzK38NfuLRZWO3YWsHuW927CY+qzM7iVNAI1WgSgkZvmUoRFyKJU27HE
	4i/n78KrQXhhj03PlrTIeu15njF6bP/h8nHc3LQb2exz5NzwEl0xv93FgbDqG5Ye
	kSrEQ5IOviuGW6GYOTanI+O4mgSBIbc7gNTcyAB8Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqa8tf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:49:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639LQ44u003643;
	Thu, 9 Apr 2026 23:49:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5ytfy1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:49:18 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639NnIZM019990;
	Thu, 9 Apr 2026 23:49:18 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dcn5ytfx5-1;
	Thu, 09 Apr 2026 23:49:18 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v3 0/2] fix MAP_DROPPABLE not supported errno
Date: Thu,  9 Apr 2026 16:49:13 -0700
Message-ID: <20260409234915.11723-1-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_05,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=871 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090220
X-Proofpoint-GUID: BO1gdfDQVUaQm9ZjoLs9PU2hrR8A6Inz
X-Proofpoint-ORIG-GUID: BO1gdfDQVUaQm9ZjoLs9PU2hrR8A6Inz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIyMCBTYWx0ZWRfX/GP63TpharoX
 84G2Ys7Tmbhr6F6EU4LeNN8xW5rb20LICTmWWrmC+Zs+yuXHhEyArNAhZHOEhntB3zrEgVcH3Ql
 ByauAmnKX8XatJoQhGUunl8S5vWzC7VRii5t66UvKiNbtt7HTI6PJk3xDdOMX2xcWC6UcuRmCnF
 LoX6P0ss42QtdB/LI+AfKLVOC77xCU1BK8cZX7EpH3RfJU94zraKA+qJ2qC+iy8VuK8ILlCOfcL
 idSYyt9mqqjn6cV/vTGeigoly92J5bM/okpo4HTk4cINwifm4rKTU4eQLhYhmx9sQiBUddBVUqw
 PczgyhTvj0aC6Jz4ejJHpK0Q7tHEwKLj/ino7/Gh+OC5uzOb11xndKkSgotWkAWINPrgRUGpyQJ
 ntpkxmCnlDYDeTD2HKI1kdK4f+V7nRrrpGsfem+K0kHWknsezh+YjUDTzWloJ5xM99wmHcDX33X
 SLIxPcgBwd0E/7uPOG8FU+EDShvtbuEi9FfFcKU0=
X-Authority-Analysis: v=2.4 cv=DLS/JSNb c=1 sm=1 tr=0 ts=69d83b00 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=hZgukN1trT8sADp7EUgA:9 cc=ntf awl=host:12291
X-Rspamd-Queue-Id: 39E2B100006
X-Stat-Signature: b9ybaec9kt659jqarrmjdmoqosbpwdpa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775778565-818105
X-HE-Meta: U2FsdGVkX192KOuYR1FGkk98A5OCbcW0+5uqchgZ0KQgQOcrIOjF5nuc/KZmsgsPfpd8M2P982WdZLUB9RRANcfpR23hJe1y0d4cVXnZiXsOOG1I+i2u+9bYqxxSDtB0KgVk/piUHH8pTvCPvl1bZITTs/VpXOUXZUqC1cOIzC1iOwQ/EoBLL0r0umbyIPks1KQjpfjV3fjb1fdWeXKdp7CJv87zZxbrTPVYLrutLspnMGcUOPpG9bjEpQ4q5SufI5yoLo4B95sbsaCXnGgpwzo5ttFJxwktEuoHcOUqv//VU7FWfISLM95bBonA9iDWYtJUEFeSme2Gd0LKpF4TdD4cq9hnkEQ+HLdm7JewL9cdUgRgmqbex1/S8hHN1xyYhy2HQUtcbfHBkDMyuFW2giqfRgIQtYuW4Cimqv5q/tp7ne0cQoW8TsAZYja8yFFk++tKAxPtOBVh/oMYag7KrKrlJVKW2lpvEH4yKdsC/zHilZhiYTSr0sbc8MIbME6TtFQgkZGS4l89HaBQPy6iy8BEBmFVi6EJJe4AMNUB4wubvu3K2Ysed/r24uxS+muUygP/iwna4OdI4iU3z3pU8zWdyTu2wFcph2dFagFuhMV14GKadavXhJcJtiaJAaPM2zZGDX4C/FZWcbGpFRH8e0BOGFhLj1CtUVtDcyBO4okKblvBGGWEk6WMfNmXtumQ/TKjLL4V3A0ybeH/zxmN2ehWw8BL3jaG+b3/PmE5Z663MeOcGD5d7+e5OHjZJV0EhHt36cxZv+3sw9kdw0jhDQS5I50nVyAudyhA5Ucbg065ojgHm5hSlA0MLzUw2TlcxW/FIHGmLF2wP29x60RF9rP0lVT/CixlLaYJBv46P1UHgcnlmn5MTGy7NBm2oJWhhQf4+BpVhfoq7W/nynhQQPAVscCyfupHUUF2YI6VxnA7rrqR/oE/P2cjEWimbPYwbKw+3GsM2rF9Eb1xzAN
 Vcq/mrnx
 edvQmABGJ1Ueh98bsJw5TKeLxpWBqT1I54sqkoU316abiknNyho4g2ind2cpYRfkp74FxlmUJcMFP5LgvcW5XV8q0GUkB0HnGANuKf9o7BOR+OMR/d4R2A7e460xzKmeXNwzbgCdk6ARyPZEWPYELzjoYCPuebmAntmzyq4nBHZGiAhp3ArhwzN1bAofbx7DArUMd6H7YNBLYTawU1LILkdWaPRmdaGrw3PKKgxnwEPZudrVZme6nKPKz49grdtm4kkdW/V5G9sqeP676PrOtY56CyOb7yiwaRD52
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
locking behavior with droppable mappings with the additional change to skip
the tests when MAP_DROPPABLE is not supported.

v3:
- Added acked-by's and reviewed-by's to patch 1
- Addressed sashiko AI reviewbot questions:
  - Call munlockall() if test_mlockall_future_droppable() returns early
  - Skip the tests if they are compiled for an older kernel without
    MAP_DROPPABLE.

v2:
- Remove unnecessary mlock() call from selftest (DavidH)
- Change tests to not exit on failure (DavidH)

Anthony Yznaga (2):
  mm: fix mmap errno value when MAP_DROPPABLE is not supported
  selftests/mm: verify droppable mappings cannot be locked

 mm/mmap.c                                 |   2 +-
 tools/testing/selftests/mm/mlock2-tests.c | 100 ++++++++++++++++++++--
 2 files changed, 92 insertions(+), 10 deletions(-)

-- 
2.47.3


