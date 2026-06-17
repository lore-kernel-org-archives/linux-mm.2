Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D2FACD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9F56B00A1; Wed, 17 Jun 2026 11:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B356B00A9; Wed, 17 Jun 2026 11:08:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA0C6B00AA; Wed, 17 Jun 2026 11:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C8BA06B00A1
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:08:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54DEE1A04A2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:08:47 +0000 (UTC)
X-FDA: 84889736694.22.6F7A0CF
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A9CF20003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:08:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H5w89jvj;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781708925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmNoOt2xhXhUdVUypMM4EgODu463lMUf0qQnokW3yA4=;
	b=XhD6//74YufLBtqqw0KuKzq4uvKnrz6ght0nKLmK8oc8UK+JSI400ekJ2o4q4p/1rgzB0l
	n3rNDSJu404UzEAPMXSwDGkgGSttp7dTlG9LMkzRT19tK7Trk1X5CMSB5LOLWzg1XGZURR
	QEZiTgyu97eVIE5wAelfSCJgDXmjkRo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781708925;
	b=nAcZFZeuWNPwbM8fUZK7TCDBJbrltNhppFhGZWuC4GdPuoN/NcHhJDOndybhUMb9aRqbKp
	qj7/CWTE+RqM1o1/k65oPDTw0RF4EkcElaAKcO3YXImWK5YNL94Mc4v3yXBCMUQ02hmJMj
	wQae1AVnoofbH/CsDqirHj1u0ChGlOA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H5w89jvj;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 17 Jun 2026 08:08:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781708922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmNoOt2xhXhUdVUypMM4EgODu463lMUf0qQnokW3yA4=;
	b=H5w89jvjIl9L+nV8GNPt+jiKO3stjNwlMcQTQfT6QUXnYd4W8l4YZukHOKyaIWnSY63+yv
	s4KpIx92Idi1rcmvtlmN1qed4GPPYv/h/M+IY77RlBqSXSspXt0xDhmbE4HpODIdd6XwS2
	Tw2x8417z7hXyOHKlEuwhzSvz3thqYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <ajK4N2zK3sPZFQuf@linux.dev>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev>
 <CAGsJ_4yCeAmpfo_8ef4MrRyRD_UtV-xGm6F4GpSjvLVPQsbiEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yCeAmpfo_8ef4MrRyRD_UtV-xGm6F4GpSjvLVPQsbiEg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A9CF20003
X-Stat-Signature: daf1uukzbf36fzi6gt58zii1bygurw6w
X-HE-Tag: 1781708924-710322
X-HE-Meta: U2FsdGVkX18a5fPVZMvu3E1tusK0OFLB+cDVgHZdJZWHSzzZWNGjy4yJTy4+rTEnFTLOsLYs+g+1J5YgT3c0qs/GwvuvAYc+Ba6PWfXDdoMh6/sF1dAsSCR+CoqUckqDM1WeJVg+cm6sVLxrFAORH8/c9wj8rBIcTrp22/VfZ3Mjgv0Y3y/HbU+4vSB5Ydg9BE033EyN0ULNpmVxnnpjc5UZel6U+F+IwsoZqHn8M1+l8laSRhE1ibbm8jBGuuubCrCMXSli5LBd4r+GEHiOMBnlNHaZaHL5HcSIT9hfj5AM90hoUE9T1vj1akiJEHQyNidXuwC9uolqYNO5YkhsV4E8jmu9sh+eXWZSr91WBisDW0JEy88BA+HmqR6eBoHehRoD6RKaNHFtpeW63+38cGNDz5weT31OcmIH5YEBTAMmEzLa2hJJEMrt4xT+w9eZvHQ2Q6YV9kzrtTD2hOubrvoJ7/3R+P/TlwCFh13tY4+dgTtf91Mr8+hqd1fzY0Zr62nQwSr2rtEA3oAQstSyXISPhU3sdaFBk4+ReFSwFZwRtAOjSRY8q89j+gwKLHLVI9rMJ57+apcsN0g1Nv50LLCnYQ+jWuipgPR2QB5RZaQWOEy1KeRiAQq7MFIxK84AN8XYRqZtPjLdQv+AIjC4BvZlPccQjM4EPMA/AmnSGPG4pw026Ud6VnKb/4C6+xsGtAC7i9lo/0q+IWsq/fESzRNSRW6zYdQt58Pl/FpOMHHdy3Vl43RrmAVU15+bNGDjM6mulaE1eVEL4VABJvHQauAiAc4f5sZk9IbKXFPtN+1Z0vvNQPT9g09y4HbqeTMRI2dOFwxHCLoFcDjMPuhb4i8F9/OjHvHCNSU2yYgFIS0lEli7U5q4+yu8c9EB9K9jtX3RsyM7jZuXC6KVlpubsb0yp4OLpM75AfDQb0Dr9WifvgD9x/W9fJfAHZpde+KyiLHNbhNjCi17KvcJz0E
 3Q26sAz5
 Y0vlFhsf3C4Vc/pHQcfzsbBb1HG9nmJukhRqH/aHYj41FrCLNS+/APOLW5/6ZRgSoV4AycyIn0X2CsbJej/R7LYIniVtlHbYrXLetq1D+Y+Wx5hSpXgAGSjFv2iv0SfANr7cTPYYnugz0/kiR6V4wpZ47aEpUbk3unFr4eLg4s2KNeRjWePqrzIM4yQvEKHOTd2V2uFPG24GMz2wIR1YjnIPH/MboYylwOAPdFKugBeTUoaFsi4vGOy+fGIlm7DeW8wW/KQuzmLFTsZrCjl6azBqXP48sSjeUBcdhehQ33dVOb6WTygL1CgoYHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 12:48:19PM +0800, Barry Song wrote:
> On Fri, Jun 12, 2026 at 2:10 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > > We always unconditionally drain the LRU before retrying anon folio
> > > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > > drains.
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/memory.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 56be920c56d7..487a34377a7b 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
> > >        */
> > >       if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> > >               return false;
> > > -     if (!folio_test_lru(folio))
> > > +     if (!folio_test_lru(folio)) {
> > > +             /*
> > > +              * Assume folio is on lru_cache and holds a cache reference.
> > > +              */
> > > +             if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> > > +                     return false;
> >
> > In your experiments, how much amount of drains were reduced due to this specific
> > check?
> 
> This is a very good question. I booted the system into Ubuntu, and after
> boot completed I observed:
> 
> wp_reuse_skipped_drain: 5542
> do_swap_skipped_drain: 0
> 
> Then I built the kernel in a 1GB memcg using zRAM swap, and observed:
> 
> wp_reuse_skipped_drain: 25017
> do_swap_skipped_drain: 43595
> 
> So in summary, even without swap-in we can save a significant number of
> drains in wp_can_reuse_anon_folio(). With heavy swap-in workloads, most
> of the savings come from avoiding drains in do_swap_page(), while we
> still see a substantial number of skipped drains in wp_can_reuse_anon_folio().

Thanks and this is very good info. Add this in the commit message when you send
the non-RFC version.

