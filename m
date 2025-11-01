Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCDA5CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 13:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157E28E0071; Sat,  1 Nov 2025 09:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A538E0068; Sat,  1 Nov 2025 09:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020118E0071; Sat,  1 Nov 2025 09:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBA198E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 09:50:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 853371A0886
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 13:50:27 +0000 (UTC)
X-FDA: 84062172894.27.15780FC
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93CA9C000B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 13:50:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SeOzDbbd;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762005025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUhy8B8e0SPVvnGZqFMKkN671bOxkjd/0ClcQZsCqPk=;
	b=fQUvTEl9rtcqMPie0XSM8RkCC8gYoYp/P0997v2CVO0MxqgL2XzrSu0Qhd8f93d5IfvfH/
	PAGYrZ5pauPkv7ZLzyMLTf3hON2iGOXMxXZVpWHyQmZttF+B1AO9sSDm6SdFoXBHbJYp/u
	sNfxifWJCHgI9kRmZiuK91doabfgpgM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SeOzDbbd;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762005025; a=rsa-sha256;
	cv=none;
	b=JxrzB2HXEuRArYIXJeczGT36Bc7FEQpKg3wa9Scm160Vk800StT8EDODOE+9YXjmehP/p3
	jDT7MXv+2ggjZYeSNDYCJDkfp0Zx+38ezNVKXiYHcCmjkvWockk2zcc0BM16tkBWX6aA+D
	GlfIyhZtK5rX+c4s9VUh7RVMVu8sw/U=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63e076e24f2so5899515a12.3
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 06:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762005024; x=1762609824; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUhy8B8e0SPVvnGZqFMKkN671bOxkjd/0ClcQZsCqPk=;
        b=SeOzDbbdEdb4TgiC/7sAbYjp5TvpgjENqqK2RvUNlYbYCDBr8se39i3xLk1eCTyVlu
         SIZdLewz/ZbF/Okn3InCPBb8JPIQ/nA4aaBYevySfGPHTKOV8Xmv9lVam9tat+ojg4Om
         C2K/ado1ZBYgIarurwjvInKEhTRhaaVBbh9nd9Nuaihx6JpvFUbWMNopHwoRxodgK5pi
         T3BTJvKAu3adsJRz2+09e+n6f3gZnpQwYlhqw4NbkO7ucigo+qODpBpjFU8+tTOP6L1s
         DRG1QF4Zmza9744No4A0ULAKuhOj3TUp9pcvGrdVLgVxHNlxAAAHapic9SVjjOEm0KCE
         qfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762005024; x=1762609824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUhy8B8e0SPVvnGZqFMKkN671bOxkjd/0ClcQZsCqPk=;
        b=wZjY9RDZ5CZNTYmvntbFvxSUTr5cN5CE0RUcdOmcMONKuHIgIu0b9JI+surXdmRIi2
         oJcgZVqHKmZdcJQt/QLy92KXHo6tF0E8wiehAZEFZCUi6kC2bxIaBELpDskzlv/iLuXc
         U4x0KHRc5MgWTnB4DlNG6babRoJ3txXA4pLdAbh6+LtAA1Pm/n1JLUODLlFKKmOsADWc
         eJAhGOQBuWHGD5EIEPazVExDTHZQ4ojZ5CARChZSY8DE4KnRrJzCA1EqvQ53YOOaQRC3
         ahfMXeb2w+98hOB4Z3/EWq200BJ+0ZqEW+qGE9LC1raa37jt0JKwuOgFYbTb8XlMOdQ2
         4iaA==
X-Forwarded-Encrypted: i=1; AJvYcCX7klK1jNYXXm1uqVpFgjTnfeVBSyReaiy9B2cYtlqSTWMRB2D+2IoOnWrjUi3/4NsWBQv2+M6FSw==@kvack.org
X-Gm-Message-State: AOJu0Yxx8MEzpTCE3LIP6vsW1QrjCq0GphwGLOHZ4UOYDhZrXA/hhufg
	2XDiDTEYR4LgpLTDU5Sl2lq4joPrKpVnc8A8a9FCAu+XL8cuBBiiR7wUphTPjBnJ2fn+c8E9rFh
	+H8xh/DVi5ZarydfsJUrork/fYb+d61TpjddP+HSykQ==
X-Gm-Gg: ASbGncvyZVE+wNjMfTkMrT534DzGTLTy7nEVyaY+aPrluREr3U/eqRw+jBqGey6ny7W
	h8Eb/rNWNBVsS7bm6Rfu4au5QWZhjxyJAguxyGQyOz7wHv7p1j9uHM9N9cBi7XEuykwnIhFQkwZ
	kMqfNLhAY6C8lHLBPJZcLghIONcyIoaPV93C5yqDt25Mu5PmkQXP6k9n5XqxO9/NiTKaZJbfrWe
	gqXtQREA4Xdsd/vjLTgc+y2b/N+VYjmVyeZufBBSRfWxIoD+/LOQ93WmjpE7J4O3l0I4tvgHC10
	qcZ3U0Liv1AMH0TgnMNRUgjVq88I
X-Google-Smtp-Source: AGHT+IEIO7PvHjnJQ62KO0r3gUSccSfXRQY2A86NcnBt2N+segjhBecWOfFmRqh0rMurQ5aFXaviqq5czfpYfbaRUOE=
X-Received: by 2002:a05:6402:5347:10b0:633:7017:fcc1 with SMTP id
 4fb4d7f45d1cf-6407704fd5dmr4625184a12.14.1762005023728; Sat, 01 Nov 2025
 06:50:23 -0700 (PDT)
MIME-Version: 1.0
References: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
In-Reply-To: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 1 Nov 2025 09:49:46 -0400
X-Gm-Features: AWmQ_bnZsvumh2bpEqN2i1Lq7WYeKAVK8RN5_qMjSNkRfeRKZmWCf3eNLlzvj1M
Message-ID: <CA+CK2bCHCw=5MaOVpm4VzJ0rHtuTVJ5JWECZQxc128djt3i0XA@mail.gmail.com>
Subject: Re: [PATCH 1/1] kexec: Use %pe format specifier for error pointer printing
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, changyuanl@google.com, akpm@linux-foundation.org, 
	bhe@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 93CA9C000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: izkic46hsuzsrcf866duya3kdi8jqki1
X-HE-Tag: 1762005025-567147
X-HE-Meta: U2FsdGVkX1+SvPDW9gF2C2TIIdMMPzU5f2wiSvyCOg7raNVEFB7f0fg7U10b0ld8vVMXBT3RtuIpkyN30RiG51uTCHZjm+C7y1rK4dDYKplJ2LPUHLJrww+9rGT89F5hKCarCPfFapgq806b8fw22/Anz8GBr9ipDXXyGoCKZm3R6w0AHROC7ew5Q4ibX2r0AGxla7AehGmT0rJIwpKcxCuVItN9Lrk0ElkrJjkBfaS8lXj1u0APxncsEbGwsqEd0a37EmmuNHcsNVSBEt2RmaSaNAMOG9rMlQrKES+oygS0HOWOZE21DNN6Tnlm51jXkyZz8YceUHs+xAd1AGcHF01X9BwgzPE37nz3YegBEPt24L7203bu0xrB3D6xIjqsPQvFMd20a6t3FsrhuoQqGNxMxnRHAxi6iUZSF8cZx0IadIhoMG4ylpg+GPURpa3fIZOXyZ0/Ea4HsTDCznzJGZv4mfEbq3Ns5/fGqsRPDlulcClWNPTKUXTZ1WN1vTD+cHq34dkb7Ee+HoviwENcFgo9rNyMkZ5MaLYLcM2T9ZRH8L2vz1N4TyfFjNpA/zUE9cwZSQ/rXQIXnHZ8SXEVMRCwnNyn35hQoXuGcPd8l8NyRghR3q7nutm4fL4+d2T1InaY2g53l4EMQjSz+Ij3WmJ0Q8yrV1FeFyINzlH28PSbYeA+rv53edwm6rzVpw/2aDuvZc7Iwwpc41Il8roA61Wi3BxlRqiz92K9qBeGtQG9ikdnfkbC2scrrb5od/j7wWdYOwvXxED8Jdlx8QiHd4xVOiQsrXNxelQGTeK+Rz81XpAwNUun+85hcG9//0JQMc0GSMpSEAE7Egoc9YhDmqCasSskGYfT6+oXv6tzP8rNub3szDveJeMOZVI4IwN6C3xYEFKntqTs7lIcxMROU8KOYX7sqVv6NXAoKzZLRouvRAyaNfEeoLcv03fRob0P/CsekYX0CNHpnreHIGG
 hAXPTJ/R
 MuOUrjkaaRqXe6EUKX+cT6W3JCh5e0dc+IE+dQ2bj22MbaZKQRs9YJep4Zz7XbHqOxvWjFy0XIfi4VhRA059F5dDlA6T5XkJPGPksVe3afr6Mw9mHQn3WK7pzp5dPy1BoDp5t/8OGmfv649hdCx7XqYzT9iwgs/xQhhKWXl14XvCcly+CF2X//FaDXh+AqaSpM9AafouFedK6/ZkkdUnJE33mshaA9fLg7o6lKlIp3HBcyxDzCMKbKCPMk+7MrZCWdhYuiZ1tu+uCq4oKKQ4OBzMX0LbiYruPyxgmy2G4HXLqfCm+GjVGAFmCaNwx2UwAUvqoJ294oZoieSMH2GpnosR5VA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 4:03=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev> w=
rote:
>
> Make pr_xxx() call to use the %pe format specifier instead of %d.
> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
> -EINVAL) when given an error pointer created with ERR_PTR(err).
>
> This change enhances the clarity and diagnostic value of the error
> message by showing a descriptive error name rather than a numeric
> error code.
>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> CC: graf@amazon.com
> CC: rppt@kernel.org
> CC: changyuanl@google.com
> CC: akpm@linux-foundation.org
> CC: bhe@redhat.com
>
> ---
>  kernel/kexec_handover.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 76f0940fb485..77af377022b0 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -1095,7 +1095,7 @@ static int kho_abort(void)
>         err =3D notifier_to_errno(err);
>
>         if (err)
> -               pr_err("Failed to abort KHO finalization: %d\n", err);
> +               pr_err("Failed to abort KHO finalization: %pe\n", ERR_PTR=
(err));
>
>         return err;
>  }
> @@ -1142,7 +1142,7 @@ static int kho_finalize(void)
>
>  abort:
>         if (err) {
> -               pr_err("Failed to convert KHO state tree: %d\n", err);
> +               pr_err("Failed to convert KHO state tree: %pe\n", ERR_PTR=
(err));

The problem here (and in some other places below) is err a not an
-errno, but fdt error:
see: scripts/dtc/libfdt/libfdt.h

%pe ERR_PTR(err)  will output garbage, and make the debugging even harder.

