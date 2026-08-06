Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA5FC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0A46B00B1; Wed,  5 Aug 2026 21:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850B16B00B2; Wed,  5 Aug 2026 21:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718C36B00B4; Wed,  5 Aug 2026 21:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0678D6B00B1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:12:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16B531C11BA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:23 +0000 (UTC)
X-FDA: 85069068966.23.11925EF
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62ABFC0008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:12:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XmnI9aQ1;
	spf=pass (imf28.hostedemail.com: domain of 3dN9zagcKCF0ET9N75NBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jyescas.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3dN9zagcKCF0ET9N75NBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785978741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqEP+amGkpnagux7ncXk0arDHCDCPoq+yfQcXf7Ol/Y=;
	b=wOWO3fMSU2WESXlQ3jwFgEW0CWd20c62W8haMJZ7/K3r9IKxjxLvKSHWzvsarqfsTv6vh1
	gbNsP0AIYoba0nkFPF91sOrMQDoG4n5cEtBBMZfWzKr0kgvkvoYpG1u5gNPdUIOiPO3LIV
	A6EE3KD9iATcVkSs77mLR//JZzyVFEA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XmnI9aQ1;
	spf=pass (imf28.hostedemail.com: domain of 3dN9zagcKCF0ET9N75NBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jyescas.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3dN9zagcKCF0ET9N75NBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785978741;
	b=bLVxBqzPXeWCugGAnfZrflqJLewpPMQxUlfCctCPAxBYD0kIqCIXTC91RH+u1KrbbpbjKv
	UtC9I1Sa9LJXiX5vc6XTRGi45bDh9Er5cIGv/nGNj2wvNV1dFoWR50X3eAbq/o5HOUUSRC
	btgmqFs87EPaURASRsMg9zgJyTeDXmw=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dde0df80bso2268882a91.3
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 18:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785978740; x=1786583540; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eqEP+amGkpnagux7ncXk0arDHCDCPoq+yfQcXf7Ol/Y=;
        b=XmnI9aQ1IiK1xAgSUppLq3UTw5Gkguw1tQ1sUbyUc8KlF9q+P47GEgSdL6M26ld8eJ
         91cXkxadIxwxs0n7q7I0nWcqrlS4de6vPFM6MeDjhbM2m6goludifLX0uBp5VhU5TRct
         8wZCj3MDNQ8E5BLXMRj6xHt+Yf53kN9pao9THoah5wOn65r8Aca/YRWWzyuQ2nLAGcOv
         VLYMu8Qp/Ngk7NvrNLLedR1sQ2Uw5elWSfHFa/UWIkRxupgBS0K9Il0kMDUJeZRpfnhW
         3YgWxH2mdEog1f70SSHPUUdQb+qvyICVyuVaHYFDeniHAH9aE7Rhnne25HSxPKErOk/v
         AO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785978740; x=1786583540;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eqEP+amGkpnagux7ncXk0arDHCDCPoq+yfQcXf7Ol/Y=;
        b=lJeb2V6bVVQ5FgirzJVxzD7y/pPoANc3xJtewykcDXUkgzZm805yTavval6yqkCH0g
         s3vCy9lxwZU4R8MRrGG1QlvZvV+5ExwA1Hs1KmyqIbX8JoeYEibhhpsBK1lsE/i1KeUG
         5pWIxtjZ8D/RUx5Q/lU9TZBuypQDOFHtlmtEmda0ipsOkGPjt0o5NoGW9BYxUb1GjEbm
         ukBHb06mzW5RnLSGJKJye+lmoJQGxPrK7sDWTl38Iow4AWVez2Tm5FCVxjNT+HYtmfW+
         ws0V9ncumvU32aShpXHa8kMeHbVHu8nH7BjPiO6GcwFemnrUTThyZcOxecx8C/kzJ1H4
         J+WA==
X-Forwarded-Encrypted: i=1; AHgh+RoC968uDtV/PG8/bzii8BE0hUBDu80IjxRYEyafwca6sU2fNQ/E1p3agdN0/PTdE8qmnnVyiZwnbg==@kvack.org
X-Gm-Message-State: AOJu0YyR+C+CetyiQlglGy2PFlkd9cWcASCWQKZv04CnQMy65DVFf4tC
	Yq1sC0SdOh4fsTNrc37w6di90w5gRKitqapT8ha48a4UxwPEDsw1y8/9eLf14A93cfqxc1dVcVg
	5u0/eVcFb0A==
X-Received: from dldoa1.prod.google.com ([2002:a05:701a:ca81:b0:13c:dc9f:51f2])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5244:b0:38e:9eb2:9d43
 with SMTP id 98e67ed59e1d1-3903c5b685bmr10977529a91.16.1785978740061; Wed, 05
 Aug 2026 18:12:20 -0700 (PDT)
Date: Wed,  5 Aug 2026 18:09:08 -0700
In-Reply-To: <20260806011048.517229-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260806011048.517229-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
Message-ID: <20260806011048.517229-8-jyescas@google.com>
Subject: [RFC PATCH v2 07/16] mm: Define function to create a dir for each
 migrate type
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, ljs@kernel.org, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 62ABFC0008
X-Stat-Signature: 7nbywrhgdwffeci1pmthcqi6tnc7sapg
X-HE-Tag: 1785978741-22052
X-HE-Meta: U2FsdGVkX1+kw+4ou0FY3cFiXxHbt0s01MQKDjf5wzrzM5t5LBg7110Wxkjv966Hw+X2Du5qjv6q4zdqOzdo/7wTLVVKZd6dqOYA/m7RmJo718A/63TmETvU1vEJr1Wj66KmSlQgfYJ5mSHqIE5gmPFeN+is6/+t6+Zlxt+br+sqArzppdmYYdj0efhp85Ezcfe5oI/Gc/wQ1+Ug8/MbppjixUJ5Icgl4YEqncfe271ztqUySxb4vDP7UwgrsQkki91dRzpSGaIjV4oMLpIWGtNuFCDx26mrU/YuAMUr95Q2tqwjb8z9qSOf7P7gx6gTth4/4IWV6vso7YDTrIxv0jgVd2JsGvkjX4wZBGJ/qcuiGX+UvYFsrpi9o1n2J1QqrkKc88a45C5Z0esF4k1nTxoOzdDkY56S0k5s2tZdGW0cBgWEC3CCnzhP2+n5qfuRgJj6LYzPHII/E5K1WZWxokJcAmzyn88zv4i0STYpGx1shScnfXQpGR3170QbC12loNCCmUUEkacsY3uPAnrurxfYTb4+SWGU/ZmiAQy31jiYvFOMzAM6StCVhWrPvpMIRVJiwe88sCGwOD7tJQGSEyxMivvumKtpfEb7aONuPcK4t5O9/0tuvrg1pDGQaSeLhptsONgBaQUs3XbyQEOMqaw9Hr9cYN2zg7h/5RSMfQbhgV1w99weZjNuIBqwlIap8VcE7VGVY77pqP/hBwuCwvwCpNKudy2JIRbifRDd9TfcuminnsWcY9si9HHuYEdWXKhNkUp16OMX2pDZHUYsZ2wpFNX71ya4eBFHpKULP/28yN0G7w7wx5BsY8soP+m8VqgL8492dHCcnbqbY1/rgdFm68D8DQXdvSE5XFVGgb8zddcBTWZ0eeW2mGmTluPNYgOmNnxD3+/RJjqxxqp0cVFunr5BkRmCuG5HdjbzfzMZ/DHx/+CX6+KQnoNqB7YuBY7GYHrbarWy4Sb2LrT
 yK3jFLEj
 QLydapEAQx02osGj9FMfq8o0AU6LSRlg9xONy71Xu8nwYMdaxFjoFxdu49Dv4VlPzMNmUyu+UfXTumomVLo+9VQTIAnjLsFdMKjXig0m4hRyu4/P/wFT1bQXLHZLzxw/rDlNBiQMiKJiLxmd79xU0NpBb2bt1IklCq2al8mV0ldLG1wS59sSWNz2etDsKCa9phtJKpYbmRrUBzsJqb6jdtQaN42IqnQFJ51DQYtJRad+LFme6yUvflCtJtLfsRXdA9y0dOIOzwr2V/FLuvaQUzDiztWZhRqIiJ7ZL3lQ7Jm8nNv3237DSrblrfyRoNQNkc1wYcIx2Kp3JRFqR/nt45GMs0e4sm33WgVh5wiYIDUWp2wVA7HAMY9eMV6gQx6EX2K8FKDETCKlddZ8HUCoM3iYQOZAvjlr3PUYgNb3w7b37b+UqGPkQkr9IaoL8sxMNgpMQXPH3b8vx6O8WlyKTVyTvFm+ITega81bfKsgO+tF3Bg4eGakxsvJhW5pn+tEPwa573ofCF7nboh5uRe9WvfF4iEKt1wZSVTnrlOyyQyNhl52aOttsX2b7OP+RxHK5JgTRpzsuS8vZ/2w/3yZkeY1bHzXTUGNmJt9LlFOf2W0afkZAkf0tOqNLzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates a directory for each migrate type inside
the order directory.

This function won't create a directory for MIGRATE_ISOLATE due
they can't be allocated using the Buddy Allocator.

Note: The MIGRATE_CMA directory won't be created yet. It will
be supported in the future.

Signed-off-by: Juan Yescas <jyescas@google.com>
---

Changes in v2:
	- Update comments.
	- Remove unused parameters.

 mm/page_alloc_hogger.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 24856f7ea5d7..ab39ea300704 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -127,20 +127,54 @@ struct page_alloc {
 static struct kmem_cache *req_alloc_cache;
 static struct kmem_cache *page_alloc_cache;
 
+/**
+ * create_migrate_type_subdirs() - Creates a directory for each migrate type
+ * inside the order directory.
+ */
+static inline int create_migrate_type_subdirs(struct dentry *orderdir)
+{
+	struct dentry *migratedir;
+	char dirname[24];
+
+	for (int mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
+#ifdef CONFIG_CMA
+		if (mtype == MIGRATE_CMA) /* CMA allocs are not supported yet*/
+			continue;
+#endif
+#ifdef CONFIG_MEMORY_ISOLATION
+		if (mtype == MIGRATE_ISOLATE) /* can't allocate from here */
+			continue;
+#endif
+		snprintf(dirname, sizeof(dirname), "migrate-%s",
+			 migratetype_names[mtype]);
+		migratedir = debugfs_create_dir(dirname, orderdir);
+		if (IS_ERR(migratedir))
+			return PTR_ERR(migratedir);
+	}
+
+	return 0;
+}
+
 /**
  * create_page_orders_subdirs() - Creates a directory for each page order inside
- * the zone directory.
+ * the zone directory. Once that the page order directory is created, it creates
+ * a directory for each migrate type.
  */
 static inline int create_page_orders_subdirs(struct dentry *zonedir)
 {
 	struct dentry *orderdir;
 	char dirname[12];
+	int ret;
 
 	for (int order = 0; order < NR_PAGE_ORDERS; order++) {
 		snprintf(dirname, sizeof(dirname), "order-%d", order);
 		orderdir = debugfs_create_dir(dirname, zonedir);
 		if (IS_ERR(orderdir))
 			return PTR_ERR(orderdir);
+
+		ret = create_migrate_type_subdirs(orderdir);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.55.0.629.g250fe7f194-goog


