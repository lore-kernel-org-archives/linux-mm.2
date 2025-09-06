Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3049CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D61A8E0008; Sat,  6 Sep 2025 13:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186A68E0002; Sat,  6 Sep 2025 13:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0753C8E0008; Sat,  6 Sep 2025 13:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8AD38E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:19:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 954B3BA40B
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:20 +0000 (UTC)
X-FDA: 83859486480.30.6D1108A
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id B21F3A0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NrcdNLZI;
	spf=pass (imf15.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGQShZZAoC8IOCDe971xjsR3B/73MD2B3WQtZ33juWA=;
	b=HLaMaEMlQTK9VP7J5kXdFyAbN6IQEv98+QxEdW3dDA8lENHpC2ixWq6BFN8YdtWZWuehb3
	wLM8dPCBMthPJv03Z9KW/4ijZ/os+MefP8VVOJzi+hitbrj5xbleaPpjD7n90FMtgoZr8J
	Jvnewzb7cVktiPNv94a/ufBKaUZ3vdo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NrcdNLZI;
	spf=pass (imf15.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179158; a=rsa-sha256;
	cv=none;
	b=7UDbBq+72WPXO+rbmXmcWUTvSx4mvVSU6f3z2UtfP8ddkGXFjLahe6pyj1ijIyE2RR5Sq7
	wo1VOL8+lPAZJBkRAepwPTtx9+y8UhnxBoZE7XRLhM5Biefh6e11a8dxl4pShclRHozMh+
	00UCXtmfbXx9BK2rcX5qPfonnbEjwO0=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e014bf8ec1so2195508f8f.1
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179157; x=1757783957; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGQShZZAoC8IOCDe971xjsR3B/73MD2B3WQtZ33juWA=;
        b=NrcdNLZI7A77siQMTaqXyJq9RBOVXmEDoVVBoBNjWogzy2a8EbyKqGG9MmqJuKU02y
         Bacn0B/sGz+VdA8QqctJaGzVu+K5orOPvWgqfdt+9WNhMPzzxqXTx2QywAtgOOOSpFas
         Alt/adPdTt2HEZOp4Sbeq3JN1sxzEOtw9PquLk9Lg12H0Kx3y549icJz+wttm5BKEEBZ
         P7CgkcNQVDZgrGqhVC3XiyM4S8PwSFe3DLDTAp9mk7yYzI6ImQy20f2dhpLWEAOtgnpW
         RoZUIlPZFbe0PFvRt+/2YVe0tO8XRUoilq8awkAfqnKk9EpJ+SuWzyFENczwB9qMrKlk
         jCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179157; x=1757783957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BGQShZZAoC8IOCDe971xjsR3B/73MD2B3WQtZ33juWA=;
        b=F/JSX52yAoihfzc4tTjs6dgd6IbRcsy6N59LqOpUZqwF5d4dbG3XbSOc4bg6UbM/Xp
         Muu9bG5CIkQ6uEbp+xAijOhmq8TplruKj60wbNFyOqXphnPknxKZ7FGep9e6fNc82cb5
         x5yn3wRlNZOMwWsKoI+yKa/LaIN4kOFpaQ99W9U0HXYcqlMk0MgpJ6KlZT4m82PhXQF2
         7qA0L0D157MjnRm2jtHzAFeV/JTdfZ7zfY8xDBSelnhnKrOc8qV7zsSPlvRsei2X74fV
         m5cDX2pLinMVsXbBhha3xgD16nYitTE89pmvLGqahF6CQjDv3TpdrE3DmkFCRC4hBBTO
         r13A==
X-Forwarded-Encrypted: i=1; AJvYcCWE3aYZ1Iu20LIAaY00MxhDvoMHfFje9y9Qc4oHFPVanrRD0I4GL+0t61Xs4ti/izubv7nAG8pSRg==@kvack.org
X-Gm-Message-State: AOJu0Yz93JXa+MVYoNX1pBjLrhZcE9TgUYV46qM5uDrQ+PmHu1dtHtpp
	gJYUggnaCF2LdvkOUR708bxZrr+WGx84KNoQvtNKKiP/m/VQjE+QjeqiBXZio7bTVYu48XXA15w
	hpO+nEpcPK5ISCXixtwqpVE3Lwmft188=
X-Gm-Gg: ASbGncsNn47GCJqCQYUS/hW3zhgptBp0G9VCXJJYlvAddbZyH5kDVn8UNu5eSv9Qzsk
	wXwwmQP3S7De7qgsrc4QsONqWGZVPd/Ko0eZKLjcNpt9M3FY314v2V8fO3DjHERAZv9NcFpgpks
	OYQ18mRy/4CNk0sYb1HGKtCj+tlJ4yz9ukFqJoK7djYz28ko8Rl7RDnR7f/pDb6jnRv+jz61M1s
	4y6WATp
X-Google-Smtp-Source: AGHT+IErSnjHrUW5RGQUyF/9Wa8QYjwwrc6W5yXTtWs4ElwxGoH13iuYCvVuQSTYFX+HU7KvNalf4Pw/e77ySQjVhmM=
X-Received: by 2002:a05:6000:2312:b0:3d3:494b:4e5d with SMTP id
 ffacd0b85a97d-3e629f1faf0mr1903280f8f.0.1757179157138; Sat, 06 Sep 2025
 10:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <2f8115faaca5f79062542f930320cbfc6981863d.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <2f8115faaca5f79062542f930320cbfc6981863d.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:19:06 +0200
X-Gm-Features: AS18NWDxFT4623FCGfz8GntFkBjzjskpR65nPPTaISyQJutWsmUOYJwFObV25h0
Message-ID: <CA+fCnZf1YeWzf38XjkXPjTH3dqSCeZ2_XaK0AGUeG05UuXPAbw@mail.gmail.com>
Subject: Re: [PATCH v5 15/19] kasan: x86: Apply multishot to the inline report handler
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B21F3A0002
X-Stat-Signature: jwk5p8btei647abaqdtqjfh87zg4j7ik
X-Rspam-User: 
X-HE-Tag: 1757179158-538010
X-HE-Meta: U2FsdGVkX186gB59NmI84lSuHz2L3zvAKKlIJkKllc2p8AtRMs4c87JCQaV2hvi95uTvwOkv6GdfPKwb/XG6kxZPbIMh1v5a6L975kCSFoiM2iua6ET3WfK629HMmQJRtF8TQfeLyq4Y3ynIT4xufqldUVp47b0i5w1mpL+YAJDBfwrfc2A1hUFAfviyuodUILEpSXMwZrhTDAo89DKD2SeaB2U2K9PCTSMyBQRhO/3EnZ8I0AUPSc4r8lxrppMO6+zr9HZTysWKWrmOcEvgmSx8tZtxAMj8DaRbTSzkhqH7LeCKZHzQskU71LI7TiHde4UBYz1t4DZyHVIRvKMfXQKOGUslE2Dc9eA7SBtubRyOmWsJA1jTrEsHtwamhyKQKoMemVVTqF7W2bmB6MQ3q9VfWMj3s59XiqH8YCMC8+5n5RdTRJoYRM1epDgZ9HG6JcX3sABujnpYo9c00KCj8w6qNF1FOflmXYnECG36u/idLrPMuiMsPco+aor8v3e0+tB+Fz1jh+Gvosi4RDN/S70YqkvZB4lpZlAGVggewBMJlRRohe8YI6X64j57O4YwmRYo7mSjOGjWyPJljkYXxarB30kIfVJf8wf5cEYaTS5Bh8s9nrXWQj0DZxnzTuCpA4joG8BrjmTRXHi7zBuqvsHEkuAFz7wdK5IPpOpMsfsf6vFWbvj8MArqE0QSFeTU0m5/XiBALPijA/sUIfLMyC7fYY4H5evr0+j26I9J3i2rdbKVIkv72TxzTGhpEviCgNsSgXc7+TwttOE/lMelryLy2dqrvrlZoc4AS0Lzcbt4QysN9fiS0isf4wYOnTObJYe2F3N9BG31Mqxg4D7jWWts6+LcwQ20AXRGTGa9mXm4wgCI23wTI5d5Coxea7axsvQov6FXlUzcFijdfwk8QA45AJB87i1lIhx5IaFfMENyp/AjwgR5rjqPwxg4DuslM9cL1/fRryAuZQZh3ib
 H+O9jPPM
 QKCL0/Oq8Bxt6ACnrEC8//q0h/jqLmEG0zZW29myCH2ZDnFm68SwPRTrGCv0rr8pID7nfzgb/xuJMJ/bFvy5pfGXr3XKa47fCawXvwMf2S7X/LNZVrNppy2PosyS92YvTNS+zG0JSk+d3tow1GIMZfblkRAaYVYdT3SYZm+LpDzH26Q87uKLzRqJcGKxJ4SgkdYbL05bBrCOCTpxfsA1ok4y/HRnXoaTgdaIO3dHP9ipsVjZ96q3SGtVq8wCUaOrfaw6kAgxF9lwf8xqCTjQwRzaq7i07U7i6d7mdQAUXubeDCg+euQnWrh/aOo/vjn3iQmzp8y5loJ4LMp8FBTdeSMyM8Y4q8fWoYotL5kIZ1CPJpiroE8bLLjuiHNm+xaTyqGt59xMaO4uunwoLrxiks1AH0MPZdybzmYdDrPkLxhRtjhFC9nwfF+aBlPKhg0oaz0muREO2DyzzxmU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:30=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> KASAN by default reports only one tag mismatch and based on other
> command line parameters either keeps going or panics. The multishot
> mechanism - enabled either through a command line parameter or by inline
> enable/disable function calls - lifts that restriction and allows an
> infinite number of tag mismatch reports to be shown.
>
> Inline KASAN uses the INT3 instruction to pass metadata to the report
> handling function. Currently the "recover" field in that metadata is
> broken in the compiler layer and causes every inline tag mismatch to
> panic the kernel.
>
> Check the multishot state in the KASAN hook called inside the INT3
> handling function.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Add this patch to the series.
>
>  arch/x86/mm/kasan_inline.c | 3 +++
>  include/linux/kasan.h      | 3 +++
>  mm/kasan/report.c          | 8 +++++++-
>  3 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/kasan_inline.c b/arch/x86/mm/kasan_inline.c
> index 9f85dfd1c38b..f837caf32e6c 100644
> --- a/arch/x86/mm/kasan_inline.c
> +++ b/arch/x86/mm/kasan_inline.c
> @@ -17,6 +17,9 @@ bool kasan_inline_handler(struct pt_regs *regs)
>         if (!kasan_report((void *)addr, size, write, pc))
>                 return false;
>
> +       if (kasan_multi_shot_enabled())
> +               return true;

It's odd this this is required on x86 but not on arm64, see my comment
on the patch that adds kasan_inline_handler().



> +
>         kasan_inline_recover(recover, "Oops - KASAN", regs, metadata, die=
);
>
>         return true;
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 8691ad870f3b..7a2527794549 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -663,7 +663,10 @@ void kasan_non_canonical_hook(unsigned long addr);
>  static inline void kasan_non_canonical_hook(unsigned long addr) { }
>  #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
>
> +bool kasan_multi_shot_enabled(void);
> +
>  #ifdef CONFIG_KASAN_SW_TAGS
> +
>  /*
>   * The instrumentation allows to control whether we can proceed after
>   * a crash was detected. This is done by passing the -recover flag to
> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
> index 50d487a0687a..9e830639e1b2 100644
> --- a/mm/kasan/report.c
> +++ b/mm/kasan/report.c
> @@ -121,6 +121,12 @@ static void report_suppress_stop(void)
>  #endif
>  }
>
> +bool kasan_multi_shot_enabled(void)
> +{
> +       return test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
> +}
> +EXPORT_SYMBOL(kasan_multi_shot_enabled);
> +
>  /*
>   * Used to avoid reporting more than one KASAN bug unless kasan_multi_sh=
ot
>   * is enabled. Note that KASAN tests effectively enable kasan_multi_shot
> @@ -128,7 +134,7 @@ static void report_suppress_stop(void)
>   */
>  static bool report_enabled(void)
>  {
> -       if (test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
> +       if (kasan_multi_shot_enabled())
>                 return true;
>         return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
>  }
> --
> 2.50.1
>

