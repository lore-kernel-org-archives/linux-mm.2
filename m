Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCBCD1953D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9445C6B0088; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F066B008A; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819FD6B008C; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6A59A6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F398160211
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:32 +0000 (UTC)
X-FDA: 84378070224.08.C16976E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 984834001B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H6ap+SwL;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oxrNqvT1rMVaA9XQeLJXr2NbWh63PM2NKwSN0+VBoM=;
	b=BZY8qkDoWbdSNhFT/BKTUf+WmoPNlB1N/5aRT4FA2511reWiL+PvvZXSeLFAZznBKJdIWA
	RQPW0NnIWnwxadZjoq96H0ECsYim5pQcnDyHjRtPn9ORKst0veYU2IrDXQf6wtlslG3BMW
	xov7+SGUvngPfee9PW1I8V96XfUeOxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526389; a=rsa-sha256;
	cv=none;
	b=g+q9zTidhi5G14Ib2hEmIRL0vJKRqEIdUpqGUVm6bY7uACYTHn0ZdoWwHCe49WrZFRsp+e
	4GzCyk2w82t6F/Jrj1Zg8c2YnY/SK3sEIwJJHPXHlnoH3HEJdhCq5hX3cltLmPoAN8Zrxy
	PbDbBTz+eztOpEZO5nMvx8Ddr00vY6I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H6ap+SwL;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60RElpet031076;
	Tue, 27 Jan 2026 15:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3oxrNqvT1rMVaA9XQ
	eLJXr2NbWh63PM2NKwSN0+VBoM=; b=H6ap+SwLdjS3mmSwFPbfzH2b01uoWZpF6
	tM3fKMMLpQ/sylcarRsUqkOBy5pUSlt1qTsiETC6IX4orVieBgTQdv4NmLs7OjN3
	SPF5oB4ELCmXOYeOOPI5ZHLzrjcUJjIKudV93L5p3AtnUJ0+yoWyTCB/HpCzO2Hx
	hyWDkXYLNi57QUEynV20qQ76LAetlTXKIh03bn6yMVQpVhvGkjIrARCazJMfq+ZX
	BjNz8NwS0sv7LqPhh3iYHWqCNYMDvYhKaDvbvmKx46r6h1D1G2BHkHwAHOGVeFrb
	z9KMdPSpSDbkokoOeR8cIv+hVC/k5UBLaJ5SfohZyZHb1cEY7vn5Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvdex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:08 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF2vOH017959;
	Tue, 27 Jan 2026 15:06:07 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvdet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:07 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60REptcY017960;
	Tue, 27 Jan 2026 15:06:06 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwb41ru44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:06 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF636252822376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F115A20040;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 926F92004E;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v13 15/18] unwind_user/sframe: Add support for SFrame V3 flexible FDEs
Date: Tue, 27 Jan 2026 16:05:50 +0100
Message-ID: <20260127150554.2760964-16-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z4vh3XRA c=1 sm=1 tr=0 ts=6978d460 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=2wkDFiw1nnRQRUo0YT0A:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
X-Proofpoint-GUID: 0wGnHg8qCGjbx3-LIzoY5IImluPfJ43-
X-Proofpoint-ORIG-GUID: k8VUmwsesU7Qjy_Zf5UhIY-OXQeeDB1b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX08dPWt8WBYHQ
 Qe6yBycEBxR4QECgsvau9hp6oKPG3n7t0MOt2PU/gX5DvduWwnR6Un/Y7GcAjjqXma1zYE/JKys
 qi+9y/KTJr2CYMbTx0PEz719NvxHk/JDRoxyrLPIkEy+Yxn94H0vlBQBSKIVZFqHtxO3bhLMpb6
 tCf0gkkHyiGWbi9rL/UjsH33aFfeLAAcg0qtZj011HRK42NUPbQYc8giE4wveUe3vv6O/aPeNop
 b38i+anwwyEH+vNdKaOqqr1vM5x3nDKhrR26etLJMhGMKpiKvEpBWdPiKd8ZK1VECPJBBcdvnj7
 9Hqv5vEW2TSunWtlFcWgrhfh5qdLE39g0sxkfVCiSUeROnifeMeUJxZwOIT/1FwyhvPgPrwW+RA
 nJ9BczHL6jwAskMMUJBw1mcTclI4ip3cuAUWFrmaGDqleMKxs45eeMg3jVcMmQOgR1qI52pkg7+
 cKE3ruR2olsKr5Qo9Dw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601270121
X-Rspamd-Queue-Id: 984834001B
X-Stat-Signature: gra89gcdnb8yx46otrsdzojiz83go64c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769526389-431959
X-HE-Meta: U2FsdGVkX18dKs4bWP7RI20lnpvbtx5Dlbih6s0cd3Rww+Y2XgYOZ54agCL78GN+ZPcn1Vvel91hUVNUbx1d93xGN+THWpWeOPnXnOAIc3YpUEI8+Rz7BPJ/ApwMD79p+PgE2xHFZ1FJhesI++VpPJ5i0N1mXtzilU80oJNWYRCFLksJyi84RuMRIY/6V7dFDQbgUa5IMP+bjQqpz0Xt/poS/tTuuMv4fzj6prNQ4yNBWwNVabu/dqnSynv3UmeZWIJphbjBNejoD51ecdcuuEfEZCnz01FALZ3pBUTnM/CjqQt6o1MElXRoKiR5k0Uw3rTJEgh9eVvNCWTlAe8x1AgaNHJ4JQh9xXW6MEIrmgAXvBcmk6to54H3PXhWpbhiuY7h4qkaC5Rt59bpgcrSlZhu1/+vQERN1IphqnRoZTbabVBBXMwUALeRHgNtzD0Re88MbvxzZaLvBTm5C3RXTLFw0crNGinJq0mlZ3gaiSfI6Q2tiJSsut75Oxvae+9XiG7SwlZoI7c14QPWKVPW8RXr58x6S107NnaDeDtThv3jT6NnD48lqHKjCsn4NH4lkx4QNtxoT5R6tbSnLA+SA/ArgypkirxVLHEyWejEUN9CSzczBHHO58NoI1ZH5FJ+VwqG3IA8QyCfozKYlH1G0SPuvdYKfbmASLLGti3jVM3zmJfcDQphe64udU46K35aJujaSMWQHOS5vbl4whRT4nNYyye4uz+PdXZuSWXnAdMceU9w9Gc1b2kkNbKI2xm7xTO6h4IRV7tTn3AvPBxI8IaVquTiVH0x+xKXyK9js31NeIitUBYxtznmLDaLLAkzsd/HRq5pzPe0UbgF00AKqUaS2IvDzcI7oKLEP1PBjo87t19tbg2F7ioGCtayHl1bBql3vX7/M6tC+mm3ek5T91pTYVxaZtzNDCt+pON3OD/zUVSgUVx3JE8R2Bt3dHAM55hg5lczzj+ilqUtGbi
 GoOG7LQj
 VCu9au4n5MlPZWfVhxrAwA/Dzx95wa7/aGlHwZpeCfLkY7YhfvYrm5WUm1a8+mLunzyiezjfLaqzGYk8CYjCnFTTvBgA+Zk9yGwsXdl4NnE6xBNQjMBrEF6hiyvaYOWqitPNaftHrJh+epI8TGM4H9iRTe1EFllNoJPmFQolasA1V758qunZiWSlFc46eNH813ihL8YzTb7KFym862zHk+bUGjZzNFTVlxfUqrBuKmLZRh8hILgJv9klo/ZbERpE/EjIwph/A+8qICrOiCJfo9yK3UzwyHY7V7QxfMivI67vXFsexxT9sBSgksU8Yzv53f214QvEDNmOtV3kJPQQmQ0a5q+E4pzjgiYSaAK6JasxBihjoUBzAwMrSm7U5QCHc8GUIKSzf9wcF7MgyQJGq8bvTyG08/io6nXQrhWucZqy+ZrSub5YgKgpr9rsec6T4zPYPTtenmu8eROWd2wQoS0HoYUEA0h6Eo/NTWNxae/e6vSOz6w65S/EWXH8UPNGtg1Mk2bTS3mvUUELDHvwyDyUwC7n7TR8kXrzrcSZEnxIu6YZnXfWmObYX6UpleFmuhz3pqDsPAjI1tkULJx8nLvnCEocfTFffWFxQl+00FkO+vQg0vWXe2iAU9HOVtWlDhEVgjr3+qCMChpFaT4gvv3/i9zdHbwOCEWmi0naAi3/7YJMI8lHRX0szF7j1t5uCcaXh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SFrame V3 introduces flexible FDEs in addition to the regular FDEs.
The key difference is that flexible FDEs encode the CFA, RA, and FP
tracking information using two FRE data words, a control word and an
offset, or a single padding data word of zero (e.g. to represent FP
without RA tracking information).

The control word contains the following information:
- reg_p: Whether to use the register contents (reg_p=1) specified
  by regnum or the CFA (reg_p=0) as base.
- deref_p: Whether to dereference.
- regnum: A DWARF register number.

The offset is added to the base (i.e. CFA or register contents).  Then
the resulting address may optionally be dereferenced.

This enables the following flexible CFA and FP/RA recovery rules:
- CFA = register + offset	// reg_p=1, deref_p=0
- CFA = *(register + offset)	// reg_p=1, deref_p=1
- FP/RA = *(CFA + offset)	// reg_p=0, deref_p=0
- FP/RA = register + offset	// reg_p=1, deref_p=0
- FP/RA = *(register + offset)	// reg_p=1, deref_p=1

Note that for the CFA a rule with reg_p=0 is invalid, as the value of
the CFA cannot be described using itself as base.  For FP/RA a rule with
reg_p=0 and deref_p=0 and regnum=0 is invalid, as it that is equal to
the padding data word of zero.

Cc: Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>
Cc: "Jose E. Marchesi" <jemarch@gnu.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Jens Remus <jremus@linux.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Sam James <sam@gentoo.org>
Cc: Kees Cook <kees@kernel.org>
Cc: "Carlos O'Donell" <codonell@redhat.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v13:
    - New patch.

 kernel/unwind/sframe.c | 249 ++++++++++++++++++++++++++++++++---------
 kernel/unwind/sframe.h |   5 +
 2 files changed, 204 insertions(+), 50 deletions(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 4dfc8cf2075e..ebf2a2905c5c 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/string_helpers.h>
 #include <linux/sframe.h>
+#include <asm/unwind_user_sframe.h>
 #include <linux/unwind_user_types.h>
 
 #include "sframe.h"
@@ -31,8 +32,11 @@ struct sframe_fde_internal {
 struct sframe_fre_internal {
 	unsigned int	size;
 	u32		ip_off;
+	u32		cfa_ctl;
 	s32		cfa_off;
+	u32		ra_ctl;
 	s32		ra_off;
+	u32		fp_ctl;
 	s32		fp_off;
 	u8		info;
 };
@@ -189,16 +193,147 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 		 s32 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label),	\
 		 s64 :	UNSAFE_GET_USER_SIGNED_INC(to, from, size, label))
 
+static __always_inline int
+__read_regular_fre_datawords(struct sframe_section *sec,
+			     struct sframe_fde_internal *fde,
+			     unsigned long cur,
+			     unsigned char dataword_count,
+			     unsigned char dataword_size,
+			     struct sframe_fre_internal *fre)
+{
+	s32 cfa_off, ra_off, fp_off;
+	unsigned int cfa_regnum;
+
+	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	dataword_count--;
+
+	ra_off = sec->ra_off;
+	if (!ra_off && dataword_count) {
+		dataword_count--;
+		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
+	}
+
+	fp_off = sec->fp_off;
+	if (!fp_off && dataword_count) {
+		dataword_count--;
+		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+	}
+
+	if (dataword_count)
+		return -EFAULT;
+
+	cfa_regnum =
+		(SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP) ?
+			SFRAME_REG_FP : SFRAME_REG_SP;
+
+	fre->cfa_ctl	= (cfa_regnum << 3) | 1; /* regnum, deref_p=0, reg_p=1 */
+	fre->cfa_off	= cfa_off;
+	fre->ra_ctl	= ra_off ? 2 : 0; /* regnum=0, deref_p=(ra_off != 0), reg_p=0 */
+	fre->ra_off	= ra_off;
+	fre->fp_ctl	= fp_off ? 2 : 0; /* regnum=0, deref_p=(fp_off != 0), reg_p=0 */
+	fre->fp_off	= fp_off;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int
+__read_flex_fde_fre_datawords(struct sframe_section *sec,
+			      struct sframe_fde_internal *fde,
+			      unsigned long cur,
+			      unsigned char dataword_count,
+			      unsigned char dataword_size,
+			      struct sframe_fre_internal *fre)
+{
+	u32 cfa_ctl, ra_ctl, fp_ctl;
+	s32 cfa_off, ra_off, fp_off;
+
+	if (dataword_count < 2)
+		return -EFAULT;
+	UNSAFE_GET_USER_INC(cfa_ctl, cur, dataword_size, Efault);
+	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
+	dataword_count -= 2;
+
+	ra_off = sec->ra_off;
+	ra_ctl = ra_off ? 2 : 0; /* regnum=0, deref_p=(ra_off != 0), reg_p=0 */
+	if (dataword_count >= 2) {
+		UNSAFE_GET_USER_INC(ra_ctl, cur, dataword_size, Efault);
+		dataword_count--;
+		if (ra_ctl) {
+			UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
+			dataword_count--;
+		} else {
+			/* Padding RA location info */
+			ra_ctl = ra_off ? 2 : 0; /* re-deduce (see above) */
+		}
+	}
+
+	fp_off = sec->fp_off;
+	fp_ctl = fp_off ? 2 : 0; /* regnum=0, deref_p=(fp_off != 0), reg_p=0 */
+	if (dataword_count >= 2) {
+		UNSAFE_GET_USER_INC(fp_ctl, cur, dataword_size, Efault);
+		dataword_count--;
+		if (fp_ctl) {
+			UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+			dataword_count--;
+		} else {
+			/* Padding FP location info */
+			fp_ctl = fp_off ? 2 : 0; /* re-deduce (see above) */
+		}
+	}
+
+	if (dataword_count)
+		return -EFAULT;
+
+	fre->cfa_ctl	= cfa_ctl;
+	fre->cfa_off	= cfa_off;
+	fre->ra_ctl	= ra_ctl;
+	fre->ra_off	= ra_off;
+	fre->fp_ctl	= fp_ctl;
+	fre->fp_off	= fp_off;
+
+	return 0;
+
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int
+__read_fre_datawords(struct sframe_section *sec,
+		     struct sframe_fde_internal *fde,
+		     unsigned long cur,
+		     unsigned char dataword_count,
+		     unsigned char dataword_size,
+		     struct sframe_fre_internal *fre)
+{
+	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
+
+	switch (fde_type) {
+	case SFRAME_FDE_TYPE_REGULAR:
+		return __read_regular_fre_datawords(sec, fde, cur,
+						    dataword_count,
+						    dataword_size,
+						    fre);
+	case SFRAME_FDE_TYPE_FLEXIBLE:
+		return __read_flex_fde_fre_datawords(sec, fde, cur,
+						     dataword_count,
+						     dataword_size,
+						     fre);
+	default:
+		return -EFAULT;
+	}
+}
+
 static __always_inline int __read_fre(struct sframe_section *sec,
 				      struct sframe_fde_internal *fde,
 				      unsigned long fre_addr,
 				      struct sframe_fre_internal *fre)
 {
-	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
 	unsigned char fde_pctype = SFRAME_V3_FDE_PCTYPE(fde->info);
 	unsigned char fre_type = SFRAME_V3_FDE_FRE_TYPE(fde->info);
 	unsigned char dataword_count, dataword_size;
-	s32 cfa_off, ra_off, fp_off;
 	unsigned long cur = fre_addr;
 	unsigned char addr_size;
 	u32 ip_off;
@@ -224,75 +359,88 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (cur + (dataword_count * dataword_size) > sec->fres_end)
 		return -EFAULT;
 
-	/* TODO: Support for flexible FDEs not implemented yet. */
-	if (fde_type != SFRAME_FDE_TYPE_REGULAR)
-		return -EFAULT;
+	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
+	fre->ip_off	= ip_off;
+	fre->info	= info;
 
 	if (!dataword_count) {
 		/*
 		 * A FRE without data words indicates RA undefined /
 		 * outermost frame.
 		 */
-		cfa_off	= 0;
-		ra_off	= 0;
-		fp_off	= 0;
-		goto done;
-	}
+		fre->cfa_ctl	= 0;
+		fre->cfa_off	= 0;
+		fre->ra_ctl	= 0;
+		fre->ra_off	= 0;
+		fre->fp_ctl	= 0;
+		fre->fp_off	= 0;
 
-	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
-	dataword_count--;
-
-	ra_off = sec->ra_off;
-	if (!ra_off && dataword_count) {
-		dataword_count--;
-		UNSAFE_GET_USER_INC(ra_off, cur, dataword_size, Efault);
-	}
-
-	fp_off = sec->fp_off;
-	if (!fp_off && dataword_count) {
-		dataword_count--;
-		UNSAFE_GET_USER_INC(fp_off, cur, dataword_size, Efault);
+		return 0;
 	}
 
-	if (dataword_count)
-		return -EFAULT;
-
-done:
-	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
-	fre->ip_off	= ip_off;
-	fre->cfa_off	= cfa_off;
-	fre->ra_off	= ra_off;
-	fre->fp_off	= fp_off;
-	fre->info	= info;
-
-	return 0;
+	return __read_fre_datawords(sec, fde, cur, dataword_count, dataword_size, fre);
 
 Efault:
 	return -EFAULT;
 }
 
-static __always_inline void
+static __always_inline int
 sframe_init_cfa_rule_data(struct unwind_user_cfa_rule_data *cfa_rule_data,
-			  unsigned char fre_info,
-			  s32 offset)
+			  u32 ctlword, s32 offset)
 {
-	if (SFRAME_V3_FRE_CFA_BASE_REG_ID(fre_info) == SFRAME_BASE_REG_FP)
-		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_FP_OFFSET;
-	else
-		cfa_rule_data->rule = UNWIND_USER_CFA_RULE_SP_OFFSET;
+	bool deref_p = SFRAME_V3_FLEX_FDE_CTLWORD_DEREF_P(ctlword);
+	bool reg_p = SFRAME_V3_FLEX_FDE_CTLWORD_REG_P(ctlword);
+
+	if (reg_p) {
+		unsigned int regnum = SFRAME_V3_FLEX_FDE_CTLWORD_REGNUM(ctlword);
+
+		switch (regnum) {
+		case SFRAME_REG_SP:
+			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_SP_OFFSET;
+			break;
+		case SFRAME_REG_FP:
+			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_FP_OFFSET;
+			break;
+		default:
+			cfa_rule_data->rule = UNWIND_USER_CFA_RULE_REG_OFFSET;
+			cfa_rule_data->regnum = regnum;
+		}
+	} else {
+		return -EINVAL;
+	}
+
+	if (deref_p)
+		cfa_rule_data->rule |= UNWIND_USER_RULE_DEREF;
+
 	cfa_rule_data->offset = offset;
+
+	return 0;
 }
 
 static __always_inline void
 sframe_init_rule_data(struct unwind_user_rule_data *rule_data,
-		      s32 offset)
+		      u32 ctlword, s32 offset)
 {
-	if (offset) {
-		rule_data->rule = UNWIND_USER_RULE_CFA_OFFSET_DEREF;
-		rule_data->offset = offset;
-	} else {
+	bool deref_p = SFRAME_V3_FLEX_FDE_CTLWORD_DEREF_P(ctlword);
+	bool reg_p = SFRAME_V3_FLEX_FDE_CTLWORD_REG_P(ctlword);
+
+	if (!ctlword && !offset) {
 		rule_data->rule = UNWIND_USER_RULE_RETAIN;
+		return;
+	}
+	if (reg_p) {
+		unsigned int regnum = SFRAME_V3_FLEX_FDE_CTLWORD_REGNUM(ctlword);
+
+		rule_data->rule = UNWIND_USER_RULE_REG_OFFSET;
+		rule_data->regnum = regnum;
+	} else {
+		rule_data->rule = UNWIND_USER_RULE_CFA_OFFSET;
 	}
+
+	if (deref_p)
+		rule_data->rule |= UNWIND_USER_RULE_DEREF;
+
+	rule_data->offset = offset;
 }
 
 static __always_inline int __find_fre(struct sframe_section *sec,
@@ -344,9 +492,10 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
-	sframe_init_cfa_rule_data(&frame->cfa, fre->info, fre->cfa_off);
-	sframe_init_rule_data(&frame->ra, fre->ra_off);
-	sframe_init_rule_data(&frame->fp, fre->fp_off);
+	if (sframe_init_cfa_rule_data(&frame->cfa, fre->cfa_ctl, fre->cfa_off))
+		return -EINVAL;
+	sframe_init_rule_data(&frame->ra, fre->ra_ctl, fre->ra_off);
+	sframe_init_rule_data(&frame->fp, fre->fp_ctl, fre->fp_off);
 	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
 	return 0;
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
index 3fcc15534e5a..5b6112945b6c 100644
--- a/kernel/unwind/sframe.h
+++ b/kernel/unwind/sframe.h
@@ -66,6 +66,7 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_AARCH64_FDE_PAUTH_KEY(info)	(((info) >> 5) & 0x1)
 
 #define SFRAME_FDE_TYPE_REGULAR			0
+#define SFRAME_FDE_TYPE_FLEXIBLE		1
 
 #define SFRAME_V3_FDE_TYPE_MASK			0x0f
 #define SFRAME_V3_FDE_TYPE(info2)		((info2) & SFRAME_V3_FDE_TYPE_MASK)
@@ -79,4 +80,8 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_AARCH64_FRE_MANGLED_RA_P(info)	(((info) >> 7) & 0x1)
 #define SFRAME_V3_FRE_RA_UNDEFINED_P(info)		(SFRAME_V3_FRE_DATAWORD_COUNT(info) == 0)
 
+#define SFRAME_V3_FLEX_FDE_CTLWORD_REGNUM(data)		(((data) >> 3) & 0x1f)
+#define SFRAME_V3_FLEX_FDE_CTLWORD_DEREF_P(data)	(((data) >> 1) & 0x1)
+#define SFRAME_V3_FLEX_FDE_CTLWORD_REG_P(data)		((data) & 0x1)
+
 #endif /* _SFRAME_H */
-- 
2.51.0


