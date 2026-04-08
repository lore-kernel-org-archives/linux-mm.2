Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2518B10FC45F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C186B0005; Wed,  8 Apr 2026 19:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE4B6B0088; Wed,  8 Apr 2026 19:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412AC6B008A; Wed,  8 Apr 2026 19:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30FF06B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:36:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C63121A027A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:36:18 +0000 (UTC)
X-FDA: 84636999636.02.D323B57
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9EBEB1C000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:36:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=do3ecmwB;
	spf=pass (imf18.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.177 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775691376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBr1Zc2iGc55MrRjwjFgix/HVG1mDhH1y2K0uZueM3I=;
	b=1K3DwWXSz+FA1t75RZzGzHtk0aUI+9W3htBgvPctjoqr99kGS/eZmvnHrhP+0/c7cboBK/
	NawYapUPndo287EK39Fc4O3Qv1wMucIqn+2lJB0Cw9pSns8dX9OKJS5AThbDpoyUv4CYSW
	GMwG2RPTqhbyEmWNUKtgVBmoJu4iUtI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=do3ecmwB;
	spf=pass (imf18.hostedemail.com: domain of axboe@kernel.dk designates 209.85.167.177 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775691376; a=rsa-sha256;
	cv=none;
	b=7RfEBwsGeelhNnh2Mqb8EleqnYlA7Uop4oMHmTwSz0jQjmRMbceTGdiaZfT6yrgYWkMSUX
	SP1wx/tOXdHKRPolCk+nsLqnHfUp8kJNspFscPMyfTYGpUsdAhwoIhtUiWafIw3dl7b2nV
	Jtt1isNaxUSATM0q1WmIbHGoF5owcmc=
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4670464029eso174969b6e.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 16:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775691375; x=1776296175; darn=kvack.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZBr1Zc2iGc55MrRjwjFgix/HVG1mDhH1y2K0uZueM3I=;
        b=do3ecmwBdV2z54+Htbc7z4jyK5xTdrhkL5osKijDMQgVSIhzCO/5MrsQul451XQ/yX
         MI3MpHQmcftH8qFOTojcl7uI7DYuGr5AgJPtFP2rnPxhLZG2mJdT0EpHiOxiz/WjUgxZ
         Y55y3ax4DWh2vPE2yJKCiYb8J3c7mZQptDdSACl/2yuojBcW4GyDEbCPvYXO7ZXJuMiv
         T47KAcYVimaegI3pP81ADsmcGkKnio0nxYPAJgSDPp/BjkOOKs3pJQ+R/cofV5JMx8b/
         tLa15bwR8b016o4GLP0SE0uGptYe8x0ROSwZDof3BsJ7G9xBJmrL2mBluUQcfuv6Bwvi
         /49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775691375; x=1776296175;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZBr1Zc2iGc55MrRjwjFgix/HVG1mDhH1y2K0uZueM3I=;
        b=HpFCwRnP6MvSQ7GkQrzQJFdgV5k+NUPAfHhwE7ml4cnUMRfR13MtVwVM5NueJ4IPgR
         EgDdBpwVgiQzu5jP4GqINRaRze84vsaM5eW+q0+whlQk7XPCRc/qLUcBB4MRh7mXb6rZ
         XaetIAj0kI0fzxVQ340lJDSa2+8X2elK2XSs9X8u8GzzLBdBm5cHFw+Smg+qRFDXodTV
         EN1BvF2BEERrvW3I0tBWlfAZdXp8/rFKbxxoqilsMDiHzf0ylGG4XB8fr/aoGF3QQVYq
         IMGXYXpnYGOMX9CuQvKkOl8/HgsaBcTe7BgTqUFhetxWXqBKC98IjeWBz70Sa3II4LwC
         tyug==
X-Forwarded-Encrypted: i=1; AJvYcCXsSEAAGKPdLrjAQ+2fvnnXaClKUD2KPHgz6EWRnNbIx0QcjIZc3VTmBPotyhqcVIP3lv+XXfRD7g==@kvack.org
X-Gm-Message-State: AOJu0YzhH1tvZvPz7/jjQj2qhPo43wv0kOWZMOMHqeqFftXdNcX8Ynah
	CEUZHuOizYsvw4fH2ditxFqVSqUTjCROoKA8Iy739OiK28kP5K6IDNTx1fVbJPBBF9g=
X-Gm-Gg: AeBDievwH9b9qWtkJI5VyYmL+8pBbKUtk8mkT6ni4Agzw9F1L3GTW8r+j0hQRpayUqY
	ubj1J6K4AMoRWHAdx+3fXMM2eGRlsVX5mGHEBynvqaTBhNNqd6AQ5oF8RMu3ZuONItgG/7FGxpm
	7+ievzr/zgi5xVlNFgAyqBvi/5ig8blYQgbilUeLVcjm2HJixnT4hZ1TQQjEx5uo3QbOGU6cAug
	oaDlBsDUiW+NSkkZ2KHZtXdTCTQNo/3+hLgXFYqe+VHg7AnhX7ItTkLTSEwaIaJLehTItvXbV1z
	GNKDhV15wQ8IlUxYNwX+oL+QlsSi4CPuhzO4ZXyOQk5zAH/J0kl9hWWJSaeyTCcV1SKZavnlviI
	QrX3YMV5M90lRjA9hoUb14HGIaOX8NdGIMmVQ6oTWeQGIkpNH1Wg2pobaPLEyXVj9iYMZ9XHLXd
	/aIZzezmruCd53ziAIAhltJGnrQspD07N43YceWTGikTsm1g3RuKd+QNfGhga9XqjlzokP0rKlz
	lWV9O+CgSPeTHhkhrUJeS1+EQ==
X-Received: by 2002:a05:6808:1b85:b0:467:4939:9666 with SMTP id 5614622812f47-47724c79cb3mr898927b6e.47.1775691375433;
        Wed, 08 Apr 2026 16:36:15 -0700 (PDT)
Received: from smtpclient.apple ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46d9387a763sm12681031b6e.18.2026.04.08.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 16:36:14 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for task-context completion
Date: Wed, 8 Apr 2026 17:36:03 -0600
Message-Id: <95F28FA1-5CEF-4E80-BBB7-A429B4437D12@kernel.dk>
References: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
Cc: Matthew Wilcox <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <97b81868-6410-4c79-a242-679a9f04f073@columbia.edu>
To: Tal Zussman <tz2294@columbia.edu>
X-Mailer: iPhone Mail (23E246)
X-Rspamd-Queue-Id: 9EBEB1C000A
X-Stat-Signature: u1ggeaus9s75gh743mz6336gyc3ohq3y
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775691376-571592
X-HE-Meta: U2FsdGVkX1/4y0bxNmV+YyNqFmqiNVJqsOFRPCBSCVUu0Ve4ZQsu1ajnCXMZ7wYxSiTlNwLvgAppUwG/cQgWwhJJuQ8O1VxhwlTTw8I2M1y5FnGo47jeVqxsCA3eY4FSRzG4pngEjXrXB+ijj1GnYjfxJ7yZw+8/INQmrtS8kiiN5OUOYt6BPs+oKbB7kzqNZtaNFUZ0G1tNJJSVRsrt4nGWLnj9FpirGBe7zj4wzsdghcuRESSDtEg7HkqNNVafVH+5y8ami9vXJJEL5J4M++AtLlb3aGVHYXMOfm6mk6tYv1u26OUsw6U1gcO2T0RUWPpV2SwMUVRNPeI8+oQwJGCWXXn4LFYL6VeMJ0pktXqybSixu97/sQev1xdJrGP7UQ+ndXuvHyk/RA9Ba7Rz5xLnT018Beh0jjiZLw7HVChwmB5Uz6WYGfPgNyCXaxFzkB7DgR8k6ppWusMAnBBmUk/aVWmMT50PndzKTjR1e5AeikYfen2PR7hXLPYDcBa6OFb75g6rt6JUilYisd1bnVJLF9XhVp2JD1oBhsT50RHXxszRG3ADc6D1TOhoopUuhiyL3J7D+rpi8VV5ZF3JfOu84ob+AEg0aPQTh6UILFTkSjtfBoQK990sYrNW68Md4cV9JcWFbyyBmEQj/CL+HnLsG0TJ0/AuyAVDjkobJOYtsqNAoyPeLVf6roFYA4zS0AWbSYeGgZel9fBeAL5ANJt6qMQgVtHToc2T86gPLubMhQU59UqAo+vJ5MgRAjpvlWbYch11c/u7soirLpj6KXaebw7wDuZqZ9cCl3zfQykUAcxlyOAquSmbQufuPCjQO+XGwZIwjfuD4nIGaU5a4QeX0eUcwxP6MDzofxt4Idsr42EziX0FYlXoPSPbwWPXIO5akbzmrEsrneGtm37BHPckWJic7BMzXh/B44ZL5hl4y2EPfHUKOVIVqZ1e3Ya2q2wEB+uyaZ4JOgM/x9m
 iiJbpsZn
 /Apik51oaI+mml+Sg2jRJnW16I4HvoE65T2aieZYenrtABrQH9QCFDMlzOMoiHoQmHYgCyOTTZyy6xyOKmYKDJWfhZQgcA77MEccvPGHtHLfz3qXtuOguQG9EWwst2Wkgu8QZLgx92LsoZYz635s5Jwbxo2mKHX/WK74NjX03vLWWElkxftpoaSeF7uxGTHXG3E5lYyzruWZT+ffrGF2wPk95fBsN00a9Zl7jzO19gpX9VtPtNTYHl7iUkIaCJSgXN+2u0n2yQz5srxB7ssknraHfYP9h2hQX/1zkZd9RqhqwD/ymm+j2a7LEbor6ftOBJsM9cj9uey4mP2kUt/F0QW0wgl+QbG31jM1LwlXpyD96Y9xFjZ9bTmmjELNZgUtTQd+NT1atvONzwTDp5e2RqUhMwK7FbcyIa5EVRWYO5t6Cp53PH7xADsW4PjDY1Vr5NBhN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Apr 8, 2026, at 4:51=E2=80=AFPM, Tal Zussman <tz2294@columbia.edu> wrote:=

>=20
> =EF=BB=BF
>=20
>> On 4/8/26 3:51 PM, Jens Axboe wrote:
>>> On 4/8/26 12:=E2=80=8A48 PM, Tal Zussman wrote: > On 3/25/26 4:=E2=80=8A=
14 PM, Jens Axboe wrote:
>>>=20
>>> Thanks! I'm going to give Dave's llist suggestion a shot on top of
>>> this as it seems like it'll simplify this nicely. Looks like that'll
>>> involve turning bio::bi_next into a union with a struct llist_node.
>>=20
>> Since these lists can get long, I'd keep an eye on llist reversal
>> overhead there...
>>=20
>=20
> Going to send v5 shortly -- tested with and without the llist reversal and=

> it didn't seem to make much of a difference. This was on a single-disk VM
> though, so any stress testing you could do would be very helpful.
>=20

With all due respect, a single test like that isn=E2=80=99t going to be that=
 useful. I=E2=80=99d be wary of making that change willy nilly and just thin=
king =E2=80=9Cit=E2=80=99s fine, worked fine on the one case I tested=E2=80=9D=
.

=E2=80=94=20
Jens Axboe


