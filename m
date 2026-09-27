Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA89C9830E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 10:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858976B0088; Sun, 27 Sep 2026 06:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831886B008A; Sun, 27 Sep 2026 06:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D596B008C; Sun, 27 Sep 2026 06:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA7A6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:07:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBEDBA02EC
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:07:46 +0000 (UTC)
X-FDA: 85259115732.09.42728D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2879F140004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:07:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+uofu54;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790503665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuZOxs2OpoBI5rzRL1beL1MIyy2hTjmekiMckgAHHy8=;
	b=kzby0psOzm7TicWxXQQJDoKE7iLPyWg59rjTt2+BSuBsQaDoFOYycuEjxdYKwj9rCga+KM
	ACj46KgmdI0VDT2lOJduVZV+ay1z8UhS1omWy2H3/jXTzzRYsUPxIbrOgh48H2iiukyAKW
	EPH9XXRnHLdKWmphkXsKC/y3z5w+BbQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+uofu54;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790503665;
	b=pJW4wBb8nnGtx91R7y9HdhgWkoDqYlI9ki4+Uo6SOuOlgb3hFprRCVFClDgASJQZijQrVq
	tnvM72Dd0fo5W8VpDqMRZY1A8y9w/KLp63yLQLLirblpADSHLsGkJVaS05htR3oXvwY/t/
	7nQjmHUSpEDsVHj6hQQZCbs8LA/dUxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 533FA60AAE;
	Sun, 27 Sep 2026 10:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA981F000FF;
	Sun, 27 Sep 2026 10:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790503663;
	bh=JuZOxs2OpoBI5rzRL1beL1MIyy2hTjmekiMckgAHHy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+uofu54BG5L8tXHCE/wnnDzKdehh4xf+m6+WeRrUt7Y+w8QlFMNsGAQn7i71OtXy
	 WkwTHFQrdLJK4uK8g+vDtyftK7ZjdKcwov7wNUqMwXFSKnwp4atdjQoMt7ZxbwI9vp
	 8QE8zr6XaKqGRKuJlZ6hagSxdqjqhPdnQmIfWOT+0xPNMIiPi0jO4H48FcIrzeKreE
	 ChG8M/dwDpvVcGsDQ6eKMmcdJBXKzvh8C0Hv/ujykz+fs6zE2u77DffvkyUMVWCKz0
	 98l+1QrkeiLq5DfffYT6Kp+zDDQlSCKaeW9gn87+JxDjStDtyTYAIY6V+b1Uf0g66a
	 8kED/Lj+463BQ==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	ojeda@kernel.org,
	boqun@kernel.org,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	a.hindborg@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	daniel.almeida@collabora.com,
	tamird@kernel.org,
	acourbot@nvidia.com,
	work@onurozkan.dev,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [RFC PATCH 0/4] rust: damon: a first small step, plus a Rust prcl sample
Date: Sun, 27 Sep 2026 03:07:35 -0700
Message-ID: <20260927100735.41931-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927072812.2393456-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2879F140004
X-Stat-Signature: d5itryze4oh9fo9yhhfiwcybswgr5gnr
X-HE-Tag: 1790503664-23105
X-HE-Meta: U2FsdGVkX19fwVadohnYuBWXTfdJnYllaxbudvjWbMJKUUjS24b6S/bso6r7IcQZ55p5mVLQLkSZSJ5NCqEc5ZFNQx33aNdurQtZR482j22U8jScz+TLJDnmVgAZdmdFTjPqLALxtXeNXYFMZmPLHhJOTjj4eHxTloZMNlZJoL1eLIxXnHVecmox2LQDtyJBlHQ42MqmPiqOvB03kP9Vv5JEpNvgOn5lpcyZYEcFx4hg9ILPk2V5RQ/p73V9TJ5BUb73vvZjBjRtM5VK+XQ4J8N4fN7/9m67PYopQXJK8q/0y0C7vpJUddU/7nCh37/0V6OhCgT7yGpFgeSvsSU5ximcWOjXZrqOUzhA6RHha1Ztzb5f1T9Rsb1ZG8urwuISZOBpqnf9Zxc97AWF4djLBUHmit9g8yxr/sWfRL0YTYSfroR058PxCjba9QrBKsPVlJesFn76g36Ag6ILyDaO9dX+Q+p7VpsBNIiIs2TW/RvlQnwTPEjeZqyl152+zNdrwFulv+avimsldm8D6Li3iuOwefFsewaI8AozrvW9l2Z7sn1kB0bntbbx/0eIiJHLZL37KWNUxw/Dwatp37LvBAjCT8maKV8YH7bPiBmUb25PckI+Ld/Vft0nan7Ok3oLKPOLKowwiuoULT7yFzaA7hgOisxrwwGBKAcyKVgCbup9sJnSE5beBA5dGRRqkT1hz1gQf7N0HxxGS3Z61yEdqscUB2g9ogtOKYhyn6EcoyOhLap1ZqgEGnbDXGelA9mTJqjdEQo1xeZpfzSu6Ld8cjX/JumbiYzwCIVLSFJT2hdYdhLs6h3Awcq6zU38kE8c5ig6ssHIxsTfFtrH/xhCme9cJoAV8X+yS5731joDNePHHTtcTr1gF4grLEzb3k9ra6fyeH+OcjhGvLmPud5d9ixoAR9BnFS4wCZ+s0Ydi6oEPAOX6dJbgrj6snnH1xjnnfKZNcvHSaj4KLKsyIO
 gxrUh67A
 nmvI3IhlHyeLcQuqa/tU5S8pKsHjK/m7352BrG1YKowi7JM8ZqAcbcDGzpT5HQGwEv/4H+DJ9rlx6d7MBjpOksV70a9u2EKhwUPBgNkzWRQ7p9f2Al+2AeDrSB7TvfnSkJwr27HPwpzF2oomtuKuwTQ3D5tC4N/Z7//nD6V7IW3dcK5d1gPrOnEY2vCTTbEnr8ub7IdY9lS9pucUmZKpVs2ndFp0dx31ieTflya01CfRTQe3oMkAeHsSEI2goDTQ3KwCu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Enze,

On Sun, 27 Sep 2026 15:28:08 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hi SJ, hi all,
> 
> Almost a year ago, right after a memory-leak fix discussion on this list, I
> asked whether introducing Rust for some DAMON modules could be worth
> exploring as a proactive measure.  SJ's answer was positive: he was open to
> Rust adoption in DAMON, both in kernel and user space, and even mentioned
> he had been wanting to write a Rust sample DAMON module himself since LPC,
> but had not found the time yet [1].
> 
> So, here is my attempt at making that start happen.  This RFC is
> intentionally small: it adds just enough Rust support for DAMON to port the
> proactive reclamation sample (prcl.c), and nothing more.

Thank you for this patch series!  Yes, I'm interested in Rust, though I didn't
have sufficient time to dig in yet.  I'm planning to attend Rust for Linux
training day [1] on next Sunday.

TLDR: I feel like we might need to wait or focus on module parameter support in
Rust, ongoing DAMON extension works before adopting Rust in DAMON.  Also, I'd
suggest starting with wsse, which is simpler.

> 
> The series has four patches:
> 
>   1. Generate Rust bindings for include/linux/damon.h.
>   2. Add thin safe wrappers in a new rust::kernel::damon module: contexts,
>      targets, access patterns, quotas, watermarks, schemes, plus
>      start/stop.  Everything FFI-related is confined to the wrappers, with
>      the usual SAFETY comments; error codes are returned as kernel::Result.
>   3. Add samples/damon/rust_prcl.rs, a Rust port of prcl.c.  It watches the
>      virtual address space of a target process and pages out cold regions
>      with the DAMOS_PAGEOUT action, same access-pattern filter as the C
>      version.

I'd suggest starting from porting wsse, because it is simplest.  By scoping
down to it, you could drop the wrappers for DAMOS.

>   4. Add a MAINTAINERS entry for the two new files.
> 
> Two differences from the C sample are worth noting.
> 
> First, the control interface.  The C prcl sample is driven through
> runtime-writable module parameters (target_pid and enabled, the latter via
> module_param_cb), neither of which Rust can express yet -- its module
> parameters are load-time only and do not show up under /sys/module/, and
> there is no general sysfs abstraction in mainline or the RfL rust-next
> tree.  The debugfs abstraction, however, already provides the safe
> read/write wrappers we need, so the Rust sample exposes the same two knobs
> under /sys/kernel/debug/rust_prcl/.  This is a temporary detour, not a
> design preference: the sample will be switched over to match the C
> interface once Rust supports sysfs-backed module parameters.

Do we have a timeline for module parameters support in Rust?  I'd prefer to
avoid use of debugfs and directly start with sysfs.

> 
> Second, the functional scope.  The C sample also repeatedly reports the
> estimated working set size via a repeating damon_call() callback.  This
> initial Rust version covers only the core monitoring/reclamation path
> (context, target, PAGEOUT scheme, start/stop); wss reporting needs safe
> wrappers for damon_call() and region iteration, which will come in a
> follow-up series that also makes the Rust sample's output match the C
> one's.

As I abovely mentioned, I'd prefer porting wsse first, and later extend to
DAMOS-based samples like prcl and mtier.

> 
> A quick word on the longer-term plan, so the design discussion here can
> happen with the destination in mind:
> 
>   - Over roughly the next year, I would like to port the other two DAMON
>     samples (wsse and mtier) to Rust as well, and let the DAMON Rust
>     compatibility layer grow together with them, wrapping only what real
>     in-tree users need.
>   - Once that layer has matured, I would be happy to try Rust for the
>     production modules - damon/reclaim, damon/lru_sort and damon/stat.
>     That is a much bigger step, of course, and it only happens if SJ is
>     comfortable with it.  Consider it a willingness statement, not a
>     promise.

I think that's a good plan.  However, I'd like to call out we will also need to
make each step with good and sufficient discussions.  That is, for each step,
we will discuss if the previous step change was helpful and therefore make
sense to proceed to the next step.  If the conclusion is oppostie, we could
even revert the previous changes.  It would be great if we could make it driven
by data.

> 
> Regarding the MAINTAINERS patch: I listed myself for the new files, but did
> not add SJ as a reviewer yet, since he mentioned limited bandwidth for Rust
> work in that earlier discussion.  The existing DAMON entry already covers
> samples/damon/, so the sample reaches him regardless; adding him to the
> RUST [DAMON] entry would only additionally route future changes to
> rust/kernel/damon.rs his way.  Happy to add the R: line if he wants it, or
> leave it out if he prefers.

I think I should at least review the patches.  Also I feel I am responsible to
the maintenance of the code.

We are extending DAMON to work for not only data access but general data
attributes.  I'm also planning to refactor DAMON API quite a lot in near
future.  Some interfaces will be added and removed.  DAMON API callers
including sample modules would also need to be changed a lot.  If we make the
Rust sample module with the current API, we may need to make changes not only
in C but also Rust parts.  I concern if it can introduce more breakages that
require unnecessarily long time to fix.  Among all, my lack of Rust
understanding is a big concern.

I understand this patch series is a kind of experiment rather than for a real
use case that has a hard deadline.  If I'm not incorrect, I feel like this
might not be the best time to start the experiment.  Could we wait until
fundamental parts including module parameters support in Rust and ongoing DAMON
reconstruction, or my learning of Rust are done and stabilized?

I may missing many things.  I might simply rejecting this great opportunity
only due to my laziness.  Please push back if you find so.

[1] https://lore.kernel.org/all/rust-at-lpc2026@google.com/


Thanks,
SJ

[...]

