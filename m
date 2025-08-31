Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C0ECCA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8D36B0023; Sun, 31 Aug 2025 05:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A736B0024; Sun, 31 Aug 2025 05:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647796B0025; Sun, 31 Aug 2025 05:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D54C6B0023
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:14:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C69AD8511C
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:14:02 +0000 (UTC)
X-FDA: 83836490724.23.BE2BDAB
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E3B34000C
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:14:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oLwQRtny;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBznXUHFnxO7JFFRA+cSHz8XvSsYLiyW87D5PciK1Do=;
	b=HVtT4ku3lvIwhTnrECmbY1T9zf1oXXUslhOXOxD+WTV6aE3jDepuCmuLbH9X9iG+eSuRCc
	EdLE19pAxerXu7u9mH7MZ5ZPWu6zQ+Jx9PiFSKOopN9NXnb6fSPM8632CvvVGSGQufVd4k
	FWwkYIe8vyXneigvYbfZ1KxO7jCQtno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631641; a=rsa-sha256;
	cv=none;
	b=CJWfRZbMvitFurxcPucbPJLX37zbQ9oYezVPU5Y+HEOzRYOEwsIb+npDIc3pCtE8nzPZVI
	t5JxGex3R6FyDFyBMxfZL6aQuTPURsE5+panivCN/lRueRYLJ3IW8yuXpmHJrBfZppOtMM
	Y0STG0vlzVmoN/JlgrUSn3OOObgT8p4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oLwQRtny;
	spf=pass (imf11.hostedemail.com: domain of hughd@google.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d603acc23so26280537b3.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756631640; x=1757236440; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wBznXUHFnxO7JFFRA+cSHz8XvSsYLiyW87D5PciK1Do=;
        b=oLwQRtnyVpSzaAy6ErfZV/ILudeSzp8krt+UCsAm489VqmqusKiaz8IgHw2N3Rkhz4
         3wMC5KT3ddLOGmZlxnR/86GFGQVYxQFcJse0asa6GYC4TXbeipd7G8auwxWxo2Yylpx2
         RyNRwvjGfpoYFnanBHQn9DVGvbylm31ymjHda5WcRn17NvxJTiOsOkrV1tG5WK1OtZgn
         5K+i7eUwYKg/axz9nDVBy5N0ox0LexFS92TRxCAQHtJ4Snv4SUA0aZIemn2OyD9ckMNv
         4/IqY+H0hGx2n+vKkXV6+iFmj3xxfTcjhMWaexKDGmymjkv69XqruGxNAdS1YINdhobK
         +eyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756631640; x=1757236440;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBznXUHFnxO7JFFRA+cSHz8XvSsYLiyW87D5PciK1Do=;
        b=VnyW+P8VaJ4sMfzgxSzhRWz5Lbg+yZu3S0Lmf8Z6K0lMM9RSf1Et13Lopxz6GIQGSk
         7AYzcPhMI0SI5zHlHbQjDa8gKyFOSRXE2Yg+fZsFmAKndOs8YgY3LCPIwWEH6BJT37cN
         5QjQkqDA1wG3kq8S2rC8UHfr7t8nsAT7cSl4dVP9Qo7EYtezdH1SWXNHnEkJJ14Y8jii
         CuXht2/r61NORfwEPqNFY8iMMyZpANbE2w7NLuw6o7HTxBf3lLtImRGvU++u0FXv4zZJ
         k8LsOKcRmW+uLJRa8W+0piPZ7wncboWg7DHHdvPkQS5ezqC4+8nj4RF4oI5wKNiN497k
         CCng==
X-Forwarded-Encrypted: i=1; AJvYcCXyb4O5wnidWAJx/ZfFDLx5wX4yEGV/8L8cl7KbcD4nN88mKjjSPUJ7HNCrmLr6PRnqxEUNslRWiA==@kvack.org
X-Gm-Message-State: AOJu0Yy+YBXS2dJlyTuD+YRd2URqdKkIidwZm2jSU5x5eAZvsYjyUGbU
	cdCRte/jw0wRDGW8KYEMrGXatIWbPA9XRu/VHeNhqFFe1FeNatIeVwLwue7Ze5cSwQ==
X-Gm-Gg: ASbGnctbRZQkKmbQyAsgSfY53cW1dKEn9h05r1jxpHG7/64thcAUhpftjZ2UpRFVARI
	YuHVf5lzGzFFVJqmNbmqJ1ZlVrI8yDeRM1GmOZ7GwQaQ0XAlB62X/4dNcF3PDgFap9KF/bJ559Y
	M2x9nQvdRQCd8V8GRn+JEziezsrDVi3aEvd2A8DHnwxWBpCDGD3IuIJpqIdC2p2DU1s/mLMsKqL
	hr7kY7Mar2j1L/UVKngEqjVCv5Lz5BK1mE+r7c1DGLgf0Ei9Nyx5SoTyCeWs8fvrTxrxJnhH7aS
	2ng7au17GRS+BjclZueYXvwPM9lfbSYIcUTDBquJoZgtngmG/0LtKBSSOegyN8y16ijvsdDY92u
	ElhEWwmV4YTNhoL85IOb6eOWuapGwcsX4N90b/LUWhMtF1IgyUzGc2nbKHz4hQFgl63TvYUqRJW
	z7Xp8wT3zvWjfFN2xHjQBzCDpKVd7kbU9as4U=
X-Google-Smtp-Source: AGHT+IF4yPQEPLuQmGbE0pb+TIdmkIJQyKnxChThhXPpgreHU7hHADg7CNY3Cer/6aWfeZDp+UC4KA==
X-Received: by 2002:a05:690c:6908:b0:721:369e:44d8 with SMTP id 00721157ae682-7227657dc4emr49185577b3.51.1756631639950;
        Sun, 31 Aug 2025 02:13:59 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7227d67377esm7100867b3.33.2025.08.31.02.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:13:58 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:13:55 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
    Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 5/7] mm: Revert "mm: vmscan.c: fix OOM on swap stress test"
In-Reply-To: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
Message-ID: <bd440614-3d2c-31d6-1b8f-9635c69cef7c@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E3B34000C
X-Stat-Signature: 6myhdcdbkff9w5km96zsmc73x9xhizxw
X-HE-Tag: 1756631640-764241
X-HE-Meta: U2FsdGVkX18wUNb2LBio/GKEt4oujnvhqzHOmxjG2zEdbLYne4+TweryQVPv8fe56q3B1b61circA/0iRaIgDgKEgc9FOwhwCRBvcWTiwXLLcvzKndNdiIcPT2Lei8pJKeuYzDfNCYBNenUZJ5sarJRaymaAvHOyJuc6TNGBCsdiOTMO5P92+7I36eYkjIaVBfiweeHIaixctz9L6SkRGO1qKwrSOoejh2/7EAWqr42dP7N+kuFwnr8A7lGGEVgHO4wVEkqaQrggZqvoZLTgHgpYydhxX0Wf0wnhS6yNO8A2vtpTQi2VNxMpwyppNZG5rjbq5jyxIplf3CZ+dTr6p8U3GxQ58qobmJ+RkFpwv2OM6ILA/U7g/TTLy71NDPERDmH02MgnxhZ6tX2AxAP79CzL2kJ4orjW8uUU/c0QKAuJd4HZ2ZkmYiCTxADjBzo5j2L+0/FtMDo9TqW35VXsptUuaMS8t1GJdn0eW9DTqggkdC5gSn7+lpXi3sjobqp8ZO8vIYeMDS4CVIjNfo6hjCD2UBT8fDD++d9Gp+2FORmrc13+9JkNzC3jNZtpninoh15JQ4dGgEWRYaEV0DkVK5h5QrisPTtT2g3cRvEHpDbCzBP/8dVnYsMTz5yiDn7Xc0JGsZE/2OdJuofJlzWds+JeVd5CJA4MFPHl12ISjl8YPaa3daIk0CHvFxqu/gdAYunKwHI3E239EJEnQrdu3uXEIUpvJHUWS9W2OcOkmEXObHZJp9mukUnXFbljD3KALZ1okPGoSmqY1WfVW+RmyxTLAuYUlktfQwL2/ChcT1d8bzWkn6CCEuGV/gEnZ7zuDapRzDJh+4Rl8YdF977Tjuu3HGRqzfMqwCH4zEt/Hi8Vco8rnYvzyyNqBQ/JSI4rAxoBgvOYYu8aNHa4y4TJ0bOZZv+PHe9GAMz6tekcRnrIDDJeyDvNDbecdnlIeS8qLnHy78wU4LiH7M0ePdX
 2+Ywml3y
 azGh8Mc5UVR/Gwo6npoLKEkJxwuf2bhQ0u5M/xuwu+iAwqncQJmFYNO1qOgAP/oz2WiuNFMw8Ff4oJVCivORvHcxPwdpDQb4qSqGY+Beo3jRHiKhIuG1YPPIKuWTCrmFjCYP/1W5Lsnab/65OXtpckN1qe1QDAoCoOGbISo9QxCzpcEV8j3ryvbKuw1ak6JhVzPp4BLwCFTRtZTVzSRYlq8sl87wjv0a3y41sMMJ9g5f/SwfHuyzEwEAU/rrIdtyCncVakftLcuJbKT0Blke32N3mBxg6mrB3EUTTS58iT+2qawizsABJY0HHhxjqw++ZkXcv1KsutejR4gI=
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


