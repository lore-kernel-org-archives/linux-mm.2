Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B24D6AB1F
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 23:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECDB6B0089; Thu,  2 Apr 2026 19:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3E26B008A; Thu,  2 Apr 2026 19:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E8F6B008C; Thu,  2 Apr 2026 19:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52F476B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:59:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B64A160174
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:59:47 +0000 (UTC)
X-FDA: 84615286014.22.9F9C95B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id E4AD1140005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:59:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="VGx/hmjN";
	spf=pass (imf09.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775174385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA8W7NxanxiabjHJTYARfF4A16zee7Z1/qp/qvyps04=;
	b=05n07Wy6aUUO0Vcyl1+uBQRw2IUwo6QkzCMbgcbpH2dUqkadlNX1yNPCJaUQP5EnDWzmdQ
	IWCbdlafNBuiwb9XKVPUYgIEdd/eB4XCSGjBCmQcVStozUJnGJv51z+dG+fSJMoCJaF+Ta
	Hx3DB4v2igbHNfC9kE3sQ5yY1ulEwaA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="VGx/hmjN";
	spf=pass (imf09.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775174385; a=rsa-sha256;
	cv=none;
	b=bhQ7110yJWjaf0VyRyImUFVX/IVVzNk4qtnvL7pVQrq4pt4KmU4IrPhIMRZnWljON0ZHro
	920sWWUEj8Wo38PKQSFFleol/Anv3yvJi0B+KLm2W3ZTqlHJHzGwyo7xFHcYVXzHiWGVVG
	SWVSzesnKwkS7k4HAdhjTbL/7DEmBxE=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632Nt1Kx3408690;
	Thu, 2 Apr 2026 23:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=xA8W7
	NxanxiabjHJTYARfF4A16zee7Z1/qp/qvyps04=; b=VGx/hmjNvfUBEB5pHm7f8
	DjQYIEjdZRkly9Ur3xM1DrIrEanNLdKZ6zlDWoVRSYevRMIdAOoyfCTw/6JbilSI
	4B/pmHZUUy0YXISSOfLGVVeMT9CMdGufcksbmxmoB3ov7N26fRtMYy9GWGTl/h86
	BSPeQe+fEZtU6lQX1EqJ0NVGm2PmdnBRTH3UwxmlzHLQ2ZwV3Hkt/PtdcGuA5gBw
	/kMPqYtp1ctswmhfg+3QI3UrDY0jtMUU+jHAX3sSNapYNYOcMnjEgU/PlFZRTFvg
	UkZnPMnW9yo3SjGwL5LJUvAkxryh2XfUflzlxOwCmS3CDVmhx/JrcXwysA0iY9wO
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66kr1c4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:59:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 632KoxLP008476;
	Thu, 2 Apr 2026 23:59:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ekna81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 23:59:39 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 632Nxb6P011992;
	Thu, 2 Apr 2026 23:59:39 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4d65ekna7a-2;
	Thu, 02 Apr 2026 23:59:39 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v2 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Thu,  2 Apr 2026 16:59:32 -0700
Message-ID: <20260402235933.10588-2-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402235933.10588-1-anthony.yznaga@oracle.com>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604020214
X-Authority-Analysis: v=2.4 cv=PqaergM3 c=1 sm=1 tr=0 ts=69cf02ec b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=8mUEbX9rbSpP1ZQJX6cA:9 a=ZXulRonScM0A:10 cc=ntf awl=host:12291
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDIxNCBTYWx0ZWRfX1kv9f3Z8G2om
 XCRJV0DHZNDXtZnG6Jr5JZNsATUwgraezaCLHdeZEZ6VH4SnY6iKtKGpMr8wDuk2fCWS25MikwV
 lkkEDmLqvtrpM7RzVXctZZav5MsPkuT9jr0f9H+JkxKsQlJRVoRVg8ZUDyhHQIuXw0Iw6RnxbFR
 BzVj0IYhwSkDTnMvDdCHzHX990m/bvgrB1avC4R5gBqfsOwuQce/ROe0i/r6KarWIuG1vkrOv4E
 M/UTcNbKe4ZxcwPy1Ry6fm4vwT1rs9hq/x2k3g6EddJBLV2OqXGP5eVEM1ASdpJLqlCkPOmkE3E
 IGrcqkLTUDTJjmLF7epk/tI7kfmH4xVWlSgpV6TbzNLTcFNJcRtHLWbw9kPyFmK5XBoJ9ogw/HE
 fjXhSgksnVoS/ZYPsGuzaaCQtGA/D6mInPF5QLjYVH7nGOuR3wtqafWQwnJZFW6XuFnZsNPLPjJ
 1WW9ucwyFZxhY4GxholNjm4ds1mbgbp8o0j1nGIM=
X-Proofpoint-ORIG-GUID: 3JUIj9xm-8FVoRtXmzIk0pKWijSksMh8
X-Proofpoint-GUID: 3JUIj9xm-8FVoRtXmzIk0pKWijSksMh8
X-Rspamd-Queue-Id: E4AD1140005
X-Stat-Signature: rxtit1sn5mjryesk6ogntj1ua1jkp7gn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775174384-5982
X-HE-Meta: U2FsdGVkX19QKQQLrVhhF5dznGA6VitnjN2ieetMhsX0YKTZSRHj0L69BFdVnxhv2BA37MD9cHVLMPwpmuAtlhSXMrYtrKBQbbV102kBPz2/e7Kx9MlB6N2bM9Te8H6fk+NB20tIO6q1sRtJo0BwJr3kElShgoYKH/AhY4jwrRdBgvZC+yEHsT3XTbNKDs9Y8hzoTEsMAWzvCjz/s7YHwFRsv1y31rtEvAtts9VDiHwXr0PqhFbg8YZwvRSGjFYmwt/MsacuYKPth5z9lW+1dJ2668meb/Y0f7r2d2S7MW11mrGQNkWu3w0q7OouuFGgLNSne6T/WeVIiC8NOWJ5c+39e1AAo9Tiv/wqmLcJdr49/eDXebkLt25F9jjZgWE1VaVXcdhcyg7TNTOmu/XYOdrjxhSUmGvIPACYSqeMvL0l1dZcsYehwOxE1muHCw+yGWAG5/UjKPJKEGFxaoK8UnsL1sHKtCiaerwvS3KyjfHuzrccSJeSWOwNSj+l/N1g3eHvO5KyosV3Uqs/znvqvxEieBY1sQr/HKBc6EWS5OrTBZtQQqXQ1HcWVO8EpdfaU5VNIRDHYy4+7qGt19s5y7rTIDD7eiBB77GcYWaObbxougix+CPs3SIHCemHeaSWXMdBFz39+osSSX/BKS4S+MkkmhLLwHoBoCwCzGtNqJXCWgQ7VXEeMMKMqrSVzdOaJvcl5R427+/thpOc8PZLGe+ZzQf/aG6IcudPEl4bSRppJDwVpuSdKmu6fgh8s5gmckq64NBLJ2U6UEMOO9KzRknOpBJSQ6vvp6/qKEi3UkCQ2WSCZ3YSf0B5lLsB/AWg1dN4Y2hzguA04SQyzvTRefVCOdh92ZorSMnrKr9kdzZls1CtlR3O1drqhzNrrzQX8GeHUME9wsxRuyX3APvjVB0HxJ6TwelR6bBjMle5VsFpcusUuAjkbRiWOybRkDldulREhwD7TZW74ujZBF6
 52WxSxz9
 qaRu5Kc9GmoXejs6y0jdOR3mvHNquXc013xbrgS9VS/OCFZuzoy/jo2bhyr3/gu5iKiHUSjm2lv7NKwPxLKpPRIFhpNlm8c7ubOgXBtGo9c8pXKND767oxL43W7dJ0MkOZE7TFd8cjUMTtwJS/lrAtUxEfyt7NN76wRnpj1ZAMBSPLR60KLnkXN1Hb5bRShAJTvxGZ5an1taHCmNc1oxk8CjvEOqKT8vJFS1hOL/DHzchw/pW0CAgO1FonIMmOVar3juNoqVktZzDxVsDgFNLBONRhlwsDrTvWr0nBor4FhXbkTsAkiKyHnn+xq9w9zRdJDeIUL+LnTW4ir8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.
However, ENOTSUPP is not a standard error value that userspace knows
about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
checkpatch.pl has a warning to this effect.

Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Cc: <stable@vger.kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..2311ae7c2ff4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			break;
 		case MAP_DROPPABLE:
 			if (VM_DROPPABLE == VM_NONE)
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *
-- 
2.47.3


