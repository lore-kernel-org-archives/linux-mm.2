Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9226DCE7B1E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F05228E0024; Fri, 14 Nov 2025 10:05:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDE18E0002; Fri, 14 Nov 2025 10:05:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3918E0024; Fri, 14 Nov 2025 10:05:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CDDD78E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:05:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FBA687E68
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:59 +0000 (UTC)
X-FDA: 84109537638.27.9BC8E13
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 872A22001B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HYe6y8Ul;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rr6xJ3c+EJv9VO46QEF+ZoB4rWgfcJmzisR3J3XhXsY=;
	b=c8EOjMXF4kECiaLLuYT28m7P9D+HORyIJQf1dVAmII6W6jeTuGGJo6zYVE76ZDY2yh5rid
	IS76CxTSfaSWi6sQgNhdu47pqJn50ItYA/ZbP+s0v834A6DDMfQX1fIlRGoApjzOkFpjae
	bdvduFKr63MUXBIl5tHGOkbs3Pggdwk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HYe6y8Ul;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132757; a=rsa-sha256;
	cv=none;
	b=QZm10IeqLV+BDc1CaVtrPSGnbtoBNziBnWlN7XnveiH9Rl4RF6wRvwchG2iLIVxKjLb254
	Czdj/+7JKLQ2PaRffXO7PoIRUUHuso61MR9YZNmw9h2OlSyWWLjA5/b8cOb+6bZkNR+/SQ
	RmULviNEJjo+GET6BgwCv4aUNIEuBUg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rr6xJ3c+EJv9VO46QEF+ZoB4rWgfcJmzisR3J3XhXsY=;
	b=HYe6y8UlhW6TB67PQ5mHLNn1wdm+K6k3YPP52hdHDg3wIVTshRaCXdDqmGjeB/4y4YbVkQ
	sN/D6LlTNt3RdNY4XBI+FhO9InDs3IMj/ZlpPIPg6IkWM/XqjHX8Vkw7PC7VE/F6hwU9Cn
	d8ze01Z2qIRqWDqVHazzehUjfshwQUs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-1COJ1lZ0NXqsZtNAsefjiw-1; Fri,
 14 Nov 2025 10:05:52 -0500
X-MC-Unique: 1COJ1lZ0NXqsZtNAsefjiw-1
X-Mimecast-MFC-AGG-ID: 1COJ1lZ0NXqsZtNAsefjiw_1763132744
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C1A71800370;
	Fri, 14 Nov 2025 15:05:44 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1448B19560B9;
	Fri, 14 Nov 2025 15:05:30 +0000 (UTC)
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
Subject: [PATCH v7 14/31] perf/x86/amd: Mark perf_lopwr_cb static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:16 +0100
Message-ID: <20251114150133.1056710-15-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 872A22001B
X-Stat-Signature: psuneh3xhnhku4ibruijo74ttkgexm1k
X-Rspam-User: 
X-HE-Tag: 1763132757-431279
X-HE-Meta: U2FsdGVkX1/fukRX75bXpzAGrqxHae7Iv79PBYLu3EQgAIAidEWSqEkMAG6aQZMM3JoYvmZGLKpPuybT2XvwCmVUVg4QtXDkKMbS3Sh9rMru2JhOJQ8C3cTTsGz9xGaidsp/+T7+75zlcf8VJ9G9AyXiFbHvgGNgucg6svj+vDXhpU5lfFD5nMRYcFSO4XqFSmrS5cnoMT4/iUXTSfM3UbVnBlP4U9npxqWm4eOIIUoGo8outlpNwsageWnxEkMAfwEteEK/80utG9VYSNs0pQ95RfOQOkKBiAZ6rbmnxpacPWm9eVZMmxZbWTBIYaOOJgSYhh+N5dZke8JX5C3mLiEnZMMgw9512QdgsnapZNch+ZhcLn1MNQF7FKOvQQqZupPs2k0SjR2altX1pWOjmkjigxvctrhtczsstwnazKzND2qQvSrdCZ+ZYfKXGLbsFSe9vRIN5u6zRNS34dBmUBhb3jBZi0v4OAWS4PbWDeR1o34osXShjS5G+ZrZ9m7hfv5Eeu4j96dTtMx0qTNnwm6/Mu+D8SUK+lSWqhdnXui1U8t0yyZZNAKfAZ0a9a5M1Fng+Pl8+QUuyOYeOtEs5xqTpnsEvLJfRUr1soCz8YvtQhIB7O4N3k+N9TcbRPYVTVOtdUAgdxn8Ov46ioY2J2TZW2COT6UGb7A+LtJfA9dc1P4ugkHHSup8w3lNMGONPRec+MA9enUGcpRlqHouAmda2O8vjMJOI+3rC25JCZ5lj9LDzFxjZxx/2bpMGCpc0ZAIU8qfqH338h/MNqRUcXfqfKXHb0pka5akKGA7yAEmPwqyc0zr2HUMzKx6Cc2yN2bssVKpZ/lfUpxQ9JBeAb9fNXVoeVy6K3X3pXmO6wi1rnw8WEqT2Z1kOkMyA1QAQ6QxkeL+eYOPZD1FdJ/kWKfkaot7g9wTSbA0ZuzBev02jKIwmVVUHbfOWZq6ChHuVcq1UsgbdyOdpscTzKd
 A0wL8xb9
 lJypOSDZ6YPRzvx77FhhllzhyRdey7q49NTV0N9W9y+FK/yyy4eeoM0OgjVv51pWm4PgqK+yyyopUkS+YKJqS0b8e5DB5tfoVs4vYCx0+an1l4FAXd+EpRqPAAc1BxQwhG3c5uOnjr5VNCDA3cTu1S0107er60acSr4LoN4TWjVhA98wrhSCB+Z54EMrCbfzLzpB3cyCFHrleZlGSpI0nSpVJj7spnlHi536s1FyDZdpbny7n22UDBQLR7lQRlZuc79vQ+jnppFSf6fimuOgneLoSQ2GOe1PV0klvc/Bq0B/FIAdQUPS6GGdmsQwBcXwZ+bxemLW9pKLaa/6x1dU+us6lcOJP+Lt2gEAGIyLWhlm1OoTYWvjxWH2GNU2TSYGStF5HT28s4/e1MvdvdQPNnLkFUtD1Hp53i5jSgtAycbFBgpb25Wqry1hoITTB6P2o/jVmY43uUEyu8EMduPl8OlifX/cqKDch98TGSrMDohUqdA++ic+wNo2Vog==
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

perf_lopwr_cb is used in .noinstr code, but is only ever updated in __init
amd_brs_lopwr_init(), and can thus be marked as __ro_after_init.

Reported-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/events/amd/brs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/brs.c b/arch/x86/events/amd/brs.c
index 06f35a6b58a5b..71d7ba774a063 100644
--- a/arch/x86/events/amd/brs.c
+++ b/arch/x86/events/amd/brs.c
@@ -423,7 +423,7 @@ void noinstr perf_amd_brs_lopwr_cb(bool lopwr_in)
 	}
 }
 
-DEFINE_STATIC_CALL_NULL(perf_lopwr_cb, perf_amd_brs_lopwr_cb);
+DEFINE_STATIC_CALL_NULL_RO(perf_lopwr_cb, perf_amd_brs_lopwr_cb);
 EXPORT_STATIC_CALL_TRAMP_GPL(perf_lopwr_cb);
 
 void __init amd_brs_lopwr_init(void)
-- 
2.51.0


