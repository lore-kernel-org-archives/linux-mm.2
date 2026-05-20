Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69709CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618BE6B00E6; Wed, 20 May 2026 11:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFD06B00E7; Wed, 20 May 2026 11:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506406B00E8; Wed, 20 May 2026 11:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37A106B00E6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F28B31C0010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:46 +0000 (UTC)
X-FDA: 84788210892.19.69B7465
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9959D40002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LhUi0Ppl;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbHj9iJ7NuBWvii1A/p//5DBJ1F6JGPeRMLlnMLO6Uc=;
	b=ibVTkoF95hMzqwe0ZnIB9L25Od4ckafrDS1CyEWUpk1ZQyW1w+5jt23mems1BV/eLAKGcZ
	2YhRS+Tr49Y9ExM03xNI7CpD09hfayMAzMILW19enDEPdcpz2/r8JMz0k0tuv/PwJuKzE1
	2J694cNUn4ebp6PiBi6KFxFZSSRTGic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291644; a=rsa-sha256;
	cv=none;
	b=5PFv1aS/pvieGnid0Hn82hdM5PKWF47zNa5IviXuxNkbT6HSwiwlQ1P67tJV0hF5XSv3/V
	hBBfJnC5Fy8EXsvK0eBpYLAoXd91AyFSaOIDCJVTb+qNa02/rPahBiF9fX4KQoDZaZN4d2
	34LaJEFlt5Loze0kW7qGw/oIo1SCZFg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LhUi0Ppl;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KDW9HL3919898;
	Wed, 20 May 2026 15:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WbHj9iJ7NuBWvii1A
	/p//5DBJ1F6JGPeRMLlnMLO6Uc=; b=LhUi0PplsX+LI7hAaEG6j36I0dcncbk1T
	X3MYPZZPYQ+Uc5gcMsVpgdtaGAu9hC8eBSvmj3927BVS8JOQf2dZmHx9257DW5uS
	+Pj/NjxqptNkqLUb/ENLnZp7baWiahV2OqveglFnnmxZFALQVm4kcpPbBjAW7Mum
	39wv6/RY9uBIQVmORyKroxm5VRbvnVz7R729JXqzXaCj2YexZmeXo2/MhOortDFj
	wSiPgvSdkr9bcvhFKbt9oDiKkhoWF4iURdUW6CdWZsuOeDqkgl3zxobG4yP72anB
	PgjpiFXrMGah4gnwE01UTE+ExYNvhvcKIWdDMli6H1YW2Eoi2PXJw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mtsqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:24 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd64E008375;
	Wed, 20 May 2026 15:40:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e739w03bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFeJ5u8323524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:19 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCB2520040;
	Wed, 20 May 2026 15:40:18 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B58D2004B;
	Wed, 20 May 2026 15:40:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:18 +0000 (GMT)
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
Subject: [PATCH v15 20/20] unwind_user/sframe: Add prctl() interface for registering .sframe sections
Date: Wed, 20 May 2026 17:40:04 +0200
Message-ID: <20260520154004.3845823-21-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260520154004.3845823-1-jremus@linux.ibm.com>
References: <20260520154004.3845823-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 8r4Jt1uPtErt-p80F5ARJZjJU30LBmBj
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0dd5e9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=1RKwvADtGVyjO38rMG4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: mjXy61-ALNHMmMxx1WsbOKx6Ph1jwlyl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX7JfboGGTW41p
 XDOHgShkDe/wpP2e0PXh/NeE07prsJJAQtbcvDgJyFfh9ORKY5ctpBKa2GImqvsb9BYX5Dl2UIR
 a4z+hPRnfb/25tSVVzV7q0B0Zo5KueRA+o4cj4/8Ri4EjiZb2yn3b0crinZq6oyxEGekYO3EpyD
 AtuzEFqyxlPLN5JV1hKeQEoMg+NVORfXB3r48SrqSDP98MsS2lpFo5RO0xNrVDM59A+nteFTCdL
 61ePrUsjdAvXBdF1KhjqMmkg6xevbS+QCNe7i0l783bK4UdiO33kWAdgJApHPCTUW+3wuldkoLU
 1HF45OQ3oVZVlQxt2VgsbQcEtw8NhxAVwVMmWMYRLUDm8KJfZTDN8qtnXGRFWI33/3jRHMf0iCK
 C2jnFU5OYUV3TSe+j7H5ha6VxxTjJONsKyIqF9V7BcHraBzEFTcAgtZs0GZpITxPmNJFhVRniC3
 3pK4cj/XcPfSGNQhRfg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605200151
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9959D40002
X-Stat-Signature: 9n6i8ztwdj898erctd73ou9nqj9z5mem
X-Rspam-User: 
X-HE-Tag: 1779291644-787076
X-HE-Meta: U2FsdGVkX1/s5yqBq7lgnwvbIRjfHJix6L1cBxkjDj4gLuFzCEj3XePxBPgM43ONnOJbCNgNmuBZMu1+fE7uh/UmwsF/ljSkjmFSmnkXGK6ajS3ma6Pvo5E1PDMEUx+h4/ATjqTYMZpfwYUNxtJuTQzCiZZL8ckWoD1vOXU0jDaTpLGWtOXdhd9IRaJNy1cThw04dMe9P/rYcOnPa4Fxmk+v2KlsXZvBtk2nTYGTbJQDqi4dmLA701WSi1cKyNACmccB0vAswEyhPIOIxUOfZDMaOIR1VGSaLx8l8zLmUbm2xmmE2gYWi0/c6fNqmVZwImXm33dA5lXYdWo87wct3LWuBW4eKwySNi4Cje/9fKV+VzoBSK3XRgJrkFbLwCmwjyveikFz/p7ktUx1gY2Gw1TI5PR9G6OvK5EtOEugg0kiLPSaqn5oMGoGuy83DBlqYbZYxLwb5n40sbQDQux4g24SQCqXe83utwh5f3ILrxwjLvAT2fZVIyZidoq5L6Yrz0lKXo5E190GJzw+z/12omfXHqvq6szsAUNaQ2eNVCpthLM723+zWG/HEKEutmUx09LhnHmq/O+Lxic33sG6f/mHgQ4TCvDpfjg2HY1G6uxCtMqPkzZyECd11gxgjD60VK+WR6DCDxClnAqYOj6G/4u/d4bzXFeCV9+/yUGzS7z7n/QiugBAdPfaeoLE3Csd5T5T9iHoDJxBn/Udh6erYr10GpkycpHrIJVEVIAs9TFhEoOGU6mAFRdSp+Hnr/cWdNE8MLvGbPq3gKr8UuLnV6i7c9ECT74NemDKZOxx7oPQ+ZOx321ktX3QvosXsqtpyJq3MLeyn0XH6QzwGXl4VGqOlRddwR221lioVC2WqUScCqQW9i6AGQTvaZYS+TBp2rqInkXNVMy3/bjs9TfV/o+u4IJaQ7ZKIz1FklxUyYxWrnUzJduk2pyA3730rA+/ydGMImCMWnJXR8FVGd6
 SBHCdGB0
 sFgGhW1anrCzCBjXGVYS0FcoLfwPjef3WPpZk58I9ybmKLCXjON2oY944alOTqBWzpggNrGrdgQAW7ppQUNsZ4WA1JmqnK2iseuXxCx586AztPsFt9G9TdpNOiiOIG0Y+b/Cye7qSeVsttEakct8fYIPQXLniKYpeOp9EcN7SLr5HawaR89SX4FJNZrNYHSCWWO5Rpyf/HG9UsO/mo5ZGZ5bEPtk934oxX1yXujjlv1C5pFl7o2i/D66aupPBsedViJh5RLu2/Ei5Q40uto8zgd/6tMDBqeu/Z4/Xafbis3B+nTMuh+LfeTvq+Y4227oqMWG9OPek8SVLsloVoc/tMAvRJr/0ceSrS8LN
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
    Changes in v15:
    - Fix rebase error (missing break). (Sashiko AI)
    
    Changes in v14:
    - Bump PR_ADD_SFRAME and PR_REMOVE_SFRAME.

 include/uapi/linux/prctl.h | 4 ++++
 kernel/sys.c               | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index b6ec6f693719..bd0bf828b033 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -416,4 +416,8 @@ struct prctl_mm_map {
 # define PR_CFI_DISABLE		_BITUL(1)
 # define PR_CFI_LOCK		_BITUL(2)
 
+/* SFRAME management */
+#define PR_ADD_SFRAME			82
+#define PR_REMOVE_SFRAME		83
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 62e842055cc9..b0a9b1e3ccd7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -65,6 +65,7 @@
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
 #include <linux/cred.h>
+#include <linux/sframe.h>
 
 #include <linux/nospec.h>
 
@@ -2907,6 +2908,14 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg3 & PR_CFI_LOCK && !(arg3 & PR_CFI_DISABLE))
 			error = arch_prctl_lock_branch_landing_pad_state(me);
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


