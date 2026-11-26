Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DCB606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PzgtvDcA
Received: by kanga.kvack.org (Postfix)
	id 0B23F6B05ED; Thu, 26 Nov 2026 06:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A2E6B05EE; Thu, 26 Nov 2026 06:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3266B05EF; Thu, 26 Nov 2026 06:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D09A16B05ED
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:19:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 639621203A7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:40 +0000 (UTC)
X-FDA: 85477024920.29.CB4E570
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AF9A240002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PzgtvDcA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691978;
	b=SH642ku0cSfRaej1soZYMQDAaLlnYJIIlLSxtXJKszVfvI0q1GFH+3PqeMFDzmBQ0Wg4an
	llwr6vjzgrQ+Af+yOtoN6i0XoMccnSmj1+nat8/1Rx8rKf4FRzVVZMx8vlLgguNqes8G+D
	1F2w5eLnq9j/uzAHlwG+c45hpdJtkHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IUAESVFtsidcpD6OicOHeScwyTIg4rQEjzbtezfzqA=;
	b=M7/9+7kyTkLqfm/B7iRBySLn2Vc1J0VF2+hcAT3eHhtOuWmYs1N/BZwIzUZAbD72vUxLo/
	zX+jH2GP0krUjbK+hEa5cVjbO7GnjFEVzNpNrSbARNrRQtC0qsczvATygGBM+CQ2THFcaT
	rDiy+38GmhFMRpZBecxMQvdf6LIQJSY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PzgtvDcA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51F8C62D47;
	Thu, 26 Nov 2026 11:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D211F00A03;
	Thu, 26 Nov 2026 11:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691977;
	bh=6IUAESVFtsidcpD6OicOHeScwyTIg4rQEjzbtezfzqA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PzgtvDcA4yy/D2Uepj3A4ekmgkoMVvK8vCHb6UdANFhGAR3OBnrXkvAS3r9CqvP2I
	 eDmwCIrTD3P98wMkVnY3W85BeGo+ZeBhcoHLlCd12HdFjujk8Zaf5uhR8BV51AOM9P
	 oW6Xtzx0AUymGG49kFi+8vJRbIFAGKIoVzVQwMCXSTZexmCClqXB7irUaJOvnH7AT5
	 H8yglHbC98pbN4quyuAGcNaw3RNs1KOwrdkUjWO3r1r/5ZIYpv9vJVR16CKt6bfdWC
	 KH8ca4HCAeD7eXntGrPQqRIQieHY1E0JUb0HMs7NmNLeElY0r6qD2n6VSHz7fdgu6N
	 3KyI5zsbNkYeQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:45 +0200
Subject: [PATCH RFC v2 32/54] asm-generic: add an empty pageattr.h
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-32-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF9A240002
X-Stat-Signature: duktrgqtr3uuto85jps47c3tk8fkcrwk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795691978-533260
X-HE-Meta: U2FsdGVkX1+sKUB+OHzA6nsJtX4xcDUMk+UqLZ4m2TEQSJ5PHpMTzi8mak6rpmMZGECl6Vu0UyGH4hAsC53tnW4YLJuE69qeeMyu4uu6DylWasjf1IDUF27IG4S7+RcUMNgmNR/E6m5KK+KenvtXtP08UcwmXNqLqWjAjHMAEKCtzV1AehIYvlluWfa0cVKDLF4N0Ik67HuHZ9m+cfCfofFqbBjm9fnIQ3XnhaU9ISWNI1NP3l7VtVJxZG/EoUacUE7P5XZ38QNMJdLzgjxmTk+Ja2S8DkXvB/Wob4oYn08OMaN4phZb2b8P6M4KhbK05UFlmex33PCzEuxsDT4b5RK2XHBFDq1Y5oFXsKh9pydHlcfk8lkL7o2MMQoR4/K4tEwBNuSl/Vg6pR+7NAKTsZA3LdXKEEuUggTfqrSSW8ejqmR3Zgl7x7LF68KPqCTf6Zs3RTSx0RaYckJvWsO0FntGEadXAdh3nli1Tnrnn1jv0dAV0DnT5A4aQjKBwhEHiWPLHJouOMSExGsWGNCELkpT8RdoC2ktU3F1PQqpRQEuMVP2n/VT7vHcKj8zfN25plsT9iKTf+xfKVWoxIAqQz+DagAaJPNZ3XOzNosJU0xof1Idq7D6O2l7pKltPsxitBnho04r/GyK9bw8phvP2x96uIKzmPAH8s+TA7KLCVwgS3BOvCQGOQ0csPFHFPOgDlymEN7orm9EBGHoTW/eUyn3C1GhWBG6CIrzbj3igtBb/ga47kh03NONSIgIvCgqIv0krE/7swFCUbiTDSdW3ZHhdnsnhc3momP8SHR+pb+Xl/QWfXQIhjJgUyz0T1lju9oOE9BQFVj6oJb9/TfwvfEk12CeHTX/DRAULjMi4w1Xi75RMYdiZz1l2eNuydXAjzXrPC+KR/hpD3PEb/uIzJXr6XkWvirjRIJe9NifwLODiifw2wwXeQ7Y1xGrqt1tXHidQA6lO0nXf4x8XB+
 LmwzMm6F
 tBwQNOtcBLT+yMQ99sBc2MEUGmtc7lalztfaiV7uAQV7Zq2O0aodg74vXEeORSsCY4mB2Ek1TpX2s7dJMZdVeyAzIFGikYx05KyFMULdk2HG2LkZ7HD7MfNflOOF8sqe0d0uQQ8qnCDH3s9W2ijADW/ozhkJE8C+4iT692V49azTpvgc4Oedw8NLUCxXppTk8SciAhNzqr832fZYQ2qvwnoFgYx8SDVKqIZeqFfbCKwJw1RIh3R/4abjOYn3LmiodVq+UztuzqO/3FpUwYY2jEcpQdExWjTrFZEBWnGK+w1304tDNp2sYdZhWd95T+kXbQBPRBOR1HgIn8ioFhRsGw6waSzwh18X+mGn9ns/Q7MT5a6yMiPPhYZZ3kxLty3C9EfzRIX6lz0/TKmKNeStOFTaosGX0oDay7YfG3Vfkuyyh6W+Gth4aaw9Ja0Wiz8pamV2MVFhOgioC8UjTAh7aKRZTlhDXTROaPDbq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

linux/pageattr.h includes asm/pageattr.h for the overrides of the CPA
hooks. An architecture that is fine with all the defaults has nothing to
put there.

Add an empty asm-generic/pageattr.h and make it mandatory, so that such an
architecture does not need an empty header of its own.

LoongArch, ARM and powerpc will pick up the asm-generic/pageattr.h when
they switch to the CPA core.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/asm-generic/Kbuild     | 1 +
 include/asm-generic/pageattr.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index b7a388bef6ea..fd9fb2c3260b 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -42,6 +42,7 @@ mandatory-y += mmu_context.h
 mandatory-y += module.h
 mandatory-y += module.lds.h
 mandatory-y += msi.h
+mandatory-y += pageattr.h
 mandatory-y += pci.h
 mandatory-y += percpu.h
 mandatory-y += percpu_types.h
diff --git a/include/asm-generic/pageattr.h b/include/asm-generic/pageattr.h
new file mode 100644
index 000000000000..07bf3b0e84a0
--- /dev/null
+++ b/include/asm-generic/pageattr.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_PAGEATTR_H
+#define __ASM_GENERIC_PAGEATTR_H
+
+#endif /* __ASM_GENERIC_PAGEATTR_H */

-- 
2.53.0


