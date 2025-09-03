Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D27BCA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 04:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0235E6B000C; Wed,  3 Sep 2025 00:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F163D6B000D; Wed,  3 Sep 2025 00:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52F56B000E; Wed,  3 Sep 2025 00:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3D806B000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:50:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A7C0C0506
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:50:34 +0000 (UTC)
X-FDA: 83846713188.25.BDF6265
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC95FC0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:50:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EgFmYLBg
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756875033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wN2QC/8grULTUSyMcvaJ5bVK4JCfaQgLPF4srfOgdZ0=;
	b=IEbuhpx3Gxx/35VDzWwRnGKI3C8xT+DbwFnB8EsHkrwoiI3W2kmSjF61g7Nb9CP/CkEO42
	BfgeSX43iUv3fbi0JXilu2o5qNO3611VwGqyLxNDjAWKfeBkKI0nw0V1bkY0iVLEkxZ8Fp
	jJOeFD2y3Gxqsti9v18JGUalrrbhLxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756875033; a=rsa-sha256;
	cv=none;
	b=I7qnM/pqk2sJcrTDq2QUxd3s4xe91eZlpsFz2KZIWtt3JcJx2qMykSZQOmzbHzrPgs3qVq
	VWc2VyZojHtysuS54G+Np6s5R8pTZjqM7Pbi9rc7RPGpZ0OJZWdDGTL1AODAfeSE1C8gtB
	F9VPNHWWFuKSaDYy49XYg23k7jcHN1M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EgFmYLBg;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wN2QC/8grULTUSyMcvaJ5bVK4JCfaQgLPF4srfOgdZ0=; b=EgFmYLBgEkzqkkiL1S2Leu9RSf
	jdZpiLKycItf7Wzry2cgsVLTSMOccIvJ5V47LQEafwlbwIu2nx6nMtQZ80N0B9vbtBD7yNIVVZBcv
	/IdL6z+++eW0QXFff/tceqZKmQuB9oK3DUwtdrq6sj7oeV1eD4noXQL8/GlQGKjRbnodg5UiZqFs2
	hdlyR0qFT+qwAxL/xLbmmUHSoMIyDpFkwJIjfYocaM0X95Jy41ktyhzBoDXX8vmDpwqfKbu944kHW
	2YbfZ4ZOROfiR47g+xKDwnc3vItfN3ZOC0Aa6IxxoMXReBaDM6HKNkBTU1vuHe0waDhF2HQXWwTbZ
	r3gCvuKw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utfS1-0000000FK8B-0tIO;
	Wed, 03 Sep 2025 04:50:29 +0000
Date: Wed, 3 Sep 2025 05:50:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
	Jinjiang Tu <tujinjiang@huawei.com>, fengwei.yin@intel.com,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
Message-ID: <aLfJFKBZCjhH7so2@casper.infradead.org>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
 <aKcU-fzxeW3xT5Wv@casper.infradead.org>
 <bb6e89e1-ff86-43cf-980d-b03b644d85be@redhat.com>
 <aKcdBrq_xwOeUQTp@casper.infradead.org>
 <b990aa82-bc98-4739-89e3-44c96e0117a1@redhat.com>
 <1c51623c-818c-4135-a9b1-28d0b4edbc89@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c51623c-818c-4135-a9b1-28d0b4edbc89@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC95FC0007
X-Stat-Signature: 5h3oxidmw7eidfwpa4gttayz3wexikck
X-HE-Tag: 1756875032-448199
X-HE-Meta: U2FsdGVkX1+2B2oXFIA/gdskm+Z0zsjfUFNqK5CxnQ/oDnOQYQD2KYDu/+asHMy4ecNfc1Izw8G6SrJk+ATloOagCZuVPnXLYCj8yejG3r0jkbXZbO7zPd4HNZYLLIQZMZd5rrdliZSnMbmOaloTS466Fa1tjav3fe4S9uqruK9/BFxZxtVXEbLdkdTou3HZweI3QJsgRxYkz0T0C2C1oQZ2xSt41oJ8cEqpYq9RmQVUVBgE3shVSJoScS6jLv+KPZ0ZgZVNiFZhMtcjLw5XtpG7fDQiIQzLX161YcEwaavCtnttdTK5M9xMIfZPw7tO8vCgU89qUFvqJgfJOkloHC3x5lT/A8j0xYxv/ZTXSbhjGo3nE4Zg/NE7KOUParqzNVpitLR9exkHjcuOJTLGRqamoM09e2IJyRl40VPbatSytGzJdKd2ubLFMwZYIbl70+G8MTDmd5Hs1/UfcMQDE/nGzRJRHFog1x5S936tfSIUo78eeI4JtTdtRm5JyYlJcl+xfWTw99iuR1vZsHRAlPlDSDC56CJteM269MWYhEgoqujd+Ki3JCXJYSRZnJyXXkGwvNzp+iww1xeWpvMTcynM/p5p0MaGjWcOOQvJcxqvzCo5PiFmEpNKT+qkb5xkAJYRp/ARv18E1OQH1HvZgp3VTllpcTg6TliK1HFTIQ362lE8U8Ldph08dJ0Gt8wZoayFESokO/4WU5lG1tdm+MatA6VnRkd6dMLY1tDMEU+YlUwEOQMopqkAz7by6T3BXTsrOWBPzO4zgKS95fFpJbCGsJYLra8iD+topm2bkQWbACTB5//jJB7poo0/vocsPaytTU2yjminO3UESJ0kTNRxsfRdXb6jCBf0ehn4XB7YSmDfuhLhV3szN9tPD++nOLUVx26CYmudzA2VxLJAmL6H2OnTu8j/I/6/Fdsj9iOOMGZgKKf9/BgfIG9Y1NsZBcPxRtZM++t9vkYWjk8
 CdwXbFMu
 pR9l3Eiew01VqDGF8PTFVctvn7XV+AH5o8m7PXck/Elqgcr8DXtbpS5j63yo5hHeQY89HpjwrVes9RRGk0WZ6ga29vniKDhBVHmwrEqOP5lWg7FKhsoNZsVgCllx9wPahkhZxJ4phiLeuhvmdN59sthemJi5lMg79oanRiItlZgN3Exj3gIrYwBq2d5kKtcR/eRXcri0vD+Ecl76FTN2F+Yctv1ZNQfuHAFbv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:04:09PM +0800, Kefeng Wang wrote:
> So, Andrew, could you help to pick this up?

NAK.  Send a version that does not move the folio_unlock().

