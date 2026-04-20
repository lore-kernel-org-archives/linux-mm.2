Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67549F588DC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9FC6B0096; Mon, 20 Apr 2026 10:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A966B009D; Mon, 20 Apr 2026 10:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C81B6B009E; Mon, 20 Apr 2026 10:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3176B0096
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:22:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5845EBBF61
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:22:18 +0000 (UTC)
X-FDA: 84679149156.30.4D76D2D
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 685E4120009
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:22:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kn7tHoZz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2z5FczK/Y5tDTqGOp8EC8XsAyW5tiySofIU9eAYltsg=;
	b=Y9Z1oVr+XHgI0sLjNLij4KatYX1ZnNm90nxjPGVqqleOofYGWFkKXy+EjX6IObsPz7zdkT
	Su3c3i2jYoRiO34ermSyLG6Kmh6Hrxi5DOcrHPo7CJn7ieCOj26YGBElP5KNLPOo2p3hUr
	Oz3FRG+OleIhcboXGTkBjC+VtsL1+nE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kn7tHoZz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776694936; a=rsa-sha256;
	cv=pass;
	b=1vrQYLWId/SHO68yuI2nMXpipjsoqsVIJgAdyeX5hxiUOdpRsLdivnQGuRImyK8EPdp4ev
	YbMVe8DoDXIk5dTjVI6WptJhH8+x7czdTOsxNzpvMG3cVW1KsX9ERobhygEM2DQz/wFJtQ
	kcVP59vVywGDVpM57Ta6N7hMbNdryQU=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64eaf8aa893so2393807d50.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:22:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776694935; cv=none;
        d=google.com; s=arc-20240605;
        b=d9bledVs2q5ktkMoYG7nieOgV4oPsbr/gQo8M+d2eVeEYbaAHGaeM4oGSsat90chAB
         ulYZcIrf0yzI/wUic5mBRzA2wTDk8YUET7i0VfRjSMiUX4YBHDjr+NutHzstui0QitOO
         kaaqAu2/r+m0NGjI8aAx6LQUcyA6ShoYA+nqRNcwS/2i4bDEWq655PrRFipvOlXHGK11
         /+q4EN4nEDb3v5CqsCXIHktZtie1vF4/OzUyvEKlBTKyz9WYRD2AJXGtDXTfC07P8b3x
         blb/OgLefbCg4moU/MyhNQowYFsbTgUBJUE1Msk5svV9ryUdTikqHmyXtU69ocmZAFcm
         rElw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2z5FczK/Y5tDTqGOp8EC8XsAyW5tiySofIU9eAYltsg=;
        fh=dgG7eGGd6n7bs2nWhOfABRMSQaB7+70kOS9so528/Hw=;
        b=hgoOmqFBMt5ONkR7/VeGAyNxnvJztB5POoCNQsFpxwvSDQBcNk0j9mWmItUdnN9yiU
         v0p9ydWjVEEjsOaXqz4ymnl0OqaG87nqerdjFLb4vVDHLIFvIgmMzxHqOTeBU0ETmu1u
         hwWyTEx993nxwk8cS0afGkHAfnaNZ6h1eEa2EmKEVkb23eWrWKwT04Z+eibyIRWeoBaH
         zJRHObItHZwegWNePXnR1B9aP91tlyZPjPStEyFOYEaoJi1M5N05HBcMn/4Ic9sMjR9u
         lTtpoCVqEfjshiaZNZYOFxKXdgMQNDMrPh3oTANX3n5/nvZ9K99FLsAFOwOlDp0x2JzF
         IVyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694935; x=1777299735; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2z5FczK/Y5tDTqGOp8EC8XsAyW5tiySofIU9eAYltsg=;
        b=Kn7tHoZzBNyPGhtoJYBJaMYtfAJd3ZqCLqPxRMwLD5AHdwkXZenTYbAnydqdcjRKDP
         Ygeuh/yAAXQkKXlbGktuW3GM5HBRJSbnYCbpW8ixNL0kdHMjN3MqlxXQrtWU2QhTxT0v
         emNyuEn0AzGJexDaKb781OLxDvKmLrt0kCOrmK+PZuSTElL2qIO3FCJfjAZNNvlAxwqZ
         NTyfp0O4jpOoFZnIyDJbHL/Y2jgAnZfqtBqcH693rFGw8pQzpkXNcvvLX9tInhxn5uob
         BgM5EFON4ECu5O4Dqi51/NPEKruclDlcMGFZTS50MWZCe5vXfT88waeAl6F9JaBaOfnu
         RvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694935; x=1777299735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2z5FczK/Y5tDTqGOp8EC8XsAyW5tiySofIU9eAYltsg=;
        b=CHQjkUEgg2v4eEwO4uxoJRBWwHIU4HOJCzOuzhtvzSXwY4iBfhFfQxCd4TSrCZexk8
         LqVNTVO+u8z5pRlMHvghHsQJrouASbQwVdoD7UgHLmKXSLF4bvlfCE1E0SupCBAHCXSP
         d/z8K4pk2UQ1cfo4fxMxHTqBLhY9ENZGNGLm87xXOcyrLuam50HrBzTYOzTNO1Gk08hH
         GR7yz7Xq5fUEHFYRHHh1O3x8YHZVTlvP8vSnD2qrgsoscBGzEwhx0khjySnpaTOPJsUt
         qy3SzVtUQ28n1lOX35TLbSh6SEhBXhSHw9tAQt18B0m08qDJhExpspfV8Tpj9ACqHtGJ
         hqhg==
X-Gm-Message-State: AOJu0YxC2Hdwgi2sVp1VFwm4KeM7I7DzIE0sUGPMrNzJqjWyfcbz/kPi
	lU2ZIJh6ayuvqqdRfE4q3yc8kVYdpu2Lw3IqDNzYLBplKrpPLXLNkXWtsgjeWTYGAPoSfndzakr
	UFtCsPFISUwqUVK6gttRHE4CpVk2sWu4=
X-Gm-Gg: AeBDiesKRIdpcpg3ma+gydgc22Ve2kAu/nLIz8MeNODIYdcjPtswN50mlU55Bdk/dUX
	k2LhrMrML5k36Rc2mNrGniqfF/hugJwzesIWgQR6toCW0FCQoC9A0jlaGThz1I2UadpZIMHJobN
	k0kedMSXBJAtg5sjILZL8wK9BdH/WCnJlwujLqX5KNGeaDq0PA9E6ulW0GWDCiyWvRn03lFy/Qf
	n1vtT26eQHCgtD8cUcGtzCleX7EYLM3Q8SOtJD9qbkIJATnUj0UlIQ1kkop+WyqucdGzZ01OwAt
	in1+Pdlm9d+0DJKLaIy+V/WbWxGAaA6pSUMeH6OE4qIgA/drEPYY
X-Received: by 2002:a05:690e:4808:b0:651:87b5:2cfb with SMTP id
 956f58d0204a3-65310a2bd67mr8432622d50.36.1776694935371; Mon, 20 Apr 2026
 07:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com> <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
In-Reply-To: <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Mon, 20 Apr 2026 15:22:03 +0100
X-Gm-Features: AQROBzAClrvsk3HyTqUc5DWxyYAnhGz9RpPk9svUhuaCPDSANrlVJfet0hJyIb4
Message-ID: <CAMw=ZnR0uVrHUNzNGu5BtZuSKDJAYmZGUX-HzSw7c4VnoeQgiA@mail.gmail.com>
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
To: Christian Brauner <brauner@kernel.org>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 685E4120009
X-Stat-Signature: qwnw9r3155eh1g56w6ab4wmdexaj6ncm
X-Rspam-User: 
X-HE-Tag: 1776694936-802500
X-HE-Meta: U2FsdGVkX198I2MEdYdFga8Xlo+lZJzXoaEMMJmKEZlBLNiBse4ktJmyxpsiGbG4D0JkXVNdAwT9j0+aJ/e6PjAM2qbuh9pbm02ei1z0kHakaoo05Rg3sDqMMO1UeKlUSuaXEltRSk7XVlBoOmAwFa25q/oG6pk9gddA5NlHhVMnydTU3SIv+sl4tfIZW8gfHkuVU63lLWvcma7cupzZK0SECm0gOs1QQf3gIN7Dzm1ysAAOtowjOBpjAs9DbPQeC0WJ3WMh7JFl3VvXIsMQxFbzNJ+TIgxZyCfOctOyfaVADjhHVaMgK8DadLCqHsSzOHGUxEcHaH4CMydlLkC/Xf9aBUoEihj+aUpf3RPnXuEkkVW9nzPTXblqwns3TFQ1skrfePF43By6fUIewJzI84/T213a7pfOiu9P8R9h/5HJnDnGbcpERMtRE8EgHerawR2bAA9qdnR43hslkkJqr6C5K8rwPdSfpIeeEl874mvrN3Tjt3UtlsOtvSN+QQV+nJxIqDHrTQzO9S1D6Fa/opCxnEdwhZEe/Hd3gYygJdAKaOmfXzWgiZPvYiVBq2tiINCe4Mlsfn8cq/xniaHoLWRUpm8mwJa2oLDgEJJPwWlihTizE/aANrf9oH+KrxGFoSTbfR42QQHyzA5nrXa4ngjclF8+2Fmj0v9uYAxTMXmffZMAIesZYZMjhd9P62QCZYMOsTBM04/vr7Uv7qg71x4ItdMUd/t+dWyC/p4pAQ8KjO6xXULaWusvkGe4ZKmodKyXOwcjJVOf6TvyLHTckbOVIbaZOwT8YeOcMb9HVl6gFh1N9zwIU+CHRlBgP5za0KdW3OIP5M0HntFUj3bmFE/mZ58kuwuYA8PnKSy7IEMXjnNqCe5oF+mcfmPMzPZ+deBNAxwgZDUalx6ne3od0gTrOjRg0CUOACuFSTg5oyBJVoByLCwDTUyQheBCk0iopenOargK3CNeyCQJoXP
 BqIYYYSP
 c5QN4e7un1//V5vAwQWUFVoaHPMZoexQAELZzQpCFRvYQPKd7Trok8rvj3NCsbG47qfO8Tp9Cx5nwYPpcwTBDxHSipoFHlwhm9HCzhQV+gUnzQWdhgl9UvXW5/qjinfUz3FDLbaSZqKHTo4iFd3DX2reaUidEsJ6+0ZOTyeQtayfxU3u8a+rrMj9A9UvoP20c9w9+XgUxCnZ4QXO5LIEG3Bx9b6ysWIVAkN6SO4pxdL8kCwyZIf+cQHRS2In8pqX4uBobRXq1FeB8xu5lQVzdeJ+Iv3OKA7jsj8NS9FAyipuztKBCFdslktIC991gRr5Wzh4wXzk7HnffxxYLtKvGgSN2C9KZIjTqzPEJOPXHKSx7lEg7MIN6O6xd3NA1QQuHrKcw/N8JYCUQL9F44DyzSCN1n9Ayw8+XEoZik7+Ymbzq6IabYvuMwhn4b/Enxpfm4xi6uHu998Lt82HU8r8hU4G7/N2PWSH9gZ2x1Pqs7i6p949qfu4O+gtxxB4Gc13v58MhZKn4DHp6Quo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 at 13:26, Christian Brauner <brauner@kernel.org> wrote:
>
> On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> > +}
> > +
> > +static const struct dentry_operations luo_session_dentry_operations = {
> > +     .d_dname        = luo_session_dname,
> > +};
> > +
> > +static int luo_session_init_fs_context(struct fs_context *fc)
> > +{
> > +     struct pseudo_fs_context *ctx;
> > +
> > +     ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
>
> I'd just call that LUO_FS_MAGIC.

It's specific for the session fd, so I'd rather keep it as-is. Pasha
what do you think?

> > +     return 0;
> > +}
> > +
> > +static struct file_system_type luo_session_fs_type = {
> > +     .name = "luo_session",
> > +     .init_fs_context = luo_session_init_fs_context,
> > +     .kill_sb = kill_anon_super,
> > +};
> > +
> >  /* Create a "struct file" for session */
> >  static int luo_session_getfile(struct luo_session *session, struct file **filep)
>
> Luo is going full anti-pattern here. This whole return via a function
> argument completely messes up the later codepths. We don't do manual
> get_unused_fd_flags() flags and then file in new code, and then fail
> in-between:

This is getting a bit too complex for me and it's all existing stuff,
so I'll leave it for Pasha and the other maintainers to look at later,
they are CC'ed

> >  {
> > -     char name_buf[128];
> > +     char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH + 1];
> >       struct file *file;
> >
> >       lockdep_assert_held(&session->mutex);
> > -     snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session->name);
> > -     file = anon_inode_getfile(name_buf, &luo_session_fops, session, O_RDWR);
> > -     if (IS_ERR(file))
> > +
> > +     ihold(luo_session_inode);
>
> Right, you're now sharing the same inode among all luo sessions. So
> you've gained the ability to recognize luo inodes via fstatfs() but you
> still can't compare two luo session file descriptors for equality using
> stat() which is a major win and if you're doing this work anyway, let's
> just go the extra step.

I'm not aware of any use case for this, it wasn't even discussed, so
I'll leave this out for now, if the need comes up it can certainly be
revisited later. A singleton is nice as it saves some resources.

