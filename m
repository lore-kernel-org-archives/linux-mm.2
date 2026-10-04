Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28735CA5FEF
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 03:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68DEE6B0092; Sat,  3 Oct 2026 23:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DB36B0093; Sat,  3 Oct 2026 23:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D636B0095; Sat,  3 Oct 2026 23:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300D56B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:09:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A932280A75
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 03:08:59 +0000 (UTC)
X-FDA: 85283461998.14.A62CC10
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf28.hostedemail.com (Postfix) with ESMTP id 818E8C0002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 03:08:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tE8PCqW3;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791083338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qEAQVhGIu/KdJWgG4IC6BLnMeKjIo2284f9Lvg4wtU=;
	b=Iv9OtCH6lbO+ijzt2WdSRDwvfA6p/OJ91jjRiBVPmp5MK2IZjAeWebz4rGFf+XeZdeK/Hi
	cmN8EF3ZnbpI2o0qubOhYkAPbBqPc+MxxSo0bt9/FKlyYpIRmISpGbMCEHoEStDD5uMAMl
	rqxyfQMhy/4mSBHbl8kAZQNibFyrmHk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tE8PCqW3;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791083338;
	b=OUfSy8QNK3kRA6tvw3DIb7U3XAeMb95yjWm0jgc8NpEioZpX0u4cGJst7ymrOC1H4ThRa5
	IkeETIzZBasYS7epFYHGnnauWnOU7h6ZZYt5aZy36VrfbWCvs0v0vE3FI/INDNodAz9bNb
	ZyTmZQKZw3l7OSJGyV0oCrBqn5bFTjM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Zp+qhYqMQRqCv6BwNrcY760zp89XnNnv158s2z7q+38=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791083336; v=1; x=1791688136;
 b=tE8PCqW39VFf9eNWbocwa/um4Qf9yGxhM6PKF4E+5H50qOTkOHvDGBO9BC1Z2tSHmCpIBaAV
 b8vUmp/pUcZ2nvj4a+giBDlnFopW6tClAxLbWO+GZk3jtv/xGHdWFaveU25kcK2GI+ancW3v/be
 vFeIGkE6zAX9A+fELraecCyw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5eb3b10a722064f6;
	Sun, 04 Oct 2026 03:08:55 +0000
X-Mizu-Trace-ID: 5eb3b10a722064f6
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 00/30] mm: PMD-level swap entries for anonymous THPs
Date: Sun,  4 Oct 2026 11:08:44 +0800
Message-ID: <20261004030844.90483-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gkgyya6fr9frctarncg4w1udu59szdk5
X-Rspamd-Queue-Id: 818E8C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791083337-118713
X-HE-Meta: U2FsdGVkX18Qw154zamdOOSZfGOi+PpdmU08VrvdnLAANsKDY+BgBEEFltW3ij516W3R7oNqHqrJCyQKwRzvCMqSVAFYaxEih5GZaRlpBo7Lwb7G5lK5uhFWHVZ/x24Ejo9fF6tZigSEz46hsYnOK0u2y+KAFpJPhtmu4cKJeVW9qzSeKtPybEFY2SRKiz/A2cJEIqRtO1rqw0gh3L4K+Rb+tcmVgOAMfXAFmE4ywZZW5E69YNqg/COdGxAdllUz5JiPtEVxLze9AaB88hLQKrskObI1KkTZGxwaXJrKWKnQbfV3scDXB1CRDvOlGcmmtpKj5fCk5flYf/IxTkDeqIZmwPYHhs37YOclWIafNI4JsWYitrnP6nV+X0RGVyGN2xpTF1sIYJG0VvJODk7Z5886scUxTF1pNQi7VJSbJOxF5alzfcSUYMEvsRCOSN1lG5bWu7nXV9cqh0z/3eMEWu36ALs+i2FQ/4AzCubstrW4mXHRs95RZET7C166rKyKcDkP49T01l8+HiqQO/y0RHSwDS8gS6RyBcItu/ki1zIfyNbBefFAdAGjxdSHEmaApd3miyLHRWK8LPohJneBMJUN5WoYaPsmW/Z4UloO6OIbBo7GRqw6gt9C2UU/DZA23cqbyerQQhCgKT4wFwHGsgQ6ybynxH6H/j5xKGwqT4Kv37gRdjCnOt6FrZCt0VtHv4jFI7s/m7AafPsptvWINZqxvbYAvDOUr9WJLJVA2r980BP2bOiri3DnkT3gDqxfQsoM98hQMn3PZmX1mluyaFefhYlT3Fs126JSbWUrEiSo0kr69CgQusjDqIN0e7JR9SeOm50srnlJJv3Wbf7H6pqF2DvozhdPTVYdu1+OsFaOQVRcgTtVOQpPzgnTIdtPXmkIk1xsta7Bxx+8nW6jHgHwmUrXGicLNo5kZNjlEEcEWFfq2o+kvZx1JNwWGvXzuoAxcWbVJNEzh4NgiCS
 pj8qRCY2
 1ORMzBJ4sCsD3PQCYezi6sHOjSVch8WFcXN9Y459vGfNCVUybUgvoKcxaMsXa8dewHEHRljdq37RrhJuKwy1UFbB+BpP3QGYxtI9fMxxRXV712mCbh2R/JlQna3nSw1a9+xWo4EdX8XX7chmXvI0UOy8Vng3lkDClYALKhATZ7SV8+ZgJleA4Ohngb1F1AAWMwjf3Ujk6NzI5RBtAckLyks8dogqEH2Wx0/pwP81XxdLDu4h7eSAw2Hl6MrodcjboeEHv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Usama,

Staring at the swap-entry bits across architectures, and RISC-V looks a
bit off in that regard ...

With Svrsw60t59b and CONFIG_MEM_SOFT_DIRTY=y, setting swap soft-dirty also
sets _PAGE_EXEC. A migration PMD then looks present ... so the fault
handler skips the migration wait :(

And yeah, this is a pre-existing bug. I've sent a separate fix for it.

https://lore.kernel.org/linux-mm/20261004030312.90163-1-lance.yang@linux.dev/

BTW, could we also add more checks to pmd_leaf_soft_dirty_tests() so we
catch this kind of issue early? Setting a swap flag shouldn't make a
non-present PMD present, IIUC.

---8<---
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 863111c6d4eb..80686e2baaa1 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -762,7 +762,9 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 	WARN_ON(!pmd_is_huge(pmd));
 	WARN_ON(!pmd_is_valid_softleaf(pmd));

-	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
+	pmd = pmd_swp_mksoft_dirty(pmd);
+	WARN_ON(!pmd_swp_soft_dirty(pmd));
+	WARN_ON(pmd_present(pmd));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
--

[...]

Cheers, Lance

