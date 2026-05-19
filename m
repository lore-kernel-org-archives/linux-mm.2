Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5354CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3256B00B2; Mon, 18 May 2026 21:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52466B00B4; Mon, 18 May 2026 21:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C678F6B00B5; Mon, 18 May 2026 21:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3A386B00B2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:14:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DE551A0133
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:14:50 +0000 (UTC)
X-FDA: 84782399940.26.1392F99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 42C38A0002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:14:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWilHvQP;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779153288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNGjqDsnY3QA72hnHcGGxL6k1dOVQK+fwIS0O9Qvx6E=;
	b=fjvGHRaHyNYqwzKwQnyAdsk8LC5M3h8EMGg8xH6f5UmP2wySWWOhW4usQ1Tmg87RNMhC87
	eoKRWryBTdJJ7chUxzQUCz1o+av7Vt1a6S0ewbnYh3LnMLep4LJQqhH8CKSA97ZPAIVuRC
	DrrRs3lc0v2f/WHSN+lGfN5Dauuc5mM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWilHvQP;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779153288; a=rsa-sha256;
	cv=none;
	b=v/VkSKYXh7iQo81b3PiJNFgfBdxwLf3cvCM1pjsbJOcsEjSFtkQIxJNMgZ/M4f4WjG/TdH
	JIOaC3EyKumkgjYtMkZNGJ5FsY2esPND9AW56WcoK5CwSI12ORqMtnH0yQ/umHhCJAPhE8
	6e1l2Wt/73ICqUk4oN++3x9n5eshamw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 320EC41757;
	Tue, 19 May 2026 01:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DD6C2BCB7;
	Tue, 19 May 2026 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779153287;
	bh=2kljYz959akpWYYVv87a7PKBDFfGelUMKZ7YiyHZVXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWilHvQPZZd7DeQWwFDL3B4sTRguYaw7ISYSe0UQ0fYUO4eJke5tPz64CcMo3G2J6
	 +wnwTk6xFCEThHHyMi4f6QMI27THb57EWnbonfpK2XsqJBdW1I3Ugeazh8Lo0drZDD
	 2Ahmm/UqczhgdP1cDp6262zavReH9qJ5DxDtn2zhNP8U/yxW+PsiDvZBc6v0ojukp6
	 dWQJ4GbQoPLGangb7/vvH/nvpHjDw0urB8TVWWRfpI3A6+IiPUG7Cqfr5n1M9tf/5y
	 xIQ3wSXcEeLz3jTPyzyPuQkJIB7haF7JWAJc3vswiHlSLNcDPYxsVFTK7r287W595C
	 raaFcnwN+N1RA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 4/5] mm/damon/paddr: skip free pageblocks in migration walk
Date: Mon, 18 May 2026 18:14:28 -0700
Message-ID: <20260519011429.100021-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y17nudor22aJvakfos3UegPgEG1M8N7cJPAxWX0Ca=MvfA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42C38A0002
X-Rspam-User: 
X-Stat-Signature: dsgi3heo4k9h4rac3pymnc8nsx5rrfm6
X-HE-Tag: 1779153288-749906
X-HE-Meta: U2FsdGVkX1/+JgMATGwh1+rsJJ/h8zNJL7VYFoozmKut6CnfAw+c6lfAjEHolmpu8BV7eWlr+CuBuI9doeniEYhNl3kUD/QiL6LVE2c/uFSop/K3hG4gk7ydFXT3XFejdOgkMnPgDzPzvhHERgCOu6KtWrCU0AnOK4deQr9YllWrxg2VJeAgocaEQfSQ2K5Xso9l5dwOVIJVnpLtPN6jT7/sF+jfBrtEgc6zj9rd2b6F8x3kBLlR/ftBcFYfbaOD9aJTwmXl+WK6754YDl6eRSpRXyVfWO3Lxyc+za5PRE4ZtaMe1+8cSg+BRLElcANQCWlAUKzb2auqLTn0AOr5IA7TDBCalaS7SR2AHIN+NBXgUM4wmf/KYimYuIZF8LJdzqbrT+fi9lPkBaL4w057ffhhMXYfvidxxTcdzYE1x4IViFTGT9NDSfnLO6bJK94Sg2A9DKzaFSYYvX3r4Gx+jRw8voHXi3YLlZyH12EXh9xRGdHhwb1foIQZJlTP+u712CuOECCq3zmAe1nrGHi9+qVfa1To0YOlv5nu6OibS4ANbwum3fhZxnxZChAcCzgVqsxQUC88SH60JjcNnEfisMcl3gTQJ/xNTp2onG5YH5ONc/GdL79qEn7SC/8f0jOzOIQZpwi4jRg2RJTjJPM7NEBvZ3wayQW36x8kjIyABSabqo2Ll8jvihYSTWB4yGi/Iy+YxIRzkU9LdBH4tSso0D2HgPDptrgF8XTy4z1JcF2+uYzg7MwOOtR+RqpfqhSwgsp86JwSsCOsP0cuoOzPlNWeoq51PFe8OSuF8ZaQvHtQsst8G6xjN291uKj3LypmoSJllq0AVsotR1pBFINs/sREkwz7dhkV3p+wzbghq4KPLvxEmRlfCvpxn2AcJpRpgz3PBt2H9MGMcaj5mE6TLdhN2ETLYFp8wHWUE8otxSj+8UkxFEIGFfIxsOHEszRF3ddNOinRmyO0rfoOidq
 WkrLnHX1
 37b/EScwQ1V0lafcNF4BghnoMqBN5Pqihm9DnpdEFXuem8NTy0aIe2WU/tib2joaCgrVPn+jCbi3jeOZNETWqmX4H0R79l8v6j2zwzMljjHTkxP8sv6yz/pNlDVczXJU6pqwXAWIKMZTfzt5HiObJ3edw3IwEOcMsAIishw3fdAbvnaxY3ROuQKYqbFHxImOso8jqzShoPqKBDWwMQzPdkdTxtLHPG9EhjCJowHfk0UkC+EQUZ/14gBpjESTsd45uLz1dCHOvhv+xpKm5BWUj3m2kM9mjSCBqiV5H8uIJtW0cgomxDVF5ITqVa8oqbwWshp1lad2w1VzQRz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 22:38:51 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sun, May 17, 2026 at 4:38 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Sat, 16 May 2026 14:03:56 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > damon_pa_migrate() walks every PFN in a region linearly, calling
> > > damon_get_folio() for each one.  On sparse physical address spaces
> > > (e.g., CXL-attached memory), a single DAMON region can span hundreds
> > > of gigabytes where most memory is free and sitting in the buddy
> > > allocator.  Most page lookups are fruitless and dominate kdamond
> > > tick time.
> >
> > On sparse address spaces, the problem would be large DAMON regions of offlined
> > memory.  The large DAMON regions that nearly all freed memory is another
> > problem that doesn't require the sparse address spaces.  If I'm not wrong, the
> > above paragraph could better clarified in my opinion.
> >
> > >
> > > Check at pageblock boundaries (2MB on x86_64) whether the block is
> > > entirely free.  If the first page of a pageblock is a buddy page at
> > > pageblock_order or higher, the entire block is free and can be
> > > skipped.
> > > Similarly skip pageblocks where pfn_to_online_page() returns
> > > NULL.
> > >
> > > This reduces the iteration from O(region_sz / PAGE_SIZE) to
> > > O(region_sz / pageblock_sz) + O(populated_pages).
> > >
> > > buddy_order_unsafe() is used without zone->lock.  A transient false
> > > positive (block becomes non-free between the PageBuddy and order
> > > checks) costs at most one tick of missed candidates on that block;
> > > the next tick re-scans.  No correctness consequence as DAMON walks
> > > are best-effort.
> >
> > I was initially thinking this is a good and reasonable optimization approach.
> > But on the second thought I get below questions.
> >
> > For large offlined memory space problem, couldn't we simply tune DAMON's
> > monitoring regions boundary to ignore the holes?
> >
> > For large free memory area, is it reasonable to assume such situations?  In
> > production, users will try to utilize as much memory of the system as possible.
> > Then, wouldn't there be such problematically large free memory area?
> >
> > Could you please enlighten me?
> >
> 
> Hi SJ,
> 
> You're right on the first point.  For static offlined memory
> holes (memory hotplug gaps, partial socket population, etc.) the
> right answer is configuring the monitoring region boundaries to
> exclude them upfront, not making the walk skip them at runtime.
> The changelog is clearer if I narrow the patch to the free-but-
> online case.

Thank you for clarifying, Ravi.

> 
> On the free-online case: I agree large free memory areas are
> not the steady state on a fully-utilized system.  The cases I
> had in mind are more limited:
> 
>    - A workload using a small part of a much larger range, with
>       the rest left as headroom (e.g. 64 GB used of a 512 GB
>       range).

Why would the user have that large amount of headroom?

> 
>   - Shared tiers where workloads are allocated and freed on their own
>     timelines.  Any single piece of free memory doesn't last
>     long, but on a busy system there's typically a meaningful
>     free fraction in the range at any point -- especially on a
>     slower tier, where workloads prefer faster memory first
>     when it's available.

I agree there could be reasonable amount of free memory.  But, I'm still not
feeling difficult to know would that be big enough to cause the issue in DAMOS.

> 
> The patch as written is a narrow optimization for those cases:
> the pageblock-aligned check is one extra read per
> pageblock_nr_pages PFNs (about 1 per 512 on x86_64), so it's
> effectively a no-op when the region is fully populated.
> 
> If you don't see those workloads as warranting the change, I'm
> happy to drop the patch.  If the framing is the issue more than
> the change itself, I can respin a v2 with:
> 
>   - the changelog narrowed to the free-but-online case (no
>     offlined-memory framing);
>   - any suggestions from you on sashiko's review comments.

I think your arguments make sense in general.  But I'm still not quite sure
what is the realistic size of the problem, so difficult to judge.  Having a
clearer and detailed use case and backing data would be nice.

I also got a little and trivial concern for this approach.  DAMOS quota system
assumes the cost of applying DAMOS action will be proportional to the size of
memory it is applied for.  After this patch is applied, the cost will depend on
amount of free or offline memory in the memory.  It might make users difficult
to predict the overhead of DAMOS.  I might be too picky and hallucinated, but
to be honest I'm not feeling 100% comfortable with this change.

For long term, we are working on extending DAMON for general data attributes
monitoring.  I pretty sure you also aware of that.  The v1 [1] is just added to
mm-new for more testing.  It is currently supporting anon page and belinging
memory cgroup attributes.  I'm planning to extend that a lot.  In future, DAMOS
might be able to target and filter memory based on the attributes monitoring
results.  Then, we may be able to extend it for monitoring online or freeness
of the memory and ask DAMOS to filter out or de-prioritize memory regions
having high proportion of free or offline memory.

So, long story short, I'd suggest to revisit this after a clear use case and
real problem is found, unless we have it right now.

[1] https://lore.kernel.org/20260518234119.97569-1-sj@kernel.org


Thanks,
SJ

[...]

