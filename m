Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620D3C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181006B0095; Mon, 21 Jul 2025 16:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCB66B0096; Mon, 21 Jul 2025 16:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76EF6B0098; Mon, 21 Jul 2025 16:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D37966B0095
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9829B801C3
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:34 +0000 (UTC)
X-FDA: 83689429908.28.AFFBE4E
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFF6B40004
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Vg0QG5q9;
	spf=pass (imf07.hostedemail.com: domain of 3z6R-aAYKCF4GQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3z6R-aAYKCF4GQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wpwn6QQouhXynO23Cu972bLk01/99pIHsLHoJU/mo78=;
	b=xO33tW7mzhxTA7LjPpqlhJyFb4acKmrJqBLZnJ+p5KH2O5AcJFVJlpEjFDwgqJyuNAWMK/
	LgSE8gdMS2MFpaSJJF66oqM8qoqKvZp+3eqWkK78/ylwK6Emz/NOG2LZgG0PrE2TTDjoqj
	M0PGNnJ2+Jrj7G7CjbGvK0OmBWNZ9mc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Vg0QG5q9;
	spf=pass (imf07.hostedemail.com: domain of 3z6R-aAYKCF4GQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3z6R-aAYKCF4GQJEUQCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130192; a=rsa-sha256;
	cv=none;
	b=YASuVT3EIn62B7M8ldomDwOsjPSnTeydpEOA1Krd6D7Xu/xvxtKqeWrQaSu/aUT7IDqe9m
	TKle2eFnBWUGlSRbph7hmTcx4PHrlP04tEiu5GIiQg8X8EcspbG+6agL8Lc6BW/odkDGPH
	0rTILdqDKM2wHBtF5MVYC3QQoDgGIE8=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747ddba7c90so3943299b3a.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130192; x=1753734992; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wpwn6QQouhXynO23Cu972bLk01/99pIHsLHoJU/mo78=;
        b=Vg0QG5q9VtzI/wzjGwkiPWYyhfXBBJnszlUXOUwahWh5k/2Z67cZNxZsKcMbB2oBqe
         Ke5EzZxES1F1oz2wzpAwb/Ahu31Kvnn/sgHGKOq9NZPSmm84DyA7aFhDDXJCQ7UfGShT
         9En+6DoXXOD+wwBXVwbQQk/t+wWgjxekvVk8eM1379ApQsXkaECXJtLNj2KT/tdozY2p
         TFIT8zconE45KcE8smBFuOnOtN4OOt5PKss9WfRv2R7fplVE52r5oJ22Y6ahpafZhKBV
         T3nFaqD+/WJZwP8GYknrumVsKcDug9fIbaPXmLpX/30zCNgsKgZveZwsvn5gblWfXRuZ
         u/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130192; x=1753734992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wpwn6QQouhXynO23Cu972bLk01/99pIHsLHoJU/mo78=;
        b=ZniGqSe8ayoTb9HPCjhR/kh6/xS0mrUXhSl9lBi9ehNb8+2Wgv6muXWy8R1SKlB0sa
         aieX/nc9UzrFfJqtnYPtS5BgEn2iPJopfpR9kqLrvBscGNZOsQzzRbj+qyOkOpwcm00K
         3jW2kbPlrKspSZOUrI5EwlQqdMzX9epAa1EALZH5LIZ8rYnQOLHW4D3cfOUMhWEFmPcG
         /AX4ITZdHXeaOQRr9+G/m2+3SNt1rpxUF/2TY2fjOOrooBK1pNOY/3Z5cQc12YXylSTH
         1xoRQa4XrQqM6uRFlHOaJdBREJsHDZR5neiNgwwJFg0tuOoI54oRAnAoDyoZMbbDpcRP
         2xAA==
X-Forwarded-Encrypted: i=1; AJvYcCV9iEnFej0nYGBKawfdD0Td9ejDjVYzYa2+4oz+FUO7iMnY0QvfexUCzKtxYDEyVHtXkEjd2h30fw==@kvack.org
X-Gm-Message-State: AOJu0Yzds1izseF/do+FxlW7nKIIZjUZiz9r70YiLKN5RHXwc1n5uv8D
	LFOQO++m+87dmYLZJrJE1Q/Fy8evQWEhevRnQ6GV0ZifajkAIni9U84OFxcqZcDi5PqG4MZgzxd
	XGYresQ==
X-Google-Smtp-Source: AGHT+IGOSqwwC3mh3GOf+Pwdhi6WvfqKoRK+i/P5LIuBAbC+/yAfslPdXIv1OdhrmQiErVu217W2zT+wZxQ=
X-Received: from pfbml3.prod.google.com ([2002:a05:6a00:3d83:b0:748:e00c:4e66])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9f:b0:232:7c7b:1c7b
 with SMTP id adf61e73a8af0-23810d50911mr35590008637.14.1753130191720; Mon, 21
 Jul 2025 13:36:31 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:22 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-4-kuniyu@google.com>
Subject: [PATCH v1 net-next 03/13] tcp: Simplify error path in inet_csk_accept().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tqu1aitp8j9qfd85j9ty3dd7hy9ymwqt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFF6B40004
X-Rspam-User: 
X-HE-Tag: 1753130192-947568
X-HE-Meta: U2FsdGVkX19NIrDyr1UTzA+7WY6fStR30AU5O8nGPhmQmsMpCBCJ+3oUUJyx1bI+ma8qO5F0Bqqzx6ptQEAgi0vI+6UuRGPu15+WmeoXKvOUgzCKpcMvC6VH/5MUdsbbMuzAMbTcPiWuRtoBuoX6oVR4F/Z+NJd3rVrGXbMQPFdz4cEle+FJgwnXC1LLZ/jg3KB4xVVmyExKHMbjTALC46XaRB3KJoJgaVeLW+VMN5J1TZr8vFuBBQHzwqtU8T33KUzWg19RCh0sh799HFaKCwwbBUoZtEd27CqshjHu9pDTXV3ittdVx5G1PZGrvTSf0lpCc74o+rcim8/88VHNFkTIEPxysf+xDsm41rV87HgFQEkinNjR3/jHgElXWQ+ShvuIrw3Bs7yg5GhsmLXQvzwRpKh/69l4HglrXEJ6aQZvSY+7uiGBfcClPl/IPXSdQ7UUNUjna48sLyKv0wpxgRAIWf9PZTbNZDk0sjjCLpnT9TfonkC1MWafvRE0E7EoXrc0L9Rz9SklHSgaj/5AaiwtG+LffCKqjuNSQQ6hjEP979+tvnc9hmkTn24KP9HqtZfC95tv9/YT3PsYtuaW+ryj8heRzXfAR+JG8ubCtB0gjo1tJpeoGNzNzQn5glubVWiI6EwRNvTSVL0Each4yvBfb9d0TWN/xoJucWXmreiXY0OZNBFXBioenpdh7TqT+9do6IOcwBr3cDMOXvJwrPAmdpFkzrhHmNXyISBe8KpZnKBkH8LVfuVagFbneOGLsu33mCo5H1HChbsyvurxbrUP5JtSqoi3ZT6esQBMI89bgNac5dcS4r1rTqXfdc4uRBq54d+hXIbZXg8OnQQ9fwsJb3v8cGlLyWSDoFEAXGVl2SQcZQF5r1tI12NfawBDsdo1+JhLPWAZ0CGxmGlFNppWf86mm/OT4KJr3X+5RKjOaj7YcZkTNJKb8WC8fU9SuKvd11B5ylT71ZRIC7H
 DoqTXjbt
 y8k0NIR/XKiFeJ4EjuefrFHxes5hzca7P0VDKYJtSNA5kPEueE2tg40XpE5WtNfXapLgIbYTLyxdRzBog5AQhYItvV/jHdsC+FvpbDTKQLnJwo5dhVyVV1sasqCzT2JmoV4NW83xJPhgP1QzdpNzTTW/S1A80XE4sIgwQ93Hj3nB1l4sCTY84GSzoVsUavXnW/WFbVhAU1Emre+AW0ujm6UaIW18ljKZ9K/05bCWmzj9/DFmscR9LRyAbu3rH7GYZ44IUO2l9egE8ERrHQVsYhG7shuvJKs/PVirui50yb0A5DWJmPLGUxsqZyDEGdwHeVqe5x4Za6IJxFIiUBzzrx7vuCdz0+hUXXibq9uaV6CwFlGkHFRplAKiHYn8Asmldt8UU6FWzlzNL0zXiRsQ8z7DDjhfJdonXmdKWIcf5hmtNJo+ZE/xGNUvJM3J9s1SB3IiWvOJMqOZAAohtE8X6cHkUI0RxMRsogLJvCEzpQ3rsvHkZgGPPuk7ls0yK8xFbipH0cA07gSxBrO5sf9b/Xl5VLU62WIP3l7HUMcITn50pcgsAgX6lyDrWGwoX00GbH8K8z4lPZjqNk7mn/SIYKqDQrQ==
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
---
 net/ipv4/inet_connection_sock.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e2df51427fed..724bd9ed6cd48 100644
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
2.50.0.727.gbf7dc18ff4-goog


