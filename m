Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEBDCF2591
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F231E6B00B9; Wed, 19 Nov 2025 08:24:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E850F6B00BA; Wed, 19 Nov 2025 08:24:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D264A6B00BB; Wed, 19 Nov 2025 08:24:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB9B36B00B9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 799B14E19F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:45 +0000 (UTC)
X-FDA: 84127426530.30.A4611EF
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3481780012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=l7R6W6WX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558683; a=rsa-sha256;
	cv=none;
	b=5hIW0d0HxrCX+BH80mQQUMKX4bPNM1x4x4i/6rovnO8Ekg3hT7XwGqqTJABYWkjPDNWy8R
	4nQF7XFwZjrUBggdNrOdq+cq0xdM+WhZ3BDhmXLrbpCcobeOutG15HCfB/1AfzP3m2Vx3C
	Sc6GUP4wW5Xzgu2geLZ5+ub/OzTMFiA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=l7R6W6WX;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bii3nYHR4CIfvAfLZVxaR2VOAmLm0OhbOzDi7PLm/O0=;
	b=nnT+ZtowGyL/h3HbMaUC6hYr0bW2AzLOsAy1aTHe2Wx1oJvMRI+4s4dqI7fQKHYv3LUOlM
	6r3eUHL+lFs+Yn25RJY2pTZxK0UpjeBCCz7dxgWf74x3hEHGP38y/o/gsxU2g7WYrimAmE
	fQHSgwVqaQEwVQRr0QqDB3Hwz89BBSA=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ8KJEm030703;
	Wed, 19 Nov 2025 13:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Bii3nYHR4CIfvAfLZ
	VxaR2VOAmLm0OhbOzDi7PLm/O0=; b=l7R6W6WXduiC+CYZG9oy0QUvC+m2j7g4o
	YtmQDn000I0QlcdO6aLkA3SSSDsKgkDiKQ/gdnYNpzOhAlJ6J2FZWzn0ca0Um7pg
	H+YEVrAqSOYHQL7W2nJEDwwEbxLiA5JdWQZ93RaBv1h8bac8M3qqSN2NcaRTvw2H
	bi5Qb2gWPFJyvZADmGDzQgEF2RVNO9BK3i7CAqY7FE0hSsu+cGnhZRdUfbtmrQGK
	rbK81S1mCG90qUKogcdIIMrA0c09BQ1CKPGTgHB8x7zpq/EgrH6m0fIZjA2dOmS5
	wrTy4YCaN9mFGpeGS2JUPeUYwO24iPuVNiJJEqW0DPEMiJi4Pacmw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw8my2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:38 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDHjrX014737;
	Wed, 19 Nov 2025 13:23:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw8mxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJCeBjJ017318;
	Wed, 19 Nov 2025 13:23:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af6j1rhhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNWNT41288026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60CEA20040;
	Wed, 19 Nov 2025 13:23:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD8142004B;
	Wed, 19 Nov 2025 13:23:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:31 +0000 (GMT)
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
Subject: [PATCH v12 11/13] unwind_user/sframe: Show file name in debug output
Date: Wed, 19 Nov 2025 14:23:21 +0100
Message-ID: <20251119132323.1281768-12-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691dc4da cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=2qwYLugFhxTygNsS37kA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX5FZs+dNTPwLP
 NkO0aTZdIGmJCO6TVs7vhggyahV5XctY83lGGR8Ya2w004FMHVg3a17tKDlP1QBROjCkBjugRVF
 14VYZ+H5Z8/hYh3uORlXE/cyzKooKkktFg6WFCHNOXvKuYJfaV8qyZcPBbdrjfMAh9LFkW40064
 nPKt9FAr2yCTn8SA4lpw8w/5uAPrLlJuHaBH1MCKik7jH2471Pr3Gp7SBFLb5ETCbCgq+M9TCyG
 HGP0sy7kZaN9BNaxoRUdkwjgAXz+4F8QYfnYnZRa/xaGgzLCFdKLw6gUOKFZQVXRgWomB+RbYEJ
 N96g6day2GqoOuEub7Q6HzmLRexYgXS0ygt23ikQVu361G3ljVLbHZnrLo09N+QYVK/4n5UfFuJ
 R5ifPoPQjZwTXKhLbaRlZctSuJBFew==
X-Proofpoint-GUID: 8gqI0sHgCu6Q55bXAyXXwkSvwztS0KdN
X-Proofpoint-ORIG-GUID: TabUCD_iSfUfDxNiDl7gp8Wq1k2pynMV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3481780012
X-Stat-Signature: toeaz4qo91hioyzwrhgquifhzrcma4en
X-HE-Tag: 1763558682-791689
X-HE-Meta: U2FsdGVkX1+KsOgLt0l7HhWsXu+wo6orXDr/9iKUamjbyhQUpH5EVqZ1olUa5ZEahaC5KWWCcDKkoGgsC5UAZgH+Z2hgG0VBinEngdxMCzkNA4MFjQUHevwOPvoPKVDoE+8Y2X4NsZKlnX5gZo6rPXxwEJHqr5Iszb4F3aOwv9STBz1rATw3isifIygrVB/oJqnr1bNSogPnY79Up+KD80iQ+8TvrBajZ5sLiHC9ptzF+1Sx/PIREV/AEehr/NShMtk4sKc8V0uJwwZZ75OV2CBKJm2oTUEPph7bD5xILVmqw/KsmPXRAApICux0XEpNij3vGjGPgL/h0x++lrtftE41XZx4nOMAlagUj25c+UKzTIuRKGiGM8WBCuyDo9LAK8V4jPFpYLP04+eiXFPuyw7x8JOuNVZ+FzZcjq2Q4uiDkAI/TAMT5qDT1PdYdjU10Qe2ul/xeH/ScaFVXt/3zncWyTt5lSoIvuqMQ6fNR2PqRFjF9p4VWI/AkmdHQ9MASw18+/iOPkGrVbW78WgHYlTrMcg5jogsW8oIHO+ZA+HWEHXEaV5U73tEhLDdpNcrr0zQrCzg+yXEN0Puass2aWyquvlGl7QmPIhBBe/mp7Yavc/+6k1H20+qZqFivFOjx175B3eX+5uPWg6Q0uO/AFzqAGGSQft2hNAWUNA4i4PYwOmOKI9EtvUsaiLznEhsmH2tMy1RNabbUEWACi7fl/sxd7xdpgoiCgKWU2Xy/EPc9Cjp6MY/p9YfGj6Ik4pMkfawteaPDJncwRoAOC0wmznbW0fYsNTz7cTfbrU3+Q2X6ulE66CS2hdN5nP7mtMJBSYyhoP5z9w7NxXi9JpBD1eJJkYgssZVETZynSvSjj0J4T5lVvThpXy4tD6zxWV5wggI4NnvpHo3CSkQR1wtZf/i8JIv0nhyQCwsTMf9GjR/QB203ZA2wYF3dQGQd205/o/Ze5+S5kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
    - Fix checkpatch error "space prohibited before that close
      parenthesis ')'".

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
index 61340ee524c2..7d3e286c1b23 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -343,14 +343,17 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
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
 
@@ -361,7 +364,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	unsigned int num_fdes;
 
 	if (copy_from_user(&shdr, (void __user *)sec->sframe_start, sizeof(shdr))) {
-		dbg("header usercopy failed\n");
+		dbg_sec("header usercopy failed\n");
 		return -EFAULT;
 	}
 
@@ -370,18 +373,18 @@ static int sframe_read_header(struct sframe_section *sec)
 	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
 	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
 	    shdr.auxhdr_len) {
-		dbg("bad/unsupported sframe header\n");
+		dbg_sec("bad/unsupported sframe header\n");
 		return -EINVAL;
 	}
 
 	if (!shdr.num_fdes || !shdr.num_fres) {
-		dbg("no fde/fre entries\n");
+		dbg_sec("no fde/fre entries\n");
 		return -EINVAL;
 	}
 
 	header_end = sec->sframe_start + SFRAME_HEADER_SIZE(shdr);
 	if (header_end >= sec->sframe_end) {
-		dbg("header doesn't fit in section\n");
+		dbg_sec("header doesn't fit in section\n");
 		return -EINVAL;
 	}
 
@@ -393,7 +396,7 @@ static int sframe_read_header(struct sframe_section *sec)
 	fres_end   = fres_start + shdr.fre_len;
 
 	if (fres_start < fdes_end || fres_end > sec->sframe_end) {
-		dbg("inconsistent fde/fre offsets\n");
+		dbg_sec("inconsistent fde/fre offsets\n");
 		return -EINVAL;
 	}
 
@@ -449,6 +452,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 	sec->text_start		= text_start;
 	sec->text_end		= text_end;
 
+	dbg_init(sec);
+
 	ret = sframe_read_header(sec);
 	if (ret) {
 		dbg_print_header(sec);
@@ -457,8 +462,8 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
 	if (ret) {
-		dbg("mtree_insert_range failed: text=%lx-%lx\n",
-		    sec->text_start, sec->text_end);
+		dbg_sec("mtree_insert_range failed: text=%lx-%lx\n",
+			sec->text_start, sec->text_end);
 		goto err_free;
 	}
 
@@ -480,7 +485,7 @@ static int __sframe_remove_section(struct mm_struct *mm,
 				   struct sframe_section *sec)
 {
 	if (!mtree_erase(&mm->sframe_mt, sec->text_start)) {
-		dbg("mtree_erase failed: text=%lx\n", sec->text_start);
+		dbg_sec("mtree_erase failed: text=%lx\n", sec->text_start);
 		return -EINVAL;
 	}
 
diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
index 055c8c8fae24..cd3e95e3961f 100644
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
 
 	fdes_end = sec->fdes_start + (sec->num_fdes * sizeof(struct sframe_fde));
 
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
2.48.1


