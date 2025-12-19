Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34CABD7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9820D6B00C1; Fri, 19 Dec 2025 10:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E7D6B00C4; Fri, 19 Dec 2025 10:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887286B00C1; Fri, 19 Dec 2025 10:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 761466B00C1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D7DF13A8B7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:09 +0000 (UTC)
X-FDA: 84236649378.24.86A2A8E
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49B1916000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wdhOEQ8c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3eXNFaQUKCMYqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3eXNFaQUKCMYqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159227; a=rsa-sha256;
	cv=none;
	b=HOYJo4rGGwzGRM99ZC5494Pwlc8jerc1VmlsLRzwv3wbIOzQzlZ5Loz8pcwkcgExw2YNtH
	OsFu2DG/77MR2TPh8ltR+iZQBXxuIzg/mC/i6NpH4TfxdMTNthOvB40pue1RXlll7s0/Q1
	9O8/MSCBlQRNdPyFPcigOA8TgrHmMGY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wdhOEQ8c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3eXNFaQUKCMYqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3eXNFaQUKCMYqx7q3s00sxq.o0yxuz69-yyw7mow.03s@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTy18ZdTqK3/SC0lGMdEXuAKkcRsuvgQuaMHd3BFX3Q=;
	b=kO9TSv+Dafbwq5Qv9EDURqijFMtXiF4XlqCPNVkn6LF3wBY/1cl+DMAI+ugDYDbJMan1hG
	CoLP4LDcfWZzYUAl8KnzS1VVN+QA5GNa/eipVbH41OuXVfVWDPuCOpwHgDrL93UPRa1Uhb
	TWrfNhBvovPbg/mSFnbadkuVQQCOuPc=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430f57cd2caso1623484f8f.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159226; x=1766764026; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTy18ZdTqK3/SC0lGMdEXuAKkcRsuvgQuaMHd3BFX3Q=;
        b=wdhOEQ8c6KCkXNlkrp4TX2c/QWBO6MSG5Ik/2DENd0hXDIq3p8QmblPQUEo6yvPQvb
         7HnU72nPH4PUGE0aR6XtPnUh6EA1w6qhCRJI73DSPiBPzo0DspDkH3UO96uoEmys9G9W
         M94LroRqj+B2zPBQSoneKavttaDP2qWW/innMrSEs+OFpJ8RjpAjCqMx5OJu0LbU51Tr
         nNWylI0gZ4ON5PZns9NJkTd4n+d35wyNDLsuWJteeMzxHY37JlskrdWXo9hDOapwkPi0
         l15UoI5fk5jcdf0vi3Gx/q8U5UyIG3Gs8MSHid5eU7OrXKJ44mf96K7M2FpTmfLwAcb5
         6fyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159226; x=1766764026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTy18ZdTqK3/SC0lGMdEXuAKkcRsuvgQuaMHd3BFX3Q=;
        b=bhyd8mwLb7SkZHSqeVbN/oxQICDrm4UVHFTfjC/zD10JlZAyelOdTsx9Non2hFKe+O
         Vh6ONU+cQa0bU0AIw4278n31OyAZXIJ1h5wE0DMNf3QdaXDMzvfyu5QuLHDeqEYj4+SD
         EjK+Wa+WvTo+ZFNRBLOzVT2G6KSMIAouCUSIbxQQtdC0RZ4j6xatrQBM+yfwidtWqt1p
         yymb3SaMSiDvIoiL4G/W8D8Ox81St+52QwopmaPBaPCIOvgNWPvvLmTFGHb/UPXLef2n
         VCOSw5dpPZ3xjPYVt7zfFL9RtWl2XivesutaoEYI++0ixzkvKu67tyx0dxEhzXchmPZA
         Y+iw==
X-Forwarded-Encrypted: i=1; AJvYcCUIJpsFuFFug/1gGP3rIr9NbG2ZA7TMHeOTWntCX+bDe77ccnw+uZ8kr8i9wInfpjyKeozDp+wqWw==@kvack.org
X-Gm-Message-State: AOJu0YwJLETvnr9L07XjE6u4xlL4wkPEsE3u2PsfCPzy31R9XPNg7Q01
	8sWj3fhqzM98dx8EFGNJ3qDhVMRxzsbo0L28n1EMOsGolspYrfSWelk6FsBqz0xRo7gQfbAIg1y
	YVA==
X-Google-Smtp-Source: AGHT+IF24T4xLk8zHfaxGfwTVEzbsV+GAmr+3MEnl5nQxzQxPnKeM3cpUzi9Ro4WJge4y08O2O0BEUfdhg==
X-Received: from wrbay2.prod.google.com ([2002:a5d:6f02:0:b0:430:f3bf:123f])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2886:b0:42f:dbbc:5103
 with SMTP id ffacd0b85a97d-4324e4fda18mr3897372f8f.35.1766159225487; Fri, 19
 Dec 2025 07:47:05 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:14 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-26-elver@google.com>
Subject: [PATCH v5 25/36] compiler-context-analysis: Introduce header suppressions
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 49B1916000D
X-Rspamd-Server: rspam10
X-Stat-Signature: q4onpoyyq5zuosx1zfeisnw6um7cyarq
X-HE-Tag: 1766159227-749101
X-HE-Meta: U2FsdGVkX1+1yRYVqzs3PejllN3tcPMpu2OV86/oL30cshraWpUow0nhiZW/NWC2H61HvK3jq8rs5hFBsa6D8qGSZUPIU9Nfq30mZHRfaVe3PrvP2FUbeAEVU5P0oKMQFi/duNDFU6rUqMn8N/hlDgEilDE7kiKnDJlli/cHS0SSuFo00KXGBPb1B7HIM2scFjY3Jp3WOWA2TrlhMiLPLZF6y+XrbKd8Sa/+hrgA9H3W7J2qTDS6sBub9K3j7vJ6g38VkMqNJvTFBa9d+WAcB1Y/rKdv9gBFWxvb0Dvg2yjuRHHSDH/oS8Sv53GmpNoMx1n02X9Sq+Rc3KWzD4L7F2gkIUSnIoitgthVcvTOGkbFbVULJehX1DsnRO5T4tpKUY2Io3eYDex3oA0ADuQ7fupvaC29QjE+G1WhG/rplbdsluSnJXyxuPZ+hIv5yB7SilPQhLEdJEr9k89hNCskqKp7mA6EHC1CaCreAemILSPKryKdC9F4OMbBhj858iRKy6qzhN/BpJpayWGiEmf6/GeyVS1dJCoHGnd+jya3hkY3EUDhY+Mgr9qr3RRGlBDha6OLr6GDP5H+UoD03w2DzWAAKbQtIrBg1U/zw0kLbZ7SZ8+amv5gxf7QUC5iwVOnSGhXpUKNJdBJEIkayoVkxqfircxsIpN5IOyfRKXsuBGON3iSoUuRZFtfUpJ8lvDhAXLzoZnSLfQ/fIp28pZeYeQN4RRqq7zNV2WxyiJ03VkVE1py+fty6HV72gJefrcIBiIxfw0xY5rzeCjhvASXYwZltjnisWWh+OTsosVUUQErZwg1MGDCzxwZUXvVdiZYtF5FDODzWQ8h33fKkmT3fiM7Smt70cF14yWb3OdJ0oCluh4EP9KAff3lnEB8/433vnk3dllghia84MN1khxD2NSiyuvBt8rX/T0xok19GksGAKv1L4MkQ4ssCR3HJTSOoVcq1PmQd+AeoNb7inF
 COjWDpD+
 JRiwKlLjRChGwES5VhfPUUi0Ynt+LpZUesXwG5sxjlPASqRSqA9WXyLrL05FlyL8oY/MrRR6gfO2bpp0BUDZcm/7rt23h3eQ1FVlmtUn0ZpB4yuDdJYlkIhuSPoED8gN4dAl2aIsgLFxhqzlKc2Ftj3xCtdf1SPLezxpBd2YOftw0E6WkddzLXgf3RuGkNjpjLjDQgb9+CBQ56rW3F+UqZyPaD7crzAEmneuAxicDeB99gpLRcWmLJj7lbBVSY/c5YyqAv5iKc0QRsmzSZDTvEPR8fDdG5vjTqoA35yEtv8BE+ekMrA2dbdbhhh4+hsdUxdRJOJlXsDJOrMge7lCdS4G+tyO/LR41JV4QbXA3nGshlaH8coSdlpOOUkDNygWs+pQ3A1hh6SmgCzA31NrrDfelHmB15UaLVTd9gf25Ai5faJHsw7lgGbQhnCoCdEr3hol3yvMjQ55LewWCB6WXc5N06Xeb9GxilZ1BFXYL4YvlpPW9D+1GM5W1x1ZKARu/T2xtWOKJeRoUYr+FJI4I00f6k9I+ZxhzXnVS+ik2ICKSD7pnQ8GNz+sgQECzTXm/etKS+2ppqaTccyRmLjnHm34qCr3VkFVY/Lq610AJJKxiO6g9ORF598EA4FJl4R+8YsJxnTozX2NnDjrwaGuP17MDYtHyaTrdidlR9655I/0TMJIpUjEDc5jYqhjUfAiuFslv
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
2.52.0.322.g1dd061c0dc-goog


