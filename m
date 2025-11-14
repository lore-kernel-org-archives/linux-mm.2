Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB0BCE7B1B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C058E0006; Fri, 14 Nov 2025 10:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F38A8E0002; Fri, 14 Nov 2025 10:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E25C8E0006; Fri, 14 Nov 2025 10:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A54B8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:06:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE35858EDF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:54 +0000 (UTC)
X-FDA: 84109539948.04.7CC1BB7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2453B160008
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:06:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=igKtCKLf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132813; a=rsa-sha256;
	cv=none;
	b=JqaX4ZTS7EPq76fXdSEONWFmsmsnqmCCSrEJRfbD5P0ncsgS3EclknBNzdoSuuiblNQtLB
	xDMM9sm9hTKbwvQTjh3k0zDlYkaGWyt6wuz2eDreXM0PvwdyTAJxzPez/Y1MY5uL3jDuQy
	K54qt480pNmnhyUa+PcERMV8d327z5w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=igKtCKLf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPe85wKAQS8nAPbz9O1eWBHIVRYgj0iBULMk7IyxpE0=;
	b=3Z5/iDvPlaQGweBAgnFcE4AQaGcdENpZO/T0AVUHvA4Hq/gvm0KU8w8tBivTqltI770U2d
	17nRokXIj+YwpcLGoc0E+RyU6MYXGH68Jj3ljNFWjTOumdDzBmYfMTTN6gFNchddkNgYhd
	AAc85JlYmAtXC/ZHDsObZyDSWLRJD9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPe85wKAQS8nAPbz9O1eWBHIVRYgj0iBULMk7IyxpE0=;
	b=igKtCKLfL3onsi7a0GkwqXb1Zl6n9JamxhWFVN/oeh7JJts0S7ZxiPptvkv8CD5VxsxMwY
	ZAGSVPaiHM6Ilh0sAnM8jIh9egZc6Zxbcn+ZOyHJyWDMGW3nERTH00dlwIVry+wcXMT1Fe
	mD9mS6mHAk+6aebehRpjBZM2BMOklVg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-101-LEviGDC8P1mJckMlf_MqCQ-1; Fri,
 14 Nov 2025 10:06:48 -0500
X-MC-Unique: LEviGDC8P1mJckMlf_MqCQ-1
X-Mimecast-MFC-AGG-ID: LEviGDC8P1mJckMlf_MqCQ_1763132801
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9FC518A1AED;
	Fri, 14 Nov 2025 15:06:40 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF9A91956048;
	Fri, 14 Nov 2025 15:06:26 +0000 (UTC)
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
Subject: [PATCH v7 18/31] x86/speculation/mds: Mark cpu_buf_idle_clear key as allowed in .noinstr
Date: Fri, 14 Nov 2025 16:01:20 +0100
Message-ID: <20251114150133.1056710-19-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2453B160008
X-Stat-Signature: kbcf986eb43z95jixi8tr4sujtshoaio
X-Rspam-User: 
X-HE-Tag: 1763132812-764669
X-HE-Meta: U2FsdGVkX18kzGPv7DR/8veMZwds7Esr03L5570y2UX8oJkQRuh9/vMeQOX1NknsqHkvEfTUNtDYocD/O2ouMYM4oEHMcbCCFw9NcyxsFSfzjGJPbuMy8yHh9dlHHSWZWIz1Io8GMDRN2w40erR5EnZLKsxM5VsSyUjcONFFYAXm/MLs4sY1sQCuYf+5LEzLndHcNknFyNkDAg0GFZgG4pf9Ut2gv+M4VRts9Dp+Y7VnE8LFO1Y1zfNAkjvn4MHofveRohmwe8BCnj96tIfT/8G4hEbEn5RHj/JazXfs8rGCNYC6LoWJz/fG+4VnxwCmJTGTBPtSmRXMC3WCZkgLWhAcebjpDtuh6wWS+7HVcG93wfaAERlUu9D8U6n4YrF2Wsny7dBMGkgFySzpKE5xiipCqxX9o+ja7KnEO5riqIGHXjjvdw7jjCd2OfZBu6Nzchdumtuq7z8qaOHs587+Wlr+H1ePmbmyQuneP2wRvo9o17YFSvI4/2HKfrWktuh+gG60ABf/jpfn+k7r4hZQ2r9tBwFHNtvVr4MBqfuiS7hb51Qe6TNjF8fwbliKtsghQNu+AJeK+TUdCsEWuWvfn8+NWjWLq0au2pRmfXGkYka4rXLC40rwcbDlBgGswLq6I0eBIthLWJsR6KGbPIyg8hkxtlrj4cpOph7txAFfm9eNRFBO12eqoqLTgmYduR7FJtdG/3NmM1o7wUMVJg1zYmc6AEHqnLrBLEmtifxB4m+lhXIURQjjpwl/SmhdPBjruzvzxka9ekDDNFozVUHCFEnShWK6d5cUn/AnHh6jvBVyxoIeuUCBMlkN3jAIac0EiHsMwGqwUphD62/PefVbDpbxiElxox/WM4KIf6njMjRFum3aYXmhTe6yGJrtLzlC1nPfCsj4zU7u+ZtEPTPHvXYrkzeYabDF7Tvadw20+NO2Vljv/f+prQl7z9qMhi7yp74KlzNxlziAcIOFtCJ
 x3EZLaT1
 BE6lDI7xcmIUTLQK3LtR7WGhLxU6QX+sF0DJmiFsHMwJbP2fII3t10tTHZYSs0pR4mQYxjcJ2lfgnrbvUNpbYRwDcfKB7X00u6tGJbcHuRj9fHKAjtg+x5rDOTi4c2KU2wUx6OUd9kg/FRmFVR/nHRbwPrQ1BJ/wluOv34SwPcm3ZYV8VgdSqv5RTl7G6XKQW8sQVOQkG5dQ1lYT6v8byem7Dq0mGrsqtXakCShdFcDehlqxfsZ6gQj6fg9SYXhR34SgPSVJQXdGKFyD333/pZuOIqs887u4h90tL5ZVbPDFxTqR1zNZp2weTPe07bhn00Zzm6u9ovioI6RckOkPwOXlBHIa+sSzCiC4ni4yQYYO2+0o40m+1kke6Y/Mrdgt+YGf9+Svq38Btin4IyccLMkbiX23dhVJMR0aetUG1oJBwvBXkymdseYRe220iybr0IR1G0XGZ/QVly1WbjbCNe74eVLpUk46x6K8w
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

cpu_buf_idle_clear is used in .noinstr code, and can be modified at
runtime (SMT hotplug). Suppressing the text_poke_sync() IPI has little
benefits for this key, as hotplug implies eventually going through
takedown_cpu() -> stop_machine_cpuslocked() which is going to cause
interference on all online CPUs anyway.

Mark it to let objtool know not to warn about it.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/cpu/bugs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a2d7dc4d2a4a3..39f6a2f9593f8 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -181,8 +181,13 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
 DEFINE_STATIC_KEY_FALSE(switch_vcpu_ibpb);
 EXPORT_SYMBOL_GPL(switch_vcpu_ibpb);
 
-/* Control CPU buffer clear before idling (halt, mwait) */
-DEFINE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
+/*
+ * Control CPU buffer clear before idling (halt, mwait)
+ *
+ * NOINSTR: This static key is updated during SMT hotplug which itself already
+ * causes some interference.
+ */
+DEFINE_STATIC_KEY_FALSE_NOINSTR(cpu_buf_idle_clear);
 EXPORT_SYMBOL_GPL(cpu_buf_idle_clear);
 
 /*
-- 
2.51.0


