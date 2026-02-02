Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A54EE7DEF0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E143F6B00AD; Mon,  2 Feb 2026 09:29:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97CC6B00B2; Mon,  2 Feb 2026 09:29:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA35F6B00B4; Mon,  2 Feb 2026 09:29:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAC926B00AD
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:29:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FD8B56A22
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:29:36 +0000 (UTC)
X-FDA: 84399749952.22.F1E17A2
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id D3FBF18000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:29:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Xa/s9WA2";
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770042574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LNr0+fZCzfcBa5F60oDM1uqpqeQaPLlDr7VaXJZk/g=;
	b=0rhHjIYMNZXB++cgYjj17nR/2JQCHVUAnwwAVDlQQ1RwsJTTk9W5vMmtLpTXbW6DH4I8Iz
	Nhg8GVZtrxGlhFrMNHUGsnQy0jjC7jvoHlSCz1Zd5kTqyUTlZCWn8vzDKZdHDRjEpcOyWE
	uwdL6CDnuU4ItQ8tkrB0yCrb2VNdD4k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Xa/s9WA2";
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770042574; a=rsa-sha256;
	cv=none;
	b=DRih/n3ip/uYI2houihRAsj/XXEQxVkuJAXWv/DWR4XQQ88aAHoGWwdlrnGSNTsr/xwQ1a
	/pWmPoIH2C4IKkF0nYSGclvvV/Nn5ypLaLFHC5pRNeFz6BaG39tM61C/sIJRn8kO6+PsCG
	DqLQ+gIsv7JRG487Y2b/jaRrt/+1c6I=
Message-ID: <4a928cbe-d4d2-4af3-bb3c-e57074d385e0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770042570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LNr0+fZCzfcBa5F60oDM1uqpqeQaPLlDr7VaXJZk/g=;
	b=Xa/s9WA2Y/6hJdCO94IgSQKVCT302nt2S50MHJ9ILaoPbQLI4iZyxn5gBI4T6fGHmtVz6r
	MJz2s+U9tbczDM0Mzz/W+mR9Z6NJe/Ir1uF1+sKQ9ngTGoPzAkdG0YbaJeaIkh2GVH+Xi8
	IU0zekLg3nAy9G5jJ0xUExxfwrPFGUk=
Date: Mon, 2 Feb 2026 22:28:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
 <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
 <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
 <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
 <20260202134233.GG1395266@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202134233.GG1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D3FBF18000D
X-Stat-Signature: 194aqecnpnmgx6c78ks78ntf18fgya3j
X-Rspam-User: 
X-HE-Tag: 1770042572-766229
X-HE-Meta: U2FsdGVkX191xhBcbiadF/N/5kQzYINftameeLpgrgzQXUrgg6wwbde3RA/fSUPTWQK8vgiL7pyD48xpR+bw8zBxqHxTJQA/QxBNXfkpNsdiAa2SZj8m4vUvlKQQ2yUYpI8bVZyC47gK6+Gz5RNm/y/Sh04pGJ7OWv6VeWoyqg8b+O4noduLWmzdFxCiRkkOIKAHoSEn1roWr38Ko9AxyGrMDZJjQ/jXIhhKRW6Qp+24YO77nHhM5StQBWXQPB9PaZgIyXKz88dS0mtEx3jbUZ4QbMUUwQdtMFPqih1IF3WZlS8jWD7hHBXjOfv8THSvQKllOTrodTJRbYQDbA6IAGvGqGyc/+FHNQR8eAX/rnfdMyiHBt10XhzntTKlkG1TWkYTC4m2ovH3Wa2+ADATAFDilWmsx8j+wtVMX84LjmVnnEaKnsmoAmsjGm/y6P4fOM0gQmsxKbmG23qr73GId8k3jIOadtmcpraYPGkfeEip63HCmNbppR9XKFaj+HfZiq1I9SzLjmIJEZpnoevwYTfG7AgTji1oLRFW+jpNbZmlMCpX+yDvFTL7y+sIsaZ757wbv6CciOccQRMVaGX6BGybokQSusMWT1Q/0dzr0W9Hgq7ZMWC3UAtcW7YndFb/YLaFtKv4QFo3QplYGplRDQwsmgm890H/mSmg4GZ942jHpbzKwqajCAjhIslsA2ntgJzclFNT2/m+F1UvUNnhB3Aon+38mnfzbhksb/fvj+6MdKx4vTfQ8yUNWr658a39wDaehOIy8xao8Waf6xgulmr2qAcLh8i+X4CMsuitRWZN9jOkv50KQYXMpaYha/f8Ir3C2ypC8pI2ySI4IKp/gAQ//NWZ15NioZ+gL1dcVHwPfIgxqQBgQhTZNDRx8CbZbdQX+z5NDTLSXsGokweqmVZbiNuHoJHGGcKQZYOKAVRJ7bt757/v7b11eo11gZH5rMAX+i0+fxIsyaePTgK
 CGN6x+QC
 PUewsqbS4WZdGr8MO+UQYrcnPxIXL4DfZMQDFxCa4hEu8nzNfv1LDeJqRZNldPFkMtSwmQn3iGU8H3NKNEpfwNtRSp8br7sx9ZWao8ps+VV0ZMr+KkNTw+EDTUlZJPs0ByvjjhJIFCUn213NADxqr2SiBSycoT3BsivctjnGgK9WhHuYmsxlDb30pQcOHDAfJWVMdDK2m72gh9kp03shQE/MACg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/2 21:42, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 09:23:07PM +0800, Lance Yang wrote:
> 
>> Hmm... we need MB rather than RMB on the sync side. Is that correct?
>>
>> Walker:
>> [W]active_lockless_pt_walk_mm = mm -> MB -> [L]page-tables
>>
>> Sync:
>> [W]page-tables -> MB -> [L]active_lockless_pt_walk_mm
>>
> 
> This can work -- but only if the walker and sync touch the same
> page-table address.
> 
> Now, typically I would imagine they both share the p4d/pud address at
> the very least, right?

Thanks. I think I see the confusion ...

To be clear, the goal is not to make the walker see page-table writes 
through the
MB pairing, but to wait for any concurrent lockless page table walkers 
to finish.

The flow is:

1) Page tables are modified
2) TLB flush is done
3) Read active_lockless_pt_walk_mm (with MB to order page-table writes 
before
    this read) to find which CPUs are locklessly walking this mm
4) IPI those CPUs
5) The IPI forces them to sync, so after the IPI returns, any in-flight 
lockless
    page table walk has finished (or will restart and see the new page 
tables)

The synchronization relies on the IPI to ensure walkers stop before 
continuing.

I would assume the TLB flush (step 2) should imply some barrier.

Does that clarify?

