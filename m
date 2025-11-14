Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5E4CE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D7B8E001F; Fri, 14 Nov 2025 10:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD658E0002; Fri, 14 Nov 2025 10:04:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5A88E001F; Fri, 14 Nov 2025 10:04:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6B898E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:04:57 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 591AFC03CC
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:04:57 +0000 (UTC)
X-FDA: 84109535034.03.062F82F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52FFF140010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:04:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=amwTkeld;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1F5Hxk9Mh6e5UiSiQQtZ6dU5HQkdaz+pE8DP+qaty64=;
	b=kLSElF06XMAg6E4l7G5MUe2UfGZFVWqURCtcfgQf0eXf+rPxxfKrXXQQGOishlNioTNP+A
	P5c4uFwTd4xgO/bkfqZhL3BszCl7C3CvewsPlA1Jd+V+882kCJDL0pAN/KcAYxyIpjLyb6
	E3iK23QXtvHWlcBWEL522h/PFdIdw0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132695; a=rsa-sha256;
	cv=none;
	b=AbYE+UiwsmYywSy1JcyjPktRvJRt8uA6enyUZ9+ZlTUUtmS0blVVBUkoUYjGKgmeVEKt3A
	07J3CcK7ZGm7qHVglxcp5f1c/KEzWbSV3grwkjCuLoKWyJlHx4JZ9D2rREdYEP39dMa21N
	iR/Cutn4/OvTGFX1Z0n9rX5rhu+X+fE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=amwTkeld;
	spf=pass (imf09.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1F5Hxk9Mh6e5UiSiQQtZ6dU5HQkdaz+pE8DP+qaty64=;
	b=amwTkeldCsxJCwElgugjnumVar5m3/1OBauobdBi8wGjRqdApaBwW4JtdncZBMn9SuSXDb
	2c7AQ5ywcQOkU3e8oqUviZOdbnyUPbzB2P1eQ3HAsyCPWUK3jEg+UXHmIczwxhzMF9qrjE
	N5J/nnNw36iQxTtNgred8u1gJ31/y7A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-e5rvPyJPNhuu33SWJLhDsw-1; Fri,
 14 Nov 2025 10:04:38 -0500
X-MC-Unique: e5rvPyJPNhuu33SWJLhDsw-1
X-Mimecast-MFC-AGG-ID: e5rvPyJPNhuu33SWJLhDsw_1763132674
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3599D180034F;
	Fri, 14 Nov 2025 15:04:34 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B58A19560B9;
	Fri, 14 Nov 2025 15:04:19 +0000 (UTC)
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
Subject: [PATCH v7 09/31] x86/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:11 +0100
Message-ID: <20251114150133.1056710-10-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: s9k3seshob8xyktpjtepaeukn63g431u
X-Rspam-User: 
X-Rspamd-Queue-Id: 52FFF140010
X-Rspamd-Server: rspam01
X-HE-Tag: 1763132695-501285
X-HE-Meta: U2FsdGVkX19rU4+i9X8gYZx4zW4aVBPBduir4wS9hGyBr0r+BIClRu7MkmCx/TVcbzZ1vxzHsd+adEzMkcj2DLi5i1zp/a2JCVtVIwyc5L6IKR5iWlWmbz+ZaPRJFbk5VboM84nqeLZ8IyiRtRymoDKj7X9zZniCZ0BSsf7ODWWjsCH7Zz9X6vfGDIrjnYso6ziqPjDZvyp6TD9jX51k1C2ye2JgB8fZYx7d7pNk7bda3RA1Irc33RurMVHkIeU2DDiprE49RW/ywbKaLwazmTfFC2DQ7hof4fQTJW+hXPrjCYpnERDOpJCFlFA1f+B/tmQtspIlZhh3JdvViJk0Azagjv7A3KTV6yK3+AF790vwC5xg/QuCLOU6c3DRHhU+TIw6GGYgBSHitT4D679WNKZlEe4zbcCFsftJajsoi8euq96PCFg6ZQgkemBoFELOipWEdWI3VpFFnjWJd67WpMiqQsPv6Aq6Xj1aZIc43jb8brq/CcIXY21X3O9NBv7+QCVT4qWG6sQqB7u90VPmzhnVMTjfbB1bhxY078lJ4uvcZM/7BNe3w3PBHBtuWrGayNZTVjWJ9sKMgcXdM6U6HYK8scqE72rnQ8QonEbg2hUwAS746PPXAddA7Kp2D79b+7i2/BKt2VlpnQux7XI08ZyR1cdCu8kejvztyHYttZheRWRkfUBahN570vymYb34rfD30nuVNJ8d6tNcqy3PhvS9WeMN/IV8jzDXEbMMdH++1hp7FeXt0HO22vl6MN9E7OBCd4ztqtkQV5TEjIJD3vuOEU0oqxZIyR2IDIOzOoWfqTnABrAMq5/br8gI80JSZJ5HLaBDn45xftvo37AMTRZXdfWsr8AK3vmm0O1/m38TroaH71vJs0p5VZ1LGlMh82OWKZMoeNXAlf/fmenjiMUf0L/n08jsTSfSxn2zZV9JkzAQ21JGCSbd2QdwWMlDJ6kRFWBM3j+7HLuGIrh
 uxT8i9e8
 f9fNqYTpjqtwpB8Z4Sy3Wsr2/s1HColLzfnAkII2H4GVZ5SYbE+1huSNkE1hUqS2EE/X48lH1Qe8wH+UazDs4+/OB1D6byDI+A+hHyUln0l8o5OFhslmCMGCXSnW+Dle582gqbOaNb3Vxn3XOMTV7FAZZH8Xn48QsdMeNJNGmsDBAoFEe/pnRBfm8o2KdL9QJo/fVNBmcfqKoXTPJlg78qlCa8NY3STDkUzq6JPVEn7ra3raLvUZqJs/31UAprjbqZA9BlY1bTNEsVSuNoOh1Qo9kDK2Z8NnpEWGZAH7GkYFf2Li7SIpSFtBTn1mB612ydTmDuzdCy1sB04W2IDTbaYOokp3fW1lPXOr/8kJu3if5e/WW60zPiH6OitFW2JkBJXRNFw9oQDLFlrD9SyJBvqmikMnErbGH+NZeBz6LuaZXuOtoB4xUdmLI7ICy5aw3EX7CPm0gRj6yKr1WiqraYigg7nXvoQsM8DJq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in

  __init pv_time_init()
  __init xen_init_time_common()
  __init vmware_paravirt_ops_setup()
  __init xen_time_setup_guest(

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 34b6fa3fcc045..f320a9617b1d6 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -68,7 +68,7 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
 DEFINE_STATIC_CALL_RO(pv_sched_clock, native_sched_clock);
 
 void paravirt_set_sched_clock(u64 (*func)(void))
-- 
2.51.0


