Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677CFCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108F26B0093; Fri,  5 Jun 2026 17:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093FF6B0095; Fri,  5 Jun 2026 17:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C336B0096; Fri,  5 Jun 2026 17:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEBB46B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8470A402BD
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:23 +0000 (UTC)
X-FDA: 84847125006.03.2EF027D
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id BEACC40002
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZuOuPHmX;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oI6t/rke/+VLpdgjZBrnvU5+vhrLOr9MvTf8Ltd88rk=;
	b=TwemXlReI+yQ3BTs7p7buKkSS/svmMYK0cze+KEd8DsmeYtz5AL9B3rhTdy50J3QZRKL9/
	DbvBu8qHaV+ZsIGUcILr5dxcgUgR/hlpc1QPih6nCTSi2y+e1bNVn/18weqWxPUc/F1f3N
	fsBwF2qJqu6ABG9AyTYztReHDGDDov0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZuOuPHmX;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694361;
	b=hQDsr6SjI/hnoPsTJTokMAuYmVIgFGCIgI0U3qaMvnTU3n+0G5kG45Mb3yE3gI9ZNqkLw/
	j7Xsj2Ch/C+XRnQKE6dEiL3js2P0K2mrKh7dklX5XnkjEjrlmobtkGWZkkxerKGqvXd0XY
	j2LKXsdYbYetcitD9H6GPaSV7bq7NqY=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8ccf887de87so27329216d6.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694361; x=1781299161; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oI6t/rke/+VLpdgjZBrnvU5+vhrLOr9MvTf8Ltd88rk=;
        b=ZuOuPHmX4WenLuAS4JG4RdOo8EI4GKkKcmnGE0eb4NR06XkEp5p4peQU02XN4UmPg+
         wb7qCTZDW0WsntOXDrFW5QMINJUH4gPV8XaYzbfOZBU6UwscR+zsXiGqUwZIFgQHY4Zk
         sScRnQ+sAW/Jy02FG182ndWT1jVlbOFk+Wd5dzgCIcaiNaQtTnBc3p+r9O90akPgrWlH
         TWxiwBscRscEVScfteENMi8pdMc3pT6DU/MWUDlRYVflNOAs5EtS94QCGMMsCTmuv29P
         gZYJlOfpTSwQxNq4L3v8uuuGSeYfL01h3TXqJsqMj2J8y5tG2osoGm5TvT9xYGIlPav1
         7ivw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694361; x=1781299161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oI6t/rke/+VLpdgjZBrnvU5+vhrLOr9MvTf8Ltd88rk=;
        b=klaolZ8sp1brHn7LVxV2cAvBzALHIYs7X33tExJPejkbPZl8HSitEZQMgMrx5ZiOTx
         LdgABagkw0hZGj4lgw7ts2VtQ1zMjnS4XeKmG9V26UZvY3sedTf1jQx6CEOlrQZ/eObw
         vDSptoS78s+MhP9R0FPZb/w6qUbo+TMxwTkhRdCnwAiy1iqApoXYl5QTWkGFCVb6Y4oS
         KKxqlAx/ESt5hL6Bi1+xOiyzwTxlPYGfORMDCw1P4lqDLKP/Ae5jAwU5FyP2+38gOHSM
         Rg/NuiYHf28w8vAihNE37vwBTzIinTbRL3edaa/bKZcT/gMVUgzHTR2iVapXg+6c+F6e
         fQsQ==
X-Gm-Message-State: AOJu0YwW1CwLZnjksDpqYQD5+iIJTfzyoP7wBj7e60vpm3ewDTeZpNZc
	CSbou8+OUlAPr7q5e611b0fNh3d5c+wsgDZ+W+EVjobOSbCeIh+LQiZ9Ht5v8Y/M3qWM9yvi0td
	60+7is8riKw==
X-Gm-Gg: Acq92OFW4XXDyJOwZpQ83oQoHR94PP0BF3NxePbkUgBhJzNTP2Ve3y0zVXVTBP1fFOV
	N8qX9JH7S+VtJOPJ6ZdGNTGC9ihCli3tn9jPw9l63vE24GYHwS8pp/GRJIHbhTvX+XpstYIPSOy
	FDARVOxwnePDra3ll1e1uhOMVk8NRMDb1WlIs4RnCISLb8DRv2Hptq70SO0PmP99SwT0/qNixGy
	IIAvAJDWPkaXsHFkSi0SQ8wK2XDfLWsEiz1zKHzYGO6WT/gH2VzFHCxGwlpDyYkVEheARQ/FAJO
	HmAvFnBdPAxPY12LGlrpz2vWbd85thPg/V45ksBA3It/Y2KBlM/ovxhUTAd2SBRTWCuy7iuHVBn
	z7OZVxOQvK0gndgoFxNZ6LB2ZoTORiChRnxcJEkIqXvIqpaelTOZrHubuQLNeZY554jdfiijqgt
	4C5VcdjrZajn5TrYFy4j+dUs5nwrC8XQN1Y6WfFiHENMtWvVgBrukuwYe1XIJL6SP2MVNYzPjG7
	49YhWz05z/z44n7izbXHvi2mcLxLHLXnQ==
X-Received: by 2002:a05:6214:53c4:b0:8cc:e8f4:1630 with SMTP id 6a1803df08f44-8cee614991fmr103632176d6.30.1780694360689;
        Fri, 05 Jun 2026 14:19:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 3/9] mm/memory_hotplug: export mhp_get_default_online_type
Date: Fri,  5 Jun 2026 22:19:05 +0100
Message-ID: <20260605211911.2160954-4-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BEACC40002
X-Stat-Signature: cp3pueqzzo79fkip3weznyzwfhrkdafk
X-Rspam-User: 
X-HE-Tag: 1780694361-103781
X-HE-Meta: U2FsdGVkX1/MQqz854qxyPhtmCk1jFFcU3WrviNMQhlRilCSntcW5DWmw6ZuoKMXCIHMTQFxRUL12kAatHfrKPc/AjH4r21OaIjR3mrOtJ32Wy819ZV2GHe5bU+FDCoyBTToiNZvJN8Br7p3dDb3ihBprq+DgqHlZq11b8ERDm0hFd575b3M/V4KOQh1Z174rxqMCXHeSPXSYQJHpDLfaTmEyV0hwAyoGyFNikbNBcF9Ecyvhc9xbGUcruMybCHdVGa7LYuTpp2SbGn3jQ6TPcbJnRwmCpveiKuLruwZnXjvMXcmQ/xAHvHpJiJEy2mKsbIGUxeYqAc1YYrf2b6LUblPGlxxPy41H53fbttv6vT4kdv3IA3gtaiF1qlwOPoSKdLsfN2joNW5WfjDU+ESouPbfUOAj49/jfpgt92sC8OQfLXrxFKSlF2uvyzXE7s9MbkoHMwmcSf5XGnPUDsgNsHh8YZlw2HgzxCJHTRsQ41EYwK9AORVu0UodTbJQRg3m3XsecQDEwsRa3jZnWEvWB7VkEKoWqQi+7CnUQxWhmky3rWIwsoWwvbvBAGlFHzbdwI1jKJkkTpfA71+THvH0gzO6dBa2IREyiznfkON1GySv5bVKNehomQtTxB7/F2eIi7w6bcHMvD/xCTzcbtlqA+v4jiqE+I2U5xNriVIjd3mT6ktmp1ho49cCY8BEFP9aaTZIFVy5fydbH3w8SdLRSOZoh2A/qYJKXz6HzMjbQd+L+k0cDTpG7hB3+7pA7tuCjvxBxbmfZuCaOD+B1NxsWErQEq662QS862XmbaTY24dhU00BsHN36jTM+t3SMN9MBicS1vb/qpFJHT4mblnf/7EoJaCgzeB9joqsax6TNOIrT7FKTMy6yP06UHyZDTehxH1oX20sNeBqqiDSBDvCyW65CCeGm/THPJf0UpXSX4QNf/gc6gSLH6k+nmipvoNQi8LEAjxy76iXfx0/3+
 h+q+iQ9q
 4gc+G978+oNI3nTEgSqcW+FJI4pZWzUBZzQAMCR+hjpzTyIjRiT3uuCNfoaEw8kF6mhqS4VDCiPk7yXYIXT//MKsUehcC/hG3j6KjN6BzE1MyohA2uEMi+W6/W09Tp/gEhFZX9d+g6iwbTFOkKQDuIgwTlWnIOPFzrShTY4JH9G2oZn5i0c/i49Z1EZIDqNx9HJ91uxVqTg3s3rJr2iLiQVr6jaAHfpIzD6keyT8wyjZJ48M1ptJLYK7O4uRzZ/edJPWV+ZLRqua5OJLG/uO/na929+8d+7mF/RRTMTea/8jXIeT5mG67EJMyBywF80GcStQ4jOknMa3U9XWRBvwidbCrX3BXdTAVxWrY
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

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h | 2 ++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7c9d66729c60..f059025f8f8b 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -316,6 +316,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6833208cc17c..494257054095 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.54.0


