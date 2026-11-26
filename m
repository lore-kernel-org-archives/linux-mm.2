Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5132E606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJyTKMIe
Received: by kanga.kvack.org (Postfix)
	id 69A3C6B05B5; Thu, 26 Nov 2026 06:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623C36B05B6; Thu, 26 Nov 2026 06:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC596B05B7; Thu, 26 Nov 2026 06:14:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1D2C6B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:14:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DF35403D6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:14:48 +0000 (UTC)
X-FDA: 85477012656.18.BF75AF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A04D1100002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:14:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJyTKMIe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691686;
	b=rOAbFaf0uuxGvfaUZyMDZKB5CtC/NgnT4ryoI8tGf0IAI9VPID4L/9OU3zDlTWhBdGbQnr
	Y2oRr8p3rnJBa/JNQVyJ2E/0t6cNR1IXTjTSDFQpJKjKN5BvhwRKPb+wFWjTxPl02lECOV
	wnGPlb40MPsiEGoeUuCOmQITx2HzzAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zAN299vizOOPECPls5C9ly2hX7A6i/wCUYEhdWTrYE=;
	b=8YGX+MBQqm9AUieA+yZWd1mFtV8Zq8QDqhId2EeW8YBONU9vPi/yF+GcLCMvUPG/pTih2M
	cFLbSyG+m5xepcX2iWRUupyXaB12btL5YgeaDXJi8zzYAAS5odsN7ssmM/hflhVQg73EgL
	8AuhWOpf8KOETZr77KZZybcIftpQvYA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJyTKMIe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FFB943B27;
	Thu, 26 Nov 2026 11:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488AA1F000C4;
	Thu, 26 Nov 2026 11:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691684;
	bh=+zAN299vizOOPECPls5C9ly2hX7A6i/wCUYEhdWTrYE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kJyTKMIef9KUJ7TrzxTw1NFRlFaRrs8sShSVVpag23heJBC0+PbBRsR1oW1Wkkfe3
	 /BEDq5VE3iJDg9scZN+INRUCab6B1pQg4aSTRrJ64C0kKSQyJj5olaROHEH5iUjs+j
	 8wKpdu+jFo2YDtHGgaZw4V+6poffdw5Oag7Yqa5qdXG3V3GPOwPnZgPhV6dXf9v76W
	 Sb0W8VbJ3BmR3nLdG+OyaPztr9yMUdYv/loapVRW0yE+e+WYmM44YbzJciMR6VYcE8
	 wGiDHGR3bmNJb9AN7Zbx5mEvbwquRTkTxaAYZtEGd9VyUgt5DRG8mbCQoHnOAjKSOb
	 +bMedTT8QILgA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:14 +0200
Subject: [PATCH RFC v2 01/54] riscv: do not use P4D entries for the linear
 mapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-1-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A04D1100002
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: wb3yc11rc7nu6t4kbt17695o7p7gd7hh
X-HE-Tag: 1795691686-514232
X-HE-Meta: U2FsdGVkX1+JbLOEJWRCZ1o2JYPmT2g122Fv+eQWxgN567EbrQFThuhQOXEedNqQ8OkgkKzfn9Wvc2Cy75OpLhSVe3+1HheuzQpw2QoKMI7w7JJu0Ov2Do+wWHJtp1Nk223ZRJf/J7VmL6hkCcM5FhHvmg/Wcu1N56TiSPV6Hk7cIBPlFPSw9gVAuSHnYkuPGL2bsVdQjLh95gIl8rfs+28jQiKz+ZEBIK3EE0N06C5DAmef3Ube3Aniv46HemOms5CYYKo/tcmboqxUSYp1VoEEkdK6RFNNNNFReyy/iiCuuArDUcF9EWks7vZ8VpcjJnKzXXyyY1H0A9JIDTzpVU0FFPNoQK1Um53h0Y/jLxC1tYfs6Xyx3vEkXV2/J3RZGMaadsgsM4TBYZVQCnqNOUluhS0cAT3z818gJzjNpUwj5fO0+jSSv5YJliEmeTm1jlDmWLO5/PkIRyErsgCM2YcneRaTdI1d5lQj9HztJfNS2BxLxpPQxohGkeAjt8BjKY7Grns9zszdWq+VYYP5f4j4XV8yaf5R2T8qRumVAMCSc7JFAI1hewQKM6KDCRgj15iHo5rCrIE6nKb+Z7xGPmI8VLnq6yARHnIFQwQ0x7RdwE0o6ZijHQuLqNE6Zp2YRCkFiwtaZPJ8ch1E+HHOYIrRwBn0xVvTkNrr5+KCXvUx3atcUx8O9uRg5z0fipJgfLEAR5btZ4xkFqgkbmGedltjL+va5W9jJQlW1vPFtnBJSB4HuTfNvnH9ORiHV8p6BkKt89D8SM8ZCy9m9Y1i7QL5mxuCzr/rGgcQTDfLgNH84+QjxpYBL3gxWhHkxjfFfPljKlPmaJFb4+8P7v9apZvGsbiL1JppiXC8sn9qtQ0+cKDLkMVaJYzbBW8I0WXiKD7q4sjFlzp7NB58LPdknL0Oz8AGVJB0X80BJMDEWuzh+f56uGNvARxIZXX/ttl8S19bpm4y7USvXOiAfQJ
 32Adm47o
 ZSUeui0PfyoILmz6Eb8oG8nrnBOB7hcvddrqOkZ0f2uAL4LLYQIjj3xyd6EDSG9EC6a7WeBbDvMTy5zqtUwbtnGvFGmO7fH0gM3L6AcvQyhyN5p5Ga5zXP11yAxa6k9Mqm8GMckmqm3ipQJ1pSVLnZskWL450GcKUo0y9uBdNcrQ+Udi1AJ/4l2n5KoeTJzjKxO9PsmpXStphUp9YqFu1waFPseqsxlUUdpLjl2L6R9YtwztNytP4qPN7LQZ0L65WIlBOgBDLnIE+kyAzONQU0kbpNKpkgbTJjYFHrkQ6vpMzA1fTQTA83SkXVH47TzGXDMP8DSeRUVKjKmpBMJu1p+iEZpUzNRcllFgvs8mQ57PaaXwoDh/sN5i9qVhK24HY6VXNFQcFxdjURBXFZvYEe0nRurl1kOXUU0INcFfZZWc9PUx14QD5EP12ThdCjE1rTUVG49Pw2UQqOpvIr4p6aec51ypeaOmeZYS2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The linear map uses P4D sized leaves with Sv57 since commit 3335068f8721
("riscv: Use PUD/P4D/PGD pages for the linear mapping"), but riscv has no
p4d_leaf() and the generic stub returns false.

As a result, kernel page table walks treat P4D leaves as tables and wrongly
descend to lower levels. This affects the split in set_memory_*(),
kernel_page_present(), ptdump and the hibernation page table copy.

Stop creating P4D leaves rather than teaching every walker about them, as
commit 629db01c64ff ("riscv: Don't use PGD entries for the linear mapping")
did for PGD leaves.

Fixes: 3335068f8721 ("riscv: Use PUD/P4D/PGD pages for the linear mapping")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/riscv/mm/init.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 070ee69eabb3..e1bcc3a16129 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -717,10 +717,6 @@ static uintptr_t __meminit best_map_size(phys_addr_t pa, uintptr_t va, phys_addr
 	if (debug_pagealloc_enabled())
 		return PAGE_SIZE;
 
-	if (pgtable_l5_enabled() &&
-	    !(pa & (P4D_SIZE - 1)) && !(va & (P4D_SIZE - 1)) && size >= P4D_SIZE)
-		return P4D_SIZE;
-
 	if (pgtable_l4_enabled() &&
 	    !(pa & (PUD_SIZE - 1)) && !(va & (PUD_SIZE - 1)) && size >= PUD_SIZE)
 		return PUD_SIZE;

-- 
2.53.0


