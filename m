Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD89C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2E36B00CD; Wed, 22 Jul 2026 13:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373C46B00CE; Wed, 22 Jul 2026 13:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E606B00CF; Wed, 22 Jul 2026 13:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEE326B00CD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:11:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 606E91A0298
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:11:04 +0000 (UTC)
X-FDA: 85017052848.09.21D057B
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7DA411C0002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:10:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVvRpmEZ;
	spf=pass (imf21.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784740262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fW10j5ZOn2YlrXHCpCLgSjE4oo74ZZ7Fu380qiiGmZI=;
	b=5bkAKdn6l2WG+dIAhE7e+FiJiAzwJ0oAszc9GAwC80m/0eniNYxGNH+6U7X0cqZ4Kh2RDg
	X22VZXURBOdZUPzaIF8M8DAEKHtyGcPymrMT35EL9wbA0z/acL1oRHsCVzPXGuT+Wz1NYi
	uNm650c+3OQGGUeF0dhyzsHDo7LZoMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784740262;
	b=Wz40OnLucauzPRgKT3/9l7RbjFCgh0JkgvL5Oo1WNqbPbJsU4XWFfPgmLEe9c6L52vUOwS
	CgfGUQ6bfIA3XEFr9j4A1Tju8Atv/VLIWqWKfmGSVdLohLj84BB8iLl4yLf+QA71oY0eyD
	Qxx0lWbqyLfu0Q3jOWrprc5JnQ4W6Us=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVvRpmEZ;
	spf=pass (imf21.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784740257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fW10j5ZOn2YlrXHCpCLgSjE4oo74ZZ7Fu380qiiGmZI=;
	b=LVvRpmEZ7sWk0oPATEPFLd77SRo1pl2mZf8svyLk5An9WMOdeFr2VR8DAjJAY/JsZ2w1Th
	/dp2jQyTc9rnjiQyoHG2HqQyp8W+0scGwhBdaMh2m8nojhUXXI2Lm14pJ64Tqh2g6+L9ap
	sj3n0CzgAZRW9dn1CAYBazoYTwg5RR4=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jul 2026 17:10:53 +0000
Message-Id: <DK59M9QYZ6CE.397V5ZU7P13UD@linux.dev>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Zi Yan"
 <ziy@nvidia.com>, "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
In-Reply-To: <20260722150006.3848560-5-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DA411C0002
X-Stat-Signature: t1hokq43sacr7zrfm4464fuw5yrdtpcu
X-Rspam-User: 
X-HE-Tag: 1784740259-95638
X-HE-Meta: U2FsdGVkX19wGgNMDttv45QtHb+ayZuyY18dv+WwJLZKDyQ06fM/nCVRlAARgwA6Pp/he9k3P9RipRrAmZgtE6ZnIxTMUVgfYzN3DECP3kCgHlV1ZtYJTQjtApLkVoMn5IQdpJEv6WDfIJxIeGXwKN93B9txx2VrY+dPPtYGMVGvVTVzG1cYhwt1+L6bsXlX6ZG+PRHEzSpTONHXJ24G3PylXEmdtzsPMH4CNiXn161L3aGav8JwfndDAlRWHxnEv5YNYUolQtLZYrr/2LE9jxhjQGifVihE1AMdWWVJ+asONFZaqpJF54hEx0RDpSxvg8+OLscoZh9f2GttHf+IEZvkPnCfBZ2G5FpEm26PZRD4mQ0/BH/nszyzk0m9k7jMUq/U/vC3ts8xli3RbIPpKQi8e/QlDNFJE4fNNNwO2YLHsDYgTSsg47TRqou6Li5kqIOFFQGxUNYNi1UHbxNl2jyr2TXJGWLWk/cQmpkbg59ABN0Tt97oCrSo7rXCqjlk9OXuT6EkvZamlh/mYw9ouT4zAjp3IDX73Oq+WMppALQzAME+L5PImfH/cGUEJEEWRk/TiLsn81xOhTqBfNxqCdVne3IlWZFOKEByR9XFNy6WnHLiaYGgdb7JDaABjHOHpuDt0gf5GORyn92LmhmmMeFzZC1i2xE/gGXBeULO7Zs4IXzwHbv+Z6ut5IEOQ4X2lB5lY9XqMG2sAMz/ZJjPVHjgFyql4chgRB3f86FiiEiyO1HBl6O+miJi9b4IoThkWRRaeEihTbLshQnS0F0N3ZMNZmvrLl67lMN65gWqHjNDQQpWfZQpCAN2VYW4RRAmLS5pphY85r/aCHgpVIY8VaiNqD/OU/F/sv2zn5/zDGPNe9BxUPXEv7G6+V01OazzUIbYMTFUZRVzyznGzK9iNnIIA19ienV2OQUmKKgmTx7KT7L74wK+Hc46u+D1r02W3S6olfHmGpxFgmaGoBb
 sY1QLR0E
 UyMVq/kUAwcPa0DREzYTEcaAH4E7mFPYTRSM0RmBBMOVGYQmP89+CmgW9/CdWO80eSv01gugdLzxuFudxkQkYf6zEmrEsb0dptK00QOxzSWNVD84du3clVp8/Z++EPOdq/9Lt6uAUapVrcS+UPpJjVpWzNtqCZU3RvT67DP5DbSobUDchWpdBZkV6xlZkelisxTvtVnBSELnw/g4Wa9+7oVSs6nsjJnZFij9kVS0f2z8I5S5D4FfhLeIpzGF05765S+ru2aNd/k3RCu002WnsusRDVDqrhOddIlilk8V74N15ZMXdn1Hz0cyFfjWujJ5+qRyu9LEbbeinMVZZM/d7smDA7Q7HfLZGWrxAhIkBN1hfxhX/9GLjzb1VEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 22, 2026 at 2:56 PM UTC, Johannes Weiner wrote:
> As we deployed defrag_mode into Meta production, pressure spikes and
> excessive swapping were observed on some workloads. Tracing confirmed
> that this is unmovable/reclaimable requests spinning in the allocator
> and direct reclaim, causing excessive amounts of swap.
>
> The initial plan for defrag_mode was to rely on kswapd/kcompactd to
> produce blocks, and if those are overwhelmed under high pressure, let
> the allocator fall back (__rmqueue_steal()) after its retry loops.
> However, that retrying results in more reclaim on some of these
> workloads than we'd hoped, sometimes excessively so, spurred on by the
> !costly order conditions in should_reclaim_retry().
>
> The storms are dependent on the request type. Reclaim will inevitably
> make room in existing movable blocks, since that's where the LRU pages
> live. So if movable requests retry on reclaim, they make progress.
>
> When non-movable requests spin in reclaim that isn't productive. They
> cannot use the individually freed pages, and the process is unlikely
> to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
> They spin and overreclaim excessively, which tanks performance and
> triggers userspace guards like swap exhaustion or pressure based OOM.
>
> To fix this, send non-movable requests, regardless of order, into
> pageblock reclaim/compaction. This way, they help move things along to
> meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
> and excess OOM rates are no longer observed in production.
>
> The longer-term plan is still to have all requests, including the
> movable ones, help make blocks to spread the cost of defragmenting
> more evenly and fairly; combined with proper watermarking to reduce
> allocation latencies in the common case. However, doing this naively
> unearths scaling and concurrency limitations in compaction that need
> to be addressed first. Promoting just non-movables for now is the
> minimally viable bug fix for the above issue.
>
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Just a note that I'm rebasing my ALLOC_UNMAPPED series onto this, per
the discusison here I have similar needs re making compaction run on
orders above the allocation order:

https://lore.kernel.org/all/17f2f1e7-36ee-4d90-af1c-1fbca6f94025@kernel.org=
/

I think the way you've done it (i.e. use the capture_control for the
"other" order) is good.

