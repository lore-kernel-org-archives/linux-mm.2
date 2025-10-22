Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD56CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B258E000F; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A378E000D; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE5308E000F; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BAEC8E000E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C4EABBB64
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:14 +0000 (UTC)
X-FDA: 84026020428.29.ED09436
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC79340009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CCeT+hGJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144252; a=rsa-sha256;
	cv=none;
	b=g3yTGBvPbS15aqb8+ccLLIXTGNtsAaWdNw/2UOX7jkQrTtkz667icbXlY5Bn3wbVD6Mwal
	k1Srrf5+PKib8cqgpv7Fy/PFbBCJ9rPVKH+8HkjSIdi9UddFOlG5U914wk2JhRPeSH9wEV
	Z7uuJqDq8PKIAxYBSZN7+xYIM1/2/8Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CCeT+hGJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/lt/fdSztGs9CzhO0ADut9nIa/5/tzFiPI0zEfiuzw=;
	b=YQftk6MPGqBMiGVWAfhOTdAIQUCvG50EzfITAtkVkxqefY/kqhI0KrGqX9ZKuGaAG0qggn
	1h5sn3ICLAUhDOe4QQ84TK+AALlunqyS2J6Qr4GDqeEQ8bk5adDDV5KP3pviAatFjra1qC
	yEpRNSuuJWv2M/LiHMjtvcTazy7+ugs=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M7lJIT014602;
	Wed, 22 Oct 2025 14:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Z/lt/fdSztGs9CzhO
	0ADut9nIa/5/tzFiPI0zEfiuzw=; b=CCeT+hGJ1U7kkf3w8AfdeUHApJDddFXbg
	e40Gj3ze2MOM2JJaqrmWrWorK81PhPI4UitzIu4CphoIIlKK5lJiGYFzsq7JE5i0
	wjnZbid32SM9g8Ka5FfLOPtjMvZZN7E36uoH+OXxt8UMhckgBPz849Gs1U1Jf4xp
	wShWNREPRqQZSeCwSl9dNl2Z2DPq8bn6RuVYayAGoYZKbvZOg7SJKTRGCEi2mgfK
	FcTXffMtlf4LW6lE3bSt4VtI1XdvHYZUXtlMiH033XJqc8ply2jX0a6Bvv5MPtf4
	jmcFxWfM538mpGkB+SzLZSABRpO5M9J7VCi2TP6z6/am311P+AY4w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s5aer-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:37 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEacIi012746;
	Wed, 22 Oct 2025 14:43:37 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31s5aem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MBa2ew002324;
	Wed, 22 Oct 2025 14:43:35 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqejgnrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhWiT6226200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 101CF20043;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C46B2004B;
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
Subject: [PATCH v11 08/15] unwind_user/sframe: Wire up unwind_user to sframe
Date: Wed, 22 Oct 2025 16:43:19 +0200
Message-ID: <20251022144326.4082059-9-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hT2qzmen98LSG-_MrR_dlDGv94phHIA8
X-Proofpoint-GUID: i2qQ7OWg0AFtrloNwHIBMnoC0O74RIEK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXxPzmLODWGUxy
 OpDpVqsxK7sFCj3+KUMkB7Zq7eemdJClmtuUx6uFW3M/eC5WsARfHnGRxBJia65Q91xlzxYsiss
 KLzjcpZbxmfRxLaIyB9uFJ5qHPdSnkhtdTFjP+uIFLaWqV6lrdJNAlORmhPIEUMjZaTTmKTuNUv
 6f6su26fantOOKw584ILNFfiTH7v/a0astZDCtVtM4++3+nEmFbFwBpCfe864Fcuw3/JNWbmDAu
 XICbWZIZkGHDtAh+acVO4s5+0GvN19vUGqz732a44u4wwmtDZXTiRoFKlcuIjzDCYpgTU+gPr5Y
 4CdSXpdPNbsMnmlGgNC79ESU8DPWsXWhiLiT/e5bCRY/HXc1DHEOABI+0mt0PkzXkjLQFkOjimS
 D5BdrRIjc8p2DaOuCJxkILFCZFC7tg==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f8ed99 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=JQQRa4MxmZcFC8vMKkMA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC79340009
X-Stat-Signature: 54b5e5538dwrim7atmqz6chnmdigxqc5
X-HE-Tag: 1761144251-310216
X-HE-Meta: U2FsdGVkX189Sml00q2KqFh+IQ2BHvZAhX+Vry5n7rMtK6URmWMsHovymDF6HOU0ymV8mGBhGW2AO34rXRrWL83XJapMr9QPAYAq5dwDjz1QyVotJ0kRWQBSo6fn3J4wu/t88ktR+2YtF8DOt2QD/kVQg9nBvD9nGko4lFlBkc4VxwcMsCCwgtwIYJHcdYK4bEvtFaNdeS6uhWv5wLvUiU/A+NX3WdraCRWyWBmVNXRcBOv6AVQCRdy9NbB7eVrcNSQNXbyzg2j8dCJL41NNi2TiDIzGKEt2V+dCmf/kL+aaGy4mo6ILwIam0fCrn7EAZndcgp+LLYIyR2oJCNTWJhDqI57/8NIKFgVYp4uOt1GuwbVqQGfrh69ezArb279p8O4p2Z2vByATNV4vD7R/Yy/TUk2XSEsDNMPb8L70KpTCxU7GYy3YWx3rHbLEGEDrfKO/Ruws/YHr1zpm93iWpyvlcmGorxWwi2v6ajE+BPZqZMwM8SS4b04ikTTYvynubEDUBOTLXoZtoayATiif8lE9cyYKLgr2TunGk6lGnx9SQ8KvDz8bu5WrQoW027rRxz0V5BYr5VWaeNv4tXXPU3nRB1LNO3SUN0MexerVykMnSztKZfOztd3dD46QQ/odi35Hsx3JvBLql6eRI58o8jOX4aa0XxTkTYY6zMJtzCgsCRTpCE2vE4muBl4xNTwztVlfA0+bWzi+fKtszZH0gZSrDO4kTOHb1G+TxXDzcbB037Wgab1AsGmCjVTDjheoPZJ9TeCmkyFgfkBFIoLSssbnbkIWTCbF+StpPMDsKzW/dO9YRddLXtqFdyC/ccUbs1cOt//L1Y5FfqZlahzVWtj1eeZd9sztHyB5AW+leXIBVuS1lG58bqkXSdt7/jMwllUeXwIERglrP6cgMzvPUrEY1F+m/4VWXJIlEHh84Aog2rPAmf+hj30rPM/xvHvdgPC8ssRi8feA+IERwU0
 P5dwVWDC
 hOYheSricPDe0yKAVIxF1IkzYMa7xeTN1+g7Uz1TRsuGiyAR4ZY6vSHexskHwErp8NobRTbZeaCuv5pqTQjvdIdUXLYL6ZFu2riyC4RpmporNrFIKKfWjdSB+lbZd0E74eB2nIsbnFZAEe+UjElK5GGkNZNb9YTvHvWxaum5gFIpSL0RKtLssR1dPStcQvMbixHeXlGDNPA0Vi2hZttYwaNLIPZXViomqMj1AJZjFFHVTy/37IfjyGw6v808GeVbsauaoPPntSd7TmNAvD6xNST9b66z8JCxpjr3dW8jlemhCXYy9Pb9NFTs16+wACW77FuqcKplj1yIHkPeWsmeoHHjWksHn62VfaT2cIvsE8aMIXedvZZwhoEAVDwS9/GNE/nNv3gLdURyVKNzjP6qN69VgGYZQ0r0B2pfCtZeorAvtT1AmepM1cKsaC5VcTq/AqoZ0B7Jf9UJHdrBGeUGlNikx6BaMYPXH1Qj5Q+c3o20Uvv5LtWMtYZigYVNJ/e7eKo/9GZ3mlGiw6pvl6gGT5GW+P//o89xQKTHzHq90CaTkkL131TZ8wvKFHPJcVBc3pYowSX5tnfBqGpXD/sydu5FU8NhZlNomC4A2fxJ6nc6A9S9hTB5FfVxK0ZWJ3tTRbN4g/74q0scz8MRPk/pyNOmGsJERU5hkME3L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Now that the sframe infrastructure is fully in place, make it work by
hooking it up to the unwind_user interface.

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
 arch/Kconfig                      |  1 +
 include/linux/unwind_user_types.h |  4 ++-
 kernel/unwind/user.c              | 41 +++++++++++++++++++++++++++----
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 69fcabf53088..277b87af949f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -453,6 +453,7 @@ config HAVE_UNWIND_USER_FP
 
 config HAVE_UNWIND_USER_SFRAME
 	bool
+	select UNWIND_USER
 
 config HAVE_PERF_REGS
 	bool
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 938f7e623332..ee0ce855e045 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -9,7 +9,8 @@
  * available.
  */
 enum unwind_user_type_bits {
-	UNWIND_USER_TYPE_FP_BIT =		0,
+	UNWIND_USER_TYPE_SFRAME_BIT =		0,
+	UNWIND_USER_TYPE_FP_BIT =		1,
 
 	NR_UNWIND_USER_TYPE_BITS,
 };
@@ -17,6 +18,7 @@ enum unwind_user_type_bits {
 enum unwind_user_type {
 	/* Type "none" for the start of stack walk iteration. */
 	UNWIND_USER_TYPE_NONE =			0,
+	UNWIND_USER_TYPE_SFRAME =		BIT(UNWIND_USER_TYPE_SFRAME_BIT),
 	UNWIND_USER_TYPE_FP =			BIT(UNWIND_USER_TYPE_FP_BIT),
 };
 
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 696004ee956a..f6c543cb255b 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -7,6 +7,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/unwind_user.h>
 #include <linux/uaccess.h>
+#include <linux/sframe.h>
 
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
@@ -26,12 +27,10 @@ get_user_word(unsigned long *word, unsigned long base, int off, unsigned int ws)
 	return get_user(*word, addr);
 }
 
-static int unwind_user_next_fp(struct unwind_user_state *state)
+static int unwind_user_next_common(struct unwind_user_state *state,
+				   const struct unwind_user_frame *frame,
+				   struct pt_regs *regs)
 {
-	const struct unwind_user_frame fp_frame = {
-		ARCH_INIT_USER_FP_FRAME(state->ws)
-	};
-	const struct unwind_user_frame *frame = &fp_frame;
 	unsigned long cfa, fp, ra;
 
 	if (frame->use_fp) {
@@ -67,6 +66,26 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 	return 0;
 }
 
+static int unwind_user_next_sframe(struct unwind_user_state *state)
+{
+	struct unwind_user_frame _frame, *frame;
+
+	/* sframe expects the frame to be local storage */
+	frame = &_frame;
+	if (sframe_find(state->ip, frame))
+		return -ENOENT;
+	return unwind_user_next_common(state, frame, task_pt_regs(current));
+}
+
+static int unwind_user_next_fp(struct unwind_user_state *state)
+{
+	const struct unwind_user_frame fp_frame = {
+		ARCH_INIT_USER_FP_FRAME(state->ws)
+	};
+
+	return unwind_user_next_common(state, &fp_frame, task_pt_regs(current));
+}
+
 static int unwind_user_next(struct unwind_user_state *state)
 {
 	unsigned long iter_mask = state->available_types;
@@ -80,6 +99,16 @@ static int unwind_user_next(struct unwind_user_state *state)
 
 		state->current_type = type;
 		switch (type) {
+		case UNWIND_USER_TYPE_SFRAME:
+			switch (unwind_user_next_sframe(state)) {
+			case 0:
+				return 0;
+			case -ENOENT:
+				continue;	/* Try next method. */
+			default:
+				state->done = true;
+			}
+			break;
 		case UNWIND_USER_TYPE_FP:
 			if (!unwind_user_next_fp(state))
 				return 0;
@@ -108,6 +137,8 @@ static int unwind_user_start(struct unwind_user_state *state)
 		return -EINVAL;
 	}
 
+	if (current_has_sframe())
+		state->available_types |= UNWIND_USER_TYPE_SFRAME;
 	if (IS_ENABLED(CONFIG_HAVE_UNWIND_USER_FP))
 		state->available_types |= UNWIND_USER_TYPE_FP;
 
-- 
2.48.1


