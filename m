Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBE4CF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8282A6B0005; Mon, 12 Jan 2026 14:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800166B0088; Mon, 12 Jan 2026 14:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728E26B008C; Mon, 12 Jan 2026 14:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 612D86B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:43:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CD7ABDB10
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:43:49 +0000 (UTC)
X-FDA: 84324336978.21.B66A35A
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 268104000F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:43:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PE9l1e1Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768247027; a=rsa-sha256;
	cv=none;
	b=0u9bKERIB7xiiF52HoyjqpB1IbcaBqMFPtDGVFjXUfk/sNcx9Ai5TQDsE8LOds2iwK4m+8
	UCww9Rd517UBjlnRjNReTePigEDDttA5LPiVLbWgTs4fc/GZyCW2P5pzBThVJn7KB5ERt4
	ihmvOUedu7aNuZqH1JkU1Zmtt8+WrxM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PE9l1e1Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768247027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAxVjP6c4Om6u8vsm6jVY6NUCkgy7e4h2yG64mnXs5A=;
	b=ApgPfiO49gM348N0ZvpLN/kQ6RHw3lbBmxKMT5YoFd6A5HSPl5TUReZRIWVYOFq+f+r266
	N9F9PCBTzcc3Fs5Nqn/IaKR943HoXQ/z56HKovnpTyiJKxe6lG6PdRpL/Q1tLSADhsgH9G
	bnJndj+A0ito0X/NuVnwlrtZSmd28eE=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-11f42e97229so10475975c88.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768247026; x=1768851826; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAxVjP6c4Om6u8vsm6jVY6NUCkgy7e4h2yG64mnXs5A=;
        b=PE9l1e1ZcwakDjxQM3EDBqNIFalT4VZPbWNQbt6MgahlVHF+Uu78/xEaOp3x9aDirZ
         O4K3S4G2+uFWPtLGxIgg5r8Sll6egL25qGyTCtsR0h200ml5NXqw0M2NGtzXBkUnUVoc
         oJWKMqktWsfx70fypDvR+6CNqSWMqPmZ2z+TLo5agvqR07VxvsDSZn+TRS6NDBChdM0m
         1Fx1WfWUYvJey/w3MpvJriNoriNIq2YQWLUBq7Lpp4WT5S/AFpDTQPBE2RShhEcNmG7X
         C8ipR7Vu5Ly0SLrsujGEYYLUloJqt/2IejpnN9mQDp040zky88lUPn+KlUQlW6p1sXM8
         DXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768247026; x=1768851826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MAxVjP6c4Om6u8vsm6jVY6NUCkgy7e4h2yG64mnXs5A=;
        b=ttUajVzr84HxKtaQ665nZxsvyAQGDCXvvJstUnFr0273JYfw6zJRkTxILKGqIOvMT6
         y+r26sjiUQ/x1q8+ndHhwrmEv0u0DRmrO0AMh9LBefkyACkyvb705ddaIbcG26+pUmGG
         9yUabht9u6e8FRbNtJJOPjA5WgDiMUQykmziCmSrGek97lt1o7e46ghbeoj5aKXcqQz8
         zPiriTs3l973Hc5TOw7KHdSgweUgfa1jEIzD9L4TyPIkv9t5aRk892OpMkdkMqEHia8I
         BOsRZDB/AUqoZSdlOwDOiOoXDbhmtYpA/XMUsgdUTLHKHrpKPPIsbGtmpIZ79EGu8B4S
         qSAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVchBYg4rKkpxOCQBLfslSxj2zPSDoepRvb0EpMjiKgduP7Xj+JVwihEV9Vf6G/BrEmaS1P38erzw==@kvack.org
X-Gm-Message-State: AOJu0YyObYmZC4sE6Tdmj1bSt36TgN1LMriGnqPIrEGCwsWNnD6wpuG2
	0I94qwYLj4H3Z2OiYqrSgTKImMkXpQCiaSQgqBiXlOWdxb+RrzXyTtsQyA+LmpQfMayS7NkW2Tl
	YSMrnO6Iab9ir5npA4NVS4YPMmG7gytA=
X-Gm-Gg: AY/fxX5MjtE7a4BYNw3Mfu/zL5fsM3bbeODrGOZbjinOKcOPqkTTejCv0bBOuecBweZ
	/cCg/3DuUdT3J9NWMgLViN4umD+FGUhv2JyYvJknOl78OQJPfha2z2/GpAhmJZWjVgXeyChHIKU
	r6zBa0K8LjvD8VVsnfc7Om+Oa05Z8Tg5R4ezl0Mtr9KeEZgYWj3DsZRoxHOobd2OwIKed+ghkTD
	PZExav3mByo4PPJEZ+gCYWyW3S1bODvQvzDRHfqGnRwtJXnikFGKidXTxLyB+r7vU/tq0ms
X-Google-Smtp-Source: AGHT+IFh5tn+kU9IHfrTDs0YlDSC03bvGBEomnygmpEiizRJP6bN5S//rn0KLdIYBN2zkqKUpA3Hh5rzgVkX84e+Dw4=
X-Received: by 2002:a05:7022:220d:b0:11b:ca88:c4f9 with SMTP id
 a92af1059eb24-121f8ab9c96mr18145001c88.2.1768247025780; Mon, 12 Jan 2026
 11:43:45 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Mon, 12 Jan 2026 20:43:34 +0100
X-Gm-Features: AZwV_QjnGtbKh0drXweXXMzt0JXRbTQf5yAyudSCZCAyLdJxE_GC_2wiEvkNplw
Message-ID: <CANgxf6xKrawktF4wPQOs08q5Ob9N_Ff7-=f_hRiZ9yKq4LN0oA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
To: ethan.w.s.graham@gmail.com, glider@google.com
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu, raemoar63@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 268104000F
X-Stat-Signature: 6b6dmwe3sfh4tgig7azaa1ho6qtm9zd1
X-Rspam-User: 
X-HE-Tag: 1768247026-16882
X-HE-Meta: U2FsdGVkX1/N+F1vWC2YG0cVGS1KHGCStLWjrIRl5HRYl5jWkTtuv1MxRaBzgzc9FrXBoCnT9Cd5Ix5kzF75Jpdr+EvfFkTJKxTiwIpPZh9kfd/6S+q51ugtMLtCVxStmfWyHioYsNcH5lafHqNpRaTKFF5hjwVeVtfUX2Rw+R7QRTkJ86LyOEJess7gTMeDE8TJOvdNacNIdVGI1kcb0J8NqVicCq5U7PmESbXZ6RONAjc5ZW6/WLS6bpvq4xssXciDuhsq+MTxDRYnivk3zFuQeEQwBfRNcFsgQZpAWHR7kzVXdwYaSucKiyiMwLgN7fjydnw7R6RYFOAUR7ecZGbQZ/wpPcWdgTajw5Q8sVOX8oFw4cX7Wn25qL5rwSqQaM2RWYFa9eB4AqffBW66kZtHhZR7c6mibpkH1x1TKI2pD9pfvFmHyWXrxA2yvI2yro1Ak6e3dqJvKcIv8LqAKtlNF00+/KQvEQRPpqiK50pcW+pNXXdI8eFKC7VwIE6xcgJPIqFiSCQkLpL9r9zj2xSska1vn+ZvOVqdSDSuRrKVmHyPfie2wE8Op8uyoSR0cX7igSrOLpuR24yT0qfyxnqyUKUc+ReuSUeKZb7iCOFhdcFqB0MLeYH+FkTTlqGYtD90cLe+ZBl8YnxycH2B1xEHA0YvquKfyP/65UF8GwxCSAoN4R6DgaxKPM9P//zJqVoUQArgQzGGb2IlRF6U7lR4vk9iQDAMKV01yZsz0XO4ijc7viPoQ9BJhvLsxwg6pGArtA0K57v43Fw8BGtpNYjH/sNh5p2xerv/xf7TfYymGpqhRK+iv+DP7V3sSHj7N4ukkNPer2j/j2FkbfzlUq9OIr4oUbovIOOhgs2/qw8dheZXZ1V+QECIv3iMxS6T4c2ISCMsODOp8nK0dpglZnqSCMWF0aGD1LDRm46qUkf56tW3qe+O4crJP6QUsuJ+JEqmyUs+5cyu7irSiEV
 ssIGxHy2
 TWhBpE9FL7n4gaz/GALpjI+EbArdFaH5xx7+G23ccWqjZ88t0i5HEIpU3gz31vq8DNt+3qgCSUtcsOAt53GTioriqnKwjXFxWFMvuiPRjAyLer3S5EC4b9JWQTBt9u2R09TgY+eeuMbfPQROR0ZQfc9/Pt1d4LgGO6uVDBSG79+T36L5+xEtA393eoNWBX9NUTYBhb4HCGbWdjzZ184AROTC1yQWPYqMBku0djbyACPPCeas5mA55XwrVl0kJf3KsScSzQtEqf+4z+OrTsH1e7yi4v2eOtzQfVuPxW53pieAWFcdTRtFs1DuZxli/K4xaKWISlbLSxl18ilEqMuv5jMiNfKkOYN/GDW7s1VMIMRt/jZJfkytl3/WLW91FBPSWnTccjj1jY/LRqZEoJajzc/L1InwTmHCupcjSZjKEI8NHZg/7VKPIsZrlz7nKE+8STYWaSieoncsNQzzt1TDZtztKwuaNaSWYc8HBgCk1sdqrD6jOqDR01661+H/VyhpQltrn/ivPWFJ0ynm7bUuyoNUBIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>

Adding Rae Moar to the thread (rmoar@google.com bounced).

