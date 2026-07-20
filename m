Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2280C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34066B0096; Mon, 20 Jul 2026 12:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE50F6B0098; Mon, 20 Jul 2026 12:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE4D6B0099; Mon, 20 Jul 2026 12:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9989D6B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:47:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21C05160226
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:47:34 +0000 (UTC)
X-FDA: 85009736028.15.191DAF3
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 512168000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:47:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ICBjY20D;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784566052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NxQvnwYlpKK36SWC6+zTzcYERz5XJIYpkhO8WkhgIA=;
	b=55NyFS/r1/Ar9zCHwGwYjWWB65WZE4MP7owRo4m52GcPlcuj3tbAD78Ea5PbCOibxNNrJ0
	jfEpfy5+4ynkTVYP8lJCCFnbMUttnjjN7Z4C+c5aLxLC26EPlS1QKMNDPg3OLcIyFT266L
	Dei0eV61GCrgw/tzJd9MFhPTZ0Nnu44=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784566052;
	b=lsyYpQBog1wkoQiuv8cBzyjGRrW+/XP99ZR/2i40cBDcab73uf4mkzPd1oIVFg5qOPZv6r
	UK+pdNpXyoSUp9sZCg3Ga4giuAFDOJIJ90RCYjSaRtlDB11fXCc2nBBAJ6rOT5o5m1iXOp
	3I6/KBb2HWLEG5ToRQv7qO3yY73eQU8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ICBjY20D;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <46dc1b58-f2de-492a-9da5-a5c429c19a10@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784566050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4NxQvnwYlpKK36SWC6+zTzcYERz5XJIYpkhO8WkhgIA=;
	b=ICBjY20DjdrJPYGZwJ25e7LdKK4Pnj3v+NZ8P/FWIrw5qTXFDS3nH94Zq4DFH6zQawGS2v
	c1sfPFNiRgf9n8LSmFXCHl5gjix/kR4YdHtiuAh9OdlXIdgTXW4QZ3kHJ3hVue3qhGTBZB
	XlTLcBfDBPHrZPKa7Guw+MzBMIngEkY=
Date: Mon, 20 Jul 2026 17:46:58 +0100
MIME-Version: 1.0
Subject: Re: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 kernel-team@meta.com, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
References: <20260720115741.239657-1-usama.arif@linux.dev>
 <13ec2603d5cbfdc493939f182b71e5133c26af54.camel@surriel.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <13ec2603d5cbfdc493939f182b71e5133c26af54.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 512168000D
X-Stat-Signature: f7tfbh5adxuw7kf6jzq15i5k3wz195bu
X-Rspam-User: 
X-HE-Tag: 1784566052-739955
X-HE-Meta: U2FsdGVkX1+j758YiCdx+Ly52LPX24tAdN+NHB7JWO8pyxCw5pwmdd1iZOJYaVDrxrvTUWGV0dHSXCZyf12M/E43skMhYR4F0TgP3rS6qfZdpG2jhddSbYWmBHyCBKCk2fzzomvDdovXw09vE5xoSs7UJWiImPM7FLxkzIl4IMWiTbkc7bbY+SgtxD5sO0f0wETh83/xGPlpYjP/CKsXI1ghFlm0st0xNWd+rQ/10Oe9F5Y3tV9ZVFWgXnTN6hjBPPbOE/2e7D/rLJm+jIJ15ArkhKwVDYLx3sjM795BeDHy8DHGXCveC9IqJdbC6rLvWsV4ms+cLWuuoXUExKWSCP3oeP0lUPmguKdnM08GsDSlavhzxpfwA5Vn+qLZjSdnb1drkuMNVxjWf1abKrpaigI7s6P6bQWh/v2sbcMcDeHwlmR+MqhnLbQEdwmt/PGLT+8yJlifZKPGYq59VBcxu6iH53Z9u7I6//6FIPQSGGmkq+bNq1VdK1xMPLr6oJoOx94OCAZU73jdC5nt/Z7+hnFWGQvY9aUTgcGDx8z/waOHG9KaOUizLOJaefx0BAK4E6F6wHNlVe2SwfNgOMZrfOpG1dbVNrGjqEKvu4FMz3rh4BcfE7vcN/X9tY65UWkTsJ7db4aszThzBGOyu39K3k2EMRW2XXSD+CRUX51EXuviR+8Ght6DvveHqT12oF6CbRSMCGLyNcmr6anI5Q5tM9zzkXWVTm3BSTEma1gaZG4UNdAyxfYBgIrwt3V+lIbQQ2L/LHrsxMKdwJOiD7/zvAGlB+ZjyLBfbxDeVWqP6Z3yA0Nd0cL3uqdcmD/GvhE5cIfQcHetcBx3f+sgilo89fCWULLqjxnva6ehzUl3R33EkQvaAp27bc7FxLGVLqH1IOHHiXJOsXPVHyfSjrESV7XQtAgS+3tqy7HHhoqJ7alqsuo/inkhyagIhhq3ZVCE0xi+m8pSpJD0O205spv
 iIvMsPcY
 Y7qPgAay/uZdyvQwH4hsozpuotUdcJwoyno77enJQzEIpC/f8q57fAQ+oXrUHFBzCQ3zT3ZNB0gvGS5Ud5JOP/hpSNUQ4xalZqzxCRWuXrSW0Ra1bhKgGGZraNHQyN6UvC1EMg0NZwiSs7T5e6zd1/k4ygxqtQPHXNuCQoIr7TwTzJrde2L0Q0lBkD+jmR4nxnA9LulmS7u67OlhoJ2OXLNKCX6SWyYaiX+zl9+ln6eV1fHWprDfl2qh/Qoqinr3C9HJhqScMfR7XREqKClZ+xgEsExRXr9kNSUWNm84k/87oSvqEwbvq6qLf3f0Vjt0rRjgD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/07/2026 16:08, Rik van Riel wrote:
> On Mon, 2026-07-20 at 04:57 -0700, Usama Arif wrote:
>> On Fri, 17 Jul 2026 13:00:32 -0400 Rik van Riel <riel@surriel.com>
>> wrote:
>>
>>
>>>
>>> mm->context.pmlen is set only through PR_SET_TAGGED_ADDR_CTRL and
>>> is stable
>>> afterwards, so it can be read without the mmap lock, as it already
>>> is from
>>> untagged_addr() and mm_untag_mask().
>>>
>>
>> I think it might not be stable? set_tagged_addr_ctrl() can change it
>> repeatedly until a CLONE_VM operation sets MM_CONTEXT_LOCK_PMLEN.
> 
> You're right, ARM tagged addresses seem to work a

ah do you mean RISCV here?

> little differently from x86 LAM.
> 
> It looks like on ARM with MTE, the top 8 bits of
> the virtual address are available as tags, meaning
> that address space cannot be used for VMAs.
> 
> For purposes of accessing process memory, this
> is a little more stable than LAM, because the
> number of bits we need to mask out of the address
> is always the same when MTE is in use.
> 
> At least, I think so. Am I overlooking anything?
> 
> I will clean up the changelog like you suggested.
> 


