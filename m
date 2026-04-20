Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B44F588C4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E376B009B; Mon, 20 Apr 2026 08:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857416B009D; Mon, 20 Apr 2026 08:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F8E6B009E; Mon, 20 Apr 2026 08:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 573676B009B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:50:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18D2DE561F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:57 +0000 (UTC)
X-FDA: 84678918954.17.69AC66D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id CFE84C000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Oj/469f/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEMCfIlCf4bqiMJiTJpP/SQ3egOk7/aPzZBRg9jsyO0=;
	b=6Qhf+Lz0e0wc5MBwnoRs5c6Tg5FHzWOODHpuYQNRXJqMmAKgK4MkLxlBj076gYVxf+gOrW
	p17iIY3dQ7q2rXKNt68vczZBo50+1zsAESUHo8GQVuPciJFIPmey5WCB4+v8FfoS8nSieP
	8nQql+ccT8t++CEFghPVxUyEZ7ZhoFI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Oj/469f/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689454; a=rsa-sha256;
	cv=none;
	b=AzHSOylvY6obJuuK9VYOYjUT/HzsBkvDUZRMLUaPqX1C2SpqlNwneg3JTi7Dl3a69a6Q68
	fX13tbk9/d9BzKX7FvNK84fimFpjZvWESYYKiPbXr3oXTyIqqbJrfxVc7BFoVyAY8vbiBr
	EQ/T0xTemZhiYEj+384fsZM7eES1rS8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mEMCfIlCf4bqiMJiTJpP/SQ3egOk7/aPzZBRg9jsyO0=;
	b=Oj/469f/YOrWRQaFxxtRODheMB9uo805ZGKPB6nkatcRWDdiSPR6c6mRnFFZGGdsvL5Qiq
	jINrHqzXIDQWVSOv+M97zLWPgTdM5bwwyYb5CIPaYb6z9SN2QkD44AbVqOFbOUKB++fQSU
	zZTP9RudkybQtMRVyjryXt38N3rJm1w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-JkMM9C1lNa-CsYMnEHj8Jw-1; Mon, 20 Apr 2026 08:50:51 -0400
X-MC-Unique: JkMM9C1lNa-CsYMnEHj8Jw-1
X-Mimecast-MFC-AGG-ID: JkMM9C1lNa-CsYMnEHj8Jw_1776689450
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488ba2919b9so22600895e9.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689450; x=1777294250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mEMCfIlCf4bqiMJiTJpP/SQ3egOk7/aPzZBRg9jsyO0=;
        b=VHzH88NR2F5HY4HSNXWwI04pi4ZwEsweD6VBuX15UknkEGMT4OxCS2LarSJNaRhP8v
         QBRXe8PnG+gbDfKlEvoPa+9PLyDgxx2th2fdkBUwKXlLXwk7VilDg1fYzBVwiYpknhuh
         sPXoZ97nSS91byWxekC7fHnDZvBBrVbwa6PWoqC8FVchS9xSihmb3CslemGcBTBnfS1u
         mG1C+GoRmyHKt82TFyBtTopegvUMJGVezyaV6BTe3Qy19vGxQvJ94WL73qm4AM6riiQa
         TqsYAgMTMbUUfXxVz3P+1JKQakZ87fc8IOLB1ziHTdaNEQ3M8IrFNjFyIZO/BnXAjsST
         Rm4w==
X-Forwarded-Encrypted: i=1; AFNElJ9s2bONOagqcw/LJhDzX1ZFFWupb6xmSMFxOFaLnNctYQUZUu6wPVrRHTACB3yNhq2RenfWDY28zA==@kvack.org
X-Gm-Message-State: AOJu0YwDeHFJg+Kc7bqgzYFxzkUoRZcCn5tgkU84swGZoJTqRqut7hMK
	gU6jBTJLpn0cNIWKGKfqdIIlUjC4QkTEyogf8zNZuG4/N1uO1iTVc7cK0HbKeIhy1NIv9QCxi4A
	DA2974qZzCvQDmq88B3O7ftsasp1jdh59R5UvATgopSM74zfqUZLu
X-Gm-Gg: AeBDiesRBOU5+xcFiKni31blfP+jqQ2nkhcL9/a08ccQQmIAm9HIQd8gCHGwQbuXMgo
	8FXTEq0Qax9cfCAkemvt5PM22qxcS/90XwQbQb+07PTWOrKqB7xHrUBgT/NLX8+aLHJgq5uYLkp
	ig9f1pM90PiqpeF/b/D9qgDJECAVlVoBZOOpzpn+s7XKKsp/a4X91EXvyW02oe6Q9yKOjWmCaY5
	zF5Dk9o+rV0FNm6C+cr8bZcEIMqJ+YsLGtyJ5jXSJhAEgu9GkHXxKXOV3WysOFJcKAYxAnxyGbc
	fMz1ijfuf3fXHJQu11HDn6ZTdHEmCk3fqDXLqzD/PKzFAQ0RmrYtkbOGwUWui3wkPhLgE0bhMpA
	tVqJDDnyURKKgGIQv/eWog33lhropewWh5Wpl2LlERSDeD0pWf8TvWA==
X-Received: by 2002:a05:600c:1f94:b0:489:1c2d:211e with SMTP id 5b1f17b1804b1-4891c2d2213mr56432545e9.5.1776689449889;
        Mon, 20 Apr 2026 05:50:49 -0700 (PDT)
X-Received: by 2002:a05:600c:1f94:b0:489:1c2d:211e with SMTP id 5b1f17b1804b1-4891c2d2213mr56432035e9.5.1776689449374;
        Mon, 20 Apr 2026 05:50:49 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891c08faffsm149479715e9.1.2026.04.20.05.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:48 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:46 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v2 10/18] mm: page_reporting: support host-zeroed
 reported pages
Message-ID: <cbce38891501864ae079ab66456e3f0d073613de.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s4P0Sv8_J-FZrDDOb6afGu3MxZUMZMIoCTfhPIuqxro_1776689450
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CFE84C000C
X-Stat-Signature: 6y5pbhrxzpts7fwr3behn9smfrr59hip
X-HE-Tag: 1776689454-333906
X-HE-Meta: U2FsdGVkX1+eOuibBxn1u5ZSV9Xd8Ulio7HVcgQI/KPU0pIJ1CqHrUpHIlEnNvvgJZ8vhDRj2ioh/lZDowxyNWd+gysgZNCKDuBaqCj+L+7Zxt2nzxhHeYBafdLWaAhZVWuYhu3AaD0f9PwhFw9hpdV8rJ1Pz44qZlt3Q2H9a5FHIl38dqaQHp8ogrdWEI5zYjb0dBuE9YApfHOqa+4gE3DzKjxxumspN+LbO8xVJxMU5JMPcNAQnz6F7wiIcDeYifbAaKNSbrOiuUqHeolYcW0m94jNfIAdH8UgA2loXOLc0wSOn7RdGLyjDyJdop2P//UM0WnRbmDz0BLudQm+9ux/qslhfLyCEvkf3sYZr/7kQa0kbIxI3x+Gn8lK3ukutgoaQHYQfnpYjMdaMsede+PxoY3ArRALZo/dtn+JgBWVPzW22QzmPkQr1VHAHuz1GQe3YadbXCMHqDwQ7jckkUcNbZ23eswIvN2aI4B7tjJ5wpl9Qxhj0RJah7ghGu80k1Y7/3t4S2E8BdmVLqahdvCCPse1F1+LrVWALEjPTT1VA7TXgZVgDQnR3iZbs9wDurHLkjTvzFsniH315gZmBrRGFr5pcwnK5oKq73n6jK6yA8dfjsCi1t4xCBx0znzKddgjBhRgKjOtNNN8x7r2GqBYl26yty1GleRQ+I1DkdpSTCLXqwxe3rRJ+cTABpVVEuHZ8//nX4RkHctGVSiqInPpp/c76v5Os40dpGN730EeQXMPUcmYSwguAhKcy7dmIp0oxLT0uBa68LObEUmIzi8VGKZybSdHUgUCku6KjuWtgOO1Cph4+IKXbtnb2L9ZVK8gLD723WuwulA3oLgl835fFHpon6NBhMD0ikYDODd14bSzSxNMIjtnybCpNA1an7bLgaPM4FKTiKYL+77WZP+k3LWMnPtWXKc/s5RWpJ5ieGdtkcP4Dv875ph6ol7GVR5ObV0AsoAk6NpfxEv
 wY+maHbt
 Wd0wsWWtKBesaPVjNGc2SkRdGoPePS9tedHKBaDDaBi/BPT15kf0HXDu4zmzPKnFdhcV+v+iTMju3MOtGMaiQ4C433LUOxYa9kE+sKSm91emsS2BkIj2DoQVYa9PK9ROzWxg7fXOP5PfHiKMwju0X6dkloNVWOOvOxj3sxxL7b0yEp00LnkbcXO2cYNve2u1fuzoYzFYjY55YDwEiAvR/FDjWa8bjrIcDI4qCDcmOCuyWn5DSYdyszRtO0knpYIFQ1gxXdMgvkXVwNJg8JPB78NdelOlh1yu5iAWEB9i974KPjGtkJX9QcSMLanjWHi0OUBaq6MsY7AjsG8+HicM+jZXq/s036dxAFAaVdLmVQkMKbWC8njHAXkshq38CNuZ9VPaMyapnQTcdDIzU3KhkJk8UWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
drivers to declare that their host zeros reported pages on reclaim.
A static key gates the fast path.

Set PG_zeroed alongside PageReported in page_reporting_drain() when
host_zeroes_pages is enabled, so reported pages are marked as
known-zero at reporting time.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page_reporting.h |  3 +++
 mm/page_reporting.c            | 13 ++++++++++++-
 mm/page_reporting.h            | 11 +++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index fe648dfa3a7c..10faadfeb4fb 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -13,6 +13,9 @@ struct page_reporting_dev_info {
 	int (*report)(struct page_reporting_dev_info *prdev,
 		      struct scatterlist *sg, unsigned int nents);
 
+	/* If true, host zeros reported pages on reclaim */
+	bool host_zeroes_pages;
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index f0042d5743af..5e1e1a924b0c 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -50,6 +50,8 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
 #define PAGE_REPORTING_DELAY	(2 * HZ)
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
+DEFINE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
 enum {
 	PAGE_REPORTING_IDLE = 0,
 	PAGE_REPORTING_REQUESTED,
@@ -129,8 +131,11 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		 * report on the new larger page when we make our way
 		 * up to that higher order.
 		 */
-		if (PageBuddy(page) && buddy_order(page) == order)
+		if (PageBuddy(page) && buddy_order(page) == order) {
 			__SetPageReported(page);
+			if (page_reporting_host_zeroes_pages())
+				__SetPageZeroed(page);
+		}
 	} while ((sg = sg_next(sg)));
 
 	/* reinitialize scatterlist now that it is empty */
@@ -386,6 +391,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -410,6 +418,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
 		/* Flush any existing work, and lock it out */
 		cancel_delayed_work_sync(&prdev->work);
+
+		if (prdev->host_zeroes_pages)
+			static_branch_disable(&page_reporting_host_zeroes);
 	}
 
 	mutex_unlock(&page_reporting_mutex);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index c51dbc228b94..a53ab22f4c49 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -12,9 +12,15 @@
 
 #ifdef CONFIG_PAGE_REPORTING
 DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
+DECLARE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
 extern unsigned int page_reporting_order;
 void __page_reporting_notify(void);
 
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return static_branch_unlikely(&page_reporting_host_zeroes);
+}
+
 static inline bool page_reported(struct page *page)
 {
 	return static_branch_unlikely(&page_reporting_enabled) &&
@@ -46,6 +52,11 @@ static inline void page_reporting_notify_free(unsigned int order)
 #else /* CONFIG_PAGE_REPORTING */
 #define page_reported(_page)	false
 
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return false;
+}
+
 static inline void page_reporting_notify_free(unsigned int order)
 {
 }
-- 
MST


