Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD0AD35698
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2C26B0092; Wed, 28 Jan 2026 04:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366A46B0098; Wed, 28 Jan 2026 04:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2481F6B009B; Wed, 28 Jan 2026 04:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB8E6B0092
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:56:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5C681604BF
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:56:49 +0000 (UTC)
X-FDA: 84380918538.11.BDC1234
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id B0C89A0003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:56:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EnodpP0M;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769594207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxRg4wzZcesj+93lNqvgnZRj7Qw2sb28l6iopF01T5s=;
	b=qYep1xiJr0FQMuXXXHe2JE4oWvszDCQao3u83FvzcOjEt2GLIUoxtCLe7jnoiRgR75Uw/J
	EV57Y4uKZtthHrV9lf259/nnk45dYosvOt/zHvdTPm+TIyvxzwyxpvDbx2h0ri7G1BupfX
	kt8UkP+pLJ2g0jSLgPniwEC65k0/4U0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769594207; a=rsa-sha256;
	cv=none;
	b=ts35ekzxNX1U1EG8DodsARLAiXNtPj7rmcL0khswOQhENqGUKk/QEKPCGEswYh6Gt3OkXs
	rxck7xcNAtYXShHfWVQn6hnHPQHSoJzJvYJUaZVpGWPLjuyhNdG2+cYs4Fq5RORyvLqswc
	wIOYOEyt18z7jiGt+aw4BFWBr0Ikd0U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EnodpP0M;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4806f80cac9so2431405e9.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769594206; x=1770199006; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kxRg4wzZcesj+93lNqvgnZRj7Qw2sb28l6iopF01T5s=;
        b=EnodpP0M701WmZa3Mr3aXb0KG3+empm31AOfu54E1oF6ksj4ekR/u5KeBB6vLnFU9m
         wCpxbATNGhdrmbTD0yeTAvmacGahQqd/rBU+GvXuk/HceXBGfxo3xdiTNM1OLf3fYimu
         7w0CXH4vPrf7Pdra4hDZKqoSOE86Z9baiSYRKN7FgSVx+tBbuiMe/OK4Op1rcFUlVsVV
         dLsroS8UHsxS1K0bOgAjNeCsGqWaqZG1e1QASJLlDkRUXjI91tF7xz+8g0G8AIDu/jKP
         cQVn+ciOlL6yHokZSjtdFHxcwJkyFRnvOden6QkTTqlNmF7vyYeb+TnoLWrP4E6AhlHY
         u6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769594206; x=1770199006;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kxRg4wzZcesj+93lNqvgnZRj7Qw2sb28l6iopF01T5s=;
        b=NkAVvoxlR4M3guDYKC2Fry6oNZtkLNxVbDqFbtSBpCTbYNvJNv70EznoX8SnigfQL2
         T3sAhKby4hkV+o6esbdPOnFbdNhaXza3XP1J/KFoeidzsxlxMs6/LvIsQSpQSvcbFIuB
         +d7Q3zxkfXWzybdi2B8TRjVFzimD1tmqBs/gmcE+UQyRd1F4lJ+F8Z937cCSoVbMXwSI
         /WJLU1EOpYIZPZD3MumzXjrkQGc5hPoprh2V5UeibF6TxoU8nLTnz9fexz2v9Xod+dAl
         m6pkmutI3TBkRaLHPq0zeSNmOvsF8V5xuSxK6DjkGSSfj+CL2X0yUKkiYGaDdBTTTyYC
         T4JQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQ8p54QGYn9IePhJq+59LoQkGrQcxq1jY/3gfK/9ESlLWnO1PQPptCgZ38mFEems09D6vyF8/ylQ==@kvack.org
X-Gm-Message-State: AOJu0YzCqRpb1X7bfmQRD5jDrApJvso210DpXCIwIj/NJYlTCX+lT2AC
	/g1fBYMzvt2IN7XsF1d40LIQIotGke/CZXciRSHf/3RWYcM58lhUiWNOpvQ6HfcbNoY=
X-Gm-Gg: AZuq6aI+0bQeuBJsgpd/yp9H5NRBT5xogOhNCQ0W71Epfwfh1mh2zDMuELKb6ujB4c1
	XBBJtoNgO6CxTJeAUF7o/SMhRynuhqTroMiLpjcmZgEuViQflr677MWa8J+X1oiO1WKFaZHcKUV
	gsGsdZmhrEZGZEocP9DpYWadWljwhQjxeJQeJOrwnbiNIYUGWutarLlq9uFaohHCPqgf6Leh5fM
	uY7rR8wyUKF4nAynTJjQ0IJWmxSnJuxCWTSV5zbvcyjIKYhGz/YN/KR0JAomKXGgtXbIwVo449h
	CK4Mafx5OKoe7/MJxd53dBOF+30TTmIMzkCwJ7xOI+NMPQzQ6kR5e0A6AwlaoxwqByhb39D0Pk/
	QyzeLjWNB9o9tud0nZmxoVMPQdtuEwbiYHpkm+Qnj85y4c9BRgjEvmO9xYIEsMqsiGZKdPbdr9I
	HpyvN2uJ9BmMOr+0OWbt81yyA5PT90iSqRcZ8=
X-Received: by 2002:a05:600c:5489:b0:47e:de23:dd6f with SMTP id 5b1f17b1804b1-48069c4a7fbmr55983155e9.12.1769594206010;
        Wed, 28 Jan 2026 01:56:46 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e48a6sm5741401f8f.8.2026.01.28.01.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:56:45 -0800 (PST)
Date: Wed, 28 Jan 2026 10:56:44 +0100
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, bingjiao@google.com
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXndXPMFK2fhLA4p@tiehlicka>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com>
 <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
 <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
 <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: B0C89A0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: sksmytgd7nstwppi3gfpym7noe9wk1e1
X-HE-Tag: 1769594207-224258
X-HE-Meta: U2FsdGVkX1/QIidNh1z/aU6F5PR7zuxd2cEzDABUL5PjCL56BvFLMAAKna28GqE8WNmpeOdtODXEyLxPKJBEuctbPmnslQnijZV8xA/7b3NqREkQ6tev9Pa2RwEmDgzAG7nKZhc9NgUFfD1r6Dxnm2tWm83NNrGRFwmgENTaYuymNc9s/Py/2EXgfhy1SodT3l5cYhCJKupzgLQ+Fg7QVRJE2TH3XPAbp0FxwZI/oyOC2UNKxBupuVkOQydo1s7W4NqiYKdlsK8oSgmqT6hw5GX1+QJ3mX73IVlqxBFM58KGqou/eYBOwyW/g1Rvjv1d3vpifZS6/4KdRG9Wmngqs8ij/kFNbI6xMBGv96c04qPmGAlS/LJGjw6FYr7Hm0/bzLvkKanOgt48aBI+dzAnII17SamS9aNtcmLf/qyTG8qyg4WU4JbPOsG3K+YJwFw6VzWPVFHMFcsn6fTYWB8/uqczNvgGnu6XSfQK2ArX6TYGe9VGocdpF6HLbtxMqpqzUBWbfDThA7zqrjC0BHM1Bm2BHRGRpP3Tiz5EkJ87Q/JC2oKofqd2oveoepzEDCXQh8CipgUNFlxbbAlnXOyMziE/JMpVBXhcdHq9wWFkVtxH3xPz+rrqKHI8/SfVcz8Cg5HyZRsqz5FCGoyG+EghWoTZ8wKFIh/uE6cBn++M8Y+YcjEQ4+afSOz5LWqwDaoooFhA4NfzjWGDiP0Hhv9kWDlaucvTAkqxMKk6gLFLkxENybyDfhaVDnpdt8NZ8ZAw5NRrT/u2zkL0qRpyHctPJlfdITymXDyjIOprBzVjNqzY9qVR+9kvO/vNWT+k7u3kxlPEGps9gdb35VI+Y588T+b9iwdUDMQXZgMUNOK9w9BPMrASBsP4BO6gp1F9j8w1kIv8TuRno6gP1AT26fVhCxtcWmIIPe+Yj2Wv7dTwz9v/yfmEJpHqifrhQ/vCZ4mHZ6oV5Eu6DgA4SWPHMdA
 QgPpmbaY
 T+KJaYVhR2eax1oQR69uSK2V0qDKITjV3JaeyZRQLdTMi3Q7FN+P0Mtu+TaZs8Cliqy0gtgwLlrcVnwOnag1fWAjwWEvHkmKrVfs+iVxyA1psWDRdRueONqyWZsmLrBqYr31hs3uaWFrRzt0FUeDcrEC2UkTnxL/EzvCYQlx3GZpMsXiffVoDjhuYd4nmLz07ZHZz7B/RmNd7lLKay5CTwiFyiDT+UQuL41NiaQ7qaQMUAAWMUmpldROVlV5ruj2V36BidnRAzaHiYF8scnkYE34XbDwPM8q+R182CCRb9yOYgTpe30WKGpoxdG+CJsdU4eL7R8Zknlynek73t4sEKGfSCIg/PL1WASyzfviAhxf/jYJLhDo836GcDOOKPNsG3A6GDtEUkB2TeU15AbgqBQVDiBAOyyuvyMREHSzhOo1sQTNonR7BPl7sTz1HS2tyYmzX1Png0+A/tFFrFy03Vgu1Fd+t+aKe5f3tsSWIfZ3dTZvQiWRWSZxkyxeCqjySB2SnqpTODBoFrtssNBBZWVZUBYRgwRlY4G8P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 27-01-26 15:24:36, Gregory Price wrote:
> On Sat, Jan 10, 2026 at 10:55:02PM +0900, Akinobu Mita wrote:
> > 2026年1月10日(土) 1:08 Gregory Price <gourry@gourry.net>:
> > >
> > > > +     for_each_node_mask(nid, allowed_mask) {
> > > > +             int z;
> > > > +             struct zone *zone;
> > > > +             struct pglist_data *pgdat = NODE_DATA(nid);
> > > > +
> > > > +             for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
> > > > +                     if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
> > > > +                                             ZONE_MOVABLE, 0))
> > >
> > > Why does this only check zone movable?
> > 
> > Here, zone_watermark_ok() checks the free memory for all zones from 0 to
> > MAX_NR_ZONES - 1.
> > There is no strong reason to pass ZONE_MOVABLE as the highest_zoneidx
> > argument every time zone_watermark_ok() is called; I can change it if an
> > appropriate value is found.
> > In v1, highest_zoneidx was "sc ? sc->reclaim_idx : MAX_NR_ZONES - 1"
> > 
> > > Also, would this also limit pressure-signal to invoke reclaim when
> > > there is still swap space available?  Should demotion not be a pressure
> > > source for triggering harder reclaim?
> > 
> > Since can_reclaim_anon_pages() checks whether there is free space on the swap
> > device before checking with can_demote(), I think the negative impact of this
> > change will be small. However, since I have not been able to confirm the
> > behavior when a swap device is available, I would like to correctly understand
> > the impact.
> 
> Something else is going on here
> 
> See demote_folio_list and alloc_demote_folio
> 
> static unsigned int demote_folio_list(struct list_head *demote_folios,
>                                       struct pglist_data *pgdat,
>                                       struct mem_cgroup *memcg)
> {
>         struct migration_target_control mtc = {
>                  */
>                 .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>                         __GFP_NOMEMALLOC | GFP_NOWAIT,
>         };
> }
> 
> static struct folio *alloc_demote_folio(struct folio *src,
>                 unsigned long private)
> {
> 	/* Only attempt to demote to the preferred node */
>         mtc->nmask = NULL;
>         mtc->gfp_mask |= __GFP_THISNODE;
>         dst = alloc_migration_target(src, (unsigned long)mtc);
>         if (dst)
>                 return dst;
> 
> 	/* Now attempt to demote to any node in the lower tier */
>         mtc->gfp_mask &= ~__GFP_THISNODE;
>         mtc->nmask = allowed_mask;
>         return alloc_migration_target(src, (unsigned long)mtc);
> }
> 
> 
> /*
> * %__GFP_RECLAIM is shorthand to allow/forbid both direct and kswapd reclaim.
> */
> 
> 
> You basically shouldn't be hitting any reclaim behavior at all, and if

This will trigger kswapd so there will be background reclaim demoting
from those lower tiers.

> the target nodes are actually under various watermarks, you should be
> getting allocation failures and quick-outs from the demotion logic.
> 
> i.e. you should be seeing OOM happen
> 
> When I dug in far enough I found this:
> 
> static struct folio *alloc_demote_folio(struct folio *src,
>                 unsigned long private)
> {
> ...
>         dst = alloc_migration_target(src, (unsigned long)mtc);
> }
> 
> struct folio *alloc_migration_target(struct folio *src, unsigned long private)
> {
>         
> ...
>         if (folio_test_hugetlb(src)) {
>                 struct hstate *h = folio_hstate(src);
> 
>                 gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
>                 return alloc_hugetlb_folio_nodemask(h, nid, ...)
> 	}
> }
> 
> static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_mask)
> {
>         gfp_t modified_mask = htlb_alloc_mask(h);
> 
>         /* Some callers might want to enforce node */
>         modified_mask |= (gfp_mask & __GFP_THISNODE);
> 
>         modified_mask |= (gfp_mask & __GFP_NOWARN);
> 
>         return modified_mask;
> }
> 
> /* Movability of hugepages depends on migration support. */
> static inline gfp_t htlb_alloc_mask(struct hstate *h)
> {
>         gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
> 
>         gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
> 
>         return gfp;
> }
> 
> #define GFP_USER        (__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
> #define GFP_HIGHUSER    (GFP_USER | __GFP_HIGHMEM)
> #define GFP_HIGHUSER_MOVABLE    (GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKIP_KASAN)
> 
> 
> If we try to move a hugepage, we start including __GFP_RECLAIM again -
> regardless of whether HIGHUSER_MOVABLE or HIGHUSER is used.
> 
> 
> Any chance you are using hugetlb on this system?  This looks like a
> clear bug, but it may not be what you're experiencing.

Hugetlb pages are not sitting on LRU lists so they are not participating
in the demotion.

Or maybe I missed your point.
-- 
Michal Hocko
SUSE Labs

