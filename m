Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC99CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED228E0082; Mon, 11 Aug 2025 13:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DDF8E0060; Mon, 11 Aug 2025 13:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F318E0082; Mon, 11 Aug 2025 13:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1D018E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8629281E09
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:38 +0000 (UTC)
X-FDA: 83765168676.05.FB83967
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id B27CB100010
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J2KD5Fae;
	spf=pass (imf14.hostedemail.com: domain of 39yiaaAYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39yiaaAYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbWyNjhRffdizOWiIb7bDk0DH91Nu7zFnwGTY/wxrLs=;
	b=ZXgsGMYcaFt+0SiEzAhn+75C+Hx8nzq2FqP5cT68LyVx/kh3J276C/+8ey+PCV4lQhPdHm
	CNXkQj+GC3ajbw67zkwqRL2HKtOuYqha2pw7kQwTf5vfklkonFFg9dyTfPsai94vMLe9Fe
	Tric41/PPzWbCFkgeWfgVDKdyxwq5a4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J2KD5Fae;
	spf=pass (imf14.hostedemail.com: domain of 39yiaaAYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=39yiaaAYKCPwoyrm2yksskpi.gsqpmry1-qqozego.svk@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933496; a=rsa-sha256;
	cv=none;
	b=V1lzRpLnxDohfIN/2Da9kxvE+poQH2JR5qjBpXluoGbHRbVd0UpRzqpbYO0jQBfXSzOwnV
	W6EBBM0/e8z73ZNFBf4hCCFKWhLPuGXJm3V7T4h4HJzO7SRdYIwrpHpCDDHf6Nfn8H3M2A
	f5GyH1qCH/WzyvatvTx/XmzbY5rCqm4=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bcfe2a8a4so4700980b3a.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933495; x=1755538295; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nbWyNjhRffdizOWiIb7bDk0DH91Nu7zFnwGTY/wxrLs=;
        b=J2KD5FaecPc7pC4dJx2XC9skTCCPN/rBYYQ1ES9r3GHQ33uMDzCcDtHaom4k0enTIw
         IOxDpxYgO9Dq9+1kCa1wiURpoP14YI/0AoKGa5+dbK0H4pvxYoxtOxnZpssJ+82FD33X
         ZJUh/jUO6WAVNPCO/pgG5FtAWZoTabmRHzh9cKUyYDYPO1Qwa7FyjouyfThuZfYwlI+u
         0YRSvCkc6Z4/mLLsg+FXcJ9E3lpihenVVuuwt5afLvQS2xPo4YDWVP0ZPevOQIlL7b1Z
         uXReKC3yemphptGPJbwJvy32yNwIbnVLRc6DJuMDRn0GG/VyY+nqIvJLS4e+sKzOmQlr
         KZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933495; x=1755538295;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nbWyNjhRffdizOWiIb7bDk0DH91Nu7zFnwGTY/wxrLs=;
        b=aIdfBXPTfzmJP9t0peDn5MzplpwuvB8B9mMqq2QC6lQUndq6KBx376+v6jvLctf/Ce
         is6zjJW5B4lkEyb+Fpu1GYzO8OtezlssVRtjIN2kB/nJV7Kz9Zrr7/FEnIPuUyFdTRz/
         fLJWNHqGSfy+5PnIGOVRBdb0f0QFdQjSvH6XQy7fBnGhCg0Rp/P/fUjK9lW7DpFgMF4I
         6W3iacDi6gHJOzylyE+9idWWH0S0X9FlqlrfLnIf7IkArLaJu1wF+zK73shgaNQf/tTF
         Oi9pUkH9KdWwL0GAZ9QzfS0GXDuKjoe4FN5N522LCrF5gD4gnuvoVeRjAWCwekZcdPWa
         xmFg==
X-Forwarded-Encrypted: i=1; AJvYcCUu05WWFbOvIbCOvSr/RyDi5ySDcETbOom4ENAMJlPIOUTID8LTtyievEwCqZx1fFdE5CO/zkovEA==@kvack.org
X-Gm-Message-State: AOJu0YzlFz6zZo7M7UdzZyT6PMdwFfK/WU8VziZV9JYeLmvxMK+TXsPo
	krekFQzxIFIDFbAJrKgGfwjUzwPA7fw3b6Ax32hIyspyL3+Qg5MpQ/28fOc4nr+BmHlCF7HpwWX
	6HBXrjg==
X-Google-Smtp-Source: AGHT+IHxJ97+AwE076KxPYX/sWcCDY1XqeMHaZ3AGAq4oCcRt8YytBHiFg6jXlxoMu/lw9gst4WNB9FALdI=
X-Received: from pfblh2.prod.google.com ([2002:a05:6a00:7102:b0:76b:8c3c:6179])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b46:b0:76b:f01c:ff08
 with SMTP id d2e1a72fcca58-76e0de2de8emr552627b3a.2.1754933495361; Mon, 11
 Aug 2025 10:31:35 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:31 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-4-kuniyu@google.com>
Subject: [PATCH v2 net-next 03/12] tcp: Simplify error path in inet_csk_accept().
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
X-Stat-Signature: chwdz9zrngazjffk3ypbrffswad4dcdk
X-Rspam-User: 
X-Rspamd-Queue-Id: B27CB100010
X-Rspamd-Server: rspam01
X-HE-Tag: 1754933496-973696
X-HE-Meta: U2FsdGVkX1/XJcIT/b2uacTAd943JKIKh7oAMzQU7iAQFA6Ku6ZktPqAlRvO5XjT5JEwJPcEVBRKYSpfeHEtDOEbUSDp9LXvYb4W3hfLV7Sn62AGWPROXQx0Wv2hqGQ+nopYwRqYOf9ngxZ1Yc13EswAthqrUK5RyIGJ1aRJn3oRZJ3Ip3ut4CvxLRB4by/mKGhHtj5q9t+5ALgUaVI8rgS4JEsNwHaHSm5QUbsl6Q3cuNPmiPGu+rJecC1GW8NSU5E2ZVrTnEH/tEicPr7Bns4RoBwFV/covdv9TdyxEJKFna5FXqSzL8XkUpteRFHHp9T1C7Tv912WYsiUPL1CYoYPmsJiukVVEitioCzVddv1D3DvYE3rs6G97LyLi1yiOibXts9uJGKMbjw/SBpzKhYvwDptta/uurEVjHew3YIGVDd+BEwd1J4brlJMBmo2sKKL8Sc+Et6D7XF9066gg9oQ1FAlP4rpspfGV18ZolFWAAJyB87f95QMt8ud8h3B7VmtQ/ups5AZGTRLdq85xzo9pMJK5AgYRh0AbQuhVQ0R/xCTFORuS6M8BEkmE3boPxy3n08GYUoFuVXUV39e3AknYtuy0i4asntSWTlKO0DRAUO94akCxCIlYFK2vIe4vG3pO1+uFuYMejbAvpKqdDmyH4bBTo153dZVtMkOUpg8bgttWXYZz6lO32wkEJm/aQylZECkBhIfRoVLKK9fyMA0mTgDkFdp6Yx4dgtWm9jeIL/xWEgZPq14mUCMPVguAE0v+gZ4EyihrcC1u2yoQtVJijC4l8BTvI1kCMx3D7gAMjEJEqkf3YlBYbJsXpDzbeEjoHmr/5+PhXIDMivt+wmyfV94yJ+ugOuImXGDt++N8HzJhrS99nTiDZL7JQBdo5duCWw2L2ykTEAXnOLWBzexQESCHwtDOfCUK4U+2rTIZjQXdmPuuL8uS8pgqZhNgl8USeqQC+i6Mv8AmFE
 3qFrITMM
 JiCvisMb6jh1p/1Gx+N1VqMJ3nsp/V2usA6iXM5aOy6vhJ0W+TwFNrL6EZr2ExjDgo6Ak8OdYcVXP9qtHY5CPZzmA3H/Zaom9BvLJUbGtmThGdRFHwnoyGklzzWpihL9yVP4V+cy0LU9tF0jL8hrH0zETOQLuWvt3qh2g+pQxtqbrop8BqrJ1ubBKQQscz+O7J81SXB+fD8Oyn2v0nafBCJzxBe0RTEULbWDUhNcyxMbKa3ImmcMhJLTCVRYBP413XlVG49RK9EZ9HzQmhudMiSQaDox5CF8g3fNtu3bISylYRUtNoMRrrxQJ/B1Ra/D8M4tR/pqUG5fvABgtRnwM/fEjkMeRNpi/wxykTa4rNMtTq6JheLpBfbzZLLV0WOMHavyB1k7m2qe6i5V6cVqpcs0on/w6afpdrwKsRYFbLDeDxJlFAr7bYML1AnGn/ggFDrEKkT7UllvlR90CxtZySSYPI3cphiOvzZkkOSco+tpBixU9MD7F5wAsJZ9H9O86O8wAi9QKNifftkOEMNXsi32AFKszOgzaBetU40L6cDnR1DtCxqSROx5kjB1Hu15ECS9By9iVPhL4sdQ/tUhVyphUGw==
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
2.51.0.rc0.155.g4a0f42376b-goog


