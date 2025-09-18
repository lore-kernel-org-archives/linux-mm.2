Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DC29CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35B6E8E0137; Thu, 18 Sep 2025 10:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FAC8E0112; Thu, 18 Sep 2025 10:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226078E0137; Thu, 18 Sep 2025 10:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12F3B8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D488D1A0200
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:40 +0000 (UTC)
X-FDA: 83902546560.19.52CD0C6
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0321920009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pvqlyYkP;
	spf=pass (imf13.hostedemail.com: domain of 37RHMaAUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=37RHMaAUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dhic53vYgugE24TxlxF+xx8w5glItenUyktwwUAacwI=;
	b=mBb80JVi+ZnN/WmJnOx2weGugiVk9qbTSxMs5Wo96Tw6eQuBN2WjxKCH0779YOwDKeM1h0
	Mwlt1cZ4ExYqnzQ3RUqg05Vn+h/f7Qj+6ea6Awsu7IoAz7AfgOm/3dQKce8FMITf0QPq+d
	LnnsXGcaRGLff0FPDBcZeNwXfZdd7Hs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pvqlyYkP;
	spf=pass (imf13.hostedemail.com: domain of 37RHMaAUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=37RHMaAUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204399; a=rsa-sha256;
	cv=none;
	b=OIkptE1vqrdOKV5PPE9+2G3LHRCKrqumS3ziC0FF6F6sWrbzQXZPiNj8i25IBYVtfMJlrc
	FiEkJVPXsyjujXRiODuV0F3vchiCOYRdBk752Ui7oJh5yAkKOsF5rZ9ecVA605DOo5uHxz
	10JOWHzpn6gB32polWY9SpTs4lt+rTc=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45dcf5f1239so4591345e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204397; x=1758809197; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dhic53vYgugE24TxlxF+xx8w5glItenUyktwwUAacwI=;
        b=pvqlyYkPFIN8KICwxuWWcFSP0Zy4jI5ABDSLjFP7BecpFxWTbtKTgBsbNU17zaLjSW
         hrQwTfexDeJWxh9D1wpGT9fiDPJ0AoHhZl16Z+udJD81ZtC9J6oO4DTzxUNLDcWsZT4N
         Ue/oZ9xlhCcQssL4IwVV8E/Pbtd3zX6Kqp3T8F4yqXNxPHPMmd+QA7s3fne2GQFLioNi
         gyCep2emu4LHIYOOVegioi+sZeNvcrKnKE94JDXTyXA0l5Ldr4tu5YmKagspcE7vUo3D
         J5jrprGlHHsOPSAO8/2DgPThZjA0f/w/EBk0I8l6IsuURoO0XFNmyGOV5fZ/CFe4iA7a
         te0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204397; x=1758809197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dhic53vYgugE24TxlxF+xx8w5glItenUyktwwUAacwI=;
        b=TVJURAjUHlVY/o7c2hBg3hRsinjvLvZcGLT+PpRwpX2omDpGbdWIm2C3x2QlompaP8
         /SB1Amn/ZJBGmdxcK74F4HBzuqly8mYLb0oq08y8+5xL4KF1jYMQa+ljSDAdOKqAoJuy
         diwK3ABglSwuobAgdTOLOJXydeROIYrY5YSTEIeX3pPS9pTA+U+myllOQO4VQz8Cal6X
         C2728ZTdAzt7apHL2i7u4bS9yR1VQucEcRyEifICPN1iGXaqPhpqycEwTzyWRCq6Svor
         Z7XbF/MJvy6gax+xFmK4Y2izA16XrFlB8XAwn0KxURsEfzwoOTFLyJxciQXUXcC406+x
         UCqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVoLvYZDjZsj6GLtVJkpk0cI4fjAWWw7UT1mq+R8FiFHEvaUvP4ZeoRXBNpNjWEDRt35NKBg2ogSg==@kvack.org
X-Gm-Message-State: AOJu0YxyPeojHfqBrMh9lPMZNpEns5LrD/nq2IEpnrJZeKT6fLUJBG5I
	qoOUckqM5f5msVshQUB6XbXVOMcZCBeteYLXPsfKp9jGO+dnfEC27nMDW49ucmCVkL3+pRog7W1
	8vA==
X-Google-Smtp-Source: AGHT+IHZwXc50wF1UKzRkCSl9Zlzv0YXfIKjEUT7w3tckKijx1tkK0IOXg5OQwciPpS047ZOEU7YpUJVKQ==
X-Received: from wmqb11.prod.google.com ([2002:a05:600c:4e0b:b0:45f:2306:167])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c9b:b0:45d:d9ab:b85a
 with SMTP id 5b1f17b1804b1-46201f8b09fmr54309365e9.7.1758204397465; Thu, 18
 Sep 2025 07:06:37 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:37 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-27-elver@google.com>
Subject: [PATCH v3 26/35] MAINTAINERS: Add entry for Capability Analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: o69d1ck8gc1wz4aw1i4ae86jyui99wdz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0321920009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758204398-761202
X-HE-Meta: U2FsdGVkX198nRSQsg/SOf1RTjE6SY7BPnKx2Mm2UupX7VDDfHysf9I6zdCo/WQVPsyeEfexeArI8t5iZXpuVOyRRrhv4lHU4r01YUpV3mLZ4r7OC86KyGopHQjgVgszbDE/6wG97OsmeDC7vzpnhwFRKB9Fpd1i0itv7zV8MGEc6oJZ6grUeZRDvSo9fArUwLxQOBcSf8UKsA+yplNBy47GHxXyrDX/kCDsL+ggI1d1u3QvyrkNAW9bMKiUa/4OitWV9aiJKbgEBboPhQtyT7Drih2/WDfhXcoylESud30JlI5sZZS6MedNGsSTjlB92jSlGzwEAQELXr14CXP4fnHtwk7Wf/S/Aa9boTePWC2RfXEcTYOjBuDVb3odHAd/jQfPgQEp4X4vXLTtTrD8LhkUA49IsEU6bzDRvbpy3vxMesjGCR9ollX78LSsW0wIWE0C/V9HogxdRMOBfDPI+GEWV51MK3nwwFb9VWSe1NE8K0PmnfpbEE9Op0PeoxCxdvV2vLn3F1pnoBLZ1LSpMB/QTwO8Wv7qZ4B6K6UwUIBY1qu1SYuQVWoMD4l5Q/lFYmNuj2ZaXG/0pN0y5PYGGG8chXJadYDV6l58uV2ixKnn26X0DdBlWrhEwywQABOXG+lGcjMK55XPVcmXEBl3eBwWhHpzVTp3h7RL1Z9UvrwQBrfLcutZ3uWt5l04EOrkZKIbpECNAapUNI9RkxNHKvxSUr/J0nBUnlvbycSzvpLOS5XYVy5BVx1s0x76Yy8kxNXtBeZqCbmqzs63/pDOmnm8MoOISltk/alxS1/jrUJFqyWZ3ArAXcQUM0mftLdGLjeB9y5Hw4Rx7D/xQfr1xe85kinx+v+9tuZZO3ZxH5yrErXF1blpvCov4g3sHRizGS9aO7yCFrQc2l8OPoYkWxyt4EoxQwIO8B4FdCtbLjp4KxiWpA36nhBiG81USSwvrDBI1zPuuz2Kv+oKBZp
 N9UGS08k
 +JQRrHEKlNvTrL9nPcNUo6a/bCSQWtQLw7AH22wUvJMnA0yB5aFIcLlp6Zx44p/M4SzAD23/Zmkku9OHTLS4of7/iJQUHgZC1/MujWnN10Y3cDZQVTjv55ozmBbW6rcLUKFARqnymSh/l9qxSkTRNTlSAinzJiOSIDQDwJ3s7giMugoxxpTwqCzgeplxNlIepoKDYglJSGPyvPEoai+KUw2jk9cek0oPscRXGe9Jj1vs6y5ltD9xwEe98cIXFUldvO7k9VJC2ubQA9ScWUpUVGAIXlRBg9DXcduGMRmUs6kpcjgesitt5hlnU2TdK8LFbn68Sr5ZtPgmPqyxFYYjaSDbGxHJFtYYM10FY/smRVL052A57vqCtjsfr6YK4lA6DjTUve9Ys4T0486Xh/eF7FmP1xvwm5pkXG5u53NJPX3cOkohHPXXOTM5LI7swVcb+dKTgMs6EbSOZ6ovmepa5GQHCsImkefmPYmleELB6+9XCf0kU7NYy1mOZZVBbq8C+YSicI1YwCPp1w31s/rv2sPx7S2jiQU5T8mfN1iUezl7zGSHstF4xCelEdsiXZgGgFYYOZbSMzW5Y2ua66KdcO7FE0BfhxMXazLlcDYdXdPZ5/FwFRAfV+Wd4+6LMa0awjOEZ3ikwWSJ1mdeWB8DuD0/7DTxxvBwFYW1GxmT64/RxuJ7/xtRC3tY2Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add entry for all new files added for Clang's capability analysis.

Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd7ff55b5d32..da4c8196c1b7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5951,6 +5951,17 @@ M:	Nelson Escobar <neescoba@cisco.com>
 S:	Supported
 F:	drivers/infiniband/hw/usnic/
 
+CLANG CAPABILITY ANALYSIS
+M:	Marco Elver <elver@google.com>
+R:	Bart Van Assche <bvanassche@acm.org>
+L:	llvm@lists.linux.dev
+S:	Maintained
+F:	Documentation/dev-tools/capability-analysis.rst
+F:	include/linux/compiler-capability-analysis.h
+F:	lib/test_capability-analysis.c
+F:	scripts/Makefile.capability-analysis
+F:	scripts/capability-analysis-suppression.txt
+
 CLANG CONTROL FLOW INTEGRITY SUPPORT
 M:	Sami Tolvanen <samitolvanen@google.com>
 M:	Kees Cook <kees@kernel.org>
-- 
2.51.0.384.g4c02a37b29-goog


