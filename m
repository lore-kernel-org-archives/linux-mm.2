Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF2F606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YuBqUzh1
Received: by kanga.kvack.org (Postfix)
	id 77CA96B05B1; Wed, 28 Oct 2026 06:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7558D6B05B2; Wed, 28 Oct 2026 06:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691006B05B3; Wed, 28 Oct 2026 06:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45ED96B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:12:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E21C160C57
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:12:35 +0000 (UTC)
X-FDA: 85371620670.13.5F8E143
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 875352000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:12:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YuBqUzh1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793182353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLByMb/sD+ZAvsSTekY9MbsiY0HI8hmQnYsiCGgVbF8=;
	b=7Ph44NABDI7PJHy9BSlzn2AfBpEnwkmiM3L5Bpjjq3KLu1a9OxApKVGhHiaXjnKIOH466g
	drryJkwuCRPqENiioS3TvKRIwfOJ1gpHaIDeDQahpxH0YdFSs7biXzXWbC/h6k5rnIMsMY
	3V/Br9z4EwToQzIdc+oUah3ZQfRlgB0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YuBqUzh1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793182353;
	b=LluCcZBcr16SBDELo+1bz2SZ7OlxUDLgOqAOFOfeDFCi/UdZWJM6dP7aTQVXux2QaVucwh
	oi8OvbcDXDibnVObWViJYIsJ8z6QFb1nfaaHwKrfAQChjeHhj83JJOQa0w5lwnofvaOtTB
	xiFuSwmhQ+LJ9h56XjwDIbPun+yUa0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDC5643589;
	Wed, 28 Oct 2026 10:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD541F01825;
	Wed, 28 Oct 2026 10:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793182351;
	bh=CLByMb/sD+ZAvsSTekY9MbsiY0HI8hmQnYsiCGgVbF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YuBqUzh1l2HE0YDAwpzIJkTNkJHZvsBgVQoXuvebJcvMlK2CX3Qlpb2XrbN9DeQDo
	 JpplHxGpqlnKavhwLga6sy6Q1KnNbnmZ62d51braPNx3KY7zIwhPOMiYz3yJWygjqd
	 jpZz2BEZFPytQxTVeVNOXTowXrcgLAo0Dn6W8LG5SvQtSeTRmemfNSruWtZohfT+x2
	 wgpjsApsEfTr9+2mJ4A5L5Osk6aBEUd1Ku2RFMscCQy7DiT9aLenhF3ZmgzPajDVfD
	 sfxUf1lOGJA4omOJGn+9LZ3kA7suK2pDT1BRy1FyaW77ilM1apyS6jR2LtUoF4GdSv
	 g2wIDe/oD+4ZA==
Date: Wed, 28 Oct 2026 10:12:25 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Imre Kaloz <kaloz@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Magnus Lindholm <linmag7@gmail.com>
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
Message-ID: <auHI2vYFjpKk_0wJ@gremlin>
References: <cover.1792609488.git.kaloz@kernel.org>
 <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
 <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org>
 <20261027212610.6798-1-kaloz@kernel.org>
 <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
 <20261028091631.8072-1-kaloz@kernel.org>
 <25f5cbed-9126-4870-a81e-65099155bc9d@kernel.org>
 <8d4993cb2f2e5c3300514f1e2616e4a101488883.camel@physik.fu-berlin.de>
 <5dac5fd3-c2a6-4e1a-98fa-0fe1936b269d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dac5fd3-c2a6-4e1a-98fa-0fe1936b269d@kernel.org>
X-Rspamd-Queue-Id: 875352000B
X-Rspam-User: 
X-Stat-Signature: pt7h39pw448rhdf857kujfry6nrk7x8z
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793182353-283546
X-HE-Meta: U2FsdGVkX19uY+kZ1xM5lpYqZGJma0AY0YBQlYCcmNluaROAKVjQ4VbUKT13A2hZU/2VGEQmF9RLjbp2+ofA7pK1UWIJDJGOXtgB78RkIfKAG3y/OCZVIuzBAMwxGKVEBBJolK07N7FVXN9CCpq5+WHW1GjnRbul25tDqa0vZ8sfRfS7qjqNZ8AzvVN/2WE5JmmhK5oxLyoUVkq/ShanzN5bkY4igSwgzbLOTjb/2rk4piC777eN2CGbO+pQT3EjQ5whjHB1rj05l7069O3CGJECZW7vvklPXcGzIHfVCNrTPn3ccqgz8S7sGfHs4NKBzTf49K/ll72bmma1jI5bZFAeJyCBpuVLeTeD33w1pvxPeEn44nNmKk+aBkHJt4FybzyUG24O5wXXIBqZPbWYex/msn/YzFVTnxTXWCSrN9sfR+8jlpIP+croYEO7Vx4V2HDT5SvsuEakdYUleiHDBKhPh6huLDQJKxReKmBUIr0IhxtOBS48UDW6akXKwpcKn0uN5d5KMWZRrY/BTd/RoD+M4bQavLpdhuPeXqytT7jCW1StOodJuEBuiJgPLdeNqLGejQWQPu/JZu/Bwf3Bwj50LuYkPebCSSkKHZzTDDnSAeQrDIQbYh6MRBI3VIYw1zWYyLyw5pWLc4cRW4TMHtZj+QwcwE/j2XqqMA9n91gr3i8JS+0kyNM35/H/iDb9sRDl1ZIEIDr7VursgeL1iOgMafhx73YDSY7tdktOf0Kg8teCK+pAwf6heMCtHA4lFSIAB+RB33JPz7OwurOCDM5Jmc00o10X2W+z20QxD/IWuSvCWHHkyVTjAx9hZIa57XonsCQxFhrlEsliJnbOI/wE+SDaMrmsYCAQXlsQ6VJxPapl5+DZlimtOa+ZJDMUjS2TFj5TMI+3diu+Q7ABU4I2LFig9f14sOLiUmLYDdeL7pa3icJW4TK2Zx9Tebm7ZjeaReXcpNZtAUEVWT+
 4Nf6SzzR
 Q3ih8zPK3aauBsA/itrlgJSPA23zGQL1kdxDAB3yd5S4LmhBqNfYpRE+Plk0xRGyJ+IQMoLb27ap6vdig9u6n3sphj+cVe9hUsF/PirFT97hweApX46Ud7179rTLe06qo8VaQfr/nmY8DbP5weCDe9zVH2Or9He4DTHcxSCliQUkk/i/+DUN04KFcUtrCaqxCRQAmFn9Hq747OcE/DedWqdWgVasnHIPlhORk0qb9Ti32nRUf3wKGEv/cumvv8tsBxE49E8AacySzVO5iuSj8lC9cE3zt0rNWfiXjv5zZgZhMZz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:02:17AM +0100, David Hildenbrand (Arm) wrote:
> On 10/28/26 10:58, John Paul Adrian Glaubitz wrote:
> > I don't think it's fair to make the kernel exclusive to very recent hardware only.

Nobody's making the kernel 'exclusive' to 'recent' hardware.

It's about overburdened maintainers having to deal with museum-piece hardware at
the cost of literally _everybody else_ who uses linux.

Use an older or downstream kernel - problem solved ;)

>
> "Very recent" find the mistake.

Exactly...

>
> (sorry, I'm unusually grumpy today)

Justifiable ;)

--
Cheers, Lorenzo

