Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A1FFEC11C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 22:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB52E6B0088; Tue, 24 Mar 2026 18:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FA86B0089; Tue, 24 Mar 2026 18:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEFD6B008A; Tue, 24 Mar 2026 18:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B845F6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:20:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DD121A0501
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:20:04 +0000 (UTC)
X-FDA: 84582375528.27.B958C74
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5A1D2C000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:20:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uW5xvVvg;
	spf=pass (imf10.hostedemail.com: domain of avagin@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774390802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iA0qEOtZ8sY0A4PQMCyKkXrxyPKJc9xjSndOAsg0m2c=;
	b=3ANsq35iMndzyfcFBEQvHP5XjbhPcPHYw8ntqwbJfA89xPsaOt4OkbYMVJTO2i3CRS8VkC
	G1QyAvE8hDR4+fQktiIAwDlMkzQ/69B3OKpX7Qdk7N6HqJ3MlXX1RHCC+1adbLA+Ag9csi
	F7HaV21z+E27lFauSgI3Wa5GCl10mrs=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uW5xvVvg;
	spf=pass (imf10.hostedemail.com: domain of avagin@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774390802; a=rsa-sha256;
	cv=pass;
	b=3xbp3R6/vWFEUxnQllA61mDL1Em4bGh9Wd6Agk54dRhLuCkBsJaL/43j2C35uLYVDDTe3X
	QwACxzs3RvxKuKWecTDbc320bSzm8JqNRCTsgQ1659t9/AF+D2TtkEvodwo7kv2b0KcwQb
	pKv7IBCKkubONDx0irdnx4+lPXts/gg=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-509069a7a7fso195211cf.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774390801; cv=none;
        d=google.com; s=arc-20240605;
        b=a/ehehhgGCgfizB+EnG5sufBOjNqEcB9EkM0WPNVUHoFQLnbbIDppdFoth3YMu9pm8
         Yh/0+GvtHVdks5+W7BRCUkfCDhBUCnBfXS8eXwGIIOD8ijBasnCr9gArnXln0rgGEMvi
         BqGzdjTzFg6ZI6l6NAiulOVlpzzQfe8gqu1lgnYzNuzBqKjnJvX7rpv1bX6W7MaUILeT
         rhBfH1tpSTcpCAWgV44CcD/0UZQvC3FvqlkitCoSrVrzseX2wLlgywiJw/3HyIn6tuWS
         iqPWUG7pVFKpYwbqXzrIcXeDqQVgZka5YiOdK6QghMyiiYOlRVcNtftcUXYHiA8Vf6my
         Xw1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iA0qEOtZ8sY0A4PQMCyKkXrxyPKJc9xjSndOAsg0m2c=;
        fh=TAk0/BGjdMrxT4z6P8EZX47tmYM3X9ZrJ5O56JnK3z4=;
        b=jM/qeGMOGgAnLALG7l+UMQLXoK33MBe+n2Um/5EC7QmPKGbbYHdLN2ZWgbIZ/G80wv
         q6mRLJgTrbeYG8DM035+T+4CrwfrJiZA9OWR1PwQtwXNPIZ8jLkpZxBd7QtXVDeFcsZL
         rpZrmsA83JR0Bmrf/VNtfn/Pot6TMCqKUlOCS95tTe1rzXBfeigR2RcHnaEyA4X6syln
         CPWG9iGchAGOprQPdrXPna0K5Elqb5TfRIzbUF+SiFMBonnBaiJg+Zg6SxglwN4uap32
         scVV/3rm1HIVg0J/guXwqxadrdcgfQKUQi2zUlqRPp7mFgPk0rtlUpBcqkXRzv+/uoV4
         z3PQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774390801; x=1774995601; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iA0qEOtZ8sY0A4PQMCyKkXrxyPKJc9xjSndOAsg0m2c=;
        b=uW5xvVvgBoBwqUsGYykOm7hvWBUul7DMmdnu8+eUmklq4fgm6HAAQKXx6RSclaZ6QF
         1CjQ6unu/sd7d0bauUnJlCexPFZ2w48M/Q+IIxcbFfknRLUAjLfK5vL/bnUSk/UpZA6r
         4SAs55L0KXSia38/0TI9nrMdyNdmGwWxA7N9PffdPkwWCVESqiEjCYAv5/Lemr6pYf8j
         /AxB0UmKMD6tz1fPtIzYQ40onuZTq4IXOqQ6SabWqmeiM2lsN+rwdWsMi6hDq4C5IN9l
         HTcTsqUpDq1nR9zRizXwcos84Yi4m4X+wMuDU3ViKjdHup/coG5dVtqiC69u7jP6cKzT
         oQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774390801; x=1774995601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iA0qEOtZ8sY0A4PQMCyKkXrxyPKJc9xjSndOAsg0m2c=;
        b=rIgkZLfMsX+cSHdUBgfa0RcxSIZ6A3yvY4X0g7+X4MJJ07tQgKY+DZsd2YIZJJfW+O
         WDAnFmQiOaEgJaNmLgpk+Ml5X2kXyBU2g9tOKkmrXN9zCadxMAS1dzcQTqLDeo1RkZwY
         28RA/qk3Xm7ThfsXX5M649meG3DOf+W+pzDOm1GqnXioUWma7lGSlfBbXylM4R7fjX+t
         0fZs4ryEyR9SrWx8dX2Eedn9ZvtWvO+Tx5AnyDXiBaEmdlScCOqeJwW+18KLwTfpW5gq
         h1T7pfjdIhjzQRQm1QxPBfxigH2Z593u4ddSRwL33E9CO1PfQYPTYza/RVm0QCEoIigu
         mk3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXIP1FexevVT76stTjRUL9/T5ifr+Bi24esIray6WiZ/cVO9J7DKJLTqTdfgA+ZOkmJwE+NtL8l6A==@kvack.org
X-Gm-Message-State: AOJu0YzpTZm0QxK3Em263rWqN8SAHkTCXzsjATV7F0axzm0Y0T9utCpa
	yMwO7Lxi8ODeewt1pg6F5KS3fePFmCsYw9ZkR6D1kabpdNbnFAQUOFn2euwYBxlh7A/Yb47HyP3
	eSGR5G0CF9zJ5y5CD1V2SHj3fqqjZN57cB4+SAU6w
X-Gm-Gg: ATEYQzzsHsUDDhKoiuTzQCp+j6X2nT+3RR2jFN7ZqEvj3bgRWd3Mfuf6x4fBJqU1gwB
	nvJTvJ1xD+S5KSKhrS9x00L1aRgWMqK5jDFiKGpyMW2S8pM+LtAIK+V1gYmU6S+dNxNdzKqS11C
	mWiFXQ2V1Z5Qf9vk72HbXXqd/LLWvI0liyVS7K9VT02nwatNZ6nEv29SQQx95p2/IT4/u+KcG4a
	oRJSYSWdx+FuF6zEdmTxousNKSMbAUEMJFvt9QWZ4Gh1eO0yelUogTTcjk7ZxGT9QYHiOuMiN5x
	SkW9z1Y=
X-Received: by 2002:a05:622a:a0b:b0:50b:4e90:44ae with SMTP id
 d75a77b69052e-50b83d9432fmr2305211cf.17.1774390800883; Tue, 24 Mar 2026
 15:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com> <20260323175340.3361311-2-avagin@google.com>
 <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com> <acJnOB-rlyt-3jU4@willie-the-truck>
In-Reply-To: <acJnOB-rlyt-3jU4@willie-the-truck>
From: Andrei Vagin <avagin@google.com>
Date: Tue, 24 Mar 2026 15:19:49 -0700
X-Gm-Features: AaiRm52g4xzDr5_5nSdTi4eazdyhs8piBH0WKAbvFvJLqkZfV7WhTKZGEWCKiO0
Message-ID: <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5A1D2C000C
X-Stat-Signature: xnyubg91q8s3n64ectzfqc6ppekt6d1u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774390802-783251
X-HE-Meta: U2FsdGVkX18+JdMDqnXPVLT8wlVjljn6u5iEyYBikSV0R/PgOxuG59AEVHkCHi2LvBSkaRem9vv6bgTAFgDtcHICIn8mQC+jqB+DF832SJDhSD/OJUngL/Cu/IYOBRwGWfYyaoyvu3qw+qchyaB45r2S+rrn8Ikdg8lmnSIQbWIQpU/h9BYS83uZdhLiyAVQavFCJ5ofEwMzQVmOE6/2KIIvWKN0Hdxtq0LKqsmv/+NTdXM9upbHjWG1PKb+hCITZB/Pxf2MJ2jUJilvQOUvHdgs2snp5mmTOTAdO7k26f4kCtTU7N3EAz5RGrvVWvkzk7OOM2Ho/PVYlZg77py51r+/qW8pqo+lJyKK3cK85G+Ap1e4GPcBf3JjXx+LyekBYiIKqWUjdsPANa/4cx64C239IdQIdSnmmL+h24Px2EoLaVi7dWWvT7zezYlVL7DqyqLCmcgNwQelMsnKZbs+bXBmoNTS3AaUIzgrAbe6EE0jI0C+jxEmSCjE4BbJieRhcFxxTp8mlYQ+9A5qOWHHi74PNt5LBPavINikm+xd5tx/pka8RNKjv+y0bBrGabueF/XOw9ZD124gKiWExhIpAH0zk+h+ZHWij7VMrtBcG2h4TIrvXeJhixQxdcC66Rh+g2S8uquZm5z3/4NPVv33BWJaRXrh2bQCN340DvZFYsGWEtWsU7bRrqEK+U14Nd5yB/XH187L+KZ1L5uv1hARjiYXUzVRP74Ndw1wQt7FdMj1JeAlB65qriM48Gs4MLSyDdkdqgcxzIbAmUqFdqt6a1kGPzMZ1UQBZ6ETfvVYjITpYmFxtPU1w8VKWKh8/o0Iu63Ul+/tHINTN5Z4OZ1ZIR9Tr179ef5vP0vfKBpV+0k/Rngp2Xfxfw72twMP6NsmvaKVaqlLGtsYYCjK386kcsWHMadlhK218+WQyrmD6VhoC1W2wZ1i7vwDOObMP1rzrEmBOphXyVtfSBn8NJK
 /Ji4DekT
 LRmiumfD+Pt4CofguRqnK2idnn05gfs0ID+yM4srqXrvSp+EjxuI2raYw9ZCuLGOvo2eHRKkwLSWZvn326nV+Qkg2vf5mnsscjbsDRgqg2bsIsvQ1V0zJ2W7i58VzZcgojSbnnAxUsMqRRaRyIdiU2gNGH2leDkwQ/wJTCEpj/f3TWKhbyVHKyV+dTh2yR67/yvd/CC6p3Ezcvd3bKKDm2y8uMl0IjTUbiN1WS2+GMn0DUT0p4bi9+6/7tvEY/cAgtNgmEybjyuOkUVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mark and Will,

Thanks for the feedback. Please read the inline comments.

On Tue, Mar 24, 2026 at 3:28=E2=80=AFAM Will Deacon <will@kernel.org> wrote=
:
>
> On Mon, Mar 23, 2026 at 06:21:22PM +0000, Mark Rutland wrote:
> > On Mon, Mar 23, 2026 at 05:53:37PM +0000, Andrei Vagin wrote:
> > > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> > > AT_HWCAP2, etc.) from a parent process when they have been modified v=
ia
> > > prctl.
> > >
> > > To support C/R operations (snapshots, live migration) in heterogeneou=
s
> > > clusters, we must ensure that processes utilize CPU features availabl=
e
> > > on all potential target nodes. To solve this, we need to advertise a
> > > common feature set across the cluster.
> > >
> > > This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> > > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  W=
hen
> > > execve() is called, if the current process has MMF_USER_HWCAP set, th=
e
> > > HWCAP values are extracted from the current auxiliary vector and stor=
ed
> > > in the linux_binprm structure. These values are then used to populate
> > > the auxiliary vector of the new process, effectively inheriting the
> > > hardware capabilities.
> > >
> > > The inherited HWCAPs are masked with the hardware capabilities suppor=
ted
> > > by the current kernel to ensure that we don't report more features th=
an
> > > actually supported. This is important to avoid unexpected behavior,
> > > especially for processes with additional privileges.
> >
> > At a high level, I don't think that's going to be sufficient:
> >
> > * On an architecture with other userspace accessible feature
> >   identification mechanism registers (e.g. ID registers), userspace
> >   might read those. So you might need to hide stuff there too, and
> >   that's going to require architecture-specific interfaces to manage.
> >
> >   It's possible that some code checks HWCAPs and others check ID
> >   registers, and mismatch between the two could be problematic.
> >
> > * If the HWCAPs can be inherited by a more privileged task, then a
> >   malicious user could use this to hide security features (e.g. shadow
> >   stack or pointer authentication on arm64), and make it easier to
> >   attack that task. While not a direct attack, it would undermine those
> >   features.

I agree with Mark that only a privileged process have to be able to mask
certain hardware features. Currently, PR_SET_MM_AUXV is guarded by
CAP_SYS_RESOURCE, but PR_SET_MM_MAP allows changing the auxiliary vector
without specific capabilities. This is definitely the issue. To address
this, I think we can consider to introduce a new prctl command to enable
HWCAP inheritance explicitly.

>
> Yeah, this looks like a non-starter to me on arm64. Even if it was
> extended to apply the same treatment to the idregs, many of the hwcap
> features can't actually be disabled by the kernel and so you still run
> the risk of a task that probes for the presence of a feature using
> something like a SIGILL handler or, perhaps more likely, assumes that
> the presence of one hwcap implies the presence of another. And then
> there are the applications that just base everything off the MIDR...

The goal of this mechanism is not to provide strict architectural
enforcement or to trap the use of hardware features; rather, it is to
provide a consistent discovery interface for applications. I chose the
HWCAP vector because it mirrors the existing behavior of running an
older kernel on newer hardware: while ID registers might report a
feature as physically present, the HWCAPs will omit it if the kernel
lacks support. Applications are generally expected to treat HWCAPs as
the source of truth for which features are safe to use, even if the
underlying hardware is technically capable of more.

Another significant advantage of using HWCAPs is that many
applications already rely on them for feature detection. This interface
allows these applications to work correctly "out-of-the-box" in a
migrated environment without requiring any userspace modifications.  I
understand that some apps may use other detection methods; however, there
it no gurantee that these applications will work correctly after
migration to another machine.

>
> There's also kvm, which provides a roundabout way to query some features
> of the underlying hardware.
>
> You're probably better off using/extending the idreg overrides we have
> in arch/arm64/kernel/pi/idreg-override.c so that you can make your
> cluster of heterogeneous machines look alike.

IIRC, idreg-override/cpuid-masking usually works for an entire machine.
We actually need to have a mechanism that will work on a per-container
basis. Workloads inside one cluster can have different
migration/snapshot requirements. Some are pinned to a specific node,
others are never migrated, while others need to be migratable across a
cluster or even between clusters. We need a mechanism that can be
tunable on a per-container/per-process basis.

>
> On the other hand, if munging the hwcaps happens to be sufficient for
> this particular use-case, can't it be handled entirely in userspace (e.g.
> by hacking libc?)

CRIU often handles workloads with a mix of runtimes: some linked against
glibc, some against musl, and others like Go that bypass libc entirely.
CRIU is mostly used to handle containers that can run multiple processes
possible based on different runtimes. It means available cpu features
should not be only specified for one runtime, they have to be passed
across different runtimes. I think the pure userspace solution is near
infeasible in this case.

Thanks,
Andrei

