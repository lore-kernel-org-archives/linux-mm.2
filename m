Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44795EC142C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8296B0113; Tue,  3 Mar 2026 06:20:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0076B0176; Tue,  3 Mar 2026 06:20:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E8E6B0177; Tue,  3 Mar 2026 06:20:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46C2D6B0113
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:20:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECEB616011E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:20:30 +0000 (UTC)
X-FDA: 84504508620.22.8033A44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C57E14000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:20:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r/p/r2kf";
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fs5xy54dOwpapJM1ABjgdm4o/gqygsmCGVNWqgWoRQE=;
	b=Dl/Gu29OXCzM83bGoTwy5YH6G/1ZhwKsljEwSE5a90zM5jPpM4BlEfqe7GRRpkh3k7mO4I
	DJASFdu03zBuKLMCCEY3MFug1N8bveSfy2k1OhFcqRtjR+yR8jliQI/JgsuFA+osuBkHY9
	4T/0/U8zvQZSOLgPLCtj6IU7eb8cA80=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772536829; a=rsa-sha256;
	cv=pass;
	b=VD1DN++sq/QpyqszCnMjwhTH7DDqhUgQMkuE6x+yZcXyqCVNcyOnriJ/m2UynvVR3Eg91f
	VIyiPX3YI9FqpK1PGIXmDskT309Pb+xEzoHB8HC9Uk/WgzQANyGAAzzX9vtfPQZlLuz7JY
	oV1nUrpO5B5Xu9K61mXkBxt3GSySR6A=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r/p/r2kf";
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899f5d337f7so23775536d6.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:20:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772536828; cv=none;
        d=google.com; s=arc-20240605;
        b=YzjqrhLLwkV+tot2Fto8ret/BTevc98xuzeyWKvf5pUNm1SaHPB7csB37YaPPQLNBs
         5MOviadMiuDmB1/nLAFePCM8spH+ZY9rWpEVxXSrfSxHhV5Jo/MsV08SDkq5PbvCFIA+
         I7VkqVo7cj1pIosu9WumBQeFjcc3gEQ6JUEPLNZx+XFyp+LOCxT5D7ZdO2k7XGyoDVCj
         Oqz8Ezyj1T5/dZZNsXXcfWLXcR2nWuXAtqLdYe6cYJseP1s7nmUPXMDTYxk1c10L1QQ4
         v4p4cTkdwwtZgHWCOx1/hCE8JVPPQIvqksYye/2rwH/6sgNvzaxyMrzc27MxhExGGlWA
         fSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fs5xy54dOwpapJM1ABjgdm4o/gqygsmCGVNWqgWoRQE=;
        fh=JlIDJiLjfLmnRJrREiRbf7Xd3CgUlUUPSpAXj0vqutk=;
        b=CVatezhxKZytso6MGwl1oCbXaArIt4pik1Ft7J10HIw7xt3JQCq0Ih5DdoCxioYz3X
         RlAHfOox1DhPZkFG1p4cmLaouLKS4hIQLdrFkS2cL2/RT1dngGv/ra0i+NWllAwkU7A7
         7c0bopJnluR42YpHiuMTxUaj/XnVeqhNoeNAcxU17l5SZBGygArvukeFr0uzvNHhJoWK
         C8O2a+5OPGlarAlSJvAoYegWWU5JieL8ZcKe1qgXAaBaxjgqc7Fs1d/PdiFLK9DwkUFB
         hQgY1hzBybqWijA6D9rsSGNj/+4ojCzYBH8lBy1VLBVtjvUZ/LQdv4ZpCpAGMWuuCFyB
         YNfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772536828; x=1773141628; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fs5xy54dOwpapJM1ABjgdm4o/gqygsmCGVNWqgWoRQE=;
        b=r/p/r2kf+BIKcWdBrUF1WzWZ649o+AjsuCIObp77Bpwweuy2xSyOVzkAjVVHyIbo65
         IFhGgcftPnolRxnEPQYhKFb3mRarEQ2xR91iz3RImRfX6XgpP1s/pugqF0i/q5So6ZFv
         DOWD5sL7V4v4MLr52peD0+ciBJkTzZE9rTp8F28YLce0Mho9GOCgqcvG7I+AQfC4ndTM
         R50r2bcD0Ke6tL3SeC8C92d4hZlb5P2rQ9Y65gwRPotiuw8bb95kTlpgQo9pSezbGVoA
         bwhmClGU6Ql5bHbmym6Jghx8yJNQ+CeWZYUD8HUkodwbraPvsnksLwPBlEX4wiHg9Oeh
         mRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772536828; x=1773141628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fs5xy54dOwpapJM1ABjgdm4o/gqygsmCGVNWqgWoRQE=;
        b=vHkrbKoMpputh6Bp+EMUtfSDPH1cMFc+vyGf8aMs9VzbJ7PlWIT2YFYMBkjejOuyTJ
         GYGvAaMiKanggTiQMQwkYVr8E4JeUnE6Af3zUZTl06LQjTRztIR/KSgdkIW5ajXQlzIo
         JeLIP7ZVBBWjIT+kHuwrFMz2ytd/5FBlCz0QDK2WIiayXn9RBHTVyjtCoHnGdJKGbdBg
         B6E9NHTLgo6VNUYBAh0pJYMcZG3VzHpUIN5u52kohM+IMQHDCNUgz1rrZ4RkiwYkVAGj
         Kri6M/mO3fRw25f4o1Qli5lMa95eNZ1eLSBHikwfVIIYk8AmvSnyzyZthzhQi6SNwZE3
         2ohQ==
X-Forwarded-Encrypted: i=1; AJvYcCW5eKhjJ2iW2YFClywTKwPDynNKlZVV6LZCxBJ6x431A+2ZNk8/dqxsnf5HplC1ubm1Lb8a8Fj89w==@kvack.org
X-Gm-Message-State: AOJu0Yy/WLjnKYnTDWFlyaZRl6sWBo2fCq7V6KVsY8F2R+faxBWstvNy
	oybT/8W1L5EQB9kE0dbFVqIkiL/quVtAwdjmzLvTp3GjJ2Yw96nfUliYwC/Tgq71gQ2Ntsmv2Gg
	z+YUD7i8v0nA0LbquvW4IPpFQ046W+ynYDYxp1kdn
X-Gm-Gg: ATEYQzww2o+Y3lX/vfOKlSLyJ5RB2DlQdJylRGFRJPt3kSgPnsnLgRigoMl0CHfw139
	/xF1SPFWueB/BxzFvxOjoVkczvPowi/pghPe0bw5M0r69RY9+jgM7dCe9DLvTcPnZsVvRor2DbK
	QquXOdVHnc2fF0jGYyksREiCFdapFzZaWwaEs7A650otODAfZ2FLiIa9D6aLNUBIE8M7CsI/82f
	IKOT9F9TPV6JyeZHHlw7s3kKTsLjk9oOgaxUa6T25gSrkgOBvUvvWf+qD3mAGjqW5t0gNIZjvY6
	5m7QgYtD0dxu8XYPScUg6uBf90FcPErPEIlybajK6162rGWk
X-Received: by 2002:a05:6214:dac:b0:895:4d3f:b6c with SMTP id
 6a1803df08f44-89a0a89d396mr19056596d6.17.1772536827672; Tue, 03 Mar 2026
 03:20:27 -0800 (PST)
MIME-Version: 1.0
References: <20260225203639.3159463-1-elver@google.com>
In-Reply-To: <20260225203639.3159463-1-elver@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 3 Mar 2026 12:19:51 +0100
X-Gm-Features: AaiRm51ecwm2GzpvBNPquu22Ta0sfwGcKpcC_V0mxDSrZBLMaa5eBCNTn_slx0E
Message-ID: <CAG_fn=WAwHUpoay2kY6rkEZQGYxoDGVJYf5B59Y80ht7++Lmqw@mail.gmail.com>
Subject: Re: [PATCH] kfence: add kfence.fault parameter
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-mm@kvack.org, 
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>, Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1pek71x75on89frfzy1ph5aeobmyxtg4
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C57E14000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772536828-228313
X-HE-Meta: U2FsdGVkX1+7oDjMbW5j2kkRIir58bpxKfzgjgHEocGqO9sYT3db3Ut/Ex5n3ca59ElBdL/oE+rDXJSFl8meFLWwURukcTmgP4fD8yPSRrMhE2olaPDekXRk9XFGm5NDTF17cPuJWnhlksA01qGfAqcAfkarNuEvVZusNNAzXBtuvmjFFncWS36z2T6abf9BRvEEZvD5Y5kaMBSBfL9SwpghLz7KLQ8Pw0cuivva3sBnbxUw2CVlxnOlq3dO/Wb75u4z/a+FhwS3bXsgtnccn//AfqdcKoTiIEJAXd+eZCxP3QhCEM4g3alHw21O/FsGnQ2SosTOg1DRzSZlt2vc6CgPfL51Gq92lVumUeh78xBdkeoSspLEYt+QaHtL6FGdoVJqJUdiXJZ/5mvi+E3umijhLSuFkLpz9hpc7dM+SnBHL4jA+7ieDcZB9JX9+8+ihEVFowVnXDpJYDIOw87dRZKaFXRaxJldQfKuvZCfdevLiBMGJFI17eUBrypMyTFIZybNyOLg7Kh7zXbnv5fT/JTO2zVnCfObhkiOadFCMfLAb4b9sxS29mcPdZlCSMtlWDiqbyrxJjjeJy/tZq0s/VNNVq5ow8RS6QrH/slOof6co0eF4Tz9i+oII77qiaknCLUbwt4TTYu6FIKebDFZvEPxAjCzMGgw8gzVCkI+MQyIiSPSnlPIhFJXC53ZoJqU+LTeI2E6DYw6m6GrNFzqF6CCg5ApmJg96oeautgl5PmrClGRsRzVOeYy8yq6xg7ySm5DguP/iSiZUFAfFViNm7TCO2IvOdP+rvYPZ436G/gzQjlktXn6jTW2IoVHsjlFY1b7NtdGXMctsUNK2uoMfcl45WVLCO96QobZzufu3tFU4IQH6ghwzq2TQybhcyA+YdDMz5i8Candu9RzGmTmE2xANv4rPX4U91W3CW+zGAfDYieI5yvBoR76VH2FNuqOFfAUXUgMt/+B0ZWqqnq
 KK1WVvwQ
 OiWfActma1Pq4emIjgQsQDRcW4qRTR31Rv90U8Ez89wZnWu/OhlmV3KOsduvQaNomDa2/TKFQnecAGgkrEeKcYQE3IQRFgnmInK/XkbpKUPup54c5Sb0fzKNVUn/33X5ZnUxVhSbd+Bt09ZGUVWg/tNRmFvpl9JQOPxJ6nmuzZuE38Vm4u4RSio9Zijc/9GS5zr6pJ9RZoiixQ1xlm1agp5zyrE+WIejmBS8oJrTTVQVu3BQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -830,7 +835,8 @@ static void kfence_check_all_canary(void)
>  static int kfence_check_canary_callback(struct notifier_block *nb,
>                                         unsigned long reason, void *arg)
>  {
> -       kfence_check_all_canary();
> +       if (READ_ONCE(kfence_enabled))
> +               kfence_check_all_canary();

By the way, should we also check for kfence_enabled when reporting errors?


> @@ -1307,12 +1314,14 @@ bool kfence_handle_page_fault(unsigned long addr, bool is_write, struct pt_regs
>         if (to_report) {
>                 raw_spin_lock_irqsave(&to_report->lock, flags);
>                 to_report->unprotected_page = unprotected_page;
> -               kfence_report_error(addr, is_write, regs, to_report, error_type);
> +               fault = kfence_report_error(addr, is_write, regs, to_report, error_type);
>                 raw_spin_unlock_irqrestore(&to_report->lock, flags);
>         } else {
>                 /* This may be a UAF or OOB access, but we can't be sure. */
> -               kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
> +               fault = kfence_report_error(addr, is_write, regs, NULL, KFENCE_ERROR_INVALID);
>         }
>
> +       kfence_handle_fault(fault);
> +
>         return kfence_unprotect(addr); /* Unprotect and let access proceed. */

If kfence_handle_fault() oopses, kfence_unprotect() will never be
called, is that the desired behavior?


>         /* Require non-NULL meta, except if KFENCE_ERROR_INVALID. */
>         if (WARN_ON(type != KFENCE_ERROR_INVALID && !meta))
> -               return;
> +               return KFENCE_FAULT_NONE;

We explicitly don't panic here; guess it should be fine...

