Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C116CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9718E0007; Wed, 22 Oct 2025 10:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A238E0002; Wed, 22 Oct 2025 10:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761B78E0007; Wed, 22 Oct 2025 10:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAA38E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 309C1C088C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:03 +0000 (UTC)
X-FDA: 84026019966.10.8CA8113
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id CCAF5A000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oxC3ThjI;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhX8DUNoBhomPVY5+1YgQ4tvspnUYjXPFPmuzkX3zCI=;
	b=MU5QNIkMUpNLq2YU6w0Oild+LPvfVrseVmjE4m+zHMkqraUgmW+70i/XslabaLsfCdc26s
	+uAoJQd6CIuvzgWeOEE+Br6pOohyYi2UVAiQT5wStTtT0yHup7Cxk4pTeF2U/uv6p67Iae
	ya99mNlJoWLh/XZpeNV8iikqxykxm68=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oxC3ThjI;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144240; a=rsa-sha256;
	cv=none;
	b=RUyYt4o3/NQDi6Y1yXP0DJAeN8o+3pBnWoMiZ6+O9KHcymBCZDwg+Tw7+MSeKFs1oIt8I3
	s9wcW7dhzfy1jipbFoKsHCOF4+WIOExiJgKInxuFJJJbLMX+fh/2rC61Bl0CbTJDv4T2oU
	+Q0pp1cn1QXrWH8mIK5lIglD6B7mRI8=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M7oagA013852;
	Wed, 22 Oct 2025 14:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xhX8DUNoBhomPVY5+
	1YgQ4tvspnUYjXPFPmuzkX3zCI=; b=oxC3ThjIeGs6rwgQAlclwwNp1wQY2J1y6
	cKidPU3LDVOUxBy9396OFgl133nuYRAAUC5qmY39Qpk9MhhlWidnrSIk0U0mpaBn
	hZI9rdUziYPJlBHXMHOBJUrzrmuHIr2RTblbuIEK4NK20KTq1b7CPzkHUQ1s1NqL
	L2HVCwoZ+hSXQXEro2HET5SwXjvloi7alvMY/7yEoIYL+7DqFpb5xfE0zxwf6GvT
	UzzQ3mNCKlHsmNY5RKe2O1FsvsTq2FRtVnEfJXGmCynEqodVMi4VhBXR2GVubYji
	UyHtRRx4y8cilkdFrdRFieHCU0q+m7/7JZGYkGKPkRq6c4ou+KszQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vuuy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:38 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEaAwd028211;
	Wed, 22 Oct 2025 14:43:37 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vuuy2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MC1cJ4011030;
	Wed, 22 Oct 2025 14:43:36 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqx18jv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhWOL6226202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C7F120043;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16F892004D;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:32 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v11 09/15] unwind_user: Stop when reaching an outermost frame
Date: Wed, 22 Oct 2025 16:43:20 +0200
Message-ID: <20251022144326.4082059-10-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AGX7kRANlnwklcfxxXI_3EamEqLjBtaY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX5n6eDBHsj5GN
 kV7brKhM7II9kF9AVfv+/gecOrQx/3h7n7h/yV69Y2qCMFfT5RtB6nk97l9WSzVktxemwJ9nHP/
 7Z0iFp0z6irrxULT6+AcNBEq9O8G7LwIVuHWUAtWy2dVKQ5rm9hxoVFJ+hTXkNPHgJ0rUmfQ9OZ
 2tQZu5d1UiGg/DaRr1mc8qC8QDCmInH4sY7EiXffdUXfUwNDvtNNut/nT4oXJrFLBZrUuB5npP2
 zLlhuSUWJsdWEVCBEctMzofal5Uj9QDcDc8o5C5L6FooKysRd8KP5+Yw5/o2svCHzaXs90BU/Jq
 U76iEel8xtm1aSJ0cK6snbuNzJlAbkvhVhcLq0bkuGheoBEI5V9pvuGK4gpNPjCLixxPNyz9j/2
 PM30Lrka8Uj2eFxyWvhfix6VEkZT4Q==
X-Authority-Analysis: v=2.4 cv=MIJtWcZl c=1 sm=1 tr=0 ts=68f8ed9a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=7d_E57ReAAAA:8
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=mDV3o1hIAAAA:8 a=yMhMjlubAAAA:8
 a=VnNF1IyMAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7mOBRU54AAAA:8
 a=_1qlYuAciRtwIPuEvDgA:9 a=jhqOcbufqs7Y1TYCrUUU:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=HkZW87K1Qel5hWWM3VKY:22 a=wa9RWnbW_A1YIeRBVszw:22 a=DXsff8QfwkrTrK3sU8N1:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-ORIG-GUID: Ieoa7oZhDiD0PHF60cjlNj87b-vbuB_T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspamd-Queue-Id: CCAF5A000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 18mgr5gkttjtakpr8wyj4hbwb6pkx4dz
X-HE-Tag: 1761144240-932603
X-HE-Meta: U2FsdGVkX19CPrHJI+E3IFcTfiQuhePd43MpKIzHcoFnCDIC36cLqsvY5BmL6C0uX4kqLUa1zBZpf8jpy9NbWcOanYXa8gipNWvV2XuntEkyuF1yhLtwhomQ/p0rcFo73ax1AO9FKAulYk2Bd5Wx2c4qUblKi06tw0cc/Pjfk7mYXpd7PTbI2j0aalsCk4UQtkemmTB4uE/bw6D1Lvz/SigY/omuRDiI6601udWA9s9yYcTBxcu9bEPMdP+huoaTXUpzB2wwEz+5tGvAPmbrQ9iyZJ+5KuFUp6FXMzdT0FJxfkJ7Qn1SeQIAWqUeymRyo2JsYUl2KBO/fUtyty284AuBxVfqYXi9A4fqVwODZ6KscN0M0/uOkObH17JSFQDbiuiJvdFZ6dYCAerGk5YScae4DD6Hoof8w/5g5lUWdhHJcYWvOWyn7sW8++HNeRGDvXE8VcHiWJ+d6LZWcwgR3S+HO8ega3sNjgEfo+pG83elNdmPQ1fjIyou7vAOQ/xbC50XbJn5b6vJtZjeoJk6Ux/k+4TWZrf0TSZrskgAhTiyq3klwQ972ZA3jNvuy9mJIGqVQzyL4FCnsr8K06Wdk24yNV6Mo9BouZIrHvtMPWdFhATyu/hpLrkIAqhOWEC3d/V6kkCgLGALHcxLkS6lVSKBPq4gOM1KBN1onylU1gqSY+NhtCML1vkS6XH8QicDILU+JG6u2RwSkiBdCIlGiZu6IBMvax9sVrRgsRyf7qMGXljD8bRg8lKMxcDONSkQ2J5AAwrt3x/7mIod//rFhhWdNCLpz9dQsFEN1RP7LD+cv2Cfm3ziRwvzk5QbQHkJhifJ3DM5A2DNjPbWz5WvJj+f9ZSLRhKSeOVaO3XRkcYeTXK81Z0+vP1YLxXPwK7jihbqEuEPzQ/o00PNfplx3cMktbZ0IzE2yZgkbAeUraWvfgTe3B5t9AGCco5fNkbliOorqZ5rgCit0bOAqm6
 xldR9SJ1
 MGE1eivZLQLorYo5jN/KjxjZJ9UzGtWUVJTkuTBZEtBM6fCxiXKdAMCjR7D+x5vUDUlB/ktH3VXLqOxXEDkCff8Zw9e6rKCL3Dt5fmNtzmQmpwbDv9vGdi7vN2x0pVCfevxp+qeS4WtLp3KoTpdsZRd5Ubs/mUs/eO7IxCXNyQhwickeq/TrEQYWZA/1qhXNOixS8kv3hC6MEd7O/cPPnGafL5DfAv8JRvPTiY36HtYKFawsHakemNsGeqzqEct1RPa4JmL1j4nET5e8Sx1SQD8TZ6bMNsL7gqS/ijmFsr4m4vzecd7k5ZK3JLGt23a69olqlAtVzs/vM7m18aAVzVf2LCSupReuRxrCGhzUZjk2NPR0MLwsDFVs+Oq07d6zXta6kvesMmTauYPX0Bqo0+JGFmTeaRhNrazX+FCdMkTRhFpwv3LU6yz2QDje6ZXiQbUau4uYdHRIKml3YImOTgTSxmaTwn79waoUS48xvHFJU/4JMbwes9Y+suQzKl/2VYgZpkmI+PFMbo7MNFRu9Bj02hkk+C4eL7QIVlKlg/5JJdTRF5q6kBsxBRhLEBJtgLqfZ47YtlLoTHE5DaUPAVOOJf443JucO6wyp
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
    Changes in v11:
    - New patch. (Jens)

 arch/x86/include/asm/unwind_user.h | 3 ++-
 include/linux/unwind_user_types.h  | 1 +
 kernel/unwind/user.c               | 6 ++++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 5e0755ea3086..08684bbeff0c 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -6,6 +6,7 @@
 	.cfa_off	=  2*(ws),			\
 	.ra_off		= -1*(ws),			\
 	.fp_off		= -2*(ws),			\
-	.use_fp		= true,
+	.use_fp		= true,				\
+	.outermost	= false,
 
 #endif /* _ASM_X86_UNWIND_USER_H */
diff --git a/include/linux/unwind_user_types.h b/include/linux/unwind_user_types.h
index ee0ce855e045..e07fee69d315 100644
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
index f6c543cb255b..c8034a447c16 100644
--- a/kernel/unwind/user.c
+++ b/kernel/unwind/user.c
@@ -33,6 +33,12 @@ static int unwind_user_next_common(struct unwind_user_state *state,
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


