Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35B1606A331
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MP3x1Ccg
Received: by kanga.kvack.org (Postfix)
	id 059E16B05BB; Thu, 26 Nov 2026 06:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0314A6B05BC; Thu, 26 Nov 2026 06:15:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62E36B05BD; Thu, 26 Nov 2026 06:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C62046B05BB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:15:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64080A9052
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:15 +0000 (UTC)
X-FDA: 85477013790.01.D039351
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5D7BC000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MP3x1Ccg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691713;
	b=l8YuPHgeDJqcXwL1+tZksjd7uFUSmzzKHGnP7fbVAJkyq2PZknAUT6E2VPCEgOaKa82iBa
	SGLtUtBFyMBiVNHwPB7VQ6zYJg45qfsNRv6p6d9sjOnj5rLbtxVUl66wyRRoaLKtDrU5TO
	o7brQ7tcNg4M+wkvAvpg+zvHPiba4ng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pa/qSMCChRGH42K3rYTSztXsaxvBOYR3oBjTN9/+VqU=;
	b=HcQG5jRrRxsyujvsWVxJ5kAZnw1r2gydlOUwOpHSwE4DvUMTxsnhWipIyYttvUAiV0OxVS
	Tja0MQC/cliaxq4J6doZL5VNM3SFPa15PU5XK/35tFsmnKfk8RHWaRzciSQFct8hzjOEzB
	Wr82NOjkqRccXouzHYisof2jXfZHFUI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MP3x1Ccg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F014F44FDC;
	Thu, 26 Nov 2026 11:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F70E1F000D3;
	Thu, 26 Nov 2026 11:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691712;
	bh=Pa/qSMCChRGH42K3rYTSztXsaxvBOYR3oBjTN9/+VqU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MP3x1CcgVdwXZovNmf2Ki608k9RA+upmwxLp4DhhwvWZFzw5QHNd1LujvDkgy5dqK
	 VudlIr+IQ0y5h01MkihEvEk+fN3u6e0wS395BMpBkuMKyfNQDtQIXifIJtscUMPgMn
	 mRMkfl5ZkqBv6Pnrvr3XlMzLeXxLL8XTGCTeQjY+DsJ0sPHkki4BSfureOMycyH4Ig
	 6F6k/5CR5+LLNSNVwEdIqxm8cn75nagz+yLvq8j0f6/pr5fLtiTxD0jmw41RAcqdG1
	 gDHYFA178/+99Xx/ijLHYcEFPmOPjXC5GwRv8Ar3G2pFnmTMGX0EXfDolIxf5QrwSJ
	 NJqE+CbJ3opQQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:17 +0200
Subject: [PATCH RFC v2 04/54] s390/boot: stop parsing the command line at
 "--"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-4-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A5D7BC000C
X-Rspam-User:
X-Stat-Signature: d7ujm6ynyj3fxfpjjxdqy9866hnx15xs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691713-207228
X-HE-Meta: U2FsdGVkX19pEbJwL4G5qsuxSPd8VYK++2mLVDXD+u3Cc57zPuSFJrhP2ICSbXigWXEgZiZyA75jBhy4EayfuT8Tra/XsTqqb3cfWu5XWAXycpJKL1h/Jd6yEfKwgJxXUk7TlSlnjdte8pOQwPW5W0KAi4oLpde5Iar9SSYeUThPiOP4PYqKLclbBSJmaYaTOlmBhd/0d6uMiEOMFRVUMS2HFzcfJNdL3XWV0b0H+Dek9Pe0VHgnTZ/ALIYFj4ToI9zFNLDUd41okfrHUgH/VvWLNQrTR1KJSym5P5AzpYy/8DOwQLQoP7TLYjcBLOt3EaD6uhdTUElvBWiWnYeffhK4Sh+XenuCzyKeWfk9kZTjumzXGKj904QreE4ewWkL8Z0KQ2+MG8MjJASWKkjqbLgrYu095Pl9msb17YHK26KLtrovzbXXofRFZrqrd9iU6PNQ7NKrW4O2x8m6ZDja9oPMuJRHZrwL/Uk2Ap8sSP08KfyeTLW6L4LKwIUpisjuOsRnVy5h4XYxw5na/PFlRUtFjPn+Z59RCto7EmwJg1TNUHduRvqpK3fhyMrN2bw+ndI4ZyeQ8ooz2dm4RacytX6kUkQmM1iRv92qT9Nl98d6NdIb8TlYPIgWMhuoer5qstPI82dI4jM2UHj2hTNh5q4wyWZWk7dM4nyyv+jYt6vrNvjLWtHzRqWCU90Tgci/9y3E95aJDBFB+bd7j/vlyuyO6pUGN+TFQbTIzBvO3f3Gtul3qoQP7QLGPapXAS7owM8l3q9tBsukIA0sIWLdkrZBDY5UWMlI3EkCcr9E7tAt1qhcD1Y9EUM39wQec3w92daleUODP2JgQHqNZqZzRP6BvJGWJgiIfVA+sr4YeY/+7lsjXRcugdMKjpssyl2G1SK4BLgc2qMeSbQfuyxG1EkSLF/kWGTg3ra6eaVWiQGhX4bfUDRHa9U/CiYDARN5j0gZEMfZomTFmYMYbC5
 HBul/a35
 p/pDViQi4SMR1KUMzOIu0QPQ6KYSBantgnpLZFepoN8Y3aq5pZ8hL+7crt5iy/f52L1bv9Gzt9nsrJwT1vOGoDiGhrzQlm9T0ul39nOzcpObKQsTEKrent678riBSoF3H9y/gURkEG7YJTJWKba3A2W6QeDB9AIaWyn9Z5UtwF5jDJJuvlqKLTPBL4XxQKmFLkY8LCcC2QtTpxw/ZEsCtECsp0rweX+dTInbocBHwf3HOFiH0fO1o+7bxKd4ryqjHMBET7460aPHqQUSAjO5RgpIUTB6N6PmBVnUJWaaf/9bgFx6mtgpLA+C+1LOuswxkMI7wKq6kevy/fFDrhkLnS0s6PbkK558nlpQgNI5JyNR2OcYcXODNsf5glfNkTRZkgO0L8FMX8PT+8LoCHq+7FtvNeoENj14dHFay6PI0qAxN3jj5qiulfDyQOsKDxW2IIiVDBN8dWBgjiVxOfhusjTuxaVT0kulW/vCx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The kernel parses its parameters up to "--" and passes everything after it
to init. The decompressor parses the whole command line, so an argument
meant for init still takes effect in the decompressor if it has the name of
a parameter the decompressor knows, like "mem=".

Stop at "--", like parse_args() does.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/boot/ipl_parm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/boot/ipl_parm.c b/arch/s390/boot/ipl_parm.c
index 8bbd102fa50f..ed28ea2fc1d1 100644
--- a/arch/s390/boot/ipl_parm.c
+++ b/arch/s390/boot/ipl_parm.c
@@ -268,6 +268,10 @@ void parse_boot_command_line(void)
 	while (*args) {
 		args = next_arg(args, &param, &val);
 
+		/* The arguments after "--" are for init */
+		if (!val && !strcmp(param, "--"))
+			break;
+
 		if (!strcmp(param, "mem") && val)
 			memory_limit = round_down(memparse(val, NULL), PAGE_SIZE);
 

-- 
2.53.0


