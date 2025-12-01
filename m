Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A642D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 06:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A11F6B0008; Mon,  1 Dec 2025 01:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251B76B000C; Mon,  1 Dec 2025 01:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140836B000D; Mon,  1 Dec 2025 01:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03B326B0008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:00:25 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6986EC0881
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:00:21 +0000 (UTC)
X-FDA: 84169852242.21.10ECCF5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22BE6120015
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:00:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iIXceqSu;
	spf=pass (imf29.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764568819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CsqBDxcbLfMDp4rivrDSMIGU/MUrsD/8o4nba0o+AE4=;
	b=8V6I0EkeKjPT6bagIZZmtMXJs6I7ybRDExtwDLrJC474XgOMo+w0QjK82D1AbOOcNNecKZ
	al7ZdfC4FcQXtkE7A4FDN2ALN5Ru2QVPgLhkVNszQJb0tDFgnJQByTMVwRtODVDRG+YYOn
	/I+vXYLlk4kBDtrT/m0Padj78S/cLTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764568819; a=rsa-sha256;
	cv=none;
	b=J9Z0AccbiuEqODK6YvJJrfjYmzPbNnyuk/X4R29txViYZhgHNOS7Umxy5SP0QHbY0HdpHv
	tT0zJGT6f0iQons+8PVdJ1qbGOnyBs+Y4+ToTMwQ4KfJ77oNQjY42OI1Y+iVfvLLBUN75F
	T3/GXoExaVoQWOHkAF5Z4xX6MUiRYdM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iIXceqSu;
	spf=pass (imf29.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AUKikaa013911;
	Mon, 1 Dec 2025 06:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=CsqBDxcbLfMDp4rivrDSMIGU/MUrsD/8o4nba0o+A
	E4=; b=iIXceqSu+hKJMZVLLHFExmAuSaIJrJhR/lPUbYZworq0EmT/x3Bv6hdyC
	QM8n6Fp8wtqK8A1FlMyDRp3z4FaYdCT5RyGBmT/1naMIYXs4HAiRiqhA7w+mFMrr
	HPU6muewkhrKNTaZCFcp1ERb9toDiBYSnR1BD3itNpZfPowmTAB0NUyIrC+ux3eZ
	liXp/NS2j01EMzTrqIL5fVtcIDTNSj5mYAFZD4tEF93bpq9uziuMgCiTAc/WN8rp
	bTpuqmPpGIhgrOwBGiZNmOu1gg7F8M8ygnnYkGCuiZmrTf5sW4bT9pFvMwcPvnRR
	iVpN7hDw78AmhGRlXUuPUFkLt9eEw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8uddpy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 06:00:17 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5B15urMO005109;
	Mon, 1 Dec 2025 06:00:16 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqq8uddpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 06:00:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B15ZrHf008660;
	Mon, 1 Dec 2025 06:00:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4arc5mmn1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 06:00:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B160Dl461669776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 06:00:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 796A72005A;
	Mon,  1 Dec 2025 06:00:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3FA12004E;
	Mon,  1 Dec 2025 06:00:10 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.25.199])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 06:00:10 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
        mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
        ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aboorvad@linux.ibm.com
Subject: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
Date: Mon,  1 Dec 2025 11:30:09 +0530
Message-ID: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I6Zz0Te7LqG6Od38J5XT0JKtOxWb5Fg2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAwOCBTYWx0ZWRfX59T+T29ZLuIP
 TrEWf7GUTc6uHOc3Jn9zeiYow2oXxuEAlpqPAokgYLn9i9dCOhzAIlqNaxIRAkBKhvqiIBsNaJl
 iGhczfKsQZBhuOOi/Ue/wWJPBqF5NqxKy9V1ibi/RngTl/s/hyfUlPzLH6wheYs2zu4lod+yVZv
 qx7qJ2QXRJxShhcrDurb8qR43ZF75U+5y4e0GKdRksKHMxM6Hgx8LXP4Sr44H07rmT2ZJR/Rv99
 4fwoz/CmtZvV8/4nb+VU+VMosTionHAufOA7Vwi+bN4RCccpxUuRalAXepbPp0dowNeBqdnPMOR
 qfYkm6+xVdPt58UEIZ6M9wGdh+8b5ddza+X4LTsw3PGKDC86Whu18G6Jjg5O4ba9lo5ANu2agCa
 jayqpWSMug9xh5C0wFPfPzedJGDJNQ==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=692d2ef1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=JTTQk8T6qDu4cFRdm7cA:9
X-Proofpoint-GUID: v6pVxS5lSzo1eGk14e7KJgQXVxUQ0rcB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511290008
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 22BE6120015
X-Stat-Signature: co4cm7ns5ejndet7xd6nbdf1641jsapt
X-Rspam-User: 
X-HE-Tag: 1764568818-9951
X-HE-Meta: U2FsdGVkX19JzFHJWyJMc0Hh9laKtwBJ3rxS+iifts6QIwjHyOqIFMjAjT0an+FJYdePt2kJhLxZq6ABUqb5YOPkcg1PbkhuwlZGv9LTepJTgTT7XagLQBcQI+UMv89fwiMkZRrIgXH4lMbF0x5GoqY4XNsZCSBrLiKUH+OvIw0LU/i1N8ylb44mVNjmY8CnoZozOY2s2WYt7Y5nUW0ejUnUrqEyc/yKOxQKYh2L3MJWt4xm7Yk+lxMc4EPOXrhD2iydvXhTUEa0RhFH5DlZEomG76Nbk2wjZ0wS4HAUJXWfBlxm3OB/okc+m+XJAXheCzjX8zO4Ns1hgwjOzteYQD/4LD4f/B+YaOKwGY9mNkpCJHVf/iIJCr/AZM1VlTUM6u/CbKfII/o0+lRnIw0TG6VY0LnuHA9djedqXJ80cVfI5s418Y2ZBA08P5K/i8XHMKnYUhgUXdOy2UBVULzAw7AByNO7JIAiHIVuA/PKj5O6g7sAnNQxvP21T3ioYf11cAqrzuuMjz3fKFtCmhEeDWGZMXAPMbPZwFzNANfQlWuhlXImTSmRpd2y3N9kezs0SJbvt6UBj4X3xteaCOkirzHXn7EdUlR/E5mcvwGjismTQfqNZK27c5/iTRTr3Cn7BN9nWvTR6DlZLhAWJ9TaMHdRfBLrwxOwmjp9f5dalQFhDJCJAIrF4D/tmcFmQBrJz68ni4tcIB1vw01OAIP1WcZTsfQwUMN22jwhitcl5kKYtdKlBCJm16BrJ8Wjzw/Kvj+hK1FcRpwRqmey3ZqBbVbsVQvEqYU7KpbvLcPW88fvI4jn0VWRukPzeIz1nn32QavpCu/wskygsK3B/YAvNuGT4wvIVMwGCTtoJJQOtcNWD3GW5+UWhzlzP84nhsUUT/Jt5wF9f4b8nNnpp+dm1C9+Fj6f8Izr5Jxd3DdEnhgkgD4XcO58kHVsBBwz8caV8RHRoSfy3ZfLXxwigfE
 Pb1J9hDO
 7q040wFgFxa67Fs/rrVFpRZnDI4r2Zb0XWqM6yg8Jt7xZ3na7pLVbXByrLfSWW1mahP3xrxyx2FL7jzxRk8lXJKRftSInfB/zceOlO00i5mFXFO3uladNyZCzARqhrqsmaalwyzj7bWuR5hIoDhcnAEvgtVSRSYw6U8VHY6N2DlmNOhqZTz4xv7fxS3GU7V5X/jrpD1lMThSzZtFJ9t8Cd4x805mtZS0NS5hff4w8JxdJ1C6G5WvTe5c9cA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When page isolation loops indefinitely during memory offline, reading
/proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
causing hung task warnings.

Make procfs reads lock-free since percpu_pagelist_high_fraction is a simple
integer with naturally atomic reads, writers still serialize via the mutex.

This prevents hung task warnings when reading the procfs file during
long-running memory offline operations.

Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 mm/page_alloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed82ee55e66a..7c8d773ed4af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6611,11 +6611,14 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
 	int old_percpu_pagelist_high_fraction;
 	int ret;
 
+	if (!write)
+		return proc_dointvec_minmax(table, write, buffer, length, ppos);
+
 	mutex_lock(&pcp_batch_high_lock);
 	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || ret < 0)
+	if (ret < 0)
 		goto out;
 
 	/* Sanity checking to avoid pcp imbalance */
-- 
2.50.1


