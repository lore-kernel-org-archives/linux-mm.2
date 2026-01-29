Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D82FDD61008
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02E36B008C; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8466B0093; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862916B0092; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71B746B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C32D8C84E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:07 +0000 (UTC)
X-FDA: 84384777414.21.F0846FC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE696180004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fmHPfMHj;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkzHqjw7Quv/1lQEkBGMQK/7nNo0dijsdSsDrvkxEas=;
	b=12VzBXfqL+eGn7DavQWf+nDSXuNskZuv8lZE+ep4dxVXidW5fLvM5mm0BopHBF3pLgzsU9
	z1aVkDG4H9s1ZV4Rc6rHMX66zGOfJrPu5l8o1in/pNLEZ3gT7g9Rzbi8o89G35aKX3kjjN
	N4FnTmZujjPZ5cQKVHWq+sW63uW8mWA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fmHPfMHj;
	spf=pass (imf24.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686085; a=rsa-sha256;
	cv=none;
	b=xpmzzhPAa3gTXOjT18KCbO+CMMBljwie/xbwh2/OWZM9g3ZdGxaZ+AcwqThkfAZbVASSfQ
	DhSNhJP8//liO1zAqqMty9o2muK9s++GCs1B07X4kq88RQM1YxjLB5jZkEvlrQyzNpTUy/
	uhi691ZvMcXIt9yM6VtYaCwRzw6uNRg=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60SLbET0024602;
	Thu, 29 Jan 2026 11:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=IkzHqjw7Quv/1lQEk
	BGMQK/7nNo0dijsdSsDrvkxEas=; b=fmHPfMHjzAT53C7zpLE1I6TSkIT/9/Z6v
	CN/PBInQD01CMavvjZ/Y4wAdjNKWToJTCZUBgxlQC8/iED0DSXzyDtcZ/4k4MF+c
	raMluOuvRdf7fHyyH8dBWDIB6xyh8DC70jsQTLFkxKkqe3n79b1jvyh41z5hgGUh
	fYlzNaHA13xoZaMXIOlAf/ZrLqCggQ3IF9juaiETPEHk4IgqO2z2DAuZuXGxOnM9
	elkbr4fE0eVbLqIdDxencVznvGK/xE5DM6rxB5wGraX0lyGP4EpTxDCz0Ge77LWe
	WjhDppluicQ36nuQqm+uEWIA5OxSzs6RAK0L3+dEabGRK/JXe5c6g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnrtr7wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:35 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60TBRYYd025755;
	Thu, 29 Jan 2026 11:27:34 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnrtr7w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60T8SfCs018394;
	Thu, 29 Jan 2026 11:27:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwb421777-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60TBRTOx27001316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 11:27:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BFA620043;
	Thu, 29 Jan 2026 11:27:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7850720063;
	Thu, 29 Jan 2026 11:27:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 29 Jan 2026 11:27:28 +0000 (GMT)
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
Subject: [PATCH v6 1/6] x86/vdso: Fix DWARF generation for getrandom()
Date: Thu, 29 Jan 2026 12:27:21 +0100
Message-ID: <20260129112726.892340-2-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260129112726.892340-1-jremus@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5P16niUu5fnM_03ZbV24Md8SiiyC6Ndj
X-Authority-Analysis: v=2.4 cv=Uptu9uwB c=1 sm=1 tr=0 ts=697b4427 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=rsc5PF6bQGhcUx5MhlsA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: -gEHCNz9_kSMTT1AgYGNNuOuZqwKSrMp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3NiBTYWx0ZWRfXzFMmW3i8oKoP
 ife3f0NiGzr8EAlHvpVxAh4fbgqeizX5KArUmRVt1ai4yW4+0sus5vEcaCCZAX9ycVCXXvclEtn
 0hliKLvcXi5zivMf56FH4Ke7kfuYBn83NbIyopX7ZFsi3WitAZWH8mmOWZXHnmm7Hh4cZ2BINj6
 Vdh7NJXx4a7MprUSEG9USzMlCrKj9/lhBoouzQ9CcUbYmysqZleqs7WI+BwnFMgyY15qoX7oPqD
 I+WHKtoV6Z5DwM8hMYMPVSgFkhUZPOQXU8oSyY9b5Zzz09AvEQKw+ozmch70GU5tw8S7nv7Kk4R
 wJaSEr8s0OBlPVWWLHdXmuukfQHs9JGicDhgd7SMvuVEBZwf5EYkDQG+N96e7BZsKvlX/tPeG96
 JM/WxWM9F6CEKy1M2d+J/bFstQ8/Y8R3veUXzr7vvDeSz7kjgG3L2GIpByEdW5nl5g0r5oBjR4f
 4ILCyoRGelB551zGyBw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601290076
X-Stat-Signature: sz86fj5arihqwcyjh94quoeifninwow1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BE696180004
X-HE-Tag: 1769686084-427035
X-HE-Meta: U2FsdGVkX1+B+bh7ZTsFV+G0xS5pr8Vj7PhRhA72LL2q3D7JH16FUzjt9dkchGGFJL8A4Z7HsfIfCpCQ6B7buDHfgSZ+qWsTu0c7vNsIdVghjqv/WzigNtcmO6QzBbhfBWx8D7RSLGGJow8mO2ZPwoGMRfPEf8dqQNfeaox3UYFY9Eqs1DlARyuHI1iAbqRNdl2qPSfBuzTiEO8391mntityqLbN+JzNO3RBJ2ZWhH2XBEmjDzDNd8Fzr/7+oN4dGkd4j5pZFrzPSCMZ/dn0WMqTEXnZqzaZ1pkrDPYFJ8legHbHz0LHgQdiAbe8Z+R8LFrEbvMSR1FCDtxeK2hyUvEP0kY5SQJiVcr4wubF/E5ahKNM/cKLwsNSJ7nb82srdvpdN4zBajBKjxZP2/9n3cj3kVNcRdSkLK4OwY4Jdac0JAzpUzpInvuftMuiYEzsLICk7oT+b5jP1p/F5XsP9Gj7ipCb2C510cKByD+uSWIR83ddmNq4yqT2tkGlemp+BWLbuupGK20QtRg7j9S4TdlauJSe0HQqXDra3d7fvHHXCrFt+0EixUk/BWm5m2cAdZzegIHTp9Uuo7BLCxfOKvII2EM8492ozh0O1RMWIVWNFYg+/HUp91wL7bqHfsdXtUNDSIQsGG5Fnlo+wUkGPp1Xz5Zi9mWdkJ/r4OpeI9NlmUhZAmG8T+llKXZSIz6FWTTNxthStEV68GQD3R5HxUWqBBi70iMbVCj52mybazca1ij93pc9scDfF0gaVv1K2zx+csiKryi6dNDM9g9HtyiNYhVdJyD4nRr/Oxy3BMZaKtwkrkTh2HpYuxzlWP6OQ/K4BYtG1L/yRjmRz8YbEV2smZMOm3FLvbqO+3CAOW0G2e5plOot4u1WWIyQ5Ao/rxH14NM4o9iPwqkStsMmyH8e1nAduwSCyEZaLSpkJWOred1rXH1QXzwuaBT9DklTw1jhmC/Y5dIibDL+R3a
 HToYneCm
 ehHu7LK27uk3c4zJ8/4EYfQgsnV/lQXD5t8ZPtnp6hcmd2GTQ7lOlpyOdhrB8tojr+0MlilgV3nWe24NRRhDlGydm4FfZXg/Hldeawv3EVmGnT6jucXv2wEfzAVM6gK7itP8+4AnxuQ0mk93XSiv/dSyyo6RJbLWbbVXONVdnC5d2Tug99JwQ8xM6gCOO5Kc7KF2Squz4L+uHTpLNt3Y3i4BgsOyyl2jBXENIwin1NTpTbutBMH5iqT0IUyGYTZnOsy2C6oI1YKQy6y4R+ZxMqKzpVYcCJKUg7pH5wjPM+Yi8YbLxxtuRZPW+rkGSztlb8pof2W4lwM5ZqX9EZGi9EEDwN9sc7+XCkwjU1bTSxBhCrKX2dxAO+RzMhok4N42/DZC2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add CFI annotations to the VDSO implementation of getrandom() so it will
have valid DWARF unwinding metadata.

Fixes: 33385150ac45 ("x86: vdso: Wire up getrandom() vDSO implementation")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vgetrandom-chacha.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vgetrandom-chacha.S b/arch/x86/entry/vdso/vgetrandom-chacha.S
index bcba5639b8ee..cc82da9216fb 100644
--- a/arch/x86/entry/vdso/vgetrandom-chacha.S
+++ b/arch/x86/entry/vdso/vgetrandom-chacha.S
@@ -4,7 +4,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/frame.h>
+#include <asm/dwarf2.h>
 
 .section	.rodata, "a"
 .align 16
@@ -22,7 +22,7 @@ CONSTANTS:	.octa 0x6b20657479622d323320646e61707865
  *	rcx: number of 64-byte blocks to write to output
  */
 SYM_FUNC_START(__arch_chacha20_blocks_nostack)
-
+	CFI_STARTPROC
 .set	output,		%rdi
 .set	key,		%rsi
 .set	counter,	%rdx
@@ -175,4 +175,5 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	pxor		temp,temp
 
 	ret
+	CFI_ENDPROC
 SYM_FUNC_END(__arch_chacha20_blocks_nostack)
-- 
2.51.0


