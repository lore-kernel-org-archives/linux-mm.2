Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBBF606A334
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hli0wnnO
Received: by kanga.kvack.org (Postfix)
	id DDCC76B05B1; Fri, 20 Nov 2026 05:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB48D6B05B3; Fri, 20 Nov 2026 05:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9A36B05BA; Fri, 20 Nov 2026 05:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A80C96B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:03:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4809D40E23
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:03:04 +0000 (UTC)
X-FDA: 85455059088.30.C4BF424
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79EFD100007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:03:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hli0wnnO;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795168982;
	b=BgV9x/N1ORs3rO7ZAWIjAGZL9OHEGTrX0vBNV1fORvanruit/N5cBVNrfSJOcVlwrH46Wr
	OF2ouFtTXNbVyyi10MGwB+2h5sXfvX+pLpRDkZaQfoKrlSl/hmAvz+BO49ofj5iGKoTOJp
	5h40AVXQoiA+GIQS3LQ3fpGRFHEK2uc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795168982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OG9wGQR7f5mu6l6IUhEOyBk2qztlmEiKeUKVEyFJTw=;
	b=aIL1fWEBNIoMkPmpuQ5gGWSxt6TvPdFbNKHuLyDhpr0QQyZNXEnQNmgd2q50k3KF2PMP+c
	vomAZAiB9rCUi+VhHuoeM2OdMaQDMbtb2W0NoghYogPyxi07w8vwSIJJ7QqsrU6T/u1XkU
	bg/H0MoBmK5VbiEstpCbt94WjoWPslM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hli0wnnO;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D7DE41771;
	Fri, 20 Nov 2026 10:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F0C1F000C4;
	Fri, 20 Nov 2026 10:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795168981;
	bh=7OG9wGQR7f5mu6l6IUhEOyBk2qztlmEiKeUKVEyFJTw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hli0wnnO5C3F5wE9WS1Ftt+8YiM6qWoePpnIzfTVOOdud2PNs7bpGRoou/Ui8PU34
	 Qn0V0QoYt02PHZe36dt0A+POB1Q2X8cwngfXcI+VOAnMh9MFa0oYQklzr/JkgFN2fU
	 KER8TJ7cMndYmhVHN5UvQyumiDp+fdBxfgOdEFIw3ZVluPPIcLfPdpSJ3nS5MwMAsT
	 MzMqcSJEbe9mvgrM8XB1pgh0y3VbWnsPLjYsRv/pmA7gO+C58/i2LbQPNW/u+kYrO/
	 PACSYIYBnVct7bKtXG41Qd5J3dQ5nABVPGErUJXdxG+BOREEZsGOv70Eo33MYqrsS9
	 zGDdlB0D8f2MQ==
Message-ID: <1f12c78f-782d-4d03-ac3b-7321520f02ed@kernel.org>
Date: Fri, 20 Nov 2026 11:02:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] alloc_tag: two fixes and one cleanup
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, Chris Mason <mason@kernel.org>
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 79EFD100007
X-Rspam-User:
X-Stat-Signature: 1zb85bhwx9i73gbdawyttzwn6rikgtbs
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795168982-478306
X-HE-Meta: U2FsdGVkX1+1JE/fto4eYQwC4maAB7/bwhrutyn1I+gJNAHMN1tYDEaCIVdKYwvie5rhj69DFzVH8h/ONJYa17aKmo12xCX6Cv7Oww4FgdGExoQQJ4GkMdqcmxUcqINFHdJGgrt/NImfU6MFMyx0ZqVCyhTnxmx6vjFSGFjL2CijmoytnJJscH2N8kaz8Cv7K6A369HNvHExqUK0wqRQIutQD6eqNsScNZKDVJJqr6Mf87Jwr5TT3iIrKt15kLNvp4JBWv1X0hrTxDRm1zNCnuM6vnP6v8A4925yrnb1/QrnyIrdOxrBF3PnQKzivN08FrjKu2/M+63jvr/oKkiUItNR9vnVEqrNQYmIUxiGKF+GxeB2ngoNg40f+EOFYojqwb/lVQLhK8FolmMJHy5NzxA1x0rcsO1C7dFF80JKioympvFWUJUfeQ74jmT4HtGu7vd/llq0WD52X6/IfljShmnIfSxNrZPVgugUuPKlbq+YT/DHOqu+sTU9Um+16CmzQ/J+OsMAuprQJodX5ALNFMNvCcsbn4dzL/2Di5/Z0Y3bZ7HazOcJAYWmH97XRaRBMrb3C2pmOJbvqTj7OxeWRXgiv5yTuejj40JvtRfqJQmVXEDLjKMLYA678Vr5Q1kbCs0lY3AHWlkO2GgsqK/bz4ntggMylfuOL6inSv+g/JDIq3QGYTGI2rYomceIEeQVBehbeH0MrCCk+qoARZqTv9X4mfL9U7YUJ0oPFPgRNu/7K5mPXw3Vx8qhGI/C3icoD4FTOevNR8wk2xvBL5WoDHpxF2WL56bczq84fsnwQ+qn0q6JJlMRa4ObMS5NIjprImXxgwv0c8BHmAEdUUhB9nzav/79TSxFy+qbufyo7TyidtS4+d3CLeUNhvDbvG9emtzsLShuBD2y6tkaN3Fj/x4XTHvPg1LCF895qyyTOp8iWALZpxgbDXY5F6z86Ehh7xbkIsczM1mAIZ/TMIt
 nViCO0J1
 JnouhP/ntzU+WVZTrfFw1/zk+FVIVp9pNeTiBZ7yLLvitqyn7t8+AZZSB7j8EsRZrak/qPen4kA2SMZj2MSzrurzxRV5LMebqLMCsnqZUukn1bEhylKoeG+moRFqiTsKKLr/qZeduKOs5A1bEU/MiuQArjSnQGJvQKnvIjiJHB0xh5SyV6R97QlxluVRf8lkrUrIHNqK8Bl+3iB+Dw8nyksSDfa93mJvqUUKcBp2xtxOEJGUjRZxMmDOHr9ymCyGkYvZckDmkdGsjI2TZA1DnVTL95bmpWogVELNptM1HoHZSRau24g1k1XN2Xt2aVTCbsUtQkQ5wSPIKTPWY/t4nkVUzE6cQJKZOT3LE4gaESB+sBtCNSqMEt5GdnhejDg5kEApyZ2NT4f4rnOnkxx8q8l8xvP5zdM1WWnETj4Wyh+wVhn0ItivQDJKYZviEK3D3HqVs84+fB/elyU7lYa86EvdwZ5tyqok+V6ODG7i6vw4yewdOcLlGdCiAYrX+edX6Ow4Xurb8IzHopoDaCjbsyMNZAdMlsw6juvspokQGPpMkD24lfAHz4q2iAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 09:52, David Hildenbrand (Arm) wrote:
> Hi,
> 
> two fixes (one for alloc_tag as triggered by slab, one for mempool) and
> one related cleanup to make things consistent.
> 
> Quickly reproduced and tested the warnings in a x86-64 VM.
> 
> This should go through Andrew's tree. No need to rush, it can wait until
> the next merge window.

mempool is part of slab section and the first fix while in page_alloc.c is
also for slab, so we'll take it :)

> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Chris Mason (1):
>       mempool: fix missing alloc tagging in mempool_resize()
> 
> David Hildenbrand (Arm) (2):
>       alloc_tag: handle a NULL tag in alloc_tag_set_inaccurate()
>       mempool: account the element array to the caller
> 
>  include/linux/alloc_tag.h |  3 ++-
>  include/linux/mempool.h   |  7 +++----
>  mm/mempool.c              | 23 ++++++++++++-----------
>  mm/page_alloc.c           |  3 +--
>  4 files changed, 18 insertions(+), 18 deletions(-)
> ---
> base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
> change-id: 20261119-alloc_tag-57326f1fcc85
> 
> Best regards,
> --  
> David Hildenbrand (Arm) <david@kernel.org>
> 


