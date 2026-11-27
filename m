Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B595D606A334
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JqTkK4v3
Received: by kanga.kvack.org (Postfix)
	id A41B66B05C1; Fri, 27 Nov 2026 15:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1C36B05C2; Fri, 27 Nov 2026 15:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9F86B05C3; Fri, 27 Nov 2026 15:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC986B05C1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:13:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 833101404D3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:55 +0000 (UTC)
X-FDA: 85482000030.20.51BBB04
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B6132000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:13:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JqTkK4v3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810433;
	b=XEN8vAYL7r/B0662uftz3pli6EZFQc5Xz8+tdgVxhIuYfaoXbu5ZFuwhC0TZTsPCVIOBXl
	evuN50eQKKv5EGQF1cVMbbpinJCaUmYJ28/bC2IarHgR4Hp7jtcGSr8sbJyljNPg6zansL
	Zwp5luqb2FVy49aLUioGGHR7YrOFpnU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJfwTSeeJ+yb+vdh0/54TF19RXF4fHrqZ3LDnG1zeqY=;
	b=Fx82712viTJLE928D6fux3VHQ8QAwlFpZRh6w1vDDt+2c/IDdTLB6J9t2rLTFvJEcVjMCE
	rexylMoa5S5vk6uITvH+bAA03yIcgqyh14EVoFyVuyVccqvfaBmgc9TNzZEoMIPACUBvI/
	Tvh2vX6fvedetCZJFuzkUJymJ9JVylw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JqTkK4v3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795810433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QJfwTSeeJ+yb+vdh0/54TF19RXF4fHrqZ3LDnG1zeqY=;
	b=JqTkK4v3JCKsJN8yI2x3vMBU/qA8WNGisVAzRZ5xK3f2u0b6Z8T8yfReQgtrjOJZR6AC/j
	R/52qQ7CP96Q3YTfRMcVOkwvHt2cyEzawpAm/ffojvSsyuGf1R6wBXfRLONIJUN19Yc5pu
	8MyRwC912Bd2SXC0+mQduhXokYuxjuo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-1wq_Zv78PBiGjjtMYbNPtQ-1; Fri,
 27 Nov 2026 20:13:47 +0000
X-MC-Unique: 1wq_Zv78PBiGjjtMYbNPtQ-1
X-Mimecast-MFC-AGG-ID: 1wq_Zv78PBiGjjtMYbNPtQ_1795810423
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CECA3195605E;
	Fri, 27 Nov 2026 20:13:42 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAFF3436;
	Fri, 27 Nov 2026 20:13:32 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
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
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Dan Beimborn <Dan.Beimborn@qube-rt.com>,
	"Pak Hung Vincent Chiu" <pak-hung.chiu@qube-rt.com>
Subject: [PATCH v10 05/10] jump_label: Add annotations for validating .entry.text key usage
Date: Fri, 27 Nov 2026 21:12:16 +0100
Message-ID: <20261127201221.434876-6-vschneid@redhat.com>
In-Reply-To: <20261127201221.434876-1-vschneid@redhat.com>
References: <20261127201221.434876-1-vschneid@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: kC0bIW1fzhf2UhpSOrnpizsfGastyCMu_D994als50E_1795810423
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B6132000B
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b4i4o1ugrks4cofkinbq9noz71r8pq8f
X-HE-Tag: 1795810433-559490
X-HE-Meta: U2FsdGVkX196A4MDH+t3stQximdSB3UM+ma+fVYKiGSavq03Gq+2Hu7q5uDmMKi1xO2ejc7O+eaeMS4zaWpy7PFhyeFvHu+tTspeTNH3AjW86WLAlOggBRHZGnKqSruwqdqxbfYSWKTZfrNPWjoZuQpcS4qCCjzOxEAQ59a2wrzpixLYakOpprY54ci0s+S54iDdN7dkK5OOfKVh4SUzVOZsJvtKHlu9pZ2r4jHUOXKuDevhDMH02RXffU5/dRqUpDQ577VeF4sHJt3NuINPL2XAVszg7MgaPJE4eXhXpkcByR3L7iNQLXY950fnklDGNUk3zJUCAlqjQh56797F1Rej+QD7dMfWO/RMLpsZCMzSPz0naqqtDoCmHOxZ1ITkz0pwsCit+gawT4yb8Yz9ufPD4zHIDyZ6ZeaPee2FdKXSjiZC4IJCQ2lvv85I927Eevii499FXavT9rRVVvxlqfT3gxDeINFw+ACskslS3kR0uYQ1nNx3af8dn/Z3UujhYKdhWsufH/ciAryvv5Pu8JqQ1oRo/SBbS++MCq4u0fADGXdWuA0SuQJ/mxSDBgMUJsOD4CUEtz2hQwjovupNrdRzI9lH0b1z9XfkDrQNOdNaTfBalS6CRVbMVfr+rQgFB1ux1qWP9BDt7gPqYOay9M6HL9sEPQU3XNqj5PeafZM9E3iiS9wCBYcwgsxShwIcR5EyQ0miXZY2xXa6tJeFQXnmv2BbM9vHAJTjutwQTGWirk5rP/L9PBBrf4VIq7/XNTSJZpOeNaaMmDVBbL/DF/gpcJxIhmvmbaiXjy9LZk7w1lp9UX/B6BuoXMv6Qfbx+ZLue1BTMwG5NcB/hdd9hCD4dwTwcpQKc7I0t7v+bOVAZIKBRGP1+5cNgxFOg94Se8Z3nU7MmVj+WdM+MfrbGstLCsZrZimFUTmJOHwNe3FLvm7pTsNQV/25hs9l3iJlBwzgwY2Swu109uDIy25
 x0BHHb5H
 18glxV+/fhZYV5hHeaPJPUFfVSm5MzmpQsY9Vn9yaE54xuwDuMPm8MOeibqWh8i1lxbOtNWyN1bj7iQXxnR77TYzqlHyHqAed98hxgm5Er2e6y8B08SSb9QSK7g/2HY1sU0OJDKPTA3xgpZp1VOFPLp6FEzJaFGnTN0UO6eOcwXiD3n/nMOC3mXW6FTX393MybvJ2elCJ1HBT65feNo/xQThziYEWzinodEtqy8QQlZUSpLLLEivcj6f85t5uZpJwBtDSHhqHseTHJ3mmFoAYYIq6WBWiTBxyv9Q5VS95uOpqEPHdytlNDPvV7TzyJiudDC5Yo+bpzc4i/nIDNeaheUwJ17J487XwTYtjWA6Dq9xwymPO4qk6vqdqYB8hm/2SPjisBr8z40OwzXAssLbWzd5r0AdljuliduP6oLELs67CMxJer6feFwL0AwYIqAmlRHXmKF5QpHEGISZYPv8fonuUb1NSMSMv9P+wzdtfEbweWv2jhG3gmF82MD4txhFY2ZHMwVrDd+Ya7YaZmMkcFuqEIihPwh4qjKhF9NjB0dFu0lFqUm4vrGsW/ZAyXBYh5ClJXWmDiLUbMuU6GwiQMVf6wE1L39cqUEsEHkrA5f7ho4c53b6LdFmOMmEyzwjY3uzq1Papa2VPVRUXVN1khkbbgmk68T8wA9ZMAF5b10Ys+8uxqQMF0QuK9oEtdH3bf5SbIcBV6+biSzziJu31R1FokW+zdVZ0MMQ+iRk9wMO4M10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josh Poimboeuf <jpoimboe@kernel.org>

Adding static keys to entry text needs to be done with care, as they may be
executed before a context serialization operation has been run. Add
DEFINE_STATIC_KEY_*_ENTRY() variants for those. They don't do anything
special yet; that will come later.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
[Reduced from .noinstr to .entry.text]
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 include/linux/jump_label.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index c95350a109876..36634f08d30a7 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -374,6 +374,20 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_FALSE_RO(name)	\
 	struct static_key_false name __ro_after_init = STATIC_KEY_FALSE_INIT
 
+/*
+ * Objtool will warn about static keys used in early entry code, as they may
+ * be unsafe if executed before any serializing operation.
+ *
+ * The _ENTRY variants are used to tell objtool the static key is safe to be
+ * used. If using one of these _ENTRY variants, please add a comment above the
+ * definition with the rationale.
+ */
+#define DEFINE_STATIC_KEY_TRUE_ENTRY(name)					\
+	DEFINE_STATIC_KEY_TRUE(name)
+
+#define DEFINE_STATIC_KEY_FALSE_ENTRY(name)					\
+	DEFINE_STATIC_KEY_FALSE(name)
+
 #define DECLARE_STATIC_KEY_FALSE(name)	\
 	extern struct static_key_false name
 
-- 
2.56.1


