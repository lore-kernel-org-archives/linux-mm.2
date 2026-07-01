Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0735BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24766B00B7; Tue, 30 Jun 2026 21:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAA36B00B8; Tue, 30 Jun 2026 21:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37C66B00B9; Tue, 30 Jun 2026 21:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 809896B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:24:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BA661C62BD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:24:34 +0000 (UTC)
X-FDA: 84938462868.06.190F222
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf07.hostedemail.com (Postfix) with ESMTP id A8C4E40002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:24:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qIRQzvuU;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782869072;
	b=qiMvNNjLxlw6MODiUjfQQ4rYgdROXBIZSd6dtZrqmYCXI1S9kYm1nAJzDFxLsOSwc1klb5
	1eeuYFdbtEK7Wbi9/sp3K6vgXxmnUdyBmBYTza+Q4j+1S0sqZPIgfd3gQa8FrFXpCOD95i
	56640N33wi39howEZBVnVINmIOP/6WI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782869072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWpUPrQcp378MKLNjuyGRA2K6a32KbhgfliIyTiZSlU=;
	b=3B2cFQhIdxozsBdi+NSWVzlzsMe/dk7hwGtlDIiPSXluA+Slq4dlidpxVHHrhNPus0qX9Y
	j4HI01yCNCL9CfSazJhAczX/roGSdfnyGQsPETHN+TQwl7w64GYKUB338IxvQTC9UrFoXH
	re8SCY2Sia/HBqHGSpHBgJK4qkd7WOs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qIRQzvuU;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782869067; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VWpUPrQcp378MKLNjuyGRA2K6a32KbhgfliIyTiZSlU=;
	b=qIRQzvuURidBEXGpD+Q5HMzNmDZAVGPGmqa1fyaUzd2IlOJmCmwY+nQi7AEucV4fkt19GcbgGPxdJ8igDsytP1BopAcAazEWk+QVjf5Bb6/i3j5IS9hn3JlJdy8rXP36jvAI3cqvH9YGf5TzGQeOJEnSuhElDK0sj4XML8gPo9s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X61Fh9q_1782869065;
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X61Fh9q_1782869065 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 01 Jul 2026 09:24:26 +0800
Message-ID: <c994e9ef-4457-4844-810a-a23a94980e1f@linux.alibaba.com>
Date: Wed, 1 Jul 2026 09:24:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/shmem: Fix data-race in shmem_fault
To: yahia <yahia.a.abdrabou@gmail.com>, hughd@google.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
References: <1d27c781-0adc-474d-9c75-899e63bf7490@linux.alibaba.com>
 <20260630120222.11562-1-yahia.a.abdrabou@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260630120222.11562-1-yahia.a.abdrabou@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y8zah9dw6uyx1o8pkjp44g3wztkneke6
X-Rspam-User: 
X-Rspamd-Queue-Id: A8C4E40002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782869070-952773
X-HE-Meta: U2FsdGVkX1/jH1yzMSufiu2kQLFDyA4UeRB8Vj8aJSumhum5/xJKMLyLczesOKgdteaVMTg0kg96kuZo0TVNmN+Lvcdn3/0fnMzj5IVMyRpfv3zN8kIuNBqP9EhdfKw2VdPevq59fEHvMMEqsXw9qln3f+xn42HcvIF7Nz90sDmIh9zG201oW5vJKR3GbU4cd3XnFSMe5rWJTa6n2BkzJnr/NlyqlTi9mYF60eis1j1fO6G0pG0aiIa4OHvrcZC7ROj1iduT1TWz5uYrbTWlAunRzoz2FIEkJu9e8GEkz20H4+3Y8GG3kBWtKsXgcWY/5C5DydMdN60oluMy935sx6Oh10Ja87MK39QuAuH7Hh58vravYcpR+UgiFUc2TX+MRocoL/hUmTJtPIeJx6Z7brAbK5YhRF9ZlMW5APoXnzuyLpIAlHqBmbRZdOYi+S9tz1kNT04EMpb4xAyZJJxOc5iq33LWxg9TIbpvSK6qDwuEUMOSVuRe0g3p32lv64cD+hgP/eCJb6Q/E8EEIJXEs32JU4K+kmUIkAEQkioxwJrf6vCpKS0Bb7QWFjYssKjIH1PcQ6TXRfaRgc5eMyoch1fGxW1AEvdM9WVq4XptnEgZA8/1tM1Gi3qXKN8r47T11wce3ZRWwbdXrmoSCQoPNYfxpZ+UORyIVbqDKR5mlksjpPrDHqRJyLigm0s6UlEFcrl9iKVLHdbDos2zPq1JgC9/V8dYy23NJ89qxRdOdD/L61BpGpANqhZwYYLoWKcvw41tPh0B7Me7dsXOj/cGr64TT91MnXtfux1tBMrtMF/AYtfmzhMdOcUaurydS1/oJWdvACSi0cfmOVg08457RnA+/RxZ8+EqjUnSmbibNXJqDSKFWZlFWW050Sz9f+H9LR0Mf7mrGxmUUQcABUaOZvJMkjOnhB/z+gze0J+BU/h50gdK/bw/2quCgNaIMAKSABLNisH6JwOzwURwLJL
 Gs6NHRT5
 fx1dQlxt82NjcDo/RA03D7gq0GMwhzjUvHYedJWUg9gljoOBF5eqJE+BzOSrLM/xbu7uDcOM8oO6+K1gen0KD5sdMDMPXeInc3XU3PKfPV/3lbbHwsCJmfIjHXutiLazleCqRsam+ZXKZLa7TJE0KItxYDFBkbwvu03HreXODj/x8pD7Ni48EjIN9qmE7mfMwcuMeRu9aU114Pb3DwJqoQHWCP+70gmeYfsAoZe1mTmll4+OdXMCivnu84Ae1dnKP/tNw5SdIrCoSdcunrsX0dyaRDaIjR7jgJ25I9zamUDbsmWHywRMs0zGv0J7S+tyUKfvYzZyoEWf7AZx/Nitzs18rFFMmiR2llkAoyIIJGfk1pZzo0t7XxWZkizgwrl0whXLcozgU2NquG1lASHEoRqZU78Jt88x1TBsx5wV5V/p5b4LiyjWPRGY+ojofCJVlQCe8tAsx+ctAgoRNw4w0uOeCzkBMxmGTaHjIlewPzOdfx69lvmSiS2OilYs5FKgZHS5pIwWJ72bVs0Lzek1v9A7RmlLsGvHgn+1JnMmG244sKwFzYCK8WvOHwJm2A3EY2dVzp9LizzQdGhz/8/exPgo39a6jwT68lEbMrKz8K/SAKzNm2zdMHiwF6kul5eyeYHPsPedxm0n6YzM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 8:02 PM, yahia wrote:
> shmem_fault and shmem_writeout access inode->i_private
> without holding a lock, while shmem_fallocate is modifying
> it while holding a lock, thus a data-race is created.
> 
> Fix this by using READ_ONCE and WRITE_ONCE, which provides
> an atomic, lockless read and write of inode->i_private which
> prevents compiler optimizations such as caching in registers
> and add writing to inode->i_private with WRITE_ONCE to prevent
> the compiler from writing in registers.
> 
> Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
> Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

