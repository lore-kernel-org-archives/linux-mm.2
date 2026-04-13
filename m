Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BDB8F531CD
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33EA6B00BC; Mon, 13 Apr 2026 16:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AEF6B00BD; Mon, 13 Apr 2026 16:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E49BA6B00BE; Mon, 13 Apr 2026 16:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5A826B00BC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:38:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6848A1402E5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:38:38 +0000 (UTC)
X-FDA: 84654695916.13.3DA87C1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF69340005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:38:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HyRxFVuz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112716; a=rsa-sha256;
	cv=none;
	b=ABvMZhSegMH9uVCZAROpTX2899doNrbVf+5as1Nv7eiglU3BR6v/Nm1H3nvStb8697Zb41
	POhs6mPHXSw5DGR/lWtL1my+9TbglPYBLAoY3s9b8j+hj9iknWfLiJsNvYwrq74lAdesNn
	OlHSy6TLzD68kVYqRFC+GugsunxDksU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HyRxFVuz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shqzzww8efu125Fz4bPAww698eDKVAA5AF6kD5vHNcQ=;
	b=CJvRUQhJP2MAyg5fQWjZPPuvK/wbR+2He4H7Ic9+D+Wmthvhl3bUbZwQTACA9rVHAO+ZC5
	CmzKoYY2OarutRDK3E+AwZqq5R4LDFwW2/mcAH5GPL8lfH2vp6NAN904HNTPRtG05xVMP2
	LngqAaO1tD4JA3jP9JTRT6DQymR1hRM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=shqzzww8efu125Fz4bPAww698eDKVAA5AF6kD5vHNcQ=; b=HyRxFVuzIo3nZP4w5dJrvfv/Xf
	/LF1ktymMWmns85j1OtJrOMy89vy0HpDVZZxfy1GpTV2GGdDOamZdspK0+5xNxMvcYue+HHyStGHq
	MH6C2w/rL96USv1cxaU00MIr687cwhZUnpEzUItaEgiSFuRadLw/+M/lhovP6UXF8n0ZGoZYHlVH6
	7cdFfgm8esi9lqVJ5rnJez7z4XIRlbbOXIb3xaAUSd5zLXLWFccn0VigkdVVZk2ni/UrQvo2OvYuu
	r3jd9HbUgUyftndyw3ADlm87pijqqL2NkALTAQOThIZ54PODyexR3ZHxgU9ivIRAZ0J3/vcsnI5uB
	1Oeu2vVw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCO3B-0000000EUaQ-0JvL;
	Mon, 13 Apr 2026 20:38:29 +0000
Date: Mon, 13 Apr 2026 21:38:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 07/12] fs: remove nr_thps from struct address_space
Message-ID: <ad1URJ0B0SOUX7Sj@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-8-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-8-ziy@nvidia.com>
X-Stat-Signature: whtbbmxezc4i7bam7y7fasqnytayhnss
X-Rspamd-Queue-Id: BF69340005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776112716-718855
X-HE-Meta: U2FsdGVkX18fofxL8kslC1SuTiXYkVBVULNBJPxeowuvRTCY0ExXp0Xy8aJ6X6dALklooH5jAxj7nGNhgRk0ibHCH3EFJlycaBNs6ayFDBGpNKq9cRg0kk5KheatF0XhMkfIIX61SL7mz4Qu5q6ZehhrxBM591g/qGIiDKB1mSGCkw3evV8iQ/ilDWggG8JmCeDVXIGIx4YtOfu6QdzlpqIsYS1HUbHjeiNg6iUxnDQnTL9d7NROsjohH9/Brtgg+PDsaIvLonWLIFqgt2ult73SG5/b40QHUGO+3zUiH529yb6RNwwhIo31Ik9fsBd4p14uVsL0TRRS7LNJK06TVMEvXpUNz1sgmiztDq+yLm9NIdbejtpcbwmw1c0a/tI3glKc4blu7pIZzTBf5FQWlSev8FIHBvqnBJk9z7ItABZeeY6NtpkiqsKXL2N9QbMc9lBFiZJYquu1Yv0AJUjEYi1Wql1URZzfx6ATl7bfqV4UFymVrHv0miWCvDQkxru56UfxZrw2T5thS37JRz6VK7fvbvY8403VvKdw2P/mSIXJJylgMauyGSAkBIkaj7gJvqR0YqcK+hC1ggwFZD1L+ZaR3Z1kBzNj3xt1qVvCjuYdRKDgmkjsLtPl+9gMHetQxCd/sVEe7tbsQaJoiceKQCsqTxl7Y9MYdGlaSU6n0EoXB0AiojRvCUaQZ4GadqIQQVQwukep82WrtEp6rtZ5IV9ftZ3i6ACPuq7MELvfjnJVgGQVyt91Kud0MYfWcgPOrTnqttWxL1d/WS2+Z33U8+2bxFZSzNU612qmRMVAM1WEVeBKjLkLnFqNsiH/trfObKkwSuUAfvyH3/GJn+kCIS+qcYj1diXcZOc6uQi7+fy4SGfiNMKqYFEVH1PRvIs+wSUIPSZjTK6gCORnn8t1E67dx3cMnSxa0qYJ8cErgZQIQQ6nElnee8CTsgA+qGCH99Av7N24JtrjQ/6cCcq
 V2yhoj57
 ttKj/1kKsmJqTgQC4eOkDyyDuUNb9fNzFxxEI3/aZGAwUACgUTXPYjJalhr7c9tLrmQs67EoI8yL8a8zXBjNpnBc65PSO6a8k3uQ1IRF5P6bwFu7iuorNB9REDUiVX2KNw3xopx2KKtdVF2jyhBovTrsOS0AwsdYdFDgTprQDYjqtX9iI1rVmW0X8nIY9Km2TiHTFIlcpi0IMT50exV3An7DLdQvySsDB1YO0A4Uy4MayE9Ky82LSa4a6EcsaFKbiEiKJ+QgfjUOB4MscypXY74KJWRikyVgrGlw3tP2jf3faYZsGaB2xsX4QnSI+19oy6qUs5kWcOBsUbEvh9tnGTWt5GpAzBEPIUwNNDSTdKp898crp/oMyEaHbdkv8y0dYLM/TC6OXt44hthVYn0QfK58ZyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:20:25PM -0400, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it.

... this shrinks struct address_space by 8 bytes on 64-bit systems
which may increase the number of inodes we can cache.

> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

