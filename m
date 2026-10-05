Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 711B6CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 07:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B6D6B0088; Mon,  5 Oct 2026 03:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73CBC6B008C; Mon,  5 Oct 2026 03:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603CE6B0092; Mon,  5 Oct 2026 03:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 437916B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:29:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D10CB1C01BD
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:29:37 +0000 (UTC)
X-FDA: 85287747594.20.F079105
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C1FB80005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:29:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYPdXbL0;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791185376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJU4wD33mIc8JQxf/rrKic/UXk6SSrGUmqTaAUnzNUA=;
	b=SpM1eqxO2fLtUYy5u4OXZ4cp5jHZr0nfEzUbZhuEHNyI/WVUDBGoA3rmgYEFG6Cex3j+9J
	dAaUhe+kuQO23Pqa6qDS8XadlE5lLZbGMiJG8wT3CXSCKhRn4B2zcAwDfRsbA+OcxNUvYV
	8QCQ3HQ7qONJaNyP6GaUo/NM/NgRbh4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jYPdXbL0;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791185376;
	b=awiqk/QMdT090DC23T+K6ihTs1/2aTQAZQeGxxLFgFc5wq8xFwk2ZYPy32auCZJF1BOHgR
	fDmq0YDQlzNC7WUchJIRIdMhAapc2H2Km6R/k/DzYAuN8KS6iqN9aIU/Hh6IAdS1DMMc0T
	3wqi16K3ttg2ObrWmDHzQuUmsoT6fgY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sK9V2jYPHnq/dXSshCTHnIO11I1X6+eo1StxCE06jiE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791185374; v=1; x=1791790174;
 b=jYPdXbL0bEvo4/CEfima5qxmIMBAoDtxF5EhkCsW2q8qWeMN+37WuD9rlTJbTbUItvpO1gcP
 pkgs9zmzljDymTwLNKL8wNHtGhoBJiVUE3lICIlRIFNx4iNfAi7j7DmMlZinl+ZKmwK89+yhY6b
 QEFMk5nv10+erCzergbo74uU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 443fea304e721487;
	Mon, 05 Oct 2026 07:29:33 +0000
X-Mizu-Trace-ID: 443fea304e721487
X-Migadu-Flow: FLOW_OUT
Message-ID: <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
Date: Mon, 5 Oct 2026 15:29:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Content-Language: en-US
To: Pedro Falcato <pfalcato@suse.de>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, riel@surriel.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
 andrew.cooper3@citrix.com, Manali.Shukla@amd.com, mingo@kernel.org,
 stable@vger.kernel.org, toshi.kani@hpe.com, david@kernel.org,
 mikhail.v.gavrilov@gmail.com
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C1FB80005
X-Stat-Signature: m363gp7cbir9w7im6wmrj5czdit4sdug
X-HE-Tag: 1791185375-964850
X-HE-Meta: U2FsdGVkX193jwIlvZYe5IGmwInpj4C0Yh9yF9TiDzlgDbYqr+8A+44YE6k7Wfn7MHdPI/Hifxx9yP3xfzmVrGqiBrhOdx3r6yDVJ2SLL4uLUfE/6wKf060l6feMqGDF/7jeyEO+cTIziuh75YTGsuXFp4JGfj7PmDjU9JiirWrNMSjf58sdBzJP73qNwW4aowy0sGFD7gviH9/dCJGHZeLrfAhf2t5aoTpDpHl3VhnEhymavET79uX5k9lm/Bi1s4fi3VKJ5jjkd6t4MT4utBjHbbUApOqEi8IOBHHgLlcNcTb5XyUpLNcsOxrMVuYvS95Q0zcalDdmP5OuLrolM5XpZlGx/jX7h+1+v7Sc/kKRU3oRqJoHM25MzvR/df0v26LMeh6S5StN+0O5lLSTRv3T9oL4826xUX1dX6FKNFagis4oC+CGZNvYEevvy90UTlchdfWE7CI7aPI3tafAFEwOw5trCOk8C1MAx+PDVzAom0IKV42vxg+/s1u0Ty9cOkoPrXOeftaL3LjtIeY0zwsiXTxJm215WD8iiBophbEClvYY23hTWj9TsjNMu8SAjJitM7i2zQwxSkpP4o/rsYDr5ncbpRqnvBjIEKrrEjaLaSdZCrI2CfCI8sw82UM2+NSFBXm+t/MAvNxEsU73dYtmNqq1V89I4A+fFDf0+g+8wXMQSdJsnNvVLSMw6F3dHOH8zuhmD3TD37jt8XvGv+lujYDdcKpUxfcwyYNwGXoZXrCqx6nFh5MU6TsqVKaL5Fb0yt7MymZ5PjH63Ik3SlIpLQMLf5TKOLiysHGVzf8eztRzMIAcYTu7d5qjR6qEXFx/5DjoohFX5k1NIWWQDrxV15X925gGQrL6G/GzOa9UNOGGisaUIz/C/yk83gtkTblaPPcK9qcU1uD3xxf7EBePohI4rmghCsDbfy7U/Ep4FOubdQM6thS9hmRCm/HrLRoHNqwjBskvpVSHDbX
 DomjUR1+
 zJsQvYuj6MuRSleBUNQjg70VU2fcUm61Bgky1yyTmvK6KI4s2xueqXNRmr8ZoOyMICmoXPSMYIpkTekVrCLPDmD2EBS5OioL1Afyz4KAOeWFSKr1pYIJ8YSfqDRB5uAfIEZf9/jsiJ6sJx9LsrwqQtqI4tKAGk8+IPMwOMOoHLytd7t3qlkhD25Fz98K/3LPmLUaXMGT6K3928EZ63ydzu6bCLAdTDD0/X4BnpujlrI0e/Ej7qltzBzVyEjgQ330dOb+6hztECcYxJwm7PZEKO+Lgl/E6B1jJX/CVc6ogoAJNCXOJhCwRJwR1hvDaszuV2Xgy4/s3B8LOdIzfgo03KRrGg6unovKzlmkxvMaLFKrMyZFXvWfNfD1HDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 14:09, Pedro Falcato wrote:
> On Mon, Oct 05, 2026 at 01:23:02PM +0800, Lance Yang wrote:
>> pud_free_pmd_page() uses a single-address invalidation to flush the
>> paging-structure caches before freeing the page tables. With AMD TCE
>> enabled, this only invalidates upper-level entries associated with the
>> target address. Cached PMD entries for other addresses in the PUD range can
>> still reference the PTE pages being freed.
>>
>> The AMD manual quoted in the commit enabling TCE says these instructions
>> remove
>>
>>    "only those upper-level entries that lead to the target PTE in the page
>>    table hierarchy, leaving unrelated upper-level entries intact."
>>
>> Even with all PTEs cleared, speculative page walks can cache present PMD
>> entries after the earlier TLB purge.
>>
>> Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
>> the single-address invalidation otherwise.
>>
>> Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> 
> I'm not sure this is correct. The PUD is clear. We invalidate the TLB, which
> invalidates the translation caches for that walk. invlpg will notice the PUD
> isn't present. I don't see a case where it can ever not clear the rest
> of the translation caches for all leaves. And, in fact, by that point the CPU
> can (does?) probably formally treat the PUD as the leaf.

IIUC, clearing the PUD in memory doesn't invalidate cached PMD entries by
itself. With TCE enabled, flushing one address only invalidates the entries
associated with that address ...

(That's how I read the manual, but AMD folks, please correct me if I'm
missing something.)

So couldn't other cached PMDs under the same PUD survive?

Later/speculative page walks could use one of those cached entries
without rereading the cleared PUD, and access a PTE page we've already
freed ... If that can happen, it sounds pretty serious ...

> 
> Did you repro any bug related to this? The functionality is perhaps
> underspecified in the AMD manual.

TBH, I don't have a reproducer yet. Just LLM stumbled upon this while
I was investigating another memory corruption issue [1].

[1] https://lore.kernel.org/linux-mm/arY1Wq6R9OY20ans@pcnci.linuxbox.cz/#t

