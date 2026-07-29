Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F78BC54F52
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 02:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E76A6B0088; Tue, 28 Jul 2026 22:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0316B008A; Tue, 28 Jul 2026 22:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5EC6B008C; Tue, 28 Jul 2026 22:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBAF6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:01:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07DC512058B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:01:08 +0000 (UTC)
X-FDA: 85040161416.22.BA9B246
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46698A0013
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:01:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YmtVnAeB;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785290466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og/k718MfI34g9XwAhuwuQilIeorUnfQgYxJimga5lA=;
	b=rANWPOM5rNpIDHdAEl8+nS0Fm2rVWPS0cNyfI4XVP9N6nnr1tgryxZVvQ4Sy7dIgm2q0Sc
	dP0nq4S4Wiv1QmzrFsZwUegx1DAgGgl1KtpsHnd5MFKQPAxvKx0iCgVtZbRQJTVgl7cGBj
	0Iufi9yqeFxESeIJMhZC+ggSTMn0294=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785290466;
	b=vjxB7Z9aoqZ4e/AAso/YIlfPRrT7v4I+JjqSHnnopqf4n8dsUJA8GhxJmRBdgaNUdNiFXS
	GIU7u4BUcRGd9nVaAFvBBNf4vgd8wbgKzLUb0Hb5eYOPO8bruyE7Y468ZhrXvFzTI13A9L
	2KXmuxsRB+54muJUk68UvI0B3mEWqMk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YmtVnAeB;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9305a2121a1so37131485a.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785290465; x=1785895265; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Og/k718MfI34g9XwAhuwuQilIeorUnfQgYxJimga5lA=;
        b=YmtVnAeBA8lglQPqWN9Sy4Yi5THBA94ddLrWldcV4OzN1OlO1quiZvrASwXjuyXxP+
         f1ruH6kAiUlDG3OmfI/xXWOl2TrgaNDi1no0ZThY4fArShh8RFWFC0Eko9psjSJZJ9gF
         YqX1YBRlncuxL2ZNhCKU0WxTgXnUOvtln0vniNbGjZY7hY9Hjk779amRVr3MCOVKgEjN
         5xaDTkIm/05u1fUQRqtkke7CFmTpcHBD+WGF4Uz4pRXPa7XJX57yFBksEyXkpFWnbBeA
         dlj5tHTy6OWUpVDcjrZVGrOH4Pj8ilziswkcOBjNDXu1b2gcRh3GvVMc8aoUc7TSa526
         YvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785290465; x=1785895265;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Og/k718MfI34g9XwAhuwuQilIeorUnfQgYxJimga5lA=;
        b=FoiL62XVGilV4gcdRftGxfqo8fQbfPtuLqHeWZUdLoIPP04RwvB/C8bX5AHnMbUk+F
         6Cw3961MXNdc0H17kKFo4HbnjwqpPIAtGgwwbim3Ts0mauryxzETt1PAadohiy5YmUcb
         YTAusz7p7VCwfVma1E08eMMKNSHZ465H3lFRdfT+RrhZIhK8vuKx1BWjajVu8qdYWmdr
         L93jky3oF5oLzWSz1JOvJjABh2X61EZWeJbQ+do9+BXvQ/HlojrPHDVnK4y2zb7VxdaK
         AvB7EIqD+Bi0cEWbTxiOYDvBwA6Y8mGG1RYhafLyDaH9e1cb0Y2SUNGa26omF/HTZSqR
         bHgw==
X-Gm-Message-State: AOJu0YyPHY51FyPe1YaBlctPCIM90gnm47mXXJRguauaWPzi1lt8LXgM
	rA/6fUc24cUN/6Us5+BebhbJlPMyqtSDkbHYKcTOVkukTquVfqRzGAaA1hlDgYi4X38=
X-Gm-Gg: AR+sD104vQBagcbc10Jgmubme+0S+pM1MI//YZHDPBeAbEuh13hM5MuH8Gmg4HKBMfm
	lUwiHFT4F4oEQNkhxtWMbkMQhZUqlZxir4qlFr9W0dyrKtQMsMgWvk7Glt6S/29H5BDvg41nvji
	c4b5n09Dgsjcxp1jcX1PwJUHD+txl5AbVRRXOy3pqbvemFvod2WFvc3VCgM0k/CsNPUUkZhMCXD
	lvs8a4AMhny3I1pn5gQz+ROxsp8hu5i3ehYDRYtmsOg++TwG2NOgcxbz3/zQmyM9GE0r/zVW4DT
	7EgoUFCPJegpERfg5ufMe5f8VWwGEpMT1kGStGlTWEz72LgmTTmeeo/O1AK30PS7YBHYR/nQ5P4
	IF71Fg6bQ2jYG6XlnVrofww4i8uzQL9c9bNJh5nIyjOfMEGi0bkDAI5Mu5X7+wHVR7ufjn05l+x
	WE4pWOsKMlUNwgqWhqywPtGkDXIrqD/+CTSqqWoPaTgThKqBmlD+XMZGFRYcIClfjgRPMkddpzl
	tFERYWh3sr8SbrMYvZMzqgwCZydXsbxUZQIafSpxHbhwcM9nt9K2SJH
X-Received: by 2002:a05:620a:170d:b0:92e:c118:18b2 with SMTP id af79cd13be357-933027293f1mr509740785a.81.1785290465281;
        Tue, 28 Jul 2026 19:01:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221ac2sm67571885a.3.2026.07.28.19.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 19:01:04 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:01:01 -0400
From: Gregory Price <gourry@gourry.net>
To: SJ Park <sj@kernel.org>
Cc: linux-mm@kvack.org, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in
 damon_get_folio()
Message-ID: <amlZ_6pnt2AC-Ppl@gourry-fedora-PF4VCD3F>
References: <20260728194714.3713735-2-gourry@gourry.net>
 <20260729005036.98063-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729005036.98063-1-sj@kernel.org>
X-Rspamd-Queue-Id: 46698A0013
X-Stat-Signature: 9n15xegxskyo1nq6iccrjh6imn9i36fk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785290466-350514
X-HE-Meta: U2FsdGVkX1+W3L1vbZJITI1ZybOaQ6skP8iQbsbl6eO5Is70rWzqCb9nSIZ0g8/u1z44lOB8OeFVCNt3UC1NTFn0NLestL8KBupSat0BLpCKtkLW4Pj5eGeX1oSXtZlMEpa9sqy6/mPVPbeb1Xcn3745EITYLrdYkVEMLBy0fhS+JqgrMikskO02Hd9QfJFBURZbrUkfFwjp9gE+GKfJNbhBYl7hFuq8GTgtExuCWmDMLqVUG7ifik6zGwscnvAAYmS2qrRCmZmtrBMA1jktIVIf4AkXEJqmio+bScTGPpS5W//+/32hPhCrcX7yAZ9+Wq4mQvvxhb9Neo8rIVZB42Q0zadc1gT6nfgMnb6Cr7fXBeQaSlsqnNLCRvza4PzpEQwIU7ReMG2xXXDZqeH38BIaPLOGHSr9vp4ItHGsn4BUtTp7zPPWFaOi+STMo9BEeZl2NQj1zYgyj15pk1PMF8Vx5Ao+Zfw9yHTA2t8+ONDfpW4vjlfvAow/kaAUfjLbPTV9ojTFDMsWtLVkcps4pcQC4u7LPUibqhzGj4q1AgY2g5fiNvz0cmoahZ4inleabjmTLYqxpqwor4nGlfmzdFZ5WhKHClVjf37LvTYjSsdfYy1AIjQucdOhyFQH83kih7YX3AXdDssvETS86GdBtgVELMS1G4JqNgzGmGzJKHh/znlJXME8t1SzcA5CiiQjX+H13t3Glqeou4M4TkW9vHGragbT7uOLf4rQRH8nBwsdvfZdsns8RqW/YZyAOhBBp7Dr+Y4ddU/CKYsU2q++sIwQJ8dpIQQ/vuZBlIjxNltzSZAvUsLZZX/DNVtdxHbCvzOSoWH42+WenH4s8BJfco8kT3vZAmpP6OhZTZCxkMaErg85VVGCsxr9YMla9KZFVmm4ePXivJJ4sQPXg75240GO9wL2Qcm5h+ymnXcamLYCDC4bbmcL64Sn767kiZRhiLrm24qG9RXeK6TgBzy
 i571bSNL
 RHhwBsx1vRywd37Pzmog5oyaZUYSs8vnmI/qUKKgPRIDWXrA5iw5E7pL9WToHOStG2l48ks8wyf0NJWOqnkW5QYg3SydfyYsnBs58LbG+cDxGhvLADG3KjLXK9f42ktQ2SGySJkXw12HE5f9pMVgMcrbo+WUFElzQIG4SWNGPy0pzVra3ZfvEu+5zNNtDmKfroxiM/NyhDkvVqQfZtpj8HLKKfCeg+p0gf2tJYdobMEsfumAH8Do/NroKPxKL54ETVP69/um0hOND4xPO83n2R000+lVUU3Xev4qG1B5M8fltgANjziQUwAhnduzTzZLbpQLAbvywYOsFLqEIxpbtMZWHt81lo7uvbIas55g1OTJCQZJKfpCXOvbd4HOOcIn4m8YIqcS8BXICYInQ0dWytgHuhW90B8O9A5TyZyOD0GSlQERjhWducy3ahoDlxEqpFfOPNATQpRVxS8Inj7aQQ52sruDhd0Le5ZakCgEwiTHokJwk/PX5kpfuwIRMLGV28Ph0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 05:50:36PM -0700, SJ Park wrote:
> Hi Gregory,
> 
> 
> On Tue, 28 Jul 2026 15:47:11 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > All DAMON physical- and virtual-address operations obtain their folios
> > through damon_get_folio(). That helper already excludes ZONE_DEVICE
> > memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> > this is inconsistent with other callers in mm/ which test explicitly.
> > 
> > Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> > so the guarantee lives in one place and covers every caller uniformly,
> > consistent with other mm walkers that reject zone device folios.
> 
> Thank you for checking this and sharing this nice patch!
> 
> However, I'm not very sure adding a call that not really required for only
> making it looks consistent with others is the right choice.  I'm especially
> concerned if this will confuse future readers including myself.
> 
> If this is a hardening purpose, we have CONFIG_DAMON_DEBUG_SANITY for the
> purpose.  What about using it with a good comment explaining why we doing that?
> 

It's actually two fold:

  1) make zone_device more consistently handled across mm/
  2) make these checks possible to abstract out later

In the private node work - every location that we'd need to filter
folios based on private node membership is a zone_device check.

Where zone device checks are missing (like here) there's some other
implicit reason (specific to zone device) that allows it to be avoided.

I pointed out in the sashiko feedback that DAMON depends on a check
for folio->pgmap in the hotplug code.  This is all quite fragile, and
we can see that at least one patch in this series fixes an actual bug.

It seemed warranted to go audit every service and add the zone_device
checks to make it clear there's a zone device interaction - even if
presently unreachable - should some silent, implicit filter change.

The goal is to come back around and replace these with something like:

    bool folio_allows_mm_op(struct folio *folio,
                            enum node_states feature)
    {
        if (folio_is_zone_device(folio) ||
            !node_state(folio_nid(folio), feature));
    }

    - if (folio_is_zone_device(folio))
    + if (folio_allows_mm_op(folio, N_MEMORY_DAMON))

If we ever get to folios having memdesc flags beyond page flags,
this also gives us a single mm-wide location for these kinds of
checks in the future.

~Gregory

