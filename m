Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C386DC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE7A6B008A; Thu, 10 Sep 2026 13:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5B46B008C; Thu, 10 Sep 2026 13:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4CD6B0092; Thu, 10 Sep 2026 13:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D1646B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:47:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83A7B405E6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:47:46 +0000 (UTC)
X-FDA: 85198585332.13.1BA30E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9BD2A0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:47:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEXSBzFv;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789062464;
	b=PCvRb60gNQwqUhBtymojIcFma397RVpAvbhhy/xw2ApIfyrFcSKqXKCfFrgR7Oz4WR8DRR
	i2JlJr20IY/xTuKHgJeHKhD3+rveXumtkRr34x0ZFd+vrqkYZKZtyUk2egYymTqG3J7nhh
	ZadBk6yWIv5wUT0Ffql63NR3q4rQNhM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEXSBzFv;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789062464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=in7k1OYAC8MHJg4Omam02/mpCXjCxzJpEJ4K4uJ89OY=;
	b=ZbwhoqsWxJ8RaO0OJ4B84epah1Rbbu8D2NFkbAzn4J8YmVpJqgjDLlCjwI2QvAfHEOOe0Y
	QkmTCAPGsTdye3SqJN4aadZubIG/KWMxIiyqvDyfcd7YQdIs+jCc7OARf1HJxtHE00zW4Y
	oqtmoRZqYHSk8qXWZMSnzWs94aV0cJo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02BD2437CD;
	Thu, 10 Sep 2026 17:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD851F000FF;
	Thu, 10 Sep 2026 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789062462;
	bh=in7k1OYAC8MHJg4Omam02/mpCXjCxzJpEJ4K4uJ89OY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EEXSBzFvb9AXYa4zzJ9u8Bb9P/Gx+B/avKkNnpNoykCP6vbPimhFD2yq+vEg9IqGt
	 SblENUgWMOPQsxFFBofncg0jAQRkvo9liGZkaiq+ZfNqq65pxuWhYSNz3S5DKLfDR/
	 jgeFvoIaxzWwbmaoDgIw1QNgBylGALEbnIaVPwCjVvYAdd4DFx6Y9ivaIFYWsfCinI
	 LS5rwoUHpfsHiBYVoqMsLHXw76YZqvoib2aufPPrOCvmlbaLsptyA2lHpXtGkXyU9I
	 QuNbsS28EUohqF12QONjryNVaA6gOn5B4lb5ywosKvBEPB0cLE31sjVeKMaf/ZExcO
	 ofWNqQ4LmU1TQ==
Message-ID: <76dc71e6-832d-4b73-a63a-fb8933a86a34@kernel.org>
Date: Thu, 10 Sep 2026 19:47:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/26] mm/fbatch: replace mlock_new_folio() by
 __folio_add_lru(,mlockit)
Content-Language: en-US
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
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <6757bf3c-599f-4ef4-85d3-d572e3bb59fe@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <6757bf3c-599f-4ef4-85d3-d572e3bb59fe@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B9BD2A0006
X-Stat-Signature: u857haqormjq681ymqzxcfafakg99cs3
X-Rspam-User: 
X-HE-Tag: 1789062464-677334
X-HE-Meta: U2FsdGVkX1/U8sudgk+rQ5ClMxhEC7lOGOVrOW/PZ5JiB4aae4KNSkdidm122Hu0dLIMnsSqj2FIHQsK0jsqp8UXKSccul3f8SuDd+L3OWpxDSV042ujq9DutYhDtSfsXYpKMY7tjpawjbHoLMeHCiQNuPqfdR6L1CBDFk2AZVz8CHkzuwL+IXdGtW3lNe9qL3So/YuyKGQLb47mcm++5VQn3uucVa5kw3dvGSklCT2b5OfelabkyIBc3lk5ZEjWQNVdiGT/yUNOqbXnSHlkAU60E3dJpEL2DlsmhY2bHYUEEvyQ3SsJgXFhbl3sICPP+nm/gInRw881i9FPMQoY+gZKC8fpv3gYbfk+4FyyRZOZYRx+uE21QveklQBfvFKnowC4MkOIyQbNLJSct4qZ8nbwRuyEXvPx+Py59y+5+mTcmU92tuP6Egs+JSlTFB+IZutCZKbsceCP8rPCNyCTDaZV1+UtTfgyOqqW4swf/pZmyBoeFDDzEpHJod6ZauYUaIaQPXqc6L0SIkXBFSYX/JLoDiIUO2uPEz9LNzikPs8ueWr3XpBObRZiZGVzpAkbZNbGxC0WDQ7b8JRWEWRT+IBXnHjxqYo84nOlO7C/PEWMR8vAARd8N7JUDRbvvTZCHuq+HnoT6AC2fIe1S+M0dgsU/m0GE0JgEUfyN9+3EGqAGbqUOhsaopIVuJWqtWBQMpQsDKvDGmzlpTAQ2F/femD9zyIYu/zeXkku5i7gLnvL3cH3S7HQj7lNrHk3/j+0QKwAdxJRak8pskruudUVBcPvSZ+qlGelEI9upWPPMQAybhEXa+OWjxapHJ9dALpEDDbf/pPU1W+E75k6UU6+1+JVhRlL0PXRdt8Si9lAcQvTP36Kj6MVSBNuKxLwHRs20JxFV9GvHKds5u5Qn4FqNg2RTXkKO/5qaArlbriLrMIsKgh4W2LO8KYBlPblWjUY1XEQDbPV92c3xnfn4vf
 KM08vFZ0
 5hAPnS4eGNF3XLBKky3eiBN6cJd+Ofyk5dCUdUM+ibI1IAVBR51NobUt83pUybrkVQksOcL/5jT6rSORfjL4xD04LHZ9DB3PG/wXQdKTxQDNlluMYkt9aNn1YQEEOD2kefX6dSlJmMYXXT9InwyNOuXDGHM1DplUxO1ZEP9sLaTDPvawGRnZEBI0aTto+mkqflp7tDDnrV6mLA+GXALEOKusHOLWTu366QFPtOd0KLUQP7CEIpujn9SBXa4qw5PoSdmakVrBpwsgkQ5gRsVbzI3yOTc9xrSvn4NX7cnYHP5B48vg3TLB/ti7NGilgo5FvmJCwB0etlggn0oG8w8YBHGcdPjRmsXenBSCtYyMMbRPtTRsorb/3/6N8VSZ+8joFp3S14H+0ZEYXJE5MJ/RqBLZj82pmyICshGAW62xdfzPgLEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:57, Hugh Dickins wrote:
> Replace mlock_new_folio(), working on mm/mlock.c's mlock_fbatch, by
> __folio_add_lru(,mlockit), working on mm/folio.c's lru_add fbatch:
> folio moved to lruvec by lru_add(), with its mlocking incidental.
> 
> Remove old comment about not needing smp_mb__after_atomic() from
> lru_add(): but that is a detail which will need to be reconsidered.
> 
> Initialize mlock_count earlier, when adding to fbatch rather than when
> adding to lruvec. mlock_count count in 2s, with the low bit set to
> distinguish it from lru.prev. This helps when an mlocked folio is put
> back early by compaction, but will enable further optimization next.
> 
> Change mlock_count from unsigned int to long: long to match pointer
> without endian concerns, signed for better treatment of those rare
> cases when final munlocks precede their still batched mlocks.
> 
> This is an intermediate, poorly tested review stage: mlock_new_folio()
> code removed from mm/mlock.c, remaining code there updated to respect
> the new mlock_count accounting, but not considered beyond that.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


