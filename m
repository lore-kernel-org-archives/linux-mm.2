Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0F7CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77B6D8E0129; Thu, 18 Sep 2025 10:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FAB8E0112; Thu, 18 Sep 2025 10:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4C98E0129; Thu, 18 Sep 2025 10:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 475898E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4EC8139C2F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:02 +0000 (UTC)
X-FDA: 83902544964.13.791DBC9
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E9AE1C0013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f0zCFuS4;
	spf=pass (imf21.hostedemail.com: domain of 3xxHMaAUKCGgKRbKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xxHMaAUKCGgKRbKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lBqaGhUvOv+7EeFvUiY/U7KvKRahgMMUHhFj4QhTCc=;
	b=pcDwv8be0zrTlpv7+/pFBEuuLE4z6A2sBp07XSl8tBOt5x1bazpD9ZMhLXoP8y0o0RUPSn
	7OiGJPjApcyJbeG7bgfN8lnzarIo/HqRN4YEsjo1HB4pNb0AFA7DN+YOOE+NRoRZzNTPVT
	WurnggjyaDYEklmzRcAgzTqmzCn3ysA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f0zCFuS4;
	spf=pass (imf21.hostedemail.com: domain of 3xxHMaAUKCGgKRbKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xxHMaAUKCGgKRbKXMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204361; a=rsa-sha256;
	cv=none;
	b=iCJi/zmMqODeNVY1sFPX9EUsxWGlCSnYPxVwWn4yiYzKO+si0/rT8z2vKFm6GGYvTn7pBZ
	qJWOEd7w8adZLlMkkRfobqa1RWIVJd1DWka0Kgo20eePrV3PAQVPXW4VHLaifNH0cwPltg
	TR2/xWFZYOlKUwwbKcAKIADd3F/3rOE=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ea1550f175so474990f8f.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204360; x=1758809160; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5lBqaGhUvOv+7EeFvUiY/U7KvKRahgMMUHhFj4QhTCc=;
        b=f0zCFuS4nl2RRKqhD1T/VDXYa8viShvthmpUYd23+ZanURiMDoG6AQAKbdWBuUh65a
         lw+p6VhG5Y9VKSGO12b24WkOnAH3FnA5EBgdqas4iFiWMP6nUDDfM79Lvkv67ORhO1PZ
         K5HT21v5/K7q1Z8gsKHrp0rb0Np9dpUpvL6RrFVpBB9MZOQDxhMFmBE5SXgkoXS5S40p
         PIHssevQr9oHKMOKb1sWk9uFYS6pA7McDdqxnq2lTyrInN2Dk+yGLoFZPZ+LLUF4jzlG
         C+nlEyJg7B0ocACoR5HGGTmU3XC752iTmoFXZH3po/LrxpNP+acM8RWKukl+TH6JbpHf
         1MuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204360; x=1758809160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lBqaGhUvOv+7EeFvUiY/U7KvKRahgMMUHhFj4QhTCc=;
        b=Khy5p51I2wpvrcXf5G3+5PcpZ6ODSMnsFPH5xRKo8TOZvC+k2uddQHWdQo9gKkAGct
         eAohNYzhtPyPvxgiMJOvQE7Fd7861B1y4ydgRe3Ce8/1isDzChFfMwOIy+T3imLEBjPs
         4XFOwFq8UXj9+XwLuNeaf3kdlfOu6t0W0qusKGGfZp6SxCvjZlmdDKRPGLz1YUnVZBtD
         co1Lg3e570XFyd+VlKkCbBFhBMG7gC47pUHgiSmJxp87XoHNkjnSWDE6YoGCfObSAp2R
         cupznBiv2Y5jotLiOqY+dEfzlr2Mf512HU14G44Mh4Jq4GLPzZPyuMSsHTbFpxMJq+vn
         GynQ==
X-Forwarded-Encrypted: i=1; AJvYcCU35VwWUWDIcpzaxctNaZGKYBpcYsgXJflj7382nhmXMiJTEwp628+jqm1N3b3TSIBaQysw7G+0Zw==@kvack.org
X-Gm-Message-State: AOJu0YzFr56MtvHtfDLFGIryLILAbB7AiboJo8yQeAKulguqNiUZs8lz
	r9l27lIyWZRJeU0O9dVn+5kRvTkkOxMWpORVaju9TRR47P/eq4kLA5UpUMLXhPWuikQprd4btyC
	8mw==
X-Google-Smtp-Source: AGHT+IHiULKUOB+EsrBDrVl5HZcjneDq5C1ugpdpG+JWPfxVb71lR0xGZgLTOsEBDQp8WA+TeuGcjvm7Gw==
X-Received: from wruk7.prod.google.com ([2002:a5d:6287:0:b0:3ec:da84:10a4])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:40cb:b0:3ee:1461:1659
 with SMTP id ffacd0b85a97d-3ee146119c6mr1267126f8f.31.1758204359630; Thu, 18
 Sep 2025 07:05:59 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:23 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-13-elver@google.com>
Subject: [PATCH v3 12/35] bit_spinlock: Include missing <asm/processor.h>
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
X-Rspamd-Queue-Id: 1E9AE1C0013
X-Stat-Signature: hn9j5gi3o5uefsgrp6sk8bjqxonqgcp4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758204360-541175
X-HE-Meta: U2FsdGVkX1+DKxEnNQY+gpBQPBThpIS+RhvLRMZsHQKHS9JVciAtqdPIkyQdYx/jK5w4qbl0pHHKLpm10oQ+k/g3eIDXc/BFLxnLJQpTwz6aGuAphF2bgebT5Q+UJLWrhLb9tm6xmeFegjPdo8aDmdUsGMIfqswDZxuf98h8skMtRFyX7Ka8qqsCW9RcQuVs8/J7YkklEjf9i70UVXRkoHHFqZR2nTHF8SyQ/TMtIReUED1ZQ/x6nSdt6UJ0IgohZie07xExmj2IJApC5SA3zxXKPWwes4h4aEzfKggHW5bkmu8cHor5YxDklNdiubfRLh5KKmOWN4PS5eA9/IlpZ3/dAje+mY2GYxG7qBnbpih13LXQ/kBaAFrWnKUkJ7HkdSo3wQhF72CfuIOWAXqy/bMBtvSiKugAfphLYXSbMoNekSR69SKgpU8UXA4ifFImKduR0IkYQT0EPB5aWmX8M4bzxElMr01QPTTu/XcwDSyz6g6mmXlqXlLclFx3YfCvvwyxwjgeEoic2A34YobBtJ/sZkja7ZogEWZ2KWYarzN+FagfymQf2tmjMEu9e/tBc8ML0W20fwlumTm4FCk7QTkLK25OLoz6ITnSVBnZL2q7tO+4+ombo5Cta6Pl4UBXPHqfIwC8GsgwWcxnyB//S3e8jHCEbTyFmrABDwSjB070N4tsj9O5T1Y30t/nwnTYytEmkVyavlda7YlWMlDOwMPom+6nLgnX0+T+CjeOtDx00Q+TWuxvo+dtqxxR8xJbRsVh4FgyIgzC+vpYFLE+ilMreug8j4PktODqBc9nEnYr+RUBsuo7k38U+QXTjC85dBg180OpbtqxAZM6nVB+eWF7SYESTm8Shvn5aDgB37MXoMQjjl/myhWmX1hVTY+MDStGkA5PQCm+oXN6Jv/IKWJXZi97FbgBDxLF6TKeB5G+5p0A7gXeKFG88Z74xlRE84OF4n98gd1Dl7Y1cZB
 dX6eJoiF
 gHVE7aE1CIaCwZaaWdJ3wehlTZX9JiItYwft8NmwECQeB+ewimZ795dIyZQap0hg9G5guDMtaf/dS+XYYFRlLoRZn58ITGS6yuFIMsVVug+CY6j2f3ZvpeYEWVaevur9pKPbVe8SSLzGp1DkYKBVYp0RwIKJ9xeDVq07ZgTV17ncv5VfM9hZiCbEzpFjpo71zbIG01oFaHK+enGfqFs6wfKIkxjzBk8yfnHTzARIoZ44zyfHy9cWpJirbFUlYiVlG+GWKQcNpK3brkfavhAQ1NSd13mRWYEOGNjZ3kYT56IGVGgxuTkRZQoqOJ49Vdh+5ZsSHSpgliacgeDZcCt6LgAPreKDPPKVbCxEMYogithrYMs9PuKYDpnOmIY21WF5Tey/bOnaYXJfvv9I3GwlUOAd4TQ==
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
2.51.0.384.g4c02a37b29-goog


