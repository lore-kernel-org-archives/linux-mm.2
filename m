Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4539CD342F
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9516B0099; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572216B009B; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5496B009D; Tue,  5 May 2026 08:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 178116B0099
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD56B1204C5
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:15 +0000 (UTC)
X-FDA: 84733268550.20.A5ADB96
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9E1ADA000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kyp1OubG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rW6pODOLpmIW3dM1Bj/JMJas2e2YSTbOVAnzl9U3D0=;
	b=vOOivRMdsKFm14Abr7uSvCA0asMT+70y2XRuQ/oQ23ZY4InVT6al05GeoLRegxv6oZ8FMz
	yZUQLZ4FPucNub9umYucJTuTtj2Ps8V8vQDwQLTMMpHRKBhqOaIl2sxAuu146Qjmz/Jlcw
	Fj5YTsxxwBzqmtVXxTgW8VXPLJfkS90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983493; a=rsa-sha256;
	cv=none;
	b=BbulT9yYRsuVUu2glxRci+7B68FWNXgZOqbzKvRBxD8QGrbHPHk7lQIViImxZLCKOR3hyI
	RFMHGC83vhE8uaNySY7QIszaTI4WSRY5nL2+ykFnmvySh96kdOkFGKdpoIWL2qvZggMseU
	J3Q2auitEpqqYg0J68DYjeVbdZWVhyQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kyp1OubG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6456vErd3189768;
	Tue, 5 May 2026 12:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1rW6pODOLpmIW3dM1
	Bj/JMJas2e2YSTbOVAnzl9U3D0=; b=kyp1OubGgmq8yPgzuacnELa/FzlQiqpAM
	F2RLXOVKW1jTgdZEihdLaJKSWQEETxLQVXki82oqVkcvfX6781cVVJUaBR1ZPBkj
	N0PmFT/SjM4t+iU5KF2K9k1Yl5JUG16ATAPZWZJaX3GpmOqxMPF9N2t8+Ki1ESqq
	gLZxhxICDnmkobCkkB6iwnVbkY/Qc0o9ohUmAt2a5KSyHP8wQMovYRJWpL91XnCU
	s00+4oPNYy2HR3R7vJDW5fV70BhGNVSEZbQ0vS43agrHvvBkPvg7z0gFFHKwZ+cZ
	Y/ztn777I3IDf4NV/P289BnH+3+/FNibj1qiVHbWvTenJ7yUt2k+w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxk5dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9cRI029301;
	Tue, 5 May 2026 12:17:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwwtg9bmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHT6t34079162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:29 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EBAD2004B;
	Tue,  5 May 2026 12:17:29 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E92E2004F;
	Tue,  5 May 2026 12:17:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:29 +0000 (GMT)
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
Subject: [PATCH v14 19/19] unwind_user/sframe: Add prctl() interface for registering .sframe sections
Date: Tue,  5 May 2026 14:17:18 +0200
Message-ID: <20260505121718.3572346-20-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505121718.3572346-1-jremus@linux.ibm.com>
References: <20260505121718.3572346-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXzbsTop3bX66g
 LFiQGRpKphTx+FUh9jEV6F2mi58EPDFgxFbUXetud3vbgciG1RsLfGwS/gX5l4YJnKpa/c5nGFT
 WRjicReZwI0HzjFm/H5IUZOb1FDYHTbHp3nYRBkbrNIRcpkJZOh/opCakmyrv2zYFO4PdsKjJFb
 xIetshmi2Vh8hav4xj0vOZYl5LwjqTgq3pIQ30rRFC+1kWJa3QMZYUBpGjGAgTDyQStije4jWqR
 bRQOugZgIlwd4QegBoUr4hvNJNniIN/GhGykR40eS2Qf97iE9Trf/1incLwqCbRJnRrynURh+LJ
 9J953rqmcYJ4dG4TWsUApQtqnfCGv61Sh+QD9sJLmiRjrEtmC9fd6yopKZFYtHqgPwVuLFXBViP
 lhYzsBEhtmuL3bZX9SVHBUo/p4X3Pce7Vu5GUiJ5T1bfe4NCGflJ3aCqWqPEGiBOGcOrkNYX5pM
 dGoksnPkr6KLIKnBPTQ==
X-Proofpoint-ORIG-GUID: wsKsPePIPbR1Pf5sSmwvRTZBUPpHqZJm
X-Proofpoint-GUID: 1K7W285VYx8m3b0nv1DHxzyyYXFMAPBc
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f9dfde cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=1RKwvADtGVyjO38rMG4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050114
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E1ADA000D
X-Rspamd-Server: rspam04
X-Stat-Signature: jstpc9zh6pfffog8bpquy3daeub9kp8o
X-HE-Tag: 1777983493-525319
X-HE-Meta: U2FsdGVkX1+Oe2lc8bhE/5h5yTlD56sSRHF241HmJORNabmCVHPQiED84OTyktcfDJQW23cKKQGrilBqrO2JDQRwAsqdTBZKnxIRZxBI0bmxggCXdd3j7ZxlY3UtdP5/MkRv17Jx4H113ymzdIx3xKVy1zGHfFrD0p3qEe3knKEh4EcWmKze8jD6tkZC162UiOJQ3ssCV9WjLR+PsE+TjR2b5l/vLMWvItNP4wNy97E1dmmnzCdbeRxTP0UxGdeYcUciR2kc7Nw/vXbKU+qHBOCYYhrPjMpkE69r4z4sfWNcxDFZnA85iBfFsoogRYxQlfRdDsjFFzzZuc/LOzbvT5qMv0Mme9f8K1EsHFb6xMW4BlE+iV4AGxmsBD649Laf9OWaKGBjB0Cb1aPKjMYryDSeaYYS1gEy+vNEqR6nP4ccQUmqCSITt7vmni6E16pyUDDoCj8P9qmGHdQlF1uBRMFhF5x7+0V0jHZfrw5Dm6tNSBlXZ5ifTB74211g3BaoNhW4Eqaa7ZW1nDDYCTW1wIc8acEaNCIJlNVWLv3JxPmOv5qh4GnGTef1Fq9vK3Jycx2r7mQJmksA84piOcGf8BVVvREp5eQgL6lqUbiDIiw/eBiFQYqXzJOxbce7Kvl5y0W0gnSrNVkBhj9R1Er0hWMGnTziSCbBzT3iKCDQjGA8B86C8r+YQ83gkz8+W6xQsQaeB/QFXKr7fhh3Ne2cif/ne05M11AJDaE6PEBvHB74SI909ZsTAAtek4WvHhR1BXICcnGDRRg9N3i469tnqvVXMT//haXu4Gn8K+AdGIO40c1jlftefW8Egu58Y33ljV78lwSmNDAELT4IWqVVrbtiHj/i4LsgrcDpwx60jBXj8QcjWAo+2yndbuESaeJycktA0yBCz4P+dibEy6z1IPkWb06gHKO/J4lBWyavM3kTRUm+O/pjNlD/qeZrY3w/s1lO6BlTZ87xfc7ZSG7
 saY5nGF9
 9tUqp84mVgudNuNK2+imSanaAOsDQoUho78TiT+BqHqnqLtb6vWexy22AawzkavxWiW3fmc9K6fwN8g6ypJdaNSXeFEV1PiG+YNyq1UJNgr6wPBIfjMD0C6xTmMZlmUPl+1znp67OyLMaCiMTFi4CQD0IRm8afE5k2csNEC4offywdebctJsT30BxDwA5Ob57ad68rJc9sL1/sbHqDwY22PpVSKbviCd32+4dJoilwUdoDO0nw23JM+h6viTRaqWNRJnxlCwe7IbLWaqcZDsctXToLeOxkCDx9Fd9N+8mWhN3MpnUy1nkWZrmPpBRjisCTrxYKKDGWGESAoR+q+w+5tktgboQtMfG2u/j7kKCWvdMX6BLNTPrPB1B1ugAZmsoWJh0A+bLojaRUfuf7hiHm76/vUpjJ5Vto8PlJiblLY+6wS3DFJ/BUWuqoyOE4k5Q5aZ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

The kernel doesn't have direct visibility to the ELF contents of shared
libraries.  Add some prctl() interfaces which allow glibc to tell the
kernel where to find .sframe sections.

[
  This adds an interface for prctl() for testing loading of sframes for
  libraries. But this interface should really be a system call. This patch
  is for testing purposes only and should not be applied to mainline.
]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v14:
    - Bump PR_ADD_SFRAME and PR_REMOVE_SFRAME.

 include/uapi/linux/prctl.h | 6 +++++-
 kernel/sys.c               | 8 ++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index b6ec6f693719..0aa0ec971843 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -368,7 +368,7 @@ struct prctl_mm_map {
  * configuration.  All bits may be locked via this call, including
  * undefined bits.
  */
-#define PR_LOCK_SHADOW_STACK_STATUS      76
+#define PR_LOCK_SHADOW_STACK_STATUS	76
 
 /*
  * Controls the mode of timer_create() for CRIU restore operations.
@@ -416,4 +416,8 @@ struct prctl_mm_map {
 # define PR_CFI_DISABLE		_BITUL(1)
 # define PR_CFI_LOCK		_BITUL(2)
 
+/* SFRAME management */
+#define PR_ADD_SFRAME			82
+#define PR_REMOVE_SFRAME		83
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 62e842055cc9..6e81e82bc991 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -65,6 +65,7 @@
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
 #include <linux/cred.h>
+#include <linux/sframe.h>
 
 #include <linux/nospec.h>
 
@@ -2906,6 +2907,13 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			break;
 		if (arg3 & PR_CFI_LOCK && !(arg3 & PR_CFI_DISABLE))
 			error = arch_prctl_lock_branch_landing_pad_state(me);
+	case PR_ADD_SFRAME:
+		error = sframe_add_section(arg2, arg3, arg4, arg5);
+		break;
+	case PR_REMOVE_SFRAME:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = sframe_remove_section(arg2);
 		break;
 	default:
 		trace_task_prctl_unknown(option, arg2, arg3, arg4, arg5);
-- 
2.51.0


