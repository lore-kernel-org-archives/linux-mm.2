Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BD5CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35CE6B00A9; Fri, 12 Jun 2026 00:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D3F6B00AB; Fri, 12 Jun 2026 00:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC0A6B00AC; Fri, 12 Jun 2026 00:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB1E6B00A9
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A874A03DE
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:10 +0000 (UTC)
X-FDA: 84869907780.10.EAA1C2B
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 697584000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TFO0ujSY;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AtY9w5OLgbMDm1Vvzf6EQHSekByITXuJYckwU3WoHU0=;
	b=NNbv1QtEomxePmqVB06coSKGNVEbgfUgeu++FKLXdd3VNGpvTfYnlhYL9iGN4+eXY4HhTD
	o/zsgiG/xW771j/16+GO+J14k8ls1hSSb27AK8965e/6Z+/uDPdeeaBD9sW9+1WT65fIz5
	JqkL6+5yrys8Y9oQiARrBcZ1M54mF6U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TFO0ujSY;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236808;
	b=cTfKr6SEweCQ+ISlP9nYC831kjomF6IOGKIcuvh5DgHwAhI5NCUGmtSHONzuqy0b1mCpAa
	U4zcPlFu3LZnSTJqfjTvl3woks3yv1urty/AGuj1MT+33SUNfnGJDhPD/7jACeTHVP7Fvd
	d9qmx9L+SqpjnFz42fR5sjWUb38dxus=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-842338c18e0so448939b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236807; x=1781841607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AtY9w5OLgbMDm1Vvzf6EQHSekByITXuJYckwU3WoHU0=;
        b=TFO0ujSYoQpQIBnhFPF6LAeFlbj3dPam2sGtMBm74HZLeTP8PQ/2z6Ufi/RFzziBf1
         OW7bf5bEHCiUkxRFrvJhOieXBEiXdENmWmteIYwOjBGY+rTHjqdN7Mn7/fXfDkIn2vct
         GjxEtLewexI0sMQ93Qq93EB+dyplOFJ9hy3a4H+D0+7UcosnG2kf5HPPVShH9xqvLu7b
         cI0cYUB0DifCE/VBfyHGilbeQqjOeYrLQ793jcyjfWPuVIVeAZnHt2+q5h2GerXUyqxh
         FucHOTTap17hW0bfPqqItjunJburomsfh2ULUtql6R88Bm6/Oe6g9+fiO2BbobFudp5K
         4qxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236807; x=1781841607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AtY9w5OLgbMDm1Vvzf6EQHSekByITXuJYckwU3WoHU0=;
        b=lynChfrAVez6M4Jt1gDIALRdmZnilJ+bFA1rfnRL4BEvcXbAWGIdXzrBGDS/Ipg1yu
         nz20zXsuAIbEJKyq46BAHt8/IhgOMUiizK0ylQ7Qyq2j2s8Wvb8qSqMD+/6kx8/ut2aV
         Hc2S8CapKp7a8hblhoHoxhZEkB+3QrRYDi2pwCFPQ9D+kiDUDVD/7nECL8+8NUioPRHf
         8yVKyBoBQpv4XROes8TUL/HGB4FJCFKMDR620hRB6Q4DXos9eOZLFC1caMvmk0fBdME4
         G4Xo+4fvdJ0oIYJvqo9GUe2W8sRoUHY20kZnfPzbuKgD9Ml86fNqdK+wlOgXNhUuNyey
         AaRw==
X-Forwarded-Encrypted: i=1; AFNElJ/6gy9E/OazKDqmGdgcZ+dLHDCVGN1OrFjN3TitZLHMWZJBVePodjjpgKJjo6kN7m2YMEztpl8dgg==@kvack.org
X-Gm-Message-State: AOJu0Yx2FWzqYp+zCpIo19EK1OqeOh+8C3ScpEVguvZ3KXEvxdDEAvzY
	aEzdR0aCJ3U+tDY0PRH9IsipcKbcW+ZyPsIA0CVaq2C1edeXJQuDgWg7x7sXNv9EUZk=
X-Gm-Gg: Acq92OFoW8hBYdErcqQ1/K5o/SiCNKwcz1+RV0KKFQvj1ebl+XPr25EOzq+A09rN873
	+ZpAJN+p3LKJ2Ea7eI+ubTDUYjIUR4XpBKmhB8FDKile++0ZQVoJEdT5DeQ179Y+ucRJUtNjZSC
	43BC4ygTt30xd/TKZ7rdhMWhGgiwxrt5QG5jC53KYfCX60Nkw6paCvZD2r+Ib2ErU8jkHidOPJI
	E5UiWXVgvCQ6a71hVpgY/PEZ+wrgf7+O5EixlAC7sZnc7g/8B2sw7uzqkbP9Y3ZrBrGmxEiFYqT
	LcM2eDfCN7t3IKoswEDViaoH0tQjsnvs55f669yCtp5IXcCzbH4zfEg+b3WeWX1nwsSqJcR81/a
	B2tMZEfQ/feCdOxjSowqxe7vSB2AUmFCD3lsDJohStwog6lx8EnGLZj9h4071eiMDEQ4zqkZwhp
	ckr2j9L+QxFIJoPERXuLZwrRtx1PgGW64svbk/l3aGLec=
X-Received: by 2002:a05:6a00:2992:b0:842:5d9b:d590 with SMTP id d2e1a72fcca58-8434ce1c8c4mr1121632b3a.30.1781236807010;
        Thu, 11 Jun 2026 21:00:07 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v4 11/19] mm/sparse: Move sparse_vmemmap_init_nid_late() into sparse_init_nid()
Date: Fri, 12 Jun 2026 11:58:55 +0800
Message-ID: <20260612035903.2468601-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 697584000A
X-Stat-Signature: xusaxa8z8tn1ydrjjkboyueonxi7dsa7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781236808-755133
X-HE-Meta: U2FsdGVkX1+DsrtcF4X7LcJ6Xou0qhOyX2V/AkINRxUpchPlzjyoefv3d3hyYLHPk8dMn8Z4BazZvVnB0450pXfZCpp4XiuVMAngzUAlRgiaHIwyJN40w3qCikqor+vqFNzMPSZtPFT9DFuUf/l5VLMSF0glO/Lp7ush4ra4HZK98mj9htDoCSDVkeZrTOr5/N7kfIe8jkQR+uPW/1oTdEHwXpKtLXO+TexFFTUefRoucxurkMITgGu1PPI0RclqnlI7XWK8n6wQ/35mK49F3dH6HdKhXAbCOAbvuS3kxS846WEqj4JGyNuRauvmC+OLUDpIV4MbJRW2xoSBpBFUSSuqbmpT+xgOSaMHpLih7fppJL33UeMokxlZ2BeFbEkvQw24RPc8SPZqeFUFI/HLjaKkE9Ad9FjNNCl5yGM2sy6qG83kDl+lde7YzfUVv3n0T/aJXBNMxaTEozEtkB61MGTko0AUR3Ss87OH0kYD+j/0KKhdH9SBjZMnEJBgTtdTz4Ciehy9HJG3kGzWXsqbdKgdLf/4GdtlwL44gpJBnYVWhi4/UUJJvP+DLuGQeQDfBqvsVbikvwfVG8U2U2DKcMPvO/lRWT7IwrBT1KDl9Xrft++onUoUpOJMZgZj2no8hmGzOfIpVgt16ZqFdX0Cp7WMTl8DaCDjJN3h1mCQPynUOVYI/3cSY51kX2GbUhGLzDVFPUBGbUwMxkNyrrNCj+fE3VNmJ3cwb4nLdl/BE0oAdjHXe731elJ65QC3HKDHz8ONRbp/qWl+zjsJIVe3XRhBwnPceQlshviH50mBxDgLnalkXGCVNDaRWBavQMP2x2TRoGoKXPdksFfQQNVCKzlXoCWMyu9/69LdH0sE3oSJ9zXuiHfvvxyK2FXhF881hh0v9UYb8GfnqbYVgm7tTmyIBMSYzF/+2ztRS6VQRmDkyCWZUq6dAOY2Pj94gAGROPdd2bnUpQvIKCM3xLg
 PO+FYBQq
 bIf17dlbpWaXkdlUoNnF53nzTaYd3qTo/iqSUg8PzVKeNC63JPau3I99iY9xBZ0J2hdYoF5efX/I2GEMdWtYGoq7/y6aRsHnIdvIio2uKtLF0VkIkI7vnM4vPo6elU8fTFrnP6qGwoCCAWxj5xcfnIiSM+lvHFnfp/c29z143TE0+hFojlWYPuXDQEzzkBiWZQEqJTVCPb/lvfjun0MoVKv4Ft+8JL1gWiS/w7KNemb//e8HfiBiDYv4VPTS3O8xVmVLwuuVe1FZOSSeocHkwCJRXZhwrGaCFfmtI0GkGVPIIDPviK9ICaX7hDAEQ4UYphCYej6jtn+z5Z4YrsDG3TvGouG6qTBhNNVkkmeK4xCfxX9HAYAZdLs8gM1n2wGsUXbAzwL4KlTInvfmfk1uT4uJiEUfj5Wy0dNbeVPjr+TDTQN8niI4vVnnVz+oFEDb5TsMxc9N1mE1sMZn1oRwvlOUurvHFRG0rjUMntZgoxxKa8C8xMcE2k3x7QkUGG0XyjFBXMgI2Tg3Y9RtmgDjQRq4aTrqojn81+Zod
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sparse_vmemmap_init_nid_late() is still called separately from
mm_core_init_early(), away from the rest of the sparse initialization
path.

Now that sparse_init() runs after zone initialization, call
sparse_vmemmap_init_nid_late() from sparse_init_nid() instead. This
keeps both sparse_vmemmap_init_nid_early() and
sparse_vmemmap_init_nid_late() in the sparse setup path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
 mm/mm_init.c | 4 ----
 mm/sparse.c  | 1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index a0eb61f9f55a..c76498b7abd1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2674,16 +2674,12 @@ void __init __weak mem_init(void)
 
 void __init mm_core_init_early(void)
 {
-	int nid;
-
 	free_area_init();
 
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
 	sparse_init();
-	for_each_node_state(nid, N_MEMORY)
-		sparse_vmemmap_init_nid_late(nid);
 	memmap_init();
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 324213d8bdcb..3917a47153d8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -320,6 +320,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 		}
 	}
 	sparse_usage_fini();
+	sparse_vmemmap_init_nid_late(nid);
 }
 
 /*
-- 
2.54.0


