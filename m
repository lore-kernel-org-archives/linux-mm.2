Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD39CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E78D6B0088; Tue, 12 May 2026 12:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEE76B0099; Tue, 12 May 2026 12:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB966B00A0; Tue, 12 May 2026 12:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 408296B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:08:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC5BBA0536
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:08:35 +0000 (UTC)
X-FDA: 84759250590.02.2B704B5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0304A0008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:08:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMotxzTT;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778602114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQEQQ/VVs9AhGm+qtGkVypTgVgwVlaVm605jGnsgvX4=;
	b=BtY3w2HfZARiw/fVhp9MlJu7ZprFI9+o1L89rqH626faQEsad1enJY7Elnig+WryyQj9O6
	ayb9gsi9293bXiy1cnnSJO4NB/bxHNYpl2YZM6dBxOdOFjm+Fes3jKyLtAwYZ7e8SXjUA6
	NetFIWa7wQlFNcm9PLaabcT+x0Mr0W8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WMotxzTT;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778602114; a=rsa-sha256;
	cv=none;
	b=MDv2X78P3ogw7cWx3KpcAxAvlXK1WllRBuc8Jpuvuc64Hu//tmyWIMuT/KlYU+UjPoGXMP
	mOQsToOhyqQ/eYWVGVKPK3QRIyipdc4M7efvPLizehD7LZROkLF1m5ZBxOzWXaBKBfp5VT
	qZPnbbIsIf7qqRE7DWLSVyqtstcuBEA=
Date: Tue, 12 May 2026 09:08:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778602111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JQEQQ/VVs9AhGm+qtGkVypTgVgwVlaVm605jGnsgvX4=;
	b=WMotxzTT7Gex56zTN2EDTCuUXloYSEoO/TNSMbbi7q6VIR1JIsjOfRhrvH/Ah77igTjH48
	wuVjVT3Ah5ANBizD0PmSEvUx6EAonupa7wSKrYFhqQd4aTaD2gTmQ7GocT6XIBDOhtthe1
	4JTKBYtHiCUCb1tilGFeczME/KueIA0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Wei Xu <weixugc@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: memcontrol: propagate NMI slab stats to memcg
 vmstats
Message-ID: <agNQNMl6TySHF4_8@linux.dev>
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-2-alex@ghiti.fr>
 <agJYrraKk_wbHe07@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agJYrraKk_wbHe07@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D0304A0008
X-Rspamd-Server: rspam06
X-Stat-Signature: gj68dmati6fbhaeyew8srchqrgac7ftq
X-HE-Tag: 1778602113-257821
X-HE-Meta: U2FsdGVkX1/Mj/atEWmpdhZV4I4Gh/5P6JuqdQmyuLC5yWEsFtYaQa9E6e/OiCfP27UZTbffeZLvU6x83dCQs/SbdEJc86reZ+JI54PaEt8xyIod6MEd42jvzF/B1wvjUkSdXU3bNpWAX+58t2fKnI9Ve83BZFzoo4VjiW6Srp2wVoqFKUq+ZQKP9/I8ZATH5VHLCR7aePkUW9pOVRwmFVykIsO46Z5IvYbhuYhCYICMgYvJStT42atWg2N4EO2TFn5lYE3n8vAXLZwGcPWKV2G7lFQiOeeWd585qhDLvGKE/wQqeVGJULgW3v86E/Nkxq7j8D0AsVF+67LhIuywc2lVyvx72qfafthtXBNdRCzfHPPYaWNETuT7zwAZ6yqVrOxsJfVBNQRbP7Rd+7PIcAhdKQjb9lcpEyqIVGFUaKf1UsXkoXk8Az2kS43HzyTUgh4qV1onD/7HWKSEv+AA+bf0zKk9EJ5iJ5bs6pPTgvJ00b+1/z0/PuvlIDmi7NDs7Val88Q91VgG95v6LoCuWzVhQth32zonV6+qkSyUFV8ujI4/vNCLesrsAMt6o1DM4YxdxvkJRsVuxDlhMsPDz4bSzQUnPZcO5ogDJqA02UsM6rjftrY1RMzIwhT3D0PTrnjgN0XoO/rSK6rAlyI7FEKblkEDURzhVXJLp8b2Iiv5mCs/McIlQom3mOqBmsYBEInln1MEvNJHCe1bwja1/sE+min0vnCZyTKjdiBQGnb2kUNW/sO2KenQOS1Sqj1Ogwx6UT8vb1cY00/QyUWW07NG87P97+1cu7GQCiIQU7cBNV82RPpzxjpDc+GFbwlZgka2KoS9xdag/Vw0xx6+Z7oC1HWIeY/b10qmEg+Rq01hkjHBt3lTh403cYE/3KSxJY2it25ELtgz7Ng0y528e6eWR4IjUMMKmC+PSpg5yl3+W+Ffy0kL0hy9vWJxMtp9qEMm2vu0WxnkJdfnk1G
 8/LVr3BU
 rOTssmer/1oF9vomhwXGv+w+khpVNZFVMtgnZYQy3TQiONvgA84cEWeZjuhm7iM54F3HJKBPG8x6n5JC+d/Ct1qSmWFSoz72qVUf8lFIUcXe2ki5hVXDfQVQJYyntd+BGaEb/C45R/D8NClXMkzSPjHKH5NFrdyQGn2Msf5WDne51n+UvHEbdE/KqYbstp5S33mdEgjAL5O78ua6wPHNxuyHl5P+BFAjAZneWF8NnfUB/IKehveToqovtUdMCS33+4DxbLw14PbfY0RkwoEppgJqMag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 03:49:36PM -0700, Shakeel Butt wrote:
> On Mon, May 11, 2026 at 10:20:36PM +0200, Alexandre Ghiti wrote:
> > flush_nmi_stats() drains per-node NMI slab atomics into the per-node
> > lruvec_stats, but does not propagate them to the memcg-level vmstats.
> > 
> > This is inconsistent with account_slab_nmi_safe() which updates both,
> 
[...]
> 
> > so fix this by propagating the NMI slab stats to the memcg-level vmstats.
> > 
> > Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Please resend this patch as independent patch and CC stable.


