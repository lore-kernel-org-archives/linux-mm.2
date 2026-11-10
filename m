Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5590860A2609
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dvLlwk6S
Received: by kanga.kvack.org (Postfix)
	id 747846B05B6; Tue, 10 Nov 2026 03:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7426B05BA; Tue, 10 Nov 2026 03:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DE06B05BC; Tue, 10 Nov 2026 03:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5746B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:10:10 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C812916089D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:10:09 +0000 (UTC)
X-FDA: 85418486538.05.E8A1A4C
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id C253140008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:10:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dvLlwk6S;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794298208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/OJddKysfTCMoM1JumLxNU2s3B4sz13xeOizo47/Ze0=;
	b=T99dPyb24qgf4siznfWR5qSNnhmzroUVZxc/LzUwjXhxtaVaWq9XorKqpwUlqgPnKpKZZp
	lsAnNUgB/5or0Obo3eFgBTtMQS97q6tTLptTh9v+BC20ZJXAZJpxhjyZXxE+ILq6dRnyXs
	5Xw61IUBGa89pXC2SchEW6UPxCkEZ2E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dvLlwk6S;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794298208;
	b=aiFlmR5oLEOk3fdgtFE/mPowlRbJW9OSpCFyQhxInnxtxNlgfHS0GymDxVV6HjcfH+JAzD
	jW06iq9ciT0uhQfgIU+zGDOz6UhMKIqLrql7cBfrqUxLDlAhPuCKOHFKm8Cs1mOWfoJSiJ
	vHVlu4pOnnZGJ5ooA4Dz8dnp9l8Qg6k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794298204; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/OJddKysfTCMoM1JumLxNU2s3B4sz13xeOizo47/Ze0=;
	b=dvLlwk6SNiAg97265CrLKooKjy9AO6o/1kBi6OM0DCb+OqPcHOHI1Nt9IjBCNCMPEFk82BctLJy7EjjAcFea2i+OrwLjhYI2OkqFroiryR1uN+xMsn/eqfxF5PejjxagUoAuHGbMEsD188Rg+jHHqtyONIX/L6RaNkAHgtd3FO8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XEUXxmG_1794298201;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEUXxmG_1794298201 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 16:10:02 +0800
Message-ID: <e154e1b6-fe5e-4945-ba6d-34ea5b2e5946@linux.alibaba.com>
Date: Tue, 10 Nov 2026 16:10:00 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm/huge_memory: add a per-order counter for
 underused splits
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org,
 kas@kernel.org, alex@ghiti.fr, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-4-joannelkoong@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261103212004.1356327-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5yyo9jw4hkyakdspk9go9rd91axjz6g6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C253140008
X-HE-Tag: 1794298206-700366
X-HE-Meta: U2FsdGVkX1/r+RocKdc5fgC0IHwJTR5BD7xlKnTFVsnBuM0h2oNFIZ6RN/NR7YmYfsU0fWIHCq9nqQHhfirVcrto0uSCOy8CKuZ8EXwZp6mq/B9JgzbcAkYJpFMRH8+FzhB1AshjMPe/2pZAgvOFCii0qOEb1DhmAMcmauxcaJKLh9CrlCQgAowy3BhQdb2nZHJB3z9ADe/4e8C/9sh2Bo5WBk/Pyr9HwhmyFPvFYAafrIthlS9whHr5NqxWDAydHJIXAd+G5bZCVA8zjTqIO4FDZV3w/xtnQJoRmJY8wS9/ZGWgBP5UpSBxx/asoqxX6YwGOlOGa1euJTFnZZlRpRWsZRdO5zCtlc3X1e+GXOpJWyOAQyQ4A7LMcQENQmFeRcmFPGYirGFqypTXHVypHVy+zGiFh6maJyZUyjxlZ9mvos0O4dFkZFTNswCzRO6auW8jHvuUC5jO6sDABMKUvFtLjcK3w1oAHJcS4yx5JQwQx+4oFPywH3Vq/d2najwTv7NBjHxeT8bGNS8XdUBOape2YuyGr8M260EDnUN2VsmqFF+bAYomC533agDwdNVleKUwa+yVzenp2AzELeLMtDSMwuDkAzcV3HWhgRloEQRtuuG6jsRe5UEDrAZGvoQZkJy0qltZ5HQzagNgsR3+xI9FewJZum3/cfib6H3aN8X9fdTjFqyiTmKouPaFmHDdxDCmSz3xP+JcO5plbWrSlPcY4L+FsZeM7fJZHb/5jTP1Xbu35HJjajbCxKBLMfU+sQNvMadVsAupNpQyTdRYPQpi13F2VpT9GnkZKO3h3Cb6pR609eBWPE2mh1titaYrrJfIUD4cQEm4NS1z5/bDgA1DhZbtS4htLPsLeYEZeu7KfKqGtPfzqoapCqTgqdpwU7VMtKd02aSmHH2OByOMAC3sn9qHl/tLYJfKxGfIfVqJ0Nfy4YyaFFzOaJKS/OOV0xEuSht+OfVt06jj9xX
 L0vhu5uq
 WIes+QpxAYw5bFSwnt8At0jth7+x79NCwjpZQsyaoRhdNatWQMNxaXlz1yn6wKNQk8i8NpyCvJxD/zn0eYdnbnuoyGBZrmW3bBYKNESUz9w0E+9PNqa+9txKOahVzY2JBPvpLjkxhNHWeEtWgB4syXxAecHbh6BiYoIUuGrESVLU9t1red2gjaTMI1u8s6uOQpDk2IUynJJR+cN8+sNZwGoIw/v/KRE8sYyh87nZck2loOsgLFRRY5BtLs/4SiLGKhne5xLdKNGqH5j3XCvNGFAoc3onA/GVa+/9Kp/y3Y92WyKpaKdVKuf7NG16JjYdqFDKpeGZAXEUrsoQeaD97LPvfFwvzPPmvdgEes9dlNv13pG2/Ibrg9JjZ2fTckrlwssz86X/NPgOYuuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/4/26 5:20 AM, Joanne Koong wrote:
> thp_underused_split_page counts every folio that the deferred split
> shrinker splits for being underused. Today that is only ever a
> PMD-sized folio, but a later patch queues anonymous mTHP folios for
> underused splitting too, at which point this counter would start
> counting mTHP splits as well.
> 
> thp_underused_split_page could then end up larger than thp_split_page,
> and there would be no per-order count of underused splits. That doesn't
> match how the other THP split stats work. In /proc/vmstat,
> thp_split_page and thp_deferred_split_page only count PMD-sized folios.
> Splits of every size, PMD included, are counted per order in the split
> and split_deferred stats under hugepages-<size>/stats/.
> 
> Do the same for underused splits. Only count PMD-sized folios in
> thp_underused_split_page, and add a per-order split_underused stat that
> counts underused splits of every size. The folio's order has to be read
> before splitting it, since the folio is no longer large once the split
> succeeds.
> 
> There is no functional change to thp_underused_split_page yet, as only
> PMD-sized folios are split for being underused today.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

