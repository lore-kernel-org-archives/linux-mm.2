Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA1F606A329
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dgm6ni1b
Received: by kanga.kvack.org (Postfix)
	id 7122B6B05C1; Thu, 26 Nov 2026 06:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E94C6B05C2; Thu, 26 Nov 2026 06:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF786B05C3; Thu, 26 Nov 2026 06:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0BE46B05C1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:15:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85EEF1403E9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:43 +0000 (UTC)
X-FDA: 85477014966.11.6A39E69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1D7D180010
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgm6ni1b;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691741;
	b=OzwJ1xTegavvHezGsBGr/NKNyyfBrdg7ZYPo4pBVFm99Nb9tHT/mxMVF1GefvD/9ebZeHG
	SiM/zJC5OerGllsYeXEgi/5YutlKzKl33v+4z9RFLXyCJcp1TLY/DCFcauzsKBv1Le8uBJ
	iuEPXIodRwA6Md5EBQDtgEtDTsvf1Ac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nf8Dg1I8n4rgs3e9w7cnbg/z5iiBQqzebLGhMMMtmX4=;
	b=cfAHUfX1Zjw2ruEi+GPhapUa0E1fwc+XQoNvm16o0zlyEain3YByIZ37SrgvMIPalNbBFn
	J5KWh29Qq4J950mpE3l8ehSLZYUd7fxooo+mNWrcQDtJgJcaRvG3VaDs4Mm1tdn+G5ydgx
	N3M4oRa9Ir7gjVB5yjwR8gyle4ImrcI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dgm6ni1b;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2761740DD0;
	Thu, 26 Nov 2026 11:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AD91F000CA;
	Thu, 26 Nov 2026 11:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691740;
	bh=nf8Dg1I8n4rgs3e9w7cnbg/z5iiBQqzebLGhMMMtmX4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dgm6ni1b4ATvsu8fOCDBBMC4Gh77ed8M4GQRbcomJQs08awcbabF4eaq9qmXy0gqg
	 JJvtmZ6YrX89lCG0g6pPuy/2dFSN9kOM6Gz56GcV7TnzjNyrWyS3PFur8FPZpE2ffJ
	 2PgnJyOJTT0Z8ORoOShyglFN4IjkQlALevS2VfUB8S9Zi/qhrGyEus3D7slbTIChIB
	 T2YrCvr7+p4qI96CGgok8isNnhQgrbn9k9y9zWEv2CeyRtTpAMgS4KW/4gxjfHZ5iO
	 2mcAZCh8kqAsGsfpbwo1eszlrG4UjdQZeusc0Ba1auKtD460X+FDVjWIcghsrzOaJg
	 GkQEntGvSaGjg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:20 +0200
Subject: [PATCH RFC v2 07/54] x86/mm/pat: drop KERN_WARNING from the WARN()
 in __cpa_process_fault()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-7-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1D7D180010
X-Rspam-User:
X-Stat-Signature: 1upjzbjiq6pqymc3c3aji8joer7be3bk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691741-510601
X-HE-Meta: U2FsdGVkX1/bIT2Xr6SkMRhNxCMTlSFch62LbQ0X2iqc+oqotWfu+DFLvmHEH7Qaq8oEEvxd6o83fqjHD9LfUXghWg5tdnNbkFQc9ieUVDj5SRXPiqRN9Ah2JGKIPI+QkFX8fJ6YdtF2PxuGmw8791fmVS/ns1jle9IFmW/1vT0g9XXFUGK7LiRq2yTjdcqrxt4QrCs4gup6dcQUV49vYwBXb6zdtEpUhlWPAMDUcsiePh5NqwTECfq6O1LlgNcaGMPahAX1JDlxGpupfCDeXISI64mZJNxwX/bt2fahX40VqDjcD3xltNXlHHExe1OWcZ93RHIycg4nPycFkBOF2q0agH90VH6aUIJJXp9lROzq8GOiyYqLkXoQxj7elnjHuUkZzIP4/gwS8/PGboe+z8j22kVorrkGXFq0f4xZlvz8Je0WHCh3PDyeqQd3WR5seEbeBZ62tztqe8FM/oqQHO3AXPWwDQKk+9tDhfpR6Prp24X3/Kr98yicGZo1DSV8Gh8Eg1Dqx4/eFgex+DvVNQKHVih9kTDhJioG4Yw/6YPeQbAe4dti1+FYM6Vpw4GrAOVuQ6HTvG/+gnUn62bGpP0Q247zLfpN322PEdgmB3FWUg3dzdDl1aYOXdkqrbC5THDo+go0dV9bnJjmgNT9TGs6V8HvmtA1u7ByiiuIK1DkAndlCklz34SNENp2kS22iWCzkiF8P8E3+gBPuD+ZS8hWKa8806NYyiNMxHP9363QVGqfUUqChnnU/Q8AtmXfbcGOaVd9vBLL2RdmQR2WaSrCRVi8B5baVEnYSZm5gfGcXTn/L9XiXNvMCL+0T2iANmEuz11H8L1vyJzq3qzXAcViJAfKAbuMF2DLubSUS28WCnC0jNVGQh/bZK51eJJr9UXcpKQWTP0clHiOoZCMGmTJDR/i3twecxwCryn2aI8Uq9FB3c3Sx7hngubhWJSEpa1iiUBDXKntN/HtKG5
 GILyXx2v
 fxlPRT6zVz9Ap3w2GJBLA4UiboVBIWXVz5zDmfXuYI4WLHPq/1QHxIIxgzIUCHnj6vhjjA1oNgwhtsd7sLSQ32gjot9vbSmELggw63tFyOOYG+q7PXHVkBYW+x7QeAoMXUcUAaCQnh7FObXX31Js6Ttdb9vmP0iaAsIH/Q8zZxulXMKCUFqhdQM9KL8IvFN21zy3OnAyMrbfwxU0pojgTw0ZUPFD8Kwx+eODd5L3Eyh3rPDFU0SJyV6Zyqzjr7ce4SnKj/DLjeYhYW5FpuYSEXfenG+UKmsAAZAWAgga4Imt/Y30Q17D98KxTdpWRccQ+ESDTZoLllIglSl/elDF1VfNOu7AEUp+BUsGTynKaMvZrdC0V6YGT4a3NnlSxy2AKhcXBrPhaYzBWfvueQOf5UAivU/6POncx+GinmbZlP1CFmtWgKPAnHU5GyQpDgY9iqgpiMFOPVq6TYy7E/EKqp5LHrZcNzlkSPWm4dqjGZ7Ogjl27UFIUzpqavFgx8cthGlWZOyBgM2AYFXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

WARN() prints its message at the warning level, so the KERN_WARNING in the
format string is redundant.

Drop it.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 42f27d60adf3..db41f94f2355 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1835,7 +1835,7 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 		/* Faults in the highmap are OK, so do not warn: */
 		return -EFAULT;
 	} else {
-		WARN(1, KERN_WARNING "CPA: called for zero pte. "
+		WARN(1, "CPA: called for zero pte. "
 			"vaddr = %lx cpa->addr = %lx\n", vaddr,
 			cpa->addr);
 

-- 
2.53.0


