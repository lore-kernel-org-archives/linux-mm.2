Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC095CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3F38E002A; Fri, 10 Oct 2025 11:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059F08E0003; Fri, 10 Oct 2025 11:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B278E002A; Fri, 10 Oct 2025 11:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF8D38E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:42:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BCD713AA2C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:42:45 +0000 (UTC)
X-FDA: 83982622290.04.11B0631
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id E43B5180005
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:42:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I39go3LC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c85HG9M5FnMNKHSoA3zkMZkmQw264GRYsrTXaruk+rY=;
	b=s1XxzmpLverm27JdQdTuJLatyYG79hkm/SAcCiiffsJpzSWR59EkDbjWkfP/fLoWBeoGjp
	mT9IxADjTstTufKbrql+ZDvgFAkwss+xu23wTmyP46y5O02qjWhgOafcTsLSEM/xYcKVz+
	WdoWtfhHzgOvQ7fsxhIsJkc7+ZynhfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110964; a=rsa-sha256;
	cv=none;
	b=0EJBEKWJruytnlefjf4Th9EZs4aXq+xhhFMleti1u4l5I72A3kLpfWvLD5mNuFocElRyD3
	HyQicL2+r+p9xPOVguoh9SB3iUYVFpX2yUAAttmMjD/JUMMthX9Jk7uHfgtwEgTv1nnuzm
	+WqTNJnP7sLoLYNOq6aO5yD+QFJ4ThM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I39go3LC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c85HG9M5FnMNKHSoA3zkMZkmQw264GRYsrTXaruk+rY=;
	b=I39go3LCfbWpObYaYDiPF0/+sbjGskXoG0Ajlhbpye2/U0V8JbUStHfiY0xVkZIdXf+UNz
	a+z0lBxQ91+plBMBoH9g5Mmppv+V6ur3h9soFAk0Q9aFZRJxC45qeOytwBMRG9aqEMAlD/
	bvYkh3RxZ+pbGctmzz0O19wsbWeJ7Po=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-WHaa5xPLOOOfBTTf7Rya5g-1; Fri,
 10 Oct 2025 11:42:39 -0400
X-MC-Unique: WHaa5xPLOOOfBTTf7Rya5g-1
X-Mimecast-MFC-AGG-ID: WHaa5xPLOOOfBTTf7Rya5g_1760110955
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4B991800447;
	Fri, 10 Oct 2025 15:42:34 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3CFA21800576;
	Fri, 10 Oct 2025 15:42:19 +0000 (UTC)
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
Subject: [PATCH v6 07/29] x86/paravirt: Mark pv_sched_clock static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:17 +0200
Message-ID: <20251010153839.151763-8-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: E43B5180005
X-Rspamd-Server: rspam02
X-Stat-Signature: p685hsn3dzw5zh3aifmmuur6ja9tbfix
X-HE-Tag: 1760110963-7515
X-HE-Meta: U2FsdGVkX1+9MuAbqQKpAtipiEARQY83vWw36LyJdyOXSE45clN8U0k6DX8sPRzF9EbHMLN0sugsPIG25Du/Q4/91lUpnlouN6Delefowa9dQ+s2PgJOfBLLvRs8WigG3p3JLJVWO+xwClWnl8MwrzOG26b8U7e2sJbCBo5TcZXf2Nw/vJ6FiD6cOQLqCBofj85fGpdypms9vMhgq4ly6bS2u8RxWbk0BPdflbZ1umFHybyKKN0qDUr7465tUfN7VEBQZvqaW9/ZhIQCVFvNgSvbSiYdz9VjCHvlbYGtB1GT9nI7VjyCRTofFEVjOZQt3RWgZLYo8pnWLQ5czWhtUgO6qTL/kwRWW/1YDGy6FV466JINNr4Xb7hiCTKXYjuN8B3aOZaqwQzqAwKjuWDxG4QriF7uFwBwdFGr/vdUT1W6k6O4r0bkS0/ks9i3GcCWU1PZVnYW7hDzvoQRjNds3JgLf5Ry4IVYoqvTAFBUcIrIqclkkfa9LaGkDVBsAmGe01AW0Tan38tqhP9WlBav/Bgo88EKaPf5i8/nMW4NYU0qxoXYFBt75EnGU3NORTbpyvQtXx3wSO6hBYVkZgLQWnDVeZtNvAhLoGx3wbR3E7LBo3Og8snu40XvF1MPXTF2VeOukV9WYmfAJUiLDvenX1mmjLV8W2IRB7TOUNrBIq+3gJJ/GxR1xgEgpk0gHMPiY5r1gHh4Jjmd2thFaVlMYvusxL/2mV3GujtJ4qrCOX9YMET3QpoHASNj4XtW5l9RwteNUFPzDRFmwP1WOi8GHuyW1voy8HGlbx/wq+ZFjBKClm0WqYq6WUYQiPFldctGoiP30K/b5gZuzlCW4lvXGHGJsORxfm/Vkvxep7W0mjGUSPhxbJl0pakbW0Mqq4HOrX1Hjv0Mb6k+LBbe0Wd6wmDi+gAZ9hSfkNQRsE+3doKv/JtVYPgQIzB3f3UJ+d/wjZH85DHZ/nsNG1vajxP
 SVDMHc/1
 b+V2NvwHbj/Uef4dZrPCzvMkbAv199bpt4rBTISF4jI/hBrF9VrfLDgfR5Cp6FS2aZUWI/QSRPtVv2gOELGVb0dcuEPjri33+IkqdvsZRwNeh4exmmZBcoXvie551T5oWZXV14VzOriMTWqmWsZ7Mkl4jIywkOQRkNOBvUczf3KcLr6GAmr5WO+m+StX1LzcfopdSTfRwUD4Znm2vo3BlhCxAX663ufPMhx4oRr7EMy6vBeEC1dtXs9hFn3zD9kDfmB/b94lSEA8o77LnAWoopQwruSDaC2p9ZRKHLxrtrZlAluAwiz/PDDetRJcESDNG9k5dugzhVkraAcihFjS8+gGzP+3O9M+XB3AdFsBk43yCdUOj1NdoJlXiNB/Tsk5Q90AuprRF8asCW0O4D+8oQZ1LzQObbgH/IU8/rz9Ea1iBPJ4zA0HEIxWb5pazQo4A7GUxd2Fiz/njB/D3hHgB2JohWGFXKraLG/gV9FxVdIuRapNu28w6qmADvQ==
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

pv_sched_clock is updated in:
o __init vmware_paravirt_ops_setup()
o __init xen_init_time_common()
o kvm_sched_clock_init() <- __init kvmclock_init()
o hv_setup_sched_clock() <- __init hv_init_tsc_clocksource()

IOW purely init context, and can thus be marked as __ro_after_init.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc693..34b6fa3fcc045 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -69,7 +69,7 @@ static u64 native_steal_clock(int cpu)
 }
 
 DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
-DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
+DEFINE_STATIC_CALL_RO(pv_sched_clock, native_sched_clock);
 
 void paravirt_set_sched_clock(u64 (*func)(void))
 {
-- 
2.51.0


