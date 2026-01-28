Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8017D46C01
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 22:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9716B0005; Wed, 28 Jan 2026 17:57:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0186B0089; Wed, 28 Jan 2026 17:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C94F6B008A; Wed, 28 Jan 2026 17:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 859226B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:57:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25F905723E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:57:28 +0000 (UTC)
X-FDA: 84382885776.22.A50AD0B
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6849BA0006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 22:57:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mdDSWLcq;
	spf=pass (imf15.hostedemail.com: domain of greenjustin@chromium.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=greenjustin@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769641046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BVN9WQ1f1WUnnewMaQHeUq2RLnvcgWlrulAr8n3avs4=;
	b=3J7VgSQSR8wqAwUV1vLXAa3Y2WMtaqPttS43y5I+l7oxi4UTjHXL9Oj5g0sgXAqVU9WbJF
	XYcs+g8WBewZILK6wUQABRFEUp8aq/o6Y+5GLKcS+YPC4BWF/8eVO4CgnWLOVFm9FiOR60
	4LuQc4JlaCKNxzxaU8Wah5GzL7JHWpU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mdDSWLcq;
	spf=pass (imf15.hostedemail.com: domain of greenjustin@chromium.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=greenjustin@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769641046; a=rsa-sha256;
	cv=none;
	b=QY5o1dnznNCIVgCq9WwQHpfARg6id9/7yr3DqUXbbJTn4KqvTW7z3BhyDxDVXLgMkraXT+
	z0ya09QXrrLEj3SOt0uGhnVywtTdp8zucQhRiLU8Tqjie2vVe9PQU8Ev8Qbko9Mb2D6sws
	nHEtBrt8PWleZhlF9YTUUTBfwYc4h+4=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89464760408so2530596d6.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1769641045; x=1770245845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BVN9WQ1f1WUnnewMaQHeUq2RLnvcgWlrulAr8n3avs4=;
        b=mdDSWLcq+TrD7SV9yRSNReNKVqmC0Gbr+tG3z5VrP+S7gN3VP+6chR/SSvRedEj79g
         CDlmMCcpdgsLoGWAEkjxpJFAB4ZPUitBrEXFFOFm/V8meLCYjS15+Sr/JDUgdNiKW5+w
         A4XgFyIE1Dw10kenG++DSFnRNUzc5MVh1GRQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769641045; x=1770245845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVN9WQ1f1WUnnewMaQHeUq2RLnvcgWlrulAr8n3avs4=;
        b=sJNEI93n/hYm/2FsmvFLm1N/ClRB/iTgVc/ne/GTFIaiBCswdVqi3v/yWbjshCkQWs
         aOgFXyUtKyTBJa7W2m92euytxHTq1O5BzCib9cKd/T8nD2x7j/a6FtvWH4FxCsYTuFMy
         KjC9wrGjM3bx9muE6QSuCfBAFNJYeQFju4vssfRdr24b9yQQsGxFoW3EJEbJwLxOgOnF
         EU1EVFRDG5bm2ZJqil7Mww8qo4va+stoZuqEpiS4ZC4pJS0MqIB7zzQgU5KinBAMvvNc
         cSYeBLTRqSugPYS9qVkyI262ib90cte8TEmKF+4P4QNlYauMXxtVD8dfTN8R0P7r06wq
         wD3A==
X-Gm-Message-State: AOJu0YyP76bPDMTJlrIuQSqH8N7RPaM2kvA0OXYDrW1vcO26Zq8JZcQQ
	omnNTEMuPzT+gL/fcjswwdDQMxvvMS/oh8OVeUH8GbrjP9vqjfAgzf2C6ZEp4tvXCw==
X-Gm-Gg: AZuq6aIxsxO+MdhWu/VqSqGQPJrgITwO38sw1uklkOmp2nToCvAoBtGlVXXWrS/dwk7
	kQgVcejDG8fFo4kWdqvVwABQecSxRvcLub3HRBOJBd1G2qCTOemyNI2n4AN/uTac20Zl8YC58RQ
	SzwkazWRw2iDNZztVPnSYrUcSF8YyC8hZk9m8En36YxcGswDytqQJI1Z4jOZU5p6Fz6SmXiPJh+
	DJTPzwQqwbTy/fm4+zwAiMqUvhJHTm2YAeSWCvg5wEZ9ZaaeCqywJtBnf71d4VwniG1gRUVwPrp
	6LjqT6ndKmJjvKpMTPMd+9znNoGC/sVcJVr9Ym5AWs5N3P8oGvENQYVzOzLo7YqJSoZ8JIDjEt0
	XSDDrHHSsA7oKXk32Sues5WSuLoLwGCQcn8Ohj2kweoI6AHbmSNU+7PTqn9wQtexmXASQ2jgUoI
	5jQy+aOq0dZCSHuS2iwFUqHKHfgNQGXSS9D4vazoR/erhOvBx3ZM4Feyw7my8yDw1fyiQJABn7o
	zP5HFLe
X-Received: by 2002:a05:6214:29ca:b0:880:63b1:3f57 with SMTP id 6a1803df08f44-894cc8c8f68mr98777736d6.38.1769641045371;
        Wed, 28 Jan 2026 14:57:25 -0800 (PST)
Received: from greenjustin3.nyc.corp.google.com ([2a00:79e0:2c11:9:6215:4385:468c:4289])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d375b62asm27815526d6.41.2026.01.28.14.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 14:57:24 -0800 (PST)
From: Justin Green <greenjustin@chromium.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	greenjustin@chromium.org,
	greenjustin@google.com,
	rientjes@google.com,
	bgeffon@google.com,
	arjunroy@google.com
Subject: [PATCH] mm: Refactor vma_map_pages to use vm_insert_pages
Date: Wed, 28 Jan 2026 17:56:47 -0500
Message-ID: <20260128225648.2938636-1-greenjustin@chromium.org>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kdx1tazkngsddrzrstjk1geq44qk77xj
X-Rspamd-Queue-Id: 6849BA0006
X-Rspam-User: 
X-HE-Tag: 1769641046-424910
X-HE-Meta: U2FsdGVkX19RHc7e+550GVyxPuBr5Du7LocvJqbLklwhHXAKmKqiiMn7VtrY7c0iAAJaYY8ybBTeDw5986hZ1qtnR7zx5mGBHP4yTC6oKr6YqKjRGKuc07GWcVyyDUzuSPNDVQlNpHom8zKa7NZLsMD9wZ7SM7UiGTIcVQ/NfKinEBeJeDTHqyW6WUSA4qReBBnIKYQXWgYocBxecd9Nu2TIxfU9a1X9M0VV5NNNlLv2LHGwO75i+Xm/sFY64PlUcxsbjbyBuuyKEmfAdLZ0LsygtHjjQunYx3qhPwtDWwCJbK4iqaF/uQIiyEOmi+CzY6xpyRgz80PTNWDr3tTqTDQe7aZttzZ2oWDswSVS7hOjXt6mdeLagI9DJWRIj8LhgLv0AhpooLb77G74B7vyHEi74hNL1Invy4k+vESO7uPw+yXGtTO8Wm8iSInJBcg5K72wqYJSpiCGt5oWNKL60F2o1vWGZ0El1GxbY/hIP1r7w+J/6MDEyTAu6MLU9MVrIEaIZolPyenT06A1MN3BgwruFCtzyHArEm1NXZFXfLC84X0hVt99t9MyjrekkO3TtlJjGclWz8g0CvYwp/MR/AZzWwuwDiXjRrf0EQ5MdBhcFOpnNHYKciYbrbTAZzX4LRUPuClbVWDtAz0/PAj5JrDvFMuuSGr2gOgSJGVkZ9E6bjO81OjEaGd5vmWQEbmdiRlw077B1yPdR/VkVuyFHDxZGzdN8Hu0VyQ2d3YiMLtOlibr2GmqOqnMdqSZUp+fE/J1RYscrL6cKDsQQBic+aeuqUdck0iq4jS0gNy3kzJMMJKqGlzlLId8che4R/77T4aYhc7+BZDDZZnpsF73BeYyHyzPSlirQDppyvpA3WIKyo/Qa2uJ4aOWqjoLPeWVZ6eN/Td1fKFwyxPhs0rH2WGRa/EgmlrLPzawTm61ClWpiJc5HqZoKAa+o88BePyjTokXTIkSJZG1o1L95wC
 T1kGTHqV
 Y0WNEFl/e4+TJoh8/Mue3cGyxHj4aSIjepOisx9Kc+KZn8dHa7+ImLlbozQApV0Gt7PR17zGDX+NiGcZg7AVMx+Lljoj7GR++vgn9hpPbHmSnmdfeqxS2hvAmbLPsY/aYhbjoLe/iLLjS3D8A23/fx9bsb5SYh0VXoY7Ua/IcHvmjUjAo+DlP2a+7BzCpv+38Kv+WP243Ac6ZCbL9UuiAoKfhIOXePPeSFAWT87fFhy86HwU0Mf++L6fzRIjMKzY7ec8Vz+OoYhDOub2M3JwGI7Cne3qVQKLePEpyY9preXDnVNYeLKwh6E6UzruNUaewdmM/uzdunXq/pwi26jRQEiuF4kISEnRDQpkgGPBsZfMo2HMTQeYtm8kmxFtp5r4EaRoZZZK95mt+k8g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_map_pages currently calls vm_insert_page on each individual page in
the mapping, which creates significant overhead because we are
repeatedly spinlocking. Instead, we should batch insert pages using
vm_insert_pages, which amortizes the cost of the spinlock.

Tested through watching hardware accelerated video on a MTK ChromeOS
device. This particular path maps both a V4L2 buffer and a GEM allocated
buffer into userspace and converts the contents from one pixel format to
another. Both vb2_mmap() and mtk_gem_object_mmap() exercise this
pathway.

Signed-off-by: Justin Green <greenjustin@chromium.org>
---
 mm/memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..7ae6ac42e7d8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2499,7 +2499,6 @@ static int __vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 {
 	unsigned long count = vma_pages(vma);
 	unsigned long uaddr = vma->vm_start;
-	int ret, i;
 
 	/* Fail if the user requested offset is beyond the end of the object */
 	if (offset >= num)
@@ -2509,14 +2508,7 @@ static int __vm_map_pages(struct vm_area_struct *vma, struct page **pages,
 	if (count > num - offset)
 		return -ENXIO;
 
-	for (i = 0; i < count; i++) {
-		ret = vm_insert_page(vma, uaddr, pages[offset + i]);
-		if (ret < 0)
-			return ret;
-		uaddr += PAGE_SIZE;
-	}
-
-	return 0;
+	return vm_insert_pages(vma, uaddr, pages + offset, &count);
 }
 
 /**
-- 
2.53.0.rc1.217.geba53bf80e-goog


