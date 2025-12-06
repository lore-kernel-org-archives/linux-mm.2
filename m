Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30305D3B7D2
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 12:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7B76B0005; Sat,  6 Dec 2025 07:28:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37FBF6B0006; Sat,  6 Dec 2025 07:28:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295FE6B0007; Sat,  6 Dec 2025 07:28:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 149EE6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 07:28:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F073133CA1
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:28:26 +0000 (UTC)
X-FDA: 84188974212.20.7B755F3
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id BA08D14000B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:28:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSnjfk9Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765024104; a=rsa-sha256;
	cv=none;
	b=Cg6P0fVR6Dl8WYjMF2c/QM/yFcIgjF19jrBCkwc59L8OvqSlYFfDcJkcVwNLoDM7IHC0h6
	JkHba5KXanEMOpqs3unJfRRPuioPAQpOlui0rBJ1NoywxAWZVU/Tc75bI7BlJxFAhVLRgL
	pe9YhPs39MS9RuNdN3Ln/NR2OhzaO7U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XSnjfk9Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765024104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNYF+zUCbKb2Rsw1WZTSJDQ0d8kdqAioJDRT0HTV/Ac=;
	b=Lpa61jXw9dBOyD10nwg0bH1ZQvu3Dq3HeBFdq75PkEBVF5RZyjZgN7bfe2ABu0t7jRHZIB
	bHLfvGHbXnE9lz4RpoXzaoRLnAtpE08JfgC7zP8juV04YehSrUN5VyWsBsfIEdmp3unH8l
	XrOxoQ8QQr8vt/aoEc0mrwjdramWPnQ=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7866bca6765so26123137b3.1
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 04:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765024104; x=1765628904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNYF+zUCbKb2Rsw1WZTSJDQ0d8kdqAioJDRT0HTV/Ac=;
        b=XSnjfk9QeG2raUwjeKtEyW4tNowzdZHmhprrYdTD8bLn0aK3FLIwE9niAKnRnmrtnV
         XAQLJhky8jhXRMNcvPkGHU1UR4L8GZIr89/v6hI0aatOaj1FAVHqIUnhUFMF5viBSsK1
         xgJkbm8spCH4S/9TX2c72OND/wgoIwLqIgZdavX26HawahBygzV6PpAndoS6uyKlNbdy
         hMSfTvo4jIlR6iUXdQBq4A/TqV4FHUqFyVKDNlq2uRAXBJpQ5TWaOIZeH3iL9296MK1a
         EsVXzD3fZkhless9vhgwq8yGNOvdnvykDBFGVO6DFMMiGt5Y65bK+dIeIbWaXxUZRWnb
         loDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765024104; x=1765628904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fNYF+zUCbKb2Rsw1WZTSJDQ0d8kdqAioJDRT0HTV/Ac=;
        b=Ubq7ixryyrVm5LbRBmpQrHnjGSUOO6RscHVM/NekFR56p7NDktKl2tLXLwCxOU9Rha
         2L5cVOgb9a2mOo/rFmBl8AWO2NTaUaOvzgHoh6UaiCUvoFGn4n00F1nnaJnA0nolSeN7
         ojc3fEREKpgB7jn4a6iNKONL5JerdOK2sExDDI6dSIXP5Bf8oCLt8uWvtSEnFekqUuxw
         a/MNUrqvmuthHFB0J76U4EhK/Ewzuak4C4AozYuOnUPnN39BoKO6c6m0GJ0JAfjCmO1H
         avB3pOR16KfBHx+4ytpI1qh3lY2NYjVH4SNtW7p8E9/5a9dNeX4EhKa1N3u2sv5Q77IY
         YrjA==
X-Forwarded-Encrypted: i=1; AJvYcCWGw4Ip3PJSKPski2oARfD69LO7j5etpsKbLauW9Pj8XiI+kGFox+piENIvNGWrQgQpsayyjnWFDg==@kvack.org
X-Gm-Message-State: AOJu0Yx6ILOiKC1KEhirv/A0owzlkfOTWRF1K0U3vGYyZ9jWxYqTFOoo
	7V6Ft8f4BhBG0IxWV9x0mSQbo/NK4U9FdzWrecYN1n+3IaCkFiXTYCIMqV5mQGaXJLIgUp9oRmr
	ivMRgv4sYDphzsGf4iacZLudMvj78gPQ=
X-Gm-Gg: ASbGncsMSa9Pb38yWhMsQSf5ubLs5SoZmXI5joOi87NskSITjaJ/pMfERlxJaWSFVDH
	qq7VN0UZ6mMukZYvSLjMuZtrInvaZVGRB6kHzMEGxXbyUXBOXJDNzzS7LYcpafTgyDLhFqMJc3l
	ELqUZqLqTiQ8LOMCsDbJGwNxLuwXfYu7vLx8gRjVyJs8dIfN+Sk+dr8BmbVDPivUBlAFDZhhMWm
	kgmd2EaUsOhc9qz4+yxVEOnkWXdaeT9n4YfdhdBg/PYDHX/djJogMtGDtq+/O8ubc+o4/DJgzPc
	TS5qDkrlEMki4yxGQpk7zodx7Jhcsz584/WNNV/3zq0Ipsu+11nl2nSMuF4=
X-Google-Smtp-Source: AGHT+IHNRDrIGY84WUUkBTT6iifj/Wc19+96QDKrhrvMwFfcVHROjar/m0bBTLJ4og3rpYFs8jAMAeYMaeReN9hOcFM=
X-Received: by 2002:a05:690c:fd5:b0:786:8ce9:3b55 with SMTP id
 00721157ae682-78c33afd0b3mr18315667b3.5.1765024103716; Sat, 06 Dec 2025
 04:28:23 -0800 (PST)
MIME-Version: 1.0
References: <20251201093741.730884-1-kartikey406@gmail.com>
 <CAMgjq7DLkbfXczQvT5on_25PbJOGT1iOqteuXYsXEzFL6CTbTg@mail.gmail.com>
 <CADhLXY73pZGTvV_2wmCB0WUOecAtrcwOBoBJQc42CQ8MOBMjJA@mail.gmail.com> <CAMgjq7B7+=_hfo+BZr-cyYayUCUhVQWRDsC7FGpMKAXdvY5_wQ@mail.gmail.com>
In-Reply-To: <CAMgjq7B7+=_hfo+BZr-cyYayUCUhVQWRDsC7FGpMKAXdvY5_wQ@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sat, 6 Dec 2025 17:58:10 +0530
X-Gm-Features: AQt7F2oUWf8gx4gkUoldxOL20pZvMkLOr_KWrlTZF23dSdsTYcSrhoG2xNIiFSU
Message-ID: <CADhLXY6FgG3sdZ1CSSp5X8huFPhyKQ+LKNkd0rbo_-=gV40RoA@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: validate swap offset in unuse_pte_range()
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, YoungJun Park <youngjun.park@lge.com>, 
	syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BA08D14000B
X-Rspamd-Server: rspam10
X-Stat-Signature: ww1no4cdkpbsxacfb5nciwwtatah9nkt
X-HE-Tag: 1765024104-351805
X-HE-Meta: U2FsdGVkX1/lAdlnx0z+XLrB6SN/Aw1jMRRI/vRYcEuZNldm4PS+qCczdgXsoHeCnooZJ/OD2vpnzirfOIRWe23nnfJdFFhJ4jA0KFapV5MZYO/7f8fXKwi1MRLeGfStcwIrRbCx/+pMKl7s+mO39Vbb/O4TedN9KGRHyY6WYeXdF2urYCAzjFVDFAkGO16BGBts1524yU6CRLM3+o5GBnv2JRrWq6lURzb4Qg1y3L6VHxm5uirGlgQGL7m6PWoVrCEKUhLX3ZgEXJ2pB7tYWW+vgShhbJcV9NSSq9AdD57yqk4JqjdDh4SSM/Yv8M096dIRgEMZv6V6ntNAeqpm1hXX7mz2nx3Z5TSbQo5mhmnQjw0i37dnw8TW1+aPboKSjGpsvFZ3G4QscG2gHm2QH3mVxBgMN1wVJBZFoaHZ/Q/+3AZJCejnkwog9LmoRtIbyBJ/mTFSXVpgkOhE4PdtPBfwanEOiQXEWRpnENgoUhLmx2gVFMCInRzrr1zSYpjaAi9NQhPIvWcl6gCXgTHCLbX4wWyMvrsixVskuoeQ5p3+o6MAmlYgF4b7c/U89hM8zyYo9SmFZpAkszo4G3xeXRjqJh2psr/iAZZfzii8v0KlV6pZUGQ7His3Pp8r+mc30EVLEa0VtnNnJOdKTJhAgGB7CHChBODQ1IygeWXPz9DfPh4vQhSovSXDgFeG8G5aNPMwYrvmqO/OfZCJPHs9aLEPm58E9EHohuBcUq7IXogDBSDQzNVehORrYpvpjrhFzBQs03wh/Mvbp6d5mQobI5TfrUcM8N7S2h4a9w7SKhwgC3CFXcSt1mH9OD6h/oRgkKfXoyqjfAfOhzYgfzASiTs3d60TIeRKDFZewKsFw9IwW6tgsQMnMJ2DOEEcyjgewAyE0B/AS+6X6av/wlsA2BgpkN7xCfcWYFNmMpS+a5vpLvPcT1cxrXenwy19hkN9ZKWAOY45CBvZ2m0lbqU
 Vq10ER/j
 InYjpcxiOU3vdQ4Gi70/Vaqx9oYahozsSpcT0NZGfsMZoonbZ00uxnbsOx9IWf3Nw4GX8fIpv/bx9Yx+5MwYLragUzFSf4YVfOuO73R35Z+jsTguJfxy8lcsPguTgzM9v4CcXvi2n1i5UTDU45QWq094VOHNJp5oiyvlf4IY4rVuthAt9DxFc3HXljvdeYvPpEKC6KoGZghQjvdm0pBK0iQ+E32PjlDimVB7dukDWi5DSZvoX7de/v+ykRIaAYBR0jYBCTMaMJnFWknGHjEGmD22M9oxTbnYnqxT7irXgzeixzcJfocyf0PiWUM+vW+sKHfD/JwSnDQxCyifLoLLxjJb/z5uhPbqrq+2tWOkVM6VjzE/QlEnG4vrihCj66tF3dqNKktH/HIV/kDiPMBoVf0VddWhgR6oxgWnjjbXMoDofDLnB12Lf55Iwu9QzXhhPeyCU92dUG+ExuM7dPh0RnO5YmhXzwSqhRrU42U6JrMjIVz0Ejw6b4RwZVZdhf9uMbmuV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000039, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 3, 2025 at 8:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
> > If softleaf v3 has fixed the underlying issue, I can withdraw this
> > patch. Or if you think a defensive sanity check still has value, I can
> > update the commit message to reflect that it is defensive hardening
> > rather than a fix for an active bug.
>
> A sanity check here is acceptable since swapoff is cold and the
> overhead is hardly visible. No strong opinion on this one.

Hi Kairui,

Thank you for the link and clarification!

I'll study Lorenzo's fix to understand the root cause better.

Since you mentioned a sanity check is acceptable here, should I update
the commit message to frame this as defensive hardening rather than a
bug fix? Something like:

    mm/swapfile: add defensive bounds check in unuse_pte_range()

    Add a sanity check to validate the swap offset is within bounds
    before using it. While there is no known code path that can
    trigger an out-of-bounds offset, this provides defense against
    potential edge cases or memory corruption.

    The overhead is negligible since swapoff is a cold path.

Thanks,
Deepanshu

