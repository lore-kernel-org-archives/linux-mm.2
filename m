Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31015CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E478E0136; Thu, 18 Sep 2025 10:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26A78E0112; Thu, 18 Sep 2025 10:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61238E0136; Thu, 18 Sep 2025 10:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89E828E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54203C0205
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:38 +0000 (UTC)
X-FDA: 83902546476.21.D9B305C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 687911C0004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="N/ZCoZZV";
	spf=pass (imf21.hostedemail.com: domain of 36hHMaAUKCIst0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=36hHMaAUKCIst0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgYM57a4+YilIGK6iKKshTwAf6EJSKpu76VpXrklnPU=;
	b=MY2SdPvIU6ZBNpFAdFb4NQPDzKchgGeaz36j53cAfgZEUqzaa72hFYPAawrKt6rt1clp0A
	XRY88STblzt24lZpzR4idoG1ueFA84+oO25qjBK1qC+/zeTUK5IWSsg78dRwxCTTAAniKO
	0nqib4YHYAnXsPterQ2HaWNnWuuPkgk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="N/ZCoZZV";
	spf=pass (imf21.hostedemail.com: domain of 36hHMaAUKCIst0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=36hHMaAUKCIst0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204396; a=rsa-sha256;
	cv=none;
	b=h6Kn6DgtjXe/xQskjyQ9Q3GfU4C0M4l2w4a/wdu+Q/1jplDwH+KSPnHQoB3vCEh5XIJ0Kq
	oAQGIggg5rOh+O35Qk99ZPQ1i42S5s+uLUkMY4IYjJbRFFki/JSzHDObgzsamez49BDgAU
	/pUWpq7fBBZWsBJOGcO5OkAaQyCeFNo=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45dd5c1b67dso5233445e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204395; x=1758809195; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rgYM57a4+YilIGK6iKKshTwAf6EJSKpu76VpXrklnPU=;
        b=N/ZCoZZVC7EwtwwLMeoxrKNUaxBPgaKrfFd7gwyZdpsnX6xMisUDB6olnZ1rhAW5Tl
         Fp0ECT7dlSZAp4+k9o6sREhi2Bodbm1nrfMA6pfB70y2G1zwbAyb7WU8q/EL8vOtWOiI
         rVHoVrVLqjZoJwQFDp98o7i94sVN2blhkH7vDtK26obwGOHYafE/h4bQIB/9EOUJxJ0h
         hY19MWr2OLwpZYf+aXoUdGch1MTfT5ruQYXK08Bgfl7ehRUYREa2+beubXLc74L/dtuJ
         8UFrm4QmqNkv2TXmX9umGrz1uynmzYlNderMGIrj9DZL4DBea5uztvbHIDWOXBChMRi6
         PKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204395; x=1758809195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgYM57a4+YilIGK6iKKshTwAf6EJSKpu76VpXrklnPU=;
        b=jNDjGmJg79yyVuxGNmaO3N5sSQDJtZahArtkWa+iwy6hXhEbJcXYnD5++/hKxShXqP
         z/JTh4tlHr+euJhLf3sHTYLRrAf0+bdcpbI2KT8w6oCUYLBGsNAkAXPDORXLO/dMec/T
         FL2Tbn8B5ETX7RqF3efXDA5iCqm2L+sgZJ3iuaFhB1s5/tV0j/kn0RFroywb4RCMZ59o
         DWlFcJRmBcjhL0qfkpOhslijSKXTjtskeGHjYG0Bw8FFkeKTp/kjypyChVS8dGjPzTl7
         C0g8ByDZjX0AbtYO9XGphkwLqtyb//9chM5Kszgr+YpvqnAVvRxDzNVDxGRLVzk1qayC
         cSHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ3ONqXlZZ2JPMuPACJDvQxt8j6ETzYEmXaNGzChvj84DmALk4oz9ZqXiBFchJM9SpT6qiDlfWUA==@kvack.org
X-Gm-Message-State: AOJu0YzuIJ/GIZcb7PRvp1V0GjU6zY3sY0F78TeJrcifdfje9QxjhFSy
	gHPUJsDRAqKKEurRSK7Z4IVgCSqm67gW1i4t7iDhqwkDfBiSVsxaPXRc+hFZyaEpwkaWYgW0mav
	7Ng==
X-Google-Smtp-Source: AGHT+IGyq2ix4kSVUhNc102rzu/+pi5sWigmai5zeC1C+WvM8GfTqI/Oxr6AI/FM5MqgBjTC/NiJq7z9XA==
X-Received: from wrbbs6.prod.google.com ([2002:a05:6000:706:b0:3ed:665b:ec9d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:adf:ce0c:0:b0:3ee:10b1:17bb
 with SMTP id ffacd0b85a97d-3ee10b11893mr1782304f8f.61.1758204394951; Thu, 18
 Sep 2025 07:06:34 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:36 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-26-elver@google.com>
Subject: [PATCH v3 25/35] compiler: Let data_race() imply disabled capability analysis
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
X-Stat-Signature: 7prfrtai15a4ctturoc4y49538ndbhbe
X-Rspam-User: 
X-Rspamd-Queue-Id: 687911C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758204396-189756
X-HE-Meta: U2FsdGVkX1/F0j3TXm1CsqsPknZxZ1nA51ShC9HrL1CNEMYgGTu5KKkIv+wkl2u8RkRnN/EvQJ/FiUHUuz50XiAwzEC0DrcFK1AWLcn2U2Cod4PEaNHbGaYM+IafRJv/jQoFe04HXEYS+fnUCMUTb6GkUUiMZPVFwXjwea40K+PiFJLfOg3pHUpXZG51X4UuYPRVfAN9QOZ4cztFGpxvLAgkawsusEcQMrwEvXMjXJqrUyLFW/yopA3KhTlwayDO/zs1wUswTmVc0awCfRrlbNsoPVVS09r3APs3sgbTkNOtEdhZ0Kb2wJWX+lGM+IhW4LSQQddQKoC5afLlKb3CoNXOklqE59DewI8IujzuaNEvAtHqGBP1GCsbgo3oHWbHvsnAVLUdbp1FVJyrfe7pkrc3HHjx21bqE+dvvns/N836/Lmll60H8WFe6cTGWsiAIAlt2szPFR18iH5K8bnqWTgkiT0iowDGjMSJYQREEBCsWr/+FWclP7RQ5uaRM20j7gQpLsiW1EQsBMRe8QfDNcqA1eyN1o3J8SejqtqlcSHtmdKOkhZxuylN+fEpRvOGKgMfyJMFSfC18AA0SYh0Fm1/YPKV6TeIQ7xX4O8p8O+KC7HNewwQ39hNv7qc9p7oHQoPOM0/EwfarD9qOMi1z//+cmhi93Zw8FI3ItM7NA1al1dm7uUlDWB8t0huYLcrrmrkgS2fgO8GKgR8CInz+BDoybUaIXAA6JLi05Lx1G9WKHDmbNf7azrBYuT2NZgS4h5b6TDye0Fgy5tTOUP4FhGjbmyrSVkrH7OSEPkZcDNS3p20pQa5hTXB0rNkmBtRgtfzFRvqNIVStTfIPjR7sjo2ReUYPjTLnkryni4SosKsKUgHjyyOB7fj9TuqmYxSFznf9kN1cnF+fK+gLuKbYgLIHXztY1TrdwcpwmdBRCeZQPk9DUEkM5p9booaPTvTaKpggyhzwqHWcrAK6Zm
 tayFUuK2
 cXKfbPMc8iIJiDkFS4kTJy20r5LyuldFrIHgAqw3gDzMTkbG39+8WexnxvtJSIB965YtYH7ojrzNQ4Io0RaluUnRLCHlVCeNXqE9CU+En3aSQpbeSX53/xGi2u58QweABnd2hUA/IW5FvSMRHG037Nt2KQScFV1o0WCEQltdxxPwU18OfD4nkeDv5jGb6KvN8YiGnCgtmWjesKtqMWRWH3HzJbtEyqo8T3AHYn6qcZevYeF7UzLfe1cF2OYDXyR/C2YyL5UHFHCw66VSpalsRrBx3CvadS/q3UVO1QqoUbH3CFItT8Uw1QBVNfwRSFdu1DenLUfI1NXg6LP81sRjQ1YuwggE6xwqdANCWIRDscnmZoDc/wHMKeZOrLyXtPHu8AmfaZCo+BB+f/Yn4oIWIth+T4KYdiG4x/zErMjs51zurXj7PincGo3lIQ2rezLOEVYu2052ztIdFMQhTb6wOVzlKJ33fYBO/fElFcs+LqFuO4nxJzQULUG+vjzZYZMzwu8o3Oo51Y1PjPBx6r+GZcpq05OO3KkUv788o47B4QdH79EKdroaNx+uOHzbm3bQsAt4SSvn756YjlYy7i7/lBXci+4RuujG1X2pOksBdLcco4xaVDJ2pxP7Hsg==
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
access, rather than having to write capability_unsafe(data_race(..)),
simply make the data_race(..) macro imply capability-unsafety. The
data_race() macro already denotes the intent that something subtly
unsafe is about to happen, so it should be clear enough as-is.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* New patch.
---
 include/linux/compiler.h       | 2 ++
 lib/test_capability-analysis.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 64ff73c533e5..eee60adb3645 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -186,7 +186,9 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 #define data_race(expr)							\
 ({									\
 	__kcsan_disable_current();					\
+	disable_capability_analysis();					\
 	__auto_type __v = (expr);					\
+	enable_capability_analysis();					\
 	__kcsan_enable_current();					\
 	__v;								\
 })
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 12fd9716f0a4..513ad28ed06c 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -92,6 +92,8 @@ static void __used test_raw_spinlock_trylock_extra(struct test_raw_spinlock_data
 {
 	unsigned long flags;
 
+	data_race(d->counter++); /* no warning */
+
 	if (raw_spin_trylock_irq(&d->lock)) {
 		d->counter++;
 		raw_spin_unlock_irq(&d->lock);
-- 
2.51.0.384.g4c02a37b29-goog


