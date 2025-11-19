Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3489CF34AD
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29DCB6B00A4; Wed, 19 Nov 2025 08:24:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227D56B00A5; Wed, 19 Nov 2025 08:24:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1BD6B00B0; Wed, 19 Nov 2025 08:24:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD31B6B00A4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:24:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FA451404C5
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:20 +0000 (UTC)
X-FDA: 84127425480.21.8B8A413
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4B98CC0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:24:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SelcCS2Q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763558658; a=rsa-sha256;
	cv=none;
	b=O4WMRZTbY19u2nGgXtT+uBhPAHLHheAbbrdNOzbc7iVGglkzo+s3EP1aIj8RZmYBndoLss
	/CgY4O1as9V3LZcM+Nx6ENu6xuM3t19GkRpBaWTleW7zfC1AbdERcCq17HH5O/S16oqSOt
	wbk4WrgHXD8URupXkEaGyHBpdTWi7wo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SelcCS2Q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763558658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNJgzz0krS2ConCdQK9UJQ5jnwsblOsZmcy5cf7ngeM=;
	b=ctz+9PcYS0ISQB1Rb4njpLtMHXAxSKbjrhEr/f5+JzjqVdRHknJJ4zW0U4mhCxn/H40bFs
	Bq9qI10rHCD4JCLUdt425DkN1yVjkhNZlkCgf9ZRfj/uvFV8YSqNNjyxw0+tLBSTFFARrC
	UDhO+dBtARpADHnWAYB3Az/77Yn5G6s=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ8vQ9F007244;
	Wed, 19 Nov 2025 13:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nNJgzz0krS2ConCdQ
	K9UJQ5jnwsblOsZmcy5cf7ngeM=; b=SelcCS2QXtcy4T2YXRxklaNzxBG+FUbUX
	EzSOHCmCMJEPR7FPpMSrlz83nG8KrOIi0dwLoWwZcZr/47B5EYE44b+WMYSjR24N
	sl5OByx9FPbUHiLRGnKeJdlzwMeTXIDq3sdflz/Yi757w+1iweR3A20baiqMEQ9j
	2Ufapug5MPU3bmwokh85PGFjHBuEIO2FLZZsk/k7RIJpCB7Ya/1yMVgK5f6waorM
	2IZmW+Aoy7lhMOGvDKLqnrnvNd6xmDDYLIGrlpLVZ3fqOIf+gA89BFgzTS/xBYFp
	+9Z5AWPh7V8Moh2cBUjJwbZmTAlaVEMUwa69D+Ro7iwNRzks+i3+Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmsqtsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:35 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AJCsBP2015019;
	Wed, 19 Nov 2025 13:23:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmsqtsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJBBSND010411;
	Wed, 19 Nov 2025 13:23:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4af3us8y4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Nov 2025 13:23:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AJDNUSq42860902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 13:23:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 234A020040;
	Wed, 19 Nov 2025 13:23:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99C812004B;
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
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v12 07/13] unwind_user: Stop when reaching an outermost frame
Date: Wed, 19 Nov 2025 14:23:17 +0100
Message-ID: <20251119132323.1281768-8-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251119132323.1281768-1-jremus@linux.ibm.com>
References: <20251119132323.1281768-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qcKsCRgGdXJn90olzyaL8xuhTfECMnlM
X-Authority-Analysis: v=2.4 cv=Rv3I7SmK c=1 sm=1 tr=0 ts=691dc4d7 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=v_yGwNk4s_hqRJXMsLcA:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22
X-Proofpoint-GUID: XXj1-gbW4yNC1v_pD8J7P3UNYUWbpfnq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXz3zsTnOl+jB+
 zCBFf+kNqKNjJX+xmlRzDaagdx2nQnia82+m3KR++R393gmQHhoIPVwKmDPl6hBE2zdiPySQ98E
 GzKbFSWVxv697GqXy4oQDZzwte54Eve9317fBBVll+NGDS0ZUqpb5LWfvVqEtATrnLf2zaSead0
 Jo1Hci0DOdiAA495vUtskLQqfp23MfHxeFu5Vl00354+SQTU+/6yngA+9L2iQedcMpUVE5hYeHS
 tiaHYYewxfU6JRnYtg5vdjc9vrYcEPRVf90X2DgifD7rzznfJlo11/ao4sqN4UAxH6vFdTiRSEL
 gujHEEonJma30KSzAdy2NXyP0o4s5669uHgmhDFoEYynabsYB5I9dUN+s6IQzKfTPntmfU+JvE2
 SPzWzcP4XqVO/5X3+tW/VKlkyX96dA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_04,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032
X-Rspamd-Queue-Id: 4B98CC0006
X-Rspamd-Server: rspam07
X-Stat-Signature: aoo94oizst5pfebufqh6sqyhneijbmdm
X-Rspam-User: 
X-HE-Tag: 1763558658-94740
X-HE-Meta: U2FsdGVkX19KksZYo+ZRdIEzpkIKUlr51k/rq2R8KHvhyCfAC7wkZ7uNR9SwZBMomkjeZ2gplJtTyzqDEnQ2uLPEg9k+tNQ7YAypbk4/ZRAkCclcHYCv1K7Me2CIjNGxlxX1h6jzY/1sRSs2fASpB1yXi27nhJaZjQUHqaj5KPZLZzwJ/nRCK38X8648Sn3WIDRIF50VlC9sORjmxRSNY6uBj7GouZN6JO7eosmMGhfXD8twRLxLIlQn8HYqG5/z+sgiv3CK3HEhA/JpJjHtQOSUcfyQCU6wmhrtEexM3gmcejLwpC/ayl9UcmVKxZKGhgHnkiT8Xw0o7/D4GuI6KzyfCTgoaYB50hlbeXpEZ5IsHH4pjhmV7TvZNMVGKFNbe0OVMlKa3pmew1vHZEdkusFBtiRfAzUkGxfpEDGSuHZYzV+cYZZCC7kGzuoaZn8NCgLaFVON7G9w1QamrIPDViP5DU7RVwfKcvaKiSx6jvAXSYehggozOCZN2nt5fCmtiEftGluZ9y+/r7S8GB1J9Uctyyk4asH3CAMYSc2UqKApLpOlxgOr5ehwz62Ke480aaGgOQVi1dPLjzwLbGLDXmkVM6C+NG8Uo82ofLSVtLMWmqYHv6v+jZiS+aa3N5gT0hsBOe1SGB3ox4yYiCVC7xYMYORUVnWajA/zelkYuVQ4Zl0SKJ0Rv6w5NCKNw2u9rYNrep2kBbXoPUUcaqvUiudhIdDk7JQ8EF8EjthuDB5wvMhk/8t/hLS+8S/4kiWGm2CsZ0QozZKkAhwmcGqaN58x29wzcuKL0IsNwWuws0MQlWSALj2NA+e//DVmhlyWvRTM7gu+qbq/Jp3Dp+LZLhM3D/nEnUwifGGdNH6CNDoPsfhwzXyZ3fm7YEhxVbk0pgOZ3myLHXTo8BDq+r+Cr5hViXYirTBMHVHnzSZoJqemsMnysIK1iZZj/V1G0u5jBob32R2picUVfU/AiXB
 mRmm85nr
 UUpycbMLI2xYyKT97z+viWikjeuSC1+qhmpOL0HRs/RNuObcqbt/kTeunSek2nlk545cZjtZCotfvZ/LsTNEj6mUGWDqZdy7wAJFBUrCO3tnuhJLSdu5sHGI5Eiav4cEi2SQid8inoMiM6IMRti4RoDd7/5y+wvcO8Ne/zJz81fmfHa1kRQUEWJ4fRy+JAElD1GmfV+nUZfZBw0PQ4goABqazQKUos3dPRpZ0WhHVsPjh23jqH0BxOzYfP7f7EUepc+Q3p98MunmBrFvw+fzIvOYqj+bFqI8LYw485GZjA7WaBpaqpP7q3WviQtVeTLVWGB3VhVzW1O3rIz5lHhYa1M0uw7KpORAMvRKUIzAl06vhKoWYuWxa8+3np1Edtm2lo6TrxbE4lueKpJC+008ivZ/5PnJUxCMu1XAFBbSB8TW+4KTcE7qpKkMPD1xsdMnp4zjsxE2XgdmziKk+/M6CSgDLthT/73/rfa1KFXQ5M3yG398ZTYSZD28RfZsdiqhlL8fTUU5wuwF2gTOKABcHJ8zowTKmvsCwk91DkagsZ1A0S1AOVjKcAvYcvckwaUAh8F6CV0B8raQvU7WvY82C7RrLtqNZRlnyhmY9W51BzF3VldWMI7cJdtrFWyhaYvW3GWX+OUBlEa0GLs9IXxeCvoCSrAL+eBY+jFt0u6f9yD7IbEV1BSd6BrnBg7HbmMNCsPW4OJndsZz12nBoz5bJOmYWN6LjzWny3lM1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an indication for an outermost frame to the unwind user frame
structure and stop unwinding when reaching an outermost frame.

This will be used by unwind user sframe, as SFrame may represent an
undefined return address as indication for an outermost frame.

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
    Changes in v12:
    - Adjust to Peter's tip perf/core commit ae25884ad749 ("unwind_user/x86:
      Teach FP unwind about start of function").
    
    Changes in v11:
    - New patch.

 arch/x86/include/asm/unwind_user.h | 6 ++++--
 include/linux/unwind_user_types.h  | 1 +
 kernel/unwind/user.c               | 6 ++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 12064284bc4e..f9a1c460150d 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -11,13 +11,15 @@
 	.cfa_off	=  2*(ws),			\
 	.ra_off		= -1*(ws),			\
 	.fp_off		= -2*(ws),			\
-	.use_fp		= true,
+	.use_fp		= true,				\
+	.outermost	= false,
 
 #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\
 	.cfa_off	=  1*(ws),			\
 	.ra_off		= -1*(ws),			\
 	.fp_off		= 0,				\
-	.use_fp		= false,
+	.use_fp		= false,			\
+	.outermost	= false,
 
 static inline int unwind_user_word_size(struct pt_regs *regs)
 {
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index 43e4b160883f..616cc5ee4586 100644
--- a/include/linux/unwind_user_types.h
+++ b/include/linux/unwind_user_types.h
@@ -32,6 +32,7 @@ struct unwind_user_frame {
 	s32 ra_off;
 	s32 fp_off;
 	bool use_fp;
+	bool outermost;
 };
 
 struct unwind_user_state {
diff --git a/kernel/unwind/user.c b/kernel/unwind/user.c
index 7644ab9f6a61..d053295b1f7e 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -32,6 +32,12 @@ static int unwind_user_next_common(struct unwind_user_state *state,
 {
 	unsigned long cfa, fp, ra;
 
+	/* Stop unwinding when reaching an outermost frame. */
+	if (frame->outermost) {
+		state->done = true;
+		return 0;
+	}
+
 	if (frame->use_fp) {
 		if (state->fp < state->sp)
 			return -EINVAL;
-- 
2.48.1


