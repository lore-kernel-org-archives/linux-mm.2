Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 293C4CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547928E000A; Wed,  3 Sep 2025 12:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F808E0002; Wed,  3 Sep 2025 12:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434FE8E000A; Wed,  3 Sep 2025 12:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 336168E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:56:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6037E1DEF97
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:56:22 +0000 (UTC)
X-FDA: 83848542204.06.116F2D1
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7D3D42000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:56:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBJ7tJps;
	spf=pass (imf13.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756918580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dccdTdtSVBoWd1R6G1eLWRzjrSI6LDUnIwi04bR8bg0=;
	b=dCmi7gCnM7s/xcsAa2JPVsCFMCwuUi/iiIMMdOhhlwFHN0ujYeGUfVNi+mxgWBUJ5Rb4BY
	cNhbyKgK84xO8OiaBohgzIgWSbKIlqCa0mI/iR2+rL/51GadTXZfHpCISJXZSOB0W2ORxn
	QHu7P1MZ5YtZQigkh8IEB0euhSwp59o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBJ7tJps;
	spf=pass (imf13.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756918580; a=rsa-sha256;
	cv=none;
	b=QwB+B4puEPLNskqgGKI6a//s/JjXe4Yr5ARzNtw5cuU8PJiaEIoSsbW3NFWlRrxvxEuyQB
	AVgXMtgKIxnx8FBNcJZWA3NMjGc0rk8hnCHj0tm1daZqiKT/9a74r1ozUKsoUFwpm6DuMD
	2LhQ5elidNLur6DtJijtcdCz4OypZp0=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32b863ed6b6so15840a91.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 09:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756918579; x=1757523379; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dccdTdtSVBoWd1R6G1eLWRzjrSI6LDUnIwi04bR8bg0=;
        b=kBJ7tJpsXnDT4SyMBkHO47wA8dcdn3FJZfjkpueYJj6Q8/wURaHvcCU3Vfp0oCpxQe
         wAKN5NCds+q2W4LsXz/0sLIFY/liDO/svTPEzfQ7REFo1dbNHvlvSIj/XGdrABqDQeuV
         D0NsO1/w9OxOdYn7ugTFlg1PU/V1HSQAOELR+XkKQEo5Xu9hL15tp4P9JhqsZANQfXNG
         F5pKTnC3NJIVugO8u0NLGqhtSdo0+sG2qS62qAWnQ2UNbPqpiM2Obj0YzEm9qPafXVPt
         B6oMf+3hL86XgYIiR/R9SDGVVEwhp3s03aNBiHFloR0/G09lUEG25UVLbz64DIVlMUf0
         Cc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756918579; x=1757523379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dccdTdtSVBoWd1R6G1eLWRzjrSI6LDUnIwi04bR8bg0=;
        b=IwgBZUAr6GUHkemDMVVF1OlgbSCUWzhZ0V0OU+rDtwsBOq5DJ3gXPTzGpWmjcvN8Xu
         WP9OTmuEkppnD2rsksqtpFQH+80tmOxQvrJ8uj/1Q47QSIlpgVW46Z1wnlQMaYsXm4Kz
         9x74DwpwENx72l74vOq5YYADPnnQCHswI37E2xGI1NIcbdqjwrnSvukzJ5b15gQC8Mhk
         8E7YXhpm2YvUG+B7/2Z5tDthuVkLZq31zk5NFrYh29Isw3liOqpso976kZUMJ5fXQi/J
         l7Dn1t3QGLCd4s8WkR4gd44TwCbVqzKxhuWzum+04INdxXxK7D+X//1vdWJu6vbju+P6
         h4iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXI/foKzJtuuajzR+FzE/NU6g9qccqU9fRfhE+y1Z/3ELeQ+XeDL7vRqNUVJ6o1FhvKTm3vDg8aw==@kvack.org
X-Gm-Message-State: AOJu0YxztZne1SD9eVIslhAxt+a6gC7YRXfPppZUSbKCxRqVfDelWrFo
	M1c4GLDdMLi1TFnKF5e1Gq2fOJf9ypCFSwkLXIXJzaCNAd1T32PT+oh0UkYTMXmAYfQ5eo111ij
	DSSTrqJf+Pb2pZKo2wHPAy9tQumaixMtgRrA0
X-Gm-Gg: ASbGncs+C59cc2yKmZVZzbhbiccfN+8ztL5wjLEYgRjPQXYY2cx0AxhXWTKIu4LEsRr
	/UDChG4FBESIrdML+yeuAROrgElrdNA4RnI40g+BsTDqgZEWnTBe0TZPQ+ybRf3kbpo1ObXN7HE
	A4cDlUBfvlB8O5cuAFwycDztNOtgIB/zUH3FHfeySauBgk0rMUb0HzoYQ2XcARsCC+102fUXJa4
	q1KbKM=
X-Google-Smtp-Source: AGHT+IFIoD21s+dgvxQwnZtU4Sq8/ACTY9GY3T1TUUfdMCaJfXlRUuwQdlKMspanUL1IZbHyARr6Wzg6PdqlUngk1+8=
X-Received: by 2002:a17:90a:dfcf:b0:329:8d0b:6f6d with SMTP id
 98e67ed59e1d1-3298d0b7063mr15671983a91.26.1756918579096; Wed, 03 Sep 2025
 09:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250826031824.1227551-1-tweek@google.com> <CAEjxPJ6G2iK9Yp8eCwbwHQfF1J3WBEVU42kAMQHNuuC_H5QHNw@mail.gmail.com>
In-Reply-To: <CAEjxPJ6G2iK9Yp8eCwbwHQfF1J3WBEVU42kAMQHNuuC_H5QHNw@mail.gmail.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 3 Sep 2025 12:56:06 -0400
X-Gm-Features: Ac12FXxdxISEk6HTcciX9MP3BtKPgGrHTm5LZn51Nrn5tqsOxJ7s30vupNBsxNo
Message-ID: <CAEjxPJ7Y_gkPN4-iS5Q8h16oE8Y1=vD=i=Yu4qQwHKyS97+4Wg@mail.gmail.com>
Subject: Re: [PATCH] memfd,selinux: call security_inode_init_security_anon
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D3D42000C
X-Stat-Signature: unp6bc7y5gxif16jmadkn4qejoziypa4
X-Rspam-User: 
X-HE-Tag: 1756918580-133305
X-HE-Meta: U2FsdGVkX1/E1slxk4fL/b85NuDpVuvizjr64b14ArHZtTsGRmwcNx8Dix2Oimjkzy6ULP5/Cf00nkaf1TVUoxz9fYdd/XPQjdNnyjvjTA1pzm0sRGFH63+kNJg6VLWIy+leMFxijDHlRNUWFqRRFRBukI824pOajPJa04R9e0q7Xmaw0NpiX2K0fyIR0GFssufZly9+xoWDbhUtIP+C7xJ/RA4FRp/+VaqZa02QxeJCGzEZvZ0eWN/+WbMzmquUwml7AhyEZ8JKJw8b9ZvSq+BR8PqzcOF4LAKVHHPPU20t2Bzd6F1bK7NxYTp50/7F28JEalYOaE8tUkjJWrB3cs+Q3AXowXL1D7Xx5kxI11Ki5fA6mW08B1Agmyu/BxXTyZ9m7lliOL6Rfst1GtoVmz6VEdIQDuBHoAlftnxE+rL7Ku70aX/LbrdSH+D2XqK0Gl/skREGNzxXPisdZkM0/lAP6wnhl/rrc1xi6jSJQD9wQUvxBTP+kSZpNtl8VQlE0q0Qt5S1Nd+zYr5k4rprDkgQB3sNTJjXDyeiHTI41I5LPQb1UT9mW8upRIbyPo2u1nhxq7b/Fun0p2+OVdM8vjVfp3X9z8U/X87hAr7e+xnzxKliipbPRQQAizMxmrzq55EV01rOg1yL6BywFCZ5Fp49II/wry/+LZNENiW7Asm7c4WoZeL4bdmJmlYOL0Sss1c5a2nsU2EZhx35UmsE6/5i8SxlYyyhsAyIqlhZq8Z51trKgbfwZa78I+JJREwRJCx9x17xRUDnuSLJAFjhtn1u+gPVFM6SlyjaSA4Rt+imLoYA2A76aNZ7VjY2DYZ0eNoxK9cUp+McPeHo/USiXO8s6vjKKxGPXGJmY1atFNlTfhUIdaAUeXE2ql8rsqt9ha7UkPXe0YuGlLVTx9ZLBsLcWpWvSldVIQAAMScrFZtkp0KGeBfJXGgnmODwZ3g9r+Xi4KUDz6MFlf1p+3f
 BVrWKlFF
 ahYXMRqBAK4JELBcGiexlq1UZ/KMU8Cn6vjtGbw5o7zfx18jzGSsfoD50/BHw8HMey/tINwqpkhXzCJX9o193FCMh0VsywGVHVWbS7kM2YS7FH4Cz/Zg5cECYt4n5blwKDOhiPg0EWH/Lk3nLHBrTRTl+ziNt5FpuFiigV4J4lDnOFpLvU4I2Rf5bA4uei0AZzaFCJ1d1JpvUKM7UM+JILJWpsEr4GH/lwMQ3cYXnj9TPpMxO1P8QdiwAWCD/4Ls4VjG7ZNKpbqJ5WXcSRJ2uXp5bNpu3+/KiTR73QBbB55yp1yN6ZywSC6KNbqf+UQKCYaQGNJVZPIWrWsJzWxljNvVT9tEtRv2epSYazPROcNYPxfhvQJ34bb/JEjXmc+GcC+EB/A7t5QICOa9wt+mwkoHFatNz8c2FOqnNgF/8/UYoIQGwTG6yto9ojmOO0WbG6Hnnula0cq1Y4o9QSvDkD9W8h7nFo7ixVgTpbFFggnxDUCY+58cfeF4Cv5H9iiyB7JXkXotoS698kXyiiWiR8FSeD+f8nzkbo4TmXRzagYEQUExS9FxGsbu+WIj5hVoJ4SOQecGXObUkjJZUQhN67kMFsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 9:23=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Mon, Aug 25, 2025 at 11:18=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@go=
ogle.com> wrote:
> >
> > Prior to this change, no security hooks were called at the creation of =
a
> > memfd file. It means that, for SELinux as an example, it will receive
> > the default type of the filesystem that backs the in-memory inode. In
> > most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> > be hugetlbfs. Both can be considered implementation details of memfd.
> >
> > It also means that it is not possible to differentiate between a file
> > coming from memfd_create and a file coming from a standard tmpfs mount
> > point.
> >
> > Additionally, no permission is validated at creation, which differs fro=
m
> > the similar memfd_secret syscall.
> >
> > Call security_inode_init_security_anon during creation. This ensures
> > that the file is setup similarly to other anonymous inodes. On SELinux,
> > it means that the file will receive the security context of its task.
> >
> > The ability to limit fexecve on memfd has been of interest to avoid
> > potential pitfalls where /proc/self/exe or similar would be executed
> > [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> > similarly to the file class. These access vectors may not make sense fo=
r
> > the existing "anon_inode" class. Therefore, define and assign a new
> > class "memfd_file" to support such access vectors.
> >
> > Guard these changes behind a new policy capability named "memfd_class".
> >
> > [1] https://crbug.com/1305267
> > [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.c=
om/
> >
> > Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
>
> This looks good to me, but do you have a test for it, preferably via
> patch for the selinux-testsuite?
> See https://github.com/SELinuxProject/selinux-testsuite/commit/023b79b831=
9e5fe222fb5af892c579593e1cbc50
> for an example.
>
> Otherwise, you can add my:
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>

And now having run the tests posted in:
    https://lore.kernel.org/selinux/20250902055401.618729-1-tweek@google.co=
m/
you can also add my:
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

