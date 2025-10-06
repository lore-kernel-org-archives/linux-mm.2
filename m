Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86F5CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 23:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C67C8E000D; Mon,  6 Oct 2025 19:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002068E0002; Mon,  6 Oct 2025 19:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32C78E000D; Mon,  6 Oct 2025 19:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE61C8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:57:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76E6CC0546
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:57:39 +0000 (UTC)
X-FDA: 83969354238.03.0AC64C0
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 936DF40008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:57:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sb3eLbn+;
	spf=pass (imf17.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759795057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aeO5Bf807sImgx5mKyNh9w4Vqa9UgFwbmFN57TCeihs=;
	b=U2sm1efGWTsoMz5GaljQKCja96BO2q/+sXVXDzbJcuJz3GPSqPqYST39edU7e/n71oS/oz
	qtP8mV93TG689XE6j2C6J7pFNJnxp28cBH3xZtAzujs1f2Ny2lvRhhQMP6CNBjAD7TxKFf
	mHbiKeX/SY+JAlT0LXw7Sk1plXkGDDI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sb3eLbn+;
	spf=pass (imf17.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759795057; a=rsa-sha256;
	cv=none;
	b=psm5z2XpzU7rsQUcBHW3aKPun1hAegtB6IumHePz3YM4QNZfjoU/kTKdzNnmcgjlNtftpA
	hPa3YOfJnCJkLoSlZOxnZ3KTLsnvSUCsDfUQgWoIlwpEHzBY00If6CdLmTrqHA3UmeqPiT
	XE2NjPGw9kmSqzdl1Lz4uOfhg4/eFCI=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77f67ba775aso7355789b3a.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 16:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759795056; x=1760399856; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeO5Bf807sImgx5mKyNh9w4Vqa9UgFwbmFN57TCeihs=;
        b=Sb3eLbn+Xo4YakPMWE179qmgSARsZHav01SSAVlJSaKAWleWHtbZ0L6VOE69ecp0nb
         cvgTkB3gKhunfQDgY63ekS+8YTuF8Zks6OtHTBHaR/W/A6WMbi+rajtgm0H69BC01Ua9
         rmCivoXK5W21nI4luOIRkRtvC+bAu2VdkCNYF1V9EMAPVP4oKIWgz5LuRKWbWDgR2mH5
         MtFnv2plCrAoQ6jpED4/CsjYjLIk1CrHaMx3nK4OpPDlUn1SajWJyTTKzkJt6EWJC0Kn
         NajXVSsbTAtC3WqbZlmE0PyPUs9E27aj/aLHWmVbogwbHW5BAuCnqOTXia4kk0PBA3xf
         Jf+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759795056; x=1760399856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aeO5Bf807sImgx5mKyNh9w4Vqa9UgFwbmFN57TCeihs=;
        b=Ggj0PS0H514cIXA2J2XGvCS+s78QfHZ9i9cfeq+FYFi5tD61qhmx6nHiV23ymTaZ9C
         XuOZlBshYP3CjbLC7CMF6yx4Ogd++JKPTXmtuyEb8e2X0jnQogV7cg0vz3R03ECwxi9o
         E3mQNUhZWKE3JZZg7Xs4Sz1e5aW1V3WP+eIAo7zkvhpFVvlpVTN/rqwQH7otSbbeRxKD
         I55xn1KoW5zJKmPCn4uAeijfjq3F9RgTnNQGbEk2W1hGD9AUBFS40dkwDxlVPTmfqWhk
         w84TlkE1RutmTBSr++NIjv7R+ZY0KSCo8KtlKNbkEKAcaGK1em19DhZdNm4JDiFdeXuv
         JVaA==
X-Forwarded-Encrypted: i=1; AJvYcCWQQHZNW27GeVytIavvnLzvRlC8EsXvT/Xsz6g6gt9bV/xyh5NZym8XRyYzSsDPAwqHvKraIX4l7g==@kvack.org
X-Gm-Message-State: AOJu0YwufI72/nbQjhurQtvhWh/ADtpaGeeCrcP8iUKsEoQfA29leGZe
	SQhXz69BncoeY+F5Y6oxk8jP17qXy0KJRng9d5pNNhAi2TtV+HBHb7goWkt0YrAQb1nXc1sLelV
	Tx7lGHpQlakTU6Ck0kNw8RVYIL8oPI10=
X-Gm-Gg: ASbGncsO4CUqfwE19VZGOJE7r2CslXSJMcbJ90UhQXkotDPkszuoXVD7pcOMOieNnfK
	UcVOgRnoijOjMzKOpEaoH28lTWM2inat/OfaPLM2g840CQvY6ccCfusoGrJbloELiSaxyMA8mlg
	jYqOXQ2LliviBw28hrDuezWCehbZt2giSJs+O2szsPLjqDArtOwRCwjecsYLUwA+BKZPBSSvCmN
	cvR5VR16Z40JEBvyW7ziLRGcrnNYNTPdjpjV32/28WtN1E=
X-Google-Smtp-Source: AGHT+IFlbKfL5TblKqKnNhOe1oc4J8CKVBhJt//RaO+QWpyXhCbuSLuhVLl88NwO9ryI7OF3HhUw0Ia1vy0lp2lGsro=
X-Received: by 2002:a17:90b:1b50:b0:32d:17ce:49d5 with SMTP id
 98e67ed59e1d1-339c27a58d2mr18475006a91.23.1759795056201; Mon, 06 Oct 2025
 16:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
 <87wm6rwd4d.fsf@linux.dev> <ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
 <CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
 <87iki0n4lm.fsf@linux.dev> <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
 <877bxb77eh.fsf@linux.dev> <CAEf4BzafXv-PstSAP6krers=S74ri1+zTB4Y2oT6f+33yznqsA@mail.gmail.com>
 <871pnfk2px.fsf@linux.dev>
In-Reply-To: <871pnfk2px.fsf@linux.dev>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 6 Oct 2025 16:57:22 -0700
X-Gm-Features: AS18NWAXVJ5dXSA50rDM1SRzH9Tu_dSgFwL-2Wcn7bv26ZAPiAQh2VJdbHvxDyA
Message-ID: <CAEf4BzaVvNwt18eqVpigKh8Ftm=KfO_EsB2Hoh+LQCDLsWxRwg@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Martin KaFai Lau <martin.lau@linux.dev>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6tp1ibi4geaesd1rpdb19p647j89d1bu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 936DF40008
X-HE-Tag: 1759795057-28179
X-HE-Meta: U2FsdGVkX1/MRnoWUem0tP0vhqMCpiSQkblPQWo8Oz4ETcyFvShzFAxli7rEfDlzb22KIObwBoc0DJjYbLZ19gi0yXYMze7MMP1vUXS/bBQUJoIS1vIvuNCjSLLDqG8DdB35atGoK8hBoPUXxah38RY+7wBryvENigxuR92xRsELUYeLeaWmW7dAIjLg9SivxU0kAIompau+9G2zWfzTVYwREp0OtmcwB4UsESnSVmuKSqFXvh8BMneRAMv2H1L2tVe3CQvzryobtNwlGuDeijy7s6ovTi6vpcge/rPTNP1CUkYOXk6ExUT7vUc6Whs2JBclPLR4NgnGWlHvN2De0fBsyf4LBmgXdnuIbqbi+XRpkfzbXwTX3Du2WzBuqkoQoiYWqWrZjBEUqjuXe9SoskgRGme1B+Y6lBnmtC4UkJeI3as24Y6fpaG6OSM2xnS6db7QzfzR20mDo/fAh6SuZOw+u+0a8v60TdKT72NX+GEoJJGWYivRY0RTvBS47i9kKPi+bmKC1N8kE3BLxZpx7BFRm58X1sUWoIX37X1qCSNbgGliZQ/uOsknaN5tiRberxyJa2G26W17e1OR1rLInlf2+HtZt2bGrAY4RxEqPJfJhDETLIeOgg8Jz9Mtqo7XVOK6Zgb8Bo2dJFYp/UylLBUZop/60fN9Fr+U5/Y2t+QUEfQG3cs+gR1tYGSYvsz3/Iajh/Lvf7T8zrDSdnh7SCfqwsvZpJMBXLNan4Fhvs5tft2J8eGwS+azxMs+5WPPcEjRkTnC7mgLSoIsUGAWx2fcv3MtuE1rok29Xkyr+rhwBxJ/stiY/ir0kN72K7S8MXdedziSyIuvI/c9eLXIMAEiLAXwmPBtWc+iVCZOslF/cflku7qOfq6jLxx5gO6RL10Zd8EpkYZsLlGplOozFlDzuVvlobCxEitTXw2UetBij/C9jy4F6zNvvyNYIzYbeNOSmVOw6fJh+bGAFQ/
 T+MxHzBh
 vMmERICLyICdn1/V8MXHEQ9oj0d1eBMoWOqLEW6/wkTyvB0XkUW2Mwf7uElzXWf4ZEdgi+jHBvfQEhy1+kfLgDAX8LxMZiDGVUmNAfYAuqq4SXOWJNEdEumUvJnhUogKX9aT5cc4rGl1NqnniiPLifsO4uA+OvUJn51+N/+vuw1TOjeTR3gRho9wIQ+6R9QR+3++YrfYhsMIc0bOAk9NWqbkXjL30ZcMZiKIzwvib6Wv8lD9/WbFTfwS26KDCxF3XAgeXkGYG4HcuKTtfuIX6Xen3AOt6K9JsN8ZD3dSt1u3pUFNVtJ9saq/3NbL/tjQrzZIXWxZVHJJ8xpvAPeHmBz66Mf+z9z7aHY/A+RmrkGgb9yrYz+LZh5ywkh9D9e0qwnRTQYRsoDw1jUUT8oq9bXXr2yy0+b3epdyCPk3ruZvUSwPyx0cPB6JTJBxA/vkyNn8oZFzNIHzXllU4JbiOPOGRzPr10stTFIlYD42ZCbWbk1Sn56dUGO0ZxkeCscNTlGrRloo9UiCIukQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 4:52=E2=80=AFPM Roman Gushchin <roman.gushchin@linux=
.dev> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Oct 3, 2025 at 7:01=E2=80=AFPM Roman Gushchin <roman.gushchin@l=
inux.dev> wrote:
> >>
> >> Martin KaFai Lau <martin.lau@linux.dev> writes:
> >>
> >> > On 9/2/25 10:31 AM, Roman Gushchin wrote:
> >> >> Btw, what's the right way to attach struct ops to a cgroup, if ther=
e is
> >> >> one? Add a cgroup_id field to the struct and use it in the .reg()
> >> >
> >> > Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard t=
o
> >> > attach the same bpf_oom_ops to multiple cgroups.
> >> >
> >> >> callback? Or there is something better?
> >> >
> >> > There is a link_create.target_fd in the "union bpf_attr". The
> >> > cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be
> >> > used here also. This will limit it to link attach only. Meaning the
> >> > SEC(".struct_ops.link") is supported but not the older
> >> > SEC(".struct_ops"). I think this should be fine.
> >>
> >> I thought a bit more about it (sorry for the delay):
> >> if we want to be able to attach a single struct ops to multiple cgroup=
s
> >> (and potentially other objects, e.g. sockets), we can't really
> >> use the existing struct ops's bpf_link.
> >>
> >> So I guess we need to add a new .attach() function beside .reg()
> >> which will take the existing link and struct bpf_attr as arguments and
> >> return a new bpf_link. And in libbpf we need a corresponding new
> >> bpf_link__attach_cgroup().
> >>
> >> Does it sound right?
> >>
> >
> > Not really, but I also might be missing some details (I haven't read
> > the entire thread).
> >
> > But conceptually, what you describe is not how things work w.r.t. BPF
> > links and attachment.
> >
> > You don't attach a link to some hook (e.g., cgroup). You attach either
> > BPF program or (as in this case) BPF struct_ops map to a hook (i.e.,
> > cgroup), and get back the BPF link. That BPF link describes that one
> > attachment of prog/struct_ops to that hook. Each attachment gets its
> > own BPF link FD.
> >
> > So, there cannot be bpf_link__attach_cgroup(), but there can be (at
> > least conceptually) bpf_map__attach_cgroup(), where map is struct_ops
> > map.
>
> I see...
> So basically when a struct ops map is created we have a fd and then
> we can attach it (theoretically multiple times) using BPF_LINK_CREATE.

Yes, exactly. "theoretically" part is true right now because of how
things are wired up internally, but this must be fixable

>
> >
> > Having said that, we do have bpf_map__attach_struct_ops() already
> > (it's using BPF_LINK_CREATE command under the hood), and so perhaps
> > the right way is to have bpf_map__attach_struct_ops_opts() API, which
> > will accept optional extra attachment parameters which will be passed
> > into bpf_attr.link_create.struct_ops section of UAPI. That thing can
> > have target FD, where FD is cgroup/task/whatever we need to specify
> > attachment target. Just like we do that for BPF program's
> > BPF_LINK_CREATE, really.
>
> Yes, this sounds good to me!
>
> Thanks you for the clarification.

