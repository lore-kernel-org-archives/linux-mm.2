Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAC5FF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AFE6B0092; Tue, 28 Apr 2026 04:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942836B0093; Tue, 28 Apr 2026 04:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831716B0095; Tue, 28 Apr 2026 04:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75B316B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:52:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C0C88BBB0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:37 +0000 (UTC)
X-FDA: 84707348754.17.173B695
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3AB7A14000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:52:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=egcUtoKF;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777366355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g3RZ85zZRMSfm4V5G/nYn9e3XYF7QD6vD8DovC4NkGE=;
	b=79JY5pM7gm4f/nmM1ys+AmEGV+ZJO9S3LGty8uAR1s5PHobDG+LuDCOleGcodqU2HVi2NN
	q4ze1aVw+h5+Y5w+sHjRpN+VVBi2ocjhl+kbTI/7vIxgQwDvFajXB4psZmcaGkFjkCxQGh
	Cjue0mGAKocxKR2V+oVNW//4AhNa2IU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=egcUtoKF;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777366355; a=rsa-sha256;
	cv=none;
	b=ckgKrTsdRH+lPiAVkzttfpvbm3JmP7SwHljbT1yt6reZbTxaIikakAAA3rw3JFB0nByCNT
	hcYuvFvs8Mvg/jBRRvv9YRcPm88VB0KuWZA9XzJbTIBuYOC1jOcXSmKfVDyhO2VgRsMmmU
	gyVVUnugvaBk4c1jaMRcfIJ/7yUeaWk=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-362ddc1de56so3457969a91.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777366354; x=1777971154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g3RZ85zZRMSfm4V5G/nYn9e3XYF7QD6vD8DovC4NkGE=;
        b=egcUtoKFZIWLRDPF3GQyPJLg5zm+VZdvi5wJke2qVQYgTDW3KAe81pJU92r46ztP2C
         /01zlB/EIF+CV/1yRAJ5J5xKtCwroe9IZLt7vEkF8r1LZkdbIkXTnPtf9WcI+QPlWFUm
         qRLVPxQfY8gaxC9u8TPvM6KZZeJyQopxrrxq9DzuH5P1Of1IzTDQphzmcVHIZL27KOGM
         /SQQEsQ6FvDGxpSBzlMdeogtzpoYHqtoKjyUpF/7GNc16t73B3PF5aci9JYFlbr6Pqpg
         Rrzq4Gt3qAZEelv9D+NNMkTEJZATbNASdeMROub6y4Y1DI7SLjSyQkAluDmTE6AwViv7
         ApGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777366354; x=1777971154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g3RZ85zZRMSfm4V5G/nYn9e3XYF7QD6vD8DovC4NkGE=;
        b=BTg5Ia6aqv1Dkdf7Y/6YYZ82BLFlPPX79cTuxAjlvH/yhQpCGB52EiXchY0JG5r7fV
         vgy2CIbq+mB5X+uQrFq2Infk0rX2stCOWIoUKV2KzmjgJqQU/U1CsgCYGrXcH/xhnLvG
         sQheoc8Obg4h7lmI+9+cCcod3L6sc9TlewNgIx+bjCVbGiFDUcT519e7dTTzwWCtu4q2
         8clXvdALpNnWcGDh9/TkL7iv2bTe3NMa4jHlXAFSofaljWx4Upube1Z2uXfI0NCw9Lp3
         NiclQY+/Q8BI6sPIBR2QK6aYMXpkBdMf8VYPYN/UQQr0X8uadjBRnEB4/z+ZKtHkMEnM
         fDJA==
X-Forwarded-Encrypted: i=1; AFNElJ8wLOkNPcPVxHslItjqWJVZFGclNyiabmo4soon+FQv/poflcizQtuC37r6XKMPrMxwKJmxz5tkig==@kvack.org
X-Gm-Message-State: AOJu0Yx0CS8i0H+cDt+FIxawa7nZIn0zFuW3Nn32BeUS0dy8zQkGbdTK
	Pem+wJ2RxOHn5u9YvUHOXyAzeyMT7+r3WxRkd4jERQCA84Jctk5+PjjGdtaOnjcHi+8=
X-Gm-Gg: AeBDieure2Ob/2xqnd2OMvgzWeqfLlS/o5Yb0bNYxMNrW5zEtqnhDsVV2VyKtqe4yYu
	gjDJMU0Tgm68kxm/uZ6VFwpdy5crjI86e4AwcYaUHoG8cmo6Ub6GLOhR6vwUx8AOB74cDityW8K
	MeWr11pCjfdqgEjNkrtyhlS7tFdee3JTgjxCdFHaNQBiXAGwxKZ41c/EWbPaZx2lHzzbi5cgDqV
	/7AoSt/ydJLuPQggX6iwZbcGauY7Xr6jrXuhx963bHIv3aaIQZAz71xF6aE2wLiEFPp51sdBr19
	HSG7/1ZuX0mCFsh50K6BUGFClTt0QHndMVlbZD/GHfEbdCPfFIELePglCCMWbT2UOSDjuqMWqOx
	/9KJ0YwwI3acFH+TtcKtFqBCMhsxLWxWNOPz8q+ALX8jhFKGWGjX2L1LncKwIna+ObTSBzcl1LG
	GBWubgDK2LaT5Vzf5TQGMwKPHVmE2GrQpWktB782OKH9qb9k37fJzKhVM=
X-Received: by 2002:a17:90b:3510:b0:35f:b5df:463 with SMTP id 98e67ed59e1d1-364920a5111mr2319506a91.14.1777366354012;
        Tue, 28 Apr 2026 01:52:34 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364902e7debsm2889080a91.15.2026.04.28.01.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:52:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org,
	muchun.song@linux.dev
Subject: [PATCH v2 1/3] mm/memory_hotplug: fix memory block reference leak on remove
Date: Tue, 28 Apr 2026 16:52:17 +0800
Message-Id: <20260428085219.1316047-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428085219.1316047-1-songmuchun@bytedance.com>
References: <20260428085219.1316047-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tddj451iye13tp1hsbnmrbd64pducnxb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3AB7A14000D
X-Rspam-User: 
X-HE-Tag: 1777366355-83417
X-HE-Meta: U2FsdGVkX1/X7I8sIYzdhcqaPcnDquo0ayc4tt0D/hEqrtqxH3w1829ra64q2jpyQTP2+pFqcd3iuZoDG5NEYAB6vjs2nrYAwV6IsDUx1inft2IjTVnq+K6NEWImr4k4DVl9c0KmuEELlGfQ80KkDCx3mNkH1o7L/zUgpYW+bN9U+6hniGxYtnbKvghTUP2rtjhPeQkhkC5e6O7sOMBsxjvonwBzCOJMa2gtH4AKIgBVLGrUwHvMPyoItPB+4XklDAFZtjaKiwEQVneQxGKLx1H5cqObgnGQnMNiXljVaKgsBEsaEToGEmdGnkTMe896vQTW3P5zrdW5EMA6TvEgtb4RfhvCSwWkaiV0lcK1PEP7WZ2hoNDDgyPBJLc6LLPPEreY0AR+GWxgUblX+524oMInhTbXBjdh8bgMsSYxHP2dXxoc0P7n9iAArbeFR1AaPbA4o6AgI+KNuoRR5UBX6EQQLA8eyr+VlEYQMse/17MiWV4v+IYYeZrqaVVoyTUHt1k23wEEqTwq4x6c0G+QUe9ut29oapyKLJuziokQs+uCn3Ly7mex0e8/DyR91uUScfSLJGtBnFcjaQnFFsrqr2WTDju2yTDBQolKfP/7suvYWHZwPGsNch/EAL2aJz1sfNrUNNa9pzVZUeB1ZePMHrUE6ydOx96zkM0ToARwCM/lpIOcddlLv/8EqeNEGggYHkWIFKHRIImjr+6JdIPHMso9TtqkwN6wRe5us0r/hd/AESCCi8eBlnwUWVil4ZABOilMGQ2XsQ27+Gw/QYgmo/hp69qsPD37klzFDjjWEp/Bggf7wWm14Q9zZFa66ITe9Opr4yC0PbaAYGtalNkJEd16Tg2xFRxG0DGZR9rRU+6QSv5kDHUSVu1yjCynHgP17rqfNoG6sQmrI7pXHIYg+VJypouByamihhiCdPPE4RQ74lYKeLqVHVcc6Yd/DCCY89CMsXXdWBL0p1zoeAq
 dqobfeyP
 Ej4T+1j9Iwq5v+/svZx4sYyj2IIjmXtTIrsPZSFEL50PLG+qZnSZds3dvh7UQpL+V2W9urHVKF4s4dXtcVPgIw3bPjxu0+I4uJKcqVksqha9DV6fGa2Bl+UsxfqE/Tv5CPhKTh5xkMq+/ToZSBb9qeWP0ZI8/6S6unA3EGS4HwzHo/2xjAM4EKutRhWKwY42icBePfFSqR798WerUAJhFgoxJNKgkEdKFlfhe44o04JPDth6piKHKUpiKAxsAAheMzNTnX86wdjZpoIL0QWazjTdsyNRzlWXlzp225PfDu0UYHvPWVBnHcQsKWXi0jEORIZr3W0mCPfvfeYzxHJuuu5ZjbmoORwdS4Pw/7yXUtwAAUBhCsCYlilD66UZPxH8kufr7DPJTVnTYT2NLsgEs7jDfJ8WAZKOON9ug/AcXUmgvtZ97N9XT5OQ9YeRjObxP601Nx4pXck9rCdd9XLbALu3/nvASFI3q8ParwqCNHwvssodiTJEr2062TvTp2ccMfBgUQaSr3OaKgodjCT3IOtqduy30f2T8jqFj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_memory_blocks_and_altmaps() looks up each memory block with
find_memory_block(), which acquires a reference to the memory block
device.

That reference is never dropped on this path, resulting in a leaked
device reference when removing memory blocks and their altmaps. Drop
the reference after retrieving mem->altmap and clearing mem->altmap,
before removing the memory block device.

Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v1->v2:
- Add Acked-by from Oscar.
- I didn't add memory_block_get_by_id/memory_block_put because this
  is a pure bugfix series. I will send that separate cleanup after
  the bugfixes have been merged.
---
 mm/memory_hotplug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..40c7915dabe0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1422,6 +1422,8 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		altmap = mem->altmap;
 		mem->altmap = NULL;
+		/* drop the ref. we got via find_memory_block() */
+		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-- 
2.20.1


