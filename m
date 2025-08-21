Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4376DCA0FE9
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5189A8E0027; Thu, 21 Aug 2025 16:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9C18E0034; Thu, 21 Aug 2025 16:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146B18E0027; Thu, 21 Aug 2025 16:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E48158E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA2A2140537
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:52 +0000 (UTC)
X-FDA: 83801850384.22.A66E1C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 680C8120014
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OILxWTwK;
	spf=pass (imf29.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9hzYOZv6YXUN4v1wicJ53nqMhopJDezqYU76J2buLg=;
	b=MKRluwVrqc4ImwitiRW93ZwgJfaC021C9pYDP70zODP/Z19ioloh+Cm2YFUNfv7ceinEeJ
	Ks9WZJgaMOrmfo8T0WGLMsRahKR62ncEdRODDJ51Jprr/8Nbv09b7FrWvl2KMj4B2jEfs7
	QgUsfwr8PRFZjxC8yBMU8tdICy+8xLM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OILxWTwK;
	spf=pass (imf29.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806870; a=rsa-sha256;
	cv=none;
	b=WIjvhT8eg8ALUSUglkRpDeJE0L1Ig6SaQlUH7j4s6xHQ1g9oTuylZp6M6lbIF/nDC3pQY9
	r1FPft//xiDGmk8hCYGoWNrewDyQAMXyoJaTQiXg4arkQ8SYGWUs2vbJoNA57DzOKz/Ga8
	8q7boYxHxDe0HL5Hfm0hMhKpagXUOLE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G9hzYOZv6YXUN4v1wicJ53nqMhopJDezqYU76J2buLg=;
	b=OILxWTwKgH1E+H18QJa0fCNxwi6OmZ27VLMtUgnIqq8Gm25wIpVkuA0f/FPG8KSDC9qL+S
	l/kdV1MlFx1hfHt8Fp3M5ZUi3sxrxZYOXxFVzO5YpXNO5xgSN8OQLBhsMQfa0JGQLgHT0A
	ejESaNNax7Z37rM8p7NXblNsO24pBfQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-0_aK4efkNEapA9c1oT_PRQ-1; Thu, 21 Aug 2025 16:07:31 -0400
X-MC-Unique: 0_aK4efkNEapA9c1oT_PRQ-1
X-Mimecast-MFC-AGG-ID: 0_aK4efkNEapA9c1oT_PRQ_1755806850
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0b6466so9581915e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806850; x=1756411650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G9hzYOZv6YXUN4v1wicJ53nqMhopJDezqYU76J2buLg=;
        b=HdIoygylyPzjW/5RIroEkAVfCoNPons3MZQybOkr2h6eicpPSBooSrqH52typ4HlGa
         JDFWmtG4syWBV4212JarsMk0XyGscrpUoHoHwGPg5AaxhN8fSo41PN5ZXdLp1CYJS4wZ
         gveV36PhbCq2eUhNqJtc/uYnoxTt8fW6CN3zn3TXrF6IiBF/HkKMPYNSbAG8h+AwBfTU
         anWpneEF8Tlw3DG2OyHDnHv0Y4OEdCKGKPzFaoSamshFK3PWats5he0p0YFP9rCMKdu0
         ocNXf64lvNpojThi8OSrGiFcA34nmhF6nTK7Wo+9B53hiDMFL4ed4voLf7nE0S7uwwsb
         xs+g==
X-Forwarded-Encrypted: i=1; AJvYcCVFOV4BKlKMPCuXssCeQVOsT81Sp83gJ4R2SJgPNFxtHyvHgGlpqBLr7m1Vz3gkfdl+ic6b2jPLOA==@kvack.org
X-Gm-Message-State: AOJu0Ywel2XsjrbJIqfjpzMu3xjEErpyqOaDBrtU8qibFRqUHaLXQMzb
	gRTmnaIYcGdkUYHZXmpN2iSRXOFI49YWFwc+ZFj3ac71Tb8b9DnvojjPaQH14XaklVESYTsUi3h
	aZdI2IGBNnIrsTy77HWGlKGMMShAuPWSNTHn/9CoultJwgvLkUcP8
X-Gm-Gg: ASbGncvV1XYiH0WnkCk2GV1Obzw29PCSZF5WQzs02wQLgTzkvNaDHRFwshoD3obk+dg
	yKGh1SAiTDYYcAydbE0rddVdafTGolSkGCHpQiaEIgxETqDPeak2veU9dfYfaiYi5zG+PjhCxWC
	8dTd5KnpwHSMWjlIBME/pJdlepAlLQufX4R6nsXE2YeKCwEaR2o2beWe51TgA1GRolwxI1BxeOJ
	rcsIaMyTqk38DQq2UoElZdnUgsFpyZ4kSotpMSEWvW4qoHSj1jbJAMFKKQ08vhiIhTzi8Po8DK5
	WPIDH9ixWf8UABS485CTbfmd7M9q7nIoyZLhqd9rL87zVsBTP18uGgMKKi7xDYEJsW0F1oNQLzl
	2EU2ZjCMTFiJwQSTnXI29Xw==
X-Received: by 2002:a05:600c:1548:b0:459:dfde:3329 with SMTP id 5b1f17b1804b1-45b517ddbe2mr2955935e9.31.1755806850031;
        Thu, 21 Aug 2025 13:07:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPNoTdvVqQJqQwQf/z0aFpcDb/7HunF1Y6KwbAqmFFF4D3cnAaKEmAnoGbjwE6N5eIepmoyw==
X-Received: by 2002:a05:600c:1548:b0:459:dfde:3329 with SMTP id 5b1f17b1804b1-45b517ddbe2mr2955545e9.31.1755806849496;
        Thu, 21 Aug 2025 13:07:29 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c3a8980ed5sm7242256f8f.16.2025.08.21.13.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:29 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 08/35] mm/hugetlb: check for unreasonable folio sizes when registering hstate
Date: Thu, 21 Aug 2025 22:06:34 +0200
Message-ID: <20250821200701.1329277-9-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wl_rm4Ed8EQjeitYcOsEnflq9VgNz7Bto9BUcfjMh4k_1755806850
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 583wyy1cuyh916x14sae9gnynqe58emp
X-Rspam-User: 
X-Rspamd-Queue-Id: 680C8120014
X-Rspamd-Server: rspam01
X-HE-Tag: 1755806870-719299
X-HE-Meta: U2FsdGVkX1983eHqxs4wHBjtQ60p047BWl/ZeXm0x6qkg8ccuSWe31JEywz3H1SfUzDbC2suHU/JbA+XhArKjAjxHJN9AoFvh6/I2c44s/Ab5wc8fDtTz7/lPj/nSpggf4K2iT9jxmOJBBZ9SWja22AsN9Gbm+W9yEEU0fylaZ+nwADnSTE3tZbHvltWIMmIRE+kkJT33R6XQTRcRLV4CQVzXqPIRYGV3Ox8BPktom3NjY1/ZZpwp4INpvWGuX8wRz6KR9CinCI44+4/2w+aYyw+FyJMumIhwv6a+nG+S739wHYbNkUakvOh5QJoUkgYL3yBorUteb9NUkvKiMznkJl2PLMQHeyz5tYN7Kxa8+ntIwlYEEUbs+OPExsCg6sl2CeQvf7EXvHbyc1XFxsJP2Ke4hx1hXmFhl2OwVvomDP0pG0Y9iXbLXPrdH9flmVcYn70bzL+WMKAD9PxYnwpLyPr8n3uO/bkw+/+/lt2mzuoWf9DBs3zIITUrvYkuk4CpJxZRuKs2izPSwiX3o3YhYJfOVZ6Pmhifk5IBz4wVpxNNDP9AWAu2VCcy58AvZPpXp8fv9wedk6OUZaBvGdptWNQKHjYh6pPz4eyQfrZzrcImvYJGBxGcWiIpafK6Q86rlCjvJMDOr4tusgZBG7DnoP9cnwT7BeKGO8jKOyiC/QQ9CkB8nEl/zxiX+GPhwEq0mlstx2+D4x/1D7X3guIpoSLQvcBZu7yG3i6OUsrWS+fJawYPX3PE2ZEiTDpLvBkc6nTtj1lRMWOIb9P/wuKW70aCecEnqtvyJE+dGvu+2WGCulz8LnfcvAmF6DfaduS9UkUq6KS5DrLSfnN0eGw8GoOV2ucbxImJHG7uvmUdx2eqCPXyjU8VMeKjfgX7srUHYMDpYXzekws61J4zKDxiRn6mzTVk5zYKj4INZNYqL6H71riEKgka2XDD0DhIRQNAeQdIvL3l7EChlUO2WW
 iaWMcWa/
 08tkwORw3dfYhJ/JPoc1uzNqfK/Er4dXH1IHGbK6P1f9PqsxbX6Q/l6288ieYyYUdXEUWqZlqxlwaZu0IrhSSyWd2XfWtgu0ZfJY3fvg8IGUGcRZD1eM8Jc8+GwSPAT13pTmlIrQP2nX3jOhwhcByC49D/7880w45OZDUOYGKJduO8ArHKs7uI4YYAV/7u6b7S8WharOg5ci27z6aK90iESlz9KuHh2NpIFxUNhWeKxdmDgAdd8y+JEzl2/c+yEYEpXz2h0nZaoO8MsJZtzaUMaZ5vkFZsN6sEXbISsESU2xHUNVnUfhKKbgbVagRF2Bzhb3mcgcJiYJ6bD+TJo3ll0eoJ6JzqdMHJcSp9W/9DWugds+CIMhiUKHCpKGz/xsXO6MVvoo5Rwee7C9Gb3ZOsitvDAAGLmkyN7nuDHe54rZvvnhXikyyeENBxLN+YmC1AkLkRwMRYiRvDY1hWS0R6acff6TD63xCjEsTojla3ozhKKwEjpVbqIJYoGodmnnq9XHF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's check that no hstate that corresponds to an unreasonable folio size
is registered by an architecture. If we were to succeed registering, we
could later try allocating an unsupported gigantic folio size.

Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
to use a BUILD_BUG_ON_INVALID() to make it compile.

No existing kernel configuration should be able to trigger this check:
either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
gigantic folios will not exceed a memory section (the case on sparse).

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 514fab5a20ef8..d12a9d5146af4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
 
 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
 			__NR_HPAGEFLAGS);
+	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
@@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
+	WARN_ON(order > MAX_FOLIO_ORDER);
 	h = &hstates[hugetlb_max_hstate++];
 	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
-- 
2.50.1


