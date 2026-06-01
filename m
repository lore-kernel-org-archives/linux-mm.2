Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2ACCD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EBDE6B02A6; Mon,  1 Jun 2026 03:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4C76B02A7; Mon,  1 Jun 2026 03:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2004D6B02A8; Mon,  1 Jun 2026 03:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FB956B02A6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:44:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB74B1C0A15
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:44:33 +0000 (UTC)
X-FDA: 84830556426.10.7D8E538
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf22.hostedemail.com (Postfix) with ESMTP id D098EC0007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:44:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=lKGH9+qz;
	spf=pass (imf22.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780299871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ea62rNturdRY4XhPqvTtukJW98iV/DZwMOLJ/F5D8vs=;
	b=czGjfC7xHhYNzAHOMDYS2jz5BCREHA7ttWuIse4n6sIPDBEVlCjfpFronhzyN/HBa2L798
	V+wIpDbz3OtrgbQxJlExOQIFrwcyTebu3T6QBo/d4RsVSl6HBY8LGtuiJhM+FLlF9AoEr5
	g4LDWcod8BJAsmdgSgufGcJ2/MUPjDU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=lKGH9+qz;
	spf=pass (imf22.hostedemail.com: domain of niecheng1@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780299871; a=rsa-sha256;
	cv=none;
	b=vZpXZZYMp/46ZyLQmP4sQFwCLr7EbTOG2k5lifVXCWyjJbBvL37bhohJm+bDJ126QeV4Vf
	wEc4/CHBIJTDfhy7jvc9lVdpoiZ87fGvE5Zgw36ZGuB9t7SRSeghwzgfqx69VtQqTWqQkD
	5JCpZaIP6RKeoBOs8LPVicdYO0hD88E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780299863;
	bh=ea62rNturdRY4XhPqvTtukJW98iV/DZwMOLJ/F5D8vs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=lKGH9+qzxR6BqKgQYyWPDZB4GRKf6naO2Xjo6aYm6KoVPkdOX6us8OO4Wc4JQG4bS
	 C+kcmUgGen8IUJqh9HYhIA8vxBqPYcYy1a3EVUr6IhUHG6UxCufBpxwIGNDdjw4xYf
	 S88yQsJGo7/3I1r5zDT1O4xr7Hcfn7DB3ZsCiTT0=
X-QQ-mid: esmtpsz17t1780299852t8a43b288
X-QQ-Originating-IP: gmM8c5FYkGEW54XQ/Bl+R6t4J3ntVyb/FQs1oeeHjCM=
Received: from PEN1097 ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 15:44:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15633326993219006780
EX-QQ-RecipientCnt: 8
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com,
	niecheng1@uniontech.com
Subject: [PATCH v3 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon,  1 Jun 2026 15:44:08 +0800
Message-ID: <A374E0020B17741D+20260601074408.204630-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260601073635.200015-1-niecheng1@uniontech.com>
References: <20260601073635.200015-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: Mm+Qeo/nLo9OU8/4JY1J+7N5evmzSZiP2QGUVLCfuh4NOXSf6GjmJgLF
	uBLwcTkgYOxfDrve6GETFU0p9l83bNhFhMfW0esFm9hkMYxVgR6lsi0TxRUNMaCPMNztHEq
	Y9lQ5DUsf2ijhkQ4ICkC7wavBbJ15DqtWQz5wXAYdGi6dOgoDl3naPar6+w+s17N4X+P8/R
	Dt0QLi8pKO2kYAbMx404rLVf+vL1i9y3OoEqiI20xSu0x0+qUmg/yPXv2kvUeVcN5lzCX/e
	jsYKaU0cNVCelK12dbWr5nGuHOz/JZqJCkFKAW4tVsqfFGtx5jlnMpbesngY2UeXvrd0NIK
	U3g74JFiVGPCDjkVTWMjv9375wPQWmNZaV7mBNdAnxkTWHO6DJbQ6N6r8NRvl0JmRwD1IrS
	TpPFk8OHyXaBgb1kk8cMmrq2Z1DgWkawQug+2+lHoe+wguN6QPu+mBg9wHzR51sPd54nBNq
	va+6E4laXJ9MrRsYsP6XZ/X+c5+k1hmgSGHT0wEH7Nvlj3b6Gspn3m6Z702GJruh/qkNQ1R
	gsGTj7rRQyq+OlSCqZ2T04fZePejja+CTmK+uPFtbEov300t3k0F5Odag7QEkHop9sn+OiO
	sMXj52GAHseF2q350mEz0t+dWuJmJrIRYHnIBh8Tf+lXtu3Nrtcv4EsgxS6ohsq9p9aENBx
	3oomWF6VzUEzSVWdzyReYzydHidvtn2CjhGEbIk4LhPtCw0YD+Fti6mIAgzDF7yXqD2Jm0I
	EWe9DHOmWlDPmlAC9jjbA0twbPAy7fpVatNTNQuaA73pWi7RVdV/1q1qNYUCLTVmPWAE7ok
	DZowA6La1LmCY6aWifD2vmgQOEEuJj003m1OB9umAowcp77kmjWPYgblYwLua6o1x2DPysn
	4t95klUzxJOr98oXWCi5xI4gjFLo0ETwt9CcHw5d+Kua1p8nw5Mu/sIT793SSivXXO7p73J
	9K0oQFoOPPapRoNukZ+EpRm4Qaoi890ZsznNOWnbDIng8m0XAshaQExXnEoNEZOPK8ljYKb
	Sr6xe6YjpyoOpepkRnr1JPtKet0f0EMu6jKRAOCvYUahBGYABnSaFZTFk4B55IXt3LsDXDu
	JaP0sY19GaK1iE8RZw4iCtK9jKi/koSu88zbCBwS+TUqAaPXEjiLmY=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: 8ge7suu1fxmno9hfnxrjq6giassibf85
X-Rspamd-Queue-Id: D098EC0007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780299870-335095
X-HE-Meta: U2FsdGVkX18gt+pIOCciImiUMt4mztuz/svWuoDZCc+ie8bIb9rWBuG4A2dliMlYXk5MJaJuAPHjOHNf/stKTJ/VGO4GsH0Qw1lyL2BF6cJG2AjpiDgV5aG5godeYmhFLjtFTYYIbgNNWe4A5WI6gnJAB7AXZSO5dlhH9Ny3n0ZkkJ7mhK/Z7SrxSyc440/vEScFMwC+hijjDFFrfVjEBqQTYZB7tU0xsdDUIDRNgZ/DIZtLn46L3CNxT3VAVVTNo3cljLbJ2DszFfOraNKKo2nihJgK1eZ/FtT7V19C7ySV8BvLnoyyEFcee8hcf2loSDbVSdV5YTJHCoLfpZO/qFhJQcJq/85rMbnK2p+33fGcB0KZ9nyBoXdxC5CdduLbQhJwpn1Upj+mcKqr5PR9Y1aH0jgcHT89IUVKpEHsNtHUI/3QyGZ8UIOnIGZR7H6sj5joz4BOzRsR8fQQ8lpLdJP1u1l3fWPtMjzC9FRTIs6u9yl3+30s5MtjjryPB1y6FrRqQX8t9lMTdJXYl4DEhNdBaoTSqTO1IK6Fv7p1l+YqG5+HoBiL8e4xN+egZh5onNfrTTOsdvNNmzxjtplN0Oz+IN5Y7PBlvrqyrnjYJ0NiPgws7ZsvoDCWHXNhox3yKWuEan2UklSsJvP0LTcKLMl9W/Yj1MBCvzeQPx6h+ydeaWJ4uU7f84ezKv9mekYgXpuo9WiEwlwiVZOa9zHvniy3YD3S5x3pkpNoUnDWwrzJHiVVE3A6E+LTahghTOp0kJCtKczlpOaxJcbb9/krAbW9XnyC879z7BStNsq5uy7+N+nWdImRI/KwOGZnV5DqPFWIORJFz5gvjo1Q3rqO3tJCxMaBqAG1kJVfPBzFiKybzpPncK9S7Gk0WQ9eIJjxnAx6Z6ooB2BR9ES9+NyLkIpuiTpOdIbVaozjHswm9NNfEagCSc9KhKDzZL15wQYZeJuv3VUxpPOBkZkwDUj
 AgVZxzaa
 2vB2ZJo2N0x1jZoHcXy/FGL4W5x1gwRT0kDs2gvbyHVrHqC2cOOi01BqQYY2eGGOV+ZbDqqjhdBWKA7TRXresReeHbpMj+VvSIqAYpCWfX2A7TwQLU/Pve3Y8P5wDiz3HwiIjCyImH5g4MfgCq25A3nP21uzUcbmc31aXbgwwup85x8kD0jd55lBuQFmVxP9bjqbAID1k9C65EBRyd580ps03mI6JnLK1tnnid+PG+MPMLSicJ0hx4ArLTn6NgkDAqBGA6gOKN1ns3RebVRm33kJFwJk7Dgv5HxJbz+JAzLCHeh78fpy4sB46b7/oFyGvPUwnAZio6ONvCLT5YYpAvQSSjrCnGLXOiJS5zRjEjlWJHlbzM0vIFDUl/4Kpy0gmTTFC5dppG4bV7r+qP8W3r61By8aaVFDbyY7ICE7c4ym1mLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DamosFilter stores memcg_path for sysfs staging, but the constructor
assigns it with a trailing comma and therefore turns it into a tuple.

Fix the assignment so memcg_path is stored as the intended string.
This makes memcg filter staging and follow-up validation use the
written path correctly.

Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 8b12cc048440..43075892215e 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -271,7 +271,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
-- 
2.51.0


