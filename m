Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D9AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5896B00C0; Fri,  3 Jul 2026 08:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D856B00C1; Fri,  3 Jul 2026 08:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4DC6B00C2; Fri,  3 Jul 2026 08:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 854376B00C0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFE051689E4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:29 +0000 (UTC)
X-FDA: 84947403618.01.EAEA988
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 41211C000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CLGhL+SE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 32qtHaggKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32qtHaggKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081948;
	b=SxnMeT49WAMx9axqcUCM9/gF3fYURR3TCNvknjY+a3+LDdhtrQx+BnnihC1lWUdfvlqgpa
	ua84yQmhld9G294aKfvx8lDAPGasmykTR8d3kjAA0GcxgBE1eMNZfUa0u4O4gQIaZLUirH
	N9otHEccQ097MyLCsxvrgulDUCAZOO8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSxEwrSlsWzCUsFCp9f9B1Fd4DZM61HmbiQS7KAxRp8=;
	b=nNpup2JrStaL7Fkncn0bBMdOkvvfEEOEdBamBNU5KdqobloX0gJLsBe5VQe42AwHJbsLtE
	X3zbzHf7LrHmCL3Nb/YB24eSMdGFhdGEAjF0+CNmn0HPNijmdhvBv1cOH1EKGRtLr7fYvU
	RRn1RuV3FIyN1I9bJtytRr4NIjBAfxQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CLGhL+SE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 32qtHaggKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32qtHaggKCKkSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-47499916233so95640f8f.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081947; x=1783686747; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSxEwrSlsWzCUsFCp9f9B1Fd4DZM61HmbiQS7KAxRp8=;
        b=CLGhL+SEDG1mY3JsEaMMCnEleGq2qwYiZxoSu7CqzmCuK66fmXOjUiK9zYbnKngyRj
         xaY/AeJAJoQjUmxvcQJ6sIA9DwADdPgrXGgcDW5Dy3cyfwouXnRpToITM8OhDolwmwcL
         7GMsaNBmfCqze7a+gK3Z3rGSO2QlAz7SkX1e2PWgx+MZ7koHlNIEns/Cic32AEG6jWV6
         lUwwzR+TKzPJVWmp8DgTaXsbOuzNhjM6isw4SSXR0Da+FbAyqGLh5nm7FqUyWgaQk9JK
         hXP2A8yZrf/ZQji3ewjVEn6Ef8XgPKzD0dtgAR9r+f67SCJDxVTL7a2wFyaaBwttgkEn
         u7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081947; x=1783686747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSxEwrSlsWzCUsFCp9f9B1Fd4DZM61HmbiQS7KAxRp8=;
        b=ip/yjoq2Fm5FxhshtkpsCBQI/516zQkRAexVZyxpCynaqJ0w8Lb6EYx3TIDlocZfTw
         aWsWqkxg70eDnXljOZabsl+obr69VDiqwmCHaryGWaBIAt0XIhIj8sctu+ru4r3I7DQy
         Z0U4bFOtUARbzgRAB+YROUpzY35EepHRtd9nOO6uI8z1fWIU3yZRj/Ot4pv/6Pdjz2Al
         wyREJWmAzvWm6OGjf7j1UBRGQPBc8HRvrGhfEKBON3zeEfyGrN/6pPttjhQeHuK1m0oU
         zWqv3cCGiplFXvYKH0YZU24HJ+uDwfes+jFrDRxAWYIJWGoZMZaPQpEL9UYkZ2R/2xEP
         8c0g==
X-Forwarded-Encrypted: i=1; AHgh+Rr27wQcaGUWEYtoGDQq2JBOtP+36yFDAZgvQOND32nr9/CVorBM31y5CB2hcpRzoE4MtJ9947rlyg==@kvack.org
X-Gm-Message-State: AOJu0YxPklDjbOp68kFOp3xUqQBr/zSswhy8fNVirtydoRMgokSEORGx
	nJOMDQPMUN6KVZ5anz/VLu2fHTqyiu2DNUFFLfB4hlh2rb4adJMILO8Q0wtC7xhjRTlN5XQZ7qA
	igm6p0sir/nYILQ==
X-Received: from wrbfi5.prod.google.com ([2002:a05:6000:4405:b0:463:60a:d024])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d0a:0:b0:473:506a:e47c with SMTP id ffacd0b85a97d-4775a7cda27mr16629163f8f.26.1783081946118;
 Fri, 03 Jul 2026 05:32:26 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:46 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-6-c87b714e19d3@google.com>
Subject: [PATCH v5 06/18] mm/page_alloc: relax GFP WARN in nolock allocs
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: csoant69essir4odjxspow4k63q7n4by
X-Rspamd-Queue-Id: 41211C000B
X-HE-Tag: 1783081948-460037
X-HE-Meta: U2FsdGVkX1/39aVr7HV1IlDVa8pdVMqCpxzjOrh4Ib33F3QsRkt4E74EBotkN7ycQjtDf7FlJI5CcDkIvs1NjodyiIFxfIJA92bNtF8MxL2sGQOnKr8BpXt8WiXle3xJCMN1D8r7RfsAa6w+HWfbQpQARxz9+H3Ct6vUkQvBKh7uoNgSwRoCEg+/VJJ+qgrkI20YaoGLJow2D+FaE4olTRs/zepknCXaxeFGPb06RUQR0KU0VF3D0UuNGTXGmvw/5u6pflowuUf7AemrkX2iK8SZmHrRf4p+6DFadNqOmPOhWuN1J5JTDOtlI15AVXE1DRaYqzUe6PMT3nOQNM4N8pcTM2iyre2NYdWp+x9eFu/VwZyTI24hCRHoZe3T/YiLrNLeOLVE37sNI5f9e3yDa/2FggI6UYrqMd4LgG4DFIx6rkcLUT742tyv/EZJx/PNz/cwMWq3QfIfgVZsy9M1CE/CgX+T5Drf7rQ/I7n0q6tFmlMiw34IZQDiUjIMu9fQwoZBUlFfdO6dTEy5ury90IXUR2TxFmL1BPNtl0z2D/N29dpMWqWnxjVQeT6iAdgLz9y+LVIToL2vfv0rRDU8MmK0VaEee7hIHA2jRF+AtsiJFwlQ5OYwJW+hS8Gde/Lqmj8nSsEGQb3jYyyoVBlLTkG4PUo+t2GueQK1PoctO6buvrHa94dMJ31svKM8x4HFG51EUwdMbKaRAQ+i4gLBs6L7z37gb8YMbGPegpfYBtdQLqoMJpmRPE5qwxsrdiEQBBTnCwBlqWGpoxHf8XZAaEwHBi6eQqos2cl13cyI8g5ZcQ5cBRGYWQvD7EOykm7cTc8ZuG4T+mVx8JbBzFVGFIz2Ymd1BH6aD40GCKoBpCJ18DMxeWf1RlP0i/HcdBWWdmmz4wc7x9jrb9wcZ25MwCRgSPxnIceC8BsgTug/Gr4xafoOf/qiWetFbLx8rYaZb4QQE7rncB95eR7ikDe
 1stbi05M
 JwUqguxXiUnS/AFBjw8Ye4P15A+iy2Vgf0cvG8VU8NBbcyoyRnKKXMFNgq1Y9wxXOctIwM1u8Lq5+nTQhnZff9E7e8CexlYbC5N2jygMzc0IrgDQ+JqikoyIfY5dIixVpiLjSgWHCsfHBxmhCgHTffsO8iZnnnV+Df4vqrMcR5FneZVS9+a62ut+ym/8mveGZYLr8mavmrv5WQ+dSCmW0lwuWbIG4scvZhQ+kAVbebfo3XgeuIY13OREGlrOJZBGZwNqrAFOnJT97nHojxHnqdbh2y8Ps3srsxv3fu8Q1TtWbpfBOM5Yn0JYbsL8ZD1QSU2AF5y4wajPjTT14R55gZKkimO8l0TkK+UHHkpePv64nNtH6EJUACwEk6DkP4Ub7F0UuqMguByxWSvrZJ5ve52i8dtVgiZ5ybU9tLwYg1/Nj8ixHoxWFDMwoEPoyXXkuwFHF4t0jBZjsOexNvyl7KH5LtvSGH8evlX9U8c1mtGGCiRWLQgJQr5F6AZ5bAEKwevF6zyn/LWLeKWotkZOGT0mFeHZ/YmLQW6vCJAho9n3lDLWOu9CldJ3/aNu2uPFSQfYPTSDhgzZS/M28Nd385qhBdr0mmFtYh0fpZi7Ma9g8zjSfYQ+JxfNgY/LmV7kgQmqANjd27kKByCKJJrgTlQljm5dWYcqHDCr3IpIUByCpftfjIy3o+7yvDFrtt5xFwUfKHyr5qjPegklenu8Mp+LHtOcEAFZKMomLpIe1ey/mtvG7960WXhw1omoRxnNKm/hd59Dv4Tm57P4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This WARN forbids setting other flags than __GFP_ACCOUNT but we
unconditionally set the ones in gfp_nolock so they are certainly fine
for the caller to set.

There are other GFP flags that are almost certainly fine to set here;
Willy noted GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE and GFP_HARDWALL. But,
nolock allocation is rather special, so be conservative to try and
ensure we have a chance to think carefully before nontrivial new
usecases arise.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/linux-mm/ajS96fWbG4dzP3u3@casper.infradead.org/
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f47a848555077..c2839959d7908 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5355,7 +5355,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		return NULL;
 
 	if (alloc_flags & ALLOC_NOLOCK) {
-		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
+		/* Certain other flags could be supported later if needed. */
+		VM_WARN_ON_ONCE(gfp & ~(__GFP_ACCOUNT | gfp_nolock));
 		if (!alloc_nolock_allowed())
 			return NULL;
 		gfp |= gfp_nolock;

-- 
2.54.0


