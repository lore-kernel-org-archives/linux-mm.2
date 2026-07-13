Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2DBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA0C6B0129; Mon, 13 Jul 2026 12:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1827B6B012B; Mon, 13 Jul 2026 12:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071546B012C; Mon, 13 Jul 2026 12:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7C0B6B0129
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:29:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AE15A0208
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:29:49 +0000 (UTC)
X-FDA: 84984289698.09.BF0699A
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0767A80004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:29:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KcUhILSb;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIFCVDCks2Nl8QDC7s+Gse3mXfhj0M04OqJMclW1HMA=;
	b=ZRJR7cbJtHp0e91Y953upQluX2zqWDpSXHJre/aErV/UfWGKpWUBxfQSxKmDbOPQmNDlLp
	NwSyK4kO7YEGC9OcFIhjXECLTh6w6SHl7PKB7Cg73hfXI8rFV7pvd6uatLqY4SZDqc2JNP
	2Tlm9R5vBrt+4Y3RC4SpO2QM0SGmvPA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KcUhILSb;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960187;
	b=bEDPqISNvWkoi26SvgDGfUS8GRtHjWk2twiyB9O4xjDRj7IhoS0OSgdXHqo7BH/zRS6NmD
	W/jj3qKXJxoQrBIyaWBkV9zIz0pP8/Iphse7N6b2ZzZweVHddhSSqwqkfpS789Vw7UKkOO
	yUuxpZkkFpEUbzCNBqhZfvWB+jHfbHw=
Message-ID: <da9458cd-f039-4c7b-9e00-a473b05aa3b2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783960181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nIFCVDCks2Nl8QDC7s+Gse3mXfhj0M04OqJMclW1HMA=;
	b=KcUhILSbXhnltRbBUyt6mFW8wzTQFpnuIrLLrSbBc8yijyOJmwSXHR1AHSdCVmkZUhzmBo
	OlgsRuZF+Z7n2ktmf9P4k5Qvcy1YHRXjCI8ld47VLus38w/oR8a14Xpc7vfoks7Pf/BrBB
	EjMLWhX7MGumc0j/aJ6zH5H++O0YpAE=
Date: Mon, 13 Jul 2026 17:29:36 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 04/11] mm: zswap: add range lookup for large-folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, Alexandre Ghiti <alexghiti@fb.com>
References: <20260713133613.2707815-1-usama.arif@linux.dev>
 <20260713133613.2707815-5-usama.arif@linux.dev>
 <CAO9r8zNVnwAS-6jOQtGrcN_fq8C+6kRiiRX4=kp9h=fTC+XYNQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAO9r8zNVnwAS-6jOQtGrcN_fq8C+6kRiiRX4=kp9h=fTC+XYNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0767A80004
X-Stat-Signature: njptiijctku3wdj68j1oiztqhwj9r3z8
X-HE-Tag: 1783960185-886341
X-HE-Meta: U2FsdGVkX18L008i6cQEbqCJKp7eJZz/k2mzP1v2GxWyRRgTJZAtprfX1CakcRU4NFYN0cMCoz2HTOWQDRs+dimXMaMCLU4Aa9p8556hYrNZKTGoR+jP5f4SgU4c4L4z0280keeLIAR3+9ThkW553W6hyeyafKg/qHaCV/lVWwelWew+GW3ofiggeMdeEh3zu478PR1Qz8N7f1X1kyYK/JIullCz+qVHn7JqYrg+alo+X/bDkWA/ZqYkyv1mDFps1a+6rE4373bOiHwcWcNmHBmRAoxFDbGGPMu/xbEXWmJibuCav/qLpMauwOCR8o4omlawQZGCoXCL+byy8nUOXGztVqkIrKNvF07jIodbdAGowny5eRPZj9RGpzN2MpT7myW7UsGE8SDx6jEeVQoFsjzNn8aX4EoH9LBLJx8mpZyhZdVO+bwv7Bh5REd5nvXN2fap0zDdl8x32uJzKoqPMHARnAMGuABvh74vZgucrwoSxXPzASyb6ukxJGsSp2eWJZkdCXUaN2dvihj0I6CeM/5LO2npHhXZ9FmJTzW6+xgyBH1XTV8VKrGyl74Hv7PqHpwvT/oAIbFchJXE5EbvIfGTAo0CAU7YPiAIywHfU87HB+qFEWI3XrcUq1pglnB4SddTMqYSqsxjgZv11QAApTbpvc36cJhPOzMN4vN3s6kLODrVOynB3kcpan722V/B9HdfxZi6REUzgKdA9/AmCSswkTIUWh4iyJQ3cFJm8nJ0DwRjclMijaljkvq5Epnebtw+r31JdRtvxyveBs8AXLCa8GMPA/jAVy31QyuYHtgyHPDRBt/nrOSqwGv0NM+uC1MyKzhfWwxhEngVvowado/BxXjln27HPZ8QppKqJ68Wd/Ei+By/IcbdjujHiCaZZevQ5ATjW02XgKxuFyZ5G+cAk4IhnhRpcg5IbXH5hg9ErspuOVlF2j8/lm2II1FMlzkp7Mz0tJwqSipUZsM
 4jYSmix3
 1f+9Is5LjqumYpNctCOyF5LcyJ5lxqJlqLL74dj6eZ9LOc+EW0kqKIf3L/UNWnIW/ahAUdSA5djfItUT0uRvISJKCt55tai181MpMQtX3XhQqzongVy6D3WDjByGcnqn5jo5R6EzB+XiVtXK1l2/ht4Y78KtYEDhiam3/MChK74mjd2UnXStiZLPX1k0TYlsZ8LjtrZUuAjKzt4fNjrGDCm28Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/07/2026 17:02, Yosry Ahmed wrote:
>>  /**
>>   * zswap_load() - load a folio from zswap
>>   * @folio: folio to load
>> @@ -1571,10 +1588,9 @@ bool zswap_store(struct folio *folio)
>>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>>   *  will SIGBUS).
>>   *
>> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
>> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>> - *  do_swap_page() will SIGBUS).
>> + *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
>> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
>> + *  error is emitted (e.g. do_swap_page() will SIGBUS).
> 
> Just curious, why the change from -EINVAL to -EIO here? Does it matter
> in practice or is it just a matter of personal taste? :)

The caller only checks for != -ENOENT so no functional difference here. I viewed
it as a change in semantic, -EINVAL meant that you passed a large folio, which
wasn't supported to -EIO meaning the request is valid but zswap cannot safely
complete a PMD-sized read from per-page compressed state.

I dont want to speak for Alexandre, will let him comment on this properly :)
But above is what I thought of when I got the patch from Alex.

> 
>>   *
>>   *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>>   *  locked on return.
>> @@ -1593,13 +1609,19 @@ int zswap_load(struct folio *folio)
>>                 return -ENOENT;
>>
>>         /*
>> -        * Large folios should not be swapped in while zswap is being used, as
>> -        * they are not properly handled. Zswap does not properly load large
>> -        * folios, and a large folio may only be partially in zswap.
>> +        * A large folio reaches zswap_load() only when its whole range is
>> +        * expected to be on disk: PMD swap-entry consumers split before
>> +        * calling into PMD-order swapin whenever any slot is still in zswap.
>> +        * Confirm the range is entirely absent from zswap and return -ENOENT
>> +        * so the caller reads it from disk; if a slot is unexpectedly still in
>> +        * zswap, fail the read rather than return partially-initialized data.
>>          */
>> -       if (WARN_ON_ONCE(folio_test_large(folio))) {
>> -               folio_unlock(folio);
>> -               return -EINVAL;
>> +       if (folio_test_large(folio)) {
>> +               if (zswap_is_present(swp, folio_nr_pages(folio))) {
>> +                       folio_unlock(folio);
>> +                       return -EIO;
>> +               }
>> +               return -ENOENT;
>>         }
>>
>>         entry = xa_load(tree, offset);
>> --
>> 2.53.0-Meta
>>


