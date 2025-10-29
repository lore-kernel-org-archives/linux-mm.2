Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910EFCCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11E78E0061; Wed, 29 Oct 2025 06:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3038E0045; Wed, 29 Oct 2025 06:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1ED8E0061; Wed, 29 Oct 2025 06:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4E298E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:23:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D0DC49E46
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:23:12 +0000 (UTC)
X-FDA: 84050764224.13.014B36E
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8AF2F100009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:23:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q vtZDDQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eEIX6CxS;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761733390; a=rsa-sha256;
	cv=none;
	b=AmPf3tRhVr/nNkO4DS+PAWzDAyWGONTOdsrIPVHD8v4Yq5thB4jV/GsAoiPstBkNS0ZMPF
	wDQS8je9nfl+YpaOONzrFJx1KZHXEQqoOwi4gr9xdayfOP3YZJBM68FaAL6ulZGHvUqdwf
	8VSEKhYf9SgKkeeqdiVimHOCteLMH14=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Q vtZDDQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eEIX6CxS;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761733390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FDSli0Ph+bdYBu+TscfPXcdJYFYx/LYMRlry+8ZbcE=;
	b=upuoXSijd5cuMPDX+Ugmkg9C8x3c+HBjjxv+d4ygYdPomYWaTuZbIzCI967UwOFhMVHvma
	bxFr0+t2KdR8KWwdf3g7d8jAgtDjGE46P3BE0/ePmjXwFUJic2TtaF1ObRhTQ7fHKsXnBS
	t2GBZ7Y7Jl/Dz2Hk/Uh1T5J5WdadCqY=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id EE62313800EC;
	Wed, 29 Oct 2025 06:23:09 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 29 Oct 2025 06:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761733389; x=
	1761740589; bh=+FDSli0Ph+bdYBu+TscfPXcdJYFYx/LYMRlry+8ZbcE=; b=Q
	vtZDDQW9pEdBAuAXgxnvLXFet8BhgvMj64eAfEieZJsGSKfdggXQ7Lu8rUVMZ9ED
	xxh8p3vftnb1d+RKtJ00wNKNNQ0uxcodP8zZjkA1FuoOJZ0M3rL1HOQ/oiO21WBX
	ORLwZuW8xKFdHsXX0nj/jYSMyGICCpPIkYYJW/lNSdzMvQB7BLQ8YOSLQVV8I0jl
	HOxp+ZhIXHdEFparR6fH9KHl0dCRSM+KLFA9dC2OUFEgeXLENp1dO1tBnKFc78+n
	XKGy8zr5F5VF00EkYSl8KqApFNKvO3iPZIaJAIXPhQp8L0K4AZoSYCLxk/TXrJ7y
	3GTTFfONQZloJiUj33tmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761733389; x=1761740589; bh=+FDSli0Ph+bdYBu+TscfPXcdJYFYx/LYMRl
	ry+8ZbcE=; b=eEIX6CxSlpYir8DMLvaYZs9klDBDvzZvWOTeqamZTjxt84uch//
	Sigb37GvtiqfVsapAg630PZZtxhnFR9ePvo18FrUeCdqf+dKxiH/+kCHYFcvxxjD
	oOiUTNdsFZHex8hu+ik65LxyAmayASorUBnvDC/iEA4kazibr9TKIsSGcqu/EAlz
	gqkf+1GrCeLQnBFk86AEy08TU3a63O4eB9bWl62b/Sii27aTiF2fpiCLRvuGg3VE
	w6tVBKSwtCFqIEeT5eVlq9v6yVBMEh+phG5KqFbMw1+iB2EexD70HeINaPDhpGqI
	onMpfg4RIRdsl1MltbyIVF9aUjUS4sVchrg==
X-ME-Sender: <xms:DesBafCIr96SHdLVEP-ppkZ3zTrNQkKQKZ_xZNORbigQMXDEqOk3pg>
    <xme:DesBadMEptUA5BbMaWv_gNgntmKBdjc7ZIjQHe3-4yKcLOqMwRzJfVzMDKz_SqpO5
    kKVJp9Xb293Aviz96fkaNq_rVnG3d-lomT6aBpjPHBGH1ZYVBLGGYA>
X-ME-Received: <xmr:DesBacyvN--A9IoQ57sFmqxDSjn4H-0uH_c6qjNoY1cw_qGlb4Z7_amF8iwGMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieefgeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhhughhhugesghhoohhglhgvrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:DesBaQenYKO6Awlcf2f2OqlDhXwNlTwpYzafHsuzytn6ICrcPt-i-g>
    <xmx:DesBaX3RSp8lRmYJbORMxetuIv3d2yE2gpXvSv-IIGHRthCf5-Wgrg>
    <xmx:DesBaZk1Jcbo1zuURKahglAfAx4dFiFC6ySlby_1BDGjODtKhSMWrw>
    <xmx:DesBaeoiWzHVKzLEnt3Da9gb5QZDUceAejk8QwX9E27L_5PJs24VPg>
    <xmx:DesBaZs429W1TDgPTtOCx6BEsoyjQs5VmQv18QKCZj6li8Y3JSHbml6->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Oct 2025 06:23:08 -0400 (EDT)
Date: Wed, 29 Oct 2025 10:23:06 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <l264zv6qfnvzhfdiwe3nzjydqz7w4t3ddumntopdq6qmyx4ktk@svdhieca6abe>
References: <20251027115636.82382-1-kirill@shutemov.name>
 <20251027115636.82382-2-kirill@shutemov.name>
 <20251027153323.5eb2d97a791112f730e74a21@linux-foundation.org>
 <hw5hjbmt65aefgfz5cqsodpduvlkc6fmlbmwemvoknuehhgml2@orbho2mz52sv>
 <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e2750bf-7945-cc71-b9b3-632f03d89a55@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8AF2F100009
X-Stat-Signature: kem65u76i77bd3kwxq7k4x5o5obmwjei
X-HE-Tag: 1761733390-83701
X-HE-Meta: U2FsdGVkX1+HWlpCFz552cWNaNP7Uuv21X545bXP7rASuTSITO8uwtldc+LykmbadVpQ7r6FEIa0a/gZVyFiyFAiathwZR4QV5I/8F0oVvayE5D0gf8f4lvq5rxWDwPBH4FlzD7VDH2aFSUFfKcUTc49GNq5EjFLOvafXXnli2iLFTVdP9gWfARHAx7uB/0Q4C+aqAU+Kzp7yLjfySUQQ4GvcQbMf6EF98NGDpYuEZDPENbjuEEqsVCPqqnIPY1MRAM7K9/q9R4UzZ09FUPeS8nhbCeDSg2yoD9Wmbjh38529KGtKzAlAffwbXTat79YnQftMlddroGL60ZFh8Hi9J+lEETUx5zsUaJ4CUUDsuZR53F2SBinDNVINtJLsr/WIZTd6aYk5yKsg7ntnuz3Q6FOmVI6fpqKw4Up7NVb7J66cKns7PtxzFeQumgSXuxIzb3BElgskKwjtob8lDF3b6eWj4bRMSTTu12SNwZN/Jrjfn1kOVM8R14JUPeJfe2wOXsoU7U3uxFndj/19iVI2dkWmtiLPg/+TphpjsL5lMSSbBWmsV/XN5DhGsbfdclNpK09ocy+cmonXPI6k8hoZMYjyIPWYrBn+o81aSrqWc9y5cGRDH0ho9F+MpD9rTiO+tgaQ+TcrUhj8kz0tWSqCEenMPRtHdqe9i9pbeM6yAH9g8jwl3WGlHy/S1s/KKm/QJrOAVFYq9IhA/HONm55RK6WYa3zbSOBTZLh5JZDbChzY/HoQA62nBa2jDJiHICDe3yrsFV8gon76kCndtaMs3n6AqrkoRfYI/BczT89mkYAQoubWc0Ap4sfs4cYkua3pmO7sDdFQB6GDpcUbFV5YO7cVkfG2l9iQcgTazKBHubAjCdXNK3b1mCRUtMSGQ2o2EMucgKX+LoRc8Hz9E/uEMQkCqEhRIeB5obS/17lFGy1o1aj0COSI/2dboSWGyXNIL4zo0HroyErfuLZQlv
 hb8iT1tV
 AtWel4xA868q3jJPgrOBEK4ZKFFjJBK1I+giJVD5ELZ0OjuLjkOVkLkQAacg/d1U1eg34MmKzXPOxthWCY/eJcPzvjA8b+gght8lrNxozDr54zXaVoUG6PwJSQw7JSnjytoLu+i1AFBpZ8RD0FsS8bxsLZERvMBQDGBcaIZ7ZEzw1Gn3WubwE+eVGtL3cJ60tCluQ+//dFLKbEX6Czppq4RsDqWgFukQOZ2pAylPVCysUQVMX1aXARLqR5xttP7Fh1dMFD+n2L3mXRFVG23Ev8ZxJVzrMVaF7RNOlpie/3Rd/EU6lKGWgBEngNQPHtpsRcKiKjOlYlgeQMFyFhD5zj6DQDImCF63OsZj4HVCTqI+ThhX1nlyUbv2ayC0HqM5O/8ecg/KAYCAcuaBc8I67QV3w3MG0yfjVwgx2ZhvTPPjThLk8CCfIOVqCXVWjkQGJYPUElCF5qZ0S6MVWtlI5AgsdV/lozKvkIviqhryk0WvWDRE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 02:45:52AM -0700, Hugh Dickins wrote:
> On Tue, 28 Oct 2025, Kiryl Shutsemau wrote:
> > 
> > > Also, is [2/2] to be backported?  The changelog makes it sound that way,
> > > but no Fixes: was identified?
> > 
> > Looking at split-on-truncate history, looks like this is the right
> > commit to point to:
> > 
> > Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
> 
> I agree that's the right Fixee for 2/2: the one which introduced
> splitting a large folio to non-shmem filesystems in 5.17.
> 
> But you're giving yourself too hard a time of backporting with your
> 5.10 Fixee 01c70267053d for 1/2: the only filesystem which set the
> flag then was tmpfs, which you're now excepting.  The flag got
> renamed later (in 5.16) and then in 5.17 at last there was another
> filesystem to set it.  So, this 1/2 would be
> 
> Fixes: 6795801366da ("xfs: Support large folios")

Good point.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

