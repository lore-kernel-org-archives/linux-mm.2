Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2341061B1B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE726B008C; Mon, 30 Mar 2026 15:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95A06B0095; Mon, 30 Mar 2026 15:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3816B0096; Mon, 30 Mar 2026 15:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C06F76B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:13:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6652F1A0887
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:13:55 +0000 (UTC)
X-FDA: 84603679230.07.1164C98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8FFA880011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:13:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5omcdyG;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774898033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIrVS86cRvIeIcosCbrm7cWN2wVrDYpF585sFe9oeMk=;
	b=SixKEMy8muYL5jbK0hfMO3NUVgpc6tfyHccTl7yXIgssGj9nLMKkCPiD1TCm+3TiuN5Ibk
	bEoBiR6QMmFciofyVNrEaZqamif/70y6IV9VxpdWlUI3z8ydUx2ntemPTablhDoVSbvIj1
	skxgl0V0rXl71dTglM+TVb4YNO86A4c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5omcdyG;
	spf=pass (imf02.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774898033; a=rsa-sha256;
	cv=none;
	b=YghWVFPHmAqgCH6oUkV85P7/8bp/6R08r0LJeGNXxwipMhhvA3tD7jLdr+UT2F/dvZYrhg
	6SklL+UTYKzW4hfwZU40ulmpiu6budAkqXs16NjQXk6go4R4D0wBdEgBQFTZT8nQMxRuqV
	M6BfHIBA2ufd7dL430a5e862xiG+K+M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F67460132
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A6C2BCB5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774898032;
	bh=tPjTZlKHtboB1hQQvFLO2OBk6hnMtL/G1+OE4bnyXnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M5omcdyGFNmjR8XnslY3vHJteO9ACXpqj5UETA0ewBkU9910YBLs7pId/Bkt5mc5h
	 YlXUodxa16q4vKsFK8kj5NwTjKAUl/PiAnLCMLGPDSd/QmOgJ2RCHLTU2OTViTVoPS
	 b4yFp2mVvFz5jgtYUzSUeETaGA/Wd0zj9sqB3cxiYNdIQ+dK9BTYiw+SRxxZE/1zuu
	 8zV7j0EY2LpEbFj/qElJ1jrrfF4l3NRR6UZ4BEhzTSpxhwAhahFFzPAsY/54xbBG0z
	 /RMrLkd5grlvgmrOD2SfAjaieZScF0Cw8JT1vWj/IZ6nmlvpisslqmZZKUUVk04Elm
	 eMbV+f6jnsYmA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b97ed4ad579so769523066b.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:13:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXBocKJKyOgj89KRdsz8DMZUDMte9ZoxugmwUV2ckev9X712Sm1jNwNqjsjNCk8JbS+YqJnWpUdqw==@kvack.org
X-Gm-Message-State: AOJu0Yz3Har6IPVvInQX4MXFe5Dkc7a9oXRgiBqzTMxRE/CzxQH5Hjmt
	TArVAxgzyIxOvgTLMHBtICs2lgz+Gkr7lSaZTxKoFC4YYwNa7wdxSWxMBByBztk6Vmr8nSfRSmQ
	Agfon/pULTWY8gyQcJw/kW7zOCQKwPgM=
X-Received: by 2002:a17:907:d02:b0:b9b:e687:7ca7 with SMTP id
 a640c23a62f3a-b9be68791f0mr61496766b.50.1774898031504; Mon, 30 Mar 2026
 12:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com>
 <20260317014802.27591-3-kanchanapsridhar2026@gmail.com> <20260326192351.7fc8c27d87c60ab5f7de5395@linux-foundation.org>
 <CACpmpofW2hcmQ5srg=a_WT2fXNhvY0pp20rjxxL=n0jGGUEi2Q@mail.gmail.com>
 <CAO9r8zMSnRq02b68Tjf_yi+_Wg6TBgyM53gaxmfbXhXJ59Om6Q@mail.gmail.com>
 <20260330115141.997e29f96223da1e22c0f375@linux-foundation.org>
 <CAO9r8zNRcSBdBthR8Mk929pT2z_Ew_vc8_nLJns-2FygSX630w@mail.gmail.com>
 <CACpmpodFvA_DMmXBmgZfE4A=VnH3+0rVfmAr2qKP8o738qafbQ@mail.gmail.com> <20260330121249.fc2cce8d2fb78ff2c68d3645@linux-foundation.org>
In-Reply-To: <20260330121249.fc2cce8d2fb78ff2c68d3645@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 30 Mar 2026 12:13:38 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNXqUd08zU-br_sNOQxQ_GyNRzPfQS1YZxYnk1WnyER9Q@mail.gmail.com>
X-Gm-Features: AQROBzBjpRE4EjoZ-iBabkbyiWViaB6E-hwRmna-ByP4FkHFwUW1GAAijWJTup0
Message-ID: <CAO9r8zNXqUd08zU-br_sNOQxQ_GyNRzPfQS1YZxYnk1WnyER9Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4rg49egxfmawzybnwpjzzkixi3ws1zoi
X-Rspamd-Queue-Id: 8FFA880011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774898033-560787
X-HE-Meta: U2FsdGVkX1/5fOGakgR5SxgtfyagJS94BFFO1PKGTiOvF3sXICYPXrmXlZc9bUe5LUL5RJw8cps2cEygvVeChcW9Hy3hhq9P5j31OWBqq5aE02rev2v0PcdUM/VGJJIow2Ree12NbH8xqYZsioJXM2tuab2Xxp3zmiElVTYv0a7lXThV/+pHAacLFYQBIa8gnk58f3YD7yjijqPERawFcflNIh2RkPqG7M78d+oCSY8kn1oWN9/xbF7UOCzkrxavHhEgX1QsLnyGPtjDPiToN8V0JkF44NbYgnrIONr+OvTwtu1qs3H8ExjjDK517avBkg03nt5401Cob/MsDrnLcci/OdyRzF53awi+xH/vWBVg1/z8hw60nsqO/r7Ake2qGRFlJWqGG61pCSyuFRUhqXxS9g08blfeULCxJST5ipCPVSwUM3Ok2COyPPD/MXncp9W2qUr7TORQYJdvGzhNaOiZ1sFo1fnyVmJ6f22E1zsGHZ7wCF5Ud6LxHCF7WODW5hPjr130rctrLv8R0bWC3tTLxeCLIImzi3qFbdmBu8nDShkdkzJdDGaDAWE4NOJaA4lW9V51Ep6zmuPjny++xPNiDdB38lgdKLob5jyjqzRqbK79zPl6F5IK03pmu33kuQcRTi33HUErDPvd7bXvHowUFuUrp0VYUIx6bHrkEyvaINroUduscNom8gXVT2OwWdDkHyxbYjAZIbPh5uTQCtWt2G1xM3KlFYkMQmDeiAOkiZzyaoI61kNC/bAKYkTEPDEDLL5apQQ6MC4TZxyba8E31ERW9ZEGkYn5CSpEMnV2EcNJlHTOiTpq0zUQyTgxhI9oA6tWdKKu2kvoyJpXKoj3LrtBl5xhRhrVFAAJ3Z2HWltpDkRnDvtHN+fX/qVlc7dKaSYIKQksnHBn21xC9MZdrF7XQNKffPIAumADwdOyAYT/2FxMTXCwSplfTmNb0xSwBxyoMFQLbUziQvh
 hXsK/DeZ
 w2GWblzKinnE3qc3pEfEFMHvP1HofVquNQ0omwZZHkbbvb6qaMw4erJ8Fq2JsQjIyZk0Ev2ypHqwJcz3KbKkQr2JBsvU3mJEGclg2zqiVSYbljo00Bd5izR6BkqMnjcwGlucMyFRaVGglhZyFrudLoB3WsWTVK4PIwdFOASdpyjderiNGnF9Wv9rH8YvOrLAITMc/RrFVA6itqgPtN2Ke+m1T16KHj5IKx63RIAsXkvxTd6DeCBZwaFIFN3P3QSp30Z+TL1kkc0PfvSFt2c5gioKNI2+RlUCivucd+ez8s+PwDjNQwOjlcrhVnjQLq2TsPPgnoLOzY67JYjJU3HP8h9dpD9R9s36xM1iax3KFru3NhO6jXeztQ9E9yd2k8dD+3aFgQ/7yYnk1IuX74RrsX+nf4eSY6J1qe6zhyaH3kvit8a8N6/qOU7Q/oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 12:12=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 30 Mar 2026 11:59:04 -0700 "Kanchana P. Sridhar" <kanchanapsridha=
r2026@gmail.com> wrote:
>
> > On Mon, Mar 30, 2026 at 11:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > On Mon, Mar 30, 2026 at 11:51=E2=80=AFAM Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Mon, 30 Mar 2026 11:32:07 -0700 Yosry Ahmed <yosry@kernel.org> w=
rote:
> > > >
> > > > > The patch looks good to me, feel free to add:
> > > > >
> > > > > Acked-by: Yosry Ahmed <yosry@kernel.org>
> > > >
> > > > Thanks.
> > > >
> > > > > That being said, it might be a good idea to resend the patches (n=
ew
> > > > > version for rebase + Ack?) to get Sashiko to take a look,
> > > >
> > > > Yes please.
> > > >
> > > > > hopefully it will be able to apply/review the patches this time.
> > > >
> > > > I expect so, but I don't understand why Sashiko is having trouble w=
ith
> > > > this.
> > >
> > > I think it was a transient failure.
> >
> > Thanks Yosry and Andrew! Although, when I get the latest mm-unstable,
> > it already has the v2 patches :)
> > Should I still send a v3, with just the Acked-by added to patch 2?
>
> Yes please.  Just to retry the Sashiko scan.

Sashiko tries to apply on mm-unstable, mm-new, mm-unstable, and
linux-next. So the patches need to apply to one of these branches.

