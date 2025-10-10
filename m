Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664FACCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0998E003D; Fri, 10 Oct 2025 11:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39D68E002C; Fri, 10 Oct 2025 11:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB538E003D; Fri, 10 Oct 2025 11:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8634E8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:47:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 345341A037F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:26 +0000 (UTC)
X-FDA: 83982634092.09.F974AF3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 522C6140005
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:47:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DalQS80R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUsWRA0PhCMnZLZEkKPa9puqLJ49gF+6GXOwWTaFVY4=;
	b=enhTQG3FAFW60cOfXCa/t1RUSUhZFik5jdpyFw9Jkc+kKQIUKIB837t3KILe4IJaykYzhl
	HlIPdKUMWXbL3q8hXOCiabIyJ9YDqqPj/Sflp79aNloskubKvpeugAA68DflETidUiDPoW
	S9oSTE5Fgp87QnNP/4lTDZVJReM+CZs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DalQS80R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111244; a=rsa-sha256;
	cv=none;
	b=amATq2/scubKf2j3f/pCzH+pfY0GN6k+0+QVP4oOKoisk0GRlC/fD/i0FlSJfPC49l2hXT
	Nbms2liKageRzo+ZqPoo42iVT5iLXv/VH05UGQFQtkLvrsuicbKVDN0rXQAbt4nV77E80h
	jA2COe6TKfXsWWH8hL3ja90kNb7TcdA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUsWRA0PhCMnZLZEkKPa9puqLJ49gF+6GXOwWTaFVY4=;
	b=DalQS80RdpLq1XJGaduoqm/bSQlTA/i0Ffgeu8xDyTTSoFrjauclJFg8RrmGbc0yZ4u1DO
	HMWmSEDLv1YLdsfUfZkiGXfZcwPVesdTCGhm/YXLk5RlvnUKiZzeXfAnqXLrx9VDZG/oe6
	9N8Y38UH47wLGfJwoKWr1Asgfj/apeg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-ZEfMxigJNYmrubTlAi7LkQ-1; Fri,
 10 Oct 2025 11:47:20 -0400
X-MC-Unique: ZEfMxigJNYmrubTlAi7LkQ-1
X-Mimecast-MFC-AGG-ID: ZEfMxigJNYmrubTlAi7LkQ_1760111235
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B87F195608C;
	Fri, 10 Oct 2025 15:47:15 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B7571800576;
	Fri, 10 Oct 2025 15:47:00 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 25/29] x86/mm: Make INVPCID type macros available to assembly
Date: Fri, 10 Oct 2025 17:38:35 +0200
Message-ID: <20251010153839.151763-26-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 522C6140005
X-Rspamd-Server: rspam03
X-Stat-Signature: bxkuimay7mxoqb35a8an3yqpdmc87our
X-HE-Tag: 1760111244-286275
X-HE-Meta: U2FsdGVkX18pEuZYFRg4hjIkUfPYj0hg+NWcMmGLSd8EHHCpvstq03Vikl9EoYU6+jdY7f8yVsF1oZyW4Ld+xLmsZ8jn9LD/NKELNo9DF4sZefncGO7C4y6VIdBux5oOIbBqq/rcYqBio63M8bkRUWFSaDGL/2PWII1NdOJTY3gcLNYhKealMz2URV0yKqDw4cbiyDWlv+q7DH1kfXSXsjN2y7RTzYFFMXYXH3nRIpwbQEZi2q6i9RyJJpIow77/dZfPaMOaRd2e39/SbeptkHKCK5kZMuLVUHyzPF1RYKUSjeSnBs5L38hAeQQVNd8/TlIEOZpxRDSllJvVywEBjpTOhNrQl0Fliu0q2yfNYfmG0WaJT2XRqQmJw9GwqdWnwX5RcGIFBvNJuZ8F8xyRok/whYa1TdNhIz/b6aWrZX72kxkzkyrpcQm8cnAXR9gN9c69oWiH6iSugcc+CpmLEk8MHkZ/Yarl+VfjfJ9otiXLTEAlUp8KwBUNRs59FPOLHPCPj2r3AXbvoYjEKELWTsXUz9uGhRm8t9K/erZYQ72Q259EmNWDo1ltYtHSsjC0tSwO21FBdU6UmzV6LRhS5x8z9jK0B3LPAP8c+oZwhnEqFcGsrtM6xv5+q5pApNsdyQDFmD/akc8Is8BN/C4A5U+dcMCvLBp7GmvjbPmObINFn2rP+p8HZIVtrtpkt05Y/ha3NlOfpJYjAMKT7BTC4joXR3jeaow7eK3KDnD/w0liqqUXMDMsx+HF02dg1xHe8r4OsypFC/G9ARJ4yTjpVOamlRjbYTDk/SJ47sCYUep/s9b4l4DFSDwjP71xFQN2oBRvHrqDxLWTU5ALWR+lHP7uUonNMV7jAgkou9dICnyrYz5OnyG6rQ9kUmeeQizOAnm7HHtyRibQIDc4QXfuori2qCg/t+dIXTtRE1QxwAJiXJP2D+SVpRp+7R65gS8wCY6mufXzq0pajF/hhdR
 bJUQhL0A
 QP56N1sc4EJOJmWhJe/i+zliO3PlFL3yYeGBwA+3Yt0Wj9R341U2jGi2RDkWQA5kFAMjudtqfzqUJoiENOLcL7yjBeqszXC2g2k/VzMwWkbi3dGSrthDtkPFRyVotWDSEPM1lp6zYDhSbXEUZgeAf7WWG0uBsKr5+bsfJ9bL33Gyv6hsvSrRmN3OEIqY9Ft1/V3oUNXyGUAmrerTvZlgBJxMCowwb7SAO/CEEe6Ve9ezAV/eAEHyKvMSAHP5/K4+l43lxVMdliCvBPG+ge6G3/PnDcGobsuomV+6DIvJGezBpk2FNOsNuKLtvxALA5dQvINJs88aM8ok5Q/iF9zPDC54eBbsTEv/DkxCCbqsB96yFic0fmRXjPQNPy2HACuRSno/gIgXtfk1VAN4MjJfvEgYI7px8gYKZcFj20ka5vNUMKvo=
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


