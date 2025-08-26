Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF2ACA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5CD6B02EF; Tue, 26 Aug 2025 16:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F1B6B02F1; Tue, 26 Aug 2025 16:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816AF6B02F2; Tue, 26 Aug 2025 16:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68E106B02EF
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCD8F8404A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:34 +0000 (UTC)
X-FDA: 83820117108.26.9A97DD7
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1780F180006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b0xmDBO0;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3RZecD6lOIXMEN4BMHwXQ5RekIY8XyyevlTW2TRt7g=;
	b=M156/Gva8qbCnMLV2VUzHO4yZHXTQ3gXVYZOdKsbvioDH2eqjI44UKm5aaGmyHj6xhwogE
	NXgmchKSBrkuzGzre19bcMsm9VElfcXRjdCK+wNdiOgftrph66nQgUcrE1UOXaE/NKhCdh
	CIjjTkGjFLBHe3+VVyr4aRZzSjE1Osw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b0xmDBO0;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241793; a=rsa-sha256;
	cv=none;
	b=etWpTKhbJvtavXAI1WLNJnEe47RtdbcUSuSW7WjRgIrencGQz65T2j3IK9Dt7QXlAYpB5q
	Ho2vngkGg7OJmNxYagyb9H4Z24oufn28wmrXHo4CyZgVSMpdvbcAiVsjSGzVr83Wtcs1oO
	AxHsfWA6Ge07KbTDtBSXh/ngNqHK5/E=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2487a60d649so10447215ad.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241791; x=1756846591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3RZecD6lOIXMEN4BMHwXQ5RekIY8XyyevlTW2TRt7g=;
        b=b0xmDBO0xoKGsPhgFmwpr0W9Z1PcmzVszKclDrIR6ZpsPQxY3A5v5nU12jmAWgLXrl
         IO/jxCtLGr2KdOW22ulwW37/3QGhT4m4U1gb/536jN4vRj7rrA7cI5y2zWjZ7POIC3c9
         cGxYc3fydCjZCVd0bCPKPxV4RVhfM1XC/53RxE+czI57cTJlw/TTBFyC9FiLv5e9lNW2
         ZaDUJZxp/N2t7kVLG1yO8k69KUE3lXWbLu470/wEr4dm3OJqDyrAYn3FSlabnUFLbujs
         DANlBBA14lUCGYcBb7PWslIoOcfUMJjlhNUZHvlrDEkOTj4NookauZlLfKxSuBIeIOQE
         s6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241791; x=1756846591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3RZecD6lOIXMEN4BMHwXQ5RekIY8XyyevlTW2TRt7g=;
        b=gKCqYiWDU/kiZGo2fO7+qwDzlW+RsSidMrTmY5qFqrRut+R1v21+0Eul3fdqUNPsTJ
         RYKgaAv3HZ2wVLQbUbdjibK7fvFX9wMNyym4XsyMNNGC5KU+Y1q8OwT0j1zRcPGD29VB
         oS8RSNr1Obl1sEQby9TqPfKWNhjhTlNRlSyceodBFFSqEIrF+11NVSxDxWJaIX9LeSxr
         Oo41LneeFKzq920kVITGLCc13sux1EQT85clbuYGrvmFG+iZD5eDSzzznbd9Tc7FYGGW
         hZgUqtf26GTlSircuRXftU8+ra795QkMCMm1kNnYtrOKvFdm1nkdwQRn5mWF1fmKI7sA
         BTyw==
X-Gm-Message-State: AOJu0YyJILlXZh79J02KIx6oo/v6+WWSPbEGV0Q7uOkvluf4IJyDWbWP
	Lsqg5r9IRH3R3b9asqGqjAJgIHVPIoSa5YDrO7A2oabkzT41NP8+S66lXVrqUA==
X-Gm-Gg: ASbGncugv7EBSR8GKdj4Qu5bsykJWTqxDTku9IYQpRpYuytJ4GP7lb8/p75mBTiZlYV
	1riNqCPbGydRBD/v8X9DRUnnVLb7Mq7SE9J8hV+0I7HR9xA3RZ6NdS1q8u2PLX8Wg7OJHD8//dE
	9vG0L1SqQ/faCXXdi5oo5rLARPSxSbVlukXWxTr4soOiLFnNkvaq8NLtFACqbxVD3/7tgiqIBXP
	cvLNrrzaM5CJRXCirA0W+q4hf/nqHD6CkeVxozizn+6Zebaop/1m22HolCLK17/OKli8juAwZ87
	rkYXKE29rwdQ3h+ARN7U3C3RXBWsnT0etGeuOMJ/8bub2/JZbP7F8/c6e7nXAVJlKAe/9F1/c0g
	PGaxlLMtYlEIz2fDvdIJW1NEXhGoNBPSqZ4HNMirmxKePWasXHtD1qg==
X-Google-Smtp-Source: AGHT+IFkbp2G3sEZhy+jI4BFP7keK5NV3wYCFzstA/KajI6AkUNi7BbF/X/7dqdbsObKoDZF8Sv3xg==
X-Received: by 2002:a17:903:32c7:b0:246:b47f:9b01 with SMTP id d9443c01a7336-246b47f9ee6mr129856455ad.17.1756241791330;
        Tue, 26 Aug 2025 13:56:31 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:30 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2 3/7] x86: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 13:56:13 -0700
Message-ID: <20250826205617.1032945-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826205617.1032945-1-vishal.moola@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4fhxniyryhpsq8mgy8dch6p85mfrbssw
X-Rspam-User: 
X-Rspamd-Queue-Id: 1780F180006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756241792-667246
X-HE-Meta: U2FsdGVkX19ZCmRniiwv/gzQ+tmtOQFzoEkqJ0v787Zn0kZtXT0nTxOeIF5x9qawGgA06qZMPqFaD8y3GV3ZBmpOuarejt5jCT4eXh2C/F2jo4XL0bSSCs/W93Dq3LRnz+WXIkKHpbrHVu9WelLEPYwadPUSQfvWzP+YTU9eQVCpDhhKsvCv0CXGzGDcp6OuVRFOwThLuCn96AauwJCHqalTGnYnqseSEw/1FY6fZAqrIyy3vrlMnjxLMyy+9hLWWUZX/1jN7wzlFLlqjHikpD2Qe5QSBn8xovYaSK1bIDarmiXPFcLT8Em34d/0pzWgDUyBEtKe+gmGQU/69gpaMWJmILL1pccAQnzhht8YaaOOcW7sAj+VcbnBeFrogIY6yI6sCvirwEEfaOctMUx2dMk8tjz8LK7IsTRVI+yf6aFSZhEnVhyC3Qc8EHyvS0GgfbudheKCGmXmVK1Dh4ceZKKFeTqxyDHA4MNf0inehanm8Vm843tCXtfkjtrj9JJ66kh5WZG+1IKtE5iiV+EP6A9BwbOcP2ih7R2JaLHUJG0weGYkHvKt9R9iGSdcHte4hkTmn6GiYP4lSLcjPn2IuTSZAYl1wsO4OCV1D12aVol64rFkmh8bno6/Y+fxhuJEBtySAU7joZ2YmzJ7PQI4+UxaidRVqeHHlBqHqk9fiTiHD+G94Z4ieDuVZFeRXg8DFOXhw/RoY+SHbt+9LWu6rBCQsjsjLZhxvKDtwrHXw9Dbesre0dSXyDuB+lxjYsrrV4gvWS96S8uQIZXLa60qe/Tp2tTjvLEc3iIc17DWY9UkdIIKSrH4IV6bdVt/B5/zFV+w76joWCzI85nyEgsTOSM38WXFj2FtflEJMXpHSPKzUwtMCh4hyPmFFNoYk5KBngR/9t79h0Z3zqX1zKlrf/ltUtQmEP2sxFNPAD7CweIo5FxuD3HnSK86b8fJFtr6sjsldRN5QShO70voFru
 U/9GVQ9h
 gD9dQVivp13argPNFy23HTYne35PBn6SdlcEUvivPycvDCQe477/3D4As8T6US/B0gNPDC1fOOd8Gff04lx74zGKA1KNJA0BeXRH/W+lRjy5L12bFKozcH0C4valp/Zh4AqNoJ+0eZfRVle7KKbS68QfPU50OYPIm1X4WKvMZ2GmLBauEh+HULCaenUBx2iWzAC1rpP/45gsmgjDTYBiFF7c1pzGNyWrs25badS92Hek55XDPG7g0w1pkO8MKZ1xvqHlv8YF55S5Zw+ku56tcyvF1+qbgUeghryHP3Hys7PdGkRMqKN1ysSz70UEt8I7CMX2EhWV7Ofrl4pTh8jPVcLUfyflLDE7qb3E8/vuLktF6+jGWxyY4nFDCWE7Pu9ddAFoQXr2sgLRloqbhBX00w3u7t21qHWyDVgBcxrlWXVTHOprfaOySqE0rG5cAmfnFEjoIjI+gFLBcctmQxKcNxcACDmJPTTgCDdOgj0B1L42+TXCQ70Oif9gHmxLw40mBqHPFTV9089xCO6X+ndwauxZj0Q2BGF/bEcRCZdHsO9w8YJwuJ+yvXmnRtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/init_64.c          | 2 +-
 arch/x86/platform/efi/memmap.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b9426fce5f3e..0e4270e20fad 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 	}
 }
 
diff --git a/arch/x86/platform/efi/memmap.c b/arch/x86/platform/efi/memmap.c
index 061b8ecc71a1..023697c88910 100644
--- a/arch/x86/platform/efi/memmap.c
+++ b/arch/x86/platform/efi/memmap.c
@@ -42,7 +42,7 @@ void __init __efi_memmap_free(u64 phys, unsigned long size, unsigned long flags)
 		struct page *p = pfn_to_page(PHYS_PFN(phys));
 		unsigned int order = get_order(size);
 
-		free_pages((unsigned long) page_address(p), order);
+		__free_pages(p, order);
 	}
 }
 
-- 
2.51.0


