Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEBD60A382A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Qm2X8Dra
Received: by kanga.kvack.org (Postfix)
	id EBA076B05B1; Fri, 20 Nov 2026 10:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43EC6B05B2; Fri, 20 Nov 2026 10:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A926B05B3; Fri, 20 Nov 2026 10:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFD1E6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:00:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21166A8FA9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:00:49 +0000 (UTC)
X-FDA: 85455809418.05.49B1A0D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id E5FA91C0011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:00:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Qm2X8Dra;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795186847;
	b=vDAYpbbQkkZJlE2WnKijauK6m50TsFVg0O0S4/cvwglVVhNkB26pLPRQB0nNOEmHyPy1sI
	twMurn1S/JvlwMoLkj4U9lMWWysSc9I0wV62s0Q5Tr9h/FWpiA9kJ2t+uEjF29nBDInta1
	6wgoHAdlgX38uollPdlQ3LYWzHJ5pGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795186847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JBlPJli6OfYtaXbnsCRcDvuo+f9RBF/Z1J4z/dtryI=;
	b=C2rWusrwqK7w5KAW/2roXwMqNgYL8GKSKf3lUv7M54GKSNlJJYVDY/aVuUyTghUQ5/Ib95
	/1m/YsTvWNUyw7xWMinM5cRovtDSWV7zAoSIEnFBNm5rgCDcNU2PRMh7w4wlGgU0ZJV1mF
	3bCv277y6YCLH9pQRGpp5iHVPzSWzkc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Qm2X8Dra;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5JBlPJli6OfYtaXbnsCRcDvuo+f9RBF/Z1J4z/dtryI=; b=Qm2X8Dralnvmkui8wBcy3AnGza
	vl1q3g28aHQOBYTda6mEogDwRpsDSdw8fLBz+wcx+0lQh/78BfX+VHFOqpk9eB4wmnz8Ii5P65Hxv
	nbiNFH98h8/7LdtDGqe2o1CMVVLDVe2aWc96hu/Rr3Ej1YAScqn10ClTeEbUTC/TuVM79inFMMT3G
	URudZ4CPQaS9N5X0DabQmCB9ARkKIKKuPxJEy4rgqIq/z5O/ATBzKhbsxUaCyjz+JZYGocQjCRFzd
	DAQRKT0sYE+4ZLx8FfJ69+usqHd+rhbUCyZkFpYxnm+3ADWpZbgZiUqmzLw688PixPLe+g0dzqYRZ
	RayTdX/g==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUQ6A-00000006Tl3-228s;
	Fri, 20 Nov 2026 15:00:22 +0000
Date: Fri, 20 Nov 2026 15:00:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org, driver-core@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <awBghmT0tiAh7OqK@casper.infradead.org>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109182533.3594984-1-lrizzo@google.com>
X-Rspamd-Queue-Id: E5FA91C0011
X-Stat-Signature: rdw6yma3z8e8tqnhoayhpfsgr7rio8id
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795186846-703219
X-HE-Meta: U2FsdGVkX1/knYfQ/4T7qjUqrq3o0+i1WaBU9k791QSoEkrGBe577WPtm4RZ3cexkgVKQYao2GI0DHqm5sucSw+oUeTou0ARfE7Yl8d/Hp+12NyY+RFxFoOlmdSwgS0J3dXYrUeffxjosyyCcB2awFc/r4OshEV2wTsB3nJzv4T8J9fWhaC+ZWbCW3KddQjuqCexykA2OtXHFiPTRii+xuhUS0XbqEItd/KQhzVndOwcgz67j8IDOvH0ytPfaYqsQkKC6He65wPqyvHRU31vx/YuSSeqGW6xDiSZhJKLnMbcKH3OSzqqQIjNKsv6bQkM0ug+iFAZq3r0hg0J50pa3DHMylDAKyEgyIAmdfsXKvxbxENt8q1+LfkXOkRlEW6omdNA5cXXbz9AOun/w00l1IOFanGoS7Hhys4GM+1EFWnwTIpAyxbDYwfCUzZYGyzy4g4nYvS5K2ni87x51D/ydjgP5GNJhtSZ7cuZ2/VAx4RSfRu32fjIdODAuc2illprsFEdhoMNA68DOsHHmHBU2pUPD4EGFxcvioCl+eLmPfqxTwJ3mzphotSQi0llY1G1iivM6FDX3bGBaUa4xuDalciBioEyk/JCyNHKaXiG3M91c6f2uIeZplJkJxnkVcBtCtELEUKTSJ9y/w4HklUyDE9m8tJ5R2qjLlhu0wQ2yINJKEU7Glq8cRUr2I5il2B8lv2WLjJp7mqjl+fxvrXgBKYQ7CXJ9/ta+jkFk6ZLOuFhBv7wHdZwHOVFYFk7IbrvoCLYx+ELadqQZm2S+Gs5w+1Gg2xydr49+fr5EsH//50FABoDKbnAUhzEaZwZmjOwwALvWE5XsifbtCxTXP+SnAok4gTHLZxNUjMiaJ6KhdnfSLIgg5pgEkPUgU3+vDpa3wqEIl2q3JJ6nbJ9b82NrOUemqYZATyd/NDtJD/bfpnUjMNjRScQDOI52fJQUmt6fGCpOrnLJwJ1K7yGFAd
 nTSUyfe3
 zkX8MtSFddkQNzA8PpOHjpv2xl3aP7BeNgU3D53PegkyBkkGbPNNU29Fdf7XprNRALE903KZgjLXf9PH+XdFkDD6yHIRRFrSSGij/SLxsiabBCJbGY6O5K+q0vvcGd+XXtpR+tmiDO32lGyDNyAsSnyQS3oddHu8/xk9LbN0DEYNuJR5djee9hZ1PZ7ZwyG4RnKkzBrSXUSb/yE0GwcW/Hxd+9xM6KAUoBGGai0gGoy7wY2pt+eSDxAWp0IodGmJCMBsoDA/0p8X3nZIIHMSkaZTCnIGsxfWjC3j6k2TQM1ZNNozMsWb88Op8jQZ8J3Ej4gb63iplXqcx9SVelziI1EJtmeeSiWfmKEVpO7ZBxnc198xlbHARu0amc2747jnQHFiSVNDtEsOZBJubagfT1edOLBw8eDnAZyafVT8eCkNDY019YgWSr1LAn6yk20VN8tWYekLMb35Mz0VJRgP+2TZX+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 06:25:08PM +0000, Luigi Rizzo wrote:
> PISA stands for "Pre-mapped IOVA Superpage Allocator" and as the name
> says, it is a specialized memory allocator. Invoked via __GFP_PISA* flag

No.

