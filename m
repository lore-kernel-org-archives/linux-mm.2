Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDC1CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D558E0005; Tue, 16 Sep 2025 18:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C808E0001; Tue, 16 Sep 2025 18:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C526F8E0005; Tue, 16 Sep 2025 18:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B32038E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:26:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D3785723E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:26:25 +0000 (UTC)
X-FDA: 83896548330.14.8641CD9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 71B3B1A0009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:26:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZS1ZCg44;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758061583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvSjwFL8UuYKuZG1WOg7NuAXvGpOFQScQAyDoq9s588=;
	b=02FAiPOr/F4iS/5LZw5ADSgHuOYnpzaPyYL7D4lAyS9vSDQep5Haimt76CG72nK/qYY5Mr
	0sKGEklGcpsl4IVL2BDa9oTX8+vhotUI/5oGqecodzrUaumlYiJKVhMzpQbFAzqJPFSxdq
	x/kOgB36aPyIwxMW+N81CyQWzz4K4MU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758061583; a=rsa-sha256;
	cv=none;
	b=Owa0LDG0YMsXdFpwTdmzQitsy8OwuJ50cAM4yaTONfVWtm1HSGoNPykBpfcXtRM3BiIXsP
	+0U+xJ6Dvk6JtH60rn2PtTKHmwRvXVQR+D68vAHHEoK5xzuc0QsPoNWA7l0U2E45vBg+0p
	IJQlp0U+8XCqNrdD9DjFjECcK9aT9co=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZS1ZCg44;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b4bcb9638aso212711cf.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758061582; x=1758666382; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jvSjwFL8UuYKuZG1WOg7NuAXvGpOFQScQAyDoq9s588=;
        b=ZS1ZCg44R2OPJAXQ8f6n4veQL6iCo5TboWIZiF5r/9nutuMGnOwLk2jGdbyOWJXXe6
         fGejzv697JHVH3uE3ZBqFPSIbtS3fa8DF3bk91aYvTHOFxeR3R+T10BQoLlCwm/GDu/N
         2XQSIBdoK14ySCDzxJ90SP/dZv3rBObfNRwxVYYr5GxGlNTxaTyIA2gO4UMBOSIPP2W1
         De01Z8avBMJmslAy5kV5cjG7t2g6K1c8IpMrKhKnnb5r3oK2VRHgegKAfp0Wz7vpumiB
         vG4c5cWG1yx7BPGxndxDStnI8HgEiSTGQm+eEVWgwUj7yzGM4qpqjysqGemOh7H2XvIg
         LSTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758061582; x=1758666382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jvSjwFL8UuYKuZG1WOg7NuAXvGpOFQScQAyDoq9s588=;
        b=DgQM4VRzV1l+RcB4oS8eY5uZqUG7cCqr8WbQszUISeDKdbq5zuEH8ojGFavuERsYQ7
         3YMNJ4ybxBWUsA5qRXVnye9af5fSml0o/OB8e6Gi0FSBGMFPtb+kQ4uo09PMvuJNPxqT
         0FnhxX1U80RiHnOWCZn4vwv/pNrcP9cnHedLVBaoiKn4NBKi92onsPzasQacgj8aQg+r
         QhxmG0T42cB2eoaSGMwGC7HBwyr+vuCmr2T+Lpe4jhUTC9EuCNiHBKQiW3FKC+u0C7jG
         E6h1IvVRUiPXuKV70OOmMc0XuM6Ki0m1DQs+9cMEiZWD5BB8EaiJ1q/zR879HAhPpdCe
         0Vaw==
X-Forwarded-Encrypted: i=1; AJvYcCWSkgAZ8OTv8ZP8v6voTiALDUoIV9hxiaGsqfiXjgrEKLjKw9/v7RaFsyTSKrQ5vlv191aB1weQnw==@kvack.org
X-Gm-Message-State: AOJu0YwkzsOfMlv9OC2EAZ4I/XujF8cjJ3DQk+Pu+HWrC4HwFJRwFAm9
	3I4ACT95taeiJE3ItzP32kcHXkzeUgi1aTnZJoIiceX9iYwpmUYc0/lDA1m+DHYm3OPDNRiXaeD
	B4125TU8wd6SS4IUov6Q0JlogFFDD3GVuSpD29Ydg
X-Gm-Gg: ASbGncuAHQocK/xn6d2nsWoKv+CYdk6tHmpsmC/Z77d6cgDlBQpO46O9C21mbOeOMNy
	ob+p4Sf91pZZeLjbq1u2AjbrishasdBHdDKuNyrauLlmFcrieYZxOohimnl5u/RPnxgUd3jLGNz
	JL7MmQQJGLk8mWsaUJMEUnryCOMljRA20kHzHWlxfQPtBD4mFjepIjkajQ4dXvDHnDr02ZiJtxP
	gyGbGq4Xv+xcAqnJRqBVjCz1yTqeZbLkHtqBegs0BG1XbyAQaoE
X-Google-Smtp-Source: AGHT+IFZ5jUYQu6B8QCw74ApfQyzcnqjHFyeE6dxECfr9tGK65ubPC2uIrlJX9wgihBhc3eo1SpLLjs5WriW+JmFBNM=
X-Received: by 2002:a05:622a:1652:b0:4b3:1d1:fddd with SMTP id
 d75a77b69052e-4b9de80cacfmr1899361cf.18.1758061581913; Tue, 16 Sep 2025
 15:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com>
 <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com> <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
 <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com>
In-Reply-To: <e5e3d96a-d0aa-4466-8303-5a7e8f96bbe5@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 22:26:10 +0000
X-Gm-Features: AS18NWAHK6b7mJpKB5w6xp3zfsHo4ykhOEb2aPzZQjR1oXKBScQCFYr1qTsDmd4
Message-ID: <CAJuCfpEULVxMixDjrk_xg7+3+97dkcMmkDd++BaR17X4tDSs6Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 71B3B1A0009
X-Stat-Signature: fk3wqwpagi7ozhyb59u7shhgtw6o5w8i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758061583-862287
X-HE-Meta: U2FsdGVkX1/7+VH9YFqnkJyHI6qcm/2UVAdkfzV3XPdoecsHi7L1e8jp1QTjM7FpOc9/RcnkIxIw97bvNb5YuziXIqZ2/tBYdWp6ahftpfjvX6C+raotE5UsC1b50Cuq7O7MBe9tHSp+yyXPiPkoREqcPq37naGt8mFRBYFEPspek1WFWnESbgAfnkRRBpzeEudpuWRbxveilTGmriCJjAq58xc0cKbuczihW+jXRE5LoweaikKcXIgSYUmhUToDL1jBRtz3W1Ry9WfXujUgIKXekkO4jBwQNFZWUVwXIFkwhbKfo2l0Dx+sVtqbHq8J0lgRLqCyIKiG58PE5GJO3Xtff+y1qRfAiRwcD7aMmwm531F0BEOM7t/y3edeA0T//xMGwEukzlVU8rZG1pLIAeX4CWp4Wl9wLWO8DTaCMtahgimEsWJEu3RKvFhW8qoPUPwjmjQBRZ5iOvqtbqnePlkGxTF7dgSENYX0PAmJBiZtjzmMIkRT6ILi+ysinNGee5dSAjkROUAPyf3GTW7fMTFKYhLwhRlcRY0GN3fNfCg0n+J4zCNoyNiuLtl18pTIrXn7KYnS0uiUzVZT9GvKervKlEL6LLKttYALgsqJ9PPXf1wzmat97hh98CW4RM7w6Y0PwT9PrOBwdOuJIe0TifrzgyGqkd7oqmvJZMWE02MpTdXG2Clp30jjnuHosFy+M7lbVwh/+sbWrdNC2dcTc62mPMjMDYYnLCW9/R1WVW9SB0YWuxzXeJfhoFcyaUaX3EiYM1w+8zwwwrDOY/lDO7fjn+dOIhNWfcI6rbqycL7pTZxXzh0uqjdo7jVo7yKF+jB07m7aHMk36kubCek84lfwkzQez9gUAMX5QAmgReiZIkmbGjzAn5xY0SYerBLKKfdAEMCiaanFOsNG3VNq31eTecIfcMy0tUnScRNZ+C4SoW7ygM6GrhGFKyRZ1MZDLCs7TC58kZUnjMQ7DYv
 0MSNeE44
 HxypRnvOwT5QlVDpiW2bELWmFAV20XDv7iXjNb5jqw1UgOnBvX1MrxmU0ba+OHdXxw6TKzGpRp4R3D8H2j0lykIA6vA9NXBdcVhMMDK+FQzAyYu2JOQ2lkhD4LqtfjZRGBwNLJSeNtHMTsDkyMJYwkTqDts2fOLIsuV6xf9qnK1X7WrKO9GL0HJMktNQweG+YDuBdEdsEeRMlnAslUnJdjJ9kzQI9FB1RCOJWTbaY78r7j5sWYWX8jpjaQoRdRFM/VR+mXBhtyl73dmF5MwvvbFMT1lY7OX0vkcB4rdFa6MBw0ebjUY4PF45wFc/Roz4QC9rAI050P5fEAsYbB1ymMvUHpNiBSYwBBv8j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 9:52=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 16/09/2025 22:46, Suren Baghdasaryan wrote:
> > On Tue, Sep 16, 2025 at 2:11=E2=80=AFPM Usama Arif <usamaarif642@gmail.=
com> wrote:
> >>
> >>
> >>
> >> On 16/09/2025 16:51, Suren Baghdasaryan wrote:
> >>> On Tue, Sep 16, 2025 at 5:57=E2=80=AFAM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> >>>>
> >>>> On 9/16/25 01:02, Suren Baghdasaryan wrote:
> >>>>> While rare, memory allocation profiling can contain inaccurate coun=
ters
> >>>>> if slab object extension vector allocation fails. That allocation m=
ight
> >>>>> succeed later but prior to that, slab allocations that would have u=
sed
> >>>>> that object extension vector will not be accounted for. To indicate
> >>>>> incorrect counters, "accurate:no" marker is appended to the call si=
te
> >>>>> line in the /proc/allocinfo output.
> >>>>> Bump up /proc/allocinfo version to reflect the change in the file f=
ormat
> >>>>> and update documentation.
> >>>>>
> >>>>> Example output with invalid counters:
> >>>>> allocinfo - version: 2.0
> >>>>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_se=
tup_data_nodes
> >>>>>            0        0 arch/x86/kernel/alternative.c:2090 func:alter=
natives_smp_module_add
> >>>>>            0        0 arch/x86/kernel/alternative.c:127 func:__its_=
alloc accurate:no
> >>>>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstater=
egs_set
> >>>>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstat=
e_realloc
> >>>>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arc=
h_enable_hybrid_capacity_scale
> >>>>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 f=
unc:init_amd_l3_attrs
> >>>>>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_=
device_create accurate:no
> >>>>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mc=
e_gen_pool_create
> >>>>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_t=
hreshold_create_device
> >>>>>
> >>>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >>>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >>>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
> >>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>>>
> >>>> With this format you could instead print the accumulated size of all=
ocations
> >>>> that could not allocate their objext (for the given tag). It should =
be then
> >>>> an upper bound of the actual error, because obviously we cannot reco=
gnize
> >>>> moments where these allocations are freed - so we don't know for whi=
ch tag
> >>>> to decrement. Maybe it could be more useful output than the yes/no
> >>>> information, although of course require more storage in struct codet=
ag, so I
> >>>> don't know if it's worth it.
> >>>
> >>> Yeah, I'm reluctant to add more fields to the codetag and increase th=
e
> >>> overhead until we have a usecases. If that happens and with the new
> >>> format we can add something like error_size:<value> to indicate the
> >>> amount of the error.
> >>>
> >>>>
> >>>> Maybe a global counter of sum size for all these missed objexts coul=
d be
> >>>> also maintained, and that wouldn't be an upper bound but an actual c=
urrent
> >>>> error, that is if we can precisely determine that when freeing an ob=
ject, we
> >>>> don't have a tag to decrement because objext allocation had failed o=
n it and
> >>>> thus that allocation had incremented this global error counter and i=
t's
> >>>> correct to decrement it.
> >>>
> >>> That's a good idea and should be doable without too much overhead. Th=
anks!
> >>> For the UAPI... I think for this case IOCTL would work and the use
> >>> scenario would be that the user sees the "accurate:no" mark and issue=
s
> >>> ioctl command to retrieve this global counter value.
> >>> Usama, since you initiated this feature request, do you think such a
> >>> counter would be useful?
> >>>
> >>
> >>
> >> hmm, I really dont like suggesting changing /proc/allocinfo as it will=
 break parsers,
> >> but it might be better to put it there?
> >> If the value is in the file, I imagine people will be more prone to lo=
oking at it?
> >> I am not completely sure if everyone will do an ioctl to try and find =
this out?
> >> Especially if you just have infra that is just automatically collectin=
g info from
> >> this file.
> >
> > The current file reports per-codetag data and not global counters. We
> > could report it somewhere in the header but the first question to
> > answer is: would this be really useful (not in a way of  "nice to
> > have" but for a concrete usecase)? If not then I would suggest keeping
> > things simple until there is a need for it.
> >
>
> I think its a nice to have. I can't think of a concrete usecase at presen=
t.
>
> I guess a potential usecase is if you are trying to use memory allocation
> profiling to debug OOMs and the missed objects size is very large. I gues=
s we
> wont know until this happens, but I would hope this number is usually sma=
ll.

Hmm. Missing a large allocation and not knowing about it can be a problem..=
.
I'll start sketching a patch to see if tracking such a global counter
has any drawbacks and in the meantime I'm open to suggestions on how
to expose it to the userspace.

About concerns on the IOCTL interface, would it be more usable if we
get the alloctop [1] or a similar tool which can be used to easily
issue such commands into kernel/tools?

[1] https://android-review.git.corp.google.com/c/platform/system/memory/lib=
meminfo/+/3431860

>

