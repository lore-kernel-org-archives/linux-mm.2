Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8127CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48CEF6B00FA; Fri, 26 Jun 2026 12:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463EA6B00FC; Fri, 26 Jun 2026 12:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C246B00FD; Fri, 26 Jun 2026 12:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED9C56B00FA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:28:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47D031A04BD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:28:38 +0000 (UTC)
X-FDA: 84922597116.02.49A33E9
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70C37C000C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:28:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBELuQ8F;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782491316;
	b=FBpc+1zURNqJGtZpA4vrUOsRifdQiGr2Hb+6cM2bMDECUjJCKTZ7ijtSvAJ/IwlMfwBIXP
	00qJBHJc911GjJqp8SzeU/krOvyN4YDdS8Zw6JFfznTuVTwmApmWWo6YBFti7nxNxK8+aY
	bdCGg+RWlQqnVmZ28SbNdkeEur3Pv9M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782491316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7yRRCllVxAYk/OchgnjQ6W/17oLwF8I+OCpCxDAKNow=;
	b=10AoZBP1b9EFD3em8i7Afm1Z2VUaW/Gz7aIBSoIvWBwi7jUXqU+fUq2hLr8QBFRV/PW7us
	oicKAsooTKE8RLE4gbJUPQ3+zZ+X2LtSVA6QegIg55eL9bcobhpWEoJF/d3Eln27b5sTXG
	XWgDcIYwlES79q0W6Jdszhkh+c5e0qE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBELuQ8F;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49230a567a9so5981885e9.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782491315; x=1783096115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7yRRCllVxAYk/OchgnjQ6W/17oLwF8I+OCpCxDAKNow=;
        b=hBELuQ8F3bagsPUQnQ2gp0SYdJowAsLkIlxv6zTudFqJhGc+7CWZ6VM3swAPuHcBHd
         R6vEmPnp4MhnpybKufp3KSsHgDmDFi4KzIZ3/AhfYQr3q0AmiADo/yX0k2BSvjc7G3ep
         E3JacGrmnfBN4BkPBvTnUkCf4Y1HRnOGzn5iUu00XSiqZudzwKmbzcZ9AqWAgPrEZiEB
         otSXrNhqGAIPCxV89wXYwSiR5uoq/63QKEaPKPOp8SutQTBr2hgSTTic1RmdcZgdb4lA
         7mKUpr95wvM6F8NnepTEwaFyKfwA+qKjn4V+Tv1Qo8P9hgwzPmQYd8GG7HGJIOMFFv/Q
         /plw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782491315; x=1783096115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7yRRCllVxAYk/OchgnjQ6W/17oLwF8I+OCpCxDAKNow=;
        b=O6nqrV5cvdjt9itZhFQkoH7ImyvbMQGF5sB1UkuhHFA+ZHx5jrQSWHEhj3Sj8lYOnd
         HwHGfQRmzDvSnyp9shN58tsw/nSXuZx7xvBoZGYQHLvXFqN8FlDqERcohlEYpj/vHSi6
         PaS9wCXYKVRaU8lccgh3kAEEYaGDn7G+UPHOJZSo6kLAzLeBqKiIZ9oJzJVnYb3wyxda
         kspzyGQnpY/TpT72sSuVZfg0Yt1cdh2A+7fJx+rChQ3LcQ9DGx0HBWphHkfGdDnkIdWp
         Piu7Hs7QtIT5R+TYrVOy/ucbezx2dauP3bHQaOL6gTFLDP38y/xfjh4fBj9gPjPJ5YI7
         f2RQ==
X-Forwarded-Encrypted: i=1; AFNElJ8IdgfvWXF4Iwmi++Q3/Ts06ysAQE+Rxv92NYZEWnpAQoJBXnr15ZQKcw4iyurRO3Zply48OGk+8Q==@kvack.org
X-Gm-Message-State: AOJu0Yzk6gVECwU8uos1KOi9JvWz2voKdV1cPLVJHayWqYac6OmRIH2O
	J/AHkDn4xxdFABu/WWeOX4JZBQIu9P5st+dnXVTeI/7vAB7s9iNpMx73
X-Gm-Gg: AfdE7clue4OZIBjRHHtOyH86CWZ9qJfzOlWltsqpWmagLaIAr3ZV8h7NanlhrAUzZpu
	D5GnH/q6lGCVHuh1W5FgTdG2jX1JgTfw0fvZcmpSSoLO8asYsPugzT0SUMoDjZiPsKrw/EIRKUO
	jIwy2RtU+NamHjsW4uhPfBcJR1Rn8Ec6mAWoirpQq5kaZ9MrMHV6H5U5+5jxRT9HhF9dmAguucS
	0Sa6Nm0IIkWh8IxSFNc6fVZgZHUXS/ZuVg3W6ZHC9mfckoDivRpEz/EmliM2P3aJshSmY9SWxMX
	0R7iGOImyN1ZyiwanjJ7QTsMnVLh1jOmyKC6v3Ykz50Xo4MwdyhjN+q2/giFyLYKlvMqMofTl5s
	yu0Luv1vHoORZCBuBAVfvTZCUtI3ekyOk43aIYyHXJFgPH4d89YjSWEF4+hlT/8j0EMINpMfdmd
	aDOtRw2ykDfQySXWMf0XfWCQu+hbW8Xwz3Vgpya1Yl74eWn4L7xw==
X-Received: by 2002:a05:600c:8518:b0:492:62d8:2da8 with SMTP id 5b1f17b1804b1-49266884adfmr116414295e9.29.1782491314555;
        Fri, 26 Jun 2026 09:28:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49271465f35sm952455e9.9.2026.06.26.09.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 09:28:34 -0700 (PDT)
Date: Fri, 26 Jun 2026 17:28:32 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, John Ericson
 <mail@johnericson.me>, Farid Zakaria <farid.m.zakaria@gmail.com>, Jan Kara
 <jack@suse.cz>, Kees Cook <kees@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, shuah@kernel.org, linux-fsdevel
 <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 linux-kselftest <linux-kselftest@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
Message-ID: <20260626172832.366deaac@pumpkin>
In-Reply-To: <CAG48ez3o1Mt59dWdyknh_SEaoi-cHv6pdmix+aOdBy3C0-LkYQ@mail.gmail.com>
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
	<sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
	<CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
	<24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com>
	<20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
	<CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
	<20260626142616.5232c61e@pumpkin>
	<CAG48ez3o1Mt59dWdyknh_SEaoi-cHv6pdmix+aOdBy3C0-LkYQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: anywn61hz4bkaxfnin8m7o63p36jbew6
X-Rspam-User: 
X-Rspamd-Queue-Id: 70C37C000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782491316-830739
X-HE-Meta: U2FsdGVkX1/QYI3iN2GytTzwUebYpryajZrM3mLIc5cHOvQSQfYu1cykrCjEABdujUHgijTLUlC6TqpDev9LgzImVy4UD7Bg9hyLkc5qD9q5pkJNp+XkMz9n+Jui5H3ZJ9r1Tn3vxerEy5U4uEFumkmJgbNBtyY1c5nVhU/crp6Ng9JWDAE3BSvfrVNGZdvbwtadMAQcfJvM5KOaapKeEk2BTgUpNLFsiEg4LwOqzRW6vTJyHCSgaCtfWw+URMMsbrdIUclVMAbed45Mi9bD8r7UjPR/c5ed0Z6gniQH5KWH6qDVfGo/TjX4a+ZNpx5/qFC4SR3busXoF3ayzheyvYyS+rzebWHKxkeM9pg5C1OCLIGMfcw9yYKwpjJZ0b0Xq3hJSn23kwQqTzWCHgR3rrpTbeIjD+YczKeElLorWFCVnicDqi6O1sDsF0T1WL3p+o1saiHJ47OQ9k71vNX8tCL1xMy6EQwRD2BuZzVIFdEUC+6V7EM1saCAJfnDKvMTUU15GN2QXBR40kNSpIT4cHV2aEUBhMYvikiQ51xlcrRAP7Gb8L4MyX6JZpiC+Je1OXjSt1KCZgt29IqGtz3YS5Add8DaENw/EjVBNHJflAZe4DkI6KCxBLMt6LlivD3QGpSph67IcImMgF0Inoo4yEuCt97fYtdq6btcHfe6fPRIDvSF+QZTkMLRN6JyyWTnTr4mWGyqzaLHzUqMm2Rv7fbPeWLnzW7bl4b8nC644tkXvBa6l2q0ZJHFqNwKjcbInB8Gqfhwb/DTuJNnkvTdMoRNWjIXvvGC4nYTm5UBfgwnApSx5BOruAusCZP62zGqz1tlvemF6y5XBhGup9h7gyeDrFOSWTPrBBYnPZbgY0ZhHOY0Y9dNWQscT1kjyZjsGvuaaKFyV4zUyeLIufMuhzgDp7TGBSgM+nKFjxIJG1uDAWc2zZ+WEtEwxlkz9cWRDrGuKdo7GOctDIrWMzw
 C0sbyGfs
 KrwN/7w/Qrw8VFiqfs05/LQjxO5GeLBl3qO7n9OgKjlgISOqlhqyzMoHs6hvLqv5vDoqIcRnHXYNJ+uRxhkAe1E5yiQKqlzU3PpKdfAuQ/y4rtlyVJgnlgprC0LSig3QgcYne2MWiNn9oxIgDgSJc9+Y2HaFcnq62oEKOjeXhOJEUkvicH29UPlIBIyiunB6/P8Rvdj9Iy3e8SqB7Yqq2xDofOu6FrA/5QQZmxsr9CGk4TRd7pIR9H5NNV01cXFW7EKGJ4N6tuAqj+zuOPtG4XRhyiio0qLwX+ZAp8KugHMB+yuINItmbv5LKD3/H5HBr6dQui1QqGdstm+SOSrdqe6uE7VVOJPO5O1cWc+aYSjU6HL7azYG5ScphezFghXnyG5XPtUmHsPDmxj0Hx4dJ+AGID+eeAnElUP5kZCZ4mtL7K/btfPyj3Phbw70h060ye2mvI+y6jmJN9AIhJ6UU2xgjh2uSTwA1/dbBiqJWlCG+xPMINmVhuIbldb3XR0v/6fCZJWSAfC6NCpdLqkVZQgFHmyoCyZ3wxf1RHBw5AiWK4CwGsjkL6me2DrXlH59AATcRYUOIEO9GfBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 15:34:12 +0200
Jann Horn <jannh@google.com> wrote:

> On Fri, Jun 26, 2026 at 3:26=E2=80=AFPM David Laight
> <david.laight.linux@gmail.com> wrote:
> > On Fri, 26 Jun 2026 14:39:22 +0200
> > Jann Horn <jannh@google.com> wrote:
> > =20
> > > On Thu, Jun 25, 2026 at 10:50=E2=80=AFAM Christian Brauner <brauner@k=
ernel.org> wrote: =20
> > > > The arguments I have heard from various people so far are:
> > > >
> > > > (1) Userspace would be able to clone a random chroot to /woot and r=
un a
> > > >     binary from it without having to set up a complicated sandbox
> > > >     effectively making dynamically linked binaries more like static
> > > >     binaries in a sense.
> > > >
> > > > (2) Quote:
> > > >     "If you debootstrap/dnf a chroot to some location in your
> > > >     home dir and try to run a binary from it, that it tries to load=
 the
> > > >     libraries from your /usr is a pretty unintuitive and not at all
> > > >     useful behavior."
> > > >
> > > > (3) Quote:
> > > >     "[Various remote execution things run in locked down containers=
 that
> > > >     disable userns, which makes the sandbox impossible and hence our
> > > >     builds wouldn't work there." =20
> > >
> > > FWIW I think someone also mentioned to me that it would make things
> > > easier for them if they could build a piece of software in one
> > > environment and then bundle it up with all required libraries and such
> > > and run it in a very different environment, without
> > > container/sandboxing stuff and without static linking. But I guess
> > > that's kinda niche. =20
> >
> > The problem with 'ship the shared libraries with the application' is
> > that you get all the problems of static linking.
> > If there is a bug in the library code you can't fix it without getting =
the
> > 3rd party to rebuild their application package. =20
>=20
> Yes, it's appropriate for weird use cases like "I want to run this
> historical version of the software and its dependencies", it's not
> necessarily a good idea for normal application use.

That's what LD_LIBRARY_PATH is for ...

And if you want to use a different elf interpreter just run it and pass the
program name and arguments to it. eg:
	/lib64/ld-linux-x64-64.so.2 /bin/echo fubar
Last time I did that I was trying to run non-linux ppc elf program.
I got part way there, but needed to build a lot more of libc.

	David

