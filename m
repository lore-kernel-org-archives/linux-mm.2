Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF83606A684
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dx43PY55
Received: by kanga.kvack.org (Postfix)
	id 9DEC26B060D; Thu, 26 Nov 2026 06:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B73D6B060E; Thu, 26 Nov 2026 06:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3E96B060F; Thu, 26 Nov 2026 06:21:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7344A6B060D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:21:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9778A03F0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:53 +0000 (UTC)
X-FDA: 85477030506.17.7F0006F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 488371C000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:21:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dx43PY55;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692112;
	b=AEpDIB8UtjcHGR4rqa2HFljcWe/B8RkjPbIbse4KNEgzzs4lW/G2wlnzPH2age4KpKvJwD
	lH5kC2erM/51cLacZ+MPLUHhY3BUTgKEpFMsTaVG7lrm8tCFA8GOtaC9FeQsrPFv65azFm
	x7F9aTpCLIrnGF5TLK2wpX/IWhOaNHw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iJQZ4JiZ/q2z43yM7sOmznlEhFue5dKtH3ZUaEt9EQ=;
	b=ND3dQQxZ3MnrvoXgVtDEATsbp3enxf5s20dCI1C8FKsJQanHfHkQJkqJJXQN4wZhh9fgHD
	jV3RecQYXn/6i9j0JD4rduIHZ4hYnOYu2PZbI6UgC4UwBEjv/VThyvkhVlYkH1jxHbUkf4
	Ns5n4ZC3oTIzuIFXUVIlLSn7Oc/dTuU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dx43PY55;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE7B76338E;
	Thu, 26 Nov 2026 11:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016FA1F00A01;
	Thu, 26 Nov 2026 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692111;
	bh=0iJQZ4JiZ/q2z43yM7sOmznlEhFue5dKtH3ZUaEt9EQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dx43PY55rPzSGwZLE10j3vMNvaChqjvukI+hPnb8O51peEgCTLD7xqLTbXfhZ4QnH
	 7pS+CZwsAXWfxbp/4JWBDp9do/VBawZXTV3ccWCbpuxUm3w6GIXCKgzhyOTodD89yQ
	 ebb1YIe3iMbTjMMO/txFQf9GfMmJqyzqek8CWJtoABUH/UGA97XeGs0zu1baThNVfB
	 qDDME3ZyjhYMlfHBuGiRumtfOFkh2Ov+xT0sD1dGDygGZA0oxdLDYurcRO0mTEOe5u
	 Z6FZ9HTm6ofPbgw7bA+4BeT2anx67vEy634jk1w4kSn7Xl1XzAFdMJa49y6aHSgZNL
	 iNMGCJcVGRqGA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:59 +0200
Subject: [PATCH RFC v2 46/54] s390: remove set_memory_rwnx()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-46-723f1e33c3d8@kernel.org>
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
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 488371C000F
X-Stat-Signature: dj38yt733xouzie74hhnitjo4od5gyzy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795692112-347971
X-HE-Meta: U2FsdGVkX1+2IRCIXUcEaPnDcQi9glBV4smh0yhzB1qYFrNqnFjCVuaEFpRb6pkpEj6Q7Rp6lrriA3JFiu0KqZB+H25chTM3jKhifxPhF6DHIHdDkTlfy2g/pR10K0eXsUwdIRzowVTOE2ZhMaRpP4YGEBIhcpdlJLKJUXn9DyJZiwdwNtgsp+z/XVQdblv1XRwSOouT1pJD94muZWliYqdKZKeQ+OmlUCR3JtwKUvsHWezPP2Bv2sxtsWtRIC1wXE7nFOHYQSf8nMti7LN27jimjlj+XTzvsPEve0MsMsEyNSJYKsvrViOMzFpYst7Ks6QDjw9x0xLUEZ5Nam/gef+SQpMxsP+qsWJd3lQl37K0bFbFQmI9Q4if3bRdbBkb65nbL7D769bKNwyYtBXvLIrAaKqvPlCSYhWAPQNujX5TqCN3dU3q6/0T6Fa1LrBCinT8bO4FhGx17UF97H/0zoMu+wB7NYXeRl7OdVFCGNWQb+89RNC2Aswofgn5tT2/DuRAUDfjB8aQvdgbPR4VwPKcub5pHuhAM6/BuwzLQomBKGXURrin2sdDnXUF/tUuqw+nSPksWoAGHdp/lEaY1XoG5PoRrbUh4nN4Dy9A25j9pVyB/JHFzmxRGaia5MPu/4BQA4FS1BeCETxa6+MqISVlZLWXLGZ/lSckB8x/w5//lqhACMWNc/XPvADaAQsTQuFENr1P7llHcgJR6B/RjfB3vZMLF6Gab2i/Tt0lilMuB4KgCxLdRoP1dhlBv7Svvi2WfkzxWR5YhDmjMyqXaGmQ/WgigJP7lQYWwh5epLu/5aYZqltsH5IiPL2ubD6e5mQod5h4Itgic6iVz2zjRL8TSPxCzcYo49ZgYLS5nxim7E2Xey32yqRMnzkI2SCKKdHWDix8lLmzlqrQPOBVBBALsu/Isx3BqCLu9VKlbUbpvXR/8lNfmQgymDTbepEWIQ5zfFIxr/byvJGLJYS
 bTRaWndF
 cXm5S5Swvj7cvOBxyLIwi0SmCnMW/6rXwVg3bp4jwODNJ1JCGq0kxjBish9SO9EGWx/eMSvqLeLSBFRWQCJ35cBi25gTL1x9MhGGTKYSgmZ3FUxYTD3WwPhNTv4Ow86c1RbeGZ5HdwwW39ofDHNAuwqmdaBqcFzKvZ7P/LjCPXfToHqMWXA1nyDdyXXT0uMPD+U8vjpIuO+uplkBdPQko2ccRYt5oAG/i+kswaKN5I+pzGjwvP+mMLKBjpTX17uRPtbgTNOcQgOHqtrn6npdLH0LaMGhvBJzZUeT236jg+nn0TEWEM/E15IYmCfYPle/jF5ldXaPpywEbAOegyTAHRrxJ0Azx4MjnSWsOqGf76QitEscPBEXsFf2Q228mqxPsKidbDzpqloDupnSWts9kDb28+qzlgdZT8zCmXpGcSGF55VlBUc6VAM+Cla3iv7X7myzX/yYBRsXvLOuW0f3ZAMypGDnkVDTekSa0ZjbNG7bij/dZhoQ8xnuNRxGhsLm4Mnq8h96ZRVWMr/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

set_memory_rwnx() has no users since commit 33bd8d153c33 ("s390: Keep
inittext section writable").

Remove it.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/include/asm/set_memory.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set_memory.h
index e3562bf0c1aa..23987b721ed9 100644
--- a/arch/s390/include/asm/set_memory.h
+++ b/arch/s390/include/asm/set_memory.h
@@ -57,7 +57,6 @@ __SET_MEMORY_FUNC(set_memory_rw, SET_MEMORY_RW)
 __SET_MEMORY_FUNC(set_memory_nx, SET_MEMORY_NX)
 __SET_MEMORY_FUNC(set_memory_x, SET_MEMORY_X)
 __SET_MEMORY_FUNC(set_memory_rox, SET_MEMORY_RO | SET_MEMORY_X)
-__SET_MEMORY_FUNC(set_memory_rwnx, SET_MEMORY_RW | SET_MEMORY_NX)
 __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);

-- 
2.53.0


