Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE05FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFBE6B0096; Tue,  5 May 2026 04:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2609C6B0098; Tue,  5 May 2026 04:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176846B0099; Tue,  5 May 2026 04:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC966B0096
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:25:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9995B1A037A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:50 +0000 (UTC)
X-FDA: 84732682860.09.5C3AEC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7FE23140013
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:25:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HLpSRv0x;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2arT9BR9GQEDmoFSfkd1amcjOIN23FvDLl4qeaHtwQ=;
	b=Q0YnBjyRiUWf9GTFbl5skbDxKIJjJazMriggYDNxbCUyvtng52UEPg5OdZY9WKtHopAQAY
	NlIdFxHk73nmZs7fVXJumKfVES7bxrdyDNoXSroAeNfaHrmsZeFwoKzkK9Ej6Y8Kiwf5jV
	DOv0GiQJ3fXOlqb21L7MuO9diMuNPls=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HLpSRv0x;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969548; a=rsa-sha256;
	cv=none;
	b=nX8h7V1nc1x3niE/o+FD4LTdEJx5aww5DY2A9r/cOGiZI9vgCfnaDXEvmx39ppWxXte976
	QjGciffNImPgTR9/fyt9UdCudcLuNtYDkOPbJTealVseKF/I45DDn94LUOG3+3pKSea17h
	nCLNsz8jDLlcOUBs2TBOkmbH8uusmrc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l2arT9BR9GQEDmoFSfkd1amcjOIN23FvDLl4qeaHtwQ=;
	b=HLpSRv0xGu4sKbuI4wLmeLIlc1C15+PhCo1G1GPe/0zyN0+iGfEvtpV6XvxzHCpzoZ/9Pt
	LJA9Qw8JCqHHFlIUvkDSR5mQCmlNr3hOY5dhHgmhlZNjxGl7uEAVKbWkWfJzg3ByGnjLIJ
	pGvFnrnJVn8yszw7N3dYjasGh0wPEYM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-547-ALc8xlBqNVCJlI1KL0LpvA-1; Tue,
 05 May 2026 04:25:43 -0400
X-MC-Unique: ALc8xlBqNVCJlI1KL0LpvA-1
X-Mimecast-MFC-AGG-ID: ALc8xlBqNVCJlI1KL0LpvA_1777969539
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C97B71956096;
	Tue,  5 May 2026 08:25:38 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF4B030001A1;
	Tue,  5 May 2026 08:25:26 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
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
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v9 04/10] x86/retpoline: Make warn_thunk_thunk .noinstr
Date: Tue,  5 May 2026 10:23:49 +0200
Message-ID: <20260505082355.1982003-5-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: ErWkj2UQjFz0BqKPGZ_8atrqu3Ahn8XFHiasoXh0_Uc_1777969539
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: nwunam31a8bs3gjbddxce493ira14g4y
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7FE23140013
X-Rspam-User: 
X-HE-Tag: 1777969548-379365
X-HE-Meta: U2FsdGVkX18098rZSL+dk3QkDnzeNFNOdsmPfzKqNV2a7hxPEwxV1sodmSXxE7krjGdUHFQxs7MhBkobs6FWE9c1OVw6cCuqyrl9Fwd6iq2SecRZ2NpI4KOFx5MG9k7DfIt4hvv9NaezkqE7Bu6hQAaUcYWZr4eMofvbPp3aiF7o66e8xQK/rten5pe8i4pxEwZ25PGV/DI/JbJwigos8jPw/1oMxqJo1MsrMaF4fEE24fRxPRyiRZ/LfpoYERe/x/sIitvat3kTOvLidgxtxho49BMnk9FXywCZuXxPaWs9eedcXCbBvLPKloaoKDWSwj07QZyuipP9VkdwO/oIwK9VC46bgHu5GgJCUrLywCqCLsZfWDVrv1QifK4jHBklNZHelhGS8+izS8JsIUDUoZm5Y71eiK0xvpWG4f1hwmbN3P9lkRFo5gGxovVo6+SAwp8eCt4ofB5qPmsJKShtsS2or/cnQ+ZIss+kQD01vMfsf8WT5tw43qfgNQJsu+FVpESWJdYqHu0+hP7ckjfxv7GDJ3AcSgE90fXFkmCprD8P09WV+RG5t7/t7fN3QIlL8JiIvqbnr7P8Cuvrrf7TwScn/ug70kKjDE/siaAU7gNoWMwnehOnhniKUryK+vL8Il4I1vjzGTBfoPr/sEbg8lBZMWnbIMStx7E3eodYWIQeshRcCapnXik4HLwHBn4xvaG0fEM+qQzp7VXLBd/oXkHEPnUs1KWZFQEi7Df6rOZ/wWX+P1T+rHXa6l+OfCh6s20GM8p+TcWtYk3cWoYBmo/GyQ9fmG4/DqUS0tsGU0mG1ORKX4YDe3mTbHX18olu2/n6fZ6D93/BqABLRB0VsP9b0Re1e+xi1VURDnBuhxuELkynCmSVMZ5zM9fFFlam1D/oJNqxC6FdQcHPir5BfzkSH5mcuGFdDoxIffBOsiia1qnbqMECf2FwaGll/P+LNdnC67XgEGwRTfreXXk
 fdNYXOml
 iv4HE/5EUYozDdq1dIRVc94wAXiWjDUCkh8hwQw64SVMG0FBDwA+m0IJ/XpWWITN83h0/4xczCsLFR+I6g7N/P2Owh1SOmtZ7Vd9250yFsAz/q8lthnnNBvJGzd/zfeww09yOUp4XBeTrOVh6+SdKuII32Xm8f0da0IfSHNQedSv3/IEqv8UIqr9f5YTPhY2sYSOwynYf92NOIGYrpT77bdb1c0C4WoGtf6LaeeN+Xy6L1q/4kMdVtZ0Znb6nD8+S3q4i6cZFjRRmkd/tDGlaYGA7e+8KV248EtoMCLcRhS3KJjiyQynKa4Y78MsZtlbldzzwlgkXhKVcQVrVo2qC57yqGZsmK7fIhJany7LIF3PrrQBOGPkthgX+ILJqAJIZacwURI9Pa+AKVi6gBDYx/DHnYQr6HqeEa9bwanJ/oj+KZGDhE6hT4rHZXGWPlIAnHHxBs4IivlQDEs5R9L9xzhS2XOjoKbmNx83EUdDH6wQmfDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Objtool now warns about it:

  vmlinux.o: warning: objtool: .altinstr_replacement+0x28e1: call to warn_thunk_thunk() leaves .noinstr.text section

Mark it noinstr.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/entry/entry.S     | 3 ++-
 arch/x86/kernel/cpu/bugs.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
index 6ba2b3adcef0f..e76560f86b332 100644
--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -40,6 +40,8 @@ SYM_FUNC_START(__WARN_trap)
 SYM_FUNC_END(__WARN_trap)
 EXPORT_SYMBOL(__WARN_trap)
 
+THUNK warn_thunk_thunk, __warn_thunk
+
 .popsection
 
 /*
@@ -60,7 +62,6 @@ EXPORT_SYMBOL_FOR_KVM(x86_verw_sel);
 
 .popsection
 
-THUNK warn_thunk_thunk, __warn_thunk
 
 /*
  * Clang's implementation of TLS stack cookies requires the variable in
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 83f51cab0b1e3..87dffa7a95a4e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3731,7 +3731,7 @@ ssize_t cpu_show_vmscape(struct device *dev, struct device_attribute *attr, char
 }
 #endif
 
-void __warn_thunk(void)
+void noinstr __warn_thunk(void)
 {
 	WARN_ONCE(1, "Unpatched return thunk in use. This should not happen!\n");
 }
-- 
2.52.0


