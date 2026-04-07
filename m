Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 959A6FF510C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 16:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07D236B00BC; Tue,  7 Apr 2026 12:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054F06B00BD; Tue,  7 Apr 2026 12:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3D96B00BE; Tue,  7 Apr 2026 12:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD38C6B00BC
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:05:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 889708C677
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:05:51 +0000 (UTC)
X-FDA: 84632235702.13.2203511
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E8254001C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:05:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6qAumRZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775577949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31FSVCx0zavKn3TOv6Wj4ou81ownTB0RmFya2us7M4o=;
	b=5oLd/OO8JJQIW790dT1lCGPssFgbdveAiDS4niUez0KHQb9x5ZIiai7+0e+HAjudUmlNTU
	JxblJF8XjBLogssQ3wqEzUUJ5Pl6+CTrSPNA1YR+6xZLBeKlTIaYZF8xJxf/N1EdfN9yYR
	eb9Xvx5+mG/fPFmjIvoFQs4dMYkgFmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775577949; a=rsa-sha256;
	cv=none;
	b=W1JMO4B4bwqFVi/TS/HMGp6WPHppLI7H+iDF+clv5SNJgPfXbtRsqCquxiuJ902ccIHAxO
	yZGiU9qhiqQKJrC6qfZ7e20FtYjum+s+QLpVsG7B18LkVTTPA3Ar3DvmXXj5UbzxmZbgkG
	aOndN8lFyGa5k58BLUs4igD3a7Dxz7E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r6qAumRZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F6E24347B;
	Tue,  7 Apr 2026 16:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79CCC116C6;
	Tue,  7 Apr 2026 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775577948;
	bh=lGp2BtsUVRO4kNlYByDjsk197DjKNjmTVw9N5OE+1r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6qAumRZuItcevNi0kQNK4pSGc27B0Y8Xwnz8s57+37OFqzCCESt3MMoiygqirtnw
	 76HCx2amLkWNSAInP56KZ5SopwltsZqvtnnIAO+PwbIDiEZGAcSwuYYujAm9C4OtU/
	 3C1F9Bh99630PZwZuTY/tutKggi0JcBrbD722tucAGNQqLbtWFonOMoGJ1uCkB7E/r
	 Jm4vZiQlT78m2MkpEjjzLHUlu+jx9Zs0a1Nvho66qYlCyiYbJsvEteSoEFsFnCGr1c
	 2g0y2gF/xLdBjFCy7tLCCO4vH9JC11qF3zOMSL6z2aQEeI6jt9sxR3JRzHKve4C0xa
	 JSpmkBw/4lrEQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
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
Subject: Re: (sashiko review) [PATCH v6 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Tue,  7 Apr 2026 09:05:44 -0700
Message-ID: <20260407160546.52220-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407001310.78557-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E8254001C
X-Stat-Signature: g89fw9g51esn515h5k3gd8t43cb5cy71
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775577949-590883
X-HE-Meta: U2FsdGVkX19A8KOC4rYJNqyyGpVhaxYDiDBUHAXaYBKp+tJLQYjiCRL1JoYOUeElIE1ilsppXyPIjkqPwRaZHACd2kNsvoaaVKZVm9A7NxKE6bOvwSE7LH4M1kNKkf/Rd//s4GDL/beSjRHLPkp3YsS9JpVS2IlLC5h9giSAbLd51DoU3Q/OsgvEf8cEZHLdNWXk80Pb9cFq+F7mums7nsobUoexF16GVfOJT/Uzheggue3QsmPa+ud+ZU4sH3MS73samWANQU+sBmKqT1RDdA842GYSYlFCbPHvInxQkuHFuaRHBo1ZzMXvfcb3PC9rJDGdO/7bwY8FOC8qf8PrMMzX4wYGU2mNtHI9ydyEEnHwBo7gMJZr5f5bRrY/Fe7oUQeJaj8+3oaktKm4Uww2l6igCngeExrBAqlmWEveKkbSAikT19ipNAIZ7epFDQ3mIKMLOmzXSYmzuoRXZlVj+vd08aN+3aJZi5SR0QyAbhKzlj2sc+SvAqHwVclmDBvFoJmNjKbojlC7iOZFHeC/GSfvcVCMQWtywHGRkXMajKbUwXNephJPKxspyPidoWjoKZZhS1aiYIQtoNfT5Y72L5osbRunGJRj5gSMP0otYU2r2Opr9MMQ7xXi21FtoZHgGp1O20QWkAva+vnHd2G2XivSW0W2r/7Bg0sv8PllJqSuWpetUmcUbERRO7CSSHTKzAXiE4zwIXo0ZjGjswzd8kAnIAZKp6EB614kHILv9xAWc7F85RocGC/GKYuuO1rihSl9BPmlUvHHx6k0k4Z5QZiSADHAgyl23RLwU3eu84wZDclGx/SR0d4g6uEEiaqjEDT9zvs6sixKIDGrc54zwVGwPLyXmkqMfvfHiCZgZHHSMOd12SDEKSGIYtf/mSHDm/ojkDQT7Pt6Vjjf8XIZ6mDD3GfrsgpiBzGxuQV2NMVacLzHuB6JK/0ZWaaYfv9C1Mcx2kUc9mpYLeuiClR
 7Ph6cEJj
 DQ/8MgdRpWknHTxHQWswCCzNvBF55bttc2B35C+Dow+DMa2FW8dcH/yblQaDfe1rv9up0sKflRhaq3IivhUXhqqeqamPFde3/M6pAt2xM/DqBU1MjsmDvRVtCASLs40R8/H4fHDtX9nkysaVpTHwo+B/5iO0wcb4WMddC7Gz6eJ8hNrBsCcLfc5c0bqbfzT7mYUG8zDH4vctaLJkA1t3EnRuHbKUaxaxv93YPPefvcOIte/aD/wSS2yQH/iu4OcD7yokZI3Jgh46OIYwCSJxtaPssi1bQ+E7xesWVHKPQ6sc2ogbY3z0H158ufm5Op3f3BEWpAAfRUirWBoMF7XA7a1BpAUCUthF/5qJe35qq+nJWbZ+BlfuOoebslzDeakeOyxhf9++aTNLpsNFNT/9Upq4S7sUTvGuRqGZD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding another thought at the end of the mail without cutting the previous
unrelated questions, so that Ravi can answer all my questions at once.

On Mon,  6 Apr 2026 17:13:08 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 6 Apr 2026 12:47:56 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> 
> > On Sun, Apr 5, 2026 at 3:45 PM SeongJae Park <sj@kernel.org> wrote:
> > >
> > >
> > > Ravi, thank you for reposting this patch after the rebase.  This time sashiko
> > > was able to review this, and found good points including things that deserve
> > > another revision of this patch.
> > >
> > > Forwarding full sashiko review in a reply format with my inline comments below,
> > > for sharing details of my view and doing followup discussions via mails.  Ravi,
> > > could you please reply?
> > >
> > 
> > Thanks SJ, providing your comments on top of sashiko's review is very helpful.
> 
> I'm glad to hear that it is working for you :)
> 
> [...]
> > > > +static unsigned long damos_calc_eligible_bytes(struct damon_ctx *c,
> > > > > +           struct damos *s, int nid, unsigned long *total)
> > > > > +{
> [...]
> > > > > +                           struct folio *folio;
> > > > > +                           unsigned long folio_sz, counted;
> > > > > +
> > > > > +                           folio = damon_get_folio(PHYS_PFN(addr));
> > > >
> > > > What happens if this metric is assigned to a DAMON context configured for
> > > > virtual address space monitoring? If the context uses DAMON_OPS_VADDR,
> > > > passing a user-space virtual address to PHYS_PFN() might cause invalid
> > > > memory accesses or out-of-bounds page struct reads. Should this code
> > > > explicitly verify the operations type first?
> > >
> > > Good finding.  We intend to support only paddr ops.  But there is no guard for
> > > using this on vaddr ops configuration.  Ravi, could we add underlying ops
> > > check?  I think damon_commit_ctx() is a good place to add that.  The check
> > > could be something like below?
> > >
> > 
> > I plan to add the ops type check directly in the metric functions
> > (damos_get_node_eligible_mem_bp and its counterpart) rather than in
> > damon_commit_ctx(). The functions will return 0 early
> > if c->ops.id != DAMON_OPS_PADDR.
> > 
> > That said, if you prefer the damon_commit_ctx() validation approach to
> > reject the configuration outright, I can implement it that way instead.
> > Please let me know your preference.
> 
> I'd prefer damon_commit_ctx() validation approach since it would give users
> more clear message of the failure.
> 
> > 
> > > '''
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -1515,10 +1515,23 @@ static int damon_commit_sample_control(
> > >  int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> > >  {
> > >         int err;
> > > +       struct damos *scheme;
> > > +       struct damos_quota_goal *goal;
> > >
> > >         dst->maybe_corrupted = true;
> > >         if (!is_power_of_2(src->min_region_sz))
> > >                 return -EINVAL;
> > > +       if (src->ops.id != DAMON_OPS_PADDR) {
> > > +               damon_for_each_scheme(scheme, src) {
> > > +                       damos_for_each_quota_goal(goal, &scheme->quota) {
> > > +                               switch (goal->metric) {
> > > +                               case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> > > +                               case DAMOS_QUOTA_NODE_INELIGIBLE_MEMPBP:
> > > +                                       return -EINVAL;
> > > +                               }
> > > +                       }
> > > +               }
> > > +       }
> > >
> > >         err = damon_commit_schemes(dst, src);
> > >         if (err)
> > > '''
> [...]
> > > > > +   /* Compute ineligible ratio directly: 10000 - eligible_bp */
> > > > > +   return 10000 - mult_frac(node_eligible, 10000, total_eligible);
> > > > > +}
> > > >
> > > > Does this return value match the documented metric? The formula computes the
> > > > percentage of the system's eligible memory located on other NUMA nodes,
> > > > rather than the amount of actual ineligible (filtered out) memory residing
> > > > on the target node. Could this semantic mismatch cause confusion when
> > > > configuring quota policies?
> > >
> > > Nice catch.  The name and the documentation are confusing.  We actually
> > > confused a few times in previous revisions, and I'm again confused now.  IIUC,
> > > the current implementation is the intended and right one for the given use
> > > case, though.  If my understanding is correct, how about renaming
> > > DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP to
> > > DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_COMPLEMENT, and updating the documentation
> > > together?  Ravi, what do you think?
> > >
> > 
> > Agreed, the current name is confusing. How about
> > DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_OFFNODE?
> > 
> > The rationale is that this metric measures "eligible memory that is off
> > this node" (i.e., on other nodes).
> > 
> >  I think "offnode" conveys the physical meaning more directly than "complement".
> > That said, I'm happy to go with "complement" if you prefer.
> > both are clearer than "ineligible".
> 
> Thank you for the nice suggestion.  I like "offnode" term.  But I think having
> "node" twice on the name is not really efficient for people who print code on
> papers.  What about DAMOS_QUOTA_OFFNODE_ELIGIBLE_MEM_BP?
> 
> But...  Maybe more importantly...  Now I realize this means that
> offnode_eligible_mem_bp with target nid 0 is just same to node_eligible_mem_bp
> with target nid 1, on your test setup.  Maybe we don't really need
> offnode_eligible_mem_bp?  That is, your test setup could be like below.
> 
> '''
> For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3
> ratio:
> 
>     PUSH scheme: migrate_hot from node 0 -> node 1
>       goal: node_eligible_mem_bp, nid=1, target=3000
>       "Move hot pages from DRAM to CXL if less thatn 30% of hot data is
>        in CXL"
> 
>     PULL scheme: migrate_hot from node 1 -> node 0
>       goal: node_eligible_mem_bp, nid=0, target=7000
>       "Move hot pages from CXL to DRAM if less than 70% of hot data is
>        in DRAM"
> '''
> 
> And the schemes are more easy to read and understand for me.  This seems even
> straightforward to scale for >2 nodes.  For example, if we want hot memory
> distribution of 5:3:2 to nodes 0:1:2,
> 
> 	Two schemes for migrating hot pages out of node 0
> 	- migrate_hot from node 0 -> node 1
> 	  - goal: node_eligible_mem_bp, nid=1, target=3000
> 	- migrate_hot from node 0 -> node 2
> 	  - goal: node_eligible_mem_bp, nid=2, target=2000
> 
> 	Two schemes for migrating hot pages out of node 1
> 	- migrate_hot from node 1 -> node 0
> 	  - goal: node_eligible_mem_bp, nid=0, target=5000
> 	- migrate_hot from node 1 -> node 2
> 	  - goal: node_eligible_mem_bp, nid=2, target=2000
> 
> 	Two schemes for migrating hot pages out of node 2
> 	- migrate_hot from node 2 -> node 0
> 	  - goal: node_eligible_mem_bp, nid=0, target=5000
> 	- migrate_hot from node 2 -> node 1
> 	  - goal: node_eligible_mem_bp, nid=1, target=3000
> 
> Do you think this makes sense?  If it makes sense and works for your use case,
> what about dropping the offnode goal type?

Now I recall I suggested the offnode metric because I suggested to run a
kdamond per node.  That is, having one kdamond that monitors only node 0 and
migrate hot memory to node 1, and another kdamond that monitors only node 1 and
migrate hot memory to node 0.  And I suggested to do so because I knew it is
suboptimal to run DAMOS schemes with node filter.

We made a change [1] for making that more optimum, though.  The change is now
in mm-stable, so hopefully it will be available from 7.1-rc1.  So I believe the
single quota goal metric should work now.  Ravi, could you share what you
think?

[1] commit e1ace69c33ec ("mm/damon/core: set quota-score histogram with core filters")


Thanks,
SJ

[...]

