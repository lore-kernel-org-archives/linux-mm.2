Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D5B5CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D7A6B0096; Thu, 25 Jun 2026 08:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35206B0098; Thu, 25 Jun 2026 08:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4AB06B009B; Thu, 25 Jun 2026 08:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93206B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:41:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37EEE90779
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:41:14 +0000 (UTC)
X-FDA: 84918395268.08.A2A3793
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE8E11C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:41:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aN2OkwrG;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782391272;
	b=VOYPnU+cEgxMaGJ6wASK2KLJUfBFmzyREIBBP13HmfvlA4RLoSYjESpiDU8To3bUuregnc
	A7v5hSUupr5zCVu/MfmxPoMrioI2mP+NXpUB8e3c8SMAgk6JcyrbWNUg/noLl3PvQygQgC
	UhUrFDQ8RpGq5AKuiw5HPv+mGEgGV4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782391272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/FIcy5VYAad+2tZYzaneZS90/1op071eXRZTRdPJDdc=;
	b=VqIHUfRuyZc7omHf16w6vTXNEk7+XaCDiBEdjipGe3mcwZH+Mh9QwrZ/VBEB33auIANETe
	+/pgtBhYSMCQngZQ6NkC/CRIdAdcGNuuRlknGRHg2j8HuYMIUoaShZroFbpza6tjNU3HMY
	dSbU35CHlAoIrD0VyBuwf1fPjf3Lx+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aN2OkwrG;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P3n2Fo2890175;
	Thu, 25 Jun 2026 12:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=/FIcy5VYAad+2tZYzaneZS90/1op071eXRZTRdPJD
	dc=; b=aN2OkwrGpBVNXntWIYCMfe2M4t8Q/kZv2943OxYC0D14S9TejoPEQn5EF
	Zmu0qwIceLDq5j11z1mfoyDj1Aix8wonJAdMMbZ1srdehQIVvKt2DevrL2DNJdVL
	Tv0LujdhhXdQ0uW07R/ebnYdBwlDHwp2Yu9rVpOoANSsyAIssD5X3BOFV//qFRac
	OBky/IUJfh8S3iRkiEQTY8cQnp8BX778wGQe2cQ/f5hl76nCRsG+NXn6pTid/t3/
	TT/xqd/dai8rCSGe8aZtHzuM29bgtE6dYePy3U/UyHkawavBmdiSzGFMYE4+wDp/
	yK3wu5TVN+fk6rrpOOOocAQ+YdQhQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjgt1bgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 12:40:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65PCYeif013544;
	Thu, 25 Jun 2026 12:40:59 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex5jwp8p6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 12:40:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65PCetiN49807862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jun 2026 12:40:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26F9420043;
	Thu, 25 Jun 2026 12:40:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42BD020040;
	Thu, 25 Jun 2026 12:40:51 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.21.143])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Jun 2026 12:40:51 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 0/2] selftests/mm: avoid false failures in hugetlb and KSM tests
Date: Thu, 25 Jun 2026 18:10:15 +0530
Message-ID: <cover.1782365671.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDEwNiBTYWx0ZWRfX+pzfsgCI9YfC
 rqm84zEZZGm9qXuQY06LMuBL6O6Wg2WuEDAXX2WS5q6/UGjbzldMT/iIu/Q6+UT/Ttsrl3uu11F
 JKZ9DabKLi5AYneABAPok1XLFrUW41D1xtR9WIUoB/E3RMGcItRo3R0y2oY+i1IUD66nYCT4Y/A
 mmJAbLKjktDaqZqvpza4/iekgvH3RskKxeaQoGM3iXt3CzZ1TU9UxDphixG6XrekOGoLybjDXvo
 kZ+Twiwtd9HhzTUZvxeDXQWqFPPvxTzgGG7rhOshYB8J7WnDf5zknrRi9VwiPG0e+zZJEk01r5l
 LGflhkiVEu2HlZLi2wlSQmbIc/1K0uzUhrjhLgtdP+riWHQS3EjofRB1NEXGT4PaRsNSJs2DzLL
 8/6NJR4Ery0FL2cZ7zxKPbgsaTWXaiG/nPEF953KywThxOgNy2VEjSAfPpZmWsArPzvJ4kYiXVW
 TK3/fZ42WpqJMKgO/kQ==
X-Proofpoint-GUID: wvXnOcw3yMUp1B6tzhXcaLeWOiadoVVq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDEwNiBTYWx0ZWRfX5WTv3XNCjeaX
 XWbm5MNpKHuDvG/Osihk8fpDtuOHgfjHbGB1d9NRUciwmJNDjKuYBDDk9c7lo/6UdcOk5W7Cf+S
 Z0HOr4EJV4gTnnP/yPdhXRY0RbBqaa0=
X-Authority-Analysis: v=2.4 cv=I/lVgtgg c=1 sm=1 tr=0 ts=6a3d21dc cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=-j2Td5Va5la4C7oUbE8A:9
X-Proofpoint-ORIG-GUID: axG6r6divsSaBiTKZElGReQERRgE4s27
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-25_01,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250106
X-Stat-Signature: uhcxsgnnn4uwnoudgxawe8xoyw4on9kq
X-Rspamd-Queue-Id: EE8E11C0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782391271-625641
X-HE-Meta: U2FsdGVkX1+Qw22MjZ4+L0uAgeBwduGKWqU+a1D9RROSy545klxxpe2KiU92d6gTQxLmD+i/Nls4wFPnGSSvhR7KpeZt7vZHD/LS8ov8bBe91X9NbCMdvac/Yvk47A+q4AxyZB9lxuF6XNngL/jV965DezdXVIIWywBeTC09Hs5SJorbrVWNUXMew4eHYE+FGo9J2YtQIxJ0lWmzat3bklT4YuDFsLqhTSp/AcUEryWTON/yWSyXm8+OG3PUejWM8S9d1NnD4DLHfIWMCSfpnNEV0v/UB9XzEwwSE6bnp9iJ5p1fBlqyj9MKoqFeguHSS7BilVZpGVBxjGfSzLDu5/18MnJQtUiEcXrfPAKErGXwbKausjKrmdFrtbIZOVdexE+OhcTKGz8StWVOp56rPelmjyoHmLsrw8gupszJQT5I6hJCqKzR3HRxP+84biAUp3NgPG+h9sUTLdHWQVR160eSHbU3HzGtzTtgl1lyatTA2xooEHocdoCUPLDPLPQPZAIKamMZuVcb3ern/g/SoeiW4ePIO+cW9/aFruEyMyD1X/NfvXeJ8s5SYeCPUIrRYpntAAbGvYayhKQ1h3xizPzc+ikxeWgDxc55Wh5FWbBBHaIM1PBVdmH41eirKhdaqDkdSe2iLtSBJLLA7pY4xI+INqPeGbdclqr/CPx13miG8DFXenaqJbO6aFJ84ZJhSjEqGNXeM7ByB4fmjAQ35lq11OypCw9ZmxYACyZ8d0u528VsvEoISVYric/uCs5HkjS3NzY4ug3ID+AictKi95zSpksuk3NY8KLhUnGkPT3JC+i+O8VjnvQw8/wBPQ0ZocPqIfzzSzCOXk1OhWzxfJQTa3Lql9650EtQB3A6xAyg1ZT4R02kdWgX5eqcDzN+1Rru3fOyVvj3wdCFAqviA9dTkmfOaVQszhuXfg2lt1Wet/nepodGCWFfa73t3+J6+HTeLdJlDhBEmJ99fNy
 cJ3/hQU1
 wiP2NhRmFq8LHQOmJWXRswXN26QHpmnbAXByF8ZW7+pfMhCd3PKL+2vgZ8LhnDpigx6MxKTgN/IsHIj7dnn5MSoJ8Py7HA/CZKhCI8/HUOp53io2CxG3h6FiuAkvLKZDSZfk2cAHQYXXYe4qdvtWIQ3/Nj3qbAT1oMIfb8qIpXbdLSyiTla+h28G/yJicVyl9CHjySAaGqlSMCgHm261ErOihTD9kYLY1aaUzodz9LV73jvbkbXmPA5SZZKvnInxyFpON
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series fixes issues in the hugetlb and KSM MM selftest categories
that can report failures when the prerequisites for the tests are not
satisfied.

Patch 1 updates the hugetlb selftest helpers to handle -EINVAL when
attempting to configure gigantic HugeTLB pages via nr_hugepages. 
PowerPC hash MMU pSeries systems expose gigantic hugepage sizes 
but do not allow runtime allocation of such pages,
causing the sysfs write to fail. Handle this case gracefully and
continue running the test instead of aborting.

Patch 2 fixes the KSM NUMA merge test on systems with memoryless NUMA
nodes. The test currently relies on the number of configured NUMA nodes
and may attempt allocations on nodes that have no memory, resulting in
spurious failures. Count only NUMA nodes that contain memory and skip
the test when fewer than two such nodes are available.

These changes improve handling of unsupported test configurations and
unmet test prerequisites, avoiding spurious failures.

Thanks,
Sayali

Sayali Patil (2):
  selftests/mm: handle EINVAL when configuring gigantic hugepages
  selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA
    nodes

 tools/testing/selftests/mm/ksm_tests.c | 26 ++++++++++++++++++--------
 tools/testing/selftests/mm/vm_util.c   |  7 +++++++
 2 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.52.0


