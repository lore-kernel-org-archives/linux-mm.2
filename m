Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03CE1CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FEE6B02ED; Tue, 26 Aug 2025 16:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D3D6B02EF; Tue, 26 Aug 2025 16:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224366B02F0; Tue, 26 Aug 2025 16:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 091D96B02ED
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACA40B855C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:33 +0000 (UTC)
X-FDA: 83820117066.08.24340FE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD264100015
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sve9WKDg;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241791; a=rsa-sha256;
	cv=none;
	b=Pee4TC7R/ZskF85ImJU0gnTGmhxynbOHnQqNN9qiUSKvfy65lkpLxa/OwXRP4Jli4IJxp9
	EtNzV3eTypG0A2anuvA4VJ3QRDMDBh6TFqs4VqJdqPH3Out/3LnTnso/sJXg2GykF11mQq
	GcXjsoFodm/fDT2JL6Iz9Zc8aal+FO0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sve9WKDg;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p96JFKpspRPKBmH2rgBynj/gu4bh0EGooQeUZ0NhcIU=;
	b=2S1jIKuphkadmIY37lxCGh340AF8q1TtN2v8i02Z+5X/FUqPmEHZUyo0lwVc6xx3XZNups
	fo/FTu4weKxJv0slzDUkyzR2QI4/aoV0O8kWPeAN2H8cr3/Z5ndEYDV3n13G2oNzKL8LZq
	+81lZmnaQYYm56reeeCPs5OFLzZye7U=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77057266cb8so2368893b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241790; x=1756846590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p96JFKpspRPKBmH2rgBynj/gu4bh0EGooQeUZ0NhcIU=;
        b=Sve9WKDgc0Kh40Wc6WpRpgntZ/LGGJpC3P1yOy/enMYaCRbyQnNgnfDR8I2motWAD1
         sjvt93leMa0VBOMfKOrHWMLpGbmn7TxP4jVNV7fJYG/yHk5YDErgm84SNRmJ2c4Hu+SR
         z7grhFZc2nExnou9O2KkKInM815luwyugauuD2wAXlgygjmeUTyabRV79i619GnLWYLH
         FsIzDKzs2umA3EXqERFL/Fgvn772BAZ0IgOKwweuqanSlNTx/YKQrhGRf55BPKPagLaS
         YB9gyH+AQKuTDqRktvEDAqSDjQ8L/2L4LtRFsidLFhZ//sZRK5iyhjoxceBX2zpgRbEm
         nckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241790; x=1756846590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p96JFKpspRPKBmH2rgBynj/gu4bh0EGooQeUZ0NhcIU=;
        b=uV/YP6OV0EQtlsbMmREE3mmmjZi+GsXcI+9Px/PKcUEd+nAsVK7LAxRrDUkJVyL9IZ
         FhRPW67GUmz1GDZZ2V2M/00Z3SLypyX3bfNsw5KHGONL4cSRWUKuW6LSV5h7ju4PdRzP
         2HlJfRPAuJxPel3NNYim3mxio06d2EG+mfv5Mpc9VDLkB7Rg4EmD1DXzNYbKUbpdx8qS
         WND7GVQwsZXFni+tuJE7REdHH3VsNrmmDAF6raVkVUdvsNYUhny/I/BKG2MK1ngtSC9p
         2bhrCryaVVmE35f36JUD9XgPz0nM1rPpfVEcrlkg1h9Iws4SxcuFTLKpyjl7vcNoshqd
         ThEg==
X-Gm-Message-State: AOJu0YwS7R881saZ0LCzqpjIqfHeSTdmtCc/G5kQGSCAtVd06Up72hzy
	+rHeST+YSsS6ImffrEFrwXIvRJaGuG8pxJkvFXw2/hPuY0rjfPxy468RYa+GFA==
X-Gm-Gg: ASbGncvseiVTJW57s7nk3BJQ+URfCdkPQr/00jtfk44jF7dEfXYc6cGysUNVtkrLYUw
	RM2JO/w4SDAUdGVkPm4OIwC9PNyiJ3dlphEdCARzNUFOdVdxjjHarwJV1F6n2PlW9jz9zTR+nke
	zdbHh8PythbQwgJhhlAwYssrHja7lGjc5gChF9E23iFQFyYw2VnDCgjasjfeDkfdZ+tQMZW5NAT
	Qa+7Kvp8Joq7w2wAGZCBVk4MEKcs1zGLnpLSTeDpKQuJGm42dQlqX7VO9YATNXPr5AwJmSfxCuA
	DLJrdiPpoubHwTVwDAXklpORIIWkXLwfbi9fT38ytF0kTC6l45L41laSizYey2EF3iUnT960hl3
	sfyMDZaQwJ+eu9OYz4VPRN9caoMEBGyqassWWllKy7ciaNNVuHSBLCg==
X-Google-Smtp-Source: AGHT+IFOjLvK0nFgsEOyBO46ifHUqODgHu2tpGV0k80H0vvFtGAR4qckJwDeMLRyP7djf61/uqXYGQ==
X-Received: by 2002:a05:6a00:1387:b0:736:5e28:cfba with SMTP id d2e1a72fcca58-7702faa6402mr23492301b3a.18.1756241790196;
        Tue, 26 Aug 2025 13:56:30 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:29 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v2 2/7] aoe: Stop calling page_address() in free_page()
Date: Tue, 26 Aug 2025 13:56:12 -0700
Message-ID: <20250826205617.1032945-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826205617.1032945-1-vishal.moola@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD264100015
X-Stat-Signature: eqj8wm3q43rfjstgyqcnj8n3kgpibaob
X-Rspam-User: 
X-HE-Tag: 1756241791-641832
X-HE-Meta: U2FsdGVkX1/Kyzw8wljBzKFdO69jhUVIvArV0e5wbEuOuHX9AtIpQlVXiMCwBEfz6wzsmQAhxBncnc71txcpJulTlrRpV1mlG8lzJIER52Z9NwsiqIdXmU9hKg4vopn1i3ht657o2CDJ5Wzr67B2NIl64J/XxpHIkYe3byy2GbN0dM73XYQmXUfYHjHdJFy4L99I6hys24BgspmzNQDKbuQ9fMQhWjtW+wsjF2nGdRICEL5nWmWGI41Ah10tegM3dA0PKpwtVBb/EYRRGxi19zPDl3gQxkv6t5tL2lW1vf60k/++IH1vYleY9Zcc5II58dVeF7sVqa3+61/BlDOrF+83IpDvOmTRpGPNG89nHvSJ4cDFELx1cFTdsFihlPJatbNzUxekhq/1xJ4GtZKIWeZrSdhcsqxQ+mQRYc5zvW9KfiKS6HI3yrR9jft/EfI05VlRARExlamghJvQWSj2NJelobcCar+5y7/hpGz6O7AdJ6qmUgat/5pHCL9jYPwUFgY0V72SJ3M8ZGBLLcItr0OSh8ggNo/ZJ2YPz/5eXS7/MXjvqTJABtT5oUDWDgZ51WqvDdWDr7G31OmsztQ3poXBJnFaUzB30REN8STtQL+rfWljrOzY9qVFapzcAmp/bVaffhbAW15ZtdZX6zMorxUHNbriB9oXltRzkqdadSHTaui3A3P/YAX8OcXj96Cz/iHjHa5mgW8dVdSBMJw2DyHIDcXyu9oWYTMxRYz+TZM19uXmUVIS2IQOyNNpf2NRtL4PKsbBneWauTmaNoyRV7R+roHWSGv/k60a+SCMeBvqmHpYJETuvdLP7HHNwe9yvVdLAxz6mUjj/e5xoEPPV/r3DykLj6k1ECE7OcJngy2+vcLxCGYqK04IJzk+XWRTFeOUWjyGTk10HOZxQucY8GcJ7TXq92VAtK3gFgW1Xyf0nD/C9iDqWRrh5HB2IQRnchi6mVgDBoe3+yzd1Es
 ZbLy9H7d
 nGJ+HJ+ZCcDflK0hinAS9ATwFksLEqCZ3tIsHy6IFVXLLf7OKlRtycpx3ppzwl8RvRIWWs3SdL8LniOHuMlcxVtfDdlufdfINVYeDq/wZnG5nn+94zSO3fNR6abEzXch6mLXtrxCOrmBS15EtVf8qWJ/o5ohmSdiwNftOGldMyz2ZdGk+dBe4d1ZylfPmWjjpgE9lu/5vvnMYfBi+cyFwIxGEsCs6OqKa3I77xjKf7Mb+EfTCxhZ4GZJwD1otZFlx9bFKjf/KFal4PbXgyunAGJ39v1dZCWIGt7EctRwiWh89TdkWMMAHiLo2xMcmzjr4sILpBv8NwDWYNzT7s5sqv3ZIWvXIknqcq5HwvzRrqgJ1GBY12TzPRE3gp6UUobHa+EhSRUw0Nmy+wLvu9/fnzvhZBaLmubMo8NqB3VZKc8QWSsk+BLbDl27rx93UfA9WXpqZumkc5WBaSVPqxZ2RqqiVUYp0wAT9psos5Iy41pF0NtgPgMbJkhzL8brDN53hZqDlCFv5H6yB2IlFfj76SiWMD1tOUYMsEATRfKH96W6s8EE2NMYuCj9UnMTXGWRIntEoU5eKFqkuAqA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_page() should be used when we only have a virtual address. We
should call __free_page() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/block/aoe/aoecmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 6298f8e271e3..a9affb7c264d 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1761,6 +1761,6 @@ aoecmd_exit(void)
 	kfree(kts);
 	kfree(ktiowq);
 
-	free_page((unsigned long) page_address(empty_page));
+	__free_page(empty_page);
 	empty_page = NULL;
 }
-- 
2.51.0


