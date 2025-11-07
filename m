Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E56CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90DE18E0007; Fri,  7 Nov 2025 08:32:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5C88E0002; Fri,  7 Nov 2025 08:32:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBA88E0007; Fri,  7 Nov 2025 08:32:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8C48E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:32:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 161A913AC11
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:32:46 +0000 (UTC)
X-FDA: 84083901132.27.EE2472E
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 38EF31C000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:32:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O6sIz2QJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762522364; a=rsa-sha256;
	cv=none;
	b=goILhGNk2gUDjLKnzpimoBvL7wFy7y58EfAdbgeO8fxK4XK09JCHMmICdiwgITQW5wMlKk
	9DlUv2CfYFu+2serWxQXP5LS0nHzOncUQhrv4k+oCETb58w84r28a5XvLGqLueWAlWSIEi
	5ghg9TF8MiT5wjB0iHAjcq+eDIQbnMY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O6sIz2QJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762522364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYGsUdW8QJxBbEDi2Itt5Jzut6orTX2cfcUNRJS1Mww=;
	b=FCr76ufZgZvg6Yw0qR9Cry/bNJA/SxVDugApZAJalvRLOf1E6M+4shw/aPnraOJVIOJ3Fc
	YWZ7CpGeB+SbjpnbyYvkacjfpgRFnIv34N4XJNPzFrh3Nt6pmhndaonW6YX5v3C6K/2Lj4
	PlV7X88pIrsZcTxXLWqY5QhhAUUYZbo=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8804d05dfcaso9559976d6.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 05:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762522363; x=1763127163; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYGsUdW8QJxBbEDi2Itt5Jzut6orTX2cfcUNRJS1Mww=;
        b=O6sIz2QJLLofHf9RYqom674Kz7A1X4sr6gWm4juBYaM5tf28+7ZQeXDQl6Igu2px61
         PCK+baf4hOKsuCaH/9BW5sUYXrG5Z7N1OqelFLufL1hELwsYzyMT1F8J7egEjbZax56c
         o2zzns91/tczPdEbdAnX92inb6o4vDICCJZD62fsiOlmqyfd0noqHrw3YAVnmQ162tZ/
         19IaNZ3mYZRux4vzjAGWU+4HZ8gr13xbXhluaqbiCx95YoIydYFzwMVYDoq0F/ocMc+/
         gLsD098uKrxOunl/JRpzqTVgADhTr2Td3UnvPy0wJDaBtynwTx1S9C8wDh4dTzeUtYrL
         W9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762522363; x=1763127163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DYGsUdW8QJxBbEDi2Itt5Jzut6orTX2cfcUNRJS1Mww=;
        b=rBX4SlxvxFmY5v+oksh42UMMNz3bF+0Cnepk0eTyyRXDVI9oatHcgJj3vyrcfbv4oR
         8DNf/wFhszZsz2dWAG3qpQowNFhXgcvBR7ejezjnHETIMNhrfIbauUbBlkJtZBoUKaVU
         tH9BoCS+Y6rm2qNyRjiFG7ywnyIj5iv54MQ5EOgvvZ9FdtN9k5iT28XGMiY8tHRMbIIW
         SAADXs5f3B10yJQVLfLpSzVCnpNGVzb9LoaL4pmaLgP4cmEsrPCAiF68YePpVOWpVG4i
         ivYzH7H0rBxOEe68FQNn0apQJ5vWixcLSh+rLl5s2oyax3h7s6OGwLKimyy/dULkhE7H
         qPcw==
X-Forwarded-Encrypted: i=1; AJvYcCWasmq5n8/tzRXWYFDegQ5NR+4BInIouIb5wPp9hOr68Xfm6c+OisWLWWFgvOrFXESqw6oFTmR1GQ==@kvack.org
X-Gm-Message-State: AOJu0YwGiB8UXtUqfMyJnI3+vnJSbwMelTKNTwjUnV6+PYk40kk53Z48
	FIc0JlzvmZW5hkXQQDg2Ct2zY/HzSl4kM4Exau2ZTjqujD5G67w2vGGJr1TRu0krLq4TRaZz7RS
	7AScR94QuQe7IkIeozvX8bioC1GrYtXLeB906qYVv
X-Gm-Gg: ASbGncsKij8eBexQ3k/d6kbiNMy7QFhJL1IiYcBtylAgBTRIJrKRiw3t4u/zdy70Uxi
	bPgNPUa8lvna4JRTWxuo+8NQu7idFJYzMtC8SI/r5ys+Z/eNqp3ZHZcWZrXiUm7YMhJPjL4MLGp
	/pO2sjQuS1t7A8ijJRNAR8D8mMMwsWsdj3F1uMhjzYgFKp7jte8Jkz3LEKTIkW2whIRdKGPW5Np
	XIa0g5I1s7gALR7AbzJHJ+ikWxtc5rgs5jEJuYpkKBnDt+IdwzrXW67jBInVX8W/KT18RDM8+RQ
	PN0+62ZydnsyRwY=
X-Google-Smtp-Source: AGHT+IGMcx4JTyoiLXSjiI5ZnYiFYQ0QhaKKSOD4lt9orRKK4hn4fiBcmRwDE/b5ad2H8h/ilMH/9HIGo1JwDkoM2ac=
X-Received: by 2002:a05:6214:dc1:b0:87f:fecf:17b2 with SMTP id
 6a1803df08f44-8817678f534mr37024656d6.64.1762522362918; Fri, 07 Nov 2025
 05:32:42 -0800 (PST)
MIME-Version: 1.0
References: <20251106160845.1334274-2-aleksei.nikiforov@linux.ibm.com>
 <20251106160845.1334274-6-aleksei.nikiforov@linux.ibm.com>
 <CAG_fn=WufanV2DAVusDvGviWqc6woNja-H6WAL5LNgAzeo_uKg@mail.gmail.com> <20251107104926.17578C07-hca@linux.ibm.com>
In-Reply-To: <20251107104926.17578C07-hca@linux.ibm.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 7 Nov 2025 14:32:06 +0100
X-Gm-Features: AWmQ_blqrF6qkYIlKEriMvS8QB3DM2vAveh3NdlyDLE92dPFiq1osVICbBllaDE
Message-ID: <CAG_fn=W5TxaPswQzRYO=bJzv6oGNt=_9WVf2nSstsPGd5a5mNw@mail.gmail.com>
Subject: Re: [PATCH 2/2] s390/fpu: Fix kmsan in fpu_vstl function
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Aleksei Nikiforov <aleksei.nikiforov@linux.ibm.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
	Juergen Christ <jchrist@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 38EF31C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: ejcmd6e5oam449aoc5ymxqbci3h8owmi
X-Rspam-User: 
X-HE-Tag: 1762522364-701413
X-HE-Meta: U2FsdGVkX19PFdLzHML10af/pyNekMV4eH1GLt7sOrLUk9UphGgiiEaNcLejaB/SIoDeFDdeIVW3bJ8/383nKJTbscWAnK2tf5RKudikdVM2Kn6LiWrYyCL7kz8FXVxX+kydhTcdFmrhLSNQ0RHSEDvHx+YYiWvsn/EkfCAvXX/AUr15BaV9OlCg3lnw9loq4vtfJ+vD1/23/3b2BvKKgmOQvq8yC3ekphHIHr1rTvdtHO9hMZV9RsFm7RZ6zRcFdKsE7R2ay7O+9zwzr74IvTNdXW09IuYEVmJCncFbCShHUOa8Xy+slL1dNMxYNHXxi0Yl/SCzv2n6lnsYsdGWPvyc81g4HlTDzETILjnLF0nihKXGzSp85hJ/GSxIJ4wHz2HgjM0C40abE6GVyldajWaUk47HwJTAAaMuLLC9UITkFgsqLOU8+hQ5pejL9kb6mh/xPbL3yTkHf+vg09EuqlV7RfJygpI+ku9IacC4Vz7If/WJwqXlDbxr2mWAHCh+gWHB3uE9mlpV4PPVWu+zpSCXr30J8LyU/InqcV+oMuCjBwJeONa4xQGFkRb3OSUxUuWfwc/iQyMuPkKBZCbtFHsxyCHcyxCkTNkaNnr26uW4RCrZQj/udfk+8Z9zanQ2DnH4dZf75b8Ge8xk8gvX2vCMhDEZIvsU+tQ1sdhsdB0hrHE9xF8ukZtgnBAUTsf9pFjTvvOGBFS9/itVsJ3jc/Yz/vBJnZtBB9ef+WdBOyfOTbSRTINTEndHDVuZwnPJa2Ce2Rw3+uNgj1yL+K6cBWq9ezEog7YP6ubus71L19AgI0eCjIbGqpdSLWr5dLpDqI4hx4gshiOgCLjyQ9wiE6Qi/8C99GAi6AVNItY8vdEej/hv6uWxH6ZSQ9ouXlNRBEm08cTcysxFs725Bngs1Xs9A1/NBWLXRCJSjn6MbDGWCY9q8thwmUi2e63eeizDwyg5tzZ1YuLZE+evjhc
 D2eFHERY
 w1o5U+nLu6QncgjXb9GY8AZQ+s4lMi44UC2W9Ys2bW4oKWeEl9mGJjSIsVxbtFlbpNGwLN+PIGkJ+MJKwQDrBjDqhYlIa6VOCXeO5tozkAaEPMTSYFF2orPEoIc5A8JKqLhXu8DkSoTwiYfhkOfQ16GfaCZW3ykyKin97sm8Rwk1r9KEb26HrDCW/T6dbDrQW7GI+PYzkpKOSbWYCcx6JDV4XrDBLcnVUD7qXFZWHAztpN1beVQ+EVQ1IKl2o3ffyhxfx2+OGWP0svNw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 11:49=E2=80=AFAM Heiko Carstens <hca@linux.ibm.com> =
wrote:
>
> On Fri, Nov 07, 2025 at 11:26:50AM +0100, Alexander Potapenko wrote:
> > On Thu, Nov 6, 2025 at 5:09=E2=80=AFPM Aleksei Nikiforov
> > <aleksei.nikiforov@linux.ibm.com> wrote:
> > > @@ -409,6 +410,7 @@ static __always_inline void fpu_vstl(u8 v1, u32 i=
ndex, const void *vxr)
> > >                 : [vxr] "=3DR" (*(u8 *)vxr)
> > >                 : [index] "d" (index), [v1] "I" (v1)
> > >                 : "memory", "1");
> > > +       instrument_write_after(vxr, size);
> > >  }
> >
> > Wouldn't it be easier to just call kmsan_unpoison_memory() here directl=
y?
>
> I guess that's your call. Looks like we have already a couple of
> kmsan_unpoison_memory() behind inline assemblies.
>
> So I guess we should either continue using kmsan_unpoison_memory()
> directly, or convert all of them to such a new helper. Both works of
> course. What do you prefer?

Upon reflection, I think adding instrument_write_after() is not the best id=
ea.
For tools like KASAN and KCSAN, every write has the same semantics,
and the instrumentation just notifies the tool that the write
occurred.
For KMSAN, however, writes may affect metadata differently, requiring
us to either poison or unpoison the destination.
In certain special cases, like instrument_get_user() or
instrument_copy_from_user() the semantics are always fixed, but this
is not true for arbitrary writes.

We could make the new annotation's name more verbose, but it will just
become a synonym of kmsan_unpoison_memory().
So I suggest sticking with kmsan_unpoison_memory() for now.


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

