Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A2BBC5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 00:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128506B0093; Fri,  7 Aug 2026 20:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1706B0095; Fri,  7 Aug 2026 20:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0AB36B0096; Fri,  7 Aug 2026 20:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE5446B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:59:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF90B80258
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:59:44 +0000 (UTC)
X-FDA: 85076294688.06.4CB0EF8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 82894A000A
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:59:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=teq3OYj9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786150782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lnAWSDJz7M54oUvOeSPqI6AQS45hZvXL0DdzAmbuhs=;
	b=HAEgEPoh0PQBDJxJzyG4VK2l+c2o9sg5uqpH7KyNgKF6hZNYqv1Yi65FfhyXIQK8LVEQ8j
	OliCBAEOzBtOIpKTPB/vwnYvO+imsAZeOGRUWL9AuphH24MgrN2bJKj97/0/MgRW7rvono
	41C1puOuHlm2Jq8rl9ZCXfHSwYA/j3I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=teq3OYj9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786150782;
	b=IjhCQIkbFYDcfjIn+mq2/1Vndl060GBg6BiaIjqBWDs1nwynvJKJ5uiHyGk7gNXzuV3vKn
	4atzPsuGtm3M+sgIsgreJ58F3twv0/+UeZ0+o1kHjH2G1jzbYvB7xeFsPXFhYNiZgyrdca
	H/mHtUi1Xa42QkZvTHeTbQV7HKDTLXQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5lnAWSDJz7M54oUvOeSPqI6AQS45hZvXL0DdzAmbuhs=; b=teq3OYj9qhO/w45xgzAPWCz294
	7SYQhIl59zgo4xDUHcsDAYstNI64BMeMtCn00kd1w2XnlaAeNoig+t7P7D/r0T8d015Xk52musjTx
	ZWKRjikrj1SME2Vf9vJ6ho5s3a8SL24He9VI5QTLUmRxloDaUaTxuwiI0LDxH5oVxiOxOLUyMeyUL
	M0Ac8ibdSvxJBjA5q9XfCLJ4oE3pcuUd05iZk+B5KEX2WuVpXRFSNaJgO24QodB3ly8EsCqIx1b3k
	vMaDCoO+KJz33o7vEZs8UJDnff/qmoE+TaKFwMnFKiEOuSU9EovfYRUaf1OwkviCDGhbZ+nepbjwl
	thhCbw+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsPtO-0000000DcsL-0ZNo;
	Fri, 07 Aug 2026 19:06:06 +0000
Date: Fri, 7 Aug 2026 20:06:05 +0100
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
Subject: Re: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
Message-ID: <anYsna7UyRe_oLuQ@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: kdrs99dbekx9zcxsrg5a7omhoahncy7m
X-Rspamd-Queue-Id: 82894A000A
X-HE-Tag: 1786150781-68579
X-HE-Meta: U2FsdGVkX18JTb+OeVcDaimQ6O7zuXZnGZWQh+VP/1sv/T74eyZL11z7m9V3ysTQxGS0pZWIEbw5SCa9zJiQiWCDAGRRzcuDIIN/XAYlBHNMJ4M2lFGdkuSqcnM94it+9ez6wupObdoPF73Uop3asYDdSIM10K7d8vcz0aykDpUrHdS53VbU878GLVuzUzUmZk579R40mS9ZiHUmVdY/Bfm3vFCZnQNNXtHvSk40unr0eHtCnxbghZLdBZXvqmyMOykSJVVR+AhuhF1asitR3Yv+irS8/3WQ/8I9Ln+mwaijD6eclbO2VTyPS7IqQVeHGf/nXWJvsHMF2Ay6ZW3EIVw788rI7pUBcSg7BCm0yozuc740xYdre0ij5AUAZQOyVD985tYcsROcEbNiLEe7e3mr8iD2xRBuO0iv0XTLje+/f/n49RZgN4HEZVPDezdRHbm66NAnuBgWtr3KBeSurR8Qpty900hTGwdsY07Mgd8kxI1osKJxpGZ/yMD+RR6AcmH924fLRTLflAtrVXjrTGN2t9gLj0KDKrAtt77wyNeEwWiUdzOiHu87nZqWmSWCxHRWKiOaEZ7pukXCFnBjsqKK2M5u+gUxdu4vFO/RoqBU8GUsCJpBN95YPQRFZqHbDb7oCoZmRRz7R+QIWgYY73IdnLq7vxzcosKOJdaBirYJLu1SXe5fw67seOXR32RbJZair6O+ibdKQO0mTI/RG8J90Ld2lynUeHHSyUoFdhRp8qQRozewwVNozQa+2w2EZ3gfDJKCm79ivmnOkszv3gzTWAeCpsQmTKPNY6l0irnohtOZE1hTjmgE1u8u3xEVSzwX47y7sjhv4sLFXr64K8sjJ9/HEepnNe+s2Bus8jW6w6B7ETDeZ7CU5YKKKECaJtsAAfqH8M+SiZ868dSvbcg0cyVF6fYYxrh5Br8T0o53bzAyLrBgxBOVUJ5Zh6f7Fp0jS9nCzLZyIOqbABC
 U1kyahO1
 /t4V12Xy7zFAuER35u+3XIWL4jJOwFqvKn2p7Huxr2gEBuifSxaaEwJr6GJWKV0dZJM4V0e/SgvxVAjGHv7e0UGeaaozQL61u76qCKnpIEdodhbZHP7xtTXXzu0nQT3/OGfUNMT/dvTHsK+cjVR7KvQcWspD4db9PN/cpPuxDXl0iEqxmLZhNVErEjDj2M+YzyZfd+LNkOrj+mbYQEKay7BmSg8x/gfwwn2tMCZvM9koLbDjmnl/q0RvfDzSsiG3JlVsE9r3eJUvCYRf9ITlTSv+UxAuj4YKJKf1SN3mQe+Ib0wEPJNFr1XS92pmunYHaAWGD6MRZ803lUhJhjgoC/biBS/X4U95JeHfg3WSLdoH27zwl1fXACcprWYwoLxbXIPOm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:38PM -0400, Tal Zussman wrote:
> Commit 84798514db50 ("mm: Remove swap_writepage() and
> shmem_writepage()") renamed swap_writepage() to swap_writeout().  Rename
> __swap_writepage(), which operates on a folio, to match its caller.
> Update a stale reference to swap_writepage() in swapfile.c as well.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

