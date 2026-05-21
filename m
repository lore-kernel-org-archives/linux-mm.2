Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BEACD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2946B009B; Thu, 21 May 2026 10:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2996B009D; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B866B009E; Thu, 21 May 2026 10:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABB4E6B009B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D5441405E6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:18 +0000 (UTC)
X-FDA: 84791652036.23.1D4319C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2AE141A0012
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fQhK+zSq;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5n7SZa1kCJjW4GKzWdX9Nc0n7Hf175be+HBk4Nr0Ko=;
	b=PR56OVhIY1MBQJg+ard5f9h4iReU2P1I77H3iGPYA2ba6PddxVyC4EYII3iOXBi3MIXunL
	eZYqDinCLe1dl9kxGKVYzc0aTWWFgoJYNSA+izqQbXFLKwk8rgHBmfjF1wpjUwQQEmvF16
	sisoaRoFx+LqKV1GGJe4Z0l2mX5YLo0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fQhK+zSq;
	spf=pass (imf19.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373576; a=rsa-sha256;
	cv=none;
	b=ZXUTppuALFa/fTn8qg2+5a6noAy+WOcFMRhSSy2fM6gTw98XRq0RFuSleEQu80cTTmNPrf
	VhwxLvDCL+jICccTf4h9u0YoFPWWTIk7Jz9QK3bgM7+B2B7gR4F1he4bCLtv3/7oM6NH5m
	wBFj11xwPd79d8kG2TuBlbJOaVcU6ME=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L6u7ST935604;
	Thu, 21 May 2026 14:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Q5n7SZa1kCJjW4GKz
	WdX9Nc0n7Hf175be+HBk4Nr0Ko=; b=fQhK+zSqJfj82Z9vnvUX3dObv0Uym+99H
	44pt5JTKxAWOvy5cX6kJZQrR0ZCZW++Mqo3MJGa4HIqAMy1M/d3lfSBTOFwEs6Uz
	A/JxysW1iQJjuuJkS3Q3HDlzJ+BVDThLZMgM20BVioi3WZsiZfvNOmX4lTPrhOVH
	3SXIkGQRX+0lYuTBS/d7xmkIVWyxBetdhUGg2FaBT4t9WPKGTL+dQF1GHzkXcD9P
	cAmV4zyb7J1N4NNiONAw+t9aVW8QXO2qkTfy141GRFE4oYAIfhlIG5Ygm6Qfzup5
	SP+nfXgs2UHKexmF0AQsKHeExE0NvWBVX58Bq5Zv0OTP9fEEwQtYg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88p6fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO56d027493;
	Thu, 21 May 2026 14:25:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w4pem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPoa027722136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5DC920040;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8119B20049;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
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
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v16 02/20] unwind_user/sframe: Add support for reading .sframe headers
Date: Thu, 21 May 2026 16:25:28 +0200
Message-ID: <20260521142546.3908498-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 9mX7Kvdhwp1YCbUfaxoGBJ4HGhkDKZBd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX0d6KUTcGxViw
 Y/BcyHGhc3iFCKPDbGVKSoaOWUK7P6FpDGNWtYh2p+/BOkNh2QmmApIdFUqfVpRsmMhfs3K2Ek4
 Qi0ANvPVIgGHR0BZ2TRHnS2EJLV8ORi0Rse4KmNPP5XCSsJmJw1P2QkgL7m8MyNsrDazOwjU4Kr
 iqjD4Fvr4FGYOpx+G3rfVg1qRZOPHfJ5lo2oSWTLfNfWrSOFMreoc6zigVJxi90tZnP4VowiT2O
 vt4xe+MfCQllgFrnO3qm1oOwGBdxzFwyQ+9zmPyTZUpTOeCll6HlqPV1PpvEUcuR1Suxvqze5E7
 DYErYnd3qNfnXNPoiXUdET94VJF2botCwh5SjL8bVPUF7ml57QBxrWrz+gK0+0mT++ZcGKB0k5z
 k4V+O9cyqj0KlYPBlqw/Vl0cHxay9taVTfILsGYmNVWVNJiG0PZrS1u1tt3k6OieAa6/rt+FxuF
 Mp8Rcl5xSnDsi/Ml2AQ==
X-Proofpoint-GUID: aeocA9vtgS32qEU2K3fTLFtrfy0TUdDa
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0f15f3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8 a=meVymXHHAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=n2P1YqxNjAFD8MGDs80A:9
 a=ul9cdbp4aOFLsgKbc677:22 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210142
X-Rspamd-Queue-Id: 2AE141A0012
X-Stat-Signature: ht5nreioe6phhtg9q9g8ftqg646oeic7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779373575-576493
X-HE-Meta: U2FsdGVkX19HJFHkFz78Xkh/A0hpz6Kx7EPTWvnwne8wGI1JS9MHueFDktGTn2Gh7/3uYMlycZMUrd33vX3QO177sGoKExSi6E7CfMz8iefELDQsaMWzPK6M+bAeiPeTwoTZh00UP6VZ1uLv84nmicmO46VWcL6+SNBaZJmlfsB9PQagbutIGjQ/q4bBGBfH6rqxzH6oA/R6aGLuambIwEAUiVxEaH+zbvd0DGGM220K6jiVahbPblMufFJkqw4mPTyniuK39CrR5alcI/mG+D3/OOZkMjI3hAO3/Nk+wzw+9XwY0bfOk4BEOiZRjRY8NeJWVOmLEtKEo4kStr2wwZQtHx9XBtvX4Ha2zXbU6/2NDr8/SMJwcQZsba3DusO1bCL1EbEpSzco8xzCLogBQDjKuYA0dj6GtDqzMib9c5b7pCthikce9FxYzt874yCiKhszbZKAF9hu1NpU4odewS8ITIzBtJfqXwmbAX/4O11gjoVIIDL/l1yoxnU3JeMn/qr8vaobUGkcAau/v5eglRxHwAHDEspYqVUvxGea+ACP1CmnZW7zOKA0DwLeBFKKBUbAviAxfr5tkZulT4Gn6wwWZ40PDhk6lpbDzluG38VMSVy0Wjvq0LmUbN8A6D3NgptbYLkbMk7cprLM1UbfoFImXyK7yACCZ6sp6KbQ5tdAm/em6wmMFjRzFsML/pThmKN045HLcIc3mte23rdaRv6ocm8Jv5RfPXmIFmSDZE4Tl7Urb7Hf0zDAilPfZCVh94tLbNoS7d5GRsMQJAiOybQnKOa1V+tSht3I8D3D4I9e6hdbqCRMs+5bUkhafcuFZp+xN/EKUZfPq/AU/+rftIrC70mKP9dKPUec+v1YEMSIDPrTwDtCRMRYRAwmRDiSdg3yZcKP4F58vVcWt3lCTX640OV1sWk32g/0PNXAAHRSxVjyLeyZwI+GS2A3VSuOtEuCPvgf7OOCCjggnsw
 4Tpp7G6T
 S2Nsq/VLsoYT0tfdx8d/vjJbutRGSq5RagYkzGNXz3nY0pMHJDC5NJ6z7pKTB511k7fILc9U1UgchHsQZEpKCPt8tmGQFeGNaArawWQkaE3g1l2oozjQOyfbIRTm2t1h49HXX/tE/go5YciOE48NatJZaRiBULeO0NRXBJF2pACZqN3GcMzpCe90qMOJ9Gt7Ii7qnZ/aVNEHou5XXmtsaWvgf4QaGb3Vt8k5+VsCzXEfrO8S/eqV6fmGKKUyxOqRi2HKBGh5uJQSj40ejRYCyWcG9hmz7jDo330/lvG4PDqtPdZqWYaRiRQndpsSTl7D+Ld23gXcRaEWMZrPKoKhbTchK8WyCgw4zU4QLGpAX7bfzf2DtYIEFuMXfeJb6eLKPCP6SvY4ceg5FkVXkoTkwZjt3mde/qk+EaVkJH4iuSrhBvkDEtcGimhSQXFGN5uEkWV3AOtBaNiiniFTq4HAdhaimJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

In preparation for unwinding user space stacks with sframe, add basic
sframe compile infrastructure and support for reading the .sframe
section header.

sframe_add_section() reads the header and unconditionally returns an
error, so it's not very useful yet.  A subsequent patch will improve
that.

Link: https://lore.kernel.org/all/f27e8463783febfa0dabb0432a3dd6be8ad98412.1737511963.git.jpoimboe@kernel.org/

[ Jens Remus: Add support for SFrame V3.  Add support for PC-relative
FDE function start offset.  Cleanup includes and indentation. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v15:
    - Improve text/sframe section start/end validation. (Sashiko AI)
    - Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL (see
      memory-allocation.rst, section "Get Free Page flags"). (Sashiko AI)
    
    Changes in v14:
    - Rename SFRAME_FDE_TYPE_REGULAR to SFRAME_FDE_TYPE_DEFAULT to match
      SFrame V3 specification. (Indu)
    - Correct SFRAME_V3_FDE_TYPE_MASK value.
    
    Changes in v13:
    - Update to SFrame V3:
      - Add and use SFRAME_VERSION_3 definition.
      - Add helper macros to access SFrame V3 FDE type.
      - Rename SFRAME_FUNC_*() macros to SFRAME_FDE_*().
      - Rename SFRAME_FDE_TYPE_PC* defines to SFRAME_FDE_PCTYPE_* and
        SFRAME_FUNC_FDE_TYPE() macro to SFRAME_V3_FDE_PCTYPE().
      - Reword OFFSET to DATAWORD in SFRAME_FRE_OFFSET_{COUNT|SIZE}()
        macros.
      - Rename version-specific SFRAME_*() macros to SFRAME_V3_*().
      - Update struct sframe_fde and rename to sframe_fde_v3:
        - Change field start_addr from s32 to s64 and rename to
          func_start_off.
        - Change field fres_num from u32 to u16.
        - New field u8 info2.
        - Remove u16 padding field.
      - Split FDE into function descriptor entry (struct sframe_fde_v3) and
        attributes (struct sframe_fde_v3).
      - Rename macro parameter "data" to "info" to hint at fde/fre info
        word and wrap it in parenthesis.
    - Group SFRAME_* definitions so that related ones are together.
    - Reword commit message (my changes).

 MAINTAINERS            |   1 +
 arch/Kconfig           |   3 +
 include/linux/sframe.h |  37 +++++++++++
 kernel/unwind/Makefile |   3 +-
 kernel/unwind/sframe.c | 136 +++++++++++++++++++++++++++++++++++++++++
 kernel/unwind/sframe.h |  81 ++++++++++++++++++++++++
 6 files changed, 260 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7434e9d7b33f..a9b42b67a88d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27876,6 +27876,7 @@ M:	Steven Rostedt <rostedt@goodmis.org>
 S:	Maintained
 F:	arch/*/include/asm/unwind_user.h
 F:	include/asm-generic/unwind_user.h
+F:	include/linux/sframe.h
 F:	include/linux/unwind*.h
 F:	kernel/unwind/
 
diff --git a/arch/Kconfig b/arch/Kconfig
index e86880045158..94b2d5e8e529 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -486,6 +486,9 @@ config HAVE_UNWIND_USER_FP
 	bool
 	select UNWIND_USER
 
+config HAVE_UNWIND_USER_SFRAME
+	bool
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/include/linux/sframe.h b/include/linux/sframe.h
new file mode 100644
index 000000000000..0642595534f9
--- /dev/null
+++ b/include/linux/sframe.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_SFRAME_H
+#define _LINUX_SFRAME_H
+
+#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
+
+struct sframe_section {
+	unsigned long	sframe_start;
+	unsigned long	sframe_end;
+	unsigned long	text_start;
+	unsigned long	text_end;
+
+	unsigned long	fdes_start;
+	unsigned long	fres_start;
+	unsigned long	fres_end;
+	unsigned int	num_fdes;
+
+	signed char	ra_off;
+	signed char	fp_off;
+};
+
+extern int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+			      unsigned long text_start, unsigned long text_end);
+extern int sframe_remove_section(unsigned long sframe_addr);
+
+#else /* !CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+static inline int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+				     unsigned long text_start, unsigned long text_end)
+{
+	return -ENOSYS;
+}
+static inline int sframe_remove_section(unsigned long sframe_addr) { return -ENOSYS; }
+
+#endif /* CONFIG_HAVE_UNWIND_USER_SFRAME */
+
+#endif /* _LINUX_SFRAME_H */
diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
index eae37bea54fd..146038165865 100644
--- a/kernel/unwind/Makefile
+++ b/kernel/unwind/Makefile
@@ -1 +1,2 @@
- obj-$(CONFIG_UNWIND_USER)	+= user.o deferred.o
+ obj-$(CONFIG_UNWIND_USER)		+= user.o deferred.o
+ obj-$(CONFIG_HAVE_UNWIND_USER_SFRAME)	+= sframe.o
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
new file mode 100644
index 000000000000..d24e9d4f8bef
--- /dev/null
+++ b/kernel/unwind/sframe.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Userspace sframe access functions
+ */
+
+#define pr_fmt(fmt)	"sframe: " fmt
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/srcu.h>
+#include <linux/uaccess.h>
+#include <linux/mm.h>
+#include <linux/string_helpers.h>
+#include <linux/sframe.h>
+#include <linux/unwind_user_types.h>
+
+#include "sframe.h"
+
+#define dbg(fmt, ...)							\
+	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
+
+static void free_section(struct sframe_section *sec)
+{
+	kfree(sec);
+}
+
+static int sframe_read_header(struct sframe_section *sec)
+{
+	unsigned long header_end, fdes_start, fdes_end, fres_start, fres_end;
+	struct sframe_header shdr;
+	unsigned int num_fdes;
+
+	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
+		dbg("header usercopy failed\n");
+		return -EFAULT;
+	}
+
+	if (shdr.preamble.magic != SFRAME_MAGIC ||
+	    shdr.preamble.version != SFRAME_VERSION_3 ||
+	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
+	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
+	    shdr.auxhdr_len) {
+		dbg("bad/unsupported sframe header\n");
+		return -EINVAL;
+	}
+
+	if (!shdr.num_fdes || !shdr.num_fres) {
+		dbg("no fde/fre entries\n");
+		return -EINVAL;
+	}
+
+	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
+	if (header_end >= sec->sframe_end) {
+		dbg("header doesn't fit in section\n");
+		return -EINVAL;
+	}
+
+	num_fdes   = shdr.num_fdes;
+	fdes_start = header_end + shdr.fdes_off;
+	fdes_end   = fdes_start + (num_fdes * sizeof(struct sframe_fde_v3));
+
+	fres_start = header_end + shdr.fres_off;
+	fres_end   = fres_start + shdr.fre_len;
+
+	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
+		dbg("inconsistent fde/fre offsets\n");
+		return -EINVAL;
+	}
+
+	sec->num_fdes		= num_fdes;
+	sec->fdes_start		= fdes_start;
+	sec->fres_start		= fres_start;
+	sec->fres_end		= fres_end;
+
+	sec->ra_off		= shdr.cfa_fixed_ra_offset;
+	sec->fp_off		= shdr.cfa_fixed_fp_offset;
+
+	return 0;
+}
+
+int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
+		       unsigned long text_start, unsigned long text_end)
+{
+	struct vm_area_struct *sframe_vma, *text_vma;
+	struct mm_struct *mm = current->mm;
+	struct sframe_section *sec;
+	int ret;
+
+	if (sframe_start >= sframe_end || text_start >= text_end) {
+		dbg("invalid sframe/text address\n");
+		return -EINVAL;
+	}
+
+	scoped_guard(mmap_read_lock, mm) {
+		sframe_vma = vma_lookup(mm, sframe_start);
+		if (!sframe_vma || sframe_end > sframe_vma->vm_end) {
+			dbg("bad sframe address (0x%lx - 0x%lx)\n",
+			    sframe_start, sframe_end);
+			return -EINVAL;
+		}
+
+		text_vma = vma_lookup(mm, text_start);
+		if (!text_vma ||
+		    !(text_vma->vm_flags & VM_EXEC) ||
+		    text_end > text_vma->vm_end) {
+			dbg("bad text address (0x%lx - 0x%lx)\n",
+			    text_start, text_end);
+			return -EINVAL;
+		}
+	}
+
+	sec = kzalloc(sizeof(*sec), GFP_KERNEL_ACCOUNT);
+	if (!sec)
+		return -ENOMEM;
+
+	sec->sframe_start	= sframe_start;
+	sec->sframe_end		= sframe_end;
+	sec->text_start		= text_start;
+	sec->text_end		= text_end;
+
+	ret = sframe_read_header(sec);
+	if (ret)
+		goto err_free;
+
+	/* TODO nowhere to store it yet - just free it and return an error */
+	ret = -ENOSYS;
+
+err_free:
+	free_section(sec);
+	return ret;
+}
+
+int sframe_remove_section(unsigned long sframe_start)
+{
+	return -ENOSYS;
+}
diff --git a/kernel/unwind/sframe.h b/kernel/unwind/sframe.h
new file mode 100644
index 000000000000..fc2908e92c7b
--- /dev/null
+++ b/kernel/unwind/sframe.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * From https://www.sourceware.org/binutils/docs/sframe-spec.html
+ */
+#ifndef _SFRAME_H
+#define _SFRAME_H
+
+#include <linux/types.h>
+
+#define SFRAME_VERSION_1			1
+#define SFRAME_VERSION_2			2
+#define SFRAME_VERSION_3			3
+#define SFRAME_MAGIC				0xdee2
+
+#define SFRAME_F_FDE_SORTED			0x1
+#define SFRAME_F_FRAME_POINTER			0x2
+#define SFRAME_F_FDE_FUNC_START_PCREL		0x4
+
+#define SFRAME_ABI_AARCH64_ENDIAN_BIG		1
+#define SFRAME_ABI_AARCH64_ENDIAN_LITTLE	2
+#define SFRAME_ABI_AMD64_ENDIAN_LITTLE		3
+
+struct sframe_preamble {
+	u16	magic;
+	u8	version;
+	u8	flags;
+} __packed;
+
+struct sframe_header {
+	struct sframe_preamble preamble;
+	u8	abi_arch;
+	s8	cfa_fixed_fp_offset;
+	s8	cfa_fixed_ra_offset;
+	u8	auxhdr_len;
+	u32	num_fdes;
+	u32	num_fres;
+	u32	fre_len;
+	u32	fdes_off;
+	u32	fres_off;
+} __packed;
+
+#define SFRAME_HEADER_SIZE(header) \
+	((sizeof(struct sframe_header) + (header).auxhdr_len))
+
+struct sframe_fde_v3 {
+	s64	func_start_off;
+	u32	func_size;
+	u32	fres_off;
+} __packed;
+
+struct sframe_fda_v3 {
+	u16	fres_num;
+	u8	info;
+	u8	info2;
+	u8	rep_size;
+} __packed;
+
+#define SFRAME_FDE_PCTYPE_INC			0
+#define SFRAME_FDE_PCTYPE_MASK			1
+
+#define SFRAME_AARCH64_PAUTH_KEY_A		0
+#define SFRAME_AARCH64_PAUTH_KEY_B		1
+
+#define SFRAME_V3_FDE_FRE_TYPE(info)		((info) & 0xf)
+#define SFRAME_V3_FDE_PCTYPE(info)		(((info) >> 4) & 0x1)
+#define SFRAME_V3_AARCH64_FDE_PAUTH_KEY(info)	(((info) >> 5) & 0x1)
+
+#define SFRAME_FDE_TYPE_DEFAULT			0
+
+#define SFRAME_V3_FDE_TYPE_MASK			0x1f
+#define SFRAME_V3_FDE_TYPE(info2)		((info2) & SFRAME_V3_FDE_TYPE_MASK)
+
+#define SFRAME_BASE_REG_FP			0
+#define SFRAME_BASE_REG_SP			1
+
+#define SFRAME_V3_FRE_CFA_BASE_REG_ID(info)		((info) & 0x1)
+#define SFRAME_V3_FRE_DATAWORD_COUNT(info)		(((info) >> 1) & 0xf)
+#define SFRAME_V3_FRE_DATAWORD_SIZE(info)		(((info) >> 5) & 0x3)
+#define SFRAME_V3_AARCH64_FRE_MANGLED_RA_P(info)	(((info) >> 7) & 0x1)
+
+#endif /* _SFRAME_H */
-- 
2.51.0


