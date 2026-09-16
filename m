Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BADA2C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9692C6B0092; Wed, 16 Sep 2026 09:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918BB6B0093; Wed, 16 Sep 2026 09:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F646B0095; Wed, 16 Sep 2026 09:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA3C6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:57:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5CAF1A0727
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:57:49 +0000 (UTC)
X-FDA: 85219778658.08.C0075AB
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf21.hostedemail.com (Postfix) with ESMTP id 04BFB1C0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:57:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kGYBo4qn;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kGYBo4qn;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789567068;
	b=H8An2ieefTOtfWV71rWD3LE/PWQ4ko8IZfVGsVNOJzZsJBmZOU1e9EA+plSzGXfpp8o7jX
	gR124bIKl0V74wXaoERsMMxtGjaano0dkUSZPONW0VVXQggwmd0cz3PWwlp4pqMiIgYOrj
	52/0YKLJ8Pxvy/1mS63QjTuRazMc18o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789567068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgUHPiwSi16km0SbObf2vOYCgqHRbxyVwtkEbeNTtkE=;
	b=HUAXPMbaGZEb9wVYxkLT8cylya71pn3yQVdQ4PUaZeTh7d9VxApe1/C7wiLylt5d+zzoRk
	g6BqU0eM5vHvYDlTRnTDSwFy6rzhb8mRhC5ha+d8PtrzAdhuW5lQpYE6LJi7xlDwOgJ9lH
	woaunm8JB/uoaRyMYZPK+oGx8YoAOoM=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9105d241693so8665046d6.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789567067; x=1790171867; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NgUHPiwSi16km0SbObf2vOYCgqHRbxyVwtkEbeNTtkE=;
        b=kGYBo4qniZNsS/TdYe2Kj7XLbGRasxlL4WnD6lzvFdAP0ROjuQgpR5kPDp97s4CHXa
         BmGBCElTs+mW2sS/29a1y/JtyNO0QsVgTDZiwMVmTK2d9UenFu+keg4CmiFqlOMkpcK+
         lAS41Y3lgRLwmqaKh/7Kat2JcdnBFXk/aO+/Jd7Hqf+NOOLixYeDyLm0ny/qrxCqlLmy
         YtZVqEFPgzlpCqKv8iiUJNM2BssMpbIYM3gQfGE6C13sHkcs5u/GFfRWsolMAnCCuLL7
         wSanpqIQWTYEyuXMj5IZtnlPRWaooubsYcK8eYca88XkLbpM+d7BHz5vVqEnMvIJRoPI
         21kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789567067; x=1790171867;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NgUHPiwSi16km0SbObf2vOYCgqHRbxyVwtkEbeNTtkE=;
        b=v5ONLR7yILpQofZ5SUdoyr+VbgJOzcIq0gcHo0BemuP43nHtgtqS288QxNMxYJ6T3S
         3z0SOk//MN+cbHaZ4Vn7I71URHwmMtokVaTeOxIJiP9iGATADtJJN1PFq14fWYlCfdpJ
         YYUAh3gmTeQKSfkjGVfakGvR9BEF86U5Gt1A0mt+/et5G17G8SEb4rbTgWvkDbWl5vIY
         I0jjhRzpjm3BGF6VzAg+AG1375mS3XcL8DjLrE2VhMF1TwQevVDd11KQWesZ+zOZ6ZHe
         8dx364aUVM5sfC1cYCd84VoWq5ag0PHqzGV4n2OiCGt6OyCN19BubCFEYLoafe5XKomB
         2dhw==
X-Gm-Message-State: AFuF++mYvrHBKcJysbWocE8baY2lS57JI7c6sahegXhMJSUOrxTW5IsY
	H2O5bbgYj4PPmSESazzzTJ2Cd6OFpcQvaTWX7AAjoE05EeYbrYw35bE1qrjb0WgwMYU=
X-Gm-Gg: AYBFou2/ijMCtHxY4nNiiOVVNmbuHKVdgSvEUjza0G/D1WHgFs7+GQlyaVIeAJkql96
	l1lNMlpOCVTNhY9z3W6zhGVuNeHtMCP03jR94OzM+CLUeGgmYLjY2VqA78s9vrOj5nlQn2Je4pH
	dmjlriJINg0lP0Zwxx8pINSaUuInjjx3ZCK6RF2zw7p9cLGOQbjFNd3PEUoVyKwpQASJNSTow5t
	ji7K0SvzZtCPF0WldCA9g2ud6EGPGF+ZlUmX0HoyfoVoNdgBWqu+mF+HJJ95KyVu6v1OwYP37R9
	JwFdPcjaTqfhwwFoPhGcKH/aP62AzO2JumISU3b2+wY0sB5GA1fb1zkGZWWxQoFeCAHNW77Hu6P
	ZSDdLDt9aGy2cTq7c1KZuX02//R0CUN4V5YF0wLGJ1ujCkP1LHklbOATp2gsijhhk/4kssoNbyu
	4e5wpfftsEaXQmaMdv+sOJdIkRFC4R7AwPPS6ytqfUnEGTRPqDbj1pVPGoieA2uHznwrL8iRkj0
	ZTugXtCXkH/G0sjDYEO7HtdeXcuplWRySCZG2hL9S5/0WTPBZx5yC0=
X-Received: by 2002:a05:6214:5902:b0:910:3452:d57f with SMTP id 6a1803df08f44-9123d7b5209mr61354706d6.31.1789567067054;
        Wed, 16 Sep 2026 06:57:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beeec67sm26377736d6.48.2026.09.16.06.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 06:57:46 -0700 (PDT)
Date: Wed, 16 Sep 2026 09:57:44 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
 <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqqTbGMJL86TzDrf@gremlin>
X-Rspam-User: 
X-Rspamd-Queue-Id: 04BFB1C0006
X-Stat-Signature: d9885ttg9n73s18efjfwnw6scnq53su1
X-Rspamd-Server: rspam01
X-HE-Tag: 1789567067-397059
X-HE-Meta: U2FsdGVkX18GZyc0hp44LK8fDm2yPjDxWgn3jvQ2pFN2DTdLs4PfK+Yvxsi11p3+2zC88eTuMidRfre3Bb7rlxFW0JVYXAAAltyxkqpnd1YSzP8bFQwgkQlJYNYSPLQ3Ghp1e6FUQvQc2uZkQSNrYhl9XnbQ/oWzm5LAMRj0eMq6RErPK5jfEH48dQr+/2r6fqYYgYyq2hzW7wg9Vw92+Km1+P9BZy/NjEgLAsXocY9zxG1dh2ch6/SP1ywT0ZJPIki2HIaYS+gSbtOFFs3rG/AbnUe92Bjn9m+Iv37UVQwQWsS0bJCAgLtneyf4isKEIyUT7ZRyBew8rPETywbAaSVC6avimQod2fbS5GMLX7VF99tmhRUUHsXSWjRyNlu9NkbX2Z1p3RH65jevspsudT+s/Z3TtdaaXXlSsqwZTNQZXZZrCj6RhLOAbN3t8eGafVtqsi1yJqZ2cuUqwHiirxLBR36sOnP7Gq5SrILLO/7PQ5C6GEnHaEb7zZB8xQ4eorh4v+kFAeZHdaqqgqbW2JsHO6eqKdSg1NrMP3SQOOfVmpuNl/PW/G4Gy2H9KdFXrS0NPtl7Gt4GOqfJz9nHEir5pXqcbDK/ul8Lv2bMuhHqmNG9MDmhRsczIjQoN91eNhZL6/eNtuhph1hmVsPaxri+MGEDeqbjWjMWb9y37jGRylpTMVMhFmHmcIOj01NiSn1AWnd2IqI/HW9mXGoA5bAgAoeyIUaBofM3MGzOcr9zCYGwWftNIeocd5lBAb/FXFvT+AHtDsCb5UMpF77ey7n/RdWWHlSlTYVlguDCRs3IieUeJB2R0PgXVAxsdZUJpjqEPDfZxXFpIFlKxnGw/x4uKL8UGWKJ1kra/xvRsxmvfCEQEFq1uQzXhIWAlRG6i1Uyv0/tGkKADMM5vgzIDW1EUlJfhMobDyzewAFQJyBsJImdDUMDndk2S22YPpR0qvA63z/29VnC3iyRW5c
 hMq8pv5n
 4+t47a3pfbKaJVjHYyfbepYKJLpU+ccO6eFpDnn4Hqbb3r4DzfTrYZAyHpsxHEmOuhJVT8CpI+SUOtyMeYtm8y6+zQZ7Jc3CyTO8xYvQ6PXmNa8F7jFZawOY1oOZNEHTzWXEqn7+OrIgGKg7+/lKMvWR2/yujXt//F98M6Et9fe8KaRSvv+3+cA2ACX5ilPtAlGmNkaNzNhdlAF1XpQ2HYtmd+jmYZd7UA1SFkx5Eu8OQBytEuDHzIAmHwNmtTvmk2e9zUfA0atnAG7ABrPqi+d8gSPWkplQyPtMzdbeOCcJeyFo4ZMDVIf8/M88QJqNl59UxOIGDLkP1eX1J1DwsKdY4lTVGhHJ6Tf1j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 02:03:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 15, 2026 at 01:12:03PM -0400, Gregory Price wrote:
> > On Tue, Sep 15, 2026 at 04:55:47PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Sat, Sep 12, 2026 at 07:08:32AM -0400, Gregory Price wrote:
> > > > MADV_PAGEOUT collects isolated folios on a local list before reclaiming
> > > > them after the PTE walk.  The reschedule path drops the PTE lock and then
> > > > restarts the mapping with pte_offset_map_lock().
> > >
> > > Is this reschedule path even necessary? It's pretty bloody sketchy.
> > >
> > > I thought the modern approach (TM) was to not do cond_resched() and friends so
> > > can we actually look at removing this?
> > >
> >
> > Sorry - meant to reply to this.
> >
> > Honestly there's so much jammed into this function i can't give you a
> > straight answer. I can take a short detour to figure out if we can
> > rework this as a whole.
> 
> s/short detour/long journey through hell/ perhaps? :P ;)
> 

Not as much as you'd think.

I did it yesterday and left an agent to validate it overnight with
existing in-tree tests, LTP tests, and added some new tests.

The naming could use some work (cold_or_pageout -> lru_op, bleh),
but new call graph / pseudo-code:

• walk_page_range_vma()
  └── madvise_lru_op_pmd()              [PMD callback]
      │
      ├── PMD is a huge mapping
      │   └── madvise_lru_op_huge_pmd()
      │       ├── acquire PMD lock
      │       ├── madvise_lru_op_huge_pmd_locked()
      │       │   ├── process whole folio, or
      │       │   └── return locked+referenced split candidate
      │       ├── release PMD lock
      │       └── split folio / reclaim isolated folios
      │
      └── PMD points to a PTE table
          └── madvise_lru_op_ptes()
              ├── map PTE table and acquire PTL
              ├── madvise_lru_op_pte_range_locked()
              │   └── madvise_lru_op_pte_batch_locked()
              │       ├── process one folio/PTE batch, or
              │       └── return locked+referenced split candidate
              ├── leave lazy-MMU mode
              ├── unmap PTE table and release PTL
              ├── split candidate if necessary
              ├── reclaim isolated folios
              └── reschedule and restart from current address if necessary

Looks like a normal table walk now.  Significantly easier to review and
doesn't make my eyes vomit. (there's still an ifdef wart, but it's not
mid-function anymore... so that's nice).

Going to spend a little more time testing and tweaking before I post it.

I've been working on a making more extensive unit tests for certain
parts of mm/ and this might be a good time to look at whether I can
introduce a piece of it.

~Gregory

