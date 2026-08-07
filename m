Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445FCC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A846B008A; Fri,  7 Aug 2026 15:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C376B008C; Fri,  7 Aug 2026 15:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B4F6B0092; Fri,  7 Aug 2026 15:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04D2E6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81C064005F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:54:34 +0000 (UTC)
X-FDA: 85075525668.30.2A11482
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 41BEB140011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:54:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wDf4fvEL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786132473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvuqynFpvLEv8znQBXI4u6NMqckqKnGj03gNbREOV2c=;
	b=oWgCe1FmI5nIf8Hxot420ZE9FjpZ/K7GQpRPnUHzXgCTicyNOIZedxRIdxCaA9ndHdi8Ww
	ZXQ4KKyJBi3QLQzmYLBqFpzW1EvpJ6cdikXfg4LIhITwBaTZaP1q2Chxa23phxRaA34gCL
	n/E2di9X/XwLsGZlTrjuJYsASsskjSM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wDf4fvEL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786132473;
	b=ys7lcnAe531gkt6Y02ricl+pFuMtlgOjnEQE5fS577+moOYTrsrS/3NOuuHZhbtfxoRr0X
	nf5hlzGd2QCYmj8ptAQvABgkwWYCLj9GVPGcq4ku9zOzlWaNkZLMq/btqQ9cKdt8NaL2qt
	qMMwExgdqUItaEqX9DWTPmx7MgKevRI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wvuqynFpvLEv8znQBXI4u6NMqckqKnGj03gNbREOV2c=; b=wDf4fvELz43aS1pKGASazu8nBs
	gZ2KZsWvbbZDVqFvfxhk3i1g7gstTA9wvkiuTGaeJPn8V1ccb8R7S/KrfMex3RyJmDYJH5/pei8iU
	IT8TXQsIs5s4ZG/unNU08xCAUUQRvcpjNXgOAZh3GdzVWTt68E/mwtRFH7OmkZsO9Xxnh4lzcj+0Z
	4wJmw2xP6iCSqcUHBdSXrmoktaBP51SNfiHI9OKJ4ASEJ1cJVQ8PvDA/Rs8rZImpxJg/76/BMHDnN
	UgnfircSjWDBds3GWNZSVGi6+d7hhEEQANggL4JmVAqADJxJpLTIIThDhvuBcdvL+qFDKdmq8CnI3
	kKBwoVAg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsPjl-0000000DRxc-0jo5;
	Fri, 07 Aug 2026 18:56:09 +0000
Date: Fri, 7 Aug 2026 19:56:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm/page_io: rename bio_associate_blkg_from_page()
Message-ID: <anYqSDnC2BbJXv1h@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: i8111wh1uyq31yfi1ncy5sdgrk66n65g
X-Rspamd-Queue-Id: 41BEB140011
X-HE-Tag: 1786132471-197843
X-HE-Meta: U2FsdGVkX1+tcBgKw7w5vofp2LdPK3RvbY2ul0d0EubSiElmt0UpzK73AXJOHxS5+PYRv8KLjUpzLJDO39IXq+tnYdT+IOrLoD6G1Yc12q+lRADciCvDdIljq9+BpUAxCa158DwWt01Ld1pvUhWmPGgBrRBzLMYX6pbGKt4R4MR/4G8zivEVGOng193Lq9hdC3N2tnZwu8v9mfSZrVXcK4uKrBjiCoamGpCT5EkL+2vpvb0+ATLv/kgV278kvOYG3PMENroVD5mb2XWbwVCpvmE7R8E6OLzoQQa6GJD0ZwrVlRYtG3OKF/EX9gUKUi0N3Mb0ol8C9M+R9h4BONh2DpyCjPTVlQ1LkltY7DJ6w2VvRjUSUMBZTa3O8LmZBzAW8ieOKFQWRQ0xE4gMwrAp5rdWYopEcTiAYrGQbDffX4RrvSCWrLM37oGIh6pDmIWK9ro07MvqsIiuiR/vSzzV51IhjM11FANPWPxROyT+CzB8pkDnqpTmH3WoIfl+VlaA3kwVVPWx3zL7Mi2U/tcDAVfN0dIX34nrExqu9ihTs92eq1663yLLJY8M1mMBt9U/jibmK7PmixRUhQhVu0Afw3zHCCIWukmiut6QYdz245RwWnkI3h4YaV47MfOKw5fA3WSiBrD/4ZCzfGzuoKFsyMrvK55OXblfX8MA07T2qP2DiR14iTctSRsBBgP5Ic4kVjjigRMxhcauZv58UcCBimscO1cABCoCTjoHraXmErqEzZuaskRy6hMzqyMS385DOkRjx3E/uCMdge5F0SPiEJiWOAtEz66ueRqDkk5u4SA3DvgOPRyG/+lu3rfbiK39uV5qDBLJNzIZtE4V3e/6ZJZ4be9xKp6GQYboD7GZ6W93ZDM3PnnKS5tQBuGBK1EOZTsb7vTi4jf9V/W5J8CGYewNTQSlJLGqgDkQLN93AGK7AsluURZDJQUqgrnwav7bymN9sf1AmyJycvZZGGA
 wmVNWDSx
 JGF5S0nIhkjztTH/jhchHdAhtHvTL0Krm8vvClu6venZlU+bezgDzl4DMhzt4xYlD+d8DO8ekSMDzFUYruk9MwJvLwHSj2XDONL/v8w/bdeQ4a/ubsL/vx5qd21OaAMMafT5FzIqWv314Ma4zUn3bfaNwGBVIxShK8HguOtZq6hQMwW2DtwMXa82QDH96fDXxsBDz0xyHcPe45CjefsTZ+A1S7CPHpVRmugOZYj+d9vBc2fgBz7VZtGk+Mujxm4vLW56aSia//x6HWrCxPWODCVnmDycUS0DyBxH2xv51HPFdoPKxkjbFhuE4fs8FPo6q0UNA1gyX2EojO9WHJwao3LQtjnBqW4bIooj9zryNTOcgcgalBJcgd9It5p4bFNa6uzFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:36PM -0400, Tal Zussman wrote:
> This function takes a folio. Rename it to
> bio_associate_blkg_from_folio() accordingly. While at it, convert the
> macro in the !CONFIG_MEMCG || !CONFIG_BLK_CGROUP case to a function.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> -static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> +static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)

It's s shame this isn't const-qualified (after all, we don't modify the folio).
That needs folio_memcg_charged() to take a const folio pointer, which it
could.  And folio_memcg_blkg_css() and folio_memcg().  That's a followup
patch though.

