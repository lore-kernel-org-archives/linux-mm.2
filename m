Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4048D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CE06B00A4; Fri, 19 Dec 2025 10:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E2D6B00A5; Fri, 19 Dec 2025 10:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D2A6B00A6; Fri, 19 Dec 2025 10:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5BD6B00A4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF86E1310B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:16 +0000 (UTC)
X-FDA: 84236647152.06.38E1C5A
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18E0DA000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3laFeL2g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3RXNFaQUKCJI07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3RXNFaQUKCJI07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159175; a=rsa-sha256;
	cv=none;
	b=ZIgf9idDymvnMd40jXOWz1sx+b70nQL8Y9hK00eu5beIZg+yllfR9Qw1ws4BxuZKdNdDwk
	9KPi9lR7wzu/I6i3i4WFyBEae0JzBTH9KZmdRJZWgC/TQfDCSQ21eDZffP45F0SaOcNBz4
	niJ8t1jKRliebaX+prXpRiu8cNzBCuo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3laFeL2g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3RXNFaQUKCJI07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3RXNFaQUKCJI07H0D2AA270.yA8749GJ-886Hwy6.AD2@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzqxblqNylMZssrhkzyYMNb717UQfTl85zNKlM2THvo=;
	b=ug/a39s7U0vq7oh+OMjJ+weOB6xjTyh1Hn2gx1W72eJqKCAe1RJxyX0PR9/Kl7lZMatuSJ
	FLTQ5LENuSSUyV6opj+mRxs56ABRZ1ZUHTA9GztnXkVcwUr/h1afu7VdDFOQ5kaoQViwaq
	WWKFo7uZ+h5Obc977QK1EH4rRi3SxO8=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43065ad16a8so993131f8f.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159174; x=1766763974; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GzqxblqNylMZssrhkzyYMNb717UQfTl85zNKlM2THvo=;
        b=3laFeL2geO3NBEkXo89SQ8zs5oNOuD4YXwtG/wGHy2kwexmUzSeZ530/lm/t3Vhuin
         rtk3K5Y+iJg9f0gLPGrlc3ss2TvE7HC549PgwqYfAcjN6o9597GK0BT5lTKtNE3hI4/n
         w97dLOW78oLU6fQTMo91vu8sdQP9m8+mDQw/yMm89f8QeyO2ng0pEYPWnGSeT74qI8wc
         DZCyiFu5WMXx0dZejd0+fWUyidXrp6dwzr1NEPIAyAOFziIaL3yKZNnIq4h4mT22Gpcp
         aBhc71aKCQ3b2E3+FeHQ61kfRQgo2d/mX8oumajeQ/We+SeeacpJ1C3xGeWeBXKdLIWR
         fPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159174; x=1766763974;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GzqxblqNylMZssrhkzyYMNb717UQfTl85zNKlM2THvo=;
        b=rpv4mM+UgNgiaXnadkcszxzExdU2jxJi1gdmBz2RUwSgdYZuesJvtwHaaUqnX/CXLh
         R0X2hPYxXq5t4uFtYAjgNfEw1/pZIfwFs2fBgp/hJg/ALP/80opn29iWmSAJzKqrNJlT
         B7w3AmL8BH0MID6xo953kpxZ3lb2ISBcGKgm6qnA+tO7K99rj2iBfeT+Kcjq6FqPxz+v
         lbIr1T+/95ghQDGxePScD5QwrUo5HKNRsFjz2rkrG+2iMk+un7v4aC3IJ5B+TtPPv4qg
         u/hdlUH+e/vcSK9YYa56wk7c8KQO6LO1gVqNxUt1xx0KM4TIgcqjwO+hgcE/HZEfvwNo
         7YjA==
X-Forwarded-Encrypted: i=1; AJvYcCVeH1FKP6RFtb6LyA6ywGogGlXxFLmEuhRQYeUkNuz3jUB6zLl1NSk9/Krc8VvPaP4YxCpwRgHcDw==@kvack.org
X-Gm-Message-State: AOJu0Yxv8/V14th/9lABH5aPS6fblqPNEzj4EjtkQnG/9tMjP41NY9I0
	9s2MO+1LRGtuSIL3Tc0/tiwqwCaiNmnGx8lKC79uPUfU8zQFgTBFoMMPaZq/xVWncJUOtOhfJsw
	pLQ==
X-Google-Smtp-Source: AGHT+IFDBzha0VLOsownpeE3/oX+GYClWE/LTUckt6t3nGkH3udhxqzAfrWi3SLQ1c5sHOt4XQ+QWDn3uQ==
X-Received: from wmqn17.prod.google.com ([2002:a05:600c:4f91:b0:47d:1d7a:6d40])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c494:b0:479:35e7:a0e3
 with SMTP id 5b1f17b1804b1-47d19582aacmr29774555e9.30.1766159173561; Fri, 19
 Dec 2025 07:46:13 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:01 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-13-elver@google.com>
Subject: [PATCH v5 12/36] bit_spinlock: Include missing <asm/processor.h>
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
X-Rspamd-Queue-Id: 18E0DA000C
X-Rspamd-Server: rspam10
X-Stat-Signature: apc7xpaj174cb7zk1b453wui5xdnixkf
X-HE-Tag: 1766159174-225649
X-HE-Meta: U2FsdGVkX18cPrIoO5exOfY4IaYu3bGZnYUlhFpx6a+LP7JCeEXGutS2TTvKRII/vJOYmWy8V5GU0hTIc1Yb+IuYxYyqGbBU1bl0R6RbW0lb0MULQOewFy+PBpv/nu7I6yH4oVeBGovr0KHRiz8meemU+0kQ6w+lrUzMm/FhqqH8k8ftU9OXA+FtcwM9Pc2wWG5jUsvi+T0H6pEwnmB7ZxU+7j8MaLK4i1paIAzW67IGTGynkBgl629BqQZJuuH/MaXJGr+WhHnRjjfEc1hZ769dSB00q0WVOD13nn355dxuS/crJ8xl6toLkNOfK9DzAAM4Wu1FVkGr0RoLJFSAAiS5P/5Si1Y5DLMJ+T9HMLYQFjm7EL+kk4lPeWCEMuQ8h6Ix624x7nD7Qwl3/SR28Vwihwpdw7nfwtLgeysg0vkOedRTZZXH+JtftuZesL9OE1GvT25R0a92zEN58LAPy3ewYCIBheWFMrR23Gq2oY3yPbKNUI+PJS75V4epF/aGPtTGeDSZfHpzhjgqxbHrUIguG/+e4pF1naN7uU1m9qB7Lz2+LCejnOQEl0ZSwo1OtkK2UhufzQX7/4We0NkXbCgdbUI7ufi3a9fLQm6keOVlf7r4ovIpKsmcXg5uVNsMTCiIL7KN3c83vt2xCnyYvOVKYLGZK/SaIpZdrS2+wPInTNzomg23wn2pWCAIQNUCzt2wYxwitrDmIP1yWGPxPIHDU469OhdwgA6K9z/xh+Uas7aLEkbxqZXu4SGORgH7nZvIaAbKCTb0v9eu9zAzcj405zqdBLmJ9RUtsGfJg6Q+vUBJ/OvCBastv8HCbgI5axhkMWbqGoGfffE/nDUyxUdNcVBDMQKhl598kAPYudTuLcQtZSvm5rjbwBA4y+kywc+bNBfULxtqP01NQmLY8A1cfDrD9zvRrmGM5/OFV5MaLCYEl2oRPFL5iVo8YSmnEqZfLdOAGTcf/SHfpit
 WTZ7OO0d
 HshCODSt0u39xJ+ZPzHC2q0uCjfvxJcoTBHv1DMExnolvVe2z6F9+tRSloAjUgbm2w446Ci5x7+TYDGch5d2TyFylkoOkx2QrMlFOtFbllyMk+ktPGdZQwZANdBh9iYjLblD4k6UhYEdfe8/Ck41Zerhq+X4Wu7EgQIUjfBSVVRNkQY/jxJyaLFYsnVV83pXkrJIMFSZkq7a7bFEhu51cIWHrglILsywuUD6nC9tY+wj5wPBBDR7G/gVMhsWwrOeimXnjJZjIDFFLiJey5CclBP4YKXYwtT0Yrb347O6pjDVmkDux2qYKpEN6en8EvJie+tBmqSMdjC/72pu4vhwalfpCY/9n7L/EWS8zpWGWOtcJlcwhoq8SxP9rGgcMKUIuhnLM5zi23P3jPmOmqCqsYgHAUNbxnUY2zKuehIrJJzGWQyOLoea3yj9Uwl6CNlaYNyKEr8dFqItgPZji10pOywcujIdkW+R7CMOBn9JWO5wyICXVhE8nEoVPUS6/n2Ur3yxmin0u+UOxm24LGLFLSuTc9YXT4ignZAw95jB7TH+sFD+hN4mn7dqxZqyrd0dCKwZY5RJJJcAP7SniW50KecOI2Pq0ioXECbP+w5F+mgELmIB5Aa3VClrB8hIDB9YkvPqge7oulKRJvVskagxH0/FpbbR9JgG64jD37GjiUvPYiC1nBNaMpQB/5fUSd0qADObW8Q4WkC2cpL8C/bGv5ZssUVGGQxS0nLo4ovy1Oj9iN9T5ig1cQr+X3ReZJ8Q+IeXsmwMM6votuf3GwRo6b4NehQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Including <linux/bit_spinlock.h> into an empty TU will result in the
compiler complaining:

./include/linux/bit_spinlock.h:34:4: error: call to undeclared function 'cpu_relax'; <...>
   34 |                         cpu_relax();
      |                         ^
1 error generated.

Include <asm/processor.h> to allow including bit_spinlock.h where
<asm/processor.h> is not otherwise included.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/bit_spinlock.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index c0989b5b0407..59e345f74b0e 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -7,6 +7,8 @@
 #include <linux/atomic.h>
 #include <linux/bug.h>
 
+#include <asm/processor.h>  /* for cpu_relax() */
+
 /*
  *  bit-based spin_lock()
  *
-- 
2.52.0.322.g1dd061c0dc-goog


