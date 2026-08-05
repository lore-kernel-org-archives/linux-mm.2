Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BBA1C56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0A56B0093; Wed,  5 Aug 2026 06:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B94D6B0095; Wed,  5 Aug 2026 06:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5046B0096; Wed,  5 Aug 2026 06:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 031AD6B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:52:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C0E912042B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:52:52 +0000 (UTC)
X-FDA: 85066902984.18.A608A2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DDEB314000E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:52:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2X7bjf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqMBK15onO+7JT1dZXU8R/Sw5n89R/z58pLEVJzn0hs=;
	b=CyGhhIyB7JuupItFbbdj2orbcLU/h+20SNScqKrWzq15BdBftQr/o73OVxeRLiX/Z2yoF1
	gLQ0NNde5XSiCfWAnC9SEjkIdGr0LcUjItKDeaTkIrIXwGbRpt2m6ti+mAWkcwrkFMXzTm
	VgU7bWSk9KiRpJpXPs4L+s+ml6JRAe4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2X7bjf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927170;
	b=nbC8LiblrgAjlxWqZR3LIeT13o0WrMyswUHxOztwLIFa+ytxiAOwJEqC96SDAysRKKCS9d
	TYchQaVfxk9qzyU47giHMJ1TNnn4NPI9AfAPqJoB5rvLcS/m2NhGw76vb27iZ2BuBbj5WU
	8VttImz9u4aa6Y5kNS9Lz6n8J5mcfCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AA37600AE;
	Wed,  5 Aug 2026 10:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8B61F000E9;
	Wed,  5 Aug 2026 10:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785927170;
	bh=dqMBK15onO+7JT1dZXU8R/Sw5n89R/z58pLEVJzn0hs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l2X7bjf7DRVZgmFo0bPic+lRCzPiIWHHmdqPOhIcRSCT2j+hsZ/FvPwed12w3TsVC
	 iqR5lXso5Vj0GPcXpcC1vhPNZpj7X5fRVo2DMAbXFvi59HcLW/vO2vul3lik0Ncx8Y
	 D9BxmsIaCDZd8/a5w4PHfl1VgyO4kxP+IBDP+mGP20aN8aN86iR/AI7ltt7DX92LAE
	 s9SlgwUQPfrlWN9WvIASQR2uS6VpHRY/FI2v4F26zxHJWqcLUU+6916WITL6XvFkpE
	 WR+/dRHysdFzJ6J2zu3tIWs2ByAaNoZS2BTTPZMq1Oh9UpF1m91kXsAsNsHAKLminE
	 FiQtrcpjTMvLw==
Date: Wed, 5 Aug 2026 11:52:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Message-ID: <anMVxagM7db3cT_Q@lucifer>
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
 <am28pV2PEfHsi4p-@lucifer>
 <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
 <anCtxQE5hDUH5N6a@lucifer>
 <DKFEUPDED2AF.22PKCFTWTG6G5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKFEUPDED2AF.22PKCFTWTG6G5@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: mhu1biki8x5aj8fidsti9eauedsxhqaz
X-Rspamd-Queue-Id: DDEB314000E
X-HE-Tag: 1785927170-38951
X-HE-Meta: U2FsdGVkX19Gs2i4lu/NhNdSY7OX3/I4lT7rjdQV5rjAnItL/YfJxmKlCfnQakS3OwjFNqZhvdCUvCXSYWXuUdamwQGt+lGgWlAqMeAWGKeJye7/QV3i/rRSmX7oQu6t8/LbLRRvS5/NAbgsp2gp2UbbnidTFvTtbUhZHoAstWRSigsnXYQepMBIUjDXbpUpY2kBUjrSyz+15xLw47L2qUBFDMmEi83TF/vhCa2+PpokaZQgOYd/o9Be/C3GIaH3woaQ5J3MycVN6cXcYGMf7Y4uhKZfjPVTaKP8zDGWcZG3pnlSRbaPPn/DzVWBAMcINWLHqM3YF8a7H0r1Z+0DzvQIKQZbghj4RG0eKaGuQ95H9vdato21K/xzXitNL7EHFaQ8SN+WQUG5Oi104/NtoRa8FvAtmcx+X3JSqQxcYtHFakWWjkmkGPsG061fcRrTMXwvbAGQgAtsRtmt5cBAHGwsqcuJM5S+gzxwZ1BUpvXcfvsw1/JLWhG5cCB+C9uOiC6103isiPdl0vBUqj4qRjFS33Z9kWmapUzpPNIV+PTSpKO1TcDOK4AL3xjQuzYqC/N3vJLD12+F/QaqjCRI3UbUmcdEjy66YytW20RKhFnu+3CgiATPXs5M4EChm8QkekIBJQ7/+OHgWmTMLqYyTjP3fS74qt+/FzdBc4r4xqvoAcDIu4pLQeGX++0gyWc0fCxAFNDukW5BkWe+2utbAkZqi/7gyz3F0a97BALXCGU+13qshsNkccGhOSuIqSAxYFFxfpi2KVW2dyk+DP1P8jDtTUWh1jw7tIjTPM4RdTmwEhnqs8hX5dC6KTdHgtXh/xgV+u4AE4QDq11+NJ8KNBDBZFesFjVTYtZMikxNQA/9Y5oDf3BT+6ZMcEZBISD/BWmk8Vqr9fmiO9ICU4E1yGwoJ1iw9ohpB+KB7aqquRF0CY1SwelrwBmFgSvE6VuTrpQGmAvTgulne6qbMIf
 Ik/lta46
 +mbCNPUzybSCwVRaOlqE3LmKxMdgwTbjNUjCRjWQQaiClEgQwj687FdWLWiWFOmU62g8PM3HiK21Jqcv8EkkWHZzBA36AoQP7Zi3jgDTWFqoB6QaQa1HcgTkhWYq88W7WYRDpIqs421psUOK6VYWdV8Z0mZoKcWMHiVoCZ/ZnUOA3hSlqLQqToh6RwnyrER0Df+O5wk5B62vKiDl2nb1fmlIQ7ySI2WisdzuLnAFEGTGv0lIZo9Z+Y4bLQxGautq7j4wKZUa00agbooNL/x3LlrpbysaRxEhN+pmobO4LBRL+KYWnUsmBZA+R0fiKWkHqAZWAaUCJbhSAQHOE3qDnaeG5W1OobTEhl55mjAxWQXTEMKfXz4gTYTkjmmXK4odczkYkl9p6fO3dS5sGRdsxXPhBVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:23:39AM -0400, Zi Yan wrote:
> On Mon Aug 3, 2026 at 11:07 AM EDT, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 11:02:30AM -0400, Zi Yan wrote:
> >> On Sat Aug 1, 2026 at 5:36 AM EDT, Lorenzo Stoakes (ARM) wrote:
> >> > On Thu, Jul 30, 2026 at 10:18:00PM -0400, Zi Yan wrote:
> >> >> During a pagecache folio split, an xarray node allocation can happen and
> >> >> needs to charge at folio's memcg instead of folio split invoker's memcg,
> >> >> because for example folio split can happen during reclaim and reclaim's
> >> >> active memcg might not be folio's memcg. Switch to folio's memcg at the
> >> >> beginning and switch back afterwards.
> >> >
> >> > I assume this is the only allocation? I guess in general it makes sense to have
> >> > the folio's memcg be active here regardless.
> >> >
> >> >>
> >> >> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >> >> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
> >> >
> >> > Cc: stable?
> >>
> >> Like you said above, only xas_split_alloc() is affected. And we have not
> >> seen related workingset regression report (like what Johannes reported
> >> in commit 7b785645e8f13 ("mm: fix page cache convergence regression")).
> >> It might be OK to not backport.
> >>
> >> Johannes, what is your take on this?
> >>
> >> >
> >> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> >
> >> > Change seems reasonable overall.
> >> >
> >> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >> >
> >> >> ---
> >> >>  mm/huge_memory.c | 20 ++++++++++++++++----
> >> >>  1 file changed, 16 insertions(+), 4 deletions(-)
> >> >>
> >> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> >> index 04e8a6b553435..b9c2d8908e564 100644
> >> >> --- a/mm/huge_memory.c
> >> >> +++ b/mm/huge_memory.c
> >> >> @@ -4063,34 +4063,42 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> >> >>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> >> >>  	struct folio *end_folio = folio_next(folio);
> >> >>  	bool is_anon = folio_test_anon(folio);
> >> >> +	struct mem_cgroup *memcg, *old_memcg;
> >> >>  	struct address_space *mapping = NULL;
> >> >>  	struct anon_vma *anon_vma = NULL;
> >> >>  	int old_order = folio_order(folio);
> >> >>  	struct folio *new_folio, *next;
> >> >>  	int nr_shmem_dropped = 0;
> >> >>  	enum ttu_flags ttu_flags = 0;
> >> >> -	int ret;
> >> >>  	pgoff_t end = 0;
> >> >> +	int ret;
> >> >>
> >> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> >> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> >> >>
> >> >>  	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
> >> >>  		ret = -EINVAL;
> >> >> -		goto out;
> >> >> +		goto out_no_memcg;
> >> >>  	}
> >> >>
> >> >>  	if (new_order >= old_order) {
> >> >>  		ret = -EINVAL;
> >> >> -		goto out;
> >> >> +		goto out_no_memcg;
> >> >>  	}
> >> >>
> >> >>  	ret = folio_check_splittable(folio, new_order, split_type);
> >> >>  	if (ret) {
> >> >>  		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
> >> >> -		goto out;
> >> >> +		goto out_no_memcg;
> >> >
> >> > This function really badly needs splitting up and probably some cleanup.h work :)
> >>
> >> You mean folio_check_splittable()? You want to move -EINVAL checks a
> >> separate one?
> >
> > No __folio_split().
> >
> > Comment about cleanup.h really was the whole pattern of goto xxx for various
> > levels of unwinding things.
> >
> > But really I mean the folio splitting code in general, there's a lot of
> > massive-complicated-functions with a million things going on at once,
> > __folio_freeze_and_split_unmapped() is another.
> >
> > Feels like we should really have this stuff in something like mm/folio.c anyway
> > too now that's renamed :)
> >
>
> I agree that __folio_split() is handling multiple cases, anon, shmem,
> pagecache, all together. Do you prefer:
>
> 1. split __folio_split() to handle each case in a separate function with
> some code duplication, like xarray for pagecache and shmem,
> freeze/unfreeze folio for all;
>
> or
>
> 2. encapulate per-case code in small functions, like
> if (is_anon)
>     split_prepare_anon();
> else
>     split_prepare_file_backed();
>
> __folio_freeze_and_split_unmapped();
>
> if (is_anon)
>     post_split_anon();
> else
>     post_split_file_backed();

Well these 'post' functions are a bit confusing so I guess I'd say experiment
with different approaches and see which ones end up with the nicest code :)

>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

