Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A828EC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E056B0005; Wed, 15 Jul 2026 09:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B349D6B0088; Wed, 15 Jul 2026 09:58:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A720D6B0092; Wed, 15 Jul 2026 09:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873C26B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:58:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18B221A01BE
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:58:49 +0000 (UTC)
X-FDA: 84991166778.27.393B9C9
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6568040006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:58:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="Go/9ENca";
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf04.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0TSRqUtBqv4LNuB9QoC19FaESHdGA0a27gnrDjs45I=;
	b=ALo0Pvh3SGsjw6WsrLMlWMOLSmuPkvPUvBNYSPTrdjYeyn8qJ0VXpLIejk/V7ZEmLTlKXy
	wT1dd9/oSQFITNwT1HnB68ULFBPav8UOtsNIIdpH71rrq7pZrMS8cdUs1eyXjgXUBC/FS+
	LIDFxsnz/iERfPMRnTkNWoX2bOEz/mI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="Go/9ENca";
	dmarc=pass (policy=quarantine) header.from=morinfr.org;
	spf=pass (imf04.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123927;
	b=dyeGH6Jl1ZcQigBAOC9M9YDie9Mhjo5CO8NKCMqvSgJWUM9pAxTuOh03XFJ0WDeM4yshvI
	9UGdWh55/YVdH5jNQd1BFFiwIRvnasvnObBOfyLJ+AjiuvoptwIUfQAWC6lmr2Y2cCP96B
	dw4AyG0QITKJlirdLCbv12Mx3jsz8uY=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id 85ECA2003C3;
	Wed, 15 Jul 2026 15:58:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/0TSRqUtBqv4LNuB9QoC19FaESHdGA0a27gnrDjs45I=; b=Go/9ENcapVzmJw+O4blJ3Th6hB
	GKYDM9jYAAQ0X3rpKCLsXtQF6VBujHN6rRWWrtEo2bWXqlkG8XyccRZqOqvou9tf7DHo6u5eoOVqq
	13ts4Ust/S/FbQTSx0NKbbQaOvlXRpCfN/sYPediT9vJMctpOnLu00jPE8BrhgicKk04=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wk08F-00000004Fbu-3WMr;
	Wed, 15 Jul 2026 15:58:39 +0200
Date: Wed, 15 Jul 2026 15:58:39 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Breno Leitao <leitao@debian.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, osalvador@suse.de,
	avid@kernel.org, linux-mm@kvack.org, riel@surriel.com,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <aleSDxoADBD0Qkb-@bender.morinfr.org>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
 <alSyhslcItgtqSHT@gmail.com>
 <alYT8J9aRQDx_8pP@bender.morinfr.org>
 <alYZ7fso3zp3j3jv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alYZ7fso3zp3j3jv@gmail.com>
X-Stat-Signature: sijdjo1ejcm8uytt33rxdzwd1bn6715k
X-Rspamd-Queue-Id: 6568040006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784123927-754674
X-HE-Meta: U2FsdGVkX18eqqRFN94g4KmPUgIWNupgJty0YWc2z9257afHUHKp8pYPqbcAIL048drFzfnRVBm45Nf8Gy0oVFsu95m/eUgxxlRRh0wH7cATtzn29Q9IGfCLRsdQJ+VxKIuFqs2DyoDUphCOk9eZqAOjAlnxFP58fEynqLxIaOY5wRrh3BUkOO+Uha6xAjuw2gbUqVVb2viUkbZ9Wo3idm63cRtPjbzZD57/U6yQtD/ySkHqS5m4bBobFw2bOUuD4CPUDXkVAOli2FYH7kad9UILS6gq4ka0QEmhQp8iOzSWgzEUyDHfK8WPt7S9jnqi6tQY/y5vL2O6k+3nmSZaTmkf8qWqPQBipvn3XsisV89J+r95pwPz9B2tKA4h57PWbiwVbCJ9CPZ7YU7P+CFrJ7N1wrkEih0u++LMT8RyZUQxy6tjA4TMXTPdpxVjo8yJ9zye4hGyTjEQV8DweGm9iaY3vNiWOp7wlRnM7UdH8hrb9WBh+fTluDrMp7oEa7oZQoYnMF52fN1XjdIYbdory1rGJ52oTHc/bjyegKmcFFg8kYgGzvbgLDogvhRrmGkiEo/cUkzkYzPJA3PEAgeDFQHFawwK1obTwcwbTFFm7Qrj2RFtKymtIL7cW/h3YWe9BASUPFTVD9fasVKtIgc4hEmg3fo2QF3ApQRMyTTBiOOLyUkuLbITMYhDDTnR7KIOi4jjYQcVRqfxMM0M2iifMuboEtYvhAeUKD6rLl2Bfd4EKy5g+B4lk06MNUImIA2FLs9N3j8sg/fbckIt+CfUvj3ntfMZ06FkGk9LhcKAQkXaGMDqMM5AN6FS0ISkzeu+PkOdQwEhr+dF+0wZ3FzQFUSsS/XPSdBjl8+PSoFVfNE8esKS69E8L8p6GtDqbVjY39/2GeaFyVLTQYRwiT2Y82TG9D/T9e/iMQp5Z2UaKTqkhjGX/HLmQkHrPjRScL8/ub18lPZXDKlbojOUwOH
 9xDFuIs+
 gp6eOy9qzZNQ0D9XBKPTbQApowAcSdie/bZ3nJupoji1wl8IdmlDjNGxOWY8cQg3JkNnseVO90/H5TKl7Ea4zqJbokThpxB7nsZRemZF9J/V5JOJfjG8owEv4O4hw2T9D2oF+orDEbbreS1sozb/UuDvSuqKztkN/87Vi8ZPzCEGZoVROv4VV64NgBJpRJyl78yquNmdz4eiCQHNcQZgshaw3VJPGD5EPHb6xHpUdKq+4cID2xImftHU9QdmgDJRcT/06NkLGyTFOAqWIZyvN2sNkjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Jul  4:14, Breno Leitao wrote:
>
> On Tue, Jul 14, 2026 at 12:48:16PM +0200, Guillaume Morin wrote:
> > > > I am not sure what the best fix is but checking folio_mapcount() == 0 
> > > > in __unmap_hugepage_range() seems to do the trick
> > > > 
> > > >                 adjust_reservation = false;
> > > >  
> > > >                 spin_lock_irq(&hugetlb_lock);
> > > >                 if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
> > > > -                   folio_test_anon(folio)) {
> > > > +                   folio_test_anon(folio) &&
> > > > +                   folio_mapcount(folio) == 0) {
> > > >                         folio_set_hugetlb_restore_reserve(page_folio(page));
> > > >                         /* Reservation to be adjusted after the spin lock */
> > > >                         adjust_reservation = true;
> > > 
> > > The fix looks correct to me.
> > 
> > Excellent! Will you be submitting a patch or do you need me to do
> > something there?
> 
> Up to you. You can either send it, or, I  can do it myself.

I just sent a patch, hopefully it does the job.

Did you have the chance of looking at the selftest version of the repro?
Should I spin up a patch for this as well?

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>

