Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC5BCCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95328E002B; Fri, 10 Oct 2025 11:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46108E0003; Fri, 10 Oct 2025 11:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90DD18E002B; Fri, 10 Oct 2025 11:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78EC88E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:43:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FF261403AC
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:09 +0000 (UTC)
X-FDA: 83982623298.16.B92E2D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C9031C0017
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UMQMFxrj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DO8qqKK4diXeF6daiShABtCSRiMA8DgEa8+UbYALx88=;
	b=rtja6zgRGRqjaS5R0ifC3stqDQssz59Q0c1z8UlU5fgeUXG3Z9ILFmH+0tZCP7kkGOdSc1
	PoAOVV5u3U/dUI3rFCuj+o8EOsOt0cTM9no01RJGdKjDJGzSGaVcxA9vo515ppaS6wZVuG
	Z4N8tukjgvDdsFyb5hdsmJg3moSydSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110987; a=rsa-sha256;
	cv=none;
	b=o5yg2ZrRoITJ7lrUp3sBa0i8/l7MoZpqdzH4ULVftQCiDtt0JgOQ8+8D5x5WnP4dx1g37F
	R3lron6yEUDPtSb39GlT0PIsz0SHqSDYba175hhajRkai4PMX5yNKyYBqnPwN6pT/SYJpD
	5XkCPRtvElgxqVHcs6lPrl9KpL6jFbM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UMQMFxrj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DO8qqKK4diXeF6daiShABtCSRiMA8DgEa8+UbYALx88=;
	b=UMQMFxrj8xl05lBsxC1WRnDx63DufAfKhgOJUBDMGyir6pFaFpDdFXWQ91ILvYx5Yvswo0
	uJHwhIZYi3OxWT1siS09uzFgGF2Lyw9ImTXZmSChYopDlEaxCoBiqo+cnQypxvjsyRusC5
	UlY7cFvS3mS69KnUu80Dnj6gzVgXAs8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-m4LwkMHWNBWbZvkPqwP3rA-1; Fri,
 10 Oct 2025 11:43:03 -0400
X-MC-Unique: m4LwkMHWNBWbZvkPqwP3rA-1
X-Mimecast-MFC-AGG-ID: m4LwkMHWNBWbZvkPqwP3rA_1760110970
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8A1B19560B5;
	Fri, 10 Oct 2025 15:42:50 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81AC41801AD8;
	Fri, 10 Oct 2025 15:42:35 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 08/29] x86/idle: Mark x86_idle static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:18 +0200
Message-ID: <20251010153839.151763-9-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam01
X-Stat-Signature: qhyfm6z3ocdpmbhcfatkfftguoyy7t1z
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C9031C0017
X-HE-Tag: 1760110987-222128
X-HE-Meta: U2FsdGVkX1+uWduj1oFIiUN6IhSv8AhFm3YAv7IyN1bK/TLHJAv9y0Y4anYv2Krfa3EdJ7I3ZR5KtwTDFWiWyY23WJvZt21vLxrrFCL3NCBe9govDPDAgYMHFeayWR4otkmihrM00V4IbsfXpA1taN1CuysFdW53FddfdpMRgQXnS3g8kSjLSRMCcUoqbVO3fRitDtJ4AWs+ABzjXGPNQabSwAZl+z1Un8O3gayIXxHeLvgWs8XMnmlZFX6+JvbBvmEIIqw8IYlTMGn3Up7SNmCImr07y7wMmOdrQdNfGu47FzDhudVMWLh9W2sGQw6qbsgKFCi7BblylhILg38rTVocNDg3E/KmawS3HjGrUa/IwNZ+E5jWxY7XA8sM6NAOoj3Y/NmU7WdTKrA3CxiA6Enb8rKxspE25K6jViuHwxyGr1WvCuPH+iT0c285ibrGRTR5giUmQ3VfY/MedOqesV0yeX3bmC9yYkI9TnrQ00QsGyOdYNW/wXQ5lQETgsLRkoPnTq8QGb8l1znBHHUfLp7el14JYtac2qgOzJbKuYWXqOL/j6h2QMnCNBXPTjSMpl8Khjz4lvEYRUm4ASQLeiYpML1TkqQgxxT1wmKVdn6Zl1YZW8OxVVLCNba30Zys1FvEgZwEQIFr+UORHKk2XjjLbcNFFWZQfOUI2F5R3i4bQ5IguxtT+WyvKB6TEkjNbgJTOJcvR2cc+YfYWBlfgNiPvGj2I+Nme1msWTczJ1lqsIWhsU0fOAaCWH7XLcVQCcw4S3KcX6sQBRSPsUlbztPxB6yvU824E+CJYJQ+iKSTl8DjZ0TL1F2mV7sgyI/MH80dx3T9f8QB26rNcj15/z2JXgzkYc5Q6raz1nFB15/6zWj7rDcaY6Fy8UCQxtZxWeG/2nhVv8ecAcr5s0LvAYe1TsNqcI71pnmNgjhU0DXpOM9WYeJVeFLFA6mh+Yl7CVZ/4mhw0zKtbkO6Bhq
 AENCPXpW
 iBUt3dJ59YK6T/7L5/G/1lWmSEwVtcu81zIB7oP1kp/98Y+uFWYHRy+KW4hygct92KU4+mQn3z3rbv/AyZLWjcke1BhLz/FwlIM5gKu1zL4MbjogTGPP0ZYuZzDI0qD//k8h+hTimeoSDgPWAzEslMsTpnCukHZv0+Mm7Mjmwi5hCvOtKON3BMZnfT6mDS+JE/ccaHpG4mxf7hlHc81tK/DB5jpT4K2ugDrde7wBIyA/Q2/mQAgJzEqX0cIhibLxoj1Hv3JVbssANH2oeSFLEm91KrPtgb4rwLSqwCyEVW2/lzJj4bd/OJcSWVwyDpRzmApImsgo6Sb+kdZ+YSsS/EVOstaj+4CZBqUwP5oZrs3HS/L2k61f5gZqAiAlUnQaJA4JbEeXAsP3lK32Qn8xHndaUimZ7bEkyPQOWK4f7BagYzaE6zSh+q3/r/HzDqQms8/RMUPy6J4T2fMrfeWVdcC7lmXCrMnD5eUnVsf3+wjewsEPRP8doEnENEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later commits will cause objtool to warn about static calls being used in
.noinstr sections in order to safely defer instruction patching IPIs
targeted at NOHZ_FULL CPUs.

x86_idle is updated in:
o xen_set_default_idle() <- __init xen_arch_setup()
o __init select_idle_routine()

IOW purely init context, and can thus be marked as __ro_after_init.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1b7960cf6eb0c..1c2669d9b0396 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -761,7 +761,7 @@ void __cpuidle default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif
 
-DEFINE_STATIC_CALL_NULL(x86_idle, default_idle);
+DEFINE_STATIC_CALL_NULL_RO(x86_idle, default_idle);
 
 static bool x86_idle_set(void)
 {
-- 
2.51.0


