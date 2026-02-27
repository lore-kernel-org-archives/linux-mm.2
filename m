Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69640FEFB6D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5CDE6B009E; Fri, 27 Feb 2026 12:08:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E836B00A0; Fri, 27 Feb 2026 12:08:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FCE6B00A1; Fri, 27 Feb 2026 12:08:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98D626B009E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:08:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69CB916088B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:21 +0000 (UTC)
X-FDA: 84490870002.29.296623D
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id 510B74000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j7I9rKkK;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7MEfERrDZZYp0c3EO05mpNNZJ5XP1zAqLXvGoyft2Y=;
	b=O/kUglAqgobTAFp1osKX/Bg87DuZ1JXbEOTfsTXqKJ/KXuB2UuVfIV+GRMAq4U+6GqjVwt
	hwkSS5+ZuR6QVbioUoipzdbAXGugCHCqCATRX79+I3NmADW7rnIx5ihtw6Eqjix4wcVTeb
	C1076QkEAyJMK5xki1Sb5Gec6JTtO4Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j7I9rKkK;
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772212099; a=rsa-sha256;
	cv=pass;
	b=w1OO5wpph+rbnYkvvP0t3ST3Ui0cDvFz5BkePPipT9UUjtMJWa+l3BTL6jWe9pSqLBq7aE
	0DeI5LzTlBL2rm9SJGgDCidl+enQs99JcXWa64u3yv3hyHjI14O10F3Lhaw5cHW5gnM9Os
	SRZbEiAZpr0HIdx4EfI38t96zRCwaZI=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-389f200c26eso25857381fa.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:08:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772212097; cv=none;
        d=google.com; s=arc-20240605;
        b=N8jlwGpIPHAR3tet567OUT8fGYTCJxEgrJPTSJjG4X/HIhg39fq5qALnASefePm085
         r6FySpUbCRHXnbk1yYalxfjgisdYhljeo4Ycpox42hZl+ELlDC0SCfjQokswVrzJnnR9
         0wbEmtGcr8h5n9SgOyTXQCgCshNT+PzZGFkfTENo4BKkpdGKcPIGJejfgEjZrRazmheF
         DJ/FoqtVRyEJVwe7w2ebXqglYqYS+w0Z0lCGHWsf1wqJYPWD5G0HvBhgNhF3T5zSWdsd
         2XlBWLqKCtP8i4RVPHf33RsLGxDA/F+uDL9NNVCNw6FL9actIZ472qmycEh3aR/6EAV3
         uNWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y7MEfERrDZZYp0c3EO05mpNNZJ5XP1zAqLXvGoyft2Y=;
        fh=k+9/As0e3gjzdeQt5XmWv9v/79lzp65ZSV1+QWaBZFw=;
        b=dFvGBLWqLUn0Ce//DKQzQdfTqvVW90Gdz8y9v1JDDLTQw0GZsukyh2VSlUvn3xRDXw
         9fkWgdAW1ZGIFLsDL9FxprZcCys1LeVrXkvjIIaT+497IqWtHGsE7n+s+UEZd/ZWedK9
         bVoAQ+ufssmW4VwBgOLtP6oOS3LUhIlnfNrFteyPJ2PLbr+wvsF1ZOpRP3OXvLq9K23N
         Ha4uUQRClhBRx5tepcbEzIk4k6MTHcUR4VBZw9jjBxuUl2FIBH+2k+rbOSpWArQXKwaZ
         iuGqH/LiW7CIgZcDS3oymf52uVVDfKpzhYH9oRnNW6rOWgJN3npgUwh4jWQLKYgHBt/R
         C4lQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772212097; x=1772816897; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7MEfERrDZZYp0c3EO05mpNNZJ5XP1zAqLXvGoyft2Y=;
        b=j7I9rKkKl3UQaGZUG6dBpeujjMGIebcESC5P1hy4At3W8V6vEwXIoKtA8K6WocWxF4
         1CumIvApqiNnOt1aCpc/6PC51L/6aB9DcDeC2u1yRt/56Yuf4GwBV6mj5TrBQ2oxp309
         S2RL4cbe3iSjkmBv9karapPQy/uu4S9VBP0dfvLnvaxt78HYarIw0s61tYXPirBWS+fY
         7w07ifSYS5RTfn2ypP/bsqKSBNTRiDQYPTIkOA2nhh/dc890Da45hmPHVTkDs4h4TOV3
         GV4X6GEdh29/qXGQLWpA10GwUpMbTcXNWamSGby+D+JkWsi5mOFsbNZEgfjNNKE6YVEM
         tW/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772212097; x=1772816897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y7MEfERrDZZYp0c3EO05mpNNZJ5XP1zAqLXvGoyft2Y=;
        b=bb94pxVbNcaYmcNbaoU+WV8Y+Gq9aC53VkgYb7t0PsBGx6fgiyMr84nuNlEFaQfKF/
         /P4whPx4yXFfOoxv2hCyHLzb5xw8O0nE+jnn4HQWMGZLcJDfoqbFhhfSdjV9R1pHggkW
         bR5UWO+EVIaVWk3PTPY2vnt1V3pUb0aOSzRNx1CWRbv1KkxJF+S5Ik3WfLo4C3Bd/dSp
         eKcDYpf6yFt/3IN9SbjzTaJqDUrWMNrEfeHYcxomBeEAAkKIDA6jnJDkRx/PTwkN82FD
         kyBFOz1owH1ogWOxCXEdFW84PAE7xZ6t3DbofscY5l8ynIeWZa33uCjio62pq8HnHQz6
         yuVQ==
X-Forwarded-Encrypted: i=1; AJvYcCX28zruc5hFLwGcjk/0WpcdHaYFRgZrHk7LfH1hw4vkaySoVJRvXqxFLr8s+A8TezHV2t7xLQeE5w==@kvack.org
X-Gm-Message-State: AOJu0YzT2ZnLjfmTwl3dtMQIJ7DiaxPl8/4FjtWawxQQ1sRHrp3tolO0
	3UvsDfNc/xMQE3LRW0hudySJAIrb+X1J2zoav2lgy0nWkAmqb48vej7hwepce/yZved++3+C3eW
	1V0YnZh3skIlyYOH5ozrv+5KNeg4Zh7VKlmMREHNL
X-Gm-Gg: ATEYQzyN2HPAW/dcbLmiLqTLv2p99mJNadJ4l7cfXuw67AgMBQoKjxZoG1nXjHSgC8Y
	AZtSevBAASk0+4/tLYKPp6XSqL2nKYU14FoanImnvkzqxe0edckwAtgQxLI3z31BVyyTYemo4jA
	dPoSqVCrkGd/jGzbKr2Y4Rx2Fw3W0R4s5uDqUzeuB0cZ3Gueh5uKdAqhlXaV8af8zyQIrYpirP0
	FurP4s3a9BsEkssj5DDmiuZ4rbHIeqTo3gsU73dz2EBq7ZWzkvop+ZBY1IHpCef67s1nHjs8b6I
	UO2Tb/F9pA21TESsKg==
X-Received: by 2002:a05:651c:50f:b0:385:f7ce:f321 with SMTP id
 38308e7fff4ca-389ff15f271mr19911451fa.26.1772212096622; Fri, 27 Feb 2026
 09:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org> <aaDqhjdLyf1qSTSh@google.com> <20260227084658.3767d801@shazbot.org>
In-Reply-To: <20260227084658.3767d801@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 09:07:48 -0800
X-Gm-Features: AaiRm519T9RurPcNiWyO80VEVhcFvT0_H9lBfATMd1KVW4QtGFBpubzCvVI4oqQ
Message-ID: <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 510B74000D
X-Stat-Signature: h5b9jwdkfinoy46gz61fgfcd4b8jutzd
X-Rspam-User: 
X-HE-Tag: 1772212099-565897
X-HE-Meta: U2FsdGVkX18wqNkYjJlvzpmYdoBy8JUKsOJ72vpJLbN1xGqRgv3zBMGEY89NjBRPyZN/XJ0BKloE2U5izSHL2DYtFdibIbzx7KC0h5BCVR4RuiSQx36VCGnFPwLFUSwV/fEAFK9uCyHqvk5HF1M9tvARB0pVLJ7ZbeHg6GQZcmy4Co8aCA47+uJmDktj6VQunRpfvjh9NLJYgvKS+Cc9rtKW/QFy/04RR62MVrZwMv1w7fK6ruK9cqlofUH6lp3pA/R0KOanPzGjIRhK7CRScoLYK/kTNC7k9WL30IPiMEbDVxv1ThYi/ZTy5VYVYA/cD5BZI45ZWQ8i1auNEJukvtKg+4q0n05HDZRpdK3IX1plE46IwrFO9Ph7HCkf8pPEQWPgIFKAPQiFawZ1FFQ4PFpBEisA3v6GooQVIM6MddsyM/awd2LdNa4tlL6Zv41llb6kYlvqhTth2EY261P0MWDJLTGUAuLUYrz7hCgDzL5CbhVweBVxjYJ4b/JkPxdftpg6j3Wg6CYGsYtcDAzuicn7nbMXEArD5a4M/clu43w3QnDLRFjGS1OcGC85AZ/f5G8uQtpubtKVT2cCnehcpt5CDyu9Ai0/rEgZQVTLJAMPfU9b9eeJSfIU2/jIIDK/6ORk3tpKm8SVXnj3n4HrcWrjjp5Zy+W6I5mxQnPAgoFBKpeC8oI/Gnt3U3Fo84ZtTZm9MrwabMFLhKZZJSLyji6IzmY0QMN08CX1UbSq2nwX/LOFqcHJnO5SXzrTcmAB+3ADB0PYL7oH8+j/4o6jEVa9TSI3kF3Oo5riyAojTj9JpnbN4m7AF5u4iFjirjrQSIvJ1X07C/rw0TuFvMCrisRnlkHPP2iFSCYjj3q06HwOinvrVqF4Cmfk0VcK9zXa7VjziuYm3QYCEnXZWdQ5mz+Po0Xdr6kpIYcfOtp9W/qK/idDJ7Zwei0I8pKJ8o8U6Do/V7kE0gzVGRzgdFk
 N5qNRbhf
 qNDif56fzW/+8AN7ZDtU8QhL1NFEFif7Apx6CCDXq2W1PftK/e2swPEhsK5+m07/kkIqrQFie+aOvI+B1kRHHYyLgD69yeBH61UgDRkSjsYbPVKkQDbZDKqfSXBPLiBe5smEXVRjkPxIXXyxl2t/8jk0kpYsUV+5IyxOM/Ja5LBof5PqBJ/Hue3ZpE2Hcwu40DnbDjmSQPJvHn01tcq7e4Ru++w0QAJa3G8TnQhs3oRJKJ8qYL8gS4UYJkdu+djU8yPAOj/zY6B6Tc29hCOJxuIuc6OiabJRePL0qTFpm56PjoC7JlrFyta775ipG0dEwjZ1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 7:47=E2=80=AFAM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Fri, 27 Feb 2026 00:51:18 +0000
> David Matlack <dmatlack@google.com> wrote:
>
> > On 2026-02-26 05:00 PM, Alex Williamson wrote:
> > > On Thu, 29 Jan 2026 21:24:57 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > > >
> > > > - vdev->reset_works =3D !ret;
> > > >   pci_save_state(pdev);
> > > >   vdev->pci_saved_state =3D pci_store_saved_state(pdev);
> > >
> > > Isn't this a problem too?  In the first kernel we store the initial,
> > > post reset state of the device, now we're storing some arbitrary stat=
e.
> > > This is the state we're restore when the device is closed.
> >
> > The previous kernel resets the device and restores it back to its
> > post reset state in vfio_pci_liveupdate_freeze() before handing off
> > control to the next kernel. So my intention here is that VFIO will
> > receive the device in that state, allowing it to call
> > pci_store_saved_state() here to capture the post reset state of the
> > device again.
> >
> > Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() an=
d
> > preserve vdev->pci_saved_state across the Live Update. But I was hoping
> > to add that in a follow up series to avoid this one getting too long.
>
> I appreciate reviewing this in smaller chunks, but how does userspace
> know whether the kernel contains a stub implementation of liveupdate or
> behaves according to the end goal?

Would a new VFIO_DEVICE_INFO_CAP be a good way to communicate this
information to userspace?

> Also, didn't we violate our own contract in this patch by adding the
> reset_works field to the serialization data without updating the
> compatibility string?  Thanks,

Yes, I will fix that in v3.

