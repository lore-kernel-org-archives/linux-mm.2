Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE2D606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ox1Of21z
Received: by kanga.kvack.org (Postfix)
	id 19F4F6B075B; Tue, 27 Oct 2026 09:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1504D6B075D; Tue, 27 Oct 2026 09:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F096B075E; Tue, 27 Oct 2026 09:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8FA46B075B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:57:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78BAAA0935
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:57:56 +0000 (UTC)
X-FDA: 85368559752.01.D35A8A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBAE41C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:57:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ox1Of21z;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc9SGkKtJQTMDl5C3kvAcEmkGmH87ZOZUzIPqVhBwZ4=;
	b=3I+0IcQu0C+/HCtJoo40Dkn3I6prFFvWLKgo+KR30ZMhCYYm+ZBHu+7pNjPEnR8xzOEqpi
	FxWPFiT4JC5lVYJlW9uKfnD95BvMivN1SFt+/Wy9PTaixA++nIRYN1oV655QMRN5dtsPgH
	rVLsfnaNRNXVsFVjMqM1qiNR/QOa6LM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ox1Of21z;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109474;
	b=D11lpot49EHgmt6+EBzDeNhJHjk6wlY48LiUpyq0R9eB1VNfsnCNoRM/+a64Tw+ndjsaKD
	+0Cz2onsWsAiPJm9D6WEQVHv0XjFWOScdComl9966Mx+6qrkjGHvQtX3N17FMafLRM4Dvg
	7BpM+hxD/P260y9H6u33U/C7nxSzLqE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5879E601FF;
	Tue, 27 Oct 2026 13:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792D41F01825;
	Tue, 27 Oct 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109474;
	bh=Oc9SGkKtJQTMDl5C3kvAcEmkGmH87ZOZUzIPqVhBwZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ox1Of21zf466valLKp99VgE6Npi2m7UHhoXKf5/TUQH6DnfElXxvgH+b8ifIMFE2v
	 xqW2zDm8NqAQ7dUm++XEnYWmeQzWP5RpgtM0B7TOTf24MP7EfMospsQZ7/sgzl/979
	 vhE16OirDAl6Fiz5ULpEB8KiUY4J+qgVXP2petQuujOnuEA+xirLoGwsa/G5YS10Zq
	 UjMG99NwwvwzJVx71/wKf3oLYTwbzySL4wz7xpZq1DiaCbcS3ysDJqgyOnxn9QO6Ze
	 WiBbCpZXOD3JoefiyU+yrAom6HW/pMrLrpG6QLJ3VFXugz2MLttS/vNNt6GjjTg223
	 ccDppjdY79y8A==
From: SJ Park <sj@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/damon/reclaim: allow disabling watermarks to force reclaim of cold pages
Date: Tue, 27 Oct 2026 06:57:45 -0700
Message-ID: <20261027135746.150166-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6e381f14-f00b-4c0d-8499-f5a5f37b2572@huawei.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CBAE41C0005
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8zmb69m41uz9jwj6qbxszgdwuxidcmwc
X-HE-Tag: 1793109474-51476
X-HE-Meta: U2FsdGVkX19xkUsOYbcsF65M7gd+P1AVxs8aFaktFaopynULpS5nhaQn+kxMoD0LYLv65yob0iq/crTc8pveymBQBYW3IwOVEydEIDE4FEWRoWX5Y3BgR5fn59NB4p/CKgzAmnwtr2a0TiCno3ZiyssnEveIJI2hf0JY90seNvOvkX6pQ4Z6XZ5q0QDbS7YfySjkEw0uguVLLdu/8SClOsGxzv2AaCZVZlbY/+qwdGYGUU8fIjMGtuA6AZjHSZecn6STdSFUkli/sp/7Q6yoXJsNckiXzf8iX6Mkk3Wa9QayZSprJnW7sh/BdeCORimqv1PPeBG7xZKxmgu9MGXIBOR9x9Ov40F4ON1aLURRaodrZzFBJivYw1SE8ZB/dmLeOj3EEI7xI+HYdNO8r1acY3NodUVxMeD2lRstjWT/EmZMwHEhBxkJflSIkZ5rEfQtRit9XPWIe4Sl8GFflTKULrUmFVmRcv3nWB5+/dFK+WaYqD7iT5xl7JaSb7KWj37GswCK1JptED9k8uKS0n97KaA836GiVvVkPTf+X5qE2eHvoUyYOOVaDdmC0LzIwFExxGpBm9E+fX68pzr1kAtE3PMfYzbRl4oW/RQGX55/kYCmygjFqVH0BWB8xgc660yN04Vu3fofOks3DGTxHiCKbUuHbC7L52/1LLaIQtcv7sTnwg5m4H/G60h+txq1hZPfJMY57ejYNsC1mK1eA5QS8H8y2GXGvVheJ3bhw+zK+KfqVYWRLelFIh+opat1d6sbAdB7w3q9CmX5R2N1zkNsrU06xmDjLWA7KziE9jW8mzAglCciA3VnRGsXdi9bOFEoVfN7DDT1C0VAlnRSYQjwcOwDk6WEmc/ZNkA3VDZumNu69NouPpIi6Jmt5f88EY36/d5Zfo/apo/QaX15f3Z4mnoW05Wav/GX3mUyfHmzeTm7AP4/kYu0k8VbLFredLVodEXyqL7zs7ezpFE87JE
 9rNv9PYs
 GDSQZVdhQUt9vxln6q48ojiufn+9vbMCLuVRTV1hMzDqtwUp5ZrTsq4jKysBolrhOc3cKLfWXocmpFPQAlVPje1SwKIqemoh3vS9NWP+K39Cia8p8h22hEo3NaD/m7ZhApyH7dGCf4lOteE+Du6NIuWjN369iQMgnzRq+QEByDrUX18tNlso1/uYSokIp/cCFoP2LTTJWknnefuNKdjjWCfNxpV2GyMwC6dr4PBRTZJFh+bP88WtqY9F+qtl4NEip9neW2iOPcGteubg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 17:46:11 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> 
> 
> 在 2026/10/20 21:58, SJ Park 写道:
> > Hello Jinjie,
> > 
> > On Tue, 20 Oct 2026 21:32:33 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> > 
> >> DAMON_RECLAIM runs its scheme only while the free memory rate is in
> >> [wmarks_low, wmarks_mid].  Reclaiming cold pages raises the rate, so the
> >> scheme self-stops as soon as memory looks plentiful again, which is wrong
> >> for a VMM parking an idle sandbox that wants cold anonymous pages
> >> reclaimed immediately.
> >>
> >> So add an ignore_wmarks module parameter. When set, the scheme uses
> >> DAMOS_WMARK_NONE, so damos_wmark_wait_us() always returns zero and the
> >> scheme stays active, bounded only by min_age and the quota.
> > 
> > I agree there could be use cases that doesn't want the watermarks at all.  I'd
> > like to avoid adding new DAMON_RECLAIM parameters if possible, though.  That's
> > becasuse DAMON_RECLAIM is introduced to let people use it without complicated
> > setups.  We will of course add new parameters if really needed, but I want to
> > see if there is a good alternative.
> > 
> > Have you considered some other alternatives?  For example, could respectively
> > setting wmarks_high, wmarks_mid and wmarks_low to 100%, 100% and 0% effectively
> > disable watermarks?  Have you tried that?  If that works, how about updating
> 
> Hi SJ,
> 
> Yes, it does for my use case.

Thank you for confirming.

> 
> > document to clearly explain the usage?  Also, have you considered using DAMON
> 
> Thank you! I will send a patch to update the doc later.

Looking forward to your patch!

> 
> > sysfs interface instead of DAMON_RECLAIM?
> 
> DAMON sysfs can also do this with "none" watermarks. But I want the
> simple DAMON_RECLAIM for only proactive reclam.

Thank you for clarifying, that makes sense to me.


Thanks,
SJ

[...]

