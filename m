Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712D8CA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7ABD8E000E; Fri, 29 Aug 2025 06:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BBD8E0001; Fri, 29 Aug 2025 06:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41A28E000E; Fri, 29 Aug 2025 06:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D95E8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:56:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54C0C13A657
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:56:58 +0000 (UTC)
X-FDA: 83829492516.23.4AD1A09
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 76910160007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:56:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=CYxU0wcc;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756465016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6MPSbkVIlc+V387DVzsSzTxYHOue4NoSXRJwOKRRC4=;
	b=HJUv5EpYjrkcOHGjc01BvdT3kFdVsocdjO0zUM6/J2qpP0906nE/fjrfTymhkuyOrxWd80
	s/bKSfaAgYiZTLPBAF4N5TF91M66sd+YRSi2F2oXwOQ4MFyCQIGsVK19HcnZ8pvmsiIA3r
	iwhstvXkNImDCyrcHm4b8A193IbtLNk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=CYxU0wcc;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756465016; a=rsa-sha256;
	cv=none;
	b=aNQ4s5o7n08W1Oztbc++9XW/6ckh7uxxNO0KE9WNO5dhudUGzjzDgqQK8BSBDYPzv7fw7e
	b8qPQvAikogljXRy4vxmAgSIL2TunyVLGz48tZetiRNkvSmBKtWGOZeaWzV5P7mLIh1bB5
	8N/2/y6iLIyVvlcJKGJPg8Y8GMw5BZs=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-327ae052173so1093307a91.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1756465015; x=1757069815; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6MPSbkVIlc+V387DVzsSzTxYHOue4NoSXRJwOKRRC4=;
        b=CYxU0wccHwXIc30TF67Idlrb0ndDArAMg7C9qVYBDf7tTU4v8OlR0UOkUIn7npfyh1
         trUcGTR/ehz3lkPv+/Zl+0AAXXYnsTVEAKbNeizBZO6RmnK3Cag+6ODQh16LFtLfzBMK
         C9XPVIePzvnDinjkNxOXjKnBoxByhg/uaVoz3dAuRT0ar9YN0S4RSR5axd8646szf8rr
         tfS3axwT+e2/+XFXTw/U7+Vg6HE6dv5P9JFNG6hYK6f+Ma14SVknc7fXBfZ0tscojvrW
         Hc1cqxI6Lqh9bgZK78psd9cmnld/T9TFVFyI/gIr4II6D8fsy3CKN1Fzl+u1X45VT3oO
         ySGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756465015; x=1757069815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6MPSbkVIlc+V387DVzsSzTxYHOue4NoSXRJwOKRRC4=;
        b=NRAHRBhrn4IkTfLLivkSixfg1c/TXaQoT3orSzQebSSDNX4OuOoXRYsghQS5ICGL2d
         ep8fekmilYqSbIFhT9RHCyqUkfrxtldJh7JsXvZv7UI72Th4UvXXJ6oAIxiH8UyTBnS/
         FlwycloeUuzUrz8NjFM32nc98lqhW77J9EAfF+3JWd7H2CgECSvpe9h2t7KT34QGPT2I
         ybgon10gc5InW9niN+ektb7cdxDhIjXptl92fyKxnz4/4v5Fczz4bEdcAftIVxpiUx/6
         iXgNokvOQAk8jHHaDE580ztwqskncz2p6ZB2xJbMxmO5YNcDItTc+qAOwA3LdHG9S0i1
         GMdw==
X-Forwarded-Encrypted: i=1; AJvYcCVQHacEGBf9WOSQNYOGd8M7H+2bPnzO8ZAOSuX7sH2MicXSutRi1Q9WIG2gNfw+o9h0Th6TzCC0GA==@kvack.org
X-Gm-Message-State: AOJu0YzI/TAMG2pRgnnpukWWqlqqyhivK4mNP5Ex56cSFOPAGJbNt5R3
	c4xoIqqpjZEReN+JcW6mLyTZt2rr/ilEdmsjahI2zINdonyHLowNW8BC70007o3agFyGIuTcB2G
	A/kQLZPpG03ZA3lYnwfqoXQQgDs54X/tw5a2UorO6
X-Gm-Gg: ASbGncu0rfcZfKe8rYlsdinT0Q6piYnLXnir6ZKyjIyUEZhau7gLh49yo3RfGiyyZbN
	68RQXDlcSKKtczZiHU35uvs8lDNYxA2kcvWp5zA3FxXDYKUfqpPvOM5gX1+BiuB8OMMds/yImLD
	udjiZeFYj2HCbY9A4kybyG+InDa4Vu2eXQVu8WTQKhRWn1sHV6TYixNmD83Jaa21vuf1Hy09VCg
	8GqDhtbort1awFza9Q=
X-Google-Smtp-Source: AGHT+IGDPrqU3qCXUsbx1z+D7spAudal7m6VvB/YAbl6Q44JNBA1bTqtvYkoa8fRk6dewuZp4Ua7WUer9nRt/kc21go=
X-Received: by 2002:a17:90b:2f87:b0:31f:8723:d128 with SMTP id
 98e67ed59e1d1-32517b2db8fmr34283941a91.34.1756465015189; Fri, 29 Aug 2025
 03:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250826031824.1227551-1-tweek@google.com> <CAEjxPJ6G2iK9Yp8eCwbwHQfF1J3WBEVU42kAMQHNuuC_H5QHNw@mail.gmail.com>
 <CAEjxPJ70O5SY=XYJKrQDLkHOO3spD4VSjYCv0LkhYKCvK=GP7Q@mail.gmail.com>
In-Reply-To: <CAEjxPJ70O5SY=XYJKrQDLkHOO3spD4VSjYCv0LkhYKCvK=GP7Q@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 29 Aug 2025 06:56:43 -0400
X-Gm-Features: Ac12FXwA4RT9c8sFjxx8AgkdJv47bPShawvWIx_UbmmXOiQU9WoRBN8gx-RGKJY
Message-ID: <CAHC9VhSkBSyHRRimb0Br9nJD02ZN_wgDY1A7uWuMh9rXhFSuzg@mail.gmail.com>
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	James Morris <jmorris@namei.org>, Hugh Dickins <hughd@google.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 76910160007
X-Rspam-User: 
X-Stat-Signature: 6irgmspqg81mizgobafwkdbueqgje1ro
X-Rspamd-Server: rspam09
X-HE-Tag: 1756465016-229985
X-HE-Meta: U2FsdGVkX189TdW5anGPctRhgnOkrwOC9dsMw170cFM6PZCAKvv427Dsb/iQ6xU7qqqRyiG7ZlYjgjaVQmMW9aPxkhIZQLBqncTWmROz4TD+LuAUqQRMWlZ/EPXL3lceDJ/iuRXeVlG5lJRYZs4tM5zSoVnN+7JgmiiCLoQOVHjHC+9nCcc4IXjZE/EIBOFyIH+AwoKTwFvwnbPfa6Y0jitBOghAkKhEuonS36MMJx+ORDu3zh9/nx7DPNN9//JUQHced/VdPizFPegRDzdtLrsnDH94o4oPhRhbqBZtpWiiC1nZ6kAJFBZXUezi9E8ZXh5jlY5LLXG23eVIB52K32SvgOHe+SriWw4V8rMLoO+7B/pC+1634pOknnFWQlHhbxYck0nn6cDEGBqHP4dCNl1b8S4vCrVCqfYMfuM7nD9oqmDwNUoRE4z8Pv0s01C3uPD8PcgwaXI7GxAWg2D4TkyjU/ke7lY/BbZJFVYp+GyvY7ZBsCAqxzD9F1T5GSubxwYoXhDHxraItWAZJlzwGzIcgFIqlc4MMHvYMQgiEoWornht/X2+v/XQOUBIbMwkaDbAY3qVzTG3p4YHRB/dxVytug3E41vU+yNVI8xFZ4WdBoDI1VJ8zVQx2U+mnEitqqprFnoD6oC+4o4kG9IwuIlspcswYsfA9sPJvj7h+JPx+BgguuES2zOWNu6X/OGopNaLXDgNrncUQ3LG8LCv8Fq5VyNFyX0y6MnzqJVzwatEWZqLrwwlzTK7YGnESHt6MuMbSWPgx1h2yMooGbjWVrfyqHUn0ASej1NQjyqrdG5jWoeLHBW9d0gcr1wU4b6HwJD6XZ529xYwBCHQ5LwebxUQ+rY9DVHKTK4X2+dUlZjjuiqMw2f8PmjizAtEq7+/RgPMkQko1euIHdRV+Xpol3X3KkKjkt48BsI3sk1J2/crQbRnCpzQIW/CklPVsXxgQ0sVQeEYH2QQJmHFaER
 xPB6AWCk
 7zpyqEJnTvJKDKOGYbRTS1WJXxshf+5AKHeyGYzG1WyQ2qFkIMssZCnHT9tTJdxI9z/f7yEM0zRA2O/WAm0d8oIw3MnbBFbki29RBf7o7WY+iL2G5+H1j1WKRg5PGAcSC6h27EQra/Rm1IjCACnlQnS/thHH4lyyoR0JC3kEgnsYkbWJ79BfMc54g77IhcLxr4vdAGxOxcuex7luxV+aG+Kc8H/Vzc414O5AcKNE0x4jqLiGABdYlPAwFXP6Vl0lDlmwMvIxmZMbMmiiltDDwLiL2qqxrA/V0yCXt2a95+4j/DkFTJL1uQWP0b/DB+y4bM8ZRYh0+oB4fnVXH8igra+l/feLxv/SCyxlI9Aplapx3ykBZcq/kP5Vja65guOD+aj1Hm559FQh0peFWiB/8BX0wQU7ctBWxMZbShprYNXpLvcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 9:30=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Wed, Aug 27, 2025 at 9:23=E2=80=AFAM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> > On Mon, Aug 25, 2025 at 11:18=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@=
google.com> wrote:
> > >
> > > Prior to this change, no security hooks were called at the creation o=
f a
> > > memfd file. It means that, for SELinux as an example, it will receive
> > > the default type of the filesystem that backs the in-memory inode ...
>
> Also, we'll need a corresponding patch to define the new policy
> capability in libsepol, and will need to de-conflict with the other
> pending patches that are also trying to claim the next available
> policy capability bit (so you may end up with a different one
> upstream).

My apologies for the late reply, I have limited network access this
week and haven't yet been able to give this a proper review, but I
expect things to get back to normal next week.  That said, Stephen's
comments about a test suite addition are important, and I would like
to see a test addition before merging this code both to ensure this
works on a wider range of SELinux based systems beyond Android (you
should also test this on something other than Android, e.g. a modern
Fedora system) and to provide a reliable test that we can use to test
for regressions in the future.

As far as the policy capability bit offset is concerned, don't worry
too much about that right now.  Allocated magic numbers like the
policy capability bits are never really fixed until they land in an
upstream tree (technically not until they land in a proper tagged
release from Linus); if/when a patch is merged that requires a new
capability bit I simply assign it the next unused offset at the time
the patch is merged.  Other approaches either end up potentially
creating holes in the capability bitmap (yuck) or creating merge
dependencies between otherwise independent pact{sets} (extra double
yuck).

--=20
paul-moore.com

