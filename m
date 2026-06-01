Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD9FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CDA16B040F; Mon,  1 Jun 2026 11:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4839A6B0410; Mon,  1 Jun 2026 11:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346316B0411; Mon,  1 Jun 2026 11:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAB86B040F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:11:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5A04162700
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:11:22 +0000 (UTC)
X-FDA: 84831682404.18.DEBE2CF
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id B62DBA0016
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:11:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=NBTsJu8l;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf25.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rF1YbX1GbK0HCKyViNv7n8/nM8s/F+cSVonTVlOHUow=;
	b=KC1iI1ysl43qQ/tb3F/TpKmSQCMoJCEblpSazrgMt6Ub36sBbPdhJPhKS5i6AdcYWM3nvY
	02r1uxTJjpY7/frLadyhG/+WmFFt20TtDzRfOsc+MqN9N1J+9fSYUhjnD3/PCmcw8CgbVe
	8laJ3RD2lSbUpkoI/8yudPLVAt0YyHQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=NBTsJu8l;
	dmarc=pass (policy=none) header.from=linux.beauty;
	spf=pass (imf25.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780326680;
	b=gunxXu/vZvDteqY51XHp97xdcOrofWiA7vf7aXggf++kkach97aZG3B5I9jrLakpvjdwNQ
	8Vh8MzPJdDmCcADMuGgAn9Sg5vjXkU1cw9ec2CxgUfYxs7O1H8pXx/YsfhWhXIbQH9iOgr
	S8UsNPISYg2pBaXqe3HHcVL0nZtt3lc=
ARC-Seal: i=1; a=rsa-sha256; t=1780326667; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=L8ITIHHb4gzEAhuB0YAEMjbYObr2ley+TReqTgwYv34mCJNdyoGhDI4zS0AQ7hXLP7xOiJahoycGB9smVOFA0Gusy6DuPRgJR62lvDQoDDCnSvfm8FU6I/bRIFcK7YUGwu732cdTSoSW398dsLlKVuAnZ6qR2yifg5jjNCQRadc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1780326667; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rF1YbX1GbK0HCKyViNv7n8/nM8s/F+cSVonTVlOHUow=; 
	b=n1rf2uwrq2SJzBx+Xw53/2evzOB2Ia3o2rzx/5ptuR+kDUsxe9Uodkmd1pkK1ixXAd1BgtKKJPkmOB7pLPKZTkb2n7TY3U/hADyLZpQiPPIiSv4mo5PGTIySaBXkOD1eMNclw3CLjRo4a22iYYE2WQbv2yMrEV675Vk3E2ZTPbs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1780326667;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rF1YbX1GbK0HCKyViNv7n8/nM8s/F+cSVonTVlOHUow=;
	b=NBTsJu8lDNTq/agD0USlvYHq4KyXMkb+qmgaxQPE4y1cNSY3Sf5G+9qNXKIzXlhq
	NzhZN0ebVwruHOz4D+avF8xaaXGmFbEZ9bLW4Zj0fqILR/j4irWgoKGb5gpKoam7oWW
	Zgn6uCt6lyXhECZjY2yFhsU8aNnsqNPZQyfqEdVY=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1780326663456505.7763831684913; Mon, 1 Jun 2026 08:11:03 -0700 (PDT)
Date: Mon, 01 Jun 2026 23:11:03 +0800
From: Li Chen <me@linux.beauty>
To: "Mateusz Guzik" <mjguzik@gmail.com>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"x86" <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	"Andy Lutomirski" <luto@kernel.org>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>
Message-ID: <19e83bd050e.1f0e5b93379754.3822464952169533411@linux.beauty>
In-Reply-To: <vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
References: <20260528095235.2491226-1-me@linux.beauty> <vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B62DBA0016
X-Stat-Signature: kiw6uuoa9dpk8f97hysga9xuoztqjrcs
X-HE-Tag: 1780326680-95823
X-HE-Meta: U2FsdGVkX1/Jfdal03tQsMiBoWNVk2ibW6KlZMQue19Utc6/iBJwT5v/5YfZuuAgclmSkFMYykLPyKiSPS/2yBXrbl0NkHR21dyHSVG3qq98xDSXCVSLcfudpv26uR5BAO1qEBG1SGQXcZsfZuhvkA6MVE0PCgny1K+W/Rj0GjIzEKrg5hwgcgPKC6pQL55QfhLjj6PagnkdhhE0BtkSqqpRfhPzHRMUnORccRxWtXyeJzc9YhFSJE7i44goTQilkyrTMtT+0huMvCLbaWkLTx2HqlPKgmN2wwJ9cBqvSYoN8O6lcyVAcKvJ7AWMsbuFMUSqLeG2ozoRKdFH48QgY98A4sGMIlwubVTOi8XSJHH2fU/gNBLMEphWZ74nh6gRBulgKmZVwhjXqcV2jEGp7gOIEslDPsGH1XvPH+YH4XGeirPWD5LVgdVxOYg2PaboTOBEolsRUSRRbsL8MNDqOCww0oNvLdO1Dibj+8qEoRVe7Fir9sOOLscI0RrQmffuyEms+GENmorP0fS0we5aJMiKd6BaL2PzGcm4+gaMmfKhHOij8IU2GGnX1wq3oWIoswfLEQXs8YZ0+MIeZa/yGGmmrAYQCgaHTj0hSO3ihw34/oo6Y5Mal+4LmRPUVhpwgSEtTtYGVQvXejqFPAw0Pl/iYiU+giDYGvexvjdzOWRQ3Sqx0RzFXxB/tPVfvJlvEJ6mM19NJdcQhbb2hOjlk1cGywbOYckQj+kAZKhPeRFScyAXTj4OJrc4pni0OT2H/2+J+Eo4bEH0djBDwbsegdjuMRO3sIoPp6Zja73uxFVlgVQTBVmA3OLdJuUGn+rnLRHE2ezLq6VyvvW1N+KSo17oBBEqOWMijVtWjDxdF045PM/LgqhMPQAS7scb9htsA75KXpaoadFVKZXc8gblt1RLuacuXqSJHnKj/QpqO9oDbWvD20Z87hjRymlSgFVoj3Aig2vIHhNQoKbGNzc
 GzToMHP6
 rFHNAT2/oiMTmjwkCDdAkZ8WEIWHlDIIhGsY1lPlFlobj4sbWE4mUfCGwzGq81O01TCju+KeTKwad/OR2TwqDMn7sMNYOrbZV1UVH83B64FYl54gk9VM760/DhKSy3ZOj0p4W/udDfjM9MGBLyPJYjbgZI469sDwZZMwoYcjLsEjGvFulKFMrFA8Z09NPUBstOnNfEeLSIAyc6tGl5lEjf1Ob8CD9w55sei/3hLYHalXpjJ9gN0hZhqkYIlHdiPZyeIh5m/faQk3VIY29VbxXYt0KU+58y41iRhY52wsCDPCSDvCGKKCzBsMP6DjlzA/nms1FfIAoRgpS6fKp8c9rmgKNSmdUftZarcT35ABvG4xBmAofxObvYBsVbiHPBUY2n8BSsSP1molANCLtrC7s2Yxgnok2Bs4d1PHxcylipCIDlGse5wVySnZtavaW9U/tCZUvUT0eEYmuAYx6gDi8jQedY6UIT7jAauG7kDLOXV8hcZgYQa8DZ9tEPJEuxcTbIZHLbtCwiplRw398QTSSmbRyIaN5gBITJc0O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mateusz,

 ---- On Thu, 28 May 2026 20:55:32 +0800  Mateusz Guzik <mjguzik@gmail.com>=
 wrote ---=20
 > On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
 > > This RFC adds spawn_template, a userspace-controlled exec acceleration
 > > mechanism for runtimes that repeatedly start the same executable with
 > > different argv, envp, and per-spawn file descriptor setup.
 > >=20
 > > The main target is agent runtimes. Modern coding agents repeatedly sta=
rt
 > > short-lived helper tools such as rg, git, sed, awk, python, node, and
 > > shell wrappers while they inspect and edit a workspace. Those runtimes
 > > already know which tools are hot, and they are also the right place to
 > > decide policy. The kernel does not choose names such as rg, git, or se=
d.
 > > Userspace opts in by creating a template fd for one executable, then u=
ses
 > > that fd for later spawns. Launchers, shells, and build systems have a
 > > similar repeated-startup shape and could use the same primitive, but t=
he
 > > agent runtime case is the main motivation for this RFC.
 > >=20
 > [..]
 > > A typical agent runtime would keep one template per hot executable and
 > > still build argv, envp, cwd, and pipe wiring for each tool call:
 > >=20
 > >     rg_tmpl =3D spawn_template_create("/usr/bin/rg");
 > >=20
 > >     for each search request:
 > >         out_r, out_w =3D pipe_cloexec();
 > >         err_r, err_w =3D pipe_cloexec();
 > >         actions =3D [
 > >             FCHDIR(worktree_fd),
 > >             DUP2(out_w, STDOUT_FILENO),
 > >             DUP2(err_w, STDERR_FILENO),
 > >         ];
 > >         child =3D spawn_template_spawn(rg_tmpl, rg_argv, envp, actions=
);
 > >         close(out_w);
 > >         close(err_w);
 > >         read out_r and err_r;
 > >         waitid(P_PIDFD, child.pidfd, ...);
 > >=20
 > >=20
 > [..]
 > > The cached state is intentionally small. The template fd keeps the ope=
ned
 > > main executable file, an optional absolute path string, the creator
 > > credential pointer, and the deny-write state. The executable identity =
key
 > > records device, inode, size, mode, owner, ctime, and mtime, and is
 > > rechecked before cached metadata is used. The ELF cache keeps only the
 > > main executable's ELF header, program header table, and program header
 > > count.
 > >=20
 > >     cached in this RFC          not cached in this RFC
 > >     ------------------          ----------------------
 > >     opened main executable      PT_INTERP metadata
 > >     executable identity key     shared-library graph
 > >     main ELF header             VMA layout metadata
 > >     main ELF program headers    cross-process metadata sharing
 > >     creator cred pointer
 > >     deny-write state
 > >=20
 > > This RFC does not cache ELF interpreter metadata, shared-library
 > > dependency state, or derived mapping-layout state. Shared-library
 > > resolution is dynamic linker policy and depends on LD_LIBRARY_PATH,
 > > RPATH, RUNPATH, /etc/ld.so.cache, mount namespaces, and secure-exec
 > > state. It also does not share cached executable metadata between templ=
ate
 > > fds created by different processes. Each template owns its small cache=
d
 > > metadata object in this RFC.
 > >=20
 > > Performance
 > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 > >=20
 > [..]
 > > Workload     Calls  subprocess  spawn_template  time_s       Delta
 > > (workers)    calls  calls/s     calls/s         seconds
 > > 1x16         6144      411.04          420.32   14.95/14.62  +2.26%
 > > 2x8          6144      666.78          690.08    9.21/8.90   +3.49%
 > > 4x4          6144      955.61         1003.25    6.43/6.12   +4.99%
 > > 8x2          6144     1048.25         1069.18    5.86/5.75   +2.00%
 > >=20
 >=20
 > This problem is dear to my heart and I have been pondering it on and off
 > for some time now. The entire fork + exec idiom is terrible and needs to=
x
 > be retired.
 >=20
 > Is this vibe-coded? I asked claude for in-kernel posix_spawn for kicks
 > some time ago and it generated remarkably similar code. But that's a
 > tangent.

Partly, yes. The original idea came from using agents myself and noticing
that they spend a lot of time starting short-lived tools such as rg, sed,
git, bash, and python. I was wondering whether repeated tool calls could
be made cheaper.

After that I used an LLM to bounce around the smallest kernel prototype
for the idea. I did some review, patch split, test, benchmark, leak-check w=
ork,
and throw away some cache codes that not actually useful.

 > I'm rather confused by the angle in the patchset. Most of this shaves
 > off a tiny amount of work, while retaining the primary avoidable reason
 > for bad performance: the very fact that fork is part of the picture,
 > especially the part mucking with mm. Creating a pristine process is the
 > way to go.
 >=20
 > Additionally there is a known problem where transiently copied file
 > descriptors on fork + exec cause a headache in multithreaded programs
 > doing something like this in parallel. I only did cursory reading, it
 > seems your patchset keeps the same problem in place.
 >=20
 > There are numerous impactful ways to speed up execs both in terms of
 > single-threaded cost and their multicore scalability, most of which
 > would be immediately usable by all programs without an opt-in. imo these
 > needs to be exhausted before something like a "template" can be
 > considered.
 >=20
 > Per the above, the primary win would stem from *NOT* messing with mm.
 >=20
 > As in, whatever the interface, it needs to create an "empty" target
 > process (for lack of a better term).
 >=20
 > In terms of userspace-visible APIs, a clean solution escapes me.
 >=20
 > Some time ago I proposed returning a handle which is populated over time
 > by the parnet-to-be. One of the problems with it I failed to consider at
 > the time is NUMA locality -- what if the process to be created is going
 > to run on another domain? For example, opening and installing a file for
 > its later use will result in avoidable loss of locality for some of the
 > in-kernel data. That's on top of the fd vs fork problem.
 >=20
 > From perf standpoint, the final goal of whatever mechanism should be a
 > state where the target process avoided copying any state it did not need
 > to and which allocated any memory it needed from local NUMA node
 > (whatever it may happen to be). Of course if no affinity is assigned it
 > may happen to move again and lose such locality, nothing can be done
 > about that. But pretend the process is to run in a specific node the
 > parent is NOT running in.
 >=20
 > So I think the pragmatic way forward is to implement something close to
 > posix_spawn in the kernel. It may make sense for the thing to take the
 > PATH argument for repeated exec attempts. I understand this is of no use
 > in your particular case, but it very much IS of use for most of the
 > real-world. The initial implementation might even start with doing vfork
 > just to get it off the ground.
 >=20
 > The next step would be to extend the interface with means to AVOID
 > copying any file descriptors. There could be a dedicated file action
 > which tells the kernel to avoid such copies or something like a
 > close_range file action (or close_from) -- with a range like <0, INT_MAX=
>
 > you know no fds are copied.
 >=20
 > For the NUMA angle to be sorted out, any file action which opens a file
 > or dups from the parent needs to execute in the child. And frankly
 > something would be needed to ask the scheduler where does it think the
 > child is going to run, so that the task_struct itself can also be
 > allocated with the right backing.
 >=20
 > I have not looked into what's needed to create a new process and NOT
 > mess with mm, but I don't think there are unsolvable problems there, at
 > worst some churn.
 >=20
 > There are of course other parameters which need to be sorted out, that's
 > covered by the posix_spawn thing.
 >=20
 > This e-mail is long enough, so I'm not going to go into issues
 > concerning exec itself right now.
 >=20
 > tl;dr I would suggest redoing the patchset as posix_spawn and then doing
 > the actual optimization of not cloning mm itself.
 >=20

Thanks a lot for writing this up. I clearly had too narrow a view of the
problem. I was mostly thinking about repeated executable startup, but your
reply and Christian's and Andy's made me see that the more useful target is=
 probably
a pidfd/pidfs-backed process builder which can sit under posix_spawn, and
then grow into something that avoids the fork-shaped mm and fd costs. I
learned a lot from this thread.

At a high level, Windows CreateProcess/NtCreateUserProcess also looks
closer to this direction than fork+exec: create the target process
directly, pass explicit startup attributes and handle inheritance state,
and avoid starting from a copy of the parent address space. That seems
to be the same basic advantage here: build the child closer to its final
shape instead of copying parent state and then throwing much of it away.

I will study the process creation, exec, pidfd/pidfs, and posix_spawn
codes more carefully, then try the direction you suggested
and benchmark the mm/fd costs.

Regards,
Li=E2=80=8B


