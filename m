Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97D4C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E046B009B; Mon,  7 Sep 2026 10:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4FB6B009D; Mon,  7 Sep 2026 10:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23E56B00A0; Mon,  7 Sep 2026 10:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1F7F6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:12:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6D58A36BE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:28 +0000 (UTC)
X-FDA: 85187156376.12.ED108C3
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf18.hostedemail.com (Postfix) with ESMTP id C55681C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a SJ9bwQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ndD01nXT;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788790346;
	b=sTcgyKqcr7dueJq/b/Uf/602tKD4DSwXDBbIW1zSNb+kS1rK5pKt8u1V+qxZ/C5EPN3Ddv
	JPPPSz1eImvQdd3i4DUJMrE2nqrOxqMbbvwzUWv10jG1QhZH9+myhBiJPac7Nf9RJwV6eE
	pM/gUQ+2jwS4Vr9yv4zOppeNlvKL/ZM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a SJ9bwQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ndD01nXT;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788790346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umeAJ+zJcQvKDZlRTgQ3GHuC/ov3xHfi3/+4coId5nk=;
	b=B5miKfQ5mtajBDhuNgQf0QkC9+F/vOeTvgFHgElcz6RtNtRNh5fQ3uiLOck1L293K+/a5h
	Q8WUnvR/FkrOYRCa21SCshHao3a1NF45BhfD+ry6vm3ilwmwq8KJ6HSMlkwEbRo7ZVoS0r
	uWF4WFF3gDT3OWuZtOH93/o5p5GaqnM=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 297EA14001AE;
	Mon,  7 Sep 2026 10:12:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 07 Sep 2026 10:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788790346; x=
	1788876746; bh=umeAJ+zJcQvKDZlRTgQ3GHuC/ov3xHfi3/+4coId5nk=; b=a
	SJ9bwQmgeeXzCh+rpvi6NWAt8C0hvIhJum2+soViebhRo6m1VPmiRfXP0KKnYLnZ
	zt89JmR0Biq/0iXIgZBL04O/oukjPQGrgOLb85zu9XDZANUFDqdRlGid1j+Hpk1C
	bErT9d42T2mYILgIbcJqDuzwAe6kI0cCvLoDfZm7rA2esFk2+nxcSyl1k70qqB+p
	xaNxGCcTic46YgoVhMeS6sJlx2Pt+NZ23rTsf2aFt1B/E2VW9x5/y+vzjQZNYI3H
	Ur81z2247HuY0kDtKbHhxFIOPsdT1RSGewN+M3NNPsYVd+JMvnM0QhpCrGO8+yGP
	jd/hePvWAF7z3PP4Da2Mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788790346; x=1788876746; bh=umeAJ+zJcQvKDZlRTgQ3GHuC/ov3xHfi3/+
	4coId5nk=; b=ndD01nXTGRUV2sHHjJwAPiONfchcAnfjXYUIMb9lep4GhVlQGB9
	rXLeS6+Msxq3mzxEJVvMnzvyMasJNLS5pIHDoNqBhI9h7CUgyQFr8dnDYiJOCEH+
	8FymkyGlvYAi3YdD7q4e5H2xWdLe9qWUa/s8+ej3fp0dxhLmtHZDdKrHboizavGQ
	4H5+Qy5Xnxcwy7Hicy+6Jhse+YapElI82yuHjRJsoCvPpuAhtTkU380VqP+f12XT
	O6IvDkEzCKi4/r1maZ0MtJNQNa2VXss4i3ZN7ejgyqDEyKiKAc1aZCqUwF0D30K9
	c0R0lS/Au0i8JHaO+V5OWEAetbGfVd82lUQ==
X-ME-Sender: <xms:R8aeaiRaeJvMbr9Rr4CPkjz2Q3k0yfJEHoO2bi0g0p30uFjqkwSYHA>
    <xme:R8aeaukei0h6ZkdKALZVxwAM679YQNQ2-p2CxNW2llRZ8-DYJHk0lBIrWiWFLIH2N
    TqCWHezjYXY3ppGFBfEZLceyzskHotHFyUx3ltY4RLlyNePZ78vJWw>
X-ME-Received: <xmr:R8aeaowVW0v5jg7BYP2neHE6BAZuGPTkeamZ42LDjc61EZqe8doPtnZjpWE>
X-ME-Proxy-Cause: dmFkZTGoFCFY9lnCBAPkrzJuFdKFm5LgvA7vP2oOkhQ51damXXSrFR8r0fW/T/fEZZCcBS
    cBr66M7WugjCfFCs3yKrXSMBJR0a4lDmZmFFz8Q37pMl3EQtfEnkIjRP7VcLGbiOhAOv8U
    wKll2j8iFpfDXVDN6ZSFUQVgyjIt8i4vrTEo/XZHT9rYzaRSdwqbEKLk368Bdf42v+aX6d
    KDRxz5XSieQJRfWSBQ9w8eLUqCFB7pTB9OFBoZNbHqAP/mirV8lJfQCIGC8yC1mmEx+4HI
    91fxW/JgKt9pXSjBmKJK17bvBRjajPqOce+gw2NdBH0lA4jh8lkZiYgaWT6ccDpGm1hjnX
    sSkiJ58Y3/H58ZvxBdG4tD5bgjmmcWKJAOXnJ9qYu3znkyJbWuSM2PWFWb6zKD3lU48ZYT
    QqsCGndowo9+mKhFjsMTWxQE7n1FAPgdArsKnl5A4vPEpQWMxY4X3tAloBkybQIxXtL3mh
    4PooriQ2tRULx7DoPg1KZnZqKjiBo6Fo0lqtCySrmDkaMlI7H+tYTTbOiQO/iL+lE9d0fJ
    Qdf5RA24R9XGGvXS1W+7ayqZl3vWMF1C6u0vka2phaEfvdCYz10YmPB5mlerXeNt+oIZuf
    DzmMdEVQKf7GAjFnddTTn09jfxA0fc2OX2xjeNAxLr99HmMt87nxd0ybhPdg
X-ME-Proxy: <xmx:R8aeag3ANUhcpofUaDgDUrAFj8kBr4in5ewUjqU1PXhtzqdR5Jz3QA>
    <xmx:R8aeavz2GnundL7MefdCZ7scxQM5oFyO0ggGwowZHiK8z1pNVEwSVw>
    <xmx:R8aeapL5nz9as05vT_tZFHAiORdCT0sBqmARlnW5DTeOxF6eVQ2YiQ>
    <xmx:R8aeat-rrorQQanmUrJGIbipGEDt_WPuccT0HoZL32mzuHbZzvhXGA>
    <xmx:SsaeavvT4IEjEFkBUbui4eNOrDkE6EMxJpfw8kM0MWO22RWLFWrvB_V4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 10:12:23 -0400 (EDT)
Date: Mon, 7 Sep 2026 15:12:21 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, hannes@cmpxchg.org, 
	usama.arif@linux.dev, lance.yang@linux.dev, ziy@nvidia.com, kasong@tencent.com, 
	hughd@google.com, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, ryan.roberts@arm.com, 
	balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/huge_memory: dequeue the deferred split after
 the split freeze
Message-ID: <ap7Fs9DCP3PVOxwY@thinkstation>
References: <20260831091514.1879786-1-kirill@shutemov.name>
 <20260831091514.1879786-3-kirill@shutemov.name>
 <f44181bb-ff82-4537-b2eb-fcbde304d7eb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44181bb-ff82-4537-b2eb-fcbde304d7eb@kernel.org>
X-Rspam-User: 
X-Stat-Signature: f4mgkz8nnfxqaowq9do3g1h4d9mt6d6p
X-Rspamd-Queue-Id: C55681C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788790346-177021
X-HE-Meta: U2FsdGVkX18k+AtcIapbnWLBCRsOuEtDUHohlrhgq7tJZi/+au2n+QYHdWntJy/rvrc+UM14EHxvTO7ZNFgJjFuaAFI44u7K8DQXetj9tZT2APIKxj8DZ2BlCuXEr+5aTJV3nSspIaFqy7q35Ygefj+xC77/qAveK2jfW+2xKxiRvVYGlLlDq8QOu//OvalJlBv21MAZddhd1uEMA0DcqDGq4FwgXNnKAQ+gw06iLOT467WBOOQX8lE8v768U8T9Bzt7utn83uZfuJh1sbms7n51hB3cL2hpmlALUjrdCKO4UgV7SBl8R5KOW2hgiZJ5pdK8Q4FRUj4RaHHBud9F7CaxRhe6Vw5ztpTNtC4/M4IBTui26ldZAruxjyEVisaozoFQpbbLOkiw1fvjd276BR/J9ShVI1T9Z80Ppo3+tKe6kWTjaN6VStQwzRtjoSeND2p4CtD4L7VOVKmpqT3AVHcNP1hg7N9P66OkwhnKkeRw+L5nGz1KUdDI3BdpZcNKveXeNk833adWZBKTjtbwWUq2xKm95+AMkHWBuupxfr2DxC3vPhyQZEe9oF3kpeguWcTQoM8/1ZTuCbNfHFPuXTlmgEOoZuWDHLAHlzVX0SSiIMQGpOGDd4/XjuIpx/VvOADTtut6mUYA5Lsbtccs5ienZ1Iq3s6IMdU+u4nsFUbwDsH91fI/RtD917dKIMfQAuBSFxgvT7wCd/994FTceg0K3l1XE5B+3qqv7SLIe6a9wCYzaJBaUKC9bxGSm6RR/K2m9WQ+YOAq5lbHbcC/d3DfwCOzJfectFWel7nkpEK5kX0H2aEzKS4F/3ZImrth9PdGI6ujY4g1ja+oSaiJcDAIjFdeWonP0XPp3CmOeTAQY+UTQUi3AfPkPDL4r97LPan4phkPdD6jFTBTTJ8JKxeDSqGWlHv0TyHh4yGpVDo4PUpnA/dYWoHNm7lKPpyGItN4YMSznfqe3+ge5Cx
 lrhD6wII
 4vaK4bGsgKJhF0a4FFAzD3cUmY0bxRlK+tNV1dqSMD3cgHEUHGstE0bhhdVrQ30/PceU7a1Fdpq+1YelxqLmcbx1iePQ2HDdAO3KKLsUqEup/ED2+hTvPPGqL2uJHxEFyjAltR0NCS7ubUQqCGXQc36gPvEUw8DZyEvUi2mSmjxElPZxTNI/bfsBLBz/MqcvMDkuDFHHGRGO+oFoOEshpbtZ84RXqPR4FaW9JZgcQcevRa2IPe6ghqJ9QX0HsuL/JjrEG4sgCACG6TZha9yh3q6xskTSBSQG72EsNC+/7JkTfTy2wnuYRsOBGI85G2DXzMeCFYFS5EMpSh5DnXRQZXsA07+IO1JBjv6SNkukWHM9+5XkkCcDCnLKacilla5kRYbvkOkWzgshvG5wO1u3QfUzsdv0agp7kuUvF4TDu+ZwwX34nZOyFA9M5sG4v0ABXlw4ruM0Q+MhoCQObMLdKPbMqGq2e3mMqdpr1oW1jP4YuAQbt8Z5Wcmtr9duSccHqh/30gl3Y/oRKpPIcHbQsyFoP8ucOlVd+dpJaiottk3D2inxx5Rye+bw1df5C8CqkIf3B8RjwiqIUVGC5t55BZyMYIUc4rLaU9/qP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 03:55:53PM +0200, David Hildenbrand (Arm) wrote:
> On 8/31/26 11:15, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > __folio_freeze_and_split_unmapped() takes the deferred split list_lru lock
> > across the freeze. It is only there to stop deferred_split_scan() from
> > touching the folio under split.
> > 
> > With deferred_split_isolate() fixed, the workaround can be dropped.
> > 
> > Unqueue the folio after folio_ref_freeze(), the way
> > __folio_migrate_mapping() does: folio_unqueue_deferred_split() needs a
> > zero refcount and a memcg still set, and both hold there.
> > 
> > If the split is called from deferred_split_scan(), the unqueue is a
> > no-op -- the folio is already removed from the list. But
> > PG_partially_mapped is still set, so it has to be cleared here or
> > MTHP_STAT_NR_ANON_PARTIALLY_MAPPED never comes back down.
> > 
> > Assisted-by: Claude-Code:claude-opus-5
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> >  mm/huge_memory.c | 44 +++++++++++++-------------------------------
> >  1 file changed, 13 insertions(+), 31 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 6281ed993243..c84e8cbc986d 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -3931,41 +3931,27 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> >  	struct folio *end_folio = folio_next(folio);
> >  	struct folio *new_folio, *next;
> >  	int old_order = folio_order(folio);
> > -	struct list_lru_one *lru;
> > -	bool dequeue_deferred;
> >  	int ret = 0;
> >  
> >  	VM_WARN_ON_ONCE(!mapping && end);
> > -	/*
> > -	 * If this folio can be on the deferred split queue, lock out
> > -	 * the shrinker before freezing the ref. If the shrinker sees
> > -	 * a 0-ref folio, it assumes it beat folio_put() to the list
> > -	 * lock and must clean up the LRU state - the same dequeue we
> > -	 * will do below as part of the split.
> > -	 */
> > -	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
> > -	if (dequeue_deferred) {
> > -		struct mem_cgroup *memcg;
> >  
> > -		rcu_read_lock();
> > -		memcg = folio_memcg(folio);
> > -		lru = list_lru_lock(&deferred_split_lru,
> > -				    folio_nid(folio), &memcg);
> > -	}
> 
> Nice cleanup.
> 
> >  	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
> >  		struct swap_cluster_info *ci = NULL;
> >  		struct lruvec *lruvec;
> >  
> > -		if (dequeue_deferred) {
> > -			__list_lru_del(&deferred_split_lru, lru,
> > -				       &folio->_deferred_list, folio_nid(folio));
> > -			if (folio_test_partially_mapped(folio)) {
> > -				folio_clear_partially_mapped(folio);
> > -				mod_mthp_stat(old_order,
> > -					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> > -			}
> > -			list_lru_unlock(lru);
> > -			rcu_read_unlock();
> > +		/* Take off the deferred split queue while frozen and memcg set */
> > +		folio_unqueue_deferred_split(folio);
> > +
> > +		/*
> > +		 * deferred_split_scan() takes the folio off the queue before it
> > +		 * splits it, so the unqueue above finds an empty list and
> > +		 * leaves PG_partially_mapped set.
> > +		 * Clear it here: the flag does not survive the split.
> > +		 */
> > +		if (folio_test_partially_mapped(folio)) {
> > +			folio_clear_partially_mapped(folio);
> > +			mod_mthp_stat(old_order,
> > +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> >  		}
> 
> In general,
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> But I do wonder whether this sequence (that also
> __folio_unqueue_deferred_split()) performs would deserve a small local helper in
> mm/huge_memory.c
> 
> Could be done as a separate cleanup.

Just to be sure, do you want a helper like this:

static void folio_clear_partially_mapped_stat(struct folio *folio)
{
      if (!folio_test_partially_mapped(folio))
              return;

      folio_clear_partially_mapped(folio);
      mod_mthp_stat(folio_order(folio),
                    MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
}

?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

