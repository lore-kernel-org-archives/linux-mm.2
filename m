Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D4EBD2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 10:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC126B0005; Sun,  7 Dec 2025 05:38:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3A96B0006; Sun,  7 Dec 2025 05:38:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8F76B0008; Sun,  7 Dec 2025 05:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98D5F6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 05:38:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C131BB231
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 10:38:01 +0000 (UTC)
X-FDA: 84192324762.04.74BECF0
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F6F7180003
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 10:37:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YMZPA7Ws;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765103879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiFmqmVM8Tzc3/pX6LppdlSzcPKAUCpuWPYMDLim8AI=;
	b=IpXrfedbtcaBFZzQIOzwdA3ewCx+pXgZiFypywRSpo0XZvfqZ8OAnXLwNbJScRxYBFVVC6
	X3H60SP+Qv5QzLyvhEX+aQ8n9Hz71a+xzdBTjR7UTk+ZLgmJjipeWic0NOCIBjf80MCn9w
	ToG4h/XWRKrEJpYDNQbuxTuTZzRlC74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765103879; a=rsa-sha256;
	cv=none;
	b=gYENX1fkvndX5BKHKHz52MPPCHyG0bfTvOGLC9nWXwy0FMc4A7AEbA7UVKE9H4v+M9pXpt
	LFjxQDldcL1u/lY2kyrIoed+1CGbVf7k9o6OaVY2Wd0vROl2k/0XBJyr2Gz38/pdb0HeBp
	ygfnVzAEyIHy41vCjT2tB8dFPG3Wk74=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YMZPA7Ws;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso17377225e9.2
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 02:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765103878; x=1765708678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yiFmqmVM8Tzc3/pX6LppdlSzcPKAUCpuWPYMDLim8AI=;
        b=YMZPA7WsX4/TyXQ25wqYEX4RurWECzAWBPbTgYcsjG103+qljRM18SEItDYINs76oB
         G0KD4qcq0qFKlGjgsBMImdt+fDe7tHNm2A8W8jPJvvyHoQ3UI7ony5TBIXDa0ZylUAhX
         Fjm/wcQj/R0IgOE8iAlMUHqObkHT51JPfc3LGZCX0x7FiGl8SjUHLoOLrzCTSeAL/iZ8
         diTRFnjNkrrhY2pS4+4Jgu0CtrH1WIPmLuuqc1UvVq0jf4ZcSCuB42vpcgr02CewtWa0
         8xvXUbwBcMTjkneikoY9Zv4B1ROrumbTGl5TMwkIcFU1xIPk7ypL1xCihIbbETJfEexk
         Q3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765103878; x=1765708678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yiFmqmVM8Tzc3/pX6LppdlSzcPKAUCpuWPYMDLim8AI=;
        b=ZRF7qDj8KWBgsQShA01d2rDH9IanGmlmR303DQudDl8/YaowpHdM/X4NpriRuyt+Lz
         cSTxjQpi8y5Rk8zA1dUN4Jp7iv1G85MyE1gIn1ksX6gaO/CsZ76CiB0IBHCF+sYxZeR0
         NSF7SYPqhoZGwz6U+Xx+irJ0CGD0VhwHbI1NXrQhpGjsFbquhfRdwKN8L5XiN9vMd3dL
         JGqjvogrZ7ZGknHz8LLc3cHR/rHd3k28EcHNRKRq5KPK/X76wSdc+0+V4P+5dD+NHoGp
         zeVCEB5GGsTTkLpFX+WwsUMpfL7Q9xomYl6Iqh4fRy5PCv1bhBR+ozHu7J2Dm6Cmg1Xa
         lXZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi72P6GuilfqOfCLaSlIwQOZ2X/i/DAJxissq4p3anok3F9SEBdl0e5TFUPqD2uz9oPKJgMUDQfw==@kvack.org
X-Gm-Message-State: AOJu0Yw48gjjvAmGTrogMN7vviXJ6A00YB3oDog0fqPPI8k47P2+RKCu
	3/TWotFDHXku8sYiL6GO8xbvMFRCF0xaaeHfJLpA3PYjPaxFVNnJMUw4
X-Gm-Gg: ASbGncsItn6hefI/XhsMaxy8NMVFhsEhU/OBFuGfgrpmoXv5jvRr8B+6Cq9OqunhGod
	RocT3stRWWqrRsTHmtXWEOlajhoRPDYDadcx0+UraGzsNl5QzG/gSI40fmEMy6iD+b4OIbLOuqo
	Zi8QFpNnag0Wf15eWxtbFN6rNi59ZaAqp5udhj+QfsGIfEWUBIB03mCsv2D0CWJ1WKO7TdgzPQj
	kx3BbSBZh6qad1KgI+/9vWrlrcDTxtXNF7DaSJuINVVjcIgoJHtSeY+hRgRX4QlB0vXxUGTYxOh
	FdEPs4pFFRWaQj3bFgW8Q7MogAH30r/tUg4TSg7QDmy4lnmHpicEECO381HgZmBpQWJj8x3qn0e
	PT8jYDZwtRbkrErePr9s8gV+PaXinLzOHbJYu79iRUuO5gRDH/YnHzc+vNETTlZ2+gJsmQiV63X
	Tx0zjQlNHPLcydPf13MZ8ufpWgaQ/F7fJSX8NjRr4jOMlNIzZXJQvV
X-Google-Smtp-Source: AGHT+IFHsj32Bs/JaOUHvHxvy9WXs85BjT7KVW4hKHqqWBOsdWdXQQobTbt0UPYwtiptAXg+ckH2Sw==
X-Received: by 2002:a05:600c:d2:b0:479:3a86:dc1e with SMTP id 5b1f17b1804b1-4793a86dcc6mr28759625e9.36.1765103877360;
        Sun, 07 Dec 2025 02:37:57 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b04e03bsm99035395e9.7.2025.12.07.02.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 02:37:57 -0800 (PST)
Date: Sun, 7 Dec 2025 10:37:55 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, oleg@redhat.com,
 brauner@kernel.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/2] pid: only take pidmap_lock once on alloc
Message-ID: <20251207103755.70be2f89@pumpkin>
In-Reply-To: <CAGudoHFjrMsQaDzndo3sM1Jn_WROBrZ0PeQbU89-tDakLAOvew@mail.gmail.com>
References: <20251206131955.780557-1-mjguzik@gmail.com>
	<20251206131955.780557-3-mjguzik@gmail.com>
	<aTUq5bRdPNpup8GQ@casper.infradead.org>
	<CAGudoHFjrMsQaDzndo3sM1Jn_WROBrZ0PeQbU89-tDakLAOvew@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F6F7180003
X-Stat-Signature: n61th8au8fat4zhhaqn43uhmprabwo4g
X-Rspam-User: 
X-HE-Tag: 1765103879-534321
X-HE-Meta: U2FsdGVkX1/m5PpKxwJVYI9LyL2xjtfXNfBj96dI9rK0s2R8A5Sdlrzm9XGpdy/d94V1fP3t2q3jPTo+4g+eV1cMg7cU/zjBtH8ZCmuXJ+lqY5MywmTFdVldCSI+YiNW+XK8m5LRGqcJakFtxRUY8Knkis71K8qEFIZPptPTnbzyicpbQxltGDEzA07t+6DV+DgrQboh29n1OOBuKTczK0H/l4QEdSxNuMg7dV2eKS6y1DjeOCwmLJCe9kRzufqWf6aZApVfK77Ezio4rg6Oo7HtrqKFzD8HrzqsBDH3/uiQ2ViTtP3W0OcQks8oM1nBC933vf1+FjnImjv8r/JIEiuGDhW942Iuv5a/YwSidWmk471wtMEfHh+J6iu6PT1zlK9cvOGxAtfoRJMLd/bNZV4+amqgmJh5i9teRUXVFteQx9hZyH4Ah9ZYun/vttoGZbQbShy6Vgh6FFsTb5bMAuoFtowCeTBhycMswJcKNwVDqLbgDrqC7JtiYhp6xTTWX8ThQ/frWGEsdrxfyw/8Aadq+LhpsN/Nh452ogDOKMCT+jMAnF7HCIDKQQvK/QvLkBhIN3GbBsNeqXTjWP8PkuL1K0+qBNTo10GUutIzum3MH7CRPSalFkJzzjG7IgJIqZWZwGo0d0+qg8wntLjfFshQPnDiXWFnhIttHfNeEJ3TkZYgbQAYCHqsPcuDaCMuob8FhGx0y0YfzUi0QfitQ9jVwXvYmtGIFpSfYF48V4zeIq1KiCBXAAqY0wcGgCrHA6LnBMD6RB5ssrCjz4RcOh7UmpdQmzfiW1aP90IIj8qmcgI7FhNI0ZT2sK5QzgXciG/DnlOyC6SFJEt1UeCIaWrKjTBu19w+52KG23cBYPnnfZtuqrV2xCsQU0NH+NfpBEPcvgTABEb/M0+gAPtud9d2jUei3kiJEBxN7Y+wq+vDATqSUy32h+CWWJIX7vxro0LFOXUe0oEeJIRr6K9
 1dGxjH20
 4KsB7dStywXHZQfamdBJU3NNNMi01ondkeXnXXKmEhgpBsjABkqvix69Q441U5Nl+KjOZuHTs5kSfV+UGXJj0WLWqKxS0wrFJR3dLoW44WYOrKH4kzz2yKGVLYpQkWr09yWhsj2IDQAkH+Iuo2k9AVkmZ1HMXoKMFMrs22zM80DcK+rlS5yIHro3f856oObhjXzv+Q4copoh4aBmCsA5ZMWLxkBno2R6TW3xEvl+q+uL9ju0Sf9vIfFnWrBqlYD6a95z67fV+WY1q7oiAP7parHBLDFArDvaeeN9Y8+WRuNB2QBx+6aQmwCVTULnGj01ZDEMxmgSwJLQduxs60m2Ag9K8JgbP92HaT56zr6XXXgKoCsBF8UbhAJKCwL/7LGPjxZFD4B+A6K7pVGsUrs+BJRdcr6kvHjQHBLeFRLp7fVPuFk5iX5JnMdEdTfDXvKdBHHupTMCnmMf0Q4iopyGw6A3mEodXIqiI3pL+lWFo4CPhPEu9XJ2O420JmJf7rDeXG3H87yRc6TPcvS8l9Qhbr6g4zoprkyABHXQF1B2j4HHMExvCqaHJWo6PVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 7 Dec 2025 10:21:35 +0100
Mateusz Guzik <mjguzik@gmail.com> wrote:

> On Sun, Dec 7, 2025 at 8:21=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
> >
> > On Sat, Dec 06, 2025 at 02:19:55PM +0100, Mateusz Guzik wrote: =20
> > > -     if (!pid)
> > > +     if (unlikely(!pid)) =20
> >
> > Does this change anything?  I was under the impression that gcc already
> > treats !p as unlikely. =20
>=20
> I don't know if gcc is guaranteed to act like that, most of my
> experience is with clang which was rather inconsistent about it.
>=20

If nothing else unlikely() are information for the human (and other) reader.

In my experience, a simple if () is always coded as a forwards jump around
the controlled code - regardless of any likely/unlikely annotation.
Similarly 'if () continue/break' is an immediate jump to the loop end code.
You need to add a non-empty 'else' branch, or something before the
continue/break for the un/likely to have an effect (an asm() comment will d=
o).

While some instruction sets have explicit 'branch expected taken' markers
others (like x86 - except P6) don't.
Similarly some cpu predict backwards branches taken if their is nothing
in the branch predictor, others (including some x86) just use the relevant
branch predictor 'slot' without regard for the actual branch address.
Then there is the branch prediction done by the instruction fetch/decode
unit, that has a tendency to use markers on the cache line - so doesn't
necessarily even check it is a branch instruction!

Basically the coder doesn't have much control at all on many cpu.

Oh, and using un/likely() can make the code worse.

	David

=20

