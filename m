Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12395E7316D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 13:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3076B008C; Mon,  2 Feb 2026 08:23:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4A76B00AD; Mon,  2 Feb 2026 08:23:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6D46B00AF; Mon,  2 Feb 2026 08:23:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29D396B008C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:23:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5324C0220
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:23:29 +0000 (UTC)
X-FDA: 84399583338.20.78FB37E
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf24.hostedemail.com (Postfix) with ESMTP id 896B8180010
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:23:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Eo/8wR57";
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770038607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Blbtt7dpKJRpfc49e1GFkumagufWOg54JBDgVKdtOyU=;
	b=iJCGaG1KP5uiW9BkfQS8xcSJj1FyJEkQY036yzHdk9HlN0n0kntukVy7iSdUJCpVZIwHYu
	/4srDN8f0a9Jrc4HnguTHiD9ojqML9sMBl045FQYSOjkWsNApWx1knhN0dMafw+y7GDb5w
	4yLUG3TsvX4YgdWAAXcYV7XhcsW4pcM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Eo/8wR57";
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770038607; a=rsa-sha256;
	cv=none;
	b=WAJgIPS+A+dz0JQqBXNbG40wvrkySWZWo7Z8sSQt3R4RX0oKZ+q4am/SsfESnFMBkyFkVP
	wTf9taYxCRi20yphWazn+5ZfM5paZdnC92XiuFmYD6zXF6Wadb0PgpoCFsdlQ0Czj606wA
	e9U9OVSHj/Y+9nnpimi/lWB/u6YEwJ0=
Message-ID: <a79a6421-ca97-4a3f-8ec3-55e88da1ec83@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770038604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Blbtt7dpKJRpfc49e1GFkumagufWOg54JBDgVKdtOyU=;
	b=Eo/8wR57GdsB4LDM8vtNREaPg+jgd1Z6kRUHgJbthTbWOdT/NJNDsAohYXREBNhqN/0k7s
	unJFWbD/w6cabBy9MCj8+62iabw6BRytmx+lEqwCE0o6a3GZmB2ewbKEBgb4XZpDtjthFN
	hZ2Awz3Jjtl7WuIQ4BvZa6vEZd5efYw=
Date: Mon, 2 Feb 2026 21:23:07 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260202125146.GC1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 896B8180010
X-Stat-Signature: 413yymib6oi7hrb4twhdgzdjx6rgch1e
X-Rspam-User: 
X-HE-Tag: 1770038607-345097
X-HE-Meta: U2FsdGVkX1/1YgK3IAYp5OnHojz9fn2fGXEPPX98crhajWJbWFWt28KZmXNdOZZ0i8cugunenTsJid+N2Zoom5KKxO29y/j3cZlVh1ztQ55XC4nv4/fMUBEhLoLPYaLNLQvm+6WDf8AWmTe0OOIOj/y4ssz3LqkCt7upthh3QRQXGLvxF2Gs83qY2/RavFjte9f4vnrc/SJwcgni0Wde9bXmAyaRjCyQKjOVFn85Q5j7MIBUeus0vmLrpax2lcKDBhvyECyVsTJLsy3RbJFnugvkuL9OCJuLfOe0rUjDI6t8F/X7gZADK4Br3wDW5v3VpOgPf2DF1WOsi8N9lVuPgzOR+6nQE7b38c734NNRmHLMAt6Acq7FOyL26Z0S7S1o4Q1drPtOhmuDQUMzusmX2kcWszGiwtMqoLJU7faozI6oKymthumFQaeWGkAF4omlVlflyvF+0ku+1EeghhbkjdtiNzdImGmbt4vEf9jVeCK1zTYH2P4/T62Gj0s9sfLbUq4AhEowHH36E68yyHPywH0v0gr6RVtw4wusJ1VprMLaSu+8IpK/Lx3/zeBWN9MEpNx6AS+Yt3FsWkiFh0TvfccSZMJvOWPM4ZwaM1pi5UDCzvdiFJqhAUPqkqgUkXxuk+f5PFDPtoN6t+7Sq6bA+5Dkx+KFWaNGTVBL9duBuy1NVgqXQYfTraE7fny7xq5u46jstL7f+XVqsbTmSJy6AqiB8IXRgKpMymYjoGdSKNJCF8ogsAJd4OrK6dmq4xQo88/2NxO3LqdPbYhtEovcKSGMcqS4fRPOshuh8CAWCEGYfHCQVcqJ7xb6/gNJBx8C2LAbjiBUPu/gO0MXYP4IGQVCMlH6Bc9LoLNNw2dwUp6yE0BVaMZnaVo4Kzm5qQ+qmPnUuxwwzJNEQh/ZUphhbPfTTyvEjbMkULmCAKVJyoXsYbQa3AYZkmEjbasumryhO9ygkZyT0dGCbsvdXcs
 XekFELBx
 EjlXuuGKa2gNyu/68faRrHp+aXc3LhJrnzEOdgSUFTOa4kqk3vr4fGilsXjt33bucVL9HSgrgp8K5NH9VwJgEAbB3qss4Oi5DIJXK/+hIik0MdVoD1TUL7tiBYfaDzjJWKpi+D1oNuaHUJ62GA3wSM2D4o1rmMCtG4HeJErzL00S4DXouyNmFUHVw+PgYYVbzkkmQq4MCudjbifMAFP3O8rexSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/2 20:51, Peter Zijlstra wrote:
> On Mon, Feb 02, 2026 at 08:14:32PM +0800, Lance Yang wrote:
> 
>>>> +	/* Pairs with smp_mb() in pt_walk_lockless_start(). */
>>>
>>> Pairs how? The start thing does something like:
>>>
>>> 	[W] active_lockless_pt_walk_mm = mm
>>> 	MB
>>> 	[L] page-tables
>>>
>>> So this is:
>>>
>>> 	[L] page-tables
>>> 	RMB
>>> 	[L] active_lockless_pt_walk_mm
>>>
>>> ?
>>
>> On the walker side (pt_walk_lockless_start):
>>
>>   [W]  active_lockless_pt_walk_mm = mm
>>   MB
>>   [L] page-tables (walker reads page tables)
>>
>> So the walker publishes "I'm walking this mm" before reading page tables.
>>
>> On the sync side we don't read page-tables. We do:
>>
>>   RMB
>>   [L] active_lockless_pt_walk_mm (we read the per-CPU pointer below)
>>
>> We need to observe the walker's store of active_lockless_pt_walk_mm before
>> we decide which CPUs to IPI.
>>
>> So on the sync side we do smp_rmb(), then read active_lockless_pt_walk_mm.
>>
>> That pairs with the full barrier in pt_walk_lockless_start().
> 
> No it doesn't; this is not how memory barriers work.

Hmm... we need MB rather than RMB on the sync side. Is that correct?

Walker:
[W]active_lockless_pt_walk_mm = mm -> MB -> [L]page-tables

Sync:
[W]page-tables -> MB -> [L]active_lockless_pt_walk_mm


Thanks,
Lance


