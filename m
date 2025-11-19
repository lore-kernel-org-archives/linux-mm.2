Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451CACF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537206B00B3; Wed, 19 Nov 2025 08:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BEBC6B00B4; Wed, 19 Nov 2025 08:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24FA96B00B6; Wed, 19 Nov 2025 08:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8E56B00B3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7F0712F88F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:34 +0000 (UTC)
X-FDA: 84127426068.13.44F7BC0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3864040013
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IQXpFiqj;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7l1WWxtKRuL/X9Muntksx05tggOVq59VtOLQDajU3Fo=;
	b=zDJTXDlPCXFHaTmW2+i0D2oI10NR22bp9SefnGGey1ashzrTpgJK+hn9SMRNagJsYV0aRr
	30zBMUfnAYu0WZJElG7QqC588EmFyZqbWDEb5iY3KXO2KLg8pfp5w49EIFl0sSPy2TpO9Y
	2Xj9oXxP2k0H8nSRSByRWc+MYdD6m+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558672; a=rsa-sha256;
	cv=none;
	b=B8tW7mDEWeIUaKgR4uKRL1fKwinpWzCvJQ+RP5RFHjvTonoRP08OoKGt1tfthJPWt/uJJS
	hmzAhDwEQhLNtHGa0OtI2r6Q+hG2ZycTDCoWKCjD9bJDR8B7ZFQWjjxSbbdWpZxpmQvuvp
	IWAq1jKwfTzXR8oh7q/LCeoyPkZCusU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IQXpFiqj;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ6ExJR010097;
	Wed, 19 Nov 2025 13:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=7l1WWxtKRuL/X9Mun
	tksx05tggOVq59VtOLQDajU3Fo=; b=IQXpFiqjHsshYEcvkGj8kYL++Xv3EsWmo
	bpJw2cqktGkhSMnM96CBBLYgSKF9avlHIaQ6MY302NSMLpONkcnse6SXN0iS+c3f
	CNToi9T8NoxnSXaG7zu4YixqtUWyH5ETIGYzyxzpfIfXkiSJBRWSns8wgNt/yyP4
	FNGaXQ0VDeEOau5g6oze6xAHpa2QX/dMwggcmav0ioqoB3uQ9R0N9kywBU8J0M4d
	q/if191KOtqK1GOin9b1rZB33uG852vjiJ7FnOCppsl5oMUEQfbhC5lINFvXVqZi
	8vPW/M4IG8AM6f273Rw735R5481UzL2UhnRlStmGiXtj7umPJ25FQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk1gms5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:34 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDNXqA028780;
	Wed, 19 Nov 2025 13:23:33 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejk1gms3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJCKaDW017381;
	Wed, 19 Nov 2025 13:23:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af6j1rhh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:32 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNTq125887136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 06BDB20040;
	Wed, 19 Nov 2025 13:23:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A7782004B;
	Wed, 19 Nov 2025 13:23:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:28 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v12 05/13] unwind_user/sframe: Detect .sframe sections in executables
Date: Wed, 19 Nov 2025 14:23:15 +0100
Message-ID: <20251119132323.1281768-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=C/nkCAP+ c=1 sm=1 tr=0 ts=691dc4d6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8
 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8
 a=yMhMjlubAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=7mOBRU54AAAA:8 a=meVymXHHAAAA:8 a=7QiolxpzR31IVsMsWeYA:9
 a=k1Nq6YrhK2t884LQW06G:22 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: 5T3e6txdIM1AGfAMguxW6pvvqYroL94X
X-Proofpoint-ORIG-GUID: ibq3Y95r5rYLWxSi-5WcA4_ovpPpvag5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX5ZsXrg93Q4Rl
 ryJbWOFQsS9cDdy25mTyYCln25cJLIiDYqEWyVmQqRtLpNHmvEWg1xRtJRXxPkpCLdmzGom4cIz
 ue36ooAk7PCyx6CSGIGCN1UZt3SYysCFH9ecTQ1+uRufSDuuwSulebNZVwkJlXIRFhMG67rSKdy
 RncOBJV+Bf0QKk8uVxxxXsGfbt/pQO6cF5j+EfORTL1mXXTcN1Swpqq/T8/Y5Vx+oqvBehzmjri
 erJy/dDecEk0uJs2qYlK4oxIFaQPI1BiYSbeZ/q9Crwv7OXymJhcnsSl7/A9w4DXkn8hnm5FVIk
 WsgSvAKZ0YJao31Rlps4hEMDyMtqB+mXQ6UJHlfZoFUlJsA9H1crj8PQfRVGNarQ3dGo+YlSaMI
 e/muKrMUc77XSYuRTvnQYGYSGBgMPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3864040013
X-Stat-Signature: qbqyg1opuwyzx1ezgnoftruin5xr8d3d
X-Rspam-User: 
X-HE-Tag: 1763558671-911903
X-HE-Meta: U2FsdGVkX18gHioGL8EJGG1zp1QjYqOv+DUTqqnepR4RHP27YvNNdpv0jfAiLzqxNyQBAqGx99CGrbwhfPuw89Yiu8nhz/C1yGgEenLqLzV0NGfyKtskn+BCLnz23cma+PmsB4ebRXillCTO8VWqR/cyYeXOpyKA3+5JQyLQ9o6BXkiy82LG6vn3QyJmbIrNXEUORuXUxUYXC4COVHZ2CDH2uj3ONnXngXGsXdWAgr8rWwFUjogR62bIzgBK1SnTf3M/Bf5/dAX1EZ5t7XtSbWSSfPXQDXJ/5VNz3QEoT0MFRt5vCMoaxhuORgwPN387F/gBnRQFJSM9u1GEI0+dh4CsaYPzJauz9+tIxiuokOmzX2LAQXIdy5YjdZjDt+IG65y9hDNyG5mhgnrxI1O7k6cahW6DowUEWgqzxANSy6aXItj+v9Nrxvha4ENICSuamdCtEko9Z3gplDLFpiCM5ACdouZSITHolNG2roQU7goF4MIeUsdABfiUB9no6XEvT0vELvW/6gFBQP26qGJT+QWS+ouOgoo+Gfpg1k5iDRJT0ektrUlaf3voQz9bgB+9dKqWVkKWw7juwaHIFc5zaJIt41n/7aTXJDvKkSuf8t6XbTPNHNX7qhdh7zzf2D0oLICR0mZKfW6nEyZDqogpmm/mio0WMA++kXxjPDSGbCCuLnN8z8dyvkoM0b8g4/JbPWevPAD06Jpo+1s0vjaVZhOEbTEbaj4+kdNBZ8kRIyITf1uM1M9lF2VRakYbZ2IaW6N1VXUHfmmP9siVMkPizfn3jw5uksG8cz+ylVZfMi2cvlzyheIV9IASxcvyxOvGlC9SKWEGJAhyEChBVRrtT4KH6NwRJYDNNJ0+NvkEqgln+rNYRibcYvYU3N0nEDaTulIk6/1fa55bH10Thnk/ZJbV5B+ec2w9BL5Ej6aBmizVqd/Vi3HtdDv6yyGz3mcOFBDkV2naSq52lH/1FUl
 UzJvVSsp
 VwO5ZGB43Jd0uVs/+DwM2+r49yU9N1e0woWfNR0lGB8GqoXWkiXk17siWEfKw/JAOeQxsn2hPY+ClsaZRXFZDheCGDxMeSLT5oiZWI76/p3RF3jzeR5zxubhBc1ILAmnjaiQa4JLylIuDp3aVhznAfdW0eN53dZAXie8ZhOkZ6aDiy1SEcTlb1jgVXz75N9p8aEqjyCACr+17pBJKv0kh2OKmAt+RF99wkGrDl8wTXCxYuVyYfZglcXchZHTPrcIryQoDHWcwxJsSug8DmCrcg5DDwwABwx6YbsmC+H8ZarQm4Hm0O8KtCF6e2KWnCjhnDC2lYPzlGkF4lhe1yO4shCGObFCtPy1T/OMVqP93qW8LkY7jaGyMVn3Cq3SsN41tGsLNKqFEwNBPWa4M3ONm2M+jNdyH8mCGIK3sL761lHLXeWcLs8MinxIEm8dZumL4EcQCvBn4yWyi6BmKI/0Mt9f1qVSZ1Dzjgx5QPH/ZFjGApipQIvn02brrQdhG5KY8R4KffelIJAAvYFpdpU5aAQPfLrLcYQErY4Wj3inLTkLMVGBcg+6Jnsj1e/ES/vBw8ey/MuY9x95oLx1yJ/FkYUESHydFibKH9srDqLwqKINkyqSTjXCcZYIdCNg2yKtTFVm07+U57bWXpxBI7W5AAbbl8tH56y9NW32yHXeEU5fISoL/gLchRUkLfbt5jhYNizIuJ1MLg1rWCucTbMAbZmvobR1VqRARYOAGpsUqEBm1tY1NlS/HKZ7Kid8qPWLBatsg4Ij+dYjdF2rKH+OGma8dYPIf+lyswJkHuIdH183cerWYe2bgCriQ+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

When loading an ELF executable, automatically detect an .sframe section
and associate it with the mm_struct.

[ Jens Remus: Fix checkpatch warning "braces {} are not necessary for
single statement blocks". ]

Cc: linux-mm@kvack.org
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
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v12:
    - Fix checkpatch warning "braces {} are not necessary for single
      statement blocks".

 fs/binfmt_elf.c          | 48 +++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/elf.h |  1 +
 2 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 3eb734c192e9..fc6ecb4d239e 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -47,6 +47,7 @@
 #include <linux/dax.h>
 #include <linux/uaccess.h>
 #include <uapi/linux/rseq.h>
+#include <linux/sframe.h>
 #include <asm/param.h>
 #include <asm/page.h>
 
@@ -637,6 +638,21 @@ static inline int make_prot(u32 p_flags, struct arch_elf_state *arch_state,
 	return arch_elf_adjust_prot(prot, arch_state, has_interp, is_interp);
 }
 
+static void elf_add_sframe(struct elf_phdr *text, struct elf_phdr *sframe,
+			   unsigned long base_addr)
+{
+	unsigned long sframe_start, sframe_end, text_start, text_end;
+
+	sframe_start = base_addr + sframe->p_vaddr;
+	sframe_end   = sframe_start + sframe->p_memsz;
+
+	text_start   = base_addr + text->p_vaddr;
+	text_end     = text_start + text->p_memsz;
+
+	/* Ignore return value, sframe section isn't critical */
+	sframe_add_section(sframe_start, sframe_end, text_start, text_end);
+}
+
 /* This is much more generalized than the library routine read function,
    so we keep this separate.  Technically the library read function
    is only provided so that we can read a.out libraries that have
@@ -647,7 +663,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		unsigned long no_base, struct elf_phdr *interp_elf_phdata,
 		struct arch_elf_state *arch_state)
 {
-	struct elf_phdr *eppnt;
+	struct elf_phdr *eppnt, *sframe_phdr = NULL;
 	unsigned long load_addr = 0;
 	int load_addr_set = 0;
 	unsigned long error = ~0UL;
@@ -673,7 +689,8 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 
 	eppnt = interp_elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
-		if (eppnt->p_type == PT_LOAD) {
+		switch (eppnt->p_type) {
+		case PT_LOAD: {
 			int elf_type = MAP_PRIVATE;
 			int elf_prot = make_prot(eppnt->p_flags, arch_state,
 						 true, true);
@@ -712,6 +729,19 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 				error = -ENOMEM;
 				goto out;
 			}
+			break;
+		}
+		case PT_GNU_SFRAME:
+			sframe_phdr = eppnt;
+			break;
+		}
+	}
+
+	if (sframe_phdr) {
+		eppnt = interp_elf_phdata;
+		for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
+			if (eppnt->p_flags & PF_X)
+				elf_add_sframe(eppnt, sframe_phdr, load_addr);
 		}
 	}
 
@@ -836,7 +866,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	int first_pt_load = 1;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
-	struct elf_phdr *elf_property_phdata = NULL;
+	struct elf_phdr *elf_property_phdata = NULL, *sframe_phdr = NULL;
 	unsigned long elf_brk;
 	bool brk_moved = false;
 	int retval, i;
@@ -945,6 +975,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
 				executable_stack = EXSTACK_DISABLE_X;
 			break;
 
+		case PT_GNU_SFRAME:
+			sframe_phdr = elf_ppnt;
+			break;
+
 		case PT_LOPROC ... PT_HIPROC:
 			retval = arch_elf_pt_proc(elf_ex, elf_ppnt,
 						  bprm->file, false,
@@ -1242,6 +1276,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			elf_brk = k;
 	}
 
+	if (sframe_phdr) {
+		for (i = 0, elf_ppnt = elf_phdata;
+		     i < elf_ex->e_phnum; i++, elf_ppnt++) {
+			if ((elf_ppnt->p_flags & PF_X))
+				elf_add_sframe(elf_ppnt, sframe_phdr, load_bias);
+		}
+	}
+
 	e_entry = elf_ex->e_entry + load_bias;
 	phdr_addr += load_bias;
 	elf_brk += load_bias;
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de..92c16c94fca8 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -41,6 +41,7 @@ typedef __u16	Elf64_Versym;
 #define PT_GNU_STACK	(PT_LOOS + 0x474e551)
 #define PT_GNU_RELRO	(PT_LOOS + 0x474e552)
 #define PT_GNU_PROPERTY	(PT_LOOS + 0x474e553)
+#define PT_GNU_SFRAME	(PT_LOOS + 0x474e554)
 
 
 /* ARM MTE memory tag segment type */
-- 
2.48.1


