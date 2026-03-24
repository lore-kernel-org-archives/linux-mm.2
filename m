Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086F3E9A755
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745F96B0092; Tue, 24 Mar 2026 05:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F68C6B0095; Tue, 24 Mar 2026 05:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C436B0096; Tue, 24 Mar 2026 05:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0D36B0092
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:49:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E608A920F8
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:50 +0000 (UTC)
X-FDA: 84580484940.06.924C8CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 10D801C0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:49:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a9Nmg3Pw;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a9Nmg3Pw;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345789; a=rsa-sha256;
	cv=none;
	b=VVAS5exl3nFjN6TskA1SoDx+0Tb9TGKsQYmVjibA1JFTqPXqfV6bjSCPad/NVSHx18V3fK
	OfgcOa8HB6kWOSkImeUkhwzmgPFNAXW6Y7RQz7A60aPnbpTU7iLvXAOgX+j4pZgSUrJdZC
	y9pCPBqXYsrKkeCWkiXB2/De9bMY0PE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6la/YGRpfCEF4wUUEPjSzD94dCfNlkWphwgGjyKscE=;
	b=EL+QNEtH6tG1ekqNg/Xjn/rhFsa0PJbAzuGqQ9Fuf44frZcAvIgTZIM1m00tdSsMdQwvwz
	moHRDgSu28n85QrWkByERc0cSwTWmTD3ur3I+DzUreyf481eyLZzdxDri7i7HlFzQHBLYN
	8x2Mp59ZudfiAUw8Uo0sDW09EREvLXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6la/YGRpfCEF4wUUEPjSzD94dCfNlkWphwgGjyKscE=;
	b=a9Nmg3Pw9/xTuH+4u51+tMbl607zXlHQ0CZo7kMlnc38gMb9CRGRGUQI4WSw2Xknz115su
	dyUHNLb8gEXvv8ljeW36fW+AefhFDKBqje0bhkTVbEzW5fUZx74M211zdx2Ho7eZWDLUC8
	w2lPXYA8oSxN2z3icE2aXfMvMwt2om0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-q8xavQyQO_WXuiyIPfHRjw-1; Tue,
 24 Mar 2026 05:49:44 -0400
X-MC-Unique: q8xavQyQO_WXuiyIPfHRjw-1
X-Mimecast-MFC-AGG-ID: q8xavQyQO_WXuiyIPfHRjw_1774345779
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44362180044D;
	Tue, 24 Mar 2026 09:49:39 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C073930001BB;
	Tue, 24 Mar 2026 09:49:25 +0000 (UTC)
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
Subject: [RFC PATCH v8 04/10] x86/retpoline: Make warn_thunk_thunk .noinstr
Date: Tue, 24 Mar 2026 10:47:55 +0100
Message-ID: <20260324094801.3092968-5-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 6TAyYWnD8PRMv_flq1NRxoAnxfyVtbHOc-8y8nc3JYI_1774345779
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10D801C0005
X-Stat-Signature: nrxunm4engrf9kpzyopr43qgznkd4irz
X-Rspam-User: 
X-HE-Tag: 1774345788-456344
X-HE-Meta: U2FsdGVkX1/vWjBtbScnRoZKvzC1TuP5IcToD25ew6f1JtsHSSRa0MxP6wMqV7jj+EkaKRzQ3AI4Q5Vz9u3kL2WnvbtriNcnjQBFJd55cUFg4p6Fpq6AB/JidBdCpjyXwL1thF4+y2vMaZOCk0l3M+BAPn0rmoTmVLKeRsFUo8g7GcW2oFoTzMhdx8fysPNl2rv35yR5z2Th/FxHZV4mb8u1t0ocE/jNoXSc0DSLb4Y/gHMC6SUbu5qCwB90IdjvZHpAgQ8aSMx4uiF7EiBoHwaDjPP/VrsdxXAQ46IifCDwA69s+TNbUJ2l5DtcVy6bf7z2M1NwS4hEiyu2Mebim/zw7NzMNQHrNJgBJMUGYdeBpbE1JGDuzRFLG8CovgZ6+t9SvlmvsPwYr98826I3pst3FaVdwC5oaY3HlRo3UqSz0M8tavI8A9pGddQdbLTYV3HtHogBO4htPJzfrpc4WsreWiwgxHP6HMtXGAltkp5ox69IFI/gS9uPqd0zo5DgXenW711ph8ZOwOX2kJafM7fAlI5C5OPheAJYaWB2cBDeVE0iTTMhhpkduhMGa6nofbsPF/BflFMm/UesJEc3kphy3BfShRHHAECaDbzwSGXw7h/6MQXybMAVokRHHs2j+RT2mXphsAujEBcRSXaH1NwfFaS7n6vZitWMNyTFk2H+biJK75SHJf+B5h3WHdFHu1C/7HqKZkj2OMVGVecn6fnJunYvbhrGI44BH89KPz/1FHrDVK+1YFjC76mPYd7EqpkYKD9q+OlcxfRkA8JCGag9NTxbrboHJUPHKvfM9dANS569X76511NWrP+OJdRTLTR9ekLkCFiBjVRkyScej1Vk8buQm8ZPdvSPrP4IeG8Ukp0Eh+ARQgCpSTuWpqCuZ1f8u0CFYrp67xXXpPYiWUN8WHCnKLP3+tVgAjqgirLFw7sKZ+zRIo1Vnow3uKAp5tTWsqWR9eAQ7UkqHYa
 Salo5u1E
 A06UaJOsIp/Vmc/S2Yqyc2lyFTiyUN47SLEd6ryT3BM7qVxlwjXBjODJfttZd+a2BSDGCx2h3FBdDgEIqjb3cBUjVyOQAYOaX57ZyGb8ZiJMjLLALYylZVsmHmQ+eAzu3tGyb0O6KMkiNv8r2xEVAX3V9X0vwu2Yup4e4hv5Qj/mPrpJ/QvymAYTuAnWznVyQqrPRjAR6dJ8mH4xUwDgHo+qalUb6zt9gRAGwCnilnJCjitA5vRHfMH200/T/LbTFzhdRny+VK9nq0xU4l8zg/4EnZvU3rnnM7jk66CtaaknqudzI9Zz5ok2D9lCXuXrRL5TyqdiNUmA/WhIpt/N8v33cXBbURPagMs+wxF0gYGjx5WBGyvWYAw3VPxm7BYJox/j6h8oVmBTJcOHq6kBjwkJI/F9i/EGwNEVzmKzpPjDMSbIHHCchgFjXxdpwB6+ii02LBrDAaMgjGxcCKSegm3vxhzfMzVMZET8zfGxmY1SoKS0=
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
index d0a2847a4bb05..1ddf9355a37af 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3732,7 +3732,7 @@ ssize_t cpu_show_vmscape(struct device *dev, struct device_attribute *attr, char
 }
 #endif
 
-void __warn_thunk(void)
+void noinstr __warn_thunk(void)
 {
 	WARN_ONCE(1, "Unpatched return thunk in use. This should not happen!\n");
 }
-- 
2.52.0


