Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 481A5CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879F88E0007; Mon, 15 Sep 2025 23:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A7D8E0001; Mon, 15 Sep 2025 23:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719948E0007; Mon, 15 Sep 2025 23:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8F88E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:34:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F19813BC5D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:34:47 +0000 (UTC)
X-FDA: 83893696614.07.613107F
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38E7A1C0004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:34:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ne+Reb6;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMZ5lKmbLJZs0sTmBXRh0OiWyde0GCv4H9+GGRjeQVQ=;
	b=qqEAUMA00pdOVTQT0ab7RK0pXRxMNEcZsK+QprfucdPYRw4eyTnVQg2+JKlYz7MUMdqNMe
	b9KkTWfNmkbZXQWdI7OirE+mqu8KppTthMk/LSFgLvv4VPLdJi9FOoNflO+wgCgHBbYVJM
	GOkSZie5mPaLzosgi09WNga1qviyFHQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ne+Reb6;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993685; a=rsa-sha256;
	cv=none;
	b=fyEgoQ2kIh5cI8H+EhNM/c66W4AkE+hd1zUxfqINBr5gRNiV2vqQHLF5qqcdsLbgi9CjA+
	cKA3cWDro1H7N/XMbESaNSN51vfQV0gllgMLWY90qIcJ1zlyykUxxRKyFcPCRD23HrV2it
	H7ycm+5j0+JJd/VzgGZ3SlMvu2LKhKI=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b79b0eaac0so53231cf.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757993684; x=1758598484; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMZ5lKmbLJZs0sTmBXRh0OiWyde0GCv4H9+GGRjeQVQ=;
        b=1ne+Reb6mODgh5iatFDzYxv5iOoxK2EY56JLjjBK9TlmBq0gG92S0cShe5W/eSB6aU
         8QKsNFxTKZ/oQNsxMu3rngcVlWhng0KUUkM/3OqBuRHN8pS+WyjCjRvowv6EAIWUC1lI
         FbK0IKDw7YvUcr2nJYr0wLGKGQdZ06SXuHLKrVu8jilamORdfV5hHPZHp+bXXDSHCBVq
         8xnqNSdIcEuyLGJYGnUwk5uVTMqcTW1US7dJIqvhSuxVkEPm7R2nCjFltsB+3k80/3Y2
         fwNVo5Qcjr6n3AM6YyNE4qE0vF1Nteg2O7HS1Yt1JkxcHNuajjqFBmV0aDVsLwfoTMJo
         7jYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757993684; x=1758598484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMZ5lKmbLJZs0sTmBXRh0OiWyde0GCv4H9+GGRjeQVQ=;
        b=BoSuR0flY6ugS1HMo5dj5K4FXfonMQJLQ80YBEFWWsdcGcYff44Y103BcD3Roq7Tk8
         Nmykf4RIhyMMD26KQjR5MaFFwNVCOGWtDk45j4/BsL26/SKLM3IFnvN3xlSraJaHYhzM
         GyCxSYY+X6neHiCzd+GtLHhvXeZe/7CmA8+25MjhS7AIie7eI5u9pdWnE03xvxmWCgVK
         W4G48ZTMVjt2KVpUDKE2D7uTjPKHaqauY56ghyt6a5/LohOV4/DAQM1hgy0OQsQaVtkx
         CaG0TPCckEuhaQqcmRd2OzMGliyWx5VmWsZnsRxPt3W6EHi8nTcfsMwwbVrI29qNIDMy
         Kqzw==
X-Forwarded-Encrypted: i=1; AJvYcCXxA6Jr00GHY3j2PPAlfVAaMsDhzmjn0/erl5wVQDUlwjhaEJyVlCYQgljmRKwW1qvIK2eAOdspmQ==@kvack.org
X-Gm-Message-State: AOJu0YyZvFT194hkb/xgKkJvELF11rPdtM2jhJEZLB/Gihvph+cGln2k
	iTp70oUMRp8jVzjFBYrh9RwQh5TwLYjGgAOompmGGRkqmvRyIcSESwceYrbujDXcw4T7BIvV80c
	sUZKIFdvU9KxmUEoH/FeiyP9zxCTmJAFMdYLsIRCV
X-Gm-Gg: ASbGncu1Ypo4/aNveb6r/U31S3JQ2GA+tjjtomLjy9CTd5KlbsYQh9GQoBAyERnedZF
	MEAyLe5+zlCocsIqUxdJh+qTwL/+w1BU3uVLQpwSMGhMB0SStqUkCuRBBfr4n7/3pNHQcZ0u02X
	4Z+3oZgmCmz1n9LPuufd8Hlyf7aWts+t7/luupq62hjiB0FRyFjN4XkXyKRwBbQPvAHLUbPegUl
	eaDbZK7/LjbrfqqVNgPMzY=
X-Google-Smtp-Source: AGHT+IG0tLHQDD8iSbrXw6mju+J9wxXyLa1qHB0bsrF0octifG7vFGZvVIpRvkEgTZsG+dJtW94GZDAeiFWqum8oLZQ=
X-Received: by 2002:a05:622a:1882:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4b7b1cc603emr3746531cf.8.1757993683985; Mon, 15 Sep 2025
 20:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
 <CAJuCfpFQCgQLSrzfVjV+J4tkYbOx_W9v-kWmoo-rmh5hs9gEXA@mail.gmail.com> <20250915195633.96236cecebd8777243a770bc@linux-foundation.org>
In-Reply-To: <20250915195633.96236cecebd8777243a770bc@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 20:34:33 -0700
X-Gm-Features: AS18NWAkqXfW0D9syyeJP9E39KHxrmmhUpYaOE7SM5QDAEH2ZhD9dv2yJcaAuws
Message-ID: <CAJuCfpH1JW8vwOFF2H2SOxZqoJHadXsTc6C=LUS_=twcf=k9qQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p5sed3cyiqq43nz91edqcy48emmsf9xz
X-Rspam-User: 
X-Rspamd-Queue-Id: 38E7A1C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757993685-829244
X-HE-Meta: U2FsdGVkX1+9H0KJP0I9AkMmaZns389diLFE5HCJTLs1jqYH6ehif5wqlqBTHYzmZWHP4xXFmFb8QOLwdllVcMd4o1s0EpZ4lONlSN+RmvN4vkPDdUxJUScCpwmh0j7iZwhcXx1+suvalutJYSxrn5k4BIM6LRbw6j1GHWHZW2W26Zv6F4GMga0zELPGBEouYNkK3g+z9xe63L2w84wR3dbx/PJ6QOo88zQxwSeA9ulO3C7zt4MZ7w2N09Ej8YO4sR5acdIiadewSm/lH2cLs0hIoR3cA68Y3bR+zCx2KDMmi0Z53fGWkXwgOB5lUy9tBFHIwH3o2KC9rYdddPBuwpyeIzwIDblYiUHUbFcV13MJZq4kKaExqZ4NkFdcYaM/KdX3w+pBne3vgY+qL4GLkZRNX4LpcsILPB8PBYuNIX9rLjtJWyzKaomPLA2uOFNf1FrJcFWzy2FZstI+JFNqDz64FSd+gjMGZ1XQCS1i22OJFEhaqdCumUpmdKlNvs56eX7UYVZNtLNeiOrPOtqzD7D7ZYTyZWEO1Kt/4RCjmvrNTa0Jy+cSvqTIty9z8GMgwYy1TWmFmb9FBrEbZrpIyZBrGINl1rcRm2nKKuiAvDDuGjYEUOWDu2JHWda4K6LXqNd34XruIlL1inch8PHIBSGZiHw9YKQW797ImbjNCJhZ7AxiQYagrjM77eG2cP7kAr9XhNvMaMH7O6T1+ijfRTbChPnYLQeGhxjnGR74TvM0tcEqoNKUw34Ukh0tOLaaEui9l6sm0vxLq4OIYIMBcbfHyzDLUzFz0fX16e1uJx76L5z5g8I0KqTGk5TatAN7UpRguhHQNH2fP049X7BQ3/m/G2uHhmMtQ9zvuTRl16yzSallLUKcPlkzX7G3lu1CXFUnUVxT0k1dmGdIWOWO7BvDX5wT74wpK/nh6WgAfYZFPLvphtcRMnBSaO7AwVUwDs65H5/wQjnAaoIZpAE
 rREGz1cU
 fSNRxNJwQBQ6HRwFSiyjOMq6f7AZdW8tsu8mEWS2/KpUYZ/b87EZkvPelVeJaJB9GNNe1GNEOtSa4J3QT9ZsE+0MyoabeBkp8hyVa3gYqi+nnZm4wbRoBBiuv2F+rM8Lve1kbZzUtX3paoz4i+WraYEi5MyLHPQSCdyga+A9AUECYHexVJX+TCtAVXG8tnhvyz0WdtqhsKjQJPgGFI7iQ3TWbUqQlhB2Ec2JxKIC3X7W0ILDuUW0kLCa0MgAn3mGME5tkNX0GXdw/6Fd388FYTnvOK9qr3sAX58BF0CvP9JKrpeddsyV1/f2C03HnwiTgb/6/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 7:56=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 15 Sep 2025 19:48:14 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> >
> > > Perhaps we can tell people what accurate:no actually means.  It is a
> > > rather disturbing thing to see!  How worried should our users be abou=
t
> > > it?
> >
> > Right. How about adding a section like this:
> >
> > Supported markers in v2:
> > accurate:no
> >               Absolute values of the counters in this line are not
> >               accurate because of the failure to allocate storage requi=
red
> >               to track some of the allocations made at this location.
> >               Deltas in these counters are accurate, therefore counters
> >               can be used to track allocation size and count changes.
> >
> >
> > If this looks good,
>
> looks awesome ;)
>
> > could you fold it into the existing patch or
> > should I respin?
>
> A little fixlet would be preferred (by me, at least).

Ok, should I post a fixup patch or you will do that in-place?

