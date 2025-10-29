Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A3ACCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:11:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16D28E005C; Wed, 29 Oct 2025 06:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDA08E0045; Wed, 29 Oct 2025 06:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9041E8E005C; Wed, 29 Oct 2025 06:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1F48E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:11:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FF3E13BC07
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:11:58 +0000 (UTC)
X-FDA: 84050735916.03.7E7CA03
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30D6620003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:11:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S VEKhXK";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=S0QENVzD;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQYcWk4qBSw8yxndIGua6DOrTN7MNNasIXpj5Zvlj0w=;
	b=5edXVFcFUFARkMZ8FrIhnrQOFQ143LwsXWeK8LOF3lKz68DplwpY9FvCabmdSUpWMBw/sn
	qOseH3IDP47cyHloW4c1byemIro62cnmLvTNyprAy9QTGx63O2mY80mn1Ps5XQMi90LR+V
	JA8sCtz3DlY9beaMhcNILWhnpKX7l/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732716; a=rsa-sha256;
	cv=none;
	b=LOaW38TuWzpkH7iMN5TqsFQj9o+P317/+hHPYo2xIh0nDHJsb27dzYuVtigIh6s8bx1OpK
	+qUTQkTPpgyarS/xmO4RB0NGcRolw2ajx2c9w1YKU5a3VpaCq5dE+PDRD1Wg2h4Na+qkJr
	L+hb0YdCxyjYv9e1U68M8rQalXwte68=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="S VEKhXK";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=S0QENVzD;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.phl.internal (Postfix) with ESMTP id 526F513800B6;
	Wed, 29 Oct 2025 06:11:55 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 29 Oct 2025 06:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761732715; x=
	1761739915; bh=fQYcWk4qBSw8yxndIGua6DOrTN7MNNasIXpj5Zvlj0w=; b=S
	VEKhXK5c6LFW9isXMw+HLLHAP6fSPEuZFJ1c3CuDm3IWRZdx7UKkUW/2FObd3aSk
	YkNpuSYlpc2WNrQmCIJ03rjhhbcpH4lJbki6NtbS/BoF4z35Rp/4aFJVkYqlvQu7
	Jy3BFlvmFd3hB3AvsX8ZoaVOldapGwq/9XmOEmQhmR/xufDWr/WPvRle1QbrrW9D
	8IHygUMPp7le4hCtUHX15CINnO9O+t/9z6qWF/Evvhw5U3V6r7JoNp68ivlh5LUB
	MV48ezb05xLuxC+Ck7qf68TvsdtUO0kQe83jylJeCPNSNoF7GjqEvkycghBkLapm
	fR9Qr3iOa56ZNaEHUFr2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761732715; x=1761739915; bh=fQYcWk4qBSw8yxndIGua6DOrTN7MNNasIXp
	j5Zvlj0w=; b=S0QENVzDgUwMR7eY+vAnD4RBq9DFaSM92Vg8JhvLEuj6DeqqNYc
	7mnMCc4IyICjre7ZZ9kNtnoj+NKcM0j5Hog1tNRB15pYqn3u+vrppe9NdDMpGCEQ
	fuwlsp6Yryqw8RfP76mDLmrn9tjroIGdqGrJ+MiGNGbFr/40rNiUlT/nMequlBSG
	e6h24I9HVNdvL+TPlvqOQilJo3x5LBmSfh/+wXjcaKYPDoUizF/armm6Mc1nrjAa
	yVw41Um/blekjsLf8+kvKPhPIKecSQs2r6pn+XKbfQSnOl4Fc6/FZvFYxduwrJ+j
	0bygpEqU5pWqer62mXdmLbbJmcxykvvQsmQ==
X-ME-Sender: <xms:aegBafANSD1fuUWZ0v6m-SiRyvr65VzyAKdfiMWLGtP0VmPM3aUE3g>
    <xme:aegBaemk5fKBmypcCcDr_uej9CFIvBJmgMau7nAq7et4vFpq4HUPR_mlJPaiqbUrU
    27XFo8cRFf6G5GfZvy3uXfXRkFrPcXSGrSEwuXdhzcq1PnH6URLkZA>
X-ME-Received: <xmr:aegBadijXcXUgXxwzcVCpdvPt1gY0u4MuMOAaodUAlinen_6vi2YnOfXOkGe-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieefgeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhhughhhugesghhoohhglhgvrd
    gtohhmpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    rghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:aegBae3i4OeX1v2tI89vH399VXsdDV4ad3VFAvjh1eYo6IhVuJ8pvw>
    <xmx:aegBaRQSx0cI4StlFMzzFiLYEPM3MmBLWl9Kz8bTrO18w5d_hDqlXg>
    <xmx:aegBaQYUEJm8bRLRcx1bxvxxkk81Fcw6tKwt7xZU7v5ZKMdcKxdjig>
    <xmx:aegBae6fNX0u1VrBUg_3J7s8MRXF_9-lZoqlxYCd3SE8XStTjnTzag>
    <xmx:a-gBaaeyvRdca66Ug_Q7G96lsSxaWl3YMxVQ5Z-ctmWd91aznQJ0s0eS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Oct 2025 06:11:53 -0400 (EDT)
Date: Wed, 29 Oct 2025 10:11:50 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <xtsartutnbe7uiyloqrus3b6ja7ik2xbop7sulrnbdyzxweyaj@4ow5jd2eq6z2>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <96102837-402d-c671-1b29-527f2b5361bf@google.com>
 <8fc01e1d-11b4-4f92-be43-ea21a06fcef1@redhat.com>
 <9646894c-01ef-90b9-0c55-4bdfe3aabffd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9646894c-01ef-90b9-0c55-4bdfe3aabffd@google.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: kgth4m78dhs39exkayakes1oum31b9dy
X-Rspam-User: 
X-Rspamd-Queue-Id: 30D6620003
X-HE-Tag: 1761732715-283269
X-HE-Meta: U2FsdGVkX1863VH5UAsf0N6B0ITRFVEIe7oKcL+K9MEzDceFEyLjWBdiPJ5+dVtb04MKDkKfQZdTIws9HzHp/OJDOUlNDWJgOcgw2/VBcWQJyQ6YftQUoQxvmsI9VNtA1RXHfxUz6Hg60WIci211LW2k8ILhyLK9+NMrkR6+4Pwl3fS/A8Kf/sLugF/KJmo5pBVDA+DMxLYQCIrxaM0IGo2z7+br3ulI//fVsptvVoRrlsXE66aWYhqnfrMH8j1YOJWTdOlS73e/PtCj749Abc05VEa2IrMhOnyTvDRAu1rfFFqklycZlZcZTAAJtN8UlidJeA1CAKeovErSEWUEridZ6Z4/oN46r1aoW7IRtXSESEWHoMoZr6b9XD4Kb95stwAewNfuWoTHG1FkI1G1XG5bTPsX7ozuDPkM74GnihA9f1CA1M4XsrWlVC4jqV6lKez7xKEbxjzN1WWfZ5FOa3tuXMeozu04tAoCnXBk+1/vb4/NAq+U3Nd9kv1bpCjF+n7xPSvc6FBwwiVl+6JKzivu+blos6mC022U9uomQgCEndB0T8SJdx+g1FPSRj22sqmPmla5Kvu2KqrsfqCxqJlFLhLu0/d+sHJPtKeYOnssMCLUwi1qABWEF//G9Q3JaDyWlf2fTLfOOWjdN9JreH6Vy2oMamSa8qXceeCOaYJZ/IjkzEsyoi96K7dSpsfpBWjHMyaSrACMytt2Swp9aTThyil/U6JvPpkFdZfHja3yoHS8yLOFqVi4MAzXzuuFRyt/6jOFKYQU8gd4Om2n3hyTtbczyqdD5HspQSuaESPjav3bk+ueTVtVB3RPhIMn8aVFEUuxmuJ5slQXd/hylvbR41TiPeIyV5ho6jzoVOo+nz7emt477RjEJKSdVELG8IE+94A35WeXE+sV02qEAk2uwY4mWrjhLGzC+cwnYK1n9qbeZ2BIW4s5F8XUdD+3vCX+MnkAm2HKULRSjSS
 G+qZBAEF
 xmgfQgrxfLgSjW8Rvb/SkbdJuebNM8Vksb1c1bBoVrYZPfWrrhmqHJ3/sX/Zgg/i1Ej8wY6bxJ4sI09SV6Fp6ICw703jN6UPE4sXdJzyIPDF2uRk/VrCZRG6kWw8/JOyCN/q0uxQfyzGGxLvN4Dw/i6eK+U+kUZedcBlUNwfPnAKJEwnqBZJmblhxtnv+AXJRuBS5bGuqiQK6j+GZYuJ+7ctCcOHLr1jI554HIXmMCVRe3IdF/oCkkZS7e1lkKbQd3RJOgvFtIONKVzUsqzE34cU4lQoBAxMTJyGZjlKdj2YfP0bRL01wEEUsUHt2xjULhrJgNHXPbaF4OgIrlenfSW2Zc0aDB17BCp28DxZLyHrjSeBV9Qe/Nns4N4TQtY05it/P4w7cbfC1/dncf1sJJMDcqU464z9SFYwk1yoC1SRt2UoRxPxExG3x7aCvn2dEyawAK1bVo9J6TVhdji6diIJwpC3KNwZ0JOPW6C//C+nAjRg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 01:31:45AM -0700, Hugh Dickins wrote:
> On Mon, 27 Oct 2025, David Hildenbrand wrote:
> ...
> > 
> > Just so we are on the same page: this is not about which folio sizes we
> > allocate (like what Baolin fixed) but what/how much to map.
> > 
> > I guess this patch here would imply the following changes
> > 
> > 1) A file with a size that is not PMD aligned will have the last (unaligned
> > part) not mapped by PMDs.
> > 
> > 2) Once growing a file, the previously-last-part would not be mapped by PMDs.
> 
> Yes, the v2 patch was so, and the v3 patch fixes it.
> 
> khugepaged might have fixed it up later on, I suppose.
> 
> Hmm, does hpage_collapse_scan_file() or collapse_pte_mapped_thp()
> want a modification, to prevent reinserting a PMD after a failed
> non-shmem truncation folio_split?  And collapse_file() after a
> successful non-shmem truncation folio_split?

I operated from an assumption that file collapse is still lazy as I
wrote it back it the days and doesn't install PMDs. It *seems* to be
true for khugepaged, but not MADV_COLLAPSE.

Hm...

> Conversely, shouldn't MADV_COLLAPSE be happy to give you a PMD
> if the map size permits, even when spanning EOF?

Filesystem folks say allowing the folio to be mapped beyond
round_up(i_size, PAGE_SIZE) is a correctness issue, not only POSIX
violation.

I consider dropping 'install_pmd' from collapse_pte_mapped_thp() so the
fault path is source of truth of whether PMD can be installed or not.

Objections?

> > Of course, we would have only mapped the last part of the file by PMDs if the
> > VMA would have been large enough in the first place. I'm curious, is that
> > something that is commonly done by applications with shmem files (map beyond
> > eof)?
> 
> Setting aside the very common case of mapping a fraction of PAGE_SIZE
> beyond EOF...
> 
> I do not know whether it's common to map a >= PAGE_SIZE fraction of
> HPAGE_PMD_SIZE beyond EOF, but it has often been sensible to do so.
> For example, imagine (using x86_64 numbers) a 4MiB map of a 3MiB
> file on huge tmpfs, requiring two TLB entries for the whole file.

I am all for ignoring POSIX here. But I am in minority.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

