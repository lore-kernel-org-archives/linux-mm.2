Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877F6606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=gNFkVet7
Received: by kanga.kvack.org (Postfix)
	id 9F9316B05B7; Mon,  2 Nov 2026 05:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A9C26B05B8; Mon,  2 Nov 2026 05:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7106B05C7; Mon,  2 Nov 2026 05:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 602D76B05B7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:12:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9F24A8AC7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:12:52 +0000 (UTC)
X-FDA: 85389765384.14.B0E1C53
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	by imf04.hostedemail.com (Postfix) with ESMTP id A3F1940009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:12:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=gNFkVet7;
	dmarc=pass (policy=none) header.from=ideasonboard.com;
	spf=pass (imf04.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIUHPAAXt1s3tQmTRgQTWCI8t2dy2mHDfBJvoW1CIRU=;
	b=kvFrMSpPXCcvydzok1QkHivAmKSX94hSDzyKo1LVLlCSbO7URqvm5FhaSlV7RF/841LLAk
	hN383lsEiKkeTjS0aeTYS8Ge/S/t61V6gBsFtSZb05vQGMhhgHDBSDiLZwz82GugwE76dU
	aNiIeAOj8CeD1tI8nEwr7NEEjUqkPDA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=gNFkVet7;
	dmarc=pass (policy=none) header.from=ideasonboard.com;
	spf=pass (imf04.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614371;
	b=muAibkshJW8LOusBGm7PNb2zHk6/Hr77/BKgvZ3ZC6PYPryM8LpV2O2iami4ohMuk0LREg
	ZRaSmMIm94cgxAzGKclH79m/83CzoPu8rwiZfnoKaF0Rw/q97KJslAu1HKHIQdfnNaeHOb
	sjaoyoXEPzqEkoS6iD3EErBysybt+a8=
Received: from [192.168.1.71] (cpc89244-aztw30-2-0-cust6594.18-1.cable.virginm.net [86.31.185.195])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 6D7E04DC;
	Mon,  2 Nov 2026 11:10:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1793614231;
	bh=Pbr7FqwHE7e4DKrbewizP5BIUnE5HZeSzQe6zlBuXgc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gNFkVet7a8YNgqKKfUattiD324ptZXZOwCs2ElXrPuQU7AEkmyGg5A9iUdpWCq4Zw
	 n3Ag9IzEx8qDyTSIvwUgNi6XIZEQ9M9OPU17+kQcdYSQC8OD5QURTc/RfUc8aM907v
	 EzbRU+ChlB6Zx8WxwMUhohSq1WiSg+C9Ivq9Tk/I=
Message-ID: <4898b6a7-1824-412a-aef0-ae6bde021e38@ideasonboard.com>
Date: Mon, 2 Nov 2026 10:12:42 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/26] mm/fbatch: no lru_cache_disable() in
 __alloc_contig_migrate_range()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
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
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <84ed3bf8-da32-3447-0577-052c5d1a56b2@google.com>
Content-Language: en-GB
From: Alen Karnil <alen.karnil@ideasonboard.com>
Autocrypt: addr=alen.karnil@ideasonboard.com; keydata=
 xjMEafxhCxYJKwYBBAHaRw8BAQdAXswEEnvxYiHXb8Q8GsSAuaLuXqJFs3kmsMI7EWF9EuDN
 NUFsZW4gS2FybmlsIChXb3JrIElvQikgPGFsZW4ua2FybmlsQGlkZWFzb25ib2FyZC5jb20+
 wpkEExYKAEEWIQT0whyXpTyoVtApVAlRzoJ78NRPngUCagGrrgIbAwUJBaOagAULCQgHAgIi
 AgYVCgkICwIEFgIDAQIeBwIXgAAKCRBRzoJ78NRPnkpDAP4kmtHsMfTtV6BC1z7GTb86BL2g
 9FC1EarGJDDzcafMGQEA6clsoXvRYjHPJexVebjmkI4bq1QM0X/L9Ffe0PfpdQbOOARp/GEL
 EgorBgEEAZdVAQUBAQdAsVoGZ4IK0EgJ8HU05PQKzK15jaCi/IEA/7Cw9ZzcBmwDAQgHwn4E
 GBYKACYWIQT0whyXpTyoVtApVAlRzoJ78NRPngUCafxhCwIbDAUJBaOagAAKCRBRzoJ78NRP
 nqYcAP0eh3LahCDsfNa8zsiK+8QzeujWPKhc5zDcIqrDI6xufwD+Mu9e202It54rNZb8UWEy
 V5OzTEy0JlsQfO6DYWIORwI=
In-Reply-To: <84ed3bf8-da32-3447-0577-052c5d1a56b2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3F1940009
X-Stat-Signature: 4c35sitmp4445asqogbj3775mcyygbhm
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793614370-257283
X-HE-Meta: U2FsdGVkX1+0CVfbm4C2+eKe2I0avnNkviRUakJD7TuKw76ZURThad+pp1JQpw7b0XHMz0+JQjFOOj6j1wjKq0CZo7OgZUC/YKEO6wlL5TFocApODzWRyetTch2OyZ7Bto8s2NgcaC5DRbiXjLJrgyFBF4yMkxqRyz/L0tHcjeklSqrxUGAHPLxVSvOxQi/SDvfn2eL/H4AelQULQuBRLjbRUJe6xS+AM7x03clNrtOyMPo5EWlWR9RsJEhpn9rA2gMv7ZhGXO/c1bL12M9E3EISCQWGFVV3WsRKasmwifqrfaTJ6UJogCPcPE1xqQjW/kdr6UtaoQHxSvPbORS+hQTCFKFZsuyzot/5GvHSWZBkUaQjDdbnOjRrZ4bx5SADNQpy9rZrZPZvdnI/fJxaiUTc3+E+wswwNMoV173lNH/7TypWY6ypG6SQlGXopF84JOG6t/E6LFJYwMVuTv9bg+4V0j0WsXzsG1rsiKHTJDZ/sSECWvu/X4ChvwOCMDpvrGawQvghivnSit5BfOiXMesDQlWIFbVt/IU7/BFy6JCrzVwHj0/+2vrX82Ho5PzCDad96jKieJN5dkH50Bdt9RarrbOur3Lz8GSNOeJ5m9n4N+hU7NFJwydli3KanIpKPyCejgVjOTv2sjvAyoKX+9AeP/0opLsbvHO82nQ7YvCrirJPIbTAIsAUY2dsIP4wbSxx8bXMv6+2KuFTr04zViBRz3DdjmC9wyhagP6+6BNkYauKOGsXITuyosXxMf9KoJA2iqKcsvzY6QYyXz+Y/t7jA/qsopPEq1oOfjK59BKbToGDcBQ7CODdd+8LEpbJJ2JtRyuRuQV/zVQ0wkbZ5hI9GtDOpayNjjuSllIHblN0xsD+0bxdOG2UwXnCTcc+EBepIt7bBkR6EXYg5gQOpf2PIqTB6L02NFFuimsNs/XBig+TSzKaZM5vISF4N+JEguUupbRSZTQjHjphrqL
 hSOvQM9V
 1HvPKf1vi4basd/QmgHAbmlMjIB8etzPKHO6ppPPWdV+EeQ2Da8ucMkQ7u79OJMOACaguDsPsYhxJOIa94EX690MDNsCg8sueH3LUlCJ2pofaTWyP6/WMIK3rrL0xExMPVRSN77m4tnr7ibd8qEh87lt8XbHrrlgajg6s6XzvlGEWpUZFARUEooe03QdnpdAEe6QpAYH/tqKs/PgP3QXuyz5iZFtDTiKveqct29WrEY1Sd41bQjR13kP3C0tLzN7qNgfdEE8gjq18kGim+qYRegdeAc/7xCTk7wTf+3IVXFSPqelWHFsvxdYDnXPeOg5z+/932KRPPKzdjDK2qGzJFsTY06JBcYZCQdOVFtHVa6t2OOSDZztTsAAGcY7fRH0ejJ3hYyRa+n1nt6QNhx1Qn8vcXLO25DGJiKS9lSoH0QYNnb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hugh,

I've come across your series because of a usecase I have, namely this patch.

Not to bore you with details, I got an IMX8MPlus with some cameras.
Due to the cameras (and other associated HW), it ends up allocating 
multiple framebuffers using CMA (currently 16 per camera)
which is quite slow (~200ms for a single camera).

I've spent some time profiling and found that the biggest
stall is when lru_cache_disable() is called. Just applying the patch on 
its own, I saw greatly improved performance (cutting the delay almost 5x).

This is on a 7.2 kernel.

On 09/09/2026 11:16, Hugh Dickins wrote:
> Remove lru_cache_disable() from __alloc_contig_migrate_range(). It does
> not now benefit from lru_add_drain_all() first; and gains little benefit
> from invalidating buffer head LRUs first, since 5.0 commit 80409c65e2c6
> ("mm: migrate: make buffer_migrate_page_norefs() actually succeed").
> 
> This will be more controversial. lru_cache_disable()+lru_cache_enable()
> were brought in for CMA page migration, see 5.13 commit d479960e44f2
> ("mm: disable LRU pagevec during the migration temporarily") through
> 8cc621d2f45d ("mm: fs: invalidate BH LRU during page migration") - I
> guess the testing there must have been on a 4.19-based Android kernel,
> without 5.0's buffer_migrate_page_norefs().
> 
> It's possible that invalidating BH LRUs perhaps 0 times, perhaps N
> times, will average out worse than invalidating 1 time and stopping
> everyone else; or that folio_test_clear_lru() failures manifest more
> than before (note how folio migration has retries on raised refcount,
> but isolate_migratepages_block() no retry on failed test_clear_lru).
> But let's give this a try and look out for regressions.
> 
> Don't delete lru_cache_disable() yet: leaving stale folio pointers in
> the per-cpu fbatches, with folio_try_get() yet to come on them, would be
> bad for memory hotremoval: the lru_cache_disable() in offline_pages()
> protects from that.
>
Can the patch stand on its own?> Signed-off-by: Hugh Dickins 
<hughd@google.com>
> ---
>   mm/page_alloc.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..3e085a25a776 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7147,8 +7147,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
>   		.reason = MR_CONTIG_RANGE,
>   	};
>   
> -	lru_cache_disable();
> -
>   	while (pfn < end || !list_empty(&cc->migratepages)) {
>   		if (fatal_signal_pending(current)) {
>   			ret = -EINTR;
> @@ -7182,7 +7180,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
>   			break;
>   	}
>   
> -	lru_cache_enable();
>   	if (ret < 0) {
>   		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
>   			alloc_contig_dump_pages(&cc->migratepages);

-- 
Thanks,
Alen Karnil


