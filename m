Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF5ACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BADE6B0088; Tue, 12 May 2026 10:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BC76B008A; Tue, 12 May 2026 10:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381646B008C; Tue, 12 May 2026 10:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 229F96B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:31:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADFD0120509
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:31:38 +0000 (UTC)
X-FDA: 84759006276.07.4356E70
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8273C120004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:31:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=w6l5hJGt;
	spf=none (imf29.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSyQLJxSsL0bCWnNBg6NGMoNuakk2nc0J3zkOk/uQIg=;
	b=nFwnFxAXA1YZWpFs5HRi4aCbhg4wyCH7X30ZYWXlM61qv5hX/HVymTRTVjiXBnWeCQjK9j
	usCZekn431LcDIqjQhYN1xiyyp0cKB7L6PpHZH1Xp2gjCGaBvcDxfS7h+wC3iu3KFf6mVR
	d9DCNGroGXtpoLcooqPNkwxINFSPxms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596297; a=rsa-sha256;
	cv=none;
	b=xx0Q75cyg7HwYY4o/+yaCh1DpfFL8whVOW1yW/LvM/pivN+d7CV5Jr/ud8wNiD45aFq+EA
	qxdOilqBjZweNDUThBZUFqATDpo5G85UsUqCqME9S1K057sNBJ8X2V+s2DC2JtbyjrLfZo
	d9T4u2AJSigp3jJDrBDBtyFwk109rnM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=w6l5hJGt;
	spf=none (imf29.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zSyQLJxSsL0bCWnNBg6NGMoNuakk2nc0J3zkOk/uQIg=; b=w6l5hJGtiKqlAWtdkEunFkEhwd
	EqPwxdQbVxIl0P2XIwxiTNKLM4WijJVnpn8X7B9c2pMp9bwoWoSVaNZgTUIdJBb3wcTXHWS+oEUu9
	yktUIV26qndpP+oiGYcnd7I/QUfjjmLksM+7KlhGJNfTaPjtG2u0/Z1maKWFRZ58Ci9Xb+j6AKdVA
	+83mcA4TUNyy+EZT1W/zH6ujynL3+U/ydIO9mLG0RT8SAwFdkrRsI7VCI+PUZfjhHqYs+xabJtb1C
	6aEVJxy8KW9NflI+fmj5xOANDsPLCS4TIA4xIOJMEsS+iItMpbGxatkL7kJDButqxvwYZMGyEf/hd
	p2AjUjog==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMo8z-0000000H2fZ-1mId;
	Tue, 12 May 2026 14:31:33 +0000
Date: Tue, 12 May 2026 16:31:30 +0200
From: "Liam R. Howlett" <liam@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tools/testing/radix-tree/maple.c & vs | defect
Message-ID: <d55seaqi3srxbpepscwp6ibul7f4je2wyxwsc5uwrlawnmb4ss@fqrbhgdvsdz3>
References: <d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8273C120004
X-Rspam-User: 
X-Stat-Signature: 464gp9n38ntopstqhohm6n1rcxisdds9
X-HE-Tag: 1778596296-154140
X-HE-Meta: U2FsdGVkX18C+27bjMB6hzQGXPg+EeNlMOWBcD3skqiknxi1Jdofc7b7Wk04gREAVrmVsVyv8pW5o4eqbFeSDAH1g8xs6cMu1PFdsdfGAbvphiW8kTAJe1pDeiRVaIzbo4kRhuKn4mUE30GLf/qbOpTPqeIo1rkLuuL7Vaaxawbl95u/qaXQPNFcS7UQCt9cNEga0G39Hdxj5fdNzj4et3xKN8YvG295gQyXIELZOo9JnMmI7rLEmCWwWapPFDq3BQTrxFz+h5CHSWZI00wdVqFqFfj6uFTethyv8hOzqvx2BW6JzzXJCv3CRkfK651J3u4ZbtUMvpCWvf8pGyBzYsA52zsAGKDHoI8WAOc8v288tiSayIuZ56LjcyQU0pl7R5LDgF+y+GimEZED3ZqCc/X520WkQxuaOWuQV29/jgtalDOQgzT5QJsG8UNCsegZ89GLZNnXD40a99LybJg1oN5k855xgbJY1tWByyrMlTDMKkBPUemkPVw+vFJJsIeCrwpCnqZYObhPHl2o/0QcTukZsUz1JYxYVPrUb10jvh4nBE/LfNK8CR7ZgyjEGEa5ddVdxwvizva298oPIn121soaoMvpewGpykXgj4WssZUXdx+Rc+6Se+3k49zM9t5pdcZDg4e/xwdbeyPI4FXCzM83IeGVKsZlZyoV0ML9Lwj63EFb+edL/H2YLaYOzdjaE6iUOkj8/qa+VOTAWPwqS0pum9vas/wNyPNvvphAQT25py3ADEHPorpeGSBwkdVqIGcnxaq8jNb2uAeZFH7LuJWWurw3hkHDlhuFqTc3q7P5nrrVG0NYWQHYhVek6oPTdHTPoRCa1bdzx4cUM7cNTcDBAKxyOLNZlcrfT5bxbW46eumZ1NPFYHtl4b7x5hgNfKntaw4BE4niIZHFB5N9HUICKLnr3ft9wEl0w9tntHJfJPv8FhtFNNiee+mkT0uFj2cIX8x4C/oMtLHac+r
 hPgtAB9P
 dAToDhvrI49us7co+AnP9x8JGyXoX1NVk0aDufR39YoXTjdxHtbPVNyLBqAru3u2SbDOtnRJ3KHF4fCflSlgJOMTBnjIstzdyq8LZ8rsMdzeIXeR4TKs4a2fzPc7MazGFK/diUhIlC9ksup31nxzYQ4wD8S94jhe+BjPOhkEi2Ti/IiqtKwqyPOrHkZUwUNsa0kyjoIQr0Cn79YnjCr+Cdt7TU1U3BE5VxJKJsjcRVNmr8Xo39uzVqcfNEFyfxVqYuKBsgbBYEvWeTrYNTKc1191uUv8c56EosOF4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/04/24 07:38PM, Joe Perches wrote:
> tools/testing/radix-tree/maple.c:       MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
> tools/testing/radix-tree/maple.c:       MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
> 
> Presumably the & here should be |

Thanks.  I'll have a look.


