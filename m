Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFADBCD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 15:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93E36B008C; Fri, 19 Jun 2026 11:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C5D6B0092; Fri, 19 Jun 2026 11:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C706B0093; Fri, 19 Jun 2026 11:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E91E6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:48:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F0D11C4F5D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:48:00 +0000 (UTC)
X-FDA: 84897093120.20.B587F05
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9CF4D12000A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:47:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=emnBCoxh;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781884078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfKo2wspR7EV2HHC2+9uw3pSPIolUFG6rWkQIpzJlOs=;
	b=b2PzgfEW5VcM/iZb9f2c28lsybatHJk7UTmcgh+AZJ10AYxIpx2LJEn18/864U6fKJCIOa
	S6IwlppzJXuh0vYWkufo+Mvoh4vSovmAVhrGzshr2zzP1zRj5dvlHFD5CPByrnd2kxLFLS
	khpy451sjeb08urCGVxOAkzc9fTCPgo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781884078;
	b=ayCW257yZ3sTjAW+uypmxU0IshDdLa+U7TLnxK6rQSzr7TPBuH9PuBtftx97RNjt4A64yI
	L1xI/wO51CS5rEWqtdMukQcKmwQWym3aLjpI07Kt9bYumQyAY76uHCVUySXmU7Ye72Od0P
	0ZHz62UWjjXZFiI+HP+dvTMFK1mtadA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=emnBCoxh;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qfKo2wspR7EV2HHC2+9uw3pSPIolUFG6rWkQIpzJlOs=; b=emnBCoxh4LtDZ70xdQKJ8Hlrdk
	Uq0jDdn+bFsf4zJPljL+uLVGPwNuGAPbXL5UKeGvQLWiFugRwCxYcI967LvulUqgFoDvhaKTvwayb
	KlkWEqqc9kx7Hj0B4vr7TW1EUAAtOnsRVQCYTuT8KB3AqzgvssMUAksOv7OzFfTffZoan/OsgnP7m
	hy1QgR0ua1HrxAealyxuHCYaThzdBZ9mKPwoPmBCNa6LvI2lzPvOt1wvAovuYBapdhjbSn0heHSg8
	vQSlzf4DLhFpEkirgOqiJQh0soLOAEIgDvKr5on62VYi8U2w6yx3OphQBY2BJ5HjyHwNzHhgHkz93
	RfKZRlBw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wabRj-0000000GTP5-12YG;
	Fri, 19 Jun 2026 15:47:55 +0000
Date: Fri, 19 Jun 2026 16:47:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Frederick Mayle <fmayle@google.com>,
	Kalesh Singh <kaleshsingh@google.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajVkq52q4VFsOkmb@casper.infradead.org>
References: <20260619112852.104213-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619112852.104213-1-ljs@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CF4D12000A
X-Rspam-User: 
X-Stat-Signature: rwqqy9moy59tc6icnjp8wcqd6tgbe5xf
X-HE-Tag: 1781884077-784536
X-HE-Meta: U2FsdGVkX18PHFoATI57/7owpbf9c1oKPGhSR3DZoxJ4NFvAF5SyD6/C7jX5BhDieaJTsuJ+TcvjNnHq/gxO0h4gtAwQtKG6iDncUS1N15gBzxGLpEqY4QK11CORsITMAPHzbaaigE/1FiSGnCKt+NNseWol9b+WBocFhlgjW0vpr7NbnV3wqPDNG9FdThaxp5Wj48u4Aik276Kwcv4sPPxs5grIE//v8XqnXVnY09Oy95zJ7pIyxhydADmkUYmr6PTpBqO6Ts47dw/KYPBb95DsEiH6K578P4gn+v7oC6Wde3INq/Fe//rCMm7jpgMoRTcNistzz1CZxi0ZX0wE8v/G1UZ0wjYha+SgA9b4Uco/bg2cFAWLyS5UqaH14ioX1fLPFuo5wAA8R6Y+Y0nH0RNYxyo7wF9m6+hY5X+2nwLaodZp9OWBtuSjoEOvlq125gUnkrci252PE7dxn8ijIh8Yf0dZ1mNNL98C3vprMFhBH/E639fuHbdTnBQhovOkfDwH0Z7kiVQouoZ5JR+0V9kupPKC6zcaIrsUcGLa8Pdtns0JcCoWUlzhVPIx5LxunYko1aR3e+XdxFiMR4Q4HH7FqJ+w+i09YpFxLce7NE4B4+1FUD1rQC2KXcEfyQA6nkbJ13/DEuE1ADTWGb7ySIiw9JJUhhuLwiM2DvkYgYzw6zOlrg/AO2SSwo4Kvb0s4zmcTAVnBpSnV3aXzwYKZDfRiqMqk6dp3TfrMOV8lCncoumPBGLaGw10Q8xLL0IlPgp7biD0pmZK2EREVdwsuBpqxZRbMaWCnA4+RaFQ7Ube6y5jWzgURV/DYlD4xZ9eLnrEJzrVJWhrwGqv2OB6vQD9sPm+O/rdk2hM1Kwhr1ORBxsiAYtVgB6Y2bjyXHgnzgN5pcDRIyTbvhMuLt4EJCKQWWjzn9rLdyrfTAAtbR43ShUeqfYCp75g/8vEfJ19O0cLYaMjF6n9XLCXP38
 Y6t5MCYo
 6fOaiah92owPKvFSpq6Nqc3tWPyloFLL12dsdS1m+quHTqv0wV7nclnE3Vfix8feXUEfcnlp1aHYBSs7GY47zOTEonxLyxavUqxp4EOps6LuRtmrthxfwBUL/3TRJ8tnlrvoLMzdpDfVhS42Bw5SAMkkmHfyL4KW8USO2K1jwYrfd4/Gmhxk6iPV7XIgi2jBBW7fh1ZKVBbJcLyhXT8uDelbJQVttRtXoWBy1VngXHdwYbnIgLItvJnwtuxRUF9aXaC8EY/UscVoZKBdWC81F7dm/xy+uCiPUKf6ADPciM7HHikzRE7EFpmmulf8QADTlT1aPP5FOea69SJCObioGiOqCVN494z6E81Vi39uV9qOJpGfPW7nX5Eq5pu7R0vxhdcgFcGCJoY1iN3d1tIuwa9MLgq7TMQuN0wyUH+td0oeA1UkHgr5RtnWHcSbZ9oc+xF9Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:28:51PM +0100, Lorenzo Stoakes wrote:
> This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> 
> This patch caused a significant performance regression, so revert it, and
> we can determine whether the approach is sensible or not moving forwards,
> and if so how to avoid this.
> 
> There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
> PG_readahead on EOF"), care was taken to ensure that the revert retained the
> behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
> filemap_fault readahead to VMA boundaries") only.
> 
> Fixes: 7b32f64bc512 ("mm: limit filemap_fault readahead to VMA boundaries")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202606181547.617a6967-lkp@intel.com
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

