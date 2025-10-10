Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54ABCCCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E948E0032; Fri, 10 Oct 2025 11:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF028E002C; Fri, 10 Oct 2025 11:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE458E0032; Fri, 10 Oct 2025 11:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8446E8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:44:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D26DC036A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:52 +0000 (UTC)
X-FDA: 83982627624.09.D4315B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53440140002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:44:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsuX1LoS;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111090; a=rsa-sha256;
	cv=none;
	b=WudDe+ck42TrOdQPR9fUuVco73IgkE9+kO1jbPxNSahY5RQpNwF3/JHpPGjq3hyK15fV0h
	K+L4Zg6vl6ZNb5g5hA8HtA3lZD0IBSley63Bmhzd3YAi5XwFTo7HhTe8jUninfKY+V3cDD
	nwh32b6sEoCcsV++g8a2BQCYW5T1CBU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dsuX1LoS;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5bTE2UFDn4FhRjqFPlcPPiaXyzSIXCKwLwP8uiIlgI=;
	b=JwjMTPxn88d4US5Qlxyp/SbpWd06gO2fH9xIBQqqskIpN0I3iVlFKNjG1nT3CMjMMjzVpk
	4IfewUiNkr0IJEKciRHnpA/+5ZU7Hz9v1S2kCWq6FCHBHlYt0ofFrLLHamdY2kR2qqTrDv
	baq9iHtvYLfPX06mr962Br+8F0MKgsM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s5bTE2UFDn4FhRjqFPlcPPiaXyzSIXCKwLwP8uiIlgI=;
	b=dsuX1LoSVuwOPfDItSebt/z7uGHeIRmYmdu2C2lgf7lUQZxOT+sOUR4WS4P/MItq3KWtEt
	xp3x+n+v9MaX4mCWWB/c6q+FWOWzq59qVg2S54FQHIRvG801R5yFcSwpHF2WjLBOixbEt6
	m2okf/N63r58M1k5CuUIYxCV4Bbr5zI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-26-35CwgeqANnqyTiiCVHZwvA-1; Fri,
 10 Oct 2025 11:44:44 -0400
X-MC-Unique: 35CwgeqANnqyTiiCVHZwvA-1
X-Mimecast-MFC-AGG-ID: 35CwgeqANnqyTiiCVHZwvA_1760111080
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFACA1800562;
	Fri, 10 Oct 2025 15:44:39 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB6231800578;
	Fri, 10 Oct 2025 15:44:24 +0000 (UTC)
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
Subject: [PATCH v6 15/29] sched/clock: Mark sched_clock_running key as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:25 +0200
Message-ID: <20251010153839.151763-16-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Stat-Signature: jtfnoew6y6mydcpb8uh9f1kpt658g1fn
X-Rspamd-Queue-Id: 53440140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760111090-166957
X-HE-Meta: U2FsdGVkX1+uqzadXJ98hX00PWRTZmi6bjTrxl2P9Nv2p4RJ5fmz+3Htb6XpLRwXD6z+dTEYpp43/oJ9BMRQhFO2M6rqX216QzuRAzNGRX/hTMln0JVYSkmVmTCgSD1urCrk48S2H2mMI19OAtzX1x1J5TmwjRS2AsSR4OGMHe38gpH0ef5fJFX0lVeZTmwkFQ3oYsDjCA8ELnQSXp2bKei1Hkh5OkdRHsPwVE+sMrHQAioleWGXdFVYXJBKKySwg7WvdRVqJqEq7HrcUKbF8CBi3sukAGn5VcwZKu+rswyJrHHUOuBKTS+tGseUujUTjoWyA9pTNCDyRGnzqCoU2FVFIXKFuGpofXftg6hOJ8g5TubRVt6QJ2Rngt8I4EidatL9zbT/5NIyFbX6FktJeyL7HVrl1ioQf/xoKPb1xe6A4HPD42g4LtUXu0FLD0fVCX3hjIe9BYq8lnggqpzbv0j++c/Ymo/ULtFvoTCrfptwAWdN30ML4kEhJR35T/A8zjxWMIpED66zf9d8xMQc0H6Qiij5pDHwMZFlItlOzIlwlg1/hBBM2jDM2u3pEe6BnIodg7e928iuM94RZAAJPvZLP+zeHkjvUtby22o1bgAV91Kvypc0yoW5d2/WQ6/j0oKIHvIHHd4dQPfhMM1cCZaL0d0yiGtTZWuORJcdTMmps/kjfw48JKZkgCN4rZMxPZYS71+mQ74zG+0coAT0SDUpsA3eDJT868P6HeIxycJrkfwsmCXsejTqGRwduXHlWU2CiVaLVD9PFwCecmDXjrUJQOItBXkxClXrcmzFnT3sZ5zbOT+ib+xkw0lh4Yq9HvffG474GMxKY8tDQ1FUxgHhgADa9t1ut6agRUooYqvqoFzYFVSEY5nPqKIhFv43m/6t3S1ht2HsDVEKwU64JOtAkrlyAW1EgdtkgYJdVs1btGyItG+c4gzwMWVE57jhnZMaEgL0s9aIZQpk/e0
 Hm7vbxQL
 PKY7hNrcaMuLQ5ybztsxPlgDpUsS/xzAZbA2ULR06WWSPRZQQJJ+vcpe2+3GC/n9CpoNxQ3BUrUvm4VtDK2zmUSrE7mOdY3jR8LaWpFiQs1uF3TUcmK9A/QdGiQsGaA5JJJiHYa0T3yMGV6ItQr5IfqL+4lRR6eTPHyOTYxX6NGEI0OM3H3lZhM7WAvJhhymR/AyZAtiuHXlVUjBx4IfCs62H3ZGWwfQUMA6E6+on0/nXTMydDUNvJmFIOI05PESJ23A65Fi/1kwTRZOX3Oecc9QBfyJ4hVj9NSESMW+66Ak/7/7JyfW98MlNRS509DI5mQlAtVCqHUjYWbHW5PmY7r6QuLyGIOLRTi3EpFcFBbFXtyJGkECdo9fjFv8TcEJxDCUjQR8kF6Sghp9AdW8vY4BIFk2UzYInJtjqI5hkltc0QGlimFcj2G5NRXKsfCqeh/8neXjz5KF3NqF3H62ff+CLxIDpKhwu9AlA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sched_clock_running is only ever enabled in the __init functions
sched_clock_init() and sched_clock_init_late(), and is never disabled. Mark
it __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 kernel/sched/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index f5e6dd6a6b3af..c1a028e99d2cd 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -69,7 +69,7 @@ notrace unsigned long long __weak sched_clock(void)
 }
 EXPORT_SYMBOL_GPL(sched_clock);
 
-static DEFINE_STATIC_KEY_FALSE(sched_clock_running);
+static DEFINE_STATIC_KEY_FALSE_RO(sched_clock_running);
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 /*
-- 
2.51.0


