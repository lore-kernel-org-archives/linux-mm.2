Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97EF1098797
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14DFF6B00D4; Fri, 20 Mar 2026 11:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEB36B00D8; Fri, 20 Mar 2026 11:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FE96B00DC; Fri, 20 Mar 2026 11:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD2E96B00D4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:06:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86C24B7B27
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:06:10 +0000 (UTC)
X-FDA: 84566766900.25.295F55A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 722D7140016
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:06:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mvpIdq/9";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774019168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysbNj8lFw8IfnnCT5+m33HcLxVUrxAw+EMUT91iRs7Q=;
	b=S0X3Dl/Yl9v2lYuyLa3RmOjNtWBPX/0i4tkdqw3Iul0KCFQ9Kf781/Cs9Rt2jp3aw72u2o
	u8EPa1hoLYMBb6rm+YuSfgiBGVFoI7KuoPEa3YgPeUWiDg8TlsdZ24GsXRgkkbP2Vf5OgG
	xLWCpvd+qPnJaiskwPj9Smr4zKcKNCU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mvpIdq/9";
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774019168; a=rsa-sha256;
	cv=none;
	b=hRGV9XOC/38wF5i+nWNxQvnKsTMdBbQW38hvnGUNYUdCEUFllI9l1WADYE4Oos+pBOizQN
	nvaFPHh/Y+rgg+ThEhGVi1X7UddN+jETdMiufD63m1szLY9hLuYZo49U60/oG6Y8TcrUp+
	/IciZBJrsntsgYO6f3NY46AHSt+zCg4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E65C56185E;
	Fri, 20 Mar 2026 15:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE725C4AF09;
	Fri, 20 Mar 2026 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774019167;
	bh=a5V6KVj/p5ln89F2tRrdVmVw8oemreTmSe3BZkx0iwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mvpIdq/9d72DivkgvVtymQHXH7jVuQuYKi3+LQHQ0f58tkUJ728fEqgRkKtSJZoaN
	 pbFtnOrAxJ13dAXGYHacB7GiWq/px7693hwN8squYYUeIxksnEMb2cQRWnyaBSSDAs
	 N3nR1vFYOOw53CMX9KGCjVkVS7tmkdKy/w1SjtNibjIDdexgi4vYDL8QvZT+6WWD7Y
	 nPIxAOAO/qfHwUNAe16FCr7yOJHR4cgua67djnjnxCltxrKPlawhJIrcceYIc6/NMK
	 69I+FE4vf7u/FEX4iR3I6J/6gTnnfOkzzEw1+ndDtVN8galvJvxQkL4Z3vdTlfZV3X
	 g8h9ZDpMBnBAw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id AC0A5F4008E;
	Fri, 20 Mar 2026 11:06:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 20 Mar 2026 11:06:05 -0400
X-ME-Sender: <xms:XWK9aTGlply8P2WXI5gm8LsWpf-879owa-bTH6wLNhi64OO78QpseQ>
    <xme:XWK9aRNwzVEYWSPIrFLkSRWV1eYcxOPkaFglgErNL5Hq1VEWEFSkArU0LVf868x5l
    v5oz_JiyfRBHk1IPGxcrKeOWlHNSYuB1Dwxt0xsL8LWC_0vOhkpqMQ>
X-ME-Received: <xmr:XWK9aZV1NiWo7gWZ2mD2LbYCd5FQZmE6XFW1_gLdhU1H1QTOkpiSmTitptlNNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefuddtvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepjedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehushgrmhgrrdgrrhhifheslhhinhhugidruggvvhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphht
    thhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehrsehhvghvrd
    gttgdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopegrjhgusehl
    ihhnuhigrdhisghmrdgtohhm
X-ME-Proxy: <xmx:XWK9aT5phdrM6ht8yfHkhZBNhAzK9KUFu6FOhax-DnoPBFUcjC6aww>
    <xmx:XWK9adn8Y_lXfNumOHQpTIL9_rLsQujlxGnsQghmxrGCBuJ9VIGMhw>
    <xmx:XWK9aXS6uRaLVti6KPA7cuKQ0pbnBlVtwgXLXnkyeRO89ddfZs_IBA>
    <xmx:XWK9aRAPA0NVurwyZxYFvL52QXGXbxBnomFHt93naPmm37U8CWTLlg>
    <xmx:XWK9aQxPNsDm5BWvL-57J_trms6Vcwlrv9Y7bSLdb8vohBx3nERv2mlo>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 20 Mar 2026 11:06:04 -0400 (EDT)
Date: Fri, 20 Mar 2026 15:06:03 +0000
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
	Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 4/4] mm: align file-backed mmap to max folio order in
 thp_get_unmapped_area
Message-ID: <ab1gW5tR6LhX0fQ0@thinkstation>
References: <20260320140315.979307-1-usama.arif@linux.dev>
 <20260320140315.979307-5-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320140315.979307-5-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 722D7140016
X-Stat-Signature: 4ujz1ddmwmkrqroj76mnzoa6tnzi8ju7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774019168-299585
X-HE-Meta: U2FsdGVkX1/FUGQmiL5OeV7K04Ndf0gCX0X3VWz4f9s8Kk/xXywhiEnbaCuxzwioisWA3xlJbUlWAUvT9UiarlkbN+8Zrdfsua5UPevfLTlvFm7VPc+N5Sz86zmtER3klxuYqOgGcElYBYvr1YVCs1B/Yku5hikqTpwuUDJBf7baLOumnFiPmWOjm3xz/he5RuxQz3fL2emehjGxzjVA/XLAt0LgdG5ly76Aa6czPdoRIot3tVPHCKnJC8/cGVd++j4Ux/H4ZgFwhU7PtWPe9NEKrt9cqFe7xjQgBE531kmBvkKSzsZ26LUVgizL9LaNCTeGwxAx3Tae2vDUoeaPP7sU+PPNGroGFy1SdnGB8Od0ZRsd4kGRlCAzth3XTPd3QvZUDjaxfJ1z3Jxy53FHTm62CXGzN+sihv5I0kV0bMTjLosW6AVNcNnt3amb9ZQOu3/isPs7a6bisvaCwYDYUUx3FpiQ/PoWBl/aupOJ8FqMimDaaEJ3WtZt5/ck6L4hz8XZypNJPIOdBupMOeOJFMj4o6ucVjUN+EFaE8uNQqwWMaLdYAHGls1A+DuXVhvlaNr4qQIxklamDP2O6SiEEdl6AuDi/eJSMczhgQa0fk50Q2gKOB89on4dWC+3Uajhr2iIvlrdaxXH8gyjVsbigZLyqEfVIMGltzKOyd6qzbNgu4flWk5CjYaeYe7SX8/m91doMN0Qq5AWyrUMlRx2q6o5G2uqqPCXrUJZrXanS94Asf+p1RErOZlmPa9tSbF1craZsz+G9SlOMzDDgvuRNoSCZTdDo43Ti+dTYHdsjMOTZ6EarkPqQ6iHtQyeF7RYXnVsuY59AH1290E1+spPMqhXSEds+Lz2C7XGPI5WXaGI9PQkhW6Eauxxp/mFsGTpz7xyF5easgrPJ58Lqdbt8oHyEOne/FKQ2lW958t3kSUVTkrgKjzov3ikC+HnzTXiVScCiDZYW1Ay6mu2fGp
 2QVGik6k
 aE/rshLu92r2rm9bKNkPw5GQ6Ld9PNkSCp5fS9tgl2jkeuPsH1yudCsvfxcEkjVoy8SqT3Mvqqv1KKuNNMEoVpUf8Mldq8uQRpZ6IO64ZtQBaAVzJE+le8Mcfaj8Wcg4MD4pGpFSOknqOVWlxRaa1WYDL7bh7yC0nN6i94E9oKFaQQC83fjHqCbRu86Di6OVjgmVWQsj7n6ZGqWzejfUgKwndH7uL0X7a62sUenykIRoSrrsClhhgG1o6U3eyWF6lENip9PFqz1+KYs38+4V7Tpz6l7iWJc7b4DPctvky2K+bskas3mCcNeQPN/VsO8soGFvyNZzqrqNxsNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 06:58:54AM -0700, Usama Arif wrote:
> thp_get_unmapped_area() is the get_unmapped_area callback for
> filesystems like ext4, xfs, and btrfs. It attempts to align the virtual
> address for PMD_SIZE THP mappings, but on arm64 with 64K base pages
> PMD_SIZE is 512M, which is too large for typical shared library mappings,
> so the alignment always fails and falls back to PAGE_SIZE.
> 
> This means shared libraries loaded by ld.so via mmap() get 64K-aligned
> virtual addresses, preventing contpte mapping even when 2M folios are
> allocated with properly aligned file offsets and physical addresses.
> 
> Add a fallback in thp_get_unmapped_area_vmflags() that uses the
> filesystem's mapping_max_folio_size() to determine alignment, capped to
> the mapping length via rounddown_pow_of_two(len). This aligns mappings
> to the largest folio the page cache will actually allocate, without
> over-aligning small mappings.
> 
> The fallback is naturally a no-op for filesystems that don't support
> large folios and skips the retry when the alignment would equal PMD_SIZE
> (already attempted above).
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74adf..4005084c9c65b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1242,6 +1242,20 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>  	if (ret)
>  		return ret;
>  
> +	if (filp && filp->f_mapping) {
> +		unsigned long max_folio_size =
> +			mapping_max_folio_size(filp->f_mapping);
> +		unsigned long size = rounddown_pow_of_two(len);
> +
> +		size = min(size, max_folio_size);
> +		if (size > PAGE_SIZE && size != PMD_SIZE) {
> +			ret = __thp_get_unmapped_area(filp, addr, len, off,
> +						      flags, size, vm_flags);

Have you considered to integrate inside __thp_get_unmapped_area?

Like, start with PMD_SIZE alignment, then lower to
mapping_max_folio_size if needed and then lower further based on mapping
size.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

