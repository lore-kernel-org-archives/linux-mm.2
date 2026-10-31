Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD42606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 03:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=fgNvs0zJ
Received: by kanga.kvack.org (Postfix)
	id 0AB886B00EF; Fri, 30 Oct 2026 23:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B756B05B1; Fri, 30 Oct 2026 23:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CF66B05B2; Fri, 30 Oct 2026 23:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22386B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:40:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 329BE807C1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:40:20 +0000 (UTC)
X-FDA: 85381518600.13.BD7E171
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf31.hostedemail.com (Postfix) with ESMTP id C634F20002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 03:40:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fgNvs0zJ;
	spf=pass (imf31.hostedemail.com: domain of xiqi5703@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xiqi5703@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793418018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3dxr/8PguZyVf6pN+W3kq1oumxAvIQqUFP4HyBpPUZE=;
	b=Y9YI4VfzIw/QggKT6eQ7HkonO7brKzUKc4tSfrDHlrLXBU9fmCk/Cw4sbT4tjSQv4gseVb
	yaEE5zXTbzDi1MpV6+y4iwmQB7jKXOWoVDAeIjewLhwVSHxcU32F4G4femIDbd27bbLZl4
	rL+X2lfwSAR+I24Z5D7OiynCJQfylxc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fgNvs0zJ;
	spf=pass (imf31.hostedemail.com: domain of xiqi5703@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xiqi5703@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793418018;
	b=RcuBbVSub7SVyBnDmG0rFJu3pcI/DNHQDtWZeAicSxcG5NFpE8yddkaMotnCyOciB7jPbY
	K5jT7ej9wNlA/kBPJrIIp2ebYHXN4btiyyYzvOsPUTQazkvpgfbwneVbTg0yywyG7ul+AW
	Qg0dbM9MdFb3ga44O+8eaj9inlRQtFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=3d
	xr/8PguZyVf6pN+W3kq1oumxAvIQqUFP4HyBpPUZE=; b=fgNvs0zJrvIGtohxFr
	CsL6UX4hjr80NCesA+JgmEZRg2u2FGK907w/Kbh2pc/7ZrI7bmyzrzy6sIVnSe5x
	0fmlxlYj3X/9RYw3ozXlT5vbmtqzDfdOpKhe5jW96DjY4kisxKSRAuvRAikWvRSi
	fiHftYjjNihkJoe8/kTbzYCTw=
Received: from mm (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3fxX7YuVqwv03EA--.41986S2;
	Sat, 31 Oct 2026 11:39:46 +0800 (CST)
From: Qi Xi <xiqi5703@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	sunnanyong@huawei.com,
	xiqi2@huawei.com
Subject: [PATCH] mm/migrate: fix softlockup in do_pages_stat() with huge page arrays
Date: Sat, 31 Oct 2026 11:33:30 +0800
Message-ID: <20261031033330.3416326-1-xiqi5703@163.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3fxX7YuVqwv03EA--.41986S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw43uFykCr48tr48Wr4UJwb_yoWDWwb_Zw
	4rKr1xCr4kXF1IyF9xAws3X3W3ta48GFWDAw4jqrW7AFy8AFyvqFW0vF98WryDZFZrCFZ0
	kwn2qw4q9r9YkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0YLvJUUUUU==
X-CM-SenderInfo: 50ltxkqxqtqiywtou0bp/xtbC7QLsI2rlYwJtqQAA3K
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C634F20002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oyaq5g34xw9qxorxn7r1sqnuh8ugcnpz
X-HE-Tag: 1793418017-769175
X-HE-Meta: U2FsdGVkX1+khrEAKoOJwmOIQXiC7KSYM9Uws5rrZM9gTZQsEjCv282qFsKyS25al/Rhy05cjW0K9p8+k03noPVTjBMxjMK9ni0dSK/qjLaP1xJK2wrdPR0pzhkVu3w6AbweyBBHIGKP0VRaOf21izzFA7sG3VHUYfIiIaDzA2K3FZzk/iuZftneBJ2HXEr49/E8EAoDZxbjuZcCWVdoClQelsC/PvUwFF0TJu2fdbQkEc8v9086InA0lZO/DCPwMMYLF9tIF5Dr8kqWDpDZ6M73VMXWelIJyT8Oe8Ri2XNAxG9DZRxWp3LTd2XtsXscGcDJRqgZ3wfMSnIxr6tcS463lSZ7w6CcwuBeRgvVy4/KYvXnMNkbsb7qgnTH5k0LGkb28ZG9PEsgeZmKoiWhZGI+PKo3GAa6DYLyzzefYArwF28ubmbddrFiU/Fh2gy7Vh2uDe/uyNTIHwkD9Y+VJx0LCM/F2k6cjrk8rF46OI+jBXM3eVoPTjVmncZwQHEmBMLXbJPuNBX6K7IawGmSGDN54RiQHTgqn51EOcYFd1X9eLBxXNyPXArbchcq7mdqhXEax9SkCCfQBMmcKSb7GRXCUhHiFWn1baNhLlLmythEoc6ZyNn4tEPA99KEvASh2Ce7VVwbaQqGGFKYxOC2p8EZDBMPG04aKcnbw65prSmQ/eshklZDelflGx148kBDMA7eqQuInm7VaAKJLWoOgOGv2np9TCqsLYhbwgXQuh6Rb7tjFuTZBLJBzqKTZiPWXzYrLBLQy9oVOb5ghLTkehQrqJblTpOqMp9R5wkc80BvCEUoEbtx7kKjd2o+X86NayZJL8Bh+UVrGKBIypzcZY+KOkiWHb3/U/VgOqeQlaYYtmOC782mvzP1cVAYpF5khDRGfS+mFRqYmo7wst+iiFfqus+UYI55FDw7FesvL2WfU7Qlooqwpgx6Mn9RSgJu4U4MTVz4Cxj39gbw7xp
 q9was8o+
 KXieJ/hIP8KEsOJRn2DOC+9dTczLIHVTFvM9j1Tt3JWB2s3PkJk4uy9rA1Q0ox/F1yaYDGeR8UWVwtshX7kXkE93APNQY0GTbr9wrkBPuD0F06yPTSosvMaW70RYOcbOdFir+EOj0soQ10h83eKLZ5wshrZT5RPuNJL9luxMqeDdhcZfUqSUmJcED5HaLlft/ylRmAJ3E23PDaEfW0rrJEfeBG4ImRMyHx3RzEMBfYeBjTHs5usMlz4jZaJjkeaS293TsyyS7XArPO9DAdahzNsPl6sr5Py4+nWL5dTu5PEMsR71If1F0d6KqCgohznAu0EgkuvOnbDzTBot672/qQAwS/pczkwWEgHxHDbiSug5nwpvM8eSkZElGBAkH59ehiEd1xc044KSfxavcXRouuu6/rugJ/KItuwR1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Xi <xiqi2@huawei.com>

do_pages_stat() walks the user page array in 16-page chunks but never
reschedules, so a huge nr_pages can hold a CPU past the watchdog
threshold on non-preemptible kernels. Add cond_resched() to the loop so
long move_pages() node-query calls yield periodically.

With KASAN and function tracing enabled, a move_pages() node query
(nodes == NULL) over 10 million page entries (~40GB) can trigger the
softlockup on a PREEMPT_NONE kernel.

Fixes: 80bba1290ab5 ("mm: no get_user/put_user while holding mmap_sem in do_pages_stat?")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 mm/migrate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..6c2371020cc5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2545,6 +2545,7 @@ static int do_pages_stat(struct mm_struct *mm, unsigned long nr_pages,
 
 		chunk_offset += chunk_nr;
 		nr_pages -= chunk_nr;
+		cond_resched();
 	}
 	return nr_pages ? -EFAULT : 0;
 }
-- 
2.53.0


