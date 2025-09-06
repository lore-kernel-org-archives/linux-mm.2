Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50247CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5138E0001; Sat,  6 Sep 2025 13:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F006B0007; Sat,  6 Sep 2025 13:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246028E0001; Sat,  6 Sep 2025 13:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4766B0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:17:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F95813B477
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:17:51 +0000 (UTC)
X-FDA: 83859482742.09.BD583CC
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9C8B640010
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:17:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ow9K+NQ5;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLznC9wbj6fsrEsXcR7N+oZqquNx2F+cSjxXWY46pjI=;
	b=AS9cd6VY5EMHgq9zeUwSeBVMgcxsuOgkLZ4HHCsocEQ3w9BmUQUUbUbipMJ89BsJxWLSUx
	5zbFU3QSQPBztyHMdX/sSCMe+lbrZoSYVBtta198e9qEO/HrN1HRO/8zS3Cl7w8mhRGdF0
	2IQU2zNnkWMr+LiVfnq50VsDfKipXc8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ow9K+NQ5;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179069; a=rsa-sha256;
	cv=none;
	b=fuU8tyxmjOtErhIBTzetNxCaUPc1olCUb6jr/uYivzRSIXQDoMCgR3lk2U1yUV477Suern
	HEP1BhV8rET5rH2mV5wJZYD8He5iE3344S+Sw/70UfpLh4K9kvK36dQdDD/1s6CiEFu0kE
	Ro59ee7PF3Vz0Gr5GLPYB9SOn4ymAo4=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45dddfaeb21so4631345e9.1
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179068; x=1757783868; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KLznC9wbj6fsrEsXcR7N+oZqquNx2F+cSjxXWY46pjI=;
        b=Ow9K+NQ5VsnYjLiEZZNVo2/7/xAz5uUnytnGjK/tV89uMt/igwV5nid+wo71YRCkje
         oS4EsqMmvrNl5pGTffEqFCyCRBzUS0oGgOQ4awxXdE+AZPlJHYdjq+KF7k0Hw3h+LeXB
         dYmsU7OO3ThDHfSN/CAtJjAHcbugUWiAe5zEfVD8RvSDGbFzPCPgtAPWwsUBwhuU5Xal
         xQBophqHzvAHpe8AAV0QTTxuH8wcHRHjUOTaE7P4uOMzCE1dPNEJdB8DvU+hqXdUJ1k/
         ABLrc/qZQYRRbrMfZDqF2v/uHHy9pHCfh8kAG4oC1Cm4owf6yCZT+gIQtloSI7H3iBFB
         aEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179068; x=1757783868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KLznC9wbj6fsrEsXcR7N+oZqquNx2F+cSjxXWY46pjI=;
        b=YoRRtmOUMPmxDZkUpjwhjK58fFrwDz64YQjRiVLelNYhg0XkvY43JydeckH0XUMkj8
         yrBn6CWmjfx0wkLpIfbJoii6BtBjSpgFICfzPgLwG5KSIdmMfu04xiF2JtIUlNGj0tEz
         yGCkoHmltcDuVYjJd6QXPXaAUSgHTa8RspJcK39i19wFHM6cph4a/sOhaYdelORxlMnh
         fxRhMJWxMu7DEEZKsuvuDXEIrRRZGQo7djyuz5ERvUXE9IAIjanloz0xkLU1bxfHmZFY
         q7geuAn6/2CD+9DkPXRK70Pxk0KCv5UST4+3/s/wxbt2RzYi9umFt4p8fHmS3WyNOZnT
         9lqg==
X-Forwarded-Encrypted: i=1; AJvYcCXVdfE8KMpUKaRXpwwZFu3aeqBiF7znmkl1g4s9MFho7uwF9OnrTEd5cvLecwr/VsHv3fpmSYe05g==@kvack.org
X-Gm-Message-State: AOJu0Yz+PweGQgabIr0l0vRzbLE+YVombEqOd83JmK7AR8gneeoUeI/J
	ikje7hwSInkPSl36Rvnv5k9XMcSOnNbQtDBR/yIU42kT4VTfcWcqXA/ehRa1nfjlc7gNYdRcUIT
	xQc6/3iEw9NvkTy1AKCXFH6kgrb3Ffzs=
X-Gm-Gg: ASbGncvZ8K+JiHp4neMdsNWigtGXePxEHgBSeJ/YeSrftcx4zqUx9P+/PF+lN2K864J
	FVOR/sQbhiQDSgx2NamTynBoX5Lw9D+bLwlsuPeNSS6kADPFoW+vNnjzT+KRO7MvNd2SjNzHyrV
	Uj23750DWVSaKEpM6hQ9q7fG6j5k83tfViWfMOEhyLw1vd9bF9erSGfsXcxU6UO1P05OhD9GvXt
	2Q3UDuw
X-Google-Smtp-Source: AGHT+IGTe20HJiXqLSJfJyxPwH5laIdS/e09aggAl2LoVQ0seNUv6wq8RVdpjnRNLbGjxROfKqJvUGIbnoDiK2kwDcQ=
X-Received: by 2002:a05:600c:3b1a:b0:45b:9291:320d with SMTP id
 5b1f17b1804b1-45ddded3454mr23011575e9.31.1757179067563; Sat, 06 Sep 2025
 10:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <98d2c875da80331a51a5c61e8a67ca43fc57cbd3.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <98d2c875da80331a51a5c61e8a67ca43fc57cbd3.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:17:36 +0200
X-Gm-Features: AS18NWBlGrTUf2BbYo1ooSpg8yIusv-EYuyVF2j8Xf3UqWFYOvg4hL7GWGKDqp4
Message-ID: <CA+fCnZeUvsvGy02k4zQwkGUkL7KbuLzah5XC7kp1m5uwp4bPVg@mail.gmail.com>
Subject: Re: [PATCH v5 03/19] kasan: Fix inline mode for x86 tag-based mode
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
X-Rspamd-Queue-Id: 9C8B640010
X-Stat-Signature: o91jtfgrr1xy79g86tee9736qsy143nb
X-Rspam-User: 
X-HE-Tag: 1757179069-637861
X-HE-Meta: U2FsdGVkX193eUnRVrxAMxCxdE9PLgSlSwSsGHoc7ezItxdfL46cVCvlSi368sLus7TwQ5GePZuQe57I3tUngsUHKVgN0JYuzF0opiGovSHRhbdRoiWpC+/QRJe5QfjJzcof2vInup9wAiJsFpF4Lh9oUi6ARKzPeH9aiw9NVipv8AqXaUzbZpqtloniwqd+rc5fn8cZV55IdcRvvMfGt5LbRysZFgNKtG+0j47yQS5yAjlLkDpy07CELJFcz7d/iguQU8KXEC65HUBA3733vpoUukFEjy7uRcIlKSzLYT1mqiCX6tOEEiogNkOy2l9FlnZLNodrsbpYuzvaDjNDr4FlCz2Cw3oKSxNr3BZlv0VheYKr0KmxgcbxyAZT6gsPtcnxT/IHExbO+PCQEoq+M/65ZPzszbptoSGbLA33nw0OGia5wEs8WS9eNbLionP50ZyCJsH23fMafx5Z4fNOKWsN8i82ZTwxmT0Msa1jy5dC4HG8M1UvVFacq2Z2fj+GOHrjbFVY7J1jZIiC0YWy4HT1x7jH7Q31NJM/B5/IFuIlygxjCr3cePg7Y6a92Z+wYrKvvPCxnerHpmLRXLpGrTz5FgIfshKnu/1YO3Zu12sej1LVCdHXbaefH7jtVw10/JLR/TI2n6pB22CiTamsRsmseLooX2XvC5WIVJkxQ2sdzcdngQkQHfd6YaAiYTKUys5Y+VGHFEVywNHeoV2Zl8p3+HizLY/vqtNqLiuEZGm7Vgwah08kNifiRegRumQwBTI1UU6NH1q4dXblhXzjwjrJhQbt3CqK0I2mW9A51GjDMeSGGiDQzol47yAq1+MCUA8psWtf9TzzUqvo4Ifk/GTMYATpsaKjroXWjI9tELPbo0ZBWn3CsUQOtAe7m0S8qtP58od4ZdV7wjao99qRqGxKHSXRJ08byhl8B/FDM6c4K8mEEsT0Qd0fyxDO73OfDCgVzPXiTazvhXiQS/K
 CaD+q70e
 STiGtVZ6XwFphJ7vVY6G+sgRGy869m4IIMIq8dupJMg+zYlBKl5eR2k4LgBcC2ITqJRoWjy2Jrc86Esw9n1EgHt1vk/xp9JMqbijuPaCP7SY++rr7+e0N8/7dKlJl6Rkde63/LEaOb/JhAStvDVVegDKKbkkEqiVBFIl+iIZOjJwKQVMU9zmpXFmlFyQWXgdYLWKIy5KtmMpDQVJq3Z0b6fLiK0Uf1Sl7zhUmlQ4JiL024uK62fGJqkmNaGeBhv8TZZZ0aoOo7tp8wRoA1ildoyMdA2qHlCV4ARjDVjFu+es/zvr/N8T/v13PBnqPgIET9/NbdzrEv5EWTwYquFBvohdc0YWFC7JX9XnVZymt0/MwgVeNNh1BLMaw7o0D9OpVH+Fc1V5Yhd1bedR/s8F+nK1j7uMIIzDdFsl5w7tvNEW3PuDeS5SYR4rP0GVtQeT+TZDtHHBJmLw3/FrkBWCnpK4CoBCqrwwtwCKK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:26=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> The LLVM compiler uses hwasan-instrument-with-calls parameter to setup
> inline or outline mode in tag-based KASAN. If zeroed, it means the
> instrumentation implementation will be pasted into each relevant
> location along with KASAN related constants during compilation. If set
> to one all function instrumentation will be done with function calls
> instead.
>
> The default hwasan-instrument-with-calls value for the x86 architecture
> in the compiler is "1", which is not true for other architectures.
> Because of this, enabling inline mode in software tag-based KASAN
> doesn't work on x86 as the kernel script doesn't zero out the parameter
> and always sets up the outline mode.
>
> Explicitly zero out hwasan-instrument-with-calls when enabling inline
> mode in tag-based KASAN.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v3:
> - Add this patch to the series.
>
>  scripts/Makefile.kasan | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/scripts/Makefile.kasan b/scripts/Makefile.kasan
> index 693dbbebebba..2c7be96727ac 100644
> --- a/scripts/Makefile.kasan
> +++ b/scripts/Makefile.kasan
> @@ -76,8 +76,11 @@ CFLAGS_KASAN :=3D -fsanitize=3Dkernel-hwaddress
>  RUSTFLAGS_KASAN :=3D -Zsanitizer=3Dkernel-hwaddress \
>                    -Zsanitizer-recover=3Dkernel-hwaddress
>
> +# LLVM sets hwasan-instrument-with-calls to 1 on x86 by default. Set it =
to 0
> +# when inline mode is enabled.
>  ifdef CONFIG_KASAN_INLINE
>         kasan_params +=3D hwasan-mapping-offset=3D$(KASAN_SHADOW_OFFSET)
> +       kasan_params +=3D hwasan-instrument-with-calls=3D0
>  else
>         kasan_params +=3D hwasan-instrument-with-calls=3D1
>  endif
> --
> 2.50.1
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

