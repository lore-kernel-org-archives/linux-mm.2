Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B0DBCE7B13
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8478A8E0019; Fri, 14 Nov 2025 10:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F74C8E0002; Fri, 14 Nov 2025 10:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFCA8E0019; Fri, 14 Nov 2025 10:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56F3C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:03:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F25E11A03F6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:19 +0000 (UTC)
X-FDA: 84109530918.18.49BA9EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0226B1C0020
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:03:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQVLZamd;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763132598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HcZccm+EFWDfH2vO39s4AfZQgOMomacAD6OZP6p42M=;
	b=4TFyKOxNKv7iEY+mLFNjxis/ZsVodXKGD47kEu8mzCzLfbxjYzBlEaNnWHKDNCY2Lxcw9u
	sl6Zh32RXtW0OREo08K++Kfam5tOmZF8MmDqRqTxDpC/6f4E4qT4UekdegC2cN4P8AZLac
	ESDUhi5SOwAbutstKvnf5K9GBAASclQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dQVLZamd;
	spf=pass (imf18.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763132598; a=rsa-sha256;
	cv=none;
	b=Bp7WEz7wAiXNeIi+ChP2gIZpiBa8y5H6G3euBxwrl6+iim8JtnUzAFGa4rpa40U+0KXGBH
	6BYQI89UG2npSCVWTuHt69urSoyspmZ3ldTTarHNnUNoaae5YX7mfVHZlHiPibIm5zWZqD
	cX3d07cEy8PmTWiU6WRdlB9GVHiAtw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763132597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1HcZccm+EFWDfH2vO39s4AfZQgOMomacAD6OZP6p42M=;
	b=dQVLZamd25lIZ6nc8USXLjvIMZg1Ob9Sb1/5/c0Qet749XUA8VySRlNy9OYnmZaVjNL6W4
	4X6JF8JdkiwI/4MoYTb1HXCSYtMwYeQVx2ovTaUjsO/4kI1bIkLSJ1iWAjozsvXf5JmBQK
	SmqHTU2vIZ+0UsSx4dMYNanJL1XKOCo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-599-caiLroS3O_OR7fs6-zrwAw-1; Fri,
 14 Nov 2025 10:03:13 -0500
X-MC-Unique: caiLroS3O_OR7fs6-zrwAw-1
X-Mimecast-MFC-AGG-ID: caiLroS3O_OR7fs6-zrwAw_1763132586
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAD0D180034F;
	Fri, 14 Nov 2025 15:03:05 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.226.10])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CFD019560B9;
	Fri, 14 Nov 2025 15:02:51 +0000 (UTC)
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
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v7 03/31] rcu: Add a small-width RCU watching counter debug option
Date: Fri, 14 Nov 2025 16:01:05 +0100
Message-ID: <20251114150133.1056710-4-vschneid@redhat.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0226B1C0020
X-Stat-Signature: 675hu6jkz7txfyb8gcmfhnnpoichb3w6
X-Rspam-User: 
X-HE-Tag: 1763132597-892076
X-HE-Meta: U2FsdGVkX1/cB+xslZuXIBxWr0vuJljbEPM51IRpHEjV2X+QJbWR9GfyO82dlv2oPHc9K1h6bK5Skx8bfUx3p2o+SUpEY3lRPpyi+4ClYayniB9kivW0709vGr53mWTk5rNP4ew8BTAgg1qcfihzzvBVaOotLQcPxD1Orh5Z9DJeAt/OvEsb7bFJbS7FY4Jk6PvUn09pkz0bdszeHTyKdPxd5t6n3EZ1b9IAEpfwwacV9+Njvv8e9rfTmpARmWneNKlJ2ER/YED4XHxBE8PKZAcs4qVgSfv1/wNbH7aDEdO9EzHg58NPEcxkcKTgQdeUPJR5Rj8DkoOyzgTDWxJIQcXNrW9Ny34igt3ycaKOR9WhEub/bD8gCD0LFyPlc/AMdPbI7EGdv1oZKasQck92CJDPGXVlLZ9tFZYSHVYs8RiiGFL5oQ0WPfRvHZ5Yh5W1LjlCnYaHMI9foLlbACded4KxW6lBoRHkqXauvSQqaRnSoBmB0DDrQ7IiYQsZEzr9PAJ3/SzsI15IX/6B5xK33HuLfE0EgmUb6ySxtInCyvK3CZqy1Iz6EZAUqLuroXwOcS4WWETr8tZ3uWxr8dfaFcwNtecx2joxgtaDHpSOac9iU8RDwAvM6PR/3fVwA/ji5iNSVWlatBzp3x2ZrJ5W+P/+G03IE8OCHx77Y/qoQmdUHlJcXdzMi1FV781VbhRlqu9ULYXnJljASo1+JJK0EsDfUm7j/QYwA4+P8lO1hpDIoiTdaPtjpmYxamhBIE4SZYJI2kaiYPxJkIQRZ83/W+pOe2tLAOXWW4Bjz9ovPO9VteVNuUVzvW3AyoQ35AejapWGMflkje38eUW/krn57RO1JTejAmmUr+3cFe1ppBMS8qhLB2wm659EC29Yts86cozS+x9wIR5js8cp7b0Mus8QRaeZKofBX4aUBM0EWBhXUtfngXfkdPK/QEeL0ZObaE/xwJq4ihlkWfYAqA/
 xtPOoNKg
 X6whDQqJTJDiV+R+h62SzDnPh3DaJJOyL4al9+nwgT3C1erRoQH8WuS0osZRKkbIiHMDC4mQILF1CzjNQ+DJM+4J4LA1ck4Pp9cAZHxYXW/IvAlCRH+qT7+XHrwafB4wZRLFHbS6lyGJZYVOj1cw9I6y2/Qsl+8t2Bd4amyTd7n2d0xijVR1fDafLyhcI62KG/2FKjXQXzdfnMNli4WC0U48VLL6YThFSKRw70L5210+R9QeLRXeE1rQuqCMzoCuWewxfhOQ+6p9sGZkgYY3P6txXjTORLRfX/iIaeNlQvV0i4qhilzj8c/VA3XlJutlVP0lwH9Alvk5652F6H+XLB4zeXWP50pqNK31t9NUUEstCkL4or1Z98wrRMLSJcRFcWW/u5xep0CNbpYgoRKyQIY4YWxfDemtXYgwhPW1fH3kr7b7/M9dG+avp4W33qqdlzgXZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later commit will reduce the size of the RCU watching counter to free up
some bits for another purpose. Paul suggested adding a config option to
test the extreme case where the counter is reduced to its minimum usable
width for rcutorture to poke at, so do that.

Make it only configurable under RCU_EXPERT. While at it, add a comment to
explain the layout of context_tracking->state.

Link: http://lore.kernel.org/r/4c2cb573-168f-4806-b1d9-164e8276e66a@paulmck-laptop
Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/context_tracking_state.h | 44 ++++++++++++++++++++++----
 kernel/rcu/Kconfig.debug               | 15 +++++++++
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index 7b8433d5a8efe..0b81248aa03e2 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -18,12 +18,6 @@ enum ctx_state {
 	CT_STATE_MAX		= 4,
 };
 
-/* Odd value for watching, else even. */
-#define CT_RCU_WATCHING CT_STATE_MAX
-
-#define CT_STATE_MASK (CT_STATE_MAX - 1)
-#define CT_RCU_WATCHING_MASK (~CT_STATE_MASK)
-
 struct context_tracking {
 #ifdef CONFIG_CONTEXT_TRACKING_USER
 	/*
@@ -44,9 +38,45 @@ struct context_tracking {
 #endif
 };
 
+/*
+ * We cram two different things within the same atomic variable:
+ *
+ *                     CT_RCU_WATCHING_START  CT_STATE_START
+ *                                |                |
+ *                                v                v
+ *     MSB [ RCU watching counter ][ context_state ] LSB
+ *         ^                       ^
+ *         |                       |
+ * CT_RCU_WATCHING_END        CT_STATE_END
+ *
+ * Bits are used from the LSB upwards, so unused bits (if any) will always be in
+ * upper bits of the variable.
+ */
 #ifdef CONFIG_CONTEXT_TRACKING
+#define CT_SIZE (sizeof(((struct context_tracking *)0)->state) * BITS_PER_BYTE)
+
+#define CT_STATE_WIDTH bits_per(CT_STATE_MAX - 1)
+#define CT_STATE_START 0
+#define CT_STATE_END   (CT_STATE_START + CT_STATE_WIDTH - 1)
+
+#define CT_RCU_WATCHING_MAX_WIDTH (CT_SIZE - CT_STATE_WIDTH)
+#define CT_RCU_WATCHING_WIDTH     (IS_ENABLED(CONFIG_RCU_DYNTICKS_TORTURE) ? 2 : CT_RCU_WATCHING_MAX_WIDTH)
+#define CT_RCU_WATCHING_START     (CT_STATE_END + 1)
+#define CT_RCU_WATCHING_END       (CT_RCU_WATCHING_START + CT_RCU_WATCHING_WIDTH - 1)
+#define CT_RCU_WATCHING           BIT(CT_RCU_WATCHING_START)
+
+#define CT_STATE_MASK        GENMASK(CT_STATE_END,        CT_STATE_START)
+#define CT_RCU_WATCHING_MASK GENMASK(CT_RCU_WATCHING_END, CT_RCU_WATCHING_START)
+
+#define CT_UNUSED_WIDTH (CT_RCU_WATCHING_MAX_WIDTH - CT_RCU_WATCHING_WIDTH)
+
+static_assert(CT_STATE_WIDTH        +
+	      CT_RCU_WATCHING_WIDTH +
+	      CT_UNUSED_WIDTH       ==
+	      CT_SIZE);
+
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
-#endif
+#endif	/* CONFIG_CONTEXT_TRACKING */
 
 #ifdef CONFIG_CONTEXT_TRACKING_USER
 static __always_inline int __ct_state(void)
diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
index 12e4c64ebae15..625d75392647b 100644
--- a/kernel/rcu/Kconfig.debug
+++ b/kernel/rcu/Kconfig.debug
@@ -213,4 +213,19 @@ config RCU_STRICT_GRACE_PERIOD
 	  when looking for certain types of RCU usage bugs, for example,
 	  too-short RCU read-side critical sections.
 
+
+config RCU_DYNTICKS_TORTURE
+	bool "Minimize RCU dynticks counter size"
+	depends on RCU_EXPERT && !COMPILE_TEST
+	default n
+	help
+	  This option sets the width of the dynticks counter to its
+	  minimum usable value.  This minimum width greatly increases
+	  the probability of flushing out bugs involving counter wrap,
+	  but it also increases the probability of extending grace period
+	  durations.  This Kconfig option should therefore be avoided in
+	  production due to the consequent increased probability of OOMs.
+
+	  This has no value for production and is only for testing.
+
 endmenu # "RCU Debugging"
-- 
2.51.0


