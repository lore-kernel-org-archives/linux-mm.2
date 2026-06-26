Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D003DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CEA6B0005; Fri, 26 Jun 2026 09:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE806B008A; Fri, 26 Jun 2026 09:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD4D6B0092; Fri, 26 Jun 2026 09:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 659796B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:34:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBF748DEEE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:34:52 +0000 (UTC)
X-FDA: 84922159224.07.0E04055
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id C16AF140014
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:34:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kSzTpebS;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782480890;
	b=05U5pTImaym/3S+oXKZOOisE2fi/6/zMRZ3yYHKDDZxSpJWUxSv5IOX6OdgB3tFdPaBT8I
	SFBURILKvNYlzYZmCE12pCpxGEHzDKMkG2vToSvaztUeIJuUT/S02BjZ/27KdFelP6SyAy
	s/YvlYvx8iD2/31JbmVylcyrAyY8S4c=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782480890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OFusc4+4RUwOAF9njJqeKXVcmCxYVbDE1Q1t4UJqUMM=;
	b=DvZ6zpnmE9crTWTdxG5U0ZOMjkfLIP6CksQ2I3AE0/TqM8hnJ8XcTOriNvPBwd2vi/teVg
	l8h9YBvGow6cQ2/y5TPxxYTpS1oh8N7ZK7xQMzMUVZP7vBasRK3+J9nI7fC4HQq9lykyB5
	yaRbActUdqvsdvs8UMeoVhy2zRo26jE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kSzTpebS;
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69565156c06so11885a12.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:34:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782480889; cv=none;
        d=google.com; s=arc-20260327;
        b=HPHCCIV9hqgmTnqxgRqkjQuXYRvmCUcf/iT25YMbEcXDe0hCTiqdVMR/p0f3ZZDWgm
         mrN0eim6SykAu8MDTg6tX4bqYbgSMYIjPmCGnhLg3TtVxh1qop3iEzVlmb4AvC86gGcu
         qnFge+kyDkKorRcj3dkMI7vLE33UUewaGooxl8pGhk6EMtx9MJPRiA1ZrfJ6Yesqt8fY
         DnL9ZIiL6Nbj11ggQEqFv9/Ba06XBQG4pJAVMq5rsTTF1s8+Tgt9b6FEhh8p0k69hTZ/
         4u9nAcnyATXd2MQaUbERvfQIYf7LSy8+I/MusQ97QNrcwep3BnLk3i0DzNQNbxjCp++Z
         O/NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OFusc4+4RUwOAF9njJqeKXVcmCxYVbDE1Q1t4UJqUMM=;
        fh=h050B6AFvWQShfHC+yYxpIr9CWGD+MlrTNeGo3rbAlw=;
        b=KrIplLxT5TUo20AVaH/fgas5wDTGqZVjtGhza6zWVJ0csTYzZO3bZEFKwbYazSlYBU
         odCv4qpcei0xM+VXvOQCXFx5cclfRpomI8IxtB2XHIe9lH7CEhxTjZZGTSaCTd3PbKt1
         DdjFVXaNLMO+3rY+0MAr1dLMyU0kL4G5O0o7WhVbreR9qENKbFWMiuVKMxK4UdoJea9d
         +YpI6YKuntb2gCmO9KsKQf+DdxIBiySNFkoojUUS9JYMhu/hXkX9pZIl7meuIeiNSk8D
         LHv2tS5nuCa1znJOwxa0ke49hop1ho+iNx2dPwK0blIX/6kGEouPjaUMRGuY98zR1rOE
         Bhxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782480889; x=1783085689; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OFusc4+4RUwOAF9njJqeKXVcmCxYVbDE1Q1t4UJqUMM=;
        b=kSzTpebSxs7A+L1QKh7Z2WLMjE2LPQGRXjNIvuqJpNHpQ5G55OnBcFMWfeC68RPyF0
         lY99UN71K0V2MFe9t/VOHSYv7lJ/VisA7scVZtFjTdMgwXv89uX/JC1XOxoXFOaZ5Rz9
         oU5uAywa1ODeDNHw5wI2ygSrYfvB0zg0y2D/QccMAXOBmshVqBmG6jx+9q0rMcEKuH1B
         bAkhQm6OGkJ6Z4efC4kb6PbTqAXnHbpjnV33IRcB7ZjCp2Q1iScHW30pUvcvZK8abOCW
         05VwtJOVAt3XnvTLML5DQjU0pHnGy4aYk/4jYlgOcW3ghOTBb4/P+GQsmOj/CUFzEDrG
         v+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782480889; x=1783085689;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OFusc4+4RUwOAF9njJqeKXVcmCxYVbDE1Q1t4UJqUMM=;
        b=JG9DfNzgqvhwjGleDu3fKKSqo+neHsolPGakyiATzjOtH7FJsyMMIKtc4qbmzUL4CA
         tHE4i1oM0h/NdgObObM4DdClnOXZsZ9RSUdU9qlA9N3rY917qHJnEKYuIGYl4JYvzMVJ
         uZNrxDC552SdsMaB+1h5CE5cnnl/QIupfPAGCg5JgwPk8J1sJB69LX76fYf8lgdDUz7l
         W9bPED5dJmSVEGis5R+FtGXTca7yVg1JeLvfdj0rqbJ0ZdYzKNc4U64vnUgrs4bsK7Sf
         RaB3FjigrqNv3jdMqzrvYK3fwgLW+oWbNR5wq07hq7poy5mUw/Sa8/oumPsSvkPcZV1J
         04zw==
X-Forwarded-Encrypted: i=1; AHgh+RpPETXjojFVdfUIap5CnFIUfwaF+6OI3/uvaF+6oUPwJDuGzXYBaNsjC/vMk5pbDgRgEWZdiR1f6w==@kvack.org
X-Gm-Message-State: AOJu0YxUTfq0sPWYfR8cVG993hTJLlCy7gFqJ7ztJkETUKEhKCm2SxKM
	Ab6pkcm8rjwhyYKmQWJEUyl+24t9wsFOoxr39Gdw/Xhwmnjeyzp4uPdtpxVygojcXdQgq5gkndt
	H/sCRSMwISVNzODOKSUOF84E8BiOAIf/afgmQbhJV
X-Gm-Gg: AfdE7cmcjhL6GpbcmQtD9cm01rqoGDuM+4fWSOKfyhaFfZaJYjIP2X7fYxhNmnJOMJn
	7PlPRLnMBRlSeg4e6jzNgnIwyepEd9hE6Fol9cB1wXRpska8r+U+U6T8NTl5BgR3hbB6vMOaAKV
	BLI2b7CA3dKh//GwOpBCnpE+g/DEFwW3kYul5fugXOCsh9JqViqP/De0zJvvR4yrWdddO9YnLo7
	ykE6ggBAuz0GMjfGbDHqhpYCHlcusTI1dtdiPVDjpLic1icMulhz7JWukKGn/DhXSCSoo/kelFX
	k1Db9MJpXOxdLriCE16EEChyqs0AX/J6AUtjVRXdXVUBz8VPCMon0hgbECM=
X-Received: by 2002:a05:6402:305b:10b0:68f:d41d:ca5d with SMTP id
 4fb4d7f45d1cf-69838079835mr4734a12.11.1782480889012; Fri, 26 Jun 2026
 06:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com> <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
 <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com> <20260626142616.5232c61e@pumpkin>
In-Reply-To: <20260626142616.5232c61e@pumpkin>
From: Jann Horn <jannh@google.com>
Date: Fri, 26 Jun 2026 15:34:12 +0200
X-Gm-Features: AVVi8Ccjij95miiFuC4obt1ADtwSEC1vQNqAn1Ep-7UuHNcBNEBqHY3MBA-NbNA
Message-ID: <CAG48ez3o1Mt59dWdyknh_SEaoi-cHv6pdmix+aOdBy3C0-LkYQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
To: David Laight <david.laight.linux@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, John Ericson <mail@johnericson.me>, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, shuah@kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	linux-kselftest <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C16AF140014
X-Stat-Signature: y9nxttxtu8pqhx3i1zu81ahwybrcs9pi
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782480890-324343
X-HE-Meta: U2FsdGVkX1/0YV3t11cdUHZMr2hB49KCtCNmZffzZ2mDXW1oD4yZICB7qnfW2QSlfCazK6q/DC/ztaWAQTAr1MvfxqpK+xN39RkRH1GHkeBiNTc8AQyg13p82e/UPhixy3gzSdTjrcxiW9s/ZhUeeeDbL3kSyFSXijwVMgbQTFAuRPACxRfDy9CYyw1NF5kpCaI2X4aY6RGYQTRYunqr9PTGRG/wAfBVGAOArZjYscSf1IzHvFtyRrOqxo9K0c0UKV1SSv1BbBj67nc0o1LYb5ZDwgeO6YJqQ4JijMa0ISdJ2J7kDXTgPpb40pTV8ohNAFbmAZUCEkNjzc3JC6fzRI41L2o/gdCynj5/V36SWWyYYDuR/4U17AHiiwl+WOWwU30f8hGCq//LlUvH/2w5Cf3I+n8P8IWelPdEHPyj7lW54z+PNetSkReLP3Tv8V7wf+l/Mgj8ynVmen07f9hlQQCqdnV+mZnttO4dNWL2XlmJjXh5ELcj79c22gk7FwRYsI74Zb6G8x9fsg9d+zHV2H4Vp+WYqpBZsVFHkWf1Kr5WUEq+Ajb7fqo5VcBCAHGpiJi2po1KB7pmAQddjqkIRJK/haXg2i1bYuGIiODS54uGKv92o86Lwv8qADwtPw7/LsHo0mzkExiPThACdkpnSNhjhoa9nMDILSoNUNRl5l9qR4P80drlkBp0W47oWlCJHsj8G43dj1p95mhRBnAv9zXBqvqvAGktK81FbqcuFxCtj8vqKpEKO5pYxc57w9Y0ZbI0DzBT8tGwI4ruJpAKnTzg8CXtJumWf20PZdGjK6dLgLSqeVQszwI8QwFM4hDYLJVFOXmfUS5AgC/pE4x6UaMY57ZQq5+MgS//Jc/3iN/VZn9RhwZbwa5qVBwJ953eBUpg2q33djwGxoJBTRspLk2bWqJauhxK10xDsdePLNrM55cxRFnUGtKnvw5An/hU2gstjrucgUz/oEIS06M
 BAWdSmfZ
 aqYX20lCBzb0d6Y/uk6SwhFSiwkqKIdKIPHy+MV6kEA9OHIBCqug8b8SXHp5aKkNFROVOBexz/xB6hmFKTSFvMsNkwLAL9RPKkDutGHWM1vJKOrK38CJcHM0oeptyBUsZo1tPIRW4gNtF8SgPAnZGt/dDktXSm7wvraMSZ+VCV5zvkgZ8J/5zBfTomR7Jw65WrDtW7r9Fe9D5Ke/hnme/gJr8QLk0+kH+L3c9zdmyA72YCXRT4LE3Ul9YTITrJuK/4cfnDCzlvy6sJ2/+rRiKmVMQ2ktgF9zJwjGitYKVrGzLkY72rhk2jfOwQkvTqe0s/RfNlN7fUnI7TbGSFqHzAQa7WijoO8lReg7sCSXrbfIC4r+/fEgW+BS660xy3FtuX8PN6FtU7yK6oMEeMRlXuB3lhPGaQ68PJbx84Q4Cgpcqm2oHf2QH5PMm5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 3:26=E2=80=AFPM David Laight
<david.laight.linux@gmail.com> wrote:
> On Fri, 26 Jun 2026 14:39:22 +0200
> Jann Horn <jannh@google.com> wrote:
>
> > On Thu, Jun 25, 2026 at 10:50=E2=80=AFAM Christian Brauner <brauner@ker=
nel.org> wrote:
> > > The arguments I have heard from various people so far are:
> > >
> > > (1) Userspace would be able to clone a random chroot to /woot and run=
 a
> > >     binary from it without having to set up a complicated sandbox
> > >     effectively making dynamically linked binaries more like static
> > >     binaries in a sense.
> > >
> > > (2) Quote:
> > >     "If you debootstrap/dnf a chroot to some location in your
> > >     home dir and try to run a binary from it, that it tries to load t=
he
> > >     libraries from your /usr is a pretty unintuitive and not at all
> > >     useful behavior."
> > >
> > > (3) Quote:
> > >     "[Various remote execution things run in locked down containers t=
hat
> > >     disable userns, which makes the sandbox impossible and hence our
> > >     builds wouldn't work there."
> >
> > FWIW I think someone also mentioned to me that it would make things
> > easier for them if they could build a piece of software in one
> > environment and then bundle it up with all required libraries and such
> > and run it in a very different environment, without
> > container/sandboxing stuff and without static linking. But I guess
> > that's kinda niche.
>
> The problem with 'ship the shared libraries with the application' is
> that you get all the problems of static linking.
> If there is a bug in the library code you can't fix it without getting th=
e
> 3rd party to rebuild their application package.

Yes, it's appropriate for weird use cases like "I want to run this
historical version of the software and its dependencies", it's not
necessarily a good idea for normal application use.

