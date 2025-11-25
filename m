Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB59CCFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 09:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7986B002B; Tue, 25 Nov 2025 04:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F8E6B002C; Tue, 25 Nov 2025 04:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7066B002E; Tue, 25 Nov 2025 04:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD6396B002B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:30:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C25928A2E1
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:30:07 +0000 (UTC)
X-FDA: 84148608054.28.FBBD2EE
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id E70FD1C000E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:30:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KLJqVV+k;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764063005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZGxoQ7uPBKyg8xEtvM7C9Hd7crWd02epgAD4b/L7dQ=;
	b=XwhgVazBUAgLr5mhEx3WxZpY5w4L7ZM+FIlx59uFn8eGI6L4R3qbdGUoBCP7puumLmxKNu
	OGHHZaDCzIVJyQ9LguKfvoOz10MLBTW/nf7vxKFtAgHZvmVzJlcDWQtKOkgq2Zw28lHIXD
	kCoYHIzGwYL67X7SZubyekpHXCMV7NQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KLJqVV+k;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764063005; a=rsa-sha256;
	cv=none;
	b=LaMNqSuGjaQXxK1NYhl488Y4WMF5Ll0iO57YjSrRJxbivdFieayHVg85P0x0cY5q5s7PNu
	S0er6MNzt/Ocx286MU2ZTwoP1AKCCepJGQnW+StBe7tOJRPLnH0k3RltIOelEntvxclecD
	klYSbvU+TfIaqRRuceejO/Uur7VAm0s=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8a479c772cfso329399885a.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764063005; x=1764667805; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LZGxoQ7uPBKyg8xEtvM7C9Hd7crWd02epgAD4b/L7dQ=;
        b=KLJqVV+kKD3tF2HXGCsYUXzKLNOZbhwWBfhvd+11+Khu7IP7pfA08XvkK377Mpoa52
         UcbrjcZFIxBQey1DpkGSWf9fb9yZ66Hkshusn/btdHb1ZdW13vvXYWtooeHrKj0vg22j
         PR2xc5ErVlj/jtvS4OqEs+QT31+pnmi5JaF2HlhdqwAsfzhsKPbaVzTaVBeoRcZpUYos
         4Yf+hjz54lLWJAjqAyVY5i18jqavFtcc8X4TxGoseepqkrUqrjq935HaeswdAwhliR5X
         /kWo5o6r0rWiJTPZ1FFi1OOmyaKOmkgbgpOYbtyYyZK/3YRR/PVEDSpNYrSBPgC1t595
         7x2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764063005; x=1764667805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LZGxoQ7uPBKyg8xEtvM7C9Hd7crWd02epgAD4b/L7dQ=;
        b=HQ1pHWKOSHn7CAlPZh6td3Eux2PiOu1NeAgxHjtB89KHouMphT5+7qule44hjZGylh
         OZsUpSbQ2DUCx091+jx0YBnoAF9Xrskpq9ht85OlzUdeXJyqUAHlj7nDSGEKOEDHDlda
         02vEEFvSRqrbwj71hUT0IYh0LZQmD2kxgKAoqQIIsNLwAtbhaJqaS6hL5vZN4Tv2Y1X3
         yGqdZ07jIuljts3dNFQ406pnMylfeCmdwsbkBxgL2j6nHRSuYorHqYpautnBlZuF/GZB
         nTvvAV2LedBO4x8KL+R3gjs9XdCVylZ/CgMEtkbmJFqI+2SEHTZ82tK0Sur2oJ5QrSye
         m3Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWAAwl+Sn+hPNQ06PENZ/SxQ1fIPetWRPnYNUw89SXW55gNhZvvIqqR9md9WZ1E04Sk7Bv+oEI9bA==@kvack.org
X-Gm-Message-State: AOJu0Yxkietdb8cnpEnJq/ibf6oCd77PiWpDuKnD8Fq6LZtsiVlpx3Gm
	K85l5F+KBiS4FueEeummstcMiusQSpzuC8iP4SWM+XzpAgX79T8md4CNXSuPLkqDcz1esm0eRNy
	yZbrWa6Xh0NLxwUyZApCgGn0SQH5RcIc=
X-Gm-Gg: ASbGncu7Bcw0Jac8W1qu0fGkKbk7sC1YaOd11ejmmySL9aKoDM1/09oPPn3fyR/1u7M
	6g/yU7nVURouphPETJTMpW4KlFe8nuOR5Iw/c0FPaF95W8n+H/I+wWgrDTqzCWZbmp1/ZAIrW39
	skpYpoQ4EQ2/+uR4Pi2j8zjRHyLfSbmJlQNl3uaP3px6EdkkhhxsmadmRFv34Yw5S+s+qRrBVqi
	HwC8H8OkOs23OIPe7nxq1jhW25som8sk/Crx1/rUwlQBr/aAj5LcGHdczJrGvj5LhGQww==
X-Google-Smtp-Source: AGHT+IFYfHtH8C5s1uvT6lQpi1zP9t+juS/waF1C0j2mYu7Lm8WN3kSueTRB3zxYadfI7XdeUjdoWuVsO5GiEEl5F4Q=
X-Received: by 2002:a05:620a:40c9:b0:8a9:ef98:6b34 with SMTP id
 af79cd13be357-8b4ebd9ec44mr276689885a.56.1764063004764; Tue, 25 Nov 2025
 01:30:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 25 Nov 2025 17:29:53 +0800
X-Gm-Features: AWmQ_bkYeHV6K5FqyKN_VGpZo_yET2QKTSBXEJ5BUvlynaIRq7f_ViUimOwdWNw
Message-ID: <CAGsJ_4wNiKfKpTPKUNim6-X=KiMxhp_9sPh+hkh8gB8AR2ue7g@mail.gmail.com>
Subject: Re: [PATCH 0/2] support batched checks of the references for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E70FD1C000E
X-Stat-Signature: tku7wqn95ygj9z4g9b9bxiifywhh4rr6
X-Rspam-User: 
X-HE-Tag: 1764063005-738613
X-HE-Meta: U2FsdGVkX18dR92DNCKGTj1kdnWYngieWKXTf7UrEvBvsqRiDCZn9VPiL2GLdkSQaZTpEdKB4swX+3N70G/exQnCEpUR4FP0BB/++C1Kyd04AvY1nZSi2uZPjOj3pQHm+kegfRfu2FIJslXm9SZIr9SGR44TnTdNd+ticnVmp+/TfwZ86142BW7Xsb+zo38uvAaIh0c0VJGsd93bZi48yXsgdTnc862dKpItX946dYOjKYqztG1KbW8SqlOQWxTxzIfv5Vh6A5ZqsbRMwyX2+RosH8jogjNsL1WGnatmM472U9iMs7uDxWWIwDY+YpVAOughuRFkYoybwgt+GShqtterd1A9pzFQlaZSWKL+kLooy2El3jhKX14MudjdSAanhcq1QILnsVkSVbl8nYSnKk0Zcmcw816m+UQyVpIfZvZZnMwc0xiJzWvyCi29fepzpDRMP8F26DT4EAgn+lREkvfZip9fbtyzYW7LCaH989/m9hvHeRZ8CgxnFZTmehmovnq8MxjySf58KzFWbNU+OBWitSGl708zatplFKsSx9gA8B2ITKF/zn3JbEGHI29U2N9dw+rBRdLPz3N569yARBV76ARMpiD6F/LaHm5js2pJf6NvQm6Dxl5bObNLZgnn9jNn7di1aqwKDQsyGkt2l5SB6G0mooo3iKgZj6whjFembF8M9aE33R7K88GRiwRRxu6BzzZLakDs0dXcinw9iaCNZGozNzZhwddOtlElrNxD3bLGVw4KMK03WzggQJ7G+bGFqG98vAzGrnVvTDmAwW/TtaTJrc9Mxx6CT+RhWLX2BndxbWHsLJbPL2UlM8sS+pEM0Arn/6x71fN01GTcduoxP0wa8MVuUWzf5GwvrMjKh4jJ20OkOwcHaUiC3CH5EbpZ1bjaKH7Jo+eDzJGB0mDIQN8IRAzeOJk7TYYHlHyWRB0L92JS+nkDoRPdulmwGsUCh7lwO7qmVQw+Bd1
 UBrwlYSk
 5hZNDLDDIAjepFBztpX7ymKdjyna/IjmkUR0/qdeYIEHqZ0GzioRF2QBCIGu4PfsAPXBk70++ICk3Z2Anupv8ptGfPfltIn5H0nVsHgMgZ8Sr7cTHN1+OHuVqwvFpRbaD3Gf40DqwJLq4A+//5CaBWCquNwO2WUKnJehM7fY541YVgJ/pi3XxX5veXC68tpkOj74ourV11Z2r8ydsxSGiVh647sFLqpYEzrvh4t2/qcdW4bXLMjMHZ05SiBMlLUd2bCVJqvXKs8MLjeT+xTjmQM9rXcZRCytKDTQ3aY3H5sEVYBIqhnGTzVkB6vVzkYl63GEVtLz1modbbCnxVHt+LMyasYTWEeK/rrhRxBA7JE2SXhUZYedSXuN1I/4hRw/hVRHgCxwGBekL1uGvnOqORUBbLDxdvg8QKSfmBngasDtXhG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

On Tue, Nov 25, 2025 at 8:57=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Currently, folio_referenced_one() always checks the young flag for each P=
TE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, whe=
re
> folio_referenced() is observed as a significant performance hotspot.
>
> Moreover, on Arm architecture, which supports contiguous PTEs, there is a=
lready
> an optimization to clear the young flags for PTEs within a contiguous ran=
ge.
> However, this is not sufficient. We can extend this to perform batched op=
erations
> for the entire large folio (which might exceed the contiguous range: CONT=
_PTE_SIZE).
>
> By supporting batched checking of the young flags and flushing TLB entrie=
s,
> I observed a 33% performance improvement in my file-backed folios reclaim=
 tests.

nice!

>
> BTW, I still noticed a hotspot in try_to_unmap() in my test. Hope Barry c=
an
> resend the optimization patch for try_to_unmap() [1].

Thanks for waking me up. Yes, it's still on my list=E2=80=94I've just had a=
 lot of
non-technical issues come up that seriously slowed my progress. Sorry for
the delay.

And I suppose we also need that for try_to_migrate().

>
> [1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/
>
> Baolin Wang (2):
>   arm64: mm: support batch clearing of the young flag for large folios
>   mm: rmap: support batched checks of the references for large folios
>
>  arch/arm64/include/asm/pgtable.h | 23 ++++++++++++-----
>  arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
>  include/linux/mmu_notifier.h     |  9 ++++---
>  include/linux/pgtable.h          | 19 ++++++++++++++
>  mm/rmap.c                        | 22 ++++++++++++++--
>  5 files changed, 92 insertions(+), 25 deletions(-)
>

Thanks
Barry

