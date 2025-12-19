Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885BED7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39246B0096; Fri, 19 Dec 2025 10:45:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5F16B0098; Fri, 19 Dec 2025 10:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06B36B0099; Fri, 19 Dec 2025 10:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF07A6B0096
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:45:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACFDEB8160
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:43 +0000 (UTC)
X-FDA: 84236645766.11.2FA7D96
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA59B1C0019
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f+rdcE6v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3JHNFaQUKCHETakTgVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3JHNFaQUKCHETakTgVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159142; a=rsa-sha256;
	cv=none;
	b=L9IddD1+AjhTPSr7NVBQyA8Q0Z9WKaK3eWkL5rMz1wDWZRIDwzDOwVXOnQ3T1GvuBSX5Pa
	gaGz+qmGCUWIbwKCooUrk6Wm7kFg840qy6W6jz5bstWdgx5gDmewJxJ3gZEEoBIfDwfd9x
	En6kJ0QdWTS+v6NmiDQn3XFvxJCFdMM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=f+rdcE6v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3JHNFaQUKCHETakTgVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3JHNFaQUKCHETakTgVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cp89rZHQypoAlOCNHCyWU3ytuEytNXkoLr0IcNjmOds=;
	b=iioqT/8VPdFiTWxGoSj5BcdFEZi9gFkamRCX4jEyylUUSciIUHN9Wb+YNuUvSfWrjAWpCc
	D11IcjxVUQ9FFyoXhjQSMZ0eOgPQQprDRyfZDC2fD9Gdnbpn4kEyEvTO6R7G5zRvhbSdmn
	MOjjjbln27becgBMLxmJWRvKDH1cZYU=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779da35d27so17887145e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159140; x=1766763940; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cp89rZHQypoAlOCNHCyWU3ytuEytNXkoLr0IcNjmOds=;
        b=f+rdcE6v/M+5Lh4ixU8npDCzsCFMSarZ59wEXW6EEYbMmuxTOXJS6MqSXldH15kUBr
         16jWKAeTIVB2z78hh7fEoBJh1l8TuvLftqEzJ5M9Z8g38RCJgqHfzOlgbxYywpP4ZrqA
         gUmAdiZUZ3LeBW8f/kC/w/TMJJOXeTxXMwUBMJ9rut9LjsoUPmUWo3lttjJdbGkJMGMn
         FOqM+PWnzy0qZu/I9W3st3GSayZzajLn1zay8KrQ6MQlx+o4qir4ZyDH1m3e4QwZzIbq
         3ZquvnAoQb2JShVk5jZlRaZtx2jXzu560gY6rlY50xYpmAI0THU2EMKWNOJSFL5Rv1VF
         Mnow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159140; x=1766763940;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cp89rZHQypoAlOCNHCyWU3ytuEytNXkoLr0IcNjmOds=;
        b=lrjNZ5zHIOivE/CxKEqmVYfiHRAzkfyqvGfn8ahKNuwC35/u8fbML2J+Z0WvkwsDmD
         C3QfISWj2hPRNO6P6/JsLxMaTOL7kDRLu4lkT/N0jG0Wtv4vTeyJR3BrFRxI1xpATrg+
         IvmOt7VttYBkxZV7ikeYY1PdSw8IWR0CdjeSuEU8pcT3tmrAQb1qGZf/myytO0cm9m2b
         V8QPgHwRl+z04ZM+M2/JZeUM1vRWW0wHwBkrdauol//hrc/wcJpMZPFRsJ2oR9rUZuoJ
         DRm2Fxdq9wRzYJNxFrMBd7LqcNaFWRojjvTSZ/ux4wAgwKjDb0+rxUQH5YXNvqb6eyeW
         Rc6w==
X-Forwarded-Encrypted: i=1; AJvYcCW5EPi5nN8kTMokN7ZFV6lVn6apt9kMirYDe9hKr1YOikzIKjMA9MpaPvmikUA4HWOQlHSccTIqTA==@kvack.org
X-Gm-Message-State: AOJu0Yz1S37rGIJiYHKJsFhyRufOrCkVSIaCEjEaILBruvpHqLspXl8l
	XpJrBgSHLrkAN1d73FbbTLEwnlawrQnNgEFAj+bJLjaiQyPp3morIGz4J3rDyGAJ9VIi6ihP9av
	ZXw==
X-Google-Smtp-Source: AGHT+IEo4aI5AYzB6mIv/Q1TYzZNn72eZTN+KjN0BRtkpQb5xaIDLH0+DGUI6xvUKW6b1Bpd8Cf9msZmEQ==
X-Received: from wmpy33.prod.google.com ([2002:a05:600c:3421:b0:477:103e:8e30])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a010:b0:47a:80f8:82ab
 with SMTP id 5b1f17b1804b1-47d1957f71dmr30483175e9.24.1766159140325; Fri, 19
 Dec 2025 07:45:40 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:54 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-6-elver@google.com>
Subject: [PATCH v5 05/36] checkpatch: Warn about context_unsafe() without comment
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
X-Rspamd-Queue-Id: DA59B1C0019
X-Rspamd-Server: rspam10
X-Stat-Signature: xfap1xy5uprigygtgkndeqnobi1hais5
X-HE-Tag: 1766159141-957320
X-HE-Meta: U2FsdGVkX1/kWdFP2dqQqbjMa8+1TW6opXMYlE0Nlz9QDXqYjK04RjiMRewJKJ5AdAYJ2xszsfrTGwBBnVozDrkWgaidEeYQLfNfeu3XMdtg348SDRBkz2GUhpM/oaLdRnXq+j5NOMEj3gFdczgpgD4qBsK18tARA91JN5YGhMiTCefjigPzQpVZwczLLxFVvnEFz4+UDBs2+Drl2h9EcV4G1w1FUwvEay9e3j87MK96fCA1sl4mT/l0+TBYqpUJsp/mG8ZzXrmkLpIZXQR5etOXTgbcxPynbvy0Zca1P1liC/IXLhspoImv5mAls5PuIjuPkmNwfbSyi2f5EsFvjEAMsbE8FMgLPu5j1+n0ucjaG4kMmzt5gEcJXlrYK6RN4EfFMrpWo9pmii1UDSq3lQ3/7YUYFn7nReT7ZNXGljyT+tOUAWTsD7FjVSk7gy7Vqkju/1f5wH750ip1pYpd4XC3KNWJE9MT47Q3S6dkyJofagEFoUHqGD+Vhh1okUBDUX/O/6C3a9iHGIbezsVRPlBpDhoYZ702dtpArpMy2zYjbKqxzsA/+cv3NDrHSnDJIplLTiaRovEECwwyv0lCSm1uNhK7vpVIOSU4gFJnK7ef0PAJPZoy2wQ1OpssctOUf9KOllsuXRwl4adpCVHeEyNYPd4PhYLMnRdF1bkGFPqND93BL08My9m0G46O/HTvejZcxgaOtFGsIdGLEtxtJFp3Wm6t3y3sk9fXnlZQJ1vhhXIBoCQYRTePeTXYRTQZHCTkw8fuBhfaBN6ldz5TUcP8E4rHWz30lkaOgPuoQro1m9HkfBeOpmho5DhjYkS6b9LVEEG+JJYEo6HeCWZ5BN8ttzsF6ML3FSgfXgHxbtJzF0/rpRR4ApWDYH4t34pjN0p7iBhXwCYIuDLXsFpKC5ruhZbh6uZUSOqaKA99x19fplCYwXvwFjq3lVDWO77lTrd2qJwJkFb7ApK3qiU
 ysW0rTNK
 d7R+OTAEu4v8o8ImgIWwykr7whQ9QtvKJDcdYtKaakNn68qyZSNLZuQ+JqUhZbaGpqVZfp+TvqDdNZhnWzuOoewVdFXVp4K54Gjf1dCxnr2F/O0uJ/U3nOPDZdeirLcmiF+cAUoOoAlh17z9FsZ3QfFu2nUzc1/5+odf4FJ4cUuN5bPe6Y1nG+JWXQtTqL1MJ/qXzmEwGzDuXEQnROFwxpjHbrUQ85j+Y3Ptp5WnHmeh06sKQtYHrGm8yfPBawLNkHsyT7cWA2EDaJZqgtEPbCNflFj9qe3AhFEAbnUT2Gj7l7KsLAP/Rwk2rjEpx+D32iMB/TNweFRcW5u/GtPp+Q9lkHmWBhyItCaoeTld/pUgn4VhH0ji5P/ldavokoq0DvvQ5wNOekwIIdnUxBiqWjsTD+Z+0cV/OMmipVwPj0BIVapPcNHg6wF8Idib1iNZ8HQG6b0gCOaT4sSjzVWXejbvOkcTnEUGYxJStCjFRUhg6tT0WwWIhTg+rctjJveLkGxhWwyHo/FTR9/9n03I8marxkJENMyRyto/Tj2ynCSsVf8a20/PSJl/yNGbNMGtsF6awoSiNBcNGocaDDAA6vu1zuPMfGUMVVJxVUP0Ju+w1HeZ/cs8213ZgLV2R4DX90ZVJIeZPkkEYQ3PTbC0tRie78MrnGCuTeieoAA6Cy3GXyjk52AsHPl+0RODqgYCuRG7zigu/6Ierc2mC3sORUSVbCoKjymEISZDGLasihEQpn/wHDh7qIPQO24a4p1ekjJhn9xm/npDYb20=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Warn about applications of context_unsafe() without a comment, to
encourage documenting the reasoning behind why it was deemed safe.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.
* Avoid nested if.
---
 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c0250244cf7a..c4fd8bdff528 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6733,6 +6733,13 @@ sub process {
 			}
 		}
 
+# check for context_unsafe without a comment.
+		if ($line =~ /\bcontext_unsafe\b/ &&
+		    !ctx_has_comment($first_line, $linenr)) {
+			WARN("CONTEXT_UNSAFE",
+			     "context_unsafe without comment\n" . $herecurr);
+		}
+
 # check of hardware specific defines
 		if ($line =~ m@^.\s*\#\s*if.*\b(__i386__|__powerpc64__|__sun__|__s390x__)\b@ && $realfile !~ m@include/asm-@) {
 			CHK("ARCH_DEFINES",
-- 
2.52.0.322.g1dd061c0dc-goog


