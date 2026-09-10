Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEAE1C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8716B009D; Thu, 10 Sep 2026 09:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8726B009E; Thu, 10 Sep 2026 09:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BEE76B009F; Thu, 10 Sep 2026 09:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 151026B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:47:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94C834050D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:47:24 +0000 (UTC)
X-FDA: 85197979608.06.D5D0397
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0612620002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:47:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpDpTI0n;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789048043;
	b=UErRw+euYoSZD+LKdmO0lTuBlqsghuL8hCKnxd6Q9ikMhdoUk9w0Dc3P53xT2q12IYNfDb
	714vrXs+38n4De4L2q5zOCGlNPmUpj1zLb/2yYCr2ZD1wkvDWgkgqVH4fFHdeevwqh38RG
	Ef8jFCCnyL6XFChfqaxuWJXqp0vMeQk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpDpTI0n;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789048043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGj0BrYPE8EmTQ0FkWSh78rcazbQbcVMpoC/ICtX5as=;
	b=jqlKBuXEJNnUOZWl17D0KnMM8S5RXCJug2ABv02NLN9DO1u/EBUfHl6BEJQ13oc2AkaqOv
	zlwe0HcE3DoPPDS5IKZ+0NsRTfulG7i0N0GzXB+3v0F4VGftwyVPK3Lg5+Og/W0szMH0Ue
	0tatiqxIvcImn3aSj7LFhZivc8EaQW8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AFBA600E2;
	Thu, 10 Sep 2026 13:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AE81F000FF;
	Thu, 10 Sep 2026 13:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789048042;
	bh=yGj0BrYPE8EmTQ0FkWSh78rcazbQbcVMpoC/ICtX5as=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TpDpTI0nquWOR1pQ4gD5SUd//vGPzMhuMt85T/pc33ZJY3LT6b1oqCZBm7Zp+dedL
	 CBD18gZruLBEQuJpOyyHmsD+9NNHiQOqcLruyK+jI522j65AYD3xHsZ2gK3J+uaYmr
	 vH0kdPjMpH3GT+kEqH+zJzF3tRvh3gCyyUToXwvhtNDRUXFa7tg8+4hiRSOqJW80nq
	 RwxasCIfodl/E8Kh7bk33kpJC9hxtP92wYGdehbIzBJN6K2BOh/CVP8NyVOiNsJ+mz
	 PuvFZFbby3DD7Km1MIye4pec7V49Z3Yik7EnB6xJ8yZ+Zgzw6jhLmdrw7cZWVKScgC
	 9YvoJz0ryaW5w==
Date: Thu, 10 Sep 2026 14:47:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/12] mm/sparse: cleanup sparse_init_one_section()
Message-ID: <aqK00SOP_XfGR9PR@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-5-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-5-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0612620002
X-Stat-Signature: o8d3c1zxzxxrhjf4fkqt5udumj8ck7nn
X-HE-Tag: 1789048042-424429
X-HE-Meta: U2FsdGVkX18WnvYl9D0epsNnURaPNdhwpKS0iKpljOLxQasWxzrvZOBYmYL9pE6eCxmMHertHmUMmogPbfoOoHK/sQgeg7iZW5xFD0iLX+8akwNhHU0WjNBZ7KsAD9oanlthvKTApA6/5016dpUHWGD5O8oEapq6C376PNw3M/+n1p8h4z9TM0uP2E8Oq+I2oOMSX8dw847ZZ/FwW1G0lmmFUx86138aROIl+kc1aV8aFyUnub1Wg6TM6gQejpc9tkTd98HeFUjaAN3UoF1d8LEqqQptTPbkBNnGxlBRpsmkRk8es/juBYFQS6v7BVjVxqrWJ6GA9TSaz8ITo35aRRXgJv1yLvEMn6Gpo/YR1xSusaWspPOI9BTHvrOUQ8ihxyihuBqg1H6/KJAQo7AebmK4pT7v6+6UeTe6RiilXUdBzWciZ7b+CQF8h4kz8kZRBQTTNbmiLfg/rdxAO+T47PAtcuxvvh2ORTxHwx1d3Dp7L4ivneYycswl/oojW4Z267kVkWD6FCvwlkiTkpaSSGUzoAYqx83TDQowfFHY87+4nRgtfz64qBe8fMP/84wAzpjrSp+HE5CdF5jR7ldheSNek+v1tMZtmcLN43ZUvaGh2i4Ut+hevUmxilKJxFOELcBkXdsIqvJ/yG2tgMul9b56ksu7CAEer11aroMz/4gmwqAP04xGLtS877BNa2O2wHVWs2im4MKrV4gVO8YNjS4uh8AsCeZs+/1cYW3rvlmRdXPTgD+3AtqpUUclV/xMZEU8swJ73m+XDvgZ63y2cuOG4DmkBY/NKh+iTCT/wL56wwiAmOquutWJ77eIsJ8T8Oyuxabl045uG60r1TK+niQJ+ywmrTGtrsOiXtTOgqQjhfE21de4cfopAdglBB3Jatqawh1r7TnX76v7NnsCErbzS938wER3XkeoJz/HH/AsySrRfv+iSlNAu6/ug8B/cPTeUUMh6EAbkeEQATm
 jLAPDFzh
 Vb82rBUABiqcTMIEzT3EEZxT94kS4c40VtnJAtO/AD3bqwJx8xcJHGE46JG1vBzTJ00cEOsOGiuk7nJjwGZ6+wbLSzK8eLqwWqDYQnPDIjG/HZKaBDsu3cuUI6qj1pma9AsokRIh/KkZ8a3WFtbKCrDtgcRzYnxt3dd4ozlVFzAG8nh7RKB53ThWnmPRJRRSOaTSEcPe/dYYU/d3Wk8swpSu0PQlSP7Ct59jUt4sKbwL3ncqbA8p+wpyo3cXdtntvzSkCj3R8P7HAlVwWWAyBjy8pI5xO+N5w6ajCjO8T013lGAKK+/L4pYMUZt4Gi/n/L2eL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:58PM +0200, David Hildenbrand (Arm) wrote:
> Let's avoid the "pnum" terminology.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Yup it's gross! LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/sparse.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 049272aba84e5..744ae29002f5e 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -90,7 +90,7 @@ void sparse_sections_init(void);
>  int sparse_index_init(unsigned long section_nr, int nid);
>
>  static inline void sparse_init_one_section(struct mem_section *ms,
> -		unsigned long pnum, struct page *mem_map,
> +		unsigned long section_nr, struct page *mem_map,
>  		struct mem_section_usage *usage, unsigned long flags)
>  {
>  	unsigned long coded_mem_map;
> @@ -102,7 +102,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
>  	 * from the page pointer to obtain the PFN.
>  	 */
> -	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
> +	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(section_nr));
>  	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
>
>  	ms->section_mem_map &= ~SECTION_MAP_MASK;
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

