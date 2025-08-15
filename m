Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C34BCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B092B6B02D4; Fri, 15 Aug 2025 16:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1166B02D5; Fri, 15 Aug 2025 16:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981F36B02D6; Fri, 15 Aug 2025 16:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 800E56B02D4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C964117365
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:43 +0000 (UTC)
X-FDA: 83780102406.23.F4FAD5D
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4B7C940003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g55jbo0m;
	spf=pass (imf04.hostedemail.com: domain of 35JWfaAYKCNkFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=35JWfaAYKCNkFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCan40y/zjv6ovcMCtQie3VVVYhwoaYNuUUlLHYJCrc=;
	b=yPJ7iNlAxAg3lfE9smicB9O4Vlh7xXzHB4drP1DajXlxAqynRs7G+he8KLbNPFfc5DBUTK
	gj++DTPQebWba7ZJkwnUDe04oeVfGaaUSYeiAOp+9IAkIDIbobREVl4Uov+jznANzeiLRP
	GPAJFvzA6j3fa3455/Z81yMaNCJ3iy8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289061; a=rsa-sha256;
	cv=none;
	b=pa7nzBim07iFo/5uwx3LpqzvCLD7xCeUReDvs3NJe00TdYyc5pxOmexOSKZHa6EaXe60km
	bQetKzUb1yGtVAOkFZ8DSP/a3oRCqjYDnbUzO2utExvrnH1R+rttKX/CxMEvJZpcLIagIS
	TnF3pTCyarBtX7VlEjL5Scn3iW5sWR0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=g55jbo0m;
	spf=pass (imf04.hostedemail.com: domain of 35JWfaAYKCNkFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=35JWfaAYKCNkFPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806eab4so21876605ad.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289060; x=1755893860; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCan40y/zjv6ovcMCtQie3VVVYhwoaYNuUUlLHYJCrc=;
        b=g55jbo0mLYJRYhh8yKERgFAv+YSVvJAa2obbVdTdTs6ztZVHDIqTr+cQ++2SxarMYW
         avmZD+2W60yWWsDiIABfjHzrVrClEzRuwuxJlIr4DRD5N5ow0rbu0HXhajZnM293kPfk
         chFbEgdTq+wiUg6G1/wtqv3nlBIupfP8vF3Pq3zIB6L0Va3VZ6Ulha0rcwN0S69AZ4Xi
         DoufrrIb5eAQuoGrlV0O+sYGCkfvrUccK0phqTAY3qivczg+RK1u63S92y7JXZAoo8oA
         SwAiNJF//ghD6jlz9hDQ1YNa7oiDZyuHNiMlVrXVvPKzYbtVMG0kq318KUav42lxSXBN
         yXvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289060; x=1755893860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCan40y/zjv6ovcMCtQie3VVVYhwoaYNuUUlLHYJCrc=;
        b=GoXI1eojzDVJu1MXTQUd7nfroe2PgWcyr7VCtqy012h1/D24pYVkPgBFg9ZZRbgd09
         qO2K0R+hIlRVGyQeAge08npRmLJQR4cwxKMTsjrRLoO36sgSaNY8H4vtpySqPEypJCb6
         YrgF9+lJGZNMLkVGy2IzGg6RlepzSxyt3TI6l/RZ5bEokQV/7akf0RwbXWHok1epQMII
         IJGyZEZ89ogWNg4YFyrHAUYwKqSccnzaPiVWZEOjbSUSeAcha71kPbG55K+AOsUFKfbZ
         xu9mE3nVGfa9GNQG7X9wn5TF111NmSlXz5vwuM7Rzp67lG0G/FWA5AJlwNaKLgV1rjPy
         ebcA==
X-Forwarded-Encrypted: i=1; AJvYcCVefJRKCIu09uHHjGozUB63WLfDo5KnDmJfxpZNttiWNu/RZSoRUgzXJG8gXa2M7oLWYmKS+Q7d0g==@kvack.org
X-Gm-Message-State: AOJu0YymgGsXsCcYEAQSzvDsZYH097ZSk8NeTd8gwJYfY/k2l4YYRHA/
	wr0jP8z7oCK/nB0a6Uu97CL2tc3WJms00+xhtd7HGScWF058XAq4Kde4A2qVlVrdOTjRECysXZ7
	1+BPtag==
X-Google-Smtp-Source: AGHT+IG+NKmG4fQxWApznT/iNlBlE89VZOBkEiuZXVixRsMQFotYGpJhNutY1IkiTXx8XPjH7buaFadPEzU=
X-Received: from plgo12.prod.google.com ([2002:a17:902:d4cc:b0:23f:f3c5:dfc9])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c4:b0:23f:b112:2eaa
 with SMTP id d9443c01a7336-2446d8fe30fmr49723005ad.41.1755289060168; Fri, 15
 Aug 2025 13:17:40 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:12 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-5-kuniyu@google.com>
Subject: [PATCH v5 net-next 04/10] net: Call trace_sock_exceed_buf_limit() for
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
X-Rspamd-Queue-Id: 4B7C940003
X-Stat-Signature: gmn3kxku3gjg9szske31sgjznotezy1f
X-HE-Tag: 1755289061-775021
X-HE-Meta: U2FsdGVkX1+URgMu50Gmha+71Rzt7sEKJw5YYhCux3uIYvZ6AEtDR71euVlHiLJobYCZ4C4r0amGVOEX4jOnoGS7dxdOZsapvYMCyzwmLuIe4R6vK6TNQGIauyal9VMoC6M9A5o0fFDKtUrHxH3HLaPKiKU1f3G91plarFOb+Xq+PYYVGSOSw7HmfeQjb3eJo7APkzgAkYkYjSi1jv3u7dN3kFwz8sgR7V4228KEn6OOw0S58qh8B5/WHc0KVDKromBicVNdflfJMPIoHJWYjRSQJJICfNBBBu3HeRPAIXFCG3pJjI2q2jerk8exHITM13hpHCnnZFzTjoz/PSW2vaQb5PVrjr3jh2Ue+H8QCIA1aR1e/mx5PTOVZmGHwvrOz/8P5dp5Lqcr0Hd6LzNA5VdPJXleqE2AGUiipyoINSr9JL3X07uX8Bnj17GN7SYM+1tCarEBN6T2Zncik7eh4NuC6qkByu1w3BsmZzWUl5MNBHzlTE7Vjb0DHZqmVAeqoiA3+zMRQMGHzarv+wbJ8POiWjRNd7h3XGZbL16yci2SelVl94QexcIswSZ3Fvw9BN+3CEc4+tT8Il+STpy50wyRE+DuQx/rpaJGAlGYoVFd55PLtWj0tUNDUQZbsJRnJqw9u1YUJAaCBZJX83BIBY6La6DAgqQs2L8OrrIFRjdeZpMb6mgvfmh+c9s3ts9gixeXt+aGrtxo7A66ittnJLvT0Z9BJGxieCho2ruHSJQXmn2e0O8uliluuU2kKGBN1rpSH2XLgCn03EH0WL+SC1MKSvii2dcrvL6rQskI8NhXvmTVcZzXW/mfdDB8RUOcy8WMCJRZLrFKiQwzOQTCvUkOazbQ4S7/NUUZWLuwkNyhKfEGchISChasluWsgLgXGGtpkzaT6b794r9IwltIG+1HeSHTWB8hmuVzmRRSlTAg5CxSEwFZPY5srvUKNZssV4QFjjd2W2FqpNVa9Y1
 zAEMseU4
 amZKSAUFTCbxWa2pG9vH3cTdS/UNyPHirFuT1poAa5lAMQZw4M7rQ6Bjtx4IBUN5MFLhMCP77f1kz270XiZwBXpbEYlNBMAo+iPYmvoKZxMYhi4yZKMTzVTonkQf5gxbkoXSSjAOcOzRF5ALWmv0RE8VbDkxCCZOj4QTGTW8CiqS5ZluSdH/ayb/13tbxgyG8BiFYYLsaEvuTx6OvKoxDSIZzyF/WilqxubdhN+k78Vjt8mZcJX5i7W4enbPeM1XR31D3rksrQ/wo6APCe6FQ1+yYigqawxnCcNCSsTYZy7MZF5pEueQdPmAKDj2hpvxauYy6VJ5VOrufWHRrila4H3ZT3+j2++DBi60rNYdeuw2yNZQbkzumsD4vtqLngqm33lG4wdIO0+dqYSfzXnAyOIhKPX8/TD+nWG9kZT4mRAy6xiUWH4+0xdELRM0bI+UAjPhm8ibKaLfqcr02JdwSYlyaehYv53Qu3F9YuGpeV1tPfZ8rN4nBbT3KYksFYi9SzMKot4/e3tORav9u8FL3znzK/5owe42AHt71ShVxItGNNBUJSBOQMhw46ejCdA3TxgmlG3AqOqctA+KAB1FFQpdOMA==
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


