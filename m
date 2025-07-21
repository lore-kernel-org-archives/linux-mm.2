Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1127C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A02E8E0009; Mon, 21 Jul 2025 16:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F468E0001; Mon, 21 Jul 2025 16:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FB08E0009; Mon, 21 Jul 2025 16:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 314F38E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCE6D1D873F
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:44 +0000 (UTC)
X-FDA: 83689430328.08.ECB2C55
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 10F0520018
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rpTelwqR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 32aR-aAYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=32aR-aAYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130203; a=rsa-sha256;
	cv=none;
	b=DkmlG+HYfZ/zokzbKWwKLCIi0xzESX4girbJikp+UvmD9m55H2Ss/1VxMPk1v3l2iBQOJZ
	UVUtPVhd2UpIw8Rcj/DPquS3bCz2xyQJQD3mBCdjHxc46VcC+16rZM5IqmOnSo4VoPGrBM
	kxyH4BmC+mu8ZAPES0jyq/e048A11CY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rpTelwqR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 32aR-aAYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=32aR-aAYKCGgQaTOeaMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssPdZm4XAVciTYPYdUcIXie5OXrS2r8M4cSNBMi+lG4=;
	b=7pZSXpuizDsm/aYTBSVC/ZI5JLNlJ9YlGf7jdYBm3RTtBW/er+XijwYfzAb6lOuVz3tdRC
	GVOqjLsD8s97D9rrq6uF63fjJKoV2BJJ7mc66Q22du2HWzytW4Tt1yi2MGIVdsAviqqvbf
	gpqcA6Fz8JiW1OLWfsZniNQ4+pWHMWY=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b115fb801bcso5208596a12.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130202; x=1753735002; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ssPdZm4XAVciTYPYdUcIXie5OXrS2r8M4cSNBMi+lG4=;
        b=rpTelwqRdPxCPh75wMTLNNxzOSXSkkKEzMa5B9HBWTlH9G/Qftr54imWTPUKV+enlA
         RsaQdXMkgWHa04AbUChGjqqfWu/+2h4cumocKNUgsbGv/Amls13cQ9pyCtwJ7Jg04YZa
         kh9YlzPMel2Cobjc2hd2zhUvnDjq+UWGlxemGqcjHyEm6aVHrN91KT1s3ZGUtdKF7iYz
         apj/xrfWNwa69ffLwsnOSk7sLG2HbDUfS2FGHPTNK3OVyuCBd+w0mfIkzWAEDLzfQYmF
         2wnqowvz6mOXY22m69bQAPp8r3xEKjzV953cUS4Z3iY61vaBj71E21tDNMr0ts5pcD0o
         n2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130202; x=1753735002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ssPdZm4XAVciTYPYdUcIXie5OXrS2r8M4cSNBMi+lG4=;
        b=L4fcNSord6WrlYp9EMkrs8UaYEGVZB7nGFPozvIS3AB8qLq1CmkqeHf2WpD6PBw8JH
         0vcEynHfj6st+cr7KW0UkPtytLwK51zRrUN+PFwvedj5M+Cn+YjoXEQ2bRH7DZwEGsa4
         wb/2DPG4/yxs9Y+xi4odbvpdAyeDBkbrHy7ZXsySRUbfMNzvOAOnEtZ62mcutzn7eTKa
         txz6Nj8g0BqnozL6ctg4WCiQVDIwUdWSjjypfR7xYKB2xx91B7pBhcMdRJB3wzInFit2
         nidwvdbbsTRakNFq6qZJCg0RQoQOFwHbBNta2jRSmffKvWj01qwz0zql1xFREqDqJBks
         SSJw==
X-Forwarded-Encrypted: i=1; AJvYcCX4rxBkfFe8/D+/bS+4NnlyAnPzyubr0r2qX209V3wh28ZXlUdo93fMr1lenlohTdOdIXA2Q2IgjQ==@kvack.org
X-Gm-Message-State: AOJu0YxPRENYFOTuQyJGxq50w09SirmUwc7d+wwd6l0N6omgYRt95y7T
	VRLfconyWT0u511ejcQBgttC/v6yk+9HOw3C/nBjJpLoCtdvq/z97ikufmh1mD5LndsQ53pZxYJ
	gUb71Yg==
X-Google-Smtp-Source: AGHT+IH0bPuHNRYQE3IBCaVT7B1b82DZOEQMUavwyW5ZrY7G02YZ/hUnE3IIWK5LKSPidRIy8Lw1sZSx8D4=
X-Received: from pfblj15.prod.google.com ([2002:a05:6a00:71cf:b0:746:18ec:d11a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9188:b0:233:f0c6:a8a4
 with SMTP id adf61e73a8af0-2390dc51bc4mr34981014637.31.1753130201882; Mon, 21
 Jul 2025 13:36:41 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:29 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-11-kuniyu@google.com>
Subject: [PATCH v1 net-next 10/13] net: Define sk_memcg under CONFIG_MEMCG.
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
X-Stat-Signature: snh8mn7wco7mpikzm1e9midnhdram8d3
X-Rspam-User: 
X-Rspamd-Queue-Id: 10F0520018
X-Rspamd-Server: rspam02
X-HE-Tag: 1753130202-964217
X-HE-Meta: U2FsdGVkX18Bv5VUD/y4orICz4LcZK8qzTJ85uK+C1KVooFSwI7isg4o+/laYk5aihYpd7gCheVGYriVVyUQaWXkQ5OGgMlI0wSguCCfaWlT1pdEmV7s3Duwo0/xYbUUOA/d1L1wzyiN7+P225cAzLryBxn/ZI6XA3CD2p8jrTiv22FmP1sHB49egN9Fx/p8nolBdWssQ7LcbE5iPK2X1Q1mqrtUmVyiXG2u8MhqPaw8BOUZUXhjyk9AMzwS7e6G3rWfOT2OBemdXX+c+winDnvU7UcrG1OzDHh4tby/TeSOkNcJwQJQiWpchKdENE55Tcvzlu82+DeSQVDn+q2NrXu+AW60mmgJV7/lyUw512yD9YQyIC8E/V2FtGGyz3vinVEgZkKNqDCl/Ws6/ko/czqSI9JWPpL6eY9Vc9xDxIzGRZCJfyAA9xzhD1NXkhMgr3Yx7NssYmROr4TJTUpzGdOuVk5zEkPjxXYSccKXv4XCa97css3QSeVyMR1/JfNAKjDLrW1etlMQTcmDlZu+P9YAkUPWVwUaGvSC2NwX7FTDPLKwn9Z78Ne9asAJqOgyWpzcg2A8v6bnikevxG/TFrlfpIaJABlDeB4YVj3PQJO+oNr55nlpmjWS1TTFdz3FFt5/BRe7z6KED+Xr3NgQ2Qsw+nqyKzipYdYKFhM/OoPlOTe6F6craOEdyuglq8eQcd5lX/CgYboxs9IxBvdCoCxCeyTS4Z+nf2BI2vFDaHuUD47T7tWYdTfiUE37B+UL0jV+VGfP9KWMGapSxYu/6UArM73ojdlaY64d7K3VpFvjsv7CDPOgRrGS8/mx4F/A/WJXk/pdJT35FJhC6RMDlBBnMtBPJd/NBUrKOIhGcH3MZMHK5Vj6qM3mK+JGYZsyovAuxRJ7NGPjHjHy8ZvAPbCZ4N5nse5OvJHzxYTkRLTumIr8ckIMw3MpOhQJT/eVBOe2qoCm0fNlwIR+rGn
 Ff3Mq1XC
 G+ORHNwJbFIn9Ee9i+OjTIoSttcfgB/4nLvzR/sjbV7/sxWXKGjNn4JNte4d+JIqiE9iGEyf/oMtfxXZxNfsPD8M1ufwXhKZp218u61ChsfXo5r3pRLjqapyOdpX017A1h9+nBNN1sBoHBjkbW6M5tmGF8kJFIvQ9NDhQ9AuubDFonndNFiggOjbDMhzHkm6NjZ3oMigs4/kKAjI93EIvUVRwiJyRr273MBgqEI74KOXErH7N2hSjIvpun7k3t/cFw12wXX00KldAQhZQyIm5YeWQBEFOu5oyjCA1Dqs7g2gJLWreWA+lrQd8X5oAkC6uGQPWhrEG9t2ZbYaDLKQr3drnKK/MZf2qyYCWe6UxlrUyZ4NiciI91vNGk1Wj4rz2/k8ZJCQcfpImyAIg6N173BIP/p0jSq5nry6oEM1PZPSuVJG8lKd5WzH73L77+dpcLATKWyXcolwDQGF8IZDXWhvueooECUoHHnIM8X1+P8T0L/L5EdO41FQsUb4B2d6Ll5BxIGU4wqRDhEM2xzkSnTDjLNu8gu1QgF1WoL6EA3rpX0ItwJjWw2BTYziex/qlm/8NG+JKDvOXYgqkO0BjTDm5Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Except for sk_clone_lock(), all accesses to sk->sk_memcg
is done under CONFIG_MEMCG.

As a bonus, let's define sk->sk_memcg under CONFIG_MEMCG.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index efb2f659236d4..16fe0e5afc587 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -443,7 +443,9 @@ struct sock {
 	__cacheline_group_begin(sock_read_rxtx);
 	int			sk_err;
 	struct socket		*sk_socket;
+#ifdef CONFIG_MEMCG
 	struct mem_cgroup	*sk_memcg;
+#endif
 #ifdef CONFIG_XFRM
 	struct xfrm_policy __rcu *sk_policy[2];
 #endif
diff --git a/net/core/sock.c b/net/core/sock.c
index 5537ca2638588..ab6953d295dfa 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2512,8 +2512,10 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 	sock_reset_flag(newsk, SOCK_DONE);
 
+#ifdef CONFIG_MEMCG
 	/* sk->sk_memcg will be populated at accept() time */
 	newsk->sk_memcg = NULL;
+#endif
 
 	cgroup_sk_clone(&newsk->sk_cgrp_data);
 
@@ -4452,7 +4454,9 @@ static int __init sock_struct_check(void)
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_err);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_socket);
+#ifdef CONFIG_MEMCG
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_memcg);
+#endif
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_write_rxtx, sk_lock);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_write_rxtx, sk_reserved_mem);
-- 
2.50.0.727.gbf7dc18ff4-goog


