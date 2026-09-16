Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 715B1C982C5
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6626B0088; Wed, 16 Sep 2026 10:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E4B6B0095; Wed, 16 Sep 2026 10:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17E446B0096; Wed, 16 Sep 2026 10:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E44456B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:42:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD26E1C24C8
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:42:26 +0000 (UTC)
X-FDA: 85219891092.18.EAE53AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 34F174000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:42:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GImUOcTT;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789569745;
	b=tlV2tsQsivlIlZwwrfu+H7OdE1m6V+Y/sVlEsNkeCCIhgGeUqGQbqIz3jCSlujLq6Q6p1r
	TPvI6x3XiDbeeeeLpDMAOA/UuZmeauW7rQsN9zcJM28yM53MsF75hU7afLHNh0EivtWTu+
	uJMhKppsh+LAvx0Sgs1qCfRBNJ7vbi0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GImUOcTT;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789569745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lxpzvQmeX+96TUN7SXRVShfKK7cd6FDDcRBR2QQvHQ=;
	b=7IapBPSNb8WajznbmlUvLaae/fKzOb9zXP6teqDl5iSOId27GUIyx3P8LLM1mq8+SI8S7Y
	URDoFOUad14ZgDXfS8Zu5+nK56Kw2DQlCQlahMVvXORF5iCgLUhDP8BlIMj2RmtrFLuq2n
	p0BVorSMBCrkTEjLDBufQL/1DHT5cZM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A44096053A;
	Wed, 16 Sep 2026 14:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C741F000FF;
	Wed, 16 Sep 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789569744;
	bh=7lxpzvQmeX+96TUN7SXRVShfKK7cd6FDDcRBR2QQvHQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GImUOcTTdmH73GV6FMfXBPrOqOLW1yjuitOSO0V6zZ2x0EYo2GFZFMR9b9lWkq8D4
	 hlXJGDQoPPR2UJEl6c/tfNBffI9QQ5D+QSSkbXNa6567WuZcSo198YNjX//6OzOw0e
	 Xn5OcVrm+mB7wAEae2yUTyzEUEGYmbw/29oD0y+KAPDpkLhbva8Aamrs8lYHuMKrhO
	 1xW7tx3iDrgtUF+ghZ/Uz0TN3xlpLKEkusaB7KoXII0FU9+McLkvZ+ESICm86Vco8s
	 nU7zkTPR3Hnx8Z/HYomH+8Mh4VcQAiC6CxoTCWb9G6lF1DS9BSs2f9zAhRdCfe/Ltv
	 FD4W/mVXjFk0g==
Message-ID: <467b6599-b73a-4f58-a29a-b6c6d1ffc3a5@kernel.org>
Date: Wed, 16 Sep 2026 16:42:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/12] mm/huge_memory: zap deposited page tables after
 an RCU grace period
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
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
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
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
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911-rcu-pagetable-freeing-v3-1-7b8c86103821@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34F174000D
X-Stat-Signature: 4axh53nymmub6znd1ez9xxz54c438zqz
X-Rspam-User: 
X-HE-Tag: 1789569745-16484
X-HE-Meta: U2FsdGVkX186ZjvgPrFzAgA3YYRoAALQnwyVunGZMw8UiOCJzyJengkQpKdSHDiQHu0KFnUsoMopROZ/lM2DWtNZD6Tkfz2IUJLNI+vziB70am4lFvGRZQ/vpQBgZnTELBwvjQ7FMI7pVc1Pz0ouQfotuWIH1FRMZUr4e4aTig/mhRerczyGTwDJShbpZY70jHrr4MY7C75I/mhF65KOhCcQ4ZhMh4qPQjL9xezTpj4XslfnqZghyS1gttk/xHWPWNOvtTUv9sYKPB490ctBW36UGyTvN9mU5cC3XeVIGPfpHAcRiXo0MTUduyqxZAsdncd7VDnEUtEfHtflANQRqsAmivTZMtYSUR7s7U/zjCzQmv/6RuRv9V7ZpO1MFdbytph4oidaekYEgWijx/yfuzi8xx1aJi3pr8vjjH0XjepX6bMIzJRidOJP2T+FYeItPj60sTtf6beIORu5vOwlZIwO8cFLgtoZ89Bq0JitC63Qu0VTgGrOR1ajSST2JmTuVVI85vZgIGQ1MXyn3PR/6S474LWfiDS/k6ZSOZz1nVqJU2UlexaSrlBu0RDIENqlH/suL4qyDVzpFBsYTvD5gvWOXDp4R61pui38ZiFFYx5Mx4DalVZ0v+mfF+IZRi8G1sxPrU+6JX0KGpFUW3CrncLT+OSzikuGHuZcHlnYAn9iibrDe8c0qh2e7hn+B+1H33RVsim+MSiJIH9TzF4DH0/9zupKlPOcSiq8orx8XMBsDTx8wW81eZ5VctPXeNlE0QZrCeMrF921qEFe2RRuQVKD3jx+O5iDSm0KIuqdfgSj0zXyyEjH2TXuTV0A4QkAFfJ8gUfcsBvE7ncPItJwSkoH4bdKvrVrAVz/NvNQpinRSIn9yJ6LzEAlfrG3VA0F2puPlpILfifm9lbZyeiultBuDJrovZAYG/AoULLfyU8t6vI7VY9nggtJRQYnwqjy7N4Z++z1r3VcY7M2yp0
 ffn81/24
 DpgFpL+C8Av108ubV49pnvfDK7BnnsY6t3phjl5ctzBWNEWvIWN2lTvi9w7abZchD3W2vreiLk7BmUMgfi02AR69Dts+a2arOFKVerOCEt2SuQ65xlZAdThueEcEtis8cGSrzG1Z5HsSwCJwoTuDrvWHztpp1aLtWBFHku3PAgZJJaGi9xCtA1NuS6zw6KgRdXiKxwX3BQ+tibyGUBiBxVwqdhhkTsG3f2yDfDWDcaEf+8QGm6KyKuEPLDvui8wgwiCRmPApuoZCE/9BEE4HOfFj8POL1+qnc7u6lGAOz9dctK7snHVCO1PSEZ8JcZxmZMnV83EBO1ShPw0p/7s+3+NJ6+gQseMzUp3XX4h8J3boIhhnkhWCEOLYballoDOeuMMTj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 21:36, Lorenzo Stoakes (ARM) wrote:
> When an anonymous mapping is collapsed for THP, a PTE page table is
> 'deposited' with the installed PMD entry.

Right. Or when we allocate an anon THP.

> 
> This is done in order that a split can be performed without needing to
> allocate additional memory.
> 
> The freeing occurs in zap_deposited_table() and is done directly without
> any delay via pte_free().
> 
> This is currently not a problem as existing page table walks are protected
> by the mmap or anon rmap lock.

Or VMA lock?

> 
> However this becomes problematic in a future where RCU-only page table
> walkers exist, as there is nothing to prevent a page table walker that
> started the walk prior to collapse having its PTE table freed underneath
> it.


Wait, but wouldn't it be really problematic to punch a page table that is still
being walked into the deposited list where it can just be allocated from another
PMD->PTE split?

Note that pgtable_trans_huge_withdraw() just dequeues *some* PTE page table in
the list attached to the PMD table.

Something is odd here.

-- 
Cheers,

David

