Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20581C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2DB6B00A2; Wed, 19 Aug 2026 05:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DCB6B00A3; Wed, 19 Aug 2026 05:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46ABD6B00A4; Wed, 19 Aug 2026 05:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 134746B00A2
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7260CC04F0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:17 +0000 (UTC)
X-FDA: 85117556034.12.097D722
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3C37BA0003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FFRWKfBP;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133195;
	b=XK8qByOAxdKPFqad3JwzvalTqwD4mW2Kuzi58YV9pb5a+Yc60q/OJ6lF4A1g7vDJxfu+lp
	bNr6vOabTto6jKxFipsoc+22iKwW9MXSh3S9URhbzyww9PKFsU+RyFeMoVTkAfPJThLGR6
	14z8nMmoX7dl9vNWGqP9KIwt/lT2htU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FFRWKfBP;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
	b=z6aTmFDgmTr4l7VHham5+k09gmSkIl4MbJBxsM2iCW9BW66a2uDkMvmVjMATUqFoXX2x9e
	t9z7DAruuchusQcHcg0JhZdWk7msl0rppbSbcjaPYdl32H6H/F4TxxWLGHuthNQeo9E7kx
	+0JVwCOW4Zu7jvs8ONQjdJlrDaa7S+o=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso9354805ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133194; x=1787737994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=FFRWKfBPxbfk71xtETPIBGbhbfXwmdcu3RNMQhDkvQZM6OGMG2dpgOrH3OVxFmzEwo
         oYdor09z7U6mMih5NIQpAgQ/rLOJIRgKrM14giw6tPjf89Qq2e8RQHRQ6loNchYR3+pA
         dc9BhPizl3+Ss3a84rRJgxKZfD3Me9yVUpH/RT3PYC4tkzh7YWAPXniqZ6P+svcVD0R5
         qDKS4rGta7Hvd6EJKpKZsYD4haKmVP+++5cU1F/xmyRVSKhqXPkYuCXlNN0Cc4yJAiaV
         P9HdzB8KyHPf/gioXvBHqyHG9L7lgNalghJgxf3YWWEzLeNwSHDFiG9TRgdj41Gfbq/a
         tBIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133194; x=1787737994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bOzdkIPPNoupexe8+AVOrQT3DBRmXPJ6Kybkle+RLi4=;
        b=HYdYFPX14HAtnB3vw/dguleHfLH0z0QKDJwhbU7vWVDF1jrurv5hEf2V1fToTqqfOZ
         CfqZInRg+m3jFSLdNYPBJeX8M3SlMpbEYA8fcAaBajeIammR6PIVsB9gXBrEY22SWE/9
         BVEOIMJ3z3QTLAUF212fSAduYDXk0B8mAK3r3G1MG4THNEoksi0wkHMJwlQnc4jmD2YM
         F2UoT6yOo4+lTyAGkPRAaowqJQd7vhEXyC41pNkmmDjntfX77BgFJdFaXHr+VNmQ6QqV
         b5PJxhFA6lUfJOYDax6yrkPSsW1Gm+/cxOOVkSUFc4X4anewP+TQDmAQnp2HeDzjP1yC
         qYfQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrz2D+j492W6XhxFB4meFeGfKgrZ0sGhRK98S8NU/u2UoA8mx/K15RhVcJTZ6V3vcXUidQaVcN1dA==@kvack.org
X-Gm-Message-State: AFuF++kiAVa+NSeYNa+oISNtzZ4ke035/9OBrgZvU5C4yj3fTC6jbcLR
	d6toCSQ0uIa8jfWFANmIWFYb3O/Yh4do02+zd2hYydLRaBm4/cRlroGe+i3EJLmDru0=
X-Gm-Gg: AR+sD11Q6YqPHPbfdJiIkUixkL9pwCxoItnEN8CQKUJJ/ABXnOmjGCkT0qkimOncP9D
	3FG1VWNff/LRT7nkuWrFsyl36HrSCCWxQIJpf016TxYeTsue178nD+CsO+6G5giM5D/DwOMmcyE
	qtMDMs+tB1+46nWk5u6Xp/ooBXgcoMJpvDT0ae7f0NmE1+N7dd2Kz6WiyZU2PsGqMgohJF9HwbX
	ZLOEyDDL6HV/pFE2H/cb/4fvfEdYmr4uDP8AJrTRmc/TRqWoSVCHQ5gr7TsfXEYx4KYBXKdlVIq
	MSFQJMlQTLHhOc84MrprIU0/zKhDwuXD/fROhUKzCp329rnzwX84sFRXEanEMlojZYPjSW8Y6xy
	5d5EjAsuPmTb5mv84o70naZAceRWkcDo9b8vHR2itnf3XY3X7kCGhGUpYOT1da5ucYja8n41Hwr
	T3iQ3ELNBRIylfqMleYbahPc9Zz7Mwo2RIWJYehfyrC83ABSZSlQTCENcLcCnW3+60kdfFwkyF+
	cIYlFCVFt6dKvQ5X0QWOE7+jg==
X-Received: by 2002:a17:903:b4e:b0:2c8:4c29:afeb with SMTP id d9443c01a7336-2d5fd674a51mr64709405ad.8.1787133194077;
        Wed, 19 Aug 2026 02:53:14 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:13 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 04/17] mm/sparse-vmemmap: initialize shared tail vmemmap pages on allocation
Date: Wed, 19 Aug 2026 17:51:26 +0800
Message-ID: <20260819095140.17252-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C37BA0003
X-Stat-Signature: xsi35zknrftbw58ewnrggo1ynxnmjkn4
X-HE-Tag: 1787133195-93506
X-HE-Meta: U2FsdGVkX1+zou1yGEFBvPDtU95r8cisC/mal/LlnLZPDzAOnpqMhTLKX/x1kSA9SFzKqUth8NRlE0e/fF/9NGPbbx3OOLztZJQGb2rIrsZwjRDoAdhbjWp4qAXyj6KkwVoIlY3yd+Ffq5i4nCmDp75CpA3SE6SbS1u2UjPLZLv+zefSqTwgXnw64m6c83ssozEYoE2jNRr7IY/PMEScpeQDAImQFp0e22HIlFcCDK3yEjcXCpeHNAudJgFhdcDc8vYWMt4jd/+Td4+uwxdspzRHWsc0qSODNV4vLX6dcUmmXVY/rWZ9+TX9/v+3nW9S1vHYt+WkxBBg8OFDKPhSLsCTVvEd6hiVIibGWhRYOBZdlnpwuQ7oIYCUUFJ8wkEk8lJSnZnSNYYC/9VVTeT42HlR8yB6X4ZtfRMIOcofSe338Kbj2LAu3XFKIjbb8x9/iAoVVrJlWsgwJhs9Mr+FzfFFh82TJN/E0fJBaKeDtBhDwhNRQ4h5hrsNp4u4sz2oIdEPsyEEQah+OWNLEcOCQe/4fpQOGZpvU/g6UAOZtwhqwaI1Gkh37vVMGjUx4oY0gMXxFFewatQW0A1D0NkZPCeFDNkRTo3C86YeO3gIAmb5DmmiYQQvSga6ZV273Q8/5IIGeHjL3W6DnuimPRu28PDL1LkMA6tFIuDxveiBAlkGw+N/1Q6Q1uVfyKw/4lQj44lzCuiDm23GfH/d6po0x9IRBK5/5MwyJ9+WHfpOK3KdyAWsAmUIFzu4XwkbHGow7QNs/28Fowz4+6J4NcswHqvbSHFrSY8EhKZE6uCquc7ln+DFu0WGDIEHMBruu5awYsL/UL092RVZnd+AqennkOBKN/Zk2OtAiafzDwvNJV8TwH79BL2Wm3bksTG7PLhrMoSsYyxNykW3F5UrMVBi7UqnbvnL0kq61XVfXy7vB3xldBAgWIGDHlmB56lZUfp1L4MFZes48SmPXh5SdmB
 v84ZSdNp
 Li7yeRPMZ6q3NQJjOzfnAQlrmnMEwPdr7r4PTN52TTZvIPVfm1XgiLS1wuFIMvlkBSFXKDmh3Iv2/FpBx0/utrunn+DShQxlQ33k/a5e5U8Akl6SM8mR3aoaGrU9MhgrwNgVw5ujRjk7/Dt4YUHQpjy7U80tEFkMZ/927doxPDBQjYhoaE/O05gq2S2A98LU0q7zQXVvOFf91/HnQyEm1D0Hb2uaIwHCCinkTiFuwA55K3ivfIJJ/bfn3yAM3rFnoMseQ4MM5pDrZkCpeOen7LGcZ/Y4tcfT3wHXyT2lv6ibCh3L56GAnNj8sHXY8Wo0HMIWsUVyhHE4YdIigZCvuZ6PDVlhG/bswqzsBzSgj8J6RfkbO9brLAC/1XMAlSXJDPHgU2X17iGOZ/zLIMqZV5RhhjJ6QVS7rwvak+AE1aVrrF10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
left uninitialized, because memmap_init_range() would later overwrite
it.  That forced users such as HugeTLB to defer the initialization to
their own setup paths.

Now that memmap_init_range() skips shared tail vmemmap pages, initialize
them immediately in vmemmap_get_tail() with init_compound_tail()
instead.

This moves the initialization to the point where the shared tail page is
allocated and avoids relying on deferred handling in individual users.
The remaining deferred initialization in HugeTLB will be removed once it
switches to the section-based vmemmap optimization mechanism.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aa6a4a2fae98..107215cf8488 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -338,19 +338,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	tail = zone->vmemmap_tails[idx];
 	if (tail)
 		return tail;
-
-	/*
-	 * Only allocate the page, but do not initialize it.
-	 *
-	 * Any initialization done here will be overwritten by memmap_init().
-	 *
-	 * hugetlb_bootmem_struct_page_init() will take care of initialization
-	 * after memmap_init().
-	 */
-
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
 	if (!p)
 		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
 
 	tail = virt_to_page(p);
 	zone->vmemmap_tails[idx] = tail;
-- 
2.54.0


