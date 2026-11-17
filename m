Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CC9606A337
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 20:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgZV8Wvz
Received: by kanga.kvack.org (Postfix)
	id 53F5E6B05B2; Tue, 17 Nov 2026 15:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFBA6B05B3; Tue, 17 Nov 2026 15:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7DF6B05B4; Tue, 17 Nov 2026 15:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 142276B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 15:03:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 903A61A0596
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:03:40 +0000 (UTC)
X-FDA: 85445686200.29.135F072
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DDA0D80010
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:03:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgZV8Wvz;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794945819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7F9vGUwuGm89Sq7Z6BKmbqulj1taVMbbgDwWzUX518=;
	b=rwxhm++gd/2e/gH+FXLG4JAdR+vgtmncvRPwpHtfZmk4EjBOnU6rECsRtS8fcAUPDDfIHh
	HWmLaCu8XMi2CpfWmtr3oY9iniP4/6kNEMKfiB/6C47Q6ga+M072I3J4NLPaegy5YlgSyp
	SPYWAk1ILtQRO7p59EOa2lsaeUPa6Zo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794945819;
	b=scEUlgE2h87bc+udsBSRO0o7hnUpJwE/cmyfcTdekpbyHJb6dHDcI+paZsx5cHQQyKRh1k
	3e28r9+lbPw4XIrEUTqaQLNgPzXoR34B5x3K2RBev/BDgH+3N1zL6D2deQv+kcZ1mNX4B1
	Nh4HttxvQIfUmS9ct6AkxPzF1brKROQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgZV8Wvz;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 485AB60DB5;
	Tue, 17 Nov 2026 20:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 453F21F000C4;
	Tue, 17 Nov 2026 20:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794945818;
	bh=A7F9vGUwuGm89Sq7Z6BKmbqulj1taVMbbgDwWzUX518=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GgZV8WvzcdepSUadf6SySKEgnAJgIRXVt6j0ej7g1R4olLseL6+Kzp1GDlNhnKddU
	 si3ENXKDzBgoKGmWrIX3uc1Sac5ouCqJQSgNT3cFQm4mHP3Op6nnesr9x6wuTbSNwC
	 opviFh71CCcLK/BQ4wakf+n49QvI41MbVWUMeEiOrXYmzsI1zneVe9ACOd+n8fYxZl
	 JRTGLazZCNCNDGqYr1YZJS6Mvt6nuNW5zYSK6SBBhT7qvnpO+92T7nRH12ryNYsJrg
	 VL3JfrdW6rXtfQM5Cptxm/f7P0nTVIk+gGrufpzNmsw1p2eOUUX/0WwilkUXBWliZS
	 VwFOOPHxJc4LQ==
Date: Tue, 17 Nov 2026 22:03:34 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [RFC PATCH 07/13] rootns: Add rootns_enter() system call
Message-ID: <avyzFnKQrNOid25y@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-8-jarkko@kernel.org>
 <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com>
X-Stat-Signature: 1ytwmxmfn8oqjxh6juenysc4es4n7paw
X-Rspam-User: 
X-Rspamd-Queue-Id: DDA0D80010
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794945818-806588
X-HE-Meta: U2FsdGVkX19FlI9IAlDI7T3XjvzInj59stQNU6jTwoX2DB9pnWW1dAhFS51zNPYlgEa/vrrPNxfqq0JrV9EzPRUWn1l69RKQXHsH7CZmdtUpe1o3aa2t8mff0mptUjdwBIzViVwHlSL4BbdHVx6KS3LrNhhcZP0Wt0490xxsV1gzXZNTpNDMlCRIoa/Mwz/vs+sqZV2NgDi65JQkEqH71nkIXks7z58Yg7aSx74r+nLRkkJWSq1W+qX2i0wgqB/mfFZ+aPtcFAPL9a+aDZqUv5bCqIqUX/JWdce61ifSOvMzKWzeenupI3fCtn+lw9wZKV5DpCUNu3Y6osu2PHgez6R/YiGP38P/NCRzu3gyP0WicnszsO5lHaGG1wznFHdsM2TnrqCi8qs2E1qN64NaCWF+7mEpeLJMsljuNkxI1wleh6ORPIV4/XEq+G99NNr9yPNbbIBRH5Dt/HH46bfZ4DskR1OqiKHVaWvjFObvj36UnRsd/sno0S+5MDJYaYztBfchxlUPX12b/mfButhlYnv8djJd8rOY+b84g8gHGjQHRHyn3Uguox+DxZeIcUR+5Qi2XpFH1Rf+cRKUnb9NnG7y3eM9t+x+D5x4DFKAMmnH9+uxml/Z8tDzEIuIVelFc7R6db6BEvQc3Zh0ANX4/rysD2DMYGEDGuNEux5CdOctaj0SNa9OAd6rQMKibUFL5fsPFelmdTn6/90PRExZ7A6jT7rbEYtFvMdVXMnNdGzh3Tr7JICZHI6gGe8b1b1hBxaY/gqebSuZPGXsnX3/JqWYZTZ9fyQo8lFuXb8LgzPphkIRH4xHGjKPbvw3uklCnDDrZK2BCRmOwxUcK63FoMZubeto9gdBJOZclpQznD/R8PXEhkuACqk3W+nzURN5pPGqjC1iCaVlgxjZjqXmsTwZoh3Ojn0yJRu/cov+AkczSE8/qDb0GJofM/Hjo2w25tPQ+Z6FGlbUdjKi+x1
 ngaGND+A
 Lr8gMN0FQWFzPCIBmLBDM5nlL92971RkG7luwREcNAq+KxPz70x/bCHiGE9POAgUEav/W203TzZDPLuz61OuN6Td7k5+HUWRWBeuGQpdb+Ct5Ts2Y6uvE1vfmv1r7kwHYbx3VRP4JhRxZjjxzGG0lfgMgSSIxY51n3rak5vgu3lYawxAmvpgIJxQhGCIwg0NJgSLv5jI1+wCxe/5mxy8kdyxcxNGQRQ1WXhINJNF4iBuUi4DszOOPxnqNeoPkmjZG9C8KBg18WpR4pBWXL9F45rK5m/i3+/0AjaZqlfF3IygEx6MdtYeZ1aoK+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 09:42:26AM -0800, Andy Lutomirski wrote:
> On Mon, Nov 16, 2026 at 9:09 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> > safely mutate process-wide filesystem state in place before spawning a
> > child into a target namespace set.
> >
> > Add the rootns_enter() system call to fork a child process directly into
> > a rootns whose root mount has been installed. Transition the rootns from
> > ROOTNS_READY through ROOTNS_FORKING to ROOTNS_RUNNING for the first
> > process so it becomes PID 1, serialize concurrent entrants on waitq
> > until bootstrap resolves, and admit subsequent callers into the running
> > PID namespace until teardown begins.
> >
> > Require CAP_SYS_ADMIN in the target user namespace, forbid credential or
> > PR_SET_NO_NEW_PRIVS privilege escalation
> 
> Why are you disallowing this if no_new_privs?

For no any good reason at all apparently: no_new_privs is inherited by
the child and only restricts privilege gain across execve(), whereas
user_namespace transitions are allowed under it.

So yeah, it's a spurious check, and thus I'll drop it.

> This isn't necessarily a showstopper, but fork() is really quite slow
> in many cases.  It would be nice to have a more spawn-like API
> available.  I assume it's possible to open a file in the target's
> mountns by some sane API even without entering that mountns, as a side
> effect of how the fsopen / move_mount mechanism works.


If the caller retains the O_PATH fd returned by fsmount() for "/", it is
able to open files inside the target mount tree via openat2(...,
RESOLVE_IN_ROOT) w/o entering the mount namespace, and pass the
resulting fd to execveat().

For avoiding full fork(), there are (at least) two options:

1. A rootns flag in clone3() (e.g., CLONE_INTO_ROOTNS) and a rootns fd
   in struct clone_args (disallowing incompatible CLONE_NEW*, CLONE_FS,
   CLONE_THREAD, ...), and callers can pair it with CLONE_VM | CLONE_VFORK.
2. A flags parameter in rootns_enter() (e.g., ROOTNS_ENTER_VFORK), which
   would map directly to CLONE_VM | CLONE_VFORK.

> 
> --Andy

Br, Jarkko

