Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496BDC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458206B00A7; Mon, 21 Sep 2026 16:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E0CC6B00A9; Mon, 21 Sep 2026 16:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8356B00AA; Mon, 21 Sep 2026 16:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F35816B00A7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:00:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9368C1A02B5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:25 +0000 (UTC)
X-FDA: 85238836410.18.83581A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D33EEA0016
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcANY6MP;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020823;
	b=OaYxRiaOOYHrgAjDq7ncSAKJnUI5VMk9gQn71hwwMjN1tlyeVb+uB1pImQNIUHbhPDpTW0
	xs0CHKhFiMgDsPwdCQYrnu/MyYEqYzvhGHQiezJUYhSqepuh2mcFOIvJSTPVKD6yIj671y
	ShLEayLJMQAEZd+954Cqy9rDRqTT4pU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RcANY6MP;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWjdXfohek7UjopKrNfrvbb5fe9CUNtaKf7mkTIpAPM=;
	b=2So2QMoAgYJyYGqOsEqn9DHC1xVWrVIANM3gxjQDdL2S4BhKvrr1W3c0+JnxF4dpBDC2H2
	4KZ4oFc9zkdpp3w5DIB/M7RSiEuRRW/p9tRAlP7W+LNhJ9vy+xk+hJe3C3cAjC6r4Dz4yz
	QHAbVlBElI0KAtJ76soSQPlk4NALDms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E95260008;
	Mon, 21 Sep 2026 20:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD45C1F000FF;
	Mon, 21 Sep 2026 20:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020823;
	bh=BWjdXfohek7UjopKrNfrvbb5fe9CUNtaKf7mkTIpAPM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RcANY6MPoJ2cYKtAT9WPPzebl6rnP5o06GtQRzAxnS2cy1JZ5rgXmtN1t5ZGKsbbH
	 25x3qs1W6FlHMH+KF9gdSLgkXJJDREvTRnQOsdNal5ankk+VYml4E3fGwimsdCp+vM
	 NphSgLOkAm8GFPTWivHmIIzFeB7/OnEU35Yc3BVa4QQQv05VDFFeVgjETOBb2q9efS
	 UfR3jAZA1LhbPlCRhFxkd+wgwhcEzqtp1K1JVxIW5XjepqiRLEQ9j3mzScmCq15cuF
	 txdI0eKbUsdLOcCl/QC9e9PRxydnF8kcOTUTluQs+R8x/ciTLTZ7+1Y/in+RED0gUP
	 xjPfr/4voZJnA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:58:59 +0200
Subject: [PATCH v2 07/13] mm/sparse: remove pfn_in_present_section()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-7-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1195; i=david@kernel.org;
 h=from:subject:message-id; bh=Jle8I94CDmdb6pvC+qkgL9TgIKRqIkcLTUltvuexjhY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rR5GKiXvujIEuRX+Shp77folP9Hhcre57Mi2+uuh
 UzlW3W7o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIl8DWNkmH3816TKqS9/GBwT
 FvpV72i/X7Pp4S2vhPiCTQ81t7TUMDIytObKHBOrfc2cGm/kGp2tX7D0qsnpc8I8L2xSHCW7wzZ
 zAAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D33EEA0016
X-Rspam-User: 
X-Stat-Signature: mz9pk8ucjfwof8whjgxqb19g4m1fatm5
X-HE-Tag: 1790020823-634980
X-HE-Meta: U2FsdGVkX1/uEwFIVFAVkm45hEwXS1R6vDiVqCM4+bQn81hU6ylVJF2iEIVaXqp8owKnAmJ6TEJs9baHRZr7Dg26M+UGokFo5zPQ/+FppFnd21tEMGuhcfhFP5CQwiRIFHkBRwL5rhoRhkFWslTCxlEvjRdmbOaeA+qY5QaJMPUkbdfYyBBiA8hsGmrwuS8x/zQHVVWdYLr8Ix7Kjvs7rWBStpc9qOvY5ostxhFlT5ka+Jg6dHzXn9gtU6N8aUjFiPSG7NXtBRYP2V7ba6wyOS0xV+LBninHTAQN7KM0h1XjWmiHu9hJcn4mk3oZQwf+PWSq561Gm4cBcu5IAnLmzcCZrF49y9S3gqD9Dwg7+M4yV4EYcsrZOIJhSkimC8gDCr1izWd5yF+M2Yth6f239RxZzmWTB3uwPAiirUTLbplzH5MRi47PgFKNqTgU5oG0hJ3zwK5QtF34lmxOv1NmoiSfhMLFEB01GBQxwposzPXpp9eTCwYW3I2AH39xnaE8tiXMJjS+1nYTEeD8UuVR+is4Imwk6f4jEUNvNO3cPA3GZ8uOs5DeLpBf0mUrGES3gjpT8q/ZvRHmIzn9v5iv+L38li1WZdVHJHBnb6jLKWSmVUGGkiq6D8ZAUDYrs5uVyJEW6X9oBZw7GYMKu8aZLz9rFmeofVp/UjYmRiABKjyliLDTe5bt/SYNY7+LoV/7a9t61RCUGBC9yNL4Qa+qXotb6W3HdsiEuQP/CSPH9ujccnEHwYCv2T2N4udVar5ZSS6UEamfT3BK3M6uQkDIgZ/wGfMmBTtNJXS0AwH1En0SX0439lR/yviQlo1AGxrMH4+u80sp0R98SV3lx8OC0tQ+yCRJS7x5uOrwxhmExVAmzXOBCovQWAkTUuLEYxH5BZ4FNPim61RLeFDKNsoMqEm9s/wRdPER3OtqrxlxtP2Ip988tZ+6+daCoLcJCjam+iP+qQAAoX8ch7WVmA6
 XDDUWEqX
 aVnvR7Do2waCsIK7XE1Ycil0LgOu505QeB75e7Nw/t0tnwGPzRPBga+K8H9aJW3b4SIiYjaW2UGZZWpkST6KiG5fUnx0guqsjqtNz5WMK7RNI4mqEv3mea79Comgbq4duXtu7NYBAcYaQQAUf7kD8YD7LoLKk5vSzXR8GyoF229LrhEBxxKfI+uFOZfMno9kHmmSs8LJKQxEmT+EeDCgIa0B7S9+3S763ZyEr1cTDGmmPUrDAiBQ9bX3/MAKfG1/3DDtqY3CMD70rDr2gGKPYA3svc6T4epRnsyCA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unused, let's remove it.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmzone.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0c2fea48c261b..a3937577fbfb2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2326,13 +2326,6 @@ static inline unsigned long next_valid_pfn(unsigned long pfn, unsigned long end_
 
 #endif
 
-static inline int pfn_in_present_section(unsigned long pfn)
-{
-	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
-		return 0;
-	return present_section(__pfn_to_section(pfn));
-}
-
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
 	while (++section_nr <= __highest_used_section_nr) {
@@ -2362,9 +2355,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #else
 #define pfn_to_nid(pfn)		(0)
 #endif
-
-#else
-#define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
 /*

-- 
2.43.0


