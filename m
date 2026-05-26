Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A575BCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE62F6B00C7; Tue, 26 May 2026 07:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6EF6B00CE; Tue, 26 May 2026 07:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37346B00CC; Tue, 26 May 2026 07:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B04E16B00BC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:58:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BFC3403CF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:58:43 +0000 (UTC)
X-FDA: 84809424126.26.E8B473D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 46A79A000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:58:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Av1h0tv8;
	spf=pass (imf15.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796721; a=rsa-sha256;
	cv=none;
	b=kWVzmXJY25ijZ9kNvja2ZTresXtVq1Elmg78+gTo7WNoW1t6M63DO92OJIvkGnmnI/yz75
	7cQVZn2LLp540SueZglUgfpRAHq+WYdD4NY70QWk88KgRDNiKoUmEjOWvEfb/CFSlwGQbG
	zB8vJlj+n05dhbhQGflQnvLUsXtoVdY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Av1h0tv8;
	spf=pass (imf15.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPyeI3WYcfjl4yRl3ac7XFI0MNmn5AdhMMlnH8UitZQ=;
	b=gWAWzwvTJkK66U0uOyWJcEiSOpRwc5mDQt3Gyf+W5rgSGofjInvZ/88/bglLUGeGil/A3b
	QtqF/+clQQId4KcFx+0C60I2y4sk/5WRXYn792pwbmXBhyMRtA9F1yI3emZrU1ySBCI35v
	PCf3/sX60MVnDD39cWTt3bIc1DE15XQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779796720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPyeI3WYcfjl4yRl3ac7XFI0MNmn5AdhMMlnH8UitZQ=;
	b=Av1h0tv8us0uwjkV1wfR0GiTVOFd6ZbrqVVgyr8uVTn14InlbBNEQ0P3U3LWdeLElxtLJ0
	dems6/1S1vuoucmotO/hoGAjqbd/uv/ZQSgjb1W5ZDT/+FkEGg/QjY54jy26WcTZxoBxjB
	T4DZD8bVX35023DN2LqEccBSwSqlI5o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-ZA1vIuspPkyKMMvH9xDWlw-1; Tue, 26 May 2026 07:58:37 -0400
X-MC-Unique: ZA1vIuspPkyKMMvH9xDWlw-1
X-Mimecast-MFC-AGG-ID: ZA1vIuspPkyKMMvH9xDWlw_1779796716
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48eb0da933fso72597475e9.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796716; x=1780401516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NPyeI3WYcfjl4yRl3ac7XFI0MNmn5AdhMMlnH8UitZQ=;
        b=Veifj0vNpWDM8Nd6UKsIPsijOpHCgoXrYTrf5JXD7EFFPCYA6eeaHoJvmY4FrHiL94
         kC2iBE6zbcLxHkE40C4R7E00bB0uJsqTSAdudX1sOdRgFkzwFWxhCHTw5O7KvG/70P2z
         ABwUD7l23AwnJnppTFhU7J9+iRQPczMPuqP38+SjreYh4p/ozoeOMV/xwxE7bUdjQZl2
         uK9J6S9BOtpzAksbTAXvxJ7T9q43bXpIUgvNjRMSdbs4ewO/yZUR04bIKcCla3kdq2qP
         If4kwtFXa71RfTJKicc69Vmwd+4nBIAkTDzS9+i7NLTXYjNwE4+veQCbPkqSzzZDauK6
         wWew==
X-Gm-Message-State: AOJu0YzUDrIFqBq6W89YTPZJIrzuUWywWZ5biw5YKZewcZP0qDecctre
	b+tXKI9Gdd5DUlRyxZtbaXGcHY2o3KT/IObGneo5PVFwfXRh3M3LsZO/OXYEDwsEGhws/mdP0YU
	mMResqbUe/MElXF+PZKlfbA5shzStnhPlIkXT8qh27u10JrtBJ3vK
X-Gm-Gg: Acq92OEQHGT09Gyd27JM8lMq7qMtoZA791GJB/335t6wjJtbRcyGyF39Idh6pKYK8Da
	1GR13S/iAojY9EP+ysF84aes0RSCWTJm/pN7f/VShhOJ/Z2li7jAk+IOndE3Z2G62a5kW0WRduo
	6vP+IGZk9o+GEIL9lGk+okEiCGbpsTpq8OfMPpwlaZ2BXKXxwSwVuuAKpIcvmZTGDG+xHfiVAye
	QwgWybbSe9+BZ5ZP3Juzd34EalpVYQZq5IbAO9a3ZnA/7rwchNRo+neYNBViuq5WDzd6jR+MTpa
	1YpUQnSqiPkMr3SyEHf001TPujaF10YOdTQi9yzcmJBb6xwi96c7OJ46ictVqZoVtluvtgKcSdK
	56fmFircm465sZQX26MOkc7zVl/q16/MIDprmcbUdIdnYaQTKmxt571a1bvezHcnjWdmmNwBboC
	/z
X-Received: by 2002:a05:600c:4e0d:b0:490:58ef:ce9b with SMTP id 5b1f17b1804b1-49058efcfbfmr209948505e9.16.1779796716279;
        Tue, 26 May 2026 04:58:36 -0700 (PDT)
X-Received: by 2002:a05:600c:4e0d:b0:490:58ef:ce9b with SMTP id 5b1f17b1804b1-49058efcfbfmr209948105e9.16.1779796715935;
        Tue, 26 May 2026 04:58:35 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (78-131-46-194.pool.digikabel.hu. [78.131.46.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428d4d8asm110335325e9.16.2026.05.26.04.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 04:58:35 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 2/2] simpe_xattr: fix racing lazy allocation
Date: Tue, 26 May 2026 13:58:30 +0200
Message-ID: <20260526115832.1294821-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526115832.1294821-1-mszeredi@redhat.com>
References: <20260526115832.1294821-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CpKbsTQwJlw1T81Frdyu2-af3UMcMzwsjimSy0LjQhI_1779796716
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 46A79A000E
X-Rspamd-Server: rspam03
X-Stat-Signature: 1aek87ng8ixhjx63b1we8ip4ywkxcc3b
X-HE-Tag: 1779796721-421544
X-HE-Meta: U2FsdGVkX19OLPrE+yGL5DzZOhTZYMwoGhphqoYAdxk43wn7yh9qOIqgTG3xwVUvNmDn4uJWISFVgbkpidPUWf6CRSRzYvgz449TI/6Y3QrKwpstrzFFNUb8R/ZOV+EiSk6GNyTxfce1yfVYQbBcvjlSMYN3LNmLSkMSPnxA2OJf/lqr8PL17VJnMvx4rbLaJFlKyvjGEN7hlhYm9zXP5VDpqg+fp6O+5CdWlXuufrm8nnx6CiSD3eWefNpCH443SeVxdh85hlcLMxUAOJfBGPsJI7XaDBkdPcJcVUlvRC/d6UVyOoOP6sxmXfAc+4K1T8UytPboGybESJn7oZMtugXAgxpll22mhVGjjXwsLykJrl9jz5ZU2HyAzr4uhJK0FRtgnufpGEG5DxJPUKCncoahDCVQtk9TObvixU5rEMfzob5pVc2db7ajFXiEJS9iKSMHDfDe0zBpiqgGhYeBrdmpwaMrziO5STqsPPHqaG3ED3SyN8sOMqRP7A562NdiBq/b5V2tZo90T5i9tg1Rpn+b1vKKxQBluMHAZJ+0upUOArmiqcaYEDlrhCwuJb45hnZZmoeDun19qfd0IGi6VvS92SzXRKuqtpTztDv7I9qyUGOum2CZkzgaVGrU56i5Xo/8OTz4ZSaHMRZA4sd2BLo9hjGx7xP1AR2LrKMZCDbiv6UiKeRHFZR8zr9LTLXChBSmMSV1Vq+6W/td0kht141CtFpWH4Wr7mrP8ZfFwj/FWIzIftEj8vor6tlJGMTn17erIoPz765OuogyzEJ/MQ/ZlmQVKo4PbFb+LiOpgz7IHbFvhKsX20ycSvHgqf0MBEVf9EZjHQ/LRjC+oviSOe3Q2nQO9yGrGsRLnj/Fjz3uo8X/EdYDB3mF/Lm24zXtK/3Wkq4DP6fZe0pyEMxK70bbMNn3dVX7Jo/8lJjYJtqLwuZeaTksQMRDahgWbh94d12/GYia3c2DH0HnoTn
 unYb+tWD
 bs40HZlQmbJRYI7e1qnsYRG1D7rLu9ojpaczEXGNzYsnjsW3JCC2WkUkWaI9KnE/6op2nTGvL1/5KNEKeaRk6MIgvbpHLXz959JFBFeccWtwTAh21ICeU4D+s76OcI+51xmXzPdYkqnJLqGUioXtZZCDNhLmvmYVNpNh0pwxLn2NIIVCdPRn0D6Di6i1uFGDiy1lEAb17ZiyVWygoUbDPQ8QEB5+kNFNmBL7BAq10Gz8F/T6GnLO/zyGdRJx77YZ2FDJNSMjhxd9FiY+q4EYhx+ergTThTrpJMSfhJCAvqbnb2IR9U0u83CmAGBJsqbTpMA4lFiaWA+3DTqH+xo5+MhBuSWzwRwOrfD9X23QBXtYoO+Rvjlfk5QGvYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before being made per-sb, lazy allocation was protected by inode lock.  Now
inode lock no longer provides sufficient exclusion, so use cmpxchg() to
ensure atomicity.

Though I haven't found a description of this pattern, after some research
it seems that cmpxchg_release() and READ_ONCE() should provide the
necessary memory barriers.

Fixes: 12e9e3cd03b5 ("simpe_xattr: use per-sb cache")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/xattr.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 31cae48e11a4..57e117ab85da 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1332,8 +1332,7 @@ int simple_xattr_get(struct simple_xattr_cache *cache, struct list_head *xattrs,
 {
 	struct simple_xattr *xattr;
 	struct sx_key key = { .parent = xattrs, .name = name };
-	/* cache->ht is stored set once from NULL to non-NULL */
-	struct rhashtable *ht = smp_load_acquire(&cache->ht);
+	struct rhashtable *ht = READ_ONCE(cache->ht);
 	int ret = -ENODATA;
 
 	if (!ht)
@@ -1356,7 +1355,7 @@ int simple_xattr_get(struct simple_xattr_cache *cache, struct list_head *xattrs,
 static struct rhashtable *simple_xattrs_lazy_alloc(struct simple_xattr_cache *cache,
 						   const void *value, int flags)
 {
-	struct rhashtable *ht = cache->ht;
+	struct rhashtable *oldht, *ht = READ_ONCE(cache->ht);
 	int err;
 
 	if (unlikely(!ht)) {
@@ -1373,8 +1372,18 @@ static struct rhashtable *simple_xattrs_lazy_alloc(struct simple_xattr_cache *ca
 			return ERR_PTR(err);
 		}
 
-		/* Paris with smp_load_acquire() in simple_xattr_get() */
-		smp_store_release(&cache->ht, ht);
+		/*
+		 * Provides release semantics on success, so that use of a
+		 * non-NULL READ_ONCE(cache->ht) will be ordered relative to the
+		 * above initialization, due to implicit address dependency.
+		 */
+		oldht = cmpxchg_release(&cache->ht, NULL, ht);
+		if (oldht) {
+			/* Race lost */
+			rhashtable_destroy(ht);
+			kfree(ht);
+			ht = oldht;
+		}
 	}
 	return ht;
 }
-- 
2.54.0


