Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE74CD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDAC6B0093; Tue,  5 May 2026 08:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3766F6B0095; Tue,  5 May 2026 08:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA606B0099; Tue,  5 May 2026 08:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED0836B0093
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B95361C03C9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:13 +0000 (UTC)
X-FDA: 84733268466.13.102405B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6AC0820014
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RhIrlItx;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0qo6Cq/QqoAOgdkngBJ9m2aLKOfy7KyVNjR2/kvaw74=;
	b=ooPGS9QBmUVdBvC8FHhqaeeto4IWAyA+1JA/YqxrryRL9A1znq8kfDlRRHD5gaTVKLF8Fx
	O4gPz0SpdQ2ypF5E1SB9fKDHJgO/zuaYpwyS+dGcMgK6PRUydkySwpRrJuwLI0ADgvz5hB
	OlXgE6iEfkJN9dnfKBTgGm428Z2tyJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983491; a=rsa-sha256;
	cv=none;
	b=VnB/SwalKGEnK3zw6s6tqZlWnV9riiVR/xjdXaFTqS9Ka4O663bmD09ZQJn1J2ESfTjGF9
	hIIdRwYcgPMCUDk/F633cUhJqw4ediVtt2LtArUcHlkhWRBdJvmFiEHfuy2rcKfeW2D5Qp
	kl/9PYhBNxFw6gfgJP2HeOgVWElMtvE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RhIrlItx;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6456sTaI3267730;
	Tue, 5 May 2026 12:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0qo6Cq/QqoAOgdkng
	BJ9m2aLKOfy7KyVNjR2/kvaw74=; b=RhIrlItxalXC6ZalJ4S8iHvI86P2pY1U9
	PhzfVDdfG36dv6TC8deEwExYmYnVazWesLLLKbGVA8d0UVAw47EUbLEZF6U6gqFo
	9UiP+9H6T2q1oYYVPyq37qb8xC/suYl6tvzkxRRaxhyO9J4aM14pXv2+JZyRe4YC
	KiIeDTuvxoZhAZFO78G9EldtRetD0VQrCisRN919nSBhsaJ+R6jxqN7LWn3+Ubq7
	uvNFhB/JJImgijbQoLwzd1E8Kd6UiVfkaGeUPQAwPfw9MXwxyJbvo6qBsKx3B3qc
	/eFut5CSbKsUKupJS8DqQAWSrdw/xsSsWx4l988LmhwnQ0+pu5hmw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxk5df-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:31 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9dZg024356;
	Tue, 5 May 2026 12:17:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3h1eqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHQYi49217992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7879F2004D;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1895A2004E;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
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
Subject: [PATCH v14 12/19] unwind_user/sframe: Add .sframe validation option
Date: Tue,  5 May 2026 14:17:11 +0200
Message-ID: <20260505121718.3572346-13-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX0n8bhYrUt/Wd
 v2k47IzZtbc5qAluNlkTei2+tmJQX4WrLUBPyE7Br7LGgf5QX+jTi9rrsN5f/Q1/ZgQHbwyA2rv
 E6HedSEeBj9KaOqlor93Qj1FRlVL1/CRLe4JkTJRm5+T0Qb66i/GrByKBtdkh3B6XNHVImQDlmQ
 q+XIBOV0n/1SVBcPf0l4+puk3fGCJyxhK2OJWrWP4GIczG8LtjE9NHLF/SXFQEFX6un9E9okQj1
 P4uIQrhUIqOB/ROlhr6+aLkq7z9/7+0lADy62XSNtnVwiqxfebWWCBHwY1pdIf9AOEMoi4v5ug2
 OQwZh+JMNp3/Z4LnykbeBz+39Erg3meV1oV33SeNd0Nv80xvsWRULQ80A2Anz3h28mN964yzZiH
 TwD0ZvaNa17YG79CttDkAZ25G3pKs5PVikifHL/vbnPCvj0VEZiENWdMqZYGdZTNSNhD5Pl9o/K
 RlXc7WPNusKw1oOc3Wg==
X-Proofpoint-ORIG-GUID: SseGS5jIfVdN1j1a36Pn4T9SB34tECVI
X-Proofpoint-GUID: 10ODE_W-5MYBr1AE7GtK2kI3nZ5f5n-J
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f9dfdb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=RXKZOtKmAAAA:8 a=X__uKv6Ezr3YNgStCWAA:9
 a=2JgSa4NbpEOStq-L5dxp:22 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050114
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6AC0820014
X-Stat-Signature: qiknisftzidu8xceywyi4d4drqeursp8
X-Rspam-User: 
X-HE-Tag: 1777983491-723736
X-HE-Meta: U2FsdGVkX185I9OfQVLR+jOKp8e2/b78lIvBNGZvjyVwQUKdJt3PXiXJVlEPkX6rKmgoYlErfgynVyi3ZOslnnaSuWbqToeuF3mT606xBcY7UXJ0gW3UTMGUSQuW68NwqCpzwC58BvucfII7cUpklS5jngUKDIg34Q/decsTB2pwjNCliZQDmFvaO9+EnI8I4pQOY9jNvCCnFchcOxyQbcGVSsrm9tu4sV81wLyTjfuO12SzrCRvGoIae07R2k2zn2z2M7O/N/Bde2rvviBjb0/chbB3ehBAyXWv7P1VzvhxVzxI64CN8GysZWKwq5X40z2MZldeQ9oaq+Ri5Me/9k2/4tKavi32dK3rYSkutJFlNgsGQAmCDVaMKy7pmpDqIW2+6l9q0dZqYj6zc9lbr64FVciWfmPr78s3Ul8Ea3LJylghES1KFTt9Qk3adDDZALhYZvIJTeh1YDeBMZafz3UGkBNgnmjlZrw7+OS9GF6/NvFDdlH6VGbV972FDsFXNdSy0fiuWo8Bus3qAwpsrIjlkNPIyIeRpQ2pq7WZQe9UJUSznQ0lCuwARZUxJkqNFunsNmegmruB+wb8KpKFdo9zYEoBkPFizk0COsH5ZmSerHCx/FHzLxpqnbn5g2uveGVfyNPlsh1TX2NXzb6Z5+D1bZhQ7EQ0s1cj9usCAxCuWX3VgUFzbDFiUhX7PH8agE3oZ50dfqo+6X1zEEMXsIdvuXqX2iMpgdFzvMsgrg+QElkLgQWCTF5hqfKTwOnXInvuXdFHv+bOKHifD4t/pK5qTClB+HMcjYtDqKbPsTuKogwEGKQPJTA5nMPwo0hk/wlputhnkkmXKU/ecxHWuDgA4wuiKvsweCgp8Vr/yugJarwJnulnH4brVESQBl+wRnBaGqCs23xZrHCfxc/5Gcr/acvmPspK+jI9waAlczECxIyp8D/CJCeQlZHg53yKhepUex5mM4zKr3Lo6Eg
 N0D/c2DA
 DReanc4nbES2ywovyG/9BTjLeMNybRV2eZQUjyY8IE/tnOH62vfI3iniXHqHNL6Uw6b2HT5hJff5273lVuETENBL1k6bmGUHeYr9WfwrNoRO3etbfC7dm+A5UX23Dg12UeOSwuNocDduA5Akhu3ogv9C64ctHsSsXBx4FR0XnzdUn/agmV1LLVoromagK03zyPOlUSMK3EigBMuuhhByvnTFYvxKR+8hElRZ4B1NLtVICe31xVYh6G6EQHwf88f9bmWTU90Dzki31a9kxxC0Uz1whkz7GSr4Jy0NSRwRa4BXCUVsdKlybkbCQ4dafQaL10O7ThJvSV0B/y8aXJAafw3nM9JhxODkxXJFqiQoTKWd++wcrinU6nRseXeWamxlFWHzvqZ/wbJcPqIFWxbwNUkpNdQm1TnV46oQI
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

 arch/Kconfig           |  19 ++++++++
 kernel/unwind/sframe.c | 101 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)

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
index 4419626f0173..45988cdc5c37 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -367,6 +367,103 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	return ret;
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
+	unsigned long prev_ip = 0;
+	unsigned int i;
+
+	for (i = 0; i < sec->num_fdes; i++) {
+		struct sframe_fre_internal *fre, *prev_fre = NULL;
+		unsigned long ip, fre_addr;
+		struct sframe_fde_internal fde;
+		struct sframe_fre_internal fres[2];
+		bool which = false;
+		unsigned int j;
+		int ret;
+
+		ret = safe_read_fde(sec, i, &fde);
+		if (ret) {
+			dbg_sec("safe_read_fde(%u) failed\n", i);
+			return ret;
+		}
+
+		ip = fde.func_addr;
+		if (ip <= prev_ip) {
+			dbg_sec("FDE %u not sorted\n", i);
+			return -EFAULT;
+		}
+		prev_ip = ip;
+
+		fre_addr = sec->fres_start + fde.fres_off;
+		for (j = 0; j < fde.fres_num; j++) {
+			int ret;
+
+			fre = which ? fres : fres + 1;
+			which = !which;
+
+			ret = safe_read_fre(sec, &fde, fre_addr, fre);
+			if (ret) {
+				dbg_sec("FDE %u: safe_read_fre(%u) failed\n", i, j);
+				dbg_sec("FDE: func_addr:%#lx func_size:%#x fda_off:%#x fres_off:%#x fres_num:%d info:%u info2:%u rep_size:%u\n",
+					fde.func_addr, fde.func_size,
+					fde.fda_off,
+					fde.fres_off, fde.fres_num,
+					fde.info, fde.info2,
+					fde.rep_size);
+				return ret;
+			}
+
+			fre_addr += fre->size;
+
+			if (prev_fre && fre->ip_off <= prev_fre->ip_off) {
+				dbg_sec("FDE %u: FRE %u not sorted\n", i, j);
+				return -EFAULT;
+			}
+
+			prev_fre = fre;
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
+
 static void free_section(struct sframe_section *sec)
 {
 	dbg_free(sec);
@@ -476,6 +573,10 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		goto err_free;
 	}
 
+	ret = sframe_validate_section(sec);
+	if (ret)
+		goto err_free;
+
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
 	if (ret) {
 		dbg_sec("mtree_insert_range failed: text=%lx-%lx\n",
-- 
2.51.0


