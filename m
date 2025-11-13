Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89AF2CD8CBD
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74258E0007; Thu, 13 Nov 2025 13:38:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BD48E0002; Thu, 13 Nov 2025 13:38:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62868E0007; Thu, 13 Nov 2025 13:38:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C19C68E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:38:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62E7D1A0AC4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:38:22 +0000 (UTC)
X-FDA: 84106444044.25.521A37D
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6138920007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:38:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GWCFJOHT;
	spf=pass (imf03.hostedemail.com: domain of brgerst@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=brgerst@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763059100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuaLltO93tDllZeZpDO8ivNIqES1wnPSOVBcYNJ4uiI=;
	b=r6cwNt+3o1CuRBGAjQ+UkYhNQlfmv+PR/gqLS9RKmtANjzcd2rD+YCAKh+kmoD/h+E3u4U
	7h6VO2iqxjEg45eaUvNzDG7eX0loqJBNLUUc+m5mwEwAWqycaHPztyqPKwlRCl1lY9lz2M
	tdH1zONCREz87p8Z3Qc+a4whu0hYD1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763059100; a=rsa-sha256;
	cv=none;
	b=v2sw0vntVJDx8NwYpxxlBRDn0K904SUjDa5/7kRuP4dW7Y3TCZae3zFzBGtGG4xBk8mzPh
	ngRbMLepjMy2XC22Q5eOndiIpNE3qnWupyWeY+DjAv/2E7sidab78jlb+338nd4QkBc13x
	7jteqLA1nxOLUXRzKhCf/Afdi1a+/kY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GWCFJOHT;
	spf=pass (imf03.hostedemail.com: domain of brgerst@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=brgerst@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-37a48fc48deso10307191fa.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763059098; x=1763663898; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KuaLltO93tDllZeZpDO8ivNIqES1wnPSOVBcYNJ4uiI=;
        b=GWCFJOHTYHYdXqrHfdZBwVQmPjq3byq7g5IT1Sv8vyF+Uu/vmJO0fbH8HxY3NireqG
         ip81AXJ9mCram/Shk6/7GaQTCzuSxybCYsIqcbLkbgujK9QxiY2s+UX7Vh/lpxNIQQjQ
         RDWrzQ/yRaNr4BMALgVBISssTvxHJYuFn+2DqykHol1ehIizN96BHRLwtPx7XpmNsh1x
         rMMc+Fq9BvFqNod19BdcvXeqGVVS2coUuHl5H9f6azI5G7UWnK7o3UqNuQ7MSKNGRLgq
         zSc5pkI2jcFnfrd3IGsiLEkNZ8XoVaySeZL3BMZKa3FTpa4iBUekC6GZ4aW608deu6oX
         VYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059098; x=1763663898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KuaLltO93tDllZeZpDO8ivNIqES1wnPSOVBcYNJ4uiI=;
        b=CGDLIgGhllY7/HsXV7ZqFqKoZKjzRLtdCN72B8xOT5pGVESRnfC+FCMhQXRGwvW8F/
         EACgSFGqpGDx/0kNVkiev/JUtkYsYQ7IphW88SbRly+dBtL6RBObm7Pl9oQ18AqW8hdH
         uubkfqdFnTmJJ6jZT7pVn4y05u5nu+LmiGRYiNfPS2Z9IbV/IEwjmmcI0phBu0LrnlQ9
         e4H4U/buWWVZu1FalJOYw4z96dAQvJ2Er3hMAc0DFo4PG2juBQNqQ9zyHsHlxtmo9+Lm
         dBmpU+7jR72OAhhaKcNETGLi4kB8TA8TX8V37SuKeUb0zPTDEbhM9HsuwHKrY6pTABVG
         0/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJTVb1J/I85CH2ZDUwMtZCcoy37JgJPMJtYQKOSB9NzGMXj1GpmGOBUF/WQu0oMooUD0OyrCAZlg==@kvack.org
X-Gm-Message-State: AOJu0YyF/ByfMfvNh+NmctnUg86FzK8v9NMakgNpNOHJekXYYaEdUJOY
	dKNc9rWHKoj0n3KsMZFNqPnmwSqtwea+nnZnJ8VXKjue01Gj3qgh3glMkImTu7WY90oFEt5coS7
	BWOOIxfZZTqwYiG+i3CZIyVfa5jN4nQ==
X-Gm-Gg: ASbGncsDYXyw+Q2lXrcCwSYiZLD9khALyqv6tastkYyJS6OJHz1XfSvDnycVSSIx5HQ
	heBPIcD1/0KQ79HyxphjzTSJxYNp71j5d0yM3bkI7+8h7bggEL+5IQIpJFOGzv6PDGsY8XCS6PE
	CnTYdgcX4R/gTNh1cWhcN6DxhKHfF+QPmEHG3aBAm4GPvVg/bGqpck6Z/gQun28aaOpo+0AlSlB
	sgu4YHDK0he4/6/tz7iSyfnxxopKtGPWPrCYIQb9nJYPzotn0VCvuEpL66O//wiPH/rq+nj0Fo=
X-Google-Smtp-Source: AGHT+IFTNaY4mZM1ix3QYFEc82EzkpvKcUBcyp813LVZ4p7kn0l1FqFqSSvz0QMX9+tLUJN4chgtI95mLiddsP3Pj0c=
X-Received: by 2002:a2e:b952:0:b0:37b:aaf7:f007 with SMTP id
 38308e7fff4ca-37baaf7f224mr1618891fa.31.1763059098207; Thu, 13 Nov 2025
 10:38:18 -0800 (PST)
MIME-Version: 1.0
References: <20251112202258.1310754-1-hpa@zytor.com> <20251112202258.1310754-3-hpa@zytor.com>
In-Reply-To: <20251112202258.1310754-3-hpa@zytor.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 13 Nov 2025 13:38:05 -0500
X-Gm-Features: AWmQ_bl8F5Gv6WqKGpN4l0omqbFGWN4-1qCrBCfwhQmjbk6-525Ibg67llMH-nQ
Message-ID: <CAMzpN2iwrzKzhif7WXsoQi=4OdBENZMV14Hm2a5ePukywNgh1w@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] x86/entry/vdso: refactor the vdso build
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>, 
	Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sgx@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p6dn38mzrrqri5dsem5was4kfscrrqa1
X-Rspam-User: 
X-Rspamd-Queue-Id: 6138920007
X-Rspamd-Server: rspam01
X-HE-Tag: 1763059100-483075
X-HE-Meta: U2FsdGVkX19W6KxjEXVaFmYbc59zNPvwzfFgsyIetPaQJQiZd0IBGsZWXSm7muusjvI5HwZK7cnscElk3+Zm7AUa8Q96U+PrFCMUa5uZcoAszZj1f7Xd2wEAcvt3CGZCBpSAcY5h49oR3sBGrqEzCWA8D3YT8uW1AxRlbSt16MpkFKXS/vUVkPsy2isPhEutTAPG1/L76TSI9pTTHfmoPJNuMI96m2Cp5FdZ2mhnHn8PX8r7unaSfiZ5819ZDCfnbK9UElR0cgr38nLGSL3JPmm+1XA6UwZq/mnkUZILwSnNTP5OmzLtgEocTyuwnCSNF5MkesTnB5D2h+GeeXjyTHqzRrvzQf5Q5/0hy1TK1Hi5zIXwxdB7u6fAghFT2mA3v7IdZtt/6Bar43gkT6MYal2yd3ARcrOgM7R2WqK/jybwp+t9OeYd75bH4XSnPbFDNyAVRHJWrRQpu63j4hY2O+pXZr7TGF7C3YAfJdIKOpPFVoWI1qI7U3rIrZInydzs9UK/O5bigmDHxw8s2lEhO8jrYmWjnbbt6YUmhg0pprIuM22cDUWnHWmgoA/iJGVIkbq+fTHHnzgowgm1DzRlOd3D0cCxR5BjJgRSkJsIgXYEL8wrSc8dhtQOc6ZnVlUs9AGVYG83ZJSs9J69PYgdrwAjHhpO70ITDUBN9aFDwV2XDxglzqZYh29l150t12ZLhSTzbM30dsaQO/6QdOkBVOH5VtXg9APhOukMzXzAAAVqvaXgq363TWCE3tJuiwKv+56NMRKCZikrKaeIEzut+cL5BX/4sFweojMXPvtnWwb2go71IvPS4MRYKOAhb/RGTZIx40APVEDDrw/dbaAQ26W9vM8p7pfRsBhGENN8t7m2a3oeJpmz0wsYs/InoNBA40lSudHc2lf5VHn7tob/DfqihqmcnhDOuihxgo7AZA5U+Qvvfp/M7pBR4BaV+EYVcJqb+mTr7cjHgx9qrGS
 RidQxeYH
 uLpfJtGu/I5nNdS65dnE0dcvXgjx6EgX4GCwrLnOS6Hf+wuUGuxodM/II0gNqyp0LhL1zlY9W2hA6fP4iO4dE2mKOtgW0H/EFo0BLuhNaDgb02Yz0lR/6OXY9bF71jI1mE9iK5wiXsunlzgsRROdJ0NePTrcGF3ADl1eeGl7+9nPOEJHEoN41IuA8mitp5lmiWEth6uGqVz2eCfAWtk552AouYlDXLjCVpPXIMIghkl4kSX/06q4eYVoHys6mWBMr94r7kVqrJCatRj/BagLhsld9KFrEg1Ful31yXwHSTvqG5nDcnWNF15DEsJBqE2ciYVWu5njn96SZ3yLiEvtNCVGOT6rvvYvFls7Z7/3CklXr+G4GKk/JKFJ8m9mM/9HydwUF8Xlj7dhJ9XF9H/C7OjEyL7qLYYQb0Ld4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 3:23=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> - Separate out the vdso sources into common, vdso32, and vdso64
>   directories.
> - Move the vdso2c tool to arch/x86/tools.
> - Build the 32- and 64-bit vdsos in their respective subdirectories;
>   this greatly simplifies the build flags handling.
> - Unify the mangling of Makefile flags between the 32- and 64-bit
>   vdso code as much as possible; all common rules are put in
>   arch/x86/entry/vdso/common/Makefile.include. The remaining
>   is very simple for 32 bits; the 64-bit one is only slightly more
>   complicated because it contains the x32 generation rule.
> - Define __DISABLE_EXPORTS when building the vdso. This need seems to
>   have been masked by different ordering compile flags before.
> - Change CONFIG_X86_64 to BUILD_VDSO32_64 in vdso32/system_call.S,
>   to make it compatible with including fake_32bit_build.h.
> - The -fcf-protection=3D option was "leaking" from the kernel build,
>   for reasons that was not clear to me. Futhermore, several
>   distributions ship with it set to a default value other than
>   "-fcf-protection=3Dnone". Make it match the configuration options
>   for *user space*.
>
> Note that this patch may seem large, but the vast majority of it is
> simply code movement.

Some of these changes (like moving vdso2c) can be split out into
smaller patches.

