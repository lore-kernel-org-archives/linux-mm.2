Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE4C6CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDA66B0088; Mon, 25 May 2026 06:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B55B6B008C; Mon, 25 May 2026 06:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF416B0088; Mon, 25 May 2026 06:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D25C6B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:27:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC30B120155
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:27:49 +0000 (UTC)
X-FDA: 84805566258.21.96AC8AC
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf04.hostedemail.com (Postfix) with ESMTP id 517DC40007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:27:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UBezBnZO;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779704868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7zs3vHYGKN6tx9Lyl/9S2axgS5cDhBPmcJa77N7dro4=;
	b=TP0xhQOme//FFfTISB6etBd49/1nogiJEDS/KKa9FuWosPGlAWJavsm/DQkiFoYFExY7lY
	p32XIaKogTmZ1QjE6EEZ5s1KuaWPhByBvsPzqjSyvCEFm9Fz+66/Psao1GYfeBjWYrzaOm
	mvWOundizjyeeS2mb415G02YIELsi7I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UBezBnZO;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779704868; a=rsa-sha256;
	cv=none;
	b=btVIk7WTIbgJlBrWNBUi6yUQR07X7a6LhYnO0RxBgao1FvWHSHsRR47ovifNIuX0zImTO0
	rwIm7B6LqVSPTg/U6AROb6DREGCAvlbGj30NZ8atkynML6KMqf2/q9hzBGLX8UeeAiAyOX
	kmeYTxYDGoX/WSAyPFdlxGEbClwvbe8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7z
	s3vHYGKN6tx9Lyl/9S2axgS5cDhBPmcJa77N7dro4=; b=UBezBnZOa8TD0sfBDs
	DQxL5wIo1cm1MxJ0Naosk2NSPEfDfFkcEd90g5RQyW2v0VEz6PtnXx9LW7BQVYow
	RGbHV00j4/JAcb1XnR6spTw9rvLAtgSz1z0uPsiC8Wl6OMLTIYcQ771F7Yjp+AXD
	f5nn1lwKTQtF8v/kINUek4V5E=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3V9L2IxRqXqahDg--.22926S2;
	Mon, 25 May 2026 18:27:02 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: leitao@debian.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v4 0/2] refactors thpsize_shmem_enabled_store() and thpsize_shmem_enabled_show()
Date: Mon, 25 May 2026 10:26:58 +0000
Message-ID: <20260525102700.68707-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3V9L2IxRqXqahDg--.22926S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWrZFyfAFy8KrykWr1DGFg_yoWDZrc_XF
	W7tasxGr4UXa1vqFy0vF4UXrWrKr4kWr1jvFy0qFW0y343JwnxCr4DXrWFvw1xWayDCrnr
	GF17X34fXwn2gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_b4S5UUUUU==
X-Originating-IP: [117.176.242.242]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7Ral8WoUI-aPJwAA3s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 517DC40007
X-Stat-Signature: espbhytoct7n3p8thgkyrfms9rgcqndi
X-Rspam-User: 
X-HE-Tag: 1779704866-824174
X-HE-Meta: U2FsdGVkX185/fm0Xq4mp68XGhDWlLqV6wpB2hX3K5pbY6OBX3vT9+gjSYIG4osU+DSDGI3k3MnHRTjwn4KS+ALlgVt3tQ1oY4cS9tRyMEihWeGmJZVl3i/kbEN9jG5ta99cqRU1gayySw5sA2ZHfVvKVFL7ec3iHo4bZDWc5CxqPx19yU4e5QKoDdFW+jwoauj55eSYNcfVuw26Y8EdTUrtAL0Fs6r+HLzRpekgSAU8xS2Yd3mnd9wwvCOJKasQzzY2nWpGGJRsr84NkpIbBZpuUd3EGnJNaKSn8GPBQ0tt6Qg6yfYcUZQPXR7ZC0APpxKsj8qooPUadZfy4T1Ihv+ZadOItjd2qVCm4AtGvbAR2BMTAFLyKKYFoN8sGI0fWQb8wjzAlQktn466f97I/w1MENUOiYoKUOMPufPpjhw6Yh1wddkOKK9XOeKKWFX/z1/bEzlZnev0yAtoHgVqO7M3aoT8KyElMGOKTVOf2q8r4mk6eKSx7AHkTf4LmbdEDCbcds606CGqMzfCwQb3YgnzXokNr9HwQ8I3kGOrLd6oNeT6COa6C1GBM8ShVLqO+SZlCub4igrG+k8w18AdmK1PiFrD5tbOgz7e/096uhpwj2RD21+75GtqoSBVj9wPEgE1C/s0gb/IfMEW+V+UdP7aAcAAepfrBOhDhKwSDk+Cmdpnzq/KxiE0GOTp0Sh5c/xLsyL9lPll9Ia0LyYuVYkNtO0NeU5kyD69UEuTGdEUBJkCwkYAajqELq8qEO+LaJk70CdFcLfU6RCJXmB30qi/ND1W2SzRHIptVcHbNn/n71mQnJPOy4e5Ec5O1so4RFg5DbiWiyoSjEfmk/2ZpxjVjXXAfy2+tFGX800vACTE0UbyLRFVFx7KgOSAIt8Nzyo/PqV8JDMQhEuG9/Ars1y9uOcEsERhW1bDwtjcPkMwV2LtSQnyR4KkNZkseoYPvfi+4R7QWkvbA8p6GUd
 jFN2VcR/
 /1g1ZJGVPZuGT4nbb1AaOyK8ho7jF8Haxc+Hs+s4Z2FqpkJu7Onc8uEiLJKVF+qIhUJ2kP6KokXyd/cssBbm9osTVEG9wQ0qv8PFJCEaHxammNQdw1pgJg2w9rhjHySjxKDkAyW/mIeEzNh67dtmYqAGnPqtQBtYN6jwFA8C4DHkcNDIXoA9quImh9MxWr4jFWRw/zlJ1IUWcuF9abxkVGOxG26/fzG17y/IPSq05CiNzYwz67pdyCLyS9ewJWN+m20xZx79BVWyFoYpAL4YIRf86J//zuzNFZe0FEey/bRfEMm5UJ4SDi0h70keBCQNpYVwH7i3FwWPjEpgF3NYkZOHWphDxNX0BZJf0UDfzgPb5LinxGy0ZSpeW9YOPos2ApRZANnv6nCyg8J7/my+fA/fdm5NFKOnCYcnXEiqUWWfFjKsiZY7a2YOvCIP3baeZlaEc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

This is v4 of the refactor of thpsize_shmem_enabled_store() and
thpsize_shmem_enabled_show() series.

Changes since v3:
 - Simplified verbose variable names to huge_mode, huge_mode_strings, huge_mode_orders
   as suggested by Lorenzo and Baolin.
 - Add Reviewed-by and Tested-by tags.

Changes since v2:
 - Fix subject prefix to "mm: shmem:" as suggested by Baolin.
 - Some changes according to Lorenzo's comments:
   - Add cover letter and fix threading.
   - Add THP maintainers to the cc list.
   - Document the behavioral change regarding start_stop_khugepaged() in commit message.
   - Improve single letter variable names.
   - Simplify error handling and return values.

Ran Xiaokai (2):
  mm: shmem: refactor thpsize_shmem_enabled_store() with
    sysfs_match_string()
  mm: shmem: refactor thpsize_shmem_enabled_show() with helper arrays

 mm/shmem.c | 143 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 83 insertions(+), 60 deletions(-)

-- 
2.25.1



