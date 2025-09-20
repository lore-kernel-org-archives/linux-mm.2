Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2D2FCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 06:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CE18E0002; Sat, 20 Sep 2025 02:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD588E0001; Sat, 20 Sep 2025 02:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2EE8E0002; Sat, 20 Sep 2025 02:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD4DF8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 02:10:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E5D586481
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 06:10:34 +0000 (UTC)
X-FDA: 83908604388.17.06753D0
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 483D140004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 06:10:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ICuu9urJ;
	spf=pass (imf01.hostedemail.com: domain of xandfury@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=xandfury@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758348632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hou6AJPM8wejR725iDsnasOHuRSCpfZoVQThJpW/xQI=;
	b=Sy2MOVDWZodQ2RyxHHah6QZQAxzuHUYr2T/guNajwoPpnWKXOZBl+qL0rvlNhPfqOVBoLL
	Z8vED9aqs8axoe6nyW1wM2QP0WDm0E0rjTxJWJt+HQ153Gm2E3VAg5N+W6ulOe6uR3yuNq
	kX3PEB/AUeHcNtNggONYZxpL8RhUW2s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ICuu9urJ;
	spf=pass (imf01.hostedemail.com: domain of xandfury@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=xandfury@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758348632; a=rsa-sha256;
	cv=none;
	b=j9RTYL2RpqRFpz4Iee+/jJqk0WnO339mkPV2rExjmdFn4+sEt+Uw0t1QEDnzn5bTPmBLgb
	E6DJYXPYwW4Isi90ZSwd/hyGazUtro9y9VEk8Sp3ckoEhsK+OpO2T6wdf1+QEe4Cj1fmne
	yGX4hY6pvB7FI6wR+GQR991G9/jM/MY=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32df5cae0b1so3075159a91.2
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 23:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758348631; x=1758953431; darn=kvack.org;
        h=mime-version:message-id:in-reply-to:user-agent:references:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hou6AJPM8wejR725iDsnasOHuRSCpfZoVQThJpW/xQI=;
        b=ICuu9urJe3HgDGPNsAVA4AATSOG5IJSIc8sf2lq6hD+oUWDhL+EBdVPnMIo8/EMvan
         8bGdbAnxO0PhXiewrh/lHaSLff6xz71kjZoQn/nPory6c5kWfYBqfsrSWcn/4wrdUQ0V
         WVNVfpZ8Ios6hLA20w4O5fPBipUdr3h8BsR/M+C+mYMAY0+xkGhqzbhxrkBc2a2lLowk
         krHVVK2yjgNc3APX/wVF7RrAwgd0gLwkpccYvYUCr9uDlbLSoWfLBeT0/je/3l2gHutT
         AD4E0wbRnIGABTXZRGx5AQvem2TINdpg8Q1a/BYOvxMQj8AYtLNw/X3Jd6stzl0LZ3+u
         4nCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758348631; x=1758953431;
        h=mime-version:message-id:in-reply-to:user-agent:references:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hou6AJPM8wejR725iDsnasOHuRSCpfZoVQThJpW/xQI=;
        b=PUUoEHey40nNflf+RP+WvaMNmctPKqb4g+PIaS/QQY+v6sk5ihbvJEknng7WZCbx/o
         EYGdeYK5xwmOrKEXIkP/GGYMKO/B5xgVY8+K78IZwUbgVAlr7EfrmFAuHRbHTt68dRlD
         7h8h5Mq4hhg9JqcnU8z4rOwFfNZja0jRiXFgjncUgqGq1RIS21lxLs8rf6p4nO6bRV4n
         /JY/FJV8guSpcwLJWgCe8q2m97CnEdrOMkV7jz/e1MWB/2kUxl4FVi+BPL8Dgqb0pu7l
         yJl00F3T3eGXYBW+SNJTrs79BptfdFRUHhZ0KvilPW208AD3xwNYOAJRmpkM8GpV1zA8
         sd+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWhRCry/Ar9n4cfEGxkywwPgo7yelAAf0j1gCJnZqii7GEbcGqUnGzXMekP39P/is53dCftFTud1A==@kvack.org
X-Gm-Message-State: AOJu0YxOHli4wmez6auQjSSY06qVFsMXxkPe97LK0GzWvC6nMhRfq9sI
	tWz1iQIvm+pVTizSaAPURxTh1c1nnDctQe7s2jsz/ys0es1gUTZW/mfJ
X-Gm-Gg: ASbGncvhSdNDJdoMalu2DICwB5DRO01xWd1kfqG4fHXFN2oa4XSeQGNOlfy3B+fr6oV
	w5nQxHSqVmieuR22NS8B8/0Y2QP8cRgzXMfnAPc9jHj5UHa2sgl9sSAYe+p1ZGTNAAYSky8ydMU
	9kMMTuPKflYARwPqo7DMDIIEJ3wlgHYdPUqYR1wNTzA0VZR8In4ZOXIVL0/OFfHHpNqlBouQDm9
	wy8M4DuB/hBuwrSfGv14cTtD4iEwtMzPj+M8UW/3Fj3MJNu1Xa1vPfwN08IWWXC8G4nn6d2lRYL
	eVWmsJqysCp/YsfXGgxjCq+MjRy2fEznxMzHojTP++imNAJ8/8fEoO/PkO6o2aiuePhRyBUjIqy
	+Gcz6mviScvU3
X-Google-Smtp-Source: AGHT+IH2YsbIL9bmM2wkE8sVKgdbADyeo6xeBPeiRV0b4d2jfA5VE26z/kBsRCKoBlEJw3bJUDuezg==
X-Received: by 2002:a17:90b:52d0:b0:32e:d011:ea1c with SMTP id 98e67ed59e1d1-33097ffd1b2mr8090816a91.15.1758348630860;
        Fri, 19 Sep 2025 23:10:30 -0700 (PDT)
Received: from 1337 ([136.159.213.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b5531d90d1asm1179569a12.18.2025.09.19.23.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 23:10:30 -0700 (PDT)
From: Abhinav Saxena <xandfury@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Jeff Xu <jeffxu@google.com>, jeffxu@chromium.org,
 skhan@linuxfoundation.org, keescook@chromium.org,
 akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
 dverkamp@chromium.org, hughd@google.com, jorgelo@chromium.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, jannh@google.com, linux-hardening@vger.kernel.org,
 linux-security-module@vger.kernel.org, kernel test robot <lkp@intel.com>,
 =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, =?utf-8?Q?G=C3=BC?=
 =?utf-8?Q?nther?= Noack <gnoack@google.com>, Fan
 Wu <wufan@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v7 6/6] mm/memfd: security hook for memfd_create
Date: Fri, 19 Sep 2025 23:54:06 -0600
References: <20221209160453.3246150-1-jeffxu@google.com>
 <20221209160453.3246150-7-jeffxu@google.com>
 <CAHC9VhRBMTQvnBdSwMbkOsk9eemYfvCmj9TRgxtMeuex4KLCPA@mail.gmail.com>
 <CALmYWFvrasXnshO01YGWRyC7qKk4o0G88yAgkgjO1YBumF5zeA@mail.gmail.com>
 <CAHC9VhQKsjiGv3Af0iqg_TLNzCvdTaLnhw+BRTF9OEtJg1hX7g@mail.gmail.com>
User-agent: mu4e 1.10.8; emacs 30.2
In-reply-to: <CAHC9VhQKsjiGv3Af0iqg_TLNzCvdTaLnhw+BRTF9OEtJg1hX7g@mail.gmail.com>
Message-ID: <87o6r5ac2z.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 483D140004
X-Stat-Signature: e9nuxoyqgd1bw1ah1hejyef8x4m89gpa
X-HE-Tag: 1758348632-318114
X-HE-Meta: U2FsdGVkX19cZUHJXn+Zr+3dEX2QjYsP3RSZKpiWiqsVhDP+Dgel2T/5ng43sj+oJg9ghZLiZpOH7LiSy6XHk9v8gQBCMlPmOpDtniapQ9xFu/PiCXkz4GJiItTILrIN1HSlYKNxvTYhU887xp+yL/mocE6g6vVWpD4Y7uFNs1+2dHaguJ5NeQwag+7zsS2HCuJ1OhZORLWzgOpRpSFGlvppQYq9DAxKMel0VtKWcC9S8UYnbO+UvqdPf21A9ZVirFInlSHTvK4LgYf6s34KFcCN6a3dlUOR5XuO6a0xMEZh/t6qSOPq2woxLFY8YP7O5MTdxP/h3pyqlmHsz0cA7m9WyqnBiibCm1JKcwUDOuRjDyO1gTxuS16Vc/StYb12HJbCMXovU+MyF5V/8NqKvRlyDWOzh7Rs0hO7MR5fv/tCkJlNdAhWxDRHs1GEUqllE9XK4cgNGl532lPSQRGZn4AL0grd0E+/Or0Nu5kW23m7lE2NNSZ3IjhCbx0swwU2wPVEq7tDb1GWq4pe0BPSGoBb/E3YIGOVCMeG+GIpZsQLSn15w2gOxEF0OJ2VJDBnQP5hW5VNfQpEpRpfrO2FZJiaKQ/3s7qF8WxL8GXYm2rP8NC+76eGdjGQOWl+o+iVyA+hRyVFUVqj0eOVZPWjLFLjpzf+bcEmW/qfZGWZPSq5yvrUmkPXUTSlFfkhQyK/MsxNnUx7hGBDPbGNemYtB8Vry73atms3gXk0rqjQooa0cBPKhUpSB7KSQNQPW1kIsVOK8TcJ6SS76mj+kFMhIEVUS/xSj4e2Q1KHULjtNwfj/IoNqNhtrZU+8cu2IEicUXsjvtaAJ0bGSTm/Znp/5sbxTVRssYna86Ii9LIfm9Zv5NMSXjOkqmMI1nVfgrEZVFLfSzW5NpGuZqCY4tLhlLkTUQhmQD97vvDcWDfdmByWSb4K8v3gT0MJe+zY0jCGpzK7hBVC9vTJOjOybVL
 ZYTCYu6p
 5HBLrztm7NyFgI4ipEDjQj0odx4huZnwoiCOOetceq8TNiIcrMNIExDfjDX3rlBGoYx/WjDGRT1VtOhtePajmUMo6WD1vv6UuldT1R3lW1X4g7dJqXxb2Lens78RkdZdlXAghaquJy1iynXzETLo/pvqEQn6mKKot/hZ0GFntN2egTqdDywB8w+/Gi9ackDsD63Pce7InqjslW4+2bGka3xgGi2mI09HceYuAjCbx2n3NdFK7BGJi17bNIXc5sQ6pe0hMJFrqVUn86Xe+uZs5gUtLRaUmYJ705vOnJ+FzIoqs2nhEUd0GZ7LRX1ztqMQ/wXp6Xqqbp4E05gGYcu8BT0FHgDA/lMQykp5zjzU905MSoCzH+Tjb4C7QgZbMttEdU9wYpclrgz1BrwLdicfnb2Ds2OI+tZ7aBAZSgpEXyDpNv7IQjKqbYqr8pgcUJ/CI+eJX3O1IF7Et8FTdqkFGv90M6MaTfqpB7p5CAWywwzpp7Pu4CuLTKiMbLRcFWDsM4SjAwbYAuXzFp+ZMdBAZ9iclrsYWnK0l2Bi7F536gEAaLYvxxeR9MRntS/zhJ1blJBT3FlAYenZFgkymKgwBlDRCv7le6BWaeP5o55SFnhZfU9ANJYbEB0Xd/ymzKhJUCy3UTxiK2Ms6EH/ZPR4Fw9T162HJlKW3ZuSEvXAyCg52L4Gh9kuClaN1zHCwP/Ii3A5k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Paul Moore <paul@paul-moore.com> writes:

> On Tue, Dec 13, 2022 at 10:00 AM Jeff Xu <jeffxu@google.com> wrote:
>> On Fri, Dec 9, 2022 at 10:29 AM Paul Moore <paul@paul-moore.com> wrote:
>> > On Fri, Dec 9, 2022 at 11:05 AM <jeffxu@chromium.org> wrote:
>> > >
>> > > From: Jeff Xu <jeffxu@google.com>
>> > >
>> > > The new security_memfd_create allows lsm to check flags of
>> > > memfd_create.
>> > >
>> > > The security by default system (such as chromeos) can use this
>> > > to implement system wide lsm to allow only non-executable memfd
>> > > being created.
>> > >
>> > > Signed-off-by: Jeff Xu <jeffxu@google.com>
>> > > Reported-by: kernel test robot <lkp@intel.com>
>> > > =E2=80=94
>> > >  include/linux/lsm_hook_defs.h | 1 +
>> > >  include/linux/lsm_hooks.h     | 4 ++++
>> > >  include/linux/security.h      | 6 ++++++
>> > >  mm/memfd.c                    | 5 +++++
>> > >  security/security.c           | 5 +++++
>> > >  5 files changed, 21 insertions(+)
>> >
>> > We typically require at least one in-tree LSM implementation to
>> > accompany a new LSM hook.  Beyond simply providing proof that the hook
>> > has value, it helps provide a functional example both for reviewers as
>> > well as future LSM implementations.  Also, while the BPF LSM is
>> > definitely =E2=80=9Cin-tree=E2=80=9D, its nature is such that the actu=
al
>> > implementation lives out-of-tree; something like SELinux, AppArmor,
>> > Smack, etc. are much more desirable from an in-tree example
>> > perspective.
>>
>> Thanks for the comments.
>> Would that be OK if I add a new LSM in the kernel  to block executable
>> memfd creation ?
>
> If you would be proposing the LSM only to meet the requirement of
> providing an in-tree LSM example, no that would definitely *not* be
> okay.
>
> Proposing a new LSM involves documenting a meaningful security model,
> implementing it, developing tests, going through a (likely multi-step)
> review process, and finally accepting the long term maintenance
> responsibilities of this new LSM.  If you are proposing a new LSM
> because you feel the current LSMs do not provide a security model
> which meets your needs, then yes, proposing a new LSM might be a good
> idea.  However, if you are proposing a new LSM because you don=E2=80=99t =
want
> to learn how to add a new hook to an existing LSM, then I suspect you
> are misguided/misinformed with the amount of work involved in
> submitting a new LSM.
>
>> Alternatively,  it might be possible to add this into SELinux or
>> landlock, it will be a larger change.
>
> It will be a much smaller change than submitting a new LSM, and it
> would have infinitely more value to the community than a throw-away
> LSM where the only use-case is getting your code merged upstream.

Hi Paul/everyone!

I am not sure what is the latest here. But it seems both landlock[1] and
IPE[2] have a use case for memfd_create(2) LSM hook.

I would be happy to work on the use case for such a hook for landlock.

CC=E2=80=99ing maintainers for both LSMs.

-Abhinav

[1] - <https://lore.kernel.org/all/20250719-memfd-exec-v1-0-0ef7feba5821@gm=
ail.com/>
[2] - <https://lore.kernel.org/linux-security-module/20250129203932.22165-1=
-wufan@kernel.org/>

--=-=-=--

