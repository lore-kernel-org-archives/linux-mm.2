Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2442CCF9F0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4928E0193; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC648013F; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85C08E0193; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 901BF8E0193
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:02:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62B8149333
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:02:16 +0000 (UTC)
X-FDA: 84047536272.21.CDE1B3C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4F1018001D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:02:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ZkAz/WyP";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761656534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zwaRUNSyGimNNs5q83h32soN7BNO+JqHU2+rsr4bU0=;
	b=CXvhvRyzOZSCy1tNFUpFXzsH+RDEpaCv/zjZvIBWUB8zdRrocgNN+cIdPMvvw8KAoCjAjP
	xTpxgr1RRu+xrMSaXMpIX+iNYwb4JytKcwEcXNm9or2eI4MgCxz2bW3tgKDKy3tEUpRLkO
	2XIy6hh0DO04niODIaxhxwKEMYufbtI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761656534; a=rsa-sha256;
	cv=none;
	b=F08QeV62jBmOBhRNgzZ0X8DyX833FeWf6Dm98mitPICHzi8w8OQ5oFpAZikCfyXG/4XLZv
	33xpcmwJiWZA/ljNu3CpoeW7XUPBrjh6lXOdl3PFUK5GRFUY0UuqC0kCefSbvnYs4U3jjI
	Nv0ICJvxonH4knv8JJJOSnQplh4kL0k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ZkAz/WyP";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59S1XMAL006945;
	Tue, 28 Oct 2025 13:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8zwaRUNSyGimNNs5q
	83h32soN7BNO+JqHU2+rsr4bU0=; b=ZkAz/WyPyVMHNioPXbmgvZxofsv7Dcr7X
	RlpDAtRariZrotrUaanDh6HjATMKK0cRWrVMIggfuKLpCY9Ggm9o6/FYsKTtkXQj
	fG36sWGQFPE/OugQt2bcpNrpq9njK0EZccanE/GOWu8mL0oSdZkHYIgnVTeSE67c
	4P91UwfAeQJ9nj4r1xI3/6Rrjfztnb4cphxUTgI77EpKpJbVPHCSgnltl/9ExOLI
	RqXPLV4OMzLqEjo7Rb7pLt9UTi8+Fa9RD79GkoRuDziuOgcgd8j7JUwdAqXg1Krv
	IZxzze4ay43bwJYmgntiX37su/j2D9RxxbofLUj1DEZ32pA21d09g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0kytbya0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:02:00 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59SD1xIg026569;
	Tue, 28 Oct 2025 13:01:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0kytby9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SC3nZL030454;
	Tue, 28 Oct 2025 13:01:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a1acjtqms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 13:01:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SD1qeR41091434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 13:01:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8933820043;
	Tue, 28 Oct 2025 13:01:52 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9BAC2004B;
	Tue, 28 Oct 2025 13:01:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Oct 2025 13:01:51 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: akpm@linux-foundation.org
Cc: balbirs@nvidia.com, borntraeger@de.ibm.com, david@redhat.com,
        Liam.Howlett@oracle.com, airlied@gmail.com, apopple@nvidia.com,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
        dakr@kernel.org, dev.jain@arm.com, dri-devel@lists.freedesktop.org,
        francois.dugast@intel.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: [PATCH v1 1/1] KVM: s390: Fix missing present bit for gmap puds
Date: Tue, 28 Oct 2025 14:01:50 +0100
Message-ID: <20251028130150.57379-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028130150.57379-1-imbrenda@linux.ibm.com>
References: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
 <20251028130150.57379-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mgW0Se2eCcEagXlixqJWxYsPb3M4yIqu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAwMSBTYWx0ZWRfX4ZPTxHz/nLjF
 xkLcDvlI0MfdXrWHGjpk2MYUj2e8AaTxwoDyM1Ws6z/WBWDhYLgkvh9kctwGm0SDzI32XpEAiYS
 RQ1fmrQK5Y2aL5tkqPQ7tEvO+pEczIbhyBdfaV3gIJZZkX4+8Ffk9doHY3sWRSO5MOR9maXFMU0
 T9xnvsQ6c9m3/Ms/xlhZ0vrTptEPB7T8yLvX2x/xM2CbUsCBHjc+pKjXkeP42FdVB9Jqt6H3uta
 6pt/EN4f+k7djdTI2PI6eXURgjLw+RBVUIqwvJB+qrrl8j72/zWp7+hzGrIZvG2IxCLWp422HvL
 QMRzdYDo9Xz55+bqz1e9SlLuy4ToJ+49gefMqwNQP8QMhS34YL+EU0H/0uMxomQ9DS3cJ/2Dhne
 T7DFNb7p0KLKf5uHvKVu/3TVN0Et5g==
X-Proofpoint-GUID: jMVslQxQ5HRWocHTW0PkeXw2KfmAEMfx
X-Authority-Analysis: v=2.4 cv=FaE6BZ+6 c=1 sm=1 tr=0 ts=6900bec8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7fxA7ORCVWHQiGjyanUA:9 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250001
X-Rspamd-Server: rspam01
X-Stat-Signature: 4tbrwhi73ykpk84jhqauprdaz467qge7
X-Rspam-User: 
X-Rspamd-Queue-Id: C4F1018001D
X-HE-Tag: 1761656533-243510
X-HE-Meta: U2FsdGVkX19Fr9Qxj3P8aXpsyMlk5M/9tl/mZUjTApXndSaZWFxVULj15QM+cCV7p66zI/XfmowsU11B+tE3BPazlUBdYSFH8wWrU+sj+ZJ2LNWkzoy86bpwUT+krbyWSYdB5qb/f+1APkmOpM+NSiLoi1OCblG6XC40nlsefJdCVaB264wSy+VeVjsxzLibxCw4sCeohEbR5hyE9IR9tJKHWtv38rnv/SHq6zgvBOucEtxQM5PrAxDolq8A/8zJeeDDIW0qhanBQyusnO8nFkq50tFDqdpuY4pb/QxVVS+e5Ph1c1FllJfOgZgRa6SYQ3HcxgED+1VnA36jwcMRpOYq0/RshExqUtOmNRNdXUEGhrchCaG2EfgxyfeagY+L+7MQLpaoawXF/D/dw6csaRB6j7iJQcPRoYrGbCdL3kMDkbh1gnNA6nYkG8JXwWebdaZtdhLabsZElQIjcc2Imuq5v75cGjhDTkM7QN04w17YHowsuSExdtYuDFVJSGj/72bOLl0tgzKTFTRGU+AcRf1x+J8bxfd48UBzblhjIUaknKj/uOwFkIjo8Zh5teeIVTslGRB3R7XKPKgFzGAK9N3T8MZTDdv0eEtVxtX4CpuJmzwYWYVqvjr63JyRu9GGL3vgm4SqmGMw9KHAvW/G5Oue5T9TVfpieJzhysF+fUwqOgqRyT7A5zieVMQl1ND/wZJV5qqRl3UHnvt3lJ59btp1VviWJKmwbC0HpyNZlp9hrLti3rCmiXXtdtzBbulkbzJUp9l3F+cTwuyrFVt0rRr3quxxV4p0Obz2wY1y6QmUu9ffWpY8a3Kojt9P7uB0bZhRdchbOAqho2PniLzDM00UELaAnibLWDPiKaiykl7pEWUwDp5n26adLgTKhQ5zywaYzE0YrFL/xbXKNCVs4ItK6KT3ZVKTMU1BtXPzlMGwnKoH+2nkVOEKU3SydmzHjjAaZdig0Muy3G2epvl
 X79KQMvt
 OSmsOHJ3D09zzseHkAnQ7wpdshBNDh1YnQvBO9Mn6SAzYtHCPhYg7reA6cgX2aypyCdkaEuq1rfDDNIvELlgfTdpdsJMw0Z3BaOmqIQsK1lsvXtdXKYZin7vrfbxJDw/32ka9Pfa84NhDs6Y5xiOsnJyjuH0zmJDoEDOrWv9LRJ/xWmQbxFyF0kbv0kWty3n9ZhyeUyjrFZ/Knc333JzDlwzS7Z30DWF1mGBmDRpvZifD8kg4OMjWNJQ6ojxYbYuW2IYUTGjUPnGXcZejXG5JexxJy1JRk8PUL3o3aOcoRxoqhmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For hugetlbs, gmap puds have the present bit set. For normal puds
(which point to ptes), the bit is not set. This is in contrast to the
normal userspace puds, which always have the bit set for present pmds.

This causes issues when ___pte_offset_map() is modified to only check
for the present bit.

The solution to the problem is simply to always set the present bit for
present gmap pmds.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/lkml/20251017144924.10034-1-borntraeger@linux.ibm.com/
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/mm/gmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 8ff6bba107e8..22c448b32340 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -599,8 +599,9 @@ int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr)
 					| _SEGMENT_ENTRY_GMAP_UC
 					| _SEGMENT_ENTRY;
 			} else
-				*table = pmd_val(*pmd) &
-					_SEGMENT_ENTRY_HARDWARE_BITS;
+				*table = (pmd_val(*pmd) &
+					_SEGMENT_ENTRY_HARDWARE_BITS)
+					| _SEGMENT_ENTRY;
 		}
 	} else if (*table & _SEGMENT_ENTRY_PROTECT &&
 		   !(pmd_val(*pmd) & _SEGMENT_ENTRY_PROTECT)) {
-- 
2.51.0


