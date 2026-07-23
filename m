Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8025C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758566B0135; Thu, 23 Jul 2026 04:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E956B0137; Thu, 23 Jul 2026 04:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644436B0138; Thu, 23 Jul 2026 04:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29F146B0135
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:14:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97DF5A041E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:48 +0000 (UTC)
X-FDA: 85019330256.13.F8217B2
Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	by imf01.hostedemail.com (Postfix) with ESMTP id B846540009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:14:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=zmsVS2F3;
	spf=pass (imf01.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.28 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yJqLogEjCL8Rn/xJryHgkunz0XWfrILiKEEOgUCtqlM=;
	b=F+WfJB2CdrNu4YoAbn8un1JYjrBx8mM7U4GpRM6GRvLXSvQ3mQV+9zAaR+2t3UVCZhAXwK
	wJGqVdtHyC3CjoWJQmtI6a8dASSw/QmASDtz7tvN5toBgAk0TbxJ8wMbZVlITeC6nyedbp
	EbT54uwZaDl9PjQ1AgXwLs6qgTYQD+M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=lixiang-com.20200927.dkim.feishu.cn header.s=s1 header.b=zmsVS2F3;
	spf=pass (imf01.hostedemail.com: domain of zhaomeijing@lixiang.com designates 209.127.231.28 as permitted sender) smtp.mailfrom=zhaomeijing@lixiang.com;
	dmarc=pass (policy=quarantine) header.from=lixiang.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794486;
	b=rmUh2CvpX/fIS784dVLtxpUtueuT6dCL4ge8coXm7l77Tkv633HfUifql0OUWWMZgmuBf5
	Wycq4JNLho2iR+pf8W11THRBI/5adCDKyXh1Oo8iO4+0jPGrIQQ724bNSYfYjXFVYB5jA6
	apsdOotj5pXE23NnacUZq6D8W7VE3kE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lixiang-com.20200927.dkim.feishu.cn; t=1784794474;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yJqLogEjCL8Rn/xJryHgkunz0XWfrILiKEEOgUCtqlM=;
 b=zmsVS2F3jvOXdVK7QR0PH5JDmSSslDsOVYJOjNGR5stn471k/PnUyE9KUpcDJFo3pLbPP1
 Kt7SSmRVnZfGR3Ldw3WkdbXbuibZ7MMhJgKaPIUp1LXsDnhexvSi00Wg3WvmllgQehJL/z
 9jK/AQ1G37223lsoL+7maEvio1an4gKykdwd6Y8HQbwlp7TH/kNyC5MQqDnp5tuKrJhwOI
 cU7hqwj4phzpuisxR4OnPsYQ1YgYVJSASnHfT+2IgRUhhLvgwTGTphzgQyWq0D0Jx2Cof0
 XTTcsCfKucEAoZaBRh7jxdW1DB5znHeBZGbWvbyvVfCgzGFDr3GP3ow1s2nbiQ==
To: "Steven Rostedt" <rostedt@goodmis.org>, 
	"Masami Hiramatsu" <mhiramat@kernel.org>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	<linux-trace-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, "Meijing Zhao" <zhaomeijing@lixiang.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1
X-Lms-Return-Path: <lba+26a61cd68+45d9f9+kvack.org+zhaomeijing@lixiang.com>
Message-Id: <20260723081427.587283-1-zhaomeijing@lixiang.com>
Content-Transfer-Encoding: 8bit
Date: Thu, 23 Jul 2026 16:14:24 +0800
Received: from PC-2B0BA31200898.company.local ([220.248.55.69]) by smtp.feishu.cn with ESMTPS; Thu, 23 Jul 2026 16:14:31 +0800
Content-Type: multipart/alternative;
 boundary=5cbfbf58fcd35742365b83ffb5de5a04faef1daede98a67b8c942a80f7af
From: "Meijing Zhao" <zhaomeijing@lixiang.com>
Subject: [PATCH 0/3] mm: trace: decode architecture-specific VMA flags
X-Original-From: Meijing Zhao <zhaomeijing@lixiang.com>
X-Rspamd-Queue-Id: B846540009
X-Rspam-User: 
X-Stat-Signature: 5b3aajy7q47dkzd7rnszb6a3f3y7tgox
X-Rspamd-Server: rspam04
X-HE-Tag: 1784794485-441039
X-HE-Meta: U2FsdGVkX1+nOjibtqpvSsz3yrkCTuUe7RitxdXXOLfZ6YT/RUFTb/bzRCsXy3z+RtB6xdNPN+KSCiJWtS59YyYwFKc4I1Mf4HjpEkvQe5jUStnUsCPNkmEegfHonDa7ZFjPJEwA+xHH3IDywaRx75kHUgT+hm8drJBYl5Jc4r+rt+yCTRlUCUIzV7h+hoa5Ujvr5mu0K/3DeTMZgokFb6MwgUE+MFyQ0OPpfM4zME58Bd52yEVnXHywKDiibqQjjdqzDdynlbV12QOTP8RrvgIFViY0X77G0hOgAADxPqKQJ4yfVA+AQm/B9rQk5jkp7ixcd/JHkJ60RFBaLHfsKrSnsAs/RRyMx2OuJ5I6x6gk9trc8jFVwW1qq7mixBmGB4AEoNEK5kvP3eaz0muKH3auFixdbpGPuLDGgpZMWtyq1GsoRc4y+rRiFAsmbZ1GCF7W2dE4f8OvDeX+v/Dujx++5UDvGud0wqlZ/IO0gYvM1YvhGCBFsaXaXPHgBGOPu4BZevQtu64WePSaSWjd/GqoU0BMSW6ahyMrowgV6WSqLRGfC2qpfxlna8e2NP0ytVM0TQRsK5hdBXhIG5UcMTu1t7O2KWNhERhG9GzQeNzBn1KhTrirRGX+kYbs+pee5HEvYNIUF2+JC50eO6bMRhhblEYx50Yh4nSKZsbgbDjnNyxSd0tCVmtyCvW5wvz2EIqtoCXTKE0DfE8VFfrC7SSBlfzXyM0gqfkYW/ucElfAYk8JU2FkwoMCiJIQYRpr3gQAflqiC9QTEStRChyZLBw3WSL/u+f+Aj67zRxLERY++4ZNK4qdAM5WxBJe75gprMN0iWaRXCRp7a6V9TvtgKSEf/1snjl5a9SRkUl3hLxCSUMhk5jRUM2LZxr+VLqDxreNG2DtVcpfWlp9WbG2fVPrqnR+8a/GDm4pJkHvJXjlk9z9Qcw4AL6C4HbJkvcbFnZK+0Kl4Y+W7oGg0TK
 YVjbJ3bQ
 1QwggimzZUZmTjFkewpbzITpSy2pysikYgSb3W1FhLqrXuu7UGgfwtE+sAHCpVOtSD7u1lYuu2kjkrbIlxlpyou0LEf7YKli+U/iCvt+IRVqUrMIPcnrVlb193N/XE2Yv89RhnAiS9UTSVDLizTxnvimLAir+CJ8t2jVmBv/4r/FxuUeGjCFqyC+HqsywUuIbFeH4M2Ut3zxB6u5BjgVPfaF5YsrGMNd6xw43VOjmzDSOXcV1eTcdAVInWX5FCWgoDFDcVkCICjl81pyBSpGHRkZAT/x2bIPdVNhp1h6CM36DdZezVurFyiv3wi4SKr0WjKgoS+RqexMtBc32y8hpgECOsaL2vW2QRFZlw9Opcz8f1Ia1z4WDR1/QWNaV+SMv2kwJiN/WnNajtekxqBDzCPRRHaehFBG4paGqX9Qouo7rua01t2k/gVKRgZvA6WHzN/FwmYIX/DVRndM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--5cbfbf58fcd35742365b83ffb5de5a04faef1daede98a67b8c942a80f7af
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

show_vma_flags(), which is used by VMA tracepoints and %pGv, names
generic VM_* bits but does not fully decode architecture-specific flag
positions.  As a result, trace output and VMA dumps can show a generic
"arch_1" name or a raw hexadecimal value instead of the meaning assigned
by the target architecture.

This series adds symbolic names for the arm64 and sparc64 meanings of
VM_ARCH_1, arm64 MTE flags, user shadow stack flags, and protection-key
encoding bits under their corresponding configuration guards.

Meijing Zhao (3):
  mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
  mm: trace: decode MTE and shadow stack VMA flags
  mm: trace: name protection key encoding bits

 include/trace/events/mmflags.h | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

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


--5cbfbf58fcd35742365b83ffb5de5a04faef1daede98a67b8c942a80f7af
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<p>show_vma_flags(), which is used by VMA tracepoints and %pGv, names
<br>generic VM_* bits but does not fully decode architecture-specific flag
<br>positions.  As a result, trace output and VMA dumps can show a generic
<br>"arch_1" name or a raw hexadecimal value instead of the meaning assigne=
d
<br>by the target architecture.
<br>
<br>This series adds symbolic names for the arm64 and sparc64 meanings of
<br>VM_ARCH_1, arm64 MTE flags, user shadow stack flags, and protection-key
<br>encoding bits under their corresponding configuration guards.
<br>
<br>Meijing Zhao (3):
<br>  mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
<br>  mm: trace: decode MTE and shadow stack VMA flags
<br>  mm: trace: name protection key encoding bits
<br>
<br> include/trace/events/mmflags.h | 43 ++++++++++++++++++++++++++++++++++
<br> 1 file changed, 43 insertions(+)
<br>
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
--5cbfbf58fcd35742365b83ffb5de5a04faef1daede98a67b8c942a80f7af--

