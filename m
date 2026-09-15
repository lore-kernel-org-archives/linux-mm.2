Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD787C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 19:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9748B6B0088; Tue, 15 Sep 2026 15:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9265E6B008C; Tue, 15 Sep 2026 15:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81BD66B0092; Tue, 15 Sep 2026 15:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA726B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:17:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 979781A052C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:17:30 +0000 (UTC)
X-FDA: 85216955460.01.F693766
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	by imf01.hostedemail.com (Postfix) with ESMTP id 69A0340010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:17:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=J4XjpFHC;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.229.204 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789499848;
	b=2TbRmweUshSE10notPevrAxRs7NlAMtn695oeqR8gPWYPSpqwfUqUyzh1UZzKMrY3rYk57
	mzFCRIQyu5DVPDYLwqMLFfqXUwFeNqcjHNjvpABzi8DvNnCV5bS3+DFGFB7lS2sDAOoBrC
	FTB+zT9niKCfQGTvedixs0buzCVsiVM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=J4XjpFHC;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.229.204 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789499848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFFk9jJtDswBQpA8QWIooO6lLG4HdlvPT/LqykRjG+U=;
	b=p3eV9uyDz82+XL0mXvVVUXsePwF9s6WwRPCdpGaVFEibsn3oeLTUM+o88pwJ35lLJ0n0ZH
	wgl/pkimljv1TsBkw7o6PDNr+d0L8CpW9BKy3fMO8eivefngz6x7ncnp14bnFjFjIz9mNf
	+z2LdixdDCV5giW3sGFZvxd0xwryLbY=
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f15b79so106856e87.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789499847; x=1790104647; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFFk9jJtDswBQpA8QWIooO6lLG4HdlvPT/LqykRjG+U=;
        b=J4XjpFHCoAhB1orRSW2jZniN3MR0UBfFFWNKj2ApP0CI0i/mkmxftV2P368tccR7uX
         eHqeKzjBvdycnYN3uqrZ3tG0cMBYyWdGqYRmaNQIwv1HRcvuct2Se2Nn7Dq8wuDSzsZo
         kDkmqy0yYveMwrQVa0S/PvquuzZCG5yBrhSiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789499847; x=1790104647;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XFFk9jJtDswBQpA8QWIooO6lLG4HdlvPT/LqykRjG+U=;
        b=rbDFchxNBQfNQT44fruKwatxoKoWVU3G7E7iITKSk6zemWD9j4HRB72KpKJUA0l+T0
         mbCp1IR2SqLLn5JXU7jkjLqUPoxmh2Y0NKBWmxwQqfrEw1Gj7N2gBn414UCV2TnGp2BX
         YSse0i26YdQnAVuU24b3D3tIMDS8aO5kl9vI1oFKqJKbtoi3LGpQK3FkFFKtTWjuWo6d
         FIfv6n/HjjxBYGx6k0giz4JDsuXaxaVJhbbl9GoymgOSTzXUlAF8cHZJerQlXhmj83DA
         wptbCCG5V9ckKH9KO+6XyQBU47DgfK5N33YqAIw5CgqKA3eFqjiQmSUbgdPtu5RfGfEz
         AVEA==
X-Forwarded-Encrypted: i=1; AKwUvBzkSQUtQaAwp1uHlUGfYmuUhzlrkSYiqy47iWfTNKqa1lMEHGfV4qe30UDaXIxSi1FawMdy2Lu/+A==@kvack.org
X-Gm-Message-State: AFuF++mQh1C1vwr9w+uBu1oX8CPhCG0T4talSP+c21YST2HsMSbWy2t9
	+J/Q+1xzMjKlNjpJZOQYqmxx/glc3F6cZaKnBXuJzFqtTjDZ1iOU0CLmMu4aCJKVu6R/7UB0i5t
	OPHgB6hR6eTwK
X-Gm-Gg: AYBFou20cyOutq5Qvjxr/yO0rUstkAXWNKZqHNMVKMc9Scx/SS6bkmvnvun2S4WJPPs
	0RF/KRt7kr0rdhiNbrNl14DodjiOtRr9wYYgMAnTgfSnBNv8+krAtd02NYfBSujvXoSBpmxmEqY
	AoLIiWK4nOivByeBAbu78NJHA59VznVAN0X0WaamX6kuYw4+Yi9oQIPq6O2CnfUuE6vQM/e+3xJ
	P+tSAbejnRXtG1IjyPAQceP2C0vabrK2OeDilvvcnjcSFL4MgQ8GiX9i1e11Gb9f/lKwte58I/w
	XJq8wClrbd9TJXzIDfeEfIH/n6YoChWLs+sRO9RMezJsFFIckWwATanv8PNRy6PAjI0UM5UZ+u7
	1aUBg/6GLOUXUc8VER7lpobEZoSeCwLq0eXADswmugu/l6EXwamvgTsDv6Q2YZzr0OzXQysFCmD
	kmmaMUzEa7gLIx0i9y2VHqdHEcX0iCfkmmIBKhHym8cd7UXig7tQ0l4QNhMImQv1lE7ZKg37ok8
	jMi1b2nHL8QsL2j3aBdCItw3Tm2xYwnvo25eMfKNz0i7LLP
X-Received: by 2002:a05:6512:1590:b0:5b4:74a2:cf2e with SMTP id 2adb3069b0e04-5b8ae6af918mr4184776e87.21.1789499846574;
        Tue, 15 Sep 2026 12:17:26 -0700 (PDT)
Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com. [74.125.230.76])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8b57ee918sm168702e87.80.2026.09.15.12.17.26
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 12:17:26 -0700 (PDT)
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a59bc470d6so2011271fa.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:17:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByNgC9AmA8SBbGQEfu91zxaqU9F8Bc+BYg1UZ3RYAC/i3slncGl1luvx+yNLcBDdEiFh6t074NcLg==@kvack.org
X-Received: by 2002:a17:906:7309:b0:c25:47a4:fedc with SMTP id
 a640c23a62f3a-c29b839a057mr1176039766b.2.1789499355710; Tue, 15 Sep 2026
 12:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <CAG48ez1RsdT=O=-0city3vjgWhDvY424KtTmrCJntWy5ds3HBQ@mail.gmail.com>
In-Reply-To: <CAG48ez1RsdT=O=-0city3vjgWhDvY424KtTmrCJntWy5ds3HBQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Sep 2026 12:08:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi3Kkqgfg6zUTHpQoZNL2VOB4vYqpi6RX0WNO++29UtyQ@mail.gmail.com>
X-Gm-Features: AcwNN1VCm0LMG7z3Jned014oJh6WBcf4uOx0OBk98_hrtHKbrhcQiMMJ_A-fmB0
Message-ID: <CAHk-=wi3Kkqgfg6zUTHpQoZNL2VOB4vYqpi6RX0WNO++29UtyQ@mail.gmail.com>
Subject: Re: [PATCH RFC POC 00/50] file: handle files on syscall exit
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, 
	David Airlie <airlied@redhat.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	kexec@lists.infradead.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 69A0340010
X-Stat-Signature: 17i6xc7jodxwmikujf1wcy68ix31gmbh
X-HE-Tag: 1789499848-927649
X-HE-Meta: U2FsdGVkX19ZtZqk5wzx9oNhak6t1ZWGTy1czQVRWKEsC4JvaKVVFjjGHuSvaxrwHHTjQlOd1AR8wJxHnx/4GigZ+lRew8kwPs5gx9naGt19XURQZ9MzwhBar3/CU6INs0oTc1yTuWkDLAaSXWfFeQV0Mj0nZhcysQ3v21905uYUwfv81HqSs1a9zfMohqkegdd9hLFtPskZhdfHnrz/8fErPu8gRQEz5wqrkhetT/fDRpmJvh3i+BW8NrmdhMdaIjTElQonI/wjzn9AaHlt3uK97zFungjqu4QU6sugR5ozrGrmONW+/SK9j5+NpbwkoeQTd0GnQ5JEViKdvdg6TNF8Gk7zHevuaH2C2Unn8Sunl8yFVE1A6G4wkQky2Kjhsy3YrJrCdP9Ojh0TqLMAnj2t4XKMp3L46DAH4tHBUrYLLbJPDrf1VoNHATKJ78ApXIFdPPfiAQh+Y0bghkvNQK0sDZBk+CBvtBeEck6ixYNjSRJ7NLHePXvnNuIKji1A7ubyPDVcffp40G50jMqAvrOJm7MapfbkhYFYN7OB7SvHD0jmnN1O/ababnSnsKB6iOSTyTHwylzEqsKNN/RZhmz6irh/U+2S5mA0qUF/nSn7Ei1YOgUbff+JJ8WunAUeojaQuziCfjRWNJd6zMkUDnlrXs6NNlBMGG62EtgCOGwyKLfPZLJedDi7gly9QiJ2zAas1qofb9hRr6Jv/De5BFD2yX9TTFV3GPLlgDsaYkljlNhdchEuieMB1h56psEMWw2ZHsbdp//gQ/VQt81hq2luXGOABFhqK/uleoqYlLlrg875A/acBFCU5AfuK8mhM9NkSE0QhI2Hf7iAAdJoZ01nYaJOH/buVxA311E7oB4vHLLGncNqs0UNhNwQ8q2UCHpX3k2ECOs+Cbhv4/HQudRhJHzI7i6g8E0zxkRn3tTOSvEfh2imhzygL5dm7r1NvkAv9RfoEd/seJpO7tp
 0FPCqfGU
 CVMysn8eqz0G4aVvTWK6xRaHveLjJhKzE5nBglEOvTj0DS0RebSYXy1+mfKgJpP8f8WuFaNzOhmcUDwj0v5IVc63YzSwXYM4P+nF1b3bk7Kx2vOCwSy5i2DBXBmIgK7hzFbD3VtOX+qtpC0mYcqnqa1SQ/5XmhKUxS1hSi3TArDeyWdUjdvcopPOj27R2ZnuvMOFFHz4uCOQ+FyFLEyRWwerafa5lbFy868mr9PVpeEEEcFBdPb6OKnyJp19HIa+NDFd8NAeNU9NB18/nFKZjmYl1tVFDlYFNccS7aP4P8KqiAZAjPbk3au4jp3hgK+fqKLl3dio5NTGnj7sOK0R5P8R4d/usLUeVj4khokZWFzI9whitianfiUCDbkGkDM0CBhZ9AYqcD4YQKSLcfPblkWXb4qoaEIGbfdF6oBzhgYFgqeqzBSdgiZ/pN9PIBFtzBZj8XiyHxtvEO6uZQuZFv3LHppl7kRXgy6jmA2YX25E6fIC5XmeIBcGU/+h/R+KViqaC8k4BrCqyXdpEkXmNePrz41SEgQ/eNniC72oKbRY7mXILKWzfFXKpZqPzt1yC5BQBlaBHmTIWW9sUAuv4VYBDVzc3oNycPoXRghANJWULz2NC/1diHTm6QdqVj2AgwEWVQlF+KlyeZrq5LuyXwLJV8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sept 2026 at 10:52, Jann Horn <jannh@google.com> wrote:
>
> Is this mainly about stuff like "we installed a file descriptor and
> then the following put_user() failed"? Because if so, I think a nicer
> fix would be to have a policy of "if userspace provides unwritable
> memory to a syscall, just keep going and pretend the access worked",
> and maybe have a sysctl that kills the process when this happens to
> emphasize that userspace should not be doing this.

We've done that before, where we just ignore put_user() errors and the
user gets whatever the user gets.

It is maybe not optimal, but it's fine. You can find quite a lot of
unchecked put_user() calls with a pattern like

        git grep '^[[:space:]]*put_user(.*);'

and some of them are in core code - see the two in kernel/fork.c, for example.

One of them says "if userspace has not set up a proper pointer then
tough luck". The other one doesn't even bother with a comment.

The scheduler has two cases too, although one of them is admittedly
for another error case.

So yes, saying "if you pass bogus arguments, you get what you get" is
a valid model. It's perhaps not the *preferred* model, but it's not
wrong.

It *would* be wrong to take code that already has error handling and
remove the error handling, though.

                  Linus

