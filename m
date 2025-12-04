Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBDFD2444A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 17:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE25C6B00A0; Thu,  4 Dec 2025 12:10:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A922C6B00C0; Thu,  4 Dec 2025 12:10:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981878D0001; Thu,  4 Dec 2025 12:10:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8411C6B00A0
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:10:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23C161402FB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:10:43 +0000 (UTC)
X-FDA: 84182427966.02.BE904AC
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2F61080005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:10:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LWq9SSt3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764868241; a=rsa-sha256;
	cv=none;
	b=u9Sxdo1nmOnpnUXLDOUX8ruzKFBNNVnVZTGfXlh1DCJMs2B5o2ZHbvt+9YFhsuzAi4GdP1
	64sFP8pn6Zc8OC10HUbGUVokk6A8+4XCupfZI0At8YmPTHKJiF/PoD96nnowbzSMdp6DCH
	aLSlBPCB1RgGsi/LcxaOA7vNYoWFs4Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LWq9SSt3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764868241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Luu0dLPCGlCn7g8rOb8w3AI39PT79ZYzQ5Pim7OffGo=;
	b=0UYvffL/0F1xgWTQ5okE0VzBgZaucRAqZx0RriSFHmFsYs1LdkEKdl/nn/ZNbD5FCP2nqY
	2xSaXUnBQ1DpIX2tTtFD1zPBNuAuOig4C2snvx+KVM55pvkf+l6W75/sPElPpRWljXON8q
	MhpA2xNALVHYRwpUzCZOnQqJS1vsD8I=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b739ef3f739so195896066b.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 09:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764868240; x=1765473040; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Luu0dLPCGlCn7g8rOb8w3AI39PT79ZYzQ5Pim7OffGo=;
        b=LWq9SSt3ncTzh0EYKpNXcfmxSHMTry0m7kIsLN1xNafZv7IFytr23w5HiMlATZm9On
         zxKWdvZwnzKAHLBK6ZrsPQRkci93tm+Gy5TBEOgMrqeqmCRoX7vMCRDfTwmXQHhDWCsl
         TfA1Y377LK6BBRKwxdd/TUXgJP4JY9O/444HmTUiJs7D+yZb1kydgeX1KBshbfej2Vao
         wO64X2FN3ePhpxd3asZ8L3ZTKN6KeR0EXCp3NgV+WEu3PLi8IBipdQ+YWH5Y0jxMhHSx
         6QG0pngKEyzqjp+odjF9y5iw9scQ2chdCEkSCl7+nMU0MsAJXsnF+c/s2n0GQKESVzJ3
         K5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764868240; x=1765473040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Luu0dLPCGlCn7g8rOb8w3AI39PT79ZYzQ5Pim7OffGo=;
        b=VEGsSXxUtkSPvkq/hLMT5+/IqVCBpjsKvlwxSLkvMLikakTsw0Vd1iKaAhfaReyH9q
         Z/9vCFK2P589frH8ab70WY3OhOk+jFqwNeTt0DkHODsCCjpdUOLBOT1sl9SPHIwQ+bwe
         WH3IbPt8hqAzOOQ7H7EQnnS7QN8DO3MwgXn1/n1wAERFQ7tQIDKYTbJKAFWKjteB9kty
         QlE138Ikrq+xXvdm+2HBUHpOZOU0f4Uy94HWQYdzaQUbqdQ1P/kqScxbzyycS9hCDUUj
         K42um02nC7Xjwtk28LF5XkdpoAX5j0gSul+jymqyMYRHJIU2zFuCmCVUIOJY26jLf1Ar
         5zmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJNX/k5fpaEinZEVKeTbiKEZ+jyAqaxHxJDCkqkCoMtfcUaFlEdeqn9TKapGYDz25r5jC5CHt7Jg==@kvack.org
X-Gm-Message-State: AOJu0Yztb/4Zi0doZ3FsBntaXVAuq1zn4HPDcrY7tpUMZbmGD/5ID2ws
	ygEo4TQZIJQYsTdoElFsQRQ5KNDz+OgpdySfXVjbHuARSJBsgko23RSWCxni4Da/EWGo2uzvOru
	Zz1zSXJlpoVY+KUG6VyaQ0r89uRqXDFY=
X-Gm-Gg: ASbGncvs112CxUbDW6JqC10sE8V9Ac3Qflp0B1nVzK79utInDq8IxSOmawQONwZ4k8C
	5FMgJU198edT29RGPQEc2G5Iggbu0Fk7uAdWUYT6WFPTafOyb9Eng4vDCDtmi/uUuBNED7UAqhw
	NCPvMi1i7ikPTZYtOonhjqw/UKisCMipeEyHKLCq890X9vm79e1ODs2CSUSjmAerO0HdHzb+0qi
	sb4fy9+84QzBTX+Mgbzhx8D7znFmVYeCxma7zu+bP2dk2LegxJKj/FiuGLhJLzTEOiy+qa454pZ
	T3C9L563Uy70iqz8HCY0vV8hcsgQd+oluL0DgTfMnsuYJnjymomlbXziJFeiNXrD+niB5u0=
X-Google-Smtp-Source: AGHT+IEYKHVXa85Li2pElk6yFv5g6STpHzlef/8H62UofABcN9oQ3Wj+xk/v4+/gcktKR5nlyxnkhnAfTauuSY9u0Fc=
X-Received: by 2002:a17:907:7f12:b0:b73:4aa5:35e5 with SMTP id
 a640c23a62f3a-b79ec3f09c1mr410215466b.7.1764868239255; Thu, 04 Dec 2025
 09:10:39 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com> <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
In-Reply-To: <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 19:10:03 +0200
X-Gm-Features: AWmQ_bmM6LnwCv_8DkzClBvkpIFbzUw_4DvWZVBU7sLi5C0dPTkjJPGuyU2cHmI
Message-ID: <CAHp75Vd9VOH2zHFmoU5rrQCRqJSBG2UDCfKgvOR6hwavDVqHeQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Marco Elver <elver@google.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F61080005
X-Stat-Signature: uud5pyq9zhjkhwp3abi8ryw9551qk5hy
X-Rspam-User: 
X-HE-Tag: 1764868240-189988
X-HE-Meta: U2FsdGVkX19WFwLkdKSqjerkBDEcGeSDp9V9RWKChyL8ZD9YgCsDS/I3Xl7zod57iakCTsGSQ5bql6SGcG7lc9ZUnlFzDekbj/syin6jfhu3Zhl+ydz8Do5+GMaXIFLFIU7sVR8vFw6jY7rxvZbJ6AoXJMuemPQH+LlO3kNuYhuT9ewKpVix0/ZqJZkEhfNJ9X10nISwTvo0LU6xkpfe10yCMRUWV6ehQJIdoYfrdCtChDY/Br6xvo5uhQLE0R3e9RHcTwrSwIOZeaTVlL0kt4boLA6jOea94BwtZ6bJAsCQDoecrO6GeH3mW5uiefRI4B6DigwCVretLX5Sc8kIqw9QmvE8q9yLF6JnTZIOefIhz2tZ1nCJHI/Hu7/zNkIkQMhfyDQlq6e4m+SqoYyWWrtALCD7ohomvez1oayU29jXqPbqhHp1SZfxAoRl3eJyn7SmIMJdJFthjJPXuP51uWvGe6iKNJ2TXhfaoNXGfkXYOgNLs/rl69XPK1IGUix8iuyFS3lk6kY6/yIABEwi9JHlnv2rDIoRTxhuXgcQj5hQ/ZgXQh7Q3/eI58meEwPF2JPtmb3yxNu0Eg+4BFqSQ0UMJxStTNYT5B42VMenGofcl8JPyzC7PNmKAvESFrUR0I2wNzlD6qTtPdLd059eCJG8gJ1nHaSHP2yhyalM/yAXvHnInu9qPUL0/OS6+Pyft9FcduoNBjb8Rc5X/FEApaBfnbC/dxsZr2d7levnXWQfLs4oxUuV4x4PM8CQG4NFwL66J2wcMK+xvJVKB99M7ywmYWjelBMLvKUSCN26KdeHCB+tTUxNEkvRzlkHWRduz8ck8MwENEpx3pT+Cqeh/bH1Daa0H1J7pQhTO9UsKOFNQr3YBRVIFzBhxxwmaUbvWHbdju+7nmiwKjKkK3jleREs88j5eUY9ms4iYBvQYWEx/TrnYNRTvSNdZuSSrM0E02EOOU8seUxrNpSK3AP
 KgrHNFSj
 eHFQncaj0aQCaikhUblhFu8duB71tundiGM1Y8VIzwLcrihY8KIpu6+Txjps4nftBDuFpakDjCg7Ou+M/Bhf/hypVPBqkYu3lpgzNJha2I5inaSXnowzDIiUY86Oe6KS2JE5RYMMCofQl9oz14GxGA/ZylME1NSKbMKzU0WvKIM0+iXakDcxiEoHl52BNhZJCR2MePbV6MjlOQFV2EdEuyGkVymw4pqoIsH2nqvZwP4hLBDc4dMSUZHtA3Nm/OJLa0pwVjAXdNOMir6C00Vpm+JMfaUodrnQDS8LirWviHYr+tusQTWXkiR/GjLzDJ5R+U6tKkC7ffrhf0al7M24X+TdZTrT9qvHu0HyhaTxL2n0FB4LE1M5qEt0e+S7CEP7kNVw55Jyw92gw+FJBp3HRoLUi9yQSLbtBKxO1QW22XSzTPFnvyvaB+FoxAWUj3BlRqTWhxhCqaxu5U4sAME6ZSjmS33GQ4r3QIGcPTANbD5AbE4Ic/WYNF1DhO6qaFdM+r51BzA6d2bBJR4rdygL2H5rgYgkgWjGVLQyJxfor2WqmyBCcH3EDACGAPhZtxRuSkFQWxKKSgHAacisverY1lAuVjo6vLkZDYLfm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 5:36=E2=80=AFPM Marco Elver <elver@google.com> wrote=
:
> On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> =
wrote:
> > On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> w=
rote:
> > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.c=
om> wrote:

[..]

> > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > >
> > > > I believe one of two SoBs is enough.
> > >
> > > Per my interpretation of
> > > https://docs.kernel.org/process/submitting-patches.html#developer-s-c=
ertificate-of-origin-1-1
> > > it's required where the affiliation/identity of the author has
> > > changed; it's as if another developer picked up the series and
> > > continues improving it.
> >
> > Since the original address does not exist, the Originally-by: or free
> > text in the commit message / cover letter should be enough.
>
> The original copyright still applies, and the SOB captures that.

The problem is that you put a non-existing person there. Make sure
emails are not bouncing and I will not object (however, I just saw
Greg's reply).

--=20
With Best Regards,
Andy Shevchenko

