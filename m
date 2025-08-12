Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E47BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F4C900016; Tue, 12 Aug 2025 13:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7ED8E0151; Tue, 12 Aug 2025 13:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24CD900016; Tue, 12 Aug 2025 13:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95FBF8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:59:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E07D1351E8
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:04 +0000 (UTC)
X-FDA: 83768866608.21.134C606
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8BA28100006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:59:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Lz3qHDwk;
	spf=pass (imf05.hostedemail.com: domain of 35YCbaAYKCKAKUNIYUGOOGLE.COMLINUX-MMKVACK.ORG@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35YCbaAYKCKAKUNIYUGOOGLE.COMLINUX-MMKVACK.ORG@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc3v5O63MgSThFhi2UQQb6roBFqZjuJWPv2BdHmfVp4=;
	b=KdloPUgWph6lbNEC7afjJ089G+tq0DGIsXF1DjTCK3TSskuAos1Q9dEwnk1XACYnbeVnod
	ajs/k1Mr+ARfXxvkUGiXBnFlrNrDtZ5jZg5+JEEN5ZeNgyim2vgZefj3cPTw8dtcS+JIeJ
	fw6RkwpM7FBhc1BiYznDD5DV/HGfH3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021542; a=rsa-sha256;
	cv=none;
	b=Xwg0zIlQuQ1Xt5T6k4X10KRAlkOsI5fBA3VNbcmGt8LWKo+RaegYjNzi7dsRTUAXB8qFJv
	i/0jdLydkiT5K/MUsZO/4RTMmJBveQHN5iHqYZ4rAtAvZ8ZD8+7wrSJ44Jj22Rp+DfmPbY
	ZHQ+84eFcDINzErbe7pw+NnxTlVl5zk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Lz3qHDwk;
	spf=pass (imf05.hostedemail.com: domain of 35YCbaAYKCKAKUNIYUGOOGLE.COMLINUX-MMKVACK.ORG@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35YCbaAYKCKAKUNIYUGOOGLE.COMLINUX-MMKVACK.ORG@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bf3e05024so5388134b3a.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755021541; x=1755626341; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uc3v5O63MgSThFhi2UQQb6roBFqZjuJWPv2BdHmfVp4=;
        b=Lz3qHDwkKkEDyf41NlsDX/jBm5cL+c2qyRFZ2LfZY+66pxdJ4IwuYqU0uF4lrlLzkl
         Wc5dTh4Z2vNlG/0C9mNeiURgPLGdABCbnNGYUwPt+Fo1sJdLaZW4vDmgRtIKjiP81OUW
         O1Z7fVNlceu5oqM16SnVFUaeawJpyIKAN7P2thBELHNolU8/1z9oWK3kcKnWmRvKJP3o
         IWlPDFL64RVbVhNjDFv28taCOk0PtXeJKtPzdEtO5Q0eWTkwXwB8KyMYvnPAc3qAoUCu
         aTlxa8Xw6Des1QJKcWWS2B64FOM/muOewRUkEqWFHRWWSKZucb4xWnVvotSo3HRpCKNF
         N7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021541; x=1755626341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uc3v5O63MgSThFhi2UQQb6roBFqZjuJWPv2BdHmfVp4=;
        b=sGkdrmDTHztMt5yf5ICl4XAEEOYmrlNlL9JFGJH4zF3gWI90vJ6L/Uzt2zJDJOii5O
         rCndv4UMYBf0EL8odF2ectXcSY002px4juXcBhB9dx9kboW94JzePm+w8MJH6lkrL/57
         wAGLroI+uPDOsKevuRM+ef/Alqbr/DNu6ndeAgl/emARpxFf/dSNvsjrHi+h08TKJX3n
         +y2HHiBQu8hy09/c7MvLDrXmcme6VKA8a/jTKezzv7u9YKJpYcO54AIpFsrHzeySVXV+
         C565gu+k3OdU5anmpQe2q/xOJOwGp1zTTApIlHRIDexuybeAflioe6YN4Z4Wdi/25LSD
         fnbA==
X-Forwarded-Encrypted: i=1; AJvYcCWHm3tbPpR/SZ4IH5edeLTL18Bs9rbuVsHk7L8+WSPTVXnBgS4zbeWbCBAu6/EdE1pL2cyjxKdr0w==@kvack.org
X-Gm-Message-State: AOJu0Yyb7LZ2Tvjo3hB69tKzl7FBdLI/bP3P9dJzv+60EV5hr9PG91uN
	goBLvM3Rv+ULs1QExK3GvwHYq3g7Nz01DQWdHyu8OT7rXAG+acGmXsyH8oUSbfRr2fYr6fOku9P
	uQxg5/w==
X-Google-Smtp-Source: AGHT+IHNkeTr1IXEx4pv8zbKdsHdKo0sVR+9B+i4vxPeQfrBSyN50QT97gh1gKgnaZexsZ6oSyAsjRSzwYM=
X-Received: from pfbko17.prod.google.com ([2002:a05:6a00:4611:b0:749:1e51:d39a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c2:b0:230:69f1:620a
 with SMTP id adf61e73a8af0-240a8ba6504mr218627637.42.1755021541287; Tue, 12
 Aug 2025 10:59:01 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:58:22 +0000
In-Reply-To: <20250812175848.512446-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
Message-ID: <20250812175848.512446-5-kuniyu@google.com>
Subject: [PATCH v3 net-next 04/12] net: Call trace_sock_exceed_buf_limit() for
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8BA28100006
X-Stat-Signature: jj6s5tqmkzjp3isq1ixj463qohrkbzmj
X-HE-Tag: 1755021542-940492
X-HE-Meta: U2FsdGVkX18eBiknTdzX6nJH83mGfysO1xoiDFKjjQ5Bq8eitcuq721L6Yh2NYhnDRj1E387omuL/ltBsj+i+7PHQq4yMz663w6UrOz52xWSiPUhRNJawo5IUyUg0stHAgbwFfDPcUMwd244Oz404xCIiK9pqgt5eOLP9m5FnlqnLBQuA9uW5MFLh2U0P777xxTP/GJFF75mzcS4jNvCV3K3L0qcqP5DNiwVL6CxUCGJZDLrmUE2+JGBnTf/HZRIJHH48jSFEVoyxxUR2zRh0Pklbu4UNs/7Aj5l5mNzmA3PKG5bsfVdxLGrQen/GSiOGh4mD3kMqpIqrd6kJMp2l2D6kMeuH2Zx3GtGldYbwmvvuMN4EncaMQyAqK4tnOkFj1zWcAd9CDugNaywTzdEWtlAold+KOmCsHqwVQHt0unGpSZ0+r41B1JZdelDJrliJjxNeOhuFOHuubPwgTtIPmT3tT8TGeg7xg01GWtc4HzLj/MRUqIa/TyW2dKgGMzZjUpjJnhUHdAitcAztnQ2ExL9FTnzWec1L7i1L8j9lej5Ds2tuVd7jQbUTstIeDqc9CdXpGN/1ntQQp+XEg376lPhbZ24wL9Nbcq/OHcaJjEr5sy7EKnbINVK4VdTUFkNpvGk8aLAz+Ly42SHPoILp6AvvremWebktG060dtYBfNyeWjbeYT7bEBOQ8HhNLsan3Iy6MYnHUbs3TxiOBV8m5PYdnOA4uAbLvsrEayyLlLU1uSvKwyZ7gh8CP6sZ0npXAWHQOEMWthaPlXwnaA7/s3VQ1m8t49AEzNaOGSINuD/odjrhwlUrSCpZslNyCoaYHo7BuIZTd4jaRRcmUYylVbPhcIOCfB5P5rIy58a9EcxYFWA4+6Vt8uittqDP4/RPdNs/f80hvo7QgYAxDLSvc69kiQkp80EgZbSsXJQFoEfo5eiNm/O9L7kAPNWGQKrc32g5w07gqkiVJSSrlT
 kWFeU6V1
 u318rOQ5SEL8EXodK/l2TXYp+DNY3rIhMe9DU+ic/01NMlnjOmuzE8mynrbu3PXav+nhiIWHH0OB26tfRjJozUjQBXoT5H+NE0UPpGXp/FZiRyTp/6pnNfBxLjgjlpbIf1hui6i2cpA8QCfUGTpLawcG+7LHGo1nUq+d2eBhSXM4oPYRCJl2bZlppyycY5hzO2hmhjJvPT0eAbEijDSNMwHy+s5ZB0fpA02ouXSFbi7JNkJrz3K1EYhp0atQC1qXtyb/Umd0JIvTauAM0LD4X0e7PhoaHd7ah3H+kVA3BVeuUYduAWcFRte/qV1anuMtdWESHrxl0lUBMW6IbqunYKl1v9YGkTFmONYQfoQG8ex5TQmOQcH/wrzebF3Jql8ghejAXEcIjWn25sn7WAB1L8TdORw8F12GXXpDRe/HP1A0NrfuC8jUWbyVWKPzQE5WUQh8zQf7/BQYcoTiY9WdVUMbGpx3BCTIoRlbNrlzeRnydJoqr82lTqrvdF7V2VKsxg1/AI1bu3sffa+g1UNdtE48ggxIDQUdkBRlzPzKtVqbWcUjh8OMlhCrLkLFemlkBaxKDgOQgnrjuYMrIHgXRwX0mrw==
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
2.51.0.rc0.205.g4a044479a3-goog


