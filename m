Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94347CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BB78E0081; Mon, 11 Aug 2025 13:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72AFD8E0060; Mon, 11 Aug 2025 13:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A368E0081; Mon, 11 Aug 2025 13:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 454248E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5A111DBAD6
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:36 +0000 (UTC)
X-FDA: 83765168592.23.F728F8A
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00D56C0005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Zbso/SY+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 39SiaaAYKCPomwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=39SiaaAYKCPomwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933495; a=rsa-sha256;
	cv=none;
	b=Z4rzaW0I9/qZmYM0jZuCLHHNAOlwBDre4SWbcfwF39O6TvoGOBwiuQMAclTbHAKpjtfKuh
	LwuO1qfoWMTmvwnFaF6Uu0CjZOfnef4SHuBuWU9zxGnfFIJbOMWIBnFlvH+b4iHaXGY3XP
	pDzAWio0XFIbMcIaUl3Q78p4uxj2uw8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Zbso/SY+";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 39SiaaAYKCPomwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=39SiaaAYKCPomwpk0wiqqing.eqonkpwz-oomxcem.qti@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJUMgP2fCvnJmK1Iv88gPtdmkhT/9+UsLcGRktrUImI=;
	b=YfD+oQ24+eUWRy1tY2YlmquNIdpqvcFoBjQukmYmjESrF+yFawjHilMQrIAq65FDvSUVqN
	cPvCh8s48i9jpOUMg8uyaoIlqOpawYARPIwKblsR/yakVW9YaHX++tpiFIgdFG6zBocEQO
	ze9Of629widVleJhVmzBvw46gPj36Rc=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f3b65ce07so8116429a91.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933494; x=1755538294; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IJUMgP2fCvnJmK1Iv88gPtdmkhT/9+UsLcGRktrUImI=;
        b=Zbso/SY+S8iPtb8bQ12d3z2LttiQrLEqa3K60cFoT1JEHlYm7BGw2M0Gei3xOp7i4U
         hZ+/WrlM4C2AEemvZzatDkjrq2Q042D45xff6ygKoUpdzzsDozdNx5p9eXLQsZbgvWNg
         C9y1HH3WYPBu2Qabg/Wl5BoWj5JeQAPYptqhm45aJLZE6MOKOJpp8uR7/ZrIDiP3F3hd
         5GwIyxkBVWqtDsrM464FdHkykx1r/puBfY03kFkgHRAR7TTZlyi/JScYlIDEXWGs/teF
         2xNsjlf+tCErq45haeyDKjTniQ8Oo/d6WnUQOEWieDFaX0hc+6KNB7fjSiJkoK1aec46
         0yNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933494; x=1755538294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IJUMgP2fCvnJmK1Iv88gPtdmkhT/9+UsLcGRktrUImI=;
        b=nY5AKTextIfSEL7+bFVU05Q3aQqK4Jw+fH4Z3IAXdziBiSgoizBGQoe+Ao9wZbNBp9
         TtuO6dhCgWSBkncjyY3b/FFL2OdPkyxLC+3AyWqnJJ9Usy7ctqUDRC0co9Gn0WSJjZkn
         W6t1lTJzMN6aJUWj8wlCF2OSvA/9PnM8oCmwQMbVxsUCQvDCFa28jdVYgPQ857y+AP0H
         p2igr2B+vFsxvaxvagkWlc0lHDUhRf7rTiRgG0QOjUdVQTOnEjGUe9tDfPreYBW2GHDx
         7I/yyG8+6zeG1fC8l2htIanLZK4lkgRpx1162DY6UuX1VrigBDBhswaRuUkyvYGvq5jv
         /DDg==
X-Forwarded-Encrypted: i=1; AJvYcCXlwrO8w6JtRmYn3aBJ1/6aGShKFBi/8BOKFKStS6iJXzihnl7dH0qsXiWNv/RUqYONkN2JZ6BFvQ==@kvack.org
X-Gm-Message-State: AOJu0YzhWQPTCakyjJX5xYjx1ATWQ/1kJzbOO20lEVkqejtHeU2BzEHB
	YpndNs8Fc7NrAw392M7oulAr2C3dEEFtFAiuHin0Hb+MOwwo6Ls6eTeTXXFJ3PSw+QbF2vKqirj
	mSd2XAQ==
X-Google-Smtp-Source: AGHT+IGLJHxtKJ3Pk5R4dgQvk7gs39J/mY7N5xl2jz8WX6Gc8LUYFyja4buobT+GhatPyGHT1yaWPuvm76w=
X-Received: from pjbsn13.prod.google.com ([2002:a17:90b:2e8d:b0:30a:31eb:ec8e])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2251:b0:31f:1a3e:fe31
 with SMTP id 98e67ed59e1d1-321c0a11aa9mr615779a91.11.1754933493761; Mon, 11
 Aug 2025 10:31:33 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:30 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-3-kuniyu@google.com>
Subject: [PATCH v2 net-next 02/12] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 00D56C0005
X-Stat-Signature: pm4xy8h85yknxawzfptoii5k5i96ifmb
X-HE-Tag: 1754933494-222429
X-HE-Meta: U2FsdGVkX18ZLH3t8DC9LjWZcsmIirNni4TiM+Le9r/vNY9yuA0HMjzhhmMHpZIV/FI0XlTtewQ91pGU0OJVUBSJp9UBmDIq/LpngofiR1YjKgK6FlXB3kYhDnI3w/vPTM19GoP8F4PpfduOnZwYIUrlinxXza/XPzwv29gKlISa+OhjAN+Rz6FkkLl9uTzkmiMpuk/oLKQqQQIBn5tzs6QXp5UF2g+jXcKfA5hDSRexNWCc3911hXfqIUBG8THtiUqtgVrJ+xFG5Z4iU8tICrIhrqnyv0HxDMJ1DaBEP8kvNhptB6egejxy3KDHFt9nwpNbpwNBzrvXq9i0JzCl5jn534TDtdM+tTmCyiiW2lvtjIjOIsv0NYxbda0DfhrVlQmtHkgr1GfFbNca6WnsujKX4gCEwPodx+p6ZiirGYvdQBczUQVIUNV2oA8oJ6Xt+nCFoGYTtF5WYeoC6OQP6PqdLTE7S5jsqIuPq9BfEYSjYMQljFQ8jGfttQdJC6L0o5AytwF3/LTC7Nd1KM+L/RNIwEHDo3kryHA5+frRwk07zCLd8wHZbL3IbDzXGXP2K0fSK60azgDfA/PDshIAbRvxSqQihmXkeuqVQnhHnsqzeGJFnRMSX1UAIIwVeVyw6A9tA8gxcyD6Puyp7kEXbmaqbkGjSpSAiazaQL+kYjV3ASLi+npGeU3KP7NgqmAcl79HHsMhNaCsdOkPxdBbP7Q2FmkMrbqd4of0ypHW2oCLkT3anY2EB6AlUMf1mYZ2mP/65JfkXRnHn3NNMDmxSr87a+v4HhNjkJzLqwm2ip026T847Q+AxfslbXxsGl6rdG94sAfxcVkbPMVfI9ghrLq/0f/vOWK3qMZ3DR+E2dLTbaR6jxELTFMQVer5fusrud5LQ9Cl8ckBhtPstGHXkbsisIMDK/RXXyxgkOgKtPqjSvFMNoVlqpavG4WAm5wRs6LHifFronKoVkNgBVn
 aNqUk2K4
 QyWaxD8vpsvWuTHppExNMf1Q3W6zQK2pH6ZdlEKJ+Su4h5NekkLG3xSmMNJNubCUJSxIMJsOPCdpm7eZQWYGPHYE4qtIcodEBuag8jI61DO5yP7RqB7pMnhzy1IHDvQp/fJJHCBNP43r/TknHOJhYXL5hXI8z6P3G23zQSEWys32OMDoeQmv/tpW1O/Vg8mk+/fBXG2NAOapWL0XCkVY1ZDhP/0mVeuwdlhbS9Tms2JHUpaAKoZ2TeTvyZxTFpVv2I2mqVXv+ZYgh6t/86KsQ+DDGeoEF6AkjY+ibLXspr+rxZFeBhXgK2bIrMkmL6UvsGZ969COKcATJqBNn7UMl79B5cng/Z30BrlmKlyOUJpE5QeY3jkHHj5f1pLlGGuLMTv1kUoi0BOvBeQKIXeZt9QHuFbhdOoHkHl3i7oX0LhpSkXg//gXTK2l5FDgYgwELIs2Ootp4cmt+O0dTqHLJAEmuZ+m89RuzFMpvGmiWgbGyVLxKGuDjD+L/LWDPZosUZnIPL5TghaIarsPhhYODpXhXqgzNgULgG0DiThvWlEr8n3VYKyBuSJk80DETqoV18WE0/DRgJBgserNcuZc+fg084Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some conditions used in mptcp_epollin_ready() are the same as
tcp_under_memory_pressure().

We will modify tcp_under_memory_pressure() in the later patch.

Let's use tcp_under_memory_pressure() instead.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/mptcp/protocol.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b15d7fab5c4b..a1787a1344ac 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -788,9 +788,7 @@ static inline bool mptcp_epollin_ready(const struct sock *sk)
 	 * as it can always coalesce them
 	 */
 	return (data_avail >= sk->sk_rcvlowat) ||
-	       (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-		mem_cgroup_under_socket_pressure(sk->sk_memcg)) ||
-	       READ_ONCE(tcp_memory_pressure);
+		tcp_under_memory_pressure(sk);
 }
 
 int mptcp_set_rcvlowat(struct sock *sk, int val);
-- 
2.51.0.rc0.155.g4a0f42376b-goog


