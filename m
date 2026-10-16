Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9767ACCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944BD6B0088; Fri, 16 Oct 2026 04:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C2F6B008A; Fri, 16 Oct 2026 04:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C0C6B008C; Fri, 16 Oct 2026 04:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65E816B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:11:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC0431C0B2C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:11:42 +0000 (UTC)
X-FDA: 85327770444.20.40692F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4ADF61A0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:11:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9Qc3KBd;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792138301;
	b=U+6NKTOpDMz7gqIBIQ32MbhJnHcL0j2ZQNbadsnTTDTveKWjfUZv0n5DRFkIYLFBhOIc8Z
	qWtAqdGPawPQCFfvQxg5aQoWZNdxGK5mSCblWMi3HDsJWozi6G7eW0LM7C+k8o3Hr6MnPt
	td9bVbBEFzG2FYQ3cFtYwvp50+Z8tqs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9Qc3KBd;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792138301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBGAT7ue9VgHZMuu5dAb/6oFafAsXIvH9NDdySY61DU=;
	b=p2fNfqSmXSSxhDbHnL5GeqSHMKIFhRuyVEeqsn8A30//giD9by7mxq10dnEudn77MlogCb
	rHh2Yh9XQmNxWvYq5bj1q0iHBumy9BMakUOO8chSaYAQYSj5WIA9gNcnTzR0elOJgrHN5H
	2H6MxkkyYc4gP6gEiyO1Y9f2EaT12ME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F8444048F;
	Fri, 16 Oct 2026 08:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886951F000C4;
	Fri, 16 Oct 2026 08:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792138300;
	bh=BBGAT7ue9VgHZMuu5dAb/6oFafAsXIvH9NDdySY61DU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y9Qc3KBdcZWgZjWsaAYnSgSER1uaz+BaIQ2eo8wOVW2XevFfSrviKphX0IpLqNOQU
	 J3rNGys0fEfxFxyjD6NGhqth8kxZet5yd4j+UsdTVoDsSdZuH5UcQuNWzG+QRh8swv
	 egdH5IAmn6eWndutGah39BCtH0vUezekNLRCZ/vEUFLRL0T+VyKxINBN8U8s7r7QoL
	 3wBKxEC7c6UUQPYd9jPvqWr8zcYJY9m+RumfPmgmejL/Q6Fnj+lTXXDJjsOwGOZJbn
	 jdxy1IRC7v4xAjsIrHPzHSTtR+yWxvhHddNJlK4RSEzryGAgYkHiU9392IxR1qvkkX
	 GGXM7I2+M3iDA==
Date: Fri, 16 Oct 2026 09:11:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nimrod Oren <noren@nvidia.com>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: stop recalculating min_free_kbytes once set by
 userspace
Message-ID: <atHcD0azFKNLvPN0@gremlin>
References: <20261014140859.1006967-1-noren@nvidia.com>
 <20261014144823.8c89da26c547fa95936a2fe5@linux-foundation.org>
 <26103c38-7b22-4176-8bc3-63e4b8fc6bbb@nvidia.com>
 <20261015173826.e7ffb7333fb84f5be927ae88@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015173826.e7ffb7333fb84f5be927ae88@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4ADF61A0006
X-Stat-Signature: w6iozujk986kyi4fbfpp57pq6imjha5r
X-HE-Tag: 1792138301-809383
X-HE-Meta: U2FsdGVkX19Y7rcOCt2aTu2z9z6uCILuLp+hCZAoPJgtm6MPJRg7Olao2FY4wFlwaCEPlS+BmTOGdGLzus6eI3XOtrcaTDasZIqbEG794cYJECcBRA7GJWjjjZOsA1VCGjPPt5ccHwxb+KmdM6d8FBR6fJmEsurqIOylTdjv8X4EoYSeVxWnr+yvKkiZlXTQjhCLEoFsmyfMFSNt9axUFzdM+ZkS5eafyfVtKicw6O6AuMAboFcMvpGC69wpsKw3FvC1HID98nQ3pIK4YznDRoBuGrpas4MzEbQ1uMao1Vk/cKRpUVMLHf1e6l6jK5qRXK25ELQogSJnApraqWXBw0nVHgF1jFQc8tVhrGyEvjNBvtJmRUpOHshR/UfSxHcMPr1tYxrgwAxnQ2I3T0vEliBu3YUMCwzc5dWUbqaPjLXjbmaJ+Ozjfiocfy7pcn+IOurg73QzTzJL9dPgA4AJpcwuDyfndTIjGpxFfNjkl4rNEdlutdmO+7IvZrBiQGkTSEBir+UZ3IMo+5DSZC0KhwoQ+RjI1TO7f4YKRORgahlE7xTFa5l86evJDLlsSC4GrUxKyB6rFVnYy0Mo1CiLsJ1UzOMg9eiKT/1VAlfAmj0FyVa6sLXlTHfEf6kCgk3jMo/htfl4tBX40AiqrM3qrNTN2KtY0q2jC9uFJJnJRu0eUoBnUt+wmjoRIx9quomWQtJqexfma4pqbEk+Y3tbQ82qBHa5JgumSmDSp9tzD95up9pW3zn4Pz1IWt+o39MpfHsfTb2J0RycSl40t8Gm0RJPV3EYYGLZIhuVYs7j4ztjsm356dS7oHRrrQ1H7fkYJ/MyIijEkvwu0kwkQ/soFijWngAVRnX+TZ4N2sEIVnABlDaA1Li/F7UxEjhlI5v9Oo/LqEL7l2fjbERpixOr05G1j17B5ecnsYxy+2UlxDClfnx9FhV2HsnGl0bxf4m3pfEHJe4y10JxYG5og52
 zagYEhSv
 J2YCfLio7vghU1QbYTu/P4yM6bSu0TEIhRq4ehomP1+Toi2xB2qEZgzUlAKNbG5d3ekDWkir/KFq/5kQv4XYU3d3VvFX5T6Cm4aLcx1hZx39mXJUFW3Y9PxkqP0DOotMi6gaYBpBwkQs3evSBlMEB/qx/jrQXPaGN1RCRjykDfHQT8W/A4lAmItOMQTZFJ+1sa1w/+zYG376wFnlTOXlQWyTt8hzCuvN3iuoj0cl+Fi5S5Ph2/xvBsHn7WzHMQqdL59y3jezh5uGXpyCl60vps224LkHekYBcgkiqWCFPqcuZ6bPnDjnHaGEIzA2CUY0O1kKrAAKE66H36pyBVtRKPmvAzZcG+g5S03AdDuHhq8fLZsdVwaSohgaEqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 05:38:26PM -0700, Andrew Morton wrote:
> Do you (and others) feel that we should backport this?  Or is it just
> not applicable to real-world users of older kernels?
>
> If we expect there to be non-zero users of 64k-page kernels on older
> versions then I think "yes, our users will benefit from this".

This is a functional change, so I don't think a backport is appropriate. We add
useful stuff in newer kernel versions all the time :) users who wish to benefit
from them need to update their kernels.

--
Cheers, Lorenzo

