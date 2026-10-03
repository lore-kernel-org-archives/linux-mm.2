Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71248CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 09:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB53E6B008A; Sat,  3 Oct 2026 05:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66296B008C; Sat,  3 Oct 2026 05:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55996B0092; Sat,  3 Oct 2026 05:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E13E6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 05:35:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42C2940947
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:35:24 +0000 (UTC)
X-FDA: 85280806968.18.950DBBB
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6916320004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:35:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YcDzykso;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791020122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJ7dg9bzjexKS7EJFyaquyh0xQqCvcDaJqmOvhyWkVw=;
	b=LPGBguc2gPYTdffphm0aE5AEFfLIi/LroPd/vCrvtZIAhfvnzbfK73i/lqxrAoPjjz9o5W
	1JWnG+D5LZ9HpTGMRFkyNYDbiMaxY/NF8ZgRT2WlCgqt9rTuKn0wBkvAm4doQID6jWVWL4
	myVRBLP1g51wCnsQs2hVuH5yc/iD8JQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YcDzykso;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791020122;
	b=UAwCff4omsRrd34qPr3v7ZoQpAzf21cKGsl5Y7wtkdNzUnCfmqmHtefFFvGYiPpvZAGUQN
	PZ8di4SmgzcLWXitCHmHtoExLm4n9rZP/ymLwHiGyUtyZnARrW+4hcYlIa/FOBzD2Jh7Zy
	Ggfvzlo3+jWtckFXEuqBWkgq057BXYw=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b0d19cf7eso170790f8f.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 02:35:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791020121; cv=none;
        d=google.com; s=arc-20260327;
        b=p9vL35BBQndE7ZQ0L6xFCgqH00RR6vpubd3xN+Kn5tX2IH4hGinJ63+u6a/DxLg+9b
         5nK89S4DzJwmR82s1eR06HGNHceLtdZe1h3NxYOzrFZ5EmirGByjCIOOROcjyQ8vWgcA
         jVgZBq2Kq6mmI0CxCbh9AAbjnOVyUwXLPyJ0P0uCovvYGaQXvk/uJVFSWyXY788kWHc6
         Pk/ZC7im5kwxl0jNFaKbo4nSpTyoClej3vrJ9L8X52bUcf1mhYyTitJlnHPiPmY5RKr/
         0z/bdlTbCfRwV+oMncmjd3/dovfAokq6gmoqW3JBgVts6IiPuwqbmwOrGr6wmn1YMqz2
         DgOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qJ7dg9bzjexKS7EJFyaquyh0xQqCvcDaJqmOvhyWkVw=;
        fh=Rj17w7IjIdDJtyyerWfuJTmONAKe8HRfiwUx+1OULh0=;
        b=W2obSvBvHqPCH8DDgy56ZaCNKxLlFrBVwVCNzEIjQanYzniyFeLYe8EN0CoiHlVYEZ
         9pZk6frFUT3uQ6NvhJbK05+K41/XFXE/8Lg/qAgEcH4d7ywMmomadYrO+NfjXZhliL/v
         vuqjzsatPEq2JfsqP7m27N/gYtKD1C2Qp3iV+Uawqs5yCvAr+9A4quiM9h1BUe3buKi3
         KXfNM7ZVrFZe+xC2uIuvcpSY4zOhJuzuwXaWFONSeTcG5lDkl+tlUakIPYNrflgx6Lol
         bDxc9Mf5dbxwarHeo6bokm+Jk42yWvsG9s07R+cMY3MP+DWhk3mPB9J1X7XAwhfZY/Hz
         TC2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791020121; x=1791624921; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qJ7dg9bzjexKS7EJFyaquyh0xQqCvcDaJqmOvhyWkVw=;
        b=YcDzyksoUc3p8lFzpi/++QYVQEjM8DXCJ3Lbg9j8+1TK0Jh1jIKhpNh58PBoHWraj1
         zl9nGum6ddw2qPXmFXw0bRlZd0AAQeXZVTekaDXOBZIy9YobuAbO3TyuOWP9NH885j/F
         B2StiKdjQawZWvBOAIlkQQIHgiMkEiV7RA9ZLhEEaeAftFaW4tDsVeDK51WJgQTLswQ8
         vdvf6eEEmySPITnW4/Y1leer/0Tcy3FIoTQXXeRU/bHYxvQk2agVPElWH+1DKgkY3h/Y
         uAvLx0LXzlOMmYG2sDie8iW9tMpEX35MtWH6HJNU4tK1uZtT0kKNTOcbRsiWSbIn5u6Z
         4yqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791020121; x=1791624921;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qJ7dg9bzjexKS7EJFyaquyh0xQqCvcDaJqmOvhyWkVw=;
        b=D5KrneU+uB3C8g/QPqkKGww3O433C2AbGcEmaPiIvhkLj52U1vTKJo6mhH+rpLLaSB
         KTDB7rKXuA9YSC3T1Fhu15TmOxSTUjDwnAjuaKLSkhYHQ0o3vvbVsqXPjUVHZdr2D6u4
         joDfkItlZ+JRkWzSxfC8efruzf8pPBoGrPCnvuQ5rwV/pOgJZM+pznuBF99DzOlM2u/n
         CJDGaz5QPS/b+isI4DpZTBn/VNkE2tA0+UbkTrGva8NyQMf36X0P64+e0fQNILKGcjtw
         SQe+La634Q+J4QC5KbR+y1yGn5AOSl12A/JBB/tdZ7fhN5BzTEHiAoPeZw1Gwucy5pgN
         nF/A==
X-Gm-Message-State: AFq9FYJR2OrsFoA5hxDhZtyJO09cMa6JDsBgb4o4P9mQq4QuwPdo8fS8
	CP4n5Rl5m2g2kbo7gtDjUdMPwryypRVOK9lT4gVZHAlh/Fu0NRiB03GYb3OidaUouC/3BKSBAWz
	XUz5oLVsA7oD3pyaKGf8wnU298Fm1ixc=
X-Gm-Gg: AYBFou3+YXFshm3zAVdiHceM2W9qYhQq+P77Mz1pRlEnfk4big1ZnSsPDe9jrkT0dpV
	9SPX/8y8fCOE7yql6yEF6eDBghuTurSVAMM+lztslvhOTFExdYLOytO8ggSSiydXgWVq4644B5y
	5CxSoNThUQDfKm39aMI1QiOUvIOAfobzkul6wZdfb4gfgTR0ynNodkdi6oZESGryKH3Rdv63gla
	64Cdmf7r/58C6k8dVQkeNhPrG2NStZRDiEjbigOENErS6Macg1/pYuhnEiwFHWtBXyJPCSFY8+/
	saS1bNCrk4OeBQP/JZzYnYbyCO9IJaVJScqA7PU0LsCKB+9XpxQ2uXfWOr5DcI3nt/AG4+uU32q
	OrImua6tdaUM=
X-Received: by 2002:a05:6000:1446:b0:488:868a:1b88 with SMTP id
 ffacd0b85a97d-48b067a768cmr17251907f8f.5.1791020120762; Sat, 03 Oct 2026
 02:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <20261003005900.909710-1-hebaoquan@kylinos.cn>
In-Reply-To: <20261003005900.909710-1-hebaoquan@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 3 Oct 2026 10:35:09 +0100
X-Gm-Features: AclHuK9hDhrxSCAx8Tiiolr9H9b0Ebqv7sOnbKI-UmBAkesAyR0Y-2xLKv5z2Jo
Message-ID: <CAKEwX=ObA6NQg-24jE+BT4QksamwM+hYWWxfYBYa=4mXvC3oUA@mail.gmail.com>
Subject: Re: [PATCH 00/12] mm, swap: give xswap a physical backend (xswap
 phase II)
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, baohua@kernel.org, 
	youngjun.park@lge.com, david@kernel.org, kunwu.chan@gmail.com, 
	baoquan.he@linux.dev, gourry@gourry.net, riel@surriel.com, 
	klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6916320004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1ptbpkg7mcbpe1ja4hdy7jc6515c8fq1
X-HE-Tag: 1791020122-887879
X-HE-Meta: U2FsdGVkX1+UxZBI/8M60Xwy4ebkmnjAuJjWJojwd2V/LB8yzLySGCSs1pVhDqewEpb3vs4WANB2N5PA//mEs7axAOE5rVDzcNqSMb8uytI2oF2CTfjAZLuiZYrijpr2ppIp+pt4YkDVlbDfkRfGHYkBfOAq9dYvI2TAUQRaFI9XVQGwjp4HTWX7UTBk80OjHzyF4J/AFr4rSe44ctyt1dZ53FnO/mx9UAnFrgTuZaIToNFn3e+eKPlLJrF5EcUahusOHijZ4mQOcBRj3Z7oTYlL/kaGIOS7kTCXxySFTrvLsWxVV4xkpnIme8La25LubdtIbliP0MxNq3AVLMe6KftwFQCdEj/xZMVl1JX/3dHOaq9O9C+tQVIku6Vrc9XLgUE1ve6nCfzqSk4vxDwzDAP7tC8/DaR1bDOGSQhXNQE2Ge8g8DlWXEr7HepzBnxQdN4kydVEPhR4iItNRAEUocOxCeBdGBadM2/LOjZffJjg28RPkFyTP33B4jrXFdEekwFOgjfDT0gHAqsnNcQVadxWNjPto5OGnyuGGG+GkhMStQCAq5YsLdBFD3jaseSE753GjVQ71lsGKJXBh3CSepP9KX/h9WagH2WV+69e71Zu/1/NM+avtax1gNtgAsud5HkgjFpGSYyk9wp9mwQ8tvPF9kBPT1Vuk0XXyns/6ilHRozu61BwVT61cqKd556Xs+elt+PxkdycJxPaWhIZbzqY54JmItaCpFQWvUICezmtIF/MrWsTRDEhjZP2Ohn+PgJtXfGUWvTnm44E/leiAlTXg4yOHaJKlTbcCrKndYO60Ry0SHoCPrOpzppjGorQmQsHd+jKcugfN9b7ZLlumO+16LUS22hiS6fS+b9m0dBumccoG026JMsB/ecPOmFzIW7cIfQxfjsI3QoGRstW8+FRKxYT1b0CFZU7VNNgPmxkxYttrbGV/r90djgoneITFUL/J9A+t1oGNcNq/Vh
 vRvFIFhJ
 XMmx2r4xGUlxykH3cYsjnBKTXn/mLrz0Q/Fb9Nf0+T4U5f9F+FCuS23KOgUm0Er9BNcvYEMwa+7SfUIniEkDUdiSZ41Piks7jMLWR99CQEzGydPwZsM5jv5x0jnTZaZ1kUtQVQcHM1dmh53H3NQ7b1w//UHu0j/ui3WW6+D6Z+39zXEgm9maq7lytxMLhSwZjZV1FP9i/1Ab++oBwrCoO1TtXbwWFUy4x0roLUC2rnmPPRTI6pmdUtg4diMxuos64lF9BldMxTq6AIadBcNg7hBn9U+hp0KmM2YDT2GPaTRwIT+3w35ttvFW+P7WbKTyDQjwt8qvQ8I8Y/IIBFvqo9GEtcaEP5T2k1XqZF/jc9bJ/StvocvX4WL2AOZikqR9pZGbL8+FEDlYUPZev9Q4XYXXfvOWkYRADCR75f2GXjXUIctuhjhT5QWi3cCFIMBZw+aL2xRnJVuWCgrJfjL9q9XW3tt3CYCR0lmuFbgI3lPzPvUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 1:59=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> An xswap entry holds a page in zswap. That works until zswap will not
> take the page. Then the page has nowhere to go.
>
> This series gives an xswap entry a second home. When zswap refuses a page=
,
> the entry takes a slot on a real swap device and the data is written
> there. The xswap entry does not change when the data moves. It is what th=
e
> process's PTE names, and the physical slot is recorded behind it.
>
> Phase II of three. Phase I is the device itself, 14 patches.

It's not cool to take my idea and code, modify a bit to fit your
design, then send it out without any proper attribution.

Adding a per-cluster array to store backend (in place of the existing
zswap tree) was my idea. The only difference is you put it in the
existing struct swap cluster, and I separate that array out into a new
vswap-only struct to separate the vswap-only metadata:

https://lore.kernel.org/all/20261003005900.909710-5-hebaoquan@kylinos.cn/

which, ironically, was also my proposal:

https://lore.kernel.org/all/CAKEwX=3DOvR7GbU_9f2h_MtU4m0g6s-esHmNQKYNhJz610=
M0P3Sw@mail.gmail.com/

And that's not the only one. I mean, you're too lazy to even rename
the macros of another mechanism I proposed:

https://lore.kernel.org/all/?q=3DSWP_RMAP_CACHE_ONLY

Yet, my name and my work is not mentioned or acknowledged at all in
this patch series, other than a small prep patch.

I have been very polite and deferential so far, trying my best to
accommodate your use case and innovation as best as I can, even go so
far as testing and debugging for you, because I want the best swap
virtualization scheme for the kernel:

https://lore.kernel.org/all/CAKEwX=3DPe+qMZd2xhnU-PAGQtgXkp56c-JwYCbt2Lux9h=
tgB67Q@mail.gmail.com/

But I believe this has crossed a line. This is a very unprofessional
and unethical. Be better.

