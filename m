Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B61CCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744026B0088; Thu, 28 May 2026 15:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F46D6B008A; Thu, 28 May 2026 15:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609816B008C; Thu, 28 May 2026 15:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0B06B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:12:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E075D4081D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:12:31 +0000 (UTC)
X-FDA: 84817774902.18.72FC5E9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id A8CBF4000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:12:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3kUGFbhU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779995550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1DLc0W611Kw3zuQKx1t6s7+eLHqWB4PhdsbwTC+/FA=;
	b=mRp7NNSySfjZdG6Hd1jzHY9/mxG3g5Xa8qeeCsteNyAQEWe9IXDPTXOU8k4gsFST8MBPtU
	KWdsEWw8243n0o+HLbc2mdvFQBWGGa4ZKL2rVH9Mruf91AFUQOWjMIqgR7DxLXZXccp2FP
	OrP5GeQFfvyIG5x+gz3XUXX6Saxj8TU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3kUGFbhU;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779995550; a=rsa-sha256;
	cv=none;
	b=M5Tn0HLCzCB0v4elVdIc67CxPPkYKaIKsOhTcKm9mMksd3WznPFeKLsip6HYmDirOZFAVu
	fctJjTEXG2i7SmRgoVWBRNFt54w3w6IITwwkkhuSqkNNB6mxdkGyMvxNQ3i5CRSHt0xW4k
	mdEjIValQwRBTdC2Jug1nqEuWJ6uJZE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d1DLc0W611Kw3zuQKx1t6s7+eLHqWB4PhdsbwTC+/FA=; b=3kUGFbhUp7SFwh4tQ0y9rU7Z8F
	yLoiMwJ0W7WSDqyKRi79P/1zof6MX60NAilusI5loY9bj9I9jw9SR/z6y3ee6kBFtEegNBNJLAOg1
	DiX4RO0G22azBWbA7CmG48R46uj1LI1VwST3DNJyMj1LoZOpsjaVHCVYEUkQKprW4MHsi54t0auby
	g8jd0znwhPmty8WTzBYq/5c4Nc8y/p4MsrRA4jlYMQra9V+x8k8Gr6LNpT6kxbNxlOCFLWy4uLa9P
	kkX80CtavJv7GgWyhkLKW67Tpour349ZS4HWuXhDQieTdRWnBMM5JI/fuScoyUyJWBHCtv+Oh/aMS
	KrWSBG9Q==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSg9b-00000006GND-23UD;
	Thu, 28 May 2026 19:12:27 +0000
Date: Thu, 28 May 2026 15:12:13 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Brian Masney <bmasney@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add vm.rst to memory management core
Message-ID: <p72rlykrihniurkbavzsqhvhmfygaht4kdsv25olras7xhf3pq@kpetmyqizgoh>
References: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8CBF4000B
X-Stat-Signature: whnwba34rxetgrnbhtf1ut1qckzgr1cx
X-Rspam-User: 
X-HE-Tag: 1779995549-607937
X-HE-Meta: U2FsdGVkX1/Mk9LMXiYr8VaRsJG7Fp3Tl06yEZ3iT2RckYBnDJtHcCymybkYRTVulFOf5MGZbUraWpzUOAs2oyqJv7mY7VSE70H7g7Pd+iMtj005kHnBRDNJJqClcER30TgAgDULSciuRabvBjCvycZBbPoTAJlxpgbKSQg80xXdd2rLHtHphloWIM60zGWR8FWIILOC6qC9G5GDOJiH6YHYDlbMFCXQ2Ph/O3X5xMs0K940mQ5DG45xJpjlAognpAhGemC3sTYivj9dk6nCXOOWLP+wBqQMzwGxo5aOzbo/jQ5d0qplgm2fcWzzyq5krjbe43M8lO9+yVyR9iHCl2OIEBwAY79CZvqahT8OLtYw4TCWD0mc5ZUrSZFcuThCtNRos/WNhj9y6yDMf6PKHx7FTbD2I58+LAYUxbH1A46fRlQz1HVF/Do55RyHR0XIruf5eUx/3Pa+7wt2fQprVv7QxdqSPFVJ+d+c2m9BWpNf2h86QPiXm4nRPg5pLbyOerS4ul30pM8JTd9S/aYTj1/Okuk5jkaGsxZlvx4DBcL4M3iyLlsmDCB1LQwWupalGCJd4L7jf4CgOuraQiyWEudt7tXQ35OHV2i36Fd9cgSqGCwizLerDuI+5+RvrFWKDyhU+foPqvDJmwvmya3MNSZnaED/U+uoLIN+sPnLR/tVEjUtfbxIIg/QGJmink6Eo9tNnOGlKeprhnNlu3M6JSkvf9xt2BsrxSnpPluulDRGS0KnWJjuPpcEW5U8bNHTWTs/oGblAkHe+tROJ1sCYLa1RpFNOBUsRxFV8NEI9Vfsuqp/xYO2j00S+Aa7DDw321Oy0WqzoiupE4wegAx75BH1LvvY32VtFDMP/4M8vYxpD/HcSXFEzOHLbvFkJPvJM8ygceI42jiXYZjKPiM426jXmrIwQWdtGU1IEDwU/nzJ2ENy2aCaJ+Zt1Kr1Qb4TOAYnD4hWgndNtk1szYF
 PhNvtt7d
 5Rh1XJ577E485tZXBIUmhGH2SZx+b5sZ4RuDDoEhBSRbDz+AvU1hcmMnGhuIhyfGS/9IwDtfxuf/3gVvQUcdqIw4GbS+BVHGe8Mj6zNq/HjJGrFoqjPOqmQiUge2fFcq8qB2WO6VLoiZS5YBZUWL5QaRP4I8UxRXroKxS2B3KSUViNGIBWwZ0a41NZ5KRH6inBUWMIywIowlbGZ/1YWSooNjn5ord54QqRHvD7r1mEeNx8wdXg5KkTU0bd0aGq+ZMjcGdaJ3alnQY0AfLjCE3Hds8c3Xc23XWCcZqdLk4udvi4IKPxLNg9kF9r1vAEqRi7wAREaEm0hEtF00T0tVXFW2yH5crWbGW6QeXb/AsDNLlgfqHDlnXfJY/GgzBun4Ni3ImDw8LI7tjixvupTDWuVSUp7PK4sTPwF1c516M2ZS/hTBoLf8FTXhIvkAmyEXL56Q33aO0VytXXpTnvh01rK0YISAO4SFO/hbFsjVqsaj0TZxcEnhGjPfDBpNsySCq8dO3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/28 09:56AM, Brian Masney wrote:
> The vm.rst file is currently not listed in the MAINTAINERS file, so
> let's go ahead and add to the MM core subsystem so that the maintainers
> are CCed when changes to the documentation are proposed.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>


> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c99f0650b334..d8dcc4f25ccf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16923,6 +16923,7 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/admin-guide/sysctl/vm.rst
>  F:	include/linux/folio_batch.h
>  F:	include/linux/gfp.h
>  F:	include/linux/gfp_types.h
> 
> ---
> base-commit: e7d700e14934e68f86338c5610cf2ae76798b663
> change-id: 20260528-mm-vm-rst-maintainers-file-1baa6da1e7ef
> 
> Best regards,
> -- 
> Brian Masney <bmasney@redhat.com>
> 

