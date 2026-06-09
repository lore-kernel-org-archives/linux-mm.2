Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DFDCD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C046B0088; Tue,  9 Jun 2026 11:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C896B008A; Tue,  9 Jun 2026 11:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F44F6B0092; Tue,  9 Jun 2026 11:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0256B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:40:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFDA41C2DB1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:40:29 +0000 (UTC)
X-FDA: 84860786178.22.887C7BB
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id EABDE4001B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:40:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sS6Wv1Z0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781019628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF7zsKiCN3w4l7B5RPd2UFWxLZZn1UTsHVOH1ijPs0Y=;
	b=qgLmJlzhymaHueSTiVTXhlvHfBoSANzzKDO/CdWVSRZZVwaMN04Sm2w4DJVfmP/Rqjw+dE
	bGbgXWMA7lZ6gF6SQ1XYmbZsdLu0KJbWNeix8+tIsK4lVzc956kp6RjTPGafUc9BCtICzR
	SMbQBAGlVdCeYE4Ixl4tLcvv3uBdjus=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sS6Wv1Z0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781019628;
	b=VvI6r5f/OaDox2J/xFixfhpxUYboNrbeMnUbTFVtXH2UkBwi1N+sz5nkXjvXPgsf4IaKYH
	hrXxfuJiZloKtwn7HluHxNbICYciYOMDm6uNdIiauf9ybdVZRD1DGGKBVbGe/7rqNXroz+
	SeZhYsLnc7ZRYGcgA/GPkDPvKWLBfRw=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490d1e54b3bso20097915e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:40:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781019626; cv=none;
        d=google.com; s=arc-20240605;
        b=eRy6U2GL5iiqwv2RWnskHTF6hMVJNPJEmTDWC+lcBkCsYftDxRuvmZFzVRe6qu2bn/
         EVEsbFQlKL1jVCWEKN0S8F6oLJ63sdnXPRdaF8ACwnAJUf7INKSidSXIOK+rCAfyVTbc
         jDZ3Bob+gK1xZW5IfVCUgosO8dFxQje29Y9byV1BENazbqSTANiQtBeeNsRqNKEjOoUt
         v5xVNbMHWZEowEHUZFYvlxLi0Hotg5atQLmO8R2ot2VZ+9DpSHrGTHO3NMjuruhpdgja
         Ftrnt7qhOVZDfdg/9/lGo7o7HmaEDoYhr1WDgrTfJIPDtYhoh0A9x6zaIFhdn8OPR/PN
         ov7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JF7zsKiCN3w4l7B5RPd2UFWxLZZn1UTsHVOH1ijPs0Y=;
        fh=MjSK2WvZlqZ18kwHoS3xRgIM4aZcNJkhMoDcPVKJ3jU=;
        b=K1GInV+Iy4t/aM4j67B2FuKfOY1MNccg7iuWB0xZOWeUwAA4gOkp574B1h2wslrYZ8
         LVSoeTZ6xPT66SQXN11QKgRSLYq4mGd/QDM3UFeAzgo0Oi3i8dOowkS53e1/aS8g7Qk1
         Mjt1gT6S7aAoNRJ1htonTLAJHc6lZ4B0Kjh0nQdkCiF/lUQMwyuzqQQT51VzuvlowqrW
         xtImcqYJX8lfZL/hzKEi4SMOQ0Vr+acMQXXJ/7EV5qhvH9MY6h4WV934rHrkfIgG1+Br
         QkSej53/eZaSEXPBhI6ajeqBbjzpyO0Q2j43nTu263YXlkA+aZLcRiC0CxDMRmPzHA1I
         YsFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781019626; x=1781624426; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JF7zsKiCN3w4l7B5RPd2UFWxLZZn1UTsHVOH1ijPs0Y=;
        b=sS6Wv1Z00hoMAIx1Pjos/4KnrtXdtrvTWLD7C4xKY6/XC7dI/eXDwcur4C/oxAZDqh
         OWGezJ9xtmHtAjTC5lqvH+xw01rYrLMPfw3IXrFEpHfS2Nj3vmNjWKavbIqxWrMb4E9B
         zLvl1P00Y76z1KKtPgbkB9jfibCf199wjM8u+QcIWM/aOl6BBRaFzGNOrTvXD18xAxSZ
         oc+BTMw3Y/ZbfGqnb76NggcKWzm4WgrsI+WS5UZRpDclYycCIiwn/dRZVvD+knWmP1jz
         i00ypVnCnZqJiUQkooWFzGt9o64S+TnFOiuhUK/NB6Mq9PX6O1kKMjQXxkhywA5CqCap
         Sg6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019626; x=1781624426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JF7zsKiCN3w4l7B5RPd2UFWxLZZn1UTsHVOH1ijPs0Y=;
        b=asGZcy1FD/Rxf0L91XJKSnBIaXFB1Ul3hJOlXQ7Gf4lJDjF84Gj1dD2eVe16cx9mLp
         akPWVEV6oznS6zkoEw0yRtnuiI48zI61Q+Inzxt9zQYGwYzamFHDLyBf3XwXx5JbkQ9W
         bVHgmkJKnYp1OKjb3qL2haAkuvYqjIdR3Y+Y6YbvPSizaoYEh7zdaCS3/99Bw0Qz79+/
         xCbUshL0C9KAIUTaZfRiCX+RTmC17iDlb0C5xIPbu03NTh4MYWi4b1L7ASlnBBQow4Gr
         qkzeDR81UQiV9NBng2J5cqE9ACzD6ZV6GpKptYzD3JKnDE4LiTMlGBZG8KPjr7U4mkg/
         JhEw==
X-Forwarded-Encrypted: i=1; AFNElJ+KwbmXT+kPgb0EwW8yjX4ZXuVVFQhmy9z0dxOeqYTyEkFlQOrWiPoOtIVnpFfyHHPt0EEPB/t4sA==@kvack.org
X-Gm-Message-State: AOJu0Yzh/F658tFpk+LwcBWGkne8ax9zUkvCKpxwoHQPFe4gsS46orN1
	KMCtRn3T5UuY/IBEqwbQ9mgKqSsghU0xBwpBPo8Xqw0EgfMIdxY7FZlTEGGhoBGWdbMsJWlT3Zu
	Q63r9mThQn420caiGzNUURSVhgkpsm58=
X-Gm-Gg: Acq92OHZuEOnjtNlJZdu91TJ/y7z5V7KCsPCHYKBhjVcV0VZzJI12RbCVh89Z6yAAEi
	4TzMOtK8weRbgJB7J529pnlT0hiRKqA2g2TyLRqffj/n7OpPcwvypZiRGShTVlqw/Iiqh3MeRHl
	MK6Ws6+KRW5GNoP+iz03GkV5R2z6vYHHEVPL0xH1KQLWmjJigmw6e61Qz96k+WSbSiitN6gyGGu
	HVR/V4UaX5K0d9+tyVi3DM4obtltAZe14c8dHjJfVtKXyKsPF+IcGsI5TP0D/FuvKJdY8gYy4Vd
	+YQxNg2hAeyiReW+jDwLvvflzIYCobToe6S94gdDKvsttMF7ZQ==
X-Received: by 2002:a05:600c:a00b:b0:490:be41:87c6 with SMTP id
 5b1f17b1804b1-490c256f5f3mr357647685e9.10.1781019625946; Tue, 09 Jun 2026
 08:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAHPqNmyHRwhi7uZN5WP8h8w3peAy-y4ZTmN4pb-OaS2RbdkD3A@mail.gmail.com>
In-Reply-To: <CAHPqNmyHRwhi7uZN5WP8h8w3peAy-y4ZTmN4pb-OaS2RbdkD3A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 9 Jun 2026 08:40:14 -0700
X-Gm-Features: AVVi8Cf96muUvkUFiFXlJKPCTtKiA52MbMttE9WHqC2vvElCeiM0RnwS0kHMLbU
Message-ID: <CAKEwX=PpwDawVzfxQn3AuuxQu4Kn24-0NcoXg24=eHD+sBk-9A@mail.gmail.com>
Subject: Re: [Kernel Bug] INFO: task hung in zswap_decompress
To: Longxing Li <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EABDE4001B
X-Stat-Signature: fpz4c6wd6bdpzrd6px99hixo54nw815z
X-HE-Tag: 1781019627-591114
X-HE-Meta: U2FsdGVkX1+CPtu91bugs5k7n0QigqAZ10X8Wc0iVeIqImwikRYiT64xQgz9dpsLdOBeByKJFJoB1vsM+QMBkH2vG7oPbrbX/TWSdCqwk4qLHv88quwjEN5rvVZPHYxTZ+UKCjw2JW0CJD3ggk/SK5uR70XT3i+gaf46JSjfq3w3VXjDNW2H/FCLXVZt+XVRqNplb5onAyijtVq9afqTh7a4y37qzZJHvX6JxdIkTpMOzGQyYg7ZqtmKDgmEZKBGpIqaxnOpKk+TeakWAUouYTHE1vo5U2uzqHnQETPoTvSvenxXBc6k+5QMlMCbL4wVVVD2Mou2PpgyKY59LQSqa1dywS6QqbpC+6Rg5rdmVkDzh5z3kPEwZVpPmmfPuB0c2+6OSWEtfXJlCagr0kSi/7w7qH6/10CucIYDOY2foyiFTSeuTPTjtBrcBHB6PHTtqPxeN1r8GMoGnYPjSe7mcgCK/UtLDsHo/+nJFWR0dqPaiMMfuEHsiiqG0xaZPqQ7fP6Xlpm/+6b9mZ8RuO0mme4rxnbfdysJ/dMpmAync9gtxH7YL54kSkGHP1vtxFHYVTTVtd0YH23crpzMAxweLU5EfMWRwCKev38FL6y8jYLdSoAUfEzL5V2kTcAtqE0HZP23PLOSp8Hnk+Hv/5LIEuKCucXpLjwbYDECClOoRgcBPQMxK3TlJSP8qVLkZ0uRqDuNi9PIohL2Bm9G88foRPPSVD/JAO9FtEcN497G04VOUn/lGlOFlyIYwXBRH6S9s8YNJKowgAPIfCifZT9HLaOkxzumNSWayyZgaMBok6WN11oy9Bhlp7ArmbbhdHIHO+PLkCLJLUZthYklStB2d7sBHDKc9VwwuyRvUbfWpCF1OSu6OS2nhM7DnvuwM3TrK0E1NedQbu0RhAMyEBWKUsbSR8rbrjKmZ2KwoRQ+HEjXMBHqZjl2a6d4pWM5LoH/YI8/6huNsRAUwv+jLO7
 QtReMMMQ
 KyBRldD56/1gcKRazsCS1sDYcYxdS3VGttBqvg2HWbaJOp0jVyUUcH800QqHikVDZ7AOdNWMaePYu2BYNuMxp0yjSfzk/BB7CntmheKIfMxihMMRih5sPwPPlNHmUc8ple5YE2BzZe/IqHXWcSQOtQCkJpw8m2idoyV+4tnCjtK7yHtd3zt5dTgzXet2KruUssj4+dNlFR0DTwh91dPJzAsGC1wRytpfkOxC60FBoQf1GIJj1Y6BT4ceIO0RAEf9tCWdLhVZyJFKB2VlrA7AlUyWY0o8RtnfF0i61x5fSGIUo+iDC7BxiSSIbQiOR7Bn1lel5SC9SUHRLEHqtJ+9z7Y4V9cXexHdvdytFCn2KPXKqm3F7mecwqvkV5Q1TKfTu3ZIGBHkl/mU1+8mpb913rMDjPz49A/Z0N3ONf+nNQAO2kYqlGK7YOohB+k0fNoEkZiePkmgttNAuax1bb2L7D1XWlqbZjUCWynNFCkP78rjvFIRrX24YrabWl1RB2J//BJb83jFfs/P2+3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 4:51=E2=80=AFAM Longxing Li <coregee2000@gmail.com> =
wrote:
>
> Dear Linux kernel developers and maintainers,
>
> We would like to report a new kernel bug found by our tool. INFO: task
> hung in zswap_decompress. Details are as follows.
>
> Kernel commit: v7.0.6
> Kernel config: see attachment
> report: see attachment
>
> We are currently analyzing the root cause and  working on a
> reproducible PoC. We will provide further updates in this thread as
> soon as we have more information.
>
> Best regards,
> Longxing Li
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/view?us=
p=3Ddrive_link
>
> https://drive.google.com/file/d/16xzUrwOvwE67cnMPH3AhhNRWq6hr26Qj/view?us=
p=3Ddrive_link

+ Kanchana, who last worked on this piece of code

