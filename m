Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C48CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 08:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911A56B008C; Mon,  5 Oct 2026 04:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9846B0092; Mon,  5 Oct 2026 04:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8000A6B0095; Mon,  5 Oct 2026 04:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAA76B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 04:32:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEB4BC0172
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:32:29 +0000 (UTC)
X-FDA: 85287906018.02.5128096
Received: from mta1.migadu.com (out-72.mta1.migadu.com [95.215.58.72])
	by imf07.hostedemail.com (Postfix) with ESMTP id 734AE40002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:32:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oQ6rdbUH;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.72 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791189147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKwFasuTx2dQsWLxaZQLp7rNh+Vz/wDhfTS9l9pBQUM=;
	b=1CqEOBxCHMM4bhlvs5/TqOuVRpflbq6dWXYXtq3UfuxgawZNwOIP8LzTId5m2j//prlo6k
	km2DfPX2jZaHNLuKQdA42hN3gW9uS9r/JHeflQDzI22qM/PSgXCHRGb8r1X4Ba6Z4OvF6f
	HEPHuOd1F4yGSvQPxUKaPelAjRnu42s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oQ6rdbUH;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.72 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791189147;
	b=HHSJDO8RnbQbpVEgJV0YaYwTcHjmGErY7/OUYrL2z03ft3ypDUVXl5U7M6bHXJTa42IeFB
	CyiDagQtE+y5yWYXhhBa9FxmVD2rlspMunQKb2rZydmX0w6fq6TRaRrqXLIziBJit7ZBjq
	vHJTJCgD+Dl9sFJiVlPDUjYz1ZGXW2E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZVqDd9QcXqvYOGttGtquLNTksUQ0N7zdBVZm8WxBuns=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791189146; v=1; x=1791793946;
 b=oQ6rdbUHuhSP+4h5cRRL3sBX8z5na8Ci6CGhJuK/EKEZdb1QKW3sGH/PB8MTZ7D2UEHrTDDK
 TO9JikHQpuTKrwBCnHoRNHBOWr17uXf2NpvhoNbfEGNCUTjla+OoNZrcCFSno+RcHVUMADzdV9a
 XTrqpUOEHNGnmAunn60ROhqI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 73cb7fec8dce91d4;
	Mon, 05 Oct 2026 08:32:25 +0000
X-Mizu-Trace-ID: 73cb7fec8dce91d4
X-Migadu-Flow: FLOW_OUT
Message-ID: <38541ec6-d796-4f35-a700-75ab097b6df5@linux.dev>
Date: Mon, 5 Oct 2026 16:32:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
To: Andrew Cooper <andrew.cooper3@citrix.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, riel@surriel.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
 Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org,
 toshi.kani@hpe.com, david@kernel.org, mikhail.v.gavrilov@gmail.com
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 734AE40002
X-Stat-Signature: stcxjf15ic5iroz4cteguowh7n33us8t
X-HE-Tag: 1791189147-521551
X-HE-Meta: U2FsdGVkX199tdPR8KVvAPfUPR1yje1rneHcg7J3FLYoz5xnT5ouIbqdloKXyzr11ghsouf82ypPCs+/j7+JDWKvjUVJSGBFjE2kRVCofxFw33Kw7jxTwZN+BpdLk6HiOvyET6PcB7RPIBPs/NkcN2U6pnPz32OVxh4qXjdOr+UgYTcqjSNoPVaQHocO0/CczS1Jd5vC/2hAEjf75JPQKGjJwvUy9ncIFCA2UlSPXs8Aw0RlC3kCPxeB7X68jM7kLN30cdNyoGif46b5qEjT6vRDEZpVZ93KzmCU+0DqhYIw3rUVpgkNoTGVMOrC2+G/C0adi+6hgSqXD0TKtJdfzPu8GAM2srRprvpEZRL2nxN4/AuPQyCxXYtUk4F92gOLcQvaLFxD3WNjXjWQYCFfFu3wTAcr10t4+5yM80u3qIujVGqUq+GdZ5xCkP0v4y++Nl/sH5Xwhn/jghgWm2rBnX3rtkLGrkALwb780xdw4sez8bqVXWZ6ExSyTo2VZea8JLs3/ZKgsAHbKwY2PAU1Pb2oMVtPqskytfrBy/TnR5FBfFOGxb/XOCziX0pjXq+jgIIyfwQBe8gJEGj6bH4YJ0UHsLm6m9iQh7Q5IqBzNIZcHxYLToFFKz3A4uGmxz5EGXpUbHMrRs0rLbXAm7KL4/YpKBPE+IDPAzT8+fNy+pYt7Dk7Qjp4a2MbTQglmWGH012KEhPxJNEXSkVH0DSyxv+HzOf0nM1vnSXVJc8LZvDKuILLT9tAtlbpgkHs/DOEn5FMLwAWaLtLa2tA8MgezGWm7T6xFUlzKDR5VA4oDEZstNuEVGvXH52bJVlvGBxGIy6+i7202j/GCT0CbSf4hXxQRCaUuU1xh7h7GSKTuH0e1JNYJUpRCjy45SmJ/sUQsh05Iu8yl4njGDcP/j3e4/aLhm5+sSIgpxp2uSw28DRgsog1AcR9JqZDTysaAW0tueY2jWDywbtU4PGIsX5
 0f3qyHS0
 l/NalDd1YZI7LGuEBUZEhgTz4ppY3kClzwfQVcFK0Oc2En99G8CM+h4u/HCWtCRJk6oq1NErDgrO3pakMf6YcN+q2b318yi9FWImozy+JCY0kQL24v7bkRabuw/CJHucESqTuOVETUdDW9fI8Pow0t3FT8EZxFDt1jqF/fzblIVL9JdrXcSpYuSrW9GX8JfhdRo+P9u9CpuHTqfEHsQ45/AWIXYhXmpN0sYglhcMdIeGmpUd8z6RwwoqFGJRr52oIPmGUC0cgkakOuLMMoNln+unXmkWNGd1X6f1J0dEIMssXfDzSZHj7V6P+BYEkNfrPCCOJPogQkZJufZi0CMSvowYwtIXgiyl24BqeyTWScrxDu4jF0tMEEoERTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 16:19, Andrew Cooper wrote:
> On 05/10/2026 8:29 am, Lance Yang wrote:
>>>
>>> Did you repro any bug related to this? The functionality is perhaps
>>> underspecified in the AMD manual.
>>
>> TBH, I don't have a reproducer yet. Just LLM stumbled upon this while
>> I was investigating another memory corruption issue [1].
>>
>> [1]
>> https://lore.kernel.org/linux-mm/arY1Wq6R9OY20ans@pcnci.linuxbox.cz/#t
> 
> What hardware are you running on?
> 
> That looks like the Zen5 issue, for which you want either the latest
> microcode out of linux-firmware and/or
> https://lore.kernel.org/r/20261002211617.1001617-1-bp@kernel.org
> 
> TCE is a no-op in Zen1 and later, so unless you're on older hardware, it
> won't be that.

Just to clarify ... these are two separate issues.

I mentioned [1] only to explain how this came up while investigating
something else. I'm not claiming that TCE caused the corruption reported
there :)


