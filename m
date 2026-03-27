Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B71010ED67F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5036B0095; Fri, 27 Mar 2026 10:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596156B0096; Fri, 27 Mar 2026 10:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D25F6B0098; Fri, 27 Mar 2026 10:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BB076B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:12:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 061F68D796
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:12:14 +0000 (UTC)
X-FDA: 84592032588.03.8B65D1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 49EDC1C0009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:12:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZfPFmxA;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774620732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jebn+5I6JMXRFlCC1NKK3OymOoHMCzAxmACgdoPH2Sg=;
	b=yOjB4qRLkVgia5kMQW48bZYPTAR76aVHPGGFdrva1j0Z0SCPmAarteqWBCM7s5d0oiyLZa
	ZWgGCsR03//VGr0J4eKYdJXCXEm1Uwi5JR32hpvhB2gLRBydWJztZ9PpIXBat9kxYyeLxo
	PJ+Mrdxx5wTCfBuqI6D6gupvqM0cZrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774620732; a=rsa-sha256;
	cv=none;
	b=vmwB0sZnwQLqHIq2jiKjniNkqePFOuosUhMazv81XarzfCqxEnFUWi1ufx6E/dbj8GpNqm
	M8siLNBKFmI6rlBTCEIViIPdqDPPEUePpakGQSz/MZ5dcmM1ZO22MbDQs+Jr/Yo5gb9i9g
	AxkpVTyn0sbqnbNPdtYdVASlrd66LII=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZfPFmxA;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DEDC60054;
	Fri, 27 Mar 2026 14:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896DBC19423;
	Fri, 27 Mar 2026 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620731;
	bh=10d/bauSZZwUaWeqxAp5AEl72kx44Zuct76qpMiWslM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FZfPFmxAuVBhLAkxJIgmHiPwI+Nesyrc086MBBCRNDFpEh3oTv1sjwFdmZ0AuaLPa
	 2DW/s9CaITCvU31XQKpY0QCn4MdCBJzpR2+h0aDrkIGdbhSu36GSw+ztSv2s839Rxa
	 oplhpvpdvKkReCNa0Nq2KZ6RNMLk1ctntQjuU2L4PJvjQTonb4xBAIiDqwXio+T+Ip
	 YT5sIdJtu4nlXcAkeW5rVMVdI3GK1zNsBY+51DSoN7785lZs73UnLXaiD7vDPKxoLV
	 tumNAiNeyQnpj0tqr0Q2JlowB2lo9qylylLn9K8SuCspmKR+dmHlXGZF2QoOsPRVm0
	 jtt0OXTV5qzCg==
Date: Fri, 27 Mar 2026 14:12:03 +0000
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
Message-ID: <89c8b93c-f6dd-4d8e-bcee-3c1ff1c04295@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
 <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
 <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: ugyjmgnbuxzgtgte3w59pmkr4ymyhgpu
X-Rspamd-Queue-Id: 49EDC1C0009
X-Rspam-User: 
X-HE-Tag: 1774620732-350130
X-HE-Meta: U2FsdGVkX18EACYErxnITANl7aRp7XuPvuH6nFafs5p4Cf07Y+dF4AftINVJZ7NgyiIcBFMn3iEcti/ew0maIWYb/pIEg1ZZYo0MmkTZ64Rhutn9+T94GTDjckniwAq5Su44cIQyTHBp47DO6liTbcIkTAY0jphfCuB18iBdamyn5VJmPMPBlElaBsYOIATPgUq5A+oRQqydizsqZ7LxhYlEKOB8CFd/smnJw/TzHei/rnOeRftiF7/RE+jFac2MikNW3W/TZxpKhinDjTXbo+u078ty5J+VGWMooOC0eCQ13Gc4caLrtB4z6Ug1C5sQy+1+ZJpkvZm2OWSKvCn/DCbMtsGmXlmqCRr3GxyAbdzWai65WLStjE7Y2dqd5kA51ERxnRpqcrM5g5GdB1nWCTC9EIX1IwC0GKGF7WKakIqAB+6Ehxe74JWRJNcby9q6ipqC3jRvkXXdqvhqwEpgjFWIv49w1pMmM9xmC9PRA3fbo3tQlTjYQLR9AO9GOLi1pfnsBHrRXFdpV4jetOfum0oDnbK0vJ3NP9hL7T/Me2inCy5X1WzxkTmfzvXw+DzuefvvtLzUB4DdcAcy+ggVQfIR0JgH5js9eO8kcKs2cTbiRO4349DZFSo2Ub/EwSj/in1YXs2Raklg/AqZ21op3NtjsiGP6o1H3+8zC6qasGlWLUVRbfJi8xBMHhfq57Fdg01JmFFZzG1RPC28aQtIbZpYo+hfXNEyWQbhM7RJ1AdTJZAdUUSG1WZt1TjK5gk+OWWC5Z+nIpSYS9amEZxEr3N+dHzfhHL2EY+R6LwORveBaQiwFq4ac1pq/7/c6h38wzTdj5ZEOS967JQYyxs19pzPc8rub2kICj5pTYdXeJY7Pqf3u6JfG18EU8e27DYrKMamK62kJuPqau+a3IKxfObvx0jnroQ/ec7r0lAz/1mlEkNBAYao8Ba1neUFrOBsiti+uVfGplfZIbT9gYz
 htnvFZ4P
 ggK6hoHL5/H1jc2EnPj0997n1PDH3R3MuBXootPdg0JKvhsUFP7wA68hMTPfpUi3FxYZpeNy4IZzIXzL5MZK0bYqXEIEE3uZT1I0oZWSVzIYLQZ04vCMs9f4nzHASUGwe6bpy+UQVDNbx+tgGPghoKvsx2bc8IXDKlBT2hqTvibfOxwxDdafEreR+MqISG/n7kyYJRSBmHyQQg7LM2MYXzEr3ug8W0aKB7w7YqIv949OVv1J+4F0wA1Y6RPyk9x4Ac8vxNyjNQj36iD1qa2JFvzIIfxOQfSLnPHyV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
>
>
> On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
> > >
> > >
> > > On 3/27/26 9:42 AM, Zi Yan wrote:
> > > > collapse_file() requires FSes supporting large folio with at least
> > > > PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> > > > huge option turned on also sets large folio order on mapping, so the check
> > > > also applies to shmem.
> > > >
> > > > While at it, replace VM_BUG_ON with returning failure values.
> > > >
> > > > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > > > ---
> > > >    mm/khugepaged.c | 7 +++++--
> > > >    1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > index d06d84219e1b..45b12ffb1550 100644
> > > > --- a/mm/khugepaged.c
> > > > +++ b/mm/khugepaged.c
> > > > @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> > > >    	int nr_none = 0;
> > > >    	bool is_shmem = shmem_file(file);
> > > > -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> > > > -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> > > > +	/* "huge" shmem sets mapping folio order and passes the check below */
> > > > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > > > +		return SCAN_FAIL;
> > >
> > > This is not true for anonymous shmem, since its large order allocation logic
> > > is similar to anonymous memory. That means it will not call
> > > mapping_set_large_folios() for anonymous shmem.
> > >
> > > So I think the check should be:
> > >
> > > if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
> > >       return SCAN_FAIL;
> >
> > Hmm but in shmem_init() we have:
> >
> > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> > 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
> > 	else
> > 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
> >
> > 	/*
> > 	 * Default to setting PMD-sized THP to inherit the global setting and
> > 	 * disable all other multi-size THPs.
> > 	 */
> > 	if (!shmem_orders_configured)
> > 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> > #endif
> >
> > And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
> > shmem_enabled_store() updates that if necessary.
> >
> > So we're still fine right?
> >
> > __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
> > __shmem_get_inode() which has:
> >
> > 	if (sbinfo->huge)
> > 		mapping_set_large_folios(inode->i_mapping);
> >
> > Shared for both anon shmem and tmpfs-style shmem.
> >
> > So I think it's fine as-is.
>
> I'm afraid not. Sorry, I should have been clearer.
>
> First, anonymous shmem large order allocation is dynamically controlled via
> the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enabled) and
> the mTHP interfaces
> (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
>
> This means that during anonymous shmem initialization, these interfaces
> might be set to 'never'. so it will not call mapping_set_large_folios()
> because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
>
> Even if shmem large order allocation is subsequently enabled via the
> interfaces, __shmem_file_setup -> mapping_set_large_folios() is not called
> again.

I see your point, oh this is all a bit of a mess...

It feels like entirely the wrong abstraction anyway, since at best you're
getting a global 'is enabled'.

I guess what happened before was we'd never call into this with ! r/o thp for fs
&& ! is_shmem.

But now we are allowing it, but should STILL be gating on !is_shmem so yeah your
suggestion is correct I think actualyl.

I do hate:

	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)

As a bit of code though. It's horrible.

Let's abstract that...

It'd be nice if we could find a way to clean things up in the lead up to changes
in series like this instead of sticking with the mess, but I guess since it
mostly removes stuff that's ok for now.

>
> Anonymous shmem behaves similarly to anonymous pages: it is controlled by
> the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() to
> check for allowed large orders, rather than relying on
> mapping_max_folio_order().
>
> The mapping_max_folio_order() is intended to control large page allocation
> only for tmpfs mounts. Therefore, I find the current code confusing and
> think it needs to be fixed:
>
> /* Don't consider 'deny' for emergencies and 'force' for testing */
> if (sb != shm_mnt->mnt_sb && sbinfo->huge)
>        mapping_set_large_folios(inode->i_mapping);

Cheers, Lorenzo

