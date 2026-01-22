Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F9CC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687346B0151; Thu, 22 Jan 2026 06:29:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6341E6B0153; Thu, 22 Jan 2026 06:29:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536AA6B0154; Thu, 22 Jan 2026 06:29:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 406216B0151
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:29:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0ABAED265D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:29:55 +0000 (UTC)
X-FDA: 84359380350.03.2D737C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07F4C100007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:29:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rW1gA+My;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769081393; a=rsa-sha256;
	cv=none;
	b=JISxNy+wF27jOkpNxR5i5Y0IN+KTDy4wSzcHmqf+9SbteeZ023oJN0HgUpoHRLgyc5ZQ5C
	FwChGsq1ed5a7c+JqSSLcwQGx/iJUEzBtyaYu2yDmRzLdBJQXcNdrnCPelYRakZ2JUAGIx
	24P4dKnxulbFE2mf7d5P3GIz7bzd25I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rW1gA+My;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769081393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQJXvXFp4Q8gFKgaqCb7Err1UsYYuhwZ1yCQX7aI5DA=;
	b=hpyxteURJaE0m33QYmBidYQD7yD8Rftb73JrEpnhGOFBusRJ/rpercMH1sOqzcZk1O+zLn
	PY1b0NjryHXmBnHQJLxCzZsffJWLBjUM0p2vMQXg5QCgsqllhqdBKAi9Bf6d7F0t0BhKNf
	cWG0KvFZINu4g2IcjIfGembmHPJ2HZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33DD5440B8;
	Thu, 22 Jan 2026 11:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C3FC4AF09;
	Thu, 22 Jan 2026 11:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769081392;
	bh=6+k4UVNbT+w35km52qtWegiDJEC7IGtBYhfU8DZwtes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rW1gA+Mysg8qNsmPkZrSjxE9hLEPUy1tFzAO7z5dY0IkDeouLBOU0r2ljIA3fvUIQ
	 IUW/ZTYm42XPCFnIAfhUEYu2ZGxo8VBmz3LhT6lN+j8ukQEfMOt8MVdl/1TLvuxmf6
	 LCN/UP4caBRd7QMK19ZDXs/4jLIWvfkOQBwa1TgUm3POHqAzgclessdZz/nK3t304b
	 su5plVDH5YToWm1ZYFk4hmThulQL6Nf+1kyf2CJTEwe2SsTWfXw59K8omnzA20Aozq
	 HuN1syWuQY4sSmxZsozAaV5rmMMc7XvS5NFCrDd7oY1q04ZqBM3R72PFkoFCQ0hVNZ
	 DPCIL1Q4C2kzQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 931E3F40069;
	Thu, 22 Jan 2026 06:29:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 22 Jan 2026 06:29:50 -0500
X-ME-Sender: <xms:LgpyaRMCOqG6TSxsLeBIsmLJ9ou2avO5AwZCqCxKyd7atvN5aXW66g>
    <xme:LgpyafUSU0Wtv9NPso6hhIXRGICGK-gHqfUJmTlaZLf4IRlzjVzGuGmTF3DLD2l3z
    OkJa4NeP7gJtxDmSdbuZH1xhUp7sqgbpKB_5pQnhwSAMQ_vc4XN4no>
X-ME-Received: <xmr:LgpyaZo29EOFiQym1xfGjM85RhsqLDJpGA8Tq9JkrKhK2kvcGMm7U0RWGk_AdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeitdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhg
    sehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehu
    shgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgtphhtthhopehfvhgulhesgh
    hoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdp
    rhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:LgpyaVfjbK06k--k_MSWJ66Q9g8RZysYYF-wNcrPVH3Dias3QjVrRg>
    <xmx:LgpyaVDhebcBkMkPOiycyCMVNdjkKN0AZULhpzXikCuVmgvuQTlxwQ>
    <xmx:LgpyaQT5d1PoaVkc3_G1s64mZdv1ZmaakCRlBVq2yFjXVgWGwdCE2A>
    <xmx:LgpyaQJpoCNxDXghyE26KFHY0vlttGsHCI_HzxfExV--1CV2hdt28w>
    <xmx:LgpyaYbc4KaLVQ1-VOARShkUV8Uk5W6Gk2_r3ovBVMnYT9oUUOKnOXfY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jan 2026 06:29:48 -0500 (EST)
Date: Thu, 22 Jan 2026 11:29:43 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 05/14] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
Message-ID: <aXIKBhHd7IbaJkXg@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-6-kas@kernel.org>
 <EB8941D9-B6E0-41DD-9C44-038D21583E17@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EB8941D9-B6E0-41DD-9C44-038D21583E17@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 07F4C100007
X-Stat-Signature: p81qzho74m9min6ndifigc6168ug1px1
X-HE-Tag: 1769081392-910792
X-HE-Meta: U2FsdGVkX1/P2sW9X+9fWCREnX/DIu/NwcjYdqMpdL903XLoKELLoQUhaMg0Fg1lsMeUbh424vftRa018fCWgjBpToQdzI5qroKs1yQwM9PlnCDIl5OlLQidn2E7Ad8VG8pG37nEiCjxk19e+UhnuN4PuRg9x+Zrtgas8tTMT0poDuQjVxJ/xe1+JQXbd87dsBAA/5ceg2pB29/mEtbp8HzHwCllib4kBcH0yo8zhdQBqxq4m74iWh6H4okvQKuCGz8dfIeRJ+ccuxC3H9bHSh/UPlREIrGt006YAm6F0QinLPrTN3s/cz72GexlSMdt8vgIJOxdYAF8i9UNgpxuiD4bsU0ATRaYuppGZK2/QXqk0+CjG8W9q2SecahNQCN2S3k9bKLbDz74f3a3SHwzWbUkwqjefnGiJsiz/FD8wexXnI1ZLaz8tLg1sySrRH6u5j5jf6EVkdntUeCM9kRKzMKrxHx++nQyz76uL3vFEHgYCtKoyssCesRHjkGQeIHHhZ9FLneZl6mPI3JH5MaAW5et96M2ACApYXOKZCu6myztHRUNc1BoVgbyc/Z9Wt4lRAbciZoohECfP7TlzxQZs/lSGKZOZz0f0ge7LKLJZO0Ac79xxruASvCwo9cv+Iy/Mn+gmKNBDKBcuFs0ygm8ojm+nldoOh+NAORKHSspMONSGhOmfTvASXLgHVGqOtFKXRzWZRHWkYbbr8mOiCrYFjdYWeN3yrzeyjcMHNsPb1qr7t2IsL9tbkQom5TO+OwyEAYAtKTekvj8hERuzt6mOWU1tLXONGCvlAdX+w7z/BaZyme2/XBlVsnoD1NPO+jdnjIv9fKTLeRti+eZwpfrPY4NajZ8Uzw5f4jqKytqa2EmSoMsprn0kiCPruKCDgLlbPaOPnh3OkHSF6TteG9lT70jWUhWzMdC+o4618SJxGia8Zo9SC51/k8cwYXH8ApaepMjCkNCHZD+t5Yreyo
 sYSgsN8B
 +8zNT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 12:12:13PM -0500, Zi Yan wrote:
> > @@ -1244,8 +1244,8 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
> >  again:
> >  	memset(&ps->folio_snapshot, 0, sizeof(struct folio));
> >  	memcpy(&ps->page_snapshot, page, sizeof(*page));
> > -	head = ps->page_snapshot.compound_info;
> > -	if ((head & 1) == 0) {
> > +	info = ps->page_snapshot.compound_info;
> > +	if ((info & 1) == 0) {
> 
> This could be “if (!(info & 1))” like _compound_head(), right?

Right. But I don't see why it has to change.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

