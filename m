Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B53ECA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701B16B0208; Tue, 26 Aug 2025 08:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2656B020A; Tue, 26 Aug 2025 08:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A27F6B020B; Tue, 26 Aug 2025 08:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8396B0208
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:49:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F19E81392B3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:49:36 +0000 (UTC)
X-FDA: 83818889952.22.DA07F51
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC2ECC0014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:49:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=s+TvbI2s;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212574; a=rsa-sha256;
	cv=none;
	b=2UQQXpgdl1JpkNyNTbHzqtdxEybu7eOq89O3swgB1F+nLYI0eTDltZrou175kOEDzdWRIM
	JYsIoMIiZOFcDQSP/zS2Y0azjWGzjidOlUBv/dSQh0VWn68rQztXsuGIXrZtQuEFo8l5Wf
	MMMjCBV8gfP2ALNTjlXOgydzS0kT64w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=s+TvbI2s;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DAGGijW6cNEN/XBrOA32YvUP9CyWMG6BMXPWcFXNn2I=;
	b=Nn6+hwF9Lq94wvvEemuPNYLTK+renUbnSSjv4uyk6nysU0/UxCLmbLOi82V3sgLGTWD4ET
	mzkgyDKt3xA8xdIb1mBV0iGNFigsyGA2CJOeXlnr48VJ6pySdoRJKNz0ESzja7NyPidw3c
	dIqk2kCS9lmxvyspiuEn7hCyfajqbgI=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8ksQW008022;
	Tue, 26 Aug 2025 12:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=DAGGijW6cNEN/XBrOA32YvUP9CyWMG6BMXPWcFXNn
	2I=; b=s+TvbI2sAU9sNskdBsITQy/SnQsX2PDdG/v+wg+7zC/ckqvadWvTTY65Z
	+YgTcK3EriSOM/psnUfBUs07SRzjhbUJeIry8nQzB2N2qDf87bwcwa7Eka4iGMiL
	usqiBpmKHqkKltaG8rXHm5YmAt5vqh1fzkkotOhIPCYCmaCFlx2YFzy9UxhQwM16
	Xm0qfL+mmKxRD7VHcmJ0MLFCVktTKHhT5I6pxBew/T8vrpve8AtbQCzlCfItZNH7
	KRF+I1Eo4N3rETA0mvnMGS2mM5gkSdv6ucc2xON9LfHmCDtdgpfWGWGGQ/DuOCPw
	vkJx4VDn/kX3X77UbIpZc1a/vUnCA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q42hxj2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 12:49:33 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57QCkfdv032135;
	Tue, 26 Aug 2025 12:49:33 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q42hxj2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 12:49:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8pp0a002524;
	Tue, 26 Aug 2025 12:49:32 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qt6magwr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 12:49:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57QCnSO453805510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 12:49:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FCFB20043;
	Tue, 26 Aug 2025 12:49:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFAB120040;
	Tue, 26 Aug 2025 12:49:25 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Aug 2025 12:49:25 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH 1/2] mm/ksm: Reset KSM counters in mm_struct during fork
Date: Tue, 26 Aug 2025 18:19:21 +0530
Message-ID: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMCBTYWx0ZWRfXydYkEKYVYR12
 9GYbng7zDTwaFmkIyJ+1SHjYxLupFkAQYTBOEytf0HF6SthYXCjLx1K7UOCkvFV+DQoaY4OgRdU
 EuADlD7T5u+W2Ng4cjr5/9qeLp23k/obauCT2cqGeAtSEhrdXGWmd5Y12LXPlhNUgC8M123f5Rw
 J/kdDw3n13wzPJnEG3gedGUe6JnAVVPyEus94r6R8tIgC2na9VGv3HS4Z3pzgjAWAJ/INvKyMZr
 /H7J1NmTn1uZXdM5HqYKA1IWIhZdZk+M2KjdhUf8lS3sKHiGwYdEAwJtZoFkkTQTdSCqfCutp4C
 ctEV9OIs5W6bUX/7o0t1eg9iPOmXB+gsjP9aSOdKbJ7T+ZZw+FkCHYXs5uYgjtCtWPmZzxR33m9
 vYPo1Qrn
X-Proofpoint-ORIG-GUID: X1kt7dpWXr41pu_7Z6YhmU7QhZ9kIS_o
X-Proofpoint-GUID: Dz170ztLRn2G-QQbmUmmLpUe42C34bRS
X-Authority-Analysis: v=2.4 cv=evffzppX c=1 sm=1 tr=0 ts=68adad5d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=bffXwCTgIVeg__Yz0z8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0
 impostorscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230010
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: BC2ECC0014
X-Stat-Signature: 73hbyxgqeu1eugewhkyrwyjrqydizodf
X-HE-Tag: 1756212574-301936
X-HE-Meta: U2FsdGVkX18jQGyVQliPL0iobU8K+IhC0Yx8fdUVMhMsBuo3V5CyBKVfK4FjYSRsyF77+jZRUO/ATnK0ohZm9xnWvBWuGA28xU8l99jcBmrS8a37TOmRmezdA2aJYoSkzCqjNz0+sqOs/DvAPFIhPxAT8l/ZuzuO8hUENU0sSjqnwMSZy8YVQoeo83zM78j+lobix3cI8aRk2PVctDTtC+CFMmFqixTBOZHe8B6BYs8vD+SpaQ50sHTQITlyLnOYCi0Y2PGrn7FT8l6K2UjI5V6ZXeevjDyAqtbVTazYtdsHBqzfyQovYdCOuawmeiVfqgP0Fzykxx6uxjDxagSfHmHHxflNiOQwUs4xTSVDSnzr404Z+GYjbnFOj4pwzTr/kb+ZURaxF4Oz7vKzf8oh0p9Gp8R/MHOrm2IfS8SIfsmAetHOtLb7o1C2Q/KBkWVhOLve6WEh6WufUiN2YhXGBvxNoJAQ2DvKAiNM0Ww2qE8HQa/o53C/8ffyT3wosS+PtaD2S2aHqVS7+G6LhzhlxTgTVh86VmFxepBrwf+zRRRDZBmxLGf3q1zecG+/afbSXD79KBXuyZxgTeHgNt06c92/wUUv615WyK9KYLPIbkd+ZZai8cTZyqS5nZ1L3khqjEvAKyAESOjY7N/YPZ5yblo2izCDHXTDo6dXm8pAW6ScB1Yx+4++FsHsLNnoToQWslty/i8/sYapkaEnEA7qMUOmcb7J66pg9howpcyr5kCyL6DjDub3JkCLhnU+cNkhhKHHuQpYoYAHm7+2YmdGbwXBYLMaU91kzggBLWEMK77DUZ4sxXhcujR73GBZaTzry9xRcDuwX5zB7TISIGzWB8jCzJpl5xvclI3249ELybXyxrY+14SYtkgPS+7J2pV1LXrvCUaVOzP1MF1x8PCEa9+rsYmpJExwEF5Pi+6ynYL6EGwheDsyxOkDPO3AbF78nny4kx9uhGm2UrKTt1h
 6vCYTrwL
 eIcqP+D4HlLTOHJETswhjXpIQRbh1Tcku55VDkGfVMMfZOyt6owF3yNU+cusgispz+Y6aYdKO5ADAT2QFVaBRxopsyONgL+yeSwg4TcAJwv0r21XFhri+sv9COaq4wmiSFfXl/wJwNC0Gs3T53PajhCN6vaNxSTiZ7QE3U+1T6tzWMdk/eaJ5L35IlTjDsZzzLFcZNgdVgU0urZgYIDwarmHryWwQ8NeOObDZbcYCLNy0rjtBImKqFxEAOOBq9oyn6i05Zslb/VNb8lBdFEFhYvSlpjj8k2Mikj9915Kz79fcgYqoO/2jILWD7Ihk7+7IQjRerxO515o4541wDjMtJVjye1K6RXgRVSe9XE25EcABkJO04qWvXMuOspkUTM5xlpi8qqyJtNH2PCbmVESAiiBMmH0SUNKZkbN+BvTOAhQbDPt8YTwH9FBRlvsQFmp/9qjE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the KSM-related counters in `mm_struct` such as
`ksm_merging_pages`, `ksm_rmap_items`, and `ksm_zero_pages` are
inherited by the child process during fork. This results in
incorrect accounting, since the child has not performed any
KSM page merging.

To fix this, reset these counters to 0 in the newly created
`mm_struct` during fork. This ensures that KSM statistics
remain accurate and only reflect the activity of each process.

Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 include/linux/ksm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 22e67ca7cba3..61b8892c632b 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -56,8 +56,12 @@ static inline long mm_ksm_zero_pages(struct mm_struct *mm)
 static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	/* Adding mm to ksm is best effort on fork. */
-	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm))
+	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
+		mm->ksm_merging_pages = 0;
+		mm->ksm_rmap_items = 0;
+		atomic_long_set(&mm->ksm_zero_pages, 0);
 		__ksm_enter(mm);
+	}
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
-- 
2.51.0


