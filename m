Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D10CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 18:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5706B0088; Thu, 21 May 2026 14:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886B36B008A; Thu, 21 May 2026 14:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774C36B008C; Thu, 21 May 2026 14:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C6C6B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:35:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1117F14072F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:35:38 +0000 (UTC)
X-FDA: 84792280356.15.DDA7E34
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 080A61A000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:35:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPM6mibz;
	spf=pass (imf19.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779388536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3n/b32Pl3sGuj03TSdpn5xxsc3TrTk3oY9MGONOJUk=;
	b=s7SSJPv/TzpLOVv/VT03zQHLE9uNLiJ/CBrDFnLmDuIOhXCA4BG5NxOarSqDDqOssM4Y+M
	GyRRJNZjTjEGVjS7kIaktMiJPyrUWWWidI1oC+slf/2mF+A82gSYS+PPbzAVdpFRFZTTby
	/gVSdGIzFszGpXEIhWyDq0xYZ553Iow=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPM6mibz;
	spf=pass (imf19.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779388536; a=rsa-sha256;
	cv=pass;
	b=D1U7N0eSVBaKNXgzzQTbTpiYOYR/8rbkTP0vbZYsjTrup5/RCT5O/4hk4s+IZBlhK4NndI
	a8xAawUIu8Gf04tAeCSZ3+msv5AgVU3g8O5FDNR9oEdCe7jYJJ61/6ybEu9RYF7l7PObKg
	VPTvAEO5nnWHzZcYpxunB199j9WnSAY=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bcd3c190f71so1095295766b.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 11:35:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779388534; cv=none;
        d=google.com; s=arc-20240605;
        b=KrTWuryrLf0n5UFTZtj6mgy7PkrcutMoyMZx33VcK8Ix23JHqKPpQn8TFSa7OqbIU3
         rY/Dc6u4IYxpllW17jEdrworD+fHB5ZFycx6pU88kdrEa3Ew1olGWwzw+Z4mQZVRs3Zi
         FxdyD+ksHfOzWjuJFCw32NE7TSAlOWiAkQ5CaunwM/BbUxA/U6C9sWJnSn8L22wHWmkS
         z9fwOGGXPYm1X4m7LHdG5rIRSxOCfCa5l2U2jRDPlXjnNPt3spwhjD3fg1DfSETM0bCD
         mLy//aYRaeqqU81B/twdoIkUcuH3SYibW9Wszal9PJ3qpLEuLOZ/bS1sk1m3EEz5kpLm
         lWDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+3n/b32Pl3sGuj03TSdpn5xxsc3TrTk3oY9MGONOJUk=;
        fh=xIepnE0p9rATVJH1Z22eeEnO6P+nX0bKBntiQHzXZw8=;
        b=BL0smh7Z9Frl9Dp12kvkB4aZKG6rl4sRuA5MI/2kOrxjnxkUjymlHCg9zsXIVwg3+O
         uN254t3axPnSPqDhQgll4rRQxGf5J3xK02uqo1yLDiKkKTczkvkdpitnrplMq3ksJXjF
         GIbhywKO8exvoLubbzNJXCpgS8smE+MX/0/CLLjxY26ToRxRovtYS7Uaw6TqDACiu/zS
         cvhuHMxS24Ukjhl90nz8GQ1e93NxwRBku2yDTU0H31acFYTFuHHmnP//qp8aUWGAe1X/
         DcWxAiSCRVJW+L0oVZLs444zfSEIl2W4tBkYrWKqa7wzxlw8apIB5KmtXewnvdFcX9HU
         Dy/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779388534; x=1779993334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3n/b32Pl3sGuj03TSdpn5xxsc3TrTk3oY9MGONOJUk=;
        b=WPM6mibzbvN0xFD7H2wbONyi+z/LNxddBgApOTqiKDuLlPCPVx9WOBjH5CeEKwRI/X
         iVhpWZc9u7YlRBfvh/RRNznJx5V9hz+82Y7dKI/9FIDann4BdeUlHp/JnlKBgcjVXLQ6
         Nj8Eb41M+odRYmhsvIJtqRrhZX74fXE95c7GSiRcPkF4N+BL4TPmBp99DWEtwtCGQY/g
         V5VPoUQsEAOooIOx9prs7qYjp17uUs3c9WYiL6Pmpvrnpy6USn52wh1I0BWfG6SsAp4l
         S2aux/pKwJgJGmrPThsieHqmQS9bwyFN4MYa3E9nhlLKg49aAxvbamUhJy2AbCf2liKM
         WVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779388534; x=1779993334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+3n/b32Pl3sGuj03TSdpn5xxsc3TrTk3oY9MGONOJUk=;
        b=HwowXsVnbOEzUPJVV47eZR+IXgIVDB5hYzQ51Qe05p5zIli831qjiHFo3w1ugUbNRS
         djECPhZrsuc3DnTobBywN354w4BtWK214QqDHBWXA4mrA7E4LyvNwLUZtVBvuKoGapTH
         74SxVvRquMWDOKIygF0hTJapdjfCxQ/tuoD0yrO016Agn+4hkgEVktI2NfUdFuloXkPZ
         vWtq1qLvkxrnS8zjKO067Ay3ybUDMMQ2ifqvZquQx7gyqatiFcPq7FmPZrQVvO9wXrjB
         qPG9YQoTAPqK5DH2Zr+UZs34EH92kqesI0vyG/Ko2ZkCqv7O91/V+rJC509Vi/R4p8aT
         cEHQ==
X-Forwarded-Encrypted: i=1; AFNElJ9EMze3u5XrzTad/Leqdr85uMk98azQZLLexO2qKFZW8F0bgh2xkIrxkV0RKSMfYWTidpBHOC3Viw==@kvack.org
X-Gm-Message-State: AOJu0YwQQRkaK9KkyLmCk0IJ+NXaKWVEN0GjfSOHoFVppuuvVIHu92xG
	zqL8AcM17q96Zx/S/K1uK61kbFseQO9wEXL3hzXzssed0C1B5Uk7dqTYkzmW04vjC04m4vyUfDW
	eQjDqBAWQR4hS1CG6fhSTNT4T4Tkv82k=
X-Gm-Gg: Acq92OEYiJb7yVtfSIjjdtd/UNMxmeobP64hO49Vb9dY7zxKcU6NNOpuzDPv4ER5jgj
	siKDD8xr56AjYIykIOhXN90g2TKLIufIf/4J3bcfUzDyPcZyMd1GzSeROL99lE+nxMu9/8kf+hc
	w9fIrCTjKfCRr2A2iISJXHjz8mmzpZvfYIQbBEJ5voIRH0ocacJKpnzQNjkWX0XgC+ulRab1Z6d
	WC2bhMAXLhovOcQhCq9AB64sZgGbYbFt/8BgeGfGNiGYyZmLGdvvDdDk1P7I35QLLUfIy7/S8/E
	n3Esxo2SAOVqZw7KM/DkyWtaNAczZUVXzFQK0SezRIa6E+F80jQwLPD6Uhe4pz1HAj7Ozex7mxM
	ZflDvKprnZCJ1q7bEh8Y=
X-Received: by 2002:a17:907:2841:b0:bdb:a45a:c2de with SMTP id
 a640c23a62f3a-bdd272d2822mr20437666b.38.1779388534041; Thu, 21 May 2026
 11:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev> <ag7pFxHpMGU0zLvq@lucifer> <ag8cvjwDGCt_14pY@lucifer>
In-Reply-To: <ag8cvjwDGCt_14pY@lucifer>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 21 May 2026 21:34:57 +0300
X-Gm-Features: AVHnY4LLuRhHwUYNjfALkpCeN5HKteW9dm5fkuBElWhQpWOUtR7NSfgZkS9RdTI
Message-ID: <CAHp75VcJJtfnSYFA8vhtsuZs1gLo+Jpne3TU2WgMZxLiB+95yQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to vdso/page.h
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
	Andy Shevchenko <andy@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 080A61A000A
X-Stat-Signature: kt8aj9q3ommbtmxqgzt457kwmgxdfr56
X-HE-Tag: 1779388535-440883
X-HE-Meta: U2FsdGVkX1/XjPI6mfCQ7jidHG1oCRT7lIiZ7/p/3qOM+6X/2cR2PaTaHkK4H+BQ+m71oAMReJvQ4gHoTwaQj56SGmvxi2Evd2GBQq7F4Tuo7FOxkPqQRg0cOcIv+f8Wnv+bNwzQi30uynfv8QIJgCM04fuRWNRBnrf938OSpypq3LToDP10AAzmOWaSNsSIAPGWbHBIvV5/o4XF+ZeqBcmmUhVozeC85JF5aj7EOAyAdeeCxn9XKqCytzR7A1UKXS6bffbc1jMLado40VjQ3VHwHOEXj+qShMx//BgFmmdE5fpzGL05I0llKceXzvMFcuubdeQBmCeb5xmRXgte/GUuLVcKWclA6YsiIQH8D2V6zULbxjm6n3WuQWM3fEgXj+LDloEpTY5WJsuVM6SqRP38qzQMMmmSUdU7OPHFSYvSeqXt6Y4TlhOJqu+eg7PGjp247KepFa6Sa5LL4455CqAnAHRzju/ICLmqnKeEo33HO/WsEOF+9/ygi0WjXZRLOVswg0/4gSCqYE4/rFI9F2owc1A9EyvdzT3ai1ee7bq/zqjkNYJUwdQKmZY+XU+3wckxD0oJ8RaXjJHQcGQTniNLpN200QYPz8zvYdaGMH7Tgz7HNvWlWYX54v7qm0XWW04/GE8iXdsYWjZfBEbVDUyLKtbeB8PeCFzZYIg5/Zci3+oXzczOC8b0muxOZouW8wm67xJSEjt4tLQThJ+do9KNz0w4uCS/026dL9roxLaleds54Glkwnc8WAeJYhgYP24RgHymiwE3yU9yQhzfVjw+0eTcLC+88M1A0anb4gk9oLjpHm36wPmAgZNvTtPNVkfokEjnJHKKWyFNFtfhhHZlfu8M9N6TGeFdT6cn/Up18QgkrpiAWYtiWnzHRJjeuJXSK10jJUX9hDqQtr7gIJ0PiymAS4lWkQmDW5G+SUc6jE8opQSXG8Zh7zJnlv2ngoFoBZMMFddIeAFfNmv
 9i5/H8lw
 QdoxqbI9xrk0DdmLILCHi2EpeE+FkB2GYk2Q1g2r84VnBrh4CRJOlUc49soiKLMYv6Fb7GoSa9nJjCJhFYxTK5zs82Xmj2H/LLEhuS099FuautstVOTbbYkCPAajDCPJHT8aBQpiZvT8AjOC/GqaDC9ALqxpnU5jLKm4PzUggv5QdLx8fk9YVR62800BiLSR6vDJOZXihOEk9c1Gbh2cevAH6BtDjNPSMErmGncT2hCSSd+VvseC8mWhIPLdWb9XOcBDaBcqF7JcGqznfZzafZLbF3w6Fe3qAZaRZmKN4WEuTzqqBsWfTFzztU+vNpvKI4RLi2+ienQMw9NGH6NW+Id9JZJGm0k1tEraqC92BIPjTM6a7qDEfzXMdJqpr2ZxJlJ0drFPHoWnMkAtX8+WLippqG4GZK2G1yKd8g8fK8vQ0aEWlzL5wCWOmbN+AvXcd4FO/DFrMplUN8zFDjD8wJmEV0FFdVuYsGqo1EakupXGibYtghJ8awfj1+Cj8NqRYsOVNGo/Fc6B4Tl1SJHjd0rgijCG1xeXMiiiMmM8tveba8VMVxYHrDTu7GkhU5L75D7BR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 4:56=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
> On Thu, May 21, 2026 at 12:16:00PM +0100, Lorenzo Stoakes wrote:
> > On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:

...

> Unless a series can be put forwards that sensibly justifies this, not som=
e
> random change somewhere, I'd rather we not take it.

The problem is not only a compile time but more generic - the mess in
the Linux headers. People who want to use this match need to include
mm.h which is a bloated header with *tons* of unneeded dependencies
(for those pure users) and increases chaos in how the headers are
split.
If we don't care about it, then provide an "INCLUDE EVERYTHING" header
and let the driver just include that. But of course, we don't do that,
we do modular headers for a reason. Currently I see no reason to have
that simple helper to be mm.h as its use is much wider in the cases
where the whole hell of mm.h is not needed.

So, the best course of actions I see now is leave mm people alone and
simply duplicate what we need in the headers we want to see
(util_macros.h as a rough approximation, but maybe something better).


> Also vdso/page.h is a VDSO-specific header by MAINTAINERS, offset_in_page=
() is
> really an mm thing so that's another reason not to move it.
>
> (A justifying change would show actually build time/binary bloat/etc. num=
bers +
> involve actual substantive changes).



--=20
With Best Regards,
Andy Shevchenko

