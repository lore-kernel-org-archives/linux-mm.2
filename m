Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D657DF433D8
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 02:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AAE6B0005; Wed, 15 Apr 2026 22:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C766B0088; Wed, 15 Apr 2026 22:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22696B008A; Wed, 15 Apr 2026 22:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C32ED6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:19:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E61BE3CD7
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:19:54 +0000 (UTC)
X-FDA: 84662813508.04.C64F495
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3D1F1C0010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:19:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ga6BMNAv;
	spf=pass (imf21.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776305992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r/b6LeONGsmHeQryJPpKqE/rRI/nwz9UqzvnQv7bsao=;
	b=7nlbDnUZyoD8MwptSOr6p5npFEKeEcswVa3igWnBi3ZikSaSVU/4kjIs91w9A8oljtS0No
	CPCr91yA8UVNWanAvhSHrVGqXDSxYvIu7+BgRZpY1WgugPjzR9X7KJlghiw4xPh03v2zsf
	OqUoxE5Hr7rw/lSeUUKLh5qS0GSIoBQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ga6BMNAv;
	spf=pass (imf21.hostedemail.com: domain of gxxa03070307@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=gxxa03070307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776305992; a=rsa-sha256;
	cv=none;
	b=e4Hr5aqDP4cXA0DscmUGziXFRrVOURK++UIJV46a773v38pJ5uz1sroDVPfRNL5YEr/I+m
	6tFKoZdcR+nlGCwDHZRnrjYOP0LinIMKa8XVDEVBzlPDs8phK5zkzRKEQHcyIQR2V/Htt6
	GXLQeCYq1gpZG+0KKrSjC1HSedYIb8k=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ad21f437eeso1057405ad.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776305991; x=1776910791; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r/b6LeONGsmHeQryJPpKqE/rRI/nwz9UqzvnQv7bsao=;
        b=ga6BMNAv1rlEELx+i7UR5p0W91GNqKEyJGXwWAWFUUU3fOuuSg87GNo3elsjmDS8md
         FPeUhvurGMBvBZGxws+3aOogXGU7eYCOFUT6PN+428Egksib8smHlPF+1fKtdrOMzuUv
         0kKRS27E/Gynm1t9Y9kVYYsrXL1MQLtUgYyQ/hpl5PWHWaXOuJxZ5BJ6pnha+VXTCFox
         wh5/ADUK8UIDwB1OqZoVWYnlPFYY7KbvNukshGmVU6FZMwUjL4th8MrSyDlq/RrVnp3K
         S2HE2hIxCg7IPqDHd0IcL4dr/G/WJ5XqmODX7oNVzeAS6XEWIpVxhjN+7rqmuqmYqgfX
         LxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776305991; x=1776910791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/b6LeONGsmHeQryJPpKqE/rRI/nwz9UqzvnQv7bsao=;
        b=O43xoULNu7qhEWK/ihAeX39JNbgNyQBrS5a8jINF50Pupx8QNx9Q7y88ZXVcGwt70e
         Y0TVcCW0U5CEeSbpu8bJ8W1zm+5iWxXVk8RkESwKswlxj224ru6vqfiOIonEy5O8pijf
         iw7c1fHuCWu7kxJ6Lg6zoczr4+8mMCX0nIVC9WTh2uRQX34N7FzSDhiv5g6tC4gXDZAW
         uwJdOWLTg/na+PO9RqnffZrLUrql8MxxuEtHul2Alpwv1T/BPYBjC4kGoVDxTQFCZP/e
         OdSYcuNbAyCSRIatBqRdaTV9dHSev/JoR4THQwq4/XGBOtDs+bXeXw/PFEwJXZTHEx2b
         kgSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/wS6h4JVqZNocIKMCOjlBJrERICaVu/z86elMUqL5QLmjV3V0xVLBSWxm2IvyuS3otrVRi/I0NFQ==@kvack.org
X-Gm-Message-State: AOJu0YzR2s8//T1hBoPbbG86ZXwANbb6nOq+/N5WFx5kYy8I8myLwFmw
	rrXE55JwG10N0MpWQ0Jn9QPina3p37oLJkWJxmb+VcETL+qCgx/Ul43Q
X-Gm-Gg: AeBDievqAXU+DASjYG78gOKdUGk2+fkNkfqwnu6vbnfdcx8xKX2FfP3J7sECvXvUJcQ
	i8Qqm3wU8XCm+bkiPAClVYFXeR5+uPCF4Fc/xeCArAQh6/TfIB833P09wbJE1P+aFuAkzA+bhY+
	lbPGPm2lOrJFRSKsnjn2pPpqd9fpCmLTxOlHiL8t703O+9f3IJnDE0nzF4c/vvrz6k3NvW0ZUHt
	lal7l/HgBtYEAWCCz+3r14tj7l+4hqBvOH9Hn5Pzqr9bjur6OtY4O9N0B3NpjyzWa2Sh4G8in+0
	ksJMp+pbu5Mg/qZZgForH7Isax/I8Jh9HVdu9PTEnNNAqy2Na5co/lN2OZ4ZKjNhyE9vSn1WZoZ
	wnwlP3J7fFm4KYMwpN4KnJ0z/w6ZsWnFnOikkQt8JaVa+/NkyiTKmScW6niS50WcL/8kNjeTKPp
	gAQv8q/N7W1UlvQSgiU3NqG43KkM3KYyVr
X-Received: by 2002:a17:903:3910:b0:2b4:6447:f8a2 with SMTP id d9443c01a7336-2b5eaabce4cmr14916825ad.21.1776305991282;
        Wed, 15 Apr 2026 19:19:51 -0700 (PDT)
Received: from xiao.mioffice.cn ([43.224.245.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b47826e917sm47129935ad.54.2026.04.15.19.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 19:19:50 -0700 (PDT)
From: Xiang Gao <gxxa03070307@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: [PATCH] mm/page_alloc: fix spaces used for indentation instead of tabs
Date: Thu, 16 Apr 2026 10:19:45 +0800
Message-Id: <20260416021945.682234-1-gxxa03070307@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jbd5qa7wqzak8mk8hf1ope74wkde3d41
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3D1F1C0010
X-HE-Tag: 1776305992-755128
X-HE-Meta: U2FsdGVkX196rXy9/opu0+hmqonhEDUA/FWheBlH5P6nidofm3EpOjYsVc1AhhG3/qzeF46p7mNP3AjvOO4dtKE4moKP1t7jwKHWsNx6dEQoqAvi4LddP+oQKn7n7tljVbFzD0K3dt8vu4YWZGDm2bj77+ZYgOZloHpcBmxA/HEfPLdiQUzgSNAoKevxhWmSIxQ58WPhnHvc58GXMKC2cWMOF9Bwv1jb41OXCPXAnO9BxHDEqTEPUvQyY/tVUzDb0nVvKs51LYiKgI1Xy+L4/D7FNewE5H0ZskzZz5+UUO3edgSdyahpfloHcYyCsXllUJFV8Nyt0pKM7XukgihzXUW8y5kmsgId4QR7yib7bbYeFWSRoDlPIzpdpgza+XFLrzR/ebr/I/hcq84up+H9GSbNsuP8DYaW80iBEMMtOvEzU4uE1aCMfHoZYHhp4RLgfvb2WJokKBNfVgA/zBjMShTXjSpULZy7959grP2NtJwIJvSvW07IRcg6Wire04yUUKSPyGKdE4Ob4HcHTSRu1XK0kZzJ2XYvKWlbI7DfzgUPFTaZNmebybwyRiJwA6igI1W59O2dBR2mSajLGcpDvG++M3G8rjRK90DqI9OCcghU5zZvsd+K6wzKcdRq+PzIFx9GriMXvZfjcgiyxENVUaUR7MEog7qNOhUV8BS9Pu6m6XFCmuTuaNJd/oGpvJhieu8W69V3OzTR/rrUbnV8yA5Bp9myaKUAWl3Rkau3Jlg/e1ji+/4lvxAQJTV0fxo09ELjNg4B8BjSizGv/pmVyuIWS9DP3P2reSnJwXSQdMX99U271et/fnY6JWieZ966bKx46Bco8e+YYccTwZOHUVmFmQCrUlV+KPV1MQKyLxplsxayqxRg7eMWst0+3H6ydan5D83FwB1WXnUm0R4FxTaFum4cSDDBkLXo+QawtYTzTQPZR2TXiiFZm3j8bFtXSYWcj1PPUh4RJfTKA4M
 1jGqDcEX
 WryoTnrN3rU48Intlfa3JYnKVqh0Ajty3oQqz8WQFsheGohRqkTyJnjlOhPWAm7BFJz6UjpMpavNzlO//yBwQYRaZtjGr44/fhn6fcXJXjqhnHUyIfkzgRoKBrnvfH4ZFCy8QnOuBLFvL0o46eSSlDiWEysdUX2zAXuh9qkNJpt+P/d9kbooHEcHSce5j4G28pcPSaz4szPtpUnYhwf955O042VwXYPEMVZwvzGbm28VFq27996wpX3KHietPQEdsp1UT8WUtwj9zjGoNOcAcguWDJJ9Hg8gJLhXyFazGMIzV3XCBTEqyZrBSenAVuggn5r+6nuOCKDT+zwfgqtcL6livxA4qfF5YddmSR/IaQgkL9r6up/m8eZMbU/BKFEMc3LUXmKgFMNz3+3XyQ2prT5Y973tHLNjk4oViaEK6BKswKa8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xiang Gao <gaoxiang17@xiaomi.com>

checkpatch.pl reports two indentation errors in page_alloc.c where
spaces are used instead of tabs:

  ERROR: code indent should use tabs where possible
  #887: FILE: mm/page_alloc.c:887:
  +        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,$

  ERROR: code indent should use tabs where possible
  #6626: FILE: mm/page_alloc.c:6626:
  +						         sysctl_min_unmapped_ratio) / 100;$

In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
spaces for indentation instead of a tab. The identical VM_WARN_ONCE
calls in __add_to_free_list() and move_to_free_list() both correctly
use a tab.

In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
tabs + 9 spaces for alignment. Replace the excess spaces with 6 tabs
+ 1 space to correctly align with the opening parenthesis on the
previous line.

Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
---
 mm/page_alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..752673a9b43c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -884,7 +884,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 {
 	int nr_pages = 1 << order;
 
-        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
+	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
 		     "page type is %d, passed migratetype is %d (nr=%d)\n",
 		     get_pageblock_migratetype(page), migratetype, nr_pages);
 
@@ -6623,7 +6623,7 @@ static void setup_min_unmapped_ratio(void)
 
 	for_each_zone(zone)
 		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
-						         sysctl_min_unmapped_ratio) / 100;
+						 sysctl_min_unmapped_ratio) / 100;
 }
 
 
-- 
2.34.1


