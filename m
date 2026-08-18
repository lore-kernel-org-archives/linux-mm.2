Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F81C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276406B018F; Tue, 18 Aug 2026 09:50:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 227646B0190; Tue, 18 Aug 2026 09:50:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D046B0191; Tue, 18 Aug 2026 09:50:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4C5D6B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:50:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5ACBBA24D8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:50:04 +0000 (UTC)
X-FDA: 85114523928.07.5B2FDD9
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf07.hostedemail.com (Postfix) with ESMTP id BB3CE4000F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:50:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AWu/N5af";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787061002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IaouprFE3gLaAcaZfQa94G5GTC/A5IpSvvuNy2bdsRk=;
	b=djooeEIv9woU6sBcUTeVKJCwKFisYuMo0JxPSlLh150hAx7Ah2SFMeUmk5sC0iFdJNp9Bg
	qLHRakHiDIDqa+NPkp/IBMb5zoI7pdYaL6JNtpJ+Qa1HLWkgDWnyWBuQEFe8TPNJbTqUza
	T3woVwmgdd582ThPUhW6wXx3Pyvm4eQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AWu/N5af";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787061002;
	b=k2u8ZyLfexrBSz3dRT+saNlMuaawLg2ts4DRXATIwE9GWHS4WYCwVmSPhaVo/f5Qw8rrEb
	qdYJjtvbGa4HGjfxFAGwh8lBV9EvMgAg6ExeYo9OpmSFQgD7ucr0YUf9H2SZ/SoLL/NOH8
	WzriNjxHplB7i+II/wct3P7s/k0TwBM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KPnY0tQYP5AcqkJrwZ0WtXGocUVKhhxCQ9WVaistIKo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787060997; v=1; x=1787665797;
 b=AWu/N5afHuzi+EIoh8uxA7PTLI7wOpMA9/0c0OqBCE6QFcRuSpiK1EGrUOc4FqTl7KAwvu6F
 Sp+/l3MfQ0+OtuyppoKG/0M/G7h0VidMZEcHRbQKH8JzqFeZqI9o9QmciJa1ojDmeA4jAmLkNQp
 2JgrAw1t7bxeQrtV7h/sdSp0=
X-Envelope-To: linux-mm@kvack.org
Received: from .linux.dev (117.20.149.64)
	by smtp.migadu.com with ESMTPS id f87da00a7e642c61;
	Tue, 18 Aug 2026 13:49:57 +0000
X-Migadu-Flow: FLOW_OUT
From: Leon Hwang <leon.hwang@linux.dev>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	Leon Hwang <leon.hwang@linux.dev>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] mm: add cond_resched() to free_pud_range()
Date: Tue, 18 Aug 2026 21:49:34 +0800
Message-ID: <20260818134934.92354-1-leon.hwang@linux.dev>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BB3CE4000F
X-Rspamd-Server: rspam07
X-Stat-Signature: c9mjwu8nmq3xxikyeoms1g43phmj8ub1
X-HE-Tag: 1787061000-990931
X-HE-Meta: U2FsdGVkX19q6JWTXnYG8CPwFRx+LvbK+AbuJS+gwV1SD3kFaHd1vk/+7nWDxCC9MhMuaBEssaI+BTH3TDN+ObBPlT6CM2rCrjbvRyi0CYNjprYHgA7U7lgDpw6E0nOALievulMYCrWZBKGUfev2RQsKi7W5TVxuR+/XzfAU7NJe5QV0TBKnU6nLL/TnOGhb4I+SDcEnyMDTkCVdrfCFZY1fhIxe8KFB88UZUKnEEOu3oEk6BRI8eWk8n2Ob1cwNAch0bXl8yBfRvXrZq0RQav6bjlR2FpkPxXKIzsZBI2FGwjrv5lOQoTRiz/asWRAvODnwShSlDqac8uiJb7w+DN+mwJwdMMDfsZa0qCehv/YMbwFH6JCgMeqK50b0MUkBr9etin8PFQ019RLC5FGLPE3ei0IwWzwTLDeL92FDLZIs19xOjAr9v2vzaP9E3CLrgjMN6WFl7wkNQN0EpFd4LelJTgn8BzLRFeOphuXPVfyUthzQ0w7DHWe9B3wGMKEGxlUq8A3+wAM1YvmGqEgNVKFl/ingqmTxlkL1K8C6txP/9Msf5rBGsRPw9s0FXFPrG/22nTiid5JKVRtp9YmaxWYlSlL000JSceawX2e5KdNdXlEM8cr/KSUbbWT8E+d66NHkbbBedIGAbzuUFtqILu2t2A0n5wXoCgMgjPZYPKbge4adK1pQd/7TDvMftG4sesqNU6ar9CrW5f+7Z/IkE2SHKBSAFVN0x+jsvzU5UJ1K3tF/a6bR3MoVJEvn0IPg+Dot7O4RFBI/mNUCXmyFZVhAmdvXVfDgvoY47+kDh4HBTYLIGyuh0DcILs42ZN23+oZFX+Yf2gmoWPPOoLaiq3MihD5jeZxcLPZP/MT889k+ZLTZdFsfoX4uA2SLNsM4F+lBS3sXg0ajywVkM68dvbSXh13IsnyPwcX9SUpG4rVw/R+u3a+rx6vnPPPDMEPHjJjf19zZavOy07hl3kR
 eZe4tf4u
 hdIZwpLq0eCZA2kk+zQiwxbfP63JjDfeSVtoabQ0DETP3GKTNNF+ySjuLkHUYdXZAzVsBk6QBEnYKv8rYLkJS2ckDhgq+Eby7kOwdKJCXrd7sWDj4H07MHJRQQ82VAbYwnUiF5vIGRlwtb1S82pNMqlPhx5Vd5esDwEvjCs2/dsWUBVVmCszJ9ZWlmoh+kumqOykFoJutcgf2B4R8ShrSU0SQX0qMJOIPX6pQm1JjD3V2o0EwMbzApbq6vxnPKGouMmv+wBDi/IY+ijpkE1JF3whnPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Packet receive timeouts were seen in production. Tracing showed that an
exiting process with a sparse 2.5 TiB mapping could remain in kernel
context for over 20 ms without reaching a scheduling point while
freeing PTE page-table pages. Hard IRQs could still be handled, but the
per-CPU ksoftirqd thread and other runnable tasks could not run during
that interval, delaying NET_RX softirq work queued to ksoftirqd.

Like zap_pud_range(), add cond_resched() to free_pud_range() so
ksoftirqd and other runnable tasks can run between PUD entries. Testing
with PREEMPT_NONE showed that the maximum interval between scheduling
points fell from over 20 ms to below 2 ms.

Reported-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4134ac607ee0..68c15449de07 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -231,7 +231,7 @@ static inline void free_pud_range(struct mmu_gather *tlb, p4d_t *p4d,
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		free_pmd_range(tlb, pud, addr, next, floor, ceiling);
-	} while (pud++, addr = next, addr != end);
+	} while (pud++, cond_resched(), addr = next, addr != end);
 
 	start &= P4D_MASK;
 	if (start < floor)
-- 
2.55.0


