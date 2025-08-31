Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A78CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC90E8E0008; Sun, 31 Aug 2025 05:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDBB8E0001; Sun, 31 Aug 2025 05:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856D78E0008; Sun, 31 Aug 2025 05:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719198E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A8821DDC12
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:42 +0000 (UTC)
X-FDA: 83836555404.16.603312E
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 40278C0007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=G0jkEGST;
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agcUJTbetPLLC7T8VbmvLYEfBB6utcDRFF105PwkvnA=;
	b=8eGpB3rUK31GbGa1Z4xTn/VHZPSx7hdaqsCfAj33G02uyu5encJRV5ZzR2tjLZQJ9umGht
	J3HhDE3PH1+Ov5gilgYSMUCcFk3YFYSJkWiS1AO5xQhw3oTXK6DAwi09Cynga4lZnFFLVb
	nXR/Ylnge79Miy+2ICgOXa/2z45CmQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633180; a=rsa-sha256;
	cv=none;
	b=aRT90rEJRfDKiThlcsIW6uG5BAgxx4CIU1x2Cs4sQFDf1aJcdX74uAKofInI39780DOyxm
	Sb/8UCR2UiP4mHD0LMUgcWzg4C5UiYZLsg5bb4MtKHVyfP4EP5BNGkbSBlkl/YiRjk8gxP
	JB92yOcwAj7vb5IZXwnDz+L7mV6yLyM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=G0jkEGST;
	spf=pass (imf22.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb72d5409so608145766b.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633179; x=1757237979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agcUJTbetPLLC7T8VbmvLYEfBB6utcDRFF105PwkvnA=;
        b=G0jkEGSTb8RMdnBPYfKrz5NXQYVYNasQUY1/xPDMqgMTrMYjMENNvv604+Y4FP1hPX
         AlbIBY4L5JVifRP8LLtQYmruPrLglNsTMoIqj2n9zhwtI9BudijoPOd/n6V+JpHqsBCk
         mn/uStyNrlV5jB/d2CrX7O8O1bXaLcCnILHf2ILG5cUKRF18aYRxSJjh5/tvCBUKAngE
         wISXBoWEp5NDD2llZo+Sww/OfgpVqqB4uhSNa4BR1mB1IDTMSFaIGfONi1SUIl8zrGdD
         h16ZtPiQBMLcmCZgy9Vbm22g+4jxUOR7Qv8HT4Inziipgwy0u6YY12TsyLwjL3k/pRLI
         kijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633179; x=1757237979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=agcUJTbetPLLC7T8VbmvLYEfBB6utcDRFF105PwkvnA=;
        b=USoPdxfXTsS084+w3dxGjs+z82GbIFAu0OuQowHxv+DEDakBSUOecpL9Vk4wdmocea
         6XcjfXJAGwK7CTd8wr0YjrawRh9l2LXuSqj7bQc/BtQjPpFmziu1geIdSlWcCECNK9sT
         Tx3vK2a+v84ov/aiL9LJTD1LoDu6KdewNy3tGbjaX4kxMqDV2uBmtz6Gexw9epb5YGWQ
         G0hz5uhE1QKpJOWMCG0LE8Uq8P6M05Ri2elfGY9XNUUDEjIIUWZCsTzP41kJNyzw01Ji
         Y6+kLLxhLACPcLQn0Ag6BZZqQiOMU64DuVLVXDlxiSQ5hMqd/7MLtAYYA/ZEUQCrFuDj
         E6YQ==
X-Forwarded-Encrypted: i=1; AJvYcCW56d1D6MGyrs4BKZhg3dkBftxBIk/fKamL8XKfBmtzQUWXG3Y4jc2f4/luMEj94AbYckKgChpzEQ==@kvack.org
X-Gm-Message-State: AOJu0Yziyd9G0v6DLfpk6rg8uc0d0Yh02CoO1SHOjT91Vv51vOxKXg0e
	yzJXHlXuUCjVWf00O3GyaWFOiOPXgPv0wdbzshTFCTf21DWHxfDVz48BPKbcQmGGeO0=
X-Gm-Gg: ASbGncs9iWCytNYz1XW+s8qFJXe3RRtvP8yYz1g6cxW9DmX7N073ATf45LM0TWBARL4
	q32VZYy3CHaDXJV55hQYDtI1Hi9eLtGQXToc/YxTFM9JCyTbw6OfTsjZpxFgJpVwLV0hJR045pn
	S0gkFv6aQ8lF/JQ9J1UG6sAjvaH/fhp0P6K/Xb82qgnPAWYAV4qex2Yxh73RZJ1oIL5DH7xTjkF
	EwGOQaew9nr+qAJg+dloAqHKfhjM22ICOwPv0Ud00RZJSYQrykGkyylakx676ewgznJEtgNxxM7
	cLebAq4toEHXTsjZoonz8LLPuPfMgjAwFUyCBGYRuoQuFOT6eGMCqHI1U9xNB978gpzvnK/Mhx5
	YZkGVg/otZwDY5V5RbmC4e1gwbniXL/O8S28uTZxSFWAZMQ+abBmI25OMTXZtpz5CSk56UNdpZD
	Vle6kTNlE+vFxOthSE/SHQ/frziZ1DMdk/
X-Google-Smtp-Source: AGHT+IGOcaYq6pdvf8qss0FJ69VWFSUVu6c1gqKvRxFyz1rOmWyTevdbJuT1tri9g/lRb4gUoiv96w==
X-Received: by 2002:a17:907:3d0c:b0:afe:c099:aea8 with SMTP id a640c23a62f3a-b01d8a266abmr378742166b.9.1756633178673;
        Sun, 31 Aug 2025 02:39:38 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:38 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 03/12] include/mmzone.h: add `const` to lots of pointer parameters
Date: Sun, 31 Aug 2025 11:39:09 +0200
Message-ID: <20250831093918.2815332-4-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40278C0007
X-Stat-Signature: dgc16wpumgbw4nwnwpj66zqnsfrfnxxw
X-Rspam-User: 
X-HE-Tag: 1756633180-238280
X-HE-Meta: U2FsdGVkX18aXet43bB1s/57fSaVWZd4ESB5ZLkXeL5dGk7EplNA4JYfAvrIQZgvvMxd5nwgWmkhXgAaJ4RxJT7lQNWGg8gtjOFVupn4Bx+1Cz8SWn2OmA1se7RKKX9vWcPRMy78VeSBCrLvRd7LVg8mYaqKhqagpmvf8CnOe5He09FAcVSDf80xlyq9iTpWUmFOBIb0kvITITP7xY4j0UDSbRIKxNJvI6S0RUhFSwdX4UNho1polinZYAovm/kydznywhGACNKeClC1HR+q8tmcTDFXDRMMH+lBQ21TxTfTfOw5ex/ztKN6CouQvJvSwqScmA3UUrhETwqRWMjb1FSd+YeyBGfv+C1yUcel/NbLkdVxmkZcZI2etIRHgq8460C36yWJu756SByaA+l0kUxPMwO8b9VNrCQr0PxVc1ePPyzi1wLFsjBert3lqR+ar7oFAAhGz29zodJsDIQtsatqCd6R7FmzM3ZPYoVmTmoD6D7EL/RUKFCwXJNP2dtXsfMTBBJAUFzLtukxNKeJlKCb1U7QxCEfJLbPcJ0s5ofiBu0REA/YfWHXBwe47O6dDGhw42hzxE9UbUMnzuWTs1CeBiiUdXRHzJfQoo0v54JyRTKYh88QXSIR/g5kDhiH8TiHhmS/kZ0LlQMQ1WYwLqQa69tni/sXSnhW8Up9KKxDnR7YPMPVmBo+BHmQYhQ3iT5CHnb0LtU/7FoU832EeJuYRpWzS7XOvahSXFH1M+lGuJb7LI+qVw9RjP9nhpVW6Km377bVndozvS7tINKeb+qmbVXr7kJ9T8DnXma3iVXoSMGEPRQk9dUPFtqC2/J3qg2owoFLWC1elQOoN9R/4+jeWoqUmdl09DOYIJTeCYDIyACTjI8Wo6BOv3yicRRo+BeP419139j6BQAY/oqYleGBecJLidXmoBtB3B1M1wOXoAlczV1MdBmTSNJ45UNdkFNdSNTo4DPieagl0W8
 jlllWBY0
 K/WOVJbUhdfxiqFdF8iGx6kw8UJgGnye041fXCfATRItDZNBLr3drFtpW7SfPtzZdUmvpj5rEr6hyTu+pahAJ5JvtpRJsuW0i+8dUrKtl+Cbl6Q+LxPsTNobPnhXzOBxEleWrfV5Xo8QITyUhPnZiet4Obutg7+fJutx0Sh9KYiMCVud9yESJrNQdP9ZnedIrW2dHkSXfFQiUfz79oVuI7Rk3aoNSWaWuZ1Jrj8uNGQpcc+zRKw8LIgEzvion9OMiQFSh7GNtryYSwIsRzBTq4xFdS9tDBlbYDeexOwCJjld9KcsbJT4E1fBP0r2SuNzHbjGcQK1CgtluDoR06zeoSImpN61mEt7aArhDWalZ/C1wqv0n7X9DvF4nkl7kbg9xOkTDkVpxOt5q7qJBbt5y3VpgtYqUM/FkZwRJs97QeZOiuhXV/pgJSAY10thTrE6Ubi4lfZ7dW6q2HEE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mmzone.h | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fe13ad175fed..7228f3231f37 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1103,7 +1103,7 @@ static inline unsigned long promo_wmark_pages(const struct zone *z)
 	return wmark_pages(z, WMARK_PROMO);
 }
 
-static inline unsigned long zone_managed_pages(struct zone *zone)
+static inline unsigned long zone_managed_pages(const struct zone *const zone)
 {
 	return (unsigned long)atomic_long_read(&zone->managed_pages);
 }
@@ -1127,12 +1127,12 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
 	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
 }
 
-static inline bool zone_is_initialized(struct zone *zone)
+static inline bool zone_is_initialized(const struct zone *const zone)
 {
 	return zone->initialized;
 }
 
-static inline bool zone_is_empty(struct zone *zone)
+static inline bool zone_is_empty(const struct zone *const zone)
 {
 	return zone->spanned_pages == 0;
 }
@@ -1272,7 +1272,7 @@ static inline bool folio_is_zone_movable(const struct folio *folio)
  * Return true if [start_pfn, start_pfn + nr_pages) range has a non-empty
  * intersection with the given zone
  */
-static inline bool zone_intersects(struct zone *zone,
+static inline bool zone_intersects(const struct zone *const zone,
 		unsigned long start_pfn, unsigned long nr_pages)
 {
 	if (zone_is_empty(zone))
@@ -1580,12 +1580,12 @@ static inline int local_memory_node(int node_id) { return node_id; };
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline bool zone_is_zone_device(struct zone *zone)
+static inline bool zone_is_zone_device(const struct zone *const zone)
 {
 	return zone_idx(zone) == ZONE_DEVICE;
 }
 #else
-static inline bool zone_is_zone_device(struct zone *zone)
+static inline bool zone_is_zone_device(const struct zone *const zone)
 {
 	return false;
 }
@@ -1597,19 +1597,19 @@ static inline bool zone_is_zone_device(struct zone *zone)
  * populated_zone(). If the whole zone is reserved then we can easily
  * end up with populated_zone() && !managed_zone().
  */
-static inline bool managed_zone(struct zone *zone)
+static inline bool managed_zone(const struct zone *const zone)
 {
 	return zone_managed_pages(zone);
 }
 
 /* Returns true if a zone has memory */
-static inline bool populated_zone(struct zone *zone)
+static inline bool populated_zone(const struct zone *const zone)
 {
 	return zone->present_pages;
 }
 
 #ifdef CONFIG_NUMA
-static inline int zone_to_nid(struct zone *zone)
+static inline int zone_to_nid(const struct zone *const zone)
 {
 	return zone->node;
 }
@@ -1619,7 +1619,7 @@ static inline void zone_set_nid(struct zone *zone, int nid)
 	zone->node = nid;
 }
 #else
-static inline int zone_to_nid(struct zone *zone)
+static inline int zone_to_nid(const struct zone *zone)
 {
 	return 0;
 }
@@ -1646,7 +1646,7 @@ static inline int is_highmem_idx(enum zone_type idx)
  * @zone: pointer to struct zone variable
  * Return: 1 for a highmem zone, 0 otherwise
  */
-static inline int is_highmem(struct zone *zone)
+static inline int is_highmem(const struct zone *const zone)
 {
 	return is_highmem_idx(zone_idx(zone));
 }
@@ -1712,12 +1712,12 @@ static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 	return zoneref->zone;
 }
 
-static inline int zonelist_zone_idx(struct zoneref *zoneref)
+static inline int zonelist_zone_idx(const struct zoneref *const zoneref)
 {
 	return zoneref->zone_idx;
 }
 
-static inline int zonelist_node_idx(struct zoneref *zoneref)
+static inline int zonelist_node_idx(const struct zoneref *const zoneref)
 {
 	return zone_to_nid(zoneref->zone);
 }
@@ -2020,7 +2020,7 @@ static inline struct page *__section_mem_map_addr(struct mem_section *section)
 	return (struct page *)map;
 }
 
-static inline int present_section(struct mem_section *section)
+static inline int present_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_MARKED_PRESENT));
 }
@@ -2030,12 +2030,12 @@ static inline int present_section_nr(unsigned long nr)
 	return present_section(__nr_to_section(nr));
 }
 
-static inline int valid_section(struct mem_section *section)
+static inline int valid_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_HAS_MEM_MAP));
 }
 
-static inline int early_section(struct mem_section *section)
+static inline int early_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_EARLY));
 }
@@ -2045,27 +2045,27 @@ static inline int valid_section_nr(unsigned long nr)
 	return valid_section(__nr_to_section(nr));
 }
 
-static inline int online_section(struct mem_section *section)
+static inline int online_section(const struct mem_section *const section)
 {
 	return (section && (section->section_mem_map & SECTION_IS_ONLINE));
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static inline int online_device_section(struct mem_section *section)
+static inline int online_device_section(const struct mem_section *const section)
 {
 	unsigned long flags = SECTION_IS_ONLINE | SECTION_TAINT_ZONE_DEVICE;
 
 	return section && ((section->section_mem_map & flags) == flags);
 }
 #else
-static inline int online_device_section(struct mem_section *section)
+static inline int online_device_section(const struct mem_section *const section)
 {
 	return 0;
 }
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
-static inline int preinited_vmemmap_section(struct mem_section *section)
+static inline int preinited_vmemmap_section(const struct mem_section *const section)
 {
 	return (section &&
 		(section->section_mem_map & SECTION_IS_VMEMMAP_PREINIT));
@@ -2075,7 +2075,7 @@ void sparse_vmemmap_init_nid_early(int nid);
 void sparse_vmemmap_init_nid_late(int nid);
 
 #else
-static inline int preinited_vmemmap_section(struct mem_section *section)
+static inline int preinited_vmemmap_section(const struct mem_section *const section)
 {
 	return 0;
 }
-- 
2.47.2


