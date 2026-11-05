Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC01606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 22:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rp7glFqH
Received: by kanga.kvack.org (Postfix)
	id 599FE6B05B0; Thu,  5 Nov 2026 17:44:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5493A6B05B1; Thu,  5 Nov 2026 17:44:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487076B05B2; Thu,  5 Nov 2026 17:44:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0DF6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:44:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9CDE312091C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:44:07 +0000 (UTC)
X-FDA: 85402544934.03.FCCA278
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E8DB40006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:44:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rp7glFqH;
	spf=pass (imf11.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793918645;
	b=Cws+c8977rZqwkVLwFH188HQL4Pd+51bDUOjIND4VMz0gvE0+Ln7aCnqROjUGvjUNCuKKn
	wam9M95JjzTPu90JwV0B4fQ6UqCWERjinPuwzuSHTgNKD3Tr9w3LnwP6q6S4jbDlLfeIug
	ZVvDCZB+3vcpoAorbiiMsFl+pq+2QGQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rp7glFqH;
	spf=pass (imf11.hostedemail.com: domain of jose.fernandez@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=jose.fernandez@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793918645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxLJNgnKaaDtogy9UDJ+u4IBfGkMCrx4gqopdXLbwqE=;
	b=g2D1uTxzWt0SK9NhwHis91MXeWglqtEnn85QQJXYwvLsMdp0W4jQTgH3ajAk9jsAakD1um
	u6yuAXi0hsY/hCqU7vCAGAOIgXBtotRcCw85Tqt2RN7PeCRb2REDRRfk7Xmtc0UUc7sNSi
	Nbun9kuRoEZP7Q1ZOLTRrA1bJsTAgMg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vAPWWkIFDwbgy2wHFM/rAmP8el8Mj7wGKfgTaZhtpZ4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793918642; v=1; x=1794523442;
 b=rp7glFqHvrLHbMfBSaPiYJG22IM71k3aN2mJXgKV8YPS9ZSnI0eD4CGSpjLSYsqaCbG5rVU7
 niGJGtmUA431/BKVodx+m/HkN3vVu/yDMxehWTLamDYafgLyUpZ6bt5suRnNrAgPbvce5imoIzY
 5T3SqgXEZUkCHeEd5Y8xay/Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 960618cb128bac7d;
	Thu, 05 Nov 2026 22:44:02 +0000
X-Mizu-Trace-ID: 960618cb128bac7d
X-Migadu-Flow: FLOW_OUT
Date: Thu, 5 Nov 2026 22:43:58 +0000
From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Krystian Kaniewski <krystianmkaniewski@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
Message-ID: <au0GBdGqu6cv5PMy@linux.dev>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
 <aunPI5eOUOAEUa8d@pedro-suse.tail5790ac.ts.net>
 <20261104-jf-filemap-v2-pedro-reply-r2-74c87c6fbcf@linux.dev>
 <auxvLCiljPhy0n_q@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auxvLCiljPhy0n_q@pedro-suse.tail5790ac.ts.net>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1E8DB40006
X-Stat-Signature: gqid7howi5t4ufbuu65ndpk89qd1rmf4
X-Rspam-User: 
X-HE-Tag: 1793918643-270107
X-HE-Meta: U2FsdGVkX1+T2uYpu/BMXfzHF3ZH6ulNDaz+Gc8yfYcIqr5C1+eAOUVQ95O5HcVE2Edra97dK4wiBsNmYBKzJ2xVuq8XbnBqYJUmZ4ObtqCtWbNLhusJ/yZmJ8jBU+gaoWHNbqCxWkLtep5If62boyaV1bZq5/cuvwFPCel300yAWbSZzufKTzftGyziJDFO/IIH8SJQ8XPKSMr+Aj5Rradp1FxPRQ4J/156g7/p9gkWIaHidvcnOYc15IMnpDBGAnkwID9nckhiPz/qIA2LrP2Q7MNkaoyloQLmIw8C+azXqoMw0Nz6EJXlfC6+rZMn87TI0lgdPBHHZl0fiuHg8IpN4fbiUnUjk6q8Ghr0qo5/9N5Q0jg+y5SNdFn+9hUyL23pATWNPMcOCQARLWCGBd0KByc1WonYWBSYjaA16iTs2wEBTlYY6xLUkiKrQeqP6KGdSSrv/99tOaO2mkRSTiz2sjYc6HSZi/6OOcrQpxAZcUrUxCbGlQTIfDmSDlem89IDjMKKci829TtM35AwCXIX0Y/iJCB242TKv3mVWA2kNm1HrErptbEdB9FLXiamKVLn80/ztj/SeMfrQn5+bxkJzI+oyQvoBW9LYZRfahkNm4t22yF1rjoFCqOxB6QsD3e/MeiFz+jUuwCgfQJS3CT41nRP+AavBaSx+vHVTMu+js79HPyauEIJPPbD1y2mTk/z0FhjLAKgeIVgL7u4Ps+e8+5wcJdrWT4cFtAQBLrJF/N5DlFUtR/McEzeJqzOggQ0UVWyX807gh3znlbXoa30qSbyQRQl0sbhNcOGREJhcfCCPXitfcnDEgnhPi3vNAWSwlejdXpfxDTpslDU3JTKpI8EW8Kbt6fTAkx2auMsqlvWPdtLSS7zcEQmI6y7KNMkKj9wmDpQZi+Ho6KzSR6i9u504mf+Zftv3FAEuuirhc1WiQk/iQUgc9FjY9XrcCf5trQ+7FVrZry0pVH
 gJenUpCw
 0VLuuB/ozZhouJn5YTL0GohTa2cwyqcgYR+8h3IlrTgAll+DeBoPG6cooLHS0CzM8M4Ib1FFCgkeuwSLkHQIdwN8Q1u7YdW0oH254ZSUiTapK30FWpOAe9aV1PA1McYR5wEv77sSzeTaQ7ti7iplU55F11cq3BUoWNMRLJoFP34Rr5aAGC0oouc6mKBaGO0pdin03QHcAUcRT8ZCxXzOoNYTWWUBEuJkKwJsLpAWbEkbl4Shr4hq1Jr9MTn9LkyBTcVLYsAWLXb4sU6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026 12:19:13 +0000, Pedro Falcato wrote:
> Thank you. So, if I'm not mistaken, this is the race:
> First, you map/see this:
> 	[folio pgoff 4, length 4]
> Then, at some point in time, someone punches the hole:
> 	[no folios here]
> Then, at some point in time, someone faults another folio in the range:
> 	[folio pgoff 0, length 8]
> so you step backwards. Is this correct? Or am I misunderstanding this?

Not quite. In my test a large folio goes away and a small one comes back
below where the walk started. If that happens during the walk's first
lookup, the walk can step back. Krystian's fix doesn't cover that
lookup.

In your order it doesn't step back. The new folio covers the place where
the walk is, so the walk either gets it at the right index or skips its
sibling slots.

> If so, how can this happen while we hold the PTE lock? That itself should
> block truncation.

We don't hold it yet. filemap_map_pages() does the first lookup under
RCU and takes the PTE lock after it.

> Can you share the reproducer?

With the delays it can corrupt memory on a kernel without this patch, so
I'd rather not post it. I can share it off-list with the maintainers if
they want it. The 40 runs without a delay were on a debug kernel with
the delays set to 0.

Andrew, I can send a v3 with this case in the commit message if you
want it.

- Jose

