Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B925CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C4A8E0019; Fri, 10 Oct 2025 11:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CA48E0003; Fri, 10 Oct 2025 11:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B4C8E0019; Fri, 10 Oct 2025 11:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86F338E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:41:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32DA313AA2C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:31 +0000 (UTC)
X-FDA: 83982619182.01.5287DB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A29A18000C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BI+uLmtB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=me4lML/uc32hdzY1DEhxwzrAH42jFfLe3M5aQyxycsw=;
	b=nStR854cOv/RQ3exJSzG32U17K6Z+50AxdhbOhp5CaY4cifUsNMHkpOyiMROvAKm2En0yL
	iY1liYLknupNujjeA+7f0RWJaSxjbyqhjxW361UllUObJ8hMu4kyIxfmNaVjMUd4k6enSz
	AqsAIZHpuXEsoqgKQe5Jr4aiRSJvMwo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BI+uLmtB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110889; a=rsa-sha256;
	cv=none;
	b=AIVEjyhpfeknqmutTr3Kl/+hTkDKf7bNGybxywpMaF2w8js5g0Icfo7y8m7VaUCurqlDTl
	B2ljGcXq7817sQt/cYZzRhWRDofhZO+9YV45/wYrn+KajIwnRQNmNlg/MewCoixiZeHrbv
	G908QFlrShW6R/aXtGAaqk+Y/23IekY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=me4lML/uc32hdzY1DEhxwzrAH42jFfLe3M5aQyxycsw=;
	b=BI+uLmtBs5uNuG5OIE9DmoIA1UvLjZ/DUcCNvJpHbJmCoVjyIaVjU59H5z2bnWxNut4t1B
	BS0WJi0Hgkcp9pYXuOvPEoC8M4I/uPEvCbjw4R8WiSPY++Y4e2wU9gsUiqzpBFf+tZ8b8+
	2hyzTO3lDEWYsz+YRyUZuKTdizmXsfM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-443-fGVpFfnMMJu9yBgKyRgzVg-1; Fri,
 10 Oct 2025 11:41:24 -0400
X-MC-Unique: fGVpFfnMMJu9yBgKyRgzVg-1
X-Mimecast-MFC-AGG-ID: fGVpFfnMMJu9yBgKyRgzVg_1760110877
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56F051800366;
	Fri, 10 Oct 2025 15:41:16 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED43B18004D8;
	Fri, 10 Oct 2025 15:41:00 +0000 (UTC)
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
Subject: [PATCH v6 02/29] objtool: Flesh out warning related to pv_ops[] calls
Date: Fri, 10 Oct 2025 17:38:12 +0200
Message-ID: <20251010153839.151763-3-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A29A18000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 44na345uhpghhy1guuf5ocabs6xqm3sf
X-HE-Tag: 1760110889-607974
X-HE-Meta: U2FsdGVkX1/D21q8Bjbemj+Hi1RmWB2PDqkJtDhRUv/WND9ORNuftfAFSzhFTBNZL/HERvKSixARe7MMNz68Ai9nYg27YiR6mFE77nNuIoRTBMXMLR4nUVcRoAirQ2tTGbqiUXfuEKB4mgB6b52v/s4liYOyxgOrVGqoASUkkIeTcjENHwllou2CvBqwhxx9rzDLNx6r4TChPgXtHGbsFL/2vgMbgb5fg+KsMt3Tq75y0Ixv768Jd4vk9iPVR/YYtfoG+67Ypw3WpjaT91XulTiBJKb4WUIIz9OVeN4lsQYsAj1jP9hu6HKY5LZntwQsY1ZetjnKKTFlaF2GKHULbyY95URoN9jIvteRt+57NNqx0gOO0TM3k3QdRUjiCgFOXf6/u5KC+5EHYwChoSoPSJCkwJkXSVY+l4MetA6xLXs8Uvjuau/aI1UwpDhe4Rohh1A6B7qYFdBHskX1xJlfYkzO3CtdIwlAW8ipO8YgET6BVf6x37tv01pF3Gre2NEICqYzeKv3SH5yVKpZBzXf1tfiwfL3/Lvl99xiNxZrNPKxs1T9BeoOLnxGXCfKB5JmrkJ4qB2dpy6wf2iu+461ASWARoINGxxQduxogh8UxowfGT//Ozyt9cPKZI0RFHEO/BQo/fqNPV5JYHAZu+fOABvdYHIjvjbFmMMHJAQEPlW0Lot6ym+Izig4ScDDb9reKzxfI7ndHQmLeSuwUh4JmQ6A2m33Y0Rhsej/i8FRD7qNpIojGlG3lhZYXS+lAE6GNmIRRO2otd40D7BPXjsKJRSaiAqsJqhEPJNtCtgNIUOuuBJRBBXXWrxMCsP/jalBapG5fAklOEwyXPDgDyIRQwAxeROhmxMPOEGTxYWepnJ/JdoN1C2AVcMj66a7ba0SlDmfhCVxa/7+WvzulOjrCUsh785OrLfS3qm4lPHiIVEkNUXlhQwnQPC4/Az/c0Vc7m8EWOEzxBHc837tLUQ
 rRuDmxlH
 IqYSe1OgqfA1OPIpMSD6PsyE02LolnYxidVuKxQrPAB5L7cIFOMfR6VTmML4sobGlSsXa4ySPQ0sau6kxuUCPl0WB9AxLxxiQ3cChY8olfi44zO4MrolQoQFC1pitSbuCjlLniymxEYIl8zX2FbUf5A5rM/AM7HNws4bUnR+K+VOyVYUfHzoFcU3+J343tLwPdWCUo2wp2N+dYJ5atq5O/1O6SgEI+9EEHpos/qIroL7xKc9hEriewGcwycJ3BNNISbP/OXv3JGk0KP8aOImXfVawcCNo94ZP1Qoz8ItWHKgt63GYyLwnmBPp+1hUzHBaKmtUQBqtpuvHwUYaXQDKZ2hLD4bapccvoqqcLMEgWJu0Kb5NThVs1Xi6x+NDlvTmm+25lX8VWlelqhHt/o+XjJbeR8E5LIbTsYq28hq7kTuR9LZ0PCQ5GJbVlDPhseMgOIAv+Zlsq6q/Z/unFxRDK1284W+638LaVg/8S5oqfLR+6n8NhF8mt7rOmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I had to look into objtool itself to understand what this warning was
about; make it more explicit.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 5f574ab163cb2..fa9e64a38b2b6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -3361,7 +3361,7 @@ static bool pv_call_dest(struct objtool_file *file, struct instruction *insn)
 
 	list_for_each_entry(target, &file->pv_ops[idx].targets, pv_target) {
 		if (!target->sec->noinstr) {
-			WARN("pv_ops[%d]: %s", idx, target->name);
+			WARN("pv_ops[%d]: indirect call to %s() leaves .noinstr.text section", idx, target->name);
 			file->pv_ops[idx].clean = false;
 		}
 	}
-- 
2.51.0


