Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1119CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3282A6B0089; Thu, 20 Nov 2025 10:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF976B008A; Thu, 20 Nov 2025 10:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BF16B0092; Thu, 20 Nov 2025 10:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E14B26B0089
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:03:04 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A80E31DFAE0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:03:04 +0000 (UTC)
X-FDA: 84131303088.18.0182547
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE571C0013
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:03:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kwhttIni;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3oi0faQUKCMkt0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3oi0faQUKCMkt0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763650982; a=rsa-sha256;
	cv=none;
	b=2kKnzLjBNN+T8357nRqrjbpzgmqF85+MCX8oEMyCXeL6Hfr+ihS6A6TZzcGb9yZFRiIjcj
	FcrGRqpXu2uSMQw/okBHIL0JrsQ7rS7hm7P1KyX/OpL+geYKv2ScllnBV2ZrWPUWn+JrxT
	8hnRfzBkDBiFZABqolaXMAhrHXCpIXE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kwhttIni;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3oi0faQUKCMkt0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3oi0faQUKCMkt0At6v33v0t.r310x29C-11zAprz.36v@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTNBohfvQLfYyJiWHtGyLx9FZqAAISthRH9eXaAWBIw=;
	b=cyEl3st6bkOqLkPOrqFbR+ILtdi3fO7XJLDDYzyWhpCw4OPyRCJkYJe9XTO4kPEikY3/IJ
	eCVG7/0CPElqZqjsZiMkuFCv+mZp1/r3cPli3yReYmN6vPodUwYm3D0y0XWy+1uD8SpYOr
	2FH4JaJ0G7viPnY6FSDSD/nxQj9ocXM=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64165abd7ffso1295586a12.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763650981; x=1764255781; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QTNBohfvQLfYyJiWHtGyLx9FZqAAISthRH9eXaAWBIw=;
        b=kwhttIni9CuDSa1MykNlGgrLAP4zkld6zEwh1COKFbKXo7LS3tDuKXJqpCPvYRUHZx
         ZiqSY63t0T54pWbK4rVwpeKUs651nhakaAQFknfd+NrBe6kDA8AW36w1PKlnPtlVufpH
         RxllwGmMCkhL9LV4g8ZrBHMxoiMokjYgMaGG5dgnczEKSkpQ1QYXbFGSsSOSqX+z5IQA
         zgWOyjoOPaCGXrVT+yhd41B4bUTYnKogzvagIPn6qU0w02xgxx9m1zAyV7tL6XLrvu+s
         iqZTc0v6Qk/rAKhMktNE4VWDhU3HFqfpSSOdBfDD+VscF03+ycFcZxQlqxi92PdUChNT
         hqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763650981; x=1764255781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QTNBohfvQLfYyJiWHtGyLx9FZqAAISthRH9eXaAWBIw=;
        b=kDY+GRb/X70Qfe9R/z9OGP/PZ8rAxbQOYF3eSATUSK+lcMkReB01nQU7G1yxftThvy
         Mb3bA640SPPYRwp4Ucuzs5orQhjeTa3JayeAe8iKZpqma/bS+uIQBAls6Lg32RIoQzl7
         MgpgkgUIaw+U1S96GfX7iKSh1CTFzZ2Zq/C+1gRISyKmA1Cb9fAXSz7PT62LWKupxJth
         zj6op6hYt4NB/f4pANuk0xhXqk4jjskAxeUQkClP1EqXxFHA7wHlcItwl2DXCDDGL88v
         hyTnqVFHlLy+xYFTjZIOomlG6nibcBGG7kIiDmaUSCyRIySFiKIJDOQv9WEjfhf8eP+c
         ov/g==
X-Forwarded-Encrypted: i=1; AJvYcCWYDj1VFziZh0yYsx1rjmOzg3NhsgrvVnOz7dsYpJfBQnGAyv6e85pHGz0m1MnGhPo0J5y+Qd80mQ==@kvack.org
X-Gm-Message-State: AOJu0YztPGE5mgvZ8SBejHQ4tsTxxtDeUO5DhjEfv0hMXcGca1NfQfzO
	nmvTpHtuWPnkUa4XSrg7RartEycrkqCQglBO+HdlPBlpRGCX61G5FTy9iL0T+mUtEonrwAXZlbN
	vGQ==
X-Google-Smtp-Source: AGHT+IF9OaX/QGeSo05eKeUEdCvjlZVpqfgwLf4/MHL/rv8J5uT/4osVo9PFxwafA3Q6L9NfftMIvUQ5OA==
X-Received: from edb10.prod.google.com ([2002:a05:6402:238a:b0:643:5f58:caa7])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:268d:b0:640:b1cf:f800
 with SMTP id 4fb4d7f45d1cf-6453d084770mr1885049a12.4.1763650978915; Thu, 20
 Nov 2025 07:02:58 -0800 (PST)
Date: Thu, 20 Nov 2025 15:49:07 +0100
In-Reply-To: <20251120145835.3833031-2-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120145835.3833031-7-elver@google.com>
Subject: [PATCH v4 05/35] checkpatch: Warn about context_unsafe() without comment
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
X-Rspamd-Queue-Id: AE571C0013
X-Stat-Signature: 7zpxt7bhoz73k1uhaipwkkgwdct63kih
X-HE-Tag: 1763650982-958404
X-HE-Meta: U2FsdGVkX19adAAoTu6dwD2T9yRNf+VsaJKfrmmRF8Wi718vWhgFRTuFjQGNl5SMuzccaRcdr8nznPmJ0p8SwR3j6VJa7okVi+nmX+a2prfkQX/fvhj0EAXkCxKF9HXcdysb3Cd5jyQvPMb7j+3Dvh3stF53FGRUxMy5uZmQSw7lWvAQu5PjSXw2XvzK/n3TpQVK0biEY+P8+mVANeco/Fcyy+30Np8GM9v/WxcuYwdv3/a0XYw/Y/HMtodY/Dysk8oa0sq9Cw+Mjxb40kbQHm+RZagPNqpJlZjouMwrvm2U+NrjsT8i+s6rZaiy1izSsWQ4zMRaHLIQCZtes1iRvd2H7d8JTFm668klLxy86nBnhIdOw/DTgOR80WN/tmjQn2JC31kaADbIbmUiqBrRzMjhs3+24bPw7PExp2Q8grcppjx8TnDdc11PB3catvCbt8kUy7OlRF0zRnWQqtjuu1+CgoNFQwTD3JFy+4YqUmsmZP0dLu8OeGoM/tNS5QED++tGXkWwfqIXWX4krXoLPKN0ft1XG0tcW8kViDBDed//pKJeIGi08oh8BFxgQt2f6xnnzVAjcc3HOBv0w16U1Nj8dyz9pX6DQeovjVdEp4E4AOmHIkDEN2JIwyynHYQeGwzjpxYNUfWQgnSsj+dxg5ct+mb6mieqpwo7mLoUABfzeqMy/NW+GqmaI8i3Ye59/6Kz3rpxZCKn24DAs/GRCKa2HOUn4qTApxOK0mPf2sOokgY8WSFKlg/0TyKIzAUJMh3buK7VUtE/MIzLQo7nLjaEjkOad36VOOQibV5oRbNVwtpDbeFZn0ZsB5e8LLvm3igVHi0F5YrhxpY/vZWoaZ4RrBxZI188IzR54KQcYIPjuSJmCwyafiuM/stKtqbkJharGFqakhpsYL2Nk1Mt4mmr7fdTcUwr3Eo2BU85kntmIGOelkgHe1EqbBiGK1cWGZ+qHM/HiJYiyuFgCay
 RNp13g1S
 NxxwwxpGtAJLD574Vog+YenYTil7qMe3uqRDb/rKNd4joYANMuE18A35e7r76cXSiNX4bCfIW4r3SxFZJ6PW4BJoiPWSu2jnWuBLW1nrGqwgheCGQTL32V1dsV05gDNlEt2ONz4JbikI5WJIhL/3nR7BeJZOqnbdX+/rwIQcxKvkmCVEdllIwoidnjiuVTXTYVHSDlgoUaJ1a/2WSIYFa+K46GlphNjqdfv/lZ0RAhouBa09m9VCcSxiZ0QAo//xUnsGBOAvqcXt/0CmYM0rEIkJujxfEAoMyK3bTjFue3CmLZliKEHK6yHXqA4DHBFzDWdJ1gtpFeBefatdFRfL/W3bf0/cFg4d4z/b2gmhbTJRmOT0UfIGCb+q01MT12hr7V+EmaqGR0zdqlKOMS0wwRt/VKxvmh+gGM+MSlqLTFwHNJq/EhGmxp4L7OxGcoiCKIopSfcG5g3HLep2YNH5iDjxC5GYQxmjTNle1Fs8UHScjl2Y=
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
index 92669904eecc..a5db6b583b88 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6722,6 +6722,13 @@ sub process {
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
2.52.0.rc1.455.g30608eb744-goog


