Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE196CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A172800D2; Mon, 27 Oct 2025 20:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45248800C9; Mon, 27 Oct 2025 20:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36859800D2; Mon, 27 Oct 2025 20:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23D9E800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:04:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0893C02B9
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:04:10 +0000 (UTC)
X-FDA: 84045575460.26.EDA88A7
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id C27424000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:04:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cFUDHny7;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761609848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhN/mHl/kffEeTqvKgtwVLeIzEoh4/retLUYk0OesL8=;
	b=PJsin5paU7ZGIGYWlCv3vKPPV3/Nu22ukEmS2DL1k3MH7hCJXMWIUretWHJj2aNSpRIKRr
	9XpRCTVzivwckJpJTIdKLI3VjkLs9ziU3GLLCmh5I1ELx+O3aR+oqZLf6s4nsW246cefcR
	zp3Y4ixtALgMdke3FnP48f3mFhZKCKk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761609848; a=rsa-sha256;
	cv=none;
	b=QQaQs6w7Lc3OqLpNQ8+GaMh7g15BBL8gsc8P3yFewt4gamFjlrw8iDEAWGpqDndvRAlUkq
	wBvXqx/tRECGPvW5WEpLkbYEVvvUqkPoTDIKJD4fdwSbvTIMbSXfbvb+7/ZcyGT9309QsM
	r0bZQCRki9ddOIL8oELcCgj3mZFpp6o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cFUDHny7;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6399328ff1fso9085494a12.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761609847; x=1762214647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HhN/mHl/kffEeTqvKgtwVLeIzEoh4/retLUYk0OesL8=;
        b=cFUDHny7owmf14+on3XbfqgC9GPQvfQrZArdkUAAi1vGjXCnE4fY8M5w7+qa8ls+nW
         AUd7YW4Fwc/36Qsf0Be7ZMpzn67VY+FbFwM1xi+Rs4RMUgHeNrgzRpfdw6cFjh7cdyWO
         P5tNyyGO1TVIZLTQ4WO5lJnOyDsUScC4djcpsT1IhyEk/G8BkcZNponnK6FY/2jRydlk
         ClCUodD/Q1ub/8qgnjrz/hzByXAhqWKpCTTyZ53ojgbAhUZNH9cIUhkE2zYIvv/+j/g0
         zzzeA3L/os9dYipKMtbVLc17KEymI4kQ6I1M43KMmzoNqcoKFAxw7gH5IMNONFuW3z/b
         ZIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761609847; x=1762214647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HhN/mHl/kffEeTqvKgtwVLeIzEoh4/retLUYk0OesL8=;
        b=Ai5LFfSehoGWZl6lvE26N2/Cdip5i2+WSfemR8X1jz80CK2H9nRoQhPtAtieP2OtUf
         TcEmrx/Jw1ZpnP0ozeUKtN1bIZ2VytacPfl2UtZFSKL826x19ZcsyUoTROonZzxr3/gT
         3Y6+qvhwmV/6/wytcoCAVkRuRTCU0cr1tCLIdCEXbOBMqF+PBrLILvhp1MUkZW6FXEev
         ZEDnsBGKsrHsKQwr+TLalbO5CzBPAFPTGN9+/jBqlDdZU6eQf6SOIpqO9V820eKov/iq
         +aiPY7oyP9JwXLcYK62WK3bZcSYmA6/D0A1jFyGsrZysja9sPhu+CZP5B2ntUW2rnZ2t
         idUw==
X-Forwarded-Encrypted: i=1; AJvYcCXr8qs554qLvgLEioiMuNT2zpApNF5ScikcrzazlLJoPo7frSlKUHcneovfHqSSWlp7MyYeosY1yQ==@kvack.org
X-Gm-Message-State: AOJu0YwLw2zohVuhZiijcBb8+XuH0K76tYHExUEY9KOpFOT0uQyZNoNw
	VRt1Fj+TqDI0lImMJC3/9ytELQWmd6X/IYOr5mcUttNrnw0EC6PZLalgcX04B2BiR78hLhrwGf8
	Am9tEj7MjcDxUudU78HfPTdPDxIFYrkWBzACox47yNQ==
X-Gm-Gg: ASbGncu82F477f7Pp/v1oNtu6ChcePdI+61cl8ECsSnVxCarchAGBYIYn2MLkCpcM1t
	yafJMUH6wVGiWUBl1LMaCAx4CPqytjVi0IWOhMJoFEcIxPKyGgeIhPsuxGo7odJavvoSpnTiRP3
	6ZrTgf8HJNsGpk1ZifmGURwQbrOd8Di+9eYrCpLlfiemuAbNl9mMCTZeazN/LjOcLAC6q8rLs5U
	j8U2YsoLZbVw/GuORPTD93v49QGbzo2UvC1KNDGoYLfg9/elr4c/6pSPg==
X-Google-Smtp-Source: AGHT+IFTSxT5C/qi2iJ4dW36Q64XxwPLdzowo6gGddt58jWhCVpKXMJqTgXpnFO8ktQqxcCj5WA5879rgg3vpN1c4fs=
X-Received: by 2002:a05:6402:50c8:b0:634:b4cb:c892 with SMTP id
 4fb4d7f45d1cf-63ed82613ecmr1478635a12.32.1761609847331; Mon, 27 Oct 2025
 17:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <20251021000852.2924827-4-pasha.tatashin@soleen.com> <CALzav=fa0rxnf-ufDmV0uhA+zhoOB2vp9ksfNpeE0amxnLt0jw@mail.gmail.com>
In-Reply-To: <CALzav=fa0rxnf-ufDmV0uhA+zhoOB2vp9ksfNpeE0amxnLt0jw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 27 Oct 2025 20:03:29 -0400
X-Gm-Features: AWmQ_bn-zfKJHiglHnpNE8yXm_PQCrs_rUjFkmbehJKOvSAt70K516WwkjY9HeI
Message-ID: <CA+CK2bAE5A4rvgxNzJbmdcTHWJ6LiyoQ5v8uMbTH4p6YxxToTg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] liveupdate: kho: allocate metadata directly from
 the buddy allocator
To: David Matlack <dmatlack@google.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: rhfuttir391u6k6heo3cib3u5knc81xu
X-Rspam-User: 
X-Rspamd-Queue-Id: C27424000B
X-HE-Tag: 1761609848-348127
X-HE-Meta: U2FsdGVkX19O0QRxOLbK3GwIqzj/cuSxJP3uCeGdLQkQwtlbBMHXWAOFYT3Lg50HY8Aqr+rKYCu4UMaRM9lwueKJ2Ub1JpW/ZUodMuAetV3sIRCdtb83vYxa6gJtDjXYpSQfvWd4ClSvrpLlBpvO8bwflz1CgV6KIgzi9hbbSesDTfbrDoloTix0YJLE5YwRw3ZGq7GI3MfgTBr6jCxRagAiHgvLYQPsfoAXLM08j+9rC7oqsLn09U9JUrmifX17bib1sJlKRYrw270C9llbrY7McTBP0QuzbwF1p4VPBdBoC4kFgnbCXPfkmKiXeIAGuRq/jZUk8Q34nyj9wxABTL37EEjBoJHB1JNipRU/Xd317RkmJabFQS4bE8n5FJvetRW7SbG+yPIUtk9JAhYlVBseko8RKAjC2CCyn5c64f82qjOKLeIO/ImPOmhGimxhxe2V+cOwgWBqa2koi3n/l+hoNqSNLH3HdjYL/7umtBeQoqJTTooAMVgFtA8GGT0z0eCaxRUjY8T/opyT4djJLo3/LXvmU6bX/NRjV3R6W3Bz1pbtlDaqxFkaiggWL/l+IDpVuXFjxZIHrHuBb32mA9KvezU7f04V+X83P+O15xpEsFEBSyHGMWjFqeODr0gCUMiFwAAZR3jA8DnWMPEyYARyLDWdzo1Y/VYeWcUDCqIdZlUCs9TQPKpPGlxtnxAD2x86I9EvO4SXd2MlMfxqiEK0wu8ccKX+SAtFrArA/PbMTbzZzXMCVgdkSA8FG2JEjsFyK249dgeb3Y8czkE9hCNyx7YW8Tbx2E0lKGs/8OjNHqcALshZfKahpdZw2BkZfIWobDSUknvvuHeiDA7AyfuVJI96VvMxSjIgvrtC73H8+xy0CVp+FkcsTvspUOwmxab0YFWlvGGFNjPsSDBFfs96mxX10cKqOjFzDDFpYF7+TM69muiVo+nltHbV2pqaYuiYzUnoxFADPUy9x1D
 9dyvEMjI
 Zh91MSo95d1DzqWyCkmNhZC23Ona3tkKZ7mNgc2fxV22m4Fd0QZztr4StdjNEButv1i0O3FP/+PxWDVE3LoSxz+k+d6DD/mz8a4ppFj4Bo4dRymoV+30/l6pJPTHEDWWpNL1S5cmkdHP/buhjQIbT353fd9XRAquwMdFWhuxVMvZkWXD/V1H3dWlDxwyoiNpgnTfLFBJq5fIiMnDoXaFsTgUZySMJxaKR4ECKcCqQ03HY/Nh1e7qot/zBsN4Yf2RXug4Ys3GdHBP3EdOJNaS33rACZQs6nA+WxowaDtdqVnBqHmQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 7:05=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Oct 20, 2025 at 5:09=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > KHO allocates metadata for its preserved memory map using the slab
> > allocator via kzalloc(). This metadata is temporary and is used by the
> > next kernel during early boot to find preserved memory.
> >
> > A problem arises when KFENCE is enabled. kzalloc() calls can be
> > randomly intercepted by kfence_alloc(), which services the allocation
> > from a dedicated KFENCE memory pool. This pool is allocated early in
> > boot via memblock.
> >
> > When booting via KHO, the memblock allocator is restricted to a "scratc=
h
> > area", forcing the KFENCE pool to be allocated within it. This creates =
a
> > conflict, as the scratch area is expected to be ephemeral and
> > overwriteable by a subsequent kexec. If KHO metadata is placed in this
> > KFENCE pool, it leads to memory corruption when the next kernel is
> > loaded.
> >
> > To fix this, modify KHO to allocate its metadata directly from the budd=
y
> > allocator instead of slab.
> >
> > Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation=
")
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>
> Reviewed-by: David Matlack <dmatlack@google.com>

Thank you,
Pasha

