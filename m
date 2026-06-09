Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7739CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5B56B008A; Tue,  9 Jun 2026 14:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD4A6B008C; Tue,  9 Jun 2026 14:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3016B0092; Tue,  9 Jun 2026 14:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF37B6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:36:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67A7940710
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:36:46 +0000 (UTC)
X-FDA: 84861230412.23.C24235A
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4ABE7140011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:36:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lI3UJcpf;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781030204;
	b=Afr3lSF3bhIoRuSxuP+xPSme5ZAU98P4AkrAckcNNKrRsZJo/QSyfEoWtKZB18ttzN/cmA
	6mReK5Ob1sFkODffIImEWSLcpt6sgURWjvXvOMYJmWSZufngKmwX/e1gBIi8a/4KSc7uYw
	Ztxcr0Yus+DexTtWQQi2EVfvx7qUWTw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lI3UJcpf;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A14yImNoYUuYnHk3J0iG7npDQKQJTSDNkK1zJ2+c5zc=;
	b=UCN9y6gzIcYRrfpL0ho5wZPtOgvgA+NZBNlan26wiRniXtr+b9w3oiTksE4xrLEdN9MODe
	jpzUcNuyd9qpM/qDMtvnLlOOEopH6Uy0stlTpfRTbny3+uqlDVlgpydgysLEZFrPX604SX
	D4KKpG82y64DLkbhNXXeXPYzOdzuuvc=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aa6cdebc33so5336069e87.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 11:36:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781030202; cv=none;
        d=google.com; s=arc-20240605;
        b=D02OdTCLFpnGJkcBg/E2NP0ROYeQtkRBwj0bST8FNPe/mQXWv+qRW133Hh7AZd8aq5
         hVKHCCrcRoX3522VheJj/TU0WVdY4BtUb1P0FGMC8ApPNJr5dPDdrkZWFnfx7XC/mIp/
         mDolgyt3VQd1Ux+FvTEIRcqtwMrn+tP5FC/7BQdVYzGknPh8T5aX+HCpUFEpee6Xk/jJ
         Af7RWIFPaO+TYX7T2wYzzfRhu5xouXQEY6tRv1nspQ71nJLmUGPRn3QEfE5GfVXUfmEe
         /hvxPU1GWOYojbfF2SQgOPswD5NKJTrR1b/5ueu18uolEPTuZ6U7gz4y0CMxO8n3K9Lx
         M8NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A14yImNoYUuYnHk3J0iG7npDQKQJTSDNkK1zJ2+c5zc=;
        fh=CEzAdClZKZnOqsTHZuxj/qu5hsj7EWzYwNk6mi54y9g=;
        b=b3xqFBH5YnjQQcoWGavFQJgF86JtwvuCqVfOUAFl+ItZVSXvyYIeCQycmJ1YqAmfld
         prlad4Dp/JybqPeu4BUjLwdXGyi1HUrQeRefvYSefrmD8W2QrmchDD3LhpB14wpN148u
         s8vyHaFzbS4rYzBqfrhF7RgbmCArPa0QyIOLU1dEgy/vtYbFscugInxh4ogCtcRDXdB+
         mFICXeFNKobF9qd/YtOSMRRKxI57dxiOXZh4dMruIZD+Bm+LRfth6qH7m9gGTj28gup1
         9aOf71q4urTBd0Pw4a0fRSUCDSfEzNkqvhGjkkEzJmSNVQk9Y3o9UB76pRaPah7Qr+1l
         3X+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781030202; x=1781635002; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A14yImNoYUuYnHk3J0iG7npDQKQJTSDNkK1zJ2+c5zc=;
        b=lI3UJcpfsfZuhD8ONA2KEB0UEqgPm/7u1FAFGVnC0Fo741FSUMKr5vb1snA9GKzyKK
         7wo2Bd2Qwu87qMwuFjr8dFt/cFS6qwcsuLwWnaWZdGZAasnbtocGFjTSE0h3bUDgBbJJ
         tPb5WJALguU35atYAFgykb42JAwXn9iD9wd9A1n3+Z3nsSuHzt2hRv1EADMS00o/YnOv
         VVoyty494sdFeR0mUtvK8svryn4qZLJZYcq3hr3VtNo1XSRr6RHJVE+kGUVXUV9v/DBe
         11iOCU4ms0U7aHlc9jIMt1F9fw14CzOPgE6fNYwCH0h3o+bEW9HyHW6SKI3knY4Qo1PZ
         h+zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781030202; x=1781635002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A14yImNoYUuYnHk3J0iG7npDQKQJTSDNkK1zJ2+c5zc=;
        b=kg3fcmA9U3pTwzY55JeawpQtI6WJUu7VOpsYXaVTJFdhlMrIXBbJ2hJTrHFGvQH81k
         0Dr/IZDeuop/fp+ZWy/vAQlxKyAEfguaero7hNVslwj2IBGV4psaF8/qLMTfwtJzkf9d
         ZasqBLdSLf/wNhD6THLNeoN79t5BTH+3D2B0xbRQCEFun3GWT7+1+MLzJKJeOlmqfuil
         BmeNX2+i1/gDLIiadApNrp6a1xGvZ7siSASv1UY7cO+t9JUXcughM4vrKoTZtx730zE/
         nzj9K7kqkt1Ic89O7ytF3IiKdnDj5kHhQ0VZmEAtMsiy9SFnyVzB0wTd7EN2Plf/oFaI
         fDXQ==
X-Forwarded-Encrypted: i=1; AFNElJ99jqQjTmXAOurQI+r/NuGxNvjfQYHShhpuNB6Z0kxT9JQ6fQE4yOGrfRkcCoP6KwbsLDnmrM4VQw==@kvack.org
X-Gm-Message-State: AOJu0Yx758MK6K0j8q5NB9DQmV4W0A1rNKb9k5vs16L8aestuWSDdjD/
	WRqX3VGBgoUBRB3c4RXGw6kzsKkB6/q/eR8o0XPpWqdC44075Rv+MUOCE4+Alt8iT4Dty2pw9O5
	vpho/3Go/CgdEV8MqgYZL7LOI3ylFVCA=
X-Gm-Gg: Acq92OEqtKjEYMdGhRZ9xUGb28dIVVOD5IqcmEO/R6MQERv8923K7y9Ls1fRCbkCCcR
	AFD7ru24GxlzvunBzXeUsJeBuLO7u2QyTU1X2MhQTunVCGMi2eQOceD1E/D9ku0PLwsGbo2m39o
	SIIRvHP3LiMgnAEWUXv6kashR4cr271f8NKTHgoJz80AP+qhlTQ2rULmw32iyMiA6Dkr8ZX7dsm
	QBK2JbGVJ30PruTOEIOw5MFKgYG2ky8OL2HyO8iZKrSbD743eheucPVIbt5iVYh1UZdfnJeq08T
	b37DhZNWa3XaoHgFtIre6/mqfpOKj9Xao5RIAu1gFBwzLGq2GUs=
X-Received: by 2002:ac2:4e0e:0:b0:5a8:6cbc:60f3 with SMTP id
 2adb3069b0e04-5aa87c03398mr6922053e87.34.1781030201803; Tue, 09 Jun 2026
 11:36:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHPqNmyHRwhi7uZN5WP8h8w3peAy-y4ZTmN4pb-OaS2RbdkD3A@mail.gmail.com>
 <CAKEwX=PpwDawVzfxQn3AuuxQu4Kn24-0NcoXg24=eHD+sBk-9A@mail.gmail.com> <CAO9r8zMUv5gBkTEst=8GtyPTn1cixFggemHt-p_tPG55fosOQg@mail.gmail.com>
In-Reply-To: <CAO9r8zMUv5gBkTEst=8GtyPTn1cixFggemHt-p_tPG55fosOQg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 9 Jun 2026 08:36:29 -1000
X-Gm-Features: AVVi8CeyoZYcP40r-CksSU5qT3yopJIxEvfYqBjfjR1S2I0NtjOpA7mp8s__RJE
Message-ID: <CACpmpodS2J_n+Q=RqgL4rfHN7zChrrefU3u2qXfYkcv4+YnCbw@mail.gmail.com>
Subject: Re: [Kernel Bug] INFO: task hung in zswap_decompress
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Longxing Li <coregee2000@gmail.com>, syzkaller@googlegroups.com, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4ABE7140011
X-Rspam-User: 
X-Stat-Signature: 7cr55gym7fa9nzqqrzkaxb7d6wt1cocm
X-HE-Tag: 1781030204-401418
X-HE-Meta: U2FsdGVkX18rozMBHvESoFRBOsX4a0Bl4c+ebyAocabYzwQlS5zFc+HQ5bGJJfvyoJT1ZAK7mjZEJ4E25RkdeBJ1dwvJyC/G0Rn0UCHWpVZRhTa5NBj3D3g0osT40Wqv7fAuFJYoJ0OjIiKTTY1xC3klor/nU7Q3fCT5DcXNUxuIXxZF+W0EdnKlxzAL3iFzTNLtrjLWmGFkPy912pwnQIA4hovnZbnonUzTYyxcQfo47vh3oRRd82pIw1p0tswYGgo88xOL4n/xPUX0SfcS8r8/yaNYR4IsanZ0+6PLaVn6BG1Ef87vgNBNA5t3hYEFl972p5UjX65Hmm9PL0I9Z3CEhTEPYKD3WWAj7A2X7kYlK0h0aVyflAQnjeNkSfP5aBv5U8h4cxlHFffAVgJOij7KTFvnrrGrV3bW3J5lSYZgpwcTShPzwsM9ETjRuZ4rxSk6V42jdaFZt6OdhsYwnuQqcYbhRDsoFmdG5a28LGPAbwUgQWQChYiMIz9OvJorQ7AIylt5MQxTuvl6QDJ2ObXlTuYXlINHN2pDIujo1sjbpIkYVCAVryPl/WEO11hMmMZcyoxPerER8HiEdPasQ8mUAehJOD2vPRgViKXvX+EOeSa8yd7t/NWJ3nZpHJtc4V6NLiEqwkxcZZGIIGfEviFN2zeKiy0J1A/qtigyZs0R98VZSf2VNch/fzuaR1nxmd4Je4DKx/O6UwzeBq3UFdP01iSr4YGCExmBK25RxDMUvVvDb3EbY5luAyMS57EIv/faV2sBhrHlJg4GQnxtsR7QMYgCQ27BwQACely/pR8ilq8eWK99COAPoRxw2+PnrHHBXIK2CQH4HFyClyxwUgeqOJChHV1nwqNHt7ShdHytzMFutIOFkdc4s1NdaEakVUrnpr1AE8VCpPTHQhmvJ5I+yLYtEO02Ikzz5JFWhV6PQLQ4eZerDuP1UvfwwHLbzSxMobjoPp3apDdMsii
 SWStFGcB
 kKE6M94+Ri/T23qlu23a156Gpk/6qZKSFIOGZONUbdDbnQ7P4HAc5L1vGHusazrWinJ+iM+dgV8UJzIqEJXg6EUAoAxR7QEQv55S7zs6GrsYyYgUtNi3DQTf5kxF7xpR3a6LJwDmZUCaSqD4pYos2JCePNWQ/NuxYkhB1WXe4av1Olvcn3yOKYf4pehqFahUuivXm9czA0VDcH8ULQNtloKIe29DkY0xcQH6gTvlhV1F5/wwJx8Y5rT98yFLptKnaLo1vSZ/Yu8jgGmVgTP2GG0HYkNdRr0uIb0hWQZf+Zh4DhIGYR6g6MVjw+FtnpMexQHs9rbpsLGsI/Bww37viJVcDl+bJXjCt3i7qurIfxRlf2QybonT49fdtrhNocN4f84Dv6afC6woO1r3KQGXtYkTIOL0j4uHT81SKCuQnjoYBESmhkqrJa1+lvBXwyuAzwNSTZpTKTEDJIcXcuaZFkwjYt8lQJeJzgKhTKw1Kcnjp4X1eKaBYptxOWC3jUgGEPpMnlHDQnfHaKwVCmAu3ItN8DLW59SLo79yU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 10:50=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jun 9, 2026 at 8:40=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Tue, Jun 9, 2026 at 4:51=E2=80=AFAM Longxing Li <coregee2000@gmail.c=
om> wrote:
> > >
> > > Dear Linux kernel developers and maintainers,
> > >
> > > We would like to report a new kernel bug found by our tool. INFO: tas=
k
> > > hung in zswap_decompress. Details are as follows.
> > >
> > > Kernel commit: v7.0.6
> > > Kernel config: see attachment
> > > report: see attachment
>
> If I am reading the report correctly, it seems like we are doing
> swapin from the page fault path, and waiting for the per-CPU mutex
> that is held by kswapd. Since we can sleep waiting for decompression
> while holding the mutex, it's possible that we have some kind of
> priority inversion where kswap held the lock, went to sleep, and
> didn't run again for a while. But that always been possible for a long
> time AFAICT.
>
> Do you have any more details? Is this a new regression (observed when
> upgrading to v7.0.6), or is it possible this was a pre-existing issue
> and you just found it on this kernel?
>
> > >
> > > We are currently analyzing the root cause and  working on a
> > > reproducible PoC. We will provide further updates in this thread as
> > > soon as we have more information.
>
> Yeah more details like a known-good kernel version, or even better a
> reproducer, would certainly help a lot.
>
> > >
> > > Best regards,
> > > Longxing Li
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/vie=
w?usp=3Ddrive_link
> > >
> > > https://drive.google.com/file/d/16xzUrwOvwE67cnMPH3AhhNRWq6hr26Qj/vie=
w?usp=3Ddrive_link
> >
> > + Kanchana, who last worked on this piece of code

Thanks Nhat and Yosry. I agree with Yosry, having a known-good kernel
version would be helpful.

Also, it appears the kernel stack-trace is from before the merging of
the per-CPU acomp_ctx simplifications wrt the mutex, and resources'
lifetime being tied to that of the zswap pool.

Looking forward to more details.

Thanks,
Kanchana

