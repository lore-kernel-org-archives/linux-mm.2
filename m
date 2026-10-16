Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D344CCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AAA26B00A0; Thu, 15 Oct 2026 23:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781B46B00A1; Thu, 15 Oct 2026 23:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE386B00A2; Thu, 15 Oct 2026 23:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB1A6B00A0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:11:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2517A0223
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:11:01 +0000 (UTC)
X-FDA: 85327012722.01.5214F2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8B75140009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu+pJStA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fiKC2aTmvE0OeIcVC/v1BvJFGUG2CBHWahegQLQaL0=;
	b=v3IlHkNieTauNhkSmmdGwa52LGj8krpCQ/UHNR+/wfKpBZrbcfvkqJctCu2wZo/YS7O8Is
	rjtGeqidm4YYmKR5fGiK8276VbHSpVTQjbqxzyMZSBv1YUmB2G+vqCnef4mDWGV7OS1TAH
	84xgkuWQ+lUiojPyciFd91jonHR/TEU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cu+pJStA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120259;
	b=FNVNS04IgMZuUL390TyVh/UJWLt8BOErJp7HfR5DaZ3celNVj19tgL2ayxKaBRqjy1xcCg
	h/wvoWV+Y2oZyOrqOslxRVadway0SuUDRdmAz0K5GZb/yYTtyafyBgIuVHm1MEFypGT8EC
	UPjoolH/yFUJg43uC0bEIXxpMSSJjm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60602600D4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195011F000C4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792120259;
	bh=1fiKC2aTmvE0OeIcVC/v1BvJFGUG2CBHWahegQLQaL0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Cu+pJStAFWrWfCf4ssC/P2a0EtKOC4/+S3a0tNA5nXaYOvxLTt9v4plEc6J+6qwW5
	 iVq7RyouyPT8s/NXzp9pibDhmdN0xBD0XaLf2rJxEm8T6xppg39/+QeYjqSpw0261b
	 5SyTnHtWEt13zgvscJV8LhCloJiMaRcUM6HZ3eDyvWbgSTCQv3zDXrf7ZBfEt8QjGS
	 uc/7J/a0v15TZmnedQZBIxj775TpTERTQRX5CdMdHuEThaQicyqbrbDP5JrD3m25zc
	 v+MAdgZzItFdZLnKNoKvc4/VS+mbjLKBMmFFyKjGqg6kN0M8jctvfxNk7Xz5VGjFOF
	 SxUldGBydgiZw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93ef1a2948dso472064585a.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:10:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzdxmqVkxrqPecyxefEP/Z90mfm8Nv3MpyNZtzz8Ed7//iKNzlvnsxWadKzsyEtAw5AL2Cd4GmhmQ==@kvack.org
X-Gm-Message-State: AFq9FYLrhaKHTLi6PLOhG85DlwVY9fraYDoG/4THz8U4g1TXQG1x5BK+
	ZwDQiY4PZ9wrDh8Wnqtk8F/YH2m/B6CU72O5sV5chwuZQPqgaT+GTd7EQs5RaFKYM27CqkjVyBa
	ktw3FfDhpHVly8nWKQFk7WWGgj97KWDw=
X-Received: by 2002:a05:620a:6606:b0:93e:bcbf:4ad with SMTP id
 af79cd13be357-93ebd24d7acmr3486164085a.33.1792120258517; Thu, 15 Oct 2026
 20:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <atBh9xfpOji_A7A_@google.com> <20261015112440.1491168-1-zhangbo56@xiaomi.com>
 <atGPwJL6XzlRaMva@google.com>
In-Reply-To: <atGPwJL6XzlRaMva@google.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 16 Oct 2026 11:10:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4weqqSGH2JCh5EThtU8N3e96kRnhLtd9Fotia1t+7YqxQ@mail.gmail.com>
X-Gm-Features: AclHuK8Cdg4eD67RhRhItOTBH5o8vU5ld-ttYECyihZqBeuSHj7hg8nJiSsejkE
Message-ID: <CAGsJ_4weqqSGH2JCh5EThtU8N3e96kRnhLtd9Fotia1t+7YqxQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org, bgeffon@google.com, 
	minchan@kernel.org, richardycc@google.com, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E8B75140009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: wy61srqmzgene9hidsjozaq9gi6o1msk
X-HE-Tag: 1792120259-325197
X-HE-Meta: U2FsdGVkX1+p5fWn41FZdtfrgRGPIeX+eme8xs2Egxvkh/t2U3bg9T+r1mJCSaxrajhdYccNxZ7hBUhLUwOxZX2TLyBVG3pPrMsFnEH3cFVQuIUzQvgSuNuK2ixWYQ0L+TiqP7HqOo3kcJqG6APtYCRTAhO/bvqTpiQeojVPM0col2lS41oyiNiUcygAfefOCeB6R1+b/D3hPhE+xjlhdS+HlP7sV4mxBAe1hvWg6n4nc7TF7vpgZvo4jKkWYePwJ+VEcChE9tERWIqzk97H9hlFpgfjXpvhzHDJdKb1usfr/TCSd2mL21bPRmwsHI4+JZg6En6Okls1kIgGCHNFA9fneiM7J60duEw5OvtJJVxacC1hezvTJCjS2FL+O3e8UaUWlZIYpRSSenYOrbAv16MxYoRLSoHGkVfLslpKHV5ru4K2j6Yucob/6c3XLAqTD+h1l5GuLJOB5XFAmwVzWIf8EmAVdH5NhQJQBcPioasHurW2CyeNSmsANpLIciLx4on+4fuQxpMQ23Xsf0GRuv4dHu2QwUCUqG1yCjvDwKGgzBx0dRZi8elRYVRsxWnqqGABhhT5hUiY3xOK7y1svSxsptgza57+cG/3B7i/bT7nKGIZrsqnyxsDska4itVYtvrhd/SwA1LTIoVVpXZqw8/1PZjZI6Y0R5PplyiBy06M+LF1iGwDSz0Dn2d3Ut4Nfcf/Kn5sJ1aCRTinQeeQi2wABq2CmzYNukuqSPlw31/ANI7L6eEFF3mowYofqms6aQjGk6IaggLP9r5gv4l5BgeMUoZt3M/jTaXf49SbtQIxUFgBu/WF6vemH1vnQyHfXV8HkFnbw3c4ROI+pDZ6P/jmdmjA5OP5r0sXrTVd/8HVrlrSK8Al8OiO5a1w54cer0vLId6teE9QkXdBKBCE9dyza7zX20yqlm23wbNpeHfxwlcJDwoz+zdbSSVM2NMO7nf8Y7AO28COCDF+aT4
 QcACLQny
 hLKdj73OSKGMFSpZBj3pyOKmHI9jYFehRxsL4Da2hz8FhF3zu7fp3cD+9CZZyCIVrab7FUgxtavEFAvTVQa3TodkZytdAzeyzHOfIgO+QYz4z2zzNfR9m2cbvMpwm3aFSOZzIclrzT9vgNx5I5akXtEEDFyLBiP5GteXn/KxIznMzvIR0CN14G+iXtBythvoBZ01jhLshVrJIwtbx0KV5ZPEf9YVU+sR9IwvaMcPxa1GI/hjVzGaJiUMbY4NDdk/LminXPHIj8jYUUlv6P8zxE+WCMbr6iaCDwGtECjOsY1p/TWKvp6y4z7gyXoinTZloT1XvWOqxVJ8ThDsOOme2xBMwYmsN8NRho2dEz3sFb421s6GEWIP3A/VAVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 10:51=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/10/15 19:24), Bo Zhang wrote:
> > On Thu, 15 Oct 2026 12:19:49 +0900 Sergey Senozhatsky <senozhatsky@chro=
mium.org> wrote:
> > > Or perhaps we can avoid vm_map/unmap.  A slightly different approach.
> > > kmalloc on fast path + memcpy (zsmalloc objects are strictly less tha=
n
> > > PAGE_SIZE bytes)
> >
> > I applied the kmalloc+memcpy variant on-device and re-ran the same
> > Android A/B. It removes the exclusive path entirely in our workload.
> >
> >                       9+10       9+10 + kmalloc fastpath
> >   read contended      ~1,959     0
> >   read wait_ns total  ~12 s      0
> >   read wait_ns max    72-96 ms   0
> >   shared              76.7%      100%
> >   exclusive           23.3%      0%
> >   dpin_contended      0          0
> >
> > Every decompression now takes the shared (down_read) path, including th=
e
> > cross-page objects that previously had to go exclusive. The ~1,959
> > residual contentions on the exclusive path are gone, and pin contention
> > stays at zero, so the full read side runs concurrently with no stream
> > contention.
> >
> > Read-side contention end to end:
> >
> >                  baseline   9+10      9+10 + kmalloc
> >   read contended 24,749     ~1,959    0
> >   shared         0%         76.7%     100%
>
> Thank you.  I'll include kmalloc patch to v4 of the series.

Hi Sergey, Bo,

I assume when Sergey sent v4, could tag for the patchset with

Tested-by: Bo Zhang <zhangbo56@xiaomi.com>

?

also, Bo's data can be put in cover-letter?

