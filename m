Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C81CE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4CB8E0021; Fri, 14 Nov 2025 10:05:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A55E8E0002; Fri, 14 Nov 2025 10:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 194AB8E0021; Fri, 14 Nov 2025 10:05:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07B688E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:05:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CACAF13AD53
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:12 +0000 (UTC)
X-FDA: 84109535664.22.0EB8BE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 006C54000F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:05:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMKYjwTd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5MmuDhyyCRvim2U70KrPJRnnsespTvM3TjOrkj7aIY=;
	b=T/u28/3SnVbtlDNLtfE+dC9mpioMOvxJqFrTtyerSu+J8W3n0ou268bmc3GWpcmb70ChXc
	t+XPU013Q5xNHSsf2b/xVwjNIs1UV4EzmndxgMeztPzVrj94UKO605SdXacZm102Hy7hY0
	ldqI78fvqoddIAWr3aqkGYFBKgWwoNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132711; a=rsa-sha256;
	cv=none;
	b=oT4phjO1UXA6EMn7LWgPKBBemUuVzKYvRnxog197IkRc3eBlZfXjnI3mLfUTdsyE7nXq/T
	u+3ckXXGukxe8RmdyAoFKE6hJ9F46idL4PdsYWl4VoB50kySJwmuwldOMvtYRP9rJPJ2a1
	D50uSbfI/Rbgg0ASWGo6T2ZoHiUADR0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IMKYjwTd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q5MmuDhyyCRvim2U70KrPJRnnsespTvM3TjOrkj7aIY=;
	b=IMKYjwTd8rLpNLVXLeRbEXkjPnkbTek8ENZnagkJ3+Y6GbslKsfYAF5hwU1VAQYv1j864C
	9da31yMX4e7ot3w85YJen0VXyFYLn9EiCgYPvu87T+sf5h0nQE8aO95COXI+FA8i0GhaF8
	2CIeITfxhQQbMVzr004a4XW2C09thSk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-bfH3JdWFP9aA7fMba-3JXg-1; Fri,
 14 Nov 2025 10:05:07 -0500
X-MC-Unique: bfH3JdWFP9aA7fMba-3JXg-1
X-Mimecast-MFC-AGG-ID: bfH3JdWFP9aA7fMba-3JXg_1763132702
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 816D61800EF6;
	Fri, 14 Nov 2025 15:05:02 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0974619560B9;
	Fri, 14 Nov 2025 15:04:48 +0000 (UTC)
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
Subject: [PATCH v7 11/31] loongarch/paravirt: Mark pv_steal_clock static call as __ro_after_init
Date: Fri, 14 Nov 2025 16:01:13 +0100
Message-ID: <20251114150133.1056710-12-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: sf9aqedf776fuhbniwsu8amjt8tojwmm
X-Rspam-User: 
X-Rspamd-Queue-Id: 006C54000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1763132710-360072
X-HE-Meta: U2FsdGVkX18vzmeHDdA4jEqCgz1MK7O4LHWO84mVJtt8XC3hHGBxOAbcpf3PYSgAIwvQU4C79Iqrp9dzi6yHYj1oFPWMAOGecsbwGx5jmQ/7oWrkqQyb/bZUpfELfEv89vp4P7ZMdt4Y8efvHaq8MVQcmS4Rpt4heHsUuPZ51V4tZUYUz13Lu+AGkmkzA8SlPaG/zQt+I5hPT8A6G0qTzcX5kLy9n7Pe+yQC7UUDpPxJwGLYJFW+WfHpKYe3twLOo2yhYbikXz+7nGuVKEPUCAP+6knhJm0c6nOgONH7iQq5y+LDU5QWo77UMwG89hjF1Ku4ZSYIycVm9KPmFz3+urUUxca0xxJebuJcwKkRij46qWtdW/JYMjgQz866V0XZk611DUu/OJyU+WpJQxiYN/A4uaGzTlP4Vq276slCcC6+ZN/vMmc+cF1U0ELW2mmSCQM4GhjvdbvuWHhJSemo8agCtOyijBhnDZUEpMwz8X27Yy4aOCU5Z1g9WKtWiTjwpuVGvyuzLW9pl1kTeoFDkdjvRp2woFm86mTlk3UsKf70/A0ZMxIwKJk/5WtjoE+BhHz8nIfCzuUOpvPY0SmBdk3eyZqDcDqJSK9JJ2TL0+3gP3CgR3J/U7mbH1rH+RcH+UNiH9KdpZJatPr5BrSZFmM31Ak9E7NGpuQdY0GNsLl/MAzXXsaBFqAllT+O4zN4+gKXdP9koc96tslui04Wi3zcS3OVXuUI4++XazP0852xoiztC+iBaseD5/Z4GXeUeim5FRWAGEQQzpyv1wTaWL63szV8X5bNUWrU6SIa+jQ5hGpQpWoYa4CObf+ep5/vZsh8dje1Z8xENxxveUuMXg5N3tJMvCC1/Kyt+QebQ64W3eYVbP2BD6Ak1mI3vlWedwPISaXy4CWESW1FkBTKkt2R/lOKxTJbYCVNJ3ZCFcsZVkdujNCEA9dssqK+5BwBw6LLpZD/NK6ny3xpk25
 Vn7CEiHv
 +aiLAFuEDEKZYayVoGJ66Pz5jFGDwKYJiT+M61Cle6uTYzONJHRnodQtkHbVBClHMRF2gluYlNNYPqBSS/1E85H/Q4lyDZiBBcEx3weQYlJkbz3GnUrnk67PkaDimUCy64xPKNXzcRGG7GzteKy9XA2djJQLDoNMjfqCOj85HR8lhJOkje7LzybvDtMdF4HYhse6C2NSNYhsb/el7bPHBb3pHeHDDvMrqT6ceaTx2SwfS8ZBVmRJfvvi2c5uXhv/l8bJSCrBh3N0fOJ7XgS+m+YGnuDNzBX+XPsybMlj4JF6IqaVh1oVbTyJwmHwznhdMt9hglWvcPhrEUA9pmFfo8utHtI0V72QzqtPNvp1RZHJQAG3JTov8ROsyz2+Uc8okZ2RQ9KJ3pMIqF0hrWWVUIS0o+ATIrYXxUnyfyDEmJwcOfP+sEoHJK4FnXV7McngIl7VpRKqN1Eru4d/YiJfairaXDLZA9IhEbZO0
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


