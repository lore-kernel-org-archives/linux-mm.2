Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40316CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56A08E000B; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8928E0002; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4698E000B; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7295F8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CBC148A2F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:13 +0000 (UTC)
X-FDA: 84026020386.09.3CD2ED1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7C27100004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WgnnFmJ0;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YKPYpomcoCqFtWDKOTpmsSVbm9H7+7084G/3DzubHw=;
	b=5jPuF7NgL6W3bmIEMBE4P4iZSznEil4+x0Xc6gmct1ncUBDajsgo8Zw4olkwgBYdhPiF+F
	Grc9ZUYHp9aMyzn2xEpRftlUV8b5E3pd5BGgzajzL0b/O8MTKK0izHcW3VVGcRiRe9SfqQ
	ZiRjNlkNFMs75xU9xtw1CwLDbQIHB5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144250; a=rsa-sha256;
	cv=none;
	b=IjUhUrf2ml1hINEkR7LCdBFERuhsGKPKgNGqh5eZ6lWJlUVhgJcTpqx8diPgaBHttX42jb
	/6ZKkEG4yuWIfmp2/UZtddvE66/JrXHQTp6xZBDvqNfq4ODxUFR5mN43R2pHKJF+vz1GrS
	Xo2kBjUuI3V3+5xrK9Z6Th45vJrkEks=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WgnnFmJ0;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8r4H3018327;
	Wed, 22 Oct 2025 14:43:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5YKPYpomcoCqFtWDK
	OTpmsSVbm9H7+7084G/3DzubHw=; b=WgnnFmJ0hIXwleBg0ttVitzfWuMID9+/K
	0qNuW8PibCoqjtUC6vSd1aNjX0WtKMEeRD7Y+mP9hXlZaT4KYZyoicNY7o65fqra
	gcAfgVkkPE0/Zn0RGLmPZ00rmOQW0O1JtX3FKedtP8+Dzj2ZxYdZ50AxNXMgzXBy
	HuHNcSXUb+S9oiCDNVfV2ve9gDdUlKWa1q8fTHC3AKL0zQE/WzSPqAjsvTyFvkSu
	/vnkLs5FJRbgMgb5K4zpsQYL9h42l8d3sXChp+oKqYQlu0M94y8H78bZtR3azeea
	6rgaBeTB4OShnxjToHFKJwHsZcmuIeghYKI47/0FDB/0ltjImXg/g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31cbxkt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:40 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEeH5E030200;
	Wed, 22 Oct 2025 14:43:39 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31cbxkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:39 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MBTkeA024940;
	Wed, 22 Oct 2025 14:43:38 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vpqk0smx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhYP120185728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:35 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C500B20040;
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D4F52004B;
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
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
Subject: [PATCH v11 14/15] unwind_user/sframe: Add .sframe validation option
Date: Wed, 22 Oct 2025 16:43:25 +0200
Message-ID: <20251022144326.4082059-15-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xeFtMe9OEVXt9N8nnQb6Ma0cnr2G3ZUk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXzWREkuO1kqzP
 FzcWHUQvmyblxg60n+vnI4PqsKv/CkbEGM/kGJsIc9vyZcF1Nnmxlez5yssVuii9JV74mrmTuZO
 cZssyjgD0ewxCA+1RrWSbNzHUp9Vn1CuuRNlzFyXe/D6oMhl1azDsE5JpR2LOoyiwW5T4Q39p6x
 sRuG8mSD8RlYkJc8QYzNETxP6GQ5jlNSP5Gx6jF8BfQGQLp/gDJAQrk3MSNGosx0srwha2/HKRJ
 6yemmBRaTH/59eheT4kxAnNG/7VjYp1gxGbuUChNZ5ArcWLIwzoX9TUgYqZ/zL0/dDUvSNCjjbf
 MNw2yqk5klr63pTifTfvcVQV+8sfUCy+HdGYuOQlFxWYIhoA1Hz6grJaHR4tW/6xMtG/TkmuexC
 zIVgX+cIstEel1goFvaGsPGt0ONUiQ==
X-Proofpoint-GUID: LyLw2LPZ7xao3i7Te8tZSv3AP1NfePyW
X-Authority-Analysis: v=2.4 cv=SKNPlevH c=1 sm=1 tr=0 ts=68f8ed9c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=RXKZOtKmAAAA:8 a=X__uKv6Ezr3YNgStCWAA:9
 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=wa9RWnbW_A1YIeRBVszw:22 a=2JgSa4NbpEOStq-L5dxp:22 a=UFF3uGjEBZWolfm0k6KQ:22
 a=DXsff8QfwkrTrK3sU8N1:22 a=poXaRoVlC6wW9_mwW8W4:22 a=p-dnK0njbqwfn1k4-x12:22
 a=7aar8cbMflRChVwg8ngv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Queue-Id: D7C27100004
X-Rspamd-Server: rspam02
X-Stat-Signature: e9jyi4o14azgnb4b3onnbwj1sxojrwed
X-HE-Tag: 1761144250-715356
X-HE-Meta: U2FsdGVkX1+guBHxL2YsJXsdHx3KLHbz1OjzhGQAId+mFAH05N+E7JuoYrwkmKYOMeTOi8G1pQknzc5gtW8ehavlT0jOWAeE81kgKsm08wOC7LWx8V5yh/lpzAPjqvu2RlMV58HeYgIDMq+0YJfHvXco70dP+Feko4KCv8bEfNzHJbGPWhJkhbc3gm96xbMIZidY/4jb9ATx6zKkK9l23R5SapGNXZq+bpL+E3wCa+e1SNwYru3/heG95DMHHc5/3pNBXqNc/LPdezb4ImfjbS+qaeJlZ9DITu7msijfWrL5I2lqyqirhzWkkMAKGDg/e+nVESezPhQebPGa0BUkeMvFamCD8o1vkfvCMi4qdqRUmnswoHt+uL+uRy/bVsxBOOVOrqrf+XdrX7VG6vwe/D0cjMI8jUINaJ4p2EqC2hW+hktEOkWZdRkA23pDRkr8dWoXKnnF/aVuvcWQR7j/4Vw+TeLjC4UA7KSQszruWwvr2fhUOoZKLdKAp+ex4NDVMxgSWvyTHH7NWK5zOdt9DN/GtDS6QkXeA43UcPaUYSV5BdJ8/d0PgX3XqlDbBkZbuoTB8a7wm6QGc8rXpRxnvPVX5thWBqM5LNhDhOzX7PtewXhtv1lIRkkK3SruMJveSrvUvougJYMOHm3hMm2UI/r6d9+Wir8w6LEsKobBjk0xYbytaXJwC/SGeXipQOSfdpFEIiBvqDsoiqTFUtD0pLvJVIS+ntojdWBjEwWz1rjxVr0KCjOUO76W3OqpFSOsg5glEftgMdO01suAaHY2koCEDUXh2+36owwTkCP7zCHsL63ll1RRNrozoHxyaE3VVCy0QpY4DAlxK3WI4ickpyueiols51bdxpaBQsafMlPoQL0sOMbYRyW9qWI/qfZoB/BKRImcRvzHAU12ni5SgmTedvKqM5p1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add a debug feature to validate all .sframe sections when first loading
the file rather than on demand.

[ Jens Remus: Add support for PC-relative FDE function start address. ]

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
    Changes in v11:
    - Support for SFrame V2 PC-relative FDE function start address. (Jens)

 arch/Kconfig           | 19 +++++++++
 kernel/unwind/sframe.c | 97 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 277b87af949f..918ebe3c5a85 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -455,6 +455,25 @@ config HAVE_UNWIND_USER_SFRAME
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
index 82eaf3c5d6b0..3d7ac4eaa8b7 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -339,6 +339,99 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	return ret;
 }
 
+#ifdef CONFIG_SFRAME_VALIDATION
+
+static int safe_read_fde(struct sframe_section *sec,
+			 unsigned int fde_num, struct sframe_fde *fde,
+			 unsigned long *fde_start_base)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fde(sec, fde_num, fde, fde_start_base);
+	user_read_access_end();
+	return ret;
+}
+
+static int safe_read_fre(struct sframe_section *sec,
+			 struct sframe_fde *fde, unsigned long fre_addr,
+			 struct sframe_fre *fre)
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
+		struct sframe_fre *fre, *prev_fre = NULL;
+		unsigned long ip, fde_start_base, fre_addr;
+		struct sframe_fde fde;
+		struct sframe_fre fres[2];
+		bool which = false;
+		unsigned int j;
+		int ret;
+
+		ret = safe_read_fde(sec, i, &fde, &fde_start_base);
+		if (ret)
+			return ret;
+
+		ip = fde_start_base + fde.start_addr;
+		if (ip <= prev_ip) {
+			dbg_sec("fde %u not sorted\n", i);
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
+				dbg_sec("fde %u: __read_fre(%u) failed\n", i, j);
+				dbg_sec("FDE: start_addr:0x%x func_size:0x%x fres_off:0x%x fres_num:%d info:%u rep_size:%u\n",
+					fde.start_addr, fde.func_size,
+					fde.fres_off, fde.fres_num,
+					fde.info, fde.rep_size);
+				return ret;
+			}
+
+			fre_addr += fre->size;
+
+			if (prev_fre && fre->ip_off <= prev_fre->ip_off) {
+				dbg_sec("fde %u: fre %u not sorted\n", i, j);
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
@@ -448,6 +541,10 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
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
2.48.1


