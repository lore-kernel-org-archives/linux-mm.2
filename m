Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083D9F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716586B0095; Mon, 13 Apr 2026 14:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDAC6B0096; Mon, 13 Apr 2026 14:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603EE6B0098; Mon, 13 Apr 2026 14:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 50B4F6B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E53D58AF15
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:12 +0000 (UTC)
X-FDA: 84654369744.22.B132B8C
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0B61140013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=o44sVXLe;
	spf=pass (imf26.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5yh+jPLjYdbpM+lAMSIEbKZx9jBkdUNIqhhBJUSD7U=;
	b=Q9cUQAYhbVA3eviug2INRtbDExHurJXtBgaq3sBdoY0MnM/0as6hO34CY6boxv0YhpUU7K
	1qld6I4aL/PPmA2lXTy93V0feYnSzyHnSHNGe2atrHhnU9xaFNmntR2udVLru0WfmiFDT2
	7n4BYOmEErDuJPKk2pr0xmWQz1sNBC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104951; a=rsa-sha256;
	cv=none;
	b=paOy49X1FXqstnvWCLbsWYJr82lw63g33ikoPTDnjHw9pUG+CDEDoZojxV1xTJ8NfqBPFL
	H3TAzVZMka55z7n3EYFEzxBGessNl2LP6vaZLoE9M2FD1JJKSIoFgLlbrg/VDFLMHZrJkB
	StOCsQmeAHnpQoQ170vKkQPuE7/gXl8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=o44sVXLe;
	spf=pass (imf26.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 6BD0C1A3203;
	Mon, 13 Apr 2026 18:29:09 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 40C755FFB9;
	Mon, 13 Apr 2026 18:29:09 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8D5D4104504DF;
	Mon, 13 Apr 2026 20:29:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104947; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Y5yh+jPLjYdbpM+lAMSIEbKZx9jBkdUNIqhhBJUSD7U=;
	b=o44sVXLepMBqSnOEDpzehWYEkyLJ277S4ZD0mX5x0/hGbON8nbocYIKweTKmZgSaODHeop
	Gk1QZ0KlMKDF6U1D/i7rG0MsPoJurHcz2wDn/C9O4mxht3VdU9u8za91gWE95CrtwzSa2w
	o2xxrib2bvulpRAYCkWrLZAtfAw9kTqQn74z1/EQj7LuL/TVuTGJM10yXYkNFUqAiZGL5L
	CMOT2PZnOSIQuXQLtFWLrdTzAkeZuuzxsF2HCU5UG2JVuExsPqUjNkFb/FdLta7lUaCx8Y
	XLZbAmvi9zcDbQVvjBohG/kgnUmIxAsfWXAYZsXwpmK2NQb3P7FKaD7qaDJQrQ==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Date: Mon, 13 Apr 2026 20:28:43 +0200
Subject: [PATCH RFC bpf-next 3/8] bpf: add BPF_JIT_KASAN for KASAN
 instrumentation of JITed programs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260413-kasan-v1-3-1a5831230821@bootlin.com>
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
In-Reply-To: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: ebpf@linuxfoundation.org, 
 Bastien Curutchet <bastien.curutchet@bootlin.com>, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, 
 =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
X-Mailer: b4 0.15.1
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: F0B61140013
X-Stat-Signature: n8ppsbcs39o1yhz7k57yhxmdiomb4ke7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776104950-924143
X-HE-Meta: U2FsdGVkX18Njsla94CPArrh0O/h9uIb3ABpvNh44jnznKEWKUGDpyC80cf5xaMk14cT2QpIqhmUH/WJhDx3I9luXG4GTDpvaPg65hUTEoYYFNKVe7QUjrcjz0QZNzAC5HxF88xU3HPIU5QppIcPgvslwcQyOgw2O7OdeBmofQhoxsCDI8rCCPGvVnlF3LbwmmItx7X0ijaC4ONtfH27v1G6McHSbICZN+tEO0DFfyatxKO0e9AVfcZDDMfYYNxW3mITEpoO3pCeYUe1jesR5SZSbIHGNJf16Ike/SuIDBzzf31o8awmtNm6fpsjpmOC54rFnGG4DO+WbZ+EthDTwMTnNiEJBz927abG5ai5vJl/4H41QTqgsaDhCh3p/qPm54FpC/DQOHmX34nB4mjjgSl4r6ZdgqY9H/AfctdP3ZDQtup/7AjflaKx63/iwPPFD3IB54cv6ArORrg7PyZVcel+plK9iB95xaqPxoOaJ9+c154dZy6B2EsxKRz7ZX8ncBhc2o/PQagDIdl5wQBVxOfHnv2TLaFDsVsmoHno5STr1eke5SpnNteEYGiSaFl3tskYbZCy1mWKs6PldkBP4ITNmW1SrN9FCxvajDMmoLEyBq/DcafI4v3SF1WUlhSs12J581SHS7qy/LOTU1w7zg2SYPqzQzf1F902Pwv3BCqZTcYaPkGmlb5ZkwjETruupWRFIpovr8opo4gloA2sxmwX3pIh0A9ASTp4fZX2gMsgTyUIYGB/jqXHXlyPAMlneKi4WsaaiOUNdNm5dH94gvT7GIMdjDcdyoFe241uYRINg6/EUgYV7kp2RZyrKUmbATCozqIiGYjGxmJHk8zUVgciKbogFagu8UDFRf4Tv0frZAgqPV5pAc61fmiM4qcOv1COHcEE0K3du6X6k9uDSgOLLHLtP4GWoA9JgUYb1y7f6Ws3QLcslsAZ+WboOXKyld/Pe9rVg8D4Beg2uOO
 2ua20Bg0
 0H8wVhIqEH6Nzmtln7NnPsg+Kn8e/9LCwFJLW2QQMOqq7lBFmJ39eyZq1wHPkBEbSBP9Sj2BwOIcyTt4jf/NbZEZnCJGCpDkIJqftavj/6rKH1G90GkwNXXM9nSUi6Y2iXR/sD3ogCQ58PO9ZjaCKMgVRq3rPKpXHoU6tSG0FUMd1g8P9W8bn0fl6Sj/18P17RhItyAQX+zUn34wlftARFIogU5pJFw1LO+hANiKS2FQ+VJ8ndGF8VE7Et3tgEKfNz5WEv1Xf5IiQvfeKkhhkHTxqpPQHSHz4rTsMBM6o2muiWLWOi+HNTXwBJ14BtObThIrk2X8PI/H57jeHGZBqpAEWyNaKVCYUkwT4ian8VgGYwcjttn1u114c1x55dw5VuwJ/HsJmAPTNIrlacazFbN0S3tqNRqtglK4zTUlqQlFw0y/Av8I5MSGAiB7igHK2fUzeE8SbGaawyfjKXdYQyYsTrMdhvjP3mm68j+W+ezMzWXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new Kconfig option CONFIG_BPF_JIT_KASAN that automatically enables
KASAN (Kernel Address Sanitizer) memory access checks for JIT-compiled
BPF programs, when both KASAN and JIT compiler are enabled. When
enabled, the JIT compiler will emit shadow memory checks before memory
loads and stores to detect use-after-free, out-of-bounds, and other
memory safety bugs at runtime. The option is gated behind
HAVE_EBPF_JIT_KASAN, as it needs proper arch-specific implementation.

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
 kernel/bpf/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index eb3de35734f0..28392adb3d7e 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -17,6 +17,10 @@ config HAVE_CBPF_JIT
 config HAVE_EBPF_JIT
 	bool
 
+# KASAN support for JIT compiler
+config HAVE_EBPF_JIT_KASAN
+	bool
+
 # Used by archs to tell that they want the BPF JIT compiler enabled by
 # default for kernels that were compiled with BPF JIT support.
 config ARCH_WANT_DEFAULT_BPF_JIT
@@ -101,4 +105,9 @@ config BPF_LSM
 
 	  If you are unsure how to answer this question, answer N.
 
+config BPF_JIT_KASAN
+	bool
+	depends on HAVE_EBPF_JIT_KASAN
+	default y if BPF_JIT && KASAN_GENERIC
+
 endmenu # "BPF subsystem"

-- 
2.53.0


