Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F0E5C79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D40C6B008C; Fri,  4 Sep 2026 07:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2006B0092; Fri,  4 Sep 2026 07:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3146B0095; Fri,  4 Sep 2026 07:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34E3F6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:57:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0481161000
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:57:32 +0000 (UTC)
X-FDA: 85175929944.27.0DC36F8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 97C984000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:57:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fjrLqvhC;
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788523050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPg2Y8Ab9TMf2vxyVV/kS7aQIsnoV2gfrzkwQRvEWzQ=;
	b=N20aKcafIGHIYuGOzt6MoJgLYjK0I5dpykP+T5X5neOuzTR64IePLCBwD0c07PtB0fa7Hs
	zVHvyxmUwZJTj6a3ZaknnD81miWM7anSDSvSwB2l2Z3XXQQmH9/VF3kTWo5/863E/6VtbV
	mzNadm6FawOVMijjUNOjRtm1FF7AWTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788523050;
	b=3GPDjpgB9FwnclnH0WZGLd6hFgs2Q9mvS7/nc4W41mGJN4dE3YLNAtci098+Hg13Mg2AAv
	b5eccH66WQLm0gihL/1B2DRudaQaTlVHX2YavgnT1cnaY4erTeR3y/ZgfPVfc15vDovzgx
	dHNPS16IOkf8JYBEF1WBGdoxFPAXshc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fjrLqvhC;
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788523050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CPg2Y8Ab9TMf2vxyVV/kS7aQIsnoV2gfrzkwQRvEWzQ=;
	b=fjrLqvhCTDxQBASXdykGwtkEn8mVn+Y2si32t0/UkaB6xWcJUwhijvXZUrsCIpgRaEKuSL
	1CBCEj+OK+VEJCfUg2bhrte31qxsoETC/hFXoPgId2nFjjefg4OvhHqs9g2umIc0pErlaR
	7VbDiFJNTOAuwPTv0tkt+ZkHetpGZh0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-LjJgyifANwiag7sKBhjNow-1; Fri,
 04 Sep 2026 07:57:24 -0400
X-MC-Unique: LjJgyifANwiag7sKBhjNow-1
X-Mimecast-MFC-AGG-ID: LjJgyifANwiag7sKBhjNow_1788523041
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C78BA195DE0B;
	Fri,  4 Sep 2026 11:57:20 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A50B5BC;
	Fri,  4 Sep 2026 11:57:17 +0000 (UTC)
Date: Fri, 4 Sep 2026 07:57:15 -0400
From: Brian Foster <bfoster@redhat.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <apqyG_d6jEUqcMN-@bfoster>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <apl7hNnt0lR5HFXA@bfoster>
 <62729d59-198d-4ed2-b1e1-b18384e73b98@huawei.com>
MIME-Version: 1.0
In-Reply-To: <62729d59-198d-4ed2-b1e1-b18384e73b98@huawei.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: M50KDj3jLgfybhFb08Xsbw0dvlG39k6CIXCHUoHIRJM_1788523041
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97C984000B
X-Stat-Signature: 1rg8ifydjnstmcqighf3fzi1opi75wro
X-HE-Tag: 1788523050-403370
X-HE-Meta: U2FsdGVkX1+G4XmO2Di2LFvtEKShL75Q8oYSs8NS/4BLTKu3f3F4Z7AU2ugXEV48GDvISAkhUeaOCTNLf29kLGhtsr2gtCypsu90c/HvJXVtKPX5jErs66tfD0hJAnmqIUt5IQSiQMTZa2+1Xgbi0dq7o/koTUqbfCoe/dV0MXZ86PNJMEusPJdvpKknZNMDYbNPa0DrfNX3vxqEzS2GU7y6qHlXI4OH81QmHzcxyq3MgVksL9Np2U6LxVYAix1x/gvHh4CwxKlSFiPZjJ2O4csrRI6Ax5tK+m5SsBiaNGqTKj43+FXTrRHctdRVOwaf1uFWoSfjPLca5k9s/MSjRhZHXRSiqds69CHkNA8T3+Yrugg9UXNT35QJOVV5KZJimPYbaddjRpBxY/VyOxu52wpjQk6Qsz4ZYRpB9aV3suLDaDDpXazYa5CfEjCKYm7QIpgrpQSw5DJnTtjrw6q/C0XtEiLi1tUF08mYlam+gbTMnQPyQQeuL1D+66iQnwgsSfVRNhT7uYR35buRCRp0FwZm3eYiVCTwWJokCjyPzC3ota7EUk/0MyVzy2plry1U9QcrDTyZWC6b1QIB5HP6hcDcy03jciIP8L7q6VhrdXWo1sxKuXzLK0T00Ym6w7FJVKYWQ/pxTZcc8lyIVdoYVQ1nxQgVNaiZvyv9AZjGVMUd775EIjN27t1L2scswMIABA38vFh8Kr7JbYvK8Q2zYnv9g8H51JkVsMLq8E1EEizHqpyzVb/YsucDQYGWKoaerl1FfyqLRM6CIyrhWhG0ub1NVDIh94IQDx7W1br6UbU2B5x1PGJNGb8DK2xZzIyhxbaPTXB6X5eC3bISGdU8LZGZYLmrOaguHyWrLkMcVCnSuLxNL01VQpVqUwM9aoVZpKGUWgvJJUg3K/giZ6rltkM9cjQbJqS8NMWLKLSRlaWBRq4oLTHfR1Ph8qQHU168lQKvg2m4+5FYybyd3r6
 ISGSPrkH
 ig1A7+3sre2zhvDYxJ5Lh7cWPWQRo0UWj/bzlmgSdJgf4sCjZ9G6SgV56QENev/WTqAyeddjTY8LJkfQh13csrphZVKunk0zDM3rR4+yzD/ndtjSKBsm7vw3k7UhMPO+AIx3O5aVdBhbK2WhHJTb+2NbDPTN+8qrzC9Q/Ji/RNtH4G/+fbmawaJngXwg8+JjHaxYRlich7vx+Aud1INvcnzOiqfVWMG4AcXGWKh3ho0OjXVHw+F8NjgTS5BvVWDd1NjHuFa/lzMZHRQ+1h/xLmMz9uJEj6a1ghqvQ4C/zZ9u55F6aD+97KL+F8bhdxwV9kOqd+gwSSSOURc7imGHMa2K9Anz4vQtAnecQg34FcIv9cYB2m0tSw1va4I4OABiOdzLk4fqo9P97vrM7MgielTLlfBxswhPAyIlLUdzJ32qQ6RvqPx+JEf5IZ4Qlt2MSZKslk6IlkZyWXFNdEs9xh1uIqcuEVb6WlKc6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 08:41:26AM +0800, Kefeng Wang wrote:
> 
> 
> On 9/3/2026 9:52 PM, Brian Foster wrote:
> > On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> > > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > > xfs_trans_clear_context() on the caller's transaction, overwriting
> > > tp->t_pflags with the worker's NOFS state. When the caller already has
> > > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > > the caller's NOFS protection.
> > > 
> > > Use memalloc_nofs_save/restore with a local variable instead so
> > > tp->t_pflags is never touched.
> > > 
> > > Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
> > > Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
> > > Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> > > ---
> > 
> > I agree that the Sashiko analysis looks correct. The only thing I wonder
> > is whether it might be a bit cleaner to have the set_context() helper
> > return the context instead of hardcode the assignment to ->t_pflags so
> > it can be used in both places. The reasoning is just that the current
> > arrangement kind of makes it easy to repeat this mistake in the future.
> > 
> > Then again, it's a single line helper so maybe another option could be
> > to just remove and open code it. I suppose the pro of keeping the helper
> > is that it's a decent spot to document the concern and why it returns a
> > value, etc. *shrug* Thoughts?
> 
> 
> I personally tend to remove the helper functions, but let's see what others
> think.
> 

I noticed after writing this that there were many more open coded nofs
calls than I originally thought, so this is a fair point. After some
thought I think this is a reasonable approach regardless:

Reviewed-by: Brian Foster <bfoster@redhat.com>

You might want to send as a standalone patch though..

Brian

> > 
> > (Please don't change this patch just on my comments alone. Let's see if
> > others have input first..).
> > 
> > Brian
> > 
> > >   fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
> > >   1 file changed, 8 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index 6738d9d1511b..8ae4b94e6995 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > @@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
> > >   {
> > >   	struct xfs_btree_split_args	*args = container_of(work,
> > >   						struct xfs_btree_split_args, work);
> > > -	xfs_trans_set_context(args->cur->bc_tp);
> > > +	unsigned int			nofs_flags;
> > > +
> > > +	/*
> > > +	 * Don't use xfs_trans_set_context() here: it would overwrite the
> > > +	 * caller's saved NOFS state in tp->t_pflags.  Use a local scope.
> > > +	 */
> > > +	nofs_flags = memalloc_nofs_save();
> > >   	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
> > >   					 args->key, args->curp, args->stat);
> > > -	xfs_trans_clear_context(args->cur->bc_tp);
> > > +	memalloc_nofs_restore(nofs_flags);
> > >   	/*
> > >   	 * Do not access args after complete() has run here. We don't own args
> > > -- 
> > > 2.55.0
> > > 
> > > 
> > 
> > 
> 


