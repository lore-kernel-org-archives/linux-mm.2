Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 155D2CE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7378A8E001B; Fri, 14 Nov 2025 10:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70EFF8E0002; Fri, 14 Nov 2025 10:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6265A8E001B; Fri, 14 Nov 2025 10:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECEF8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:03:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 184C71A0346
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:48 +0000 (UTC)
X-FDA: 84109532136.05.5F25D89
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 19312180026
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TaM4c6Ev;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132626; a=rsa-sha256;
	cv=none;
	b=ltbI6ELbEucfW+S1wuDsg1ukfyoRunmIpOrLxE8NqRmfjdRgYctGIgxuOmj04zCNq61Ub5
	Db/2OjFY8Zqru/PygCyBI3AK2B7A57hBW52chrw/CrQdy10YfqCqeQA5MoDDr1AAygErwJ
	l7fpFDko5zVvQK33dklx2D+W3hsFfaU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TaM4c6Ev;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypuA88VHIrtZCycTQvLRbp4fTjYOiPnVr/lgVBnkLI0=;
	b=A9gu9LbnENKz4LMm3mHAAURiJSLRuhExf0W24ip/t3m858exn00HDtH4loJWWBoRanOWfl
	bIEbmZAEu7aYhjB1K4CjiiXytpAdgD5MJI3VaMRX1u6KISQQKICmr/1IvYh04CsvekNggC
	saXN3kJt0vPcBDtyefdfgmdPE7kWxuI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypuA88VHIrtZCycTQvLRbp4fTjYOiPnVr/lgVBnkLI0=;
	b=TaM4c6EvL7KFofHorfGAYnzqmJQr53N4DT+JMhqP2UH2o9RtwRTIsajipvd8opOq7HQTV+
	eiBlBmaYpHv4ahn371QhyzA4ZaRLn7IpLXAGkDe5k/iDUpUh8k+T1vfsWqHKZvwNr8slH7
	ZcJ8wbJFOTXmDdkTk85ScWKmjpEGIAE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-SKUOVx5hNtSa3DHoze9ZYQ-1; Fri,
 14 Nov 2025 10:03:40 -0500
X-MC-Unique: SKUOVx5hNtSa3DHoze9ZYQ-1
X-Mimecast-MFC-AGG-ID: SKUOVx5hNtSa3DHoze9ZYQ_1763132615
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E500A18D95C7;
	Fri, 14 Nov 2025 15:03:34 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA7DF1956046;
	Fri, 14 Nov 2025 15:03:20 +0000 (UTC)
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
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Subject: [PATCH v7 05/31] jump_label: Add annotations for validating noinstr usage
Date: Fri, 14 Nov 2025 16:01:07 +0100
Message-ID: <20251114150133.1056710-6-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19312180026
X-Stat-Signature: 4gmd6pcaeads69tzica7im9iugn6sq95
X-HE-Tag: 1763132625-553983
X-HE-Meta: U2FsdGVkX1+smzYpjOYLSrLPh1ul4xXIbgZCJsGneWgDRFv8vkEaNQ6opYq4dKZTtNNcVAdYjwZgzAClasYdKofdyol3hTsM4QfC5NxpkySriE9qFAO0tAmYitPtiG68SAk4pVPCU4Z/3SkynmUiLd5f1TjwD11TIeCAo6ETr6nvKLPQE5QeQh3WijQK1893goX8omrwQ7b9OT6kRrHZ+l+8/7JUBeBLvslXkN8DA01jPgqQbim48C6fEWobP0N8r0+VN4IaBPbSR8gwWvsC1JuZndaVLFsskSKOkTd4kctsK8OnGZuaKUBxt5vTMkn9/0ACdnYyeDhnrFFXFnGPIN+6u2HJ4JXYvfFc1t0vkrQ4k6c/2lYQuwWur+SCaxENoEpAvwTtcxjRtMdOZ7HcCDsfNSukuA6dwoGBbMlj2M/tKBQ5DBh6YSfnQ70FxYsXZ3TMF8ycOv8Gy0c6D35jWSl08uK6F1JqgfK84HxyZ/ZEJIo4nEPuD3B0RzN9Lb8Nq3koEppFuGsRyU5FpV77ScOLav9D6IuCsOHwNpDeOmVzJLdJAQicVH+jKq3h7QMUZfnxlcjEfqbUtDCXe35I+aFxZpOzQCGzEi6ayCdUCukdfEh3lqayfLSK7884UUc/QMEnsjRkhz6/gmdo6p7HwECwP4LAIiG1x/qGiHAP39YVwfpRRziaeSvUmST1BDVIBIRnMEyUbjFl2flFgqVuMCLIJfADPUIs1LcIr2tWTF3avLlcyf8avlEV/3fFCnP0OfTdYw+/WaSSNQBjbFSuFaiK6csdbYoDQBMayIrM9rQff7zRmCWtLtygf27JXTMnGLCl0NSYJqtULzN34YzWFVowmgUEvKigSyuIw1ipTsvyV9bDNtnwFbKx5S+Kgvb2rcRUXR0iVLBXLS4HJlVefCxyEDnDtKFK5yrl/osy+lylQpaGBBLsPsct34CZh5oCNnB+xpc0YNvz1jPUnIt
 NrDgRkzA
 lTtZiLvDUXAMl79OybMRW1hEnODEdQ3cY4wt+IErcFV2UNqHzDhPZA7D7vdKM3wI7pWDeR/stRo7t1tZL9vsYMWbCQhCLFoXcZ36KLbvXJ3U6kkcHI2Y2K9AgHejffcHk8hjue2hwfDcksKlK9uT2Y0PX5MAtxgSX28Qs3JxRLSAMxuaVc6c58rm6YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Deferring a code patching IPI is unsafe if the patched code is in a
noinstr region.  In that case the text poke code must trigger an
immediate IPI to all CPUs, which can rudely interrupt an isolated NO_HZ
CPU running in userspace.

Some noinstr static branches may really need to be patched at runtime,
despite the resulting disruption.  Add DEFINE_STATIC_KEY_*_NOINSTR()
variants for those.  They don't do anything special yet; that will come
later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 include/linux/jump_label.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index fdb79dd1ebd8c..c4f6240ff4d95 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -388,6 +388,23 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE_RO(name)	\
 	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT
 
+/*
+ * The _NOINSTR variants are used to tell objtool the static key is allowed to
+ * be used in noinstr code.
+ *
+ * They should almost never be used, as they prevent code patching IPIs from
+ * being deferred, which can be problematic for isolated NOHZ_FULL CPUs running
+ * in pure userspace.
+ *
+ * If using one of these _NOINSTR variants, please add a comment above the
+ * definition with the rationale.
+ */
+#define DEFINE_STATIC_KEY_TRUE_NOINSTR(name)					\
+	DEFINE_STATIC_KEY_TRUE(name)
+
+#define DEFINE_STATIC_KEY_FALSE_NOINSTR(name)					\
+	DEFINE_STATIC_KEY_FALSE(name)
+
 #define DECLARE_STATIC_KEY_FALSE(name)	\
 	extern struct static_key_false name
 
-- 
2.51.0


