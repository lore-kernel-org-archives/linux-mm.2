Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E403AC5CFEB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 23:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5846B0005; Fri, 20 Feb 2026 18:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78B26B0089; Fri, 20 Feb 2026 18:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84FA6B008A; Fri, 20 Feb 2026 18:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94AE66B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:47:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3249513A915
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:47:33 +0000 (UTC)
X-FDA: 84466474386.28.AE3AC10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 42BB0C0002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:47:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kQxKhUVz;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771631251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52l3HcRCCVzDct9UP/tq5Sxv/658z4m9MNZ9dAv2u40=;
	b=enjqb/N7j89Ma0U5QBW78Rb4il/WNM0vPXkQHUV+wNvtH9Q0Y6F/NIH5J/Q+9dxm1iKqqL
	SprdEN5qkgAOM3F1NxTW8YiRXZUukCvZZcP75TduQcsxX2fl8u1lu2FyqRjRi8X/VpeIA2
	erD2hAbWAOGX4f0Ir4z9hguC3FToSi4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kQxKhUVz;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771631251; a=rsa-sha256;
	cv=none;
	b=zMlDgY1w9hu5Qo7biDlOkHPC+Pdh13ddXJUbegcVQtmExCS16MyPurBqIQgtVq3t7fWZ87
	sIOfKaz/TjZ6+RXCxyBA/Q1mo0GRr8NHOs2HiAYAkL+BJJEs0P6vM+XitMXqu9h4JPmCEz
	PTRqCm7zahjUHps9PyeMOBs0ydWS66s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 414D642B40
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228CCC116D0
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771631250;
	bh=TEfsjMPb/jlmR5aSHobOXDJsvNJfwa+RkYYFf9ntIZY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kQxKhUVzu3bemsQ4B8trXOEKP9ZEUG4xIWBbJThKiQJJnXFgHx2JzmGHfQ4xHHg7H
	 iMZP3BrC5LwEqrCB87peR57E56b1Fuk9BItIraeHDHy3h4y0aUZ1wuszp7bUdOyWL4
	 fYxgMaqwp7uH9lSwqJP/ffpcFtWs96vq/CROEPx+l+8ALhk2WHmgxUKHfu8ZLGKerS
	 xCmWe97ofydvLwINyEhtUjFVLFFjK9N3qQZiCVtterLxh16Mgycpb8JjhQHilgr9C6
	 Act8YQ6n6lZMooWa7EIsFB/+rzAlamJpZqhn5rceREK+VITjpOz8zwrfzBcqrcO+oe
	 4IPYvEayqXEyQ==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7982c3b7dfcso4386307b3.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:47:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXFJlLN8emD6scItvcnnuvy5sr6ripi3HmVyd+NfDwPUdPwfEWdP3r4+E6t82xf8iNLhb9GeEStlw==@kvack.org
X-Gm-Message-State: AOJu0Yz0jWlRK9DaTj83jgt4n/nL6sIQKEzoU2t14zT4j8j9iaDL0xK3
	AAxMjjwjfg3ouZtcMrm5mWM/jiRgV5dwBOgWJYKeQ/1GqUSny/Xm76J3uI/cE0/7/NVhaWdUr7X
	y/yEZBSTAY0aWTfgfwSbx2cUThr6sr3Cz2ycYNJndJA==
X-Received: by 2002:a05:690e:e84:b0:64a:d64a:b023 with SMTP id
 956f58d0204a3-64c786d1518mr1440870d50.9.1771631249437; Fri, 20 Feb 2026
 15:47:29 -0800 (PST)
MIME-Version: 1.0
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330> <aZiKQwT7KjWDLspH@infradead.org>
In-Reply-To: <aZiKQwT7KjWDLspH@infradead.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 20 Feb 2026 15:47:18 -0800
X-Gmail-Original-Message-ID: <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
X-Gm-Features: AaiRm53Kmjj9af0xHbs1ud4WI6Vy26F9eT6AQFNheNtu3wdIw09752yMd8lAOIc
Message-ID: <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
To: Christoph Hellwig <hch@infradead.org>
Cc: YoungJun Park <youngjun.park@lge.com>, lsf-pc@lists.linux-foundation.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zt79znhz6qy514cmpptru5u1fmfa5mgd
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 42BB0C0002
X-HE-Tag: 1771631251-966772
X-HE-Meta: U2FsdGVkX1/XDZUsMeZBKDJVshpfe9rYrki1QarwZtCD5BtEH7PIExEQ8g8Mf/SvNKdWy88sAkXRiYN90UhE6HbwcZ/u0tqkaBnsTE6gH4wGUZzVILExii//ahrD6tU1dELkRIxl4OlI8uOCHq0xa7UjmkA5aZdssASYPu04DlCVYV47sxDOAKV4MfxdP+z06I+pH7M2wBN/uGrX1i9DSIm9/GayrCxzK81GQbqAliIv2kVNJK1ppjTsaAR6lA4IMBAiHdzgv63wLG/+ia9Yhzli680FKx3sUO8lS/i5hnpHFHpCjXETTC5J5uH1b1eATdu7AWpTqq0GUXI1ynaZ+JSREhsN5oxiYm7qx42/nzcPSiUwukLc88yqH7t/cHZDCBM94ezdIKNFvuPlxwnIKnA8KGZITzhCgEXu5L4UD98JcNk7RFS184hZA4IyPTUWdErjMibS6Dnwh+mAMMv3+29bz1oLvB/S36Z8zwSHNLEhrtWBseP0QPujLVWMfF+0wsDLxzikp9JwGaYGUs2++l5a+eDtLd+uNRKiQ1qMU0z/UjKpejrgy2rY/ITXfgh/K6dGc5pFOjaU80xzmLvva/Ao6HV2zHWAnjGa676wuEqUIrLD7dGM+PWbV4KFs7cSx4EpTX8bW01WWLeiJixRHBgaQS8WMFKmS9etGWpNiwoT/UEzLMwLgsUMv6GnEripwmhOkfs3Z7Gix2BhQpZTirDqU72gUgt90IjqfwKuam0Cj9WX7aUTrtnS0wzyqoL1axcpsTPB4ZGzO/YMw2U8BVYs5bKv+5wyU3Ayx/0BGxYQIMV1SJJoqFL4EobQesYx3s2A+H6gRt2hLhbXUTgIpiyjdbgheuBIb9rVY6QqNFNqc+xshCv9LAMAzDc0AGWxe46LHn17B6eoHHsJSNHOXTQ9GQPUtW0HzOyritfjlV+A+zMeUUXKzcHBZMsRdxsm/QpQ+eqFLpJb8mdxVId
 eZutSzEh
 5PSzUBYpn+J0JMkTp8JV3JaGRV9FZYj2nd3o0hrtg4jYkRr9kSU8J28d+O1N+V2ZoDmYQ2KeS7X4W38dAPNrq7KriFaUPaQeRB2NKvH/GW+3Kl8BVWhh3BuaUHh329B9tfT1ewYc9Q5J1AxiktnyWpRRzvuHLCUSxsVomMkpkKrt5fn93XllSaoKxXyTEuk+0EKizrbwIoB5PcyMrfzoCLurQ10vVt118TZO9MwQBAMLMd8An0y6rMjkbrGcZXNvi9c59+C/EMUY56JNmi+gSyxln+VLaUHBiq73F3Mc5fLVAtaele0WNCe8TUhOozTgovT/9x6gCJ/EUPTLjdLSIT1vmmQXRPFxDHYtEJHRylM4IvYw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

On Fri, Feb 20, 2026 at 8:22=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> Honestly, I think always writing sequentially when swapping and
> reclaiming in lumps (I'd call them "zones" :)) is probably the best
> idea.  Even for the these days unlikely case of swapping to HDD it

For the flash device with FTL, the location of the data written is
most likely logical anyway.  The flash devices tend to group the new
data internally to the same erase block together even when they are
discontinuous from the block device point of view. It is easy to write
out sequentially when the swap device is mostly empty. That is how the
cluster allocator does currently any way. However, the tricky part is
what when some random 4K blocks get swapped in, that will create holes
on both the swap device and internal write out data. Very quickly the
free cluster on swap devices will get all used up and that you will
not be able to write out sequentially any more. The FTL layer
internally wants to GC those holes to create a large empty erase
block. I do see where to pick up the next write location can have a
huge impact on the flash internal GC behavior and write amplification
factor.

> would do the right thing.  So please no conditional version that need

I agree. There is another LSF/MM topic related to this, the plug-able
swap ops backends. I hope that the flash friendly swap layout can
implement the swap ops framework without conditional versioning nor
stack block drivers.

https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/

BTW, I am very interested in this topic and want to participate in the
discussion.

> opt-in or stacked block drivers, let's just fix swapping to not be
> stupid.

With the cluster allocator and the recent swap table change, the swap
is a lot better than it was before now. Anyway, feedback to the core
swap stack is always welcome.

Chris

