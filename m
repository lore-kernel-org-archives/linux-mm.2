Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF8CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDB716B0024; Thu, 28 Aug 2025 03:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BC86B0026; Thu, 28 Aug 2025 03:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53DC6B002B; Thu, 28 Aug 2025 03:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEABF6B0024
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:38:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7687813A421
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:38:00 +0000 (UTC)
X-FDA: 83825362320.03.CF2A34C
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 691BB40003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:37:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Iuezaub/";
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366678;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVrt2ctwbXgHbo+Hn2TZ0gCxiv/sLljbJFjbqAY/TQU=;
	b=e0hx5n6IXRDpoH3WSz+2v8OfNMozWpovvss+UTh3haRVKtyrGO7UTIBogRJuyblXT7gPq/
	JhNAzIpl00zSq0IwUoDx5wC4/6Oh8s7Ubwfj4NNFctHZ2/rMaxRS6mAFV6+SZIgIybOeRD
	g7u5BaVqLM+KCU7Sl/Vi80C2Yc8cV5g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366678; a=rsa-sha256;
	cv=none;
	b=bCOur6Tn0N5fhuP8BckDUy+Y0G1ho/8kDcRj+Aa5EFZ9s2emQZuhrvLNxlJw2ezHK+EpVV
	gznVSnVh6VkntEn1eZ50ndDFWA5+OdjC6s4h2GdfnFmdvdPU4p0hBq3Lv/84WPh4cOzPmO
	N1RGbFP1wXWPJPmQgkjhcpMPvCwVPyg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Iuezaub/";
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so727948a12.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366677; x=1756971477; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVrt2ctwbXgHbo+Hn2TZ0gCxiv/sLljbJFjbqAY/TQU=;
        b=Iuezaub/9Hg+2++TwPPGOdWlx+rJCig5/tSxcHECb43bOaAXdBt6QCGMfdvDHn8KOY
         /MoQkdZ00bt1h3dLu9TahG+2t1ZtO59ky2ec6Mw7gGh8vd6Pv4TmskijYcSt5hjtvB0U
         BK0FYqjWBBzynqXEZkP/PbZqSMyszwGs8xdEFun3mMK8F8dDHXrdKqxEBKAfBl+ccWci
         7q/cqw/yL8a9NlzOf33mNcOMgum2FpX/yrMz5h1ckalwIwbJpBkJC0h4tkizykVxUykj
         e+PjFCuR/aY0NLKwcBdhQloaLSaNdJN2/baikwltmsqPmR6naudUIFVTB7EZD46P/2Ct
         5prw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366677; x=1756971477;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TVrt2ctwbXgHbo+Hn2TZ0gCxiv/sLljbJFjbqAY/TQU=;
        b=ZERzMcOtUoKeetkByerrKOu2CSj6k2uVx5MfabzFnTcSbvlxLTAeKEcez33NbXg6Nv
         rkhv/PvF0X+MgD0NMtrIsko4iOw6+BRJxytFzwFRhmNfr64KWw13AZsec9qQM2jSILtS
         XhIl/0R9BY1L76yb0/gchiUivEndqFLBJ04QN74aSG7LF7PM3zg1idFmxnNBYk07O4kP
         CPo6uCwqBH7Lsiz4oyDTICTwlUpyBKy7Y7PVe9zdZo5/nxQN1oKYHpUuNaL2wV8dOc5O
         1BByWqVWieC50N2zDSJv4r9K4vj1xs6kkpk4SCi2noPWC2o0gQcW9HDEMxGD+GqtzA4t
         URJg==
X-Forwarded-Encrypted: i=1; AJvYcCWlc71jA/09W+YvDVQBX3Tq+mTFBFkPtFisyUBAfrq4bTNASJPjzDmofbbFuaqq7WXwhMrqomQM4A==@kvack.org
X-Gm-Message-State: AOJu0YzeQsKU5eOp+TABAdstIqsajzLaNmcNYNW17jHH8Swu59W2uFuw
	JZR6hDhYfob3x1z0kqcGm3o1WqTezXLWTEvI+XGUGOVardvx0bfmazqy
X-Gm-Gg: ASbGncujfdDrwg/PpkMm69dQNtcFxJzqz7dMqdfL4lX1NbLEeqR+TLCZdjOUTRIWHgA
	GTF/SzJIUiCZWTFnNP/T0b95Hbm523SJQ8uqcHzQ9SXN+JfU1cGYOjjRwfIchRYnYQtN8q0XKA/
	Vs8cTbYeB8DyaWJMZEz1ytJDPcJAkVJHbeNPD8u6n/EmpN9H7r/92RIWBUZAQX788lFhNOI0+kD
	cbmErZxhkcSCDg4cjKytOn6Yr4IwQb7tH/oL8ZA/Qljh3uq0GEdAOfXU7DNdsZ7vydIpqX3PAIs
	XiCbpOqcWk5XWRvbUz+3nztWhISitTsaB0fk+zjd87JxQmZFGSt7rRyzJ09bT6j5M6WZmxaLYrC
	VlqOZ4Kq2dPaAai4fCTltKR8Eb7oYJb4MpmEeIOosWUewjG4=
X-Google-Smtp-Source: AGHT+IHzpXzU7IRYTRL9u8s1GDWZ3U5CYmUtBakw/pIBZX/rgdseIwaMMauanPlQhlJ9DDnzYy2q2w==
X-Received: by 2002:a05:6402:52c4:b0:607:28c9:c3c9 with SMTP id 4fb4d7f45d1cf-61c1b453182mr20154119a12.6.1756366676733;
        Thu, 28 Aug 2025 00:37:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cdb00baf9sm715248a12.33.2025.08.28.00.37.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:37:56 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:37:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 11/36] mm: limit folio/compound page sizes in
 problematic kernel configs
Message-ID: <20250828073755.gyq5cyafrxb7lnw2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-12-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-12-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 691BB40003
X-Stat-Signature: jefemtw8rtsgtmqc3yuui5diunstidn4
X-HE-Tag: 1756366678-667969
X-HE-Meta: U2FsdGVkX1+W2kqjk5MbgEiUN52Fy5Pfxmaq1s9i+CKpOlz3mcpEUNSse8sfDenqccikgdeH9brP6xLDleEm3CBcd3LItFm2YrvhCmfCA3kebzvhkH3CrEJAmPAhEdy+/HaX0kAig4wC6inamAcQVILa7Is8mrZbxSpAlTAl5/IVFAE41Ke451Dew5MnKWoUbGmlSETq642BIeAQs/rj8kxyREb6fFs5IDqhl9joCWVibeXlk0KU0HNLFsC1MLV/eGZ4WMWqAwj3IDYSxKgwEZGUEa8i1j9uAHEWokG2/a34X6lScDIkq5obnNZNPjYy0jBGJopAH8HPTs4DlCY1XrJoL3UC/WUo6IJsJijwD9sTqm0YYcXlCXylgYxbRAmQzuqxfIilSCjwXkZ/L+fw6zn0ZUKIEgfNLlHux/XVFxIlwypZQFwa33MdN/IbRrToC2956MDbeNdwDQZPMZF2vKkQ+xzHYGhGkTPJF6iyOUMkNel7OHeSg5fV6W46zdkS69ExtbabLiCyoCz8QIeaw5xMM9PV/oGwLqYGHg4MBFSC9XxwI9gIpXYJEQfQBz9i4CSlCbycAVE0GFpLnHwvIcCCoWE26rG945g5XtQqeGS5zAS38GRF9sMFl8K3U6IT302kIpbRef//LEGF7Sq6W8xpu5A1xFyeEsCLm/2KwMRcZj3ND5b9OTv0qzMhxfDe1kQ/H3Gld5jThEY7xQj5F19zUys3KebS1AMOXwCCLzD4e0j1dPMfhe/HE7zzhXMppOBNKhCh05gpqALeb0d2BhczT/ci1/ldWpoOX4JI7+v2lGO6zEW1vL7pTU9emeNyd4zWp0rx2dKAD1/Z4VdxYuaUvzhuinQFJBlehLvpWMsJ9npZZ+LYsQqX3TbsTB+75yEDgNTVtooXuQPwqXpREkgtiFBawXURSFqQyGBWlH3k0Q8zocZ1i1rm2qVcuScRTTxlVkPaeU0ydpOUjSX
 QO6wxnOG
 i2E7SPdn+OBFFRkiBOcSZNmzpiUHBy5hWaBZxCCq+lelesrUvhdl4BXNyXJhnDW/5/9B/xG1NOW0inH2Q4HgZ/jG8wOYqbHl9W0xKlUZdGT9c1xdRAMZKX/19AyCMM8eQKQCw5/fHIQWPSt0R6v0WzLUbe7+nRuWhq3i/i5yRIPEIwc1gFHx5VzDx77gT6McOYR7oHxjlCT0mrWvZH2m4m0cZqrBzTWIY6aeZHp6qAgs7Fdeb7xxoumfZPWUArMFeYcSrPB+ZqVhjTs/xBJNDaWce+TkMGT6jlv7kTXvFhr1pdS9a62a6TV4Faid/4Dpw8GnPl7I+P3DDMbUXucGp8PbfSxlLYuVC2B+uUnOE79SFH+8b4sh2ZkTls4Zd2rh38+2GBjFog9fIiNVb5awdL2SlfoCkGffLx69cC5BH0tnuBWZRV+vfDYqmiq1J6VIuS57SKyObcxUxUAb5Lszwpcu4QoZVkdSio0mshlX5psiVsLFU5pND6CZkyXIEuVZ63dMaPAF1FVhIcTxNUZgiWrROzWLkeKmHlB7rUJKniQ82yQz5K/TrVYckbLN88CVxTruPyNh7P8wy3hu2aeE3d5893fBL7kOneVmqgr4HSGYQLPAb57C7EEEFE3PEh/ZTxL8r4q1bIEuW9fhIm31wqAEy3RwwiNwPLEStimJBSqG3ckbvlQDqN7q2G2GYPKWEtAIN2wnPSJs2Ii3P+UFmag1nM4XgVG6P3UkK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:15AM +0200, David Hildenbrand wrote:
>Let's limit the maximum folio size in problematic kernel config where
>the memmap is allocated per memory section (SPARSEMEM without
>SPARSEMEM_VMEMMAP) to a single memory section.
>
>Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
>but not SPARSEMEM_VMEMMAP: sh.
>
>Fortunately, the biggest hugetlb size sh supports is 64 MiB
>(HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
>(SECTION_SIZE_BITS == 26), so their use case is not degraded.
>
>As folios and memory sections are naturally aligned to their order-2 size
>in memory, consequently a single folio can no longer span multiple memory
>sections on these problematic kernel configs.
>
>nth_page() is no longer required when operating within a single compound
>page / folio.
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

