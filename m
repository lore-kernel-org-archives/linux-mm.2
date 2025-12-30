Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 387FDEE4983
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E91B6B0088; Tue, 30 Dec 2025 11:18:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C666B0089; Tue, 30 Dec 2025 11:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8415B6B008A; Tue, 30 Dec 2025 11:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70F306B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:18:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4B231A0263
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:18:54 +0000 (UTC)
X-FDA: 84276646188.09.0F66334
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 062F82000B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:18:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XLZkiv46;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767111533; a=rsa-sha256;
	cv=none;
	b=REYlNYxflEqEGJNarkdRd4zITspzD8tvz298LrWE8Om0lC64tgQ+9H8RCEUNIfWvIESfmK
	0BIQ1d9GgoLHcPyYaEGBxrrNsAJnJnoiyDyh32M2tOcZWu1sq7wTB7PNDPk1iEHpVCA9Z1
	1mDRG+1GfGdBePTiyY1dP55V5BUN8BQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XLZkiv46;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767111533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OL50/gZnO2VMMSC973/UKorxrP/7cJIiMBsmZ6LNx7g=;
	b=eWU7pbNZEg/tQLDZlnPD3B045t1GYM1O1wr5QHLj78UBNWNkdL91/tm16XkTqLVfjUXCgz
	d8D52Uq5kUmsfFfs0w86UGs+xk2K60ExHp6qUr2y+fTUPboDZaLp0P9qwI4mOK3eOAQSB5
	y2pVlRzialL1WzeJFiZiLeut5OHFcdo=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b83949fdaso13774648a12.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767111531; x=1767716331; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OL50/gZnO2VMMSC973/UKorxrP/7cJIiMBsmZ6LNx7g=;
        b=XLZkiv46qszJN1njtAxkkbxNmhNLIH9ZyCHSJ3jB7y1Tjv7pFosoBNC+tsv3h6MAQ5
         BsTeJr518aRPCyo3Ygkva+VWIeSAm+VjzLaA5uGbP49HnsZN5Y0eppA36dhogSOU+pfY
         rsiE/f4untbjfK3s/ZqBdEtEowN7jePhXgFy+Iuc5jbAz7KNwyxaPwN/jR8fjJdqVIQX
         mk3Gp5wqtwpOY3IL60aRg4b6h0KtA/OcjKWQyMN8bu+gxfDepBC4qI8p0uBhfF9IVd6a
         44ZJn/3+t5qu4v41cnd5TCJvqUS741r4Radf/fBCsuXSStezd008w9qt75OTpARHCgcl
         TTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767111531; x=1767716331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OL50/gZnO2VMMSC973/UKorxrP/7cJIiMBsmZ6LNx7g=;
        b=CVMWwJVi/BiYz+gNya/AgJmusVqXWSPWkTLSkRkxSS6WrvROcwNxre4QIkZ6YOwnqA
         9K10vtOOiE5lHFbU0Kc4AYV6Ruxf5hL/cR0sk4aJUv6MxP57LqcUQAyigzBLKuxES1wO
         us8LeLIfVvHZYYIVFKdfN9cnAX8M+O9M5/qoY6JTfNnOWMNj0DLk4wD6sC8yDLvrIuzQ
         lwATPGegt2y0kfx4mkJftEJPpl635/ydzmPfjAwk61gIx/VpV9X/cSLyyAGpEnU+a8Qk
         T0UHp93yLhiKIGWOJ/iS1ICF4PiqUbCusx61i+Mozsmqx3TcPwhdIy8RZgYijZ44xqba
         FoeA==
X-Forwarded-Encrypted: i=1; AJvYcCUuE5zc5usk/tsCBx6Thgn+/U+oUltckOqep8cqzFdPsoWNRKRZkuK+3dM2lQCqtYXkenL1W+wsEg==@kvack.org
X-Gm-Message-State: AOJu0YyixZw7/2PshWbGSaJNCyfcAYWohZwPsCfMQyuOosYlO6JP4jf6
	dybrFzltAhE7lBPqLTJ+fr2ZYWVLSD8osg7leawu5NR+yXmC2yxJRgMPFFsrsFXKMNbP1Y1c43k
	EIYdMCbf8yqLu13Yy5nlrWj5mICfCIbmfzijPF0xYHg==
X-Gm-Gg: AY/fxX7+RF2r+BMfTHSdz7QqNPQYrKc/4MryrhhS9qWhsn6S3KELCUUhxnau4vR8VIP
	IRTYVWFBFokEqRnZXsfLEnHKt7VKZc+tF+0ioITrEtOSK+AWMKESSSDf3XgHvVk5X8+wBXfN2kb
	CdaiRSvGCCHiUZOCprVbk5KcmgahqHaelAYNa30mYTEexOLTVmoOJ95E5fnY/sgCeqPevZEivu5
	KdMkEzCKt4Ns8RFcvqqAw/ycmImNTfb5ZfhxCaVwTv1LO3LAj0UcrAWwrL+YA9cpbsM9JVYy1pc
	LuhH8nSiC7XzRyIZuSeDWCGcpw==
X-Google-Smtp-Source: AGHT+IFeLw7u44MQZgbjsQFGA12sP1qdi+5HsRmBGCX/BEXK6I9KYbtNSPfAQW5/lttSum6QUrCoLo8izwyidq6kWdA=
X-Received: by 2002:a17:907:97cf:b0:b7a:72bd:ac65 with SMTP id
 a640c23a62f3a-b8036ec9e68mr3510206766b.9.1767111529979; Tue, 30 Dec 2025
 08:18:49 -0800 (PST)
MIME-Version: 1.0
References: <aUUYprAotKYMiEs0@kernel.org> <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org> <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org> <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org> <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org> <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
 <aVP6wBYoHJQsplIl@kernel.org>
In-Reply-To: <aVP6wBYoHJQsplIl@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 11:18:12 -0500
X-Gm-Features: AQt7F2rRyBAWSRSVw8tyvBNQJKwYnaZAfvLVHz2DyBAssxNNcP1N6GpP7-FmoGk
Message-ID: <CA+CK2bDZPwYpUhksDLSbfVdVm5TYbh0XrOKRV=q4YjGpqH+Fwg@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, Evangelos Petrongonas <epetron@amazon.de>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 062F82000B
X-Stat-Signature: 83pwb8za45oiojnowd84eo13ayw7o6u7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767111532-468565
X-HE-Meta: U2FsdGVkX1+GGPrV04VyvukyrLieuG6F8zFn7CYZVfopN7p2Tgbs/rkKa5OC++qJL4QGgon1yNv7cSRR1p16UfJFQBH3xuqZS9fhG9zUvgnJLP/HwN8EnATivBuFNa6QzdFh+8yFHk8kjvObO5Scq4tuI4akND0M0bD8YItprHKLH7RLlK6iVZ9RI0JtzYRIVAlzTAeBHXBF/wAJdnnE+BKpIQAra5wGLmyQ2WFMqMemm7Xsbjwhe3i6ESqeaoIcdDVyv5ghEZxryT7Om6W1IeNzBDy/KHQh6xjk24Z4DHwCe2hXJM/kxkK2RgIctMwxeiGyT5oQUxv53zz44h+8SD+15MMAYSnfPH1kkmNDhVQDf66Rmsm4HoGa0fIJ3HwSzDsYHtLo4+s6C4nWUf0PHXN0izeiR4LMvTx7STTotN/36dd6DOXfqH04ag2LR2vq9s+//YIIjpT55/EcqHwJyPPTZuQ1lOd3f1MAtg5PGCRS3qmbrnoJVDN2pvqch0hdyaHvBZuh4vMBfnFul7Ku0e48VUQKgHGBh4Fx/2M7jzlnIXpY7Zo1ib7z5N0H66WWbdMMMk9LLnNS5y5b89iHFtgHn9j3bcJfJeAuT2i5nDAOijRS2YBaAAmez0hhg41sEKKaaipLLVMjnx/9JlI9jodxpjQGt2f60uMLjUy35TGYDhkknsRIC1kNi4tGQf4hiGWJp6lH2HSTIQQP/w6SWVUPdmLET2NJnnBlv9iIzZpVkvc87YJrQyok+Estmi7CvXgjzrV1RHgYsVpUsSbVQYLtlNb9Q/8lUXfmEtAhHUzA+vhMRO0yIWdulB+vC4p4v70HOfMQGgAqjFXgbi8akau50T+pXRgIAxP8d/FPIwa1lPXT3cwVUg+zIKGdjisNtMrhuQ900BfO9e6Th1fCrCMvTWnzZXQAABRaY3CogwunKlsl0e+JyThlqQGmd543GlbKLlKnHJCDpY9J8wd
 OikObJfe
 9W9tsWXXs9dsDPrN4vdqJ4LnrpxjBKUf926QH5iX+xaeYjajCMH/pl6F/63GiGUdNO82dwj5CVZyoJ+gRw3q8TjSkf2lMoFYXt0PpMRsNX/NAKgNejbMiLO1rfz68+1qPXbR79snBpsZgV/Axx3MSe40ZfXxYvIsWjLoK+Tvj5sPHIXyNVSmtB5Bjm8ZLkPmZRkiPHZfZCbk7tlz/KNLOI3bB1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:16=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Tue, Dec 30, 2025 at 11:05:05AM -0500, Pasha Tatashin wrote:
> > On Mon, Dec 29, 2025 at 4:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> > >
> > > The magic is purely sanity checking. It is not used to decide anythin=
g
> > > other than to make sure this is actually a KHO page. I don't intend t=
o
> > > change that. My point is, if we make sure the KHO pages are properly
> > > initialized during MM init, then restoring can actually be a very che=
ap
> > > operation, where you only do the sanity checking. You can even put th=
e
> > > magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I thi=
nk
> > > it is useful enough to keep in production systems too.
> >
> > It is part of a critical hotpath during blackout, should really be
> > behind CONFIG_KEXEC_HANDOVER_DEBUG
>
> Do you have the numbers? ;-)

The fastest reboot we can achieve is ~0.4s on ARM
(shutdown+purgatory+boot), let's not add anything to regress, as every
microsecond counts during blackout.

Pasha

