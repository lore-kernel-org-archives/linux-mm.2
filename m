Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A76FCD98D2
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 03:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D75E6B0005; Fri, 12 Jun 2026 23:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887CB6B008A; Fri, 12 Jun 2026 23:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F096B008C; Fri, 12 Jun 2026 23:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 692A76B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 23:02:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04A01C176A
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 03:02:20 +0000 (UTC)
X-FDA: 84873390882.16.93AB7C5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id AAA8C40007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 03:02:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xbwJYM1o;
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781319739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVF7Nd9sgnw6E/OlYL+ByO7ePMRW+XqPGuLnJaLouec=;
	b=gcKiNEai9tUFngxVj5bBvds+Q2EuTr63HD/0Z/5q3EVwnEZSxPH/eynK5gx2tDvr2JfDKN
	4t4T27Gperje8FNo8t+Ri28gTymAtLFZQm5B8OFbje1XctlaYq/QSMNt7GYsld6mkL1Ko5
	on88HPADA9ecIxsHT3tb1Kq2VGxTTD8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xbwJYM1o;
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781319739;
	b=7Q6UpsQ32r1hf4Nl5w6xwGs4+0/q56vnFLvzYSaBpxr5BNKaG+QEib/JG/a5Eb3Xy5fWS8
	AGinCmnTgBZofEJUTN7xMh9suZGf8xgaMCT/0CCzaCRuAYX0RvsvYM2vlW/LHM3l11WShk
	FsQdUNRWBuz4ZSn3iaPIviSb54IzD6w=
Message-ID: <11cc4dca-7841-4897-8665-e27d7555f246@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781319732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jVF7Nd9sgnw6E/OlYL+ByO7ePMRW+XqPGuLnJaLouec=;
	b=xbwJYM1omO378wP9o0JnW/erUDrv/d8m/bFHUTCTOwwN0krhSGZDZl29z1bPEscLuryVsI
	8LnWDI9J/kyRYVDz7dAczCccGUeUVJ5tM6fK9NFiJOoLweW5hkSSY21iyjLl2niMdmk5OR
	N0s3aXDAMGn9kypBurlbT8CInmZvXEA=
Date: Sat, 13 Jun 2026 11:02:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
 <20a5a752-3ed6-4fde-96c9-e8369b15524c@linux.dev>
 <ainCu2HZTTdP4skd@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <ainCu2HZTTdP4skd@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAA8C40007
X-Stat-Signature: 9crjg58nwhb8575xxikw79kaih1eqpzi
X-Rspam-User: 
X-HE-Tag: 1781319737-674763
X-HE-Meta: U2FsdGVkX1+ky3JFlNcJABB2CM2pVdIVaQwGgxXsvAHq+qu0wwpiYsovh6tK/7nZp5Ua2v8wXJ7N9romIT7MwC9wIPMv4bl0yoNT+1nG0ZVl+CRunGhZM0n3+cKMtKKD5t0VUuoyYIgbGvzRdTavUsAX38Y4WBlggAoQSC7GaR0ZuiVbvTK5pH7++PTYsXWM7SFL29sC2vJggVFfn1ml/7bV1QLHkUvS39KPXLkXkbUVaGoeuIps+ZMlxGoQDoJWJ4yqV/T4WHvrChkYEAwGS+6N9V+30FcIpXWVVN7lGp+zbvnBnedxE8MCWWqG9H0n/bOZ/Ii3LTPJi2f4DWMCKFC50c9uMEy9C5XzGq7quWyd7zAVqBKmDDp9cHdeAr6iVsAU4NLVTUVtLFC9EbMrs9zjGIp90LYAjswzxlNOtAe/guLFnFGrUfc/k83DrWKMbBnZdQ4btc+4nKrUSdly6KYcn1zHvy5kpNB2BzsDOLNz+C9evg4bP2tY+Bt02IXTDDQsfaWfRh8aRPVA4ZgN3W6qlwikP/gzB1nJhIvXZ9gq20EqzSfMB0Pk0Lp9ao0RYDUvatIOba5izek3SgJTl7kNC/bDa+FNz3/q+eJl6kMX/dz4owyK6mlSZA/3DRGZkhBGvRYl3IEaoQh9HarsX04uPkK6nNTSB6KnCVWnNZ+Syxx1Q2hmdFeNukFDeV8bmP9oKmc70iZG6piRg5AXGyo8nOI65+GQ8Mu6Ga0sXFhSauundoDzZ9PnagZ6HNca3gq1JQNdHZ3xPoKJ8g88xFRVC1CXZGD8mN14XFRyMDZb2K6KeZsviyhvLC0hUN//pb+u21jRlTNra0K2LdpciTug6svNfKhj9IFs8FdCl3E8ltOXPwKcHE4i+6KvzTNSlZdfpK3zLvYt5XLAp81H5hSLPrDKeBl4EfnvRlQYKZV54M2C78xnSIUNp7Si8tJA4GS0KSs7alsMt9O3LZd
 Ft7VknRt
 VnDnd6i1lJhOlRnjGAikGRxKeYRWt0bV8euo7ux0q1vK+4QknQ72DA7pkV4sBZ8psdIroh5yGKAIhc0PKcjTrbwDfUQAOo1F1FxIUyeh2q5XxFgPm7p9x4Ut8IqhTWAFGAbAB+rvmac9ECkPp2FSPRIrC+PBIh9n9rrHpoA66qANrphCegtmWCB7qJwxSAgl3Jjw0ZjWeCq3D9gkCY20ozkjsxnfClHhxiZQJAmIIg/WGXW6BYsQ532gkJL9HJ5k+25f+VuuLoOL5FFjs1xAidzzVOlaMcXQWsgKEZnCWRzUQ4g6KJIbqumyuf6QMcDkOSUEA0cd3hJwj6eZqGeM8uAqb5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/11 04:02, Matthew Wilcox 写道:
> On Tue, Jun 09, 2026 at 07:59:28PM +0800, Ye Liu wrote:
>>
>> 在 2026/6/9 05:06, Matthew Wilcox (Oracle) 写道:
>>> Pages don't have indexes, folios have indexes.  Just delete it.  This
>>> script is going to become increasingly barren unless somebody steps up
>>> to maintain it.
>>>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> Cc: Ye Liu <liuye@kylinos.cn>
>>> ---
>>>  tools/mm/show_page_info.py | 1 -
>>>  1 file changed, 1 deletion(-)
>> LGTM, thanks for cleaning this up.
> 
> Thanks, but could you explain why you don't just call dump_page()?
> It's more comprehensive and will continue to be maintained.

This script is based on the drgn tool, but the drgn tool does not
have a dump_page helper. What kind of method do you mean by      
directly calling it?                                             

-- 
Thanks,
Ye Liu


