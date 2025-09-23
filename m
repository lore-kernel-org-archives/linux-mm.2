Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E36FDCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 18:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32BE38E0005; Tue, 23 Sep 2025 14:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3034B8E0001; Tue, 23 Sep 2025 14:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219A38E0005; Tue, 23 Sep 2025 14:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 101E88E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:47:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAF6C119E41
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:47:23 +0000 (UTC)
X-FDA: 83921397966.06.707767E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6741B160009
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:47:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=J1WktLVE;
	spf=pass (imf08.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758653241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=x+zutkjkcpITR/cVlfWCAq8Vz9RcZ8fZjfSm0216Pbc=;
	b=xX+rOzX9CRjaQfizqiShINt6McMnihQSwAwF1gC9nRuf2mWMM9s/CDOxOxL2ZvHrP8Twqd
	7W3PNFEacWIossFuePcUbiKvYZ5XNqjJIJdmjDF1gBXQa77CuduX2or6ZuDju4TJlp42Z0
	Wa2C9v4zeqmHSFqK+S/b06+yd3ev1RQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758653241; a=rsa-sha256;
	cv=none;
	b=NFLo0damO/mwrF2r8wQca6Em97kwaMnrKKerqZ6IgfEVklE/DMC8DVU1179Is6DcZsev/i
	CDRTfTzTQTuV+zZLjQrIfWkv/wWt4QzNNsl8j2TVXqHspE9HlXO4Ad1V2BdSuuddKMmEov
	ASR7b6cXk/RC/FSGlUlgBqh28QQsx7I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=J1WktLVE;
	spf=pass (imf08.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58NEE2aF013794;
	Tue, 23 Sep 2025 18:47:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=x+zutkjkcpITR/cVlfWCAq8Vz9RcZ8fZjfSm0216P
	bc=; b=J1WktLVEVK2gcBRPrfQYgAES326ihgJ4g3nwsInNPGVAoqC4Kk3VzM5Gn
	RY9ASX3Fp3jBTnUaIhO0XFjWD0U/Aan2BM2TEu+sZS511jo591dIMNCPDkxJLUAG
	U8jAaFKYFrYkSObLJEWT0klYNvF1FaprzrNZMIT4+NQfC6904nL+Gx+lBDBu4YB8
	5X47JCw8gN0q1iF9Zl4OHfubZtv2Er9Wlc4w/yiMuPQJqtMJymUkuBPhsLAoTm3j
	Gkmae6NV8eGnKqsxMDz2+gt5YChM8IAqGpna5DfgkCDIx/7fs8D1AqESA6bbwGcB
	a4n0xIITTlQ7/XUBG/InFEbklU4iw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499jpkapf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:47:20 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58NIlJCj023409;
	Tue, 23 Sep 2025 18:47:19 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499jpkapf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:47:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58NGigZv020197;
	Tue, 23 Sep 2025 18:47:19 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49a83k4vr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:47:19 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58NIlF5d33948080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 18:47:15 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 147B120043;
	Tue, 23 Sep 2025 18:47:15 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5038620040;
	Tue, 23 Sep 2025 18:47:12 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.ibm.com.com (unknown [9.39.28.7])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Sep 2025 18:47:12 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
        Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v3 0/2] mm/ksm: Fix incorrect accounting of KSM counters during fork.
Date: Wed, 24 Sep 2025 00:16:58 +0530
Message-ID: <cover.1758648700.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=L50dQ/T8 c=1 sm=1 tr=0 ts=68d2eb38 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=sIImd-A5PneLSRPQBKwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMCBTYWx0ZWRfX1Dqzv8uZYpWZ
 uZ5LkamgnttkKj3jHM4LSCw43b1SR3rwmKjkpMI/zhgEiFR+ig5KlHKbGxtHLCMacpQ4yRXxizJ
 m7wkBytJpyiaksJ3mKWGsz1rmtSRpgeYyKswJHeL68u5hqmY+zt1KmWuvcEhtekyj6nhsF5Eo69
 HjSEHzRnrToJL/3+ckuXFr2j9rjkwb2ne08hynlXHiDMmQ5TH9CcpqM08P0EGCFFmg327YT0Zj2
 xXuytrDUYoMOkR0ukuv70C10/s1dRQRAJFbmMvVhvuMn3Yy38zYRACQD8MLmmjmEBz1tkEtKntw
 Lxllqnr8kuLc9C4xWjL20ravcUubPe224a9paX4GS2uiQBqnIsBYZnYpko3OBnmlf5i35lTeSbH
 hnohqcDi
X-Proofpoint-ORIG-GUID: HTuF79VZUro-IVeOrC4eXkUtMXWbhVjy
X-Proofpoint-GUID: mANJ3viSGXY_txc0F596Y8jBwYg7Jcph
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_04,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200010
X-Stat-Signature: nbb98jub4pjci37e7qxfzau9yimy3ipr
X-Rspamd-Queue-Id: 6741B160009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758653241-654931
X-HE-Meta: U2FsdGVkX1/lb0SaTvrXiYnlBYzoqdii3puRdTg1q7izGxqVerztK4zEuQbmKqh7y1t6q+7YEPq54AJPffQ5AVilwHYM5TCbzBawOZzOfi54NwcydLkTfew1iFQMXYfOQd61yrfd+6RFQhbFHsc9hl5UgAD9Q5mI+KjUQwXsqdy24NP65tE60ulF8OkHKRm4+bphy3wJzSC9FqWrKNpjZMUjyD5T3e8JFN0Ca4VLZIECYuuTOg8VKVqqD5nUXU6tHWBKWj8cefl1TD8rjwrUB+bCBb0QcQcWc2CRFYAuLzdmeOHYNu0SshVVoHhXPV6iHmy0/tSZ1Y4M4yaLB5RiDTVrR2csP1c8ZiXj9WFZGt/rQNEIYaEKCAlcybagfaHXt8A5CJxJvVUwV/SmBBYYgvIWQThU8xs38R+k621Tbw70AtGVS4tc44VvQt2GXHVgEFk2DQ6VD7NDnSNtnVeppK6b4/pEhoSRAkFRW/MPtACrrWPuHrF4okzyyitm7cIo+tGGuxNQ7N0VSaqRoCz+4/W7atqsP9weZiNnQCZ5qOzqfSCr351pfOCI6+gQm2QqxTBWLyWtevoxBzvT+h/YBVpMRKt6T/P6zos31hMsQGJUfzu2rimJq03D8icz9SOcDUYC/vD01rmOlxqq7qV0VrWPqdkDYJAOVRLAMXjeQzjbyyaYcnPUaSxzJgHphUhkRDUqp9Uy6LgC/G8vGNDSFHkZtM49YsWpDJEio5/GEQUdnR9gjYbwntnE8O2i/3i6Yq0fcdlg5eKprNLxAKr/38UHyI+vpRNGBln+9HhHQ2h0bhiuQjanT7fDJdvpjhMoPUYYWTUXMoAbYAsSVEoPt6WbesIfw3UvFWxXMoP1CKdE2gTIPJ1Af6X08lULyytmCR5pCkXp1uw9EmKrm8Jc82/Bpi+45J8/MamktSdY6S+eAH0O+oAzsjf6W3UikkiXGu9k0p885WJ7hCCFb80
 ycweKIf5
 HrboeRR5tg1/vzlIVINcBFEOEGi46202HxWDCDR69/hmQcr2suhkk89hj0usafNYN/uscqZxR+HqrGQ8H2qx32MsjUpaOjbvFJ1kEZ2Yb2eQknYtFomulXV2YcsPNm5MjJyTDIJIYWNdvltMcPDcOwl1EbZonFtsixttZt2CWEhr+jKkMQK5sgzMHmewTHJsYEkCEjJKfah0R5UbNoscJ8Que8mGQMBoRcNchwHmZ9Y62I3eJlUjVJFfAWG7oaoVC8QMn1r5/gEGQSsmlni12iFOHQbX132tckdfdy5+o7nUWWl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first patch in this series fixes the incorrect accounting of KSM
counters such as ksm_merging_pages, ksm_rmap_items, and the global
ksm_zero_pages during fork.

The following patch added a selftest to verify the ksm_merging_pages
counter was updated correctly during fork.

Test Results
============
Without the first patch
-----------------------
 # [RUN] test_fork_ksm_merging_page_count
 not ok 10 ksm_merging_page in child: 32

With the first patch
--------------------
 # [RUN] test_fork_ksm_merging_page_count
 ok 10 ksm_merging_pages is not inherited after fork

Changes:
V2 -> v3:
- Added Reviewed-by and Acked-by tags
- Added cleanup on exit in ksm_merging_pages test.
- Dropped test_fork_global_ksm_zero_pages_count because it can give false
  failures if multiple processes attempt KSM zero-page merging and unmerging
  during test execution.

v2: https://lore.kernel.org/all/cover.1757946863.git.donettom@linux.ibm.com/#t

v1: https://lore.kernel.org/all/2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com/

Donet Tom (2):
  mm/ksm: Fix incorrect KSM counter handling in mm_struct during fork
  selftests/mm: Added fork inheritance test for ksm_merging_pages
    counter

 include/linux/ksm.h                           |  8 +++-
 .../selftests/mm/ksm_functional_tests.c       | 43 ++++++++++++++++++-
 2 files changed, 49 insertions(+), 2 deletions(-)

-- 
2.51.0


