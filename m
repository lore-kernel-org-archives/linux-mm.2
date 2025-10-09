Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F197CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866278E0010; Thu,  9 Oct 2025 03:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8164F8E0002; Thu,  9 Oct 2025 03:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753708E0010; Thu,  9 Oct 2025 03:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 660E28E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:01:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07763160AB5
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:01:04 +0000 (UTC)
X-FDA: 83977678848.08.7FBB71D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8D0BD8001B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:01:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Qs1pKDhn;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759993262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pIOoMBHNJqhZ5/ofJCwBqb0XpdSUUA4WlCEvJNRfdzA=;
	b=mk2TK//0QucvtAzwVe/ObYSiARVoDBtxnYTwJ+i4KYvjaZlAEEXc23Q3DoCrIzPL+2cL/k
	I9zRqAfaY92xYRt3AsCk8i2+zzlT/qi5wyaqlETuGdMD4msBk9gscYlCtnG3cU7jOwon+7
	8Vt2+AsvQGRiuzQOl/r4UvgaxLy/hAI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Qs1pKDhn;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759993262; a=rsa-sha256;
	cv=none;
	b=kMAfch4k9QZ7axnNv2Tl7G/gw1t5roCsjzI+z89SuHL87jqY09J272jl8ttWdEUFLTCeY5
	tTJOAieCW4VvZqBlI/NiQbxUJghnB+rcuIfqQPC4MfptGt00GxXV7cw554c9QO0srtYmVc
	ex2lC2ZCDrtrSAxvW2baJngFsjzBCYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=pI
	OoMBHNJqhZ5/ofJCwBqb0XpdSUUA4WlCEvJNRfdzA=; b=Qs1pKDhnSwbOU7TR/a
	CObdNqoykid8FPCZuyLMJZnprncQxkN/Yw2poc0B/EBhtW37WAWbtJhwJypwcKzc
	e7nch8ng5uTnHGOKR0JplYpoqeySfDFBt6pD/RMZzTJ1mG5oFHatIwxsr+o/HUw2
	GVsIuDJkkhdqHeQ+enp7OQ9a0=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgAnV+CjXedocoQYBg--.7355S2;
	Thu, 09 Oct 2025 15:00:52 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	wangkefeng.wang@huawei.com,
	xu.xin16@zte.com.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH RFC 0/1] mm/ksm: Add recovery mechanism for memory failures
Date: Thu,  9 Oct 2025 15:00:44 +0800
Message-ID: <20251009070045.2011920-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgAnV+CjXedocoQYBg--.7355S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr4DGw1kKr4kKF47uw1UGFg_yoWrJw17pF
	W3Kan3KrW8Ka1fW3WSqw1xC3Wagas5Gr47Kwn7u3y0kr1Ygryvyr4kCr48JF47Gr48Jay5
	J3ykXr9rCa15taUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jRyIUUUUUU=
X-Originating-IP: [112.64.161.44]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbBcwXh+GjnU5rzZAAAs+
X-Rspamd-Queue-Id: 8D0BD8001B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: si7hb1hhngt7i79seb41e5bqa7sq1req
X-HE-Tag: 1759993261-308601
X-HE-Meta: U2FsdGVkX18/BJmMOLbJP9gZged5Trd37Gct0/vK7v0wEkBDMBk6Uweuz46hgAvP67yLuW0UydQ2e2jKo3VrZvToS3QZAzOvlQryaPN1mSUvXPZNsYRN4A/EsFsHw3tSmIplQNOcHwlwR6eqjVl9EgixvwZRsHDRXEWsFNlYWaGUn6Oj0LlxAsQdTcdtvpDphh4IlLlT0S+TM5PDZBaybbGMB6EJKgh7MVNffOMUK1/k4maJGP8fdxcOMe+CJJTVkvhjzluW+1cImctk4LmoOF1i1pjgAeq9bFJZ76iXMOtyv9IRzykTzyxIZI4zYvP1QXjYHsikfwIAN8XF/vgQGTyLvn9Qsh0LOT6QYDLY5OuRKhpe2mvhcI3QxCP/c0qLRMRNnVem1QvXHmEN8JtwrXref/9+5Lp3X+LX22KAMIj1ahzGh9FWdIplUXNYbJ+REFeHhGsPMYyYrOJhaDF7gBgPdCnzVn2ystXv4oIXIN9zntVrYEfe8UY2r4x5KjFnnfx4DCyAwJAeNifbzidI28SjbCOz2d3e2vVsNvKxp+9oS4EUGQChRvm64OhqmNde7DRBRCsPD622X96LP8wnC+TV7x8VmNVgi1S2f7/q0HU2zz4VaS3GbW56n0oFa7oVa2/6unvejSsYYoTOrO4JrCPz97uFAUD9FkAz6odM+uCQAUWbOU/5tyv2aj1RO/pqTUL7HSuIRRT5Pal3K+iGYdcoMPHBM1dKl3/z/g8BArnJq38kIXrGmiSvILEgfxxhI0mIgkwAtORVZTTftRdo0dJZTCPKUom2GXKQx+EjHscNIM2NqvKcWZcvfQWmXtd8tF8tnyukp2goSHgaHcvrlPYdE9k+5VKLLeTgBBIExg7/FxF/B+1VnegzxxPMQRuo8JyEPSquv+aqDZx8Rv1vbnJProfSngbfG3YRT7yN67M8vDtJlSd319/0LmRkGjMt50Xk8tNc9igwG0rUxOv
 aA95rVQr
 uaeh9nu1+yhXBJshdayVm14DBuLQd7h7pSaji1ZdqhZ7d4DSzKwLv1dnmKKfNFtnQynVFrWQWnSqDCMBRzr4G+OHuApAwTjaxRddpuZ9lXms2SzPGWB7y9KONc8bm7qFhdE2+HipMeO7MBp4ng3+F/dgxePpwWoOKI2qRL7/wnaaDUkMKhQdZ7m42yMZLEuO04odYdnqXMeYVxwi3lSlbnUMJpoWGXbhUBxc4TbT8eJBGe4qeI7xJUMfBHjaew+R5AB7gb3I042TqBScdT3crYeAjxFn28V3L7WZK93k4q/g11vCsmYjLrtn1YpBctHCKFK9jBf4nP/5i9CkLQuOUZtOwbJ80/dGHu3QCjcXz6YrWE8ol2Ocl1CZh+k0fXCtJpLLOyiJHrU6vGSxXNdR7DAYkqf1XH4bf0XSmoD06gcuKPP2OIRkSi4JAzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

When a hardware memory error occurs on a KSM page, the current
behavior is to kill all processes mapping that page. This can
be overly aggressive when KSM has multiple duplicate pages in
a chain where other duplicates are still healthy.

This patch introduces a recovery mechanism that attempts to migrate
mappings from the failing page to another healthy duplicate within
the same chain before resorting to killing processes.

The recovery process works as follows:
1. When a memory failure is detected on a KSM page, identify if the
failing node is part of a chain (has duplicates) (maybe add dup_haed
item to save head_node to struct stable_node?, saving searching
the whole stable tree, or other way to find head_node)
2. Search for another healthy duplicate page within the same chain
3. For each process mapping the failing page:
- Update the PTE to point to the healthy duplicate page ( maybe reuse
replace_page?, or split repalce_page into smaller function and use the
common part)
- Migrate the rmap_item to the new stable node
4. If all migrations succeed, remove the failing node from the chain
5. Only kill processes if recovery is impossible or fails

The original idea came from Naoya Horiguchi.
https://lore.kernel.org/all/20230331054243.GB1435482@hori.linux.bs1.fc.nec.co.jp/

I test it with /sys/kernel/debug/hwpoison/corrupt-pfn in qemu-x86_64.
here is my test steps and result:

1. alloc 1024 page with same content and enable KSM to merge
after merge (same phy_addr only print once)
 a. virtual addr = 0x7e4c68a00000  phy_addr =0x10e802000
 b. virtual addr = 0x7e4c68b2c000  phy_addr =0x10e902000
 c. virtual addr = 0x7e4c68c26000  phy_addr =0x10ea02000
 d. virtual addr = 0x7e4c68d20000  phy_addr =0x10eb02000

2. echo 0x10e802 > /sys/kernel/debug/hwpoison/corrupt-pfn
 a. virtual addr = 0x7e4c68a00000  phy_addr =0x10eb02000
 b. virtual addr = 0x7e4c68b2c000  phy_addr =0x10e902000
 c. virtual addr = 0x7e4c68c26000  phy_addr =0x10ea02000
 d. virtual addr = 0x7e4c68d20000  phy_addr =0x10eb02000 (share with a)

3.echo 0x10eb02 > /sys/kernel/debug/hwpoison/corrupt-pfn
 a. virtual addr = 0x7e4c68a00000  phy_addr =0x10ea02000
 b. virtual addr = 0x7e4c68b2c000  phy_addr =0x10e902000
 c. virtual addr = 0x7e4c68c26000  phy_addr =0x10ea02000 (share with a)
 d. virtual addr = 0x7e4c68c58000  phy_addr =0x10ea02000 (share with a)

4.echo 0x10ea02 > /sys/kernel/debug/hwpoison/corrupt-pfn
 a. virtual addr = 0x7e4c68a00000  phy_addr =0x10e902000
 b. virtual addr = 0x7e4c68a32000  phy_addr =0x10e902000(share with a)
 c. virtual addr = 0x7e4c68a64000  phy_addr =0x10e902000(share with a)
 d. virtual addr = 0x7e4c68a96000  phy_addr =0x10e902000(share with a)

5.echo 0x10e902 > /sys/kernel/debug/hwpoison/corrupt-pfn
MCE: Killing ksm_test:531 due to hardware memory corruption fault at 7e4c68a00000

kernel-log:
Injecting memory failure at pfn 0x10e802
Memory failure: 0x10e802: recovery action for dirty LRU page: Recovered
Injecting memory failure at pfn 0x10eb02
Memory failure: 0x10eb02: recovery action for dirty LRU page: Recovered
Injecting memory failure at pfn 0x10ea02
Memory failure: 0x10ea02: recovery action for dirty LRU page: Recovered
Injecting memory failure at pfn 0x10e902
Memory failure: 0x10e902: recovery action for dirty LRU page: Recovered
MCE: Killing ksm_test:531 due to hardware memory corruption fault at 7e4c68a00000

Thanks for review and comments!

Longlong Xia (1):
  mm/ksm: Add recovery mechanism for memory failures

 mm/ksm.c | 183 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 183 insertions(+)

-- 
2.43.0


