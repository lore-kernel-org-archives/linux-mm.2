Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90346CE7B1E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF8E8E0027; Fri, 14 Nov 2025 10:06:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6B38E0002; Fri, 14 Nov 2025 10:06:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCC18E0027; Fri, 14 Nov 2025 10:06:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC2FD8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:06:37 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4923B8F86
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:37 +0000 (UTC)
X-FDA: 84109539234.09.2771832
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id E68EA18000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=htW9Vz04;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132796; a=rsa-sha256;
	cv=none;
	b=DFPseGddCJYAx7n836KGF47+hckw0CKGvcjO20nQvXyhBJ3bSuOjQHQR9cppJ1CRJ30xbp
	0NHkvLVEo9JJDx8RMWlNkeiYLEnywvbiGmbVY5YS7zyH4crFkdvzjwGfyK41+KrIlOqbI+
	moZRGRLnhiwPcxsIOjNNllf5OH/oU0s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=htW9Vz04;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0EVYMqufOoIHV82nAeE2u6YNjD+PUPB4KvH6NE2Jsio=;
	b=VAuumgUaeTuN2ISDkjuiAGcTgHhVRqWFquvTxHekRo1y2HNgJDpEBracBIkaJxdeksg2QD
	MnhLiORCfXqv7+tVE60BqnQr0eGFPGthF7V/w5e3G3w0FlefvE48XUx48CQjKAzzwpLJYd
	t7QsYhRcQ/L2OJTGAJdNZxtZ/3RRViU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0EVYMqufOoIHV82nAeE2u6YNjD+PUPB4KvH6NE2Jsio=;
	b=htW9Vz04YPShMoSF15pSEsSZ4BCiStOSl2PG9QHv8UkTNd4TQpuQAUE78RBwVALAa2sF5g
	5y5xqIkjD8Kn7HpaiimF4TBwmxXm2BTcCxicTDSNvAuJoascmoqIbYSY19i9f0JVMvZW/5
	ZHfRR8Ym+6TvPQBXhgHehdRLY/LzMwE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-cI01Fc2gNgiloAaXk9-ykA-1; Fri,
 14 Nov 2025 10:06:33 -0500
X-MC-Unique: cI01Fc2gNgiloAaXk9-ykA-1
X-Mimecast-MFC-AGG-ID: cI01Fc2gNgiloAaXk9-ykA_1763132786
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4213318AB432;
	Fri, 14 Nov 2025 15:06:26 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0671519560B9;
	Fri, 14 Nov 2025 15:06:12 +0000 (UTC)
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
Subject: [PATCH v7 17/31] x86/bugs: Mark cpu_buf_vm_clear key as allowed in .noinstr
Date: Fri, 14 Nov 2025 16:01:19 +0100
Message-ID: <20251114150133.1056710-18-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E68EA18000B
X-Stat-Signature: yeggkmt1rmwghibrfyd7eobfbp63ouft
X-HE-Tag: 1763132795-821047
X-HE-Meta: U2FsdGVkX1/XreyH0cJVU5YV0j3MARZUHa7RImKQ9FLRtzSE/Xes5ne54/enknBj+ShpMvojXyiEmz2feCFmxHNmaDOgPcUuZYv4uSJvzGliM/X+gjf4FmjfsNddkYY1RqBh2FQ9zgw36EGA1+xAIX3FIqdzJswUgISIpm5MsQmoxIV9lGiNaWJhmKBnhyMTr8PdMJ0+rbvNOREWmMqaBnsSTxWY9cXJP67vChgO9ep/ZRy+VYieP1RMNPXctcYdqVXeyCCg6phHSP0iV729C4gKDlxbRJ5+Gm44vALFUPn5HJoMoa4s/8hBLG9jMLDPjRdwUaEq7ORGeoKdPEpTeBh6BSHSwJEBNBfv27kbFPd4n2BnXEmwnFElX9sjMonZbeFdzEOtY3O6ybploKKiXHoLeJkn/jRX3YiAwe8uPy25zLPZUiuU0QYRjrF7WTb5iL5IBUjftxrzgtY+oDF1dwzUqDnY6QE2i7Lx75xwdiqHEmF2qHHKXQ4Sm5dcFv7yTCQeUeNriTPUnLAvM6vGkA05FGTKFUkKKVMwGH4JgjHHlIDcTpeuFmMPRc/2Jrl/grskiwrAwREDaNPYA+DWF1RhCKjMpAv0xaezOYkbqAAO0aqB2tMsrBEDfjslBgqi6PPhs2m47tQM+oJ0avnzPnsTsz5NXLQcDVZ55N+hUfkeh4Iuv4WlcVcxHN81Z5k2D5kMGHD0kHKgFAyd4tfziu1Vvwr9Pyy4viA95syjjZPtXn6LpwrBBLppRze2GAIJgJ9a4DBNochjfbe4RndVozSs5mdt0E8qlnbWXDUMy316cLclkQicJjLkUYO+o/eybJRB/YXaDKeW0fiC1rpaBJtKRNiqUaRMhXEXndppWz4c8LYtFuGSsBlHryqkjJ1dhDDiC0CuCh6b/h76270JDopXikaqwX/befo85ccaCw6WLJyWzbk8z1r7kL8IsUdXYFBMjf6/kl05m2NjJE8
 EacV0oWG
 JaXRMarpe2VlD7DQqPj5F/CZJZ5+JiY3Kt1D4ZuOhoIXlcdgOPIykhLL8MHYFBtYEpbYRMJacF2P6amEKi0q9d+FRQSFUNQlTQRiwfndRq5GN3mEdv4xa39Y7J2QtkMMCvB4+7EEo1pI5Hp1BKYIFCIbtyxujrc7dQChE6sbtNLVd2agxQIt9B0g3CjsWhc/wYSDYVc5fj7Ua2DKIpRUWQCo5LGjO3ohmWZUK/YKlf4SzXuo1dh7cyLU8oxUTu1gOlioyty0VVf6LTlKVclDvaS7QKuR/oDMy8lWtjXbOm5BGwxy9UK/FP9KNfOHL7EYotrwbF3yeS/bzcD3M2r+Uldkhd9EjAJqTe5C1x0lVLndnan4wsxBTxHIrlMU0F3MOA75z3j4wpPOX9W+WnOK/HP5wK3wvzGTJt+yBBCVBLkfreF9ECtokX5Fv3bvGIP5AhwG57YjxAYms8S5iIBU6O8GJKAA6cESBwn+b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static key is only ever updated in

  __init mmio_apply_mitigation

Mark it to let objtool know not to warn about it.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/cpu/bugs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d7fa03bf51b45..a2d7dc4d2a4a3 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -196,8 +196,11 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
  * Controls CPU Fill buffer clear before VMenter. This is a subset of
  * X86_FEATURE_CLEAR_CPU_BUF, and should only be enabled when KVM-only
  * mitigation is required.
+ *
+ * NOINSTR: This static key is only updated during init, so it can't be
+ * a cause of post-init interference.
  */
-DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
+DEFINE_STATIC_KEY_FALSE_NOINSTR(cpu_buf_vm_clear);
 EXPORT_SYMBOL_GPL(cpu_buf_vm_clear);
 
 #undef pr_fmt
-- 
2.51.0


