Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECBE9CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E918E0030; Tue, 21 Oct 2025 08:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A180D8E002F; Tue, 21 Oct 2025 08:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B92E8E0030; Tue, 21 Oct 2025 08:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76AFC8E002F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:59:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41F4A160461
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:53 +0000 (UTC)
X-FDA: 84022128666.05.D04489C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16B9C1C000E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:59:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PtOr0JvT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761051591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5VcU60xQeN7ydJcNuOrJoqdazEeOf9bmMF6YJ9dhbk=;
	b=gTOi9Y0gEI9DS+ye5bIQS+z1Q07BlrUqn+UqTSUYRdtd4biuyuBw08l70ArRRWzJxY089y
	r+0nvsT2Lri3XIaBEVPHi7c6TLygyenClYN6bBDlvzbdWhEhxjd+h4oRhEDQRJfSfzF5JE
	a4ritNHp06tcN5fRJ8FZluy/bqpN/C4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PtOr0JvT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761051591; a=rsa-sha256;
	cv=none;
	b=alstt1Bl/2woIAnfyYs8SY0o0EjsSVMb0IB0KP2JQu/9eZ2+Ae0qkg0ICNxjdWh3AvjzA/
	yM+hvzxHA24fT47eF6cCAmZQZYDi/mWZOVXKVWEa/IlYw+R/U6UMgJ1T/KTX1yiIU7M05T
	DyhJp4KOBmbQWF2iiVNJomZLGm8H66c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761051590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z5VcU60xQeN7ydJcNuOrJoqdazEeOf9bmMF6YJ9dhbk=;
	b=PtOr0JvTQkBPjfcbE6v5FhDSnoTRKMxQkr5AiQa4LwXFomT8WagkYOLMKeI+GU3YqtSSRa
	SFl93AvzhQWP1X55eubeRw0ndEqCAZqb9f9xjJNdKvWe1ckWktduIQuAPnuejfnI31DWKP
	uxq2y9kyS/98vBe1BavaSBHiG3MPpYY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-TdZjHn80M5uzr9z3q6imtA-1; Tue, 21 Oct 2025 08:59:49 -0400
X-MC-Unique: TdZjHn80M5uzr9z3q6imtA-1
X-Mimecast-MFC-AGG-ID: TdZjHn80M5uzr9z3q6imtA_1761051588
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47107fcb257so77727155e9.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761051588; x=1761656388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z5VcU60xQeN7ydJcNuOrJoqdazEeOf9bmMF6YJ9dhbk=;
        b=KnXKiUTXyuDpKKfSPTxbuBxM5fVKrE3noThgNNHU0ucodcArXH4tNqkQZx/v0tBFKk
         PjrQIfu6698zMFYivF0aS7ISey/LLHRbbJMF2NClTIPn9NZLzdHjXFrJS/AmNSn2FMz0
         1bi5z/T25TAOlcGEbqP/f+NyVvmHf7Z/DHZyQwqZDdmTQ7JSWiEOFq4gn8+agjbHtG77
         a1nTl3kEb+x0ArEUpMC2aqEgvNWKtGNuEdpkGN62MPeCglNAcpCNCzuVmryNsSRbCY6S
         L7FUchF1oehwawNloJpT6rRJ9q/Hgi0lzP9Lzt7ajA9DMm1wvS4ahxamJRV/6EpBWbMg
         1BJA==
X-Gm-Message-State: AOJu0YyLUku+L9EWi9177oiM0VlKoeuF5tMVLpt/JutVRQqFTW8MwExd
	Xrngd44RTxGXCkHbFyrw6mfTWEYX/IYIX7TnJDyb0X5PwFJNNS5PhayK+/Ub8WPKVgF2Eamt8oh
	64Nc6rWW8YrDxAf2ppBJQAMQmckRLbTcUJUAytwfMo+wgLvmQhFLJY6pqOVWY
X-Gm-Gg: ASbGncvPnXh/wr4aknX0kRnhT4IGdNEuOM4u3HBDg+cs6V4g62nN/XcHwqxAJpYaq90
	acXO5+qFLM+oo/Gp512325LoLTOVkx/IoLzq3EeA1AaC5GoQw5LNNed5vkZcw30REfAeBMwRHgJ
	h5YbC8bLG7b6qkIufkUgLfgE/3BrVEavKRxTqOQKkBDcXMezaV9a+DXiJImkG2ygwcDPCxhcbqU
	3sQGfP17xCY4/fowfydhirn1YIPkr5ji4phVsKXnmZ8YcAS0gaRlXndTc2xV+u3QJboPaePbqw+
	67s8uZNmGWMV29kuyvGzYH1ixXZKn2O9oAZhn78x0ewGtDUOumqIREW82+4uJpvJLvnIIbMIOR6
	PrZcNQjH72cz5C6HPOK+v3T7jhXIwMATa/4/MVR+XKOFHecvohyXrSuTzqE2E
X-Received: by 2002:a05:600c:45ca:b0:46e:59dd:1b4d with SMTP id 5b1f17b1804b1-471178a4bb0mr123277885e9.16.1761051588076;
        Tue, 21 Oct 2025 05:59:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHERIP76djccuxwEVDdc3jxl3cHQS1Z1VLDzbGDsvVWwgXU4e20hoqSfb9F5zq9YX0z7BLvwQ==
X-Received: by 2002:a05:600c:45ca:b0:46e:59dd:1b4d with SMTP id 5b1f17b1804b1-471178a4bb0mr123277565e9.16.1761051587656;
        Tue, 21 Oct 2025 05:59:47 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471556e17afsm190432085e9.17.2025.10.21.05.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:59:47 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 07/23] mm/balloon_compaction: use a device-independent balloon (list) lock
Date: Tue, 21 Oct 2025 14:59:12 +0200
Message-ID: <20251021125929.377194-8-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021125929.377194-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hP8-u8IYKJ9mHmRACOuFm_vkY_qUhTEz762_1DmrdZc_1761051588
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 16B9C1C000E
X-Rspamd-Server: rspam03
X-Stat-Signature: fgadwj8kzq1hy9417yp7t81t18tgpwts
X-HE-Tag: 1761051590-206575
X-HE-Meta: U2FsdGVkX1/HR6Gu/fjqd1J6QMmNLylQfCnScFuogzoa3wYqNdNNoRT8iS1v6e3tnZWhnu0nvj2dnB1KSCFOD83fwN5sU+w5uPeyi2OUctzkLlMJ1w3eNOGBA9AnqUZPe64gSHkGagnQ3lcYk8/S7WNC5R58HgNp4SbfcG7stiqcmzB9tpmFsbkmFo69+H+hmoJYiX+FdxsSqGFmfwwdNjCa+uj6/5YhfyUmmslh/WNlLSLDHt/rAMDliaTL8RFdEpouldwXA2juPyqK+npiwbN34yI/48jyB4iqQgrgoIo2U7DXZXo3xR99x/v9ECg1nNLVcmYt20DHkoj0+kdFNqk36U2K+adJlGv/eOeSdajrTxCRgO+CULKaSIizLM/737/u8k9r8V/Y/fiProhCJLuBqZLk2CXLDukLrP7c3+NEMUAE8UvrNXF+CWduneQ27xX7MOD9T9gzmQOsBInjrTCyHVaxQjNznJDzpS+BXEuwO+xj6O5PJuJGIf8pTVNe88f4KENREVtrP5BKw/vFSWLmKqbEoDOHeEksru2DswAbtwfcj38oFH3xBP4pg2SUKSeHriUQkj/GSS+EDzdQ4drokBpecD7ON1lPp/fdrlIp/e+s4M9dHaj8SAOqYvWsulAcfiAJRKuiyM5gTpHRV86gD+Ntc3rBcWiO1xZ3bEvPQvmsRR/jRivQDi5alQyQb/GzeAwh66OVqjuJbSN34POswbZyPUOtvSAJzN8n45mNlJi6nPfH7bmEWNI0I7aLF+cUO7wt3EZpuRKHdGm+xc7HbQqpET3iTLsC6xKyqJyScLjyhhpzezzntQfGVnIKQQCzlAfvcjS0eGXhD3sufba/jtjDBKVLJLoDse0kxZqM8sj3YiU60UJ45S/uMVAPLkZ8hCwsRh2Fs/BYU6N0TNo2aO1ymaOvuq7vORjW+UzZ2e1N5X8PUwFUaZKaCxoqadnDYxYxzyQTaaCY9ul
 lTYcienb
 1O2WXHg3DozCOfRape7ArIdcN9DIEHpxRf+vrWUhDrDjKNzkvRuE+gpvA9aGwhDrV0atMTXuNy+aMMxMIlVj423FYdPEB/yMkEAudhaysV9QiHhRLWvFcLIsKHqWehACm8AQUmAuhr1zv2ray6OEqPvKz32x+VsgXKVGZcuD7Sz808ozds92x02xdsppfGRvNjfy6RMxW4sXlsMqgSC5JzH4/fp2nOryXpQYJcfMsoiEQW84bhsOp2w4zXyvnw/Xa+C4iWss6e5ThBTxODL3rzCnM3VoZRgb6dlRcQW03CsZLj5s4d8hH6GOVDC/VQnE/sDCUBpSdYl231jlby1bQ0OeXYOWSy3HpSBcy2ndsRGK9yuT5yjD0yCXr1CLTmUBXl7tuFL2CmCJcS7VKnJv6Ylri5/QNTDER9uvwUuU/H3p/7om4uhroMok5IjOz8iwN/Ixz+R5rspwFPYgG2Ek4P6BG+TvlanQf1SY7HR3qgbVLotnwvdvZhZYY0wROe7uU1skGOLAV3XNgb9mCV+T4jrvWaiR2WJozQy+5OCQTsNJ/CZ4ddtUBpVfbkvELOXs6OW6O7xsdUwCuvHRNjw8jX1IzCfv0F9xws9Pi1QZzf+330EOH4wkI1XbSbJcrbO8z4KHeakiG/QLK9YH0FOZ85V+3K4JZmqiIVs021hoOBrZ9dUX/95lQmS3WUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to remove the dependency on the page lock for balloon
pages, we need a lock that is independent of the page.

It's crucial that we can handle the scenario where balloon deflation
(clearing page->private) can race with page isolation (using
page->private to obtain the balloon_dev_info where the lock currently
resides).

The current lock in balloon_dev_info is therefore not suitable.

Fortunately, we never really have more than a single balloon device
per VM, so we can just keep it simple and use a static lock to protect
all balloon devices.

Based on this change we will remove the dependency on the page lock
next.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/balloon_compaction.h |  6 ++---
 mm/balloon_compaction.c            | 36 +++++++++++++++++-------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 3109d3c43d306..e2d9eb40e1fbb 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -21,10 +21,10 @@
  *   i. Setting the PG_movable_ops flag and page->private with the following
  *	lock order
  *	    +-page_lock(page);
- *	      +--spin_lock_irq(&b_dev_info->pages_lock);
+ *	      +--spin_lock_irq(&balloon_pages_lock);
  *
  *  ii. isolation or dequeueing procedure must remove the page from balloon
- *      device page list under b_dev_info->pages_lock.
+ *      device page list under &balloon_pages_lock
  *
  * The functions provided by this interface are placed to help on coping with
  * the aforementioned balloon page corner case, as well as to ensure the simple
@@ -52,7 +52,6 @@
  */
 struct balloon_dev_info {
 	unsigned long isolated_pages;	/* # of isolated pages for migration */
-	spinlock_t pages_lock;		/* Protection to pages list */
 	struct list_head pages;		/* Pages enqueued & handled to Host */
 	int (*migratepage)(struct balloon_dev_info *, struct page *newpage,
 			struct page *page, enum migrate_mode mode);
@@ -71,7 +70,6 @@ extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 {
 	balloon->isolated_pages = 0;
-	spin_lock_init(&balloon->pages_lock);
 	INIT_LIST_HEAD(&balloon->pages);
 	balloon->migratepage = NULL;
 	balloon->adjust_managed_page_count = false;
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index fd9ec47cf4670..97e838795354d 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -11,6 +11,12 @@
 #include <linux/export.h>
 #include <linux/balloon_compaction.h>
 
+/*
+ * Lock protecting the balloon_dev_info of all devices. We don't really
+ * expect more than one device.
+ */
+static DEFINE_SPINLOCK(balloon_pages_lock);
+
 static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
 				     struct page *page)
 {
@@ -47,13 +53,13 @@ size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
 	unsigned long flags;
 	size_t n_pages = 0;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_for_each_entry_safe(page, tmp, pages, lru) {
 		list_del(&page->lru);
 		balloon_page_enqueue_one(b_dev_info, page);
 		n_pages++;
 	}
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 	return n_pages;
 }
 EXPORT_SYMBOL_GPL(balloon_page_list_enqueue);
@@ -83,7 +89,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 	unsigned long flags;
 	size_t n_pages = 0;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_for_each_entry_safe(page, tmp, &b_dev_info->pages, lru) {
 		if (n_pages == n_req_pages)
 			break;
@@ -106,7 +112,7 @@ size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
 		dec_node_page_state(page, NR_BALLOON_PAGES);
 		n_pages++;
 	}
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	return n_pages;
 }
@@ -149,9 +155,9 @@ void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	balloon_page_enqueue_one(b_dev_info, page);
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 }
 EXPORT_SYMBOL_GPL(balloon_page_enqueue);
 
@@ -191,11 +197,11 @@ struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info)
 		 * BUG() here, otherwise the balloon driver may get stuck in
 		 * an infinite loop while attempting to release all its pages.
 		 */
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+		spin_lock_irqsave(&balloon_pages_lock, flags);
 		if (unlikely(list_empty(&b_dev_info->pages) &&
 			     !b_dev_info->isolated_pages))
 			BUG();
-		spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+		spin_unlock_irqrestore(&balloon_pages_lock, flags);
 		return NULL;
 	}
 	return list_first_entry(&pages, struct page, lru);
@@ -213,10 +219,10 @@ static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 	if (!b_dev_info)
 		return false;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_del(&page->lru);
 	b_dev_info->isolated_pages++;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	return true;
 }
@@ -230,10 +236,10 @@ static void balloon_page_putback(struct page *page)
 	if (WARN_ON_ONCE(!b_dev_info))
 		return;
 
-	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+	spin_lock_irqsave(&balloon_pages_lock, flags);
 	list_add(&page->lru, &b_dev_info->pages);
 	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 }
 
 static int balloon_page_migrate(struct page *newpage, struct page *page,
@@ -253,7 +259,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
 	switch (rc) {
 	case 0:
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+		spin_lock_irqsave(&balloon_pages_lock, flags);
 
 		/* Insert the new page into the balloon list. */
 		get_page(newpage);
@@ -272,7 +278,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 		}
 		break;
 	case -ENOENT:
-		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
+		spin_lock_irqsave(&balloon_pages_lock, flags);
 
 		/* Old page was deflated but new page not inflated. */
 		__count_vm_event(BALLOON_DEFLATE);
@@ -285,7 +291,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	}
 
 	b_dev_info->isolated_pages--;
-	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
+	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
 	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
 	balloon_page_finalize(page);
-- 
2.51.0


