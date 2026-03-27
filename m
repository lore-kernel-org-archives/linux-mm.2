Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3D210F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3F56B008C; Fri, 27 Mar 2026 12:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D3D6B0096; Fri, 27 Mar 2026 12:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5CE46B0098; Fri, 27 Mar 2026 12:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB70E6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:06:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 562B25EA11
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:06:38 +0000 (UTC)
X-FDA: 84592320876.08.2EA216A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 30E8C100016
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:06:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=euB7uvj6;
	spf=pass (imf05.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774627596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2KhTUAjw0jRKl8iCMNRp2pUaoEv3AvLCHL0xg/y+1U=;
	b=R2qax0OE77Ms5cJUoHD0SlrsKqLh8LRh862VbkRjXMH2P9OpE6I1SufZY43Cpx4eGUile2
	gOy/p2FqJQ147Ea4/f0Ovy1aHP46ieI0336mGn7ezvGe5awDKh0IDx2eNMeLKOVhM28EI0
	Rfx1WN3ZaIX7mlrgLMRPQcy0T9KyQAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774627596; a=rsa-sha256;
	cv=none;
	b=4woFTxZDu2xjhfRfYHKGd9tSr7Ng0N4HXhkHdTlkO1YmXfh+1XHoOZym09a1UMLv6DKgqV
	4xafw767+j22ovMfN2iHQAbOakHVy4O6DYASc8F/SQ53MWs56NciEJSMfqEKpA/1Gu+UAf
	WOwlTOS9D33+jFozL4IL/pmvCVBzkeU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=euB7uvj6;
	spf=pass (imf05.hostedemail.com: domain of mark.rutland@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=mark.rutland@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0380635DA;
	Fri, 27 Mar 2026 09:06:29 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 501B53F905;
	Fri, 27 Mar 2026 09:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774627594; bh=rP5Us1gXdwPg7GyTIgDBgSFYYiyK72XcZqUZNsRJd7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=euB7uvj6sPvllCzscsJiWjfu2yQKubt0UwiyzR70XCV7OQY28kY7MGRijQb7Rj/ww
	 g5Jnk+yKB7WIdQKX0sZMjkOG8Lh6yX18HV9LbxuG0Qx9gTebYXJ4nvfTqJnMBxiUjW
	 Tep1yK+UIiWrTDxl7aHcASnUCM2R72F1NxjKzw+g=
Date: Fri, 27 Mar 2026 16:06:27 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Andrei Vagin <avagin@google.com>
Cc: Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
Message-ID: <acarA3sGKY4Acozw@J2N7QTR9R3.cambridge.arm.com>
References: <20260323175340.3361311-1-avagin@google.com>
 <20260323175340.3361311-2-avagin@google.com>
 <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com>
 <acJnOB-rlyt-3jU4@willie-the-truck>
 <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com>
X-Rspamd-Queue-Id: 30E8C100016
X-Stat-Signature: sybwep5z9bte9y434om71tjyef5ibbhz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774627595-549080
X-HE-Meta: U2FsdGVkX1+nGX6xbImk17eWders9pFtFM2kSp+fM4I03rVMSI3twFfoI6BFrAxNyR8j31oN8WCboYAkBXYsc7caktCH/UsU6Hsu/Aj7p4cl/dv7obTc6eXRdkgsu+oJ1F3IPVnfSQGIULJLET92KJOcNpamQy3PCznKAUUf1vK+LFBfgDKcLAo6YEh4etwK6aHOadkxk37zrBkz2XrapQ3gqaAFoW+xN+fsvxLDr9IiyC8go5Knxmd5YUFqJ2EWdAOuHZB6JcV98MBDgnv6D5B5LHBbkXsiS/FHgYx6PvezJMJpu38FjfD3p/L9jlW2aJToeTeGAUyVoHwDQOy9JIAy/u7Ss6YU88WqGy9efRNqmhw57z544MBPHiZhf9T8s69XYVq459MzcZX5H5lZI4zNCuIHzm79+NcDKNNEsYf8qHUQvxqj9qxM9x7pBGvG1qaCwO6Ox0RMFkw58VDosRJHVYuLk+LQD/MrSUanaYRS5IqSYhjp3dOPsi90o8JxdQUaRjY75wSryGyChoelGhZ1HaI3cjkr+FGG6lBJIzml1fMYDwyxRbnBusisSjXwV91fIuZanqGaSsT+Qh1Gc8eO2cz+m2V0o+tKqqTUPtt1BzIijLNjMC+QXtxeiFx5JUPHTA7dyrraamZjLPOTpUiIy2cpsfH2A7AdFvxVyTZv5mKv9T5EMiz1RcMKcNOBB9vzqyw2tXB077ZXWMH/fxxg9CQeFlR7DdNLKWfgOVYoG1mzPRLf6rCGJnZQw2FcbuZmYwAwdlCwabbc7AKYsT2TaPwiBGThHt0xu/SMju3rZS2VOgowRJgdECb+nWW3cwgj1oocWvzGXuqVtIdXgxpKKIHE4SkZSiBsWj0zTNs6auV7cnF9n/g0e88+scqXpKGk7en+9tSZqHAR/xvof8IzBDYLaGfKYFNKisaX62HrPdhIIeORo6HbD2/jEi8nlPvLvpjWX6dIkaSD761
 GTzfbDBF
 pGRmMcM42hFaEgVTb9gbH9XfF5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 03:19:49PM -0700, Andrei Vagin wrote:
> Hi Mark and Will,
> 
> Thanks for the feedback. Please read the inline comments.
> 
> On Tue, Mar 24, 2026 at 3:28 AM Will Deacon <will@kernel.org> wrote:
> >
> > On Mon, Mar 23, 2026 at 06:21:22PM +0000, Mark Rutland wrote:
> > > On Mon, Mar 23, 2026 at 05:53:37PM +0000, Andrei Vagin wrote:
> > > > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> > > > AT_HWCAP2, etc.) from a parent process when they have been modified via
> > > > prctl.
> > > >
> > > > To support C/R operations (snapshots, live migration) in heterogeneous
> > > > clusters, we must ensure that processes utilize CPU features available
> > > > on all potential target nodes. To solve this, we need to advertise a
> > > > common feature set across the cluster.
> > > >
> > > > This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> > > > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV).  When
> > > > execve() is called, if the current process has MMF_USER_HWCAP set, the
> > > > HWCAP values are extracted from the current auxiliary vector and stored
> > > > in the linux_binprm structure. These values are then used to populate
> > > > the auxiliary vector of the new process, effectively inheriting the
> > > > hardware capabilities.
> > > >
> > > > The inherited HWCAPs are masked with the hardware capabilities supported
> > > > by the current kernel to ensure that we don't report more features than
> > > > actually supported. This is important to avoid unexpected behavior,
> > > > especially for processes with additional privileges.
> > >
> > > At a high level, I don't think that's going to be sufficient:
> > >
> > > * On an architecture with other userspace accessible feature
> > >   identification mechanism registers (e.g. ID registers), userspace
> > >   might read those. So you might need to hide stuff there too, and
> > >   that's going to require architecture-specific interfaces to manage.
> > >
> > >   It's possible that some code checks HWCAPs and others check ID
> > >   registers, and mismatch between the two could be problematic.
> > >
> > > * If the HWCAPs can be inherited by a more privileged task, then a
> > >   malicious user could use this to hide security features (e.g. shadow
> > >   stack or pointer authentication on arm64), and make it easier to
> > >   attack that task. While not a direct attack, it would undermine those
> > >   features.
> 
> I agree with Mark that only a privileged process have to be able to mask
> certain hardware features. Currently, PR_SET_MM_AUXV is guarded by
> CAP_SYS_RESOURCE, but PR_SET_MM_MAP allows changing the auxiliary vector
> without specific capabilities. This is definitely the issue. To address
> this, I think we can consider to introduce a new prctl command to enable
> HWCAP inheritance explicitly.
> 
> > Yeah, this looks like a non-starter to me on arm64. Even if it was
> > extended to apply the same treatment to the idregs, many of the hwcap
> > features can't actually be disabled by the kernel and so you still run
> > the risk of a task that probes for the presence of a feature using
> > something like a SIGILL handler or, perhaps more likely, assumes that
> > the presence of one hwcap implies the presence of another. And then
> > there are the applications that just base everything off the MIDR...
> 
> The goal of this mechanism is not to provide strict architectural
> enforcement or to trap the use of hardware features; rather, it is to
> provide a consistent discovery interface for applications. I chose the
> HWCAP vector because it mirrors the existing behavior of running an
> older kernel on newer hardware: while ID registers might report a
> feature as physically present, the HWCAPs will omit it if the kernel
> lacks support. 

On arm64, the view of the ID registers that userspace gets *only*
exposes features that the kernel knows about, as userspace reads of
those registers are trapped+emulated by the kernel. On arm64 it's 
not true to say that something appears in those but not the HWCAPs.

I understand that might be different on other architectures, and so
maybe this approach is sufficient on other architectures, but it is not
sufficient on arm64.

> Applications are generally expected to treat HWCAPs as
> the source of truth for which features are safe to use, even if the
> underlying hardware is technically capable of more.

I'm fairly certain that there are arm64 applications (and libraries)
which check only the ID register values, and not the HWCAPs.

Architecturally, there are features which are detected via other
mechanisms (e.g. CHKFEAT), for which HWCAPs are also irrelevant. Even if
that happens to be ok today, there are almost certainly future uses that
will not be compatible with the scheme you propose.

I don't think we can say "applications must check the HWCAPs", when we
know that applications and libraries legitimately don't always do that.

> Another significant advantage of using HWCAPs is that many
> applications already rely on them for feature detection. This interface
> allows these applications to work correctly "out-of-the-box" in a
> migrated environment without requiring any userspace modifications.  I
> understand that some apps may use other detection methods; however, there
> it no gurantee that these applications will work correctly after
> migration to another machine.

I think the existince of applications that detect features by other
(legitimate!) means implies that there's no guarantee that this feature
is useful and will remain useful going forwards.

For example, what do you plan to do if an application or library starts
doing something legitimate that causes it to become incompatible with
this scheme?

I don't want to be in a position where userspace is asked to steer clear
of legitimate mechanisms, or where architecture code suddently has to
pick up a lot of complexity to make this work.

> > There's also kvm, which provides a roundabout way to query some features
> > of the underlying hardware.
> >
> > You're probably better off using/extending the idreg overrides we have
> > in arch/arm64/kernel/pi/idreg-override.c so that you can make your
> > cluster of heterogeneous machines look alike.
> 
> IIRC, idreg-override/cpuid-masking usually works for an entire machine.
> We actually need to have a mechanism that will work on a per-container
> basis. Workloads inside one cluster can have different
> migration/snapshot requirements. Some are pinned to a specific node,
> others are never migrated, while others need to be migratable across a
> cluster or even between clusters. We need a mechanism that can be
> tunable on a per-container/per-process basis.

I think that's theoretically possible, BUT it will require substantially
more complexity, to address the issues that Will and I have mentioned. I
don't think people are very happy to pick up that complexity.

There are many other aspects that are going to be problematic for
heterogeneous migration. Even if you hide the HWCAP for a stateful
feature (e.g. SME), it might appear in one machine's signal frames (and
be mandatory there), but might not appear in anothers, and so migration
might not work either way. Likewise, that state can appear via ptrace.

Thanks,
Mark.

