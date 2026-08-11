Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23517C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16AA86B007B; Tue, 11 Aug 2026 03:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142006B0092; Tue, 11 Aug 2026 03:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F616B0093; Tue, 11 Aug 2026 03:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC6486B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:34:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DFC880353
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:34:12 +0000 (UTC)
X-FDA: 85088175144.25.72A3534
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2D9D4180012
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:34:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FvV6vGCU;
	spf=pass (imf06.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786433650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M4X/pEDEhzJriqH/Dn3z9EQyrzergLRc+6vzfSJPFlQ=;
	b=R1Xcux3iHv5vj7wEdJPTj/WRd95goiG7CSMKXSHDXiFNpGXe++qibm549Yoq9LF6xB/q6S
	XiH6s44bqi3AHyRLxH+Elzi3hoRRlyrsBOVWgTUtIx8D0uHXM5OXmQQEJZ/gR2Z8qpWRUx
	2oFAhFztR9a4Y1tQ8LRtEzQqP9C1w7s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FvV6vGCU;
	spf=pass (imf06.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786433650;
	b=x8smQddtChged6mtbQ1YPJJ5+xQe0sKGG4YTB7GRf95i/pCBm7YxmZKbLZl8fUxWFxKa0W
	/DxUJZ6gpSf+9s2auME7yVyNGJLHPOKb4gxL0FGALiXEf1JPYAX6wXPdxl+bpQOCNR2+co
	tuSx7FrLvyUWF0ulbs9HKuZya8yq144=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=M4
	X/pEDEhzJriqH/Dn3z9EQyrzergLRc+6vzfSJPFlQ=; b=FvV6vGCUbpByJVYo7Q
	imuR0kRpyhtDLcOFTVCAZA0ZoHCkMdKMdo6wC3GiJxHeLWtWsixuNUhTrxT0bjBp
	5CYns4Of2WWyc/m1WDKEy53WaK1DdoYAx1r2i6oa6z/E/DPQ/YgC9KYXP5Yltc6T
	E+HE0hmX+50l6T/kmoe+H6dHk=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wAH3+lM0HpqmAU8NA--.183S2;
	Tue, 11 Aug 2026 15:33:35 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: ryabinin.a.a@gmail.com
Cc: glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Su <sh_def@163.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] kasan: fix quarantine_size accounting during cache removal
Date: Tue, 11 Aug 2026 15:33:32 +0800
Message-ID: <20260811073332.1351893-1-sh_def@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAH3+lM0HpqmAU8NA--.183S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFW3Wr1fuF4kXF45XrykGrg_yoW5JF1DpF
	1UJFnxCw1kJryxGr1UG3W5Wr1rWFZ8Jas8A3y8WrsayF1rG3W2qryrtryjvayYyws5XF4q
	qa4DGr1Fkr98CaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-Originating-IP: [183.192.100.171]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6RCB4Gp60FCanQAA3P
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D9D4180012
X-Stat-Signature: hxtuixahj6gewcequn8fmxyy9p3jgt9x
X-HE-Tag: 1786433647-794891
X-HE-Meta: U2FsdGVkX18n7tKcwB7F9lvc1JGX2pCPeXKdft84L9wkV6cRxgQqjdq3WGPZpa0rqqEMdkiDUlM+v4F1fFmi+oE9VDAPtMyAhePWYFhoAsHaRZdKtFhIYECf6Wq67zDAJj0mqlj2tpbgN1Ch4QEeK70wahwrkkl9fxCLKP4bUPtpIDUq1GRVqZjswj46BQXCohUrIovOSVPU41PfQ17uOQONaQlYDHB7iiAt26RUq9pccxR3a97Eu2AwdrfLE2Meod+/gluhqS9GmGHI0IrjfyiDLT9bXFuv1kO8v4ymETjAUNwV4XTtxpMlo2P63MHAPQ5q73aZsF334+4vpA7vQWygucTjfBQ+Yzb8atdNPm1eOx/8BOND+jSn6qKVgqNSBbEEGbccv3GhSd15y0KjiJEYCSuMr8B3EayITlv2fLPQNExtOrZSgmWFhYjXr5bRAFsQd1PmE5p19Saq8Yh8oqL+ArPMBJwIJNJa15ieJRtq5aljC6dMTu7jrkR5MGgTc6BdoAOgwI4wLT3vD7K/SqBVdEjZRTzNlXXAfOVjJZpjaeZajrGSkcBblUOZfnQ5VqxwcWyEP3zolQMSAFQMS4YJ2MgCRFr1B4cLizmJLFn/+vl5wRETy10y+Tjm9753CEz1iz2llfA7eVkPxf/hhUS0aABbjBNsLfsFFpFCHvYHwenWPsxX57YWKzc5cBpDhDbrNWMrkM61P14fbK7ok6PV+FHnXSNQnXD1Bt3ecTHUdVrb0mSDbCIfoMLFPNiXKPnqYbFWnUSnwMJKqc8wkx5u7cE1IRDkDbnU7gNIKqrp0Gy2ASFRvdqmGVWd0v+qmwz4eRLL+xVbWowBQ3MwnV+VR/+A2Rwv8c0YCbBqVFil+6BHklLltS9rMsJ4YeJ/DetSWhL4gf5fNkWI//5rT11rppu6E07NLgK5h0twaHmeBxZQ671HVy049FhQNcfiz2p8zbniQw+l2++5lZ3
 3rzFIMl7
 UaB/U7hRCEa1dg1g4qj+gR3vub6zwzXKVZZreXIVKT4GdiYrCdiy41MNTGUaNfO/dUv4oM1SeDyC9wTARzAkz82oCIOUjlB/t/tzCNdRDnLsbvEw7zONdkofQrHVMLlMVa1Dj0ikbnZs5Qr2v1ZFUb0lpSV9zGW6e8TSjm8mZgswqhLose2XUL1avAw6NzItBozqPNUh6Uqr7v5R42V0qN5DDOALOoHeIgQwNdqBeAxum1iCdlAKLDvGpMVSI7jE5QgYdkyqNNye8xjqs0PlwE7tC5zDkKRMkz0TcJC8X45SVX3F2u3/CwQaKh2OOqaf7Vl/6bldm6/6QZLWdVaiAlb+bflUMUky2JBLCvxoyh8mDgGtYCZaLjviWtbpL37Ped51ESXl+ppMKUjb2q4W37x3NvQ9rT2npv7wyFljzWBs5EF5z1/CrJDNcQTuh36/Dd2+ODTO3gnFY3gOSHNmbqf0SYJ5uDwEsbBvEXB44eooYVTJqVnPJX4xxMPQ23cSsUAYSJIaUiOrKx9OenHiOiPxODm649/Kjnro5zJggfK4vWQpzPfLM7YT4mNUfLJ0rM9QEe66023NPJUToeBb/4Kif6ez/DC/gTSVI97wadDNmKEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

quarantine_size tracks the total number of bytes stored in
global_quarantine[]. It is incremented when per-CPU quarantine objects
are moved into the global quarantine and decremented when a global
batch is evicted by kasan_quarantine_reduce().

kasan_quarantine_remove_cache() also removes objects from the global
quarantine. qlist_move_cache() rebuilds the source batch and updates
its .bytes field, but quarantine_size is not adjusted accordingly.

As a result, quarantine_size remains over-counted by the size of the
removed objects. The stale accounting accumulates across cache removals.
Once the inflated value exceeds quarantine_max_size,
kasan_quarantine_reduce() can evict a batch even though the actual
number of bytes in global_quarantine[] is still below
quarantine_max_size, shortening the quarantine window.

Fix the accounting by recording each batch's size before
qlist_move_cache() and subtracting the number of bytes actually removed
from quarantine_size while holding quarantine_lock.

A KUnit reproducer used during testing observed the over-count grow by
4698864 bytes after one kasan_quarantine_remove_cache() call with the
fix reverted. With this change applied, the over-count did not grow.

Fixes: 64abdcb24351 ("kasan: eliminate long stalls during quarantine reduction")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260808031459.3032812-1-sh_def%40163.com
Signed-off-by: Hui Su <sh_def@163.com>
---
 mm/kasan/quarantine.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 6958aa713c67..c220f0d8ddd0 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -365,9 +365,14 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
 
 	raw_spin_lock_irqsave(&quarantine_lock, flags);
 	for (i = 0; i < QUARANTINE_BATCHES; i++) {
+		size_t old_bytes;
+
 		if (qlist_empty(&global_quarantine[i]))
 			continue;
+		old_bytes = global_quarantine[i].bytes;
 		qlist_move_cache(&global_quarantine[i], &to_free, cache);
+		WRITE_ONCE(quarantine_size, quarantine_size -
+			   (old_bytes - global_quarantine[i].bytes));
 		/* Scanning whole quarantine can take a while. */
 		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
 		cond_resched();

base-commit: d58772d8520c7ef247c4b95c9bd76d3a25da9ff5
-- 
2.43.0


