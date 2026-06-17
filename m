Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E04B9CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 15:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2BD36B00A6; Wed, 17 Jun 2026 11:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5546B00A7; Wed, 17 Jun 2026 11:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4326B00A8; Wed, 17 Jun 2026 11:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 535B26B00A6
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:16:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2D6B12046F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:16:33 +0000 (UTC)
X-FDA: 84889756266.20.4CFC1D9
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5304C000E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:16:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMikzOs2;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781709392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1EDABnUO7dk3OOLt3QzJt4MQGcV67TXHO66KhLr+II=;
	b=jOrjXYsWBvT+w6Wc1auRx4WpUGmUmSWV1lqL6Q91YyQJtWVB3DqzPOnr/ahRdsgGT3ZdCK
	PRTLbRWweYkbjHMB6GYPjvBodBBWfRM1du/T/0CyxYDfWBY+wTWSlfHK0l4IuX2Wlh9ooq
	It0sDpZagZ0gpFgTTK4x9G5wq24GFSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781709392;
	b=XATdc2zMugoBXHAUd+NTTcgzuYa4z9C+7tgyPrgunC+xtXegXKO0mXWdLPJ2F1ouNWh2w8
	D6HiumiyITIatOaSHaa35HVBru5Yc3ANXIRjWcIG7W8CF5ezuIyQuIimE7/b57TuNWJo+c
	Vdcx+o6pQ3gYgQLHGStK6sh3zzzArWo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMikzOs2;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 17 Jun 2026 08:16:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781709389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T1EDABnUO7dk3OOLt3QzJt4MQGcV67TXHO66KhLr+II=;
	b=sMikzOs2acqW9YuE2lSJjfi6RepKsd7IAtK9STpyAyIuvhcZO8Mu+L36rRvtNRfLYe+LbK
	3qU05pACzrNWFuKHF/gDnsd3eCHnd7MMo6CARlEKIyCieoT3W5p7LCehg0Inaeph57o0OB
	eHspCD1lRm999lB2S38Z1I282iG1ATw=
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
Message-ID: <ajK4tyHhTCdyhdap@linux.dev>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev>
 <air7FCRQneIPiJ5l@linux.dev>
 <CAGsJ_4zU=UYOA6MaM6Wsx=yB9r4rta810SUDChO3OcF_EKeW2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zU=UYOA6MaM6Wsx=yB9r4rta810SUDChO3OcF_EKeW2g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D5304C000E
X-Rspam-User: 
X-Stat-Signature: ugtsiihruuopt46ggs819d59ej33t8p7
X-Rspamd-Server: rspam08
X-HE-Tag: 1781709391-445767
X-HE-Meta: U2FsdGVkX1/cYuneLB9lli7WhGdladg1f0hVDTcgGqOPm/jMBbFX9Wi5yzkPVXf2Uti5WC2hk6zTuyPIYmQ4Yt8hL0KtE5iKeQuMh2pVIysnO88bQi90gMi1PWcuxdNJx1yhvGC5s2pVL5+QD38cKmfPjRzeExq2Vjcqlbxvt24xHJPjMoRMxkK4lYDaq8CVOLlQfUEXkQrTKPQFWWlSlIWZwvn4fXy42D10KBAXWHt2ZkgA86SISYX0sKyRu3d3fjhta/xM+8csCZ7xA+7LDTQQB3hlZyKhM0ztcxonbjTY1vpGkjLqTXTUDwMP7j1NF7jK5AOzDdG2mf6yPtRWgHYCvD4sy2vmY8hjiPV7cMJ24TYjpIiNtjdXdsdCgzdL9j83e6/yoCi8nH0YAxlMmY9Uq3UXjdJYQOCVBGzfKgK2aYYcbXuaB7nWa7Rs5NQM7KX6eZHlgrbwvjwuNzn88tD+Uf/nR0fb24hLID63oz1kPnpwNCi3SKS2fYXhpMAm0rFtrqrydbBuW+qG56ajWKddcw1VBedWbyzkRFFysc5OVKRn2P2v1yS3bzYCm8JBdbjcYxSJu6YTQoTcFFMVTjwL3638o4WvB1GMLPVHyTdPKhzxYPMBx3B/8ARYLGxNCh9+zKK1t1lhT41FUE8PRPdtjbO7Ba5PfUxO9GajRmfCgBwcia+LjpdQM/I31YafeMaPwZYdurARhxr2QqdP3oiP0ouL8FaHmLINVVuzO+YenQgcipMQYbaI0GPbCmwHz5/TBzXtBlucuwBzHhzJTHwCTSHfKO/hz/4lcAGztmIUVmcugkbMFjTmPB/NlO8Z15x7P/nAvqibx4Xz5vKTndhpttc4jqZm7P1jcHa2NdDZJF2sMrDMfiExrIi+5r2GMfkUpuJbpD7CWujf10hDHQ+oAwO98RzGKSl8P/m+fhh5vhFHwDygU8Tk41+rfUteFPg5AdciaU/ihn8dkpT
 +heTPGuC
 UMBTJ9jZZQcUUcLeAIIqleIpwEOiAN/gbF89qICmBUSSOSjJmi0FnNPz0OMirOar9W4xaMAFq3xRn/8FY6K03OdDWFuXr/4elU84y9xeN71yLOoajQk6VE2FBMkVgYf7U+//9CBq8CFWReufws3flGM6tra8WuxMuI9DhUT9SVYUd/7I63wBiCy+v0eNol3gEYTfExdpzDxjPF4aaiH6diuyUphE1Xd3Ch76C0hrCiPKICrmTBM0iRHahYB5wBlMVd6qM0SfiU1zGll4jkNa4oqZMr/e4JcIt5WFXGTw37ZW2P5i7/8fO8k3y9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 09:35:04AM +0800, Barry Song wrote:
> On Fri, Jun 12, 2026 at 2:18 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Jun 11, 2026 at 11:09:43AM -0700, Shakeel Butt wrote:
> > > On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > > > We always unconditionally drain the LRU before retrying anon folio
> > > > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > > > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > > > drains.
> > > >
> > > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > > ---
> > > >  mm/memory.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index 56be920c56d7..487a34377a7b 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
> > > >      */
> > > >     if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> > > >             return false;
> > > > -   if (!folio_test_lru(folio))
> > > > +   if (!folio_test_lru(folio)) {
> > > > +           /*
> > > > +            * Assume folio is on lru_cache and holds a cache reference.
> > > > +            */
> > > > +           if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> > > > +                   return false;
> > >
> > > In your experiments, how much amount of drains were reduced due to this specific
> > > check?
> > >
> > > I wonder if that data can motivate to introduce lru_add_drain_folio(folio) which
> > > only drains if the given folio is in the local lru_add cache.
> >
> > Actually if we can peek into lru_add cache and folio_ref_count(folio) is exactly
> > equal to (2 + folio_test_swapcache(folio)) and folio is not on LRU then we can
> > just reuse folio if it is in lru_add cache without draining, right?
> >
> 
> The real problem is that !folio_test_lru(folio) does not tell us
> whether the folio is still sitting in lru_cache, and determining that
> is unlikely to be cheap. We could either scan the lru_cache or add a
> separate flag to indicate lru_cache membership, but neither option
> sounds particularly appealing.

I was thinking of lru_cache scanning. I see this can be 4 cache misses, so might
be expensive. Though if we are draining non-full cache most of the time then it
might be cheaper. Anyways if you don't mind checking the cost that would be
awesome.

