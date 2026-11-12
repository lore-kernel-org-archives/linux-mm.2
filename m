Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1464606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=F+iitw7e
Received: by kanga.kvack.org (Postfix)
	id E731A6B05BD; Thu, 12 Nov 2026 04:48:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4A916B05BE; Thu, 12 Nov 2026 04:48:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FA86B05BF; Thu, 12 Nov 2026 04:48:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B26A16B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:48:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CB8AA80FF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:48:33 +0000 (UTC)
X-FDA: 85425992106.08.F1FE578
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf08.hostedemail.com (Postfix) with ESMTP id 197DE160004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:48:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F+iitw7e;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwA8u9VJ9m6gnHnzfW8zxz5hofEESJUkeHdy358lFOg=;
	b=TYBBWDw8V1ly0j1awGTLCsaICCE73pCDJaXoaXSoI6YMZO3Id3ZwHsfHc5H9ufeNE0P4y3
	YU1OThJyM4zDGcyT1EiAIWA87Saxs2rET/Blzx4JWA9xmbjbVr5G+zPNlqY6XSscuOm7T5
	iuUmhB+iBlL0vXmUcqRD+kiMB0PdyVI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F+iitw7e;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476911;
	b=kC+3VQr1KZH4eILqa1t5cj6R+lQFhs6j1XOqJ6tcE5Xp+SVAgar/RHkJBkbpLUX+jnPzMJ
	JhkdyBE6LOxrVWeuUwYvVm8cWAOLMqLzrswH4JSrse4wSw0fSHOikz1Gg9ddV32vffCUob
	8z265CbFCqNjA2B0L1sFrCXOmtGOdsA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794476907; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gwA8u9VJ9m6gnHnzfW8zxz5hofEESJUkeHdy358lFOg=;
	b=F+iitw7ehln9RVD/DgVOWk/UWo70w/PS+mnu6Yo8jSJ5ZzentB2gDJPxQYi/ZZr+LJ+D4CbYdu2aEi/3dmnYy72q1WDCLD3CU3cOvEhjvxrHknl5pmgwUNg1ZB/aIeBbkkJknUpAw75MsoPxk7HsIarI5E8mqTf4VXj1x8TQ/2c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEbbDux_1794476902;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEbbDux_1794476902 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 17:48:22 +0800
Message-ID: <bd25f767-1f74-4721-9264-92f3031d9109@linux.alibaba.com>
Date: Thu, 12 Nov 2026 17:48:21 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shmem: remove truncated folios from the page cache
 in batches
To: Qiliang Yuan <qiliang.yuan@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261112-bug-mm-shmem-undo-batch-v3-1-212db8c24058@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261112-bug-mm-shmem-undo-batch-v3-1-212db8c24058@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: caujge8bg1776n88djmrpn4uimnayfni
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 197DE160004
X-HE-Tag: 1794476909-1981
X-HE-Meta: U2FsdGVkX197ehSZfyujGPYUrhCOnzVpLHscCIg3qbbbeocog/Vfvl9pbu32XQi+Gc7MOC3qd6mhaX6bhb7raUY8ZEwZ98R6LgMD9+IZPJ/wEVFI8UE9ALtFWojH9C9x6aoRpEzrKjexGSXW9K9u5G8VKMOmOLA7l87tiBGaQuZm/Iju3pJqksErUpZaquZ+kpcnZBiiWR4eBPQDmHoW6LA/mAx/0rurZo57GE0+bSZIJe8L0e2BtrWJzpDNv32M/mp2Xfz+vwLptmH65d8+MoPL4GLE9ih0tCpqZEhuefg4+JcbLzn8riPw5fyHv26WF1O3qTjV6SkMGG5UymmG73VO7snu7BOqOWzXIX7d7sIos49UXvt6sn3OIaqU6+wLxE9PSH81hHWrNh8DTKi3u+Tg4vjsFqqpJhmlrlxbQmNsMe6+lFfU8mIa92NL60ctbgADaHI7V9tPfh4JezN+CbtenFYWQQncF++BHZOTsicsaovOC5sCWbVpOQm0WJTLDgUQ6vi103LF00o4tpOtvxjfwqI2TS8oZf1xFRMvz1wUkpSmg31jrGEXhw3By2EWwEaB1AD1PifsEPxH+bp6AI1mhUQ8yhM7qC9EsqKbEVCgNTD6I4ixLZgtH3BYM49merlVJTsBjQjGIbWDJbp/CIq6Vi9DxjgBAU+euwYcuNCrfp8ZCZ21Kq1DkKk17YTb7UBvIUo7H3yT1uAr4TsDKEEODnFCknY/+yAohtjkzYcgdyhJe9Gzl91PYmERnAGiBtW4NdM9dRlwVuW+X7+hlru2nkEQLaq4zi0nmCOTprAcliJ9VpQknm1JTOkbCVSPO234ge4B9JraNouGla0v8ZU35ywnVys5JBlIlEG/LeoTrmAcV7o/0WuSD9h6FYqfwN9zQrkY2CWzTj5aS3h73XZK+6houq7pP9pZ9YSLsp/hhryudh9jl2Wc90O85EQt4lucmgqs06Kyq4XS0+C
 HbiwjxpK
 2UVuGCRK195o6mhUTeFEKsg5Y2XZMnDnpxlsSUOC9aHs8D99b7R0A/i1r9wZNyP+nWTtEAPTuSGWm+QSThinmUWsD0jKNxomRz8P0ucmxcyp8XjfHPNEJGHtDSQzm3FFQRBaNJ/0Q2KSBB0Xf/eMvR6/00KnNNmEbTGS+RXXwrTjt0eSGgqtojfEBpRJF8DgZINUysh+UuuVLnI8KU1YWmOrvTEPrp0jMqhqwr4Q4hgkH/ofFMvfnjsU+TvnJRLSy7TW/j5aHiPoxFXT2Q+MbmhQhsnvnelGtY6ILX2XyJe+SiX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/12/26 5:05 PM, Qiliang Yuan wrote:
> truncate_inode_pages_range() takes the folios it finds out of the page
> cache with delete_from_page_cache_batch(), which takes the inode's
> i_lock and the i_pages lock once for each batch of up to
> FOLIO_BATCH_SIZE folios.
> 
> shmem_undo_range() calls truncate_inode_folio() on each folio instead,
> so filemap_remove_folio() takes and drops both locks once per folio.
> Truncating, punching or freeing a tmpfs file or memfd made of small
> folios, such as a large /dev/shm segment, pays for that on every page.
> 
> Clean each folio up as truncate_inode_folio() does and, once the swap
> entries are gone, pass the batch to delete_from_page_cache_batch(),
> which needs truncate_cleanup_folio() outside mm/truncate.c. Undoing a
> failed fallocate() only removes the folios that are not uptodate, so
> keep removing those one at a time.
> 
> Dropping an 8 GiB file of 4K folios in a 32 vCPU VM takes (median of
> five runs, averaged over two boots of each kernel):
> 
>    operation           before (ms)  after (ms)  change
>    ftruncate() to 0           1144         901    -21%
>    hole punch                 1148         906    -21%
>    close() of a memfd         1139         912    -20%
>    unlink()                   1142         914    -20%
> 
> Files of PMD-sized folios take 18-31 ms with or without this change.
> 
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

