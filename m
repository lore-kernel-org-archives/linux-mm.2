Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52120CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CBF98E0009; Wed,  3 Sep 2025 07:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9276B8E0001; Wed,  3 Sep 2025 07:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1CB8E0009; Wed,  3 Sep 2025 07:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63BEC8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:16:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2CCA1DE920
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:16:20 +0000 (UTC)
X-FDA: 83847685320.13.12E3472
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id CF3B91A0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:16:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aqSx2d/z";
	spf=pass (imf19.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756898178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lABkHSnvIXMnQ3mvHA4p3Yj4MTD8nCbzazJj3CjC75I=;
	b=Fz6lfvqYWQiaoMPfggQ+w9xmYlMo8Xs29HNp5O6OY0F5b1mWH/38NU6GPWwpmaQhzniWfs
	5vxkziik9ydK6WIHfjQI/gUoeShu9+8fbF6nyu2hWDxqVU7G0qRSOAp8JmO3lmJ6Acl3pc
	mGGFOH/6suR/R6of55tTOL5CnFYY8iw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756898178; a=rsa-sha256;
	cv=none;
	b=1u0HVXAHWCip2Thg3OHBF/3McMq0jyeo3O11VVlCha9h99b/kEM3Amn0yWkQfjXLhqML/g
	Akl+h30CVLQndqqeOnvr138sORAKOHWEllRLU4QmlI3bPIZqgjmCXzTLFaoHfgsz6d6osW
	KSiKr14H9wD2G7UJu2qTRjwxk9z5Kg0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aqSx2d/z";
	spf=pass (imf19.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3dce6eed889so547563f8f.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756898177; x=1757502977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lABkHSnvIXMnQ3mvHA4p3Yj4MTD8nCbzazJj3CjC75I=;
        b=aqSx2d/zKdmr6k+epSWiHMciml2BiC3Ql1cQ4yunjGXUQzAfm6tAAqmJz17giixP7r
         kV9fb87/6+6KQuTOV0bDd2igW6jCKo483BOTiFbJFHIwc/JQaR1aYLkU/uy97Yzf8nOh
         C+5f9TNngv5esgKzYxhk6pyoW/3atik+7o/m7vfrwNYofjJAbC1QI/dhSDHJDvfE1QVB
         aAvrQA/M7JUlIW2MSOxgyC3jxkVwTXOmMQijN4oWzMmFId3GspW3mBCtmRx5wtDxqNjJ
         +iaG6bbksqsuDGBfjHSVnNQac3c+4+r48uPhlLKN80yifYZqsDEcMttGhvHr/EmdXpe1
         kJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756898177; x=1757502977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lABkHSnvIXMnQ3mvHA4p3Yj4MTD8nCbzazJj3CjC75I=;
        b=BGS+dX5E8lqKEwpkQF5yEXcC7VV9ZD6wwR0zTPJVGt2HVGKwyLW5xYqZR4QU352xNG
         LEXT4kHFS7Kq+jEpFgdbxO6PfmkE4h1VCcenBqSb6mUcxnQSlNdqq6XcWBPhc+QqQL3F
         aCLwIzikc7yQv0H/hhAToDAmDyHqMiUCliDHFmOoXPCIHgQZDZXE1TrwvDMqjVepx9YB
         /q1msReMxja+gsihYClOMvJ1DoclhpPtNdz29vwIM1JVM14S+aJxhfmid6T1ez2B12mt
         U/Pc4dgRd3bCFN/R59U4cmoPmhOpKqj9XDUwZWK+PzgQ1Ghx9MHy5X4Os5hwQ0AHx8ne
         WNdQ==
X-Gm-Message-State: AOJu0YzMoxaEBg4yCxRbZ8ZyNPR+clELO/ErmLl3lt2JEbg2Vlnv1WB1
	e3rMSK5C8fgYnoum2dO/nQK1SyDTkSWKF5Auw8hxYFT3ON581BqA+IuNtz/lNdU09EIz9g==
X-Gm-Gg: ASbGncs2CNQ8x7DgssEGy/SRMg+1NdYN6SiqrrImW6fJZGPg30cTlC8tI74Videmkce
	FU83hTughlZxqNqSj0ozslh+/UDUavxik9/Rb4IKLzXSbraTbbpB6kn0zYSh6VeGUyqfqIr9WWS
	zLmtC0qW9r1icVrZXKvUbQz/KOExIKy9jzn2OhgqAbqZ/98q0rh9Yp5f7YEG59hRWDghkvFgsKy
	2i5H5ZTz4OYDyrGrCcFtq296WZflSAn84moEWGytj9n1WH045HpqJQXpSW5DQRm/umaa+uMdfRa
	An9eohF1m6c3ck50YSqrNGwhlZnwfRLCGE6bgVoD5c9BsHbxI0wwoM7kTYYNwd7WFo00uP7uOR8
	75e42ZEUcf77y1A==
X-Google-Smtp-Source: AGHT+IGyItH6fhxqweNdBqrIhVxCLFxL0ES/3HbetquX8Ifljh6FJc6e7DueFc9I4VoDCyRFj9PknQ==
X-Received: by 2002:a05:6000:4203:b0:3dd:ab51:d979 with SMTP id ffacd0b85a97d-3ddab51daacmr1895384f8f.10.1756898177219;
        Wed, 03 Sep 2025 04:16:17 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:6::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3db72983560sm4717559f8f.1.2025.09.03.04.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 04:16:16 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] mm/show_mem: Dump the status of the mem alloc profiling  before printing
Date: Wed,  3 Sep 2025 04:16:13 -0700
Message-ID: <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1756897825.git.pyyjason@gmail.com>
References: <cover.1756897825.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF3B91A0006
X-Stat-Signature: 793z5o1go54woi1nmqdjte7c9g1wwxqg
X-Rspam-User: 
X-HE-Tag: 1756898178-209054
X-HE-Meta: U2FsdGVkX19PSSz5o81PKC3qs3rnk48e1xgrl9MJBFwaXPVYxN//9UByW4k6V2gE8EieLfW1k7zmZgmTMw1po4QsZwxreZHvfgiAs3DOsRFsr0gQU2YOY5SyCPwWgoxtTELfmqCVhfv+I69evqAURpyFH61O4bY8zU4H2zuRawbYcMayc1fWK30jX3/N0gsiRmAebljxiyCQW8dwLYGZ+Im7HxxFb/Wu53YYRlE6jI5egBggrUZVtPQUCvZ3H/vGALvWxPPheJHVsuj8pEasKz2DEXEjaQ7hvQSUzNQnbbf/5PRO7NR8npW545bTYEWPbHisSRxt1eRRRlnNbqXIi9XkjEsQgPuyB35ahBlFxC6mrxqFzPwGm018J4EIpUWhJrU+ZYGTP48OqPyCJOIh2tVoP+/HRJeLq/MAYl8PnS0NjyMqy/SAGdPkZlCnRyujzAzbJ+8OzTyf1Sdr9ctEZs+ClNzpsEkIvpBTZsSxaLzrKP56Qu7KnwHcFxwL7hIojeaBk9ZOfNa6hBkF5yhdL+idlH4aLNJK/gyA1Lyphc69nlEMjZPn7azTf5W3exfWhBpg7YK8vWsjcOe9gRADmqX0PXmcF47KJmQw8QYYwp0XP6evvTZ68YHpV748xeAvEXc1jvolKAWAE2uJGfO1nWuscqw9pdS5jtf5aq945axilsFEDqotBkCS5bu1vFeBkME94/64iKU4dovHXB/JllewKtUxlwSVAdRTl5rSgT8TPbOqj97S52B44ZrbBjO5PGHWPvGLfN61/dRySGoielsMj1Oo0ztEKZGsjsQAEWm+5bX17o44EHFSdSiGbl7FonZGyCQiZ3bUpZozjD7hfU3DTTAuvEF7Sh98qfQoCpED/mZoHsVDxXTtgwpEIVerC/G06aVzL4ZV4pH76m3CDaOMYPw4csv1HnztCdzR9YpyTYXbxR3Ww/HRy256GdoVyGpyx+Ol4wKsS1Uu5U5
 m/NZb5+g
 7k+lsXIE3hJMiq8wLE70ER3VtH8MOpMdpfXqkikc0vCVbKHptUHXv6YK0gDaFfkuAaqMZcCOJcYkDNhMEX2+1H9WpxWyh9U1xplrDNAImkWsHSe7DRk0Mscp7eIAwXmxyYmqisaUcPDrxtxso9RL+fxueb2Qe6KkpHOfj7zH0zgj9m58I0ZYhbPARAWgrqe0geg2yPd80C7ldP3OLmq71VeU9mWyW0bfAzDHjnutqGZfvSio1+Wdr50AU3k/tieoYOh7C3i8nK6RvtyAfz35jB/+v1WM4unsRZgNRKMabE5DvvMBaXgUH+qqws9S1MEOzuqJSQ+Hf4zMgy7Kz26ahVt3taYONHeqCL1a46Q37pRlrsFpxtTP+psHd8B3Qp5EaKqlSNqIpOctJGJqVlIbu4Bye8PawPD3sFyx+ytAz2N3GggzDtM2a+KGlDs7J/ualpVVWtMzjafZQQs8Mv/PooSBdAE5jLjuM7/zvxGf5EXh+gsXc9okDwnhcB2sHM73Rbqx1rXzz8shgu5A4xxzD4MX94ZU1ZN+BVxtZQ9nsmvf3998MFSFVWj1NlzQ0z4HE12/0DHTMP7Vl/6S0p6cUShe/ubahcsIouWQmWl+y+yayqqqNZiqT9hizQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch prints the status of the memory allocation profiling
before __show_mem actually prints the detailed allocation info.
This way will let us know the `0B` we saw in allocation info is
because the profiling is disabled or the allocation is actually
0B.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/show_mem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index ecf20a93ea54..fd85a028a926 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -427,7 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 
 		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
 		if (nr) {
-			pr_notice("Memory allocations:\n");
+			pr_notice("Memory allocations (profiling is currently turned %s):\n",
+				mem_alloc_profiling_enabled() ? "on" : "off");
 			for (i = 0; i < nr; i++) {
 				struct codetag *ct = tags[i].ct;
 				struct alloc_tag *tag = ct_to_alloc_tag(ct);
-- 
2.47.3


