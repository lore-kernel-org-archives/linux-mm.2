Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A445C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBD06B0114; Tue, 30 Jun 2026 11:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3796B0115; Tue, 30 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0766B0116; Tue, 30 Jun 2026 11:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07E096B0114
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:04:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 931D6C299F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:39 +0000 (UTC)
X-FDA: 84936900678.12.29107B7
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id C471340007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e2XLixPJ;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831877;
	b=MCirQmnGS3o79WWa0NOTG1ch1R5D+Kxrncoi/2Gum/hemrlbyrHerUhOFvUD2xcp1G0k7L
	zBS7vR+G7Q45UwSDdDL7jA56cIro3z8O3B9z5n4JEHNg24av+ZSCdYKIRha+zHfRN6n65H
	8bRDPRC1D/zEXifR8quvV7OkZb9wzKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7qMl6JaTusMjQ71t10D/Z6xyVtqjy476HmM+ncXIDo=;
	b=JNt3Aekq00TygnFNSe7yPolkVwUfWVwFsLRuJVnhc19G7s0R61x6DfmpHiTpaPWjVjmyp4
	cqEGqIta22XFxH8HrcrAzmp1F9VSaIBPH4AtdwS/SRMH8cujqxKPML2CRfDm2vy/uLjaPr
	XzzY9dNVji4H/7StHQl6kgT+0nLEl1o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e2XLixPJ;
	spf=pass (imf04.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ca265d6ca1so5160705ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831877; x=1783436677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7qMl6JaTusMjQ71t10D/Z6xyVtqjy476HmM+ncXIDo=;
        b=e2XLixPJtHAtBLqYSdOvvHPkTIlqUecEOAw5N3eDGRQV8Jin9+5q4p69oPMungeXYF
         Ao6SkvOWKLYG6ODOqqIrFCSIt29f8md+wXFf6o29Sn271PkRhwXyP9ptA3vmmJ5SdXWQ
         qsPjg0ly+6YqhIs26/zCIOayrqyB4gRBijIhex39Of7eZLeQrUh8GLReq2Th9AP1q1DE
         QhRfPilAKyJDRWqt3AaRv1ayeb88ikF7Aq5TarcEX1lHmzxzCYW0XsQFRkbciT9Jig3P
         Z8D2YjwdpAvbBjRV7TYnXMo28ZkPa4k3ytMdrDkDDiwlSvAjNlsDobIQkO88831r3EfM
         0WhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831877; x=1783436677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y7qMl6JaTusMjQ71t10D/Z6xyVtqjy476HmM+ncXIDo=;
        b=IS/OEIGG02GWwY8rsYuoXE3CdiJLmqbt3BIcy6zQCn/VcXzhdrSLIXLWmYfy14X+3X
         WUfgaBYe9lvAZ6wD6A2JHtQaiQsXyioP+GdnEFaemLI1vm1/3k821sLq7Lzu3nZ1xbUp
         4HOjs6UgAPm68F6RLQ7UyXA0j04g6Og8xgpHREwR+cCl/0p4fvAI2nDf5LGiLw6kvHEM
         PO1UDodvPZwYHMj/DM94nhVUBo/dOHqa6tpgjtf4zDWVK1nDK4x7RQo7vnQYjgDNKlQb
         4xvINCH2Ps/RQzHJ9S7euE6Kq+t77T5GR5s4RQPVDoUeMFyd0SQQCKmP9NwUqkpPfw5M
         Mh2g==
X-Gm-Message-State: AOJu0Ywp2g2dUljEvYDCZvdUmntfgmmkaQ2I6ISO9vrRoY/yHBd4LuLh
	uXqUIn3DGtbyIgNBW3h4bWGr+gELjhnTQT3eeDIl9hX75JZvFcs6XHWn
X-Gm-Gg: AfdE7cmdpr5nN1GoWAxCE7pmpIbG0YTu5PZ75xAqjta0xtXIErwyzRyktCq81qWqUDO
	kxc/Ui6WlxWctsLAXAKK5DDbqr98BWRjnQIhLXfehxnMN7bxeUlA+fe6htLqtAq4traizQl8WOf
	3fWF9qz0Smwc8tiJ5vFSgYrhIAcOVGYPaT3oB12jumfLE/K/H3uK+qxFjSe5gL5lkkXlHgBSn5X
	ujlnmbT0i+oUNRXCRT7G3rjgkgmAmfIg4Sairowc/f0T436Ur4hD18+bFI3QncgtrtM9c8p/UtG
	4lWqgKsSpJHuSyxkKIz8JP3NI43cJfjiki48l9XT+Qu4d0F+vebem3zOBzYnr7TMfw3/1OomV+1
	NekrRVs3GcBkvP2xPdKxXQX0e8+ljg0AxV4IQ7ikCPN9tW1K23PE0qYPNxD5SLEWdw4Y9T7BSMw
	mgBmnrcMo=
X-Received: by 2002:a17:903:19e3:b0:2ca:53f7:3c6b with SMTP id d9443c01a7336-2ca53f7403emr11246105ad.19.1782831876664;
        Tue, 30 Jun 2026 08:04:36 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:04:35 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: [PATCH v3 1/8] arm64: mm: remove unreachable invalid range check in kasan_init_shadow()
Date: Wed,  1 Jul 2026 00:04:06 +0900
Message-ID: <20260630150413.1718632-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z5ntq73rqqybrinaow5gmumc47skj7r9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C471340007
X-HE-Tag: 1782831877-759960
X-HE-Meta: U2FsdGVkX19+Ls7ELn3QOlbN0fvBm0DxeVG9hlYt8Sn9ptuzNypv0P6S8U5QkdSR9tfCUwVNP/HD0PplA02zyjBVjwQnGu5OUxshgPKLOQ+CCJ6lLuVK/YThoulq2lpTTiKism1dAxl6IJ8A6A+MX5VyyZO/CNpEkR7Tzw2SHJM5Lo1MF+VuOd/pJwMiK40wTdFZJpMB/S93l82KdJzf4EAcCV8nlBNk1l6oR21yP6u7Vv1245Dop/EQ1Yuy+LKUIjP51P4Y/4E/CdnNvSreGGq3WbEVclq7WkpACpg4371A97cuTNUXXVmvCVXPeK/iM1RGl/PxUS84fRDk03uD8exATYdYOA/Ddv5PPfy5dw7c3i58j579eF1rusfEr9c0l65wVXzoBNbFtfjr9ZjFs+Dq1p7RZ52Xw0ax9y5sv6eBnSng9uKrBp0p4R3P3M6oHkmNHWxtm/q27ZFBvqmy2HAZuX1ErYnL1hbLRMvCf3crmACTv8ahK657PtUg+9+P6aYijhABHb95PAZSjxU5GZNUUZ57PXyl9OI9kudCxWBvF3hcq9hMaCmAjci1GvyBAQWT2iDT6ckfX35vxyh4WIwWfhbzl0tkjZUz7nnThJckbWNSFtmYe9IC5pWjVrIxm1+PlXGyhEeScJrXt8POVCa0bSylA3jR28jAk12Mmk8mO7an1fhldI++05nHZB142pM+Que5InbZM8wJSfM665dT0/4/vcQohVUs4gUhmpdmYbQ+d/on6xInttp47ECtIYlQrqe7vQ2R/uSEqSiugZIr91ccWog114cfcrUOi1OcnaqGxIRy95ytrY3L4xitsqPqEUy38+jf9uoYKe8WqU/p1LTW2K3Y/6YGVnYIa8BnGnHzVKjjPa1VhMzcQ3gUb9orUKPxQ3gFozZD4oHc+r8OK44yb66Llc6u+R5Ulrhk8ccIjNV+2C+SFmvFptVN4DwDMWUBsT8Dp0o0UFS
 oWhX35t1
 57D9f18264pris+9pe2nwU63mL82bs3Fq6PRXez7T09YNbjaDdCIdF52vwf/RpNYBCgoetSvI6kAW96dgDx3m35SPkXUQPlj7QmFTlMJYRRE3htJVAr/cAQ3kN2GMq+vLZCLzFVEA/ZkrUebW6oZAIi4rT/BDkgFJp8QvFuJ7X6h4hEKJLqlZSLF2jj3zmuIhbwZd0h9dGS9TtYIel7ErFDzC8E1Qnb6TeE/LZFlPeoN4lJFLJ6u408pQuCK5/zDnR9tq/GYR/n2PMS0VMDHFvrSEDmf4MzVmiPkOo4HSLD5dWej3nGEVOCcfFjvVG7tP1voGkcRAQZ9t7Xh7boO69TirXIbRC6J50F2EwgK0qbUoE2F1SyVa6azbKCJcLLU0VUcEtS+oXQVsbmBkJApJIfqJSt7Z+K77JQLSVIkhxnMZf7iVEyRn14G8aR8ZbTHdqlIdzQizEgXGQ0Vet09obpnWz4+F/LJQ6HS8+bLdtC1cW8DkA956foZEVLsI9hi6cCDQkrJHkE4tQ2qtae9y/hFStzbE90rRhcbfB0RV8liAQHb7DRoZ7A1hp0vaJaNF+oA4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init_shadow() maps each memblock region with for_each_mem_range()
and breaks the loop when start >= end. for_each_mem_range() never returns
an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 arch/arm64/mm/kasan_init.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 3fcad956fdf7..45fbdce684c8 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -353,9 +353,6 @@ static void __init kasan_init_shadow(void)
 		void *start = (void *)__phys_to_virt(pa_start);
 		void *end = (void *)__phys_to_virt(pa_end);
 
-		if (start >= end)
-			break;
-
 		kasan_map_populate((unsigned long)kasan_mem_to_shadow(start),
 				   (unsigned long)kasan_mem_to_shadow(end),
 				   early_pfn_to_nid(virt_to_pfn(start)));
-- 
2.43.0


