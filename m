Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D18C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 15:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37DB96B0095; Thu, 20 Aug 2026 11:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354BC6B009B; Thu, 20 Aug 2026 11:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2939E6B009D; Thu, 20 Aug 2026 11:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08B3A6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:42:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 896EBC01BA
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:42:14 +0000 (UTC)
X-FDA: 85122064188.25.10E7A8B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id DAD44C000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:42:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RKGS2X0c;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787240532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulTlwX27slVFaLoUCzg2XqBiAD4jg0AAXlg4UNDOJpQ=;
	b=vuSff9QWVyOzN6eLDtnYfaOzlLVGf2piIxSh1ilzxfLy6KT56rAJLTPHc4i2BuwyYrLHfQ
	nn1izCWp48c8V5ChLK8vVh/5C3XL4Kx/FJKa5NREmQ4AoHIqFNIioK8HE+EQk6LC/L927c
	A5VK/nrUtUmB1LlQf4IuDdtelLR1TCQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RKGS2X0c;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787240532;
	b=vPExEH+YHJBLtI8FQcFtnkg6hr05AL518mm+dwEUnBMPirmYqHEDCUuAYrC4cbEla79kar
	tZq2yyIvjwBG9mAtAqfhCFBSdUCQZMUmp9w0qFNx4GaHFkgrTh/n/eSXej2Bd55evxnao2
	QD+oF1b0VH9RVXxP6JOVBbYHrITuTtk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ulTlwX27slVFaLoUCzg2XqBiAD4jg0AAXlg4UNDOJpQ=; b=RKGS2X0c6oUnHo1brczhP49qgs
	UNr6SnLdoKe5XY4sfd9c074PQ4u+LSiVaw/uu+kNw2/SbZ86YeLSRgGf6f944TDYbE6SNWUctolci
	bxorucXSRC+hPkpqobOHuONmTWd5oxCP9TYcLypfNNAjmh1OwEpZk7V7LANh88DHWNGi/8+aPMooV
	CHqnPq7/jVcBtt/DaMe+JfylsuTHQv2evDKxvKkmE1bSpEbtvsDSeJnvQnuxHaUmfrdaiaJMH1T/h
	j6f68mIkXwhHk0nz9aKyauskCDqzSDeOxuMtwmwLI7bRsYuWTs58YyU5Jdsp1aygHHqLOkn0zcYya
	LiaWG5/A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wx4qL-0000000FtO0-2kQt;
	Thu, 20 Aug 2026 15:38:13 +0000
Date: Thu, 20 Aug 2026 16:38:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>, Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
Message-ID: <aocfZSYFRvP7_vEG@casper.infradead.org>
References: <20260818163221.589352-1-alex@ghiti.fr>
 <20260818163221.589352-3-alex@ghiti.fr>
 <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com>
X-Rspamd-Queue-Id: DAD44C000A
X-Stat-Signature: mcxwj6kfu6d7y6frpeh7rfjmyjuyh8u4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787240531-278665
X-HE-Meta: U2FsdGVkX1/oi3NVVRn0Rn0r37G8Ji9/C21TvhrP5dV14l5a/IRd0ei4OC7llipZHGJapfMSsqCeWtw08An26yJSpLrYaKvB2X/JZYHXiv1pdcsYs53SNbgmcGQTp8MdvSTbuD7IHJT2mmJtEooUcwC++mDDUoof4BgBNDA0MAv+2WHmVcrUdlLXCbUtOEScUFW2x7j5zSNazYFLGoGE4BZ8n2UpCnhAyoltPw6EyYh0T1Z3QsPKvRKiFCXLiSlKjLLFhfFucq+dGwcUauuJ0N31D8JKFbquY8k3d/RrHkxZxfzNIsTAng2oRF0wwnHLsavgr80AQjt7JoYoZpRtWnILFdmMH/uBJrIqJh6XpPDf9oM9bja4zdL3awoqg7m7/7VOapSqc3nwnwfpkYOK3O01iT9bMd89yElfXFwu2uLkSTNwnDjhRJgJ+qJDnZS+Mn+JEGn34rjr10RpcMZXpzMhpsufTVFuE1kj9InHjWnBBYmQCxZb9tL+BDqnX777Lg6O309k115bnSDJZIfqsQY5lUTH1Qd5mN40l4H0Ww7A1fxQ2I8ujdsDOlKL61wydra3a6A6xYkBGWR5nVtLhMgC8kGS7qh5HrIHiak9aUH2W5mNhsojdYRQwqgbX1YuLMygsfhGPLZRIL11MqI0lz7gb67vvsRnweHRchjwFw73+hDf9rpRoIHB6A7Jil3Z28LE6o/5hSQlpJLVckmOQP0AmO1duj7q9rcSlfd5h136FDCHXsyzi8Ysxi1mNEwYeVs6/JAlmf4o8VUTQFq6Lvsc8vIT9WS8MzefF85qQN6uTIJQuDG0YyffK8KxK21YMCTe3JLO6gpIJiIWpPhvq6HlUv1MDgCPBL5JCBMqojZM28vF3HB79BfUWAERfK5kmTTPnMlCgoKv800WG3EcjKzw01YoIr/QecOCxLGPrQxoeP+Sr7yFTXH/Q6hj6aJXK3CParQEJ8ShVJ7PgEy
 g3SuClyI
 0C1Jh95ZgqycKfYoP/wX9LDbtXPHenq3xoQQ6UHQbb5MpuwWerSjw38EFnyHl92QEuDnfqCjSIjlfVCqhPo7zlj5jh/7QqZ5I9/ihddNSUEIMIofjterON6lUgLFgVrSL5zWzOqi2LqyFdxVrurdNBaI4VI9PTGtCEh3NPJdUQM4GeaJhhqbrvUs3AX2J2510geSs80DGI+Kz75RZdfb4AKTn8ZB3ZBzu5manqoWjXdfN1FHexfpVVP7VQDQgjNaVHD4dMx0S+S8Af9f+21FkJxMkfpBxObZiHII38KglfNUI0LA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 07:36:42PM +0800, Barry Song wrote:
> > +void swap_writeback_dropbehind_folio(struct folio *folio)
> > +{
> > +       llist_add((struct llist_node *)&folio->lru,
> > +                 raw_cpu_ptr(&swap_dropbehind_llist));
> > +       queue_work(swap_dropbehind_wq, &swap_dropbehind_work);
> > +}
> > +
> 
> This is good. For file dropbehind, I see both F2FS [1] and block
> devices [2] reinventing workqueues in their own filesystems or
> drivers, while folio_end_dropbehind() simply benefits from its safe,
> sleepable context. This seems a bit odd.
> 
> So I'm really curious whether this could be extended to file-backed
> folios as well, so that those filesystems and device drivers don't
> have to deal with this themselves.

You should probably both be aware of Tal's series:

https://lore.kernel.org/linux-mm/20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu/

In fact, I'd base this series on Tal's.  It would be considerably
easier.

