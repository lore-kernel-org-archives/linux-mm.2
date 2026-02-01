Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A25E2E65298
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 22:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829FF6B0005; Sun,  1 Feb 2026 17:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7776B0089; Sun,  1 Feb 2026 17:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9786B008A; Sun,  1 Feb 2026 17:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA1B6B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 17:01:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A05D214026E
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 22:01:45 +0000 (UTC)
X-FDA: 84397260570.25.A7F0BF8
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9F9E212000A
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 22:01:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKoG4kwH;
	spf=pass (imf29.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769983303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxxXeMZ2Mj2NhEcakAGevZjWJ8Zk/OwUaMBA61xjWow=;
	b=kboSJq3u6RbzQp52vtVOOdlLzzl6Gveugq9pls2uj22J9QBul7n+XW47Lin8w/+IRIddu4
	RSxL9lrpHOcbnPmUvt9NtXdX8xDNhQkfzoIvX2WG0gaCXtco+80E16esSSM15raI+TzDW1
	UA5oVMQ3MoK5xg4oZF5iVhQLz0HK3eI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cKoG4kwH;
	spf=pass (imf29.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769983303; a=rsa-sha256;
	cv=pass;
	b=Wx3vsu8kWBVARbWWSRWUcTXRNfP5AgK/VPHC8Z7jQ2vWH9B489GXT5znt2bHZUkiPVNNL/
	uJvxUYG1QFS0vSgH7kZpkZhYhIzBleweySpDo2DBWC3TEEOrYb3jncCfLSqahCTjynImiT
	1f/zlr5PqUOwhq86DkHxtDERoQ89p8k=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65832e566edso5084619a12.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 14:01:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769983302; cv=none;
        d=google.com; s=arc-20240605;
        b=gbtWRF623OkFL9UnJVQiQItuuBsesZ5hPtcJwZ/nZyB9LWT25v8/dgMvoSaWIWW4fz
         ZEopw+D2BFVWrz5In5nI09F2N53IJnTvTJidmnNKpeWz19WzhIJ+ioroKVkPOeTv8+N3
         Rzb6XdoKHJ9hnMOTNPKw2DRub9VxPGLjnSYWkvA36AgXz+rPcI4cssK3eA29kHzHNUNE
         nnVsBmNMnAzNrM/ppF+JHGmyTy5BRMVo6PdqozykVUWfpkkNCau2FIO9+yUlSXLJu3Ax
         MB+GZ+x96CRp1Nt7mAVIph+JnbvSNIZtOiNe8T5QnZQCfrmgZrB4/mVi5nP9Xkf42v6T
         V6zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nxxXeMZ2Mj2NhEcakAGevZjWJ8Zk/OwUaMBA61xjWow=;
        fh=71m4WiZXr0NKNPiBqVnbT1nVPannmNp+NYG/Ctl1ge4=;
        b=GdfIzVwAf5ypVCMoohESVR40/yoKm4YmuerNCOQXlOUlWwe7QMA6c9p3jc+LR6I/nc
         4m3x3tjRdQqN5ys+POF9TgejWBjOSg5LO3VtH0QrFpqEmF0ymS17/hPkMpGGeuUlv0T5
         tyhh1jK61dQ944QqIUwi4Ak3oRA2TZLmpOsG2PWQQptZYeRYYT5wYI9qrUkkheAVnLKT
         yB7kU34GenUmjBPQcOdDGgjcShVTRWKubTJmT8rjfxWsyZYg4Z+0gLNgCqQOagwYbuJ6
         VYTOx5byKWnZtoB8HbB+2rJOObTvn1E347InpbLhNocIPoLhqDBkgk8A6LsjizWCfCQu
         t70w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769983302; x=1770588102; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxxXeMZ2Mj2NhEcakAGevZjWJ8Zk/OwUaMBA61xjWow=;
        b=cKoG4kwHHpiLYjBC6bjrSLbsYbeu1vYR7U2YYjMUxOAA3/iMPYgYlAyC6pGCMRdoCl
         lhkUIdww3fk//l/bopunjOGqfFHHSeRg0IS/cwoKR2Bw9sbCCG0ae3yCbyBXq/hzeWDN
         MZcECdyaXnrOJ76ifU53n4ps2GRZsBLGkCHtd2Q07Ng4bCgVVp6u0vmpCOlVvVXwIeCu
         /74DWlRvT89YRbfEjsLaGpfL9b6sbK2TbYKXYI2CvV5bzngpw0N6j0xgTaEZbkko7nDL
         jRM7/Kwfk0Lm0xuBn0tKOFTGewbIgQ9z0lSnXH3RT3Oor46113s0JtjKWWn+T8oYFPAk
         O60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769983302; x=1770588102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nxxXeMZ2Mj2NhEcakAGevZjWJ8Zk/OwUaMBA61xjWow=;
        b=LK0Bt5hhEutTwuAm+MZ1rQM+ZZtt3wZD6CrpKhjJA0YvZROyYtqajJ5TFnkyU/+CNT
         Ea7fjMee88jUc0/d4+9Viu99HcMSblwZXzMqJC8e34MHLBhHS70OqA0Io6lG7ogAsvTp
         73PMYAK3DiyEcFBz9iMV05rE1PdhYUaIuI5kZ2yT0hlhVatHtJmVYnM2eNaE+vV/1ucZ
         oXsmexgTcwFasGUQQgqHHBzfFMpsFcghAepWE97kIRu81fsTY+fxUUZDLN1sL7TyZZDi
         Pmvwv8w5oZIPeOm3AnhXNjtoyk3GM5WALV+zSi8hsTQzMwrdVoBzWP7EKXwM+dyTIapU
         0Dhw==
X-Forwarded-Encrypted: i=1; AJvYcCWZ/JNfy6M6dRmWLqERKiZ+qOWeNDS41bIATBISpQc3dLQG9nOvlj3eKRk/1lbf+m5gAaIby+AQiA==@kvack.org
X-Gm-Message-State: AOJu0YzmVPUWCUsyv/rjikD8tIHD5mG0pL1oHRwtLNN9KJ5GDIOurh7u
	m+nPyMiITLtkJyirK4nLRJ5/TuM0Th01JpCtWtkD9GgY3yTj/fJ/ZTu0IziVXNYhQ/L7p9r8iWq
	tfiW2z7JcrW9bZYxe0w0CVeJ6KHR7z7A=
X-Gm-Gg: AZuq6aLSxJVsmuzNwF9/dpYxT3T6sHxD9H6NK1Gbr9Tp0a3CnXiWGQtPAZBGM5ALbKv
	43Zb3wK/GL0rUKwcWRx1/hB3VhJ7lUvx5dDrxhwOZUximABiNssGMtBeYBJ6aRM8jmGzO4OSqko
	fNLh0vr+M5GPimJ+Yr0DWN29jPwWebGm8mZ8JJNGpJKjbBWUIZVwBdey5bp5O7N9h44bYdq0ufV
	/klVVYk2lOyjzaFkDx5oI2j5EXBbyOt8Cm5SWwT9W0R59bsfCBVb8C6WZ16/v2HhD0iXuUk73OA
	e2PHLPKriZ9bQuBVRVTPRcTV1CZg
X-Received: by 2002:a05:6402:90b:b0:64c:9e19:9858 with SMTP id
 4fb4d7f45d1cf-658de58d61fmr5598076a12.22.1769983301701; Sun, 01 Feb 2026
 14:01:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769515122.git.zhengqi.arch@bytedance.com> <3380f40a89b73c488202c85f9a8abf99fb08543b.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <3380f40a89b73c488202c85f9a8abf99fb08543b.1769515122.git.zhengqi.arch@bytedance.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 1 Feb 2026 23:01:30 +0100
X-Gm-Features: AZwV_Qj9VNkT5OuGD6ka3IvGbnZ780_iMCZkDjCZeudKZ-RrGhxplhYBmunMjcY
Message-ID: <CA+=Fv5RhxvyxKr2t+pHd1tbGrK57P-+b3pGe1nVaK_OLiFt2wg@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>
Cc: david@kernel.org, andreas@gaisler.com, richard.weiyang@gmail.com, 
	will@kernel.org, peterz@infradead.org, aneesh.kumar@kernel.org, 
	npiggin@gmail.com, dev.jain@arm.com, ioworker0@gmail.com, 
	akpm@linux-foundation.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-alpha@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-um@lists.infradead.org, 
	sparclinux@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: z18spggxzuj7mpztgke1hfz4wkis1njr
X-Rspamd-Queue-Id: 9F9E212000A
X-Rspam-User: 
X-HE-Tag: 1769983303-801118
X-HE-Meta: U2FsdGVkX18I/Ac/HWnsKIyaPep2g26ucns4fZSjo+qDk+oe5LzO7GPjVt1rrPM2tQFujXLm0vI+WOo4jHZsW902jUKZkTKFgy3zVqf4Ra3IrUNXIYsmzKXvU/CpTXvwthaMg0KUNprndyA9ZGc4SIrNS/+1EwiRsqQANkgcE+nsjk5+ckc/4yq38qZ01xAeF4vJAzdzrO/rBiQE8JESfe5qH1XgeW3XBOq8YgIMnZth+1roQXUozxqYYGpM6cldeT2TIfT5cIJDd/sinV0mGRniBddg7L2j4TSG/UyosCyfGC0TZHzzUlixaUyYQj2oah4v9s5CLpBKE/KwEbkAMnOdt1PXjkHJPvmFPk2j+9dgmMKd3T/UJFigA5BkYaQJ6vBQ0gg7mJMa4+4CRnsUNev+BxVu2k68UB24TVD8mRoxFNwuXz/YBDwO0OJKQBXRDAav0Rjt9Vr/ehXdsnb4HiNvWibcNH+oGrp/zXpwwHkt8tYBQo+6vYX+c5mJbmSYINW9QOL+h83VtU+Gzne4FDp+MeakKUTpqGjjrC8KbcBvYmeNaccOF5NcQZDHy4iF8kfolEGDaD1SwTvyGFrtfLoJ97NeCyroQ/X/INIoivRfsE4ZnBMeA+nfB3SP/9h67USpslN+do4+T2oJq5DrCMaTgygQBg+iNU/t05c/qDW/cn/l+1dIrIwXfjlAPwzvmDjEr9IfS63jODrobJ838mrKorxdfDkiPF5mUiSZUrGQXsSMo/L54RMhrWiun2RstzayoHxFkoLp7YJFrm6S7J8xidBOfOTa9IjXFDXUN8/vuOHhUu0oBZRhLM+Pdmg2T6qQxPcRD04MLWP5XKkXwCRwfOIO4xrsvVomu5v0THdzosEtCuuS3PQ5sXK5rNxDWaSs5UEkQjkrJWBGmCx4KhNbKzMxu5PBEqr/y2v3BXIWxZT6OQHzWaNHW6z3p13SbnG6WDHxTh1QDJzdjrM
 NmpXgX/P
 DelOocvobcZqUny3VmO+VpodSyTsk19TECaNytx4hptMmz+spi2vuZIybHUbyeckXiWpo29dXEzxna3aSTT0/13u7idi8rACxbwbRZoCvglc1z7bCubXBvecdyb2OW79wVufxuo9K49jekJ4HgVhosFC9fiVjNQUtdOm2c76FLoRdEcHDqwzAivl9QENOncrOxlVK5ZA73IiQOEKPNnBGMDbjgev3x+l/DQF/Tj95PI9bogtbcAiio7kggBh34tO9fc2Ao41NrtHBFvElD5buBrN9aCzRJGG7Yme/IlVdYZmEmVD8KjFG85m/pxVf66KOyurosyBXndA9490OUtBpeTCiMYNK0dUv7cjjED6qTnGzbk8HUrPJR459VaYw5NA7bSaQui0xL6q+IEr+pywsX8ti29GHVVHG4YBxydU/C0Lp3jCRPTNN74lH8jyqciPl7ufg4hjDrbBek10w8SgxfQnamXSsK4IM+h7k5FTouM+cjb7YnctbkfH6xfCD/uVddjuTRuL7AkZJv+DbblNbH9LRjwP4o5ZJImfVF2++Z4NzjXqzm/ljw1fMlQh3qmM5x3ubYzhg4ZiXYDzlSb53hFpS0Z3w1Xh63tzYfSCl89N9c9Zvw5muIQq3tVl/sjZkBKq2o2rqfsX7GkR05YmUE1nC1oJJi2t2+4mzfKDeVM6i/Ao7EfKTNP2Fr4remHQZcTXS8chbBbB/gSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 1:16=E2=80=AFPM Qi Zheng <qi.zheng@linux.dev> wrote=
:
>
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
> empty PTE page table pages (such as 100GB+). To resolve this problem,
> first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
> PT_RECLAIM feature, which resolves this problem.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: Matt Turner <mattst88@gmail.com>
> ---
>  arch/alpha/Kconfig           | 1 +
>  arch/alpha/include/asm/tlb.h | 6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
> index 80367f2cf821c..6c7dbf0adad62 100644
> --- a/arch/alpha/Kconfig
> +++ b/arch/alpha/Kconfig
> @@ -38,6 +38,7 @@ config ALPHA
>         select OLD_SIGSUSPEND
>         select CPU_NO_EFFICIENT_FFS if !ALPHA_EV67
>         select MMU_GATHER_NO_RANGE
> +       select MMU_GATHER_RCU_TABLE_FREE
>         select SPARSEMEM_EXTREME if SPARSEMEM
>         select ZONE_DMA
>         help
> diff --git a/arch/alpha/include/asm/tlb.h b/arch/alpha/include/asm/tlb.h
> index 4f79e331af5ea..ad586b898fd6b 100644
> --- a/arch/alpha/include/asm/tlb.h
> +++ b/arch/alpha/include/asm/tlb.h
> @@ -4,7 +4,7 @@
>
>  #include <asm-generic/tlb.h>
>
> -#define __pte_free_tlb(tlb, pte, address)              pte_free((tlb)->m=
m, pte)
> -#define __pmd_free_tlb(tlb, pmd, address)              pmd_free((tlb)->m=
m, pmd)
> -
> +#define __pte_free_tlb(tlb, pte, address)      tlb_remove_ptdesc((tlb), =
page_ptdesc(pte))
> +#define __pmd_free_tlb(tlb, pmd, address)      tlb_remove_ptdesc((tlb), =
virt_to_ptdesc(pmd))
> +
>  #endif
> --
> 2.20.1
>

Looks good from an Alpha perspective.

Acked-by: Magnus Lindholm <linmag7@gmail.com>

