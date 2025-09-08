Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD581CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A776B0008; Mon,  8 Sep 2025 18:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342A36B000C; Mon,  8 Sep 2025 18:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258446B000D; Mon,  8 Sep 2025 18:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1367F6B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:25:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95D001A0347
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:25:01 +0000 (UTC)
X-FDA: 83867514402.05.5A54CD1
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id C1C0220009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:24:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="mWfBe9/6";
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757370299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rv8hMh0LMqevWYFZ+srlns+vtAjMl4A4z3f9Z1Buf8k=;
	b=Ua/mYkfIBsRRgOoqSRwH2jGEYo+tMaghB2jyr3Chys/jxS36dl0YuWsKxBp0IAr5L6J0aX
	Owv64/Ia4kT0BO+yXcHtHX2E+cTdRPQSj35CQfKJ/ayx4eFg7fqtnXDYxc4mE5y4MaOYxZ
	aEGqaJ5n3MYGeAV5GooXNSR/E7kE8SI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757370299; a=rsa-sha256;
	cv=none;
	b=Ze/MsYl4kJbHvWBD9XNWH89R12BoWLAA9TS7Hq4TsFINoUaRqG/dGR0lwBaWyn71JHb2s1
	6Fo6aPXZ0TdgX1Z8Yszry0ZlmP+xOB8vonkUfeywiWn2Xqku183lf/fjLENemcfkuYXa2n
	Poni4A1mcIolDgNufstbqZ7zux6T2QA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="mWfBe9/6";
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.219.169 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e96e987fc92so4071764276.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757370299; x=1757975099; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rv8hMh0LMqevWYFZ+srlns+vtAjMl4A4z3f9Z1Buf8k=;
        b=mWfBe9/6Oiv0PlAfgRasLsx8YHFISbgB3/IG9eGqlHGTXV7jo5XBV5fOLDzyfNOQFb
         RAtWpmzOx98awM2LElHG/FREXGArXXcoulA/Jg5LM5YWTj/L7zi1mJtQUkfhy+7zetrL
         qsdQjUKlwDuR3j6PpTvgu5M1NJssBh2m55i4GL5MymAbUWDSjt3ypmzjOk6oYpxi8m/0
         zkNC0e3gq1Q6tB9fVx9LRFHaKHEkOy9xpWsWP0JlC1UGU+EZo8hJCasKvfurBQJ3HrHD
         hFP92wDUwJSsWXvP9gF2yRo+HKp1F4LmemEaH0FM23qOSO22aNrAaqk9iY1J/ksg0qjj
         60Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757370299; x=1757975099;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rv8hMh0LMqevWYFZ+srlns+vtAjMl4A4z3f9Z1Buf8k=;
        b=xD30NjNLSWIyAdWDXY294VFM44dgxA3DN3Y1m/ep2zKmupNvKxKi/XvysqX5vHMaIo
         HB52Bnrc+Q/2XJWezd4YhReq355htq4gV2/00YZ2Z8GZWQ9HlLeSeApie/G2D5RipAHN
         miwB3fxgW5QsOOksgk0VSryxm51qrQ/dsoDOCXLVVoRMvz9hLF5p/BtqP2nS29Vt+5tr
         eVfwjKN+eyz003tVIOXLMp0a/dXmNtjd6xZ0mk3F2ZaE2KVqPgWzJTXbGYwPWNZqE+w9
         rze8I+jOd5oNeXuqTFpDcRtXnJnr58P5mrKK55KJ5eonhAX7PPQ1WiQGMNcYpeRThf+V
         D0Yg==
X-Forwarded-Encrypted: i=1; AJvYcCULbeKHVqmePXMzTlWpGai8Kml8Hzy6+lM9ZMhtuNYg7cVB3Ek8SZzxsoQpP64znd6PBis1To78JA==@kvack.org
X-Gm-Message-State: AOJu0YwLJmDbnhem7SVpjX9rz7etuvM7pXMxwmz8rYz8VMjw8U4aabja
	PfxFc0NcWBUuzm19pjPopIdwd49FodzV+GYgBQhBXjZ9C4Zsz35dy65jD8SvnGQajQ==
X-Gm-Gg: ASbGncvYVW3txPD41J/jSenJ+lZ8UlpzzQr3U+wobrCdD3DvyHfbJPeJe7xIYOzsGDx
	ZWqUZT0LblTos70fCm2qv+3Grj6/8mTqBUmszvaI3vOhlcR+3lu/F/FvKEpN6Dym0YZREH3i0DH
	9B+VPKCV8MunTfhrNqcWsNaJx3hVqUlEW+GcZ1+/uHbVsWJehQDU/X+iakz1hDmvx+ttW5r4OII
	D0cqq6H64D/XuDLoDY9g+xHEWA0LgR5bg+y0a54VSs8dS3Efzv0v02BneJBm/NDyHrQESo0lRfH
	2swt/oAe47O1Ly5U4kdU98G8QAgMwpLd1WYuF6TFI9RCF516fIPce7E9bYZ3KwjVrPA4ouIZswa
	MXnKP/6BM82CechoeFtDwMu7Eh3FYYfVqh22FlAUOk2HxiuhGwYQtApz8+6lMbhRtBWaDD2/A2c
	2CpzJvncuPS5cS+tWxS4psO/Tz
X-Google-Smtp-Source: AGHT+IHz12RLu2qSx6kJKbJC54vlA6AVMAsAUr7Wd4XmRnv8FjgUsgD4d7k9E9m4cnAD0yWlnXIlxA==
X-Received: by 2002:a05:6902:27c8:b0:e95:1dc3:8838 with SMTP id 3f1490d57ef6-e9f66fca8a0mr9322667276.21.1757370298464;
        Mon, 08 Sep 2025 15:24:58 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea14b2e7ac4sm1647569276.35.2025.09.08.15.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:24:57 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:24:54 -0700 (PDT)
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
Subject: [PATCH v2 6/6] mm: lru_add_drain_all() do local lru_add_drain()
 first
In-Reply-To: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
Message-ID: <33389bf8-f79d-d4dd-b7a4-680c4aa21b23@google.com>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: ew8hf9w6ws64y8p1fd9dyrmw8yrc9r8y
X-Rspamd-Queue-Id: C1C0220009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757370299-244345
X-HE-Meta: U2FsdGVkX1+7kg6yRdvaOoTCe9E56yo6zsUowub/SUH2+2mxJImJY7SLk/hLcLZh49Yn2HIo3MnzISfM4mSQiouZoohu00lThQr/JV4rm2b5O+spQxM9xlJ3msevIsIrmlcy2BQ2kTUNJzLPGbpJngy5RD9hLXWZ7n/747pR0TNR1esOGXSIfmWFWOmOygF0BEEmCA3j1J/CPnJZgxVw17drVquQ5KYW8mSvSExwyjxYOq/N913zt7qGe3HXTYLoXWztQcRU/FQAPwnC4U9CbJljFNi04XY3awxNyniSn24wXV6Yf2m1JoIBUlqdm+LENZFQPQ3Rog3q6pQjq2GYA4ANN+Wvyz1iYY58xMAwWtlBMuxI+xthLXkbOPnrtydhkRP9RsFLPCt1diq2Hqgu5+2zdWQPC83lw6WkdfhlkqE6kagBHwau+BtgDJuLNtDPGyvHA4qVUPOC4j/kcFqCEHZpz+PbkIjnSZCrTKvq8spmQl6Ht49TSmjZykia/hY800Ts5fJhKsRnySgjh7Ux+xnDq145dvPnqki+UcWv6czQA6vfnuB6k9IxC/TYoO4/8C1tfmBeCBPQVqdQ9tZgLLvwCPZW/+8Tb/dj+8UZEzbandCXHX37h2IKPfBiB4mvheVcMs7OK7GFe4CXkU8VKVHkvQgW/5fV/E3q+Rg8yX8PZzb+86nJ6nxWayTF/31uP7ksSvNlgYvvl9rvvEJHE/8qIIU2zU8mWAPza0U18qGIkbYUVShty+THyTIkZjMAPySOBqsJApeQlMk6cS088oJBkvoty5Xj8w7h4m2EakCmsjE7xsyOP5d4iS2UX8/ymdC1RPzo23JoSExODtfN/pHE7XZF+Nj52FjextVAo6vG6jrIcfUtAkgyP+lkJHhYghj/ovfRU7uyuTE5J5fn2flgPBOm4b4mQC8SuBb9GVcfAbcMc2D7Zt5+Z7QswPs6CCkm8M2sSBDBQWZBTsL
 I9NOoQQ9
 DR0oqfCkLfywtka3wnTkDcAcjBKwx79/1lHLPl2xAwuJc429G6bvfDP+O6IugYoFmv1BdG6eiT1tf749rVXd7+Rr/KeK/XTVnxXcnDxDOr0+of3fcRpGnB3x8IPXbMaYSGNG2ibhzw2gFRuj2nynefG7Q4+Fj06D4bGxQx+RhcIFuOiKQtC4DzNl05CJxzSgxOyfa3g7EU5k6EY9h+lA8zAoPjPEG2wFI9ay34wmYvJTRCizANSSGy2BQscMYS3O0K/2RPH+Q4ySlvpSRfz5UwnEEGYUNuI5D3OTZ5aRnXZLYsnGdVAwVxzqh8r1845XkfLFsqAeZrzcCnvmVP6q24l2C+dINdZGBZHpg9zURB/RbS0m5rEUh86xu6UaMOsap/hAV2idtl0nJIBo8qCQ+7l3UFQ8HaxHj6A1N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No numbers to back this up, but it seemed obvious to me, that if there
are competing lru_add_drain_all()ers, the work will be minimized if each
flushes its own local queues before locking and doing cross-CPU drains.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/swap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swap.c b/mm/swap.c
index b74ebe865dd9..881e53b2877e 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -834,6 +834,9 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	 */
 	this_gen = smp_load_acquire(&lru_drain_gen);
 
+	/* It helps everyone if we do our own local drain immediately. */
+	lru_add_drain();
+
 	mutex_lock(&lock);
 
 	/*
-- 
2.51.0


