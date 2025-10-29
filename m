Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFBECCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 06:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9228A8E01A0; Wed, 29 Oct 2025 02:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9FF8E0015; Wed, 29 Oct 2025 02:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7988E01A0; Wed, 29 Oct 2025 02:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64D868E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:55:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05A0B5B37A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:55:00 +0000 (UTC)
X-FDA: 84050239560.29.0AEEABC
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0C1E74000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:54:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UE82q54L;
	spf=pass (imf07.hostedemail.com: domain of brgerst@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=brgerst@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761720898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDqF9BgrJ7R48G+OSHsQqZ22RHXmw3YvmJtykHqVDo8=;
	b=oIHrTwfNeVdYgiwcd73uWFGKJ7xEvtkoV+t+dDfEZHHassJzY0YC+NRrCdIU0rSEpAtaOB
	V8pfVTCAwt1boktsj40eyq7aIQIdocUBl4dGpG7aWYGjy+df19Lkn+jR0I5fUnAciee8zk
	uQkWAH/opuKVCtn38zjj15OmWb7/284=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761720898; a=rsa-sha256;
	cv=none;
	b=PCOMubSp/mzOku/gSe49xrQgFrdmQjxhatmSyDDbtXb44HobK9xkdysIQY7bHwpI7sHdjr
	OuUvZoHs6M8nDKXjH+sWqNUOaSywDdePL3AVZd6vjF4293Xb5NYbz3XDfOFkw/OJmzmw/C
	JvFWuW5PtkgOubXs+F5JlXXP5GezRNU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UE82q54L;
	spf=pass (imf07.hostedemail.com: domain of brgerst@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=brgerst@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59310014b8eso1825808e87.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761720896; x=1762325696; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDqF9BgrJ7R48G+OSHsQqZ22RHXmw3YvmJtykHqVDo8=;
        b=UE82q54LJKyIO1XAK3ym4eoG4HBLeDiGE7DHeJEdMZ0BxZ4dxG2Z6YawfAkbTHCDqH
         NgJGLV1x66bWD7MSomEMP9SB37Cdcs/Qb4QTd5Q00fBGfHsF//vlbSEoODepfUF550jy
         GYCEdxW+/kvKkq5CwI8Y7nlnBx9mi3SO7JD/zWnacCn6urRnnkV+5qi2My79h765lDl1
         NoT8pO11AGLk5UnvxaXEjUSqd0fSIV/kXMZ/Wvc4WWdsT+EG47gn+7kBOsIKgy9G5GHz
         +1VwWC8mMQyvOL8QPhiwreJpOPOk2PGnUjSENANWEJD6QpCaCIyZzJrUTh3dB6G5tCls
         Targ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761720896; x=1762325696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GDqF9BgrJ7R48G+OSHsQqZ22RHXmw3YvmJtykHqVDo8=;
        b=dAiFrdQOQWXzTfVfHxsod3bP6DQ17qIzgwoon2BO2jTNseosiJ7MwBZBeQsKTtJFfN
         oVGHhvNJtoTOQxzxOAeDpBDMrP09f1liLweHKrPjrgQAYmQFhLslXeBaqQhzkoOl7srp
         14lRT56EoFDVF66r0IdwNC3S/hvsIyT0wAgWMeuv49Ib0VfrpUfxn2x/0j/A+smP3j2Q
         ZrmmOIy22q9/csg49Ie6wv0AvKmlo3Msq0NNItEfbsQLYkNqBHYZ4Sn3igrhrPVzWkmf
         XuVdRNpZf7ji2TimrTSfbHaCckNf6cMflOJ7ueIrVC8RYYkapBd825VFfqvthMTQKaY6
         i2nw==
X-Forwarded-Encrypted: i=1; AJvYcCUKKVRc56ydvT2zjay5hBpxJJZWpFbjB32xlmrOxYvHfR1n8wzrgBQtJmTSY9KCrYjdbTrVpVGm9w==@kvack.org
X-Gm-Message-State: AOJu0YzNlwrH2Z2Lt2+KRRR0inoHpRnpZsi+bZJqG2GivYzVqgRRnhTc
	EctkufvlAil9dnR3LdTIfkFan4UVRRKNXxzBs+Yd82R+nPH2bY5GlldaojdC5Zy+n0xpWrvQR7h
	c0BvJ8Ei63w8YHCSDdSHMz/MaBRIlSQ==
X-Gm-Gg: ASbGnct+nyyzLsgY1AK6Q6qUsBxnVn6XvurMIzcAs09oqtQonlxewZyN4pY3lkHXqgv
	E83Nz1Hu9C2ViGZcGd7IfQkDHM7FQaRUOTAdTfkdKT98PbD9NWe9w+jKT0pwT6WmszziKUlu+Ho
	/droAwXKghh3Z6gg3h/AQWMpbjLVrBPZGPOVwIXFwC15Q6JrH01u7FyL+QPJuvfUY5poemLoXUr
	mbGSfDiv/fI2id2f1zTJeJ0ki5IYBurvnher6ytgZ7dgUClmL4I4vZX7o19bDUW+BbqdAV895k=
X-Google-Smtp-Source: AGHT+IGEuL5EZ1//R48jmqcfeWhsVo1m8oxthAF3NZBoYhNUuWGZKmZifPFDiAMnhMvwmoelT2mK6IbqIEbGCeJQ3WQ=
X-Received: by 2002:a05:6512:6c9:b0:57a:311:3234 with SMTP id
 2adb3069b0e04-594128e9881mr684224e87.55.1761720895815; Tue, 28 Oct 2025
 23:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20251026221208.1938173-1-hpa@zytor.com> <20251026221208.1938173-4-hpa@zytor.com>
In-Reply-To: <20251026221208.1938173-4-hpa@zytor.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 29 Oct 2025 02:54:43 -0400
X-Gm-Features: AWmQ_bmfiyfREKo0e-gaQFIywqypW-gaTtMVt4rv1DnveKwp_KlVvqDZ1gAvjyk
Message-ID: <CAMzpN2g1G9Jc6eL4L+Rq3kGvKALt-tuaA3NKUuZ-jJXeaKuPRA@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad
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
X-Rspamd-Server: rspam05
X-Stat-Signature: jjn8m57tsbohq8jbwkhht1urcwnch1qz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C1E74000A
X-HE-Tag: 1761720897-368879
X-HE-Meta: U2FsdGVkX1+Q5BApOXHYhEP08NpgxPRCnK+L5pn0k/bINTF5JRbWxCLB6G1cZS/pUhcD7Rp1JCTw2jGPvbFaUwrRJMubC38lLUbiffe94Mzn1lJO3PBZlFytQvlKQvJK7kjI2KE4D2AcvRrGO6RopAUqBkOjCl/gbtNkmVCyg8JVWsi26IHwA1VWZhTv7YpB6fJ5FNMJbP4xqkpX5DspUdUMiteo3KshZK/WZx28UBuOm/oLSB2C4Y8yz7Jjo0qHAThiSQGKh06hknQD03P0qmFuK5SPZnuZEakNbYFfh6A6fWPB7yaZ6z62AlaNZahp5eLDw0SyrZrQEZFfQQzOkpZTYbnqtNeHQwJ+FO4uwcKI9IyTdyHiFeGxdz2er5s046SNZ0auheVyQxnbRW9OGS8y2ilFTvlIXiNXS8IvTF8gKyclwfnb1/MnxyzWMyuwTfYqyH5qQfnjxNa5XJiPNAdXwBFkehCvPu5ijfYwagge949FKzc2BLjjG4YcwikP11LJ16dCaYlLVoKWJaENVy3bWnWx19T7Z9yJ4zF8xohXoTn+SONkgGGCjfzU1oliHaWRbP13psoNX9L3TOiDqOYLhC6im1dfdcp/Du9lG7MglqNN2R6eRL5dIAAeAyZiauxEpJSJa+2G3F9jtkRkVepkk/72iMNY+IW66evGhA3/OO+sU5PjwEXwmjKwpWaOdyxUoWPwcwzBEcpWg+nGDcghaU1Y6MAVqXnskRBKurrCOeF5bYicHMCjZ5TdSCGiPtXbs7hcHC6m+qg0V4QhDq5Fmxl5hXM6EHdvl3Ey17FO32oEL2l8QO+7NNw+q2uV/ak37+RjdsMhVXwzywN6Q5kg6V7rpxwdXuXfcQiugmWrfY6S6TMrKXvqrDid4BfY1qu0ZRxBef0nraSKkph73cA3AysObz3wLO5y6UkuGzlkz/zS4L+MygpidYbznhY8Uq/4VS6uO9V+OMsWNFe
 y0zPK+Cx
 V5MD9hHaNNVNe87Gye3GHc6aw6GhDaE/ZCc7K4yNXCVvXg2Ae+vjuB2taVrcS21oxyzVT5onH1K4y1D69VVV41YWIjZZ1A1aCDkBDpIvi3DcBXzfVyRLwHc5Z6FzuAWSbPPX0WPvRI0c1nnQ5uzcYZMCXYEmkHGotIKzwogGCZpgCjAiWggAKel73vB95gEZJS/0w95v4Xdbx/wYC900K5F8+tHWNQNfqknDR0dMO459fN7UoH/9D9wBdshpNRnQ4eh/9CitkyWcgp1+Tyd/Xd+s1K3Jx+Kaw28/lyu3s4B7Fj4y4JQbcSdONWlfJ8bT0+khcporD4/3Wc9tPPC3Fn5foog8b3lyZ4Si8Hp46N60hgrVcAjmMmR5MQLtFJiPVtJllR0s/b0U+kdd8EBezu3dhYZMGt2NySH+iPuwEj18b7XT2fY20zTNZTYGWcOwVk/PQC655AlPmLqBJDuiF4dBnkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 26, 2025 at 6:12=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> There is no fundamental reason for the int80_landing_pad symbol. If ip
> falls within the vdso, and the vdso is moved, we should change the ip
> accordingly, regardless of mode or location within the vdso. This
> *currently* can only happen on 32 bits, but there isn't any reason not
> to do so generically.
>
> Note that if this is ever possible from a vdso-internal call, then the
> user space stack will also needed to be adjusted (as well as the
> shadow stack, if enabled.) Fortunately this is not currently the case.
>
> At the moment, we don't even consider other threads when moving the
> vdso. The assumption is that it is only used by process freeze/thaw
> for migration, where this is not an issue.
>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> ---
>  arch/x86/entry/vdso/vdso32/system_call.S |  1 -
>  arch/x86/entry/vdso/vma.c                | 16 ++++++----------
>  arch/x86/tools/vdso2c.c                  |  1 -
>  3 files changed, 6 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vd=
so/vdso32/system_call.S
> index 2a15634bbe75..d14eca4403c5 100644
> --- a/arch/x86/entry/vdso/vdso32/system_call.S
> +++ b/arch/x86/entry/vdso/vdso32/system_call.S
> @@ -62,7 +62,6 @@ __kernel_vsyscall:
>
>         /* Enter using int $0x80 */
>         int     $0x80
> -SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)

This is still needed by do_fast_syscall_32().


Brian Gerst

