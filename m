Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC645CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC596B0340; Mon,  1 Jun 2026 07:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E0C6B0341; Mon,  1 Jun 2026 07:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A26B6B0342; Mon,  1 Jun 2026 07:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F089B6B0340
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:38:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99BD38B57D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:38:38 +0000 (UTC)
X-FDA: 84831146316.13.AD4A359
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf21.hostedemail.com (Postfix) with ESMTP id DEFE91C000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:38:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780313917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NfZkde7UfzIemn6xfka9xky3f0yBJ8DhIBCo4an1NyM=;
	b=bI612PxMa5/5WlI/ZVAikHamwatZHfES/TtZTAy92sM0ZNjf5LemHzmQ7IrcGiKn+OdBod
	KYyIFxOFm4qKYUm4XzhTmlPOc0b1+Ea4njcSCqzPwn2mkQwz5fMnhSUIcHjynZS6wt8sIV
	7sxW65+E7YnSEoQMBM3RKShLFyCtOT8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf21.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780313917; a=rsa-sha256;
	cv=none;
	b=oMP1VWEJNbtWUcr3EPvSJWl/R7dmRn1Ptk9VMRwWm1DJCDl7lTWGVRwHMpj3tEdNGZCDnN
	HIaxdZlaNeU3uC2+FOGFHQu/Sj7ZnK7lZm6ISB7EWxwWHJ2HwrRUSOdz/s1omhyc53eLwo
	9uyPD58UWumHBWNUnzQhlxU5CRcuBU4=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0537468B05; Mon,  1 Jun 2026 13:38:32 +0200 (CEST)
Date: Mon, 1 Jun 2026 13:38:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Message-ID: <20260601113831.GA25535@lst.de>
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de> <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org> <20260529135045.GA10647@lst.de> <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org> <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: 54wnts5hhyc1hzkrrt7djfws9rnzf3w5
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DEFE91C000E
X-Rspam-User: 
X-HE-Tag: 1780313916-905188
X-HE-Meta: U2FsdGVkX18m7DBzY/KKjF3/jDli+oEfVlXUwGDkgXrtKcgtXShwNZ0d4vpeS/T/epQKpXWfqsEboG7MaqUCTGy36NjJ1rwmfdBrkjgWJxpYEUe/v1EdZofpKycWLGW/8gsb10CyxjBbnqCJw2Xg9kg4omp1uVNUonAjjFUFz1h+0StevkBQr9xT6wJWIx1sCUWfBRC2MrjFsxn/ZdaB07vdgaWEgSOSi5GAAkh1GDD0C+jRRv5Hg2Epv1madywBkScA6UuYFkQJTALDYRUJO4s95C14u3dw6CYn6ZXbCdYQeWXQdBxFAvSIoqWwU8V8St57wj7EgXu7wIcjh+Nn+n5X97MOfM5c2iixi+kME+g/0tGGwA8Qb/9RxRrhvPCr7hjdAKJZeDx6xA4SdAM+rDeQG6EGe0qAFPQzZvGvJtBQcZXyhPWf9nm8D1pShP4RvAhVSwTwldXM0R8Vw+JWZ1cGUgg1KeHU5ebzEwXVYcAX/qoaDrISbqhWo4OqrYMlRVev+FbdKXOsVpGMHMVrUsyyXU+eWYQqwJpdn+fNxsO4e7EmcATQ1k4aUD+aH4D7e4xf6d9OV8Q9qqUrVavd59Su10BAuvLjsjOtSjrZcoEmvZCrakGyh4LnG7XZJFfKV/6jFIjTwBCcp1mKUn736RqmCb85/wkgytcGRZNB13q+XwxALFK8aP/URpxmbdBfx6TuOSKxWPR01kKFV0GA1kACjhZxJJHGAxz2G8YminhNidzRZV7JpL4KhaassuOZ1Cbu+2Rob2PM/3eHE1eaTidSFAdC5p/5yNN2N74eo89uv/NLP1WAoi4nDqfiLAyYpkLqUu6nHgOGXsF9oYIK4iXkBpQQ/UBSPr4friLjC82d88PegZRrku07raNhdnba9+YcxM9FGBPRJGdU7l6QV9NqnHEWMWmTug6JYyeln+Le1TW6ONN3Td7ySXSGZwJMF6n841qCR1msP3Yjkwj
 zpXwcFlx
 sNC3kX6vPOZg3J6ozYW4BHBJ/d8NUv3N/06WiNjq3eQpYRVDdz3UXLa+1ZeHbwgEWYqom740O4JUOgZ88kVwy/RG3DT18I6HT0tewtAi5HatI3X9mdVrkQQvBbVRzyd0FAhdOVrXFAgEbuTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) wrote:
> > kmem_cache_alloc_bulk() returning 0 was considered a success in that case.
> > 
> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
> > user sounds fine to me.
> 
> Would it be wrong if we just returned true for size of 0? Would something
> else break?

I don't think it is wrong per se, but it feels like the wrong kind of
API.  I.e. I don't think the MSM caller actually wants this, as they'd
also do a zero-sized kvmalloc.


