Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2412D31A11
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 04:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8F16B0089; Tue, 13 Jan 2026 23:18:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796996B008C; Tue, 13 Jan 2026 23:18:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A27F6B0092; Tue, 13 Jan 2026 23:18:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 58B5C6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:18:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDEA71ADAF8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:18:11 +0000 (UTC)
X-FDA: 84329261982.26.ECCF7EE
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 138521C000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:18:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KQ2D1QSa;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768364290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoWwSNa3GS6VStvH2Dubk9djiQSV0dHWHRu2xsc9wjE=;
	b=jNjw1ET28KgukbZnf/lQTby76eqWFz2z6JuTXpQK4ALOZKgUvixfBaIYVAyedIDPc3FFiW
	eLPJ8Xv393IeSu282CadE3y247yCIKBwB4Sa1v9+Ke+65Z/0q39elB1yejunbfqbcSo/DR
	EcBhqXaxkeXmOz9pmwEdhPocP2UnLXk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KQ2D1QSa;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768364290; a=rsa-sha256;
	cv=none;
	b=lA3eEhdPuewYeX4uVuX+lBmHHM2TQXlY746r6pvyP737E/MvY3HBnIVq8KyQudn3z3k4ML
	3GDAfwUbkjRWtQiuLk0mfomoPtfMkHO9s2TALGgE3huOD0QW7eWDCkeh6+LTBPW2bUOave
	I035+oFgB9C+RhC1II2Qq/ur0Imd0hg=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fb5810d39so4293815f8f.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768364288; x=1768969088; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XoWwSNa3GS6VStvH2Dubk9djiQSV0dHWHRu2xsc9wjE=;
        b=KQ2D1QSab1EeSlMDbI6zJ9evNbwUNxLqrSMdP1/p4/uKaJYYwjRS5C9GsT8asRoLFq
         suVlvBfY7WfOy6BGXdLFl2Jek9/W36NrSnkqGvVQWbHo78Rqe1pqj93P/hKkxSQ8Ut28
         so7lXvPl417RENZaS4sfMpaEphHk6hQjlA0of4DXRP0aXXT4Fu/5TSo3w/y3d3ZKWIry
         VrWE4aM33nZn38/Sqdt00QOsyu+VuUMWj5BnFMQlvzCrMGrDxCyJ/HjsdBbJ86NBzcj0
         9pYCy78080zQPCqf7IGfoi4JaZ+Dh9uw0R7tHv42hJZvd1OGtRJO85BwvujlfPwKdTpU
         l9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768364288; x=1768969088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XoWwSNa3GS6VStvH2Dubk9djiQSV0dHWHRu2xsc9wjE=;
        b=gfisl+F8NcUVq91QzYxg9WdnE/4zK9MISN91Cb0KhZIYwvj2DvJc6RmohREz/1kFWY
         FDgJ6FNlm6Vcsqkji35eTo8unzduQGdG6xGG3gD47gi3ypGbWycTP82Nd526TYglUP47
         xTBaSs5Z2eiwTgXqlSFQd1F07f7oRdOGKShwNm2FAlvF9IyrqJV4+hOWdl2rIyAdU8bV
         DnTVTA4zYhOgQ7ozSnZmVMqKSmDCXp0hb8u0y6nBOpMsdMBkUcSxMWhUgQ5BT3BcYkKw
         yvkaHGbgbClk9iEtRxGn9cHX+4if8XvEr2G1W5vJE09xgdJN1XFH87O8w9EsrGh5VIpB
         3pJA==
X-Forwarded-Encrypted: i=1; AJvYcCVnVpxcPv7313qSDhDXmnAhbABF4aX9at8YVP3ECNMI8nrOSbm2nkI+Z7xzEYyHOizXv7q4nELbJA==@kvack.org
X-Gm-Message-State: AOJu0YzCr5kkYhUV6ksJZIGgUMctHpW8zfHDu4n59SaSNnHL7sIbUXxp
	q4fXgV4EFWltbWi7E/AaMGDXYsxpVxGUsX2u9VwjAieTB30nbsiot9n/oBjhPLq9yRKzOKxvg4w
	9gjnNvbDYIIq3JN9hzLYugYuhKCihUSg=
X-Gm-Gg: AY/fxX6MWwohU7Eitk6qXNaADmNjig5C/oZcnhRAXP2UVB5va0pOJRsLrEi87YEJJYZ
	gooJCWy4jfg2dALfBKhD/L7JEU5Z7pZMVhhNs05zkF/fR3VnI/nkGCDnKGtib1+1bkSEbUy1p89
	EiBeuoFFrB2F7BpdsTdKlhnODPNLG8KhOwC/oxLHjrsJl3Y238PXok6J2VMSwCuIuHdZeLFvh2S
	OBIl4pJ7gQEjqjRPg/cKW+4xjItiUbRyewlUIxcoMc7BkVHpQTmtoNv0B4TP9RC/W24OWY=
X-Received: by 2002:a05:6000:200d:b0:431:8f8:7f1a with SMTP id
 ffacd0b85a97d-4342c5458d4mr1266708f8f.31.1768364288427; Tue, 13 Jan 2026
 20:18:08 -0800 (PST)
MIME-Version: 1.0
References: <20260107052145.3586917-1-senozhatsky@chromium.org>
In-Reply-To: <20260107052145.3586917-1-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 14 Jan 2026 13:17:57 +0900
X-Gm-Features: AZwV_Qh3Ah-9EEniILVVbi_82w3BsgdxatLQHPGeOWCXVq5c-RbqsYdI4CsU1VU
Message-ID: <CAKEwX=POodPuBkKkQvgt7R7cbjJ1z5CJ=sKLAA5uWsEX7OyrgA@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] zsmalloc: use actual object size to detect spans
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1fb4rwpf58tmj5ynb3prkjrcfoeb54u5
X-Rspam-User: 
X-Rspamd-Queue-Id: 138521C000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1768364289-46327
X-HE-Meta: U2FsdGVkX1++k578KGkhy1MxnVsHbZ/QAqM7vqr/05SxDxMppSjYG6X91a9td3yIiAwokYqdWsgr0X1PecW0Mp3q2hqTf2XPQOUkJqUZkWarqgxA8xjgpoL3kxV7QiUCGi7jw9gPgnoYvTTrHKGy6Cxln6hduZoQY3kxJxzPyuQYKkTRc0aw0X29HLncUChfn7NgNOhvLrBIBeUDJJxjH1UpEVdJV7DBBqMVuoUYC1V+JX2o9vq/0fYfmN7WkBTcG09X4D1Ps0eOkcmuTN4a0RukZEQw0utZiFxNCIMBu4UXHTUMxIPwwfj8qkBtJFh2+Jlem1pQ1ZjaCgqj6qFL1CYoFbNpsrIprZcGXBWGwn/axE04lXNd85anRQzunbaHuuLOlSb0gmkN27DdeGcdvP/CgzEvLSkcR113PbDVIpQUpcAzYbnLJ1V+PpSAW+YS6/XwEAB2nnw4kclh2YaKlT2s5W8xga4W8jmmzmsnyJRG1oM2IfbHg93ESUTiP6775im4ra/e260sPNmAloViiJmTi20NLan3rwgXyrVUXoyz5oTV77vWyaIpzCKJA1SWp/s61hwr6hD4pOrkWuQFlyVMQ/X27pNwSYaZKhaOgJwYSNw4gKKfevTrrpfCuIhJHfPOnnJqShH4Cd2BTNvlJjXuTEo1HvUQqoCpPBEkM6tIOVlgctIbBDpUuqrdQggCSwMJZu41msjyz0+bRMf/6j8oN3dZRsOSzmwZkZIjr0uOgkygdUcl6+BwL9q9Em+ednjarC38tps8TeXYvJlfr+DCOTJPrlELGfhQsBcZN4yjqnwcBPvE8IdDiAfhPdzlhfFtX1OehGksJUlP7UC9dvwUHQm2/ySBDqpylwaMu91wqY41fRadX3jy5feOYXY4Fhb7eAcgkM+iJ87OTg9Po+fFDU+QOdJGzl+9tioJkfjrjhlFymZla6C80dqymPcqZnBiVmA6VJbagWJJRj8
 4dkGJyCe
 Nn/9o/xwK0bMsH4A7HLggpaGMaQSujJ0Q9FDOuA7IpryLrFuqI67IxYGgiruaHCGEEocXHnNzu/Ru6auEkdqHetiDq+OyZD4gK7w0ANcdlaY3lYSM5ASjqkQL+lkDE3xfhasCf/QN3EfEGvimsD+sGOK1PUcCcI+N4EyNPAnU2vzGZ0X/GFJ1oheltohbN3uxHQ8UNeM4cRVPJcugZmnvWKnry8Vmz94eUsNufaUeji6Q0648JqTo9czPYHZp9h/yiIJFX6UAo8QGqwAqZVdwIVDqHwZWgs9IlWI6pFCHWis2N2ItrHztiaeVQYy62xa2r1z4Y+yCUkMmavLlXVbpg8v86TYDa4451pa0GszqH1RW7T33pwHuPljqksS8KKNMT7vsF3yr9DIQrvstam2CPOGTVU5CiASYpOztvI/Ddfbj2bA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 7, 2026 at 2:24=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Using class->size to detect spanning objects is not entirely correct,
> because some size classes can hold a range of object sizes of up to
> class->size bytes in length, due to size-classes merge.  Such classes
> use padding for cases when actually written objects are smaller than
> class->size.  zs_obj_read_begin() can incorrectly hit the slow path
> and perform memcpy of such objects, basically copying padding bytes.
> Instead of class->size zs_obj_read_begin() should use the actual
> compressed object length (both zram and zswap know it) so that it can
> correctly handle situations when a written object is small enough to
> fit into the first physical page.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>

LGTM!

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

