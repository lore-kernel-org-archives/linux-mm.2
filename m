Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52082D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D168D6B03C7; Tue, 20 Jan 2026 06:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40986B03C8; Tue, 20 Jan 2026 06:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9719B6B03C9; Tue, 20 Jan 2026 06:19:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2506B03C7
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:19:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19A89C1D9D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:19:54 +0000 (UTC)
X-FDA: 84352097508.26.B6E4FB0
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id F1377180005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:19:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b plZG/W";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=bGwiLDt+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768907992; a=rsa-sha256;
	cv=none;
	b=zQPyKDl4s6b+xKKV8h7hUNeOYtV2lG/AJqy0Sao/Eebu0erF9zBKpg/vZ/NLIpjd7lfaG8
	UlnZB02HLcvnWD0CvJZvk0RW0T1OD4zMFF2wJAyyLF1jkGarZ7UbW/vPoFJvx01YAQ2wox
	oKB02chcELkVCf68JSslzDReYCK3lSU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b plZG/W";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=bGwiLDt+;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768907992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foChf5V6FBeqdFIVO3ToaRk7LOuOObFXHZ+T8o8z1Lk=;
	b=VIoPj4HGlxmvL9zeIVGn7mMdxowarucx4oX6dRHCnQtOFSlaXuKF33sZg1637FiV5KXApT
	xE0CD6NSADPTnCtftp5UNsSA7dBD8farVT7Q+JYRFhqEHapXNH6XfQRa93bTbW7rTeUY44
	BKtKRIiHZf445XN1Je0t2lLVulF16Ws=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 886B7130056E;
	Tue, 20 Jan 2026 06:19:50 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 20 Jan 2026 06:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1768907990; x=
	1768915190; bh=foChf5V6FBeqdFIVO3ToaRk7LOuOObFXHZ+T8o8z1Lk=; b=b
	plZG/WsuoUP2kVdpM+pH8UfdS0M6Z8QrpHpObysjC1brXoYXjcVYtoLw1nYhyG1V
	ImOlI9X18f8I6zZjJPsaLVqWpyfpU0Yy33/4WIfGCw0PYfO7pdFXNVzCBW1e5Ovx
	uGWb3yw38fQjUJl4rnEG49/9WhHI9hOVWT/xoHl5sVh/7ODCp9XUzNSSfk4SUDMs
	6uYZIRg4Ddg1YoHoMSMDK8gISCT9ILu1sB9IlHTbj8zWB747Qe+KCjOsdBjoO8g/
	1LJ0b88Z0SD/pxm6rCRatfYsPOHB4M0yXimj4A+GZdnqikSgySAwGyEjMc+m9Q17
	96bY/qkfFcTJYyeQjGcYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1768907990; x=1768915190; bh=foChf5V6FBeqdFIVO3ToaRk7LOuOObFXHZ+
	T8o8z1Lk=; b=bGwiLDt+EvHViHcK0/T8nv8olWqcxwBhEarWWlDWnbDfbtIfRrJ
	ZLM7MtuBhyTplhEiUsWdrYSJXay9jV7tXvgMnvIZgZRm1MxuWCmoQNxoNh1Y9RdV
	Oc01W9RFtwblxXaW28eIOS53Ljs2HX08Mtajnqse0W1VYdUuIOu4TjIHdRFhMeT9
	qiQFiPugGw+RizF2p7hK+g2VoFXXooDOme/4xfr95KXw0dn07chIbMFQVUE8YolT
	clPqFJ0lEsPDyOIGJFtjXqfmcZ48VFxgiMgzqWb57cNHuYYe9X7IYsx0rqSFXdgA
	FjzSWCyIM1KZf13xvnUIhWbrlHsPpEIRwTA==
X-ME-Sender: <xms:1mRvaUPnH3jQssVNwRIxCGHIMJ-DkHnk92HxOSWGpBc_CnaLobUBiA>
    <xme:1mRvacRa8bjB4d1AZm5-cQhBIxS8nYEsU2_fQBI00ulZcmD-orK0Zist9LpYWOxo9
    mLA-aymCrJGAR6YvEGKgV1NvRcFxFDAK-80jkY7fIg9ZTOFcOqHvSI>
X-ME-Received: <xmr:1mRvaf7BLtYgqF474QSD1bO2xu85hTwZ9KjTNIzuXg3mHB-CItn09i7biYQZjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugedtvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhephedvveefteelgefgteeitdehvdehkefgteekteejleejlefgheei
    uedtjefgvdelnecuffhomhgrihhnpehinhhithhirghlihiivggurdhmmhenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhh
    uhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvddvpdhmohguvgepshhmthhpoh
    huthdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhu
    gidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhorhgvnhiiohdrshhtoh
    grkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhhohiflhgvthht
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprh
    gtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgs
    sehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:1mRvafZ0Fvn3troQU3yULE7637MwCkRrlAcnxDdPC7_r3R2-_zavhw>
    <xmx:1mRvaTZukqhqKUYem2FrPVwB85BpU4D2I82flQqFTg3xQlAkRyygbw>
    <xmx:1mRvaS04kt4yVpq38AIU9AxT46xcNYSYd7zH66h5FkENP_ixzMnlwg>
    <xmx:1mRvabac9MbgxbwDzT2KKui33ZxDES-HJd7BYUPymR_HVSEY_6e-nQ>
    <xmx:1mRvaZ-_ucglKlSEg-L6haGS_bdQdbuuUPAJiQaL4JN7yavQaFeBiqhk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 20 Jan 2026 06:19:49 -0500 (EST)
Date: Tue, 20 Jan 2026 11:19:47 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v1 1/2] mm: move pte table reclaim code to memory.c
Message-ID: <aW9i3Er3HXzg9V7C@thinkstation>
References: <20260119220708.3438514-1-david@kernel.org>
 <20260119220708.3438514-2-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119220708.3438514-2-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: hsq95apupu6kyfixmzdo5mcso3xezf61
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F1377180005
X-HE-Tag: 1768907991-66994
X-HE-Meta: U2FsdGVkX19UuNW4T8Zguf512ycULV2fru/AcITRqtU1pSO1oYgHYFmKObvVGEu+dpOjb/RFMUKPdgwBWi8MW5COOkc/UY/8zLHxMyYsvjNPb/+GFTcfh+rduDR0+vRF8t8jDSCeah5m6j0YZY3R1EzEP2EgNz9XELDHpnaZNUQMVBkh6wjzeajK2npS1eaN/rnrXZpK3jaU1Z9i7QfWLzGn7VxoluD1H4eaIjoNEW+h8fhhH1wOsXlJyg/ii4lEpVrPL/Jj6A8srIdfu5c28pV0Rsb9nZTGsiXnjOCcE01tTHy2KpMRpEogaEOGsWXWUaqBoku7rIaH4g8NGNdvUSSMK7+2O7DSaDGcRTPKrfG1TmHtkD4F1+tiWD1p0KeuAJrXvTigkrj+TsykXabDtF2TQ9R6Dm0LGTzuRiPl3GaDKr+8Q6uv5g4aeIQgsicqGEsy8WBa8z4fh8NQRWx8WPcwQA+d6z3MJQhL3B/qBvLSYe/Al/yWeH5NDqmq+GWUyDSd5llJSzmGSSq2awvD3Q6qsBng9CqKC5EfW/nWyTTYTxhVwZfRBUzGDplPqUxgGaUedxRPshmL53hZdPOnheh1T1w/6f8L2NnGzYW9BJTFq/bX84I2imJ2fMwv3mr3YKWyHD0CsjrCUc7CznmHKlGqYBEf9xA9DSmz4gPeiUpC4d79m8/07i5jGjOPHHaiZ9wzAvFT8gqDCC7GNIE4mMOOXsWNXKHgWl2it8cqDAFNO0xAJ9f7tZXpPO+UT09cXkTitB+Qo8Pe98zO77ZAM98HRWfgnGRfRaTb2yRqhitywgPQxdquEbEEqbqYcBibY3naLwDd15fQWiMO5pOykBLZrHGLs+hAxTYu/KwnDK46JATSxe1y7vZW5DaN+rhpAP4UXru6Tz3hocCB4JX2gXC+0ArF05nxuIYGj63B5RhuvnXfAs6cXIpl8mWfYi9xdOZ6AU5Nvjxog4u5u/Y
 RCvcktPX
 sEXKvOk5AF1EyKHAHQeJnVY6ThL3eZIG3f0WkH2N6rAcfCSxm+SY96xseMJRoiTM50kOVJNaODcs7C5yJwmjzhyC4cXVHkB58EgspbHT84QowYXG6Qsav615+vKR8DU+MgrahP812gKvutIaFTNJVuvMI9mEt3U/xH4k0otXYdl6ZeNi/q9WxRvvZyngcKF7ovlg9FWEFtnS7TGppRYOEPjHILHRsaKgBM80YzMGRsiz8JQwVOBdNYuySi6tuh5CKqeNxDBFqLCmXDpvag7twkESzLwwMdOU0hBUL/9srZt8VB/llLknWzwAHGYGMangacP6C9vkwYiI7b4uheo1iOhCc5phHRJrVe1GO9zPnbN77LJ+VUeBg3P63Ip2+0KCgZfZl+GyY3YaxOcWHiBqNcP0dc7Qrp20XKOSrPvj6gDk0GHpYiS1vKpzssQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 11:07:07PM +0100, David Hildenbrand (Red Hat) wrote:
> The pte-table reclaim code is only called from memory.c, while zapping
> pages, and it better also stays that way in the long run. If we ever
> have to call it from other files, we should expose proper high-level
> helpers for zapping if the existing helpers are not good enough.
> 
> So, let's move the code over (it's not a lot) and slightly clean it up a
> bit by:
> - Renaming the functions.
> - Dropping the "Check if it is empty PTE page" comment, which is now
>   self-explaining given the function name.
> - Making zap_pte_table_if_empty() return whether zapping worked so the
>   caller can free it.
> - Adding a comment in pte_table_reclaim_possible().
> - Inlining free_pte() in the last remaining user.
> - In zap_empty_pte_table(), switch from pmdp_get_lcokless() to
>   pmd_clear(), we are holding the PMD PT lock.
> 
> By moving the code over, compilers can also easily figure out when
> zap_empty_pte_table() does not initialize the pmdval variable, avoiding
> false-positive warnings about the variable possibly not being
> initialized.

mm/memory.c is a kitchen sink as it is.

I think you miss opportunity to introduce mm/zap.c and move all zap
code.

It can be done for code from both mm/memory.c and mm/huge_memory.c.
Line between THP and non-THP code gets more and more blurry over time.

The same can be done for copy and fault code. I think it is going to be
more maintainable this way.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

