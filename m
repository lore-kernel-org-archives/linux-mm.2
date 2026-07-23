Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8869FC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37F06B0139; Thu, 23 Jul 2026 04:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA256B013B; Thu, 23 Jul 2026 04:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25516B013C; Thu, 23 Jul 2026 04:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81C836B0139
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:14:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD7581C08D2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:50 +0000 (UTC)
X-FDA: 85019330340.10.83B7CD8
Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD7C610000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=bcvTY5UO;
	spf=pass (imf05.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.26 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZ/PodPZ15LIxOQN8pZJFNNm++1lzIljfenjna5igvg=;
	b=AGP6jZ5d58BrZt3gBVDlzl5lkNfstzu5QyS/lwKlb/VZlltD0DYgNwODGgHmyFEp83rD8d
	Du3YEY5Cj/ZEigno+Am5aXyH7pPl4/0Wki+zWGSg2tsn94Q1s4PEio7TsWQXLhdfDclHfz
	nif3fACzw0WwMvgO+1CGIQT3SCad0lY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=bcvTY5UO;
	spf=pass (imf05.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.26 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794488;
	b=r3l+ICeehyHB4oild+UsQKzv1hsF+a2+x6malbKv0YI6rMTrI/VwkCyCbWUlr+lcmqWVm0
	sutMWukE1XY/sBX/bPHCQhCaWBECHeEMGDe3NkkJDQBN3EtbBekNAPG5zL7J60KgZnuKRA
	DVq1koj3lEJTjvsfiOTtIrZ2y+DqTZE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lixiang-com.20200927.dkim.feishu.cn; t=1784794484;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZZ/PodPZ15LIxOQN8pZJFNNm++1lzIljfenjna5igvg=;
 b=bcvTY5UOTHFaEZ25o7AibPK0ZlxMwc4yNbf3aotb1NcXJIPT2dJxj+j/Tu9PBTNLi1S99U
 n8bogZjPytqqL5t9RGnXXf6SdNhaq7aARNL7h6powyAVYDILiKvoMkk+4B1+2NKSP79OiP
 g0FeUZu7U7Xd18JnnC2hFWSGIeaY6a6+fc//smQtM+/UsNSknHLYF05Sf3yzW3hiVvSEib
 0qYZyxRj0lJTZeEyQqP1PjvyOZ1dqGtygXcpXFw1ALv/1+UD5Wly0neTByQzLOHeHjMVSZ
 e2nLPL/NbgdeZNwJvlheqUFaDBShWoeaAN+8p0nYwSRh4g9tUBwzObdOOvnWdA==
Content-Type: multipart/alternative;
 boundary=2f0f836d04ce310c9d8a5f2c350653a259aa3f266d1338c545ee2bf85654
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	<linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, "Meijing Zhao" <zhaomeijing@lixiang.com>
Message-Id: <20260723081427.587283-4-zhaomeijing@lixiang.com>
Mime-Version: 1.0
Date: Thu, 23 Jul 2026 16:14:27 +0800
X-Mailer: git-send-email 2.25.1
To: "Steven Rostedt" <rostedt@goodmis.org>, 
	"Masami Hiramatsu" <mhiramat@kernel.org>
In-Reply-To: <20260723081427.587283-1-zhaomeijing@lixiang.com>
X-Original-From: Meijing Zhao <zhaomeijing@lixiang.com>
References: <20260723081427.587283-1-zhaomeijing@lixiang.com>
Content-Transfer-Encoding: 8bit
X-Lms-Return-Path: <lba+26a61cd73+d4604f+kvack.org+zhaomeijing@lixiang.com>
From: "Meijing Zhao" <zhaomeijing@lixiang.com>
Subject: [PATCH 3/3] mm: trace: name protection key encoding bits
Received: from PC-2B0BA31200898.company.local ([220.248.55.69]) by smtp.feishu.cn with ESMTPS; Thu, 23 Jul 2026 16:14:42 +0800
X-Rspamd-Queue-Id: CD7C610000C
X-Rspam-User: 
X-Stat-Signature: cwrzh5bf8mp8o19sicfgzg9afq8x8dod
X-Rspamd-Server: rspam04
X-HE-Tag: 1784794488-441796
X-HE-Meta: U2FsdGVkX1+S9RYlrwLfubxQG9/4GI08wuN4/K3UHdtRSeKAvyiEhwiBdowcMZaXc6C6kyQBEPaqI9tbAgkVAd5okOVps3J29SKo7FfxeXHvTbWmzCcMMod/givq4Rs+jZOAyZPejSEP2o8QKXD8Bn7oLgh2Fx1TpNZ8rQi2DZjyazlwkJTFMl6DaNog2clArFg6kc46cXuyyXX37rPxnJfMwY014NryUZjgnPkjWNpEeCuIJn1k4w0VqoOcM6SVvY86KgB6R/0bdU+g1yjqSn25ShVKPdG1RNM0oZhRvyajlfNShZeEb2n6pwQ8sdWzoevuw6SIoC1/tYoXxjgm0hfrk9eHG0C0NwDwxjVBoiNWwWUuNNGt864rvqPLVH5VHQ1Vroz/PCCPOyeTvQ/QrG/67hwt4aeP2FupAI2/98xdpYltnAvOyBv4XTtvBRaG+8ur9nggD2Z6ZexRcr17UzPS3ZfEHkWNSpCX2+hvQcB6Gaz1ObOzY24J+ntLaFtPCerpomIZ+KNcmzOnXgcCf6hWEXQ1sK6BCc7s5ym1c4fhLS8ds0yaliBfaoEuHKxpeWYXMQWPZzYIHqG+n9hxBZ68AKC/TxaIj9hDgkonexJdCc9ju3uE+Dik1gD84dmfUBE7gYERoqOLOVSducAr2lQMAXLoG2+jTOWcdGcHYXr1gLBDlna8QDR0c2U8CpC9px1Jn08I22HITJrHhKkO818gzZw18ZPhCOqJmmln+4spcZSTTqAHP5Pi9B7zlXEUZgaHpWi6uEX2TtwSK8iJwRipUsKwbkhamf4/u6Edy2fCOCtlb3z+UmfLzCjxsenOrGutjnQ5b8hBrMpikacMgr0ukwb4v3/pIF4WggfHY6NOlTbnPYigteWa4woOXgSbAzr53iMt3mYB8zxlM0PoFoZ9rHthjcykkNpV2dSISt/Nqs/h8aQ51ECiE4LdAu4UTnfUOKQQpaSh7NuB6mN
 23x2w9YB
 HkGCSppV9aXGP7PxmcGfHsINz7VVMqB3w7w4VIKaCECQUpcJjE1eYA+C+G/rEICr+6cso3DErGcAn0hWH7IWmJkfS9xg+8i82CuC47DDKPYjv/D+Sa5iLYynZc8uV1Bap54p1tSxpa3Lr5bREAHZyGhN1Nj+Ue6ZSsbr+AhR2d0Bv/XGBnMwuwlTUTQ94FFr/h3e7zlQWy1n1P9AW9PHdUd6HrK6WWhbxAvpiNjipxLGIO0WxV3v62tXlXyA1PIt9W6sx1/d4IOZkz4K/7TqkwHckzoTMS0HrysmSsL+/gmF+ncPyJXzID0J9a5xFISPHeX1FI6NM6ga5aWqFbWkr7PMeTO3mKgnjBoLQ1qQUw5Uy3XTFVgFHSqFGo7MO5uQNPQ9nZ8+36KnjdCwobzq+iUECKhDH4pm8M/ZEhoU2rRPVyMw4JjYyHf+ziq4Z99xNWrfz9dyV2uVqLLilUIQWz0IA8JqRAdlF/2RVU8unqocyvA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--2f0f836d04ce310c9d8a5f2c350653a259aa3f266d1338c545ee2bf85654
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Protection keys are encoded in architecture-specific HIGH_ARCH_* VMA
flag bits.  show_vma_flags(), which is used by VMA tracepoints and %pGv,
does not name those bits, leaving them as raw hexadecimal values.

Name the protection-key encoding bits pkey_bit0 through pkey_bit4 under
CONFIG_ARCH_HAS_PKEYS.  The names make clear that these are bits of one
protection-key value rather than independent protection keys.  For
example, protection key 3 is represented as:

  pkey_bit0|pkey_bit1

Honor CONFIG_ARCH_PKEY_BITS when exposing bit 3 and bit 4 so only bits
provided by the architecture are included.

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.=
h
index 2d76daacb70c..c8b8a980f8c7 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -204,6 +204,24 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
=20
+#ifdef CONFIG_ARCH_HAS_PKEYS
+# define IF_HAVE_VM_PKEY(flag, name) {flag, name},
+#if CONFIG_ARCH_PKEY_BITS > 3
+# define IF_HAVE_VM_PKEY3(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY3(flag, name)
+#endif
+#if CONFIG_ARCH_PKEY_BITS > 4
+# define IF_HAVE_VM_PKEY4(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+#else
+# define IF_HAVE_VM_PKEY(flag, name)
+# define IF_HAVE_VM_PKEY3(flag, name)
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+
 #ifdef CONFIG_ARM64_MTE
 # define IF_HAVE_VM_MTE(flag, name) {flag, name},
 #else
@@ -251,6 +269,11 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT0,		"pkey_bit0")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT1,		"pkey_bit1")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT2,		"pkey_bit2")		\
+IF_HAVE_VM_PKEY3(VM_PKEY_BIT3,		"pkey_bit3")		\
+IF_HAVE_VM_PKEY4(VM_PKEY_BIT4,		"pkey_bit4")		\
 IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
 IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
 IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
--=20
2.25.1

=E5=A3=B0=E6=98=8E=EF=BC=9A=E8=BF=99=E5=B0=81=E9=82=AE=E4=BB=B6=E5=8F=AA=E5=
=85=81=E8=AE=B8=E6=96=87=E4=BB=B6=E6=8E=A5=E6=94=B6=E8=80=85=E9=98=85=E8=AF=
=BB=EF=BC=8C=E6=9C=89=E5=BE=88=E9=AB=98=E7=9A=84=E6=9C=BA=E5=AF=86=E6=80=A7=
=E8=A6=81=E6=B1=82=E3=80=82=E7=A6=81=E6=AD=A2=E5=85=B6=E4=BB=96=E4=BA=BA=E4=
=BD=BF=E7=94=A8=E3=80=81=E6=89=93=E5=BC=80=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=
=96=E8=BD=AC=E5=8F=91=E9=87=8C=E9=9D=A2=E7=9A=84=E4=BB=BB=E4=BD=95=E5=86=85=
=E5=AE=B9=E3=80=82=E5=A6=82=E6=9E=9C=E6=9C=AC=E9=82=AE=E4=BB=B6=E9=94=99=E8=
=AF=AF=E5=9C=B0=E5=8F=91=E7=BB=99=E4=BA=86=E4=BD=A0=EF=BC=8C=E8=AF=B7=E8=81=
=94=E7=B3=BB=E9=82=AE=E4=BB=B6=E5=8F=91=E5=87=BA=E8=80=85=E5=B9=B6=E5=88=A0=
=E9=99=A4=E8=BF=99=E4=B8=AA=E6=96=87=E4=BB=B6=E3=80=82=E6=9C=BA=E5=AF=86=E5=
=8F=8A=E6=B3=95=E5=BE=8B=E7=9A=84=E7=89=B9=E6=9D=83=E5=B9=B6=E4=B8=8D=E5=9B=
=A0=E4=B8=BA=E8=AF=AF=E5=8F=91=E9=82=AE=E4=BB=B6=E8=80=8C=E6=94=BE=E5=BC=83=
=E6=88=96=E4=B8=A7=E5=A4=B1=E3=80=82=E4=BB=BB=E4=BD=95=E6=8F=90=E5=87=BA=E7=
=9A=84=E8=A7=82=E7=82=B9=E6=88=96=E6=84=8F=E8=A7=81=E5=8F=AA=E5=B1=9E=E4=BA=
=8E=E4=BD=9C=E8=80=85=E7=9A=84=E4=B8=AA=E4=BA=BA=E8=A7=81=E8=A7=A3=EF=BC=8C=
=E5=B9=B6=E4=B8=8D=E4=B8=80=E5=AE=9A=E4=BB=A3=E8=A1=A8=E6=9C=AC=E5=85=AC=E5=
=8F=B8=E3=80=82
Disclaimer: This email is intended to be read only by the designated recipi=
ent of the document and has high confidentiality requirements. Anyone else =
is prohibited from using, opening, copying or forwarding any of the content=
s inside. If this email was sent to you by mistake, please contact the send=
er of the email and delete this file immediately. Confidentiality and legal=
 privileges are not waived or lost by misdirected emails. Any views or opin=
ions expressed in the email are those of the author and do not necessarily =
represent those of the Company.


--2f0f836d04ce310c9d8a5f2c350653a259aa3f266d1338c545ee2bf85654
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<p>Protection keys are encoded in architecture-specific HIGH_ARCH_* VMA
<br>flag bits.  show_vma_flags(), which is used by VMA tracepoints and %pGv=
,
<br>does not name those bits, leaving them as raw hexadecimal values.
<br>
<br>Name the protection-key encoding bits pkey_bit0 through pkey_bit4 under
<br>CONFIG_ARCH_HAS_PKEYS.  The names make clear that these are bits of one
<br>protection-key value rather than independent protection keys.  For
<br>example, protection key 3 is represented as:
<br>
<br>  pkey_bit0|pkey_bit1
<br>
<br>Honor CONFIG_ARCH_PKEY_BITS when exposing bit 3 and bit 4 so only bits
<br>provided by the architecture are included.
<br>
<br>Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
<br>---
<br> include/trace/events/mmflags.h | 23 +++++++++++++++++++++++
<br> 1 file changed, 23 insertions(+)
<br>
<br>diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmfl=
ags.h
<br>index 2d76daacb70c..c8b8a980f8c7 100644
<br>--- a/include/trace/events/mmflags.h
<br>+++ b/include/trace/events/mmflags.h
<br>@@ -204,6 +204,24 @@ IF_HAVE_PG_ARCH_3(arch_3)
<br> # define IF_HAVE_VM_DROPPABLE(flag, name)
<br> #endif
<br>=20
<br>+#ifdef CONFIG_ARCH_HAS_PKEYS
<br>+# define IF_HAVE_VM_PKEY(flag, name) {flag, name},
<br>+#if CONFIG_ARCH_PKEY_BITS > 3
<br>+# define IF_HAVE_VM_PKEY3(flag, name) {flag, name},
<br>+#else
<br>+# define IF_HAVE_VM_PKEY3(flag, name)
<br>+#endif
<br>+#if CONFIG_ARCH_PKEY_BITS > 4
<br>+# define IF_HAVE_VM_PKEY4(flag, name) {flag, name},
<br>+#else
<br>+# define IF_HAVE_VM_PKEY4(flag, name)
<br>+#endif
<br>+#else
<br>+# define IF_HAVE_VM_PKEY(flag, name)
<br>+# define IF_HAVE_VM_PKEY3(flag, name)
<br>+# define IF_HAVE_VM_PKEY4(flag, name)
<br>+#endif
<br>+
<br> #ifdef CONFIG_ARM64_MTE
<br> # define IF_HAVE_VM_MTE(flag, name) {flag, name},
<br> #else
<br>@@ -251,6 +269,11 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		=
\
<br> 	{VM_HUGEPAGE,			"hugepage"	},		\
<br> 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
<br> IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
<br>+IF_HAVE_VM_PKEY(VM_PKEY_BIT0,		"pkey_bit0")		\
<br>+IF_HAVE_VM_PKEY(VM_PKEY_BIT1,		"pkey_bit1")		\
<br>+IF_HAVE_VM_PKEY(VM_PKEY_BIT2,		"pkey_bit2")		\
<br>+IF_HAVE_VM_PKEY3(VM_PKEY_BIT3,		"pkey_bit3")		\
<br>+IF_HAVE_VM_PKEY4(VM_PKEY_BIT4,		"pkey_bit4")		\
<br> IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
<br> IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
<br> IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
<br>--=20
<br>2.25.1</p><meta data-version=3D"editor_version_1.2.12"/><div data-zone-=
id=3D"0" data-line-index=3D"0" data-line=3D"true" style=3D"white-space: pre=
-wrap; margin-top: 4px; margin-bottom: 4px; line-height: 1.6;"><br></div><d=
iv data-zone-id=3D"0" data-line-index=3D"1" data-line=3D"true" style=3D"whi=
te-space: pre-wrap; margin-top: 4px; margin-bottom: 4px; line-height: 1.6;"=
><div style=3D"text-align: left;"><span style=3D"font-size: 12px;"><span st=
yle=3D"font-family: helvetica;"><span style=3D"color: rgb(143, 149, 158);">=
=E5=A3=B0=E6=98=8E=EF=BC=9A=E8=BF=99=E5=B0=81=E9=82=AE=E4=BB=B6=E5=8F=AA=E5=
=85=81=E8=AE=B8=E6=96=87=E4=BB=B6=E6=8E=A5=E6=94=B6=E8=80=85=E9=98=85=E8=AF=
=BB=EF=BC=8C=E6=9C=89=E5=BE=88=E9=AB=98=E7=9A=84=E6=9C=BA=E5=AF=86=E6=80=A7=
=E8=A6=81=E6=B1=82=E3=80=82=E7=A6=81=E6=AD=A2=E5=85=B6=E4=BB=96=E4=BA=BA=E4=
=BD=BF=E7=94=A8=E3=80=81=E6=89=93=E5=BC=80=E3=80=81=E5=A4=8D=E5=88=B6=E6=88=
=96=E8=BD=AC=E5=8F=91=E9=87=8C=E9=9D=A2=E7=9A=84=E4=BB=BB=E4=BD=95=E5=86=85=
=E5=AE=B9=E3=80=82=E5=A6=82=E6=9E=9C=E6=9C=AC=E9=82=AE=E4=BB=B6=E9=94=99=E8=
=AF=AF=E5=9C=B0=E5=8F=91=E7=BB=99=E4=BA=86=E4=BD=A0=EF=BC=8C=E8=AF=B7=E8=81=
=94=E7=B3=BB=E9=82=AE=E4=BB=B6=E5=8F=91=E5=87=BA=E8=80=85=E5=B9=B6=E5=88=A0=
=E9=99=A4=E8=BF=99=E4=B8=AA=E6=96=87=E4=BB=B6=E3=80=82=E6=9C=BA=E5=AF=86=E5=
=8F=8A=E6=B3=95=E5=BE=8B=E7=9A=84=E7=89=B9=E6=9D=83=E5=B9=B6=E4=B8=8D=E5=9B=
=A0=E4=B8=BA=E8=AF=AF=E5=8F=91=E9=82=AE=E4=BB=B6=E8=80=8C=E6=94=BE=E5=BC=83=
=E6=88=96=E4=B8=A7=E5=A4=B1=E3=80=82=E4=BB=BB=E4=BD=95=E6=8F=90=E5=87=BA=E7=
=9A=84=E8=A7=82=E7=82=B9=E6=88=96=E6=84=8F=E8=A7=81=E5=8F=AA=E5=B1=9E=E4=BA=
=8E=E4=BD=9C=E8=80=85=E7=9A=84=E4=B8=AA=E4=BA=BA=E8=A7=81=E8=A7=A3=EF=BC=8C=
=E5=B9=B6=E4=B8=8D=E4=B8=80=E5=AE=9A=E4=BB=A3=E8=A1=A8=E6=9C=AC=E5=85=AC=E5=
=8F=B8=E3=80=82
</span></span></span></div></div><div data-zone-id=3D"0" data-line-index=3D=
"2" data-line=3D"true" style=3D"white-space: pre-wrap; margin-top: 4px; mar=
gin-bottom: 4px; line-height: 1.6;"><div style=3D"text-align: left;"><span =
style=3D"font-size: 12px;"><span style=3D"color: rgb(143, 149, 158);">Discl=
aimer: This email is intended to be read only by the designated recipient o=
f the document and has high confidentiality requirements. Anyone else is pr=
ohibited from using, opening, copying or forwarding any of the contents ins=
ide. If this email was sent to you by mistake, please contact the sender of=
 the email and delete this file immediately. Confidentiality and legal priv=
ileges are not waived or lost by misdirected emails. Any views or opinions =
expressed in the email are those of the author and do not necessarily repre=
sent those of the Company.</span></span><span style=3D"font-size: 12px;"><s=
pan style=3D"font-family: helvetica;"><span style=3D"color: rgb(143, 149, 1=
58);">
</span></span></span></div></div><div data-zone-id=3D"0" data-line-index=3D=
"3" data-line=3D"true" style=3D"white-space: pre-wrap; margin-top: 4px; mar=
gin-bottom: 4px; line-height: 1.6;"><br></div>
--2f0f836d04ce310c9d8a5f2c350653a259aa3f266d1338c545ee2bf85654--

