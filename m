Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F632606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L0/p3SHz
Received: by kanga.kvack.org (Postfix)
	id 93A056B05B5; Fri,  6 Nov 2026 07:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9C46B05B6; Fri,  6 Nov 2026 07:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8546B05B7; Fri,  6 Nov 2026 07:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B29B6B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:23:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB7CD1A0DA5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:23:45 +0000 (UTC)
X-FDA: 85404610410.08.8150A4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B12780004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:23:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L0/p3SHz";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793967824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLjGM2UfwmU67W0l87AptAXAx/R+n7IKoR/u/mXJKpg=;
	b=2rqbfY1P6rXD9ZijyUELVeyrkh2y2UoT36Q9hnPm17rluGYLlC3/+6fS2wCb2rTT+iXFsb
	6FAj8FUrV5aR8ciuqVWlxvJOkrXroWhuf6Ae2NNJqNo4erLeFylitl8aBohqv0NDW/eeQ5
	gX30EiqLmg2OG8GnU1idcfGG28B386k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793967824;
	b=x0RelXK4E/mc5O2UaDy3EbmoqyCYAOATIO/sbGhCqbG1vaqaP0gbuGbhYgszUFkCDIoesr
	17GoecuUFtFvq4npZq2Px517957cNH0VOJh+KACkI0prAymbhoGSjQnLyzDIz+kPm4B44R
	eAtWDYXUNkLXe7YfZAo+sIXRnRxVDuk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L0/p3SHz";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD5F4602D4;
	Fri,  6 Nov 2026 12:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8181F0089F;
	Fri,  6 Nov 2026 12:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793967823;
	bh=xLjGM2UfwmU67W0l87AptAXAx/R+n7IKoR/u/mXJKpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L0/p3SHznilxSDO7OgzJM7rwJVgmsnj//HpVD5hDrikLDqFEazTyfc8l5n7oVdoiZ
	 QWqfdk8UdMTE2CQJ0nNUuF8ihSuQ9UGqu9MpGCGBthQgERbzl6GlodrEvMp789U6Tq
	 IGyMCBX3rfBGZ+ewCHoHjhVKJjGtgDTztZBs5ViGhWmx6fLHcd694D4KgLYgywOnLE
	 pLwPhu20b9BywaahSTEmmDCVbSZ2j4G1i8tof4OEFeXpOem6F/1IYAAveAiUX/edng
	 bmyP8tHh1UqgyuqVmpL0Hji09IzIMoialiDNggEd9ZhkEgm5n0za/LmJPskyy90Wbp
	 KYS7Q+S8hhQ+A==
Date: Fri, 6 Nov 2026 12:23:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au3GntBF9AE57h4C@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <au3CUJO9zBMHLx-B@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au3CUJO9zBMHLx-B@gremlin>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 47gdmmzie3ejunyg9me4gdewqwab3e86
X-Rspamd-Queue-Id: 4B12780004
X-Rspam-User: 
X-HE-Tag: 1793967824-728940
X-HE-Meta: U2FsdGVkX19T3g5WXbvQuRsE1NXd+SpatK9X+gURBR5YyY+6gVO/ur1TGxPX5iIv2Z5rdG9bOdtmM1aevS7h6fF2ZuIhYjbQrN+1mRTDCjqxWGn9G2rRQCEBeCAK9V50hWmoYgiViJUPnnOVJhP8PGZIpPoNdGnBP5PUXEQTdUMMCMkIjJMEdXpUsYtnBS/TP0a0bzxYjYUeD76wgzdD7m9gaix/+uzptrlG9LEAe5R00P8BktezLiCquWbT9fHM4prWaP/eKe0zX6rwEJ5dzZ4sKYy/eAaiA4mr0MD8NpImlzA+qD5AhbqqSZvwgfPL4Td49CfZWW3YQe2Mln1AHZvjgLIWPEf1+LG5aZZgR/zZqVrH+IoKRbF6IPA1l2Cin0qxDqr+l6JE4ZVp3iaqybLz3kheBcSto9kObyE7wt/+eko/6HPnOZ8urB8LEHPBNWGRVR7VAk4tSXspJ0lvfQeHqTO6u42u3MPfJb5/OMUybHSIxhDO3nXly9dExsvIMb1tj8910W8ZgJcJrlBsGXztp1aDGAwUqt20FFCSHsL2puvX5RPlwA+YELUjfS7p7GKVWP4dSkBMv2wgpwMczAjMij5aZme9R9EkoU2A8yeSYsbuYsDeFQBa8Ey62mgSBqQPCOePXwdEeYq/vMrI0BjJ1R8fJszQUJsifyphzOcHL1gMAlCmjNKJOILcxOLk3d2qeIzyNDnUH/dIDk1teviMsXwT68Rdh2uToLPKc8IpOqmkLl39KWVLiLpdDU8hDBNwzJHXXkucwMX1Fd4fo3MubKHziWGrbWmjgdl6Rs62u9jx6jRb364iS7p5dWHbQ3pN+Wk8/AQkyCzI6Fy+2VlQ+G6I4oRVi6NUDzwHCKMeUhMCW5Dd5eQ13ypBqZwt2c8r1BrLvuOqynBMYt1nxGD7yneNUyOSKilD1P2PeFAqWzfmPwLCW/SusRr5mAWJvGkPF+7czFH/o7eRU1T
 hSwTtKVB
 9xUKa+CBtbFd+KGoQcv/hrf2h3VYdSTsT0cfj+QenZjmNHwBscRZkZGkw4Bh3LLk9xbzxQ3Eb2yBBNVj+e3HYnmDEWFjtwWAKBOD+tOmjPWhG1XHmphtXEFKh8rgMueeF2QWFWwMQ7m7oVrEOJyMCWygZTaIvF/e1Jpgcy0RWtyxKvCuFk92b60HHLvSXZAgtQZ7tBrSSGQEVwdHtnbo9AOTXt2YU37EahE2WKcI+oZy2RCzmS9511caC9eDyedPtPjXwhg7/+t8dXucYmTnH8cM84Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 12:07:53PM +0000, Lorenzo Stoakes (ARM) wrote:
> On reflection, I think this would be better implemented as something like:
>
> static void collapse_scan_mm_slot(unsigned int progress_max, ...)
> {
> 	unsigned int long lock_start = jiffies;

The rare unsigned int long type, rarely deployed but super effective when it is
:P

(sorry losing my mind, should be an unsigned long)

--
Cheers, Lorenzo

