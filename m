Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49739CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 02:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4056B0005; Tue, 26 May 2026 22:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484BA6B008A; Tue, 26 May 2026 22:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BB06B008C; Tue, 26 May 2026 22:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C61C6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 22:57:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4D198D797
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:57:56 +0000 (UTC)
X-FDA: 84811690152.18.E5BE3F9
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4C10D14000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:57:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jRHumPzy;
	spf=pass (imf23.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779850675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OevDCY97IHfMWjohNiIYTqTRYr/bbPEe4iODaGzCseQ=;
	b=n3gmslwbc5xxlPE2w133UVO02BzDzsAC0nw0UPPPSzDpbCc0nTVV10K72qwoklK2LTte1R
	qkpsKDpDk66tnLLn41a9iSlD8cwYIdYwDzU3VFJGJYr8Tkp2U2JLLYzprtHCWc6QTsQ6ko
	bF5o3+I5j6Iy/Lbco8JziTh6054LlOA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jRHumPzy;
	spf=pass (imf23.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779850675; a=rsa-sha256;
	cv=none;
	b=stMch9BG5sh1TAdytc4PjC0POMH1vFE6n/4lZynnmNoEe6MIJRuNA4HRFgMG2cZ3P85Jox
	eJA8rKbfO3r+XfQRUQiOEn2k6CuGZI69yo+Pw/exKQzOgvEDM8I7/pzWzK8u3oToJRNPR7
	vveB/p78CuNdTVUaemJlb8uYL+bv4+I=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OevDCY97IHfMWjohNiIYTqTRYr/bbPEe4iODaGzCseQ=;
	b=jRHumPzyfWCCF+pN7RD25xUqbdZBtJrU/LkkjWSghE/SDZVDQJHA1uf8sTeQQJb+pPrrVIriv
	BHuldCsnAcyzX2PDcp0+sXpNTRAcEZ1GyfXFQmgDwVeRSRjpiwTtY+Ft4brF9v9wA+TktkA6SrK
	uso67IalMfYGi4RTYZwkOak=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gQDcX1Rg0z1cyQ9;
	Wed, 27 May 2026 10:50:04 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 70A6E40565;
	Wed, 27 May 2026 10:57:48 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 10:57:45 +0800
Message-ID: <9dbcf423-108b-40cd-80af-6b93f113599d@huawei.com>
Date: Wed, 27 May 2026 10:57:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable RFC v4 0/7] mm: add huge pfnmap support for
 remap_pfn_range()
To: Lorenzo Stoakes <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Juergen Gross
	<jgross@suse.com>, Jonathan Cameron <jic23@kernel.org>, Will Deacon
	<will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Peter Xu
	<peterx@redhat.com>, Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
	<hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, "Liam R . Howlett"
	<liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
References: <20260526145003.88445-1-yintirui@huawei.com>
 <ahW7rut_WP17KADW@lucifer>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <ahW7rut_WP17KADW@lucifer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: re8zpud1eojpeqa9qo1f6suqwy8inaub
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C10D14000A
X-HE-Tag: 1779850673-274971
X-HE-Meta: U2FsdGVkX19KP1Yi1qjiUaJiCN8kuODQiovBzTwV8IkDRnHrQZRXejUnPzD0oCmp21YLDjTR5UtqlLN06fW4hjJCTDgHSjls+F67s1IWZrrI6FfiXapd7rNSMcVKOWlxRBwzKF7Cd+0/3o2sNLWFwMV8mMMy6Adqx0mFFyhZMItMTS6ZgN3tcHdHvSFzeOSc9ccdRAwljk+khV4JWLQnnL/NLHZcoigid5NpoNe8wyWAvxcPGF/FRLC3mRb7e4boioJ/5gfLp9DC6u125D5qGQliVnu5i7BnJHjjsRB+lomglpyr67F5Wgs15IkBMQDcuaZ4mTedxYRwuH2qzRtfA4zI8a9TeQgHqigOVlbcXPjdVnyCuHDLPyA3lQGtaw3rzloVBFl6LRhRbdm+54uSeHN9S5NGXtnRVIztSBOXW3PgUNrGxvd7p0V3xbCRXE9yKU5c3nTw71VhYCFX2CoaTt33CDztUCTBCbwyc5NGwZuhcg4mY1ANrs3XJk6sVbZUYeJZ6JXJ/cMRXSNTpO9Cq8KHztHdoUMpnUKlh5Lms4g/ozNAXa4BMltBev/5pvORx8fGqOy3HWGLlheDpdj9cN7t9OVGtIgfWW95j1s0JPh2AiE+Ao3Y8ZHaS5euABHbD8iyTsSoxNtEFw4JDpqEgwksscIiOFLNQkniNQqgjxY4eiiEBm66CNw1yFIirKiStZ6Tcmt+C2f2Jva9bG9kXcbGHtUbgqYBRzHYQJqiJxoDkzzeeiML6RX3P4vb0gDc8BBZqosjgDGKSgS6ZEDGMbFk2MuQJUa/QlvAhdeCq/JfiwiqhSEDjHRIkh1xyP7Y3VOKEDZ9UjujMlDLQmw4uyKdYV6hxq8KK7wwQK0ujBupTGVOoWSrceTc0Hny0JXPoPXsRVtMz4b1cCA/sUHndZdRJkAMm/8SyMRL1qcPYzMI8tZhqQ0Hki4kRw9ZL0N3m6hOOMJ6kOJs1QknJCZ
 vizegxno
 1zBvt/SzvXSKVpyvaqEDbUuKDPzmgvSoMOwqzMOguQfnklxZrTM9XDCHqJDuun2vQD+Ddw9PpjuZGoXckACT9GJK+qUQuGHS8M7sCau2Jp5U2yUcImzdrHw+LjVROwj2+D2WzSmuvIL+MfFN2D5IeDMS1sZKRlQEXXAuwNeTmcI7bCmUSmwp6OLYQ73fpM2Cf2lI8OipF3aFostFeLrlKkhKZBnh4MQZQueCcXm4wpZlT/bz32dUgsMkX9ONPiPHe6mtjYvbpeEW3TLJ40KRrFWg1JEfmV8aHZGxMmqnbFyNj071PNHctXwqFamih9WwxtEREHLZAxRIJuWYB1ezsGPpulrwqtWMjeWtXtJ1PY0WDlqDmzqzwVnaFvYfjZN2NMhXIHBjsSeE4uxj5z94zPPfTwNTne+OhhQ0TNweHeUOtWfngXwQfiL0VnI1vu2SzZKyipcqaB0+yUA4t/vI3FarB2DhhS9jG8PYWgA6pckwjPsJ1xwYxAp4wDqxPnrWhTHZ2KXViA2Y7sYJRSOIPHjNc+djqQtYeLpWn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/26/2026 11:33 PM, Lorenzo Stoakes wrote:
> Allow me to be mildly pedantic (sorry :)
>
> One thing I'd like to highlight here is that remap_pfn_range() is, in the long
> run, deprecated.
>
> mmap_prepare callbacks will indicate a PFN remap mmap_action, which will do the
> heavy lifting (see [0]).

Thanks, I missed that mmap_action_remap() may also reach the same common 
PFN remap
path.

> So perhaps worth referring to 'PFN remapping' or something?
>
> (Since we already have mmap_prepare() in use, it's also kinda inaccurate to
> say remap_pfn_range() :)

Agreed, describing this as remap_pfn_range()support is indeed 
inaccurate. I'll reword it.

>
> [0]: https://www.kernel.org/doc/html/next/filesystems/mmap_prepare.html
>
> Sorry, this is pretty nitpicky :)
Not at all, this is really helpful.
>
> Cheers, Lorenzo
>
-- 
Yin Tirui


