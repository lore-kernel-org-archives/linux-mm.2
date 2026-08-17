Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08165C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9A66B0115; Mon, 17 Aug 2026 18:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1406B0116; Mon, 17 Aug 2026 18:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090916B0117; Mon, 17 Aug 2026 18:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D905E6B0115
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:08:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6720EA355D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:18 +0000 (UTC)
X-FDA: 85112150676.05.D835776
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id B1D1F40005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W5YyCrJP;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787004496;
	b=HXgYw8xPOX0qPwwdnW0s9SiASwcmLH9Zj0ggZMpsii1HWlf3NfyPU8UHPl81TmdLna6yby
	fLe6aVpo68ziXnbSCUpLVoTFbm6VbHphrkM2tLRRQi5s09N+bt8EOHg7IMi6bN31FznsQd
	zQs7ZYPumxBGxj4bk5NQVfH4c/SM6jg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W5YyCrJP;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WaMmOyr/e8hbHyUhtw1/fJWH2VLNaqO0DJDPfuneTJ4=;
	b=diDBuzmdQmmVtyvTAqJ+2r+zSdAV3QiZ7Z4XPkAFYHMZpWaSbvCa5B0W3URjLWL5L+hmNG
	h8SxJ7+VmbH4OsgJgtN/OFID0V19gecsPlPZOTHyk7EJ91h2V4UCggm6ZPOhO9zlDeCfHl
	O+WHpIvx9B70nEuiR0BOJVLllk4adWQ=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-936e393176fso126596785a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787004496; x=1787609296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WaMmOyr/e8hbHyUhtw1/fJWH2VLNaqO0DJDPfuneTJ4=;
        b=W5YyCrJPfIgbbdINsOkVfwiOtf3uRAo/DqHB4fG3z4IpJXM0O6y6gidQ5ZJItcvZST
         L/JKXdPXHzMzmBXxqHZezDySUiO4Mqasn4Tdp+3NQXqp3JqQJNGC6acccjobi8SJcNet
         Kdz2EQe6j2s5qPm2rVlIJR1slr/xS9Q4YUfd/P+bdWGLQfyN/u4d0hP7CNlRMb1uSET+
         mfm4uhe9yp/J019bNTOGkEBvwgWE1CXAD4HaAxQyBi5tOCcZY+bmjbd9CNXnr9Gll4y3
         +Zjd8H5SjCfhOxg3irqZeK3I9It7gYR6M2PGdL3BSQJBcoSOddw9NSAwSOFE1tCV+s7K
         6/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787004496; x=1787609296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WaMmOyr/e8hbHyUhtw1/fJWH2VLNaqO0DJDPfuneTJ4=;
        b=j3VhTrBONQLXfiA62b3K3NYYQOmjv+xFR48V3cWX33sO4KZpIUpSp6Yaguz5hg+Jcx
         vdNzojZOJF8i8z8qHhFswB+UXVw9xImVktwn9EOESO+6mjZfvHX9c77L4MWtGhppVMTC
         JvKw74rIDkIfUv5kO2aCXV3Oh9S8aITpDxtH8edKCYbVb9pgMWA7DsYDLE96ID6KlUF8
         lalH5xHzDpsrfRrsuwYgTGKVyXpR1fXK2P6Ubearvjaq8MH9VBMZWgDoXDl6yVjTjdRa
         8jTHeF/f5ag4czMIcwqGIp1e/O3d8kRHqRvCAy22SUo5XZfuMj/4xSZXjncaWQAQSxyU
         HrdA==
X-Gm-Message-State: AOJu0YzlE5sc5Of8VpCLmgIGphVTcRi7kLgZM4HoQcKBhPX8yFSrSpHy
	uf8XcB6jIIIluoYPlKR/K1oAViru9od0rfGzX/fCRfWOBgImWUwP5bmT819SkhvDDBWiOhN7CnS
	1CP11X1c=
X-Gm-Gg: AR+sD10AbzzmjhlCEH6I8mo5tJPPAwoenXfLJFYM23b8rkGIGBXKS2WpMO4UG9jZ8cn
	0NzjgVnwjn1nKtW0RChT4BjizmaBdNE4ZKKTtNwAERFRJGMYuEp2fjgBnPaRLZ2eJ7H54vfWEFw
	lApwPeQbCextisv6hdHotIIJv6DqobLmSnc6jAaMON5bGeV06ur6WuAtpagF2X839+bzAu4ob31
	HNmmbMGaudm9N2i/MipTXmHGqBeq7B7/0Yd2r0o9cZQP6I488GEo6mrrI8bxAZ5M7fNLa7d9Hxw
	eo5WW/yxi5mS2IQCq6G5Mzd1KyZGjvVMiuZrMwdMtQDPOonj1KwyvfL7LsS2HlV2R3El23IHph4
	c4pumG4qs7G8tQT1GB3bDn+wV9XOYOM3r3qUV/RSdBVbamWmMTl2buRjmlFh/cmOkODFoQgr9YD
	PgiJaxw9EkQG9fqQDtksj3PADvjHFJB6t2MK/g1wA6jFhu0Ad8mwp3LxtJkXTw0uU/GWlrXeceX
	9MkqCDB7LpUyJrgcSbJZGOqNLjXEtkTAfNgCcrO+pE+y1dDSyFhuJE=
X-Received: by 2002:a05:620a:170f:b0:92e:603f:1f20 with SMTP id af79cd13be357-936d2145adamr2421836985a.2.1787004495789;
        Mon, 17 Aug 2026 15:08:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033ce78csm147108885a.31.2026.08.17.15.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 15:08:15 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com
Subject: [PATCH v2 0/3] mm: reject zone device folios in more folio walkers
Date: Mon, 17 Aug 2026 18:08:07 -0400
Message-ID: <20260817220810.1175596-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1D1F40005
X-Rspam-User: 
X-Stat-Signature: nchnng3hh43h5cyhw4mxzajy7rht48rh
X-Rspamd-Server: rspam06
X-HE-Tag: 1787004496-187829
X-HE-Meta: U2FsdGVkX1/a6h5AjvmeregH6Kh15s8hI812OxoZTV/6VW3xiU3ArxmDuoT727gyMz8jNcvPOFNGf5Od6OxTTWmij8In1Q9YTc3Y3lsjWmt3RSnsCRCsTYxbbP0BpNhQCLKjOpBcJ2w9Xd7cTpaZyzjlyiwAeamVhBFTvJzN9ujTLKwmkz72LTMpann1Oy5+ZpppY6WaTAt9fv7hsSy2/4HJ6Qxha/7vsQri9ghpyIfcl1GGkS9H3NMryF9nu016KVIFcAyV35UTmPwNg3JkraQEehia4lPeiolGf1lFCYndNdMRpBUzqgnK3S3MNwvLtgAjwHlc+XbkaV6zZk2HxOE+GbLt60WniaZ/CKLn4hvyp7d3m2VuzcBgmi/69rfEhuKRuSImlbwB2xk/23llWnXdmJxRwFVvYvfBpNtsgsnDoi88MV0dQUYSZiwK7aZtFBwChaa8Hh0yIYEp6BkbkWOvJ3dk5tz/VTuZucQS/Jh3h+r2jtDXwjTi2ub8PHu5QPFPMRV4fdGovkzfwYXEXT9TAUaXJx13r0UDBQvxTjSXDSNok7HA4hwcufVDGJklptYo+A1Po0aeBR0x0kUwiDpT3K6hONyF7YF3TsMDzqeAohEXtzrb1CGrUh4tqUlXwJAZe/j8kb0cYUHlnpgcPK9uz10DtDDCX39PrUkWijqHqi6N8LPlYcLoChZx3K4kcIG532v1H69NOS3xIWYKvRXOlCavlmQ1x+mtAq+yZc4hM/MeG+XHTImKCejmXSKm3+m2dLgIAW4Xi7+mgYsWVrKiwsAoyvsUSK1o+MLW+skgUBLbGRuyq0QQFGSFSOPRHpKhIF7DPBxs/gP3oVmvpWMmhlsgXdzpXpCIevVfnTiLt6wQ5mtWj3cyA4Rgkbop9KTWvrEg739nDwP+iuzmN5a3xB1nJ6bxHtVCOUalF+rkMw69tvH211jdAZYecr0TJNpA6aE+Dze2TYektHt
 rmLndwqy
 BiZDXX4d2vUeX11KqAJ5Ohusv8oxSX8qYIqTa1usTZ8FdxIgOMQz9J7rE6ggMMFytEg195sEuDP+0cAKxQRogWui2hkGa1YTr8Z6zVdtDtqIr/MLIFsmwJKTaZw5Eslom8a2tdXa10Rr5ka9yoechPjYXxcvTLnjqXTuQc1sD3b8HyjuFZlQofHBpzBeGWfO/sXTJeTJ6uTr9ORouYKvYqJJZbYl7BCluEeRCkkJFC1CNqj1aWufmpgMPxnYVJWSfa3f69gBn09yn6K3LnoaBjr/CfpLBPtsMbzroH7fHzVD1crOSGosI3aLN8RYAPtT9sVUR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several LRU-oriented mm walkers resolve the folio backing a PMD entry
(or a physical pfn) and then reclaim, age, migrate, or lazyfree it
without ever checking for ZONE_DEVICE memory.

This series adds missing folio_is_zone_device() rejections, matching
the checks that comparable walkers already perform.

- mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
  only filters device-private entries (which are non-present).

  A present zone device PMD (e.g. device-coherent) would still reach the
  folio and be lazyfreed / aged / paged out. Add an explicit check.

- mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
  (e.g. device-coherent) and queue it for migration.

No crash reproducer - this is a correctness/hardening cleanup found by
inspection. All checks are placed after the folio is resolved and before
it is acted upon, on paths that already hold the relevant page-table lock,
so no locking or refcount changes are involved.

Gregory Price (3):
  mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
  mm/madvise: skip zone device folios in cold/pageout PMD range
  mm/mempolicy: skip zone device folios when queueing folios

 mm/huge_memory.c | 4 ++++
 mm/madvise.c     | 3 +++
 mm/mempolicy.c   | 2 ++
 3 files changed, 9 insertions(+)

---

v2 - drop hugetlb, move checks earlier in queue migration route
   - fixes tags for all 3

-- 
2.53.0-Meta


