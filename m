Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97975CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E5F6B0088; Tue, 29 Sep 2026 10:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776F56B0095; Tue, 29 Sep 2026 10:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665596B0096; Tue, 29 Sep 2026 10:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3847C6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:15:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57BA8804EC
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:15:19 +0000 (UTC)
X-FDA: 85266997158.02.F419145
Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5CC83140005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:15:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bsJGvAWE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of amir73il@gmail.com designates 74.125.228.97 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790691317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
	b=nlPGIS10Ftft+VQGFaMmag6k9wVl4x+4xCNRntp1lsAUr4jxNS2PoCPA3NPZH0oxW/jwDq
	d/7UZle20XCBsDFyh/SWq2qKixJD6EQWyRZBZWgBvQpPpNZqcBjy/slSISKfN3B5yJOomX
	g/EICXJo6YXxWbpvSH4FcEbBLTcJFVk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bsJGvAWE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of amir73il@gmail.com designates 74.125.228.97 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790691317;
	b=GiK74cOBDo6TIdItTIrW44e4bB29k4GvuufW2B58JzTro+rPWnPsn93kc8Rra6kCiu/2ot
	MDOnrvcXa/dT+YAMxkRdA1EdEPfnoQxp9hsJBB/A7ahsz0A0/4bYjvg3XQelIfxGb6Qb1e
	B4eq7g9f69780Qt9dtadnurNxDVIlFA=
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6abc27842b6so4558346a12.3
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790691316; cv=none;
        d=google.com; s=arc-20260327;
        b=oCUqXpBPe1LWstBwIv7I/43oL2MHiYxxFfolcTAYNp15GoPhoBYSWjlpEABJXVBGEp
         7Pk3Tq2INWRFEODN3VHXV5+RC2W2WvITmu2aAp5/Ot8vH2O+uczlG4OAvVxbNjCiApNp
         lrwZLgNYF110TVVjzBFl9k1r2w9IAI47FZsTmlzg/upaLDoy15BnOnpKS5wMu0zADh/k
         fN4ozRYiA6W+OsC3sA9Vc/q67+R6ALTdkveW5LNghJU5QgyBP6DOCJvo/eX9qkrp9BRP
         PVYMzqVT2cw/Ne0YKIAukfLlAT1B1SG1VswAkeY4EiL/jVR7kgxjfnDuEEr85coca+/c
         0puA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        fh=oiS2FYAWTw43DJgrOQ7CducWTerbZ2yIJ3iw3z9t49Y=;
        b=Yjf85gpwP6ar4Y5RI99VFRgVGzQPOY+gx/f68uRYpEKilMwOZy1UuQkqc0PcTOtFQD
         7AuH0toBm+dUtYj6+gRF9TZuXp8Izrm7EomdmlfNYKhmwL3WWPP1zoQdSINIsNsoXfqF
         9stMrevXBh1u76XEXkDjbYM19OKGtfO3GdnZzyULh9d7iEHYPAmdxyumXWzVKkXrV9gJ
         cVxvezFUl97XeVbh7aWPrJm5dPQIICNcIGYqS9KzyM4krVTtZclbUz7YJXuGqfVwvYeG
         trMk8CXVyqc9c7ItyIJc/2X0ziqBdXqyFx9yBuggrup6yKz0kUx3D2rOoC85MulH/OQ5
         KkrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790691316; x=1791296116; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        b=bsJGvAWE+CsNUeAt5s9A2M5irx9e+UJc20Wqj/XyHxYXzPhNvR3YtrSL24lhzDx+iW
         SKs0WFbcJCduwFh5vu2/bjSbk2QWJtSalfNkdflHsW4WgWj7da8r8UwBSyeMrSe4ACyq
         qFPR4DD2PTAOV0eBF2aVq+z7ohXlRMI1gEGC8QVfQvpTiw14IKDzfHebcMnqIGIswlwl
         MzFEXT1IFx384jEnZiUw6L6a1gKIyCXWKVhE8PNqKe1LTqniP/oKapuuOC8Bh+ZUElyL
         f6dySzDt3FDzyYsNaO8uBRTE/cRwk3HMTtuFpnTZvmTnwibUNmWUqM5vm+iJZDrwsGop
         3GJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790691316; x=1791296116;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trsZq/IgHnE0dFOaiSMsY9WGT+wIu9sqLXFKuCxoh54=;
        b=0p/PEXNb91Vtt0+ecgqtMgS9Gd35IXWHU76JybQiKBl/Fx/sJTatQudaNIobVeQKiW
         5RPuyRyJWtRrwSlfOrEr/9vWGMWoG6vDCRMsYgb92h6ZfiiIjb36NVu9G8qpAV9KRuxI
         xxs7x9Zya9cts+dIGxx2SQhnj0tFlCJSkO03IoMN3qXMKv+56wL+qPRP+Jn/Ahr1YtEn
         35yzh9n9oxeDd1c59+8PnprmG7t36/uh2juqko5k1mnxoLPxLL7FsztVyoczyyxxglgf
         EYCjuGnfLHxSBfs+NXNMHEhViqhwOYEbaYX+gHkfjyy07cJQ0dyX/dZZ3Gk+iULnq0ti
         y9Ww==
X-Forwarded-Encrypted: i=1; AKwUvBy1ErLhAvZmOesGEiaCjNO3P9YVqIRf4dPH6GQ6FXktAHUpHfJYKo4j5GPc6XKllrshPom9EdZM2Q==@kvack.org
X-Gm-Message-State: AFq9FYJvzoY8ajTJ+wejCD3Mo4THJtY4BxnMpdDwekT6VqMe1qVeH4/W
	QP0amp0nKU6g392tqB9NmDPQkQ8+xhrIne41gyJMvKODohEjr5i1gWkvamOJgiR77HM331pr4Z5
	eXWTmGgpQ5DiU+1mrC0GADIZLyQ8Y/rQ=
X-Gm-Gg: AYBFou3zpwFbmD/Y7A3T2t0VdDAIegfNIl6W8vafmDrRBIGBKOK9PdsbLP4jhtayUMj
	iJ2cPXuDM2bNmkBxe57EQZSgnU7p6Y9f5jHCIik7sVUQp5KyW7HLf4Sg6lU6bl24U0SjQK2vNqk
	WHc5pRmrWu7iNGuD0xLX9AMgtJiBI0Yf7CKiMOMuswbw2Obf6Q325l0Tc2IK3iShCsiSzK0i+gM
	dHNNyr3KioZQmYs/6Cs2kAiRkXPnxKhY9DxYvPd8gxpNkQaVURlE9HdImLbJOCwGol3AglVN/dp
	EU/bpzjxmDJMmwa0YpZqQ51E8TF6I7Rw8dyLyKls8HL9TZPYJP3dtbAp
X-Received: by 2002:a05:6402:380a:b0:6ac:bd84:2b84 with SMTP id
 4fb4d7f45d1cf-6acbd843b1fmr1090820a12.34.1790691315590; Tue, 29 Sep 2026
 07:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260928213155.2612039-1-krisman@suse.de> <20260928213155.2612039-5-krisman@suse.de>
In-Reply-To: <20260928213155.2612039-5-krisman@suse.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 Sep 2026 16:15:04 +0200
X-Gm-Features: AclHuK8ytKjl4O38jVPReRqXBMm8kcLwbRELyjNeXdrdxLC7F0LMOcN0dvJ9ryk
Message-ID: <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>, Hugh Dickins <hughd@google.com>, 
	Daniel Tang <danielzgtg.opensource@gmail.com>, linux-ext4@vger.kernel.org, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-mm@kvack.org, 
	Chuck Lever <cel@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4961wekf87qwnjjga4ffaifjz1xi8j9n
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CC83140005
X-HE-Tag: 1790691317-604121
X-HE-Meta: U2FsdGVkX1+ay/1L7pWbcVuM2gGYePoyz/AZ1zW09GptZUZ7RrwukDHfeTZIPvOLlRkQU6eRZjUCDuOfqHROzh7sEuJqyixNiN3Se+nke/X4m+K1h72iA4j98BO5NNeI5fHF1aGfKFqTZ2zsQvw3pr7olr7hweFjIlBT11fWnkUxy630qtWvYQGDogfnPEqYtnrpS8JTBV9KYm/fbTfdcXnuqYU+wPYqp4Xt7+cLCfRQEGiSDiwpukY8PRPIPtMnOc3pWKXL/T2ggANCogeaOYK3jqN5d89Pngi25zVxeqD2EcYw1CqDQoUljH1swLuLgWn3E+YIW5y4snl25tivT6Yr7y/BKigDlJEn/4QtDLT9hwXO202iDRfkhRlRa4Dmz3wAxHP0cCM+pOWPj5V0BF8DAV1dnSNLaaf3B2ZDSgHdZ5aMHeOMsE5skE5tX01LuoQ+QV30pj+Nw0dRk5EhfgRN6orWDzFtQb7Athtq2bscoYdATEPpg0+vVhkfWA+FXdgJ1Ctjkj/o+y9cTDmUCm4Hb40g7piWU1CKg6gIX9zUKtRsAMaGf8GwxTZtFPRPZF+SLiam5HoeAHxciempujTWz0pj9FZX5XDXXqhhGqY/cTUd4nG5VrBL28fB+WFK1Zdx3JYnezgzOODDDscWGevOKsIopqDnAQtEXmHqyk45oM2GTSxAw6tQDTm3r8wXziTVywgb+eeZ4iT4PvaSmncRDPoK0KgeN0B3eF4XlWD15Lg5U10UxzdyqKSBvHD8im1/u+k+6TTpKnPgjP6XmK0k/JClJ60hcGhttw40ayn5Fn/7FBb0O6BMNF/gAzCsibngOGUG2LFlH+6HlCpUUHAMfdgKEuF7KJZChgmccNculJRiNM/nZmRaCHIZlMdqDwbS7yVnwYGRrflpFf4BAb2x14dDtMoGqU+RcjUTCFY9xO3inR3lHvovzzOX8ccHSz1kQ0/0Sj3T0yIKE35
 LCIohT3G
 O0iq9s6MzYY1iZqTjyon4uVuRXOdCzb9eQX6kXh5bYfaEDx39O0wLiMDZZjpfyoez+4mPCmSaHSCqE4uAUB3hgk88ttOR7dI77zWSTZ4IPdBnb3qkYCYTE7mogzEh4N0cWHPKQduuLiQcwEo0BkLP4AuJwBkxFUG73VPalCErFyjHMqbPi4uJvLnndCah5J5TJNSpb0BN0CfYfwRq/W/ZT2/cyleyoK/4b6+1rEtYi9cEIL92Kfvofx2vXM3VApJXwcoizOJ/EYRbFK0m9VMNWU3RsxdVMK4hQEJaxGEO7Bskk+18M/hKqZpQ0upoDovT/S743ISbMq02dlWehOmgMfP1D3ErjmxzOHwN3GZ7qwWRO3uAc0obqYl8ucO8wKI1jhPBh3rW0Ke61V8BGJ5xAbcxgztrqaJXOgNRRoTHULDBQzkB8tovgCJJsGtvUQFClvv0zY5weJSIp07Gq+iV3xR1bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 11:32=E2=80=AFPM Gabriel Krisman Bertazi
<krisman@suse.de> wrote:
>
> This patch reproduces the same interface from ext4/f2fs to have feature
> parity, so users don't need to rely on parsing dmesg or trying +F on a
> temporary directory just to check for support.  Note there is no
> encoding_flags file, as none are supported by ovl.
>

Gabriel,

I am not ok with this API.
It is wrong in several ways.
It is not generic, we have already file_getattr() to get casefold status.
There was a suggestion by Pali [1] to get the supported xflags - statx styl=
e,
which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.
In Chuck's v2 [2] FILEATTR_CASEFOLD_TYPE was already suggested
as an extension to file_getattr(). I think we can still do that if we inclu=
de
proper versioning in the casefold type.

TBH, I don't think anyone requested this - you only mentioned
the need to know if tmpfs was mounted with casefold on and that
doesn't mean that etx4/ovl patches are justified, but ext4 can decide
for themselves.

The point is that this sysfs is not going to be the standard for all the
fs that can return the FS_XFLAG_CASEFOLD, so I see no reason
to add this sysfs interface to ovl.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@kerne=
l.org/
[2] https://lore.kernel.org/linux-fsdevel/20251211152116.480799-2-cel@kerne=
l.org/

