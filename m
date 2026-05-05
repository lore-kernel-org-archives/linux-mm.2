Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 216ADCD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D816B009F; Tue,  5 May 2026 08:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1055B6B00A2; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63986B00A0; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0A636B00A1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77565140489
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:16 +0000 (UTC)
X-FDA: 84733268592.12.05D116E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 35C5720011
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rDomqQ2a;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ap4R3Nrb3HGP7jBBkw2h44aTj83fiw6YNumkdQ+8Wn4=;
	b=ygXq/ie1AcD3IyJENYZ4Dueul90s6MYF02N1BQeAcRz8kwkOBBPY1TW4VXlLucz6uH+1TM
	jnCFD4Dl5iuqOB3at/2TlVoG4eKAKjEr5hJMt021Q4u5Vle8qPqVUjvD3QjA9oHXnzN3Dl
	Yk9oyXwm9lwIAE9//saGR9WZPa7RKpA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983494; a=rsa-sha256;
	cv=none;
	b=S3lkQI4CH2XYUDBx33Hr6dlxsm98e5GSnOi8G2w96e5/NrNtGx/MCiuXJ1YmKnktdTONcA
	Ud0+yHC8KkPyHMBW1UcEVvhN/HQOq/JTDIYrMfHVAGd8ciy4Hl3iNw/yTJFiQKvvPKwee5
	pE2+2mE6fJhCSdIg8lB2zq4z0cTEprc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rDomqQ2a;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6457qr752577247;
	Tue, 5 May 2026 12:17:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Ap4R3Nrb3HGP7jBBk
	w2h44aTj83fiw6YNumkdQ+8Wn4=; b=rDomqQ2aW2F5/pROfhBY74OdDg1ktM3rz
	KS4z2oqf6KkQxZVErlc84gn6cUQJyf35J6VEM+hYgFLk/IK+scUnhhmS30OUueUy
	qeGw4B4JdIyQh2xhq3H3qX1UuybhTzqzfzYu0N4fULTWGISvB0jsOjI/3LX1TMcU
	vZm99rr0tWTgWPjSUIV6ZgQOLuR4zDlmjd2Pq9PWotsZbKBiyAZSvzQsjp6El775
	H4fYi+tRgJ1qd7az7i3jnxFcItSNG1bVcTBJCVQAdOfJEpNC1s0Tq5GFbgzo4eL7
	Gq+2fpNt+qc2BSU6wQ/DBm+MriHc42SIh+6pfu/9Q/y9yex1M22ig==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y4k7da-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9exV028527;
	Tue, 5 May 2026 12:17:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyw1m3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHQ4c38338910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:26 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 136512004B;
	Tue,  5 May 2026 12:17:26 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DA022004D;
	Tue,  5 May 2026 12:17:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:25 +0000 (GMT)
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
Subject: [PATCH v14 11/19] unwind_user/sframe: Show file name in debug output
Date: Tue,  5 May 2026 14:17:10 +0200
Message-ID: <20260505121718.3572346-12-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX4GgQhG5eHyFU
 lPmBYNeOIzla9WMhZ9EHgLETmoIU1cOal0VdLRAKDFe8lW1N5EqqeUT80toSh0XUF1YwOdx8xD9
 q/yF9nK1Gqw9hAhimX9Ru5UpMhXLU7B+Jk0htDh4n5VBbYC2PRKyvkP+jGXaL0J1dz09+JwgwvN
 nmflUx0RxoEv2GfEASg1OanAGGcxAakNmDVzlxqLjP8HDBQP4DPnv4djoaDxxs0InG3lak7enIf
 SobeJGGaWn1kWbL+w0sjAMYhxMTyl+GKFZg+v8PmMhz4blZGhRYt3SwtV158Sw+2bqJY3nbrMwW
 4TSV6WEJG+w9YtrRYJS9KVNyHJvNIe8D7PJ7NmAbUMr85jn1z9zAj5ZCsN4jDtDsVeY5ThFLAqt
 obJjVu02oEBG79RuMOyuHcBefiNPMmNU5IiikOPA8jPnuYQiAzfjue7nxje5KU85/tjFcnstQVt
 uHunGn6PZZSlg4/T7Hg==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69f9dfdb cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=zNP608caSEEB7r2JvF0A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: 9v8pnJzrnbMWWnYp9-7dXnWNVOkpzn-s
X-Proofpoint-ORIG-GUID: pL154LcnXQ1O3B4PHlmZYcrV1mui3esL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 35C5720011
X-Stat-Signature: bdiqzij81jker1yebznfqwpc7q9gr17s
X-Rspam-User: 
X-HE-Tag: 1777983494-726750
X-HE-Meta: U2FsdGVkX19wuZ9t2Z+4dWycwkxHXOC7mFoa1St3JyUvcB3ZKfBESWA3n2MldPpAWMIIH058TRI+WO9Y1xkO7300LGGxnHZuT9pzG06G7NF4MccrGNgQLrvksHG1zF68yiB5WDB/Y38afO3azJLJPqQxlittyiiJgQj7E8DP7b34RJ8P7jzd3SLBWg/bmImIc+0H8W1WRy1XQ+bhmF3qeBz+lxyP8yoU/NT4SGYeuJOsvAZkGgTsw5TYR7dwFp9rkeN6Hk8FePxO+aEIIouT4zS86qlIppZtc0k4AYyzPDnvUDLmq3QxQXsdI94C5RVAz4MvGZbVG1yns8Jaa749p8HHNHDBqoWZPgbe7aJ8Jbue97iWlNCQ/gvaNXdl5qJRpaNK3sb1BLh17+jPqf5NSlwCBp9+VzlICz/1Ycahj5LIn0dXPlIAmtQXQVVvTo8x5uYee3UC0aiktfOVLJfC32EI8hV3t14hwN9ekt0E632YBa8CTQ3ZnO78qjrLAONURsD+zze031m7PyTMVdsuEDhOgxvlclCLyh2P0ci5MLU2jDdtuUmI3B3ky0cV1wc85u2muTr7yjfU59XbtaZnWxVIPavlSLMnElQbsQdU0s8jHRxSneOyM6Q8s+4gkIrjvTs9wfSiR37zazVFEEB99J4m5VwYiJbZ3rKWrTrS7zfZ5zx6PvbObkxpHa8oMCb7A9xZKo5SeWa8KknDtZDuLMXNyI58wDdIrTI3gTHl31XaajSTyRcXS53PL+o+Y5WO9PZ2EICvPaiwPf2+FMKMRoXVUtq610A5IE3wIvCl3bJr1fCJeajV4SYuva64Z6MhHt0ZdJL9iNLFKS92wBBDGm8FWL6Jj1fWpVcI0rUWQSsqBDPeF2TRZCRpKwFegBOFkkmW1gjG9c9eP5hPqFffujfP0SGvfH2zNk9zzJATtqHExKyQsX9mRREXFdNOBsYVtLZIS0gAscx2PkY0zy7
 wwzRhke8
 VqgQSyBMM2G9u/bpHtsfw+ihyaeUm7sIIIe6Sez//z46Zl+N2Nx2Da6thWIjC/437CxbJEye2DHp+eMpNztKzDHsZOy77ANnoACZ9R2SXpv87kpP8Pegiqp3/pUGUabZbKn1VYbObjRsEZYrLYiH5AxqyI/t90dgrWZ6gXye+yFydec3DVCNXOg3du9NoKRSGnnWz6nqXy78e0SDahJfoqd4DTtmCGrxnTFybe1fZtwQs4nQ5e50FF3ShbzzacpeUKTN8vyL7GcvWj6gGAOodNhKWI7ImVWh7H4tsvYc40Cxu8KLJB8FMStdjtDOph87NJruwmXNe0KXUY3aGQoEIKu27bLzubDE+deye5w8xdYlZOTyvh0WGmTNkCvpf93HYZfY6+jlEiIFzlKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

When debugging sframe issues, the error messages aren't all that helpful
without knowing what file a corresponding .sframe section belongs to.
Prefix debug output strings with the file name.

[ Jens Remus: Fix checkpatch error "space prohibited before that close
parenthesis ')'". ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v14:
    - Uppercase terms FDE and FRE in debug messages.

 include/linux/sframe.h       |  4 +++-
 kernel/unwind/sframe.c       | 23 ++++++++++--------
 kernel/unwind/sframe_debug.h | 45 +++++++++++++++++++++++++++++++-----
 3 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 9a72209696f9..b79c5ec09229 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -10,7 +10,9 @@
 
 struct sframe_section {
 	struct rcu_head	rcu;
-
+#ifdef CONFIG_DYNAMIC_DEBUG
+	const char	*filename;
+#endif
 	unsigned long	sframe_start;
 	unsigned long	sframe_end;
 	unsigned long	text_start;
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 8eed6a7d9625..4419626f0173 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -359,14 +359,17 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 end:
 	user_read_access_end();
 
-	if (ret == -EFAULT)
+	if (ret == -EFAULT) {
+		dbg_sec("removing bad .sframe section\n");
 		WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
+	}
 
 	return ret;
 }
 
 static void free_section(struct sframe_section *sec)
 {
+	dbg_free(sec);
 	kfree(sec);
 }
 
@@ -377,7 +380,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	unsigned int num_fdes;
 
 	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
-		dbg("header usercopy failed\n");
+		dbg_sec("header usercopy failed\n");
 		return -EFAULT;
 	}
 
@@ -386,18 +389,18 @@ static int sframe_read_header(struct sframe_section *sec)
 	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
 	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
 	    shdr.auxhdr_len) {
-		dbg("bad/unsupported sframe header\n");
+		dbg_sec("bad/unsupported sframe header\n");
 		return -EINVAL;
 	}
 
 	if (!shdr.num_fdes || !shdr.num_fres) {
-		dbg("no fde/fre entries\n");
+		dbg_sec("no FDE/FRE entries\n");
 		return -EINVAL;
 	}
 
 	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
 	if (header_end >= sec->sframe_end) {
-		dbg("header doesn't fit in section\n");
+		dbg_sec("header doesn't fit in section\n");
 		return -EINVAL;
 	}
 
@@ -409,7 +412,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	fres_end   = fres_start + shdr.fre_len;
 
 	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
-		dbg("inconsistent fde/fre offsets\n");
+		dbg_sec("inconsistent FDE/FRE offsets\n");
 		return -EINVAL;
 	}
 
@@ -465,6 +468,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	sec->text_start		= text_start;
 	sec->text_end		= text_end;
 
+	dbg_init(sec);
+
 	ret = sframe_read_header(sec);
 	if (ret) {
 		dbg_print_header(sec);
@@ -473,8 +478,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
 	if (ret) {
-		dbg("mtree_insert_range failed: text=%lx-%lx\n",
-		    sec->text_start, sec->text_end);
+		dbg_sec("mtree_insert_range failed: text=%lx-%lx\n",
+			sec->text_start, sec->text_end);
 		goto err_free;
 	}
 
@@ -496,7 +501,7 @@ static int __sframe_remove_section(struct mm_struct *mm,
 				   struct sframe_section *sec)
 {
 	if (!mtree_erase(&mm->sframe_mt, sec->text_start)) {
-		dbg("mtree_erase failed: text=%lx\n", sec->text_start);
+		dbg_sec("mtree_erase failed: text=%lx\n", sec->text_start);
 		return -EINVAL;
 	}
 
diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
index 36352124cde8..e568be4172b1 100644
--- a/kernel/unwind/sframe_debug.h
+++ b/kernel/unwind/sframe_debug.h
@@ -10,26 +10,59 @@
 #define dbg(fmt, ...)							\
 	pr_debug("%s (%d): " fmt, current->comm, current->pid, ##__VA_ARGS__)
 
+#define dbg_sec(fmt, ...)						\
+	dbg("%s: " fmt, sec->filename, ##__VA_ARGS__)
+
 static __always_inline void dbg_print_header(struct sframe_section *sec)
 {
 	unsigned long fdes_end;
 
 	fdes_end = sec->fdes_start + (sec->num_fdes * sizeof(struct sframe_fde_v3));
 
-	dbg("SEC: sframe:0x%lx-0x%lx text:0x%lx-0x%lx "
-	    "fdes:0x%lx-0x%lx fres:0x%lx-0x%lx "
-	    "ra_off:%d fp_off:%d\n",
-	    sec->sframe_start, sec->sframe_end, sec->text_start, sec->text_end,
-	    sec->fdes_start, fdes_end, sec->fres_start, sec->fres_end,
-	    sec->ra_off, sec->fp_off);
+	dbg_sec("SEC: sframe:0x%lx-0x%lx text:0x%lx-0x%lx "
+		"fdes:0x%lx-0x%lx fres:0x%lx-0x%lx "
+		"ra_off:%d fp_off:%d\n",
+		sec->sframe_start, sec->sframe_end, sec->text_start, sec->text_end,
+		sec->fdes_start, fdes_end, sec->fres_start, sec->fres_end,
+		sec->ra_off, sec->fp_off);
+}
+
+static inline void dbg_init(struct sframe_section *sec)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+
+	guard(mmap_read_lock)(mm);
+	vma = vma_lookup(mm, sec->sframe_start);
+	if (!vma)
+		sec->filename = kstrdup("(vma gone???)", GFP_KERNEL);
+	else if (vma->vm_file)
+		sec->filename = kstrdup_quotable_file(vma->vm_file, GFP_KERNEL);
+	else if (vma->vm_ops && vma->vm_ops->name)
+		sec->filename = kstrdup(vma->vm_ops->name(vma), GFP_KERNEL);
+	else if (arch_vma_name(vma))
+		sec->filename = kstrdup(arch_vma_name(vma), GFP_KERNEL);
+	else if (!vma->vm_mm)
+		sec->filename = kstrdup("(vdso)", GFP_KERNEL);
+	else
+		sec->filename = kstrdup("(anonymous)", GFP_KERNEL);
+}
+
+static inline void dbg_free(struct sframe_section *sec)
+{
+	kfree(sec->filename);
 }
 
 #else /* !CONFIG_DYNAMIC_DEBUG */
 
 #define dbg(args...)			no_printk(args)
+#define dbg_sec(args...)		no_printk(args)
 
 static inline void dbg_print_header(struct sframe_section *sec) {}
 
+static inline void dbg_init(struct sframe_section *sec) {}
+static inline void dbg_free(struct sframe_section *sec) {}
+
 #endif /* !CONFIG_DYNAMIC_DEBUG */
 
 #endif /* _SFRAME_DEBUG_H */
-- 
2.51.0


