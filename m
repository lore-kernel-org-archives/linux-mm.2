Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D559F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123926B0099; Mon, 13 Apr 2026 14:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FAFE6B009B; Mon, 13 Apr 2026 14:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2BD96B009D; Mon, 13 Apr 2026 14:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E21116B0099
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B05F9B6FAD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:30 +0000 (UTC)
X-FDA: 84654370500.23.C48FCDE
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id C77D6180011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=MWPBldvW;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf16.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104969; a=rsa-sha256;
	cv=none;
	b=epJvBHBOUGEo/3SDqB2bxXhkEE0RqFtd15ZYcpuNxqGzQriHgBkxjFDpXggk2MSP1EONdX
	k8phvjfq0DLWruaUgSIKGDoD4BDCJVf557cMuCXjRYZx3fucGOztXvkxL5RdAvAnp/9Tzj
	34/WWLhyjgEJwjknzQmLURCWgbr+Txw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=MWPBldvW;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf16.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mdcp4bv1eu+3+1zz5d2KPvXdiRfH0YZIH1Hih1O/yps=;
	b=EvlQdtseesfSU3XnUw8+8YPpDuE/8g2YIvbMYIjZVxJl+J2j/WFKFLXq4SU747VBkbafah
	RtMlZvkyAInNLZHg3EJJ7J4AW6vHg1izMIQMVgZYNQCt9fBNu9WZZBP01LYKzDtYbaS/jX
	Xx8lKgI0jr/sj0eX1BVH8FnQtWAbCFY=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 8239E1A3207;
	Mon, 13 Apr 2026 18:29:27 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 4E7C55FFB9;
	Mon, 13 Apr 2026 18:29:27 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 65DB41045056A;
	Mon, 13 Apr 2026 20:29:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104965; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Mdcp4bv1eu+3+1zz5d2KPvXdiRfH0YZIH1Hih1O/yps=;
	b=MWPBldvWBlMlRLB7YRsCB6BeBrxux7LP6MczGCYn9+gqLTpdPE4XjlTfrNInbkuHOU245w
	rnCCzBg/4H0eg0CCDktwD7qx8pXICwn9sDOLbeEbNFGXIaEQd2iOWyygEb+ZKxDXkwN0Ze
	3dLeaz/gU2DpaSNYvL9S6agidNul6GvFXrdnBQZ08Z1FGLVkWAVpx7UGogUMYF545oxiEK
	cFdj+JTBc6ATUzw9po+Hw78YsxbuHGYR/K9YxFGuCsKwEUPY7zCalMX2s1SlgVn3BdG29p
	BhSdIs+8pFh68+m0Vck/uK+J+HK7zfcanYuNTj4q1HRWPFXDcHSDTEsKjMjwrw==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Date: Mon, 13 Apr 2026 20:28:47 +0200
Subject: [PATCH RFC bpf-next 7/8] bpf, x86: enable KASAN for JITed programs
 on x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260413-kasan-v1-7-1a5831230821@bootlin.com>
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
X-Rspamd-Queue-Id: C77D6180011
X-Stat-Signature: 5fqw9uqr6edifkknmgem1mw9ywkmopdg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776104968-7358
X-HE-Meta: U2FsdGVkX19NwxkU1kCoLRPMf/wpNfshKcAUGdm3XetDTdgrP0zVv+Wit4g9OOnhAi/Gg8EGyBNDaVu51L94siERCnP4L4gMvo98Jq2lfi9kd4FcrQSG8LQVezzSnFUqZGIuWNVnn4OO7blpZ292KIZpv7SI/dwEXfAZTWAEMWMp+oCH3rYDIY1rYE/2220Wcu6tSUhKkcQyxkPcJNRsOM82Y4qDYQ2nB/3M6sM7kWCRICjQ7/1pO7gZ/bCsiYDeg2WW6kO3G4nKBbNXm1eyZ8zgEYv7NFxd9M1trCagTDxX1xMWrYg67eRIYR4eZay/t7kVOdFgQFK7YfHRS8iHfM4LUq05xggKSkscXpOuzO9rl/HmIMvSZw6vtawzgKSabuBLHRhEAsvYcEDJSdShwyVTfYAGD2lv1huM87EFFStit4Xxor7MQ4iBlQtAGP0K8ljKX8I6Q/DYpzWtII3TxekgLcjsCXGI3Ktdzqtm8XdwUkym+zcE+qiQepsBu0a1IYQ+qF3Fjf2An3QDv4+0GwlkaA4k0YuVFhsAiaqIJaAePW8GifTHaBfzxzPwHE3BSvs+mgk152twoyxxoABD5MEhT2wTdga79x7pa7ZpkfSY2eRvejJP7Rn7DamI9pN4lIjfkBaVML8FWosds6MDYRgnyGudH3rvi8AA/VshkwOACYYo2x19a24sH+jv50MPOzScy/r3r/SzGTXUEpbUV2yOGuJc0D5cQ89e+5aShgFFmLCKYjnNCHwZdXD7GN1BXxEzEhdcW0GtnI7Qn28KveJaZL82XeD2N4+a2msE+1Fbfun5YNA7kT+YlF3lWe0wPUrIyYUZABrovO4UZ0djT9WK/n+JItemFM+aYyjpe4VsCePmiMzBdTa4c1RB9GXSBoacc9bledHgLkSAtCCgjRjHwnobYyEaY+4dNkgrjdmgUTl5xz0+YdzmfKj23qhN8qyClMoBBKz2dWy8eYp
 ZGX33C6Q
 V0eKownSMafIKlFFKYnE4ihBLIZJbrtIEbrmsbFVu9FvNqn7XlthuhBtwtznYIto0sAMfDqXnOtljgyJmLqSRR7uZt09AAoTXOBBSS3xNamO0PSDFv9NwtgtDYZyogvllGXvmUShmDtSTvFK2DXhxHaJarIOeGINjMrM367AgWidfLl3nv0lOGYomblzdQOF8WHYGJx+Wda47ZiHZIYWy+F0WDZuYRSh/XKlci05eEd7objLiI7TnAJpeTdyDBrw9ef/I7Wxeep7rqRAwpZSrZdaQ6hN6gCxaJ3Hlda5a4CnHtpTFyHH39tRDE+zkqvNx2RccCmFFeGAFBY9hqfzAiQHtYtJ9J9rgSgRUekqWucJs/2k9+0n8254YehJaaluLaAAjsLcIYE1q04cNlyoVUw7mGUeUgPnZnoXrTe4N/RaNIoXvPCnUDShag7SyxXOInbqRg/7gUe5Xdt8L44f0TWJL7I/l8AGMi6acvbL9WLib4ug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark x86 as supporting KASAN checks in JITed programs so that the
corresponding JIT compiler inserts checks on the translated
instructions.

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184..a50aa9a0b93c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -234,6 +234,7 @@ config X86
 	select HAVE_SAMPLE_FTRACE_DIRECT	if X86_64
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI	if X86_64
 	select HAVE_EBPF_JIT
+	select HAVE_EBPF_JIT_KASAN		if X86_64
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_EISA			if X86_32
 	select HAVE_EXIT_THREAD

-- 
2.53.0


