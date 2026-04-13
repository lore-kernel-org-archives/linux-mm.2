Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE6EF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63DCA6B00C9; Mon, 13 Apr 2026 15:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615DE6B00CB; Mon, 13 Apr 2026 15:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553256B00CC; Mon, 13 Apr 2026 15:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 469C06B00C9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:26:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8B491402C7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:26:51 +0000 (UTC)
X-FDA: 84654515022.26.E17A740
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B7331C0003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:26:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P5V7D+wp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yyAV4CsxeBNj9l27xq0ng1Ca7pq+jXSdxBThfycX8Bg=;
	b=hoPy1TFoPdHpjYEmSp5EJMGtcCpIuY8VlHnXOEF6BTJRL1NCv9NmrzuOM4chCLlW0V1skJ
	OQAvLkvVgmyAbIm2XiSCm6UjuoUMC9xpdUP3O3S0id8ty/XSeBGNchrlUnLm9zmhVq2TCX
	97GzJXLVPMJkZ8w0Y6VNzX1ajhIIx70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776108410; a=rsa-sha256;
	cv=none;
	b=CE/NEc27gpfGjh4jsZYIeqXDb+cmw+OrI+lyyQOEImYQziGjpNwtd5QJ6BUHU5PEW5ObZ8
	ZNSmZiJhQFxzCjaqam1dObkBuHnvQ3KsdXQL79EMHR2zkQWsfPDR2Yf6jGFrGWSSCFTmQu
	PcOCoKQAiZy+QbvrO8y27vICbhwIW+c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P5V7D+wp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38dd9f11a09so44073341fa.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776108408; x=1776713208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yyAV4CsxeBNj9l27xq0ng1Ca7pq+jXSdxBThfycX8Bg=;
        b=P5V7D+wpmv6SSHgKRK10T6BzF8NOKNT+Q+dG4lbpTHq+eMYq6wy8GxYI521VHTKJw5
         u3swhjHJTpCmDnWpIMaWsJL09BNU995SadsU62lMLt/Tb4xYp9qI1VcrKOEXvna4Wg3t
         5Y/BFJJEZ0n8UIXwfMkLDIu3D1S0vjzNRgA9UKeIRiM27fBJBGuFwvCJCSwo1InqxIr0
         of+iyTQ0smNrVlC8dxqbmPauX2rEzCtznmGSlpHpRv1PT3pKGvwGvBNoxcVfdzi2r/ZK
         S6NNmQxyUSnb4zQ+CKcIRyKbsedGIoWMKuOrllavwU216PZy/GNJaVjQtWDbZn+Pv6A6
         s+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776108408; x=1776713208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yyAV4CsxeBNj9l27xq0ng1Ca7pq+jXSdxBThfycX8Bg=;
        b=mMr3dfjrVn0wbwAS0XtOc/HMqJl1pvNclc05xDTwHsPc3A8QgBQNe+RR3Jl4BNwFR1
         ENyn+hYGj8kL1X+mjcwSFOHH4B+YO2J58JD4KvR75waFj8V03PZ1t3hVuowQa/UaPV/S
         6Ad8XIiXFoZPZ/tdZqQijrehf8RS0kePj16jM9qq05jORgAiEVQtOFb5ZwHu8rBBl0Fn
         KYcnzO51n9Zz+SnnrRWG0C8+1naU6eob9dvMVRBrmqQTsU/x3XZwpfSm0cWvSKowbDix
         nKFQh9MgjAlCd6VIAkGlZH6fvKKI1Lls8N4fN60VItmeqJXntLvNOmnG4GmJhfGwYMrI
         GLig==
X-Gm-Message-State: AOJu0Yz9JDFJC8CLVBoLbTI4GgvQTd4tBhQvGpYftO6B16foyPYTcpsF
	6piWigxNJZSTBy6wce7lUSpLMUmXcVsDqxf85YXgsLwDR6e5/mmr9v2Nq5ro16ll
X-Gm-Gg: AeBDiet6KG+XWbSzLTB+7PbLQXWmaAlzraw7kXS76ziyb1iELCLXSkayRty58e59nW1
	Yu1bFrXKPqOveL7NhQu6miZ7GuKW/8S5YDG+ivi22cVFs4oaZEnbQeTi3y9bgG8vnxbuWmHBAsA
	12z+1TAhIkRpGD+I50OptgIfnXx22x9+iWQomHqW1hx4Va/PH7sQ2+YwB5xQn/08kOB/P3RvoxE
	IG2JmDb3EGZJ4bc5WiQ3MtLMfO7p9pE9R9Ky7BTn5mAMPfctUqvrkindZuDuRWp80ASkoR5+MAb
	+8CYwAdKWX3fZK0piFOhcPq+hd11mF8UPdked3qGiv0r/TiEVwlvYNH4jCMw5uJUVUHWoz33guQ
	OUSU/oZL6in4gi0Ef7AFUlS5HaXjDcsERDIAa3+I33CabAtmoQkMiw3hBMIOfc6lSkvbAFv/q2Y
	pX5MruEmTuw2zYX30=
X-Received: by 2002:a05:651c:144a:b0:38e:827b:98f5 with SMTP id 38308e7fff4ca-38e827b99f4mr12058721fa.35.1776108407898;
        Mon, 13 Apr 2026 12:26:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38e495461b7sm26191241fa.26.2026.04.13.12.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:26:47 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	stable@vger.kernel.org,
	chenyichong <chenyichong@uniontech.com>
Subject: [PATCH] mm/vmalloc: Take vmap_purge_lock in shrinker
Date: Mon, 13 Apr 2026 21:26:46 +0200
Message-ID: <20260413192646.14683-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B7331C0003
X-Stat-Signature: brgncg44j6btebgrjcj6u47dn7a9f3kb
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776108409-370566
X-HE-Meta: U2FsdGVkX19G7Fg6us/ua9l0/oVjVsr38bt84r4VUgaERqYB/GQzOZJA3afp8azmheaGPseIx7SeRfRKDIr/3rKuqrWheMDouY9v6ZVUbDXTMlMK16UKiHOy4WkdxcTEbTY7iWwxE7VBH1md9snSy9u262O/lIGzJjwjsuzgdkj7a77bwuIJr7t4tZJkKv9E7gtN7UlJheDmpwnMGn9DnHM5oDAVgM0XNtCM3en5b0q4CmsmsweSq8rkNuMVDzE0fbk9Tvbvh1wFn6DvGW6CcwVFD0bbSZe8MreKJGT8UVkgQCWoWPkoqgcY6s7wxl96CRVst7m3TfX2bbD+OM/e0JPNCMgiSXIv9HXMlDd8bYsIsHI4dOyKwWOHSje5Sz/Z/6SVld6IiKr+mItA4nD+Tyn2y4HbrfQO508KYuwvSTVbmdUB6auvIGfjiD7lOcb3LduoVtBqHBABVr/UB6x4qBWYGf6qARUQKLHvBks3Cf9lFSujcqVJX6Ssa0OVdKEOYqMFgiWvtO3ZQB/0hfkw0CI6ZRXOO7u49/e8nibVh9xDHuEddr/lDmMaRxsTpm/WzwiWKfNPhYwJ5pcMR94gnqQ87Zjq8xOc8mXgwWEtzYH7Evdhq/98aS6b7IugmqZ8qERn7oHkoQCoaXINLy9DSjY8SPcGjudsl/tgsDjKd353i7JAMB9vupzySztuJ3GX/aQ5om7XUZ8eLTNetrgT3XKszzVm+JJvmAq9KOyrJ62ab7Bv1OBGARCFQ2Q96YfBQhd0mSCbqpO1xKsd197o3Fa3nTP9alCqul/NPUagSzM/5PLP8+mb/3hqgjWkGZNMjBPShtWdHDO+zRA9Ut4FbEkNMeImHfGgv6wQaNMB/QrvYGf7eUunqwql0BCw595cYq3hbjp8jN/tW/JtTGrdAJuOtLzosD3X0AGmkIKj9XWJLZo7chfNmajqzHtBeKNgQFfWZhqM+J02sGqEB3b
 +NUdKveH
 WV4eYOLP1nxKbpAcsTfZgb2murfPQxmvIImcKOUAatu38JnW0nv2khWW3HlEjrflS5ZuFELTEyy3O8n4X/0fYp4bvJ+MaBksVnRSYJlIwuW1Z4sjzjy+HoDi1SQC2UOSe7lgR8lqHI9ZHZW95AS0sISHiazkGR8Eeowi7QIJSZMWinyxiE/ll6/wacOP+skTB0bkV51op3f8GUgQ3ybin7jDwtrANumMS2D8CyCN06Al50bR6ax0RCBzGjXD1kigwVyAli13+nkwTo5aHYA/dv5/PbEAHUOSFpEWy/PT2tXpUWyRYAz49e6ukMIB3VjJLxZM+0AVAjUzFYCiVIA/fUOVH09ZfcZuuVZch2C/hi9dcJPp1rdy/Wm7EdkSctsd3n5ahEHd7C3/WdLZNKgW+bEsB60UDwCW8bL4uYv8SDE5RXK1A7i45DL0SNC2Cg/UxtNWJatpBRhLJkthGQZWKPpKeDIk5oAs8SpAcsRtoptxErsNmjfMnBpbGSc8oZwaL6cPR9JiwQ0f1wN4FCx2aygR+Lj1P6XwJ5FGlUpwGH0X7rA472NoVu1EqfhI/jWhg9dm7VGUTHOb75w0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

decay_va_pool_node() can be invoked concurrently from two paths:
__purge_vmap_area_lazy() when pools are being purged, and the
shrinker via vmap_node_shrink_scan().

However, decay_va_pool_node() is not safe to run concurrently,
and the shrinker path currently lacks serialization, leading
to races and possible leaks.

Protect decay_va_pool_node() by taking vmap_purge_lock in the
shrinker path to ensure serialization with purge users.

Cc: stable@vger.kernel.org
Cc: chenyichong <chenyichong@uniontech.com>
Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..676851d5cfe7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5416,6 +5416,7 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct vmap_node *vn;
 
+	guard(mutex)(&vmap_purge_lock);
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 
-- 
2.47.3


