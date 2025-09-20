Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D143BCAC5A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 18:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17E28E0005; Sat, 20 Sep 2025 14:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8B18E0001; Sat, 20 Sep 2025 14:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE7B8E0005; Sat, 20 Sep 2025 14:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACA648E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 14:59:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5344B1A01AB
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 18:59:06 +0000 (UTC)
X-FDA: 83910541092.25.72F252E
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D465120008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 18:59:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="KRIe9/Fu";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.43 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758394744; a=rsa-sha256;
	cv=none;
	b=Sih58mmIfEMmWS0lEjEkeb7eHXkzVr+qQZR3EU61pAax1lMCUP+OWJKJRcH5Bh0Xem41A2
	mOuON3hLGhjTS6FNjbyAb/zdaFYXmE+vSVB6rSY9N415N65zkJQTLstc/DFMHHxvcEvSC8
	SrxTTcc7SaHWSH9fBlAFcJs6TKr55sI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="KRIe9/Fu";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.43 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758394744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6m2W5nx71xMSXVxU+RpAhVoe4BosDpZBLlHtgjTWO5c=;
	b=Po/nTJQb4Vt/0SQokqm5zBpkePoZ9PXUn+/buZHMLtSnX82KwkoycnaC6ESGmYr4K64Fqe
	Qp4Jv/kyY+mN5CxpYKss/p+jS5WDKXS0J608p54Pp66LtzGXJcDkU89Y3Av0OA9FU4ptz5
	uZATAyUOJaMmAP14RM5lHS6NCJDU0qI=
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-30cce8c3b06so483698fac.1
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 11:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1758394743; x=1758999543; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6m2W5nx71xMSXVxU+RpAhVoe4BosDpZBLlHtgjTWO5c=;
        b=KRIe9/Fu84hptlC7PZis99G0x5GBpjC3uZbwsJHIC9W1MrOUkaSoIbr2hUX2erBHeH
         XqiXPU3+R3PXU0d+lvGsgXV39fzHb7U6hXPYmf96Vu4q984E9mU9suMLAHJs7jWzxGjq
         ba3cmSpoIjeqgbzceiEMZAbCqGa9e8obEOWBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758394743; x=1758999543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6m2W5nx71xMSXVxU+RpAhVoe4BosDpZBLlHtgjTWO5c=;
        b=eZ5Y7YatA0ePgN/YO+o7K2TBlw0yrvlaS1RufMJqn5Pa+2NY5cso6jxqa4f8DYl0h2
         yg81JcbR2iotvxp9nbSp+YBcGNq+YIw3Rxke0f1hvvuNMqgms3Gic6YNp5+6kZt4Vha/
         jZZvOEdp03eR09S+i2P6sgIPK21tyCbCYNDOPyHbCnIvPCavRbQgSqznTxcTgBOhAi/F
         MHgwLchRJORoG31/whOn5x+SBS02nyspFLQCJUEujGgf6us4ktCDeb01L0c6aHq3BxVn
         3Id8qNaaXE5EGR1IDc6jEYFOiCJV8wzZef3RrbE/gcvj3HuPvJgKROCtuUXKQzDoEt83
         nr6g==
X-Forwarded-Encrypted: i=1; AJvYcCWZcCiDKwqwDktt+sRghrerw/HXH31eb/1YlIja3TuWYdeW376nBcFSDSsuYv5beS3C/pwZAdjMJQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1QvYdGc56cOQPjPLsADGIOT6PUnSmBM9aQJFjw11JO4fYbN1P
	RbNJGIFL8VfL3YniRaXrOe+1ttfGX/mtwqu8IrKUemTfwpB+iF1Wix24P3bkSS+jppcVkOISp8X
	3Q9WIu3O3/3R0IBUE85t00auHHZShGeU/JOXPBZFr
X-Gm-Gg: ASbGncveLuv2cWltJ+WK4fWcga/w7tE94bBlapOvGqOStEstDyUpdFex/b70sE3RjVf
	SggoToC0Sf7FNmOvJbdVgAw+kMYSvus++ugOR/MiHKCGTaGQiYbWQHH+GECT6F2lFf1/S8+qLMB
	ART0UwNmQJXcgAKq4LWMbVQGa87ou6MJJjP9HOj0wKExlFovkFWc4jX7/ZJA8X4gPgusITL/D42
	x7tnOBtr5tsLjE1+aEiBAqLIikgX1VWA5/M+95P
X-Google-Smtp-Source: AGHT+IEbtUOHoGxmH8+U+ohTvlhZagORiUWDUjw1ZNRWRQtq3uyJEEBBW+146XDI0TEaj7CC0DarjKctgvx9c6CKZAI=
X-Received: by 2002:a05:6808:4f6c:b0:437:b03d:9028 with SMTP id
 5614622812f47-43d6c2d5ea0mr1674830b6e.8.1758394743248; Sat, 20 Sep 2025
 11:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20221209160453.3246150-1-jeffxu@google.com> <20221209160453.3246150-7-jeffxu@google.com>
 <CAHC9VhRBMTQvnBdSwMbkOsk9eemYfvCmj9TRgxtMeuex4KLCPA@mail.gmail.com>
 <CALmYWFvrasXnshO01YGWRyC7qKk4o0G88yAgkgjO1YBumF5zeA@mail.gmail.com>
 <CAHC9VhQKsjiGv3Af0iqg_TLNzCvdTaLnhw+BRTF9OEtJg1hX7g@mail.gmail.com> <87o6r5ac2z.fsf@gmail.com>
In-Reply-To: <87o6r5ac2z.fsf@gmail.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Sat, 20 Sep 2025 11:58:51 -0700
X-Gm-Features: AS18NWAgq3wn2Sk2LOUvEfd7d6hzlOiiolow2BKEmFkCuGifdHV5pRX8Z7-PEW0
Message-ID: <CABi2SkUj2WoNpm6repAr0rkmQgFAmfRTYD0k=KcPUXjOd3tvhw@mail.gmail.com>
Subject: Re: [PATCH v7 6/6] mm/memfd: security hook for memfd_create
To: Abhinav Saxena <xandfury@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, Jeff Xu <jeffxu@google.com>, skhan@linuxfoundation.org, 
	keescook@chromium.org, akpm@linux-foundation.org, dmitry.torokhov@gmail.com, 
	dverkamp@chromium.org, hughd@google.com, jorgelo@chromium.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, jannh@google.com, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kernel test robot <lkp@intel.com>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, Fan Wu <wufan@kernel.org>, 
	Kees Cook <kees@kernel.org>, "tweek@google.com" <tweek@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D465120008
X-Stat-Signature: ps5miycgkbu5xmfh6guywudmw8udkrmk
X-Rspam-User: 
X-HE-Tag: 1758394744-465430
X-HE-Meta: U2FsdGVkX18hEeQ5ASpG3yfzqGbj7VEqEzdjD/OztfHMirqwf9W5Mq3tIDVoLatT0yTj2Bf13tEZ2oGQaoGr14/JCfT7sJBI53O0O7ktv0aT2mVZSK9NYnCIFjSnpu3FK3PqFOItyabPzCt6HpsgVwzHXiKFRSVdRuvzI5naCvnQ6813fAgn/xGZH13T7bbxm8AD2GSpGzax3RcE7Nq7rECpolp20xORylY7XqBDKJ9i58GSA+xMOwJVXBfmgAYiySMmzEI8o/ltV5UQKwniOz3+KOitsScAO7/nSaHJ8XWweX08Qsf5J416rQoNc5baGfVloZ49s0t3CEeY3ruY1vdDN4yr1RSSXSlJd0Hd032xxL4bji1sQPbrodg4L4yYkkcoXSc5RTFz6zxSJRb0mf8kC55dHRUSbCNe1qNv7ztYcdOFhG8x0cUIvr5gYulozveprEjvBo7ZKWwg+/kFXgjsteu1/SD3uQ7yFK4z2sJjCgq7lTDIJ4tLxz5C5wU9EmDrorcVbVXInDT8nRXLl8tIhk2gdlJtU9o1baGmswlXlVQXphFP9t+o/9h+SjmSm2lYaDkW0h+SPseNuJB1W+ZGlSx+kc2y30MP1oS8M71bo998FVDzx12wDVwo8O+YZiUnMSzwAOuJUdjvwdDCszafv0DSA9GlOVAQ2pbtfZAfmJl9+V6X4OC0uDAeeQjNbko/EfQ2NumozkfL5fVEBaENLhvetYcDGReDqe9dXSTWW4AtouAC5HW+Rg8oLwt1Q1uIm9tDCdz6EVH8MHCxBUTfG/XDVVufBnP+hCi9kqVWij6pmV9SF5zWbZKLxvGAhPDWqbgzwWfm84bB4nXuGyS5ur1erjjhbApkl4CsOzfJJlh+YFLVRAt/oWzB6QGnBsWlYGMr3yEKjuA38auOrDxeuCEfLJ0IGqOu0eeEOEPvuiWEX8itafC0ziBDkg1sBGLsRzbycva58ynprYG
 yHAv1E1a
 9JDo8SaAFPPKAnmx46h/zLrMLDMzhE7XKddhdHq7Z/4YR118S7t5DTSoJ16h1avWz414LL8U+vsCL4jzpun2wxV+49J0OtKDZODHlnSIC0A9nzDDHb3biyQNXPZ8E4SIpuCZa30I7tuvfKe/cOEj+uVPHKvscyMD60M4TXKmrF2sxm1huUFhqlppTLVICMQYecg3GpzBX1SPngT8LwUf1CG3v8n99sIWDdwB7imkvbtOYBfTJQY+Va1CL2Ggjz9NEYggCJx1rsE75Rmx1lcvw2WXlFjI3eoiG9bDseXdasKi7ie3gxS2Fky7pwhmtMH0Vjg6JlD6xxbyq2EFd0I5UN8UxN9hhHmSoCAuB6LY7FPc5MlzKeyfOVe8SP9cJWqEa7FZ9Y2RmgE2bfjiDMN/CVPA87DDUNHa5enVL7YIQyL8uwC5T33FqRizu2MfdcxOuocuaiNGvM/mYS+reur2jBVvbPqKlUn0Z/cRLXtm0omKY8q3GxHEGus1q59952N+DQN+Z+ZS2Y3H00/099zZ2JEzQkJ675r9htSAphRsizJ16Km0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhinav

Thanks for reaching out, it is great that you are interested in
Landlock and IPE use cases for executable memfd.

Adding  the latest discussion/status  that I'm aware of, related to
memfd, for reference

- Thi=C3=A9baud Weksteen (In CC)  has patch [1] for a new selinux policy
for memfd_create in [1]
- Micka=C3=ABl Sala=C3=BCn and I  discussed the security hook to block exec=
uting
memfd [2].
- Your recent patch in Landlock [3]

[1] https://lore.kernel.org/all/20250918020434.1612137-1-tweek@google.com/
[2] https://lore.kernel.org/all/20240719.sah7oeY9pha4@digikod.net/
[3] https://lore.kernel.org/all/20250719-memfd-exec-v1-0-0ef7feba5821@gmail=
.com/

Thanks
-Jeff



-Jeff

On Fri, Sep 19, 2025 at 11:10=E2=80=AFPM Abhinav Saxena <xandfury@gmail.com=
> wrote:
>
> Paul Moore <paul@paul-moore.com> writes:
>
> > On Tue, Dec 13, 2022 at 10:00 AM Jeff Xu <jeffxu@google.com> wrote:
> >> On Fri, Dec 9, 2022 at 10:29 AM Paul Moore <paul@paul-moore.com> wrote=
:
> >> > On Fri, Dec 9, 2022 at 11:05 AM <jeffxu@chromium.org> wrote:
> >> > >
> >> > > From: Jeff Xu <jeffxu@google.com>
> >> > >
> >> > > The new security_memfd_create allows lsm to check flags of
> >> > > memfd_create.
> >> > >
> >> > > The security by default system (such as chromeos) can use this
> >> > > to implement system wide lsm to allow only non-executable memfd
> >> > > being created.
> >> > >
> >> > > Signed-off-by: Jeff Xu <jeffxu@google.com>
> >> > > Reported-by: kernel test robot <lkp@intel.com>
> >> > > =E2=80=94
> >> > >  include/linux/lsm_hook_defs.h | 1 +
> >> > >  include/linux/lsm_hooks.h     | 4 ++++
> >> > >  include/linux/security.h      | 6 ++++++
> >> > >  mm/memfd.c                    | 5 +++++
> >> > >  security/security.c           | 5 +++++
> >> > >  5 files changed, 21 insertions(+)
> >> >
> >> > We typically require at least one in-tree LSM implementation to
> >> > accompany a new LSM hook.  Beyond simply providing proof that the ho=
ok
> >> > has value, it helps provide a functional example both for reviewers =
as
> >> > well as future LSM implementations.  Also, while the BPF LSM is
> >> > definitely =E2=80=9Cin-tree=E2=80=9D, its nature is such that the ac=
tual
> >> > implementation lives out-of-tree; something like SELinux, AppArmor,
> >> > Smack, etc. are much more desirable from an in-tree example
> >> > perspective.
> >>
> >> Thanks for the comments.
> >> Would that be OK if I add a new LSM in the kernel  to block executable
> >> memfd creation ?
> >
> > If you would be proposing the LSM only to meet the requirement of
> > providing an in-tree LSM example, no that would definitely *not* be
> > okay.
> >
> > Proposing a new LSM involves documenting a meaningful security model,
> > implementing it, developing tests, going through a (likely multi-step)
> > review process, and finally accepting the long term maintenance
> > responsibilities of this new LSM.  If you are proposing a new LSM
> > because you feel the current LSMs do not provide a security model
> > which meets your needs, then yes, proposing a new LSM might be a good
> > idea.  However, if you are proposing a new LSM because you don=E2=80=99=
t want
> > to learn how to add a new hook to an existing LSM, then I suspect you
> > are misguided/misinformed with the amount of work involved in
> > submitting a new LSM.
> >
> >> Alternatively,  it might be possible to add this into SELinux or
> >> landlock, it will be a larger change.
> >
> > It will be a much smaller change than submitting a new LSM, and it
> > would have infinitely more value to the community than a throw-away
> > LSM where the only use-case is getting your code merged upstream.
>
> Hi Paul/everyone!
>
> I am not sure what is the latest here. But it seems both landlock[1] and
> IPE[2] have a use case for memfd_create(2) LSM hook.
>
> I would be happy to work on the use case for such a hook for landlock.
>
> CC=E2=80=99ing maintainers for both LSMs.
>
> -Abhinav
>
> [1] - <https://lore.kernel.org/all/20250719-memfd-exec-v1-0-0ef7feba5821@=
gmail.com/>
> [2] - <https://lore.kernel.org/linux-security-module/20250129203932.22165=
-1-wufan@kernel.org/>

