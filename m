Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFF1CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C559A8E006A; Fri, 24 Oct 2025 05:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05A08E0042; Fri, 24 Oct 2025 05:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACD728E006A; Fri, 24 Oct 2025 05:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96CBA8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:26:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CF9313C3A7
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:26:12 +0000 (UTC)
X-FDA: 84032476584.12.5058CBD
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2A183C0005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:26:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i aabcnQ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=t3ftFPHs;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761297970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vOP5u5uit3cxUkfpkAHqHBhu7MvgqmCIDH3vZUkkWg=;
	b=5Ztaqm4F4XAhDQ57pGCgc0JxCuvanOKqMxAlH6ISu6ca6oKbEK1JALTCR4tXQojMz/R52U
	1Dh3I7Pzwzt72LLy5cG8fC95AyxtuQQkk2ApVtZJjAbr0oZP5m8stiwqXXZoxYtN7ldGPm
	I0oDiGmKU6ENcR7X0MAFcGw8e7Xr/Ro=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="i aabcnQ";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=t3ftFPHs;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761297970; a=rsa-sha256;
	cv=none;
	b=ArfWbFT+KduRzW4RF12/nN8v2pnu2VCH33XMMLJ7xTXC/Owvb55PbDHtH22xT4l9GkiIaK
	NtJ2hzEeslZgg+fnYUesNfWTNXvzOptKegkNNwmN7wNynKO1dPZmtmU9iWvgxKnhsUfsoP
	x+EzWr3FJrUJqZUjUl1r1ownp7FL2l8=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailflow.phl.internal (Postfix) with ESMTP id 8B730138021D;
	Fri, 24 Oct 2025 05:26:09 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Fri, 24 Oct 2025 05:26:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761297969; x=
	1761305169; bh=6vOP5u5uit3cxUkfpkAHqHBhu7MvgqmCIDH3vZUkkWg=; b=i
	aabcnQIduiFQ5ipLXI3sYTNqwj3QuA17NBDTDq1fIME6SB9RwYdbHrrV8OwW9Los
	O6lha55gjhXnpb5eCDrGKkyinUYaHKzN8iyO2oJdA5VsdbbLwPTXF+KaNhsa5HXt
	W7fHbXInNyT3a/9m3uXJIozft8IoQI0jQ65+d9PL74KPieqQu0QUPE0/wUFiqeBE
	7iMj8AvML4V2XZXHHXN6oSxbpCuTuH4YCHxfWxxFCzvgPhjyZYDu0nAnulvx0x1j
	G45MLfhl/6FzMdyVJtXuohWsEQrHvaDIPR3cbYpOGPopDdQcp1vwQNQMpMi38S/n
	A9G6tLNlvosmy7XMjM9sQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761297969; x=1761305169; bh=6vOP5u5uit3cxUkfpkAHqHBhu7MvgqmCIDH
	3vZUkkWg=; b=t3ftFPHsQgOvgRoRYDMEV8j0Q2wDfdHCUdwMjoQGpoLSabmEXRI
	pg99abZAk5VB1xRJjFVJIfMgX4KUIUEEpSfkr6/SJ5AjhwnaB6e6gDyGXFTYA0+q
	BoqoUX2cDAACoaCsgWTm/eybdsJYfUHSfJNTR46qSaKN/pKQHZ6qgUECoQ5nxV09
	XN7fSWty1WZzkw9ILYo+4D3EpJRnX1xphb6IwHieXO7j2kbhciqz6yFYHJTq57A4
	mnlFVfvtvTPj8BZ9UzES61wz5xcvA1ngARNHcAKdk1DFsqJOOvJf+6DNNGdb7NTL
	zz5Rq/nq8xuoQnp+C8crw8vWURp4GUQVCTg==
X-ME-Sender: <xms:MEb7aKdZJSgZ29MHvsigNS1bPIyFFST-MmkpfrqhrCgodsPdMmrgIQ>
    <xme:MEb7aNRL2UNzZA7Mo3KYepn8bRHYT5FADopl3wnbPRb-mUeRtCAlQzf5pDkKAXRxm
    4K-91pOoMMr7g3W_tZtc23FQ5drWCpzaQOsPSvejcOz4AeAhBcsHHy8>
X-ME-Received: <xmr:MEb7aOfXts_XD94bsCrA1Fb57JewCvoNJVa1P7X5TOrDLcKJQ19xhiwQWRpWng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeekleekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfoh
    hunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:MEb7aFCHdXRnXcHGjsRb842voZlMR7r8VLeZTiyu6Zwj0d1v31cjZg>
    <xmx:MEb7aDsCBhTTLvsrYgBSE047YfKVcvwZaZ3HwwV9jpp3G8KYxhmOPw>
    <xmx:MEb7aKFek1HdkRpUYzR7i4P6mo9kjt_kk0zltpGlnVpwAgfdBs2-jA>
    <xmx:MEb7aO2lBzM7RtgplMKnX5AS8rVgBdW4JrcthpKWMGX-iRcIAo-vpA>
    <xmx:MUb7aE-sgGrAILrrvqrM5ksHsNJ6VKG7Z3ffY1qxlijRyMG1p8k3BxRm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Oct 2025 05:26:07 -0400 (EDT)
Date: Fri, 24 Oct 2025 10:26:05 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <xhpgje5pb5sxi5frjvje73v7oatablynl7ksyjnbrglwh5qx7h@fforsl3cwbl6>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <20251023134929.b72ab75a8c132a17ae68a582@linux-foundation.org>
 <3ad31422-81c7-47f2-ae3e-e6bc1df402ee@redhat.com>
 <20251023143624.1732f958020254baff0a4bee@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023143624.1732f958020254baff0a4bee@linux-foundation.org>
X-Stat-Signature: hi3qoahfzk3h3zukb9gmr6y95yy8txp6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A183C0005
X-HE-Tag: 1761297969-488851
X-HE-Meta: U2FsdGVkX19q26dXSdR35iUiWMVnSf/4GnbfRJD7BcxadxAZGG5/WhGmHjPA9VzUVydcZN2gjB8TfOmoc1cCO0eHt4Wp1vnJAenvbK0//3vG+kXRVoo6Q4riPCqnxIC2jXd5PDsPX1uPzyFcOE4lzNwGwLctHrPt0o40eBB7WNxFb7MoeOy99GvyFPhjam2P9z+MSUjFtI8YZn9OdyEG4JpfEgoeDv82KpYOelnrNbh+qrnnArg3b66HIN1BaKRQq6j2CS0nYzNLca/VL+ZqLwsk2+9HN6A4FtUtFKH0IHIXnF2xmgp5VvjBzZKqyMyIG3x0ntA6DPVMsknYVvFLD+mQ6yW67OHVekz11hTEKsphJmlnU/fjEo1FWXoE1ubIHZ2Xg78UiBeWFFEqBnm33C2Pm5xb4CVWv8oyarB3LjzpwBK0MsFTs6mLYN96s0bXkSK3FrerULHAFb9PHGzjNCh2StHS+6ho5abUlD9xGKWxwvCBSnXybG7mE5uL2nFjGlf38bWGAudHeVzKCkrfPZvpAA8md6F3uM6Yzi0M0socxekkzrMlrFN2TQ0gbL+CPfa8tOJsmwLHVcqgOzWdnZAm0uPmXO/JMFYIVCghpJTgo9aUESABVA/exMd4kHe8nImSJ+kNOLPoq9tLztmWTcGclOXzSz0F4pmdkOptoIzbdA5+/DlDFr8sTSUW9addUl1d55zbmnZ+76Fio4k/SNG8IfWAamZnRRvwYgOwo51ey7QnA7edVYgYWkKGODAPRZ312mot+ElVJV5jtk7Nn7vcMoW56OJ2rc1a7O+W5S9VxWJeLjm6c9ZC+bq9VRJEVlpM2Mq6ncw8ZDzTYGAUhCxhV6+BBm+LS7u4xkH3yEOYE0TArK84nqJ0Ae6ejzHna1yEdnhh1sVggnEOSB5EBF6mBqMUqQAZPVKkvjgRuBqh6WHHgTneXwTl7FIFz3s3IxmcFZXsD5kK1FGIWGj
 L9k7KaTI
 H8ulNLWUwXEmk6IJhpgYBrSLMa7g2lGzOi+gHTSeNg2vDqLm0zfG/uLyly3D5tKOTXcJlwCgQQTfuJ5onIfE4NSmgZ8Tv08FYsTv42daJuqvcmUO8bNmMpwf7om2JWkvyBjWrDm6LgN5XEPGMHBm3gsSZGo7ccJmM2dtnhip8iUofL7yhA2+lFy+lJpqfz+6mlQlY5usICWeGP/TNPVRUEp+H/1WQB1xF6pCJ3c1CZ2HkJ0gioCre65JUp5WbX+U9YFa7znNF21yFHoEyuz2n1slmv7kh4beVg8yUqH+UWASAvRfUmXKKREkKSFDbkyYf33ZTi5FFYLsJea+UpSsBU8KO5VoOQfPcXnP5XIQ/wPzhAL60ZDHLFzNoqAhWVo2o3xtPClkdFN8x5QzJCzwwxZOALiDCTlw58Cmeon49OLzd+jFipaqloE4oTdJTnS3S/hfoOE0yu0rVuC2T9B5+aKTwS632O+PM5o3B6pXlWSjwQ8CcXR879WkztS/93Nu6CuHObAx3MujJWG3D1BScM5eci6keNLHfkBOb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 02:36:24PM -0700, Andrew Morton wrote:
> On Thu, 23 Oct 2025 22:54:49 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
> > >> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> > > 
> > > Sep 28 2025
> > > 
> > >> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> > > 
> > > Sep 28 2025
> > > 
> > >> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> > > 
> > > Jul 26 2016
> > > 
> > > eek, what's this one doing here?  Are we asking -stable maintainers
> > > to backport this patch into nine years worth of kernels?
> > > 
> > > I'll remove this Fixes: line for now...
> > 
> > Ehm, why?
> 
> Because the Sep 28 2025 Fixes: totally fooled me and because this
> doesn't apply to 6.17, let alone to 6.ancient.
> 
> > It sure is a fix for that. We can indicate to which stable 
> > versions we want to have ti backported.
> > 
> > And yes, it might be all stable kernels.
> 
> No probs, thanks for clarifying.  I'll restore the
> 
> 	Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> 	Cc; <stable@vger.kernel.org>
> 
> and shall let others sort out the backporting issues.

One possible way to relax backporting requirements is only to backport
to kernels where we can have writable file mapping to filesystem with a
backing storage (non-shmem).

Maybe

Fixes: 01c70267053d ("fs: add a filesystem flag for THPs")

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

