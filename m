Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7CCD7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376836B00C4; Fri, 19 Dec 2025 10:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A686B00C5; Fri, 19 Dec 2025 10:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22CA66B00C6; Fri, 19 Dec 2025 10:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 107276B00C4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD723C0472
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:13 +0000 (UTC)
X-FDA: 84236649546.27.C4F46BB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 01E8D2000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TqGu9kgx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3fnNFaQUKCMsv2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fnNFaQUKCMsv2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159232; a=rsa-sha256;
	cv=none;
	b=OB3t0rU8zvE4IximiEnjtSR05CVCore8npyf749/uQ7CJn4pxhaqtSdzENNE5LRa2V54ic
	UG7pZsPwQAxEuuW3npzaW7dE69/NwZFqxpSgKIAwZRFvFuuVU+xzXrxHa3UEeojgYEfD2l
	YbsObNt9cnR8jbqK5ajCECZ7adpG9WY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TqGu9kgx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3fnNFaQUKCMsv2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fnNFaQUKCMsv2Cv8x55x2v.t532z4BE-331Crt1.58x@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3sgEnhMWMLOYj1/OofGWKavVFtW6YP1ndiLQ0rOu/8=;
	b=HjtNJMYREiqX5lUEkPzboouQBVnPwNn5EGrHYpQXjHyDzMHFJ+PAdfzoP8a4EQKQ4dZV3M
	Xugjbuxp6V4niai/lzmUbys2/seo+IesncQehIl8Cs1nQHrhQaL7/QUvW1ptNR2BsD4FlY
	zPcQzMDC0QPuczK2G4QUvy91V9tb1rM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47a97b785bdso13262625e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159230; x=1766764030; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J3sgEnhMWMLOYj1/OofGWKavVFtW6YP1ndiLQ0rOu/8=;
        b=TqGu9kgx4VWdL94Ce4/3003y+KffRCL5cEaSowkvc1L+mWAWryaqLE6IZbdyrBk1ni
         UUwKRUtQY3ukNH/4Vm583QXNZELcED6y1Zimf5x9kr/8n+HpmeupmhNCS/tkLsBSWJ+A
         JPc+wZPIwr4sulyDdm/X28dxKwMmyaFnFAjyFkttQmxBx2bosS70sLywChNabwq3Zf4H
         VIjfcAyqkX+PTjLMNIsWPBHcPbRNgPtrjYnnVwkgvZP4lTlLWkHYVpyX2nrNbeC6BX1N
         HDaBMgsOUj5cFf3pXYUQ39EjKlgdXVUcPvOV77UZybFOXWwYiRF8/T7IyhJmejhRKrdV
         p+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159230; x=1766764030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J3sgEnhMWMLOYj1/OofGWKavVFtW6YP1ndiLQ0rOu/8=;
        b=h/+rd2jEyTewpyQsgiQzaeORwhBljGdU4NWUoGOn69+y1+UwlUByzRfwkG52N3o4Mk
         AJtdHbetfC9jqtGsj2UQCGAFq1+cxvamUFe5cGbBxn6qkSraxnCuITsyxAshghYgesSA
         FuFzKW5j0aXi7DLXE9EHOHs5V/lt5mO0foZVk/HEZ9y17nFJZiWMADtIHMB2iM3ZKmn1
         vMjXYfeoi84kZofuwhJmYIVZvRQPDO4ocL2LPieSGUlQaTye7pUjAmQCF9laeoSN1T15
         CltNGYBS8Qhzk7bC2TNFg4fzdTRkdlx6GGsqbg+RXGD+fR5bhIuz6w8PSTT67HsT8jYa
         u1uQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5nui9xhfP4m7woTAmu4NkSkz/YFm260uOJFgiCrUPM4yUz4uxy6m8CkU0169AiIo5BC0jzxHPLg==@kvack.org
X-Gm-Message-State: AOJu0YybhbDvdUDKWHnlWaLD3QN3yIfcGSnCq4ruMwrE8npZ9R+oSaqD
	g1GEBa/0UIV0nIeG607iwbMMvKtV5sK5x/3kYiIe2KlvviZgt3zcpgpgbtHGfo1zuF8nmjrsVHE
	xow==
X-Google-Smtp-Source: AGHT+IG6Z5Tj65gpnRG9ZfygNEOWxPYymEwwgB1rgfvjvus65EDRt+hfREOXwzDTtwSRis3WLEZWS8/1FQ==
X-Received: from wmcq18.prod.google.com ([2002:a05:600c:c112:b0:47b:e2a9:2bd3])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46d1:b0:47a:8088:439c
 with SMTP id 5b1f17b1804b1-47d1959d6a0mr26330495e9.35.1766159230294; Fri, 19
 Dec 2025 07:47:10 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:15 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-27-elver@google.com>
Subject: [PATCH v5 26/36] compiler: Let data_race() imply disabled context analysis
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01E8D2000E
X-Stat-Signature: 75b3xcctcz68saxghjhrj8meb53t3j61
X-Rspam-User: 
X-HE-Tag: 1766159231-809351
X-HE-Meta: U2FsdGVkX19VpFy2x1wnw+gJmlgUt+abLPa4gEp+NGtc4gXWT96OJzJi0L1jlkk3yL/LByY674ICUmV43uOyQrnlNQ3DuysZcPZOliHwg8uwCQToEldKEaZkt657wtUWADGEPQDVJ4yO0i9pHDaDYZLzfE8hW0UDlNsY9Ug5eU66D6w40eoNyzZZhsmKAz37M0i4DIDTkl5r7ZQAvq3l2+i5HvkScaemq2eSz7StJTy1zdWhuF+MnPiw50+ayB6uk0djUrgkdEUxb7pEALGaL6tJ4s2Sp7YWtxV3MaMM1gv5eOEdzHsnyUHBAlIfvXdD6L4S9TrKMWMutu8qUkcXBlw1VKG450lHDo80gK3dtigBjeHXLuqiZ1lzDNUHY6ZIYsMaOoh2OmvRWiwSO6bBuElUl6NlFyEqTXfAXIs797EaMTH6cjPG54Jlg72R0Vr4JwY63GNLvhNdEuQOBuwM2NWugdb9Y+KrRjr8aTysr/yRAW55HsGfM4Hq+rUZbPNv5OyQlfeOAQMeUzq0k86T0+0+n86iXITIuX2VAZK0hR35+BGQ6JhNPA2ojQ1d9yqPMMrMZanWJOf+NiIQPvemNfrnhKZ1cKWDnErVLR6Dz9HuFLZN8jRs0ln5hWXIwTG1dNTY/uPdQ3RI2TXBSuEuzcJVedsWn4GwGaOZh0mKalNAuSQ1SfUpkA+GiwnNKtwyvbKjOsg58MRK+e7VFQeoPnCAW+uGsqV9NDCiYOA32GeP8hhHvcaY/byI5uHnjuxYwOVS0m+Y6+i35JFJUUD30L7gJZqjHnY6WEaDeuGPhy7mK8KUjWxHVSYs78LS5D5Q3qCaECNy8na6iqJp9Im+4TBHIMRhsrv+kjaUBKhA6rlE20K1zdEZktuYYccWgsAUmAioGNtGaEoTdxPaLXbU3tHnE5aSKommJnQSCguqY1Srqe9n4p5udqa5vn9H4w6sjS7ToWmS7vV6jkKhLYO
 gWuXO2FF
 RKZu0zU9pmIIN4c+bOA0rKsn0jpxU88k48mGtjk4YvCiWxnkIwzn5NXmifjJ9dno38LYaWR2fBR35j5r/9Bksl6SNLoqGvUWHFX3MIHXd4WHtpW8uo9EmVHkcN6XAi7J0DPhGF+AiH7XD7kAJsnCfyZq9klcmFtkz5EvOuve92dHL887qNpZYKOtcP8/LD0E5SrJgOoPT6d90/fNCOqsTOhfT+lmGGiYPX3m/5zBo+NwRjN6ZvWv19MxqnCFdmF4Xerw1hf73u0/CtUXoKW1aUQr1fHvYHefID2WvZtvxs2OnEh5QbWTLBvV1BkypBjQrbCaGr3xjb5M6uD1kbDpvc125Sk0yRojIDFPymH5zz+QO/vJrAY046lNJZu48mIqNALtqI9I1DAE6o3n0fn3sQlZFgp3VoFcyaBxzjbiOTf44WlHHF3eVxOypwyto4uNoyk9ZO5WCXVI8I4A1yISCLBe/+zyiOWs7wOIWHt4ipdMAe1xEbg0urQUT9rteALxe1wZYUu1Wfw7RvuKqioL0WqL7kHg0bKQ/dzMinD86vgkUDua04lGddhepd+YyL+jRttH7ot+N4Dfr5cXNBw2r4VDkjmlSW653LmmzW266bLOPSqOl47dXez7CEfylweFQKg7OtF6kgOuvENEfv8u1OC7YBzkre0nGOi8ovojE1XtwjAdLias2ByxMXGoTycz4FKlupEV/Kol646uc50ks4VWDmWBCRfmPplcALuO80Wo2oWrUAq6Mo2clEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Many patterns that involve data-racy accesses often deliberately ignore
normal synchronization rules to avoid taking a lock.

If we have a lock-guarded variable on which we do a lock-less data-racy
access, rather than having to write context_unsafe(data_race(..)),
simply make the data_race(..) macro imply context-unsafety. The
data_race() macro already denotes the intent that something subtly
unsafe is about to happen, so it should be clear enough as-is.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v2:
* New patch.
---
 include/linux/compiler.h    | 2 ++
 lib/test_context-analysis.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 04487c9bd751..110b28dfd1d1 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -190,7 +190,9 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 #define data_race(expr)							\
 ({									\
 	__kcsan_disable_current();					\
+	disable_context_analysis();					\
 	auto __v = (expr);						\
+	enable_context_analysis();					\
 	__kcsan_enable_current();					\
 	__v;								\
 })
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 2dc404456497..1c5a381461fc 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -92,6 +92,8 @@ static void __used test_raw_spinlock_trylock_extra(struct test_raw_spinlock_data
 {
 	unsigned long flags;
 
+	data_race(d->counter++); /* no warning */
+
 	if (raw_spin_trylock_irq(&d->lock)) {
 		d->counter++;
 		raw_spin_unlock_irq(&d->lock);
-- 
2.52.0.322.g1dd061c0dc-goog


