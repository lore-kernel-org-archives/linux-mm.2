Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE78CD0406
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56226B008A; Mon,  5 Jan 2026 16:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35E26B0093; Mon,  5 Jan 2026 16:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62A86B0095; Mon,  5 Jan 2026 16:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B53AC6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:02:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61A2657D05
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:02:26 +0000 (UTC)
X-FDA: 84299133492.30.8F32959
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 989F5180005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:02:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=M7MVgaVF;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767646944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1LaBTj+Lp8QZt+yN0HjuqEi9ytm6quw5+aduOgQeXw=;
	b=04OlSQsW0782Qb62RQIyV3r674Y1erNuY9dsZQOS79TMX1b1e9EQ1oSGK2B0CZp6QfkOMr
	/RJu5ooil6mqF3rpVRauoeqVQNA5yhnSlgsVYl38sxt59jVnnDRO+bZ2vkl1QqI2IZFMX4
	+nWI8SfgmCVxQvacQFzhLQ24RfUaO8c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=M7MVgaVF;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767646944; a=rsa-sha256;
	cv=none;
	b=Gbf39riMn39I0xelOVIfllXBZQvvrTM1ZjbN2R5qpsv/PylNOY18PcCQ5dk7qO0TvUItLF
	UCBouq5nCp58y8wCTAjqkRlBNnyXH5yKa9Beb2Lh3Y7/KI1kyNwiQHhV4i0F7uAYZyTm9z
	/89a1ITl7wB8aC+ASgDZ34LKG3NmU4U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F1LaBTj+Lp8QZt+yN0HjuqEi9ytm6quw5+aduOgQeXw=; b=M7MVgaVFGLkFRek5B3rJ/KxO1V
	Dmr1jcWD/2KAezSGpvgxT+9S+743R9cCYMQIcmJXogw00gsItPUgsuBlgbhjur0fG8COJPjgkfInn
	LH64zccyPWS+jzgq8+CtgupHoEftx8r20X9GaipSeh8AjNFPuUjMlt4PPzxfbaia8JcjNOWJ3C+Q1
	sN9nvTww14x8R5IynMleZZ6994aArYk+NtAvV6luaUs4GNs3cKYUh2NjMyIGaytbXrczYlP/Iowun
	XbqdJhfj0AFWruepIsx5Hn/pfNFtNuh7uY3ntrgqg8avCqJzavsxOyMinNwtfU+AWvCfc3185EegI
	PHEqzo8g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcriW-0000000AsSg-3H7U;
	Mon, 05 Jan 2026 21:02:20 +0000
Date: Mon, 5 Jan 2026 21:02:20 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shivank Garg <shivagar@amd.com>
Cc: Calvin Owens <calvin@wbinvd.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [BUG next-20260105] khugepaged: kernel BUG at
 ./include/linux/xarray.h:1441
Message-ID: <aVwm3MQ_ZDa_kU8c@casper.infradead.org>
References: <aVvz3tYdu49TGkjI@mozart.vkv.me>
 <aVwB3t2wD6Dyt6yT@casper.infradead.org>
 <aVwHYFesgoSSbKmz@mozart.vkv.me>
 <aVwPii7dfR5owHbV@casper.infradead.org>
 <d1cdf40c-9535-4d79-abaa-aa1675ec62f2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1cdf40c-9535-4d79-abaa-aa1675ec62f2@amd.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 73jn5tu8uzsjtyh8fery76j1o7ug1ej7
X-Rspam-User: 
X-Rspamd-Queue-Id: 989F5180005
X-HE-Tag: 1767646943-745821
X-HE-Meta: U2FsdGVkX1/Uy0KI84bfBsus6Uar10lokchrbL2aDLHEKHleK/xNiD1irNbXrbs4iYIs2xilj6hZqUdPL5wAhvM3c1Oaw98ke1qfOejeq+cTi7aKIxMRmRcMvBaTEsR3Fc1XLQju3v8sXlkMpzEkNklzaYhM6yGLX61Q3QQscY5aY6XZQ+PHylo4/IZcwKagPPnMf+CXqZ/ks0F8vaa5GIKEiqBX3XXre5kQe59HlChXBasAvgT/mPLSZ7EFgu26S+siih6yde6ZFQaPkJo0iuDE5LncBP13DJhIwiI3Uvo4RsRuENRypkHMgdUoqoH15M+Y6zl2nQw1uzW1jAjuhB/A/VKPK1SWTlCipoVyfS7uDBzCBndUvk4tiC/ddx9LODXIfXdXUAEPUXzOM9YjVYdMeLe0omO15BNSKPIjwKpBrt64r2lUlP875uXHWzKdaOxkZ6COL2A1FJuyCnxh0gbizv1qfN4hMhFauY+VEkFPliDfysmEaO6EXDJh9zsDMjUz6QZ+1AN6rZMgljjYcho62E4PRnvvh574I2TI7sLTn7CEI8FxGw7c1OHj4WNI1uGDpuxlgCzsIASkW/zjIPlrNf7h0VUVP2rQT4a3ASnJAp9o14wGFWzn+vPvo6cF6HEP8xU04kBnjMQbu/P1QV61N8RY2MTRa2ynE2fyNxfipiXEdpfWVJA8ifSCc3srmnIeUFnp6ZFRc0rcHtXMc8m6P06M+XJfhyO1p5BE8C75NxdHgTCichF7Ax2BAbNNtZMXhzD/PmOKEnF3ozj40XoiEhko3g+lvI9+YNXPz4Kt4khrv7EJuc7/uEZTmYa7hh2Yr0D0COlKeF+7Uk1hx2fTCxUmMhMzK3yq+dQuDh70xQJis2azU1r+mxP+zxlXRoXeFVVPvm8Js6YpbXvy6OinsuEi5/bqNk+ZRyZSSNLvKY6aXwt/Kfzis8p9+KcfRLmAsyqQoocs5Ez/PtZ
 kyuL513/
 bK2I20BzSKLC+SFt0CkhBPclNxm37ewsBKXG6iLJZD9RIwBgwOplGeT8lAmZoBDP/pR7Sdx8tW4V/62X+d5H4vz+TkEywb2299Fj61kUkeAhgOzcuFNSKcB4+cUQ2sW1LRyHw5p/uhEI8F5yFc+CEYWWbXPfFT2xdOJfKMDJV9oqrZ9c1SRkH1unyZUVsZcGHmWNTFu0TQJ3bWHcPcJVRQvGZm0TW5vzy4yP7QvKufnU4Xbk/gv1gv6/0NA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:24:03AM +0530, Shivank Garg wrote:
> I'm able to reproduce this issue locally. 
> I tested with xas_reset() before taking lock and this fixed the issue.

Yes, that's one of the options I'm considering.

But we don't actually use the xa_state between the point where we call
xas_lock_irq() and where we call xas_set() at the start of the loop.
So we could switch to xa_lock_irq(xas.xa) here instead and save assigning
to xas.xa_node twice.

But this is a long and complicated function (over 400 lines!) and I don't
know if fixing this one way or the other would serve to make other bugs
more likely or expose some future problem to the debugging code.

This isn't the kind of thing where you can just jump in with a one line
patch and actually be helpful, sorry.

