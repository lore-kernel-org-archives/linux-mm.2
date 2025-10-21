Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3ECCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49FFB8E002A; Tue, 21 Oct 2025 07:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429DF8E001A; Tue, 21 Oct 2025 07:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA388E002A; Tue, 21 Oct 2025 07:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14D958E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF8EF11A208
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:18 +0000 (UTC)
X-FDA: 84021905436.27.5E5ACF0
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id D3A7F140014
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V tVOLEB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=aFvs788V;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLuUH66s5GK5mvKmYkyR8CP4H6QviMHTV/wP+OAXiXQ=;
	b=tn3B/yRzSoNY5Ns00d9gh9nucocEsrPG5Yly7TVjwoMqQasfjI8SQWxv37Fq719bnAE1aW
	lheb7Rp98cUZFJicHcmH9P0JUu8OVtYX/YFlcEkWr4vsSPAJD8wgp53RpXC3kuSN4pSeKx
	+AqyoiIYJNKADDMZpfvEVBFMXlG7CQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046277; a=rsa-sha256;
	cv=none;
	b=LjHpeaYWVEwrrrWur93dgvxwinyxJnXLpM6K+OAxG+qJhME1tnznWdOWlw+dvnjHG9xYlo
	NimUhAArEc/UZCB3lwY3tXVnXwOmBNfs1h+Rsd9nOH3IZ+Xjkqrfo7CnnM9PnC0bI8BggQ
	NWtWNiV8q7hmd+fi0K/BCSHtGTb+lVo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V tVOLEB";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=aFvs788V;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 0D7891300099;
	Tue, 21 Oct 2025 07:31:15 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 21 Oct 2025 07:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761046274; x=
	1761053474; bh=BLuUH66s5GK5mvKmYkyR8CP4H6QviMHTV/wP+OAXiXQ=; b=V
	tVOLEBljxFSK4E4lhTxWAlL/ba9qwZSnEFWSqacoI5R7kgVCiKIxoZsvON95LFmE
	xoDya60LWDBFSR1e1bw30/GlLZL3o4nfz3qXpuIXZEZVRo/ViKE0F5YjvaFfPGnj
	XuEsBzH/m+N0VrP2WS3y34OTx9W1ecGRywFMNkHd313pgpswYEpYIvtCa2h4KzmP
	iWGxHm3fAIJTRvKerXuOFdhRQ8qD59t87gxFH1nIuj4q17xFdxHTYLA7o8cLH/nR
	erdQBTUQA0O6ettsJnUL8VXnCLZ9t6LktqKOwd99TTuN3yQ8M5JUjTglXwWHz02r
	ktf+vlegg3qaaGpJCXowQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761046274; x=1761053474; bh=BLuUH66s5GK5mvKmYkyR8CP4H6QviMHTV/w
	P+OAXiXQ=; b=aFvs788VrXnd8g82PJYeNvUI53vVxwk18Ndv2uvKvtvljy15OTR
	h4WYYBHrrO+OwztFJwlVUS3amF90w4OU3xannSAyfXNZZyFBGuqKZz0TPO3GNtd7
	LiBz9h62+fvFY/U77VleCHyLpxXsueVua3dTMnsPnipA+ss0hGUKvYE0Mf0KiRBY
	Sgk9YXLNRYO/jp8C2ZihSvz5d/tszQz5kDaAzAni8tstEoQVQ+4BaHllZ6+lxQkP
	D5LVzU8oBa06CeB9a8Mxj9LiULXttMUuOH8q0IxAYzTW2606yBTDoRA3PI46DEj8
	lNL9R3RMlSX7og8eRViJsCCsaaHBhdM5PDQ==
X-ME-Sender: <xms:AG_3aJ1aLBz_kNGW9nRdGfmahw6U8DwgfJ-dJoX4CCAQyD3ZfiQqqQ>
    <xme:AG_3aMROrGlYnv_olSTsAAGcoyItemt7cJPJvcTK9R9s_oEUVHjjsk29KztSIwSlb
    vqT7hiXnfY_JMBBL4u9p_ubgE9t-AmVcNL0IwiFGc50tzmOeX8-EA>
X-ME-Received: <xmr:AG_3aBAIomb4Gm8dpNjkqNcOf7uDGKAk-0FfSyVR-jQv_6heE_eHP6-bnedBGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugedtheelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:AG_3aCYxh4OsdSuannxhKiVcXTYN90LbuhkeFf2kpQu-BoU26k4U2g>
    <xmx:AG_3aNawM5tTZoyPJCGn-YFXzTHP4sTIeYfby4T22uZYJj1m-X7Pqg>
    <xmx:AG_3aNlk51B-HQP3ueaKimaqsrIvO87dFdtNhnYUcmr32cJyis5SDA>
    <xmx:AG_3aEMZGhoCb0mdqmLKXuelhtzyUKqbNAiPRiAxuewOAMFhzPgfhg>
    <xmx:Am_3aE5rG7YeIoEvLbRvVYLoTuCMmIb3LpXFvKkmi-ujHwsAIlZVxTEF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 07:31:12 -0400 (EDT)
Date: Tue, 21 Oct 2025 12:31:10 +0100
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
Subject: Re: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
Message-ID: <eokncpih37zm7ypt6gn5xyetx6jlemhvvfdzpmdlxleqlsqcr4@45h5w5ahwugs>
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <20251021063509.1101728-2-kirill@shutemov.name>
 <a013f044-1dc6-4c2c-9d9a-99f223157c69@redhat.com>
 <37ceab54-c4b2-449e-aa46-ffaefe525737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ceab54-c4b2-449e-aa46-ffaefe525737@redhat.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: tt7u8bmndju59syhz78j48tr8175n6co
X-Rspam-User: 
X-Rspamd-Queue-Id: D3A7F140014
X-HE-Tag: 1761046276-703823
X-HE-Meta: U2FsdGVkX1+9LAuu0ktbOTWyg/0PJWCbE358AJf9eMsO0EPz9A4yow6ofjL/EwDzL5+wOxTRtP07OAF3Dz+kSKIlkvAd3zYLhPhPlNc7HREiuVy4lodg+nt5cMBwT1lrwuHLjrDUUDizuh9UETKY6pVgHg6wDN+tg/5MHWop7Gb1/UzJdZZ78dmT5vvCOLk68duFE5SWtXd9f4Cxb7A/Pmcve+XtQ6Qwguu5qdIWt0cVes4ipcrWP1joQJSa/E9wzV0QTCLZbbVJZ4uuUeIIl2PWxD57RBqoFekzM+t3dqUcqd7N5o21Rw7+i35g20r/X3Ggfhnar/q62WFvcu0r71h1Z/4IsFy/Rl7pN1id1uJ/eEI3hINoW9kTMNLcnWE4o1ZHZrJzfDJsAnDRp4hHP2Msx5NhaDT8P1koq7Y1FLmVAVCWCD4sOsPE0Dxf2mLg1oCkh1gntDGStgQv1e/aXwrYjRonLUm6atxIsRm8H6hbB32Zzi5rSNFhNc5U9ocChMrnaOcgvekzPR4Ta5S//P8tM3IB1vfotXqTLRvmCnPZGKBarp/KCx76/bRUCcq0jUIiNbiU3RzPZlJBu4GUvYqsrvNpL0Q+GsLYRjcPHbOkDVMvtpEFa9+hviIA9jk8b+7e4vCHgJCh0sj8xLPJIEj/UZCH7gpMvn/xJJshMnD5clpzFP9TU7nItUBWmnNXm2JOkgfDKYWBbwA1zjKTx4o7iqzS1TgNLK0xsPooHerIKu2+WOHjObkq7iHCU5R/72ZDxmD6ZHwCCjcpZorMMOGntO0wD3yHzMDm8cGXZDINMchi83EzAJz2PmbE9bhyjyannXzcp11pkw6P7unyuUJdptAwtslrodjGwNEYvydWtuz+seaw5NzywcZxNR+2i/IzkbhN2GaGcM2pnGa5Jo0begvjxh8QLbUC6bTZwN0wD3WLTxpMvzq0bcu28YsLE2xDN04EHMMIssnWGxs
 daeg4xCQ
 zHohHULpY4dtwn1e6pIAybTfEy+pfY4QZObIGpI8edossQr6N/N8YkT4tqvkdi29Iry5n6gI4MU5/Ri8cAt/uX7NFX6ZeBiIfgfGvGjHjUq/CYm5+GPgqrONX8NpGSSkN0+avgDqc7E8lqNzAOpanx/BeYxkb+qRG+9aba17MKy8uSqaAT6PgATAj5hNBu9qsduWGc3fppK5qzrZVER4K2vDA59mCDw2sw/ihNhcC+m4lQUf+6nQyQ8EO2BR/JzIZRPGRAGBJd29TSMVugQZWLOrUW/d+X6yKxr4klbRnxj+QQDhJu0r78wEbP2ZS6YATTiFim4S1xC6V140pF920YGSjjb80+1s64KJMfymbp3g6OtanBqFx9tCEEjy47Zn5Fk/jhM6Qna3YM4W+fdzX1DkIDjfssa/D19FiUJPr/VTMZQ01YjkTu8jdohQa1xl7/wJQImQrLmGDUkooLMa8o3zMFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:47:11AM +0200, David Hildenbrand wrote:
> On 21.10.25 11:44, David Hildenbrand wrote:
> > On 21.10.25 08:35, Kiryl Shutsemau wrote:
> > > From: Kiryl Shutsemau <kas@kernel.org>
> > > 
> > > Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> > > supposed to generate SIGBUS.
> > > 
> > > This behavior might not be respected on truncation.
> > > 
> > > During truncation, the kernel splits a large folio in order to reclaim
> > > memory. As a side effect, it unmaps the folio and destroys PMD mappings
> > > of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> > > are preserved.
> > > 
> > > However, if the split fails, PMD mappings are preserved and the user
> > > will not receive SIGBUS on any accesses within the PMD.
> > > 
> > > Unmap the folio on split failure. It will lead to refault as PTEs and
> > > preserve SIGBUS semantics.
> > 
> > Was the discussion on the old patch set already done? I can spot that
> > you send this series 20min after asking Dave

Based on feedback from Dave and Christoph on this patchset as well as
comments form Matthew and Darrick ont the report thread I see that my
idea to relax SIGBUS semantics for large folios will not fly :/

But if you want to weigh in...

> Also, please send a proper patch series including cover letter that
> describes the changes since the last RFC.

There is no change besides Signed-off-bys.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

