Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D939ACF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE6B6B00C8; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AC46B00CB; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF466B00C8; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA4B6B00CA
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C348E140172
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:27 +0000 (UTC)
X-FDA: 84131329254.05.A43DE4D
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id F17F21C0004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kWGaZ/PS";
	spf=pass (imf20.hostedemail.com: domain of 3FDAfaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3FDAfaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0QY5sCjABQs82s4Ju3ZdPJK85+Pyg+eamRrTOstnfs=;
	b=I/7ls89KasAWnGAWS0MAGYR8SqvwFNdNyjtwSq8zQksjmuPwdN/FbcBhJqkMat0/2OkeER
	RFiJAq8aSdPmCtHlhGXpewPQra6VjkTL/ypvYwqjdqZ0bp67PD/BxU/WL7bSqmU38P0T6+
	1JrGdysIvOCur2TvvY0CFySYMY77yRg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kWGaZ/PS";
	spf=pass (imf20.hostedemail.com: domain of 3FDAfaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3FDAfaQUKCEEhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651606; a=rsa-sha256;
	cv=none;
	b=gProgANr8xUGN2V1wxHNiTJFgg6yjSxT+gKH980MbviNdy7FuubnLgYYInYn/za5LeNBqr
	2oq3LGW81wibmO5U5Btv+jZvC63Ww6YlyB65RbL+3SG5oBG/bhrSErwyhWrbLO5A189AOX
	3Z5aMaBJUagfvhPrCBW0xCZ5cVaaT7c=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429c7b0ae36so658566f8f.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651604; x=1764256404; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e0QY5sCjABQs82s4Ju3ZdPJK85+Pyg+eamRrTOstnfs=;
        b=kWGaZ/PSwtlFdAMmsL9kdiqubBjULju3EGMqNJV4GJsv5NBQwyn1cNuPvmMQFgIwLD
         V/PVjTgOpLQ39a78rOdtOPPZ/dRkc1s1C8n7UGl3NjJn6B6U+0/bV/pWGwp9fqvqxCLQ
         tF7mvuf9LCW/fqWOrEdIUB5Es3KaCYm5V33v9ihYF7+NfKbWOs2ddkvDxBTREAjm5Ifw
         jvkGaDb2FRNtI0s1u+gnrwIjwcSv0ovNZggbfnoD/wB1OlD7oZVxT7Ik9116Bksx7n6Y
         6/N6Vjry774X9lEyGZdHJs1gKMeZbRjAzW2qzhK6WzT6IlhCKNcInNSpfWf8kA9aPyig
         i+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651604; x=1764256404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e0QY5sCjABQs82s4Ju3ZdPJK85+Pyg+eamRrTOstnfs=;
        b=AJcYImEYJn0s/LhHmkqL9L63g2watH22nhQFKazrGL+xvZsD3v81j6H4sg34IaAfTd
         W7Ao8DBmAUhuon1EZ+mvlftI9wLXu0NlhV0ISa9M1mWN0EB1GU4huSQkFb3ENsxeGIaO
         AwXgWH86makWdx6FVjsHzCgOv1ao+cdvj/76+x5KlEGGfCiRvj/4Ix1Vu3JuMqe2XISp
         Thw0sqemG4CDG5j+e67JofkA0qIkPogyfH4c2s6qvcm/wKHVLZrCKRxatqNOyYoqgD9e
         d5qekbIRpYjgsSa+K7Y6/DiQR0M0q39W2pCXeMpCKxiunLIIa9ykhQ0zJMNgj6mJHpnm
         ryDA==
X-Forwarded-Encrypted: i=1; AJvYcCUQz5pL0CxgnGiGSk5aubmZJBVkc7WDXEZBW1pdjR0pTVdB0j74v+ML/4GISO8V4NamFPJQ0b3f8g==@kvack.org
X-Gm-Message-State: AOJu0Yzb1mlPnFvXAyd+4lL9kDrjxJrKPXf8JPFOOb8fGpkzeuBBQb6T
	F5esWtVqxadeE5xVUl0NNdZu3M8+bah5TUmV+OO/VdyUp8XMMqI8hjRZiqtr3YVgL/DRgYp1bkE
	pJg==
X-Google-Smtp-Source: AGHT+IEwTiVA/c7ivK4PcZYzQTIU6yfpqSY2nHpvc3eMP1mZxx+HGAMnAzVRYoTvuPwgEuO1vhoD29fTuQ==
X-Received: from wrbfq12.prod.google.com ([2002:a05:6000:2a0c:b0:425:6f4f:8f67])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:adf:f8cc:0:b0:429:b8c7:1848
 with SMTP id ffacd0b85a97d-42cba767dd8mr2702228f8f.19.1763651604278; Thu, 20
 Nov 2025 07:13:24 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:49 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-25-elver@google.com>
Subject: [PATCH v4 24/35] compiler-context-analysis: Introduce header suppressions
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F17F21C0004
X-Stat-Signature: 1useeuymko8j7px8sn6tgjzn9wigarjn
X-Rspam-User: 
X-HE-Tag: 1763651605-122567
X-HE-Meta: U2FsdGVkX19PV4sxti/Eht6EUrQW1QLvr47s+daaXEWx/b5e8b3VtvnaAuQvaXR8FSjuIdXjQtnUIdYFHnqviecV4L5QAvl96M1eAvr5YNdPn6iVSj57NbXpnmDle70rPm0XAu6+gYPW48dGib/okWgsJfHOtglnAuJLp8vjWl6xTRCUoF7hYpZjvV23ZbYXX/oSVfnMr5dJuMsVX4hBcoT0Wt8r8ABICp3FqSDS3Z3Bgb5TuzmcRFJAKUjaE2hcszsQYfemPsOT1pwwgaQEWFk2LyFsCqbi9CC8LYJPTsQOaNkmieiCyuiMXaB6CJ4j2kimZDM3DBemsu/ELsTho/qHeqm2r5LA6WE+JddGmVpZqD2tYWAkfpAlurlOOvvXgxDdpwzXreyVXHx6tQCcC4U9jYwugfVku2nJ7Kb4WYC7PWtnW2TbbCHbkrTPqfKwWAlLhCPYApHLoPCrfpFNonHbe4VX5WIdfag8WK7bweC1rvuj9xuiP0LpTXj2xKPyhjNkbYRJmH9v7svYkLqqN8AjevlKM8sKXIt2tO7xEDFbX03uLKSt6agULEDyuE3qFyNTdU27JOSFYTYlemwK+59hDIXGP1zodzOZvO0x04YvOS+Q75qP2UZ5+87i7GOQv90tyA00kHi94bs9reS+wIln6F9nFArQGs5/8XcEHnaSPGeOCmxDEanpdTkCGsYNavcowqk66arm18PW6tCwiOoSYSFE78dGgvi0jYL/Fu2NQ5PCFjKb0EmEnvN3ozGv5VUiFUQq8qvP7kNb++/7gl9sFRjshFatR1v3D5QTi4b1XVh8J5JdnblzbyYuCG5lv7TNzqL3jqQoUu4fpyB1M0WxUhLRi0tdhArwMVaTKs3a9X40xMvYmQJKnzNxOTMWw4qpJPl3L0tid4n4ZF1HvtVODiCS1CaG0cblCJZ3XmRYDNDCNJhzA0rxe5Tn9fjKSyFtcYBWqVWhAMUiXKr
 YgPWen3B
 Uga5hrH87bdceJ7HCfVPBXuhHusAT6Cd6Gx6QxKtLSgMAMOAolDWRlvvcywEz31yh358jnb+c8he8bYYsy4hn8tfTe2uuEVYvZ8epfqqnxfDuze2e98kidaJrsCKWE1w6wyVCECSpO3BSVSlUgd4nUS8WSGBZt6pULLy4DUDzpG6VbWOaUxJIh4ITE9SZVC6BJ7Rs4KOxTYTNKFqyyweiG68kqiF0GLtQfZ29cFikNqaoD0FPh/y7NrHrPPMAavlDyixY+yz5IEiynAor/5+5xnT6LpEc7gfZcMi15vwD5/Y3UIQPJK3n4vqiiappPihT8mseYTrGKvOAAFhpF31QcZGreVJz8bi10420ZxZbSdTCVqPosmbYq3NtQsuPSXeyTxeIAdHoYGUsxB9QdE1usOSYZPU6ywma0W7XkX/nlhFmjfLRbfUP3PoTdGEUiZ4s6W4D2XNiARKSXQnCq89um/tRCIbiY20neHMy9WeQj83bF9nHOD3OwsIPb2gwYXooGAjHSRAJDlIc4+QE3qoZKwXmrlpEqidYc0R8+Tk4HcEaZeEy3bKKcvoG5L93UcESIrrUYGTCCpYYVi/VLStXPec7pczYe/Wo/uXVkJt2WCOjhna+xAs3Z51GWBjA/9C/MRUIu7yLfJ2ujJw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While we can opt in individual subsystems which add the required
annotations, such subsystems inevitably include headers from other
subsystems which may not yet have the right annotations, which then
result in false positive warnings.

Making compatible by adding annotations across all common headers
currently requires an excessive number of __no_context_analysis
annotations, or carefully analyzing non-trivial cases to add the correct
annotations. While this is desirable long-term, providing an incremental
path causes less churn and headaches for maintainers not yet interested
in dealing with such warnings.

Rather than clutter headers unnecessary and mandate all subsystem
maintainers to keep their headers working with context analysis,
suppress all -Wthread-safety warnings in headers. Explicitly opt in
headers with context-enabled primitives.

With this in place, we can start enabling the analysis on more complex
subsystems in subsequent changes.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.
---
 scripts/Makefile.context-analysis        |  4 +++
 scripts/context-analysis-suppression.txt | 32 ++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
 create mode 100644 scripts/context-analysis-suppression.txt

diff --git a/scripts/Makefile.context-analysis b/scripts/Makefile.context-analysis
index 70549f7fae1a..cd3bb49d3f09 100644
--- a/scripts/Makefile.context-analysis
+++ b/scripts/Makefile.context-analysis
@@ -4,4 +4,8 @@ context-analysis-cflags := -DWARN_CONTEXT_ANALYSIS		\
 	-fexperimental-late-parse-attributes -Wthread-safety	\
 	-Wthread-safety-pointer -Wthread-safety-beta
 
+ifndef CONFIG_WARN_CONTEXT_ANALYSIS_ALL
+context-analysis-cflags += --warning-suppression-mappings=$(srctree)/scripts/context-analysis-suppression.txt
+endif
+
 export CFLAGS_CONTEXT_ANALYSIS := $(context-analysis-cflags)
diff --git a/scripts/context-analysis-suppression.txt b/scripts/context-analysis-suppression.txt
new file mode 100644
index 000000000000..df25c3d07a5b
--- /dev/null
+++ b/scripts/context-analysis-suppression.txt
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# The suppressions file should only match common paths such as header files.
+# For individual subsytems use Makefile directive CONTEXT_ANALYSIS := [yn].
+#
+# The suppressions are ignored when CONFIG_WARN_CONTEXT_ANALYSIS_ALL is
+# selected.
+
+[thread-safety]
+src:*arch/*/include/*
+src:*include/acpi/*
+src:*include/asm-generic/*
+src:*include/linux/*
+src:*include/net/*
+
+# Opt-in headers:
+src:*include/linux/bit_spinlock.h=emit
+src:*include/linux/cleanup.h=emit
+src:*include/linux/kref.h=emit
+src:*include/linux/list*.h=emit
+src:*include/linux/local_lock*.h=emit
+src:*include/linux/lockdep.h=emit
+src:*include/linux/mutex*.h=emit
+src:*include/linux/rcupdate.h=emit
+src:*include/linux/refcount.h=emit
+src:*include/linux/rhashtable.h=emit
+src:*include/linux/rwlock*.h=emit
+src:*include/linux/rwsem.h=emit
+src:*include/linux/seqlock*.h=emit
+src:*include/linux/spinlock*.h=emit
+src:*include/linux/srcu*.h=emit
+src:*include/linux/ww_mutex.h=emit
-- 
2.52.0.rc1.455.g30608eb744-goog


