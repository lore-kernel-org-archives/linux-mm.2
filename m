Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A972606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M8mHgAyn
Received: by kanga.kvack.org (Postfix)
	id 213696B05B5; Sun, 15 Nov 2026 22:21:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4146B05B6; Sun, 15 Nov 2026 22:21:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA776B05B7; Sun, 15 Nov 2026 22:21:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9B936B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:21:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CD9840819
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:21:18 +0000 (UTC)
X-FDA: 85439531436.28.2DD3C3E
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3DF9A20004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:21:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8mHgAyn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794799276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAugIPzNpC7UMbhZOYH201v2ZVOiEbosgCIzwR+ppz8=;
	b=CHEZEVpf7bFQp/wNBiMJMp6OMljS3mZaw2WgeZfwqhgTwPS2ExEgwN79br3h+6l9JEA3EF
	BEp0pDN6r3qf6Hh8kZUbR4isyUIp9jh+bZa9H3ZemQz/a8cVsqrfQcWBKtIIvcLQ/X9UtS
	kYiYTWxKvIYNg7SNvzJCOvvgNGaPAg4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8mHgAyn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794799276;
	b=MniJqERu9eADigVIeQfxDW6f989D1TcOnjHWEG3YSRJNZ34+Eft6/2JmAWYg8ncbdOEI9o
	n6VUF33uf2yPFbVeiaOPLpNnHFkYi1fT389A3HfIJjPrNgb+pK7i0TuzuXOaE3nKLfyY37
	Itog8d4fxjUDJAnuG80I9lc5oG58plU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eG80WsiqYoqypFBVkKs72E/ZaOBrPv9KsimpXVqkwp4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794799273; v=1; x=1795404073;
 b=M8mHgAynhyIaHwj8+XGfMzBIHc+IdQcIEk4IF4vG8ksew36D48bwjAuUJK/qF5gkGucmGLM+
 2puK2I/3h9gGZVbVjnOX1NfDYfND6eIZSIVNjvwhYewBZxBSj8SfCH+UvEU0tVKdM4G75tk5Wxt
 3zMtuRp5gYRvu7APFCx0QRoU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7d2cc37c894a39c5;
	Mon, 16 Nov 2026 03:21:12 +0000
X-Mizu-Trace-ID: 7d2cc37c894a39c5
X-Migadu-Flow: FLOW_OUT
Message-ID: <cea5d9af-435a-4708-a937-59c7cbcb169e@linux.dev>
Date: Mon, 16 Nov 2026 11:21:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/9] mm/vmalloc: BUG_ON() on an unaligned range in
 __vunmap_range_noflush()
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-6-hao.ge@linux.dev> <avWtxcH2mKw7dgbp@milan>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <avWtxcH2mKw7dgbp@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3DF9A20004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: m5qmah4ust6fbt4qgx1q5wgexmkxhw1b
X-HE-Tag: 1794799276-282429
X-HE-Meta: U2FsdGVkX1/BBQdGpNVXSMxcPSWRbIb9POjYbOC8ITXIO0SLAbFFvIAB0DvsA9ivsWh8tBvv9HjmpHEU20tWMewcrinaLtXgX42nRp4N4fvwdg0AAB53Hhi/PbXJ81zdjLh+yt/qjlYYZDRHEx8taDuYGsUkiY7MnPpwsDfrkENbqIeRr+VLYVoBPu8L1DeQF0RTwjFnZENOxGTlm19j4vszT9T2EcGRgDXsOiwivwng7xpt+5AI52zQFkRA5RMMT5kMOz9b1uh9AyggSjC+YzvkiceBPffw4l6vAAWI0DI7KZNspc2Kos62Q8EhCIDUz/LnwMxygUzG7LBYlfN21ruIPgUTM5kLZuK+UjlUBDKl3iuzI5et3ewK8hnp6RcYZIzT5vhYTYP9wuyRWiHl+Z6FfyQqIrMdeQ344p9TX2jGty7+Rkg52RdD2Pu/1LArs2FOPzXpX3pBCSugNkUWkeQVMgY1ZFYDeRznVnCabNqzyKqII7pMQxbxCjxvaCda/kE4vbibgUpT7jC6C2zTSJYe8Z/FfaYvgVJoL+ee4m1jH9blc69ksWVDTHeV0f+Z9hA33gd7cnbrHKROkInibuo21D7M0p6hvozO2JN6h3z92pZFOjKCL/+LgCaKfUN5dav3nOLGBHTPZFZkjEV4rgAP1xcLhfUkhiGV7MekQtJBlFiSx4Hk9LjUC8DpDzhci7RPdQSopi8sYTvJd+5woMNRid9AFasgx1cvb0+rbtvifnqZNwtzAbd12OwPFblDQhODdZXsWQxJJeB2CtY8LWpOb8BnPABxnV93SxJeb8ai/lJNfhjL0ilimJcIazwZ8WxFO6KhdpfQcS3/T3lTFGOdqaHVaP/fIgfuQoLJyaFUnaSRzld9olTCTp6cEhF7ZFKcAxPPHqvuiUs7fJ5F5x4qZVS978al5MtIsZpIR4cqBKN0spb8u+9T5ItC2KYw306oUs4hp9u52i97v7X
 19jhGV2U
 hcgWZr7qsqh7sOjKYU6sbPXP23OM+LGv5mKchbGLF1h1klXWe40GDPjqlW0nT7por75mMGP5NcHbcP1auExyrxJ63RoU7P6MAbYknGCqo40Q90ayrKjJ0a1Q9V4KX42/V3Md4B54vWxRKtNf1v1WEKia57qfE0wQLAoMQxyNB4opGx2/URmy+9cTGEeR+k7Z9zO6rc0YYb6mA8yw6rhvkIWaTh08dXBh53TlsRFrOqvJa40CasD6F9ar0IEpbDuxLgfYo9AfO3yjQLwvzreN1MWeFfeeZQ7IzUb8X5XmIwvKqfqG5iz7FIAK5cltLhUltZqTk8pbOSYgK9N8UeynJ1Gb9zInigOLi62Vtlp0YRv+ne1sP4BhQ5pI+yGWXlmqnvJFYz6IDAZZKXzbWNrXa6X5LbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/12 20:15, Uladzislau Rezki wrote:
> On Tue, Nov 10, 2026 at 07:25:42PM +0800, Hao Ge wrote:
>> The PTE loop of the unmap path stops only at addr == end.  With an
>> unaligned end addr never lands on end, so the loop walks past the
>> range and keeps clearing.  With an unaligned start the loop begins
>> in the page containing start, which extends below the range.  Either
>> way the unmap clears the mappings adjacent to the range, and that is
>> nearly impossible to debug afterwards.
>>
>> vmap only installs page-aligned, page-granular mappings, so an
>> unaligned unmap request is never a legitimate teardown, and there is
>> no way to tell which pages the caller meant.  Check addr and end at
>> the entry of __vunmap_range_noflush() and bug out before any PTE is
>> cleared.
>>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/vmalloc.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 86fbb1d2b27a..0565cbfe325c 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -518,6 +518,8 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>  	pgtbl_mod_mask mask = 0;
>>  
>>  	BUG_ON(addr >= end);
>> +	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
>> +
>>  	pgd = pgd_offset_k(addr);
>>  	do {
>>  		next = pgd_addr_end(addr, end);
>> -- 
>> 2.25.1
>>
> I am not sure this is good to stop machine at all. WARN_ON_ONCE()
> and return?

Folks tend to dislike BUG_ON. Dev suggested switching to this when I sent out v3.
That's fine. After all, nobody has hit this so far. I'll switch it to WARN_ON_ONCE
for the next version.

> 
> --
> Uladzislau Rezki

