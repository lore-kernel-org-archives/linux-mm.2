Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C7DD4A5F6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 03:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8866B0005; Thu, 15 Jan 2026 22:58:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C5A6B0088; Thu, 15 Jan 2026 22:58:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A396B0089; Thu, 15 Jan 2026 22:58:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80A2B6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:58:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 344498BFB2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:58:56 +0000 (UTC)
X-FDA: 84336471072.02.29B288C
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id F254FC0002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:58:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=fqlYnfj6;
	spf=pass (imf10.hostedemail.com: domain of "prvs=94765d2b35=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94765d2b35=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768535934; a=rsa-sha256;
	cv=none;
	b=tWfcb6RXiHnwEhkiOnqOdTfmaHlV5Em4DOf4DUUIQCZ76hd7Urs2i1d1wQ10WODSC3pj+p
	ZRtP495D3pD4hWlwzeB5J44n2qI/Obrux0Mk6Ybo34Wzx1mt9z2qsQTfgqvJVASHLNWZGu
	+bkSy4az+WfqNnFA1xERzUCZjxGaCIQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=fqlYnfj6;
	spf=pass (imf10.hostedemail.com: domain of "prvs=94765d2b35=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=94765d2b35=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768535934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHGRhzLgkzKeDXXU7flt1GDfOTT0CygaMj6S64Q4pTc=;
	b=swnbYOFBCK+S3Jb0iZ25abBYLTHpK1nbr0U+FzaUsgKnwWTtlspPy4q53U76zjnl1FSE2t
	xCHWjVoy+pByYR3hPHzoF4WD+nKeZMVmwKMgeo8N/k4FPqC8ddHGsRAw/dXLVFFbHGbnFI
	zIuG+GloukHy4vwfYMX/5ySwavnBIaY=
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60G1PGpC3731818;
	Thu, 15 Jan 2026 19:58:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=dHGRhzLgkzKeDXXU7flt1GDfOTT0CygaMj6S64Q4pTc=; b=fqlYnfj6EMX4
	bj3tSTYHng3FQ0Bf947bM2ssXqvZopiMWPDzpxDzX2nS039HHECHBbo3lvqpnSHd
	IEEtsVWLM+eLyppNNZVj+SawBw9+fJjte7Izpx4OB46c0vY8BgSkPpTvnILQiMCb
	yhX8HvLIVn3K+bLF/WZtXg8sU4MSl3MbGEm13Hr4LFjNIL84klNeJB9xWvsHeBOm
	WJkiuoS1g4FD1HqmTy/FK5CmFIRQY/j4cZj00xiY+xrfLSi3f9LtaM1UQgATOqke
	T7/d8qFfDN7WxPEiY+9T2IHzxCzcub/1OL4jsGrpBJNpOzR/CvJjmyRxcUzVTBhr
	It1bGnlrgQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4bq9ag9nnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 15 Jan 2026 19:58:29 -0800 (PST)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.29; Fri, 16 Jan 2026 03:58:26 +0000
From: Chris Mason <clm@meta.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Chris Mason <clm@meta.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter
 Zijlstra (Intel)" <peterz@infradead.org>,
        Theodore Ts'o <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li
	<xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski
	<luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov
	<bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen
	<dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse
	<james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf
	<jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao
	<namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan
	<perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth
	<thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-sgx@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v4.1 03/10] x86/entry/vdso: refactor the vdso build
Date: Thu, 15 Jan 2026 19:58:02 -0800
Message-ID: <20260116035807.2307742-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106211856.560186-3-hpa@zytor.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::8e35]
X-Proofpoint-ORIG-GUID: gO_gaMacYXfmKyVJzFFoBcI-MgI-l0Zn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDAyOSBTYWx0ZWRfX9R0dUwIcoC1s
 V3qPIGKgm+5mos7jnG6JLCRjUacIC1ZjKPEog3Lbo/0nZGNgBw9hjhY/vLKmJBMtGgzu1jnU2JD
 e+kTo64mrR3uqSwG5TeuvrCVqXcUHkzFRbd+cdeQpiJPlrJ3vG8twZVabJQ2284meLLOjmEX7Sx
 C4o67/vH60Tn5cjaf+MhpjJGVD4xuiCU5wx0RI9QxjJaM5NsVXkHqFmUZObVCEfd9mv5ji1IT15
 FJdAeSo8TtY4ltxTw7dUyBEN0Im86gQDZnvm96j2GkG+BhdVb/dlW1SfzRF0IRSQLipHv+B5x6h
 RtXAjdZGKhYJ2+Csby0w1BtaFBZFEDX/s1DL7PZt3n96OKuoqkwMeAJvjrHqrBjegED41VfegGX
 OGJPIJZBOw/rMoYubY0oqifPDGrMbAJPY8kbJvhD74qf9E7i22ffenqZSuJzc4uzsz1/8IrFStK
 JNSm/GI5KntmKxacbBw==
X-Authority-Analysis: v=2.4 cv=B7i0EetM c=1 sm=1 tr=0 ts=6969b765 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=oGMlB6cnAAAA:8
 a=XiQ4jqB30v8HiKyIVqUA:9 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-GUID: gO_gaMacYXfmKyVJzFFoBcI-MgI-l0Zn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_01,2026-01-15_02,2025-10-01_01
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F254FC0002
X-Stat-Signature: 16fkbg78qu5kokx8mcpafemjx94yt6n5
X-Rspam-User: 
X-HE-Tag: 1768535933-496641
X-HE-Meta: U2FsdGVkX188uCI5bo3b2v/umZH5U/tOs2mIo3PqDSEPmbLynfUuadTuyOm6TmNeufWGimYdrDJuX90Q03bJkRb4ilCsf+Wh4i7Njve7uXa6ih2JxD+2c/cnNFTChVdxs0L4hHNdRw71aDbIKnOzMl64dMMnw2V7RCdIsodt+3RcKoZBEXbBvqmyxjRO02hkm6mQ1f9alkukfO0DbCiE5nTfybRV+Yzj3E5UymeA6cvf4OtclSt359Jf2OfrGHCTXGEeXa65wGLiVRrzONycgVzn84e/Lw5sNIXqAyzfm2/LOiQvvznK0pVo2mFhUsTCyfpncnWN4nGcyanhHAVE0vpmpgpczaVVBbkj1zn5DIvNsaoF/IA0iCHjcJkRyHpXvnE0HBZ9rsat9/z31RXD+sTemxO+hS7xcn4aSZ2FQHGATN+r3N8zFIpQdF/8CxQoCDCk4Ln3MiD50yOl2Ot3yKDWdF981u8WpsJlFn0dzfWgfVYHHJ5iYMZUKOInyenrnzQtHW8IVnhvs8D7N5MtHirpAFSrpW3dMATxyRf46647PrnSJPs1psYJFwius0TxVC5DpuDdEMF2WLLjTzHXiRdtdszzrfZYTpntfWVRF/XUAkgfKXR4ZZ3uPtow8/zV9TQThK6klGRfrKyQhSoAsICS1X8YEd8EQ/XZVGcWzdB3yDY7qP2hT3bP6PuwB9Od2uzE+jWEKeS/Ct54ERAiOXLNmlu+mhmL51EsL6oDVwn/Z9l4jlYyJUT8Jryt0R/cEc/kV1SQv3tfSLUNvYU/6oZDt0tv1E8/855IXkiwyylX03ZW2QnO9FAExtPP1SgGpVX7+rKgMHSYUGAsmBjiGZebDRlsLn7AEdGPQ+NQWS3nr2HLdH0U2f9lcMqLnq+P+PTiIHFaaf7SUqS6fnKp+23/qlbbniCGdZtGq72jz8EcwVU3u4y+QxfeVlf3hcW6IP8Z6KyBmU2Q3jpT1Eo
 rJqiUeP2
 whUDJDLZXpvtlk8KP31TVc3zkLiudkfpCviKvr5K7SMzrM10F44sorgqWyDnMQ8WjMIAX98Cp/ZO7ICcuDiWUvrHkYwSn5zmX8bSf9WDuLVQpR+Qz/M3F0EM4PTjLRIcZ7EXQwYqoJtmqOz/Ve9z0EjK5OUr2mB7G1TtvFrqgK+fCCDkdukNKxWB3C1FEfWeRfgi9SVfzse+LeDB3xKGBUpvV+KgXpuCzuA0btGdUs4jIN53KxPLspXa1Iy7Ow1oEn0tGQs8+FmCDB+IWDZvoWJUDoACIQHeqDwX0R+88gpqH4HjzpdZNPamhxMrWSJzVWZSUjQXvssuOda5US/xAbEvHonaX8M3y7RISvUOJSpodGf42JhKv3a2NCqhRPjtYENRFFvDP3dymquI1nKtaus5K3erUdkVIUfAjdvqzfa4oc1bEv21+7k0GTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Jan 2026 13:18:36 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

Hi everyone,

I ran the tip master branch through my AI review prompts and this one was
flagged.  These look right to me, apologies if it's noise:

> diff --git a/arch/x86/entry/vdso/common/Makefile.include b/arch/x86/entry/vdso/common/Makefile.include
> new file mode 100644
> index 0000000000000..3514b4a6869b7
> --- /dev/null
> +++ b/arch/x86/entry/vdso/common/Makefile.include

[ ... ]

> +#
> +# Options from KBUILD_[AC]FLAGS that should *NOT* be kept
> +#
> +flags-remove-y += \
> +	-D__KERNEL__ -mcmodel=kernel -mregparm=3 \
> +	-fno-pic -fno-PIC -fno-pie fno-PIE \
                                  ^^^^^^^

Should this be "-fno-PIE" with the leading dash? The other flags in this
line all have the dash prefix, but "fno-PIE" is missing it. Without the
dash, filter-out won't match the actual compiler flag.

> +	-mfentry -pg \
> +	$(RANDSTRUCT_CFLAGS) $(GCC_PLUGIN_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
                              ^^^^^^^^^^^^^^^^^

Is GCC_PLUGIN_CFLAGS the right variable name here? The kbuild system
defines GCC_PLUGINS_CFLAGS (with an 's') in scripts/Makefile.gcc-plugins.
Other vDSO Makefiles (arm64, sparc, arm) use GCC_PLUGINS_CFLAGS. Without
the fix, gcc plugin flags won't be filtered out when CONFIG_GCC_PLUGINS=y.

> +	$(RETPOLINE_CFLAGS) $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
> +	$(PADDING_CFLAGS)

[ ... ]

> +# Reset cf protections enabled by compiler default
> +flags-y += $(call cc-option, -fcf-protection=none)
> +flags-$(X86_USER_SHADOW_STACK) += $(call cc-option, -fcf-protection=return)
           ^^^^^^^^^^^^^^^^^^^^^

Should this be CONFIG_X86_USER_SHADOW_STACK? The Kconfig symbol is defined
as "config X86_USER_SHADOW_STACK" and kbuild exposes it as a CONFIG_
prefixed variable. The next lines show the pattern:

> +# When user space IBT is supported, enable this.
> +# flags-$(CONFIG_USER_IBT) += $(call cc-option, -fcf-protection=branch)
> +
> +flags-$(CONFIG_MITIGATION_RETPOLINE) += $(RETPOLINE_VDSO_CFLAGS)

Both of these correctly use the CONFIG_ prefix. Without it, the shadow
stack cf-protection flag will never be added to vDSO builds even when
CONFIG_X86_USER_SHADOW_STACK=y.



