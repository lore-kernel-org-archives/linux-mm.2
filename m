Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09A49CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B026B00BB; Thu, 20 Nov 2025 10:13:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673206B00BD; Thu, 20 Nov 2025 10:13:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589026B00BE; Thu, 20 Nov 2025 10:13:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44AAD6B00BB
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2BFF13978C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:03 +0000 (UTC)
X-FDA: 84131328246.26.3E17588
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02AA912000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4qOD3wGT;
	spf=pass (imf29.hostedemail.com: domain of 3_C8faQUKCCkJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3_C8faQUKCCkJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTo30xRtk3dNAYk+WcMlGzrXIDi8Fd3AcvMY0oMy4/o=;
	b=AUZ9boniuWp1kJgTsxU8ZFk4BlkH3513G9bXaGnTdeBVqLh38fCQ8oplI+d+a7nKNl2+A9
	obN6+fM7e4k8somKHBcNUqwNhOnX70oTPodfXChPzlg8fJNNXnFLLlul9YTdlQO1n0Iy6D
	9kRxryirm2/ulhuUDrm2R52/3u+EuWI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4qOD3wGT;
	spf=pass (imf29.hostedemail.com: domain of 3_C8faQUKCCkJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3_C8faQUKCCkJQaJWLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651582; a=rsa-sha256;
	cv=none;
	b=5QjNas+0ps0xY7NPzEv+JUxdhklZoJ2Sl8OnYGDlrIm7Xa7Li0y6RorGlkgCyQz5IdtKPH
	ZQq9GxW2RK4/OjR6Qqbel8IOlUx3eOh4O73IOZGp93fJSxaLL2YT6F9NHk6kc/gioDRqEl
	xKaxw/us+M4lSDMQ6PaqFRcpwJ0xp44=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a11d9f89so5141845e9.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651580; x=1764256380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LTo30xRtk3dNAYk+WcMlGzrXIDi8Fd3AcvMY0oMy4/o=;
        b=4qOD3wGTqYo/tPlL0AAVGmuWFjc8s9Vj2Cqd6vS1GB8586sRjXMkJdCRELSjmQdvKq
         3uozcpP8XCDXYG7I9UPPoYkZScFFbsSupcOe89KZg+5jVCwjmfOlKahBVq0vhGIkESso
         mB4zsQ4E635PMPII6kmY6umBHkFkGiZoiyyszSYDPsqrq7dUGr7YgXHRsCuFcDu3Xhjl
         V5ayO3pdKeLwTgL/pgfWwHEyXihXnLMBpYxbIyDDdimAjRaJcoRTGLnWTG4mt1lGr9sF
         R+ern04WybrWJlNq8iHG534kqcoPXc9/tJYVst6WC3ao6OlibH2GXsmuqkIc44h9V+Lv
         HcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651580; x=1764256380;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LTo30xRtk3dNAYk+WcMlGzrXIDi8Fd3AcvMY0oMy4/o=;
        b=A+kOwCJx6QFjY2Yqw8RoQ8+l2zY/5aPu7xtT65IGDhwyP67byXWLBegG0RB7HGjDWa
         hMuA42Ac+E7KknzOaGIXejTukrjmCPM0bJr6Bwvmq50thqDF9a+BIDCQVtyeqPKG1CwZ
         3St5RnBFCpJdJu9lwGzbEueicKBtAMUge2F1exkzmnHRvDcgqXTYCOpzBH0Gt+zmF3If
         LTcOct5D5Xy1gYAkQFZGJB3lA6lTWxFS5WQyRsOnXb0IjQyjIW/ih1LeGEFwNrSIDwPj
         ySjPWbrcxtvOuuElE32duTJo8q/EFmIRTKVh4xPt7N3PArYUwzoXlRUFGGmeVTZ24+3Y
         qFOg==
X-Forwarded-Encrypted: i=1; AJvYcCWqOF+OoBOyHxEfTmfivB7goNOY/dZJJ2Y7rns+q9JirX82WjfXF5mqX6QTmHy711YLO55pDWY+UA==@kvack.org
X-Gm-Message-State: AOJu0YyV6dzGsnMejH+sEkrIf0Eh4r0wGor7igsIgs6LkDaip2Wof+gy
	0gpCWJZSkU3k44yYK6X8rJP5EP7a8jsCfZAkQIBNYfT/E7FM/O2nC+JkRy7cLDgHitjrEXBp/UL
	kRA==
X-Google-Smtp-Source: AGHT+IFrGgNPktKG3H23bhC9w6XQyJEAaYXs0SazZ2yQkYIVJL1b09kjJ5fLN+jez2xgS5LZ8SbpXS+XSg==
X-Received: from wmqo14.prod.google.com ([2002:a05:600c:4fce:b0:46e:1e57:dbd6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ec6:b0:46e:32dd:1b1a
 with SMTP id 5b1f17b1804b1-477babc1fcfmr26767175e9.7.1763651580311; Thu, 20
 Nov 2025 07:13:00 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:43 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-19-elver@google.com>
Subject: [PATCH v4 18/35] locking/local_lock: Include missing headers
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 02AA912000B
X-Stat-Signature: hqut359btb8wq3eiy6zcoi739i5wh8yq
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763651581-685416
X-HE-Meta: U2FsdGVkX1+nnCiJPFq+avPzyQrxV/d0fJhlNH4C2M/EnvkmUBBzBF4wvxL3NgIBiFmXz0rUVtOxY4BmkkoY6Pfs0Lx/aMnGO68PPzUccmZ2ZLHFWmmZigSqoMC5Owo03WPB9NFXxdxO7VyibflOLAfBA8QeVMZqngWwKwJzojAOEC0G/o2nKe3bg2IyZ3HSXZ/tDrXr4yarat9lPtu7psi8i5UOgsvzmOPVWA2eJYmahXYLlI/DdeX9gHzWqPPgjSQOg6TiL9bzpYCngXagU9vqpHT33GUS/MPYkCFbarkrlEQ0M0UWMz+h2PWBZ4r3AoAMtyZ/wr7rmzoR2NiUbgDFXxWEixxZ1ZBgYMX++A5kWFUdc9SKVbvQ0BAuhT90KvOD/QRWDQrsPW53kzWWlkgIRjc09NVtbyFPix0oDjG31zFT53gOoE+2nHYkZ+JurK1Tc//BTLa1jjTTxECIm44tRnkxC4nCNB3ccoHjGt5GbQYZkLp83HTQ3Ek/hZyHks4xolaIju3efTrfHr1HXXOhJeNusORWAr5tcaRjOlbrfWRx629f11aca00kkDj75eOTbs5vPNDmPeXPo3oojpgNoFKjbFNaCHm+nGStzN9FUcWNlM0XUKkw5K+Zcgb2VKKt+pAsk3CLPG9qlfGjAvFCaO5dE4bx/wUWCE3kk6LAENyNlZl7nu3Eb1ibAwJu8x58nYkonrNHpw2J2pH+OPEFO8+aAbJFz8ajhs7Fb9cjJwN9rXT257EFzFD1RxiDTAimQbaF4q80whIcNyDvUYG1I6Li8doIhKbfLmwuBneadudqUdIZo6zlp+AEAe3cuzF1ESyehEHRCBuUY/x9OEV5lrkdXRdxr+Vy6L6tJB5rv0Xw2Bp+/xy0gKSgATp2wzZ5S/n3RRiL7MyzCDLEletqbhGw23bdZRklzpKaLx7rTiiPyJx5yyT0DFIdir49vZ/o+b9jclzXhbFYfLE
 k/Wk+vup
 GnYpRfULadl85nDSU84yldxJpvvVxzp2O8QldC7vDOOGuTmkXUGURICwkCASqQ8IQl+cc0kGuMmeE0O3MU9UTTB4+nlpIB/TWsg9dn+qCMiZ0Wqg/wM4C96/qLraxFKndpMQcMi6ME5GIDXXa4qmSgksv7ExP/9SNtZdi6kqFZfo0+cI3+r3IT+6HsMuPcbwlgQdXrjC7vC+cVFQNJ9K2gAcbC9S+DUL5ZFk/fRIZ1YS+8FZ1OPXYNhc1blnkVHCPaRf0WYBhTFzu3ofBoLv4TV55pXh78Lct+mnsSGMwsatTAglDrjXYW1ltzE3o790JrzO2z8QXHOi8/oUN/7v2WUeUZPLDgmUDFAwi5wc2wjgU5vyhr7PQtbs1yL2UtmPbfxDJ9vrXlA1Op45NEvpbf77ukP+mblf79ir2HOZx6dxJQuUaZVmSOuMk0bSDu6ti0Qo5MQa3ywPOcSn2qY+0KXljXzVNwfZFdEf6TtSEQnTqVGnSqzFzrq/ZSpYDUd/qEpy2OW98QGcNGtegVK7sYOltTN0DcUTAHozx0RsZfBqhjPyqGo4Tm4xSxp7Hgp3MxTuBA4CHvqPxIPtNJmS+NovZDE6gulKf99y8u9FpQHOVp9ZGmoNalJmra+uQzkI2ljg2+ZSHyHgd6X+EzD/VVa25CIVFRT3mJ5zpFuvSPcVz6UhecS+IEEwApYihZC9VZz4KnuNB6WCP/kiqHehLIH3iHwrehPVW5cocrLyOx1tbYZetlwRMli4KjjhIoyeYzwvuYYrgeYh2xKL2R8tvcZCiyVyrIzC6VSfCRh2F6YO1Ogmp0E7gykaSdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Including <linux/local_lock.h> into an empty TU will result in the
compiler complaining:

./include/linux/local_lock.h: In function =E2=80=98class_local_lock_irqsave=
_constructor=E2=80=99:
./include/linux/local_lock_internal.h:95:17: error: implicit declaration of=
 function =E2=80=98local_irq_save=E2=80=99; <...>
   95 |                 local_irq_save(flags);                          \
      |                 ^~~~~~~~~~~~~~

As well as (some architectures only, such as 'sh'):

./include/linux/local_lock_internal.h: In function =E2=80=98local_lock_acqu=
ire=E2=80=99:
./include/linux/local_lock_internal.h:33:20: error: =E2=80=98current=E2=80=
=99 undeclared (first use in this function)
   33 |         l->owner =3D current;

Include missing headers to allow including local_lock.h where the
required headers are not otherwise included.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/local_lock_internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock=
_internal.h
index a4dc479157b5..9f6cb32f04b0 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -4,7 +4,9 @@
 #endif
=20
 #include <linux/percpu-defs.h>
+#include <linux/irqflags.h>
 #include <linux/lockdep.h>
+#include <asm/current.h>
=20
 #ifndef CONFIG_PREEMPT_RT
=20
--=20
2.52.0.rc1.455.g30608eb744-goog


