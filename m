Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E189ECCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C2E8E0011; Wed, 22 Oct 2025 10:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FEB8E0010; Wed, 22 Oct 2025 10:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2818E0011; Wed, 22 Oct 2025 10:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E77C8E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12E9188CFA
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:16 +0000 (UTC)
X-FDA: 84026020512.12.873E8D9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 897091C0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K7YT52m6;
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9MMz1mGoVubG34DlLcHwqMIiwI8NCtc6jF/PmxwMZg=;
	b=yzZlUsV5dO4NiH5Q+BPOC+cvnSu/xHiuIdPbY4HbbIdhnur9V65cTJjdytVKfaWMTXfCgF
	LnKGpZ/Vj61MOzume4rrzWY+YRzeC9BQAXBL8oHqtTeFo7TgigJRaAZujbT4thUPlnM8T7
	jZjlPmfIP3YWDxdnl9bi/MYdV5tyh9c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=K7YT52m6;
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144253; a=rsa-sha256;
	cv=none;
	b=zNv5jpw4CRENnFpv8Vh9Td8howi/B66iIW5UQ/zHocZVcNYunsps4ziPT6Fw64+VPhlMBJ
	XtJSoopeIJynwQpOXW8A0p64bn9anx34MZnF/7aCK31vwOQ1/7se9VPenpl58XqYKONXTY
	G+iTwev0/7RoVEJqEJfFev0VdqLlJ+o=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MBCP66025247;
	Wed, 22 Oct 2025 14:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=s9MMz1mGoVubG34Dl
	LcHwqMIiwI8NCtc6jF/PmxwMZg=; b=K7YT52m6RutBes3Cm3YulTlXhcGreBL25
	1ijMItK4X1pt6u1Zm1PUkfRWycyzUgZb7SQFlzQ/yfc/2Y3mEwZLIHkd21PXjxy4
	dR3jCHKmCMGt29fRoq5dew5gYf1aa5JdmgMeW26w8KBoFGnl2eNPxQyRtEN552DP
	3mLj1y179Sv0TlTfnpksNekjb/ntSH1MlvKLiN8oA4JnLwTIHxzIzSvODZtNGmgK
	DCk+40wgbT6P/VFcDjXDwWNFh/9fIBTYnILNce5l/HvI0Y9+WTeu9k3yw42QZdym
	da8gc5zv9RxuHogPYynsAH4jyb5j+BBWqFnFqJQobv8Q0ecSr6fug==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326w91v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:37 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEUbBF012812;
	Wed, 22 Oct 2025 14:43:36 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326w91s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MC3rNq002281;
	Wed, 22 Oct 2025 14:43:35 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqejgnrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhVif56361262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:31 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 952D120043;
	Wed, 22 Oct 2025 14:43:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D6C82004D;
	Wed, 22 Oct 2025 14:43:31 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:31 +0000 (GMT)
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v11 07/15] unwind_user/sframe: Detect .sframe sections in executables
Date: Wed, 22 Oct 2025 16:43:18 +0200
Message-ID: <20251022144326.4082059-8-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EJELElZC c=1 sm=1 tr=0 ts=68f8ed99 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8
 a=7d_E57ReAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8
 a=yMhMjlubAAAA:8 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8
 a=7mOBRU54AAAA:8 a=meVymXHHAAAA:8 a=ng3ke6V5KTjMZiTm5ZEA:9
 a=k1Nq6YrhK2t884LQW06G:22 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22 a=2JgSa4NbpEOStq-L5dxp:22
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX9CjpBtdPtuoC
 qfnlwwMWLLEIeTnIJIbLrbS+p2nIDrQ1T3krCQUq5Sp3IBKhW9ag7c5VS0uC+cuegVzFBz4eK7I
 Fx1gFN1Hq4tI1D4xh2gzRF8AFSXNDnVlNg8WozpDNGUd4z/nLBV+Gn+vyIEM9cztv4iTiMqORa+
 HOGpIbpe54r6f8E2rJjM3fPHSi8F6E5zdk/hRkHPXTAwOeB5POjA1YwB++RGJtN1K3Ef7Bnr+39
 nEgiEhx79cI6ygce8WY7zk2mLZzFTDyxQhvVtuGOzuvZgtHYoqi+wgfSbAHWGF4ZeyIjtfYDvnt
 YW2bWw2Cy99pf/sqI796F538qZXLtBzF4iGb5w0btbW3Nbt56OwGL4rM75rZcfWQ0iLnec/VZQR
 x4NpegdMpup+28T1sjQMCPBK/XtC3Q==
X-Proofpoint-GUID: zcdgKPI7jkXrrrxZGMbTLYyI7xjjAwif
X-Proofpoint-ORIG-GUID: N-RsAOxJkuseCstKW9NYst5rXMarQDy4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Stat-Signature: pgpnnja7byyhcsbtizjo4ni9kjzgg8nx
X-Rspamd-Queue-Id: 897091C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761144253-662716
X-HE-Meta: U2FsdGVkX19WD3Tf0mHd/CXJFXhRQnnCeWcExeL8ZRqbT4Uqv9SXCdOBpqeTKRgifqX0v+QoW4bWcrsLdceNm4Ir4aUMeOYTh1pW02xKr9rh5Qolw2N9ujgIH22FeumWz5LLe98njB32Stgw7JPorFw7pT9FHQ8iqR+PnbOSwNUgVkD2Rhqv4XzoHhUBNVCBGJGtNIXAOyZa977Gjo9NXYkXc3phlcd4FnZVdPMlWmCdtzETzRwj4xbXFJ46NdJ/GjUN4EC2lTt8kwTJOY3X7LAPQSvxYaGpCt51Cf/QikU6M8mCREVy/wdOlgHh+qp6ggq5VGdlA03dxw170V4t2xPAp8BiGRrykazUHPYdFd3GmeevZNxHt3FPKrk5jG/idKEj3059o/762ve3wxMApTZTKJ6dbZEUgwpUH6VCmdkfK0Xr67NRcXh61NnYQ5xbW8lPVXO19YnIVSYbio9mEK4pEza5f3vtRqg3QkiFf0zHp5hl9b9b8PIdzA040vRx2EaqcOw4doh/wgKFUuO0Fh5eioYynG5X6f1Tdq+V29DtZSqN1YCQqvBM/2OQXmv4Ur5W2MVz6ZQIart6PMrPKf025yLqcObDpOhdxCiKRVURtl2iNgsRwpxsuNGDj+kZDZMEmxF2LHUTbxl/AVUsjfrhm0ELNfLDbz9GmwQGARmtaSDrIA9VQBymf5WOSzCdr5d1sFxMDYQxYnvEw1E0SzfKlUnMR3knL1+sHpSLsne0ldPn2Q8EgIuF5fLCSmFzqCno8Ws4P5/lYZeqIZuIeckZV7cTmVNS/oYIPim9/wOZSNLtT401WXNVO3+83k1VXBy9oqW7DQZw4eRVK77/mY848EAmc2rDWFTcYIVrEk42ANJ+Izz9f4C8HuQjhPEDeeazS/SlIk2AkBoJ2ilL1xktrDLgETZP4lvl7WF3qMjPdTywopy2KP8uzwdByjo/mMLfQqKvSn/CHbgooE7
 gKVd+unE
 JpDWycVydtlzBVB8hsi8aY84puN1TQhKntY7HGaLe+vQd+br+cP/aAcCVBUA9rAKZa0zz51K00IuLtuq/xs8Tbv8+gD6kdrz+PfcJVTsQkRCMeIHfEbDrFLS9TEhh9R+sbnCKt/LnZbZVyW2Cr3oh+jDLHMaJ7Gq5j5YR99sq3f2XrmVAkMwzznfd7NVFlqFH89l5yaa95dzAoCRN9t6XTNKHg9Dm4gN/uDPB4SUCPLcI7AGKCrq8H+kKblz7SSWeIKy0qgBJbLFpXjiWTYIwqEJiT5EDzwUQUwNQd9yJaqpNzsmNTz2eErOZkHxz9AayCTh+NfSl8L2GY27EGyWDEFK4nc11AKbrPm+o44yeFC4bQzvx3fBM9jjHCNaQPimKuDOayY+e3ioPgbwPABWj+xi3fwX14AZAViKDfXrAuZJA7FEFwVNsDcV237KV6f3AuDLqMYTArZRtZhGNS5M96wSlL69PivGTP0WFcDR6auhBROPumv0X4yKvlGAIrf+IYpifcTKbw8RAkbKpHT64GTqHOq+4/VViZghqG8NvovbiILzfnj2IvAIqIWunlz/waunCDYBeOatclXgEEIIWHyHo/rr50qaTsxllRnxn5IADC8b25M5h3YP2zN0CANsvlJ1T6elku/yjpCGjfTM7yfrei+b3ZtJ29rlCq3WiRL8NeIx73M45/nniGLv428GeFCWXduplHBMftkW04CYAZxGonTvxP50rn2pdjjyavgq4hWXSwA6zRKp2NpWuNWeby/nB
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
 fs/binfmt_elf.c          | 49 +++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/elf.h |  1 +
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 264fba0d44bd..1fd7623cf9a5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -47,6 +47,7 @@
 #include <linux/dax.h>
 #include <linux/uaccess.h>
 #include <linux/rseq.h>
+#include <linux/sframe.h>
 #include <asm/param.h>
 #include <asm/page.h>
 
@@ -622,6 +623,21 @@ static inline int make_prot(u32 p_flags, struct arch_elf_state *arch_state,
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
@@ -632,7 +648,7 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 		unsigned long no_base, struct elf_phdr *interp_elf_phdata,
 		struct arch_elf_state *arch_state)
 {
-	struct elf_phdr *eppnt;
+	struct elf_phdr *eppnt, *sframe_phdr = NULL;
 	unsigned long load_addr = 0;
 	int load_addr_set = 0;
 	unsigned long error = ~0UL;
@@ -658,7 +674,8 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
 
 	eppnt = interp_elf_phdata;
 	for (i = 0; i < interp_elf_ex->e_phnum; i++, eppnt++) {
-		if (eppnt->p_type == PT_LOAD) {
+		switch (eppnt->p_type) {
+		case PT_LOAD: {
 			int elf_type = MAP_PRIVATE;
 			int elf_prot = make_prot(eppnt->p_flags, arch_state,
 						 true, true);
@@ -697,6 +714,20 @@ static unsigned long load_elf_interp(struct elfhdr *interp_elf_ex,
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
+			if (eppnt->p_flags & PF_X) {
+				elf_add_sframe(eppnt, sframe_phdr, load_addr);
+			}
 		}
 	}
 
@@ -821,7 +852,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	int first_pt_load = 1;
 	unsigned long error;
 	struct elf_phdr *elf_ppnt, *elf_phdata, *interp_elf_phdata = NULL;
-	struct elf_phdr *elf_property_phdata = NULL;
+	struct elf_phdr *elf_property_phdata = NULL, *sframe_phdr = NULL;
 	unsigned long elf_brk;
 	bool brk_moved = false;
 	int retval, i;
@@ -930,6 +961,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
 				executable_stack = EXSTACK_DISABLE_X;
 			break;
 
+		case PT_GNU_SFRAME:
+			sframe_phdr = elf_ppnt;
+			break;
+
 		case PT_LOPROC ... PT_HIPROC:
 			retval = arch_elf_pt_proc(elf_ex, elf_ppnt,
 						  bprm->file, false,
@@ -1227,6 +1262,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
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


