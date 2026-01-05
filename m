Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0677C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF636B019C; Mon,  5 Jan 2026 11:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A69D6B019D; Mon,  5 Jan 2026 11:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A95C6B019E; Mon,  5 Jan 2026 11:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3256B019C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:52:31 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD78688EEA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:52:30 +0000 (UTC)
X-FDA: 84298503660.16.B1B6697
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A63018000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:52:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cFGioveZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767631949; a=rsa-sha256;
	cv=none;
	b=C16GeBd5NfZJD8Nv9nBBcNxWMomlsXK8OLLzYga1rIpN0Meevt/2Fe9YH8GYTMEB4xi/zM
	X8jtvecGdYg8wXUj7cqLFXuzbk0CadBcu1ke8UEsmf7fYHUZvRT00q+he6AYolayd3Zm6e
	mLqQEuEPynUzRgV+g5q50eGTD5E4uGo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cFGioveZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767631949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXq5H3Bfb/91vnB9/XZLlfCsK67+89WJtiHWbgZsyck=;
	b=C5CU9mYN64w4QXKzgZNpy6MckthZ2VUe/q4dNJqaoUPCPZt7VrPv+9/+D1PDJg3S6Or1D9
	up37t6KdbG3TcBGpUdB/ZFw22Z4Jzhl7vZlnTcBwS4npbGkV1ZCRBKqh18hCsTdojkfsJL
	f/wk7mMz4jtPfLjsaIT8IaYr0R5dUqk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OXq5H3Bfb/91vnB9/XZLlfCsK67+89WJtiHWbgZsyck=; b=cFGioveZoA9zgHW11EqnhK6ETk
	5XVezRmK3Vs9DFpyljyxiTOStgQ4+x0H7vf4N/m1mOh7FljVUSkGqCnQNDAjC8FSUBNJlv0+FrZnV
	ib2EM5VA4/o4j4flCWMpuaNeNafoUjdeG4X1ocgGWcfp5nCa0g3CyvjYvM/XeTs3FqFkIWxFoHuNO
	fpfg6UReh8MuiWmzDHnu8+AXy3EFfo0IosaqVA0bLgAFCDf3Iaqu5iuj3EcRcJreousqjnptdpUq4
	GoVQeWRk1PIcxsQBSd7LIbpBwjP4Jg/QGAnluLp1/u4D+zoz4uGNWc/MLQkQW6DZWJrNi2aNayKDJ
	cUJUPmAA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcnoW-0000000AdJJ-1XDL;
	Mon, 05 Jan 2026 16:52:16 +0000
Date: Mon, 5 Jan 2026 16:52:16 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: consolidate order-related checks into
 folio_check_splittable()
Message-ID: <aVvsQEt-za4ni_P4@casper.infradead.org>
References: <20251223122539.10726-1-richard.weiyang@gmail.com>
 <20260104023756.jufklyl3bl64fnck@master>
 <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
 <38555ccd-c241-4781-ac8c-ca50e1de7309@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38555ccd-c241-4781-ac8c-ca50e1de7309@lucifer.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A63018000B
X-Rspamd-Server: rspam10
X-Stat-Signature: jaqe9fmhosyo71ahh4cq399migbqyaq4
X-HE-Tag: 1767631948-527197
X-HE-Meta: U2FsdGVkX1+cEQXJwu/X75Uel8cmYvHpwByu87zYwitb8WRnpXqDrstYQ1lbrxGY26g7+bEMf9t+3Dx+W93/5gmq7YSrajZUoHnnQWkvUepzvQthaiXUZMyZazN4zHqBW95TbqHcn0dz/pYPCU5yUjwjYZ6MpnLp/6fKNty2FniJt5zwmLDyr0p1rKTcVtV66S+38PxwdKHz1gFMnrx509INKhCy/oRJbY/CzH4P96OHj9/kRz1sS83oKCMeHNopeNHB8Inhr3uVPBKpBKftPa2c6aNB5X3YeOceKuz49mVH4RQ/1uy9yvCGlS5OM/jWcUwX2Qab+LvCPgl3RIwL3zYcOnmk/H3jgovDQKnEjFG62N3i4T8Zw8D6WDLRF92RQT/bHGKn+c0bHvrqJscfwQNEyk8ATRLV93yVIAPtqx27dhlnbIo1TUJtf5dG39IeS+5Vzg084zqoJRp6RRg960X3LMMfl59cB18qE+4KnmABRPCyikdkkSB5SUkr6Bx9ApWllHhpLe7JxyHty8pfsCt7mL8kOIorGGoDxj333rMlAZHnTjx/u2i9IrBuJk2laPB1idlRtZoiXx/PxC8prVVavtK5tNwcU3ICm/o1o/sOoeVTuTRehZpSmTg91iAnnusjdysl1tIYHnr29acpy5+yekgqDlT21NLyrbXnSXhye+Idi2v9reE4niot8+9VWgsHVpAsTwmJTUaexKrkjPouVyDh14MJj7SV8UIRdHa0W4inI8pNg9zNZ4t5LQctMOI6y8sVzHW2oIUFGM+asjofcuDG+SVjUpP1K7ZhC1wz7lxJ9sJbCjN1CViz3ieVtWnMY3xPlP4pOhXbkvp4DLgrKTsJOzfx1J++V0n+1vaTIJAv54LGCNjpYKa+W231cYDHovMJcyND5bWFyKffB2Xa7H00JvUO0C3U/9R7XjNYLsodQLVTFmLeR/fqp/IqUKc8puOcaN8wkizlf6u
 xvbytfiu
 iScn92yaWkSqxd61cduXwPXuMFK7aspApzzPwd6p+6vEFNajLqy1tWPNOAtXbU1EdRWQgCAUF/vIgQtM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:29:30PM +0000, Lorenzo Stoakes wrote:
> Honestly I have repeatedly told Wei to not send series like these and have
> been ignored, and therefore I now ignore his series in general.

I also have lost patience with Wei.  He's been contributing patches
since 2012 and has not progressed beyond cleanup work.  I'm all for
helping new people along, but the balance of "time I spend helping"
versus "time I don't have to spend just fixing the bug myself" has long
since passed a tipping point.

I no longer look at Wei's patches, and would prefer them to no longer
be merged.

