Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27254CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39DA8E0011; Wed,  3 Sep 2025 14:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D114B8E0001; Wed,  3 Sep 2025 14:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B647E8E0011; Wed,  3 Sep 2025 14:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A352F8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65BF41A081B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:48 +0000 (UTC)
X-FDA: 83848853256.18.76B37B7
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 935A314000D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ktT78Y2j;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FA6weTM8vdilC/EIGooLzDUuRuJzTtRM53Ib1Pd9QnA=;
	b=NLtnpkQJ8Ojg/ztNnujMeC3peSJnI09T8AYAREKHVzVrEAtJokDGmwNEQvNdv1MA/JIOnf
	/QZZacIMDYRQ6syoFUXLcI9CgBtzT7cbExiQ10McMVhNB2o9q6/+AlsOht+rG9dPIsdebc
	lQfTh4AIf32WYgjbCz5CoIJv+aKW9iI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ktT78Y2j;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925986; a=rsa-sha256;
	cv=none;
	b=o8a4lNLQrpGsQcnpHU+zVSrWAmwxyxyWRh4IACxKj4KXMxBksBTYOIFjMisZ0ECdcKqquz
	Qd4PiXEcyWBF+2GxtbEI9TUL8pVc4W2g4VTn34HQ0AlfylppZJ6hxOROuFGBrNCM/PyDSY
	RQjPm/BgUfdfWCJkLs8bf+91hAXLhcM=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24456ce0b96so2501875ad.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925985; x=1757530785; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FA6weTM8vdilC/EIGooLzDUuRuJzTtRM53Ib1Pd9QnA=;
        b=ktT78Y2jAgRC86/1ohavx17jPdmDbcJ0jtLCZRMzH0M+KjYOqHa3mdcMANw4gDjKiY
         KRB3ZZBemVrGLlAKXxgkRYKX3EbUyzYKQxrMNxfPXe/LzZxku3Xi/fI+BwakXV1Onh8a
         j68NbH46dFoYgCy/i8R/BODuCWI1T1dOhd10b3rrKr8IvcsrNtiQWv204nIKwwDkGwHB
         pOcQ1YppoZ+4PzPfHOxmYSY0JzSx0+S4qaa+OFKsQAh9i1J/NgSjECcqjUsxkpWp2wGh
         SeTyAsWVeBCxmz8A+ppSBTOMwngeR48Aa2pzXSgr9Lz+yysfv3lYliww+MM+6PFk+7KG
         AG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925985; x=1757530785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FA6weTM8vdilC/EIGooLzDUuRuJzTtRM53Ib1Pd9QnA=;
        b=uwP6XrYPZVV3jRAgnhv3+0Z9oBQT339KcMeaKXTHGYdr9JQSLaPAKlpUNTQ7IZfV7Y
         /TsGPukvS77dJ1qZdw8B/gLwnamMu05Hng3TOc3Q41HXqWG7ZMO67w+HGKqZ0NiP5Jk1
         2KZHm2YwTwr1GFSacbGEYJVYBM0ub6YWlnLERiIiDDCIugjDLL9go+nlDQkJMJcX+Xh7
         tQzeoXzrl7OXQsJ0i1XIjkGJ5UFCkYMbz6LSpCi7ecLOZBuH6aQQnPWc0jDLuU49pjzA
         V0QweQYxyC56HNbgf6RXnLqelZajHNlBnQgqnmDt4492Wu4kJacRc0Else3OPA8O+3Ve
         NnRQ==
X-Gm-Message-State: AOJu0Yx3P8DYzIV3xud7RT/h8rieNYOXpxBNbN3gi6snojbY23pywRdH
	54X8Oddfr0QvBTwlBwkuZeHu05bx0J3iHf/VV3rhixpbSwDia5QJSroN4kThLA==
X-Gm-Gg: ASbGncunyXKuYU4s13dKq2/DP2/70tX2r7c0QEXw0iuyzor21F6a62YyslSSh7PIkZM
	ZGFh8tyQ0ZtN8FoWqCX1rzrHN21k+xWMJby7in778nxfRUZNhTmYCbAGQiL1vZ2V7aTXMdPVHUG
	0W5zIuiX8bOMu40Re8lU76UMYThkISh0bsDdfxPAMkgiZhBZDuoBPeIQ0G6sopp3kpPNUTJdsWN
	Ub/GSlukwOFZCDHmOyQmjWznWjP5H1RgmzxqrjGVanoCBdeTmcEg3/OHkqlZXAFMu9PMGSndgOJ
	sS2mzmSngs/9XllTbz1RklLEnRpvLNGuesruP9PYuUz52pR1OKsA/aTqq0cedSN2I3zjTWSwsIz
	ulGC+X7DqXkC+nskwNRk3dQTmJiCD7kOoAtYJ7KN+VGZo6K7Q73cfEXwNOjARm6Us
X-Google-Smtp-Source: AGHT+IFoYEL3/2HJDWoKxsFsnkPmdjG5vBre6hTTnok3nMNP8kBMsMcFaEho42lHd4bWFQ52X19GJA==
X-Received: by 2002:a17:902:d489:b0:240:5bf7:97ac with SMTP id d9443c01a7336-2493ef50b32mr219143675ad.16.1756925984962;
        Wed, 03 Sep 2025 11:59:44 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:44 -0700 (PDT)
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 6/7] arm64: Stop calling page_address() in free_pages()
Date: Wed,  3 Sep 2025 11:59:20 -0700
Message-ID: <20250903185921.1785167-7-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 935A314000D
X-Rspam-User: 
X-Stat-Signature: 4m5ot56e1c1kkfnn9zk7hc4u3zxab74r
X-Rspamd-Server: rspam09
X-HE-Tag: 1756925986-805977
X-HE-Meta: U2FsdGVkX19cUMlELE8i547aBABXKVFxyQTFvs+S2iPNLZBZmWBCcXYBb5VinK0NUJfhJPXt6dqgcxj2SR8yg02nLPFme0CdtnRMXfrL8ZQUiQAp+ZPdo7+CtHbwctsHv97sMhTB9e+QsiXSdX9vaoQp28DrhY4u8hzmPJ7O+LCcrrNxlL8xmTczCHmWZlnarZvhyoINzcvQfSPD9c6D4yO8qMNgQYqT+aFgCBT2mKkLRVGK6OOhEvoEfebz/w9V1dOOdrcZ/opHzmZgOExnMEqsFCIIJaKDK9nIeu3GBKifk6dCquIsdotcHrm+VcTd68givMI0kPH9m+WIHxgI6qKeihER/8Z8icKf8sRTDvN9kVA68y/ovlKGtGbswWFYO9BHO5btK0Ycnhp8WRfQNnuK7MvKFcUUy4FVaIQ3Y9Jv7x5S8gHguyoRNiuOW9DzQ4jUoZQZLthdiRJgY43UViHTsg7LMRkXepsMBvyv5fMmnY5xf5bGab1Y8JCIHHidrZKEjAlnaBN5tu8PhzlrPVTR/3yP04aEo6HP9H5cbPuXM4N8DiXhHHbiQ1ao6O2SYd6bWoO867NrhpxSjsFAqG8hWlrKiaK8FKCwHUMP+3pEAS7ltTI/jiCKwaRdMp6NfdPSMjPh2+JHSIEwYurnOPfJaU9x6018Oeq1RyA9zMZBsgQWekEJZXBLCQsVrmC4jVxDPyb/92mdV+0foi9wNUKd4peJnXes+OrSUR25cPLCh+vOe5JxO1+iwrjFR6/5w93asB0yc6AgQ49Kxjvvx98BQG5XBZLBjAwPSvwmknMMEsQWAuYYeRRhfYrn8KYoQTBL4g1KPVCGiveTofzC9caUWUUxVOXyCex/qkpxeuYDcuC8LDbWwOHz+R4gwgELRZLOwSUtWMY0AASncaSkxHwVwHK44gkrMKtgdkGaPRNFB8Z4iR7APXzicGuQaV74MzfpgzQ+0irU2ndOKQR
 NNvG+RsA
 CNP411tu/Jd0exfSDhIOSvW+T8xZN/FHPqJ7yHqW3g6OtW7UC0hReIpIZPYB4rohZMda00P/4u+5fmg+pr/JnU7TeqRA9beN7N9mLcDtRqv1SHTNXqznKCLkNQ5KpSfRupnh8/V9VNJ6OoY3OFgQIebPElGXK6k904Y64HpoK/vu1EKd/ViAVynLynRSvApH/sWAfUSJb2v0twR4GV94PgNstG0EAz5TeB6YOicHbnum6t/sx7YYA5gsxAKolgNC4D65VAEDE8MJz826MKQjnrx6Q5+c55vGTK8UC2IMqZb1m9POCyHoHnPQsEB7FcXNqKmejlPhXltTJtA1pnVlw0kAQV2Y/rC/12aGeP9Ip1v9DbaBTc5NiVeVdHJ22su/Hfyc18/r6T/prSxHaqXMYcDhElsilaAqa4XBvdQUKO+mTo0z80zXRfquYuYRHKev9uHQm0WATkvhkSZ2scKPt6UMblIRbFn+cbXOs0znGJYh401aM096sGp2GzR6fbn+dMdT6UlHgf459czx4e707yLyTW5KDCuHzdQNJdjxT5EZYooJX5IIa/g6/reV50gUNV11uWQXXuDDaFTRKPwQwVR4VH6eJ60+diWrRjeGu7pSguiZF85D20qzREg==
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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 34e5d78af076..e14a75d0dbd3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -843,7 +843,7 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 		vmem_altmap_free(altmap, size >> PAGE_SHIFT);
 	} else {
 		WARN_ON(PageReserved(page));
-		free_pages((unsigned long)page_address(page), get_order(size));
+		__free_pages(page, get_order(size));
 	}
 }
 
-- 
2.51.0


