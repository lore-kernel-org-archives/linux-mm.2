Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D76E2CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7DD8E0009; Mon,  8 Sep 2025 18:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178B28E0001; Mon,  8 Sep 2025 18:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067338E0009; Mon,  8 Sep 2025 18:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E44258E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:12:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88AF713A511
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:12:41 +0000 (UTC)
X-FDA: 83867483322.19.3613DF5
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 084E01C0013
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:12:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0XFX+w9k;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757369560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gNtbdDCHgk+DiPqbiXpsjFsPHOrdOzQKbMxRyjp9MVM=;
	b=A99rsvH94dyjLXt3VJuV5Ay5LxW5wGbi/2HqkJM0baNrp5Y+8jDPY7PiwI/WqS4cZLxRwu
	ddO19r9nfoyf/q6/F//szJE2BsRkYBfLDiCUcxEwMMxRcHrr9/m7F6Y2nLMKfWUnRlKfBY
	bUIcoI1Tuo5dWdg2r6wOoq7S1mzwn4M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0XFX+w9k;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757369560; a=rsa-sha256;
	cv=none;
	b=uHkVM1ZB93tu2+XoSyuWz8vjQm6hx9jJ5aj78AF9gIGndCpCd7Lki4o5aSxAwxoSQBS5wu
	KTfrbi3TDLBNRoEUMArkP4NGNmReuVk9PSeEPtXZIifOc1cY9S/PB9+zVu5lefr2g/i5uY
	v1dKV2JvWQsF4BgZbIHcj04D+OPoLCM=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71d60528734so39080407b3.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757369559; x=1757974359; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gNtbdDCHgk+DiPqbiXpsjFsPHOrdOzQKbMxRyjp9MVM=;
        b=0XFX+w9kOrLxO/aoGy2m3rILRjUkcFoqYjSujENlZdY156kgUz+QWY4sSMeoaEVChq
         jcz8cloiwl/r3RMGUObVkDATgbtdTqPrXvv6jSR3Un2TipwGPT7FcbLYcLP0pybb602X
         989bl4+JObU8vl3G+A8uKb2lprfWP5kiOMKEntgryWC4UEENoExdNIm+7WnWrzAXf/9U
         mN48cgAVTzELzeBsrOsZ4B9MyJvnhLnkK1XIt8DAUS/SqAblaDR4F11wE7MM+Kvh8qwp
         4sP0c461ALhQS2lAd3zo5eaGI3TR2tkKVeDXHMMPGHtURjrKaFI9vHBRUn9FzdXBP5uh
         2ARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757369559; x=1757974359;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNtbdDCHgk+DiPqbiXpsjFsPHOrdOzQKbMxRyjp9MVM=;
        b=Eyqqikzqi1cCYIwsa3Ab1vftF3DJUPVzQ6GOUzCIiTZkfmiaAJPhj9Bs5h/ecM4jA6
         AqlNcjB8y8lJvUvEhRE4CQwNVkSuiHAjHiOBUAuxCkiYFd7rhicfS7p4KIeJMY5pU4we
         xZ02ChI2dix3gr9uwBR2h/1nHR+j3NKqCCxzKvqffb6RdY6bTLwWUo/RA9EhGRhe6ZvY
         8Doa9YXjXUG/7e+32z8vcKGpWnUkefChKKQiyHd1Z2zwVlPVu1kpSiGuN45yYAXo0MBr
         mT67XYC+if8WpdJujo/AhOTAnHPp8Y3M+UYO21VanotcG0G/A6L7as0rNpZhlp2C9gnu
         L8Aw==
X-Forwarded-Encrypted: i=1; AJvYcCW3tTj9uPzW9XQQ4Zc4oR0vwY7ozqnpiZaiZ6ynIOLEuIABsPixsaUXzPXq3YGrw3Dvwc3n0OGxFg==@kvack.org
X-Gm-Message-State: AOJu0Ywwc0dRqPzK/I2N0Str2atMAz3KKAtpHwQrzEtgmLQTOeYjhFhL
	W3FUxLYOU4+TUlGV3DbKjwacf56nsSWkfhZ56Qz1ORVexa07ScgYskDjwkkasB46sg==
X-Gm-Gg: ASbGncs4hq5wcF47j1zeOas2LjXF0q4YhJ4XoTOWAwft2CBdJvIdcybrJUCFyfKLBPd
	yFcPJOU9KBpwGnbEazE7UK7vtB8HnBlpHXqb5Vdiq6b0UOZOCBXyLtBCj9cqoWof20T95Dw4BOZ
	xu3FNdvq52FNhcdfZuAZKczZS4L7q9SRJI1R0bbbwVyq9pzf4JDjYbFxlKArVxmzKkXBGpJ8yin
	BLbzBGAIzD1/sA5tXMEr4gY9rQgFU52Yu63vBtNHm8zVXWaIv2AIHjiUtX2pOTktcQwXhwJL8Ty
	tQpzx/UNuoX+FP2ImKc6iVQPJ1Wv0NzMhidoGBcI0DqcYB8Yo6ajiLtq/L8yEGjouwyt/LQ2qO7
	mf45RCeaNvSd8IjaEUZImfQfn72ZNwj1ratfDXCoQK4XM9orF3z5GH9iN/TjyPq1doQAsICv7mY
	WKYd792rQ=
X-Google-Smtp-Source: AGHT+IEcR9qj/dDVqywaUNohOEcHuvPXDWkQP4kYVA1b3P4MwbJPWFYGGqkq8v1AvH1FCx7J7AOhzw==
X-Received: by 2002:a05:690c:6087:b0:721:6b2e:a07a with SMTP id 00721157ae682-727f5f3e326mr79337167b3.51.1757369558683;
        Mon, 08 Sep 2025 15:12:38 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a85a0cd9sm56756867b3.69.2025.09.08.15.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:12:37 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:12:20 -0700 (PDT)
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
Subject: [PATCH v2 0/6] mm: better GUP pin lru_add_drain_all()
Message-ID: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 084E01C0013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sso8gkcwge5po4hrczu6ck6haistoish
X-HE-Tag: 1757369559-36027
X-HE-Meta: U2FsdGVkX19cDT6ikkAGFGYqc7Dev3sNCvQwd2fj5IF9kulmfH6iTzuNsp29Vxgu1ETBZ6yGiN9E5G92QkM7tK4XUx9aSdLIzTS4fuB/oJSgnC6kSm0JJogPrpwx0YCrH6avKfEqvHx4ENDFS397psH65T8Q+qsu/Bm+HewwjRZhknb2SeIYHnv9GgZydo/FJwgMgcaTGlScwgNdGbCLIV+sBQOl406iGIbA3/vpb5obqGeANHH9KECwmBIIPHVMc45vA/gZITcAPAeNmVLsFSOCaDhKkeNCbbTqlNZGJoskdt+uCWILGuiIRXnoP4x41klsvZ+iJODaLBHoQEMEJPWiPWl8p/360DkITc5XqhKvMM7dQH9B02T+MMsXX9Zd7uW04wZSeIpBMLVeweDbX9AT5LFcvOqQmJ6DidEi9f8KVKXtyFDGfUp3bal7Lq156Kv9zz82eaZNc9sfdkdZz7jJHXQ04faHHaWN4be6O0WHr6V1EsMzpgOYftKmIHK3Fe9Ca0LQiINxmyX3KtFYPS6wuBKRRPK+EwD0EX2+NpT78ex4idHBEA/kBPi291ens7gOk2e8UJbZKcZi9T0oeN8O57OA9Y8DgQDN6ROLp+ZjGWoQlmuQ729u2/jONxU5jl+kauBnjqdUz3kP1S/b2oa9veHibHJ7otJ6vk6Ui06hLSN6cbm4cTtDPymDCBm3fBKW2BNsQHOaVd+mLLOglUj9w++Sqvyy2/vY+W+zry+ksh2CqmmuxEQO7ZOJOAFf92LdaQqtV3d2qNZIUqn0cxsx/+gzV9M6ormkt9wmvvNyfEdvjnWvfDtP/afxb2osm+d+XP2f7p5HT8wJnSptovNrKQQjZk2A+wZ4YrKAsrW11lWtp+MGKW+iv74s49SFlDEoRWv2BhtazKH86URtHZx610L9O+3TRZIdwsCTOLjv7Z5yLW++v+XIHKzXmAYopfPU9exZKqAycbfBAjs
 hmTuj6jz
 ImOW/j9NHrd2qPJQebNS0+VwHIpq26qNSzFh6TeGNpdu9hZk3rpIztg0VLZ++AiGS3p91
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Series of lru_add_drain_all()-related patches, arising from recent
mm/gup migration report from Will Deacon.  Based on 6.17-rc3 but apply
to replace v1 in mm.git.  I suggest all but 6/6 be hotfixes going to
6.17 and stable.

v1 was at
https://lore.kernel.org/linux-mm/a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com/
amd its
1/7 mm: fix folio_expected_ref_count() when PG_private_2
has been dropped from v2, per Matthew Wilcox.

1/6 mm/gup: check ref_count instead of lru before migration
    v1->v2: paragraph on PG_private_2 added to commit message
2/6 mm/gup: local lru_add_drain() to avoid lru_add_drain_all()
    v1->v2: lru_add_drain() only when needed, per David
3/6 mm: Revert "mm/gup: clear the LRU flag of a page before
    v1->v2: Acked-by David added
4/6 mm: Revert "mm: vmscan.c: fix OOM on swap stress test"
    v1->v2: Acked-by David added
5/6 mm: folio_may_be_lru_cached() unless folio_test_large()
    v1->v2: folio_may_be_lru_cached(): lru_ per David
6/6 mm: lru_add_drain_all() do local lru_add_drain() first
    v1->v2: Acked-by David added

 include/linux/swap.h |   10 ++++++++
 mm/gup.c             |   14 ++++++++---
 mm/mlock.c           |    6 ++--
 mm/swap.c            |   53 +++++++++++++++++++++++--------------------
 mm/vmscan.c          |    2 -
 5 files changed, 54 insertions(+), 31 deletions(-)

Thanks,
Hugh

