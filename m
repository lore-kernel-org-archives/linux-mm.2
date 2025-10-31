Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EFFCCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 20:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEDCF8E00F8; Fri, 31 Oct 2025 16:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E528E0068; Fri, 31 Oct 2025 16:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB47F8E00F8; Fri, 31 Oct 2025 16:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C88D58E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:18:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80EA21405D5
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:18:39 +0000 (UTC)
X-FDA: 84059522358.20.12572BB
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B03840009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:18:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JeEuqJis;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761941917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZhdacDdwvl3z6wuG1uUon8ZTl5XKBxP70M1vr4Jtcg=;
	b=vXQed/mqYyGNILbFl/MNXi0idt+v0yxQKY2N/NZzYDLccsp6+nfEyHefVW0+5U+kuszadP
	93A0e+7NmPgW50n88HENiIM8mZIO70qM7Nas63dQxEMCl41YWyQy2rUyDCyKqZtfkf08Vb
	N9l5diYy2DFimF0ozb58VJWrWUenbxw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JeEuqJis;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761941917; a=rsa-sha256;
	cv=none;
	b=wyJGkbYLDZUfXSkU6Whj/TK4vbhmUUgz9yoalU5q4IZ/RAsEveAmU7L2vW8cE/T0ka1gM+
	IPM6p7hYDt9fu9NKLxnTEJqkkywkoR2+ekhMr6iSTaojFwxoe0EoIRy/UWsPUXtqwkWceb
	180V5d7GduRVTxWlb7wN/0/PJHrwado=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63c21467e5bso5672102a12.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761941916; x=1762546716; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iZhdacDdwvl3z6wuG1uUon8ZTl5XKBxP70M1vr4Jtcg=;
        b=JeEuqJis4jgwkludpxKGnXvLCWiipzHVxDKVAW+/+vxm93vNklrJ+9nGv5uSZ8odEU
         ruUNwX6vHR/j/i8g9Aps2CNfRHc4nZ4PjeMrFIE9Jbqtz6FHqh+vDo/FORMkcInGGOjD
         /KHWS743VFAYO44G+vGFGBJwjZelc1vCFEWLK/W4PIpiUZrW5UZ8kAsJQRAYOM/6PDVw
         S4PwhPgiHHYQscLIN3OjjWHEcaPpNBxLsgBFplX4X6C55x5ukdwQfj8hp9uVNJcRNgLl
         E4Z8d64h7V/humCJ1erb+TVJCCLFCuxNGFMbYigC7WzWBpLG1roRGlasanl/4ysihLbv
         a4GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761941916; x=1762546716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZhdacDdwvl3z6wuG1uUon8ZTl5XKBxP70M1vr4Jtcg=;
        b=eELlYqRzbPER5HASSRghI1GpYXlC/0ny9UHy39ceIAWtMK9A0HAeON4W6zU3MG3pl5
         oO7GEc1W5ttAOy3ENW7JuwO8snnIOl/Q3JHx+Xz5oPCUKdoklanTd1gtCUMjuiR3OCff
         P4yFzqookqIkn/sU4NErhSFrdeiKXzRA8lgfKR8APfpBT0jxtnVQ9YYVJZGqn+WcfC1j
         ffBHYsgoXlyiA8ntD0LvQyDiKYN8SV06OZlCu3PMn5u2y4Hqgk9p5SbcN1WoGu3e4QgD
         q046v7pdnLCDOZGNPmkUhywaH7gB09WMOMPJIBQ2g70RJF4qKWpT7flQRrYJ+HdgG34z
         Inpg==
X-Forwarded-Encrypted: i=1; AJvYcCWbIJlq84pp3eo6IXWlfXTMV5HTLiww8k0iCfsIj0Z1I+Iu8rTJirp3wKMs9LfLoWNbRbWnP2RWTA==@kvack.org
X-Gm-Message-State: AOJu0YyhFf4BK4OywEPuEG1mXwnULwCPbffn8XijOddNQZWsSniFlu8O
	n17ijzQusye3NgO9UO6+rgSRvYXD6XAdJKecXNkybE7POJeBjeib90W06t0u76LShygaiBbwl+k
	kvExV3Q1JLZ2Gd7YG3TSWWMfgOiKGeQrB3GA7Ni0WBA==
X-Gm-Gg: ASbGncuoAm9235b0KjuAkzLTVKyk02rgSAJ6DEKq47n76enNCbHf68NKxGLzuMx9y6+
	TpBWld2ovDq8aV4ZUYgiq1Wwd0KqLNZ7V1J6GMJzDY8x+GiLbAZyQ6Gs+ccW6tmiMH+CCaDXDmu
	i85KH0YaXipl899vAIFV1ZdA0dEgMc/VpG9e/y1XEF0tBHDaKS14kGX/WXAqtnubj7DDDnCQa2s
	i4vdTk3x1kii6G1XKkdLQuD+ijYGYiUzrSCwfw2yqnM2gTxFqWFWnXuaKyHzrTf2xhiFge2NXo0
	TeM=
X-Google-Smtp-Source: AGHT+IH8popBFFuu+7j49MbLPlZ9PCj/ug8iNZoAkJ4cP6tQ/3sJ+ToxQbaNYdZnYT4W9gHNNYSqbMSCstTCZpJAjro=
X-Received: by 2002:a05:6402:2549:b0:63b:ef0e:dfa7 with SMTP id
 4fb4d7f45d1cf-640770413b4mr4089855a12.6.1761941914959; Fri, 31 Oct 2025
 13:18:34 -0700 (PDT)
MIME-Version: 1.0
References: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
 <aPdVSyLRKeRN3i6z@horms.kernel.org> <16b37574-32b4-40ff-a8b7-2b443f293d74@linux.dev>
In-Reply-To: <16b37574-32b4-40ff-a8b7-2b443f293d74@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 31 Oct 2025 16:18:24 -0400
X-Gm-Features: AWmQ_blp1EcIGvx2FVAvkiazcvVZTd2t3Kird0CkC1s4V_L1BZfa0AWSXlFb8ZQ
Message-ID: <CA+CK2bD+_QFWx-+3sTW5f-C2tKG+bU1Fzk2bUP39UGuGouPRVA@mail.gmail.com>
Subject: Re: [PATCH 1/1] kexec: Use %pe format specifier for error pointer printing
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Simon Horman <horms@kernel.org>, kexec mailing list <kexec@lists.infradead.org>, 
	linux-mm <linux-mm@kvack.org>, Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org, 
	Baoquan He <bhe@redhat.com>
Content-Type: multipart/alternative; boundary="000000000000f4d27706427a1110"
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B03840009
X-Rspamd-Server: rspam03
X-Stat-Signature: w57nabcm3rjh47j8kwzc9gm1zg4hqrx8
X-HE-Tag: 1761941917-976083
X-HE-Meta: U2FsdGVkX18PoUeBmdxCJ3WE8NGlxOeNDeN7+QQxZqRemthRy39AH+E57zc0bRHMvqNmoBif/E/jBFtxlarHayKBUsCG+IOvu8I7wljCBON005IjZzTS/jchQOuunomZm84UR392NwZXGQrX0qkbMrhMPpFF/6m3ftmKmPQSJF4piNc+t1RF8atmtx7+MGJr8yjaOSDQ0D8wcz9+F/tWTbSi2KqgmSTeEOIaQnJOoKZldnmsdgwl6A2K/PEWuacGiF0AI2TJYK0D9l6KFqgVGvSzsT1tat33ikdv5vE9+rsmx6Hr8xkDJCl5KyjZ/G8QGE4EMbjIWuHVygD+0Oqzf5mg9AayzKWDrNZxxkAJakVyyVOrshnkGUcAMN5ZfmiOLS0uZI6c/3TdmQOzQBZPKng1NN/vIJJwIqbSHHYEqUOmqE0vKz9cAnmSdF/Rn1YLQ43wkMcD2yMjdnJRuAjjoX7tl2HU/Fv4VHOvVoLftI285Hvu8JPobV9Wlh4ZEI2Ra+DZKZtsHnGRJJ9SPRawOCBcyLc2oRwJ3Moke3qQbeZT91hNqNEsynYDbhh2s2zOc7cnOJvCqzcSzdQ8v9fJZeAzv142WS9/AdQCdY+yzUpk7+etHVLUaqIlwe0fz+aKHrfiX8a9MJ/3MBLBoIn68tuEO8O0YKWSHjXh4ew6gCBrb/OTL3BcjYtrosPniq0IrvqUCwdHOjeo6Ej0cfvgmBNlzcfwzwD77O6pqUMePRtjWjfpCyL/ux8YKdlARO58OB/T0EMll0pEtEKaCiptQK/DBzoour4AJffq6ZPPF6Ijr2nXsgwPNm637OEvFMwLgSmJ5APlGcNeoURr27S6+9beV9r1qRbc3eZ6Ys74MmOTxi5ywX4hKu3I2oCtCR+nK2NbNd/8VdBcD/67h9EjX+HM3tbmcp1ZWGiWM4H7iWmEX6ceBYLEhL8EwQkEjpKgsCOilisRasdcclty2J/
 CWzLCRMF
 a38IbRf+7sqa0fKqRDwUtEgSUj9zPAXXMyuXB4DTdf4uFOHkI/95hwtonIP3dGJOFTIxK1WklZI9NtPJ04YVqdS6+5Za4Bwyw928eEVNLe7JmrYp7QDaew2QNpanNJ6gPQpYERntt7TCOeqcq3ZjD/Ljqvj5CmyWGY4KD/4yzoxvQ3Htvar/4OFoIGMOpCZoaLYK6u5VolodsjI7BYi43vzIVZ+Q3dUB96l2fsCXyLjs2erY8uBVaQlkCLWQFjm/lKqM5vHGSfIDjh9UnohfypZF5AXE4NWrb3WzyhaRzyY3CJu9EccvxhK4a8VGTobMRIfrz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f4d27706427a1110
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure. Will include it

On Fri, Oct 31, 2025, 4:09=E2=80=AFPM Yanjun.Zhu <yanjun.zhu@linux.dev> wro=
te:

> Hi, Pasha
>
> I noticed that you are moving kexec_handover.c from the kernel/ directory
> to kernel/liveupdate/.
>
> Several developers suggested that I resend my patch after your patch
> series is merged upstream.
> Therefore, I=E2=80=99d like to ask if you could include my patch in your =
series.
> This would help avoid extra work on my side to resend the commit later.
>
> Thanks,
>
> Yanjun.Zhu
> On 10/21/25 2:41 AM, Simon Horman wrote:
>
> On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
>
> Make pr_xxx() call to use the %pe format specifier instead of %d.
> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
> -EINVAL) when given an error pointer created with ERR_PTR(err).
>
> This change enhances the clarity and diagnostic value of the error
> message by showing a descriptive error name rather than a numeric
> error code.
>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev> <yanjun.zhu@linux.dev>
>
>
> Thanks,
>
> This looks good to me, even though I note that this file
> has moved in linux-next.
>
> Reviewed-by: Simon Horman <horms@kernel.org> <horms@kernel.org>
>
>

--000000000000f4d27706427a1110
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Sure. Will include it</div><br><div class=3D"gmail_quote =
gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Oct 31=
, 2025, 4:09=E2=80=AFPM Yanjun.Zhu &lt;<a href=3D"mailto:yanjun.zhu@linux.d=
ev">yanjun.zhu@linux.dev</a>&gt; wrote:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex"><u></u>

 =20
   =20
 =20
  <div>
    <p>Hi, Pasha</p>
    <p>I noticed that you are moving <code>kexec_handover.c</code> from the
      <code>kernel/</code> directory to
      <code>kernel/liveupdate/</code>.</p>
    <p>Several developers suggested that
      I resend my patch after your patch series is merged upstream.<br>
      Therefore, I=E2=80=99d like to ask if you could include my patch in y=
our
      series. This would help avoid extra work on my side to resend the
      commit later.</p>
    <p>Thanks,</p>
    <p>Yanjun.Zhu</p>
    <div>On 10/21/25 2:41 AM, Simon Horman
      wrote:<br>
    </div>
    <blockquote type=3D"cite">
      <pre>On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
</pre>
      <blockquote type=3D"cite">
        <pre>Make pr_xxx() call to use the %pe format specifier instead of =
%d.
The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
-EINVAL) when given an error pointer created with ERR_PTR(err).

This change enhances the clarity and diagnostic value of the error
message by showing a descriptive error name rather than a numeric
error code.

Signed-off-by: Zhu Yanjun <a href=3D"mailto:yanjun.zhu@linux.dev" target=3D=
"_blank" rel=3D"noreferrer">&lt;yanjun.zhu@linux.dev&gt;</a>
</pre>
      </blockquote>
      <pre>
Thanks,

This looks good to me, even though I note that this file
has moved in linux-next.

Reviewed-by: Simon Horman <a href=3D"mailto:horms@kernel.org" target=3D"_bl=
ank" rel=3D"noreferrer">&lt;horms@kernel.org&gt;</a>
</pre>
    </blockquote>
  </div>

</blockquote></div>

--000000000000f4d27706427a1110--

