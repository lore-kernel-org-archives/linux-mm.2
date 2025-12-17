Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7675AD6406C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA30A6B0005; Tue, 16 Dec 2025 21:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50B46B008A; Tue, 16 Dec 2025 21:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87096B008C; Tue, 16 Dec 2025 21:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B718E6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:41:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51E9CC08AF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:41:27 +0000 (UTC)
X-FDA: 84227411814.26.F82D91A
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92B2AA000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:41:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MXqvDJXN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765939285; a=rsa-sha256;
	cv=none;
	b=xrhh5Vo9qZcjCPb0q/3GTnQkdJGAIs5m+fIYrJBBKwr6EvqIqMT8xxO+kLW5VRL9PXmEFJ
	HtxbviRUO8Qx4n4GX4m2DLGACx9tf8gU5ROGMC3eYZjWR7hsnb0iPptsPlm6k1lu/DO/Og
	+Xn6fNAmgxBv4DhOjzDpvXxS9y1UsMo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MXqvDJXN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765939285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5fKVkf3kgzk+SALGSZHSsZcr0hbPWOBU/trwH+0mNs=;
	b=mpx8wfc/4ygRwCPrpvmjP6+Ak/Q4YOvxDqnY4WgKnQp2iJ3V6uORcqg1eWVp2X7eqhVyFH
	ntfzrs03m0rRJlRmJtCuk4AmBwCu83i/JnocAC84TSTX1IH0r2d7yg6vjtNjHrKTO6XRSw
	XOYeEP6fjJnpFHo7ElFWO79y7fCU7qk=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765939279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f5fKVkf3kgzk+SALGSZHSsZcr0hbPWOBU/trwH+0mNs=;
	b=MXqvDJXNQqVUFC/+i0a05VJz+VG5lMqpd5YAEVuMBEAhlowClJAjY9W2yIX65LBdpYZYHG
	cfIW1vCLaLsg7BkK8QoQlQUgIhx4c4RpP30LPfEGjbB045kFGXVi8sm2cRKxBf0euxnRar
	unsiMgVsiBMO+waB38w+Dw+PbCxakZk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v4 1/6] mm: debug_vm_pgtable: add
 debug_vm_pgtable_free_huge_page()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251216114844.2126250-2-wangkefeng.wang@huawei.com>
Date: Wed, 17 Dec 2025 10:40:40 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 sidhartha.kumar@oracle.com,
 jane.chu@oracle.com,
 Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <C0062D66-CBF3-497F-91B7-813978CDC417@linux.dev>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-2-wangkefeng.wang@huawei.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 92B2AA000C
X-Stat-Signature: 57kkurybxmgf91mkeho7thx7bpddb3nb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765939285-265014
X-HE-Meta: U2FsdGVkX18CVztgeLSo/9I6ISqm0gLsPfRnI/BC6h02hUXYsgCAF9PzqsGRDFkwwIdnapK2R5ytcFuopDK5pT//MBmnF1K2urb+C8SsR3lcEW+QvfrRkbpR1pE96DNNe43rnCO5Jj4Ez0nC4F5JxMl/fbCNEGj15scyzBiyHG6IiC7o9qv04xe3na+60Mv4Tjb9I+kyECaErPnVNX28Dijezxnff+SFdp2MOqHwLJRpE0UPmSRQs9mVvKNy8ihjy1Z86dM0a/BR2aleQPX8bQdpNQcSigxuHhyeacyoKr2GWBibfgo/8PXposeqlPuKVA+hPLDBXCc7Q+pNTrWjsz6GvM3Rxv4115tuW9smciRJVOSvxmcGZssFtQTwkF7Rzv+gt9eimMSYkRXyFgzjXTp5OrDHnx05urmKNRBkrquGa+hsJWavy926mxaFDWglJrtgeXEiK0YH7TQHykvcF8rrj093S63kgeqERx/AxZRAft3xQRBeLuyBSfnjmUt/nXUBLd/GGACz1dZAjCjzz8Up5Z6YgCT8LUoqNJXCTv1ZCHYBEjJwA1IDGYybvdEVrGd8CWLBTUtJGrKBAfyfAMe3ttVWiXzl0h89aaz0vdZenVQ8GCBN1wTEUXLCiqWEvm/zNUJUqus6T4hB68OXDyT/Kc9JSgox2gMe+N0TDXrUmgeUU9mCmLUX7+SgrCn11HBzj4bBGVqEJhUyX2LtgBtUfoPw6fHIRBUoY7dB5r8yKgoqZenfo2nJnxcXYYWdhsfiGtmzPHyd8LinepWvhMVBGJnLyvyT2HB8GdCEr1HdYv0veZErPqts3ipltHyq/oGrHG8AJ65srIfhWmtLNgBdKUJoXgqFjuCI/+m97CZBvck4jQFLrAf+iRdGJaAEB0rdMkeaTE8jU4Rzv+AO0r3GU71dxOfIzi/p1LhszXdCIAv1uxwdqcXHRdDSHp0EVI2WE1s8YzkEsIwgTs7
 uS0kzg2r
 DOH+vXIgc5mudFZp2vbYbFwYQVBdvYICZ89ScgEN5+g96jsCIaMmwjSfyIrYdVIGBqDDqo3dRw6vUQrcZ2XfWxBKABuNZEPZaXBe1AT9L9YUwLWEPh27OhEMKnuRvL3syoRB0qB4dmrZ9aPLLaA97TVxYCtT13zafJ0z0dfhfr9XLLzoVYyp7yOONiekE/a6hpdiWd7rNCdq5/E3lEDz1DBC9Z3PynmZlgsTn9MXUH7yiVxoHh9INE/qV0zFEKvpOSJQE1mCSOKcVdIyCE0RqZIZ0kk8CoV91jG/VUZhp3aIaKDrqgO+oDTohYT9wndUYKcr5tFBduwq16rQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 16, 2025, at 19:48, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
> Add a new helper to free huge page to be consistency to
> debug_vm_pgtable_alloc_huge_page(), and use HPAGE_PUD_ORDER
> instead of open-code.
> 
> Also move the free_contig_range() under CONFIG_ALLOC_CONTIG
> since all caller are built with CONFIG_ALLOC_CONTIG.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


