Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE037C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59C48E0002; Mon, 21 Jul 2025 16:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31D58E0001; Mon, 21 Jul 2025 16:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E498E0002; Mon, 21 Jul 2025 16:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83B598E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3136F16019E
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:36 +0000 (UTC)
X-FDA: 83689429992.13.96322B5
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 679A5160002
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQmdlZu7;
	spf=pass (imf08.hostedemail.com: domain of 30aR-aAYKCGAISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=30aR-aAYKCGAISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYUyNgMVCCaofoOHBPPUoPupTfXzfLB6/aiuX2w18Mw=;
	b=eFWbfELSFLmQNktKQYa8snIzEQpe+djdFLNjFIb4Z6Y67NFnCPtvfnTWhoVPEPSVBQ8pNG
	qBSE3NAjq68IO/CryrzL3siLfotyH5UZEa+ejKggRDpNVugk8Goq5EB5Q75DV9Ka6LOu9C
	MmrKaQD0lalUL0Q8zkxGHIGg+RBv8H0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130194; a=rsa-sha256;
	cv=none;
	b=bcHlVInET7GE8trAzJvmEMDbsiF2VTzy3m60AwKzBamV1v/g9RtCYZdt7QOlvvHnBgi1+J
	p9cvyLvJtmRGf7UIxbbrhHGYKvgmk6q9B2B0H9FlmNQMa+YerC3IasJz3nT4ETZT4v7yoJ
	ehuau57obAfEcHLtx57HN6Dqx7OOpzM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQmdlZu7;
	spf=pass (imf08.hostedemail.com: domain of 30aR-aAYKCGAISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=30aR-aAYKCGAISLGWSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-756a4884dfcso4489837b3a.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130193; x=1753734993; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hYUyNgMVCCaofoOHBPPUoPupTfXzfLB6/aiuX2w18Mw=;
        b=yQmdlZu7ec9exn3/G9Le1Ypl/DT0tz8peexSONbaqf/jjiYyz8MeXZIvJjJ4n6OA0+
         RfJ8jrGw7H0Sw6mIOlkv8feSGh/Uux4+wVOHHigcyWddNw28hTrAAbvsA+ylpbMSywJ6
         e1IpxtUQ52pJJNciFX1gW7QHzGAzsi9Isq/9wUlHnpwoah9O0/xnEjmHieBV5d8KzDkP
         G17Rw3lkq9DU+goUIkdJ2YPx4yIAQ71vSzcfAjZaxwU+T6vU2V/6MITUZ+pgWYoj/c5g
         wDMjtmc/nL9AjD+OWVpYaiL6lDtGRxfwbM0T9VaWNSff8zK99w0oe4RuNqylKx9x8rS9
         Hb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130193; x=1753734993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hYUyNgMVCCaofoOHBPPUoPupTfXzfLB6/aiuX2w18Mw=;
        b=tLCRKfTJHQB77SYPUiCq6JnruPgYNSar278fw/bDx2LS3OLb5fMlimCihPF7BmE38u
         Zvk6Hiqbc3AoT71sdk3yikk+6zKbIqb+xgfcj6PYnr6CN6um6w/2L9hyQPvakdU+pAxL
         11beBFlRlCf17H59jDBh13MDNyKLDKxE9RWIiYe3A8TdFd6lHCa8gXmtEQcPu0/+gZdC
         AkHp5Wu5KyGwM5McnsQjqgk6JMB8OnzK1J7JAhDzLNJdMnMgzkzk7kDrcxT4fwdMpcJ9
         pzly1OPzyQuMP10mRGm1+C/0zkO7IGlxy55OTIOWL8QZFTYuYGDui5oJ0fx33UAnIW0r
         lgDg==
X-Forwarded-Encrypted: i=1; AJvYcCXi8ng7lxFiG24y2Iwn5aYPcXZsGJwEXbMCgvbwDasvPU65j/mSnB6Xk4CUpmilFGEZJlaHCACo3A==@kvack.org
X-Gm-Message-State: AOJu0YxyeS/wfNjYTvu7N+DMd8h0mSxhbSrtiZ22iJV87iy+fg4v9B/0
	Vao28B3tZjJ6e5ZSTDsb192S/7X1835fKPwqKuRldTbrUSFvxSAy72rEGUoKs54drPnpLrNwf6U
	HNr3PPA==
X-Google-Smtp-Source: AGHT+IGmJf5+70mstVkzYNSRFS4u46asIcv4vmF3QPlJsewm8h4FN3p0mxWoexnQlkXY7f0461xV86Ew6Co=
X-Received: from pgll188.prod.google.com ([2002:a63:25c5:0:b0:b2c:35e1:f278])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:62c1:b0:216:1476:f5c
 with SMTP id adf61e73a8af0-23812b50d6cmr36295824637.25.1753130193273; Mon, 21
 Jul 2025 13:36:33 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:23 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-5-kuniyu@google.com>
Subject: [PATCH v1 net-next 04/13] net: Call trace_sock_exceed_buf_limit() for
 memcg failure with SK_MEM_RECV.
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
X-Rspamd-Queue-Id: 679A5160002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: pkg44q79do6e3tccmogjqm4s3gywa651
X-HE-Tag: 1753130194-95664
X-HE-Meta: U2FsdGVkX1+YeNJhyNUSf4+pQLHmL/fHssUjmVbXT0YlhDG0mp7DrNWPC1t5xvdK7ZKt997l9u6Y41Sq6Je7Ul4/Wma1mv2cjG1J+MoZ5or/mF9RUaRKmIbYyL/E04C9BVxJanlDwdgT2bXKxFD21NHZQstGs/UUhz1EfR19ZjPuwAwGh2wsBcgtPJKbTMMVmS2yGLRb9CogcbyCY8SGlHR7/7s3oK3dUShEj0+kRyUCXX1oHO4NF4mJoGicynT9+jOjJRQbTzPsgKomLLSloBJZacGHZvgn7k4WoiXsI8S6KY9ITxASEEJ6cY35Ud3EEsPx4QkX0Wh9zvzW7AwP5uSaSiTqxaMq8JF2LtGKRmyHZNXllPIHpkArQR20UOWFal6f3a4JipFEedXEPbQjp8c7vnDCCmJggUt6qmnWFVUzdIYuDahM3r2Oax912aC2SNZB/CPp2aN2L2/yrC1KPwSK5K9mDV61LMp6SlIySEP2M7tDTxZm7tzimK9Nj3uu37GGYwmNK/E+NUhC8np+SdJ98wK6TzfM9+lsKjcI9Dt+IIHaTUOou/k47MK/vqyRyl4DAfIIAM23HSOkAk54bwXEe4F/DveQPMP7WpC2GsRxDBYoV8HDesQvHF0J8cX5lKCAyIHeWeXtZ3b2shLCv3OpNPLgdRNKzCjSXr5G8zAIFmfVzT9Tz6prLFQkB+uPlkTrIti6Buesx2CehUbWehyB8PJxi6nwkoRYsMAKz0G+RCd7XVgM992gp8IhtxuWn/eN5lnBBmu+8jUMxA+G/asQuh60GJBDQ1OKg/NtQ8rAdQeINFY+VMT++htS2omztOZCN9ZQWfo7gjvDv0xGYYY/gQtGVBzxcR++r76lxsLYAdEcWDjsrFSLKJV5xxdOXzjjRpl4SpiQyebpT6Y4oAQpjL0xm1DYvmoBOqkpNmWL0bfeyCpfCLealzqVS3rkKM/7InTNTOaVkSuLlEz
 xtVxBCav
 v513ICtwNCW+caQHM8NTUpLBM1pUKkRncsbsinjIkPUfJ94r7aCmbkZLnw978U3y9iXe3bGSTuzNkFG4s875iYUESjKuoX1M0qrL3sY9ACl0cZx/U046faYI+ZmZyhV/eroCTTYzg4/0B8rd6kTiSLIEIx3oBEd0CDTmLrqvgfKt8VGT3RW7MPTErzaLhg6ZIaJJigrTIvf75c17j1g/DD6GHO4rGO23Vhqz72OwVu/o+imkTFYxDFwubYElc5hK3NBqSzteOt7SnKTWdOAZH+DK8eqS8ZiD2ncFrNPsbmCwrdKE2k/7PKxV0WJKQLZiXkh8FDMZjDCUBU2TOGmoGl8tNWzWlVSRPu/ZnyEYk2DS4zL3dA1gwRdrL+gcqwiL7JeVsJ7E+oN9EcXEdItFY4Io/4Dw7XndNAHIn+Lv9r4DJGqKszMMe5/yyczQJOARdX9FS8gXOsR7etv4+cQrjaheNMfeQHshIIGGu2X6IudqEMEzS/7Mh3N5kjRkLCT1k44PtfPKjTjfsAzd83Nrmw7IWnlxVFCeTJ9l65W9fFLvZ/pQts2jVUSlCgxrsUSQqj1eVZQgfn7Yk5DOahE6Go+J2xQ==
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
---
 net/core/sock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 7c26ec8dce630..380bc1aa69829 100644
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
2.50.0.727.gbf7dc18ff4-goog


