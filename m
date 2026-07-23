Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273FAC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FDF6B00D6; Thu, 23 Jul 2026 03:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D13A6B00D9; Thu, 23 Jul 2026 03:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE376B00DA; Thu, 23 Jul 2026 03:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD7F16B00D6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 714E8C0420
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:29 +0000 (UTC)
X-FDA: 85019268978.16.17F3227
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id C3EFDC0003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XqOp62kC;
	spf=pass (imf28.hostedemail.com: domain of 3wsdhagcKCDMYnThRPhVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3wsdhagcKCDMYnThRPhVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793027;
	b=A4Y8OFMFBCaFB9PKHKyVHIW/139a3Tq11ojVkM42U1RI3SbcW/Pq7vkaHvASBZi/hKh411
	R74WfsqhKAJeXngQsIF3uZKZ2oKhBRLlCoOiaHjOwbkTgG0o0rKOo7vll8l+xJW++O1+kx
	4bdX+vBg/+l0xWdM2HwFnyzdy8WR9nE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XqOp62kC;
	spf=pass (imf28.hostedemail.com: domain of 3wsdhagcKCDMYnThRPhVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jyescas.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3wsdhagcKCDMYnThRPhVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7CBNiHk+pogzDyhH1M3QCDP6vdmZRlAwIqSJkV+BV0=;
	b=EhZws3lTSP+VOVgEfWuI5HBMRFLRfp9IA/GnfRMP+4/lRDnM2C7YxpKiufjT7ZEiqvZaN3
	Vd+jgGgQ9T1z33AnOmF6tKJnIF+hKdFR/hsSBIMOX4J90fOyv+uZ10iccdjVsRqNouoV16
	Z2Q85FogFz/Eb24HrXS2mVtfUWcukC0=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb7049fa552so374011a12.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793027; x=1785397827; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C7CBNiHk+pogzDyhH1M3QCDP6vdmZRlAwIqSJkV+BV0=;
        b=XqOp62kCZnc3cSP4BmrvjrUt6QQqf5Fh0kBD021QA1hKQdM19MtYYjLgbQpn0ILzD0
         wSvEBjoKUqmxzSGOrydy9giFcnyTb8fucP1gXL43kvS+xZGd315lqHUwqDogG1mMayCe
         Ed18M7M4GiaK92fp4jMXNjmbLLijpKjaUvttNbQuh+C7LmmtuJ/sXzN/F9keMx2m67dg
         +eA5fS1ixgn6ZnJbFcOX6Bb1lyNzHGkbP4nLh7OohgdkHM+x0W1EeCb/nCWJU3BHRZWO
         lt/b8SyuuipnAmlGJlC+5OY2H4D1FCD/NGaalhcEgROr13uMOypSXw9rYkQh/D04Vhzv
         thEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793027; x=1785397827;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C7CBNiHk+pogzDyhH1M3QCDP6vdmZRlAwIqSJkV+BV0=;
        b=JohOz6ytdRDH1JOg7Pkp+FFmv+RWIqpaHsiw/e4pd7zPWPDFs0NGQjWSnuqz6qm39G
         NAbWlydKHvLC1ZlY306Z9f2xDON8uasTA71QvqZOU3s1L34yfQZCxmfUCXSasmEnWECg
         1Ih5L/FcE/q00FLUuZYO8QmRKeaoQxBeD67jiw2lH7auUckk0jucrBXNoQVVuIR4FGbH
         n3TgXpo2li/Cnur/NcVcfC440rsAvEUNfxYkScV1IXR9I2rC0wCxORRPMQXBzC83pCTW
         P0T2+P0g3ZtPb8lMYf5Ycscii6RzTxY30tov6nf5iNNPQuHoq8RaBPzqQkoXlWXhUVLG
         ej3g==
X-Forwarded-Encrypted: i=1; AHgh+RrzkpCVif5e6afjabRt1IHpfTRcwfT/mQk5zNypyqWzb1QIUkqxRvWryZn+qyp++m9fDW8AvdfLMQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5m/63FX7wM8vO/pbKMibQazaxtlcZJ+xwutI8mX03FrcbjQFf
	BkN/WOlg0SQ/BcnM9JmvkteOlRj01Ddwg8mSOFYheMG2Urhde/SucQTkKPKl/b8oIpME/7zOATu
	1Zs1/Ob1KGw==
X-Received: from dyng25.prod.google.com ([2002:a05:7300:7f19:b0:30c:2bdd:dcdf])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9f09:b0:3c0:9c19:b275
 with SMTP id adf61e73a8af0-3c44b2ae3c9mr2165420637.67.1784793026464; Thu, 23
 Jul 2026 00:50:26 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:13 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-10-jyescas@google.com>
Subject: [RFC PATCH 09/16] mm: Read the nr_pages_allocs value given by user
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8su46tgihi8myxuh7cfus4ud3raheokt
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C3EFDC0003
X-Rspam-User: 
X-HE-Tag: 1784793027-562769
X-HE-Meta: U2FsdGVkX19YbkttFyaHY6aOUFOvg6MzOlMbro9Oca9wFd8H/5vYAM/Mb7gYRcDi4hO2dn19XmOBkkSJvnAE8qNN+p6yfvyyHlYrVqtmOCfSvNs/M1w9DJpTU+FZs762tPBmPWtIKqsIzj6gp9+FnnizR9vEmUXL7YMmxArt6+sS3TBgIKoMkeIlRfnd8Ufl82WiqWn2rtbvUFnU8hDZU4b1OCnLtcMSsFbymE+V9jYsRXzwZdJbm3yWxyBYI/Gf49sCsZJ6EpvBwaVO/GqgDClAwAKDunkvdkt78EyzlMQ2ZRwVaHN+mSIFti2iX+biCYu6Hxdom3TZsWCRpJIMSHkTsZAByzvyyhdmUOXkGcou4/Zs/NTi3cw1LacBnjyRSPOzq9utcE8gWnmqfmJe7hN5WX98JOWDHgK/7fr3mNKzAZa25hclCWzWWW/1L2xX5VPNZi68xezoqzCOI+4PYxF5MZI+729XIca2bXsxpJ3WogEwnTVHgNJ2yoOfZ/XhwdhASXPG141uf4YfvTDjcU+K2/BXnXc7bphRWV/jBTN9p2E4QBZuafhDJIRDFNmBqN8cvMS67+7HjdUipdHZdcwB3YrQbVG977xLn/Kyq5fVVTbamxgcoerLoNhGdrC2Wl4qX1hXPxiv4ATkBOPZki7f2IO4Ug/BFXQEt1KRfDAeyQWvQD0SDbAJLxLvrknpMqmF1+QRDpJSla3F3aPrrrPWJ/3JKH+ztfnYeTJHx0qAa/eMFpSip4WoD4wBpH/ookIL9a41v40N2JMFtK0hJ7vWEXr5UWFc8H5QwMwjlO2d6zH9N/jUopGMwfC+4zxqErAv2lZrdILRVi/3bMJ+LAOWcBsSAS6bRr6wUttAtuzatJbuRzgKJVTtql11IVmMQWmD0cGRHQ0AsOlMyzYi0PoIskNRu7sjRdUfvNoXwbUu0UW6gaTuboPhnPDOF7LpV1G0ANg5yGQ+rYjYOdb
 l93BV0y2
 xSmpouUuWtyQU3Frf+BeqBLqUgRQkbRkVbDsKG8Bzj3Bn4/TVIVHEmSqy8qlwSo8zD1gxyjdl54HiAtwT+Zum0djKDwZ7UMMgXM2dMMF9dscQgY4fW4EvqzS/Dis+kAVG2naame5iHCsLXSVa/tTyKA/jGtcNNQrFcZ0owsK/LJ6wPUFmzXx3U68NQjQAp1mAfAtY4L7YlGe3kxEwqOsxIprPxZYv8vEi1Ex0UAWZOIyln85MqDdYLcJXXUGWB7yeadpuvv6a6ByaQvJls8A65nzS1tCG8mrKabGc3Plmmdm6SIzz/pf08xGe2fVW575QGWPWitaybb9GBt7pFnOssks6g0eT0SWjH1RulCYBOVfvkrCn7FbM5emoG/liWc0A2pHhq7S7+YU/gvjPXzdlXcZLgLUGr82rWW/k/Az3/ZP8W3/W52Pm5qA0s1N1NUjj1DmoAw8ZiGoKHSCZQp3XhLNyrOqwesLJ3RhLFRCFuqN88ZMsuG62BRQ/EHgK2qt5vOj0Qrt/RUbsze6NTjsnGbdtbl3j+QNOzGH9l8r8dJuktfiZBLhXl9H/NYqGO0mx39WM4tdXEhOTaD3dT1jBqGCrysKp/i8iA10qZ/Gkk5LY9plRpu/qmpUYc2HgRA7jiWLwj/Rrzr0gji/K743Fue4MCZMaVkHz/mUEo73h3oUAlOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change reads the nr_page_allocs value given by the user and
validates that is an unsigned long.

If the input is valid, it will allocate an array of nr_page_allocs
size. This array will store the allocation ids. These allocation ids
will be used to free the allocations.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 3ffad74a0bdf..60dfddf6b441 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -136,6 +136,19 @@ struct kmem_cache *page_alloc_cache;
 static ssize_t req_page_alloc_write(struct file *file, const char __user *ubuf,
 				     size_t cnt, loff_t *ppos)
 {
+	unsigned long nr_pages_allocs;
+	unsigned long *allocs_ids;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &nr_pages_allocs);
+	if (ret)
+		return ret;
+
+	allocs_ids = kmalloc_array(nr_pages_allocs, sizeof(unsigned long),
+					GFP_KERNEL);
+	if (!allocs_ids)
+		return -ENOMEM;
+
 	return cnt;
 }
 
-- 
2.55.0.229.g6434b31f56-goog


