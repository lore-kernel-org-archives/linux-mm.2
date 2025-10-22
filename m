Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C8FCCD1BC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B118E000D; Wed, 22 Oct 2025 10:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5228E0010; Wed, 22 Oct 2025 10:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C998E000D; Wed, 22 Oct 2025 10:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EED718E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:44:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B64151A0883
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:14 +0000 (UTC)
X-FDA: 84026020428.16.87E51C7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 57815140009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:44:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oLJt0Qp3;
	spf=pass (imf23.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761144252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZDgkDOOw5nbm5xw1iPAGkFIssnW+cMSNoi3V1QctE8=;
	b=ABH8P8JPN0JQsBxOC8gxl23S2sCK4jSIz+9b5IKfo1ma9psoQ+TxhejsgMxi7+t3d2q1IP
	fuBLlSx4j67ehpbvanpBgJ5Rb8OLLkQvr0zj4//XLxq/oRZRD+DR5tgl01B2FF2nhdzRvM
	devwix+omDG1MWT2nJDPpKiEUIGJRPA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oLJt0Qp3;
	spf=pass (imf23.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761144252; a=rsa-sha256;
	cv=none;
	b=HyuN8JmVmMOfqczeMejcKaZlIzyr/qASX+Bwpip62W0qLpvnOre4/KyF+WcHZpnKWFM2mc
	VY+8HsySlVXCSVFotIc0UeygyjZp3eMim1IO8L+Oyi48hkk3YfQWGHLrk9v/u1cw4+BS1I
	v3nl4OaHoRg8HKIZ2xH7hyfZrzBsJV8=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M6U5qS028877;
	Wed, 22 Oct 2025 14:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gZDgkDOOw5nbm5xw1
	iPAGkFIssnW+cMSNoi3V1QctE8=; b=oLJt0Qp3vZoTjiG2gUUkuatI7j1wxAvCM
	6PQTRkS51wuo4V2STXW3QysG6Or7JQQuaO4RG9mJa8LfBPCd33t6j5dk0DuIEWKA
	PwBgN4h1sDLUNTRug+pktKMyF++j2Y7BWYDll2oJrSWsZj00ouC+mMIFkyrRO3Rz
	C8gXm30gQv4ZNMMtFfnvvSAvpA3HhIUYjsHm7eWMC6mxyHWW4auhQ2Nct3SLPLDn
	xWqKQjqXqv68VsMMUUz0smGBpsuMB/j2W99HDh1wHA5duERv4hdE+N2jXgFJhqxD
	zV5XylIHUTMvUqC8OyK97YSm0RlVSpS5TYbiH4ZGhtHgEfNuAvsGg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326w91q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEe2NL003565;
	Wed, 22 Oct 2025 14:43:34 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v326w91k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MBbKpi002306;
	Wed, 22 Oct 2025 14:43:32 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqejgnrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhTWL38142220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:29 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35F1B20040;
	Wed, 22 Oct 2025 14:43:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C490E2004E;
	Wed, 22 Oct 2025 14:43:28 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:28 +0000 (GMT)
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
Subject: [PATCH v11 02/15] fixup! unwind_user/x86: Enable frame pointer unwinding on x86
Date: Wed, 22 Oct 2025 16:43:13 +0200
Message-ID: <20251022144326.4082059-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022144326.4082059-1-jremus@linux.ibm.com>
References: <20251022144326.4082059-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=EJELElZC c=1 sm=1 tr=0 ts=68f8ed96 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=VnNF1IyMAAAA:8 a=EodaETWhB019NyyF3gAA:9 a=1CNFftbPRP8L7MoqJWF3:22
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX0e7M9HHbi/Ac
 yXgYqV9qImq8zuLhOKbEd6GeVocaYzVK0ttCaML7f7/nYKSTj2VS3+z2r741Qq4G5SlxtyfxH69
 EIs3SyY/qbBwS+trucji5GaZ07jDw0Cp6bokiejvVD/nDWPZpi+6afYIIg9uapbEotJqNhXDYhK
 u9i7e5LiYzJ/JHpfi8pkCPfD0qf19fKgcZBO3qIRYjdaVIMnOIXfYQUvrn/eIQNGsSrZ5F0sBtE
 kGmt2EVdZYk0zmqyEQJ3hkyHLpR/LNExWpAS1mghNZNAy9uYkx48GDFCZK9X7bfhYIEpG+/iYiU
 hVYwrH7p6FShUybStFvhxuCnxug3NE7IJs3jnjPICh29j+ssoWZVArQg0S4twocd1V6eY+ifXij
 feL79YbOmhQE1prvqTpxmlZThzFqBg==
X-Proofpoint-GUID: NmoAHBvx6InKILozZL_2rsdLN-CEPWYt
X-Proofpoint-ORIG-GUID: ZxbIuIINCOGS6XvhKI4LBspJ5bo8Ej8P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Stat-Signature: sst53oiimj97naij8y76ro9wdbjmo6zt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 57815140009
X-HE-Tag: 1761144252-156450
X-HE-Meta: U2FsdGVkX1/O1E1TIung2lxOW7mV2TV7aj6VP4HHrKpA4OwBXDOEki/Eyy7ypO8fyDyvFNfRH/OurfGaK7GBxBTK4JdqFlPn1wkZhjaolM3Apy1MYWkXHoBMvfp+BZBme7Xp75NJDyDfgW2F/7D7h6jB7m6SLt1EOxVbndaefLBWNLlG820ZV3f9GzwKa9OvZDTFZs1p/GpCKbHGYAaeovA2i3bWUqTEN9OpIklNttdeysN/O6jmCtBUd+j2kk7qUhEzPhzjgc6PKgc6B1fqdnxni7QSO6yBtuDU8X5ShTbKFxJMmtLZKLItzDsoVnNnsjK3+q++QTpEIRlHK8q4LU55f6uKRK66eWJmL6XFKBnDgTCQRn+XvpDKZ/sYVD4dZN2CnbhTLvXZnzZPwL2uKXsyiN9/qTxBwh6RacuiEfzYxbahKrdOOnFocW3DiCHmy2T4QN5RFUIj12rfVHF1EdxE/mBlW1F0Yeub6vqLSbv+6pjQf89Pnu3h+R9+RXP7+4C36PeydDHV3fa/b+7w7C1QO9PpJsB60daYLP2fa2jgYpBkI/HZFgoMnI92QVYLEZZqoCheJrIbHW2OSN7amUFgsJwBmsOmxpDhD/g2syVyagTw20OwKOi9FENcDyw3/RX9WxN+mjhajnzrfQ8CpJ+5uVtTHvDwPTpqzmpx8/IHnPdyvpzRXY52taF0DBr3oMji3gHkMnGXEqXEWOhtvfNpIK9MbzaKe6b4UalxPGzIheRgEgXoa9zSDHC151QZCGN/ppXGCHrS76dyLQYlURDNBT0TwoAJhPMErAx+km59fti0fG9VO6qhkF2duEk3zNF+vuM7iLRW10DUGEduEshD91dD+u+50pq9OzmpWnBRcJvtqVPeZjJMjKbXq7MC+r5escfOtiCpawu4aoaX4o70/2tvYzPs7F6AVrQv/Do0pXSCQfeaIKuZHx3VSncRXVD02osLFAunN1Vj+T0
 lJBLgmbE
 Chn+8p72TOpgWIM4Kbn8UZoURGup6dj7BvZqNZyl9i/E/JJBXpTHrvsvE3Y9oh/mUVMNNYwv0iDuFqtPj8KyG5qkDz99RdtkbqIAyvGlaM0DLhCTLPhsznfCucuv1qyUu/9Qm9NJdqdx9oYjI1J+vM95xSmV6LxHzmHI+FQ1vVxEq8Za6vXuFmPh+Tw4IjLMtQUvWWzJM+r+BmZiKdKu9SoRz+SmryHugG5oyNkbKUY/atCcosYT8a68od4uxBYgV0Ucb4H8b8H4v/VcYEIMgXsXYC00zq+bxhYSaAkxYkQrin21cWcmx1XKYvRB+Wi7isvVgqTQdy9u+J8PPkl7Q9OhSJiVk9h3Y3B92ewlWKbXk2HjGz5B2TDhGlkHUXv1pYigNE6ddEJGlF/k3Z3b87c4rD8Qb5HVIbXfyg96xYcwY8JA2GSC1oeE4GIlWSfwVb7qoB0bw+WwedruRksILUaK4A5pKnAHY5CfLlhrYhAz0B3X9s4mmln+/2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    This fixup adjusts patch "[PATCH 12/12] unwind_user/x86: Enable frame
    pointer unwinding on x86" [1] to my preceding fixup, which limits the
    down-/upscaling by word size to unwind user (compat) fp.
    
    [1]: https://lore.kernel.org/lkml/20250924080119.613695709@infradead.org/

 arch/x86/include/asm/unwind_user.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index e649b8fea2aa..5e0755ea3086 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -2,10 +2,10 @@
 #ifndef _ASM_X86_UNWIND_USER_H
 #define _ASM_X86_UNWIND_USER_H
 
-#define ARCH_INIT_USER_FP_FRAME				\
-	.cfa_off	=  2,				\
-	.ra_off		= -1,				\
-	.fp_off		= -2,				\
+#define ARCH_INIT_USER_FP_FRAME(ws)			\
+	.cfa_off	=  2*(ws),			\
+	.ra_off		= -1*(ws),			\
+	.fp_off		= -2*(ws),			\
 	.use_fp		= true,
 
 #endif /* _ASM_X86_UNWIND_USER_H */
-- 
2.48.1


