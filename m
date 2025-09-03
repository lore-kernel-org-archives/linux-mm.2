Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5CD1CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D5F8E000F; Wed,  3 Sep 2025 14:59:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375C18E0001; Wed,  3 Sep 2025 14:59:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2168F8E000F; Wed,  3 Sep 2025 14:59:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 107FF8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C794513B4D2
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:44 +0000 (UTC)
X-FDA: 83848853088.05.6BC6656
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03E33100013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+r2lmWG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
	b=ugubLGnC2y7hFIzrSvaYkiuITQjYYhL9SuYOYpnNqZG7Tbnuy/pj//LvXOL9sUOhE1Ezw+
	S88VWIr+FuAIbTh1s9KFKZOX30di+VLo7AkLghCZYw5bsKzr+4RVjYOvxkdosJ/MClkRKm
	/QahOmAEac471wvD+3Wj/iqKixKZ9ug=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+r2lmWG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925983; a=rsa-sha256;
	cv=none;
	b=wmc6VM/k4Rf6MQAmdCdmgFMIMUGSHxMmSUvKolA5hbemI2k+I7DA5p39I1Qk93nHgMfg4t
	WljhoMPD2FJPMVpbBO6alv4hjFg05S2AUub1poOphGiIRAXJ+CseQspsSX4J/NP4S1mZ7a
	rIxPhYRHvFQznK+sdaKWSz25S+i6yRw=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24c89867a17so2865955ad.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925981; x=1757530781; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
        b=h+r2lmWG706l5JZbGqSyrZXhtAOJ/MTB5sYKstdzHZhu6W+pkWQAiEwT8GcYu6HkMp
         jm5V1PJyj1DleVI4TLY1eq0aKcV9MVgRVidfOcNDul4Wqvl01HgdXfEbo5iLazAkj/+M
         eRw3IWBM35iIZs/R7Xz/4ryn4rYZ57BzdESATJCNFB+fcu0g3I4Mn7CXW0n8o53gPCr3
         igpd9l2NNkWEhId2L9d1qgKUbTVC6xB+QX0L/tMBzQ6SeMwn7U1GM/VBA1WPxgJ9MISl
         Q27FbYtsmKU1FzHDv8WrqgqivkWZguDxn2pRnGH1/bD1eKIjY4NYqsiOYWKYNHKDur0O
         iSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925981; x=1757530781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
        b=BkpPYN3Yqsb4ljjohsiDlgXYlZJHqpTp0N0FDNvySIjMYx2s1cfnNGFBUbleKHGKj6
         Wkqiik6WrL2jef63pt9h123P8E3dsYqYs8mF6jgQ4o2danQAl4L2Xu6Xvst45fn1zvH6
         k8Rx0lDvbYPFr1JAOeHbPYuc9UwucjYp4V/hHRlAb3vCmGR7G+yD9G6DE/mij3oFkbFL
         RyOATYdX5v11Th7rN9VVcZeb9Gy2PeamUHThzNtZRgllmuSymiqG8gRNv2jb7d9UAnnn
         8GT36kvj4ST6JgmBdwFV8zcBCU6SrkmJugEsm0dPHkRMS8bzdWmu53JGF47lgh5l5eZ6
         MPww==
X-Gm-Message-State: AOJu0YwTvl4/wmYZNwp0zdh5FAgvAYVy/+oQVfwgsoOIp/gomC14DFft
	0O6qBXuXMN1Qi/YTu9g9P/8LI+Wr3NeI4HDiUkUPF9wfUghopZq53oUMQXLRzQ==
X-Gm-Gg: ASbGnctNhMiwXcg79AdvwNsZXAJQSW6rqdylxXrNiV4mts/LNWuM/w3ia3KzuSehNhi
	SGhQf5TPM8CllZHVhNZISf1kBJpYMWpYOXlD0IBRJbooyiQtjai7GsGvms3rI7jbUIIogNmIN/E
	tgxbvJBAPCUcls9T3KZ+pHswecfMfhgOVRPT34ddwIAJ7yhmfyFjGnWox8NH1QwDMGiW5BXB7s4
	70MJ5XXB7VlAQVAkIJJxtTrLQeiB7yhcnWNZWd00BW4CPKZqxzA/77jpki3bDUQIUFHK748zKs4
	LYg+Ke6hnQJT+MeTH86anrZaMh1ZE8J0R1t+PUiL6g44+2GYaq8FJKXaWCzMs0IT0D4CUoRiSHl
	pJIzQOH7KiwJQ/mSP7q6znO8VSmpeKNG9LeYsgJo88JiyE4pYC0i75tkmrNS3j+FN
X-Google-Smtp-Source: AGHT+IFOzZVS9DP4L6Y226muKjeIB1JH5DNA05hxxzbj7ORa/S2amssbHzjMdMYqRSy3xMpxXA++JA==
X-Received: by 2002:a17:902:cecc:b0:24a:aeb6:f1c8 with SMTP id d9443c01a7336-24aaeb6f63bmr166407785ad.43.1756925981346;
        Wed, 03 Sep 2025 11:59:41 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:40 -0700 (PDT)
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
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v3 4/7] riscv: Stop calling page_address() in free_pages()
Date: Wed,  3 Sep 2025 11:59:18 -0700
Message-ID: <20250903185921.1785167-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 03E33100013
X-Stat-Signature: c66b1dcscfxqk9uukqkkkxngzrsmegeg
X-Rspam-User: 
X-HE-Tag: 1756925982-792120
X-HE-Meta: U2FsdGVkX1+93BuYEr9zsZTY6RmAdB/P7gw8i8z6+/v2QJ5nwYy0irZPToid4E/PEvKwQVqW8OXXh1is9n5Qa6oCsRsXoffX+x9sl9NqVazTP8HD5rAM2nEkWhle6GojZrSHZAO03+/bBetVr/aQYxfXllONxiyL9ipli6tmLfHopjwlXSfEHjx/I5LMAxbYL7ObyGAtUS7/LHIt+MtYJDLkGI/2y+8M16C3q6oBhw0TOpV3UAzFMe9Tu0/TyFaV6G6uLZueJeKmQG+GdIe2uVEpYw5jXnUx41QK+aHcD1eDqsPxVJ5kNsFs/ZsZnF85pELoxJVfG8RTIiybI7y1bq4Dt0cyjgTOMjqkiBn5BJCTR/CfHhsOGL5WS+aSHpb5O/2B7xOW/dLWMzUrAoIP3iOhuoMbhvP1UMVfwOYWZ7FMuZ551IO5/iWcPlVCs3YaEbz4GcpmO6LBuY11QUi6+gj4EtTOBcD3gdeUfXlC4T3GmOWpmGVaonHto7eCKoumJMc5e8iHgSMglmRyl+idLpFlQzleMM/Di6GGay6MMWK9f2RabrxJyeEm0KaMyBduIrN0wcglM6Q5UwapLMINla2mLEILfuogNAzK5OWMHZHU6qeU6QEOwPTfyLWC59oXWob7fHnIAmGKLRDOksb9GG+vXUovPwL3ULx7+TaXNLFqjGY/yvkitba1SLQ//S14qgwWmLVE1NoqN56yjnQmJd4rt0N7+8mOWKOIHa1ptRTzoFBpMJT3AGhD6TErCTEMCH/0MwM0aK8q/4gd3ueetvpfOmSH4ZHiviREQvTmzyrcIMqUpJVkrNNvtq5pq99PzCsA6oildqUMI9AyjC5JnPfKyCdJ36XFGFCHBVBMdwLb5bXOshJOC8Wc6FKbTJKTK+g1AAGNay99rmUpBDJP6uf613C54MJQPoQ1sd6mbBk7IsNPtlHotEuCD5gZElSZiI4uVFbfzWloBvDRsJY
 dUly8p4q
 n/+nd1qNa5e2DqXUC0/DEldl3rPINr5uFwpu3O+DjbabG2B34Ew5DHWhynhWUoLgtO2tmBtK/FgoVCRyAM92n4qwRG0usj9V/fGXzplS7wHbknCB66Kvg1vftt+1QzVrkQ/GQcDnC0mJ94EN6MZJ2DE0maAqBOAQDQU+JzVaR/4Xzh+GWdM6aHKOYZ9B8DjJgo+AvCX5P4XDyrjQmXE4Imj1i9caY97BT07D5FJkB6bsBcNQ+6B5iETslxgXdpOMaKhB0C5ObDy09+FYEeTPr8fmAok7hgY/5K5RNTUWhYviRB+MCLdf4Grrrk78896WKp5OOYkdinOvE7GVWTnhIIdIDfBo+Z2Pvf4xWMsvIEDJnjDT+RpNSM17o47kOwFF2AtiJHHCKQjSb9XtJxJNJhAuRCEkQZDTvo1vJKr0bQdUSytShGJCLI2A3MLBK0nf8hC8OmT22fEF2SYNgb+H93wUuq5143ASAcZxSd8lmQPBbS9lGsvppGz2AsO1CzM9RbXp/YgR4ofu5DxzyKxQNrSiTxCAgMPfhI0HqU7mhnnUyN43WDy90phlBHA==
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
 arch/riscv/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 15683ae13fa5..1056c11d3251 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1624,7 +1624,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 	if (PageReserved(page))
 		free_reserved_page(page);
 	else
-		free_pages((unsigned long)page_address(page), 0);
+		__free_pages(page, 0);
 	p4d_clear(p4d);
 }
 
@@ -1646,7 +1646,7 @@ static void __meminit free_vmemmap_storage(struct page *page, size_t size,
 		return;
 	}
 
-	free_pages((unsigned long)page_address(page), order);
+	__free_pages(page, order);
 }
 
 static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, unsigned long end,
-- 
2.51.0


