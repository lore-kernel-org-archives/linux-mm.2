Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E0BC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003016B013B; Thu, 23 Jul 2026 04:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFF66B013D; Thu, 23 Jul 2026 04:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CA26B013E; Thu, 23 Jul 2026 04:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC6996B013B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:14:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B8D11A0402
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:52 +0000 (UTC)
X-FDA: 85019330424.03.E3DF6FA
Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0896A160012
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=cWeqUg+9;
	spf=pass (imf08.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.35 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9UuNWq0gTy9Ty/9mZd1M32eFbtoNsmqK0vyCguT4AY=;
	b=fOC/K91n5tLG32A6r8bp5FJCVRB5/Hsqf8xnDdvIZbuxXEOIBY/eQruecdE7AHW4K61Phv
	SbjZXP3lWEJ3frw6GDVw1Gze2s/SsfT2KGuByKruOZF4UM51ia7flNkONtFlb9gfg0YBBr
	ZSJfPlMjST+smU58l22Pgm7euo/gumc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=cWeqUg+9;
	spf=pass (imf08.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.35 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794487;
	b=acSfjpLPUXiqYadX5K2yn7ViyxKtjjeGo2o/CrlFW9lCY1sqZBheYX9xaUXG5jHHmovQNw
	uSsxCJzllFKSCywHTGE7dRY7UVrSDq9iDeOtQo2II46Qhh6AQwu8XXqAS3RjZtJLw7sXRj
	80UcnNTz/r7NmQH8f+EbU5UTPNkMxs8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lixiang-com.20200927.dkim.feishu.cn; t=1784794480;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=u9UuNWq0gTy9Ty/9mZd1M32eFbtoNsmqK0vyCguT4AY=;
 b=cWeqUg+9dmPkAk5ca5lXD6bJLHkZBeTlH/bIY1FRFYhTSXfeuAgU2KI/7sb+xrm7CfFb0d
 65Zj0rFkTr/8HCPffoM70/sieZL5bBi5UToYWUSGi9d0SWLv9hle7Ce1Ctk+r+NQADbAAe
 SfExILZViw565W0vTBPYB24kcp6LStYDjIDAkcQoPjX3BjErm4JfR2NhF8/xJvORCpLnDh
 aRnCRi2MakpGOrVbKYkWRvFZvKREBmSYJtqVZmczKMeQsP9nMKJfeAggtqo9TUZHiE6ZiK
 XpfryL2ncITjekqVoOXOFwZIgOv7SFAbp0F4kkuxd7tLmTY5w/d81ysKsvqUmQ==
In-Reply-To: <20260723081427.587283-1-zhaomeijing@lixiang.com>
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
References: <20260723081427.587283-1-zhaomeijing@lixiang.com>
X-Lms-Return-Path: <lba+26a61cd6c+f205c7+kvack.org+zhaomeijing@lixiang.com>
From: "Meijing Zhao" <zhaomeijing@lixiang.com>
Subject: [PATCH 1/3] mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
Date: Thu, 23 Jul 2026 16:14:25 +0800
Message-Id: <20260723081427.587283-2-zhaomeijing@lixiang.com>
To: "Steven Rostedt" <rostedt@goodmis.org>, 
	"Masami Hiramatsu" <mhiramat@kernel.org>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	<linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, "Meijing Zhao" <zhaomeijing@lixiang.com>
X-Mailer: git-send-email 2.25.1
Received: from PC-2B0BA31200898.company.local ([220.248.55.69]) by smtp.feishu.cn with ESMTPS; Thu, 23 Jul 2026 16:14:35 +0800
X-Original-From: Meijing Zhao <zhaomeijing@lixiang.com>
Content-Type: multipart/alternative;
 boundary=e521202af606818774e5ec49e2ed41cd606f7b6435b62dac2131dfbf19bf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0896A160012
X-Stat-Signature: y7wu1ni7kng17s6zd5smk1ssqz967yxf
X-HE-Tag: 1784794486-263669
X-HE-Meta: U2FsdGVkX181e4tvdlQ+x/9qf4pUi1YP2K9yqa2yc6JszWZfKPdIgYqH1f5QPlvmarXXIA+lK39H2uPT3lVwbH/e5FSYDTozAw/rJo9F9Yaqj+zHX4uxr9MlL8FAw/G7u99pLbEBFyhSm1eiYnbO70DosS/cx8rWn/hAyA5EGfVUoXrsrdTwgZgP/TupjeWpVV8Yv2ZTVAw+kxUCqkKn2t1HWunjYuZb2bvtVBP+ZkNj3ndPIcktw6bgtDr0TMdwVlZWO93FraxgRc+tdLD8Ls9mPm2rCaQpv4G3ZXwTgr7PLSfm96ueIwoJSJk4a89uwXA48KkigyJm6CR9XDaqQXZxfCmnDProuFPHQWvr7mtWyMJkK1bXP4KHKCfASH0qD2809xLOZPTOKPY02eeZgMUBqnpk3ANRZ0LZrlV/8Krd6bAV4ZYQjSPED14acRyhDbz6vUV+4xQOfG4SZ+j/JxWUEAfZjpuy4yJTrZOIQLV5QQ6M2pAD/0JkPlHOuUlV4xYVYcIc3FOCT0rFMGFHwjikkr3om2t1EUpYsA8Vl+JyJRiDP1UHUUPLA44xBvaNNyf6Uatd1JXhlHTgk1qSzL6YSW9IBmBVmvC2h3j+gYGj/e+VWBzzuk5OzY88a3KvrWqS3PxqlfOaApIpy7oq4BTwjzvOXcz0joY7CmwSBzjVekYQX8Ns1SIBKBWSm0AThyq/yA4XZbQe/RW+ZVKOGCEMchKAYACeG7NsT/mUOwGPePFWcUYdBt/xhDaQrnYisLyah/ImkB5eo7pzAjol/EIhUUKRyXIP3MN5VTSNLEYgsT7lneXjSaDldDJJRGJ+bhmFqOuD4CzuMoOg7TpZcMdfTjU4ELGWFi7M0BGUNLAwmwfSJpsay7RMPIfKZJd01HzUn4PGjIrKID1p0ezxfK+CoOiRXka7cMeH70BG69UME/60XaDrpugvtspWwsschgtPvzZa4P+eYuAH7da
 PCDkm/gC
 W9Z4r0kmKrNTsuU1VKdwFOYGEyMZZ1qjcg3vO3pkMMIQtjXH/Zqovm5j6fwyb+AYtlCkp9GrLFOSWJGwMwAb80zekcp3LWtecaAn/owMbdx+ZjCWkhNg8j1OHBlXtCaNoHBrbriCLK5lZLknIF0eSdUf+qQaj1ZGCLRrXO1d7fhd2x7dvUaEl/42YXXcYVWv2kuba/28mOQ9G85hvDGQWOo8lls5ffe7bAMCnSnR9migK3O0R2HJ3ajGZDYCK7x3L8iYMf8jgtrb04x5vQ4/zH2/qMNEzwhCsLzaDz7wx4W9ZY7aO5dhCCwzo2QKouuOMsmfDE+BJl8a65AS273O2ljqzqivV97ZQmdt2nCwcqOIatgxvnl3woNNc+VNXQHCs1FCYSzXUkXIpFK66RVXj0b54Axrror2aUbN8h+WeuyNVuhZzZZ1r2OVoQE4wlZXB+z9313heV4oUk0yFKF2t3qCDavNnBrPW8xi0NO0uAQuh3L9fKb++1j5taRfLjYf8v2zVh6tTlYEFAGeQttXMvgaxsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--e521202af606818774e5ec49e2ed41cd606f7b6435b62dac2131dfbf19bf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

The VM_ARCH_1 bit has architecture-specific meanings.  show_vma_flags(),
which is used by VMA tracepoints and %pGv, already reports the powerpc,
parisc and no-MMU meanings, but falls back to the generic "arch_1" name
on arm64 and sparc64.

Report VM_ARM64_BTI as "bti" and VM_SPARC_ADI as "adi" so trace output
and %pGv dumps expose the actual architecture-specific state.  These
names also match the mnemonics used by /proc/<pid>/smaps.

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.=
h
index a6e5a44c9b42..add5ad6843e8 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -176,6 +176,10 @@ IF_HAVE_PG_ARCH_3(arch_3)
 #define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
 #elif defined(CONFIG_PARISC)
 #define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
+#elif defined(CONFIG_SPARC64)
+#define __VM_ARCH_SPECIFIC_1 {VM_SPARC_ADI, "adi"		}
+#elif defined(CONFIG_ARM64)
+#define __VM_ARCH_SPECIFIC_1 {VM_ARM64_BTI, "bti"		}
 #elif !defined(CONFIG_MMU)
 #define __VM_ARCH_SPECIFIC_1 {VM_MAPPED_COPY,"mappedcopy"	}
 #else
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


--e521202af606818774e5ec49e2ed41cd606f7b6435b62dac2131dfbf19bf
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<p>The VM_ARCH_1 bit has architecture-specific meanings.  show_vma_flags(),
<br>which is used by VMA tracepoints and %pGv, already reports the powerpc,
<br>parisc and no-MMU meanings, but falls back to the generic "arch_1" name
<br>on arm64 and sparc64.
<br>
<br>Report VM_ARM64_BTI as "bti" and VM_SPARC_ADI as "adi" so trace output
<br>and %pGv dumps expose the actual architecture-specific state.  These
<br>names also match the mnemonics used by /proc/<pid>/smaps.
<br>
<br>Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
<br>---
<br> include/trace/events/mmflags.h | 4 ++++
<br> 1 file changed, 4 insertions(+)
<br>
<br>diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmfl=
ags.h
<br>index a6e5a44c9b42..add5ad6843e8 100644
<br>--- a/include/trace/events/mmflags.h
<br>+++ b/include/trace/events/mmflags.h
<br>@@ -176,6 +176,10 @@ IF_HAVE_PG_ARCH_3(arch_3)
<br> #define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
<br> #elif defined(CONFIG_PARISC)
<br> #define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
<br>+#elif defined(CONFIG_SPARC64)
<br>+#define __VM_ARCH_SPECIFIC_1 {VM_SPARC_ADI, "adi"		}
<br>+#elif defined(CONFIG_ARM64)
<br>+#define __VM_ARCH_SPECIFIC_1 {VM_ARM64_BTI, "bti"		}
<br> #elif !defined(CONFIG_MMU)
<br> #define __VM_ARCH_SPECIFIC_1 {VM_MAPPED_COPY,"mappedcopy"	}
<br> #else
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
--e521202af606818774e5ec49e2ed41cd606f7b6435b62dac2131dfbf19bf--

