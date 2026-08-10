Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C89B3C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3A36B008C; Mon, 10 Aug 2026 14:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54C36B0092; Mon, 10 Aug 2026 14:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43C76B0093; Mon, 10 Aug 2026 14:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 867236B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:30:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E847C0190
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:30:02 +0000 (UTC)
X-FDA: 85086199044.14.5F3592A
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1ADE51C000E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:29:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X7BVtXf1;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786386600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jzRT/jzG6fGTHeaMqBTKR94VOv7jRZ9cIp6Lbey6ug=;
	b=17f1oJh3VvNl1PIa/jwaxyipXWnrX7PKKw+OHeSJtr84nNQ6yUroP/NQ8TUTw/m2pcb2l9
	pAuMsCyo9qB8RJdD0mQ9u1E6jFNNUMPq7kGROPpjXbldKiRSWWSIdBdwQbEqwIYbkyrv9T
	4fQggg3owO3zAOcAK8hVUVOieXAi7T0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786386600;
	b=PnwDzhw2qA4zmsvhlAkdTSGeGzYUfj+SLvCkLsezLxHxemqXnXew2ZJ+iiM/5mTAyMevcg
	USN8rBBmKTjmc8hmjzqNARcW6wIZH8UOVmhTKcgl2fzscyBmckE3sMibNrwB5B58xlvS6u
	+Ejc6ooavZlGBJPFkuIiK7WBnGiRQAY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=X7BVtXf1;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cacef7d299so15375ad.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:29:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786386599; cv=none;
        d=google.com; s=arc-20260327;
        b=flRyjV3QoloAB4X0oPn7e09tCirXhVa+hlf3u7YUYMM1ozt5EPhLFR5SmZi3dI2P22
         1guH5YD/WUyNzplxAFMTVx3CtgYUHXNJZjWJmR4mlj/ghubDskkehlFpZ9z5JIAanIvM
         +l/VWtO/bdxu91fXqLpYjzZHygCgQI2gsW/jFNryUm9KCh0gJJri5to00gYV5ja7eytX
         ns97s7J6ubvW2eaV6nJAPCl68NakVVF5KoeDcGVY2BQ3Rdpqtw/Igf1ndhPKv8b8mwEJ
         46nJhpVyo7HbE6lVTRzj2D9L9NKcJU3lQrCw1wOXsjh4OZICOvrV+YDwbgH+sUR9uiPT
         1ztw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1jzRT/jzG6fGTHeaMqBTKR94VOv7jRZ9cIp6Lbey6ug=;
        fh=z9zYjIKwPMVoD+U+W0Uy1uqZXfjIsM/mKnVnnflQB7s=;
        b=UtZs0u4BfeDsWstnyFU/fPGGfw3DzKI4aj6rgBac60WB25jdl1b096sfokaWZAtXJc
         0H3N+Bef0sQwfrjuhNWs3b6PwZjDAos2GU3UZ23YHlbn4T28SAfCpioUusqqyWWiX7QB
         Q0WpMly7z3nQd4xnWCUE/VMxJrVcAPFNuqVf96C9edL2D9ciCTJMmkf3tIqTRd8Sy26N
         lLp7o7OSh+khj/FPPi3FBeiOwV4yOj9Ics7q+hR8K/4bqhUK7rl6SXW9OAT99HS02njO
         SnF2DkaSD5olkAD5fxYePN9l+EqXScAULDNGxip92sd1UcpY+1G4Isu09kB1LFNADH6h
         YAFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786386599; x=1786991399; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1jzRT/jzG6fGTHeaMqBTKR94VOv7jRZ9cIp6Lbey6ug=;
        b=X7BVtXf1ljqzxTFyxiAyqwWf6xyDuSpli0dN1D/julB8lvLbst62OPbsfoAn7h7vzW
         nJytcooViV5/CEoW/Uc3MXs0Clwp/i4PKAPrfLx/9CbHvVG1fAdSITVkseQs7PcGwXKI
         X/S13AHJcE02MV7wBpwmEDtL8x9EJ9lQSv7OL8hHlSe2JDK6jhPW1zqpoxKA9lAHTagj
         2Z/ujHO56qDLi/pbzsB4DwbRE8I31EbE+9g21KOrpY2SLrCB+/g3DltEbsplyv47lw9Y
         IT5iq9uHI7GKqmyF1qI3B9iUD/T8J/ct+yP9AdOR55zl7ZtkKrUkZU/Ngv1VfUKXT+DL
         vBsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786386599; x=1786991399;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1jzRT/jzG6fGTHeaMqBTKR94VOv7jRZ9cIp6Lbey6ug=;
        b=EtBWtUs1n/f9J43j1Z9OS6Fyn4Jx2ptmx0i05zOjcNB/PcW8HjK5kpHRv+tJdvRhaG
         way7Z126aOiv5kOb071/Lro/bZLHEh4Upu04wYmhAgytQfF1VK3whOF+Ajefz58IsnfH
         G0f+TtpU30BOM1dTEY5HKNW4ULPwrjDynZFvUTXF5nKEJWFio5ONpX6DrDfBrwPu1TYt
         1Q7cGNxGmNCak45kmJPWtYdSsadiEZMuqA+WyZG51iATKCRStZJCikkXwOZat/b9rtNa
         zolz7FV9amokjeYoiuEWA6O/Msil75d35nRtXmRiMRp7YOpAoDvccn8Jv0aWNRVkI5Bu
         327g==
X-Forwarded-Encrypted: i=1; AHgh+RrZsoEqmY0W3HLv2mm8loVmIdfWCl7dKZ22H5Cp21KToHb7uv388av+KjKTRpzg+YheemEliXedUA==@kvack.org
X-Gm-Message-State: AOJu0Yyb1PObpme93uVGSd4gXnECFp/kWP5qJvExkOzZqnDgFzWisDp4
	HztzI1aPF/55BdXFZ+xn2kRat+frtBEDJe7RgPX4GrqVNpjdhhKQoGAbGApVVp9vHQ9Zm0vhPDg
	4Hkzj9NST3aT8CuBmh7v2QUQ6PtbHVg1uox3CCNeg
X-Gm-Gg: AR+sD10/Vey7YM/BbSy0AB+TCYh5UYBM5jMhXOFopl1fdGaJsk4Qc3aiIj+l+hrej1z
	VQn4yJ/7UfL62Kfju4Vy7sZe/0VKAjlze/E90iQWTVlb+QGQ/at8xxGILQ2g8K1pjZ9U7CoImcB
	t1pN83j3mIpIP54VHR+8LgIOtAspKvxleaoteedAaL1DiYG3ndQgQCQ+cEe5WV30120O07CJLF9
	kwXiNd27Br9bhcpRayPBJK5O9To7auraMHgXqtw/FxrZpCAChKXb42Dxzczr8GX+1ilYe1wcSLb
	Mgypb1xEAgLvpjrSN/yTuAMNy+iRZc6uvbOYk1Nvj+jVWAYwWk7796zjWG+l6kPkOsttg6SyL70
	0Klkmem0eVECcmSQuPg7ygiikY9mcrA==
X-Received: by 2002:a17:903:2643:b0:2c7:b1e7:501e with SMTP id
 d9443c01a7336-2d3108235ffmr875305ad.3.1786386598231; Mon, 10 Aug 2026
 11:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260810-set-page-dirty-warnings-v1-1-53cad4890808@google.com> <anoMNezqJ10YgcoN@infradead.org>
In-Reply-To: <anoMNezqJ10YgcoN@infradead.org>
From: Jann Horn <jannh@google.com>
Date: Mon, 10 Aug 2026 20:29:20 +0200
X-Gm-Features: AUfX_my0h3pMPDz0xsvhZgSJb9FSJGPCEVL1ZaEAlqutcr_1WPGPSeLUtGzDBnc
Message-ID: <CAG48ez3ZSX5hN2wXSf-GWXH7eZ9Zu=S0eVfTyzNw5F4j17kOsw@mail.gmail.com>
Subject: Re: [PATCH] mm/page-writeback: document folio_mark_dirty() locking
 more explicitly
To: Christoph Hellwig <hch@infradead.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1ADE51C000E
X-Stat-Signature: oib8d66j7pyyaqtipwj1atg9m6s5unrr
X-HE-Tag: 1786386599-400347
X-HE-Meta: U2FsdGVkX19V1Rc8yPfDc4vEiMbO0ojZfl6L4CYcG9qd1MGSobK2cF306tS0M9bQQKW49WBU1GfEeufbO3GgHBurIDWcea/VF1U8yylESzQSTj4cflayX7ZgFVKjxTIlhXfIgNQ2AtoWaaGVhz6mIRX0/9Fq2QNqRQ/aDN6881VJ19NkgexmjfuGUhQ50IacEII6yOQjXtkH7L7Z6Hr8QfKeiaT3r2t97R9xqs2dDreqyXLhJX256HqpiGwkH3sY+Br6bnHKHmHrqncLDHh3tRjmTdljE8yvh1RuA26W6RfZrgR9tiUtK4NhTgGU3kwJdXxHOtz/oa5RyLI4tvo976S6vKZl4Pfff5aW2YyYkBoBsO8HcW/gk6ldJJOy8q7g5J+s0WpsZpcJ0wn0hdGk0B/GMJ6RzAalt0iyr1BovUF1tl65tlIoZr3y9b4po5TVV3nGbk8vTXl5RMo4YzChsWMAsxTyO9eczQDa2hb+X2yc1kp145rWxBRlJ6Cab/jX6qu2MJeYe+pDnGnpCeiYoXgLh9S1JcCRNwbsxYFRbDjnJiZb0INYaRAIWwhi4+/dYACU2VaA6vfbaUIYiN7lhV2EM5mzREK6kpQq6c4lkT/zGjWwWbn2jq4DTE871oapr+kQsbSq6ykVdTINApYaw204U5iwed41CsC96aydSl6QjFdg0jY4DXK/9DPAat3GLiMzDqieDs3a3rzxjHBISvBx1M8cIssRDbkJaq8Vi5+VD+iHK84Dx1XhCkwKHDhMl2f/VFHo5qsV89HlvtL9eRjvcgVaGZyjPu2MlR5kd+y56akn/Y2UImci9Pom3tFsD2wrDUxa/TZIGHg+x7ZsUHAF9C42/eJ7FIa9Yd0kD5J8X6zvmLOq4LMx0vlFJEnki8fFQy6Xyo9A33sBytm/fayZOAVgs3c+yuSHAqI4LCEdIrnJeokWB/CsPkMK1CNXpThRNge4ikjXQmM2NF1
 B6KC5Tl6
 Z0TMEq7EkAP8prv7u/ojYfxH3oi/ZOODBTdI0cLpMbwia7IaIAvGLrUPZKhyYPCrM1GC7YDEjjWHGHXagnGfKmvwl0EUd+grQT3tHtVw4vPWAfCtpA4+0faYXYoPHkiUKj/EIV1MFTMFbCxitKdJp/9iANhsd1zcHk4I2bBCYOo081WFvV+MoEVtL9A4doktPV3bPEG0VpuLJckV9eco5vsieZB0Ia9WKXLMzekWYrS/vU4wXVuq+6893avkLE9VqrVgYPQZj3Ik0FawwuyfbmapJRECPxEK/7dQrk31bsXA7pcwHe3YotxjucgjUukug4wEfJuBPOESCjSM8QzMjNL2E2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 7:36=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
> On Mon, Aug 10, 2026 at 06:02:36PM +0200, Jann Horn wrote:
> > I have found two out-of-tree driver bugs in the past where set_page_dir=
ty()
> > was used on a page from GUP without appropriate locking, leading to UAF=
:
>
> More documentation is always good, but out of tree drivers are totally
> irrelevant for upstream, so please reword your commit message to be
> relevant for the kernel itself and drop these references.

Ack, I've reworded the commit message and added some more examples I
found in mainline history.

