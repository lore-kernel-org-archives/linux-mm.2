Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05577606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZmHB+25T
Received: by kanga.kvack.org (Postfix)
	id CEC196B00EF; Mon, 16 Nov 2026 20:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9CEC6B05B0; Mon, 16 Nov 2026 20:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C546B05B1; Mon, 16 Nov 2026 20:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EAD66B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:02:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 141E340283
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:02:24 +0000 (UTC)
X-FDA: 85442810208.25.EB80DB8
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id BCF141C0009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:02:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZmHB+25T;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794877342;
	b=WPI7yMEtvXtVto7v+UafY2Kb+207MTCK5jJgxj2mGHk8tSWMEw7hudT+yd37sBdrTjyoA8
	KXiG7QRyM3TUggzKaZyfdELw6O4Q2qiEquvyItaxCP3iLOOWhNLBNNB6XtsoH1E4Ip4WZs
	j5FzxeGqcSj5KwaCbZNqI9clOkdUASA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZmHB+25T;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794877342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jUhG/+yD7ltzA1P4BeznW+FBUmK45hGHrDe9rOGBQI=;
	b=S2nOFSh6G4sj3GmYReM8H2NRT6mLmr5V6OHodOSuyob7ojw2BBSbtes7N0polDBE6zBPcs
	WaDWqaAHa2y3J8G2Xhc4ZqrysSfVUswD10fSFVztgBYt1TA+vXHF2mIknoLX8QGLr+pb+a
	Ew+L/iQptKzOVvcZSe7sLvTg1Fjpf4s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pr7ixXlMABVW+xJfmRHqZ/e1vIB1gUkwAZyRtlilqH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794877340; v=1; x=1795482140;
 b=ZmHB+25TBRRhBW31zFJrfdn6ttpzmoDErIxV6rTVUUofVjBweGbt/Jbrci/dqoB0v7KGlwu/
 Xt6nVTiE5yFq5Tnp92Uz9F855H3qbk0X2/lUoDzOgmTXjK2u93W4yoWnXWhLtrWy2rKY0z4KDhB
 rTA/nUhx0d6uoUe1MHBQXzUI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 8f80fbc7d52bf4f3;
	Tue, 17 Nov 2026 01:02:19 +0000
X-Mizu-Trace-ID: 8f80fbc7d52bf4f3
X-Migadu-Flow: FLOW_OUT
Date: Tue, 17 Nov 2026 09:02:07 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Nico Pache <nico.pache@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
Subject: Re: [PATCH v2 2/2] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
Message-ID: <avunj4dVyiLovWL0@dgvxl46587.localhost.localdomain>
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-2-8b61ad0491f1@linux.dev>
 <b4a82805-5b13-46d7-bdb6-0ad2eb70f148@kernel.org>
 <8375728d-c1e7-4033-8096-5d98d1bc36e9@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8375728d-c1e7-4033-8096-5d98d1bc36e9@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCF141C0009
X-Stat-Signature: npoh54o831smg49ggq86bs4h9wh97bfc
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794877341-956891
X-HE-Meta: U2FsdGVkX19//AVtUH79BvqmlAKpUJy7NVEsbn+xA/d31d4xuCXzNaTHQrSlMrLxRaPv+rc2+LTNPbspKYetIYBwo0lNR9FHfj50wLJP3WRiRCrSfE8q/NuXRqNcjeumKvJbWCluWJciCQ0K99E2kNHE9SZ862ac1djQqh85SfzAspUtaBG5TWpQTjI3q3l/zSODpm05qqzU3kZoMOknltFzVKfxqthGIClnzPYJBmA3/W7+OQtV8UgJI1sl4axGUOvnXw2dt8m/MwYoRZWWoTR1cZeKXABgz1NIQ5wnpvVkJa8MeRiL4XJZjqdLn8Daa0+Cuzi8mGWxppFg0HhTZeQNeIYnLSWb54wKZWGaSbo8EeYwb3XTLy1yPG7mmpIDKRgfZMcg4rNw0Zda1QbQC8pKCr4wwo1joQRa4Ygxkce/ZWNd9Tj6i2ZKZ13+GMpiEHcBBfS+3LDobd/d4k4G4nSIM6VLDmGIA2RtYIeztzhE6+yh3pCHp9jW6Ezm7/UM/JOlGboU0J26I5r1kjAgcJXdu0otynMCTN+RcoMS0/wKh+4RQojO0zRDRJlMFoZmNuDZRQBCBUX8eAsfIc+UrnKzxiqMT5KHD+sc9AookHNKHHXsldMW8pC62XVnvr9YDNuQ3rTA+9CmV/SBGqz8xIPkcc7j4z5VczA2urSUppjfuO4U8clmCnOfFrmpjrBJmCb1qHIF7sz5lQZNazogj52H9GajtEe86ZrcN8s6kskoWTvgiryQFS86dMZA17dsgJvBTQiY4TdRPmWiS3oMvt+KDvbtxdmHob5tuqNn0XF963Hcy9CMIEWebr9vIqcmICLPfqPxV2PDifgPDBhtk0kwOxIf9BAeYkqdL0GCbzY+EReQJmZvZSFraTJkSZkdv4OQ70zcW49OuFVdml7GqyAoNBGJQgLiNveH1jXk+nxF+uY4rUhNBmBph2j5cMIKwaQ27/MW2IRf2umJaoR
 mWWv9jD8
 9rojosce1qNtqHrXoCgzgs0CaQSjkHIvQB0uHojJ09LFGaTKWuH64Y4EpniMdMDAqiea74XEoA2dF5bjo5au6Aj9Zs3g0NLqsQdvoAHMA9+orcuRvxKT5+QznCGwmgHjlcstb8lIoKEiFGdIdt8bPzp1EzBrf3ehcGbaWxuChVEwLRY4cfYxnchXmMfqf7dpEEHlOmLQH1vUjXmVt2l4PkZUMOEEHJYnpxw+IMUHuSE6pY8/jMWfBfr9mzlfape+XpbEEL5E6lNz+rcyR4SlVrln4YjBmigOsDUFP1mW1eKvDBcv6+WTUzbkzB0FIzVf1wE3Uhq8mMvN0/D0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:58:55PM -0700, Nico Pache wrote:
> 
> 
> On 11/16/26 3:21 PM, David Hildenbrand (Arm) wrote:
> > On 10/25/26 18:39, Nico Pache (Red Hat) wrote:
> > > Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> > > when splitting isolated thp"), splitting an anonymous THP remaps all
> > > zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> > > This flag is set unconditionally for every anonymous folio split,
> > > including splits triggered by KSM.
> > > 
> > > When KSM is enabled with THP=always, this causes two regressions:
> > > 
> > > 1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
> > >     split_huge_page(). The split remaps all 512 zero-filled subpages to
> > >     the shared zeropage at once, freeing the entire 2MB THP when KSM only
> > >     intended to process a single 4KB page. This bypasses KSM's
> > >     pages_to_scan rate limiting, causing ~1GB to be freed almost
> > >     instantly.
> > > 
> > > 2. use_zero_pages=0: The same split side-effect occurs through the
> > >     stable/unstable tree merge paths. Each pages_to_scan iteration
> > >     triggers an expensive split_huge_page() that silently frees 2MB,
> > >     while the scanner wastes cycles on tree searches for zero-filled
> > >     pages that were already freed as a side-effect.
> > > 
> > > Introduce current_is_ksmd(), which uses kthread_func() to check whether
> > > the current task is the KSM scanning thread, and use it in
> > > try_to_map_unused_to_zeropage() to skip zero-page remapping when the
> > > split is triggered by ksmd.
> > > 
> > > Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> > > Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> > > ---
> > 
> > [...]
> > 
> > >   static bool __ksm_should_add_vma(const struct file *file, vma_flags_t vma_flags)
> > >   {
> > >   	if (vma_flags_test(&vma_flags, VMA_MERGEABLE_BIT))
> > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > index 7bdcdb57652f..c33ae3fa1043 100644
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -305,6 +305,9 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
> > >   	if (PageCompound(page) || PageHWPoison(page))
> > >   		return false;
> > 
> > This really needs a comment like:
> > 
> > /*
> >   * When the split is triggered by KSM, let it take care of scanning-for and
> >   * de-duplicating the shared zeropage.
> >   */
> 
> Ack! ill wait a day or two before sending a fixup in case others review.
> > 
> > > +	if (current_is_ksmd())
> > > +		return false;
> > > +
> > >   	VM_BUG_ON_PAGE(!PageAnon(page), page);
> > >   	VM_BUG_ON_PAGE(!PageLocked(page), page);
> > >   	VM_BUG_ON_PAGE(pte_present(old_pte), page);
> > > 
> > 
> > I'm still a bit unclear of what happens when the split is triggered by something
> > else in the system just before we walk into this THP.
> > 
> > Like, imagine the deferred shrinker scans for 0-filled pages and splits under
> > memory pressure. Then KSM scans and essentially skips the (now-split) THP?
> 
> IIUC, we dont skip the (now-split) THP (ksm works by page, not folio), we
> would only skip over the parts that were remapped to the zeropage. and
> because the shrinker already split the folio, it wont end up even needing to
> split it.

Yes, that's right, KSM would skip zero page during scan_get_next_rmap_item, but still
scan non-zero parts.

> 
> Inversely, if ksm does run into a large folio, it splits it, but doesnt do
> the remapping. Which KSM will either eventually deduplicate itself (and in
> the case of use_zero_page=1, it will also do the zeropage remapping).
> 
> I asked our robot overlords if im missing anything and it did find this
> potential issue:
> 
> KSM could trigger alloc/reclaim that would then prevent the zero-page
> remapping for any reclaim done under the daemon.
> 
> It did suggest this fix `current_is_ksmd() && !current->reclaim_state`
> basically check if we are in reclaim and ksm. This would close the gap.
> 

Yeah, `current_is_ksmd() && !current->reclaim_state` would be more precise.

Generally, LGTM if you fix that.

> Or we could go back to adding a flag to split function (but i believe this
> is still somewhat cleaner and doesnt complicate the already messy split
> code).
> 
> Cheers,
> -- Nico
> 
> 
> 
> 
> 
> > 
> 

