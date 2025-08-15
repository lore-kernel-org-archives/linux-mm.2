Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FA8CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674FD6B02BF; Fri, 15 Aug 2025 16:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626276B02C7; Fri, 15 Aug 2025 16:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BD76B02BF; Fri, 15 Aug 2025 16:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 277426B02B9
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:17:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA5461A02A7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:39 +0000 (UTC)
X-FDA: 83780102238.08.F46942A
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 539AC80016
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:17:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u4WADXeL;
	spf=pass (imf30.hostedemail.com: domain of 34JWfaAYKCNUBLE9PL7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=34JWfaAYKCNUBLE9PL7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755289058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ4QavREfrxYYp51rWZ/EL+zSiE81x3iM7eRADON/+o=;
	b=gqWGCBrVhhO8y54E6wFdiAfofYDAetFTl4G9euU8AAv/sSPdPRtrJjAMiUhgrFvOy3cS/U
	FJZjPfiBxo8La47H4rBOHLiS0LCW1XMP8ZGQ3v95V1I7pmXgzPOtWLIdpPlabJJZ7HH9Ub
	F7aO9qKRHxTNCCFP2p54PXkyNDt4VbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755289058; a=rsa-sha256;
	cv=none;
	b=3Lz6wdhkWNWfWAzE8YaOoFkXuF+xiOrUfJmdPsXQU4UeBdTkm+kf54uCArEixjjABCeVOu
	iMXmIPnpofEYkvRnoyIMxfkt2Uh38y2JhZRnRTpV4Otg/oNYhTsC0EsjsAdC6sur3qtSSk
	TV1MbLMmj2c6lsICl212n1QIUqkidfQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u4WADXeL;
	spf=pass (imf30.hostedemail.com: domain of 34JWfaAYKCNUBLE9PL7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--kuniyu.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=34JWfaAYKCNUBLE9PL7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2e617422so1903901b3a.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755289057; x=1755893857; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ4QavREfrxYYp51rWZ/EL+zSiE81x3iM7eRADON/+o=;
        b=u4WADXeLbXIHGe1WgNBPDehOIH+6hqJSC6PEwQJn2k1UrGdNxEHObAIT7PfrnTJNUL
         zZeHwrQmYxOGOoBKKYSgAPEXGOqdaUDbi/MTPg2PzkFbSPAkx0uDfgMD1C4KbkftXSXR
         iuc91/Bcqvpb1TtxD2NYehtnUvA03UqH7fss5Nvbm/L/Os2mss9FeMLnL7BLleuOLaG1
         qxriiAbSCY+oHaTFgQ3y/AsKsSWzgk5F1qDCFIlQjF6JLx+QiYT/Gwgsyh7exKtKHeCJ
         m7Hv1HkfVRKkYvCVS6W7Wyj+27bdyctxrj6ZVGCXpu9KmWqZhcjvuUiVaN6idGbn2zzu
         4VYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755289057; x=1755893857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ4QavREfrxYYp51rWZ/EL+zSiE81x3iM7eRADON/+o=;
        b=OMrVNCy62gJ5wibvag/l/mfow3cfJSylrIj+i8U4TVhaiDy+vB6bldFw2H4xArFVbq
         y9WgorbJw7gBP87XRa+2WJsdWm2jDU9Bpj0yWcyVhYq2q5r73rraMQWGUSkWxe0/ZMhU
         I6Z1Krc2DeZmCLcp/QEWVaW3kmBZHXBJrPpTApuSU2eig0efhfcM7CMfD4vt7r5dlYTe
         3TkNKRtZQwBWF/zYMKJI9TK8NEgFr5ptT+rpspjoBKy5IrGbOlWpFBFlpSgC60/TXf2g
         dQ1xuSiLJdonWe//K9LIJAjmgqIp1Th8hDvrQI1NUG0euOcchifhAWS8PE5n1GYP0LzM
         zJ2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUygeCGBA+WNIwBBCJuUvBp7lcX/Kd+InrQNWYbdysZnT9cPw1YRrdf6fkBnPKL4gmBnur2/8PBbw==@kvack.org
X-Gm-Message-State: AOJu0YxxGeBKvWG32xjw3mKqFsNbccZZpXXfngs8UikTkAzAhHPVCAq9
	P1hi28haxbEVN2nvpbW+ZkwR1fnRtdDRgjGsFUcvq4oQ4xejxx6nxQCsmgisu7Ne/i8asgSRWwL
	eGtyIhg==
X-Google-Smtp-Source: AGHT+IEr+/ZjFkXy8umwdjDxM5J/aKMeoAE5dmVL5UloiD+KmJwNlOPL6BEq/ZXuKgz5B8/N8YhDKs6emow=
X-Received: from pfnv9.prod.google.com ([2002:aa7:8509:0:b0:76b:8c3c:6179])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1893:b0:76b:e805:30e4
 with SMTP id d2e1a72fcca58-76e44838e26mr5098018b3a.24.1755289056973; Fri, 15
 Aug 2025 13:17:36 -0700 (PDT)
Date: Fri, 15 Aug 2025 20:16:10 +0000
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250815201712.1745332-1-kuniyu@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815201712.1745332-3-kuniyu@google.com>
Subject: [PATCH v5 net-next 02/10] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 539AC80016
X-Stat-Signature: diqgjo1a3sk8syjb58xkz51ix9umybyw
X-Rspam-User: 
X-HE-Tag: 1755289058-107197
X-HE-Meta: U2FsdGVkX1/Uh2nQ9HsOJDdWHo+YWfWNsi1dRMDrMbm3eZPMV7K5ICYwNTJyVkxAFlrpm0r0mxXi1wvQtNr0QpyPTQorowNyOF1WjFOTwqNJwmDxJkRxFhwRwr0UsY8CZ5wZUFHKKGFiVpoEaieovEmUdeOMkoHguLh7tlqcBHOfJVQsNcrOOGCY3NgfwXW05K3zyW7HqTlblv8JiGX3XHiCGNg6MLCMfS0vnUrOnozunxWlCz+D1qM72PwZHwsrckLiJMwQ06KWBC8bg02+BR4eCPPwWdBcAPYNNp555Lb+DWL/rdWsenaUub6KTtTDhchJIM+ZHcVwz5k4pkJ2cikBEYXy+dvtZyFde9YaJRLvhkj1KDb0iwieINcCmxMifbHezz2SBFVaPSbI8741kVhBESflr/tygndsVVT1ruXny/an21awTOC15a+Itg9EN7RigdQ00SNWjSSD39a6GsBhoATlZXd2eFtjrlPiogDARZieQlFqA3eV+qDCvTeQB16V/KXH8yE4oy+UhvHNwfP7l7VFAzcPFKt4r/nZ5CfiCA5XV694qgA58N0eTf2WTV6KAiESVIj8RU+cNwvycLi4UdpNaV/DAs6+R4Faq50wdOpDAIopReQ8z9HMbdahHfsUBAi5K3fvtLfmNS1t5P3waw44pjH/Ufr0M55ZdrnXhBGejsEpU6x/Iwz3KIIt4idN2W4ylpBLX7LBJoptvIl/OxM20gcvvaVcz2bNVq55gmPE91ZzBEnPq4+X6lnSV5s9rCIjGYJu9R0n2ge0EaCGd/AMdQNmuife3gZ66m/aeElpnn4njV+90DNfv51DcbOBbySphhVVyMInjr1OQGXwM4rTJ/2YENuj1AmOg/cytW8Zi1PpjIAVOhU+1zluyn1yUTHLP5QXPO6XBdqkG3LpCw9rADAJnoawwmrtalrkFKdqiu/GYedQiQ61b77ST/otV/VJUtZ9Mmg40kr
 flS+YEKt
 DEiW11q0bYQf5WHDYA7Gg8UOx37O+PmcJ9HRid71J3O/b6j0zA64hwSorXqku0KFF53lBj47x+wERnz+qMYf4qTnmP+FCJLG1yaFl+Kqptm6aflyBtH1Ij5Nq7ESvVqJ1DGNQLzx8GuYLtJ5UW/NGWI/KXA2M6JrTemk9HnDjq3BESkcyhQZ7MW+smaRW84M7RRvJUPQ5E5IahAEahYu8RsBXn6wleaituG9B41PuuVnfh16blogtqEe3x/8BBQdNstQQS22biUPjUANzHqoCLgtg232tjrCaZkenULJKnt0AhgI=
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


