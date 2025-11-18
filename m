Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6392CCEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:44:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF3B6B000C; Tue, 18 Nov 2025 13:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6F96B002D; Tue, 18 Nov 2025 13:44:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3F96B009E; Tue, 18 Nov 2025 13:44:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADD86B002D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:44:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 369081DCCB3
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:44:13 +0000 (UTC)
X-FDA: 84124602786.20.11A9405
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59BC9A000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:44:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GyDc2cPe;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763491451; a=rsa-sha256;
	cv=none;
	b=sSQDL9UFm67K/p9JZaaolHowEGHugPcxXmIZRBUMBejlrwRakGk1qa+9W7Aj3LTVshNqBz
	2sPPQO9Ax8k/CDhfIO87xGyDiTce16cLUhysIyltQKqFqGZwQ/lY2jEfqS8P4xE/I5Mspo
	JHQwxLoOW93pT6flNDeSjpO98AYfcW4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GyDc2cPe;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763491451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNBD1uOYdTrwPFhiIMXIlOxlGwv9kCEdaRQKtjYTNR8=;
	b=CEQnUR1xaI5Zsf1nowOZTPxQSn6TeULyDQMFCQyZv5koa7V4ZtNPij343OmEdwNuvu9QpL
	tqRIlqqHy+2zcbKowERIIjGuVcaLessnQtK/vw5CW/mCcLVhwaaAxgCSgp2X/ad+19nAPs
	94n+JqjRBSn9IjY0t4IhHvSU5oJW2Hg=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so530335a12.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763491450; x=1764096250; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QNBD1uOYdTrwPFhiIMXIlOxlGwv9kCEdaRQKtjYTNR8=;
        b=GyDc2cPeUY8Yro0VOcXJRWK7OWYt/5rMph5sWgwigVWLwi0mDG6WKv/qxYummhH6Gt
         hOoDUQi0UyQubJT+HRZMCkm7dmr6e9yG1PJ7g14c0g/5nxec0cBcgza2SApvHKUuiPkS
         FLHVQiFSFZPKNwI7cFzy3i/zGdE7I754pQqlpv53yLADNBVP4c2KdjBAlsixkixXpWby
         tjnfx6NZfdX61mi863j+zOIJ9SVkxKuMD1dsJnJlqnZtBmpioxaPRP0shtEqUB84bDjr
         A+QGv2eHnXO4zFwyyO7ebj1vIlQf4874eODWQk3Rcg1Dsoa+aR9csBJ5bkYb69t2Vyzj
         naSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763491450; x=1764096250;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNBD1uOYdTrwPFhiIMXIlOxlGwv9kCEdaRQKtjYTNR8=;
        b=B045Sfrj6RemS7+IT8yWM2X0GCrR3Qai7mtrwzfkr6wr0J4DXP96mau0hXrJdZ0sUK
         4Cfvz+9LOX5LKwIKWYInsbXEGCUyoFDs/k7kCKM7vOBBns6PHU6RRtqUALaQ0GO8fUOF
         GeGecIjXamB1DqvAji8DUoZOeyhXtPG7qCZDmT4G9YtPPxz0u0qp4LPbB0WdM3xAFbb6
         ZFfUa9cJmCkvneUZG4YePCFt0+88eX9DOihIDlR2Z1B4jSRAnQorJ1vebXOThnHW0Ubl
         6dTGM0YVRT9aI9N4ad174Cx4v0x206NLh9QuK+90UeMKlHpJZ4RqKJqCJgNS32pFb6MB
         R4Lg==
X-Forwarded-Encrypted: i=1; AJvYcCV9Jo5+mjtSy3Hgad9maTxmHbeeq0pEkWZ6NsGYWL7kS4WTjwF3B++SW/D2+jdEf42KPJCdsCKS1A==@kvack.org
X-Gm-Message-State: AOJu0YwQqn1HeBIzNnaYi6ONZz2PH217JF+gDlrUgg5fCtW0R/niwLu1
	fUIqOyzWRV0ZshW1tnAPs/bwyxLpKn97OulhhB7gzn2NEfxsAsxqyUUptaIekYkZCVAPPId3gwj
	X8emSjLPE2qsaF5H9mKXChPqYUYfdkq8cKVsKoT16YA==
X-Gm-Gg: ASbGncspwkZ7XeRFyASXcOpOVHtFwqtpMZS6DiBVd+Xz5Tg1rmO3AN0x8oeu6qpjv6J
	3TmUSQ96QbzGywugoEaNPKqANo9u2YtT1Ss6awukqRCUTzbfIa/jnB0D3lBL0IiusXwSa7xgM1C
	THSZC/b2ZL1idG88GCAdmJ522f3HSDJFQepz7EfJDigI2xSH3FVhSdo5K3vSf14GvxUmYGmtMIX
	zdr5MUCyrb5wWdkmpp7cyTKlgmp5W7TXp+Y5I9qg7Rb2hc6JDp9cW0wimty7sNQlbvH
X-Google-Smtp-Source: AGHT+IEhUz7TtqzijSclhrRy4JTnMJo1kISMx7JAXBX1eo2l1LTuJlrlAmWzUxSKux9EXl5fjUpbnnV5TRFPrOucoPg=
X-Received: by 2002:a05:6402:1456:b0:641:1cd6:fee9 with SMTP id
 4fb4d7f45d1cf-64350e045f9mr15717357a12.1.1763491449779; Tue, 18 Nov 2025
 10:44:09 -0800 (PST)
MIME-Version: 1.0
References: <20251118181811.47336-1-pratyush@kernel.org>
In-Reply-To: <20251118181811.47336-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 13:43:32 -0500
X-Gm-Features: AWmQ_bmXkul2v5wS8yKC3okGvxsFI_LihBKfF6ZewAs9SUHa4l8gzAdSMkQR3AQ
Message-ID: <CA+CK2bAumctR3WyDW0b+NeeX22+OuCMkQ2VsGvnE1NxJwOVPEQ@mail.gmail.com>
Subject: Re: [PATCH] kho: free already restored pages when kho_restore_vmalloc()
 fails
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 59BC9A000D
X-Stat-Signature: asn4s95xihrnbsks1jewe6ioann8wiim
X-Rspam-User: 
X-HE-Tag: 1763491451-713306
X-HE-Meta: U2FsdGVkX19k5mEsdg3AF0qbksX2tvXnoLVjn1ZjjZ1wVI+BPDvRL4qqC0wzBh5k1VTdM/f8SJK5VIQRk+8OGSlkwD2qgTZHS2UpWvLP5FJTmo4VHB+2vrh6dQ78lnPPJ6LkdRAJ4FFTE4hlQofEBAu115cYyo6RTjGC/PEEYpx8iw25o9/60bBYjNQxxmtQaf49p1O0qYqZ764LKtjqywsmcv0pqt6tLl9MXHJkgZESLcFZCTJXBooaBeFrwB4szbUqxwzo0QjoToJDN7hWQ4mHFiOPlsFcESOr6wAEM7a7RjSlGIVoDS00GUZWrtviSunQQNlzDCqflnpAw721G7vg7Fee34TwSs/jilaqcM3Kg1GicjfXCxO4YR043o4ZvVXu0GoYYd3zl6bsfglPhM+hH6/tePz9DI1JFMAuP5zKrhF2g+ISL59MySyJYIYU1krJxY/i7EMIpn+zjSRvj3QIjY4eDiZbATD0Raoo95h+HlmzO4XEP0+MXXpRReg7YRl+mofAWD0q6SzHve9oxiwRhA+q+LN59PXXew//ojPzWb2N3S9ylYMZIja5xRhO30rRWcgYOiPC7bj3EcBxneVeJI9x+K/EyxfEn37iM+DGfn/Me+rlik95Q5JkPfCihnuGzJSwbuZNZmwcf1d8cUebI97SSS9wXMpVGCFrFF5NK4yNbUWzAkOMXPPWvd/S4s+/OyYAsKN4L/IVg0D5C2eycM4kdp/qzQ18wa8a2XFuiY0JLu5SIUV81RBChFyBt2+uksbRBP5eJVxjykWlfRnN6AuFtNc88YkXV56bgBqs7QYrcgW+8DhpzIMdJofwEU2M9C4rG5KgXrcKmbkn+M9916ygfzrSGDqWIGOpmznNMR3/vTfFCT0w6mqW0iqFMqjUw4nlryMSQ2ZR3wla8ju6rOL0YeOpifyTma2cQY7mkFdpmqG+zwnh5Hy0W6gkeP6ho3z+eflI6AnDmz3
 9b1z4FCj
 aTs8cKVhABpwBoeAHAPdumQ4rKHlox1TZ7lcvjiAwBpH8yk1CEeAXRvNKECVlOdf57bezJUZHKbjm0TEo85CUhOCdUbBbEJnu0Up2i7+NOJV6shLxN5I9uLfDX+XL7hN6jRTbCuUJwmvWrFTCLBYdxraRNS5lCGkUfhnGAMEIns7HnZsVx9X+C8Ou3a+YGrWJmAFlBX/OgOMMCYyXwxao3n3x2Xuq19QP2AEEA3NjCA5IVbtsIqsIGDdr7JZkRvM7qGgQpHef6LTDhPw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> When kho_restore_vmalloc() fails, it frees up the pages array, but not
> the pages it contains. These are the pages that were successfully
> restored using kho_restore_pages(). If the failure happens when
> restoring the pages, the ones successfully restored are leaked. If the
> failure happens when allocating the vm_area or when mapping the pages,
> all the pages of the preserved vmalloc buffer are leaked.

Hm, I am not sure if KHO should be responsible for freeing the
restored pages. We don't know the content of those pages, and what
they are used for. They could be used by a hypervisor or a device.
Therefore, it may be better to keep them leaked, and let the caller
decide what to do next: i.e., boot into a maintenance mode, crash the
kernel, or allow the leak until the next reboot.

Pasha

