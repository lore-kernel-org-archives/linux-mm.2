Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B7CC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6978E0009; Thu, 28 Aug 2025 23:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86FB8E0001; Thu, 28 Aug 2025 23:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75E78E0009; Thu, 28 Aug 2025 23:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93E848E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:18:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46ED513A23E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:18:11 +0000 (UTC)
X-FDA: 83828336382.04.1FFB0BF
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81F8EC0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:18:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HiQu7fEp;
	spf=pass (imf28.hostedemail.com: domain of tweek@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=tweek@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756437489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4RSp9eYISPp3ul5CQrLdXinmL5Bsh3QxnfVtRH1dpQ=;
	b=B9vP5DXxmp5p4/olqkA/q56UF7hkxVyMKYspiysX9qULUs0AabTYfK+LdumejpmjtkYK02
	L3CBUZpFqg7j4Nx2oz6E0ewNM7+GHwDuXTnLNKgjpA6eNqDRzhYfYt1Kjc1mJL0ZlkuWkQ
	Ai/WRnwKicPnf7vOyJuh0S+y/Y0QrGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756437489; a=rsa-sha256;
	cv=none;
	b=uedDYGzmfVUVwNFeIgPGYkqu9S0GwUnOzgQsO4u4bbA3GEaXE05BU+Wo+EFMeZFXe0a36j
	5w2dCLDRkXtDCYfyzIudscJE2Gac9TmueYMniTTNf5SduV0GakwJcf1kwDQPNIhpYDmwMZ
	rBzbRJgpq/N8+7WLJ17AK2q5XHhVGRU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HiQu7fEp;
	spf=pass (imf28.hostedemail.com: domain of tweek@google.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=tweek@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55f3f68d4bcso2638e87.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756437488; x=1757042288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4RSp9eYISPp3ul5CQrLdXinmL5Bsh3QxnfVtRH1dpQ=;
        b=HiQu7fEpCWMzNfuPNUKVX5QQpLO8CDoMYVrCmiPrNBKnUrbrj8Rn5k2EG41fpxDlBS
         So3S/ka29RmTTjOOK6cOKE4z1O9pLgDJ8ck9CclHBVBaLOYpkRa4Xk1XiQn5owhocQIJ
         UpB9fC6OVg6Y5BY5TNy+snym1EOr1uutD9tR1IRB+r/XEadzX7d0gQ12J67BNmSAyCuP
         5UT9SUcoG0gwQfiLN2UCcbJhg9RPtW51GfzgTaA8eNORvxFGx8pNaFIZ6atqv1MNZy2q
         u/klaJPG6uPc9tznEK+MS7oGyzz8eYLBo+xiveByiOn1kzglj169dWRrdX5GS4c3AKo3
         EEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756437488; x=1757042288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4RSp9eYISPp3ul5CQrLdXinmL5Bsh3QxnfVtRH1dpQ=;
        b=UfW9+cfG3gW81g5NdQ4F0H60A3J6Z31UBZPWYeCnwOCob48WQnCHoKp+9+ppxU3OjA
         wNSPrCUebpd0tUSAwxdhWdOs1Hqqam9YZiIFzLn0ubVjSy2uu7h049fXfSSndbpN3yxP
         qmU6OyAC070L84vgCac+pzJ50ThI9+mbxRdS0JTnFcpKn2OCtxgmuMqaMASk270pexwF
         txDI0YySsl8YWXgwpjSRaO0xMjq2FDkbrzq0ukyxkDs7LlXw1gk6aj/rzFGSg5B7wcCp
         23rxulmnGavQ6TROy/irvt4I7dgWOypDnv17mamkUNHGtj6eSYFeeZukXwRraGJW9P85
         AFFw==
X-Forwarded-Encrypted: i=1; AJvYcCU3UL75y3X9kV97H6+6yy7ziVZEtw2K3rvPeM9gpOhn7lIS6XU2f+PFwy1UEnnY97uY5RCVKOjD1Q==@kvack.org
X-Gm-Message-State: AOJu0YzFFFtNxnlst1MHX87EuLAVgH7VIXhMbReWNcnq1lwfkhyrNOUP
	bFKOxolmaCBu+/NI7SHhFtCV+paVpQjzuVkPUY00oru2WfAQfoWArtEts0+jJS63vurzczuUg5k
	d1Snc51CL1JMK/3UGxSqz3DC+GVp7YbWHKtViEeCo
X-Gm-Gg: ASbGnctfiXkcuzFg0BcQCEuHu2qVOa3I1gfTIohdkeCHZkZupFACgisVdun3l4Ow2/w
	cO9aUDATrrnroFCVFBn4GgxBeijxhlRhJqJnQJCLguVYu+m72aj4jIL5CR0/qbF3nNxBLpgHMe/
	NXq24lOFO2hC4lepvYsBCpURvxP1ZZk29rI7jaQD4Z4ryuqNo60p1e4EzeViKSpyTvlnYDJYm4E
	5/8eE8/VUGGq98nATGK1V/3aGKFo5JPlGi6fJbI6MOY1pPp9cvblAuBSLn/Zjo=
X-Google-Smtp-Source: AGHT+IFI50gmtXeeaXXxJIVAnDAGK1/ITIbRhwTJOQBFj8x+oy0c1K4cSlqQEeGfc9SE/eP+mLPN+XG+5Gr3gbEHnq8=
X-Received: by 2002:a05:6512:6081:b0:55b:9f89:928b with SMTP id
 2adb3069b0e04-55f4dec0603mr835582e87.1.1756437487364; Thu, 28 Aug 2025
 20:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250826031824.1227551-1-tweek@google.com> <CAEjxPJ6G2iK9Yp8eCwbwHQfF1J3WBEVU42kAMQHNuuC_H5QHNw@mail.gmail.com>
 <CAEjxPJ70O5SY=XYJKrQDLkHOO3spD4VSjYCv0LkhYKCvK=GP7Q@mail.gmail.com>
In-Reply-To: <CAEjxPJ70O5SY=XYJKrQDLkHOO3spD4VSjYCv0LkhYKCvK=GP7Q@mail.gmail.com>
From: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Date: Fri, 29 Aug 2025 13:17:50 +1000
X-Gm-Features: Ac12FXycBYGD4I4aX2hDf4xZlIcdu2KtzzqfNLXCw0JqAv8OIzGQjgujUyOsrpM
Message-ID: <CA+zpnLeFwyCSRrQW_6hb5r3QZ3LMb1dNTKqGZ3b7gNqZQ3+OYw@mail.gmail.com>
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81F8EC0007
X-Stat-Signature: 9xu7t8rfwg7enz53w74ghwfo9abey5ay
X-Rspam-User: 
X-HE-Tag: 1756437489-967570
X-HE-Meta: U2FsdGVkX19zOr4EQN9H726muPPyfrRpnHJ9YEStqH4j8nF5+o0IwnFKWJYzTbY1Qbx55ZenDAkInOkQ0Xh10m/axrxvp8uanA5dY65XpWgMxGwy6SEOdWGcGpPwVKGBZJb/cuTHD21+J7nQd81WJxNRyIX8/S+3qFevGkKmjuzEzO9Hmw79p8/WepoOLoCD5XYfLqM3WoQnQaQNnG4i5TFFEob3pY9uJ3smVzMSzunA3BWWtPtn6WUpCgJR3d045DQ3DQSwoYVtdVts0ww9vXz9+kZIthScNwtuF6WP59nxyHFg9vqYTcCJkJOYPOJDbtOA0zOcn3LzM6aKdp9fCODwyITl0qHl/0RpihSNwW9ya0XwYUqvJhnI1ixw9y7FIleNDq+TSrPoNzUWTq46lDpIyPsdP+4B3dtPMtRTLNZDfZtFGVQD72Yii5YWlEA5yzIAP806zcmo99c67ULHjfiaR5+x4L5F+LHX+KzZFn32um2DAnxnTSJsznYdpeFPQWmvOqiGOmtmPoR90btCQGlo2wSG2p00uizRU4n2xyUbna0IQwmCiOcEY5W6yQtsnv+k/45kcouORzK/LHFtIrU82lbchB8VDWwoo8CgFdFEjlYNgYc+l9zIZfhDc5ScfGvy97cogSsOyAIqnOa2+c7C2z07hCIa/qE2R2nRt5ui2Zlz2fjqtQ44kdvbsub+GFoiRQ/mkcDADNl/J9ZMG2VQ0XWMcR0BggFjGWJaQc73XcYEd9rJR6d/2Rj3F31EmLqU/dEi9IYXUrLqdzyGvX4WBmVcyje6BfYkTgUjZgFhE7duStzrO2TeSGww2i00U8VsNj1z74LEZJM4HRhGwH+o9lgIpydVnWXGKJCY9tXSfxC7I/JNBZ+79rZ8ZJ5kVzZ699JN71uKJeRitW15mQqpDNV+nqjik8VrXPI20rgB21iqGcWhslw0NkTABdJToFX19M+Vqgn1RDNhWK0
 6tbRaGB5
 5xm07D92RdFPGxMjT7iIEP0SGW6LPMQO5KlPvhDzPIp0QULQsVrqoNP8GmOBiNTXvpHYw6JTPkdAtVM+fE+a/k/q20gPEqyMNkUbY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 11:30=E2=80=AFPM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Wed, Aug 27, 2025 at 9:23=E2=80=AFAM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> >
> > On Mon, Aug 25, 2025 at 11:18=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@=
google.com> wrote:
> > >
> > > Prior to this change, no security hooks were called at the creation o=
f a
> > > memfd file. It means that, for SELinux as an example, it will receive
> > > the default type of the filesystem that backs the in-memory inode. In
> > > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it wil=
l
> > > be hugetlbfs. Both can be considered implementation details of memfd.
> > >
> > > It also means that it is not possible to differentiate between a file
> > > coming from memfd_create and a file coming from a standard tmpfs moun=
t
> > > point.
> > >
> > > Additionally, no permission is validated at creation, which differs f=
rom
> > > the similar memfd_secret syscall.
> > >
> > > Call security_inode_init_security_anon during creation. This ensures
> > > that the file is setup similarly to other anonymous inodes. On SELinu=
x,
> > > it means that the file will receive the security context of its task.
> > >
> > > The ability to limit fexecve on memfd has been of interest to avoid
> > > potential pitfalls where /proc/self/exe or similar would be executed
> > > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > > similarly to the file class. These access vectors may not make sense =
for
> > > the existing "anon_inode" class. Therefore, define and assign a new
> > > class "memfd_file" to support such access vectors.
> > >
> > > Guard these changes behind a new policy capability named "memfd_class=
".
> > >
> > > [1] https://crbug.com/1305267
> > > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google=
.com/
> > >
> > > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> >
> > This looks good to me, but do you have a test for it, preferably via
> > patch for the selinux-testsuite?
> > See https://github.com/SELinuxProject/selinux-testsuite/commit/023b79b8=
319e5fe222fb5af892c579593e1cbc50
> > for an example.

Not yet, I only tested internally on Android. Let me get a change
ready for selinux-testsuite.

> >
> > Otherwise, you can add my:
> > Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

Thanks for the review!

>
> Also, we'll need a corresponding patch to define the new policy
> capability in libsepol, and will need to de-conflict with the other
> pending patches that are also trying to claim the next available
> policy capability bit (so you may end up with a different one
> upstream).

Ack. Thanks for the heads-up. Happy to rebase the commit if that helps.

