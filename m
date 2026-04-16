Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81710F433DF
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 03:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3886A6B0089; Wed, 15 Apr 2026 23:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB236B008A; Wed, 15 Apr 2026 23:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E006B008C; Wed, 15 Apr 2026 23:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0FD56B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:39:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A08C48C25D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:52 +0000 (UTC)
X-FDA: 84663015024.15.74BC7E8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9EC514000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nYWXXbzy;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776310790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jvfGwj9gk3exsHlit2tgP9PwiszVaoknxW+bdXzbjYg=;
	b=gKNFoqOSu2xFf+WUttS9cc+MhCapHejFzODoDpVuF02dvqnyo0ZvJxAtouzZy1LlTt6hzp
	Y5Txap0+4BQxtLcY77fK7YgDiYYces1A+gmrwXJqLq7lzFB7Pe7CW5SHr0sMvw5TDmaouQ
	tSwbiGjFZXnhqkTvQdiNoAxgIB1s5m4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nYWXXbzy;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776310790; a=rsa-sha256;
	cv=none;
	b=BT5os9DZOid/AOu84FNih91hqIGQFbVKwEfqBOvT9N8KrSf+Li/dWDA0wyBEaWAnEcWukx
	hAgvTi/jpY9Yio2ZPoI8xQ07zbhf5hlVUIu3hXGr03mazAzJf49Z2vatTyL2TEs0ZtRP2t
	WinHWfZ2HjE6QY7gRbYG/51nVS4p2WU=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FJMTNh2471195;
	Thu, 16 Apr 2026 03:39:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=jvfGwj9gk3exsHlit2tgP9PwiszVa
	oknxW+bdXzbjYg=; b=nYWXXbzyOARYWAUrPvnxqFEfkqc3qNXp5f0LZohpOvvOA
	ckYzZwewp+NtqTwPmDN8A2D8yOaOq8XxLE22SgeHfrYyjtEffV1ouzUKyUBtQAor
	18qdGJr1cTi0q2H6zzom4H9rgJ1GLcIznFJPvdiJjWMpe7/Gje8aB/UZmI5zUFhx
	TFb53DXjC5NKfOj1D5PlBCs90Nq/jZ3uRHKqDCbEE8/9H1KzzFvibSKHEHzHkQvM
	JRXhrHDAL6HTs7K+x9C4bPdj7vgfE+FqKpJp/c1fIR8S58zv83/S0zk0McZ/G+4h
	fAj98sd+u9VDxB6vokCYvaOpknZh3CEeeA5msMt6Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85qetk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63G3dXqU022531;
	Thu, 16 Apr 2026 03:39:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7npq7kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:42 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63G3dgir023193;
	Thu, 16 Apr 2026 03:39:42 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dh7npq7k1-1;
	Thu, 16 Apr 2026 03:39:41 +0000 (GMT)
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v4 0/3] fix MAP_DROPPABLE not supported errno
Date: Wed, 15 Apr 2026 20:39:36 -0700
Message-ID: <20260416033939.49981-1-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=795 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604160031
X-Authority-Analysis: v=2.4 cv=d77FDxjE c=1 sm=1 tr=0 ts=69e059ff b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=hZgukN1trT8sADp7EUgA:9 cc=ntf awl=host:12291
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDAzMSBTYWx0ZWRfX6kxMqrmdnCvS
 5ohLfPNa2qzdQv2rTtT0jJ9UXVSd+Ag7VAaVTm0NCXE2mOipm3CdqS99GPHwr7P9gJwWgLK/DmH
 0uc9Q88fH/Pj7bEKyjcwzEoChtwBMTVSO9+Ms+pvp4Euuh+Ac4vZChSdQv5kRjfakv1X0nn9XhK
 LsNtuZruMKtdTrvQVTEzdlHkSINOI4boSXgNUwms9waoadE1F3+ObQfDuN9gpCAgDw+K4IwYXpg
 MnYd2BGcA668TU2lFVLcYn5TvjNCmXQgHOl2ZfJLuevVbvR7zXfYcaYJ7mxw7Th+9XAYcRej70e
 H/69dfSbYlq8GBt0/npRwCRTAYRDj8xMBxKdBKwaboL0NjZfAH1rzdDD9PmcOS9rq8gp9FUMVUe
 KSd9P3bEr4se4LcX0ZtFXbBjxYpp4p5vLwHjKp6HzRtBq7G7wzQYc4ZxCDUvKMJ45cof0kpS4Np
 o0lMe5lazMPIun9s9AqBUa9WqtEtilXmU3KJKSGE=
X-Proofpoint-ORIG-GUID: OrpsW_e-qVrLPYUohSQ6-2NVMWT80gHv
X-Proofpoint-GUID: OrpsW_e-qVrLPYUohSQ6-2NVMWT80gHv
X-Stat-Signature: 3rh7jkj6gtsccsct1rf6oif8gdua794i
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EC514000B
X-HE-Tag: 1776310790-376751
X-HE-Meta: U2FsdGVkX1+uLVdPfAY7Ur3YereNkK4Tku8oumBwFfgBkE85MJXa9pq9dBMzoHO9PWJ4oRfejSn16bqZOlUc6vyMkseFol+0GWY0y7yVzC8TEH3xlr2ndPHCODPuwifoIoVfoZTnH94TlasLiACykh14IWNdxKRbOKiymOUkMkYMLU24KRo/3CMgrepDGTuiUT44w/9QGwxOLRS92+mq5dQSR+dqgHqhrrNGAwoGPh4rvNRPnffHBjP4kys00eEXJwRNQ/HaCMLpjvs+mmRqcWtHjNRk2fr2EuRgaJhexZqt2HSUwGPFtup2pFRMiHkSO5+MEfisrBXFIITEFoZpjt+wh36OT2y3yz8KH28mHPW86HEFTMaIghA0+zamZpnNBjhUCFTFri4Lvdq8qoxCySDYJ3p/Q6815QPbz8+KQNWpUHAGig32cIHD2xlXnIskcqLchjGussSgg6WTC74tTMm0no287nocgrj5H0oGGO/2CnMkWZR0oO3MXSgXrob1UO6JIQCP5andCnb5vvzwZCjeMU8TiyWpcW40c1UkUtxeEqaOgwRKoPns+PpAhaogUeHkxapLs6vUALv72WiOhZTGJXcYSKwK4Fgky8toLhujKTRg8anFZpYIdKvJZDSH5F4DHUyknzFNGOuc/sAFWx9znexhZs+vB1WGJQMBH3TjBFK7PVn4gtgbJJ/yfzJgeXcoJ9ow3JobC4g6kgyyLxf1sbXJUJiiIMY5j3GZjG3736n9fIapQmVFEQ6//M4jdr+nkIBXObLb0o6/JrE+5kH8Zm1S3QTHUUsPVSCHP0MYBCiHeEkPoAguUoviKlIQoKUFiaUG4UPdyMPNjm+TEuXgdrSwpNCwQsXXcx+0qVOC+9PcfNIbQmF7BoN7k6RFWSq35gPUPDEp50ObuCf5TKS+Ab691VhA2A3fLqS52I0QFqGkZc0HoVGtOQweqM7wmOyj6ojxQPLzpl58pHl
 ST5XAz47
 4xeXXOLcuVqW8aG4uGzxQ/nO3hx/D+m0syq4e+s0ma0QO1k1mQq8fg8f1N3EPb51b3gda3zc7QRcnaGKfEToPfxw3WQxmFQx0JKOIF02+dwYIBgdzHU0fvjBHGMOAOhA0ZO8qeRCnHPT3wwR8uPDm6DLrXelFwDix/+xesFsTrx13sLIqJ7hF1eVg/Pp7j8wMoTP2DBJONxEmHeDU4vPcFymgXpWioraN9MOBKT+DUl2B6UT0hqg60/+DWu5V34xHEbiYRW0M2gJLy7HGPjnpI9U+J4wlDS1E1igm
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
the tests when MAP_DROPPABLE is not supported. The third patch fixes the
MAP_DROPPABLE selftest so that it is run by the framework and skips if
MAP_DROPPABLE is not supported.

v4:
- Removed unnecessary #ifdef MAP_DROPPABLE from patch 2 (DavidH)
- Changed the tests to also skip if mmap() returns EINVAL
- Added a third patch to fix the MAP_DROPPABLE selftest

v3:
- Added acked-by's and reviewed-by's to patch 1
- Addressed sashiko AI reviewbot questions:
  - Call munlockall() if test_mlockall_future_droppable() returns early
  - Skip the tests if they are compiled for an older kernel without
    MAP_DROPPABLE.

v2:
- Remove unnecessary mlock() call from selftest (DavidH)
- Change tests to not exit on failure (DavidH)

Anthony Yznaga (3):
  mm: fix mmap errno value when MAP_DROPPABLE is not supported
  selftests/mm: verify droppable mappings cannot be locked
  selftests/mm: run the MAP_DROPPABLE selftest

 mm/mmap.c                                 |  2 +-
 tools/testing/selftests/mm/droppable.c    |  9 ++-
 tools/testing/selftests/mm/mlock2-tests.c | 84 ++++++++++++++++++++---
 tools/testing/selftests/mm/run_vmtests.sh |  1 +
 4 files changed, 85 insertions(+), 11 deletions(-)

-- 
2.47.3


