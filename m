Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E4DEE49BD
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 05:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD6E6B0088; Wed, 31 Dec 2025 00:57:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A547D6B0089; Wed, 31 Dec 2025 00:57:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E4A6B008A; Wed, 31 Dec 2025 00:57:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83A916B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 00:57:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBC39B992F
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:57:58 +0000 (UTC)
X-FDA: 84278710236.25.A8019C6
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
	by imf27.hostedemail.com (Postfix) with ESMTP id A3FCA40003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:57:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of yangqixiao@inspur.com designates 210.51.26.146 as permitted sender) smtp.mailfrom=yangqixiao@inspur.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767160677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=6OJSJ1HNsNhSF727gzC3ohRmni4cBuj9xASashfNLV4=;
	b=TbAs2KWEHIHi7216Vfnw1S6IK92MCA/cV0l/rK18FWSqWj55IHKNwPIxHRfYYUpWWHCwia
	0m6sXUDG2/j1IlaAV8pICZyolA6jZcqoJ4s5/DY0ilIlrinzhgzQKz5GdRFpZi50c8uYhy
	rX1s5JYItAqYXWec4h+8cZ7z07NWLVQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yangqixiao@inspur.com designates 210.51.26.146 as permitted sender) smtp.mailfrom=yangqixiao@inspur.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767160677; a=rsa-sha256;
	cv=none;
	b=XxJhyVBEi5EmwSGMGa3ez/pJThiqU48u4PTU/0waNnpYfzchHSXL5r/9gAnEhJkt97r6+b
	SSPiQb+m1bE0KHE0MIO/qZKB5vXV7QcEidw1ZQt19zBPVaKpPgSUSNmv+CEE5RN7r9EgzK
	+3lV3qtIOGjshr1aTjebz49qSL7aTbs=
Received: from inspur.com
        by unicom146.biz-email.net ((D)) with ESMTP id 202512311357429743
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 13:57:42 +0800
Received: from anolis.. (unknown [10.94.11.57])
	by app9 (Coremail) with SMTP id cQJkCsDwbvhWu1RpD60NAA--.27572S2;
	Wed, 31 Dec 2025 13:57:43 +0800 (CST)
From: Aaron Yang <yangqixiao@inspur.com>
To: sj@kernel.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	Aaron Yang <yangqixiao@inspur.com>
Subject: [PATCH v1] mm/damon/pa: initialize 'folio' to NULL to prevent use of uninitialized value
Date: Wed, 31 Dec 2025 13:57:37 +0800
Message-ID: <20251231055737.73325-1-yangqixiao@inspur.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cQJkCsDwbvhWu1RpD60NAA--.27572S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KFy7Kw4UGFykuFWrKFWfZrb_yoW8Ww4xp3
	WxG34kKrWUtrWkuw1DXF4xZry5u3y3GF9IkFWfGFyvkanIqw1kKw12y3Waqr1UZrWUWF1f
	Zr40q3y7XFn8CaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkm14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
	6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUehL0UUUUU
X-CM-SenderInfo: 51dqw15l0lt0o6lq211xuou0bp/
tUid: 202512311357424a74c73258332d6bb6c345215257ab0e
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Stat-Signature: 1u65npmjo3oajc9qee35s8gs8rcepoz8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3FCA40003
X-HE-Tag: 1767160674-218631
X-HE-Meta: U2FsdGVkX19AiSwEmvMy0NzBAX9ez6x1hfSTWkABcGOmatcFXvS7i7r9EFD1ggfhR8ffozL69RzOaGSnlvgQwEi/5nkaO+pJvMyYB7IpOYxObHqU5sh66k3iYc1yh8dt02lkrYArlDjQg9ox7i5M5jeWu9hAw/iB2IKk+O03OYeuba4HZpmZCSlNBzuLVRNoWKMoBpaf6qhHScUhaDyQvIhG53RzN7+bXMmOiyDfr096Ox818QINoyn/q6vklu9aA0YgMaz7HMUEfb3OzyRRDtaYwgTCnkL4M37vGnx5eQlTV3sMjU1A7S2sRsfhkEaVk2vtwScSEQFPl5hGlIy3URSGwRxiUZgHELiNGU78xTkNBSavOjO/iEo1Myn0fZbx5kLe3YyEVLim5xc1rbFAx/uVpKglXhD7aT7GiiE7vAjk9ORwMQRA/duNUVD9MSaKahkZx1lIvt+yaLtMxQCT+G8/tSvJ/2Ne5O1cL2eNYSj3B7f3TSKylrd+Fo0BG/Mk6jcfWJ/Nrp9bG8V8Y8brrpWc2YVA+Z5+j+VXa3u2zeOBAVZr5woftw2FdR4Pd8qdexDevCxibVXQKx+23i+GGf9iRtlkqo0jl7rvAynSi6/5FZes3BvYmBGKAzf0fUVgUlCb91RBmT0qIG1FLUkEZv+Vqbx3ZI/SvDtnWoTJwXXtbzaQ75DZZyZD3T+dNBSEPHioXaZriyzPoMv3V6aXrlDUXm4f3nzemYfdGdqVdD4ji+GPZ5t4XNkUOtekd9nHC8AwGw3/iW4veEP+SkRJyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In damon_pa_mark_accessed_or_deactivate(), the local variable 'folio'
is declared but not initialized. If the region [r->ar.start, r->ar.end)
is empty or invalid such that the while-loop body is never entered,
'folio' retains an indeterminate (garbage) value. The function then
unconditionally assigns this uninitialized pointer to s->last_applied
(line 239), resulting in undefined behavior. Subsequent dereference or
folio_put() on s->last_applied may cause crashes or memory corruption.

Although DAMON regions are typically non-empty, zero-length regions
can arise during region merging/splitting or due to address unit
alignment — making this path reachable in practice.

Fix by initializing 'folio' to NULL. Assigning NULL to s->last_applied
is safe and semantically correct: it cleanly indicates "no folio was
processed in this invocation", and callers are expected to check for
NULL before use (as per common kernel practice).

No functional change for non-empty regions; only hardens error/edge
case handling.

Signed-off-by: Aaron Yang <yangqixiao@inspur.com>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 07a8aead439e..32d8024d130e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -212,7 +212,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr, applied = 0;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
-- 
2.47.3


