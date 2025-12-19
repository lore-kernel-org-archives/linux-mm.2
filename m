Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A33E3D70E0C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426816B0088; Thu, 18 Dec 2025 21:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE2A6B0089; Thu, 18 Dec 2025 21:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327D06B008A; Thu, 18 Dec 2025 21:13:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FFAC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:13:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4D9713649C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:13:08 +0000 (UTC)
X-FDA: 84234598056.06.7461F2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE99DC0003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:13:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cYb2Em5K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766110387; a=rsa-sha256;
	cv=none;
	b=ipK27ie2xUOq4V7UnYz9ro4NvoXHPpg7Rz1D7viFQZghi6C7A90vsYF1HWnjvtFej4bD1v
	jDrVWZK+1cpAhUnYBqYc7vmWlklU2kO6eo2z/TFYoWial9OfRad9pNVpZXlu9LaRy9IIvI
	qHXpu7XjRNvHwfJN30MXnieRqVSvPZo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cYb2Em5K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766110387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EleYCXTllQ1Ksj0san+UXP+fimOICR25jVAXrgMxFYA=;
	b=3c4AiuYf+FbH8lax3EBBERIE9Bqpq2q59MT0wWmHEDHkm2KK5cfblfwhsNruPoqrfeg7c8
	jUHNoDkJNKdZcDUY5V2gPe6b57WrhkMgwKO53zysfg7wKzPQEDSfBUsiU3pzhE6gnY1TJr
	wZc+7M3R0qXiriTvHL433p5SIXj0J4c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC40743FA9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916C4C16AAE
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766110385;
	bh=triT9QSniQeKLUtzo8vt39E1h9cOrKtbwvOui4gIQNo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cYb2Em5K4Ke5enOtxdMRo/UEGdVhx/aqBcAMPV1HiJMf3lhUP1okJuZYriqBo3ONu
	 GL+1IA3FGm+G+Uv5GCai1qi3CqHvLBLLfcwocx42jwxrSilLNiomem3/AAirB7Y2mj
	 jsdFcAwTBj90ctcxPhFwsm6GEWo0AZL95SRzGQLHvlldfhe5xJWvX9GkPGa+DFpXNa
	 5l6wbcVx5W87Qf25/jYy9z5qPukKnxmMJEMcuCwbgVO5htAYOLf7tVHlFmJDFh0EQD
	 Rs6U8VdHdrr2Jiz33ONXmv663P9AnIUn5CroLNdskWzk+5X+i9sXlrCjjZu3dIqBzi
	 53BaSe8WXZLfQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7ffa421f1bso415944866b.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:13:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWtloPJsXGKawJ3dGNCAyPxeP1SFQn7B+dB4UzP2DJPujC/uzdLaYUV0LxpNkqpGotvfxJbb+6plA==@kvack.org
X-Gm-Message-State: AOJu0Yxirt7bmKfqy6AD2qirYVr9a1vhbekaDruqlfRWVtkcEISmH0CW
	qfEQHxfPRiBDkfa03MHwc/kOn+jMPf8Tc8LuBOVslcv6xIEeDpYmxcEpVv/P5AFb+hABMxBW9xn
	0eaSXjt4zWQ3ROTQ5zEOdVT9y9MhRnek=
X-Google-Smtp-Source: AGHT+IH0x7eNf3j0ubAysanhZGwFFKBdMBSuPdSso33VVXEaoaG0squlwQeXxPg9waRXjHWSnWjG/PFAV+VTiC2Kq2I=
X-Received: by 2002:a17:907:7e85:b0:b3a:8070:e269 with SMTP id
 a640c23a62f3a-b8035649310mr195334766b.14.1766110384189; Thu, 18 Dec 2025
 18:13:04 -0800 (PST)
MIME-Version: 1.0
References: <20251218063916.1433615-1-yuanlinyu@honor.com> <20251218063916.1433615-2-yuanlinyu@honor.com>
In-Reply-To: <20251218063916.1433615-2-yuanlinyu@honor.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 19 Dec 2025 10:13:15 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5n_3Ndk5yRm=S-9WktD9xivVF8-JLaycV8JB-pVuybbA@mail.gmail.com>
X-Gm-Features: AQt7F2qrv-imhdGopLt1MPfdTK-Ic-3FPg_HSxVXBdw9KIsFQZQLPR-6ZFBiyC4
Message-ID: <CAAhV-H5n_3Ndk5yRm=S-9WktD9xivVF8-JLaycV8JB-pVuybbA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] LoongArch: kfence: avoid use CONFIG_KFENCE_NUM_OBJECTS
To: yuan linyu <yuanlinyu@honor.com>, Enze Li <lienze@kylinos.cn>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	WANG Xuerui <kernel@xen0n.name>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE99DC0003
X-Stat-Signature: utet61a5th1gbb11dwndc5836cqz6iac
X-Rspam-User: 
X-HE-Tag: 1766110386-621377
X-HE-Meta: U2FsdGVkX18ellO+ZIPQeJyPMaQ/rjbFTrCCMflcRl4MPeuuQeZ+lUo4+ghYiACt+e02umDawPzyhDV/d56F/qvlcKVtZ+8Nhstpgx8HeY3lRbr8waE38bO18ygWsOKfo3/GpDkxBcpoosY7NYdn2hu4cWXJ3DP1ISc48VIn2pjAQTzzzWAKuA6DbuLSXZvakV7G3SY0fCBtEI4DqdkLQINh27FJrWGfOJTdRDYcr+u4la+c6aIEESQ3Rn8JWWlUJzrAvIp2iDJAiXkwPHeeZLpG9HwnCrJQEhQxL5m2xNhd9vXarDVQEOfmo3KLY5uL8uoqTmnLIMhWSop0N6aODoTaanF3HB3W4Grmj0YKNSSFERmijdOagqDSrxdhBN5NJmG/Oo8ek5/ME46nmnbBLvcH540UkfvruWXtdU9aODuDRwG68N/zl383e3xG3YMRCohlkOwL+KNPhXgOGO8gvIScJHeh2GsMF/uYDHOgAADnp9fMxdu4W6/STZ51kpbaOmeb7/gICLHfKYIUSqruX423CqG+WTWYy33CQHPMBcFysFspP8UW/Qlf+xNb+7tqhxvaaHOu96XgqY97VigyJV5vPoYoCQEUmdvc9vfopiDjSB2RWXFzgc9s1HVhu7MBGJADk6iaSrtACvNFI2IKuOtkjeUiQjHS5+i0ioSPsS1cHE7RyL10sBZFdkiydrByZnp7EdOUJS6h9xbjbHUtFHiwoh0UMPqxja3bxUlmXX30imnrfCKZ3cgwfR3TMoxaHyqN243zS6wcMoiv62d2q3fVqGNxA+YTyc3yGG+1mWP5Vl+t7N/SsFWJhKufLtUaxe+qJQ7OugEmwSU74TTf31iJatkSYACH8+v7Qo8WKMR451IfDdMldEIGvcRsjFd+gMbgCh3sj3CDvtJjPmKVIlILlTcxReGCJ0n86b5Qhy9UghmOEJ1KJkJ7aitIi1TUxlJECHlHQWh6jnL8PD1
 5WyDI4Ml
 CKBrnFHIVWmL6tapC2O0dK+KR6CpIsbT7qZEg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Enze,

On Thu, Dec 18, 2025 at 2:39=E2=80=AFPM yuan linyu <yuanlinyu@honor.com> wr=
ote:
>
> use common kfence macro KFENCE_POOL_SIZE for KFENCE_AREA_SIZE definition
>
> Signed-off-by: yuan linyu <yuanlinyu@honor.com>
> ---
>  arch/loongarch/include/asm/pgtable.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/includ=
e/asm/pgtable.h
> index f41a648a3d9e..e9966c9f844f 100644
> --- a/arch/loongarch/include/asm/pgtable.h
> +++ b/arch/loongarch/include/asm/pgtable.h
> @@ -10,6 +10,7 @@
>  #define _ASM_PGTABLE_H
>
>  #include <linux/compiler.h>
> +#include <linux/kfence.h>
>  #include <asm/addrspace.h>
>  #include <asm/asm.h>
>  #include <asm/page.h>
> @@ -96,7 +97,7 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof=
(unsigned long)];
>  #define MODULES_END    (MODULES_VADDR + SZ_256M)
>
>  #ifdef CONFIG_KFENCE
> -#define KFENCE_AREA_SIZE       (((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2=
) * PAGE_SIZE)
> +#define KFENCE_AREA_SIZE       (KFENCE_POOL_SIZE + (2 * PAGE_SIZE))
Can you remember why you didn't use KFENCE_POOL_SIZE at the first place?

Huacai

>  #else
>  #define KFENCE_AREA_SIZE       0
>  #endif
> --
> 2.25.1
>
>

