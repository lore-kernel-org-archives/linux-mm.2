Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F3DACD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60EF6B00AE; Tue,  9 Jun 2026 20:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11C86B00AF; Tue,  9 Jun 2026 20:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9275D6B00B0; Tue,  9 Jun 2026 20:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 852166B00AE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:53:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17CDBC25E4
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:53:51 +0000 (UTC)
X-FDA: 84862180662.03.99868AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 401D2A000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:53:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=acgc7xgk;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781052829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9sO0gIm4z95R8a+HuLm1r79PfCgTK1qEypIW9uF7ZLY=;
	b=aswWfDEI2KlbeOiwEJK7lS2PLCszI9qggZ4i3zRE+rN5AGs3JomXxOy4V61ymemI1gIYwY
	4PnYKnkpWlaEaByBQ+CU8NWUorxsoz/tMUmD9y9lInIY5WJyGa2BanfMKvPOo4M2cK6NeQ
	D7Fbd72TREm8iEusOBHF1rimhyhkqF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781052829;
	b=WP5gNevqFJ15n1WGdbU4hu1VL77Slza95J2d8GSA/3ZyAtkD+P9DqBFmH2OPg7ng2Fa0SL
	8Kzs9EnLCgVLIAUsKBXdCyKTSKyhyXC6roCrhgcluaG6TZMGP8btkLLt6Y23QbWtm/T08i
	0VmSZVnmsAVa2KvwW6Tvz4FZnzUDLwQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=acgc7xgk;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83A2E602DA;
	Wed, 10 Jun 2026 00:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE071F00893;
	Wed, 10 Jun 2026 00:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781052828;
	bh=9sO0gIm4z95R8a+HuLm1r79PfCgTK1qEypIW9uF7ZLY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=acgc7xgkEu753ugPGGUjJS42dHPmgrdSxWxEl3bEd/o06wO8hf6DWmidvkiwJLPFQ
	 hH3311AyJa+Z/NfGYRTP9TDVz6X/iSlQSoFPBQmczKZpHJ1s8+ftom0oW9mcuE7YyE
	 gC2Lk9CMpaW6K6cnd1jRSb7PF67cSUFrf66896tE=
Date: Tue, 9 Jun 2026 17:53:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
 <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Waiman Long <longman@redhat.com>, Rasmus
 Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
Message-Id: <20260609175347.9688ac8060bc072ebd58cbe1@linux-foundation.org>
In-Reply-To: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
References: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
	<CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 401D2A000D
X-Stat-Signature: ftciapsm366jzkkpje8zxgmphz9ra6f1
X-HE-Tag: 1781052829-727486
X-HE-Meta: U2FsdGVkX19xu5Pdujbnr6lxerxjNCfRkHhBwEREvLbYE5NSiaEGdSmZ2uO6EEHarHwXsQhWzJYUsLJTV4kBqT+MM/Fx9kQwxl3+zH0JAP+uMjrrlhr3qdINEC4xER6zViIYYPQBGuVZsbpRtzsGRuIMGNehYDg9eiugr9Vu4QAj+OpnRNLJMjcG/ll1jViiGlcuSlYrh9H2UCIai7vH8KF/tqziyNvCiKAyM+MeFWIocQD56DkCaLSpnBdMW1o85pJEtROWafW2lP64VQOekBau/uqFC0JAW1Ri9eoL+ztt0oJpGgFAbSfYwZaNFd4qLTV1xtJWFM2iXE8DUApLNZDxMVv9BxmlRwROi2p7hfDoSG23s4ez65nzeFrYUJgOp0ev8JDaKwZ8Pfe7hIt/DQRowTrINoZOGjypvqlcJETHrVojjoVq9Kg9VcTP29srY5TGalRCNC+o4FaDNTpQQcMRrD4piHGmyEeimE09SNrSxjYqf0vmB8tjaHLxg5CUCwo96P1kJaZAjhYmTU4ppBaZsQgp557L1r2Urw2J9u46wcOWb2V7aRRewk9T2nni8M70fxc5xot+nuQp6dpaHnv+ccHs4mvhJvEVe7jY2LYpyZB2+cELXaHJP9nFYLm2/fGUabo4BIuur60sfovppPTsAMZFZK2Fc/RYR9XILZv9g3kFuqvzk5H+tXo85AsFR1JNI5pw543u6l4Qpb3g7S3/O1v8EnaYDOis2gPNSHM/WQUoOBNU9GILKvqe/70EL6mpIgt+33Jm6xJL5CoFPugwH5IS25V35VNIZlYowLryEFsp6x80ncAy2USUENy7xLzndhvHroIxpoGE15DWKq12VwCpEV59kLudrdXotDwF/Oib1AdLz58r1h40+OMvrki7a341wP03E+oJtROJjf2g3tF/FjggUmb2Kf4z0tckbg8iSrMnvzn+5gf+HoCYqI1VH51SfJeEPKGA0QR
 mnGvDICI
 OKmLpzxgNVzf+w1bqKYW3XY0AQNq4YrZ+dQ/0iMqTzdbZCQnrD7m/fgfDp12eib9pwNB+YejblGCW052D5ZflXc2gbApqGvN1aGhrei5l/A+dzKKF6bAizJ9+gcQctUZB20sj/uzSMljtsoI5gCwwddmRgCNZ0pa8HKxLEE+bqsmSY2Yo8zGkiTJp550YUTU46vA5CtEW8oRCxlM9sP9xORBsPPqgE50Fk0YiepITCgPJpIQQoXhsa1eJqvwbtorkBHILu/VHgA/FHBgL8QkEjbmjZVPjzOqAgIjoxPwlXToxEbJYuwk+/ThPb6YOXlCq2w9dadI+RxNFSVcMuhZGg+wdIjGunYop+TJz/iF5ft5EZhyK5Odh3DL2Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Jun 2026 19:57:41 -0400 Farhad Alemi <farhad.alemi@berkeley.edu> wrote:

> cpuset_update_tasks_nodemask() rebinds a task's own mempolicy to the
> cpuset's effective, online mems (newmems, from guarantee_online_mems()),
> but rebinds that task's VMA mempolicies to the *configured* mask instead:

Hard to understand.  Was "rebinds" supposed to be "is supposed to
rebind"?

> 	cpuset_change_task_nodemask(task, &newmems);
> 	...
> 	mpol_rebind_mm(mm, &cs->mems_allowed);
> 
> On the default (v2) hierarchy a cpuset that has never had cpuset.mems
> written keeps mems_allowed empty while effective_mems is inherited
> non-empty from the parent, and tasks may be attached to it (the
> empty-mems attach check is v1-only).  A subsequent rebind -- e.g. from a
> CPU hotplug event walking the cpuset -- then calls mpol_rebind_mm() with
> an empty mask.  For a VMA policy created with MPOL_F_RELATIVE_NODES this
> reaches mpol_relative_nodemask() ->
> nodes_fold(..., nodes_weight(cs->mems_allowed) == 0) -> bitmap_fold(),
> whose set_bit(oldbit % sz, dst) divides by zero:
> 
>   Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:bitmap_fold+0x5e/0xb0
>    mpol_rebind_nodemask
>    mpol_rebind_mm
>    cpuset_update_tasks_nodemask
>    cpuset_handle_hotplug
>    sched_cpu_deactivate
>    cpuhp_thread_fun
> 
> cs->mems_allowed is the only nodemask in this function that is not the
> effective set: the task-policy rebind, the page-migration target and
> cs->old_mems_allowed all use newmems.  The sibling cpuset_attach() path
> already rebinds VMA policies against the effective mems
> (cpuset_attach_nodemask_to = cs->effective_mems) and explicitly notes
> that mems_allowed can be empty under hotplug.  Rebind the VMA policies to
> newmems too: it is guaranteed non-empty by guarantee_online_mems(), which
> fixes the divide-by-zero, and it makes the VMA policies consistent with
> the task policy and with the nodes the task is actually allowed to use.

How is this bug triggered?



