Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39610FB5175
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 00:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45BD46B0088; Mon,  6 Apr 2026 20:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D0A6B008A; Mon,  6 Apr 2026 20:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F536B0088; Mon,  6 Apr 2026 20:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22DB36B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 20:13:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B432AC1989
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:13:21 +0000 (UTC)
X-FDA: 84629835402.19.9BA30A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25F3140008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 00:13:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tm6l9d4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775520800; a=rsa-sha256;
	cv=none;
	b=iieBEDmlTKjEP+4qXfFEzfNkwz/IlG470s1hKhJKXZaO7G257tvrY9Ncz1wTz7ii7neUgN
	0vVHRyq76KTAYifcdfpLAXHmnBEE1dRRKMFWYWCFJvmMpm5o7ntUaPVrYekqIHRJTaY1Sy
	rj9OpZRdJ+VPqeLs54LSuWDW/KoBcYY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tm6l9d4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775520800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImYGZ6WecvsypPfqZwwqPSiIea0UuId3hjh7/1Av+yc=;
	b=XK5fH6SuCanjYnkHm68qy/0/fWvM32A9LrvyloZ6brFf1hfz1K1XzPjHNutHixOQPjpV3K
	AiMDUoOukInQIz1M01Yk2Vq3ZzvlfGWofMUOP/KwKRjv1mrsISkXLgkRjSC1/4qgsr2E37
	EjsHspPto4gJTb/v3Ast1RFEHSnRGao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 31A1B60180;
	Tue,  7 Apr 2026 00:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68043C4CEF7;
	Tue,  7 Apr 2026 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775520798;
	bh=BGK91Zud1kj/tvt7oieAdbvvJZc26dEc8R4BMeClsPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tm6l9d4jQGiEtsxOMCMp//3292RFdMDB9vsyy6kw4WZSXcXUtHVOWBnL8S6YHCyh0
	 vW/zwlr/O/+PpP2TNA/v6zkE8Zl5TwoTpy1q4zJ4dZVcNyeVdAVI2CC/nfvCEh1JBg
	 MME4m0eAbWKFMzapwCXTk+fvMtRbhTYPCwzh3Uk+S395vQnLRybEZ689TYeSAgOT2W
	 X0JHiM+PFMIAc4E+JUkzmWwKSz2upRMgSrtxKFHTab8qyyU/zBdgif44TAihuFJHFD
	 Ofg7ChEtq4Fnq0SLQ5FBs5C9qMUzxsSzTNPNpnuFFpRs1z39tZcofKb19K/xh08Ttl
	 dDeuk3T4oQzpw==
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
Subject: Re: (sashiko review) [PATCH v6 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Mon,  6 Apr 2026 17:13:08 -0700
Message-ID: <20260407001310.78557-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y14oWqu5+DbkENy7GgBjc=dCbFTaoOCr1i4=9CN-ZNRgEA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i88i5fownoadbgtkfb4aefcqhzegwneo
X-Rspamd-Queue-Id: 25F3140008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775520800-624083
X-HE-Meta: U2FsdGVkX1/x1Ys/F7cUwMqxSX5TBOL4ohuVYXN4MtsbBbIzNcKQ7sQE8ehbDBMoLZjqxDG1B80VDwCsanboTGw7awkKNbW+ZWno6fWAsiFRT/SHpwI35i9mnhoGB5MJxLdGT8opZAZbITpsLq4khG02dnKHtJGwgaKPe2tD7Y0zwplfQnhB56jNxQXAjxj45yFvMDwJ8qTCwBlAHfLH9Ixg1InsBRbgPVe8BJt0kn+3tuGKih6JofXq9UThxRrxjEwzI8wKJNc/ETE7vvZoV4S+6aqI+RMFH5/BMZNurLH1lliK9zCZuUGTpjJfVTMXQTjd2Sztl7RAV7/SGc6/EPVX4oJPcKsAabg52HD3csjrqQKOe/kWh+cOmVvd6wzdtsZ6Yrem4zIeZx7p1y20zIfQa03Re8sK5tBP0X17TPljgMrzQhwLNxCIX/oOUfA6jJBGRk171vBYjCmks3D57uk4wj87N6/v6EooP3lEItC8iH2XHxzAt6lesGppPA/s1LfuDNI16/7t+mgZ00OM7H1uAWIHiKWvvMqgAcWfofnnsCs6hh2So0vp07CQvF9IThHI5be7+SKCkE68aJJhImLADZhNPlWTTBHi227bo6Kzxn93tm5YriTwJNg8kJUAC5vgxasuNG7RDb4/iPsIa3L/yfzonM4Lup2murkQb+kdm6MguaTpAaG86QCrNixQZI5DJi47ZCV0FZ89gzcQ3wICFQCeSN9RcQk9QAgqQBBpS0DcCnvNzZV8GpKw+y8XJua30sYXSqq/kfL7aHf5jiRr+biOQJsVf4F1IxdNUo5OuX6gwUCX8v7PBePPwVtBmUu9vc4WWzk6Z+3McTLEsDcbzDlo8GAWRKUYtJz3raLNQGMXu5o5ndFy2BwpdPsAK6tpoHWOupsGnsB9kwfzIl1534vnb1KnQHm+nKyvpA/J+iC7ZDqmroOaFrr9jtxwpxXD7OvJ81+y8hJ1vR2
 h0ZshKhf
 FBbmSRxB2HHyieR52BZqx3e6I27i7QiqTU+Dbqlv8telS819iXrHw4lNfIpcOZ4a7op+ztT9Pkcy/DWIaYc/7VX0Bt5lm4GiprGWz5tio2WhfEafNO/PND/4uUeNLlbkks+mnzpmzeOKew2lnzGFFmAzMw9DFhzcPGBNnva+QebyEnbr/DZNTTMa53Cgwn8Z2jjpJmTOH1+bxORzaomqsEScyK1YibW7N123pHlbYNW71WjZYC1f8UKu9SY8PvLH/+BpYbHe1FPhu00iUIybyU/R9Kk9wGr/8JHMwrBPYQsCr+imuKDCGCRxcbloOB05YyslhzFLI61SBBfnAlLkNih38V6rmuESkh3foCI/IRsF28mhb5VOv/4Hc15NxuK5zpoLLSilwMX4c9Gwx6Wq5qvHcKbcI+fs3/2PX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Apr 2026 12:47:56 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sun, Apr 5, 2026 at 3:45 PM SeongJae Park <sj@kernel.org> wrote:
> >
> >
> > Ravi, thank you for reposting this patch after the rebase.  This time sashiko
> > was able to review this, and found good points including things that deserve
> > another revision of this patch.
> >
> > Forwarding full sashiko review in a reply format with my inline comments below,
> > for sharing details of my view and doing followup discussions via mails.  Ravi,
> > could you please reply?
> >
> 
> Thanks SJ, providing your comments on top of sashiko's review is very helpful.

I'm glad to hear that it is working for you :)

[...]
> > > +static unsigned long damos_calc_eligible_bytes(struct damon_ctx *c,
> > > > +           struct damos *s, int nid, unsigned long *total)
> > > > +{
[...]
> > > > +                           struct folio *folio;
> > > > +                           unsigned long folio_sz, counted;
> > > > +
> > > > +                           folio = damon_get_folio(PHYS_PFN(addr));
> > >
> > > What happens if this metric is assigned to a DAMON context configured for
> > > virtual address space monitoring? If the context uses DAMON_OPS_VADDR,
> > > passing a user-space virtual address to PHYS_PFN() might cause invalid
> > > memory accesses or out-of-bounds page struct reads. Should this code
> > > explicitly verify the operations type first?
> >
> > Good finding.  We intend to support only paddr ops.  But there is no guard for
> > using this on vaddr ops configuration.  Ravi, could we add underlying ops
> > check?  I think damon_commit_ctx() is a good place to add that.  The check
> > could be something like below?
> >
> 
> I plan to add the ops type check directly in the metric functions
> (damos_get_node_eligible_mem_bp and its counterpart) rather than in
> damon_commit_ctx(). The functions will return 0 early
> if c->ops.id != DAMON_OPS_PADDR.
> 
> That said, if you prefer the damon_commit_ctx() validation approach to
> reject the configuration outright, I can implement it that way instead.
> Please let me know your preference.

I'd prefer damon_commit_ctx() validation approach since it would give users
more clear message of the failure.

> 
> > '''
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -1515,10 +1515,23 @@ static int damon_commit_sample_control(
> >  int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
> >  {
> >         int err;
> > +       struct damos *scheme;
> > +       struct damos_quota_goal *goal;
> >
> >         dst->maybe_corrupted = true;
> >         if (!is_power_of_2(src->min_region_sz))
> >                 return -EINVAL;
> > +       if (src->ops.id != DAMON_OPS_PADDR) {
> > +               damon_for_each_scheme(scheme, src) {
> > +                       damos_for_each_quota_goal(goal, &scheme->quota) {
> > +                               switch (goal->metric) {
> > +                               case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> > +                               case DAMOS_QUOTA_NODE_INELIGIBLE_MEMPBP:
> > +                                       return -EINVAL;
> > +                               }
> > +                       }
> > +               }
> > +       }
> >
> >         err = damon_commit_schemes(dst, src);
> >         if (err)
> > '''
[...]
> > > > +   /* Compute ineligible ratio directly: 10000 - eligible_bp */
> > > > +   return 10000 - mult_frac(node_eligible, 10000, total_eligible);
> > > > +}
> > >
> > > Does this return value match the documented metric? The formula computes the
> > > percentage of the system's eligible memory located on other NUMA nodes,
> > > rather than the amount of actual ineligible (filtered out) memory residing
> > > on the target node. Could this semantic mismatch cause confusion when
> > > configuring quota policies?
> >
> > Nice catch.  The name and the documentation are confusing.  We actually
> > confused a few times in previous revisions, and I'm again confused now.  IIUC,
> > the current implementation is the intended and right one for the given use
> > case, though.  If my understanding is correct, how about renaming
> > DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP to
> > DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_COMPLEMENT, and updating the documentation
> > together?  Ravi, what do you think?
> >
> 
> Agreed, the current name is confusing. How about
> DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP_OFFNODE?
> 
> The rationale is that this metric measures "eligible memory that is off
> this node" (i.e., on other nodes).
> 
>  I think "offnode" conveys the physical meaning more directly than "complement".
> That said, I'm happy to go with "complement" if you prefer.
> both are clearer than "ineligible".

Thank you for the nice suggestion.  I like "offnode" term.  But I think having
"node" twice on the name is not really efficient for people who print code on
papers.  What about DAMOS_QUOTA_OFFNODE_ELIGIBLE_MEM_BP?

But...  Maybe more importantly...  Now I realize this means that
offnode_eligible_mem_bp with target nid 0 is just same to node_eligible_mem_bp
with target nid 1, on your test setup.  Maybe we don't really need
offnode_eligible_mem_bp?  That is, your test setup could be like below.

'''
For maintaining hot memory on DRAM (node 0) and CXL (node 1) in a 7:3
ratio:

    PUSH scheme: migrate_hot from node 0 -> node 1
      goal: node_eligible_mem_bp, nid=1, target=3000
      "Move hot pages from DRAM to CXL if less thatn 30% of hot data is
       in CXL"

    PULL scheme: migrate_hot from node 1 -> node 0
      goal: node_eligible_mem_bp, nid=0, target=7000
      "Move hot pages from CXL to DRAM if less than 70% of hot data is
       in DRAM"
'''

And the schemes are more easy to read and understand for me.  This seems even
straightforward to scale for >2 nodes.  For example, if we want hot memory
distribution of 5:3:2 to nodes 0:1:2,

	Two schemes for migrating hot pages out of node 0
	- migrate_hot from node 0 -> node 1
	  - goal: node_eligible_mem_bp, nid=1, target=3000
	- migrate_hot from node 0 -> node 2
	  - goal: node_eligible_mem_bp, nid=2, target=2000

	Two schemes for migrating hot pages out of node 1
	- migrate_hot from node 1 -> node 0
	  - goal: node_eligible_mem_bp, nid=0, target=5000
	- migrate_hot from node 1 -> node 2
	  - goal: node_eligible_mem_bp, nid=2, target=2000

	Two schemes for migrating hot pages out of node 2
	- migrate_hot from node 2 -> node 0
	  - goal: node_eligible_mem_bp, nid=0, target=5000
	- migrate_hot from node 2 -> node 1
	  - goal: node_eligible_mem_bp, nid=1, target=3000

Do you think this makes sense?  If it makes sense and works for your use case,
what about dropping the offnode goal type?


Thanks,
SJ

[...]

