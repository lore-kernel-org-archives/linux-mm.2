Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDC0606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y9P47yac
Received: by kanga.kvack.org (Postfix)
	id 23F1A6B05B7; Sun,  1 Nov 2026 12:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216586B05B8; Sun,  1 Nov 2026 12:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1563C6B05BB; Sun,  1 Nov 2026 12:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E42F46B05B7
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:30:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76C2A80A21
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:30:43 +0000 (UTC)
X-FDA: 85387239966.07.9F65F3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC1DA14000B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:30:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9P47yac;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793554241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yjT4uLUMkuD27R6BJuNehLVUXuISjPFuRqD0wtplj8=;
	b=iZjQ0duu1SuKreIbLBYkR64yyHvAFTWIVbouJfaKd6BhJttl4iKTthEf3Rrb0HYVvAH7aU
	2UAtmwPmtqG41P74vRttAVQsOEPOZTlGMP+5RILF5voG+0q66Di2uZh64n/T3gFJoqxGzd
	4H9ZvqdCMLcrjEGmlPasuW8t9N5wreI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y9P47yac;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793554241;
	b=oxslKlBd7BnA1FATq8tujRxXu3LdVwMr6lzMUUbljhu5QeQXYSEeCOksur61WPS/5vVT/5
	9EUPqTVVSPamj5yzz0AdPzkAU7mR/lZhzZ6IdD6oZoh32Iei5LRZHEUycFNidYoUFubruO
	a5ykkCTXcnHQlxI6LVXbbfnAoYSSYNQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 458B5601FB;
	Sun,  1 Nov 2026 17:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F02B1F000C1;
	Sun,  1 Nov 2026 17:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793554241;
	bh=3yjT4uLUMkuD27R6BJuNehLVUXuISjPFuRqD0wtplj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y9P47yac+uhWhB5RjcPOXxPsZmYKXJ0KZmUiefS66FujIGl81416n9FY5nAwYtECI
	 8ral0CluzQ5Il5hoeHd9AlTbnzeQ+t+dhJX90DvybLfu44Otl4DL3RFRyB+wVs/nC3
	 CslgtwcgzDGD0QLiYf1nLKnFeNSswHkV96Gikg7lzj/KrZI6NfBvGGasi88xbD004x
	 IZcHyzNbFU0QX35ExNLnBnFWcaUEc7wxtQi5sWj+3ur5NBMQc3Adl4HZX/tq6zWZsR
	 Gvt4DgUq6B3K6/jR9xFBSZq2llTv4tapMxUCHUVRRek36Qx+WrI/h+WbJoHKaNRLD9
	 VX5oMtg5kvJXA==
Date: Sun, 1 Nov 2026 17:30:38 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
Message-ID: <aud2VVt5zp2i1BkB@minisforum>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
 <audw0QKojvZU8J7e@minisforum>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <audw0QKojvZU8J7e@minisforum>
X-Rspamd-Queue-Id: CC1DA14000B
X-Rspam-User: 
X-Stat-Signature: c8zue3xjwem4ph4gantoipiapfr39pdp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793554241-833422
X-HE-Meta: U2FsdGVkX1+jmQMHesNL3LmFE23t2WB7O72GG9iHFooKG1KvdC4SnyXJC3cKCkoKSf3WQdF+rQDTp/9cdCbQy+tA3Fpkr5lJ4FI4bPUhOLDBjA7DJZTRam2eltr5W2jvazt2q5jK1i8+pRlsSjBfYUbbfr14Xk44vIARalBeZ9hW2lvL5K/FlhkwhTxeSRdQXeDdQ5y/xxNTk7XSFFcm6UKrUoCcLNVDu+6TvjnEzRwfeWsHBXgL53dxnrdWGNUMGBMxq0/FPed4Cvfjz2vyJL9oscC4YfCXcybFbGnzLZQXQXmziHTQg1LOF7MHq56sPdbILReVlLNz8Y8GlFvW9FR2RVciJD7FVfFfZsd+7o+pzVVKRF4/nUkBcZOv4i6+djBFPA7yecYFI1EyvVaZk4LWHGM+yA81p5q1QN/njlQDsXwscoFax3GLKhbcbL9zwJC636TEAD0YePfzQ1Z58XmKLdqHplhwAIO8hPLE0DxuLUYu3jBKAtRlqPfLXA+2BEc6lX7dqARavtFbPflwDxvMVt2xqQ27RSU/frOfHx0M6tFYl+kd8IRLW/DBFPEzmFb7ZkNE8gybe8D3XJnBTBH82pRfSVS2GM5PUCPY5zmWzNIFMKhztao1NqrKX2m2naZ/JMoIa7bC6F2hQmZwlA/3IYbLmka+2CXxrIVrnEbalmRyOsQmXT+BX117scLiszc7PE8xQMfH9BsVDkObP0cI4ZrrEydjB+dKljaeP4FQnIXeBJsgq3AVdXvoyw486JOmta5D3KsmBUYF0Jd0GMYlwssTOBlltJm8xqaYIzVWhfGNjsnkXz82PInVRwiGnJESAmU2chseJ3xOEVS1Kp5/Ckoyk1Zt6h5cLu3LhLhoUNZEGkgBy30zsVdA8X3jjPC4lEl95Xu+D8JuiI+KNwRYoCtduIxqMuCGoENAb0SK0YlaKZMlf0myOPBarpi20r5OCimBFu8GitJsjGl
 sQxYYIgw
 sxCTGfoOK5LA4lEmsfGIgaG8IwVKi9F2F/9b3xWHvvkOaW2MBt+17PXA2hwwijsRN9zyLSewcAyjBzG9f2KI27wAYrPZtLEnDUSOxzRELkPJeft8msK/CD2tNGBnM0siPI3OCAlrweecGN5n04bszB1OAf3n9Ttmvq4wTfl9dN2Go9UoHuAg7VIoSH3+waneRjzMKfhXCchthUO8/he58OV7FcCMt7vwhtl/txMmjE+i33+FG/5SEtP7H9trVJOu7mjrJWSY3sb24YhvBkhc8nCPRow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 05:03:41PM +0000, Harry Yoo wrote:
> On Sun, Nov 01, 2026 at 05:34:48PM +0100, Vlastimil Babka (SUSE) wrote:
> > Johannes is a long-time expert and reviewer for the page allocator and
> > has agreed to step up to a co-maintainer role, so do that. Thanks!
> > 
> > Additionally, page allocator is joining the MM transition, following the
> > MM core updates from David [1].
> > 
> > Patches will be collected in the mm/page_alloc git tree and integrated
> > via the mm/linux integration tree. To signify the change from Andrew's
> > mm tree, remove Andrew as M: - get_maintainers will continue CCing him
> > on most patches via the catch-all MM entry. David prefers not being
> > added for mail volume reasons.
> > 
> > [1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/
> > 
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
> 
> Acked-by: Harry Yoo (Meta) <harry@kernel.org>

Forgot to add:

I couldn't agree more that Johannes Weiner has been making valuable
contributions to the page allocator.

Congratulations and thanks for stepping up as a maintainer, Johannes!

-- 
Cheers,
Harry / Hyeonggon

