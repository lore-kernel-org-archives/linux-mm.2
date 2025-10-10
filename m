Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0469DCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E2B8E002E; Fri, 10 Oct 2025 11:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E8C8E002C; Fri, 10 Oct 2025 11:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DAB8E002E; Fri, 10 Oct 2025 11:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF3C8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:43:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7DD41A03B3
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:49 +0000 (UTC)
X-FDA: 83982624978.02.9FFEB75
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8AEFC1C000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:43:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GeDAW29C;
	spf=pass (imf20.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5MmuDhyyCRvim2U70KrPJRnnsespTvM3TjOrkj7aIY=;
	b=P/WfeJZfkG18zcQLjynVpvKbvy+h31eKZdltvQ7yUmRdQBpu8XT/gsKHEyB/zw8lhBwb1I
	8M8c1mZwaoDvSDWGngt+NiFORuAS7goKVmUTePaJpcAWKg/g9Xdg0XZOB6fNMRi72CTpZ/
	6tamjC+xIgrikX9VlAiC1owwWPnrMcU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GeDAW29C;
	spf=pass (imf20.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111028; a=rsa-sha256;
	cv=none;
	b=mFQjsjboa6i3VMETKoji6lYPgksfvBoXjoRgk1SZifjrmis7Hsg8Mj0RTiU4Sn0WRUmAGP
	2lQ3uf1qQCohOKUnOvX1yoNjcOjZbXl7Rbte6Pw2PYTJe8CXWtfr9LZHU5LXEiP00qnuSV
	k1ZcMZlUCIGMd70hPzJ1Rgk+nw/6Dtg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q5MmuDhyyCRvim2U70KrPJRnnsespTvM3TjOrkj7aIY=;
	b=GeDAW29CIU3hEw2LWAn+5lb+THlxQJPN0FWQIbB2ZZ8mzysJKM6WdvZbvd/Ksj3ltRW2oW
	4kqbB7zUFsepJZWep7NjD9Ok9yX1Fx59XtEcw4YoCcPX3lTfqlDaR5CIWXstPjnUy9S62n
	jk0UnlV7/N9yO7S3SkkWXEN31qlNy5w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-G9k2o7cPOD6yyJc_TP2uNg-1; Fri,
 10 Oct 2025 11:43:42 -0400
X-MC-Unique: G9k2o7cPOD6yyJc_TP2uNg-1
X-Mimecast-MFC-AGG-ID: G9k2o7cPOD6yyJc_TP2uNg_1760111018
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9C4518002C8;
	Fri, 10 Oct 2025 15:43:37 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BC4218004D8;
	Fri, 10 Oct 2025 15:43:22 +0000 (UTC)
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
Subject: [PATCH v6 11/29] loongarch/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 10 Oct 2025 17:38:21 +0200
Message-ID: <20251010153839.151763-12-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: d5b4ycoff8mt8rckq6r9s39znb45kmo9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AEFC1C000A
X-HE-Tag: 1760111026-347841
X-HE-Meta: U2FsdGVkX1/U7mylLxkTnwXeCUV+yhPpKPikA0SaDJHRTb39yIAYErwQumyvVbUf0c+qP2+abiBeTOMxBxSHiwYdTl+Q1GdUsRrWjG5NqkS91PSxXKCUNwgSUbdotl0dMTCyNFSDUbgSNfFF80gEIoa9+PsjyYunowkYjDzy7YN6rNKI9Mss9QzLx3EmZjTRsgMr692T1fFi2uZqmzq52ewHm7s1BD6ch7bf2K5cfBusgq4jW2TEhLvKD3YbRksWVMPqv/5j9+T4e2XI1Lp7Vye3tViWAKXMILonf5OabwYB8wal1VcVgInrZONkqlff6CL+d7imNJbaGORUN0xb7svCMWXnfCqjULodx7+42WY0fDa8YrLwwER+3Biosdl25SnrSQPU0QwW4f6ijgkFM7k8WmyyRHyBxXVPBkHElNSQWuH7z5B87Na5YnK0/dZO+KjC5O+0rp9pAo2oSWbIHh9eDwTMhaRvkxA6fGC8ExPZtqjKITQ/UPiTZPzEyDVFMcjMNf+9l9AJeUgZkIjpCF10vSZpVZOy7gpePzGkpvTHL87l1hHLM1RT37B7/YbF9BwMzFNufXJC/U+VyTPRgbkrljqYQx6qdLTGia5g97Ri6Ks4GYvXvLMcf8+bA749M5wwwI+wD3o8BChpx5y2CQrwJIeKP9AyrqFATRcqHjW3IZnAejwcVf+CZPLbHPaBft9KWZwOXRHZg6+Q+P3ZiY0b97vNt/4LtnMezWBvOz4g2+nosPClfa/hIeA+/UvDkgsOWzbO58sKYulj6RjLBEtPrwhM/7hEN2pz5HDgbgpWFYiL6I2bFR8PcpCyl460xGQg6OKis+u95IKZgXSzjA6f33jdXTStsb6zL3Pi6c/s+Q4fngTsr0dlc+eiKEP9eOgirBfiJ3zes/WIQa0Jt8m2R+XNcvqrWMsloeUnC9lRrS62bOVIC30U+1S+ThAg4GmHlj56U78LJee3QWT
 OOWAVpP9
 c7nKzoCOALkzyFyWA/FSExwjxixwyxZ/LhA+w49Bg2fWcP5vnZqzSJpwcHeWgLEkq5C72zXFdH4mEXuwe17NlJRV5ZHLywK/YLlguejvvedMCoFKbs1xRpK7vUwbphXclPQh83TYHvMY0CGycnL2KqZlSS3ecvsDfQ7azTUHj5Gy+bKxpxRwhv2ffz1fdh6LLr3CCWA2OXTn7Xy1V3+gbhKR9U16xe6YOaxQs8Lon34FiN9BGEF8EriX0MGbkNu5nvYTWjCRWQ/su2ufnKmQHy5CgcLov9J2cIX275P+wCnor9Hufdk8+l3FH3ZQ9VSbGPZ5ZGru4aUNORk4uYAGSdeIeLx+zP+WfMK3/EThToBcbpAFfPQN80LDIVFquoS12RkIerr4XZQ7nPu4MnduR77nQxv287rX53mb7jBHppe+SgedObGUy86L4aOsJ7iYU4JlZFryF/OV5PveogQ7EXlabLAs6SPJKW7d6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in

  __init pv_time_init()
  __init xen_time_setup_guest()

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/loongarch/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
index b1b51f920b231..9ec3f5c31fdab 100644
--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -19,7 +19,7 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
 
 static bool steal_acc = true;
 
-- 
2.51.0


