Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD08AEDF16D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 14:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B9A6B0005; Fri, 13 Feb 2026 09:52:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513F56B0088; Fri, 13 Feb 2026 09:52:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416A66B008A; Fri, 13 Feb 2026 09:52:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32E496B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:52:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D66B213B2BB
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:52:42 +0000 (UTC)
X-FDA: 84439724964.05.49DF0FB
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id D35FA100014
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:52:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DB837Hu4;
	spf=pass (imf14.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770994360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3wCxzBk+1lVwPPx3hpJY6M+kN5vjQjXLSUyhwRtH3k=;
	b=MONZhd/4kG1k7s9mDOusx5pItUT0dujw8C7pfk15hJVHARrXz9NefNQyqv2ewLcYihsddK
	JPV+gYkwouBJPyTVtFB3P9jkTuLk+RBghxumQ28yMpSH4IuglXy4zUncrmcPPjI1inFWCQ
	XhrQg0P8D7O7ZsPzua/cs0wdZsrI9nA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DB837Hu4;
	spf=pass (imf14.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770994360; a=rsa-sha256;
	cv=pass;
	b=Xjp9HQZkmsYjE8ZAqOcsFwpLj5AKPLcDqL5NR6JBle8gv6IHDKTvZyZmJBlwuqPZvWB/5k
	U387LyuE2+WiMT5AY7P1Hu6vYKCqbsabe7r0swaNSWUziRm4dTONz8LyAL2sSr17UzLwws
	BR6u5E4Tc+VOJ8EcrPyxEDNx/BIvV88=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-794fe16d032so9928087b3.3
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:52:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770994360; cv=none;
        d=google.com; s=arc-20240605;
        b=JkWhh86JTZHw3UbcH5+2kwkZgUKwsfNqBw3Vv1S2ytJBsj9AwAVBKv3a5y5qKBCMZu
         u5m2CA7dB7uojKPrNVn+saMsEUuprCcD0+xz2OR4XjZbIi2fAGt2WzcyHGajSjF1GIq8
         TGr/P9FLNr+hKivuyhFLxNZFxf8b5fI8uscihoAKquLDVo0ynspi+FtfiQZ60WlXAs5s
         e48EfroKUo6EZIIeCNA1wIp/NV0rMScdCJz/MoO5RDJ1NfvDU/MjnOJ8fXoaYy1ztuQO
         I3Bn1BIHYOxSku81AiCH2QnWtzp7p8M/TWoQ8o3qz+XCRFsgEndbB5lfvR2JOZ+dSPx3
         20iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E3wCxzBk+1lVwPPx3hpJY6M+kN5vjQjXLSUyhwRtH3k=;
        fh=hVev4GQkYYKyynk46/iwe0q4OGa2JflmkqK8438pxF8=;
        b=fnYqvDFFHBnoseDLyAPCSIruzfXlXROHJCl3fwho3ahGMBaoMcaBLqHRFKCjUSRbN/
         uFVXQuZ2pWkTZaxhS5KV3n4mIR5wHT4x3Car02Nq+lghj8c0Lh9Mvnr2vxGlLm3EmbBT
         mtVe+9JqwnBAIZbYD2XewjnV4Cdp26d4x/2MDAbWOW9nBVAz37keEAwQaBcVIcY2qOOK
         1XQXEj7Ywjg1JwaCi3eVjq31UqaII0wVYevi4gShHlSMjXcztCgrUsVbdKltOT0l9UK3
         UZujs5+uuQ4SdMc9O0jdE8MnPiO5gsaqyNPXInx/LzjeIdPGki6PGwpiVPhR8qOVvOJp
         PGfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770994360; x=1771599160; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3wCxzBk+1lVwPPx3hpJY6M+kN5vjQjXLSUyhwRtH3k=;
        b=DB837Hu4QgClZC20UTcH2Bc+4DMe51lrwS548naNERDZLmuWvhR9bisC/6eHTOxxf5
         VZl9teGciQOh1fDSsuCPHWnng3PHZ8T8Y+Gs0gw4fe21YfQ4YvnN4nyMlUMrpZA9GU/R
         bxgSTCAcY9I88bmiz8CGwRMKaGCXAsTDGbczmZD2aB5OIxjZvfTUcxENS+q0YlSs38QX
         XIZtSu2WX2moA6JLaw/sSBKGf9qeCaaGJUIgdHctspbk2TfYSpp1OUY/GdzT7PBWgYem
         TKCwuM7v/LGSCppdzudm8tsC4TBtiW2kjaxdKJQIdnvElAfz98a2dvvBAcA/kdAfEcvl
         UtRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770994360; x=1771599160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E3wCxzBk+1lVwPPx3hpJY6M+kN5vjQjXLSUyhwRtH3k=;
        b=vTBeCTic2nNiv9ncyEf4iy6Fzr8my7fHVJ65YB6FQHYb5JQ5h5FeC/4kmvxp6FFu4k
         MoIpAsVy4dnS1eKIGnWw8vMJg6T+lRtZnnu0NjIp/VZZT+ppw0LlSp+A+AalgkWeHdEv
         B2YUSk02hPsacRfcssxDpzM5Og/8ck/jN409gRDPDtYAVEcbX1DCt6eYmbEHQWWsKb1D
         C4XzEqchns3RdllyElGGP8dtJ3xNS86/819yycf7BOrw+jdeo4v2MZjwjGHoBtGUbVhn
         RsyemyzoHADh/fKFj0ojr2dFdDwVTzjFX8fuHMoVAqyjQeJJBU6Yd7waaAJUaey9lpGB
         OysA==
X-Forwarded-Encrypted: i=1; AJvYcCVWAAQc+OzJSKa2eXl7sSdSZMm7UAKI9DHqzSmDQ08TafsrQD0mGBL7qYpE8hxMmRS0bLsJdqVsyw==@kvack.org
X-Gm-Message-State: AOJu0Yxqi9WV3hRaboc54Nsicqgilwxl8cEod81L1yBGSGoCX9L3egeX
	56Ih1/J17UhlI6iShET62PFVs/NNjAHRb4Vx3MTRRxCX05qmXf/hoWnLefdp5Y3BYAJYbWPKTCY
	S7dogI1o5HxgqWgoEalEKIcYBjz65/gU=
X-Gm-Gg: AZuq6aIwoIhw1Lwsmrpibll1cZU+0yEDisNfCb148PmcWRhMki0lcfVm8h24KiB2dXz
	e8X0IH7L+uGexy8mnlDUQVIcvXRr2qSZVq+D7hj5xi6NkGSyEtVS2Px+CYT4e9w0lDMX10VHLTI
	bBqvJ9UguC2FELWUN0FmJaHPimSSVG72f8uxRNgtb5VN9JuLI/c0anP5ApC3B2GbKKobX2sLJYr
	7qJ0IkOcTD7KNTTjhsCvwilPHH9e/hFXC1xkHpUGQxASGKWbwHwJNYMsBSWbd28icNSiN+MKDpy
	W++tmSh3
X-Received: by 2002:a05:690c:f08:b0:796:2976:a465 with SMTP id
 00721157ae682-797a0c61f76mr16250597b3.29.1770994359745; Fri, 13 Feb 2026
 06:52:39 -0800 (PST)
MIME-Version: 1.0
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org> <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
 <201fcbb4-c43c-406c-ad54-f2c9301c12b0@kernel.org> <CAOptpSN1_4N=e=_e6bVPWjEN2RUXG5=xJouhCaYjjqjLTCi=Rw@mail.gmail.com>
 <c48511be-047c-4ab1-bd49-f2c4899e3cf5@kernel.org> <CAOptpSPx8-APDtkrobTWrf10L36dRLdDTeZOwob6t6twmdbQ0g@mail.gmail.com>
 <f5f0f666-b9e5-48a1-8e4b-e7647e4103f6@kernel.org>
In-Reply-To: <f5f0f666-b9e5-48a1-8e4b-e7647e4103f6@kernel.org>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Fri, 13 Feb 2026 22:52:28 +0800
X-Gm-Features: AZwV_QjFh_hBIesWneXx_AGXafgFmkb2lL8_tH60Wk2lj6ZVnsRw1UVpkSgrwRM
Message-ID: <CAOptpSPuWb7u+ONYAeqsAOCkheqg5oGW23ARc9D41mnHDAXajA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D35FA100014
X-Stat-Signature: 7uqechc5xbb7811x1ikhsxap8pn9yoap
X-Rspam-User: 
X-HE-Tag: 1770994360-446899
X-HE-Meta: U2FsdGVkX1+/IydJ0IdfU1s/Dzj01GoBwFe41T86LQ1IGSWt0KzKbIvHUsgid9Cm5KNCoVVHBxc8sAba2Ti/JV8b+IMVCnDsz7PQ5zceCl7rUpK7v/R6I+rybHZCjq0fWTHx3y0mZfSJt+ep6VxG6GwQluLs0M10bphevUWH74rxgeDa8aW4FBcJsr6xllLMYWcLFQdETMct4J80g99Z1YZEB8V53T0H8KTeCvLB3XnMp5qJ2tEXf8OHwUhpvX+UZ/V/gaqhsbsS+tNeAubZIXaURutqKAJSaqHEas72HBQ6g5wGpkH7SGQ4e5qMkDMdnl3F43TmxKRADPnBgslmIeG4IsM/YLINe7xiukISRVjAtXTYKREUBJa405nl6NgEzZ8Qmed8UdMQJZ7Pk1RknLnzX/2V0ny94XgXm0wLmpzha2zJnZcmFK7M4V8EvUtcY20ekQWi1hPGLhoIv2n/6n/DE1JTtqlMMlNWO+lOtMMf10Q89m60vRsK34b5QbGR+JoOFkkU46d3ADJ2OCZk8hJjYG3H6ht1wzFD1DwgpsHcsNWawWZCUhG5TVrU78oUlxlyJOYBkcTvDKv6is1sqxT5Ben5izZsCRo3zUUNzgpROr7WksxOWMJZM8TVQDuYPVH8+rOhyusigyz2NQwq6ALWtBSiHBHQ66EsSzaHZQQj5Nd1rxixYtX26tlHqFAwD2Nvckh65bK5P/BsXbdhvMVSBRM1HYohfovoZrjkU2b4PE7NT3FjVYzz8r5hid3Tordd8o0nmgOmhrF5hMB61xuckCpLo4Yv6aGjvYNGlBh/6mwD85pueE/SJQoPUev/d+1uw5ro7ur5nYSihhecudElWCaj06CPg0BKxaSDR6aaMVHxKE/fDTAt9rdKH4DbjFPZfSRyzlC3HB1baYWL2qlcdo8mWPI6yp++oBOUz4ebgeJf1K0u9qT1nTh/RgBLHECqvEBLO5D684Yv1dI
 WBqEMBvA
 IQ/YTIbWwKFzsHMYFlLNaRxd8eg61rJpFx683a8qc90cZ8tqtkYd3wAOaqv5grFbyYfl2iAkjL6WG4KRcrIRDHGujaTbipesfMVoSc9qsKhAUb2h40YfpsHt8VIW36SIA9uCjtqyg0KvrzvNPy9n9yZqoRZ1nHB7uB58ZkA2iayHeCBffjBXA4FCkQUa4seQ8zkG9T89QQY9EE9o1PZorHQMnWkTErVF6AYKHH67/0o21S4ZvRFmXoVMrWH9PWLcY+9gQG5cTn61ojPJzNSe/EtD/wqonwann9CI9a9VdeGwK2jlnxKxyy5CKL4xnj/6m4v/Wb+U2z+4D6RsYeMbn9qFJcQVwiKJbMDrV3o0s9K1aarf7pfm334SqPxFVMPpXdAliJhxy0BUFgtbuFS37Z9V/QxTDsWTeA+2eV8DIjCoBFYFZZV9dY6UhJWG5SX8fzIIFmo4kOa68upUfcGPm+guZzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 5:08=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/13/26 10:02, Wenchao Hao wrote:
> > On Thu, Feb 12, 2026 at 4:54=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 2/12/26 02:57, Wenchao Hao wrote:
> >>> On Wed, Feb 11, 2026 at 5:05=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> Thanks for your explanation. I now understand the design logic.
> >>>
> >>> What I=E2=80=99m proposing is mainly for debugging. After enabling 64=
K large folio
> >>> on Android, we observed increased application memory footprint, espec=
ially
> >>> for anonymous pages.
> >>>
> >>> Since Android app memory usage depends on runtime scenarios, we canno=
t
> >>> confirm if the growth is directly caused by large folio. We want to
> >>> analyze memory
> >>> usage via the `Referenced` field in `/proc/[pid]/smaps`.
> >>
> >> Scanning for zero-filled pages will be much easier and more reliable.
> >> For a debug feature good enough.
> >>
> >> I'm wondering what the best interface for something like that could be=
:
> >> we don't want to make "/proc/[pid]/smaps" slower for all users.
> >>
> >> Maybe we could for debug kernels.
> >>
> >> For example, adding with CONFIG_DEBUG_KERNEL a new entry
> >>
> >>          Anon_Zero:
> >>
> >> counter that just tests whether the page content of an anonymous page =
is
> >> all zeroes could be doable.
> >>
> >
> > Apologies for the delayed reply =E2=80=93 I was just writing a demo to =
verify the
> > approach you mentioned.
> >
> > Using the CONFIG_DEBUG_KERNEL compile-time macro to isolate this featur=
e
> > is indeed an excellent idea.
> >
> > However, in engineering practice, it requires recompiling and
> > replacing the kernel,
> > which can be cumbersome. Could we instead use a dynamic switch to contr=
ol
> > whether scan for zero-filled pages when reading /proc/[pid]/smaps?
>
> Maybe a kernel cmdline option could do?
Kernel command line parameters can meet our requirements.

> Selectively enabling it for some PIDs only is not really possible, but al=
so, maybe it's not really needed.
Yes, it is unnecessary to do that.

By the way, will you send a new patch for this, or shall I take care of it?
Thanks.
>
> --
> Cheers,
>
> David

