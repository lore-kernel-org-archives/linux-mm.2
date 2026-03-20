Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FC51099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CAE6B0122; Fri, 20 Mar 2026 13:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DC16B0123; Fri, 20 Mar 2026 13:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523746B0124; Fri, 20 Mar 2026 13:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE266B0122
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:47:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4C9C160331
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:47:32 +0000 (UTC)
X-FDA: 84567173544.26.4636B51
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5E69240006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:47:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=T605LByc;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774028851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBrE+ETl3QSBu97biTA3vK5m68jytBBGssPNHhBNDT4=;
	b=nZANZyXrb0c01AQun4jx0Li8xYnkZ3s8J9j20VKPTYqJLakqKQpoZkAvi8qEFwO71icRul
	4g2YzhqfFTjcn9+tdp+NkKupC4XfHOetPnvj4MK6b2eeLwTAiPaHXAJrDOQjqrhJhfn6SI
	fH6Gg2soP01QGC/WrB+s5zfwk8dqG4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774028851; a=rsa-sha256;
	cv=none;
	b=0exKL1naevpMGY2zfosHz3DJ5GPuma1OIpQKzInXtjaLm3YjEBkLJPQcuuMqsB8v9JO9Ir
	TZUT/T9mQqVRMnoA1yzugcED91jIQtTjMuGROgWIc9vwMhV59IzVKjgB01gkkhKICXKWxo
	yz8E0k6RmZsQbP3WOGOwFrEAtoh8MeE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=T605LByc;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YBrE+ETl3QSBu97biTA3vK5m68jytBBGssPNHhBNDT4=; b=T605LBycL3rI4RFN580+M7TbGh
	aCtU6vIGOVxGUwytuHLYp/1ZLkr27qP8DQeq4BOYtdqrVVL7wqOyT5X593nCLlATcEz6u0jOP573S
	Ui6lMu0pcx0mOEggwfgy/xeErgiLPY6i5Atl+6FZuDnHJf/jVwDXtFVk28OQjIvLgQLqnccrJC1il
	ptJwQFvaNBAZEPXJGG6jm1esBTUZ7TfOux7cY9wHxOz0GGaGeCZLrlw58J4aim0VjVLtWzxZKjMv4
	ISz7tyHvSHWMmQuU03PUvGHLpCMGBRVES9neSGXWnsFJ6ZI/TZNJY3nCKyBuPApHpwPAmkHEihWgV
	BjW0+lsg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3dwK-000000088lh-00QQ;
	Fri, 20 Mar 2026 17:47:16 +0000
Date: Fri, 20 Mar 2026 17:47:15 +0000
From: Matthew Wilcox <willy@infradead.org>
To: WANG Rui <r@hev.cc>
Cc: usama.arif@linux.dev, Liam.Howlett@oracle.com, ajd@linux.ibm.com,
	akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, david@kernel.org, dev.jain@arm.com,
	jack@suse.cz, kees@kernel.org, kevin.brodsky@arm.com,
	lance.yang@linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.l, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, npache@redhat.com,
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
	ryan.roberts@arm.com, surenb@google.com, vbabka@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE
 coalescing
Message-ID: <ab2IIwKzmK9qwIlZ@casper.infradead.org>
References: <20260320140315.979307-4-usama.arif@linux.dev>
 <20260320160519.80962-1-r@hev.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320160519.80962-1-r@hev.cc>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E69240006
X-Stat-Signature: rz4jik8q61bdxpbicu56xs145joc8fdo
X-Rspam-User: 
X-HE-Tag: 1774028850-545769
X-HE-Meta: U2FsdGVkX18HoLsLAqCq12iwNBaFn1lNZiFPOnKqfpGf8F3VFh9GsNT4Wt1DTzr83EV/lPi9lAOdUywOXL2lrmLWZOlSvlYtBKRQMpqYRciZ5w155vSaFOD/hYHTz1OpQzTZ1YdEf8WlhaFLuRsLM3u0sB2JiW94xk8I6VWQTQ602AHer3xNGoQ/oDycRiEByRtx8sdAxj/eujqRAxPWFV1Rv+u8nFfjXoqRTR1P8OZlX6K01TeD/VhMmHgsYif3G+sFIfKjVaFNTi1yIlgrbJ1eKGj8nTcl1HpTqgNRndApYJlrgcnPclmz3+zWiVr/esRAGvMzi0X0h9jzXVjUGTaywdSkfG1GoJoW7uQv1ICuy+zvzdIjrDRawVV6Jcbu0AUbZDLwCDiE/T+YGu3kC3LLWWbKjXFjxxrUbINVvE2FGHvGOGX6pU2hwSlNRXruKz+y85kWnv7yS78m5mn/xTXs4xLfvRApqsmEEZ1xYtQonrZtaZZ5lVtWDJoe3emlKaVH1z1XLlH0hPeIqsYRFIi+GoNuquVMmmADhXgfuMZwCba3zHrrNt6sIQOKFaBUSFwYBEG+kvibKPgLXPAO69XjJLbKnfbnyTt9IUALe1bl1Oj3rFHtQ5qgkQj7ITkcfeB9fAzjHTEvR0JW46jhMz+UHRMDwSV19PmlvHRWLdow+SEEAKEdK5p8nuc1mZQJLKnGYNC+Q+XrCVcT4DA0CDoDj9eukFac/Isb5hdUUAO4tvuhoFtE8jIztMaxul8WAiUY/wPE0VZAKbKXDEfY2z7E3PZeQW0q7dyJOMv41YNxMLVN7oY7JCpvy3n2avuJNpyScTHmFotFw/ThOU50ZThNUIkDDD4axnQGFuoyJxwEc+f2hksf+SY9pLNhh+EfL0v5LiTPLerUnuc2RrWo3SFSLxlwvi/9iJ0QoV7jIrZ2L9su9Z83f1cYTQTFW8008mKZAIy9811i5THKkyT
 7Huz5jwz
 9Z8feYuElr4YmxpMQ06Wwfz/rivOiEVWc/HOBR5fPntdxrThqfxm0udz0kB/xzZSxRLsM7qgZ1ewx07gmzlp2InCaKrlMhOcjGjDUNby+I45S60y5b9FOMV/MiNCbNIGFtoODlCOjOJ4mGLBlaRSQ7wyPRSg438uG0cog7PjJVcylHDLTBPyIjWIKU1rnHCTiEFi1k2K76RqSjzJCA9QTGpFmvQD4E033lQGlM4k+nV+A9pHti1uMFDbcjPWLZlvAFDxwBCNwR1+Zi00y9fV9sjzxDaqDVK3jRrZ2YZiCqs3MQI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 12:05:18AM +0800, WANG Rui wrote:
> >From experiments (with 16K base pages), mapping_max_folio_size() appears to
> depend on the filesystem. It returns 8M on ext4, while on btrfs it always
> falls back to PAGE_SIZE (it seems CONFIG_BTRFS_EXPERIMENTAL=y may change this).
> This looks overly conservative and ends up missing practical optimization
> opportunities.

btrfs only supports large folios with CONFIG_BTRFS_EXPERIMENTAL.
I mean, it's only been five years since it was added to XFS, can't rush
these things.

