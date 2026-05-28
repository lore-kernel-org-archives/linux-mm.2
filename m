Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FC1CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443C26B0099; Thu, 28 May 2026 08:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4EC6B009D; Thu, 28 May 2026 08:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4886B009E; Thu, 28 May 2026 08:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 158F66B0099
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:55:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B128491E05
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:55:43 +0000 (UTC)
X-FDA: 84816825366.04.CF36E41
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id C8D91A0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:55:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mgweJVWD;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PXV0iuW9R5esuigYUQ8OuX8X2sJ11qfHxNpdIBfn54=;
	b=C7837yVVXMuaGL45kP5khtxkpowgR9VC+dP1Fl7XdCTRo39o6FLUGL8ZzWDQOhqK9aYj0/
	HRiQhAshxTbf+N2+iSeE5I5B+SysTTDyg3JTYbXK7xA2k1PNSigoIMkhrd/hcdH+m4+CBP
	8Bex1dm3hRYvu11uafQjmcz63Dnxbf4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mgweJVWD;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972941; a=rsa-sha256;
	cv=none;
	b=O8GNKTC8nxIC8y2+KC+K0ewn8C5j8X7GDuTFHlIPA+6aRDGIGxg4fKOYHdT2cKNE3vdtZ8
	OUI1szfDaELFm4/MjR4/RH2QAECMzJ2FH3EbvUPh3VVBKx6/0w+7pnaFlhH20BqPHGxvyp
	AA0qK9F7tocFVvWu9xmHfeosHOmItB8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so57309785e9.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 05:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779972940; x=1780577740; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+PXV0iuW9R5esuigYUQ8OuX8X2sJ11qfHxNpdIBfn54=;
        b=mgweJVWDpeaOXAnuMoY9m8hsxM7JQ6ets2v6/cDgRlRsA41AxYZONhhJi7MCQx2vof
         laLNHpSJWJ4q7cn816cfDnBuh9MLc/i2ofzn2zqVB+RnSCL32wRfRk7i6c2OWuQHV7ti
         ndX84f7jul/SNGm9uLr73x/WJJ8atqXY59DOWl85/nos3Ecb1Jxaug4PLk5utj02tNSp
         AAozzK+olNcaIWSoH9uTBSPogxOvy/UyPrzcGaf2sju3o3/kaoynk91y2rM+TOshrFEy
         JfxE5CmCCZoR4x32tzVyZQvagmMkVexYWd87cn8a6b3iOADgX2+Yspcyc2ZTWtOAKixV
         3cIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779972940; x=1780577740;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+PXV0iuW9R5esuigYUQ8OuX8X2sJ11qfHxNpdIBfn54=;
        b=DID1SX2X0DDkgWCCj7d0sDmOUmQ2MqlPqctK7Rp1sXR0hgtOR9l27sFwUFp5bZyv4M
         IzE5R2WgpFbR7xWtG8LjXhzk3SltBVZpXyhGzqUXJ1IAPcOtnojPwpvIgAhlJObh6M4R
         iV7XmF+h1no6VftlxsQaJHTA8v6HUlqkwscAD2K8ZmGgwMlxcbtIWv90LH6juDhX35sL
         gFeumq4IwwSpooqjrBF167BdURjmrqpDZ4cdLpwt1AkauiA0mDyZVKRE2SoKoR4hfrNw
         gKNJm3JwbkUWJomuh+SKxLPZxWYBZHXSWZUPCXtfQuis7PfBap04HQYeSrwrLuLKZ9qN
         G/zQ==
X-Forwarded-Encrypted: i=1; AFNElJ/S6VRGdounzaHnR/K6I13RAk8zfYeJX9kGIykRZ/ZDzzxvIUXmptMaTRW9XLyjESAyklIazynlhQ==@kvack.org
X-Gm-Message-State: AOJu0YyL7tjVxb2DLjHyrDtioHnuD2XrZfqiNXkA0t/0blqgEmZBN1I6
	JXxwGB5P13a2eC3A5SpWxkEAXG4XJBT4owmOc0C5KlIW76nD6WmgwLQH
X-Gm-Gg: Acq92OGTUHo6qAOu3baVijyMQnS5An9fk9trR0XswCT+9PS5BHQhbQqJccGNjpwPQ4S
	ySZd65qzyscRS1vB25JC+30LII6YMySuVfl7LuO6rYV2+n/vpy6yWjyXNnns98oVXXATcwVtTIw
	RqKSvKRoTnsnc64tea1A9RYxKHR6KsLqXjX6vDnG8E/rbg1qdwp+HL/HWLdTv4cjQXPLZZO4UZS
	msOOPzyGTArtVa+hzImwD9wwl36l7NmnFht5hQ4ysWiozZ+94DzS4PuRVzAA/RKmlqJkljeCUPc
	c8yjL8PWDZDYuvFuq7hN1LH/OszBXeREiZcdT7NEYWzHn831mgYQQ5eAHr/oQaXtgdYx7h7S1kx
	evWYp1NvnPLJSobWvX41GbHlrJslesUfhL4V57wvdK/eD2v2J4oHcyIZfbYVkQf+Bos21zzAvSF
	Phl5hWh4/YH8exTAoq3SO8P8jz7VckXM+CPXu5QmaIrUAl+wqC2TqRcvhG0uzdhCC19bfrtfGyr
	FjFR+hulw==
X-Received: by 2002:a05:600d:640f:10b0:490:3d45:48d7 with SMTP id 5b1f17b1804b1-4904248d296mr326000915e9.6.1779972939903;
        Thu, 28 May 2026 05:55:39 -0700 (PDT)
Received: from f (cst-prg-92-135.cust.vodafone.cz. [46.135.92.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49092a82ea2sm68894895e9.9.2026.05.28.05.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 05:55:39 -0700 (PDT)
Date: Thu, 28 May 2026 14:55:32 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Li Chen <me@linux.beauty>
Cc: Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
Message-ID: <vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8D91A0009
X-Stat-Signature: 6ukg5dpfgpbqqzny3xg8z7ec79goh7fa
X-HE-Tag: 1779972941-890230
X-HE-Meta: U2FsdGVkX18DTXc72jDtULWE2Ds3ysHBvcXTIAT3iGumn8SEytuCuLCydnO5uqtmZ/GEuvJvPm9R72Q+CJjmoO1XuGEd6Vf73URdiVaw70pZ5dnIl7JovfVRgdJvbec8hJRIJrSsVN8PzMJpoqW+lgyg64V6+oenl+GeMwz1ehw8U11crsLet97FEvd8NdvvMGb00Tl0f7cGUMTdmPPsQURVrTyx8fHW8agw7zWkJ+j7nPv/NxaGCgn/BwnU67KdS5PMAZM8X6k61AP/YHfFX4d0NgI0uL+HumYuEOqmCmFitHewmtsg44JdcUPZGBaGSCmVKtuhAQe/ohY9hC5tc/xYGjb3VfXiQoa5BAiKJBl2GYLRJ94aePFu7l4X7mWfLHWXbr45f/w2m7ZXncbdetso6SjMzNWOu7T25Cg+KSKwiaB4IjLQlxiLA51u2CL8PfTSGuSPRIbYptT5oA0j/j1VaHWbZ1bycGCObi6WPflXoeTObsZGMQLtUhUr5vk8rqouKqQId+AibhQ1+2aZw5oNac03Y5aK9WYrMEFfR24lIOJ56+tJNI8ySjsgsBzXmXePZmINXLgaVJ5PjgaJtwRomOw8st8Z2sPfBtIPfYdGBF5duzhU0iDvDylPo80mDeukJl871LBoBxmCe/rCWKCywoMjk908ApZq7RcC69FRbuGXfkEyuMw5+TH7akhK9DyRkhVSkoqUG38f473XieDuiLz+x5uRqW0uPJd1P9pUw2JOhJSSBlfFzBegP+l+4TDOWWkgnHLEfxDuhB67WCsQNme9u6uqKZ6VBwGUxLYUjOjefyvxwyHxLGX8aIqzGgRMt1BCTwL/iP8OFwBucnKQZHriXHeHBXQ3BrcLKkdUwc7HGaipSKLM9fsjSi5Cfl4UQbIJWQGk7+AvDnD7/SeRkQoznF2tgHOPvMzMQGTNEl0Qqyj8ge+fOFGp0F+aZtHZVzqwUXE7chnBeqP
 qFtAbJVY
 1gOuQeTu2TH54eKbq5RwMAt9Z6w50y3U/+Fxl4ScVxiqyauztLkFmV6vAaWHNgK7OH+rGthYpQm6GUSUnh38cW4ExQcAOryRKDY3INmDYujZER97mQdYFmGtiNJVBqnTVWBvfPqMqV8nOQexPx7mm/5c5liyQTHkrmgCgbDlTlyNirHxzqsl6jB+Nt3VA8epEeAQFKH50wLEcVJPnK0A0HMhi+fV+Kwnkx6GGH3JK9VsSuY2IcmPBYnpQX2eXQdxNyhd5LAxJ30xbdMKNETlaUkl3NFethRLlhTr1yQDt87tSqjrnj5FAuwKHylzKd8y75zta6EFrWhNCM8bsshkFQVZz9hIBuihRsal0e3GYX6ZfGlF2dnKQ7VIlGdJjW/jSgw8zY+nSHoyCk8TKLdhOcf4KixS5G2e1QrObiGMjrxjQefSzUpfgPl2fA3yAkJ3hiQqsVct8SU5T4yo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
> This RFC adds spawn_template, a userspace-controlled exec acceleration
> mechanism for runtimes that repeatedly start the same executable with
> different argv, envp, and per-spawn file descriptor setup.
> 
> The main target is agent runtimes. Modern coding agents repeatedly start
> short-lived helper tools such as rg, git, sed, awk, python, node, and
> shell wrappers while they inspect and edit a workspace. Those runtimes
> already know which tools are hot, and they are also the right place to
> decide policy. The kernel does not choose names such as rg, git, or sed.
> Userspace opts in by creating a template fd for one executable, then uses
> that fd for later spawns. Launchers, shells, and build systems have a
> similar repeated-startup shape and could use the same primitive, but the
> agent runtime case is the main motivation for this RFC.
> 
[..]
> A typical agent runtime would keep one template per hot executable and
> still build argv, envp, cwd, and pipe wiring for each tool call:
> 
>     rg_tmpl = spawn_template_create("/usr/bin/rg");
> 
>     for each search request:
>         out_r, out_w = pipe_cloexec();
>         err_r, err_w = pipe_cloexec();
>         actions = [
>             FCHDIR(worktree_fd),
>             DUP2(out_w, STDOUT_FILENO),
>             DUP2(err_w, STDERR_FILENO),
>         ];
>         child = spawn_template_spawn(rg_tmpl, rg_argv, envp, actions);
>         close(out_w);
>         close(err_w);
>         read out_r and err_r;
>         waitid(P_PIDFD, child.pidfd, ...);
> 
> 
[..]
> The cached state is intentionally small. The template fd keeps the opened
> main executable file, an optional absolute path string, the creator
> credential pointer, and the deny-write state. The executable identity key
> records device, inode, size, mode, owner, ctime, and mtime, and is
> rechecked before cached metadata is used. The ELF cache keeps only the
> main executable's ELF header, program header table, and program header
> count.
> 
>     cached in this RFC          not cached in this RFC
>     ------------------          ----------------------
>     opened main executable      PT_INTERP metadata
>     executable identity key     shared-library graph
>     main ELF header             VMA layout metadata
>     main ELF program headers    cross-process metadata sharing
>     creator cred pointer
>     deny-write state
> 
> This RFC does not cache ELF interpreter metadata, shared-library
> dependency state, or derived mapping-layout state. Shared-library
> resolution is dynamic linker policy and depends on LD_LIBRARY_PATH,
> RPATH, RUNPATH, /etc/ld.so.cache, mount namespaces, and secure-exec
> state. It also does not share cached executable metadata between template
> fds created by different processes. Each template owns its small cached
> metadata object in this RFC.
> 
> Performance
> ===========
> 
[..]
> Workload     Calls  subprocess  spawn_template  time_s       Delta
> (workers)    calls  calls/s     calls/s         seconds
> 1x16         6144      411.04          420.32   14.95/14.62  +2.26%
> 2x8          6144      666.78          690.08    9.21/8.90   +3.49%
> 4x4          6144      955.61         1003.25    6.43/6.12   +4.99%
> 8x2          6144     1048.25         1069.18    5.86/5.75   +2.00%
> 

This problem is dear to my heart and I have been pondering it on and off
for some time now. The entire fork + exec idiom is terrible and needs to
be retired.

Is this vibe-coded? I asked claude for in-kernel posix_spawn for kicks
some time ago and it generated remarkably similar code. But that's a
tangent.

I'm rather confused by the angle in the patchset. Most of this shaves
off a tiny amount of work, while retaining the primary avoidable reason
for bad performance: the very fact that fork is part of the picture,
especially the part mucking with mm. Creating a pristine process is the
way to go.

Additionally there is a known problem where transiently copied file
descriptors on fork + exec cause a headache in multithreaded programs
doing something like this in parallel. I only did cursory reading, it
seems your patchset keeps the same problem in place.

There are numerous impactful ways to speed up execs both in terms of
single-threaded cost and their multicore scalability, most of which
would be immediately usable by all programs without an opt-in. imo these
needs to be exhausted before something like a "template" can be
considered.

Per the above, the primary win would stem from *NOT* messing with mm.

As in, whatever the interface, it needs to create an "empty" target
process (for lack of a better term).

In terms of userspace-visible APIs, a clean solution escapes me.

Some time ago I proposed returning a handle which is populated over time
by the parnet-to-be. One of the problems with it I failed to consider at
the time is NUMA locality -- what if the process to be created is going
to run on another domain? For example, opening and installing a file for
its later use will result in avoidable loss of locality for some of the
in-kernel data. That's on top of the fd vs fork problem.

From perf standpoint, the final goal of whatever mechanism should be a
state where the target process avoided copying any state it did not need
to and which allocated any memory it needed from local NUMA node
(whatever it may happen to be). Of course if no affinity is assigned it
may happen to move again and lose such locality, nothing can be done
about that. But pretend the process is to run in a specific node the
parent is NOT running in.

So I think the pragmatic way forward is to implement something close to
posix_spawn in the kernel. It may make sense for the thing to take the
PATH argument for repeated exec attempts. I understand this is of no use
in your particular case, but it very much IS of use for most of the
real-world. The initial implementation might even start with doing vfork
just to get it off the ground.

The next step would be to extend the interface with means to AVOID
copying any file descriptors. There could be a dedicated file action
which tells the kernel to avoid such copies or something like a
close_range file action (or close_from) -- with a range like <0, INT_MAX>
you know no fds are copied.

For the NUMA angle to be sorted out, any file action which opens a file
or dups from the parent needs to execute in the child. And frankly
something would be needed to ask the scheduler where does it think the
child is going to run, so that the task_struct itself can also be
allocated with the right backing.

I have not looked into what's needed to create a new process and NOT
mess with mm, but I don't think there are unsolvable problems there, at
worst some churn.

There are of course other parameters which need to be sorted out, that's
covered by the posix_spawn thing.

This e-mail is long enough, so I'm not going to go into issues
concerning exec itself right now.

tl;dr I would suggest redoing the patchset as posix_spawn and then doing
the actual optimization of not cloning mm itself.

