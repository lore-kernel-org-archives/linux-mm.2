Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F4DFC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DA26B0092; Tue, 11 Aug 2026 15:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEB66B0093; Tue, 11 Aug 2026 15:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 415936B0095; Tue, 11 Aug 2026 15:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1293A6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:37:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D70DA1D3B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:37:06 +0000 (UTC)
X-FDA: 85089996852.26.9D5156F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C0BCB40004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:37:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZK5z1mIO;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786477024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEIV1+Ic2JJ2pbDnh2hSoJgw+LV+nGwdX8sOI5VTTbQ=;
	b=2/ZAOUB4rHk7mWEp4NHCvLu+7bHNyDe+HSO2SsCPkhpZnYRPvihP2GgjEfiZp7nNyrYf3L
	lg1ltmJsBPdiU9pu/MnBUrLYjxqJIuTIZFkW+3LRlPFdiNhGDIbvlbazIV/sKNi9neiDWp
	o04cJynxlT5Y5s3kcWvTMPe24O4aYsQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786477024;
	b=ocy8VC107L6DLj182URsE2EMNBREsj3yziO0JrtdElf1nTwzgawR461uK9ICgv1LULPvlM
	6KzB9lZUACDc61i7IJyQ+nl8vGe6s4WSSYuWCvQyYIrOnDnV8ysrY9cYp7xwT7FuRtqpMi
	Ngnfe5FbJUF18neZdDvRNTJUmXbzbUw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZK5z1mIO;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A36341720;
	Tue, 11 Aug 2026 19:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB761F000E9;
	Tue, 11 Aug 2026 19:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786477023;
	bh=JEIV1+Ic2JJ2pbDnh2hSoJgw+LV+nGwdX8sOI5VTTbQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZK5z1mIOs+2tz4ZAf0h1lEU9OS/9Ig0pXVprUHkNmIDefT/MQ8fVSjsIKeoQpOXBQ
	 8P7ZjmBBQLL9XebRiAoxunQq4+2gL7Xz0z3z8D2sFaeuactLIMewkGJgN/Wfqh/AKl
	 RkzVitgTCEZHIN1hh09OMj9vTsV2VglHFmzm1eQI=
Date: Tue, 11 Aug 2026 12:37:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, Max Boone
 <mboone@akamai.com>
Subject: Re: [PATCH v2 1/2] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
Message-Id: <20260811123702.f3c60a3573e148c53ad35b97@linux-foundation.org>
In-Reply-To: <20260811161949.3879321-2-imv4bel@gmail.com>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
	<20260811161949.3879321-2-imv4bel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: exy3jzpp1g58w8xo4mstdpgzjfin3mkx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0BCB40004
X-HE-Tag: 1786477024-415702
X-HE-Meta: U2FsdGVkX19DB8HiiFQbxp05OR2ko0Ld8axa4sj4sWY4HGnI1WJnuBCeUgtM8PJvICrneux5Ag+3QiXYqgwL7P2/2pdL90nalbFrfy+eKueyiAqvwCRf3IqH35/koMC1vZiVIzOqyQypzH1VFUyK1MjcsnNfs15B1FOnIIOLqHTZ66JPdM5mciGAOi0IFpr/jC5yHcgJ8z4obwogg7NhRAPzaHpjE1e/y2dPod1On2VLViv9uI0i/FPfiV2OCoR9yBB2LhcisUARTh+Sf9NnbdcDoULA694XWxyPtSRDRT6by/69zxoWkG2Vni/onxElcxSgOeKrZNOkIeYJIU+3o9XvvBYzA1pDRphe+SDnK1s6kcdtc8zDOWD1IzpApLjlUYEEDoKo5erd/F6SaZ5FJB45Duz0VSESQMdc+Nomv1O4J27OP/fDZizG7iWQqFu8+8WXMddWibO0nYVSJNw11jewL7X6rSysae8C88ayNhVSzymaDWYlSOqNipr6ZYd90pAkDVaaPW4hwyKsoBBIs8pNdy2wL+q4RbZIL6Ryk2Lla14+UDYvSYWB5mD//HJxeG6s90xY4HO4EuJCqRHYjJJCKyOYexonapF0LpxhOjVjljAuOM5yEwECW+Waqvw8aywNoJuDwAgpkQPpD8acbVDuTwbpbNh1pmycbOfsa5MC23+y7OkQQtgnCAFGI3wgcct1xDqUmkIUqypJeyJeMbuUwE7xPCyIBrJScuqxVws6tulLr96En/LO0FhmlUzb2YGJCIzzc9G8cmhqTpFYRn2ZVtaTykinXWVOPQv/FtTZklxxv5KKRvA9em3pO/9LfLxzo5I9L3Tf9ELBxESxKrkkTieIKEDEAcRsoMl5HIbrkdEWyT2oVLvihNmD9ND+OlXRUp394Px0kxR+9djfdCVy3k6cbz3IoTfq6k3esaxXejpbA3fspKESnyWjJGRjOG9fwp6paX70rPC+JnO
 mpL2IUu2
 kYhNCTFZLobJuWsUZAyMXcaIUTxyZ3mpKV6naZUwsnD4U6iQvwkdOGqjumLbnM3D5IhyiN8s+jbM4HKpmPWJ2Gu9nbDl0KpvO77m1f3ZPg3q2yQkDhzYtA+pcHsER9zqQZAHdqC353O8yV9JEX+voSAJwsADttBcyi3UZlUF2EPlGlSDMO7bONto01jT0RtwvlaqvbVRNCNL9np20C9es6ApxEoJmxQmKIQ3k0w8++9sq09PtB7zCx7zR9VIBlA0GV4xkPiDRXxiXtfz5Ts4pDICn7FekXyNn0HcfmG7sGP9DdSAWRvpOkoR3VG8aqJ0USB3NPGKcE/NmqJ5EJANygWJqSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 01:18:57 +0900 Hyunwoo Kim <imv4bel@gmail.com> wrote:

> If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
> check is retried. The PMD entry may be cleared at the point of retry.
> 
> In this case, if walk->ops->install_pte is not specified, the code
> continues to the next PMD entry in the range without resetting
> walk->action to ACTION_SUBTREE.
> 
> This leaves walk->action erroneously set to ACTION_AGAIN, which is
> incorrect.
> 
> This was incorrect but not problematic up until commit 3b89863c3fa4
> ("mm/pagewalk: fix race between concurrent split and refault")
> which updated walk_pud_range() to check for walk->action ==
> ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
> to be retried.
> 
> In this case this results in duplicate walk callbacks being
> invoked, which is erroneous and will break any caller that is not
> idempotent with respect to this (and waste time for those which
> are).

"break".  Please describe the breakage completely.  It's really the
most important information in the whole effort.

IOW, when fixing a bug please describe the userspace-visible runtime
effects of that bug.

eg, what were the results of the fuzzer?  Is there a Link:?  A stack
trace?

> A specific example of this breaking things is mincore which walks
> an internal cursor data structure a byte at a time on assumption
> that page table entry callbacks are called only once for each
> entry.
> 
> Fix the problem by resetting walk->action to ACTION_SUBTREE prior
> to the none check.
> 
> The pattern also exists in walk_pud_range() so fix it there too.
> 
> This issue was found through AI-based fuzzing.
> 
> Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")

It's good to cc the relevant Author(s).

> Cc: stable@vger.kernel.org

We really should tell -stable maintainers (and all other users of
earlier kernels) all about the above things.

>  mm/pagewalk.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

This depends on the above info, but I'd prefer to process the bugfix
promptly and defer consideration of the selftest until the next -rc
cycle.



