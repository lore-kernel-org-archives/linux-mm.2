Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BEECD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F788E000B; Thu, 13 Nov 2025 03:40:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116F88E0003; Thu, 13 Nov 2025 03:40:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054748E000B; Thu, 13 Nov 2025 03:40:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9DC58E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:40:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6A9C4D415
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:37 +0000 (UTC)
X-FDA: 84104937714.14.C7E0E36
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id D2DE940015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:40:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vmluMEYy;
	spf=none (imf01.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0DSnCyN782tsZSY9HxWi0P19w6ogG/u4dRCTbTMALg0=;
	b=j95xbUwOULMin+UmT0T6Xfn4yAO270zNaSV8+XACwdkpLw3EiZFVvedoMl/33eGRTNfg8W
	9ZOrO39c3l4bDNNCYw1ckM2mrJxHkFk+vBlYhBUg1Kr0ISC5jFPU6CcCMy70Go81UUSnGn
	+JfGSgOYgoR+alNOUAAOxeun0rUpTyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023236; a=rsa-sha256;
	cv=none;
	b=bXfefMXzM+kybgP6C+GX54JnkusbbgxloEzVBIfxU6KZGL72SFgECAmqA7M7X1HihBWsK0
	obktcwtt+ZCofMTYktZaTcmudlLVpjpCzYrVocd0NIlbHerzuXYpdYw1ljwhQGqkEk/fKT
	nX8dln747z4tzEBO20QCuZn0BBNl3dU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vmluMEYy;
	spf=none (imf01.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=0DSnCyN782tsZSY9HxWi0P19w6ogG/u4dRCTbTMALg0=; b=vmluMEYymE87yQo/+5NpaqWOA5
	vk2QkkVYjLMbXxinrmKBKeDOKwvFquZgnTZoscjXscrOqjVTGHcERPK21QjCYrKjfqAvmEMReho80
	py4Uggydyd0cDtfMV+o3ajrQKtvnAaNXhpOD6PvxVo4NoRzKL/MFoe+4mSdVdbntL3VBwANkJ6Hxr
	5LzGi/fxUUmvR4wNWR6NZ5AdKbwm96Xz3DAt/sEWRIpbqoDbz6+u0MTQwmB3ZmrLYuOndCU1K+uLi
	haOUlPVk5HGHeSTtqURUFKh0FWBvTXnV2P65L3hR5bjsNlAuAoi38vo0iO3zOjLhtHfMlGH8EDG09
	xjeZkuSw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJSsW-0000000A7Mw-1Ac5;
	Thu, 13 Nov 2025 08:40:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: mempool_alloc_bulk and various mempool improvements v3
Date: Thu, 13 Nov 2025 09:39:41 +0100
Message-ID: <20251113084022.1255121-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2DE940015
X-Stat-Signature: 51ibrco93kzgcrsoq79rw36xw3y7yw3q
X-Rspam-User: 
X-HE-Tag: 1763023234-497798
X-HE-Meta: U2FsdGVkX19kGWLGfR0kAx0cTibuqoK4njrDHU7E//bK9b52fVPPB8/1JuL3LYAWH2ljGdjn1JkLef1+gcVad3g+CUnGMyOe8OJylDFrJcpKEkz4gl6FotzO8GimfhCT9hP2kQXdGf9RcAJcN7DVpVF4kOrVVQ0Ca5IKJAm+05CS0EL6vMG6BQoOWSzMV9wkwW80MWiF7CLxIi1p9DCQOQAGUU02GublLHkWQZjZkmxu/pua5APdZWolYVHZhB3Y+er6iqsPwAyClSVh4Lzf79AfnK9SpB40s5TACRO0llddLvogIK5h8YD24xnazsZvEImWDEesESYHZ0HYLL4J2uTRw1tFL1qhk392bARlqhVczMKPGkNWIyt57el9nrYEfGVg0K9Wvlw4i7U/mfl6ZJhVIOu8KxWCvWbZHND76ivYhVFXO1v5kKNiL7VkcMkLphZ1NDGa/J5mMFJA56MiPf9Su2VZiKqCFtgty0BWLEPEBanJxVyOcXPthmSrnJPJjmREfZesq2dHWlHKFmM9SyZ759P/0BDFn3Y0SK/ejSA78dmKB/5k41viQKU1YCBQMoF7kDwaMpTFn1xyeoEr7W6kJzEUN1emlyjmPbWs9SzAKD+7ttKjoDjU2lcndSDVha6f0F3TNde32M7fL9Pa124XTSwwXUE4MaxrIpW6KbDCEknt1AHCgHM4L7Agei4M6uOIQ6r374IPzcuApvNRhAqQ79cZytNXaYaYeBMdNg9kc3ier5GzBBymp2E33ovOkFpboM/K+WQDPB4g13rhddGFGIYJlL814fj2yChmWTKgewJZbrFD/EKIZasd/+5mHYjPJkbxBQfJseTGqTCrnDXg3bRLywXWPO2bZZ8Bvq0siHSrkxKMcV/TN8TE0Pv3s4ekLcuRm6DoebPqHhDPYSdIi6pUizqZogz8qGpYalCt+TyZ/PIhBkqbNjM/hoJJKDB8VlSiG9kKvyRMg71
 Xs+Irq6x
 CCgFNRbDjx/xsAILKIs1G+L2X7rraQRCFyQuO/fXz0yBI1gpjdmo6utsGcM4sXOluzAYGHu/F+8FfwQJO7NT2Xzn7M59pJ9oVyzIiCy5NRLiDs8CLa0IuwZLs2Lij6P5Ljx/YNKJc29p3jLE+L3ntDdj5OfTIdZV9SrJBIPKm2lyAZ+GHxgpGDCx+Z8iCKrL41JP718/sJyFUOiIyydUzHLhxhB67JeLFZwcu7oegE1fjJoVdDWWkZFNTn1sbmy+oAgVz4vvyX66y5Fb4/8YvHBRZOqs7ScoVOdJjPauaZkIzQL0wHcwDu/k94BzpN1Psl88K817wvH/nn7KAk9DNR9tv/VqEiQoQPVjgIu536H9Kuzw8/V/c7NcNI3FT8STQvwK25r6UL5C4hEUF7i49w4HZ4pto5UrwjqAUM9dcT69VYn8D9q3iFIzJgjPfiwfCFLMguy0dY97Z8PCsYPT8O4EYXIR45OMGxa2eTq3wcuJwNbaK6thSKJP/J1nLOQaTG7S8OP8v9WSpUXVxA14mMJvZljfm1TI8c7OczITVCT4oE2mwzozMoo0auZzhzGZxROXitdVI3EnJa+/pACWucPmo8ENiEndrsJACtOf0/XvCcJPuavIktFcjFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series adds a bulk version of mempool_alloc that makes allocating
multiple objects deadlock safe.

The initial users is the blk-crypto-fallback code:

  https://lore.kernel.org/linux-block/20251031093517.1603379-1-hch@lst.de/

with which v1 was posted, but I also have a few other users in mind.

Changes since v2:
 - improve the alloc_pages_bulk documentation a bit
 - drop the not needed race fix again
 - drop the gfp_mask argument to mempool_alloc_bulk to reduce misuse
   potential
 - add an allocated argument to mempool_alloc_bulk
 - drop the caller_ip handling that was already not required since the
   last version
 - add a few more mempool cleanups

Changes since v1:
 - fix build for !CONFIG_FAULT_INJECTION
 - improve the kerneldoc comments further
 - refactor the code so that the mempool_alloc fastpath does not
   have to deal with arrays
 - don't support !__GFP_DIRECT_RECLAIM for bulk allocations
 - do poll allocations even if not all elements are available
 - s/elem/elems/
 - use a separate failure injection know for the bulk allocator

diffstat:
 include/linux/fault-inject.h |    8 
 include/linux/mempool.h      |   58 ++----
 mm/mempool.c                 |  401 ++++++++++++++++++++++++++-----------------
 mm/page_alloc.c              |   15 +
 4 files changed, 289 insertions(+), 193 deletions(-)

