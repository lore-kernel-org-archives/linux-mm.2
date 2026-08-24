Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA30CC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 18:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884DA6B008C; Mon, 24 Aug 2026 14:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835AD6B0092; Mon, 24 Aug 2026 14:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD6D6B0096; Mon, 24 Aug 2026 14:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 459616B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:42:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C518914016E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:42:57 +0000 (UTC)
X-FDA: 85137034794.21.BC39D7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id EC6954000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 18:42:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGsubsYw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787596976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSv/6rdiV+Ejdm7HFNd+vWPkKgnm+qhrHZ2IOgt39vQ=;
	b=tOaQSGoabotyKfI9U/eK4poDIKh5g4qJVUH80j0b1Rtl5J1vgnXDSXtBTDh4EeAWO/ayzz
	IL5dFfO1AL22keRWrnB7+hnH2Y6WXih3LF7Y0aJXBgh/OwLDRZilgXT5C1B9v6dDXC1Imq
	5KZU4O4mfMs71kOZ2x4rMWIROyj3C70=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGsubsYw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787596976;
	b=QLHtnHWzzqaRl8hxREGHb6g00956EuRN9Fe8R5Qreqt8hJDKaZTi2OI+KGEhbb/AN/6Ph/
	G9mC+ug32ry5rhUDwQUAvDtC/LRuK2A2EWZ7Y+3We7i6ykFOcr8oUVlB2xBelhLmiPkvKQ
	Pc39PTyayFutX0SZQ4fUfLW57h/easE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3436417DA;
	Mon, 24 Aug 2026 18:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49C11F000E9;
	Mon, 24 Aug 2026 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787596974;
	bh=jSv/6rdiV+Ejdm7HFNd+vWPkKgnm+qhrHZ2IOgt39vQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QGsubsYwz9ZWAK5Nx5pYkp7oFod7EReTcX1RaAy4vBSPNG7ddLoVNGIcGRgjIhvaP
	 9oWIEqC7E12TA4a7kdXBLGNML5/nBXA/BNkBsPHTBcvOCQaB7kVZcdAou4Z+EQvILt
	 bWMAW+jf/5ZQ+5pPihyuNTpb/Mr8A9KsQ4Xsllzva9Fog8NgAMVuEcQ9uQ2NMGlMas
	 25yHVWNhNigMjRz1r4TX8kbFH3F+F2cbOcPdqijAAV/osDk+ZHRdZf1XaSiH8UKPUs
	 zTHcg3CWCzaTSpR4E+jasfUlAUwnhKoSrEpOQg+Gn3hfMA5Q5sfpm+q0USX60/LRZj
	 0KskYmOWfUhNA==
Message-ID: <5d42fbfa-1cc3-4161-8ba0-7318267576a1@kernel.org>
Date: Mon, 24 Aug 2026 20:42:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH alt 13/25] mm/fbatch: no lru_add_drain() to
 collect_longterm_unpinnable_folios()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <fbf3fa74-c646-8855-17e4-e8b35dfd9c14@google.com>
 <333bb765-a36d-e07e-d3c4-5ea2f1cadfcb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <333bb765-a36d-e07e-d3c4-5ea2f1cadfcb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ppzg98akukdbusihpeqmfokoseagtq6t
X-Rspamd-Queue-Id: EC6954000B
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787596975-335870
X-HE-Meta: U2FsdGVkX18qMr421iE19BoChWy/r/3w0opPPJe2MJsrqxEwpZ/NYtMIGZaRd04ZQCE7Xsh0OKhqgdGXnE65l5VbSrGrkfeVTt/AdrgXPywiIAwVSecPDtiPJGN3s5oPeTqgrOzOQb9EybvkOo0NuH4p+I3zeBk9b1VvC5z4eB7ZTfDtqfNMGNFhK+OVu3rThqvw/oHr2K9IF/mdzaMsh6IaHCi/ZHQgLnfvBJr+BgVXj+SDaRtb1f6zS10rcZr7ylMTmW8XyLLQnZXaY9USqL/T7+btuXZM303eo//sDoBMqmUvBD03SoBS+cD0r33n9p0EmxnCMv2OcDhk0QHIURj6Siq8fKZD8VfkjXmFSJ1e5OqUKG6dSTu8UWIxPJnlZ37SOWW0ZIByc8VyjCLnQGwhGPo152ItUvGJDhRrieSOwgknKSGO+3xeNDibxmJFZ4FHPTo6gCiKCrZAuhjRLzQ0r0pNCO/6ph3GDx/0SHELVV7qhuyB0UXQHkaJg3ARQ6KMz7dB8XSMKHu/8FHsCaSFu0qpO9g6UU0tbtDZifa6BS5W8/q+LGQbX/avx3d7n10SNcxPsx7+8Lt7lL4fxt1qPAd384e8tv+DtqeJzBHOZbtVGS5RTnhg77Lnfq2+AAXUFTNve3En5Ci5yw1koqkFuW2cvsA6r1fORL0oDCU4xCtKz3T0tANf6NHe/srNRqyphMyyEsnk754XlxCw6StwbicdqUKKRC2yTRkjwz9Q8aqqtkMhR+5EssHbwWhMuiQEc0jt97f144SRtluBEuZir5Z0PoDTEVpdz8TROPl4cowSL4TBehygEUJdn+Utox0Vhf8MEsqqj3i18wxJJt/ywFDMX21bcfJatqZiAMy/SYDCvCj5dr6XYMxjWrYjNJsE1CvbEI0CI5/VrXRv72KxGuH7/jdXNcme+oE17192SAkHaKelebtsJgSKpAhltPTAwPpXzHTEWYwCWOV
 sRkKEpX5
 9gJMUG/gq7xELOAspkH3r4AVx7/yWaYnmMX0ubrApv0+c+BwTQiR2uP8FjNZFa50H8KOH3nRQh/Z+y2pW6tcy9iSd1wsgLyY0eloY/1iIftjzdY49k1A4NocA1lVCWa2lxSuVu8gjzhp5nA/f8r986OmMk+/eN9wR9IFYL/2oAtrIALb49fTMcpmDRd4DCfKRc2tKWyJtgwKKCS1dTYzdjQR1k6H2sBtF23/sokhOJEVUeEJ3SsyCxDJ1uLGe8t4q63V0iqoOAhJGG5Q4kL4hClGQAQcT8uY2nGhCrW6LksKw9KkydxNe8Mmd3nP2BI+4TB/9xVVkJxkhyJukbPOn/0Kvb7dugnJzXIYnERfMpV4VhSmVuRuIm04L5MvrVh2a5C05oDOn3oER7F3SNPxXTHGPDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 16:55, Hugh Dickins wrote:
> collect_longterm_unpinnable_folios() has no use for lru_add_drain() nor
> lru_add_drain_all(), now that the per-cpu fbatch references are gone.
> So remove the recently added lru_cache_drain_for_folio().
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
> Alternate version for use once David Hildenbrand's two commits
> here have been pulled from mm.git into linux.git for 7.3-rc1.

For 7.4 we expect another user of the helper in KVM guest_memfd code (the
primary reason why we introduce the helper), so depending on when this series is
ready it will just remove that user as well, or we'll need some coordination
between trees.

-- 
Cheers,

David

