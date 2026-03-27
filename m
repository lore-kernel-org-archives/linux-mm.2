Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B43810ED64A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC4C6B0096; Fri, 27 Mar 2026 08:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACA86B0098; Fri, 27 Mar 2026 08:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74356B0099; Fri, 27 Mar 2026 08:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B21186B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:02:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70BBDBE6A9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:02:13 +0000 (UTC)
X-FDA: 84591704946.03.DE819CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6F6714001B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:02:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=du98Vx8y;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774612931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCjDNYQkBp7UOykBAf3dwBfiXByhYjMKjVk00/ZKHEo=;
	b=mJAruqGNu0F4DAmz3vHH9r6OvCpc3QsjrFIBJf4UlgooIt/OG40wLHE4Fy1cHuqxYM2vhq
	CBN3pp1b2I02RWSGPmuCMFq2F4GAq0gy6S66bwl0A8obhoXv5yl+l3iQeCSEHJl+fKddDp
	ELYUYLN6FKLy/BTYPZRTYNnLuJ0qRXQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=du98Vx8y;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774612931; a=rsa-sha256;
	cv=none;
	b=yAeDjHMwJ2zf+VIEiJWK47Vkg84ZPxs4FwR/xPXSVSuZluhU78Q6sFe7ilY6Wrx9wEZyOQ
	ktpETf0xx+TQvjgOItPA493KKQUcr+y2V3vMH8t1epC28j46XwtCe4J29DEvfxZnpIDqG+
	5W5AfFHm/s0g9dqBWXoF2MLm6MJzl8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A1ED760133;
	Fri, 27 Mar 2026 12:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C5BC19423;
	Fri, 27 Mar 2026 12:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774612930;
	bh=Ug6PXMZj5EM6WaHP8j75mffKH6tZAhlPhePI6D/ozn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=du98Vx8yCn1S+x77RS40l3PUv9m7U54a1BwLsWUzQ5x0o5lkD9sbNwm2BqD3vBJ2g
	 4zGGHCojY9pjHPq8vsNhlThNLw74qSgYHIeQnd8TJCxibLmYCoi5bzObLOUjBAXIC0
	 6yMLnMKEqtIOmooxZK5qyFWlLWFQkTl56n+LnDBuRci7Be1pQBZ9o13MsjLYRiLcIH
	 Sbmx+to7Vw0rdUEu//tSfSYufDqE/N4VnQHoA/7wxiuz6FuWkk7ebV01GWnIx5To1z
	 xd8F06ss8tLsfEbejMlZMvaIR3MpZtme2pumQcIVVkhGZ7kl2RLVv3PGYK61pFdqZv
	 gby718h7/72gw==
Date: Fri, 27 Mar 2026 12:02:07 +0000
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
Message-ID: <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
X-Rspamd-Queue-Id: B6F6714001B
X-Stat-Signature: zcz5y1j8q6i9b8161xo3tuqsqys4ytnw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774612931-672949
X-HE-Meta: U2FsdGVkX1+NBH0NOjiF8zIIBRvjS5strfhnxvrVHTyszFdbhS1TIMZt8Tn62oceNByLl3xDDSBoR794pUGTm8w7bdJ4epKrHilo2N2rPvSbDIJ+9PqMQfuzu7PySUCWuI8d0G56i3KizkBdLwJBwJ1K5s+8pt3xkkjihHzEakMBfn3tFLAwKcEs6KkQd7Z+uQpUCyVYyMY+sGI3SCo4lwHzFHYUjpe36gIqwyel4Qp0ntbsG0BIKdoRQntgYNyeEGVPxw5CE2h5AoMvldF7gJkYM/Ngt3h6iGbMJaA9UcD+T5wt9DhuqE71+Z6mbDFNXNQpA6odWw2+W50rCohko4OkgiN261L19i19slTBK3BDDExLXC31ud11F3ECqekTMJfSBku5ZhLJ1kwno3JxjGpjwKXsba2hXAGKKm7xlPP5Q3N1BjSsZtGkri+Jfq9WYWPvBlZSvwGcXphYHeuZDsOgpnJQF/Q/HnlQq/3cHfKDzsNPMNKoZs38twyW9E9CeeFaCXr60OUH7yyCbKIrPBOp78Xm3MPppPLnPzgw5qJBwfhkCaV/ytKxlCTE+JWRAXAP0+Fn5Zz/w50ObAT9etU5Q0//8niqVpuw93SijXa8FgS8RlMYQClw4WkGWf0S8djazkpLsjX7gAP5NmNvVGvFOl0XuzwUdzJG+GcVzhCG+c9YFVlVCgu71iwAGwrAuNB3bzZdbBrxV2y9cbOhRdUPJzpLg9jpODwBs8CcnJJK48+jO/GZMYOTGP2nWW3W08o2GagRwETRQ7pIi62Er67gkTwQGHMowgyWUmEF0haET2KsfBnJYhguA/16PzHi3MUXOW5W3jILjivBrLnwfuDy40BXhvv6NuAx2Tz5zgEwgqYspUv1O3s6/zyNAjVMbVPzwME4w087DSf6obfHNHHzCXlNKqsDQ84bep9jlO+14B4TMiJoKGJrloUcbwo6XHg5GOGlu9mHJ7AaKh5
 MrTE8Smd
 ofqWl5ZwsPc55w5Aek/Er2UhGABZcoT1KbJVhb9pkZ/TzWbm2QQD/hHeTvUAjF64ALawUXjDrMdhkYi52Da0RcVKztnUali9+FMjZkn07M+fvf6iG8/H2zJlV2fhTK+k3Ak7mUxKThUB+DPCTCgqU3EroJ1uRnfigELZw7I+SsAeW86RpASY9XdpJbmllCysl3VZiToBGxmG78sD+tDrEuvxk0IRHnPFsdUL5ma1NMVhXOQseWRljuaq11AVwBxriUdUwjACB3QYSciHVlCDITv9DzlT24cXO+t0g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>
>
> On 3/27/26 9:42 AM, Zi Yan wrote:
> > collapse_file() requires FSes supporting large folio with at least
> > PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> > huge option turned on also sets large folio order on mapping, so the check
> > also applies to shmem.
> >
> > While at it, replace VM_BUG_ON with returning failure values.
> >
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > ---
> >   mm/khugepaged.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index d06d84219e1b..45b12ffb1550 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >   	int nr_none = 0;
> >   	bool is_shmem = shmem_file(file);
> > -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> > -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> > +	/* "huge" shmem sets mapping folio order and passes the check below */
> > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > +		return SCAN_FAIL;
>
> This is not true for anonymous shmem, since its large order allocation logic
> is similar to anonymous memory. That means it will not call
> mapping_set_large_folios() for anonymous shmem.
>
> So I think the check should be:
>
> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>      return SCAN_FAIL;

Hmm but in shmem_init() we have:

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
	else
		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */

	/*
	 * Default to setting PMD-sized THP to inherit the global setting and
	 * disable all other multi-size THPs.
	 */
	if (!shmem_orders_configured)
		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
#endif

And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
shmem_enabled_store() updates that if necessary.

So we're still fine right?

__shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
__shmem_get_inode() which has:

	if (sbinfo->huge)
		mapping_set_large_folios(inode->i_mapping);

Shared for both anon shmem and tmpfs-style shmem.

So I think it's fine as-is.

Cheers, Lorenzo

