Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94A0CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F388E0107; Tue, 26 Aug 2025 16:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0BF8E0105; Tue, 26 Aug 2025 16:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE81D8E0107; Tue, 26 Aug 2025 16:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A50298E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71AE5117A51
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:38 +0000 (UTC)
X-FDA: 83820117276.20.7AF0C96
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5A16C0007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AEMYanw9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzlN+dsEa0DyjaimvacceBZBAxpbehfow7bvljEAvnc=;
	b=GDSjC1IXH5iyqqBfnsCsgRnxabB6X5aGysLB43JqWHp3VAYlVONq3g8RSc6bEEDe4ZF9Tz
	IK52InWK0TJreoC1CxOPpsBCDaQ0jHuS0ZV9O6ndmbp9uTmibiYNcO7erv/QGt3h0FJFB/
	lZtTHeF9INPunFYDydWchTgEBbjjmag=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AEMYanw9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241796; a=rsa-sha256;
	cv=none;
	b=P0931SoGhXgOJ32VB9VTtqtOImLGknVGtlEhBCGduM1kJ0NNow+dSzV5ZjYTkal1IcRSWO
	JfzgWZwyw0WN9MbkLGRc1bCEVoXndrSkJSgyAtYtM0Dmf2WcvoIYJ93s0vvhQ0uAoFmn2N
	lL2TpueHqEtZgsj5I0zpWRtJNPkUG/Y=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e434a0118so7084328b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241795; x=1756846595; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzlN+dsEa0DyjaimvacceBZBAxpbehfow7bvljEAvnc=;
        b=AEMYanw9GPO6tvT/brZj3jOKkudAYWUYxIN/MNuXBHvMGce9xlZ1Q8naCByPGA5A+R
         qBZBA9h+QdcQd0e5i1NHbBeY1+g2bJOXDlkfuG6IfkT1KD+y1c+4zVLg5KCP3uMbc81d
         jUNXxle6SdigOhwSh1eDbHjEngDzoHkIkrefxvOi6Q8c/JsyHwmGIiep4zrSjsu00XHr
         B+vmgei2a+NfYFA392qTyB0WyfwF5k6cyR0U7sFECk7zQHEGOyxrVE6jQJ8SskPGoXFl
         CKWY2qV+x+LqjDGgNI/DiZ2bsjc2RlmYr4bxToCPeqwLRPGIXHcfXaL/5pMmkuED+gpW
         o61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241795; x=1756846595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzlN+dsEa0DyjaimvacceBZBAxpbehfow7bvljEAvnc=;
        b=L3WI9SnNU84iwrSd9RibgfRbzQIdBKvGziUq/4MDWNcCYjPiseukCKaG0+xhCG8RXy
         0vFSXc2xqCk0inA/w8SVnth35MAE7XKNDDkogsz1zHd6a4R544UIuIrjSXgOoDQjtJ+t
         77VUFkRdvszZQmL/MPXfYcwPYapuMJosuLu2HaqSZZxjAcXeRsYK6ETQ4RFdON+tMK5e
         WcGvxyidecwcAjIrm3h39sLCOJoVZNnCXxsPY4KVxkyU0Dtl6fGojCJDgDpVOoTQwJu2
         zvBeV0ZiVorQKWmQigQBV3rvNBu9n0o9jxj71/XuZdfnw15m2/fQd90XP9IPQe9sj4IB
         OE3w==
X-Gm-Message-State: AOJu0YxosjIpTA5uVATXmKy8ga958Gorl6bKpRrE0iCt2FJp62gFF77r
	WTxIz5HDETPBuyIAV9hEsO0BUHiTtdMgkZk5ggVt2FA2TGoxSQcyTQAO/FjxwQ==
X-Gm-Gg: ASbGncsdlvozXutkF2Jku+L6YIakIwALaI+G8D6vCLLEjExjzDrZqsOnUcnHRpRVnw6
	zgekaL1nsjgrEn9+ygY+b8ZrYcH4nP41bNsh9nY4uYkyRSm7zPIk6sug1jaWOdjS8MMMRSTkf9l
	MJsaFLkTF26dUHiRibwDMU//A29Js14n4CqDbK39WD8fi8BIj+4kyhskIRZtngSr+dzhyu9gkIn
	qsI3x96+OTQ3lO4nsmveP0h9wKVwnWij5ierPN8pQtuYWE58fU1BQdLl3qDzJrXq7JsOawCRSR6
	WvN0ZgotkHuuTGnWdMzpaJFVrGQT7ZFLCJKOOLVKIQQpGvDdHaoIiYA39g9qdVk6vYzt3oPnIEG
	tvw4P+58HtgmoIBVlSJhj+M+8zfHsSUthkbCgAABnJ0jLZAMB6O2Y0IOv85PxrO6u
X-Google-Smtp-Source: AGHT+IE6v8CNLQIgw+Ku+i/WxqO4TvinQJJMdkDw3LTLIMW5yYdgZnYjPm9+vx14ZzpiizsAY7GNkA==
X-Received: by 2002:a05:6a00:10ce:b0:76b:f01c:fefd with SMTP id d2e1a72fcca58-7702f9df093mr22128819b3a.7.1756241794935;
        Tue, 26 Aug 2025 13:56:34 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:34 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 6/7] arm64: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 13:56:16 -0700
Message-ID: <20250826205617.1032945-7-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826205617.1032945-1-vishal.moola@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A5A16C0007
X-Stat-Signature: go3hobeqa499koq5aabqosymm66f69hf
X-Rspam-User: 
X-HE-Tag: 1756241796-116301
X-HE-Meta: U2FsdGVkX1+6VqCWt8dFAJZjkrsxuVi4V8LquoPb2IW7lFl1/Ysv9OHkkQkEGOcb9QiEorabAB2sIWPSF9TYJNr0seZ3BEjJt+O8btRL+IHzKU2oZg98hL5hAwVx8eosFw4f4J5Deh4M2BdrO3Yx9np9PR7iYS0BnIMK8E+fBdeU0Tj7oJTDM90TzXmnqI/gAoBtfd3hiSOMdFj1IK9zwn2HrZZATSEMk3CRWmlfVD5l1f6rp4bMyktq1cs3vCLt901K6vS7FiSyivr71HNrWlZQ0El63IjbGBJYBb/arzZOvWgnPfi7A4loAlOaqTHVruISwJPN3gq7tnJHmQ69bjpDxAJhIfMk+DXTeuNMrsctoaiS1iIikocjg0qGP+2gu0IIp3z8+dr2pq/oyjzvqNxgXY2I8NXCr2YtAXwmlPQzD9BUGHuYX6KJCqWUQW0E21wxe/qcBU38WzK3p1MHgkWdJNUm8wZuvf/0HYlZLBW41Q30N44sqee0qAhIy1Ikh22onejNpHFiHcVm0OS6kjJJvIg0fmqMrExQdTvxoXEeb1JXeLB8BVIVpoNY0IIDh31Jev1OwodtYW20N/tdyX9peeUsJ5ZsaU91lmu+4NnfV1ec1omBKcLVf1gL+0KQKrWOWwZm1B67TbB6IdbfMxQwKxhcm3HqxDvZ9NKFN/z9/r/hW8saLi9E74QNuiwDUkUeTjiwOr4QdJxl4aeMmJWrIwlU5KukehsGRk8zDBfuSMJ2YA9Dz60vXtlAhtMd7aMsoi9HQjwXBSBE2++qjhCFGt5AunuHAO6eK1ZzS538LxdaQJ1KliaJBYQXSlWCJDaV0lGzxf4XJyEyCl6EYm8nAB9pCSZBFRYXqPouyxAuZCuohElNIMx6A3JpjIRCYeQS2cRMULg7Pcp/yGZw+TzPKZuPxoSc0Hqw8LELfKkGEdzlvmrfcTbqRXb76wct7JqDD81vkqTeT9hdEDM
 u5cL+v86
 qOEnxrfYLmZnOA4NL8YzeqHT3ONEVMnpQY045iaCjnZVIJa2InNzSTkIGOu+Uw+S4/3gUwP2ow2c3c7Gz1HvChXV9yhS9nZMdM3PDfjssL/Nwn7U7KB2W7AkL9wH7IaXlgnfqzKr4BZg9PRdyj0+gSfBodCFmSWINt1RMVATiaxBmuO51X6UWXA46rjiHaf1isZuMrAfkUOa3hINbvnzMmCksjgtbkq7F7S6WPBxh1qgscBraQz5KENByyKrld2pcX8G2SYhpRTi1aXsfWSNRxQui+5VQwFmQAeSQsKYOn/65naGGmdzVAMDSY6LzRXg3erdXqvOBfLcJ4m0NFcm5evoQM9C9T3Qy8yT3g95oNNPGDzvweHJTzU5/hX+B3y/g+NGJ5yDpYjN1/E+LzshajPevWICRorlypUswprDwhOrXf4fxeDbCD9QUaJKKNNlhVaX/Ev08TFy0hXpVCzgH0HMt4PeqBwVCBHqyf6TgR5nKE6RP8ZW7AiGpuUtyLiB37NRcvxIpm9Us6m2neJzZvHb5q+c5NgQp3jcmIQs3vJTWaOSfHJ9jxRYh+g==
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


