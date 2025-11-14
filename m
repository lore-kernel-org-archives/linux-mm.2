Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB20CE7B1E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E17C8E0030; Fri, 14 Nov 2025 10:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A888E0002; Fri, 14 Nov 2025 10:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5598D8E0030; Fri, 14 Nov 2025 10:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41B5D8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:16:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0669C4CF5F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:16:44 +0000 (UTC)
X-FDA: 84109564728.16.B20DBF3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EE36C0012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:16:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SfXjFrjy;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUsWRA0PhCMnZLZEkKPa9puqLJ49gF+6GXOwWTaFVY4=;
	b=WJPfWIlcQ6fE9fzzG+8xo5UsK3JOBZYuKEu3aw/KJcxTBAFFOoZWciXoIVB4Uk7OySajwN
	DAR+DlYtkNAn2ii3iErHTLxqre/0tMfs2J0VVepxspn32N4TGLyUEgmft/ov+amRGzFWzu
	z+IKMhbHo9QmRZr0vGTR0gRLZ+okjWs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133402; a=rsa-sha256;
	cv=none;
	b=zs4gkcRc7LzVpyqsz40oxui1NCs1RxtcvdYLxm7BArNfKhfnBzSlGgE6RnVwizleSUDOXC
	UYqsC8qGmPArvmsem0PB2/1pLBtXSljRoytzwKfshD5Tc/7J1SVEvEHVEEgG7VfjQOJHN0
	cR214JhmB1J7rokrD/BZ3pHax53RJ2g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SfXjFrjy;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUsWRA0PhCMnZLZEkKPa9puqLJ49gF+6GXOwWTaFVY4=;
	b=SfXjFrjya/UszD5iBGRDB5HTedJ3X3i92R8czttiMSi77npOfj0CzhQqKprYwYYPWDRhXE
	ahGqzHF1SuQ4HvO+tD2RZxi4Rn7CXoWeT8GY3unyJJ43Hc7lzn41J3utV0iGNBq5PK+h2J
	U2YQxr3ciiGHV0YoNaYIEeaVPVKbF4o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-ckqYkCrGPcysWf_5rr0BIw-1; Fri,
 14 Nov 2025 10:16:38 -0500
X-MC-Unique: ckqYkCrGPcysWf_5rr0BIw-1
X-Mimecast-MFC-AGG-ID: ckqYkCrGPcysWf_5rr0BIw_1763133392
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CBED180049F;
	Fri, 14 Nov 2025 15:16:32 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD14A18004D8;
	Fri, 14 Nov 2025 15:16:16 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 27/31] x86/mm: Make INVPCID type macros available to assembly
Date: Fri, 14 Nov 2025 16:14:24 +0100
Message-ID: <20251114151428.1064524-7-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EE36C0012
X-Stat-Signature: dwki5xx46eakg4e4stmrxncakqp3w583
X-HE-Tag: 1763133402-156869
X-HE-Meta: U2FsdGVkX19gf2xCsAqbEBPoXbCDpbvhnhecg4xr+7NoAFIbAYHDrhRZevxw6ePSnVXdHY6e03Lqy4ghpvSJnkh51L3Ybp9+V64mZlIQdkjFIdvCq5OZ9xS3aO4PPfTft2dw17s+S+EWgVGWguKWsJAte7kwgX/XFuHP607Sd8gdoadVijlfqobvEHnXz5FFItzlnGoIhWAtA8qRcDJO4NSWkVCTCMY2v13TCo7K0KM2mr4HtV0exks0vUTR5gM7hf2uD3eRWC9CJfDnmBrewRmvIFmBvpfiLu2ub0a0GzDhN3UUpJhNH4uSHlO1yjNgKNXB3czIONGCyWjl7d3iJNz8swuyCPjhRUVHQvcYoTFnDeGZ/gerDiUT0WX/3380ZpCLG70urij1CzuSbW/WU++tqTtcUmumB+gHArzZy5+LPEBjUXyYDe5Vjo7MrPktNeyYS7zCRkSPniIoXuff/rSn0rsC2EurCIW3k9PEthZHhCs5XAiA5JpZWMh8DNYKN0/2D2ZXmPtkvGH+kIkly1bxuwbsGYYON3SU6PS5tkXMZQig12a2w6S2/2saG07Jo9uOnNOEuzvBT7eAlmJrGSASIxFuzVt6C7fHAOLKhDcdkVmtacdXdKW7zQvH+wFMlBBY/KXRE6eeH/cHuZ4MgTZD5KkCcozcBnQXVl+2gI4bf+1LsbUnwomza05CRNFStY2CfDs0DgYDQzr72qu+to4L6QPV9h+GOZtS9mRXPXMzAmPyMG1PTB3Erm/9vGZrG0HaFMy2s+9Km4YM2wRmVXW/FMmrDNdq+PH/XoSRFNz+I5AmZueblLlHUsg5Dh7wloyErX3AamoLjelGw2URfl/SCNz1MynbdCc31Hl3tcfWM802evM2Pl8Mu1Plrk6c1toML4Bq85p58BrY6i5GV7Pz0nLO5I36hcDIcq71vcgTzQ3il1ICwt6MOXZx6TxaG+KtiUe7J5hda6Zj8mk
 s5TzZllK
 GNaVjYDJFCq+Dwtc9oCKsHCCig5Appop7WOXfcRJ0lwdaKCKwT4LaFjZXpbTbTWfncLvCb2F9WV1ERT9gUpYeZc852I3nC9S7FnC4e5Ib5zxOfRFu1p+HcfrMOzijENRKISGAqz+ia9Oi1085oTvSpuQsIry3IxBbSisUt9OhXfFsFu+6koybCepVP4De2DdSzLHvE+9L1O93+ZRUosJQiMS9tgIhQ5q1UKbBFROpXXndJS6M7+EYKJOYmmXhdtnJpoZSLOBZMXfpuT8X5iFKK/EckdLvyGwN14K6wUeMzRdE3lpnv6vr381CS/VtC6Ou+GMCPq3NSy2CoFbhKUuwV9LGLHbojAbUgsNjhbB0005dcNd4e4cMhwJrB58kQ4p9igm0c8Hv05XCrixNgQmMhfXMTFcpA6HEx2rp79gGH2sxa5s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later commit will introduce a pure-assembly INVPCID invocation, allow
assembly files to get the type definitions.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/invpcid.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/invpcid.h b/arch/x86/include/asm/invpcid.h
index 734482afbf81d..27ae75c2d7fed 100644
--- a/arch/x86/include/asm/invpcid.h
+++ b/arch/x86/include/asm/invpcid.h
@@ -2,6 +2,13 @@
 #ifndef _ASM_X86_INVPCID
 #define _ASM_X86_INVPCID
 
+#define INVPCID_TYPE_INDIV_ADDR		0
+#define INVPCID_TYPE_SINGLE_CTXT	1
+#define INVPCID_TYPE_ALL_INCL_GLOBAL	2
+#define INVPCID_TYPE_ALL_NON_GLOBAL	3
+
+#ifndef __ASSEMBLER__
+
 static inline void __invpcid(unsigned long pcid, unsigned long addr,
 			     unsigned long type)
 {
@@ -17,11 +24,6 @@ static inline void __invpcid(unsigned long pcid, unsigned long addr,
 		     :: [desc] "m" (desc), [type] "r" (type) : "memory");
 }
 
-#define INVPCID_TYPE_INDIV_ADDR		0
-#define INVPCID_TYPE_SINGLE_CTXT	1
-#define INVPCID_TYPE_ALL_INCL_GLOBAL	2
-#define INVPCID_TYPE_ALL_NON_GLOBAL	3
-
 /* Flush all mappings for a given pcid and addr, not including globals. */
 static inline void invpcid_flush_one(unsigned long pcid,
 				     unsigned long addr)
@@ -47,4 +49,6 @@ static inline void invpcid_flush_all_nonglobals(void)
 	__invpcid(0, 0, INVPCID_TYPE_ALL_NON_GLOBAL);
 }
 
+#endif /* __ASSEMBLER__ */
+
 #endif /* _ASM_X86_INVPCID */
-- 
2.51.0


