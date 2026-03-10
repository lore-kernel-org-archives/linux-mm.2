Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE30FCC9AD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EE36B0089; Mon,  9 Mar 2026 23:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E646B008A; Mon,  9 Mar 2026 23:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADE76B008C; Mon,  9 Mar 2026 23:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0A16B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:12:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5AF71B7FA6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:39 +0000 (UTC)
X-FDA: 84528680838.03.E474CB5
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 06D7240005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=My0EFc+f;
	spf=pass (imf12.hostedemail.com: domain of r@hev.cc designates 209.85.210.172 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Gnfc04EYdLBOgTA22D3ZA5OANJFWm2SEibGG/QoA0M=;
	b=pjsP+5w8Q6K5c27dY5wf6q0Vx107q2min5q+Noy7yafG8GaxNZ2Ztboteb24iCKzgR4VPM
	JHM3MT7gcQoGg8jaC5JDVXY9cwDkNHG1pjtTLwed+T7OGH8xjddriaSZyhZw4+1KdnVA3E
	UJwQm6Pr2RKC8Khwz05rJBgv5+SBZoQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=My0EFc+f;
	spf=pass (imf12.hostedemail.com: domain of r@hev.cc designates 209.85.210.172 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112358; a=rsa-sha256;
	cv=none;
	b=DBk95GC99TKQoKYyCrh/ThXhkfDHSMUGGseBaq181jPRYaBYU4gnuE0mMsUadQKqNHqIby
	VHcKiMtXqj09D8/1YLpkTZuoKgWrvKS77O58I6oWXHSPOZBwinmwrcN3tHKDLrtZDA0Nld
	DNYSvo8w/TD3gBQSjD2W+nUpbs6AazA=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82989744ee0so4037492b3a.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773112357; x=1773717157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Gnfc04EYdLBOgTA22D3ZA5OANJFWm2SEibGG/QoA0M=;
        b=My0EFc+f4trSmJrGDJqv5OLX0ckOo0CtoYNi5v4trt5nkaMxrb8EmccImYRPUAmKXK
         HhNLsta/BKOOqSIYP/Izw7cpyToen44hBm10I4gAzmcNLo3HaPKAvWLeFFEDhuiJUSTb
         gttLXCC13mvbtJoZL+PUhW4yg20ANd61UNkqOZucFZXpmJNdHcVgvBbt7H+MJ81iD+2k
         lEi/l9y3h5OHa6xNgX2EW95K54BxbBn8qvBTWnUWosA+V7n21OwugVgA4q8nHQRoienU
         WnMYniPq2AYepK4qF6VxenTs0GBct8QdAceLSU26WRMTgUmDOIkwtx36KxhAg2Ds0M8x
         7d0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112357; x=1773717157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Gnfc04EYdLBOgTA22D3ZA5OANJFWm2SEibGG/QoA0M=;
        b=jF5YODAA8YBAnllmuyGkKvcirptDFAstqjyFzpQDeWJYUIZqg1CpEygy9GR3q3lerP
         yjq8/YZoNHldSKN/RXwLFqNvrqcSkHIuvekPu9N5pMvnpz7sXDm4y/ri+bY6iFwh9n4H
         xv4FoudrSfs8XK0jDVQ9/UGLgQZEmJ/NXE07Vs0E/5ky1qCRS9ogikmn/i6KzNsSqKef
         Y63i08GYz9f3z3DQW9WS/BnIggRsc8inmZi7bR8kuAzny2IkrNRZ6E1d6YDyFASKljSd
         sELDu1RTmIrshsH75RPGPij70hdvL1ooEwPCA+LFwsqTGpnniTpp6BHsokiHLFr+tvP0
         LZ3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMj+Lc0280zk/ZKHKDhYLiZm8t3GhRYvCpWws79AnCpqH9gmiMvy4qDfBHWMMksr02IjZ8zHO8xg==@kvack.org
X-Gm-Message-State: AOJu0Yywc8SGaz9cxPK6EidlNVTYZoC9mDMQlzsfBWXuaYSHiZHzhcpB
	Qx1fwoovLV35i3ah1hLf/htp9SnZdutTeEjhMPrwYRoFe+dPqQ0VXcxE1zwETWtqmSM=
X-Gm-Gg: ATEYQzxVge7uXhgH0bii5kmR+Mba7/yc00FDx0TilBq+vHINaKCoysxUvcAqZOLOZgQ
	2xHn0F6NbIRbQHoisYjNn26cXDiBPxysCRqQOl/cdG3ewnXnhz0Nhv9D29PiGbiIGuvBYEIZYck
	6k7BsA468htI3r5s59dPSffyqu/8hAIPXS+Y4ys1ziBxat4JT5f8jrGJsNmJ6eNaUkZYf2x5sNE
	7svSc5MBgTBB5/Mjm6FQq09RuUuvaKNlbu1TfLljM18CJ+1R0G/sXgd3oUMJ2pXO4PfJAuF/eeq
	AIwlL7F3zj5sMcLgXypCMrIV5fyYIkibbDY/k1n0ej22CgLXbE1llOtoV260S1/IOVQpxnhKLRp
	JVqpbuRncNuYxXxeAjyYMHa0vCa98gvvS3DLh+YnPQP3Tgi8zFj+YVcpDy+6MsN7JumEWo4SVbq
	2ZcEJjfQSr
X-Received: by 2002:a05:6a00:1a8c:b0:829:810e:8af8 with SMTP id d2e1a72fcca58-829a2dc4f99mr12713671b3a.22.1773112356834;
        Mon, 09 Mar 2026 20:12:36 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a465c872sm14213691b3a.19.2026.03.09.20.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:12:36 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v4 1/2] huge_mm: add stubs for THP-disabled configs
Date: Tue, 10 Mar 2026 11:11:37 +0800
Message-ID: <20260310031138.509730-2-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310031138.509730-1-r@hev.cc>
References: <20260310031138.509730-1-r@hev.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 06D7240005
X-Stat-Signature: btx6su98zya4cn1q3rhh476dm51qtkio
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773112357-552657
X-HE-Meta: U2FsdGVkX1/hpQKNhU1lxyoJ5fEebgRCxj9CSOdF2ZlP/FbuULGzlXuNSRfTJQUoP8KcfZNzn2wNF3rn2GMgx+66/MbqKQSr6gK0f52Ssje4sEA+StevAkir8rFj0Hl4i0YFs2JgIRV21qBO/eAyxBV8J0xtNdlew5vQje3AerQPvzXvZPUnKFIYC6s8O18G28PCpVPCieeZqWZzvntDe5qAD+e/6qSlN2sFJJUVOaGv5/QnMAqc7CbRkBoYhBMLymd8l0XwpwF5zPZpMASDx4nl9EnfsRrRPJXWzDKNHLHasmLUrVey3p026VBRHsmNHPL+M59Me12ve29k+3fv4SDYbN7xIKQTQ5p+IyWbN1PxAnUROicOoeKNiAwPuIePY5XyzO29lHNU0+CAYjuXwIyyJFZF47a7elCKLh9+VCArEZzX+rEWJsKAtN9FfScZ+284PgyJMqo+2Ko9jRJ99cWMVpkbpyD7tMXif4eejnftJHCANs7StEF1aGY/BAOp/GoxtT7aIAHJiMJAUfR9uqd2H3dLvVw0Cr3ypEVakIA6aez6OCs31e4vbUwWvNch2VFhwOrzIOUh8FpgNT/7Kl7arLeiYkXVDExhVriwgZ9hy3gpgwIEj/ZzBTmH3MJOduM+qoLA0hMSIkTLycDNtBQbtPBXsbd8/rz/4MUNYUbk/LiVET2f0Mjj1ZlbB7b0TM0PjMA9Y6iIUbekry9v+cXthCUWsWjDZF8AJY3mVahIVxv72jpREj99FDuidp2mfwPFKDV3BaiokQTaJ0uWG6zoHnO9OJTAQmObYSUVpLMGH6TI61nk8rTiQKJd9GaJqPGUw4IfjA8pK0914Zsij9C7UJgnXLB/ODXx6Te6xwd02bwBXzwPcXujByiE610/lC/N58b29MpM8jNNtH9fHIQqIMhoBd+fsbNIsmj2gZZjp79G++++qXQj/2qzXTTTDznzLIlQaXyYGHjHjPc
 vfeAr2KD
 SERVgl3i6adNTMb3Dj9pX+uH/oWTQPkx/1l9AdUGsFyZUFOTG/a4MvqZGVIGb59brp2GU/we+x+InH9IdV0+IuxngvXi6sHcrt8RRGyrjPtl1quB1qujDHZs/zRaGn5qb+t23u3E966k2J6cZHJoboN0s5QVT20VsI3hJttTl1UUdOVdRp1siXx3ZnnLs4PW03Dsr/588Kb4UgXH08GplRWv+tPrylWh17ttPB/xjTMjAe9dffE9wWmG5IWCT8Qr+fYJcjOjiDQJ2CNQSbwDwb2o/utLbPqlNeplpgFYuPiRKwBQtf0L8oke0JyVYLr9Hiu/sB4T/dEgzKpwQhMqQcFy5RR4c3An4PaRsS22aWcUup/1/57E3QZnXCfSP0v6FcDDj4gGSjlgymA5WTKfBrXx6JPNw20/LNPNGFziFw8Qt15k3UNUr5alkO69+56w4yOKqW/zYvti304LvIUZNbFuEz21ERH/5dG1+XrznAV2okDvjYfDO/qjkKq56M/5IoekNTPmzDa9mq1ZxVpXioq7Go2aUlXO18xF1mEz8UvT+en9kLSz4cVioqqTfQusKBJe7nUXOoPOpOZ1qEpStn820Xauc8X8XZtp3MwRz2cRsUtMgYEiWoiSaiAHPShiMjeNuig/UscTqSvNY4Fdw81KvLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugepage_global_enabled() and hugepage_global_always() only exist
when CONFIG_TRANSPARENT_HUGEPAGE is set.  Add inline stubs that
return false to let code compile when THP is disabled.

Signed-off-by: WANG Rui <r@hev.cc>
---
 include/linux/huge_mm.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..badeebd4ea98 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -570,6 +570,16 @@ void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static inline bool hugepage_global_enabled(void)
+{
+	return false;
+}
+
+static inline bool hugepage_global_always(void)
+{
+	return false;
+}
+
 static inline bool folio_test_pmd_mappable(struct folio *folio)
 {
 	return false;
-- 
2.53.0


