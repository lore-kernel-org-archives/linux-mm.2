Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC86BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EF78E0003; Mon,  8 Sep 2025 13:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF2C8E0001; Mon,  8 Sep 2025 13:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D56B8E0003; Mon,  8 Sep 2025 13:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F115E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:47:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8AFD1A021F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:47:20 +0000 (UTC)
X-FDA: 83866814640.06.6911D38
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id D06504000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:47:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="mi/V/vex";
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757353638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siEsv2pirHTuHZt6M2d3vtcT7Pnt/qFkT+meHrSYc7I=;
	b=dl0qztIcgK6YS5vt7+nGQHubwojsuU4U6a0WQKMJKDjn0awyg3G6hF6QYVnT1O1P/jouTE
	UaayrgKsTWKtHiSiLUaFl38uveF+JeajQxyLpIfJgtjtrIdmQN+PoGYwGwDD8drqulgl4p
	onSWu854yQc3lW7aGn6bNRGpPXm7KP4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757353638; a=rsa-sha256;
	cv=none;
	b=rpJuyLp8lqod5TQIBwTCfNiJ/rGnBLJCXGiI6AQ+YYR0LSpA1DGSq6hGGtcfb5cmYLmMpe
	8Je5QeM8FB2NzCTsJoK0xO2gj69E+zKJfS42kToCcmGBinbJs821FVy1lKHQcLepbJr7vG
	G9WwRSsUyu/xcLf0NpKvfqyQJGZuHeI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="mi/V/vex";
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so924971cf.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 10:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757353638; x=1757958438; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=siEsv2pirHTuHZt6M2d3vtcT7Pnt/qFkT+meHrSYc7I=;
        b=mi/V/vexDEadaLJKUGhaAEYwqV7lOPlk7YN8aNZx7TYnAQ8glYP4/MdZ74j2XzPyo4
         wftzzMSuyDmM0rWoGlKGEJv62RThZOKg5o8BOv8xKPKSm/2Q3UisMHJm2Ul5jQtQWsMB
         fhxWZjWh10bsMhvkLlgFVRJki5lhNvXL9uGY/x1gb/ZyKoyj0aHEHA+2BjudN81JRERo
         cp5E4kNALZ6t7SFI8A1x6MMeTP+rY98cdef2v8WEaTewVyh7FVJfUzwbfAp/TovmLz/m
         35Wk/IdriBhbx3Gcdthp3RInt1xpNvr255jIj39KQuOPJ14dqQcgdP3r9qlDWo2W7eUW
         cW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757353638; x=1757958438;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=siEsv2pirHTuHZt6M2d3vtcT7Pnt/qFkT+meHrSYc7I=;
        b=PLWNtTUjAcEwo1wvImzCYrux7KDaUnyICpGv5MGQHuiLKsnMN53PUpmknGA2mwZWJf
         EvmiAoXTE2Sx4ravx0Yqs6VPCJYb5njAfe/6/DaYvX9LyiWtWQyTZa5COxxoQAZoMzTJ
         5O8Ag5/KK1rvwlRR5znusXQfiL7EOApVDYyDxw4S23Qzp3zMWjLLZQbG5omAbcUy9KqO
         cZr142OKiqsXJ3X6vcqzCAqZ4asuuzLeLDaBb3nlFyOuG74iwWYrXvcuMoBcsp+mU5wy
         6Yjlv86DOMsQEKNZCcKlVtNs5YnBtXKTFywGGjCT1Wwlk1PAgBQGF9/fNWT7TlYklDdA
         PVVw==
X-Forwarded-Encrypted: i=1; AJvYcCUUbMoJkDLQtr6zn0kxVzIVZWW7lGHtIpf9dPkAV4OAtDtEz7NbqBAq1CLIyZG9VlnOSekzKQ9Kyw==@kvack.org
X-Gm-Message-State: AOJu0Yxu0hRMoze1B6N0EJI4x83R1DcMPAW6i5P97Nk5ydc6/Uo5BuBK
	sh8JAg6rKAGwK9GTDf3j4Oqgo2sZoJyOqoTAeOHKBIlEcjIftndH3KIlXrvXRnXKJplIuZ8ywa5
	AqvvzfaHA0nT/JK7//Gyal1SjGpwW4eP9Z9OPVxUc
X-Gm-Gg: ASbGncvPpGXmrzv2+m5t3fFttRQHZ1JCtx6MSUBuG8YD+uUUD5i3Q/R5UROD+w4LOL8
	S0tZ1T24Aq3C2ksCCWb9295jGx4kCV3SkDhO5YcWOWh2LzGuoHh6V602/s/hWdQYLeeTxKx7Ski
	YDo8TggllAwrEvAMrN7uWkRm/k/Iu0CHmFKkMpC9iH251ly1O59bKxwRNBUTkI2O+I964IC2ZIX
	Av0rIlW0pv1
X-Google-Smtp-Source: AGHT+IHBpoBHctX0ggJPD9Xzmyyd8HgpBtBxge974et/uW/ujee4+Lwr6N52wAFhOd568mp126yqL4bB50l9eB9dkl4=
X-Received: by 2002:a05:622a:1a9b:b0:4a9:a4ef:35d3 with SMTP id
 d75a77b69052e-4b5f83a34bcmr11651441cf.7.1757353637363; Mon, 08 Sep 2025
 10:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755190013.git.pyyjason@gmail.com> <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com> <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com> <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
 <aLFKHGe2loD657fu@tiehlicka> <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
In-Reply-To: <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Sep 2025 10:47:06 -0700
X-Gm-Features: AS18NWBVRSHhKmkbky6crK-2Tia3zeDy6qS8rf1MalWs3LSVJvFAqHjRkt7WLkg
Message-ID: <CAJuCfpFynEuwBSu28UiRDjWrayN-raX4Nqqh283MwRoJLi8bMQ@mail.gmail.com>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Yueyang Pan <pyyjason@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sourav Panda <souravpanda@google.com>, 
	Pasha Tatashin <tatashin@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D06504000A
X-Stat-Signature: nk7qpjcz1yk7o75q3fu1i4wbyt1aonuf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757353638-973362
X-HE-Meta: U2FsdGVkX1/QQalVchbASJi5DNZYfBV6BYHRlhOfB3roefF82vb3Xb7ZI4JUkMeHKGRtGaEMW1MDDNBFN/zhv9CrmFtFZAb91N+rNK5UIFKWUGczbc4vdU5v1yIh+ftbE/RHMq3LR/81kaN/BXnMpXpY3fCAyyHaUfqphAMjj0jdb0zBeMz4Bnxqqw3omkGTj/0nzS+lXDKvYCnzAg5lHMfJwZSqe34MH2tekvROBem3du4mz4tRiGG7E2O0xxYCCzy0/vlNQZHtpf7SOds/UPE0QyzDlYJF0q7pH8qWnJq4m7oUfUCPlJVcKdhZKjEphsN2Os4hir1UttPfgVyIDeYmAndQ5WhX+lUajCs3NmYxdfwEL3h1q0UiGlNxOIiTZ8buOGqUQq92n+e+y1pWN+lWU1CUtvahEyMlFpk9nswXcI2Y/6tXOfVSEfOZKhbFKCNjjPJCxAU6OWpACK+z1kZ3OJxZS2Ii1nkU2SowoUbXCwEfWmlIy/I7cTF4iZifm6ZUF692pwSF+wJHgM83wfV3XeShiIdorHGGP28EFfKXMHv97YfLuK7yqXSTeRyKRkHCJY/9JTAkqg3mJZZfqqAYH8D2SMHH88aVkr0TfrMhUnJDLbOUWpHAkwpgrSICfpi0zUrAhq3sRqD53lRV1oZjVdNtpUOuNabeGd/aaQ/gG73ku14r89R5GFPG9ZEZ91T/gBCu1fRl3z65xLGiIc+zaPGSV77NDUwY7+Y6Y981ml0MD5KdRAgmcGYya/RCkWVEXdjyAy/DroAAd859Mv0O2B9P32Nkk1ubTSTE3CBBzPAxeZi9vhbBD3GSOPNfVCoW9yCRoOTy6GhFOX0s+NvUv51Q1VC+6ZhyaDGrHgRelRDxmi9R2bIlq6CmEElGwcMh3STFzlGKDm8T8+fvlA+a0zCGr/33REL5h+3JCM0marH3xLfF5kuy5tPkiMh2cUatkpzbBxI5hSR63Ym
 bI8D5hUD
 TmMHYZlJGcwK9BPfSxk1ax3aeMJigexIfNqybqoRrHPjfwU/zVdB8fzEn5z7c99hVxkNhHjDlR//NmwSweekVKB26JU/YYQm7y9/wCV4OKJuusIQ31Af1yz0OmIRQIh6jb/hz/+FAlnefMakpsmx0uAove2SF5jg4iq0CrojeGY+N8HtOV0O2IGxhFxuO6leaQxJyaX2LGskjywQ82u5KGAddaoFHpv7tcXZNf6NNlnc0f53jT8prSSF1Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 10:34=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Aug 29, 2025 at 08:35:08AM +0200, Michal Hocko wrote:
> > On Tue 26-08-25 19:38:03, Suren Baghdasaryan wrote:
> > > On Tue, Aug 26, 2025 at 7:06=E2=80=AFAM Yueyang Pan <pyyjason@gmail.c=
om> wrote:
> > > >
> > > > On Thu, Aug 21, 2025 at 12:53:03PM -0700, Shakeel Butt wrote:
> > > > > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > > > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > > > > Right now in the oom_kill_process if the oom is because of =
the cgroup
> > > > > > > > limit, we won't get memory allocation infomation. In some c=
ases, we
> > > > > > > > can have a large cgroup workload running which dominates th=
e machine.
> > > > > > > > The reason using cgroup is to leave some resource for syste=
m. When this
> > > > > > > > cgroup is killed, we would also like to have some memory al=
location
> > > > > > > > information for the whole server as well. This is reason be=
hind this
> > > > > > > > mini change. Is it an acceptable thing to do? Will it be to=
o much
> > > > > > > > information for people? I am happy with any suggestions!
> > > > > > >
> > > > > > > For a single patch, it is better to have all the context in t=
he patch
> > > > > > > and there is no need for cover letter.
> > > > > >
> > > > > > Thanks for your suggestion Shakeel! I will change this in the n=
ext version.
> > > > > >
> > > > > > >
> > > > > > > What exact information you want on the memcg oom that will be=
 helpful
> > > > > > > for the users in general? You mentioned memory allocation inf=
ormation,
> > > > > > > can you please elaborate a bit more.
> > > > > > >
> > > > > >
> > > > > > As in my reply to Suren, I was thinking the system-wide memory =
usage info
> > > > > > provided by show_free_pages and memory allocation profiling inf=
o can help
> > > > > > us debug cgoom by comparing them with historical data. What is =
your take on
> > > > > > this?
> > > > > >
> > > > >
> > > > > I am not really sure about show_free_areas(). More specifically h=
ow the
> > > > > historical data diff will be useful for a memcg oom. If you have =
a
> > > > > concrete example, please give one. For memory allocation profilin=
g, is
> > > >
> > > > Sorry for my late reply. I have been trying hard to think about a u=
se case.
> > > > One specific case I can think about is when there is no workload st=
acking,
> > > > when one job is running solely on the machine. For example, memory =
allocation
> > > > profiling can tell the memory usage of the network driver, which ca=
n make
> > > > cg allocates memory harder and eventually leads to cgoom. Without t=
his
> > > > information, it would be hard to reason about what is happening in =
the kernel
> > > > given increased oom number.
> > > >
> > > > show_free_areas() will give a summary of different types of memory =
which
> > > > can possibably lead to increased cgoom in my previous case. Then on=
e looks
> > > > deeper via the memory allocation profiling as an entrypoint to debu=
g.
> > > >
> > > > Does this make sense to you?
> > >
> > > I think if we had per-memcg memory profiling that would make sense.
> > > Counters would reflect only allocations made by the processes from
> > > that memcg and you could easily identify the allocation that caused
> > > memcg to oom. But dumping system-wide profiling information at
> > > memcg-oom time I think would not help you with this task. It will be
> > > polluted with allocations from other memcgs, so likely won't help muc=
h
> > > (unless there is some obvious leak or you know that a specific
> > > allocation is done only by a process from your memcg and no other
> > > process).
> >
> > I agree with Suren. It makes very little sense and in many cases it
> > could be actively misleading to print global memory state on memcg OOMs=
.
> > Not to mention that those events, unlike global OOMs, could happen much
> > more often.
> > If you are interested in a more information on memcg oom occurance you
> > can detext OOM events and print whatever information you need.
>
> "Misleading" is a concern; the show_mem report would want to print very
> explicitly which information is specifically for the memcg and which is
> global, and we don't do that now.
>
> I don't think that means we shouldn't print it at all though, because it
> can happen that we're in an OOM because one specific codepath is
> allocating way more memory than we should be; even if the memory
> allocation profiling info isn't correct for the memcg it'll be useful
> information in a situation like that, it just needs to very clearly
> state what it's reporting on.
>
> I'm not sure we do that very well at all now, I'm looking at
> __show_mem() ad it's not even passed a memcg. !?
>
> Also, if anyone's thinking about "what if memory allocation profiling
> was memcg aware" - the thing we saw when doing performance testing is
> that memcg accounting was much higher overhead than memory allocation
> profiling - hence, most kernel memory allocations don't even get memcg
> accounting.
>
> I think that got the memcg people looking at ways to make the accounting
> cheaper, but I'm not sure if anything landed from that.

Yes, Roman landed a series of changes reducing the memcg accounting overhea=
d.

