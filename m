Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AEC3C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262B76B0093; Sun, 12 Jul 2026 11:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B5F6B0095; Sun, 12 Jul 2026 11:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102776B0096; Sun, 12 Jul 2026 11:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9D5A6B0093
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5049DA08FC
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:25 +0000 (UTC)
X-FDA: 84980549010.05.7112830
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 86077180004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cZJXtRPe;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871123;
	b=f4YVmdpbLPl0lh6DB5jnjtDMzlNAbTgVzPtIey3za5G7kLRLB+3vEwqfAs/wBzx8u+pHz+
	TATCdmSaG+eL4oHZUb2x+ldbdiVPIoUMNVijXGQwgDV3yBJHkVgvNjxIYMrIef+di/1xEV
	5bEfPJphp+Nxu8yKzsmffBU0IXJVBhg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cZJXtRPe;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjJw3wlBuqXvLpxi0GmvsmDJYE5o3ZwGQsOl9zW5rZ8=;
	b=JXQCTTspXa7UDvUb0FbcVIkyVDtYDZGKigubKV6lfFoD2VNqygbDmdo8R+kkNVo/fpjXMs
	1MY/xzMjgeCiFcdFdi9tIAL2HQB1d5wh+kI874/mGuGNrJtg03OYmkSTrHvzem20luqPVO
	IaNCAY1nD+UlB8MVePx1V4JHgfO/HP0=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92f03daaa97so43817785a.2
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871123; x=1784475923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zjJw3wlBuqXvLpxi0GmvsmDJYE5o3ZwGQsOl9zW5rZ8=;
        b=cZJXtRPemfecBOo9Dqnz7a5nL6IMYH5wmHCgzOPLpcvvKVGzEKycHQos1YeNia5LWc
         GHL2wl0+IQ3aYx2LgL3/fqArVel5UehXKuLj9h65ZTG2x3ngwFpbjpsTC4kro79LrJVI
         z/ARCP1VyAajqmlj2M61rLyQfETSJRLrKJfpY712dh/Nq7Mriz+9h35Ui7V0ro1LFxiD
         7y1/yNzIlfhVzOSvah9Ssq1EqwhzPSQDDbTeHqJb3Z+hJisr697ULdw8a7M230w2xL+C
         Yv9sd4vC7sUAB6GiukZ6lqp1UjukRFLGhhs5BLEvhnsgGf4vdN3leUDET5JbJFDSVDXA
         0OTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871123; x=1784475923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zjJw3wlBuqXvLpxi0GmvsmDJYE5o3ZwGQsOl9zW5rZ8=;
        b=MSWzxduIiWO9R6AjqJUspGWnP2bYWA+8ZsQvrDvRu7/xv2zmWGCvTtMwXNyuvWaN1T
         qClATs+NCdB+0d2QVV2fnU8KiZwCEH4+u+Mh1Xa2rblaEn1wg8NOL7aD8G1Xs7uGocle
         oDYpmpb5qFRkhbPjOEChurSXsuYlqrE3vVo8juUYUmOQ/UtGBhzyG4oUzFAf6SkltbSX
         8D6uT167J1Xtl6Uxa9cDEiHHURXmuBGDQPUIm8Zl7vkLe0lFQjjZCKMxfEHsAUpnRp5X
         f7WQFo2v4/o7fegK+5kcgw+HfeAbVJxCJH51D9fHQl5CxUMTGzXjJeZeZvGBCasdOwze
         Mp8w==
X-Gm-Message-State: AOJu0YyNfAcM6J/lANgj6XS/6kRte/n3+xrVXSHZSh3JWYxn2u/VtdpH
	NTU+TWv5cEu5D4GsNETfOBmthtTFma2oZhWqidrbgTAmTmpOcp6xs9pGicdRx2RUA2+5Tq0WoZV
	Yrfjt
X-Gm-Gg: AfdE7ckypSH8VnnOvlV9X8EmdLd7HbaozGWE7XEOFdDtV2wAaU/h6pOTRCRFGwg85iO
	Z6mrrYm3LvLa7MaUxoq6F1BZoRevFOZJSMcHbgh2QUoflO7d9150naxfRAUDMUkr8t2KFrUplvn
	o7gbQsq8nRLGBXBJrzLWMMdav1ZIPDw493MDYytrcBhQQjeE9qedESXWqEInrXMyTk7jy/XelXR
	CFNp9V1fjJpnm58EBMLCNgbMOlt9dY2y3FcgLaBeMwWwDOpKTTl1byfQN69EoVZB8EDkslgVw0k
	e8JHXRFrvVb1nsuL8FwwbQDBEPcvWOmmHMiCCMS0BvBym6lMTuzRpwY3+iZb3n/Ggj9oNx1K7Gj
	OPyphH50JQ10zEiScQA2301P3a4t+EeAlxnkeBgHmPhM9cV++2EtRBzHzOk6on8uZ6FzhEzdgMi
	s4uVh6dGUQLoOEdTvhQIHFXKOuE2xUciGenYshJodRxFHLC8yFxbey4O9L0HBKK5qyEozmpjiqY
	w==
X-Received: by 2002:a05:620a:4711:b0:92e:5610:e479 with SMTP id af79cd13be357-92ef2bfd741mr601996885a.52.1783871122600;
        Sun, 12 Jul 2026 08:45:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:22 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net
Subject: [PATCH v7 04/10] mm/memory_hotplug: export mhp_get_default_online_type
Date: Sun, 12 Jul 2026 11:44:58 -0400
Message-ID: <20260712154505.3564379-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86077180004
X-Stat-Signature: jc1fatn4f8f4fkwtjinapz1tqxgmtbbq
X-HE-Tag: 1783871123-22995
X-HE-Meta: U2FsdGVkX1+0MEds4r66MJ1IUYiIVmr9iqN0wuiLDifd5mQZvWi6fUEJK7iyxQmZVUY468XXXeJYpMigbxGuX2d+zHDXLdp8WeZyJdPVt+MhJRUl82ZukTCvK0nlJ2z6rcC6PuLuNRpf7U4wQJa97xdhoLObHkoFZwFjp6i5U2US372fHsdUrlp+q/u0TaZZduhw3tWihjjlWAjM3BdMkzZk63C9Bv5hlUdW9aNbmw87B5DC84URuv1uPEa6dAdvpIStfXT9IZD6yhSZjPRniKAYmsrn4nw2PAiKmVcxidEcOFPuGq33zYO1CCeUYQatWX1BMT51Re/I3VqcR1GFszV7sJqQNVlNwSU9/iPw0yFWb7xiVZT+GHdvMNIEd8UvpMU8FfnlTF1HDsuL5/9CRwEO8fMyFBlH8hv+my3YkmJNWgfHlXzZVsSw92TS2AcJf+iHkO6j/eTJtvfKSBxQl+hoiruZsd1qYVJEh2jpKql0IYlcs/F/clt5LFn9889Y1j5PGlfEmlLhc7lWySAmZsfG4Ti0lzUPDP9muuzMgI9ITUsXEjveNbb0Q+hKJSVGnwTskgFL4d5bJvhuy62CyOynVGYexwFurwsAZa3HRzZq976yb2zReMFbSIw/qOrQ17tLqQ5Vr+e6jeluLTaezcnJR0jKCe7hjr9TeH2gFzz8ufV8plTJ8JUKwBvxO6WaDYOBP/Oh+D+AJGJA4xEaizNCfJInezY3XFWXYMnJhwgHJ18GRrvbbFPsBQXY7OrlFGhiBpVGDY6t5QvILxM+VglZjmwuCpnupQOeQFGZNIjf2vtYfQhERR/FIg/y0VWgMczlfGz7e292x6D87JK/FoHdB4/bILMNq5UTX7g+zxJKsuwBablVuHLuQ9zb45l4+AH5blRi1aYYVYljN6QXl4UCcGtyr5PobhbE0ztlkToosCF+Qj+fPmyxaIq9hwCz9uJ/yZ2zGw/NmTRgAnO
 Pe2fqkcJ
 gp/fr235Ye5WPuatl3OXHs3vXeiv48jW1To+Pzw2HEdj64iCbigqkp+6K7u5W2ZPZmqag+SxOpB51hb06RxQUP+++65sUKR2Lqxm0VccifQ6GqFitEsa7zRr+SEXudqs4YeWWKDixmYW4FjzOfzRlnztRNRJ7jYOw43U6QZK2QrjkGERS9cNApuINSkBbyMLhAjW6Ggu2HTW7owz57IItN6HH9BrHO1hs0LkmjMdNMNsgMr9SCGGFMoLPKbAir1wMm0JwNHGQbSZgZY580cnXuf7a5onl2e8w6H2O8+oNU/kZj/ZR2fhrGxdxzbrM8ESW0WgosHJl00/b2tLhWQJd4H8wfVaZj8afSwpCS8tZlaip4/Ma+6BdlL+vp2FddLreluAx5AKgaXoivxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
and the mhp_get_default_online_type function for hotplug use cases.

Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
the same driver code, and chose the dax_kmem path as the default driver
path - making it difficult to require hotplug as a predicate to building
the overall driver (it may break other non-hotplug use-cases).

Export mhp_get_default_online_type function to allow these drivers to
build when hotplug is disabled and still use the DAX use case.

In the built-out case we simply return MMOP_OFFLINE as it's
non-destructive.  The internal function can never return -1 either,
so we choose this to allow for defining the function with 'enum mmop'.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory_hotplug.h | 2 ++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 8f6da2656f4e2..f19893f5fa948 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -317,6 +317,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e625529baf996..be8e8e2cd1535 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.53.0-Meta


