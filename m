Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AECA8111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83316B0088; Wed,  1 Apr 2026 20:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33BA6B0089; Wed,  1 Apr 2026 20:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B228B6B008A; Wed,  1 Apr 2026 20:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A05A56B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:34:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38E9156B8A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:34:29 +0000 (UTC)
X-FDA: 84611744658.27.D6E9C98
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1CFEA1C000C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:34:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eK0GXqB2;
	spf=pass (imf20.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eK0GXqB2;
	spf=pass (imf20.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775090067; a=rsa-sha256;
	cv=none;
	b=n8nOCOz3PrKNSRRD3BI8bqYVUzZEpgkyOn05wroG9OVuOaCUQnWbQD6rd5UXW+YBbtFLbm
	NASve/o9U+lcKYEgOv+Ct8SagXm8w6XOYLeHJFpKY2E1qEWUj93o5900CheQtRX4u9LqAW
	OHp8amPoI2GZ7oKOaYsUdWDkbuAHWCo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775090067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Mw8BZbGPDp+o6t2OXcBTx9ulTVd8VrHHY7fUKmtfPEc=;
	b=rRdwhOIADi4TU6SvTABFNoNMBYf9ztXtm2j/YApJSULGYeNYotx/qZWP4W1KfMHazR2KV/
	WhH7p4sS8umov5eH6HTQCutgmhyqczPifJeIIUnCLMCi1WZBMrLQJRumG53lyHMNJfd8MC
	m3W/sGE3RqJ0LmS9YOXyEy6GY3IuOAo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 631LE8ic049616;
	Thu, 2 Apr 2026 00:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=Mw8BZbGPDp+o6t2OXcBTx9ulTVd8V
	rHHY7fUKmtfPEc=; b=eK0GXqB2pU7dQ+R55WHh8uW4pkUQbNof1tpHPtWh1NfF0
	1yPmDCpHcyTRtqyEM1dS8AAvpp9CnN5omAC0seTWBMnYOVH+gK4P3ga63XgN8Lya
	MzSFK54qvZiFOe2zk44kRLgc9PTy7URf//7KkWoxQBielGBcUmNOTiwGfJ23dI8Z
	jwc1cZAEpoSgJlpPZ/+7aVh7PuN0UuurqCvm+HaEY8XbV8BDl99/mzVGmc6R5HCC
	0YXMRk50afzeGfBz5WMpgxl1NjtIifhNW2hgW+YPApXJZVXzALe6P7nNr0Mhhjvz
	aqOoqRRLco9Q9wQZuqwpf80ro7yQSuuG3kUnQ7fLA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66v5qjte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 00:34:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6320JaBZ026329;
	Thu, 2 Apr 2026 00:34:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ec2223-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 00:34:20 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6320YJ7c001596;
	Thu, 2 Apr 2026 00:34:19 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65ec221n-1;
	Thu, 02 Apr 2026 00:34:19 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH 0/2] fix MAP_DROPPABLE not supported errno
Date: Wed,  1 Apr 2026 17:34:15 -0700
Message-ID: <20260402003417.438037-1-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_05,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=926 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604020003
X-Proofpoint-GUID: F2q5Z0BXn0bsY7LaLl0nEIip6PR_OIFh
X-Authority-Analysis: v=2.4 cv=G7cR0tk5 c=1 sm=1 tr=0 ts=69cdb98d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=hZgukN1trT8sADp7EUgA:9
X-Proofpoint-ORIG-GUID: F2q5Z0BXn0bsY7LaLl0nEIip6PR_OIFh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDAwMyBTYWx0ZWRfXwGCW3ggZHWJH
 JnGKm+BjYe9u5HJss9jUyoF/s3O++Jo4cT84Y/KC1aHqMHOJZRehf++noY1iFiEtmWAvTl8pSNs
 XlFIRzxVHpiO71GWejzeJ0Qz8Ci6ganxySMojaGBa2l6JGSlH8zbSxtyOq+63tAAeJKasDm9VMp
 OQDCwU6FOwHkdakJaoCKmHj0MrsGEb5XO6/DWzZ4NUNvXMhS05b2y+KzL/o5GbkYlwAzjxl9h2D
 v6O+Rt/hpIhc+4iQbfxYFnOJpAuLeDl+tFGUZtq1KNEsw59jVlqZWhm1Hlm6NdY5WKO1mErOJlC
 l4oCp7vY7B6ROdeMSJ4eX4cMhnQDr7869EeflQYUGbbhQz24zP2LdHCZAP3JsIYQ5YqQUZjXf3H
 IZzTP1n5xHVoRnKTeaq1uo0o8C1w9UmReViRido00O8ko395ctF5+hPeQsVMTaJoMM9b+hvgrCH
 yDT1me9vDkmMlowgNOw==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1CFEA1C000C
X-Stat-Signature: 9iw4axgozzcgpnhhuxf6rx5rdtqnu8wa
X-Rspam-User: 
X-HE-Tag: 1775090066-855020
X-HE-Meta: U2FsdGVkX18dMcMDydzc/njTZmfHmMmvFeWFQVrzi1+PAHsFfWJ3nRU87+WiJOE6nnzmy0CrIgmrFMgBg6mVEl8bwV2G0Av+PHaqA4OtJnNWJJHwXzZCVBRkgL7muS1kKy6ax1o8lPJt6aidZWoXBfNJyNGb7wh48L996AEYyxmrTzP477KO2Ou4e/R1bvNqtPLHNmHXsP/agkH+y24CjC/uZkEEffwflut4VRUVHBruLkWvUnQwxvU9rqz1gFDFE+XsJdcFBn3xyl30Z4mLU6EVz5nOkGw7OAA12Jy+05t4Hu2Zn9ewj0r4xP4mJ6Crd9XIVB7lGsUyRK5/q5YI1RcV/TMcZ81zTXTqB8hhn0mQQxNktzNWszWwRt32aKGthzgzyqvvnR7BV2ZJsSQKRlLnY3NxkVBy2f88mONzSjb0Eu+xjGOusM0eLB8YzLByZdjkkedhHO17w61WGO0NOwo5nkpCZ1X/M7Ow8Z0ZYgR5yegCI0QWdHQQ7wHSmEQdzn5a4Kk2S6uruqQu3xT7opIJaRKMq9MWTNP2lS1LYQafY7dfjuN+LV35iY16OPxO8kY5Q9oLpDl1u2yZ8rC4hO0ScaI8WdfdSkvpzGJHfOznsUqPPtjawFPqwgVYMD4HjqGa+Gmj3EhdJmEiVWtLugjB5hGrBNPFBCCxlTSfSsq9FASXWQVr+IcgPt/G3R3XU87BfZXdB2B3PMIUPxgM05+kuDZNf5P7Pc4tyZ8h8jibuiGiA93Ao71PTCDNRZ5rMJGpW1vMuY8YaxGwQ8SANrRkL0JvW73DCFEILV2utyXT1y9q6NJVfDw4b6uqqZCXGJubRzKFn7lICIxmoni5fkFmLu6GzilEYAZPP3knMh8ujotFAlf4OgFscBKuGVEHnBEG5PaRGWJ3vtTrfXUo0b2W0Z/U9HB3eQVp/KFQHIvDxZgJ7fGPYNZdx+ijB1PwCCB9anmNyaDxKcXwUcA
 MTdqraNi
 LkczzXBs0RqVai/0GDYGoKhvvAZhnK2dobdbl49ELqGqDrZeOcNgKAPPRLXI+7atp+hbSP7wG8oSJAgzeTOLZfH4GyuStxX+ClBDcQ/XNM3DRvY+4FTQe/jleSGqg7iRQk7wVC3SXBl3Rohza7aqOgzJXYs6cor2RSmP2w+s60gNrahR0mXyIcNkJrExZiQjCt44h9N8O4KMCJoZlq5MIysGsda0O6AiSRtnPMZWE0xfvoEp6B9VYaX99s/kkDhlp5leh9w2e/kOrXAvzxKFCYX30jBzwycfqCjAj
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

Anthony Yznaga (2):
  mm: fix mmap errno value when MAP_DROPPABLE is not supported
  selftests/mm: verify droppable mappings cannot be locked

 mm/mmap.c                                 |  2 +-
 tools/testing/selftests/mm/mlock2-tests.c | 91 ++++++++++++++++++++---
 2 files changed, 83 insertions(+), 10 deletions(-)

-- 
2.47.3


