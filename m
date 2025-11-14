Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A39CE7B1B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B324B8E0020; Fri, 14 Nov 2025 10:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09BB8E0002; Fri, 14 Nov 2025 10:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F938E0020; Fri, 14 Nov 2025 10:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 906D28E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:05:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDD381A03F6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:01 +0000 (UTC)
X-FDA: 84109535202.25.61B56B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35FD4C0019
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WdY5mwtg;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMfkEjR7bo9/GPZWUZrcsZpIJiAh+KjKI2oJCMzgHeQ=;
	b=idKmYm1ovXisy7+7O7TNNhItV21io9UsQ3voPOY+avXeWTABjKu2esjtotfTnYkMmO46Uv
	0F1ZcYOWe1EzrizAvocj5JxlK8An8EfeBKw2YHQG92u4TaMA+guszfz4uSgrYUlCZT+OHA
	8R2py5aw6ShfKoMES3mdSuU5gui9bfY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WdY5mwtg;
	spf=pass (imf10.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132700; a=rsa-sha256;
	cv=none;
	b=ieI+5uXRxV5+OlYoewsYdfJOPLWp+qQ5AuE7O9k29lv7JGO2xUA/QVetw+pwzJ3Q/dTjtY
	RehvGpf9bFgQ/Z3/Y03ZMSQ/9weOqJv0F5HAJbX9RqOlkvXMRDFbaWLnLxBxtV5+uzLDfq
	cHZ1JAGZ0ECdrdvKXZwAelwJxp8NUWo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IMfkEjR7bo9/GPZWUZrcsZpIJiAh+KjKI2oJCMzgHeQ=;
	b=WdY5mwtgnT/mz3lHz1azcCjxpA6NLnfD60Yk6tH8wGhJZwrpZd6/CrkyMBqe0gljZwX7DR
	neDOiZA5mPIP11FNboh0NmMemOr68m9/sS0wtROvlQHKGQsAqe7+gOocPTi/8nCDG+BoLw
	Q2qAecQDsxL713U+5sTlKBKMSkSCEtU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-pAP02oI1M8itOtKzo3ac4Q-1; Fri,
 14 Nov 2025 10:04:56 -0500
X-MC-Unique: pAP02oI1M8itOtKzo3ac4Q-1
X-Mimecast-MFC-AGG-ID: pAP02oI1M8itOtKzo3ac4Q_1763132688
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84A53180049F;
	Fri, 14 Nov 2025 15:04:48 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACB2619560B9;
	Fri, 14 Nov 2025 15:04:34 +0000 (UTC)
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
Cc: Andrew Jones <ajones@ventanamicro.com>,
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
Subject: [PATCH v7 10/31] riscv/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:12 +0100
Message-ID: <20251114150133.1056710-11-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 35FD4C0019
X-Stat-Signature: 7htn4ww94feozkmajic8yspadwdmtmz3
X-Rspam-User: 
X-HE-Tag: 1763132700-318161
X-HE-Meta: U2FsdGVkX1/Z40dkDcs/oTvBrjTx8B/G4p948V3hoLZycNlQoO39HhVW0e57usxhYqYKEHXqJ5u8U/nr/8Pu4oCqMPN49CoXL9JPCdXfzB1lQ3z+VC/CKNZ0VRUsKLXoCyair6SmWE277nQ2ruTioMhRXZO4nOUER1aeQDewouCdWy4a8ajd1q80tAaQ7Ne7+Y7+RnfQO9c9slhpt0gOwy4nTfp7ytX4hCr1by1iqyD6vrkSX3FiwlW0wKAeP74s7CkPBEAfsJokerVtEv5Ig72aDENDtmiQ7N5eG2L7ZeVHaXy6JSP7FHY66WQj0RbdZXe5QoTXCkXKPlvEdFq7NRSApYjSDpk8Du1RE4hbXEee4jcB610iVuA8GKAuPSAKHN7Bdwav/JYaL0sLctP8zpNtXD6cdoQKnbERNhl+2nUIOAy/3XnUDYu+MyvV0ZPomtqAQZVTp7fKzyHSN0ZYh8RAqz+mLgMpUo6FwuZYye+U398wTEEAUk8m9CJMts4emAnqwIbdQsd2aYK5cCy5PJOgE6PLTH99RrSgnVoHudQ6NrVbtDYn6WRalIJeQWZQWocXEWcql8ZnutNI6zDp0JLVPTZPnSteIwStghQ8P/STPahBK7tzrbv5QjOt4gvFnK36aRfBMEFIKIQKc65rCAV46gaK0rCwbOujBiNtsiNdySMxgvfU1FWffsi2uhug/lqsY8EOddwtl/pR8JXU4P62LF/jmikGdfNoe9E9C7pX6igDbjy2jbtpoikTkiIbnKQgWNUOinj91Qt5+IC5ECNyuEX9UgIHhEFgzEB8HoX2EKhwE2tgUF0PDjsCg9wvvIJFQdWWHQm9nIeImRGFyf15u2+g5K1CNj1YpFc19BHuI3jDCDprzo87N3bB8dKa3Ps36OrywVlSE5pW69MCe6Uj2jcNXIYkpyQDBcGHo/tIWDeXumgDlHVcoBxZNrjs8hDneEMsywyFePGwRFR
 57GlTYOF
 5NJT/xwaVAX3wqwl8tj9YyEJEU5Fm0FNf+OOyeaJHS1R32LX/SIAdlftM+WMceBQ/DohAf/JLepXlb5ENVtSv7o5XaddnRFBtfGrE0rIuUZNfnKexj5j5R79HZEK1sc60Ywt4pBVRx6M3PsiY9uia2VkmotvJ1Hrjse+Y7lXDjhxQMwj7kaQ7aJ6oVKyoRjLV5sY0J0fkh8hPrUaj/+tBxsCz17GkRYZ93UCcygJfW82e3InA+5VIvyzylYkMPuZds1U43SKdyKxUcGY+xFRj0KrqbQ5siy/+9mqIynLyMBRY5LTHbHjbpPqvPzRNfvm5DWjYPNsDtTZNmU1RDfBYzUGf8A5PGE56xzOZfhh7rcr6w5ltgDmu9rcZu9vbV7VsJgQpg3+ZH+Q91L08UErIIvhDOzw+vs3IQXg7pmRaOd9Ymify3+O1u2Nh3Ru5zrrGikwzDjMk7JsKXxDjaZpOaLwO1EjzBi6V4zyt4+SV2Y8NC5kR8Qd4RiqoMiF5UwVxsf+Am7PP00RBeW/xvedqsnLCtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The static call is only ever updated in:

  __init pv_time_init()
  __init xen_time_setup_guest()

so mark it appropriately as __ro_after_init.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/paravirt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/paravirt.c b/arch/riscv/kernel/paravirt.c
index fa6b0339a65de..dfe8808016fd8 100644
--- a/arch/riscv/kernel/paravirt.c
+++ b/arch/riscv/kernel/paravirt.c
@@ -30,7 +30,7 @@ static u64 native_steal_clock(int cpu)
 	return 0;
 }
 
-DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+DEFINE_STATIC_CALL_RO(pv_steal_clock, native_steal_clock);
 
 static bool steal_acc = true;
 static int __init parse_no_stealacc(char *arg)
-- 
2.51.0


