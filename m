Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A91C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC486B0005; Sun, 28 Jun 2026 17:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CB66B0088; Sun, 28 Jun 2026 17:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE2A6B008A; Sun, 28 Jun 2026 17:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 166146B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:45:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76DF9167BF7
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:45:34 +0000 (UTC)
X-FDA: 84930653388.17.3834124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 07F3A20009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:45:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QXgjva6G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683132;
	b=lnEezwAhKOhh/CIMxzlpQmtTgy0O4Mf7WnZP/SQR4KdEpSfhJCJH6S36c3SbFEmuOchs99
	ekBX8lOe+cabO+4HNIFbbZri1fgGLAQD7bNbJFVZOZsCfeYYz1YbrRR3M5r11gg1mFBh5s
	IdNIsn822A7PKtyioPlXDXsK/Ss5LPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RCuiBN9uCkmY04AJpyhIWd7gPOrcS7Rrqdc+Y3Kk15Y=;
	b=yflGbRHsskrRtrsQpZi7YE8RRxdjL8ZRNoJ1YUIt9BavR/e84A3ARsEZtAbg2TT0zx89tv
	eWLomeLpJAL8ZHkHRfunYBQO2QzIx+e2n1OD5gLB9BFpkKchHaP7ufA27d2GHGzQivN6nN
	gFhcWoen90OF2xx+7Be0eFJ1AYdr1W4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QXgjva6G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782683131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=RCuiBN9uCkmY04AJpyhIWd7gPOrcS7Rrqdc+Y3Kk15Y=;
	b=QXgjva6Gi4O6YD887grlurtmwnNtsBHmgFCB9P6+1grfVCTxWq7NiEgsEO9H2E5JF3YXDQ
	SWJRJ3U1iPgS2ls/YgITViE2qwkUYFr9Iz9xYcZtBxlzKC7JYRGhELOzqyQI/IkZDzfSHi
	H96CjvTTxdAxJ+34aU5geKhLQvpJ0HE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-9_rja7jlMAupiDzqx0pzSA-1; Sun, 28 Jun 2026 17:45:29 -0400
X-MC-Unique: 9_rja7jlMAupiDzqx0pzSA-1
X-Mimecast-MFC-AGG-ID: 9_rja7jlMAupiDzqx0pzSA_1782683128
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-473e18559b2so75063f8f.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 14:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782683128; x=1783287928;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RCuiBN9uCkmY04AJpyhIWd7gPOrcS7Rrqdc+Y3Kk15Y=;
        b=scJx8uHr7jF8+j3hMZ7svslxudTvRN7V0EufkQRmhd0EPqDERz2LFaWLqZHP22M4Ge
         pLYG0xC+D32fGlsgWZ2ba6nQuG1uyBpin0Nc8JtkE3hF/JOaRzUYHZzEYqhjClGWe3fA
         FIybk+wz7sY4g+OKaNJ9B9htTTf16T+7GMrQIuCbKRDMI8H0gQVtANZbzZ6o+G1CC1cM
         9U80mOsLdpcoLx0aRRbzkk5m6tM4SFXOlzjpKQCkUYTdt9p9SD37dWOLcK63fAefnyql
         ED0rcp5n9lymzSQOsPB+csRNY2MwqoRGA3IeZXJjkudV50EP7bxY5PliFUYr+S8EK+22
         hpKA==
X-Forwarded-Encrypted: i=1; AHgh+RrqYLgn7uMnzaRbDpd0YRyLqUhrpb4AKyqYj0nf9WqCndVbGLR/LzaFLDbJp5qsLqC6/MgpFEpC/A==@kvack.org
X-Gm-Message-State: AOJu0Yz29VvXjDHBxqO1aMVbsFdp9Diurb+hX83nTQUoh73VfwWzZVse
	eN81ugbEIfKpCxXk3bHHaiHYP4DFgTlv1kg6M/i3SVWMV0mDIAqfy7Xiqq/l39YUti+jyYA1St9
	wJpwRETGWAy7a6YqKEB/tfwayhQGS9Mje48e8rQyIesCbqtvitqEQ
X-Gm-Gg: AfdE7ckgl9Ztc72jfnW3367YptV+r//iMwjids4XE75i6IRDqX4adQO9WVcdTnvXU5C
	EAxH3huHyHUuxTgUWAqJmGLBkyngid5xDHOmWQ8tjyYgnYuCqRyO32up9nFwjGi9/o6SCChN5iW
	AMtw6XX/dLFzm6EEpjdwLuoWgzjIBC8RrnZtCYdUS0AkLT9XZqi4zY0obYX2b+Erx8MKDS2Hpvc
	aK4OoTiKnZsig9QznPXDrAd0jyPS0TjDhVpAwuNrlER57f1DbyP0P6lL/boaBbPrNtxVbA26z+P
	h+4Ih48COJHnUOaXu6uBBeKQdMelCdEWI2s/UYKQmVSRfRhjba4IOgqk+JaYEjRT6wezsXnJk3z
	Q
X-Received: by 2002:a05:6000:2387:b0:460:e4d:bd46 with SMTP id ffacd0b85a97d-46dc0d0eae8mr23677100f8f.21.1782683128241;
        Sun, 28 Jun 2026 14:45:28 -0700 (PDT)
X-Received: by 2002:a05:6000:2387:b0:460:e4d:bd46 with SMTP id ffacd0b85a97d-46dc0d0eae8mr23677067f8f.21.1782683127520;
        Sun, 28 Jun 2026 14:45:27 -0700 (PDT)
Received: from redhat.com ([31.187.78.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4730937e18dsm8325636f8f.21.2026.06.28.14.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 14:45:27 -0700 (PDT)
Date: Sun, 28 Jun 2026 17:45:22 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <cover.1782676497.git.mst@redhat.com>
MIME-Version: 1.0
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vjT9DcIowDW2OITX-XgXBbpdSz7DKNMXaQPKQv7TuFs_1782683128
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07F3A20009
X-Rspam-User: 
X-Stat-Signature: 1cw4b57p964gft3zre1ogtxb3j6a7gfu
X-HE-Tag: 1782683131-744152
X-HE-Meta: U2FsdGVkX19U4AZa6S9QdJwYIoOedX4vsJm4pWEePX0zfXAnKovJZUK2ctRhmvCM4pJHu1w2bFNaRXfX906cG0wt5Llu3OgPetoGZP1XUnSNPQ02tVROF2gKr4/Mm4ncW7Ntmbfel2HfS3o+UErtwMBlnfXGktFGhgMD54Bc8HQ3kwFMNQcnuxmj1LLoNwYB0ApLmpdSE5oT0tlkgSGUDFCfwqsoJs5kychouIa9kQdFWgeGosa79BMZnguIlog4KhKXaJDocPUpZzz5L83a917fP7nUCVP5LDPDMyXFf1TAav4xvRDxWi3stM1NVrx8s4cBFwgChFoWCLxMFALshImT4GGUSIy0qq1OHaFbrWndon6NRyFynnOC11Fx12Zx1pE+pIBQKAWkvBVF1LjIiSTzlbQD5pfjmKYvAZEySYvt71OmoczIRQYSgemIf2ww4/5zQwN/Dcljd/gUx1FC5mbLvK97s0R7IKUf9t/vGkltnLKkMAvDJ3SYDclrxtIbt7UtVyupU9cKpgmrCOzlbOWFbv2cFhpDh+PJdIJNEtqygj0rjOM9L0+c1TvavAYXvxe2zDs7ywZNJCrSc3eU+MgOuC83Eputy6P3/fFjqe7XAh02AVsnC2rqi+91TVN4jeZkdSPxj9YKGBd27OdjqpKe1O581ln94AnNSoLYGbmJYyLKnfYPax3CuNtxsesTYliPWzm4toPuDstTRR024EYoLWvD5DsJvXvyMKHirJbitVNTPnjgGIpVgTjuYHCRmhW6NQp9O5NFiMazM7I1qIsjGNLVSWB5ngDQkFaHdzfkqXh8PgtfRMyJPjZ1w6ydaehAIL0r6XIcgk8fCLKHO3Kg7u3n80KCTlugXg9BCmKd7xkbnGnRKJCPK/O1qgPeFcIS/151IVwIJYJ6KzPVKAexBiukcOCgZ+1DwQ094vwKlqKZfeA7ieUIg6lABgNAwGbWbUgOn009fgypqdH
 wXF47uui
 FgsUEFYKQB2mlr0umM2RzBxz8c22aXhpUCjkhFt9vg6qZjwg7JzAAJfE78/1BYcgXJXjmgm+F0YCGvNQHXfRsNApsd5PU6yovvuFBKqJmFXTZAYdb1ip3758XjGiJTlHtuJg1l4NF3+Bmg6ZYNiYUw95kfPK6ad3WWV9wX9VYduF1DoLNXCvnWjiY1I7vN7mQqv/Cb1dTQA+8sVnlQbq5brpiChl3rcPZrFRNQQOm6h0JaGMiZSg0xkh8uRYEgwDlxixqfE8p6AM3MaMKmilqUSlmEs2LMRvKuC+5n75mFsEayiMyrNaQyugzL0RiUi9pjai47La8+hHTJv6Oio4QIosmF2qnSC6Daa3J3Cb7iU427giLq/3tGtmC/oMkNrcQUen+WWZ1jm8e/Kush6PispP30Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I don't like it that we are adding overhead to the good path for
the benefit of memory failure, which never triggers on many systems,
but I don't have a better idea. Pls take a look.

Non-atomic page flag operations (page->flags.f &= ~mask, __set_bit,
__clear_bit) can race with atomic TestSetPageHWPoison() in
memory_failure().  The non-atomic RMW reads flags, memory_failure()
atomically sets HWPoison, then the RMW writes back the old value
without HWPoison, clobbering the bit.

The race was confirmed by injecting a cpu_relax() delay between the
load and store of the non-atomic RMW in __free_pages_prepare, then
running concurrent MADV_HWPOISON injection.  The clobbered HWPoison
bit was observed repeatedly.

This series fixes the race by:

1. Having memory_failure() call synchronize_rcu() + retry after
   setting HWPoison, so that any in-flight non-atomic RMW that
   read the old flags value completes before we proceed.

2. Wrapping all non-atomic page flag operations in
   rcu_read_lock/rcu_read_unlock (CONFIG_MEMORY_FAILURE only),
   so that synchronize_rcu() actually drains them.

Performance impact (page alloc+free microbenchmark, 200K iterations,
20 runs, KVM guest, error bars are 3-sigma):

  !PREEMPT_RCU (x86):
                         insns/iter      cycles/iter
    base:                12237 +/- 1     17954 +/- 136
    patched:             +22 +/- 1       -124 +/- 122
                         (+0.18%)        (within noise)

  PREEMPT_RCU:
                         insns/iter      cycles/iter
    base:                12512 +/- 3     18541 +/- 214
    patched:             +95 +/- 3       -12 +/- 161
                         (+0.76%)        (within noise)

When !CONFIG_MEMORY_FAILURE, all wrappers compile away completely.

Suggested-by: David Hildenbrand <david@redhat.com>

Michael S. Tsirkin (2):
  mm: memory-failure: use RCU to fix HWPoison flag race
  mm: wrap non-atomic page flag ops in RCU for HWPoison safety

 include/linux/mm.h         |  7 ++++
 include/linux/page-flags.h | 81 +++++++++++++++++++++++++++++++++++---
 mm/huge_memory.c           |  2 +
 mm/memory-failure.c        | 54 +++++++++++++++++++++----
 mm/memremap.c              |  6 ++-
 mm/mm_init.c               |  2 +
 mm/page_alloc.c            |  4 ++
 mm/slub.c                  |  2 +-
 8 files changed, 143 insertions(+), 15 deletions(-)

-- 
MST


