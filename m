Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E3BCE7B1E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1858E8E002A; Fri, 14 Nov 2025 10:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1366D8E0002; Fri, 14 Nov 2025 10:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024F88E002A; Fri, 14 Nov 2025 10:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFAC78E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:15:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1ED758E62
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:15:05 +0000 (UTC)
X-FDA: 84109560570.29.E6FF2E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB1F320026
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:15:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RZRe09v0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763133303; a=rsa-sha256;
	cv=none;
	b=r8SL4SESu2t63XOakcIaxRWflNcv7yQ9Fga0WNHo5RT7N8ulX/NVRRfcl/K5C38x7EJ5T7
	JC0+pK7Wru8mtORXKb6mDd4ed5q+6ajpkNPYpowxfz8Xziq8OofrFXBpSlhKVLhRbYzXwa
	DHoYJFbucI69ZiHw4f85zIdE6RfGF0Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RZRe09v0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763133303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKNAHPDAvmAC9QequSTQUruQa42RH3SMYJaJvkkmTRU=;
	b=ciBedKnQMPFtEod2Am50i8mvyTTwtbBjpphfAQPB+VEt6AjF4Y54PndXwXGDdwPZ05y/WN
	srWBz4Hsa1slSdKQyAcJvXN/YJJLULu9TUaKrW/XQGCBbY8ynHsGlZB6rzjTmZikM+qMCU
	okDJOu2GTRx5Pb5ZwMrEoRdS8wauSE4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763133303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hKNAHPDAvmAC9QequSTQUruQa42RH3SMYJaJvkkmTRU=;
	b=RZRe09v0LztE5NC9I7MuIq8/zZKetKlBc7vqJVfmkmd+dhdJ+af7VvPAezvInF7Uag2FOY
	eN3PeCFJ8jikFJHxv72/N5r///qVEyabuDGuOD+/6AY2phRieGM2ZIekYL22NoFk0Zl+Bv
	4iPKRXkROg5ZlldX8G1j8FsgC9zePds=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-7iDwu_fMODCphb54CSyEig-1; Fri,
 14 Nov 2025 10:14:58 -0500
X-MC-Unique: 7iDwu_fMODCphb54CSyEig-1
X-Mimecast-MFC-AGG-ID: 7iDwu_fMODCphb54CSyEig_1763133293
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 796421956088;
	Fri, 14 Nov 2025 15:14:53 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DFC2180049F;
	Fri, 14 Nov 2025 15:14:37 +0000 (UTC)
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
Subject: [PATCH v7 21/31] stackleack: Mark stack_erasing_bypass key as allowed in .noinstr
Date: Fri, 14 Nov 2025 16:14:18 +0100
Message-ID: <20251114151428.1064524-1-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB1F320026
X-Stat-Signature: 8omz81ydqsca7bpgk7bir5txphiym3wr
X-Rspam-User: 
X-HE-Tag: 1763133303-605049
X-HE-Meta: U2FsdGVkX18TPGansM5kuc4z7NNH/qJDcRN34DwFXa+Tf9KG0BZyftdhy0W5hseJVYvBYZWEz/+EotK8jNPR5Tvrgt9Ko93FSWcYrqIuNIfXyEhOVU+X00G9sPkUYiSIBqHubrsP11b5pS9W7ye73+M1T6wX7tV/sA85ipXPE05jXT3N7KJmaAb9fMnAhGrgdYkzKDSDOr6Bw7gyHTBWyyyZtye1dXcFc8WN+wUZ68P87Sdpf1VzLKN5xIzZ7uloVMMDBz26pl9QbxiSDpY2OLvibMrvjvhawEAbA2y2U2cZYzA0d1i3DhJTLX+rmTXNr8BkiAU9ZhuW4RwYQX3hD/6vPvLc2lDWbfIgTCtUxScTVUFLi4IlzdkLXzhncOVBxHF59FW8zAgOpyhISomtWN4EwQAMvqnN3M4NwMGW2/wlsmHGx7pgGVonyqA+VepSJKEfDX2VYezpMjxqpjXyvkWM5MoYtnQHcC/a2i81rkliApCSzvWZFcDDwVzOcgjHOaBzC61dkC3JJCbguVTA/Y6kGr/AbKuXxjo25ZAG9lm/4h+7Q36FsA46n//dsFT4xiKPeEJO68LkoqB6WL5soaNZdGTr6JW1TSrt5C6XGOFkoysaBql66MLGXsOd4TfEwhjE5/7+tooU2aFRTtK/SSg7+kX8xh/miAddcvv/8ZvD2tNK6T39JrImUboc20G2HmsswbE9bo6J8lEpL7SfVmdySh+V+Jb4jtirHdVkDH9eHkVOhcUxuF32l5WdnMFh1M5lGIrEVYutrGUfsEo1dnvnmM96aObN2hdlZrpCE/uryb8BadeBvYD/g7AXeDRy1FUMETQaIQK9WHqQ44MO27cpMF7UFBbF/jbegHkqvIvBcg+ri8dFSgt1tyNF3H9LwAa+AYeKkhSrY0dP1+YfAscqK/WeOxumuxHxvcwjvD61q1BZ6PBRQrP69sfpzetP+amro+dqnMrlxZcLZTI
 Lo8mlZ6e
 0O8euXi4joTcPmpMH8cTIWIl1bwd03wO4zTEVreRLv7znM6e7xw58HIaDKow9g4ZnJHNf97eLB8hyEj/4b6lQDwRlQRmGXrrLLgub+RnqtZPKMLXgv27YtuMIArSv8xTHwect/03+1jC1r5i7FedS08tEKzrb4BxqlJtUhfhtH5sv9Okza2RjjwZolHjOWAJRIhzEWu3OlIZPO0PMNkk4fxqks+sDQQDOnixZYaRkaU+kGg7Euj6aBF4szpoR+quzMgn6bkeL+fIVbylY/oU3iprgj7MB/W1veBS+QM7gcxkhOwPqVNW9OmPofbVJYZhOxFvrnsIfX8osD3+oqsJXqIv4at801D40BsicyfJ48SxLzuaUNUsTXn/Xejh4Xva+B3d3TqtR5p/wU3Ho4TA4Uny9Hd6JZmtePZsyu2yLXJzEaeR09uZq6s2X61M8x0voGDWijShl0baWCgAFjX7wjirkipueutsFImzWIxFLHLPSF6Uy94EO5DAlTg==
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
index e49bb88b4f0a3..99ba44cf939bf 100644
--- a/kernel/kstack_erase.c
+++ b/kernel/kstack_erase.c
@@ -19,7 +19,11 @@
 #include <linux/sysctl.h>
 #include <linux/init.h>
 
-static DEFINE_STATIC_KEY_FALSE(stack_erasing_bypass);
+/*
+ * NOINSTR: This static key can only be modified via its sysctl interface. It is
+ * expected it will remain stable during latency-senstive operations.
+ */
+static DEFINE_STATIC_KEY_FALSE_NOINSTR(stack_erasing_bypass);
 
 #ifdef CONFIG_SYSCTL
 static int stack_erasing_sysctl(const struct ctl_table *table, int write,
-- 
2.51.0


