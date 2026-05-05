Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 287DFCD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 09:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CBD96B0005; Tue,  5 May 2026 05:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C916B008A; Tue,  5 May 2026 05:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192426B008C; Tue,  5 May 2026 05:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05F196B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:30:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92948140370
	for <linux-mm@kvack.org>; Tue,  5 May 2026 09:30:33 +0000 (UTC)
X-FDA: 84732845946.28.45966F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EFA1DA0003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 09:30:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kNjDGJ1Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777973432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8Iew/zO8KZOyQJSsGsy9EtfpuszCrgHT3zY+ks1QlU=;
	b=2PP0Wk2iB9oIfoOz40N+Ayzsun1w8FREQYhW9xtFthZmrSwaL/sfmiSwBzZg9o53gqlkBY
	99dMw1VjyXIKjbqPyKLkOK1ep6uVggq4+oKUJQ9SMP9oYEhGgmcU+Yb9IaDEzjoqWRDeYB
	jXRv4CKjUl582DsDkWb1B2irXjVCowM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777973432; a=rsa-sha256;
	cv=none;
	b=er188vVuhfvSDoPIbpBrbCd+wO6uG9aEM2qRW7WGLQuF8QNJvIgQjC0zicR9SN8lPnQ41u
	tKW3MZh73/Zeakt0fmGI/A6zv0PmyfmrDSGU/j1CwTu0HGJRUTSFweEITHaW/lMOiCJuYg
	aoscsPYy4Gk+yx0aJUswQ2OmcP+LCOc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kNjDGJ1Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4015B60133;
	Tue,  5 May 2026 09:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A312FC2BCB4;
	Tue,  5 May 2026 09:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777973431;
	bh=QUEqaKOiHh1ZOxaKg3KfDUXaatpEkTtgP1z5oeVjDEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kNjDGJ1Z9jqR1AtJaHLz3UVwRtXa8wKRn+8Z9ABA+bP9K3b3UlQsZfV3KaB9xXUrD
	 tmA+fj7ZuWJ/HHF5+lYbinlXCbgP6C2pJQBYysbOsyawOhvsP2og3vA+D3ZQmGXL46
	 pGnVL2EBxZKnvUV82LohPKjuVV+r6/1uK5EbByOf0nAF87KWiSaE8MAod56uaqQQcZ
	 o9lhCctY4vS/HenHDEzGg0SDg1UfZckSXLnmSQDL3OY36jWIhIcPRcecCiBMb/PhCr
	 NmIzyqEmW2pEwY9z8JzF/4kIV4dztCCztn0hLL9CbfkzSQwSf0zLmK9I2Fk6L1IXTZ
	 vjukxG7XLahGQ==
Date: Tue, 5 May 2026 11:30:22 +0200
From: Christian Brauner <brauner@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org, 
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <afhQB0CWEcflXpOi@tiehlicka>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFA1DA0003
X-Stat-Signature: hez4rba9qogfq7k57tf1dgzqa9gys4jh
X-Rspam-User: 
X-HE-Tag: 1777973431-801373
X-HE-Meta: U2FsdGVkX18nxZP+E8oDyeuRcpE96MzUtogIUzE+nCxkVCuXS4CR9IJZgMxNG3zYpNAm7BOBCtkil4R69wBSdDpF27WJFqjqbcg1avhxjDmoWmGqYoqfOPhBwYmzRVkJMlG0gWX9PqfmQiet3MgGajsnWQwnROKc4UVkxvW9w+0hgudi5i2+AAjrmCF0RE144vqtJfqDJpKk7incy9S38aacKptU3eAf7qu40uDzlYwWFZsPx9nMM9eRI2ybzv2vFp+/MsAcBhJDhEqaSWQTcWt32z+HSrojV7LlUsCH2ptZfJmvzgeAkfVY4p9Zo8WsKGKXOT7cM8kY48EBspt+e7MokAbqSr1VE9L2nvp/PNg0lL0OTyv2aqHV1ubRD3ElkL5Jp0DYc1ZRuLZx1Gw1fSyhINRCe6F7foBQNyT9cFkLAOMWzZuXPeL4981rG93Pgdk69fOa2dn83S7OUB8hLUG/kVxMD9PI2DZF1BoLrChNk9dYKhQ/mHp06ucmjj2dqROOMYtnhKnzvA3M2fVOx7f9IBOsyskOa+6uIQAg+Jm7h88S0HwS30fPl4t4ndxlHv9E7TqASSF7xd9EVzjIJRFnZA3CAWbcgw5fULW6u0y1xaXC+ASxdP1plxF1DsWu62Tbuyt1teecmYs1siyikErpOlJQ1YNyJkGKqc2TgdWziFOVt46JJKFf8WCBdv+8h4djVBbPKQAuIIau+ewRJMeh3rjfUS5l7K3ILVqLQGPjrknyOv1ACK/bOW6p3T/tExzr7Oh2DlB/04NBprdJjGHycsYe0W1LQ2rwW0WWh15bbvEyXNrneriWAE3Cdl+b13wyPfii/lNR0HLQHu7KIeGo8h9n9sTj8209Yirt4mHmYdZGbCZEr7O9Q+gyjrDlFqozBCEvbK5c4sMzhvb19CI0w2XHVCPEkx9lN4Pl0R/OsCg5awNEkPNFVx/JvPPZGeUwPYxT5KqH7p2GCxc
 HLWxUpBY
 2hD+GNK0ZyXNX08un87yogtZkhE8DiorIBeZGvLgf59/7dF6KFnKLZiR0wrKYsuI9btTmNXYya1G/2OxyT8Gg3JuyAGWGUAYvKhvOT/doIHkOFU96a+Ba13Z8AzexL+5q6olfMsNdwUG4oo69XxqgbRIHcvfDfVT+gVb2GWKzCVnIY6Kt7zl0ebEm3m+lFm88YYCcYhpWe9+vxA8+NawoZFknk+CghFuMhybQk66D1o6mYi2cbmwF5iK8YdRhWR1wrQQbCcYDWtA+8nBU7n08U8ar3FmyidBcWWro+Tr+O0fAdLXl1bIcaPrTUmNQYJkoRIaq1SrZpQB6YD61tCfx6HHqhbEzTsyu7f/8JG8Goi96CfLWDpOSUJLYNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 09:51:35AM +0200, Michal Hocko wrote:
> On Fri 01-05-26 14:17:50, Minchan Kim wrote:
> > On Thu, Apr 30, 2026 at 11:55:54AM +0200, Michal Hocko wrote:
> > > On Wed 29-04-26 14:13:59, Minchan Kim wrote:
> > > > This policy differs from the global OOM killer, which kills all processes
> > > > sharing the same mm to guarantee memory reclamation at all costs (preventing
> > > > system hangs).
> > > 
> > > Incorrect, we do the same for memcg OOM killer as well. This is not
> > > about preventing system hands. But rather to 
> > > 
> > > > However, process_mrelease() is invoked by userspace policy.
> > > > If it fails due to sharing, userspace can simply adapt and select another
> > > > victim process (such as another background app in Android case) to release
> > > > memory. We do not need to force success or affect processes that were not
> > > > targeted.
> > > 
> > > This is a wrong justification for the proposed semantic. You seem to be
> > > assuming this is just fine rather than this would be problematic for
> > > reasons a), b) and c). If there are no strong reasons _against_
> > > following the global policy then we should stick with it. There are very
> > > good reasons why we are doing that on the global level.
> > > 
> > > If for no other reasons then the proposed semantic severly criples the
> > > shared MM case. You are left with a racy kill and call process_mrelease
> > > approach. You certainly do not want to allow a simple way for tasks to
> > > evade your LMK, do you? So just choose something else is a very bad
> > > approach.
> > > 
> > > So unless you are aware of a specific reason(s) where collective kill is a
> > > clearly an incorrect behavior then I believe the proper way is to kill
> > > all processes sharing the mm (unless you are crossing any security
> > > boundary when doing that).
> > 
> > I agree that in the case of a global or memcg OOM, the kernel deals with an
> > emergency, system-wide crisis where killing all sibling processes sharing
> > the same mm is an absolute necessity for system survival, bypassing
> > user-space privilege screening.
> 
> You are misinterpreting or missing my point. I am not suggesting to
> cross privilege boundaries. The syscall should fail if the mm is shared
> with tasks the caller cannot kill (same as it does now).
> 
> > However, process_mrelease() is an explicit user-space initiated system call,
> > and I am still hesitant to place that same raw, destructive policy blindly
> > at the UAPI syscall level even though I don't know of any known security
> > issues right now.
> 
> This is very wrong argument to introduce a potentially crippled syscall
> semantic.
>  
> > If we really want to go that way for the collective kill, at least, we should
> > evaluate signal authorization (kill permission) against *every single*
> > sibling process beforehand instead of only the target task of
> > process_mrelease. Do you agree?
> 
> This is what I've proposed already.
> 
> > Also, I wonder what the signal/process maintainer thinks about this approach.
> > Christian Brauner <brauner@kernel.org>?
> 
> Yes, this makes sense. There might be a very good reason why we might
> not want to introduce a way to kill cross thread groups when they share
> mm from userspace. I do not see any as long as you keep the proper
> permissions for all affected tasks. Maybe we cannot do that sanely now.
> But these reasons have to be properly documented. You whole argument
> that this is different from in-kernel oom killing is just not valid.

IIUC, then the OOM kill if invoked from the kernel just takes down
without permission checking what it wants to take down. That makes a lot
of sense and is mostly safe - after all it is the kernel that initiates
the kill.

However, when userspace initiates the kill we need at least the
semantics you proposed, Michal. You can only kill processes that you
have the necessary privileges over otherwise you end up allowing to
SIGKILL setuid binaries over which you hold no privileged possibly
generating information leaks or worse.

The other thing to keep in mind is that currently pidfds explicitly do
not to allow to signal taks that are outside of their pid namespace
hierarchy - see pidfd_send_signal()'s permission checking. I don't want
to break these semantics - it's just very bad api design if signaling
suddenly behaves differently and pidfd suddenly convey the ability to
do a very wide signal scope.

The other thing is that pidfds are handles that can be sent around using
SCM_RIGHTS which means they could be forwarded to a container or another
privileged user that then initiates kill semantics.

The other thing is that the type of pidfd selects the scope of the
signaling operation:

* If the pidfd was created via PIDFD_THREAD then the scope of the signal
  is by default the individual thread - unless the signal itself is
  thread-group oriented ofc.

* If the pidfd was created wihout PIDFD_THREAD then the scope of the
  signal is by default the thread-group.

* pidfd_send_signal() provides explicitly scope overrides:

  (1) PIDFD_SIGNAL_THREAD
  (2) PIDFD_SIGNAL_THREAD_GROUP
  (3) PIDFD_SIGNAL_PROCESS_GROUP

  The flags should be mostly self-explanatory.

  So I really dislike the idea of now letting the pidfd passed to
  process_mrelease() to have an implicit scope suddenly. The problem is
  that this is very opaque to userspace and introduces another way to
  signal a group of processes.

IOW, I still dislike the fact that process_mrelease() is suddenly turned
into a signal sending syscall and I really dislike the fact that it
implies a "kill everything with that mm and cross other thread-groups".

I wonder if you couldn't just add PIDFD_SIGNAL_MM_GROUP or something to
pidfd_send_signal() instead.

