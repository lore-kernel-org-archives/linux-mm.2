Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68EB1C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606626B00A1; Fri, 18 Sep 2026 03:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B67F6B00A2; Fri, 18 Sep 2026 03:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5DC6B00A3; Fri, 18 Sep 2026 03:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1805D6B00A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:08:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CC53A05DA
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:08:39 +0000 (UTC)
X-FDA: 85226005158.17.CAADD57
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 00CEC180002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:08:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V4wInamu;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QyiWJeyX40zhG+NrXO8KY9exffT+1DYFLbG5dwgeEfY=;
	b=1/xHF2z+mBU2sXu1/zafy745vC83R/d+hFhay1duDCy8xdc42ed8uS8GaqdIpFqxE8xsPa
	OVXbQlrOORTieSBfArgSQDWBzKqU03IndDi9jPmxeGRwBxmlCbYutpnskQl+CBJNtaCLnR
	Q0GG5wpeme4yhieuSFdSO+59LJ8l3g4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715317;
	b=cx9vIkT7csXfVd9SBneb/0O9RiTokwjichCsbW9VZxXW0ATy8libpfsrWrwv94Ttvpxcxh
	X1/jxhQJrVZSNCiM8XOmJ3ryELNacmpiqppnuQ4GOqfb23YNlZVEZP+kYdx0rccCYw7xiu
	6x2LR1JXRS7SwoFOBjs37d+cFLWajCU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V4wInamu;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf24.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I61faI498317;
	Fri, 18 Sep 2026 07:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=QyiWJeyX40zhG+NrXO8KY9exffT+
	1DYFLbG5dwgeEfY=; b=V4wInamuVbWxLjj1/9ej0tPQ54QG4p/aIq3QzvL+jiEG
	6soogRNuvCTwXEiv2bFwz07NtZaoWRTTHvttLJl32m5QkZDITxdTWYGY5v1/XHiI
	stWNMRYJei8u/9wLhLe53bMz/l7p2WvvlfkmYblrkUU1dmmfw26zP234Zj8fchKI
	5FcMJj9GjoZxVA8l/ZVIGom/U5+6jQ8LtzPR1kDrQ1HnvNPCZxIC/wwu/QaWooqK
	+kV/R5CIckK+hJTrncsSPKdgde8CxedRA7nM9VpMQynb8iWlnhnOrRHC0mM8UE/g
	c2DDrS7nW/pAIswpr23KNYAaYb0jmxYULEJRJcAEgw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcve40b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 07:08:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68I65GE2196413;
	Fri, 18 Sep 2026 07:08:35 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gr5fjp7py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 07:08:35 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68I78Yln20644464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Sep 2026 07:08:34 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B02958050;
	Fri, 18 Sep 2026 07:08:34 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5826358045;
	Fri, 18 Sep 2026 07:08:31 +0000 (GMT)
Received: from [9.61.249.200] (unknown [9.61.249.200])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 18 Sep 2026 07:08:30 +0000 (GMT)
Message-ID: <d0d04df2-8d69-4155-81b1-3d3ea2fca14e@linux.ibm.com>
Date: Fri, 18 Sep 2026 12:38:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, Liam.Howlett@oracle.com
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [linux-next20260917] BUG: Bad page map in process
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDA5NCBTYWx0ZWRfX895lyo2zTBkb
 ZaHql1XFDSCP7aJ1wGMiwXN6FFYtI6WQkxjy9/dXUsgvTb9M3DT7RYMg+17jBbD2WTzYXMt10qt
 QsBknrUjK74eJv6SGMlF/3arRRSuXHE=
X-Proofpoint-ORIG-GUID: nhZ8uAaRH0OylhbcL-v07Wa6WWEnFuJ4
X-Proofpoint-GUID: nhZ8uAaRH0OylhbcL-v07Wa6WWEnFuJ4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDA5NCBTYWx0ZWRfX5Y1Eo3CxUn17
 qO1khtNF+7VasT4TAK5OnEFOltfENb2uGAvVprbjadqoZs8WWrc/ofbURwo4p47bkTlpyIRIxO9
 3qyBS+tt+HetmfCtNMChTHoSsIXgYi539HBxWpJWRrU0f7pN/cOy62DHX0dGtGz/dpN4aWtVGtX
 nRIaTd3eYlupR5zaTfMDENA0uQxSGAuMgQKS0q1m/R9zk1cad+lr779E1n9ug6Qmjgh7dhNiFJ/
 k7SV/thkJ7cXssbAPC5wdWhDvhtch2PO0jtoRgtk0NJRmIqUx9vkuUaowc7EK/Q1NYn3eJeKl+u
 c+v7uaQeKLrAmjHMR6stYONS9ViTjJqaGpF2CCIlEJhTfZ9nMBPo08u3SogLbfLsfrGKKehXABa
 LUVoNRuG0cqjy01hyCVr4GcYOxNRLxe1s1XRq1P6meF8KZ0AwOFXtI+jwVsKbE0hr7c9Tdalp5P
 FzdU8CYRPXfsEQchcaQ==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aace373 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=HixBNUViIQCYW3mda3AA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_02,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1011 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609180094
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 00CEC180002
X-Stat-Signature: ohhu5it1gip7znug4bc7hbkq4ahaemns
X-HE-Tag: 1789715316-203117
X-HE-Meta: U2FsdGVkX18R3P1/WSay8olC+YJHQ8KOnhNWD3fFOg/EzgBNJq07yQ9u1LDioy5Oo7wt9ZcDrNw4j3PK6px7JpSXnm+Jj4BIUcRkIen0BzTUBHgazwJIKBt2bX2S48ZXNluoH890i7s0lUOIL4sIQroFJpKDCnGtyTz48lbLuLm4sQu6QcW4LCII45kWyzC/bDR7DJ9mQ4kQOEMpThQkTjkmu5DQByL3wn+X/GYJ2PnuHQCe6+pueSevjZvmix5UVKPNpOFoTpmBxMZqRLquuKj+m7Tng251ig7TtB3fM/kRbW6mzD6Wp+mfj4WPQn2W5+wCa6EBU3gItcKPc9ok6MYSRYOfUDPFFr/OoE1KPXyY9NsOwi2CX2uRyC9CfF8B2OrupnHk+JervE9p1zxAr0u+b9LegOQ1K2AMIsdcXdyvQkx/bcHvJkKQ+nNpRIeR/5kUvHLn299bwjQmP3WXbecLVUH0juOzvCtNRWEvtFpAmTcJK7ODoJGpQQ4x82oNJhftus5rs7J1NQRjwZjiTaT4m+99KEPSf3gYaNp0MoJCEMIqZDEqLk6pAi51zUXGnvNksy8JaXKo/MdMip0rwUwu3SHtJsibS9IftlBcYFT5rPrWRErfKzT1lDSekV89FW+kPEoCEgDZ+M3C5nkOf+uFpNndMG3fH+KZTjPdVis2qxdQp/9yaF2EdLQ/gFlZx8K5rURRjWIPuc4GfqiHle8Q7+iwd93viwqBhcnh7dgUBaL/m/TynmoIWODZOWrIn9fJ5zlYpvKW4YkOh1ewgFFtqMDsC+gRRJOEFciu2k/WOl/0zAppOoyvE2e3/mbqXLXu82QA4RyBypUNpo7mm3qaZlysmCb4OprHCbZKjcNzQelN8Notv0t1KRAKaB28odH0zNWEG+mLjp9GMw9ilnDcw182oxq38X6WzBONOl+nW1YZ3wod0q9jWvs/OgzoUOh27gIJpRJDSGoxqCp
 ll5mGjzF
 17n/UnJxOM3R4EXRT9cqC+CvuGOEWljjJJ9u2F5MomZMnSG7SeUK/4dBs1qB8JFBRJDZw8rdEpY4qCTX74n/Mtlzx8odRkAmLmHTPtmABjd3kCO2IBPYeAJAYPvprVvrDKkwE3r4UG4Q69oJWMX3B2VuXyE80LXmHdi+aKzXhVD6XszCMxJ+2pfmZx02TAVAULkF2rSy9Y+XR9X12i+SvPaak+fxmY6M8YamuZKf2iB46LXbj7VibBqht9RWtp5/xzEgcDg0RJXDReaZ8PRzXeE/FzNsCs0WPLQ9Dnbne/pYvZPn0jiz4wYcXoNNQRDLUwljzTwW+Xo9+0x1/5nbrRTDRRYM4MdSsrrWUfrBGTsTBfL41J8P37NtFbAlzmSuGfnfiKM3Fn+kU+/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Greetings!!!

IBM CI has reported following boot warning on Power11 pseries machine 
running linux-next 7.3.0-rc3-next-20260917.


Traces:

[    4.944846] BUG: Bad page map in process rtas_errd pte:c00000001fff0786
[    4.944850] pgd:8000000064e76009 p4d:8000000064e76009 
pud:8000000064013009 pmd:8000000064011009
[    4.944858] addr:00003fffa9382000 vm_flags:080000fb 
anon_vma:0000000000000000 mapping:c0000000054443a0 index:1fff0
[    4.944865] file:mem fault:0x0 mmap:0x0 mmap_prepare: 
mmap_mem_prepare read_folio:0x0
[    4.944875] CPU: 17 UID: 0 PID: 773 Comm: rtas_errd Not tainted 
7.3.0-rc3-next-20260917 #1 PREEMPT(lazy)
[    4.944877] Hardware name: IBM,9080-HEX Power11 (architected) 
0x820200 0xf000007 of:IBM,FW1110.01 (NH1110_069) hv:phyp pSeries
[    4.944879] Call Trace:
[    4.944879] [c00000001791b4e0] [c00000000135a92c] 
dump_stack_lvl+0x8c/0xf0 (unreliable)
[    4.944885] [c00000001791b510] [c0000000006708c0] 
print_bad_page_map.part.0.constprop.0+0x18c/0x260
[    4.944887] [c00000001791b5f0] [c000000000674fa4] 
vm_normal_page+0x140/0x17c
[    4.944890] [c00000001791b630] [c00000000067648c] 
zap_present_ptes.constprop.0+0x9c/0x9ac
[    4.944893] [c00000001791b700] [c000000000677038] 
zap_pte_range+0x29c/0x5f4
[    4.944895] [c00000001791b840] [c000000000677500] 
zap_pmd_range.isra.0+0x170/0x310
[    4.944898] [c00000001791b8d0] [c000000000677a00] 
__zap_vma_range+0x360/0x4cc
[    4.944900] [c00000001791b980] [c0000000006780e0] unmap_vmas+0x98/0x1a0
[    4.944903] [c00000001791ba10] [c0000000006b0f68] unmap_region+0x94/0x108
[    4.944905] [c00000001791bad0] [c0000000006b1c7c] 
vms_complete_munmap_vmas+0x11c/0x2c8
[    4.944907] [c00000001791bb60] [c0000000006b273c] 
do_vmi_align_munmap+0x1ac/0x1f8
[    4.944909] [c00000001791bca0] [c0000000006b52c0] __vm_munmap+0xdc/0x1fc
[    4.944911] [c00000001791bd60] [c00000000068b154] sys_munmap+0x28/0x3c
[    4.944913] [c00000001791bd80] [c000000000032150] 
system_call_exception+0x190/0x4b0
[    4.944916] [c00000001791be50] [c00000000000d05c] 
system_call_vectored_common+0x15c/0x2ec
[    4.944919] ---- interrupt: 3000 at 0x3fffa9143754
[    4.944920] NIP:  00003fffa9143754 LR: 00003fffa9143754 CTR: 
0000000000000000
[    4.944922] REGS: c00000001791be80 TRAP: 3000   Not tainted 
(7.3.0-rc3-next-20260917)
[    4.944923] MSR:  800000000280f033 
<SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 44002408  XER: 00000000
[    4.944928] IRQMASK: 0
[    4.944928] GPR00: 000000000000005b 00003fffc0a69a20 00003fffa9237d00 
00003fffa9382000
[    4.944928] GPR04: 0000000000001000 0000000000000002 0000000000000000 
0000000000000001
[    4.944928] GPR08: 000000000000001b 0000000000000000 0000000000000000 
0000000000000000
[    4.944928] GPR12: 0000000000000000 00003fffa937f860 0000000000000000 
00003fffa9383550
[    4.944928] GPR16: 0000000000000000 00003fffc0a69cd8 00003fffc0a69ca0 
68746150706d7544
[    4.944928] GPR20: 00003fffc0a69c10 0068746150706d75 636170614364656c 
747365526f747541
[    4.944928] GPR24: 000000013ad9e130 00003fffc0a6a0d8 6d726f6674616c50 
00003fffa92f5ee0
[    4.944928] GPR28: 00003fffa9382000 000000001fff0000 0000000000000009 
0000000000100000
[    4.944945] NIP [00003fffa9143754] 0x3fffa9143754
[    4.944946] LR [00003fffa9143754] 0x3fffa9143754
[    4.944947] ---- interrupt: 3000


If you happen to fix this, please add below tag.

Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>


Regards,

Venkat.



