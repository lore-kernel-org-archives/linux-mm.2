Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58A5D6406D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 04:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257C46B0005; Tue, 16 Dec 2025 23:14:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2057C6B0089; Tue, 16 Dec 2025 23:14:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E76D6B008A; Tue, 16 Dec 2025 23:14:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED5806B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:14:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 425485B704
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:14:08 +0000 (UTC)
X-FDA: 84227645376.01.E0D3C42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7B2F61A000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:14:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mObMGKaH;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765944846; a=rsa-sha256;
	cv=none;
	b=7Uoy6HlTiT7iUBgXXnNhegUQaScwL1T/JWKVEO8lwbkEDyEG29Uwj8uumrGjABX0HSFBCa
	KbEi9NUP787W+Lb/wKFPUB7mKQfGHcHucYE6o906JX4zGuciHGt1lvNqZKBrZq6SNLNeiK
	wX8YM+7Be0rhD8Ln7nZhJElBPcxnfqM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mObMGKaH;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765944846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIvslDrd3vRyKntdo1TKclAc08m0jxGuja83vYWFMz0=;
	b=bI5EnkdqYFdujvdlZTH7XVN6J8BMg5hd52uSVbKdwEuexXhXEpQEKjGX3U2Pb44QTB+feD
	kLQvhc776/qin+2uhMWEYwe/V+T6ujLZUxLQcWhF7RU7XkegARM0jro+AO0grfX7D2hNiW
	y6jmJ1oteTUaB6Dp3igfNuEld5Kmu7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07C734021D;
	Wed, 17 Dec 2025 04:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB41EC4CEFB;
	Wed, 17 Dec 2025 04:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765944844;
	bh=xU2trvapXnk7g5CtACkCj5ikoDQ/txcQUif1mO1cIY8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mObMGKaHzs+oIi98uFJNPKFjcIbwG14MyPdinNriP9aRfBOmrP9YgUR0U5RY50Jcg
	 MRZ/eN62bquBtMDDTcWo7ge5Ui+mwLmddzDbSz+GfDkXxY71DhMOB9iezvOgCfm+sh
	 F57lldv0D0XP5sN73LEmpLArzoS8Y23dHH7bFz7M=
Date: Tue, 16 Dec 2025 20:14:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alexander Gordeev
 <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, Anshuman
 Khandual <anshuman.khandual@arm.com>, Boris Ostrovsky
 <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>, Catalin
 Marinas <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn
 <jannh@google.com>, Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Peter Zijlstra
 <peterz@infradead.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Venkat Rao
 Bagalkote <venkat88@linux.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Will
 Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
Message-Id: <20251216201403.4647a4f9861d3122ee9e90d7@linux-foundation.org>
In-Reply-To: <20251215150323.2218608-15-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
	<20251215150323.2218608-15-kevin.brodsky@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B2F61A000C
X-Stat-Signature: qpcr8pzqxdwg7w7ghrceefpozhfpgif6
X-Rspam-User: 
X-HE-Tag: 1765944846-955370
X-HE-Meta: U2FsdGVkX189uHp4Y06fV4hBsWm7xbTnEly1/8LsTCM2yG0rOjeqdTEQThjl6EBzpI9M9Njrt/RUTka/txDnyeQ4Ndjzw8JbHZ5HVggw8o3I/g52m2jn5LgsIuj8ohCSZLqq0KQZibbPeagswjE/mryzyF20YJFcSNL66IYdQb6M5NK+kNqWOLayLViIIaNcSMtLi6AuFjxr5gcNAAvP0E++zSceXXoZQVPVNHvU9I6IRp0dK5JckqN2v+UDeeomEwF+Ez/LNHU3ke/KUKaA2gcKasJg+pMyqvmgQFb5HEV3q5IO4u94Eord+TsxRuBtgeZkdKc6p/nnwSDv4ngot1Q154ZvmZx/zFMVZpGxe5juj9gzwQvzMcgA5u+X+61TINuZIk6IsU0i0azkl9+PCLvW5SLkdFu7rjL3l264IZZlYkd3jIZkowc275b4dxJxH5XKGetmXZzOSOI6zFhSFW/mOoVZdM0ZEFh/emO+puJYdCWLv4bWdHafyZ8wCnAfnL+ow7jAg6TUmgTKAxX1Au0LyCwooV94lFbJA0oE3IEIQqkUszzeDv9EYOT/C4kT7J46ieEVX/Ht+ZdNQZDVchgWs50h9Kj0GX2SJYaPuhpvKKeYM5eyvMT8OtxWNWy1ybDWbqJIWuHS2LvCXpzdCWSMcO8W9WhdIjiOE5L+T1YNn9WIj4kDnk9GPRV166lochkAIjyi/QGdyqmCNX8a5FbMqtoBtVNNfwZ5QozvqgGg9c2/+/oni/CJiR/9oxcD8ifhPdJbFPG4XZkyIgm1Syn/jCmYQ0FM05AM3urpshoan8UN1FMWtL67AeMcnBFgwdmA0ZyX6/zApD3Ob42SnrD/s/T2rz4gtrcO5ZwR5WVfA8YghWshltk3q5dFIMm4gR08d9jzAo8eQJ6qoICvJ5JJ/m1CLyhdJ5as6SxDnGpZ4BcfsJtveKxiZihSMun0gcOX8fxUA2CXEWqsr8C
 1/RWPrqL
 DpkGvW8ZTLLEE/MH8nL7RGltha9mWx8KV2GTOHaKY2RO17S6Mq9KTRr6GCLFDtkinDku29PK6oWfjfQdjiaqRqBK/CPi5vSs/qs9fePX3Q8CKAbil0fWVp2UpINMXnGuSGWncpicVyrCVEFW2uB9MDN9YIpwYbFVlK9IG9ESbvaPc/5hUiCWLQrn1Xmh6H62JttDG8CTkRvwRRFKKR90+xiMQVA17eC52tGDCoqKFELDPxyB5YwL0lo48C7vdyJ9jq1UKeRWm01xZ31ThkSI1E9EOH5DxK0FNCObQPAx9vR0pCa0b0mc8wSr8uu4rk/jRSEvRl0i1XahNa8CJwzF+DvpuBQhiLQIk9GJ3ionpOOJUq/bnoS/4BFbcsHp+UDAitRLZwacq4EvjilQz2TRFYs0U2pGUiYoAJKE+UtSTjD4usOQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 15:03:23 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> Add basic KUnit tests for the generic aspects of the lazy MMU mode:
> ensure that it appears active when it should, depending on how
> enable/disable and pause/resume pairs are nested.

I needed this for powerpc allmodconfig;

--- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix
+++ a/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -30,6 +30,7 @@
 #include <trace/events/thp.h>
 
 DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
+EXPORT_SYMBOL_GPL(ppc64_tlb_batch);
 
 /*
  * A linux PTE was changed and the corresponding hash table entry
@@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
 		flush_hash_range(i, local);
 	batch->index = 0;
 }
+EXPORT_SYMBOL_GPL(__flush_tlb_pending);
 
 void hash__tlb_flush(struct mmu_gather *tlb)
 {
_


