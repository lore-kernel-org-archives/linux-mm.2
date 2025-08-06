Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0096C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E008E0008; Wed,  6 Aug 2025 14:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625EC8E0002; Wed,  6 Aug 2025 14:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515128E0008; Wed,  6 Aug 2025 14:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41ED48E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:24:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2B98136294
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:24:49 +0000 (UTC)
X-FDA: 83747158698.05.F906342
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17AE2160010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:24:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OfZaAz96;
	spf=pass (imf08.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754504688; a=rsa-sha256;
	cv=none;
	b=lAfM+DpUm5qZ1uLdiZoecpTsvG0mZu5J7dS9/0VTDv+yM46yVR02uA0mtpeUJdv9ISnh95
	81DXbEg74sT/WF+JYBXEBFyTpVhW8wH5vUe90Dpsjks4RtiroJ6LMhP3gJFTOee3eQ7m9S
	4Oh2mOFv8zskYpITRn205sJOsGcjsNk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OfZaAz96;
	spf=pass (imf08.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754504688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jzfnt4fl4r2JAvr3EQAhX7jF93WfuTFzsNkMkN0wipE=;
	b=DKS+526rX7mp/olGAhXy9ObAbvxHkaXKJWay6hWoCe3waqHa0ju9yKwcE38kt6H67Gq7TV
	DGgn/MAn7P347Y2ZgLP6Wya5t5QEpQpu/CgCaFJtHr+gpA4ngdC1KehHyNg+/W5yz2orbq
	ZGLLr/hv4Lnk/hHRC/kTqjNBpJYAzCU=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55b975b459aso168857e87.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 11:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754504686; x=1755109486; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jzfnt4fl4r2JAvr3EQAhX7jF93WfuTFzsNkMkN0wipE=;
        b=OfZaAz96+aGhAuNAwAWgu+P/DEPUm32/yH5iNOtysyNfE7gO4WVVlBfbWTMcSg2JJy
         XiDhNc6e8GPUYyLS/PcNdFwMpNl11wRwhUVoOsJrAroxdY+UOZc02zw/ZxrgokBF8dkp
         tGRb+XN+SZADnrFBVJDK4XbaE9g1H3e6fNER9tDT7Wk6ijhVc6ww3+JoNJYKP+7TlBaG
         wg3LT9p3bKoQN4ZWx6UIwywhVCzD/QMeUsIfWkYgibHdfon6VHfbz8h/AnT9rNbLcV/v
         txIJZ54AqQlkLqrYMtxoHPE3mGyerYn15TyH9epblfXX1WYip1htoa6eh65MqU0s58uy
         XEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754504686; x=1755109486;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jzfnt4fl4r2JAvr3EQAhX7jF93WfuTFzsNkMkN0wipE=;
        b=RdCXZIyQTj5+U3Y6gYB2wQwDuarFuuCx9rzslvmwGygSZNCGnPPgkJfanxNYkaf7hs
         yYDX1ukuWV1Zy5Rx7gJpAVtFGLflCEc3nupcvghfIXgNXMoU7tp87+inKZQItPIfG4M8
         vucwQVSPOsfxMFhw6Yy5ON9mZCBIvgMrvWXLteuQRIuLjSwC2woaqDZTJktXJHEhsSPs
         NGKVpDukBvlncZSDfjoPkx9jQU+lFTjn8H1EkQB50WKX4FnJwZ1b6/yw2qyem1eBVtnM
         0QdZw3TLLjxQBwaVV77Cegr7fmO+tnzghF9Bal3f7MOOP0ilQU7O+dsx0fIZaO1jIOPm
         bqeA==
X-Gm-Message-State: AOJu0YzxJ2rw6IL+PZ5YcG6aaOTGLs2kTac2Rl62/1vOH/qyPObnQIpi
	PyV/SlcHUDZJHet9JDyLJR8uwggywcJ1FxUQZNz+BDSOseDwnIkVjgBrg53ZExZubhwTCXy5cFw
	y49Hxcxs6zmdN2Y/ke+PV+25+4lr44/4=
X-Gm-Gg: ASbGncuZHAbIxUDVxEP2nhB+kr+ICNqwK4qqlKbPxsJPhRHs0SxV9QvhWe+l60w5eWT
	35F0uKTuUTN3A6liZFGERKUUOOZtHNK81sqEtt7s3jtwifrL7PySWjZZlS24i8bYIE1jFqKuXTn
	WgBQd+TWNGmZdIh3nVmQvtpViSyqi4kjnxV+0fQe4CP4ooYGsmwMt2LOmLvVGDepzN33U6UsDp3
	90sGS8=
X-Google-Smtp-Source: AGHT+IF0PXQZi9vqVnGtQAW+0IZx7w81vI5Y5ZNTHdf+iKVApDbJ4sFRSLR1PHAs1LlJtYMmoHssgB5z97iQcbR/02I=
X-Received: by 2002:a05:6512:224d:b0:55b:7cb7:f57c with SMTP id
 2adb3069b0e04-55cb69c0452mr37793e87.57.1754504685766; Wed, 06 Aug 2025
 11:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250805062333.121553-1-bhe@redhat.com> <20250805062333.121553-5-bhe@redhat.com>
In-Reply-To: <20250805062333.121553-5-bhe@redhat.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Wed, 6 Aug 2025 23:24:28 +0500
X-Gm-Features: Ac12FXwvECclFxV4j0m2efvjg_nqG0wG27nQYV0fVI0B5ZHzOZg6GczwOHM9vRs
Message-ID: <CACzwLxivXFYXuF1OkqcP9THar7UGQ3VVAQgQm=PU9Tohb8hnRQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] mm/kasan: make kasan=on|off take effect for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com, 
	akpm@linux-foundation.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17AE2160010
X-Stat-Signature: w5hraa5adnii37768n5s3ja8d6gezaoq
X-HE-Tag: 1754504687-948827
X-HE-Meta: U2FsdGVkX18sSaUO5ZfRzGtMjwL+TxQ/FID42+YNCVGkYOIlyxRB5t4gYzxfednXorytFefKrSer4TFwmFwuXqACBglNUfC+sXPuSK5eKv4FPz+PNHrrkcUStsccxjMYGNv7JBTjzpMH+5ILWgAdrSW7xy6bO7cX3KFXRyvsV81O4ZuzHVXgT4LWM6Yj0ome7VE2Fx7f8oDZx9Ov3qvaRmg0FpCKv39Ea3Ct/fKLQxOOaK8hzUchXLEC1WkkAQxUzsrHRKeek34MEBSKfGRjvijCSzq+7vyPNH9y9KiHl06x0XoVStEdM7sPQZf/1a3zsRlzxA6XU/beQfUDi58j2h9qDJNSCGWzgNL8FlKCEsXxAmxTgg0NWU4HU3MKerWxvkPIoh5uwpkln30mN7zU2OtuJk1qVBomNKhF1TMQ8CCTgAzNge9OSxNxaZIk2SZp0Df5GyEmVvFJnuye6Y9XxQq4t6RA8w9BaVjBALcIKO0O74O/xAXGz8m4QKyPquz8HBfG7tg2wSTwusNqawUeuzcu1TzYqw8fAeJ+3bFvrUEZZLiRtEohxNCahyDXOliTkPjXomDZkRNpnat9VNBPMWGVj3BX3goVDAn1VLRAYSYyDw7CD1+YnYQCDtahNieMlfNigYuJthsSlTBRwrfwxGia2GRs/UdlihjyPCISQhJw+pu/hmNbtB+74awyQob8/9H7OeuS8qmJ2+1kMDZXtpzfxLj1LLOgBlTd6VIiwB+KqTgrAhKdI4DU0YsKNMlQvz/uNNrGNQVR95rp87BUjGZiXYgxtUFfKzczMHCPgYEE22ThbaFyj5gE7U3SiDWeSTU/tFvVXzwUdtYY/+qpDpHfXnBmyZBab49pDps8Du9MY/ircRsgaUL9znCnPEYt0tLCUFIkUpDHWpZm8PnhtU68NnFkaFsa4343bJkh7pKik5/jXNO05fJLqKTc9hEyhyWAztsYY5k1vlXptX4
 /BMwqDOS
 pAtcehMrwzn0HnsUuVNATvx2YETM2QyCHjPJ9RJ7pp6SUWhwSmzMXJJWl6kzDTrMUW17AkpKj3lZghpzdMVE3Is/W1ZO3BtCIPOBVI86PfMfdpUzcFWDPeZHmM3DI3J5IUbyBa0M1kzH60ROzfoiV/q5a1p+XwFMnbEGrb8ARNaHqBGQpFrFD4LJGWwu8KUxcrmbm+fM0mAErYTN6xer92obwqxX8AK8VBP1rR49/kMfAzeWOBpRTt9E1NGUL39Xg7Oy04tcVPHGdeOFNDO3gz04tbW6BkkVtKpXxXy6VJNLoAwNtzNZjKDnEL4bdbPttS/nXdiVi6FsFPTHObdxl1iGirC9Sy5Ijwb8Nn3AhWWCvSF2wx5nkEh1tnNzrnce0vra/cylHzENuxOH4zP1H9x74Xo9HNvUSdL/x3+Iink/o6of5uLQd5QBnuBkHzPWKLgFC7KoceICCAYuF5w53r5M0yY+0GcHEirAHGByKtjg7Fg+/YYbuxcTAWA82PnrFEjqas9s2N9NVuDzgXlSlM0rK1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 11:34=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Now everything is ready, set kasan=3Doff can disable kasan for all
> three modes.
>

Hello,

I've been working on this already and a different approach
with the Kconfig ARCH_DEFER_KASAN has been proposed.

Please see v4 thread.
https://lore.kernel.org/all/20250805142622.560992-1-snovitoll@gmail.com/

It also covers the printing in a single KASAN codebase, instead of
printing "KASAN intiilaized" in arch/* code.
Also covers the enabling KASAN via kasan_enable() for all 3 modes.

It's up to KASAN maintainers to choose either version.
I just need the confirmation now if I should proceed with v5,
or your version if it covers all arch and cases should be picked up.

Thanks

> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/kasan-enabled.h | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.=
h
> index 32f2d19f599f..b5857e15ef14 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -8,30 +8,21 @@ extern bool kasan_arg_disabled;
>
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>
> -#ifdef CONFIG_KASAN_HW_TAGS
> -
>  static __always_inline bool kasan_enabled(void)
>  {
>         return static_branch_likely(&kasan_flag_enabled);
>  }
>
> +#ifdef CONFIG_KASAN_HW_TAGS
>  static inline bool kasan_hw_tags_enabled(void)
>  {
>         return kasan_enabled();
>  }
> -
>  #else /* CONFIG_KASAN_HW_TAGS */
> -
> -static inline bool kasan_enabled(void)
> -{
> -       return IS_ENABLED(CONFIG_KASAN);
> -}
> -
>  static inline bool kasan_hw_tags_enabled(void)
>  {
>         return false;
>  }
> -
>  #endif /* CONFIG_KASAN_HW_TAGS */
>
>  #endif /* LINUX_KASAN_ENABLED_H */
> --
> 2.41.0
>
>

