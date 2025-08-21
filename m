Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E5ECA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91CF8E003D; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C445E8E0041; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2908E003D; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8250A8E0041
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D7AB1DA034
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:29 +0000 (UTC)
X-FDA: 83801851938.29.D212E77
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2C8C40002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
	b=waajRnSWjl/ABxn4y1Kvk9O5HP2R3g6nJcmnR5EmGf7u0ePA98HTSVUm7T2b4zhhZa9E5y
	AFGtM3mLxBh6xSdM57T6bsmOukZoX7mNI4wva8FC8RefzZVBHBDsxsfA+FH66gI1mDKfpC
	Agdos9UCM4AfEfx6hQ7CxObhO3wYQM4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755806906; a=rsa-sha256;
	cv=pass;
	b=bM6vrE+6/Szzz7DT9ypEvrOC4L0oRsJEl1XcnYtCOTz1dFG0paOzSjgmogqnRV1SSXBt50
	PvnvGJPnoe1u9T0dHsvUSYs952/2DFppSfcxGzIJTs+d2atAS/qJKSLnSxAlP8DbivvmHj
	zquyI755AnPeI3hyChXtXt/fbB5HYTk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 317681DB8D1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:26 +0000 (UTC)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D2A3C0570
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:26 +0000 (UTC)
X-FDA: 83801851812.20.B0A76DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9EFB2180006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:23 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
	b=y7TzP8YAqeL9HsTHfDIhGfz2b+fBscC2xM9yBmHOHyDdUGEKSDQPCXJV7yRhXaDL+qiWtv
	2EZ+sL2C6hljysVK5JCv7zA/sh9wldmlFG7u+wMTD7FmgjUBbozaH3M3/H1N5PZseZllxo
	agU5sruEn/vuesgwmJga69BzRfD9Xd4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M5eIkUTN;
	spf=pass (imf16.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806903; a=rsa-sha256;
	cv=none;
	b=4QXB9VAmvbTNFpe8yIb4hxaqbtSKX+VUugEirCgm4JKF8FBYcc607IUSQhs9PMX62ltoXQ
	zsKDP1kvYmNIJflpAiOrW5Q42GYZZfdDlSQFulun+RhBzNr/aeQKqGq3ksVEgJH76ysLzr
	3wlKasXJ87rx52EdF3m/GavA/92pWlQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
	b=M5eIkUTNOfZAbO1HhqbvK8RSCTkC+xAMYuzo1rzYrLAiykPHIn9lv2D7YmsNWuK+auNtW9
	7N/xoysrIBK1RHpxBqWGbrNnt4lj4AfcHUWHUIgQIyZ9wk2VIpl9iXubDpi//Zhf/jHKKX
	2SBbugQ5LFxqtQ24PpWJWqhhPJ9qqn4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-yxlgtk_yOZed5sED4hJuag-1; Thu, 21 Aug 2025 16:08:21 -0400
X-MC-Unique: yxlgtk_yOZed5sED4hJuag-1
X-Mimecast-MFC-AGG-ID: yxlgtk_yOZed5sED4hJuag_1755806900
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0b2b5cso10141355e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806900; x=1756411700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5m4ogAvLOK+AKMqlHwhkjmyVbS/4gGgmBykcdwEFmjg=;
        b=KHrefs/DxId3ReAlbTFqzbnHs8Apm93aG9db56BUv1qCe428v1LlepSdeybIFWCmyg
         AO6cqIU4knKJafetaywoWRfEndBnR66+rTT1NHXNSF3Bj3geU3Y+c/88FqRfpNKfugNs
         FMQZ7xyeuBVoTHiNc6Clp9J84X3SO3EiDUQEaj1FOdUjKzmzr09I5F5cQwmgPHdb3chc
         uXmMQ2VNTY+uLyQR7kD1ZNkhmDROzJa9AsXFhcL+7aHHQZBuGCBgMEbMY5rCa/K5eVf5
         mYZD4vcJsbUeHHezIoNNZ11n+soNgxLKUxXuOPGbbnLLUfEaPLUdv/+s9SuFCiecC6lQ
         FYIg==
X-Forwarded-Encrypted: i=1; AJvYcCWxzqv/XXrMDTrKsVacJKiwXBQOinmI3Pq4FUuWpKL8t+x77Wi7aLyeFCbWh1vB+u80gcb6q46Z+A==@kvack.org
X-Gm-Message-State: AOJu0YypyWTfgOfW9AFt7mfHV2o5qzGD6aFfgTWqMXchtaUFL6VU8h36
	RASBAfSac5vTAnntF/vZnsyX3yMuwey2RRBWTR5knQFQfLlOpCzaG7XPJyIBGWZkuIAQTgVTkYi
	f0UVbdu6YOfvUA/TN+uAVe4xqUlECiWqILexdL5MzENdC0vs6LJYQ
X-Gm-Gg: ASbGnctc6eLVvmQ5c09qEEQGq9nPMFaehohDgtKTMi52GbhLgBhXTsMgIe82670X3Zx
	Ikh6T1mQgOQDC+AYUwvvCOFaDFoBPrOlTdKzyLFqG7gLpJo1Ij3jVrxSlr/b9efn40BlgK7LO21
	A4yAKlQomaRts9Yxg9fnxquSFu6ROhuh3DiNSjTUd1uEGNxFFO+GOBI76FyWTfvTV+Q8Ok7fSxR
	FSLX1tHdkrVWl0QtnY1k3SRMg3dpL8sdgU9O6P4mq7ZlJ8iwGlaYn+TviIxWHQyzXwybm8t/4WI
	fBv5gj/DFovIwgNvWqIScA7SrycwxTVdyXSo+ybMNZ2MBaGN+oGWB72lOMamJl7iBLCK8mnWexb
	/e11lPLV7EN+ZcOI8ZiS+iA==
X-Received: by 2002:a05:600d:15a:10b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b51f2fe8dmr510475e9.2.1755806900316;
        Thu, 21 Aug 2025 13:08:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpV2b3uhR/IYbmrTMgtg0gx1wkF4+JdBDenNBBSMhYf9nynPUCNMa8PTADPxo4/liFiw6TqA==
X-Received: by 2002:a05:600d:15a:10b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b51f2fe8dmr509915e9.2.1755806899756;
        Thu, 21 Aug 2025 13:08:19 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07487986fsm13999227f8f.1.2025.08.21.13.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:19 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
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
Subject: [PATCH RFC 26/35] mspro_block: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:52 +0200
Message-ID: <20250821200701.1329277-27-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7_sE1aMkIclVy6TntFypThGdJm4ZENqug554QO2aGj8_1755806900
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-HE-Meta: U2FsdGVkX1/HYjtfy7hKxjsDHxuZr0LwohjgigBsj1m5R6YvuqNbA4sbh7FTccrcRcRVq/htY5zI3zBeParApz2uzYXWAs+ngKHLZLR2HPJulrIuMkD2C+0+0xliM7Jlf7EIHPp/tHKJFA6KCo/FXGkxWdjRFfZ6T7Ziz5naRIhPIMjLnoKCPXy1lsajLSXqjJvOvfvUkk5VtNXjJMXk5Dlt6q7NIeyztC8TMuzdS9G1JMQFi+2cf5qLeyYcpqMxDWWTUXG7LzGN89dc9JT4HRTixA6DbEnnmioEhu3u8wL1lZx8wZbiRAHaOM0UtNmEymXJTgCAdq4BKSfEP3Istcvxc9t+2qm+0UMV9dFHhiJxbAAsOorWIa1VYDbReAJtuzXagJTKwy1TzTPNl1uUvBPTA/2qbck89gqs0sjOrOmJMgsrt7dyF1Op9Auai6KzTDGDW8uXuliP2w03YPjLw7Cv8gu2DxCU9pXRd4BnVJtx5WQycUcB2ABvJOauEv24RHfcYlVufit9KmldlzAqYliAaTj2djO24Mi8UEjQ23jP0iRYvNAaRp5s6PR2CpPHK9drh0LxhM7oIHE7M8q3Yx0O44W92ojD8JDNS6UiUOdxIaAKNv0RCXsiPACGIVo/nXILwbdmCCiY/p6IKgXt5MMB3iq05tbsP8gx0Szpn5+CcIa3HGrKJuCNDbfKhlVZAnRhORULOD+8b8a3BMolnd6ofivWunD/Wdu1GAo/GSSuOZSfLYNGU1Cbfa6lCWWIZk19F9pdJfa+MF4pWiE8+e3C9+NQPI2T2UpKdfWPBg2/Ku3Q56piJrQbQ6QmEArg86ikq3Nlmhx0CRuWyqbfQGcSNOXuPocw9uEIjwn+X0Rb750K5r+ppaSsBW3beJ0Mjlxq/WDgPPtPKlB8Bruao8z4wG+Hd17f6KHdkDQ1GhvGgIuARvaMGna1d0VsMNDyYC1CHugcYUs9IUu39wD
 8RUqWyll
 fdokYrb52XChJmyAmhgfC8GzoMZpBJx8SKuCp8aO77K/oleNtEcpwLmY/foQwVnKib/qDniMKeqV3C8Y28+qBxFuqrk7fokVWiL5cdRKiuolw7Axpy4liMcu4DYWGSBEbNAcaa7f7ECI0y7hXkVjZI+PZEJ61vmzy7gtcaX2O6/EbK72MpI2vJvy8q33HU1O/Q2T2pUAMZh+cK68T8yC/iHivp7eYeqmoNhVuT81n6FtN2Mz5r3ht35jLPHJ9aUMAt1C48dxpOri4uodl2khiqYZd/UkBPMJah1PFHYGAzECEr93bMTmSJjYoqgEyjkuw5NDhazIR7GmZaB1675xpm6fNbw7qtj+0X6t1G0VTe4rDarRg6iQwBThxGi8EkuQWLPrue0MEkma02Xqrv4RG4LauyC6FP1f8CAa/GwkD4LGXFKUayiugDNRJb7X8s0n1awMskM2UGdzASql33DkzTOri/OsPGA0Hh0bXiYVRyEm7qmWC0jDGQ9+1OprOGLylyGhc9fTdcfjy7bN9A1mZGZeoD5b+pBY2AB+M8PoYpD6+LhJL9zlaE4e3JV/wkfThHR0hIuMJ4KoAtsCFc86aGouQa/eSnuhP7AdNRbv6z2UlOjBTBZ8yoY0fmCaGgVmUPss9dQqi/6jcgDyvfqimDajA8cpRUuhIw9ML
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2C8C40002
X-Stat-Signature: 3ygujwgtd81agbehpsu6ju1oii1z1uhq
X-HE-Tag-Orig: 1755806903-93565
X-HE-Tag: 1755806906-14560
X-HE-Meta: U2FsdGVkX1/xuuAHK21QiYj+uYgOR3ZEARgp7g+VPuhw1nBlpd/V+PqgAIsZ32jp9dRT8rNT2D4UnCsIqegsa3VgoaePb45ApCwV764uveNDJTTchDyNyXAUrdO4s7lSuJM6aLz+M76bAAu9slfOiyS8arTujHuACADCh+kt1d6koeey/j1Oy0hZBq46ZwRRntDtjdWPrTpv4f0ib1QlbNovdY1JbQxJ1rq40Td6RcWQWb9oynvJZLLB0cfClUa4cSElMonFVrSNJfblfcC7W9Mb5J4FDwhJCSoIfpw23SkB2wyKOgET6JJnV+KOaSk+aMDc1fXetb2MFBydf5BUfzpoaSldvYPQhZZZtw9TZeltPodVZ+/wXEc0EFAb0CHnTHcsGgeLUmKNfbrNqDjH+tfrvpxSpKThfnbYuUMQk6XdVffObyz/rDf47uEy3Mfd58rBt1MI789Fa/O7C7rhbVrB2RsgmzvDXl4El2q6x78bda3ozeFW2h4KmWBz0rxiM9oz+RSAY5jMGrg7W1tYxH/5xpS+M8bCTyJedecg7vTNDvkEvfmK2Jkasf3x8mM4BpdBgdn3JfwMH8EJatNjTsCo1huhtPyBNv9zxUzO7C2+ST7NnhBhTv0Pb/K1qNZsUshRM3mqSDUxq7pc/ptN0OGvQ+2ZV2e64TQqhHK3WCGLItUOt1gSu36geNKSsIBJ4njebFWJRwzay6s4A6WaoKAMNNrdgd0TEdN4AzNlYDccTImda8PNYseEKWmoYun/mtCKFPaBMQ8TmRWgr2ZUA+L8p4HDvWSPnqJ0n6eHYQRp7/egmvlhHMoZvzUCB9TuLpKzO0NeZjFTRoh2NwBGp1vtydM1DBq4qmY++qw9huE03Y9yV1U6MTdT3RtKe3wWhIBZ2M0uuwuRgsKxOeJFlqCnK7nw3etU3Wx6nqjQ9PqgvsSC7qCSNIlaG2tI/x3Iy77yghmj3Aoznyb9J8Q
 aqhitBcg
 OeXmWTFzK1pk9CVmZd3UwA6kFmNfCmu9LRptnryOQ60431psGbXzfMCrbu3Q1GcQZFkgrM56cZ7za4vHfxTXbpe4mLp8N0TUBp8w6AM0d4S5kWuapRPtC/0owR+6YkhiQNyAGmCq0ETdnxfg7hKDyu6rUtHw62hp/M5yWpRNbo8sc7yj9DM979JP+JOE4Ljf/QzH3LXD4n/pWJLoP0NZL0x3y9+BYNyhe8ARcHcPnzEOsXsf2DTRoaVh62IvylVkHfYTFo5Nxykl570Z44k0RKV4sP0JcThUFfw8KLleXXCn7o/VavbXUooUdkau8din6GWmaRA8t4BrC/uwHiHHJAuFrx+jsHM4PaBk8Zc8gbu/XIoP6ahQsoxdHKFt6tr6YdoJ/GbeTqKUi3zUYS/hElA0e725UONoTwMPegwvupEjUYn4ySq8UGnpNR1/Tu1Ks3lXMt+02U8D6lssU1S3AHkFn8EaVyC27puG/x1G0qA3VSXp6frs1ZtYhrxm52zqcb3MqG+2FJozou4LQ5QS4YwUCOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/memstick/core/mspro_block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c9853d887d282..985cfca3f6944 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -560,8 +560,7 @@ static int h_mspro_block_transfer_data(struct memstick_dev *card,
 		t_offset += msb->current_page * msb->page_size;
 
 		sg_set_page(&t_sg,
-			    nth_page(sg_page(&(msb->req_sg[msb->current_seg])),
-				     t_offset >> PAGE_SHIFT),
+			    sg_page(&(msb->req_sg[msb->current_seg])) + t_offset / PAGE_SIZE,
 			    msb->page_size, offset_in_page(t_offset));
 
 		memstick_init_req_sg(*mrq, msb->data_dir == READ
-- 
2.50.1



