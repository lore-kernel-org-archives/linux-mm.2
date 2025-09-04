Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A4D4CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2156B0006; Thu,  4 Sep 2025 11:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651E18E0002; Thu,  4 Sep 2025 11:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540D16B0007; Thu,  4 Sep 2025 11:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7E58E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:26:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 081951A025B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:26:21 +0000 (UTC)
X-FDA: 83851944162.07.2F01331
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf23.hostedemail.com (Postfix) with ESMTP id CF78B140004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:26:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="T wxRUM2";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JY1atfuu;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756999579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jC7LQ/mmOicbI45GOht/juWrWam2IipA0I2zNWPuuhI=;
	b=xIQ3mL1xYMe3OdMhga0T3VEg0/daenStfUGBC9Oa03Mic2iKGemxpX67RVRx091AEeYSnW
	IMgl7KXk+3UjDxvhydzVQWpVLqFB8jacwMiyiZeqVoQLza96Z8foLLJKCvbDheHt5Y+VYW
	+qj0HV/lhfGYSq9Aq1rkUTP0Fxp5888=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756999579; a=rsa-sha256;
	cv=none;
	b=kNEovTqAuSi/M8h2BeN0//r7jpNGjJpeofD9sQCRgqSuG0s7+N9h5n5w0HE8HXBiwGKyXq
	TRABjPHdvzMGJdu/cg4QC4+x7I+w17czI58fDy9fkIguxZ+2tXuerkFeo2fny1xIspwgiZ
	kgxGR80/KYKmkCfhZxC3MaYfo2uMBPs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="T wxRUM2";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JY1atfuu;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id B0D80EC00DA;
	Thu,  4 Sep 2025 11:26:17 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 04 Sep 2025 11:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1756999577; x=
	1757085977; bh=jC7LQ/mmOicbI45GOht/juWrWam2IipA0I2zNWPuuhI=; b=T
	wxRUM2QaTVTlnBa/ZJcF4rY/bJM3SJWhhweyChEn/HLKlYHBEHffhLxLHXdifdtS
	/ba24aWFNHJk9gCiQWhzBB9VOrfbs8LKih90j2f2UIRTd4a8AyIcb5iUrtxtw3Ij
	rmAO/hw3a73ZImmJErlxXtn8NP+KiD6mq+bnRgznIymFhz/JwTHMYWewDjm4YgKU
	55yRTam1GX43hHM5fFbN71kHVbNGBOw7DEkR/OwB1hN0pglDGVSVK7aUMPOm/ysX
	7LqoauChBMGHnrZX9LTmZRsk5CQMVFrYz95j/AL2NItK/4fuB7AkhDlEM+k5lct9
	XJXmOtiI/rdInQJdFY1Pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1756999577; x=1757085977; bh=jC7LQ/mmOicbI45GOht/juWrWam2IipA0I2
	zNWPuuhI=; b=JY1atfuu+QwAu/e+ni+j63Vk4tgUxsBL+2ZYa3Oy6Qi+zClA9ld
	l/3rFBqXfCVcb+yh4TvCDElXnOmBQUtCIP+OXQs9UYJmt36AKknCvifY3SB3aJzO
	JFdaIQw58Fy4IyNbRZ1d2NkFZxLfkuAgurzYuStbuo5O7OMb0FQdrLqBztLVBqWd
	t3gS8Ieezh4KVK0hDH2Q2VkjJtDmmwuBtRVm2tgQDjE1YjQrMBPTfcAqcV+U3S2w
	CpF15RojmHbAB42jrwfPVLQ8n7KH1T3JnBY5I0g/vhhvBSSKrDWVQ42dCDgrOaNy
	HRKVIviNhPbvBOAlHACQ+qpU8UJlKrt/i1g==
X-ME-Sender: <xms:mK-5aG5Q7Uo5m_Tc3R2FnfcmU5IDBxKQDOXpELOgJzt2-U6eo1Qt_g>
    <xme:mK-5aKuk7nXDPS-rEolkmae89IsLZ9bhBPVG2WJ3X6YrmEiErmnQ7WDBJe6tnMuTk
    wi9NOA5YGcTguPMTro>
X-ME-Received: <xmr:mK-5aDuLWYiJdKBDO7E3WbL6nUJJ92sa8n5AHWXpJ4zcsCnCoixBPMyrdqtn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeifeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdeludfh
    feefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeefgedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgvrhhnvghlsehprghnkhgrjhhrrg
    hghhgrvhdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphht
    thhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphhtthhopegurghvih
    gusehrvgguhhgrthdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghs
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfigrnhhgsehlihhnuh
    igrdgrlhhisggrsggrrdgtohhmpdhrtghpthhtohepsggrohhhuhgrsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:mK-5aCsCgw-2hundynXjOa1ffohr3kP4X4rv4RcdFHZ5ZUDXrURv_w>
    <xmx:mK-5aD4P7nvpZS6ODvdsaI9eRk3WGR5m0yKv-ufabLl-OXFEBDmylQ>
    <xmx:mK-5aFB8FII5kC9Wfg8hsNjVMkicxIYZB5KgY3NAKIzTl4hIOfbOGg>
    <xmx:mK-5aDvqfYHOM9-5ntiRug9-vd68Z7oRilFCEoBQPv3K0suePfKNDw>
    <xmx:ma-5aNUso35o-4sP0Do-5MeUQcSGi9iH-0D9xY5lDcSMhkdh1VxKp3A3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Sep 2025 11:26:15 -0400 (EDT)
Date: Thu, 4 Sep 2025 16:26:13 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Zi Yan <ziy@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, willy@infradead.org, 
	linux-mm@kvack.org, mcgrof@kernel.org, gost.dev@samsung.com, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2] huge_memory: return -EINVAL in folio split functions
 when THP is disabled
Message-ID: <2psecfvsd4lbgcm6aflifi2kc6gof345txsvk7wtsytre5ehqt@4wyru36aaeel>
References: <20250904095129.222316-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904095129.222316-1-kernel@pankajraghav.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF78B140004
X-Stat-Signature: t3q6ytjhae5sc8hi3yepr1888x1yzg6r
X-HE-Tag: 1756999578-999083
X-HE-Meta: U2FsdGVkX19hJToYy4N+l7eSXAMpG9aIRroAHaEqdF0hLp6Xl/VzuXrBIImuUJtCDe+vRwg8rvy3EaZlMN9GmY7BHgcWDBhrnBW6Y8dsfooc3zBQ6t3Zw1m2UVivbrwqvYKKxkE5okf5+3aRP6LrTV2IFfj3owOREJoXP9HQH7z3r5tmBPea1Yu/YZFBSZHiPPUhymMke/aspZhcwt2JhGLiVQHORJ/KhvuGMav2EWdr8s3reexH8ZT1HQKg2jPl54GGgnaX1c/NlrK28UzXv74MctWkT9yoVFFMD/9tTC5G4oc7tygXiqGAAqe23GF2fSPR3Sh0S71HirKGKRAoRyib/1x/QsPOxz2QTe64oyDBHd1NocikAJ3bIoFpq80+YNc36dYiydFYGFuVRn/OSFIKc5mKzQ9UK0BMMvrjPiVQSy4Nm2dbr23v2/Chxsis56hJG1L19wJqns5DPtqif48Zt8ICaKIXfTCUgZtehun+htEadD9WoHJakZNHdy2t9IOzU+Mjiaq4U5sGn9ekh7QR2/Ds4O9pEVeCm5fB8NDqR0B4HM04yzszeholUEOUCaoOLlolKMQCmCS3wx0M5iDVM4q8eDNZokBRjaYPeS9qzQWet01+MYMn/l3FVJ/S+vkUTrdhI0Z1YRit7rX6F2Qxi8nE6ZIDgydavpCmE2Q/itfQQe7OFsv6z5asdW4q5vA83opMbJrUOuOmIZ38ga9pqG2+VrHyvrp6ihNvJTYcWZgWZtWHQG0JSHIPwbl1JeOSD8g7e8u9MiR6lZU4WqiJC9TS1/MC4xZi9SeZb1yIXzVbG1hcHSEHXpNrntMgLUwoWomKbptc+6ujgAlA3emvgUvIRnC3hpinZj41FF00D78iTpU5NspmasaIFqvBdugmtNCimVg+pokfWEt1p2WZrD6RGzHG9/WlUoPhS4srhP3uR/9UuwwYqtl5DlGlFULTyLb4J1uTkKHDugY
 qoVo2oDg
 63knANn7a2DQZWeWjeHrobXBUFbDjniPQDO3V7XBSYXevZLOj9snGiBXoPb8GO3IjRglZxlWMr0MaR5MgRepHtm+G9tUZoop9P+GoMLjGRtegAVw9786Rlw4y4AGhlXKdMk+9BhYVMLy3BBWkdTha/tv6v9MwakzJQrS6ly4QioixtAIqyrrBXV1WE/F4w7DcBnwrCCvpTr0TnD0PFRPYLRYp9D+rBsSUasX+CQJ6sY1B7oodr+C9EdO1dohx0LO/p/KaxJJPHKYOaj0xTnJewfVJ/67EXjZOnnP2oMh1CAw+zCD/013gY/qzM4RflS0PGR3ZZq1pa3ZqA7aMKp/Y4/5yvptn6NcKKHQuwko20Aa5gmDD03xpfkhibroN5dbCegFmx1fKKm/ZiStD1xrT40prmSfvze5d4rt3vsaA63VI12e96SqvP7p9qR7X4+ZktPzTuUGKN5/Dv+o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 11:51:29AM +0200, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> split_huge_page_to_list_[to_order](), split_huge_page() and
> try_folio_split() return 0 on success and error codes on failure.
> 
> When THP is disabled, these functions return 0 indicating success even
> though an error code should be returned as it is not possible to split a
> folio when THP is disabled.
> 
> Make all these functions return -EINVAL to indicate failure instead of
> 0. As large folios depend on CONFIG_THP, issue warning as this function
> should not be called without a large folio.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Acked-by: Kiryl Shutsemau <kas@kernel.org>

Just curious, did you give BUILD_BUG() a try?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

