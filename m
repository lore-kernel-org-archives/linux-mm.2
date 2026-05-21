Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABB1CD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5C86B00A7; Thu, 21 May 2026 10:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6EED6B00A6; Thu, 21 May 2026 10:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1D76B00A9; Thu, 21 May 2026 10:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6593E6B00A6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 373141A05C4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:36 +0000 (UTC)
X-FDA: 84791652792.27.E9F6DDB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id DA5E5180006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j4Du8KgI;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLUdkq8a3Y1OwT5DXjpOwlqcJtqrXG3rf2YuzJ2NkbA=;
	b=tdr2VnaWm2S19AztrnlwV/NlFRE6G0c0IJOTBmtEJKoMjF3eRh3qlFHu9mEYu9kDG8zy2R
	ZUFxD5h2g0Fy1Em8yhzTka3qPhNVgPg5ovYTtO10rYwHljYNFR1W0jpkvMP8Iyn8BP3WoS
	c2LZIqOxwottr2hOfIoecFEkJQjl254=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373594; a=rsa-sha256;
	cv=none;
	b=wzoMt6eDTPPojmp6oNS8Rp6EDy6SSQXudL36TjXg6EpT0R8PLr2x8I4mKnGpnFpDaSW5Ql
	7u+UKqbgEkMoWmnajsRvBuXZugQh21xM6LNFsiWTmYHmm13CBhy/jxG/ZsFvwveLvQnG3p
	kAye0PKGiD6E7rntf0Sk/15BLgnvkZU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j4Du8KgI;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LBVPOJ271835;
	Thu, 21 May 2026 14:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dLUdkq8a3Y1OwT5DX
	jpOwlqcJtqrXG3rf2YuzJ2NkbA=; b=j4Du8KgIApJgAohv8CFRqcAykYsTymGs7
	N/XLg32AAbJC+mQmMqdAcFkxRj6zomQbHS3SVt4G0agihIzaEMhaxM6xg0QSLC5v
	mikLELCp3PrnQe1T3tZ+JCfhp3UgGWQ7dTxOQc79sNI/iCQ9j8MV4QrfB3msMhwf
	MIjZBzjyW7yThlAnL7F6PZYj7dWKipQOvzUxO4dzsia0dxuq0nJql8qwWUUWqoqd
	sifPRWl/3KPLs3nPa68zb9LiO5nKJfm0h0/6t3bcuC22fjk6n2rT5o0KNYLEIA6O
	f348nae+GpZOxkwKOc9yOoAeCZC3LtrJw+KsgGSovyt4DSgOL0iUQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h757dqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:57 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO92l001746;
	Thu, 21 May 2026 14:25:56 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wqcst0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPq4T45678870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55C8920040;
	Thu, 21 May 2026 14:25:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 002AD20049;
	Thu, 21 May 2026 14:25:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:51 +0000 (GMT)
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
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v16 08/20] unwind_user: Stop when reaching an outermost frame
Date: Thu, 21 May 2026 16:25:34 +0200
Message-ID: <20260521142546.3908498-9-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260521142546.3908498-1-jremus@linux.ibm.com>
References: <20260521142546.3908498-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=ffCdDUQF c=1 sm=1 tr=0 ts=6a0f15f5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=_1qlYuAciRtwIPuEvDgA:9
X-Proofpoint-ORIG-GUID: fUfePOnfi9_oEKj4Abvipy8o3-nPleKs
X-Proofpoint-GUID: c8elz6F9YYxRXonNj5nq1kxFANaA4Iy3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX6N2qZycI2BBT
 jLDodVQXz80U+52pLCZg+xmQAY7Ow54WWQdZJSDAhgkmx06upvMLkZwcaApQt53aW+Io6peTD3Z
 81I0CRQmOPlgvFLHpAgYYsMHPrfSZQJJ3IYakPW5fjsW2I1SWx6yAOnmv7rB7WVqWMaxtBltwPZ
 EXQwF1GQxWx6JIckdTQJlHZhF5gYU+QlcrScerf+JVVewo2+nBOXNFDhHVlavkPQadyE5XF6+iT
 ZDkM+Pidu8gUtfbSJlC1a1S3IQhLzcW13losOWp8JWXIwzx2jF2OSsV/eI7+cqny6nmOO8g56fR
 YZijlyIYV5ZArd1SdT6tBkr7g+0LnXNncEqtBHNGwpgrqrhqh1NJlLAxFo52OTtp/FjrxO0LIYP
 6HOc+PV2I14kVXZemJ9lvpxlWyBD2DbyEDmjJXkJKd8u4vjA3oeiBg+88eV71u8s0anv4nhMoL3
 cBIi0jv8QOnf0Q6VA2w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspam-User: 
X-Rspamd-Queue-Id: DA5E5180006
X-Stat-Signature: y9uh83ne3epmd9m1s6pfqc4ksspzcuq5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779373593-608540
X-HE-Meta: U2FsdGVkX1+q7uXNhGiPDz9rOOFRyR5Aw6Q/SC461binpnwZx6o5BNp23B/hLrcpjxHlBxnaFu30rUILaRiG+rEwp44MRF26l2kgyu/czWb9Mkkp0PKdH18KpEK4e2b1FTteg33OY3pI8F8LvNRwO3Rt24o+RQxg1GXGm0JwwPcDDZcE+6+9Z7cKd/d8ZTbPO9psw0S/VEGvDyyfaVIgBdpkPizUESVojqiKPl2S39yYh5SJeJGK3O8tXSltSTer6DIE5li9L29e7vVeFVvmVJwdFr+h+03q7gIvlPHFs7YxrezyXehpieG6b4w1+bFVmAw/FtdLX0rMd/bLhl/Udvj8swsA7T6DwjGV7q7Cf1yiKERTdSV1QORW9EXnOSfQE+FlVi/nqutk1KzlsYEZZVj/Y5PI0vR3aVCyTtXiyqnO1zx8Gn4ds9h4oFMNihdaun6nTiLxlxM7TnCoGFbeI+O7W7L6k+FA7VRKeUORGykseuaaVOiFGmOOtBv92Go4mtYoXVyzXiFwBXgzl8fzy7Gq/Zm/olTxEn9zKn8xGIJysYyiOsgbj5ChMr1TxtHv3KTvFX/HZz1mRbCfJsKhVzRLW97FHC83hdr7OYbQxelPKTgn43vV4LuN4ILpxzmSFA43ST4Q7ykgI8nJX3yGCCHHIlW7vTQqbzmpv7/OYwBGH4ijvdD6m1ME4+9vG0AV0lkT6L9y3g63QnROuxldkXj0tvAwjweh0xQ18Ym6vbhqeg3YJLV1uTpogh8g5HA4tef/C3vgR2jZMwNRY96//rD5NB+Nq+SUBqahs9s7JYcM0oZGkQVBEXd0V+HwR6sl1OJ//k4vhFKHNZyb6dgyPc4Rw1573VtANXVpMfrFmYZrfgEmtFryIAIC64rnrjnIb8UEZXqR8jxC1b7VinLcA+N9b/Zok1k7C5UDqaZt47rYTdYjS6ba29dcunX93FcbZAb2wkLUOkF5n0OufO4
 EmNNevdm
 1ZxNsuQkGtovgu0kDUocMkLG5vzbXVoD9jedto9bA8FZYOYB1Sh1D9hLfmJE/fgiW6wOhWkTlF80VCaPBGKwwq+vPyk+X8lceQ80ti5y2WYDAmwuzXJtGJu548KgMR2DJ44iMnHs5o6NfT9ze02+P1jgbHDAinLcxe7cQTCRzjCt0ZmklEufFjYhM6XhggqN4j5vE1tlISzmfckum8edJWhqqYj6NEdPo+Fc3LhZlnpzjw6TXHM6RV97r8CnYhJwj4YIi1ClDNPs2kzLR5LL4yRm6AjPtRwAyPdpd+ZccuMuOehW5/REecW1o5lcR0aBwrU9SXBpGPT4wfpH5iBhaEqGKTksYF2gL1qrVCdZjqjMFgfIbm4iM2HtNaw==
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

Reviewed-by: Indu Bhagat <ibhagatgnu@gmail.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/include/asm/unwind_user.h | 6 ++++--
 include/linux/unwind_user_types.h  | 1 +
 kernel/unwind/user.c               | 6 ++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
index 6e469044e4de..2dfb5ef11e36 100644
--- a/arch/x86/include/asm/unwind_user.h
+++ b/arch/x86/include/asm/unwind_user.h
@@ -23,13 +23,15 @@ static inline int unwind_user_word_size(struct pt_regs *regs)
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
 
 static inline bool unwind_user_at_function_start(struct pt_regs *regs)
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
index 1fb272419733..fdb1001e3750 100644
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
 	/* Get the Canonical Frame Address (CFA) */
 	if (frame->use_fp) {
 		if (state->fp < state->sp)
-- 
2.51.0


