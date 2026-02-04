Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF9EEA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 23:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465EA6B008A; Wed,  4 Feb 2026 18:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD116B0092; Wed,  4 Feb 2026 18:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31BDE6B0093; Wed,  4 Feb 2026 18:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAC26B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:52:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80EDEB7D4D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:52:32 +0000 (UTC)
X-FDA: 84408426144.05.F560C38
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 808351C0007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:52:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JvoXGKX4;
	spf=pass (imf21.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770249150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vydobbPXrZrzizZdxwwfY84vYBgm5hoA9LpOro1zZVU=;
	b=XZ5zxidL4kdTDXYC+609IYTkVlJVAkaW34PoN3AT/ZVTIVEMoPrGx/U78mTC+z1mq6pRh4
	U+oKEHpgfN7bKmYjy2B1l4Rlsb2PtwSmWukZf//MZN2DUS5MvRfbjr/bmr7Ild9psodmga
	fb1uWd7MtL7Vu1IrLPoUQZyl6rRZRhM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JvoXGKX4;
	spf=pass (imf21.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770249150; a=rsa-sha256;
	cv=none;
	b=iI1Mr7E+cBj4HMsuIg3FqzpAtUw/bNKQDIqrwKiR5zqRuv/ATZLnU2b3gf/sqQ5S8Mid5Z
	UZlGPrb1ScAWpb5K0OqygJQTAD09CGwY8geO59f5B0+Em9HcyctIZatfSQMMZB2UTdldle
	lb4aDgt4NB3R6K9s2d+l6GQvdMHs8H8=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b885d8f4092so46602666b.2
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 15:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770249149; x=1770853949; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vydobbPXrZrzizZdxwwfY84vYBgm5hoA9LpOro1zZVU=;
        b=JvoXGKX4Mewu0j2FJLVTU0XrS6EYG0TbBu2zlI+6tRITsmu64UZgohPGdMXS5bEED2
         2cpiIh5Ch+eLMybIihKTtU4314fd9Fna1kmM1iHfBb/5ygpM+wgmgVoJ2FdOcl/AOLi1
         fS7SjpwvAbRJ8GqnEOzL+HIOADTEJHGitLsnIM5BY5Ug/yr1vQfkmurpEYz/cZiR8hAo
         FCOlzcY3PzDYxybFPtlbzo2MP5hay3UtLMIN+PtRUp/LieIoOIpGBvf7qFB91R2tr0vi
         8/h36imezP5wlB6YZguC6TId4E+dcWGt3YThjfkdB9PMelPLiphISo/hoqnMvjDQIgFH
         q0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770249149; x=1770853949;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vydobbPXrZrzizZdxwwfY84vYBgm5hoA9LpOro1zZVU=;
        b=rgqw0w8RK2V6j8Ulf4UqQBm4RoJf7L3ACvVOPQS0j1ibmXlZj/GDIS8gTlnbA6ffDm
         0ne4LiSgfkYjRXJLEE9nuobmJv/G00MU+YlIsslnVRnexaI+bj+4ktLMmQE8NI47DDQj
         WWjb4htjdnFX139nkMU9TfbYC9K4taPHdHzqPMVO0VQa/RFESusLUxitdFYZWlIaB77h
         uaaUcoyWWZF2IrTKdDncXOwrl+ROoI8RNZUuuOm66vc4ujwXKS0brfzh+gMggaEZPEpr
         3J9pe7lgTNfaMd+d18pI5k4G4cSB97YpG0bgqvl3wky6p6h7pcBEkrJD75n+6X2W9foD
         ky1w==
X-Forwarded-Encrypted: i=1; AJvYcCUpH5MIFYCiPnxyHiAnKS/0EU2beccdb4Hre4ll8xS1JG0rEtwpohbCjk1oDEpxZ+nKnNpJs/cedQ==@kvack.org
X-Gm-Message-State: AOJu0YwqIY6iGmC8GdvXbg/0NNyKO51q1gnYdvRiLoLEo9dcHkf+ceCO
	TW6Exe/FlwWBxaUCvS5iasIvO+VmWDOMz0pNkIhAAzg0w5/DmougH328oe7o1NQmAA==
X-Gm-Gg: AZuq6aKnHo1aW0Etj8Q3V5FuxhYd5ZxLbCXShpSDZiqETUKlVkFOBoBnivxpnap0Ndx
	vMmCjFd/Vf0PpspOdQgghdk2bGFQldOrsrfpOWIwcsf29jtS6Zp0xBgy6o2f06Ie+XIUo/FM6LQ
	JyKp6fKWlL+JVXUTRIu/0XWM44ILULJj7ZPfU3aMtUJYpMf44iSpM6xTPDEYwy0HQDfBe847pdf
	bdb5AVnVZ6mvTdMhDyBgch7SWGTFC6FN13w9db2Z6bHNdTMNCfdiuGWnOCqPOuBTHOoD+yqd07m
	cEjWvyDimxwyTnQhFXHUEV6HZ+5/dv0tiwnfLVToVgGDMO+NaHq+AXNxsdJX3KAYtId4hRWMxDL
	LpMVz4eceLTm5XJa4H6mbdVMe9779E74HolyM/5ENX46n/r9BXSgxF1oGYowuCAyyvP52RWyyRX
	ITswSJIbqnxvJNcddY+RJCWkrMHzUqzHgixNKQHF8UuRMy/3b4Jk4=
X-Received: by 2002:a17:907:9625:b0:b88:71ec:e7a6 with SMTP id a640c23a62f3a-b8e9f04c989mr307018066b.17.1770249148604;
        Wed, 04 Feb 2026 15:52:28 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8ea0021b25sm164091166b.50.2026.02.04.15.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 15:52:27 -0800 (PST)
Date: Wed, 4 Feb 2026 23:52:25 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Josh Don <joshdon@google.com>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
Message-ID: <aYPbubIPIsfFiMhD@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <aXh_LpTzDhvv20uB@tiehlicka>
 <7ia44io6kbwj.fsf@castle.c.googlers.com>
 <aXnDdkYmtipGwSjK@tiehlicka>
 <CAADnVQ+ghTc5FtJCjm4ya3y3xVpSuJe-7ctdT-thowqWguc1pA@mail.gmail.com>
 <aYAZT-ZZSKdiChfd@google.com>
 <CAADnVQL3+huSAwoYRexoSDaLRK+nEsY6UUnVSmhk_sGYUYsO7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQL3+huSAwoYRexoSDaLRK+nEsY6UUnVSmhk_sGYUYsO7Q@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 808351C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: apsxruaaxu96mumtagqng94nw9x1g3ms
X-HE-Tag: 1770249150-521244
X-HE-Meta: U2FsdGVkX19aVKgJYw6k+j0c15V/PeaSRGv3oPcskfJgayu5ye9szEoJVaZmqmnghsdkssUsOmQm1JXqYhvqqPtc9/UfEZu8d8uS8zUZLD256of/p83g/kLh7fyBkt5t2ZyRmUnRIbHMxQMsqrkkN8VM89MlYujInRCpK+sjnN/GPCChbJcpVvW4YKqiRoJyh0LKkHE0U0wjoOXa5vu2q4Qyj4WBz/GhUu+aSXfLrWVHjMfRkv9ndHkrYv4DDAOZqOR5S7zKav//91stIPJZli2c1FNE+9kSJpx5Q5wc9W3LeR4C6WVVYbLkG21TZiNN83w6K0d6luLEsh/L+sA10tS4CpPaTK6LW+vHn7YELn9ZuSH6a8XklmVAaiIvlmOqs+RQpVgQqsJ7WCeu5d9n4uuMAGUqVLG+lrI/njl1/wlagxlnDNZg4b/sy6XwHTtnzXE3YBG9wVMAEZk7Q1pAx5YvJR40mIyqy4NIeXTjU+JXsxfOjBLVeiL5udgHwmH96HPcWbzcgZpVwVCGd8SEdpohk0BZZwrlaRAWZGo5qaiRtv/jdIP9s5e2Ow7IvwsEnw9FsYxSFTq9zkgFfvvdMyqpwzbmBvHphSUP/GUPsUuZOUMmQAUifVlgHhNH4vcn44EdLrNUZnbAQHFAr5Rqotz6RflnjdFbQrx9MmP4xW8xEHXlofpG7I/LM4ZGhw8lyKqc9hiM7UhXzrkjZbMjQfmUD3cSWAQBn1FQ7qZVDh+oRbSDBqQlWfOQOfDy97UxjV+x+MJ0u+XrFVHtorSlO4iS8m8ctxl9AAsn+eRYwEbVVMwfMjM+hLA4L8yXDZMu+yAlKVKKpD+ZW1IxpIfDiZrwRKpi4TPEkixDd0ELZyycHOewhSn+VvTzvWUYSZOVYU4o/M+cEqXRNV4ac2tdMhnCwPbfyGQdeaKM2RHHv/LsV3AGVgbAC5xu6jYpMEFFdcJJD/dRRW1TOUxSOuu
 5DFSb3gw
 HEhPWWtdQv7lvjG+IZM8p9nXgXXIhDvSi26i72SHq7YO1CnrbVaNuSQnvj6Ts9GE4QaVt9pIEH0hC9p6mRmAfPrq3TWmOSMgJCya5XKTVMgAmpkb5yg9EIg/GnMItzuszhNfmEEtTRLhCq86S7PMfSByisBLTCB/5jWIx0BYxj8/PbDIP2cqvhDu5ifD+du5wLa8Xe5+HoyG8dIis8PpMjADUArQsjRftMFEmZpvfyVr1gujoP/Gr2DjQZe7sLnTR8xaneyoUp2dcT1mlziFbKfYmywbPcNqk04+WiDsP7DlZmj5Xz+bbSRk3S9az3+PKfIm1pQswaiv7Nim3H3NHAN67L7HVRrTiR0DFnsMgzolsRBzo+GA+RE+SIgRQWGLyPOkLKJ4338ZYyHrCIkoVAHwZ5XmFVAbs/6l5XqnAdkovjtNYB9/jMSCTyJQnfWBdh2j6/Ae1HYIAubrTAVwzMCR/u2DRjJ5BE/x1JMRNJdBGPUmxxfi8DXiqHnecovG7Z2p8PjiIqqVeKClc8wuyooqhkWe2EVKiwf1Zq9NqT8Is65aIc9Uzdv82lF3Wb4rR9ZiZ/dcw3axIwFUCc2c7NJRdzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 09:50:05AM -0800, Alexei Starovoitov wrote:
> On Sun, Feb 1, 2026 at 7:26 PM Matt Bobrowski <mattbobrowski@google.com> wrote:
> >
> > On Wed, Jan 28, 2026 at 08:59:34AM -0800, Alexei Starovoitov wrote:
> > > On Wed, Jan 28, 2026 at 12:06 AM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > >
> > > > > Another viable idea (also suggested by Andrew Morton) is to develop
> > > > > a production ready memcg-aware OOM killer in BPF, put the source code
> > > > > into the kernel tree and make it loadable by default (obviously under a
> > > > > config option). Myself or one of my colleagues will try to explore it a
> > > > > bit later: the tricky part is this by-default loading because there are
> > > > > no existing precedents.
> > > >
> > > > It certainly makes sense to have trusted implementation of a commonly
> > > > requested oom policy that we couldn't implement due to specific nature
> > > > that doesn't really apply to many users. And have that in the tree. I am
> > > > not thrilled about auto-loading because this could be easily done by a
> > > > simple tooling.
> > >
> > > Production ready bpf-oom program(s) must be part of this set.
> > > We've seen enough attempts to add bpf st_ops in various parts of
> > > the kernel without providing realistic bpf progs that will drive
> > > those hooks. It's great to have flexibility and people need
> > > to have a freedom to develop their own bpf-oom policy, but
> > > the author of the patch set who's advocating for the new
> > > bpf hooks must provide their real production progs and
> > > share their real use case with the community.
> > > It's not cool to hide it.
> > > In that sense enabling auto-loading without requiring an end user
> > > to install the toolchain and build bpf programs/rust/whatnot
> > > is necessary too.
> > > bpf-oom can be a self contained part of vmlinux binary.
> > > We already have a mechanism to do that.
> > > This way the end user doesn't need to be a bpf expert, doesn't need
> > > to install clang, build the tools, etc.
> > > They can just enable fancy new bpf-oom policy and see whether
> > > it's helping their apps or not while knowing nothing about bpf.
> >
> > For the auto-loading capability you speak of here, I'm currently
> > interpreting it as being some form of conceptually similar extension
> > to the BPF preload functionality. Have I understood this correctly? If
> > so, I feel as though something like this would be a completely
> > independent stream of work, orthogonal to this BPF OOM feature, right?
> > Or, is that you'd like this new auto-loading capability completed as a
> > hard prerequisite before pulling in the BPF OOM feature?
> 
> It's not a hard prerequisite, but it has to be thought through.
> bpf side is ready today. bpf preload is an example of it.
> The oom side needs to design an interface to do it.
> sysctl to enable builtin bpf-oom policy is probably too rigid.
> Maybe a file in cgroupfs? Writing a name of bpf-oom policy would
> trigger load and attach to that cgroup.
> Or you can plug it exactly like bpf preload:
> when bpffs is mounted all builtin bpf progs get loaded and create
> ".debug" files in bpffs.
> 
> I recall we discussed an ability to create files in bpffs from
> tracepoints. This way bpffs can replicate cgroupfs directory
> structure without user space involvement. New cgroup -> new directory
> in cgroupfs -> tracepoint -> bpf prog -> new directory in bpffs
> -> create "enable_bpf_oom.debug" file in there.
> Writing to that file we trigger bpf prog that will attach bpf-oom
> prog to that cgroup.
> Could be any combination of the above or something else,
> but needs to be designed and agreed upon.
> Otherwise, I'm afraid, we will have bpf-oom progs in selftests
> and users who want to experiment with it would need kernel source
> code, clang, etc to try it. We need to lower the barrier to use it.

OK, I see what you're saying here. I'll have a chat to Roman about
this and see what his thoughts are on it.

