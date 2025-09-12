Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D8B2CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901268E000D; Fri, 12 Sep 2025 13:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3188E0007; Fri, 12 Sep 2025 13:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A11C8E000D; Fri, 12 Sep 2025 13:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 679888E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:44:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2017BC0782
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:44:50 +0000 (UTC)
X-FDA: 83881323540.03.18219FB
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C4D41C000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:44:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C lQV0HT";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=im51tb+C;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757699088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbXOseeNnaP83dMYePU0k6b7ZDIfNAE/7Jdsl7Ac4sk=;
	b=mjJXMBu7zpRBztiAU2TbFnQg0g2kCboT8+IaYQ9VAPK/nseoImfHdV3fOgNmA6l0hXsznS
	hEenv4LqtjkpMA0sFYXZi3VRj5amP6H4eVCBUG4FFg2MF2nOU2w9P/2bQcLMpHORrfgY4J
	m5r/SH8KjgPxP0ahptTZqC9s369wU64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757699088; a=rsa-sha256;
	cv=none;
	b=d7a3inzpHFUtXFYnhgz1C+ps9wvFqnqEpfBMPiK45r1nTnqyYKivX1yP6vcibOr5x4k5Bo
	OqFdMvLTfH17cdFamkbWYzHdcl3EBkTf72+qxrTgXBHbS1F3/xjtxDZoCeHy3xYUbTXwCe
	v7GzsJ1n+G+U19FZM/UFBK/y3WFHCBE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C lQV0HT";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=im51tb+C;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id B77937A014C;
	Fri, 12 Sep 2025 13:44:46 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 12 Sep 2025 13:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1757699086; x=
	1757785486; bh=UbXOseeNnaP83dMYePU0k6b7ZDIfNAE/7Jdsl7Ac4sk=; b=C
	lQV0HTId9nSrky+AZyRVP6KYEATXi3LI2X3MH1EKxhekzxJptQPKhSRwtr0nFi0D
	qEqgqtXj9mKLK1L+i0QAajauX/Ee0j/OQeVlnnIuoU/D/g9iR27vQOkBnUVceFBq
	/fW5nZCXO/yEL7wCN1jNkkQUkiChOyUgqgE8Man/Pj49Y9wkX8Mn/uy9pumaHknp
	GGtLlzoEcfR0XZ/4cQAiO0HMxC5IQQzkvcrgL8THEFXpfS0g7u9+VYb3vNxMOopv
	zpLK8opf+6sAS7H58t97ncAqDZyyIn97GBjNjFE2X96H4+1nxhoEHXYb+Ia8ssyt
	lJXJ3CyGFn5IudSqqQVrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757699086; x=1757785486; bh=UbXOseeNnaP83dMYePU0k6b7ZDIfNAE/7Jd
	sl7Ac4sk=; b=im51tb+Cxc9Wf3P9QHBTtqrLu4rPtozC6R2oFl+yniN2rBzHA1N
	sERVMcZv6I+ZvcgjX3uo3M2RxUZKvck4epBQ1ESR8jLG98+0hmZe8kMnO9iGp+gj
	VrQlEthRCh2jQ9vzDZCYp10JbwFjB2p4G6lescKIMpMy45VFSa+gptcc+58g3Cvv
	5WAcgLAR/AYqgv3+PIlR4kKLJp+uON8BWBvm8AymfEiFGNA2txXh1mfyvYMPmf2s
	jYRW3t2y6vLDEdxSlqi+HyehpCIPUC74lkiFJxzv9rB2qEqb4zOwPCzO1MhtqBe8
	rKuc+chegJ9jJ9A/vmXvpbG/NteWp3JXaGQ==
X-ME-Sender: <xms:DVzEaDlSoyTdClnPKHNq_iKBQHeosJ1uFtNg-5H8GgHyp4xlIJ_v8A>
    <xme:DVzEaCt4stj4bo245syo5toimrJAm8oWqoe8zTcuPqMz2Uk4dKk0o_mYjPzxXE9Ig
    PiY6OCeX3dQwa4OSP8>
X-ME-Received: <xmr:DVzEaCfdcx_95HunODtaZRKSeQ5hWu94jJE370DO-LEmJGSDj5nJQ4eKSH7IjA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleeikecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtg
    homhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
    pdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohepsggrohhlihhn
    rdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtthhopehlihgrmh
    drhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehr
    vgguhhgrthdrtghomhdprhgtphhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtg
    homhdprhgtphhtthhopeguvghvrdhjrghinhesrghrmhdrtghomh
X-ME-Proxy: <xmx:DVzEaEaGwv2OwHz4xSZo8qNskgJ435vmbHuXJZd7RhbxWdL6yuCjEA>
    <xmx:DVzEaK0hR0wItz6tDK741-KZNaADkjRugK7IrzvSaJVnWvPQiOOEaQ>
    <xmx:DVzEaNrq98OX_y_swKPEMos7hZTf3KQfNq3T8PcOoMjxt0PQPJdNIA>
    <xmx:DVzEaLwJKRMt6gJyMlHTa0s3AK9A3JfBYscahY6m9rRIJdNZYIxEvg>
    <xmx:DlzEaB45ZF3zCnnB4Ev4Y8vQA_MjYTBHMcj6KSUxfR1hVLJJ5LCXBqO3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 13:44:45 -0400 (EDT)
Date: Fri, 12 Sep 2025 18:44:43 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
Message-ID: <5n3vzdmdmeyicqf5dji2vo5hsfupigq7nl44cog7vwm6nchtqo@so5mvct4fwhn>
References: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
 <36bf71ea-f6aa-42fa-9fa2-53d00f351777@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36bf71ea-f6aa-42fa-9fa2-53d00f351777@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2C4D41C000D
X-Stat-Signature: ffa4ii86z6irgu5wrbatz8bd11xcse6t
X-Rspam-User: 
X-HE-Tag: 1757699088-266162
X-HE-Meta: U2FsdGVkX1/Y7fbjum5dl1sMvooq7BpSSLlLRBnWjdUXtjNCndT8IPRBCcKPZKXGVOgDZcZM/mOIC6WF7hXU2bJVJv3Sq7PqPv7qaXCYQPlnzgj/6enR/0hou4Y+w+kRfqdUYLaTaVSm9gJC3Dc6EyftEeWcXBjktixFnIF7arKJgDrQQ7KeyjF6XmV7Q/JHetuJfxjRkEljIEa61/AhPy1AyGImDK6j5g4kLiQn/irjXq6TvvW5Fv7BN6LRl5zBz43/WpOB7m5+RugpjF4RqpSkZCUsYOWjhaag9PRAwAxzhhAcLXm3vgXCe/mZwIjVVEFkvN251BamFGIhgM0Y47CBdWMqDWV0ERE5ZQb527rIPwWXCXs/kCnVC/TbXxcTPuOmF6qf3+XXBRzJWKNev5T9/52E9q2A1HAYcUDf7Snv1XHLbkx3byl7zjIOJQbOaf/ROED6RcJzNI0xVlGjO4eKIIsO/mNuAE8XnO7mkZsyNAxkF9dCSbvfhbs5cdwqz6yYHdEJ0lyPNTcIIrcNFgEdx8zA5gOzh64Wjiv4MdM1skNQqVGppdEW4luqqhEz/wuBJ7/yb5m9MpO0huzD+PfcAxm2g5ZMwyil8sH4P+ffexka94LUdqMwqfpUNNcMg4Y+nNvYdrTSGZFf9kwmwu3oZzBQmOraOh8Fw2+9phsxjbiBTGB5OQntD8LXAIrEBe1JuSjHGk0j4w5oE4QDr4YMBrfkJuaMQDGZIc+Zd8xuur87FvJ6LDY49LCd1PRCxEwZbJaM29BS+W31RKucPRxJfF/diBGh63ho4XKYQzhWmJ3BU7MpLq3Zu1pnhvoCCOL/Aw4j6i25vlgfh2fFPRhByaoDpshxJXOiNg3huhqunzk1XPN/xwPb1ccjRjabKLNYw1+hAjQqMoEOTY/LqHAapql5V9eDVXKCxsAcUYS7OHYsx+zAlxXjanSWzGV8GpgRFFuqGhm7zNpJj5X
 snWSyk/6
 Fhc7gjmLK2du6c4ds3AtnXMCl2vTcpGOZKDgdg7HunzQ0FlZYTwqG3D/BHQadViTrorg9nWv61xuS9CMMJBuAg4RXgx2EbBHxpVogTGhGr8eoshoIbDlsqyVvFYBwng2YWyMp4rVhRW+2cIA6NOx0ruTEY+ZTg2HTjazu4i0OTI+VSa3wsSTaToe+L3xsXARGMYGDKNCNppUtU2FZqjuH8JErDfFsqY1yqSgGK3EROX4r4ptGz1ulW/3mkR1MJ2wso5JDRF11J4HjJvMkHwrcxXXdsrXJKEkPtp1YiBJ4ni8hy5ZFhlTDBDQEehdcU3gZFTCiyWgogU/jiWHytaslg96D12UWllqJvwflntxsR2LtqAmXbILCRz88McTQuINgq3okF7QFPUNarqbk4shBlZ5Rnl1TFbVuC5QENHDvdq6CfUF/lNPG/07zrSg7puwBMRRbOBaDG/Pr32QxVolkuZnVva1rpsR5p25BGZ5xv1DTZf4e6TuTxNGW9EzHEp8nSQPA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 07:13:48PM +0200, David Hildenbrand wrote:
> On 12.09.25 18:58, Kiryl Shutsemau wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> > PMD page table is installed or not.
> > 
> > Consider following example:
> > 
> > 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> > 		 MAP_SHARED, fd, 0);
> > 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
> > 
> > fd is a populated tmpfs file.
> > 
> > The result depends on the address that the kernel returns on mmap().
> > If it is located in an existing PMD table, the madvise() will succeed.
> > However, if the table does not exist, it will fail with -EINVAL.
> > 
> > This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> > a page table is missing, which causes collapse_pte_mapped_thp() to fail.
> > 
> > SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> > collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> > tables as needed.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> 
> Makes sense to me.
> 
> Is this something we want a Fixes: or even Cc: stable for?

I am not sure if it is stable@ matter.

I believe it is there from the start:

Fixes: 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse")

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

