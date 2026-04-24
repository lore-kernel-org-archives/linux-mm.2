Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 448BAF34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6326B00B2; Thu, 23 Apr 2026 22:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57606B00B4; Thu, 23 Apr 2026 22:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946BD6B00B5; Thu, 23 Apr 2026 22:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0A26B00B2
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25DF61C0F0E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:35 +0000 (UTC)
X-FDA: 84691936350.25.0EE9A3F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 49934140006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fOL67c+A;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETx/tSKnTC+n/nV2wgCSbp2pIhIkVNUTkv0q633meJ0=;
	b=bcdXT+RWTZeZYWzFib0BsGT/ZPoT7T8bYokRR7rK1rs4w4aNRNYEMAS9ju5yUy6hWM2dNe
	diCtRDtz4m4SKlOi3VQi5TmSj3ENkEbI/3cOqe33Lm8GT6LxNnVLEIVtfVCgyZ7ywosPeM
	eQdX5LuK69NmlZPL+BbzYPIp4tQQAuQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fOL67c+A;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999393; a=rsa-sha256;
	cv=none;
	b=x+/atQf31sag9b/9vSEHF7tg5CCPg++q415U3TjK/fZj09XFmhw2Nhw4FexPWUxq2f0TOX
	5pYTr7Tnyy0hdhlLj9AWbEiqWI5uiJRQL7/L6m/iCD8ZLZ+GFH5lXOdWagnZdptTG8FF+b
	QyuCDNM4NUhlcwFkmK0RbaBS477U4ao=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ad9516a653so37177795ad.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999392; x=1777604192; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ETx/tSKnTC+n/nV2wgCSbp2pIhIkVNUTkv0q633meJ0=;
        b=fOL67c+AC8jiJsONThF3yLHW3YQetfFUYzavuO0oIxd2WWPMqpUB/fItNOIEZ54+Xc
         bX8UokW3SdeHkHiDUIpLv8erhv7QxtLX2/qVC9ucZ/7sjrRbDeHvhXPssBDfJpFCsGPZ
         5lV6PRKQRo30zLb8pFyylWEZkp+Kr9AaLhirH8S2b0sku4KlvLVV1fuXMLTpoiGEwTKB
         QPePmburBXH5xfYbBV/lNJGKCihd8Kw07lPykEs+fLsg7onx51mrszvsVmm2S+L/VOSz
         z2BpsWr+qQxkKuy+G1bKV0u1knTN1oRkqLjANaip29AFbHdyilTca4P/NHWiNqsuvGHg
         JEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999392; x=1777604192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ETx/tSKnTC+n/nV2wgCSbp2pIhIkVNUTkv0q633meJ0=;
        b=M6pVvJ/vNQuzFps8q3J0JIlNi0t28n8sloW3YFt9pGkz2rLsc9+OZNHXczwJh0LgxN
         huKU+BpCN9gRo1OaHtUTTDnylbqUhawLMIwRAeV/P+av93FH6FS6x/92pdROJ/d193zm
         o6cidgE7vY5SA62KhRrMrmf33+bvXGVAdD3CPxRYNUB+PmPFAcBIh1HaJjhW+jcc1oou
         lxi9vxTyha+n76gWUONRbQ7KDHq+z3RC+X98JsJPQmm0wKO9gnFPhXH+gCjigziNOjVK
         bDnRfcyLmbZRbOBRlN6FyHo3Nosjr8jqNHpeu+OpSpteW/nxYrYfjFKPB/cXv3lGbOdz
         Uxlg==
X-Forwarded-Encrypted: i=1; AFNElJ+py2ODHOesDKhRv9Tqba41ckG2qop+sasUt1FhhKdUv/gtB6svMx4yQUc52gsVtQtP5xgzu4NOkg==@kvack.org
X-Gm-Message-State: AOJu0YxYmzzzYgCfX2aVkfD6EyjdHoiTlTE8ajhuRRbVz5uwUCEJSXUA
	dzVcpvJzysVDxkAVrrniWu4K/Ot8vqKj0vOHcQjnlcoRKoSPrQL3OhyOcZn5J6+TjOc=
X-Gm-Gg: AeBDietvdOkVig0yg+Zp+L5tSbrEHDSXkZQwipxFh8Nw7mOAQF1GJqc7Hop07trqPhB
	R8Oj3xpF38mXcq5RUJZoLuEVnzoRqfGnbl+4rbyaPP1z9x9kFdDIQBFo0kkuV3GfLduu9YjJmOU
	Kdnjy1+WFKY5Y2EHEVzVX8qZQxj332Gw+qnRXpAsRAPsLpgnoa1p1XRoFTHYEZArHkfIPktGO0X
	tKzDhXdLik0aL1ui4s+cE62QQBSUfCFlqVqJP1UBMLu/+ZGHbqQdZfiK4ExOcgVJRRJty4ZbnJM
	S/PHBN9gSd4lmB60+hs3i52yc2y79iM/2gAfMweNKU8aSgiFLuZ+RLyB+Zt4a1v5fXvJEUP3Rst
	khFGpBS/3ymheQDGvB1iKt5LQ6mbJB9J+jg0KgC8Ww5WwAti0cU9gpBeF72bkykzBg/vW0IIKss
	kdcJA7VoWRP01G7TyJ/VWN2jw+ph9Wyi2CrmZ8lviWULLl7KVjCtroaZ5Ml0CgVORlkw==
X-Received: by 2002:a17:902:6bc2:b0:2b0:9101:1b77 with SMTP id d9443c01a7336-2b5f9eaf6a6mr216777385ad.17.1776999392104;
        Thu, 23 Apr 2026 19:56:32 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:56:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 7/7] mm/memory_hotplug: Factor out altmap freeing checks
Date: Fri, 24 Apr 2026 10:55:47 +0800
Message-Id: <20260424025547.3806072-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260424025547.3806072-1-songmuchun@bytedance.com>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49934140006
X-Stat-Signature: ur48erte5hsxn6g8bh7ziqx846huepx1
X-Rspam-User: 
X-HE-Tag: 1776999393-451167
X-HE-Meta: U2FsdGVkX1/jt5kqKdKQ/hQu82lXOXiB0PnSDC0UYrudsCcRlG8qbIcgh4P8CVLiLHhKRILWfKPjMpXiv7xnWib5jfTQy4mURMncv4jOdyDfEKxad9wfamankFyFwCbhgwHwb41WmxrNOVEvYXp9i0LjF7Zi3DbHio3/iWUwTMp82S+9kzBWvm8fRbbBGOotMvqIRCSTeNj/9JMO0FjfJfX3/YgEjKxcNI0vEGlxbivY52GW4KbCytld8HjZAHLP6gJX9/1kg1PkCAeGMYQpoFI1mkoDp166JDA6R4ej6nc5ffivWqJT0Kh6OjdEPNJrIib1FXO/J+bsvsOtkfv7EbBgWw08KM/OMZSxZTrYLipnSApgCTuYb2K2wyCD0I/0hNxHdAStu2N8qujfa2ZwboNEwI1hROhOqaShoAj4md7lj+buJd5/6W73IJ8Jy5nofgeTkSbdeUCYynbXwCKPCzmMpbnRNSXnv7W+CaLRj86s9Xkar/fG/0y/oj3lMBt29QaAsTE8D8gOQAcl5mTJPYS/xfsYrfyB1CViGbhGMpMaIAKiR45fbEmYhCgmI/JvHc6ZBMDFPgx1ePetYLotV+jh9TMn4fx3VLyJowLA1y/xdHvyD/VvNAUmkgucICR5o8FphoW7BYLXk91ZcGoc2CPVamf0UueUjNXeGuTlJc/pHCOtQEXC7Aw5QXvkFmx4dFg/S/aNEjeKPGUWvft0DQkyQKwhj2GQPDBGU6WNxFayM3h3zzZlK7o59JPpCNseFGYjsW6VcHuIN6tM2/pZXrBp9H+ShIBVisxkzjBWwsNp9Vdm25luO7n29SvkKV4GTNi3JUzocU7mJP5l4cSlTWrKxxb35A+Qm9akqkrw9YWolzgeR3HsqCZcWUSjlYIgyXWT47fCCLjJ09oQqrnriAnip2702Yhcdepklxnr4XdkehV/tXFPW1VTLaiN+MjRtvpvdFazcByDw/SfANr
 egTkUL15
 Ctc5338xAbELN0uKc9CEuoQCZ/IEpY1iTebobXt9UFSzQgdQ+ZLMurGb/rlVZi0mOTJp+qHqVE0cIiDRWjdjpBExki1xLx1ELST/hXcTIs7hEkIRQVD35Iaxbr9H+eyP+w4E8P/Si0hmHEb6eZ/hlP/wiYn2/cMwVlBtuhGJAUGjQIC1SMeZpr66AUtNz/t44F+8moz4O9HIZ7yxmJzjNLS5eXYTt8j/Je8dxGwEKEOHWH9oz68jbdYPTGas3BMVsR0trC0WgQ0U+dVusv3MuYSiGpmamWzdAKo0m8vJeEhJNxBek25+bJHhhz7AY3SLyajak1Prl5U9k72rdCm9jP45KTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use a small helper to centralize altmap freeing after verifying that all
vmemmap pages were released. This keeps the check consistent between the
normal teardown path and the memory hotplug error paths.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memory_hotplug.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7bfdc3a99688..ee150d312bd9 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1403,6 +1403,12 @@ bool mhp_supports_memmap_on_memory(void)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
+static void altmap_free(struct vmem_altmap *altmap)
+{
+	WARN_ONCE(altmap->alloc, "Altmap not fully unmapped");
+	kfree(altmap);
+}
+
 static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
 	unsigned long memblock_size = memory_block_size_bytes();
@@ -1425,12 +1431,8 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 		mem->altmap = NULL;
 
 		remove_memory_block_devices(cur_start, memblock_size);
-
 		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
-
-		/* Verify that all vmemmap pages have actually been freed. */
-		WARN(altmap->alloc, "Altmap not fully unmapped");
-		kfree(altmap);
+		altmap_free(altmap);
 	}
 }
 
@@ -1461,7 +1463,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		/* call arch's memory hotadd */
 		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
 		if (ret < 0) {
-			kfree(params.altmap);
+			altmap_free(params.altmap);
 			goto out;
 		}
 
@@ -1470,7 +1472,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 						  params.altmap, group);
 		if (ret) {
 			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
-			kfree(params.altmap);
+			altmap_free(params.altmap);
 			goto out;
 		}
 	}
-- 
2.20.1


