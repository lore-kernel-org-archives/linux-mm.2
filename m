Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78431CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4C48E0025; Fri, 10 Oct 2025 11:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E4B8E0003; Fri, 10 Oct 2025 11:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADEB68E0025; Fri, 10 Oct 2025 11:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959798E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:41:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 627E6119C1F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:40 +0000 (UTC)
X-FDA: 83982619560.02.7D888D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id A1DC9120007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:41:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f3dBA1xg;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760110898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HcZccm+EFWDfH2vO39s4AfZQgOMomacAD6OZP6p42M=;
	b=eRYJNA88YKlpoeOya4BEYIaa1vyTXiXWD4O/yVaZmhnGUL6jIRlPUUJXjK+KaBrVBO9Hyu
	gCwg6WSSDdqzW7N7zBOjY7nLjD+yjYSa2qiJQsbIgRtjVjn/IZuOAwj33JyQoc8k7FoRT0
	jSGu8uF4MrFmQaLfriXFjINrZxvefVg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f3dBA1xg;
	spf=pass (imf29.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760110898; a=rsa-sha256;
	cv=none;
	b=u26XztfJ1b2Ey5zexuVE5x45RtXTT41L8jpSp+CiiIT/zyHXeHuuyI44Y12Brm3YjfJLk5
	3zTDjjl0BFEwFI9W5mYOd3EWs3q/9wbL0VltfGQWzSpQVRFaCISQ7nIvpYgmq4/Y/7surn
	4TSDb9Fuitf6RJVRoQ8+ROrlzzYvZLE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760110898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1HcZccm+EFWDfH2vO39s4AfZQgOMomacAD6OZP6p42M=;
	b=f3dBA1xgmoMQ/qOhl9M87RKX1aNGGefQ44x9kGqBg8F2owcPWbP415NMEfSLQkv9Ujf6H+
	9Ou2uVBPRdB9MfyhWset8ZNygYGJqroRImP02UhPkYg+sLhFRDlD4padp5je/vg8LqUPfZ
	+vpJ147nSBbMBKzlxNs34k3CIzUfnIo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-zXwbd8ArM3KVjfpSaoTGFw-1; Fri,
 10 Oct 2025 11:41:36 -0400
X-MC-Unique: zXwbd8ArM3KVjfpSaoTGFw-1
X-Mimecast-MFC-AGG-ID: zXwbd8ArM3KVjfpSaoTGFw_1760110892
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3CB21944F11;
	Fri, 10 Oct 2025 15:41:31 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D5F991800576;
	Fri, 10 Oct 2025 15:41:16 +0000 (UTC)
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
Subject: [PATCH v6 03/29] rcu: Add a small-width RCU watching counter debug option
Date: Fri, 10 Oct 2025 17:38:13 +0200
Message-ID: <20251010153839.151763-4-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A1DC9120007
X-Stat-Signature: 3trzhnmqcwca5pg9wsdk6ozx5axnhd37
X-Rspam-User: 
X-HE-Tag: 1760110898-294803
X-HE-Meta: U2FsdGVkX1+UVBPrIgFn+OffsE/Lk6EtxOzupgeAicnb6JczQuBPE5gEOLy6wiTyzwb4XvOVjX0E5UFPgGSRYtpF6mx9jdiIZWuF6ihSILaSMG8ZLF5N46w5S11nM3QOhesrA8g1kMqEEjFN5kcTwyt1ldq0p1P/gQqzsBurRb/5NlziEOBfZlY6hNKYvDizUclZN08/jVEux+bYPgZ9OmGBO32qq6l6PTerLJOjfx0LoTLPoxjR86jmcZ4jUYd07eTk1Ynppz9D+HAmcmm4EYxJtdIdhG9JKcdPDtpLO8LBqledQKq1z9qEAwTMplTj5jIA1ukhAoRgw+s3QyZ7k2GrulwwD+vxQve5BtucV3gnHI8+vyz+3vzZy3+GByI31Hx9zdIaFX0FKOuyXITgijfrEwSh8LR9HAs37tNbrtB8P29oKeZf1gAiPXYbRTX6QAqJFQk+R42CckOwxf9xRFtzjnKRTVvJ/0k2ESouPBwL8TYa13qYB0oc+f4leVwavQRv6eOAbREXt7OWNyPU4/jq6m4fs5ffuuvDAjRGwhBEoAlNWpJusmSYNwMLafGCy1zz76b7F/xdVWnwnoKBm4W1IGjJuczCMYYKoeZ9IwrCXieC4Ayfz93rb7PZA9a+YqFi6mI5p8MA8+yRzr08fWmVc7G+3AXZ3347L8GtDeqdpJsO8cIFYrvppy0d+e4aSOVufViFo649arYMnqqkG1rfEIo0pfiJ1JRB38GyQs/acqjEPf2R74GjBQUBv71Dh5aYc4ZNXT1RKLpIejLyEhUnBiSyvbmzzi1WQyoux5+QSvpJxnJ0UNUD6f151wGvFJFNCi9bkiW74yOrjyCmFKzzjkTgN5Zl+lMz6PTlxY2/gAZrcwAAR4L2cvlkE5AXhXMWj/xADi3evlyMjOaA9NQHTHRZaHDYa3+Dq4YYEctxCaSkqlm3rmQ1KMiG1EGp1MpSbp/LeWlZgSsql8Y
 jFSkHT+x
 j7Rp3x8OBJd22Bs3J1oOgG51DmAwmh9pKpZfapKfLr6QImV2Iaxm+vHEa4NjKKsV1ocC9UR/GyMsBS+jG3HXLPVYLOOSXffq0VgYX5XtwVASfIakfffuDbHdI4w9+t6gkjnogGvLCeRyMVkBhL51p7JQ4Sd0wwst6DH03a6sKvgMhwu7SchqixftvSryHbJJlgn7wWO0V87DoFk2kNz14CYH9s9KZH67URq6I+PfGK4Cv/ZmwSNzTsGAmj00jmzq1vUMhoVNuXarF0pnHaQpzV5Ii+ArDbFjISX60Y7SAUX9nN88xOgETuBLEXambKOmdpn+BB8+4zsoquKO0G+oXIJe7M+5jEol0i3b6fcBjUNxQkfYBzQPIu5mmMNf40aM5GzKm7Z91O0E9uvx3J6EVls0UOvgXtBmOQtzSjXqtMMcECs0GhvyWc6hspSH9adJA5kzY
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


