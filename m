Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1FC3CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BA26B0088; Fri, 16 Oct 2026 10:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13576B008A; Fri, 16 Oct 2026 10:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FDB6B0095; Fri, 16 Oct 2026 10:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7414D6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:29:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02CA6404EE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:29:31 +0000 (UTC)
X-FDA: 85328722584.04.FB032D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6291B80012
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:29:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q65In81g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792160970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HSzrUk8F8TN6B6+DOgVOUSWwHPV0RhSwS1OfeQB0K0=;
	b=Q3oR+sEvr36i2coF9G5cFquMc6C8PZM5Eio4c4jIkXFiLvki7ysQpvn1cnTc31g7F5TiaD
	JpJkfCZg8gDngWFhUheWWjg6I07w8vPhRTEVqaRg+3g8dNjfcY6h4y6OOSd4ql5Et8v9md
	ERXdc4wOcQ6v1E3rkq9SpCevIMb6peI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q65In81g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792160970;
	b=65LZKfar4lq4xKhQ3eC36CerJfMbZf7pIMxCHixanF65or1y8LC/OieXB9zkbdBgb42VIX
	3pIbl5o8ZEaxQgjt5VoNYCWOfAx9ez+1NTWZCO6y6ZlGf7+ttJFS9wYE+5CAqDpXmqNtrA
	2y/S/LNPXjWZNUlADTp2DHbsa38+rqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA67360008;
	Fri, 16 Oct 2026 14:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62371F000C4;
	Fri, 16 Oct 2026 14:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792160969;
	bh=5HSzrUk8F8TN6B6+DOgVOUSWwHPV0RhSwS1OfeQB0K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q65In81gZDrVrtW5aeohcJVJLJobQ9C8yQuS2wcMlNBqD1FSgQ5ZjZswj5VFjEIhV
	 Uj3NJt5OF30kEGcVXt3+OijWD8/DJBwmwsVbLwDKW2TF8NWbmYfIBEKbj2O7sejVvG
	 +RSSLoAh3RIWYDA7pX6RCZ53f38uknskqpEXSpGwbaojB979hqlX4WK1wHRTxDeUjl
	 fCkunetpfr9SnSdoWyXIUOzbMYjOtJCc8R2NDlPyY2OOn8tBJwwHR+YgK8IZBflwOS
	 yHACdqKGG/K2PLFWfm9XS3S4Anf7UblSAKrhhiULhHwKm2lUEGosBhMHe5l3FqY53c
	 iJC2HQzQ0cVqA==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
Date: Fri, 16 Oct 2026 07:29:21 -0700
Message-ID: <20261016142921.126622-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179215409165.864368.11903228864381211337.b4-reply@b4>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bczx4zd35a5ugq5fnxjzma7wzba35odr
X-Rspam-User: 
X-Rspamd-Queue-Id: 6291B80012
X-Rspamd-Server: rspam08
X-HE-Tag: 1792160970-567623
X-HE-Meta: U2FsdGVkX19YCI8HGByse0kFGpP4uznZoGkNFM21/TjKHzst/Tpiryra9VD5FEHk5avhzMq3dK4V/F+EagpVINaU59elbDufzlfIl/6QadaIqLQ5fHB89sLN9KGFIOK0/T5EA2xT+pUqI0f7Uj89OQS6MHn+cqSrDv3LuAgJdmyGbixj9Va+Z7FMChVVy/3T3+FDBzYfwpclnjhhLQXegIr1IiA1F/k+DOXs8WueSUrugI8CNGZrCjAdCq2AK3SwJdZgPejrrEbSaOdC+NuDZlXuKVkw4NjQuVJOB384OdFptErpmVtgVhHWiWpcI/u/rbR1xytYT9cbTVUJn8wEozrgZkQO2Bh33D2XZP+mCiJCfNg8vwBrCPp0DgWqivFZ9ovtgRAqmiD+tNZ6YMmgPeWNcTxXCoJFgkDDSH4O/mEA3RMRfKi/r9lw/indM1O/MkYEsgOZ0gWB8XpURhMcabsP0sUVSgPr+Zis5i+93fRYXKmB9haiWYbTinJlDVsCf7SzkuDdCZPYzedS5nN2G1KgYo29wFiUmJST9+38m26+8IpCZf7QgH3cbXG9vHRNYb4pOL1N5zmo9CVwCZbnzfO8JC52B7VSY45LX8Dh0ldbKs9/KYhO1AfDvVz1BC/dOaGQZ0dyofsg+svOwiljPSn6yKzt4IVc34KXx4ksApbFVxu0xyYTsEYGziNoT7TGn1RqR5DE/CtzxIhRi5AaeuMBuygHlNfrvM/j7PSNIIYe6flzOv2by5MmJszbB3MRHo7pGYPO7UGiopzb/zeeB9eULa9XvDyYRt3Dl1UNtkqgWYcaRdVq6o/u7PSlvYH+iA347fIGi6QTuLpt/NvdV8PXgHYWohVRIc7H7a4Cio+CVyZtHg/UsM7phWT1OxP1d4XuDJfCXwQm/+4npW0kM2K4i5WA0WK+ffASPMK73GK5vSCr0apHXfvj2L3hNIdLEcdhmMo7vo51zC/+oQF
 3lPFINf8
 SSKdEz/2n+28R9cZMX6u6Vyb4MD/yrsSOH5Q5Q8Po4ii8u24z880VTrsZOIG/gUAc4bgwolTyoHmaXU33bQSy26YnfaDgI1P2zkBiS15uAT45gcmDdRmM0ZexF4LFxXt2GuXeEM+idURqD+YozH0ppIqI0IEvHGFWP8h/9JWp+8V2Cq95g9IxNoHIY6gW/2JTJgrb7R0oJ+B6W4JZr3p66SvRZcC5tR0GSXBqry9UHyn89fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 20:34:51 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi Manuel,
> 
> A few suggestions from my view for you here :)
> 
> On Thu, 15 Oct 2026 10:06:23 +0200, Manuel Ebner wrote:
> 
> > @@ -30,12 +30,12 @@ guests could mitigate this problem.
> > -DAMON_RECLAIM finds memory regions that didn't accessed for specific time
> > +DAMON_RECLAIM finds memory regions that weren't accessed for specific time
> >  duration and page out. To avoid it consuming too much CPU for the paging out
> 
> "weren't accessed" fixes the grammar, but "page out" still doesn't
> agree with the subject. How about "DAMON_RECLAIM identifies memory
> regions that have not been accessed for a specified period and
> attempts to reclaim their pages.".

That's entire sentence rewriting.  We could consider doing that, but maybe
that's better to be done via another patch.  Let's focus on simple grammar and
style in this patch.

How about simply 's/page out/pages out those/'?

> 
> >  operation, a speed limit can be configured. Under the speed limit, it pages
> > -out memory regions that didn't accessed longer time first. System
> > +out memory regions that weren't accessed longer time first. System
> >  administrators can also configure under what situation this scheme should
> 
> "weren't accessed longer time first" sounds a little strange to me.
> Maybe "Within the configured speed limit, it prioritizes regions
> that have been idle longer for reclamation." would read better?

Let's do such rewriting with another patch.

> 
> > @@ -88,11 +88,11 @@ identifies the region as cold, and reclaims it.
> >  sampling and aggregation intervals. The auto-tuning aims to capture meaningful
> >  amount of access events in each DAMON-snapshot, while keeping the sampling
> > -interval 5 milliseconds in minimum, and 10 seconds in maximum. Setting this as
> > -``N`` disables the auto-tuning.
> > +interval to 5 milliseconds in minimum, and to 10 seconds in maximum. Setting this
> > +to ``N`` disables the auto-tuning.
> 
> Maybe "between 5 milliseconds and 10 seconds" would read more
> naturally here.

I concern if readers could confuse if the range is inclusive or exclusive.  I'd
prefer the current sentence.

> 
> > @@ -113,8 +113,8 @@ quota_sz
> >  Limit of size of memory for the reclamation in bytes.
> >
> > -DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
> > -window (quota_reset_interval_ms) and makes no more than this limit is tried.
> > +DAMON_RECLAIM recordes the amount of memory which it tried to reclaim within a time
> > +window (quota_reset_interval_ms) and stops when this memory limit is reached.
> 
> Agree with SJ that "charges" fits better here, since this is quota
> accounting. 

Makes sense to me.  What do you think, Manuel?

> 
> > -While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
> > +While keeping the caps set by other quotas, DAMON_RECLAIM automatically
> >  increases and decreases the effective level of the quota aiming this level of
> >  memory pressure is incurred.
> 
> Maybe "While respecting the limits imposed by other quotas," would
> be another option I think.

I feel like that's out of the scope of this patch.

If both of you agree to my abovely suggested/agreed changes ('s/page out/ pages
out those/' and 's/records/charges/'), I will update this patch in damon/next
tree with those changes.


Thanks,
SJ

[...]

