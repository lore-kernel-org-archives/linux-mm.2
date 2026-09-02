Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27219C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1C36B00CC; Wed,  2 Sep 2026 10:32:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2B16B00CE; Wed,  2 Sep 2026 10:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF566B00CF; Wed,  2 Sep 2026 10:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5066B00CC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:32:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DFBDC023D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:32:28 +0000 (UTC)
X-FDA: 85169062776.03.D1396B5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18E541A0012
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:32:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=x94EtOSW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJThRJxcb5ZyZDKnZjsJGD0FqhAXwnBk13tyzhihRaI=;
	b=Rnh7bJiTLrqynb4nWO92CUVbEHuDJFn/UXReQUa1EvrGElI5a357Vn5xA72YgD2DObNEiG
	Qcp2+hfxRiXbR5soDTHe8D6STkjs/IGi4r+FvEoBdW+NbkV5L6nOemAePxXjUZ4TAoXLKa
	SeplUN0sPGQXtR/3RTK7tgGLlwtVFd8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=x94EtOSW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788359546;
	b=TAOjvKmp9wq2glMfhryQOBTI1tpORbR0avxVxs08NLwFzqhmp0RPXqD3lozrg7e6qYDzaW
	7cz6hfgi0GXvi0EtlmaV1lcck8JQ7oQSUJuy7Go6A4xZERc0ajprjUJzFVNUErO25TDnX8
	22gIq1PRQwtvk8jymt5mEOEqZk1Ntz0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EJThRJxcb5ZyZDKnZjsJGD0FqhAXwnBk13tyzhihRaI=; b=x94EtOSWAUSX3HLBg0leRaCPlV
	GdYrOK9kldOMx2U6iAsjteD+CbZaKRJp5J38nHE5xU0/SqKFUSsFYLDFQOlP7I0A0chlc9KuqPS5c
	jjN4mw05LVyc/LlTQiQC5tG1k3jencqnNrEpbeTwa/xa9pb/YlqkX82VbiN4MjUodzkgBRoVVxmru
	ik7g4VQncUo038xq54h/Q/Qvz3dBxcmauqJNZ7Mrw1egTjB7CvK0WX7JWhtoTyMmt4Q+pC14wNH5c
	3XJPuldMR+kc7yQgXSgzHemS2PpNr5Ao+S6wUGd4PbSvUYZVw6q/qKt0vQesbYfS6EnKkcA9Sydns
	Dgpvhcpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1m0i-0000000ExMs-2Re1;
	Wed, 02 Sep 2026 14:32:20 +0000
Date: Wed, 2 Sep 2026 07:32:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] xfs: remove dead kswapd flag inheritance from btree
 split worker
Message-ID: <apgzdKWBDn4rpIO5@infradead.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18E541A0012
X-Stat-Signature: 3yxkxf7kaejqyhrr51r54yqukupupux4
X-Rspam-User: 
X-HE-Tag: 1788359545-437145
X-HE-Meta: U2FsdGVkX1/azOAa8r1gC0ItA10/Beisb6QlwvdPDJW3QbOsmYrZT5gIqwShTs7jR4W/rdDB26Tr5q21HpnjXb8EFO+mwWfqeDHS9hiDtd7VCG1GTuz3dl6+GwXXMMuNXaRr2owZ/BEBImv34ScDx/1VC2AVhack2kuXnqOIf85+uFruT0ZmnhWn5WIPDJNh4eYdS/VoE682oY2aox76qY3ZmCKDEHIYHzDC6XizMQkjnHLtAOutZnUyy2AN+lN1dhr6WqaVx/pC+9UWjH5+pgijxyX25NI8/7Oj3reGY9O8DsunG1aMMRh7RRAL14UxcgtxNdlqe97eQVFDO0CMxszsisSEiYRE4hQaXDDHzr67deYJpVFgMP8d+kun5lw5FNryNfNb0MIA43lq7RNsaT0db/apFgeJKstI9ammJzdQ0YfZiYLSY5+9zQW401hxqjoLAlxbyDeeAk6LdbAga2Qy7mIwSHssEVvvQMy7CuLwZkEMGyHwwdO1HbbAzupjnongbdaVhMW3PikkHv3zWKMb3VmVUL+geS+on3U9tQ0DgtOhMAc+va0gffHcnHnfqMTshfsxSHwI+2rmRA0q06dJSUpg1nimdJ4qr1UU4Z7kkGbkCGt3+d2ee2OPhAST/iJ9mV+9ocsn4gwl7fCbL7ixSymLWzbngsUmHPNBThSSh0Fj/R2n+IoOzQNPKAQwXhFvtbIXuVyC7vWtwBwXDPAwEPzvIs7xfZvsYR8Hku419gz/29qZBRx9HmhZzHdKnJozEYnoOKmD3czR0CZ/ZmPFaofCm6pkLZV04tklH4nFF5ejXFPgo3qCSGuZ/qpxTq7dRjLcstN858unDAJIhRxMdk0nJmgwygA1xVjCbdVqC9OajZj5YkJKXc9lYvY9rRI6WvoPZnSDJyoUY+CKKbT3uz5KPCkFraIg3msOC0U46g2YU/jmtY9NNr55WNC993ygU+dWGPYvvPuT/Cb
 nBCz3u5J
 I63RGlSngk4mVaLVxA5jKttV4KO8+EAqqpExWHQ25J3s0g+BfiwLHCrvIr3fiid7jUPgcnHbQXUaTdrkKqOjhFVxr/g6hWnuvQJSS8KT73O4P/U9Q3kCQ5ot6jwPoJM2AeWZf8VriAntgZqibbuzhLQio9eexfKmXxhipsdj1XZIQ3w/dxcV0uIJmi+nv8e0FZeM02MkamyZv5KxWBF+nnt95CDhXBsrObytwBFG9fjhv3ykGirzxDzpWh0/0vkcrKnFAgVP5QtuIeCzxQZ2PlHUec6/lS1Ouwk+OsaecmDEttU0HwPzLd4Jlg3sVhNe26X41YRAPMofJrMElaMbzWF1HMy5/adfVn43q7YCmRcOO9XOc6gyRgAkyL1paADoZV69k8lOprA511Qp6EplagyqKl8YnCp41vmHalB9ggf4TAkmP7UHwwpIlGxycpF+wkX5qbNJbaNDMjqS4O13kHgbul6NtOji4d4jB0pLI60KLRIBRrxlCDv9rWmzSOnBUeL6AmxRnmaWziW1hr6VAymw1C4aND5ZEtWTl7fNmWMonjAacYh3Ywyg2cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:16:50PM +0800, Kefeng Wang wrote:
> Commit 1f6d64829db7 ("xfs: block allocation work needs to be kswapd
> aware") added PF_MEMALLOC | PF_KSWAPD inheritance to
> xfs_btree_split_worker() so that block allocation offloaded from
> kswapd to a workqueue thread could access emergency memory reserves
> and avoid reclaim throttling.
> 
> pageout() no longer calls ->writepage() for filesystem folios -- it
> returns PAGE_ACTIVATE for non-shmem, non-anon pages.  kswapd therefore
> never enters XFS writeback and cannot reach btree split.  The only
> path that offloads btree splits is unwritten extent conversion at IO
> completion (xfs_end_io -> xfs_iomap_write_unwritten), which runs in
> a workqueue context where current_is_kswapd() is always false.
> 
> Let's remove the dead kswapd flag and related codes.

Nice!

Reviewed-by: Christoph Hellwig <hch@lst.de>

