Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5C2D3CCAD
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E376B008A; Wed, 14 Jan 2026 22:57:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C88E6B008C; Wed, 14 Jan 2026 22:57:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D80B6B0092; Wed, 14 Jan 2026 22:57:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18EBD6B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:57:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B33A11AE45
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:57:29 +0000 (UTC)
X-FDA: 84332838618.17.1F99C85
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id A1B5540008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:57:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k44PudGZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768449447; a=rsa-sha256;
	cv=pass;
	b=bDu33Ja4P+yH1P+MEAzrRdEUytiL2S1bE4lII6TQzB8EFlKcsE7tQVYEhv2G73YhZX1Mb5
	/wcur02t6SeRC2661GToW+8hxgP+6Rfk7ijmMdHVaRk73D4sA35ASwsWVgCaj4Rx/spfzY
	jQn6RGABSm37683GSAmt1YLAws+hrGE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k44PudGZ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768449447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF8ykdDUqJ0kZqPReApJ7+RcoAo4qkCvnJ+8HSR43WM=;
	b=npUqi8KbTdMeRW++Xaqj64gpY4q/6KChgCEcPRroMsZgG+qjCAJXSMrZqK07AzQL4r/ILx
	bJ1Trvp4UZgnjoGVi3uXFh4lM66Y9GwE/LCtTQbZ0ePBW4MzJJb7dVQOBQCwVwhzF7GYOw
	t/0bZVT7P4ZV+u4iXdr/U8WLTMYEfrQ=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so349686f8f.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:57:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768449446; cv=none;
        d=google.com; s=arc-20240605;
        b=N1t2JKjazVJ8m1DK2/8ab4YbLftvqIVYGza7jSh/b4BJrcxoY8c5xCAEm8ur7KWrOY
         N4pTfwy6z5XSdlqq119j785DQiDN2YYxTYU4F8mFobORx67HmQqdxQ1WrWoYyNPoYhE0
         S/X+vs94/9qIbg+WbBPIU9byN/daVDaBRgXe7737hDan1628Tthc9GXY7FqDG6FzFqbi
         aupC/mfangipKpH2dyyDcaP8N58/2B5lu7Dj5c2f3R/tPpcv7TzYDgqjLJa72QW3VQWg
         /awI4zhfQPSFCVqhs5VQi089K4tm6M5irsmjiFvvw8qVf2xiG/qiUl35lDM0DY/1wFdy
         UV/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dF8ykdDUqJ0kZqPReApJ7+RcoAo4qkCvnJ+8HSR43WM=;
        fh=14eRJf6ZH7rN+XMzVXkSzxPQJ7h2/EAuLtxyOjuyVYg=;
        b=J6Iu8rWNlUOirmN7bZKVN70fVAf+Uy3g3LrnkAa5P9/dNKVHeUTZzkwZmZPBUGeOFn
         TFbELSM3GVc6+bG7V/KNh9K9gDV94Jy1MblMMSmsQUlqc0zToI4arJIToJ5IPpHRWYTi
         6f3LDtJ2+OU5YiJ6RfCOkmiE8fLOipqHKh4sGF6CMeKasaxMygG/gyAfuVT+ZVMKmf/u
         b9eyorPDNUSOWZnKLTGgJXY+tk478dQGKSwRWuS8hZ2gml4C0Z0rIkOla0gJk/PvmgZS
         PWcoFjvOneZj6k0fTOczGojyaInmM+RCNmDgQolXAC2XLIhryk1RGpDYtnFq9SN/XaUH
         PjZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768449446; x=1769054246; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dF8ykdDUqJ0kZqPReApJ7+RcoAo4qkCvnJ+8HSR43WM=;
        b=k44PudGZ/DH4B4mGJ17G4D5TQIyvbzX5xTuPZyeKzTVrU4nQrOPfbSigKnFRFO9+9z
         ymuYxApsHzYcvimpXzdzfEoXIcrMXS3lK8Wcsop5ptMUIdaoOa2GL48xPSrR2u0sHr7g
         7/4ZN2FQSoPvg3KxiNa8Hlrl1VhFarePmcZZ1+JuDllsG+orzODxMye/M5C5dTwP29+f
         1Iwn4KnlBe9wrEueVDNtmpzqzwXybeJGg/jjaiSnX9tASGZ6V02OXE9+GcsZb1ZtH3Dq
         ThdieZv26kizEET2sahrDMsFXyMjF7GQ2055RqvEwp+mcAKV06IrcgSYbspHD6Gyicu1
         lULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768449446; x=1769054246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dF8ykdDUqJ0kZqPReApJ7+RcoAo4qkCvnJ+8HSR43WM=;
        b=GtQlHslM3AqEzGklOMtcVWbxuk2YGRMjqaqnYcqv3V033+TL9EUY/QIP+l4P66tUiX
         MqmAWj1qn8qf/+3DyBHv6HSiDomolgv9XANimKvrw0mq/vXYwVp5fzAARLvAdqqJQ+1d
         BQJwWQ4YaRLqd3oF02lSAWNj1fZbIals/t0aZ4coYRJt9MDKJnL9NRPkMYUjT7SpKpZI
         zWSipGW4s4nB2oKuTCmbqZfm9Q/Voos9GnK+WxEaFJB7ypiny7CM3teflXF1BLPIxey5
         1L/wIm9W+UumPJwnGMqDvlDiMik0Y42POovwu9ylEZ8xG7v+1ZQ+ihnoowmBO/PgwFhl
         EGug==
X-Forwarded-Encrypted: i=1; AJvYcCUbzYRy8EIKGRPmaKpMEbV/0gKu0z4dmUwcQHXwp26LgYFHqeRdkW8qHImtv0xVSJ8XvQYjsfpYDw==@kvack.org
X-Gm-Message-State: AOJu0Yy4qox+cNr3XHCT4+jE5zMXEMtpPiucttIo8ddDfaVm3LO7JNKj
	DUWiBJGQRG22795+d1OpCNy9ewV6Lpy1DSm81ovfQXRcU44+6tCXlGqFVzBtCLftrz9gnPiEZvu
	DTpOwQN2Y46RiKA/sHELnbVrFuXcciOE=
X-Gm-Gg: AY/fxX4SV2H5lzH8Qw3otFIbKQqoGelwuw/EsEBaEdnem2E4yjJyjIdt7PK3CuHT2hM
	XELPvLugg3wX2+ZvvEbPHd2o95T9TOJV4MmyklZCInqmpVmrhf1Bec28Nq1iqj5pHUTUzmOp7IN
	xRXV0kgcRczLM3eHvaVMusL2IxIoS9/lgf+r70NXR6Mf6nTng5/xcJFlKAri2DN1tb/QVpZcfJl
	xhyPb7YkcUxbW+zEz3w67QZz6MdJ2ZCKeM6d27BpLflFF7oFXa3sqsKnOGffH1ki0XA2wSRQ1jq
	BsmvxtqaPyCcj4dgmhKq0ctqHXZ7ag==
X-Received: by 2002:a05:6000:1448:b0:430:f742:fbb8 with SMTP id
 ffacd0b85a97d-4342c50132emr5549030f8f.21.1768449446128; Wed, 14 Jan 2026
 19:57:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <b1dcc32aa58fd94196885842e0e7f7501182a7c4.1768233085.git.m.wieczorretman@pm.me>
 <CA+fCnZd+ANJ2w4R7ww7GTM=92UGGFKpaL1h56iRMN2Lr14QN5w@mail.gmail.com> <aWfDiNl9-9bVrc7U@wieczorr-mobl1.localdomain>
In-Reply-To: <aWfDiNl9-9bVrc7U@wieczorr-mobl1.localdomain>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 15 Jan 2026 04:57:15 +0100
X-Gm-Features: AZwV_QhDwJPvCo2WidVMEEygaFIr8dW0DNnDeWkqySsg7Bs1utl1YydiVNaZwUw
Message-ID: <CA+fCnZd4rJvKzdMPmpYmNSto_dbJ_v6fdNYv-13_vC2+bu-4bg@mail.gmail.com>
Subject: Re: [PATCH v8 13/14] x86/kasan: Logical bit shift for kasan_mem_to_shadow
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A1B5540008
X-Stat-Signature: 36391186c45e65kjuzyc6jamqp694u69
X-Rspam-User: 
X-HE-Tag: 1768449447-790701
X-HE-Meta: U2FsdGVkX19TIK9k/DMTkrtaPnvhUoc4sogZ/ypfN4R+4pDTId6m514rkXDpv6wHEKKb5rm2dQJCO2l0tP3XjUKv6nPD50+jCOLwgln5PB6Xw2V60BVbkavPPdHwbRYf+6iAkCSSipamDl+Sf5FidZW6teSUxKWiOF4aLRW7oHvsYmIPoIBXUQf+qOD3tyBuei8eHIi8zBAib5/Y5QK6s3oyOStwDkJ4eEATMxYRpEqaiTAe8U32ehAKXkKybYO8Tiy1+oS7iTt3hGjL3U6x+RuZL1szbMRC5FUMshMonU52xX8nrQrSL2RRWlQEIMsjPBxoOjsjjwtaCqK/qcbB/fxdgI76PUoZhrBqslcu4bzSzQ1DwtUm/K+xdhljf1j0eDdiYOd2fTnBFqnrnIoM0gTQcdXNbaDYOfDVRDArZrvDG8Sg6nymym7sUKQORzH9NxcPV+EZlx5Y2CUJLwNsw3ewZBsAxHj1MpWcQxH1qMtAUpoBLEqBFjnsh5NdqEhbnTTlNH1grLtGqh/KpMqmA1K63n935fSCvaRoTiK7fK9aLaNjCiLEtMh5a3dS1GH9Clo1Nq6FlXW4ajXLB8vZX5KVwHbw0sbdiAEIii2Ce2mRFoj7umdKlA+eZ9AndseQcwnTgb04lY0p5rYebeH4oUF+snJvqXyXmIlr4w7p06ujlZWJQRhyJ0iJz09xF0QbVu+goQ0SghWFycFLXXkzzbR0jScb1f1oyWzQZ79E+Xwr+wrJFBptA4+h56VakV+tONboOStdcwtrvnyqAwUs6G2f1/TxFh547rcmCVz9rQzzuXyBfgdL9GXomA+5GOELYFut5PuDq5Dopt14c4avki8EsTiP6ObjBf7VcCKhsfrKTl01fN3+L+S88Qv+YN1V6QzPqfZtJ5NPngIyHrsrJq36iin3bkX4GOm9ERjHeYpuFOF9KtxWDRkXDqWQCIn6wZSGY8BST4Mrtv3v2rl
 KVse1HNQ
 GTjmAvFaLnan77cXG56tJVbkcZm+ZvEGaST8VAR2eibdbJmPauRnwJwIlGg4X3XaDZ8NaV7v0uTm/OgLr+4jNMTd//7fHnHiCCDOjYAFD2QigrJec+zSClnd3AuZtQmdXtuCJ9buwOC9QqfqFJpyBPcpZVqRVJnB9kwnl/mklHsgigN1RBUqXHKVnJJ2imSx8/icUj4BE7rqDDGUxucnJ9+Q8SXk1OTUKt6fA/9JbWxAQoeBIQTarPy5hs5mz7ZpiHMngkpW4LCU51brlvJxXex6RCRpNYZjTVWy+Tpueaw2g14pLdfV+HNgWKExgFhTmmsnv6HG5xxtaSsaqwrwWPKFBiGHvD4SizyaG3wbnJHSQPmxmI479u8bLbdn9aWRh5u0qEuDCsnj0blVRLFr1d86oAxp+6zYWb+N1U0SqMENpfQWmAu6wyBVuHNznRINqndnhv44ES7d9CBVjauyGkg+RBEo1TSttvb3FBUoNS87C3eBahlKZF0yGI169cQJpZAdy+yQ6iuAU1uv2dZW1ohjlZdEP9z4KgZDH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 5:52=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> I'm a fan of trying to keep as much arch code in the arch directories.
>
> How about before putting a call here instead like:
>
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
>                 if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0U=
LL)) ||
>                     addr > (unsigned long)kasan_mem_to_shadow((void *)(~0=
ULL)))
>                         return;
>         }
>
>         arch_kasan_non_canonical_hook()
> There would be the generic non-arch part above (and anything shared that =
might
> make sense here in the future) and all the arch related code would be hid=
den in
> the per-arch helper.
>
> So then we could move the part below:
>         if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) && IS_ENABLED(CONFIG_ARM64))=
 {
>                 if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0x=
FFULL << 56)) ||
>                     addr > (unsigned long)kasan_mem_to_shadow((void *)(~0=
ULL)))
>                         return;
>         }
> to /arch/arm64.
>
> For x86 we'd need to duplicate the generic part into
> arch_kasan_non_canonical_hook() call in /arch/x86. That seems quiet tidy =
to me,
> granted the duplication isn't great but it would keep the non-arch part a=
s
> shared as possible. What do you think?

Sounds good to me too, thanks!

