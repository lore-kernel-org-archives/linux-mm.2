Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44174C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373D56B0092; Mon, 31 Aug 2026 05:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325A76B0095; Mon, 31 Aug 2026 05:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE306B0096; Mon, 31 Aug 2026 05:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0207A6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:34:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6523DA03CE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:34:44 +0000 (UTC)
X-FDA: 85161054888.11.5B53539
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B33CF180004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:34:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fsxw37uq;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aVpTeV09tl2ZIJXldYxie5+lftJRpDlFbGafsWVa/Y=;
	b=GNzuQLIu4XZ13FomEuMu+NpgpHugn/XqpfN/Sry9QZoaOkugGMpjfu2pBR1r0YhT4m239+
	bYMO/A7Z/Mata+BXClGoAITntsUTJcsKyWW1ZjYqPMwoyvybST3Y/WX0kbCYyQdKNsx7IQ
	crrLWHlTIXs23sy6coWIV9k+AIeaFaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168882;
	b=L4GUZDUqY/5lKFCQxk6xGPZvZBK/grTOj4PV0kwrN8GkRjaJsBXOXUDFkbXQjNHzXHZQ9d
	q3ZFPqVihtNGrZDqEKZLRjEov1XimqTbksBQTSk6t0sMS7cpUdJ9rk7/oFqXGtQlCY4nW9
	c8u2GeJ2etT2llUdQkPAIaKkgyxEfQk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fsxw37uq;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEF5743E3E;
	Mon, 31 Aug 2026 09:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F112D1F000E9;
	Mon, 31 Aug 2026 09:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788168881;
	bh=4aVpTeV09tl2ZIJXldYxie5+lftJRpDlFbGafsWVa/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fsxw37uqF9+SavdgCPh+An6E7UFG+cjRuxWcGRktFZqKnC4w9ip1z+JAVeBVhkIdi
	 SIb9cJoFNYGqjO58A/yKEOqHis8UQz8bmCY2mMLESyyRz7yk+RrqdnDMhcf95sbet1
	 sZBl5bfeBGq1uGtDGh42TUu9GJ4cf0R+TTRqZrnk09SGAJpljX69S0ddWTs8yawEZA
	 kjXLUSVTzV69S9x6zYSvrMAqfXxQGev/jZpEzMmEh8cJ7fkX724Y8RSOEuYLpmPjt3
	 A5g95G7m9P9XDTm7ynujW3M0GPlBakvCDPMGSE3IOF6knLaBtlKEN/p/mucMMbo5VR
	 ZSN2+W1pb7ukA==
Date: Mon, 31 Aug 2026 10:34:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Nimrod Oren <noren@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at
 1 GiB
Message-ID: <apVKf8FgTG-l2EU_@gremlin>
References: <20260831075635.2244437-1-noren@nvidia.com>
 <apVHXmSljK8HrIuA@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apVHXmSljK8HrIuA@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B33CF180004
X-Stat-Signature: zr6srdx434da6jn9cyx4ujag1r13tqrb
X-HE-Tag: 1788168882-242213
X-HE-Meta: U2FsdGVkX19Z4ClaLHpuJEF7GUErjzCvz14Oc2aV3GSw43bA8kKjvLN7lzDapFqxBIKy4gZyKOLnzeFqtF9fWl5sDX/nQYNBVjR5A17/q1DDttHN4JRwhBy/NvycMx64K+TWN9o6kKA+ttMOIYW9ufniqF65xBw5jRO6cmJmlTPQLIHiyg/8atYn8A2uNY5HlHzqx5zbe0H/FQR5bhHq6o3orxFL37ERmJZHrk6rmxLbKIgyKD4RLDrcjbYWXXUjg/upMXqG7XAfEwLiF23OvVToytJ1KuodBE2vriTrijhB1hxMFd2K1+rcavxSZvCa2CANgpy3mflja8aG+vdpxsDig2+AxVEvL9OJTdm8ra29LfGLFR9NWFZ8jPn4SYUuug54BxDRn2OvE8C8hsJSV1Yl5iXcSP8IEg6o+h4OKBls7H6Wo1Or54+juGc6+5OuXVRlgsD2YgnN9Egz1qrr4WfmrFLUb/BC/q9iQR81q6jRwzK6NGEny2PVeIWvP4f+Fs6H1HkPJoQ/O31gsyQN6XugezrVuto4ZB24EPV6CuQ3tt2j6WIEMLfo3AcigL56SWjOjzYam8ulSFzL4j3ErxeN1AjeeTZkd6cXZPDy8vwgLoVaRyY6uqawPDKmDs9r/HPaHhlrGY/m2cAcM42A1unxLvFihSjp0aTCnMR20c2GENXG8OtQ7zRHakrpcLPuM5AfjtNEHoJKXffJOR3eluwSlPercZbQ1Y5cpnBseW0wI5M7erLCPxwpT2+Abrda248lzX/N64G+RTYCqcw6rY8kGKd0mxp0jees+o/r24iaeTjXh8PAQ1ZlOwsxp8yzNjphlKEpQ/B8g5pBb85hnJIpDTbyd1LtKzIsBnWNdZXAibDQ+nwbaBf3FiqV7Qo6S2KDhqEAoeOb1BeQpVPVhnwSLmCLZXweo1Jsa5fsPySk/ojQHNd52m4hbsWEhRf7JDdBj6rkSqEbyijtw2W
 BN9NyDZ9
 CjNHhu7mA33x+ol91IAjHGGDT+kuN0pGtfpCkOpZoH24eLA2TVC3vFqaxdGyF2zVi+5yJss3A6ObMaAibWdManyYpDc3Ve3UVmXhpDKnqPGVq7d3gowDAW5vFwShrLRuxhdPXWO2leq8R9a4TEd2gxlI6OaHLU/WtbPjiEk/iqkc2ckBJxvmBlRbTyPZzoxaVJa4tq0S0KI3QxYoV69fZxqykvW2DKznGFE+oKzQ/Z6/cl6wAoR3JZtAX/W3kjNm52At7eXRltlhj1vnrCQj2lJueRmjxMqza3Lum33Mt+PkEBhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:20:30AM +0200, Michal Hocko wrote:
> On Mon 31-08-26 10:56:35, Nimrod Oren wrote:
> > When THP is enabled, set_recommended_min_free_kbytes() may raise
> > min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> > With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> > pageblocks for every eligible populated zone before capping the result
> > at 5% of low memory.
> >
> > This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> > configurations, but scales poorly with larger base page sizes. With
> > the default arm64 pageblock sizes, the contribution per eligible zone
> > before the 5% cap is:
> >
> >   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
> >  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
> >  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> >
> > Consequently, min_free_kbytes can reach excessive and unwanted levels.
> >
> > Add an absolute 1 GiB cap to the recommendation, in addition to the
> > existing percentage cap. This bounds the automatic recommendation to a
> > sane value on systems with large pageblocks while preserving existing
> > behavior for typical systems with 2 MiB pageblocks.
>
> I would argue that the whole model of increasing min_free_kbytes for THP
> is wrong. This will trigger memory reclaim sooner and make the THP
> availability more likely but this was at times where we didn't have
> pro-active compaction and many changes in the compaction. So is this
> actually needed in general resp. only large pageblocks systems?

Ohh even better :)

I did find it strange that we increased accordingly.

I'm more than happy to see this just die altogether if people agree that's
a sensible way forward...

>
> --
> Michal Hocko
> SUSE Labs

--
Cheers, Lorenzo

