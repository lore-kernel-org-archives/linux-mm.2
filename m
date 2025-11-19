Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01ED4CF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26BD6B00B6; Wed, 19 Nov 2025 08:24:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0006B00B9; Wed, 19 Nov 2025 08:24:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD506B00B8; Wed, 19 Nov 2025 08:24:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6966B00B4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 512511A04D6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:39 +0000 (UTC)
X-FDA: 84127426278.06.B31E11D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id D50E01C0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k88QHmdg;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNu7AwZkL+7LwD/e3+JWxcepnHLL1em3QMX+b+R2ii4=;
	b=JIfxF+OaNuijVlcXwpUAdMisByEPABqWr5GZWlQwiacaRXi6Md6q/3LQKZityCovHrwm4x
	OCON/YZronQqSAjfas3vZJ/3grmXxahZ+JZtCmjlQBWJ7huFDZFUyTkbP66Dh4KkrqryWs
	IPvPIxRc3xicQlIPh9ogyWtZ6ZlReAM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k88QHmdg;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558677; a=rsa-sha256;
	cv=none;
	b=7E/IXiCKKBV5nW5E8TyUp7j1+T1nlRevAfGLQjzVrdiG9Q0pbpVeiCXyTzpL2/J7WfjwJJ
	e5b9z/zaPjTGN1Tx66hxry+ZXexotya07bqelZ/0sDpzo7MXQt28Ns0MgDgQQBrvEJdv1v
	NIqJLZm4+5GODYLaYFXeRSkBKVOR92g=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ70xDS023082;
	Wed, 19 Nov 2025 13:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=sNu7AwZkL+7LwD/e3
	+JWxcepnHLL1em3QMX+b+R2ii4=; b=k88QHmdg5qtqPir91dwXdQHu5qC31OCPH
	v6BZSKXapdmGzRbCLtcZZ8X+rRTZRHHdFZAvbiK8hxz+RDx4pm7PllT93IpqJIgs
	6fmeiuX3sr7qknxdmA2wcKNqK2QngurQgFQKplnaos1WO5jKW4g+3ix6HfZw3D9+
	DKksxLDT/pYbPMrv522H9P6Pjeyve2e3s5Mksmys9cgi/vjtXXJGLkeF3Ylacyqu
	vZgVrCFiw3mCKyRB+BCcfnOOJZi3VV18/pSV1TBKeHtrtfQNLbLIDpxKAZncyVj6
	xz22bNlf6ey1xYJCvbaOSCBF4wmxOz9KKYsJ5adhqBvOcUdWRHIdQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw8mxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:35 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDIRRf016838;
	Wed, 19 Nov 2025 13:23:35 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejjw8mxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJB3iPE030837;
	Wed, 19 Nov 2025 13:23:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af47y0wpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNTss26542558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:29 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90ECE20040;
	Wed, 19 Nov 2025 13:23:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1052420043;
	Wed, 19 Nov 2025 13:23:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:29 +0000 (GMT)
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
Subject: [PATCH v12 06/13] unwind_user/sframe: Wire up unwind_user to sframe
Date: Wed, 19 Nov 2025 14:23:16 +0100
Message-ID: <20251119132323.1281768-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=691dc4d8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=MghY-D4m4Gq5DWcjBO0A:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXwS60np0XNgGh
 wNTlEKubMfY6jH+zk51Kkt1/bOGIee6ovtWgsdm4yDWMhPZqosbe4vru64Mf5NzNqlyYgxh67+e
 9ax1xcc6rZnrJ2A0kuHZjAmQD+a8Zwk2TkNbqlYb13l8tNHoEC3RCELeMFQESdqiYDXm+8oDVa5
 4biwsMfyQW1feDNiLcTVkDPzAtu+t57nwU/M7uXx7N9lJsGXfo7t4If+haXJXr4luvyQT4O05Av
 cxOM333BybuJ95jMZdbJjJDgS3HuNapIzF4VjwGjmRHrmzKyxa9/e2k8uKP9mvfrU0a5YPGmF6f
 JkwoF6lySgawf9l6BQTosa8IVBZM2Y/gZJwGT99TWHuhCg6hauqmZD1x/GGuDb7gmxDxZ3s7Pod
 wsCZiZjsouWyrwWhGhzWe2/HwWgE6w==
X-Proofpoint-GUID: 8s40wywhp5ysHiQXficn7qOInNI6IeDU
X-Proofpoint-ORIG-GUID: ItsSK9le7epIBPl8cCace8rXArNw23G9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D50E01C0006
X-Stat-Signature: bf3i8cikbibsog81pgo18zfxn7yazxgw
X-Rspam-User: 
X-HE-Tag: 1763558676-498922
X-HE-Meta: U2FsdGVkX1/8j0m8m8VSgo2oTdTHONDIfiuxJ/OEts0wvZ6zmQgNufygD4LNYiLpFtlue24Wdm6ZJLy21f70b4HZ6e69wejZDusbityk0ydYNHfDjWR5nLCiX4gke8YTxjozF3EiZmpLH6K5tvS3/V5d9zqf3Wzy02Pom4fMboWuFNeMRxdmPkevIS/MYXyLlQEXa8ayj2o2HzEUOe+yefOSzDa3WMWh6jg8mj/azW1ujKN1PpdAlYhX1PgpZjggzUZ4HDTgSYWOK9tqg2tyIyXYjT+Mvg9JB8/w9ClxbeOZfDMUynpgClzHIaLSSxbb9czdWgIiAhcKEIfykMzTUkJ95fg814NKka1zO/RPJp7gsK8LzkE7U5T5glxEi9OptmrrNOH05sggICHXBz7CRuu2PlZ0eT6h0WVkdMR38DH7yZlvvFgbQsKWFh3am5Z2UQYKXEz6S04TTCHr5GuVr7hmKfgDIzNYkim3Et6GSeqFLZ1ptKh2mhKKiaIulJrTpNmu2jOmXsA1a5nYa7thpBHSrF8mHpaL5zLHCH0c5g5fqKZ1tLzqvo7oLR1kmg9IAdut8YQnFWpq6inwiRdLAj/3KpoIfLfy3SefcnfjH4M1JNbVVF3Z2zo4SrRx95LGC3NO5fgyrXG7yZsB4u9zPZ/47OBG9qsebC1bEFZwbyLW92ltp/AUUzqfS4RN4vJwZJWdDssHyDVnv/szAFfuCg0AizdM7R+rfS4sGejzxioZsddeY33/h5urisr7M1mrb9+R1Hes1RK9LHgzHajtn2bwAZosj8/fHLnkQfTR20vylmwb3vjQzxyff/iCJNXv12KeIM5CfRBzbJlVdhtkS3QearLDertWy1e9WRLguccYdQWQ10NldKBuIYMwNCFPanhnxLdfIU2yqyXaG9hSnocvdYxVo+Dg2OX/At3HYnB35nrEPvqGdUJf2aYFcZoDFcBcAxSa7socbKMYHcF
 RoXGNaxx
 LbaHxykwy0quCZiAC+nrtNDbiOHjQX2CK0tHZXifM1R2h0mKT+TdZ/3xIi4n1oz5ccpv/KXO9D9E7cnnnaILNnLjyofHhdJermhdKLOHZVJm+Kz7DKccRxW50IRB+vT7YnLQo3QK/bQ426lRlLOj0QchhJmoSC+pkhC7gLIOEXvAJshzaFhY0jzp8whjKNuSSzkforREZX2bsjcSHCGfDgKbIQ+pUReFjn5UrhglIsEvAqtRfYMzv6fvb0XXT3BWhwVUOvTMpAdcA6+796FyWETm6sXxETCwrS/X6PsX2bAGRAuVQH7F7tW9BRnDUWNvYWlSZ3RiIhEersPbQdX1RT3iUZZ2o21rpMNyLMjCtSbnWCOQWPolEMJiCG63P4Rk5UVtsNoMwykqUo492OKF7T9kYNNvztZS+eopdVvGSwKUQdq5hLgLDTt/FTppCqNYMM6F0k5WmepkNksnvjVp/J88UiScHzEf5/HeUezQ4ln6oLUavxTaMkLEdIPYJEuVb8FVFnndyasiUALNh9t3ZzR1U4AeDh+EiWE29dS1f2TovPmM5MrqIYAwpZtw9xvkMArnK4ViOJOXhy8nNKTBubjYz8a9lC5kWJgOD0g7zh9ukaZVKuqDDaowmtXhQdXEsx7FOI0cYfUajzqsLzxUGO+Xn24hiTyyRQI2YsaC5qkfe4aDwV2iIXCP60Gu5dR+rl/ar
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

[ Jens Remus: Remove unused pt_regs from unwind_user_next_common() and
its callers.  Simplify unwind_user_next_sframe(). ]

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
    - Remove unused pt_regs from unwind_user_next_common() and its
      callers. (Peter)
    - Simplify unwind_user_next_sframe(). (Peter)

 arch/Kconfig                      |  1 +
 include/linux/unwind_user_types.h |  4 +++-
 kernel/unwind/user.c              | 23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index cdb0e72773be..ab1941ef1411 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -491,6 +491,7 @@ config HAVE_UNWIND_USER_FP
 
 config HAVE_UNWIND_USER_SFRAME
 	bool
+	select UNWIND_USER
 
 config HAVE_PERF_REGS
 	bool
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 412729a269bc..43e4b160883f 100644
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
index 39e270789444..7644ab9f6a61 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -7,6 +7,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/unwind_user.h>
 #include <linux/uaccess.h>
+#include <linux/sframe.h>
 
 #define for_each_user_frame(state) \
 	for (unwind_user_start(state); !(state)->done; unwind_user_next(state))
@@ -86,6 +87,16 @@ static int unwind_user_next_fp(struct unwind_user_state *state)
 #endif
 }
 
+static int unwind_user_next_sframe(struct unwind_user_state *state)
+{
+	struct unwind_user_frame frame;
+
+	/* sframe expects the frame to be local storage */
+	if (sframe_find(state->ip, &frame))
+		return -ENOENT;
+	return unwind_user_next_common(state, &frame);
+}
+
 static int unwind_user_next(struct unwind_user_state *state)
 {
 	unsigned long iter_mask = state->available_types;
@@ -99,6 +110,16 @@ static int unwind_user_next(struct unwind_user_state *state)
 
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
@@ -127,6 +148,8 @@ static int unwind_user_start(struct unwind_user_state *state)
 		return -EINVAL;
 	}
 
+	if (current_has_sframe())
+		state->available_types |= UNWIND_USER_TYPE_SFRAME;
 	if (IS_ENABLED(CONFIG_HAVE_UNWIND_USER_FP))
 		state->available_types |= UNWIND_USER_TYPE_FP;
 
-- 
2.48.1


