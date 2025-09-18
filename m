Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D0B8CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E398E012D; Thu, 18 Sep 2025 10:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35CC8E0112; Thu, 18 Sep 2025 10:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25758E012D; Thu, 18 Sep 2025 10:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A10578E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52D31139BD0
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:14 +0000 (UTC)
X-FDA: 83902545468.10.27F4456
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E5ADA0015
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=25CVOJ4P;
	spf=pass (imf25.hostedemail.com: domain of 30hHMaAUKCHMVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=30hHMaAUKCHMVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMl1c+2bip1CSgLpfgWYnQ0cyIrLa9qex036CuBQq14=;
	b=0EMbQ1on+F3eRlfoj/Nm8rU5sKol5VomVZkPJoWuOsZ37Q+qy2YKX9oUm0P88wbKen68T5
	IerbL40kNiqVw1E1bKzQ0SCZRl5T96OdZi9jRMUPYoJHJgEf6IBjHk1DjhcVtSzejvkhjV
	wPh4z8LF5JnZlL4oKQEXsaUwW4zzWuU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=25CVOJ4P;
	spf=pass (imf25.hostedemail.com: domain of 30hHMaAUKCHMVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=30hHMaAUKCHMVcmViXffXcV.TfdcZelo-ddbmRTb.fiX@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204372; a=rsa-sha256;
	cv=none;
	b=D8mdM1c8XBKQ42Si/2GSEB2+tksic1KvVOn1g7aY5HHWD4q62imrOWiEF8kJoj+rsgQe4T
	H4qh2+mgb1US0eY5UIl+Mttsuqcr5hxH20ObpyfA5AN738DjGK2EMzAgJYRNQMGTkMMxOv
	B6kgojeCq75mmr2lWoH5mkdbSs2njRg=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ece14b9231so561433f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204371; x=1758809171; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nMl1c+2bip1CSgLpfgWYnQ0cyIrLa9qex036CuBQq14=;
        b=25CVOJ4PFacfs2kWMPSre6knrr7mVmyMWc6MiGzUX3gORWRpBT24to8f0Q9kDHeUeC
         rcCRSgUVRh2zEamRWRhwGl3/gDjZx4C7wNNbTb6HuFYqEjOh8tKdOPxqLllJmj5KxLH4
         2/2PbZQSVL+Ww9T2jFyHOuaj9xfwxPi50w+nL83xKNF/pKmatCKfLpGmM2+J9eFhzVpO
         kT0dMnHbVJo9fgEit2swnWDmlkH9HrbvCKg2jmBTCaVgOJz+mC373LaObBNLEwMXuonP
         cIwNxX27zJq5I6Up43yPS7I5sf0JmiYQeW15Chb17ZRJ1+IPX+modiUHAg0yw7oTAB34
         HeFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204371; x=1758809171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMl1c+2bip1CSgLpfgWYnQ0cyIrLa9qex036CuBQq14=;
        b=WLEzPQFUrqlgpem1L0RLXvM+c+/zjg2ULcj2z7nGEl28isvcp8d+Lpj4Lq3rMApN21
         PHL5dL2pH+E+7EF94qVmLta7H0OpdOFlxU2NRTc5iCehnp0YN2OeEBxRqu/orVkOeXXj
         xlgfMXv2FuGsXpeXN/hwQ6rKuXw+CEEji50ZjJ+UZITMb5EKgks/TQJt/x7OAj1SFEoB
         r85ZZq7VHlrOHzpN0hKjZw541GzB3aUrmrwGVnbgWcHEodh+MWOl2U0H3AxeyGI1smFh
         FgmOZlySV+zo/HpPnddxEbHA5jtHuWViiZYzaEIb9YvQUtDTQTE2VIMMIigNhLujhXcA
         P5dQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4upUAjKs1l9N4myerZxerD/Bt7IlhiHEvysLYn30tevpi3mgHxs3NoU5idUtANCN2JM5fq2sUzw==@kvack.org
X-Gm-Message-State: AOJu0YyhyGuApPWLOfhF46YwS8J5cNhEd1RuIG4oJlaUQrsOYrmCGwy9
	GvlIxX2NF77gvg+T1L91m5fpcXx/Xk+zpi4sOs6i0wIr66N8449XmrSDFGyGnvfQ0WMJTwUmIvY
	cXg==
X-Google-Smtp-Source: AGHT+IGGSan2NMk0haZJyAnJIFJtZQy4kWfduj7BSWtkqxKSEROyPCMlVWawyq2y1FSCfdmQzsRbgTIQaw==
X-Received: from wmbay25.prod.google.com ([2002:a05:600c:1e19:b0:464:f7d9:6b0])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:64c5:0:b0:3ec:dd12:54d3
 with SMTP id ffacd0b85a97d-3ecdfa1eb5amr4911144f8f.35.1758204370434; Thu, 18
 Sep 2025 07:06:10 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:27 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-17-elver@google.com>
Subject: [PATCH v3 16/35] kref: Add capability-analysis annotations
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
X-Stat-Signature: 5dupei1msxzqwwhzc8ii47hgnykx913c
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E5ADA0015
X-Rspamd-Server: rspam04
X-HE-Tag: 1758204372-498663
X-HE-Meta: U2FsdGVkX19dU9K73m7EW8NNL7N+qVA8YQmt/J1gQ94cMAopC2sr2YMF+zv4PT7MnUiD8WmK4IUY+Xu9bT6rOTcv+qxyfJurL8HHut5h7jokY5lXnjfTNOFE+RKEC1By0sGhCQhKxTqgUq+6okEiK56n8lur/54+XBKX67dO4XeZ14aUxAZco2XjeKeUA390+/sh8Yx1v7KA+s8k351SUsHQB47hWQ5IIJ747o0fRzdXxEOgWhJ7hwulkZ88YLUY4suODlRd/5Tva/hLvXpjK+6+75Zb/GdLb736HVU2i7beTyH8jH+YCU9aq4cBwZ/DDUt81H9/i7ULlVEoANKOUOlWB0wzm2plUOT1qlQ5h1q2IF4RoeDEaz37lNQsAfB0/4XrjyZ1OSnUBhqsTL3qZNUrND01GkBzABnB9JSa1iZAru1wSDGibgDgEr3I6RchNdT1rpmcy7iEpQyV5OWWbt6YC1m/TxCeyey2qrbx4vYGuZV5lSpj6nuVn3OAPnBo6QlzMhfKItxWdX9a+HP0Xf/j0S9N3QqbqHi2FXZe27mcGf+/LJxfPg6smZ5Bag1TbEwCbI844/fkI8XGtqiTrVJYY4LfZ3O3Pg+iWUMNn4320xQD58RVuCprm+H9Cgm0zWEbAX5HkjmMYon2LXirPMQYKU1KJHBU+9dRhiECOC2Zxc3qMey+lNx76TEikF3BZYyWJxnQd6P8FOsi3lqqzOW9xeBWzxAaoY5w1yaShHMS8sFwLU+vNkMiLPk5Kr+c4DiHIIupxshksvjXgQuDDKJvZoOOHvuYnUlsL18T52+RYqEToyW18wLZ0k52Os0UYsZtoMyDIXz/iSBnYzPVzYy5uQoCFDLDcgSNN/xXlVXDgoXfTOSJU/uJ7l/Tv7o+5oqQB34I2oellUODZF8ahWLDj8xFTDDQs53IdK9xi4TX5tVH451vyvMUamFrdFecfBZt/rVYuDbUsHUwPdH
 4TwSRksA
 YipryXYU5XsKbe8hYv3hygV/nWKTOj93aoRGK+DTAj4pnaUyDLPPfQilkoyWq0QilWkgo8g9H6r/q9ie6XKgXMil5lD0PT3fGraMgwIJw0dK6DteIVK8KTlXkco49lojFHGFO7MxivYuZ29R7+Q8AQ2+1bDvPguDrpgRYmpI0Rb48Qg+XYVuE8ISZup0gV5pZ2T8loWwBZR6IE0J5zebMAY52c1lz237IuMrMyndCIknYE5KTZlAUhdw6XIvDRfzPc9brKljwzJUrOpevY0cLdlnaRRaHFHWkvei7BHk2zc6aaTUW/+qX12l0BSMgX++pabBUUh97YanuE92ghrnRq91ok8n3magUVzpeYrpWLFzZ/4juZsk1h+ERLRLt6X8ExUuxwzPnfyiwtxV62DpGDJeVOumlMzMP484Wug45RWfcQY9N9+Yk9BtPLeJABDrY9/Ix41hv1maSIUNuAqVbXu7l1YX7yTQcZko3Omk0MngXehLr8q1YBD8rnplzGbyrztrx0anMBiyh7aYpfQC4cDMfR0YN0ptPzAgQYMFUIMPrty5/lf3FXvxsnE98C2CMoz/E6y2juvSG5f+TBR26pZce47Li6cCn5o4Wf9lyhdxLG6w4M9ysE6gF5o2A5YW3TMMlj9RmP/9jPtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark functions that conditionally acquire the passed lock.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/kref.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 88e82ab1367c..9bc6abe57572 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -81,6 +81,7 @@ static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)
 static inline int kref_put_mutex(struct kref *kref,
 				 void (*release)(struct kref *kref),
 				 struct mutex *mutex)
+	__cond_acquires(true, mutex)
 {
 	if (refcount_dec_and_mutex_lock(&kref->refcount, mutex)) {
 		release(kref);
@@ -102,6 +103,7 @@ static inline int kref_put_mutex(struct kref *kref,
 static inline int kref_put_lock(struct kref *kref,
 				void (*release)(struct kref *kref),
 				spinlock_t *lock)
+	__cond_acquires(true, lock)
 {
 	if (refcount_dec_and_lock(&kref->refcount, lock)) {
 		release(kref);
-- 
2.51.0.384.g4c02a37b29-goog


