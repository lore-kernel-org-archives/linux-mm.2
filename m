Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C57CD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 23:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199456B0005; Sat, 13 Jun 2026 19:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1494D6B008A; Sat, 13 Jun 2026 19:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05ED66B008C; Sat, 13 Jun 2026 19:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E92CF6B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:15:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F17A1C276A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 23:15:36 +0000 (UTC)
X-FDA: 84876448272.16.FF97DC2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 08FD840008
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 23:15:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hLXD7eOS;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781392534;
	b=Iq8l3fT1hzH7RXo/qi/wFNNDlLoW8i33GsZsDlGXBhY/lEGU1r96QKI3C1CyeYeUfI3YBu
	Xc+fhlKZTUnepBEDKeunwwEp9vZ++HOnRgdGMhiSu7sU9LmM411FEU1D2HAE2iyQRUca1R
	YYTbOIDTd9vaLnghZ5Sj0Fm4zP47nsA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hLXD7eOS;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781392534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dG3xiqATit6gEoZb/SAPMSkQ9RbQB4Q9JV9vSc+U8/U=;
	b=kcan80e747/SomI85tPCEiSRW3Gn3nVfcGPUlTcc/EhvlNM+O/pBb3UNYYsj7D3k7iOTYJ
	zEfTvYiwRegGK+V7lQbjSg7dkaY8c7gjmnGqK9TZn5fTppsiLhMrk78K9BiRm7OBHmTM/O
	9eBaPvvMEQ8nsS+Y7F7a279ZD9YtBX8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dG3xiqATit6gEoZb/SAPMSkQ9RbQB4Q9JV9vSc+U8/U=; b=hLXD7eOSFoc4e2VKrlStDVD/Du
	Rr+P17+rwokxTAhVCNohqPP9xa8dwN5Gi99qnUYhjXMy1K2Er6rjVlTluAYt0GL2ig88zArVF+8DL
	1/r8ywXcf5yEuOG0JnPadEGtjy5v63TLkLSQ70KRMIuWmvKKakX7q1pHwcg1DfEk4IeZ/S6IqkYln
	kK9hiVzrvTJZ/6d9Odoqp+g1zWurLoBhkgzSKTtbcDwye5KDzjdlm+L9hX3dMprypCjS5+1y1JLrS
	xwqZskhRqi/p1tQ841bYJ3x4SRVontkg24HJu8IqA2hPgNMB4hyDySHxDiw4H7B/Tgi2UkDMmFTXs
	EFlnYPnA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wYXZY-00000006DCZ-3ADY;
	Sat, 13 Jun 2026 23:15:28 +0000
Date: Sun, 14 Jun 2026 00:15:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pranjal Arya <pranjal.arya@oss.qualcomm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mostafa Saleh <smostafa@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Shuah Khan <shuah@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Brendan Jackman <jackmanb@google.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Wyes Karny <wkarny@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Message-ID: <ai3kkIpaR0aT_6q5@casper.infradead.org>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
X-Rspamd-Queue-Id: 08FD840008
X-Stat-Signature: u15s9om4wc84p13yaz59grga71eem4fx
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781392533-591700
X-HE-Meta: U2FsdGVkX1/TZGDLCpgKs35amQ61n/kiGFnFo/9kxN3PUNy3fMa0Jt4RX5uoC3r+zASmEJLpv0gHg/lraIqthBIg62Kmo3GdL85j5SzbjDRSSlthp3UmBVoZJg0Cq08SkmF/v7dGDn7ZluhyP3ZtJmbRh+poIB+FOi80p+XniWfzzpIoic1+ANXeLVufSdCu2l322jFp5EX464drd9DPnPdRtVsfvkurTSnLui5EceeVMoNCjMx8vqZvPA3svd3vBjVq2XneYGpTM/kiZq5gpDt9/mrvZSYoTjUmLGz8NgcLcMDtKNd2Jku13n11gt8ggTloHn7TebyBxxUQAGoBX1OXZLdjDRXFcsw6y1uECSro95qDg8dOK5wgv+WoG+VJa8tvpMukt5yr6VhZXOjusAOpLtl46rV6sVvNMJlXTE5JueLOLZR1xLfjSZ4k+NsBXmqoOZGt5qriZxdnA2OOn2YJHxPRWYlUB6tVu+0XfgHuJQjgh14TP+stzfZRnurMyzc90kUoBkrjtgvuZ9RFsqgS3T6SnLoljBp2E6IDjKurZ8DLsNPjvi9FXymYc2EBeAWZQl6rnpBZBIilKfD35L5UICHp+4b/vzQc7/nxXMB3XIMnmKADK6EJo7UfU3tIGEqUaEM+IMdQ8iBNG4SCN9ary6O3Hifzu+tHXbc8ZtV7uNkR1Y3Mbjp36sF862FiSWg+4e0FBanfwKisLZuVXBT25h6HMZ3I6Zdbvj25qN67wAkgDa8t6JbfWODB3TeHrHSbSOgHqeMYShpUWdPNrrNkNtehr49+xWFBNHMpnUzU4Y21EQQ8qCVtgJzM3FdPeCNx0uPOsuKwjCgjsFhwSIA1U2SDmDs2GaNqv89m45JHekN3vLMtNcVfcTgczI5hg7CsOr75aAwLfvSjWiIt4TK5DW73hTNqoONEInKDrwB5GBPwFIv65/iGfC23tz4LWiQqBkhEGOdLAG3A2C9
 HTp90bUW
 5K+KA+/yVLXkCSDeWcYVkKdb+1Rh52xpM3yF9tNjLe21X+4mQ318Qcr1s3TgMMxun/bm1fA6So12TZQ3wQyiNUCcRL6EkCSPf7WXAXhTAc45CMlSqtgZrOfPzsihGV1zHIIIqfoGq+LWkGcCpfZ2Gew9SlMo6b/9M4HvSCKYugozP/6HttfPHgGZrsAo8Xq1ZSxfnNkJZg/tUPe4BnurfgJHwXSnMrz559j4UtSb7+hFKwjTt0D1/an7cCepeWa2U84v+gknKXXpxU5h3bGZIWFN0HvoBRmM5YawrkBTqdA1UzK7kfFln9Z5QlWfwtgPcEIMl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 13, 2026 at 10:49:42PM +0530, Pranjal Arya wrote:
> vmalloc's free/busy/lazy area tracking is one of the last remaining
> augmented-rb_tree consumers in the core mm allocators. The rest of
> mm/ has been gradually consolidating range-keyed indexing around
> maple_tree (notably the per-process VMA tree in mm/mmap.c), and
> the underlying reason is a structural mismatch between rb_tree and
> range tracking:

First, and most importantly, I love this.  The maple tree is undoubtedly
the right data structure to use for this purpose.

What I don't understand is why you maintain a separate "free" tree.
It should not be necessary any more, but maybe you tried removing it
already and found a performance problem?

