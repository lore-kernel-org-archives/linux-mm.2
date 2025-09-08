Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8126ACA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48C96B000D; Mon,  8 Sep 2025 18:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA928E0008; Mon,  8 Sep 2025 18:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A364C8E0007; Mon,  8 Sep 2025 18:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92B516B000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:51:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38E04140346
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:51:33 +0000 (UTC)
X-FDA: 83867581266.19.B3A77F6
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47CC0180002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:51:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=35b23ybX;
	spf=pass (imf16.hostedemail.com: domain of tweek@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=tweek@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757371891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7r/MdVFkxF8UOpjUQVzgKnL7FVHjfWobr88oKr636Q=;
	b=vnGlktyqvVQOP9W3cqeC9++e+dAXdsWum0LhwzDXjbwqhErG2mAYa4UNt+9bA30QbPrh9N
	XDpXLI8P7lRKIklJ7w/Ag7ue6O+h1AesSL+Uu4ElX2mdx0d6+RMBsv4p5VIHza5cKRVjo4
	MnFSzqgJLLSQZ+/8JULoPAWVUiN4HSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757371891; a=rsa-sha256;
	cv=none;
	b=SxlUeZDecUj5MPf5GmDZpvy4PMVUDUXXYYjeo0Ljj+bzOZJpptavTijSyQl6Xqdsu+fFwb
	XlCbon5W6rASY42uCzcGyvlmT3FoBxBCAVkzQojcaCiIWIe7UFV+LZzflG4qY2Wc8B/Z0m
	LyQDHl+IPYfsReZ9qqco9EKfQQz+28Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=35b23ybX;
	spf=pass (imf16.hostedemail.com: domain of tweek@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=tweek@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f62f93fdfso14153e87.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757371889; x=1757976689; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B7r/MdVFkxF8UOpjUQVzgKnL7FVHjfWobr88oKr636Q=;
        b=35b23ybXG6d/5oAn+De5vlmxBFN72H9vM9QgH+EhkcvuMXUkiDAov8f/Wp3oJfZR6a
         saWIE/b+K/GwzBPBPH12fCF3pKl7NwWp4M6NATsPC8L/hhvFzvBOjbXJKGrdRxgcd5/c
         DANp62V0nBrLum6upqDZOZiBPytm1UXplDV6HAtukqrBrNIvtl9m00QTO3H6xdKlP1gm
         IsSO6OWuv1XaegiMEYm3S26LaenUZM8od74mBU3vglu14kjLjHJL/1KZjIBtucaoYDxi
         xCp8MWDyHRLOlqSj2zGtdPpMvpj+bBrrSlECyhI1iDlMJSCaESeDM6qbbpa1h2f4XWoy
         coBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757371889; x=1757976689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B7r/MdVFkxF8UOpjUQVzgKnL7FVHjfWobr88oKr636Q=;
        b=mNbm+XUAAmq8nM/XjyewTcMM3o9sn72jY9SSJ85GZ79HKVzoOufShUSd0TCjOy93MI
         Es+cHoLYgoHa3HICQ7IQufIbAoSb2AYXj6hHlpkv4Yy7dTh2Qe9TWcIx6Hd5rwCzt3Un
         pG8k0y8YsTOCboNV4QtZDl9mDgZzMv2w7f1L53rH8dCzcSVI81y/RhoZxiXRBiaBZk7k
         rfUDg0w4mMhmMCp93UxWIfMrX8iKQAR0/39uqNSfxJ+KUDyDUOlpTDBM+ODF0r3Fyxk0
         zXF0fZVus/DoDxLt6qsTNfP5aOejLOC3DNqzQmhkeXvVi8SC+dnXjHTewkvc+EWUae8z
         t1Yg==
X-Forwarded-Encrypted: i=1; AJvYcCXq+czBcR2U0s8Fo2hpNUYvEdSMeVOrlOksTi6GBBU3i4U8TmKxU6aDv7tbulC3b2MACgd1amF14Q==@kvack.org
X-Gm-Message-State: AOJu0YyxnVJ5w12MIzVaSI2jK9FyDWmJy6piXomLiv5lMHbBn3Ncx7VR
	AlMLphEo+fcDNvaP+wr0585LokL+JGOx2N4fLwPXoKqZfaaRj0uniCcL1eVpovAD8BVlv5F7gFs
	5cBKF83pT+IdL/DI7McE2IVDmTIhRnFQH2AZPZaxh
X-Gm-Gg: ASbGncshnYAYtlMVq83fallohiTlDmCQzqEigk1LbIShQpkzulAkALSZ/ZCfeBoquG4
	B/gPjmvYwn3R+s/E+KJSCIMn9Z+ldXUNWae2xKLyPIqbdB+Gd3OTn8/Z6evNZc2uCMt+bSjhhCg
	s2Zpwt1Gx41Jd0bFdnYXP4YR9eS93aSKau+s9aSJOhKpkGHE61PFulvOOKKpKSO8CmZKg9R8Cff
	6IIki48uWoY723OGL91hs54RV5OptJ14Ebqs2Smx1GvvA==
X-Google-Smtp-Source: AGHT+IHGlPCHT+44DAvJB9zRm+3LM/HXySp5XwuN4EFQvOUkmZCnoZLTNZDiAYuGffXb4da9PPxUbTsQPmLHNTo18Sg=
X-Received: by 2002:ac2:5b92:0:b0:55f:6c68:400c with SMTP id
 2adb3069b0e04-56272295585mr463209e87.7.1757371889119; Mon, 08 Sep 2025
 15:51:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250908013419.4186627-1-tweek@google.com> <CAEjxPJ6QfUZijh3PEpHs_Yw6Hmte92-rg8gkvMw9cD=JxA+CMA@mail.gmail.com>
In-Reply-To: <CAEjxPJ6QfUZijh3PEpHs_Yw6Hmte92-rg8gkvMw9cD=JxA+CMA@mail.gmail.com>
From: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Date: Tue, 9 Sep 2025 08:51:12 +1000
X-Gm-Features: Ac12FXzaXfPJRpw8SIYa0ofw9A3koHJPN82BozBv8c8kOd4rvQR4t_4Herx7EQg
Message-ID: <CA+zpnLdbLjuGrk-178coxAH1pzpEA1jRzGn8zU9DHZ1rQspP4A@mail.gmail.com>
Subject: Re: [PATCH v2] memfd,selinux: call security_inode_init_security_anon
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tfoijwgtjyw1bdykieer81qusuokiwwx
X-Rspamd-Queue-Id: 47CC0180002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757371891-558581
X-HE-Meta: U2FsdGVkX18lVBl7G6lbVvjCJQAyVhARu7B/clqklO+S5m1KhipA62I0gQ24aYEUp0THI51Za8pVz5jAHaYndyfmyrxj2eYzrrhFDEz+d4TE4nyeXz9mVGtsaVFSsDeMmMuJwhlerdRyarJ0592e/+M2xJ/DkGD5fIJe1R13k+xYi7btM0FLcL0P2ATBk2Qiv59FrAzpOTPw9XL/uYHdePYpy5HcCuPSq4Jj+gW6bc5n5+2BvdTqXwLZGZteLvBwBEmTja6RUabS57U947gumYggOQ9kYUyzq4abB5YhP44fpajg/XKIz+XdqbNfzdEOxiHwM8ULHzHevPcpXQ/9QNNwNsEFDF51ljZniO+ggKSAao2MRsoNrGANxm1NaHe0EymHcWqlNj7jE/UXh9ib9sLDwOCKrI2GVEL4b4f7mgbUpKD1TARaN7tabHkjdzMFqvkWmFVQuolrmpB/dFBrcojmNNQCfa429fkXapWxO8N9FAmPFBAk31HmNrUES22WFRLBGgu6i15YVBehAxfmrP21eefxYRGcE2ydT5KySA82VDHerUt/HiC0A4g3DHdIK0FxSiy4Jv6m40ci9SHE9qezP/E6m9EK2QocW4PU17pHYOzO5tlH8OmTK12vmnB9d31pC4VYKrNLGw0E7RiEhDdStxC42J67tD4HhyKONfgitlN4UJh//aDQ0hJX0R/4BQFkwSiVgHSNPbA4I96aD+gOTHkJ4XLZ+O9WOIYsw7FfLSteIzumWq7vOFgHIdtwf/PDN25W3vZW0TkfhYUOE+WCWiUy4Rl2iFDyQ7h5KbiEH39J2XM5SB/Wi7CVYTs7uqIJ/q+ahgjYkKUzRxF1B6SUfQX+YTRGDDyc/lsNATaBkxSQBFX2zvausw9v+gA7BfD9gMKW3apDDxdsNjmrhBaGE34I4JOEQ8UHTYvh+Pc9S7WuhzzJmfPU+8zWx7yDnDemRbb94miiXTgEDUw
 aYytwsQv
 NjUo7LR4PGXoswNFKzaCq9x5S4ery3aSiN+0fpyEmPwGt5vlpMD4fgVawSR6JMmgcp5Xh0hLjCFinvXOevRpFzAgiYpWN3xk6h5fsryeHmzoO8kU26lky8gO2XfvUZcnHE0Vg8serzjZDcQjZ2jxAL6whjXx2+FApSHxEL+F9HgrDFXTn2OGkZL7HcZsiMUknXhLNjsl8tCbULxkpYWDstkp4jWxlPis89LJt8gBUTisOAe0tk6jIQGpnNNvoKZGCNuYbSlwda3JxvhhEjKQEDkgwP35FQm5WhJLa+wq2hQuaKgUwYQkH88byfI9Sk14ldP9SdKsujAqYbwcpwP7kxG1901LD7ZceyKmscQc/nd5ZCRH1XaQH3jyLQ02ODS3W6vTCDxlTfTPxB83luFPrMVWtmQmUDX5NmAwueKoRcLWAIMd9l0/7pZ+hAZfIZlny0ui6aoSCWqdhFLI9uPGozm8xlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 2:27=E2=80=AFAM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
>
> On Sun, Sep 7, 2025 at 9:34=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@goog=
le.com> wrote:
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
> > Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> > Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
>
> When you revise a patch, you aren't supposed to retain other's tags
> since they haven't technically reviewed, agreed to, or tested the
> revised change.
> That said, I have now done so and thus these tags can remain!
>

I'm sorry for that. Thanks for the clarification, I wasn't sure what
the process was. And thanks for the review!

