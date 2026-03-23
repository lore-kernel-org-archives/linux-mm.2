Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C79F46126
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3E96B0005; Mon, 23 Mar 2026 10:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBB36B0088; Mon, 23 Mar 2026 10:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1546B0092; Mon, 23 Mar 2026 10:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEC016B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:13:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A18A16087C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:13:02 +0000 (UTC)
X-FDA: 84577519404.05.E0225D4
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6033940002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:13:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bztq76PE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774275180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYr4H7Qc1JW2lOr57BNU90w82iHcpZfVMmSZ/RMRf1o=;
	b=4e3lZ3j9xodb4+knNAESjbwSxc3ZEj+0qWAjEZKBNWTjDDHvHEiBjke11tT5WZ1bNygiwK
	dgF/OlSuY1KL9zrENdv7iB4Jja6ZSn7p8Ot4FQlGYOq6yl08xwLRh1+9PSJDUyKWm2tkZT
	I/qUvlZrLQzLARDJJUHz7vzKVGf94Yo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774275180; a=rsa-sha256;
	cv=pass;
	b=Xoj1fc6D8C6H3ubD0K8IW2t1o4r0wQII5Hacn/p1DfKptbVCfo/p2O36rewueoopwKCZCT
	zcGP5MFkh3FFuDg7kFr8+DoNFAxfLIa18R+WDCeiEGkQvRi8gjni6m4OT+bXeM5GTBVL/u
	3+FmlxrMle/AXh7UZ5eqW6QFyOMYf7o=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bztq76PE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-667de793310so599784a12.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774275179; cv=none;
        d=google.com; s=arc-20240605;
        b=Zn5oGOmARJJdkRQvE+HFU9I8kf0K5EVACDVootWT3Kq2vUrENOXnL0RBs9bIt5QS5x
         /9FOtuHbdrN38RTQe7+pSbGVurkk+Przg52CfMfTSC59MEGokoQZDdUgXAaT2QigS4/Y
         boabcl/MOJdcCiJ14wgtAqk8UXnrcsP6FX9C9/u6A77NK5rIGstg1Qbe/lmvWt3L4rzl
         4zU4eZNceGeC1c1xeNwJQl51dNzbxJRdEErBUZLDzwNT9CTT2kk4G5sRtiqUr7F2rSkJ
         tvIqHRWT4/ZAHiL27768Gi2+apQ0Xa8ZDtQSWUh+LxmW+/defcFBats4GkYukqvWF9KT
         i5Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wYr4H7Qc1JW2lOr57BNU90w82iHcpZfVMmSZ/RMRf1o=;
        fh=KizwLBMr9C9DGUDs6q9wJ1hQPBA9HFYe2ZT+XpLEYqQ=;
        b=f39TvrVbPJbpx+RbeAk59WQFYPca12vqM7IhWrM29SAZklfYGXBsbhH20djRfwecCC
         LDw/DOEm1Gcu4SHHzNoEjtg8FJkuy5UW5Zy+TRZe7FHY7trzSqnqvBGn09fTYzXrB/QC
         InJdncAK26EyBaeWCaqZ24bvBUE/j2BY4mmIEPUXCFI9snd0XFn/m9gGESfJ6ft70gDd
         L2+3srKCOHcCRt/gSYUgJyaq5DUG3/6pYrARb0uENDkCad8godihDlAaY2lyhbqY5jCR
         mloiF7Y9SoNQncO3gRR8/zclz+91xgpCgF/29eMqNS2jJvnREsal9jznLA4kv48guQg0
         5RLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774275179; x=1774879979; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYr4H7Qc1JW2lOr57BNU90w82iHcpZfVMmSZ/RMRf1o=;
        b=bztq76PE+9Gs/M4Q0x9ypOLOM3VYv5tVQ8P49yyS1m9fgcjn7k4fdResSYWJCKaNUJ
         YcN8W3ZRPlq0bb/y0ZvF/W790DlZm00wr8sxmOcB4qQE+xKkKThULwebo1BC+hMKBAn2
         TVEcsedBg/bF0Xe6BZi0vKMX37MODO4tmjIZu3wVq8ISaUsQgd+o/szOD9BUzAtbjgim
         rOhKQAgpw2mdxVDGqFeSiCHhvjbd1OpzSf29WldGqUN26AfD7APuVPzTn5JbmD1qLtiw
         PfaH61YfaD7NcVRlQY0K+DFYM1IAWvBVH5ZQ4ADb9LlKF/WOMYmhFllmjqhp0e90Ot4O
         BS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774275179; x=1774879979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wYr4H7Qc1JW2lOr57BNU90w82iHcpZfVMmSZ/RMRf1o=;
        b=KgMf7dfJPBwW+DURERPgxNZLZdoj0nmHIQt25n6U+NtCKkMlTvwhDpfV3O3QwSbm7g
         CSXET+Xr/Bdms0qumba8VMhKhR5aKnf51vWmW81zJbnrAcY4yBlNwSmxN7tCaO1MnKdp
         HmN3GxgpO6NhPilldwF4NCYdnq1X342YssohUiE2dGvOSL7cjOx0oWLXtenTJ4aWDcCX
         cm6Cf0mOr+gIE+2wni92r0rM0NklQ4U+E2cDFi6zolc52F47yzwqgmCHMsoo48R8qXIm
         CmGmIHtbW6xwNi2ntzcCv0iSXAgV/NwonfBvD4VbulRmrsnV+RGmY0n5DC3HdB3I26sw
         m9+g==
X-Forwarded-Encrypted: i=1; AJvYcCUEkKczTUL38D7tqz/NH8/vGnoVefHu1fa16EX24j7tLR5RmITtXQRfL+UvAcfYxDa8M70T5QiiCw==@kvack.org
X-Gm-Message-State: AOJu0YxcyGwdrZoj9LN9aHKSUWvzpJYa/cWr7O7FHcBeporRm7HLtBDJ
	lXvXI2e1EpVDdfvArj+5Zgqxa5fmTlAWJEGcXMYtScs4XLUbmKOLu+WVJZ0zftNh382HJmPrhLU
	89C1WqjM/T1OQLt/FyTYvhjFEMBmsO5UIG48YeUKEFg==
X-Gm-Gg: ATEYQzzijTRnEke7Hk9WMIf4GGDAFbyErT0Jh6vKflDAOiGh/XfRQStVfquoiZKL2JP
	5lR3PL7DstdHXG/ucRzyoCyAZPCFQMnbi0ghzGCI5e5QC+LjRE13voyu/zSD9mgh5cf997RLxVm
	Rej37PRf6HmlWCqufICAMbZ+y5J/uYnaYELcnSmRQ7x6npF5bZx65o5ScyN8l8lC6U3f2TM1Z4J
	lzPN2l5RdLlcA9j9YRToMl/9A43oivytwpxzIIw9duL4VXYwcOvyRCyhycnil7xVpUVkCBdgLfm
	VTuz2ok5qUCBr02MDgDS9vahzNBD0sCA+V5RLw==
X-Received: by 2002:a05:6402:380c:b0:663:dfd2:6c94 with SMTP id
 4fb4d7f45d1cf-668ca31c297mr7921141a12.30.1774275178540; Mon, 23 Mar 2026
 07:12:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260321143642.166313-1-oskar@gerlicz.space> <20260321143642.166313-2-oskar@gerlicz.space>
 <CA+CK2bCVge7xybLshgLLphHAdRSHMLD3egT1nEyESBUFi7kHCw@mail.gmail.com>
In-Reply-To: <CA+CK2bCVge7xybLshgLLphHAdRSHMLD3egT1nEyESBUFi7kHCw@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 23 Mar 2026 10:12:21 -0400
X-Gm-Features: AQROBzB4CJo-Q6aqcjHwweredVmDHdcxO42AcEjPRWBK_-LL7WH4i_ce90Z2WLk
Message-ID: <CA+CK2bDvv44+YLX6PcTOX_8eM5iET0RrC3gS4BCjMQRUjOSF1g@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] kexec: abort liveupdate handover on kernel_kexec() unwind
To: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Cc: Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6033940002
X-Stat-Signature: eg437dcuo9odjsnyguq8fny9f9czqfmk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774275180-582453
X-HE-Meta: U2FsdGVkX1+y8l38fIjE7jOdNpgWhDiCi5+alpLgYzoloGa6nfa/1twtVKLxcVn/ctlaUHAyIAH7F3E5AxgQBIgXSAE5WMT5i2cFBMm6QWqScxN+XlW/asvDO2RktJBA+BgKkyDXWdg3sBOVJ4jwJJdQbRW6t7fihabRTkIBhT6SjFaBiHdSZZit7S32jZaGxZ3pGBW0pGg95oOQINacX0lcY/9wqqYtbternR5FiLs4II2gto77anP3oBjwYv3fvzYoSKbPx+oafiwm5EeSD8fb4rblJjHDwUDHpbJCIHEVeTh39GM4R4VMhqwoju8ozixeJSoadneJ0oTLaWN7hFOnN4zy0OvWk0K53r7v0nh5PRnTPWtxdqwV1LnCF9ZkwoP+noNnbo1VWIppbnHzMGKbeHWRXffQ93cM5SnrHrlyGZCAhnHL9wuBz1Do8cKED8d1rxGJF9rvawqpAsUBHDapGWC3GqYSbHfsz/t701UIVrWkKtPnXy7fL6/KgeD18xpZUmYlTzpX2DS+OHMDuzQhfpFKVxdvvHlI86Kn45BuDkKUtqism/xJk8BA8LSgJ9Xaqc9BP9QgDYLPvBuJ3LgtEowvm8/Aw8KQU62jYE/9d8c7u9gIBiRqWp9G/ikfY72waiK++/jItrQLIZktveWEbtkx4whOUFxhbMQhnHaZDN5xLhyDCuYhJWzKkQ50dFPdceUe9q5pvExohn/qOYs3WyTdojCM+kQVokruhT1f7wWSmFvtxC42lBL6LC7GiFvwgsnzuCaccAab10RQe3Zjf53n0R7VawE0aBsVuva2iEKA8iCtmOsC75siAIbzjyPei9bDzKyfedonxfmHqqakJUWQ/ZhTTYSGctQNsjQX4Y88GzDT23ZDpFySfzOwXdf0wK1fvKyVdzbkseTorVTa5QaN34T6ug5LuxrAjkx3f4Kj0d+YLH0PM91R1v239Nw3/TsdpQxL/SpMTLs
 OR36V/ic
 /55B3fWZq5FEuUvhAw+RW4SCvAOYazQ/kXjOA9d04WTPiYUv1DCoVnsE9p26Tm0Z/waFOHsOxIgj22qnCYnheI7ZsXLwIvJpolJv0M3hK5L9R5/Ku3f52KVnkVAy0iWr2+1KBMyuo8o+2qziyQNHasy8xy7VVFzpPljFCVZ/rUlId6APewd/5Js4XbXELtZ0uQ1m1jXUGKbPL1y7JqUGkrJ7Qm6JGv+NT5Gn6H70R2KeFEDXEigCPFtSSE60o1pAP9v4MoAl4tXEwFRNTp69uTckRPOsyeKZcCKcj9FXQszEhk6LyXuuwG57LSuT25dFQdNam7Tf8onGwObhDOYPUefRnlpi33GpKl626igINi1sXv14FSLILIFFd8d0SIgRQ5T66GawiVm6yyzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 7:05=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Sat, Mar 21, 2026 at 10:39=E2=80=AFAM Oskar Gerlicz Kowalczuk
> <oskar@gerlicz.space> wrote:
> >
> > liveupdate_reboot() can freeze outgoing session state before the kexec
> > transition completes. v2 only unwound that state when kernel_kexec()
> > returned a non-zero error, which misses the preserve_context path where
> > machine_kexec() can return to the old kernel with error =3D=3D 0.
> >
> > If that return path skips the abort, outgoing sessions remain stuck in
> > the reboot state and later user space operations cannot make progress.
> >
> > Treat every return to the original kernel after a prepared liveupdate
> > handover as an unwind point and call liveupdate_reboot_abort() there as
> > well.
> >
> > Fixes: 8b32d3ced269 ("kexec: abort liveupdate handover on kernel_kexec(=
) unwind")
> > Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
>
> AFAIK, preserve-context reboot is no longer used; in fact, it is
> currently broken. I tried using it six years ago and hit an old
> spinlock bug in the x86 code that prevented it, which means this path
> touches dead code.
>
> It was originally developed for machines lacking hardware support for
> hibernation, and I can't imagine anyone using it today. (I know Amazon
> is using it for a non intended reason and that is a very specific
> scenario in a costumized kernel that internally fixes the upstream
> bugs, and would not conlict with live update).
>
> During live update, we cannot return to userspace after a successful
> liveupdate_reboot(). We specifically place liveupdate_reboot() in the
> kexec path as the last possible point of failure. Perhap, to guarantee
> this behavior, we could  add !KEXEC_JUMP as a dependency to KHO and
> LUO or crash the kernel.

So, I think the right approach to address this issue is simply skip
liveupdate_reboot() call when we are doing preserve context kexec.
With preserve context we are going to get back to the current kernel,
there is absolutly no need to do serialization. So something like this
should work:
https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/commit/?=
h=3Dluo-reboot-sync/rfc/1&id=3Db13cf19ebbf2f8483a3c5a61a7358611b391edf6

>
> Pasha
>
> > ---
> >  include/linux/liveupdate.h       |  5 +++++
> >  kernel/kexec_core.c              |  6 +++++-
> >  kernel/liveupdate/luo_core.c     | 11 ++++++++++-
> >  kernel/liveupdate/luo_internal.h |  1 +
> >  kernel/liveupdate/luo_session.c  | 23 +++++++++++++++++++++++
> >  5 files changed, 44 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> > index dd11fdc76a5f..d93b043a0421 100644
> > --- a/include/linux/liveupdate.h
> > +++ b/include/linux/liveupdate.h
> > @@ -226,6 +226,7 @@ bool liveupdate_enabled(void);
> >
> >  /* Called during kexec to tell LUO that entered into reboot */
> >  int liveupdate_reboot(void);
> > +void liveupdate_reboot_abort(void);
> >
> >  int liveupdate_register_file_handler(struct liveupdate_file_handler *f=
h);
> >  int liveupdate_unregister_file_handler(struct liveupdate_file_handler =
*fh);
> > @@ -250,6 +251,10 @@ static inline int liveupdate_reboot(void)
> >         return 0;
> >  }
> >
> > +static inline void liveupdate_reboot_abort(void)
> > +{
> > +}
> > +
> >  static inline int liveupdate_register_file_handler(struct liveupdate_f=
ile_handler *fh)
> >  {
> >         return -EOPNOTSUPP;
> > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > index 2fea396d29b9..95710a7d5e56 100644
> > --- a/kernel/kexec_core.c
> > +++ b/kernel/kexec_core.c
> > @@ -1139,6 +1139,7 @@ bool kexec_load_permitted(int kexec_image_type)
> >  int kernel_kexec(void)
> >  {
> >         int error =3D 0;
> > +       bool liveupdate_prepared =3D false;
> >
> >         if (!kexec_trylock())
> >                 return -EBUSY;
> > @@ -1147,6 +1148,7 @@ int kernel_kexec(void)
> >                 goto Unlock;
> >         }
> >
> > +       liveupdate_prepared =3D true;
> >         error =3D liveupdate_reboot();
> >         if (error)
> >                 goto Unlock;
> > @@ -1230,7 +1232,9 @@ int kernel_kexec(void)
> >         }
> >  #endif
> >
> > - Unlock:
> > +Unlock:
> > +       if (liveupdate_prepared)
> > +               liveupdate_reboot_abort();
> >         kexec_unlock();
> >         return error;
> >  }
> > diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.=
c
> > index dda7bb57d421..95a0b81ce60d 100644
> > --- a/kernel/liveupdate/luo_core.c
> > +++ b/kernel/liveupdate/luo_core.c
> > @@ -233,8 +233,9 @@ int liveupdate_reboot(void)
> >         err =3D kho_finalize();
> >         if (err) {
> >                 pr_err("kho_finalize failed %d\n", err);
> > +               liveupdate_reboot_abort();
> >                 /*
> > -                * kho_finalize() may return libfdt errors, to aboid pa=
ssing to
> > +                * kho_finalize() may return libfdt errors, to avoid pa=
ssing to
> >                  * userspace unknown errors, change this to EAGAIN.
> >                  */
> >                 err =3D -EAGAIN;
> > @@ -243,6 +244,14 @@ int liveupdate_reboot(void)
> >         return err;
> >  }
> >
> > +void liveupdate_reboot_abort(void)
> > +{
> > +       if (!liveupdate_enabled())
> > +               return;
> > +
> > +       luo_session_abort_reboot();
> > +}
> > +
> >  /**
> >   * liveupdate_enabled - Check if the live update feature is enabled.
> >   *
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_i=
nternal.h
> > index 0cfc0269d746..8a6b1f6c9b4f 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -88,6 +88,7 @@ int luo_session_retrieve(const char *name, struct fil=
e **filep);
> >  int __init luo_session_setup_outgoing(void *fdt);
> >  int __init luo_session_setup_incoming(void *fdt);
> >  int luo_session_serialize(void);
> > +void luo_session_abort_reboot(void);
> >  int luo_session_deserialize(void);
> >  bool luo_session_quiesce(void);
> >  void luo_session_resume(void);
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_se=
ssion.c
> > index d97ec91e1118..200dd3b8229c 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -788,6 +788,29 @@ int luo_session_serialize(void)
> >         return err;
> >  }
> >
> > +void luo_session_abort_reboot(void)
> > +{
> > +       struct luo_session_header *sh =3D &luo_session_global.outgoing;
> > +       struct luo_session *session;
> > +       int i =3D 0;
> > +
> > +       guard(rwsem_write)(&sh->rwsem);
> > +       if (!READ_ONCE(sh->rebooting))
> > +               return;
> > +
> > +       list_for_each_entry(session, &sh->list, list) {
> > +               if (i >=3D sh->header_ser->count)
> > +                       break;
> > +
> > +               luo_session_unfreeze_one(session, &sh->ser[i]);
> > +               memset(&sh->ser[i], 0, sizeof(sh->ser[i]));
> > +               i++;
> > +       }
> > +
> > +       sh->header_ser->count =3D 0;
> > +       luo_session_reboot_done(sh);
> > +}
> > +
> >  /**
> >   * luo_session_quiesce - Ensure no active sessions exist and lock sess=
ion lists.
> >   *
> > --
> > 2.53.0
> >
> >

