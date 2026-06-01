Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C398DCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E61E6B0395; Mon,  1 Jun 2026 08:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296766B0397; Mon,  1 Jun 2026 08:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186886B0398; Mon,  1 Jun 2026 08:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 035316B0395
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:51:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C5F349082A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:51:57 +0000 (UTC)
X-FDA: 84831331074.13.686B45B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 052801C0008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:51:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZh09f04;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780318316; a=rsa-sha256;
	cv=none;
	b=HQDNIxwOELL27EymxsEScDF7xb4JaSjC3L/u0m49j6/0zsQPFM6TK7w8PxqkZQpw+ojUzX
	b2Ax+KAd0ZLo2aUSrffuU9BFsLTr7LCIDu0uZiQt5NDdh58HELQLiCrKnzdofsF42W6xfO
	RMhRPRnnJKAS/w2HPvm4KaoiFaoRQb8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZh09f04;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780318316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UuLLpf/B0APZs2fKhiTHsDQcp/pWBrVBaeWcUNV7xw=;
	b=eVzny152Di+s38hh90PI1H5YSeDU2gTYF9bfDnNCuS/bmlGLeDgcQnngVivYt/LkUiJhjc
	XCJ1oLuqwoXOo6m7M3aYEVwQCcBtyo146ByQLY2M9MrM77Nl49bOW4eNyWeACNtuF+s4jm
	p8zvl49aB8yfCowez6n48lJQmmSllk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F67E440EA;
	Mon,  1 Jun 2026 12:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852061F00893;
	Mon,  1 Jun 2026 12:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780318315;
	bh=6UuLLpf/B0APZs2fKhiTHsDQcp/pWBrVBaeWcUNV7xw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HZh09f04h0YRCfV7g0NLIJL/AbOBwbVYneaEssCbldYO/BamUNdJP61zTm+S5IR0m
	 YHtWvwJRP2KYaahKT+GUKN1pvMUY4we9NTPAH4dvpM/Y1P0tfOehC7m9nWZgg74UJd
	 Cs5AJMCon4DJq+Du52T/SSpLHZ8e8V0becrh7YePQ0wreIB2XgxSF8EcKTaghX2Yz2
	 UesKnwV+2Osgq+r//WwhIQp0hLdR0uNQpduKy3lFPoUcHrl3SejbTEUF2xcOaf9UhE
	 PMMehAx0Dhh6FbNrs8PbWRyFe72UO++ZpeBV3wHvfDEh1RuLJ+jixz2XGhybVTONkk
	 ugPCZD1ujtMdQ==
Message-ID: <36487122-7cf6-477d-9ad8-8893c187f4fd@kernel.org>
Date: Mon, 1 Jun 2026 14:51:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: delete stale comment about cachelines
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>
References: <20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 052801C0008
X-Stat-Signature: duewqy6wgtwigk3bfzptu5xf7p8oofqk
X-HE-Tag: 1780318315-928415
X-HE-Meta: U2FsdGVkX1+cqgN4bz99ulT+9+k17M2O9IuF9pQjyTm57oHRsC7DLu1zsXbovd5tU9lLOaggI6EJnzcnwQSduXklyuh+EoBLns9+7TN6I0vLvzoS/j2yPVNaokgpSjqodkQxw9Ry71mW4Wf2NVOF3pdazbMvdEil7zxA1lh9Cc0FzfS/3e1VhjlYy2VeDsldHbCeT7VLUumvhGeyyLTIHywgQKzcH3WnNpt4CLAeD59+1tCYbrhqTVb24rlJqQCx0NCEui7LMBf9DCt4Gdd7xzJBrVOvoWlbehFV8wEze1rZLIiN/IfL2Ss2UIanTQ4NgvFSlPlX2pD73kzABjm/wQWDDq8UdTut+Zv7yRcAt+4HOj8GP33O8/Eqwa/ty7iyIDiLU8+QZzQZsktE/ptrtknbm54hh89pWQu7kOBOPv0X72sV3BUwWNnIf/sgFTpkW7XJ325N09JuGSnZmGdJdPBNuk5bJUn8NNforozA5KK8lP942BpkBueGLftSv93Gc25KKOm78vLV8g50YOvgWVeRzfOnR528gHO72OnCx7R6mArSHxNf3/wzE9P+JBzUHNu7YlBAB0TXG1H9YCMpX1Ydrvn1OKRzoiMLp79w2t9PyHfuhcC0Cbc+6T4HJrrCIO4D32WLv48g2nob7uM9SxXc/7W2VpAfu25e8lgRlO3RB9TgA5SmjlochFc42vmiHB6khCZtv30Wh8AR6o0BErl5zQYNcys2FPQtCP1je7+bAnNIQlcLZ9rYfHwLPkrZnzoWa1BA/l5CTNsybZBCMAqeDlKDvO08Pe8MwAgYb6XUqOgDmCE3MCDhYGkoiryDOWmY4z/IcuJCzYAuNuHxNUDkXI1IzHP7tJm9IdLqgnygFRLX5EIsqqLBezfRa7veHz6uLmF2kveeF6bRlZa0otoCUR5h9icXCK4z559kI/6VmKWWvNHwB0lB1+VcxUVDwAiP56MW11sT5j7gqGa
 B/lDMfbd
 EnL78UI98tYVkzHsb9RcSGPz5a2yuDNNJHMeId9kj7DtZ1TYFVBZdRdwV7UZGThik5R9donmmA0fUJXP3tQtTNBGiG/1Pz0I0sdrkvPJE/pWwfgHlFpp98nqxmE0YuZyu1qeJRkuyEpmdbE9WSRX7qj6kGeS7mWOiC2VWb46FaO2Ngo1tH0BC1IAwe4nfawpIiZti18UQvJUK1QDU8TseoSUxJf3hiHavhWLBEDK2kxb0frWkVSEepp3G+u0OyLg4sKM1mp1fyHfkDmGnK0Xbg6T4QI/yJrOjb1XU41Z/gvXX2cddp5kdW02q9g12OOwHZs3nEf/htOA3TX4RBiRIY4X43A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 13:40, Brendan Jackman wrote:
> These comments have been wrong since commit a211c6550efc ("mm:
> page_alloc: defrag_mode kswapd/kcompactd watermarks") added
> NR_FREE_PAGES_BLOCKS. Since nobody has complained about it in the last
> year, it seems unlikely these comments were particularly useful anyway,
> so delete them.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/mmzone.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 1331a7b93f33c..e308f5ac7950a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -214,7 +214,6 @@ enum numa_stat_item {
>  #endif
>  
>  enum zone_stat_item {
> -	/* First 128 byte cacheline (assuming 64 bit words) */
>  	NR_FREE_PAGES,
>  	NR_FREE_PAGES_BLOCKS,
>  	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
> @@ -225,7 +224,6 @@ enum zone_stat_item {
>  	NR_ZONE_UNEVICTABLE,
>  	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
>  	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
> -	/* Second 128 byte cacheline */
>  #if IS_ENABLED(CONFIG_ZSMALLOC)
>  	NR_ZSPAGES,		/* allocated in zsmalloc */
>  #endif
> 
> ---
> base-commit: 4aedd91eef75addec6eb2702aa0d94625d01458d
> change-id: 20260601-zone_stat_item-comment-45d660892420
> 
> Best regards,


