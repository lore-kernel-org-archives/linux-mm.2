Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520EF1099B41
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95966B00DF; Fri, 20 Mar 2026 18:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CD46B00E2; Fri, 20 Mar 2026 18:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAAEC6B00E3; Fri, 20 Mar 2026 18:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97DE66B00DF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6364B1B7B6D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:03 +0000 (UTC)
X-FDA: 84567845166.03.6BF046B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C55EB80003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/uB2w7D";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2dYd1Esmr7zz0j2jla0IIVHfnreMBmG+4nWX8l/9Jk=;
	b=yXc8fBQTFvTkbcmIn76kuI+OhA4qKKcITdeQNP/s8JMwsbKIh4mNzffPI5cW6hGrDWzI5J
	IzsMRjuVfgvxdnEnliJGINTErMQKbmN6Kgj4rY5L4b3Y2F86GW+vc5oFLrr+JPh3lHaYCn
	N9G4UF1Laldc3E3YfLL0eQ6+kihl5bk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/uB2w7D";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044841; a=rsa-sha256;
	cv=none;
	b=6uJP8JtHnj3RnsOyfSqakhNn4pISfQbCRMDSeIwnfJKD6ArLOPQRUZkMWYTrAe55+o7M4K
	7B6sZwl9cg2PllNmXYpOYp+3rEnvSLdNoIc8iFaaupOp+qvbCSbdZRXrwyBtER6a/VjpWr
	jpWnMjyU8nO6idD5NVgoJznH3zeJTgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1777460142;
	Fri, 20 Mar 2026 22:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BC5C2BC87;
	Fri, 20 Mar 2026 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044840;
	bh=mvXhiGTn6tZZYnNOOoiRbg2GgcaMPiyLXwyjxmdxo84=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=X/uB2w7DSbxaqWWZI0SFouAEqRYt5ziW1QewNaYsFL+YJCSIra6vwkHxw1G9GGCh4
	 BIg7cd7GsHXYGOKUNs0MzTHjHG60jQ69wHz78GZiVzLl9CYVKK8mKlaJBjYPupxasS
	 g+bH6a1n9UMg+IiOGJihFzUSK7KfYpQoRfoiR5xltvNtvoFnAacVxiUXKk85xWL8c9
	 muE+/XC1RcriPyCEgQuzM4jbHkE9K1Cv3yzKRDknP/UJEsuMIMFvejFsVGjnmVpp4O
	 pbmnmWeUm1R8FQmqFTejFLSSs151sXs6nnngVkaakFF4+Yn2aN1kiPBhn3e/pwFWuy
	 w+3VzFUlJqhAg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:36 +0100
Subject: [PATCH v2 04/15] mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on
 CONFIG_SPARSEMEM_VMEMMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-4-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: C55EB80003
X-Rspamd-Server: rspam08
X-Stat-Signature: q96pe7sa9odknz5ixtrkfgaomb4pae17
X-HE-Tag: 1774044841-365625
X-HE-Meta: U2FsdGVkX1/B9v0J/ubRayMq67By3F38/F2SSMr2v0WKpDGVP7TKJ5aekkL+REVxJ/Z9s8zWJQMQT5JUld01TrYXCQwh0jJXPMDLM7RIa75arjhNjCjJ4+Bgh4iPYkKIUIYp5eyBHuhocGkzqx1+QQgwXwwM2geClqgs6M9deEEstx+8d0RbickYuL4NoGFDlViZGW2TklXxg9nktJ4za8GPex585TKR24/rQvFqX5Y1j5764WSJqfEutmK5/7YMr933vMGwsgI2cIQQ9RM5Ez3GaGzrSDN7Ijdi6FPOUdn7hyEs9E2yKgrJsq0YI4TsJA5Dwt9zsQnElycO3x+ktlAZbJBOpjxd/MQXBrPGPaSTAg0gYGNm1bKcmBGV50Ll/rgdNatbHQ/blLIXO6ZEPIzjYIjXxE4QuTxfGz0fTiVeIpeeDsP+NB1zPLNHtG/6mHaAitwMdueSNpemY/OmTEbOcJocDoKoqiTmrRtWrvgzODYag1y9TKojy1yszWpk+/RMYMO6e3iH9BEeUCxZaYG6JIjIENCpGxtrSYgoHDtRQPKuZ40C4joSOt+8yZx5bpAe9iHzQjJxUGPpsqJIUvY4oIzzlyVLuwwu/FEaH0nKU6xFkGEuW3VcOxquQlT/Yo5JgNhmDLaMg/c52oscS9HfG3Tm037dnMebN15dV2tNDuNlCzCGOuiTCe6Oil2yLGDk18IUsRzGfEhXLctYbga3kXQffjwdO02Br3AUZYK0vvmsAoPvYbrkXK2fs4iDq+046+jbJUBbXbH3aDrFEkaqLdeyHC4L4R1/OfgfgNv47vGnUFsaJaT/oW7Pmp4k59ba3d6pHhABNP9wFccIqNBlrsVaOK0YxnSg4wj1UZQb0ISC36sosXwiXqClV9F9Xp9sQ4P2LYayp4tN3dP7mTcK0+5NoQTmR/0d/+YFoL2iCOQX7vMU/NzagoDWFuw3u3duusCKdcdIC27J2pX
 TdDQHQlA
 gYANyhHb3W5QmDxo4Oyrt+4MmGOFFNzwv3qopyMSIe/cHGa/RwPvlXaXIEirvuWNqk/JmJP2ba1MmguIEXG6hfphbTrHrIP1ZaEO7fgMMspFM6BZACkDBw93VzTMg8trdzlJTfSYAGeekHwpsoKKyTUuPzTGJuCU1CTHuOivOeurdk5ZuSzv1S3obPBa2GuJyC419mDfHY/D54CEvaFvyE6sCyL60s/QDzPCpNCVr2JUY9yZq0n2/Psxhcg2y0Cu2B94B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit f8f03eb5f0f9 ("mm: stop making SPARSEMEM_VMEMMAP
user-selectable"), an architecture that supports CONFIG_SPARSEMEM_VMEMMAP
(by selecting SPARSEMEM_VMEMMAP_ENABLE) can no longer enable
CONFIG_SPARSEMEM without CONFIG_SPARSEMEM_VMEMMAP.

Right now, CONFIG_MEMORY_HOTPLUG is guarded by CONFIG_SPARSEMEM.

However, CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG is only enabled by
* arm64: which selects SPARSEMEM_VMEMMAP_ENABLE
* loongarch: which selects SPARSEMEM_VMEMMAP_ENABLE
* powerpc (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
* riscv (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
* s390 with SPARSEMEM: which selects SPARSEMEM_VMEMMAP_ENABLE
* x86 (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE

So, we can make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
without affecting any setups.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..c012944938a7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -472,7 +472,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
 menuconfig MEMORY_HOTPLUG
 	bool "Memory hotplug"
 	select MEMORY_ISOLATION
-	depends on SPARSEMEM
+	depends on SPARSEMEM_VMEMMAP
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on 64BIT
 	select NUMA_KEEP_MEMINFO if NUMA

-- 
2.43.0


