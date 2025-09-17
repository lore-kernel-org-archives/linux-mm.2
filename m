Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4ABACAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BCA8E0076; Wed, 17 Sep 2025 17:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13A88E006B; Wed, 17 Sep 2025 17:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29388E0076; Wed, 17 Sep 2025 17:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D080D8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:18:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85CA41DE9F4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:18:48 +0000 (UTC)
X-FDA: 83900006736.11.7ECB214
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8C650A0011
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:18:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nIdmGpV3;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758143926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+4zDUZvcLkjNXzlt5Aq3+g1zpnB50vN9F3ZvcF1/wc=;
	b=cEIGAx9jf4cJwaXwiAEN8IppgVGeALesAxcJRKiTmMtQ/In5G+N7Zr740sVYzNSTOT5vjY
	J8xLlfNvys/cU9riRFvLxUtywGTBLqd1ONvnS3a9Gd/chMBQYKEXsqvroXTemH5MFk7bFe
	aAkPYtNnxRms3uAzNcwEQ8kyeWZ8qrQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758143926; a=rsa-sha256;
	cv=none;
	b=KjRLvbHOUccc2q/4FvTkrybmaONvqaKruuQDlT6McSTjdObHle1mitYmr3tVgd61FxNKx0
	OkApNJVn2joRV7xs0vsHzqNlc02RTcdm3uhLGd/bhqv1TeacGJubw6/DsJUzApK3XZOw7C
	RlGjbVl+skSiGX4C4YmtvKYfVG8A2n4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nIdmGpV3;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-62f1987d446so304252a12.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758143925; x=1758748725; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+4zDUZvcLkjNXzlt5Aq3+g1zpnB50vN9F3ZvcF1/wc=;
        b=nIdmGpV33XgF5qf/J57ffFKUUErnHtn2Z73moO3VIy5s7nt9aaNjJMC73cRNHJyOgg
         DHf4Dni5s04yVj+aE+Xjp1sbwHmYs740DMKoUje8+ttt7Q9C6zl3XkoLhCmJGdzQbNc1
         lxk1eEWi+6gvy8ztTlFvDpcY9UuxegU8hS7QPajcBF3zMXqGGolMhUpifZyZ1L0y4I1i
         ZzNBGkhW9URC/xjhp2+E51lJS6/UbC0OufJc+Z5jBkGmGhXlX0o5E6GDLFZxQRm8VIcr
         X1pYnSLsXVbc/0gtfp6PcoJC1j+KQhYBnUlumY+IcAx4AqT60pygkQ5GWnuKbpYaRm4k
         secg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758143925; x=1758748725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+4zDUZvcLkjNXzlt5Aq3+g1zpnB50vN9F3ZvcF1/wc=;
        b=dVRgktVAyrhjzCXgnG/eNp/AMd0PrkA6P80gfDWNWGTaZFMaN04GdleH2uRCO0yW63
         2yb6AeIPnnO9iny4FSB5k+h8TU2cDqVEoeXlEpSPig/QknvVIRozarfA+zGVAUX0igDI
         ZxamE62IkeGSdINoodHUjuRtUn1F2bS0wvO3nAaqW57Ik8tNaqARJ8yH3B7KsyCHuhym
         qEiHlk2gAtr/7hC+gKaXqfovM5lkiIJ4Auzb6RdcTPXyl+rpplySY6tCaPCkaAFaEnSD
         yPQb3bY4w6ne6FQodj91dlT3nSvkpxfSOS/OZfy7ROwRwWmXfm7D/vJAJab7Jo9OTvq8
         9ilA==
X-Forwarded-Encrypted: i=1; AJvYcCUaDwNRAFGVl4gLX0yvK6CdcJB7lbKUonA05yS+hcSn+DUyBuNCa9AmQ1fnmCtKduSSnu0TgNh1wA==@kvack.org
X-Gm-Message-State: AOJu0Yzwpw2f6otEbk0pic2h7PX7MWi9L/4Sf37mxB3yqMhiypr/Efyn
	r7+CpQEbQqq7yvk0sWzOaja5TvPDDh4vTSLO95TQ0b28C7jm+uQmn60ukn7MZzRk8j8pt27Cssc
	E8QcxVdhFvQ2eej/XwMOyJmGbksWLJn0=
X-Gm-Gg: ASbGncs52+dUJf7vbpIJSfcTKR7nTm3lYDE3DJdIaUtL2/V1knM7vtXqyDtFy/f5XfW
	hlpASuuc5/mU/FxNdVxmG+k1Iofd5okO0z9jyGD6KuF9GFRoV5tOe3VSRXyJKqScsRpPjLIA4hq
	zoYAOGm4SVBSsJaCafvbBfwWjRuBpiD0AECuHP0Idu7UiZiom0REJ2EGRRdbve89TO8Rs2m/j13
	r6eCxMyfMlP5eKbJtUcm2peLH8mYKVO6YX0vq+IHRs7yIVMKzd5PemJPm2/hqi+A1Av
X-Google-Smtp-Source: AGHT+IGFkUjrPG1jXZau1U7BaKFkQzm7O6SgJWCgDvQsw2T7Ujvbun5mQ/1iWGF5UyEcyRSk+fAqmVZS/fniGxkTHIQ=
X-Received: by 2002:a05:6402:3496:b0:62f:391c:81d9 with SMTP id
 4fb4d7f45d1cf-62f84465dbdmr3588278a12.24.1758143924916; Wed, 17 Sep 2025
 14:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV> <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
 <20250917210241.GD39973@ZenIV>
In-Reply-To: <20250917210241.GD39973@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 23:18:32 +0200
X-Gm-Features: AS18NWCkia-Sx0-wjO0zxGoUs9dltKFlKpfhwDC2lrItr-gr9dXtrlhzF4HaAbI
Message-ID: <CAGudoHHnNpJViGU-HaYOKNw0EGqT3vHn819zDLOMJAoqkLUQwQ@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z49b8yamuykthx3jgp65fc6tp4un8p6k
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C650A0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758143926-11017
X-HE-Meta: U2FsdGVkX1/JJOtiD1Dko8XDVxdiQR31gozxeU6+q3M3588+pQV+fsmAgqB4UOrDFnl3vgNWYr9n344xRmATTqsl7ko9LVfOKBSSZyzq6i/uUVXj/pCzD4uJhOoOWaUJnqxrHCcS1PXVXaLvDhEJMKt7eBzj+K3dMnyeM9yGihBji/DMMGX8YY4glmk9BoYTyqZ+KJH00gMjMoLMp0iEjZkDs0omL1dZ7zU4GB8pNx3PIeNwv+gfHmZ/VuF7jrGwtvmgok0tCpkdUsVS6M2Qgo4Xy9fiZSloxSnO4vxtFxWue1jVvM4o1ijz6tf0l0VlahAvLZS/k1gQE8CiH0E17t1YGzHrJeK12CnYLXcvE01MicOF+Z51+1cBgVNWxkGjFk+3Ny/7xBnwVy+abqmGDZSLIaaKVkDEH+5kBol6pPf1jtW5fLVDp5xerD/fx2Ilfb4S4Fr/l4NUO+O7SwgK4DbhuE90GXFMkz9TotwTLam/n6E8uTWvO/8/XEqxTgmENNwD6Yfihr2Kfq37fANoNFz2WBs7oCQA61WaZ0REDv2uuBNkbWUxbom7iKQH5Q3RAda8RKFaVq0S4H027yct2ec8au8QlNTWdyuy+RGYU4YVHGRA/P6CZs2SutktOPpJyuakLocR37OOv45fQrH5qI7UOr0WrE8nBHWbEq756WCXy6ePx/6LWlObkNyh2x/Ow5xikmJ9czrQVbmPzO7h7g5xAEsjVXP8paMJLkYKK6wqIK61LwJOZvnigX8twhuh9GBub1yuqKOhfsG9lzLwRQjeBpaVcKqiqWpFqeVvF4KpR7FzxEag3TL28zwQJ7GtGSh9gWY9y4MAVSJWWT2yGbdouYPW96GPjw4d6CQYg97SLxd0kGV0NnRYAHq93nQiE8pts3OTwvbNn24ShsOGQjqERfSsXdqNzUPv+YFWAA24fBHajP1MkLwGVfdYoTnxWfCusIhGeRd9Xg//DvY
 OUDkiULI
 sCq5NIaC4uz9zEgB1P/+wA0O41VFtQupyQh0NkHIy0nJxbfuaCJOhxfVuI5bgZtSE5LIuUu+H/UkFNrjoYNPPNUF+IDqVR9pH8zFKO7NZAcYHXcJvaOKfYXpIPWiBEeYKiJhZJSY4R0DH0UUXJLdBKeQs8YkW0N3D8nDh8aTxVdUU0wUmFS0fuLF6FxkrBooW34yiEulcU9L4UgMttPxWLHOeRtgA/JrQ64Dw3e55WYj1aXgKTV4pJwqLTZ99Yu87ohPpflun9STc4FKyWdyHbvuWyR74d/aYRbb8t0Hu2VCIMFRGjl3r3MUvtzZ/1LPpPenvz1Xpjy151ZTazYhFX527dzOyoiKYeu6DGFWuOmGkKHkBjFUTciDwxKXb+jNFoWkcpFpW71umfCbpHm0oB2vvfpba705TfKDa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:02=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:39:22PM +0200, Mateusz Guzik wrote:
>
> > Linux has to have something of the sort for dentries, otherwise the
> > current fput stuff would not be safe. I find it surprising to learn
> > inodes are treated differently.
>
> If you are looking at vnode counterparts, dentries are closer to that.
> Inodes are secondary.
>
> And no, it's not a "wait for references to go away" - every file holds
> a _pair_ of references, one to mount and another to dentry.
>

That I know, I just blindly assumed inodes also stall teardown in some
way. That said I see generic_shutdown_super() and indeed it works as
you described and now as I assumed.

> Additional references to mount =3D> umount() gets -EBUSY, lazy umount()
> (with MNT_DETACH) gets the sucker removed from the mount tree, with
> shutdown deferred (at least) until the last reference to mount goes away.
>
> Once the mount refcount hits zero and the damn thing gets taken apart,
> an active reference to superblock (i.e. to filesystem instance) is
> dropped.
>
> If that was not the last one (e.g. it's mounted elsewhere as well), we
> are not waiting for anything.  If it *was* the last active ref, we
> shut the filesystem instance down; that's _it_ - once you are into
> ->kill_sb(), it's all over.
>

Ye I see. Thanks for the breakdown.

> Linux VFS is seriously different from Heidemann's-derived ones you'll fin=
d in
> BSD land these days.  Different taxonomy of objects, among other things..=
.

So I keep finding.

But in this case I have to mention btrfs has some hand-rolled delayed
iput (see btrfs_run_delayed_iputs et al), perhaps something you may
want to take look at if you had not.

More importantly though, that's 2 filesystems which would like to do
async iput. Would be nice(tm) if the layer provided a helper to do it
safely.

