Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7178ECCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3538E0031; Tue, 30 Sep 2025 02:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92898E0002; Tue, 30 Sep 2025 02:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81428E0031; Tue, 30 Sep 2025 02:39:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0F288E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:39:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5601211A775
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:39:06 +0000 (UTC)
X-FDA: 83944964292.08.5680A9C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id AF8714000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:39:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Ktymnz/w";
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+ADYZgQxqjML4TSvzcJwM4PJN4DmwLuvNdowvW8LHNg=;
	b=O/yZG2g0x/5MJw8ssNwTG1MmjS/vbL5080m+ACq3w8wXYrzZs7bLro1YPN6Hg0Z1RyNib5
	QCxb1RbeHDZfA0+Y1kDWJRC8yEBI3hVEnpcbBk+EZA8Jxn3K9WJ5XjGW9fDfGc6G8ahGlr
	sI0uG6FAS2tmISDJR9oWewWXKPk9GDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214344; a=rsa-sha256;
	cv=none;
	b=2DPwz9mX46O8bXHJHokK6J6YaFG3gMWXAzpWg5QQcdNVSlsg8rzdAFNWvgng6zYqpmQPa3
	qnACyX/KaJFXP57V66z+zMryViUxNCoKPNjpFlFNb2FMdeQeJOoOWQdMdIQE69+cxeM9Uy
	qd4OiI1LnQalZCoWHvu0/vDdLNY8E6E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Ktymnz/w";
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=+A
	DYZgQxqjML4TSvzcJwM4PJN4DmwLuvNdowvW8LHNg=; b=Ktymnz/wrmiLNEMW4a
	imQFqoYYWuJQhq+stRLqOF6FcuM9my0vSQznURViXuoIa4WiXX4IxjikbqBlFx4+
	kUM6yRAYNBKErj6mNPKJWHXWMfx9lVZdHv1/spXkNXL7xF8QHGcBgv50XFxupI6f
	bFuJgCJcfapB19tbTVkVZ+J/M=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDX5V3qetto_xZ6BA--.4290S2;
	Tue, 30 Sep 2025 14:38:35 +0800 (CST)
From: ranxiaokai627@163.com
To: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	ast@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH] slab: Add allow_spin check to eliminate kmemleak warnings
Date: Tue, 30 Sep 2025 06:38:31 +0000
Message-ID: <20250930063831.782815-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX5V3qetto_xZ6BA--.4290S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFyrCryUKr4kGFyDAFWrZrb_yoW8XF4fpF
	1rJ345ArZ8Xr1Ykr4YyF92kr1Uua98W3y8JFyxWr1S9a13JwnrKF98trWS9r13AFW0k3WD
	Z3ZYvFW5Xry5taUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pin2-UUUUUU=
X-Originating-IP: [117.176.243.111]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/1tbiOxLYTGjbcuTiWQAAsj
X-Stat-Signature: 1go9s9z81rxybpwwi7wmb3y56i4j5swm
X-Rspamd-Queue-Id: AF8714000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759214343-559542
X-HE-Meta: U2FsdGVkX1+BL7yT3/jsUxVuwMgPAvp1OfE0g+WbDKWph0Lat5uP1Tm0qAO9xOzl0wpxb5KYvlUb+G3UezQAoB+Bo598snaKK9iNMfGqH4g8j+y/gq90WSiOFCOjXLs8HDGguo55y8mhFWoNgpu7JambC23XdQuOLakNlxXR0d+OUox+i59mBdWYBXuniY05nILAsD+EarXdPvBBnI2Mp8RJESHBCOigMxx4oK00c44JlOr/LMiMIX1MTQKjxTCMXgOrqyj8RUieB79Cr4HVNbpsEPBkf5fqA6O3m0nAvxAYFS5B8I6vlmgs9qldQJuFFIaiJSJ7xl/BkHpEz2WAO3tys2jUhpxqbgzlFX4HAs6Z1OAvKeC9xdFaGvloFpJ5/PSU3lX4HATCLB9VrC2olP1S/vkeN/hEwMjpYKR6d6XKNQTyXKzHakR590SHb8acK9HTGNlFeeI51EkvTZU25G9mBF/SHPEf4Nh5Ua1ObTkxtwXheMQ/LuUa41Ad2jkUg6KGLCXwXp0CkN/K1Gude3eVvncV897y654UICQBZHLV3bT5D6Zeq2AJd5M7IxwvTX4bAAuyIf5Qf1l1XTrhwZFEUaIapKVEBpzyXlSrjBt7P3/NMp0wGwyvwlmGNipHWcDGDmWhU44z/FHvUfe33ItLuqC3cYzEpp36lAx8XPorD+rrqdZhEb/RQD5onlp4EgRl2SB12PggrwKXn9BxsphcoOvZIavjFAiiMTSOoWxleEYetbSUMG5ya7fG6lzfF7ScgDc5agToyt1Ggwi7wIY/uq7TiFyBrUHIex+zbgk8gNSxlfPVJnPgEVAo1D3MFSwnD1zmg9wUQyUZrc00fgVwbhe9HgqTYiZS+gXyxL00vyARENs2WHBsA3K6MrLeQ1r8c6Ulc67FlgRSl/UXlx35rP99Uxic+WR8zcOPtuIpQ1KKPCdRE5KYP4nWrnjOojmvWqTWnhkBu+KbJLV
 zloUdCP9
 FrZtwR/eg3lqHae+O1/4ot04bwJz9EX+ke7b+rYxaOamO4PiFCJ4S7xOeYq3zopLlUMicxiRe1lBJDyYjzQ+YdFJO41tdHPLt27t5JyCR4mV/cOKI4tLvnajPq9bLyVUoe2v0gFGvcsp98UK076Y5iHBCnEeVqvfGy3hZGoqj2EzfQ9LWIWFX2Wcke6K2qQ241TILL9YZKr9tDzzpm5xl+1pU+PXgR7TnTyxtI+5YYcvZCYoM3oOrSlCxM8NR6/QkjHaxTE4xef9Zq4xmCqrw+mjubpzyAsnmLwMtoabfV046Gz/fW/g8icA7v7xg4H0yblmMTR/r9esRnHPIm06kcTlgdEC4GVbV+fY69CgQcUj9sUSB8xRSTECC4f7aCZUW9hAaoNrGPGtEBpjvtu0WwTzECw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

In slab_post_alloc_hook(), kmemleak check is skipped when
gfpflags_allow_spinning() returns false since commit 13d872ade8be
("slab: Introduce kmalloc_nolock() and kfree_nolock().").
Therefore, unconditionally calling kmemleak_not_leak() in
alloc_slab_obj_exts() would trigger the following warning:

kmemleak: Trying to color unknown object at 0xffff8881057f5000 as Grey
Call Trace:
 alloc_slab_obj_exts+0x1b5/0x370
 __alloc_tagging_slab_alloc_hook+0x9f/0x2d0
 __kmalloc_cache_noprof+0x1c4/0x5c0
 __set_page_owner+0x10d/0x1c0
 post_alloc_hook+0x84/0xf0
 get_page_from_freelist+0x73b/0x1380
 __alloc_frozen_pages_noprof+0x110/0x2c0
 alloc_pages_mpol+0x44/0x140
 alloc_slab_page+0xac/0x150
 allocate_slab+0x78/0x3a0
 ___slab_alloc+0x76b/0xed0
 __slab_alloc.constprop.0+0x5a/0xb0

Add the allow_spin check in alloc_slab_obj_exts() to
eliminate the above warning.

Fixes: 13d872ade8be ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/slub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 09cbe580842c..a76275f4870a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2145,7 +2145,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return 0;
 	}
 
-	kmemleak_not_leak(vec);
+	if (allow_spin)
+		kmemleak_not_leak(vec);
 	return 0;
 }
 
-- 
2.25.1


