Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C1ACA0EEA
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C327900250; Fri, 15 Aug 2025 11:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3743590024B; Fri, 15 Aug 2025 11:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE30900250; Fri, 15 Aug 2025 11:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1030F90024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:07:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2743115A55
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:07:36 +0000 (UTC)
X-FDA: 83779320912.22.AF3CDA6
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id D79C9180009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:07:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=dabbelt-com.20230601.gappssmtp.com header.s=20230601 header.b=J6BZZMyC;
	spf=pass (imf24.hostedemail.com: domain of palmer@dabbelt.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=palmer@dabbelt.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755270454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=HSuqWusYtC3hY8ploe0KH7jPL7SusiQWfMM3CIlvAWY=;
	b=KeX1N1xTzpOr3F7vUPVIDTGPQOkTFNUnKWPVIGfITkDg+mxT/Y/UUxNR1nogMVv80VWdsV
	4mW0eZFco2zQljk9cQ570uKuuzDtJwxrXTBi8TPPcNEtdtORW1mZQ79bQ4n+hyoF0u3iyQ
	fXgBz6V6vSBO/TJTUTG2vEugGjXkmSs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=dabbelt-com.20230601.gappssmtp.com header.s=20230601 header.b=J6BZZMyC;
	spf=pass (imf24.hostedemail.com: domain of palmer@dabbelt.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=palmer@dabbelt.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755270454; a=rsa-sha256;
	cv=none;
	b=jKVCmsXceQgeZrYrt9uA13J05Lf/2H3YXpSpqhf58nZZgk53Y6Q7B/HKtn5BEtvIZ5kujp
	eEOtHi0OrVmcss1eM+ToV1gVI/yO/GDLRafo2G09jj9jjWXFvNjP9lXG/UXifPaw99ewTP
	fOMnIhbXkPUzzqL5uO5UYo1mRs+udug=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76e2e614b84so2125194b3a.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1755270454; x=1755875254; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HSuqWusYtC3hY8ploe0KH7jPL7SusiQWfMM3CIlvAWY=;
        b=J6BZZMyCXknB6z0+Thk3JhBsSYUxPWWn4HIkTtvVG0J+JyNrS8If+jE0MuQM+1MIXK
         V3h4MlqNrcOjU341dT3Y19CYCSp+39/UD8Xe6jLM4N4jS7t9vjxEDs6sxmG7jHh+FTaQ
         CziYaxZCtULgAvkKSvy7eTGPAzbYTjVxoumPQLg3HwL6rbHHF+BWv/PQth6dI2ceemKY
         mBAzeC60rAzE/t1W4Vle2zbsT9ElMTwUoyAXb0EiH1VWyKbX34jFJpaEEmSPSzDnPXFh
         +M3/DUmP1nJTAmBkxYjjMPdDb7agkS1MhSCnBpRq4UIFgMTgsYEUmzNUQp+iOnXflZbC
         5Hlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270454; x=1755875254;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSuqWusYtC3hY8ploe0KH7jPL7SusiQWfMM3CIlvAWY=;
        b=EP4YSKawpaGSP1w3ERljGEU/XJes5jsfX5hDXAo1okcP8ElTddYUyeeJgR1I4jirI+
         wtqvxEjjUwoa66gcag3yAdSrgp44TyoSBid+ZJKdmkpHR4DdrfdO1Cs2ge/5+0OEKA6Y
         WJsMpdAnVxYbSL3gPiJf50+fALd0D3TaEK55kvLRqUhYLzVhBDUmgXUOi0AuW968X4w/
         xltzvXoZlXSAeUZWKTLRaNxZaD0NJv73sizhonZhZ2T+FYMy3wFgJ3PlXH83IxH41/X4
         TmVqIa6To/igD4O+39XQSIMpIQHvQS8UwZmpHnh57iWDewSMiU4MqkXkcaQCH7lYM6nc
         1+Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXw/FBrJ8IOMvfNrJIqo6DjbuSNm946NBi87uh+dlyZ774SnFmHr6EA3KFbUVGJH5/gVpaKlpsqWQ==@kvack.org
X-Gm-Message-State: AOJu0YwYhWBu+fhI91O+yk5DQ+/UfrosK4eWuV+r6gv1FjhsBlmk1K70
	4iaWpEKGR9xFEyJ1Yeuyy7IEx7J5MCchcroUJiOzTun4OkJfjMGBgOd9nmscq04l+bg=
X-Gm-Gg: ASbGncvyI5MLiXn7pKSdZJGevU+1kf/TWCH8EgNenMD1vp2MgH2N/8J76O1qjOUXNEQ
	mH44Lg3A7ZUIP1zNmURmdUbdxyHwDFg8i6zwVpRKKTj5OvXD+H91TDNPCMpqv++KZs4qpNoYe1T
	rgnLUeS4QBs8ShVkLo6MIcYDSpkzGa8qOXHUUdkHO6N0kfihKJXYVUONQONr44L74DT7GquCLyo
	GdJtATEpC3Pk2D0ux3eZmgMTdqbqbEq1cFpTm18jYJWU/YlxorauaifsGE06dSuvsL5eZLDF+nf
	gNkFGxNgoCHPJvQofKMVoINLNtsdFklZeqWqYIZ9IzCpwjFfiYr3gkJFRgcR5441hCVQ6LAUh9p
	5B6ZqOVXG1ZivkR63Gj4F8GNPFRsyo6vU4rI=
X-Google-Smtp-Source: AGHT+IGQbGMaqUCBVjgHpE03NJ6lUtJGuN0cfMPLFV18k27l43zYHixLrnt22lRnZXhrjts5z9io5w==
X-Received: by 2002:a05:6a20:1611:b0:23f:f5bf:35d7 with SMTP id adf61e73a8af0-240d3039205mr3462386637.45.1755270453673;
        Fri, 15 Aug 2025 08:07:33 -0700 (PDT)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-b472d5e58d0sm1499710a12.23.2025.08.15.08.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:07:33 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:07:33 -0700 (PDT)
X-Google-Original-Date: Fri, 15 Aug 2025 08:07:29 PDT (-0700)
Subject:     Re: [PATCH v4 18/24] riscv: vdso: Disable LTO for the vDSO
In-Reply-To: <20250812-vdso-absolute-reloc-v4-18-61a8b615e5ec@linutronix.de>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Alexandre Ghiti <alex@ghiti.fr>, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com,
  justinstitt@google.com, luto@kernel.org, tglx@linutronix.de, vincenzo.frascino@arm.com,
  kees@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
  hpa@zytor.com, richard@nod.at, anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
  linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
  maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
  chenhuacai@kernel.org, kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
  agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, tsbogend@alpha.franken.de,
  ojeda@kernel.org, alex.gaynor@gmail.com, boqun.feng@gmail.com, gary@garyguo.net,
  bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
  tmgross@umich.edu, dakr@kernel.org, nicolas.schier@linux.dev, linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org,
  linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
  linux-s390@vger.kernel.org, linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org,
  linux-kbuild@vger.kernel.org, jstancek@redhat.com, acme@redhat.com, alexghiti@rivosinc.com,
  thomas.weissschuh@linutronix.de
From: Palmer Dabbelt <palmer@dabbelt.com>
To: thomas.weissschuh@linutronix.de
Message-ID: <mhng-146EE95D-951E-41BB-898C-033437B27EA3@Palmers-Mini.rwc.dabbelt.com>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yu4wq3m6ef5ftswy9fkw3ubwi63aho8j
X-Rspam-User: 
X-Rspamd-Queue-Id: D79C9180009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755270454-317460
X-HE-Meta: U2FsdGVkX1827xNaHesvYJO9hauM5WAMJW1aDE0Ue2jaQ4lQUGCP+17obrIz+uAFAjbp5SjjgdPRerdcx0BuTQJfMrMGGkE+eGPZbSQ3JrhzcAWo+kzGMLwlizO/KUCBuEPUiaI6Wpb4PoGycqSnbVw+h1xn1L8823uhqDUMswimpYsiGGnGblomLgNTSWQRv8v1uyQHwPaJdP82GACYlVbPFx7ZdXWNqxtiZLz75AJyY12PjZeviwFNjCIbWSztYY7hcsDChqQBMrZx5Ka94QLw18T3aV5ua+7cgotUwC4pQSbUnRHs3fzBWY3N51d+c8CevnMV+oOh7egLlW2EexKQmzFJa/hldE5m9UIfRS4+9fyZ2Qq2iZCiyO1zSJpY+qKdpmUWNUbknueQvVTrzuzA5YJcb6asEV+9TRorKpL+U5CCPqm5Kf8MHbzAsAPrhBrO30RtQH4yXaByEmY/xAu+T883iLU9zAouLcfwbzVYBByBPYDMjTHD+a7GS/2z5sjDDFon/dl575nk/GIXdbv1jg2Z/sjO/M2Txzuh/7NKebf7mUU2TGGnprTpHJ7LaKFhxg0R+xNfb844lfIPwSBMZIX3MzkjcR6BCBIqP8G3dbw5qO7NyqmArEeSF9IzINbTXaS0wh/McNvrHd0VWbsriRU9qcEHgtwZXLW8SeSNACm6R64+hQzg4ySDL3NdEWKGs+/4fRW+wKxjnGB4chG7mWOLN01KS/IqesPskj/jmBgMs0WRSOqgGoq/BOKBJOmXAt9gltOeLittU0cW5jbKUp+rqj/Zd5ofHuRIT72JKZcOCKJFKXCLesWP69V8xqE14BEkfVxT5GvA5SGuN7cfdRu7cNx1bJho1/hhw1ZxhqqAg45m7MQsu/IBLR/5WBv+JdP5KATVPf/yUKscCIjIl7/MtGSoMDVdpez8XP0sttLi2X8jLI6RpwrPM+ltnaJ7pfeBKc2iKVe73gB
 aj0KHinA
 QAqT1pvukdJdUbqF+iDO8ba2rFcVuykfto4UuXA1s8LCWZYBqgtGkAPoSGow6VX2AqnVrr0L2WdYw1hntFXYRJOxWZGkVKrXp4bB7NP10EDawQjsPkI23izccFvori5DkAEoqoVVbk5CVtS5HM1puXNF0LTyuxupHZRCwZTWK3XW7j7pKG1sDzPRVmVzHYGmK5v/0Hjp+CIr6o3S794Dz0IsZvNU8BvqNwSJHYcGTMy1tnIKPtlR6ZGkYIqPUu/TzUS6ps+JgnkT/CHpWLHcSQ6g1jNp9ZRY9oKqGLZdBl+szVJZSVeDqhOiCa3Jf4Vrk5COX/WjLF5XBXmFzYRxhAxaZd6OD+tHwjBOPmpXb+9EeA2smsNvxGw1wO+9z6+qPqOM3wJQxEmhxSm2z6FVTyn9MqTweKYQkkTl8/Vd7Kkc+t5/Vv338WRRebEAuOLt2Eeq7sYE5OCdFecYhcR34lN7QL277wLSZyM4oQkzY0t+mI+UB6cpYhvtgC+NQBZSwpp4P9Gw+ngSoy4B+QMVpq5h0z7L24P+FhYL07wfH1p5HOSTo1CdZ31WR6IJjSaKMwnCpV7bs5eSUw7hyTjLvLlHPe7x6OH486bkI9Wm2qk6IxpW5qrziw0cXkbAY9EI7ngSe4qSkBV5nyEUcBuOCY+9tj38MtjT6TV+7LYhC+ZmBdT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 Aug 2025 22:44:31 PDT (-0700), thomas.weissschuh@linutronix.de wrote:
> All the other architectures supporting LTO (x86, arm64, loongarch) do not
> use it for the vDSO.
>
> Its is problematic for some upcoming compile-time validation of the
> generated object code.
> The LTO object files do not contain the necessary relocation information
> and -flto-fat-objects is not compatible with clang < 16.
>
> For consistency and to enable the mentioned compile-time checks,
> disable LTO for the vDSO.
> The vDSO heavily uses __always_inline anyways.
>
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Jan Stancek <jstancek@redhat.com>
> ---
>  arch/riscv/kernel/vdso/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
> index c19c3c76f7c9f6b2f7523a59269de3b683656323..9f1bf5bae9bd473e43d9fd3022e9e1a185128b73 100644
> --- a/arch/riscv/kernel/vdso/Makefile
> +++ b/arch/riscv/kernel/vdso/Makefile
> @@ -49,7 +49,7 @@ CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
>  endif
>
>  # Disable -pg to prevent insert call site
> -CFLAGS_REMOVE_VDSO = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
> +CFLAGS_REMOVE_VDSO = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_LTO)
>  CFLAGS_REMOVE_vgettimeofday.o = $(CFLAGS_REMOVE_VDSO)
>  CFLAGS_REMOVE_getrandom.o = $(CFLAGS_REMOVE_VDSO)
>  CFLAGS_REMOVE_hwprobe.o = $(CFLAGS_REMOVE_VDSO)

Acked-by: Palmer Dabbelt <palmer@dabbelt.com>

Also assuming this goes with the others.  Thanks!

