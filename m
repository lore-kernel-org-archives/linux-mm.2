Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 036E7CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51F78E0012; Mon, 15 Sep 2025 09:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C279E8E0001; Mon, 15 Sep 2025 09:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D548E0012; Mon, 15 Sep 2025 09:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBA48E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FD328606F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:51 +0000 (UTC)
X-FDA: 83891595102.21.8CDDE0E
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73AF1160016
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=djUayMpc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943649; a=rsa-sha256;
	cv=none;
	b=w8NvyiM4hkyd2UzNHQkYFMSZYLz6LWDvr6nlkDXV9iCuHM4hiQe9fjCC0SmfYgDHJuyuWc
	aT5fsuC44ho+LOmFNgO03DQqjByAGVIqCuO6SvjZULZDIChTO0lKlSa/KkiwR1WtNl+5V+
	mleubp5702OAMoICNhiok0Q3xlFUPTc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=djUayMpc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jt/2LWtHGT9EgRO0DryBuNasAbNViAyk/FJTAlZaF7w=;
	b=Mg/vWpXUDjaF4nS7hFFrbiLiuCOEjXLe4fw3DixFSNk3AdskMHOmiJ0breSaNsUavkxcDh
	EIBKpsCmuglqq501v91t93h8Y02w6CMWH4QvAluLcBVqb8lEI/artl625T7JamMykHxJNv
	+WR//QKU6rIQLGPyYjAoWDC9CcSw76Q=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55f753ec672so4662670e87.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943648; x=1758548448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jt/2LWtHGT9EgRO0DryBuNasAbNViAyk/FJTAlZaF7w=;
        b=djUayMpcfx1wiKl9KHv0BDxr8GJ2jyUgrAy8XEmr/+vBbwQ0tSndpiyPCMH9sWExh2
         Ymbu8FsNTTXbylaSjf6jcbnVV4qhXXoBzrMSROcYIYnEJkfe+i6uwqvyNlq6V5AEwfsG
         HrH0ROI7I9T5yKynWLMJ9cJNaQafwDw/4s1eeVIlbdkwDsbEl7WrSnHirCEjpL7SzLbn
         BnH7afVuKFfkHngHoEkfVPg+Hr0L79IuYgYL6pKOcrCDrRbxZz7ruiOcSClFkQx39GPX
         56ZzrF70p5Zr86ZvuEOGGxmTwcNA8vdEMKgorMCLjy13V1B4f9fkiyyonfkEhHnQTvtK
         diyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943648; x=1758548448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jt/2LWtHGT9EgRO0DryBuNasAbNViAyk/FJTAlZaF7w=;
        b=c02H15KKgiZZWJxiC5o3WKKmfrAk+luWdT1r+sp8lg+I2eJfAfNj2Zr7HAMFOhKHij
         GCyEe5m7I4QkXWi3Bcjv/xa0Br6cuu2u9aM9puAYK7F7fCcg7iQZqxe81mxVemQE3eD/
         hR7S8xzhkJ+DXz+HyEJ5IV4TKbSIKn76BSbGY3lOjHbYGKp+iPWt7+QHN9ljF4m/SO/H
         RQl5zK/yoFgDrxjljBrDodsdoHk/YocFqh59hDTnlVD7M0eRoE60SUJOnx4o6y5lTS8G
         QZ0Ag95XwLEkqY+vbgdXmEq0XquOfWwY61op8EQNSsKrybunvnV36YoKECjM4ZvF2prk
         W3EQ==
X-Gm-Message-State: AOJu0YwQfqfCwR8AYmGe4Vr/DqucHw00hJ0XDh1amGEV9U+yGHWR9cVg
	XYvcAjxlDEMwvUq/h86TDCt1jfd434hFQRSHPhOKZLmK52hh9OT765+W6BfQBw==
X-Gm-Gg: ASbGncs+jh3Vvw46fTIPUJkmCHnqyL1AHReSUNzwQHShLRIt3bELyF2O+Rk4FU+o7Ym
	0OMQeAu6ZmJ9Cvh4CMk/YhVHb/jniBoOKCpcTCx6ePQb6Ndanc6BNb8LetZdg1Mb2L2pxO70me2
	gLdi/bYKF7yZ7vUqIUs3ykMxUT8d/YoTy/IxphOl+coqhxXYpKLS/W00NhZCnQaTWOlBG5z4VvI
	IVRh0dsDwE1H3Pi4EXPt+U4RMYY2g4r+sdCe0i1Lac1SUL60RbCY7sNvDEJrjCO4lG21vqJ5E9W
	lJrLA+2LtZM5q5iD0hQEOZDPWJjxKtJYOmw6s2IobbhYiKlUSTzhSqMP+mhWNljR6awqQ8owMMW
	dhuuay2WHvGk8kUW5SykztYsuf6g=
X-Google-Smtp-Source: AGHT+IFsE9P63lZm6RN6AXK4f+5FSZlBhHgIi0Y9I2WY4Ie/SPWsz/NGfvqkJ+OOyzYdciXpuKcc+g==
X-Received: by 2002:a05:6512:2608:b0:570:8bc4:9545 with SMTP id 2adb3069b0e04-5708bc4a015mr3017588e87.4.1757943647381;
        Mon, 15 Sep 2025 06:40:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:46 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 05/10] mm/vmalloc: Defer freeing partly initialized vm_struct
Date: Mon, 15 Sep 2025 15:40:35 +0200
Message-ID: <20250915134041.151462-6-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73AF1160016
X-Stat-Signature: u5htcbmmifk7qshd6f15w9x6qc46abp4
X-Rspam-User: 
X-HE-Tag: 1757943649-893941
X-HE-Meta: U2FsdGVkX18LbZXEMYGNTlopdHG0WYwizlnlS+DayO/ESoGjlq9a7iiGJJmLbMAoa3I9tvw+vT2uEPP0RaUHR8ilgKfdlByzY0+5ZL0w0MmsjxV497eNCdk50lzOfDWmy2nv/853iq0U3yQOmZAF1W+4ds5yzZFKsgyXHcawNUbbcHW7Ckgk7VEfq8a4CjCU7J+O4kodjKtw3GLAOmwMd1/d9QNgt8Q4zrVbK0BvMYU/EHcKFBSifZBVzlA37Q1kM9q2h6PXyOPKv4Cc6SsY2w/B3RwQMupyk+tS+P6uhQuQNU3CUdN0Mo7kom7/W/RrEHrv0dpCur2P6Zk1Pt/TxS7XDhHOkFMzPcNu+21iicTFjisbExDykOd73sy9Y9br0hHA5LQ88x7Jq5HZ0ZXoSi9M9pPB4UwvFh1CT5mNu2bSMJRKJv5JlTGSSd96aXdpxw674lxs0VYoAe6jGUhYwyqqgl+avPgdnNGoGHf9o2mjpWvrOzvpTGwF4QJfugFCP1ALeLCl1H6A2DwkQ3SZmNqqGrpDkF5Z9brTEpB/YKclZ2PZsN7nMm3RbiYTv6X/VttDJcow5vkB19knpbRK1ET1ocqq4nXu3zIBsFXnd9vT5ByAEXHylgpYd56F6OqDjQJKi7z2VE5ZhDFaiovVveTXTBkgNNuFBNspEuqoBzvOIuFQw5rKb4R6AokqAoD8drW+dchvW6Brylczxiuli8Gw0dbxPuyYm4FmPs5e7uFPFpvUD+/eE21YpbQ6da29Jh7kvNz3DrT+ZsMDnuITPZv6dKIc6gjUAOZhF+ypQUBQr2iI0/aYsHg22/nAOLu4/69/+9UjenYHUfTuMBtaoCjTAAh2xps3LBGd4vp9ujzoDiwOqxi4mrWFdgyP2/mud7aBvKHsI4PqNtn++MFkXE1WCFMp9giuJIYezbVPv+VZZzt01zoiBYgo4uaTZpCAXkx5Uc23T0OgvxYxtnm
 WndUtNQT
 HuCSZW3xd31Phv+3isANCvJv+/pc68cieAdAVIPHW7vj5Z28QBi0shWECAiFEZp92bMoXaCiy0oL0ucY9TNr16a7W10Ao+vqJR4+wqt5u1EbFkk/OJKHk0pr4fCy7Kxtb487fh5QwzqqAl9hyVlGr2tM7wXCFBsq0A4phY7lgh2Ar5nguIZre7ZLlGoAdbQlOve+35uJeu0NRyxgvrxCSYk/EdVuSRlZJ2rWNwtrlHMjjgLMsHv1OTmuU0EcIiGC+vOAVZ4NLs/m1yEicoRNxPFGpD5dEkChCDhhLl+A0nY7PZjS292D/4oeYJfMcqcm0TioCkm37RZOYbuoexz0Cl7HsZI6Vcm89Ce/OHfkGsRk1SVlDeD4/Mmc9njNAEQI86tvVLH9LxmZeACUppK/3XqYftCGYFUm1k+l6AKvZRuOexk+8kw9e0tcVMR+rRmlhSBVev8zncTJmImS0FunuX4HWDXyVvJqh9QzaQZ1D9lHgHSmk2dIssnocPcKlDlGWcUdtfFzBmdPH4f9T6i0Us2EPgDaCE84mBDeKhGv/37pJwjgmzF7GrXfMNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc_area_node() may call free_vmap_area() or vfree() on
error paths, both of which can sleep. This becomes problematic
if the function is invoked from an atomic context, such as when
GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.

To fix this, unify error paths and defer the cleanup of partly
initialized vm_struct objects to a workqueue. This ensures that
freeing happens in a process context and avoids invalid sleeps
in atomic regions.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/vmalloc.h |  6 +++++-
 mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 2759dac6be44..97252078a3dc 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
 #endif
 
 struct vm_struct {
-	struct vm_struct	*next;
+	union {
+		struct vm_struct *next;	  /* Early registration of vm_areas. */
+		struct llist_node llnode; /* Asynchronous freeing on error paths. */
+	};
+
 	void			*addr;
 	unsigned long		size;
 	unsigned long		flags;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b77e8be75f10..e61e62872372 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3686,6 +3686,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	return nr_allocated;
 }
 
+static LLIST_HEAD(pending_vm_area_cleanup);
+static void cleanup_vm_area_work(struct work_struct *work)
+{
+	struct vm_struct *area, *tmp;
+	struct llist_node *head;
+
+	head = llist_del_all(&pending_vm_area_cleanup);
+	if (!head)
+		return;
+
+	llist_for_each_entry_safe(area, tmp, head, llnode) {
+		if (!area->pages)
+			free_vm_area(area);
+		else
+			vfree(area->addr);
+	}
+}
+
+/*
+ * Helper for __vmalloc_area_node() to defer cleanup
+ * of partially initialized vm_struct in error paths.
+ */
+static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
+static void defer_vm_area_cleanup(struct vm_struct *area)
+{
+	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
+		schedule_work(&cleanup_vm_area);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3717,8 +3746,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		warn_alloc(gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to allocated page array size %lu",
 			nr_small_pages * PAGE_SIZE, array_size);
-		free_vm_area(area);
-		return NULL;
+		goto fail;
 	}
 
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
@@ -3795,7 +3823,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return area->addr;
 
 fail:
-	vfree(area->addr);
+	defer_vm_area_cleanup(area);
 	return NULL;
 }
 
-- 
2.47.3


