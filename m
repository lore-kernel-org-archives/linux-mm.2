Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06968CE7B1B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466468E0029; Fri, 14 Nov 2025 10:12:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4161E8E0002; Fri, 14 Nov 2025 10:12:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE988E0029; Fri, 14 Nov 2025 10:12:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19A0C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:12:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C83921603E4
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:12:37 +0000 (UTC)
X-FDA: 84109554354.09.BE31232
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id C84B3120005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:12:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D5oLP550;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133156; a=rsa-sha256;
	cv=none;
	b=rb6uT6UDMPVjikkvUponJYsg5WRRspQXaQdlvL8s6aBo6CPo1+/VyxWtebUhqKEg0RRvee
	oQHdIwfNgqy6RdFSCQ3Yn3XErfhqvJpn0KUeMYCRZmqaOmJYreyzR/gqy608BheXQzjvU4
	AlP2z3iPfJReonwAMDYuevDHUpAoaYQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D5oLP550;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZ5SyK4DoPKkV4Z0L+pFMHxCyW+tdtvFdr+A8RoV6VQ=;
	b=eOrU68b5kQwJjjzrdApZakXk2vAUArK8WvVaqKJordZKehJi7OSLXDLwrbom7YTSU/X84h
	nsWe0p9hY4xdTQ7On/9y2CqxdGfeEQYVvw+Zes6FSEma8mATRUeYzYDz9XvU8gUShYewr8
	uQc654Snbl4+op5+NGrjAYWQk/bQI+U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZ5SyK4DoPKkV4Z0L+pFMHxCyW+tdtvFdr+A8RoV6VQ=;
	b=D5oLP550FnHrWEBZ7sr5qGgLslskbyHLvzafjSoFYd3nUJjhjzE3LH81MppGhzV1PnTFvM
	k6mA/wgnCr0wcwcO7yZZyyn1A5iJCncffVCHq1zwywyNSn4yPgchCAyhU2O+4k2CjC+8Q8
	X6GZaDsdC6EAR7WiZr6d0IsLisgV6v8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-hYML2ISBMs6U1QZt9CCgwQ-1; Fri,
 14 Nov 2025 10:12:31 -0500
X-MC-Unique: hYML2ISBMs6U1QZt9CCgwQ-1
X-Mimecast-MFC-AGG-ID: hYML2ISBMs6U1QZt9CCgwQ_1763133147
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB3D319560AD;
	Fri, 14 Nov 2025 15:12:26 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB1803000198;
	Fri, 14 Nov 2025 15:12:11 +0000 (UTC)
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
	Sean Christopherson <seanjc@google.com>,
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
Subject: [PATCH v7 20/31] KVM: VMX: Mark vmx_l1d_should flush and vmx_l1d_flush_cond keys as allowed in .noinstr
Date: Fri, 14 Nov 2025 16:10:47 +0100
Message-ID: <20251114151048.1061644-2-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C84B3120005
X-Stat-Signature: t967mhoqr1qfbu1rdm3yc771hd4f5oib
X-Rspam-User: 
X-HE-Tag: 1763133155-822976
X-HE-Meta: U2FsdGVkX1/TSz5lyXpJ3e2aLNIAoRwrqlnWWckVyLAH+VjQz1HcbtL7i1mpkCQgFbB6Mjt+sJyB17LdGplqEY7X8/AAsbMwbU0wYJXf1KwpneDpDDmcw2DHdzDIvYtlorXIP8eHpoIcOGcyYsXf2DcWvQgy2ZAtk+Hmdl4H3xfLwfJHBuFwfQW58SeXOVB3rNz2JNBMUhkb7dfGJNykyYovYmsnyBp/Hj5k6k3W2SyaX+lOo5YQOp0Cq6DxtWEC+mupwsK/i/BEaS2HwFd7y3U0PGZl6+qLLs0uX+fjx0Y3rrF7Umjwz+9q2niO+ljUzALVGi0Ki4rd0GB1dbJGqHs1EsAaB0bBtbJxfOCmCsXjOGKF9hUzhuUwdZLwnXvMYXzioDQwsu7Lx/ZG0w9JoDg1n9MPqBO5Nly1VxnT5BUwPP6q3sSo+cEEMwwxD6Cr35YFdIskCHsNJguTX1LVwi62XARJ5mVWJPh5I6je1AUWafi8TVr76tA6CJl5Y0df7EahYNKFSxaifeUcPmZcLbQTkvH85QWk1qQyMF52fOY8LecIp4GARQOUD5t8+2X1YbIpGbZe19WkkKUvXafbjjf8rlxi7aYYkksJlRme1sfimZRACPERSZgQfFoyLwI94QqZFH81D0ZlZA27mq6lb/F6760B/+0UNpSuTky4Dh9HwCK0Ep6io+Sx1DtMWhkdvxJPrVSlzF3pqF7kzu+xYUWcceUZu9ygcoYUlqjflXDgmGViUSJUYscBfL7JsJHpuoIk8EgR71YbcJXCT5POX9iGO6rHFkTMkEPcah0YTDwNxbAOfWRNV7EZRsPM4F8TYpk06KLeUo8Bzvp1m5l3c/BwuK/eavCl3HKlF/7Ef39rlrymwlwhFK9L269XhEYM3VNDqBNNqbiT4/1lJxR88sCtDZzB5YXiAFZOV09wsShzd2pKbMjC+ofolPsRF/TPchDQxE3pJc4REkZir1e
 sd1vH4J4
 9tyvAQ4fPmQ6ACoqYX0rVt5uCZuQzKdpLLUuJP8xHU8pCN2S60ExyOGte66HEE6tG4PG5oTsz189T6ySqwBv1tMTx2wPwslADMo4hB/w/RtIJJfSMXZQWsggDJMYoXD/2V7GENRMsUEqNVxj5JQ7XY1hk7EvPVFK0sA5SBakjB853eY/FDFwjcdr2D2DqGiswuE/bKSedQBZ6+qcfHwB9gKfsSeBgk1UAndNy1BZeA4+ykwyQAujQktT8xp1Z1zKf4RwRLOGh/9Syd/Xau9H6jdOhdLp5YTz7Xdwmqw+yrPMOg4/bfF55aTtJ75vEE2clzi1Q4vmAobBbNMr+lWi0BZwjMFKMPDwEnTGH8rY60VRlB5tCaXxDdchIWwVWYUa/1fCOBZZyowVq+jHYrkPx/d1+1id6XX8bPOVIr2ATJZKfEX0Y0D8JRSQ77iJ8oQFbJFUNabodY9/vP6Uh2lyCKqvJGIR+PfJvHEkXRxqszJPStIvwsaZQgpLEzbwtPp0cbFhGMspa+I/+3TA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Later commits will cause objtool to warn about static keys being used in
.noinstr sections in order to safely defer instruction patching IPIs
targeted at NOHZ_FULL CPUs.

The VMX keys are used in .noinstr code, and can be modified at runtime
(/proc/kernel/vmx* write). However it is not expected that they will be
flipped during latency-sensitive operations, and thus shouldn't be a source
of interference for NOHZ_FULL CPUs wrt the text patching IPI.

Note, smp_text_poke_batch_finish() never defers IPIs if noinstr code is
being patched, i.e. this is purely to tell objtool we're okay with updates
to that key causing IPIs and to silence the associated objtool warning.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 91b6f2f3edc2a..99936a2af6641 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -203,8 +203,15 @@ module_param(pt_mode, int, S_IRUGO);
 
 struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
 
-static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
-static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
+/*
+ * NOINSTR: Both of these static keys end up being used in .noinstr sections,
+ * however they are only modified:
+ * - at init
+ * - from a /proc/kernel/vmx* write
+ * thus during latency-sensitive operations they should remain stable.
+ */
+static DEFINE_STATIC_KEY_FALSE_NOINSTR(vmx_l1d_should_flush);
+static DEFINE_STATIC_KEY_FALSE_NOINSTR(vmx_l1d_flush_cond);
 static DEFINE_MUTEX(vmx_l1d_flush_mutex);
 
 /* Storage for pre module init parameter parsing */
-- 
2.51.0


