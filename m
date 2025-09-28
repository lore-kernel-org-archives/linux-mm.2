Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58AA0CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 11:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CA088E0003; Sun, 28 Sep 2025 07:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1288E0001; Sun, 28 Sep 2025 07:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE358E0003; Sun, 28 Sep 2025 07:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF8CF8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 07:17:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F43B160966
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:31 +0000 (UTC)
X-FDA: 83938408302.11.C802177
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4FC7610000C
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:17:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gZieUkdA;
	spf=pass (imf14.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759058250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BgJ4Bk/AgLj8OXwTMGRn+fyRsVHIEGunbuVkNEAkF+E=;
	b=0sb7MOOogy87pD1hDIV9Ypnm9qiXZ05gupZe4aL2DqH4FamSWrJ0/d16ALpzNCu2h/At9P
	XXvorujt/jcB0y7RlPSLsYmMJwQ1/U6SzhsXh1q+7aP51RA2a9tjMkbibCnBeHBxWp/6dj
	VjJfUVh6c90yZGjKUQ3KU5ceC648G2k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759058250; a=rsa-sha256;
	cv=none;
	b=PsyZLpcKL1X2lameaYGEkrQ3Grsz495q5ZpqnN9UvytySfpYZzF+5EW+WEqmiWaljZem+x
	Uw9ZRMin/ZAIUQxR+6WrQ5jMxq9Sg6HRFOVw5UiHT4NaP+QE+puA9pwEe4n44oA893Plmn
	MIAhoIqHEF/BXJnrqRjUr+Ea5Utko04=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gZieUkdA;
	spf=pass (imf14.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b54a74f9150so3176276a12.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759058246; x=1759663046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BgJ4Bk/AgLj8OXwTMGRn+fyRsVHIEGunbuVkNEAkF+E=;
        b=gZieUkdAV8R/Fxi5PRV1MFYFjpiqDk09E2+DAVO2zZu712VkBHYfyHr6eHYfn5yoBL
         BlARK/ZG5F4mupga32Hq0PAWH2NY6yEY9wf3LVKu6/kikklQJf29oTN40qQL8/KPD2BF
         dkS44Gwa8QJ8l8YiaesCftUnmVatRNMPrQZaMV8skFV2CqctkTFsFHfDBSNRYyvijMRA
         HiipOEK19AI7aL1pUHH4l/K2L1LGdeTSBNimuXuxE2zLkKNz9v+3g7irLSqpIN7L5Tl5
         4G0PZ4eEUNJHWsB/WERrVGQr6HLZv3fNVxu8FL2P8o0dRB3MNrdxeoz9Wpp/rRGRTxh/
         0smQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759058246; x=1759663046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BgJ4Bk/AgLj8OXwTMGRn+fyRsVHIEGunbuVkNEAkF+E=;
        b=c4/XktNCCDHBcw/HI3PXTrkDvpUgmpE+ocIOwmSy/Vcc2pKdWNRYoPhby4Q0jvR1ml
         tVX+25d+3FmWRHZFMmHeKNtDhWRP7QoAX1KfqMSomQuZ6tI++lWDpVR7gjnX6tQm0aOX
         HDWb1jOBwv27ZYqaAPvBVu1Hpnsq6vQ4BuagBlslVOD258aag+OeeNw1cdTxnTGk4tg9
         Uq39yAo44eT03Re2i/9XVXNu+pB82axt6YRjEtql27ySYAIeY8z/RQ0ig/M3hfZvhWgc
         PBowr0l1JSLGpbj/Irkf0ZArEuWNZ48AK3yIZfBT4UXdNR4Bdcwa+FMasbgbgQfLqh4m
         gmjg==
X-Gm-Message-State: AOJu0YyVuk8Cy+oHCqW5qqjPECqet4piWPIhZ2T2HWfwKqrzstnAboSx
	xhxpje6jbKRmgcBq/XLguN4caGh+YGfY6X2biQthE2foio6Bl+xqgrpaggC6zOz9R2o=
X-Gm-Gg: ASbGncsAdNPCponIvRtFZyN1zRtBXOOM4Q/XAUgecYfNRK2sZ4IDc8KQng/tduHkQyH
	nb0zWiB7LLrRT8TzyxY7oM61W4S8YjxQ5422uzUAdUNOAcVXauevCXvsr4veKqkZHab8e1XXY6M
	GBOtMzTc+7o3C0s5YW9WpKbk5ENXbkQj0uI4YS2856Fpw6Zteo7mKgEknybvlkUBTndIWYv1ioo
	rIwVKJ0hiIjfsOyQpG969Z/IuwVVVhmCEpfBiIFtdGmJ9H3cm2zVu22A3BGOljUvdLYRfZAnxzp
	qXY9SPpMgpNZReabjMsPtPHjKYDumZAA1ts2DLLUgVG3ZO+2HxP754oZ/B8DuYHD915J43jYP9R
	QRmngBXdcJaHDeDVBRSqfL3VCOTxebMELTf3FxuN+FIgTBcLeOaGRVho8K68JmHR6m8hB8I0f29
	YD
X-Google-Smtp-Source: AGHT+IEIBgcE97CoXC2cuv8USSawi1baX2mBvmMGwoHiSnGzF1+jN6Y2AS3XpbKZjXh6B6f41EZZsg==
X-Received: by 2002:a17:903:1b28:b0:269:ba8b:8476 with SMTP id d9443c01a7336-27ed4aea2abmr148101555ad.56.1759058245920;
        Sun, 28 Sep 2025 04:17:25 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c55a2c45sm8687451a12.45.2025.09.28.04.17.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 28 Sep 2025 04:17:25 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 0/4] reparent the THP split queue
Date: Sun, 28 Sep 2025 19:16:58 +0800
Message-ID: <cover.1759056506.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FC7610000C
X-Stat-Signature: aw933yxk1m5zskkcw7ambk7517pdqitr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759058247-108334
X-HE-Meta: U2FsdGVkX1/vqC49PrhYOKVX04VkvzcRyhPGU8PqXLLl9dKZKkCPcG9HFcoIRrwyUoPVsCDnYWgx/GrYcbIMsAHozPVhjfQXGM4hdzA08rWHpQMdLoZQvLye+r7wQye17avOrz0tGxF7V8Wbt+8hIadntvQ1kGee8sZ8RjfBaOSKh/1p11CqE8ed8NNpaN22QcBPtCG4Xklv90Y+tpomgp/+aUbzeu/KD641lFBk8uCqJZkkP42yEGL0yCRrSQ2QE2AlVdUohUvos9rYrbkehi/6Pra3fHOCf1kGsDtwxkZCH7WHtf5YomOjNaPhy6w/6G4gqNp0u2eq5E0/PUNomulU3om+MdC0Yf4DuyEyvIy14TGTZ4mAg3gsr1IY2+BcXEqR7uaxJUbscmwpsgBXj81IHpkzFt6lDegJG6BZ/W7bDcl1GW01MTEmRXpdMLHShNJqpuKbQL8bol6vrGAPBRybZ6+BRPrlS6i2DcB6of1xHRZb+56Pq+6ZWHeuKPJEqhU5evzXBsEgWBfZnLcgdW0GQziSgqwMThMd4SyKQo72GgAlBSotRYaKZLCg0jtVF92Ame2S5GT8HbeBKfHC0tHm0IeXZUzxNpwBl8kDRCREKBA71dvDk85UFRB/SX9YUK087l8MsVWRKefKWIRdN6Ecf1yTpHrEvAEILVruglVhoniWqDHsqFWRkVO/5xmzeZuNmV1n+BNJ2XqgWUgmtDkDSTgWsIN4rywaYMpKejxY96a06SdRgQfqRaxsoN5KKXuct7RoRGS0xBjxYhCWLVBNtnspH+NbWoSUr3S5Yd/G81lHnLsCHgZKZ6w9+zwqIZ2J0U7VpXCmFoe+MUxVuBGh6eJhjOj+tScQTweQye2bPnKVvcm3N6tFPcyKXLJhnhgt/D0+Gf9TEfxM47ym4vF1sZ1Vd3tK9nxubh8qnk5aiMTyXyo+N7PZZnu0AeQ53PnpQb1tiPUrQPIv8kO
 /1PiLSL4
 GLQrA1GPyf0rV7f/7JiXK6xBmI8/9CqjuSECu87M1H8oUGvgDYAUqPTzzV1Vj4r9jYX63zB1D0p/oHxq3oCgdAMyBdvGkNEfKLox514gaJEcvTATkJZtc+10Jdr/cd6ur+9bfhgj/udEmD1kfOvHoITeWV58+IIw7k4wEUD/tpBMyKefXnYw/+n96dKSiictMNmPLJa07x5ehnyFk9Kep5USdU1+z4EriQol8X4SFFXlxqnIxoVmgOuVJazcfan0rxgtdklYoPAR/8Ju4GghLANK76bCBiyVnRCrZSWXOEKhgblDQ6N3bEjxqjm6sG7Cc2X7fpGmaxAjfkiY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v3:
 - use css_is_dying() in folio_split_queue_lock*() to check if memcg is dying
   (David Hildenbrand, Shakeel Butt and Zi Yan)
 - modify the commit message in [PATCH v2 4/4]
   (Roman Gushchin)
 - fix the build error in [PATCH v2 4/4]
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20250926

Changes in v2:
 - fix build errors in [PATCH 2/4] and [PATCH 4/4]
 - some cleanups for [PATCH 3/4] (suggested by David Hildenbrand)
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20250922

Hi all,

In the future, we will reparent LRU folios during memcg offline to eliminate
dying memory cgroups, which requires reparenting the THP split queue to its
parent memcg.

Similar to list_lru, the split queue is relatively independent and does not need
to be reparented along with objcg and LRU folios (holding objcg lock and lru
lock). Therefore, we can apply the same mechanism as list_lru to reparent the
split queue first when memcg is offine.

The first three patches in this series are separated from the series
"Eliminate Dying Memory Cgroup" [1], mainly to do some cleanup and preparatory
work.

The last patch reparents the THP split queue to its parent memcg during memcg
offline.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/20250415024532.26632-1-songmuchun@bytedance.com/

Muchun Song (3):
  mm: thp: replace folio_memcg() with folio_memcg_charged()
  mm: thp: introduce folio_split_queue_lock and its variants
  mm: thp: use folio_batch to handle THP splitting in
    deferred_split_scan()

Qi Zheng (1):
  mm: thp: reparent the split queue during memcg offline

 include/linux/huge_mm.h    |   4 +
 include/linux/memcontrol.h |  10 ++
 mm/huge_memory.c           | 236 ++++++++++++++++++++++++++-----------
 mm/memcontrol.c            |   1 +
 4 files changed, 179 insertions(+), 72 deletions(-)

-- 
2.20.1


