Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA64CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62BC8E0008; Mon,  8 Sep 2025 18:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A6B8E0001; Mon,  8 Sep 2025 18:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B507E8E0008; Mon,  8 Sep 2025 18:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A11A68E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:21:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 561201DDC4E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:21:19 +0000 (UTC)
X-FDA: 83867505078.07.FC86332
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88A2414000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:21:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IhFYMCA9;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757370077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9ddMlnJhgesFyfarJvyfx08wlzy1kwgyyy3+aP4EDU=;
	b=pDmdtB6gSGD8qXo+31VngvaO+dIXN3kBicudvJhELYPKQUj49OL/cIZpGQLYcCfB/VyjJu
	0bIqreUUd0SAJTdMKDLxSi93XnrYuiLhmJ1h6N8fZOPjga2w7GCz4O1ypS3ZGJSDUBN8kD
	m2kSIjoyKTkL0Q+7N3aT6NBrEM0+1Hc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IhFYMCA9;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 209.85.219.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757370077; a=rsa-sha256;
	cv=none;
	b=OlbjFRJBpeKJsBKmcce5D+qn5y6LL919bdlT773J4m2sPV25DXVDKnRwm80hnmp4ub1sOn
	mhaBmIsqln2XSWXv93GMyVAfxjUHcTrjpFJT3yaxa4NNrv+m1j3BHE7a7qohtMnbx/g83v
	lS2NwXld59n3Ia2Q5wpdKE16aogUAhI=
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e9baa0310cbso4718772276.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757370077; x=1757974877; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c9ddMlnJhgesFyfarJvyfx08wlzy1kwgyyy3+aP4EDU=;
        b=IhFYMCA9k5xhyCWEl4DkFia5+JZXxQ1f7AsyubcXGA8D6DxoqB/tmEguFa7hr6yY3L
         d7G1bXZp+2rikpNjMkdf6Jwl9v+3iPQ6jzvWEXiIEyZPZl8EJGbj51foeyH2xOHrzJ+n
         ba66ECaFPckZJif5rp3+79HS7919wu5xrwYnMyIMVG03kpc4T7TAw45nr66qLbn2Ud0M
         muaVko/ktaedh8TKgMW1Frko5p4hXoAN7xa+PJkxGY/xDGaYksealEZomC6zdGaHWv7n
         ESoSGHMofq/fDUd9uHQW1czoor/t3Cl+67EErfCcemOqDjpnfzZL5VKCpCbVzJKa9JWJ
         Ft2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757370077; x=1757974877;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c9ddMlnJhgesFyfarJvyfx08wlzy1kwgyyy3+aP4EDU=;
        b=hEsdQmR8VojF4ljH7VDnFhm5RPe5q2SA/zyZGb6PBQ2QkfjFRC7nca9ZV0Ip0MhFT+
         +J6WTe+em/HzN3LcFGoCYjUgiDNzC4kQmQeRL4+843V3G3VcSBpOlOQLWwoN9hqYivu1
         LP5F9UZyk5NF/FZ14GBzOmMKGq2LEIawTfcS5VsPK1npf2xbROuAdVLhkUJ6WbfM+HjV
         dC2VKzYw7I9Tt09xPkF6YmYM0cChehD6+YCGW/X/GdtcNps9eliNQmfEW/22kuLQ8z73
         R5/jyglZT9ECa7QGScgT274PW7f05c7gYWFnDui8sn6VKgrq3IfrZInX+JNTUNE0wanp
         WPFA==
X-Forwarded-Encrypted: i=1; AJvYcCXOrjxHvfT9NdGeFV8ZhZlJa+ekKjGymXXuTEigl7zzfj7nlxnnn6lypujH7L29ADkRwnBLktDKtA==@kvack.org
X-Gm-Message-State: AOJu0YwyF8xUtyrfK6owAfM4muj6jYy1YQaU3irhsXXhrk/pjgC3nCYo
	He1UugybJgP4FtJEpxshBG9RZB69B4pYc+nHlS/rQfVO6FYZBUgxPOvZEFaDxh0OQQ==
X-Gm-Gg: ASbGncsTX4sET43swHqC3kFAY+5V2ciG+y70aBSgcU6mAnOb2i3Y3ahhbwSSDFgTM9F
	tK8DUEK0C1kJW4Zr+1/feYi8SRr64Gm5aGSoVA6WGxdqe5k+ES8tTKWemVGpTgp8z4D6yckFcaB
	v0BUz8JezB9VjvIGHjst9SlH6Kx7YpMPoF1UTlTZPoXxemjww2HAtkqBX17teWqOMxkaa2T4U5V
	dhqTl3ejsJy2mwPy0roR/JvR02DJ0U7PN1YvHKU36pgCronsRrOgr1tRhgKsK51TLxZ/VanlY+7
	zb+NLrOWrpVd4is0TJDT82qmMJ/VUrY9X79EgNLpBdQGZAeBRROpif6nsDxMBx8IApeFYm7pWYZ
	s5Cl+PrQA+QGRr/F3uoWqRK/H4yWP3hnIJYIPzggRjTnRXDWj5w6Au1hWQv+BIYXCS0gGVT5eEZ
	muyp33rOk=
X-Google-Smtp-Source: AGHT+IGM8fYhE9A3qchntfUnqur0lqvaNoCalamMqRl5+gg2Onz6zfisAMxx2108yKC4pC3/UUNzNQ==
X-Received: by 2002:a05:6902:4282:b0:e9d:6879:5fe3 with SMTP id 3f1490d57ef6-e9f67ea672emr7444113276.39.1757370076366;
        Mon, 08 Sep 2025 15:21:16 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9d4019d53csm4681153276.7.2025.09.08.15.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:21:15 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:21:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexander Krabler <Alexander.Krabler@kuka.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>, 
    Christoph Hellwig <hch@infradead.org>, 
    David Hildenbrand <david@redhat.com>, Frederick Mayle <fmayle@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
    Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>, 
    Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 4/6] mm: Revert "mm: vmscan.c: fix OOM on swap stress
 test"
In-Reply-To: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
Message-ID: <aa0e9d67-fbcd-9d79-88a1-641dfbe1d9d1@google.com>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 88A2414000D
X-Stat-Signature: kfz5uw3tctzjqpj9xif5d8gq48zfb94e
X-HE-Tag: 1757370077-471280
X-HE-Meta: U2FsdGVkX1/DyacYMR7oL7tKtPr0Nc2fgfSDcrBrm1mg60AUG7oZPrB2Uc2AESw0bWg2t5Mj0/yHVMXLVxX7PB83IviIZMCGTA3dLafvK94oRx+ZomT3u38/QjM87nRndjwWZsJrGkVqsqhYW4rYEqFcpVPnet11d8CoLArwzGQHw1ULhXYIJXQGbFnqX6NERVdF0r7rPjtHn9K1RBNiZFg49M6ebeTILzTlg0oifhhS1QciJ6VrqFFUFk/ZTEgHNvudZcMS8LK/uqcwlJbf7ACuI4pezLmA/q0uBpRyH6pAQ8TzcU2k76XGT+r9m/B3qy6NyFzZR8ZJwtRIq0VLNakfLLZx3cHCpaIbP4loqHrZM3WjaN30wIkD+fsRt6/rCQUp80Amthe7apjebh/PrfGCY2Xr66parJKHc5VVinAq7HG8aMtpfLpxbmQKFdx0AWKMKq9MomzM8N1eRXclyP30zH3vPSZtkfmWEJoTKMCJyJTAvW0ln4YqM28IgVZKiCLvMhHUqXrGKFiZTTKq2PNx8xJKR/LiO6GAi0+W4qf87jS7PMEZw73Em764pD2L4cmJoUpX1CqqPWfrUFrvO90Qil+n7GRuhuJgEU1ILZdqtqx2EoIOORNsHq92Yh837dMeSnB4MQbLTN2Nxrdpu3AeP1H1B3mcuomTO+PhDIoa+JmxY+pxyXPfHLgYDXCgD5DO6x2Qlf0QizwINgw1p8lpMTrA8dqKozKkB6vtblY4fW+xPzsKRI6pKPC7BsmkJOnFAav4YawmDsy/JB281pECYsjsw99+9Wd8O2K0d6yQP7pbQV6Gxp3KZpm8SiVwBLc+YJMY0Lv8E4WgmbWm3JjdeLW/0Qs8h3E/b0rv6Xfbi/5YBBDdajX6d0jlOoH5xttTR4IMdOBps0CrXz+LvoMQqXj6Wb+Je7TvhXdodpDu7rOnJAmRg8td23Yun2UOX899xwyXfdnl1TcOcBm
 uaS1+UOQ
 8Zl9k0DYfe6Z20P9DQgzgU9Jdb4oeMF5Q9ctDg/9JGv8C8piV75xZ2NLuhIoflej4lPLV7Ilnp4em/Xz6IWJqejg3e1HO2UgkoBNtxTbQBOwvhI27fD2YhkpGJbap1iQCRHDyqWpsD+jBQNZYuJecB+1R11nRK7VbbF1l5Bt+wrxI/62M0bNvQxuMMUC8JgN8sX2QXjj/NpWqH4+il2/T9MHJopooHVSbwDEEXDHSRGT/R8lVZHu6Ce3FlqVdHtpLdTacfn4TqEuSTKxAySqGmX6Umk3vvcuCTr7I9GiEOgySpIJ5vSi3Tafm8bfKeJV1SrW2xNG+Vd4KYW7reG4fNFmN2kKdS3M4m3S87XaT6lzWNzyxiTVIMwlvraidgrVnypLg0gPB/aXqOQWo96FAKANC8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 0885ef4705607936fc36a38fd74356e1c465b023: that
was a fix to the reverted 33dfe9204f29b415bbc0abb1a50642d1ba94f5e9.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a48aec8bfd92..674999999cd0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4507,7 +4507,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	}
 
 	/* ineligible */
-	if (!folio_test_lru(folio) || zone > sc->reclaim_idx) {
+	if (zone > sc->reclaim_idx) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
-- 
2.51.0


