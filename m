Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB6A103E162
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68276B0172; Wed, 18 Mar 2026 06:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E188F6B0174; Wed, 18 Mar 2026 06:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2E5B6B0175; Wed, 18 Mar 2026 06:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2BF66B0172
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:58:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D6DE59CF3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:58:58 +0000 (UTC)
X-FDA: 84558886356.06.930D1F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 50E4C20005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:58:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pcCtAXo9;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCYUk5kHzwVrneMFO2DR59QD+1jmDCykkPv1b8HhVv4=;
	b=Hl9UYFO0LI3MJcSoDm35qAXj2NTx70aNtFJMW4B3fx0iZmvxo9ZTx+k8jCArfC9BK0ZnXZ
	rDNwKUHJueKLkihFEkz9KZfXMROkrW5W8G81Kddp73ZzG7MsjtRTUlRKPDyhrrmXb0JWJi
	y2OHMhiCi2gYSx17GLKFzvzcK4Q9cjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831536; a=rsa-sha256;
	cv=none;
	b=dI4IgsT0Ixe3fnqmhgtW5I3rQszaiES7I2cproftXRjS/f4OssbgFCRXX7qZh6Dp3OeajG
	eQliSdn9urmYL2NHHiBLd01GOAnh83XGQqu4wacaGkNUaFgDh8GdOwupHKOoUfnN/2DIBQ
	drpjFKpvBoIZmstHABBNPJKkE6sm43w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pcCtAXo9;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A06A4474E;
	Wed, 18 Mar 2026 10:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C28CC19424;
	Wed, 18 Mar 2026 10:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831532;
	bh=Xt2trVGOu+O7P4h2C+N66P7rMFK2F5qGGY0Nx9maAnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcCtAXo9HFjeLmxxQDz1bWFGhGz3cgAlZqqVZqUib3biO4lA09lDRUAnvR7VPd8xK
	 xud5VSvoOVpP/uusVxy/mEj9ZPuFa9FBiEZXenJRIhcJDaFVEfdONJUF/a5DeLxg/6
	 9eJWF8V9iJtWLHumgV17GT6fy0gRDiS3mfXFa5ikPxnCcIM5ggnEsU6yokHlyO3U1v
	 z1M3PIiEZAT6J/8aMQ7R2ZMjIU13s+SJp+4B5zRJ5Z2M0LcqXMaYHaFCkfTXOiu6r5
	 wdkBq5ZN/Uu4ADC4SCCEps0JuPHvaJpv8CueQ5TFX51Ua5WHxeubzTq7aqhN6Hf77n
	 s2wD6ho9PQsRQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 1/8] powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
Date: Wed, 18 Mar 2026 12:58:20 +0200
Message-ID: <20260318105827.1358927-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p8upyam5pa7z18bcyeairy9hkp175fd4
X-Rspam-User: 
X-Rspamd-Queue-Id: 50E4C20005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773831536-497258
X-HE-Meta: U2FsdGVkX19oB3rEoWCdzMQA1VgEhrXqya0LoVRW4Tdrt25WEekEM/VMX8mW7iKQWUiLDeSzSr2VR+LOa5p1VXOJ0mm2w0Aiok7VrssbLXU1C0jMgvlfUxudFv8Y5l2DEwKizZQKJaJKbcVeDrsKPNU4xVv90Qcp3XyrV7pSBSL4ahpe2nf2PSDz14CYQ83fLhkBTzu344c9UB7l6jNQ9ImbOPw2WdKVtw9Gb5pfIFNnld34ejP79kqSERXzlcjtpjI3rrgbA8WYXCkRJq7KOF+Ve5vS8dWw02m5XG43lksWv634/HEMIAiv1itPiQsQBE29Oj+5B0rRthJMOYSYnSGNdv6E1OVeyUiJIa7q2K8BUKqWRLSlvGeeiYoZIuAKlNkTBntcmPzHsh7P01OppFAM1WDsR36IPTLNNI8MOvQL4ucECawmfAjfCJK3l/KbFKy8hIa1FuHpQ8FEg3oxF+mhitUVbTdXKBhmW/jo6l9KtYdi1Z4O7BaOBvDNinfKSKmjy7LFNl5ToBmxL+wPmEjt7aLzsQI1ZrywzeZIxdBq3truzl8xoSEfNUYGpbX/MxvyLHjNh5TjDXHieSms9VvNhqrC3xO+mz7A2jN6SwPv1EAEY2Io+81q2VjJQR/xo7CN2FbigGpH7sluPzpJLeFRn/K7HHGqg6x1/FkFZP0k4SzBMql2SQAeRjXjLRECaUuzbnat3toibhRSD7Wp5Ja+6wXgVON9pm2vP0hEhq0oCYyIB84YKq3tMTwZ7z2rPlv4kD9I6rfqCPkuzLDGrudXtb5MmHNKh7o1vIi+PPwtby0fxsOqjDJ6OtWbhMcuVCTtzQuGPjFvtRPJ9/n0F+3kV7Jn+VspGg5e4lgLrlan7LMIxopDwBgrKxxKsmIt7MyQvIiRDKxGPjKWCRuJ658n8NB2/097OIx2ktK3sk5xLYVlMNCvLNjzy+WjB8ulSosCSxoFKhxstqb4vMQ
 142XGQC7
 NJLma9BFsn5ttRgHaL2QnQgY3Nvv7MkoBN8ObDoPdxLUjnex0oP2+H1i3YU1lGZDFmeJjSVS6l81aZxbq7ohPsy37TIBlM8ZogloxwtHSmZpZOTsyHCBc4bh714uyuwdSGe28HP4b+oljMl9N+nDRm8oJHm41YM/ROjMdPuaZqrB5q6TUZLvYIU+JIxVyFXVfx93DqbigIc4+zkInL1mfROsEb5Ctc+ZK/I1FMxKWtaTbuiWWcCm2VJVuXCXjO+rhw5Aq/OJIdUyoeq+b+8jWcl+KIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

fadump allocates buffers with alloc_pages_exact(), but then marks them
as reserved and frees using free_reserved_area().

This is completely unnecessary and the pages allocated with
alloc_pages_exact() can be naturally freed with free_pages_exact().

Replace freeing of memory in fadump_free_buffer() with
free_pages_exact() and simplify allocation code so that it won't mark
allocated pages as reserved.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 4ebc333dd786..501d43bf18f3 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -775,24 +775,12 @@ void __init fadump_update_elfcore_header(char *bufp)
 
 static void *__init fadump_alloc_buffer(unsigned long size)
 {
-	unsigned long count, i;
-	struct page *page;
-	void *vaddr;
-
-	vaddr = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
-	if (!vaddr)
-		return NULL;
-
-	count = PAGE_ALIGN(size) / PAGE_SIZE;
-	page = virt_to_page(vaddr);
-	for (i = 0; i < count; i++)
-		mark_page_reserved(page + i);
-	return vaddr;
+	return  alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
 }
 
 static void fadump_free_buffer(unsigned long vaddr, unsigned long size)
 {
-	free_reserved_area((void *)vaddr, (void *)(vaddr + size), -1, NULL);
+	free_pages_exact((void *)vaddr, size);
 }
 
 s32 __init fadump_setup_cpu_notes_buf(u32 num_cpus)
-- 
2.51.0


