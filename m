Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E676C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 11:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED6D6B0149; Thu, 22 Jan 2026 06:22:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995E36B014B; Thu, 22 Jan 2026 06:22:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87BED6B014C; Thu, 22 Jan 2026 06:22:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72C8B6B0149
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:22:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15C3DD269D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:22:20 +0000 (UTC)
X-FDA: 84359361240.19.6BFECE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A7AC140007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:22:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtXcReft;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769080938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Om/rZOQIDleSoDIbcI6IoE+evj8lKFQsByV4u3Cnfyo=;
	b=nvXHDgTkYtbo8LveT14zqXH5TV/0Is4gnY3a6C+HyrS0K8gt5y8+DE2PAOwVBAewgUa7xe
	x1TnQ3oEgLpnmBKoht3KsYgHVAzjC6RQEgjdMmS7Ii/gjrPgnD50a2RoXnT6/BR5vsJrnq
	efca+FX61hmbKmKMlXOPdveey3oqNt8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MtXcReft;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769080938; a=rsa-sha256;
	cv=none;
	b=EMKnJZtaXQlAY+S+Sd4KtXdgUHVrggK1fSPayoGjubEusPyeLZY57332E30p5qhIXnlnzX
	eQqvFV0gKjajgYNaiJGuJNzBBlc3foBLg7PeLEJcBHj17Swn6ldfQL+K9n5qXp3KNS1ola
	XInm42uPD3Z8GcErCzkh+FBVtS+wgAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37E85600C4;
	Thu, 22 Jan 2026 11:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA0DC116D0;
	Thu, 22 Jan 2026 11:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769080936;
	bh=jY+6Ux20wmAFYj3ZDCilg3Fqqbo+VmiY4n3Np5FgRm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MtXcReftCdP2oFGE4OG0RTQX7Q5IiOPR0vhdBuwluNE3DUBS7ON9s+dbR7i3vzj4K
	 2oubCIx2+Epn4BMnF+OkT+UFOGySFI0cpWmqaiIbfvH5rppwjD6T8RKVfVcxceDOIn
	 znjINksqDZ04a/gR6K4KcQjXwTm2StzZEk01WJVUmg1kvn1Y8UDGoBqNL4oH/GNIwR
	 nq3EVklGNFPF1RmqRVUU+FlO+hVTGrVSynU5exqtt27aTc/PqemXl3PYRdo+f3/hN9
	 ibX2WrvEOi6VhsAhHyPv/olj5TTttldMggtLUJQCKnBcluUnqd3MQEaITxlZfzDOuy
	 pI3wDL2CyptuQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id ACECAF40068;
	Thu, 22 Jan 2026 06:22:15 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 22 Jan 2026 06:22:15 -0500
X-ME-Sender: <xms:ZwhyaQgWAfOH5lPwJgyrs-1gnAF3m2Q_4HcwNASz1Wv5_4mcWd2WBA>
    <xme:ZwhyaUaw4M6u1dYaCv8I1qbUHy5fw5JTmQXxAUuhU4z093UynXs2devRrnsryUzF6
    gh0QFGT1fUJ9JpFl6-zIUKCCFRArrHh_HJOF9H9AMymNmgciToKJ_s>
X-ME-Received: <xmr:ZwhyaRf4QlVc7Un7uAwP62xF5Uw-EuYl_qXiO17SEqS_gTccYq3lwtqHl2Lgqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeitdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhnghes
    lhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuhhs
    rghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtohepfhhvughlsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhr
    tghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:ZwhyaZCTB5OcS3eOXlUVRsza8Mk5ui0vmfXzK8uhni8MMHhczov2CQ>
    <xmx:ZwhyaZUfNlcv87PL6radnVQe0suIWRGxFuVaHWbDiEK67YiN8QDfYg>
    <xmx:ZwhyaWV6LLQYMDzWw7XCWfHhxPccglpvxFKKl-7xF3g8WJxYkHn9Uw>
    <xmx:ZwhyaU-lJOCqpcT1VSUvYV18KCDrf_kLwGbyfShy68v6e2_LFFAj7w>
    <xmx:ZwhyaU-3VxbqCvRnTFqbNoCpS4ywUnwbelmbJoJ0-tY8kcd-el4eCVQS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jan 2026 06:22:13 -0500 (EST)
Date: Thu, 22 Jan 2026 11:22:08 +0000
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
Subject: Re: [PATCHv4 07/14] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
Message-ID: <aXIIOf7cHe9hzk0W@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-8-kas@kernel.org>
 <B752281D-4A31-4E2D-945B-FD18016B722E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B752281D-4A31-4E2D-945B-FD18016B722E@nvidia.com>
X-Stat-Signature: 86ageyn9scohbcdjahffjb6in1771toy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A7AC140007
X-HE-Tag: 1769080938-772023
X-HE-Meta: U2FsdGVkX1/23qOlPYtiW4GHiB3dm0xNnPTc+l4KSXhFd5YaWKb+kTX3Zxfwe2FhOMyV/jZe/2l8YLUaM1i6h+So2qXuaEICavmODEa6Ma/HZZXfn5qQgfi7OGoqms4HGBl92qngA1Se31hAxQx7aAd/cvpPRhjP9AkpId+waeWhk9lHSUszJwDkdN10+uNBjud87/lOJ5evymyES1K+eBCFPSFpZNAbrV118I5m4vJgqUQjVaLlmVttpfnzBWusz9hwCQc/M424F1k4UuNPOtk/k5q1aAjjjf73Gx13MC1leKHQc+JyWZrQ0NNWWSFJpO4YBTYXRUN24Aov2dsO4BJ405qG0ZZFv336LFT2QGrCGOeA+oHNffFcVlR10l4lAmmACmceN4/BIvuA0lswKRwku3uTCudY2raX4cIf6oBEH6r4OnwOIBp2TcErZQxhMPFcFP5CUGIk11wI/laqnsun0sjtEs/xQ6Mdp0zq2AMyQx/21aUzlo6W2UIlgvvFEc+hH1sNIMVt0w68nMl7RVRLj75JTRV3ThcDRH3Vczt+xT56fx6m3YAei8dP0c04x16X9/qb9sRLPJaX1OLjVCd9/Y9AfFE9mcvRmvzFFbw5xb5lu0/2ckS4QlBJlhlPERoRMAJ/B9YXKe8TrAzn/4XQu1iKPljgX5YQEW51cadSQRg1lrwaowvs6uc7YhJ6slUJGH2RMOLtrbvwYro0wKurM+wvuNOGb7KJYZRGQoSdexzESxvmYCj5eFlR1Se9ijQeXxcZVXvAPcoM2v2dTq0wpZHC/ks9RNW8EII/BicYIDi9TQRAyazcOlYB7f8LpxcTjquU1QLikdyxzktIHEo77rvZ5DajVwHy53ryZQ+PwKvIB21IzykD2AV8/0Kt5dftADahAto+jpUoG4FR74ZiDTg/8wdCpvPJnB78PC38J1gr1CwhA8SPi9TCFpqRQWKBg7WdyTF+bhYUxaQ
 7bMHq4w9
 0TzNsI6UeGP/omLVM6dMI1ROhtoseS3sDLPmrMsXvwovOvhsaxClJskW43Fyzeo0bOaMsFkreEUfu1vrc6VL6G+46dSYyD/p5/rEkg2EXHJe0zPgBPrQEd4lPvXPby5LVkFFKgYwg6/d0r0MUfvLBYCPru/f/eGo17NgiOJPzalBiGnQm408GaUFiXpaem5eYzUweisSDbh0qi3nPDGGtN6lk7thabyCrMVx5K/uSOgpKFp8sANufuWSza9H9qrHEdUZhm7fUWYLy+uhE8Y/v8zP8QCuRMePqJ2H4GNpOM8O4WEHRFjoiwKefIcvbxM1wr9/siGyn9w2QXkoCiFxMFX3q8NSAKqDq8K9o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 12:58:36PM -0500, Zi Yan wrote:
> On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:
> 
> > If page->compound_info encodes a mask, it is expected that memmap to be
> > naturally aligned to the maximum folio size.
> >
> > Add a warning if it is not.
> >
> > A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the
> > kernel is still likely to be functional if this strict check fails.
> >
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >  include/linux/mmzone.h | 1 +
> >  mm/sparse.c            | 5 +++++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 390ce11b3765..7e4f69b9d760 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -91,6 +91,7 @@
> >  #endif
> >
> >  #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> > +#define MAX_FOLIO_SIZE		(PAGE_SIZE << MAX_FOLIO_ORDER)
> >
> >  enum migratetype {
> >  	MIGRATE_UNMOVABLE,
> > diff --git a/mm/sparse.c b/mm/sparse.c
> > index 17c50a6415c2..5f41a3edcc24 100644
> > --- a/mm/sparse.c
> > +++ b/mm/sparse.c
> > @@ -600,6 +600,11 @@ void __init sparse_init(void)
> >  	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
> >  	memblocks_present();
> >
> > +	if (compound_info_has_mask()) {
> > +		WARN_ON(!IS_ALIGNED((unsigned long)pfn_to_page(0),
> > +				    MAX_FOLIO_SIZE / sizeof(struct page)));
> > +	}
> > +
> 
> 16GB is only possible in arm64 with 64KB base page. Would it be overkill
> to align vmemmap to it unconditionally? Or how likely will this cause
> false positive warning?

CMA can give you 16GiB page on x86.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

