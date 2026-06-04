Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39DECD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172D36B008A; Thu,  4 Jun 2026 10:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14AA06B008C; Thu,  4 Jun 2026 10:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0604A6B0092; Thu,  4 Jun 2026 10:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EACE46B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:17:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EAE2C2473
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:17:34 +0000 (UTC)
X-FDA: 84842433228.01.33BDAE0
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 40C162001B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:17:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="P8ipu/Z0";
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780582652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAn7tUi15DsxPNLBVxb55DsaCLzi2ItCgQT81dYuAAI=;
	b=TIkf+eAQagLfhMLkbL3He19i09OMpUJNYSOpK1BwRqex8+B4+oQUJbRiOHRV09CBIKkB5C
	VIBORnbK55O51A93CfpF1IDcz4hgQ0y/9WfJXSBSG1V9MlPpjaYuoouZaRWh//UA63PGZ4
	jT/ioqHZGzSTbtsc+rR9xY77KseOdns=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780582652;
	b=rWCXoNDMv/yM8YdIg/i2PicUgIp80x+FCwmSSiA1jGFjyMPHuJ2I2i/dStU1f/RnYkavHX
	JcqhKVq66D6lR4F9yJN1R2qZ+CBoCxys7p+//ChJR1m8IRqCgNO4hba3X8b8S6+zvs/rKl
	QqZ8038Od/CPmIwWjhi705zg4fvQ1tI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="P8ipu/Z0";
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bec429c2bb1so117758966b.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 07:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780582650; x=1781187450; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lAn7tUi15DsxPNLBVxb55DsaCLzi2ItCgQT81dYuAAI=;
        b=P8ipu/Z0URzg4CdVa55DnI0iF9VrSz9CyfsEUNUekvN64O4DkgG1zWwjliuFotWXAm
         MJm0u/1NQ6lOQa51kYw3moBeRwMb2V7tdlCqqWuYLcF29r7UVGk8C/Pbj5rVB/nyaW0S
         DNCoodzTgi65qq6wxLFo3kiX2kuTPoC54ftk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780582650; x=1781187450;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAn7tUi15DsxPNLBVxb55DsaCLzi2ItCgQT81dYuAAI=;
        b=kmr8Y7b9Suy/8oguVnDRSTS3AQlE+X3L0/6gLooNSnFYK6J5uqVVlib1nPs3SH3BXg
         nJidVguYflFejDC2CcOyI12T+Vzpfl639Ra/j6d0qv8gpLA6/QzqlkdSkDUFy8fakBsB
         WOvvJMBsgph2kM7KM2v/X+mRqf0xg0es/QlkwER+FoMD0QGjUdMa35rOX7+NUtIkLi85
         rf6jxtm5pAHC5ya9ovt/mRmYAwpZTjXpZpJ/gr99I6U2KHVuUcng2wIpJPEF/HCrax4u
         nlzOjfyS5DyxvatFfMop2fIqzlvBnoSr4hn4y978dvfzV0Q3pXqyFcvkpj44FGWDM6ot
         v9jg==
X-Forwarded-Encrypted: i=1; AFNElJ/PDJ7L6ywpBrW+tuHCRZKtzh1kEqk/BdIAx5BjOKMYmKhtsjBsp6OvXXo7RrkCi0aB/VZHZqgjgA==@kvack.org
X-Gm-Message-State: AOJu0YxcitVN0IYsxeIcExPJZeXG27zv+IFLc3qRFJoBj+q1TP5/qpwL
	WqRKAJ9e72deUSRQ8A769z3Ep4NO8ZDI6Wa4K7tjTOOpsQYkm8DrvbGKpE4/yhOwaeofbvZKaSx
	UREIf9FypnQ==
X-Gm-Gg: Acq92OHeTe7vx2BvNtl5HtGZ+iwe9UjbEyYwgMHL5lHv3ILSEsYWGYSqHfSDDWNQUYv
	psosGP3gD4+6bEXL+aCT1Yvvo0JDH0vrcMjx2eQrveZa7AwIVhybdFLmnO7kNUWZYPJ2Wh4blXe
	Qfink/hszw8gEWic2rqvhpStJr0oO6fXue2oC2xGGhhTfD6l8CcUOoSrX4dfx0pTlUGouzpgBSp
	yJVwIa5kOWXWXo/2Jv0ie42pSUgcIENYw1Tqq21C6WE1c58hObZDdm6sGVWOri5kfHX+cELH509
	exVDJu++KwNZlknMz/axpbqNwhdsV19fiLRFUk0j/DtY+0OTc/tA2ixbH3nSP6NT1ChycPAv3xo
	yAoP5vDRa0uZs8KYUcVu4MCAMu0BAA2i8U3fYXmoWir/ewJ9RilNUFInWQpToE9tF3d9qhZMjQA
	WRaa4IzGl5K1TpqIA7LlzE1VNpgqGN1G2kTrRqxmKW4qxBe0Ojr8tLrSzojgVpuxEjjQQylb5g9
	j+VFrT7T4H8vvViNjYGeQ==
X-Received: by 2002:a17:906:9c86:b0:bec:40f8:b54a with SMTP id a640c23a62f3a-bf0aed0cb16mr457181866b.38.1780582650297;
        Thu, 04 Jun 2026 07:17:30 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf051d82a78sm308083466b.18.2026.06.04.07.17.28
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 07:17:29 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-68ca6f01079so881532a12.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 07:17:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/ORx+99nWUuuxL1/J0f+puLXzyXoOJkHv5Uk8Ufk+GNAsLQRm1x1cKRu2YJ7PuEABNmknjzOkMLQ==@kvack.org
X-Received: by 2002:a05:6402:5296:b0:670:8add:2b8d with SMTP id
 4fb4d7f45d1cf-68e72739555mr4177743a12.24.1780582648047; Thu, 04 Jun 2026
 07:17:28 -0700 (PDT)
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
In-Reply-To: <20260604100609.6b37f500@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 07:17:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
X-Gm-Features: AVVi8CcQ0yaowxPCFqM7JCGZCz4oCGBQaQ6sAmWXnRpVnXINniRqjS3Vb3FRVpM
Message-ID: <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: David Laight <david.laight.linux@gmail.com>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org, 
	axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com, 
	hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 40C162001B
X-Rspam-User: 
X-Stat-Signature: yqa6u7bgebr79sf15zm18jnf4usxg6rj
X-Rspamd-Server: rspam08
X-HE-Tag: 1780582651-751262
X-HE-Meta: U2FsdGVkX19mk+IwHliH6oDAK3xRFSfGh8JPOre2Knsu8gOYWzhwT+XTXNhLL2IV99IGhB1+H+99AS/UoCbQRdH35Tk2gFM+v3zMCKw9EbltH8Khy1DInG1unu8Z2cExbkK0UbecX0CL2OQddo+CEx//r5b6OE5IHjRPi8oNmUXgjeZsuYWJejQvuFV5MeRODWrcJyFliHyGZT8J4vNzhFNZQVadt0W9AX0S2MJbFI9j9MwqHs5UHVsXUEkT+q9DytyEOl7Q90wKwbpevYw205C4161FMp5t5jRYxncPjpfLUKACxfwnUOXm6XIr8dYkYSAKqGtmu6+ptz7UBXbuuiCwlCLus0QAJOunFUC44zK2T7FVXL+gZstpJA5uge+wWRUDP19Ec2Q03lmxJCRGzJ8QM5Noy1/shSjqo+ncuosC5Vy4xxJB6Go9kDm6nIjIt3SvYpL6eQr9v16CsszUWTyaL73Uz+HTwmx92GavnOMMlLxzvpHZOuzZ9YiVC0+MyOcfhG0WFXTG+KJ9hY8OX/1p83qu+SvxRCysSonsXr8DzjjdBwIVOBMlanw7bk97XzQJD+80AgwixqWZykg9Fhfy21xmO9fGpGUPo2J4iryPaMcg03+9kUy9xIc+JWYDM4ovgUSmKgFPCIQgsSu82Xs3KLKIbhQQ2B+Lh/thTkIJd56FWWrAxmW6YhBJNGTfo9+hhr19B1SP+TUz2P3Jhc07ovjh7lhStvhnkpW+lp07lj5EdMLgGXET8vDQdx48X01EO2HkcRrWPW09P9MCdlIf23HzrAChJa4SY9/pX/njWffOtVac0U2EBwv9lso9IbWWCwouMFZZXWwJZWS8tDGJNaprOZVLlKI4wEINgMgAZXFpxeOMnl/2b6+U3wXORLbSn/D8OUZsRLfOYyWEV/7yA86FKbvOS7PrfXqpDhP48EMt1yfM0A4Zc0TRMShq9BTNrESpSblj/7Rnr6N
 /Auc0lOH
 TOR47yi5wOpLdC40F6dpDWTaDkFbM9r7gwWnJZLlBg80zjUDKLECsIkPj+rNqAI/M6XMTXEYlwo+iE6XL/iWm0PzB8Tkh03+dTuwX9tZgtYMNvqnOtveQBrQJ/ZT2cji4aGT77vmO2P03ycLH/1/b1VuUawfSWPSNedD60h9ePJzrJ0xl5yWrQ40LT9fecLX+nUeqSzIUl1OWgPyLP0dBBryeQeEgjOyiGOkhSCiaPb+d3w+coqm676q4QxwGMtiUwnv8jx1qkJjmH+B8gYXtD/v45I4AQFoK15l+ONKgalGNXB0mVjqMEHJxuKoYG79mS1/lIs8KOr+Rjjd/lNGuPf8CCtFQUi4I0jIS1fCNuIcKD/Js5LEMFX0nTe75fdY+G49TQeYxL7D6X4dgfY1/flZv6pKIlAk0rZbgoPZNrOCyRs7jdiLiv17tkRJYDvMCW8x/az82h25OdaX9tdmBAF2vcHf/7crYj0D7aN31LJotkGBZbCR0YfSJGgUYmvSaw1HWWfR3fZbCTIjzFMlqGIiDVZbljeONEr+5fReJ6l09zf5XXuNtjKXm2rJUTeDSf2tv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 at 02:06, David Laight <david.laight.linux@gmail.com> wrote:
>
> Something needs to ensure that the high 32bits of the fd get masked off
> on 64bit systems.

That something already exists: CLASS(fd, f)(fd);

It ignores the top bits, because 'fdget()' takes an 'unsigned int'.

We have been a bit random in how we declare the system calls in
general, and we mix 'unsigned int' and 'int' and 'unsigned long'
pretty much randomly when it comes to file descriptor arguments to
system calls.

fs/read_write.c in particular uses all three cases with no real logic to it all:

  SYSCALL_DEFINE3(lseek, unsigned int, fd, ..
  SYSCALL_DEFINE3(readv, unsigned long, fd, ..
  SYSCALL_DEFINE4(sendfile, int, out_fd, ..

but then anything that uses fdget() (through one of the helper classes
or not) will simply not care.

Does it make sense? Is it pretty? Nope. Does it matter? Also nope.

                  Linus

