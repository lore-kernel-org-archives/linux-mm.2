Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5319DCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705618E0083; Mon, 11 Aug 2025 13:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDEA8E0060; Mon, 11 Aug 2025 13:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC858E0083; Mon, 11 Aug 2025 13:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46CE98E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:31:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 056C457D50
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:40 +0000 (UTC)
X-FDA: 83765168760.24.1D3AD2F
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2832AC0013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZsnK0bqP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3-CiaaAYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3-CiaaAYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754933498; a=rsa-sha256;
	cv=none;
	b=fsHnh7AEMWnjxjmwOtc2MuQx5Xuk/HAi48pwP3sR+Qan7WB2+E7VTdTzhZD1mjW3Wkw4LK
	56GDGK4II8oz9T8Q5cPojKUoIk49zhTu5byatdLMtMUtwFobKJy7ZSWOL3JBLMMaDgkYvf
	NByhoy/c63mFqQgq4MwXizG1KNoK4xc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZsnK0bqP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3-CiaaAYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3-CiaaAYKCP0pzsn3zlttlqj.htrqnsz2-rrp0fhp.twl@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754933498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2qfuFeHIs9pZcvOOidK5ttDb4kIntPZhb9KYt5G2e4=;
	b=n4XwJ8pqhgTeItjeaftsFd0U3J7RlTiNmpnH/gN2loPBuB6J/f24/E621udUHcvhLSRQvZ
	vtjdbw2CuMUmeMJqA8xHOdHnkGa/O9XDjyiqtXddWxgll9qxXGsjzBVH+DxruyJKMcYgIf
	GCd/F+6E8XfxeMsBxIg8xA3XHW67M+Y=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b42ebea2f2aso1776503a12.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933497; x=1755538297; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2qfuFeHIs9pZcvOOidK5ttDb4kIntPZhb9KYt5G2e4=;
        b=ZsnK0bqP1ryKkAqyucqKJzS/c+Wqz4HLSqweRgu8rHPCz40r8eGQd1a1tCDgA4EDBz
         0oW+5FJhiuTyZZrCMBXfdK3l02/Y7PNgRDDgN25L2TI2wvdlLuqg4vY5qp64hL3ACGJW
         0j8+pEhje99B4smHTq1SsZg30xOUC1ENZV2GFkse30C7i8um51/ocdfcz/ymqSUzFjbM
         SMcld+3MTM/wAmf13cE+x+pV6DaxGBaTxwfsz/W3OwAY3RD9LzvsyevY9ZRr8jfRAREB
         DYblRtsFxUniwRtqEy52KZoIJApBhv3yfHTaaJ3d044ZtjCfZRVaQhuO2UBTlQz1eJKj
         1B+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933497; x=1755538297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t2qfuFeHIs9pZcvOOidK5ttDb4kIntPZhb9KYt5G2e4=;
        b=l68AU9wvJs7LDbqLnPluQBL4NTMe1vqI1BpL3QJ+7b9wwqy1sH0AyLYYJl9QPUtNQ7
         Rx9JFi9lvw6jpZw51pQok6pNLgn1nMkQZgE7Q8JN/FCv79B+10mr4V4hjW9UHr+ExuOC
         LAO3f7g0hsOriiSxN8IJ8SzchmbkQqL+65jxcUB3J/bBAvQPpD0conYbkYdAEmrMFxVX
         SdTk9YOiesfqwQfkrpjQkgeOZkaZMhX8Zt4iVDWMm/tQIHDhUX/QwuEeDJf79IzAc2h0
         ZNeATcE7Yyj15FE/D9tw2umjgm8ablx7HpJ6nPDH+lHa+o/XOtx/zXnB8RFUaGXsaiLj
         TF3A==
X-Forwarded-Encrypted: i=1; AJvYcCXKpx3acaaTAWbQmnQjFmFyxK6992dEYovfaTiXDYLTI+jX+3VjLgWdxOwzidWRByFds/p7ZYt6Tw==@kvack.org
X-Gm-Message-State: AOJu0Yx5WrllPU3gbL71xVZwZrHNgykPyALA4zhEYGSDkLgnJBZa81Wn
	G0VKZ5IClL9EUPSAqsXXiQQ+DjQi4BybmOq4H2Fqoa6GdNLhumcVFWQDWUejkuLVlcUvMgWJzcP
	hPXvwkw==
X-Google-Smtp-Source: AGHT+IFCL/e8m3EpZsorqhDOQWgbVKsvSbTHCyrTvZCPhbJX57+yQJEYtdDdTVRR3b+15GDZLagPnHJ4FnA=
X-Received: from pja13.prod.google.com ([2002:a17:90b:548d:b0:321:abeb:1d8a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a23:b0:23f:c945:6081
 with SMTP id d9443c01a7336-242fc31aeefmr6642605ad.31.1754933496988; Mon, 11
 Aug 2025 10:31:36 -0700 (PDT)
Date: Mon, 11 Aug 2025 17:30:32 +0000
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250811173116.2829786-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250811173116.2829786-5-kuniyu@google.com>
Subject: [PATCH v2 net-next 04/12] net: Call trace_sock_exceed_buf_limit() for
 memcg failure with SK_MEM_RECV.
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2832AC0013
X-Stat-Signature: kg3xxwoik6sh4n9i99njedjpiasjh1s9
X-Rspam-User: 
X-HE-Tag: 1754933497-490841
X-HE-Meta: U2FsdGVkX1+539YUnq5PsS/iboerXUtzXXjWRMFwBmQLnwZSitoPJrj2PL98cGXwXJOeBrLVubSIw7bBH/myw964I/H1oZUCrUG4j+NhEnUJX//LvP7qzlwOYKHUGvwkjFIfEuiiES6qiZDF+4eKcuCrAsIKpoGmcpPedI8eaPaW2MILCmpWughcLQvDgP63qhLj0EQC+E/S0oHNfGkrJUUvhtdhWgcXhieCWi99+IZaUs5ZZAsgRaS38TdFLuHSfoRc44JwKjBBq4YRPytABdI4cNg7xzDrm/6Lfgx8A2utCX8B8oxd9pUKrA8mZd0V9NcMzlUVZY28O2wy7j9pLtqsolcqwESDsXElmk/wum2WSfVVgiAVDiliGDNAlSFMfT8n2qWueMGgGyemobiVgZdwL72nuxwNXWzf+8iJ1bS0bQkJLz8EVI9vrnB1iiW/rvELBET3F/EXLGz6cWWAtek2sBTqDN6jzSa8GFPCdzuWQh+wWhMKkLnl5RBcRAjm7IBGxBAt2kvBaEWxrGGKsD8AcP6yxo+XXr7FwMT+9O28YTS8cpJ23KBiVxAtNMPErtmnoUuMQ8tVZKlxI0tKYwhySdvGsaEMkAGyR5e7JSeK5N2bn7Xb95HUEpYjJrbyScG0QnyJvLkP22/Ne/zkl+kTcgRtzDFTW8AbojD/+7w7gJL0uinGRgKxfK3HQDFSAAuBH/5yIZduiWqiEKy9o2br9My8EhF8wiiZJZcCFDB3XzMN4CoFL+tXi2LRrdJZLrEUkmsHUhT1sb8O8CHuTm6X4VJDkYPT0y0SHotSzOdXDHuvh65jp5yZ5zgjn/LTl8SFG9OrwH5gYAXcsyoOuudbN25XK1hOhqtiIJapQDNo46v/wJDHzprP+Y+K6+wZvegRCshhkIucjwGaOBMJ3sXpOPiE3RAa4ZdswBXJWctkLu5q4ptrAP7bQ+V38XdXUQ9+Lmte+sAdXkGXSUD
 WxTldXJP
 BfWM6cDmKj8XXLVuVvnuCDGckqCiJtp4BLL9WiBxobSmUqByIK299qlhoxTfoQ8w9VP1lOQFwfKPtYuTAkgjhWH11zCTyYCnGScUNGXwa1o36PqFlV4BekCmB7jkAsiLXiI/52xoIxOdjUFYJHtrNObFcvHlhhKowBXSKf5X+GFkbWkb24BLLch7sn2PybDpO+z929OQpispOTukrfT4e/CCoYSTY9QIuBMvM5msy+gbVDGR835iQKGH7s8Utk7Hk7Jkp8qnhtYbK13IFuXQwPyiPOzN7EuvEL7ojdOjbafctd9WS+y1zqTTHO40Gswocyyix9zapoabE8eT4QNoKU4Ub9N4zNpQPUSYyPNl7K6jxUMvUkGutPuoipjosl4mM2GEs3lTeygOrDZNc1rf0TULoZfG/4Jfuo6hFdn6VqKeAAgT6DQz++9k6wMKWJlZQiY1Jo9NEtQMBPawX2h01UZI3jRGJb7E9EvnOVW49YHJEqf97j/077oGUr/7Wi/nuLzkNr6AGlt6vGWnQIaJgbOLuPvFwjRWJYTPppZOV9X2vACLPSG3MHJ3nJ1zVr4CpPa0JybbcpZSDMmttcL9sLJDmXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initially, trace_sock_exceed_buf_limit() was invoked when
__sk_mem_raise_allocated() failed due to the memcg limit or the
global limit.

However, commit d6f19938eb031 ("net: expose sk wmem in
sock_exceed_buf_limit tracepoint") somehow suppressed the event
only when memcg failed to charge for SK_MEM_RECV, although the
memcg failure for SK_MEM_SEND still triggers the event.

Let's restore the event for SK_MEM_RECV.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 7c26ec8dce63..380bc1aa6982 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3354,8 +3354,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		}
 	}
 
-	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
-		trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
+	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
 	sk_memory_allocated_sub(sk, amt);
 
-- 
2.51.0.rc0.155.g4a0f42376b-goog


