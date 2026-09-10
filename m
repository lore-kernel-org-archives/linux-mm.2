Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6422CC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 05:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A09F6B008C; Thu, 10 Sep 2026 01:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A6F6B0092; Thu, 10 Sep 2026 01:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2B76B0093; Thu, 10 Sep 2026 01:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19C3A6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:52:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 115621203F8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:52:06 +0000 (UTC)
X-FDA: 85196781852.05.1B9D8AD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id A822C40003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:52:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2YEpsF2d;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789019524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dr2hlvGX1oeEKCxfnd5X9ajv/3V1RzuH6f6k+gKLa1I=;
	b=oPJU7iFFjOMMVXsg3QGheHshvyQAdwvv0GWSVprW7SWAGLwxgJwWAEPpaWZAowVy/r9S2g
	s10v/cuNnM9BJyrgej8NmWNkNnM7JRtW7R6hvttcwV87PJHkkd6b/+r/qJDLkQt4zzKYWg
	1d/u15lBTgMgWg9hmJJlq8pa8oJlTD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789019524;
	b=pAfXJkc1PFiBUgZ7K019Jj5oU8zlWc5HNNyxibDqjOcUHzbZuePJ/MXFwFW5VDC8iT7MwX
	Q6wvXBxp1AkHZbhRUzdf6FL6x4UWXNXMAsBsDyOe/JbfmVhq4MSPqq8x8iKEnKjw0S9LjH
	Azm6dMJSsycWa+M7dgG2ASZBWtsuZ+0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2YEpsF2d;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf11.hostedemail.com: domain of BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dr2hlvGX1oeEKCxfnd5X9ajv/3V1RzuH6f6k+gKLa1I=; b=2YEpsF2dy4dF+E5OuE1/Zk6cNe
	QCygMlId9eCRm2NVbsLffeSSqzYB99gs9iLF5flp3UVvUh//R01ZysL5QM1R/nsZazvygWachsRy1
	kqlHp5S2/99fGgHycoYYi/OGBrD8bvH8pyCKJjzQzmiAWUwSsFVcYy4xcFdR6BHD7Lp5m1LHvtkV2
	aEPgjFnNYdipWh0pO1JY2H+aZOpxYJ5lrn1vkFQxdRjHOegKXlWcaGKZq8lUZLXjvjzDBRAklcON3
	PWUYt2D20iByPA9g1u6y5Mm9bbo16VIWK8E7NgHiRbGGTdT5Ww4o10UajRwh/yOEqCHg2Jg8tcB6Z
	b0GhXEgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4XhH-0000000DTvB-33x3;
	Thu, 10 Sep 2026 05:51:43 +0000
Date: Wed, 9 Sep 2026 22:51:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v6 04/12] arm64/mm: Export set_direct_map_*_noflush() APIs
Message-ID: <aqJFb3VtsYtnIa1c@infradead.org>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <20260904-tegra-vpr-v6-4-79042cfa8de5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904-tegra-vpr-v6-4-79042cfa8de5@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A822C40003
X-Stat-Signature: ctd1g3iht957gxfdrfswactcuryf3sy1
X-HE-Tag: 1789019523-559244
X-HE-Meta: U2FsdGVkX1+TWCxnP0bn9EWjTgdnMT9I4DtLRerulG+fBlzPeyzWNW5MRjbfllIgqyZP5pgqEgewxzz9BT4LjKRL1KHbJLiK3q6a/GUAz9FDaSW3r5TXSV5CIAxe2k7m+d1Ot0KeD86KYpBJ+/IJmg1QkpQq2x1/FjI9Sd49MW1XxAQuDoGWnhHOi+vA1jqMbAUiX6BVRRsv3yISh9VJ12nse45373noXPuW3F2fAotmLZapIBMMLWNfHeBUQEvBzoq+4qCm6xbQ/zRVRnzsFwbMY34mQkqFclpZpRcgwPAYwnEqkdf/1tLJ1JKL8YVY+RXB8SN2zUUFw3Ju4d/kpsLllLdtvpyHIbKFWOmDqVIcZa3oLszqqKWCe/9R7XmgLAxGG03MpV+pOtEatJmF9SFJzQofYOsHvmFPiFakJr/fkXZfeGihbGDIsQMWH8ZuMc/dyUpwqIdK/bRS+gbhzR2RCD/kf9/FqhRQdcjqISmhWejQNEcuwWaNmaubsHmwxtJ+WLAOtRHO7HTCo2LDMwNS//OszmsWEddwa7FJu3YTQkgvLgGWDYlhpHZsgK/7Hzokh9WZ6+7OzJmfDSnrjKYJJXcSx9dDJBjWCgvrjGtTyZXOseye8SpLjraduC/AAVo65Tzc+HDhURvsd5HFpGjhUQgU8pUbP9YzYV5i9KnZUdL2HAAy3Mk+rEpCK1Sc+2VDuujWnkdk2xmuaVT+mzvZHQM/B12KWamkW2ZPGvHqHiTk2UDeXPW94LQKx4vEtoWPzUVa4e+Q0lQwDOBqOYeLiP2g/xqcAtNLijgNNlnCgt/kOYFW/Jy77h0qna5gNnZFe+lMj12pgBKYq/F+rMcP7yfJusJPno3ICK7McuaCaz5ZbvV+tAvhOwLFH9tfVgJESDCCQAuv1s0386mguTBghRBnAOQDbFBueKKzLww34vlIZrGWoQIwRqSC9fWuv4ihbhEJ7RClh5coM5Y
 9qvYTrH+
 snTYH59Zm8nwXLMw4fImWeQYRHUf0M5gZjLtFmxOeMiv9x/aThwaoHgVzKejfz+XQstXdsmeTAh9blomkkB0TXczjgcozb04XkEyIyIfy+4IJBNEbCO5hucN0hXsdfQwNAtoqSDHoRPgZZ9ROvhXuZEX+TmK8MUXzOS/3eK1Z2hHW9ksKUWbL1AFIWvxvBmgNSR+PlAWcscwB+YhCih8ICwZOe4aGaCen4HBjAeQ4hCtCiq5j8L3Cc4coLSn3uLT8Ucj/EgotH7U33E+Ewmy5/6CGwWBwb84l93+TXETbrp+zMIV9slhcXVkX/2gLgdPv5KD6n2C/NpwG9krgDc+kcvlixLF4ultc2/IOCXZUCR7tWxMcPXRCuKad9/nBhida+GOA6I16xmJTHGTopnIOiXJf/HUUHLSEDjawjsnYKUT3hRBgxaFwG5N9c7ciWVDmQBvbtggIyupTptp+PKtibCAB/k3JO0SHlF+lIOfuIhDpigozHhHvt2XEYB/lSqbZKvFG+lf2WLnAj6ZAOUk5q7cQ/HQhZUGBswrNmNfOlrfooNt6rzaoKswHKLcoPNDTpnZ7o0TZulkZIc12WbzzY7BfaRWCCd6k/4iVS0AmXvAtKGDHDr84+cBX5fXP+/tRZjfBfTP7FYNQn3Hte1JXNLxnjWZdSrau4B/7uAcKs8Dlsn8uNfhqGSLRWVcZo7xgdujP9ZgoEeEPFFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 12:44:55PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Drivers that use this may want to be built as a module, so export them.

That's one of the worst commit log ever.  No, we don't just export
core symbols dealing with the kernel direct map because
"Drivers that use this may want to be built as a module".

For one exporting this at all needs a very good justification and
not just hand waiving.  But more importantly if we can't avoid
exporting it, it needs to be exported at the tightest sensible
scope.  E.g. for a given module if it is so special, or a namespace
if it's not that special.  But in doubt we should have a proper
core abstraction instead of opening up direct map manipulation to
random modules.


