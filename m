Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30921CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A57F8E000C; Wed,  3 Sep 2025 14:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856558E0001; Wed,  3 Sep 2025 14:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0338E000C; Wed,  3 Sep 2025 14:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E15E8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:59:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BDCF139E51
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:39 +0000 (UTC)
X-FDA: 83848852878.06.6461683
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3797CC0004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:59:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HrtnUD9Q;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925977; a=rsa-sha256;
	cv=none;
	b=gbwfyqZNAme1AOlKIaEGa3AzHm0GEEUU5w6ngJfC2DFb8fCmyOis8B8QDttA92poyzsSa6
	VB8Q7LfMlBtVGQmArQRVYQhMuSdvXKQrr0YrLzn9mFiNjo61CDS7hdGKBpQh0mQTVdrNT0
	PNbrs4M+9snbnX1pNQWGPA2+MHLZ3aI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HrtnUD9Q;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cg3vWTOesz5aa5s3lECf1v2j8z5ZoWgWQOpdmwDONGE=;
	b=oOWU/z8slVNKl55wm7hYtzSpIeez85u31WuWe3uyMrHkb9POdIhtaOwY9qu3uqlJTMeQVh
	rKSjaHMsS3w5JY97rZjUSHCtYFJs75tLzdT4cazwkHz2gFA1CJFtHeezadnUWsAWimBihc
	MeQwFXKs917BZbaLuy+7yxF8Ne5VvZs=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-244582738b5so2245855ad.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756925976; x=1757530776; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cg3vWTOesz5aa5s3lECf1v2j8z5ZoWgWQOpdmwDONGE=;
        b=HrtnUD9Q3ixXtUptETXJ9MQsxYi3Kxis9PIBVd2IU2gQDCxQI/46+HC6xRh9Xaz89f
         dH/2hfUMyhSIu7C52xCCkHMq0vy7vBJqeaf5jgNu2WbPos66/9r/h64rVOBtcRkIRj36
         bq7dxbANLHj9OWwvOoMY9pKgp5WKI1fd0nrBSmkIyj3SXTF5IoGEkrhyUseP1vI2Izww
         DDMpyaSKT9gIJZ/JJHwWBTwUGxVjjCxILRgD48jBatNNe5IM9PCRrf3e8Xt+5V+qF5C8
         AEJAFt9QdIAkpUUl1xWxI+WAZKnPoDj827UKPonaH991QIiIJvolGSMyW12YCFJltU5j
         FTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756925976; x=1757530776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cg3vWTOesz5aa5s3lECf1v2j8z5ZoWgWQOpdmwDONGE=;
        b=vc8lWlM3hapHsQyWo8cbJG1vcBgAapK7DB9ymIU92t8VWSS49Pv6EXUCQat11mBjJu
         E4gzR2u4Vxm/Sh0uwhQnRB0aLgu5EQSK54Pg4oJPy7zbxXmH3L2ethIOrTwcxmyGa0lH
         gPl57foDD+Ywc08dvznvUaHqnQKp+0naLqOI1SlIt+fpUvKvAJ3wDH1M8OkuA6lOvzUg
         fSOevtlxSgJXJnVYiwDkX5np6Sl+A8j42w2uqhta0u0of+bZrtUUMsRF08HiKaroZmxR
         lt/cjoH5X8Hu/KMQNgVG4Am1ZNx5DQdvK1ca+QqsyK/oREUbn/MGYLTh98dddhqBIQTk
         9g6g==
X-Gm-Message-State: AOJu0Yyxp+uTLUASEy6OWZTjmFmJzSiqKHq5j4dtWVHmT/5cu/fKfg0X
	0IxwwZUek5T6b2pvHb4P6f1S+uQ6xdtoSzF8hdAJXVXDTUj0CExTSrPm1t/OXA==
X-Gm-Gg: ASbGncv69lkPUwhV4V0D4OnROBmVin6gBD7Aoi1iZp7Y86SFl8MvHX/hZBurC5zVlgI
	nVwIIKIk1dKihl3dvyihqY7mG34S1Wu5MZH3IBAqSVVFxfO3k2E0oE2/4dg3m3qbAmuK5N2PZXE
	Wtwa2zsOH1GU6TkDJbz+ufa9yVHLaNfFVG//KEgl07qkbkX/wPPAEanrA4XEYrwXvwrjL9ZYVMI
	MmwWn3LGWGdUzVw7ZaMM9MS1kp6kpxs35t9wzHYggbrz35hIxpxPRZZ8SgbBjFuq8bX6lLJ7o9o
	piUB9BVqCysBuXGxTdy0pwdQUv5eUgPVI3JHIR9bi1BMDMpRoiVgbmk7HJ4hvWRC141pgw2pzR9
	iE9GdT8bZMARD+PLRbX4l1vr7mVbdUec1TmWlBETdyhDvedv9acJ9PQ==
X-Google-Smtp-Source: AGHT+IEDGbdRM9mEhaV+2ag53MUmou+Up6hgUY2vpYZIptsrNmf4dFU9V5zvfqRBlRBpWDsd4n9KQA==
X-Received: by 2002:a17:902:d552:b0:248:fbc1:daf6 with SMTP id d9443c01a7336-24944ad55a3mr207897875ad.43.1756925975667;
        Wed, 03 Sep 2025 11:59:35 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-249065ab343sm169403475ad.126.2025.09.03.11.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:59:35 -0700 (PDT)
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 1/7] mm/page_alloc: Add kernel-docs for free_pages()
Date: Wed,  3 Sep 2025 11:59:15 -0700
Message-ID: <20250903185921.1785167-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250903185921.1785167-1-vishal.moola@gmail.com>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3797CC0004
X-Stat-Signature: xhgdir8ws4f6qa5zdh3dpiytc3tnqjt7
X-Rspam-User: 
X-HE-Tag: 1756925977-927413
X-HE-Meta: U2FsdGVkX19EvkjONDXMtZJ2xsjs2c2A/gpKggziKmyC5CA2nEvUzpuCEfmFjO2LtoObOvERwxxqaiQ5ckhLvV3yW4D1ywbpAUyfXp7fi7Jr8IsXgZFF9aZV7WB7QuaTZXg5typFSUfSjl/yv+O63QPqIDs+xNjQiT0Sal5ouhdFM6uAoDXxUmqGU2kQotfUULW5gBv6G4gQ4kg28f/yevjNcO9ucuzCRzhuZ5sOBz3goFYWt1QeFEX384r8U9NvizOLNPaEalLkxLQr+Ec6GB4WgNxTQW9sT0i/iDH1BlimxdGx4m8JSj9acYHiY/mbfiQGy33AVL1xOeEL8JUPwat81WMLVcfch3Xx/idiL2SgCEIACbsEpb9iq4MwruZOWYPfRHKBkKlVRgh8j0u5axxlgYu9zgE6GR5eSRYqQxjiUskIxphM6bduGazKUD2HTc7yPRYZFRwQDYl0fiCwki4PSxtlZwhFO2Ngs0ZS9Gf6dniil232U++q6XxZZKGJyrSDRaCzlo5OtxXMP4btemntdKhwpE+lAJlJUBofFJVWPXcK3fiotz6o8kly3KX4uuvyEvHeTawh9yd+eFJfEL0gVLDqVW/fDlmu+zIy8RdNECpFIRdAn2N8Qb/HMtxi8VTmmm2Qkh31LO+OW9/cPllHjuRrgVsiJU9ORGvPIJG4Do3iu9e6VB3t9Up3bYm8+g3Rlt8wdMPvBmiWMkkHXca38e46c2CZ9Dx22zOCYA1/dBfR6TJ0yLhjPbYMlfJ1Hb/KQAPDbQZRssn5anSvzkWeCNQJNWosZyXUL0LD38R+z6AEnhQyS5ug9dlKVpzjTLUrus6JAe3c7JMLY5WY474EU1Z2PYwk38PWFZCuUS6ayIzNB81/mfu8GAJ9ykewSDgmlmQar6aGuTTn30sR0DsplCl3ftXAsQ2g0n3OUoHTcb6KXNqmWdOHUoH8kkiTvo/E1eEKkwb33ZjtfEK
 LCEHSntU
 lDl/WryjT1cwZKXNsRC/sCAwGFTGQbQD6vjWQ4seZ20Kyp3byyvc8ZOTj7r0cIAiFeJG4m3/BRY5PTvNZ2e38QjGptXb6mZWCsZ/ul1SoGXP86DYMqHrWQMEAJadDDvHB6wj2kztJXQFAfSoZGU9HgrtrQZcqxfN0O/JUBLjmrFRiT6I8FexlfBz+lQ9YFiuF+PRud7dl1P2QLNPYGJSX+CpeuWg6+xLhaiyZgnxy46MqxZpYSgyIyLCsG8q57X6kOFbvCr7Ai33ELXs37rGLicvc0WR8nYIgNE4cNGIVxtehEkGmz7/XKcJYkKwFEwXJ4FdZcUuhcsO3Z31irIYlIdYK1TpIAZwfbeNQBwb1sNiRAcfEvsaSSFQYppGz+WanQY3LN8VO4GKKQ04iLtJB3B8uCSntF3U11wckYwPeeB5Nqpz+h1dZuOT6/d+2k5GB9uBiJ9Nuk5gLm9c+6de1xFbJCBBiCAfkyLUZOdfEHWRJ0opiXLsXHqG7FRx14sfSdP7tNbBQ0YIT2omwgTdG09o0ij1TDKqmphYTnLJ1YVR0d/ZdWHqbE9FeQKf6pwhhP1nKpunbzCfKFoA7VYp38owOrbwFGS8lLz9162BsFr+7PNy/yoYr56ZsqOEow+jwkuP/GIn9TIJOH0s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kernel-docs to free_pages(). This will help callers understand when
to use it instead of __free_pages().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: SeongJae Park <sj@kernel.org>
---
 mm/page_alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c2a254d877f8..0277b86b62ac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5269,6 +5269,15 @@ void free_pages_nolock(struct page *page, unsigned int order)
 	___free_pages(page, order, FPI_TRYLOCK);
 }
 
+/**
+ * free_pages - Free pages allocated with __get_free_pages().
+ * @addr: The virtual address tied to a page returned from __get_free_pages().
+ * @order: The order of the allocation.
+ *
+ * This function behaves the same as __free_pages(). Use this function
+ * to free pages when you only have a valid virtual address. If you have
+ * the page, call __free_pages() instead.
+ */
 void free_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
-- 
2.51.0


