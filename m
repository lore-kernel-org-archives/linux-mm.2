Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8807C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 20:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EA56B0092; Mon, 21 Jul 2025 16:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C06586B0095; Mon, 21 Jul 2025 16:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7016B0096; Mon, 21 Jul 2025 16:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAAA6B0092
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:36:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09CC2B6D26
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:33 +0000 (UTC)
X-FDA: 83689429866.03.B71CF7E
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50A981C0008
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:36:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RCSI7O4x;
	spf=pass (imf21.hostedemail.com: domain of 3zqR-aAYKCF0FPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zqR-aAYKCF0FPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753130191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cc1Ez/xk0myRMpWYi7JwhYCdmsN/iTRwifsr6matvKU=;
	b=7b3ONMZYt6RT2jqYxH/TgOSlWTEI2Ok45R9hAMAZWxDTfWpIR9a0Up+l+lmNRg+1bjHHA9
	7JEUj0Qlq5nTdyuhmnb8pXPO9jPxwMjL/FmohDhL52JeIewPCpqE/7mXNYItN+xBuhZY/J
	ZnzAZcoXho1RldqoNAxWZrGl+8gW36E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753130191; a=rsa-sha256;
	cv=none;
	b=iHApwhNEJTEVz9xtijz5bRbthcnHD5UcW7+R6zBL0NkrcC5vkVTs0Am1EOrbf6GCnyavCW
	SL8WY/tx+Ufu5iGrr60tTg7HtU5hqs68l7fBwCchVyP03I+8kWWUAHnP1ge5KE8ImZ3myJ
	UWHElhsKybMwTAragBnz9QSu8hqMIuk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RCSI7O4x;
	spf=pass (imf21.hostedemail.com: domain of 3zqR-aAYKCF0FPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zqR-aAYKCF0FPIDTPBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-756a4884dfcso4489805b3a.3
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 13:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130190; x=1753734990; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cc1Ez/xk0myRMpWYi7JwhYCdmsN/iTRwifsr6matvKU=;
        b=RCSI7O4x2S/4IUw1PrH6siHNV/ESyYr2GwXjUwYBqlDzuXlDTLCuoWwdm03FEbeYIa
         Cr2q2R4gG0xBm8bIbS3pCUT1C8225sGYQK2xQFKOw5X/4EXXNkRz22vqsBHFDMCkXPva
         yKSrxgFgLqtCerpEYJFXhj6fi7cPHkYYddf53SO5uiireXl5jbn4VwoJVZMz4wld8w6A
         sKISwRiapeduAA5W18ls0EhnrVw5DxJVNjYDD1eLWLO2DP5spiqnvAYSyUSYF4TNlQ2U
         Mh0KzYcDavBjRQbiJ7OK+Ij+Yi0Qoj1f0tw9rf6E8fwb3excyLqDCh3tHEOouT4fFbzA
         duDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130190; x=1753734990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cc1Ez/xk0myRMpWYi7JwhYCdmsN/iTRwifsr6matvKU=;
        b=SEtAfAK2jyO40p0voDs3460fUxLNPivNaDucm+7pn86TijmBF9vlCwSI51ohtWxWAM
         MtvdHn5HmhEdA8SXYD0hFhWo45fIcNdZopQfqZUaRFRiaJ/Adv1hiLtnTzycB0+FlxIu
         qKCDCW34SZrASnobIaEX/WI538OthNj9PNtfvPPxax9oOapJ35Jf/cRHqn1AoE5aNdkf
         1q5/dNQC3g1u9GQHeeTS1zIHqHGKDVx9Mf5hQ89bfaYfdJyvIWMTE3/edqJY5AylJK+y
         8SyzFDiJRXRdKjY+Wf1kSd5IXVc+ePEgkretVIMdz4+OOyb+BbBr9gBiytYEi2Ol5fxa
         aJXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXE9JpD1zmMa+GRt342Ut/jyKSsyp+Ytjk8GY6BN0S0ER3H7TGDIaAmZVhNpQoFTbUKjhCkG1oKg==@kvack.org
X-Gm-Message-State: AOJu0YzrZDNUWA9G08S/vbFvnRkG1Cx8NtnVOyUW5BlK773w1YU9eMqj
	GuFhv5nj3lNKXzWSv85VIsM9mNp70mtJ+i/Fb/2ulpAVpniRdTRMTNzvpNh2hnLy69+U+FvqYrc
	/JoWMHg==
X-Google-Smtp-Source: AGHT+IGaUy/HgUE6Lp8HLDEGr2kbd1XL7Q/OQ0eUpQ2PrdZCIeYCL6Si0ZJ9Rped6b5KZL3DccuQO15A9BE=
X-Received: from pfbhd9.prod.google.com ([2002:a05:6a00:6589:b0:746:1a7b:a39a])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a05:b0:742:aecc:c472
 with SMTP id d2e1a72fcca58-7572266ffdemr27218148b3a.2.1753130190133; Mon, 21
 Jul 2025 13:36:30 -0700 (PDT)
Date: Mon, 21 Jul 2025 20:35:21 +0000
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250721203624.3807041-3-kuniyu@google.com>
Subject: [PATCH v1 net-next 02/13] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
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
X-Rspamd-Queue-Id: 50A981C0008
X-Stat-Signature: uofc5ouf7pnquu6mch49c3su3xzo8tqx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753130191-558693
X-HE-Meta: U2FsdGVkX1+GUfs+HmEpBhKW9GPbjGsk1K9CWHYKyps85RJnMSe+P+Zj/X25Naw89kpU1caJug+6s2GoG64d1Z3TpaATfdEOTZpL/iwFJkLkSlrbvNnixPaOmGqprO0LDJIopDMGT7MrWgR8NqasByKD+Yq+9BocZwpe7YwQ8MFFF9r4dTglXv8NbPZ9F8UTHEpbUzn416oZwpA/TXCyN4ARxCD/Kb9TrmBzcpYfLRis77rhtlKyD985/TsztP5XdDyeG9MyASvYwysQD29bYrrZ/czxs32sCZxQxKGchRbPKPtsT37UFUAmr9qatQdRZDMkIEfSA49TUwZTcwiXQO1BEfRAHVUtSljAqRer3vCeZxJZnSVIRiVyv8sZFbTPncWlC/EDsfS/qedM6+S+hA/fu3ES+LGOII3vppIv37oqtIghLYJQfeK9+Ac7qycCHIdn5zlS9+/42U9GEV6YlDiDiJmgYXUjyabWIqYsvZGLZ9riSwJ9fmPYPWXcV9FPtKddbrJi64Mbb9GrQTXWKhPKHv34glZ4OyDHuybiPBSnLqsQzoKRAGgOhcKlUhWIZuj4mKiiK1pfqnkO28gwT2C5m4rCIZ46FXiFWw+7l1MyTkB2HiG23IBTVFSXeoiOtprVHGGubJK51XlXBTzQLHqoUd4l0Dm3Zmhq5oSB5wcuR6Fal/RBNgTwgIinJdmWDQhM6xACPskQTjRwrHK55aljeCsjQxxutZDKEJpmVkpDge0K8PcnFoYllA65UKWb2wWw2XoNsq3Ur9t0jK1KxC3/EDIHLeWIrdjlkXsZpoEQBDBOJ8beLRPns1DZchsxvWEqI7EIP/PJq+5oTOssY5PjDVG+AM6yGglQshV9f6JaK5LCIzPrWM0y/YYR661mYTLehvSoVDskCFiRgn8kapZjDT2r8HR4Q5YKdbGyJvgxrbRNReHaxDlli7AI/iezxrHup88o+BWL+WJ0mLS
 awIMNdVd
 qFV7mN4Vq4+U0pN6Nsh8jfQc0x/7lO/NLFmuybmGzUlcfUEvn3M8Gh4XQ13wghAimAObOy/wrh3xFnP3Ejj3G7sNpBhP28i7Qe2anDfRAIKoqtxgdi+3LXMkI1mC8N/32DH4lvChg3r+xGci+dZviFZVbLoiYlHm7X6kmpZevru1V2JhcNS76bXsaARQ+FU8asCAJxHEZ0ayddlilwy7f4y+k0rDCwQj3koZ6/riP4Uavz+/qjA9sDj4y//SpSJOM6rO0dIJzonN4uxX+AnDNXRr0kklu/xtVWyeWX7zMNwNXThTPi5k7mQ13BCvkTdC8Kq449hh8R20Btjm2B9PHa8Q6APwhbdrpg78Ww2vrSCsGWLGV1nFA4xSc88c+DggD93VwEGmjZnaC3vgU8X4waVVlz5wMHidqvG20NPA5J4Il/C+g4GOaO2JfyQL27dioRH9Mw7TfRUK08WiD2h27HI1FY29oT3hOPkkXfMbDkIPZojzQ9yqXMqfvvIdufyGq/fPnr94Y+JGIkNYryE/4XKu4pAefXngHA9+43hC2HlplCac/2ip5ItrDkHqMfQyXKtM7kBKpAsX8bcFQaImPdESR3w==
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
---
 net/mptcp/protocol.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6ec245fd2778e..752e8277f2616 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -787,9 +787,7 @@ static inline bool mptcp_epollin_ready(const struct sock *sk)
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
2.50.0.727.gbf7dc18ff4-goog


