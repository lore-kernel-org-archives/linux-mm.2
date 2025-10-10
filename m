Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB1AECCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E138E0026; Fri, 10 Oct 2025 11:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEA48E0003; Fri, 10 Oct 2025 11:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDC98E0026; Fri, 10 Oct 2025 11:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAEEB8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:41:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9517B160347
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:58 +0000 (UTC)
X-FDA: 83982620316.22.254D672
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE97940018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hJYmnoIk;
	spf=pass (imf11.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0yyCaz4IBzCuynoK7eJFq8qb8jjHV9aZwpbdt5Xpuk=;
	b=UsmswaeSQWf5DQ2xLbzmkEtbaLUtb5+hfNKAv6tnkoPyRmX8NLNZuxpWYMelObhtb4Inza
	VSgudP+rUvp6D5Wh2bEI2JbdxdBGi1Vgzcj0p0marBmJ1VDGRyLUM74OyRrGIKcy03rToP
	b3njFuNaDt56zzXp70NtP5cwVwPt4do=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hJYmnoIk;
	spf=pass (imf11.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110916; a=rsa-sha256;
	cv=none;
	b=isdYNRd+7Le5fNjabCgP2auq/62KscqSB62BUqyjUpVvVFNo2BmsPrtEAIi7uaaBnKySE2
	H9TTRcu1asicLizYT4XfOhnHU4FcMa1ayOnNhBH+VSUYicqaGyEAxa/IjvybTXMfpBxV90
	k9NgVWTVV/nUXIHKE9LG777OZUsoFfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0yyCaz4IBzCuynoK7eJFq8qb8jjHV9aZwpbdt5Xpuk=;
	b=hJYmnoIkBlzwg3K82CLB/NuwxiIrLriOD2O7X2AUyA4ESqn2i2EwkpKvy0xojFmgov8Z2+
	K8no6cxDmXsv0q4mz1qHmjCCoa4vmeUPQ4QCtyoibqgs5OVmschfipusBHWJ5JAsMMpaNu
	2FWPhzIN/w1QsV3tBZSeFMHTribWi1w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-qfwoRNR_OtK0oq5rP7Bzjg-1; Fri,
 10 Oct 2025 11:41:52 -0400
X-MC-Unique: qfwoRNR_OtK0oq5rP7Bzjg-1
X-Mimecast-MFC-AGG-ID: qfwoRNR_OtK0oq5rP7Bzjg_1760110907
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12AFE18002CF;
	Fri, 10 Oct 2025 15:41:47 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B87518004D8;
	Fri, 10 Oct 2025 15:41:31 +0000 (UTC)
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
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH v6 04/29] rcutorture: Make TREE04 use CONFIG_RCU_DYNTICKS_TORTURE
Date: Fri, 10 Oct 2025 17:38:14 +0200
Message-ID: <20251010153839.151763-5-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: BE97940018
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: i7b8ef9i9bcrmud5e3x9ycb778yzxyxp
X-HE-Tag: 1760110916-325219
X-HE-Meta: U2FsdGVkX19R1EcJF4kR0FwPeK4Gg4mNiWSn8DwieZTG/Qp7sjFh2AmJFgSIe8O6V8h2N3yyFkYNLWLXNM9Cdn2toeh/kY3FHg1xo6B5XeMpWK0MgA+w+zDGjtJ/OlCxrOXcCk+dsDfYVq4T8DSDZjgtQP0wAIGT4HKf820O62kzJS/xxLdf1VTO2F/olxU2JVseIXTyvj4R5sF1YoHd+icPM59DVRkN/4G8gqWwbiL1gRCe9bC3zSQHMnQvagOAeYEuGiIW21fpK06TMN2VlOd83PsPh7Vh/YXq05/IWoOeAM4fMSxOCE0S8vVxbMD+qTDqepDjKvEVzYE5z4zotRwZxAXzGe5WZGozhgkyQXB1NMFS5z37mxRus1fnOJ8MZcM5JJlLHI2ZiADDD6cehEjTEJ46lHMgg6RPOGUpDYoHm7d+FoxpXHeA41bJZgRQ1dg67L2cbQLPP/+u6pLho7rP2A5nZ5tyBFK1mwJQJLcYQtTSjIztHr1nT/wOt4dMzf/81f2HnSyLNat3g0MHrO6k4QR8Wg5H+3heI2/9FeZBkTGlxar0Ln3dyW4mKV85lyb6yreBxom+XAHDUQ/9uj1OzESdpZSOW3yg8pE9lUcSbwylGTle840Zv1dQvLa0x3JBcuq+f5LQd3JRo89VqrW0nHGRCUVpTR+sgihed3c6OB6WRe9xJtEzK3XNLSDdNM/L1OLgDgpeZ3TRhYsev6TeJX1axbvfSDc2w1FTPcS8twdlu4s0P7J/uwgEPltte7pZKUYuRjHTXFgp/XA3dJPTeeLwGLY7a9kqype5UxDFic1PwJGoOvkSvFHbwAWVTFAMDt+3+7BECTbQ5vOWuAWs84ZxC5ZBmHJighVpQAzP42cNyPGszEvwu0QFVBlprUrBhe+JIoAkXsR3i+ygqCF+DC/wwqhvS9LzXc98hrPU3vhaMMfnR9JsZ2xS6Mx6aWzv+qnzruDVmPBAFdn
 EHGFq2pu
 pKZY63JR0cLGQZiGPLbrd1mYYBhHqPxh7f41XjoaHR+Q/LiG2iWb1nQ6Bq2LiRd7H32jr2BcNIBGNFD+ZJgdFNdqmkNLsdqySh0ZMVVvRQn5MLxmxoSb40DE4iFTpHzAsnDg5YWEXRAnq+4X0tCKbwAS5xSMCJRQi78QGYhNNW8kNCeuhpKFuy8+6kOfcTvp8yRyMagl1qAQR3k9cI45sqHcELBFl9VocBC9HVJ5Cz/C/F+QwdxR+yijZvp/y2hxE0SheasmicTL3u9thBfpiUslbrMFzr5lQ6g24+/C1ECZF1O42g5XYp3QTnlEz5oAZ7XUaWgw9jB4wseLIJqsz18Y5edVNZYHiG6yJIRHlsocdC68kvEjuUGJ9DbOYhyzCFEUA4S8iF1T42Tbbn+Y8Hn6yNTYDZdLXYvYV+G0LcqfWweCFmKL1Hiz1335+P2m4hUQ5+USGKtIWGw250juER/l4SGq+BuCQ3N4AiXBDZtjwMjPvGJ31KBZ/kQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now have an RCU_EXPERT config for testing small-sized RCU dynticks
counter:  CONFIG_RCU_DYNTICKS_TORTURE.

Modify scenario TREE04 to exercise to use this config in order to test a
ridiculously small counter (2 bits).

Link: http://lore.kernel.org/r/4c2cb573-168f-4806-b1d9-164e8276e66a@paulmck-laptop
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
---
 tools/testing/selftests/rcutorture/configs/rcu/TREE04 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE04 b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
index dc4985064b3ad..67caf4276bb01 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE04
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE04
@@ -16,3 +16,4 @@ CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_RCU_EXPERT=y
 CONFIG_RCU_EQS_DEBUG=y
 CONFIG_RCU_LAZY=y
+CONFIG_RCU_DYNTICKS_TORTURE=y
-- 
2.51.0


