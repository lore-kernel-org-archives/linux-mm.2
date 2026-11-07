Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41659606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=db+Tx6ph
Received: by kanga.kvack.org (Postfix)
	id 50E676B05BB; Fri,  6 Nov 2026 21:29:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BED76B05BC; Fri,  6 Nov 2026 21:29:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADD66B05BD; Fri,  6 Nov 2026 21:29:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1496B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AB6E120290
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:54 +0000 (UTC)
X-FDA: 85406742708.26.D9E5C67
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD7D1140003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=db+Tx6ph;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRsIPTMr9DAEDvgH3CXndlUsRH7W6W5mSGx/DJlSS8k=;
	b=FZzz6ZBPjfVk8MBoFicQYOZycZIyTVMijQ3sfjWU5sCvMnyleZuTJqQCuhcpC+zBu8CHOw
	pNgfjsrMUj+iiMCB+xOAa02FIaxwfgJZ5xyyseNCkgkKB+EuZG+lS3EhZa2X2x1c9MQkoa
	5RggLRkd/uD+wRk0vqP0RusosqSy+tM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018592;
	b=hgAzIChYVG7NH7UW0EUgbkAD9Z669Vy8XMjGvDHgPmxwaM499AUYjc/e3q9gwHoLEWSFF6
	Fs46XcI6Ya90u3f06JFOI/SAMz5vHq3aVPLTE11Un+Gv2MATxJ7lwgdaUHhvQcesLSV4uw
	7XmXsZary/ELTKXIiVuZRtjAPLsxLtw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=db+Tx6ph;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-37000e7234bso1627700eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018591; x=1794623391; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uRsIPTMr9DAEDvgH3CXndlUsRH7W6W5mSGx/DJlSS8k=;
        b=db+Tx6phFWq/adwrfQ0/ko9nKLAy93vJi3VzS1OZ1l5gWfP4t+/Rupyh8OMT+u9eAS
         YL5uH2gulW/NGa5dESz+Fr8Fdb44K6htoyS3ceT5DZLRM0GtJIfJ+wv7KiTl7n7wfkaQ
         i3J1H+qbuGOPw3Q9LXU3Bu+520+AkMaOvfZh74YoRFLGEPGJuG2JrMmMJ1CuA9IdsabK
         /9S4tM7htCuhEUS41noWc/4HoSAdJ/Dh8VeLitvupkaxrvKKW+E+DQcUKW+uskLLVgyK
         FHFFn84Z71iKie7qlapPQvx5UJB7xhTebFtcMP8xzVEFm0mPEW5KkERyRGq+2Tdq3MYj
         IdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018591; x=1794623391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uRsIPTMr9DAEDvgH3CXndlUsRH7W6W5mSGx/DJlSS8k=;
        b=syWDEinullVtxYoO1BJqyJd1oFNSWErqJVcEssAMfd9mjeTdJrFelfsSR52A03sQdW
         CtuxXAlHsE0G+MkkXPbvk3HqUjeKxPvWyvBUEdbaJQ/4c+VOIjiDLqc3pvkKeX1/b9hp
         Et8O7lHPB2K9xxvucYsgmNZakJRLDxWRqDlWk88Ebd8FJQoP5sqSLJwlYMSi9k9stiyn
         Q7pnWCD4CDEXhS/vQeT3AuQLH/g3lVplVtczE0P4W3LTuQPQFZk9ZObONBc9jMkgwpyo
         9wJl8oXN774r4K8RfCbXU3iWe26HhQWERblCSsiBhZma0X05r4XGw9MMUJeIMeojeh6Y
         S8uQ==
X-Forwarded-Encrypted: i=1; AL+hErHrz3J+8+R599gJLDxlXfAeCG6/4gILMnX+NabUeivXlCD8pFRP07KG0LoZgWlTMvw/Iz2F1IX5Bw==@kvack.org
X-Gm-Message-State: APuU4Z8Ej5P9lkE0rWgaVh4iq2LaMhBE635ChMmTzwXMEffy9qqzPZdG
	Bd3NrCTC4ei3Om91JTzxsxAqmI9qkLO1Ijhbyal5fYsEdHUsuuSlDPe2KKQKzbPbucc=
X-Gm-Gg: AYBFou3TYhEMyd3J5xu0EksPxtXZfzv0YK1kcvh3oDK+N+GVNBvuCJMhvpXOVHtMWix
	ZE9w6VGy0OV8WJOC8fqWqFpbHJTlRrWseE+EToo/bMEuVAQoFqDFxgA8Ci1URvMUh5zAbpMX4LW
	1GtyvIBMl+Wi7/AsyJQS/kdIImv2zWlLWAFh5fvUBNsSZM8f/jhI2vmexdvVxNe8ssZYjinUITQ
	7GqCnfSTg1rz2+o7Ay9PWW2LUTjWhSe77jqE8309OPQuA3wYvJ47bfOwSZjFmQOapaLXMczOCm0
	jMO0agxQA2b5sQi4lv2wDFjK9Vrcu0FGkrcu0MusVbH0pG8nyTOzYP5fmRLslNOdPyfADwVfAbO
	IdBYvdcGvazt1m1SoudKyBl3PKY2H3xjpsEy+HqGYqD8ke8vJtKY3IqRMnaSrR+JVIoMLcoMYGY
	W/yvZxaSZ6vpAecgGl81+pjk1m64fCOlZilEJO8s4hxARlzlPoVSJUBDCdvOgQDVi3KB4wexm71
	9wv9yr7getKhYmEWQIeZMJCTripi6EHyzbpxUTkraTGcIKXt7OVxx+gRhnkgozCD7C3fgHw0nkr
	tsMl7kQKHlNMWUfeYinrdEbZoRnfZVjNBHQB9QPoh2ZqnZTBTTA8GfwbhJTG
X-Received: by 2002:a05:7300:f818:b0:36d:e547:6db with SMTP id 5a478bee46e88-36f7671ce59mr6171150eec.23.1794018591056;
        Fri, 06 Nov 2026 18:29:51 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:50 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 07/13] mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
Date: Sat,  7 Nov 2026 10:27:50 +0800
Message-ID: <20261107022756.77731-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: doybzp7tcng3hb14hh7fx8yamhg1f43h
X-Rspamd-Queue-Id: AD7D1140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794018592-30355
X-HE-Meta: U2FsdGVkX192HkOoUg+DEnXmA2zk9ftsIz1EPa1AkbBh/+L2+8SOczoMYQ7jUxX1Pv90QoyFviv6q5XnsW0HPBIESEBmqE5MEveBGfEzjXbDLO/ZWgrI5V18CKWuJI7Mfd9RzGMcm7kSKyB0kD9F0kjyqnNLeuKln4oRSusB4zdfuZFjuKiHqBcNf3Z1EGafNxz7Zjku8ipcwUh4Q6uie0Ur8EEFAILdUlEJLDXJLl2vPigfQssuJjGG7VfAGVN2yCyow9ETo9oOLayx6FV0u8hLLHYuQQqxh56ObaqcwbznLy2GZHjnj3mWHvAatksXZAZRCDIG3CfItIREzmriBu6mv9Jc/AjlhH7YyeDZvjYc/SxXSR0UlroI2etac2W1CJ5W+aIxRiAq85AcuZwgSKcA/urj9uq+1gmHFS5S/n812SDcDCFG0BAFbZkZckUToU6WVCCiFDSknD5JwIUqpkV+wJDm0RdLlNDLS0WLCn3Rj5ruQYU7/5xNLS7gqu1D+prpssPnh6QzWMHC6kN4PR4QUsThKTg+GoQ+ZJyLKCrQxikxJRaPDcmNkZ99Qi3Ov2RoU78avSYHb+DHrDq/PWLNIvWKs44QW0IsHGJE33d0VAy+iWRrJAGDLhFozftXCKJDFTmwIcdkZMhsLC3iHoXSyzfORXiIPXa/Yq0Zf8XmIL2YXl1pZhUGq3djV2AxMEpboDaiP2SV+cQbB89vwWwPlYDNW5Pg05W+WfQHE3/b6o62DGwPSd05mmm1Fuui7kwMp6FH/BWVbwU7xe6G4ywMPLRI+l21SNxV8ahmVTJxzjtU7nOEwZ1axcYrOr3j8zjmPsUZ8ZcsAkT9iERJxfbHY2XaanmZLKbW79Yi0coEWuiE0V6VqydF4SlpgCBz5ShORL2EdbmqQr6lKjwRMP8b2nr8FBqcv9/c1GPYYhfssyCjVNI7u0Q5YlXDRcQioH+OpHMiP3WKaSoqufq
 g43P9FkO
 gHh+5jgTCFVT4xCezPa3DiFRH8PXiO9Yye6XxabCYLm4Rep7KbODU8nHDbq8ZsKc6dsckgLPsHvXzX+KvOiKG6Euqti6a9Yqhu0ZiixRC7Yk1VHhPlXZXgrItl0yQA086aN2opIhW/Ml7PqzEx8Um+7nyT3N92OhhNYULjHQwhRIx1ItdUy7R4CNtxReU+uOLggbcVfV3mrIsbN1QTnQLNITEAvyctgfQEkeHnZf1mK/vrRWeZbD99ojQtEb3uG4fD4LQi8cVGsTLu2dLI6sCevmXgFmovvQ2/LCCP392/7qsDr05wEAzosaaT1n1JCbSQVmLC15Hf05wKv65Aqd7LZs6xkS8DCyRSCtyEaJ0O87FZAQwntfgqJm16qYEC9/iujQ1zQHZC7HGhuIGRPF2RQJZOdVyzqXPccVbCLc/yrvB7PZPj5Vh29aSr3amWkzSQdGL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both optimization and restoration update vmemmap PTEs by remapping them,
so "remap" does not identify the callback's role.  Use "optimize" for the
optimization callback to match "restore" and make the two directions
explicit and consistent.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Use two tabs for the renamed helper parameter continuation (suggested by
  Mike Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d58f7a369c9c..7a3af4fd285b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -213,8 +213,8 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
+static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
@@ -302,7 +302,7 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_remap_pte,
+		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
-- 
2.54.0


