Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB999D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB3F6B00C5; Fri, 19 Dec 2025 10:47:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179336B00C7; Fri, 19 Dec 2025 10:47:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6886B00C8; Fri, 19 Dec 2025 10:47:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA8946B00C5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8D6B1369ED
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:17 +0000 (UTC)
X-FDA: 84236649714.10.38DF570
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA90B140003
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t2XdKkqb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3gnNFaQUKCM8z6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3gnNFaQUKCM8z6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159235; a=rsa-sha256;
	cv=none;
	b=gwPo2TsbI1HygBJfNsBD+afVLq6XgvsZDtKlXqLwYUYTE8Dt9CSH0PrtKQ8aNUVjoWrtyt
	rsVAbyYfzbP9kOgaADWCUzd8a93FHPSfsmp9oPMrwjif6mr9K9YUKrkaJG8CzumVlvywfS
	CYCCBIC2aZiZHvwTwncuc3+wbfFYhao=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t2XdKkqb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3gnNFaQUKCM8z6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3gnNFaQUKCM8z6GzC19916z.x97638FI-775Gvx5.9C1@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oz8u5mnRRtKrmwrW53CCOIRd71oba2M2eRROatW6JBk=;
	b=30R9/43ZKFZRcODt0TwoUvPEGy/KsF/Rscij0YOMSDHPGjZ3MHxxdzmRDSwICMOQ/ukggx
	JX/zHa/XI/mJHBUTvAGC8G3e8aNIaSHyz2TyAk9gtDdif1CbymTqwraFvaMDWRnyeNePGK
	yUlzvlrDQdWZ201aHgfRkhG8q/wmkQY=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d1622509eso9288305e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159234; x=1766764034; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oz8u5mnRRtKrmwrW53CCOIRd71oba2M2eRROatW6JBk=;
        b=t2XdKkqb4995nQ1PJuv56ppJ68wLJuxASQeYyaNNXKs9j8hDQwIBr7+jrn2ZtGLqlf
         uIcy6OfnouqeTaWcYVZD6rA3+svPSz+a94K1UEQoQnUQ2PrzHc0W0Chce2lnYLpuF4tj
         uxmbo22DNkvsjbDs4jb0gjNPWxOq1UZtxplMIFkzcZbY7x/POs2NzT4jMcwB2CQpCmnd
         3fYdDmaFQTfzz2f8qHreW0QXVxGx06iD5Cxph7ECZlhlpvZu+JdF+jqeRcEhuCtjTeon
         09jSoWhtNIfPuGGqWzo+pXmRZZoVdj5X5MR80oJo9HrDuaucI74drVQ36AZuHoj33ygi
         gowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159234; x=1766764034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oz8u5mnRRtKrmwrW53CCOIRd71oba2M2eRROatW6JBk=;
        b=nLGdDH2Qh7U5sWVkwdxFBk8wNG5UH/qwxbSkv+a2F6K32GXnRKxfQkpOXYzBZEVkZF
         7NZMYcDc7E0XahS90aRUxj+Z+EGWm+9PUiDSttiFGDHy3JlaV/K3y0lLBZ+Vo5urlJSj
         Wi/rzRb9D6y/FUC6cY5avpJRSOZyeAwLH1af4ooqttFyKhxMvySlC6KQ0J+5Ow6BWdYA
         Os4p5Jwfj4aRBwvFRz5/vny0C39tN9SsZb+i4jVNns3wkrX2va1Wb7D4UWhxJxHojOTD
         0wScd+rX2cEolDBcR6bhOf8FtZ7ygrFgUYoBYTP1f6O5gJCX49iDsuWXUEw2XvUBh2SF
         EFDw==
X-Forwarded-Encrypted: i=1; AJvYcCVV25AqRYoRmuer/ngnfxk4WwZFU6HmSQu8RHB4l52UywqZBJUty27PKlPIMWczzVRuv2q0qj2wvA==@kvack.org
X-Gm-Message-State: AOJu0YwLrVStlnWQjhlugL7aLanWeBA0hJqaVIuo7llv1DSq1v/1wIYE
	H5rOIdyRGyLtmnJnoLH39nN/DZEJ6Ul2YTJOoYDMSw+KTgHFXNBZdiuOaemcLHBzsfuVr21rxvU
	Y6g==
X-Google-Smtp-Source: AGHT+IEwqTwwND1oOGnUGB6Esw6SWTC15eB9YSENtXjOOBgQW9BC3hhYUlWG2oQBl8kMDLj0dbJpcjcvdQ==
X-Received: from wmdd3.prod.google.com ([2002:a05:600c:a203:b0:477:54e1:e29e])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c16f:b0:47a:810f:1d06
 with SMTP id 5b1f17b1804b1-47d1953bb06mr26654055e9.4.1766159234094; Fri, 19
 Dec 2025 07:47:14 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:16 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-28-elver@google.com>
Subject: [PATCH v5 27/36] MAINTAINERS: Add entry for Context Analysis
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
X-Rspamd-Queue-Id: AA90B140003
X-Stat-Signature: 87n55ihmugduu3rmyh4dqwg3daatf9a6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766159235-543488
X-HE-Meta: U2FsdGVkX1+uFhZYvDPSWQMqhEGRXf7iLlWjmPkqQo8EjRZbSc1PXbN+UIuPvSgIlEyzNKGlS8HDR/Wx1b3kHa0Kg5VOvOwsJc/UqrTrV6NhH48x3rYLNky4Uy9hEn45CR5uI9AQ0LabPRzze8Vi+CLyXQym2ckGTIVfy2CSaggpODbdE1RxbaQDKmKKCInLzaSkM4F/6EJLKu1p7uQG+dDnVrcTkoIQpiVs0p5gX2HfFDjAF2+zcYFU+3GhOa//XJ2zvBcjR04M8ra+yX8ndUmWZchw1IyP8w/YHtyZFtDlwXWUbEr39g4npZGSkJtT3h1XPkOKoQ+BSHFYLn8iypkS43hKTbjptb4mi9WIvTbDSseD6VceYZq8v0sqd4K1/fIrR8/EOrDsCEvIZ+k21S7+X/ac/prnhAUBRimmrIPEG15ylJEuIZDS5x8JI3RE+61xtsuwO66uLxOLJYBcmuffpMiEvqGinWRrNRkG0VMSckwVdO3BG6VwSHIWIxP8BotIh7+rk3Jv+PvxKjvh/pu+UBsTesxXTxddGfBgSwStl6UndZHVk+wcTNZDLVmO+264qJ+D2/l0CLtPmeSUFY8CRLoicbX+jkd1MB1kFwjvtyMwAbeE74LFYAtzUQuTbiKRlE0k8QG15x0U3dTMNejA/NYpgLOKnuXT4ZtCjdfxNTqdyucAg1/K+vaddlXcynzqg11bt9h3FJrx18etTB99TtOsgxdGUp6lNMR+faSMQ1rh7xkk99aSjW3PusSWm36jND20kojCDL5mn4612rC5IgSHJTcyAGjBFRO2p4NXdYFClfNuS8WJpfCNUAHFo5AO4OgMNajHKRkypX8XzKDvPig7KGpluhKBI6C07JkDcCoVgLgwNvTz+vD8gLpUeHQ3YtldtXakN1FRu4NBkW+nM2FsMi2GOMseE1hu8/62MKJBoNsWg3UUhPAwRTOLQMhW6NCVKKOrGO4GBWF
 II4BKo7n
 FSnW88r6xfyfbMVNkcN0WKfWOFBUDF84pIqscXhVuEZ0yj2BFsyvB6+PqBcgliOgXiPCD5dbg2FemDItrQwp9s8HTORYEi2a7DFG3zDv13kuBWYvUn/FWzA2PVPEmWFVC/No5YbPmvcqKmqzpRiy1powqr4aItxtTSEukjoHvqfUCShRnO7wG6RpRGwao2bzx9sPspA32kGoGiqCyilCxiPFLGouachldDAxD8DHXpAr9C5GSqwnKXKYqM7P60MNHO1SoKHyb7SEoBWsFdGjFXkYWzCunhKruvyzxTt5aTJaHTvqWsavd/KGKfEoFwx8rBXUfxcTvlLp6YmkUMYHaL4sd3ed83b4T3pKzltZX3gQufvHYPXZVQN9rQUetLIfneqY8qkLXR78argqr7wUxYzuVvd/cDXCmcg6DNg62Y/+af3/GKScY3+vevayBh/ROJg2lQKMhWM8mYccCDHh2o/q2VW3k3f3lIB+P3Wmap4+8TUOXPfuN5iFhd3OuKW329lwlZPPxL7GBOZfqJUHLH/KXRyKQR1cT4V/D8dFBZiNFGcupDl/+il5wN+KHbD7S7ACmmoa/pixxlsEOHweNFptugPs7L3mvZpseHwbZ4lIGeMSoKyN+oVotzh13dWcRVAWul1xxaTPmDo/pFlouL8m62L6D6PJX68dvKgxH30VNOUeWUZOA4EvLN55uo3gmPc8/gI4pdw/xber+B10fBAwaoL0KsjrBXgH1UuLCDg+rc2RE7r623nROqJ2TAjWc/MXL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add entry for all new files added for Clang's context analysis.

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
v4:
* Rename capability -> context analysis.
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b11839cba9d..2953b466107e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6132,6 +6132,17 @@ M:	Nelson Escobar <neescoba@cisco.com>
 S:	Supported
 F:	drivers/infiniband/hw/usnic/
 
+CLANG CONTEXT ANALYSIS
+M:	Marco Elver <elver@google.com>
+R:	Bart Van Assche <bvanassche@acm.org>
+L:	llvm@lists.linux.dev
+S:	Maintained
+F:	Documentation/dev-tools/context-analysis.rst
+F:	include/linux/compiler-context-analysis.h
+F:	lib/test_context-analysis.c
+F:	scripts/Makefile.context-analysis
+F:	scripts/context-analysis-suppression.txt
+
 CLANG CONTROL FLOW INTEGRITY SUPPORT
 M:	Sami Tolvanen <samitolvanen@google.com>
 M:	Kees Cook <kees@kernel.org>
-- 
2.52.0.322.g1dd061c0dc-goog


