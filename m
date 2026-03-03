Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DE3EB3649
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AEB86B008C; Mon,  2 Mar 2026 20:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199F26B0093; Mon,  2 Mar 2026 20:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099176B0096; Mon,  2 Mar 2026 20:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC8846B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:32:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 878B3C1E46
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:32:06 +0000 (UTC)
X-FDA: 84503025852.12.ACC9623
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 841A080016
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:32:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CslBgReA;
	spf=pass (imf30.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772501524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gg9/Ehf6QkdTNMOsj2JZyr/GjUvgkpSyP1puN/tgXXI=;
	b=6rRoTFr3debojKv3t27ioycbT8NPBP0I5exvroAVWiyf/BtTTZokDPA8eoQplhCJGj7Y5u
	JCIr0NrleeHpm+mbBWyAnxcEtRIjb+2JWjQe+FhhcrdelJqsIl49rZd9NUWg/vqcFkgt8r
	5tqWKuTQJG5b8m0h9lbNHckOrpwbmXc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CslBgReA;
	spf=pass (imf30.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772501524; a=rsa-sha256;
	cv=pass;
	b=xxbjeNrZC3cY3/vPVwPWctCKpYlqeKnaBkf5xMtoPCvvEXxiuIyRP9sVeQI7RiDIuTqmCd
	tdGy/hhDmL8rpZ1WpV6TrIzFzghfrR1PHtVb0tmiyiAZ3b00Fg6sV56tbv/bbE/zszgZon
	/CnCfsBR7Ylul2lbpMauEkPFhk3I5jA=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-124a60cc9a1so2011c88.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:32:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772501523; cv=none;
        d=google.com; s=arc-20240605;
        b=WZs5Okk6i8mqVIW2e54ee/Xrw4pEM7AzVERPzqiS423C4e6LrIUPGTn1ohqxWMnAWp
         i2eo1+FlqqgNbD1les7KPoO6i9iAmfm7WR4iFinUEthfUbWPWZU5+qmqyNA9qgEh9WaN
         QfHsOdGucNsIQ2DthJenSj43pfrXxaeukk+txTp6b1NZTtajYsWzERSRUm+v5Nra2VNy
         7yvUhHP31hQDLhIHP1zakyuU79FZqb5A/j3i2/zvjWIZzRrSN9n6pFjS+b9TemQz3QYa
         QNyLEULP9j7vPaVVUr5c0glbNlnXj9XQRHV06nJ6XA4RYl1I3/n+Rv9+XPABwv3BQxar
         Fv2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gg9/Ehf6QkdTNMOsj2JZyr/GjUvgkpSyP1puN/tgXXI=;
        fh=m3KRG/W8qft9qYccanVvHS7Q2TYhfabkYnk3ZKHvZe8=;
        b=fPZ50oVrDYAXLLXHZVtGXsl94VG7jXqTSKVYi23tCEAXuk2e4+VJG+iCTBEjMP5Vp2
         g9To7QlZA4wYQh98GH8QYpwk9dPPtxzPM++2+mKEYW1wgqrJiA7+SnZlRqezrN6QvOcg
         S5wZf2tZigmyf42tNNT0riAdJO2dXiCqUnMBC+B0ICyAZWYpalIbMcHw7SJJma2yXq5Y
         4wy+8KdPijIuejpXxzuvEW3OAoY/tYajK02F28tEirwmMSRjryiood3CTJEdSegCLQLD
         FWkz7ReMPan+4qOYKFcIkhIXdcLFLuSJqyuLMlA/onJKKk2X2WA7YAAV83fJef444B9r
         ioeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772501523; x=1773106323; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gg9/Ehf6QkdTNMOsj2JZyr/GjUvgkpSyP1puN/tgXXI=;
        b=CslBgReABJXNMtsqksffyTobXMllYm1q1ZOxvU98n11Db3VKmQo12z4632Uwz+UikA
         Tk2JBu/q49OjUQiCqCcz3NzAP7jRJiYJIduLCaHvh6s00RRS635slS/ENzUGMC8Pmhe8
         bbR6YV7JWiuLncPVDjbcV15bhwKawyM/eJdhP5Jm7xWU+bHyeiwnNecotQPWlKPuUIYG
         URmpfL9SEk49a4k/9UIka2rwoo8akb28blPSK1XzFoOEiE4ThqU0tWlYdu945qzX42TV
         XWumCaXjuQSth3tpP8kwJknkoKdD0uWHhLeSGzSqEKKDkm3z48AqDSznb1Jc6+3aO51G
         ULVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772501523; x=1773106323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gg9/Ehf6QkdTNMOsj2JZyr/GjUvgkpSyP1puN/tgXXI=;
        b=kEptRDxZppBrpj9Ls93sVkuY+iYJtvL4r0KoHYuDUd7+MeMyJn6afrI+wo0H/E31xL
         k8xaHw9yiF7pZFCJTc2xg8mQQMcv0ibS2X4Q3ayKxsOBPromAmHhrytAQde/Npsa8Tyc
         eKS/u5c9hqwdm8hyNZN2Zk/igJn3zwhZ3n6p8Kjzkn0g//CdnHRP3nYXgQUJKSmOUY+Z
         kdataoi/uZxOiCP9KjlBrBR7v4clvCWCcylDOkk5vzExbuDDojrmhINAvB/7uSVVR6J1
         mp0RJKil+qkn0kRweqW/5LWU7nOtl5T/R9prswEe1S7NsUIy8IX+owyffATNyqZrGWrP
         dGFA==
X-Forwarded-Encrypted: i=1; AJvYcCUtM1/axUuhMp+daPuPZjH0XipcxNn74cYNVX+hMrxJ7U9JFLXE4rWEq3nko6bM8uvSD11GgNStwQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4HqDQMHoTTxCjvl4YeqAvQmt2ih02uYStKEoSvmpT95BYt3wj
	D1MmgwOrAqvUeEJI6caRqOS6MBviqKQGsVWDALCkGvkdY/2hjakcNb/x9Ste4+MvEPqJNrltxQa
	XkCwtRrR4oZjK/NRYHr6mtto0Aeq4gfWVml5FLLvvL+2N7v/Y2TsosJu9
X-Gm-Gg: ATEYQzytkLVOqgQzG4d/yOpWAHNihhvwxv+XAr4r8SrY8qUblzqc5jBK9QHty8GIC5v
	r4+gOT0wUu+dXGJUn4jlZiy9seatw+3jngMX3m61rXlrU7JByRCYwRuZJaW+QwdXUaKgrgLTWBV
	fcsNQEq34hkN5wveIEcC0i+hTWTc3gknCts4+Xec4Fv7iXRT9dZYNqEGpDh4gB5036bkHsnlRJ/
	z+A3M4LcB5sTYMjNbud5Dz289HE+crElVkV1sz2dnx5mnAhV/JARmPGtH7/6eNUXajIEbgwl7Fu
	I0NFYBsz
X-Received: by 2002:a05:7022:1b01:b0:11a:4752:4322 with SMTP id
 a92af1059eb24-12796db8e27mr359868c88.3.1772501522503; Mon, 02 Mar 2026
 17:32:02 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <aaBsrrmV25FTIkVX@casper.infradead.org> <aaHaSRXNLJNLwvKh@linux.dev>
In-Reply-To: <aaHaSRXNLJNLwvKh@linux.dev>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Mon, 2 Mar 2026 17:31:26 -0800
X-Gm-Features: AaiRm50OHYRvXAplv236SeevUxQ7hMmDxFaSMU1i771ucSGBElyXkJJ6rQkFSHw
Message-ID: <CAJHvVcgU8ZgJAymFfxr1FC_bf6gB0mpr=VTbtSdFqY4iVB-WGg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Kairui Song <ryncsn@gmail.com>, 
	lsf-pc@lists.linux-foundation.org, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 841A080016
X-Rspamd-Server: rspam08
X-Stat-Signature: mt6pkjj7wxsrxbichf16ixdt63r98jxi
X-HE-Tag: 1772501524-361643
X-HE-Meta: U2FsdGVkX19jNTKaUwI2qr+5lMKcOTj4awKZEVcTYaEdhagdIwibX5lj8qCgAXyxRdA6AkomBW9BMZvgF93KAqnZER5m35jiqXw3I2PK7MXZEyyryW8k0hdmHe+MA+CqibSULGHp1HgV/MegIoKZUgllCvyBmy++U0Vvxs0Fcvigd1mG0uUMq9M2Hqv4/78cjDSruie0lppr0sfH9Mv5XGbtkSQTXFLXw4vHf30BUdyqRpGbF0CJBBNO2UcwiGMKVcKaKrh4zck1HQ3vMv6/BRbvpFQix/QpsTS2JTX2HD/OjN2gDyoA3oBiTxDLPNMQ8co2hduyWXwz6Ebux8Zv8VqsIgcm3SLYVApSClvxGaI7AVPd9NI051UZPu2bvMxkpndxmi1shsYAUuNpQfO3pSPvGjr3+2obli6UQ/K4+oM15sihX9mipj86MbL5GIYlFoeYMJWog+fMJEP83rx+HJ8dZljdVSkfhcgb4k8dRuJYzj++K/gYi6JzoN7g+r98RyDdj7u1hnkMUjaZl1CXD6Vd2bndrPw6v3oPesbcYOXY/DyRj4Uvh+jmqzpKnoCBM9YIRdjyrdcCd3iYqUnQbBh97qsXF2z0EzHZ3LVH2GAmebcY5QfNfCCmKZBp93UvKusz6YtSNpubsdOGbtaYHWcJqCermZOPJro8Al9AxiFG4AoWRob9ZXG8Mvq4NVoHjBy6PMmrVxowZDNZ/Q2ELtRh7HSc9po6+847CzYVLl6x6/rywWjohmfdkbeW7GlpIlM4fFYITOyE/nSSOKMWYu/KqmUEX/NuMUNvLczU3qpZOUJ/xs0FGdiFZ2jt+1pOB3fb65JNGrJDb5sv7bzM8Umw7gDh3tpCaeQxkoMUbRbeie5+Sg+rJ6TABqm2V+mTk2K354MBn2oeHq8m4eKsM4lHGmxjuLCjq1NmzGhGCzm/sQb7pLJyjoxHIHt5bukdX9dXZdNhsrZdAx1UJUK
 A6t9rWx9
 TEMywtlKMnFF1VRzeUgmR9urkkKM4B+ILqOG/1LdrnbKU+oa1e4poup35vheSOVMX+gGcdOs+XjZ6KO5aqFBOIP5c41uVQtp2z/by1m5DF0N7B+rq9xQjgtHzja0Mj3ggsTH/50XGfSBwwdHldFX8ycX8CXKjv8TMbZmiZpXF++5iheeX7cVPkBrABa8odiA4dRGytq6gS/Z0FUqW1pc0sjzj+mH2QVvPIv1zhn1SyF1w6yo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 9:56=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Feb 26, 2026 at 03:54:22PM +0000, Matthew Wilcox wrote:
> > On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > > MGLRU has been introduced in the mainline for years, but we still hav=
e two LRUs
> > > today. There are many reasons MGLRU is still not the only LRU impleme=
ntation in
> > > the kernel.
> >
> > To my mind, the biggest problem with MGLRU is that Google dumped it on =
us
> > and ran away.  Commit 44958000bada claimed that it was now maintained a=
nd
> > added three people as maintainers.  In the six months since that commit=
,
> > none of those three people have any commits in mm/!  This is a shameful
> > state of affairs.
> >
> > I say rip it out.
>
> I have very similar concerns. Though rather than ripping it out, I would =
like
> we put efforts in unifying the two reclaim mechanism (traditional & MGLRU=
) over
> improving MGLRU.

Shakeel, I think this is a great idea. If you have any ideas around
low hanging fruit here, please share. I'm planning to invest much more
time here going forward, so I'd be happy to turn some ideas into
patches. :)

>
> >

