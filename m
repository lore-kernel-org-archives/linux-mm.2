Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B1FC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2169D6B00AF; Tue, 14 Jul 2026 23:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8B06B00B1; Tue, 14 Jul 2026 23:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8D86B00B2; Tue, 14 Jul 2026 23:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAA266B00AF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:20:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38AF31205AB
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:20:08 +0000 (UTC)
X-FDA: 84989557296.16.B05119F
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf25.hostedemail.com (Postfix) with ESMTP id D840DA0007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:20:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pq4BINNf;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffXR8uJnFgBdEDOKpZDYO/HUDWw+NBq09FrCbR+s9mI=;
	b=C/iGZJ1dnWd0fUk/R0uypBgMKYiTLBLUyqAkggaWnexv+lcbqLhgGChK/7NxSL0keh3+la
	LF+GmeMQRMjuL4xPfgwixMLQg78gEzfpNumMdp727DDfHA4QxTfHKyRcnQt/6nlj+YedO1
	9N1aBqw0Zn33EVyT+quFTaVGanNwRwA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085606;
	b=MPwxHkfmtSLr3WtoRDBMHKZAMhofXlrBiiE2mPteuTx1ngTAjJIlbK6vIURQtSdU/+2hQd
	gW5Zo23i/FRtOTBwCTJ9UUZu2rjLVUdI6q3efA2KZHUNXWIJ7taww2a0AtLTDuONBwFd82
	705X7sR2WPwC4PGhiI4yc9eqz5E346I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pq4BINNf;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ffXR8uJnFgBdEDOKpZDYO/HUDWw+NBq09FrCbR+s9mI=;
	b=pq4BINNf4lRsBSwRr9pg5n2KLCksDva0NvjjvVoh0EKEX0dCYt0Arq0KXtQ/1I66+CbXkV4vj
	E8lil+L20C3eDlpCIW+EflFfwqmHV5U4iEBhyWdLYi6VbGu/3cC6UwQ0goCyfoSv2GWaICT3SHs
	47uvXrrSq9oUpqdfcqLG4M0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h0Llk4FJHzmVX8;
	Wed, 15 Jul 2026 11:10:42 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0283D40586;
	Wed, 15 Jul 2026 11:20:01 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Jul 2026 11:20:00 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Jul 2026 11:19:59 +0800
Subject: Re: [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
To: Matthew Wilcox <willy@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Usama Arif <usama.arif@linux.dev>
References: <20260709184740.1286561-7-willy@infradead.org>
 <20260710150204.1887475-1-usama.arif@linux.dev>
 <alEpBqExnyvBnnxi@casper.infradead.org>
 <alZw5EdYVYCRNyj4@casper.infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <3251bb16-be46-f752-a6ff-a6c3181f49b2@huawei.com>
Date: Wed, 15 Jul 2026 11:19:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <alZw5EdYVYCRNyj4@casper.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D840DA0007
X-Stat-Signature: ho837abuiqziiyihec9uzdf46chj4zat
X-HE-Tag: 1784085604-434789
X-HE-Meta: U2FsdGVkX19HDyua1dOMb7+7ospdy3/TxBp8VNvSsDbMYlx2Dx52bkakNY986dSOj9Mj7FWDok9UZvB3wg1HAqWKtN9uDH7bnGhvGkyeyVpSMgWyXkrD6Wt4p0/JCKtVFMf6Xr1ncIa1atbKUoF+pz2GX2Kzw2jl5qgEVyB6mcMNhfvXdnkcr+r3pN3zcO2bd8T0C5E0HtRJlgTRxrQWL7ecN4nI0b/7N1aYQJ3HFQgxHmyMgLsy1PYan0cZXONxpe1LvDN9fz/z4TEAt8WNHtCWokl3rqx+FndYxF4Y1xAiNpNRzbfN+W7huLsMwG3YDjcdZuhoAh2lSs7FsbexbgxgHcYoUzLdFRThZudRGax+inxoobKC1RyRBll26KW7ao23dABvEJMgQTOjoepduFs8k0qkKTzQ5ZTQKfmUeDKBPqBUbmu9ZnP2x3oRjLYhjravqL8UUHtN8HJOhNeP6tGvU+IKBYXlpvTxJL8jJbPNGCK/ICnrzqlEsCX3+zHkRjLKqjwwWuLCKSBe3Mf5YhA8tBRQy2DJkAQWb9iljy16EZzia6e2bhCEbsxJS9d8hveDYwL1hZ7QsYd09+XmtXKEoDl1LYwi+qdhLnwYQdCptPkN/Nx5BfKg2W6YJBRdFU8eGX/d59DyRo8ttt/LPMpYDx82k/E5yPHg2lwEJd8YF8ZRcb9IexAfFPKPLdNxPzmfhsOpJPlUIYfnlolomTcpSenl48zvVzDDEJaLSzyPxMAXLvdHbS2Ew6EFnjc7Ehs/Qd8ui/eEFFPUDTZKakbBqRpxhLmi6OES/B2QR4Oc8RylXL5Hsosnk5VmTIlTaC52XNp3/jRK2vzdm9MzaCnI/61nVqXlg9YAcnzQIWl7CSUcbLqwRAkz8hIzgtGgfeDPrhRQqJmUg0CceDphAV0vf8unarpHERa6D19ADPSaipCT7gAigPx+PbI+ebgfGPv1GjX71eZFoX62oOV
 C8Du2d3p
 1Fo6JDZAAngKRiPg1Lpkk48aSbt33YdPwPP++gkq6SBt0ebqQPEMCDCLnYkA/FIwbHwXhGC1m57vnVM4Buk1XpGfL9lMFXmFI1V87oETwWcssZhqfRIr6emR9XafbMnIgfPOBAFUVnejAyx4gbI6MO6L6U5XBb0Z+YIo22erzNid7lovz0V0bFoMVW0IKEErmsEcaZhAa04WPeB6PpAt6YFyved/7wZR5lVufH6BFeaPDmFYwlBlLo9F2HaKwc5BHe7T7l50Ab8WCJC/WeeapKulTXaJoRQa8oM0wqx6Wndt0o5MgUvcjoEC+cXZjPN1aNP0eYvllM9XUJdl/CJfGtAnZ4lkSUkIDnc8jSzWxWhaXhQ0/RiJqpbRzBcd6EbaG5BoujKXY4gL2e47ps1zTwcYjSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/15 1:24, Matthew Wilcox wrote:
> On Fri, Jul 10, 2026 at 06:16:54PM +0100, Matthew Wilcox wrote:
>> I think I'm going to have to change how we track hwpoison in hugetlb
>> in order to make this work.  Let me think out loud here:
>>
>> is_page_hwpoison() can be called without a reference on the folio
>> containing the page.  The answer can be wrong in this case, but any
>> UAF must be benign.
>>
>> Grabbing the mf_mutex inside hugetlb_page_hwpoison() is insufficient
>> because we can't protect against folio_clear_hugetlb_hwpoison() (the
>> approach attempted in this patch).
>>
>> We could add a spinlock for protecting freeing & checking of the list.
>> That's probably simplest.
>>
>> It'd be better to protect the list with RCU.  But then we'd need to
>> put an RCU head inside raw_hwp_page, doubling its size from 2 pointers
>> to 4.
>>
>> We could completely change how we do this; instead of having an llist,
>> we could have an array of 32-bit page indices.  Reallocate it when we
>> run out, doubling its size each time, and put an rcu head in that.
>> That'd give us 32-bytes the first time, space for 4 indices, then double
>> to 64 (space for 12 indices), double again to 128 (28 indices), etc.
>>
>> We could also RCU-free the folio if it's hwpoisoned.  We'd need to
>> clear the hugetlb flag before asking RCU to cover up this problem
>> to ensure that any reader that saw the hugetlb flag set started its
>> grace period before.
>>
>> Probably all too much trouble.  I think I'll add a global spinlock.
> 
> Sashiko pointed out this doesn't work either (ok, I was reading between
> the lines a bit here).
> 
> Since we don't have a refcount on the folio, it can be freed at any
> time, and the hwpoison list head can be reused for literally anything.

Sorry for late but could we hold hugetlb_lock here so hugetlb folio won't be freed
after we fetch the lock? We can recheck that the folio is still hugetlb and hwpoisoned
once we've got the hugetlb_lock.

Thanks.
.

