Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51904CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1BF8E0035; Fri, 10 Oct 2025 11:45:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4BCD8E002C; Fri, 10 Oct 2025 11:45:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B3B8E0035; Fri, 10 Oct 2025 11:45:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3458E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:45:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41489C037A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:36 +0000 (UTC)
X-FDA: 83982629472.17.E303B50
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 75EA3A0023
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:45:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z8nQZ3jR;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVMYi0dEPlAN5oTp+GqnRcFGW49bLqYyv2ugGfsmT5k=;
	b=RaNvnKwZIUrYF3kFGYgGJ74QnDLrLORd+me8M8l+c8Y+H5UFDJ7ZIUePja4ClF8XwIhPgc
	wpUd3I1WjmUcfc5/3f2HR7gJ9mA4Od3mbziO96kwn5ugA1xU5ImBuimmrpcLbXLN8ktNj3
	MjNQS4xAthBi9JN4v1Lyfx90gmxh0Bs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z8nQZ3jR;
	spf=pass (imf15.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111134; a=rsa-sha256;
	cv=none;
	b=bU7WhFazuaWFkJ/DSK61IzfAEQJreO4+EGsS3sYtvpYoBnFT+riO6rGzoIdNvQ2fSV3mPx
	Cp8R40o8f2r7qf5lrPdjQh+o+2/RRx/VB84+P1WMi11gbWgHbFqb+D7RI0xjCz1nFcKeV+
	gjKNWmUv+L5YvxChUHrCJnnMxnd9g98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jVMYi0dEPlAN5oTp+GqnRcFGW49bLqYyv2ugGfsmT5k=;
	b=Z8nQZ3jRQkVBvMf6PpcUxKH3iFi1Zq7WRC6d1w35oruj3APhEVadM+lhNUccfyTJq4mZ0t
	Is0C6+2oAhfFY9KPnT7plf4x7PgWHCUJc+1zA39JrubbNJujd+K7X9KkcjyTD3Ru4zwMrF
	B98OC214qWGDiOOEyY9/b2+J+zxeWgY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-thi_Xds-PSmRA2dcrK3vtw-1; Fri,
 10 Oct 2025 11:45:30 -0400
X-MC-Unique: thi_Xds-PSmRA2dcrK3vtw-1
X-Mimecast-MFC-AGG-ID: thi_Xds-PSmRA2dcrK3vtw_1760111126
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E36721800576;
	Fri, 10 Oct 2025 15:45:25 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1BFE21800576;
	Fri, 10 Oct 2025 15:45:10 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH v6 18/29] sched/clock, x86: Mark __sched_clock_stable key as allowed in .noinstr
Date: Fri, 10 Oct 2025 17:38:28 +0200
Message-ID: <20251010153839.151763-19-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: 1k39jzsb5hzfghbg8tu8844acd366kza
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75EA3A0023
X-HE-Tag: 1760111134-84873
X-HE-Meta: U2FsdGVkX18FaMhnIHrWDbj2eB913+84yb+u5LpYJ88cRI21RKuWJl0n0QDAV9bQePYrNcx5U1gGl+XWfDU8WI6SBs5TuAJ7soV0cSr9V68I0YXmxsr6zCs8SAHaq5w+MDyxTRS5tTxBvyFtOjiNRm3mEdMrZpW57m0siqbYYnnCPEcLb5KWsVFESKmjYGhiB/YJzNBOGXGEXwsS8I9fFawJdRluKQVhHWSASef4VALYEt9Zhb0JxkS69CYWm7QQYYQmrELKTWGmzcGDkDLTcdwXepogTauwaug/CUe2RZMZRk1cw3Pn3/H8O1NLuq3vDTtI7avp2IkzeO/TbOFjro1QapI+BYpPoQx+DwRZMjrsIuEtSpNtxrmqUknMXAYGfq8AaTcrNvrYDW5tfPF9+psCYYgZgM197MQ3ppkGlgD49hwx+egGk1HGHaxdDV59qSKH0lwKtyiUEXy4tuMIcHdFlezSqpaXGcNmAJXV17JnHCiXditQuU4QOXr0wTUEBDjmGvBaSyXD2QUts8IUlagoD/iHGimHYpmIWGcig1b8t+OiBXlCJoULdKM5Ru5Aw+O9V6qGIMEUZLelpD/DRS/cWGo7Khj2VOOqw5rXD4FX+SFj/wlRcQBWm6fO7Gs0MkpZPv+s7aUApcd5v16IQnxZCZ9ASyAVgvjEfPA1bBOcadc9IEdIUicaUpX74ZlHz2SLIqaVrEHfE9QxAfs6uEjDcauDSelKn/bYi/r824opLLqJPun3a0bLJ49VCS7sCPeWpilj2wEr6CvaFZCRvz7EjqIIeulVV7bGIEz3cBousX2xkbHdB99P+b97Fh9CTX1ZG5aCe+/fZrd2uQ2hQUcMl9PoPV5NJ8OJ4wyq8kqyCls6EoJutlSCiv7pSE5Boz7MzMR+BUZHE4fHhEpJDJQOdvnJ8RpM1MFIIsaMolCHnYjGMgoiv/OjRBhan7/ypcweW2kqsG/lWcRIZ0c
 UQdICyBX
 OaqD2Gk1j9QeRZH1AlJp2pcZzmgRcXO3KJWqMqERBcAxZpAanA17oPVQVdrm89SrWM/M1F22OgvpgzsBmDiOq89DT3cSjB0sDKVRFg/C+hsXAQUJPKeQttUIF0FG0nGjOU2NOWFjrJ6DHjeyW+Qma0G4qynKsMZKHr2TgpDZpblTSB7m5FtYsUzX0KMLCN+PcC33jCWsLC01owgs0ZCa+sfKN+IAo4BkdlF7ApQYXboTYHQIHVlciMk8+8Hmchjl97w4LvjmU3kCV3qBu2kB+oWzD+6izlgyL2vNrbD44yLClg3WNpkZRnTK/0++EcMAuSqzP9lwKkL+nnAvATvwDFRLZ/yNegk+QAPmLeVI5VkdPG9CduuH+6LRd5UIHBWLkxpcSfYcH21ltXo2Qt1EZg4/Zxq/A7p/oBy1gjxPUdJYnkzB2oHQ3wnSZg/sON5HzEYMCHgTf99e/YAIGfUc9IhawOSSztcRGFOBY
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

__sched_clock_stable is used in .noinstr code, and can be modified at
runtime (e.g. time_cpufreq_notifier()). Suppressing the text_poke_sync()
IPI has little benefits for this key, as NOHZ_FULL is incompatible with an
unstable TSC anyway.

Mark it to let objtool know not to warn about it.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/sched/clock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c1a028e99d2cd..e6ef71d74ac95 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -78,8 +78,11 @@ static DEFINE_STATIC_KEY_FALSE_RO(sched_clock_running);
  *
  * Similarly we start with __sched_clock_stable_early, thereby assuming we
  * will become stable, such that there's only a single 1 -> 0 transition.
+ *
+ * Allowed in .noinstr as an unstable TLC is incompatible with NOHZ_FULL,
+ * thus the text patching IPI would be the least of our concerns.
  */
-static DEFINE_STATIC_KEY_FALSE(__sched_clock_stable);
+static DEFINE_STATIC_KEY_FALSE_NOINSTR(__sched_clock_stable);
 static int __sched_clock_stable_early = 1;
 
 /*
-- 
2.51.0


