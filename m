Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03E9ECD6DA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA58B6B0088; Wed, 11 Feb 2026 14:28:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53126B0089; Wed, 11 Feb 2026 14:28:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F326B008A; Wed, 11 Feb 2026 14:28:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A165F6B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:28:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BEA08C043
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:28:50 +0000 (UTC)
X-FDA: 84433163220.17.E4D9FF9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 04DA280008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:28:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c0BVem6M;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770838128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfcWTsASilNas6PFhzjcdZoCB26vcE9C04Z2aIN7kYQ=;
	b=KJe78B3YJSrfisu89UDCxAsDjyF9oeS49qcjul/WR48OZZ/a8BZaL1WLTU95bBsOzT/JYS
	ttuxcTtnCCeNXktIFyUYbH03jprkcmW7wIeGPQAfx5fQA3WVnLa/G/k6UKyQrUJNAD53yQ
	5FUHybNChBFBXfaLzowX9fLfePG0nQw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c0BVem6M;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770838128; a=rsa-sha256;
	cv=none;
	b=SC18+b6u+qp/i/14pVoX9xqvm/cC3cFHO3o6mBB5XfTTSi8+20XY5bN9W8phdISC98J2mx
	Wk3bfy9ZVMgVv6A2u5dog0ILxGLP/E5M/FvUPvgqoFelneyfhS44QjNYFRzavWwlNjALGI
	yVR1wZ17s+M4zVmGvAfzF+Y1UevlKuM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yfcWTsASilNas6PFhzjcdZoCB26vcE9C04Z2aIN7kYQ=; b=c0BVem6MHbnA4jpUfZGF0UHvjx
	h5CycOS7eNXx9NOFHiV8l1UxnidrvOL2BNTXz5lnlqJa7KQIg9NFPipvkPm2RioO7UE+xxYk9/rqo
	AqYu0aAzJZ9uoJ37w4QHdpkrRaAfVzPDVM3TA0nUhK6EPWPKyHSpwnuEMReFn2FzSPnyN0dFeU1Dv
	jQJMTXuYMmkYpcm/YHOFUQsq1inwy96Qgg1nqyrjwXPhgCoKqIrljI3mKru4S4KS73gstDN2tzFfm
	n6oVzCUmzWA3YejUyBTudprHMx08PcpVcRDWV3cD6cFORCuMH9mr4Fcw7vvW683XyWB1zt/6rePwQ
	UtuSRMBw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqFt9-0000000D5nt-28li;
	Wed, 11 Feb 2026 19:28:39 +0000
Date: Wed, 11 Feb 2026 19:28:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	lorenzo.stoakes@oracle.com, linux-mm@kvack.org, fvdl@google.com,
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
	kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
	lance.yang@linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
Message-ID: <aYzYZ-QqQGH-dNEQ@casper.infradead.org>
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211125507.4175026-2-usama.arif@linux.dev>
X-Stat-Signature: a1neqmkm1obktygbx1ry3de5i3fbgn1x
X-Rspamd-Queue-Id: 04DA280008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770838127-864627
X-HE-Meta: U2FsdGVkX19YGLZjt3ztFRop7xuUTALTRZDFUOfsyVwXKtu4pIdLLo4AYDiUDfAZYzBdKFNaHMLQQeYYfbg+jEnQBYkNUBjtgUbEXEl49ttJBYBKU/U8ebV/SNubbcko4GECyFmves5wraj7onC1Z4eYGGQjl+TsOkSq7b+H3JQ8AXjVRpV3yxpjOfrt4l6SIxWkkIn9l2QofCs4AuSKtzYfg+J3fCtI2uFY36GYiicpeVATT/UAqpQhR3NbbBX7VBom5M/Shsuvq6xz6XTJOwGf0JMquAm8LcX+YemLVhea292tjW0rN4NH137kyZkhalj640WjNJ/9y2VzhR1alcYmN7D+ZEge9PB9lTw89nS2ubeE+VTAZTv0081KPw9uv8eeM4ay930ChfR2qTkjmvi5XXlK++bkAaCbASEb9Q8TW53FAEOE81uwQbDZe4+wgnhYNZOzX4svmY8uJahpH2e3DX3cHmBTFr4SnbIt0N97gFAga4xv/1xgSlKfxDT1BPOKOFdf1Kz5pIJNOeJ1Gn90NepHEqjC+nbtWbZNtgb/es6QfBcRmjdGzqTUUBaf/VVpO7ILm/arw/Zok+6dY90XUAbavHbhbPlsPe81XJS/ZXF+vcn31HOboTCb20SqHn1TmrcOoaeA/mL9cpIztihwbZuP5Uh1ijTJ7/T8s5cweAgPFb6c7io9L6QWog1vAdW23MhY2P939zLxaA3BS9AKJ1LXy5vvkt2XuSHVI/seq7rdxG0MvV0iyshGrOy1VVVvv4Y3nTQK7f4QpnaOMBghBsd8KmALQL9/b9g4XF/77upW1/F8Q8DBrae67IQF6uR9pJ+OCc6nKJy9Tkr8M/5O4eSAFDxn8i3MW7XjbmOqD0xo6vTxI1VTE+YPHprosFi84zTgtTBXmxTCO/RdAn1WZpkUOGilPij7zZuWuarbpMdnmUzJYeeTWXDH7HDR02G1ZMLAQF3zfi3QVk5
 oXCGfG1/
 eJWy167q5P167qPMM4SclTk19S1lYUjhscA3odRAk/LlAALf3fL/taeEYGwLnl1lxmcVRlAKlBCTNPugTfotets3zIJtY0WWUQgLbN4BFO8fp6+hji4iuOoM1UvTMv7SZoWwI0xwF+65EDJ0iaOWopGQFyxFFc/qWN5l3pOmcRoULjUC4VJzA+ZoZDv7q78ThYC5+kLyaBH1l1FxtjLLWOST4irTkistJsr4o343sx3AbT3c6q78HuTjqVxCFg0fg3IuW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 04:49:45AM -0800, Usama Arif wrote:
> - Memory reclaim (try_to_unmap()): Returns false, folio rotated back
> LRU, retried in next reclaim cycle.

I was advised to ask my stupid question ...

Why do we still try to split the PMD in reclaim?  I understand we're
about to swap the folio out and we'll need to put a swap entry in the page
table so we can find it again.  But can't we now store swap entries at the
PMD level, or are we still forced to store 512 entries at the PTE level?

