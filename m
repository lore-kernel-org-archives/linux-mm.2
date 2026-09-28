Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 282EDC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73AE06B009B; Mon, 28 Sep 2026 04:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711A56B009D; Mon, 28 Sep 2026 04:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627E16B009E; Mon, 28 Sep 2026 04:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4781D6B009B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:48:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D211E160143
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:28 +0000 (UTC)
X-FDA: 85262544696.07.1E9CC4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 252CE120005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:48:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxbySvb0;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yLabRzTUqOUXQwgBjet8vKJDfT/Yj93lFm/f0NXf0fg=;
	b=4dq30oL/vhF4Qzsblo2MRUZY2n0nBOqvNWU0Bwow1V/Nz7dvDePN1yd+S21B0ZTgNnEeRG
	jzV4hM1ERBD4T2e38XKDbVvN21AumJmasBnqol+23/5mvSOZr5zIoeWCrLRFQ8RBiyT8ZJ
	IlXWq1Z626WtBC0Zkt7K/zXeXka6lhM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585307;
	b=Q/Y0JdQFynptu94yxSf9VIwwXNDiS60mF/Jddqx2NvXm1CfBkcK5L3mBAjXAApSqW/QSiB
	ojr+fpkzfhE4psB0xSxvVY4ycB6Z2/S/WFUBEwPkXXgm90vFpj+kctYFQAGf4f6IFPi5Gf
	3NWF8GWlra1S4kyah2LX2pdW6qfiC1k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hxbySvb0;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8301760052;
	Mon, 28 Sep 2026 08:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852CC1F00893;
	Mon, 28 Sep 2026 08:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585306;
	bh=yLabRzTUqOUXQwgBjet8vKJDfT/Yj93lFm/f0NXf0fg=;
	h=From:Date:Subject:To:Cc;
	b=hxbySvb0c5U1ddRxETp6cq1wU7L0alG6fj7LX9jUThAcqHAP6DklVfNDAiFMmhBTp
	 oYhLfiJSG/U1KguJ1+fjQ1sKb2nDYsIbQWrj7F0SFh+zcmju3XcpqGm9ACxlqzVh81
	 imPv3oNQC+NcUOKqwhnoyuXoxws25H6N/Md7YGEKNNT5LgJWkHODd1WsT3oLu5XcFK
	 5BJ3edJlelICi0L81sA+IiZ+qG4Zr46Bwm3HWnhXxKOWwiW0fzHTC89ewFeVFtwAuE
	 lzP9GtwlYiSi3CIp1y8XdnhYJU+nefUAKpLOTJYcK6OoeFYkVsdj+EM9GswkdWZXVU
	 m2+XfPvh4HSrQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 28 Sep 2026 10:48:21 +0200
Subject: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
X-B4-Tracking: v=1; b=H4sIANQpumoC/yWM0QqDMAwAf0XybCEWFLtfESldjZpBVRo3BuK/G
 7fHg7s7QCgzCTyKAzJ9WHhdFKqygDiHZSLDgzJYtA062xqhuKvj5yA+UfIpbKaxWA/RYUA3gpZ
 bppG/v2vX/1nez5eW9wrO8wLuHPfkdwAAAA==
X-Change-ID: 20260928-section_has_mem_map-6205dc90a09f
To: Andrew Morton <akpm@linux-foundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, David Carlier <devnexen@gmail.com>, 
 Dave Young <ruirui.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1383; i=david@kernel.org;
 h=from:subject:message-id; bh=4+YaRd+w8CkKUy2umZb5rtfcp72agIYLGB21NcbX/fw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ2aV7fJiTZsbSSO9P1lYho1/1HHhtNdlb6H3vYUZP+J
 +f3l3T+jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACayQJqR4QXXg8p2FVmmD+xf
 /1VOKCn4YyydI6+dI+7/+OBywXu3JzIyXHwUXzzpx8kM0yyjE3OuRL6x11iz8KDcx813VNtro9Z
 xsQIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 252CE120005
X-Stat-Signature: x91acjccuiq4uitmfixb8c7oqpmhq68g
X-Rspam-User: 
X-HE-Tag: 1790585307-652912
X-HE-Meta: U2FsdGVkX19YVvoRbvgWIZ8JLJUf+9dU/Wh9/NZYlmvjPyaBz5lqLSVWScuOOve8upz6rI8R7MpZ/FUZbsCTE9jdrJFlUCVlheJJAPJYJARJkwzjpeJNFs/3TmoXM23wKxL//LJ2gms5B/1uZ3egwl3ep6cmjGtjz+8vL8yimXyBM4I4ZPC+bjBcQp1xNqBWvNhpwVXoMO9wvr6Khf+SYvM8uuB99c1ACFxuEiXByxZ5Tnh5j9wc6mWkoJDwGyCZJJfboQoUka4YhvWZE5xQzePC+y09Pcf5VLenlCPzBy8mMnkaIwLq3IFzPrv+PD0vHHNjxURiexvJZ39I3xDVxBZi8t+32Ioga1AIKKHl97B1QXEzAUNVqapTobk09hzE0/8TDKp54nO7CxeVBemRztnUJMRcZhFWHu4pJisN5BJybFu/K3ZY0Zn/QRABS6i8yC41H3b5xMD3d3q1Qm/ReZBtWGBNHNq3atlIZFEAnwWwGOuzAch8PukuW8eUM2gMuJ/T1HjsRLtAwiCgYvzLJG3lolL0gm4HDMXj1pRYf36Oujh2a2wCOAR5aqieTBTr3Roof1P9zZb/8blWdYthBETYvg8MMHUFO3DQ6mb7+jSb3L9ai4odpkwuBH142QDIh5HuZ6VTNFA3gGeNK/0wjDQtJsxzN+Nxn/ODpBqvZcf1Xk0yPHu46AA0f1dY8vPQ/5quHsC4xbr0ufyLP1Ql2jAJZwJV8LzkAZ38LSuDmXvM17d+h2MUCAGYb3kTVv9EkhyrBC2eXfT3NP0+gqRAHJ74B2PVlwOQO2zs9iy7f1HO4feMyDuMP82Kc5ZZX91I14j/59EipD8EjdudtVvR05cWgMjTIyTXRgBVrCU2LALgyisbKjX9Ni7zIsCB2q0ut63npzTEqlE4Zhn2NtQe8pyr7y2ewL2epMm8vI/2wGClMxjtLqogPByH+XAX8t+dtiBq8l9UHgXx3SP0hRZ
 tD86h3bG
 ejTWu09MZuKyxC0V1MfvS3OfAbQhWqQyT3JnE/Q1FWP1K6OnTNFQO29F9ogx1qwpUI559O8p4K2HKs2XIbqUP3uojSn6afuWYwoPadZPTgJhci5YrELxfhltGgTD6YTKi3vOqvKcy1rN64Rh3aD/ErxwX/Duhr1rKId+RO8Juuo4OTkgLG4MIQnSDfuL32xwtLt8IuVkTySgAYzKbB7CrRVVUW0n47vOxNV+1QKjIeCTM3dqF/oTBYnJgUyIHlrtDssf8PRziVpXTxklXzefBffRxXZOhJI9Pod77
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
needs similar information (although still relying on
SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).

Let's just export the value instead, so tools that work on vmcoreinfo
will not have to guess.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Result of the discussion in reply to "[PATCH v2 00/13] mm/sparse: remove
SECTION_MARKED_PRESENT and further cleanups" [1]

This patch can go in independently. It would be preferable if both
go into the same kernel release ;)

[1] https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org 
---
 kernel/vmcore_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 5a417f8a922a..7833a36064a8 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_STRUCT_SIZE(mem_section);
 	VMCOREINFO_OFFSET(mem_section, section_mem_map);
 	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
+	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
 	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
 #endif
 	VMCOREINFO_STRUCT_SIZE(page);

---

base-commit: 57e4ac91fc62d75d84b5a03827a19ceb4094ecd9

change-id: 20260928-section_has_mem_map-6205dc90a09f

--

Cheers,

David


