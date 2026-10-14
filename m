Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F894CC6B24
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC326B008C; Wed, 14 Oct 2026 03:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794736B0092; Wed, 14 Oct 2026 03:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682956B0095; Wed, 14 Oct 2026 03:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47AB26B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:28:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3F5B80451
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:28:43 +0000 (UTC)
X-FDA: 85320404526.27.98A1DC8
Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB4C8180006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:28:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ad/jrMpR";
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791962922;
	b=kf0tAPLK0A95paZwneU3YsrIfk5FSRRj53SGBl2Nz+28uj+821UIVUF7yqv/BsYeuD4aMo
	ADkaJqBNO3BP/tFqEhDZWZPu0Qym0PFMx8E+SxPrSKzvKOQEQlBKCbaRawoXhbKGzNosMl
	per2/DnQ4OyzUGVlcsxQZcEAeBMiSBk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ad/jrMpR";
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.150 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791962922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+BZb7N4NKQleaa9lq5bugXGnOz/dEyA9NxnEh5TVvc=;
	b=62x+x231lkb+q2LyMfO/TwgSGnEJ3Wm268nRdOyui/Bn4o+9O755ZrRxoSPj+pxEv7USgU
	XCs19NnRGoY9AffG44Nz9Ah/7bHQzBBwlcVLvcfugSICeDW+EspxAe5oEczU60yWp4ZpcX
	XodXRv51W4pzF6QPaOeSHrG9AuYNwYU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HzoLGn/NBj6P08TgEbWS0zGGjXPm8raRSAmF5JjEaBo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791962919; v=1; x=1792567719;
 b=Ad/jrMpRjKf2WeQ2dpoXSBFj/Zau33YvpnZT987xq4x3KVLkAi/FJJBoJcyG9jSaa8jrVQ/r
 gbNp7xkDmNXuu9JP43flf3rDmxOVco66OchFyYVD/uooW2ugBTrbbBbuFV1nITJKzK0eiXbXArF
 Z1egrm/XsLWJ9g/WTkVOskM0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 853cf23eb73e70bf;
	Wed, 14 Oct 2026 07:28:38 +0000
X-Mizu-Trace-ID: 853cf23eb73e70bf
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 15:28:35 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Klara Modin <klarasmodin@gmail.com>, Baoquan He <hebaoquan@kylinos.cn>,
	linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com,
	baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase
 I)
Message-ID: <as8vI5DzXAZgelws@MiWiFi-R3L-srv>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora>
 <565e1744-54ff-4daf-ac14-7b6c49fd3fa2@kernel.org>
 <as33VMjNRIZOG5Ua@MiWiFi-R3L-srv>
 <d6209813-d53e-428c-90a9-6404618d0804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6209813-d53e-428c-90a9-6404618d0804@kernel.org>
X-Stat-Signature: i7fhwxuddrw3newyymzxpizw5q8g8y9u
X-Rspamd-Queue-Id: CB4C8180006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791962921-274039
X-HE-Meta: U2FsdGVkX19qFNskXP4PB6UDz/TEM8UiOnNXd8JsRUWfK14p61RhrmGBN4RLhDWW9l7L8LqIEJw9NBsfDvM3sKIKIqo4e+5Jrl0EnzvXsBlOlDLgP3MFdvaZBml5Hi0gipFvndv9aMhxxST9KGm2zIY/kFhLBdRSzJKQVFgNpUUKs++p7Gh2uFfKJHKgfJG96HGuUTn66I30otsQiLJ+h9k5i/osh7geJhm0q814OqI+oKBeVbPbwt9vuAz/d1wgDLES1E1RTPktmrtF0p6ngQsW7xmu0CmKt1DgKg9TpkGl4NAvVPlO3KXwFmmgm4vH/zHkT9pJ2+6YvtHDxQqeU6SCvYQ0sU2pn3fXfirG24XRiLQbxzr5bqOZ8C8GLIx1fUb1yH8wTF3G83vOz5/qYwOdCayaWth3JCjw1Krtlxm67RgEMrFMq7R0g6nfyh8wVLIpSGFIRB+xNI7gHE7uKpN/DzYXc6P/1dvnyorssiI9KX+Zt1Y0HPDtCSzudlCSONiPA0DUtrICkS/kJ/WJgJR69XxB189kVa+OTeWKTiPtOmCBCGzUOV5bSr5MxQeAXycK1POELz8ZiMP8a+AADBMeIB5HAFrzmCOJiXsXxLx4lhZkP201o2q8ptRuIZ5Xbcu0wuMPE/l+x4H4TViUBplnxEXqKy9OS/yGfsXJzXbOhrlMwf3BI62OZv+iwE7eZitBL+0BQC9QUCDxtt0c95Rp5ynEagM+F4ozMAbwjXOFbe5oOtAJELtayR3z0a2LLgvRFMUBJApUkqnKwl6HtCSHgLUViRVD8WDTGYfuJ2VLHl9tgIdqkkkMpFklZ0IhcBLwRTRsNsk4e3YBcugk1XuTle/8R3sSz1yJsJK85YyA7rhK0z30NMJT7yUlQ2s0gNSimG34uPotxeo9Kifek9+A74ZQkmzTHDqQsCcr3gf07dfyFy7APtm10y/jHvrK7/W+z9Q28WrfdWY0EwN
 gFDtDKFw
 S7Osixu8GO1Q2vRmK1TYTAkmrotISlS15JueOe6NII97l3l7Dv18rzTXpKLjM9LFytWnjP/XYB5rB1pMJoOF+ycS2XMImG+RNFkPCESTJ2i7D4syW8VlSDE1ZO+iEUlgDtMERacXkqCDs7iaxOkJd2hEYiPYOxAyS47OUMcnjd9dN+VtbdkuqZROvXeE/+H2F3RPpNawLAWlFlcMMJx7wE9A8CLgZFF8F0RTafWHoOS10U2Vdr4l6u0fubw8fBDfcEMgccEwYGlqWHCMrgK22FvkgyHxTb0aYcHMqiqzle+lm20920e34LOSvQZMG4oO/cvCHcwGLTzNmaP7XL9Ch+pV0K/yWrFxVXK4b/gS6bsZgtMieFjKw+yrSW05Qbq8nXk0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 at 05:08pm, David Hildenbrand (Arm) wrote:
> On 10/13/26 11:18, Baoquan He wrote:
> > On 10/12/26 at 03:44pm, David Hildenbrand (Arm) wrote:
> >> On 10/12/26 11:16, Baoquan He wrote:
> >>> Hi Klara,
> >>>
> >>> ...snip...
> >>>
> >>> Thanks a lot for careful reviewing, and sorry for late reply.
> >>>
> >>> ...snip...
> >>>
> >>> Thanks for the comment.
> >>>
> >>> Here xswap.max= is a global boot parameter, while not a per-device or
> >>> runtie knob. It sets the space space (si->max) of the xswap device
> >>> at boot and can't change at runtime. So on the two places: the size is
> >>> a global setting, fixed at boot; the priority is per device, it is in
> >>> the create interface. They are different things.
> >>>
> >>> The default is 2xRAM. From our earlier discussion, this is the largest
> >>> size we think is sensible, and in practice I don't think it is not
> >>> reachable in reality. If a system has swapped out 70% of its memory, and
> >>> even more at 100%, it is already doubtful that it can still function
> >>> normally. So 2xRAM is an upper bound, not a target.
> >>
> >> I remember some overcommitted hypervisor setups where people swapped out
> >> significantly more -- without any issues.
> >>
> >> For example, Windows VMs initialize all VM memory when booting up. Afterwards,
> >> you might just have plenty of memory that was touched once but will not really
> >> be used in any near future.
> >>
> >> So I would consider some crazy hypervisor scenarios as well where people
> >> commonly have significant cold memory that is currently not hot (not in the
> >> working set) but might possibly used in some distant future.
> > 
> > Hi David,
> > 
> > Thanks a lot for the valuable input. This is probably the first first-hand
> > information I have heard about a production environment. And Klara
> > measured about 160% of RAM in zswap on her RISC-V box, so the 2xRAM default
> > is reachable in practice, not just in theory.
> > 
> > So I see 2xRAM as a default, not as a cap. xswap.max= already overrides it.
> > After your comment and Klara's numbers, I am open to a larger default, or to
> > a "max" value for the address space. The real limit is still the backing:
> > the zswap pool plus the block devices. The address space should no longer
> > be the limiting factor.
> > 
> > By the way, in Windows-VM case you mentioned, is there a block swap backend,
> > or is it zswap alone? If it is zswap alone, the knob that matters is
> > zswap.max_pool_percent, because it sets how much cold memory the pool can
> > hold.
> 
> Excellent question: I don't remember all the details. There were talks about
> over-committing up to 400%, and people played with both zswap and zram to
> avoid/reduce IO.
> 
> I assume as a safety net people would always look for an additional swap backend
> (that's what I remember, but I don't recall all the details).

I see, thanks. I will take this as a real use case and think how to
handle it.

