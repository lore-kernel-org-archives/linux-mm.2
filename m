Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35EC606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VzGWi9uR
Received: by kanga.kvack.org (Postfix)
	id E31F56B05BB; Thu, 19 Nov 2026 03:00:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08F96B05BC; Thu, 19 Nov 2026 03:00:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45E56B05BD; Thu, 19 Nov 2026 03:00:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B51BF6B05BB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:00:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 502B91C4409
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:00:32 +0000 (UTC)
X-FDA: 85451121504.27.BE20CC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2E0E10000E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:00:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzGWi9uR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795075230;
	b=R+EX1GaiAt7e1IrydG8eiw1VDh4qXhg/cu0ZY7UJ2Xr4Ei+k3bGFpsatlwrYIVXfjiiMYn
	U03ev3VKPCF3RwP3rnFkDD3tZYyoDRYYMMvrIHJrz3J8qBHPzyZFObOUN3FGK/ZJVr1ymJ
	KZoUix41iUt+bzyaTlLapAagqXShQ14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795075230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhKTd9PFQglELBRtpTYu4W3W99Gioeh3CPcw8i00DlQ=;
	b=wrZM+lbS8kzd9pv5VdMGTjW0mOiZrOdIrQaW3y23wuMDgGC8rd8959mqY1+CTjk7PPwjAj
	Rrg+h9pbvNScwgD6hVQfp4ldGdxTdTBV5Q9D8Ys0DDmbB+aGWQ+AMjk69t7LJUECaZYpAU
	0QS/u2HuxhYcitrW5GA30FcB/Tb1Ck8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VzGWi9uR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43A6561D0B;
	Thu, 19 Nov 2026 08:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF05E1F000C7;
	Thu, 19 Nov 2026 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795075230;
	bh=yhKTd9PFQglELBRtpTYu4W3W99Gioeh3CPcw8i00DlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VzGWi9uROMYGTkKOazYsmKlhMzNc5nhXpnMk8mDh68gKBL3B+x0fn8IT2VwmfH1Ef
	 rudOl0YdIbdAx9WxJt28qSgYc293YBRFbc8Reex7r49nSl3Ob3DnWeNsWSZz9zM/D4
	 J+N6xHljw23oX/WnkCWcYVCe5dhPBUi3zbmc1vHWKeBpAAkzh8HIDjfPgwsxdcGmzn
	 kd+9Pl6pkdZO9vLBWRqZH1YamDRZywlSVUnyqLLZt5beZMAkw1dBfs1s5W1DV9ew1S
	 1zkx7BsNMPKEbu555/1Agg6ojWE7+gWcjaFLSgz9qRIjqB/d4ixApDFDjVAYb0CPxO
	 Cd+MDnFgeZyyg==
Date: Thu, 19 Nov 2026 10:00:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/7] mm/page_ext: fix client data alignment
Message-ID: <av6skRQgBf7f70vd@kernel.org>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
 <20261119065812.89959-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119065812.89959-3-songmuchun@bytedance.com>
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B2E0E10000E
X-Stat-Signature: cpfj1htondsd488erbbscahwmiombci5
X-HE-Tag: 1795075230-769197
X-HE-Meta: U2FsdGVkX1+hTWwe9jH9O+TX60vIK9Nf3xrEi9sIsWsLIUmY0GIrlDXykBs0vR3wvYCcScFgKt1VK91oYo5FosddpwliCQoohznuhVV/NqopEaXCR+zlZDtPV5Fz75hN2XDpx0+uDEVvvoeXDxOEhdnM/IVO+XRz5r68mwLDiL9FBcHpaRqsfmoSM0kbDE8AmWbf3kpJ8jVvXKTpTKec68ug6oGi57rb3RKfcmJZBe4lXFPfly+6XJ4CcNeJH2V4jkQfozjyl7K57EL5/szPzkU4QMZ5DCtYHzc8dZAkz6DRSAOc0LljAhD8Dhf7UNlOFcw3o5bunoW6I8V1hjG0M16939+TYnksk1WJeujV2xc47QdLLsU8waNOyn6BVphDhzgmVGfaYTC477i142b86r+qhmq1wZD/03fTxJoggpnZnvJBn4qzvAd3NqrOrroGe7xtq8K4fdtxRPalQRgmhkq0oS7BdBRTW6kehuG8FS3tj5RMNiz/NcHLmEFLNpV1+enAWuh/wl8ZnGi3DZs3yeIqyl/5q2sQvodCQ+6Nw4146CywXgC9xioBj80zjtDBG4uG7fQRAJsskRZIYhRWYsaYJJeHM6ZJf2Q9AEyV84xl4hu4h80Sib3xAsjY0w+pfWU9ZkFYx28OqjIxj1Au/nqEJ15uZKKvm+0FOicQmLrOuzspWcngtyqbxLq4uS4bjEmZGEWVBl6AXyEQCWzyLEE/BS4vbeoI/lHhg+AL9ZaPbk0jgFqyfWVXnbKQU8+RXZ71wi+kfxmDk/40sl7lN0EQJF77bK4AJnM9X/iIyVFMbAZGn2EqTTpCF4Dn5TYf+pkDUlkwGL1oFBHaGoQeVzN+far+yHINJ61cF2iQ3r6/s3TfYwHWcGr9GvP6r3r+jH7nosPRq02dHkzapHGt4gDqP3WtV2YatKBr+kx3qiEDVKcUwtyLH4EtmbSFCQqtosTJZlxtpMANKeheeSI
 brM5Xifo
 KY5Dfdh1wjrvtrwtTwNb8cjNoL74DbDkxH1miJ7udep0CrSYwAf3nXcA58eBhCxQ2IQNlMUnl7hLvM4LbxeHfl/K3dvEArXGEdRL1PvCEp9VdyfSpRSCNuZuGZZPLZBsCSawfxve3wNchZrVWBr6I4Z5h8Kay1/pyetdOs4MlqagLsbqOvNZ652z0FgIakSes7o0v6ATx3LyvMLi2+A1LKWwcWuoq3QVYzEOtyEYwfJCtVhtK2+OzYWxhGLRbIGQ9XUuMe3bOWuZZII3YE6OSFK4spUGJ+PXCNVPhXK2uCU1E4snzep2QDpSSTn7hDBrfG9wVOAmcwF90pDe7AR/TjR66TYIOzGDfqL+0rpOy3nTtMj2YlVmtpuNjsSRQ+5LoH8MB6KRG5thF1kW4d8AcYkcvjlj/2O8FwrUpVGWa0xg2oVVdhwEm8/AHVQe9QGfQzlAeUEJac9+4g/qNbmyJI2Wbt8TGGgnxSu0ZKmM+jMB8oWrH5wgVaNznpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 02:58:07PM +0800, Muchun Song wrote:
> page_ext lays out client payloads consecutively without aligning their
> offsets or the final entry size. This happened to work while the active
> payload sizes kept the stride naturally aligned, but IOMMU debug page
> allocation added a four-byte payload after data requiring eight-byte
> alignment.
> 
> When page owner and IOMMU debug page allocation are both enabled on
> x86-64, struct page_ext, struct page_owner, and the IOMMU payload use
> 8, 64, and 4 bytes respectively. This produces a 76-byte entry stride,
> leaving struct page_ext and page_owner data in every other entry only
> four-byte aligned instead of eight-byte aligned.
> 
> Align each client offset and round the final entry size to the largest
> active alignment so every page_ext entry preserves the alignment
> required by all active clients.
> 
> Fixes: 466ae6978a5b ("iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> v3:
> - Cap client alignment at u64 alignment to preserve 64-bit alignment on
>   32-bit architectures (reported by Sashiko)
> - Open-code the lowest power-of-two factor for readability (suggested by
>   Andrew Morton)
> - Use a local for the u64 alignment (suggested by Mike Rapoport)
> - Simplify the commit message to focus on the alignment guarantee
> - Collect Reviewed-by and Tested-by from Chris Down
> 
> v2:
> - New patch to fix the existing page_ext client alignment bug
> ---
>  mm/page_ext.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)

-- 
Sincerely yours,
Mike.

