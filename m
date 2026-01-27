Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90789D2D8FD
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7A26B00A4; Tue, 27 Jan 2026 10:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B946B00A5; Tue, 27 Jan 2026 10:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18FD6B00A6; Tue, 27 Jan 2026 10:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E42E6B00A4
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:21:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44EED5733E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:21:41 +0000 (UTC)
X-FDA: 84378108402.07.8F068CB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8257100007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:21:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="clH5/tXV";
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769527299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVm5fftPMxN9/Z5b/HvpY+qb7Z5C4VZqWHD0URHipvg=;
	b=ZwMgkDKGtMfgU3B7nc+19Z12C6u5IeAgtEbDzTGZ5siJpcEMusxOSFuqf450DlGpyxLOpt
	13jLQiyREXAfuaAHQ2f1loJGoocKo/uL2HxglUf6Bf8vp/n2eKfxFNRyiMS/hWYr9BbtAg
	85nYMRnFu3JQDcnMdfBP7gv1rImBLSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769527299; a=rsa-sha256;
	cv=none;
	b=xZZREGVebHLWtpJ65U3pXEydG4gy1ftGXB67ulxjJSCdgAH8U3MdA7lYdhPyj88aEsDN6a
	zdMa14qOaOX5MxOeQE7QD7BC+KNBXWwEAKzv+XPFvR1ty9E14gqWqU854SuwpNb+Ekc29M
	CT6uWSU9BffhUuPdGS2U6yLACaXRF/Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="clH5/tXV";
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60RBIvNL020431;
	Tue, 27 Jan 2026 15:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zVm5fftPMxN9/Z5b/
	HvpY+qb7Z5C4VZqWHD0URHipvg=; b=clH5/tXVntD26pkJpDYOLDvDuioG+XOmh
	BOfZtPKdC71XL4MQrv/zdfOlXxHGMJwJansyAozOatpMVQ/oy3F5v0t/Wcvv3lc4
	izaQJbACzdnH9t/3NPaNWn0Y/nbQesLp6N8kvr//LrTTjQ/QSzsWBmYscxMZ63Nu
	desnJuZE0F5suI+mZgayD7oKQL6FU3v5iQcCYyR5CZwaRO7AzQvp2uuRwj7G4dLk
	Jt9VAnNPaUrsgsful7RUWq8JpjXu7ty/FWYgp14h7EAsF6uUi7yJ8netsA8zuvzb
	eEwn2yaANGyzv+elIux++G3jbTKngI0HBL9PkkaqPU0Cw7JMs/nkw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvdej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF0auZ013973;
	Tue, 27 Jan 2026 15:06:05 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvdee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RD69uk019647;
	Tue, 27 Jan 2026 15:06:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw9dn13qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF60JZ39191032
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2533020040;
	Tue, 27 Jan 2026 15:06:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C23922004E;
	Tue, 27 Jan 2026 15:05:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:05:59 +0000 (GMT)
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
Subject: [PATCH v13 08/18] unwind_user/sframe: Add support for outermost frame indication
Date: Tue, 27 Jan 2026 16:05:43 +0100
Message-ID: <20260127150554.2760964-9-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z4vh3XRA c=1 sm=1 tr=0 ts=6978d45d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=mFg4y33aAicYmUfzDuoA:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
X-Proofpoint-GUID: KlXhgSsl-7XYGr8sEfIy1wcmIpHJAtvp
X-Proofpoint-ORIG-GUID: 1nm0Z9teSyeP7GTrC8S6VI-9JvDkzbHB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX8ehchMl53yaJ
 fhvCTCx2yZ+p/TGN5+RQxrq9+j9wt8NoOUFDFh4LaSJ8mHgL4MfxPbe1jiMBkO2WgFVHakS/7r4
 M/vG8tmc6/ZZtysxHnzyfD2QBCzYPHmtaDf8z6PoOSaGsRPGux9TIHoDib4brteX4Kl7RxoOko3
 R/BboGphlfMIzq4TYydGBoXM6RQzK9f4qNX3l9SXTf11tarMJYJMd1F3Gzz8JjuoHTmxKCsAKSj
 Bhqx3M2ObqttbbAkyce1w/34RocYLgP/kLgpIm0eWsYQGgQJppOZ7G3QXRJtMQsmKPeOGpPLt09
 5p1uRo/I2tKfrbhz4qa+cwhw2kOhG3IkbrcIJxw3zl7zZ8E9bo90ijYt9EA1yBlHYYHRmBkfO/R
 MpszybXEApyTC3gxchB+ndVRNUZs8XNDhDXZA57uFhC0OD/V/IT7GHTkPTs0mIAvqbZDzp7ItNT
 b/PaEexVcRASurcbwHg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601270121
X-Rspamd-Queue-Id: E8257100007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: w4hunzkaqgmgacihhxec7nene8em79md
X-HE-Tag: 1769527298-214939
X-HE-Meta: U2FsdGVkX1/uKcNpNpApSmNWOz6DJvYiB6t+0PRafyyGDkgW4ri55bumzJEFD6creF2LzJjPLOin++ZeMlmI1bm1LtzU55ZhO5Elp3dX6+P2fPukeH9Bm8P3t8Mrh85CYL/agWdX98TBW8xLqtndDMhw5Gy1BU2AR3udfV2K11fRVyp9UoR6mKkjPvOnyhtZsYOLvp5Oja4x14xI8vLhdwyF8d45Ck5NjRdTpwSd649Mct74Mkf82bQAuLUS/7lYQ/fNyUFVhuvqtNhr4VxrnIRntdF73218Ki16xRViVtQWPx2006r9kTrgpzDNPXtVtdILUE7YfYQVBmM6jFRWQGXHkdCcyRKnNuHxtmbMGSxmy2HGzSHxJXa8NxwwcnpOM9G3mqdbzv5aOFTEKpwJItD8hoRZWXKcmEnhL6oKZ9Mk2TzHgmW9JbsFgU9qNHElS1PcNDLoKSyAPgX2NjchbHWoTTJF5UKvkt1vis2AB7To+qBPbnW6MpQowqOHtAeEJniHqPLN5Jd7yLp1povP6+6zaAP7hzyh1eVfDFxVFVvVDAgLbepuosHs20Cvop+BZUi9D6ZONUBW+qeiklqWIteSUAQTAztdfBvkyFoRVeVGnh8gSs+4sxsfplN1sQiZtdk37igv6FBIdjPUcw2QvCVFutqTiv+C7wNl3LREAan3gfR2LADu4UO86Lt63sDW8dRGr4qJpU3UDRKWerQ0dSjS2Lu/ZAUS7kjitLXCshzh2+5OOr4SIzfnXmSTChv8lJA5nPody7IQ3xXMQWNBqPJ2bNxee4Z3zgitVp+O798y6nuOOoHic4Fbwz4vwdwztdZWmcWK8NbewpEbKdQO1V7n9EZHW5uQM/+pnUecCxhWIRw2/BKQg1eCtRph93unYxKI+cyDIj54/61GrBH9dhHCMsHBEQQ6IztS1S7IdJCXXpy16IYPNsDzFsbbGy5gqPPyFiQT8OaZgYmkpZ8
 9pHKaKIB
 kLKRAMtFEVbwLFFdhwWGNUISdkK5d1ZJhu8vZtObwA9JtZr36ko9dF9frsY5jFW+ZiaIUXbrv9+xcUJBYvfo8yml6mg/NGznSbXjxYLGK3+Zs4LtCIROuiQrkq5T1FYsNzjmzrTS8zVEJcyHoWtloNGN0HXcuLZPl6ixEtioDIa9pLgQOntJLQ+wTfP0h4mTKjrcWTGKtVzuQYn8XsjUl3JFi7D4jqMplmSIqDOVkWwR6bSp+3ZUTmfF7E22Mt/vopvDk44LmTzBHRebuAhQU2BDNESAexgFl0Pw8BClHnM2cegIhwWY6D6IyhXfB4d7BJ6q7uw78teng6lyUPbQnMwnf8LrzmMToIMwyYf2NDNxnaufUF+nEWYmht/g93IF39C9A56kV+r8NlvKXFn3kaYeLW9ABv4VdXh6znb+nthk/nQwLG/17o/hCLbjQ6kJSMm9ced+spbM5IhWr3njdB0gLHee7hfFsaXGzu0PqWgoRR04lDnE46cB+cyJbkm2e8CHxSYXFkMH7j2MYR1ivpiPG6PLaO4ecS2srFai5MplBwVHZqz2lPw/1Q7u2vLaa1hDd4+6wJgOv0ZtUBtLAkg1bszFs5m5T+zYs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SFrame may represent an undefined return address (RA) as SFrame FRE
without any offsets as indication for an outermost frame.

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
    - Use SFRAME_V3_FRE_RA_UNDEFINED_P() instead of struct
      sframe_fre_internal.ra_undefined field.
    - Reduce indentation of assignments.

 kernel/unwind/sframe.c | 15 ++++++++++++++-
 kernel/unwind/sframe.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 9b3779924395..6004b43aac34 100644
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
 	if (fde_type != SFRAME_FDE_TYPE_REGULAR)
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
index 07a2e99855f9..3fcc15534e5a 100644
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


