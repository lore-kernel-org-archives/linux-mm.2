Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4E1D29DC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 04:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBE16B0005; Mon, 12 Jan 2026 23:09:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F656B0089; Mon, 12 Jan 2026 23:09:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B616B008A; Mon, 12 Jan 2026 23:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77F846B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:09:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CFD5D0949
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:09:48 +0000 (UTC)
X-FDA: 84325612056.18.663AEF5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE80F180006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:09:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BNCFRz4e;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768277386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPDQONHKCDgnwEfmCCHE8B+Ej5UJEZq2JA2LN4UYypE=;
	b=S3kGSsgz6yqHhLWVxRaZNiaSEXVS7FbMueTsU5mCM8GYOfVvuQjbq3W5Yze8gKe4r+1YO3
	4EaW2SHQaDtq0I3FMqCS8Cqdrg9Up7W8yYTSZJ5vjPo9GpdgmudLs4Kz6w/n/gXTtOUqGB
	1z5xsp1F+6CIzilh6w1k5cQLgM3SP+o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BNCFRz4e;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768277386; a=rsa-sha256;
	cv=none;
	b=45ZpC7Cq8mrQ19iklIwn5xmg+ilCqJzP9EYWQTFyp/LeNKtZ4hneWTM69UX4SgMAdeRn5c
	YOJ5OF4H/Azp6sRsXaUKzV0oWUvVh7nztaF3AkmCt2GdRGSgthLSMxQXf35/5zdWKlPJKr
	xtuxiHIsTsQrC441COX6cc6qtPhDaYw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FPDQONHKCDgnwEfmCCHE8B+Ej5UJEZq2JA2LN4UYypE=; b=BNCFRz4eLPfjfJ2qSh7zUCS74o
	bFnDkG7iJVpZ2s9CBjxdIUij2tzii6zrVYCbKLHO+VGwUu/CUClk23pdIocqw/M6Rq7mZpMLsWzX7
	bIKm4Nl8uqKm/AhDeG0DsGp7NTnjLZljLE4ger/3aHHhciCon0dtnvLTZ8J4UyVgfvzgBmRxnhmL7
	gs+Zox18mKEyIDYgY0/cqB9p7y+TShFjBurWNOfdoloBeQRZ3Xv18CpKV2aH85tpswuBtINJicd2b
	UbXVDTMDgo38U4yotEd1u4Gyr2opDj1G5KzLqL/rBqdpus4oATKhc75EHYuF2b4wd6Jiwl58fewAr
	G96bLBtg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfViX-00000004Chu-3eJI;
	Tue, 13 Jan 2026 04:09:17 +0000
Date: Tue, 13 Jan 2026 04:09:17 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ye Liu <liuye@kylinos.cn>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: remove redundant page parameter from do_set_pmd()
Message-ID: <aWXFbZJl7Z-9INVp@casper.infradead.org>
References: <20260113014130.922385-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113014130.922385-1-ye.liu@linux.dev>
X-Stat-Signature: eixdciymp3po9ta84oyymsmkxfh5u3sa
X-Rspam-User: 
X-Rspamd-Queue-Id: BE80F180006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768277385-509269
X-HE-Meta: U2FsdGVkX1/ifNkLQ/XM+b83pPUMQVsb/llILsQ4qwqA4vtIq+YRmn1kz4DBWBZA2bgzid8YtcGU8ZGkQaIoLooExsieP6OtgO2p9E+eGlBEncU7dg91a/zpwQQ96x6OzmIjq7kDzo9GXOPuhiz7FssSr3/1wN/qPJPeTC4gDFhN8GURS95HsV/qzLoElQRbAPgxDYf59kzxE83rsDBGMwQ9fclo+VLLVi5X4UJVecXh1cB1gXrY1gkG5MAoYz7EI7swr0ztGbrSmQYIgacSd7xjUyikGMv8NClrRMh+vf/Zo980WLBLiuXi45n8x9/a4hH/Q4WUekJGAiWWehw2gXrnH2fOB284aYa2pHeC5R3R9pOUUUnHdRTI7VT4jvIWx+KGs9gNDyXk5Duccn39wIoX2s2bR8HrtaKaRMjhzwfu6Ba/5MSBRGO0KM7DLNHwo1OREjQxhtPcDRsXdEcmPtHePt7nMTGF3JNB9++M+MiBj01x37PJ8sEiptvCJGqKbRMZ7/4tqR7N6boAJj3USIXPKcL8LxnlGtZzjUpzkkQkiZLCRwILWPSRTHn0DFXeLuX7lBB3VVWZa/fmhFKrYRc+zkQZepGnrP5aF6N8rgcGz58aBsWt1U6Tlv1+OnrqkVIc4vlLjdO6lrZCk6VNJcmIUoHeHREROHgHTRTPUQr+EDaJnL+fQPSPmCamUOOYwLBBGv7QFgztVVsCt6kEo6ilfxLKU3octjPesn7akH+JktGw+pD1k8RiRwZUN1YlxSAvY36F/eqC9nw7eqWAycq9uAtCnEews7NciPftqxADRv4MKQGumJq+kP7abL067NyEF/uZlhA132+DydQ+9ptcHzTUP6TzCr9US7COLtCtQzvkLHQnxKxa2tT5wU+tzjRsAdIWmTTAVISl7lJzrPv5V3aR6Vs0PLok7ei8yTAR0xMvHhOQmeN/5fYCc1ehmigOas1nBCM8jeJmacu
 3ihT30UI
 h3kow9YjgWLO/JjNZbm0TcoGhPeNIl1Q5nUEjXo7Nw6YRjHluuO12jYAthGgijsVAenR6k/he2vE68RNiFSw7OKJ7Oj4B5Sp44CU+ssDCeZuIR9O4cR1I9HKaUG0cxzIKAw2brysCSQFZbCmBGfpn+6B+BQMxAvQ0XmX2YqQqkjLpa2IL/vKuV9maC62bzXXIV9euTa94Y7rIzl30UVwjp6u5SvK/cWZ0Sg41zgjc85sexwEKEMoQbkBgA9TZZQ1Qs7vYfTm1iz5GynqSJjUYMk3pOrzj2RdEmQe4dqKo1B0+8D4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 09:41:29AM +0800, Ye Liu wrote:
> The page parameter passed to do_set_pmd() was always overwritten with
> &folio->page immediately upon function entry (line 5369 in memory.c),
> making the parameter completely redundant. This confused callers who
> computed different page values only to have them ignored.

No.  It's an accident of the implementation that we currently only
support folios up to the size of PMDs.  That is not the long-term plan.
We always want to specify exactly which pages of the folio to map.


