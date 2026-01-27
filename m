Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FD0D1953D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FEEE6B009F; Tue, 27 Jan 2026 10:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C00E6B00A0; Tue, 27 Jan 2026 10:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3816C6B00A1; Tue, 27 Jan 2026 10:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 194166B009F
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0D40D2B4B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:50 +0000 (UTC)
X-FDA: 84378070980.19.8BD5B0C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9807940013
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mkPMWj8O;
	spf=pass (imf04.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7PUs00n+iGXFRNkuNqX2x1J88rk3p3akBKjU23hZu4=;
	b=pTin5MrnIKlOAmpaXZGV+bf+Z0MdImlC6tQTJcKsBl9oIvk45R9GAA7angpJhEX6BasGrW
	X168BwHxJyZKrGVx03Kwtrg6DayHcecrhCUegZ07KACY8wLimfSIq1jS5GHrcfZ285fpdd
	ATSkTPwIXRt0SwJAdeTlStO1EiLBw8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526408; a=rsa-sha256;
	cv=none;
	b=PjhTUjiFufkAZlfIqDum3g6j0SUmg50QSbOOksJYDj7HYRVt6Q7r1q1+OKRoprM369qp8M
	qTs1zTexznTmXBCmyrYbvDCcRxM7rM/KycitCBXN7bDitbv/eP5tb6G+aoNOfa8YtjiW33
	V41XUlqRUnC4t48+WxAbuUV+ahn76jk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mkPMWj8O;
	spf=pass (imf04.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R8OYQK016222;
	Tue, 27 Jan 2026 15:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=j7PUs00n+iGXFRNku
	NqX2x1J88rk3p3akBKjU23hZu4=; b=mkPMWj8OFLLgSDNnS9OdTu/8KFhOUO0uU
	wQyWLa+f/i2FVk6p9PRzSOIof+TIBieeKLrkGObebgR84+d/Uj276IGB476jjH0d
	3735w+OwM2teAbkNuLPdL0xnJLHZlVErRLYdqTfnCAnAmu0NKo+98vXYul7b2u1B
	U1yalOAPBaIkEz2UDQgBNTM5Zvzf0r9Dz2j5RwcJZAz9QEmZvjfs4J4atO/SOcyp
	lD+94v2Hn4xts6Vt2B0jzBv/2d1DegpoIJqZD/6icBV6Is11YjrpchN+SmqFPICL
	44RWlajJfCmsTsiDwNnD8TQQBs7P+gebyI89SqI/1GvhssX04Gg1A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:04 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF1ZwM025842;
	Tue, 27 Jan 2026 15:06:04 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646qg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:04 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RD5sZJ031040;
	Tue, 27 Jan 2026 15:06:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bw8dsh6cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF5xBo37880180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:05:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBF8420040;
	Tue, 27 Jan 2026 15:05:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94D872004B;
	Tue, 27 Jan 2026 15:05:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:05:58 +0000 (GMT)
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
Subject: [PATCH v13 05/18] unwind_user/sframe: Detect .sframe sections in executables
Date: Tue, 27 Jan 2026 16:05:40 +0100
Message-ID: <20260127150554.2760964-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfXxyX8eQDOJo7p
 Gv3tzaBiHVI8HxE1hmXjviiHlheagc1N6M7LH73B1548/7VVMeobn8G7uNDsHQSqGY5zaJMANfn
 0VIkTcVmYdEDgzqvCuBo7PD52dLzzdj6280ccbzsM4rolRC9Q5/OgbNxuFMXyuAeg/n1XzKK212
 B5MZLdE+0TLt4E58brgt4dmjfEd/HhvLaYzoqIkCEqwfwXSarJId9Ply3+azb/ktPKtUruLZoaQ
 D30uvGn++tqZ2dYCVvPfqsLJIee3byLLcPD2skEmPuTvCphkvYlC5GHft6ZLKf00LKfcHZC7N5h
 9bXl0sl7rckSPMLhnxE0coCGPcl/hZGS/r7kyvdfFZszdrQw/auSYtn6Z8AoG/9A3FAWpNeeu69
 Lz5V8CZS8BWUI542SPAGECtN+lHIJnzx0js41dViwqdwZZCceCAwjOLqrLhzX5UsjW7VetUfNbB
 /xRXBPsUJ/AMZKb3OPA==
X-Proofpoint-GUID: -aKMD8f0xVdm5za7MVxww0k3EWdzg2cu
X-Proofpoint-ORIG-GUID: d_lNCTprw3XggzNds1LbFi8sLbGXEVGt
X-Authority-Analysis: v=2.4 cv=X+Vf6WTe c=1 sm=1 tr=0 ts=6978d45c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8
 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8
 a=yMhMjlubAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=7mOBRU54AAAA:8 a=meVymXHHAAAA:8 a=7QiolxpzR31IVsMsWeYA:9
 a=k1Nq6YrhK2t884LQW06G:22 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Rspamd-Queue-Id: 9807940013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kbode3gqupp8sub1n677husrbugiz3gm
X-HE-Tag: 1769526408-590419
X-HE-Meta: U2FsdGVkX1/CETrGAqJopUeIVKKr4V9Jp/qVl8ln26OlvaGCinUANh23QGdqwvqff5ekzVWzHn3FStN9HE1Jeepj9+ra3UF1b1t+uLkEDdiG4GVtteVb3NcTW3xqEu11muILJ976ch3xmzy8YTce6gRT3yAHwE/J3e/rSNSbPB5g0fqWZJSXMf97La0VegZ+HWYB+24QiUgyN4OdIS9vx1SiPvkMF9LjhgANQYy09WmERfIUnLstYwMCuJ+Cb9nsbEAiZRahU4e4mOeesKIBKlXDn2y0fAlDX/TfcAVeZoTOsqbCQHl7u2Kx0zbCa3IV7QdhfPuFETV0vzl5kkKOA37UP65yEVcExnyeQE8A9uvZtxvAVi98j/c+jlrZyoygaACeMEoy53bslPs76aZ0IUz6r7YrUrgSlT1JMc0aVSmbhyphRuASQm5vuaYYVaOILGRig1TryTgLHNBXKyvElQwmdVP8HOk3VO1vtAGfj6YBLA3BqMciymxQ11aN6ttpCfEdRfdrJ8JYIHDgZxPw6ukZ1/orMbxddUNSZx+WK97U9uUp9C9iZR+Ad184NvH/j2rtngLcb7bCB/TeJ8JaXfCZnRWuk+VxCzOZ07hNLISp9iHzZxgtlC+xTBPLzDvuKcp9U1iUVfb4sX++k/YGYrvU5+N/KTuFCa6VgbM6dOPzS0Zh/BY5fn0OOan+nAR69o1qgg/1FILttPRNf9wZ4yH6kI8oxgXmqt3wf9/DpeSjx5jcMYcf9jR7PfoGH/IijBPPTtxgM+EArJZW/Rs8nB+WpZvBD7ctH0gszldTLLutiVn5lnsapnt3EfU7gdjRY4HzhJcaemZzn+sQ0y4ZmZe49P1vnDV2jHM+S0V6VBL3yVyXtdnDXK6c8MfvNQVv/7NWjdbNV8YhBMDHg0F5sUB4ydonDxRg4BYDHP8IohD6OLoB5nmOSoTAnCzqBYIkW/rSPzubWFIDHapnXiM
 uUiFh5L0
 ebjI3bal4L0C+C0nK795OobezCY0m/A9FWLlfFFVEtyVisF50FJZkvBf2C2DSDyKrboFk7b1sMrgd04vcJtJ0VcXTO+E7Pg596lq2wj0ilOVE94LQHeUUFof1/1y3NFs7YWspYHzlYnDZQJ+gtAnCBNhOV7Y9KP3m5vk6sHylL5os66Pqi0Jf6XmV2aesIlW6yVw4gxTuaEa3EQpcQEIpvvgETdP7vObPsvzfKeLl4Fi/ggC6qy/y0YaqhgmCnQGerdVT8LWtMbpNtDuqeQT1+IckAO2SGWDeQHVFAg4E9OGaoyKl8U5k7JL6mpEPBQ41b0TJk5BfSJp+dmPsO6wM0NjeGDiwCCHcygrE61Xld3xkaNbFrpM5cpVAGwROgRGA72THCn8pFCmjjlKggcgfA6fFrzxP6bZ2b7ZV3rgLsdPZtLjn8pDeewy/BdqI0XnJw0L8H2y84AjDm+dtU3r1knvrPeSsCwaKOEyQqhwB6XqqNk6quVprbjY4oDe05Q3JGuML1yWxPaLBTdE2DSK0az7/1ErubmmR/UMkkgyQumN6i8U2pMA9izB26lQ8j5SKHmaWpY5UxY+XFoyUAcE7Te4FxN+3VzWticledZAT3YcYbBj6x+eifJxti1RTi3MDza1Du1H0mHbxNxl12hT9v4pvBNULBp9AkPAlqaSZ0oOo9mfV0hUxGHAvDV0SIns5XKhLhTz4hbeJKi7BYa6D/GxHjuEjLERf1Gpz
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
2.51.0


