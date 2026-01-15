Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5913D46603
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595006B0092; Thu, 15 Jan 2026 12:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BE96B0093; Thu, 15 Jan 2026 12:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478636B0095; Thu, 15 Jan 2026 12:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32DF06B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:23:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA88A13AE32
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:23:35 +0000 (UTC)
X-FDA: 84334869990.08.E873815
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9B1A9A0029
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:23:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QTKAoUZr;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768497813; a=rsa-sha256;
	cv=none;
	b=yWbO7GyFtjwjo2XorcsQMDbysyRcFFxGkIDE3dMqAD9rYZWtQVGitAMm2f22I4V1P171Bf
	Bc5x8gLdZec4DPNgcOlVSF1g0Ixl9bH01T99NUJ7jNQoAWom+021QVmzxksmvNFXA6fVMT
	Kw3ZPYF0kOnT/UtOdnUVyoAwG3FpzQk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QTKAoUZr;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768497813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJi26COYsj3INz4WytrnMe9ckU51cZL6sHMyGDJv2m0=;
	b=h2yShqfOq0ic0ydUtpt4WF04++xJtN4O6AcOe/28mof9/9jwwA3PS/7lTbvg+8O5rMFifp
	LElsDjkptLvjFSya/+WQurO0NIXwJlTOAlwZr7enPtWt8hxKJ6GwL+cFZOc/bj+wpUPFcO
	GY2X/c+XHkTjGuIiTsQ+M1OA+2XkDts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AA1E40030;
	Thu, 15 Jan 2026 17:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7AAC116D0;
	Thu, 15 Jan 2026 17:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768497812;
	bh=mNdqCNiv3YpkIfV+LBX1fZkrX1vRUP6RN453FsHaaLM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QTKAoUZrRJTFIUXC+qBThBUef1tfw6+caWhlQmOrJlq1y4Y59B3nRrdC4p8tbfznr
	 +zYDahECxJh6XLBQSjVQ5lK/Z+FUz0gmdZkSMK/jz9ByXSdTbeLqklfkHPSsuONOh8
	 0XC9uGGQNYkaBkMOk3bvdCOyMoMq7Sbn7Xggxu6SWJo0jJL5gdubSTNSVl3FeAvd0Q
	 QbcwB9UlxNYDoc0nqWaFjEobZ6M5xk+8Jkoxcu42Tq7j5ZT4nW8Cocavj/DD10gBjr
	 FALpdF9Edq5DGhAecQFzJT85k44erYcpDGKLqAnhim68UNPehkJVIW1N7dS5gSpMfl
	 8HWEpAJ/us2CA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 10D2FF40068;
	Thu, 15 Jan 2026 12:23:31 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 15 Jan 2026 12:23:31 -0500
X-ME-Sender: <xms:kyJpaQlmKR4zWD4yNkrPq64SA1xp7c-4NlCNztIXOAjPV7sUrJ7Mjw>
    <xme:kyJpabOm1wWiz3SP3UTlIMK8kFwcfca9opGoMojNNhIPcB9nknMvO6v56vjI57Vqh
    ks4GebSZ_BvDU_GFRvVA3Wyt5ALqWrj26WiHljIomzmAKx92kpD-FU>
X-ME-Received: <xmr:kyJpaYDSS1BWvW1HxFQLWONhcViWOVpUksiuG9v7CDzYzZvvBw_4EEnlsRswcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeiieehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinh
    hugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhn
    gheslhhinhhugidruggvvhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:kyJpaUXo0tCYhkX-oXD9KdOoJ7QqO_gqdcH0YL3zhRO8DU-lpdGRRg>
    <xmx:kyJpaabOv2GsX6wd9z_1oGf6UIPxMc3CFAB5a0LyU8aw66SWH7z5wg>
    <xmx:kyJpaaJKwQUXAogKqTYlQcK5mC24RWiEp-psBYSnLcKywz3bBvD4Cw>
    <xmx:kyJpaUgd1C3TR_3mnUHIvuGoa2y3I4abzU23Etdz-tWDHpd4FGrO6Q>
    <xmx:kyJpaVSCY1dGwv-wWPPWaU8Dg923g_coG7UvpT854GH_qjzGmXCDuwHy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 12:23:28 -0500 (EST)
Date: Thu, 15 Jan 2026 17:23:23 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
Message-ID: <aWkhbWR-3fWjeTaE@thinkstation>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
X-Stat-Signature: m3xfzksbnxnco5yc8dikmtzkhoj7oxkj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9B1A9A0029
X-Rspam-User: 
X-HE-Tag: 1768497813-44745
X-HE-Meta: U2FsdGVkX1/xlm7xFghKoPwM1uwO51yZS23eyop78ON0jVVVblBiDAbxLA/+5z66eWmKWTXIYt5qcigdPIlopZWMC41qeTZB2Qm8pGwyEVbqtxmVIk93t+E24x7j57wY5FLXvG1EkUE9TwSY6Xw9kYnmY/VsDIjbyUCGLE6Q8uQdnCeaZQvCL6Gh/5FqDuMwKzOjL+dE5xO9FJYlHhOIG9VjUe8SNbjlHlJqJ3dH+RVaStPamkvWfxlDAmwUivR+dCFg5XAnQmmmxZKefs3Tii/mNgEnAM6yYe7lLAVF6f/nNJkhtHkAsC+omRyVuFPNwYtJ2dvmT81HxkGxPZqE9Id/sZ0zhSsEazzp2XSLczQRKu4mEBRU5BGDhlECut6FeGgyD4oQw94KqsruO3OPuZ09QPKlcEQXz7wYNrdIo6ZKIZOoaDcMl0A192uhp5I+/H/RUtMt+Jt70K1FZz3rHlnXLStszMGyHAwXHH9uNfluKXSoE3MwLz3t5vdEbX2XgK+aBLtyXP56njLPrxTB8WhDvsEKGgc6urJqxtoJySShot31xV6n0wqks8pNtwt8WwphxdUICKZUvC1iu1NjliME2+ld08Ye+1Yb925oLRzSu8yjsUWF83B4e0RnhQBfPQYUdCTYupQXlOtwAqjF5AOYjNiAvOf/C6hoBxz2vpabLBtfRG2sQiuHPckuXIEz9E4SKuniUVds9PFbn6R1ledU+GNJXrED7MAKiWcslkzP5+Y+gVT3wlXaFi/AgQ10YYxRte4mKzK2qpAp4U2alPAABqtm9xKMZJiraSbHUFTJkB46vihdAn3o85DQzTyQOZdkcXxCUgBnO6qtzppoZqz4U/gBlh/AaajSCAaCxeycmijLrC1AbG0jpFpNi6LOZ9TV7j4McEXXApRPPv23ZDAW/UYxcwbnT9jXILLncljw6yrDEmEThhjhyUkWfKZV7vDp3CTi63f1CetPKpC
 lXan1EZn
 he4raqeNWmQoUPZW5FnPLWEfwjZOBELQvoIQZnxYFrDVRscT16kZuk7yld2LwhZOco8su2J8dB4K1MBC8y84gmiLXG7qlTNNwZ+ek+0BqkvFlSEduv1K9eXGOvfvnmq57V8O0bNfkhPfxE7hCHt5sHsjJgCJdERQjF0dZKek07G3+Y7j0qywsx34Oe5DW/ByU8AZe93aJ03jkxtQO4QuLbjGxTuergO+pmElIekCeydf8vzQehri7k4j5SHVcswgYFv/GfeDEK84enCCqy1pfnmNJSlEXPGYeARt0nw0RO2z++as=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 15:45, Kiryl Shutsemau wrote:
> > HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> > vmemmap pages for huge pages and remapping the freed range to a single
> > page containing the struct page metadata.
> > 
> > With the new mask-based compound_info encoding (for power-of-2 struct
> > page sizes), all tail pages of the same order are now identical
> > regardless of which compound page they belong to. This means the tail
> > pages can be truly shared without fake heads.
> > 
> > Allocate a single page of initialized tail struct pages per NUMA node
> > per order in the vmemmap_tails[] array in pglist_data. All huge pages
> > of that order on the node share this tail page, mapped read-only into
> > their vmemmap. The head page remains unique per huge page.
> > 
> > This eliminates fake heads while maintaining the same memory savings,
> > and simplifies compound_head() by removing fake head detection.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >   include/linux/mmzone.h | 16 ++++++++++++++-
> >   mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
> >   mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
> >   3 files changed, 93 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 322ed4c42cfc..2ee3eb610291 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -82,7 +82,11 @@
> >    * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
> >    * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
> >    */
> > -#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
> > +#ifdef CONFIG_64BIT
> > +#define MAX_FOLIO_ORDER		(34 - PAGE_SHIFT)
> > +#else
> > +#define MAX_FOLIO_ORDER		(30 - PAGE_SHIFT)
> > +#endif
> 
> Where do these magic values stem from, and how do they related to the
> comment above that clearly spells out 16G vs. 1G ?

This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL << 30
is 1G. Subtract PAGE_SHIFT to get the order.

The change allows the value to be used to define NR_VMEMMAP_TAILS which
is used specify size of vmemmap_tails array.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

