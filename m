Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D39606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=L1aw4Yxh
Received: by kanga.kvack.org (Postfix)
	id E47376B05B9; Fri, 27 Nov 2026 03:28:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F6C6B05BA; Fri, 27 Nov 2026 03:28:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34996B05BB; Fri, 27 Nov 2026 03:28:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4C4C6B05B9
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:28:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E693EA7699
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:17 +0000 (UTC)
X-FDA: 85480221834.02.0A48B26
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id C155B80004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=L1aw4Yxh;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf02.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.9 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795768096;
	b=xcmhhNA2qHfYN39Lv2ZiyICkMbrENU9Un07SPmz1+z4TlMm7hlF98AteX+j1OVIcBeiP4B
	h3DfBEaEivWxBNIJ63vadAxfnFetATSUGtRfZMMSu4uC82MHyHBUqwbV5TyOKaskz8MVG4
	0YWBGGK5gP4iddjFNzP7oLTRckPEiUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795768096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mc1AjUFz08l5NWa5nSsq48XQe3osLZopmAouGxSLMYs=;
	b=kn2XudMXKtP2zrcmZcVkN0PkpIKI1AKXRKz0kZvnIE9xYi0A9efAc8Q6UKW4WOn9yOMN6g
	3wgfOpteZqcpJWox5a+id3MoyJzsK97krh9yqQnwo1zLnp0aL/RBBL9EzuLNBXO0C5Lyy1
	4FuxVbC4BkVSvU6UDf8tGxLFnLHZexs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=L1aw4Yxh;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf02.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.9 as permitted sender) smtp.mailfrom=nzzhao@126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=mc
	1AjUFz08l5NWa5nSsq48XQe3osLZopmAouGxSLMYs=; b=L1aw4Yxh705ARFxiJM
	L3FHnFN2FHrn27dS0jGDazV8PaUiFx5OtOhnnG5BB2E+/TzSRwcRMhVkhBAtAbjD
	4ENm/cSy7u4dmNR/MaXDoUIvTj0jaobtFbxcbYGdGA2CRDeJnHMlMQjtHmLj+QhQ
	rB9k+5nzhmPsp7nNTmOwCYb5M=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3n8ToPglrpDfcDA--.16205S2;
	Fri, 27 Nov 2026 16:27:21 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: sashiko-bot@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo56@xiaomi.com>,
	sashiko-reviews@lists.linux.dev
Subject: Re: [RFC PATCH v4 2/4] zram: support compression at the granularity of multi-pages
Date: Fri, 27 Nov 2026 16:27:17 +0800
Message-ID: <20261127082719.3624596-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-216089@kernel.org>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com> <20261115024455.1465726-3-zhaonanzhe@xiaomi.com> <sashiko-outbox-216089@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3n8ToPglrpDfcDA--.16205S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr1ftry3tr43Wr4DZw18Zrb_yoW8KF4xpF
	WrKayFyFykJry5urn2va18Zryjk3yxGay7ZryrtryxWF1rJFy2qFy2ya1rZa4UArs7ZrZI
	qa1Fy3y8A3yqv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UkGYLUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBsQnmtmsJPulG7gAA31
X-Rspam-User:
X-Stat-Signature: fyjjdj4oz4hihd3qdo8bztznwhsh7oqs
X-Rspamd-Queue-Id: C155B80004
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam: Yes
X-HE-Tag: 1795768094-339458
X-HE-Meta: U2FsdGVkX1/wr29y9No93Gr+CUuika0ekQZbLEjgP2SwkkGP5wd0OQDF+KQZBnljNUyGRd1HZg8DubhLSLYHK+eBgLRwLLVVfiMCzvapgXJpyQwKv78J6G04btZHeVyODcpuoyONlPKyCIa3KOB6KEGXaLnav6XUXpJdmdgEwyAMOHjTmYrhKgLu5pufe5hTPs320/R9kFoyzsfaciUV7SXCmGKhOKbwJbNvs9N92hZ39lfPwdG5T/1z248isgOIHC+HwgpNJcDT+g+bmo2cJCV79pjPgcV3KlJv3P8YmLg1bT4th+J2WHfqJVUezVgqF32Vp5DU2HQETqc7KzxZWvV6S56ZpE3jeodNVbSUZFbdr3UiGF5ZeWtFbGwoCUZXR5g66fDYe5wJXBbQeLEMkGg9VlNP7E9Hcq9xd7T4x4RoMCerD6ZTZSSYrrN/hEbquKOglh8Fc5ufJvraFvHUTHN2/pB4gTdEwD6ZezQ8wID0NX7o+uIITHEagm8UnuQFL2u9HHAgo0PMooqtpeUZvW5h+PruFl3q+v+1wTTePyItPmxvcdYel2Mrc7Abh383nmd8uyayA/bRs4zdJQQM5093lbpRon8rggR+uJ8tGOZi1uIs9uFBhXWfbGcBRRjheuuJCw3oltph6ucdXMFopNuUynn26YK5dRn1awKG5o2G84UsD+mX8xuwknvVwpiwUq5094ZN9fDygSp0kM6A73a94t5zIrbgVrLtTCLB6JWsUu1eUiGqoZS+H++R4s+D0lTDy72mQRUxee6dnlRX0AtGeTxh19IHJTOFWocxAy3VBQnYAG7PCmy1yxI0ci/mp9LFnoijKh2qnSHBeYA1QHkcVC+HpaZduRJJlZm90TQSLndQVriT7BJE7MNLPbjjy2gQBVtkfsuTgp1jGo+vKFAsj5ye8J88SM5kTTRUtD4g6OnT022qIby/cykgpn5Crr0OG22geRkqkkoJxJm
 skUgqI7X
 7o4sVSOYH/+L/LtpnGPBcYc97qvXN9hhmmTvRTV0bHH4JtRunbu6sYluafEb5eH8Y9LvB7ajitm+Zn39plIZvmRr91ZDCvqRErUMIXwhYzX52gc+vpta7bi9Lmh0fruXWBhk/CvDkRGHxsyTA0eIQdkWrJNwKMHQK/LE5ziZQRrddhBWdaokpRz/RffTg10NYdbJJYq9Efsb8NxnfbnuazJmqD6/r8y5Y84c7hrJuPl9bAcloPpcPBx9TXb9mTwyN6xZxqXsNmSBuZ9NQcE6K50Lj9f5IOeKSMGRve6fuaoW3e/AQX3/656jddrqkH+gy1zrkNGV0SZpwDJuewTYXwGNJUu8Yrkc7tmgRYX7Jak0MfG3pVb4vEQ3izOaHxx6Y6CQSlXdVxPEmFK+g6o53QNNmC9vvasa2jz93CW9RtqJob+2i+VF32A+1JWk3VBY/jn67R3mqHmIVuxIHhoZngXSBRTXP2ECE7Uz5n4bo0G29icM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: High]
> Can concurrent zram_slot_free_notify() calls on sibling sub-slots leak the
> multi-page object?
>
> __test_multi_pages_comp() counts ZRAM_COMP_MULTI_PAGES across the group
> while only holding slot_trylock(zram, index) on the current sub-slot:
> ...
> In addition, when comp_count == 1, clearing ZRAM_COMP_MULTI_PAGES and
> unlocking index before slot_trylock(zram, head) means that if
> slot_trylock(zram, head) fails, the last ZRAM_COMP_MULTI_PAGES flag has
> already been cleared, and another CPU can also reallocate and write to
> head in the unlocked window before slot_trylock(zram, head) runs.

These are valid issues. The locking and lifecycle model for compound slots in
v4 had inconsistent semantics between slot_free() and slot_free_notify(), and
lacked a unified locking boundary across sub-slots. I will redesign the
concurrency model for multi-page slots in the next RFC version.

> [Severity: High]
> Does setting ZRAM_COMP_MULTI_PAGES on index + 1 .. index + nr_pages - 1
> without locking or freeing those tail slots corrupt the slot bit-lock and
> leak existing objects?
>
> zram_write_page(), write_same_filled_page(), and
> write_incompressible_page() only lock and call slot_free() on the head
> slot index:
>
> 1. Because table[index + i].attr.flags aliases table[index + i].__lock,
>    the unlocked non-atomic |= in set_slot_flag(zram, index + i, ...) races
>    with concurrent slot_lock() / slot_unlock() on tail slots and can
>    corrupt ZRAM_ENTRY_LOCK_BIT, hanging waiters in wait_on_bit_lock().
> 2. Any single-page zsmalloc handles already stored in the tail slots are
>    never freed before ZRAM_COMP_MULTI_PAGES is set on them, leaking those
>    objects.

Same here.

> [Severity: High]
> Can two concurrent partial writes to different sub-slots in the same
> multi-page group overwrite each other?
>
> zram_read_page_size() unlocks slot_lock(zram, index) after reading the
> multi-page into the temporary page, and zram_write_page() only re-acquires
> slot_lock(zram, index) after compressing the updated buffer.  If two CPUs
> concurrently perform partial writes to different offsets of the same head
> index, both read the old multi-page before either writes back, so the
> second writer overwrites the first writer's sub-page with stale data.

Same here.


