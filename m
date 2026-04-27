Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2636DFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 22:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C516B0092; Mon, 27 Apr 2026 18:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD1C6B0095; Mon, 27 Apr 2026 18:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4132B6B0096; Mon, 27 Apr 2026 18:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30D8C6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:03:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE30A1602C5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:03:54 +0000 (UTC)
X-FDA: 84705713988.23.C81BC28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35F481C0011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:03:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h41KS2Z7;
	spf=pass (imf20.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777327433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JU9V/u1lpcXmaFxcPn/Tt62APimG3Gscn1V7zAvwLBk=;
	b=M5i80QW4V7kL3LsABY2EmOY3YY52NI+lTUAQTi/o+xQaw615Aot9Z0QdEgPuHcAwSprmN3
	uFA5aNLup8pwZTswQ3KM+bq81/w+cCDRiAY2mgOHamOuLQIWniE3mAJUpcFg58JMaQWcGo
	lEOeczxjrrHIs8ETDl2rSetN81fAjD8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h41KS2Z7;
	spf=pass (imf20.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777327433; a=rsa-sha256;
	cv=none;
	b=NFTnk/BSvgl/TGNc6r2eHIWa1uUxrjOrgSr6DvQMyHhPXG8w1VijkWboyexwlLfTIHNZaC
	bWP+rY2jWo3uVq6h0mr/RvEOSSzSwEJG9VlsPY+UezU5LSskhoHQc7ityaz/IeRQzHpGsP
	wu6Pua7iRsCcpAZ9KCnK806S/dXpHa8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34F8D60138;
	Mon, 27 Apr 2026 22:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F5FC19425;
	Mon, 27 Apr 2026 22:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777327431;
	bh=pPTuUPRefTYXU0h48znUz5nLioqs+x++M3hE2079xYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h41KS2Z77hg/VY2/+NTtoUFxQIthkEBER+hZSEVIpJPXonq2EWUNVVUwjwsbNRBgs
	 KSZCamtEW0ld0Je/vDvixlslp/ydxcYwhmo37UePuG71OgymKVtfRLTSSjtOEgxGaQ
	 U7OS0H2Rx72wANcLxqefSbt8c6kwJa1lB9gYTmoehWXLV4B6QdDsuUzrB7cGI6fazN
	 nHrJJtau5azQogDf6HtV/j+plH/wwwUcPq2DDIyTdQ27xiTBptmuApKUP7XtJ9v3Wi
	 vWFGRTordeQQAURGGO2SIcp1/GOgJwYLYtsLJv/r8abloGac0Rh/0tRxbSgvs4PF3i
	 FZfIK3umVgTzg==
Date: Mon, 27 Apr 2026 15:03:49 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <ae_dRZ95dCDTTxaQ@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
 <aevzbx_Pk5Cu5exa@google.com>
 <ae8KD_Tq0t7RvUy1@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae8KD_Tq0t7RvUy1@tiehlicka>
X-Stat-Signature: sqbofx6nh56zr69aqmmbzmbrpdgcjyjf
X-Rspamd-Queue-Id: 35F481C0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777327433-276131
X-HE-Meta: U2FsdGVkX186F28tucQZfBWly6tMEYqaD4fKzPXZMnFKfEt6+TWyuc/0aBlQnusciLH5DyQZoLJTpfh4ziaBFf8xw7ze+wZeltcxaE8t3ZILse+CPU+UyM39AyKd1AL2HP06x4hFidjoj/rW1hAL3+mCcCYCpqOda1O0pI/MUZUB0Km4hmqAyyPvTU9zOiAY0NIXsRX4sPhlRhm5UgmA+S1uXF5zvTMZ62ZU8P4W3J7z+JeWCgxByJufiEm9ZTsQt1BBSdvRuSczI1mF8FUlJsCjJxDPVkddUOSadT8DHZmdtA+cFE9V2aJ8mvQu8jhf7sGmGIXr6iDf8F2gZNw6jH5fVrDVUfGE8OI9/LaxcLOngmZuMZNkUE+cn3bu4b4HiNFYjdLDijNN3NEykytr9L7l6ZsNQi6VPRBmXkwujceWiC31YTBMxwbRTPGqqJeaqwOfkBcZuGvnJQoBaRwRQC3U7hJ/xCaB65u7aUVxnc2VoIC5QZ2ahm/YVt2ayRrwKqdS97AnU727BrEqNhbDEKHNNxQFzWsyE8ii4fDMt1yXOt5oXE1dU2ptD6EnnYK0JN4HHwazURBhENGZVF53FpphsjDaKgSkE+cEe6QeoUg2WPHvJlztDYIF07sQPtljsZIZwkn4EGLTTGRlBDru1NYDkPa728roWjinI8DOTHNu+tqNGpcCESyJPVJc8kfy8kiFQIPov4bRu78oPdhIOu2S4XIgXm7kUJcElFHX42WgEq7NFM3AhdfZC/ghprF/k/yEowV3sjhfhkmiiQO/mWcCZdMDLgEOxsApTEM9rEfRjsadIS8/hRA7h9nfaWRSItxR8CtAys+/6hcGX5yuQigN9jRSKIbwE3n7lboIc/dRiSWcBu0eIWD7TXpc6Wh11rGZel87kJCqGz5phcPVBuXzybdf+J++dD6NvhfmLQfhFnaMTJzEk92MlfKoQg0tW63/tfd9+dVg+ngWjWU
 CxlSQNtX
 QN0f3NC/uLwahOkluc/baXjHSuWJdNPb7tMYKjyHXFpl5SccnTFFCJ8BhgaUA6nYJV6uSGHVBKVeGmeSMlgU96yt088f3ubCaOFWoVL/jdRYsCh2qWYxL2yC43fziynPiRhm5AdsqTS/wGMYk2c/yif1/Tnu2qtq/txsAYY8FNPVQnG4qJ0DZNd0/aPRNFyaIasX5XjAe1kEaK59N5LllZEdH6PG4M4Z1BuZ88Pt84rqOQQftcAUoDu/DagmePom9c7ZHAwbTlsXH4uVwXv9t3tQntxCna/sPWKgAWNPfrm9SWaf+kRiAJqV7U7KDXXXtDbaK/PRlrvzl4vONwDIVL/LsoICSOKSsfcCwieBjDcKoa0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 09:02:39AM +0200, Michal Hocko wrote:
> On Fri 24-04-26 15:49:19, Minchan Kim wrote:
> > On Fri, Apr 24, 2026 at 09:57:20AM +0200, Michal Hocko wrote:
> > > On Tue 21-04-26 16:02:39, Minchan Kim wrote:
> > > > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > > > prior to the call. This separation introduces a scheduling race window
> > > > where the victim task may receive the signal and enter the exit path
> > > > before the reaper can invoke process_mrelease().
> > > > 
> > > > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > > > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > > > leaving the actual address space teardown (exit_mmap) to be deferred until
> > > > the mm's reference count drops to zero. In Android, arbitrary reference counts
> > > > (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> > > > VM accesses) frequently delay this teardown indefinitely, defeating the
> > > > purpose of expedited reclamation.
> > > > 
> > > > This delay keeps memory pressure high, forcing the system to unnecessarily
> > > > kill additional innocent background apps before the memory from the first
> > > > victim is recovered.
> > > 
> > > Thanks, this makes the motivation much more clear and usecase very
> > > sound.
> > > 
> > > > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > > > an integrated auto-kill mode. When specified, process_mrelease() directly
> > > > injects a SIGKILL into the target task.
> > > > 
> > > > To solve the race condition deterministically, we grab the mm reference
> > > > via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> > > > Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> > > > victim from calling exit_mmap() in its own exit path.
> > > 
> > > Why is this needed? Address space tear down is an operation that can run
> > > from several execution contexts.
> > 
> > Agreed.
> > 
> > > 
> > > > This ensures that
> > > > the memory is reclaimed synchronously and deterministically by the reaper
> > > > in the context of process_mrelease(), avoiding delays caused by
> > > > non-deterministic scheduling of the victim task.
> > > 
> > > The memory is still reclaimed synchronously from the mrelease context.
> > > This is really confusing.
> > > 
> > > Please also explain why do you need to do all that ugly
> > > task_will_free_mem hoops. Why cannot you simply kill the task if
> > > task_will_free_mem fails (if PROCESS_MRELEASE_REAP_KILL is used).
> > 
> > I wanted to handle shared address spaces.
> > Even though we are okay with the target task not being in a SIGKILL
> > state yet (since we are about to kill it), we must ensure that all
> > *other* processes sharing the same mm are also dying.
> 
> Then just bail out when the mm is shared accross thread groups, rather
> than kill just one of them. Or kill all of them. There is no reason to
> play around that on the task_will_free_mem level.

Kiling unrelated processes just because they share an mm is too radicical.

Thinking about quick check whether mm is shared.

An idea:

`atomic_read(&mm->mm_users) > task->signal->nr_threads` to detect sharing
across thread groups without looping like task_will_free_mem.

However, the problem is that mm_users is easily elevated by transient remote
VM accesses, such as when monitoring tools read /proc/<pid>/cmdline, which
happens quite often in the field.
This would cause too many false positives, making process_mrelease() fail
unnecessarily even when no other thread group is actually pinning the mm.

Do you have any ideas on how to check this quickly without calling
task_will_free_mem() reliably?





