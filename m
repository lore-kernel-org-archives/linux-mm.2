Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99153C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3DF6B0096; Fri, 24 Jul 2026 12:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1A16B0098; Fri, 24 Jul 2026 12:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9D16B0099; Fri, 24 Jul 2026 12:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29DA56B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:16:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA29C8031F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:16:15 +0000 (UTC)
X-FDA: 85024172310.02.EE5A995
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id D18E2140011
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:16:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GUOTG2G3;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784909774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3WmRU0rK3NSBssLfskheuof5N8D8eRd0P1fh4GZaYM=;
	b=eC2V2X8IUBmd/Ddlr1c1ZoE7gb58HN5ioXm8CZgPRzPFapa7zgGaJdMi+ls7/KzdWd0v/Z
	wm14sVhAqk1jxTf+BuBPdQJRVmGQzLb8adgPLybj2cIN+SjHKMz6GQkLZ15480KOX8hjWS
	EfDRYdK6003TfFw5m66RKYdhq0iMZqM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784909774;
	b=1p5fvaxbM1Czfn+HCZIBdIKDmEo2NQAl9Jri/OvEggmpABSsa2q6jvw7oW4obtOjaA4WkE
	JSywRt4RNXhH/KsZWJ3Lw0i/XdHt7DAH3tofudFZKN/FRoSzsVuQ+aB0MAv9hPKYLRwj6v
	f2GI+Uf5ZvLF12bX6ZF+4dBFaxyaET4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GUOTG2G3;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O3WmRU0rK3NSBssLfskheuof5N8D8eRd0P1fh4GZaYM=; b=GUOTG2G3RjG5GfqbwCcfshxemE
	vYR//JBT7GpRxU5C2guOqa8rlG/I4AxBU5OhNlbW9+QC50IM+4sxDbWNOe3WrWlQL2SSZVaS6tVU0
	dmsUl9a+8CysAiRAxmS/QrsjO1v9M7VmOtKcF9JLnuzCS80hs7yOhkNaczLz0yGKBwhUTrQ9z8vwX
	F74Ao0CxG6ywYcQCyRg1smiQKzh1VCqbqaY8eXAoZLz1vHdzvHRPmTPJt54JxwuuF/LXCNADzLdlc
	xBUUd35ib1oFcyb9hotLF+4wUtgWG+pkgmxRnDcZNR5wtRBhiE+rqwrLdEpar+WVF2igQJCeyElpu
	8W630ghQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnIZH-00000003tSX-2V1q;
	Fri, 24 Jul 2026 16:16:11 +0000
Date: Fri, 24 Jul 2026 17:16:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 12/14] hugetlb: Set mapping folio order
Message-ID: <amOPy2SPO8845YNM@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-13-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-13-willy@infradead.org>
X-Rspamd-Queue-Id: D18E2140011
X-Stat-Signature: km9off1cs5zbgerzrxy38iqx7hbf7d7m
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784909773-688628
X-HE-Meta: U2FsdGVkX1/enbS23Vo6wY42z2JtnK2WWk+UtHPK4pX2Ad7S/jF6a4RjUwahisk6s2FF0cMhp5WTwHMBHeQLCfKpGOgqZ+pOkHUz4rwB9brmpuDTudAF8aflCB55YTg6uwHCxbXFjj75lIWap+fxecA75YMcByUccuIHHW8RJhwTFuXFadwd0laFnnO+/hIDx3KyDfI7C73VkOdmStAZa5l/J47UCNeH9NQ6EyFGEbiScWY9pkrb6ihlRP7WGCezc1nJlewOMqfYXfDNddcNWeCwACL6h12yg+i3HCcu+hXwPOG4kHAnsphft8CsdRNoCoKyPPxlY13DBYTnNbHjXZ0Em8oLHWWzvtIVeRX81C5zEZKpiqfp2knZmLOeXpSSmf+6gLhClO1CIBC/vwXVzQrJizgKODt6A3ZeLL6YOcOmMtGMZp2hB9gqskr3zCuGajx3zXQFnaQekDyEI62Zv9QxrQxkfvZ31wFLCdyMg9Q+5xT1KyDesHUhLjASCHC4lH3KrRWNbIEUikkJQ5wz5Avg0gPR2NyzJRM/PTbP/xHNpfzJhAmHS7rT1TsVxFNvM2RS6SojKCN0q+UvPwpKvkd5iWts6IkhbxTbDsJnUM1owEUFuPqeZ5Ri5BHe2kdYkcRP+B7L7Ud6PT0ZG4BuLK1RPaFA0RZ+j+hHaCGfiUytkkbXBuXunLiOa5wMFbx21E+MYzRTrBrm0AV3t0NvIkwW+mZ+KscfR/Gn/TeZCCUg/OosVCOqEyKN9bwZrCzsRMo5hzHY+cLHsYs4oCdkz07+xA8NXpcSbFoteP1dSG35rGqc5Na22FwkLZ1t4cNxYmZlPf0HcLRPWV8+I6sgZ8Shr8kz8ztM1+k/juSaO+IlsKJXQLRMPDLM+YI90JtAP5ioU71Sq2WWIa0/wnJbIcB0B7cM7RFR0+A1Bji7Dpc5MD9VzXU1Usm4FqimWpn05uLtw6JI+LKWKS0xulf
 G5sJZuNW
 R3E1Kx4D8X48t9yrzqzv0aTaoqNVM4zXaAz77nRDDRmaUiwPEi7vHhggJF7F8T8GqUl92aJSjdviyG+WmrzViT3K0kitOhp08FgLQNCRkQv/0jMbJkdjH0UhgPd8+ib0AXzweofP6SWsvtLqpNAa/nxatqRsh+qGzbYZ/P8QuB8fNFDdn+/EneuzO+oHoLtVUOjJNAf6BA6R+2GGIWlO2Dw3m26Y2r09ZTSTi8bj8wnL2ENTAPf+nm++zr1HjSmo0yWmfMWJRliW1jCmEEt7nN+TTxWqHDmzYsREwpOmwPhHlPl/qf4jp9aPoRdTIz2e0/Ped
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review indicates only the problem in the previous patch.

