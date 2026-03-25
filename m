Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3EB109C029
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DBA6B009B; Wed, 25 Mar 2026 10:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045C66B009D; Wed, 25 Mar 2026 10:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4AB6B009E; Wed, 25 Mar 2026 10:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E023A6B009B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:58:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85AAE8C6C1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:28 +0000 (UTC)
X-FDA: 84584891496.14.A02B6B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DDEA100007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:58:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4H7nAW7;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4H7nAW7;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450707; a=rsa-sha256;
	cv=none;
	b=G0eKujL4FTqonz/G65ZMdLVXYFDm95i59vDSo/erbn4k7xVH7UN56OpZyhJOZxHVPFShPz
	R38HKj7qZHc24I9aSkzg/EBMSSNNwlpELlVMm12LYwuW659mA8WvXFjWLj1+jrWJbfEUCZ
	p4xXUhMDAh37S2g3Fzh12qmtKIBPWzI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAg/9SYOwNvXBsK3xYB3WMYU/nidc/COKx3Vf5pQQZA=;
	b=QUhLgcMtYTHZ2aHqm7a+xPGmMJ7t3zF6pKfkqkmPIrazjHVnRh2sKgZYGnaQZCRMS2qWva
	Ahl9WBrUv7EAoIk65uNvoBugVydQTapEKNCzfvbB9UBx/w7/owlLDJ35pGVJi0OWQS3IDX
	DHRPBsX1nl/DdOfYzunBGZqbwHELDW8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76E04600AC;
	Wed, 25 Mar 2026 14:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E62C4CEF7;
	Wed, 25 Mar 2026 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774450706;
	bh=PJ66QebMQICZPHru+Ol9tC17Y8ZYviklyv0rvmLSZHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4H7nAW7M8zf238SiNH7LcqjmEdcm69QKxxl5QtoBGJ3JRpt98C6N4cv7bpBpqV4f
	 R8LDjFfBF3z2EguuCUL8pxrw34c6hMyFX/FEryKCamqgdgFnZ0jhdcjd+4e3FVTgt7
	 apBPGPVaF9c8DeWNz1pYn9IbEpEcV5SxRKlU3yt6Ss6/+nADVOXQbwxXIn0fN9JvJy
	 8UjP2CS36YbhgQgMfUXil2w1MkzCZ92GjJbbb7H//Cb0F5Y6GO2kRCAFiRSPudQGSB
	 hb5EasVzLPBeRXllpvhCNzLtyy4zucK4eYz8xXVySYjbaNxM+2eiXUaA3uGwmnrvRf
	 usaZbsHCKJTyw==
Date: Wed, 25 Mar 2026 14:58:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1DDEA100007
X-Stat-Signature: 9q8yfsbna5e85o7wgfn7mwjaa1atgzg1
X-Rspam-User: 
X-HE-Tag: 1774450706-391512
X-HE-Meta: U2FsdGVkX18wR3bvzjpngbCt8clYW3ZoQnYFKhgyBIbcMo3PFW/mq753PbNWmC84lsym2cJLwZxOmwz+tg7GYSySZAcCg1xeAz5LU5LIWLnwUp4Fcsm1CTBqkg3d05hGUl8sN3dhYz3+6Hxe+H0k4rqoUYWw5n1+CdzwE+sl1mLOFlBCOkYOxGztCqZumHI6n08VLgEJUarlt1G0K9+TsXNtP5DGwoR6UZQSuwW8YfnB6FGsk8knvNq2U3goR8+5jtPcNjKF/cTBD7WmRWN12srnHxla+HTrIreS8Rh3V3OjiHM9Lxziw15F6/RCN9CLC7Gp7oEd6R6aaJTJlDEPgUzWPv3KvpZQcbxgSbEna9QLdD+q+Zx98T+5Cbq1x2FL7pNC0UaSVptWkvang977Nvypp2mknLWLksQsNm5X1RT7J5qsdBfAhqLNnroSRLK34mEuBmhbMN7yh84Rsn+lP56j4qhFhLxfeYNtIC+Ey1Pf/YE0f/1mFVlU+53Azw2Lo2iJuHVtZuyy4k102Vk7gHIZwLoX7aARZiW4iBDeUo957S5jM1STPBVKmQY/DRmvXOTsR8sVVHsfbFSrKcLGQMTJMocm6c2f+AGZNL1wti6Hk+HiG/KvX4olhlubuzOcOJLhDJUtJasm6eWEpUz7zQYUqY+XaCKYaJY1TMV5lgtYCiRIQdC1fRcL/lyv/+Y7qjZPRPG/kiCxCEf4m9hxmwKkzD4eRbHrbffvKvTt0e/0CiKxwwal2hB8LycQGLchAOYsrRi3EFyVoy33vpfY/MOV1tnbyKPdDt3vOVtJCrz8F3uh2ELilpn89rf4YtSn4hVpiZFj632aMIIuRSJGlnq9cjGQgr9MAKEmWLZoDYI0T1MzLQ36LmCeSFs6QxYg2L5oPcOVA6jDL+/qC4R4KUaqe8V0Bh3O+6jGpNVlfu4qTnx0jeYQ4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:54:50PM +0000, Pedro Falcato wrote:
> On Thu, Mar 05, 2026 at 10:50:16AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> > macro) always being inline, as we rely on the compiler converting this
> > function into meaningful.
> 		meaningful what?

'into the equivalent compile-time constant code' probably fine.

Andrew - could you update that if there's time?

>
> >
> > Also update all of the functions __mk_vma_flags() ultimately invokes to be
> > always inline too.
> >
> > Note that test_bitmap_const_eval() asserts that the relevant bitmap
> > functions result in build time constant values.
> >
> > Additionally, vma_flag_set() operates on a vma_flags_t type, so it is
> > inconsistently named versus other VMA flags functions.
> >
> > We only use vma_flag_set() in __mk_vma_flags() so we don't need to worry
> > about its new name being rather cumbersome, so rename it to
> > vma_flags_set_flag() to disambiguate it from vma_flags_set().
> >
> > Also update the VMA test headers to reflect the changes.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
>
> Is there an actual difference in codegen here? On -O2.

No, this is more about consistency.

>
> --
> Pedro

Thanks, Lorenzo

