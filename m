Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D956C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368736B0099; Mon, 21 Sep 2026 14:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319676B00A6; Mon, 21 Sep 2026 14:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E15C6B00BF; Mon, 21 Sep 2026 14:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E247C6B0099
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:32:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66684120267
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:32:37 +0000 (UTC)
X-FDA: 85238615154.26.D2998DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3FBC140003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:32:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFpE9f55;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790015555;
	b=Xri4RvujYDSBT+TazSNvmohQa2ttmNXHcsDWCRvIExF1n+7e9CBfcFNcyOoXTizIQp8ETH
	jY/WUViswx3pGCJymGyW57K4ElM02J5echYY/V1WgUIsUf7X4DFKYHqUHdIP4RFI0lUirn
	yMBxMiRY0dMTdeX03RRHrftQ/ZhsSMc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WFpE9f55;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790015555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pyw6OIqYdaAAArC1eiLPCVl5i4GbNp6LlCIy/JNTw8=;
	b=dyq/v4Qht/LzHl8DAMR2L/2TONq1qi/7s2P/5/vuT2g7tCRGL5bZER9c0F+mdzZFHEhU6y
	u78xDau1T80v7WnNzmu8CgTgu7PKLV+qGE5BdKtwcUzjf9at3Gdhrdncro3IwosqYgYnPQ
	y4vb+Nc0JylZ6rEpiL2iN5qiz53DLNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 463336021E;
	Mon, 21 Sep 2026 18:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB3C1F000FF;
	Mon, 21 Sep 2026 18:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790015554;
	bh=+pyw6OIqYdaAAArC1eiLPCVl5i4GbNp6LlCIy/JNTw8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WFpE9f55RKK1JMKZpFnzyVz8Dh1+RNUasf0LCrtkPk8+9726+cpRXF54sbuypEfBf
	 5LTBlAiInfG29CTPfkcQOP346jxknb4mbDB15wEdh54KIXQ6mAMIdM9WzPIyQQREBd
	 SV47M1UTSYsyEzBI3js629pZI7JGj/fNujG5663D0CZbNIqkew03Eq589y7pmvK65k
	 g/gXwVIivnPr/fkXhNnIjoo0v1e3lIKcXrEecSJnYiwZz7cRmfx/0s6haCgCO/ee8U
	 As9PU/MVIoPu3tNUquzVZgN3iP/ywgFtdx1I5eKaNyQaELj5BTpGbJujngYk30c3LQ
	 dgqwwYKmpuvew==
Message-ID: <bc2805a7-361e-4082-bf71-efc125b93c84@kernel.org>
Date: Mon, 21 Sep 2026 19:13:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/12] mm/huge_memory: zap deposited page tables after
 an RCU grace period
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen
 <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
 <20260911-rcu-pagetable-freeing-v3-1-7b8c86103821@kernel.org>
 <467b6599-b73a-4f58-a29a-b6c6d1ffc3a5@kernel.org> <aqrAflIQbwcNKlQL@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqrAflIQbwcNKlQL@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3FBC140003
X-Stat-Signature: 1f33gbki5e8mharmgpf4qmjcimizmk9x
X-HE-Tag: 1790015555-3357
X-HE-Meta: U2FsdGVkX1+/n3uNSdwscnWlprCsWDPIRtFF/rXjlM/Bev2TQKve2a/EuKVX8kvxC/wWfwl7is7on4vY0o731yp3vLlOPJwKB8hG5XJ4b8zQa08dE2JA/bu56eWZOu2y+bbWDqbnbc5hV+DQjFCOGnIKnqpsR3k2Ku3xlsPE2QNMqn6fSKgnQRoLew7imi8LUnK6IcwudDjuoRU4sI4LsmiVdeuPd0eLqwHl5mYOHN96zvcK26HforIMghr100BM7iTAcUnfuio6x7sZdu3FeEsmtphmgINwEoqdRm54cjikCUghioe+i85gc43pR+aAloSTJFR/vZHmG8bJgKgfs2XF3JhFmOfvSaShr6I8ds2dEBg1BpCii6Mee75FXOI+IPTMaEskXe7D8DB3bT1XsJ3Jo5x4ebZLmB+gYV2QD1QYPsTbSzUMH3VPXA2zbCC4SKTpTxbtVystsACe8Iv25vsiWZrpujEljnpB1sKWHWUbucGabtHwXxuaruU0wBZN38NE3KWYvWBAIj2ynh4XDv9NflYJB++lcINpL45+h6014+we+cRiZlrwDwVPa2RbFsbEVBigSvpbPyOAkKiHGzfLc3/LRCzkOk0u5cKs5h34h6Ej/B/8OXyvGrFIkK5rWOc+piHssy2JeZ1kWU9wFE77v06LAW4wEXT6AjBVOi5hF0l0k4x1GqE0ZZKW8rfyK/N3Wze0rfwpLtOJvVXGgrcQsg6XOOpcKXSJ9XVMNzjjO5KiF/mktppqozt3cnBst8h8haDS2BNdhXmgvXjsEAUxdlWMQERs3YQWNgk1D3FYbgqezv8FNLQ2Ct/DlRjc/KrtbD86BpazQyBXf48/aMUvugQgFLZfaWt0JVFzydumziOXNFFln3C+EM6hYm7JnV1CGufobP8Tpypaa22tjfsP5E15UvBUMLe/wh9M/lP+0864AtDUhoDtGRIR+E2tw61zS38hqJT6//tzMCL
 8C8m0qFr
 WMPdQ95lMhmR38GtUBh0u5KX6+f8nrZJZSnXm0kE3MwSes+Rr/VC/I4Ip3mZ6OcnYNsmTME4yh00Iqo8FUhUxB0ogBBPVvzcOVFh8USOOYPMINqOFfXnzLSeRIJY+m8RgJjx0nUWKQ3oTeOU1gYFy1DvbXHaV8bSEAWYdx4W8B55DUBUBXcpstvhHT1nll3XzX+sh98CKOdMZDYR+NOINaf6jfOkZSnNOMJ6kUIKJduLmMehD0oeuMaO6V29fq6nz38+y1WP90e+FSy3ISxPgm7jg/3lN24Cxn79lQZkmfu4LEbSItBrq3EzVvemOiLtzDtgMwpctYGNwgT2yz/7G6USvRkPVheq4NBhe1jccMFW/L8Q6eAVy9y0EK49flPZDjy/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 18:59, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 16, 2026 at 04:42:04PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/11/26 21:36, Lorenzo Stoakes (ARM) wrote:
>>> When an anonymous mapping is collapsed for THP, a PTE page table is
>>> 'deposited' with the installed PMD entry.
>>
>> Right. Or when we allocate an anon THP.
> 
> That case doesn't interact with page walking though, as they're
> just-allocated right?

I was surprised to read that page tables deposited during collapse should behave
differently than page tables deposited during allocation :)

That's the semantic change you are adding (and that I didn't quite understand
from reading your description): a deposited page table could now get reused and
modified for another page table due to a PMD split, while there might still be
an RCU page table walker walking it. And PMD comparisons (+ proper memory
ordering) have to make sure that we didn't just walk  something that doesn't
belong to us.

[...]

>>
>> Wait, but wouldn't it be really problematic to punch a page table that is still
> 
> Punch? You mean deposit?

Yes!

> 
>> being walked into the deposited list where it can just be allocated from another
>> PMD->PTE split?
> 
> In general, RCU-only page table walkers are _only_ guaranteed that the page
> tables are not freed from underneath them, as per the cover letter:
> 
> 	"As a result, page table walks can now be performed safely under RCU without
> 	 any risk of page tables being freed underneath a walker.
> 
> 	However, this is the only guarantee that this work provides - page table
> 	walkers must still ensure that page table entries are as expected
> 	throughout."

So far page table walkers never walk deposited page tables. Just like they never
walk freed page tables.

For *current* lockless page table walkers (IRQs disabled),
tlb_remove_table_sync_one() takes care of that. So there is no such thing as
"walking a page table that was reused in different context (as a page table) in
the meantime".

> 
> So this series doesn't actually have to answer that :)
> 
> But a PTE PTL -> pmd_same() check will flag anything like that,
> a.k.a. pte_offset_map_lock().
> 
> The RCU lock replaces stablisation on stuff other than VMA/mmap or rmap
> lock.
> 
> If the walker needs to be sure the PTE is actually valid and belongs to the
> expected walk then further is required.
> 
> Alternatively (like GUP-fast) if you wanted to avoid locking at all, IRQs
> off would be required paired with the tlb_remove_table_sync_one() in
> collapse_huge_page().

Doing an RCU sync in tlb_remove_table_sync_one() would be the big hammer (I
thought that was discussed with Lance recently). There is also this option: just
allocate a new page table and deposit it, and free the existing page table
through RCU.

Long story short: allowing empty page tables to be freed by RCU is simple.
Allowing empty page tables to be reused while they are still getting walked is
obviously more complicated conceptually. Likely it can be made working, but I'd
hope that we can keep it simpler.

> 
> Another strategy could be used I guess with looped checks but it gets a bit
> sketchy with timing etc.
> 
> But actually maybe we can avoid all that...
> 
>>
>> Note that pgtable_trans_huge_withdraw() just dequeues *some* PTE page table in
>> the list attached to the PMD table.
>>
>> Something is odd here.
> 
> ...Since this code path already allocates (the huge folio), so allocation
> here isn't an issue (as long as done outside of lcosk), why not have it
> also allocate a new PTE to deposit and RCU-free the existing PTE instead?
> 
> That eliminates the one place in the kernel (afaik) where a
> page-table-walker-visible table can just get yoinked over somewhere else.
> 
> Then a lockless PMD check works.
> 
> E.g. something like the below?

Hah! Great minds think alike.

-- 
Cheers,

David

