Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAAF5C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE33C6B01FA; Thu, 13 Aug 2026 03:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBAD96B01FB; Thu, 13 Aug 2026 03:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B823F6B01FC; Thu, 13 Aug 2026 03:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 919376B01FA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25AAF120572
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:59 +0000 (UTC)
X-FDA: 85095475038.19.B5E9CB5
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57482160005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ec8kz4HA;
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786607457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
	b=vyY/7atMXsZMHbtqM+vVi7rns9SeAXwkmFKJHPdr4vN7wQMRiAfoQUBA+1XlkPHLigpBoQ
	MXdoFO4MXOMnA+uEBJXXYY/iJaeSGvBZ7E//Rpzi3yU0lroU5kmBnF3ipwmFuRKt5He8Am
	ZqpphHp+uJPdLTUUDvtuOH0BK7blnLk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ec8kz4HA;
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786607457;
	b=NzdAFs94Ho+hM39W11rEpNuONQvzyRDUZOWwyaRHlwYkUgRRYUXc5gFNSjkevespgd/7cP
	C5MYiyZu/j9CXo2p3RRALen2OkCyBQjXFYzGeuQjub/dBLDGC/YT86Rk1rbzI3tozrMYHW
	XRnU1sESY+AoLxe3GavN2+sFbZQk2ss=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d30c22b1eeso3309295ad.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607456; x=1787212256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=ec8kz4HALbAxOUH4m0KMfVLT7QFKP71a/O6ewPE4LJanYkFMdzjNe3WgMFUCAf/PCI
         aKDSyfSaYAMAUa8efGwgQj0kuNwkqhJBm2aqBD/VRrcgKxV2dd2bs+K2F3XEdObLnkub
         ZueYhYgI+ySjnzt+8UqGIIVXwn+xrF529WZfv6adBUteZqcR3bvJbaRdtGZjJ9ddFFJ+
         8qbjh1HkSvmdbz+T2uBgBxKFNR64WdMxCKwezNR8GHApMPizV0699PIDBQI3sfd3pf/Z
         JIWhU+09mrrd4O0q9GYpjpFrbqPz8mz29LiFUjE/V9YgTthEGqLkaJYJFR05oHjnPvAy
         N6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607456; x=1787212256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=aARYcdsb8HINUAfy3V57Jc8w+F+4i+5UUaM8AIZH2N5roNh8+uLTBB2VQsrMo3uJrT
         DVErWbmSwKE9ZNDOB5zRUHOZCQKViZeYa83S7zSFbejB1xgtxbDqtt7esVo8jt/IdHIW
         zMlBZ6oBN5j7dnoN6sa18ESDwNyHn5rb5QAhFFthzENkgu1AA7e8Fc7sS3Luaj0TwoC8
         ssuvxQJaAUUm3Lqc8wEsk0SQqZje5Gbed2hN/0abl3gt3Y31Yh29fS2LxTB4Dr1ZGK9E
         MRhC/waiJYeWXzTvpUDC1Yve9NhijwPt1KvXcLFp6nHEhxMhguUYzggeAabxdnLcwon6
         vbnQ==
X-Forwarded-Encrypted: i=1; AHgh+RpnHk8ghsj9jP3lysa8Wh1wxUfUKsXm5XNYeR+XbxBIDHQXC7Gs9BhlZv7IVHk7FdwzPAfTFeFWZw==@kvack.org
X-Gm-Message-State: AOJu0YyHu4IOAj9tkF1XFlkfXFzoM3MYYqV0DNE8FzuWMEKwdOrEQiew
	o4W68hT7elnQgtLa5+izuDfRbyVU/myffWD7ViDKZME/KvsKFAQXKTu1
X-Gm-Gg: AR+sD10hhZoE0ujjWpKjhbrRuYFNJo6/CLxItw2buUxBZKIRCj7eWqb9Emvu25jEtom
	YOYviomT3D2hJdia7qNTXHX/kxSxFqJKLX0xOuDgLjn8VPwyykF08MLYmZE3HaE2eHgWlYyMxth
	PwS+rb9nXrTR7Gx15z3bVIUu61EwSnLl0WRP8nEgyeKAK0FURmAb/3HyNUX6+uWzPKqGz2wMxWX
	fQQbdCoVIgJTOi3A7uG7vgl9+ILmjtl+yD2jX3yxSvvuheAFqQXLO5tKLdKoDBJe+fGEFatDpZo
	NDPBTCkLGg04lvCU3cA+m97Iw66XKXGOShhnyX1pgl9yA/cTBzPe2fzv/CrBXVOowRAAmwoh2If
	s7WZxVPQObVMlkVZJvWh/hdHlpC/SFHi6RWMgX0HfpBgWqb2u3YeTxCv/bMQcIdl9MsKwH0JC/f
	joS2sNH7ljGuF7AWBVSB8EPb7k0aSTE3HEoqMzmhaGE/ZSXEbP2ycMuF9Hsnj6tSbsC3lAaPX4h
	cyMLzvvDexkDmQLrwq4rWoGqGKT4Jv0sjGCPQ63K/l5mtrC1dZd84Pwya+DQ7SRJy/SY4FjEzus
	NlJVCSg=
X-Received: by 2002:a17:903:1a8c:b0:2c7:ef84:c58e with SMTP id d9443c01a7336-2d37d53f7ffmr34359475ad.1.1786607456117;
        Thu, 13 Aug 2026 00:50:56 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:55 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Thu, 13 Aug 2026 15:50:24 +0800
Message-ID: <20260813075025.1406585-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57482160005
X-Stat-Signature: h45ekr1ot7pxioo3m5cxqd6133pfnbes
X-Rspam-User: 
X-HE-Tag: 1786607457-90147
X-HE-Meta: U2FsdGVkX1+2rWvYm69uikgZPbnFvDqa+1rR84B+V2BVSIHrJluryUL8fHcgMQAQu+TGyN1H1O3RFhAbGHFZdUcHsHm1OoHrOyDWOcp+pGCEQ6RszjIwgq/2yJRTuesnpK/4fe41+QM7UgsczEwZfa2Huis/XzueOfq79Cjso+w9DcIxVGcQBzuuA4nVvKf66RfUNmqYaijH6NtbApbfTRmtt4ayuVa7iHTA08fNKjmM5+MKKNeUI0LkCwf3lthWlqPbpWX+s+rlO6S0xnSxc1Xvv6pDE4MSOeOsa19mNE2BifxW6GVn8HHU5ufN7Hz0MHHJEu45hNnYYGNFWlayZQypJHbfWIA9kU7ZAVrXEcM/fleTHIULi63xzXK/RXqXeXgbm6Mc7cJYDi006XjPX9Q6DEndgemf/gdi6oCTlSC28lBO3M321Qnw3qCeWabU0kn+wwyUwlrOvB7S4zgTKmq8CU61C81RlXyTs7izyQPFT4S+2TA8Nd/C+IWWqAL+WGs/gpfEn4ia2vIvSefvsJvyIEA24t/9ahrfB3CwvtKK3ci2fxnEfsjoo/klC9UK9e2t9H1W+C/QoD3T/OgfpqTQgsdCmB+YTvO19n++6IYvlbBVuEmMsG9zSwLxWKgJ9vexwzWFa3ntUCby2+AcDhSNDZYPLPCj+dIi6ssfuj14R1o/HTimKFuSz36Z7pwoPTbpqjVcHwZP3QWLKJr6VEbTZ+p2amsqs12Xy5iLh1mSaUwPHhk+TntwxzFUUFQSzeWoxz0aiAheLD7M0FVYYujZLajoTs4mIfUfkq5mDJtZeopI3pW39FTgqX68PJ+5UySL1uh+zbtymZmwKjcACICaVrKtcPwHkeCu256NpuHFRv0RI1g0uXXBeEZjuHKcujUh4i2Ugv6GS6JkS0BSG7udw6Zmef4t48CoIbKCVCqGseiytw4cPw0xf58/4mdFXCbd72E7ZuABXi2bTH3
 d+bYCcDv
 f78tUmYrQht24gDi+8AUtzKNHMlOnzsEpshKpEcDdp+Fj2HII8WXLxl8SHBcKAcA//1473TTVv3EUqGmKfpKRJb4Y2pRIb2oRB3DlzArpzCucW0igU3B8uR0Fwr+aNKn5TEkaNrpIU+fMaYJWjzlTd0zSUXJ/+Rtmo2lGSTnMN1JQAtm7mKRM0UP7r+Nm6nK4KNYGKEtHHc3oTvbxBS/62fg5DVg83wp+re2LLyEoeWLRxJ9WmL/GZtJS3h42kkR4AIPip9WIzws8JYQPDR9iKigq2+KNoyY3SBqkav7n1r4pHNqjjlb9QXWDb0jQ6ufSAE7RE4QzZK9irj798635DC1Uyf0+7GRD3uMyHpRqvj5QF4IVMA1Piv28DoM8STipCtB/fzlHSUySQaWLLioBUNaoGYpWmSI8xyHL4ICkYgOkFJOSrR30KvV00KLOUWdUGXgXV20ZiB6YPdEzn1Jr56tLwiC+tp51QdCKIp0mu7JTHk2EoSzVyvW3d3HK5kg0Lx93dZQrr5pG2gJEezWjmQObz+U005cYBppXO1CDkv2XRexpdhhujN1F8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

When swap is disabled, exhausted, or unavailable due to memcg swap
limits, splitting a large anonymous folio cannot make swapout progress.
The fallback only destroys the large folio and inflates split statistics.

Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
the folio might allow swapout of smaller pieces. For other allocation
failures, keep the existing activation path and avoid the split.

This preserves the split fallback for fragmented or partially available
swap, while avoiding it when there is no backing space for any part of the
folio.

Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 26df81e773ff..457049e130df 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1263,6 +1263,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1281,11 +1283,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
 				if (!folio_test_large(folio))
 					goto activate_locked_split;
+				if (ret != -E2BIG)
+					goto activate_locked;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
-- 
2.47.3


