Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA222CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F389001D0; Thu, 14 Aug 2025 16:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F45900172; Thu, 14 Aug 2025 16:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6178A9001D0; Thu, 14 Aug 2025 16:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49CC2900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18AFD1DDC40
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:21 +0000 (UTC)
X-FDA: 83776452522.19.FBF3EA5
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32DD618000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lIxC3k1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3bUKeaAYKCLYgqjeuqckkcha.Ykihejqt-iigrWYg.knc@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3bUKeaAYKCLYgqjeuqckkcha.Ykihejqt-iigrWYg.knc@flex--kuniyu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ4QavREfrxYYp51rWZ/EL+zSiE81x3iM7eRADON/+o=;
	b=8Zz8w0JqyaOWwDjDYXfdGoX6HWGx0ZU/fJ5teCHHC7bxKL1XQuyKnBsJ/qQumnBpGp0Eeq
	Pq0sXJdXHkn/9k200JFgCp1IZCj0GIxVqT+prjsGxuCqGreqEPxt7lt0Ef7U00BzEQWlN8
	W3JFQgHy0XwLsyKKrfGiwGGqHDvP2wU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lIxC3k1L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3bUKeaAYKCLYgqjeuqckkcha.Ykihejqt-iigrWYg.knc@flex--kuniyu.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3bUKeaAYKCLYgqjeuqckkcha.Ykihejqt-iigrWYg.knc@flex--kuniyu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202159; a=rsa-sha256;
	cv=none;
	b=qya0StDMWBW/lsq1NZx282h7RKgUMMkCd6+kYyY57nu9hemVOBR7BkWgqPFhUwEpIFPq2Q
	L7F3ao5A3W63mAaYw6yTqec5JhKsEeLR0xDKonKtgMpt4b9SVCWePl44GCU1amvz6+ALEr
	CkfChZYp0QhrUsoUPeML+zPwgEnycVk=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e46a20so2563946a91.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202158; x=1755806958; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ4QavREfrxYYp51rWZ/EL+zSiE81x3iM7eRADON/+o=;
        b=lIxC3k1LFISj4Jb7ukYsbG+1+IhPMySG9oQ5Rupsie2uT1eg0VBHIdw97niYmkwQ6I
         wFvM5lkaumVpUux9xo4oly9wff1l/lYpAfUHT4UtIMF52EKIuh34bMNYIpveCy/TObvQ
         hSnWCfRfM/6GeJ92wG/yqLhDlcHsDVn/BEXLm3wrr+HTbUAvnf/A7pYB26TD2x53d1pe
         Vu0JUSuIT0MXYMHpuuZEIpJ2jGqSGB9lWzqgnK/ClZ2sBbVFrMgwwbZSdLOJbi0QoOnu
         8xDsIBYlTwvmYS3Tz7MaRDNbVdUIffZYbY+629pWclElkG732dXcZsak9hzzJ84H2jPE
         Md9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202158; x=1755806958;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ4QavREfrxYYp51rWZ/EL+zSiE81x3iM7eRADON/+o=;
        b=qTvX0m4y1SuX95cIRt1vnkA8elPQKNpCQcYovASClwhIp5Lt7WjSP2hq88OfJcgppw
         zyH2YGmODjoPQGdXIBjanvkfro8xpJoJ2NK4T2QU1MStRUEq5lJIyxEYxGsaPW3NGW9b
         YkqpgRCSzDVkudCIktLytBsxPZvz93IVh4vt6OyHbaS0lubNja9eJaAZ9Uxb2nohH7sW
         Vq8kQiEgHyaRmj+adye1K1kRicrc8QCMnYf1aQ8QnHxHyFJqgyZ/QmuJqsvwoa2TAARx
         9O6xFK3UGeYKz/8v75m0bLCy8pOrVd8SrnX4e9IMUuu/DMr8xmDdDILAIo+KQieF8O5A
         ILFw==
X-Forwarded-Encrypted: i=1; AJvYcCVmzuLGGuXR93t/4jJ7NQ3qWz/4KyY/QaQmohjT/S54PBXboDF1o4wd+fLamtXEf/z7C94uJ5qVmw==@kvack.org
X-Gm-Message-State: AOJu0YzudXDGlPEMIzISZv+GUr4Dyhfyrgys5hf1QMwoaXB5BDhmHZT6
	NinU8bSi8xUD021tahOa09lwrY10UBeV25fEF4/vfFCZUUHDvgZahwao6aB6A01VpsrbeBsVqEK
	SqcmnVw==
X-Google-Smtp-Source: AGHT+IHJqj8OCBO957elyCb7Tb9EvqaiAKT/a7fghGIK2eeAw95lJXxXFobtfukkiYu1/mXizBdvqnwNOyA=
X-Received: from pjbqb16.prod.google.com ([2002:a17:90b:2810:b0:321:c300:9aac])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e0e:b0:31f:16ee:5dcc
 with SMTP id 98e67ed59e1d1-323279cec2fmr7690481a91.14.1755202157953; Thu, 14
 Aug 2025 13:09:17 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:34 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-3-kuniyu@google.com>
Subject: [PATCH v4 net-next 02/10] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 32DD618000C
X-Stat-Signature: cd5ry7fnpqbjx5m436rts7k48bnwkzri
X-Rspam-User: 
X-HE-Tag: 1755202159-712053
X-HE-Meta: U2FsdGVkX1/mSoGn/7EXrxSyaj5s4MxVlpKrfsLessEoosT57x1BlNoaHHWZH6r7TH9TEdnJWOW0Kf+wzZJ873PGuXCzgDTRzsiutr/imhqcDjZDp5eJKajkigMhUvKa3KMNvmIJjwEIXCKhIqsVhH0O2M0xaBEopedi7cpdvjcQ++5lGlOIV7bL1i89KmJVWWP2fglE0iXL2D/yMMSFf6lWVPhRMxdqT3oeOUtORimeIl7LhfOflmSDWc3JIUiJx0HeJMlb+cUIGmdtDvR0mB8hoi96Oefa/CYl1hcGYhRohSClcFS/M1j8VjCgCs+T2w+mPOOHEkpgoLcaZv6fzjdirmSwNbQDwqWwf9ahbso+i4ngCUl069AZDqYSlg4qWeoFcXPO161YX2iS93fybN5UOEfkEajqISJGe6X0gsIkpHc4D5C5NUCZKOSWwbp76F6piBpdLoUIBC2KU6pElFJ4IZ7yLF5de9kzqsA4hFypflzPP1un40Ip++z8cRKoiodd3jcKhltiK298MERyfmx9IDzBoUVds2nDHcisZfMS49E9FJszFmhP7/+LW2uj+l++213Az10cdIkh6ka0y/ogzyNj3R0hv2Jymj3vOQMrXfOkf1FZC5pGkDY9gpm+raZzo1aqs7AnSNrxPIN6nLP2D3t/ujrWTtfrnII/99iaSYnThXL4H0ICrOu8SxKgieq6YzRXCwCNBEx2KRnzVp2XT7ov1ZAvIv430Uw16y1haTCjfMxz5BQhrgcJ9pfFlNAdkvfguj4UkqjiYCXNKJMN7CFUsT2tfCBjQlqSb28ZKOrW8R1pHo9/e0OPLzckVnKQcsYs1iYabBc8okgKgJP1x8L9OdS6XHY6DQCpdoV176zjsut/o5rp3i8Ca4Ktvek/DnYUnaqjtfQHHK3TTpFYrGLG1ApL2B2OEUui353kCSk8PZIBgHq3ddBg5T/yvf1Da00wWVxT8P3j+Ly
 K1ImDpTu
 qu7yL+J0tQ4ied94gqAOne6UlKE0vbjBlsjaHuJ8LoV7guKLgXflUOA0zTrf9B5ATOyme4wzif1P19BfoUA/TQKbIVE7qVxzLFc2qIMIoOGFhvZTE6d0V+TAfNeq5W1b4un5r9JIMop2vWDzO3PuxiaYRVT7awkC9b4DThqESzvy9D12xNLCC5GqgUaPv9rK5Y6ll7zDg1ufh3QpuMPiSLiCGti7TWpsrCxzts8Y+rlOBaSes74XuIuQ65wtxLAfuZ51RxP8ipCzw7i3b7xGPIbViUZh6naWMYFtilMc/URkfbA+rbkuSPc7djACYJSlxHkp9o1oKJPksJ4TRfRd7eVjf/Edt0Dh46oS2SEMbgi/OI2+aupuWLvz/xDVwf1B5z6RQK9D1mnWGn17iSmntJiPOJfJLYZRtxphg0NSPVvrIXuXBN5nPvtP+Jv4gByRdccQuCOAA/tfklUw7jOJz2PEiEhfEXK1WsLJ0J+0uC1kM9ZV+YSUX8u/jWGhvt98AuFuaFq3AOhj278EEJI02ae709tpYbisjJ2/tqSO+zp5ypujHp0z0gtPp4J5BPeO3hDNpbsNjIuFVyju2giPfGMcOcRtoxJMZwiRnzCR+Wbpm1lo=
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
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
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
2.51.0.rc1.163.g2494970778-goog


