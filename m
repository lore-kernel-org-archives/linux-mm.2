Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4992DCD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 22:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B111D6B00E2; Thu,  7 May 2026 18:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC15D6B00E4; Thu,  7 May 2026 18:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6F46B00E5; Thu,  7 May 2026 18:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 898806B00E2
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:23:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51A1B1A0639
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:48 +0000 (UTC)
X-FDA: 84742052136.10.6B67A9D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id E941A18000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 22:23:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ikEesiH4;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778192626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
	b=8NhGHbyxbOLGkuaiiEsF51LfwAJbCoGcum7LL8GMGxXIMAB5qfjApi3fZPop0eocOJ0I+C
	znwNOMivdb6JAI21hiQOA62K+IDGDbG0U51cLsUnpR4OhLuNOCrRxOuVruedOM9wjFEucX
	1UohRWP99k6DtqKrCATy53UfbtgD/1w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778192626; a=rsa-sha256;
	cv=none;
	b=18Il0blbChtgtqUmOAuCiAM1O2GyIXL6oyjXfmiBdfFS4Nt156cqs1n6OmDVzkkDScwa3m
	jc1F0BbsCgqKt7ub0htHiqTNnhNbdy+vMwGknWRLN7uIAz/6sGq0d3s0oAUiAYAXDXbYK4
	HjViZrL79zzNooswx2uGxx0awHHT0EY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ikEesiH4;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778192625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
	b=ikEesiH4aJ/nIOpNNaMGgO8oRGbgVzSiAeCLMh5tXxVlfJGPGksEWeFRuCBbIkawl5prIq
	NBX2ofqdqbfCAlTYPqwj1FGzY5wTqG+pht07DtBlisDSSCZx/6C4E9wRLi5rpvONtJaKUB
	H1cFSjQ+QtYwGUBaL3zskz/Ti7sE1Ag=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-FKfbToC8MiGbl4_XtasfmQ-1; Thu, 07 May 2026 18:23:44 -0400
X-MC-Unique: FKfbToC8MiGbl4_XtasfmQ-1
X-Mimecast-MFC-AGG-ID: FKfbToC8MiGbl4_XtasfmQ_1778192623
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44d83e45febso1970608f8f.0
        for <linux-mm@kvack.org>; Thu, 07 May 2026 15:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778192622; x=1778797422;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpBn8Jg+yemSfT/rKcYB8AJ8VmedmgkSc9fIviOsi3s=;
        b=ZIkM1BOwY/RBQgudLzT5cEANLYzkyWXOkNZnwrw5eqNJVCiwoNa2CgQvEv9TYTzalN
         dPD7KDu+BY7nn4qL0U3w1VVj6csMmKZzEkKrfi9hTPwwcKaXKipaSDR4QC6W3foAFxAo
         prI60MAmLwa3m2WLSvTOEUJCCicHxoBhzNSmosXA0ZpHqv3V3H57B9kvvv8n/4sKEwsO
         wdwv7Cl2UX7n18I+HMtd/Oh7/MRZv7mrcmNA05rskbPRDqY8sIUxC+df4klyQGYppaEu
         Yksd1W9EN9PmnhDNsxX/KjtNpOYhSvNwwqEnCFhMvqkrhiImXh1InSC4pQ2Ig9wxogTW
         MlZw==
X-Forwarded-Encrypted: i=1; AFNElJ96NlRfu3vN7rLUipKLCX5eTl155H4jf+NFfb4jaRNKpMV+v+GuspICjzhXzyoXm4n+0ENv7r4miA==@kvack.org
X-Gm-Message-State: AOJu0YwRKsthZqTDFT1646gBpKtmOtWzdFIK+5saCJpBrldCbzoBmSzy
	LU0U5C96/VU9luPn+IHXh4DftOyywfEq0L+znAUDfom2aDd6gD8aeaESEYckscIKJjUUCx2xCHC
	OvdNlQ5Y4Gy2dhuVkz+z0NiK7Lq2Wa8WH83uKOZNyFD9AqslFgu2ZL1IouX5K
X-Gm-Gg: AeBDievmU4mOncbVwLK4nv959B0m8OUIuvC+0WovL4jrGPyti43bJ6Lr9oowVFvf2Rb
	Ae7eO6zxYn0MRCG3eq1XPZ31qF8eKj/ySK0h0iLoKrj5jy1IuT5qBwQQNkIJCAd038RgXsc6pKH
	fDg7syVUSgEumOqvQ1C3lUarjlIHJJhddpCPlF4kdp0WUdCSAmAtt8WJdCNLwzUiHDaP3MLztqu
	l5bW8gZuAGz+45Ws3Xm3p+Dg4ETJdJzLEkUIKSCCBcgzrT80CX4cZbR8OUc6unQDu9kcyRDBSAs
	XLyARARH6j0jGKJvnDzt0v3wx2/mWamygpxwtkXpzf6YWGYIeqqPKngRiQAPpszkDGmqTa4zGbP
	AccK33vpaP4oEIvHGNgjck5Vml4Hyp+rQXY0RcJo6
X-Received: by 2002:a05:600c:a10a:b0:48d:50a:6ef4 with SMTP id 5b1f17b1804b1-48e5dffab24mr53046485e9.11.1778192622548;
        Thu, 07 May 2026 15:23:42 -0700 (PDT)
X-Received: by 2002:a05:600c:a10a:b0:48d:50a:6ef4 with SMTP id 5b1f17b1804b1-48e5dffab24mr53046285e9.11.1778192622056;
        Thu, 07 May 2026 15:23:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538a517bsm166228835e9.4.2026.05.07.15.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 15:23:41 -0700 (PDT)
Date: Thu, 7 May 2026 18:23:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: [PATCH v5 26/28] mm: balloon: use put_page_zeroed for zeroed balloon
 pages
Message-ID: <f3e0f47bba9181f7411086bcb7d229e8575d58b0.1778192416.git.mst@redhat.com>
References: <cover.1778192416.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778192416.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E1KLZGUCdq_xyZfMxXWdmaO3wSx5LQ8xKaVpZ-sRpKw_1778192623
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E941A18000F
X-Rspam-User: 
X-Stat-Signature: 5w7mahg8ks5bbrpro34og5bce4gkxxhp
X-HE-Tag: 1778192625-231665
X-HE-Meta: U2FsdGVkX18UL9RR+y4t98PDfrI5EKy/eBB2FebrqPtpef0zmdd0T6eHVOGKA+eU+LuYdtF9iJ0gOCSiBkwezaGOYztKppQcnxmHArRWhvf0UdwlXubvpJBpy8Gpe5J701Umgy4w/ONfj7Egxo5TnvUgqPnGV3tN5mHeYuSkwPFsJKp7DGmKDXrnWTmRy2D6DLidiynl4/5ht/XPcQlxohVXAx1PNUnLlOOlEwSito5xliWWS++9Tbm4msIame1xD7XpB3ea+qfHbLdLYuhXBcnBx7Cl8ob4XY3MELNTf0Z/JC/DjAS8XgwzfRVJxukLeIhHPttxHu+qANx8IPb+T4fa1JFB3QHoz/K5iv8tJPlUPcKDU0skfKRnJvAfsX6g03kOTECAFc3tiVV6UwUpBq3/8ojtlVCYAvEVhOBUpQK4RDR8j9g7KAAnKLNUNyHTSNekSUqkUZGE6hjBRoH/PSWP709u/OxLsGotJVo1qMCYqrawfONLHH211CTPjWALXEVLMbQRSbkTg/NLCpVMDIh5Xwd4jf3OUfSFUAs3YVak40mMCZmn315T8eSTDnIBL5l4i5p0gRjqePhAhTIZDqbcMhr0+DW4hjlQWR/OXXrvY6q7sbrgVV8FIjbK7VDYpckxvRlipfi1f6hAxMXjFhMqZFFCTpLlY7nkuGZs9W6Ps20xWH66t23w436wvrrzRitWtLDv6VUY1qb/XsheaTOVmbV+OyMeEbNboC8wlxgM4CtrcJooog51A5KkAjAhDv1GpSyB7OnZ4z5CnSc+iA6tMgj0e6pLrKa6WPxC4AFy3fWymwCjNFcjrLernDIlze48ZzY+h915o6DJBtGzfg3PscM+8vloaSmGOcl8rel+2EFofjtMSVSGDJqxu0C7Md0aQNH1VSzvosLrP/hmpk3BxP3Vgb/sDJVKjBOrNLb1PQ6R8zHyzwFaQyEZLcQ6awLLGuTcxB2IkQpGKWV
 mGguxuh2
 uN2B81W1K+zs9TMFTYzD55AOwVqHYRqRz4N/rikKl2e6scPfSu2QhtCjPM0Q4kz3g6/Rw44SY8nkr0GAont1ECu7aYO6bxl5MFwltDiXz0j6b+I7y+96gF70vZMxhq6+077Bopeo9jm93Ps+5W5znWmy0gOWXhZiZwPU4TyiDz0thQa28RqF8cye28wU4vQfh1Xqq/U05Po06LfYdjxbO4ts6ZsQJwqBl8KQt22wzMZXDBdSaoMH8wydWwSVirClJIqw8cC7zjqY3uFyCHxuWDR+DZVC2H0XngwRYnjlPMLgYlnM5WITjpNIQdJBiQD4pzL6qG0gNK9OOC+PlRGypPmDsvUuNqjnB7YUa5xp2iMhaKkyhhaxs3m7STQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a balloon page marked PageZeroed is freed during migration,
use put_page_zeroed() to propagate the zeroed hint to the buddy
allocator. Previously the hint was silently lost via plain put_page().

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/balloon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/balloon.c b/mm/balloon.c
index 96a8f1e20bc6..1bf7eb2642a9 100644
--- a/mm/balloon.c
+++ b/mm/balloon.c
@@ -324,7 +324,12 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
 	balloon_page_finalize(page);
 	spin_unlock_irqrestore(&balloon_pages_lock, flags);
 
-	put_page(page);
+	if (PageZeroed(page)) {
+		__ClearPageZeroed(page);
+		put_page_zeroed(page);
+	} else {
+		put_page(page);
+	}
 
 	return 0;
 }
-- 
MST


