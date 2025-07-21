Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25207C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA9C8E0003; Mon, 21 Jul 2025 16:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AADF8E0001; Mon, 21 Jul 2025 16:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0C98E0003; Mon, 21 Jul 2025 16:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 663BB8E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7FB5B6C13
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:37 +0000 (UTC)
X-FDA: 83689430034.30.8E55B0D
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id C833D140003
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dD7SmBvM;
	spf=pass (imf26.hostedemail.com: domain of 30qR-aAYKCGEJTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=30qR-aAYKCGEJTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I175s6NxGih3nP7OcDsLqMOyvojLdjw63UOF+xheMJ4=;
	b=AeA3Za6lQP2PqF/eoZ46uDY3YSSB5S2AYpZ12m4KrEaoLpLH0rPrcyZBiKZ1e/yie0Z07K
	kGSn9lDqvhgstKjj6HiJkgA2RgJ1SyFkvrtKjglkpXu3qXtvMAOipY7tabIbyWOCc4MssQ
	/v83K0PF2U5s4PwbL21WRWXQCkGcrKY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130195; a=rsa-sha256;
	cv=none;
	b=BTcdZqDKxiw3OISTOpunYJDgzMSOWvjDJ6uYsk+6e/FjbXllAo8d53ipKO6Zaa9NVPd0ih
	iSE84gq46oXd8JdNzYWnD/P82HJEsXos4NZEWUj5pUK+ncUizBYxBaCDT31vjh+FcKs7Il
	QSPillTDQGa1+XfNOd82o4u1txONL6w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dD7SmBvM;
	spf=pass (imf26.hostedemail.com: domain of 30qR-aAYKCGEJTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=30qR-aAYKCGEJTMHXTFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74ea7007866so4348953b3a.2
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130195; x=1753734995; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I175s6NxGih3nP7OcDsLqMOyvojLdjw63UOF+xheMJ4=;
        b=dD7SmBvMvW7PHDfxa0W5ya1HJLk58T/Fqo7FQtr28mL7DIg1t7HC+DWqKZ9K3tI0uf
         yfCBa0d6i60ahI8cVdkYdxvFS5eAoAsLKbKV+BfTjN0iyaQfJ3/1H+sbksUXHO/5/xuu
         uhqeFBwrf07LUhAb848obTktUpRWNvCvl4XbCJaiiSnYI05wA0m1cy/U58MMv2rwIFmU
         uG5Uh8DkPox2GiqmJsAfEQhZWfFWrOub22C/5XT2OrUZRd22Xv7z2KVmYqsxid5/AcMt
         ADnKwuIwrdrHenwblevyN1gUOkWW3do1sOFLPEoP8hT1R/VFLBDjZVG9DC6Zyee++qg9
         Dl6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130195; x=1753734995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I175s6NxGih3nP7OcDsLqMOyvojLdjw63UOF+xheMJ4=;
        b=RqveMCPZg/Qbgg+76TVy3JGutZniokeyKRHXKV7DnnJecbG9YZ8m5QzPgJFBT/E0i5
         3TNAYmGdx7Mf9rG7yu7x8DFFDE9EMcGGt7uso0gaM8Z1fl7tB/bExaFLrdxQA1WcUbKm
         hJ+62Biqu4FCzsYd+4fROc7W9zmJuc3FjESwaQ5+fe/INDyonx6umTj5pNAHUmjvKwrX
         TynZcYBlTPlIkbYWRYavMOLoNSgaptM2huH7fkSPA5ClKyVmA9U282sQLOBEKBqMT76u
         zydl97grn0KH594wVpORyO1me3kzEB9U9QHKwRqTOqQfGIYXYwtW9sDBV7hHsVI2XI1x
         eFLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYl//w08K9lvlwGZvYSW9UXHhivfBX41TAStJwWIhoiW+n4BLrba71GtxfchjbJDaOllvpgptoQg==@kvack.org
X-Gm-Message-State: AOJu0YyqNzwiblNS7vOgZ8LwxqcTCLV2ItCT37aFxG6oZqbtC27A5FEK
	Bo2hIQIdsbvw/a1fYEtdPOxC8Usbzh2jz7Vb/RGY3CPDHZJ7/oPu/nJsXuhhLs8RDJbR2rglEoq
	rlv9trQ==
X-Google-Smtp-Source: AGHT+IFv6U7uHL2iBa9yupFYshgEXju3eOkU6QMVmKj+fMe7znAZlxzbdQTya4Ql3pAJYEeoSFGsqqqmF3U=
X-Received: from pfay32.prod.google.com ([2002:a05:6a00:1820:b0:74b:54a2:ff33])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f86:b0:730:75b1:7219
 with SMTP id d2e1a72fcca58-7572466bee2mr28714696b3a.12.1753130194603; Mon, 21
 Jul 2025 13:36:34 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:24 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-6-kuniyu@google.com>
Subject: [PATCH v1 net-next 05/13] net: Clean up __sk_mem_raise_allocated().
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
X-Rspamd-Queue-Id: C833D140003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: g7upkq7gn4p4zb1c6geixijftmdy7wpd
X-HE-Tag: 1753130195-881868
X-HE-Meta: U2FsdGVkX1+l4BY1WgkFTkO4vXcLf8ysz5ng31tZymRtmPjYm4lF18UJdXZyWfOv/eWXLMs2DEfflc9iJ2VdyfGg34PXkMffC9RtMbCYMNC0catDqVt1H763+6Ivel1kT5VAFuBc/NuLHP/Ef+NLZNYsbrFCjUqv339nxizYbZf0IjxrsEpvrbwkXZQu3kZNUI1etMNmLZdaxIqZ3DdPQ+aXANsIKijIGQE/LYE2APhn5WCemNG9fNKmNvSbAmCjilzUNpG67/4lZrM45MbWQ3VxqfcSWDavGYU/+6RUjezk0Gq9EfLi954TwviWkYWby9YFc9mZ8CcOaXLPEQDp4f+FjWH4m/oRFfd01/3QhtGmCAaUxPpph2YHi9qBlMmbOe+ujO2mF1rvpEo9dnIdYkRtkLRSsyvGtAAyJNta4QyOaHlleJfPqqbNPXVTXR/HUq5R/GuliGPVwWiSakKOt7z+Sh0oa+ObLYzPWL8Zo+XAu06Qtzzpo8jdwHh0HDRbTwQmWyQJplbmQsL5q0op72RYxqtp4YzGbiYvk/YtOwnrsRbXYgqZ0BSHmhrO1I2tPWu5DejrGweZz/GrkvhI8quEcVbV02PFKEekkeBaurIorAVURhxRwyo+cX6YpuRkYGjGvbnO11mVzHIaCjNoBM78H8yisjpLNDrnKCq2S/l7FcRv5yntrWOHQr20B16YRJ8Nt8rMsiPYUJ8Tt+s0MihR6TbUas1FQNuemxw3M0ynzsI/k4Dr84aIsKjmuflIJmheYxApKbOgsQGO7ot+QmWnn7ekyYlk9QA1mj3RF6ubtNClJuWQc8sLRvzNYsnIW+UnaF0phNaL62xGS2FA4wgiXB+kAcbiriGzGw7HfSHl+lKY2L0pHnhAOyffHxClc5uQhDbLCldSkSV9HUWqGn3wy3U9hYdIBgOP79F6J9M85z+TH3J17zLloa+FWcbQc5Nmsbr+p3yuoFfjLNu
 d2u50CNy
 4h4+HgitCLzLQoy+OlUjd5ASq+9qi0TOBYVwL60c61jV1XIUJSVuKfdA9Ry/+4+W+wp9skbCWSK+7T2FvBbXBlOd5sWqvRDT8CC5D0fW8FUYqajrfeQr28xS0NuhtuIrg5ojQQDWyp2e2O8hUryYnKLtD2m9UOmR4zhagavNVggy2HVXItoB7Siz16EflYBv4IR+SJwY+rfQRo91qZo+oA+XkRN4FgA7RIlHt+QUgVQRvfmvh+fqbFdJslh9z+mSGVu5Y2AY+X0w6DtCjh5g3Wju36goaDHLocbYPJrL5qooqK/wlThGQJPYsHGlxK+nvQkkLwJZgkigTQw2iJZbLLeA7mXWWr/C3WhCMKNnSaKFwwlee4FAwHhOtK3vAJ6fIoHW4dJ4Rqv04vZx/1TE0hS7UW0ySFzoDo7c5hKJl6CXpjJUUg6HghLt6sKY/TuJXPRY5JaZJVaNkSf5Lo1PBGQ4Kp+4mQC4/NN5xQI5CC6N67KZ0MWzqec2SmIVI92X66XzQB+m+K7oUoWo9eFxcp23CuZ80/OHVLnztU3KjxdTD1G385l1U7JdZS3QEnCgtwnU8B8MBmvd8TURJkt0GpeiF0Q==
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
---
 net/core/sock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 380bc1aa69829..000940ecf360e 100644
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
2.50.0.727.gbf7dc18ff4-goog


