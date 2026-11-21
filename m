Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0480606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 22:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RQh1F6vZ
Received: by kanga.kvack.org (Postfix)
	id C4C2B6B00EF; Sat, 21 Nov 2026 17:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5166B05B0; Sat, 21 Nov 2026 17:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4066B05B1; Sat, 21 Nov 2026 17:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FADC6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:17:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00024A0397
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:17:47 +0000 (UTC)
X-FDA: 85460539374.17.CB32DCB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2D2AF140005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:17:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RQh1F6vZ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795299466;
	b=HpcTAqlJdi7BChLdr4VjBeR1p6HTGaypQPDfktEJHtiPnChjlNKaAHn0HsG/0BDFU29mm6
	k4CWjRhXXp0t0VOd63FNJ87W/qTnj7VIR/Ih9ywMGjSVWxB6GEzInDxCkU4aMLI+2B6GjO
	4nIGWf/vNhM7IJ2jSjErYug0ufiEPRo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795299466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiD3WvpkfFMaq9WZc8IXp+MSoKnMtJjpSc0XfXung4Q=;
	b=3u36bsrElBTNM3cSA+RwJF3zkr8vldBx9mwVL+FulNjCN2mFsZ3+O8bb2B7MVZ9Xq9hsDG
	XeeT+Q2jTlqg3lfYIkEHYzeeXtq1VltAq49sYtvEKWXQ+OsfqTbdM5eDR9Q9gtWX7haeI+
	/YLZ7xGr8AVwo69LMPTGahqUwKbBHH4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RQh1F6vZ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87B224557B;
	Sat, 21 Nov 2026 22:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4253E1F000C4;
	Sat, 21 Nov 2026 22:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795299464;
	bh=oiD3WvpkfFMaq9WZc8IXp+MSoKnMtJjpSc0XfXung4Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RQh1F6vZjbnStpK46EKSIanIFeen7xkryaaTx7ipWHGuG5j9IGFeuFiBYe471g7KR
	 IncpZ/RUzrMb6AV3t7vIc5yvDHdvCYGitSKPIWJdKWhDlPA/shrxv1OC9UmrhQ9kSL
	 jXC36Ynl1SpAms60l4bJBy0IPnecGqRG9F4lnmnY=
Date: Sat, 21 Nov 2026 14:17:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Baoli Zhang
 <baoli.zhang@intel.com>
Subject: Re: [PATCH v2] xarray: initialise the offset of a new root node
Message-Id: <20261121141743.6f1095f5355fcdb4519ed979@linux-foundation.org>
In-Reply-To: <20261024014344.830116-1-nickolai@csail.mit.edu>
References: <20261012181107.772545-1-nickolai@csail.mit.edu>
	<20261024014344.830116-1-nickolai@csail.mit.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gpuctaxk55esz6n4isr7ra51ff3dxges
X-Rspam-User:
X-Rspamd-Queue-Id: 2D2AF140005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795299466-523293
X-HE-Meta: U2FsdGVkX1+RroG2OHA8WFRpr4hqIVYprOFhNgAE40DimHftDrBqKEo765MoXbKrQEOZO9JSZ0GvZL16siegkkFGkrL1Un2Mko0IT2vb1GaOCpqbmXfitHFlJSSL8ZdeeF49IJrkTM7WSfPpBUqci8L0y3KtGeJTcFLCotQfrIkynLu2iQdaeC9ndAodt1uX2FL+lxljxYvkZgI2P+klhBdXbthBD9O3XY6R6ZVHoydAd4Jp3WWGTbokHZ0VN6ZAJ90S9I7GrV/Op3SL/bE+d+LVjKvKsZ6lJZR7KckfXvjnkzOXN2lHtpPVpnXHJ/2Q46sq1sZqVunarPz1g/RWKImoaAVYuWuqOkBdZs5EW41S3meH/y5VOltauUywGYwhaKLhl2L5veeNsJO91+ayROBcXh/6FUzxwxy0r9gag9FCamzwUueZN0xPxmUN/Arp5zivUICs8NckV8AVItkZh0tBaJjw8NbO4AvrWo4c0RieYbnFXEdr3Ug8eZIUgBGK7ghRolsrx0NZDB0WzRh4sGKXGo4mxwlU5SX/rTBUnVvKNvtIV9gS0BYrz0e81rHxTuj5sCFLKw8IYcNPqN9BoBpuB+OGE3Uy4C7eJgUFBsXOZkDYHM0GCzyGbj58YfK6Vhc9ZrD8KPrG8FvYp7sUhvnxGh+DuMC7QcDg3Wr/PmPKOymMnKJyBHoUjnGtHsNGERySYIqZTnnhGv1uWQk8BeeygkiAAkIozQe5gWVIoxPeHx14AJ90Jn0cb2YzyHmupy9h8RDjZMjFBrK40ixBF5R49/85Hxh4/hhk6PmB3okayyhyDnV0CqkbNWWatBGXcaIGzWqxThfqin1Exs0QehTGuXPLYCii9WHQtQnbGLsD11nnRn1+rES3741iUf3jslg9JaR5ffON6p8/1Tz+Rl2VO2IuOoD8yhQdr3QHfVTZCGHfO9p4kWjt2PIeeW1XdJIMbhWNT5fKGgvUj/w
 UgPsdSW3
 TplWEe1m3nrTU7rqxCRofO55B7evAsIHL6cUTxronqnOpECRVm8m5Qr1ZfGLfOMM1UyZrJcmXMQ4EhNzcKeYyVHbISqvOiRXI5nyxdvHHJaxE8Zues8mpC5cPSP/uBm7eQDnUr08SyxCzsgy3bt8YnjqjcHGQK4xNZqP1/cqmdxAvpkAYekkOYDb8uctt8NiSeLNZ+e9/HYfRjidp5VRcgxZr9MqwWNVMzDAguq9mOZa/etdl2Yns0QsIfEgcY7T/99HyzPT5hlZqRDmrkudmcI/O8CkvqlfsHAWQ9L3LBDYEZnGATbURjXtb92q21vZGC/6vS6NILaFPHCPCS/aHlZiX+mqLSjB7KZyjjJeOC7i115azI4rr+tFyjeHKtW9DQuXSgEGDFxE9DaVJO43WWCC4tytNBEqtbLKRSZbncjuJjKpWKvnLFKJ05g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 21:43:44 -0400 Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> An RCU walker such as xas_find() that climbs out of the root while
> xas_expand() adds a level above it can resume in the new root at the
> wrong slot and return an entry with the wrong index.
> 
> xas_alloc() sets node->offset only for a node with a parent, so a new
> root keeps the offset its slab object had before.  xas_expand() stores
> 0 to the old root's offset just before linking it below the new root,
> and a walker can load the stale offset before that store and the new
> parent pointer after it.
> 
> Set the offset of a node allocated without a parent to 0.  The store in
> xas_expand() then writes the value the old root already has, so remove
> it.

Thanks.

I turned this into a 2-patch series.  The first adds the test to
test_xarray and the second fixes the lib/xarray.c issue.

Which is arguably the wrong order - I have just created history's least
important bisection hole.  But it's convenient for before-and-after
testing.  I did that before-and-after testing and it all checks out.

I'll send this 2-patch series out for review.


