Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 717D1D25931
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182686B0093; Tue, 27 Jan 2026 10:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1304F6B0096; Tue, 27 Jan 2026 10:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E424D6B0098; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE48F6B0093
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84F3388E11
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:34 +0000 (UTC)
X-FDA: 84378070308.29.46B7DB1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2215A8000E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ACezbWl6;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbpErXg7HY93PUk7+FUjxM4tE3Cz5WHz6tumO7wQIpY=;
	b=NwUKb0J3+sonDkJkmlScy+QHGjHohaTErMXGbz8Laaa9ijj6Il2VHF+DfwVlf71ZG+vQwV
	ngteC1zfb7La+jKgzowzAzgphdZ1DzTyeCqjVNWMJBU93kOZmRg7Io0/PketfUX9MQWLCd
	2NNDnvDiWHfjKiyTud0+d2ksbVAlbhI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=ACezbWl6;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526392; a=rsa-sha256;
	cv=none;
	b=Lv/dM+qoVBHghDwMRDWSiSz/RhnAffI0DtbY0C1O1onbWFvSPWd8paRpoqCPSds4/ZhlhU
	uj0tTu5UY85iJOyamYIt2xwvqST6PeGzm3o/xBVZGOPzYwtP23QrU1bjfgbFSuemEb0Hly
	OLrH8lqmYj5j+YXUFth/rbpz/3hFGpA=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R8BwoI028591;
	Tue, 27 Jan 2026 15:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=YbpErXg7HY93PUk7+
	FUjxM4tE3Cz5WHz6tumO7wQIpY=; b=ACezbWl6w+Bx12TtXBkF1fItFqrnbAwwE
	a9Jifv07Lw4mtNSN8crIgnafY/RLyfTAgdQb4tu+nFI0lVsTelYs5/YKYUIrB1FF
	dJJ1Zo1eZzxq0MtBbbghwRr76fQq8D+xHFTlZAwC9DdGoIwPUTXYVQPuYIAJ6HCG
	D4NYvnYvbOF7Kb3qHgV7aJVsFtk6uE1e7pVBIAuvw9pw3q0XMAgdYjMPOnP2YsAp
	C1k4DY4T0r7CwytniHUyPvhOrUiuE1gvkXfkDMLAA+EAE6nPy6S24eHT1B3s/yP7
	s4wPyYKmX4TIxngp7IPzEe/wTV921Nka88HjEuQi8pC6MP0fD15jA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvder-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:07 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RF4FPo021920;
	Tue, 27 Jan 2026 15:06:06 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvmgfvdek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60REptcW017960;
	Tue, 27 Jan 2026 15:06:05 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwb41ru41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:05 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF614k31588670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:01 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5550520040;
	Tue, 27 Jan 2026 15:06:01 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F153B20049;
	Tue, 27 Jan 2026 15:06:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:00 +0000 (GMT)
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
Subject: [PATCH v13 11/18] unwind_user/sframe: Add .sframe validation option
Date: Tue, 27 Jan 2026 16:05:46 +0100
Message-ID: <20260127150554.2760964-12-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Z4vh3XRA c=1 sm=1 tr=0 ts=6978d45f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=meVymXHHAAAA:8 a=RXKZOtKmAAAA:8 a=X__uKv6Ezr3YNgStCWAA:9
 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22
 a=wa9RWnbW_A1YIeRBVszw:22 a=2JgSa4NbpEOStq-L5dxp:22 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-GUID: 8CIGiFRntDNEIVuUfDBRFak6N5_snaXU
X-Proofpoint-ORIG-GUID: HXV_CBhSVc9DXg5rigLHd-wDWkUlYZuK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX79+Ow3UZoRu4
 Il2uCK9/SM3NUUG4G4ddQ6vPPpHwahJ0sBNDL29v7uGb1pPtnaLrrt60NZNj2FHtfkfDtBcYepR
 GMzDSglFjkT3jRCDGTGEO0p6QDX75oROSY53MG4pBD0QCFy6pSOikW4NCwFTWF4d7rOalIBTxwj
 8Sahc4tv9NyO2ocdLoJDR1tZpL930JS5PVXpwoonqDJUuhNlgt7eHH4dIeUNEX+25xTXTzW0Tc3
 2ugQSGJBigxVSrLd8gpvLVvmIc8Hmv4WuZ4a4YjVznWRzZG1eXB9uyVD6NV1ej3yIs4/RmY1M2j
 zZaRxWx3MVeb0j08bhEef6Y6aM9p8RM86B3l40S5aE99ZPA1pNbUfh6/CXB2qx1djRp8H5qZ+Cb
 chpKZuxa7Tp+56sJYwxgB1RgL9ZdhPdjCABH+vK70TVFG6GgvsbOtI7EZqW4Lql/XEwntlx2dJX
 AdwFDuAy8QN9qfp2i7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601270121
X-Stat-Signature: ss9y4amj6b6qzdxj8myrw14bdr6rzepr
X-Rspamd-Queue-Id: 2215A8000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769526391-847490
X-HE-Meta: U2FsdGVkX1+EcSXUHNZX74NjamMpLsUcuYlTR4qzcFPaA6W/BFx2m6J3L6NhNhlvEq+ura6I6pq0SwxilALbxqVZXMc3ifDpWpdy4vCxyhz6jhVBgDZ7F6x4YTdFEcEh+lIqpBujaEuNhoBQcLiIisULbGi3LMjJXUkGMin7rm5/vmZE6ensiSSuU+mCjTg2ceuLZeL8pG6oKnJH6USvtjiS0yzgLj9kjtJj1te6w1kV2NSI0TsBZfa7hA1lUy5J4ROuJqjr1gqYya/zW7fkkSFh6m5pdbxjjh7WPWbJFXJGOU3ZU1kVTnIR+h2qGTK521STeB5deG8UdpJZATNiMJSnAG+mY6hqDkdFWry/D3I4Vpn/p/vt6TVJOnFuQxxxXi+gHXtc0M+4gipUkNdHVvr6fO6U/Wu08Fz5bqRZ0JY5MpOu9vPMsWy2CpbAR5ffwvBFTXOd7PKsCRkPN46KIJZpFTQVwszzoc9oUqY5EDbZLxw0bKBi9pxBjDjujniF6GCv0r2XUmizQFdDCFLndNx4DEQgvhmEi58CrrSnKy97f57WG+4ZMRvFlKvO7ZaNQ2V4PQZ4YMtGqAT8xMTm+X8Ak20GiDp8VRc4XsPavcnnrbYFq499RTuj98CjnJPuouzaFCuNsbSSegDKkE87JdfP4Ef+ZOlyZq3jxsqhLkQ2n0YRrTjHHi7VNAmW8i4egxI6N4lLDQ9Ffve5w5gHoxmYKrchsJckdn2xLcAEkxC5tHL7uWC0wk3qNiVgXkC8p2IpXT5FUJfrwRnoeSC+afIbuJ8maj4f3lSlmCMwCIslB5FVc45/bXsH57cfvNNdRgKmmk8VrJ8qGlwBMzN+KiZn2iHBT1nnmr2c7LQrPrbED1/0OnJvMg2DLnjICVsYcZcnuUUGjDFqkZ16yrPOMsk90yyNy18kv7Hrb95C6Kt4bCAAhAKOzRAvw/E8Dd2FPbYHRKfExUZStm549UZ
 qa+QXpio
 tv20m+MCC8z4xRNIWJc3Jzp5x+XXXuK2pZFRSzS7Mf2g4X0TCBxcM9sMdKjz5IpnjbLDjFu7Olyd79r8jfPgoFfIZIPkpItUtnTB8svl3DzYzwKk9+/qft49NB39B3JW8h7h5yd9gWuPNSjgQrpJd9yy31B4gjPoG+veUwfYZrbBOeEBd2HqCZX50nwKEQNbEhLCETJx1AHilkgyX5haWjpk7VAnNNaZ+5RsC2WwhL/jA3pGqWoTe/RLv3dtIpN2qLEnnDhZccCqrsn+AIZ0GRyZoSirQ5dE+Gz0nUjUQqMvtyt06xFn2EEMDiPE1E6+LO8j1vGheMOpVZXHOqT2XzT7zBl6+1GiLPg0hasdJJ7c6d6tJAkib/1QeNeV06gPWR9TAaAxyVSf6sscCryjorpZFwCpTGBrPTnLi7N92i8n3a5u5MZkXJidP/0mQDY2fa3k23w1wrK+Prl7RCKhBnPOJKJ287nNWVk9gvqdIdaUVeH21z9JIfBo3bizR5TCF5td0fbA40wNgMvBLnsyTfb9shcFeB2pQHs3HF6NUm2k8X9a81/TFAReGeAL+BQcYdH5txaXNMCgdUKn4xp7Ztn5b43ojM61X4N3/RtSTiiEXJeBZCFjcBq02XOxq7Bn9iNmF8Rdnn4fofr6Kyw0V1k2UQrELbL/aEpmMVpIANb7MqYFsa9EwqsTBmlaq9h3nQV+K9G9L53D9uHkCk+7CGYp870JK+oddg4RSFZM8IBfh7TQ6V8B4msxsHacDC5uT5yzAs6S0hCgGWlIN3BWEVFEvcb62QSSMCX4iLCS9OqV3eKibm6lB+rpd6t5HF+HhhRAt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add a debug feature to validate all .sframe sections when first loading
the file rather than on demand.

[ Jens Remus: Add support for SFrame V3.  Add support for PC-relative
FDE function start offset.  Adjust to rename of struct sframe_fre to
sframe_fre_internal.  Use %#x/%#lx format specifiers. ]

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
    Changes in v13:
    - Update to SFrame V3:
      - Print struct sframe_fde_internal fields fda_off and info2 in debug
        message.
    - Adjust to rename of struct sframe_fde_internal field func_start_addr
      to func_addr.
    - Use format strings "%#x" and "%#lx" instead of "0x%x" and "0x%lx".
    - Reword commit message (my changes).

 arch/Kconfig           | 19 ++++++++
 kernel/unwind/sframe.c | 99 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 2ece3df821b5..dcb553136e0c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -490,6 +490,25 @@ config HAVE_UNWIND_USER_SFRAME
 	bool
 	select UNWIND_USER
 
+config SFRAME_VALIDATION
+	bool "Enable .sframe section debugging"
+	depends on HAVE_UNWIND_USER_SFRAME
+	depends on DYNAMIC_DEBUG
+	help
+	  When adding an .sframe section for a task, validate the entire
+	  section immediately rather than on demand.
+
+	  This is a debug feature which is helpful for rooting out .sframe
+	  section issues.  If the .sframe section is corrupt, it will fail to
+	  load immediately, with more information provided in dynamic printks.
+
+	  This has a significant page cache footprint due to its reading of the
+	  entire .sframe section for every loaded executable and shared
+	  library.  Also, it's done for all processes, even those which don't
+	  get stack traced by the kernel.  Not recommended for general use.
+
+	  If unsure, say N.
+
 config HAVE_PERF_REGS
 	bool
 	help
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 3276aa6d0c77..cf353bdbc907 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -367,6 +367,101 @@ int sframe_find(unsigned long ip, struct unwind_user_frame *frame)
 	return ret;
 }
 
+#ifdef CONFIG_SFRAME_VALIDATION
+
+static int safe_read_fde(struct sframe_section *sec,
+			 unsigned int fde_num, struct sframe_fde_internal *fde)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fde(sec, fde_num, fde);
+	user_read_access_end();
+	return ret;
+}
+
+static int safe_read_fre(struct sframe_section *sec,
+			 struct sframe_fde_internal *fde,
+			 unsigned long fre_addr,
+			 struct sframe_fre_internal *fre)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fre(sec, fde, fre_addr, fre);
+	user_read_access_end();
+	return ret;
+}
+
+static int sframe_validate_section(struct sframe_section *sec)
+{
+	unsigned long prev_ip = 0;
+	unsigned int i;
+
+	for (i = 0; i < sec->num_fdes; i++) {
+		struct sframe_fre_internal *fre, *prev_fre = NULL;
+		unsigned long ip, fre_addr;
+		struct sframe_fde_internal fde;
+		struct sframe_fre_internal fres[2];
+		bool which = false;
+		unsigned int j;
+		int ret;
+
+		ret = safe_read_fde(sec, i, &fde);
+		if (ret)
+			return ret;
+
+		ip = fde.func_addr;
+		if (ip <= prev_ip) {
+			dbg_sec("fde %u not sorted\n", i);
+			return -EFAULT;
+		}
+		prev_ip = ip;
+
+		fre_addr = sec->fres_start + fde.fres_off;
+		for (j = 0; j < fde.fres_num; j++) {
+			int ret;
+
+			fre = which ? fres : fres + 1;
+			which = !which;
+
+			ret = safe_read_fre(sec, &fde, fre_addr, fre);
+			if (ret) {
+				dbg_sec("fde %u: __read_fre(%u) failed\n", i, j);
+				dbg_sec("FDE: func_addr:%#lx func_size:%#x fda_off:%#x fres_off:%#x fres_num:%d info:%u info2:%u rep_size:%u\n",
+					fde.func_addr, fde.func_size,
+					fde.fda_off,
+					fde.fres_off, fde.fres_num,
+					fde.info, fde.info2,
+					fde.rep_size);
+				return ret;
+			}
+
+			fre_addr += fre->size;
+
+			if (prev_fre && fre->ip_off <= prev_fre->ip_off) {
+				dbg_sec("fde %u: fre %u not sorted\n", i, j);
+				return -EFAULT;
+			}
+
+			prev_fre = fre;
+		}
+	}
+
+	return 0;
+}
+
+#else /*  !CONFIG_SFRAME_VALIDATION */
+
+static int sframe_validate_section(struct sframe_section *sec) { return 0; }
+
+#endif /* !CONFIG_SFRAME_VALIDATION */
+
+
 static void free_section(struct sframe_section *sec)
 {
 	dbg_free(sec);
@@ -476,6 +571,10 @@ int sframe_add_section(unsigned long sframe_start, unsigned long sframe_end,
 		goto err_free;
 	}
 
+	ret = sframe_validate_section(sec);
+	if (ret)
+		goto err_free;
+
 	ret = mtree_insert_range(sframe_mt, sec->text_start, sec->text_end, sec, GFP_KERNEL);
 	if (ret) {
 		dbg_sec("mtree_insert_range failed: text=%lx-%lx\n",
-- 
2.51.0


