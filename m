Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C59C5C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A3E6B0092; Wed, 19 Aug 2026 11:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FAED6B0093; Wed, 19 Aug 2026 11:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9136B0095; Wed, 19 Aug 2026 11:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 167416B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:43:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BEF74026D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:43:40 +0000 (UTC)
X-FDA: 85118439000.27.0560041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D812980002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:43:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJgTEOEc;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787154218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38JhnhHXecQ6hRRQfHnTqEwVWVkxH6ubOJI2lsidQN0=;
	b=1g6LJKi+gieJEwmMiT5EmQ7aUsjK1BDYV2plNroAbFhkMaHr6nWgP0aFXEPxkNLo48aEhX
	8Q6Nj2zLc0tSEdIB15Xc3a/aqyiqkmYHWfGFKbJVjGp1x/21YOGiTJMJk9RUWITvEf/Yma
	IOpI8pF06bNrfv3yxbJ6wscJgin4RsA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VJgTEOEc;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787154218;
	b=al01Cy/DPtvg+fExyOKcyQtmWM9rgt04uRUZEFaZmhXO+o0tM/lVwu9M+eo8M3YmZ67IMN
	HHl/rZgElVlaOJEYQQwGviACrboiJT9e2/BTQQPi56JW2KviqYrY6NiiKrmWVqzusTFt6d
	qIzRwKNYM/d2Xyib9DH5lKKRSGU4pzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DF2760DB5;
	Wed, 19 Aug 2026 15:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511971F000E9;
	Wed, 19 Aug 2026 15:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787154218;
	bh=38JhnhHXecQ6hRRQfHnTqEwVWVkxH6ubOJI2lsidQN0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VJgTEOEcslv7heA9gjgAu/iGr2yaBO6vB/pN2zKgXLJhTIgm94p5S0H/kvBwGj5+q
	 m/DYpEd/YI7DwEGcll0WxUCvGPohSWN8IuSLwPjy7SqncmGauBYgy8b2QgF+3g5UV5
	 KbaSZ4Fdm+DluAgWk4O8iGc3rf7giL/kRYGz0xQHvTE+tL3apP5cmXyns1WwZu8eSx
	 QkxgEQ3gskFSf5eXEscBm5FLz/R3EGBY8oxKkEPpoSD8Tc/Tcg167y5yzbrWk14Pt8
	 q1RAGvhQuMoOHs1L2phIvgtKADNze9FVY14/L9nsAiJu6VK0zCs9CL21TgZanRarNw
	 Av+Vg0Iu2QV+w==
Message-ID: <dfdacdac-fa1d-47c3-8d22-abdbd8c43ab8@kernel.org>
Date: Wed, 19 Aug 2026 17:43:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: Mike Rapoport <rppt@kernel.org>, Yuan Liu <yuan1.liu@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 Chen Yu <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, linux-kernel@vger.kernel.org
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
 <20260818085702.3395529-3-yuan1.liu@intel.com> <aoXEBCWQ-a9OB_YE@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aoXEBCWQ-a9OB_YE@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D812980002
X-Stat-Signature: kibfg88efggaghbnw4qszgqkmyftocnx
X-Rspam-User: 
X-HE-Tag: 1787154218-95188
X-HE-Meta: U2FsdGVkX19/++DLZwLmDVldxy9P4TDmgCe6gjp9dhCl5sC1igN5uQDb/JLojE7RL2N9hSPZdSCCf5TuvcbRz4kzOmpAd8Zne5vWgXPZ43SBkRi4Zt18VAddA2GFYIWnHfmTKi1I2t6bgJZ75rNKsIXtkb9Xr8E0mS77UWH93JhuMd3eiW4bKaJ6bClAJfvE53PYKY8Ohd1O8zmZNhGQ7XKXKUnAml1Rs4qBPqVpyZIzlBFFxEnLpUPuvAnD9r0s8KuUMTT+oRkQmTK/6TXJNgdpvQza17nRkxgzN1UA3I89OWZjGnHKrp8/2BYdDyKlFnCAIZeA6i8boZ6mSRbTgx81YJMDVXzP+Od8AckfoxvK/ovWAKFmmqcN3No6cQoXfOHGIyCUFRDm5DKM667JwUboTLZ23Dgh2dHMvcI2I62/FH1eNkK7bjJDe3Xw0kvYBkpW/zXExWnvQ4NbY5mmHn3747lwWb0y6cVN2ofktuOQFftqvqvoxfN4O+XrRDVwGc0GCwikkVOh2VgamfVvTCRy66PnW+C0KaYuC9zLROj9ELurRblRMgZBGJlUyhKbEvb2OO0ebhgkts8OuQQlLNjuilS27p1R4XEQYQD4/EVUxhETWaVeyH+KABAp+Q8oHIrR3Fv/aAgFHWDcVB9zu03YNMOyyOKkZeh0HW+sLHT38z4e18yOYkz5VrYdXpkslHz9gPg3wSc7o/qM1Hov4PqfTSYJ/wd3dk7PkRSLpjzDhQ/5Bp9VBmyxvGRbc/vpMcbQRZMYD4pk3/zd2Hh4hXBWpcwhMTcBVpRKj6AbDAO8kSSMNq5Eq8XwMFPDn2KnBB352ZaXVNPqC2fA7vX/0ltLDkgEDRRcz8s1fNxy5j4psuQcLIxFgJ76hcHexQzzFbHEDzpq284RWkQeEGOQbkgw+PYjTx1lnnpTwuNLd0rxz2gYSBvrmv+U3zGGlZ9EUmqlq42NrpmJzJNeyFg
 dG+dpbbs
 O2mi3E74piNDp4l866pkwRmKblUh0IE7CvAv8cxD3jRf5YEW3fABeV1dcgEzyfoTa8Y3Pq0FaqLb681Q8BGxd/OjmegKjKoIRR45jqnSBkR9sl1rLNkEChzy6ul3BpWwISnzqrYdNxD8DkpP6uJk1VTSFgN1uLcM/BtOisvIxnbxKzNYg1A6rI2SaCivXDETWd4TfTizrCJ0+ger+pJ0rfCarx6fyMgEZSzoRUmOzqXSaK2XbxLYgBE1m+/jg6kyX1TrmHaW3jKzMUx+227+9e075LAlMZ/mHJWKzEQQato4h5+oahosvDEzWK/H0X1yAorz4p36qJUQ09SBFUaOeWndTsZFbUkBCw9XR4MZYEB/ZtEWAJNSBRpUmwNKImcGvYZ2a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/19/26 16:56, Mike Rapoport wrote:
> On Tue, Aug 18, 2026 at 04:57:02AM -0400, Yuan Liu wrote:
>> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
>> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
>> to rebuild zone->contiguous. For large zones this is a significant cost
>> during memory hotplug and hot-unplug.
>>
>> Add a new zone member, pages_with_online_memmap, that tracks the
>> number of pages within the zone span that have an online memory map,
>> including present pages and memory holes whose memory map has been
>> initialized and for which pfn_to_online_page() succeeds.
>>
>> For early boot memory, pages_with_online_memmap is calculated in
>> memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
>> included in pages_with_online_memmap, and hole PFNs for which
>> pfn_to_online_page() succeeds are also counted in
>> init_unavailable_range().
> 
> In what scenario it is possible that pfn_to_online_page() would fail at
> that point?
pfn_to_online_page()==false even though pfn_valid()==true in case we have a
subsection-sized hole in an early section.

-- 
Cheers,

David

