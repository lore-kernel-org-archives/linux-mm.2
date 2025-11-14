Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504FBCE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB118E001D; Fri, 14 Nov 2025 10:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92C58E0002; Fri, 14 Nov 2025 10:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A91F8E001D; Fri, 14 Nov 2025 10:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5858E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:04:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3365E140408
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:04:20 +0000 (UTC)
X-FDA: 84109533480.29.3AE9915
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E2E340021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:04:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eZzuW9GN;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c85HG9M5FnMNKHSoA3zkMZkmQw264GRYsrTXaruk+rY=;
	b=euKK6rKXpuiJeuoiK4QgBafPrC5HoEfyXvV5SHU9J2gco0hgnBApD0v5bYyLbxoNIDUzq6
	hTxrpH2Ytjq58Kh1A0NJCWOHl21t+8Ux0zjpCyW4+DY04gZx/QTDEeKK6QkrWwlsTIoElE
	OSZIyxNglXTA0mU0ZNq1n6TaRjycpt4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eZzuW9GN;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132658; a=rsa-sha256;
	cv=none;
	b=yllCqcK9bTBl9I19ts/5FA1ObCxqSb20xT4ehMZYKLTha9+/kdNq9YClHhXlOLYmPCWPHf
	oGUMPIM9NfPWgoR7aiqW1/c6Lf4SzpogG7wOdA2+/Lbg2l46c/wbcBqP1qroc0YPvUeW9C
	hJDWSjvYG1LrWhHGIoK9QofErxF3MBk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c85HG9M5FnMNKHSoA3zkMZkmQw264GRYsrTXaruk+rY=;
	b=eZzuW9GNPSCX+G+UmtaYVhJHm24xanuwyf0/BYj5pla06Mt6BHUd+oT2Sy9bvPaaMkeJhw
	MUY497GvpY3IkHmci11t4XkK1xu0QagKGwnmUTS8M/m/o2v9lZFSvzol3F2oTXyois/PB0
	2m9DZm3K6vQVnKrWnXa3ttrzDbXF+nA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-IKnaOyZsP-KgTt9Crsfdyw-1; Fri,
 14 Nov 2025 10:04:11 -0500
X-MC-Unique: IKnaOyZsP-KgTt9Crsfdyw-1
X-Mimecast-MFC-AGG-ID: IKnaOyZsP-KgTt9Crsfdyw_1763132645
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA6451800370;
	Fri, 14 Nov 2025 15:04:04 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9839F19560B9;
	Fri, 14 Nov 2025 15:03:50 +0000 (UTC)
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
Subject: [PATCH v7 07/31] x86/paravirt: Mark pv_sched_clock static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:09 +0100
Message-ID: <20251114150133.1056710-8-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E2E340021
X-Stat-Signature: u7cd5dgwrmpnw5qq3yrnykyf7zgkwtro
X-Rspam-User: 
X-HE-Tag: 1763132658-232825
X-HE-Meta: U2FsdGVkX18TYSNFH1feoIhLldz5a3mIIhPx4Pwc1Loca5VmHXZTzBH4hZRj/t/y0ZQFXPLKhXKsNVorlyKmXH4gt7lCq83gbBgWZU0T2NLxMEQ+tK8n7dCj2UYLQ9jOzs2+jJNGogmKmOTeqZkZjeiRXYf/sisDLAXPOOMu/EooKBT7Hvm7UQDD0k46h2fmohxdPGcYufYDABz5N0h5dlfK6NXDwMNcpYek0kBlGduXGOe2KYcVomkCQhbEdK+vhtU+i4SzSMG4v+8brJNzZbG/5FGJjVLAqhL0FwrQxPNZb8/SG7uDgh+LjhrGzP/8tCrILh84hOWi3ft/y7WqSVnc0dZC3o9hhstMpPF+N4JQ7wr06SEqy2KkSiUrplYgmH+Wqp3kP9BKzSEgGd+TYmUUdo15SW0cffJKf4dLM4JWMzxtrCby4X280AV04672TmN8uW/a2c5NDpZ0c0+mz1GgH/t7XwccrXB8D/KAQhZ+QvK3Dee8Ob55mFIznghsRjMPOzKpKfFeb4X4wEtWLFNZfAmb52mHGs5kBSyCPCv9jR6kZVZ5jDyh0+UU0WbyNT2CjJDPiRAyEcxCaJFpGrDadpaZaHDB6aHfgtt/ORodjQ8R/AngapRY2ODls3+24MgrECM7J/06AN6WDM1M5PDSRcLmXBeunQkSzViBt1P8uRzu/GtsSnRCIJk/S2ms9ZU5cZ6IhiE2SvydZ0B8aVXAvXYoEKiN103Yoaws5L34mO/CQSIwKDmeFftSYlszGL7+bMYR3puVEwOUSlBBEbXlNB/Cyy23EYYT42OXzxJUjk1eLkpcX/FdgKd716G3FZS73VRHx8Wpua+w3k+VIXfoMm4ZgY6XizwKSWCe3VlNg/gZmkxx9hBPDRmualwi3D2n24SDhv+sKWog6Rh8Cy03a9dNoVppjf5xDmR/KzUZkIxXmhfVcjOXp1GyEdlmvrgKK+ZB4tLbSYLtMo8
 9SVgTceN
 clQKnu4zi4DoSHhzzMUc6ZWqKOr0vB7deWfTLj+DlG40HEupuHd4+CgYJ/53yVkZ97Ogk1qMIXnUN7P0WYebceOzQDONFBGRwc5xRfjHNKleFUwAXUMy2gdKd2tPFqIJAT85u7c+yIx7p16td3GOYKC7OqoKV+7fEpTHNCvkMC+TedXA9/6ilsrhx21fO1z1bEcVSyranJO0AcI9q74Im13yDPI7oKnhnYovil7ZdhkHAKTIv/lb724PfQ4jfF+4bM+/wvRtvACl8cj5YsnqzQlUa23uUvDAkfbIAuNWHCM+AB7k5nJoWXlcUdyS+S8hiaUni3MTbUnU0eAz6WUiv135WQ9ghKudk+4+aZLiYhJW+sZaf2q7FhXroUa1XumUWE3cymy8OsqBT87Si68ksXm0Dh+dIubby3dZJ9yUrw80d3CGtEktwdPgrF+QmJLKsnHN9QUj+Z8+Zc+P6IZY1tn7+A5X+IexOZLYPVpLhQMnTXBdwribQ/3B+zw==
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


