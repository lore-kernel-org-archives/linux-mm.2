Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D3BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9895E900017; Tue, 12 Aug 2025 13:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938E88E0151; Tue, 12 Aug 2025 13:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800EA900017; Tue, 12 Aug 2025 13:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF6E8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0000560D4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:05 +0000 (UTC)
X-FDA: 83768866650.27.F96652E
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28231180013
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v8dIxGBy;
	spf=pass (imf06.hostedemail.com: domain of 35oCbaAYKCKELVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35oCbaAYKCKELVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UE7+fyIYJB9pTP5Kh5RXBJc7LN9wQtEkFd8ieoqRGBc=;
	b=JKWUJC0BTKRXPBDy0EorZbHasfvGt4lHKpwa052w1fOeckP56LSIGti0btbBDjpwkbLdIB
	SiLMOeY+d2r6kW1Kjgq2HFUYTSBO4coUjXXyRwPpzbScmhtjTAddy8e16dKVWghNHxU5FZ
	yfoJmD8dzhfsWiqFNDFeOztwRThEPdY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v8dIxGBy;
	spf=pass (imf06.hostedemail.com: domain of 35oCbaAYKCKELVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35oCbaAYKCKELVOJZVHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021544; a=rsa-sha256;
	cv=none;
	b=D7quSBvSybxcuBVy+WqIj/1FKszjK0CRJ46qhAxCsWsN8r+UaTiveQRRDp+I2X6pmbBsEc
	5YiQSoiGYkMmnu7cqGcVHJbjS5/6PG7oDAeXijTFSMHOQKIsMxF2ccpxZyIwBPiIcM5mt5
	DqEb+6dXxzyqpIYxSDQOchbOiz1hjmg=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76c0039e0f6so6002006b3a.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021543; x=1755626343; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UE7+fyIYJB9pTP5Kh5RXBJc7LN9wQtEkFd8ieoqRGBc=;
        b=v8dIxGByulWO2lguAQ/zsrLHjYBHDf60Sc/TrkzIQ9z44guXOivNOfS6tFMmhhFeq9
         n4/v6W0dRBlCsO0Jb+uMNd2Q/5xPsF3hLSoTXaabCdore2xE7JeV8tKlouBrmuPbNM9k
         7a3KtBMuJXBqJrnSMJQV4Y9mcQ4LAvGwTi9O9+Ur6dGxvsxlBlLVj+zhMjNZ1EVMyP8w
         z62bKbH1XUlPnmyyxYtMsVuye9ql+iE4+8JHcW1S3dSIamMqXaPmUrxXVntfCxrt+OA3
         LoYa2L9A5+vgi0GuX9C2EyEbNQvnz6Fsrka6TAuuwO3SpyeOPMjeg+kAOM1wRHvkQP+t
         u5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021543; x=1755626343;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UE7+fyIYJB9pTP5Kh5RXBJc7LN9wQtEkFd8ieoqRGBc=;
        b=YM6t+I8MKvQmq25ZJ9e/r4Yi+5719PoABPKwJ7Uy3bLAlrAqKt9zeUoiNqETyh8aDJ
         6+tQIZOd4XPWdzLS/gsHL81CYf5fnCjqx1U6rAvHHpgOVROjGVHjOfIhO0HaDue6qX2G
         iT53Ze/yUG+h0CL6INhb4cRjMJrQpq4/ZdD3SbV3i6ZCK/vccHGNHgJjsnVRwUWUOPH1
         bDCoWqu/M3B6sBBxYNuUDQob839aXMFh795MK+F+oVpe/4udfwJTe440zNaIs4GwYZDV
         o/Z5HaLg0HWPlToUTlX6ELEusnlxaWBQxQckkBwM6xDzO04Fgf3Qzf/BtRaXw79Y6sZa
         JXNg==
X-Forwarded-Encrypted: i=1; AJvYcCUeddf08H60tiVn05bu2EQnwG7IWLBiswQ8O1nhD6R5sKJcq6YZHgN45mRTTCVqxnov1jxoWLud7A==@kvack.org
X-Gm-Message-State: AOJu0Yx0hK+j0UDcULx+uBxm+6a6VuWflnuvhBM0NvQKLmyPzWGyWDXD
	i2rHRWcu9NBa5WwVeKcjDdGUT7qTFCLGtnlWS56t8Us1076AS1Jq8GvV4zn1El+UCkGBolw/yb1
	8SeVshQ==
X-Google-Smtp-Source: AGHT+IFtBSrb2xrrpV4Km05LIJWdOq8vUPj5EVaB8QdNd7zmXRO48lhifltEO3FaesYyLeoc/sVTWfW8tqA=
X-Received: from pfmm1.prod.google.com ([2002:a05:6a00:2481:b0:768:7cb5:740a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1910:b0:742:a82b:abeb
 with SMTP id d2e1a72fcca58-76e20c9bc63mr181842b3a.2.1755021542861; Tue, 12
 Aug 2025 10:59:02 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:23 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-6-kuniyu@google.com>
Subject: [PATCH v3 net-next 05/12] net: Clean up __sk_mem_raise_allocated().
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
X-Rspamd-Queue-Id: 28231180013
X-Rspam-User: 
X-Stat-Signature: 7ckssh6bht8ur7qinki6gokk7sh116u5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755021543-458679
X-HE-Meta: U2FsdGVkX18ZrOzmhrOW7Aa5kTKzFjXr9M6ZytVk/DxmslziqFpVWTfgmTTcs7x2JyzcrZgjXOq52wfUFYoCdnVvj3ZyP3ENIOnFjGxXzuVN/5FiSR0KfIYuTu2Wlw3V1XdrJx6KC6D78rihq/YeDAmbMO0wb2TFYKR5mLNS6n6lG6T9LqZh4T4Z0pxqYb+RH4yZ0ved6kMUtfUkxdKEMBRgyKNvPWUz/w7TYng2AFp5gNN98PexGkwRpedBrT+YGkxlP8JPOUG9L2DmEWja7uqEFSa5X2o3uK54BqUgXofgo4uPdCFtZ9uEQ9A/AH/4oRbenMBn9ims62DGYN3aLBY5u00SaGXbSLaMGoUF0aOAidC+IIjcaa9fmfW8aIME3YQs3deq0PnO8NxAX/JdHNZhA6KROeGfoT+denZXT+uNVblurY5x5ezDeGwnGPY7p6+lzyTJXa/KR7AbxysSXrLg/MvHlghVPx2rt9EaYrKNYKWHvAeq58Btzrq/YXp7jGj1Eq8RZOKmknkWUltCN/Ps4+h7Odup5ejYriUc6Z5zB208F7VaQashH5ayu7F5Vqbm4sobA76REvJF3E7zc38CqEg/0w60qRlIgr5q0fLTqpnXko/EdxaZ21NjKye/cyN9vUhuRIkDLUwQBAa6F3nRbxMURpC4PFUWuQjXLIqKqrokd4iOOZz2V7BPNvdYNXjAMKIpTgN9NO11dMf9rQydbUYE1m85+KBAVKiJw0QH537UWI4FCqpbwCGhEuFgUDx3KdDsZZzaELHtvS53o3Zwb98NIH019P4PNbRjtBJxobp7z1LKzFKYy4KvNjATQ0kszWuyQLSDnWZugKDjlCMy11vL9d3yvKRn6Uzi6HT9RAfZNESS9k9jj+XJbv7QVevFAcHRA7EKJ0TmAX+TKzMc/xiyB9knBVHnznktZlAZ2S3kNYetIwzsVSVoI76KTFplwLNmnTQqJxQsg2N
 090QdEzL
 N+iWvN52r5o3ZDTujATU6bQtFdREFQLC/f5VEyGely7Jfjnph+27/tPFyR8eyuVf430fowcfCwn1DVz3UzgMR7Fu+jWcDY9ndEZy51ercl26wOgsnimj6PFL0xQjAbJYaQoNYYYbkzi1yfLIRzXrgimQ09CLvoOVLmU/djGmKJRMlEREbhExLqog/C62rW1sBkuNURABzS0jBEZNhPxx8MEZsVLxv4M7hQzkS660piNy0/NGCSNVhUzaERHHDqPQE6vgF/5AtMFdYN8JfvhpsXvaEntE6KQrIJ97OcGEvxfjuvQ6qX2JGxB2br3h9VWIkCoPN8L6XjUYghy++GomVaOE8RMGCdp0pZTrHjYphrm+sx/do/UQG7SDMlBFLp9U6hksBMIXH2a5r4mOZP7YzYJjcq0+N63a1V47Ap5L79j7pjwNIF530RcJde0u8POLX49WYvXaEn5o0jas8Tkm/RyyvDO2VngO0gKuPL2RfwWLIkY1q0llHSkpyW9oWjkAtFNk+Vun/2u1sIhExQl/d0Di8JHzn5opR26OwPI6FuxtEcaWvvewK9lJNloiV1afiYllyv4IPjg0Vt27LAHOz2NmnHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __sk_mem_raise_allocated(), charged is initialised as true due
to the weird condition removed in the previous patch.

It makes the variable unreliable by itself, so we have to check
another variable, memcg, in advance.

Also, we will factorise the common check below for memcg later.

    if (mem_cgroup_sockets_enabled && sk->sk_memcg)

As a prep, let's initialise charged as false and memcg as NULL.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 380bc1aa6982..000940ecf360 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3263,15 +3263,16 @@ EXPORT_SYMBOL(sk_wait_data);
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
-	struct mem_cgroup *memcg = mem_cgroup_sockets_enabled ? sk->sk_memcg : NULL;
 	struct proto *prot = sk->sk_prot;
-	bool charged = true;
+	struct mem_cgroup *memcg = NULL;
+	bool charged = false;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
-	if (memcg) {
+	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+		memcg = sk->sk_memcg;
 		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
 		if (!charged)
 			goto suppress_allocation;
@@ -3358,7 +3359,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_sub(sk, amt);
 
-	if (memcg && charged)
+	if (charged)
 		mem_cgroup_uncharge_skmem(memcg, amt);
 
 	return 0;
-- 
2.51.0.rc0.205.g4a044479a3-goog


