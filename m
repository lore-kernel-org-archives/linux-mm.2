Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A537C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5DF6B009E; Thu, 27 Aug 2026 13:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876086B009F; Thu, 27 Aug 2026 13:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EC06B00A0; Thu, 27 Aug 2026 13:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE7B6B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:24:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE7701A0125
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:24:05 +0000 (UTC)
X-FDA: 85147722450.14.62C62B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 025BB80006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:24:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzLpiBjN;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787851444;
	b=3fuCeJiKg/Eme5WTtyDzE1GfN9HDSD8qcfGXS3yBW1/UEcmJMPEXwERhrhoakcjWJuW2NQ
	VBu7vjRjsgvlCRBubPX4bFqig7jTSQ8PAyvvkqMk6rgC3lvqZBBjpBVVL+3cHzNAppStAk
	9xjVPxidgTlTOMVxNhNxmqjRk3lGJAE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzLpiBjN;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjfGfa7gS4D2wDK9mCCSlkjUdk96fAt8iFKlJ66xdXk=;
	b=P69Vixz2TuSPx6Fwus6iApBdad+c5G+C/vo+HAu82W8eLeKE3nTsnRkc3xyZHdVQvJpHtK
	k/xRlY75/+49aAIi1mcQmN9GJxuhTcn5GY4bmLABt24/xlbvnX+HX9bDV3fYRLlNl+eovL
	VhzPlMjSbmgvpAN8BTjFgQlOTMWNhW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ADDF413C3;
	Thu, 27 Aug 2026 17:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14011F000E9;
	Thu, 27 Aug 2026 17:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787851443;
	bh=BjfGfa7gS4D2wDK9mCCSlkjUdk96fAt8iFKlJ66xdXk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EzLpiBjNYRL+cecuiQoLhAzu7P8qyHCBg5rZkgBcp23SnYHYI83dN1J3k3hnXWUun
	 sf5NLBe4/3OssrfnO52PXIBY48h6Xl9YhU1d7FCXkCP2aLD0U1fdzcIBv3WdqSgFIz
	 hjadHXoPzSbMVpUQiJ+eVBHaNsUAcC6l+ka6F9DHPXTRCtvOgwIhoh0mup9ELuSwDL
	 MfL8FqK5PMcINwus6FEHP6gldl8wXFCgjAYaKrMo2JcyUVvoFRvoOWZfcgT/LyrVJu
	 9tcvciVYTK+I3cB2kbcTTqpwx3p1mK4QvoFlxEMKppupZfkHiMpFIOMhFXMGViy5Lu
	 9L8/+h48xIwDA==
Message-ID: <7fb30b85-ea60-45bd-aef2-494943b524a0@kernel.org>
Date: Thu, 27 Aug 2026 19:23:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/25] mm/fbatch: remove !CONFIG_SMP special case of
 folio_activate()
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
 <3f18ab7d-c12a-d2a3-4d3e-f9908f94f27d@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3f18ab7d-c12a-d2a3-4d3e-f9908f94f27d@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 025BB80006
X-Stat-Signature: n3p1zckpa1g1jqfs3xsmhs4cyqzc8xbj
X-HE-Tag: 1787851443-117093
X-HE-Meta: U2FsdGVkX197aC7YSlhLGfwnbEYthCY8XftCn67Cl5zkVfivtTU4tGe6E4lxR5dIS56mk7V8AlCHgYe1ZGWL5GQihVDFFTHc6elUwTNR589/5KEWmW26drZ+vcq4drgWzypcv7oxk/I2VDIdUl9s5dN5gqQVS7PEYNvSZhlQ2rFOZUzMJFIrNywu/C8a78OfJqzWTLnjmha0GCUTR/b+9MIJyHIHqb4gNKwmDV4KPCFWNfaA1zxkB4uOb92/qVMpM7Iy3J7S3YY442Kr+W47lNQRRfhSmY5K2NYTAzWkucyz/1XJgqLerqi1oPySbM2jSsnVXWCiIqF6Eow7Ex1asjgJ0Ipeb2wHa2w4QsubwT2E7qrDuAQVnFNyhzqAG+W/Bmrr82LsWVPa/guvs9RUNlZKT+2zVvthkA9zlxQ+tGdu4HG5wexqdBy3BjQL5+htRvtpQmWiQxCUpRwWiV33pvg6JbZod/8OwYW/Ua60S5RXN9iV+tZPsa57zTTqmqFahgIVsZ76CYB++2CmgKJfiK+fIFts7XCXZdZS27gGzFRI1zceoqC5FBZgt7bk4piI1iIb+t/K25reGI37y1cazP9iaEcZyz43nNtsfLPQ1iD16ZfVbK6qUyOnWxrq0TzzaeSTocvZx7vWuVN4M/eRiSRHMrD1ffUX9CpyDvSJyhxSntYjwcFtQFjayWzTgVZRx8+Q0Mw1L55xE1Ysa65DKtGMdXAxoLqdzNPkyPZ8VMkjpSMayVmKJmfvgVTSj7O81PNJZe+iQZcEy81S6dpeM5pvXvMe4EvtB6zj+ROrMjyDJC3C1AfUQaxe0al6DbgAnr2hTyIkSgFwxjSC/QHeL577h952GPQZhVO6SFw6Zrkwh0Ytchy3Jm/4mYYB6UcLchW50e8a2FccioT6hW6xl+SkRSPZO6UTgARPedkWUnXehI5aA3k8oyyF52OULueNMWcY2mhgK6vbBXnZX3W
 2Xj+M+N6
 t7EtGmIj0abfCAW1lV/rwvgrMuzysoGfHHg/tKCUcIIRuqG65+JKsLdH0hma8AUabHozbS6i6yn0ZLSdJLw4a+77tpS6gMnmchUdGq5pEqIBf2emeAhe2VlUNSKTW50Rt4yjLOHl2/rWJP6eE37YbAxhHhaZDFEb+6vcVlSSiuqHk/v+RYl51n46HCIoFcf724qj5+wTHUkc96Ut2x+X0/KhJbeaZdMb9cH7vmjsgl6TG823+F5xLNYzJw2hGxqlZd1+IMXIcoS96DnC+cZQwSu4JGo/mHHTS6sj8GTKwiV91s6aIHSOw6S38AvLj/FukXuXVI8IbRMxI4a32JAYtx+8hJuTAkGTPlU8LSc7pd7GVLaIWYz3sb1EVeYhDoSQ1O05rrl8JyPNIJgw21asmRkqTDOHfTe3+522+Nve+EHEXODoD31cMLN40XpVnjE8179jlYWnz9eSqIxc20FIXcz/acjYHjclsG9JP8AQoQabHLK3hBjUJjtAgBEyN279GVJ+t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 15:52, Hugh Dickins wrote:
> 3.0 commit eb709b0d062e ("mm: batch activate_page() to reduce lock
> contention") brought in an ifdef CONFIG_SMP around activate batching:
> https://lore.kernel.org/linux-mm/20100805140755.501af8a7.akpm@linux-foundation.org/
> shows a sensitivity to bloat that day, not any incompatibility with UP.
> 
> No other batching here has a UP alternative, and it's a bit confusing:
> simplify mm/folio.c a little by removing it now.
> 
> Certainly we can reduce UP bloat (and/or 32-bit bloat) by, say, lowering
> FOLIO_BATCH_SIZE from 31: traditionally 16, 14, 15, then raised to 31 by
> 6.9 commit 9cecde80aae0 ("mm: increase folio batch size"); or by giving
> just the static per-cpu folio batches a type of their own with a smaller
> array size on UP (1? or a little batching worthwhile even on UP?). But
> not right now, it's orthogonal to this series.
> 
> And I suspect that the old ifdef led to lru_activate being placed last,
> whereas it's usually the second most popular fbatch: move it there, to
> match cpu_needs_drain() comment "Check these in order of likelihood that
> they're not zero".
> 

This fits the theme of removing CONFIG_SMP conditionals where they are not
really warranted and cause maintenance overhead.

Let's see if this actually creates real problems we have to worry about.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

