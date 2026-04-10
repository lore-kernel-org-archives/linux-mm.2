Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B0BF36BBF
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 06:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D414E6B0005; Fri, 10 Apr 2026 02:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1786B0089; Fri, 10 Apr 2026 02:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0316B008A; Fri, 10 Apr 2026 02:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA9CA6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:51:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C394C1904
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:51:45 +0000 (UTC)
X-FDA: 84641725770.27.D72DD2F
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4DD191C0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:51:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SHirp/Xs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775803903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5ecvBhpda9ioV3CZUSK6c06l0wj2C9Zw3R8v4d6gvQ=;
	b=2OdPeEFxx5UH/LF9d4E82DO3fkciRlycfKc6hAZd9ERS4EOT415DYGy8gVLnSCG28y1vJ0
	9BRKEIIAJ+aRRCFrG+z7TQXfF1LBGCv7xiEPT+aeTWfX/LH+w09nzwHpDk1u9md5ka2VkG
	BPmcPQuyPBrI+IkCEqp5+CMtpHIHvfg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775803903; a=rsa-sha256;
	cv=pass;
	b=mTWPz9T9MDHOxQJ6FyO9Dm5ExUkiaCSQZqpCLdkmlNeOPCB32qbMtB32L5tpfAUOQFoBtE
	asHvVuifqpqeumH4PIhKQVRyTkwgw8PA1vH3bj18xYH+wRarHZYHTnJSXQ+yidSyyUm223
	Crv3EBokfXZccVnEPW8UxEyVBH7S8RU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="SHirp/Xs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of komlomal@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=komlomal@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38de18126e7so18419631fa.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 23:51:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775803901; cv=none;
        d=google.com; s=arc-20240605;
        b=aqj5h+KG/Vn7HfDWYTT57JcXyb6gtNBlOdM915OEKNxEfZVysl4F8dp8LU6hgquu+F
         nrDuYpiL7zkWSA+2KNc8lDocJOtJD++wpRYgLWXI0zrchBAiygGSzPI6U1LVio1hDbBn
         13K9ZW9YTmu/y9djsyUVWCC+S5IiYLFy5AfFqXQzgtcnZyicxEGqxluZWMQqbpZ1K/z8
         UHUhz5h348BIPe20EnFJq3DUrSAPstJA/LYCqp4/EzY6O7SxWVjaYqgSnuJvxKdZUvvl
         5H06FeLaaX7wG63EM31JtaBYLx33zDVgfOsEj2b8yyKrG6Vi6FSwuYHPZriVZDyHGBud
         qooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S5ecvBhpda9ioV3CZUSK6c06l0wj2C9Zw3R8v4d6gvQ=;
        fh=gS+akRVAolhD7ROjaX9InxSfle7sQFGDXf9K5MYCt2o=;
        b=VdbwrE+eXjoXM8K8oArcJlpY1m4eFoLhr+IndMneryW6glhJTc26cWQ4ZirsE74Cfg
         rUoDzQyq/HvnCp3ueiYopsfS1JQ3VNnrT4RtvkGfgfNiLHjsS5kx+r3UrTER+AtZ6yEW
         LbZp/MI7zfXZcv10A0yHyLPf4EA7Kl2Za+e1LugS4pf6Wufo493wnfaiJe9R9pBAmnFg
         +lSQsTrHMKD6wSsj/v3zfcHCNdLmg09fDPt2rPzRuOd+CHkU2qibdmCpbFU6R9aNOinh
         0RZajx5U07Zj/gnCW6Tq94hjPuWDbSBcfgW1ixJ0DUnOQYQwwy0UZZZXQumNL4M/jdzM
         aMKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775803901; x=1776408701; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5ecvBhpda9ioV3CZUSK6c06l0wj2C9Zw3R8v4d6gvQ=;
        b=SHirp/Xss5nNTwcVcTrvDs0XwElLTGq3yShIiIr2s05nLFMk5cCM/XLbp14vst7INx
         lRN8/g0mtY1s1ewmee1pDlY9qBrKPmUrc8tqEsrbT058zejOEidXAMV7AvIM95FkqwGx
         4lVCOj+2X4Nsyd4E9unu+y9zvByX7pQ2Kw5ZKzvD7HGUc29PDQOiuvI0YO3uD6/q7BvB
         KyVYw0zLwK2RJsN6bxFKo9fXZ/VxMBkuexmp9+mSi8L90cUAAAnQEqJFwsHiViYnB3O6
         HMXAi4j6uAqM4Cp47qLu3/tnIIUOeko4bIrChmllgO2S8kvSP6//IyRvDL/6EgInE3tX
         Wpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775803901; x=1776408701;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S5ecvBhpda9ioV3CZUSK6c06l0wj2C9Zw3R8v4d6gvQ=;
        b=DlXUgR6re/sYaUR+gjqFRutNyyH5NFCnsNQCufcoJWiuc+CTA9uuDv4d7HNKnOxDr+
         nSFBgKTJMQQDp20AUZcJoHdHzmMv+Lcbpy3B0QBBrfCkQR/bOTv5kov+wkMhKs4l0xF8
         /BiFICOThx+gDPvuRxxQRFdCEGR305nIO5EA+/M163/7SlKS82JHpu5D2iNMc/W18K8j
         TaKL9IaR3Whev336++rrpeJE3tpgbGBnbbdMu4mXU5sU1K9oApSZMJ6eiylwkNnoTYEy
         gqtDJGqKXcYDy2cx6lLUywzDGrBRx65+LaWld5C7S8UXn2sC12dr1uOJ6nH8gSsfdDK5
         EBww==
X-Forwarded-Encrypted: i=1; AJvYcCV0M7ZC6iDOf3HkFDUXHoizHlovX4ZJuU+t3Qif6GCcdt0z8rXUs22iAi2ajn4FavTrApqJpZqyiQ==@kvack.org
X-Gm-Message-State: AOJu0Yzy4pCX+nEibLxKU1YYKEBAZjW9nzYTkZMmb6S96ezyXtpiyvsg
	ekth7/Vfo/7NaBQhjGwJlVwOyI4R/qAxd6wTbfAFUnaQHQP20ylkNSXudb8z9GC1EdA7bUETRDV
	v+vJaJs9uSZK0TEyYgKov1FcsnXvVPv0=
X-Gm-Gg: AeBDietchwVHceKbplMx63Id/rdLIhFISgAnZhFnY5uIEmyYyXkMXHFehEiiT5Xr/Sl
	H8kGz3cy9hDaEak9TVNA2cbxd3V2ziQ5AyLGMmrbLRrbC9bR6Y2xL00oaUzEuSyFb3QYFHU5RSF
	jjlUeDEjSj6DtXYT6EBCKUzfvo5atfldyDwYekii3/Eu9utFgxi/fkLTcGkyDTn2jhGFxF8dFVc
	PVENzg0BOSnYedFTcCTHFvpC7vF9/+4odRnHgLU4TOqmELP3b+aRwc848NRZRpJEmyuqI/CLXsZ
	rHvdXBo=
X-Received: by 2002:a2e:8a8d:0:b0:387:2df:f3ee with SMTP id
 38308e7fff4ca-38e4c02e493mr3910501fa.33.1775803900834; Thu, 09 Apr 2026
 23:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260409103345.15044-1-komlomal@gmail.com> <d4xigmgectqbv5q5dxsrlunea3ynexa4ym4nuxy2rokrawsqu6@yfhzm3hl5nya>
 <adfDCpTH9n2lG63n@kernel.org> <CADtiZd0NF8=4YDs9YR6vKYK92SKYOFd0LR1R3w9ZNoZW4cy+jg@mail.gmail.com>
 <jjhjdtdg5o72rlff75hs5oqaqqshmn2m5vfgjuew76dmjd23le@nw3rb2zw52h3>
In-Reply-To: <jjhjdtdg5o72rlff75hs5oqaqqshmn2m5vfgjuew76dmjd23le@nw3rb2zw52h3>
From: "Denis M. Karpov" <komlomal@gmail.com>
Date: Fri, 10 Apr 2026 09:51:28 +0300
X-Gm-Features: AQROBzBbYnfPywRG3Yp0tRYc7KAWWajkBK8MVh_qYfBGHCI1-FaAx9kMSaKpQ04
Message-ID: <CADtiZd1gL6wFD7LYBrFLcgPRitYWe0PuSDMoXw-4THOwVoErxQ@mail.gmail.com>
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below mmap_min_addr
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Denis M. Karpov" <komlomal@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Pedro Falcato <pfalcato@suse.de>, harry@kernel.org, 
	akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, peterx@redhat.com, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	usama.arif@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4DD191C0005
X-Stat-Signature: djnrrddohobqf149q85tk9cjespsqiqq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775803903-448759
X-HE-Meta: U2FsdGVkX184Z3gkd+KNrwP6kBGavH4CIji4MAewpqyQGXj0VTku2SDKkCn4uberOrC9q4Lk0Q6hwD0EWdUTT6UoZG9MMEAIG1IAmfCEoDrxgk4kc4rSeoYb+gXkgRc2agndWdbl3ZKYT8vRMHPCp75u+uMoHEAv3JxXhjKedNSRv7bilpBsuCrLBzzOEqu0KNHX7gfelLkWM5QxfqD9HyTrsXksNj7PEFefM5OjAlQTVzykkpUAx61/cmhme43VbnKoHVzQJ4IAn2itUU4sTPLXVHTSbyqEg/Qhtx61d7Dd3K0eDeirFbpiyYvWRbBeToD2rcctkPFwzrlcSkaLKCzXmdj3t9pCYOp1Fxy8+u7S37m++FSqkohRLpypk4fSoxtMS5F7XBgZbpnDizsSftNwd/z143grvWQIsVcoLup8UZ/bSt+XJr+zIC2rAo0xO7ZtcK6Q76g8r6ui9EEtVUIjwVavttljily7ZxTEAPoKU1cf1q9S2PKJN4cViw2WvszoyTnk0QpblMbkjB+gB7KClhM8Sinuqlw11JSSJmKSUFx50GYCWwoerkTs9jsU4oRsZSG7kdMBogU17DTjlBkwvQVInzQTouxaPAP1RDlydR7ZXwXKosLmkgQojRvekfh+x75N7dmHQGHZGG+xEQ7vLz27KUI2y4Y4z0NclVDEb8z659hPNjxfXZ/8M2znl9WR/GIuLeeaCSJTQIAG9CdnE317IMxovS8unjUy8g0aOeuVPK69mpKIk4pY50WNCuZEu4SvjsSXDOL60t9lhCqNRgK+N7fnNXznK2eOb18Z5JL3A5KbJnZuQQrxi7UB6bgBBkZf14a0RxQJAHohngvzFKoJLvNJsnYthtFVipiUPj8EY83Zk/ziBlG+CICWGTU5lBW8Mqp1Xc3Zi4s/6uYumek41QYcfn5tYAmBHYlKPbzYVr49uGfXyQed0bjY09P47vdDtn7iTXlzRDd
 H5Aoo6JR
 90I40hluWfEwtA+ataA3HS+lCirOVMRzgPyBLllfypp71SXcwqGh2YzsFLsSEIE53vqVMcb695Ut4pFEKNrL7Dp3t/frYFH6n63okk3h1Vv7OqVWxVxD9ADyVfUkuU/SLmeql4tFR0zComrAjALq02os+h6XtN8Te6buSpiruBKyKh5Tu5Zou/yAaCkn5uYKtwo7yf7vqnrzjXP0xx+0weZZTU3VV1aM8qKJF2cZePfAOjAvns4CHKaIHAaNpkE3OQUVZjg00o1X0LEQBtOedIN/wrUNzarJ8l4FLNx3GXTUVzIo7za6JAf0qjmRG6t50tmHKOky4KG3hgN46+XYxNMJPXxNY1mBNnDVdnGn6KRHm1aPt5HpC/08blpJKJQoaSjAG7URJCm9Y79TR5QQSk3ZAtarpFTLXyF6xIpxt1GO8AP7rS/aP9rO9G4oBV3xq9dx507CzQZeatbrk6ob2n/byAyyR6NolG2PNHGlfX8sey6CZtB8Rjhf11l4znfnf0xrDv9Zta7GzKME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, Liam. Andrew has already picked up the patch and added the stable t=
ag.
I'll make sure to include it from the start next time.

On Thu, Apr 9, 2026 at 11:16=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> * Denis M. Karpov <komlomal@gmail.com> [260409 11:54]:
> > On Thu, Apr 9, 2026 at 6:17=E2=80=AFPM Mike Rapoport <rppt@kernel.org> =
wrote:
> > > On Thu, Apr 09, 2026 at 01:30:07PM +0100, Pedro Falcato wrote:
> > > > This looks relatively safe. However, I'm not sure if we want this i=
n stable.
> > > > This has been broken for 11 years now, with no complaints.
> > >
> > > I believe Denis has a new usecase that wasn't there for those 11 year=
s :)
> > >
> > > Denis, can you share more details about your usecase for us to better
> > > understand importance of backporting this to stable?
> > Hello Mike.
> > Actually, there is nothing new about the use case. We simply started us=
ing
> > UFFD instead of the classic mprotect approach in the binary translator =
to
> > track application writes. During development, we encountered this bug.
> > The translator cannot control where the translated application chooses
> > to map its
> > memory and if the app requires a low-address area, UFFD fails, whereas
> > mprotect would work just fine. I believe this is a genuine logic bug ra=
ther than
> > an improvement, and I would appreciate including the fix in stable.
>
> Then you should have cc'ed stable (with the tag too).
>
> I'm fine with it backported or not.
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>

