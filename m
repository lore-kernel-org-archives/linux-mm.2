Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA75CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817DB6B00A1; Sun,  7 Jun 2026 23:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EEE36B00A2; Sun,  7 Jun 2026 23:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C8D6B00A3; Sun,  7 Jun 2026 23:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6224E6B00A1
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A63716497C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:31 +0000 (UTC)
X-FDA: 84855350622.05.51C389E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 912E7180002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTPS5cu7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbxrLUIuHStdHaKlhEhtpSuTr7xLq2M6g2rOrGI1zRY=;
	b=M+vxk4EIEaGuIJG7Z7xCDdwbQJUn0UxcmWSR8gYMjnehmtYjs+BRV1M8BZOqrDnZxnrNZ9
	+S5LHTzMuu+D0cF9zGLhD0IHg9WlKCKZ6700Z5CtiKf8uYrzK51F14IjbRBmNOJCeQkI2v
	jyxY+1OASiFV1HC+F9YJ0dJx/6F4FWU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UTPS5cu7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890209;
	b=XTdRVok+jIpwotPOuXRHLOyHFNjOwM/KhE4vULE+SBoQq6//czwu+C3ViYZX3nM9doyv1u
	QnLLbXfri6uk20Nw4wXuu7GEgg2svAH18fXCI8qj3oeIHQpvsaJ06lEGZ9q99CPp1t5ax4
	Rol09wFk1jpKHdLVdFKCg9scgr9KrJM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E14E043867;
	Mon,  8 Jun 2026 03:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27DE1F00893;
	Mon,  8 Jun 2026 03:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890208;
	bh=xbxrLUIuHStdHaKlhEhtpSuTr7xLq2M6g2rOrGI1zRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTPS5cu7VlzINgI3kKmHxHbbFQvryV9PycNA5wH3n8YHw1oTF6/2JHEKn3uCofyQy
	 waOb2600Hd8AYZFpZP/nPBIVZ2F0EkQ3P8HUWjb9Gm2iDAyCiZOE7Y+l2xyQt3ee34
	 CQUBignVLDwUjLOBcekxUuJxcBj7EsOTToYRg5hu1OJcnX7iW0IzFDBV/OfJHpAKMT
	 aY9ukY+NSF+yjMYDkMqrSL/FTHCIG3Hn2r0xGSrdNGU7isnnSDZKhGnYVhl7QNehKe
	 GdgIIW2RY7rk25dDZNXn4rUu3JGWYBKcKvc9tQ0ychxYj0msv769sHOtAeAJkQ+847
	 ViJzYOZgf0f3g==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mm/page_io: don't nest queue_lock under rcu in bio_associate_blkg_from_page()
Date: Mon,  8 Jun 2026 11:42:48 +0800
Message-ID: <c910d2c39d3ec97f67de68af636a52394342d55f.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1da4odaruq8yxgbmkudhwcw8y77pth8i
X-Rspamd-Queue-Id: 912E7180002
X-HE-Tag: 1780890209-395775
X-HE-Meta: U2FsdGVkX18HryGF4d0w0vCxB6stk3olQqO7AKKClt6AHIOOMi8FSDQNkuviw8aA8d+Eoqc06tJEtlbvqliSrNFlQB9l6FHdC+qSuxBPK1TsntEDrdLxwuybO8ZPp4EMTC0jBZVAhphLaa6L7sX4U/DZISZk8yYRu1XdV2fxkTHPYZJY56R5xVPLlfmYoQZXpUO6qVinhQXvFZX/b1VgG40rN6VLcF0LKjfqtUQyHmkZSqQxVXsJwVAnE9B1G2E+L+Y3NVYFrjg7QU1EQXbmaqIQl+UuvslMe0s2wjZH8pU4wtgc0fn1jhuXB3NveLDX5NArJwSKV8286Ii58Hu2f9EVBa5rD6ResiPwTJ0iL+eT891wo5v36+E87M/N97WJL9lU0bxTsIBKYe8fkgtkxJhRXUDqN2q7a7Cw35HxIKe92I1LDYddMvFgL5uIYIvt3aJ8YzZh06QruNrSqRT2PoZf2ugw6MdVzhr4fUnGXr9jsU1t74A9xYfIm9eEuBm0iEUBtFHZ17753I6FpIV409WTn6TUtfvYAc+tU3eGkFnx9bnUoMMitc6q7IitXo1SOL7u0wi9rSTDAsVR8mTT9OxwZmB61o4JQOsvv9ua2LUkQMuBpRKo2cdGHBSBSO0A+n4sqKslGQ8PdJlwQSt8q2yeA2/yxG7LURzGKMymgDk6G9Qb2zf7m3ept0PEoAvjjXz4TWRxGHgDYpbj0ucJIbr9X/cDbwgPH87MHhhMIO0CvQetAkccWD0toWYoEtiyTqY6T1QrOE1uyWcURKch8YJbUnmYDN0xEQqIjbis2OLCpgjnMXumEmJacOzuMQSNw+dM8oM97IGywYkB+eqa9XQXlew+BF4AfDJEAdGDEbCf10bNS1EqA07CvEbsVSzyMCEO7RybNpGrtvJ2tFlMnYN/GEmhvFhvvYS0YgJzSt4lsrUDzCfzaDB2Stnyo5nNnrnKz40rkSFKqNn7nKP
 Rc/pYFWl
 zX5YzlAKovAOh9UmX13YpucDhXD95w9IzK0o7Ug5yscbb3jUg6zSzT47iOHN1gn6K9tRbaVwJKZ/I75DMf6b7GGogo8YLVpbmPeC1Tkp/W/thZlvDACRSVGKUlti2wevGKkW5Tdyl8d+DVowcASjQ5B147A1J+UAcveUi5393dZ/R/ks5D1CY3PVV1DJXWxuiFVS66zykXEig2wXfXVGxVP4cK1WtMW5Y5z+aokF0yzO6QOBGV6jrEbytGpaMzPaIRESf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

Take a css reference under RCU, drop RCU, and then associate the bio with
the blkg. This avoids nesting queue_lock under RCU and prepares to protect
blkcg with blkcg_mutex instead of queue_lock.

Use css_tryget() instead of css_tryget_online() so swap writeback for
pages charged to a dying memcg still passes the dying css to
bio_associate_blkg_from_css(). That preserves the existing closest-live
ancestor fallback instead of charging those bios to the root blkg.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 mm/page_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 70cea9e24d2f..3b54c60c278e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -315,12 +315,17 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 		return;
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
-	bio_associate_blkg_from_css(bio, css);
+	if (!css || !css_tryget(css))
+		css = NULL;
 	rcu_read_unlock();
+
+	bio_associate_blkg_from_css(bio, css);
+	if (css)
+		css_put(css);
 }
 #else
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
-- 
2.51.0

