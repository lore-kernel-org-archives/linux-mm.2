Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE307C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 16:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C819A6B009D; Tue,  7 Jul 2026 12:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32926B009E; Tue,  7 Jul 2026 12:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20EB6B009F; Tue,  7 Jul 2026 12:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 897D96B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:41:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 167908E7A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:41:55 +0000 (UTC)
X-FDA: 84962547390.27.DD5770C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7968210000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:41:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jq7tOwAA;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783442513;
	b=SKsLNzTlyZyZYZxkOMAgKz3FCvHszYbpGrvo+kVkX/vNwQrkSLx9uooXQppDbqiZ9cFNrL
	05qbRkM8Lu+j8fNQd7NDlmFH1Y18MnBDo5gLqjLYoMJ4gXK7hbh6REISc6qmwv/ckD85TA
	Hm7b8fpFjICJlYfZDiaa5h4N2/SsJX8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jq7tOwAA;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783442513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1LiWmdn4ANwF7mre0n2c9WYvUSe5HG3n8mv4iyoQ40=;
	b=zFLBciCdHpetuyfKdOnTrEmwxKONkqQt8zolMcRIkMQHwUtiRSAHTA9UjAHSGSUoI8gwLa
	WBuFQ/s0NpqtI3mzblCKG7dCVIGGvDmPAIouTsVJZHXTuNv/ThugVrBvUtZsqykDv2mlo/
	9Xj8og7PFKsMknYSm0GVirBRsVlMDZY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b1LiWmdn4ANwF7mre0n2c9WYvUSe5HG3n8mv4iyoQ40=; b=jq7tOwAATczN9vuWGa4uYNOle8
	PcqSZCkXc4xOdk/5BX18xB0iJkYSToB1XStWZcrwwPPFVffSKbe/AesF5XYJRx9LSkpWjLtg3vjp4
	d498m4DuNbYAQITcnKquW++TdLoTHOpCKkIBIQK8xlSnlIWzs2vhfQNUaAfMESx6PlUMbRqcKT8Wl
	ePznfcXoebFqOTTWE7aCcHIBkR0NDPkOyHKAQzt3d7fekqIH1/6neB1P0brRYJJXsMtPXVQy+QOug
	e8dl1660dt4RNjy8M95QSjB1zg3renXKiB3zk2wvQ8c0LfoVMWGSTRFxse8rOqxnBTIKe9TC/DgU5
	PhmAExwA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wh8rS-00000000klL-1ZZT;
	Tue, 07 Jul 2026 16:41:30 +0000
Date: Tue, 7 Jul 2026 17:41:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
Message-ID: <ak0sOv4UN1ug9-cN@casper.infradead.org>
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
 <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-1-e816812698a8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-1-e816812698a8@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7968210000C
X-Stat-Signature: qrqwkybh77agyhp91xkggu3n89iweh9u
X-HE-Tag: 1783442512-737035
X-HE-Meta: U2FsdGVkX19DawpBLkVKQJvBJVIyrZH9VuHhIUF5mE7CqQrV0xmbDRwCu1DfAP1U2gqUQAaShr0tvw8kXnx3RVl+hgd4VYYXYNRIRtExpxrHDi10nW4Ke6x8CbtSnc0Mw1XNDSGRAFYscNJm4gIcLXh76rtFLp6UELkacOR8D8W+uIeRlgZpMXTcG+TfQV9L65NRt052KuCVAlUrtz/4Wj9xEOSLGLS7h+9/7b7I0dMAkoLedScceQ9VtC9SB3cSNab+wG/dxnjQbNAA61k5HpDhBnLCHFFjVUfeU7zRblN9YMStFzwznMxvVTgBle8vNlnxEMqpKxsyffPUqA3CvQdc4dPkNKCg7F7Vb0PDIQxSbI9l/WOkGF9+HEhtfGel0I/zVBP0CAzgFK1vRWNsbE9QLW4jP4zXNOghw/763TGF4/fXr91zA8NsrNL15E0rxSJZ+8HhRsrMB8xCfklMN3WzpIlEfPMSIPpnktHU9GL9DM13NTzxBFjWuIP/wxrCKXApvOtPIuL17Ibw4vlJ8r7yxqA1vMA63kZIwbeCj0vXVEMXQX9OqwpC6QcLZ53FnExoMdzmGcHBeFlDk/7JZHsRSW/xvek99CZv6E79dDwOvKv6cDNT5Y/+t3P7wAFCTyFJs1EDe7ylivywGm8m9EJJ8sn80yCAyw95QvuPymvU1g/VrhbWKJ5nTCUOvhkOkJWEnW6r6AgL26qhIrfaIQ6eCZMh2/smV+uYYMRFkP2Ey7VM32IfbYJkDrK+WV/UGCWO+ynfb5VJGM/uhC+lrUOrQ6TqHn/Ma+F6aglYANlhToEaRd2rseKjHXEEjm+8x+hDHOH7tgltLaHGxzb5lg3hHm9eYuy2efauPZqDyYc8eBlaLYREi8Frt6w6DljkuVlQG3kAPQtlUKENUv/LGx6f3SZwClgDzCQug0hLumb4izvvYqDiLfCVSg8fh9WSrIgyr4ozMzMbRBdeWVI
 iYZURYHH
 t5WI/YA6niOoBrKnR38rECqvIKlaTZIFpK14fzOIrWZJJ0DVEAXMbk7BJbcA8YOY5DAN8ws40xw+ZggBCozgtdIZcxLTbIF+yt5wkAveCDl6ZU0Pc1zhWgTryEFWUkTo+W66mhdi3fmbIEYOffCuy8XowvJUVdRCEqZdOsPEUdmc81hYnFE7KhYZrLZUy4CPM+qlOEZ4HDAZ8Ku9ofDhrw+JwMmYOhhrNaekZ4gcFWGUnnyXL3gpPXt8F5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 12:11:27AM +0800, Jianyue Wu wrote:
> +++ b/mm/swap.h
> @@ -336,6 +334,7 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
>  
>  #else /* CONFIG_SWAP */
>  struct swap_iocb;
> +
>  static inline struct swap_cluster_info *swap_cluster_lock(
>  	struct swap_info_struct *si, pgoff_t offset, bool irq)
>  {

This change is not related; please drop it.

> @@ -985,6 +990,38 @@ struct folio *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	return folio;
>  }
>  
> +static const struct ctl_table swap_readahead_sysctl_table[] = {
> +	{
> +		.procname	= "page-cluster",
> +		.data		= &page_cluster,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= (void *)&page_cluster_max,
> +	}
> +};
> +
> +/**
> + * swap_readahead_setup - defaults and sysctl for swap cache readahead clustering
> + */

This comment:
 - Does not need to be kernel-doc formatted as it is static
 - Only contains information that is obvious (at least to me).
I would drop it entirely.


