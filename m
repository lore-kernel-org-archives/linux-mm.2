Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC239CD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEDDD6B0088; Tue,  5 May 2026 08:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76B46B0093; Tue,  5 May 2026 08:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16B56B0088; Tue,  5 May 2026 08:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88BEC6B0092
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AA35403E6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:12 +0000 (UTC)
X-FDA: 84733268424.23.4608ED6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0266A0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VEwxoKQy;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rPRr3FZStWFGzetx6++VNjJW1FkjSSD795lGjO3e+g=;
	b=Ta5hUpQl16AIj9s9Kp9Lg+qm5fCCojndps6cOSb5bjg1gUDxSk/4EbrxJwvPG0nQyjiYX5
	tP9sRrVAHYPkG5Ube7WnVoG8eyyg6QphtrP8Vc7iohcnHOUe+4i477o34mky6YnTw6sCaa
	1Za0YlYcdJW7OQqUCh7CJeYNmebF8Cc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VEwxoKQy;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983489; a=rsa-sha256;
	cv=none;
	b=RDzJJUWsjBbz73zns7yV70lNI0vozEUlNdwbhvRonwyLiDPsjmI4/khDc1DnfgLAVMKebI
	Wk39HFediYZ8chFk3uL/FjkFPeGQOb//b34FCric3LbryCnWvjBSlQk+5BLixJfKxmiSUT
	BTlExpKjGcDuaOA9eF6k1LR3BKSDrcY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6457XVQv3464145;
	Tue, 5 May 2026 12:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1rPRr3FZStWFGzetx
	6++VNjJW1FkjSSD795lGjO3e+g=; b=VEwxoKQytBh8r2anKmrQqsD/fQrUCoyYI
	dPEgpHAorlGbTKN9hFnqiHfk/Y70Z7kIWHvhdgrbZpSi4YaocTbjDKQqkv6lQWXL
	1o0+YDWR+sKsS/D/CcTo7avul1PUaW9nRyzLfsqTn1zBmM69KJpPyq+C7woDYKdN
	fcQRoxnIEWlCLJZM9kW2MrJB9BZtw+FmW8jW73vfP4fRPIkPcBtS8TRGL69vMoz7
	Vj89YJgsQw7Sd8KiewtLXRLG1ZLGtU18ROXSc1iTrGLOctoRq+2BOjp/mjPbUVh5
	MWNl3YnG8wqTMpFdrhyD/gKO4UfR7SmvWmh7J/4OBUyNEikLfXTog==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7bj9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9a40030210;
	Tue, 5 May 2026 12:17:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwukq9nmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHPVF59375896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 322A42004B;
	Tue,  5 May 2026 12:17:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C98F42004E;
	Tue,  5 May 2026 12:17:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:24 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
Cc: Jens Remus <jremus@linux.ibm.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v14 09/19] unwind_user/sframe: Add support for outermost frame indication
Date: Tue,  5 May 2026 14:17:08 +0200
Message-ID: <20260505121718.3572346-10-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXxs+poCAAGGNG
 9Cfil+KpyvOWZ9eNrzo7p0DMXBFB8ddw/Z1jToIBMfBbF8gMOySE1DKHJWcGx47Gnac7WNDTiLo
 taNPOzcwB6Y8H6i8+1Pp4KPU6O2MUhFcCVbjeAmZURahIZN00aaJLb84ENmOF9mGSz+ks67MlTr
 rWIEqS/rjtv0J3bSVM1foQruayIKEyaxqJNlMCE5TMuK5spshFERy06ksgWNkD9fIzJybSvy8B3
 ewWKJrKeorztqyjQ5ewij1YeHGFgGAgz/tqg52Kodd3NY4+bhgFswOXORS6TxaC/pufO+nVvMNa
 lvDsil9mJNjZR2uQAp/BAI5qeJIaCVQtOqPedhVQXoftsOrMd2EDrjECVrxiqBzenGD4t2J7Ncu
 CisLkq4sGFxUfvR9G99vD6Ar6DfjXVzC1S5QvuSL4Y/xZu+Qjhz09vn8ebdNyklOCvsy4Qs4CeP
 2aUlUKu8+wPP2shbgRw==
X-Proofpoint-GUID: efVzNbBCZREIKW4fO6gioglIN0VcT-tB
X-Proofpoint-ORIG-GUID: BJSUMIXg6C-mMKI5aio-_pcfAq0a41Zm
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f9dfda cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=U72JrVpwKSe1qDC-WCIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Stat-Signature: c9rktnm5oo88xbcnkgzy3fd8oauo538a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0266A0002
X-Rspam-User: 
X-HE-Tag: 1777983489-932625
X-HE-Meta: U2FsdGVkX19yFWMAFuljzjlMIm2U6rv5OJsBpNOKDPikuRA/80xEcaLBgMY50aVBuGkNGTTZaFg+cxT8G4BBnRsRv7O3koQXzP2Lu96QLy6kzPdLtYEA1bvbB2kTVxNzljPQD3gnBEzXWmtqDEFOmD7yuCQ4L+Rx0UxmMw/CgtboXhdljc6qe+4sbdIlAgHDPgKlrWneyY5W3VJENUo/Z+hGYkBH2x3bc2D+QN0sQ+Vf2YbD8z4PoMJ0QgmK08bNklZ5xrXapp1/X1wNM2l14rBqCTmvqLraZqARdpnP0APxi16VetARQMYaSZZi851/M77VGxslSvlWhNSSnh91eLSA4oQ/MRl3q1XmHuBVvBNDvBK0/Ryr/Y78kpC2hMV4WFOe1VVkPKjQAGCXXGVP6/A+rptbEHuT4Vj4mJetqUuSGgGcZ9TJYmbO54qoiFaEZP7/N7j4LVMpkrVI9lECAwZCITNLy80UXyz2qF5AFKn5WGTBKtMzQ8oomYQCbvTyo32wfoR2z/gYyrxCBXQ0dyKJPOFJrLtaNfWZ/aahsVu5cvOTEHKhyJwC12qCVbLLH1oHGhDv1Ld+fadKk74W5+ydh0qKsjvOAmewNIn8Wg39BDfEmzRd89s2HD77c/8qZTeg0lN6XuabPKI6t5VYAKAJoGDpbW+uiStk0HxuMVnA82uXGTQSR1QGo0Gi/Ly2sfSjStzuaBzCbQZwD6SMY/4lprmE+Yr5hajsEsiwH8kB0qicOHCG9i8RETXtmP67pOaRmNM9mf0T0Aq5rFafUEUeZIa+kPsvU/4Y7H4dKgVOMyG1IKXsk34fd7n2OPwhVQSvBq/5mVLVgF5J29FqeybvCDRLqrrl1FwkyYtDF80nxltpI/+TI+QqlAm7Il7LP8KXAskpLQJvCvTrTa/nYMX9dU8/OEuapKlDmevdWomEDQ2Sb36ZcvOSFv3fG6lJa4tcYv1HCNgxrAe7Gpb
 hAVv039U
 4RvlcrLj8lr8n3poSZdR22YxqY7va2KZ0Ml4necCN07If/LqWY1jOI+8nOk6QmxBHizh1MyGyGf8DITVktezaofBg5pIE/WngV7+s2gbeVENGCf214M8Er9agUqBjQXcbTVP7xPh1LtY7qVYwTPL1DLJEvz5+mjk5UPnMCGeQaO/C52jQqhooVYU5avDFyX0OIRL2rFcTQyP6/SQuskZPkSxzsuHW/iSh1KHS/XfVV0v/xteDPBad/wsp87DN9xdMypI3/qWtIhCtLBpWwl+FBv5yBz9vNp1uiADfG4+O3Y5Imjf0qONnb0laBcPU/IySdi+2/HEMenu27WsMa3HFaTaWjO3bFCRpNoLK1VpPuKIfcMj11HDohPvNrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SFrame may represent an undefined return address (RA) as SFrame FRE
without any offsets as indication for an outermost frame.

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 kernel/unwind/sframe.c | 15 ++++++++++++++-
 kernel/unwind/sframe.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index c60aa527984a..9c755965ab83 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -218,7 +218,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	UNSAFE_GET_USER_INC(info, cur, 1, Efault);
 	dataword_count = SFRAME_V3_FRE_DATAWORD_COUNT(info);
 	dataword_size  = dataword_size_enum_to_size(SFRAME_V3_FRE_DATAWORD_SIZE(info));
-	if (!dataword_count || !dataword_size)
+	if (!dataword_size)
 		return -EFAULT;
 
 	if (cur + (dataword_count * dataword_size) > sec->fres_end)
@@ -228,6 +228,17 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (fde_type != SFRAME_FDE_TYPE_DEFAULT)
 		return -EFAULT;
 
+	if (!dataword_count) {
+		/*
+		 * A FRE without data words indicates RA undefined /
+		 * outermost frame.
+		 */
+		cfa_off	= 0;
+		ra_off	= 0;
+		fp_off	= 0;
+		goto done;
+	}
+
 	UNSAFE_GET_USER_INC(cfa_off, cur, dataword_size, Efault);
 	dataword_count--;
 
@@ -248,6 +259,7 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	if (dataword_count)
 		return -EFAULT;
 
+done:
 	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
 	fre->ip_off	= ip_off;
 	fre->cfa_off	= cfa_off;
@@ -314,6 +326,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	frame->ra_off  = fre->ra_off;
 	frame->fp_off  = fre->fp_off;
 	frame->use_fp  = SFRAME_V3_FRE_CFA_BASE_REG_ID(fre->info) == SFRAME_BASE_REG_FP;
+	frame->outermost = SFRAME_V3_FRE_RA_UNDEFINED_P(fre->info);
 
 	return 0;
 }
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
index fc2908e92c7b..ed111fd0d702 100644
--- a/kernel/unwind/sframe.h
+++ b/kernel/unwind/sframe.h
@@ -77,5 +77,6 @@ struct sframe_fda_v3 {
 #define SFRAME_V3_FRE_DATAWORD_COUNT(info)		(((info) >> 1) & 0xf)
 #define SFRAME_V3_FRE_DATAWORD_SIZE(info)		(((info) >> 5) & 0x3)
 #define SFRAME_V3_AARCH64_FRE_MANGLED_RA_P(info)	(((info) >> 7) & 0x1)
+#define SFRAME_V3_FRE_RA_UNDEFINED_P(info)		(SFRAME_V3_FRE_DATAWORD_COUNT(info) == 0)
 
 #endif /* _SFRAME_H */
-- 
2.51.0


