Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A730BF9D0F6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 00:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE45B6B0092; Tue, 14 Apr 2026 20:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94106B0093; Tue, 14 Apr 2026 20:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A98D6B0095; Tue, 14 Apr 2026 20:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84AAB6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:47:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1345C160311
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:47:35 +0000 (UTC)
X-FDA: 84658952070.20.7D2D880
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 213DB16000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:47:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iiExjr+5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776214053; a=rsa-sha256;
	cv=none;
	b=Jt2I9S+CQMHnPPEYOmRvmy3kJj9a247SmMLv+9Dw7OsdQtqAeX0N0cwPUOyBL6UVau9OOV
	0XDYHsAz/JjEs0niQr/EkQAB14lFlmYKJR8FBTlfavmkW9tB66ljbV6bsdEf/ImgwZOXp8
	/HR0GIIRDftW9snsYVRf9DZMH21DG0Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iiExjr+5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776214053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDf0JysG1bA2y77OxrgeizzszHGnVBp+pEg8WZw72Mw=;
	b=NYg93QNepuq8mFSwDVaz9Bh6CXoTkMlmX80kYVEllrYygzFs2cCVdz4M1pEHb3Jhk5PHUp
	luHTqQqSr8oU6dhgWbsU6wUxpiJ6uClT64gjkkHeazoQT2szeFOSVNBFrjhN/szw5g0/Kq
	Lxj1iLRRxmlLdAq7ND3F27oJU1Ixn+A=
Message-ID: <6c0ab55e-a687-4ad1-b18e-b4ca97305a44@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776214051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lDf0JysG1bA2y77OxrgeizzszHGnVBp+pEg8WZw72Mw=;
	b=iiExjr+5cyazYBdLoBH2BKE5Gka46VW0z+r9c197tf4RVyo84nfsuVGttJBEWHHZvSNywl
	EN+qGzgOaW4AOzSSIAxwkJmrvNZm69sW4DFbX+t7PQJBIlD+DhzDPWRNZO+KNmmsoD6wks
	wgX1p02r1vgBb2Shym8RQoJ+ApLkfio=
Date: Wed, 15 Apr 2026 08:47:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] mm/vmstat: simplify folio stat APIs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ye Liu <liuye@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20260414091527.2970844-1-ye.liu@linux.dev>
 <ad4-kpPTPqOuDF_E@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <ad4-kpPTPqOuDF_E@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 213DB16000F
X-Stat-Signature: urzp99pfhqtbp99gqx8dczuqsbu89m86
X-HE-Tag: 1776214052-414052
X-HE-Meta: U2FsdGVkX18kcjjyOrWCgSuee0FyFKFKzrC4mb6BbaGF3oXwNwQ2NoZzvQJ0z0zKu5I27BLx4z48xjCDOH16MNtyfY61BsUnYu80gMR7BzKjbOmgMCo/etGMfPRa7cUU19cazy71IMA2e7lzgjZHpg0Xkz18vxV+dte2C1rIqd3iFvnVGR/BoKJ56cPHmNZM5JxQ3qRhznhH88LxjvAiy1OM8Z8iQE/KPUUFDwqfZKsFrKD1h9dflDNeaCqqN6bs/2dZbwIuwxDP5RIhgsuS3gYtuBzw2zj6ebrLDTiH6cR5PITT5jlmBBduzXReHQwDf4Ub/GSs3Z3rTnDgaWUPxc7hu1Ba7Csv0g7trAJFrJpG3/JAg3gWabsbOXb9L9FHuOnNzMfV3oJRiKFWq+OH1eAC6xkpzTh5u1lsi25BrIIqmg3/MbDZEjvLNPBDo6tP4ezDPFUfExqV9Vmep70vdRPlcdlkEqavQHIvSJ3u1H2zHSoeI1AwIGLYGBNG45bwettl/PryUEUEbZsfFrqbOC/Kl4h+ReqP3kVc9SR36JO5zHNAEdlNsQClNvwVzx4wh6gbEYtSqmHBfQqai0LrYn5DAFoO/DL/o7lsSvToFkmdlQ6TJV8ZxhgwWkcHLjfXR53FPJsVM4v4tG1+b/R8nh4c2UB2qKs5n4GtM2IMFtjQc5n2lqAupPbV+1dcqYqGGi2dEBkCi0vtd27BQwmheqnqeq/C0v6UiqNCJcwjQjzEDzOquP5f0CTiADCvo29FGaLODfTNtBgD/0Db3kPE2u5jPQ79MvpzsGHb7siJeYt9L0OdBlvt7Dg5kLc5alEGTLl34z8LV1m7flWxZmoViWVRZH6yvgoMRpbEtknKutV9qQXxBGtKju3vrtWiifhJlkJ/rmrvzyA89EQ1x0XdbYk2J6BmGO9+ACm3xD7TTUWMIT8jEAu58+6A3RODeogCh3LiNSr83+y97CkzXia
 xFFN5sTs
 05RVZdu6WDFgSMENsPZTc+IaUwmD36Upoir+jgzql20FDIekAt/rt7E4C5l+rpko++O6K7fxtZB770mwhNtP+eUZ3sXEhSHoH0w8r3SrAYoCuxnoQmMV1g/W+2PvLrtm640tMs0eCaZxCWnc358enNODmgsf1uTMoMh+HzDbOs2o2s0WnJhYrjX62HpqGGtLC4stDPD8QzYG0ISlr2LDgPcCJdy/64WM/iYLVY7OjC9dUxUw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/14 21:18, Matthew Wilcox 写道:
> On Tue, Apr 14, 2026 at 05:15:17PM +0800, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> This series simplifies folio statistics accounting by:
>> 1. Replacing node_stat_mod_folio/zone_stat_mod_folio with more semantic
>>    add_folio/sub_folio functions
>> 2. Removing unused __node_stat_* and __zone_stat_* wrapper functions
> 
> I'm not convinced this is the right approach.  We've often computed
> folio_nr_pages() for use by several different functions, and you're
> making us recompute it.


Thank you for your feedback, Matthew. I acknowledge that this change may
introduce additional calls to folio_nr_pages() in some cases where the
value was previously computed once and reused. However, the new
add_folio/sub_folio functions provide clearer semantics, explicitly
indicating that we're accounting for the entire folio rather than
potentially partial pages. The overhead of recomputing folio_nr_pages()
is minimal in most scenarios, and the improved readability and reduced
argument passing outweigh this concern.

-- 
Thanks,
Ye Liu


