Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F08CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFB58E001C; Thu, 25 Sep 2025 04:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FB48E0001; Thu, 25 Sep 2025 04:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F258E001C; Thu, 25 Sep 2025 04:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E59608E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:50:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85DB11DF629
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:50:20 +0000 (UTC)
X-FDA: 83927151000.27.D8920C1
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf02.hostedemail.com (Postfix) with ESMTP id 07D648000D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:50:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=i5CMwei5;
	spf=pass (imf02.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758790218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oWazejXIX/ZUdm5NLVQBNS556FwM+MqcPhsfiU/gNew=;
	b=JLH25p9WB3chNEYzLI6vgGPBTBe/5fagc+NxtGJ/9b0+2vWQ1WjDvdN4O+oqbP4Rd9fktY
	vnxNIBo1h45JMduMKjN7C9PMdg8dBaCvSQgiPh7yhef2yAIYlY6o/jSQ5tfZTGxYlytXfy
	rjpTMUXwueA9Kh6md2KVWWce1C7uzd4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758790218; a=rsa-sha256;
	cv=none;
	b=A2PD3zynUoXKapo+a/4UMrmaecrQLUK1Jg8uAzkXmQpoFGw+Nn7ySOPKohLzrCx6oHKuPY
	ZrtX4h77wLeoBHX+YDXltURjwq0bWc1PmGhReeIDOe5p9noLqY1QTnfjz2qizjKSgCj6jc
	NUId3b9XqMn0EQp4A/qN2z1CIxPe7ds=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=i5CMwei5;
	spf=pass (imf02.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=oWazejXIX/ZUdm5NLVQBNS556FwM+MqcPhsfiU/gNew=;
	b=i5CMwei5/olzl8ncecz0XEYWq8sQNTIHv5SELuvOIhPo5wNkGugcfxNAPyQMHIBn6g2NwoadL
	aiT+fHJ4TjGWjmgORohmCgzw0btjgh38kLbZ6JTTAjGf2XznX3rvSqqvCU+6SdBlHC0RvVmvl47
	E6hzNzhhySYT0nkcHjQd1mU=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cXS8C6cddzYl1nL;
	Thu, 25 Sep 2025 16:49:47 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 25 Sep
 2025 16:50:11 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 25 Sep
 2025 16:50:10 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <akpm@linux-foundation.org>
CC: <vbabka@suse.cz>, <surenb@google.com>, <mhocko@suse.com>,
	<jackmanb@google.com>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <liulu.liu@honor.com>,
	<feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v0] mm/page_alloc: Cleanup for  __del_page_from_free_list()
Date: Thu, 25 Sep 2025 16:50:06 +0800
Message-ID: <20250925085006.23684-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: bg1gh3wq4eaaanj3ohxmrr4hr4jhfui1
X-Rspamd-Queue-Id: 07D648000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758790217-472094
X-HE-Meta: U2FsdGVkX1/DjybOQvfqt8xep1IhaaEYlPXVeqjbTqmQiEbEgMVug18xfXguPd1hdmM3cL18ojEgALphSDJOXz/jy6+2pOOlc+ftqoHvwmpz4jxTDdbvrKiEeTelom6oT7XysPilem+S8eFSQzvuwHXmfahDakgVh7PK1oFbpBgAkQSIaj8Ya3MfgeLKaS/JdixVbWx+vr23/UeyhCMUsnUXLla3zEoPxSQPq82UNEaF2q2YKXiJ2NEQMVHwMZfmdQ5k74HS08jnn6GPMBw3T9CLm0rn6/w1NRdJsVyqTF80Ny6X2OXP/YDQJgOibbx4q/S0D1t/rl5ryN2S2GSxxaqlH5o5pnbLs4lkGfzlB2FrZdptSpP08Y6ujM5d4OAxMiiVWCI60KIY5ejJvAxHsMhnK/7xcyVRylV4jbx4id2ZowtUPgHdVGigUNWFi9EoXhutGlvr2autUsdly0Ke0Q0PYlONQM16wd0nSky3v1d+/K75yGWNrnG6rUMNub/hpn1okQNbgmmEHcRWUl5QDZfwArEkWq2S+MgSo8R1LbGc6mOF2iNh/AT37XL4aPnA0n4hLmfNr1kkrjcDU2tsIBlr/n7kRjVOXLsOSruupYQgzNo8KT4T1kiyflmN0lwbo/E/V8guHQwXL98ANDuc6lMAt8bYfTD0m5NEE3uC3O7adwrYI1mNCpjTz2qq1xaX2Zju4Icigv4evUOufRWTH0uKERYjHAf6ch6b4DrcepBgdomuint3LD/otVBbCzMLjLodZBl/w/IRuuHlT6QnGBUhGW1R9/DXWdosKyjQxbiJSRla+ojjdIF1X630zRhaN6XaKmnx5DvFzjd9Qzwdia0ZJWF3Vu73oXvX7bNAlDJVNdmxE69xiQ8oij/tQ8tyGbGJ8lsodQSlQVAWQMsEQNk0YQyHXCtqIwY5DUHtD1ToPRr4XgAoERKtuSNwYfQKlLJpmtuphA50lFF98RV
 G9QOZ9cH
 h4vudh1VYVnDKfZ85KF3aqTTz00/acbFa+T074pm4z8UN8Jz+rvDzJDEKkbAYlIPZV5xkIT6VoJZjcf/i3K26pWqa62i/X9n7c+i7T1zaKTi2tn57MJGCogk7T+wDq4Rs6mSLodNrrdc7Lzbn6vdUfON/us+TPdvZyIL1Rvy7Qpdv5fsu20K1IU8cJpVsAKpUTt9IaQKnaFiSEfnTXJt8wz1sw05TEYw7jB+AJnS7wlpvffHAgPN3McaBVxlRvt95J+UAzppusXGkdifktvUOuzoSdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is unnecessary to set page->private in __del_page_from_free_list().

If the page is about to be allocated, page->private will be cleared by
post_alloc_hook() before the page is handed out. If the page is expanded
or merged, page->private will be reset by set_buddy_order, and no one
will retrieve the page's buddy_order without the PageBuddy flag being set.
If the page is isolated, it will also reset page->private when it
succeeds.

Since __del_page_from_free_list() is a hot path in the kernel, it would be
better to remove the unnecessary set_page_private().

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..1999eb7e7c14 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 
 	list_del(&page->buddy_list);
 	__ClearPageBuddy(page);
-	set_page_private(page, 0);
 	zone->free_area[order].nr_free--;
 
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
-- 
2.17.1


