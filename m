Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9A10FCC9AD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5CE6B0099; Mon,  9 Mar 2026 23:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C416B009B; Mon,  9 Mar 2026 23:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181846B0099; Mon,  9 Mar 2026 23:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08DDB6B0096
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:13:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0B2858F3C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:14 +0000 (UTC)
X-FDA: 84528682308.24.C9225FF
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1708C40006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=V2IavMn5;
	spf=pass (imf04.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qn1NnWxqZ5SAV3ch/T7Tvbu9YC97L1KzKClE5EEgxDo=;
	b=LT116eHTcYC8YJ49vsUzGHHomJyatnJMstHr+NX90dbcKABTDiZvF02QPNHtofUK9Mht0A
	P4Z68U+8Cq8554D6CDl4o4g3TNqRcMFoe2VYhqEStFqrYY91iFqU6bgIGQX0FyZEoXCHbx
	/ahfq9KL68xuKoT1QZ6/Jkl2xH5dido=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=V2IavMn5;
	spf=pass (imf04.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112393; a=rsa-sha256;
	cv=none;
	b=rrMa4n8OxQ4k35EKFUQzYpodCeRHVHc9j3CrvbqK8Movx9jsfqlLfGls9ZdgQo7OA+3xQF
	tr1zZWSpapo11PCD3yK4K+AjSSc8qk+sdxl2jwsgWEUeTVWMto+U7eKC84kGA7mqncPnF5
	cHglArF1DnK90X8nG504IrabHNKF+eg=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-359f35dfef6so165752a91.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773112392; x=1773717192; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qn1NnWxqZ5SAV3ch/T7Tvbu9YC97L1KzKClE5EEgxDo=;
        b=V2IavMn5Ubvaxz9Zwi+EUhWJTdt96eWq8enjJ0MoB0wtbbz6Kp1S/T7yTDk1klLK2T
         EmYHviMOM1F3yy0I2YEsz/kHSq2Ibc2M9zSiPzfWhrmmoqO2+IkVFkaxGsFAysLefiX6
         BJ6CaQOEluYkaiVIWx7EDC0ysZARkN+9HGgkxuF1mRnmygQRPldm4M7MZi6OgFwrigbB
         NKDbPFrywPLWpn/2VEA7FBV7GPIYW3dOQ77zTrbJCpA7ra7ehp7EjdmzwrfO9H2QPbYl
         h2griqWSSLXh+mJjoK4VxO3RFKR9knnE9px/L9R8xQLPKNkLM6QxpboPB6eV8vfZK7wA
         SeTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112392; x=1773717192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qn1NnWxqZ5SAV3ch/T7Tvbu9YC97L1KzKClE5EEgxDo=;
        b=GqO8mjqBAzKihanIIxFFVxaAzhqUdxVc9gHZXMcB61UJuJOLzBqjI+MpuqD5/YT3cA
         xvJ57kMjYkgqBlgAxLw2Iwus1lmIdR9C9RNMwJmkQ4KotyPaT1F6mZISm6xp+SYxnmTY
         YGjvt1MgCNhwYdgVzZodDn/LHzxi14aGIeHNQnzFEhgoMLfCWHnt8ByfVKVkyibQsTTc
         Srpyc6hzZSQzdedQ4+MBp5XyhRR6jm3iAFP3LuUesPg9IYw9t6+qB8gQEpYXbxld0G8s
         bbn/5scQr+9/E9SGlM7CcWiqtAYOzOnH2/fV3xPDxWCIzhKtYY8atLKfaB2/XnZmnxKL
         FI5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVXAIQDWNcDcSgejXSpgRdyCB+W56rI/5QfbAlMemBKj6K7xY5YKECz6twzP7JFcnDti+relXUuoA==@kvack.org
X-Gm-Message-State: AOJu0YyHqtGfweVgftJJRobSP1y4w6puRiJplYwDlQndOF1PI15ofoH5
	1qbWnxEzp4j4xXyNECFSIPP0frbk05QE0nriJikPgOCVLR79BTohdM7IpMU66GWqRVY=
X-Gm-Gg: ATEYQzzPIfRavaumCvvyMR3aoVTe+TwLNxjExcd81s6HprY7nglYLr/KUB+YXy44+UT
	EgDGNae1NnOUt1K4+/czG5MWZxyN+c6Qk0re9rVRCXqctZ82cbuydEeYYtPOX76ACGsApxIK5+X
	f65m4DBlnjyJ5XUQAGHxMwnlK0IqkOP4w1/6nAy18Ua977vfJdhdZY2W2XB4hSg9l1XlOozV+TH
	EY8BZHw8GVDN9Wocj+TGttlYYZcGFBhegydoNOJBUNVFqPPqQNQwgiy9noMSyegSR9GfAjoLU3O
	FbrfCa7l7iNYtXZd+6lUgCxQivNFWMZA7FsCdh1j1F7VhuLtDgSr6Lq35eNljVtKVt9eZbh8YKA
	n65ATfr5ZnU9cmqQEbvPmR3VW+u1EUFMFb70kmZYTS6zd2DUO9PryRR9IqRTR4ClGMLinfly9+u
	KUOK3WMh3/kDeSKHs2g87v/8LuQtXOBxwhWppNww==
X-Received: by 2002:a17:90b:4c09:b0:359:97d3:5c57 with SMTP id 98e67ed59e1d1-359be34986emr12179522a91.19.1773112392014;
        Mon, 09 Mar 2026 20:13:12 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bcc28f0fsm5169284a91.13.2026.03.09.20.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:13:11 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V2 4/4] mm: shrinker: remove unnecessary check in shrink_slab_memcg()
Date: Tue, 10 Mar 2026 11:12:50 +0800
Message-ID: <20260310031250.289851-5-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310031250.289851-1-haifeng.xu@shopee.com>
References: <20260310031250.289851-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b67fxaop39podphmru6qri1ue3a3w3x7
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1708C40006
X-HE-Tag: 1773112392-368432
X-HE-Meta: U2FsdGVkX18ds/doTqUjuHW5TDIcl/dCIGof7cZoMNkrYqjZ4TEAIORxKXxYPhIYhEsuIGluGkFRjCg2cu+z8mIjrUexfHPP4/8t0zx+yYkJtZtdYuTwHXlS5wAsAPxE1hPB3Cmiiu8uyO1FsE/BQvim+T+2xlqZhIKnQ7HAq4+0Yas10uDjbduKmExtGE1gtEWGyK/XRkWiQhWuD67vNAF3bvpRD29shlNYub4MklcXXCiBu1mUvpBUrjbR2rbJCaXJFkHv5caJZXGkmhApTRbO4vlah39OLpGL0EpIBElUq+VH9eY61XFyHR5MLqMACyncwHSlvg+fBTn4qp0LBDrm/vY3oqvhKWu6TsIItRay8aEkwRpGic66Ns7XZ4XoOpLaHOnCgAiopTrnvxpDQxzYphybbG8M6u6bRlO5tLu6SMQF+nyIXvHYh8s7UwNnHS/sIBgPzcv/+YFrAJKVad7Tqz9qVkRrL/9I39x4dRpThwkWQJl94y8w2wImh3UDn36ZUbpyIpgCLV59JXdeOIk/brHE1dRiCUMaz2KA7YcNOFGCVhCTIM/7yQF0bOQwY4x0vOn+Xd6pzGPqdbeNSm6JsOB06KhkNZ5Xnu1nMu+5SVFx1aRobQ+zqpyArDAMzvyqscwPLzK8n8Dm+XWH0xMVn6YLGwFgE2JDkPAFXW8IMsX7y5A8XPjK54vK+X+l/9tLg/6275L+eIjn2ICndBQjmfp5c4pqPonWBGkfIeq3bQHvHwxlti4NfvkCPRaWbOoSm38Ah3adRunHxZ4oMPeoJGDXMkPlGuPu9QFisRbNqk9Pmm8z2fshdqLTohL/7ZeQS7o+hp+bvx3SBz4l50pGY/k/p3zRLjAv2UYRHN7BkaNH2GhwH38ix3jaAWi2nxEnmVuZL7A1rB3q+9OUOjLfU9dLO+IC1RtRuxMioPdkeZgbMpasCyaeb1z7z0sdqep3hnKcg1VmbhHepXk
 ykTExioR
 BcV9CBrg+eHK3j81B12V8YeyKe42lIpcoWNntV0ZNus0Dv1FaoclggmUKbXdujkVBUH2I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If memcg_kmem_online() is false, only non-slab shrinkers are recorded
in the map, so remove the check.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 mm/shrinker.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 68ea2d49495c..436387b3ba24 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -638,11 +638,6 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			}
 			rcu_read_unlock();
 
-			/* Call non-slab shrinkers even though kmem is disabled */
-			if (!memcg_kmem_online() &&
-			    !(shrinker->flags & SHRINKER_NONSLAB))
-				continue;
-
 			ret = do_shrink_slab(&sc, shrinker, priority);
 			if (ret == SHRINK_EMPTY) {
 				clear_bit(offset, unit->map);
-- 
2.43.0


