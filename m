Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 897AEC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5AA6B00FF; Tue,  4 Aug 2026 12:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887B76B0101; Tue,  4 Aug 2026 12:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775CD6B0102; Tue,  4 Aug 2026 12:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4867C6B00FF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:30:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C492D4023D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:30:30 +0000 (UTC)
X-FDA: 85064125020.22.C54721C
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 493EB2001C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:30:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VbnY2bNe;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785861028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbQ6lDHTycyG9G0iriLV5gjQixei6LpNvUvf8igOrl0=;
	b=EuN1c8sKuwIPzsQZSLWCa4+nMbEYMJnbpO/4Qcxgm4Sn0AmILpoQdH62/bJplKUJcNs+64
	cZVesvvLuj4/xuE0OgpUQZR1Kp5kzeHZ5V4yLXquYV/V20itYDmqYBrP3gyDYklCqLlPbr
	gB77Z5qoIIu7QmdmtJEyEVKnYF0gnPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785861028;
	b=gxik6HeqHzFwAS7QppxFJHgvqJNKzyKcuR55nr9w9LudtIrpbU3qZiXN+dQaBJXT7yIrrX
	ubN6NekHN6rXZryYM7z85qBDRePSTge9wGu2s/bWaECecAXAyuFfSmjpD50USUWZEdyuWS
	JSyT1wIwUR98gDDEiZTc82q4xaWxryU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VbnY2bNe;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69fec980a30so5535826a12.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 09:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785861027; x=1786465827; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NbQ6lDHTycyG9G0iriLV5gjQixei6LpNvUvf8igOrl0=;
        b=VbnY2bNedFflgWYbfxXyqH1Reu0swiuQ7ung/pXabpFRMu6BKBpm9K/9YcOYIE94DF
         fZt5a0+goM8gh1vDHee3DZj8PDZ2lzjSgdmBvv+VPm99eJq9NhjaIfQ4cnX3qtKcpIS2
         ERkf4D//E3mwhkhn+84dcjlPDKLe0FlxslwO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785861027; x=1786465827;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NbQ6lDHTycyG9G0iriLV5gjQixei6LpNvUvf8igOrl0=;
        b=YBIxCOpd4JZSlnoOSz/KzJjXbY6LA5ima580BhNqfIDlnaHzzb/VahXxaDD92jBXRj
         WR7U5VWXyqXatWY4ZyKuV3Q5Ss5og8Q2z+k/F3Y+/DJqsM/2Pdafs8n2KwfJAE5Bh1f+
         pHCYCg6lptcgpFX6nlHcDKulEgV1PxqTl0vgWpB7cmKZG1ZuGMojEkUr99TYYqQxZoNs
         PVIOd6jT3O5ZE1h2YYKIQM8x9eEIk7SMiIfYjQ5S3+1qdX4ISCZ9z388wBYCelZWCFuB
         h19QnHvqlvj0OUDUHTPazWg4Fc3zTjvHa7DqejrfL+JK2p8o9gYO6QutCxAURTxXCVaL
         OTbQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/bf61eQf221ZsIlW26U/Nt+LOWdiA70Ujg/Wl6PUjD9P/ailP/nhMfLEYgiktDlbbZw4ksv+Fwg==@kvack.org
X-Gm-Message-State: AOJu0YzDo5ChiESUbPR4ucgTIjdKxYvYfQW9OC/yCFtFmbgB718Wbbjn
	Nbrv38FDPFT37Peoew3/rP27hsT3JbshRFjncumYlyaXZ1zu3nKmLtMUuCgHvuVZcqpavyoIpF7
	lWVdHixkSzQ==
X-Gm-Gg: AR+sD12erat5emBwrOUyBrgnebOstjYVZ9TlE5nl9mtOxQUs1KDQCox61iB+m0oNasA
	o+EKM6iFIEmey+3ZtN/oTcwxEerYQTZ57tU5G+FMpXoh4TMyB7n7FGfYBnQrGrZ2iIOrqGy1h8G
	ELRyaTCeQqauBTGIY6+q7iM+5BgrbQiXP5dlR1FAVB35viJDFDC4LLHxtyazNfa+4UY/zyhW9tV
	e+s7iemQNhT6LTvf3V6Jl1Qj9H7yrvGJN2R2V1NtUvARblbtYbP3WSNyI1wK/IhS1u62DjfuTjJ
	Zh8PxAjWU7SAhgSv8QM8zp4MHoP77MddjA8S9qfQgAl6gp3jLhsUm+Ez4Hh7v4Fog+JYcZaMbAO
	zqnOfCuczBZMQdViaEHEg8BmWMtBLvk7RxE+mejoEXDmFIgvWnItmKYvQBxXXlB5SdeQomyrTwF
	esPY5jf+FBcFRenCatJiZ3kPEsT5G3G5pebKZ1VSLxVzYfJZNLCC9QLHcADakIteInWQejT7+2O
	229BeZKoUkj0ChgHOZdxP/LRM0zL2DXzN2doQ==
X-Received: by 2002:a05:6402:5053:b0:698:e595:a5c with SMTP id 4fb4d7f45d1cf-6a14f09b191mr166689a12.6.1785861026645;
        Tue, 04 Aug 2026 09:30:26 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a145c28149sm323600a12.5.2026.08.04.09.30.25
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 09:30:26 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1671ec8692so17342666b.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 09:30:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RofF+WMBsxaOFjqniCZKMEBrJbzA4NKvCfYauQ8pnDIMrnerKGVDv3d3AMMkT5WPgb2In1wNA/fAw==@kvack.org
X-Received: by 2002:a17:906:259a:b0:c15:e33b:8c4d with SMTP id
 a640c23a62f3a-c1fe7f0d60cmr1115849666b.4.1785861024819; Tue, 04 Aug 2026
 09:30:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com> <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
In-Reply-To: <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Aug 2026 09:30:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
X-Gm-Features: AUfX_mxC9iiWxGkQdgQGlH_dpY4ketm4ONzq0gdfJSAi_GqCpD7ENOlTAcBA6K0
Message-ID: <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Yang Shi <yang@os.amperecomputing.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, urezki@gmail.com, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 493EB2001C
X-Stat-Signature: rtuihsqgk71pmr54nt11j696o98tog8g
X-HE-Tag: 1785861028-315377
X-HE-Meta: U2FsdGVkX1+CsMYUBXWzN5KaFRbN+rkkkCIcj7RZ+r81r6eENm5P1WY+0b0Sdznb33F3h7zmSLnDAxxCW9TYoL7FtufPXJ/eJCd4GgZ2g/4n7AuzEPms1ldfuAN+6aJ/7r2lvriqYGpE8Ikt+QixAUpxG0Yyc5OvXCKS5AZvT+scHRb0n3nmHsZ4uh8rTLKifE07C+I2Q3/GMgNPLSraW6EaFiIfbgARkdGhn8Hcr4ymWsxqcZH1clp20Na6vveFTMKZy3a3L+BJ79h+qpml2O6Jrd+OSTRKJylbCFu+44jxmgBv2mrkCNFzhfTiodUuM0k4VWJATDPaPdK3Y1CI7rjZLru9wH7sk4p+IUFujOyRzvwvyHtcGlveh8zw6dYunSLvd9ulenIGKrTX8TTsnmuzOO6B2JYFmmmKKML3y6sYUoKtkZVq/5oshOiH4+gwEMEYq9SbAm2hJKy8eseOGSri7O+nSS8i99Q6jRCw545W3a6gkd8SzECm1DaAJPjykBWdt6/xPDJSKc7zbLmTcEUhPJEdb0e6kjSatcfM1Lvwps6z6d5qi487GLi3Rlnq+7M6QIH/cv4wJw4Ed/DSSS/DIz9a1bzdY2DvWxfMbMTOQfbChJvZg+EeXA3Vmb29RT6CQOm1+h3JZvdIjW/lqIkPBfo0sqgisj7OQk2UaG5bPSxF8xcB+X4YrL0JHFfuCEj8iLuYnKS5QOtFM8lmaSPvJd8M3mlavEBDaoPYz1k96zxmAO5n1Jn2BqRCsPrj9QeVkDFtWJXzu2l18LkMZfaA/N6oUBor/qcOGQ5kZ4Tim4YhwEl1ctC1uzEHqyACpiDLNxkK3NtrUwRigARPVTpNBA0mvdf3eZRLXKvWhTzbGRr30Va6gFIfilkHFbViZ28hhtqkBtSfSZhVey2XtbMfdDzlWZvKeuHCb+cQf6nx27I0WtFYbtp5B0A0DtgFy8mxQ4xj26d6FTRXNId
 rb5JHVk5
 4ae6ZYV1vN2Mes/o39fEp3q3+xaI8t7j0H/ec4paQRvf6dqKC4KK1sUqxCjT5OFFT3FufKIUsTWlHHQp7PnwXNPuZtKJudDWYvDBr55Mk27CefkxPFD1ppG5sBTia9YyXLVVp4EECKyp7+EGmtlYoiGaug1y+c/HU42n/9FAnAsTXvv0KtRT1/o7dmcDdv4qaaD5ROns8Uncx23dJ5n3oZ0AYOhYW8HxbGKoHvklV2tTsCuGuIvuMosRlL/eb25oiSlo5rCk9Q+17/jwPPPNBlX9omHs4U0dWHMZ7zbPtwLqFHElCwMx834FMYNhxUEjWBd2yK3R2gQa9ISqgRv5zxJLPXpQMIAjP/LYO2JdTocy1Aelc3ZSEihnBtp+q9XOQjXu8IN2IBlJnL+PYYjM9UbkBgCWsn1G6KsWachcDsPMBrIuVU3LV5Ndx9wnnNZ2bEcUTHHT/1VR09nLolqHGhHngFyu1yThj08ikzuY7/URq1Xru//XHFjuwPNrINshDoHdLtiOZuR68CVvfDHVgYMYtWeB7aA4fFArwlnMi90inLr/4aovFye11IP2otDoqvemvh3o6SgDkQQxRG71WcmDxVfeGAy3bbCqXdRFvKoeU3fJOLb0R1DVuOiLUUcGfWF0L5VqlDawNxnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 at 09:27, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
>
> We certainly do not want to replicate that approach. We are using the per
> cpu page tables to avoid address calculations in the VM that other
> platforms can do with a segment override.

Right, and I said that that's ok as long as it's a internal
architecture thing. Not a "this is how the VM works".

Because people really have wanted to make it a "this is how the VM
works" thing. And that is very much what I object to.

              Linus

