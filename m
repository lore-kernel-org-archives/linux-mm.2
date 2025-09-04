Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEECCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 20:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CFD8E000B; Thu,  4 Sep 2025 16:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196B68E0006; Thu,  4 Sep 2025 16:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0863D8E000B; Thu,  4 Sep 2025 16:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6E158E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:21:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95B36160396
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:21:11 +0000 (UTC)
X-FDA: 83852687142.28.43BF4F5
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id B877C40007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:21:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QpA04bIS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757017269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5R73QwFGpxpwtcDAq2/wRoOXZRZTM7agVtz97/zJueA=;
	b=nH2AguAVh5KU7edb3Ufktw8JZ630QqfiaZ4kVYzO/1anc06o7YiK6Ji+MGbeiwnaQb7vtW
	qRvCDjYmovzZUZWS+wBcnAAaydwdaoCI5eAYgvy6affrh8aR/BClLXuc+6+fHDlB47k+9U
	OeB5APveIX6JMfFLGhT6r0z+gKVQL5w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QpA04bIS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757017269; a=rsa-sha256;
	cv=none;
	b=vyOzF6Nu/p8bl/9jpU2JijuEFMtp9ombnW0y+059SOL+8epfTqYErIWp/Ti0Fyskw3JlKJ
	yk0WgsZUm/xLmQzoYJTKPLHglxGW+X54nk3SvuNooHpY7UMccd7NNDrT+QRbmLQ6IMK7Wi
	mD7zxAxIsuTVn8CZtMiaacaCSiOnT5Q=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24cb39fbd90so14163715ad.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 13:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757017268; x=1757622068; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5R73QwFGpxpwtcDAq2/wRoOXZRZTM7agVtz97/zJueA=;
        b=QpA04bISGsFI2vINIwB+slA6sA32dfRdcPMsQRPuUJQeyXOE0AqV6Mqnc7VXUWLyrI
         IjLS66SKGPagwSbF/GDXNxuLuuUJu+UjsW575BSZvOkErXuArw4WGQPaEmXmL3poUeEn
         vNfEoAmY3OBjlrC3nD+0l70i3L3cnPTegfixnbvQe7rXS5TNKwmqv0HxkaXAWMipsdv6
         LkF2GmoESxw0+1vwX+0zOfy4mvTIrW/45ve5aI8UWhMNZYa3/ymgiqek9lS1KkKkOqps
         lxN7iq2BORKRi01o/TmGWmrCLRlreau8qEn85C/5kfVbYJpk4SOuTnG1k2JGsWFfL4JM
         zl6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757017268; x=1757622068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5R73QwFGpxpwtcDAq2/wRoOXZRZTM7agVtz97/zJueA=;
        b=dzC+YtlCpQ8jKvPyCZihkYQ8d/TxUM9bhnjDRabQCN+nD3pqn0e1MwMXpOZpCN/CI0
         QXBbAr5U+7RJH2aT4ed1is4S3JYHbvzlnABy7T4ywDGj3GHHj+GS8pQ3o6xPwMgeteCI
         N1M9yhjqfogaV4kx4XD8cEWFkOEpWCEOG45Nxthc8HIgpsNZhChITqhVyFAZ4x0tF/y0
         uTfXMMFD6u6YBis9Veg+fgahYvYN92wxbnBv6yve1uFSGmTdNZLI73+JeZzoIeOVInN2
         4/MG9acQ/7CDYYbBlBkmL+jT7+pUSxBZmVidW8+3SwpLFis4t90JbiRH07Pw891mkhCw
         EoMg==
X-Forwarded-Encrypted: i=1; AJvYcCU9z+Ch8SMNWyvaDWEies2zbAa3RcRSDN/KsQ5fyoTVNFNPVJ/gDldPOs2UpJkFMYRLMbuqreEyAQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8X7ZglLa9zXvc5PhmA9+xU1KfturYrvY8gtyT0eEzObUkj97i
	uxhDmJ9Fd/uTKUuQh+PiFRMSZzLaA4YFhJbtXy7K+tL3xz0sT0TjXgijQKlqghs6OyP0I+3ikuL
	gO9uQAKb/FDa8IhCRngUjyPvrUXUYRYA=
X-Gm-Gg: ASbGncvAHf5fv+8nSBZa6BClkD7ZaafDtj+MptL6Wa6d5+1tGFx6gMtZyRHDUD90aCU
	uiHPX9+4zCMtC3Ng+Xen9C8KXovHqfMWcjBbM09tuFZS9m99B+1CjfJYD0D+KZVWYmzmjDYMqBr
	J5X21E/9fMfdL/NFHXiLZX1YVpfmEtRbaCkuZhBWLs9Tlbo6PIpSKXYtaxLseFV9J10ZKphnxFm
	oyrG0U/Tcwi3Pne3IeOHbLZuixEzkDMMaV7Xg==
X-Google-Smtp-Source: AGHT+IEI0YtwNUP5Ckeu7lnXmy0Rk28H9EZkLvS0yGrAkAdCynjENqi0zkQG7ZR9KNGK7GfDI0Z/fifzp2eGgX7XZqI=
X-Received: by 2002:a17:903:37cb:b0:242:9bc6:6bc0 with SMTP id
 d9443c01a7336-24944b73618mr268496855ad.55.1757017268482; Thu, 04 Sep 2025
 13:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
 <20250901164212.460229-8-ethan.w.s.graham@gmail.com> <CALrw=nGkk01xXG7S68FggsWQXygTXnXGz8AvseQuRE9K-OE0uA@mail.gmail.com>
In-Reply-To: <CALrw=nGkk01xXG7S68FggsWQXygTXnXGz8AvseQuRE9K-OE0uA@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 4 Sep 2025 22:20:56 +0200
X-Gm-Features: Ac12FXyXqZdTxVG6TdzkdqBvv0Mcwr4nVECn24stQHwKcyWRqz_jVg7upfdtHW8
Message-ID: <CANgxf6xCfk9uDsGgqWqociv0Q2Ngu0_GBR0vzWHwOAowsO+CVw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 7/7] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, davidgow@google.com, dvyukov@google.com, 
	jannh@google.com, elver@google.com, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com, kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B877C40007
X-Stat-Signature: 4nosspzbssii5qu4dkznd9ofpgmqw77h
X-Rspam-User: 
X-HE-Tag: 1757017269-834474
X-HE-Meta: U2FsdGVkX1/Msf5rxUj+8LL3YSMELuhaO9FxVWMw1WXzNu+d/hyWpMMEg3jB/8hjOw5Cyk0vOf9L+RLKg6Lghh5t0oMTVuQQSwEe+WXJngReG8Lu1qFJk6WT6JeQwKmWPd0a2D444DTx3/8TjCxeJ7a0sugP4DUx/kWBVIERvnRoCFyc+2a+AHAXh7Bu/FpHghcL2MPfbX5JYK7ckbMZnIzTm/+bLJIE/TlZYnTNX8vZkYcZWEsc9sLUutTV73OEfietuHARewfOfApBILc11e5c/ybdLemx8+ciEntoUJtg2CFBJvI51u5Ps5yKAQhIOkeD57PxQLSEN1U4541J331wCDVkc1FW8JN81eR6FsfLHcFjNY00vzBwzBuJ2KTb/8jWp2S+RbOeDIaAIspqwnwo9RGE69MNyHktOAgLtYbOGfNwlOvdR3CBOh4Aywzie3TVT/ZQGg6l71b0KlyGiA1vjV5NFyn4x+icUoO08VurpeTRa9erw7yIFGMofmRF0DIvT/LKB65lMwp9Qiw3X/sEle1RAYHcDy785GN2TuDbmMseJhkiMG0SqeybhBNhvwsaADUn9SDw54o3yqSKPr/A5NS1GJELBjJyUk5XdpPsFAXaf0B00S8DuCLOIIJvzH1W0+4boGHZxlpomol5q/oKd2wgWppzkfBAntgrnRXzePSApaCTLhWbljzqdhWR6y61PD9fUQSNKEeq6XrKfPdYcqXXA0YzggEC7/usnM9qafqLV0XaEGRTqCDBMHEzy1CDO3MEDfJN9L2L1IA0iBEl/4CaVxHYRK0FHkJPTRKnJQhj6ZMQKdrdMGSWOYTHXvMeUzLtBLaWEaYOcHw8BZbPcuU3GewOmMaq7TrOm1sk6oiFLAUX9l68ZMpUEn4FBxJQ1SF/m9XBDj167xun+axqRDqVXf2CwOnqMc3uPfzWfmw76h/BuFwuwS6uuiZAK0fcT9sf6b3NPSvfQro
 sbPKu/hG
 itvxloHVnBsEOfCS1CIW+8me8KGLPU3S/9aNCSftUAd6U1WNw/dXqyVucEv8ATDZEn1QpdWGbgwXNQUoLPZf5KVC/naTyWp7yuv/j/Uc10bJABC7bPMH2EMEMOx2DW7A7sNCW4mxjXv/xC0P5Lwew5T6z/Jz3A2uOJRdtvgVnUa4O0Qf8y5SLu86GnCcSYssIXFFjCyLccUgj8UV+rmnudQEW+xcpgq2+mjUYqddGZnBFX+QaFHulBa47uc8Lj0spsa6CttpfhO2yW3lQcFTspnqILmTFdsBBzOdid0TPqiPQmIaskUuMSnivQe6NLQ3J9fgjx5KINmM+qxMc9y2g2No3j/hMUPN1tfroTPXzRDSV3RGyDoUeVtj8CKfi8nydRKI0PeOVOgfJrfLsP2r4q80x+36BY7LobIU1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 10:58=E2=80=AFAM Ignat Korchagin <ignat@cloudflare.c=
om> wrote:
> nit: can I ask for another real example? AFAIK this subsystem is
> rarely used (at least directly by users). However, one user-controlled
> widely used parser terrifies me: load_script() function from
> binfmt_script.c, which parses the shebang line for scripts. I would
> really like to see what this framework can do to fuzz that.

Thanks for the suggestion! It looks like a promising target.

> I'm a bit worried about the scalability of defining one (visible)
> config option per fuzz file/module. Is there a use-case, where a user
> would want to enable some targets, but not the others? Can it be
> unconditionally enabled and compiled only if CONFIG_KFUZZTEST=3Dy?

That's a good point. I agree it's best to enable them all by default if
CONFIG_KFUZZTEST=3Dy. A fuzzer can pick and choose which targets
it wants to fuzz so there's no downside there. My original thought was
to maintain consistency with how KUnit tests are built, but since
KFuzzTest targets aren't executed directly it makes sense to diverge
here.

