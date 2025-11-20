Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761FFCF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5B86B00CC; Thu, 20 Nov 2025 10:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7375B6B00CE; Thu, 20 Nov 2025 10:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B16C6B00CF; Thu, 20 Nov 2025 10:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42C4C6B00CC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05F938652C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:36 +0000 (UTC)
X-FDA: 84131329632.26.A0A8560
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 515F68001E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xOJGxivL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3HDAfaQUKCEkpw6p2rzzrwp.nzxwty58-xxv6lnv.z2r@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3HDAfaQUKCEkpw6p2rzzrwp.nzxwty58-xxv6lnv.z2r@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNvl5AadBnBbkNqIZ5ePr/ep+DGb1qTLi02EcnmaTpQ=;
	b=PFUY50jIz9Rund//SuEI904L6ODYlYhwoKkFtQV59EG1D93l8Z9I1q9XY6xjAwySMGMvzw
	A+5ToGbDYn2LXqK7mc/vk+LxpYWwYgam3rqB4k8pXH7rEBr2EaCCAUZsVckRwk0y+HSeni
	LugTqCgje8qsfRWJXsOplzaOOi0nh2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651614; a=rsa-sha256;
	cv=none;
	b=kYUHBJR0BSbrhOixfjLCGn/HCjzLvNXf3cFYnudA3vELKO+cGoBTpg2k60196+oebYrlL8
	xDwSzXHE/arZ93X59Fhmp1wZOkhgokGudzhLp7LLvKQcgyzKHhpnwnjn4YRjVoWLevdJGa
	cAb/fB6pT0kvcrPTYfuO1eyvRcXAoyg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xOJGxivL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3HDAfaQUKCEkpw6p2rzzrwp.nzxwty58-xxv6lnv.z2r@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3HDAfaQUKCEkpw6p2rzzrwp.nzxwty58-xxv6lnv.z2r@flex--elver.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477632ef599so11886405e9.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651613; x=1764256413; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xNvl5AadBnBbkNqIZ5ePr/ep+DGb1qTLi02EcnmaTpQ=;
        b=xOJGxivLGXxuD7T0nen7CdxecmQ51Y21jjH3GxfadqrQNei2eI1What6DGAgzpuWqT
         Rj5Fp2iCJeqLGRtMnkpjEzDsPX2dsJVps2WYzpzuR9A2CSkTZ0+ml6TlUMchlo31WosU
         e+lvbzuaqvXp6c5ytxSn62Umxv+QB6/Kn3Xk7I0RvQ0HCJHfNlJtRVaq6MBZWnYlHdkz
         +/fQ4lQCkBSkO0d2Z24sg2EoCFc6rbVubwSZt9nkIpZcrMLLseIt0pscrdrH6rwf8vPA
         g6EC3u75Rtk/7JdS6VQIQA9Qylrl0DB4VinVUguLPKk+6Kwbx1HoVZXd/ipGeQ3GkqvT
         oCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651613; x=1764256413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xNvl5AadBnBbkNqIZ5ePr/ep+DGb1qTLi02EcnmaTpQ=;
        b=iqH8ZnKQA7ipyu2eow0LdyEJydz3vb8j2MFCquq/w+5zOjA1rSY8bgYkkVYQpG/pIH
         noJAlF1B4qUC+triCdJ2v4bWvmqw1r2hzi5M4xOjUV3UtU87aJbWLlGbAbJ8NuBgnQAa
         xumbvnC6pzfoUHH4GisFcnnQJpKYleO8G31nezsyO1YEN6Bn26Fl2NA7PI+kVI/Tmj+m
         uZlDEsBlCXDo7RZBt5UNRjadveCwXHHI1VeaIDIW06KbH7u517OI33XaWMKqRB0AilR4
         2p/u0Okuq6PXFC3nQ+YgS2ZgC9jXPjT+AzihKFYbeWXNvC9cNFNn6Urye3bn8Gj+buM/
         LHWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLHeYpslihVBB7DBeeEr282F9qmp8r6ZQJ/ECHOwGuhSZacWT/qgayITuJX3boTPqdb4q4Zbw8ew==@kvack.org
X-Gm-Message-State: AOJu0Yx2HL08BWbS8kNAQ8tPBB2DKz+evJv1L4eX417J61x8n2rgXzU/
	7iz6lnW6BOR3af/NK9yRBJuAKtv2xWfOojqtezuA0FKZEJyL0J8tJ3HZhWTUc6lIHVzVbdp9Fi8
	dSw==
X-Google-Smtp-Source: AGHT+IF9W56E3BCf4ycfyNzV0Jbt7zmYcg646z2GlS6yDnrRg6LpKFxf4hnN1dp2GqjQ6ITkpBqUZJJJqw==
X-Received: from wmbbd8.prod.google.com ([2002:a05:600c:1f08:b0:470:fd92:351d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1516:b0:477:14ba:28da
 with SMTP id 5b1f17b1804b1-477b9ea8f78mr18741385e9.5.1763651612613; Thu, 20
 Nov 2025 07:13:32 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:51 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-27-elver@google.com>
Subject: [PATCH v4 26/35] MAINTAINERS: Add entry for Context Analysis
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
X-Stat-Signature: qwq7gy7jgpnirn3efjci7p8p5jj5azah
X-Rspam-User: 
X-Rspamd-Queue-Id: 515F68001E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763651614-496437
X-HE-Meta: U2FsdGVkX1/57G9rUO4XIG260n5cONLTXvwzPVsAh7ZWL2cOakPcyD4m8sGtxkIhtZEwnA+z+PfSkysyl9cGxh8VDnGhtPxUxMXjKluADNxPI5DLS128HXPDuVjM5LqN79g0YfzYCqgAq9lFmHFpDl1JtKinWUZCrk9mrCWa8AoGxkXHyt05n2buDocHqBSmVfMHCEwzT6ABLnv1+9hEW5IeewP0LpE0XUtTcqSRGK4SUjBA/bWWMc6FDnsgibpKKd4EQV6o6tS0POsMGbxvTDRIDurZXURq7ljPSoiAUEy0r1V0Mckhsa2L0ABlrjmQNEqM1OcxaOUcOJ2tfiVk0zzBPbEp0reZd2EbaMik+nD8NH5TrtfbA73exd1xGbooqtBTxYI7nyDFaLAwCPNiU6doG9r3HxXY1/1gKoSgWabWdPNiUgj13Hvq4lS/L98hsWvkXquBNO6bD/HYOc0Wyf0avJjbiA/B61hJMiTh3cwInHbPSVGah5ES+QVQaDByhag3ygzesPNvHuFoLDQDEvcf6WfEhYA9aXeG8UxkWPuiXbEcIh3QpQoOTRGIMLzCYd9XHxcGBB+mLzq303cCaMor6CRuE2fNkEOXpvBzw5Di6zqQ7MlbqhyxjPo9y5UM7Nn54P6nCDZ4oq+RqPy693tj2HVLX4cqUg/FVv9w2T7ENJWDMTS/CfqT92KKhewyrcC+a7ubNEIFiIiA1SDfx6CU6SXI76ZFmxTF9OsqQfsLHpTA4+nQ9AUsfL5ew5XWo34rUvXabD/JEhs5Hp8F2u24lROT2+iCgSe0/hIe7oxomUJXAZ5W7Uz9n7tmxX2JcOY8LRTzXVXHQ3E/3Uobfoc6HZvbK+lQPLzpA+SB9UB6vA65hBk0hFJ8G8GAD0Yk8sm8NXKRjyrjSUc2RBqmLXr8qztv1QVJTdimkLanCs4H56IqPm4eupuu/KzCWJdQjV6h1vOKrVaYunJYumo
 9yy8m8Si
 4BPDLefpK4SG3HR6H8WxrFyTqvsgzE2DLfgwM55UgcoeK2GT11W7tpDZv7tYT2TbEnapgM94r3POlzPhY0g/fBXek3sfLD2AyE2a6apQvtygyaqblUy8RRnvO8SDSexItoA8k5QnVhwVbsS+bRMnajud31lkrKS3oF1GDjiYvlgwJFiX1x7AWa2C62akh/bjtELJ0upmymVklG3DvkPk3PMeElU8XVqBxdD3k2HL8Dba308wB0oWO2bcQ6F9emMoPfkBZTW53cS26hACfp2KjJZax1rSF22ui/FggWgX0ApfG23cJ50fCS//kpKylttFA/BdOrNDWGa2mKIFI/Qo34FiokNu2JFHMtMmUHsnprxljlBSwmUF4uO7p6tMlulOXYg2JR73H14o29KT8mXj+npuGKVFieqYvrhA7
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
index e64b94e6b5a9..0445478f74c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6029,6 +6029,17 @@ M:	Nelson Escobar <neescoba@cisco.com>
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
2.52.0.rc1.455.g30608eb744-goog


