Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B80BCC5AE5D
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 04:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5343E6B007B; Mon, 10 Aug 2026 00:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BB36B008A; Mon, 10 Aug 2026 00:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421D16B008C; Mon, 10 Aug 2026 00:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8D76B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 00:17:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4EB68065A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:17:09 +0000 (UTC)
X-FDA: 85084049778.13.0996316
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA45E160009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:17:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PLcraFEx;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786335428;
	b=mDe0HlJMfzpnNZkJzpYfcUVCbGT2eKmiz/wEq4k/H/aUNgjLEdcI1dGA/c/EyZFGrbuKux
	7hPtc6dr8B0ckBf6deqAttV8Qs7erZ2JUj09pzNJND+4oWGM1QitT3mTlXv2HhQeznrO8+
	OMm4khMnuFr9Xskf8EZkbfK1lxANhJ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PLcraFEx;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786335428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=naUdZNScz3LOq4YnQ44LOQFyZHRAesdbsC/IKemOnes=;
	b=gnZ5TgnGxS7ye5RpIn7Arf0TzFhP3uPQ/3JvPOqPMr4AKDBgn1TfIWuW7VwenljeX372zA
	9hNH7EVTwPtgCgiTstLoVfKpVJe5R0DXN2V1iyqCcHstVJgTwcn7HZ9mttQZ6hPqdCkMPb
	QfkyW9+vWjGTk+POWwx9ZWyPi8urI0c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=naUdZNScz3LOq4YnQ44LOQFyZHRAesdbsC/IKemOnes=; b=PLcraFExOHMYf2FLbqrwCTpzB1
	/pqJufm3oJKLtzYWsuGHlU4uUArpOxxklvNJ97mlPxC23C6eDfihJAK1mhKEDLQ/FClmxQOgpv9nT
	0cH/lcHcuWpHKGtyka5HCQbLepgO+ZjxgekcDopjgURHFtcWUUjnQ7FEaswB03M+pTTxYL2sQ3Aps
	/YPMnIprhbzQS5sBC0MSwLIi90RdjSndX0HzP0c+bFUyTK61bhwB9JlF5s+KA7dT/gpE2QEueD00Q
	p3CSunn1ToZau9PaQKesDqe7QOwjG3L/81lL8SLOCy/bvuz0SNNbQvPPw/Nx5IE102J3fMfwKzVK1
	6ky8kxKA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtHRH-0000000AG0c-3J7M;
	Mon, 10 Aug 2026 04:16:39 +0000
Date: Mon, 10 Aug 2026 05:16:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Yongting Lin <linyongting@bytedance.com>
Cc: Jonathan.Cameron@huawei.com, akpm@linux-foundation.org,
	alok.rathore@samsung.com, balbirs@nvidia.com, bharata@amd.com,
	byungchul@sk.com, dave.hansen@intel.com, dave@stgolabs.net,
	david@kernel.org, donettom@linux.ibm.com, gourry@gourry.net,
	joshua.hahnjy@gmail.com, kinseyho@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	mgorman@techsingularity.net, mingo@redhat.com, nifan.cxl@gmail.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	rientjes@google.com, shivankg@amd.com, sj@kernel.org,
	weixugc@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <anlQp9LQw471t3YU@casper.infradead.org>
References: <amjz7kIDuZH6gBx9@casper.infradead.org>
 <20260810033814.83951-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810033814.83951-1-linyongting@bytedance.com>
X-Rspamd-Queue-Id: AA45E160009
X-Stat-Signature: 8mtka35kq5o39fniqu4hjqrwz4ki5fan
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786335426-995646
X-HE-Meta: U2FsdGVkX18lzVKpoGEzRSiuQPtYjvXwKED4MgtQ9eDRVj3qw0GRsjdNkDLehV+IZ6JB/md/mDNELzIxdZvQZVElC0az28cKFBUPaDVYwiOg8Mlv8rpPyt0Z7Msbav4tpd+KBBvPIlsIntgCyHQKMOJs5Ss7wVMGZsSRNGnWcW+4/UqB1FtNXzzR/Q4wSLeOr8W4pCo3m40tKapatmHp+ztI7lt6iib91Zm6aVoghxlkAJUKhY/NzIOe/1kl1FoCk7k8v/oFrxZf/2Fo7eAR2cAVOtR7oznq3/pR5xmFWoGuDwK12Ub1fMpnietzZAotiKvOq782HONyQ5SbrS1qy+3jcphQjAefLQQFgJoXNj4AKXBMdIWQNrQVdSh4GoQ4wHNxXw0CTA0MlhVQL6MNsNVBfVdW49Ivyk6i9xGNBmW/xP6bYTmImTAMulg0C05iv2JCn3gG+RiA6ahznZI+C9EgDY0epUXw2R0XXkub8ForsT9Vipu9mOCkTqWW5zAb3II/aWfHUfKbcdHiqS9+wg5iJ1Gre2wNFEHD0c0iqxE6U9sRZF83iynynGGMIrWU7xDDtFNNsZlLCt502LL/A0Tc97pJP0wei7rr1LdclIMbeZiE38YbYz7G2XudqDSOMDJk3pOV5rH9L8cPptDXiexd+NO7ivp5FMQRlfQwSvf6uWi2nYCVJfLloy7Cvq+whI8FEF88h9H4F9mqJxeAEEZnUQ3nkIu3fCQ7/evWf4ORSqF5uVA2Dz5Gbmz3NNDW55ejEC/Ycl5STXxGwWd0LjHGfFbLsyw1vlWtilt85SQafEaPzjjijtoN8ylUqqqpLA3l1AlizyiYB+Kcmundsqlj3kAOMRHma437fvkoaAcqVSXPDgWEudu3m/Kxu3Z38j+NSG7nanGGQ2XKRANq4pbOtOUl2Z046P7dcncws8QVvE7I02BKW572NIE6VTe088/Axn7Dbmr5SL3UrtL
 mggvoiOj
 BIaYmdAnbt2uKGa9PmOb90FM9FVK1Bt7V+oXeBte64CaZdpa/kXVAxu/ntM8FTd3LYFS+XhOT9D0Q7Cb7Dgp/tgONm+Zf0o8buHCdKzaYeKD4jUM3Z7yP6ezUPmv1GCSxMSO3d2X9XuGsg09tCuwhSryziVhvZt3Jqw6fjvnz3sxqlpKKdA+GtEUzS2zGEiP/WiTdikJ4ZgoirSEEBFe+Mixpq1Armk+OZ8E/weOsoaQQq4TP3LGYOwUtoUtQ/AG5t2/tvZtw4/L4Mjt4fkNFqvf7jFufSFhXyhv0jmaAWY4Aq29IslZfCs+gGpBnQa747niW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 11:38:14AM +0800, Yongting Lin wrote:
> On Tue, Jul 28, 2026 at 07:24:46PM +0100, Matthew Wilcox wrote:
> > I don't think we should do this.  I don't think it's a use-case that
> > customers actually want; I think it's something CPU vendors think their
> > customers want.  I've said this repeatedly over the months this patchset
> > has been in development.  I say no.
> 
> From our perspective, this is not merely a hypothetical use case. We
> are actively developing and evaluating CXL tiered-memory systems, and
> expect promoting CXL-resident pages that become hot back to DRAM to be
> a practical requirement.

But what *is* your use case?  Truly hot data ends up in L1/L2/L3 no
matter whether it came across the ridiculously high latency CXL link or
from regular DRAM.  So we're talking about "warm" data that's presumably
measured in gigabytes (since current server CPUs have about half a
gigabyte of LLC)

I see the basis for saying "this task is low priority, it gets its memory
allocated on CXL" and "this task is high priority, it gets its memory
allocated on DRAM".  I don't see the use case where we're trying to figure
out that region A of this task is sufficiently warmer than region B, and so
we want to demote region B back to CXL and promote region A back to DRAM.

I particularly don't see a case for trying to do it on single-page
granularity.  There's just too much damn information to track.  Maybe at
a 2MB or 1GB boundary, but not per page.

