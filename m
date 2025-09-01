Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 195CCCA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC92E8E000B; Mon,  1 Sep 2025 02:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2BE28E0006; Mon,  1 Sep 2025 02:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A658E000B; Mon,  1 Sep 2025 02:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 90D0E8E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 610F4119FC1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:44 +0000 (UTC)
X-FDA: 83839662648.18.E20257F
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80573120006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ccWWEK7w;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707162; a=rsa-sha256;
	cv=none;
	b=zClei0+kh8e3u2AtVV4uzV9IVrUT+niZ7Xd2cUENvKj7gShfM/thKtNBgBXK2kpCaBtykR
	akGrUrQAcRNCbpwwmAcg/4pctQYdLJRvv3G1ktcb/5Uc5z+TFQ/j7i1GRff1MBgcNTVxRL
	coDN6t8FZtizvtg8g3dE33Wzurg/OI0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ccWWEK7w;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbQrHBJ8z81uwew1vi+7yRgIBMEBSVZY4WcnSS+Eg3g=;
	b=vU71RB3YVLv6hBhuvyVeBf5DEiH5aJX6xeMwLRb3vAJKUhXeMteOAbCf4fkoiKNW9lIcSw
	iJ00nGAtS3QVjpjaDcSQs8Xxh2j91QroXImFIa8of4m7S4U2kwIPFn4LEMvUb3B57Dhf69
	Niekm78nJydlU9M9VmWBOCGBuAoyskM=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61cb4374d2fso5598700a12.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707161; x=1757311961; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EbQrHBJ8z81uwew1vi+7yRgIBMEBSVZY4WcnSS+Eg3g=;
        b=ccWWEK7w4QmHa84iKw4JkSP3px2OUO+e5f+PCStaKYaSY1+4o7ABGJeihadVRPIZFz
         mLhWMzIUwzyg5DsSMc3GzkqjFJmIq/8xDmMogzqTrHLjSeE9SLEMvACCZPWuRZEAcDjq
         gd6rLXiKUlaTznMGhHZJNq/OnW4XvYBmvi/cZZCQ+uHqUggzmTkr488zGyxMP9X3TkPE
         k+xPmkiNaOi2h1I4xtFLjz6HxJWR+djnFRUepzus2KpygDtEkzX3qETu3XUgC+9/4o6h
         7wF3rLTbz/Pkw7gb9JZhJK3SqRGZU3MOdX0TfP/dnXyeQfakMgL6lPiWdbV8RrQvlr42
         zokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707161; x=1757311961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EbQrHBJ8z81uwew1vi+7yRgIBMEBSVZY4WcnSS+Eg3g=;
        b=Z8WV0zB8FRGkt27E23sg2sZCjtpXXKnDU38/lApeTSIG8Kwz1TS+DX3w8atQsQMX2v
         N2GZ0ZW3a+HOXazgZeDIbis41ZikH1eRt5Fz1dc3ntVDtDTleXKO/sVyBO6wX7SHSZ8f
         4VyndC7QDkQNZRyoTxcZyk6Scb61J21R2dyH+48Idi2oiG4VUjLVQ4G+ljCtvyv7/WHY
         4wztOJa5wZpclLxblRMF6KVHqJ1cTEs5q+mtk61sHs5OPFqhCgmGKb+ECsX0LeYHWccR
         5QGqXMXLiR1ckGl8+btNWIuNO4v9O8P1wpcgOo+wEiI0eBUxo5bB4oCvXgbthb6TtQQV
         s1sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVogq1nQlB7ALI63qJ7RXutm+uTZoIK/4g7TKt/hO2s43VSn5R9HoS9bphhOWJOKoTAz2vP0O7/Hg==@kvack.org
X-Gm-Message-State: AOJu0YxqfkO/l/IUPtQKi8L7Eya8N5aBCmHpFK1cpw/sngEESLalH8Bp
	VX//XtDJBkVJU34OxEc/K/lHGDArIf+hUfh2VrpEgz/qOUyw9YPiNVDhuDPg1J+JBLY=
X-Gm-Gg: ASbGncuffqkp04EbXTGpaj9D+ZovQ4VSbs32enJVSeqfWigUXu0qZuf0RpdCn6HBCqS
	UctCn9lSNV+zfR1gjuTTuP4wPqdXP+/ABqOc1vZ0p0U9bWz4YeJ5NrEMmgh0/9+LYp9z5b1Ka4o
	4V3VRlaoFy8R/S40lS9ObA4qtmNXb3oQvXZ0YUEWW585PPkMH4BjEf3rvF4BaIyAFAOt4bUoz7Y
	41RU0lm9j0fZfhXKUt7/t4cPCyAraKvNiLePoN0CfOITjsdTXzYQU2IKkn9WQOqH+TcMjwSmhUA
	nwKtiSfGKoF4aOYoUoCFnXUY10wPeBR68z2OnO1cwJjDvKrkZRdZsPJu8MoAabZ09mqJH9ZBemx
	bdzBdSkTZ3KB1+QHISgPN2Oqd0TFzJRXq39zXktY/jgP56hSJFUHFRHAyvB4c8s8zNx+a6oTQUe
	b7qrNALR/w9TkCdPz2hZbPoJuZkUljcw4R
X-Google-Smtp-Source: AGHT+IGevVVFDwpib3Ih00RORrmBg3Bj8mRdXcMsGafDrizuqnKGumProyccpoS5DO5Ejs/3iaBZ7A==
X-Received: by 2002:a05:6402:3594:b0:61e:49dc:171f with SMTP id 4fb4d7f45d1cf-61e49dc176fmr2613262a12.1.1756707161042;
        Sun, 31 Aug 2025 23:12:41 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:40 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 09/12] mm/mm_types: add `const` to several pointer parameters
Date: Mon,  1 Sep 2025 08:12:20 +0200
Message-ID: <20250901061223.2939097-10-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 80573120006
X-Stat-Signature: hrmkr5xowq4ik6ffi7niz5t7bjb851r1
X-Rspam-User: 
X-HE-Tag: 1756707162-665478
X-HE-Meta: U2FsdGVkX18Bmr179u11UNFwvDPWOI3Y3vibkabJW9H7T7ZDZb4GGr+94N90F4+EdCz1JvQRLWE0ngyDufKLybMwF5VmJwDtrQuuxI0cpJlfjYgRCQA8bFGdY8Y++03M7m6hD8tIGTabcwxz8nbIgzgO3/H5QHq5gvw143R1xSsYstx2YdNVpRAbjgW8ZLwH9iyFNWwiJH22IFOViIwTzKlLfOFNdNknzAoD+nvIpCs/YUfyVhnri24S6wI+rkrU+0bRh3a93dP8a+h4Tr/BTZjMkdwF0Un1RGBGHl3RmPYI17z6mYjJ0fjZezYFv1Dm4tSApV2uVHp6IIYnWaNgJiow/swd5pkMH9kyR4UPH5kDMNg0HNzmnaJlChq3kuGwbj9nEdGTAIXKDWu8oW5wk0t85kQ6CvfPm6azCqrIBJ2JR33I2Dv9kOMiZLhzo8MbRXUoL/n0RTl+0FztdMHbdAhLBAwq0dDlaHjHgVCyUZ5sS8vqE/TZgEnnZZRq8tfxrZ0M4JfvWmhn1vZIOPTXVU5JI0hp3qxq4Cw37rc5PAdTPlnjuyJcH2LvlzrOp/RPU/xDoRW0oUfRUGUypDAovR8rZH7CqJGDlCCJ/x7CxZK0H+E8Tj/Lx2eiVMijshu+O92Q2FqLkBtTrSmhiL1lMnFg2tyHNC0ZH9Rg4883oj0u9zZ1a1gq4Q/12te5Jqg6jbpc5dBXXJD8q33MbbT7cW3wlDCdTNfFyi+cEKJiZC+H6izoWni96zhBOEQ1O26tb8qyCFlB77LC55PiZktz1md/eOfOt97UohxsvoM+Y+ttmItNnDCJc4IIF0Jw7EennrM/IohMYErZjU+bDldUdLh6+YpSU1/iFKXYuprohXw4ioxqP4EGZmY/DfdgN9EW4gDFKvAQqqtygNqWYES8xecx+67FJtsn7BoaZpPDMfL50IY3AAtQ3b3Ki0Gz0CpoURtS+ORFVMds1wrAW7y
 Kj8kRu6z
 vRfQFqyRZ/Q+WB9FwSbx5VRXupKYDxho3aaxE6VLobTSd5+5nQWW2OSyAqQGadQkoGbAiXPU7y+w0QhbKkFMcl6v86HMxX0VH+yBC1AAIskxX4TMKDSHM7gXFZ+w2bJSJGiIyLuz9n/+0c3yf0ltNQ5SgcMXgGraI/cd/6XVIX/ay29io8rwll3ZD6xZKVq78duhbfFZU+JV7zxKBFZ+cWTH3TgHQRpwrRxdTvzMv1cXaXqiouQiWUnwI3nyL+pS0TaDBNYjSz9rZvfW0rTYXOZmAbKiwVah9YjmRVQiVXJfmzRe+CLXNSYhsLARsg67aHlL8vS5h/og5l0Z7rkPhwAF7aSoN5RylAaX12clS6HnYmu8drchbRteoLgLirvUR9dN5UeeSruHqwWHRkJB+XqApHdsVIrQfc8kvRYeDBsAfvZzed6GDeoXS+7+W2n4xfTAB4VS/M9NHRVvj8X8CgdUy04AA9OYfXw2Y916TrgBilJqXbCEkBzeah6p39D3s/0H9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d934a3a5b443..46e27ee14bcf 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -632,7 +632,7 @@ static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
 	atomic_dec(&ptdesc->pt_share_count);
 }
 
-static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
+static inline int ptdesc_pmd_pts_count(const struct ptdesc *const ptdesc)
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
@@ -660,7 +660,7 @@ static inline void set_page_private(struct page *page, unsigned long private)
 	page->private = private;
 }
 
-static inline void *folio_get_private(struct folio *folio)
+static inline void *folio_get_private(const struct folio *const folio)
 {
 	return folio->private;
 }
-- 
2.47.2


