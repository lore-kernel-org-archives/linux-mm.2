Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0FBD35690
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29ED6B009E; Wed, 28 Jan 2026 04:31:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6626B009F; Wed, 28 Jan 2026 04:31:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3F76B00A0; Wed, 28 Jan 2026 04:31:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B53046B009E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:31:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BFC2D3D30
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:11 +0000 (UTC)
X-FDA: 84380853942.18.88E88FF
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82AA0C0012
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:31:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EtU1Plkv;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKtT6XQ/JEquVZGbic/ESwJDGPsZ48peRTM8lwccGeU=;
	b=C4bPw0GzFRZrCoU/M3w2qYfb9fyThkWKwx0XArbKGF767k4egGRsw5wHNf7iWN2pDMPupv
	QPNG/1huTh5mOZhsM9wFLmlcF3DM9Z7CK2UBPo/4hfQih53r7GeqvkyDNsmYE/QXfjeclt
	EOBm4mzJUkAD9uvTAxWiJovnz6juAnk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EtU1Plkv;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592669; a=rsa-sha256;
	cv=none;
	b=1UBixJc6/Yhp/L42OnoUjZTbX7CAOhso1PFPl9l8H6iMJZ1UU4rXLfuX5VjVHQdnFUWgZd
	xhztnkqaSHrJScohQ/CeQj+592GvnZtBPA9vUMX7Z2sWiu439wE8eHGx+61TA7O7LoVgDJ
	j3Po4tgfpcgA6VrG9pXqWBestQRhOto=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3530e7b3dc2so5520126a91.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592668; x=1770197468; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zKtT6XQ/JEquVZGbic/ESwJDGPsZ48peRTM8lwccGeU=;
        b=EtU1Plkvh1YDxWnYKttuZUpSXFLQS656Veck6YlRoElQTb3GFMpkh1rY9CYdAwninJ
         zs5Gk5TrX9wPz6YACWuupQxBI9RE3G0FLQwI91+HxH5KooiEoRzayN363yGro7Bqa4So
         41kWugIWnhRxgHMBiwwP29dgmZcQq9CriPJmkAUN0D+xu6kM6dUqvk3jST9E2M69CAFa
         GVciCK26Ie2TiC3bdRJY59jCgSOjs17C7VuFT4LVSjNqXvfcD+/ZmEuNC1Vc82rkK+lM
         NwlUOQ9JIcONLlbJj+TnMkWBu93CQxxwF7UZ7AVl47Olw0EnD3TGBeZ5sCUunxsIbSuY
         AePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592668; x=1770197468;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zKtT6XQ/JEquVZGbic/ESwJDGPsZ48peRTM8lwccGeU=;
        b=BJ2XO4a5cPNQHm4D2mkVSDx5FzJNUTE5SLWLBozZNAqUQslGtRq+oWXyDPU7KCLBzX
         CNDCt8qiZjbFmoEM5TPVZ/3O8W8SppzLQdSeUNvrKB/FmOBcSh265kYwkQ0YcQf4c+Un
         jdCL/gqlXJA6WLBdbvGQbvWAJLk9AstaOyQNXIr09xRZhsLKREhJXpA8hNmxFv+98e7g
         OUXzBC9r6uQUMRjng9CVXwX+ryDuoYIKHmrq7aQm8wDGv55nN6BRRzLWncotTkAbmtwk
         WbDqukrFjrKIvmWbZd3d7lLoYQz52YM77XuqTfiFs85N1KIAwLsSyRgxYxNP2tO3GKyM
         d8tQ==
X-Gm-Message-State: AOJu0YypNqh/6LcSYN3v74kPLy2kHl02PN5t7Eo71l/NRFBpKlPklTzV
	g6TaEeGwOXlmJslaE51KIV5ld9AUBBQZUuybN3bP7B1AHfqSuemaYJL8
X-Gm-Gg: AZuq6aIYfikScbnpKYfNbYO4ZECQ0BnVqQd3GUfjAHqmUpxnWPHQgndgZEOiWMAzd6r
	ixZmBhuduLVqOuHOwAnHIQzm36nRl8TRU26HhpqtLuVNAv8gxFAI/NYQW73rnz3eixdXd8QKjfe
	FeEonEH8VRdyUJoDlyLsNLzXqD/gVkXtakBooURgFiHwGNg7Oe9hQIb2ierYMrt9faEuNJ8D6lW
	yd2drL3wfh5TqlnXSpTFlyigOO5KXOfknSqWQeh+fnjkBLFN7zgB7kBMg1NhwjIL6GTRKgO3djM
	0Le3Ox7O2wH9M7f5Qv5VhzdncsuKIMIb6gfeaBfr9QscbehS3MPD+sFSrAX2klPu0e8CLsMKh3E
	g2g+RRHZjosnOaCna2Pgaos6CLB6B8jtrLsZso+/Vu3t6LL/xd3Zs609DcOgq4ZlpBExrlweDKR
	DEG51StANssCywmZixXBpzL+Ajd7UvhogdaM+HM0q8U/ZIzDMO/VUa4QvmiC6f6eJe9uUT
X-Received: by 2002:a17:90a:d603:b0:34a:b4a2:f0c8 with SMTP id 98e67ed59e1d1-353feda7c73mr3956579a91.30.1769592668439;
        Wed, 28 Jan 2026 01:31:08 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:31:07 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:34 +0800
Subject: [PATCH v2 10/12] mm, swap: no need to truncate the scan border
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-10-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=1640;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ck39h4o+3Bnrl/Eu9W8vHqj0uF3mkWDHUJNaikw0DaQ=;
 b=kJCS5ZA08P6/rGRGb+xeKM/R1VDwIlZaFTsuoDqsV+6Ui4ub/Gh80jMko5GwkW+9xBorUMw8i
 WZE9V+lM9lBAP4xPOGnTEu94K9jhWqa2iuEXNM76wmVfxgMpiP65aqW
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: znas5hgahngpcqhopm493ash9c44cws6
X-Rspamd-Queue-Id: 82AA0C0012
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769592669-794240
X-HE-Meta: U2FsdGVkX19Ol1afxZzI2NYbmgupPmeJqw/j1Y24UKYAN2KiKEIgWUwfEVA8sGFXe5DPf2zhbFG0HVmPro+XP+r5F0NbrbDBVQIXEGawvl/uNw/Vt5JbPYZO+eJVA3mEyNCbOEhUvPBOgMzTBRYZhN88oyuunuG1zeWS3MGbYzCia/zgDCt1nCZAQyRqYyieo9i2iWUtP06cXT/QRV/uPpImEn5uxVGLsS5/GZlzq747OdshvIrLbOHScuxlKhFzG7A9hVwqLFKolVF+F881lc/MqoQAafqL4vNRh7lcQ0W3agx7xeMjR75jQKqDbO7pBYfH61hfVks01tFxHrc+nkgiTHuuarnr9HMrk4Tu+qquvlWos8aGLyjurLE6kDz2mTs7umUzVItuRRD6y2i/txB5JMwfwQAJTr+f7k8vUhGRnUqjXoHmAr3ngd28Yp5D2FBH7fD8Wc93JAhX+VuTe4+HB7k59r+s0xYqECxibb6lEQlgRloTBfpZUL0NQiffBjoNAaIe2Ugs0pbYXlCfh0Mjdtv/3JPo1mVe0dT3I2bdW+RFaWvqajuhbD26kjAJz3Ff+emOVN65YzNNJ2yasSvrOgbXpR+0xpiPVL60fMJt3jDrDVdzR5A0u623J8vwS/6oqYW4zwByUKCywwqcKLX+0+VbrhveMGHzTNgUCPIdFvLsfyIo+oN4PlFYdOLvTv+jwwgVGR5rGaC4gfFzn1oGAJzs+AZBHUlejF7iVj22Xodr8BH/E0+ZSLCXY1b4Dw6AOmdFNReftJEu43sf2YvS+R+D7bfznQUkVrudRdlSY5j5uZ9kk4S8YxsWT2bSygiDCO+QaiQrQdgfnHjOTtUcTk7jR64mS5pFaJVFiQMjQArot48Jkz5+8fA8GHE6jaTEZZg72eK7Jg6f6UnM9IWzQQ51WwxEO6TPgcs6l3ABhZjyCEP9ttso52w9Ao9qvzPwfghO5lvar7zjiQ0
 kI/WbZks
 RgTmR/GRR6Q4DC3y9UaKbMIfIGFc1plzJdnqw5pgyyJEk2p5Y4amR8b8bMTr48mwW+2i93vsBTEjT4sQjy5SSDZ+0WtSKbHYSNLTd1Q4NirZJPGKa6MU4LmKUplwZb98xALv/gvYfNvAX2VuPHx9HITUcLqi7YaEivxPiN53CIhmzMZdipY8mX4n4fsAwiaCQDkhWA+SPUrnO6DSy2U8DuKwEBHRtaOGRYbpfFD/6UJuMgGGG8Fv5iXUrROZAVrE3NSUp6eUJdx2eYk8LhVAErABx/5mr9qioiX0TPujGutFXbWCZ3Q3z0RUPuxmwon++YkmaX/30jUh3MWjS7wWmd5QpUFV3UIRrUUxFETlD/fUell6Bb+PudZ42QQv6BfM8htQ611cCt9ZFwbf8QUQgu82eHoi5z0OofKVoR2uKMqsiVqvdnP2tVTRUZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

swap_map had a static flexible size, so the last cluster won't be fully
covered, hence the allocator needs to check the scan border to avoid
OOB. But the swap table has a fixed-sized swap table for each cluster,
and the slots beyond the device size are marked as bad slots. The
allocator can simply scan all slots as usual, and any bad slots will be
skipped.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h     | 2 +-
 mm/swapfile.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 751430e2d2a5..9fc5fecdcfdf 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -85,7 +85,7 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
 		struct swap_info_struct *si, pgoff_t offset)
 {
 	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	VM_WARN_ON_ONCE(offset >= si->max);
+	VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
 	return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 45579ace27ba..a7fc8837eb74 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -945,8 +945,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
-	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int order = likely(folio) ? folio_order(folio) : 0;
+	unsigned long end = start + SWAPFILE_CLUSTER;
 	unsigned int nr_pages = 1 << order;
 	bool need_reclaim, ret, usable;
 

-- 
2.52.0


