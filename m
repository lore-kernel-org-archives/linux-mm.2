Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50876CFA761
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EEA6B0093; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B540C6B0095; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BA06B0096; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D26E6B0093
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4416712931
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:23 +0000 (UTC)
X-FDA: 84134128806.23.21B0594
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 566B11C000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZHW82oM8;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763718261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR76LDUlgljjFtmeZJWHqW4GDEs69WYJSwA05inS44E=;
	b=7zJnPmd0Oxc4XkN0k0VIlVR/9356+2H+sphJgG/WsQdqBeWborqIfQMzyHpi3jWdGvXziy
	+FurtE5Zbk1pnuam0UHD7hYsU/5TdkBtkWeuBNYlC14OvWmyxE++cJGvhVAFXRGXvrsE8X
	YV2A4IrPsT1mKsCutG9Ho7aRTLLfBFs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZHW82oM8;
	spf=pass (imf21.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763718261; a=rsa-sha256;
	cv=none;
	b=Sk5YzJiXD7oVo1yoofoN7Yy8hYfurXICF7PiZ8tOYy2m7ewsUlNSn18T4Jy4nMCfC/Qi3y
	gINUSasCDBHWU30JgI2YV5dKw9eNoKAmAbG7ISONAFEbxPRjKDQwV+FYD/PHQjm3ZumO5z
	gDHULXUe2Tvb5Q6/sr0F3CWbiRug7NY=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7ba55660769so1665065b3a.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763718260; x=1764323060; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rR76LDUlgljjFtmeZJWHqW4GDEs69WYJSwA05inS44E=;
        b=ZHW82oM8MF3S9zs+Y4iGdYsMsKs+YUEhyamMhwbe0OjCiBunXp/mXMGAR+0fnGhACk
         W7ZwaVTLcpo/Sg59P0f16CwJJ5XKESz4ukRe5HN+n4kpawP5aeQvmLR35WSaBHJxo6nI
         rIASBAA0ItmcjhVnk0kuJgP4iG0aQZCldSXQd8oYUyZuicFaW7RplIlo0QFsc/naWKO2
         hLM98P7U11mwzwUnU/Nsr4O1LtwmeNl8Bhnw+6FxtVEitVVeYDMOP11FpE6rZaEmIZiI
         iY4lVVQcZFrKaAtjkKc9OeAZqaUDBvwf94JO/jmcHoGSqvl08HmAtjDosi8AXuz2XSkS
         O/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763718260; x=1764323060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rR76LDUlgljjFtmeZJWHqW4GDEs69WYJSwA05inS44E=;
        b=kRZbPhwvmP9Z1vF8J/pNeFiHHscV/HQxPa9v5Zniu0G+nCJ9cIMFunC8D39G8/EZJG
         bzAoJPlaf/mMeaYTVDodqWQ8ujYG5TG3AhftWwjs+EglCd2JfP9VADvh0Df07omYDjZU
         Wn9kIXTRlb57Jtd4d5yXuhxhbRgB5Zx4LpXwa3ujTdbgiJdOX9gXzIswUmE3BWJe7s2c
         yuiSvAevH/oVK8E7lvtkfclSy8xBrd4279wNCEifVchqglcadE/02VwHGpFkibaLc6Yi
         6+wFQRfMOVbkr+V7EhM6AIFKOoxW0iVO/b0rxcepwm87SFcUG60AbAuW7I0IFUusQlB9
         UHfw==
X-Forwarded-Encrypted: i=1; AJvYcCUDkV3Y8xDwv7scOcNFc0oyiL8ryy3MKpTRj0gAbl04/KbvGWJlV9MRNvxV4mfm6iAoiQmSN7uLSA==@kvack.org
X-Gm-Message-State: AOJu0YyqV1tenLM/ZtlrRbbU2V8Ch5EX1GQ4TMzy183sk1jCLrRyJpkF
	QP9oiWbHHlDU+1pVrNwn/3+19+R13JjfUu4xa+sQkt/52hrSj4yrKgmS
X-Gm-Gg: ASbGncsX914WIOdVsFxQLeMZt0gb+RiuTHNWhcve/AcCMA7NhBPCP8m3jwweswkJ4Cl
	bQY5XQzE4vgf2OjRJVpUMT57koEmrJmNh6CSlU9YXIiaL/+ba6xrC/marRxj7jQRMOyQff2ruhv
	42m/XWH18QmMH8FZhcbHUnc07HFtr9NjFUvqFF1GiAMztDxxCKHknkQVIsUaq9hrM8hJfot4c3j
	kP43FLGEI3qtB7ShI9vjDbmndi2bo3q5B0x+eCAtxz/pXchTRLT8uGJffseeQOWCJIRACQ1rJPK
	MDBv74dI2mTW6S2YInMgtu4BUDOEqiCQsNPYwPkMos5vbAPxwMcZz5VqI42oOAE28kGrRMHX7U6
	t+GNxr4xb7oGPX0Wwi3GEA116Kn72vO029hDSOW3yXLW6XdY/pUaAhJOJYEf3CDl/QXdXYF5RRX
	c5Lg5SHD2sUfSx0BPyfLwtEQ3N8XLewthlPSmHp0ajiYk=
X-Google-Smtp-Source: AGHT+IH8Rfm161fYnb8pChR4FoT4DA0B9N5K/FBAFCXimEKKSQ52cgwfgaH5ut9vblEzc3P+V4B2Kw==
X-Received: by 2002:a05:7022:f691:b0:11b:94ab:be03 with SMTP id a92af1059eb24-11c9d811fbemr485992c88.20.1763718260030;
        Fri, 21 Nov 2025 01:44:20 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11c93db4a23sm22430736c88.2.2025.11.21.01.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:44:19 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Fri, 21 Nov 2025 01:44:05 -0800
Message-ID: <20251121094405.40628-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121094405.40628-1-vishal.moola@gmail.com>
References: <20251121094405.40628-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 566B11C000D
X-Stat-Signature: 89sqwdjnr4iw4xmgtzqjssjgm5qetmzj
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763718261-648879
X-HE-Meta: U2FsdGVkX18uqeGIycbVZDlYhSgmNrCCpADLXQfdnpd2Ej+towRYcSD7pA1hF9FcXUhqic1BZ61cAddwITI8e8QlPKdY+pM73CNdXyEQ5+lVNZkA5jrr+L1w/SZjI9qa+Tw3Otg95wqWy4A4Wv3BUVP38re4YUjIN1uTNlq1r3EyhVwZ+P/LPKdmKQwKLhJ6loUVqmDCNOmWEIsfUMBlN6T5bnPZmAJJMA9bEOOIJ41RDeP4kTXLRF7OlSaiIvdLzolcW2tiq6SEhXSEY+13BqkST32O937SSYIVzwtkCg1g3/stpK05K+MWSD4478kvJ3EQepnW6PYCOFChGjNfzFkWCLXX1y6s1Td064vSaLTuOWl9i0fZp8B31VH1JuE9Rcetqootuisb6HGYcY81oNuOijloFKbj1dP6H5p4KPv0RPFkKr5KQZgDPlO0J13To0MUimmVVmb9dyfxjQibLUsBDFxDEduq75QJVjTVTBjogg3fQ4vNeueCdEhyYVGdvPoK2PLcYz5vszPXWKCWhc1YZFF/iWJ2madUuqBIl65/Me3BGOoExQoCX6gN1MmdILFwfiM3EvpHVE7NgD+dh7qzui//Ilnin4p8LVstaoVFNJyFHEOeKCygCpmC3n5uutrkLNfkIgp7zBsbJxT/mJw7B3N7hV5ixLtm7ovgb33gS2ulPEXjqOsZonOX8bHa+j2bZrcxZ+XTuxfKu29Qc0TMSZgiBnZ7mjV/nDcHB+lPFD3ob3ccUjHaBOqFH768GLS8O2xivvhwIPlwguUghBsp83novRyr+zT/Ag7U7LcwiloayT/6Ipj2S7a/cQ/xjc+o9v6JdxnVmJeBqA57Ni8WMQWoxkQmNHNtGyQg6ItQ0u1daUOaZ/hTHYRzBaJfMYpKL2l3e0sSSXWNBRChjZU1LZN5yEir+6eFZ0Nim4lBCP5jLkUTv4WlBPsLyX34Bzua2YSugaAL5wF7qW0
 oSfOM7v3
 v5bCwOUzJdgVqOhExI53ZVh1SsjrBHtZ9VU3yga0uLDrbrSQLqTyyilUhzEwZmOIPkV4pB2Fdl+r3EoaaRZ4nY9wVQmSkPZ0F0hSUgc6LiD/4o2vz9OEWrX6+H7O5VPSQH2A4qslIepXKcWWstriPopL95VeL1QEENIPdgHEY1etNlyUYTTAh6XiG2x2Dt3TFB/VE7mJJ3kh0ya1pAc29yEd79n6akYCKaTdqdGi1xIoiWjJf+InA+TOLQwOjPVJkBmxw1Nm+ikRshZAOs4Nnj09nMVnq8iDoiV+23AwpC1URmz5c/DQ102Cyj5h9qPVhKD7PVn6wLWBjfqxGZCEJDib1O/Hl8FvoqhNW9J3L6Aui6Ti2ROAnCTddHzS0WTV/lpu5dOPsaQb0JtcEjguNleg1DU8GDiQDdxzT6SptsXfgCT0vJ6QGBmU9ff0b0PuTgP1bWnbp/189/x4+ONZvmz7uINKydRsOd5ApbuCOJqtGthiDi8gj2E/ewIOZgymCLqdpKxEx5G5y5grkcJSaLW8wTE1OBNG9czKJFVk0ZAusxjAseJNJaakJ6+96y5NmMYAquvNtB1lYXq0WujOJiMsEK9jwAbGM4mhtGfCpuHGznRJH8ABsbHsbCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
this mask here, remove it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
---
 mm/vmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 134f615fd3bd..ecbac900c35f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 
 	node = numa_node_id();
 
-	vb = kmalloc_node(sizeof(struct vmap_block),
-			gfp_mask & GFP_RECLAIM_MASK, node);
+	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
 	if (unlikely(!vb))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.1


