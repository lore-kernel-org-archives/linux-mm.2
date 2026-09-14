Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1531BC88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9276B0088; Sun, 13 Sep 2026 23:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69C66B0092; Sun, 13 Sep 2026 23:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80516B0093; Sun, 13 Sep 2026 23:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A41116B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:14:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D4EC120EAD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:14:47 +0000 (UTC)
X-FDA: 85210900614.29.B2345B5
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf26.hostedemail.com (Postfix) with ESMTP id D33B3140007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:14:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bWC7ZaYm;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789355685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVhxsMXkoOh4go6lqUh1XBFzQPqM1DF7VxUa3Bcntmw=;
	b=0rM0ZFsS2CnoW5THXyZ1HFRQ5jvedoYVoYtBErrvSKxprcq3fRI/+qdOB0khASw17Y6y1O
	qFL1tNyndWW1PQ6uvfvrBYxClUJ1gCaMKnLFbOLJltwC1F3ikVxMhtSKoM5S3fPN4s06M/
	1lYQexz+QO2uhsLYxNn/08JulEeebvM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bWC7ZaYm;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789355685;
	b=HoQo7nkpVevzwRvlaTsC22xPcrBZJhPJgITgMxKsazgL57xd9ut/mmwupx6l6A4oNDeAAh
	7rf698TsrbaVG8LA15j4GU0AB20aYS2cptkeSCMnLcjVKSfNgP/AHDgSwPgWY+PUy9IKe1
	6NLvp/i6fXtrZ3gCytEH25t1OfW+5z8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789355680; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aVhxsMXkoOh4go6lqUh1XBFzQPqM1DF7VxUa3Bcntmw=;
	b=bWC7ZaYmPOJANY0Fgdw3I+jgafyBJzAMm55SeaxcFpOShYihKnAYjRNyhRvg0mnLXmCgp5cJNQC38byA0zig+FtRjG4Q0NFUxWxSjx9D9dHfmWaz7lKuuQ3s+wy2QbBXmJ1rxBMlyHJph2upXmzNNEZwNeJ6nEG4PcPR74fjeec=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XAqABCh_1789355678;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAqABCh_1789355678 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 11:14:39 +0800
Message-ID: <8fbfb29d-ecbb-4561-990d-4e1a1b677d75@linux.alibaba.com>
Date: Mon, 14 Sep 2026 11:14:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
To: Matthew Wilcox <willy@infradead.org>,
 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
 <aqck8rfGByZhdtqT@casper.infradead.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aqck8rfGByZhdtqT@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D33B3140007
X-Stat-Signature: dt35qjjarqtb79mepgq1xohzptwaessq
X-Rspam-User: 
X-HE-Tag: 1789355683-682239
X-HE-Meta: U2FsdGVkX1/p70syARtRTrr8lw6j7SeH8tlNRCltxvqRIe+Tq1RU7CkRBBNNmxcVFi5RwsELJldBGM99y6HQeM/S7QZ6od/pPeWL+lTpFg9R6pDKRXPILHAAyeBzdx8ZcT8cB1/VieTqtLjIC+ZzzbCJy0j28ofseRZw00y1eJBv5PDlhCIzC2e37I2X9Jdr/TvmiO3uMXAVV02fl5ZLEbon78hfvrr6abQcGUTrcNR9+lUl98BNiQ+7EszxD0RXjjqIGSwnHSxfc97JYh8fOOD6mDZYBUGkzQm3/pLJiPCKZOYYnyMIDUg/qz4aTJqhY6BIQTPkpSsratdSb11YLe1cg2enWzp/lXNKoSsVzBOE6DPFeNzWuglW9wBtBYj2G6FDhHf8s7UrIcCYRPCjZe9Aft7bcof+UopzQFZVtjcA0rzfMK7W+Jwe84+Re/4DajUQlS2h6jo2zturPubOPLNmjl5C6+lr3Fzk/lXE6PONl79uDRggtn3/iuevd6CZNcF0xnFGk0m5p1PMNruZw8u4AY1rQkGdtQywRA+ebwH7npFe0eYBrDz/knBGK172nWhhylhPieVWBzoTfuVPXCebN6Q2vmBl4gejtiTUjZ7C65/HE2COTe8n+loOjFo6yZEIfYzJ3BdLR1TtNuzpauiSyUkGL/MAXkoXGgd5SJL3pTLIpiwJyCiStnDfZWKmmxim1wO593m0GlI29AlKzKEX5laSv0zdaZkGxiwjy/zBMyiyROJH/fs8XGG7dDsMzKUcnKhbb/GXIVvGu83TJ0ZzsCZVQZiHyJ5FaYHEDNEhZYHyKEncTbBbpzKbd/fQtzxHO3/I39JhxjLlF8XMU3g/CKgjqmLstKlORVdF9wI/DiBGygfAXEFVL1gK3sD5+5LkW3mViP767VSOp3XCxzSmNwV88nGK/eMZMD0KCOh66V612MSSYFILHPl6+RKSn+ZFy13uhSbL1Lt1aUX
 btOtz2fy
 /kpjzqh2UOA42gknD+u4O3H89gc2L2+M1etgQ9u8OxWPyygPISDUBYdse3maJFqKdNP9re2fDiNrnW5/hvRV9BievrH649ywDxK1m4hdbtOKikufkHNhs/GHPi/wycfC9JpfSuSc3dQ29paL5TJ07H2pxiwoMT71gKTnQitMuWzNPmiLd/BZUzmx5TzWCZZIXq2ORCGlJFDiR9XvayRWsO1bs4QjSegGnDmGY92yFkABc+8qHJtMCXr1Js8TcWmH7LokhwMs89xrwG5M4v+fvekJ+kuO9C7m51UyW/b2r4c8WDYab5ULAH97DN1CI8hDjaJjP9UOyWAfa6cJqdwx4RFSW9/K63TBoAL6pHpv6PFWvadLFABr6Fx36BCmrsgul9w1R3iV/ObXpDxrFQXDOtIGfclFT9f/UqPf0TVOaKDvCB1PWiFsLV0iZhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/14/26 6:34 AM, Matthew Wilcox wrote:
> On Sun, Sep 13, 2026 at 11:36:44PM +0700, Nguyen Ngoc Thang wrote:
>> @@ -2271,6 +2272,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	if (result != SCAN_SUCCEED)
>>   		goto out;
>>   
>> +	/*
>> +	 * Take invalidate_lock before any folio lock: the readahead below
>> +	 * needs it, and truncate holds it while waiting on folio locks.
>> +	 */
>> +	if (!is_shmem) {
>> +		filemap_invalidate_lock_shared(mapping);
>> +		need_unlock = true;
>> +	}
> 
> I'm not a fan of all this surplus commentary.  And what happens if e
> simultaeneously truncate a shmem file and collapse it at the same time?
> I know it doesn't use the invalidate lock, but does it go wrong in some
> other way?

IIUC, shmem uses the folio lock to synchronize truncate and collapse. It 
will check whether truncation has occurred after taking the folio lock 
in shmem_get_folio_gfp():
	
	folio_lock(folio);

	/* Has the folio been truncated or swapped out? */
	if (unlikely(folio->mapping != inode->i_mapping)) {
		folio_unlock(folio);
		folio_put(folio);
		goto repeat;
	}

So shmem looks safe here, unless I'm missing something.

