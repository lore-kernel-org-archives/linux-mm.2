Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBCE3C61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53146B009B; Tue, 25 Aug 2026 06:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03DA6B00B1; Tue, 25 Aug 2026 06:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940FF6B00B2; Tue, 25 Aug 2026 06:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 725F56B009B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:16:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81EACA0378
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:16:03 +0000 (UTC)
X-FDA: 85139386206.16.1411DC2
Received: from mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	by imf25.hostedemail.com (Postfix) with ESMTP id 66014A0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:16:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYWCFU5K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787652961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9YDHoAdAY+cpJ0EdZT98qo2UhuZGqE/VwJsjL/TUAA=;
	b=1Q/q9/kvzlEfeVbRVuG26U5AZdsFdFtfBWwNK+SGg6sbKiz+BCY4mJZpUr2d3v5Fa1XeQv
	1B7AvmHLZVum++ASTGV0drxLPrx9LXp1azZ1+U3OSDXFiDPlkbXWvl/1OdgLPLOKSTAUsH
	7DUaj8VZ+GjXz+M3z8U1AjTECVLnotE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYWCFU5K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787652961;
	b=qyiKORLVEXHmNUzbdgrgfOK2pmDaw2ng1+7Pjp9/G78gTGfnNp3k+ROkXmYcxlgp2XlmjJ
	haC82d+Gn0G3vYvMZvVDtZpCJ9YczT/oBbvm/pqOX6/ifhYlyO5hPMxyszjODEp1MqN8OG
	trm5wY2JLEqCnqOso/YRtHj/uBbNxeU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Tdr/HmJfTxf5L8Y+jdMDmcvzH+SrmMF/W8kD6dxUlKI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787652960; v=1; x=1788257760;
 b=jYWCFU5KB164URbFDLQBKWigik7j/EdHh6nSnoXU+YhtoV0cVkpA7qd9Ndd+ZnEv7ArAsllV
 MT/uc6e5Q731d4QzoWn0hpRYV2q2u+6wEsFJ6Oh19lQ4wDNSgaWGlgQt6zpwUeedyIADPZw3dp+
 fC3NLl/FoTdQorSjnvp5AY0s=
X-Envelope-To: linux-mm@kvack.org
Received: from [100.82.85.74] (101.71.133.200)
	by smtp.migadu.com with ESMTPS id bcd67e8add5ab7a7;
	Tue, 25 Aug 2026 10:15:50 +0000
X-Mizu-Trace-ID: bcd67e8add5ab7a7
X-Migadu-Flow: FLOW_OUT
Message-ID: <4de2eb8f-5b26-48e3-a331-f2014a922788@linux.dev>
Date: Tue, 25 Aug 2026 18:15:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-4-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 66014A0004
X-Stat-Signature: o5ifr98q8xknmch3ndt31h7co1fwe68a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787652961-188789
X-HE-Meta: U2FsdGVkX1+oBqG93slDu6MU2SaEzxZ1N7A4HMrYwPZE5a8L9OX8w3GKDA3B6gLZNWv8POVVttirCwsHkLLDtSU463BNu0SjXkHKWfKOvOnpdyk7+kuzzo5Tc38MKBbemRI6Lz5x+P1ZOs1zzfHWOZks0tfaG5ksVP0S8zUq9D6i3alS5rLoQd1ILiLbF3O80uDgkNqpgBBK926iUwlEWk7516Bxxo7TfIFWkFykZNHvq5JkIZczq3sy46gAsp1kveyTrQz4jyhLNtWRFk9SnEWFc0ZxM9vnuVsA+2GcnTQBJ/0VdDn+LbnQuLjaByj5Edt10Uvii4G4LlmwiQGQd215satf3Wdht5aMOsstiCBXc6PvpJLCI6yvq1RT1fD97ECs70HS+qJjI0wMGqW3ZgnbOMQDZJx5+V3zPmrBzW0Q3GwSlfgipywekZMHL2LPcR2RkF8Jw3cgUE7RxybZxXMhCiBfsY6r5+p1sCJcUz4OI4Tcx91XaPyfWBPg8rOw80QRjqwNeabyc4Ip2dQCVo00qCLosGRZugInRX7REYsrMwgrbqnlYM8qEVuYS/DUG+UhIy/hM9LoOiYFZZ85xLwZHR8p7P+0CdvUfSGuV6qDWHF6eYo8fzDrs5lR4kq/X0U0gTq5m9zeylh9dgTDfgLzwPtnlk1HorC5zrE5GjqER5qYD4sjpapwEZlMp0d6DRkbFx5dsTcjj+wHdqEIc4EMJRgaK3MeaHxqcpNVmtCSYAJ8xfquQyoUMrGqTlaCmAUMoDCQw5oNR7bIYUjzhfanOuDLvt0HJJudnYrhaYiq/67cvQxgt7XpAZgzum/tMMF90kOWCjS8JVE2erxkM0BzU2SIg/o4Rxn9gzakR2Z8ui3ViJO5XSRvaqgwL76lHb2CeP43hRyjYHdsmA2dn35NDPb4jRl+Tjl7uZ27mWdCTCM0mwr8XArBMwxJSPTn+Hi1RL3m2TR7KJebNGY
 EufH11yb
 C1oqPFceazKmU1ZN/MkyhBAwEqUZ3dah0yBq11gPtfhg8Qyn6AepQRfIxJPCeRlnspPp9A1FULVorRFaI+Xte16k17i5a9TmQMbKa4JtSlOWt1+RLa/bkXU9fo7VJ3HAK+e90QIpf1alcB7wu3T+LHKe1LY+OdKztowexd0sEdlfRb9IP0iTUkC0T/xbuoeO/N75YD/D4/1Ws6oP/wGWs7f1FjVjdArh3dNpPDm+UWha1ixJuZaExWB2eq6pbYJorq3S2MzJT/ss6JfROg4ZB3ydWlkhz8TZWNSWUtDGagcjlD6+EuVL6pUOo0bkvPpnjbvNWUiG4kKEgYGila+6pHvFXo6ggxmQ306dTbl532qC3Sjz+1wNOsThGicaXagz4vgWwMjba+6C/oC1exikIAqav/xZvOKZRqjx5b1G1MliltDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:45 PM, Muchun Song wrote:
> memmap_init_range() initializes every struct page in the target range.
> For compound pages with vmemmap optimization, the tail struct pages are
> backed by a shared vmemmap page.
> 
> Initializing those tail struct pages would overwrite the shared
> vmemmap page contents, requiring users such as HugeTLB to restore the
> metadata afterwards.
> 
> Track the compound order for HVO-backed sections and use that metadata
> to detect struct pages that fall into the shared tail vmemmap range.
> Skip those shared tail pages in memmap_init_range(), then initialize
> pageblock migratetypes for the processed range with a helper after the
> per-page initialization loop.
> 
> Keep direct mem_section access inside sparse helpers by exposing
> pfn_to_section_order() to users that only need the order associated with
> a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
> without exposing __pfn_to_section() to !SPARSEMEM builds.
> 
> This is a preparatory change for consolidating handling across users of
> vmemmap optimization, and it also avoids redundant initialization of
> shared tail vmemmap pages during early boot. That early-boot benefit
> appears only once HugeTLB is switched to this common handling, since
> HugeTLB is the early-boot user that creates those shared tail vmemmap
> pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


