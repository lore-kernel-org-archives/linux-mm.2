Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E8F51049515
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD396B0089; Wed, 11 Mar 2026 05:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CF06B008C; Wed, 11 Mar 2026 05:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145106B0092; Wed, 11 Mar 2026 05:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7B626B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:20:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98A4C1B8871
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:20:31 +0000 (UTC)
X-FDA: 84533236662.17.C515697
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B6B30A0004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:20:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UNr8gI0S;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773220829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVWRqFzLUnoGwGbaRrq1u921035ZV5YkTsGPPJzAwyk=;
	b=kfEqAErroFQ1AJsGZ940LT/9Irl8AcbbWkwHy7+ZmTRRLz74IQJ6gyis+o8AeQoMe38bBI
	J3VylfpbNEmblNaQevxwSTX5/ZynzdFaNenilQTyc8KZz6vxUilb+PduTDYkCX0ve1QC2T
	nQdJkR+fuiKs6XTqafy4PSipY6i6vvc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UNr8gI0S;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773220829; a=rsa-sha256;
	cv=none;
	b=dxGCUaz9E4VeHPDF6lv+I7cZgqo1I6c4Odo3U4Cv9e3sQLboTbUqq+L7J53TfZa/4RPVEG
	7Jx5mtDM6ISi7f4905sDSD2xg3oPoYZvtu6xijLuMx3B/NzVXLdRF5EvxyEPE3eLXOGNL5
	KNT6zbWoZ5tCmVuN7Cu/B5tYW84BLmo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A86F543F11;
	Wed, 11 Mar 2026 09:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1923C4CEF7;
	Wed, 11 Mar 2026 09:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773220828;
	bh=JpypEF1J5OgRJiCd/MihIRnK/CNO9ssCWYiKbHTS/ro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UNr8gI0SByGHmNtlUSwlW+rMeQgLKwbKy37F7Orbw5cWliVwlEh9uriCZXl35osx4
	 Gw/7mXt+rvp3qbR1zONjRRSPW1LQcMXs1I3jF7fvjSRRFECl6QESr5xFHbldEjXoBK
	 xzePRByzI3h9l9oF4gdxDX88nnD21W8X4ZZ9iq5eZsEt8l+SW02ToX5cRCuG9EpAVy
	 TDnxPmjMA3KczLO+KXtYlACtFf7fJ5Z7eOttw+nFSb/RzNIKLXmsDlW8uqwHDPrtPp
	 LeqCp9BSEiV8ut8oRObfPr4IIizsaEgqT3OXxVjiF2mqYoDhInBziLF3PchK1zUQTI
	 FP9g9QL+vFfMw==
Message-ID: <f7732d1c-0e85-4a14-948a-912c417018b5@kernel.org>
Date: Wed, 11 Mar 2026 10:20:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/16] mm/memory: inline unmap_page_range() into
 __zap_vma_range()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, "linux-mm @ kvack . org"
 <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>,
 Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Eric Dumazet <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-12-david@kernel.org>
 <a5765cac-69d6-4314-82d5-80ee363906de@lucifer.local>
 <bc5cfcc4-5e51-4da1-9ce9-ea0831bec400@kernel.org>
 <737a88b8-8221-44e6-aa90-3be326bc8612@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <737a88b8-8221-44e6-aa90-3be326bc8612@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B6B30A0004
X-Rspamd-Server: rspam08
X-Stat-Signature: 5h8twj815ip3ytyxocr3zd6ag8kckhwm
X-HE-Tag: 1773220829-95316
X-HE-Meta: U2FsdGVkX1+tUoS+RpowzOaofclr+8EgCrS6+x8ESoP9ZEJjVgjHAidfz170lYG0jjUrKf3U6IF6ujXvX8+uo65SsOayy0zaoGeMgC0Eef55cB46Km/WXkhMnzoWz0mIYVzng9upugpfJ52RxnW0YpiqFRe9YK2FvllGfML3KF8/Uc6Uf9xk7e9OZyuFlpLpGYjf0bv2EUtXRao6xxJF/MbBaUNaWUJpcsL2lN4YnNkOFiGjOtT2Pdxyvs3S0T76NNjjXBMiFq2r+/A7ve353q7Ld/wRWfOroBQUe2Vo9LmG+6BJNTav+86SK/k0NtCxM75G7P9zHncgpIKdHhiszVtzJco3jIqU+zTIfx4hjhlJhqsPEsilFpbkLQOYi5DHjDqpq328gpPhROEt+Ap6Ferf1nW9iZE+SkTSNTmuK+tBo/By6l7JXzpOuJE6Oz9VhA1n6DP+f/9LygrBkWtvS1Jfg7tElN/eOko2eL5sMYqGJchJghapF9oHdncGX3LGqduZBXTVAIZ/RjA2vDW7cxjcDrQMP96UJqVZBosOZhN9hytdcWF6nCOAXQN+ub6GcEq2M3ByOtlz1g9IsiRaxHvUj5HXlyKQUtw7vdv/IcKKfjFQwuoneX6fvc1kkJxKmmcx62XnkVVJ+WdH1BDTcOnXX+SNmiwmcsz9+viOdjFgirF00mzJnB/VS5Fk/CT/Fd3gAKj89sx8+9SMxBwmcrqi9TQVgloIkKVA8YOHbp+Dq0/5xz0p8w1zjhD8zCUDcc8ZjyK8wgGvh810RKsWVdQq92uRBwh3wFyWL/ILXvv0v7g+R9rVoUkaD+jtLOlVF/JFLD5gPmviesISK8AoA1tBgRT2pzfRBDLlcTxKJ+Live4QJAkwwxRWPrJ1IVG6CFDKZtIjKyQfQxaoDaq1iF8BMu26LeaksCpNWUpXs43ueKy+0qOgDUSYeU425VzoI20G/tzks1WbXxlgcJh
 lC1ic+lx
 gyp1AHlCC9xq25tWKIcjQ80gk6CnfMZPlcpA9frrElqjQU2snIj1CwF98epc37y14u0lmOP8Yd9NUog11BrXGuVXKvzFMMAzjDfmGcRljvupvpL0mLnEBCNlFk/3ZhpfuFp2SKd/BZ8hkC9BeB9sEgl3avczyW90phxPaD/P3et3qBLLZlCk7tKrHBaGcjdAeBFjRRK9Qa2nT1gc7bS17p6QLJnnYDGc4GZLtwBuCE9Ez1ZGWkmLsRdExEVh7Vuf+ClzKDiD39+HRgRvvAmJ0gojQ/k/3lxEp2U4Qt/akZskoeCvAcwD/xt7spSzfqOba7sqenIRyspPGlY8Tn2RP22dkZ0xXfotKrauIZmOaGPy8voY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Tells me that "cur" is rather common.
>>
>>> It's not a big deal, but why not addr?
>>
>> Good question, I can just do that. :)
> 
> Thanks!


@Andrew, the following fixup on top

From 8470e94c57b89819753c8f31e23320f33c14cd58 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 11 Mar 2026 10:19:00 +0100
Subject: [PATCH] fixup: mm/memory: inline unmap_page_range() into
 __zap_vma_range()

Let's call the local variable simply "addr".

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1c0bcdfc73b7..5f7607140de1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2081,17 +2081,17 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			return;
 		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
 	} else {
-		unsigned long next, cur = start;
+		unsigned long next, addr = start;
 		pgd_t *pgd;
 
 		tlb_start_vma(tlb, vma);
-		pgd = pgd_offset(vma->vm_mm, cur);
+		pgd = pgd_offset(vma->vm_mm, addr);
 		do {
-			next = pgd_addr_end(cur, end);
+			next = pgd_addr_end(addr, end);
 			if (pgd_none_or_clear_bad(pgd))
 				continue;
-			next = zap_p4d_range(tlb, vma, pgd, cur, next, details);
-		} while (pgd++, cur = next, cur != end);
+			next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
+		} while (pgd++, addr = next, addr != end);
 		tlb_end_vma(tlb, vma);
 	}
 }
-- 
2.43.0


-- 
Cheers,

David

