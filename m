Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA45CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B238E000C; Tue, 21 Oct 2025 13:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E29C8E0002; Tue, 21 Oct 2025 13:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8788E000C; Tue, 21 Oct 2025 13:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1980F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:40:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C13B11A056C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:40:30 +0000 (UTC)
X-FDA: 84022835820.29.768B0EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5196AC0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:40:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZPkS8vdn;
	spf=pass (imf10.hostedemail.com: domain of acarmina@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=acarmina@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761068428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6mtgo3pPCytVhVXZFHBeLsifkDHzSLEpkyjN1cf7zc=;
	b=t194l0XqFNGgwVQLvDHuNSBcps7gmMEBfn6SNQNmDE/1zjv72kYZ8UaSUX5bx/fb7cdnHS
	mRxDv5wGfIP38D1//dptDRLvXNP5kQHFBCDz4lL6E20qOqBcFAkUWkpilCfdoOOUZZc+s4
	ouXJ0b3fVbj0u/g/W+suRgoqB51Wdkc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZPkS8vdn;
	spf=pass (imf10.hostedemail.com: domain of acarmina@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=acarmina@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761068428; a=rsa-sha256;
	cv=none;
	b=HTL/GMbeYA5sQiNuNeoPxKfV44sSjrMuXCDSqqJ5KtJaf8DaTs/42tQ5+Orex8TyvMbiBK
	VzfiXumBzXrd4HhmYXd+fI/zmrDapuRXWK95kWIT1nVjnuyIBB4/KavPMDBIOAqWqo8eDK
	pjBX3w8emzzbDBLz/vZjugB1Aq/77+4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761068427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6mtgo3pPCytVhVXZFHBeLsifkDHzSLEpkyjN1cf7zc=;
	b=ZPkS8vdn9YXYHMFl5jsP/6e/FNrCEv2cFoumPD9pODoU8wG7PoScVGmDLIP1mUDoeUdi56
	WjDFObW2KNpEJlf9o+FLmAU5yI2Ueb8zpSVDeDD1dpgtxB0P/NvYGrwoVRT3EH14ZkD1eU
	RetPzCYU4yXNugxEQ/xSyg/Y/GHAcQg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-JZ_xVBkhM_WM_M8IrmXmPw-1; Tue, 21 Oct 2025 13:40:21 -0400
X-MC-Unique: JZ_xVBkhM_WM_M8IrmXmPw-1
X-Mimecast-MFC-AGG-ID: JZ_xVBkhM_WM_M8IrmXmPw_1761068420
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-27ee41e062cso74897725ad.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761068420; x=1761673220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X6mtgo3pPCytVhVXZFHBeLsifkDHzSLEpkyjN1cf7zc=;
        b=bWWuGYRbqo8TTWMMqIsZQHqA6bWMithfmmFuZm2PiuiTtoyOO6ke4+naVB1neUOvzC
         r9IOVacqc3uvkdbH0e2uUI6knFLMu6WRGqUdrWRkIxrXdqHdUyLYXkiagTc7VDGLIfyZ
         xyHgrUN5Ux249xBfUzpjqt3wd+roI0Ij7vKTVjCcX8w+pU46ACIa2sMpQAIu71L0dnDz
         H0DRIaLvytnhpexwTqKb2pZY4QS2+R5ufS9CtQh0q/Tqi88bWMbBUfYZMP7qwbjJigvT
         nSIm5j+gzyKudZwPOTNxdBzNqvqQQ0T9FKJnT4OSERDkKCI6FNGF/SyivDvq9LHoBdGb
         ZiOw==
X-Forwarded-Encrypted: i=1; AJvYcCUj4SVYff9xIHJx37GAVdZqIkU+6C2eUBm9p40x4calbYSoFeVh2dFrOc0Oj7jT82fzU8yL0vqiLg==@kvack.org
X-Gm-Message-State: AOJu0Yy5rYeemhkeGJBSW6CmKEwIj7Nfx2/kXHduAKxSm6IteLw6beBl
	rjx0VJfRoZl0RpGPUisrcrnYJFjSh3fvf3SrlSfFTkBYn/idQww1DojeNiUPY+z28/13QWTJJDd
	4D8rW+LCY6ZODeNStXx3KfwcG67l2N3gT/KjphcEZHY7y2flWQrDZRH7uOu2SR7aBd+Mo3pUUws
	GZk+0z/zKLb7SO1S08k89vxilq1Qc=
X-Gm-Gg: ASbGncsUWJkPSR4s4ezDeaE54AR8aDvIKfhpw+fdruUyJXwMuViLUYkWIcFaTvhTFwc
	cyV84Ns73/A+OOl5xqOjAxSWECYzC6wWyjy+ryGnbn0a5gXDMqNGSkBYGc7l5wWv0daAoRtJu4p
	OVOrTD4LojWwSlqZDd1OqDMjWLXgzVlnAJ9JR7YWMv4AEuhz96sBNK/w==
X-Received: by 2002:a17:903:2445:b0:25c:25f1:542d with SMTP id d9443c01a7336-290ca1219e1mr241861705ad.36.1761068419830;
        Tue, 21 Oct 2025 10:40:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNBRXbNnmPSpLYEnXFkENFI/1M+gqvKIYCVJm9fI2lS0fXYAVI+gy+WgMJVWOy3YBjG5e8is9uJ+k/OC1HrY0=
X-Received: by 2002:a17:903:2445:b0:25c:25f1:542d with SMTP id
 d9443c01a7336-290ca1219e1mr241861165ad.36.1761068419241; Tue, 21 Oct 2025
 10:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <20250910170000.6475-4-gpaoloni@redhat.com>
 <2025102151-distill-operate-a748@gregkh>
In-Reply-To: <2025102151-distill-operate-a748@gregkh>
From: Alessandro Carminati <acarmina@redhat.com>
Date: Tue, 21 Oct 2025 19:40:07 +0200
X-Gm-Features: AS18NWBEOONK7dBiVq2lvIZx05dnm_RrfOSuk8LGx_c67bshALzcxq1srb2jgM8
Message-ID: <CAGegRW7qKAPre7EAh8JLkUuA4Wi0-cKs7q3_qxHAE0nJs6VHEw@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 3/3] selftests/devmem: initial testset
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Gabriele Paoloni <gpaoloni@redhat.com>, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, safety-architecture@lists.elisa.tech, 
	kstewart@linuxfoundation.org, chuckwolber@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y8eVuIG2ADqwCKsG_sHT1NdnI7GRcise0D9Y-4f5OGc_1761068420
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t7oi6o5keoi7wjyob6hzshafc67b58p7
X-Rspamd-Queue-Id: 5196AC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761068428-24882
X-HE-Meta: U2FsdGVkX1/IjuGVmgJbCN+uKMIs4OGZ8A06czNMIfPMOVAmBKgopdVQRwqopKlYM7Ohkjue3XfrkpWAp+sVUbEZLJ8do072OMfVMlnPXzj2LNtAQs6jydHcM6mn13XVwGh3Bb9/tOzSdtsJGuLtQqAL3m8L9WsnB+e9jpPhIj0MfrDGuzu1YDDYQVlhlqSsvLEiEFHkCDznts3fMld6PU6E9veWlEMFTG8x8f3Nfbt6amzMmbwuG7mCsyx39NOWamuhCOXRbL69y5V2tnar0eE2x0+e8wa+F7/4NdIvdYD/+D8IkRiSmwn8K8OAQdtd+GmPpkhwA2/IMcCUi2qxExY2HnUxVWGep2RkxgK0gAuCJjC0GqAocVhQ6aklTP/EgYlUz40dNfPNFIEh/17ZjgnpjfdHMbfLJiT0ujdA8HPCVTsqBf5BVt1PNMHEq9aJpf/TsCtg5XTUo62MXdzSHfP/vMO06rULZTdJ+QmFCR/CqJaO4B3I1N6oNk9AmkJGE9fuvDLnDBY+0o7FilPAeUJ8WumLnY7F6ZezNl3CE9QIgXzWO/5L7NTWxGt2Kvu0viF/rjlU8Xk6wjUKSgSKGwRePvZUPbROvehc4i8/0ORAZejgieojsZjzvqns5xQIcVVc1+4/oGUtgPgwZ6V3ZU2e37vTMgXwueETLVfa2LJr7RrYE6L+eO8Ae+yFwQ4kOm08pN8t+ti5uzyVDl8xEAESqrqeUFnsALaYocJ1Q7YO40FJyLYgpiN+oQ67YS6/fyYg5s4wBCzzIdLnJFMyuNeWqJIf5kEmORLLVBIda2MCT2rzjGCqlZYQ3OQ5+vPY3HcaEetHkC0Zx5PFkT8UHUM4gm0W/paDukeYc3rAU2DUfdk67fSjtwRSh4BDVgDyaOhwJusAkNvS1kWMSZrngkYjSM/F4aYLyV8yQzX4rNI1udn8ssN70zuw8JKcgNB2l2PlQlQOf/L6r0ROZZd
 M8NNf5GJ
 e5JuVrL2GGadu67lkAhi0WxZBZrXxPZVD7y1GitLmufLaqEGx//LDDDTzlPEEh3dxCOin6F97kcHSRyVNPBgIhryMBb4ybktHcK+XMG1zipdHdR2M8IZVdG3lkjS4rPiV7I13IEwQZNUwblVIdGyV04ZQdJaoF/cx7t1NrEu5Qcwc2p0WbaHdXlFueKC+u0Lxuunh/SawYKdPZ3rgUUCVPTN97pplU4u+eeXLdq2h9hTJy9CZI48NjFfBJVMaSu+VCBpKQkGyudFnNJKjBBB/V4us0Ywe2EB+JLq+e8WwmAxULn17uorkBdCUwNMCQlX2qNeSN3GFry4DV6oQB2QfLL9Q5dBJ50Wxao42JX0Me3eK8qw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg,

On Tue, Oct 21, 2025 at 9:41=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Wed, Sep 10, 2025 at 07:00:00PM +0200, Gabriele Paoloni wrote:
> > From: Alessandro Carminati <acarmina@redhat.com>
> >
> > This patch introduces a new series of tests for devmem.
> > Test cases are mapped against the tested Function's expectations
> > defined in /drivers/char/mem.c.
>
> Cool, but:
>
> >
> > Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
> > ---
> >  tools/testing/selftests/Makefile         |   1 +
> >  tools/testing/selftests/devmem/Makefile  |  13 +
> >  tools/testing/selftests/devmem/debug.c   |  25 +
> >  tools/testing/selftests/devmem/debug.h   |  14 +
> >  tools/testing/selftests/devmem/devmem.c  | 200 ++++++++
> >  tools/testing/selftests/devmem/ram_map.c | 250 ++++++++++
> >  tools/testing/selftests/devmem/ram_map.h |  38 ++
> >  tools/testing/selftests/devmem/secret.c  |  46 ++
> >  tools/testing/selftests/devmem/secret.h  |  13 +
> >  tools/testing/selftests/devmem/tests.c   | 569 +++++++++++++++++++++++
> >  tools/testing/selftests/devmem/tests.h   |  45 ++
> >  tools/testing/selftests/devmem/utils.c   | 379 +++++++++++++++
> >  tools/testing/selftests/devmem/utils.h   | 119 +++++
>
> That's a lot of files for a "simple" test.  Doesn't LTP have tests for
> this api already?  Why not use that here instead?
Indeed, at first glance the test may look simple.
However, despite the high-level concept being straightforward, there
are several corner cases and peculiar aspects that needed to be
covered, that=E2=80=99s why the test grew larger than expected.
For this RFC, my intent was mainly to share the full picture of what I
had in mind.
I fully agree that it can be refined and streamlined in the next iterations=
.
When I started working on this, I wasn=E2=80=99t aware of any existing LTP
tests for this interface.
After your comment, I double-checked, but I couldn=E2=80=99t find any relev=
ant coverage.
As far as I can tell, neither LTP nor the upstream kernel selftests
(kselftest or KUnit) currently include tests specifically targeting
/dev/mem.

>
> Also, this is userspace testing, not kunit testing, right, is that
> intentional?  You are documenting internal apis and then writing
> userspace tests for those apis, which feels a bit odd.
Yes, that=E2=80=99s intentional.
The main reason is that all the interactions happen from userspace,
and the internal helper functions aren=E2=80=99t meant to be consumed by ot=
her
kernel components.
So I chose a kselftest-style approach.
That said, this is still an RFC, I=E2=80=99m happy to adapt it based on
community feedback and direction.

>
> Also /dev/mem should not be used on "modern" systems, so how was this
> tested?
That=E2=80=99s indeed one of the nuances I mentioned earlier.
Access to /dev/mem is often restricted for security reasons, so the
test is designed to detect and adapt to the environment, only
performing operations that are actually allowed.
>
> > +// SPDX-License-Identifier: GPL-2.0+
>
> Are you _sure_ you want GPLv2+?  I have to ask, sorry.
Yes, I used GPLv2+ deliberately, but I=E2=80=99m open to changing it if the
consensus is that GPLv2-only is more appropriate here.

>
> > +/*
> > + * devmem test debug.c
> > + *
> > + * Copyright (C) 2025 Red Hat, Inc. All Rights Reserved.
> > + * Written by Alessandro Carminati (acarmina@redhat.com)
> > + */
> > +
> > +#include <stdio.h>
> > +#include <stdarg.h>
> > +
> > +#define DEBUG_FLAG 0
> > +int pdebug =3D DEBUG_FLAG;
>
> That's a funny define that is never used elsewhere.  I'm guessing this
> was cut/pasted from some other userspace code somewhere?
It wasn=E2=80=99t copied, but I agree it looks unnecessary in its current f=
orm.
I can remove or rework it in the next version.
>
> > +
> > +void deb_printf(const char *fmt, ...)
>
> Who is "deb"?  You have more letters, always use them :)
>
> Also, why debugging for just this one set of tests?  Don't kselftests
> already have debugging logic?  if not, why is this unique to require it?
>
> And am I missing something, or does this new tool not tie into the
> kselftest framework properly?  I see lots of printing to output, but not
> in the proper test framework format, am I just missing that somewhere?
You=E2=80=99re right, this was a small custom debug I left in place, mainly
because I needed a way to include additional information that isn=E2=80=99t
normally part of the standard selftest output, such as references to
specific requirements in the code.
My intent was to make it easier to correlate test results with those
requirements.
That said, I fully agree that the implementation isn=E2=80=99t aligned with
the kselftest framework style, and I=E2=80=99ll look into integrating this
need in a more standardized and consistent way in the next iteration.

>
> thanks,
>
> greg k-h
>
Thanks a lot for the detailed feedback, it=E2=80=99s very helpful.
I=E2=80=99ll revise the test accordingly for the next round.

Best regards,
Alessandro


--
---
172


