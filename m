Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE08CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 17:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A164F6B0088; Wed, 24 Jun 2026 13:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EED86B008A; Wed, 24 Jun 2026 13:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE0C6B008C; Wed, 24 Jun 2026 13:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7A96B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:52:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EED848DBD6
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:52:25 +0000 (UTC)
X-FDA: 84915550650.01.BE4CBE6
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00BC0C000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:52:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vd5AY02w;
	spf=pass (imf28.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782323544;
	b=wPGjkkisSfTSY50JG+NpGJlYZc1vSP0QaSsrk7VSREprN7usRv8LJWm2n1DxOqS6RbDvgP
	xILNhd/ebPhrF9GsuIXvnEax5uEFaQHSkJfLwp/orjTPnuptUyZuy0BMLdla2CrwuFcGDj
	1vm0mmV++6y4OQ9B+a2v1p3yYPSA2Yc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782323544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yIQCK+bzs9AyvsQ75CttiaMe1DqI5YJnh3974Pl4HA=;
	b=3VYGv05GWEmCystD1v/JdezAfRZ6xHzQpoRMSZhFtTWN68CsVQJ0F8Oy7mvQmQsoIR3eEu
	9KPsUzdiyW6kOhWB0BjSsitRs4uHctC2aaIVNfOooUvtsmAkF5HooPaRIhseBiA3RhqkI3
	pCOFfRxDVVmrZuQcbyKByzcSn9DElgM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vd5AY02w;
	spf=pass (imf28.hostedemail.com: domain of avagin@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69e46524711so938883eaf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:52:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782323543; cv=none;
        d=google.com; s=arc-20240605;
        b=WQIsB4Qaoi6Q4EUV6od7fyE276rbC2Zzk+WZ1Z2SvoxiD/VaWKC625lc8ZfkzFpiqT
         cUqj4QUS3edvVih72mFau/CTn2sunvg7ZDrGeoySbDjWw9Zx5FmdwJz9e4PoRIPh5+7+
         oVfFJN75uBmT97ICaYiEqvN2jeCPLopOsjjruNVgMGgBVrB7sRo5SPAoU1sYpaAm/B5G
         oShNC0QT6ZIZCEL1qfaDc/JluD7Fq1FVCY7AabWd+EVFfRlclxRh5cApiTCK4MXwYD+a
         6+tleGpHgLqa5nJPv+l3ck4t4tB2TmUsIQ4xvvO7U3PkFviNzabIe6+ribt3XY+bH1IO
         nQqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3yIQCK+bzs9AyvsQ75CttiaMe1DqI5YJnh3974Pl4HA=;
        fh=ZgTKYr9R4IjFq4c7zhUbwuj4wWRQ9t3DXMJsRcpNX0k=;
        b=agf/KsYoDzXVzRKTgpIPWgdhTY/sruCO3fa6GVQnxqxBMry5InZYcXpwd2gHa7JEwo
         7htLF/ERdxYWi+N+bg/VfvOaJ8o7VAcVlvGe1mgzdRDcmnJa8eXt+s/8wFURwp16RaLg
         nKYjK6k3egBHFubEdPmeVOXjgrzg0J4K9DJBXyU6heeuHFKUXZ/C6kyIz2r96WGS3XJ2
         SsK3eT2GTWPCs0oonSHiasvwB0P57jGMXfXF7QiTWP4RP2XseR/V2ltWPHHwvgI+nTX/
         PGvU7KwEA+7KbKDw57fqcLn+mnvHJ+5r/Mp1SkaozYbA+MRWgbkM7iSW5IQPev4kSIpa
         VvLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782323543; x=1782928343; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yIQCK+bzs9AyvsQ75CttiaMe1DqI5YJnh3974Pl4HA=;
        b=Vd5AY02w4x2tKDPV4afkaY2FQ+m0aepOj3hMPPynfBtl6Xxrtlhc7DsO2fq1yaKw/v
         zBIw52BzkMOmas6w5lrYS89vdvu061SAdAoH80NzEL5OOw+taHVNSX1eorKwwGGRsjog
         tLqQZ8KTHOF/iromcv2RH04kBqoqESP0PbfIlU5f5HDk7wBYXTEeF9lmR//k08T7CoSg
         Auzpq+k1RbVw4csBgL4XbKBKk39KcjXAeFxMPZdNA+S4rMbWI3qrqjS1brEAY+Wi+xA9
         W8PO/Ggm1LrEsoBG464AWIs4VAFPGKT/1rwNF+0wG6YipbKvYy3fmOb6YqXQa5MpY2yk
         h2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782323543; x=1782928343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3yIQCK+bzs9AyvsQ75CttiaMe1DqI5YJnh3974Pl4HA=;
        b=f/WBBxxejYjbRtr9ZWqZIBmgyWuCOQ5aTHyWOfhXwECjRKVJzXD4Ot+i2+S+TKWxVp
         KHb45mIr2mNNCpRG/1Zd0qg23ZAHQZ0r3DduD7PkD6ZurUzQ1vZh7P3Ri6eOlKTJAHbA
         5huW3gWNIkfNUqvx6EoITVQK93UN/b1OZSrqhJywYUvm/8d9DX++ECn7zhNz5nA9U/oW
         MYdlpbwUBLiUPq3+SfhgXzpt1kkLKW9qXOKAUAwELflZtv4OXGCroolyFcdmMYMhxL+D
         i4M6cIyde2t8TukbtffqxLbV6OF/d+VYthhhZH8gCE+j7ANwSnseNxRUD2yoiznfKdA0
         PM4w==
X-Forwarded-Encrypted: i=1; AFNElJ8yXGChQOxBOh0YGZiZPRcIH1kPdRpLwrvn3KCVTwGiiyJrpkPwSMgxQO5U4Eirg7V4ZFf2bN+l8A==@kvack.org
X-Gm-Message-State: AOJu0YzeygjmlRffHRACnWM0hgiKhuN5G0xu5DyhDHPWFb9BrPk063QR
	s/6HFuW1hS/Do4+crh+/ENpaeCYI36htIFgSjRIlwsSUkT5mWzJa9yqdI3QDHaxzJqq5/2lqdMd
	wjoeWbUk8Z5kXaviUdo2w4kAHstpcGEg=
X-Gm-Gg: AfdE7cm2wCvf2X7GrPI75EJeyG/k+xYYs2WvKVEjnQeOIF5QIMEyyaQCP5NLJU/Ql71
	mR6u+SsnMla3iP5wTTcXb/Is5AW4vZlQMq0LAVVKFI7UpiL4sIXYPI11ruqqLPh0eUrR0/5is4k
	u15+jeqTwQdFgb9Viz+pbPLorXQlhBRsKuhlBBUkqapKn1TD6ZXgTDoIYO4NrYcSms+wSmst3+a
	layoXwBp14JUJyf584Fwj3SW9tTNg9bPTJZtlvAzPmCDf/Xg6s8QGoqvM/RfSvgr8lHuyw=
X-Received: by 2002:a05:6820:4d03:b0:6a1:10da:ab9d with SMTP id
 006d021491bc7-6a123056b05mr2754013eaf.15.1782323542879; Wed, 24 Jun 2026
 10:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
 <20260624071226.2272209-1-safinaskar@gmail.com>
In-Reply-To: <20260624071226.2272209-1-safinaskar@gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 24 Jun 2026 10:52:10 -0700
X-Gm-Features: AVVi8CfO4ShP8XHn8pnL2N4gaP9BD3pzKdndivNRe-NdNvS8dpf9qzg05LfmNXE
Message-ID: <CANaxB-xUrLQYGiRJZc4Boi+KX=0TJSWymErNovANVko20fMDVA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, alexander@mihalicyn.com, axboe@kernel.dk, 
	bernd@bsbernd.com, brauner@kernel.org, criu@lists.linux.dev, david@kernel.org, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, rostedt@goodmis.org, 
	torvalds@linux-foundation.org, val@packett.cool, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 00BC0C000C
X-Rspam-User: 
X-Stat-Signature: uakb151gm4nketuuzhyh11yw4jtzp7zu
X-HE-Tag: 1782323543-220155
X-HE-Meta: U2FsdGVkX18m8KodoEkoYfZ6R6gpbQkWgfQhE+UhmXnAe/4o+XlWU5z+qKDd0VJefH3nMiURwqcuUytLRPx7+GH6vmMqrCbNW/VR6Xp40/quMFnQF3Am9VYeOan1PYHJpYFms6e7t9PIacRNQPgn1jQMGBK8hJXqrxEBEN8mCr4KyzsFngEtHm+CtSNcBZmAA67FdyjWWaE0UjgQTFZAABsbbj6cf1egtTlfRc/Ez4hkQsQS9DsSK/pmOH26ibQjrZpVDJHRcxibVu1salrhMan7aIHtsZ3463wWOOG8uYQlQ7985LLLdTq/IChvrSb7wz7jsD44zRH9pntbzoJucnigOTEeDvTBEotq4gPoYC3DDzUxXZ+f+si8hcItAlzzseSWarDbescQfl6rOAcwF3EGHv0XAQlv+WSeRI17gyMYu0GQTTBNrKw2DBo3BtbaAVDIBVHgsEwbmg6ah6lq21K5qSP5E3ug5uoEf0s8VUl5e994sLAEcrXzthYrWjqOhkUYlVxJT2b/zb/kimC3Vm/K16pW6qEUqo6ss7hx7bVyo2lUlKAmw6oCdDcwTQOInzSqItlIhgA1aLEtdS4N3eAd7A3osusUTLwrDCOGBK3TzZZZ7XX5S2H1CdHJd5m6Qmv9WWSEuGVQDdxWJZZKV1V+xqtWvr2W5ytnjuYAsZM1hqeJtGuGu2y182YM++DU8awM/0MzC7+qIMGsI4bo1DwIPbbre0cRAeD3zknvCcIV7Ub1t23JAk5Kwe5tf5sl4ppgPv0f2KlYnl7So+kNIlxGT9LcD5SdAsp33gmRMPjvLwMs7R0iM9Z7odYumulv0rl8gdSdJTKcEfz6qu/G5IFyra0GZnsaxD00l/Xslv5ZKCH4kGYa1A8FEBOapea+HtwzpX8ev5MyrHEU6jCvaEVkC0pYM+IDqOXwFFR/chsca5C4hUeHde4oHysjWIaa6dbG7/6CrODVfDNtdPP
 QBEI0sXa
 i0hRbxtY44sP39+aOPBMNLaSPjJs1afIuTWPocvL0B1DW7j8CbSUmrSU5w/ibq8O9iwilEGMok7BbKe8dYUd1b8wIcCMHCR32BWeat7G5Yg5SJgBH4yPVMvaNC6BTxZx8KJHE5ee8Ds2gYmeO1s3a08C2WjaEVUBzBMKOeqdVCb3W+wGSPswV6KSRmvG5AusuA8p7kKrorR4XOw0fpoVDSmQ7lp2oyZrIdAmazh0qEEKtvPDrXZ/PjB7itH7F8Ur1film5afpjT3YCGn2W/XwYiGCbmyogkvU/9sW8fBxEJ7TeysG4YQlImLzFjK7z0w3TNtoA79r7xNO/YhAh++O7Ct9e30hEp7etF6GotMFrYE/TGerCrm5XV/TaRrltTwmsqvUY2x3UQ58VBCFvHXgAfTlast/FOBMfygjeZjXLL0iCzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 12:12=E2=80=AFAM Askar Safin <safinaskar@gmail.com>=
 wrote:
>
> Andrei Vagin <avagin@gmail.com>:
> > The CRIU fifo test fails with this change. The problem is that vmsplice
> > with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP=
.
> >
> > It seems we need a fix like this one:
> >
> > diff --git a/fs/pipe.c b/fs/pipe.c
> > index 429b0714ec57..6fc49e933727 100644
> > --- a/fs/pipe.c
> > +++ b/fs/pipe.c
> > @@ -1253,6 +1253,7 @@ static int fifo_open(struct inode *inode, struct
> > file *filp)
> >
> >         /* We can only do regular read/write on fifos */
> >         stream_open(inode, filp);
> > +       filp->f_mode |=3D FMODE_NOWAIT;
> >
> >         switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
> >         case FMODE_READ:
>
> Does CRIU actually rely on ability to do SPLICE_F_NONBLOCK vmsplice into
> named fifos? Or this is merely a test?

Yes, it does.

>
> If this is just a test, I think we need not to preserve this behavior.
>
> I did debian code search with regex "vmsplice.*SPLICE_F_NONBLOCK" and I
> found very few packages. And it seems all them use pipes, not named fifos=
.

In short, this isn't how such cases are handled in the kernel. The fix is
simple and should be applied to avoid breaking random software.

>
> (On speed: I still think that my vmsplice patches are good thing,
> despite performance regressions in CRIU.)

I already explained that this isn't just a perfomance degradation, it
actually breaks the pre-dump mechanism in CRIU. vmsplice is invoked from
our parasite code within the context of a user process, where execution
speed is critical. A heavy performance penalty completely invalidates
the pre-dump logic, making the feature useless.

Under normal circumstances, patches that cause this kind of breakage
would never be merged. However, since there are exceptions to every
rule, we should let the maintainers decide how to proceed here. In CRIU,
we have a backup plan to utilize process_vm_readv to dump process
memory. We already support this mode, but it isn't the default due to
performance concerns. If these patches are merged, it will be the
only option left for CRIU to implement pre-dumping.

However, we need to look at this case in a broader context. This is yet
another example where the change introduces a workflow breakage, meaning
there might be other workloads out there that could be broken by this
change.

At a minimum, we may need to consider a deprecation plan where vmsplice
with SPLICE_F_GIFT triggers a warning for a few releases before these
changes are applied. Alternatively, we could introduce the proposed
behavior alongside a sysctl to fall back to the old behavior and explicitly
state that this fallback path will be completely deprecated in a future ker=
nel
version.

Thanks,
Andrei

