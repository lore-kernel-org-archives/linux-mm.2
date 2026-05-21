Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787A3CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A366B00A1; Thu, 21 May 2026 10:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01F16B00A2; Thu, 21 May 2026 10:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17E16B00A3; Thu, 21 May 2026 10:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A506B00A2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85CBE14066E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:20 +0000 (UTC)
X-FDA: 84791652120.23.1DC3485
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 39F3D180008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YtVgdokE;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373578; a=rsa-sha256;
	cv=none;
	b=QHMbF+vFNWm4MPmJgOWN3OlvFRFeN/H3u2v9+lDtKQAdyiD7WgOm0EVPfYwvKnysfTOBaG
	096yHAjeps/OPH7WWEWRLn8vdrMeAccO2RymkqaSBpBsA8KEMNZC1fyT7bzyznvBMfKEqE
	C4rhaASuaE5RGg1RfUCPyZgUtLI3Cy0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YtVgdokE;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlatXtmLcK/YWpio4LvTurctcguDyO2LElxStpBPkjI=;
	b=rFAEPfwtGGqzt3SQTaCXpfoqknHUe3l5PwZNxJrmdp/vEmtxCjAzNp69gM91wpIoz0Znb2
	dq4V93fKkbrP5Nq3YtnRKB4r2tl4FSyE3lU7sNDEn+q/4M35FFwmCmPR/G1qVaQovFSpxG
	3G7301GTAUvVJUCp0ndZElsoVZzrvdk=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L5YUGO220135;
	Thu, 21 May 2026 14:25:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dlatXtmLcK/YWpio4
	LvTurctcguDyO2LElxStpBPkjI=; b=YtVgdokErE214+LMLt8M9j4TDpgG5P1R0
	UJzMWT/nGjHdLIMDpeWlGYO2V9E+2Xm32CBGHiJjsN/hRTdOFN58BC8Sb44dWv+L
	0y+F+pg7US6Jr9rIohwA/TxC3wmcIHzDc7WlSPXbmFixWc65sVgwbwmoSjws67cm
	xRtcV6klyEyYlH1VYuQpxJ9a2Bf7ZMlX4Zx3JTI49ZGl3pqtVwlXFJ0sqho3F/e0
	uR0crHW+NtDeJTg0T8WOdTcpeZy7PRJMXeq79XFbc/7ygaj4nKnAznsOlR97OKV6
	zG1xuxVG5uWaOW/u4fAZXHlW+F7glUdEa/Y6IfRYlFx09iuwdTg/g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y7grj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:58 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO7Ao002174;
	Thu, 21 May 2026 14:25:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gmbhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPrUh47579558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9DCD20040;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82C452004E;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:53 +0000 (GMT)
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
Subject: [PATCH v16 12/20] unwind_user/sframe: Add .sframe validation option
Date: Thu, 21 May 2026 16:25:38 +0200
Message-ID: <20260521142546.3908498-13-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX75JMwD44D9po
 Tc2RJGNzA99v0U34GDmAJZcsfdGsiEbNz28O6pUZx4vtcRt6344OlxoXzCtSJ9bIZdlVgyDD4to
 c9rV6vBbT+cqsHTY9/vgTmryhGeZ0Vd1SdKqSPAdHX0AEvVaMzhO28w581fS771GtdaRlNd27FO
 xGr+hY2oMYn9ju5VMf7ZmYRI3XlQXUCFVe+9D5n+Vnj+9lgHV388nRVqs7uTo4UKLNnoYJXJs4a
 j6eoeP/s5u1U0AtLegph1nlAjjq9aFnNz+YHRuryRLw/VwF0SfRKdJpgiVUionX1uEjIMGkehvF
 D06F5G13u6UJ+LsvjBcpjcFwpTEPMx7ziYP602PI0+REPIYKeNflVrN8oysnXZUcv9Us0MJPbix
 zT7CBmXsz4Xi5oW/G+SZ7nvSPSEYg8PMNxAUdXIs6Dy2FnkjrFFxmI1lcjlI1VToOYIS36yqTb1
 KNYgYFDCotEXo+YPTWQ==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f15f7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=RXKZOtKmAAAA:8 a=iNKnMr3YqTL5pEm6fAYA:9
 a=2JgSa4NbpEOStq-L5dxp:22 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-ORIG-GUID: sacPi_ffize2HNJD9Ulb5EI3vTRjMch-
X-Proofpoint-GUID: 2kWA44K5Xjeos5_bgX_8kSIVrC6qCLZb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: 39F3D180008
X-Rspamd-Server: rspam03
X-Stat-Signature: qqjthm6ou86suw45qgpqew4h6tkyj7ds
X-HE-Tag: 1779373577-146507
X-HE-Meta: U2FsdGVkX1+lcBspr+fTAFsA2Og+nm42VdKhKSe8NypOm51yXAE3pn3AosqDpAH4qe2SqKxNgK1vf8hufGML1pJoOs6AtR1E5HeoLm6jeW47VG72rIpoqNw59Pb5i8WTX5iw+WLT88NH2RLoJmVDNECygz/NsDaUgtRe7P2QjUEiysad5H270mkz9qoFesFNBJO8Z/NYj6VFR/3s9zcAX8jNh8f0TRvb22LSCHCQiGdozyxZ6EKVn1l/R7aq2c30wFILCVZnGuO8QaLCceWMeTGOS2TQGM0R8sFicNdzXHHzt3ufwq+Of75fv0ukU1LKlfV/+UZER2XUGeFfFObhYZ+nfLff8qtkTk8IJnX9Ou5uTcteTY/Xrms/7yAnbtwwNA9J2CixPvU49danfRnSrkPNbJ+ZvscgBZqUs4v9+b9Jo5yIeITbhakyVN4BQdueiUkgtd0N89Aq4kBTeiNrxmxXSCX5An7wcDMPQuRLoohnnb2kyuk7SQ9JrdXEcVqTgStWB1M6KAIom8/9SnnLtx7YssFFqFEbfC+SrYoJTlIbTi3tSJxVzKFNDtqWWsJgvxAB7aw2jY4f3c1tPYQKd1cv/LMnAXVIjOKp+uUCaFSOxAXopWx+QmOCCqdiJCQ0CeOsyU2ZiY/0rsLZt2x0ngKja7icW1hcU2S29nvhCnn3mZbmFQpWc3f4noUeKCMCwkUkQ6SzOq6VjOWOwfO7jGb6kehOYtBO3hpmmdcoM3CaeCiwrWbFn2UWZ5U1ZKce6QyHM83DmGT9dr1rq/NmbVnzQCzCsgWZVY+cJ8SYDhPPJbM3jpPUgVB/6xzM/7D7M9k2rHQvpIhjNlCoB8lVB+loW64kzl4MfxGJLe4kCL0hNhJ/pumUem+UKWeGdl438IRsUpZl4GgixMuaVlCbmI1gv7/RR+M5nMf3kybvODVw0YDzgrOZBFH/cIhzfnYSJxNcRv7eXy5vDAVpyWg
 9rcqZ8Er
 C+uFzoF13MvaSet0pJQQ4DUPxcXlP0V8RuYOnyKYixrSumrpgPUeAlXxTCZjuZww/Fpesh7hNIs5qNfsvf/rHuKZd5fGQXp54C6knEbroHKd0xEia0FMAbHubrXAFeVgj4yo0zuaQpDBGCzJVarZSMpfUDGcgrJk6whPimIvHXLnx7Eur/jQx93FHV2CaTcm9OkESoAiwEDeO8tM3CxKTqQmijTy6J4LKBSfFsqxorMc6xB8wApeTBEdqWx/yqviWoJUpCv8UxvCC5EGu+YDwVHTNaLAw8iO8JZdprwQl/QmH8RslhRG+vxCwUr6DiDVmRoM2O6wJ3AqL1Uqltd0Ps4bc1xquPFQLZAbCE7ZZFvlpP+z3s3E5GA3zco8CAMtuyweolcssvgrpiHBlSfBXp880168zYHHgx5JVpLHGqglvH9Jr+uKyQMSowS4YEdpDPIklNe/VUelEq3EWUJN/F5YB0ymDuGZe0wILXrXcjHCHSCGw6m/WujM6zPCAjqT8GK6r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add a debug feature to validate all .sframe sections when first loading
the file rather than on demand.

[ Jens Remus: Add support for SFrame V3.  Add support for PC-relative
FDE function start offset.  Adjust to rename of struct sframe_fre to
sframe_fre_internal.  Use %#x/%#lx format specifiers. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v16:
    - sframe_validate_section(): Allow for a FDE[0] function start address
      of zero. (Sashiko AI)
    - sframe_validate_section(): Replace alternation between two FREs with
      simpler logic used for FDE and use a prev_ip_off.
    
    Changes in v15:
    - sframe_validate_section(): Fix format specifier for number of FREs
      in debug message. (Sashiko AI)
    - Normalize error code usage (.sframe is removed for all but ENOENT):
      ENOENT: No sframe or no FDE for IP found
              (FDE found but no FRE is EINVAL)
      EFAULT: Bad address
      EINVAL: Invalid input or sframe
    
    Changes in v14:
    - Add debug message if safe_read_fde() fails.
    - Update function names in debug messages.
    - Uppercase terms FDE and FRE in debug messages.
    
    Changes in v13:
    - Update to SFrame V3:
      - Print struct sframe_fde_internal fields fda_off and info2 in debug
        message.
    - Adjust to rename of struct sframe_fde_internal field func_start_addr
      to func_addr.
    - Use format strings "%#x" and "%#lx" instead of "0x%x" and "0x%lx".
    - Reword commit message (my changes).

 arch/Kconfig           | 19 +++++++++
 kernel/unwind/sframe.c | 92 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 111 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 37549832bd1f..132249d342a3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -490,6 +490,25 @@ config HAVE_UNWIND_USER_SFRAME
 	bool
 	select UNWIND_USER
 
+config SFRAME_VALIDATION
+	bool "Enable .sframe section debugging"
+	depends on HAVE_UNWIND_USER_SFRAME
+	depends on DYNAMIC_DEBUG
+	help
+	  When adding an .sframe section for a task, validate the entire
+	  section immediately rather than on demand.
+
+	  This is a debug feature which is helpful for rooting out .sframe
+	  section issues.  If the .sframe section is corrupt, it will fail to
+	  load immediately, with more information provided in dynamic printks.
+
+	  This has a significant page cache footprint due to its reading of the
+	  entire .sframe section for every loaded executable and shared
+	  library.  Also, it's done for all processes, even those which don't
+	  get stack traced by the kernel.  Not recommended for general use.
+
+	  If unsure, say N.
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 2cfa274cd8dc..e6d66ae8e7ac 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -384,6 +384,94 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	goto end;
 }
 
+#ifdef CONFIG_SFRAME_VALIDATION
+
+static int safe_read_fde(struct sframe_section *sec,
+			 unsigned int fde_num, struct sframe_fde_internal *fde)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fde(sec, fde_num, fde);
+	user_read_access_end();
+	return ret;
+}
+
+static int safe_read_fre(struct sframe_section *sec,
+			 struct sframe_fde_internal *fde,
+			 unsigned long fre_addr,
+			 struct sframe_fre_internal *fre)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fre(sec, fde, fre_addr, fre);
+	user_read_access_end();
+	return ret;
+}
+
+static int sframe_validate_section(struct sframe_section *sec)
+{
+	struct sframe_fde_internal fde;
+	unsigned long prev_func_addr;
+	unsigned int i;
+
+	for (i = 0; i < sec->num_fdes; i++) {
+		struct sframe_fre_internal fre;
+		unsigned long fre_addr;
+		u32 prev_ip_off;
+		unsigned int j;
+		int ret;
+
+		ret = safe_read_fde(sec, i, &fde);
+		if (ret) {
+			dbg_sec("safe_read_fde(%u) failed\n", i);
+			return ret;
+		}
+
+		if (i && fde.func_addr <= prev_func_addr) {
+			dbg_sec("FDE %u not sorted\n", i);
+			return -EINVAL;
+		}
+		prev_func_addr = fde.func_addr;
+
+		fre_addr = sec->fres_start + fde.fres_off;
+		for (j = 0; j < fde.fres_num; j++) {
+			ret = safe_read_fre(sec, &fde, fre_addr, &fre);
+			if (ret) {
+				dbg_sec("FDE %u: safe_read_fre(%u) failed\n", i, j);
+				dbg_sec("FDE: func_addr:%#lx func_size:%#x fda_off:%#x fres_off:%#x fres_num:%u info:%u info2:%u rep_size:%u\n",
+					fde.func_addr, fde.func_size,
+					fde.fda_off,
+					fde.fres_off, fde.fres_num,
+					fde.info, fde.info2,
+					fde.rep_size);
+				return ret;
+			}
+
+			if (j && fre.ip_off <= prev_ip_off) {
+				dbg_sec("FDE %u: FRE %u not sorted\n", i, j);
+				return -EINVAL;
+			}
+			prev_ip_off = fre.ip_off;
+
+			fre_addr += fre.size;
+		}
+	}
+
+	return 0;
+}
+
+#else /*  !CONFIG_SFRAME_VALIDATION */
+
+static int sframe_validate_section(struct sframe_section *sec) { return 0; }
+
+#endif /* !CONFIG_SFRAME_VALIDATION */
+
 static void free_section(struct sframe_section *sec)
 {
 	dbg_free(sec);
@@ -502,6 +590,10 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		goto err_free;
 	}
 
+	ret = sframe_validate_section(sec);
+	if (ret)
+		goto err_free;
+
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end - 1,
 				 sec, GFP_KERNEL_ACCOUNT);
 	if (ret) {
-- 
2.51.0


