Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F01CF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BA56B00B5; Wed, 19 Nov 2025 08:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25376B00B4; Wed, 19 Nov 2025 08:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5046B00B3; Wed, 19 Nov 2025 08:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE5E6B00A7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 705021A04C0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:31 +0000 (UTC)
X-FDA: 84127425942.21.B90E7F3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F172140002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IMBBaG1C;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+dR3ZyUwv8dVIGnnpIFwvKLWWNKM29SKpsuHVAjb7M=;
	b=QubxArVmS43TyPWkCA8Y2N/7O1ON6BND4c2F6BYP1NpfWXCE1eK6u5jmYtbcLNtr45NYxV
	Gun7J7EGihE9mp7GNvRubhAKBL55LBYnLIqCGKuNu1BSrQCksroSEQuIiKToKW7zdbgZ7U
	hw8TAZyIsVWTNzQ119SR5X1JIELDb48=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IMBBaG1C;
	spf=pass (imf09.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558669; a=rsa-sha256;
	cv=none;
	b=Ivw2ZIMUjazYJm2Ryo7mjP4O04vnPZzsgPOFuc2FjvhN6ybfG9r+sbO5j6gtVH3y5o0Dzl
	zUDAD/9eINda97R6bML52JZIqmOlaldl0koDdpBafpCd42rdWg6ks1GVjupMff/LrO1Mpi
	3q7+wnbw6ohN0XAI7o0I1TDHLtDrqdk=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ4tfMT022500;
	Wed, 19 Nov 2025 13:23:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=K+dR3ZyUwv8dVIGnn
	pIFwvKLWWNKM29SKpsuHVAjb7M=; b=IMBBaG1CUhCrayp85t89WIjgRz0JAR5EG
	5y34/3fhBxMZ3iOMgL4/R64i2jzaxk+IAJZVsLGfwBQNlHsX0vtWLJL9B0DxJz9R
	XCRYxW518QucDsLwXAiwfDupCj/Sfs30ZFgiR0pv5DUR2mK0T9j7jD1Qa2CIwMDC
	810v7prkh0+L/ToUA6jIAFJ4iPnRpKYnoJWkAIWiEqaE/jq5YkBXHTDGip7gh/P8
	Mfrz/v+iunt28Pifz5R5mX02Hc5cAg7tT9Lw6rjPJ0o5eqoP8aOTajv3dQZoliQf
	ACtFa6suKOFbLTdvbT530fN0TlcnAfNCFeEdeG/8aT/sUW7TXsQwQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejgwys9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:39 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJDJKpf003034;
	Wed, 19 Nov 2025 13:23:38 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejgwys9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJBjY4x022370;
	Wed, 19 Nov 2025 13:23:37 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un0tc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNXxh25297200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89D8920040;
	Wed, 19 Nov 2025 13:23:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F25F22004B;
	Wed, 19 Nov 2025 13:23:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Nov 2025 13:23:32 +0000 (GMT)
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
Subject: [PATCH v12 13/13] unwind_user/sframe: Add prctl() interface for registering .sframe sections
Date: Wed, 19 Nov 2025 14:23:23 +0100
Message-ID: <20251119132323.1281768-14-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6J6MplQdpeKZP47LAPlrIj_NFVq4GDcH
X-Authority-Analysis: v=2.4 cv=YqwChoYX c=1 sm=1 tr=0 ts=691dc4db cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=Xd8byWXf_M4q3N6YhP0A:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: bJ-MNU2r-xDPiDny6twD3DdrKCXmZWqb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX0oQzG3jHyknG
 4Aydlg4L0A2ti9MTGGKmbT+rpASK1fukvHTSK9/oB5noBy3TWBc7Z1yycWVGJRHcJPg3bVK6PI/
 mQzaD1NAObtAH6c9fBJ8wtehVUMwVsgUmhgkOjPmEsI3Dbrl5QH6aRsRvtFMKqEJyacNuX9MDYY
 FvYB4POD6ziMc+UPSrsUDieKur3BmysOSw0ho4l4nbwK8bZ4Q8nsgvoy7SaL5ojSz2Dyjqb4vYb
 dmahgi7rLIwbNE0iH4tXdv7DKwNfP7KhFE/L09e+sKx9wKJqv0Qqm2iGQJ/7sKG7req/h1DZMA3
 nHOyS23DvGW1Y6S2gzAnM90XlGeFk5uo/6AulJAwEsVcnBTNpEdfJI3aV7H0V/nqDWOfeiRK0A3
 Fw3uQ7TDtZGdw5tj/e5LgG7YnQRKuA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032
X-Rspamd-Queue-Id: 1F172140002
X-Stat-Signature: 4fwdyou8gcptcynhegk9wjqkgqcmrtf5
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763558668-487682
X-HE-Meta: U2FsdGVkX1+x+fYaM0GX6KfGmjxNNAAFlZEy2jHrlLZMLSaZZ3kF8tH3bFFPU15XKgC1l8AJSVUw4ADh5Y5c9vXtJq4OnPTJaUFMo+F6gf/8CQHUDJXJpHlXnELnQlihW/N69ySBRIHQm//TQybdD9ZfYQYTLMKI/SFUB6BKaPBKXsxeKCKxWubxx5q0iP9aBiW1S+L8Y4GqP8P1OK2rNLn3OMEafZJ7WiXamgaNPYMCPiTdNeNYSXixz8X4M4GZBKOsI0rc4PFbd3Lth35ANkBCvOcY+yDe8ZzKzDxnRDnLLaHbzcH/JAUDpSq6lxHcqeMd1P4XlLTWOFb6369b+LpZR81FWMrmwf2wrsdT1lqD3KHbqbE0t1ZDs+T4ZzShqcwL8S2AQSJ3/Xoj+5clyoK/aHhxvJvrZ5RmlplF4cga7CB6bsAV3n6dgUDYp+xDK90d2yqLYEtYBumYEBBLy3FhAjLyev02yeq1GOFds+T9UbyWaIQ7XNpUYs5WXnq1pezTvR1dsXq7yTKXjq8gcCU1XRvW7qJITjQC+qQ9wW3uRw/nxokHQNpd3EjbExqEUjJEBm+9XyxCGH19jNG9jCVag2LXoYkd5iRIrgtEPIpW0LVqViB/0+BkpKT8UF31dCghORvEz2mkgWxavQRfiKUY8Uah600rwKpMfmkTv8hgnzBAZ6qaNMR5gPfcLoAEC/hLktn9oQlliPFzp6n5OgSLIHUFGEHSpilhPz+W+3beR9cgMT+TQrwTctyqdlXrp9fQiocqBwHKxXORCDhYZPBxRt9sel1qYhd+OLTqfZfiMUhe1avPaR9FR+M8eu4qXiN55QuSfWjUHy7yWXmWxFjPMaJR1Fup9Ahi64EdW8V+/4gt8kvbtJy1Md28Hm3zCgZ1oxY34AvMt4hAZLWB5ybqwvlDx5RKhFvZcpl5vUz/5mryZ4+3gVV6zB0qvpmhnKyboQg+D1a3Sw4D6o+
 tUwOH9pd
 WLWEl9MNnQBezkOTZgPcmKj0H/2kcfJLcMxSxxe+K8rAJZGJZti3StsfBSJtzXGlAM03komlKga6piDjAik4Quli4eRVTRR3H2t7e9ED/BukNDhy5ysQTfHXhicqTxWmrAtflxIJkin2KtJWccerpSpminCkEOmVFoi0UZzohZlpUDK5xMjw1D/uOQGTBnwoXteUuc00oxyyScwFpUqy57UWQn7XjfK5YUE1fZu4ul+YU9auqfUwG9NBMSZ+sayUFHf7fYbgeOv2QmdqENzYpFXFYPqoCDE+elvhuoCZacGoPhKnfsnITrZEcKwYtnAkbP1/PXnjTmAbWrQwc24m3l7Br53Jq5ZzLjYktwkMbSAhG2foYRBXNBQbEMOlQ6U5eUOkhhwy3u5d2gLxgyHHREwWuJbCv8FXZ450mKwBGub4J08EgcvUDh6Mc+ZHSom5ygkr/aGlTieQH+lnwMvFf9B2x18Fx06/zfr1RWGEPmya+F+H6qV9WK0+zJZ/ZDLtyFCC/1CnKmgnHikY1Xha/XEifE/jBKN+2qiQrA8UhP1V6upixWT1hiUI+Urg+IeK3ZDRRaAoZtMa1g+qBERO9nDtaZW0fDfxbqcCi1tH4hzkdLPszNYynTNp3h7nPQwMScut5NG+GnQdhBPEMAIqepNWqZFYcx2A/WpCP
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
2.48.1


