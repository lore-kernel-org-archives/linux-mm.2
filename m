Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652D3C55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA9E6B008C; Thu, 30 Jul 2026 08:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56BED6B0093; Thu, 30 Jul 2026 08:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B306B0096; Thu, 30 Jul 2026 08:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EAA16B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:40:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9E43A0125
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:40:00 +0000 (UTC)
X-FDA: 85045400160.10.E785F76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB65710000A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:39:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjGo0+ef;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785415199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWd1k8EXIqwmRQHt1JMH5oDb5WZp1Mtdat7Fpqf7Ea8=;
	b=FVb6p6NAn2goTXm3M/RCjRvvil0lX8ZNlIShTNUO8wiQ+gj7hDCfXatw2WTMWzP6QJjPau
	QEMWrCY4+PLOAXoW1WeU7QfdsB6ad8bulWtUQDKFOqh7QzfpzBh+sYEowXviMX4jZGI8oZ
	M9Xy8WwxeLuviQ2c5plmtn8iK6nZjQo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjGo0+ef;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785415199;
	b=wNVgnhkfnxN9gGgcm7q/3WF0xKEImCHAxZnM7HnoLmslfCmzRf8l71lnnx/YfPtr+6gtqq
	mfpoy0oJoJoFSkaPdM3jCG92YYGp8jDVk2qB2tUEXRt7GLR/c3AnGK1zm1qmwVixow1Gu6
	zWPqWlgi/HjrcWYoNic0DbCWWNqo0zk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 334D14371B;
	Thu, 30 Jul 2026 12:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBADA1F00A3D;
	Thu, 30 Jul 2026 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785415198;
	bh=EWd1k8EXIqwmRQHt1JMH5oDb5WZp1Mtdat7Fpqf7Ea8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JjGo0+ef6V7aGBLPT5F6flIjmLAIVBu7nXTqOXTO5IewpJ5zjLsOqQ/jeDmpRppDP
	 Ck1UcyOGvG5OFSJ0FyGlNR/jiDcssR0+7uWYI1i+j0CU4dtCu0z/ZOwtsLuhShuBPz
	 yHCpJdgyzBbx0nsAc9QgZW87nAn1jEDg4d/Wo42hDqUWr8+yvtCMPhULD3+BZG2Oie
	 ElkNXvxNs1I0BZm67/yZwDr7Rv6ti/MAblPee+0lf8KbmIWxBhEflKuFxSrqB37l82
	 CGA/kgO5cW6hAsk5dTLTrXHeqwIRcuk8btez7hGCF8WntkdR0BjjvUF/QjOtdBdPSd
	 AXWHuBGrqqRfw==
Message-ID: <1acb7ba0-6aff-4d30-9554-283ac8fbc93f@kernel.org>
Date: Thu, 30 Jul 2026 14:39:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module
 parameter
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Pratyush Mallick <pratmal@google.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, sj@kernel.org,
 corbet@lwn.net, skhan@linuxfoundation.org, anshuman.khandual@arm.com,
 gthelen@google.com, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, rppt@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260727230545.262579-1-pratmal@google.com>
 <amiN82J8p5z9l_Rm@lucifer> <91b61f02-c533-41b9-b680-7de52a5c6918@kernel.org>
 <CALHaPKeOs25YNRg60+NxfS3E5RYLt5hJqFNX02ZCEBrjcDua0Q@mail.gmail.com>
 <amsYVFfJmOs-Hy90@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amsYVFfJmOs-Hy90@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB65710000A
X-Stat-Signature: mtr1t9se91acbhw3bgutisa13eiin6pj
X-HE-Tag: 1785415198-799191
X-HE-Meta: U2FsdGVkX19GxKO6yXkiSoK6z1MD5SFlHhANTJ7ohyKIsBR4Jz83kQBb9LlvrS7dHOdDkHuvUKDdABH63sCz+8vOIsRUutS/UDZgAL0lqTxNy9E/kaD4w7GhvJZgIku2ypfB3lfIPKfxdg9zhQVbP1PTHnRkJ0UOx6bSBbSpju+06os8DTRiMJaTvmZFMSM9qfC5noV8UNC0nmYBRDS7SeBPC2Ui0GZmpO7U7RkZelZ0sDeHbSPlD5gPZc1449hIyMOV3EbBT1pDfFVir+lpJ8VYL3fTQwgIMNRWcsGdYcbI+WVIkJHDBujXTc24sQ6v+DNtbUoTCCxqhPSrmuIKQar2zmPefnyezadV0FesWQy3j57qSOf+SovHnsyMZcvu6Ju7o6sYxWw4YrZPOfFlWJrKDyaDjvf4apB1dRWqn4bVQ8w087RVmVyinGWJN5HtOdeeEfKulDfRWSYJ/Y50bvL3TSazDRZzcv7JBcBLI1MbbEwp23bdNQIuhO/16WIEulD4UjYxIulVvQavKCdcwM8DpfKMRu3QZxQf76nn5ql5VU1wZvwwN4lIOBaiCb0fvEjEVsw7aH3kQGFJpfA8K18rgVjI8Bf0QMvaWrhVPS2VKiOrjyT9bUyYAjt1OnfI5OiTd4Iw4RTaiaReDVTbkq2CTroNhNIVGxJs3IdWO976I0NrSbjmgQHqxN+bxVFBDFaqKtbC1fxSvJRKtYhjb51BY7typfXwnAeGi0WpOzXqhzwhrkIwmF5j3bAswvFaluQrMbuEejb20XkjLyzo2dJy8tB8lQVQncWw9kBwe3fpLamS/kxTRtSD5bIUkGKS3j46mfpvUbGFdI5QMRbz5E51XIwb1HDoetuC2WI0joPAB5fnywAztK5D3gAz3fFxi+TVAMjxCoO35/1hBcnd0EmcOvw66ybTBIWVubuYiCWfBHVqEnvwV82DXPrf0bKZ9GAI8Y2QW+g+bPtV7DZ
 WB65TjwW
 kGOtMHq3NcITZwmHC0OPbqwaap8B05bR/0tPa7ek4sXhoN5WLimemBPHrON1it26RjmCHmF7eJRGsj+quHQqFz9XCo7WrYo6YE5G+EHQ9KTI0ZM09601ikzOuYhARuDQb+qWxGkVhD/s8iDtIxibu+thU9Lt3bdVd5KQfoxthROXR68SOtBk1lgNjgLHh18cX/YPV59sEa+wg1YDVEZg3xFtpm0wpnwJ8TzReSIicHuWcK0Fz8KffGfKJLvmKW8xgF9JLBVCgXHBNzhWGUfkKNzDeii2J/fsmRbpa1nkKsLveZmNPEj5tdtt/8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> With 2s, we wait 2s before we start reporting immediately by kicking the
>>> workqueue immediately.
>>>
>>> So "0" does not mean "report all the time", rather "start reporting immediately
>>> as we are notified about a pageblock to report".
> 
> No, it's whenever pageblock_order is specified, defaulting to a pageblock.
> 
> But I guess in practice fine.
> 
> There's fun like this in virtio_balloon.c btw:
> 
> 		/*
> 		 * The default page reporting order is @pageblock_order, which
> 		 * corresponds to 512MB in size on ARM64 when 64KB base page
> 		 * size is used. The page reporting won't be triggered if the
> 		 * freeing page can't come up with a free area like that huge.
> 		 * So we specify the page reporting order to 5, corresponding
> 		 * to 2MB. It helps to avoid THP splitting if 4KB base page
> 		 * size is used by host.
> 		 *
> 		 * Ideally, the page reporting order is selected based on the
> 		 * host's base page size. However, it needs more work to report
> 		 * that value. The hard-coded order would be fine currently.
> 		 */
> #if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
> 		vb->pr_dev_info.order = 5;
> #endif

Yes, it's really about "a large chunk of memory was freed". On 64k " a large
chunk" is unfortunately order 5 == 2MiB (so the same as on 4k where a pageblock
is 2M).

-- 
Cheers,

David

