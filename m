Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1850C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935C86B0255; Thu, 13 Aug 2026 07:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C876B028B; Thu, 13 Aug 2026 07:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B3D6B0292; Thu, 13 Aug 2026 07:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 609D26B0255
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 049811C0066
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:50:39 +0000 (UTC)
X-FDA: 85096079040.25.AABCAB0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id CCD024000B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:50:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Vo3HK4Sc;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786621838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmWE56RD/47YLwpBg7jMd//bb0JWz/XaJINUJAJCtBI=;
	b=R4mqVDBdpzvOgg/Mn6bZup4KIg4QM15g4PS0KC+S4wCnNXcMOOjfVVBrfzXt05xnLqbKQJ
	852laRVnWTWgKOFQkSF4MOV1MpulXiBZFZzhip51Jtbwn7GLcwUSnuLYrr5PjY6hKfZ7sa
	qjhv+vc5tS5NVlJlkaDgLWWImeQQo34=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Vo3HK4Sc;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786621838;
	b=ausCgr1OegIq8cQp79Wt+Bfn1/ZyyyDX0K0LqmJmRANDfjtol1OwtkyyFZcifB3QuULTcT
	qzetLkV4Cgq96PFyZI9qBMfJ2GlRjj7C4/m8CBcInDuGS/YhErgKyDs0PhHkWdaakeiHFj
	d1I+nqMiSsOkG3zrjHYf3V1I9HS161k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YmWE56RD/47YLwpBg7jMd//bb0JWz/XaJINUJAJCtBI=; b=Vo3HK4ScYRZ7QxGq6/fxgLrCM+
	kKgsx5Jz4Dl+Rqv5hmwpcI8fXw6q2dKJOT4+MYZRHs9YxOExPtLJLKE1RJqJKzOOyYHfYU8ct0MRX
	dSKHnI02X+AiVsuOsxlro+bEf9zm6UY4mvzxziSn9pqcBllH+k3p5cOAApXj/xcu18wMu+8xOZkfx
	B0hlJZfZPpYwTyaUPns+kbUz9K7Eg+Xzzj748baAJ9urv+N9gqdvbY1o+zHXB5Syofr4Xn/BpS3Ue
	xUh/nUy+GB0BxZ1gBEdGE1dYKYinK7jucLyecG5Lnplvo7OZJztwT7KhH2+QNutzxFmDAUwLvGoGi
	j+IdbW4A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuTx8-00000003X9f-2ULy;
	Thu, 13 Aug 2026 11:50:30 +0000
Date: Thu, 13 Aug 2026 12:50:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v9 05/15] guest_memfd: Use folio_has_hwpoisoned_page()
Message-ID: <an2vhg4Uvdo52WPX@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-6-willy@infradead.org>
 <32873b50-c900-4fe5-9dc1-cb086bba77e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32873b50-c900-4fe5-9dc1-cb086bba77e7@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCD024000B
X-Stat-Signature: setxsctmktejdt1swr4fageogi43q1q1
X-Rspam-User: 
X-HE-Tag: 1786621837-415101
X-HE-Meta: U2FsdGVkX1+diRG2HNuWB+0qb27RHZKMaQUlRIt879RWVgSZuN07gB6YqXGaxH3qTMNMFvys8JYlx2fSMAHHPy2eB56046f2+c75LHx3T8xiD/QlD/rk3QAwPJykxdpfDnr845CRc7RVUgMce6FjarRid3nYzjKDjZ+oxdrHZd6Iyj/QmF/d4Hf7JNY0ABKHiwpb4c/jn8FhtruBMIVDZvrrPsj18cuh2XBsYoYhAOqv2WzlL8ldhCXQ1tqjCbo8vmQzicY4IWxnf+owGW2ZAQHk8SVl1vxRVsBuZBcMSoz+tADqMdsOl5lu4crVI5e4EX6sg1baDp6Wk9CbNIbx1+5pnWZgIAY3o7C5H/0yTds2tCwkPIQJEOS7IBOyIF927m17J9KQZqcYg8SOYG3f1cjQ8nUtJJQAPQ0z8FJ5EmwmcZGdKtnc6agh5mXEbzER5e3l4bQnNiejcJzk8LssGzLuyBBgdiwRntLYR5V1olCWOBpmLy9AJcHtFniY8XZhQ9vt+BNlaQKg3QRsnxVqGFdT0IKHUXQu19raUhTJbiKN01vZ8/pXdJnxSUlwRO1zkn7JP0J2lJuJlodd91TZOc89IiqfzOCwSHU8Q8zTOzIjQluFOA/KxnXAyNzsm8aJeK/RNgtUh3uxWuv3VlMYk0vdqQhKlkc4UhzSGy66sChbppkmxxRAi5x7G7qKKNAuu3PRlBewBtp/56UzYwzARCWuw5r2oz3QC2P3N59YIOBSt+z9MYdjzBXEg/pAb1LJqvlMSpoU/kaIVwffVYi9eTXct/nS7PBDzyRBNrH5cIkF2rDupNsQIO+S7t0KB7mr8Yy0xDT6BvXez5XW3O2feWDzZmgqG/ev6xFaSF2zNpFaALjpPnSeX8BOuNohMFWtbdkq6m2UoQLCdGpjLt7n8z0Toh/BB5SJ9H+CZeEelS8X5WYvLByHdymhsYKGxDamDBCwmWO8o7Q/LO8V8IW
 WZgWzC4d
 7hNjRCqXW+CtitOif5cytfToBExxOkwd6r02YKwsRDEzoOQYMtt09zRrN+S8FXQnab22YgBmaX14YW7svvXAVLNZI5uZUMX0yG8RMYMSPBVC1jxHd4JBtcKUXvA481r9ol4n6AG9SApkS6XSPS53FO6PbBMUd15ELwqes7lV6Ni7emwqPaU/0OGZlYZrL/WK68CcA7TGG087FOyWzFu53a7es1rdr+5oXw+qQIsuJfa+6ndUo4zaGsX5BhOxvFb0jPzkcCrRBjRhSjdnGzQcN1iJjyQ/ly3+TrrIwiQXTNX07WUu7xhLgmgrOD1CGwugVNMNcdzAlJLvBmYDPksu2tM7MkpoqWcV71OfPc+x3IgluiYE6crlbp/qsWxiLms1zAeQ5q3I7zNq49iCzmWqDPYDRFBWNLIfTIweZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:20:54AM +0200, David Hildenbrand (Arm) wrote:
> On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> > folio_test_hwpoison() only works on hugetlb folios today and will give
> > the wrong answer for other large folios.  folio_has_hwpoisoned_page()
> > works on both.
> 
> guest_memfd only uses small folios, so it doesn't really matter.

Well ...

virt/kvm/guest_memfd.c: /* TODO: Support huge pages. */

and one of the followup patches I have actually removes
folio_test/set/clear_hwpoison() (it's a bit churny so I didn't want
to include it as part of this series)

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

