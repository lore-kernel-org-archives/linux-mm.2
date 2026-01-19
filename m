Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 542B6D29C2F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA486B01AA; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3B36B01B1; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED8E6B01B1; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF426B01AA
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 336A61AAB9
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:22:56 +0000 (UTC)
X-FDA: 84348929952.24.E7CE6F0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 69E6D100005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:22:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dEuP9wDJ;
	spf=pass (imf14.hostedemail.com: domain of 3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctFjNYhvimSO0VVR6mHcQICH1dILW4P6822Kd8ujTu4=;
	b=YjzBh86+obgCG7MOGyX5WpSRd8xAc/iEnO1t0S6I9vztJt40ugIUkALyk6pTouI7DHla6D
	NRtostyPgTxRN1/2WEVYipcNSkpoTyehVDxz/7T94mD4cIjQ5GijqDoD7ug3q20x/3pgyS
	0wvVLSXwp7Cjl7Bz7z9nqUp4jxrhZS0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dEuP9wDJ;
	spf=pass (imf14.hostedemail.com: domain of 3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768832574; a=rsa-sha256;
	cv=none;
	b=mm0NFVrrK1fKcoI1pq5Wpc1B8Ft7mpoNpSE2qP2Lcfm0jMJTYE8s2g6Yc3NmrZzvXYuh7c
	tLmlyVeaKb0sWvkw+RKl35w7ZeR9SWGC6q+SZ9kQN7E/H2RSnZGm9SjAkB6HmC2ha6aHL0
	Mrh4xxw/e3d9YbtbEVxDITIlKt1EOxg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4801c1056c7so19988315e9.2
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768832573; x=1769437373; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ctFjNYhvimSO0VVR6mHcQICH1dILW4P6822Kd8ujTu4=;
        b=dEuP9wDJ482W1iSMoggJZFxMHfUjQSeF6WgxATYG0N2VhPUsFNGaX9Vb0EDTRgrLpX
         WYM6G9Gn5BIHkYU2Ld4tafImdv3um+ecKX2N/sIVK/uTBBXadbfyf+p3xXq4jr/7u6nU
         324+YSGwVYgqj+FKEZDt+jpTx/b767v/Aho22Y6Z4oaziawbTYw5gVFtfWvnqSWvbKCv
         lB5hH9I9iEzOhmAu6j2z6FeN9ckzv0atwsrG0i65t/x7GV6/AiRk6YH/96sgn/lJDxck
         doMzaDoO9JDM9TkL7KodLCppkbIQQvhU71HrhMUzR801+S7pJos6Xy3vim0Ilq5WxgFB
         F5fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768832573; x=1769437373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ctFjNYhvimSO0VVR6mHcQICH1dILW4P6822Kd8ujTu4=;
        b=oI3azOUb3l/dzSR0mr5sHb9hL9r81cDhZlCWORbi5n6eFbsuvdo992uvKnrhiWZdMz
         sMWE0DAJ5lRPKx/HAT7dKC29v5NT5nrBRpTjnQJV3j8MOnwRmI6bg2HwYraz2eiClLi9
         oDyKLv6NSI/stNYOKaD1SsuiI3AFaBpwx5YjQWjgLMa4CXFZNeG9Jna3sgys7ruem5s7
         mWm3H/hziZGG/moeuRzB+JO0Uou7tlyPbxZmcC6wpCBF+yjjren1HlUinTXFmbA1TkA/
         Lp+2nX3tNxYuPc++A1vV1yovWu8BzpSKKv69IWb7E6F4FrwgFxj08GHzU0qH7mU35A5Z
         57Mg==
X-Gm-Message-State: AOJu0YzQmRM1ha0XUJIzjDGVAthQ+mnyHYhAp4wjc/8VzpBeuMUiorwG
	ciuCnJJz6lDNPe/IEdi0+2QZl0kD6yuHmfNmhF04cgffpN4xJRo6z/RBV9fZHj4dJmP9UKqsMvK
	KxnfzsqPOQ9fmZmf/HguFRpXpwnL8UB+KFjn2PaCMhdyOikepc8UFURYL14h886+cfWSo0Qx9Tg
	ErZzSfSY4+oRRm7PHVGaymd2cPgqQVBFK8qyv4I3S78Q==
X-Received: from wrwj14.prod.google.com ([2002:a5d:564e:0:b0:432:85e9:432f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b81:b0:477:9a28:b0a4 with SMTP id 5b1f17b1804b1-4801e2a2176mr148484965e9.0.1768832572948;
 Mon, 19 Jan 2026 06:22:52 -0800 (PST)
Date: Mon, 19 Jan 2026 14:22:46 +0000
In-Reply-To: <20260119142246.3821052-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260119142246.3821052-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119142246.3821052-3-smostafa@google.com>
Subject: [PATCH 2/2] iommu: debug-pagealloc: Use page_ext_get_phys()
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: udhr1hfpdgwbbftb4fuyk4c1e5oekfmj
X-Rspamd-Queue-Id: 69E6D100005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768832574-553722
X-HE-Meta: U2FsdGVkX1+sA7sjvdKQkibEzgMv69wmTZYpXfEzlFh2Wxm58HS95cz//RrIfEmuDxLGCNHNX9301TJ6b8bL3hsuaFJIXCxytUJg/UfTaWundxHVENOTXkYRCm5K8xnpW0m56BrTsIYgVajEPRhLRlaby5hx8kC9c8n/xDcDqB6qrJ/JK0M0Qm4AQfL67aOXrfTMyOKDDzGYU/zkqA0Wl2jNeQEYFXqHHI0beEohVdwRuhRB1FhHHVn+uMjApHA167ym9ciGEP8cYbBLsWFD9TLOJyI8PBbD3HxYKKVYff1Li/lgiJZoUSNPsUTDd4Cm4HW+x6HQm1EsdhFdCy01z9CQrCKXxcvoWbZ1fVYKpZfBN49hEN+xnfWkCdICjVQVy+Z/KZKG9dVGVdUZ0qGQ6tvVX4WrgYoashQBwh7j878IShR3I7DKbto6wHe4mf9YsttJm4sN1SMmsSe0jTp1NlCgxYMwEKUo3iOPNlNivrzMM3nkW4y07Dqe8nLV+9ac9nqP1A13qkiSyNT/ZfHp9ztOhEkHKeRizhggnLPmI4DoPZRUlcmaO+CTah00H1ot9GpfFwpOnB9G3kzq3Re8FgAvIy/jzSoJgy2+DJPC43z+Wu9JK1p6XNWXl8fyW9ENIe22FiT9HMO6mlxavTVc1DqOyuz7J3SPjyAV9xd2FTPC4AtwVkIhfEE7ym28q1+AmOMo+AsIe5it3VFfsq+0XGNqA+i+YyEQNvr8eQxtwbCKjWgH4UE5cRCZhKVwFgUHxcHoDbOr1yOkGQZyIkwJv87Ry2Kvj/fTevUHhjuwandAjliEg5xUOT17Kq3lpsq1zqp5svoJqN0M8m2c4Rg+QH7BfKhwGzw0SanN2ZhRPSs9lcyVQFknNxjkgwhE6IdnZe4evOhSx9lj0cEEmXgdT932eKKA9Lx4duKOwESZ4XFwA4Ui/3CmU+D/8EtEMWBu+sfZvjZZ0gMaq4aFIXo
 kHpU6nPi
 9aQPhwwNqUNUWA5zrKpG6V3nc1gRhfeXcIrXvW+t8ZQfwUItfvM+T/xMpqEM31rsrHmGOUD6VE5itbqwbu062vEW6ZuFHpWF0uxGwcs9DhZBx8KNh2BaOquNUuaIcXEOQXSh82HDNfr/mjJGnsw3KP9ncewaQ9nrMbpDx+PbQLaCFWE68hmhXZioaYn+WBW+hodGLCY8ZmXgn8QrCroMaWFNIHN2v+fOYweioEHwIYyknSd2wEcyVKNgR921WHgKEMk7R+qIIcOk2kZYisUSSuwyXQYF7Ki4mS7jnfzigbKUYPgh53jprNQAAMSTQY3NL7oK2MaP25FUBfjTH17Tgd7/TDYK8eiaoYv+C6x8RTQnrB6Z3SB7PxKRbkRp+bmVlZo//+NZ88q7janxYYOk0EWD82wXtF+jQdn8ylhPmVlhp3/OfGnEW/aqRqnlXQu1j3UwBE5nbph5P8pcSM48dQ37I2ZsJ40lqnS4hb6wGhPL64Xk7/FWGOoK9SukvwRKV9n8B+mJhztMqFdTy9qkvCUHAywYZdfxHQ+g5Olnwfr9AD+4ZpiXoI2uyOTisa70RTCWadThA5EVT31P+7nw4EtQQP7Gua+hmZGl1okJR0V4mlEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of calling pfn_valid() and then getting the page, call
the newly added function page_ext_get_phys(), which would also
check for MMIO and offline memory and return NULL in that case.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 31 ++++++++++++---------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index c080a38f45a4..9343af3bdbb6 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -30,14 +30,6 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
-static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
-{
-	struct page *page = phys_to_page(phys);
-	struct page_ext *page_ext = page_ext_get(page);
-
-	return page_ext;
-}
-
 static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
 {
 	return page_ext_data(page_ext, &page_iommu_debug_ops);
@@ -45,18 +37,26 @@ static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
 
 static void iommu_debug_inc_page(phys_addr_t phys)
 {
-	struct page_ext *page_ext = get_iommu_page_ext(phys);
-	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+	struct page_ext *page_ext = page_ext_get_phys(phys);
+	struct iommu_debug_metadata *d;
+
+	if (!page_ext)
+		return;
 
+	d = get_iommu_data(page_ext);
 	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
 	page_ext_put(page_ext);
 }
 
 static void iommu_debug_dec_page(phys_addr_t phys)
 {
-	struct page_ext *page_ext = get_iommu_page_ext(phys);
-	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+	struct page_ext *page_ext = page_ext_get_phys(phys);
+	struct iommu_debug_metadata *d;
+
+	if (!page_ext)
+		return;
 
+	d = get_iommu_data(page_ext);
 	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
 	page_ext_put(page_ext);
 }
@@ -104,11 +104,8 @@ void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t siz
 	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
 		return;
 
-	for (off = 0 ; off < size ; off += page_size) {
-		if (!pfn_valid(__phys_to_pfn(phys + off)))
-			continue;
+	for (off = 0 ; off < size ; off += page_size)
 		iommu_debug_inc_page(phys + off);
-	}
 }
 
 static void __iommu_debug_update_iova(struct iommu_domain *domain,
@@ -123,7 +120,7 @@ static void __iommu_debug_update_iova(struct iommu_domain *domain,
 	for (off = 0 ; off < size ; off += page_size) {
 		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
 
-		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
+		if (!phys)
 			continue;
 
 		if (inc)
-- 
2.52.0.457.g6b5491de43-goog


