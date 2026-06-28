Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B2A9C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 18:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405A86B0005; Sun, 28 Jun 2026 14:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD906B0088; Sun, 28 Jun 2026 14:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F48C6B008A; Sun, 28 Jun 2026 14:44:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB8CF6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 14:44:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60DF2167CCA
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:44:11 +0000 (UTC)
X-FDA: 84930196302.05.E30CB3E
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8EEDD180002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:44:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pdk1+AqD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782672249;
	b=446+h8I/Hy9PPm0lXkRAEZeH3zMRZ/+WNgQhw2FVmpyy/xinJadJxy8uLIM5DyD6SvIazY
	Y+m5XyEJuRSc4/BMiKqzjgo4qkPSjvrSSag3NJMPgT7cGyqOOk4N3r2bGmeKa3WpCCKCFF
	DdAndjJi6RxIeLd0ntMuypGdem0sqlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782672249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpVWK3fWX6RtxuEZlDdW1KGkNIIyoL6bwAJsYAyunoQ=;
	b=gCCzbqkELzSwEBJ8a1ri16/x1VVmXzg09cKZqaa6aiqq9L17ssB7oji6lSLHea6T8mj7fF
	ojTDsxrVYVbiIo4AmnBoE7ZWzHZtkEw2s3tE5lZ9mY6RsxpoRhMoyEDForz2X9kvYZNmn1
	lrAWHxF/RfGycQs3RVJzosSI93xuUhg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pdk1+AqD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493a97fad2fso6281135e9.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 11:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782672248; x=1783277048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpVWK3fWX6RtxuEZlDdW1KGkNIIyoL6bwAJsYAyunoQ=;
        b=Pdk1+AqDrETp2bG/qWV9aBdkjuKXbXpA56t5TazYEkGt1MuYffLKU7c+F03SbFNnWN
         IihAkj6ddrgV7V4IIVon/3k838WfbmE/re3VwW6i2RTNXfh+XYHD59gTZtckr+4Tsfps
         1cxDqfShZmMAMGouUOnuVSJppa8Fvhfgy/+vZ5lMx+TWaOHjnx6CEu65TQDBwMACSLYV
         AqMujcHfs/hjDgi4PLtJkaO11fMbzhwCzp++3CMU3pzWbZGXwtFkgmqzqdAJrvgRE1/f
         vbEGn4PTtHRAjWljjTfnWKtoYItF+rix4TQy6e2NlPsebmWgApd0dowNJ4swVXXu6FV9
         /g2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782672248; x=1783277048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UpVWK3fWX6RtxuEZlDdW1KGkNIIyoL6bwAJsYAyunoQ=;
        b=WT41t6gk3nWmk7Iuae72npqBEKB2s98iA2FuJokoOy9Nquqaoky9gf/2Y009qmXv7F
         aWb705/wZRI2e7LT8NIlIlfv4FjdimTBnIbqS8mhN9Xqp8VW0Sps1qZGzxBBivn0x0Ne
         8OWqBqUe6BMVZnBIT7NSGPtMFqg2123BgqEByo/2HyK+MYbdU70BUiqK2XRRF6V1MLIQ
         HizRWmuFYhWxGzPTNMfyEdGEizGUFknYrbe6/5izVpt9TaoM/QhKLo0zUQ6Vn9hb76V4
         uVgOwP9etf489IgszFQfvjde2uP7hRBX0IRvUGw/5lzC8bLhk54T5anBdmvagm+fgtfE
         OEmA==
X-Forwarded-Encrypted: i=1; AFNElJ/qmhIMvGKfgsalgoUrU0PSkW4vMAdNcabJNli78ZRzaA8NhScGaVdlcrAkuUO1itH4TT4jqu1UxQ==@kvack.org
X-Gm-Message-State: AOJu0YxBKFfWj2i7h7C/4j7fLKbSwTfHjHjyoQA9BuELKmThibxRSEwO
	htJpgCRpz04d3h1vnx/gw42QtvxTCBl0y16gBnOHMNKlbr1aXrwXbUTz
X-Gm-Gg: AfdE7cmaqUc7t4x/psRiQOuxonXZVBpziZK1b8jh8BsDhnr+vPGtykC8RNa6jeZrD7C
	7d5IvPR71QxnwCg1cXXdWVK1wVJoXg7dwfYc/nAha3pWqTmu6hf4VXOzb9ybs0AAKRr2Vvj6lh4
	6gcOlpT0BbLp9Zbnr5lLxv9CfF252xXv9my1RAp0710IJ/ycT9CEKbH7Mh0PipvuXBcL09+Cip1
	iQSKrdUzEvF9kQ+6MrC0XpxpI0PfaYM1rJYcHNyD4e+alLUC88EWxmAjVkygcIqJl4h7amcT14R
	aZrwEDQKMudCX/JTnh2iVX0D8pQf2M67L++g0DuznIE4KID001hajxxJg8puryiKWPyX1nGEm8h
	ruaxBk8xflQxqo7eEBxj537Spij/b4eARGT2xHz3F/IjF0CAitny0D6jNuI6kF+ShMxjN0K8SeX
	WyuhldcP0bfgDraI0uBzUASz/zRuji2CiMT503iRttZAoKig==
X-Received: by 2002:a05:600c:628c:b0:492:71ec:7b4e with SMTP id 5b1f17b1804b1-49271ec7baemr92587895e9.22.1782672247820;
        Sun, 28 Jun 2026 11:44:07 -0700 (PDT)
Received: from pumpkin (host-92-21-50-228.as13285.net. [92.21.50.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4926c285fc1sm167243165e9.1.2026.06.28.11.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 11:44:06 -0700 (PDT)
Date: Sun, 28 Jun 2026 19:44:04 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, Farid
 Zakaria <farid.m.zakaria@gmail.com>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, shuah@kernel.org,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm
 <linux-mm@kvack.org>, linux-kselftest <linux-kselftest@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
Message-ID: <20260628194404.40253a7d@pumpkin>
In-Reply-To: <20260628-debatten-vertagen-amortisieren-3bf518773e75@brauner>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
	<sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
	<CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
	<24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
	<20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
	<CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
	<20260628-ungeordnet-orgel-stechen-36dd64038541@brauner>
	<20260628-debatten-vertagen-amortisieren-3bf518773e75@brauner>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EEDD180002
X-Rspam-User: 
X-Stat-Signature: 6zqoq8m86e1snmqiw34okxw6yo55g6x9
X-HE-Tag: 1782672249-416479
X-HE-Meta: U2FsdGVkX1+82T/sh5Gm/+1sRUYx6Ev5oxSh28fs67M0u0M8tEfH6/kk2JUoxjZKVC96SNZSsHLsTEEoUZEzm6v+BGDFIi6/mFeQsZrIkPcG/d0ffkS44BWTDKGnoYOlgQnB5PLx6OwLAsykm23ZKXW46kyJMENyDayGXArjW9BP+HWXeys6CkNEuqO8c6soqPskdLVrj3H2G7X2GB890QLuNO2w8kf7zVsrM0mbxgfSSzL7Wbqxhdzn5heB7KdNSFiiUSnEpanIkGgflfFc7RTrXCbjK0OuPcfOX3o5/Yd2LN3VERajBf49WAhrEWshRVfFJ4l6w7NFUiLpuDct4ZgN8LWlg4rFhbfkLdMmbfppjF1bVReC1ycLuVyxJSucBeMUSSto91GFJfT6HV7MEYIE3/fQT8e4jvH4iBmrfqGjV7vQ0wv6GrbpCaDno8v4wVaNOPVKV1SSMMkbOIoLDBjxqR7bAlewFKcUlk4OdTxFC8/ghK3d0/7iwm6KF25Jwh+rfQy0aCjnRXbOUyXoXtCkcUhc1P9VrZ9hBd/Op3l0udqvKaKIBWSQFvADAS/4LWe8Hkt9gklzhrANJyP5Q2q9JZBy5N64ocnEUer05fB49OewjZ0iNaLW0htAw1S6Qv8Rjlhuwm7nygm81YL7jj9JIWYVUUw0bNHBodaHEfGqyet+FpZyBbKNuQbgyxQ1qpZWs/fXKxHxgPZR8aAx+1zEyGvdVx9r32xkE6JmCd8B+F0iXv7iGGYCu/tz/UMOgvAvfAov+YS5ZNYL9DqNfjnjKqpciYJLKcoUbguRSUMrkOy0F0IRcpltd5yBpNUBDrylkM00s3TmdWvxeSIkaYnW2b5zNYyNN+0zecpliA4c6zP0cDEzR3hp30sLHcd7BwPr2kDmycNlKqHunLoMQKubx+cGPKm3HR64ERaz2sSYR/ZzWkItjnaju1pe/yZLdQU8WAdBarXBLm64xlD
 nKTirYa+
 jwcM5CXm9GIuD/JilfFVjt93boPjRH6qgg2vSrBoQKdlYhMpypKMWn98+skrlnAcCv2WAfMQFJnT2qqQ+A3Rt9tx9inr3dkoq2/fWr36n3sOalnC9YB7j69qW172IUGLo/XSRVeq5LkyqZpqQJ6FTpt65BvlMdaGABR6ELqgBzaimntt0UglZHiArmCTV5/9SrKIFowhjY3PsNRx3vFu8MIW9CyljvCYaIMubZNwJ+iWaOs4XjsWfr4gJdFnz88q8VC5qHkybfByEazo90NX+b3HwCmArBwCW21i4/PaIW3gRzO78OvRBh3ZdnOdhgfhGr2YSfQkX9hGjqtDxbNFk8+4K56GytOtxWYRVbcCMwLXNAF417d2SiValLo9ITEZxJp/oV/7cRIsSWO+MHADBKnqWhwHwIIam835jNbEARmUjRhoIT6Ge9j/wQso0a9kXkKru/qSqIxyew7kOt6sM6qx5kI2BikKrNoLtob4lKR91bKd896bcEn16EtmqZZEQ/h9zwAr/ptlrYKk9gOnrtHIpoB/Xamt9J/T0bvcWO+esMGP82+HCgbzhjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 15:20:11 +0200
Christian Brauner <brauner@kernel.org> wrote:

...
> All of that needs consistent, easy to reason about treatment. Reading through
> the glibc implementation of $ORIGIN for shared libraries in rpath - even with
> an eye on cutting through most of the complexity - doesn't give me very warm
> feelings. It feels very hackish and full of edge cases...

I'm sure that NetBSD refused to implement $ORIGIN because it was full
of loopholes.
You'd need the kernel to hold a reference to the directory inode and
have a 'magic' argument to openat() to be relative to that directory
rather than cwd.

	David

