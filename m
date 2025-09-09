Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41756CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A2B8E000C; Tue,  9 Sep 2025 04:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8381E8E0001; Tue,  9 Sep 2025 04:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726A88E000C; Tue,  9 Sep 2025 04:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB948E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:12:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A18008615B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:11:59 +0000 (UTC)
X-FDA: 83868993558.22.CB87EB2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id AB8F41C0015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:11:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oPcuHsVi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QOwWMez3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oPcuHsVi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QOwWMez3;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757405518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0t9rDplzPdZ1xQ21gXDF2fVB1ygxOCHI36axj5nB1o=;
	b=L6qeXwh07wXHXq4S77R4qX+6FVkJYZe0l1ADsKh/2u2BduYwZw2xNJOnwVykkPoHU0uvW9
	ob1qgfO4Vo4o7Kjst/HtiW6b27/Q6jiXtB2m2UXLLaF267YbmO0dIydZWCpmxRKxqhKwh7
	Ov1Di35vvXGvw7uP/Te1QiucILlRK9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757405518; a=rsa-sha256;
	cv=none;
	b=daCfmubp9ftm7jGoa1Epf2yOKLzeuXgNBDOAJTWDyjuulcSQJxqLR1QjXQjqcH+RYyQs0T
	ZPKR0+M0Vfzlplb1UeDYS3k3RKU2ngI6SRrV889NakpuXBbwUA6H/IonJjWpiCUwxAs9aw
	NfYbT8Jksmai1oPjCaocCLzDZ60vZtM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oPcuHsVi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QOwWMez3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oPcuHsVi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QOwWMez3;
	spf=pass (imf20.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0B49620584;
	Tue,  9 Sep 2025 08:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757405516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0t9rDplzPdZ1xQ21gXDF2fVB1ygxOCHI36axj5nB1o=;
	b=oPcuHsViA/ZJdWbt8Uj5OVRnsvoVFrehGgZV+G63sAWJrma0mWG3GNYdAP8yhnkPW2N3md
	CmsVVc7GBwZyrQyp4B2twwp7E/kFyJXfGYxnIbbOeP89t0XrD7gymQLdls4bg3JeA3X1UR
	t5ZXesRcBbUl0ippngTnl5Gysbfl4fA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757405516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0t9rDplzPdZ1xQ21gXDF2fVB1ygxOCHI36axj5nB1o=;
	b=QOwWMez3keNGgH5ECPrXeOOurCjnrTLY8zyJAVs3legk3yLUlD0o2qjUpNngCphmL8PV8I
	a9MMw08CwLJOFwBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757405516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0t9rDplzPdZ1xQ21gXDF2fVB1ygxOCHI36axj5nB1o=;
	b=oPcuHsViA/ZJdWbt8Uj5OVRnsvoVFrehGgZV+G63sAWJrma0mWG3GNYdAP8yhnkPW2N3md
	CmsVVc7GBwZyrQyp4B2twwp7E/kFyJXfGYxnIbbOeP89t0XrD7gymQLdls4bg3JeA3X1UR
	t5ZXesRcBbUl0ippngTnl5Gysbfl4fA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757405516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0t9rDplzPdZ1xQ21gXDF2fVB1ygxOCHI36axj5nB1o=;
	b=QOwWMez3keNGgH5ECPrXeOOurCjnrTLY8zyJAVs3legk3yLUlD0o2qjUpNngCphmL8PV8I
	a9MMw08CwLJOFwBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62C071388C;
	Tue,  9 Sep 2025 08:11:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nW36FEvhv2jfcQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 09 Sep 2025 08:11:55 +0000
Date: Tue, 9 Sep 2025 10:11:49 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 6/9] mm: page_alloc: add alloc_contig_frozen_pages()
Message-ID: <aL_hRVLF0YoUFmWh@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
 <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-7-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB8F41C0015
X-Stat-Signature: txrt1yhrosx3mrjnfqdre5pbbyuec84r
X-Rspam-User: 
X-HE-Tag: 1757405517-319832
X-HE-Meta: U2FsdGVkX18Q7vRzfm7PSeZHeZzqwrVA5V0oN7uU+qi7S/xAgvujKZFrH5Wmg7h5Ac6GEwo6n7PEo5HVMs2snWx0xwmhLRKc1iepPxJwQtd4NAnwRAcWPU6YqMkFcjFHA2WIyos4chKUUBquaEr1C7gfYWvPTd9a5fzNqyg+O4fLg3a4dNOQ8UOahqVbDm1YHgD92W/NeXt9yTjsfyZ6FgQqDaMRhcpT6aog9//fQLjhIETUeZBNrstPNErCzUFbHvFHzYpY8GgF8noW5M/gRTOxvXBQbe7HqlI2DIzLMu21V9cPPpEVcBgoa043ZMs8DQcJ31lqv4gMe3zp6jyBPvAsoI0BLXSsykZmpYtkN/CMHgIr9OOSvwBImdK55HMuTCs35b+Dnn+An+QUXARqflMViOTkw4XyMA7iwlvy01juBzu7XKf6K8NBgfqHuBkunv020rnY2TnT0xfuSxne9P3Z+dVSCeBbC0jb2kNw6Qf0UaRdVTV8ysb2sIDrTfnCHLThxwEloz2ltOlfFYO+ILMAslQoWcXFxEj3bLA7ktvZPbbVp7mp1embFqZpCQ/7k8KeDLcYWSGX2H9ucWApeNeNkp8XOeoFCIGseXxMzSk5ibHGUnEzi5AdBKaVCVWfdwgEEkF35Xuu7WV+s6uvOBnLOh4qVwZwGxlHiLorccLkHLlXZeHFObl45RPaGwuxsRVLpqYo5Mm1RWfVa/BuwnG+HXNaCBRoeB/GxK25o7DZPUFPWJYuQF/uLFXPybVKBCTi6bk4/7sz2i+QFyXxaaWTxAajWckkhj5Ynb86Z10hjqcYkY+VwXnwWUMvRTVWugagfM0FBZdIvgfG83T42d94UomOnwABeJODhFcCCfGADPFWqeCCzzIUBEpeagcGY2EHwx+kx8ODpJrlNoljW/jKaH9f5IGPV9gmqSvAS+2V0WYFWo6yrWFA0DG/U3UAP7FOmui0gKf+xwndqC6
 7ZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:17PM +0800, Kefeng Wang wrote:
> Introduce a ACR_FLAGS_FROZEN flags to indicate that we want to
> allocate a frozen compound pages by alloc_contig_range(), also
> provide alloc_contig_frozen_pages() to allocate pages without
> incrementing their refcount, which may be beneficial to some
> users (eg hugetlb).
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

With the feedback from Zi Yan addressed:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

