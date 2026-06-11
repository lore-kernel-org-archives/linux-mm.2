Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A943DCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F3F6B008C; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7016B0092; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC876B0093; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 704E66B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:01:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EE89C23DF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:53 +0000 (UTC)
X-FDA: 84867644106.01.0AA09D1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3388540019
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iTuqVWDl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3vbEqagcKCCQABARNASGOOGLE.COMLINUX-MMKVACK.ORG@flex--abarnas.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3vbEqagcKCCQABARNASGOOGLE.COMLINUX-MMKVACK.ORG@flex--abarnas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpVm5xmGC/R2ADzdtCLJ8S55VXRKmTwz2appu9MAZsM=;
	b=qBhLSGN4eZQ7qSapJV2V1ZPYBCqCkqvP73z/E6zL/HYVk7cDhYge6MO8ko0KWKNsXqSVdh
	yesdFdhtxtJj6myzv7cATvUJDty20HiNVqoPA8F9/8yuB82G3WHQ+g3h69vf9vbx+TWLBU
	KubExLG4wii8SvRVABEuEGlm9Z/T39o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iTuqVWDl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3vbEqagcKCCQABARNASGOOGLE.COMLINUX-MMKVACK.ORG@flex--abarnas.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3vbEqagcKCCQABARNASGOOGLE.COMLINUX-MMKVACK.ORG@flex--abarnas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182911;
	b=HL3jaWLkcv7lCdlQ3dmRu9EqA+e1dfS7S1E/0ZmOSw1RARYYVRtNbQIHa9FcoOPvddnMRs
	Hmgb0Xp1Bo03A8CeTM7qO3LN1UIXpVO6Z+cygQzqvxCP7BoPIowp5/MaL5z3c/3tC/+HRN
	epwv8ply2DlIAF6M8I5n0m1kZRan6f4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490ae0167ceso37958995e9.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781182909; x=1781787709; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vpVm5xmGC/R2ADzdtCLJ8S55VXRKmTwz2appu9MAZsM=;
        b=iTuqVWDlLTTs1fTU16219cmuDrrFcx8Bvx7I4bNSsCgFZUxVyBLYsggWfOKC4W9JVV
         AcLLaFozWiapZ1od5ZdVawKJdV3CYigFq7FDvBsTs1diHUztg1y6aXxtvz+Z9U9L41l0
         kfXEdeSDEnITdHYoXX/YjeiulmgaycclTahuHu9pXWq1d+mtTwd6zB/5GYn4PNOwi1tJ
         D7DiluBT9YTae/WNp1nz1TWpwDDvFV32f/egNmqXxEmdlIkq11r/CiJPdk30Nyd1LFft
         cqi+fd6s7gXOOaJdl9A33/4w4EZUnAuvwVSl3u0LJd3z3cLUvl16TWfaEyhN6yAE/0K2
         ii5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781182909; x=1781787709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vpVm5xmGC/R2ADzdtCLJ8S55VXRKmTwz2appu9MAZsM=;
        b=sroFBIB/Ie/1ZIZ71Knbq60lasF9AysVdtDdFOKM1gEOzeYprfFwIDllTvI4hIR/FF
         r/Md+zxBt8/M5LnPz6jVa28pxHVh86oKg5QtTGy7qg8vaMBngrhhQ7WGCMvwM9SqZhsK
         WYk+j3zBheJDjo1l66tI3tD2v48uqMaqkAYlONUl2lWD0Qgq00xeaWgI8/plJNdS5seN
         hmrFzKEzhs0toD56RZDbVpknChwPQEUGc5oRefpvsx1cUZt6LVFffWb7ZW+JX1I0kG13
         tfDnK/q5BFiqhNe60C/DE4Ch+ycCiziCJe0LZSbPHMq/e8tsOrCsFJJ8tarOZUMcYXUo
         g/HQ==
X-Gm-Message-State: AOJu0Yzj/uMcbJnolrE+VX2XWwEhKYfJlg2xESFmf/w0B1etU7vAu37E
	kErgh8cCSGX9A3uRS0I7sXbCSjk0bPt74/6Snx4egj7av7HnXwiCeRZOCnh6MKoyMURs2f4q3ml
	ny/dP5Oe94g==
X-Received: from wmpd18.prod.google.com ([2002:a05:600c:4c12:b0:48e:6f63:7624])
 (user=abarnas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d04:b0:490:b58a:dcc1
 with SMTP id 5b1f17b1804b1-490e5614165mr34126615e9.29.1781182909448; Thu, 11
 Jun 2026 06:01:49 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:01:39 +0000
In-Reply-To: <20260611130144.1385343-1-abarnas@google.com>
Mime-Version: 1.0
References: <20260611130144.1385343-1-abarnas@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260611130144.1385343-2-abarnas@google.com>
Subject: [RFC PATCH 1/6] arm64: mm: explicitly declare module and ftrace
 execmem regions
From: "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3388540019
X-Stat-Signature: yzemx8af1qiwqiouxh45ops1qta63kwt
X-Rspam-User: 
X-HE-Tag: 1781182910-690646
X-HE-Meta: U2FsdGVkX1/v5xbEjHGlt4aiyDnCeC32wLHaIpHLtyST/vrRrMloS0jPMeofvASeDbkVIcu/e01mwO3vA8QAaUlhkVKO+2zWrNuh2bXl2XvvotXD0TbWaAtS4T94oYHNxkqmFxJ9+d58ySmSvIDzD3BWRnhQ2+9QfphTq/Ss8eNtdkPfBLI6qeTcodKMwHp6NVT3UWD42Mjisw+ZWFb9kS0L5LmItS4jk/R8eq46ajWTnShSfwPbNCwPn6sBRQj8dwXThMQFvsU91PGfMTjp85SzZDQrNPUOxtJ0OxkWZcxIv2ubHixkOnsaGZQaHULH3W4B6J8xQENg0Y6naU6c7fAAAzoVaXMM5Vnbs+AswHd9UHQcfbNvSNWMuHE4M38ery3Br5SMvTc86TOhWC5hB6Ad4I5Kccj+hTh2lOe7M4Utd/D74VmQCCsryDFYBw2XR5sZr4vuEY0+cIYojV/T1S1k28AM1WzudooqL8qEc7usBIVrbjvroMWrRUqQvfcqPbVtwflFmmVW73CkqDabNabfGmg1IEL6iqzBHceXdaXoPz71eivvRAfBu2/7pZpIw/kTLs/4A9XfyhsVp6iCTchDeTAgI/QWdJuEQT53j1Q2aEUEvLkiTS51u/94UizuveCYU5efg7UXvtZ1rNkBI6pwtwJLLsxWOfIvPoJvQjN5DVPF2DY2FMEvZ9d1m/0aWV2YuXYDKbIC3/Nkna3N1cPXRhBAJIfh463J1nrFLAERo/yn9TyionIeTNQD+QlxwNh6bxYJmtLnbNZ/LHaeNLdEUJbNcisuGo6Q0FE9K+bkBiob27C/ULblxLYHs1ldnc0IYFODO6nrL4xEMDmfe+tt25l//pvjp6wgkM3evT6RZPC3Y9nLPvKhxfH8bXlGkgl5QqbVvhiJU2cICK0jO1rzW8rzttLijITeJ/mgAPNAoxMSMFGQ14Pyhrx3XnF56b0pRRHb/1iFQYOO8zU
 b08lwTWt
 FRN4IrgxOEl1CTVQt9OY4TNlkGDPbKkObOYK3e+1gncBJ4cHbVY2R3cvAhw6taFq3xu7ASY6NNP/emLy050TtwYYRX2JaC4xiebUDJGfHOrLK5BPTcEl/dfXtS3IaqPdByIWWF/BcaSQM+ndyXsKRqvlqX6kRc6hcGQ5OgHUxibbB1Qn94FQNtqfALyrpCKx+HCMsQEl9Eofq29PKKqKZSktvKwA4GP6vwuGuf7wHnOmN3PJvkk5cB0blgstVQj9Fd8sh9SpMbhSg6YA0j9DYVB7p/yzoTHbhE8VKkvwzxyFD/QaJN3UMfrbvKd+xjRnhVQgNpvVdojhOcAG+zNLLJ1OcFh4WicN88gHnD3IqmYf3AYBETM56u8wDgmeeZVNqg/Sr7r+cdD62Zpd1CeiVjokYqCwvSn0pET9QF+/uQtsDK4cFWcVdb0h2I2HxH6bpAOxxsBQBYV+ofj8dfPm25Jjt0nWvJYRlGmn+Ri4b1cDKTmzMuei61KlqERKelLN+e8ayQ75si05W6MWz8qa3FQLAhPrNroJgnpbT+59Hg537ppWGcUhmExdEgmqAf52SvxNF6WFwKWmZLD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the reliance on the EXECMEM_DEFAULT fallback by explicitly defining
the execution memory (execmem) regions for MODULE_TEXT, MODULE_DATA, and
FTRACE in execmem_arch_setup().

Signed-off-by: Adrian Barna=C5=9B <abarnas@google.com>
---
 arch/arm64/mm/init.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 96711b8578fd..c673a9a839dd 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -519,7 +519,7 @@ struct execmem_info __init *execmem_arch_setup(void)
=20
 	execmem_info =3D (struct execmem_info){
 		.ranges =3D {
-			[EXECMEM_DEFAULT] =3D {
+			[EXECMEM_MODULE_TEXT] =3D {
 				.start	=3D start,
 				.end	=3D end,
 				.pgprot	=3D PAGE_KERNEL,
@@ -533,12 +533,28 @@ struct execmem_info __init *execmem_arch_setup(void)
 				.pgprot	=3D PAGE_KERNEL_ROX,
 				.alignment =3D 1,
 			},
+			[EXECMEM_FTRACE] =3D {
+				.start	=3D VMALLOC_START,
+				.end	=3D VMALLOC_END,
+				.pgprot	=3D PAGE_KERNEL,
+				.alignment =3D 1,
+				.fallback_start	=3D fallback_start,
+				.fallback_end	=3D fallback_end,
+			},
 			[EXECMEM_BPF] =3D {
 				.start	=3D VMALLOC_START,
 				.end	=3D VMALLOC_END,
 				.pgprot	=3D PAGE_KERNEL,
 				.alignment =3D 1,
 			},
+			[EXECMEM_MODULE_DATA] =3D {
+				.start  =3D start,
+				.end    =3D end,
+				.pgprot =3D PAGE_KERNEL,
+				.alignment =3D 1,
+				.fallback_start	=3D fallback_start,
+				.fallback_end	=3D fallback_end,
+			},
 		},
 	};
=20
--=20
2.54.0.1136.gdb2ca164c4-goog


