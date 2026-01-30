Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78ADEE6BF17
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 14:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE32B6B008A; Fri, 30 Jan 2026 09:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64C76B008C; Fri, 30 Jan 2026 09:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939F66B0092; Fri, 30 Jan 2026 09:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81DA56B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:18:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E1E81A04E4
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:18:37 +0000 (UTC)
X-FDA: 84388835874.12.F55AE59
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id E74EF1C0004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:18:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=snai.pe header.s=snai.pe header.b="o8mLdw/f";
	spf=pass (imf21.hostedemail.com: domain of snaipe@snai.pe designates 209.85.128.181 as permitted sender) smtp.mailfrom=snaipe@snai.pe;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769782715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVl/DuPjpWBTzeLaOSIU4kHMwzFTVV5s3STIHrfTBKU=;
	b=v/YvvFIWcQPipMPOc8uSC3WE4GyPs7KOAm7Sc9Y3fSrkAyBtSviyA47Y7To7T5ZvLHVgSc
	bVY1cVxy/txe9sB1tf2BgXQ8UikVlFI1JnWuSywv6R0yafAyukNbCuGZaL4tbh0ZxOgAE5
	+tbq7MuyGdtC34kCVJ4oJJgzEK7hamI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=snai.pe header.s=snai.pe header.b="o8mLdw/f";
	spf=pass (imf21.hostedemail.com: domain of snaipe@snai.pe designates 209.85.128.181 as permitted sender) smtp.mailfrom=snaipe@snai.pe;
	dmarc=none;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769782715; a=rsa-sha256;
	cv=pass;
	b=JmG2QLfPufD9YTcci2FNOD2SYdY7Ivdxl0qzN1vn5fXWQMv5KhoXNrCmv79bPx2jM/CRBu
	pCdth5CaI+f12bHArs4mKQ57yqAqkIL2Ho2PzkBD09hgUTVps0p5TwNWoWwvogmnh1OJ4y
	hLN+uIGSXIoOyDqbSDt483mT13rLySM=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79273a294edso21275247b3.3
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:18:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769782714; cv=none;
        d=google.com; s=arc-20240605;
        b=TulquSlDnMKAoKHTIQfMPMzIUzgytkltWKrXH5hC3aTmlFclR2DMxnGHj2KqxNToMf
         i0dCp7wIFswfUqdnWnQBqk080imejGCWAkh7jqXCdGlBvPMtf2GJ273bcwSeN4TcALLe
         giaZKjl5rSAvIx8uLr2cJ2hu19+8NpmlhOJ9gdBHU5yEv904I7oT1PoVcVt5m8w4CxQ+
         edYbZxdLoGTt96Rj0WOENO+hfTc3Z5kMtfxq8rHYjVtjfpzfU08DSwTqgn8ctO9JmGFE
         L7ak+hUa1j+ud6+OsOMW6hWMfkrnPVASNDedgBdQkWXFq53p7bbl02MgP0zsqJSK8dOF
         c2Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fVl/DuPjpWBTzeLaOSIU4kHMwzFTVV5s3STIHrfTBKU=;
        fh=M4h29L9i71Z+al3+Vhy+70POrW7Ry0B/HpxaIwYM2e8=;
        b=SmLbZnoxFrFfSzFl/CN2akRrKVXnbkFaemI2ulxE1hf6IUPQSvrBJGvuxvmjhG8yLg
         xsbyhHPv8tQtJDJy1di+jsEsUDrfO3WEGufQ31OxnFZxWWlAR4jORg1CL6fOaU+jizuP
         fbsLjWtay33wEDkjpkaprP5xtZtOmfq3TevhnHiUtVuX9+g1lmzhd/iBC7cASbSVnDfv
         R2LO8BUDdouIQXga3E472oarWBCvRepcos1jEnpq1NK/WvLEkH4Uu4DTvbmeb/I+0xqB
         pJVNLGCbkWV7e2G28sGarC3jYtH64yzguT5wCReiDhCpsFx2NrPZsJyZNQPC41ClOdyv
         Mttw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snai.pe; s=snai.pe; t=1769782714; x=1770387514; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVl/DuPjpWBTzeLaOSIU4kHMwzFTVV5s3STIHrfTBKU=;
        b=o8mLdw/fI3470yNvRZ9ftNEPif8tyfkmY1PZKEkncnMr8hH5nvy48zgqvclpe/es5K
         62tl7P2rsDcqAPoVAYONinZCkerFdEc+qaiqZkMr1TYKadPL1AT8bgHnjdkVIjRFSgst
         +VEYtH0dDmDAMVY3Tb6sGrgnMBc7dqC6FcIyAeOzh4mDMyNHF68eg4dX5M2UVnwxY7Up
         vTXH5WC6GOQdv/CqN+nj2gohas7k+Z0nth6sXPCuG6b3n6vPnO9Yb59TcvJVxAhwk1pO
         /1XEuBu6SQe6DvsfoOwwc0AqWEjVM1VNGznZXInrKUdYPo8ZjJPtppZjU7MOmSpj96H6
         wguQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769782714; x=1770387514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fVl/DuPjpWBTzeLaOSIU4kHMwzFTVV5s3STIHrfTBKU=;
        b=U2cbiDlxqE6n1BfhMpb48jnRZkLXTqRKb+LVJS6HCtz+BjlACUbdi5znQnZ5UxWbSB
         P3lHJKsEv40SF3+1mLV9vfE9J5sp3k/Hr5ebNDjhA74XarblWxvn9Vxn3AkEFOBojnPL
         Q51AMZh7RHpVXQq49lfTbbC/JSzbJTc621Dxg2oJsDPBSKT1ufk10Swt/2oflJn4z/76
         Cy1PwBWrLDYHsiyMFqEvcHODvfOUrA33/VvWpGyimn2D9hfMkUqS4LdRvrWDMdbFjVyj
         +vD8zenv8o3NJO17cvwaDS84nLsdhfwdGgUXK8SS8cNGTAm8hcamayIelPTJsH5s0p/Y
         KN4w==
X-Forwarded-Encrypted: i=1; AJvYcCXjekCtIg8qoBdTDCbuK1ZeMCqEKaqiadS44hCeIUc4ppF1ZJY/DJMcuTzcsV1QIiOedG3QWzi+Eg==@kvack.org
X-Gm-Message-State: AOJu0Yz41ANmy1ptSsewMYgkEDLPkmBlEM4vytl8DVqLqGpOJ20vTPpl
	eYkYilUw9bmb4YTWzdGdqivYY2lr/YYsuL6QjbKc6K2PPJBCGw7kE1SmhwnLz8aHFBkAhv0vntM
	jfJd5i5R76W7k7gnwRw0Rsr8MqiBfxyXRrqgFMMBuyg==
X-Gm-Gg: AZuq6aJOhqnD8cOet3FpG68ZO6CJIZhFMLeOED4Xmi51DBDijellu9dfqKENyiDcgWS
	aECJSHq5wC0QoXKSFZ35y3cYau8UAw9tkuDCE+Rf0dSHfqJR+KCghT/Cffss/ICovxIJDl9K6AB
	JkuRXGKiaSb0415vt3UVDf95vNtHLP4R6A8jg3KbQWF9oDW2chlr5SSSzfW+/CajRLeONK9dDHS
	jhOA83ThuF67mQ1ZWbM2YbYOQlgxD/iNDNHbStKRR+437qEqMDUn+9U7/SveFYm8YMSDzyfxDP2
	z1WEZLdUs4tmSReCjZ2OdWhE+XTCi0GcT4ZcRY06txL9Jo1DYFJ7ouP8Rg==
X-Received: by 2002:a53:d017:0:b0:649:612e:3f38 with SMTP id
 956f58d0204a3-649a8525a37mr2096730d50.93.1769782713797; Fri, 30 Jan 2026
 06:18:33 -0800 (PST)
MIME-Version: 1.0
References: <20260129173515.1649305-1-me@snai.pe> <20260129173515.1649305-2-me@snai.pe>
 <60f683fa-bd25-4656-ae53-fc247962bac7@wdc.com>
In-Reply-To: <60f683fa-bd25-4656-ae53-fc247962bac7@wdc.com>
From: Snaipe <me@snai.pe>
Date: Fri, 30 Jan 2026 15:17:56 +0100
X-Gm-Features: AZwV_Qjt4KKY3U0TehHyeXb0kQJInVupAcf9pqh5qn3uwMjTD9tSxhXopaIQL_Q
Message-ID: <CACyTCKj_=U-upyY+p_8ns9EpDp0utNJjN-ozCV8=m6tEoOPeoA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] fs,ns: allow copying of shm_mnt mount trees
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wtjubbqrysgxomeu7htim3n7e6t7jiqr
X-Rspamd-Queue-Id: E74EF1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769782714-961882
X-HE-Meta: U2FsdGVkX1/lDhac9bSjBbV31CNvAx6rh9CCxgOpI/VnQXWW7wplu9LnH4Y+Zt7F5R+9w5HsYFf0v7qZW9wLAVwUrNdfD683lVjfZ6/tByQlK0xZygXi0Agbi9o0o/bJ2EpKcuzbKAhTKKp0gkxmNll/NSLuiPHqcKwJh/bLZe4KUF6KW02aE1nybcQSd0YENkAw2iYh1eNH5pKKVSbuLdkiTGkmQLOAYzONzBXluul9ONwjrjJVGg8I712LCZODTabBnAKKpjeSKqv6WYp92Um1u2FxbUeLbB3EdU36WSqeGfLDCU7veQZ+mwAnQRycvnx0DCpI5pykNsjMYn0upXY6o1xCjDZWv50X7A2/hVVXhbx96OngbjPgUP5leKCXbY+Z58QaxVY/EeIcvSTf1A34tX9ZHWYB9WyYQJfKM9pxgygx1VVyfpQd4Qy5yRtaMZgWKP54OunEckc6Xm+HsyplGZ8Vz0z41aibd8NFsjwUoVZ6f0OQGOOJa90CnBLsAfDMmLAcSPamkwQMW6sHWvQfnllTsrF+5fzJJRtSgh4TTv3mO/7G+p2OM281xYvRIl/EcHGgvwDIuIGawLbKm5SSskMhThhQZWsjEiZAWWHKCEE/N+WDGd9G2FBCWjFdemzZqnt1oERJ3VsEaP1ZExMgW0Dx3ACghXSgdH7ND5yHc8hXQ3ppawoD354DZ3r1GTfMb5G+9fQwAXjQGA7+KvLCh3O5eEo8NbF9FybWhopJR8q8hw2j56McVuGxYW+np1PSgP1R4ZpydIgqq2Iz/lI1rNEXbVy19eVTxyVlDVK8y9lTg8uktjn+WMDZdwQ7ZaLO9dS2V4St8Z2+BpCcPHklNKcCXa71U4NHYeE1oJOqwwmFkidyp9al5vURJHlF/SthyRI7Ed2f7nDPGnP76INSrvckfX5oTk9yji0FSXkltOrmWIQG6HCIfK/taYMOOFkQndZstUG/kYCXVWx
 Zlr9oY9M
 8f/pyrlRDhI913viJo9osGidPTg/ug0rNp3PhNJzYH239iPx0wGa9uaf5KCBKQC7CMbt76Ug/65/Gy4IQpa3GWAk43kx+Cc7x3aVSzVVItelAL2ONiQDNG/X9QTuHeOJ6lrHoRULPIoVACLMaAjdqyOAxvoGfCco8Z+codZ4zSwFjmayUhhkru2xehbDXEOddwe0XXN2qh6iuid4eR9Snum0l6c5fCYe2wNuHA5NggBzMj+bxUhhW3IagTbB6Corq9b7BXCCSQjjy3RgEFpqlTdPxrVFJo9z3wM4hGMpWpnSll8F5m5EF002+bi8zvnM3SUSuC4yUzCCSGgPhQnIIVFtckOYie7xiodUdvqsiwURMroc7AvFS4wgINvaZ+geJpinG/1pfPHhj7KMxdE9G7KYJ7+eH8GBtc2nQKGCb1ntf135FvMpoRm91fsIKDWWPnXknPtN/A9/0PxXPJ6TX5cka+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.019383, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 9:39=E2=80=AFAM Johannes Thumshirn
<Johannes.Thumshirn@wdc.com> wrote:
>
> On 1/29/26 6:39 PM, Snaipe wrote:
> > diff --git a/fs/namespace.c b/fs/namespace.c
> > index d82910f33dc4..f51ad2013662 100644
> > --- a/fs/namespace.c
> > +++ b/fs/namespace.c
> > @@ -38,6 +38,9 @@
> >   #include "pnode.h"
> >   #include "internal.h"
> >
> > +/* For checking memfd bind-mounts via shm_mnt */
> > +#include "../mm/internal.h"
> > +
>
> Hi,
>
> I don't want to comment on the rest of the change as I don't know enough
> of the subject but this screams layering violation to me.

Yes -- which is why I was a bit uncomfortable to do this. I tried a
couple of other approaches before this which did not involve including
mm/internal.h and poking at shm_mnt, but they ended up not working.
The only reason I ended up settling on this is that there is precedent
in including mm/internal.h in other parts of the kernel (fs/exec.c
being one example). This may be a bad justification, but if there's a
better way to do what I'm trying to do here I'm gladly taking it.

--=20
Franklin "Snaipe" Mathieu
=F0=9F=9D=B0 https://snai.pe

