Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB578CD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217686B0088; Fri, 12 Jun 2026 04:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8C56B008C; Fri, 12 Jun 2026 04:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE896B0092; Fri, 12 Jun 2026 04:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED8826B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:17:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BFFFC22D1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:17:21 +0000 (UTC)
X-FDA: 84870555882.05.5072981
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3498440004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:17:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rr9lXiPf;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781252239;
	b=OEk4eYxsQJxXkNwOjTKmF9Df+C9VsvgVdtQx0Ksij0q641C0tudAylOTDMJS2kzDSsVuLe
	tr5WmQTaygIx8HS9/7AlPHuA0R8hqTISrDKyT7pU1DrHur/g6hYdXUDei3oEwivlHPs3CD
	evCMX6FD7pGf2BWXNl0I7RtcS4iCeOc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rr9lXiPf;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781252239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5txWqMq4PmQdbjrUmIcHFPjy9DNf375GIkFCaQfXUM=;
	b=1C9onC6HFgrcjD0SUtbSLiqe3BKaWTUpy2I3wHCJfybpllbfpdW6AbQ3y5/7xl9w3c51py
	qlAZibnNWbRQrppAHVi0zSRCfCVrlNBRbBsSTUPHD2AQyxtILRb139F0voXPbrmv1LnY1H
	BOSta8KylDpzq0G0JXAklrNz9r/Kbnc=
Date: Fri, 12 Jun 2026 16:16:53 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781252234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l5txWqMq4PmQdbjrUmIcHFPjy9DNf375GIkFCaQfXUM=;
	b=rr9lXiPfZZM899yzfUxGqEA/z6DhXDRCL8fJfcFQPxOBcTPnkWmbPyQa5Kb4ANluLPDZhL
	WYafjB+RD2C8se4zM6X1Hz70DuE2o/r79Ms+w2NVGxRaxeqpGI9k3pNsLPF6hRLR93Pg5m
	XLlJGQhpxyKiAE5EFlhtc4u0vlVItjw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 16/16] mm/slab: replace __GFP_NO_OBJ_EXT with
 SLAB_ALLOC_NO_RECURSE for sheaves
Message-ID: <aiu_5Y5PEtAMMNJO@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-16-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-16-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3498440004
X-Rspam-User: 
X-Stat-Signature: m9o1xn944nmdcpepxzu9zbda5j4tof8k
X-HE-Tag: 1781252238-71418
X-HE-Meta: U2FsdGVkX18YdrixINTWzezPnwXYxRhPn7c5XQvJyaNR2l4eL+CHAA3tou5cOMyGPpHt9bkF4cmSaFhX80NOsXxZyaOsOMk6miKZ1F8PGARQUj49CZjPJzF8MsKbIpJ0htp0f7mv20c5NI4VFve3pPsFZah0Dv9QfL3mDfGsQbCz0/B4mENSyvmzvvRj3Yt7KLriIGVcI5LWDJrcmbQiwzsfx30jJnzc8HrzUYZ139Za7zb7zVLYhPUzNf2erIccsKP+cPrxxXywVkO6ByCADknbhDre3TlbsqC+ZD5ZZSv/tKYjPs2ZP4ZyzRxQkeOBvPgFUC9s9OxM+oqAjfmCTrfhONgqjKGSiBDYT1d7pbyIYZtx0F0gva4TO99mkKuIRkPtn7tcOq8PNzEj1dUF9WVKK1pbYXd9b8mblVCIEFM1VOJ8p7vqqwINU/XuUWdJJ0cRMUgUR67SuJEwdsRR7ZB27pUDSGuIfHyqJQrXT8Ndg2o61wKu+RJqedHB3gb5+Vq4QqGDSHwKXWON6JDcDnyXky7gDf4P26hOUPWIN4oMujaZqAPcl9FIFZu5GxhuudMSM+M/F+Ir0QH7o3L2eO0RDOqUXEaV0HwZZximenRpD1UcasKswGDzy/JMz+53gijK+vHBptJeGUpTK6parPBy6wdhE3NlQGve56jPoJ7JlORLdsweO7SfVipfDvoJ8ErPUJ35W6U6fY94ZlOxOKELpUzKCL/mjQQITJa2vKRba2zmvvJrE+zqSKMB+cJcQTiXOh8HEFGYvt52iZ+h3xA5cR+LySvEFkDQfHdLDKB2KbxluFlqLamiudngVcoH4NXM17xfsvBhqQo09jmEdVRQeTJDOicQjhs1EazppQhtf70fm8JhHUflSUmuboVwX+6dCMUgCBlH2965/hFMvUdnK7Pp08NaP5BkiptH8CVA+CDOh2u+VnQkhg8kMOmwr3TOWrUDnU7vK/BPIAF
 18UNskuU
 qtSz89sqtPSz3KeVHbcUvWEeZwo2JF0pDlCAj8cZ3aw8QYnUQus7o1ll4fw17P6DuFVsmrnOrDobKdvIPOss4RwBywKgYNayr4AuG6U6eE0ZBmadHppDHjHDD288zb+7x326DgHH9Gzm5QOMtAvAifqlP/Z0CUnXnj5T+nE1wCpWecYSG/lkIWnufXeVT9KBbPdkZEFSvpgnXO3fRongvOvSf5LTIgosOuiV5M9/5p8bUS7BVjUfpOstnsRVlUIMhrKiUv23cMF1Ir+wZyuRE3GZ7BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:18PM +0200, Vlastimil Babka (SUSE) wrote:
> Finish the switch away from __GFP_NO_OBJ_EXT by replacing it with
> SLAB_ALLOC_NO_RECURSE when allocating empty sheaves. Pass alloc_flags to
> [__]alloc_empty_sheaf(). Callers that can't be part of a recursive
> kmalloc() chain simply pass SLAB_ALLOC_DEFAULT. Use kmalloc_flags()
> instead of kzalloc() for allocating the sheaf.
> 
> This leaves __GFP_NO_OBJ_EXT with no users in slab, so stop allowing the
> flag in kmalloc_nolock().
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

