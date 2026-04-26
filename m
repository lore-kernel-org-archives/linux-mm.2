Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05335FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 17:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27F86B0005; Sun, 26 Apr 2026 13:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED96F6B008A; Sun, 26 Apr 2026 13:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE9A6B008C; Sun, 26 Apr 2026 13:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8DBC6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:33:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 62FA8140544
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:33:56 +0000 (UTC)
X-FDA: 84701404872.07.18D0085
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD1621A000E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:33:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muNEjNIn;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777224834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSQLlwft2oATSiq84OUJPx/kvXvVcYMIjZRNk60qiUg=;
	b=48ywZM8zfjUQhMApmlVGIv/feWES+Staq6l7RsuhWDTwSlqiejA6cDQsfjHjd4OV0IW8K/
	R6xeZ5ZYcDFG7iEXkvGIED+GfeZWSyPKrDeC0TMgi4TqOwUIZyzS2rHn/70Uva0ks8B8OP
	5kwdlXiXwMAvGlm5Q3s4MYNvxI5Oieg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=muNEjNIn;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777224834; a=rsa-sha256;
	cv=none;
	b=H7lCyFuFINIChhFouhZORnKOpp7LVL+6Qy9uiLm+9agMN1MUhfd9BLcI74PquS7cgPaz24
	ldOhaRfm1BachTRev7sg7aMLU+kyDMM8E4lffHmVz76LRD49OfN+nnw2vXLzFkXcstQOsN
	2tPBDDeI6WY/ubjdTb3TEnfs61QYKGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 107FD60138;
	Sun, 26 Apr 2026 17:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B48FC2BCAF;
	Sun, 26 Apr 2026 17:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777224833;
	bh=NyTBE653KUBU75B1Vw+ooRQPZJEKpc65dpXTTl/wexw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muNEjNIn9bmjunSTmqEoWZ4JkfJ/h02Zn/c9cR8jvok9bIl5vFicBPprhkCdMm/Bc
	 GvRlyYtvl/Vs94USjM+3iRff/FILL1R3tBPquAiPjw8Q+azsH9ZZL2ttcfwssleBRy
	 iS1vE5pQY9pqSACHwsgWDKUdfoRceLFSoyEzRiQTOUEMZayNB8sQJdT/3siGEsFZo7
	 ZEyuz/v1wzF0oq1+2Z24l3X0NO4p/nXhNpCcO0T9z2mnl7xeFFpS31aSbN93G503gZ
	 ODra5De9gCAL8jUU4lqrcxEtmUcIkVoqA8gmuGCOr3GBVYJsW+us2+4aEoG9DV/fbW
	 h5sQtuOEu8TJw==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon: introduce damon_rand_fast() for per-ctx PRNG
Date: Sun, 26 Apr 2026 10:33:45 -0700
Message-ID: <20260426173346.86238-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <afcbb502-b91e-47d7-8fb7-2e4e237928c5@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6tf55x474o67ehozt41h4syrbb6a4j8t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BD1621A000E
X-Rspam-User: 
X-HE-Tag: 1777224834-399566
X-HE-Meta: U2FsdGVkX19wvj37lansJEb7XhKpokXWfTs+oLNLSM2H2z10wf1VrGE44z9JsoUh/+/w+KY/Fvgdq8AtH08lMhElc2Yk6btmwgFHkNZM1KzdDYqH86ubgf4/47HCQMLFsgiNrjfjIDSxcHl/x1WeL++dPtx5vidLGokV28mHs7awjV4lxf8KYG2IZ/OKJSWTBkNqreOi/fGmIh4XmhA4yTA/uxBE+HnDpFzD20p685isNJ/A6FkOB/x5qEeTjA4izUnGuQ3PaNBBP60FBThGGzwOio1qRAwslyfe64lgMfGdUApG3FbwHDDLIhmIKZqqDoQ4e+gYhQSuAGTGH92z6fCMLDOAJJK6QKyK6bjQ1E7AWR7cKjy/JDFizSoQB34Rb5WIGBYL/3PJYWhlM5gUHSp5QyvM9X60YlMuj7e6ps3WjiIJHjfFetzH5OdF6zLshj14RsUuvy3YjkVzo7EXPAWa+0FE0+HEJtrHAyd3z4Zr26Fpl++CR2hWhFhF6Ffq98dF9o5ZdbufeCEAwHsO8h8l1r79mC3BkF7NoUdrdHRkiFCEjk0f0P6Wi40mgImUMnbDCWOpxnfj/SMqEQ5pnqzoLtMUWaI82CbkfwL01OoMMVhq0EBcu5lRWMFZwWvbJeg+dKTs4YMeteV0lWyx9+fyYMhp+eoJw6DH7FFGNkGiFjUNjzInrHZ31Fs29VXnnA1pIPKeIMO3CCrzeiVT2lDY1mEhQudsiUkaH2M86ebPh8bxJr8P+TVLxRg88HSPDegj+hS2N3HUvoaA8rBi+Sfty1t+rSrayJ5FhN34dtcGZLiUowKyK+zCs9aUDe6wSxRwoxbSz5BguBuksJdH0mVxaAIQkmHaNh/b5snIfiC0Jne3fqWSCcBlM3YXIiYsq+nDb1vgXRD5XNrzzIBNvxNV15PjQ6kowSPipDMdBy9j5oJuR7ZCFbUCLmxIiXRu/AuuTNdzKiZ5sCVKY2A
 bn0hSgnm
 kpO3SJm/Ji8DCL2TXI7+/7QBi+2eqo1SoR1u9ajWvud2YCWNhzuriyj8COdOC59bhuHBKEV7YIFWSuoudmGcH0Weaao+73KLpbjZq+ZqABtH9qAW1wcx7xPK64g0LdfpxrhZQhdeEC0UyFQ5aHVrfaoR1BZMMu3RwLcXpOFeqJ6GEy/YCnEQS5XgDyVftgjulvuzvMhURHemd70HnMfDOeDV1kYbjLwP04553oswVi5uMiAxDpO4J71s8U49NQGNSKxr0nk60fTpwUOJAohb0r2nejvqUtTpCVZQmblbIYotCIurVUvyXpgA/Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 13:50:42 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> 
> Hello SJ
> 
> Thanks.
> 
> On 4/25/26 11:59 PM, SeongJae Park wrote:
> > On Sat, 25 Apr 2026 11:36:02 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> >> On 4/24/26 11:11 PM, SeongJae Park wrote:
> [...]
> >> With ~2 GiB
> >> default regions on a 2 TiB host, a small pod's pages are averaged
> >> with thousands of non-pod pages in the same region, and the
> >> region never reaches nr_accesses=0 even when the pod is genuinely
> >> idle.
> > But, the adaptive regions adjustment mechanism dynamically change size of
> > regions, down to 4 KiB.  If the small pod's page is really cold while its
> > surrounding pages are not, DAMON should down-size the region to capture only
> > the page and show you nr_accesses=0.
> >
> 
> Looking at kdamond_split_regions() / kdamond_merge_regions():
> the per-region floor is 4 KiB, but the *total* count is
> hard-capped at max_nr_regions, and split itself is blind --
> it picks the cut position via damon_rand(1, 10) without looking
> at access patterns.  What keeps a split in place is the next
> merge cycle finding the two halves have visibly different
> nr_accesses; if a small cgroup's signal is averaged with
> surrounding host pages on both sides of the random cut, the
> halves look identical and merge folds them back.  For a 1%
> cgroup on a 2 TiB host with max_nr_regions=1000, the
> split-merge loop never converges to cgroup-aligned regions --
> random cuts almost always land in "99% host + 1% cgroup"
> mixtures.  Raising the cap gives the random splitter enough
> attempts that some cuts happen to land on physically-clustered
> cgroup pages (THP, NUMA-local allocations) and stick.  That's
> why the cap matters in practice, not the 4 KiB floor.

Theoretically, you are rigt.  But the size of the impact would depend on the
workload.

In my previous testing on 1 TiB memory machine that was running a real world
workload, DAMON was able to find 4 KiB cold pages.

Is this somewhat observed on your products?

> 
> >> The cold signal is gone before any cgroup attribution
> >> happens.  Cgroup attribution itself is done at sample granularity
> >> (folio_memcg per sampled page), not at region granularity -- the
> >> regions just need to be fine enough that there *is* a cold signal
> >> to attribute.
> > Could you please share more details about what is the cgroup attribution, and
> > how it is done?  I guess that is the way to map DAMON's monitoring regions to
> > each cgroup to determine if each cgroup is hot or cold.  I'm unsure how it is
> > really be done.
> 
> 
> We sample physical pages within DAMON regions, look up
> folio_memcg() per sampled page to find the owning memcg, and
> accumulate cold bytes per memcg.  Userspace reads the per-cgroup
> result and sizes memory.reclaim per pod.  Conceptually similar
> to the page-level monitoring you pointed me at -- we'll evaluate
> whether [1] / [2] can replace this path.

Thank you for sharing this.  That all make sense.  I also hope the existing and
planned cgroup-aware monitoring will help your use case!

FYI, I removed [1] and [2] in my previous reply, so pasting those here again,
for other readers of this mail.

[1] https://lkml.kernel.org/r/20250303221726.484227-1-sj@kernel.org
[2] https://lore.kernel.org/20260423190841.821E4C2BCAF@smtp.kernel.org

[...]
> >>> So I think this patch is ok to be merged as is (after addressing my nit trivial
> >>> comments about coding styles), but we may still want to fix it in future.  So I
> >> damon_rand() is now only called by damon_split_regions_of() with
> >> the constant range (1, 10).  may by we can rename it to
> >> damon_rand_u32() to make the u32 constraint explicit in the API
> >> name; that closes out the truncation concern at the legacy helper
> >> without needing a separate series.
> > Good point.  I'm wondering if we have a reason to keep using damon_rand() at
> > all.  I find no such reason.  If you also find no real reason, how about simply
> > removing existing damon_rand() and renaming damon_rand_fast() to damon_rand()?
> >
> 
> Good idea.  v2 will remove the legacy helper, rename
> damon_rand_fast() to damon_rand(), and plumb ctx into
> damon_split_regions_of() for the new signature.

Sounds good, looking forward to v2!


Thanks,
SJ

[...]

