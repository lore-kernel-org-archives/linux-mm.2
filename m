Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1082AFF6E85
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 21:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0A06B0088; Tue, 17 Mar 2026 17:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8116B008A; Tue, 17 Mar 2026 17:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497286B0092; Tue, 17 Mar 2026 17:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 332566B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:21:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2C801402F6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:21:21 +0000 (UTC)
X-FDA: 84556825962.07.C5D8CC0
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED10D40006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:21:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OQemsZBn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773782480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsRzA0NcPvaEUlVqi/fGFPQ1iuCRSiuOQoa8upWBzMw=;
	b=hGhJDUds/5VdrHnTUUmk3uhianmvyiH+zJG/sFJxh8nyzuKed0ozyn6sZtU9dL+iOCjdl+
	EpLhh4mEvyTFO70UEzEmdIGq4NZmYRVtjn0w/LS1h8YR49JBtl3JajcdLF0XgPyq5g25ZL
	yF8P43sxJJeSp17inHCnK8izaGgDxvY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773782480; a=rsa-sha256;
	cv=pass;
	b=2uC6InNjuxPltKRUn4xYb0sGHIQ9uVmL3m42UofyisdbgIlIlx0nqF9BZGwOrRCVJ84YJA
	1geqXqV3RsH++7KRo39PhI5aVWAvcSuimx66hffNbV7puhhaVF01aaoCq30bqkxxJFz3KS
	B+/hvNQpjOtg+4fPyd/KBJ9UF+sLSuM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OQemsZBn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2c0bcd8f194so4422255eec.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:21:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773782479; cv=none;
        d=google.com; s=arc-20240605;
        b=UHROusT28banhq2Jx49jCtFWB9L2R9NpOVagq1wkt1FodUfQVfafPwq6lHHfLA5cZv
         gUz0/gNTeq6uvp1dEsUT135Ls7j/+huPSDm9Bcxy/nHLAcl+1yQKpE4x2ML27T0gRmQU
         fE8tcTEBzEpiMN0FqDU8hIMA9XER8I7w4GyzFvK9oDMk7lAjPVElzzcpBYurU9BIzjBQ
         MM3YoWmSB4O5Og9oGBFiYkmFEhXapH7f2Yz0yk2aBxd9bMJRwavre39Si1P/eRO644zy
         UO1ma81UHNn5fQ49RfM2tWXNOQ2WdzI26R8rhzy9ySdClIDTHWM+mcl58xo6HVwvrKUa
         x17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bsRzA0NcPvaEUlVqi/fGFPQ1iuCRSiuOQoa8upWBzMw=;
        fh=a5OATCtqUC/Q5Fk+e6THFquS8P4h40AB3wufTdj9sNw=;
        b=BGUSqnw2xUSFWvDXMr42ixHVSFrxIjHQa4gNj0n5HhVOjLXzOZ58OJkBiQyf+T6/dT
         BmTg8BQBF+vwS2xwmc80uVxF39ump4+pRYIN+483V2JT6uc6XBC1b8p6Pz7px9qojJvX
         mCcVU/+K/l8Dq7+IC/duN9W5JlyQx78X+WYqxmA8Nn91z28yKuwNtn2v1wZeEbHpdcsL
         Mp4M46JsFp27QgCZnCpxxnRaYgrv8hdXOnAWSnypt6ixYk2MVFn9qsa7KggkIkCRfTEM
         MmG/aVjkcHxuGKZ5xE7w19cRJ3qchwqO2JkxEs7Ip1hcrzxgaGzDL8TuMyA2ge0l4uiP
         rn2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773782479; x=1774387279; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsRzA0NcPvaEUlVqi/fGFPQ1iuCRSiuOQoa8upWBzMw=;
        b=OQemsZBnCcMYrkDq5qh/OS7NnBEE5rCmC36oGz7iK9rwSTJ1HwcVrrQttS666pKSUQ
         cbY0+keKWCJX/L6MPUQkMsOLqLdr4vUtf8PFfAoexJE5RnJVbDCZuiuZavRPUUSVBtYN
         Cz/+yR1JNxI1tyK7IUUh4RX9oRF4cFb3uP9p3JOVyP98m4X63ucfVu/aOtugNyRUV7bf
         bI7QgAMh4XlZuy/kxZrEhwnwiR7B7B9iAAJR7CkIayNgGJJYipb6mHGzRReKTwcgWs5c
         8o2yqFU+/YS8wwTtMclnzaf8OI9mllANiWi0DeJNlRWjV5gKbs+5Kmr4p5vMFvxNeoui
         8YBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773782479; x=1774387279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bsRzA0NcPvaEUlVqi/fGFPQ1iuCRSiuOQoa8upWBzMw=;
        b=sdzDEmqKa+QqckXfN3/CBEqssQCyd4CA8lzYc8Mv0kfJf9as2bouGmvxptvOwqy4Vg
         XCTseUFso9qPAxmMhV6nYqmgMRZNtrX4tm2bQUAPcDXX04f2+PJJy0q+borwef7S6Hkb
         +HSTLCdp+v6/SHuIKVDI5ybkZS+bclVTa9XGSWmYEuoQHKMogtpVP5OHzALuSKK5wSPS
         VEA3218BLJDg2b6skcdCp0vnFOtBtGYxpsD/sUERFQtEaHBMr2yhEcUNx0q9XgWiW+a8
         cM6KbQsUyIT2lngs5n7vgbYF4i/84kZxIsu+3Mdc7EbzlfVQEjR6i3enmKsOHxad50Vx
         5m5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFYX0TrOXnw4H809QVMJEIJHy6Ya1zwObCl02+uXY/U9QQ5qPzsHjdWaZZ5T36cFhhpKUyXTVbHA==@kvack.org
X-Gm-Message-State: AOJu0YyFTkwmYexBoATARXl/dTEc0NiB0kHl94kVzSqenaeaq16+38hB
	nXx1jJ7j+9Zc2WcETQA1/WJMZ6pe/Ua8NyDRF1xT9dFM+UZN8ETbMDYfc/7DQaOPmupd47P9Kek
	218aSJDQcy54vRu6TIGnadJqCpIkLUIA=
X-Gm-Gg: ATEYQzz29e4xXJXAMQUFcs9qhqEQyaavMnuZXJJ/GYcTeqL7IO7pUtg5bQomIv8Br3l
	oI1+K1WdwgIkQbRz5dg8PlFBjWOY2TtMRdkigqC39k9uYdmXGIF3iLr4QFXBARm58xfcHvkxnGn
	1GccsKPua1niaAMPIisC1J2yhoP1J50roiOXxO3MU+JhBL9NtAP8CWZNJaJGJVc/7r7r/HB1OiN
	6ilfleZaTvIHdzawojWeazyN+FKiwPWst7jiX4rU/Szvp91JfsqOOAiIIK6/1J0xOGQQMrLWMku
	wXK6OrHVPKk/qbfHed2K+Ymi4us36KSEA3TAcX7C
X-Received: by 2002:a05:7301:658a:b0:2c0:c5e4:6058 with SMTP id
 5a478bee46e88-2c0e50627ccmr520902eec.20.1773782478481; Tue, 17 Mar 2026
 14:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317124528.961ebeaac03f69e65cb767e8@linux-foundation.org> <CAO9r8zPHpfGHaz_crbSwB6hhyLpZ6+L22XjtM9WY=NvC87n9Yg@mail.gmail.com>
In-Reply-To: <CAO9r8zPHpfGHaz_crbSwB6hhyLpZ6+L22XjtM9WY=NvC87n9Yg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 17 Mar 2026 14:21:06 -0700
X-Gm-Features: AaiRm52e4jzLUpa6MtuoQHRTRxid58wgHj_b2yPLYb5e0ITw8k8_r9DXhaYYXtE
Message-ID: <CACpmpocQ4z+5eDOTFAU4JqWOWgcx8jwYd965dBgBquHDuKcRUA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED10D40006
X-Stat-Signature: resqjxdyrasacq13cnrhwtf7z5gt3d4x
X-Rspam-User: 
X-HE-Tag: 1773782479-929628
X-HE-Meta: U2FsdGVkX1/3N8YLvGL0w+PCpSRoCvg2Ipm7qAysQRt5RAl89oFQYE4nZt/QqJkil1L5im05V6GPevj6Xh+T5G1NoE9jE27v3fbJSdzmUoATblQ7yQbLp4wLW9VzEGIhoVEiBSYmMZNaCPYG3jTdvn710D3W3X/O1F4Wi+rm9U06w/NQic3jDOpKcmgH3gAoAOy28YrLyVI+zYkBoSyroORqL8CgwjfYMchGRvfglPVds44To5vrD6xVHcfz6s6zpDaL/s95WKX44lfBHdA15CMif4/SfDX/K9/3oYZMYJNC1zVm2m8fRbBo4H5c9S3JGe75KceYvtjLCWVDytR12Ylpz3XYFILy0AtfLPR2RMRVH59J1p0chdCnwpA7bYZCyk5y2bdZUTpfnCm8FvNFEgQcqHMAfad0aHzUM5oaTejOak7SrNn4EzC1Z+WJHDoVJsDcCJV0YD3fZe0FHATIvu07o2TOk4McmYYPwGYuVMJ9XHxyxUuurVw9z3o7/ZEHYqbL4uE97SXJdVs1XiuI7Za14HYe3JprB1WovUfEKNSOcUWazj2ENdPzDh39llcIh4jTfvnEcPqEVmpqrthWqQTlpaPmY8D/YHMQmHHYncwtGS69kNdki2E0AmtOldsLqCoFurNlkRbwjQSefzSCEKIWibLIva+LmatMx3mElb7eBu2odL6m5Sj77NIoijsG/auiBnxXBqqXm2DtQ60Vf6ELpiPUBORz0W4KVdMKQSli9fZ4klut5om19BdY1o0Tj2ZdqSTWudxgdpZQ4pnbN0qo2601ppSmeZdKY4jGUwIUirtinTBNWDP4VrugLC4DztyrFmogNXLQHX7c5LNndt3NKqiFGnXWcreWEao45TU0LalH1RksUMUQc0ZlzojqK6QIM5lH/4bgayorPZyAM/fAcYYgcn0MIm6Ks2XrmxECYxtdMi3AnDjKWki0kl4JKguqRtxsuTZDXmi3LwT
 9EVAcVyH
 4kA2Qki/RHmg9qoP12ClLtNHOMOMZs1eDGRjzc6OG7gnOCPfD416VoOXhrGAaqP6ALKG+YNDq5AU/VDPMKKYNyzc9N21+Y8kXHetLqawKZEayc297npAxuutk8lK2ocU/3vdmRs2Joo+AsPflKaK2Kw3gQgaxB46yGc5AUdsYOCmIM6B75p4t1IVc3DYYiqOGfFo/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 12:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Tue, Mar 17, 2026 at 12:45=E2=80=AFPM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 16 Mar 2026 18:48:00 -0700 "Kanchana P. Sridhar" <kanchanapsrid=
har2026@gmail.com> wrote:
> >
> > > This patchset first removes redundant checks on the acomp_ctx and its
> > > "req" member in zswap_cpu_comp_dead().
> > >
> > > Next, it persists the zswap pool's per-CPU acomp_ctx resources to
> > > last until the pool is destroyed. It then simplifies the per-CPU
> > > acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
> > >
> > > Code comments added after allocation and before checking to deallocat=
e
> > > the per-CPU acomp_ctx's members, based on expected crypto API return
> > > values and zswap changes this patchset makes.
> > >
> > > Patch 2 is an independent submission of patch 23 from [1], to
> > > facilitate merging.
> >
> > Thanks.
> >
> > What happened with "mm: zswap: Consistently use IS_ERR_OR_NULL() to
> > check acomp_ctx resources"?  Still relevant?
> >
> > https://lkml.kernel.org/r/20260314051632.17931-3-kanchanapsridhar2026@g=
mail.com
>
> We decided to drop it (and patch 1 here kinda sorta takes its place):
> https://lore.kernel.org/all/CACpmpoeo0LhxkoA5Wx6q+9=3D2scn_az0u=3D3bar-Jg=
BvTA-ZBkZg@mail.gmail.com/

Thanks for the clarification, Yosry!

Thanks Andrew, for adding the two patches in v2 to mm-new! Thanks also
for obsoleting the "mm: zswap: Consistently use IS_ERR_OR_NULL() to
check acomp_ctx resources" patch - we decided to replace this with the
"[v2,1/2] mm: zswap: Remove redundant checks in
zswap_cpu_comp_dead().", which makes the acomp_ctx consistency checks
changes in the original mainline code, before refactoring that code
into the new acomp_ctx_free() in "[v2,2/2] mm: zswap: Tie per-CPU
acomp_ctx lifetime to the pool."

Best regards,
Kanchana

