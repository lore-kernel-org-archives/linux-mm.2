Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D7CCE7B1B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603588E0023; Fri, 14 Nov 2025 10:05:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAD48E0002; Fri, 14 Nov 2025 10:05:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0FA8E0023; Fri, 14 Nov 2025 10:05:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE3F8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:05:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1734612E07F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:43 +0000 (UTC)
X-FDA: 84109536966.03.A7F5D4D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D18218001B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MMyzxU/4";
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCrVovza8CGhJ7LNJd85GGwejUDYWs5pqgpl3zVqzeE=;
	b=PWfkktzyoPOCfyRcZN2TlQYHphWGmSbSi1gtgKFULkZRGPbjlzXZReuW+cAZLX9qqp/MWg
	9y9/6O7wCP2vhwPtIyZp6vPTGQnXUZE9u+g5t2cvBNbe2pEugXxTE2pgIBYCmgOA2hk+jf
	qqa0r3VDEBVhxRItLSujyxpZDPwh/hw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MMyzxU/4";
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132741; a=rsa-sha256;
	cv=none;
	b=zKKCohf6GoaBv2kbT6679Hc04FT+NnFSGm7VJbPlY7RyUzCAq8xTblOKnNuYVMSO/iCajL
	9UNEwTEnfyXQN2tlkUMDdfObphyWiInXMBo5wckIWKVPLoypVg3UWRkdMCv4Wl7n6fj6Gr
	uaNXtHqmJvKYMjRxmtOfu7xngEiEk6U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CCrVovza8CGhJ7LNJd85GGwejUDYWs5pqgpl3zVqzeE=;
	b=MMyzxU/44NCroWyaXGuGxxhJTkgeZ3OT07Go1VuQv+p4Y1JIbdLsKz2Tso2rcf7hnG7FTF
	0WgwMhGK3EWWTds7IK4dyu4DexPDgpI8sfeHqGgmFnr9/mEEerEWR9fO31+yRGhe6b8GuQ
	YnSUVkR95KDnBaKTtmyiUXgAazu9RaU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-rVqwtSy8N46ZztWuPhAZGw-1; Fri,
 14 Nov 2025 10:05:36 -0500
X-MC-Unique: rVqwtSy8N46ZztWuPhAZGw-1
X-Mimecast-MFC-AGG-ID: rVqwtSy8N46ZztWuPhAZGw_1763132730
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8874118002C7;
	Fri, 14 Nov 2025 15:05:30 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EF6D19560B9;
	Fri, 14 Nov 2025 15:05:16 +0000 (UTC)
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
Subject: [PATCH v7 13/31] arm/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:15 +0100
Message-ID: <20251114150133.1056710-14-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 2D18218001B
X-Stat-Signature: 3kje5curastq5oxsy83a8pjy73dewgxa
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763132741-67561
X-HE-Meta: U2FsdGVkX1+i1LqwBotUNLOL514gaADzMbsvfbWGbYi6IS95j3af98Ptczd8IHXFxbjBGnJFoXViMgNMEeVK5w5FPAZVEtcZ2FOWuNF7HjtdPNvHhWiA9SPUQ5+l8VFTDd2x65lUYPTXoGGelKf53AdzjXxj/UYVHfqU3pOW02L0X39LY4EhAbc/vMrjQFdWFm81ZBytKogoWBGV3rXZBGxTW3mF5eLURxfKefmJiaP9N5lC54uI3HUXr2KBbGSSQDIpOA3yHBBEypyrD/GbTFaZbRN/9gN2agEHzJPMOipuaOexZgwn+o+KyvxkVC9KO6WbU491qaNul4ndfA6JMGAB6VbEawXkljloOEf9Ma2zWujVumCsvohfB0WhwBix/cARJ9rCGNoIjP3m2IktPAxJlXHI5bwXpII1RjBAaUBnWyHZRs05oFb0gUhAML6nNleUhY8Wb73twGrzSh3shIXYuRIH7MjP54QJloSk9Er5UvR8SySil8Tg89UM6nHmZJOlPqHkHfgc1yu3z1gTYj+pUaSQxpPYWTQlXtcUtPm+JIIR4qeycWzXiNQESnSNo5Zbd4nKQlMR9oWy9ckC32cZNtPku5XNANliPnFGRSmG17IWN+fk7A3uQiJd45kWIJllF9DC+ox5qxjfjNE1eFaEHAETb/tj99Mk2+7aNk5CbACasQc0tN9oSLnEQ63hl787wzSQTaWdGj0Au+2zfsH9P+ENBM51VqMszT4AFAkhE8IO5zsPC2AM8IN2F7Pn7WcarqORqsBhNPC4M3CDGXy7wlGVdRweaxIkxAgBBulqNlJz89H0OASkztm2EIonYrWPKHE3d5B2pbuLEJrio0LdT4W6ZnDxPyyIY8ntpNpYGVXXj6Dl112wElD8bPqe2ys5SxH6PFMxCjSnE0/xG/50XOWSWHHscKCgoLQi039bzpWzIQfotKIa/kuN6ri16GkA/qpedrL7ShNzf+J
 llyU/Ya6
 cWSCtic0RQnpIXeukXguWzLu33fVZoLm1bMRtshwmLcTIlagtPOCK2TOkj6QjdwPnQcyjWhefwhYFSnEPk/N9JnUJQN5+N8TuUvI5gsj3SogpjXYGLNsuhAJycAdAkJ4XcH9hF8COdj/GE2J+Al98FzXnnfXrOD8aQNhLZzZWxfvY8eboI3h62c0KPOGiM+GWUC5CPORrLswKmxwW6C1f+snp8r2Y1L+6agHiY8X8O8awNIe67u7BaxQTDtgNCJI/+HgZMtlGT0tWHcBYuRLbd/R7ROUbOsHDjMbfiwcu1rIRgdB7p7dkRLcP+oNejJNkrQMj5r/KQvgCjcfCNYNf+GR59IAAgPtrTiDKiyOceH25HTdwSBwiQ7NrOMQ30bbPXAZqCPnNoXVRnnsoYoEPjsJzbFY4BkkATtH3WCvLilRDLkr7CVjHDivf9yRHH2SHFGbajGKm9DIGy+d0urZz5RzPtv5YoczATWEP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in

  __init xen_time_setup_guest()

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/arm/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/paravirt.c b/arch/arm/kernel/paravirt.c
index 7dd9806369fb0..632d8d5e06db3 100644
--- a/arch/arm/kernel/paravirt.c
+++ b/arch/arm/kernel/paravirt.c
@@ -20,4 +20,4 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
-- 
2.51.0


