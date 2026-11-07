Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE2A1606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftQfmrgX
Received: by kanga.kvack.org (Postfix)
	id D48346B05BA; Sat,  7 Nov 2026 14:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20046B05BB; Sat,  7 Nov 2026 14:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34AB6B05BC; Sat,  7 Nov 2026 14:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6C76B05BA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:33:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D712A7F8E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:33:32 +0000 (UTC)
X-FDA: 85409322264.10.082ABFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65A16180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:33:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftQfmrgX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794080010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdEnRhaq9naN/jfM+EgRhagkLAGd6elDVRBsfzO9N9c=;
	b=pfCDBVYGYbUW0PO25q7P3/yLxGn+WHmOg2sNcoHBPShgkForcYL+P1SUxhPjfzYPIDgAeX
	sXdDtpNPd1/zd5xusHbYSjv5WQ7OCQVQY0ardZ7p0b31/C/X3dfKM0+r1abQKYo2arWbbd
	3uf9r6q/mpIXCL/nSgCOopmXtxtUiXo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftQfmrgX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794080010;
	b=Sm+d+8N6XHrrV31lfBtpYBLWy4x6V7m4+wL17FPSpztLLVEOuXKsEGL0FQpKgxvvvQyKe+
	z4dpuiK9uwvR0NF2rckyo0MHobT2i/lioytTFaqNLEZPxSq7w2B8G82R9jpYB/STLTGNW3
	mMF4sZAb013djADycBX7WtN9Hj4dahg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F4EE40126;
	Sat,  7 Nov 2026 19:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C431F0089F;
	Sat,  7 Nov 2026 19:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080009;
	bh=bdEnRhaq9naN/jfM+EgRhagkLAGd6elDVRBsfzO9N9c=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ftQfmrgX0PTL6OyPr21ItVBP7iEotgJoBBodKYZzA9N+WTPgVMGgNEt7hRvo8RcW6
	 aQ0PevE5CQFQNDEijOMftez1rUxlx71Q/4QI+2JjPZsru6Ascqo0HoBhrHkQjeoWn6
	 tSejtejf+yz41ID74q+dJDLcq7PwtP0rNph9cqRo8zVJ/ANC37AuElytIy7b1KOj8l
	 3u1PF4itd0zJ2DU0wEzj3v3dRa9voEvSE0mamgbMPpilnqGMl1YFM3pCr/8AhoBwVE
	 60Fu6EBLAlsHK9iOoTf97nGo532cXVaNYsgqrJXZ+Md/QzdrUuMOU0CTtmEp+pGXal
	 uxFoWTxTMFGig==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261106-fix-split_folio_to_order-race-v2-1-1b59c67b8af3@nvidia.com>
References: <20261106-fix-split_folio_to_order-race-v2-1-1b59c67b8af3@nvidia.com>
Subject: Re: [PATCH v2] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Message-Id: <179408000316.4465.8734683078485520816.b4-ty@b4>
Date: Sat, 07 Nov 2026 20:33:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65A16180003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ggcaw6rtuitq7ohjeckob3up5wfhxuto
X-HE-Tag: 1794080010-594513
X-HE-Meta: U2FsdGVkX1/6Fu+EdFEJ72oRUN7EzIozdY72O4X4TDm6LTmhGlI7ix8Al6vv3tlNFaUJ8UB8q0txd7cWxRIuA4jCDy3W2NLQhiWQHAaQ4SdXCe0wZ7X6NBrMoaq9ZuHTknorSStkVVbYmIFIz7WKzWtpAqml4liobiFtAE4vuN/vVcpo+tNynr5lAAdHtZNMCHjsHNKo4sSuBKpO993oLFDLp0XnBOqRkH8Haq0QGgjOLTC2r+GXjeLjw5G0INrHwYCcOlpxZB7hxc5o8sIqkFnnua6gaPbxTvU5e1UAZGrW4NxmpDbX9mRxPx1T09/TOYOTB71hSCzo0vrlvN6mTXajvawohgRwPEwfhVh2b/vE6XCRQ2fXunv5RHCUYAd3F6aasQbs9LUYZc0SuE3wJrvjCdWTxL+H/xD8nYTExpRmJOUGJuCvEPz/PbeztmFVWryBs9LreBw+GUxjfGwQs+16Q872W1vxbdexJPH8SxKJbwc/mi6m0MSDambopOY/ibVY7dStFlchSG0nwuUOoXZ9029EVgraUgpJRkkgcAvuDdtDA5Il4lpCScHM/s+yq3i7hC6NvXb9mr2u48ZDvRVpKoNvbOV2L3Q9bovkofWFEWqStT3/krt/rkIVCZMJ1JgGtaCaJZcHoep66RwQ9bFzd4ZPYqjrP5aTPyFz1yzTdLVUwmqPxeqzlhutSR4T6L+5LRx9phqVymGRlEetqibNlRoZQXqNNV4106iYq0YvXdDr1XMywI9Wiz1+qfZAmJdlvNfV9K/cWCkGT6rN9zDRMcZlROKGeAdCvYVGuPP6MwWCpxnYMFv3+1B3cVwJU44A+n5wvpCgSAKkwiXQT65BgS1b5aGlH99bsZt5l9nGNsomUR2oxkqUdH+AcKaQyLBRJzDYH+Xk9DqS6i4puOw4pom0w/OqiebHpPBeTENUyH6h+m/eHAUUPSxZma1u/9pXUc7OPatwbBhqoqG
 LjJS52jK
 pesO8ZvOVBVwDVfxTF4kYNQYeH8AlfQw5ChFw5nbrJyCt4RXHbHANWjE/g8BaIin/Ps66uD/HFR02+U2srQyJmqXidcSQxlAcL/U3y8e0QkG7hwpudE2QUe8Plt8MNfhBkGVtYyqA8MEgwzQXFIh/PvYzXRmBZPAYer5zRS1Ph0X2Fd/bbH2rZ69CPp4neNl+UT7T02SoVdu2GIzcnTKGWAxZ0yO9Uds8z8Hye1RTPXDt61eKN2SWMIQymN+zdXXka/LYm+A6lmI4cffVviAt+M4J3xVzbCFZs496
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 13:28:46 -0500, Zi Yan wrote:
> __split_folio_to_order() calls prep_compound_page() on each new head page
> to create a compound page after clear_compound_head(). prep_compound_page()
> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
> and frozen and no one else is supposed to modify the folio's flags.
> 
> However, code calling migration_entry_wait() can reach the folio by PFN,
> then access its flags. It is because softleaf_entry_wait_on_locked() used
> by migration_entry_wait() sets PG_waiters concurrently without taking a
> reference and the frozen refcount during split cannot block it. Meanwhile,
> __SetPageHead() does a plain read and write, so PG_waiters atomically set
> by softleaf_entry_wait_on_locked() will be lost if the set happens after
> __SetPageHead()'s read and before its write.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/huge_memory: prevent losing PG_waiters in __split_folio_to_order()
      https://git.kernel.org/mm/core/c/654fdaf4

-- 
Cheers,

David


