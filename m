Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BDB4CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 21:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5D68E000C; Mon, 15 Sep 2025 17:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7643B8E0001; Mon, 15 Sep 2025 17:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0D28E000C; Mon, 15 Sep 2025 17:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 464F98E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:28:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC66414072C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:08 +0000 (UTC)
X-FDA: 83892772656.13.6DC1070
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1BF4A14000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NKUH5Jxr;
	spf=pass (imf09.hostedemail.com: domain of 35oTIaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=35oTIaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757971687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fEJ6IElFOeZzP9UWymvXhcSMMsB3bmGnSn0zKtn7xw=;
	b=Tqwv7//NN1DOkaJ9rqIrvs8qWO85ayi8ZQWObnxI5a1ygqWk2FprTbqImF5WWYcr3Ug08E
	426WAHTTUArMNuVkPkJ9vaEJANwzZ9M7kcieSxG5DLwwdyNuor+tB3ZItdssAhJFsMsjBv
	ZVvSkcLXmeBav70cc25ToG6T2NjHZ6Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NKUH5Jxr;
	spf=pass (imf09.hostedemail.com: domain of 35oTIaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=35oTIaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757971687; a=rsa-sha256;
	cv=none;
	b=7My2F85I6Xl92pKU22iVWNMJZpOpB2iBTibx9EZC4dE/2ZgiHo/MvOzT8OySwQZ3kx9vRV
	OaCy0gPi+4pAdKK06vYdgV991ZguF3PcPeMNSKvjLnA84fNTsmXp5ic8rmBVdzJoxl1guh
	/kx1DoXWoci1OP62rnzTioLUqQ2ZwfU=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32e64d4923fso986976a91.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757971686; x=1758576486; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9fEJ6IElFOeZzP9UWymvXhcSMMsB3bmGnSn0zKtn7xw=;
        b=NKUH5JxrNpdCF/qSqZ7P7YDrKN1K1W1QBZLRSQYSMzAv51oYMd9Y7x4qIycxaD3GLT
         SC4Yl/KbdTNhYijPVqDhf+bcfRN/K4Pc2IHFJiCzcsxVRNllo09V2Lyx7sjKmq3sYrjt
         7AmVR2CgS6cQQeU929pKNvGJ0LJmyyKLF4LomWh6tc23g54CJhdfD5xHOTL0HBaIDzST
         MIAo4LODlWE4wVCE+lIOkzimMpXjDltSVYE5Y9mgl6h57wddpH2cZ0zq4eRdJ8hh8IFF
         4smPAicWk2l5Nn6vJ38nlY8vtYKLy4F+W+Y3QTLoBak9PffrrJuLBcf2m1hyA5+m2fYE
         UqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757971686; x=1758576486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9fEJ6IElFOeZzP9UWymvXhcSMMsB3bmGnSn0zKtn7xw=;
        b=h27FXvt7y2uSV1ytQctDULX8NTGGTKXnYK6D+/bxTuQ8iUl5964+DuMh47jM00QsVJ
         5mxGrWEUEEnSV28IIML2PYCEhyd9973Au6SIWhhGb6DRIGeDBA9ptpdWcXHmWrJ3KQuD
         tkrIIKDnpah78OZbDFBcCrCcZQhtXHx5HoShCntxTxJCpd7r+aJyRWE8763HKef3CvlM
         q/B8dfT6k/tl7CHZkiz69bYAWYHvZPD+iMSvHk2zwR7t0hVgp/3M5aGDJqY+OhitKSOJ
         e9u10PUjYExEiEox9rmW3WBUkiXNsExl812jzEfCYsawccVMwP2dQCi7veSwx/bRZx27
         u40g==
X-Forwarded-Encrypted: i=1; AJvYcCWUOtuWhd7e+A0AB4HV9LDIz6t83AatHvhAVLirtBITtxiSozkLZU3q2wVR1pKR/Z7rWKqBFvoZeg==@kvack.org
X-Gm-Message-State: AOJu0YzHUOBU0tBFOQmImP2wnb42dPeNpzotDEi4fFk+yb945nEcOtA+
	CLH9BUW2cCN2e0vcA3mNdFuKad4tKTOELp9yk4MfKHvT4/o6h4/eWB7reTYe3C7iFGo2W/Ak2KX
	E8MYKvQ==
X-Google-Smtp-Source: AGHT+IFJUPo9LPvtAkRuwP8Wle8PNDVxYyAftN39GDpSH2OdOqb+BpCFXVNO3SkD0W3Pv7ttuYAJ7A5yC60=
X-Received: from pjtq15.prod.google.com ([2002:a17:90a:c10f:b0:32e:8396:7798])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ec5:b0:32e:8c14:5cd2
 with SMTP id 98e67ed59e1d1-32e8c1466b2mr2709252a91.28.1757971686028; Mon, 15
 Sep 2025 14:28:06 -0700 (PDT)
Date: Mon, 15 Sep 2025 14:27:56 -0700
In-Reply-To: <20250915212756.3998938-1-surenb@google.com>
Mime-Version: 1.0
References: <20250915212756.3998938-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915212756.3998938-4-surenb@google.com>
Subject: [PATCH v2 3/3] alloc_tag: avoid warnings when freeing non-compound
 "tail" pages
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1BF4A14000D
X-Rspamd-Server: rspam05
X-Stat-Signature: o7rii7jp8cm6x45rx7ykgswgcn66njax
X-Rspam-User: 
X-HE-Tag: 1757971686-487539
X-HE-Meta: U2FsdGVkX1960HcahzUWGJNXEUHOp2U08d1Mw6qRC8dbB9+krOFSxUI17tAUnEFQW1RudbTbNkhh64FJsS3MwixLJZOYDeSTNDZk5ZySkQKO/7vSSbLYFYrwjJeaj5F40OPnNEMcwFKuY7CbyVgDSazGW4TyGsBCxnHSJBUZ5mfj/Ned9E3EOpgmKfK/JDy4WPr2IGiH0nq0qyFg15vhISWVxN0xIb2m2I6gKQNiSy8dJEatdhrhcdR9N8dGHpAYrlRDRC1Ruj35XulwsvgkeE3XOmWUGnLhW50VSWyb+E3l7Xy8KIeD7d6T+FeV9+vMtnN+pj/8rlOwxSN2l9ErE5OC/M/cnKlvBmlNgP15wJgVCpolSgdbJKchg5RU5e9wy3Z4V/Z3MpMtAFZ+4/BCoN0Gs64q5YDBw7k0Kb33UvqqHTPJiQgbyMTNbymjyr6YAvfxzpFQGVF8HVF8VvZMa1JvxgeDjdGucwZmysnA3dx62Fk9B91yGAYM7TKljasTIVJXyaDRbe8md+dT7xNnMSUo1NXdivlxdaFEtMKBg7Cbph7BT1j99Ixjtb0AMWalzW/uPfpTLhZ0Ms0CRQcmn8WAoyZ5dFhZj5QWrIJ1Zpw9cPue4wgsCeHfky0pNlmR6dWRzFbUiFRFk7lDgynddtGOe/LSSZAMOm9/kw1eTHPobyAc/lJc8aYgw1Ub9cx3Uv//prx8pAVHaSSP9I0I21oTY4t4gSQT+LYeCoomV4Ds46wZmwq6DNOrvqj6vvUd/hkpv40Q6/jGEvlA+mCxG5SOObrWnFV1rtqMeL9fZ5F8p6hp7XeoIlCCHR8pFIr54We3bmm9Uhe88yDjB/h1Em2fj7jswOhd8l2kDjuMM5QXufdacfLxUWEfNOv/KjoKX/FbH0F7IeDk4oJTHmj+KZgW2ZcYKp82Ne9/cSK2b2bSX1fchrG1wRnBFaNGJqwkz32/1LTzaIM1mwTc/pH
 ghY/SN5B
 LT8oI8GZ0ouhCj/oaG3mNbwS2zWFdjSzCEcGUOG/RA92PyVi7dwBsL4rLvSOK8qbbcFIw6hE5u0GgTkyJ9/dZvqhNwgHK3TnRQ0dLpJpXhzr/29+q6eF5ZixnrNvmbw1KxBQLfGaKOrT2W0U4a4CI/J8FsRl3LLDGJoQcR1qVl7F74MznUDU8+Z2nL6P9LbuIui/QMDoLTblRnvFqQ0HEO6JK8vA2/c0mhQqTpJ4mfu28JV8xic23qSresoQZgGB37lF8LSkYxOjDBeFqzPrI6F1GSMOlcekKNLasYSr9OW9UmpgKVmfyoLyH5htcb06Dorq4UrvbNjOIB0shVlM2vATm/p1Q7kHMZ03o30DPdbxM/sDS71FxboSqhLaQTjZJgTA+X4GOHVG8dvSZJkWnSBzBpkMw9KiIwF7B8rg3JExbRVmny+sKGYOXD/88/1OPckPv6v655q6r68mScoTnSevjcKcB/WSmhFBSYHedYXklW6OaA77CMvvxFkLGRu2gAww8mLcMz0JE5cgxmLTOhKqlzdE7IBr+iX6v9koxEM6g1Pn7Ce2iRgPFW6PZue1XvMlcHERAaNf3CsbxjGr6tjIV+tfgEqVCvyVb/MtaJBo1c9/N4bALIyr5q3zmyqYHJyys
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When freeing "tail" pages of a non-compount high-order page, we properly
subtract the allocation tag counters, however later when these pages are
released, alloc_tag_sub() will issue warnings because tags for these pages
are NULL.
This issue was originally anticipated by Vlastimil in his review [1] and
then recently reported by David.
Prevent warnings by marking the tags empty.

[1] https://lore.kernel.org/all/6db0f0c8-81cb-4d04-9560-ba73d63db4b8@suse.cz/

Suggested-by: David Wang <00107082@163.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/page_alloc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f54c5ee1e318..2bfab96c207f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5240,9 +5240,16 @@ static void ___free_pages(struct page *page, unsigned int order,
 		__free_frozen_pages(page, order, fpi_flags);
 	else if (!head) {
 		pgalloc_tag_sub_pages(tag, (1 << order) - 1);
-		while (order-- > 0)
+		while (order-- > 0) {
+			/*
+			 * The "tail" pages of this non-compound high-order
+			 * page will have no code tags, so to avoid warnings
+			 * mark them as empty.
+			 */
+			clear_page_tag_ref(page + (1 << order));
 			__free_frozen_pages(page + (1 << order), order,
 					    fpi_flags);
+		}
 	}
 }
 
-- 
2.51.0.384.g4c02a37b29-goog


