Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5174ECA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A9F9001D2; Thu, 14 Aug 2025 16:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C49900172; Thu, 14 Aug 2025 16:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83B159001D2; Thu, 14 Aug 2025 16:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71428900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0DDB16073B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:23 +0000 (UTC)
X-FDA: 83776452606.27.2835E06
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23111140015
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yMVYGb3m;
	spf=pass (imf26.hostedemail.com: domain of 3cEKeaAYKCLkjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3cEKeaAYKCLkjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCan40y/zjv6ovcMCtQie3VVVYhwoaYNuUUlLHYJCrc=;
	b=z4NMvNZUKtJzUtjhYPwt7x8xdlGtJvNd9csSCf9Vf4Clj8EyD2vF2+qiKF1m3kvuRHGM5H
	pUKXzQFOiHi3j0K+WSjyu3LYVQ/zqdIP25AttF27QRPyBWTmF3UGXGvB/aSQ/leyn7eexN
	B6L3O2job9jsz2xXvx/y5zIQ7MTrbuw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yMVYGb3m;
	spf=pass (imf26.hostedemail.com: domain of 3cEKeaAYKCLkjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3cEKeaAYKCLkjtmhxtfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202162; a=rsa-sha256;
	cv=none;
	b=CVrr7e110PmTG4S0a9C7feyZZ2un+tQRrQXlaeH95BNsIpUHsUztRmDDLngWuXgo48DZ87
	D8OvRZctlD1YFTvU0lRtWmS4Qycr85G2oymYiNq3MiNhepLxfdeBikjvbXFdDtD/l0DXH+
	ioA2XvGEp50EJDTHZgC7r2uu+BuS5iU=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24458121274so15659085ad.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202161; x=1755806961; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCan40y/zjv6ovcMCtQie3VVVYhwoaYNuUUlLHYJCrc=;
        b=yMVYGb3mA9zBUYyO2RyX56uDihkaEg2y2UaZyHG45MAmuDCpPv6xcWfHaEftIjLnUf
         1KfDfkmahXjo51fxWzEGsrlZJCr8+ztYxy6Sp2N19vc4pEOd9k/5uTisDQoPI8JAJIFn
         KN/LxMnSe8B4KXWUQZcqVMm0WJB8Nbl4t+ezKSEwgyIYytLIsHLeLAwNkAs0+z0TlF90
         L6uktSzCljSE4dVCkB4mEVsfMo7W1f2AV2A3drZx+yULZo9zqSziRLajGL/J0Z6WAKgP
         XCHQRpcH2sFTTd51orlLBaOW1NUZM+ygjuR84puOmHIvh1Y+2kbXjAuQld4XkXr4lJAU
         qzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202161; x=1755806961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCan40y/zjv6ovcMCtQie3VVVYhwoaYNuUUlLHYJCrc=;
        b=mmknKfl0+7ziDK6Q7ah779/QycD+/FBJC/bQ2MbWyoTegjlDKbviS2zcbJlYJF3IlH
         kVavd36oYG81rqf3qSTZRb7wdUkaD9WAkw0blAxT4w+8V/qzmSgxHWkcG9h0qchoNJfu
         ScuVD/8VRpbv3+m1D9inNvE5skHOcHCE8tvAoUixHGbLp54fCc0TRr//3m0Dl/5B3YYM
         XHaY9dxIFDU6BD+rjhrjBPJTLzCXKKdz7bw1NBOesdEfVg4F8p6roOeSiaT949LKWtg+
         BbGoQc3muCr2gozNCm5vdyANmnu8tiy+WL8yD0nkGG3L+bu7YjleFd9oLj4iD2UqPIH+
         w8jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCEmuqIqF7GbzkzVLhMgqTEKN27AKZ/Axyrm+rXrBx7oK+QYIJddh+ZfOeSRBqBgwchY33MHQV+A==@kvack.org
X-Gm-Message-State: AOJu0Yx331MRJRroGb+Vfh1W8U6u54XcjNB4od1s88AMRyQMuhA25I4E
	YExpzFbDFy2TZu+Vn1mpg5r34uYLucBWGHbq8+LKlsFSSSHHe+/PARSG1SPsHCqlVqTeDIXd1tj
	IhdLv2Q==
X-Google-Smtp-Source: AGHT+IFZG58mv+xFex5I3IvbaYDViC565d/Zaj2y0+6TxgO46lJTn88mwWlXmxsJcHxyM0rDApPblLTIl7c=
X-Received: from pjbpl10.prod.google.com ([2002:a17:90b:268a:b0:321:370d:cae5])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d488:b0:240:92cc:8fcf
 with SMTP id d9443c01a7336-24458b58443mr83319395ad.49.1755202160983; Thu, 14
 Aug 2025 13:09:20 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:36 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-5-kuniyu@google.com>
Subject: [PATCH v4 net-next 04/10] net: Call trace_sock_exceed_buf_limit() for
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
X-Rspamd-Queue-Id: 23111140015
X-Rspam-User: 
X-Stat-Signature: trq8tju563od6cguo8gbmm7brncsbc3p
X-Rspamd-Server: rspam09
X-HE-Tag: 1755202161-991665
X-HE-Meta: U2FsdGVkX18mc4BLrWdxyP7+VsC2Tqy7l+xjSZfU0aHhSFchWDmUpcoJvcDUlW/g1Nxl7qoiBWc/rjS5Q0fqJb6QULYCvd+9el37QTIOlvmy8oRwXAp9/oYhPcWCz//iL3kInk+ik7WUAVHhkelK814RV5SwZMlnXKqIbRFllQeCQlYHWHp4AH+8ST0MpIh7/JrPAszao1eLUGSBiawQz+4oV+WFushbAlhhzJFrXi8JPukP4IEStm48/Ff/2Ga5Jxhj9T+adEOZ0EI+InwRqDW/nt/GUEEZaOJ1C8DTYxp/N097FE30ck3Uq8Qrz9qbmT/53PzdkhaAZ4Z7qZprePIiiEigstkKXQd74BKZfsQW6c/ejWciv50lHNTjXaNHfKTL0NRitq4p/hu/qQcxSihnCkcPCLHLVvMuyTGJnefFsOMIApM8pgOQVRITLfJJpJm6TxzFbLxAjs7afZ1CeakXfzueVeG/VKmHbuKBwAV6mJBWkyhXBV0JJFjGIsrkjmWbhc9c6yn6tVLbedtBDipd4b3UEoP0RWGc9fa/efnlZM/0bkX/MkdKBqf3fL6bg6qZVHrmlUVhJ0+oM5O23tY1s+pbPm1KxsmyTk00gT3x4bgWv+HNJiGFKJ1l5n2F/dpGoZkkKZIjgfYhGBXkMMyB5Wcz4Rc0JQ7Mls3p5KDoTb5NoLxIh87K3ti8k3FFv1u8ZTD2HiTeJwNxxBFaABrMahBfKduFBw4Qtg7LU3fLHpYyv167o+gkbeoBQu7nBtV+HyIb8EBpx/QO5K060VXEafUNNq1tfOAgshXsLW6psMxKpCm0G932TbAIdvpqZ4WMZjCTdSiIKRScrlZ9zupa8/JsHr52v2NsSvIRMiVU8QNwmx3wZL5nBpTJJbqlqmFLgckJi19GWjFw0H++jiqTbj2dvqaRTY5Nr4eW1B6gwDq1ai6YIV5kz/LvTSCYkrymmu3DBPVoBM6xce4
 Usj0mcRF
 Q9xYht1Wf/LJHtuOuB3I/55+8y6a8KxN1HnFmB0rUz0nHuUplwriBIzNswALqcSW7a0BCeaDhr/aMY8uDspOWv2I15w9RiSewvPuBQxq0XD3nngtrb+anusKRFDifVAnfYd13mjL+Gzwz5Z5v2pBhQyGagzzG1ZV9bvl1BKjGPsU7htDjr6SMREkt/2+FdjYGYyL/PwMfa38XfQv94l8Pzd5cD0t9Aq9KuHjJbgUfYq/2IIuuRnZOAM8TDiYH/kwjTSDimBMf2b1DxfP+Kdtfh8kkWilhnVQwz3K32EMJpPtX7XEFw/65d/gz5zIXPtCpXANy2o0iFxq4OlfqSTPd5Z2n2eiUnD9siMT8mj0WkLvonJizdo5X2mxDmXH0y2VjKFtNvTRynN7rizUfnwJOclWj5nQ17uEqJQCEycwDyRZzPnPO6WvXD0ill6EGjC3Bdkugrp4eTGp1Ao85g31w3jF56181RwZMex04hk6TDuC1dwyCfNP7FAw4QOyQbPHQrfxozH8bE47oencqedJJU5cjC9LmeFEfkbF7qKsNqWECxhzt9UeZ16nkHyECk4ns8vmclZXHseyyRmw1XpOnK8UKjg==
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
2.51.0.rc1.163.g2494970778-goog


