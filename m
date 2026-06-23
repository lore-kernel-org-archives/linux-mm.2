Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CECDCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B2A6B0096; Tue, 23 Jun 2026 02:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDD26B0098; Tue, 23 Jun 2026 02:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B296B0099; Tue, 23 Jun 2026 02:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC1F96B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:29:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43CDC1403BE
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:29:02 +0000 (UTC)
X-FDA: 84910199724.28.6F4B6E5
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74BD9180009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:29:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tpo4KkFr;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782196140;
	b=wXV4tXpXSGvfpxq8xJLDmd+zdOLZwYjU3xUSujIIaDq8uW3KmknM65JSFuSljvSp5gf+IK
	BKfMkfIGjPZBfkgIa6nIYbfbFdUTpFUjJWs5q7pp4QF8kkTRoebYZC3riGrMEN7MGY9JA5
	sHUGrVRiLDgVWjNjSXYMM2Pdvio5+hY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782196140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGm6TUFBAg84hbkJ477thX3itg6T9dCyxPw+enISTeU=;
	b=FTFwl3+C63uY51itE1ODP9+ebnjFnhVPjZgrMyzTcJb2PsrnQY1DMyxhdw4sdvijAmXp1c
	EYpVRKMlqdcU9mtdX3F72JHXWbk4EdOvlINuRyLACtYj7a0eJB8ass7j+0rYjLiUo25Hgm
	IwzCIIKIUAl4qr5rm9xLddVjzEGeXP4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tpo4KkFr;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782196139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGm6TUFBAg84hbkJ477thX3itg6T9dCyxPw+enISTeU=;
	b=Tpo4KkFrsFNFm6Ly/8tUzfzu0MJJ6VdUwcPMg6lKY4K3FCcVCQReTaeBUYOMlGuTAKMDDz
	M1+L5k0Xqy6KfAUnecwQHyAUe/pON7OXT1bFKhs2DpLnwhwvez/II0XySwSVinnvIkp90N
	zyQcQYpZQDPwTZ8l/fGTpE3rEOj5lA0=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: yingfu.zhou@shopee.com,
	jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] memcg: bail out memory.max when memcg is dying
Date: Tue, 23 Jun 2026 14:27:55 +0800
Message-ID: <20260623062800.298514-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260623062800.298514-1-jiayuan.chen@linux.dev>
References: <20260623062800.298514-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: et9puqrbh6koe9qcaexdaetbrxh49t85
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74BD9180009
X-HE-Tag: 1782196140-599503
X-HE-Meta: U2FsdGVkX1+q5GvA5c4nkKpo9Ony2Z1tAd+2Y3InQWkXxhjDf30w8V5RRbbTQTgVvjMlTe1FkUCu+XsYsyx0mcb9Ymd1qM6I1Tv1V1056BmZjnFdJQVkabvXCSGoOLcXuLuXSlXcaZ5Km7to5jgteTSLdKzjJccx7xe4zTyTqNQKHeBgJFgJfdR5OuUvguSArJ0umPjAeSdfycUZFf4s928929ywLv9MIkn9ccW3/YHyJ3q3w9dHcsMaUUAXJyxQNOje0rZUkJ7oD4j0MNyKoLAKMzOSxtGUPry0sJwidTWpg0wVdxQwqiz/zIBeZewBMmo4zRpsqSDdlXPcfhikCWIO/JV2mSi1zQGQzxWjG0NnEeOXiv8lSOgiFvY8ihI3Ic01QDlBRk4xuW47A0wvcwBgqL4cXFVVRQdb9VWY8ROBbbuJ3r1B4ab7/bg3z5IfWvGKRYxTPcWHOKE0b1MUD50m5EmW1SRq6l6di/jJ7aX2Uj6fSSE+plGr/AAbf4WZRh1DjJu82HKv2MJzIVyWjUB3pmZsXA0WLxcY8fk7fPWiW6eb4FimN8/8FFZM8bZjdPfWC5euXReE8Khz2goQGLeYRjbl0SHs+l56HO0+Y+apNwx7XwVQdOeEoGSmtr7TxpeI5SoOe2igDje9RAA6OZwQhBhUTR3LYKaja9MBZGfcrSOw/M9IzVV58Ov7tANSm5VoNxM1XWP7f6XovJX9S3vrVibEFyctYr9M30hgTrUxthtlisjgNDq8ybqxkU6teggLfOSlYtDt1JKjFfbp1CMxcATUvp6BBFoyC1xjea4HkuyuaMK0oi2e8XXIEZ/gGLQThPc78lu+pI1Sxnqg5Zn1g/XxbsktawDwaVuSn/vvNeyEzX5Mub7c4iPO4ltQ+UdqwrboUuuUORWbjkgcYDrWzEAUmDldfiI5oU5pUKLzFvsq0b5v39OWXvUghB4wMyZCbCET+F9D6asM4ch
 Q8M6DefN
 WEfZxbolzNQyOFS4oxQDHOHef/x7B1xJUbfi3+ETV5J/hvgcpgbUewM0MBb+BxSnec1vXx5TQvI8nGy926a1NsBw6ed1ZOsD//GCMkeko+We+ALDnoHWoEsfaC5WR2Dtoy+cBZFZl0xOYbty/kKGdjuERkEsEwA0Z1VKzblmC8AGH3PabwqaD5jmNH1V/Q2rbvOX8s1X5nejgMJKjXLNTfuu0LsSVH0W77HoB/hTTbvHdutDxu4iETy19XQ0CIKB/OfCZYUwkl4+w42UXn6CYXyvRiZ8SxaGihaFDi37umep8gAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

memory.max has the same high-latency reclaim loop as memory.high, and
may additionally invoke the OOM killer on a cgroup that is already going
away, further delaying its removal.

Mitigate this by bailing out of the loop once memcg_is_dying().

Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d5cd056a25e..06bde6c5318f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4847,6 +4847,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		if (signal_pending(current))
 			break;
 
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
-- 
2.43.0


