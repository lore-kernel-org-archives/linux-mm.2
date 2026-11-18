Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBB0606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NH0OyTPs
Received: by kanga.kvack.org (Postfix)
	id 934566B05C4; Wed, 18 Nov 2026 09:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AB56B05C5; Wed, 18 Nov 2026 09:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA6D6B05C6; Wed, 18 Nov 2026 09:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 586BB6B05C4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:38:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE96AC076E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:38:42 +0000 (UTC)
X-FDA: 85448496084.04.07C107B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 446F440008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:38:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NH0OyTPs;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012721;
	b=kQADO0XFP3oM6ekPmt6Zzr1/VsZU87KPyWVOwfCGD8T1cKjQKXaNvjXuhZbIhpc5IPf+Tg
	YdnGE4QfJDLEl6cNvbHPJmbrwrXJczLrCSqfO6Ov5Oemk8xWhmiTw07w1YamWS8M5HA61i
	mNoWRp1JyJ1KYdmLlEo2q1tdESIU7Yg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NH0OyTPs;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eSFRUxNp/7+gMqqEqt2trFE9S3TEcIfNW65n8uJu4s=;
	b=Ave4dOYVzjh3e956LXBrk2NFGt4shz3VPfwlerqoRChRoP9npZNg4Zt8PtaQBFhHvSnwRn
	lpEdulC7Z9ALYdAVeisHa6MpvrhIrlFujafLqoBIUkN4kxDalcYO4CJwcHTx8oSLBolq/K
	3/KLn96QlHiUqOLTUJ+GRSi3X1DsuDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 755DA4069A;
	Wed, 18 Nov 2026 14:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21511F000C4;
	Wed, 18 Nov 2026 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012720;
	bh=0eSFRUxNp/7+gMqqEqt2trFE9S3TEcIfNW65n8uJu4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NH0OyTPsYET+SG6a8MQ7AB6SuivmK3D31Odv4Mz5qV9Vxa7UCoLuM6lCqbI9VfRGu
	 4vdNtxmYCHKVbsdIzhQHoMsqN4BjqTE1o6hU+4Dnzbkpx5NJrGyjQNCyP2oCpLapwj
	 4PoaOsC4h5mrBt1U3dzstt+W6Ae3loDNa7H22Xp42jJq8pcrKnNWiB88USqBPcOACw
	 84tG5o+PkO5FpxJdEMb/yw2u7ye6ccTPuV7hze80ccDnq8oG1HkcUcbE4eU4SFyBGE
	 xdyEYvUFPxeGwx3RBAoLVBkEbewAfS7CVNF5uxg3AiYq8z2uOdczc/oZjqhitie6u9
	 syPOVIDqiuqIw==
Date: Wed, 18 Nov 2026 16:38:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 5/9] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
Message-ID: <av24YrE4rbg2x6c4@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-5-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-5-b617009d1a4a@columbia.edu>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 446F440008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: e1hzmiwhf6p6fd8e46oonb6m7tp8yjw1
X-Rspam-User: 
X-HE-Tag: 1795012721-700119
X-HE-Meta: U2FsdGVkX1+nL9JwV52tKRGXBV6uFSRH1Mm6weMcA85HbCvPucvnqIevRN/avVDIJhdulNQ8eZbzkm2KCn7wgrqsmZMI51IDAG4IwZS3SNKE8CoO888w4jEZaDbtL/ZFyLRyBx9XufKFoMdketyFtGGnzUr3QbAh35BryrabRUras1c7crU1mMTRxDaOfggayJgUN93At5STH4/4xTzms5PoUwLXQw9QBCrtaSkExx3uTGtFTHvR9fEWYzQrQ6AU+m8u5BloMFIa+gB6sfKni5cCEPh+KVm6CX5i7zz/+NwsvhEjgllnxviYI3RwV768dcDi0qXRfqYxaYkRGcr7LACvUltuaoV2i40lWEjPenwS9mS3+R+Xe2WefAAZvfi9c79vpd7RSU3dOfv1B3RuQSNICCETQFjuC3m0tS2hLPF44LPFdpmfiSrx4JSPVYDRfkPGxEaikBWZtnQFe/3AvYLX1ZLbzZ0Nx40Ko7lsbDfUjGY5hwnA3llJM0Lp4w/NNRINzuE+uaEacMVZsUfqUbd7A0PUDmgTH5lwjZTp42aLbJq2dj5Qmn+PL1oXqOxwBzUsQ4q80JI5CE9BxD6RCkRNRclJiyY6kz1aDRce7ImpZXimZIVej8763BXI/j9VUUMPW++Cley7qSSG5Ee3wynm0GgupLUqmn4wvV36kbe8rFkPiqpIZHlKJgki2MOJnHg8AN648COZ+dp2L2IVzw2ubyB++sfZxsoPhmKqaXmp2EMpYiYoXJIWw/wJYHZk/SWQkbO9VhE08fZC4IizKV37WE/zU3DzfGqFkXfH+VMIEzBd9Q+LRHm8sbGeyVB64aK1Oxe5U9vVKPZPgKf2Immclg5pNUrojzI2qv1auOQATfuclSDhyPGfg4LikJYl3e64Q13fm9+CdCpCwZ4uRW608YoOyNpfV4dgEANO4FM49iHkduIbTvpoR7TeyUFVcsdl2f0iS1VGyf30upI
 G1TwU2Tb
 arZAbyUR3CUdEsLb5Paae0Vgt/ZaPU2YW7Qf5dD0HH4CZB0Kz8lvBIpARgmCM2dHNNEgKNFBy5V/k27k+WRPvn4KN6+i6rxW0sSfvU/4eDaKpgpdzkxl74nGq9vRKf3ty3oD78S8Lwq5iZs0F756zFki4S2mm+A/X89QfEPGuK876SnFy04fkHu0sJSzhAN59RdMa2SZ4jghvxKdSrejaeznsH1yMbhjYvDPk06uIyheue4PKGRMSM2CxbwxkVKFAjSSPeW7/FyRRH5OXjkmnGHgVJtQivCaFrLSsmGl/nAjNlgk9AY8d/q4YRtVsfiDhBxxSSl6/6BBeIOYA100xG+wbZgkF4UKJ5C1KUqJZcKLaMp41RYI/SKsP7n4r2qDXxDjxqImPM4+pcc+mbB4vXIWNKE1GScPPdva3d0IHFgPGxY1B6jENW5qsZcDaX02xVFial1+p4tV+rthYGac1+cqPaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:45PM -0500, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
> make_uffd_wp_pmd(), which handles a present THP and a migration entry
> but does nothing for a device-private THP. The PMD never gets the uffd
> bit.
> 
> pagemap_thp_category() reports a non-present PMD without the uffd bit as
> written. A user tracking writes with async uffd-wp therefore sees every
> page of a device-private THP as written on every scan, whether it was
> written to or not. This requires a driver that migrates THPs to device
> memory.
> 
> A device-private PMD must be write-protected like any other huge PMD. To
> fix it, pass any valid PMD softleaf entry to set_uffd_wp_softleaf_pmd(),
> not only a migration entry. It downgrades a writable entry and sets the
> uffd bit. When the THP migrates back, set_pmd_migration_entry() carries
> the uffd bit over to the migration entry, so the write protection is
> kept.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  fs/proc/task_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

