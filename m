Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C3F109878D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3B86B0088; Fri, 20 Mar 2026 10:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BCD6B0095; Fri, 20 Mar 2026 10:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0533A6B00D4; Fri, 20 Mar 2026 10:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E758F6B0099
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:55:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9B2DB738B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:55:22 +0000 (UTC)
X-FDA: 84566739684.23.B8FDBF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id ABBBE14000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:55:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BVCcVgcK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774018520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qGwCJGEGWrGTjW8pf9/IIlX3yAZzjdHMWZu2HgvAeg=;
	b=jAxQxTrzmrHH54VZyPzpGzCfz58LtXVzL2FND3ynMRhDu3uWEwfLjhDHodOrMlEhWwOrZV
	56YBxb9HT6k2fP8ZHBcZNQJ97vPo6PNshhc4Fq+mQAY58wDsNHSZrQzJQVo93E38lMD9Mq
	r7ZgDyT9AIiwRtVpNNUsO6Y0fhBDIQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774018520; a=rsa-sha256;
	cv=none;
	b=Xeg5jsyz9bL5meWbzD/tacrW/fyzSFKAba169JWnUrcmDqx8jlwXPUfYAsar+4WFrVGXCE
	jTgplXuVUwpnCFT8dgqyJe9fYG9uoJCMJ4qZ5b5Ho6qJDFuKDO0X6ly52XdNpkmyVNTaqN
	Bh103tl8BKHvBsUbxe3D4Rd/xmd1tQc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BVCcVgcK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8728643FB6;
	Fri, 20 Mar 2026 14:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AF2C2BCAF;
	Fri, 20 Mar 2026 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774018519;
	bh=O3kRy3P5OtBeHmM5/xruXYwzutxlo/f+EkNqcRA/w5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BVCcVgcKt3ENBDOXfD/60Mu9JraNJ2WvkNnJPLDxcLpHQTLXDNARrOidqFmec0PJE
	 yVX1W72YSY4FPiVwzr/ZZLT3Ks7PMrYQsxJmPxQ9LKlgzKGFbt3Hut/RU5zMcJqMVa
	 vGjXkqa7OVHKziaQ17Ou0ly4kIsD2kZfQFTavyoIDQF6kFCYpWNz4WYlo7JUscgUzI
	 h1uDMO+B46JkBdUu2L43tNR6zmaqUThorJmcbIZrJgrMIakV+wwRzHzJjnqdz9Zd50
	 mzzi/amooHZh68eKX7aADaySN/4Gx0mAiN20/Xg7Lh95emwHaBAPvg5HhWlFVZ5i6A
	 I+9dUNjLZKG4Q==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6FEE1F4008C;
	Fri, 20 Mar 2026 10:55:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 20 Mar 2026 10:55:17 -0400
X-ME-Sender: <xms:1V-9aaSTVTLEJPaFtMfcA9OOQSLk6qtER_2mvgUbfF3fQpIbCDd91w>
    <xme:1V-9abdH345Wj_d1EkOyJYfZtrNL3QOR91X4KS2F-d0a3XE01QeuoYEtJHrRGFmio
    UlstYHdVto1xFUMavPzUq8FilejKFr1oa0HhRdqNVX2yayhuefTV98>
X-ME-Received: <xmr:1V-9aTfYn0Kud8Hgybz5tkAILzW6y7K-6lDlJViE8CHzIInCavWwUHWChV9qRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepjedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrdgrrhhifheslhhinhhugidruggvvhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphht
    thhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehrsehhvghvrd
    gttgdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopegrjhgusehl
    ihhnuhigrdhisghmrdgtohhm
X-ME-Proxy: <xmx:1V-9aSLYaO6kt-4n-RVsJqON1ip8AjtaH_Pt27AjXHKRrFN1Pvqa8w>
    <xmx:1V-9aZ0A4xGzllAxFHCPwmld6prMiihpMM3Y0RTtW3tR4Z5viCZseg>
    <xmx:1V-9aYoDjjXvmIC1gpUFWF1PXwx9w_DdKHu1fvkuetZfscplB_4rWQ>
    <xmx:1V-9aRo6hYvorNf3SXqjnpLn9K1cmaKVdAbWqEdB7skdA7USK4-Ypg>
    <xmx:1V-9afx9vU-5uv-9QmNxaLtg9yZTtGG520E3KGSXRr2754fS-0oCwACz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Mar 2026 10:55:16 -0400 (EDT)
Date: Fri, 20 Mar 2026 14:55:14 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com, 
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, wilts@infradead.org, ziy@nvidia.com, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE
 coalescing
Message-ID: <ab1fvJxFYQP-ByQG@thinkstation>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-4-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320140315.979307-4-usama.arif@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ABBBE14000A
X-Stat-Signature: sifcr3cxzi5whnpebdebcway3gznh5sx
X-Rspam-User: 
X-HE-Tag: 1774018520-134433
X-HE-Meta: U2FsdGVkX197P8xBaKHasgd+z2UX0iBDjQ+EDgChwyzuA72DTaBg2W6ohs8RQR0SbLcZfGn12UEmCDt9MwsUaaNtxNu5OS23McAf4NVkZk/CGxVJ5sZ5OIKna+k4winhs+0ox42eLscDrees8EojEVq1LjldTI6/hiFqTmgGgkde1lsn9wE6c2ydOsZ2aXwS7trj3Vh7/Rc/JTjZBwmrsLwzZO0v12inJJR1QhvZZvNhEn8dN0PP8Opj7wsvzHhghGz8o9MkGeM618xqZm7vwlMgANQ0E/gQwcazBplgHjjZrxtk7it9X13MHq/2Iqdkor+yBozvFASYsw8S+7q1ijsOM5ccfiZH0B4OHDRLhDkGikKRZfPrg58+6ABxF+3N9ReXdkt8MtsdSR3ilFuLJfx35s2D5D7WFAG+5gp9oV2PdYPvgGeCrM4skSkis3p4Eb4R3sKMeR6slDYKkPRNzZIlwDla9XlBSxJd+rR00mhmqsWh7YHvistq4597Dr4ZONmQ42Q+QA/U4frXDoCN0cNj/oR+mqpAt3YOsBuw3Ol2M5puqOYfPZDS+jMiNnQD4nl3Gj3sjVuMKqlFktFLZ7MvsOeVvaH6q6xPy2rTvH+Vxwx/T+IVnHbOQJwcdmjC6cwdc6fKkNYxlayRiLU5/iAXxO0tELyL5PbOydTr6na2paGChFo1oAaAsGGSD/QyAWLjxu7aFCjOYCEaNrrW0NzuO4gfYP8DWc2HypFfvSdLy0rNCQv8A2bk1ApYVQqUC4TT7UNZjNp2mdboaI42YSMS/xS1Z22KslnAsaujWTONZvakvl/e8uUKEUGdLlphg4deh6l0UsCEIKrPAIIkklCXV2h+fhwOWF59PQzbHaelwq6hppBdQUvgUpr3dE2P/zpF5LivkBhCEmHKIuWluChJPvQgqQUJqNtPfPBlgYQ20HY7YaOlVKjVYditWGOaus16vs3fcaG5/dYSLir
 CO/+7Exc
 Adw/3DPGGgDd6CrGNgd/eSTfEPYI/SsasQV5BH0TRgi4CLbZMjAeRQXryamFBzhrkhXgIhlG8QA4ZcP1MsxL4NSDNba4M7epp/06MleJx/9Pt9EgaiERQRe8mXNjRjCnNV7bwZcGqE5jGTbKgptSd81sjGLbWIMHUgSB4N0VFQ3R/XKaaxh/OOFrlCkhOUd+uksSLeU6Tl0szeRTZ3AK9vZrk9bAhsoMGcWNUmHBALpJ1fI0Sc7RLeTAkQv0ayj40YXN3tqWRF5Tp0lmQBKzcXSV8fvdLQtG75VdbBSAhvz/XRVe1CbgdU9L/yY9UpZDfDo/GfHyhKpZPGWkUCOYbZBWRf8HNtg5yjF1H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:58:53AM -0700, Usama Arif wrote:
> For PIE binaries (ET_DYN), the load address is randomized at PAGE_SIZE
> granularity via arch_mmap_rnd(). On arm64 with 64K base pages, this
> means the binary is 64K-aligned, but contpte mapping requires 2M
> (CONT_PTE_SIZE) alignment.
> 
> Without proper virtual address alignment, readahead patches that
> allocate 2M folios with 2M-aligned file offsets and physical addresses
> cannot benefit from contpte mapping, as the contpte fold check in
> contpte_set_ptes() requires the virtual address to be CONT_PTE_SIZE-
> aligned.
> 
> Fix this by extending maximum_alignment() to consider the maximum folio
> size supported by the page cache (via mapping_max_folio_size()). For
> each PT_LOAD segment, the alignment is bumped to the largest
> power-of-2 that fits within the segment size, capped by the max folio
> size the filesystem will allocate, if:
> 
>   - Both p_vaddr and p_offset are aligned to that size
>   - The segment is large enough (p_filesz >= size)
> 
> This ensures load_bias is folio-aligned so that file-offset-aligned
> folios map to properly aligned virtual addresses, enabling hardware PTE
> coalescing (e.g. arm64 contpte) and PMD mappings for large folios.
> 
> The segment size check avoids reducing ASLR entropy for small binaries
> that cannot benefit from large folio alignment.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

