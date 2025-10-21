Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021C9CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405888E0019; Tue, 21 Oct 2025 08:28:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD278E0002; Tue, 21 Oct 2025 08:28:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3648E0019; Tue, 21 Oct 2025 08:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7C58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:28:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD70958773
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:28:31 +0000 (UTC)
X-FDA: 84022049622.15.63FE13D
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE81180007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:28:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N kdawpG";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="vfABFsS/";
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761049710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwJV6k7KAy5PyI+RrheQP6UoFSX5NksO95Gumi0SSf4=;
	b=SEZ24CA3xkKvGDoAO0FmF+PDhUmg/NKg3h4LGU6vow4xr7voR1Lh19fu+agTb0TQEbzjZa
	j4Zz9rbxdpAcemQULWaplQmJh/25DFMmo/Uj7mgfKT261eHapKZIQFhmztUOoT1qkJ41Nm
	lyMe9ujTqLNOzeaoIXjUuBM3Sq+qyII=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="N kdawpG";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="vfABFsS/";
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761049710; a=rsa-sha256;
	cv=none;
	b=pZvrLVNRRvMrz/opzEMh1SHlbrlBt0LQkT4heBd7kPVfEhmMoQmNDJbEAVyOF7c2OKq369
	YDRme/Lr7JCs0iR69pwTHN6qRcGbMXhmEtN2lwyRbVoQEizOVnhKn6oeoAo7sQp8t2xGO1
	76sf9Oim2mtwUKLkLF5z3+lN2Tomuog=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 3A3D71300A45;
	Tue, 21 Oct 2025 08:28:28 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 21 Oct 2025 08:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761049708; x=
	1761056908; bh=VwJV6k7KAy5PyI+RrheQP6UoFSX5NksO95Gumi0SSf4=; b=N
	kdawpGarW9mlGtlWvGFIharRVGnVhfcQVPTqQN6DxNcGoah6JyH45a5+dBj2Cozm
	dX3EUU7ZQ3qgzNtH94TnFQxGavpK1YxP1T7UsS3ffMfZplynyGEkT0LGpFmIlvQ+
	hyZG1xlkDru8fGi/YgsAbbHFuWwxAcAqKCZcLbKLwE+y/PQtmbpFSI0seGqiabY4
	RMYp63IfYvGyoSF8B1dR2vDm6JgJrdB5B0iW2erf0bs7anLmO70l9BplG2QJGNnj
	Zq0whnamzEVGgfQJjlXLYowOwWHBgRXjSrBeuhWNU/z5CaJ7AJyX+lMVA9o/BXXd
	vYtGKtuJq6nUg1DNgeYyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761049708; x=1761056908; bh=VwJV6k7KAy5PyI+RrheQP6UoFSX5NksO95G
	umi0SSf4=; b=vfABFsS/HHAWcMErFRnvQF5oA5FLojAadKCcRRDx3VQPw1YdmAW
	TXhvAVC+NvRFevUPeV0aPnW65ohgmqaBjkO3BCfqlJYytS4rlSTKRx1zisjU6q9d
	X5bINWQUDvDugE/emiCU1+kHd40jMReBb6cgXOjg0AVzsRcYYA/pc/sRysWuTk0b
	c5NXvLN+lNU6GAhc8vrpcwq2b6VO5U8sHhxkammKbHWkoQB0ZfIZLm1OLyTt+vfl
	QuJsQl6t+Uts71FLaIJ8We5R/dV7jWdcTR5DTuLFpcsTnGBhrmVX956Iq/x4AY7V
	uVl0e1KW1QApkbCahMVEuuoQXAue14mvuhA==
X-ME-Sender: <xms:a3z3aGN0srF7acnD0h97O8_3FXDVwcuaDB_cUCLUqnW69AHOfhoqcw>
    <xme:a3z3aBIsdQVGY50Ppx6nKnLD-8d7p1zEQiWpN35nRXsClcu8CRhkX6X8MJio3yn0h
    t_M6rQhj3ZQiBbnHHJOmeQFkLGaFG2q_kSo-G1iPRv_SqxjGp__m2ta>
X-ME-Received: <xmr:a3z3aEZW5Nla8tBAIu5ZyDfXtmBmVTJAwlCeZz4sB74fmbfmbeHk5LzigdbItg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugedtieelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:a3z3aCQCzxYNVjBVDx8Z2rH2suuu5qxBLjs7h9T3g7fBT3ZCXKLQbw>
    <xmx:a3z3aPzgs8QGIGF0VdO9pJZKtSIr4lv-BNedlzmZF03OYzzIMbbmRA>
    <xmx:a3z3aAcJxn58t_mVWYCY-9Y23U1h-AT52j7CEPF1gTJ7sE8Re7Gqpg>
    <xmx:a3z3aNlUz-dat0UHVi5BADrS-vP-M9UjR9-NiCS28tiCkwpEBsQ9Nw>
    <xmx:bHz3aImgp9TZtPbdaxirqYGnhMuVOwvujC0eW9ojJNvpy3H2VX6x218o>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 08:28:26 -0400 (EDT)
Date: Tue, 21 Oct 2025 13:28:24 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/memory: Do not populate page table entries beyond
 i_size.
Message-ID: <esiue5bbvksdlopvt4wvzs24cvhh45xtf2jfyhqxi44w2r5f65@xw2ufks6rjdt>
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <8379d8cb-aec5-44f7-a5f0-2356b8aaaf00@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8379d8cb-aec5-44f7-a5f0-2356b8aaaf00@redhat.com>
X-Rspamd-Queue-Id: EE81180007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cw3dfb7casdq7mrk55d45d6p7wxwn6d1
X-HE-Tag: 1761049709-882999
X-HE-Meta: U2FsdGVkX18W3U5SKCYMrdnhiS7/KJwpEDa1OC6V2hDXPswhZ7ANiDd4KpdvJ+J1kQDuRWGdIlMthMgBm8887sMko5lTOTX492BGMOrlODLEYMV3Lyk660BZywzTklTCn++6aRXwW6F+qe2eWVWvVApn56EYZsf8fVjpjyRW/gtXkGPZVLoHHibvUg+tnO1kjP/isvjy6HitK6dIoT1qOzdC+obm2wB7T+YvNfp5kZbWnjG+OrxyGVjYiCN7zjRW2446LJn6BF21M43VZUHClQS2lUViMnh7lYvVmQnha3dxouzRR01GFOjHUCZL6RYOoH9mYjBnDQoc2/B2MO2WW1Q1XuCLFwa5OUDFhu0RYw4VB5z837ztPpMLtjxABkEBQkWwmh2IaW8XOOvdOiPOsf/jQkabEqhdMJBlyDdnaHpn6GH0yJ9GmdedWbSCR/CJAcfiO+NJPCXrz0UdP6dnWLU5C3AQpDzvfzRkbX9XFWLc0ZrjToRQVtVIaAxDZhp5mOhd1NK4IuTuOfFOuHEfAi1nMKbOekadSMXYh+fFiP+2tFHttSBAJWis7StpWSea+VD1Oklwln/Wt96OLzM64ehyG31czc4Fc1Bkp7Vo9jQx1mFstIlwwH9Ji5MEnunw2fzKTtMBu5Qx9l4+/uh+9weKYsGdollMsRdErzWqMnZnGq+uogk6ZxS0fyq8BfI1XuQ1PlzTR4nrGXYDMUSJFKx3/KG2A7W6FcHHEFpLlje09Hh7QMxhK/qRIXSwbezmgMxt1S0s8S6B/BvibDNl5HizfUByj45X8fOCb8CBowlp2TqN/BjZQq8xTW1TALArYAC2YqnwLxxAE7u32Bs+b8pk0khOE3PcPxGGiew1dnGJztOdtSeRHvzVDhDusxaYubQ9/9dU+Gbkm5q0BTvTue7KnWRAOqq8wH1NfQO+mKJI3wkaOM3rQkGcfawWqgjQpl4p8Z0fNj5T/bpPbws
 Kz/EEO2H
 QsLEnl3W0dQzwHIfyXbhl3/BQqZSt6uzIoMBJBaJEBz3e6ndzlAveV009Ia88EzxUqsDDt+GnJqOOMNu1oXHA5uq7cVkAW2aATy7/u9u9Bxyi6JAxJgvKiPFdD4SiSM/sxt6D4ncPiJM+ThXo+c/JmtYblnbGz2BwLAu7fD+vMpKt1QGqWhn7jEreoaBeOy46tHBtURWTwLe8q3o6GF3locb0RBM3sdpK6UyqZh+AlJpD8lS4mi7lNQ7VYqPkXqmxMVjovH63u9kllvc1/Z72Ni6MCWpeJ6leJ5Jv3d7SiGsH/KFbcvR7r3L0hOXv06bdtMjOMY9EMgHNqO3Ad3YSNFjExKPGOTd1T+39UuT1anUdRr9qWLKlW8ySFlljC54mpPBq7WS/yvnEcMSegENoKrY3NFpISSzG8OZQSSvN8H957uXXvlB162I/bUy/cA0RftKVlgEkiQ3fElzH+LS7E+JS7jFIDAgZBdB38i0szCH7ZTSiKm2o52IVqPzqZRhicAFRCc3I92d6LqU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:08:44PM +0200, David Hildenbrand wrote:
> On 21.10.25 08:35, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> 
> Subject: I'd drop the trailing "."

Ack.

> > 
> > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > supposed to generate SIGBUS.
> > 
> > Recent changes attempted to fault in full folio where possible. They did
> > not respect i_size, which led to populating PTEs beyond i_size and
> > breaking SIGBUS semantics.
> > 
> > Darrick reported generic/749 breakage because of this.
> > 
> > However, the problem existed before the recent changes. With huge=always
> > tmpfs, any write to a file leads to PMD-size allocation. Following the
> > fault-in of the folio will install PMD mapping regardless of i_size.
> 
> Right, there are some legacy oddities with shmem in that area (e.g.,
> "within_size" vs. "always" THP allocation control).
> 
> Let me CC Hugh: the behavior for shmem seems to date back to 2016.

Yes, it is my huge tmpfs implementation that introduced this.

And Hugh is on CC.

> > 
> > Fix filemap_map_pages() and finish_fault() to not install:
> >    - PTEs beyond i_size;
> >    - PMD mappings across i_size;
> 
> Makes sense to me.
> 
> 
> [...]
> 
> > +++ b/mm/memory.c
> > @@ -5480,6 +5480,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
> >   	int type, nr_pages;
> >   	unsigned long addr;
> >   	bool needs_fallback = false;
> > +	pgoff_t file_end = -1UL;
> >   fallback:
> >   	addr = vmf->address;
> > @@ -5501,8 +5502,14 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
> >   			return ret;
> >   	}
> > +	if (vma->vm_file) {
> > +		struct inode *inode = vma->vm_file->f_mapping->host;
> 
> empty line pleae

Ack.

> 
> > +		file_end = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> > +	}
> > +
> >   	if (pmd_none(*vmf->pmd)) {
> > -		if (folio_test_pmd_mappable(folio)) {
> > +		if (folio_test_pmd_mappable(folio) &&
> > +		    file_end >= folio_next_index(folio)) {
> >   			ret = do_set_pmd(vmf, folio, page);
> >   			if (ret != VM_FAULT_FALLBACK)
> >   				return ret;
> > @@ -5533,7 +5540,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
> >   		if (unlikely(vma_off < idx ||
> >   			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
> >   			    pte_off < idx ||
> > -			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
> > +			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE ||
> 
> While at it you could fix the double space before the ">".

Okay.


> > +			    file_end < folio_next_index(folio))) {
> >   			nr_pages = 1;
> >   		} else {
> >   			/* Now we can set mappings for the whole large folio. */
> 
> Nothing else jumped at me.
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

