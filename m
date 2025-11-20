Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC8DBCF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190C66B009F; Thu, 20 Nov 2025 10:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1683F6B00AC; Thu, 20 Nov 2025 10:12:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E696B00AD; Thu, 20 Nov 2025 10:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBE746B009F
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7A1C1601BE
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:26 +0000 (UTC)
X-FDA: 84131326692.21.BFF85B5
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id C4EF020019
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UUIkPSd1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 31i8faQUKCAMhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=31i8faQUKCAMhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651544; a=rsa-sha256;
	cv=none;
	b=YlBikMaqMklKlWun2585U7YYl3kcTD8/QOyGOuSdEURDBHG4wuk34IlSEra44RmWSlEQ+s
	F0C7GQO+8uYsctyWssJv1MaUVbI/uLCQFtEYaw5AcfujFrN9i8tTfQYSSb5NJgNQANXUCJ
	EaR8okfyzUXld5TgTAjfc9C9OK+yFTY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UUIkPSd1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 31i8faQUKCAMhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=31i8faQUKCAMhoyhujrrjoh.frpolqx0-ppnydfn.ruj@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhzmKujL7bNVWf02jAjaSOrp3urplpV1YekSTYKrBiM=;
	b=2IlfW8CyXcunRN2CmGamKKgpodeXYsOy30y9c6hfn9jigpPRoAD65DDyeLGKG44XitjJrx
	sjKBC+YgXQvY72Hn+b4YoVH5fVctlgGtJdSnVx+iL2oLEIwDwF2Na77SB1gAmumUV9ovBk
	L0LtMIezkz15gh851JV2zxp9exhXhks=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429c76c8a1bso1051572f8f.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651543; x=1764256343; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YhzmKujL7bNVWf02jAjaSOrp3urplpV1YekSTYKrBiM=;
        b=UUIkPSd1yW/a/krgL7Mzrdvh/hO0t3wba4Umy8Jd7qnmGc+WoQHJ9NgGj5yZJvTZDu
         Tvccs3tCO1S65qEwN0TtaXqcYlLTS9Ip1sFpmtUgILQ/M4Z5UrHHN90eMiunk6o7fiqm
         EjVLRBKZF3bxQ2nR0mXiAYqCCg+uu/ZdmAjOivUS1YQmSxo/JOJz518VYrVvP3Ede90s
         Bc4zZH1a8c6wRKWGWy2GFrk55ZkgNNhrLVAq3U17K6im0zzPhJk117jRfgWoZ7mQHc0P
         h7mMeo1XuFcolnrpEi1hL70Z+6ZBw7dFcnc9Vz2NEphTk5Dw6dgWW6LD9B6begn/FQhp
         naug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651543; x=1764256343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YhzmKujL7bNVWf02jAjaSOrp3urplpV1YekSTYKrBiM=;
        b=mtcq5KjDpu55rX5CFlbFq2R9FYnQJNpZDN2fD4M7V5sw91Po6c5vSxR+AebkRkICqE
         MUCEiK/7As8CmaOWz5ap1nJmrG44eBqqz7i8i/mMZgEOD78seZAGtSzjlv6rBN8FhrjP
         QVzLKqeg/KvDAltfy5bki9sKontIH/FW41KiEHWXBc6/nDHpIO/SESL3ZlpuMHRRmz9f
         ayqt0MbULDwoIEX2RnpcCXNouutFqLgFQc2ynsQcjHrMEOIttFrhHqNrL0wqnN4LQAgV
         rlC1SgNtL3q/SLngTbuBw6A05rXsZ3zJ3R17/+1Q+ZGLEF36YtRPDhDC+AxlGPAYyWkR
         hsRA==
X-Forwarded-Encrypted: i=1; AJvYcCWJRzjJAhJafWC549OQW61oowKkbdmm8I437G9NTEaBOVzYb1fOvrqzrWKMnh+TOyx6mp2efOVqWQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3lgZVtIrRTUKeJkPPyupVF4N9aaE4L2rJ0kLFiRP3bNR/crBd
	2ly1jdcAcuWLB5jUB9X5RoUuCjgloXXfYk9K/3RMIng4/1vZWWUy+vbRKIUeL2wFwoflU8D4vzB
	i4Q==
X-Google-Smtp-Source: AGHT+IFL0EI2FVZUMy6GZbaXFPeZWxMdszC7G+QJPxJYJ5Tt54juOMlly5lP2pxtgOuHE3Qi1fA/jEG3bQ==
X-Received: from wrs17.prod.google.com ([2002:a05:6000:651:b0:42b:328d:1994])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2287:b0:42b:3bd2:b2f8
 with SMTP id ffacd0b85a97d-42cb9a603f4mr3376737f8f.46.1763651542984; Thu, 20
 Nov 2025 07:12:22 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:37 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-13-elver@google.com>
Subject: [PATCH v4 12/35] bit_spinlock: Include missing <asm/processor.h>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C4EF020019
X-Stat-Signature: dqyxy5s683dpjex9r59p5j4ti4gt1chg
X-HE-Tag: 1763651544-178429
X-HE-Meta: U2FsdGVkX1/8Ug9FCrdclufP33yY8fb0M/t8FvgJxxGbi8XJ8BWMGT/UKAOx6I7Sk/ZszslMdTFJYxrgL2kZlPFpU4HcDTOX21OCyZKfaS2NhpEK5ucimWfjwJY+o77nlQyzm0nmXitGvm+r3GBKpzzMhG9fDLXdz54scskEZ8V65Zvy7MiDKQ31RA/aRJPnEqt7yb7HRE48rwESSIrmnYrBzL5sBxvdjPj718bEz3oHPbyMxdKrUQUD95IvLfDaUbNRAowL+7qtvPSqerYLwZq/+N6Q41EGWZxh5ecUIjBwaMmHqodO5niMIDucZYNOy037E2GtLC3rvdrWz4lhhypt309n9O+pTLgQzRz75uUa79reB8N4HNZ/LecN08E7to9EneTlDvpaIWiAXRwEBV0ktJzlNw9+ywiokQl03qEHcGJ/XZHuME+u604clffhURKzkAHhha0f47IMrNvM6stUo2IP9yxnLsXVxeRDjJkyVIiSTo0WD95wbViHbcTESJPcKz6qInVagbJuyDAxp/1metXJ1Kyw4pOZvz24r+wrLxQQ/XUbLnSmDCr+4wkPthK8YilFNvo7Dif8vAuCsEqZM/TjpZgWiYsT2ijD6geyA+FI2tAQ5J1XvNuVvoWOFjUzO8pWh7S1jmiMivcbvdfKN1jGspiNNjmUcz2VdIxj41xotzgMBiGLt4m0qYHueILWB0sTKiVTOtzwt2CG/It5YIZRuT7rLu6t0k4PlHHFaeaFZuNjkOlNtQROgycDekjU25SSqkMGYKVxlpIvpaxeDRWVRfnLZAdTmnNrMRzmDFZ82C2mLDECcAESS3gptXWfth6pmuARmScjLeFkzQVnyBGgFF78py1CBPx/pDtrW06XdcaFqXS8B2UPUBo1ry6qY7V8d87t5RzgKjjy5RkA06xb8x5RzHYU5WCoQyDm7P0TA/s/AbZ1rbb0zxzhfQF68OvW8fcQhH8sLtR
 RpjLLlFv
 26pv9Ke7lTJI89uwe9ce+eba5tpenazZUGzhlUEFBtKGFSVQ2D29s7CfSXlsUTDCTFtImlyx0YUpBNIGZO6DLXStZbGQ5auSk27LuVnWElAZpJscqKqXNjMuJazJESxiBghMZl/5KK8/9HwnlSTOWh19QaS29xXEwJQG9AHhzhXLRlMe+nBj17/2fa+Puyj0JZtr9EnR73iRjCvANrskTDLzyRdu7W7ehQvxQ0mLcRazCw1kwjajWJ1OBfsMeA10K/7Am/JrYV5rOQK1bWYZRTZCElhe7lKA6l5d92WXgovVikncMLbXEeVHvAbxrzmSOb43H3saPfakokAhiSU4zidzMyfsMvsKoVgTI74gZmZ37KDI1tC+Ag2ce3Pcgy/d/iEh1yYTciNqBCzJz4bg8ZT2xEL20GMhclGADu4iK3stDYIy+LKLQnVJ5cNpj0fKYML6IXA133dEyKP8XIhGAEsWFVBj4GI/xJskJWtBTkaol2HIVMTWIyfhAmFvYjA/nXQyP/Zcr+8Rji7lLatFF38z5xMIi/H9LVlSFB+wwbZ6SSb43ny4coQPvOYeqjR/xtvgrqKbwPDAsiHEbFLZ2SCCGyvKzlPAPYEijQxqBUyQ+Gy4j+AN0RRyiMI1Ya3dOOEd+tXLKlAOk6rq8YXUrVXZ3enUtEk5bqiXY5XQFvrVDEObmi9TMuX4VJESIY2FSGPQed/Zs9JsBlnvra2RHckZ46LvnyJEGzWRf+uIEuXWjRZC9m9q3fBDgP3fuYEOsfzZF7jwvZXOIOmiccqsD2MpmbKmfl3ckakk2WFuzVV7m+XUffZpsIRH+nw==
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
2.52.0.rc1.455.g30608eb744-goog


