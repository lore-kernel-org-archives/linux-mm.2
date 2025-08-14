Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4343ECA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E9B9001D8; Thu, 14 Aug 2025 16:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11D19001D5; Thu, 14 Aug 2025 16:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFF99001D8; Thu, 14 Aug 2025 16:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 775979001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:09:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C620C0506
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:33 +0000 (UTC)
X-FDA: 83776453026.17.C672B66
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80DA2120018
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:09:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m9povXue;
	spf=pass (imf29.hostedemail.com: domain of 3ekKeaAYKCMMt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ekKeaAYKCMMt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UARZd9qLkSRlP8HijwL/4OYfjtGDpQLLXgE19FfQX14=;
	b=41ZyQ46XIpR2uLA8hWm2sjQvZrJl3l0LzN5sMe+iuWJ1lgFSUVgDdqcpar+8PxhtWLLukd
	tncCYQSkcX50vMjbhScfRDF+em3L4lcs0eVQfZbSOlSIf8BLVr8jS0pFfLSq/Cr9G8hO5U
	QSnGOHFYE7LAjoOLKzAaiDWDSQFL8OM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202171; a=rsa-sha256;
	cv=none;
	b=w0Jw+wYjXsgbsWPrPCuzEZDTppRHWbzIAkOcQhXRY3nbp2n5NIS6Jnvl+pASUrkBrIkWeV
	Vb3ACXJNFjoN1BogYIjKm5qGgfUFdj2LTvX+V6UWxC5WGYsFhsYoiPkrOFrxu6TiauyMv5
	8NJvCXJxmQTpdk7aw+A18nvTWlT5QWU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m9povXue;
	spf=pass (imf29.hostedemail.com: domain of 3ekKeaAYKCMMt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ekKeaAYKCMMt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806eab4so12618805ad.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755202170; x=1755806970; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UARZd9qLkSRlP8HijwL/4OYfjtGDpQLLXgE19FfQX14=;
        b=m9povXuepebZxZ6f0y1LMG4e7eP3LIkkvZVR5QeknI7HR1QAQ1MSa1ID86NOoPQMkN
         +q4z1rKY4iFwUBkuTsrArjmhhO9AnItSLoMbepquVpHz5sQvwjPgEsmSZonLXpA0m6Kv
         kcYkg0I+BwTNw/cegOMSjtWrcgO0JV5UO+ErBvV3FSWFPqpcuTpK6MxWOEsTza4J0wEK
         v19gfLeMSRelaDJZlEk+YEm+W/lRuunhZQMh/HQ3UuMxqV21KT7Wn5znbEeFWF+5wbSB
         2J8vvjN6tc5Gjxnvr7fxxETL46qZOzKycxLiDcf/QoHIfQiDn5fGbgacAJryY/8fnvV4
         QDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755202170; x=1755806970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UARZd9qLkSRlP8HijwL/4OYfjtGDpQLLXgE19FfQX14=;
        b=b/dsMrWxTK1M0tkXxyUba0tKP4UKlO+nThTx5U2kEZDHCYg5/DthIiePsJuy7MnerZ
         TV3tOes8h0EprGoj3plTodpvKu5klIULVz1hDJ0kQXvFDBM/jXhhte/8QcjXBkpXICmS
         bZgOGQymj6j+bR62j1/s1ZjVY84HP3KvkuuusQwTVvBT/zS+y6j22eDPDNO+tjjv+gOc
         HcCveaTAvh2kRJcyH6XJ/8OPdtwTnGMNhlAPue5F4U+R54O5bOu74sVtf3/nFY0SCrxG
         OuwJ0vBeEokUzVoLm3KG59IIA9pZssfn7DLZyt92tv523KgEgKdLs62B/iCIhDmF84Ut
         VQdg==
X-Forwarded-Encrypted: i=1; AJvYcCXJTdfB+S+vQvLRwyf2x+vEig6j89P3K19WLtjtpiJ5VLNg46iTZnTmDZv9uC/0TDlhoELGWlq+4w==@kvack.org
X-Gm-Message-State: AOJu0Yzoe/mb2eW9xnS547YeqxhIfocEvDGLbnd3V4XpqS5Tfi6lKdeM
	2cStqoOmTtPKDKZUtZovKUqcNBFx4nze5RG6UhqLXu+dN6K6/EXhpXvD2/RsudIOGdyh7uHLCuj
	T0JhsBA==
X-Google-Smtp-Source: AGHT+IEr2KzFw5L5eoFv7qE7SLsTY7h0r30kka9wgKEfCc5e8mASPVpzRfuL9JgzHtqNiN7oenCLbFowFlo=
X-Received: from plbml5.prod.google.com ([2002:a17:903:34c5:b0:242:abac:216c])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:228b:b0:243:12d5:db43
 with SMTP id d9443c01a7336-2446a15730bmr3842755ad.0.1755202170389; Thu, 14
 Aug 2025 13:09:30 -0700 (PDT)
Date: Thu, 14 Aug 2025 20:08:42 +0000
In-Reply-To: <20250814200912.1040628-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250814200912.1040628-11-kuniyu@google.com>
Subject: [PATCH v4 net-next 10/10] net: Define sk_memcg under CONFIG_MEMCG.
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
X-Rspamd-Queue-Id: 80DA2120018
X-Stat-Signature: sfd5yuyxheouc3qdg77444mq9o5ma7ae
X-HE-Tag: 1755202171-448891
X-HE-Meta: U2FsdGVkX19ifRqvrnkFtLMZJdhkPFIse2L93gSKQfRRMwMzlPagjipVURJ/qbMZwmfaUGPWhJaWCfez7QocHPzGmxlJzdunMi8K4nedSVwRVDNJ5yPdKqqrMXA4XP7X2o04u9Ib+lWF+gIo2mdJTPx1ClxOoBY8DLtxcVCRvTqY/p2kgxeEfydNKXPgUh7jNNpL9CuQltkp66Q0mCxtzxchlc+BCK8kcXOBIvQ/I5Yv/mk3wapGOLgV/M9jXeDgLcQR2uaP26JR0wfzP/Fm+xmjlX1qxsV9MgTlXdaCE4a6wOpw7D7466WvXb+GTmed8ndBGeWOU+TRNWbEw5L/C7F3MG03K03YbDMk79QfWDhsAZY+vnRYrisIDiIOifE/KsoH5kN3hHMO3io5w1e5roLvdyIcxVT68QFN/SlLNjYYPX2gXAZM8aX1phJwDsdiIN0R+gL2U0bBpVcGX3EJ6Pj4FBxkCqHf0Y5nFxM2NW+OupP0lRRSTCsGe3sHNN64tvzK1Rp5C7cze9My4eFyXlewbBsz6IfvG5hZeg1e1Ly0W02IFr3DFRAhz9zdMXOqOqbZ6O25rlgpkQWRIekwUs3nHDNisqPlopsoNoVK5h5KU/D9VugadBGIP14VUj1EThyPT5s5fFGlMuvPcYZkOKkMj+cka57PP91PooR4UqV7nQIxXd831dCO2luOwxeXzfcG1Xa7pQnOC72JbbeY1Q3TDG3vyLPtwu3XCeHJxKE+0A5sAg54uq8URxj7eVhNvj8AgqZS9zoZv8jpttTQs0+6DxFGHYURmkkyPZvyKLvBuV6pAOqX3AkCculOIRwRalZXUbgNyy0C/ORbBvxw74uP9d0FDu1d7bjwdfgz8HxRu6UaxjJHovpewGFfxxvvazyYUpc0KlQimjnq15QzuO0+Zen+Re8jPjKFZvFdePhtzd9meohpVR9ft1a+QEnyzvsdesOWXRRipmSRZT2
 J9woXV23
 GLkn3IdGbUIGpi25J5hv8j2RFCgbUn2iAroIY5lZMuY+irT2mlIQ59aWXplgc6OYw2SyyNAUFmqDuCEHx71aP+X3gpnKDnWY9XaxgtPOjj9PFH3sG8kQvYUmIE5Y4JpsaWeZj1vsC5vQnEWf3Ldpo8zM8xLfZ5zL+3R4L0rjUUm76pYsNdwWL7989pKhAxKKKtVSSqHz1vyVISFqFcBepYMTPoc9UOOAbx7kir1yMWS8Tpug4xpf8aSgjpnXKQiprfTo1s34Quw7TAXkRlFFX7QcxPMtzEhJcBVfRe2pgroMm39DhmZjbGv9YITyoSv56gqDbVy9pJzOaJaHPkhdmXn7OlP6kRkZUel6V8WMz+2BBJwJM5HeOcV5m1usLtF6RPTfKPEpGnAB0AOiRMod4l4hgZsQWL2bMq/lQSn7M0PHI64hcdGcLZHWh63FRPAkUGBbZi5mdDTwE2+ikpCci/ZUumeha0DFMb1G1QRN3R4i2w450w33FZcvQsAnQhpyiYxxf98kBvKvDP8tQk6+9myjqv8DJd+wVhthxj5iSTWjn76O4ixsqW1B6ej0JoI5SvtbF6bFlnAGTr1SQgUc5vJJLlg==
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3bc4d566f7d0..1c49ea13af4a 100644
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
index 5537ca263858..ab6953d295df 100644
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
2.51.0.rc1.163.g2494970778-goog


