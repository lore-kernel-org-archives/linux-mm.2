Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C322CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A6F8E0031; Fri, 10 Oct 2025 11:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB1E8E002C; Fri, 10 Oct 2025 11:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA128E0031; Fri, 10 Oct 2025 11:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 780FD8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:44:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A9B614039E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:33 +0000 (UTC)
X-FDA: 83982626826.24.3E692AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 902F2A000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GpqoFDhD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rr6xJ3c+EJv9VO46QEF+ZoB4rWgfcJmzisR3J3XhXsY=;
	b=uhppny4cYuWsV6Bqvx76GOw/33DI3SJTqrnzVdmCrleRLjWj742ZAmrAHm8C721x+NAXUW
	NoZlQMmCW2pHjVXdKyNZNfDbzXoPbi9yjqc0cae7FzXogDcXTMK8FBRLvJrTjkPLZaDMT/
	idgrTRZ/gDWr6yLZiF/LjRRsXSMrE8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111071; a=rsa-sha256;
	cv=none;
	b=pu6jb0dkXZY5nVM543/EQznepdMuxlDWcDk3STc3UeKlwLmIRfP51KAR7rpfOqN+wOJLU8
	MywnA9R8nElUmoP2tzhYgy0snLLCAfFXe2hLjl9K5v87fiEct0EBhsbEZr+D/bkQwff172
	JOIEFROhIgOxw2Qj0UEWu3IgCfVAbao=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GpqoFDhD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rr6xJ3c+EJv9VO46QEF+ZoB4rWgfcJmzisR3J3XhXsY=;
	b=GpqoFDhDwRuf4kqdDkVeA0PKGltFnnTc/ELDi6RTYkYFpvO4eQdlj7XVzQp9MHtlah3ClZ
	J6q/3+V69Qbs2tmXAcz3V3YJiQ6dIzgXzOgAYLyxn+Fl0pEfP3ib+lSPtveD+ivTco3hxv
	2IzgJDAUntMEbPOSWy7Jx1Ddt/oLJQ8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-meY_oTX3Ni6d3twePwCogw-1; Fri,
 10 Oct 2025 11:44:28 -0400
X-MC-Unique: meY_oTX3Ni6d3twePwCogw-1
X-Mimecast-MFC-AGG-ID: meY_oTX3Ni6d3twePwCogw_1760111064
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 313C31800357;
	Fri, 10 Oct 2025 15:44:24 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9B8F1800576;
	Fri, 10 Oct 2025 15:44:08 +0000 (UTC)
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
Subject: [PATCH v6 14/29] perf/x86/amd: Mark perf_lopwr_cb static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:24 +0200
Message-ID: <20251010153839.151763-15-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam01
X-Stat-Signature: 1badzmtieoeirt4ob3ikyfjuowxaac36
X-Rspam-User: 
X-Rspamd-Queue-Id: 902F2A000A
X-HE-Tag: 1760111071-777615
X-HE-Meta: U2FsdGVkX19eH+O+DvAYVakso3jVYdfxkK2+WTXCFTgkLWVn2zuRiyf2wZ3w/JVK9VJrepJyTSX4CifUuoQvzkNVcc4F/VNQc9Z7F2tIDNtSBzn8ZeG5sA8NXp0k2Lf6RNtCurx8NtlYBtvUCnkA4XPlSRAZg91A2nXEjSODJ+f/zstOmRvzudf40AlXd4MjbKZE+zE8/StLCtBPs8sm2jPFOXWyCzORog+BF8aMIPV5vnfJvob4Qw4Z906ARTxFvKDeA9Pt3M2DglPQxfSXgkWHTaV5F1qoojmBP0I50+jhB9uPwjTq8cnHfPTHG/NU6I52gt/13Z63Vaiy9wbXUr0et7SlgjOQlVd0OywO2Y/C1Sqytq0EmEN/hxKnSz/TvMQTQWBTKkHrle48cwmpaO/TteaAbv45V8eA9IFT5zFNXmPx1ev/Gqm9eC9vM9melkxaQSUvuB6TDtVmzYsBgZJ4z/Hr9c1rBGgsp+I59fdWHfkK2ghLWuU+GLvBETKtePFD7qSmNH4wavNtrhhmqOO3HeeLzd82gKCHQO+99uwmyEljft33OVcKv5nOXSqrXp92yZErJenKT5ehfLhxfKPTf5081JR8lrw2Um1jJEOll93hDjnBUIbQtiYdqLu0EpEdKYsAokCJVrNjIzxW1CYx65NvJF+Uqc/qYkYPRr1W63MPm1QmcAqkUKzFHB0PFn3ip2UFy8ujYqTp/R6Jex7oQN6QAEGovXd0oegf2gKvvrYyblxbAyT31Px+qSo90eWQ1jb7YMJmzekXDZXY1CWDyD8uMu5H3QleOAJItEZe+Gh+niZ0U/N48hwfJPs2PYDUtO23wh3eMV6SEhmdXdrr7b4NLeMvAhkL+QBXybV4CFZA2vYRbv6z9bsJ8MsajWA3LbiTWLWuhbkhEbDXdNjcLSP/y7yn/MYpsy4K4fshHIQwSEywTTQBqbtjIeFTm76an4Zy5v1hrTV9Ttg
 R3LJ36tK
 eDUR9mKZK+YOCmHFrZ0vkv6KGtCWWCh+2OFxTamdH20DO6/CxivbNEeS2aXeLaBVin6+E02Lr1BJj+taN99/ToH/A3+1GExXuvzFdMFmH+4eaqlgf13SbGmpbyrPlueYcULRbVFVaXTSyOxlIHmDprdXEvRgxdwtjkpmff5NJjeuYOyviGyNIxtuEI4Yc1E8LeYXDT1+Z+MVOgjc0CAUWOYgQX4dhM5R6rY2KvDLCxo0S9vrvxzjQVw7zeq08wg/OedtRV+X6eNCJcSxSKk10A/Mok/WFo8TG5ggGNiV7atUmppguc50HD9xVndZ4GgrimcAjvnv2i6sPNDZlJS5ovESUcDjmj6DloVODHH/bQeQ/sPnw/tfwNVI4N662wJRVwQMoRioHXD0s326B+MhkrANkDd9V5eoKvQmyAOXdJmLxjbo6FUsGRn/KZ4RGO/dWaI9KzTR0zMMIDuCE1Kxmxd7dwRZJWBrreDy5c1IX7kMIR/rdghJg7aBePg==
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

perf_lopwr_cb is used in .noinstr code, but is only ever updated in __init
amd_brs_lopwr_init(), and can thus be marked as __ro_after_init.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/events/amd/brs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index 06f35a6b58a5b..71d7ba774a063 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -423,7 +423,7 @@ void noinstr perf_amd_brs_lopwr_cb(bool lopwr_in)
 	}
 }
 
-DEFINE_STATIC_CALL_NULL(perf_lopwr_cb, perf_amd_brs_lopwr_cb);
+DEFINE_STATIC_CALL_NULL_RO(perf_lopwr_cb, perf_amd_brs_lopwr_cb);
 EXPORT_STATIC_CALL_TRAMP_GPL(perf_lopwr_cb);
 
 void __init amd_brs_lopwr_init(void)
-- 
2.51.0


