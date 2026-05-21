Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9F9CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D276B00A4; Thu, 21 May 2026 10:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56136B00A5; Thu, 21 May 2026 10:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B896B00A6; Thu, 21 May 2026 10:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6AC16B00A4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EA261A0652
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:31 +0000 (UTC)
X-FDA: 84791652582.29.4B8CD55
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F906140010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pSEyqh5w;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbHj9iJ7NuBWvii1A/p//5DBJ1F6JGPeRMLlnMLO6Uc=;
	b=sK/rPZCEho6jP7xNJWTLn+jPzLTFER+1aW9TEX7uH3T9aSq6ER5b+7n3eBqvz46NjoSZBk
	7m1QmBVKR1tiDlFt0UWmNW+wgtljKvAK7ecwIZcjCUwStWzWfBSX5HCaBN04qaI+/DFdcC
	ebX9dnGgoOl119/o3So2QVwf2dmSe+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373589; a=rsa-sha256;
	cv=none;
	b=aMPrdeCN2v0WVvXtQrueYdlQEmH0JPvfJtGBS2FS9RbbD/XpyHD+5I43GrKuGntPQfj4Vw
	YJy5Z3qKc4K40EtJ3VdI2GEhRHmOZ2kAzLdGOBzo/2hBqqrq/uhV9EnmEU4AyID6KYAW9X
	fHKNZPALDTuUIP70UxAkoTlf+bLfS0o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pSEyqh5w;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LE9rhJ069465;
	Thu, 21 May 2026 14:26:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WbHj9iJ7NuBWvii1A
	/p//5DBJ1F6JGPeRMLlnMLO6Uc=; b=pSEyqh5wjnpwsukgafEIKddJxopOs7y00
	+ZVILJpPdafoQiR3lHLzdY5zow3hdI5apSbb2NO4bvdBltLH2yfsjKiBLhtoAC6r
	aGtZ6nz+50g9mzN/iO3g96O+nQkRGW5LQdt+SKahj/41CZPTp3Zglxmi5c3sbLDN
	q2pAHMqFQA6lL78WObsRroZc9t7F7Iv7Koy6w6IFomRnLPWjv5xCwhIst9nuYVuQ
	lihv2aMNneCF7saQ1ASb3sdwMBeBzDsulq5gVTD82ocvPGG9FyeXKE+cvIeGU8Zt
	0q0QqmC8YPudR2asfHbWJQD6iotyOVEq2dtQ1paDsVI26tW0FwIKA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mydaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:01 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO5Xo006184;
	Thu, 21 May 2026 14:26:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75kyc9u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:26:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPvdL28377478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FF9720040;
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACC5120049;
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:56 +0000 (GMT)
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
Subject: [PATCH v16 20/20] unwind_user/sframe: Add prctl() interface for registering .sframe sections
Date: Thu, 21 May 2026 16:25:46 +0200
Message-ID: <20260521142546.3908498-21-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: OUZAgxwN4FB_fHaCqX_mujPmJt2qr6ue
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0f15fa cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=1RKwvADtGVyjO38rMG4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: zPlQu9xIGGGD_WQ6kxrO-9UCFhYyJMIb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfXyY3olyWCekyi
 Vgu5puGG/58e0KVOmBgnDleJsWKu5skVuUeu9MEMW540HMEn82k8pL2woSITI3dfVuzeQITqgtE
 FtQxRrvYhpYHLOrg0T/raneNKl51iH5L1KVi0ng359JsFiooL5Z6lGf7+f6dy0/d/sGxfamK7AH
 fZrNVBNTiJqPTvxgrc5D2EUrrz0we3uexp+nSYV8NhMnoE1NsY4/LucQpfFA36fnLF97CKsWXtN
 gPRDjnrjASTL7Sw2lOm+VqWFXNOTemJNkkSBXd7Qf3J7M6b/jiiIUVpTV+JNRIAYSsyJ7kBn/Ud
 nScPxkS3Jv0jMZv/WDl7gJ15AD7NrVuzaRJMCb8+fBiK2k/g7SwkOihgGyDmgCr/n194XKibiYF
 Olt5LUyD7TmnrXjN/02jsp+kn7tHLlK8xYpajCGfCRwXX65o5fGeUF5pOOJD+oc8kuv3kpG7OcH
 LO2C3nVxBMIQbx262eQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F906140010
X-Rspamd-Server: rspam04
X-Stat-Signature: 1kx88sk8y55yiaihsn5k5quucjhik1tm
X-HE-Tag: 1779373588-737976
X-HE-Meta: U2FsdGVkX18tXawyg5m+aVFPs5x8GFEsxqElBUItErgO7DT70zwQ7dgIopevCM/W/Pyyqr5dgPLk2t4mIZUYjYJliBI0iWDok3H9dKG4JwerkMKTkQOY4BW9LHju45FzVzL6TYedoHilXLOsYy0fMVFMJt5vdRKKN2F3bSxoxYybiqARbZJT3mG7OT64XV6uXBg0WqwFDRJh9/90ap71MnbZU4VVt4nSYpfc+Y6t/F4UTtp610KT+IkcUL0mDmK1c286pCsBHKcbjrxPVGB0H5Q1Dg5cD0QOkdoZwX0NCAsGIWbKEv4/FoEjO4N9lJKbnFpQAyKhztxpicqew47foW4P7WSmC5LB1VCGucU04hLuMb9vO1QNpf7pHCdULz2DZVPWghOjAhGJUvq/z9y8/PZZBFJp1QpcrIQj04KTeDCJXmcnc5zy6uFOzR4sThiXZwqD+VTVtzFulHBT64JYnIEjNR3rVBlzY1wkvR6L5tYBRscBES4lwERXPzDIbxTVDdFyrM95UA77XEreB95az5QPlkMl+to8Zop6qqkSy8I7aiN9qWbWelt0edUWnwcM7IqrbSGbBrInla9JetsIt15YbORkikj0HZMjrSZZezedRMTx1dbO/fxWKLyFUz9O9im/TSmD7zWtSb+mKakE6hO6MQXIs32OYCl/DciQGHuuHvfCcpCScXuSTAeYJOnNPdURJZur5VCZyRtoXb0dn5nE+OhhhtiVtNJHQKq5ojzAkSqnPW15AG2n/wxJI81bUOUE5zw6wCA6ekQRQTAyKApRr/1HYvNvKLFhLpDiG+l3RpFD1WnU1UCKY50VNTBCmZKbRh3mMUbss5IVxIEslrb1w4SmhGfrs9GV7/sB5sSwtMS+vs6OoFHWaXO2is23UNtLFUF62Nz0vmlhC9AZdquBSvnxjOnEVuHe3DyPASPvY4UUK7hlhbxna+jvVhvfatFu0SJOESvAHsyfGw/
 JwgJBUhE
 cICcQGF4zPhsEvS9Nno2AJSZwQiui7Hsc7ycAWNDg0OVrV4+6Dxlq40iMbT0EUfxfHZQp9cIF1OBbmn5b/pBB10OZ1iYshrzhLdjnK92WcVxrReTjvhe/g0KTkpR1ZuGQvRJDnNgF/WzD2KBfShJHe4CQWUnC9/IOLWaokhL3kXLIAO66chXFLvduAkWpsDUbhFaEsqbqeBj47Pfh1fEfWUYNdbK56LlAf51IMHP3fp/pol4Cb5JsiJkC2qZaPiCgSHam/GvbL34PlcgSBeO2hr0HX0SJ9tcrRWtS/0ttqDVrXK/LiO777Wla7hKDaVZazKCsaQSAAcMvHERK/GJKcOQRS4H+fjp/BlURguFGTkzVbCy1ZdRjB8T38rrqOwPjOm0V5OypRwg2U3xzV8Z//61vWR4LSM8kC8k/fQTWszshMIR75oRb40Fn+w2g7LSwoq3f
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


