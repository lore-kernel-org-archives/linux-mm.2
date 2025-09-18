Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A8E3CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0026C8E012F; Thu, 18 Sep 2025 10:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6568E0112; Thu, 18 Sep 2025 10:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32398E012F; Thu, 18 Sep 2025 10:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD0AA8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 916E61188B1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:19 +0000 (UTC)
X-FDA: 83902545678.06.8407191
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id A360940009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u29mdV4e;
	spf=pass (imf07.hostedemail.com: domain of 32BHMaAUKCHkbisbodlldib.Zljifkru-jjhsXZh.lod@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32BHMaAUKCHkbisbodlldib.Zljifkru-jjhsXZh.lod@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPOyraitAoGllB7BsvSWOoZaTAjW0zjsOFJLH9vcrlI=;
	b=kkoIfJ3PvRCPmDEc497CLYD3S0dUmBenNJSubhkn0De5mInK5oo7vY/ry5Q8vEtJvNHU41
	xjdAN1GlFJ2AhiN28jyP62VbOTnY/y5WljrkPP6GfqfQPD4QUEVXYZ3Aygo2GD1lbEr1ee
	HzwqT9GPQzhv6lg5pvofxHLF7pWA9GM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204377; a=rsa-sha256;
	cv=none;
	b=cZnR6Ek0zfyJkK+qZ1K61aaqi4lYMUW0mpd+LEv+dzGvskwtk4xUeKPpUugCR5E7iNuiaP
	XdygQenHsNOxXZqnt81fVWjD+RitYfItGCcfnquMY2O5H0Mf9crkcHBNow620OiM/fyqp7
	PpH+uA16Q4ujElsVqyhX1mVV5+8Hx8A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u29mdV4e;
	spf=pass (imf07.hostedemail.com: domain of 32BHMaAUKCHkbisbodlldib.Zljifkru-jjhsXZh.lod@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32BHMaAUKCHkbisbodlldib.Zljifkru-jjhsXZh.lod@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ea2082db1cso229638f8f.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204376; x=1758809176; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YPOyraitAoGllB7BsvSWOoZaTAjW0zjsOFJLH9vcrlI=;
        b=u29mdV4eeo7KsKyfQp8qWvY0IE0R6Gg58TRaACa8RjSsNg8i2/L4HwtlIB7SvRo1tA
         Rlxyy3HJ7ogGhdnk7/nD3vw1LmMtB8okhdtilbFUs1EOpBaZUTAibAZAPblBXK5OPXJ9
         Js/pgcfZljrpayKUJZNxrR21B/P/YncMSdxzIdYEihiSHlEF/DF0ybv3kemiffE9AgaZ
         fhRbfypCnrHC/3wtQMbtOU8yXTm43EVeQ9We1WMK3ShKokBqVW1gmiD0QTE7wLskIaRV
         gLkmqkD6aWtYYPuSw+kPFTbd3S5feyMOKHJXyjNdoHX0gJAnYpRyJSKtiL4ZQjcGPdn1
         Nt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204376; x=1758809176;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YPOyraitAoGllB7BsvSWOoZaTAjW0zjsOFJLH9vcrlI=;
        b=Ien9lLvsD3JcZGKcx/zdRBz4L6CUpOPuJUjMomIKfA+8ggux5/+W+b8HVz+2n5iN+2
         yroZBtP1jbJuq4ObVnIJG1SvjoR35PN8ZiS/C9RV4kzndwRuAGmUNzjvkXXIGpbwH/74
         UpBnVjWUEGFuIqXs0M8Flasms62Jy493tV7Avyg2p94xaQF7/5nMMc/Ytd4pLuKIz1uS
         3IRnibJG271p2rqvgASlv3fuspxNrELvsztSSTGmQOXN4ws31o/yKNR/gZJi+Qm1cPuD
         mamhrSOW1VQjz8qK5N5JXEIs1Gr1Bx0b+RZxbelyvSTnom4t+VMLvgiEyo5n8GVYr+o/
         jvwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLzIZXVPAO7ISa4rbhzdBx6I0Ba+KBRbhBW0v8l3YheV3WDIvoZJ/H+Yl+NH1dN5MTjvA0JGtodA==@kvack.org
X-Gm-Message-State: AOJu0YzI6JiRztJidxF089JXwI8eAz3LP5d8tJnB9YD6viTqo8/16edD
	7OQH4qgUB710YAG2pJ5YjyrT9fz9OYBQhHoJbRr8IAN54fgROxaU9lIpp58/pEUVtJgjxlsPU3S
	mZg==
X-Google-Smtp-Source: AGHT+IF8aLIhn34LgaGAnLK+69nAB2mIA60sJ6OJu7Vgj9ULaNgMfzBmpj6zQNDNkmaJ1Aacoswwf832Yw==
X-Received: from wrd21.prod.google.com ([2002:a05:6000:4a15:b0:3ec:defc:12db])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4284:b0:3ec:b384:322b
 with SMTP id ffacd0b85a97d-3ecdfa3d37emr5318506f8f.46.1758204376079; Thu, 18
 Sep 2025 07:06:16 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:29 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-19-elver@google.com>
Subject: [PATCH v3 18/35] locking/local_lock: Include missing headers
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
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p73k36wwnc7tbhcwxt8m8iugs5xb54u3
X-Rspamd-Queue-Id: A360940009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758204377-537769
X-HE-Meta: U2FsdGVkX1+w6GVljCul8yUYC55qrl8daF4o2k1oR3W7ZksH4yjKjKc8HwFpOYXw+fS+uGFhPcF6wkGSSOKnuXCuZce1uxmi1wRAYpRRMqo1HBOgewe/bw5kXlfzIbNEJOdWpeni+iwRuxV2doqnPNUkJ1JundKf+SN+tn96+6kd//5LulAgA7xMXpxIrJ1UZuQOJWyT0ueQT34hgSOlcPu70hmfZG0jnwWufx6gA97LB6TGL+ArcFks7TuiqwAXAGlmmXijeXkBsXpYcwmwX/M9ekrEFERxCJ1eukcmjlKKIME7ReyxL89BE6DsezewWcRuXc4CdEXkKqc3FDnz4axez8Be/9eGz2+dLH9thJ8x6aCyGnN8dVO+Lxiui5p9WLM6uDSO2oChBUe0nmNbHd8pevnP7gWqwLYTRU7GidBjKNeJ5A4eTVB4PmHZ+Eqptfc3MyqwUcRv5wtx8SdPSknnlij1xJhqFwf1UC/QCZjfe/ZwxOfrGt8NvugyzOLpSeLEo2t6dNMzjogQY2Uvwa2GAra/jdXYvT0KExg+sz7ZsUrd3lQdhyqHrX3swIsLigqzUAk3OkUXDtzKbzqgx8gX7Lq3DbLShjyk65kwOK0N1In7NaSr5eh/mkxLugkw2W1LgT064bNpgpqkSuAKunnUynQSHLesLGHfrDtIO1y+mB/UYXpN+/lOQuB40Y4+N5TWTmE7l9RN8CaH50twoVHQi/ipBeiLwh4KNx/thC0TW07NrGoVTnlq1sqoXA8duO01gwOKsAIH+qtPHp4R0BssokOXZfdxZN8gQEC9ym7lcbzM+ZLJByAaHxfQLzW8EDCv0rQOXCFWjKDX3q2QZgk/Qn4uQPTTcheilFqv32+VY5Z1nuPX4+4t9rSPSmwtOhMgIvWhpiTeKMbZCgmetJPwSgNgSm8jeykCEWPJUackWud43JEZXDRZT15F5PFVGxnOWbLvsEuw3XorMZH
 CjKmC1xf
 VThvCSeVc8IdA/W9BiUTORaTjVHBoznmg8PH2TFgaZqHS3frNSptLDRijfPZZiKa8Lf/y4Km+2OW8qdIJbsWhEPo+zt8nFdiU3TsLQyEzD6sOSnldm2l7yyHNGDAMn97FI3hlqfP5REOndR+0/seNGBasrJHu0eLVCZC16gj3RQFZ68Q85Egv0wy5d9lpY0kR9mlpvBOxF7UpiF8yCda1Hebg48Lm7yIZlxQ4uTpR3mUmO5O8ewce1wES/wY8dinywlmSwwGg7JW+1JhmKSAyX70GXi+wyxWOl3NOOYUYr3S3kSuAj1CPEKWQXBzpgAaJGCkmH3y4wlCFZTcWu0khqwiMXunDV+ENgT1FUa2nGKMEzhBXuKgaMpxxtV2vDB0Y7rYHL11vqphnihxraED3f75yMY4A7y+SyCc0H203mTcySkfvAsAtVwCrzLIOV5PHtkkz2wwymo7dWRo2bQ8xjdIA/zhjn85Z7DvGFTcsjGDPAo/O2HU/IAG4ZWeCZN44S2xAzJEoGrqHA6ZdeHSGTRgdNGeRg5a0NcVWYhDoNvxi71k+IHARx/vfRYIJ8wm8gWfyCun9Cg1WbgyWHYrwUVDE0lgO+RXJEkpLXJLdpY1rA6FDSRC9P1a5A2L4RpUR26km5PxWtwxkmq+un4OsvW+VZpG3WLH240Ykb60RgJ7zfiQ7wodr+KZ1OrhA/MQi2BzPviLduBlbZdGNhNzgRjBWAg97vOWyFZXJ
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
index d80b5306a2c0..4c0e117d2d08 100644
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
2.51.0.384.g4c02a37b29-goog


