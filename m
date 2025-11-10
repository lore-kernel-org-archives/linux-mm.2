Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3CBCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A388E0038; Mon, 10 Nov 2025 11:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA7B8E0003; Mon, 10 Nov 2025 11:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4858E0038; Mon, 10 Nov 2025 11:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D22EB8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:08:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 811D0C01AA
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:36 +0000 (UTC)
X-FDA: 84095180232.22.2F28BA5
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id C268720010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:08:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jvCKFL3K;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762790914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuKiYqKXaLoC/HHi2F0UDEkiOMPWnRzm7yH74kwlVYw=;
	b=DbaqleOhDHxPKXY3QZmCwf723EH+zmzlOrf6GkJX0/XD/CTdPj7D3bLgJlHCs5zI7FWc0Y
	78WyLNPuR+uoJTqxYsXgVsfIF2EU6bulR9L2WX93mnUR7GFOKBTsexdHaS78gTBC5WGM7r
	1LYzoJnxpi8idk99EIumpBHpRFd8geM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762790914; a=rsa-sha256;
	cv=none;
	b=8Ukj8b3NGpHTaQMZl10TZKM0PwtUkvC+jZmSprmxnudgrjZncqIe81pGIhj5hI/pY8QihO
	xt2RAXZgGTV1VR3BQTChB5rK2IEFEPpEdSSvemJV/BGUDS10/XXvmlviyaMjyhBVnCVH5X
	/krra/Sac+TsT0o/1PoA03Qmh3oezbA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jvCKFL3K;
	spf=pass (imf03.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-340a5c58bf1so2206853a91.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762790914; x=1763395714; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuKiYqKXaLoC/HHi2F0UDEkiOMPWnRzm7yH74kwlVYw=;
        b=jvCKFL3K0hiBw01ifGYnJ2N7w7Ow0O3rN08Od/qNFe1dgp5k/31VZjmnuNVQ0t8h4g
         xRqfUWETRdPxbFHPpEpQE7DuIb1Et96zs38FbsWQUJW0F7gego12FWnt34aI3Fk3KrDO
         e+9bBSP3Ph9/Vk/Pjm1ktM+d15I/KHtPpfYmPXGSWsnlGA8g4uuVFXn/djWcc4DVJMVV
         cVQLHKPb19F8E9RxGVZ0SA96UlDxUMlZRB+g/4lyHcLTTD/SuhtvcXRXHZbLeNSoBwDO
         PPCvxUp7dLflzrJrXb+9e+LcJj2TY2UILNfXkG1SMs0YtK8JT+hUbznvwBN8Tk0HgndA
         UZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762790914; x=1763395714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FuKiYqKXaLoC/HHi2F0UDEkiOMPWnRzm7yH74kwlVYw=;
        b=SqVCoeuJKJGTbXZKNN9PBdDuwk345VVfU9NaU+fbPccErdjLZ3tafK1qxkbHMPx5PC
         yTuS8uSraq2DRKl1hWxo2EjE/p0KgM1VlOft/C5lDUONsbSsFQ69yhvpHNJcannpHSbo
         IBAhBVsUbWgv9vKUnAiQzoIsVWYDN7G9OnyrFHYeh0ztZZ/DY8kpL41hal213d5UEurB
         7/r4366BxC4+BM0i5IxUGUnpzxp4oLtxPKAt5hyjGOFS1U4er1xKKYzlo/ijlw53s3zG
         ZMXg34fFa1wkcZubVRIgOkg19EUXViK6vJ+9VW6gyatTm7pRbJsGRidFe0JF8jsqSJM0
         144Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9k8LMqu67v8Vyd2OaCgtx5NTaz4Vc3HItJEr2QJdmwvqOJq52xQP350nTHYHJz84GMAEhmRdFrQ==@kvack.org
X-Gm-Message-State: AOJu0YwoHAXEmeaksNZtj1AostPkwls82ell//4qNmC5oLBTSEJ6Nw4o
	tG69Bc3vwsT3AcXQb3+Vudia24raqEZIkoenJ84SGobjzv4dEAbc8zrC
X-Gm-Gg: ASbGncuLuJMk6DKCOG1cxqdISu8dKBthYFRsRMRqwnI5bvFymMGg4ObzWZQZrpW+VfO
	pjnqLpWrXv07ZL7lp2wppDOuRC8FrjJYLxwpzKQxp1pA09IX3GICuby5pT5is2BFjMoDb9F3taL
	W5l+OvqpW+/T51LyFCKebnMP7WLexggM+XNKddU2/c9/2bQcpU09Rf0LMZk7jPms2/VRdYyTfmx
	L5SSsiGuBNaI5gpMVQu74jbrQgrxyrCQH1/rMI0WTEDYIPg/lKyhs2WRLfEZbGBgExrblzYLSee
	bJpJFZsgwK6iULCJhCY/Vw2McZ9NNeaSBPMs52rTqs/qBHWEMVSn4/rW3NHGvfWiHjkRmfB3G1x
	py6u+7KY+VbskXKr0oxvG9BoKa9NCmm5g2+qNbLosUT7aA/W1S8bjiuAZzvgW43cYo1hysSToee
	JY5PfLiy6qibqs8IJH3iCpJbZcNae8EqnyqgaufSuaIxg=
X-Google-Smtp-Source: AGHT+IFxL86gMO8C+HEUrlebZRsB/XS5G9BUSOq9q06RQ47+OUHEKa103lg0GYFY88+iDHCfSgaIwA==
X-Received: by 2002:a17:90b:1c0b:b0:330:7a32:3290 with SMTP id 98e67ed59e1d1-3436cd1cb48mr12509736a91.37.1762790913565;
        Mon, 10 Nov 2025 08:08:33 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-34362f1f231sm9308893a91.10.2025.11.10.08.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:08:32 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Mon, 10 Nov 2025 08:04:57 -0800
Message-ID: <20251110160457.61791-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251110160457.61791-1-vishal.moola@gmail.com>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C268720010
X-Stat-Signature: n5gxs59do5fxi6nztwru99rho4ty33pw
X-HE-Tag: 1762790914-698643
X-HE-Meta: U2FsdGVkX1/AnXgcjfBZCnbwUL26riJ14Iu1mITzDxzLiSxUzr0DuLiaGldCCtR5SWCTcq0A26Tg9C33e63xS0r10qhrblQUBfdg6u96fivEaopSYNQDqJIkofmDJWTHGKig7/ExwRsvuRrDuEt42B+54ee/uKgkhtDf2ljUW8lvXj1UE/EKgSrZTMTI/JMRwdB5j8Jjr/1yIS8QXidkCnOtiYPymoC790kFWGNOgpdyrq57uheO2M+zi8z2ivVghUuIK9nWMYUEOKiwnrGakkhuHInGjumq3yboqar3vXOK3abshiDxVI4WHWau25tPJBeI0L3aZbSbuepcrRGRO0LGCevd5K04UpXCQOFKrJr7ZThE2Y6YCUTtPassI/UcH13jAegThA6lwT5g22GC4Tb3IGHhQlIeIPaVRU5ljf6RBkEWNlub8CKSVf6KzXcGtR0Po4C08OE8vW/Fvg/BYWwhsV21n2Kox6HRxTnGAUkcVU2cSMTi5BRTmpuYHOdfLMkxghqFia8febY8b4fjCoUa1O/LLnqZQsEuc0yt0A04uxjlqIIomZ8RmJJiLv7Yfq7I5aedmbHq36KJg2Yzt4M8vYaw/rylGSB292NiBfGn88fThASOzdrMRxW5/NUTa4tbPM06pstG9PWEC/hJuMdQJSQOB4/MJAGB3g7Pl0PjmrMNo/84przPhBZz9lx/nYILjhH3EPYNOLapP3D3UQdnTTIlzOFhrjCt5yTlcCID6X2CTiidLk6oLcMH10m3bNn4QtXSc13KczvwWUN1Qz3V4HK8JMWjuJCi6b1zCUyy1nVPtHJy4NgDMs38kaMsgd/Webex8s7JlvduZq7rWpyBdQg90c18lf1G/KSO19VEG+IJZOu7d7NFaVXagW4UULcCdXMwg0Byhe9CZjHNgpen5Bi7aYOoRDmvDgXRca5EDs6yOOXio0iQncrQC2NK4tdMF59A1KcZia+8XEJ
 mxx8iiwP
 UFTWWFYIDGo2+R+5EA4o1+pAbDvgWctUlZDLwAtRxtTR1VmsKFZNT6NOuaxjTJGcpKAbT3HkGv5DvXZxrIFWk/FmF3MhbcITl5cOAy4vqCVh71jbZboAe3t+mE9Xx3UDNipkmbk7f2t9yHKkWAfB4NkDVkVhpz3W7SDqqR+P1ohQR5GbGo70PSzm5QF3pQwNJZ0bb/gLMgX48uqUYchjsl/vpG7t1fz6ApbQUbagQwu9JmYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
this mask here, remove it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 970ee6756909..eb4e68985190 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 
 	node = numa_node_id();
 
-	vb = kmalloc_node(sizeof(struct vmap_block),
-			gfp_mask & GFP_RECLAIM_MASK, node);
+	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
 	if (unlikely(!vb))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.1


