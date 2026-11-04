Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9B3606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UHKTO2SN
Received: by kanga.kvack.org (Postfix)
	id 364036B05B3; Wed,  4 Nov 2026 04:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CD26B05B4; Wed,  4 Nov 2026 04:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283316B05B5; Wed,  4 Nov 2026 04:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 106B46B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:40:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A03A2A82F6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:40:27 +0000 (UTC)
X-FDA: 85396941294.10.CD0CD42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0AFDA14000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:40:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHKTO2SN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793785226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LbmTa3BVHVnVv2Si7sxzWxDFszjGNRZ9XOev2sXbGQ=;
	b=wlPzxSQ/O49d9EFqobMdsccDQwpWzoOi7aJXNHrayEwWROe7f8RHdkOSSi4SWHsa1iXu6p
	cGxzK6ZOAR9TFhaQfe0a2aIi83cDgkRzB6/wh+ctZm+dOpuKLx0LYicGRQ8ek5SXZeGpvd
	inhq6S/TbC4kbjSJmFz2BWKoDwLlzAY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793785226;
	b=6jL9AoNRmkek6CTq+UMigplivTsaMdE6hCRu7/W/9gjLOYa2XX21439D9PiCR5MeSW2wzf
	V2gkTDpisHde6j314GXw2Iw5ZlRl94reIM5uwe0icdBjbwNQA/h5NaezfIYWtj8aaCCPFh
	DVwtfZdSxOuOQMgeyJcQmLpQsGUaD+k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UHKTO2SN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 429244073A;
	Wed,  4 Nov 2026 09:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B4A1F000C1;
	Wed,  4 Nov 2026 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785225;
	bh=3LbmTa3BVHVnVv2Si7sxzWxDFszjGNRZ9XOev2sXbGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UHKTO2SNGPckrCl1XoFlOzMisCwxok8mqGhz6lG0NrgZtsFW8nPQcWgjZCphendEd
	 e9/0DCryoJpHx3lZLLa1Q/rmuMzaF7+GOtZKyHamhTpAl+GbZUdxSDMes72UIP92oI
	 Q9NpIi5pYXPdLFPHc+mMnbRg4afAFCCEUXKk6GQ51MLLU+NOh2ukMKTFjw6MORQswn
	 qKMut1cKcdCieRf0vumxZgxqoJ6ZykAlYDjhEj3suMD1jlG5zxyf8PpqbvHznSM92V
	 B47NPf43vUKkwqMMkfvULdEq7dw6/ZW6DehUcPHZurnUQn/ui0DFUD6RkKILeLpDil
	 lf8Ed0ibbUeow==
Date: Wed, 4 Nov 2026 10:40:18 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page
 handling
Message-ID: <aur9ggEKK1i-MO77@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-4-songmuchun@bytedance.com>
X-Stat-Signature: pmxq8hm53z6jrhz3o4yceqs6t86gie1s
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AFDA14000A
X-HE-Tag: 1793785225-62935
X-HE-Meta: U2FsdGVkX18ZYJat4loJEDHFV28zBbj076kMWWvAKlhgmA6tOlwjlb9+HZUTlpMZTtBEIL77hLPauy0eSVN2NbmGqwISvP9bdkduplLVGAH5/q8pG19p492mREC63qemJ356/mTLRSP6eCGXxZF65OmQaZLR+jasgcArtXnvi6AETznGRFTqjYSWT95jP73obNdHnwggymY3q1C6ZgGswqPQKYXVGITs6umSMYqxgJ6fjka7f890nOgaqPznU8bmqUdEpngyqphyJoiHX5GebIVe3GHc6OwcjyRJA6uQq5vkgFo0To8nclgmM3ERw0FrBqbSWOneKTpQJY57gMmrvYkA84O9O2B2aUSYxWK9SRn3RL5+eD7XLvIcisSBZA9DJUOM3DnBkyj9nrndSXEYflVoZ6TCJHhHPGeQjD+DUGfg4GO4CdJl+rUANNXQgqKhszMOuBBW9qHPPpkVADLWlnOd0/j0Ij0VOXliH9sjbRtOSb9ppCi0jKEXugKJA76YAJdPSq6y/KFnribxJLOatPo/vF97mlNdxkgTRibxh1Z5M204PLdMYD6Z2PZBjHWHfAwYb/YvGwqL0zZABBBmP6f6wWsGlXSTJhV8YG6G6K4Z9CGl/5ZvbWK6pJBkMvceFiP8f6oILfAAbLbwsBDe+PTpy53D9nWtETe0dBl485ITF0Z+jwImHMlvYvLmyjWZSEtzV0NuNYUaDsN0RmFJK9TXcysQoXS9dqbS1LAOHEIrcYKhdYcjS2xRRmkqcEJOA3cnZ3xud89/V2YK/kbyn6hoGHPKXDVFGbvdBWHu4M9E9e2TCXwXOxwJWvPFLM4VMfojK8SSjSbYVK+vKqDwAuNNEs7U7stwBNfaEKkoZd/PvgkLJFo/itzQwW6yY0ozMgs67k8au6VXdAYFIykmYmWoM5sZmWQJ3D1mumnGxekKcAGbeA/XaGbvT+St7k8/jlkCkka2GJRkcFiLS+Q
 krKE6Xg4
 6MlUXSNXUIPxUUKm8RhP4OkOv3QCAYZDaFfvR0IexoKRy0P351pAcQERelLwF2IQXRkfenO9KI80Wp0npuvmsghSOEw6aXt5bBs71y7OUSWZgoer9+cyN83U78nvP+DR91kkdpnFV0F7Pz4tvZ+/RvY+oOmLzNgQgZs1jyO7QjRBp9fsrLEtQPImgQt0zOEoZqlpG1GbqTKg1/RNX+vA8+RP+RK2n9/u9xDH4kkuA5pDpzjnG2vAmkPr2RViRf8eYhl/TrZbRMc1pYtiXyh77I+T2rIjNn3FQUw69cIsOhXyY51Gwbnpgr4NtPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:01AM +0800, Muchun Song wrote:
> The new head page is already tracked on the vmemmap page list before
> remapping starts.  Passing it separately gives the remap walker two
> ways to refer to the same page and unnecessarily complicates its
> interface.
> 
> Use the page list as the single handoff mechanism for the head page,
> removing the redundant state from the walker.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

