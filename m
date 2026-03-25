Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5951093168
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 21:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0AD66B0088; Wed, 25 Mar 2026 17:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBB56B0089; Wed, 25 Mar 2026 17:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA5D6B008A; Wed, 25 Mar 2026 17:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 985D36B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:35:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F20D5C13D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:35:51 +0000 (UTC)
X-FDA: 84585892902.26.68DF62B
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 653D71A0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:35:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g3jZ8GxJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774474549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqwP9g0v6C0mDQ30HJRspUgVjqd11IZmGYop0w3266E=;
	b=hE9uzwXcnZRj/mrV5tQq4ILyBvOkN9ZGZhua6OzYOp1eGf9VuGqzIQ41DUArA8r4N9LE8b
	ikA5SBrOpwNwMoGuYB0mNibyA3x1HMgz1jyrriLpBmE0dZEnqQb4jneun898m4/yRWa9u3
	7eyFsiq7vXDEVi18Sne3+Vmp5edt/V0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774474549; a=rsa-sha256;
	cv=pass;
	b=8jOXxfmjK5FJaZPJ6or6FnzE1emTW5C++qXRWWcutTNMPpTiHZqr848dKZuOvqU2BPeI5O
	Te5m45EMpNwjCYvPSHIkBZl0Y0QygTQTrukQPUODfVy1lV7rbIbDKWV6HmYh3b2aWpEKdG
	tg0dJq2W33MENMdoRP0gjGvdBNRLkZQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g3jZ8GxJ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6694c9c02c5so351621a12.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774474548; cv=none;
        d=google.com; s=arc-20240605;
        b=HEChEtemwl3zaHZZi4QLDWnCQY11teUd7u/izXzq8wk8V6c21OHbOq8M08F+K+G17e
         xsqcaZJGwn+T5+noI+dCPHHhQxARFLTZck+/01UxEhIBKfxxp3Bg7L6ZVEdCgTc1k1Il
         AGUZK2E9pDmSCH5Jd7gdQ6DRAIZcoNQnWhQgFXyBpc+pFK9nCS5O33dcEcozf+94M+Ry
         LP5JvhDePCVl8QeAsd9wKjHR69aC95Z2D7lnHM90ZfzbyLnaW+qfOvUrvgFvknBa77D/
         6ykDS5ITjOekgbCLgaK2sdsntz3O1YNOVvgWNLFbtnhi0W9FpWN6YFh1bwdv7tHuo4NA
         hQlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VqwP9g0v6C0mDQ30HJRspUgVjqd11IZmGYop0w3266E=;
        fh=MmLU3QLEz+HxH8hYYs0hkpoj7u7TbFbZvFMyS6lLOnM=;
        b=NRueh/tsh23NcG5njo4jf3CaJd/5iRbWIuZYSlLh/Qzkt/zqC/d0+RK7aOTqyaz7JP
         eaz2YDIKGcenAZsqscixXSAbjxDb1jW1LHAGKLtYJt4i+++o5JJ//EgQ9I8LF75ZRO+S
         bFpOWS0nAQvB9MVz99Tss5omW+DRGspSwS3RVgAf7cWnlKVdCW3//XczdcrYpIiXeHAw
         MNfwpF0JFEgJtqsN4z2IRiVrGdq6H2p7p3lLYuhYxy2YfD9+ziw7fsG0IqveN8dSGrJt
         dpiylUE8zbXhlJ6xgXjYpGNZNEYU+YrVrmWaRc9jKiZ2kZAp1h+dNWbus3zWkiRWR0aH
         VLAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774474548; x=1775079348; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VqwP9g0v6C0mDQ30HJRspUgVjqd11IZmGYop0w3266E=;
        b=g3jZ8GxJ29/cKjq/fnacF9NCaCs1Q/wLXFR78boPE1aNk6QJ8YUKxTBWZBIAf+3DPY
         84z8tT8UZ62HEyKXRe9VnRtCKnsm7ROhKqloD7Ezu7+qxjm8A5GDpDzDG7xiv/qm45KK
         peGBqzH/0hknFMehfvkRiNutyicpEcUobPLhjE/X1PdG3f3g81IUugDnTn0BD7TnkBaa
         Tis4hoiK5oKYo90M71lkFY56GEdsbqWHA2zE1QP/6+CIgQjDHc0eXKsQqVhndEJMqq6Q
         z8p54Pts7lUJ9hiOXmjpPYGxYsgpBbOmJkBiGCml0nVClWPNXQueVyfmyju0wnJ97T8k
         c3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774474548; x=1775079348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VqwP9g0v6C0mDQ30HJRspUgVjqd11IZmGYop0w3266E=;
        b=aNdMgOmg3mwx4dIAGw0IpPnGojq2BFF2Hnxp8gmO86VH0Uk92rm97LevaTwAt8Y6EJ
         Zh8R4oTXz/dp0iZbqZsVDJKRKfd1es+l9YzVGdgAdXCBTX9DWw7bRU7Oq6amVKjVtk3p
         YVYFsJZYuQc1gZMH+XokrOysOzyiyPUSG7hSaZX4s8KzuXJJIQ6GM5VFx7I7fyldmEnV
         h+cyJuJS/TxZRxPolFzp1A1cOwP6C/cmGYag6q1KaxI3ZBQvzmtr/RypKeerLm3DVBvO
         jDYOxGApfLJqa+EWu6QKT5yT7/+34nE4+8T6ZHx6Z7uTGb2MrKcZLekyqNXAMD7Mr9hT
         DmIA==
X-Forwarded-Encrypted: i=1; AJvYcCVCxuKg3VPf+Kk98j6JypzZLfuHaDpSs4O2FMdJ/E4BMq0uadfVQl6NnJuh5MvCK6o6RPQKGp2D6g==@kvack.org
X-Gm-Message-State: AOJu0YzbcRuUoG7Eh1ndHCfsyEHubQQeapguGPOU/GuYGiHcwXl5o5VN
	j1JYYQRYbdmzsfSdOwnbOecorgKZJY1c5UpjCeRG7rCFnHJa/nsiGtyBVmW425YQbGZDt/8vSNa
	SEnfVCbUYPSqOzOAVECmoOoci91WcS8I3HaF1+NYAzdRJKuoQvt8HU0Y=
X-Gm-Gg: ATEYQzyZ0c9w7pLY1I7NGseNGyLvwf3ZSLEZ5abSxPGV1ZwmyBpec+pYiz7P+7FjWg5
	9uFdkWmYLvvnTww7f8fmxMSmieBcTvbI/+2tYz3L3iNXiCDVr23LoVVMI4a5qv3GcCEOh/WZUV6
	GCYJM2ACZ2Qw8D36qWYbbxpDjuau8Pvjjk2NXFmHNRyWXf4RBTmKIjPMMDvPZy0IE06WyA+VWWi
	o66+S+cczJq1QKaQC1JxYfoEcXdnRsrUbC4pH2GI4eUJ90tZ+3Y6Rz730jVxVdIO8hneoNoRubb
	kw2U0TxissNq8Db6loqS52HN5f/A4EsLoXTcGA==
X-Received: by 2002:a05:6402:5054:b0:669:4aad:6338 with SMTP id
 4fb4d7f45d1cf-66a82634580mr3223285a12.8.1774474547200; Wed, 25 Mar 2026
 14:35:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
 <20260325182026.467307-2-pasha.tatashin@soleen.com> <2vxzikajacgc.fsf@kernel.org>
 <CALzav=eybgJwMQEtvSi2bUv8u7cic6d45r4wFZdZiKFFrrLJfQ@mail.gmail.com> <CA+CK2bBpa8ZnxPdsPCRCAiPeHUbqQ3TNjHTGU2eN_BGqqX2Y1Q@mail.gmail.com>
In-Reply-To: <CA+CK2bBpa8ZnxPdsPCRCAiPeHUbqQ3TNjHTGU2eN_BGqqX2Y1Q@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 25 Mar 2026 17:35:10 -0400
X-Gm-Features: AQROBzD_QnuinvR0by2hrqTHXqilLDpZUMWt-WEZYStEDPZAUyluZXMIeXkLNnM
Message-ID: <CA+CK2bASPq0_4tDGaqd_mEmF-Wvw4cfS40bC4p8XWR4joY-ypQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] liveupdate: prevent double management of files
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, linux-kselftest@vger.kernel.org, rppt@kernel.org, 
	shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 653D71A0005
X-Stat-Signature: 4u4qsjkai9upb3yzn69x6k6mqowcnkmx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774474549-118528
X-HE-Meta: U2FsdGVkX1/LGHl5DMhUgE7Vpe2ty7hG1G12CwdckUWcRscnAaJQwF5Lo5b1Qb819tllKATtQWQWbBTyw/1f/I/QIEluCu3wN4aoRPdfMpqX1wF3jxMaM+KiCk5zGVZ7Omn0+p8jm9n/rom4tzCP270o9dRS5bkPqZHaikL8bW+vZK9eQprGDJtoiBkUM4mvejXxdpDSf+7TtxLoteZAOLLFjGT62belxmJFUAjgJPtwsTWF9Pllp9YavmecPwZ3e00K4ssgSSlMsx9+NuYukZhJfNRh4zsuUH83+QpkW0Lk7jVI7JKjVt34OpSO97z2nbQ2k6LgPVfmeMnYunO9sWMRpsGQ1oazr99hUbGO7mdLxXMuBCXEBozO8tQgu8vVhQsDhmJfR2TJvVMu4oqwHC6orY8IDCFpG4WnltAGUHyoIdiTA1PqQ5pgrccjblNSX2yG04+VQp2yhzK+bzoc2xK7oHC+Px6DyzWCs1vlBZqghwGuoPPD8IRnDvyz5Le4OJ2MTgLcwld5ka/LX1EuMQCh6TOLKFyo2LPo5iAwCwRsOf0HTa+3NkAN11dPBs2r+GRmt89EbuaZ3UNNYVbzDs5fWsXGdxVAueRWl73WfWG95FIrosc0Wj2C5baN/kR5GOG0TEbXEIAyvbSAWfVkPG9h2FikLOaF9guSBjO89iFNd8tW6yhe4eIygjH5vNKO7Slx/xQM/mUfFNCvmNXuzNXeAa2IZQz8cGTVy0hzfIgTNvqlWhCgVx+EPFog5hIWDA26mY5G02UuQZQOaTpUgYeLZdhTcgbm7vceMon9DQV5wWEnTGhuFQW0iKiEuSXVckyigjN32ADxHcqvJOagFN/QT6gljLlkL0CaydKZOYHJ5LOUydjwY6bqi8Tz493JgWZQpq8bRV1rl+XfCpH/vf0w1Ap0nGh13wZzVUwg0RpGkU4tNn4zPdt4v1iRvj1ftsDcksBDh+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 5:08=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Wed, Mar 25, 2026 at 4:34=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On Wed, Mar 25, 2026 at 1:20=E2=80=AFPM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> >
> > > For memfd and hugetlb at least, we serialize the _inode_ not the file=
.
> > > The inode has the contents that we care to preserve.
> > >
> > > So if two FDs point to the same inode, this will break. You can do th=
is
> > > by first creating a memfd and then by opening "/proc/self/fd/<fd>". T=
hen
> > > you would be able to trigger the preservation twice, causing all sort=
s
> > > of problems. Same on the retrieve side.
>
> Hm.
>
> >
> > > So unless I am missing something, I don't think this approach will wo=
rk.
> > > As much as I hate to suggest it, I think we need to move this check t=
o
> > > each caller so they can find out the object they need to serialize an=
d
> > > check if it already is.
> >
> > I think LUO can still enforce that the file is not preserved twice.
> > HugeTLB and memfd's preserve() functions just need to also check that
> > the associated inode has not already been preserved?
>
> For memfd/hugetlbs the true state is in inode
> For vfio/kvm the shared anonymous inode is just a dummy wrapper, and
> the true state is in file->private_data.
>
> I wonder if we could use the XArray to track inodes for standard
> files, but track the struct file itself for anonymous files (we would
> need a new function from FS that allows us to determine if "struct
> file" has anonymous inode or not).

Actually, let's not modify the fs layer, instead, add an optional
get_id(struct file *file) callback to the luo file handler (struct
liveupdate_file_ops). This would return a unique deduplication key.
For example, the memfd callback would return (unsigned
long)file->f_inode. If get_id() is not implemented for a given
handler, the LUO would default to using the struct file pointer
directly

>
> Pasha

