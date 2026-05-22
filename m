Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB75CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576FE6B0093; Fri, 22 May 2026 06:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 527FC6B0095; Fri, 22 May 2026 06:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416446B0096; Fri, 22 May 2026 06:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 309B26B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:33:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70CB11409E6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:33:29 +0000 (UTC)
X-FDA: 84794694138.12.0E139E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 68EB420007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:33:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gGKq/CIz";
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779446007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSAKcTCjHEBP0sQv4s+o1EWc5Ccjv9UlLr1FZ7wIvhY=;
	b=gAFFRMtWGhFPP27zbVhRc9Dy2KkiFOd0k2DiSMFwZvCwZ9pwjxsLbRFWOrmBUkZ6YRVNKK
	/neLNgj0nlMZ/zh6tIQJTIAahVwDOa4QXyHakouM/wDDvoe3zrR/NrafUIfOPmVkOrxMQh
	e3o0C9MMFt+6KLWyx1h/4ffccnFIFMI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gGKq/CIz";
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779446007; a=rsa-sha256;
	cv=none;
	b=7jLBF38OAeil50e+furlbSfsxp2ynoL1D769PXxwINRkoKAEVF39nwYuQjIkrE145SAJaQ
	QWvcbCLXv3ZXxJb5638XDN/1wb8PzjjzZx/bXNtZUIfLeUrpoJgyKfQt8Z0rfhSk6ZuPeM
	/RGWwsRoui8akrub3OEaxclbkqH/CIQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9696F44117;
	Fri, 22 May 2026 10:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4BF1F00A3E;
	Fri, 22 May 2026 10:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779446006;
	bh=fSAKcTCjHEBP0sQv4s+o1EWc5Ccjv9UlLr1FZ7wIvhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gGKq/CIzLxg1eVylTmSsaymkCWKTFGI+O2LCAQD66kFGHuWu7AEA0EJlsvNO0PnQE
	 +sihyb31rGdup1cSzTE35K5odHeZ3/eHCKeOYbV9EbYbbeLlKAny6B5p5VBmDYx2ES
	 GZXeOEgUZAcHnVcNK6M3SVEXt1noKuLnGw0nxC0MojK5TvXJhQ6WEjgAVizgmQLpcI
	 dDsCOpurTMS0gGQCbFYdDq9VDF2/E8KvK+CSXg9xD83/19DHSXkato+MRFH0E4vsWo
	 NTnvBgkTQDRwspvDgy289uUsENhabwbbni7Ifovw2ttOt/+5uVb0/kPNiwfTMRJHVs
	 dZpW2WP7j3/pw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3329CF4008C;
	Fri, 22 May 2026 06:33:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 22 May 2026 06:33:25 -0400
X-ME-Sender: <xms:9TAQanIenWH_ygrOQ6FUHBHioGIwigEJ1_bMwmlkf-_CugjQOnVFyQ>
    <xme:9TAQaoztDcO3aL7ONGNqejCZ6lxgiC2rO1Vx_hOXtziE-Jk9_NpyH4rGCI2sD7hjL
    fZ00HOxyCzB1bqTrz8L27ZkOuzsRdNMUxkEmlzM0tQFZxy688CnJQ>
X-ME-Received: <xmr:9TAQalSy4EwNoMaSIWOw-ZQF4JGjJASlv6y3tByrXHYXi52jPSyjgkhmOvBfPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeelleegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhn
    vghlrdhorhhgqeenucggtffrrghtthgvrhhnpeeuieejieffkeehfeffffdtkeelfeelhe
    fhfefhudehjeehvdffleeuvddufefgkeenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsoh
    hnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhn
    vghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeegiedpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtohepshhjsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpth
    htoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgv
    ughhrghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehg
    ohhoghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:9TAQakB5MJDyeRY_hnhhvRW8ddk9xhB6k169PMZOdmdBLzjNgzWUMA>
    <xmx:9TAQatdv31zZM0M2rGNw6Vf40Z5SRXpwAVIh8GYd_OyXyI_GhgRs6A>
    <xmx:9TAQasvkmJeWjrcPgrWoxeaHPZ0_znuDXuC3yuO7C7vruthndstmNQ>
    <xmx:9TAQavJa5JPR45FttlxYzQlQ3p6Hp2BDqXCthKi8GGTuTo5LyVCc4w>
    <xmx:9TAQao83YRq4gP8_a6IhIK19klW67QorxUepSbRdp0Q2PX13A3GyyW8a>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 06:33:23 -0400 (EDT)
Date: Fri, 22 May 2026 11:33:18 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org, ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 03/14] mm: rename uffd-wp PTE accessors to uffd
Message-ID: <ahAwiYBj3V8kV-Ez@thinkstation>
References: <dfda2f55e155b17535ea9fb8330d9fa9afe0c0e1.1778254670.git.kas@kernel.org>
 <20260514013127.148945-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514013127.148945-1-sj@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68EB420007
X-Rspam-User: 
X-Stat-Signature: prjxrx9g47p6wirwxmwqkzpot5676byr
X-HE-Tag: 1779446007-8173
X-HE-Meta: U2FsdGVkX19PD/I5bzAKVYvbnOQ3JwD8tHt7ZY0BRM2FE1JJjDJaKx3IcWKuWXaOSwYZjslXaK8udtTdkkWY1LqCaEbEjoeXzP4P7S9ICOAJ2ojk/SA6A+vi4njR64ZbwgE2zYtCRLf2hRxg20Gvihi5iTfgSqDFYlgov2j0KVai/iDskfujs5Ppd/MM9st6s/SgBouvViDzrpsIAotzq9JJ0uGOiP7o6AsHivfCWRX2QRDqJ1ZFtHpgp68UeykHrZqEhKdusSZelIBvQEqvdzzPz28i8jsMpyb7ZqezO9LzQ/CPBokDkR3FCN23NPMtgNzxK2pYkCspCimnnm1Q5Vb7COfQ7j67X99O3jIptgGKZJ+YApSLY2vwudXhmZR3vyI7A/6anpNfZjCAivtFLHn2Gxa7XjS/1qjnwE7bvzIYTWWVh1jHEE2aiWQL5jxzLoLzGpNYOwBYbi0Dzp6Fe4gOXPke1FFoRlW+6jmDKj3NX+xRvviJbKIBufRud+RV01ERVtUQdWDbojAeZPIFk1aAdA1+8MfjrQrTSvnSjh/ckLdRd7kWtsGJ5n53kAQ7wRH0AiG4etciAT5CykdxOeCh6DDOm671QARL8nv3Qppj0Anby5swbeno0tHQSHYaDB1BlKzav642kEK7r7F/JIhr3bZ2fOsofFF4eBL/dz/PMbGw33ide1M3Nrj2s9ssUDqpisVAWS/HY0Sq1fhPzwNonKql2Wv6xOL17CKwPuCuGxaSVQzHwT/nhZ/kNMyZjGu3aZZRt4vZzZp36DqV3VAd7ljqLmMLXngdOwwlTPgWiCkDYyhDmUVBlqkLU2Zno+afLYJIg0QDv6T3w49EtMNH7kQcg1qxed4+jdYqz2ikHB3WfIP6XTm3x8BrEvHhWuYviVB/sfE9tNcklNeokQBh6vu+GRvbe1RJfL8HbGKhrsXuIJhntEEXLk8OI9jAPlFIZHhNrw65RY/izDd
 LLFHwuWN
 NpRU8gCLiMFxwOTA4ifLr3PpGfc0Sok3oW/u61X8ROr9ulRn6XWq9LilULpYmzfUs+l8OgcUMpCBHGgjJGAgl+od8cbbQ9Cpb1F0Oey4XtNb1pKkaa4+Fc6cAO0eO2GdouWi7LRh8AEExI6WUAmYyiRMQo2r7KNI5XgOFdxnrzDwvEb3MvgGIUEI/MBhLhV5dn8bslOvbwbMHHAVJ7o7bbJDB9DxR1jcmpiHr29ut48y5pL75RmCy5pPCk19ThfroVk24ZEhlGu5fYc66lSl88HsVQtT3rMLuagKqQroURcC+gWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 06:31:27PM -0700, SeongJae Park wrote:
> On Fri,  8 May 2026 16:55:15 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:
> 
> > Userfaultfd RWP will reuse the uffd-wp PTE bit to mark access-tracking
> > PTEs, alongside the write-protected ones it already marks. The bit's
> > meaning now depends on the VMA flag (WP or RWP), not on its name.
> > 
> > Rename the kernel-internal names that describe the bit:
> > 
> >   - pte/pmd/huge_pte accessors (and swap variants)
> >   - pgtable_supports_uffd() capability query
> >   - SCAN_PTE_UFFD khugepaged enum
> > 
> > The ftrace string emitted by mm_khugepaged_scan_pmd for this enum is
> > kept as "pte_uffd_wp" so existing trace-based tooling keeps matching.
> > 
> > Pure mechanical rename -- no behavior change.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks!

> [...]
> > @@ -4934,10 +4934,10 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
> >  		softleaf = softleaf_from_pte(entry);
> >  		if (unlikely(softleaf_is_hwpoison(softleaf))) {
> >  			if (!userfaultfd_wp(dst_vma))
> > -				entry = huge_pte_clear_uffd_wp(entry);
> > +				entry = huge_pte_clear_uffd(entry);
> >  			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
> >  		} else if (unlikely(softleaf_is_migration(softleaf))) {
> > -			bool uffd_wp = pte_swp_uffd_wp(entry);
> > +			bool uffd_wp = pte_swp_uffd(entry);
> 
> Just curious.  Is the variable name intentionally kept to avoid unnecessary
> change?

No, I've missed this. Will fix.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

