Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9B97D172B9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 03:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2F46B0088; Sun,  1 Feb 2026 22:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E186B0089; Sun,  1 Feb 2026 22:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3906D6B008A; Sun,  1 Feb 2026 22:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3CD6B0088
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 22:28:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3DD4BC524
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:28:03 +0000 (UTC)
X-FDA: 84398082846.12.A733D09
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id A79D1100008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:28:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mw3bNWaZ;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770002881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Xif1Y3fqgLS+V98gEIZsrXiCSs9ChcJ9ZmM8s1HPd4=;
	b=ufuwRMe3jgwIDi4xR2CdLPP6Gkw7UkOJEo1gmBk+MIQrU2dFeHS7cP/KdgSwxyt+5v8FB1
	QqRcRQVtOhOCkS9Uxw9z6aqecLOiMYUoermGsbg+xEReKIedv4THq3v2d9aZuvH3daQ6Td
	Rgw54mnHdCkraQeA5oVQIJyl0oYnFIg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mw3bNWaZ;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770002881; a=rsa-sha256;
	cv=pass;
	b=FTV1ROjYSoQdxFXMzsOjiTP5G8x67rI2AzT+hL+h+lIAS88XP0gKXrieSjMZlnB2jyGZe/
	ebygJSctESDnBV5P4aJ8R1L+Lqm30LQ64cpLnloytKJoAKcCnEisxe4vR89QO1UtXclW/f
	o1z49PO8HUGlULOxG9oFAdxYz6ra3oI=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so4908209a12.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 19:28:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770002880; cv=none;
        d=google.com; s=arc-20240605;
        b=BGVvRSQXFIo6UIRni69WMDOne7+QR7IOcUfWIHcLjVCsIopB5eHOgdnMjIjQoAFDmV
         woasydqct5feT5IM2ODlF5PWMXGNQHmQQtYnNKSTX4R4FdTUBhgLa4D7Wx88ByutlfZC
         d4vGuW/ltJAXLARQSX+UNn1DXBtV+wrSQHJU1w0jjvwcfhIgG6/OGBhmULIJy7nG/QNd
         HMpYvWQEVA+VHT6jMXzfB/0In1wg33JeBYbyCv9Yq3IwqHpS16wl5SRlTJDul97GRhqo
         E6u/CSR9WW7rVh5aFsvAMd8xH9U/W8LIs51mOu1DDaDsPfBZzVeVtoxOpvx7xoCyCcDZ
         Q8zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Xif1Y3fqgLS+V98gEIZsrXiCSs9ChcJ9ZmM8s1HPd4=;
        fh=/M6izUITbQHV51XpAlhPrY4uuarulwks39xuCYuWN1E=;
        b=NGmR6mf+6yeSsmOtOcY2XjqNp4yYV0QLgMgepk1F3WWt3Z0RLeY3yLx8CCXZ5aYDLu
         iRXO1PSl7rJPE3j+3LRpeZwnghlYpRLXzeoh3FyEltzb1Ta9kkLXQMj3lwUkluk+0XPj
         jHVxWZsR03UU019HTNZ2KLvc6fQFkNFwlV51mbW7gemN6Z51G9jArS3WnRfMOTcMDzVe
         diykLU3WVIMJetoY7ztaGHKkUokmRWmDHarOQpwtHeNvWRfXniC4BSFqBDBGyFd64T4y
         mehvv7O6JfT2J17rl4vJqw/1ewuuwGRvw74b5+Lsk2BbK0uZAqp/upUJhlQbd/K1NkBF
         YTMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770002880; x=1770607680; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Xif1Y3fqgLS+V98gEIZsrXiCSs9ChcJ9ZmM8s1HPd4=;
        b=Mw3bNWaZVctV60X42eS0y+Pv3v34w2pE5/aripEo6kk+BAifbiBuyRiDs/UEmNVPeA
         6XWtFiRYoKlK5qvyPSgxdbHuXV+TSxMHgyAq5LZ19+Xsi/xWtP9g/AC1GVO9iBkjuzz+
         z9LyW/f5J4iX0wkfJ+S8tjuvK+OIyGeQOdYhXo3dRSvKqPNA3j2oF4CDhjvEwdchG7kE
         QFA3aAdV4cooyejFmltwvMkmdvy1uWkeSj9WSV4rQ6X8wI9avsOBtUGct4whbm+gezFc
         e9sKrtL/drkYCMiPkEeL0SkAfd3vPr4cptTIyWbXkF5VSOgbh43n0ioxLMqQlCkUjHBc
         Np4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770002880; x=1770607680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Xif1Y3fqgLS+V98gEIZsrXiCSs9ChcJ9ZmM8s1HPd4=;
        b=tZfrKhp6KuLLbdAYWNgvozDskK20AIq07q3+DVNn6tGUFLIWcr01cX6E5Qc6X5sU/I
         b0ifxPNqbR0KvMCAPSu0c6OhS9gq558yJ/TJi51i4CzkN/PG/Nfs0jdiLzd/h2Hx68VF
         GZDNA/sLcYl8/BEhTaSOad526zbs+MP25HWsyELq0MY95XWe3tZzsa/kr7USkaTbw/y3
         ohtUbLxEA3UBqZPNePFFinZqDLbFLajmNk8mzqS7pH7XfrtDVjlgTaPhOQFQgf3YlssG
         IGq1p6MIVnoh6LhjAa/2uUO4OKyOpNyT2/7DqcDGe2ZYh3KzxR/axGU60QNSSBsbsevK
         qTlA==
X-Gm-Message-State: AOJu0YwQdikB0TM9zXOlvFrrM5TAP82Wta/ri2BVuieprjfe/pclvXSm
	ZYAj/yfXM19gZ3F81h2AOEED47KTrg0F3lVoGoFXSlqe11E8aEy7luJdZoV1DVeWFXXxI+y6rVW
	E7T4eLg4y/JxWdRyYXVR0CoCs1D0HwyQ=
X-Gm-Gg: AZuq6aIV9RjHImrUQOPgnJVVf+LydJJALsDT1/wAIJLg2XcZ/KR+TLZhxAKD9nwxEMI
	OBqbD6oBxYh1n5XaEpMca+SNMIINBCvOL2gWq9RaaMGeUrNv/MIrPf64ObzS+Iyxwebs5qfr64Y
	ldXJvs6EFqHoEt67do4KOvif+/1/yyuK3CYGyyqElkThTk58YsAjUiZ9RklxnQv/lKc84yXiEX8
	kmzFi5fBKTI3m+IT8BwaPfJa1k9EeyvxfPdQbSpGd1zVdtXyVUk83dVBkB1ioppQ1btNmrIo5Vs
	u/Q6qcMTIrCmvfCkHozY6v0Mv81p
X-Received: by 2002:a05:6402:27cd:b0:658:2e84:1b48 with SMTP id
 4fb4d7f45d1cf-658de5a9083mr5402330a12.24.1770002880022; Sun, 01 Feb 2026
 19:28:00 -0800 (PST)
MIME-Version: 1.0
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
 <20260128-swap-table-p3-v2-9-fe0b67ef0215@tencent.com> <aXsaNsUFCiHYrECk@yjaykim-PowerEdge-T330>
In-Reply-To: <aXsaNsUFCiHYrECk@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Feb 2026 11:27:23 +0800
X-Gm-Features: AZwV_QjihFrmvSHuJVYd8nzxllaeJzYJZVz2nfD4iMpNamhxeay10_o-S_ay6UI
Message-ID: <CAMgjq7BYp8XwzzRiFDs39QDs3ZnK5p=ZZ+4i5Pne846OSfbqRw@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] mm, swap: use the swap table to track the swap count
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A79D1100008
X-Rspamd-Server: rspam07
X-Stat-Signature: bsujq8dgqwoios6ofbw536amrtsnxyok
X-HE-Tag: 1770002881-557904
X-HE-Meta: U2FsdGVkX1/E/qQl1YF9Fw9QyaKDQwzIoJWjnWU9Q/Oj9Kz2gucjdlkoVlcPZKiomJiGCP04v9DwOvwUwBh84A0MPf7cqQJWwsvPoPr+oMZ8MkGOOwbqKaO1Bz3/5nGTMTreIJixRz+Q+I4AWKbYJGOoYoBAvkPDhO+iM/kt6vtGlgiqdjrvqXpKMbFbEYpBCYWMlNYyDdyRyxTRtbolVZwDaY2fQP3PltRcsvxZkVcYW+kWhfCuegnVqVEkHwv2DY4WugJZFJqP2JwkaaWLnv/BIxGetA8eFdIl4oJ38g98kTg3Heqk8DNdUTXzeOqWuyecnVVHzqYrOykZXRqXqxHYjfQUWJB+zIQ16Fai6udlJu2ezncf4Gi1+AqBz/Prht8/T1QmLfwmQdrh2At8iZNQQ2cubxPDkA8Jym4pGVaWzqOXu7KXfBDVIn5WVoqHfS2p0geUYzRN1aLd0gaTutzpYj5Xmo3fm8KaLerL3t+wDmEu5764SskQNSLaFSu001JotaPr2aTZSKNntMfMTd6KxzVAZdDwl9WRS3g+2QRrPpCXYlo7yKoqxZVGxPpIHmbggsC3ogx0w2jWXL4s6Q5VjRth6ZdzoGy/Cmmuf4Zdg86mYRGmnDyGtTFE+ed8gK0OjaO65GqyCeuZCXKSIbDcmK7xdzzpUoJAiHNyEycwO4BS5N5eExadRWX6M1QTi6RuaYYoFWq+rpgxRYf0jCitEBwb5RI7Os88gJEc7dOfarAbDnAUnO+jTLSDkIIyTELaLvs8H37LNASraX6RfUuD9wKTTL3S7azaradAYT+cG57YouXloEuE+4SycGiADxFFecHtt9DIk1suGNm7JEx83UfjC79h7szlb4klewltv1Wf+0cikYNvZ0O1MJZaX4HGnY70O9iEENlYDc5nowf3RuXPbbNs8qLAPMfGSxq7kemdcqlPfQNCTEtVVtEi6JsrhiYdaNjncwjIS89
 R1I5MPhS
 LBovTLN+mV5o5ZzMDhnY+LdUBsIo1OGoIyIJn4HzL8Vu/LpsaCfxYmZtukBUoSFRAccZFcw5lK/42L/szRCFqkE42lWJYwfRz0eqL3wXSIuoJbpwOKcqV942pBgQ3TwOFgad1ty3i4bv+a4JJkSQZJIBPQHmLGbVz6v9pIY0Q2Z5eP4I/dc7n60EkWpG+1/lilXN0DIFYCRULg07d7EfJ4y7IG4uM8Mw3ffLNvHynUMD7T8rBIGH0SfcYvkSoQ41R8YCRBvtuiBBylIJIrkJVjIp/5Ix3DZQoNLxgM71vJaP/PHtJyr3Qc1UWtEKfa0jml7G7xtGeDu0dQQLH7oRAPAZtUm2GgqMIrOLpLmdAc9GZBgaTqirAsE5wI3VvjGnPDAp03vmauZvLjymURsNWFftLUcb2bPt6o32snTCWVZffNzzqUpy6moTxaYoWqKtMHHGQtxlk7Yp3yvNHEtMjSfcIqMLrJdR9tWJdRNcaIHqHhzGsDf1nkSk92rhmOSxkV18CG9MPqXOh8VJnlnTyZ3NO5VF+cFHEm4gU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 4:28=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Wed, Jan 28, 2026 at 05:28:33PM +0800, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
>
> > index bfafa637c458..751430e2d2a5 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -37,6 +37,7 @@ struct swap_cluster_info {
> >       u8 flags;
> >       u8 order;
> >       atomic_long_t __rcu *table;     /* Swap table entries, see mm/swa=
p_table.h */
> > +     unsigned long *extend_table;    /* For large swap count, protecte=
d by ci->lock */
>
> I assume using 'int *' is to save memory on 64-bit architectures (8 bytes=
 ->
> 4 bytes per entry), which aligns with swp_tb_get_count() returning an int=
.

Right I used long as I'm not very sure if we will ever have a counter
larger than int, but folio's refs are int already, so using int*
should be enough here. Thanks for the suggestion!

>
> Regarding the extended reference table.
> While I agree that a simple array is better for speed, readability and so=
 on, the
> 2KB overhead (assuming SWAPFILE_CLUSTER=3D256) might be significant in
> constrained environments when only a few entries overflow SWP_TB_COUNT_MA=
X.

Indeed, but note before this change, we also have a 4K overhead if
only one or few entries overflow CONT_MAX in a given range. That 4K
covers a larger range though. And entries with very large counts seem
very rare in practice.

>
> Have you considered using a resizable hash table(example. or something ot=
hers)
> instead? I am curious if this approach could be applicable
> as a future optimization after the current code is merged.

Yeah I do have several ideas about how to optimize it :)

Currently using a single plain extended table simplifies things a lot,
and I tested some common workloads with SWP_TB_COUNT_MAX =3D=3D 2, the
memory consumption and performance overhead is looking good.

A later idea is that we might be able to move the swap count into
folio struct for cached folios, and remove anon shadow completely to
only store the count for swapped out entry. That way we'll always have
zero overhead even if the swap count is super large. That requires
some tweaks for the LRU side.

Or if that's not doable we can use other ideas like you suggested.

