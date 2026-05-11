Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD6CCD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1EDB6B00B1; Mon, 11 May 2026 12:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF68F6B00EB; Mon, 11 May 2026 12:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D496B00EC; Mon, 11 May 2026 12:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D058F6B00B1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:03:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 962458B2A0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:03:18 +0000 (UTC)
X-FDA: 84755608476.02.171F8F4
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78D12140022
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:03:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T5+yKPjL;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778515396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuuaDDwSdRyrUMct4d7jjjibKHf0gx8tzrW/J2KjDZk=;
	b=3i9BUAJRMzFBApheI/XaVdwUiEqy6BbVEz4dvNydI8VyjyUBHJf/NXtdNoodi9PI57NVEZ
	jNzp7155w/eqPlv+tqHJeemm0Y9Rz31ocSw/wenIjoAZe+X6kl8+48E9tK8CAi79te7fLu
	3GmN6oRmRilzJptOGo2aPJ0f0z5hp2A=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T5+yKPjL;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778515396; a=rsa-sha256;
	cv=pass;
	b=DsHpKJIOubHLq/M4T+vE7yQkY/oQt6ULBhrvoZJ88aMOJ7R8PSUCg1z2RLNPW92ayDLRZ7
	IcB/BxcvxaLpA0OljBlBtEFA69y1rH3KTo+LO7R9KzHvmJlRkP7EBFT/6mv4wrJQ7/3477
	ddU7f+Kw6GfQj4fHQqIGcbsbhYyMMcM=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso25a12.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778515395; cv=none;
        d=google.com; s=arc-20240605;
        b=eGNQFa6AhFjo73qsrQwKT8BRpDK7fYigwnOCvlcpAzUTDgR3suR0UKYv+B1gyNFD5n
         +E0Jv85aHR7WSKa+Dg36faFlct8BmCtfB6u/C7gmlPh77OEvRNOqwTAjia3avRNYQVuf
         x/obZlFi1AEP3es9k7+qiBGvOZaz124zv16EdHQ3l+DfLzg2U7rNQPHQTZPhXg2Hxete
         /+FhFzbn6gwpLrdo+YIDHkTR45fwfEeR/vviGk6g9HdgPcSvZ6sAaw5Z47MUZRinG07i
         Tq8z2sJ+gyil7tUoEdlteAfiZtvInBpSaSTsFp4+7dDSPOoN/M6buC/JBTb2SAcmxK/G
         x8gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AuuaDDwSdRyrUMct4d7jjjibKHf0gx8tzrW/J2KjDZk=;
        fh=eRbqHMCyNK7S/Sdej4eTaU+ss7N8nqRBmFpe42Xt3yI=;
        b=JVhxUtT+oC2+eX0JjCM9GHPNwQIfo1wINCUhuSVjr2KCWWDSTsiAhKvAWVq6dQVk58
         VnJEoh01V7IZFrGNOG2WFtHfM3d083QWoGHrHlN/Qfb5HQJwMiAOoHUqNm0u29MCGYD4
         MmLqVTvU/2xasXXFhY6YpwQ/mWjpc6BipYTt1ZTOgzNE2+njAafotigMmxE8gPz4oBvA
         NIr3BtG3T+7FI21vHRLuElGPNVTlaPWzIWO+QhHHAzouuSIDEwnlS7SbsAPPWTg95Knk
         I4yrHE65PGuGcrkHEWL2n7R/whq+CSGJfDTaUj6vFSjMEzhGPG8bSiXq8r6+NqLyPvzm
         KKnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778515395; x=1779120195; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AuuaDDwSdRyrUMct4d7jjjibKHf0gx8tzrW/J2KjDZk=;
        b=T5+yKPjLawzyxhjpKpZwfzSWQVqGQFkkFDkxtk/7ZVDaDYKPgDD3hq5Sm5K+l06p8i
         qeBjzs3g0C42Njgz/+KjEdptdtQQpKb9cKCtEpxUkfWCuyRSRXFAvkBDy70TJewuh1Bt
         DzEvTMbp/Tcnyn5RTSgCyNq3a4Ba3B2AAM+3gpH9sSdxM+hjAfVYnGnaMuXPNgrZduD9
         5/NrilROZeRTrbh98vH/6aS3hHr+AaTVXIwzodd6YWNOFIWVDigptF7FNUkBVqyCbZO1
         vGVVcxeFP9ljjTTitZ5GqPpJcn8T/m0vX3fCcjxvKthfXc1PqYmtmR3mHnC/ZRcjeWBv
         m60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778515395; x=1779120195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AuuaDDwSdRyrUMct4d7jjjibKHf0gx8tzrW/J2KjDZk=;
        b=CggsR2lI0CBp5hTcdCGIUKB6ty9aHvOstulsutFEDD6olFSMdiulMiGpzzwZAZjiqO
         zsg/PKZM/wvBMYamqSYyEPOTSuiyOb51lvD7l+hIZcVx+9yVN3db+EqdC8aTODh+wFRl
         BUxFEgE7malIs5gOM7rzaCGrIm1ga7HIUCXdQ/vqwMik9n6GSDGfWKP9J5wYadIIfzTb
         UwAcFzXStegKVU0o6CB18YxjE14gm0qgCGe1jQ+zYt3Ti6AoU0InZnJ31eiShBsV2zqF
         W43TtTEkdg4BMnocmfA456958Pg+DnX62m0nfGqpx2oX7zfXKERYgxbqkvyCg8XmAoJ2
         lgyA==
X-Forwarded-Encrypted: i=1; AFNElJ+8IzPzrk1HW8iuRQExdpgpk57eHiaJaQ9OcZj2LXoGHEKVKLyDs9TkIW6m25zcOhAIFkN9WhmR+g==@kvack.org
X-Gm-Message-State: AOJu0YyKBsyPdGJIO5nstQGebE/BiXOzBl/p5657B/ydjS2657MEu21Q
	gxW6Q9rLT4kfXR6pGamP49JlCO4CtABZmk8CWc5Khq7ORakC8TYig3BvtNOSKFlfjMECJ8xwQWq
	2/vH/FSVWWslD5qjV4EC1TWGeokc0CJBbL/RuGP0v
X-Gm-Gg: Acq92OFlSvG5rp7gGNY1MC/hRLUWa7OQ6Itizf2oXpx32ocVcncszQ3o8Va7F8JhPkU
	p4BGDAM4CajAWGWaSv3FNUUmIYtyboca/YB3lr1tF1kVaivw8mQgjMi/kJyctGumea1ypT3qYjp
	s9EG4gpTPGq7curwkaBzV7q/lEjt5pd4pSQYhMVnONbhvEdVprH78U5YDl9/yiXq5DU5spIcLp+
	VlGQClJSbof1q5zRjmyakiYYTJe081dn250hh6BJvYcbqkph6i0diVm0hwYxzBvteF3TGV+qvwq
	898d08HorIZylcHBUow2ZTcqDNOtXXMeAUMyhCUTU+Oqr1kJ
X-Received: by 2002:a05:6402:4288:b0:678:cab0:4fef with SMTP id
 4fb4d7f45d1cf-67f5ab7d126mr133695a12.12.1778515393940; Mon, 11 May 2026
 09:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
 <agHmO4i4YUhs3cSG@lucifer> <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
 <agH1ZSdX_7QF8P_I@lucifer> <CAG48ez17evhhcoDKF6AoPqzYZwGuFCkVAsc-0bBzevf0LHYNxA@mail.gmail.com>
 <agH7ONBSX7XLzS6q@lucifer>
In-Reply-To: <agH7ONBSX7XLzS6q@lucifer>
From: Jann Horn <jannh@google.com>
Date: Mon, 11 May 2026 18:02:37 +0200
X-Gm-Features: AVHnY4I2V_gElnqPN14yzCyNl2tB6MVkPAmUTaxoO8t6fLEorvR6VSpBkg8hWBk
Message-ID: <CAG48ez0y3N9uEOzvr4N85Js4XN1fh4JiUFjW=PQB2UZ_5t1R4A@mail.gmail.com>
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78D12140022
X-Rspam-User: 
X-Stat-Signature: h8dwqnz9tkm9cpt87tanfsb3bji6n8o5
X-HE-Tag: 1778515396-672764
X-HE-Meta: U2FsdGVkX1+961LMfMYBJNbA9l/ymRbN7qH4+xe+P/5bo+V5rjwvlbPdHgKFQhmkUVgbfjXEW+s74HwwVBOArzyqoXkKyLIzX5TzcLMSa3bwTQv3L901F1aDbGww/rOeY63g2xNfuASnVxagzAJGC1MSJMiJkRRKx9ODYoouLVydE+9+qWyrRXzYWNfh3LNtNSpI4m3P1k5FTaf0SfeneuwOq6pNr72oxXR4YKFpd0dpQzOgdrrNEq4KrrRF2hr0OJ5twSsOH6y7pI0HBMjUXVeSKeN9npYjKT9UCx+26nvbSu2aHYImBti43PPagw29h7VWTvUzhOpi0MtLQru21zSu94GeGAG6+BWQa4fHb4I54NI683Ij7sTYRUH/F60uSLzJrduWINyA32FEosDvs8jBIiylzIA+l1wGU8Ra7ZjM1R3r+6N/D6JXzSlNmIeuBZngXtM9SHCxBzLNZNMRdrruGRTE0kZJW0I8B4XkxwszjM/E59xOgxjZDF8/wLL3qwtduYxzCUeerkYKgXMwPc3o7WtIulvxEc5sWs4db2aO8et1jm0EyXSI3zvLPfW3eE4DusBeKLmvd2/gy8uN/R4upTM5F1Pvjk7soNWjXdWacHsSqqhczhiQ1wkP7MXZGbdIvU1/ebjg8sswORtBSnntctdQLU4tDnwCVqo3rKmgLtRVCeaiPrnJZ5jmOKsyLLjPW5UeMO9INRugnTsy2t+ysloSNGhPJvUbAu/vVk8Ef3KUtfAOrHrImhW84Z6PiqV9vEdIhonAmyAAVjKsoMDnh2wOYHSJSNgd+tlCXdBXrwJaaXGJvhQcOofpkkatQefO/JDuSbBioJ99gX5kd/eAwDYmUUYlpevS6qAk8dP1gO/InOEpGU77L9OzEcL8hsWIsLVSAOP9C0fp3LLJsMaT2l4nSEiC+J+EICtejPwfaU+rKSF4FNeIKpsFHbaGyJuWr4O2S7sVU52NWAd
 2zNyStO5
 SO4cSzKTh/9klC6qQWO6OUv+bB1yxHO+M7uZWaNvEyRcGdth8b7GXQKCQoHKBH2JBBLyBgtsv+wzEH4ue+UDLLVa70Dr1eTV2ZA1THKmw9s5GcDET+s+ntua4Ei2Z+sAsqQ1XYVdl7/QiEGugwV0pvdvwH+5jLzdYa/q3ABwXFM1K5k+6Ng5WbV2crfwATuTJkAtONtvrEsWBr9DdkrfwXuo9ceN3iIKMAmI76RNKp+iKh6ZC1httZw505m6JaMx0ambY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 6:00=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
> On Mon, May 11, 2026 at 05:40:24PM +0200, Jann Horn wrote:
> > On Mon, May 11, 2026 at 5:32=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> > > On Mon, May 11, 2026 at 05:19:50PM +0200, Jann Horn wrote:
> > > > On Mon, May 11, 2026 at 5:05=E2=80=AFPM Lorenzo Stoakes <ljs@kernel=
.org> wrote:
> > > > > Hmmm I think it's a bit debateable honestly. The ability to handl=
e there being
> > > > > gaps is a _new thing_, so there are no semantics to speak of. Pre=
voiusly
> > > > > mremap() simply required that you only span across a single VMA.
> > > >
> > > > FWIW, I think mremap() on a source region with gaps is such a
> > > > hazardous operation that nearly no userspace code should be doing i=
t -
> > > > gaps are areas in which any mmap() call without a fixed address cou=
ld
> > > > place unrelated mappings (unless stack VMAs are involved, which wou=
ld
> > > > also be a weird scenario), so to use it safely, you have to, among
> > > > other things, make sure not to use libc malloc() at a time when tha=
t
> > > > could place an allocation in the gap (which means you also can't us=
e
> > > > printf(), and so on, unless you have swapped out the memory
> > > > allocator), and make sure that you have no other threads that could=
 be
> > > > doing that, and so on. There are rare circumstances under which it
> > > > could be safe, but I think it is almost always better to have a
> > > > PROT_NONE anonymous VMA or such as a placeholder.
> > >
> > > Well, we're holding the mmap write lock so none of that could happen
> > > _during_ the operation right?
> >
> > Not during the operation, but right before the operation. So from the
> > userspace perspective, you have to know that there are no concurrent
> > threads that could be creating memory mappings at non-fixed addresses,
> > and you have to know that no mappings can have been created in the
> > memory range between when you checked that it's empty and when you
> > make the syscall.
>
> That's a very good point :)
>
> But I guess applies to any operations that operate over a range of mappin=
gs
> anyway (madvise() lets you also do this, though it'll give an error code
> _at the end_ _after having done the operations_ if there are gaps).
>
> So madvise() can have the exact same thing happen right? which is... fun =
:)
>
> I actually wonder if we shouldn't just change this to disallow gaps. It'd

That would be nice...

> simplify the code and we could even do the check upfront in one pass. It'=
s
> doubtful anybody is relying on the gaps behaviour for anything real.

(I remember that in the past, there were concerns that MM operations
with multiple passes are slow, but I guess mremap() is probably not
such a hot operation that that's a concern here.)

