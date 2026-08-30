Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A462DC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD02C6B00AD; Sun, 30 Aug 2026 00:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A872E6B00AE; Sun, 30 Aug 2026 00:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996206B00AF; Sun, 30 Aug 2026 00:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 718E96B00AD
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:29:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFA7EA015E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:47 +0000 (UTC)
X-FDA: 85156657614.14.464D06D
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2269920004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:29:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hc53oce6;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788064186;
	b=tvWewllqmF07yEepZJHSFeO7fZrQ5PZwHHf0GDMrFGCb1HMvovU7sjkOFCb5cCD1wgSkSQ
	YWcjT47W6WlTqTPeUikk+6YjvKSWFEWfN3NZRI66/sA4RqfCV5EfaiNYHxJSU2ZWOn1SMy
	87qc3lHMtAwgjLFiMWNGzmc7Rz02n4o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hc53oce6;
	spf=pass (imf31.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788064186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
	b=gdXanMd+TKjP14Ednwz9/UEYJx/Khy9ywqRpg2XmsZ0NcoGu0jBRJ1jUqwkdXR+h0m2G2z
	/X5KLsAILMKH+w0tkd+SRwVsaEK3H9tBRTTWFl4omNSt1Bes4AFFfwFQw1Go4AXOZUpEad
	QKVftUwvOgvjqysDprMnhltFcmN+n+s=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d590f4c291so7455615ad.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064185; x=1788668985; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=Hc53oce6BIBlbVZLo09BdI7FufqLjOqdoMq7wlvrJk/lKWODaGfpdxSTRQUHepQGrU
         4cmIB7i/ab9k7Ntlxw+WXcL1FLbKaxpNRf0Z2RjPpeUuT2hl+1X/dRKWb5fX6cNUcpj5
         OgT8zYPFVec2t/n8AjeVyYDn52So0d0fap8Z6biDiU7EI1ukcNr81ugnbz6DzluIcmb8
         Wb6B24g6/BxnCDazvovuSa5QQn/oZ14sjN0wq+QDtkVENdbw3ep6vAIGcS28/8tnmkJQ
         LrR5BDQqI9Muk8PXVTi6TVjAnrQCcMdWcYJnvFaLDGXeMZS425Ypnab4H8yq2rXcwO3B
         hQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064185; x=1788668985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=KEmyQ68gnWqnYC3G0YOJqqBYYx1yZOi92cmWHTQiNVYfuY5GC2I6cpuTXutwxGGB4F
         /+mT0ofLbFrywFUptDhZ0mMOGsBJYuOMjz9nvtIxmMGOmkBQN5Dmi/HR1zLv84dQLIhq
         b5G8tXQjybkLvuPRCuR6nAqtuAlbwXAC6bpoabNVbb1x9wfOVj5NKJ6Qw5XvRzXDjepV
         9dkfiONYZbiF+Ise3A2T6lxQ+afZGWbcRBbwgRdoOrkuJKMxs06gHR9twRLby+/xDMCM
         QadIlj+i6GWnSp/pL44Qx7w4DUBDPe5cDYnZurXwbTMjAXJks/AW6z4LeW8OBTuj+fWe
         rqHw==
X-Forwarded-Encrypted: i=1; AKwUvBzL4BERFr+r5XxEEx2yre4dyrfVtPJxA7jbiZ/NPDq4M1mAVuQU4zHWFyYRc+CvZdf29XDMgbZo0w==@kvack.org
X-Gm-Message-State: AFuF++nmti00MfNm4h4YGNDs6ZxEMh+Dr/qAiTiH2AwVJ6a+YjK8PU1y
	YFZQbaO0jM2IeK2NyuvcoZO40PIKA43sHUusjfQEU9RMxGyoCkKWReee
X-Gm-Gg: AYBFou3hoqcD901h8iCY/BN6OoDZAtSISnp/CLuzsKN2unBEftax/57Zurh1oj80s8S
	927UE9xpc+Zmz5Ky5IHmVT/8gNE2OphHX4p409sSBA1LgqoQZoo8AxBSu7LcVmsmSeIJ+x24Usl
	gCJrkukF4KtejrNweII/kQd0cbdkIYKlDeLtlwLHFx5h6k6IARKV08Fn1rbFd1SRRFsDPtLAp6g
	M/hcrNoIM02dy2AgBwoYgTlZxEcyoSbBje0CWnHFD1AwpuQTnPCIYssTuhurxbxoKArPVHFGhDi
	jHVOx+IV1nDJ8p+rqfJ60S6fnOH5bJ7ah3JRA5BTLrU9zfnVE76GZtH9dfWyNMeRgi2TVC2816a
	buh5nrYDJd4pHjMbL4jMYB/nbrS99svSvszyFFKtO9RFTntmHYSFgoHU3EOoH6ibqzSs3kieUq2
	0HEM9f07W7KC4zBayIMil3SH1566Ad06ye4+LAhqQDl3KTHNJuklSo7z4SxlKLGSMXhaRM1pMwq
	TLQgZEzzN999SNhDkP9hEKGop3qttksd5vBNCmcN6b7mILEXck=
X-Received: by 2002:a17:903:1104:b0:2c9:8287:fd0d with SMTP id d9443c01a7336-2d74df62ccemr151520335ad.3.1788064184852;
        Sat, 29 Aug 2026 21:29:44 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:44 -0700 (PDT)
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
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Sun, 30 Aug 2026 12:29:19 +0800
Message-ID: <20260830042920.2280454-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2269920004
X-Stat-Signature: jgjouh9jkrjcgrrfryymfiim3a5cyyrr
X-HE-Tag: 1788064186-370514
X-HE-Meta: U2FsdGVkX18msQZ98pMGENo1vAJgOoF+8obaIz7oa18qCD9XhMaV7Wt7UaYojj1vInJ61BMYpsz/x8aV5SJu9kZZVl7r2OtrB0V5g8iLI+kwDUtsflbRX77vgSMdhiP4UDkO/rIJsuCEbmohlbjE1lnmxgLAw+pC+AxKpWXg+GPTAEyKKzk8j/Y4u9EPqV1rOMScwTi0441hIPJ9nPfAC4OczO45nzsrClMlgjoW4EF/YZLXPtKSqhY8RzMGupOxLIgAsbvACqVlfZnJ2G+bjMxjCbgo0WCeS/7cM1qUh45djRLY4daDKsfaEE4PObunVhpSBNBQ+GZKB1VYPW0sUnWi+VQ4hqOkdixFmNOjDSehXaBTIphzwY3b+tkwRu5sk0uB9d0/VtdxgD7vouT59iL+9mkKgKCmvGxYNuGKyzzbnMDX4U7dC9dPFk2wpNZXbB8dsJF/OW+fvNkKA2peEGh0GRdrRmQOQ4NgWkJY7e74aPj+Eapa6TjLH1Oxqu5WxQuiyeqJx+f5epASGEFT5J1Y3PZ+K/GG8eoKUeDpW4nf2QGoggHMB1cqTEMU8YCwm8SKTxWHIOr0T4ZlEr15evYL6hBKG4YAgTfKATwjqsG/WQokKGdETIiq0UBOdKpo4KdjM8c5J3+oHNDHS95KekFZYW6tZMmX/oJDchVf0FvMZiNOS1NTstv7z5e0Qh/obSaexlwNPfJhOg3ki+KeV9xZReJ4GiIoJCDpn762BepgIyAOTDNEtyaYCuyH+jQkfG4xR+59Va7Xd8PWTv8is4F7fyz92S2RruG/70u8TPylrvfsrUEmwfj0bwCsRKLydNyVeiD2mYPrfhxa3ceyWrBHtd+3tHjXJmdx3hNRG+OjqkMhjRHB5RFzAN9I6bImF7QHKjGM3QazACUU2FJnUOwM2UGlk8Jl3epOd551D9t05dlSLP1Fw5ywFxw4/qi6mY9xBoCMT6fekKvU88Z
 jjdJiIWH
 PiAXRWEzqfgSGL+iTIGXigVlb2Wpcrnwp3IqaylupaeCVcMmxW0jGIz30kOMyP85IFMTqFA4Bz+xw/EBML7i9EMVaO4eOoQ4V6UhTWoGXU3QL+UEziHOHnjuBpgohuSoTGPH4aEvsHy1CuCaHITDRo9lJYY88bmfYb5VXcph2e8lieNbNnAHnZxFOeOZyxfKUeoG1CDRuaie7RkyCD9ZDYZqA5BrPaHbQ2hLCwfp6+zECBROkf2AASZWTu2EZ8L8bSfxtg3GFd0PArQwrh2pTrZFNlD8Oo/q3173VZGKLPbmwyE7KtSnWpqKXOSyrtSBNCAPPLvBqqncetDgXXAOfMJHom/l2YnD5uQKmShviHUGJp+i8wGL3eTrIxDCNqoa2wB6423eb6/57xOFZ9tbgdjYyCJJY1kAaHrqTPTL0E1jdHy5z/g318mcUI7rh3YtAEocUXXByR2Y1QKtWYwEREFVGwfQH889YvqAfjCX0erdN4Xn37vWJnJiuAUM55COy34E2sONqdxpBGIlo3z9Hc4sezdGjygB7NEXnb//9Gdlfub0Qt6bd6lL5Sg==
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


