Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F63CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7518E0010; Wed,  3 Sep 2025 14:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572FF8E0001; Wed,  3 Sep 2025 14:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECC48E0010; Wed,  3 Sep 2025 14:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 182728E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C45E11DD9C2
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:46 +0000 (UTC)
X-FDA: 83848853172.25.BE2297E
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id D989340006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/aa//VL";
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXRq4apmEamZdvq2d1xSOZY75J3qH8SSfCfS4DJoIVY=;
	b=HbKU7ryYyyTTIGQ1BVapwV0t4CbY84D5jbSvKsYxtzdJflDV7E5b9fMZEm9NKB/0tFyAhu
	8GQ1qR5xJmND9Pb9E/d+ArqoY8Wwd8nGeJJGPBdvs0ZFr928Ltt+uc7U+S7mkxLZbp7b5j
	IysaM0R+VxKwkf6b6Pq+J8LL2ef5Ug4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="l/aa//VL";
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925984; a=rsa-sha256;
	cv=none;
	b=iouO+7Q+JLp3pqqq0x3kgMAI40ez5aiztaVxsxo/K48DNSIV/vmf60M3K8H7TwhR/CkV4t
	uXOaQyeohhRv2iAftNyFsvcsJAbhT7Q1Wgj6CPa9BeUiREYEk8IIUw03V27YIBI4wgtBtB
	w6NU4qePHMMh+5SoFGDmnKRXic4URqA=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24456ce0b96so2501585ad.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925983; x=1757530783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXRq4apmEamZdvq2d1xSOZY75J3qH8SSfCfS4DJoIVY=;
        b=l/aa//VLF/jytnzjBD9xCje8gqtlWQfqXPziB2NtcfebjX2RwYsX+wHPqL7ybDTkxG
         7HsrHC+N7RzYthl1fgR9Xq6T9Kz8j1VK3tqNJ9oJeoxSvH+1kTU+YCjI86QCn6cwYj8N
         /uzbotHkMzB+uUy5/qHJZcvNWrdiy88H/VL2WBVlzgRakuhsLx+NoDxZ4IMSpiHM49qh
         wlNUPVt75N0FWNPPrstoL/X1oLeyRZpUSLKzXVwINAhmZ6JyFrS4LlXZMVQMjuR4bHnP
         0xhl9hwYExjO0nCUHvg2oCBLopmoXzGqBJUwLnH6s/H5m2bGAJNG6AhqMEldWAi1eBmr
         u1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925983; x=1757530783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VXRq4apmEamZdvq2d1xSOZY75J3qH8SSfCfS4DJoIVY=;
        b=Qm6EJaFrZ+U4dub70VZfVXgIHYq8MCsQniVDA6M4sTW5QsOtBLFiMNi9vOpjfcU7X+
         CMxoli1ITxeSGeJI59dQEk4uoKfbEUKWl/Ymt0C+dSgSsntRv1XNpA2sQRA660ms37iY
         +H1CIfLXpmJksW1WnKeSyRIJ/E73pp1ETJnOZMmzqR32+j0Tf8eTaG8QiybCp/aZ3mWu
         A2RylXYTEdZ4ep8DqesMFHGpxKiS+gXMbId2CKkO4PEVWxcqD/rZq20cCnqZuMtUxwrs
         Z/DxFFIQpTuPXOgDCLAsA5sEm3y7Pqzvi5IuafYK5ywpQWnuOiuEe9TzTHHtagwwcAZ2
         CW4Q==
X-Gm-Message-State: AOJu0YwRss1nsMDQfYSMU/pGF8HfrqDX/0rR+EXW29DjYAvtfj83xqlJ
	JHdmRC9x5Fx2MI0LrOoan6zB6ESEh6brnot3FP6P8uD32RCXjMR0P9Q1I8XkKnZL
X-Gm-Gg: ASbGncutfJDAGH8Q/wKK4ywpIzunCJSJUdpCOJLCzji9T62vZ5FVzNQ6V60dyX21lS0
	wIhj30IbIOm76VN/qThmt+khVZzlxxrsUWQ2JgsCySgceRNs+Zy9yCyRo5p2J5X7aK+pCJNbJz5
	Cgc801pYEA07P7KY3h3wcDgNjMoEK1nkiGMv3uJWEXI5Pw/KxWDE2wFwU0VfzfAIQ0RTeUHGk/N
	zTmK+n2KzDqsFdDNDoHD6o01uZ9kRXEfo0ZrLhPSqdDYXNX5iAS5RDL6E7PQBSvYpaFLCN1r/2s
	SHCW83CC313VGtXjgX3IxElvMLhHnIixy3ttvtPlMnSJnKEexjazairkXUtiqfLbkn7C9zSNIPj
	mWUGZ5vrx9DiUd/1Xu0oMChZpbfOseKwl3aEbyBkco5mXGh6fDejFO6DKIfCrIlbizimSvpFUb2
	E=
X-Google-Smtp-Source: AGHT+IGnOdoMz4pWaL7qXoMT+R27TwnQ4+tCeRLJ9HFet8fs0efEGIfh6YbGSI9RHeToTjhpbJgt1A==
X-Received: by 2002:a17:902:f688:b0:248:aa0d:bb22 with SMTP id d9443c01a7336-249446d2aa2mr226131105ad.0.1756925983252;
        Wed, 03 Sep 2025 11:59:43 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:42 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	virtualization@lists.linux.dev,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v3 5/7] powerpc: Stop calling page_address() in free_pages()
Date: Wed,  3 Sep 2025 11:59:19 -0700
Message-ID: <20250903185921.1785167-6-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4gt9i64fjbqzpaas75a11y8t4e7kjx58
X-Rspam-User: 
X-Rspamd-Queue-Id: D989340006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756925984-516574
X-HE-Meta: U2FsdGVkX187F1CdBlwVglk181jlCt20MXNY9fEGpYXBJYoHWwa6UhGOHAVmpaGPaldeCCi8rk9APyCb95/g1Ni3s8VkmwmJrlGbAhmAcJ8kqg70zlmW4tviTJ8wLlY8/dBwhULuNQysX4UrmnHhlriCutG84jlCh0Smnkb5TLh+oIMDKkqU5lK8+0BR4aLUaEXhJdraKJy5uS2FU86S/giOfu2Dx0C2zU5XpKg9lE1RuiVKU0kTXNPx/FaYmzLE/AyyXVprrblprj4t1TGeipK56SAJh+TnQNk7U1uCyzlOfxxyb0ER6qRPSOKluW5jJF5kdEszmPI1Z8xelsRrG7oeTwrCVJoU4mLMiL/SsoscbYF5r6YkudJhum7iRi6ZaJJIAaydoarbDnYIRyHWAKSK6DpCjaDVkE2aFUWXSUssO5PnreHiAQC+XQ1CYs9WntL6R8p76m77yiujPeXpwheoRY+ISW1ATR3mM6YEt+1XRFZX6+yAdJZcfUkvHYCSaeEGBVb2tTezTpJNf3dCJ7dLR1givnDgjtnJ13UbO8Cq4AhF0JXdnJWP3STDbIPU/y4RgBswnsahUBhPn6njMqd0lVXj73u87hmvRQPUeOtPtVbGWSJuwrdQoS0hBZUChwNPvQ+vkdTc+tYAwHtP+oJowsbmM61jFQxEdVQJ/WRU/W/HFcHu1SP9WRjTnydgFDL+/RKK10IzUqnrc4ZX8BzfolORG3q2/kU+F2fRKK11cO8rHeghWy9Q1uHYY4ON5RX1GzLipio8PHKPFsczEpq0Z4DBcqma5jEuIvKPCOn4KoC1AQeO/uDFuZ10rM83qU2LYwzWD+TtNfp9+I5nY/tVxED5/XbBd5I2seI0EYBMQrlcrWOmWTt0s8kRXGPyUYdkuNdYp/sY5oPPRctIwTDg3+anwtgtuqIU3UWzE0ZusiBG5Orjf1cEgAi+hEouTMYatDihl84XQuNRaUE
 3EQ/Iok8
 twTJahBMXJb0VVfdDH55pmHzpfWuJ6Py45yYSYCBBmDX9cw3XlepvoAyy20lEMSOcJ+ErlJyCZkhxF7s0TFs9hI8ztKOE5HSN5W1TJUXSLcAs4dfZeGm+3FO6N4kPxZGh1bCGV8HnxeuoCcGuowgSZn9KlDRWZ3WlCvJIjlzJ5SW8SGklzQn4b3NkZiTEBklB8GTE1qoAEGSLA3bS0SHoTQGMteyBYzPwYFWgicWoI1KiEW77kmi/q+FvrZMLuObu9cSlBRCIiCLbZ2mtisbkoJH36emDfwLdTuOu3yVzRBG8OMsDL1Es1GW+SEJmjWstEE8vBDakuz8qPPgoyhtVOCrOfeZLp0IpmKt4+CAt2T03JpTD9oSMnwKB53/Vt0Z0MSKMa5qJ08JNlxriSngYEd/m8mr3W6Q9TgndyaM8NrVI3+j2mfXUVPlkakdDWhu52ZBGOEn40vVQPKuKlBMZy8xbt0fZZa6DA1Xa4b010CehKGSscRxZ2E7mPzcw8M4JLeIjrR/ran7oMkvCmpO44O/GmA==
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
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index be523e5fe9c5..73977dbabcf2 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -780,7 +780,7 @@ static void __meminit free_vmemmap_pages(struct page *page,
 		while (nr_pages--)
 			free_reserved_page(page++);
 	} else
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 }
 
 static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
-- 
2.51.0


