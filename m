Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F83ACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76A3A8E0009; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC388E000A; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547FE8E0002; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39D298E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0A8C140730
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:12 +0000 (UTC)
X-FDA: 84026020344.14.566E70A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8171B40010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="MbxDP/hT";
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hulga1iRTiUHb9Gn1ZJtjohTobzxqtXivIk/MrewXHo=;
	b=mPXZOzfIzwoWcpNhjiN+UdUglBPaKHpokViWQf4YKJ97d6xn9C2dMuEUspN4Mi4y6y1qCG
	6H3KnaYk9wCjDXMbVkqwyByzxCOMHjlJKJJfjoL1PCWBrOc6VbpYabnvZZmXsQ1kwBiJkp
	BvQHCFYsQ9JM+6efg3gT5Q64tVxkeUI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="MbxDP/hT";
	spf=pass (imf07.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144250; a=rsa-sha256;
	cv=none;
	b=I6YN/g4Q3ZT7Bhq+yMIKFYaVKZiPAdO48smeA91xhcrbLW7Vu+CX99u9p1GMU0Aq5Gw6xo
	2V3AEP7POlfy5EEHar4S/5Sh+oPbWdqUHmFIxqCM7Y2uaQixxvc+aI9Mw13U4/3Oik0HdB
	DXy70j6yMIqL3vnjUSoDFa/5MGioM5U=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MBkTDD016011;
	Wed, 22 Oct 2025 14:43:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Hulga1iRTiUHb9Gn1
	ZJtjohTobzxqtXivIk/MrewXHo=; b=MbxDP/hTp7jnSG2o+UGlloHL/Wbz1lwVe
	0bXLWzIv5t7p7H1olP0SWpzmxfG5cguDG0YMjhjRlnfO18qgltdk6xduC1NDTvYo
	BEffuqZolNASU/9pTBGZvMHEM70hdMVm9uqwIhi/Re77yntFUWDbFgLDK34WBIm3
	bJpmDCGVH8HErZC3c0uf1dxKbrgHj91Xr19NI/0qIHv/058UsY6Nt5gcWFEH6mMX
	g7EPVtNx8r7LlfFwqoxa5Bowd2LeEVlZuZYaw4XiNuWZJgPe1FXtA967ytWgxt0V
	ivDciSxLsh/pocQyQ6Qveb+EA192U4PGsFp9JpY16DuxFTA2spBdA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hkt6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:40 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEKCmW003107;
	Wed, 22 Oct 2025 14:43:40 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hkt6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MEFrJD032099;
	Wed, 22 Oct 2025 14:43:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vp7n0tuu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:39 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhZqe46399906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:35 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FB7520040;
	Wed, 22 Oct 2025 14:43:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBE5820043;
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
Subject: [PATCH v11 15/15] unwind_user/sframe: Add prctl() interface for registering .sframe sections
Date: Wed, 22 Oct 2025 16:43:26 +0200
Message-ID: <20251022144326.4082059-16-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX8gRdXF8Bo1Hs
 L6mUmt/gijOYGdbbygRk1RfR09qzDB0Zy+5sfvBbU15l/3/RR3zNFthigVPWTA2SePQKh36QT3Y
 QMg90ENkk/cpZkLMnL7SueqsoV2lPYIG/wC4NTwSuR8GECgv+kRAKFxz3v+WT+lIZ14eH1Pg5Un
 tUHkgMlZqYt6ckESrtX/2GW2kVJ1fRdfO5oG9fFhoLkuHWRTItB/t//b1wW3Y7X8ZEZGKofgKEC
 rngWP9mmcSIIoqORxPq5MK41SiNQW3b0iovQL2QTs+RR/tfviKavYdx9izpZzAPoO8x+4blgb6w
 3GJmvo7gN7CgD7gBTXOormZhc2Y7iTqDvCU2+82+yc0duVoumb9eoEqgKAxjQ9eQJYsfL1fQjYs
 LG9aJhYsS2yu5vOPWXAhkI5c53Mp3A==
X-Authority-Analysis: v=2.4 cv=OrVCCi/t c=1 sm=1 tr=0 ts=68f8ed9d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=Xd8byWXf_M4q3N6YhP0A:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-GUID: k9FN5CKd8FOvWKNwr1YCwiB_ti87uZhd
X-Proofpoint-ORIG-GUID: HEyps1tM1LxZKt0nkQtMIvHYlzjPgbTp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8171B40010
X-Stat-Signature: csfbxjdx7npnhw1gbn79p5d9567yenpb
X-Rspam-User: 
X-HE-Tag: 1761144250-735739
X-HE-Meta: U2FsdGVkX19iltHXsfnqgGuFNvgT2kSRAQjPvHQB7M3KXJno5lzdvo1DBd86RVj/hp8F5RRf9IGiPs6BS2pOGam2ztm4X0UHIMSb2+HhAOjuKPvh2yr4Z74+fBBUB/lB0IsrI8aH/Io2pI3I/TNoN11dekV+B5OFmowVBbNTpqNCGijdtmLxuGu92k6l3UHc+iseQ1unwqHSRFJvSjvdzeICNcKjhyaVgaxQeIA0ELCvnjxBWYhLcJs227eP4oLIPjruwH5+h/te4cckg82OsW9dyKImYGZHWpm92fJDdSVM+aNgo4UPEI5V6WGjgkF8c1lrHUCsVGxZRhKfh5mY4B8w4HkOUnj8U+nuZZy7Ic+Z3qsxUdrtep0tXdWhnMI/ArVPILonEN7G2HikmC9Suhe/ZUcBNO1r0Hn03K+DBqpE3EczVgJeojrh/9NqYCajHkCLWg+RZQASsUxl2dR/0URajwiBGwohP/JfUQLQshbBBR8yLM4WV+75mM12Ojo5bUJRgEHr/r9A0rcTAqOEEO6qu0VFzZaLpQ9XpHMKpJZn1kR8FQmQ2f5+SjmDTnY0LZJ6FQoUCsTpaxdAuf6EVD6XhZ7sOyZLHFZ8n2N56bO9FbIOnCI8AFEEeVakObh4ZiYjj7W3/6mOArxnpyOHd22CA+8fXe0xCxbp8JX+VzWKH5UyQgjEy/fhl9PzpbjtpEcYdS+cOmHDKoLxtwtCu/O12qtf9lmD8m1vxQyOQggaiA4idyk5Y3fjjoWoEaNTDGHOGEwxZUOsIGsyKDehwTQp/wzLUX6127s/TMXe1rWKpQ99w+6bFRHP7qQl2rxDSniwyq2/7QlrfOoC1kpeIGnSkuMuu+VP212YXWS8PbBfkZFNX05WvF5+ReiqC6mWjc4bSZItZNOXk3l31GIyAQiZ1/KYC8P+kZLg4Lnonh9enijQzKJiiGFLqKPkaTxo5QvG6eOTVcWn3TLpn5V
 OlhpY+cH
 Lzbcd06R1ImgyWYAmh89Izl5uINmDlieQDyfVId40NC1rh0PWDcZPxOS8SQ3LkpDvfFWtQzuU+KIxqVhApBNwYh7TKr8KSsRf7KzPE6K0fDDfuK9+EehympuTlyjpjOEbXBcBQ1qWKz3mOY6TsoDJ723fB945XbUDUu+3KOe/UGsd1I5ipP2uqmQ5dvhtxk5c04XioLM7NmO1fEwbOUWevN4CH5+q1J1+xoSDP2z9T4P7jEU6Jf3DEJaQrXrKYGpafnntEfKKezHJENEJR9BeqWNioXSlFX4BGTpFRqEgYcIUoloVuwS7LSkJN//jZlJfSskiEVmDDafv66V8MIGkG19yjjSuX0pFQNpjmRzbFcSQNYjA8dyeYuZPzGuM7JzqWbWSo5G+l7aAookK3Mf+NrMd1OvXyxX8ZVpdTU4GCHLIhv+bf6KPiPnHEUZdh/DfAo1g7wOFMNhNODAM1/0BFV1ZLc7n6dYwdiGI61eRqGe2ee+pGW2SNtjKgtMSv8bEAfplii98GqTzX8Qx9agyYZroyHHNeKT83g091hjG9ERP3OYG+SdLjKOd4SqH8tnyLoZpIe2EenScn/mAXtR2Cy0cfMmg+YxnhG8Kz/YVcf3UK6MQJJ/YejtZakEi/wouUSJrBH3gKTDPP8uHbxX6g0PYaKUa/COGqc3G
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
index ed3aed264aeb..b807baa8a53b 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -358,7 +358,7 @@ struct prctl_mm_map {
  * configuration.  All bits may be locked via this call, including
  * undefined bits.
  */
-#define PR_LOCK_SHADOW_STACK_STATUS      76
+#define PR_LOCK_SHADOW_STACK_STATUS	76
 
 /*
  * Controls the mode of timer_create() for CRIU restore operations.
@@ -376,4 +376,8 @@ struct prctl_mm_map {
 # define PR_FUTEX_HASH_SET_SLOTS	1
 # define PR_FUTEX_HASH_GET_SLOTS	2
 
+/* SFRAME management */
+#define PR_ADD_SFRAME			79
+#define PR_REMOVE_SFRAME		80
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 1e28b40053ce..e6ce79a3a7aa 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -65,6 +65,7 @@
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
 #include <linux/cred.h>
+#include <linux/sframe.h>
 
 #include <linux/nospec.h>
 
@@ -2805,6 +2806,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
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
2.48.1


