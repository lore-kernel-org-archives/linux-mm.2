Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D69606A319
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=JncvfT2o
Received: by kanga.kvack.org (Postfix)
	id 0E9856B0ACF; Thu, 22 Oct 2026 23:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A6F6B0AD0; Thu, 22 Oct 2026 23:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6586B0AD1; Thu, 22 Oct 2026 23:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B59F46B0ACF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:29:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DD66A7BE1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:29:06 +0000 (UTC)
X-FDA: 85352459892.25.676C695
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E42A8000C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:29:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JncvfT2o;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792726144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY6PNPWYrXJ1vE51SKSZSX2JUaPuTiugkEMcschNNkY=;
	b=V3YvRJnHvwByT3xclkkPrRZHyPSeAVHUXGNYGMgix8lzPA9Yjl+KpvGMXx9qQM7MgaLucK
	Kv6vKQ8AgLsuE5CffI1iLSFZqebVoKWMODhZHN+lZ8HGVlO1gxUt5AC6ltb2MIpNfDw+fX
	yygER9D/A83yI6Par7Msa24rgQybgSQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JncvfT2o;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792726144;
	b=maBUPz7Z4TprgNCTQQts/m43dfXLBb35u5DBMfl9fEXbVpGvK7edfFU2HBvbfeRoRFFtKf
	e84MBg3JRlkR1qTfEKIs2N3aaTlbtgi63y0DvbKrhmqoc70/3S17a32DLUlLCJApkM4den
	ZJodF9nnuk8c3a+TEoqpDNDdkiW0IUM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dY6PNPWYrXJ1vE51SKSZSX2JUaPuTiugkEMcschNNkY=; b=JncvfT2oyvrPwwyPJRfav5/H4X
	5oU0JUu0Z3ErMABOjy0TKMu5/IrMxbIjRNj8foSiz3OuPQC4YzrPglPlPItdlFpPGE7cQ6+OAYimT
	8RFPHckxVATZH1rUbdsnThxnk5Xi7CurarzSBci7nOx6bMaB2HJ3hxuQ62PW2NattGYyXN/9fd9D/
	9gXY2gbgy+qQrelC+UaAe10koA0FIJuh6y6BaV/f0gGZCmTbvePYBOw1FNkCRI3qIyqnhK4y2FPnE
	kr3NXuzPE93VosJkF+AOCZj5S70V9j8yupWfbA9YArBqOBPpPTpb/lDdlUTueRxRGsB1EeS+u8pRy
	KkrfMjaA==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xK5xh-00000007f3f-0XlY;
	Fri, 23 Oct 2026 03:28:57 +0000
Date: Fri, 23 Oct 2026 04:28:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] mm/migrate: snapshot the source nid before the misplaced
 migration
Message-ID: <atrUeGPZgoSACpOR@casper.infradead.org>
References: <20261023023226.29783-1-laoar.shao@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023023226.29783-1-laoar.shao@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E42A8000C
X-Stat-Signature: d83ionyuhfzk5ibgq5nixbwr7gpfxepk
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792726143-417041
X-HE-Meta: U2FsdGVkX18qLx919a+wpZJ5w6ZNZ6JQ0qeqzC7HvqMaEQLWIIf6XFo1pPjrQerEBcHXcjlKZNaKi/rvZiDszDpCDvKz2nxzU3vdDyc2g9rHLxK0/YheykIFDnq9hs1ULF7M5wcATI1CVkNZrOgW5VGiGFqxQxo72RoAxRw6AC0JZD8O/ZnmQrOzYds7me4uUFaQwAXoWGV9y9dhiBDoCGWd0L2lDj7e5UoZkHxo4rEXF1MkiUYNhs7Ljr/K7JSBvY1X3rOD6FS6Z7+8RPSS7gIvZ6mtm/AcOkd/7S2khlVGuvSLG4elisTbTPTxedQvy888lHYQzFdO7i1JBOzUzGGxtKggc7h3Sz3Cfpiu++mv2QWvUqTTCudfmfoTR2Wt4aOJDC4RdQPXr1Kb2Pg6INrboXfBaWxlV3ucq3dUGxExPZ7YflR/1FvUgxjGDlUfzRtvU+0/nMeBT/oyzD0FY2voQlsu252kAa6P6SWK/YhIpEDouYUSwgR5kYrPkley7Hx0xbISsn+7beDuNHyG8T/V8t+DLhv4uzSemyMfEHrXF87FnjTo9vsZoAe6GLUyavevKvFdul0hRj5z3W+XicyUroVPEJ0Hp/jD05SOxG3Lyh5looSCieSqMye2FyHCXdhWLn6ICk/Ar5DVYTvY0fHdWdjySd4N4z97/gWH6St2xNPILHfvCauoXTy+0R1Ll+iOGQLOr2a1xbcOby5lUHehiR1ibN1wmPmn0MosD4cNm2tX5EiFH51dmgJ3QoZN0g+xj+/bdffDA4jpF2Nyq2aU4Pp4fpy9IcuSuAqVf7AfDW/r8AFF+MIIiLQjUgChaMbvalIjJoRqdRYmeOd5FXlGkYn6DMDBJn/vUukVKVSibWWI4dF4EsiNiqtQBROE2Q59i4l/uUamzMNaqKwdhWZV7vMBbjFYJE7OQwPKYnWqbI0v/5DAkJvEvj/4pVoPCZBmuUj6qxPy3lBOOiu
 4LO/wWOj
 9tWQUYHb1okVtURiV6/clVJMgy1XPlLK+59OWsYpX5BSNRFwKe5cmDghbSvLr16aRQynGA7b4L4Az4nglK24VsbtHRKW4npU2r5lOqA9HPY8ITcZ29gC4wLc/wojjipucKJOsRZYCXZxLLvbu/9x2N9rlcqNUnXgqmzn2iL9Cffl9wvyczpjZAVChIQfnOnSAmepjbNUCODn+pMNl29iznr+gQECYQm0+bp9gaN+L5nKj8sl1UXKScBrxWMH5xr6rXcUwVabudV9uB6yfsoiXB6q5vIdKNhgYvwnGEYWHIqDPcxG3430C1ewWRiVURnrQasiQOInDg1NOMML8KxSQuZ2vq4BumogwDPRk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 10:32:26AM +0800, Yafang Shao wrote:
> A successful migration frees the source folio, so the folio_nid() read
> in the promotion counter update can pick up a reallocated page's nid.
> Snapshot the nid before the migration, next to the memcg snapshot the
> function already takes.

I don't understand how a node ID can change even after the folio has
been freed.  I don't think this patch is wrong, but I don't think
there's actually a bug here that's being fixed.

