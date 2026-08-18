Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA9AC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35FBA6B026E; Tue, 18 Aug 2026 06:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338126B0280; Tue, 18 Aug 2026 06:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24FFE6B0286; Tue, 18 Aug 2026 06:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2FA46B026E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:58:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73ED4A38E6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:58:08 +0000 (UTC)
X-FDA: 85114090656.05.7E233F2
Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74963100009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:58:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W3gWg80l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787050686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olJ6zlGKO4Jvnbtl+1LnszRH44Q4D0La/kTP3ky6LNk=;
	b=69MtH2dXJjEpZMxOFVThbckwkPBMWokMeY6QaKx8bzemNL7mmbaESu8m+crtbE/McxvsJI
	BY7hylru5FTgXIRLRQfMYPNCMJMGyHyo5/YX0SCqh/VLGRMU2f6IutC0jRhQTxBxX7rfwU
	74ol745b8+RBXNBNZXiAiNIDeW++ypQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W3gWg80l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787050686;
	b=RJXCYNuAl6b9bF0cu5CW6P1bKjhfI8FjsGpDRc/LMMR4rwCa4Cg/KJPBPvbtLA0w62x5GS
	Evj28xCIqq0HBWC9AVMLCJabNi1qJPkBc3uf7xwgtk5ME25+8pcEWDlmG1rtbmT+ffaL33
	3OAaboDy8Qo/mtW9OPei1umQ4UiUAJ8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=olJ6zlGKO4Jvnbtl+1LnszRH44Q4D0La/kTP3ky6LNk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787050685; v=1; x=1787655485;
 b=W3gWg80lZaGrkbqiNtMNLqd9YkEkAHo7K4H9VsO9mNjuxVpIyD4CqpAC0mr9N9XwuEIkVkT8
 RK5KI5Ym6M4ADmCCGpkdspGbpg00mbdwE91VAbR1DHeU/hxmV5pa8Oy8aMRoeYxhxShFRbkiZDW
 AOSgHP1Auhvmwbhl6iI+QFX8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a02:168:f6cc:0:a69a:f3a4:8fdd:3332)
	by smtp.migadu.com with ESMTPS id d4297f5cac7e4cb7;
	Tue, 18 Aug 2026 10:58:04 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Aug 2026 12:58:03 +0200
Message-Id: <DKS0LIEA23TT.12IKTM5M3I01M@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 19/26] mm/page_alloc: rename ALLOC_NON_BLOCK back to
 _HARDER
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-19-6f5729aa9832@google.com>
 <ee8df643-91dc-4a38-a676-486a0d52c919@kernel.org>
 <anJc8Ansf-QWFfFo@google.com> <DKONM2LHEP8I.1PW06S1B3CDC7@linux.dev>
 <aoOqd8Th9dhx2bjT@google.com>
In-Reply-To: <aoOqd8Th9dhx2bjT@google.com>
X-Stat-Signature: py6jgy6ua6mo1m8ynozakojdt99x53df
X-Rspamd-Queue-Id: 74963100009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787050686-101227
X-HE-Meta: U2FsdGVkX18ttahjH4CvLvEXx63rA4xEhCdRWMMc9aTmmpEUqTHnriJLZTC9KlLXUW5/zVKUwC0b9KWLlTFY1Q2uYDWIgPOxICnLXu7EeoUvXnOa2v2eoS0ReW4d6KIxy02q1upRJMahuZ9X865j5Db5uuW0k9nkN78XGapHDnsihA0B5ktyqajHEoNFq8NrkujUyODXZ55mqb7EKU7CE8mh9AKHNJwctQ2l2e1F3TjVTtk3beSgg6gUddLFNnc1B4n3FaqnQKEXbCmw8ewMe8PYMflQgRSWuELLaBejPf0mLNpHgJpcYnhpA5ltNNubS8eWrnW/OrbEBMH0dXxk4/omCPNYAApvI87BbmH0wzs6GgUVu9vss44pRhIIq+tbIfnSyOWWMxYIsItXy1OdSLFzTxW2HMqTig1s+6gyYA5pktG5nGT63NzFGlZdKGZK5yf6LoiWq3YVwhblwYKxGWIJG+WG/9mkjHKYSrIUk8tqW0mqYlCLBbrCIb+QPbDvlly53EfIerXhf9udHr489Gbz5Xx+Vf49ER1Hf3CqaE2uq3JdvClj8iWGGAqkmpSApk+InHHoBEI+YrP/KZLWR64v/+jkAIR0fxmP/K8eJgtQigLPgWJORrEj6Y/WRBZ0e7/M+BuyzAABJXLSVBG8A4EuAYKXDd+CEXqtABBlVDUHOT+gx7CwEniWPc7DEpFK03c+jMn1lVbHf6f8ZV4e8zzrtkMlaiI1w4boRALIIsMU5WXuXoqxdxvNkmmaFan7W+wuaP0HrHGr/9HnZqSPBoP9AIoAi8Ne2Rsrmnlp9LshJR4pn+IdvN2jcz2F5gM/SPDCaGFkdfAeYIBR8/Bpt2wRK8xOXFpPqEOWJLsrT6v/uiC/skLhtzqq6jnzOyyq4SLO7/pHAOPQ4wKCuqLJxrWcIX8Qsn3qr9LuX/CP+Bc/Mj+Cuom7Iwe5licdyo/wS5sjj2DHd2dADpRQW0P
 MG+WA/uv
 iUIiznMcR70JPEOFWUvZkt2ql9c2CCId6r0qIaRXmL9z15MjOgqLGp0HT7n1eQLoeBrD8WhDu4onjmt1cxiTHItf4/H4XrqzNRvAULfnuZuqhCn8onJVK0/fXBptS26wK6UgFM0k8sXlwF4BKY634awYGze0PeCQmqKTci3q5p/7sjl0M7a/wX1SiEAPCajwSiiA8vJ5wGjXi2QerpebnQ9sausMp0HtjM+qDarTfulLV+Meoc/6MfcHBoJSFZvPwlOkY5XeCnPguF6kLA9sU7HKcAf2e6CKlFoJ1zTJEDPuDR+DabVgf4wjMX19R/yhDMlG/Vw7VRQbYwGAt71IdHPBKYBXZdcHwIrAn1dEZAw1MK1Nf/daFTRLQwouBgeyREjtN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 18, 2026 at 2:45 AM CEST, Yosry Ahmed wrote:
> On Fri, Aug 14, 2026 at 01:09:32PM +0100, Brendan Jackman wrote:
>> On Tue Aug 4, 2026 at 10:50 PM BST, Yosry Ahmed wrote:
>> > On Fri, Jul 31, 2026 at 04:52:59PM +0200, Vlastimil Babka (SUSE) wrote=
:
>> >> On 7/27/26 00:22, Brendan Jackman wrote:
>> >> > Commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HI=
GH
>> >> > non-blocking allocations accesses reserves") renamed ALLOC_HARDER t=
o
>> >> > ALLOC_NON_BLOCK because the former is "a vague description".
>> >> >=20
>> >> > However, vagueness is accurate here, this is a vague flag. It is no=
t set
>> >> > for __GFP_NOMEMALLOC. It doesn't really mean "allocate without bloc=
king"
>> >> > but rather "allow dipping into atomic reserves, _because_ of the ne=
ed
>> >> > not to block".
>> >> >=20
>> >> > A later commit will need an alloc flag that really means "don't blo=
ck
>> >> > here", so go back to the flag's old name and update the commentary
>> >> > to try and give it a slightly clearer meaning.
>> >> >=20
>> >> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>=20
>> Writing this to get it clear in my head, so I'll also dump it in the
>> mail in case it helps get us on the same page...=20
>>=20
>> What we actually want here is a flag that tells us when we can do a TLB
>> shootdown. That means (on x86) that IRQs must be on and we mustn't be
>> holding some random spinlock (most spinlocks would actually be fine but
>> I think it's simpler to assume we can't hold any).=20
>>=20
>> It must never be over-permissive i.e. tell us we can do a TLB flush
>> when we can't. It's fine to _sometimes_ be over-restrictive i.e. tell us
>> we can't do a TLB flush when we can, but if it always forbids flushing
>> while GFP_BOOT_MASK is in effect then we'll fail critical allocations
>> and crash.
>
> Why is it a problem if it forbids flushing while GFP_BOOT_MASK is in
> effect? We should change gfp_allowed_mask before any unmapped
> allocations are possible, right?

Hm, good point... I don't remember why this was a problem. It certainly
seems like it shoudl be OK for secretmem and guest_memfd.

