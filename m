Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE2CC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C836B009C; Tue,  5 Aug 2025 08:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD7E6B009D; Tue,  5 Aug 2025 08:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E2A6B009E; Tue,  5 Aug 2025 08:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2D706B009C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:02:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3216114E34
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:02:39 +0000 (UTC)
X-FDA: 83742566838.29.CA3FA8E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40E5640018
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:02:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V4JO1yix;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754395357; a=rsa-sha256;
	cv=none;
	b=PvvQlWgMHXpguP3OFJfjKh7InQO81yRpSZ5DeX4wK8hJXViBgcaLQlSZtoBCfY0OObhRNH
	pHwxSEj0fOs0j8XLyv5YCRH6TE/9vRtibPe0OsajTQU/x1gcjk0l0KbIoBzQKQljQoiSTt
	X8J2pbyO0mS4UrCFpg8MVxU0fShMLsM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V4JO1yix;
	spf=pass (imf07.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754395357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gq1hragezVRPpyFaG97IjZ+pamyoAqvxruf8TzYNDw=;
	b=MSWx5sLOZIcgzvOzmtILwEIqVMnQJca9ZFGRA7JWC7v8N/1QRN3X/gaisLpMvGnZMxAUFK
	RSbONLkmcg4DnN0otUot+3OmAyedPdCDtL35Hj29xFJEDeitkMyznBA+R13pLtg6geCgnn
	hxvPAfEm2FRuS+tul4WLTq2yXC7hYyc=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5754ugMO001974;
	Tue, 5 Aug 2025 12:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=4Gq1hragezVRPpyFaG97IjZ+pamyoA
	qvxruf8TzYNDw=; b=V4JO1yixO1ntQxKmzarPKt0NrIhbVckf2vo2mpgig3+73x
	X5/caCi7HMUjhM0kkBShepLXJc1PevjbYupDy1o0YqMTgcpbQZ+dZ1DWfKmCPS54
	JWYguNDpXtDqOFHOw0TA0ENUVfH6cs1xrrRR+veESreXCvmheYGw1Y67FM2P3lS2
	OtswnWxrpi9oB+/3ps1vs+9EXCqpY7u2sxRfW1VYRZmJ7AbmBbEZ4Mh36mlQkxBX
	Jl+k+elMNd45ZEhKV1Nkhh65iR92XcGxSRUZgaoUy+lh7fVa600ru8KbKaFauWTE
	htTdRDRPzSlinujjue3aDsn11ZmivoNnPN0w0Ajw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bbbq1rac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 12:02:35 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 575BpMtX014043;
	Tue, 5 Aug 2025 12:02:35 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48bbbq1ra8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 12:02:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5757vA7a001893;
	Tue, 5 Aug 2025 12:02:34 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 489wd02cde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Aug 2025 12:02:34 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 575C2UMF52429262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Aug 2025 12:02:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FA452004B;
	Tue,  5 Aug 2025 12:02:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D23420040;
	Tue,  5 Aug 2025 12:02:30 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  5 Aug 2025 12:02:30 +0000 (GMT)
Date: Tue, 5 Aug 2025 14:02:28 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marc Hartmayer <mhartmay@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        linux-mm <linux-mm@kvack.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: Re: page type is 0, migratetype passed is 2 (nr=256)
Message-ID: <0f120fc0-860f-46ac-b9be-762f8bd42284-agordeev@linux.ibm.com>
References: <87wmalyktd.fsf@linux.ibm.com>
 <1fc8eb08-7e34-4b16-a08f-c81a531ec3fb@lucifer.local>
 <A82049B8-B1B5-4234-BCFA-55779F76EDBB@nvidia.com>
 <20250512171429.GB615800@cmpxchg.org>
 <87zff7r369.fsf@linux.ibm.com>
 <078e6415-d779-4658-aa6b-1fba5fadc0b4@agordeev.local>
 <CA+mpNMkvSBs6juBUOFEGLL-9SWbhsUBGAFAY2anrHaQ4OEfYmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+mpNMkvSBs6juBUOFEGLL-9SWbhsUBGAFAY2anrHaQ4OEfYmg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: El4sce7GAzX0H0ryWJfMu14Yw56xOaBw
X-Authority-Analysis: v=2.4 cv=M65NKzws c=1 sm=1 tr=0 ts=6891f2db cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=itihl33mmSw6o8Duwr4A:9
 a=CjuIK1q_8ugA:10 a=Qzt0FRFQUfIA:10
X-Proofpoint-ORIG-GUID: lPT6r1O5ZmnZ5-t7rOfSZRPYkZD4KfN8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA4NiBTYWx0ZWRfXzdf+BfaILxT8
 VqWHWPhMnSxFkMBCjzxwtbIletltxUTwyhExEjg53hxL02+ntt6xhpGCsCeh6GVDfKhJahalkhp
 vAL8FZG4Y24gogmY2i9+v9sm9GEh0cBqI3Er9wb4hoLZRx2E63AclhEK/A9jGHsHHtB6ub4BU3u
 nVdp9WN6Y1ny1HebGnEybcO4MkwHFQt4yFMJNAgAMPWN6Gnbw0+K2ukeeQlya84L3P2v8X7kJVT
 75DeHfR5uWk6A/bgrOhreq86cuVWvBL4pDL8A1GSCzxTHlYFL+sjwiIAnpYvhfxYLDSefcavuWU
 UtSuhZwRbBnzm2Zh5y2yR1NrrTV/uohbp5PmhziZwbB9cdVDR3DwEzWGHFu65asZ+HseLn+8dwC
 bTpngMj+HlGfOYxjHf34DQ/Z8ICq0oGsC+h0sNt81eKgMh8zOqdzvxFURGOY+RmltaERVyUU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=497 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2508050086
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40E5640018
X-Stat-Signature: tqnrpwpbdbdxz3tkyhar5wz73hf1tfwt
X-HE-Tag: 1754395357-243088
X-HE-Meta: U2FsdGVkX1/07sOzo+XRDzawNxiMFOXftrag0ke16f7bJvxej/pnDNBBcXGlmNVEotxzextyr+dwwx0ln/80HqhdF6RafdUs5odYLLGhahAIyfWw1fvgPL2+7GMqXPkKGmUVW7FaoV8UBg+OD/1hADwMPTIKCt0qll3J76kmzMWQlkJe02xFY4WvS55IC3KFo++s6MKdFQPev+T6Gao+qka0VUsDCI98q2LKavH1PLV83/IYITs/cNhZZ5C/+25/Ry3rAQAvmc03/RhS2iq0MYG+cVZX/vB2mgu1c3XzqbeaoRcVhbk/x6xWXEtQfvRRU7+Ej1H6dyQ2S89o0KqzijJ1LudKRIFLxP22Vigw7SC+itwgUyqtdxFfqgUrxf+S0UWhUedee59wO+2P9x7fFJGSds9VxX7Cn67w5qPEIDBMExVhi4qMipHS70K80nFvA3ZI2yGVfxf9FUn8QsGoYjrSkBdCrvH57hGcuSQmbFaDiIs5CEj427QEvz9sQibVSSESiav9LuRkWJKWrUKXffNFypoduS6CVXP85JPgp0ZbSbvLELyiq8TaCbUVGJ8PbCqukh7towsJOBhxNHa0r2jOXugKW10enDZnbme4I9JyRJ7pmgMT5jT3s03KJy/20wlYzBf7p/t3xMa3Dvi7PaaW7cwgv23Nt2JCmRj2meVVH8usFh8I72UyEn53BxiemYFznrMoLgIYBd+9nC/5n32CkM17AbsxeL4K0VTmwXhx/9kgObf1r2mOHfCL7S1lorAiA9Ziji1W5dEVLgSEmurpVOvrUGr6E9tU1CB30oQWBNcPJbfy4u+szrg9Aiq+s+rVToKNoPutfbPLD8ewQcXuNZ3Cmyk5gbKigXqWWoPil3m6lKn2DVhwmCaxVEhloqsuLZqyHLYAvb1WE6MMkxMM8A4VlPfZSWKTXsjWTLbrTPBlwyR84t3xSH7ouNGOCF5ybtUUmPc6Z5eeEXO
 o08oIt2O
 ViquwTxrEdusF8VI4JFIoWfMIZ1/kK2MPHoEsSP1hGyDCXQxf+eNv5A5nFO6ehhAcF2EBzdHWllrHMj1M/jLmljtO1v98EfQ2AdZ+oS8LixBeBel7Lc4DoS88PvdfEv/6yxe0NYU8QIEUzV+lPmD2f2nryws+4ZaW635KHjKXqARbT3YSRO0x0cmmG7aWUjnKoKWV+15pErWSUnEfHCtJp1wvmibwQXwX0qXYW7ECudMfwKv6VaMdVVi9Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 14, 2025 at 10:24:32AM +0200, Johannes Weiner wrote:

Hi Johannes,

> Hello Alexander,
> 
> Apologies for the lack of updates. I am out myself until the 23rd. I'll dig
> into it when I get back if nobody beats me to it.

Is there any update here?

> Thanks,
> Johannes

Thanks!


