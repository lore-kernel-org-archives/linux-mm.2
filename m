Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47455C54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 157616B0088; Wed, 29 Jul 2026 22:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8E96B008A; Wed, 29 Jul 2026 22:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15546B008C; Wed, 29 Jul 2026 22:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2A166B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:36:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58F3614089C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:36:20 +0000 (UTC)
X-FDA: 85043878920.21.62C71DA
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 769C5180002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:36:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="C/s8CGrN";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785378978;
	b=dduriXHFbopYKVchB41JmJ7J6WjFritnG1CK1FEu6XOWLtfiRJv/hy3qzGya2laYqmAWbS
	VdtOtiL2nJIM6xo7Wx71HNun3ki+SA/w4Hg6q9OV5L/V3Uta6faAwq33VZ5F3pmGezl/7/
	V9v8wRIhmbZ4NMfoU1S50s96oTAF/BE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="C/s8CGrN";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785378978;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cMQizCo6RK2ppBslsu0qkK2klwa/3pjLSR8m78mm9U=;
	b=7qcxAZx6yC9QjNmsCJm+hA1fhAkbkYh/dac3NoMspr+X0/o9TAWGRKpchBK3bDogMopCw+
	kj0ffvFsrhi8jejQf84cpB4LJ+fZyutYRyc395zA9eeZMos6jGcnRjpU0r+7MSmChdK+Al
	tRkjT0woFTzNFzDmLooWrRtn7PLVcwg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-69c7ab350e9so2625534a12.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785378977; x=1785983777; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4cMQizCo6RK2ppBslsu0qkK2klwa/3pjLSR8m78mm9U=;
        b=C/s8CGrNuDHyMuiKmfpcRNLE6MM5K43w6J29jYB1cW7wA8Uhmm3BO4009bcS4PCFHo
         Ko8cKfgC1dr36nLo4V9xlu5atR1fvIHAq2T8kQWI6AMINqQ8mnnXyPXwuW55sUfDB7wQ
         zh/3NeWeE4o51FgLcsGxalDVR9X5KC9DQQKfhrd4HtAJVwjYxSe6V/0z0jGb6SnoSwVq
         ZSmp5q3EARwC9DN5Q1EukA2be1c21r1CHtmj3Di5FCxY6OcvrjUnLoQVWD8YyytTmuzR
         Sm+JMESERb4WBhyXxMk56U7Mf+JzirZDOVyjMZ8jE8XJBS5axjU4seNrnc7U8KGQ4x5+
         R4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785378977; x=1785983777;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4cMQizCo6RK2ppBslsu0qkK2klwa/3pjLSR8m78mm9U=;
        b=PVnRmImvkWlmPav/Mu6lGACqkbRxCimGsqqJHhBnf85PWP8ECCzI9zYxuFKoDVCzPN
         r8pEjmKARah0OaGl1lZ+Q5YZ0gienB2Y1syBI4GP3CVkKVdPm1sVgxU5dJzFvT6l+HGv
         rQo8Gcn3QokwDOLNL2cvdbjZX+LJcLUlsqn/f9e+CfIGJOMGi5g+FpvBFhQm9ruOAH/0
         UjLeQrCxUoRoi3egPJGeIDXh8QAxHKhppG6+2oWvP6j/TVc+bfp49RumIPQpa0qVRu2q
         J6WM5CQ3FbdTeJHpvBma6t7m2h0gXPb4H77iVQ5dHbRE0d3lXjnwqSLcbrsooOn3mvek
         MOuA==
X-Forwarded-Encrypted: i=1; AHgh+Ro+tvT6KH8AizlMCP6ejCsKl/WnWBlpr2PV7dKYM95DpRTEsEs5C6Q4nr5NA0O3EqMmxlLqApbpmQ==@kvack.org
X-Gm-Message-State: AOJu0YxNGuMgnl26uIxdbtsvw87A9XBD6rf8B3sZZJ9GrJOnyf3n7gYm
	2vH/epYr7Hji7BQ+GTCSG0NFLGc4FZCdHqCirSAWQ2vP2ICZ6lZkloYh
X-Gm-Gg: AR+sD11ER4QhfIc5XrH22wbh+JgDhpvjUCxkNOGUr3TwYVALFtEIqC1G5UBp6on2JVX
	mlQvbVSPhmuclkxEe3PiSTXk+G99s9uFB/WHqBcPwVKfjYHtBAr5vHQYsOMtJfHiiBS4o7eov1g
	F9b94z767/TW15jYFyInmoIAjZsoZldogqByBmAetlj4yVwxoRBdRh13TbbnAdrFFpb7qh/4Vv2
	xjVvvt0BzEK5+CJfe6g3ZzQxsdLjUJ9SBx+0RNbNlM+5lzov2RWsd+VXuR4773aXAKfiEK/T3gq
	49iHVSK0cigtErxvdGuzw3W4MZlzMi8/37nlfP2WWX5X5pb5t9n/az67+LSjIw+vqqeCylU/E41
	ji9CIb9LZp05Id3CFcrFHW0G/ZMsTN+ViBZfolB/bik4VAF9lLVPLXuHCAQwZ70ozaM3i93CKlv
	9aBFHVKSIUMBbp2Z0hmiSeklc5XZb/pf/66VREZDfNOoImPQMFed5Xy7LV/z2l
X-Received: by 2002:a17:907:3cd5:b0:c16:36ef:d437 with SMTP id a640c23a62f3a-c1fa55ce077mr39208166b.34.1785378976749;
        Wed, 29 Jul 2026 19:36:16 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa851b723sm16110366b.12.2026.07.29.19.36.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2026 19:36:16 -0700 (PDT)
Date: Thu, 30 Jul 2026 02:36:14 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Liu, Yuan1" <yuan1.liu@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	"Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Message-ID: <20260730023614.fasdjzfl5wz4tsfr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-3-yuan1.liu@intel.com>
 <20260725024952.65lfm2s676obpoue@master>
 <MW4PR11MB6936598686BD5FA7B2FE9181A3CC2@MW4PR11MB6936.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB6936598686BD5FA7B2FE9181A3CC2@MW4PR11MB6936.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: j4dihr8prehbzkmabuczaiy5bg4x1z8q
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 769C5180002
X-Rspam-User: 
X-HE-Tag: 1785378978-670071
X-HE-Meta: U2FsdGVkX1/mLQCIXwzc1W7KyFB2+fGfgIdrkSaqJw9mPz5rL1A+JQBW8CTy7use/8ALfWwwf+4dhQet2/r7D18piFl+AkD2F0Sc25Oo/415Cpn8F4/Wu/BRwSE0OsmugFc15zlZOYQsPhI9+YwJ1rnaj3OrxA1mOeHuGHDH/vCFH5OciSKlYTSFb1VubYXi3pUvaEGyqhwT1PFpB3iheLPArGZZ9hbWOh5bY/2/Fb+MsMwLIQyPmwhXn9bOQwjRx93M2FAnhObOVZQDQ0jJoKDC1O4tCWGoOH1yMVbrCv0BvKeOEU6XAFK+DA1DNlF5eSGPQim25eZ5ovyXE3ZcAcNYYZrfhEj+GhyOx+ehx5J2HMtzAW2afrHv/55TvpoEKADOX8rMzpr1au6er3pKXrUEktvWMQgD2bdNgV3tj3TryHZQv6v6qhrxTEU/84NUOib7rjCpqOcgxdP/Nv4Equ6ED8Vi3UL94KYdW4Urcd7iZa8aZZjxQWv9dfn8d5o6X2K09RsK8SgOlcZYelc2fBmc8dquH9ZVytGfJIfUpVpjXDfdv2baE5/T79mvyyZ7UDT5Ws4z7gmOuuaTFil9tH33WrIqt1rQrovtpvOnISDpSSXfUv5Z65x85wxAUCdjWBGipT8ZSO4IArO8KBVcFJvYnLV9/hjcm0lSsQkkjfuO3Gt2Su2m6LY8uf0TGJuEVCx+uDlOl3pgseCZSihRUEoBS/JxSzp6FTVmRHVCjxS0yx0SJfKRHt/1MKSzs3wTPwUY67bepEnpXC7yNgOmpIl7EDPMgupszgCHZBJZot2nVijQjLjPIpLYuxiIT9JX8mS4Zm8QPNKwupdivgvmHWuXMCiDMd3I6Tq4XkxnPeiUFDojxf4wlvLsfl4Ei4NFCKuBCdfN39fyigTnDWnaNdoqDGSp4zmBUeKdBeDdE736wlNliX9rbX+KD5RTfHZb9ha7FoRFOXkRiKgP+Om
 /XxM75NL
 KG6BuNKa1N+WbL1EWLzHkEGLPpIGGBMJviyAdwqvZ0viU5NElXYbIj7ErY22W33QPnJ14pKYydAQW2QFTa5EJ5yGl9Hd02261tk24ZIO3Ns549PJ/eQX45VYSpGpZGaAA7Ilhe1L+cfFOPnB0sMtW0GtX7Cm630yA5FfX2Kv3LUhFryruph3NOzKZti0SbtS2envGagzscBxJkJqlbHWsDWbJlAqwgM8MmFkEKxCba8S1dFv8XULIlBTC60AAv48Hjt8PTzsIvz7wGrrnBZuv1EjQbxa0GqM+ivU3Pnv054BdaIxC+EDJAg2uBeYFT0GCRRr5R7ssAHWcn6kVzngjpdIvgrQc68qM9NEZj320HSiwj+EL/0lPwIQ3R+3zaInghQ7j+nQQv3C7JZ87jE5xUOwbg8hDwUR405j37t1mOOQQ9aFiU8sqnIT29Wtc1+7O08hGtUQxtUhJRJin8kHOR6FEEXJRcpLfGX+NPEDsffWPdYI3Mg/Te9qzB4s0bqIk8ib2OZGnJeQ773ClTyVcGy8WblrartHz0YhLHyrJLh+ZzsC4XXEw3k3L6pI0rQ4v/v1G1ooHs0ww7dCqznQEX4zlQet9VcvujTftoFz9nofN9yTGNjXQtEDbhXV/DkzQEWS40rgHuYb+cVfPzqEKHmC3DmXC1GOOSNMn9lrb4eeX7iynDt0pC+5qMcuXNLJTD+9AWop4y6hM66EO/gOWGqnr8UifVbHELimeIzjAi0OeNQMbA5JpRt6O6MEy1K6TfweZ1pn8RBh3NkRCrnd4d6kscjlo9j4NKUPliAKqLWhERHdDlnKkKH88MuwuEc/YN7OPLPXQuPu83N1DF4GGfM0VD55boeqKoPnIatiCq/yTmgr8Y8jFBHvM7PEm7EoW3kYCAMHvIXH2ngF88lKZzGsIdOoMHSzTkA41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 09:49:39AM +0000, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Sent: Saturday, July 25, 2026 10:50 AM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>
>> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
>> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
>> <richard.weiyang@gmail.com>; linux-mm@kvack.org; Zou, Nanhai
>> <nanhai.zou@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
>> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jason
>> <jason.zeng@intel.com>; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
>> subsection boundary checks
>> 
>> On Thu, Jul 23, 2026 at 04:49:46AM -0400, Yuan Liu wrote:
>> >When shrinking a zone span after removing a PFN range,
>> >find_smallest_section_pfn() and find_biggest_section_pfn()
>> >only checked one edge PFN in each subsection for nid/zone matching.
>> >
>> >If a memory or hole boundary falls in the middle of a subsection,
>> >that edge PFN may belong to a different nid/zone, causing the helpers
>> >to miss a valid PFN within that subsection.
>> >
>> >Fix this by checking both subsection edge PFNs for nid/zone matching.
>> >Keep a single pfn_to_online_page() check per subsection, since online
>> >state is the same for all PFNs in a subsection.
>> >
>> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> >---
>> > mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
>> > 1 file changed, 27 insertions(+), 15 deletions(-)
>> >
>> >diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> >index 4c699fd9c479..3a281d595207 100644
>> >--- a/mm/memory_hotplug.c
>> >+++ b/mm/memory_hotplug.c
>> >@@ -427,17 +427,24 @@ static unsigned long find_smallest_section_pfn(int
>> nid, struct zone *zone,
>> > 				     unsigned long start_pfn,
>> > 				     unsigned long end_pfn)
>> > {
>> >-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>> >-		if (unlikely(!pfn_to_online_page(start_pfn)))
>> >-			continue;
>> >+	unsigned long next_pfn;
>> >
>> >-		if (unlikely(pfn_to_nid(start_pfn) != nid))
>> >-			continue;
>> >+	for (; start_pfn < end_pfn; start_pfn = next_pfn) {
>> >+		unsigned long tail_pfn;
>> >
>> >-		if (zone != page_zone(pfn_to_page(start_pfn)))
>> >+		next_pfn = start_pfn + PAGES_PER_SUBSECTION;
>> >+		tail_pfn = next_pfn - 1;
>> >+
>> >+		if (unlikely(!pfn_to_online_page(start_pfn)))
>> > 			continue;
>> >
>> >-		return start_pfn;
>> >+		if (likely(pfn_to_nid(start_pfn) == nid) &&
>> >+		    zone == page_zone(pfn_to_page(start_pfn)))
>> >+			return start_pfn;
>> >+
>> >+		if (likely(pfn_to_nid(tail_pfn) == nid) &&
>> >+		    zone == page_zone(pfn_to_page(tail_pfn)))
>> >+			return start_pfn;
>> 
>> Here we are checking range [start_pfn, tail_pfn]. When we come here, it
>> means
>> start_pfn's nid or zone doesn't match our expectation. But if tail_pfn
>> does,
>> why it still return start_pfn?
>
>Hi Wei
>
>If start_pfn falls into a hole while tail_pfn still belongs to a valid
>memblock in this zone, skipping the subsection would cause
>shrink_zone_span() to shrink the zone span too aggressively, excluding
>valid PFNs from the zone.
>
>Since init_unavailable_range() initializes hole pages with the correct
>zone/nid, the start_pfn check always succeeds here, making the tail_pfn
>check redundant today.
>
>That said, I wonder if it is still worth keeping this check so that
>shrink_zone_span() does not depend on how hole pages are initialized.
>

Looks reasonable.

I search the discussion history, and found David suggest this fix in [1] with
following statement.

  Well, unless we have an odd case where the hole+memory starts in the
  middle of a "PAGES_PER_SUBSECTION". That would already be problematic if
  memory starts/ends in the middle of a PAGES_PER_SUBSECTION chunk. I
  don't such a case exists.
  
  We could improve shrink_zone_span() to let
  find_smallest_section_pfn/find_biggest_section_pfn test the pfn_to_nid()
  and page_zone() not on;y on the smallest/highest pfn, but also on the
  highest/smallest PFN in a PAGES_PER_SUBSECTION chunk.

I am trying to understand the exact case David described, but not fully get
it. Would you mind describing more, so we would make sure not missing the
point.

[1]: https://lore.kernel.org/all/e86fee84-08d8-4563-8596-e40d8e196799@kernel.org/T/#u

-- 
Wei Yang
Help you, Help me

