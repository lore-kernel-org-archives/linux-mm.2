Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9B1CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950EA6B009E; Mon, 11 May 2026 11:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9034D6B00A8; Mon, 11 May 2026 11:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E946B00AB; Mon, 11 May 2026 11:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 770296B009E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:35:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 234381C009F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:35:50 +0000 (UTC)
X-FDA: 84755539260.23.3353348
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2C8D3A0019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:35:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dn+SZB4m;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsVn7BtbmFje0SGepyohUQBONQlQL4jIBD55qYZrHq4=;
	b=xBce10118sMhuQp/iYWm5GFgccLsj37D/KWUlJUxmNYe3oTwKgXMKAN4m7AMnBSj8ADccq
	cdiJV2Vs+qb0KhBxIkKe4RVQnetv4hEAW1rHMSnCUUPGq8IXNrk5eMWjyHRnf/HvgVuOht
	7thCwn27u5lVO9Qnp8JNhYtUod3jXtU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dn+SZB4m;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513748; a=rsa-sha256;
	cv=none;
	b=NVd0VEdQdPf3eutUC5j9cxnjpjzzjQvt4BFW0t2Wx/TwIPxcrnGETHZF6Ip3Gy8LrDJe2u
	6USDNrHhVlqRb5K0m6d5QZFxsfSZrlqNYS/viCcZ5XIHO1hXpWoA1KxTFabjb2mZJOvRf0
	t7TtO2t3KB0RNXXX5MbaJ/sU9j6snes=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4892F40449;
	Mon, 11 May 2026 15:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A535C2BCC9;
	Mon, 11 May 2026 15:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778513747;
	bh=iJcm8bdr6xMheZvsDrIni8gzkyxU9kPE3077pOdHAIo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dn+SZB4mCwdjZggoXYntM1iDNswlVYRqUfJQC8SwnxcOHtloTPXOaNVWWhTD7x4sq
	 jMqyvhkyXZYWDe9t/hISBYSphf+XBIBE1BjFAo1qud5I26S1tWOttFuUSswdNnndD9
	 sNmEIVT4QHwXtwFiaj8NCeamB8zhYGyVm8InipJyefddqIzUjGANWCiB7OfF+pAvrB
	 2uWYvAtJe4wpg+PXT2rCRPYDCe0nCRbV+SbhwX6eld5ZQZWy9AXasd3n3ZBUQOw8IN
	 XJP9sV3T0u//VdwCSXDgOULVQyRT/VIF2IZGsbKzd24FuxbHrGgeBpsMV+yWHYxtKj
	 eQpgYBYdgOGSg==
Message-ID: <1355f92f-5259-48b5-bd42-d27dc8b2ea63@kernel.org>
Date: Mon, 11 May 2026 17:35:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/22] mm: move migratetype definitions to freetype.h
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-11-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-11-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C8D3A0019
X-Stat-Signature: cck7fguhci5krb18snocbffnqwdhhthj
X-HE-Tag: 1778513747-152026
X-HE-Meta: U2FsdGVkX19EHsdRItzTmAgflgnMVx4eqk5QbK9ZoMzrzQIabzu+gbT5mxaTReBIbF6+HpCY1+zL5VvLS9+8yeQhakIsI8gPgqzgKMASNt8KE+cfI3f9/uQk3bBJAN+21GDHVZhQz7wOAHcPleqUZJOh4LHXikt7bv57nrn0lTPAH5c4T5rQQwgUcgVkyYFVRaqeJYGKbiADe/kgHXEhBR7eyzrt8p0RaKfQIKmkOTcltetjRnTQYevlUeC2esF6se+nRhcSvxb3+kA8NnB7CAKKjuL4mnPe616LjLViAva2ZpanzFDw7ZPBI5dY//V598IncW+1t0jXpViWQHy4CceYf7MF610anXIDqD6cV/V5PpTYyfJzKYpSvyr3nOTEDH6kHWduiSBHHjtz/Zgp5QEhb//hS6mMIs+qWCbPYe0I2giUqrxx92ek5ttn16MzTjZTWP1PvJmDVDG78jdP80H9ibzaewitzcUJMm1T+GjYQ13Y2unsfoeockmLxPuNu8HZnmwlqET3C/h2vEk/BUsxw1bRJd4bd9EBspG/u7d3pUWy89JYT7aGgUMpf+l4HJ5mBxlCFG2sTn94tKiRKxMN74aoghmyppqnaq8/7PywYwgFZE7MtQTJXXQu7fpFMx7o7Dns0otewL1beOzvw9JatewdGfGfkIMehmodPeroneLTqhj6NFDeQ96zdabzAEolub7R7gq788FgeOX+RvTdZUqxw4sOgakQt99z802Q/iq+2HZKof/wB/7hJ4zFCKibHL56we5vrg3bTdjKfU164xNl3nlEOKQG2iM+YNuj016b61jx1ASp+MjtKACxUV+gEkBTp28zA2mccEMyDB/FNcAqvxUy5urDpi961sjEhAMeJCUZD5Kn4igxfEbIdc73zzHpakvTj+FsteTow/zt6ztnWjWq0Kh5fwOVYCoPSOR8RzJrktiz4r2vHQ9psNXpoeYzsCoSiokqQRr
 SONW8MvK
 HZ3VOhkB9QLxUAVM/0w0cbtk08xTqG5swjXpVZiLcosB20LEUbCb/+nnmqOuqHZwc3xuFIrWFNry/cHGtux41BvG45I1NeSUL88Pycm73a42tn9jILi/C8jWOCIA/I47Vo2IBEF7DyCEShJaiz7gffziUal+1tP3Ap93+/RXBO6/zqNE4X4+OOlNTp1iWYITCzjt7Cvi5Sf05s7iUotrMcoNmwyN4FQnGVyjHSSlX2G2lri/5d7UCTzR2C2+MbWAgpOT71xmOGY3aGbGeGwyTLR36tprTeWgS6C+MGJ8ea8mQP4kA5BdY2ml/ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> Since migratetypes are a sub-element of freetype, move the pure
> definitions into the new freetype.h.
> 
> This will enable referring to these raw types from pageblock-flags.h.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

git coloring agrees it's just moves

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


