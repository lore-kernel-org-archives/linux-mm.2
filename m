Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 370C010ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935F76B00A6; Fri, 27 Mar 2026 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6D96B00A7; Fri, 27 Mar 2026 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824336B00A8; Fri, 27 Mar 2026 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 745F56B00A6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:31:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F30C8E177E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:31:15 +0000 (UTC)
X-FDA: 84592080510.11.B0722A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 367E914000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:31:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FA65YRld;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621874; a=rsa-sha256;
	cv=none;
	b=lJ7ZLw3j6hA9cenmuLbE0ND1sBNNkGkZxNBtSoxK3/ieiWO0bQwQJt+hi+HpAm8zGkSq1H
	HKfoHnKtDEYxFuoz5V0Kzr/+UDyq7WPXM/njGd8lCZ7ZFdxYO6BbTqryCB04CqFwHVwxWf
	fgsjPnMXbVHpkeJ+FZQ5FzEL+fSTk7Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FA65YRld;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFXPZxoDmWFTpocvfrUnISb12Pkk7t0JFMib9TNSA74=;
	b=3F9vdP/gcMXQBYD6VHzsmQB1EFELjkl27ucBbdZgzGUQzG6V+VHwZJ6wDtGoORNAgu8Xuu
	9/p3aM+W6JbOjekLmtw/s7jXFpU0GJauXlHfQ9CKadgh0iuilIKm3Y0tmxMZ3RkR8qMCU9
	piD1WLJMkTnI4S/qdIYsCh2AbbH1+A0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59C5F41A95;
	Fri, 27 Mar 2026 14:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8E8C2BC87;
	Fri, 27 Mar 2026 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621873;
	bh=MrvKjRWkl1Y6HHbAPwGm0kWozY8T3Glyl78Hgi7yspY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FA65YRldQYG5G3drQMMoAc8SfQ4mmeIUA90nBgmb1APmS8p6BhrzYu9nrBDDjJfto
	 tMBA9seiAdGawC246pLjV+Fl5yut7bDI2tSd1BoHbsW+K3JnTkXzANWLMFai+Z0b+8
	 +lyTw8FpFfTPmDRtT9Qo8aGRXT3lo236j74uh/mLZvP2qfIlCIGdmBFY+f1STVdcdV
	 i7GtH/LWRU0i++pN+8Bt945zXeQXk5IQKYViC1aplops7W8LmQ8KPMcMekKZnq2GHT
	 wZX83qWDlNnCQT3ZAIXM+3nmM7S475HJjU6WRuj+KtTSvG7Mw46mbRhKWnsePUXjna
	 7p88Q+af6JbLw==
Date: Fri, 27 Mar 2026 14:31:05 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Message-ID: <6442d533-27ae-4e2d-b8d1-64acdd2dfbd9@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
 <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
 <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
 <89c8b93c-f6dd-4d8e-bcee-3c1ff1c04295@lucifer.local>
 <b9bc241f-91a0-4df3-a5fb-2221bee3ab68@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9bc241f-91a0-4df3-a5fb-2221bee3ab68@linux.alibaba.com>
X-Rspamd-Queue-Id: 367E914000E
X-Stat-Signature: izxi4c9818ifhw4y8zzyhtjo53j8nti4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774621874-303096
X-HE-Meta: U2FsdGVkX1+XhwkirwOjc6iLQ05wxPYf3h6DFfLBECOAvtE8IRBpjUdY9+WyelVJmjjIXEPWNEc5XVCTqDjaJK05eycliS+g4qfUJRsK0gG1SXBVDxF6rroMaXZLv3Zo28PKbw52fh046EqCa5vLXTRwL+h5PKMEDi1cpiwDe//eQbJMW0eoxrzq0Qs0bWdj13u/2oV4rrdho5yCNCuHUu4O1z0sW2KF0mhKsK+vCriEuChzCjp+cA7bOsjr1FqEwU6uLBfqHTmvjCEqWU7vmGk1i9DG/Ms45WRqVllgve58p0IywCoytYHO/k41EDTuOGOsMJUkfiOZFAygPZcbjHd5UzloEsvOxpAxcbzJv/Xy1790oYZBMs0qKNqwkkqsYqq4AYFRfdxR9QERJq+wZSoJYG9vDZ+pb39+pCQdfSVa9yfXUGu7A65LRAHkqEFig8MZq7czTGxiRmqLTEgyGVCRRH/4DehdcQHgT6mLYhh5MS+3d1dfidIwqi63CvJ9N5boCRpP5An7A+dYzMiQPjp1FsTLOHlmHLPQQRnwhXmVH/yhJNyVhLLkT00APbNEi8SJ0Xs7HIt3b5e2JkzpArImLF4bB25Tx277Y5cDt2F4DhiAeaNBnAdY0u+/M7k8ownJMKCf3SdcxavfQypvZfifwQADMxtMD82wFGFyGXg/1e5YP1VeLw14d7a5btinzh5c+OfMTf4JLWFph2kdWFKPAQGBNVkZGmDIWO2UxSfPzHhyFRPTqB7Du9G31Ad4FD8BH41nwcpvDczRs0A/UlHD731htMflx9IypxqUuG6/RqYQVvUyoxDaa+0D6lLw4WtIaBBEN3iYvyNf5G7hYAXJ40nCA4Sg26inwwJtVh6XLmtmg65cl+NeaQlPk4A6TDSvbV6KnpKdwAMzXw2Ul0SRmvknDLM8qQNc6LC7U1usgEos9IbC0KdtsEmxy+xdk9tIiH1xTtwSsY6eup+
 UC2h+udP
 IyQEzUyZs8ZdUwmjU/AQ2LDhNNfsXBRE34GHVHRdZMjeLFq5tac9WEsWThzoy+Pun/jz3O5uWLiEDd9AB8S+ONYaCazKknuWdl/nm+rXcongzyE3733OevSP2hEvV3naIBPUhzqEAnZj9y4iIT7ZmkXdPQ39Y9jKoXL7GC3bl/sC+Lpnhf+phylAr7lu5c7NWlHYzqrrrplRKN2rWeAUlratnqYc1vZFbrfkPy707rDjpyMtZInTiYof/0ZqiapiK3qIZCwtQSyUqi0+gtFvKtCbTMSpWFuLB2wcd1Bzazt1Lfb0wv8ToQjufoRO+yO8oJZ6w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:26:53PM +0800, Baolin Wang wrote:
>
>
> On 3/27/26 10:12 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
> > >
> > >
> > > On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
> > > > On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
> > > > >
> > > > >
> > > > > On 3/27/26 9:42 AM, Zi Yan wrote:
> > > > > > collapse_file() requires FSes supporting large folio with at least
> > > > > > PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> > > > > > huge option turned on also sets large folio order on mapping, so the check
> > > > > > also applies to shmem.
> > > > > >
> > > > > > While at it, replace VM_BUG_ON with returning failure values.
> > > > > >
> > > > > > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > > > > > ---
> > > > > >     mm/khugepaged.c | 7 +++++--
> > > > > >     1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > > > index d06d84219e1b..45b12ffb1550 100644
> > > > > > --- a/mm/khugepaged.c
> > > > > > +++ b/mm/khugepaged.c
> > > > > > @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> > > > > >     	int nr_none = 0;
> > > > > >     	bool is_shmem = shmem_file(file);
> > > > > > -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> > > > > > -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> > > > > > +	/* "huge" shmem sets mapping folio order and passes the check below */
> > > > > > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > > > > > +		return SCAN_FAIL;
> > > > >
> > > > > This is not true for anonymous shmem, since its large order allocation logic
> > > > > is similar to anonymous memory. That means it will not call
> > > > > mapping_set_large_folios() for anonymous shmem.
> > > > >
> > > > > So I think the check should be:
> > > > >
> > > > > if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
> > > > >        return SCAN_FAIL;
> > > >
> > > > Hmm but in shmem_init() we have:
> > > >
> > > > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> > > > 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
> > > > 	else
> > > > 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
> > > >
> > > > 	/*
> > > > 	 * Default to setting PMD-sized THP to inherit the global setting and
> > > > 	 * disable all other multi-size THPs.
> > > > 	 */
> > > > 	if (!shmem_orders_configured)
> > > > 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> > > > #endif
> > > >
> > > > And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
> > > > shmem_enabled_store() updates that if necessary.
> > > >
> > > > So we're still fine right?
> > > >
> > > > __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
> > > > __shmem_get_inode() which has:
> > > >
> > > > 	if (sbinfo->huge)
> > > > 		mapping_set_large_folios(inode->i_mapping);
> > > >
> > > > Shared for both anon shmem and tmpfs-style shmem.
> > > >
> > > > So I think it's fine as-is.
> > >
> > > I'm afraid not. Sorry, I should have been clearer.
> > >
> > > First, anonymous shmem large order allocation is dynamically controlled via
> > > the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enabled) and
> > > the mTHP interfaces
> > > (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
> > >
> > > This means that during anonymous shmem initialization, these interfaces
> > > might be set to 'never'. so it will not call mapping_set_large_folios()
> > > because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
> > >
> > > Even if shmem large order allocation is subsequently enabled via the
> > > interfaces, __shmem_file_setup -> mapping_set_large_folios() is not called
> > > again.
> >
> > I see your point, oh this is all a bit of a mess...
> >
> > It feels like entirely the wrong abstraction anyway, since at best you're
> > getting a global 'is enabled'.
> >
> > I guess what happened before was we'd never call into this with ! r/o thp for fs
> > && ! is_shmem.
>
> Right.
>
> > But now we are allowing it, but should STILL be gating on !is_shmem so yeah your
> > suggestion is correct I think actualyl.
> >
> > I do hate:
> >
> > 	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
> >
> > As a bit of code though. It's horrible.
>
> Indeed.
>
> > Let's abstract that...
> >
> > It'd be nice if we could find a way to clean things up in the lead up to changes
> > in series like this instead of sticking with the mess, but I guess since it
> > mostly removes stuff that's ok for now.
>
> I think this check can be removed from this patch.
>
> During the khugepaged's scan, it will call thp_vma_allowable_order() to
> check if the VMA is allowed to collapse into a PMD.
>
> Specifically, within the call chain thp_vma_allowable_order() ->
> __thp_vma_allowable_orders(), shmem is checked via
> shmem_allowable_huge_orders(), while other FSes are checked via
> file_thp_enabled().

It sucks not to have an assert. Maybe in that case make it a
VM_WARN_ON_ONCE().

I hate that you're left tracing things back like that...

>
> For those other filesystems, Patch 5 has already added the following check,
> which I think is sufficient to filter out those FSes that do not support
> large folios:
>
> if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> 	return false;

2 < 5, we won't tolerate bisection hazards.

>
>
> > > Anonymous shmem behaves similarly to anonymous pages: it is controlled by
> > > the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() to
> > > check for allowed large orders, rather than relying on
> > > mapping_max_folio_order().
> > >
> > > The mapping_max_folio_order() is intended to control large page allocation
> > > only for tmpfs mounts. Therefore, I find the current code confusing and
> > > think it needs to be fixed:
> > >
> > > /* Don't consider 'deny' for emergencies and 'force' for testing */
> > > if (sb != shm_mnt->mnt_sb && sbinfo->huge)
> > >         mapping_set_large_folios(inode->i_mapping);
> >
> > Cheers, Lorenzo
>

Cheers, Lorenzo

