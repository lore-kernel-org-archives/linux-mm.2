Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147E2E7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DF46B00B2; Mon,  2 Feb 2026 12:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1856B00CE; Mon,  2 Feb 2026 12:53:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D38E6B00CF; Mon,  2 Feb 2026 12:53:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F06F6B00B2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:53:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C858116026D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:53:58 +0000 (UTC)
X-FDA: 84400264956.07.81424DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 388781C000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:53:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oX5Irr2O;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770054837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SV+cuE5PfvcUVRjTzXoXMAxt9X3O/n5AqsfylnDAOmg=;
	b=S6x6irf4+ZV542OcJ0kCu9aJJYfwmnTg9ynsaZBhjyhqqTIJKEslCMIKgYEAigmX2uZgBZ
	RCADrLuMLKvRaTaMz2nQ2Az6NX/tOLrDHL/XK6sBjtb7l7IXm8GlZRgtT6ulCxZd0YE2pm
	7Xun1Vk9nYgK0rx4a8s18gK75ohH4ac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oX5Irr2O;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770054837; a=rsa-sha256;
	cv=none;
	b=VKhkleaas0ITY/LzomVWfL/dINL2imwgreFkZl1Uqo7VB5GgpdjdrgzMCfmk98Du6ikz9b
	olsJGMPSsd3M/rK83OeiAuHlJEwHMIu2IAMJ2D9HUn96xhJrrc+zDh1OJm4GfaH1kTis6X
	B8eFsYPyKwetuQl9mzaL+bCqBxJ3HwM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9205960010;
	Mon,  2 Feb 2026 17:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005E0C116C6;
	Mon,  2 Feb 2026 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770054836;
	bh=v/GL8h8V+LemGAfnudlVdJMDIRWPzEd1NejtNk51f1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oX5Irr2ODZuZgLimb7Nnl2qf50tvPBpHr8Uv1TPjD6ggroqtqJkLfHkMewBhYFgzf
	 B5QKYrd45KdetuqdPFuvBQhSRlBGEhxUVLE1hSAuk90VFGGZ7T2GSnJipkEBGTOncs
	 DUSG4PqzRj7qzWA9Ivw61DT7wQSXYM1Dvw4j9+f/fLH6/7PAeHU2c/g3GtPG0uib3R
	 GrXf5/Jpr20tFW6hjpttuHI8KeitmaPSktuAflNEQjcyvmDgLsE0HoU03vrQcqWz6c
	 OC9Sg7NmpmSoVoZzZtv2rXhyw9pp4xSEdh2sREfKcDku5Obe+rWcS04VaQNw6MjQBB
	 elefOkOOOC5Rw==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Date: Mon,  2 Feb 2026 09:53:53 -0800
Message-ID: <20260202175354.39717-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <q4ak334ehwt4monlqqfwe7cbyxtm27qhi2isrk4ncqjixfohgw@iwclrvrjvxeb>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pekuu3egisgspizqaf9kz5j4oypnt5qw
X-Rspamd-Queue-Id: 388781C000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770054837-43705
X-HE-Meta: U2FsdGVkX1/sRCGvhqmTYOsOanVofLXRsA1C6NRZRsUCowevQG6gmjqxIwgUnGcD+1aaXcJrRw/tqOmRifZZQmvMu+BksnFXCjobAh8Ziyup/bOc3gRpJocEhZiJzz1KzxMW6uzRvJBlmjgJLc0KkeCccmcuRybK5Sb2wNQ9yJt0i1UIGOxkxDZh3ChraqR3FGwuMqm0tjuHGqfpHTBdZPA3T3WkFtSjeEAsanH7aRf2w1Z3sjsp1tst73fDjKVuAj9/4D5PT29vLoYbjrS3ve49VSBm2MVHlE0XWHZoJbovo9gT4wm/A8G7tXi0og0OuDwkbLVsyuHAxLrQCm9LZ8COj6efqwaV855qbMWrXhQysduVRjZIqwlBceQf4vGrzEjVGa/u0U6cz45uY8FBm/Zyx4cascaFCzuW5VAEQcgcWhiFVfPHs75EEmVPatpb60NO9tXVMiLGiV8Q+mGUSLdZVDYZI50EeyK5OmJcjZz+oqQqzelA1KBMAd7Vpg2ihwPqGOsM3LjSB5rm0u/7Kw9d4bt4NuafcSNO+FhXOMmuF4rrLj0Jrx28H0JlO3Cvxi5hZx4LfFsMMwPtYwXyr1LS2yE5mHhDa/aq/04V5G/3pRoVbozCNb0eXB8M5bCg417KusFkModT/4VTq0L93IyZAOeoSaAOFZpzfpQMvaumGMLkIqDIwRCqs0Rk315H6ZTlL3XWpzMMB/CNwwJSbY0/k4UxJHHwfICa8KAFjO1N81yAe2baTEnCVgp57qQ8zfoeQhaeaMWqTbC9CfLt3b8PNEvB7z0f5GogRCIbz1u0Rg5juhJwuwVyNkox1K75hn1mDlBxHLxL8VReodUihJ25bR060JGtI+Jln/96qEBrK2GkYt7AbM0fgylAOLCx89LhUryUIcA/r2/9mC9zxyfxVUbOkYZqdYDJGYSvKByb4Xjx7yuz6ypHH0oe3OXHnOi1n1csETo0N1MSS9m
 qHu310k/
 pgaElyRm7TAbUhmvZZCTgIBx3PDfqSY8uR/89oWa7a4ZE019uF1ZI/FDC0FHAU0lKxtSWYyKUfTMrl2YGtKndWZz3lLZ3IHSLvotMnv8/zoQS8FaJJuQBZtl1fKhEIjOkE0U2sIqsMG0abLiHt0z/dFQ9uHPPCFoa3w9XVPztNYPI/HZJfV4gIpqyP4oBo9tTGTOzvQD+arBAEKBq3lg746bZ1KHaXe603SVKY5E+6N960iCejWQ7tgi1AdKYb96GMTH9CtfyX1L5Tr0tK/mH8c7ZPh7rI8F1sFE76PXTDrwOZqSXvU1dkyERbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Feb 2026 12:01:53 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> * SeongJae Park <sj@kernel.org> [260202 10:56]:
> > On Mon, 2 Feb 2026 09:58:31 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> > 
> > > * SeongJae Park <sj@kernel.org> [260131 19:10]:
> > > > Hello,
> > > > 
> > > > On Fri, 30 Jan 2026 15:59:26 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> > > > 
> > > > > Add a helper to do what is needed when the maple copy node contains a
> > > > > new root node.  This is useful for future commits and is
> > > > > self-documenting code.
> > > > > 
> > > > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > > > ---
> > > > >  lib/maple_tree.c | 70 ++++++++++++++++++++++++++----------------------
> > > > >  1 file changed, 38 insertions(+), 32 deletions(-)
> > > > > 
> > > > > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > > > > index 5280fa6d2d6ec..42038e42a4c7e 100644
> > > > > --- a/lib/maple_tree.c
> > > > > +++ b/lib/maple_tree.c
> > > > > @@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
> > > > >  	mas_spanning_rebalance_loop(mas, mast, count);
> > > > >  }
> > > > >  
> > > > > +static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
> > > > > +{
> > > > > +	if (cp->min || cp->max != ULONG_MAX)
> > > > > +		return false;
> > > > > +
> > > > > +	if (cp->d_count != 1) {
> > > > > +		enum maple_type mt = maple_arange_64;
> > > > > +
> > > > > +		if (!mt_is_alloc(mas->tree))
> > > > > +			mt = maple_range_64;
> > > > > +
> > > > > +		cp->data = cp->d_count;
> > > > > +		cp->s_count = 0;
> > > > > +		dst_setup(cp, mas, mt);
> > > > > +		init_cp_src(cp);
> > > > > +		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
> > > > > +			  cp->dst[0].node, 0, mt);
> > > > > +		node_finalise(cp->dst[0].node, mt, cp->end + 1);
> > > > > +		/*
> > > > > +		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
> > > > > +		 * documentation.  Since this is a new root, there are no
> > > > > +		 * read-side operations that can view it until it is insert into
> > > > > +		 * the tree after an rcu_assign_pointer() call.
> > > > > +		 */
> > > > > +		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
> > > > 
> > > > I just found the above makes my build test using an old version compiler fails.
> > > > Fortunately, seems it is same to the one we discussed before [1], and same
> > > > mitigation like below attached patch works, at least for my test setup.
> > > 
> > > Thanks SJ.
> > 
> > My pleasure :)
> > 
> > > 
> > > This is still with gcc 8.1.0?
> > 
> > Yes.  The test code is available at GitHub [1].
> > 
> > Nonetheless, another test [2] that is using 9.3.0 was also failing.
> 
> You have two failures: one in 8.1 and one in 9.3?

Yes.  FYI, I picked the compiler versions for no good reason but just because
there were reports of DAMON build failures on the compilers in the past.

> 
> I was planning to test 7.5.0 and ensure everything works, but this
> implies my plan will not catch everything?

From Documentation/process/changes.rst, I find minimal version of GCC for
building kernel is 8.1.  So gcc 7.5.0 might not need to be ensured for?

I have no good expertise on planning tests, though.


Thanks,
SJ

[...]

