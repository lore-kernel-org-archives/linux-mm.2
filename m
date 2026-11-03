Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6E6606A338
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GR3b6Ou7
Received: by kanga.kvack.org (Postfix)
	id 305876B05B4; Mon,  2 Nov 2026 20:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B56E6B05B7; Mon,  2 Nov 2026 20:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC5E6B05B8; Mon,  2 Nov 2026 20:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED3CF6B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:56:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E2F81C2B4B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:56:36 +0000 (UTC)
X-FDA: 85392143592.27.A4DA123
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D076720002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:56:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GR3b6Ou7;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oG/UK1lpPVs0T+G/uex5I6y18oVty/cZKc6GhxA17CU=;
	b=BV9lVR1SNLVyNsYwV2SGhmuQS02hCd8MEIdoovKM9Whu+7yxKkeZJsvsU8QBKiH2PoeDU1
	M5CmZB9+BU4Ln1yij2DffzQhbrQHMPHjL9vnoydRsYp4BONHPilh14nL58+o7sRtm+IGdd
	tf9P2Bc32pLfY61VLDBKWo9ZV2pXdtY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670994;
	b=TEnoWj4/6KELNGe1/Mxsy1fxEVYuW7MgzbqgPowkd2qoFHZXKlhDUBmZX1olH8VoawXk8J
	WrsQQh/dflhFbRAJTk5YEpvoRozjUqYs3Q9c1a2pixwEJWBNWCDDh+nu92RyVLEH2xzZGp
	zY/BKGNXKdqyDvcUgAGIRmNieBv8J3U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GR3b6Ou7;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F6ED43DE9;
	Tue,  3 Nov 2026 01:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E971F00919;
	Tue,  3 Nov 2026 01:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793670994;
	bh=oG/UK1lpPVs0T+G/uex5I6y18oVty/cZKc6GhxA17CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GR3b6Ou7TomFWO0koV9WkroAduiPVKsmUD6/YPTpUoTzyGLMtkji7zWzVR8FrgiHI
	 9OHvH5s3KGh9l5yDsvxYIDlr8ZoPQROdPIVZBp4enZcR6M6Ki3yQ1PYth8jSGKc7wK
	 1pe/wtsBYyfAlR1F3athy4ymdpghRh7mbyufTTPDeVvJkilhfLOLKbMMS9zLpZMA2Q
	 N0+G8PV1zOzmeTqB5KcF735yHW8kb+luK6FY3SIuSXL9J4kLjUYL45zIp9Jl858QVV
	 3RiizWoZATPLgG/cfhePSC25t26uP3Bbu/ZJVtmbSVsg5uVAn0Z4AiykwGRiImF5Hd
	 aJryq0kKDemug==
From: SJ Park <sj@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] MAINTAINERS updates for page and slab allocators
Date: Mon,  2 Nov 2026 17:56:16 -0800
Message-ID: <20261103015616.95465-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gq6y3yiwozitu366mrkpzn6ghf4f4st8
X-Rspamd-Queue-Id: D076720002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793670994-479969
X-HE-Meta: U2FsdGVkX1+YTVlApXII9TCemqe2JwFjR+QTsqmXvbDjP/a9X7uApq2OpU+IpKUCZVM9HYY+bK43zgxSjBsWxuD75x8lJI84njUVh+ZqqpXDM2fJEvl6SfTikz2cRFDF9Ucu0paeZHRkOqE9z5cYdteav+oq581TEasEeJd2NzY7ztG6tfDI7YOiw8b6M2x1lS+9AZ1ijE58Ekz0DjSvJpEqThgh4RW9yB2HzBvwwFlkcBX+wlTmpNhLpMlAoiw5U1MqqeoocZywMUka+uo/nX6AcF7tHsx7l/shap5QN8J9qzozkkjvIja949W/5m/xGp1FPfJu8g3/htljG/OFUjUI2QCLZUs5PRGqE3pEGWrLJWfLYBTo7OOidXLd+vPeVpgTCdmW3RqxrYtX+rZYPKAYeMKDbVtb32i81bo8MSlAjC5CJq26J+cjOfEQBF33omRlkHFhYfiIJMBZ1mT8h23WFOJTBZwnxZ/epfgJN+FavDoTZgXqlUE73QF3y8OWxsCQQbiyQV/j1hHFmaz/FWjmuckUp6S7UPw14Rmf5hiY0YLLz6eVgG/tasVMdckPhLlQekCTGnaGO2ebIEq9NFhcBPKXAQXevd2tR0FxsZYrAbELRFESsGHw4z8mJacJczVccWblalVkDGqr9OTxKpoZ63QGNcw77PO8zA2W+Hrw14gS4tbdDdocdc1jXq4kHUTQDc0ZleAFJa9aCJw6JvsLLqsw3FLUvL+Do2ev+GYhJ77TC0wG+vlPgcvlnJ0a42G8dXv1ZDOy50OxmWKqbEDnliVUrXk/bZXZlaeLae+YZzyItG3IIgbbG5ELa0b3Dr3mHNHzDAv4UzO4TP1rGCHS2ItqNEfv8hN7W9Phn+PxbyCJ76XswDtK2JXiRlf6rm4rirgmNnZ9pyhXLrbmbOEY3iBPBBlmZzkVkssMFvJ7c7lD6j1KUteUpQPzvD1rehtuzFIrEMsyzf4Kc7a
 NWH/3EZA
 Vsj3GOC+X0ep2MlIcEVwxaOghr6k7nmLojGmaEzCiacwRGxOO1b/qED23LJ95Q5csXAErvTE+eox8TqwOkF2dIftyr0k3j9Z4SeFG85JtJkFSp1+ZsCE+tZ+HgAt7EVBBbglYTkfFv5z3UaIgvqgAZgyeFy4B7HMxUv8vdjOOR+OcLpgs13UiUSND5AY57MtwqCTve6gb9a1RgWFthtu7/Gb3zda5lv7RLKKZ4cXC/mYEQFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 01 Nov 2026 17:34:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> Following David's updates [1], perform similar updates for page and slab
> allocators to indicate the MM process transition for these
> subcomponents. Importantly, add Johannes as a page allocator
> co-maintainer.

Makes perfect sense to me.  Thank you for stepping up, Johannes!

> 
> [1] https://lore.kernel.org/all/20261030-maintainers-v1-0-97278f8a5f54@kernel.org/
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

For the series,

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

