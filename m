Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4646CD3941A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBF56B0088; Thu,  2 Apr 2026 08:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49CE76B008C; Thu,  2 Apr 2026 08:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2736B0092; Thu,  2 Apr 2026 08:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26A406B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:49:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A516D1406AC
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:49:45 +0000 (UTC)
X-FDA: 84613597530.16.EE69E6B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id E693B40005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:49:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GofupbeK;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775134184; a=rsa-sha256;
	cv=none;
	b=N5FXrm6SaOQLNreOePX8caR6Ii+2U2kXfQLy/o0EQblBiJ2ZDQIEqfDgCC7d0lRspnGIdY
	ZvCyMdgTC0S4xpEqRnxupNZ/ujyYjet2q1a5WHG/+XAtzuM0wu2qfuDAx2whvv7m37xGL/
	8dt1CfeVrm7oWigj1pVjitc+FlskCWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775134184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cF/GPU9r3ujDgxRZ2sbfYudvj0RzIpZembFDGNj7L60=;
	b=N34DqJ2YpO/LBo6Vb9tOnpjdV309G2ImEc4CwdLOosNL4zV0mWHERTjMbmrzRGPs1sjEcL
	JJU7Ijvza6Kd9bh+17bDopiD/UoL4/KEBsP660DWRbcb2Mc/cTX9BJ92Tdd2QXc3SS+NqF
	4x9cGu6sMRTSw0pZ0FRJVnpjNcNr/Os=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GofupbeK;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cF/GPU9r3ujDgxRZ2sbfYudvj0RzIpZembFDGNj7L60=; b=GofupbeK1lWQwxbg9iGzDlL/7l
	qo3ix734gZIrALLFw+o7cxCW1xN/TXBQ0xTHlT4sznqhs/qldCPqAoJr3Ypxx33FYPMiK6Hqknmzh
	J6Ud+auepjNFtWEfIKBN5zybxu4rWwOfjN3WaqCqb8oYfW2XpWGaauwu1XsldL6XCxNIGXAZ+vtl5
	6Xc/q/fJDUU9z64qVqlJ35HZV+VD+fYo1/dA2udcdVdhJVlFhD4XPJFMCl3k02VPyIEhzx9xaRVVw
	f90uoYIjnEWDIOp+woBEnzzfYPFh5M8IGZCFT7i+273QhwJtkfWdfGkqQaM+Q86LBX+v/kL6kjEFd
	TpOeB7Kg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w8HUM-0000000CJI0-3hHr;
	Thu, 02 Apr 2026 12:49:35 +0000
Date: Thu, 2 Apr 2026 13:49:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac5l3myFf_dxtRji@casper.infradead.org>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E693B40005
X-Stat-Signature: 6fwwiijqt8ff5d384a5ao16kkx619faw
X-HE-Tag: 1775134182-477186
X-HE-Meta: U2FsdGVkX1/lrcXcACyLcXffw42BfujqYiBVDZH6oBQpUqSJtvfr2atJCYBoYO3Ntzc4GJmA9JVGHe0yXXhfMWxN8Qr23mFsyzttodnYDld+XijcngT3bXVbRaDagZm5VF0ttLCG948itTjYfnUIVYUHptqrW7KTtNp48tZmz2Oy9FNFj+Y6MqcquKTMv0VjBYRwvaD7kObjVYxB9+TdNy63Aa36U8kECOx73vM9dFnHcgHjMXcziDxW1ji37aLb6nX80NRZ7iCGMT8KbnoSOitHt+QMi0RnWjmSE8s2w9xOgKB+N+PYQgP8ki9TCg2oFVuXcivDiiWgI2/hlTJhuYZuuHfUY1h9hm2hwYig+Easdx5nL4VE5bC0N9worAoDnzig9Yh3ai4Ve9kGn8gcIZccBNzylI2Lqv4OrVw31e/1sLTIAH0cjAdt52rxM5aowrOPqn8KRL34CgRWi8VotgeihLiRQUQT9JgNP5ueTAZMotOYUx1e+weEsEvveFXI+HMEigoIgy+aAxipprjjOWTDbfnlOq1M9KkUmSygxkxvEjYWP107+Awkw94Emna5K173H3tsT/0c22nM8agHPXa+rwC26PEa0LueTXyLgsO0QkKs70RSRmWB1oURMH/g9pM05OFeoaQiOQuvYVt7vMMjDjC/+lKgemnEhsdrSwiTSx7iXUGZBYjVAcStyOZgW540s0BR6iqlYcR3sHEGiAXaAoj0PcwrG08SxC9ixK6CvD6qJEUHHA3UhiUzs8Ci55oWSeKeCuIjFhwll/V7oxgiWqwZO2QPNtyMYhqO9Ft4x3UigYmquMfbyZTl/iPL5z76THE0LM4VknFb1uxvr/FPZMYNT+MbAUSfySYpUSETcIln8mDq/Aan21VwGQulyMokLdQhkpf+8rpRnGAN8ekiXGua8y6RIP/ZjJ99TbBCz+kGJ0xDtL7cEssJP2FQJV4OGPLFfMWFAuLwqjR
 sMaSibxQ
 0dRGo6Jy+8RLOEYcF8n+QxNCrRr7raHZtfzJTD3VwXeT1oXYaGWpCkfKMuXaVXUFNoa7hzkidCUMHct5eVLbIDDxnuWBTwgSTpIrrGcsv/02C+OJNjvO1WvHwTuzYNrsYw3lZz/Op4a5iRSYhMrF8LXVF7fzBDjLEVKQ4TrSavyYCyAgevVy2QOftISrxQNIAw59puM+eXfJ48rFBHWb7EuXLpDeZNnVhsKZv+adU+4NPmnVWX5L37F+psDUUjOs6Hk2AvHS6cGHto1bni0M5JeIp67rE4dEpppIIIIDZLVpU2Z0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 06:57:50AM -0700, Breno Leitao wrote:
> vmstat_update uses round_jiffies_relative() when re-queuing itself,
> which aligns all CPUs' timers to the same second boundary.  When many
> CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
> free_pcppages_bulk() simultaneously, serializing on zone->lock and
> hitting contention.
> 
> Introduce vmstat_spread_delay() which distributes each CPU's
> vmstat_update evenly across the stat interval instead of aligning them.

But, uh, round_jiffies_relative() is _supposed_ to do that!  Look at
both the documentation and implementation.  Why isn't it working?

