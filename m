Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DF3CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7615A8E0007; Wed, 24 Sep 2025 14:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739458E0001; Wed, 24 Sep 2025 14:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FB08E0007; Wed, 24 Sep 2025 14:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55CA08E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:41:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4E801DA51E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:41:24 +0000 (UTC)
X-FDA: 83925011688.11.EFF708A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id A335B4000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:41:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MN586EU7;
	spf=pass (imf27.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758739282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UxrvbhRi5qIbb53e4q9T6m/KTCcP0t1N9Grz7dih72s=;
	b=bs6bV313IvcLSM60hIljuALjCXWTslJoHyyVyQd+U3o9YIS4a1EqiZrgZ2ESDPoFirkTQp
	TBDp5kcal2G9Wqh6jsCbC0N90eJ0p314IUx6ybjLuGjVWhwwykDLCyedx5vIQ4XBOTVc2S
	IxcOrDonGRCtjw8XS36+EXUjXJbrCu4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MN586EU7;
	spf=pass (imf27.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758739282; a=rsa-sha256;
	cv=none;
	b=icWjkyaZuj0iZnXm0zPR2IWbgAc53z6h5/hdFvPeFCiamNjNBYxPrTooq1B+p2aaNN8HGh
	cmLtbMTqQEv61WMXu1F8Plqq+8/NJXtE42IlmvPP4uazfTl30y0gqScsdjN1DxH+bUK8An
	k6rIMadWml63wkGWI3XtYXHEMawV+D8=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OAWNhn032221;
	Wed, 24 Sep 2025 18:41:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=UxrvbhRi5qIbb53e4q9T6m/KTCcP0t1N9Grz7dih7
	2s=; b=MN586EU7SDSkvQyJKHTD31RRBBSnCwqRe6vkLxYqPOq7VAfQxdnbwvl2M
	lXI32BtJ/92gi0HVFwOfZZLIM/csybWAKoCIay1E6rsWpuSdHVhntp+iI9KjR3w2
	PR+hPiTuxPBC0t6aYg2Jv1iiYGaN++ux8zAubAuxCZK90SMPq030hoGJCpzIy/KT
	2j8+la2mcyCChX0Ly7Owqid3ZXkcPbXdbSec4z2tMtQEpRFC3bZ+XleTSSSG40bm
	mTG0ZXUuud5ToSb6JojABKULmwcJCf+aM89BVH2VHwSg3y/KvxVnmvj8x/RN0Azf
	RRSp9gWEAkCwcGzFnuGnH6M3lqhTw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpqgwjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:41:05 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58OIUJpH031936;
	Wed, 24 Sep 2025 18:41:04 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpqgwjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:41:04 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OGZ5iL031166;
	Wed, 24 Sep 2025 18:41:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49b9vdb3s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:41:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OIf0ht53477778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 18:41:00 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 066D920040;
	Wed, 24 Sep 2025 18:41:00 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7BDC20043;
	Wed, 24 Sep 2025 18:40:55 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.ibm.com.com (unknown [9.39.28.85])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 18:40:55 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Danilo Krummrich <dakr@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Dave Jiang <dave.jiang@intel.com>, Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH 0/2] drivers/base/node: fold node register and unregister functions
Date: Thu, 25 Sep 2025 00:10:49 +0530
Message-ID: <cover.1758736423.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FrEF/3rq c=1 sm=1 tr=0 ts=68d43b41 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=KFY20ALy1DZ1KhuY3mYA:9
X-Proofpoint-ORIG-GUID: czx2wiS_tSVfgnNn8tsKr_m-DZkTk-BC
X-Proofpoint-GUID: TmIYvx6EGz04tjFfpJeHy-d1Mz-GBxyD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDIyNCBTYWx0ZWRfX370bLG+S6F2M
 wcTVuBvEi37um2hyQ9MnyXoGynceg8EHVrS+w/8fSRxMCD6EPemdeP0Oe67b0pwiRjtiHAN4XBx
 rnZIBQM6tUPVre8sBmj8wOS2Ebcw00WaCpr12HeHxSbvmBLBIwdPFolPZb7dGIeGqDVRyHLJcsW
 YWq7b+FyoQPL5B+Eec6wlaCpUdy4ysN3uZkpxd9vRf0nD9fYyRGwqmlAz2+WiFha97wJRS75Y8p
 M9lkZJhGHSAFcbE9r626xh+NbwWjKcWk/VWrLealcXccYDI+fBsGWCwLlar/MJIpNascuBSV3oI
 TNfgxLML0iNAimfO303evz3EFiZ0YbOZAMxvgJ/BFltNeYCJG9LjplusHi5B7H9Efff4pzLQjO7
 /ocgssqa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 clxscore=1011 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509190224
X-Rspamd-Queue-Id: A335B4000F
X-Rspamd-Server: rspam05
X-Stat-Signature: j7ebgfwfbtajw8mo9pbaczjf9z6xau5q
X-Rspam-User: 
X-HE-Tag: 1758739282-241149
X-HE-Meta: U2FsdGVkX1/NwWT0iAPrqbB9ETDR6cN+2BruXDgpMX0aLhsSFTSTZ9NUEEPKqQhVBjTmMomaKPT1axMUwFMr+YwCaUdSDhmiZfO4rEi1PeOHfnrKOnOMcRZ/WZWUDRSh9Pl5Y32QJFFpCxaVSjt3eSyZWxUYjFBlu3L6seAeCeaaelITylbZn9jFsRVI4Hp5LkJpBmTHkQcxRNVeWYfa9/CG7+V9pEc77d7b+8BTSG5FAZNETvtd8Nm25gcw5mhDiOTao4rIOvguPR4rei1BPPQXHe5Y7Jw9k+Kjay1PdogE5L8msK21BGOYOR5aGeGVZS5V2awueqqC0B+e+QRcJ2vmWR0W+cVkxCqwxTdv3JFFHettM+tXLWW368yjKl/fYVwdOF5cZoNbheRGx9upRov0EbqTVS2gseF3PKCfZQB8GtgNRl6f0kg+mkuzrQ55tfsF6KUTD+LV5nvP30TqAXlJ2tiF9sPk6z3lr+MuZnkfjE+A6HqMILY5H/I/ZZNIxW+Q9DVfq3i+Ev6aj5Da0ZPMUo9vdlv06IyPr7RxOcsgaQKDGZsXxeOJMSV68Ok667OnppeveC5tYCiNUYep/Gecf9iXBoOzi+ePnq3P2laxC4MYDuEcoN2usl7R7qUPrfpekeFMECVVfeUqcWj6kmhRlOUBLm14gp7T3XkjQb+Z1Uq3njuRCYyj+cZVR9m6wVBgbF0eYRTjgUyvnHGOWOkEX/9SlKuJyUiM22Q40OZO0cUrz/VYKqgTYKd5u/RwNOt7ebHS8w5ndlcFzH/5sr+S9vc2rdyEauDwasZvJgEUDz4bW/as2flhPZuuxIWxTZX2O83ANPTeqcKIQW+x/srNwRJsoPLlJRiwVgwL1Z727riUDubLNKEC5OJPYPRnj6zG6awWsBSlmNUz6mU1vb9xtZBCDNVlP1guXc5qzaT1k6LxKKHk5mzIZ6kHVX0p7PXdBu3fv4de8WCGTD3
 mmugyxnG
 NDeBM2wL2W1HzWOGnNLM1VjWAIA5ViiHtmCPkObGmJiiF1XVDf3oJJqgb1ITn5ElpSPkIEfB//RouIBWr+xSri1tsi89owOhE9Ie+cqmyM7HFgVpp5em+qJNostrRiAxlczdDBnRrVQpWa5GPF+t5iY9Xu8kX0UekFFK++GWQTWHAB0UlPkgZVTOwNiQ64Ikb3y3MNiw7uYkDbAJtcmgpFGjbgVqViLexU6h50jtHFWNOJFIgP/LwvPcZQBolN1KYE64LbrKhh+D5nHIO02a5mpGxV2cjLwDYU6QwFQXlUiafHiXp/XC5onu4VZO7OtEnzV7REBwvnd98L0y4S0LLYSsQ+zBNUKh5fV+iUxyVWEiXH22ronzuVKpYNmNKVDGCriamDi0p7xAxgNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change came from the discussion in [1]. It consists of two patches:

The first patch merges register_one_node() and register_node(), leaving a
single register_node() function.

The second patch merges unregister_one_node() and unregister_node(), leaving
a single unregister_node() function.

There is no functional change in these patches.

[1] https://lore.kernel.org/all/5512b1b6-31f8-4322-8a5f-add8d1e9b22f@redhat.com/

Donet Tom (2):
  drivers/base/node: merge register_one_node() and register_node() to a
    single function.
  drivers/base/node: merge unregister_one_node() and unregister_node()
    to a single function.

 arch/powerpc/platforms/pseries/pci_dlpar.c |  2 +-
 arch/x86/mm/numa.c                         |  4 +-
 drivers/base/node.c                        | 89 +++++++++-------------
 include/linux/node.h                       | 10 +--
 mm/memory_hotplug.c                        |  8 +-
 mm/mm_init.c                               |  2 +-
 6 files changed, 49 insertions(+), 66 deletions(-)

-- 
2.51.0


