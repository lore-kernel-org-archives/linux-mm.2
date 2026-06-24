Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966E9CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACF46B0088; Wed, 24 Jun 2026 15:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786146B008A; Wed, 24 Jun 2026 15:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B3C6B008C; Wed, 24 Jun 2026 15:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 400066B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:07:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA5851C5D95
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:07:09 +0000 (UTC)
X-FDA: 84915738978.28.30DF919
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id B711018000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:07:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s3ac2fEa;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782328027;
	b=iPIl3Je+RVvl3wP4X4f72bF/C7+CqAhCH3xJB6hS4es8so2uJodCtdl0lsI+JXiExbcpdX
	vnuc7t0pzjjkxW6j/8/vvNiKeOhqI95GFGXnq5h47kLWBx6d4yqmXWTT703RXYfEECGqsp
	NCxC6jzO6JocBSkR76V28HrZ/FQ7pBw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782328027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62RtAAMdOG7011x74VLOvyQrp7SFTtUxM8XkYksByVQ=;
	b=Bw8rvV4fZV7jWxCG/55R7a0nsmWv6fC2HwddFXGlXlKJ0lkoZO5rO8YfEd1s8L3oMZm2q8
	WmIKrRDUZhDFAom9q+nGr3nfFPsWXMOwCVGFFJZeYP/kIIw8w1dV3KjEpd2Rd3RU9iBOG4
	GDe9I5fBT0nSaaNbW8qPX2gqBHwnG7A=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s3ac2fEa;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490b613a17bso13768775e9.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782328026; cv=none;
        d=google.com; s=arc-20240605;
        b=ACSlTvn5Z/Wk8ov0cUQSxqX55mTM1nrYki8LQQEmo9VQt7coQS+1QAAeLberFsfzGH
         /2zlMpksSL0glqpK2/u8y9u0TeQMegSc1xpsW8Dg5prqUlfRpzHlgGjMH/poV9C5iCWe
         BjwXV5AbTxDkTzok41tQq1QUIlK74ivSzBG0/ZAZvr64dFoDarxOfL+FYCRou6Ix9Mq1
         0Tjdl64pq55JXLmkrjtG+r9ATKwRb9Bcyulgr3O3V0DcjHu6v0v+7CGLn7TRds9LYQIK
         5Mqzt54XXMpTpKtNMqcG7ph5s+/ywqrwaMhuCIuBYK4IbON4/PGnaCVwQ82EqmQJ9Dyz
         +S1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=62RtAAMdOG7011x74VLOvyQrp7SFTtUxM8XkYksByVQ=;
        fh=MhQ1ULO+W/XpxvM25x8nJOir+9Yaj8sZLbzIlLPfLaU=;
        b=eTDrN/SYAXHysbNU9NA16Jrrdw+Po+irSr4JU8Xmf5/uCMOESFyUl46OuD3GDT7i6H
         TzJfN93fObXxiABP9walwV2Hb0CIVG3VtaFifJOhW9FmBZ3rkOUcITBajJGzntP5PCUN
         si2txY6jzwzApx/ilDRb4S/X3eqkcXrbmGURmXfdEWQfn5dmB4wDUyuyw8P0+R0inbUE
         NMKhADch1HUWjEkr397qGsPLbBhzbRwhi5S2LDQ4JwsEHzGMGm+wX3kSSStskRh167CC
         T+YF0b8hsGJfsvQQr7SO5jLIyOQg9cIyH3/wg9PURYvf9TL3nt+oKjYJ6213RiwOLI4E
         v85A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782328026; x=1782932826; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62RtAAMdOG7011x74VLOvyQrp7SFTtUxM8XkYksByVQ=;
        b=s3ac2fEaR0kdpHcsR+m9MjOMCeCVpwVW4AantqzPBvsFV2D+rz7DheOA7wL6Luy2XJ
         +uJNpjSyf4gRS6j1ckV0fvjt4bd4qvSB8Q7jr4ZxchbGkIG56Hl0pP6wPZfGxDnknM4S
         ANNUe89XL4YsxrXngdrtTfO8oj/uu2pZp3WVYvFCmPGLZhJ09YctMbKcX9gNfRe7jSey
         m/bceeV9N+spslmZtNIDs2n3gpQoid6YMTaEWSxwjJSaNlztbGO0DshAfZ2LWoRKJgvX
         FH9k1Yam1Nf/Yk75JiI8TLxJHp5ztL/+mZmxgo7Dg3nyHTFmTK3Hg1RXYcBD/4E/p8sU
         m5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782328026; x=1782932826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=62RtAAMdOG7011x74VLOvyQrp7SFTtUxM8XkYksByVQ=;
        b=rtgYCEEX4aXjcnQWmnS7V2R2SBmsg3Q1Y3QKbAO3XKHapLxhBPdmglFA64/2iQp0W8
         eaoF2K0N3Z04etmH46DgC0Z/MZs8dc9Z90JY2kaxYzoMhu57TwsmgiQ/hfZwc4K+RTis
         JCQFbS1ouJB2vbO9qC1zzbcgCoDEGL8iffcc5+2SIqfIoe0kYFYAeOTR0+MT0wus6BJo
         FVwbiNvCtCxNG+rsiBlLf9Vvsdk2GGDrYA/7iEslPy/Bl+0GYDbCUuWvQK+9gxG8ZdF3
         WMOFjZQCa+NtpLd4D0RzbyBo/TpKRXMgvnJpeQgPZWqdirPDCZXfyfag/6+J0jNnbo9S
         /jcA==
X-Forwarded-Encrypted: i=1; AFNElJ+ctK2m4g8D9ymWjwDAe/s1KM6xbrHWbM+8FNzK81Q6dA4NfbmoNuOQmwG7nFMMdJINw4RUWB91lA==@kvack.org
X-Gm-Message-State: AOJu0Yyj0jBnNE15wuS8inZMDS5+ISXWWfvUd6fOSXyGMKavsc4oL1zb
	wZMtQaeoZIOaj14Uee7ZnQ0/XNt5Hs8+fAuk4s8vzWABIzOWf+aHfSPRIe0MeZtgMLNvxx4Gx98
	OP9sSDH1mKA+UW7mUf4a9iNQ70YiBIN4=
X-Gm-Gg: AfdE7cmxjhm/o+Sd6DKiM6p+ZEAhVG1Y6CIqaQIKqucZ4/IS8lwjzYo4VNRKPhrpoGb
	dUrvaQYM1OmmuKSPctl/JV0PbzD5dOmD4Hca4Q0cG//w7NzuoGd39a3ruHyvwyZ1gXiF8E1uS/F
	AWGHCOnsLPq9qzytuzQ/2XjiFjG6scG+4TTKgTnh2oRZp8GtrOKABw+ilAoI02mXUNx7qURSie7
	aUU+1M6aVf6gwzvSZnQo8X/0fGYVbO7nxx1dLciCQs4cilaZkD4Chgn47CmLxwCX1hyUdSf7SJH
	LoolFkR4+sl5/jhR+o70Gfmpq2BHVvLa1S+2R3k=
X-Received: by 2002:a05:600c:a51:b0:492:379c:32ee with SMTP id
 5b1f17b1804b1-49249083c09mr358068975e9.6.1782328025896; Wed, 24 Jun 2026
 12:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-3-ptikhomirov@virtuozzo.com> <CAKEwX=OaKTfNqzwa=djLxZDeBbR1+DKdqDnxdfPfZFKB-K+ECA@mail.gmail.com>
 <c390081b-7b2e-4b83-9bca-5f93eec6a939@virtuozzo.com> <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhPROaeEyYceKNsL5QVwVPkTjGtbRr1P_TYXTA0fHvRoA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 12:06:54 -0700
X-Gm-Features: AVVi8Cef9aZmI2zHP0TU9bg-9tvoxUc7Rq0PSUmFsfd-hngauFECj4f6N_uHz4Q
Message-ID: <CAKEwX=MedyK8aDM=oe=Hbzo77mJOEp0Pmo0u8N4HhvikosVbSw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: support cachestat() syscall on overlayfs files
To: Amir Goldstein <amir73il@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fiierqfqdtfh7kqturbqyg3crz7rdzfy
X-Rspamd-Queue-Id: B711018000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782328027-27657
X-HE-Meta: U2FsdGVkX19uk/On1XNzSwIeTVQ5SMsI6NNBgnl3yO+EgUq9hmck/vknuZrbU4j29AKOhZ4pU8UTz2qjScVezQQJ1/VSKGnuFjN7qQB83a8J760MC7Gg2sEXbxnHbulLst3lO/mDkt7ce/KnZuc8A00p3ufGP9sqHcwG+Fd6wiU7psPAF56lv65Y6BSPeyIVR17m/hFUgMLYlrJ5j43SlWCzGO4Ezor4QUVN9YYuQb+V82ut2dQ1LchxatMcUIaKduSfOXc7JMeXp35LYdblgABZYTS2tKDtgAPiUtpw/PvExloAoFwsNmr+EULjsKMjZLtMgTDiC8R0sL3k3Od+xcK2kdXKk8hz6u8RNO7mDZu4NLWZzehz0Ht51E5EQVpxiUWXJcX+xQkxgyg/2Kx5TBKRpQlW4NjnftcI99i9EyHdtx1AtTkPzjcrFW56xryhYGx6Ntb3LK82+5CFwInKnfQnnJ5NBKc4+O2UlRR9sXqPw4sm6l+/M3qKty8nLl78e+AM9JNi1gODwzJcBst8vrq9k2Lfnz3/QDqLZiHBoKLArzKupwfQUUk+6e79MogxoqvpWxCEJGDnlfy6L1W1ky3tCObllW/qHs4cfwpO4fpRTQGYziO5oTJ1KFo/fN8ZZngeIieFEoVUyO7i9HodWhwHqe1/zTaCGrOb1mPl2fOE3CNWMzV/rxRdiHCr3weyqJRncEKm9OXF61PI2ZVgbbbMVirZ6CEWMWF2Xb5sgQUsgN5cHdrpEv22fmRr8sKgxDAUPsEuxUHytlMae0f7v3FNg7dLWRJ7/gwqMONTA5myhm1Cl9bSZRXfHRxGGa5P1RcMyqOIgC2rdltc8DAPIDJYTgkli3V9W04mcFbopDVXZMuiOlScFFMGKWLjXptaIPv0VpGjGePlphRGfRDO8s4v7cdxa+yQb4bW8XbuhfQM4BHjDpDJbBDIMHdUO7GiNa1T3/HCWI/pkQS+gC+
 bOZjVBYm
 3tpo7W+NwSo978Miga5ErdwLCklSaxUEC8NoUcOi5NHV9CWGmnqJwFdAp/oaIGPA0FnNTpLQIPZflNgq0+wDKtX//rFF0YZ/F3F5zfR/Wl368VwWYuMz2VpbtwdafQvgLuQnZeqDrH6duuEUtLw2xWd3e6M+Tzx4sT3v/ZDmRxF2qfKcIbHkSDkzwLi1bk+ZM3njnoEtuCRj8rPVr7Jf2s2hSgRnHiVy8Z4KMjMeYda0MRmHiSBWLVAnrAiSIJKRRKL0ESDigauE0ADIPr5qgzVU8qglRefG1p2GgDRt5RtBaeqasAVKe+HoeEe7gI3N0Pd6LaHkAIyQvQ2oacq/r+puEAj9LN3zFNDGCdsE7pzb2rdwF3O8oLZkeoaOJLW3I9kOrC4JzW0knePrdO3GmOnCBe5z3Wbl/X8IQTQhScIkmCzb5Ll/YlX2TTBxJkME6INsYg7VxbsfHMkWDZWFR5Aqvi+FKuz37Oz5+z0t/ebF69YA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 7:16=E2=80=AFAM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Jun 24, 2026 at 1:45=E2=80=AFPM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
> >
> >
> >
> > On 6/23/26 19:12, Nhat Pham wrote:
> > > On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
> > > <ptikhomirov@virtuozzo.com> wrote:
> > >>
> > >> Overlayfs forwards data I/O to the real (upper/lower) file, so the p=
age
> > >> cache lives in the real inode's mapping and cachestat() on an overla=
y
> > >> fd returned all zeroes.
> > >>
> > >> Implement the ->cachestat() file operation by forwarding to the real
> > >> file via vfs_cachestat(), the same way ovl_fadvise() forwards
> > >> for fadvise.
> > >>
> > >> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> > >> ---
> > >>  fs/overlayfs/file.c | 18 ++++++++++++++++++
> > >>  1 file changed, 18 insertions(+)
> > >>
> > >> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > >> index 27cc07738f33b..a7e252a91ea43 100644
> > >> --- a/fs/overlayfs/file.c
> > >> +++ b/fs/overlayfs/file.c
> > >> @@ -518,6 +518,21 @@ static int ovl_fadvise(struct file *file, loff_=
t offset, loff_t len, int advice)
> > >>                 return vfs_fadvise(realfile, offset, len, advice);
> > >>  }
> > >>
> > >> +#ifdef CONFIG_CACHESTAT_SYSCALL
> > >> +static int ovl_cachestat(struct file *file, struct cachestat_range =
*csr,
> > >> +                        struct cachestat *cs)
> > >> +{
> > >> +       struct file *realfile;
> > >> +
> > >> +       realfile =3D ovl_real_file(file);
> > >> +       if (IS_ERR(realfile))
> > >> +               return PTR_ERR(realfile);
> > >
> > > We're propagating the error of ovl_real_file() all the way to
> > > userspace right? I think we need to handle this.
> > >
> > > For example, we might get -EIO here, which is unexpected and
> > > undocumented from cachestat's POV.
> > >
> > > Maybe handle it and just return -EBADF or sth like that (with some
> > > updated documentations, etc.)
> > >
> > > The rest LGTM, but I'll let overlayfs maintainers check the
> > > overlayfs-specific bits :)
> >
> > Yeh, we probably can use EBADF here instead of propagating:
> >
> > Man cachestat(2) says:
> >
> >   EBADF  Invalid file descriptor.
> >
> > not really a bad fd here, but probably close enough not to rewrite man.
>
> Please don't do that.
>
> Re-read what you just wrote - it is ridiculous
> Because of being lazy to update man page,
> we are going to send a confusing error to user which tells them
> that their fd is wrong, which it is not.

I don't think we're being lazy here. It's technically more work to
handle errors and updating documentations :)

I'm more concerned with undocumented/unexpected behavior (error type
in this case). -EIO was an example that I saw in ovl_real_file()
itself, but I'm not familiar enough with overlayfs to know if that's
the extent of it.

But I'm OK with just updating the documentation with a simple note
that other error maybe propagated from the underlying fs, if no one
else thinks it's a problem :)

>
> >
> > I'm a bit hesitant though, since in other overlayfs operations we alrea=
dy
> > propagate, maybe that was by design?
> >
>
> Exactly, plenty of overlayfs operations return EIO for unexpected
> conditions, often accompanied with some assertion as is the case
> with ovl_real_file().
>
> Even though many man pages don't document an explicit EIO error
> code, it is obvious to any experienced sys admin that if EIO is observed
> they should look at the kernel logs, because an underlying subsystem
> may have reported critical errors.
>
> But in general, man pages follow development, not the other way around.

Fair point.

>
> Thanks,
> Amir.

