Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C300D277CB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 06:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105816B0088; Sat, 10 Jan 2026 01:46:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2D16B0089; Sat, 10 Jan 2026 01:46:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA5C6B008A; Sat, 10 Jan 2026 01:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E147C6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 01:46:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 702161A0182
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:46:24 +0000 (UTC)
X-FDA: 84315120288.02.5A98A62
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA78EC000C
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 06:46:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jWDP/9oc";
	spf=pass (imf28.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768027582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9Ou5lC76BYaJdteXUTMwt+L2/JNxHr6qaLeaM9sIinw=;
	b=QnVM0ga1W6uChY8TCIKPlwraq96idXg3Y9A0IMrsJ6IhWQ1XfpZsEWys+S4wYDggshjluB
	tSsANXZZmohPB28d4pJ1N277J57XdiDtfOu8xKuImeXozA2qY01tuGy60YH6pIJSguG4vn
	iOsA379a8HScgRrq7hj4K22ZphLxY5A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jWDP/9oc";
	spf=pass (imf28.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768027582; a=rsa-sha256;
	cv=none;
	b=Vd3aFahe16vxl7nWBhwern8UZDFgJaLIPAMDqBB8tLZK6qS9OS1CMkXwrOv318OwfPggMM
	8C6x0CEqueUkE7i1Z2SPNHKDdiwd/gEbLtYIDTVZhJrmLMHNZMtCU+zETDwf8VceMzvS09
	ptwP7Cs9Rrtu5nqeOc2kPfEYAydW3Zo=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0fe77d141so38135425ad.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 22:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768027581; x=1768632381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ou5lC76BYaJdteXUTMwt+L2/JNxHr6qaLeaM9sIinw=;
        b=jWDP/9octG0dag3Kj33FEW90qAfNd14JF/KcBJ/kf1/4Nm9GCCONLrMKYntPUko04/
         ZWuceS4cmjJpDGx6PvD8R68r0XWYLFL7QSBVgyM0hjyWixcO1oP96OLzVTe17ROS/sbh
         7PMKGD92r8tI1wbwkxnlVQjP24qnYNZSLdZM9IvxRQ+w+qRqWmyjA4rpBusorSpfZfOc
         P/EeUicVK7q77zxhuND/zxsJ+dSpVKXFy6TVaMkZ3PRGZcH6IL3l3uev+dNxBUnr2COT
         dxpH4yOeSHsQKXaZlA/+kWXT72Rpmx0CXEEwSnTEKdZ0mh+nkQDxatI29bhiSiJQWqvl
         brkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768027581; x=1768632381;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Ou5lC76BYaJdteXUTMwt+L2/JNxHr6qaLeaM9sIinw=;
        b=YluAQWT+xHaTfCWPD8+0h+yBW9e6Wq7cPWc1pEifNiDijfyS6ujbvPmEaHtQQAkb4h
         eDlcBnKpsU3+YVbmg6nJqba1PahuJB3ypxsZdH37U9kdv9rVg8wiix1BcvxdsTXXKf/I
         YZUgM0r6EhlH9Mq9PE7qPLS7fEYYDcnWGw/ciVUl0AIhNpRoz6n0Wj2mtcUd2+pnYKir
         iUxsFJb8bQjjCHb5L8B4m/Fh4EtfLzhYYT8cnYeOrS1q+wRu3ilbjsyIldfcz5aCThuG
         6kgPL88Z2NR6RtuCBLyIAGwDBIPPEX6W37pr/hYw+S4pNDW0KFjl1uToKL8ItlDcX/yH
         R69Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgjDUB3Ula6+lPfN70NncDaEuWJCIEWyYhcyMkBitizb1ppV7ClpPK8f7cvdXlEZkv2h5EWMVNyA==@kvack.org
X-Gm-Message-State: AOJu0Yyz3TfXkcpGOsmKvrFpKJk//hI8T6htRNtkrVuNb4ktNtUJ3sHT
	uyzBKvNjb7iyPR/9op77XN7I21kNyHV11SLEuxnP0E3WtpKD1aVRSIP6
X-Gm-Gg: AY/fxX7MxbCeLya7Obb621ZmBKghOeo/MWEvBd/xX9DjcmpSrd3NOAEtMGWwUA4fxfQ
	nnIfIIpa+v22SPwLeB20V5TO6f5aa+ax0vztduO/mYOYrBo27ewYmkp702Dl9ebYYkorm0nddpo
	A6hleSlM/Gc3tRBkPhq5xubyuZxF7WOhAYkuFo7i5DpN18ebkga61PU0vri8B0nFdNccGUXrBdb
	vxXq/5Lzs/oNwMsxxHUnG0YPEc7V/v4BQy5KZlp3NavDp2iblvdFDHyiNy/jEDB0vMy66oQ2caW
	ywA+W/jY6s86wJ1eF8oerhCwfkXIClyHZ50LRBzQQRHHFozs2FJPN/aBflcAT+j2xhtkf5T3vUN
	/guQCF3lFIxi2HI6gSodj+dX0RMvrFPJEd5rTrXacMqKG6nQR72x9OedFm0dI+W/iNI/8QLQmCz
	R+9MD9AOzUsFwwVq+keNeVjrS5EtBud9wCuzNABUwQ5fhDoPg5QWeMgerXJ2bfw3uZa0I=
X-Google-Smtp-Source: AGHT+IHGuQt22SdTcAc4PZYM+XsESzmpxcEWJWs9UUXAO5SJX6AiSx1GNlfqbJQp7/JvjdqURXdu0A==
X-Received: by 2002:a17:903:32d1:b0:2a1:3895:e0d8 with SMTP id d9443c01a7336-2a3ee50926fmr104894095ad.60.1768027581447;
        Fri, 09 Jan 2026 22:46:21 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:3fae:1049:5d45:ed6a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a512sm122712385ad.10.2026.01.09.22.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 22:46:20 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Subject: [PATCH] mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
Date: Sat, 10 Jan 2026 12:16:13 +0530
Message-ID: <20260110064613.606532-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: goqgeomwqxibshanrtw4ubkucj1iqi4a
X-Rspamd-Queue-Id: AA78EC000C
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768027582-886073
X-HE-Meta: U2FsdGVkX1//isySsP99x/p7xbYuBZHnQW3E09uMuD1MnwaFGwylU4+kCzUX79HqIUSxRIXUMi+++GmKAemdyl/8Z3pUnpvHaap0blOdXnaIM7/n1NV8CUIAQmx3zzkqwea2Nv5ZklI1kLM5L2430M4gFum2MyOrTBKFiFaNCecBlWMKwMGjwAcp5Hpy9Psu8efczqkDo94BD5yUMDoU6dfP9GJujXOoQeU3nyOE/jinBHRghK800L6LMJDJk9smz+aISh0ErhncGCPMhIqmOdheEkAoe6D1PlkZWUqPmMPi2WeBa77QbnPGg/baGOBV9Md0s/7WoQiVNorVDnh09dk3dqpY6czpMbXLEJcq9k9STnErup8CaOLDTNu9XGEQw3L5+g36HGSGeFjcMDkZK0MlCAa9A4m57k4u/FX+KB/G23KWsQCG4DmPWYdgDjc2N54tCL06GB3aHKNgxTCf2gol0SUv0JteH2vP0L9eVZXk3G0yNz5mbmVo6G9L17D/Eaczz8scCBr5ng2+5Tp4+qbSCisWOOVQEoXiCHfeoMHvIyVSHIbxrlBumewBjiq9ODI13ckDmkX4qr61rfy9+7XAdLS0cXN9votVTT2hm62huBhSZ5Dpu+TvUAfP64O2jKJO+Baf+sMuqnIfNy8m8P2l2TLgkxgliRHr4AD+1TleZ/qmQ7T2TQWe/mklYEpqwJdl7pU15DmBZQSPZ7YIvk2YvOiE+zTiqAdzrsV06rcUEoSblhOLlnur8RQ5TOpfsw6kpy9w/NXRrhbXAZBpWnDmhIzn9Z0+Y0O7t6hCZnHQ2qU7LmD5Uk31/Hkl8aSY6ullOjD/84TOJPacJIby+w620L68bZ5uI1w/gkNPdK/5CTo6M6iYItpQTrdXtjZ6DzS5S/UOXWPWtxMD/hLJzeu0irXBCW6Yaauygd7/wmj7hD2EToWvkzFu6telJtIH0vcPYFpK2h5k+y3od4y
 V2l5nlVA
 5JnDZJF4R3A881K3AXlAA/pEm+Xvc5TJJGiJKaQI3f1I6t2UdYMAskTC/2QazuwfrhlkT2I6RQVHGh0l6j8rhjMxZgXApvMwz28kriX2QIa5OzOlkBIwceKNgdSVrCYfYOdKeJ9isJSFNesiB1z9w5TIsmeRVXkINNxAII5CflFBtmcjeprueLTc26OhxQRRgR9JqJywS3itXO1mXAPHLKZVuMtQ5AwCSs/+jPbfUBxFumPAEYZIgBCdhio/UDMkgE8RHX0Bgl2kQcNs8l09xha+jLPX5j4/TTcvlYlXUF8FkuqnC3beGOsytoi6nfTkoa0EG7rKV4CaKAxhn9yOHfNOKJiFv49LZIriqofoh7eVh5bjDAzpa54cttF8dPKoTlR9o8SyJX/qEdp04U1QXBoTQ/xKqrRsjjThx2eNxKqD3ZlQpbaQKCnOUx4QU1QqJf1Xu6FL4OZXt5Eg2Xg14qJgfEkWP6XEJ9diXdY/6rnUDdOup/HDwhBolW211OyZWI673Qn4n6QF3RB+8HpzpcPxfdNeFDDvdYjvLkYav7dcWxHmXAeDBkIy6BIlRxHVjw93Tnxzv2mSnXD2hX7/QPkfmb7xu2eaYu4oQ8cLWTCm+tqmuhbwFEx/LVG1wv4BTsCdVJWlqCGFKbtHiwoQ+O0aev1zAqYO5bbEyUy3bfJGzV10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using MADV_PAGEOUT, pages can remain in swapcache with their swap
entries assigned. If MADV_PAGEOUT is called again on these pages, they
reuse the same swap entries, causing memcg1_swapout() to call
swap_cgroup_record() with an already-recorded entry.

The existing code assumes swap entries are always being recorded for the
first time (oldid == 0), triggering VM_BUG_ON when it encounters an
already-recorded entry:

  ------------[ cut here ]------------
  kernel BUG at mm/swap_cgroup.c:78!
  Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
  CPU: 0 UID: 0 PID: 6176 Comm: syz.0.30 Not tainted
  RIP: 0010:swap_cgroup_record+0x19c/0x1c0 mm/swap_cgroup.c:78
  Call Trace:
   memcg1_swapout+0x2fa/0x830 mm/memcontrol-v1.c:623
   __remove_mapping+0xac5/0xe30 mm/vmscan.c:773
   shrink_folio_list+0x2786/0x4f40 mm/vmscan.c:1528
   reclaim_folio_list+0xeb/0x4e0 mm/vmscan.c:2208
   reclaim_pages+0x454/0x520 mm/vmscan.c:2245
   madvise_cold_or_pageout_pte_range+0x19a0/0x1ce0 mm/madvise.c:563
   ...
   do_madvise+0x1bc/0x270 mm/madvise.c:2030
   __do_sys_madvise mm/madvise.c:2039

This bug occurs because pages in swapcache can be targeted by
MADV_PAGEOUT multiple times without being swapped in between. Each time,
the same swap entry is reused, but swap_cgroup_record() expects to only
record new, unused entries.

Fix this by checking if the swap entry already has the correct cgroup ID
recorded before attempting to record it. Use the existing
lookup_swap_cgroup_id() to read the current cgroup ID, and return early
from memcg1_swapout() if the entry is already correctly recorded. Only
call swap_cgroup_record() when the entry needs to be set or updated.

This approach avoids unnecessary atomic operations, reference count
manipulations, and statistics updates when the entry is already correct.

Link: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
Reported-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
Tested-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/memcontrol-v1.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 56d27baf93ab..982cfe5af225 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -614,6 +614,7 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
 	unsigned int nr_entries;
+	unsigned short oldid;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -630,6 +631,16 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
 	if (!memcg)
 		return;
 
+	/*
+	 * Check if this swap entry is already recorded. This can happen
+	 * when MADV_PAGEOUT is called multiple times on pages that remain
+	 * in swapcache, reusing the same swap entries.
+	 */
+	oldid = lookup_swap_cgroup_id(entry);
+	if (oldid == mem_cgroup_id(memcg))
+		return;
+	VM_WARN_ON_ONCE(oldid != 0);
+
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
-- 
2.43.0


