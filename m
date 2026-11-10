Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF72606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cz//o2m1
Received: by kanga.kvack.org (Postfix)
	id B564D6B05B9; Tue, 10 Nov 2026 09:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D096B05BA; Tue, 10 Nov 2026 09:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BF26B05BB; Tue, 10 Nov 2026 09:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 829856B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:39:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D4068091B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:39:22 +0000 (UTC)
X-FDA: 85419467364.24.47F7D9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D41B940003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:39:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cz//o2m1";
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xGvOJLWQhllaVLukgTz+i4tETD+3mmWO2tAkOXX1BM=;
	b=2vUaIqUtc9Mtt/XEGvJqwdlibWpxja09P2eKXoJqO3GtmvkAKXP9gJAP/pJKXltn9B4jWl
	sPgJ6DyFrff1ybUcfxTke3OUuFPfjv0fQabS9Sqio6/9P+PhDkm5Yt7iksqay1vZ1rH3Vs
	pJfU1k2eka0LSXHjhqRUqze75O/JpC4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cz//o2m1";
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321561;
	b=CsJRWCauBWhkr1xVIxHqvnJSfIT3TNTLogHPCUB/ejp/LP+2LbP5nhu4x3pie5+nDP4iKY
	Pajvrilnvq4iupyZkJy8uQDL0oBosSy9N9n7s4rF0VtFRrKLOMevZv8uXnZq+hlVMPTE6V
	ZV2akvByaAPzmzP3wquXCZ/WIeWyvPM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 104E84067E;
	Tue, 10 Nov 2026 14:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6721F0089F;
	Tue, 10 Nov 2026 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321559;
	bh=3xGvOJLWQhllaVLukgTz+i4tETD+3mmWO2tAkOXX1BM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cz//o2m1vDWGkNLoGL1DsXDe6cKey5guPiaVnFD8xr2NwO8innlcJgvWZcAW4qSgP
	 mvanF71Tt7qoC0VHQdAYCfG5V4UE6wu10S1hXw7MTuZ2X7ez70VWsWImkZqMbOZFwP
	 aI8i1T0Z/cI9mWHkw6udVUvKmuONIGK5Ygi4Xok9eBNloQ6UpzO62DCRN7NJ2DTUSw
	 t0SlTXOUdhaSA8/333vnzILdq21tY9bgQNkpUaLLtjJzUTQ6ZHdh76tAC/z2KlMASC
	 XSBR756DSoLE4O1UCW0XYzy8iX++VYsPpOHox84YG7pBNW4WyCnYw8SwyvvCL7emif
	 Orb47sGKIaFdw==
Date: Tue, 10 Nov 2026 15:39:17 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 10/10] mm, slab: deprecate CONFIG_SLUB_TINY and reduce
 its Kconfig effects
Message-ID: <avMpvYcc9-IddPWN@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-10-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-10-0484ce59eabb@kernel.org>
X-Stat-Signature: 1j3p55sx59bfjkxemp9kh6fuapfknym3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D41B940003
X-HE-Tag: 1794321560-664515
X-HE-Meta: U2FsdGVkX19Y9sIDHPwtknv7SEWPQo4csDVsu0V8i0sjtKIXU/6Ks6qHU0XqzFvkuDjS3jsifLh2NCkurEmSj6biGNFQGqZeRuyzU4oBrVYuvyjCMpy2euxKidE0M/ymHnhjDcHLPGEPx7/qs3QEiQVqaJPNs5B3gw+X7IvqS811E8wO9zhGJGCHFNApykJNEuM86sbCneVeetH58OkSVKIAs07mGdXvWzQcDD6M7KXt1ENrMseKcQpJr765EF9lKSiPi+cGdS0lz3RVT5EhmDyg2C3mRlkjxU0MBzhgVITTOTsXK6/2DUU7Yv/u97snzHeQ28jpQ8ccUbHhE0Osyr2APB2egYsVCDZdw2sVj5OnWG467IGXOcQFTCYn4RE0MkBTmqpkTWkWY8qV/8NyI8SrpJfdJUp7nkgOiuSK+HQqMR/NyJiKEjZ6XXIWS6+RvGr8GKqU7/NhqenQJB2u5otO5JBOY5fNHf4kPLxQE57mddf0fq1rM1v/dJvxUGJYb/4mkt8nhGCaXoyPsBqzqxtl3oX7/8wgwwY6mF6C4Dye8I8q77F22f/fR0qi5+yGI6nCb/s8fY3M9E7CBwlD4xyxgH2MCJYYoWRynFuhW7jUCwDIo+e7VnXhYUjTz93yMdmxHQyqb/6qWPMLSMNP3VUdyVXdQlbXTW6edd1XEuTZcozSX2rT2MxOrQJZ5gQnBM4XQGJ3kQnM3/4yTvo3lELOE2rfH+ziinKSP/BsSiS385BDhuXsCOEZFlRDQxfdpwaPMWXQ7IYMVxS6ChvKE69eeY7/npceUX6Zd2SIf2OdNlIh8DVFTuG5EZGIvalvHQ9ymWif+N2RGbg/qtCaCuLOm01nV+sYS94spvPrYBzZbRYGgD6tur6MVQ4SK8MvmGcds2fx4i9VbxBUbytYb79C1qxgBue0E9leI1X+dLt5cluwpZxR2Wzb7pe3kiZJgFRLWjqiyNH7CTRYBYI
 VvxwyInm
 Z1Gil4HnQuBskDwOKo5TWRTHdv0mOFHZsZu+sUunVKmCeM1P7zA5MSzlMRFg1CQy/miqs63xTvvWa/812WyNnh5QA30j3+QdgzskNvPNgqXyH/pwOIl9ZRu4YOZDTAClzW6gCfhf+YHBttU99a0Hx19AIuxP4sDGjLsFEprhPeG+a5lSIvcErh1A5gYDn1KrivtJs1wBVLLiMt2tXQwpOVkpPR+s8qPbZ5/2WIZ7xG6XTd6B77h4jmG/MCvUj78gZjs2GlAUTxXOMDgXUV/L6eyPawZw5DtZlp42sM8N9tt2Gk8sCrP+zmrVWNgBvg3DBTd/UaZ2K+CE0/e84DB/9jOMANFTl60sDwfRT78BGAiWusqGSSbQOHTJ8DFP+5K1fjqYqJKBCAYuJonVzSnmLks5CiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:59AM +0100, Vlastimil Babka (SUSE) wrote:
> At this point CONFIG_SLUB_TINY only affects the default value of
> slab_tiny_enabled which has a boot-time parameter. Thus deprecate it in
> the Kconfig description.
> 
> Also remove its interactions with other Kconfig option, as they are not
> necessary:
> 
> - KASAN, SLUB_DEBUG or SLUB_STATS support do not need !SLUB_TINY
> 
> - KVFREE_RCU_BATCHED can simply depend on !TINY_RCU
> 
> - various hardening options do not need to be excluded, although it's
>   unlikely that somebody would enable those with extra memory overhead
>   together with slab_tiny
> 
> - SLAB_MERGE_DEFAULT does not need to be selected, although it's likely
>   to be used together
> 
> Keep the "depends on EXPERT && !COMPILE_TEST" as there's no point making
> the deprecated option more visible.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

