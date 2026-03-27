Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD2A010F2869
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E005B6B008C; Fri, 27 Mar 2026 15:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7C56B0095; Fri, 27 Mar 2026 15:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDBD6B0096; Fri, 27 Mar 2026 15:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDB9F6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:30:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A4538E04F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:30:47 +0000 (UTC)
X-FDA: 84592835334.19.C3CB68F
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 25CD91C0010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:30:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rf7Pja/h";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774639845; a=rsa-sha256;
	cv=pass;
	b=XzueFYCQhEwTEeUS9trR3tO1GHgrWK+mFsBlNc77Sz2DjqkdSFhDhCTyUqI/NZtdSvKxGI
	3wa6hQbPDDRyQko6bj6ys/sDVJvGYUDm7VLRG+dtcBaOHbRgtlj9X5PL+GFaOWWJZofxjR
	TM3/iTAyNhtvfSGrzxoO+tXBvGT7yTg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774639845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ML+ucyszSDrSmSjKc8RyIiw+Io0bDGehQw1OsackIDw=;
	b=vhgL+00jmCg4Huy3beFEEdzJFmbdcj8mq6o8cxenlshTqo2ZjXKzgjlvIyC9YpUwYBgVsS
	twF6y97/y3yFnyGC0D0f8zLpHk8zsLydLStnMBproWNGmMHJIuIiy6LsO5UoA61fPL6Lw+
	5ZdC5v7RdnED/KYb2VbMxXhTDk4dd6w=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rf7Pja/h";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b6b0500e06so3504682eec.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:30:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774639844; cv=none;
        d=google.com; s=arc-20240605;
        b=AAn0ZczFk2rdL5K2iUVfJHL4J86Fa3kvUNHTWViSKmscqwhlYUJfJSpvPm9Seto2AA
         2yBeyek6zkMN49PKlIu0A3CC4nuqbVYwM4OhIUV0JgvaLGiJLYMX/gSv9Q6+PbK6TtlU
         6YFPEdFc6qXZfMhu5SyKxyxzP6x9EpLN7ThYTr5AUoBFuGu12j2QZp+iIh7Gl+h4V9no
         WWv8FoqmLOGLkN5AFKbxoXz/4M0Hvvyy7CrwTvYfQ+t5inEmBNYaqD0c7mmKuwU2aCLe
         pO8VLnNk0flcjs33p0N7E5/FEpbxySR94fe0c3Ru5/hY+wgCxnWfVmeznlyamRLTg1X0
         dmow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ML+ucyszSDrSmSjKc8RyIiw+Io0bDGehQw1OsackIDw=;
        fh=JTpeIRqLgrI3V+e4DSwk7uJf0ZmfIiXHVla//tKcg/o=;
        b=DkSeAXSUMH+2Y6ti0rIXun9V4gy971xxZzGPenwYSRy6k+AVTF9Rj6gru1EUdkvXTB
         YihP7UEq+CoaADyPgSFRK2LMpTW9roCIraWol+L3Ao+vq7NJL8wTAoOtjsY1jkk34L97
         NjxG0wXePQhP41JodL7lOqwa3iBeWPy7Ho15jQL/kTCnoLo8LRbdYq7rSgWo8/Vh9AO9
         v0qGg1xLcDWU5DUrfXJ80h8PgmUeKHDtp17xGjp3xed4dQJc8d60uZoqrxVLpFwKifkN
         uYjm5jQYwkmNCQEUNkmWwo6EyV7tyyF5uUoktY5hEv0Y1822Vvy4KJkGSantl6MJyoHI
         LqSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774639844; x=1775244644; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ML+ucyszSDrSmSjKc8RyIiw+Io0bDGehQw1OsackIDw=;
        b=rf7Pja/hbwcCp30JpjBzebwAg0cuYP1sdHuWaFYybmBDzL1l9RuD7YvqNksWK/Fgvx
         CFhb1kn0oDFftCXhncuuhdWJsvsaKRb+CKixkRSphFWE60t9rzwNQHYAWAAuvnghXoyz
         vKwpnmvgE+Dk74T7DEzYG5FdNzwmj1M2gyUpkCuFA0jRaZ7XWFm1TJGAmerfCf2A2Y9n
         95LVr3JcHEmpeAiQte8UFUJomelzZ4JCmppymX3/W0Y/wDYMNMfna2CimfRZ3OOMMWrs
         QwtXq3aXztF4iP25ylZmgLaBo6k7i7vlADviCMAIqDSYy2o08JKlgPI3dCHsB4Gik36Q
         B7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774639844; x=1775244644;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ML+ucyszSDrSmSjKc8RyIiw+Io0bDGehQw1OsackIDw=;
        b=az4Qm47V5pDCjhKrDO32giGt601evhHeUVs6ELC1PURz0Gv81mYmDaMUYQq7XToOuy
         TUJsNOGQzZ93HjFv1S1q8nKXtzi7wNiQTCRlQGlh6+mmyctw1Dtd+yBeOrwNRza4itoi
         zgBa4qnmwiMyf70qxzZ+8M40T1FYLviKZGyxrbXKJwzYz9L7UleK3ugiS/tBlrfvtPk2
         4hhzVNxxZN+fxY8yR0Zn05MnEyXIb5WxnWKI3iMTjQDkYoisopCZunD7wqyq0XP6ej7S
         mEqaOeAaMyoUeMbHD2ZTcrpBxvXVwAmuKNRtiVCfWY8xHjdkxkj8/aOO/bnvjbnk8Ool
         eLCg==
X-Forwarded-Encrypted: i=1; AJvYcCWXYaLa8Qd8D2HGEtE7rH9jXZimsXmipn86HLoGYqvLeuktUmTegc519QDLN4awMekvdMyISLxpYg==@kvack.org
X-Gm-Message-State: AOJu0Yw0I67P/GsjgZ/zRTdBmfKQbqwhz1amiCty1jqsmmDwT4E6ehag
	ijpUtX1bmHsk1YOoBLI0dkCUFNvwA3V9+2hB1s92ru09L2bZu1yCm2UNAMqhrT3lqiYQhDPsWkO
	rKHAwneLCFtpeYq7e2D+8WO89gK4QI08=
X-Gm-Gg: ATEYQzy3JXUWi/qqctNvBAJgpOsL9eBvet1jd7QqZoqSDelhplarSCZiya5wGYXC9c6
	N1uNPptszmM1mX6HPMV5ULjmPxLLiOkyd/tE39PUWMsBMv4WgvgYgL43qwXicDo6/3FVOBLAFS7
	iVkm558OJyg6rzjabMpugx++2JRIY+KkEVQf27WzGGBg10GqUXAK9tCeLBOzDQBNnYSteQ0/eeQ
	pL7b0jPx9n7jc3CehVZ/TGwPNefkSmz2MR0CmDKtV2oRwQAIu6qwcBlNM0aDYIEaUVYRweqArSN
	Y+8EETlfFChzCqTBDMR+U3Pcwn+tBp3Agf7pQ4lR
X-Received: by 2002:a05:7300:d512:b0:2c1:7afc:df06 with SMTP id
 5a478bee46e88-2c185cdc5ffmr1963092eec.5.1774639843583; Fri, 27 Mar 2026
 12:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-3-kanchanapsridhar2026@gmail.com> <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
In-Reply-To: <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 27 Mar 2026 12:30:32 -0700
X-Gm-Features: AQROBzBcnch79r5a73Jis55XnZyghXcCJW_BGvI9d4XF2Z6lh4r_RGIC_4MvugY
Message-ID: <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25CD91C0010
X-Stat-Signature: rj46ch8u4tnzms5hj9da5mkmtidz61bt
X-HE-Tag: 1774639844-691984
X-HE-Meta: U2FsdGVkX19TERcmZD7L9wNhW98OkmRT/3/Oh1nKJ5DkpFrO5dzwdjRUtjrekPVBkrL8JQLhqOOnXXtuyIy/ypYB5H4/Apx2gEIXGjPSGdeENZuqywJUyWHuu+FLMVpxfzn1w2ptUhHzyw962GK96+o1vL3A0nMvJZOkS9/78YcgeDjpYSDl5fXnlmpCEwltrg1M3ahZQ8RCeFhA/oUf/8f4642Y6XL9NM2VXaXTNzXnOFY8Ry4HUSlsakVonqzcdCC9EmLLUe1OIOqxmOYji4ue1AodKYYwLouoFMVUOsrIQul6FPZMw9Ti7O0rrl19fsdxrQBvgSESURtNb5xZrAY1bz+Q27czJW+IuzRlN2tnJwX/92WfVHDD+W0NWCoqFKYA8tLW682Jr3wRNIvF5sqMNIQSHZF76F701zoC8kBReZ+FDyJxCXP4yKuFJo4ygecuoOEX1eyVpuoN1SmcqUd8eWTr8MN+r79ZNMS+8DlfULyy1S5y2eEKc7xd9aIIOA2drUb3QVv4J50Z1QG+ohR3fcgqBzIB8bDHVCKI4VqVew3jP2NaIsm0UBGwwAt6T+z2a+7gWH9SzsLQzw8KOmrkfkJfFSiP8OdyaF0VCGXUrUFbP64nE4kVrO8OWku3cgnGDvaZz/Cj1ztx4DUfcMPgFEvxAksD2eRVXon7GD6FIOLgtGoLcFwbw9xNdBpdWa7sMON1gljWqtOHPP5u5NzUCz//upuEfsus+2JwJ5Ecpp107sTVugVsxWG/DvPN2neWZ6Q6CyuNt3fAKyHa9b92kiI0gV+vA5tqCwGsQCGISUpAssHb2MkIuYP2VhswLfK1bJkzJsDpkz83vNcaUuzGPMswioLW2PFLIpzE6V4yXtywyG0YrKtq5aYYDzC9cMHGp2kz/meLeJBZfwQ+Tl7RQJBf6RxCXL/IMeHlL79kl5+mt52uCpToCJY3iyodMUIqHf6qmoMd5lV+DRQ
 KUgz/vAU
 6fZh0XmKUbnex0wRhE5NGw2DKKEbDQkap89nKI2+lWy7Gb/xPwUVwlyXcrvArAhQ1BT20HzJD7lt83GTjC8qrEhNEV3TKosuFhvDXuIB9QGjB7PrFrot5fxD1RQ6BGYGEhsjprkmxTOiv15sSw4pKyz7KiUnHd3Z4SWz9LmK1xWoo42DmI0q7u4kdrdnQgrBGfUgY495cMEI1TT37hu98JhdbezoJIU+mPt7/23o/JuKMAE3zrFUNCHt+vlxqxVynKGxORMcqgjZOeU6RKj0hFvnuRojiUNyWBzLxQ/QHe6+zOEIZdKbDex/MHkCAf9fo/nn+VV7VlgdnV7TxsXIrDMUq7jNs+Q9iaCwyphhcmXb1RfQLjiHxcr4tRmOddMvZ9EqsblayWRkSTrl9Ttp5droYKC2ZR+PuvI5kn+YlvPQ3iGHtcTOI9yMnzzQrTBCFPNxJZhaOquGTw2dsXo167hQJgE/jWtYEgbmeI0ji3f90c+vbW8w2cdmydHlEeWm9MvPuzDpvo2Tz9kX1eZimRuTpQq6xcz2n9hJmiGwSD4EsJHVsGwFhp8xg8hoMMgFbrTJjziSrmiuFX5dq2RSFCEjEV84ucQfnhyF8895mYMDo7xBms8RSGdjhgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 7:23=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 16 Mar 2026 18:48:02 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> > Currently, per-CPU acomp_ctx are allocated on pool creation and/or CPU
> > hotplug, and destroyed on pool destruction or CPU hotunplug. This
> > complicates the lifetime management to save memory while a CPU is
> > offlined, which is not very common.
> >
> > Simplify lifetime management by allocating per-CPU acomp_ctx once on
> > pool creation (or CPU hotplug for CPUs onlined later), and keeping them
> > allocated until the pool is destroyed.
> >
> > ...
> >
>
> This is a tricky-looking patch and I haven't yet recorded any reviews,
> so could someone please dig in?

Hi Andrew, Yosry,

To provide some background, this patch [1] in my v14 patch-series was
Acked-by Yosry, with a minor change requested [2] that is addressed by
the current patch.

Since Sashiko flagged the same issue as [2], I did not automatically
carry forward the Acked-by.
Yosry, can you please confirm if your Acked-by and comments in [2] are
addressed in this current patch?

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-24-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/comment/26773986/

Thanks,
Kanchana

>
> Sashiko wasn't apply to apply this patch for either the v1 or v2
> series, so no help there.
>
> Thanks.

