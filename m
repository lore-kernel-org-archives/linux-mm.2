Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2258CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89D06B0088; Thu, 25 Jun 2026 10:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61666B0092; Thu, 25 Jun 2026 10:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A10A6B00AB; Thu, 25 Jun 2026 10:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6733E6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:27:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D72E31C4835
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:27:19 +0000 (UTC)
X-FDA: 84918662598.29.239D951
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 44F9840012
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:27:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+NsGq+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397638;
	b=VR3eDjIoA06505SVkOXF17sl2B6SC9UMLwwpdKhAy3NgRfV6miJY/emHmodmWbPGmT/R9v
	7YsF+SfXVmIrcHthbEWBSWCWpUtVGT6Uw+TpyXpVmP6lNGvqwc4+jU02G577ddHHh+3GJ5
	PGRtii7+4UDqh3VtnE3CWt5/ewO5CQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KI3dWK73xGnVU+pIVknxWpsIpvRbOvudq2UA4+TXP/I=;
	b=4k7gIefD4PpcwMvUe1mTEScZpMPah242dyI4JbJQcePdnJViWBUKZGZFhFfIiY91kNZ+HW
	gt5fdeOrqYRlZvQSetcIbxUFqR9MYnVselF/7l292uLN4iMnanWW615/mfse3gniV21LEI
	VEDRLPfhr6ViBuyK6ts8KsWcAsXl7Q8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+NsGq+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3DA4600AE;
	Thu, 25 Jun 2026 14:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261221F000E9;
	Thu, 25 Jun 2026 14:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397637;
	bh=KI3dWK73xGnVU+pIVknxWpsIpvRbOvudq2UA4+TXP/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J+NsGq+ZI4fvGX8kJDFAraUgVvTUUuuF6XQJNX2NQwhy5XXwsMunrEFmB3SZwQStM
	 Yp0xm/UhGXkbmEYqK0Mj3VWNvH7GKdd+ARKqlXWGXg6nDLxPma2Kyf880DYWi2uyzc
	 wYx+SdoVKjaOnjOsCjBVuLdN4kTykgnXJSOtB1h3nAmUE4e8FaZ9xEvxKKKND+at4r
	 KSJmaZl9V6D6CB/ze3oodqLhRr9tcNVHf5bhi0ZJU9qkvz5EeIgeyrf07H3mxlhRrS
	 v9qDoNBL4YhBlI0lgVVhfp4lusZifLAU619MiR51y0Z8+OCYgPjfMyxhQsGDTQEphP
	 R2EUH6JPYIaUA==
Date: Thu, 25 Jun 2026 15:27:08 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: annotate data-race in cpu_needs_drain() and
 need_mlock_drain()
Message-ID: <aj06jJNfxhwB0QeU@lucifer>
References: <20260625065153.1581419-1-wangxuewen@kylinos.cn>
 <ajz0pjJpxsTNwI8F@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajz0pjJpxsTNwI8F@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44F9840012
X-Stat-Signature: 11iy3up6q4dgpcasr4cif5dgzhbx7ee3
X-HE-Tag: 1782397638-725899
X-HE-Meta: U2FsdGVkX1/EDVOMT/23wkhdeirA1dzLPuWmL7AvPu6JA3+ovU8NrWbwgN5efhh2dpGUeKCLrl/5mR9iXsU34tTUnEv9yNbiINbXAEDq33Y8ZMFFSX+Q2et1I6JfmcYlHuyJhp/uH2qTOFoN2mbZkgxlkQhOCK8JFFLs2Zd2gWA2z49dq8TWubt7TBGcIT7eJxF6OXiMhcHoHESD46J/tm/n5jrx+3nyyAUHkknrRcax/xpKZT/V01JY+NFaItfYEFYNzrB1fIThsNsG/jzU/vqCgetYWb6mcA5QoTfY8PyiS8rbLf9/wik0RsFRZJ5idlitGuzD9oeUg1ucKTsG9j8JCw1AskvsTvU3VD7pRIirK0NJjI2eV+9T0Has06BQZPJUyIdoqKJB2DYBzA03VOvNZDHMUqw9nuxwN+CpgD7UIzv+asMUP4yRgqwstQFxCbf/B6mY7cH2y6UWk/D7e7bcSajpQ5wIg3FgXDXn5oiA+GVne++avxpWYSs8XY4fqznkrF9a/IEWi/sVgmFLrfBZ6X0ht/raBzt6eFcKmUZBoF+f/gmp0kz/fcBJaHEmEwke5w6v2iVngRpSKCMEZGEEcGaaPIyjZWq8/zQEMjEW2G/jT+qd0Wc+hoHrTBaMZnPr3+1flbhhyCxJC7j8/RVGoHD8wuQalYk+MTZ+3n82xhavCMQIgKzGtwH+LXobn8FtY1P9zbV61GaBuu+pPLYUS2mPWyuPT+/Baq3zdrTjZScT+WR2xYCXLSO5dLxEJMIHL1RXTf1cIeETFt1tMgwl7OHSfHFriup65Iz5JjD9LzWAai5OGvBopSs9NflvWXObSVNWeb/MUsOJcyxR88AMXQE5Y02oA22z4EHcka/sNWYsIRfxcW9VtU8zjLQIgESxdb2tdmKZ6Zb3ND+Te7jk82tjzbr7PVprZ4P7w0NmeuijIQ3mmlPcgVMqNrzCRjdDxVeg0MOwftzxD8d
 IciSZ443
 fg3BVNUcVuEQJcACFDbPmw5rNi/NQzbfbfg0TmrwuzyDPRS9xIGMq+Fl3RTFxr9ym736mKlBrSkr/kcAYUsJru93tCc72HaDhVcYbCo42Zlx5ygUU3fYwi0r0p2FTfWQD9G97ihVroz7OKU8tl647u3nx22vMky5euwByvafQiZP33H6LdBWkEkf6CoTJyungzAqk7fzPnqQDAtyBPUf8g+7CFTcEekzNLd26XTsi3sh8j9c++Dstb2UvZRtKA5CQIMLt4lkcQXGCbtRVhug9SKUokz2fIns2MlqHQ6jbDRTdJKt6AAaOTjt2TQxXn0LHXkuNPeGieezBzn6+H3+ZTNWEbpSY23WvdtoBg01izMLt9jU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 10:31:24AM +0100, Pedro Falcato wrote:
> On Thu, Jun 25, 2026 at 02:51:53PM +0800, Xuewen Wang wrote:
> > KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
> > per-cpu folio_batch->nr without locking, while the owning CPU writes
> > to it via folio_batch_add(). The same race exists in need_mlock_drain()
> > which is called from cpu_needs_drain().
> >
> > Reading a slightly stale value is harmless -- cpu_needs_drain() only
> > decides whether to schedule a drain, and the next iteration of
> > __lru_add_drain_all() will re-check.
> >
> > All other callers of folio_batch_count() either use stack variables or
> > access their own CPU's per-cpu data where no race exists, so
> > data_race() is added at the call sites rather than in
> > folio_batch_count() itself to avoid suppressing KCSAN warnings for
> > future callers that may have real bugs.
> >
> > Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> > ---
> > Changes in v2:
> > - Use data_race() instead of READ_ONCE() in folio_batch_count(), as
> >   suggested by Lorenzo. READ_ONCE() is unnecessary for a single-byte
> >   read and imposes overhead on all callers, most of which have no race.
> > - Move the annotation from folio_batch_count() to the actual call sites
> >   (cpu_needs_drain() and need_mlock_drain()) where the cross-CPU race
> >   occurs, rather than affecting all callers.
> > - Add need_mlock_drain() which has the same cross-CPU race.
> > - Add comments explaining why the data race is safe.
> > v1:
> >   https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
> > ---
> >  mm/mlock.c |  2 +-
> >  mm/swap.c  | 12 ++++++------
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index 8c227fefa2df..fbdb5018e2c3 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -232,7 +232,7 @@ void mlock_drain_remote(int cpu)
> >
> >  bool need_mlock_drain(int cpu)
> >  {
> > -	return folio_batch_count(&per_cpu(mlock_fbatch.fbatch, cpu));
> > +	return data_race(folio_batch_count(&per_cpu(mlock_fbatch.fbatch, cpu)));
> >  }
> >
> >  /**
> > diff --git a/mm/swap.c b/mm/swap.c
> > index 588f50d8f1a8..d046428caed6 100644
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -828,12 +828,12 @@ static bool cpu_needs_drain(unsigned int cpu)
> >  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
> >
> >  	/* Check these in order of likelihood that they're not zero */
> > -	return folio_batch_count(&fbatches->lru_add) ||
> > -		folio_batch_count(&fbatches->lru_move_tail) ||
> > -		folio_batch_count(&fbatches->lru_deactivate_file) ||
> > -		folio_batch_count(&fbatches->lru_deactivate) ||
> > -		folio_batch_count(&fbatches->lru_lazyfree) ||
> > -		folio_batch_count(&fbatches->lru_activate) ||
> > +	return data_race(folio_batch_count(&fbatches->lru_add)) ||
> > +		data_race(folio_batch_count(&fbatches->lru_move_tail)) ||
> > +		data_race(folio_batch_count(&fbatches->lru_deactivate_file)) ||
> > +		data_race(folio_batch_count(&fbatches->lru_deactivate)) ||
> > +		data_race(folio_batch_count(&fbatches->lru_lazyfree)) ||
> > +		data_race(folio_batch_count(&fbatches->lru_activate)) ||
> >  		need_mlock_drain(cpu) ||
> >  		has_bh_in_lru(cpu, NULL);
> >  }
>
> eww.
>
> How about:
>
> static bool cpu_needs_drain(unsigned int cpu)
> {
>         struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>
>         /* Check these in order of likelihood that they're not zero */
>         return data_race(
> 		folio_batch_count(&fbatches->lru_add) ||
>                 folio_batch_count(&fbatches->lru_move_tail) ||
>                 folio_batch_count(&fbatches->lru_deactivate_file) ||
>                 folio_batch_count(&fbatches->lru_deactivate) ||
>                 folio_batch_count(&fbatches->lru_lazyfree) ||
>                 folio_batch_count(&fbatches->lru_activate) ||
>                 need_mlock_drain(cpu)) ||
>                 has_bh_in_lru(cpu, NULL);
> }
>
> this should work equally well, while being far more aesthetically pleasing :)

Yes...!

>
> > --
> > 2.25.1
> >
>
> --
> Pedro

Cheers, Lorenzo

