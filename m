Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F4D606A337
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Tv+MUOQH
Received: by kanga.kvack.org (Postfix)
	id E84406B05B8; Wed,  4 Nov 2026 11:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BD96B05BB; Wed,  4 Nov 2026 11:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98C56B05BC; Wed,  4 Nov 2026 11:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B14866B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:38:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B7D01A07E7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:38:38 +0000 (UTC)
X-FDA: 85397995116.13.348371C
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11848120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:38:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tv+MUOQH;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hG3RiTzW4rOzvFwLuSqxJwT5QWl3KAEwMYSeXlW3oLQ=;
	b=IAv+5kXYJqpm7MSj251RMDqlMw485UVaMxYcRpH0DMrQpaZ3LJv0whKUwodbt9hAP6i/Et
	xRrf9kOf7LXeB4vKQhE1EEiLpB/d10iWp0y4JJH/39ZnyJTs23dRBhgu9337PX2m4fea+E
	kTOnXNLoU/+bE/s/67IoyCr63vDegGQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tv+MUOQH;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810316;
	b=Bu1PT2BF7h/oFkQPgMlsYY3gHIgVDbD1rNwg8tSPMyYOnNtdWn79wEUWnREN+5MpOy5/Ue
	J/QYNlPBHiP864sokMfEwo8C/qLZPrZydP6DyIHLWZb11xilxDFSZXY98ExlJEwxBUPHae
	AwpkLQzlVyc93lnBhywpC6tZSekwa5M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7Cg4Ez7Vn04vdChf0EIzG0v+x6mvneURKcF64tPZr+A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793810314; v=1; x=1794415114;
 b=Tv+MUOQHV4qew5/g4754f80AI5tU5/F1HTu/I+UxwKUvIKTyKSznhMAiU9ubR/mAAdOaazwx
 mRORZzzzUpCwUKHy28o7VLQl7PDEgcXl7Olmk8sos7gXF2SCrtt7fsHFlUa2lKQvdgn5xwv3Wj0
 YZrzGotU/vdQoECcW9izQCoY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8ed0b4cf6e12cb23;
	Wed, 04 Nov 2026 16:38:34 +0000
X-Mizu-Trace-ID: 8ed0b4cf6e12cb23
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	"Baoquan He" <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	"Nico Pache" <nico.pache@linux.dev>,
	"Liam R.Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	"Vlastimil Babka" <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 08/30] mm: recognize PMD swap entries in the softleaf layer
Date: Wed,  4 Nov 2026 08:38:29 -0800
Message-ID: <20261104163830.3586103-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DLZ38NR21UU6.QIKBG8SO7189@nvidia.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3mmw7q8ajafomau5ooxd6zt3cnrwu9ea
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 11848120004
X-HE-Tag: 1793810315-574416
X-HE-Meta: U2FsdGVkX1/ipdCht9ixJEHWHiHvrtvr1F7OCB9aZfRyz6O6iNXZGHT8AaNdSD8vE6yE4s4v1Rjpqq5mi0vKryfsYNAGLLKqPYnA3ycdDbRUuvxkNHheDeDUN5wWFxwBgryfH7lfti1Q/2fZ0XKIhPDDVsFERrrH4GOgvEml45bfEmzkUnmeJB1rID1T4lZXCiV5dAbiPrg11GjaIgsQMPPYqM3jXFNfqILthgOSlxVbGOQcWrNi9BBP7Zidrr4wG0OmhF8v5MXAhUgHBMS47Px2/NlmXmo1+klI7zICWG9zzju1BVqowh6mQr/xJRRJdXega/YdVj9XWQYeH5Gcgqg9AVinGHBlSZQMT8b+e6rrTYEWmy4SX0+Xr/CS65byQks8CuM3+hSh4+3uLo4IUr2thxhBKkRDjdv/tI56QYvKUkKe5HNakQdgrO/WjOXD9TVqs/MUSpHVa4/K15G/njq3QZ5U4FIE1nf+gYYH4uEXWYTKMbH3lA5Z0Q+Z/y2J0U5Lkq7MT8z+tIuOaqySrTo4Vsqt4faErh/HC+saOe5Wt1N/wbDs46D5DrsrgzhYOfYyKYi5HlpwYsxxMa6TNrYJVAm6BOlxAP4rNVwSaAJamHduMImm5vHR+5GHLLrdrJCTZa1pvTLvfloiB9E+2fSD6vOSM+BIKcrbCkwepaL2Sf9BU9hOu+vZQwEuQgfG6TzY6JmctNzPZ1t5vKlxXA05VYLLGen0JLteGEUfeldn70I6AIvtnhSPPRMvYvO8ounmjJW7N4xeqL8CBXI+6NeMD7C9YExyB2YVltB2yFS2SMpX1P/7o6A0ht6Lf+jBBP+Lf/YE6zXzFTb+O2wkAe9XG8cKahqfhIVNShzlMUXhmDI02GSqFlZ4GSWA+HJAKrMce8t3VX+HdRjnsBfUEPSLDKmtmpC6vK0z+0Cau96gVUUqOUW7FE1oSHdenBU/SKtNXFweg/Rw98H0cOn
 CsuuKfFT
 bP9bCAfb5iLy+J78YSsrSWomtDt0EuihS9XYKDj1NcL/uj8Kq8c53Dzdrv2vFMeDODMDzD15UxV25aPLrSSjDd78o9LTP3JcN5EILZXxgxvWwt4ilwu+UMRQ6kuVnB4EOPiTITPoJUIUHwMg5dZUp6mpziN69rA351WR6GkFyA/U72AV9SB05g7kCLmBBIA6icNGijdCAwQ7Mxo1Atzrdfl75zl+YTWXBMrcHTCVFyYNKCKIDktS6Opg5wJZp1FuEuV9q9OabepS8+jEhMe7EpKf7Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 07 Oct 2026 22:06:57 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> On Fri Oct 2, 2026 at 5:52 AM EDT, Usama Arif wrote:
> > Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
> > before unmapping it, so an ordinary swap entry has never had to appear in a
> > PMD. Prepare for installing one there instead: the softleaf layer is where
> > every consumer decodes non-present PMDs.
> >
> > Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
> > A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
> > return NULL rather than interpret a swap offset as a page frame number.
> >
> > Unlike migration and device-private entries, a PMD swap entry can also
> > carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
> > before decoding. Strip all three overlays unconditionally while we are
> > here: each clear is a plain bit clear, so testing first only buys a branch.
> >
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  include/linux/leafops.h | 40 ++++++++++++++++++++++++++++------------
> >  include/linux/pgtable.h | 17 +++++++++++++++++
> >  2 files changed, 45 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> > index 7c13c58a5e218..ce176c78cefd4 100644
> > --- a/include/linux/leafops.h
> > +++ b/include/linux/leafops.h
> > @@ -98,10 +98,9 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
> >  	if (pmd_present(pmd) || pmd_none(pmd))
> >  		return softleaf_mk_none();
> >  
> > -	if (pmd_swp_soft_dirty(pmd))
> > -		pmd = pmd_swp_clear_soft_dirty(pmd);
> > -	if (pmd_swp_uffd(pmd))
> > -		pmd = pmd_swp_clear_uffd(pmd);
> > +	pmd = pmd_swp_clear_soft_dirty(pmd);
> > +	pmd = pmd_swp_clear_uffd(pmd);
> > +	pmd = pmd_swp_clear_exclusive(pmd);
> 
> I notice there is pte_swp_clear_flags() and wonder if we want
> pmd_swp_clear_flags() to match it.

Added pmd_swp_clear_flags() alongside pte_swp_clear_flags() and used
it in softleaf_from_pmd() for the next revision.

> 
> >  	arch_entry = __pmd_to_swp_entry(pmd);
> >  
> >  	/* Temporary until swp_entry_t eliminated. */
> > @@ -634,18 +633,29 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
> >   */
> >  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
> >  {
> > -	/* Only device private, migration entries valid for PMD. */
> >  	return softleaf_is_device_private(entry) ||
> > -		softleaf_is_migration(entry);
> > +		softleaf_is_migration(entry) ||
> > +		softleaf_is_swap(entry);
> 
> Using softleaf_is_swap() here makes softleaf_is_valid_pmd_entry() return
> false positive when pmd swap entry is not possible at the moment. Adding
> it only after pmd swap entry is possible can close the gap. But the
> whole series should be applied together, so it should be fine.
> 
> Otherwise, LGTM.
> 

The predicate accepts the new encoding before the producer is enabled,
but no PMD swap entry can be installed at that point. Reclaim still
uses TTU_SPLIT_HUGE_PMD until the final swap-out patch. I kept the
ordering so each consumer is ready before entries can be produced.
As you said, there is no reachable intermediate PMD swap entry to mishandle.

> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 

Thanks for the reviews!

> -- 
> Best Regards,
> Yan, Zi
> 
> 

