Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1260BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F90900015; Tue, 12 Aug 2025 13:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D07F8E0151; Tue, 12 Aug 2025 13:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0B3900015; Tue, 12 Aug 2025 13:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5728E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBD56160117
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:02 +0000 (UTC)
X-FDA: 83768866524.25.E2BE9F9
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0063A4000F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QPZmFG0M;
	spf=pass (imf12.hostedemail.com: domain of 344CbaAYKCJ4ISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=344CbaAYKCJ4ISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5rCQpTg40XvAN0nRmC8PJTXTHlgnacsK7xSr02TOwk=;
	b=u0Q7srGw4afcWWTxwa+1m3gJ1SL7h4w2JbugKpw5vcxNJ9xWsEPqq+qSTAC+ihlDUoJESP
	VqIsomJCMGIEiaAlvt7Y+m0tCMAQRtuAl82pU425bPkxFGcgOBtoLzSX77+nUy+1j/V859
	xxIKoGO2pB/0RNxyeL0RxHGmJgbQjEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021541; a=rsa-sha256;
	cv=none;
	b=d2KxfBX0gvKC5hpXASLBb+MiCwFkDgF5NKT2G1PsGSgDuQH+fcAWL6Z5y6MzRJ/S31SFc5
	A+lsmUUlVSQaYzmndQw9fN0ss6iezHXlSoA2ZdbjLj+quVYzXJPw0d5mn7mvhPlAxys7bm
	26CbS2aIKHP64tAT2exwISXoM6Q9h+I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QPZmFG0M;
	spf=pass (imf12.hostedemail.com: domain of 344CbaAYKCJ4ISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=344CbaAYKCJ4ISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bcd829ff1so5473250b3a.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021540; x=1755626340; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B5rCQpTg40XvAN0nRmC8PJTXTHlgnacsK7xSr02TOwk=;
        b=QPZmFG0M4z/dBo/InwDrS3RnkUFy4KWBc9IwEkr7L5ldSRyEhAdmtxhLl3iUel/6Gx
         Ik2fOipjZytNvZ4dpxVHO/4vK40P4UGxsdv+JbJWjQpSaV9s1Su0b6D3oKuDJwMdL3ni
         swhROAgXYUabZpe8q42YzIDDgv9ojgB3Y/4OpeiVPYDrnT+ZalYBsXSZYHoG6LiFKSdt
         XooiB1/Ix8Ak5Q5hYtNrVbDFbEDXyf51RO9+dlS/+GQYS6kywhGnQkFEaSQQWNCQZdxB
         4r90o9gC7GHlWu7QUaT8+wuat8QF38lGvDpIMYTo7FEp1+wDn5lkjmCtVU/qNy5rK2/3
         O27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021540; x=1755626340;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B5rCQpTg40XvAN0nRmC8PJTXTHlgnacsK7xSr02TOwk=;
        b=iu9YJExPmR6+uIcCEdZbZG0j8YfBYVU8ile5YpIPqF2fGVIXnrGpoZIz4Zk2JGLwxo
         xrOaQeoN74/sFlAdDq7WNensEeDvXpyiwpOAy5CD7pBZJ3LUa/eO71gNPxbMPMUAujPh
         scuf0W1fTa6y7a+bPPBGOxvu+25U2fJjvpwCe35mn+PiGdEXDsHQhvurBTcaOXRQmCcV
         HyXDgoiiDF5HfDMtGcYDj7ZW816W4MEuFKZxplnbl/0AQMgKeHm20gu2u2Vqw7u8tI9t
         2pb4aOeRiqLkROuXjDbEJE6DTulRl1R6ZsdZ6i/U6NXU3h0Qc0iiUa6ShmsJfG5J7CuD
         UN7A==
X-Forwarded-Encrypted: i=1; AJvYcCUD40iwlo75Kd+1j+u5HjTwIHdM3uwRagGooSy4fhvabZclopT8/ie2MDdz5YM+ioCRjxAQXB4+fA==@kvack.org
X-Gm-Message-State: AOJu0YyAy1YbpyUOY/6TsAJGHCcNNxGA632IJW9UqHgOdSJicl69aMWl
	Z2XKkobLS/TM5v5ceseGoEpxTMcQzWpaURB5NXnoOClzOi3AnrYMq4/UtTmzH8a7se4v8FjmQAT
	wJbSaKA==
X-Google-Smtp-Source: AGHT+IFWOE5iaFIohAGKeh/7bkm49sAtcTJw3E8VuXd5fFWE4AD9T9o/O9JzYSwQSyIb+xne5Odsyex1rCE=
X-Received: from plblh11.prod.google.com ([2002:a17:903:290b:b0:240:39eb:1e8c])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:440f:b0:240:127:85f1
 with SMTP id d9443c01a7336-2430d0fc548mr1608415ad.18.1755021539728; Tue, 12
 Aug 2025 10:58:59 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:21 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-4-kuniyu@google.com>
Subject: [PATCH v3 net-next 03/12] tcp: Simplify error path in inet_csk_accept().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0063A4000F
X-Stat-Signature: dzpj3xa18r9kqydu9akr9qfkwq5rjmsc
X-HE-Tag: 1755021540-371955
X-HE-Meta: U2FsdGVkX18rVatcgIkB+Utik/zrJBuvSJbIbu/EKtCefoZ8ytlOPy2Ntma8CDEGdYFHhY6drCggN/UpnbhQyc9k2dsxrjaso/janDddEBPXSgthAgN15JAppEgiLpDSvOofzg6epj86STrVnACVIPt47tEWjNj746h3f0w7Rzpw2OT95/JD0qPjZfZJm5Tmi76lSMS5lt4KhWCslozpOZNTSFDtg5d+V3eBfmHTq/EYHfB/GAnm3Uviw5WsUrZDKnP1Twp6/gcohmQD1MBBaXV2Q1aEnatriW5x/92uX1XCy+BM5qj5/R1qZt04lQGnnV/iV2eMpQbsmEOKI0i6fYSVzeQqYV4n6aSyxoxkVP1tmFxiDC8xOGO1SWJyLU7nCLYAbM8QEIatQRvLlCDK7zfXLmcIA9yg4zem6ZNa/DntHcH5JB6rPavswA8T1cPWdaHYhb7vl+LDsc1RUTN1BaY0Q4IQzbgpnMv4BFmvWGnVelH00EgGEXhU1PH6HYP73Zm0SH9Jm3eIrNNKJSsK2X8dlBXiZzqMY64JpPpy++E0xx4iVgIQHTmskCPgdq/NkURpcgio3ieNo6y3TzVxOTsTgb42syC8aBYsIUpy62zEmB//2lg+TmvyACVKaCZ61kIMixrJaqJlBspS/lJob2vfD29mU4odlduAwvXyZQraN8HJeS9PYO3Y5NzdxAawVydmT/4GWY/dutdvXpISvIc1UfZmUutnmKjTM9dWLmkyVv2WWMuJnyriOIc2T2kAc3zgBHv6tinuT13Mt5cyu1SPmQYsI4mU7yHqe0L0naDnG0eVHsxZJFpLMjc2AiORzhSCNova/RvX0nSQEM+BCl71ad4PdtOP9s3q1lgWg3LDtCb4U0Uv5LaeQNm8LxLvp1RxIesL01yOvJNI9vplJT3g34JeNThAX0X0fNkXYQM8mEVn5Qacyux+PrrZ0hS7Ujs0WfLYnSkIAaer9ea
 ZCsUAMBr
 B9PjvFTVQ2B8YSaxnE36CKe+OayebKoW3Yex51502pUBPuKPtbNafSCJdxKFVch6xpaKn119PznxD6mEbtuFwsoOKz85AF2pEpwinD5U0edDjY2b+U/C8+wFr+vCQZ+ECRytcCxSK0jr+jz+x6lek1pfG61r7Ljy4w4SXDBExiKuau9uAruRLZDdWexhZRHfElil3+mQ70FEvQQDnB7WvPdNcgrsBdZ6vkRW1a3Hi35PbRj18Ww869un3xFa3MyepjOXOyAZ5zgmN+YifoMeHRL7hb+Na1C1mpo16T0ekZqFR9JeATNNxIpC3hWoFx7DnF7Jg60psxVxdRsbkhT09cERi7KQy5jixiKcNo5NytbGOjM+uy7I/X3dSGaomBvLUf6wmQYYcv8Nx/Tawz9FFfcMRHLm7etIm7Q/DgbL4jFIsD0QZBKQijQAV38hjfyPmMfBUlUfsXUBvbo6opArfwHt5Lmu2vMoWMS4hCb/bEQ9B79bjKzF9mYGPl6Q1dbIebvvWUhTKygyr3+1/VOiVxH/vpDZD/2k0qKGnvTrI5Bx7OEhusAn/fK1Hc5blmD+1QVpKB1Qll//sTNuwty6mnnmx5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an error occurs in inet_csk_accept(), what we should do is
only call release_sock() and set the errno to arg->err.

But the path jumps to another label, which introduces unnecessary
initialisation and tests for newsk.

Let's simplify the error path and remove the redundant NULL
checks for newsk.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/inet_connection_sock.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e2df51427fe..724bd9ed6cd4 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -706,9 +706,9 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 		spin_unlock_bh(&queue->fastopenq.lock);
 	}
 
-out:
 	release_sock(sk);
-	if (newsk && mem_cgroup_sockets_enabled) {
+
+	if (mem_cgroup_sockets_enabled) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOFAIL;
 		int amt = 0;
 
@@ -732,18 +732,17 @@ struct sock *inet_csk_accept(struct sock *sk, struct proto_accept_arg *arg)
 
 		release_sock(newsk);
 	}
+
 	if (req)
 		reqsk_put(req);
 
-	if (newsk)
-		inet_init_csk_locks(newsk);
-
+	inet_init_csk_locks(newsk);
 	return newsk;
+
 out_err:
-	newsk = NULL;
-	req = NULL;
+	release_sock(sk);
 	arg->err = error;
-	goto out;
+	return NULL;
 }
 EXPORT_SYMBOL(inet_csk_accept);
 
-- 
2.51.0.rc0.205.g4a044479a3-goog


