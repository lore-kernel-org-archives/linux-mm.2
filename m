Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B94F1D59F6D
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 07:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2696B0005; Sat, 13 Dec 2025 02:05:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C356B0007; Sat, 13 Dec 2025 02:05:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EF56B0008; Sat, 13 Dec 2025 02:05:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCF866B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 02:05:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2BB3B9CB3
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:05:43 +0000 (UTC)
X-FDA: 84213562566.10.08A7B49
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id A02EC8000F
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:05:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tejL0E1L;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=jackmanb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765609541; a=rsa-sha256;
	cv=pass;
	b=S4rFkQQXzYBnp9TZtlXNnIhxcT428jbiEHAYBQbD/rHQivXtoWD3Xp8HtWOgSgGYbD/oyJ
	4pYHsXxXQR8V3vcWgQgO+bcvtDneY/6f9qHYMm1vKTS7/d5/iQ/vNptnCb9ClaqJ2CTm8H
	/ZTkcbkH2pmMB2ksbg1vAj7ynnkzXws=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tejL0E1L;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of jackmanb@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=jackmanb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765609541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ot7CTaOEn9MEJkbjFKG93I03AklZCblxqt7tGVu1gvM=;
	b=RV5OmX349yzvlNrasCwlo4mti12qHN4kDAVKlcSaJCUU7qsBZQsLRr6LAmluTG1ZX7SLFL
	eYQwUs3emCoCn5mdcBxkiOoLjLtzlVm9q76LKynBaTHfbtqd3avzyYXqaS41EYdKWHc59f
	QzCd7RMZpKl6cICi3MloGd79kCUK8ls=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59434b28624so20484e87.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:05:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765609540; cv=none;
        d=google.com; s=arc-20240605;
        b=HnetSzMRCgrpl/X+ydYIa2mY+yUVk1qhUrZxF1OJEDc34wQNf3HvzSVyFAzCQ3Hdgr
         pl0NkBL0UGOxpewuxNmScCShJQu/79yx3ND0fdFsxdf1VGSovhv3/OpBt6hC+uXxdjrr
         zalv0KM6nJpFfMewBhbWe26zFQtyUNE8pgTfUdz14czPa5MVjg/GMyKGTn8hpOeL1gnj
         9tC3wN/Zh+2cerChPytsFA0p+nB8nBQoe0cF7wcJoTn9SZWZ2jzpXtc+Uh+8hw0GtArl
         iMKRraLdS/MtFvlDvuX2tmw2iHuNJx/v9pEWA104zcYlN7U6S5/bzY5e/gxZjCkhkKae
         o2mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ot7CTaOEn9MEJkbjFKG93I03AklZCblxqt7tGVu1gvM=;
        fh=R2DMa8fOy/IhZLElATROQ4DOzJL7aSpS9JdVtwibjJQ=;
        b=NOMMA00TO0mFfJEAvYUsIn5OmNNc8b2p4qhtxu0IBPD3gf+sD4Kt5q0bUNjqCGMki0
         RaU//WxtOvHWSD64Pe1n9BYQRCGVzl/W2bxdK8y0LiymJZEpDf3PUzlPQcqiRwTjVNv5
         n4GS2GRmnKbO/jQg0oF/4yeiNsqwjHN/YHXhi8hca5PTMKCEjenlOnZdd9CfO4GhWOZg
         7MyqfjQxjaj8mCKT2WJ9uVXglW/p5iczZcDGfsC/tOojI/UqOfJ/n6cYVgMuq8iRXY97
         5SVoZIqoOajKzhy+8H5DSq+iUPNkZ2+dkZIVf/MIs3Oqn/5Cz/Il/ZMQ74bU2rDKdL/9
         k0PA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765609540; x=1766214340; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ot7CTaOEn9MEJkbjFKG93I03AklZCblxqt7tGVu1gvM=;
        b=tejL0E1LNjhmzr1TIxMQP34UKMIoVVJGbBaOkAwCDisyJ2nHuxb8vsIEVPCQRH4cuG
         Mv+Fq9hX7qlqDzKsfdG4Z0J+qz6XQR3fd6SF0aNnRfmjr431ajO2iNB5RAK/p0x7EXHR
         UhQNFebqK6ZVuG+3pt4TUwsyaOdoyrio1VYIpT90fwiQhRDHmz6eyGv9LQX3GZOtknq9
         YE0o+FmQGyHvU7FiqwXKcki+p89ZDUdS84f7tZfhSOwrgIMDex/o3ofULwHmDA5XHUjA
         KePCBz8NaUGoIG5xjIH3JVyKymBAmseqkMDlcmk9uwt84PQ24/PjywT7V+qTLPD9XT46
         9mFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765609540; x=1766214340;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ot7CTaOEn9MEJkbjFKG93I03AklZCblxqt7tGVu1gvM=;
        b=UdBss10Z1LkESRIyLdzy04wn28oyNvPfW+bdKEkljXFE9f6a8BPTqGaZAMz0cXeUMl
         cYEkiUYCpVFC6yeBTsBeud0FB+0LrJiP0S69YSdc6IAK/7fliNNm2sBWTxDR5t9pky50
         iR6Tq+FrReQ+ovtovSJV3k1ahQMjhieU5u3ff+P7LompbPnaW5+SwXwNLv1yiNMEity8
         XUE06mxYknvcAnsDChYf91HdH2whf4YWZkzKHza7PHwdb3henon6NoTBeKn46qCZib60
         LZO4aPL7xgpptL8A3L0itfPPqpBSjHmU3vAQkF6C9Nte7W/bFV0YmKzWmH1RzQHd8BXb
         OPDg==
X-Forwarded-Encrypted: i=1; AJvYcCX5KGRZG6lFwc/4Ahq7MqL+31kY/V5jqQ0/YbjTcptZMvb3xr6L+bzmgnwMizLYa0b6O+7dy1Iv/w==@kvack.org
X-Gm-Message-State: AOJu0YwIVSbehytnddmGAvLTKYiqJEZlFHA+ehzdNf8Pn4zqDYAs74FD
	TS4lYjpFfeTS8TTSdu/cjcQwLasGFuQQTrP8xsvfHiXWJYxKz8mZAPUGyNTo6LtHNcZcZnDuVUQ
	4k2PIf7Je4OC4yATUuaLN39KVbJUdNnilcNfLEP+j
X-Gm-Gg: AY/fxX5HTB5svKmxN2hQieHTu/bMI3xONBw2sxqUJGRTWXFdJKv42YWF6M+F0RsIiGD
	36mKqKv0rve7dzLSiUul+GCEn1KEqfZSg+vh5ezr66cY5wef7AIUxPghn//WduWg586FofgXd1F
	LTxTk/3Yc+vNGAGu4qLKEYTneSeKxMMIho3htF2Ix83QdRChqEDIb3bgAwE4YEGQGFhAtdjm0hP
	4Ejrz91CXXC9LUHjaI/FDe5fdoAGLLQsJmUDt/I/lDvKhdmDyxGgi5ZsHEjtbkiJggVvYN1
X-Google-Smtp-Source: AGHT+IFxhjah2N2uFy306dItOjP0R93hkCDyo1Kn++vNhOwiYTt8khSjxmS7193oFeZUUiU7KewI20Oqx5FGrhIwBmA=
X-Received: by 2002:ac2:5de3:0:b0:594:43e1:ed43 with SMTP id
 2adb3069b0e04-598fe1eb38cmr60101e87.2.1765609539221; Fri, 12 Dec 2025
 23:05:39 -0800 (PST)
MIME-Version: 1.0
References: <20251212161832.2067134-1-yeoreum.yun@arm.com> <20251212161832.2067134-3-yeoreum.yun@arm.com>
In-Reply-To: <20251212161832.2067134-3-yeoreum.yun@arm.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Sat, 13 Dec 2025 16:05:20 +0900
X-Gm-Features: AQt7F2rPm7R-wCwVHPTjXe_bQj-qNecTeNkHkP5H4J7QvG1ylb2YhWsPANW--u8
Message-ID: <CA+i-1C2e7QNTy5u=HF7tLsLXLq4xYbMTCbNjWGAxHz4uwgR05g@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while stop_machine()
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org, 
	yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, 
	ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org, 
	rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org, 
	ryan.roberts@arm.com, kevin.brodsky@arm.com, dev.jain@arm.com, 
	yang@os.amperecomputing.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A02EC8000F
X-Rspamd-Server: rspam03
X-Stat-Signature: fkx3mx34tgfcyg3mqjfursiacwxk46fq
X-Rspam-User: 
X-HE-Tag: 1765609541-160198
X-HE-Meta: U2FsdGVkX1/3TwiFyVDZ8eK0QQVxKpOwCrEWQoWwdM9/eGHmd3G3ckbBWSeoCeRh7PDIHWVP3EClqtkRiV7alMrdJJUqu4z900zvmrhZcZa8YBMBqNz24Rv8ZEFcqwzMwzWv+de4h/ookxIpOrHb/2uT4EMPP05EA9342VDvmDTaYkeqRsBeFUUQv2mOyQRv5fuH5JCGGR4MWdmn73JHVGZLgFGfIixGFC1Y9v+0pMPaY48VTnP0Us0CXrTB3Wqm+aGl2TLcEaArHRvvpCj1Mc2H2hPo1/JTriyuhkK32kQ1NtD9/OkcqV5lDgc/z2Z9w/oAJcF4zHyfvDPoLFQqtAJ8iQUPnH4hnbRm6KnNQG8ToDO485PBswdH17k4M4qDrWZkQ0WR8mAQT5SY+u1wh6gckob9GkM2Fa7pBeqpxPieUIuHXoRsLwLh/LkqprMU7EvlCCfbuhCe2ePos6UY7XYUu9VbjmLqB2sMfNs3N4gSGRevAcptXzRfyXQxpj87JtZIIHEcRceKz/13bTvFd0aHJCoWfP/CdgMzBhBAf1L6joKHktAEVhBrdly4Zndqml9kMCff/xVYe6T2XnR5tOWzcGS3nU0xcRNACBbK7zjpOXBv9g1jxpuplgDhx/SX0AwOU4TLLuwwimWbn6QdLMytO+X20WcLoycF9Eg8ydFySgaML1VFyzyIP5dBs3n4gNg3pG4ao3ty52sgbxHxmWDYrELK8earX2W67pUNT4F/eSshdbu+j9m4f/6Vkmw2cnVgZ3+vBmgS8/8tHrYp5/AIn3bp3pRvcnk9/+FcIL7RSrJaNYqGcGt8l8htFKWUCbZ7FQYaLeZwMLklm2TedB85fmp58TBKbYfPBmzY4bEEAbFbaNWJJi6Enpmw/pFrzhsQrEGvQ1YE57gOeQKKsdAVOv/YsNKtpsORvGfxJhff+HHiD+HyhlvG36su0kqgKvQsGqv/Eu0P9TxJFD2
 Odhk1X1G
 VmedamvxCEm00ZIEfaE6r91F/Qv+qvpfOLqNclOWOh+yxpIBTjKv+bPFoeW/K1XsItrVflQS0kSkoApkWxDx4R4AihMe/MxHBEfUZhyEzl2nM0QBY+hnFF0C5iKwHcXuQHGCiUaZhX3Yr2RdvFJr/hCXSIMj4+Kti6NDte0IX+vMpyq5gFO3IWop62KWlk2X8Qo9yEMfHzPXtifxVPEzwWmACzcAX3wJsFKru7BqitJ39Y3nrtg7l8UiOC0g1YTtepf+G8OjjhDp4P1WB2aSdtdC3dhrhmX3HhWy9i3gM2B5XdOJ1d50B27/YK1f2/2PJY9Qx3vKrEf94sbbAqSbVEtUUIOFJR/T8TRuj4cR8fBbGJxIIniYNWE/5UQXZYQ/fPoALwckf/Nf7ya9xzYB+Vk3fuwBH7S+jN/48
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 at 01:18, Yeoreum Yun <yeoreum.yun@arm.com> wrote:
>
> linear_map_split_to_ptes() and __kpti_install_ng_mappings()
> are called as callback of stop_machine().
> That means these functions context are preemption disabled.
>
> Unfortunately, under PREEMPT_RT, the pagetable_alloc() or
> __get_free_pages() couldn't be called in this context
> since spin lock that becomes sleepable on RT,
> potentially causing a sleep during page allocation.
>
> To address this, pagetable_alloc_nolock().
>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/mm/mmu.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2ba01dc8ef82..0e98606d8c4c 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -475,10 +475,15 @@ static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
>  static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
>                                        enum pgtable_type pgtable_type)
>  {
> -       /* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
> -       struct ptdesc *ptdesc = pagetable_alloc(gfp & ~__GFP_ZERO, 0);
> +       struct ptdesc *ptdesc;
>         phys_addr_t pa;
>
> +       /* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
> +       if (gfpflags_allow_spinning(gfp))
> +               ptdesc  = pagetable_alloc(gfp & ~__GFP_ZERO, 0);
> +       else
> +               ptdesc  = pagetable_alloc_nolock(gfp & ~__GFP_ZERO, 0);
> +
>         if (!ptdesc)
>                 return INVALID_PHYS_ADDR;
>
> @@ -869,6 +874,7 @@ static int __init linear_map_split_to_ptes(void *__unused)
>                 unsigned long kstart = (unsigned long)lm_alias(_stext);
>                 unsigned long kend = (unsigned long)lm_alias(__init_begin);
>                 int ret;
> +               gfp_t gfp = IS_ENABLED(CONFIG_PREEMPT_RT) ? __GFP_HIGH : GFP_ATOMIC;
>
>                 /*
>                  * Wait for all secondary CPUs to be put into the waiting area.
> @@ -881,9 +887,9 @@ static int __init linear_map_split_to_ptes(void *__unused)
>                  * PTE. The kernel alias remains static throughout runtime so
>                  * can continue to be safely mapped with large mappings.
>                  */
> -               ret = range_split_to_ptes(lstart, kstart, GFP_ATOMIC);
> +               ret = range_split_to_ptes(lstart, kstart, gfp);
>                 if (!ret)
> -                       ret = range_split_to_ptes(kend, lend, GFP_ATOMIC);
> +                       ret = range_split_to_ptes(kend, lend, gfp);
>                 if (ret)
>                         panic("Failed to split linear map\n");
>                 flush_tlb_kernel_range(lstart, lend);
> @@ -1207,7 +1213,14 @@ static int __init __kpti_install_ng_mappings(void *__unused)
>         remap_fn = (void *)__pa_symbol(idmap_kpti_install_ng_mappings);
>
>         if (!cpu) {
> -               alloc = __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
> +               if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +                       alloc = (u64) pagetable_alloc_nolock(__GFP_HIGH | __GFP_ZERO, order);
> +               else
> +                       alloc = __get_free_pages(GFP_ATOMIC | __GFP_ZERO, order);
> +
> +               if (!alloc)
> +                       panic("Failed to alloc kpti_ng_pgd\n");
> +

I don't have the context on what this code is doing so take this with
a grain of salt, but...

The point of the _nolock alloc is to give the allocator an excuse to
fail. Panicking on that failure doesn't seem like a great idea to me?

