Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01ECF54AB8
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA926B0005; Tue, 24 Mar 2026 10:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27AFD6B0089; Tue, 24 Mar 2026 10:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18EA26B008A; Tue, 24 Mar 2026 10:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 059546B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F7AABF891
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:00:26 +0000 (UTC)
X-FDA: 84581116452.06.D416CBC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2EA3E80026
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:00:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="kFyY/uY1";
	spf=none (imf30.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774360824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYpp2zd5bcLpLRUxBdcr0PV/kjzDh6+TBXbgdTt5jQI=;
	b=VqLhVTStedHGrU6kWJPLF5VN2C91Vn/ExtxFWMCVWSvli3Ay2PshDaXoVH7h5E7eWEze+f
	UIJkkInYk3+BNS73BcqY66bwRi/OGFQtHITwxH4NxD3LfkIyMjyLeZs9aciZIBzdTJJUsP
	OxHYKVEDrSDW1D70fPi8jL8OqKk3ys4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="kFyY/uY1";
	spf=none (imf30.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774360824; a=rsa-sha256;
	cv=none;
	b=U9U1H8pWgD/m7VOoY3AIOe7pSQ4X+kuBp67xvzFL7htxrC62qTlgxgsnPZmAjFW9QoMBZv
	4rD2bDQaNM88ep+/o3vLVW21I+7Vq4iZP05z7TrYhRZL9vx550FAaeubCLgcienP6qAqoK
	/tBxGhR5oKR/9EqIOCuf+E23deFddvg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vYpp2zd5bcLpLRUxBdcr0PV/kjzDh6+TBXbgdTt5jQI=; b=kFyY/uY158fZq2yziSCwUz8cGR
	JR31T9nU/ZTUO7vPnLar/NCR8LsfKJArPicR8AjDdfzEdn/6b5DkBQ4ee9DXr+ZIRQoSDgaC92U37
	E1jZleAqjCOwSLAckrOmK5vFtaKio9eOEQ7V91XBn6a/z90SZtAyoy65nYc9RSQBecpxezUmtXJqJ
	RH6+lWQmq0po1ZrWWXt8wdpX9MD4rv4x1n077CeK0ixMoQPfwUY54i2uYr1vg+tDMjI/pEIvj2KhT
	RaumJ9FJjmZ8L5jB17PLuv7zslB+pGZlOzV3mkpKO8aASdPyf1zLUh9Q95SOTV2yz+ZjtXT//Qvfo
	NzIYGZvQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w52Iv-0000000E7T4-23HU;
	Tue, 24 Mar 2026 14:00:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C1BF53002D8; Tue, 24 Mar 2026 15:00:19 +0100 (CET)
Date: Tue, 24 Mar 2026 15:00:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hillenbrand <david@kernel.org>,
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a4vyihlx.ffs@tglx>
X-Rspamd-Queue-Id: 2EA3E80026
X-Stat-Signature: afb35ffr38phap7nrxkdmcqskqafh5g9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774360823-964179
X-HE-Meta: U2FsdGVkX19A5AOqZ79iqDet8ufL06GNw7dEvx4NOkR0Zun17g0vicoldhva83DD5Hjy1gj6gHybrQPsu5DLiyjrwl0izULPPFRrSvWdEIjzTry9pXxABhBT+uDtSfhmEmilzFflPujZqfwtxrIdmdrGf3qeqJGgvRNBKCtUWkX0FsTSqLTHienfCstPABvn40agF2gyc0MT4LgflOZ2oqZdxZhd13NxT5BrHJ6i5n+VRA4dffgTcUUcUm2td8J2Y3c+49t5YgmSLTt3b/AhFDvuGjyIezDY5nrMGdoLnVCP+RelqHQ8P+QRBzOhQJ9zDk/PT0NAUvaw9W3YAPVm/gvu9ehxYpvnGRuZDMzN/v4T++DgFU0sbttfpB/2dSO/ipF4raXA9MWrN2eHijVDf4m4mMXL74Z9YIil4GokODPXn4AdE8NCaoPfv+K5mccQCDiX//0kvbcGmQMOZmOMC8snZXHOP9qDOjAo37UHltLdNuXkjKrvCCkviRRFWuLfJXeEpJI7scepY5/bsKTRfaa1G6evvIl2kgN8SVJqavAWdsJd1+wT2QxAOBCXPdQ2JSar7Tu76+o8JLvqnsKLNFCc3U2pYSb8/FnvvCVcV3RvdaBlZmeHVnNItnBdG3CSSyVF2KhfJV/LMLkqGxni/GDMDeXTz+kWdvdAxr2VK5clEedeThHXuxFtESixtnADmImDXDtjrtYJ03QRp9ac4AYAnhmrKseEE3ItDWKeCovz4kDaPOLeH3jbprrcpgvz28K1RgX2g40sZO7ZunP8JTFKrCUVF2PjCDRU9c4wstUG+cP4irDlIO8p9DT0xyx6TepGsyjM4P9lZtgXSDPcUKj6+NPGZRjeinFwGDb9AIJ4MQYyiUhubv+9e5IC6t0X7Pqfq+5GSouUZqRTbNxP+/fZGTQJo4X615dXSahxykK7Po+F0U1g0k/uBhSh1Qxm+tdc0u1qfvVTTG/DuE1
 fA9Sx6OP
 KxhAbUTGfrey3mPpoXqVTZ5rv+hCkfm9hrY0vlqnF4wNCkE14KWYGY7tewHwGieiAQUkGjhMqXOc34jC2MOmYNPcWGvUoA5AvjaxzZFAsxPLNG7y+rs5+hvfxSxQuwUG36P4gGcFbkLlC9NyBtdtuz6q87uSJnT6O7L5n6Kkx0QUrOJJhmVLtkv2XK7CoQhacw/m/z0PtJ6ORevvwhlMpDOuYRvbM+PbPOh1QItfSt8LJpcv4vO4+a84tjcCKI5zEXXMQkSX4wE9nmM4TJpga6270REFbxBP66Z8aEEzCQlzmu6m2PsFJcfJgdegMR7gp/TK8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 06:24:42PM +0100, Thomas Gleixner wrote:

> >  include/linux/mempolicy.h | 1 +
> >  mm/mempolicy.c            | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> > index 0fe96f3ab3ef..65c732d440d2 100644
> > --- a/include/linux/mempolicy.h
> > +++ b/include/linux/mempolicy.h
> > @@ -55,6 +55,7 @@ struct mempolicy {
> >  		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
> >  		nodemask_t user_nodemask;	/* nodemask passed by user */
> >  	} w;
> > +	struct rcu_head rcu;
> >  };
> >  
> >  /*
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 0e5175f1c767..6dc61a3d4a32 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -487,7 +487,7 @@ void __mpol_put(struct mempolicy *pol)
> >  {
> >  	if (!atomic_dec_and_test(&pol->refcnt))
> >  		return;
> > -	kmem_cache_free(policy_cache, pol);
> > +	kfree_rcu(pol, rcu);
> >  }
> >  EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
> 
> While this looks functionally correct it is incomplete in terms of RCU.
> 
> The vma->vm_policy pointer needs to be marked __rcu. That then requires
> to use rcu_dereference_check() at the reader side and
> rcu_assign_pointer() and rcu_replace_pointer() on the writer side.

I hate that sparse annotation; it mostly just makes the code unreadable
for then requiring those unwieldy rcu helper functions.

Not to mention we don't actually need any of that here, because:

> Especially the writer side is required so that the proper memory
> barriers are inserted for architectures with a weakly ordered memory
> model.

The vma->vm_policy thing is written under mmap_lock held for writing,
and the futex consumer is a speculative read lock. Specifically the
ordering is through the associated seqcount.

All that is really needed is to extend the lifetime of the mpol to the
associated RCU period. Which is exactly what this patch does.

Want me to go write up a better Changelog?

