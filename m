Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7C5606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SETtaNlQ
Received: by kanga.kvack.org (Postfix)
	id B0BBE6B05B0; Thu,  5 Nov 2026 08:12:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A955F6B05B1; Thu,  5 Nov 2026 08:12:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB4B6B05B2; Thu,  5 Nov 2026 08:12:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75FFC6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:12:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16D4AA0A20
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:12:28 +0000 (UTC)
X-FDA: 85401104376.30.2F36C32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7B6814000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:12:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SETtaNlQ;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOPqnwsFQYHBISIkk2pO8UlDsjZcYkTbh8+hSmmU5WE=;
	b=SpsGDv15q7t30ZGISCsnF+Iy7xaXgFa8pWocnbYxkf1U2LedVULNy9CjicjY1HyBttJlRo
	SKr0Su4jGwy6StwiwkRTIOJY1W7eACjU8J3FKDTiHp5GSQD8dG0Xwjnq9HAixBzuCZfXen
	FmWsGHM+pZYsFETARBuAJ4lH4PuWSt0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SETtaNlQ;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884346;
	b=E5W48zuRuJ/uZy9VY2WlNeLxsmQpUMd5nloGpUSaOt5O3lePmJmI8Qi1UKQjRkLgrETm2J
	3qX6B5O5p0Sq4gmhe8WUg7slWB41+Ai8OqvhwYWfIsN/pXXpPRKcUXa0uofuUuajCFoSIq
	e6Vl61vWJtB39zNd6EoTIsngLoKoVew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04984605F4;
	Thu,  5 Nov 2026 13:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4584B1F000C1;
	Thu,  5 Nov 2026 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884345;
	bh=bOPqnwsFQYHBISIkk2pO8UlDsjZcYkTbh8+hSmmU5WE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SETtaNlQ7OqsZkRg+4F2KmbHGav+xCxS/suET8Op3SQDNp6N3sLYa3YJsMTWYO6f/
	 hMDLtHhnUNRMTE0I5Khqn8cm6ednL+pf58FJ85kw4j8BIcStIJNHpVhDAMPSxWuHi/
	 fxPM6wqJo7EZlC3gdIdLI3DoJQzr6cU5PlGTprW9KJuRE5+ui1Mz9fJya2BoyJG6CY
	 J6+JjLmTxOr361wRJFO8z19ZKI72DQm7lA57p5HhXFjpHiDWPXuezeD3J5ZfKaCFu2
	 hpQqeGuoZv96PdCasfN/hK0iibtlzBPkCbzVpSUVzQ/M9rS9pbbJJuf9FS9jHtblBH
	 640xeM4gu4FTw==
Date: Thu, 5 Nov 2026 13:12:23 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 03/10] mm, slab: refactor slab_min/max_order handling
Message-ID: <aux_UhaXFYy0ZXhm@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-3-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-3-0484ce59eabb@kernel.org>
X-Stat-Signature: b8resuj6put6h63yoaua5h4mynjij5z3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7B6814000A
X-HE-Tag: 1793884346-899113
X-HE-Meta: U2FsdGVkX19IGF94DZxfakvAHy87NCS3d757CLWhFLClOpc3YwndrRbBO5vzyXXh1SJVEd3IAJI7BJlMGjUeiNOv6L6Z+NYYFDVK1ZM/YGhf/QhZzHjHUh9ueSSLkYvos4RFrt0LqZ8dEPCmaKgc0j7ZhP9899g2sFO+55dmhfOxfOs5ApPs3oSyiIDfKh3YCV45Ef4Fot1yVUtrDLPfHk9agplSWn1vBi9n27cljU3z3EotPz1c1NSHx133SW0Ax7HmVpt6DJBNQkfks/+3dXW9XgtLv2M59ugaoqtaFelGmYpbw+XBBbxNdsNO9tjcx0xIXalhzYcCFbC85UzGhSwD+B6BZARKq6zMOstw0NFuRaqvkhHUuowX8vadH49qcqKug0kQp+0XTGPAlZ7JDlTVrGmdKOTAhZtR2uWZ86nghbOB0esiwBrD+hsBwr06OJ6RbduJbRUdsCeK4HcV2+WZ5geZiq7V8Nh9hPcRr5Ocwg1CyeB5R65cwzOU8B56gSVG1wgaq6gfXL947OMlre9BCPyW3QqgWPist4V7ny0UNdxqLzijeeXluR/5bx2PRQ33mR+gVuXJc6F1mkeSqUAYO9lIXw/42D3Q3KRYw1Mgru2zM9Gb0UqII7kXBz4of1jsHthFk0qFDJ7mY8Qw4/rOUw8fEQFQESErrKkjCt9JEzRrMxe9xFO9ygvMTny+HNUgCrpZ8bNZUezThxOvApgPyLVo7Yg68QoSGOeorEc0tht6awwxq+oloTK58FP/847/j7LYm15x1ExL1U6EuE9zTP8DS92cRAw1ryMEXQxIjcDswg9oAwGvHv3REwaLo2LdgL6JN6OeFhsvsmSOrF5QNtG8qCGaO9HUFU2Y6SPNOgfB0lxfSVNXOns9F+dCGYNa7Y6wTnJjdEVp0hOLZ1hIEaadj+dAVDRr73cI4d3G0BlHfs3EFOw1CX3xiEJJjWQ7PJK3zvrPLTQTjnd
 lwvSbz+K
 fqt/M7ScTrGf6C4G36RBEEaHmO09XnZwWRHmarhm0fdyRsIv3xF2JHlWYNwZeCW7SFgCXDVvQq3CrB78cWVo55au4CymigRaTJh51mDUEwL8IVZM8LFi7HvTzt+bvnmSh9lMMB6nsC7m6uhmUtlEyqlefprD7Fwy2T4r6m0zLFdj3z/oqV1p461QhZJSmvBwszCVeugJ6wClEzOzuJLFXLW+BFmfaq9SZEZZeyd+aZcgxs3RqFHIsoIE4hZMqUj3Yl4YJt7RLUH/0wYZ8vArVyqtQ7aNfFDa4B0RfnKzTmPaRJT4QGlmlhDOapS7TJ3wIr06/hJfK7Hj4hExqmWhHQNyklob9/RTLGyesSVG+r1nCbskjsv2uSEOPqoelyTjoPoL+CkNs1o46xVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:52AM +0100, Vlastimil Babka (SUSE) wrote:
> Setting slab_min_order and slab_max_order as boot-time parameters
> currently has several not so great aspects:
> 
> - slab_min_order is not checked against MAX_PAGE_ORDER
> - slab_min_order can raise slab_max_order
> - processing requires custom callbacks, their execution order
>   depends on the order of boot time parameters specified
> - upcoming SLUB_TINY changes would be more complicated
> 
> Instead of custom callbacks, introduce __initdata variables that hold
> the boot-time parameter values (if given). All inputs are then evaluated
> deterministically in kmem_cache_init(). slab_min_order is always capped
> at slab_max_order and cannot raise it.
> 
> debug_guardpage_minorder() still overrides any given boot time params,
> but it could be changed if there's a use case.
> 
> While at it, rename the slub_min/max_order variables and
> slub_min_objects to have a "slab_" prefix instead, as their values
> determine the sizing of slabs, and the "slub_" prefix already became
> deprecated also for the boot-time parameters.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

