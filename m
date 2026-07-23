Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEE6C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003096B0137; Thu, 23 Jul 2026 04:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF176B0139; Thu, 23 Jul 2026 04:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97A86B013A; Thu, 23 Jul 2026 04:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A38D66B0137
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:14:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23599403DC
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:50 +0000 (UTC)
X-FDA: 85019330340.16.4B4E36C
Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F71F1A0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=RnRNznuk;
	spf=pass (imf19.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.26 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=re576j+UE1+nlTJ0rhenHe6/IVTMRdCMWkcYxZdL44U=;
	b=A6u0wcmqq2EUD1A3bwWsQGiEC/mdDX0jEyuQ1sr4vd0srEXI9Wnfg8e2x79jWOVVtQrTG2
	X57x57NVgctb5lPJ5O06SP882fJvbFwV0kP80OI6YS2klFLdkM+9d2zCbZ4knchxVMH8uA
	tDCWLD/lFP2xWVprIW3LG4MU2q2hIRg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=RnRNznuk;
	spf=pass (imf19.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.26 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794487;
	b=H0aEpTVqaxLXZCXK0RkS1p+NpyztoMym5mkdUaFY2n7rPVAGKB+1OcSwwNYheHzPjwzRjd
	Jx7i7kbmbslV+gSn7C4nF+HJibI0xZfl8EoDxhMOw/T/SPeGl+qX7aAvFLw6yIP5tV6DuI
	0AfataKX5T9fcTf2L7ND1yy6zpIADOU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lixiang-com.20200927.dkim.feishu.cn; t=1784794482;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=re576j+UE1+nlTJ0rhenHe6/IVTMRdCMWkcYxZdL44U=;
 b=RnRNznukrJAn06UmPbVmCDJqLZoZcB94Pz8hhLk58LPC9gPo+vZ47PVGg/4a3bvBXudeTZ
 fo7bmnBF0PQwYfncKG9pOgG59i1+WHuzbz8Oi2SPkmr8BKHmPYsZ92z4iMycqAtN3hXSKv
 okZcFPN71OdGM8SH9Q0uxcbhQ7sbF12LKMoapDVM0m2nVqKxrxSrTRC0JKTqzcd/Ym5KNu
 o5VVggfjxeU8Gt0rktXhZGdFHSb7CEiqLmreK1m55XHxmMDPpVgtLZg49VkUhdrEweUjfS
 AsbMdJgpUUkrwHtotZK8UqXfF7dE5pXWktbiagjK/gdeYClCXpyfAhaJTBIiog==
To: "Steven Rostedt" <rostedt@goodmis.org>, 
	"Masami Hiramatsu" <mhiramat@kernel.org>
Content-Transfer-Encoding: 8bit
X-Mailer: git-send-email 2.25.1
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	<linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, "Meijing Zhao" <zhaomeijing@lixiang.com>
Subject: [PATCH 2/3] mm: trace: decode MTE and shadow stack VMA flags
In-Reply-To: <20260723081427.587283-1-zhaomeijing@lixiang.com>
Date: Thu, 23 Jul 2026 16:14:26 +0800
Message-Id: <20260723081427.587283-3-zhaomeijing@lixiang.com>
References: <20260723081427.587283-1-zhaomeijing@lixiang.com>
Received: from PC-2B0BA31200898.company.local ([220.248.55.69]) by smtp.feishu.cn with ESMTPS; Thu, 23 Jul 2026 16:14:39 +0800
Content-Type: multipart/alternative;
 boundary=2ca289da7952ff7705d8340b5c4616cf5f9d45f99074a18f6b0085535688
From: "Meijing Zhao" <zhaomeijing@lixiang.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a61cd70+b92e84+kvack.org+zhaomeijing@lixiang.com>
X-Original-From: Meijing Zhao <zhaomeijing@lixiang.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F71F1A0002
X-Rspamd-Server: rspam01
X-Stat-Signature: 4cfrcooyebb353665rfpxw1r8ttcs5oz
X-HE-Tag: 1784794487-693971
X-HE-Meta: U2FsdGVkX19aMYikmQI0Ih4unANzuC6yBErHF/lQFtRr8y5tg6UAVAyChtWRhiNBgWfTbD8JGTXhtJwgaGNtovJTn477U7fr+wK8qzXn7tzf4gCT0aHxYEu/QUaNjCe2/4O3Ceb8nkW9eN3DNjtIzHCNv6AbUb9C2qGJ2zIf363O0wFHLV+PEDsZQp8OUOrmdukU046GwUpeYzKTf9Z2v47Fx+gLb0PvZg3gBgXlP+SbvA1hLHwfy62LE5nhFv0FJ9tGJoS0zAoZcc0M+7UqZIBz9XbpLAdBzMiwPlK8bLWUQD17kwQPOW55VNMlPTHT+qlEu5YAXd3rLtJKD8XPpXjLtXhKKCcCVkbFvCrZMobKRzaV2zU3yf7gso1B5iEkabPdDgsC0tE3mmffB4EfoTZud9QqPRWBzTJWBWhdtzVZ3o0QFcPZPr5NQCHFYVs5wLxlqBmcenJ3/dNzQ1OjJBtgtBr062XOzGhJ6LqJa1gX0SJ2vLdciWZzwFJvkSPOOhzPChWDwDinvVy8aGBgf1VyyaFQJUASQL6MKPa8QPJ34r9r/EESsz2TbSRYCY3GHKZ5a8qnQVMaVOdMdoyWraZBFqv3DK7UHWiYnB4sGrHnvIlvYknGjaOqkcgJcGlXdI1We8riXo1KFWiuELsw0AHT//ffbdw3dvv3SMiYW98EGUT5OekyONdCfyC+sKF7WkrLNEkvFRtXMTQc1X7bu4SG2H4h3in/z4ygg44UBHwpzBk3ZJ418q7pHpHsQGLyCKfUV+Kntrx9m5jRx8IB7d1vwT/pY/j6Rh3uhHLkPCVl0G27/1Mjuyxk0/9WugCq/Iv0idr/11HZopyti6D5oS2acKKj0eZY3ig8P840vbaYp6qWR1lSyoNJE+Xl1n+DiBbY9fatIa7UiGGpH7BXXGXYMVgTG6RF06M1xGyA4SjPRG4rcloonvASCNnBtLLP5jME7SwLjJkIThWkSDi
 0pxUDIaf
 /LC01j5MjfzyyuSk3ZDAYA0lNEb7FXsiBba1+Dcr612kIM3c+g+lJLE0IesLEF6oTTNhpQVLci3oVddfq0GzUB1iEbXhZwHe9AnNP4OA3X9iI9Krll2AT3JBCLYYJIwMaxhn2RiABd5qnBcNBA7eua869C85OGHR8jOni+gVWXMcam74kk2nOQIDOA/TyBiNgLdkI5a74lrvS6YppH5Hg+6oLMe1NtSCpVzHR30y7cbEmxbEQXrIQYD4bJ/uqRVgxI67cgR6jKZBUBlhkpoALuaVPOIuBRBK161leRG9tc6EeXN40S/jmGKN8tnB7ZWiiSM4vIQBYbU1PR9hgVXhROPeHTADn8fFQ7BRjs0RZqYHg71/cEFkp2eeZFuTsmKNaUs2QHarygpo6/2oCu/FGs1b2jwomC6kbTE4SXrdM9hKZhvxTFMwqGyub6S8WEoFaoCHYuzbogv2peRwskI/SPGpiiNlBbmorGzC2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--2ca289da7952ff7705d8340b5c4616cf5f9d45f99074a18f6b0085535688
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

show_vma_flags(), which is used by VMA tracepoints and %pGv, leaves
architecture-specific HIGH_ARCH_* bits unnamed.  Arm64 MTE flags and
user shadow stack flags are therefore printed as raw hexadecimal values.

These bit positions are shared between architectures.  For example, bit
37 represents VM_MTE_ALLOWED on arm64 but VM_SHADOW_STACK on x86, so a
shared HIGH_ARCH_* bit cannot be given an unconditional name.

Add conditionally compiled names for VM_MTE, VM_MTE_ALLOWED and
VM_SHADOW_STACK.  Keep the configuration guards aligned with the
definitions of these aliases so each shared bit position is decoded
according to the target architecture.

For example, an arm64 VMA containing VM_MTE_ALLOWED is now printed as:

  ...|account|mte_allowed|...

instead of:

  ...|account|0x2000000000

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.=
h
index add5ad6843e8..2d76daacb70c 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -204,6 +204,19 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
=20
+#ifdef CONFIG_ARM64_MTE
+# define IF_HAVE_VM_MTE(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_MTE(flag, name)
+#endif
+
+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_RISCV_USER_CFI=
) || \
+	defined(CONFIG_ARM64_GCS)
+# define IF_HAVE_VM_SHADOW_STACK(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_SHADOW_STACK(flag, name)
+#endif
+
 #define __def_vmaflag_names						\
 	{VM_READ,			"read"		},		\
 	{VM_WRITE,			"write"		},		\
@@ -238,6 +251,9 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
+IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
+IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
 	{VM_MERGEABLE,			"mergeable"	}		\
=20
 #define show_vma_flags(flags)						\
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


--2ca289da7952ff7705d8340b5c4616cf5f9d45f99074a18f6b0085535688
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<p>show_vma_flags(), which is used by VMA tracepoints and %pGv, leaves
<br>architecture-specific HIGH_ARCH_* bits unnamed.  Arm64 MTE flags and
<br>user shadow stack flags are therefore printed as raw hexadecimal values=
.
<br>
<br>These bit positions are shared between architectures.  For example, bit
<br>37 represents VM_MTE_ALLOWED on arm64 but VM_SHADOW_STACK on x86, so a
<br>shared HIGH_ARCH_* bit cannot be given an unconditional name.
<br>
<br>Add conditionally compiled names for VM_MTE, VM_MTE_ALLOWED and
<br>VM_SHADOW_STACK.  Keep the configuration guards aligned with the
<br>definitions of these aliases so each shared bit position is decoded
<br>according to the target architecture.
<br>
<br>For example, an arm64 VMA containing VM_MTE_ALLOWED is now printed as:
<br>
<br>  ...|account|mte_allowed|...
<br>
<br>instead of:
<br>
<br>  ...|account|0x2000000000
<br>
<br>Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
<br>---
<br> include/trace/events/mmflags.h | 16 ++++++++++++++++
<br> 1 file changed, 16 insertions(+)
<br>
<br>diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmfl=
ags.h
<br>index add5ad6843e8..2d76daacb70c 100644
<br>--- a/include/trace/events/mmflags.h
<br>+++ b/include/trace/events/mmflags.h
<br>@@ -204,6 +204,19 @@ IF_HAVE_PG_ARCH_3(arch_3)
<br> # define IF_HAVE_VM_DROPPABLE(flag, name)
<br> #endif
<br>=20
<br>+#ifdef CONFIG_ARM64_MTE
<br>+# define IF_HAVE_VM_MTE(flag, name) {flag, name},
<br>+#else
<br>+# define IF_HAVE_VM_MTE(flag, name)
<br>+#endif
<br>+
<br>+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_RISCV_USER=
_CFI) || \
<br>+	defined(CONFIG_ARM64_GCS)
<br>+# define IF_HAVE_VM_SHADOW_STACK(flag, name) {flag, name},
<br>+#else
<br>+# define IF_HAVE_VM_SHADOW_STACK(flag, name)
<br>+#endif
<br>+
<br> #define __def_vmaflag_names						\
<br> 	{VM_READ,			"read"		},		\
<br> 	{VM_WRITE,			"write"		},		\
<br>@@ -238,6 +251,9 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
<br> 	{VM_HUGEPAGE,			"hugepage"	},		\
<br> 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
<br> IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
<br>+IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
<br>+IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
<br>+IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
<br> 	{VM_MERGEABLE,			"mergeable"	}		\
<br>=20
<br> #define show_vma_flags(flags)						\
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
--2ca289da7952ff7705d8340b5c4616cf5f9d45f99074a18f6b0085535688--

