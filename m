Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F36CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174CD8E0038; Fri, 10 Oct 2025 11:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125F48E002C; Fri, 10 Oct 2025 11:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FAB8E0038; Fri, 10 Oct 2025 11:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFC9C8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:46:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF1BF1DFD21
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:46:15 +0000 (UTC)
X-FDA: 83982631110.18.0CAA38A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id E9E73C0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:46:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnQxuHix;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111174; a=rsa-sha256;
	cv=none;
	b=NxynhjBZSsxnaX8AWrBN68lWNj33HJAfJgtWiigFKb+M2EcKdXkp4+XmxGBELjmUYUqzVd
	KY8Bcdb1m2anX2LoeISlpjbCxIW48Vnm+asgC1QZSTvT0dcBSXZZmjLJeYrguLsBXxkXQU
	qWzuLDTwayJbhh9D3PjN0AQsEXrUfkI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnQxuHix;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iD33w+Kf1PLBTVwd7Gs6fvxUpUzwmU6xc5WkYASPV+Q=;
	b=Ko3pD18jaV38b+g/RpIhf4EKrQdgjwEtrms/yWf9bP7uGNRsiM6pHyiC10Yh/JXyFvdH8Q
	6GlEEAZtJc6JzhZl3XKEeRy73m8oyQ1C+9hSrr5bXBBipBIcIo+pmaflPBLqgYG55SYM54
	12xvOs8y4O6fKIVqonev8yZziP8yGoM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iD33w+Kf1PLBTVwd7Gs6fvxUpUzwmU6xc5WkYASPV+Q=;
	b=DnQxuHixh+d/pfaHwKbJSkO4dJqY1LCVXadsxVt+tfuGpT81rWBl9e8hnxpEtGK+2/1v4J
	jCz1Hvyn6KYadd18cd2tCGnJAmL4Fm6riB/DK7cng/YIhqWaKk7DgtBEXv65wG4vAEIs0R
	uyPN+HzaB2VlboJGlx93PZUUybMwjuY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-YyfYK7fpOPCOQwG47iM_TQ-1; Fri,
 10 Oct 2025 11:46:09 -0400
X-MC-Unique: YyfYK7fpOPCOQwG47iM_TQ-1
X-Mimecast-MFC-AGG-ID: YyfYK7fpOPCOQwG47iM_TQ_1760111157
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCF321800290;
	Fri, 10 Oct 2025 15:45:56 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CBC601800576;
	Fri, 10 Oct 2025 15:45:41 +0000 (UTC)
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
Subject: [PATCH v6 20/29] stackleack: Mark stack_erasing_bypass key as allowed in .noinstr
Date: Fri, 10 Oct 2025 17:38:30 +0200
Message-ID: <20251010153839.151763-21-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: pxypgbpqf4bgq4ix7rof856tzj5ngyfm
X-Rspamd-Queue-Id: E9E73C0002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760111173-36007
X-HE-Meta: U2FsdGVkX1+vQBcdV4BZgqjrRCHNQNJZwQxgJ5vtrHjR9Uaz6R+Mk4nfqxq/NV/2s8W0yVzdBnlrSBARsa/f2kh7t/oas75CtO0fgtuth8de/TAT4raTDO79BZUJhs6UrYGMWgYR8t7/YRxWBfTcOSvV9497EMyszG4UYhKpua4AA+ClfJRKYSNwcQeiaAGc8yE6jv+IWFsh1eUTHULJB/Xs/hywjbEzk3GaaCza8O33XsJ2nWp++gN2WOjKA0Qr6a3QGgjc00agUWuGJrdERFOWssxWAfPeN4CI0CBWyD6KOBCiVFVqckLMNYYghOzbANEUrRPaMD+L3MR44cKt28IyfvRDdxV5S8UmSnvAHo9la508TYnm0okx1u8YM+8ROnUcaA2l5gROcYDZoGwYmwcu2u3KX8D6DVDVvJ/EWj3hGRSdNcDr5R86UEtfoZpAGV0OZBWchFGQBy7TxAwAX3JPpWScqJ0CLdxh/ZP1sJNPKnQvLaZcssw14MHcyCE4E7XDQSDwmeQRTP76ykH+z3wV4XdO92MZgLJ7TlZwy0o+Ya1KMSOL6yzaUjg8eEmPvelzD/PKi56z9/qIeuKtwMYcL5ICPQx16074ch79UCh0/tt6MJLz7nVjWYd2P8fVc1SPq4lVl6ovop4V8aEPPlRBTJxaaYJm1Fj3Ot8gFnN5YwHVEAxTQe7ABnvBybu76RJPuOFaOwZduH+rmgfmrXosgL+7lYAACblyQPO0VGIvd96/zXtZD74BbJiMU1n44zYBgtIINys2CUJ9/N3NjuDT7xQTaN8k3cg+1xVLq7hoV8YHSvUegqo88AVj4w8FCWqE5jsvUTchN4LIEUNRE7fQ1fXttmkf+xnZTTxzKQqCzHabO4paA+kOQk/sI9KClU3CxwkFCXJoWeFmJNK9yaW9UpBDSpM2+ith9lIChCcRVFpX/qYW5LXb9Rq3bjjNokZ6CKq37RXHQtgLfFY
 t92YS710
 JVfaUCh+rP5Lgkb+QSwU3cq8ePItvmhMUmcEfX6aFx4HvXMGe+U4hUd3aXlxBrwDFIAGMFsNAfrqIsSOZFHhVBPaaMTjlGF/j0eG7NvIxmjLpuufxd6cTHPK7Xk4MYX0JvwSd+QC+fUT3uf1fDtQTDwAseTxwcRUh2vW7j5jlSdtOAVdK9GDPvsJPHGZYRwoEWYekyv6EB/m3MM5KvohD8j7DPz/Q7siPeB8K2piCcw0PVE7gbf79Vt7oCzykE8qDo6PB1FTIyw9P8ywGPu9SDpgkjiH2zsnudcdGWrZjxxJEAcoxT5sufJAbL2oDltJUre7OvTKollEjhDRtBLwsFXFqcOmkZ/Y8yAQ5axuAaLGHO4vfbSZ+8XhZ7hkyt7yK61Ad9nCzoracbBGNRyH09mfn+Y0c45VbWtxjBP76iX83ybA6oDr+i0ZkeVwgxuRPdwRtOylOaJnqKuIPkRUKKK2PO6QIOqj2Xuakg5wUBu8I/iLQGLkJnk2sYA==
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

stack_erasing_bypass is used in .noinstr code, and can be modified at runtime
(proc/sys/kernel/stack_erasing write). However it is not expected that it
will be  flipped during latency-sensitive operations, and thus shouldn't be
a source of interference wrt the text patching IPI.

Mark it to let objtool know not to warn about it.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/kstack_erase.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/kstack_erase.c b/kernel/kstack_erase.c
index e49bb88b4f0a3..1abc94a38ce14 100644
--- a/kernel/kstack_erase.c
+++ b/kernel/kstack_erase.c
@@ -19,7 +19,11 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 
-static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
+/*
+ * This static key can only be modified via its sysctl interface. It is
+ * expected it will remain stable during latency-senstive operations.
+ */
+static DEFINE_STATIC_KEY_FALSE_NOINSTR(stack_erasing_bypass);
 
 #ifdef CONFIG_SYSCTL
 static int stack_erasing_sysctl(const struct ctl_table *table, int write,
-- 
2.51.0


