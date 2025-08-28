Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21B83C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FC56B002D; Thu, 28 Aug 2025 05:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567626B002E; Thu, 28 Aug 2025 05:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3F96B0030; Thu, 28 Aug 2025 05:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD6E6B002D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:16:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE6B6BCC11
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:16:46 +0000 (UTC)
X-FDA: 83825611212.16.A93EE93
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3953B100009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:16:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mlKlnhqe;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756372605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=AOQtyuZvIMzY2/2MSHSODxBniunfbBUj4nWDsUIHxjM=;
	b=YHNgdDHnCHqhsKf92dGT8droXCm8YFk1yzD6jTz/bD01tZMpOg0gX9Z3RgxxIUzzViOecm
	o8++A7qJD0A/uguUYtxA5lk6OyfMEDZUNtbbCi/V89gA3HF9UQOH5kJBZgcj7jvJBx3R3m
	Uw8arHVxklJ2j0jFn6XEPE6hXbQ61Ck=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mlKlnhqe;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756372605; a=rsa-sha256;
	cv=none;
	b=f2xtBHI/Niq5R05TXl56y+uRtGNeilv3SK17ALig3Ty+Y3RUITxALhhci2sY7vVwZeCJxd
	gP9OflPqhqRKoe4J9aPNSXU8sMNQHXh/KD3A2zns+7wSR4DBqlw2e0jYAqZ1zTTgCV5ch2
	Zrnk4sLn9fOc6PTkRG5sE1bd8v6CxxQ=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afea7e61575so75618266b.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756372604; x=1756977404; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AOQtyuZvIMzY2/2MSHSODxBniunfbBUj4nWDsUIHxjM=;
        b=mlKlnhqeP5q/FE/I1onI+q4Wg/Gp/pUNrJfj5hS77gA9wX7yOF8ZaZkfcvPB2lhidj
         ggHisxO3Cy+gfyBDto25eGW/Q/48EE2VrbNSyonMXhniZYb2pW/BJnR8YOP8U8qfzqaW
         1dSpGL1SX8E53uDp2IiBC2lnD7e46HBTJLoVc5BwfYQRyek0lXW43mXeP6x5JXZTdP1l
         UULSbcWnC/ypOhqLv2o73AdT3ymRqgm6q+lMHmY+6vxvSNkqPw35Umnbg1Mgupy/6ilg
         VrR0u4mBfnhoSQon1J60GK4RBAPSrbGvpYm9fwjnp4l8RvhJBKddhiyTcA+gUH9Z6B9f
         tupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756372604; x=1756977404;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOQtyuZvIMzY2/2MSHSODxBniunfbBUj4nWDsUIHxjM=;
        b=eK1UKe+G6Z6RbCktnfPzS4QMtTuwviRG0j/wjV4PMovNCi3IJcVULcD+19k+qsq1Z9
         aiSTgBq0bwrDQZ1T3a6tu9MfUD4mn/puy0nSdRP+/Gin0gcZeRTV1W15Lh2v0g4SJ0mf
         aHkfXYQOVKWyAhzkZSxjFIylsYL11CfH02d2yrVRC8444WQ+CVyWAmgcKW1unMoFelmb
         CHtf2LWJhD88BzlstH/7FTTIpkxbroFIgoS9Hl2PqI0mtoXilNSu4MX5jpEDgsC2cRZA
         1JC0ImMpNS3K5JGFBqcUQm/TpoN4+VyA1pov7ezufvLSWbu6GTkmIBJtQcqnOZ4kIKd1
         DEeQ==
X-Gm-Message-State: AOJu0YwTMY1NhSTxMyZFrm1bkIT6GeA426lzLXsgB+5G1Ouxp2w7PI/z
	zO31wT3lsYzDcy7OIxQHtPjpT+ziWBIUu3nrgDO1COtPyiag/nTGffXp
X-Gm-Gg: ASbGnct0SwnjDifAV6lPz0Fg76haTWwObRlS4wQkzPqEVemarExwpn6S2qz4s2SQMgS
	i8odR6NET2s1ab4ciGcMg5xa1zvpzDsyNSjxK+qhd4I3tXTZgqw5HwHz7Er7gYGuEBblYYbNOG9
	OE2beGg6as0QkyyaFCoYYVlqWh4YE1UDCUrf9smgDGrzNn66MHmqzJJd2bJg63vc6t+FEkm69K1
	hNQ4FGtxVsX/D6bAXURg92RdOlNWskJFot0XxVh/3z5w0lmqkhge9TersoH7FbFOXQGSz5T6YuY
	J79FbclXjMYGBcrsQO1Sf4ENMKlB7xJiVZaiKo5jyVmGtI0C3tuFf1FZq/fhZVo/wuWC2NshD5l
	s4bLDk2rTC3e6i1ijajJH/be+8GItE7PjjPt2
X-Google-Smtp-Source: AGHT+IGp3AIMhaQdSet5edp7PRFPEJedEhdk75K4ynpmUS6ipjxADLemo9WemaEkZOD7O3F6DnwnKg==
X-Received: by 2002:a17:907:7206:b0:afe:a2c7:78c with SMTP id a640c23a62f3a-afea2c70877mr720927766b.6.1756372603490;
        Thu, 28 Aug 2025 02:16:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afedaa774d1sm151433566b.89.2025.08.28.02.16.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 02:16:43 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned order
Date: Thu, 28 Aug 2025 09:16:18 +0000
Message-Id: <20250828091618.7869-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: 3953B100009
X-Rspam-User: 
X-Stat-Signature: s8wmte4q77uzyjcik5z1wckmpods1pt5
X-Rspamd-Server: rspam09
X-HE-Tag: 1756372605-613178
X-HE-Meta: U2FsdGVkX18TmjuKlLHF/VGHHpb7MtzE01hihrjb8yFQZZVmtJeUbvq30f6gWS4BqHsDXAc2jr+ieOv63i80zk5AeQR3Mq1oP6ZXR2rWyJAXU86aDas+tdKaJcBSTUQCW1kYFDMcjdWkKSeHu9gHA8eMPyhUvqErPKwQmaP1BUkRmRGKAVpP85529idI42BKAd6Fq/8HytlN+PoDSdGrHr9L3tQvGwfYNKEHy6loNa/kWgwVJ/5h/tO+9JPA+EbjgtIYsB7EmAKXh6erGmrup7SqBln30Y0MPMjpKe5wecEn2rCm42wydJLav1KLoJAVoppBnNv/2CLetu2kKeaENDyeQtEZm87qSL2HmKoq7/WvkMfQlV/MPKirTPS5PBvzYrrLg6IdtnQavnuQ7QUXx1ts8XK5MSCj8AJgkBw/ppeZpAkK7tgzw8NXnVU7dBZXDToF3xXzosmuKpMzp22JSXQVPsLJhVlm/deJMCehV/JbEkp+VqsPkK8YdO7y9lgSYP4bWeRmxIzwimsg21WdPDGVoePi7jzUInDqsknqRqxgR90VLLsM3VrdJNzaOFYZMUNVp8hy+agJcXKl5kJQc1RNrk1jj6+7LfYMAO+o94kkTd8KD3aCvn7wUtqCj/mJkdoCjCn5j6OlcjSdWTns9AyHp9HMS+5EhrP5Nk00BkzUec1QVlXK8/Qkt+TwHWLUS6MtnJEZO4LxDMHtXE2dZi0bu5ZbUwFFcEwAl0BayIbBZ88danm1CloAnppDi/8aeZDiYc5k4wtsIHijjgKcCrou2G9BTzWwQ3ytEnjiEc0zAHpJ/qYQJ55X1FP3x6YetZVVP/OugvsRuW/Y+uyyO8vV/I0BlM0uZVxID2EbIjHSRoz7gKBaA2GiHjef9sN2wWt2QaYgu77M8dGoN2hB+w9fmSV4GbVYyXTP9ZdMfnJOCq1wS11BGCeDiaTqyEfYNkfa9KbergZhGmmWNS6
 QfZAsUVQ
 qxOuyLimkWwHK7Cg/mq+C9fTErYYFUBhCHvdu0b9TxREh6O4ZsUuRgeyW8/gzrgtAwDLxtZXaDy/9debLKRQ6qaa/TUYrUZ6BivVkiJcGvqfaBdx0ssnenCOyAV0zjrutCOP+zTOOuZe4TTuY0AHeIQuZszISpNtZuBJeJV4PGDFvIay7hoQSV576cQDm4V/JcSvkgCNK9OwOwBLphDBhkIY/2mhEx2kwCd7WSHqy0EDMXS3PIiyuJgFN7nhko9h1E/Tpa9TkOVyjuBSjrX+AwUaCnPuwk31WSZ1Qg72+uLYYn6dGBpceYyEIfE5D/sJXlz+uKB7pW7TgmtIabIr7OY5PI8tr9nm4LC1sc0blS25BSwVEy++MdUDYFdReU79ctibWEMOLPeKAmq+w9V1qub9KIAAJdHC0ykcB0L1WbLkuX97l2PJaXLKagBs8C2egMuq1sehpfngvAVswPJc3Xjot77RvG+Z2yVl0QQMErPwFf9zNtx+q5MP+MUimW2kVwODLFKDJCojb6LLaunHHSPKsoq4Ft4ovq3IaSxL0pF6c/vQH0Xth3lhUEZ+kaDG+w+jJ6uQSaVtx/Ip/OlW+P6D/YWZSVVRQe7v1ZjbRgYijWMXYXmvcxI3y4vZ73T1itG4krLFP5WPDSFavUbb1zDFxpYthA2rSo7CUNxi04HgO0bU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large
buddy. While if the order is less than start_pfn aligned order, we would
get the same pfn and do the same check again.

Iterate from start_pfn aligned order to reduce duplicated work.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>

---
I build this and run, but not sure how fully test this.
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 27ea4c7acd15..7f2dfd30106f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2033,7 +2033,7 @@ static int move_freepages_block(struct zone *zone, struct page *page,
 /* Look for a buddy that straddles start_pfn */
 static unsigned long find_large_buddy(unsigned long start_pfn)
 {
-	int order = 0;
+	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
 	struct page *page;
 	unsigned long pfn = start_pfn;
 
-- 
2.34.1


