Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A9ED7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC946B00B3; Fri, 19 Dec 2025 10:46:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6564B6B00B5; Fri, 19 Dec 2025 10:46:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562D66B00B6; Fri, 19 Dec 2025 10:46:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4281E6B00B3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C89E584FC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:40 +0000 (UTC)
X-FDA: 84236648160.11.3118BA2
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CBA340011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GG87FSSt;
	spf=pass (imf12.hostedemail.com: domain of 3XHNFaQUKCKkNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3XHNFaQUKCKkNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnCWdNxOjiV83xbv6/Q1ySENLnYMSFtAYAkCgCH7C/E=;
	b=odwLlLkYY65P0mQHYrSO3dVHe0sLquFH5e2/b7qeTZTXMwsyFQ8Vy9z5SXy/a6BG1XXYYl
	bwGxEuk6A8dbpIs6iz4MCFnPuO70CNpD/sDNnkKIIMOFH4BCSH4/mp1oQ1fHNri4enWg1L
	ZM9/kh//TO+4pvw7OI49Ri9WU6hfkes=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GG87FSSt;
	spf=pass (imf12.hostedemail.com: domain of 3XHNFaQUKCKkNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3XHNFaQUKCKkNUeNaPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159198; a=rsa-sha256;
	cv=none;
	b=izeXZaaYHB52VMgsPMauYGkSt7vvbGHsNd0+aYKuO4kiTHJJp33yu4b4tNdMSHkd8a3+Jy
	pEkasZGSUKBFXs1M7+5tXjPMkVlwvJa/kugl1Em+hqqmma5Sr6bSPe2tqBb1IIzfA0iKJN
	F1sBPKs1PZ9tqQ/WNPURjuOY1rsSWSs=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477964c22e0so15831055e9.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159197; x=1766763997; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pnCWdNxOjiV83xbv6/Q1ySENLnYMSFtAYAkCgCH7C/E=;
        b=GG87FSStyAGBLv379KOLpU0q4qUEGfulWb7GIJJDS8IOm7ZBc5M8JMmy+aVrpR0ZFy
         QeS4xoVY3DCqoBS/eyvljJGhJ0/NyFZhHcBejVGShuc0+dLVNF3DeauL/PIl8+6Q+6kV
         fHID2VvlVwRhFPAii3OBfNTAISt5ppj18/Hvv8dgl7gD8QDb3NxMz/uPFYNnVXOvaFZ2
         i5c9BTpgTw3tpHWp2SlZz2xRACVGc+0ee0xXwss6xHItgnPd8Ui5iS0S0ur9Wl4cWLOX
         BuXzSMcBoYMaSyt0e3RVlszo6yghxwlp1CwXvIiSODm+KvgYqgIuAv3qDt30JDJNPP5I
         33nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159197; x=1766763997;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pnCWdNxOjiV83xbv6/Q1ySENLnYMSFtAYAkCgCH7C/E=;
        b=UM4i5NZaTHOnrvXW3wLiOuSffpq15QkdwOyHlb4cGWjyA37cTM0wKZqJIaTPM3GvKd
         UCsI2gDLZ/LFPDn+OmYnCovFizeltTBCihfED7ipUdWTWJsqK2y5atBS/0CzWmLjeD3t
         hin8wj0D7KLPD1MljPgzuK02qKWoJdDWloecIjfZXIQPR8cCSUg3Mg+ef/cINdIzRPss
         Qpq4o/sTeTq5+UhmIcA4L5JZJdmfqO99NOYb0ybKCfL4+q1/YA0aK51VckFVcY4cEvRl
         tzk+3VtLRQf+5bYUJc+DEGAD3A1KYMSTyYQi9kVMHl20LOv2dqxUbM/m+2YwaBgIGtBe
         iIBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTjD6r6iY0BhtIiQNx4v0qmk6X1mpHY08MMtW5fvLlg62hVZsFiXwlbwK2b4VTIpbeSnvuhJCGQA==@kvack.org
X-Gm-Message-State: AOJu0Yy6BOqwtJZhELT6PW1dK2ZNVRU54vblNAJhokL2xUwqSoBLGR6x
	r1Us60wks4DpAuTA/gscwlUSX0CqXJo24ZDVbIlmj9N3PwFIlmAVOaZjhyS1IwnEWRwjk7zUSh2
	D6w==
X-Google-Smtp-Source: AGHT+IH94p9GxjeE5eZFV8DN+RguEekXTKbRPlnErvQrVGXfEBJeQJYNzzYoe3WVGxRFHI0q7jnGDkVIDg==
X-Received: from wmcn13.prod.google.com ([2002:a05:600c:c0cd:b0:477:a6e8:797a])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:888b:b0:477:9cec:c83e
 with SMTP id 5b1f17b1804b1-47be2999667mr56775795e9.1.1766159196727; Fri, 19
 Dec 2025 07:46:36 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:07 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-19-elver@google.com>
Subject: [PATCH v5 18/36] locking/local_lock: Include missing headers
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
X-Stat-Signature: msc49ug8oeujmzwwd4s8sdd1npmefrqp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2CBA340011
X-HE-Tag: 1766159197-118464
X-HE-Meta: U2FsdGVkX18Er/sXHIK4mYDG2N05MgC5DSZp8Z4RyKmygfHoyr5SdjlHWCIE0zGjOmMA3GkQiXTC1eHi85J6L+SrWVLSMBNZtv1RCOL3Tbo1VYgJGy/eBt40aqqZc7KYN+ekVaghOggQ86bkS22ll1OdpNh3rOp3F0LtFK5qUv+KdXn8wi1Y0Lwfg1tiPlyi6d1NC9+E568P3AHi5wSXhvfbEc1ZT2OlFT3erwNydtQB5k2/PBWwD+0S9Jzp+ALNZsMS1n0hHziBsRmc5C3mdaejbIctyGHA+hDlfPOMJ2pEK8bnG8JLzUrEF5OWx+qjY+ctW9f4Frgq6W6IzUMt7a/ScqbPGB/aSw/eEIkcMPQN3LKj27fvr8XsFEYndLlg1RzZtXykAza6CpBKhqD08lng9fvup716TK+SvW0XhC/wRUwBAa+e7XETOShuCFFgz7T45oRBRKhtuxX5rzyxod27BOu3v7rPmWYKAuOKxvsAe7c1RmWZhOsSAxPZRVbJUiV1w8e6ri5CoVYoHrEFwNNkjM97Sogg0WuXEcIJxsullMXslafztMLXCb+yrXkmHNfjMRIMm1cm6zkcGfWTzbLM6VvG6yjlud+q4QgJOJCDPawIGPCXO8T0EzprpYfbFgCQG7pFc2slokkdqw16dbYI3LyAcYgrf3thDIB6FXTjq7fR8cMOHdiqvlFN6XuqslqeI/V+qNsFjxVdooEvSvJcWViKQAW1EfVyIujgdWWjz6SwARIlLhm7D49zBcL1g5Io962/hK085i7eQJSjIRdZRZmXuyk145hTBhaCW8x55zQku6vrQdd8yVIMZcx8hz9o0EjE203YXmt3yw8vN2Yia1TUUZu4kP0FCYBcTX2+3609KRy+d8zsnR5IJHw8WUS+hwnI0D/4uPXwshdhX1ZqrKYcoFS/chrUNDg2l/gYCP0pTXIM0iFELDP5XFqxAvhJqbZZkUldJWuE2rW
 xDaQpF69
 ccW8NSm4JB4507EQE/t35LV3YibxmeP2IMgEvtkZQOP2bHdIJjIMPnZbhaoK9PelE+nc7Uku6V/sg1n/u+oEb2Zqfx8hgTRZIT565fT/kZr9wm+SQxg4L8yqg6H2KjlSooV6DWBi93i/ttb9mkDFLCNxsT8bTquhVqZKvPzwwW4uztze9ygKYJoIIa3Mt4eSbpBlol+ZTdmreHX6JpEM7p5KkyZLVQLyz4UfUmAFHxBZgu4Ae6yFNeDmm5qCUMYnkIKQVi/7Rjm7FtX0cxdi3M8Anu6SJTWOk1CJV2WiLZAJ7h4weRUn+SHVo+QPyLeJuoUeCv9fQEE2CagKwnC3yu0P35YlIhEVOCmK2YWhDdJRzwuUEQiBY5OFJo7owNIjnK3/lJ0q8rODyT634EON3rVZZ6uDM90f+xDEmwef5zF0Cg3Dg4/JPoBVDC/4MPCsXsX/m/Bf3IEpJrj4w7p5uXS6sU6xDesueskPxi+HDrJLyDfgMOiGlxh4zbfqq4nPfHk0kvJiI1pN32N4mnxkOpSIegwvFz4Zac1DTPkZyeQzpVd492N0hHPLRLaDqIS/plLjEmSgZeOGxn4DgLOdHZN8/1OeSCfMmJgQK4VPiUoCm6NpcgaEf5+yIRJk7bny4C9tP6QsQptztmnEAq4gBEYb2LJsZcbelIClu4+CRVZ5pYTuMfWBO+MzKTob6gYKDIVy58px4ELO9sQOM1WwG9IJkTPqUxJBSTAMaJQq1/si3RA9t99nxqea1+gPm3u1zXFlVPdPtaahDofeR9kjplF48LQ==
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
index 8f82b4eb542f..1a1ea1232add 100644
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
2.52.0.322.g1dd061c0dc-goog


