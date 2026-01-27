Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D3ED2FEDA
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 18:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181FE6B0088; Tue, 27 Jan 2026 13:39:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139666B0089; Tue, 27 Jan 2026 13:39:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062496B008A; Tue, 27 Jan 2026 13:39:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E54116B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:39:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7386F8B441
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:39:28 +0000 (UTC)
X-FDA: 84378606816.10.0422FC3
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2691440014
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:39:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=S4kZJ+Hh;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769539166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB3BhFyIjodZhUGQQ41xIA4/U0Zmh362p3tEBCm/trs=;
	b=cC++S4oU6dC6R/t03BKPN6psfuEEvweEKut9J6FJQ23UDEIWnnLL5SFOqJNMAQkLxISBmL
	UINnWjII5gSl3apb51NSpPFhh/PGULKmzAXZ7zXLP8ClZtVe/c0/ekFXTyHRA8yXL/HA9R
	P1BLjsP60t0Z7Ft4wxgNc1tHA8DNsCU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=S4kZJ+Hh;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769539166; a=rsa-sha256;
	cv=none;
	b=J7RMfKQ3ttoQUuHxf+5YU6dJgPXP5x8a1rKPlgsRXuHokFZ75kRTcfAf3CrJ91wGxsNKG2
	A7Oeb2HNqilvOtWPkqwFJ1k6pK0M7Nvb2lT33eHJLH9fp19nO66v7aL9U2l6mxlQGF5mdA
	q5opB+hgwHwM6myE5wBmxHelEj/NhdA=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-65832eb9723so11134353a12.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1769539164; x=1770143964; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IB3BhFyIjodZhUGQQ41xIA4/U0Zmh362p3tEBCm/trs=;
        b=S4kZJ+HhfrFa77iVDVTBduxo40W68fozi31AJN4Fhd5Ts5kPeqOS2z7PbizL+BAZ0a
         1rNd6AkLKWjq+TPfaXlYa+ja0Gxn0KsPjk6rX5z8n3l+l5/RKx3zgGfZCMP+8TRGX93K
         wR6agFvwc6kO6mfIvPOjH0+xdh6KNBtOjbq/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769539164; x=1770143964;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IB3BhFyIjodZhUGQQ41xIA4/U0Zmh362p3tEBCm/trs=;
        b=iQPpB9g+HV1sXnJDHOK8U4XoXEfpa1Sb9ZsRA9v1ajJzztoZdtfsTgRthq+DC19yhz
         YNrPXtnfiQ4qQDd5z7urnB/ipqKYEpoTeol83D9UDcRLnE2lSzZqDP2QhiBfhF1aO7kT
         Lvf0NdZXP8Kv5jqsHwC/5vOFw7s3EyYVwkPWixavE8Uk7l2fcgS3nEH4a2BuR42TevU/
         HbG18Y/7zUbvEDHPA43E7P/VhH/v8pF5uQCcUuTZGRm/Q/h6vcZ0musEdzij6Z5lkHCq
         ta4dcYBlmz+bHQTkgjK+Xj2YQ1e5qhRkh40YmKMbVypeeItoodG1j8Djifye0iryBbYV
         f9mw==
X-Forwarded-Encrypted: i=1; AJvYcCVXXqiA7wzOk4P5QrRcdDzth5E0NI/IS2bzKIntg7C4IdjoAF5qfORVdwQD1LK+tuCW+7nPFVwLeQ==@kvack.org
X-Gm-Message-State: AOJu0Yzn7afoYSi/70nyUu+3p2Xxqgp7aNFoXn3ZI2fNC7feYxzocnwC
	drQnl5TLHpRwuW968aFenORv6QKLFVsBCvkWRcagAGCyppi8KpVlEjP+eYLNQzVV48catdn9oQf
	G5jdvRZY=
X-Gm-Gg: AZuq6aJ3eKAJY10kqTZ66qFZUkAyLLOom7JyUkgLZBRMGAcH7aG67C20pnYFZIjyZNW
	t4F/XAAgLDylYbVotMH5nidpXbGxKjnCto8DJPRNqBTXAmtQuWIi5arI94/ORXhzVxS7Yuqm/Mp
	bxdxzZ7XXomLVHhqKNLw1RJgu53Y88PzgFm/RfIIK3Q8QXA/StWyXyYAHdF19jdnKjmMQVTy5ZI
	OtFIbmfKPS0KSl86GjcvKRy5FFGZAlhstgsXAPK8lBU7O8VwfJFCbJqxKXchp2uoAZM0VPqJlSp
	jRyzo8yzy95Dif3kYMKSzbfR2X0r4zjN9IaS0A+ayBJ4qpdjFTqJhkh0yESG1cW3zEZ069z1Wtf
	8Pl2ntC1UtEwZHTVK0Sh84eCl1mpUlCdh887hBGaUGRszMAYT7Wp9Jr1XqGcTZgpHZT5OktS+wt
	dvUBZ330RAo37GYDvycl7bRr2C/o1J4HyQtz8dxB6xN5mrpwRgYwEnu/m5PhM0
X-Received: by 2002:a17:907:3e93:b0:b88:40bd:be50 with SMTP id a640c23a62f3a-b8dab37d8b8mr215242666b.50.1769539164150;
        Tue, 27 Jan 2026 10:39:24 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbef86957sm19025166b.5.2026.01.27.10.39.21
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 10:39:23 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6581234d208so11209575a12.3
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:39:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV0J21u+lYLbSeH/4bH2ohsBPpbcTo/1xu5ZcyA5kkXykTC51H5H+8/JHOv8hG4IVy55j9Ebsllwg==@kvack.org
X-Received: by 2002:a05:6402:27c6:b0:64b:9d9b:f0f7 with SMTP id
 4fb4d7f45d1cf-658a60c5513mr1939607a12.33.1769539160812; Tue, 27 Jan 2026
 10:39:20 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com> <2026012715-mantra-pope-9431@gregkh>
In-Reply-To: <2026012715-mantra-pope-9431@gregkh>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Jan 2026 10:39:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=whME4fu2Gn+W7MPiFHqwn51VByhpttf-wHdhAqQAQXpqw@mail.gmail.com>
X-Gm-Features: AZwV_QjTvEFSmpHcnOP1NJLVZBe5xlcj-dD5ZtjcNC__rjqudIVF0E_rBxSpQA4
Message-ID: <CAHk-=whME4fu2Gn+W7MPiFHqwn51VByhpttf-wHdhAqQAQXpqw@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Samuel Wu <wusamuel@google.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: p4s8yknhffdk4akznn1iie9cn96jthir
X-Rspam-User: 
X-Rspamd-Queue-Id: 2691440014
X-HE-Tag: 1769539165-243296
X-HE-Meta: U2FsdGVkX18iaaXsZZR9EATus+W892PsdE5Il0WtZDHKC7rSzupgVrEJ7jz9CXKA7i5/2yIs0E89MZgCNHc598uIrlwPAbMSrOGZ1hVhWpa0ch/76/8sjfDf0HOwUj6LVt44YRihwo3f0VI+4yyE0YsmIf2fR9hDGT/0NJnDv/jp4w28qms427sYay7+zfLuy6CZuDUnVk8ucz9ES96O2erXHqMWpeu5nTEStPHjTlqr+EsmKVykFFjYBOP3r+5wiAIandhjHD+9ALla4RTrhLDXZVDgmGl9Fny0o/Yrulm4hjMs/c781H/NcWzWyWC4wLyGicttWF4YTPy0B2xAzZroQz1LgrweqVph1IAbY8hnuYvggp7cmDn92ATOANL6cbMPVewUhdA76SwEaRbUH//RXXD1We4EeeqpZZU+mzFc63DFQN8y2udkFrgHln+f+wFq5MUeMqmlYU9fF6SyKecnuxsPCdcJvtU+y6ZE/6ehQKVc+5uhuFCiLIsKuPqtfR1Q5EqBmw3UBjq4JcT08HDF8fXkhmKsQeFFmyqX73mtZYJ2XC2iy6lok5YHqxGH4Z1ZfTSavEBl2lmXnw0c1vowy3DsNyutZIPozVb7zIVnrHrqd4/DdC8BpFhR4VyjXF0Ct+Icc3SZF3LmJcI6ab5Kkn7UrlVzQJ+FzIaujXxKC61BW/X92qIPHOSjBT6LOs54pWCoRfEp2LePQ8NnjMyZMaltOE+7P8Ki9C9EoAOGpf8Xr/feugxfiwf+5J3In5u+2oFUxy15ezACHM4iS3DOgurkuIfalKXRjXr5MbQtSJFtaul9q+Omas7xqrNYd/ou90AQ5TmjFKfiwGJlijnQyGD21Of5GK8kvvjxcr6sa+kveOwVXB28950LsKRGtRDOFnpmCZew171XHa75iPR1/3/HCoaL7/VbXYMkG+sSOXkp5oOinOL0OFKsbA+FTo8B/jUfrLTjPzs9+W1
 og0CZxlb
 bTMZ1dwpkNG/AW83lR1shodlvHFtdda31lXEPPRVv4UiiZupDBk7Du3qsQjXtgn4T/P7GAlpyvkQUpXE/QyXw5Yy206HJaERYblNrVYGm+kpXBYM1amqRxfKT4mKqRTDX6UoxUWGp4jt/IqbmsErkiwFQJTMYnmQXIAgPh/XcBNtMdX1gH8bdpnxfiio3ljvfC7XUo/uyp2kWSep2mL4FjjKXloO+CMMNl/SQm65y5df9MheCtDtbaZVkm6taL86gqKrUwLLoFB3MaiOdHfvf2/R35ajsu8npxkCmwJv+slncVyEoqXqfE77qPOgCBKNECbHpSj8UEtDEahJVsAKMiGLKAHvfWEgNyY2lMIi7ZhzTNEgQhc9G4lURNuFb1iOG7VFjzqhn4am3aCuXo2L/iVWQJbKzS/VYLk83YpPPOLAktVsTJoetc2s9iUioFnB2E+xTeCuwUrNdppuDtOTaN878ZIIhkJdzeT3SKMNWijzlJidSsCqfsXnEa0wmxaHZBhZIIex6FtOi7lrlcjNKKufvZkvMpio+HLMJqIXFhUp2Y3bQoigGTg3R4th1/FMIHQtSXZ+V66H/g3hGfmBKwoixB476H8WF6KIrQpEAAXvvkw6FsueZBelojLInurMC57sQtvKLqX7kECMqY1ZKT6FyIB0eTMF0yzkM1LBcaQ4nn3CtVnaaui0OXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 at 23:42, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Note that I had to revert commit e5bf5ee26663 ("functionfs: fix the
> open/removal races") from the stable backports, as it was causing issues
> on the pixel devices it got backported to.  So perhaps look there?

Hmm. That commit is obviously still upstream, do we understand why it
caused problems in the backports?

                 Linus

