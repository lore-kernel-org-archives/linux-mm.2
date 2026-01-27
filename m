Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85FFD2F033
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C296B0099; Tue, 27 Jan 2026 10:06:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479206B009B; Tue, 27 Jan 2026 10:06:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0866B009D; Tue, 27 Jan 2026 10:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 169C76B0099
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DF308B42C8
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:36 +0000 (UTC)
X-FDA: 84378070392.26.C25BD39
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5CC6CC0006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="FT7kiZ/m";
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CEYS4jY8hNAdRrKUOU+/JGW1W2bTK/np0UbnjKAxFY=;
	b=M3cfrIDXWRnWbU6NjJwNpB6rnzy8l85N6Rd57hQNgFGXD7356gtNHEynKszKveQAC2hUHy
	rzFPvuRu9vpGL7uhH8WVbDF6HcBvz25UfKHex/UOSel47Du8GUY2D4swk2UsESsdgRBLpA
	E2DURKsO8Iz2U6kwMKCoP3vhzchd1LU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="FT7kiZ/m";
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526394; a=rsa-sha256;
	cv=none;
	b=az70Qw0Gf3tjB9FW7LvOL2F/9KMk7igAO95MPZJwEPY4tAh28ySQ4CTnk4s+fh6PPPdOOJ
	+LcHyrnzmjz7sOAxmAmt2sHv6QOnZukapflCBcmBc9L8sa/N3aFCzvkx7M0nq54H9M6Xml
	Qrs0k13+h1BpsRwVTdcIZ+1r5K/dZy0=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R33kS1005587;
	Tue, 27 Jan 2026 15:06:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/CEYS4jY8hNAdRrKU
	OU+/JGW1W2bTK/np0UbnjKAxFY=; b=FT7kiZ/mSXlUGR7J3WsyGi4VWxUxy/ITO
	6G/Tv29XBLqrUNvtGzFPzMo+KY0MKL8xz9Qfq/19fEt/lxJ5Qi8ZwBs8XLNX0dqd
	RqOzA75HGmLRqvXB3IUr7farlObS+NHpWaTo8u0eaKgfOVa+x1qnHeD87HSNNREv
	v/+OvCxF2ig7DtbMb7TvcVZO7e6UZh5RmI8VyAKSLzjA639fg8tc0MAdPWblkZ9Q
	N6oOWAu9AM5Y9fWrWWk/5cSqUF8nHsbIv96yPhkXwqMrNEQsgsho/jV3QyN3ub/L
	X9/+pWHi22gjLe6nNNzEE07kXtEgwxQ29f0fWG+UyIpNfsVVxh96w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnrtdygr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:09 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60REl1we004130;
	Tue, 27 Jan 2026 15:06:08 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnrtdygg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RD5sZK031040;
	Tue, 27 Jan 2026 15:06:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bw8dsh6cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:07 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF630m27328962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:06:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 623CA20040;
	Tue, 27 Jan 2026 15:06:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0412D20049;
	Tue, 27 Jan 2026 15:06:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v13 16/18] unwind_user/sframe: Separate reading of FRE from reading of FRE data words
Date: Tue, 27 Jan 2026 16:05:51 +0100
Message-ID: <20260127150554.2760964-17-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127150554.2760964-1-jremus@linux.ibm.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SxjsYwA1yXDXlqfI_eZ-2rQJjp6_np8F
X-Authority-Analysis: v=2.4 cv=Uptu9uwB c=1 sm=1 tr=0 ts=6978d461 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=RXKZOtKmAAAA:8 a=DUHKQo4JlzHLUktqRlQA:9 a=jhqOcbufqs7Y1TYCrUUU:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
 a=UFF3uGjEBZWolfm0k6KQ:22
X-Proofpoint-ORIG-GUID: fzlXu4Q1sRnRiPU-AXpnORpn3NNFMVir
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfXzioM6+7hU7xI
 /sMkYBqjJzi0bM7vkEHSWbo9KtL2QDd8gA13CQ1g/fn7oG37vvxkz2HZgYEma7S/SH8b7i4JL/D
 lVzJUMS0vMpgCCSm3B80VcsUcSodV2B55jE1e8h3Qf3QpEYQEcSlBbfxvCR593aWqCePmrvaNcK
 L5EQqE6bvzcifmYvzesAQgBPOV3nIGzNn5EiLg12Ir8EQnR+99+dtDk/RW0kSOavNO9T23utAe3
 LJXZjJ3Lk0kew6LdxNDSzJkSiGc9GrOZfoqnisG1wCcPgdk16KFtHoTP86tE9L+M91orCZ5DNkH
 TtkNHOOerZV1ULJs4wBun6htyR5h+0qnVi6vcnTlSC+M4WJVMfXyrZIdJptf3xsrBx+tdREkiAT
 zk6d0iKRmO4QmD6FIrHMHXM+/P/LOcLCzzC+cqc1qAgc081XX2Vjd2Cy6cabMW7iyVz7WkI7+CQ
 vTJlzE2hZ0jbw1o+l6A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5CC6CC0006
X-Stat-Signature: fuqerko1ybr76mx1cfi4yyg476o188ch
X-Rspam-User: 
X-HE-Tag: 1769526394-276876
X-HE-Meta: U2FsdGVkX19+QzsYXELqpWnJ0bk1XBfC9UadQlnLKsbfQS6kgb+c2DDeNlTokp1uAS1VRw+F1yRFDi8MnO7w2QjtEvozrpeVyktyjz0smLLfojr++MgrichBmQybXWSnbydrmDWjnRZnYw7siEF2NibEIaxYkxkd/6xfB/nh3zk1LVTZ7hoEYwIXhgMOca+SCxaAot7Jp3IYvCCXBFvOu+GR2D81WltpT5OY6KpMf2NQG9SbHO2K0gWvwttVMmGevuOwrGTuVou2JcHGJ7CBCGNyh57AThsZ4pw7fQdWRThwfW3KhRQs42l3VhWtIQVW6ESp6LpKebWgbA4GRkEvgs3odjYt6wNpcTxGiBOk8hQqi3bmr4BqpM0tRhmLuAOjIaptveloj1SAD/SEU/Rwe5kJeY1B3cLA3jOYsSFlxzdIF+Arnvf0xeG32NuyJYchpchoB0HiGnROnxfK8z0zKMqyguz4nRFtg0NllzeqQ0ellTsr7vOw9V33x89aaOe6tCFSOsIONXs3jD5/ghby2bOQJ+uAgX3CQB00eKv2+L3VnlDdlnne51NT0mnK6kVNbpLnOXGUlmGBxz7/J5dH93ehaBlE8datW08KtG1yyXoYspEaAJlIs0ytAuxmBNRSgTW05UsQFsPK3bWMbYumlm6BnCFOko4tgCRMHfde4YAuSS3/XsarkkV+daBlONQkZIe4ud6US3rG2DhX+FKU3W6qh124qerW8iSVxK/YXeJpH9RZnxvIrY9MSDTKrs4+tyHIp/yB6JVPPX/rYUEyTHcSJ71RXjsztnKvyeV1Xco71VqxWIcOktWoJRCalyEH2vzIJia/GK45XDsw5UAIZIS3ubZ2rmMpYj1gOQdIl8ArVru/ju7n894JHFST8od1+rii8ow8eoswrpk8idixQ5x1sb7D1kAPnmoZBjMiJbGEqWir7n0pi898JU6m6HlkrhnS4B9lTpNbzOZd7gI
 6XxhSjl3
 SNHzF26G4Pq2BGSz1N3cUZUqiggNMqE6yGy7lmbDn9dwEgDd9nBWtf9gkKC8JP3DG5EwVtI7mY+loRLEC88rtMqEWvGSMdjRf+a8mPGze0huWK0JZyTk7QpKakAwroQ6e83o3HUUJN1reNPX+ViQ9Vrgs/A1H7d1miBTPhhVFM+pTgcsz3kPggCE8ebYAC2N7b42/GNMfaRfgfIMuZ7SZa5Uttl1WVRtSOh18pxDRxNM1HPC+05eIwR2SNll+I6sxQ5jV9NN2RDLchdjbWi//whZfQ/Vz0cGxIYgZyRXbUEWmRRFGkhIqmp8mXO+M9LyT+h1l94mJwgnnTXYLjFy6evQwC6HPm3/DgNCwFr1bQsn+/GSs6Bw1SJc7feRPM3diUgew3m5m1IVm1TX3S220RnLwdkIirkjecEl0I5aiVlqDAXDjAuRyBOyOy8SDJzqm5NWW6iJIhrMRRo+WvaS6zDgWdp3akq2Q2T3XGI+NIm2YwsRffNsPGHkrBst2nWrGNTuv969vKcjtZK1bTmXtMiqpSNSviuhiA8+Xira+vyawCRNSjVkbazxbOUdtLrZLC4jbJhLYxHgX0X1/ruYhKEOpSyOz1c8PUTa1v+nkyhfcfy5PowMkgyWcRLlfEC0f59YG5oIRbrAPb69TrfqhoVDms1IABwowO4rqFUZV58nR6o6HVZykSqtV4Zu5E9JQDv3ylZIW6TvfmZqv7GUry0oH7uZI2ijqjm+eBmr3KxPvv4dqnze6CTRo1TEwmdFpfRJP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__find_fre() performs linear search for a matching SFrame FRE for a
given IP.  For that purpose it uses __read_fre(), which reads the whole
FRE.  That is the variable-size FRE structure as well as the trailing
variable-length array of variable-size data words.  For the search logic
to skip over the FRE it would be sufficient to read the variable-size
FRE structure only, which includes the count and size of data words.

Add fields to struct sframe_fre_internal to store the FRE data word's
address, count, and size.  Change __read_fre() to read the variable-
size FRE structure only and populate those new fields.  Change
__read_fre_datawords() to use those new fields.  Change __find_fre()
to use __read_fre_datawords() to read the FRE data words only after a
matching FRE has been found.  Introduce safe_read_fre_datawords() and
use it in sframe_validate_section() to validate that the FRE data words.

Cc: Steven Rostedt <rostedt@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
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
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v13:
    - New patch.

 kernel/unwind/sframe.c | 91 +++++++++++++++++++++++++++---------------
 1 file changed, 58 insertions(+), 33 deletions(-)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index ebf2a2905c5c..f24997e84e05 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -39,6 +39,9 @@ struct sframe_fre_internal {
 	u32		fp_ctl;
 	s32		fp_off;
 	u8		info;
+	unsigned long	dw_addr;
+	unsigned char	dw_count;
+	unsigned char	dw_size;
 };
 
 DEFINE_STATIC_SRCU(sframe_srcu);
@@ -196,11 +199,11 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 static __always_inline int
 __read_regular_fre_datawords(struct sframe_section *sec,
 			     struct sframe_fde_internal *fde,
-			     unsigned long cur,
-			     unsigned char dataword_count,
-			     unsigned char dataword_size,
 			     struct sframe_fre_internal *fre)
 {
+	unsigned char dataword_count = fre->dw_count;
+	unsigned char dataword_size = fre->dw_size;
+	unsigned long cur = fre->dw_addr;
 	s32 cfa_off, ra_off, fp_off;
 	unsigned int cfa_regnum;
 
@@ -242,11 +245,11 @@ __read_regular_fre_datawords(struct sframe_section *sec,
 static __always_inline int
 __read_flex_fde_fre_datawords(struct sframe_section *sec,
 			      struct sframe_fde_internal *fde,
-			      unsigned long cur,
-			      unsigned char dataword_count,
-			      unsigned char dataword_size,
 			      struct sframe_fre_internal *fre)
 {
+	unsigned char dataword_count = fre->dw_count;
+	unsigned char dataword_size = fre->dw_size;
+	unsigned long cur = fre->dw_addr;
 	u32 cfa_ctl, ra_ctl, fp_ctl;
 	s32 cfa_off, ra_off, fp_off;
 
@@ -303,24 +306,28 @@ __read_flex_fde_fre_datawords(struct sframe_section *sec,
 static __always_inline int
 __read_fre_datawords(struct sframe_section *sec,
 		     struct sframe_fde_internal *fde,
-		     unsigned long cur,
-		     unsigned char dataword_count,
-		     unsigned char dataword_size,
 		     struct sframe_fre_internal *fre)
 {
 	unsigned char fde_type = SFRAME_V3_FDE_TYPE(fde->info2);
+	unsigned char dataword_count = fre->dw_count;
+
+	if (!dataword_count) {
+		/* A FRE without data words indicates an outermost frame. */
+		fre->cfa_ctl	= 0;
+		fre->cfa_off	= 0;
+		fre->ra_ctl	= 0;
+		fre->ra_off	= 0;
+		fre->fp_ctl	= 0;
+		fre->fp_off	= 0;
+
+		return 0;
+	}
 
 	switch (fde_type) {
 	case SFRAME_FDE_TYPE_REGULAR:
-		return __read_regular_fre_datawords(sec, fde, cur,
-						    dataword_count,
-						    dataword_size,
-						    fre);
+		return __read_regular_fre_datawords(sec, fde, fre);
 	case SFRAME_FDE_TYPE_FLEXIBLE:
-		return __read_flex_fde_fre_datawords(sec, fde, cur,
-						     dataword_count,
-						     dataword_size,
-						     fre);
+		return __read_flex_fde_fre_datawords(sec, fde, fre);
 	default:
 		return -EFAULT;
 	}
@@ -362,23 +369,11 @@ static __always_inline int __read_fre(struct sframe_section *sec,
 	fre->size	= addr_size + 1 + (dataword_count * dataword_size);
 	fre->ip_off	= ip_off;
 	fre->info	= info;
+	fre->dw_addr	= cur;
+	fre->dw_count	= dataword_count;
+	fre->dw_size	= dataword_size;
 
-	if (!dataword_count) {
-		/*
-		 * A FRE without data words indicates RA undefined /
-		 * outermost frame.
-		 */
-		fre->cfa_ctl	= 0;
-		fre->cfa_off	= 0;
-		fre->ra_ctl	= 0;
-		fre->ra_off	= 0;
-		fre->fp_ctl	= 0;
-		fre->fp_off	= 0;
-
-		return 0;
-	}
-
-	return __read_fre_datawords(sec, fde, cur, dataword_count, dataword_size, fre);
+	return 0;
 
 Efault:
 	return -EFAULT;
@@ -455,6 +450,7 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 	bool which = false;
 	unsigned int i;
 	u32 ip_off;
+	int ret;
 
 	ip_off = ip - fde->func_addr;
 
@@ -492,6 +488,10 @@ static __always_inline int __find_fre(struct sframe_section *sec,
 		return -EINVAL;
 	fre = prev_fre;
 
+	ret = __read_fre_datawords(sec, fde, fre);
+	if (ret)
+		return ret;
+
 	if (sframe_init_cfa_rule_data(&frame->cfa, fre->cfa_ctl, fre->cfa_off))
 		return -EINVAL;
 	sframe_init_rule_data(&frame->ra, fre->ra_ctl, fre->ra_off);
@@ -567,6 +567,20 @@ static int safe_read_fre(struct sframe_section *sec,
 	return ret;
 }
 
+static int safe_read_fre_datawords(struct sframe_section *sec,
+				   struct sframe_fde_internal *fde,
+				   struct sframe_fre_internal *fre)
+{
+	int ret;
+
+	if (!user_read_access_begin((void __user *)sec->sframe_start,
+				    sec->sframe_end - sec->sframe_start))
+		return -EFAULT;
+	ret = __read_fre_datawords(sec, fde, fre);
+	user_read_access_end();
+	return ret;
+}
+
 static int sframe_validate_section(struct sframe_section *sec)
 {
 	unsigned long prev_ip = 0;
@@ -610,6 +624,17 @@ static int sframe_validate_section(struct sframe_section *sec)
 					fde.rep_size);
 				return ret;
 			}
+			ret = safe_read_fre_datawords(sec, &fde, fre);
+			if (ret) {
+				dbg_sec("fde %u: __read_fre_datawords(%u) failed\n", i, j);
+				dbg_sec("FDE: func_addr:%#lx func_size:%#x fda_off:%#x fres_off:%#x fres_num:%d info:%u info2:%u rep_size:%u\n",
+					fde.func_addr, fde.func_size,
+					fde.fda_off,
+					fde.fres_off, fde.fres_num,
+					fde.info, fde.info2,
+					fde.rep_size);
+				return ret;
+			}
 
 			fre_addr += fre->size;
 
-- 
2.51.0


