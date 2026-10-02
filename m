Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C17ACA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FC186B00CE; Fri,  2 Oct 2026 05:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACB96B00D0; Fri,  2 Oct 2026 05:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B256B00D1; Fri,  2 Oct 2026 05:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 308286B00CE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:59:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FB8FA71AF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:59:37 +0000 (UTC)
X-FDA: 85277239194.24.7323BA8
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf16.hostedemail.com (Postfix) with ESMTP id 771AE180006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:59:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=p5Y3yL5I;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="U w9Q9nx";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWQWvSRtZpQNRbLA1L5skLRgmvwqnZxEILnwPaSwm3A=;
	b=Wzm2nVwlPQLcOztlWe3lEeZOSqg6mHprKjjrJ5Lj58qyGuvTeKRaOe+bKmIoqxMq9cemmQ
	aM0t2Sa8qJo7bz7DudsocF0gemqVr2pXpH/jbdz5W2WyJmSyuqAwu7URpKvc78Wl+GaetH
	MBiUfgrPcK1Re9ffYE62kidlcMQ8cXg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935175;
	b=Hejh2Ir46B/ifEfMQJPRJzSGC1kr6rKmXRu79Tn7XctBFFpFOt7POkLJyTpSqqSNWH/yRv
	5Braxg9E6gIy3vpAkuEe4WeY4z6n5kfVEnTDHvb5mZ4C4XR6M5d1GjJK7TrA+kGKHfYoSz
	ZGpz1iDpKoO3qJFvPrXHm7nmy2exZRI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=p5Y3yL5I;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="U w9Q9nx";
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id C2957EC02CC
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:59:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 02 Oct 2026 05:59:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1790935174; x=1791021574; bh=hWQWvSRtZpQNRbLA1L5skLRgmvwqnZxE
	ILnwPaSwm3A=; b=p5Y3yL5I8TGolsq33QejSo0WGo9if7U36A2hwPehlneErwIS
	fVzQLUifb/C/4TgqLGxGkiVuaIo6g0ueXVvchbRGEFVPG07rNmBBBsZlbc4NUgQp
	UQVc5ukIRWP7jh9q4JzW3gQd51i6OnxyQZcwS6HKfeTHiYzf5kKBwuC+WblnQ8mz
	WxfQCxja0lymg73eeUHqTRwJevdg/eL4mpqwpjs8fZSSJiGf9d5a4HZ5K78ysE94
	JrWAZns0nGjf//zIxSq0YkDwSCJ042lPXc/TVfJyLFxMKuZwss2WBsC9Ja60ADUw
	fpYmlEW10uF7+XlC0ZPzX+yt9CdbcHrTa7Xt4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790935174; x=
	1791021574; bh=hWQWvSRtZpQNRbLA1L5skLRgmvwqnZxEILnwPaSwm3A=; b=U
	w9Q9nxCmS6URBEgiHaHv4Ms4+c5F/afQLiOi+aDzaqmR3WEH2AIsANNAHvfFaDsy
	Iynn7FILh4ddTxVvvs2JxXGL8w1iVDgCh8rZ9ukMVjiVBzs6+jVMsQPJoXVQ4/Mf
	0Sw8OcZJ523s/OzyH/U22lLluqgiILqyAIq7JntSKsY/oQQb83wS9sKpqGbcopsd
	9cIcF7e0A4ackCd7PUVH/WmUk1eiZse3iuRI5aB+XpIgma9yVVliBg8SrhZqGpy2
	qID/geK4wf4k7ZDH1RLd/TMxOuXJH2Ej8TE5rjAu7v6tp1COV+NqdWXIFCVOTtEy
	Stl+zLp52wPMH7BSpNH3Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790935174; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:U5YpwrgEzpqo5YCErG2wh9resIy2TeWgd091AArv+WatnFE
	dQGN9owDdlVQWtHkeRsBwdi2QNQ3mQZV6cLKoY6s1zABaQkVbgthmjIyWKNzvQhE
	V4ta8j24zbUH/tELwl3Qlhb41C7PXqhYdZ4sbeS4bY8faS7zDmUxaXr/R+x8/fD0
	18MuJmVQOW1/aIBbSCs8TKdgRtPTKUZAMSKxmuKw0lNXOTHBV5dPrWp8UXNmlr8A
	qsO2M2Kr4aC4iZHl9+X6MiBWR8LylDP1otQO0BtE3BGmWB1eIBRhIIn1t4MCyfVe
	Av1QfuQ9s0d7aqJI32jE2JMdAafGPxuuvvfSMmA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-disposition,content-transfer-encoding,
	content-type,date,feedback-id,from,in-reply-to,message-id,
	mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:0gFv900XlcZUDJ4ZI8Lx/4OVpOk/3fhbx4DEwVMO4BE=:tQ+3O1oy6NmJ8hLKB6uPkUQsSUjCMku3OhgpM3wcIAo=;
X-ME-Sender: <xms:hYC_asvTqJuagCtgZkwiauQKagDFVr444ktAUH59nxuJ7_2YZBELwg>
    <xme:hYC_ahOD1O3pOZ0NcbTMZqjFFxnRephQUNMcVIzrdOJDjb89ZOkP4941iDvRniOXL
    qIY8ayoQmPthBaxbEDIKI4qA7OOM8Hcst_S7gFzKQA8kM8LrjgeN14>
X-ME-Received: <xmr:hYC_amUHNWQ93nS649A0bXSeUotPRsNCVX6JzQuiv9JIofVhKkjlek8739Y>
X-ME-Proxy-Cause: dmFkZTGHfOnUXXV747ZOhpmRElSxxMTfyusx4TExOoI37ujVPFXbZ/Q760i88W7nrEn55y
    AP8xcOqTkCAbECNdU06na96ApU2vkVhYrV4PzoavX/w5mKGSof2jZoMuBdeLia0YzmmuUN
    pTev5b8AELQPAd/HYArKqZt09gR4E3cHqSLnVqqcY5fIRZ+LyGa0sY4DD7WqLFfH2Int+A
    1zgHpILFDp1vDOVh24AsP5Yi2fsPCISmwTB4pb2KQ1984S1CSubISh9h5d0LkQO4rSEG7N
    jypXiuztQoPtYNh/lHVdONb5hXc8qTuVbSsT8+QRKROpb9y9PALFcvydo5i9S3iv83cFer
    cCPGYBKmQRJbcqrYbwmIKdle+hFynhE/ulYyXBoHyIwBlqJtfKdLTB8FZrN4iw+EgJDZHa
    7vxKA0IRUUmJ+Z179OBbDBR8vJSjARuXzjEBtHv60pHkOgP4s6hRo3fhxXVWsw2JP8CFiN
    lI7W0aDWLxDFHjTZuyYl5rkOi1jDVoes+G83FBmOxaew4sjMBd7BmWQpFhuxDpxlRtkM++
    HICzTth7+MdleRYH9GztZyq21sny5pXteWKW2/RPMYwscfXY8ZMexK7natHHrhN3JE4S/v
    0SZwXwjry3KsPz2K52v60LS3EVUbP+jEpUPxJe8vRm5Db6aV93sY3GtUV+UA
X-ME-Proxy: <xmx:hoC_apjl56_l5wvsCIEOG7vefXWCohkVPZUfTxNV5I9Bto3Em1rfMg>
    <xmx:hoC_ag3940G799hIEiY6b8apU2cSYHfvWsRWPN4V83AbLPjIAfOMiw>
    <xmx:hoC_ar1127IgkYLuiTYxQ3QM8n4qX1TBBqsECeoE7kwaLkPJGOHL8Q>
    <xmx:hoC_ahwfOvHDYZFny764Gv-0d4-BesX8pEVXHq6Qm_38n2vwKHPEzA>
    <xmx:hoC_ahZr8XjA4DMKIZ2Wyb41fphUEcQkNUDZ9JqEXxrvzQut7md5nhVN>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 05:59:33 -0400 (EDT)
Date: Fri, 2 Oct 2026 10:59:32 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Harry Yoo <harry@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <ar5rOHWwc_iPJF6C@thinkstation>
References: <20260929174553.175333-1-kirill@shutemov.name>
 <arv8J7ysrdazJmfY@thinkstation>
 <ar0NRMxps8UErXaQ@thinkstation>
 <ar0Xbs9mEu-vUHvc@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ar0Xbs9mEu-vUHvc@cmpxchg.org>
X-Rspam-User: 
X-Stat-Signature: 38szfzjo5ssaf35zxd59pwjiaxcrcj5c
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 771AE180006
X-HE-Tag: 1790935175-402047
X-HE-Meta: U2FsdGVkX19g3pGvlxU0Wd5ti1VYvCz7dVRCCGXPWBfLWQN/hkh9Nri0xGedyWxLJcqGktippTJtnpTOb6+THVAr8OkCwJ3AM3SmWpPeweH2YFPgseIn9XwUmX6VKu6XZ8rdHpeQtLRhE1dvpCU4dqF0wyWen62jobyoMvktYq5NXRp2SZYU71CeaYVOLGssLGZPPuaDKVtzpr6x21HYtQyVC+CvEM3In16vfwuVa5/UZ1WQxogITGxtDf6+CVMsCR8F1Yg3+wTu9WM/QTnRjgKh8lrP5eZZky6Z5HYWjsVnTk3sadQN5U8ux22vLj/BbXroBSuQwRr7dMj/eF5tLOBmvMTtagdPkJt7Zlhf6RkdXUoy7fc3KS9hvJMm1ozpUCcXgXUnnVpljK2q+H2DZtoEE4BDsLWwIODnevQkRfBBasyw2ILd9qui5fZqbSRl9rvC0KiKy0rH9313Uz2kiIm+D65RJtskyGxod685nuzNbfOuS1NIR8d9OJWRMdf5mQFwx3mfbNlJnLNdyPgPok8IbRQk1w6UxJB6aM9A8bGJ7dxjhlgofCT69X5fLa/Q1wplQt7sXaDA/t4vVWtDL4gpSras211V72/4YyOf8arPgIywZBPEmGYLZYSr1MJOA2nKGOJTVIXGV2p3CSAR9YDXm7PxWybvyKaAHaxmQDEFfYKYeKoH9/JADrlBbRPoafP8alwyJV0H+d+kEBmXFFFJbBSR028pgK5s+T7eOg/rOCM65XP/sJoyFZQRaJHF42+PBajJMT3Fx9ML7wscEme1DJ9OlQobeNj+QC+mJIZ/YN+/LAdD/Sx0+jdpTxgeph8yJsqJ6kt9YqWOnKxSQXZkU3xdFHZbxIlUhhr/dfX55b95+wfAUiorNTwKxmYP5VFEWqLHlIAEGzxqPwAbh1JdCPv7u8EAweBqg74c5fmLFf4gCFdMvYuuB+4gmenV+ddbGznq0V9oKO6M7lV
 KRmcyIeJ
 O52eZRfMG7UcAx4JRxegL0m/ZU6emTaRUjmdk/3Nf0ez4Jjicc1SqedbJqHwPd4+yJTepYWEZzSwG2orwbwoPZko3GS0K4RxcJZUezY43A2gfhMh0DFbRqiXnXsTOE1VIMIxXcO6J+mocUuaUCrzonWQrXB/hLFCgeexG3GztKOkf4PgShqrkFuG52V1NvOgWHYLL1OMZqSVx3wRu0KeTGlkcBEpA2CJlFPn47MLDt/pDjFB9Q/xOTSPuY4wAknVmMzyuIkBFNi3+sH0Di7WV0cUGDFlfl1AtBI0DADqme+dlxJS7FApgpxosiiA2H2QbYKEkXAycJyMmIoe0tjj1eiOzaORFk6XCMVf4I/fLVxCZu3RnMmyXL+ff5NJ3n9n+pIHyjT5oQfx25bjHnPROGPlrME5YyS+DLYRspoefubbckAmilHTFxqqLoTY7u1pnqiMT8k+TwS18QU1XsYtSuSYgFGZSLcnBVNKZGFM5Dagfyu7EuaFPl93/nlFuXt1Xi1cF4RhFtB4eYLlX57Uh5FCDkUioFeUoK5OBu1aEVQ+zHG255+HslirtUp5BJk9/62gpE5540TQyz+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 10:06:38AM -0400, Johannes Weiner wrote:
> > > > @@ -4127,6 +4127,31 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
> > > >  	return page;
> > > >  }
> > > >  
> > > > +/*
> > > > + * If fallbacks are not permitted (defrag_mode), we either need to
> > > > + * reclaim space in a block of matching type, or clear out an entire
> > > > + * block to allow __rmqueue_claim() to convert.
> > > > + *
> > > > + * Reclaim by itself is primarily freeing space in movable blocks,
> > > > + * since that's where the LRU pages live. So this works for movable
> > > > + * requests, but not for others.
> > > > + *
> > > > + * For those, promote the order of reclaim and compaction to help make
> > > > + * blocks, instead of spinning in reclaim alone unproductively. Retry
> > > > + * decisions based on the outcome of that work - reclaim progress and
> > > > + * compaction results - must account for the promotion as well, see
> > > > + * should_reclaim_retry() and should_compact_retry().
> > > > + */
> > > > +static inline unsigned int nofrag_promote_order(unsigned int order,
> > > > +						unsigned int alloc_flags,
> > > > +						const struct alloc_context *ac)
> > > > +{
> > > > +	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
> > > > +		return max(order, pageblock_order);
> > > > +
> > > > +	return order;
> > > > +}
> > > 
> > > I think we should start distinguishing order and compact/reclaim_order
> > > in __alloc_pages_slowpath(). Silently overriding it makes it harder to
> > > follow and easy to make a mistake.
> > 
> > Agreed, four callers recomputing the same thing is asking for a
> > mismatch.
> > 
> > I would rather not grow this patch, it has to go to stable.
> > 
> > I will look into a cleanup on top: __alloc_pages_slowpath() computes the
> > promoted order once per iteration and passes it to direct
> > reclaim/compaction and the two retry helpers next to the request order,
> > so the helpers stop knowing about defrag_mode.
> 
> +1
> 
> All they really need to know is the split into requested order vs
> production order (reclaim_order, compaction_order).

Will fold it into the fix itself. The cleanup changes the same places as
the fix. It makes zero sense to keep it separate.

> > > > @@ -4299,7 +4316,7 @@ should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
> > > >  	/*
> > > >  	 * Compaction failed. Retry with increasing priority.
> > > >  	 */
> > > > -	min_priority = (order > PAGE_ALLOC_COSTLY_ORDER) ?
> > > > +	min_priority = (compact_order > PAGE_ALLOC_COSTLY_ORDER) ?
> > > >  			MIN_COMPACT_COSTLY_PRIORITY : MIN_COMPACT_PRIORITY;
> > > 
> > > This would change how hard we try to compact with defrag_mode in direct
> > > compaction as it won't try compaction with MIN_COMPACT_PRIORITY anymore.
> > > 
> > > It doesn't make much sense to change that as part of this fix?
> > 
> > It is a choice between compacting harder and falling back, which
> > fragments a block.
> > 
> > It is a judgement call on what defrag_mode means.
> > 
> > It would also mean that order-0 allocation request promoted to pageblock
> > can trigger SYNC_FULL compaction. I cannot say I understand the
> > implications. Will give it a try with the reproducer.
> > 
> > Johannes, Vlastimil, any comments here?
> 
> I would leave this one with requested order unless the reproducer
> disagrees.

I built a reproducer around what we saw in production, which was oomd
killing the workload on sustained PSI, so PSI and the number of times
ALLOC_NOFRAGMENT gets dropped are the headline numbers. 32G VM, 8 CPUs:

 - fill memory with 4K anon pages in a cgroup, memory.low = fill + 1G,
   so page cache beyond that stays reclaimable;

 - pin one page in every pageblock with io_uring registered buffers[1],
   except one block in 50 (2%), so whole blocks can be made but only
   from a few places. Without the pins rc5 does not storm in 180s:
   compaction makes 130-210 blocks per run and every retry loop ends in
   one. The storm needs blocks to be hard to produce, and the pin
   fraction is the knob for that;

 - free one page in eight so ~4G sit scattered in movable blocks;

 - turn on defrag_mode and run 8 build-like workers on btrfs for 180s:
   write 1-64K files, read earlier ones back, unlink 20%, fdatasync
   every 50 creates.

Kernels: v7.3-rc5; the fix as posted; the fix with the priority floor
and the COMPACT_SUCCESS retry limit on the requested order. Three runs
each, mean ± stddev, 2% producible:

                            rc5            posted        requested
    ops/s                   4751 ± 684     5181 ± 18     5206 ± 84
    PSI some, mean %        28.7 ± 11.5    22.0 ± 0      22.0 ± 0
    PSI some, peak avg10    42.8 ± 30.7    24.9 ± 0.3    25.0 ± 0.8
    s with some avg10 > 50  3.3 ± 5.8      0             0
    give-ups (NOFRAG off)   0              222 ± 58      277 ± 199
    movable blocks lost     641 ± 13       654 ± 10      652 ± 14
    whole blocks claimed    90 ± 8         81 ± 10       76 ± 8

rc5 stormed in one of its three runs: 3.85M order-9 reclaim runs in
180s, PSI at 42% with ten seconds above 50, workers that would not die
on SIGKILL. The other two were quiet, which matches a workload that
OOMs regularly rather than always. The fixed kernels never stormed.

Between the two floors there is no difference I can measure here: same
PSI, same throughput, same give-ups, same movable blocks lost, same
whole blocks produced.

The promoted path is a small part of what the allocator does in this
workload, 16-22k order-9 reclaim runs against a million order-0 ones for
page cache, and a few hundred give-ups in 180s.

> There is a risk of defrag_mode self defeating over time by raising the
> bar for fallbacks but not high enough. Every fallback we let through
> will make it harder down the line to compact towards that higher bar.

Same movable blocks lost and same whole blocks produced in all three
kernels, so in this workload the extra SYNC_FULL passes neither produce
blocks nor save any.

> There is also a non-zero risk of connecting order-0 request contexts
> to SYNC compaction which they haven't done before 7e8756d7ad22. But
> you traced the problem to retrying, not sync compaction itself.

That shows up only when I take the I/O out: tmpfs, every block pinned,
1M empty files. Then every exhausted order-0 refill does a whole-zone
SYNC_FULL pass before it falls back, PSI some runs at 39% against 20%,
and the churn takes 1.3-2.8x as long, five runs each.

What do you prefer here? I don't have strong preference either way.

[1] One thing the pins made me notice. A FOLL_LONGTERM pin migrates
    the page first only for ZONE_MOVABLE, CMA and isolated blocks, see
    folio_is_longterm_pinnable(); a page in a MIGRATE_MOVABLE block in
    ZONE_NORMAL is pinned where it sits, and the block can never be
    made whole for as long as the pin lives. The migration target in
    gup already uses GFP_USER without __GFP_MOVABLE, so a moved page
    lands in a non-movable block.

    Should defrag_mode treat MIGRATE_MOVABLE like ZONE_MOVABLE there and
    move the page out at pin time? Ideally we might want to move it back
    on unpin, but it can be done by compaction too.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

