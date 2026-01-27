Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62092D34088
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2B96B0089; Tue, 27 Jan 2026 10:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FCE6B008A; Tue, 27 Jan 2026 10:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754A16B008C; Tue, 27 Jan 2026 10:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63FBB6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:37:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 100078A98A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:37:02 +0000 (UTC)
X-FDA: 84378147084.10.E9ADF70
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E01EA000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:36:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Xtmeg+nA;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769528219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQf5zjual95361VzjJZ2yX2E8ulU1Ja6ZxON0rOjARw=;
	b=DNgGN4WxhnrPsiY/GHRHHbWW5kw0v6nzYrOUKzP6y7LGZhtbxN1SQM4JtXWGBGh2qa8R1b
	/UewGGD60Iil43gyooLzRXPkml0Wum2VAJXjfoUKzoY6GsBmBjhwfC3w6UO4Y7MDQ5XUk6
	MG3Wm6wSFSUUaJnnFgFoS/KYNJG/ySY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Xtmeg+nA;
	spf=pass (imf15.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769528219; a=rsa-sha256;
	cv=none;
	b=DIkhhy3RIbaYvc96lbeLXsZVZcX/ognHzy9W4SMroBDtAkx2Ak1dMOXvFgrfkwmwYBaM9A
	WMkL61TE/CD96gDFUUU/bhyyY2kIzrBvCjvsWi5VprgzPx5RxmRHa9H/zBsMwSXegABW/D
	rZZNNNEOtZQR/lxMIGuYea6xKCvEgvY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R6JtXm006097;
	Tue, 27 Jan 2026 15:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UQf5zjual95361Vzj
	JZ2yX2E8ulU1Ja6ZxON0rOjARw=; b=Xtmeg+nAYRHjQ1Xfj+y3MEKkGUiS+Qi0O
	f9t6V7Aujyb0/MqTcx6g0tT+QJGs1iS2GCcannRTFXZsyTZUOE0tz/+DwXSsIE6/
	PacJhc/c7fSgpDa9M7U/y81YmjbRvF4aOU6Mlj3GvsizCeZLN70n6RlHtIOBZ5U8
	LIB4GNXYtz6DJ3omZaRWri2kDNa0WHIeyAvGJeYUQ0erTTqC+IG482aC7eEyRcNl
	7iOWiM4SzL7is1/5z0VtZv64aDK3EtESaw2Bl/GivS+MQ38yeek30HDij/ZowHAt
	d8wBhSXK4dVsCuvNDf0+nAcBHEByYE3+83XA/pLIfcJoQNzA8CSbg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnk6x33f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:10 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF2LPK009243;
	Tue, 27 Jan 2026 15:06:09 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnk6x338-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RD5pGk006707;
	Tue, 27 Jan 2026 15:06:08 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw8sy96j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF64mF30605876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:04 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C0CE20040;
	Tue, 27 Jan 2026 15:06:04 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8E6520049;
	Tue, 27 Jan 2026 15:06:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:03 +0000 (GMT)
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
Subject: [PATCH v13 18/18] unwind_user/sframe: Add prctl() interface for registering .sframe sections
Date: Tue, 27 Jan 2026 16:05:53 +0100
Message-ID: <20260127150554.2760964-19-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CqQXPkR5vg5vxNfEPomESWqMvfjyY9jB
X-Proofpoint-ORIG-GUID: 4HvbmZdrXSQ5cQ-sg4CHqAxRj0cwUnvU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX0ZKYCIui2TY0
 Ptdf8Cbe5yR03Ee7564PgLuxdfDwLew4ryfy4vpQjHgkr3DZwwubVV3trwhzw4YcL2hTnQUhal+
 joRDcmjf+cjIHiZwe37tTM4qTICn88rO/XNCo06foZJjHHWXk7yr03EIX3RlmcLlaU9bYY80Ayq
 sSUN30jSQajSoLQSNliqdMBxINGzeHjSQ4AeOSFC7IHVt0GdQhLanP6bVV6yk/4x/ofvIozx/lH
 D0sQ0z8WdHyEm6sgosoprBMNfMAIzBTPQEz/JVqGTA4BF1cKMSfv/wwiZWI+uZOFmYdgdBM+f8d
 DdWhFlzNMjDKatEBb9ssywAfA6QLKg4eHdZkFPvzDFpf2qnTzZ2lK0AuP/39zuqU2wrzmJ6BFn6
 +1lO2Y4Hmk+zulk6F33MuGEkynxSEwD1ZKSwvWC3Dp4/vdQcm876FGrnXp8GdUZwNFud4EJqcGs
 0aKE5925zCZSeSZQAyA==
X-Authority-Analysis: v=2.4 cv=AMiVTGgp c=1 sm=1 tr=0 ts=6978d462 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=Xd8byWXf_M4q3N6YhP0A:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Stat-Signature: 66q3cg755ybq7p97o11u8m3c1tgoi7u5
X-Rspamd-Queue-Id: 7E01EA000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769528219-860721
X-HE-Meta: U2FsdGVkX18wJ0/Pn2KVpOIytVRQ9NV1sdF+K7ePW0Jc9GpDqRGSBpC24iuToZKtf2CxWOFs82nTuhaD2NlJmTk3e9fJHKeKdCxeMO5wQcgY3FEcvccIxGea5mO1FO8SF6QzYOWvOCEsEr4O+ZC9VnxuZ+7Z+VCIUBc8hjkptgPeHmAzecGyDkeMuc3E6NQxFEXFvhYLjn8qIZ84KQu1jweV+kpAVqM3QOt66GNxnCE+65vziN92x76zZc2rHRwhACCcGEt4DHJOqlcH+hOdERltNM3LLCKL3/yWaDq/JfwWkYihBNc49xj7A1I0G6gLCa2tSGH8LdiAyae5Ba3iH1O6l3yCna7UKlJTrU5VP7U/AnkqMwhVftw3bh5Tj1ZIFNuHr03F6zdy98i4nLdP6wV969Mf7mMGXBxXeJA4B7m73+/svhF94CArACIUzFNwE8+GgM+eRDkB7jPKdD7sHHHYiEVQwLJpbHe8Hr8N/oIzxdHGDPChFMdsKWOryslbPPdR4ib02ckP4Ah5vE2FEcKxK2IX6Yu6A6R0h+gOjBfRyAbrhek1qyprj8hQGeO1vlprVWo5ipvPIaf8MYxatxZ0CXOHRgWa/g7x96AKAn4zb6JYowiU2BUdmhT4xbANTzqF2giFG0Wo4lpid8YkOvd6kkoVnkF3BBCIYN+f7xlNDd5S/bPPT2OjFUhiYcHBSADKQXkxjG0pAwcxlc/lZlQOhSRoPUVd47EJmtHJvV63S6v0wNGtQ6U6TAOKaL2ljroYznyZrnFsJ9Ht1bpMcmcrGpk9BWw1UljLVMNgqfsTAuzIglBpAvSrBNRT3u6wc8qNu38qKROTZ/tzUCyD/xjKydO3N/2e6vGKaazb+InNksPkebGxaD19dWqL4LHUcPHNZSY9cMvYXYeYJL+h42j5cv3EWvto2N52uXHT2u2Y9fdTnDijcm4ZXyr+1C0yWFQDriVBhT14JXe9GK8
 hlP6MneO
 vOO8GKqeyEjPpE3djBgLiiClPdi+PAnNrM8w7aVAk+DTiXMLc7iKbuguqRL4QqhCiOyZVGNiLi3JPvFUY2CUUWJss2pEEH9Bno6TqKdnk7uQTonKzrXipX1j6xqM0O27dVZJEWFpqi8op0WR4rbFb+tmpp5PhqypHSOfCooPaHZ7XCm0ba1WrKh5N7pyI23OIlC/rTKmAEzwxaGY8Zbcxm8CbBYKZFgtKYxNy0KkLTlUbQbW+MkAG/GNfqKnY9VUybS7kIIMq02Q+GhkUy6rxclYvie2OgQrNMNEDJQBaSucOG1tavgxChr8gnyBhmkUyfR4kEDXGLxGZmeZ9MQpRAuxPA4kCB9I5D0YtWQbjsotgqZf00twdVgTwXKrLXPhf8e2O3mxzSiDwuNslB+2f5ORo7ETCkoGIog31x/4DbkRaExLszKy4HGxCYMwpncU7iPwSDE73oTrO87k8zSA2BmitpbwyxQj4UtM/mA/eyXPfxp6KVY8tc6xo/HjNjIL/aQN+VMeLNUfiqWPYKkifOoY9su0l4NSNePUKP7h+Z7zHqUgduB2N5PA/GLghfZzSSvTt7bA2ekCdQCOA5n0bR770ybXzo/SX1+CBNwuXWHJ2CWz3Fg5tALwFItsNJzhTMxX9B2WtI96RHnQNY0sNFS4+YFMox6SDvZtF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 include/uapi/linux/prctl.h | 6 +++++-
 kernel/sys.c               | 9 +++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 51c4e8c82b1e..91d2c9eb3aa3 100644
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
@@ -386,4 +386,8 @@ struct prctl_mm_map {
 # define PR_FUTEX_HASH_SET_SLOTS	1
 # define PR_FUTEX_HASH_GET_SLOTS	2
 
+/* SFRAME management */
+#define PR_ADD_SFRAME			79
+#define PR_REMOVE_SFRAME		80
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 8b58eece4e58..ea088b643eb4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -65,6 +65,7 @@
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
 #include <linux/cred.h>
+#include <linux/sframe.h>
 
 #include <linux/nospec.h>
 
@@ -2868,6 +2869,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_FUTEX_HASH:
 		error = futex_hash_prctl(arg2, arg3, arg4);
 		break;
+	case PR_ADD_SFRAME:
+		error = sframe_add_section(arg2, arg3, arg4, arg5);
+		break;
+	case PR_REMOVE_SFRAME:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = sframe_remove_section(arg2);
+		break;
 	default:
 		trace_task_prctl_unknown(option, arg2, arg3, arg4, arg5);
 		error = -EINVAL;
-- 
2.51.0


