Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76473606D81B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p4EEjsWU
Received: by kanga.kvack.org (Postfix)
	id 788E86B05C4; Mon,  2 Nov 2026 14:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739716B05C5; Mon,  2 Nov 2026 14:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E8B6B05C6; Mon,  2 Nov 2026 14:16:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 438E96B05C4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:16:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C54CC140201
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:15:59 +0000 (UTC)
X-FDA: 85391134038.02.5115B9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 04CB040008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:15:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p4EEjsWU;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646958;
	b=KiKgKRIu8+ZuiYnJfVw9qE6mUmcTxWKysSfOw40y1xAJ1CoBjGxOk2GOcV+nX22hVDFyAu
	tgDaZHKREmqPoEAicamoLFZEXIsd92L6sYZRrIQlqoTEL2wXh6gmR9SC9tZtoIGfuOf4rY
	QE2AqroKzAXiBiYgeUlm3StpIacWjP4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p4EEjsWU;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcbHN39bNWWbkdcjeJxDmeD0qc1zW2q+oJX1vCZ0XVI=;
	b=ovI9GRPW0rX8cUeqV94M6SXwe8g6zp4IKKfggMHSi5E5JEfQdZNeRCNY9MaczgfT05msEf
	TmwULiI0/avIaiEAuITDP+kmkKR+8h6E6lbTYixfhWDm90aHghaARZDtJ+5uDrQ2jiC+I4
	rczWQr99Pzlmk/K0S5j60IblfqA0wCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24AE660F19;
	Mon,  2 Nov 2026 19:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBA91F00A16;
	Mon,  2 Nov 2026 19:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793646955;
	bh=PcbHN39bNWWbkdcjeJxDmeD0qc1zW2q+oJX1vCZ0XVI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p4EEjsWUt3MhEpUIjyLqzo7WSphxnduiMFMxPf2nUtQftKt6+8J2muQ+NicZohSCO
	 F7rbgElz8NIWQMbuaBTSQHD/+sq7+IXuDa1D72zQJ4SAXGDcu5zQqO0OPtSvf/5kMw
	 DCvQui3dtzvkQFZhE9fFZkIbsc3sqjkQRUJVSAZ4=
Date: Mon, 2 Nov 2026 11:15:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: daejun7.park@samsung.com
Cc: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: keep at least half of the async window
 when aligning it
Message-Id: <20261102111554.535bd2c6d0520877ea3342bb@linux-foundation.org>
In-Reply-To: <20261030-mm-readahead-async-align-v1-1-109dea6851fc@samsung.com>
References: <20261030-mm-readahead-async-align-v1-1-109dea6851fc@samsung.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 04CB040008
X-Stat-Signature: 3zhoyrdwb63fn1zkx147du9xce3e86aa
X-Rspam-User: 
X-HE-Tag: 1793646957-720916
X-HE-Meta: U2FsdGVkX18TAyL4ApL+Cc5y/BB8hmNNO21b9wtLQlKMbHdKawium1xKssCkQVeaTQaeZjCAAvm9odtUELWagGAFIpV/FESmzJ+r+AaSXp/jLkXtY6EavLjsfOe9ahsuwwBkotTCd4S+UQowjd4v6zNhQGX84T5BX+wIetD9JhMdxNKmo4wlOMmNi9S8Hp1FHewBT8NrL+JsH5x1ai+HrJPUhSBb/yqB3PmTIgGjtvcjlKrsoPuPi9a8cbF1aroN5ht1Xi576lbH6wooPOyAzhYo8NhW5dPovJbwGmbCY0Wn4o3AFsdPCo//T3sJSVMcuQ9zk8CoSL+EmO1/ae4LlN94nxYqyerHKEMfai9TVwhyriuF6qVXvW0c+M4fS4AyHmltWTE8zoC0RzNJ6pDhQHZqdkUD2TvlasJAtAOpopAQgRc/EDjqG69bJ0CBo5GH4Hbq1UPsXIZw+FQUeKSBQPuuCT9XhpemiZ4oVtvoY0Fupqoo8rAeCV0Buya/CULqqIZCUNnwKskKpB9pgn66ufIV/GwLfeMZRnjvQ1t42lgBHmlGiFOkP6V2rt/K2CCJcEDIXn1IDZPF73U4oc9RzFN50r44SqhCypMzCffdW7BfKCSQ6eS6IPAupLkUUr2m4scljp1honfpszUyWx34v7V5MnAbOr7p1xQH5NFZcIqSnNdcodwN9DBwr86YUGrYHSVuKRwRmZGduTUZJVfBI345hr7UWO7TpQuy2t10S86PmZLt8xbWRTiDy1xLjroges9yoJ3TtMD12bKYccl/xm4XCH7jPyFWNQ2g7QmAMe9k6tko6WJ9tIjJwCLRsNsVqRhrO4OeRre4mYnFNv/OBBLrIR9t3176jgOIMsT1cAOI7BMLkPaPvNKTWNRml00KABfEfAIYLXyUdIisz6iKVCSp8gCdfkfT2s8l4HXLzn4JovCSlbHQHjK9aOlZdpwvhKlEwo87AwD6eW50MfD
 vxHd/Zi+
 /x4xI6CrnMS9WSr9VeeiRMfRkXTQl0gjCyXLOkbsv7b/BUNeVxO7TDrez6VcROJkFZzR5CnOsxLREQY/eBAW3otPcEnW6ILPbW1K/lVo8DmMP3iY7wTLsAKAiSynky+7KM1fQwCBmYrZmISz3Q05L0wx5RtGf+W12wZaRhxM98Pl1BvwCKjMReSwgucAC6OlVs+3tUZSckT/pgDk8zo3oYcttQn+VRlWGocyFqa5FUtHPsCWnTj4j8L1Mvqw2chwtUGRN28nFkEt224DglDmOtZ32/g9Tt+WqKt3Bp8t9LZZLOpga2oqmyS9pduQ7UB2debG3e1HklcFb21Qxli6IaHzNeWxwrZ2Txi2TFxCvJX89obF2XN0GF+879h4aJnAQsKOcYgnzq6x0h0+zdoy7RZr/O7kFCwjwG8npFUROwMQKYo1g7Ek6bI3u1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 12:52:57 +0900 Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org> wrote:

> From: Daejun Park <daejun7.park@samsung.com>
> 
> page_cache_async_ra() trims the end of each new window to a multiple of
> 1 << ra->order pages. A window that starts just below such a boundary
> keeps only a few pages. With read_ahead_kb=128 and max_sectors_kb=512,
> 1 MiB reads after a 4 KiB read at offset 0 hit this on about one window
> in three. They issue three times as many device reads.
> 
> Halve the alignment until the trim keeps at least half of the window.
> 

Thanks, but...

> ---
> Tested on mm-new in a QEMU guest with XFS on an emulated NVMe,
> read_ahead_kb 128 and a cold cache.
> 
> - max_sectors_kb 512, median of 5 runs: reading a 512 MiB file this
>   way takes 0.247 s before and 0.180 s after. The device sees 3329 and
>   1032 reads.
> 
> - Other reads with max_sectors_kb 512: without the 4 KiB read, and with
>   64 KiB reads, the times do not change. Random 4 KiB and 64 KiB reads,
>   two interleaved streams on one file, and 2 MiB reads at random
>   offsets also take the same time. They read the same amount from the
>   device, within 0.3%.
> 
> With the device's transfer limit at 2 MiB:
> 
> - max_sectors_kb 256: 512 KiB reads after the 4 KiB read take 0.626 s
>   before and 0.322 s after. The device sees 6147 and 2056 reads.
> 
> - max_sectors_kb 1024 or 2048: 1 MiB reads are not trimmed.
> 
> - max_sectors_kb 2048, 3 MiB reads: the device sees 343 instead of 271
>   reads. The time is 0.120 s instead of 0.118 s, the median of 40 runs.
>   The interquartile range is about 0.10 to 0.13 s for both. The window
>   stays at 3/4 of the maximum, off the 2 MiB boundary. mm-new reaches
>   that boundary by trimming deeply.

The whole objective of the patch is "speed things up".  So a description
of how much the patch sped things up is essential changelog material!

IOW, please summarize it heavily and include the performance testing
results in the actual changelog.  Low-level testing details can be
retained below the ---.


