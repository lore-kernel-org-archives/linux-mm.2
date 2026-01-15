Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB12D44C5A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 14:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E926B0098; Thu, 15 Jan 2026 09:46:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BC86B0099; Thu, 15 Jan 2026 09:46:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129676B009B; Thu, 15 Jan 2026 09:46:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01F626B0098
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:46:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C89D6B7D6F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:24 +0000 (UTC)
X-FDA: 84334473888.28.17AE607
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B97F9160006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:46:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WZ3g8gbn;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768488382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdS166ODSp1mt84tct9eW01ywIXih8ME3gSn1S65Nsc=;
	b=FOnJnbB7GdXsqg3FxzfymlXfCsMjSGJ+7RkOPxuqfOwLqhFRz3iyF0OC8pqaFbkUabvzPZ
	sAEQRzBvnV1o4FLxFVlYMynODgFg+P48+XBziFXTQFpQ/o/AP2aOhqoi00I594K7QWl+CN
	bQjoF5GhZREXz1LhY8gH3gcy6l3//mY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WZ3g8gbn;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768488382; a=rsa-sha256;
	cv=none;
	b=Lo+xnF154PHFNuxQw/EE1+fcUEJ1w38HjdyRN7V+1jRCtSFLwG5Efvm22xiWDEU2ZcS/b5
	TtT72M8edJPBpVVafZWmK71JBGkcLY8GVreJMmLztc87Pp3Vsk5osfWuWHUlUWMgyrTFkK
	ZBWNjOhQ0gZ+MltKvtF7xbFFYN6mwqc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC7E0443DD;
	Thu, 15 Jan 2026 14:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C30C16AAE;
	Thu, 15 Jan 2026 14:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768488381;
	bh=T8UK/c799JlRwYME3UvlwD+wczrXw9AaT7vDCkxDE1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZ3g8gbnEiCuhI8vMJDySSJbBbUKB/9dP+m6ZqhSJibYs4S/FWvO4YDs9A6Wyc6xV
	 G4hjEhzGcCBoUsrgPDJLPumCmCs+SY1gFt6+q1155iTdVaqZ4elE2bMIbKZcGXRZBg
	 AbXxkSUiF3cVak2vqJGG+QsTohAbcxAl0QWXG6HN8gwZhdwdPwhxcATH2tj61O+BFf
	 9aSZwge4QVwtWWbdyCYBOJX5Vf5A2YsGvT/rtmJG9nIcv9l8s7IWusrOfAWMPwdVt3
	 ctw4WkyFvmhH8oDTivbbK+QRUYoCUa2j4YGWkgXPu5jzj1K8+J0eyfYYY1Qof+B2Ph
	 xqM8AKKNGWhgA==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 797CDF4006B;
	Thu, 15 Jan 2026 09:46:20 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 15 Jan 2026 09:46:20 -0500
X-ME-Sender: <xms:vP1oaTm3OOTSUqdiltgu6cpY5YhOGft_hcZnqQEIZBW0BZtngNy-kA>
    <xme:vP1oaWFxBZw-onh67tdVi9FLIw9txGxmJeDmvJHIJC-Ek7oMjh3egbJT5Ybc7B09K
    ztNEL-N6wUYj9LYrIDVLvkemvYA4DDPiVHO6VyLbUqYU5qiEmQGhg>
X-ME-Received: <xmr:vP1oacdg-Q9rjHOz346c3dE0Nmg1bcrL60Y2o8yEE9hJmm9XTm07zdwxlhvbLg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdeifeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:vP1oaTHWZiBFLjng2zgR0eQ7HF7XmJX1XNNVWbWuXUjk0sUGfGxcWg>
    <xmx:vP1oaWGBsVYm8zfHBxeFsb8j3le6i8Sk1b8jhQmdHS77Ky-CPmbxlw>
    <xmx:vP1oaTOLQKPSDHLp4o-eKxhIYBydkthiudER5ukz0Zodo2_JKTQnNQ>
    <xmx:vP1oabr9ohV2gSDsLQyRyvzoMJq4pU77gUQlmDmXK3K4cSh70aIF0g>
    <xmx:vP1oaUAORi2kZsXA33Ie3yjdMvJqWAMPTF6z2Nofp6eOtvZmVZvPUP_c>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jan 2026 09:46:20 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv3 07/15] mm: Make page_zonenum() use head page
Date: Thu, 15 Jan 2026 14:45:53 +0000
Message-ID: <20260115144604.822702-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-1-kas@kernel.org>
References: <20260115144604.822702-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s4sh49w4xkbsww6dkkdf6rjokc4fhfaq
X-Rspamd-Queue-Id: B97F9160006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768488382-728927
X-HE-Meta: U2FsdGVkX19FRSg5kQj0RA7PVPzSGcKu1yNGGFPznQbZaP0KioSDsAtXF+MCCzuqsRooUd+LdNv440Nw4RMweH8ApziU9hM3E6mT2P9Zeq5XR3zwf+TO2dnEhfaNabpiN4OsDwubaKueZGOg+KQnfBovrpoLON/RHKARGFa2fBdguQTmskv1d6KHD/XA/06y6VSQvguzPErAzkvP5qVAbqE2jZtMeTR8W1ZItEfuqG47xp9gYgG1RHQYTaZkxYoGIM7LJ8k5Snt3+CSiYGGAyG+BglGG0ifYuErQfqOx0xo6TAKoZ8u6c1feqATbM6w5zMacG0qliABO84BR8GS1xSyzBMwtO2CJUkwd0e2yLpnjUg0HscsToqdZceERewvFfAN1Z3Z4nAO8TSQbvxkd0THOnjbJOx2CqegfPGeO4QXyD23lDePs4T9np7dRE8U5SpodHIonxnaUKSxiZvQf21Z2oyiQdno8EsQ2rJs5jawfVnu2ad0BACd6AgMiWnB9LK3r6mFpbGUZvX4APT3Ezqpgjjr3obm9bhsAlOtwiT09Yek2zxsMx5IQ6JPekpkDtt+txkygKazKyzoqYg6BkqvGNt+bSiz+UDnQZ2kjSUB30lX8dBA/Q70UNqDyta2yRqec4zNB3h7kunSX9FX9w7LKnmGU1GUC+IPFxxTrlfKPt+jHhzGdrn9tfyBYDWyiJk/xHGZMwCvlo6InkslQw9KbrY8JlZZ54tggZrURk2hrTExoYSOIndcxdNz5HIwiFruSf6BAfrlMNP8AOzLmqZGKIVZ6/q1pbgHmajdSAzKO02kUkxbGKsCjR1RttjscC4jEYwRUlh407I4Ns10EBjsCmlHHMlfwHu/ZnvDmulknHUfOEzPF6oKhHUELZrNmsrx0RIxedGVD34hk4ZJ8tbuzRRnqRrN5apU27kmS461of/15yXyDJ9ZYlbFhB8hB4A3qI4okxuuBBDZBSWN
 llz7MmQ/
 /rJiXDZ78bbpI1kfN4GXePMUaJ2gCkdBGwvMf5b/jvINns9xMK+DjOX89+6RLtfy+xTVpuqPJphwvyHOLetwJCymeIdqVxPC8z9bFXBOKtkk1BGQibwtTMI0IoVAu963+8QF2KzqmLTABk+3VMQ6lOBGPtHQNW8iZqcl4iN4g+6/rQ1r6pIXnylMukYpyL4pAG2+iGqla26IKNoBIS3TaLSfgK0+HYax0gjrxy2jRIKp5RGZSsCml1XiCU72hoqjhijLmu0fiVKmgnxQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the upcoming changes to HVO, a single page of tail struct pages
will be shared across all huge pages of the same order on a node. Since
huge pages on the same node may belong to different zones, the zone
information stored in shared tail page flags would be incorrect.

Always fetch zone information from the head page, which has unique and
correct zone flags for each compound page.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mmzone.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a2f3696068e..590d1a494c4c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1224,6 +1224,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+	page = compound_head(page);
 	return memdesc_zonenum(page->flags);
 }
 
-- 
2.51.2


