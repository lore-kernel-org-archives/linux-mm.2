Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C819CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C508E000B; Thu,  6 Nov 2025 11:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B537C8E0002; Thu,  6 Nov 2025 11:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69298E000B; Thu,  6 Nov 2025 11:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9579C8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:09:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D8EB86BFB
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:09:07 +0000 (UTC)
X-FDA: 84080666334.15.38F051A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06D81100017
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:09:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Age+i2ve;
	spf=pass (imf05.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762445345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kBkC7zrPOewXW/Pk0CVDrxMn8x8sMd++XtEVOn85zQ8=;
	b=77majxuaLV1ubiE/n0imWBgnmCxdsEUdjMYFH2UWBnu7sigcNeOsS/M+VNgyb0h1nMN7GM
	Ky0WUtoZGjaovODsBFzUWpQvHiylDb0YDhp8MAY6qTtSLL4jjPLKav4xFGI+BBGuptpzaa
	5hXdHRkfIrwtIP2CWxTMM1CaC76voIc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Age+i2ve;
	spf=pass (imf05.hostedemail.com: domain of aleksei.nikiforov@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aleksei.nikiforov@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762445345; a=rsa-sha256;
	cv=none;
	b=QkxVSeb309BMTjpgFn77At59+eBAZBDa07dU7nlmhzEHoPwaGHWW/qJDNThlQ3yn5Vz4s6
	/f2l5e71mOU/tS0gbSQBiaUD9MC15O21CiNjrQAvuCZKxDNZsamlTxVc0glWeHYnxgv5xN
	QU4bhgnLXJaFccy77QApbXdkM61aLrI=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A68oc4A030782;
	Thu, 6 Nov 2025 16:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=kBkC7zrPOewXW/Pk0CVDrxMn8x8sMd++XtEVOn85z
	Q8=; b=Age+i2vePvB+LSLLLbPL22On/jr3dDndzvp0l0zg+j4ybFKYUSEqOOFT8
	rFNvgnVaqDypYIqjbDZ+8PfzNUViKkd/3CeLqeanToAOHGQfblNpmpN+1GvqM2h2
	1HmS/iHc0J37uOF4Yx5Yghw00W/QZFi9+QaCTRw8j9iPW2XyzIYgqc6klp4z8JpI
	OfLNVzDMxGpAbcU95Y4lXoLWwu0kvVisI8v2b3roxqOAOVm+R+C7zBv8DFb4Vv5R
	hyjiujyLjGbVSXGYU/uHmnvLbGwJslC/JYx/2zhCIflxUQ3gb2qEzmrtT/EpoI7n
	uVHIQIwsSkjqf+D5WkUP0mwV9AQig==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vur6gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:09:03 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A6G5juR007347;
	Thu, 6 Nov 2025 16:09:02 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vur6gj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:09:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6Eddvg027371;
	Thu, 6 Nov 2025 16:09:01 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5vwypfgj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:09:01 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6G8v4h32113122
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:08:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 59DE220043;
	Thu,  6 Nov 2025 16:08:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65D9820040;
	Thu,  6 Nov 2025 16:08:56 +0000 (GMT)
Received: from li-26e6d1cc-3485-11b2-a85c-83dbc1845c5e.ibm.com.com (unknown [9.111.24.158])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:08:56 +0000 (GMT)
From: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>
Subject: [PATCH 0/2] s390/fpu: Fix kmsan false-positive report
Date: Thu,  6 Nov 2025 17:08:44 +0100
Message-ID: <20251106160845.1334274-2-aleksei.nikiforov@linux.ibm.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JOWFrIeWMqn245vgRdby_F5E58YycLMN
X-Proofpoint-GUID: RJ6XjdSFawZ2LFKDN-n-5Vl7DDYv_MyV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX1ELoPqIfaNGt
 pAGzcEvZn/IFCkh4ow9Wt7zqiZLP3CvoGPoEwl7ACHl0M5ihGA8+jBbE1F9O5mP34x/ZxB59+Hv
 wGII6SGUw1pp8AyxgFjzqUgev8DzvHk6HXlnRqqv/1hIJlCAvPxVUG7a18lAgtrV+FZkovdbu8z
 +Zm9Ywgkn4KJ72fqd0/dT5ypV12/sFlm5OYRbqorr+KF9jh28OJbCRzujL7BanbQi02FAYYTRkT
 7qX/geCOAyFBHeYH581bkuHLB7Mq6avMqfhliGyeHLcoPMONQEXOOf/l4YHr6ooOMInFyaekoi6
 U/Pt3mXlAN8xAmMZXjmIVfgzRE4U5gSD+hlVeXtlX26SOoYRpNclm8/fxTYnTrGyL9DiKdjb7id
 +yBQJcQIc9/mAcdEnuQphbZQQ9z2sA==
X-Authority-Analysis: v=2.4 cv=U6qfzOru c=1 sm=1 tr=0 ts=690cc81f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VIxkIzLlmwRAJRPTlxkA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1011 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511010021
X-Rspamd-Queue-Id: 06D81100017
X-Stat-Signature: 8yguwurx9jdj74ws13tt7w879mfenpi8
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762445344-427787
X-HE-Meta: U2FsdGVkX1/eO94uvC3v/XIC0M5v0fOzrHWgJdW8buuZh4pWeFXp1pKXFdmNjatyh3KsnShFG2CV7Y+VEXNDqbLj6YyQcshr6qQGlMjPUKFgXZY0Xvi108VuhgfTHrC6FC+mxHF6qSBfdezc9F7kShSXkBj5IlNqnzJcj+XZhHFSpE7hvfiEXPXoRPrPVn4XryLx6u8sQv0wi4b/QxitSV6PTnkCBVnnsmSQiBgTHzaXR92/Vhinrfehb5y52Hh6uzFPudQleCIm/UPS4nJDCSlJATsUMlKNdkRELY8tWhonjiibIQPClxqjbL9BdEaoYc+xW2trNwNNW9PJ6NsBTmhweSoOhg/7SNScveFJeQMAX5pU9Kv7dX6tqAnl6qv66BVUzxhVAExOcsFBffYBaKvnN71SQkBTWI8uyU1oPQYKjwl6CTMeHE3oUOXVXQ7I2H//mr7/JAj9kJspezjVrm2D+XxR9UGxmvoaGtu72CiuREknMDVlwTsSq5pRrNIEHXll30pSK/OuOOxWCepviMKansFT7w/C8TKm7ZpGglt18rWlG01Ao81XXi3RAgHa+94TpHPzHtGxS8ASjiBxy2r2J/hsoJ4/2jg2P7fqQcpwtIlYQTJJOqTP1dzLZu3WY0EuCDGU758QJPr/6rRXWayMVvrkscaAfx+9I3IVxeiz9D6jzDgvorrPvUaGit+pCMnKeUfpVnd07ZrsJoddxhJMQW9RR5moClr7d7I9h0sLBbVZTMdv4w0ncwCXT9vkb63aegaOYUQsnZZi7YwdLDTOj8YPgB1QijVrs+3sl6MQ0o+CChnvKrM5Sz4LvFM1j+tmknyMHa3i/5SfMIMTqr+UmLiEVwwn7Sc1+lHBX7IMhSYENe4Qeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A false-positive kmsan report is detected when running ping command.

An inline assembly instruction 'vstl' can write varied amount of bytes
depending on value of one of arguments. clang generates kmsan write helper
call depending on inline assembly constraints. Constraints are evaluated
compile-time, but value of argument is known only at runtime.

Due to this, clang cannot generate kmsan write helper call with correct
size and a kmsan helper is implemented and called to correct this and
remove false-positive report.

Aleksei Nikiforov (2):
  instrumented.h: Add function instrument_write_after
  s390/fpu: Fix kmsan in fpu_vstl function

 arch/s390/include/asm/fpu-insn.h |  2 ++
 include/linux/instrumented.h     | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

-- 
2.43.7


