Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6189CF4613D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36606B0088; Mon, 23 Mar 2026 12:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0066B008A; Mon, 23 Mar 2026 12:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9877A6B008C; Mon, 23 Mar 2026 12:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 857E06B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:01:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CAC98CF1C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:01:24 +0000 (UTC)
X-FDA: 84577792488.13.0148F4A
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 449D8100019
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:01:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=K1nMhyKc;
	spf=pass (imf05.hostedemail.com: domain of vineeth@bitbyteword.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774281682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eViZzzv8Sc/M5QSGBQX9CwMHZ/34uumJnzvDlBpaGpc=;
	b=pt9mVx759kEBvvWLPOmtPXMU6XJqkfvZmXawcrrQ3vEUUA/2oAq+Mr/tFcEuj5LiZM48yB
	Sk1rVzqEkZ1i6lIjI3KlSQq+RmaK+k3rqoliHKpuNhQt+AWJ8ykfJzDJXUyf9JBS5vuS62
	Y7DYWUPFPbyL73qNlQkS+95VpESaqz4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774281682; a=rsa-sha256;
	cv=none;
	b=pRGBlAJxW8LH6fiMFNMe7KFHGQxbKmOr1IuqRzFgYsOwPWbE7tJ9frWpu0u1zGoLKp4Orv
	uyAmZqVLFCaW/zaNqvb1E+cu9oXwV9XIcN1bIlYAquOKcwte5ZxP0t7Z/l8YqmVbq4kaTp
	IGG2D2CuRefxpo6B6o9UnW+SaQHpeSI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b=K1nMhyKc;
	spf=pass (imf05.hostedemail.com: domain of vineeth@bitbyteword.org designates 209.85.216.48 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	dmarc=none
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35b98def50bso3131404a91.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1774281681; x=1774886481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eViZzzv8Sc/M5QSGBQX9CwMHZ/34uumJnzvDlBpaGpc=;
        b=K1nMhyKcs7nNJMjJA9iqckSA1cyn8U5UW4iwfpNqHsNuucpusZGDke04HlFuUxpphm
         dn57IbAEsEYwGEVl/k3V/fZfomOwg+nWHbO9iX1r7P2/qEfYN3Bc5E5Yh0ZVVvn8eF8D
         HydPy/M4Cl7Nmgq3JSnk5+drODve5U8F8Uk+P9aBNj+dC/zjrbUdtb7OxW5/Ixf3yrWa
         ipIaIO4koin7JuZTxBu0KZWiToOLVh1RXy+HgjPoqRMzedVd5dMtyHyWlz9p+0ph5+mY
         zl0GAqdejSUbSgHZ2SIS1v1XEF3QaGjgVVkykKlLQfacRn2T2qGzIYHOM0WcdVXTe6vZ
         3Gkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774281681; x=1774886481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eViZzzv8Sc/M5QSGBQX9CwMHZ/34uumJnzvDlBpaGpc=;
        b=j/8czizlVDkBWwUES9q5qrKgjtsYyYI378Qcx+cLcy0QjWmnQALFYgJWwmyj0rw7hH
         wHgqyUSiOOVbwNaV80L3Gl4n3kt7DIrdU2kCT2MbC2ju4lznOnBX8xfMBb1SjvZJI++c
         DyYH7rcJOhkpE4QP12MA/5E0i/BrKWcZIRAJNJIodjphYp84Q0jrLY6cTc5qKvwcBoit
         DfQYw3yFQZavg0bGOHY+boHyxkSYW7UNyC+xcnLgjW8EH1MySd/T61Ck9BYZH61rmpAk
         56NzG4F+qTvvlCsIfFQ1xuFGWrZ443CQhNpuPbOaaLWmr3hbYRPd5MsD5ZBHGzjYcj2s
         Cv4A==
X-Forwarded-Encrypted: i=1; AJvYcCUpdSWuu8+CTLBI5ys1olAqp9NufU3VOZ/TpbxeY3DSwKWY8u1DTFMDrGUDx5HWfLZa9fHxq8q2bg==@kvack.org
X-Gm-Message-State: AOJu0Yzh7oxtLToxV8mcMtVHZw/JLTkiJyiz5A74En/W8ScaBHztp9xR
	g7VqVKtSXhC9FWCGprpwsmUnFqPUV0/hggFMglrQm6yxvOeW93ha8PQq247sJ9YsF7GNg9gpX3w
	PuNWAb1dXog==
X-Gm-Gg: ATEYQzzOYozXWEpDwnBwPb2Le2APNHjDrlBS9CtcOKIqexdbGeZdG22AKMEDxO8KVge
	/uGiuNVRL49XhzDvn7m4LTbVj1CSrezNvy/4MOneZj73Rnj3Y8Wyp2zVBabFCdlwMpIVxf4VP0Y
	uDoqUlcZBkpSfwAoO8gv6HJ05M9f1X4wZKgH2g14fIGonx/C0Cnf3TtXh8uhhszPazvuZqxrVYv
	YnilRnFhqFHm+r7v+PEjHTDnLcmWrWW1U0eOCF4wXN0uRuKBqGBS8YrKZut8QPH2q2V6Oa2osWj
	KcY7DST3MKmzvQKmbNjN8S8mSvNYLBpbvsr+0fnMuMCt/q0NDUVOa45jfszKvbnZ4xfeRxnJ2lq
	cJrj01CV5bUjJ25NSrwNLZe8gXYUyQRL7p+fqqUvzUnMGbqgYhU1vQlkyyOAcCQo6DgXGV+fm//
	HCXaKp57O54y4DJW9DIZJVaM/y2kNo6k/mZCSllZN5cOnPfVk8ozotXUH9B7pchrSGfQ==
X-Received: by 2002:a05:620a:198a:b0:8cd:8d4c:aa0c with SMTP id af79cd13be357-8cfc7a796e7mr1828317285a.0.1774281661473;
        Mon, 23 Mar 2026 09:01:01 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9088df1sm843364185a.25.2026.03.23.09.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:01:00 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net,
	dev@openvswitch.org,
	Jiri Pirko <jiri@resnulli.us>,
	Oded Gabbay <ogabbay@kernel.org>,
	Koby Elbaz <koby.elbaz@intel.com>,
	dri-devel@lists.freedesktop.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Len Brown <lenb@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-pm@vger.kernel.org,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	linaro-mm-sig@lists.linaro.org,
	Eddie James <eajames@linux.ibm.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Joel Stanley <joel@jms.id.au>,
	linux-fsi@lists.ozlabs.org,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Philipp Stanner <phasta@kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-i2c@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Michael Hennerich <michael.hennerich@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	linux-spi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/19] tracepoint: Add trace_call__##name() API
Date: Mon, 23 Mar 2026 12:00:20 -0400
Message-ID: <20260323160052.17528-2-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 81b1so9zffx75guwkyufc5rbq9dajsjz
X-Rspamd-Queue-Id: 449D8100019
X-Rspam-User: 
X-HE-Tag: 1774281682-365727
X-HE-Meta: U2FsdGVkX1+ZR5lPxpc4fO88lb2zWpW3x881+lnJTvl6H0pT/W/3XQsmFBPhLjY7a2UUbAufSDXwfJHrhVa7f2bZN1XYQdZPcEI8wFMp/3QeRn1U6nkidGXMkNtPoXqs5hKaD7s4ZT5rD6Rb7nyLdLVFo9Y9pkNCEM+r+20rWys5SutrvmdboFeIP44SMZmSEjlW+QYW300tIcHMYvj5VICNVPirVlMdWBoCFZCZBC5+DTSd5O52IkY4V7My69TzGHGme5tQkQWbasCCqiaPo97jgU7KZKXk6q4u1lTOEU5G9/LbuYehlY0TXNU1lAaIwm5nR4IKngB3QXa4/kW26gF5GqgXQHyEUxHkbY8n4+rzGHbOcPHk7xr5+QYf2RmlSqSBXX5HG2ie2tUJZD9cn++iVXRZa90JMlhQ34uISs7xm5cfY39aIhfZlm6/2oOIMDabkFUygQRuwQChgrllHYiUuWWJXiQGpocIkBVsT6Ggpv1qdQi6eTGM7SpatCCm6KEBuRR8M6sq7reN37xFV8AhzVF8eEiroXLu2ycXNanKa047TulB76tFwHlDom8xKrPOpxbVDzo6wfPYUVeOMgpXdvnFHJVH60fv02AgP3LQ5U3hz22/Vi/7NwuqoOqZiPGc0Kiz52SifA9rJTQGgyhXb+IeRA3SXbhS/ZO0ykGjO5BZU6l6FToX8L4cxUO50ayZ8Sz9xC8lDvtAFNNdAr8+9ZopqoTpTVKIdLeAjrMhd8osAIL84MDk6A4F+NnnrWzGdpl8NPWuh4PzpuocuTj7Nmithq81F6ZgNXAoKxf+fDBNjCcbpgi1wA1ZvRvzIEjOjKzeiP4jrfgnpJJ91fGr6F0eWkU6oLuyOJ8MNqC3qudUi5T/79ztE2p1HpIK4XNBIxZ7FgLo9S1BaHurUYLQxuAgfw6mGqLMEyFQKAZuymAZeSe0xBcWyhZKl1mkrkmNTAAVwtqMa5e8InL
 0cdX4M1A
 zqjp1b28P7uzLbIEsVt9L6u7y8ftc0I45esOgSWXH2efQHQtusmmXOw253f5R0xf29lRXkfgEOWYodxIg7QD0waGuIL7cWd2NbsmeLt5fc8TwgZUWPWCU1Wb3b3frjI7tpZW0BjhTffQaBUSV/9VvAXWQ5rzxrKU1Q7i9Gn1JPfpP1/DI6UzIbwu+P1IduG2mjYNKDocq5p4f+/Xpp7AcCCcGUVxO/wlP/D++ZKLuFdR1vBEcYQ8LPMF2UIzAF6Cv4v37L/zAmzf8aR3BKYYSQylv424rM2makDhcTjWfNLvhdUraleMy3WkfJk89hJIxc6vothyitBVAlk1alSRPwkN5QDm+CjL/1u7aFafZOHCmQe/JTk+ezpetDbTM/ehE7bv74l07ER0uD1GYzI44nGCAIxx7a+ED2RKqEmlgNiGmBuwQKYjsUWnOo8d5wMR/8GR+PmWaDw1tr5QbH+LaQdXrQIgjEg1Z76VMIqP8IUtJSsJSvMz1rU9hMqNR5jt6I8DlWdMU3A3Q6JsUs17Zu8V3GVky8IglPXVyupHuOvmX1m+0bv2zQU61QTBVoO8J+TciaUpHNxzYd8IFjhwKUbO5M0VxHPNTVB7R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add trace_call__##name() as a companion to trace_##name().  When a
caller already guards a tracepoint with an explicit enabled check:

  if (trace_foo_enabled() && cond)
      trace_foo(args);

trace_foo() internally repeats the static_branch_unlikely() test, which
the compiler cannot fold since static branches are patched binary
instructions.  This results in two static-branch evaluations for every
guarded call site.

trace_call__##name() calls __do_trace_##name() directly, skipping the
redundant static-branch re-check.  This avoids leaking the internal
__do_trace_##name() symbol into call sites while still eliminating the
double evaluation:

  if (trace_foo_enabled() && cond)
      trace_invoke_foo(args);   /* calls __do_trace_foo() directly */

Three locations are updated:
- __DECLARE_TRACE: invoke form omits static_branch_unlikely, retains
  the LOCKDEP RCU-watching assertion.
- __DECLARE_TRACE_SYSCALL: same, plus retains might_fault().
- !TRACEPOINTS_ENABLED stub: empty no-op so callers compile cleanly
  when tracepoints are compiled out.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
Assisted-by: Claude:claude-sonnet-4-6
---
 include/linux/tracepoint.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 22ca1c8b54f32..ed969705341f1 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -294,6 +294,10 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 			WARN_ONCE(!rcu_is_watching(),			\
 				  "RCU not watching for tracepoint");	\
 		}							\
+	}								\
+	static inline void trace_call__##name(proto)			\
+	{								\
+		__do_trace_##name(args);				\
 	}
 
 #define __DECLARE_TRACE_SYSCALL(name, proto, args, data_proto)		\
@@ -313,6 +317,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 			WARN_ONCE(!rcu_is_watching(),			\
 				  "RCU not watching for tracepoint");	\
 		}							\
+	}								\
+	static inline void trace_call__##name(proto)			\
+	{								\
+		might_fault();						\
+		__do_trace_##name(args);				\
 	}
 
 /*
@@ -398,6 +407,8 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 #define __DECLARE_TRACE_COMMON(name, proto, args, data_proto)		\
 	static inline void trace_##name(proto)				\
 	{ }								\
+	static inline void trace_call__##name(proto)			\
+	{ }								\
 	static inline int						\
 	register_trace_##name(void (*probe)(data_proto),		\
 			      void *data)				\
-- 
2.53.0


