Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB65606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 03:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Mko85Vxn
Received: by kanga.kvack.org (Postfix)
	id D703B6B00EF; Sat, 14 Nov 2026 22:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9496B05B0; Sat, 14 Nov 2026 22:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8366B05B1; Sat, 14 Nov 2026 22:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B64E6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:10:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 619071604D8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:10:12 +0000 (UTC)
X-FDA: 85435874664.15.D2D0D74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94BE0A0003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:10:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mko85Vxn;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794712210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjdrsIJyKFIFnzAMatvSFy1r3GvrnGD+/8dSv9ZNaA4=;
	b=z9Tyg/sjOvtYVQc7bKL/lGJoJwLcX7YIQUOkzIMx/aGt8oBVfdzH2O2BJmQ3XT0i/ydAnS
	SYAIZJyJlxiMlUtR/X+xLCv7GMJUBSj03gD/8HsHd1RjQt00nASo/FmT9hCtgDgA7dOFVF
	lkYiK+VGiehZK+HzdEmAEoZ+ldU3eWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794712210;
	b=Yp/wC3tV/fIhS0at1OPtRr5PyuSkYK7G+A36tO720RG6LuiFXp1jbvVo9+KvQCQz+1qzQf
	GhRV0viDbatup7cj5fh5RNUeP4hWX9M6vHWDiglQ1vccjlsnsnu27XE9KIWCB6ZPvcbpE1
	4kgOu7F3u2cD2tJwh9l66Q366bEpfak=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mko85Vxn;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D965860202;
	Sun, 15 Nov 2026 03:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435271F000C4;
	Sun, 15 Nov 2026 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794712209;
	bh=mjdrsIJyKFIFnzAMatvSFy1r3GvrnGD+/8dSv9ZNaA4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Mko85VxnD5M/cnGfWtpnKAiOaW810jRtHcqXz54OIn722p4lzVvDQ8LYBV0J/qJoQ
	 xOXiZAPu64MmB9Gs4uYvUKNdfRpEWLURaQ+Cb3nma3rj/c/+742xKVrBbwaL1ibLK3
	 w8hMLrIgz+hFZy2TEY0/pP/slQLx+ru+nfRcqGPU=
Date: Sat, 14 Nov 2026 19:10:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shardul B <shardul.b@mpiricsoftware.com>
Cc: <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <dev.jain@arm.com>, <david@kernel.org>, <janak@mpiricsoftware.com>,
 <tujinjiang@huawei.com>, <shardulsb08@gmail.com>
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
Message-Id: <20261114191008.c6a23905a52c6f4f918c0d33@linux-foundation.org>
In-Reply-To: <19bf8d68cdb.ae2c0d37126486.8380742359510867201@mpiricsoftware.com>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
	<b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
	<19bf8d68cdb.ae2c0d37126486.8380742359510867201@mpiricsoftware.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: pgkjf9jigx8dyebfxhhuxe6qm7c7pgi7
X-Rspamd-Queue-Id: 94BE0A0003
X-Rspam-User: 
X-HE-Tag: 1794712210-968076
X-HE-Meta: U2FsdGVkX18oadhsaATlBkv8Szp7q7BsSU6qwNlt7mQUgPne88QkIAoCUXr3h7uTDooc6MasD9mUHfGl0thQ5ARWkYJrZL6xIhfIzGI86osp3fLD8A2rvB2qn+eMzSzh1zlY/Zfv+GuhQKQknZLRFlVNkUdsPMkQMOFs+1clLpdw1uzFWqMnRdj252a/13jFJH1HMg8HcyK4Byxi+x+WV5r9dL8K5JWI9iHhD/O9EKW3bCEIKnIJEhJ1s7oNjJN1Jyj+VhgJQyrcHmzrCUBXQF1iv9nn3xHAnl/qRfjhito3xhHLJPJcsGz90OqRevyojDHEjKzVJRqwIX3UKT1kM5s4SJo0MTJ2Y+cI16hUBU83iB18ZNVzHsE0TYXjObCngh2zJXNmm3zHsvzyKXk74ONUVMXcYZSG1MEw5y2cDQwh+aUYGd+4j5CmtliZeIQ9LL3yShUAOaIyFjWIH+MkGlJ4qAt+t50QmpgX0MGtEC0G/PYlZlFTLws5RrHMHeh1jjIS3lfuCexGGTU9nVC9AJAaULRNfbayjH4wUgSzPUvBBO0/oz+Ssr0JFeRU7n6tbAlL3yHgHWvMwzRpXDeQ3IjRF9v5bmkD4MEy5vJPolAO69YCm3qUJEbVe5HObgZJaQv5pA3+heWCRx29aAhGp/vlzIE1vsU4mU03yjy+OnvmPlGlHtsejdzxwjEO/0nzQgyn0UA8ZC0gs12C5C4DHQ7G4XHlaGPWuWi4kj/jiLF2sL5oaye4mlvKBRftLSOkru8j5E+ueuBicTWlp+prtizZFVmN/rsV25mIoEfqBvGRBwqrtw9StdCGuXlg/CQ5RECPdS+Dsvh512ReZ6SGMWwQdunUU2dPHLFfoqwRn6+S76QggIZ3OUanvYnGL4PiWX/kW35pzbiB2IkfbGv+As8rJc1VaQFza6y/h2YBVhGr4UbZTpd7l0HX1d77ec4fGA/BeSk4+lywxjYJv3U
 WWgPs/Nf
 b+M2yjexVGBPcDLiSvMFO6YYiu78VPPt1vBaXWEh1nblR8k030R7+Ze20fVdn0xkEm/x8vZqaOCncJXlTsCC8oqEVkmPS4Bc6ymsHyzeqhT8bxuU4x7dlFQydovq8DBlJTEpyNP7MaiveDrDXO53GZOGKruZqYWNYbciAB3VarcnAounFuNVB6bYzxPIOEC4K8rAd72W9Q/WE76utsowQ9AzxvxldY/NfcQ2IDfaPFW5tSe/PjwgcQ4u829E81312aJ/ujwsnkHvrhkVJbhFfo23r0OHT0JNLY7WNACRZTGzZbx3G6xg2xxZUeNSKiEpqLaDn2G8MIO/rep6QIo6SKvL6CPJSco+/kVFj6bP6Tv5L1gPNwCMbpDjbEp5chAfFgEUBRxT/kmG1GgJqXpAEchz6cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Jan 2026 11:16:08 +0530 Shardul B <shardul.b@mpiricsoftware.com> wrote:

> Hi Matthew, Andrew,
> 
> 
> Gently pinging this patch. I’ve checked the latest linux-next (next-20260123) and the akpm-unstable branches, and it doesn't appear to have been picked up yet.
> 
> 
> The patch has a Reviewed-by from David Hildenbrand and fixes a memory leak in the XArray library identified by syzbot.
> 
> 
> If there are no further concerns, could you please let me know if this is queued for the next cycle?

I finally got onto this.  I prepared a test_array case to demonstrate
the bug and confirmed that your patch made the test happy.

I'll send the 2-patch series separately.

Thanks.

