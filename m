Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F44CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 19:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E8C8E0002; Fri, 12 Sep 2025 15:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF666B0006; Fri, 12 Sep 2025 15:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADFD8E0002; Fri, 12 Sep 2025 15:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8566B0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:38:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64FE5160909
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:38:15 +0000 (UTC)
X-FDA: 83881609350.04.5194A54
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 87EDE180005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:38:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PkMu76b3;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757705893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxKLJXAozeMmWAPKUjfUsQIDjzwB9fwUvrZiHvNyBbo=;
	b=iymz4hFRptfouRZ3PAliNrF3DyS5kWWLjkzBbJ/oAFZidX1af2crgiBZKPY15d1AxiPX0c
	EOPP/9B07gz/cJnaGrqOzLiKDlpOldopKZlG5hKSdPM+akrb9Z0UkPN6lK43VcE5get5NZ
	Tkg9uKYalo4pWBNPPK6jB8YB0vd+HOs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PkMu76b3;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757705893; a=rsa-sha256;
	cv=none;
	b=Kpb3+fr0v0nM7By5azlQbmC7fKuAlYLxD/l4NwmkZyMY5665Q9mGK31wpwTDsjEzAv1+ea
	HcLDMrSyOlPtAOpO9aJwVKWFvIoxAli8rBAXO4xnCCt1D4XOCKg/y2uj/VGLqnAmUQHOnA
	F6gZpXj1gmITw/c0pqh+vBoZjfEfA6E=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b4bcb9638aso5241cf.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757705892; x=1758310692; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hxKLJXAozeMmWAPKUjfUsQIDjzwB9fwUvrZiHvNyBbo=;
        b=PkMu76b3squvlRfhnkJYQhM4aa7LIZtW6KhGlrhDP42j7twSseSXdzpp5UmmO99DTg
         6ZSIM10BMG/nR9eTSdkQSqqyAqZTmlzwjep4cuYtQWe2K/0pLOLGIXedpkwyfVWcMCUk
         vsrSw5Pw+ibI3qHc9mRyBtO+WZhgwYQWip6bh0GorOpMcytZZ9BXzYDJIaOJTu1tVhqN
         4PI10poavCLmuA3C6MfZEiz8QvzjPWGO9yRE/KWsotfQomOH3ElK9jbWetpY6e2B0rvr
         VcQlYpSPtBorbpQmKbtNg1sF+QZ6APq+RVMu1bhnYXm0A4Z2Bdv4yIhLEKZGkwj7K92I
         aDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757705892; x=1758310692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hxKLJXAozeMmWAPKUjfUsQIDjzwB9fwUvrZiHvNyBbo=;
        b=Kx3qm37GRfgndZ2fMErZ7epOBHhctirt8x33boWbRP045ABlowAld9UqN5VRUKfWDm
         v/DQdZeT0Zf6Ln069wZFGHy1YGhEugVlZoRDOBl5NW06PA49OO37CmSgDZasahLtIVvM
         NFNmutclKs7m6UhXEsk4W+jY8vdGBSyFA/xVHLSw8uUmfjy/OqFPOnPWzYJINUlNWHfq
         say06cWu5c+TfmPFDbyGm1ThBq4mqhf5EN3nSOoJqjMBLC7BuolFSi3/SkAs/MHYCXRd
         F+EdzDT40z3NphdsEzQhJggUVgvkieOSh1JwfDKhUBDjjw9RzhHZVvAXm3pI/2am+b/z
         KwzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL2eog8gaaD+S4ENwH9Cauy9vt4X9X+ABWtHcQUmD2aJQKFYSYbbf5EHKQrrljOUnpQ7LSn8Vx4w==@kvack.org
X-Gm-Message-State: AOJu0YwJbj7Cv7KB4gH00Chyqt1na0ImPSZsOgrrbhCvjMvCGOdY3vyj
	ueZc48qmLZ8T4l0YaV2xCqnYHcyYKgdbcO2r5Q+JYnSSdvaWxt06n6cFdJMzdDShd1vMptEAcl1
	gEX2+uilOr6+oysfEwnws6DvL1MixLfdOGoBvdLJ+
X-Gm-Gg: ASbGncu2rsSosrStIWbUWO1QuzvQknOcZKa73XkvCQXRfTOZW9erXJTSiuXpo3djYq9
	ac3Rnnv++6JEgtZ6VNQKzlK5EWcPyqzliRxjQ/VTTfdYsSNKOtuF7NtHk1n18f3Pu31syVOKFmt
	aKyZzNVVoJB11iH/J4Zqnx+OSUwMw6p+vrLyohr3UlD+QOh3mRVBmIatp8+ovX094/4N9+rKpro
	UcctXJoEcJBCfiphpeOssg=
X-Google-Smtp-Source: AGHT+IFmFvmuMn+gst9JeecVjoOqDASQ8FiGmAOvs5QtdO3E6xy+fy2CjLC5X+Z4o1NPGM2DESnpaITFOKT0WwBaSWY=
X-Received: by 2002:a05:622a:1a08:b0:4b1:22f0:8016 with SMTP id
 d75a77b69052e-4b78b78b205mr803781cf.2.1757705892211; Fri, 12 Sep 2025
 12:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250909234942.1104356-1-surenb@google.com> <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com> <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
 <CAJuCfpEoWtgv8k4vApkGsNNUYFBnvS-N2DPQu2JrreCUPbT5dA@mail.gmail.com> <aMP7g7ts8n2Gubql@devbig569.cln6.facebook.com>
In-Reply-To: <aMP7g7ts8n2Gubql@devbig569.cln6.facebook.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Sep 2025 12:38:01 -0700
X-Gm-Features: AS18NWD6AauY0FbZgSwcBpoAh8LOEeedT2LpwLIFm0sZjdQgHEGT9i9EDpb1gFY
Message-ID: <CAJuCfpEy7kQdDzU9GR6T=nz7HB6EnSkfx3vXmTBEuvJPqhxyfQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usamaarif642@gmail.com>, 
	David Wang <00107082@163.com>, kent.overstreet@linux.dev, vbabka@suse.cz, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 87EDE180005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5crdif33g5dhggeex6tw7e1rfd6sjman
X-HE-Tag: 1757705893-760253
X-HE-Meta: U2FsdGVkX1+8SKnzdrEzM/qWqdM2eWPChxkyrELeHsbrOxeCkkpS15c1ekMj5SP+syNml3ajCY0ixMhG7Ua01vfwo32ezmlmFlr9gz9AOIVXFBS6zHb9Npj/duTwQh2cTOMnBgP3jTIjRptsIdLztfPynCg9CpY+mw96h0RdNVDz8Y/AYCYXFXPnZx4ZCGIYVG7Y+hEjAQQU4wF9gNEnQkC+F9y1SXa9UYTPT09wipM4h+yrEPWEMoww8/fFxJWTVJNI8H9XESjsTyxTml1fE/jUvhAC04rQgvsqPlSTbwjZ0s5po/1ABkpR0tgoZBRg/m3N039XEXuEL+7GSqtClP9qo7xKt+LN8zTAv8IfFG/jmYAUuybXVtlaz5rIGA1V2dmLmrZqosewyGNrNl/+xSLL/xz8MsFNc2VUpeAo+4CkljcIYdV1+4AhDERTB3y7U/lczVQZx8nTdTb641dAkzVlcO/ap+ZOLajLoGjQEaDTHBYUP3G7lzQ/jKdqIUFJ1KWN18+V+YV/wwp2GeiTHYrmkVkCLUDU2d0UKc07km6OPUUYv5c8zigp8LWk9Nl24tu4LOUiIh0krIZwBQa0Tj7i3BMPdUOLdq79+PwakVmWgjM6AT0qN3ur911qjIoCAnNhKh4aI/fClCrzWTQTG5lAOeFkVcwuSN3J+HCYiyJRieVYzlhIU8L3Mdexdh7XZXB3zTwlKsQmIBTmpNBCBca9/HObpsW9SSkDxxtN2XIgGg51AtP+7OJlyAvIn5lZIT3Ofssk3J8V+1/LuowkS+HDX0vVJuRtdUgTtBf9KYLMKfGrqtNrBudgXGN/3VE/1yzrrn68fhbewpLoFc2EJtuPodTjqCEw/9mXMyvd6UqGjfQZuyqYsBYfMqpOErw9Yyr8Tt/cwWYEBK8H0j63+eW9mqJhn/TylL6m0BO7RPP/bitXSuyQc987ZeTX9yWYu/LuvVYpDfdZ9zrA29G
 WY01BaDd
 l5AySTq2w9LY1/LQww7aExu+K4YMmjA28tIUw1wu1bkhehX0rMSHxROdAfFKqOUzHxUs2Lip4SiL2iBjSKm6YJeCBGRz0cFl1LBC2kWVx/IG/JxprrJxa9ZzSHzS6PN4Zk2EXNJy8x6yViwibzMUymEa+z/budUTEtH+Bf+FWbl78NnKxTfG7ACUKUNuO9iILLrRiJvQGQrA32s3va8a65zDrQjV/mrBjwVyHQQol7uol+8XjPb84fvFGL7zcuzEbXoOvytibFVJ6i38CPd3zwwfAJIhJvw641PULwHfw3G0u1tpUf706Zo5FetybQbNwaUk8XjNw0IRD3m8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 3:52=E2=80=AFAM Yueyang Pan <pyyjason@gmail.com> wr=
ote:
>
> On Thu, Sep 11, 2025 at 05:25:12PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Sep 11, 2025 at 2:31=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >
> > > On Thu, 11 Sep 2025 12:00:23 -0400 Usama Arif <usamaarif642@gmail.com=
> wrote:
> > >
> > > > > I think simply adding * to the end of function name or filename i=
s sufficient
> > > > > as they are already str.
> > > > >
> > > >
> > > > Instead of:
> > > >
> > > > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device=
_create
> > > >
> > > > Could we do something like:
> > > >
> > > > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_c=
reate(inaccurate)
> > >
> > > Can we add another row, saying "the previous row was inaccurate"?  I
> > > guess that would break parsers also.
> > >
> > >
> > >
> > > I don't know if this was by design, but the present format does provi=
de
> > > extensibility.  It is basically
> > >
> > >         NNNN NNN name:value name:value
> > >
> > > one could arguably append a third name:value and hope that authors of
> > > existing parsers figured this out.
> >
> > Actually that sounds like the best idea so far. Currently the format is=
:
> >
> > <bytes> <count> <file>:<line> [<module>] func:<function>
> >
> > We can adopt a rule that after this, the line can contain additional
> > key:value pairs. In that case for inaccurate lines we can add:
> >
> > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709
> > func:mce_device_create accurate:no
> >
> > In the future we can append more key:value pairs if we need them.
> > Parsers which don't know how to parse a new key can simply ignore
> > them.
> >
> > Does that sound good to everyone?
>
> Yeah I agree on this proposal. We can keep this convention.

Ok, if no further objections I'll post the next version and will
document that v2 allows additional key:value pairs in each line.
Thanks,
Suren.

>
> >
> > >
> > >
> > > Whatev.  I'll drop this version from mm.git.

