Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB21CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A708E0100; Tue, 26 Aug 2025 15:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C248E00FB; Tue, 26 Aug 2025 15:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5088E0100; Tue, 26 Aug 2025 15:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 257D08E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:34:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C303883ED1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:05 +0000 (UTC)
X-FDA: 83819909250.21.7B34630
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id EAE2D140004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QtBAV3a0;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YzlN+dsEa0DyjaimvacceBZBAxpbehfow7bvljEAvnc=;
	b=7xhKAd9N6mpEXi42o441ZXpjYfO87uK+/rf+BPHIy0SS2AVydy5gramagIPRiYnUvUrbhH
	GUpB5rZg/aorpYSAVUCnMUFktHHU5aoG1nYHz4mAT2O8wa2Sw6S4To1kmq76UJFKQXjdT5
	KRC9242eIsACFdXmcZeqHnrxTeOW064=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QtBAV3a0;
	spf=pass (imf23.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236844; a=rsa-sha256;
	cv=none;
	b=zeIaUV8AhqgpGmKC6LSR1HwUZg9g0FSPaJsOoZ38EfvRcnneIez4i/pKaGNjh0AtEQfFrB
	WqZMiUHkOsH6f2NFysUx2NDHs5jewRq+gofpjKEuecbXltY6wFwR4tscrj+iNQs5E2umDP
	XhrqvMOPsIqAH1+xgUkP9QGKO+RMmB4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-770530175b2so2458274b3a.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236842; x=1756841642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YzlN+dsEa0DyjaimvacceBZBAxpbehfow7bvljEAvnc=;
        b=QtBAV3a0gKxCpY713gDYk73ZSly/wtnQhXtzR1fSxvBmo/sjvlxhLAtrDUYXSidLRR
         j5YF8Z2e+vZnoWYxVaS9YcLchkaZQOYBQOx0KyfJpF4LrcxCYcfvEyTgSbPuXjPXMiXe
         8MW2m3AJWcKVQKRw6QulBqKsUHiPR8fU12Fq3lmYuBy+79mtSRMkvkLaiY+gHmbO+H5n
         ES/x3ECqN4l7YgAW38t0KGrw/EtH/cz850ag7l4zn+ovvFtVcCe7cvaA379aTXSAbiHp
         mEmq1BfLW0EM2gzpABhgTFnz9jRLblAY1ybhSlYSuMRoWUYSU9ert1e7WzNp0KhlYQSb
         hXiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236842; x=1756841642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzlN+dsEa0DyjaimvacceBZBAxpbehfow7bvljEAvnc=;
        b=DWlFfHZVucpqaxJ3NkBsif0CCDP8vDAo+iK7yDKSDtnH16tk9koM1bH5ilKqepcB0y
         +AjQzoWxF1HQyFweGos9F61ziD/L/lh/4qYvD55os9uqqXHVIbVnUfhXb3HhQ7SWvFg9
         uxAOGLjAG7rScY97dxvp09Qhd1cN5hhVwJssMySzQiTNIXvIO+l7bHLZLYxuceN5BLlc
         UMnUQiyCR/fi7EsyA1AWYl+uUJcW/LqIVl2e0EsvEbZlULNk09dYEvqWGkEJUmAJiwq8
         U3CPRv2RzSiTVNQ4aD2Jeq3qo7RNq9yDanW/MdPj/HsXhd2Y5q4PixWTNnJVFOsdHAya
         ED3g==
X-Gm-Message-State: AOJu0Yw3HuoF4Pi1mPIlxmsZhx2JgszUy8VZwbjqIf28jKAufp1aEVVY
	7KAroKQLNKOcy1cGspNIvve1K/jon3Dm2v/tFj3zsR0cypGiGbMC1yCWEevCOg==
X-Gm-Gg: ASbGncuf8N5mqKMzFeZvdMJV6OJJnRstDsxa8NuCHLgvcqrFv1j5K5/paL8V2OwUpXW
	cPszAjldREpXxjBEfvwoWvALNzETMU+RnBw8Q7ATCyDBDbz/xnie1QTwj/3izyK0SZa6UwDtcve
	Ujq1lgECji5MIhPhJeCr/uRIh5wBvh3vogcYmMbHeOt74yGc1dcz45CPe6jmWxHaCXagpMzvYy9
	naPjPGXJ6G0+TF0cdEWa1lUwsExbKh67PqrHODogXfFCVbpH7vSBO8je4peAO/fyD8k9/n9o1AE
	Flyi+2DUe3jtMsPhCyWqFvxEWj6bhxo1wWaE0BBzLXcZQJMl29d4iwsCWNoTR6cbLvz9+OWM2nw
	PiyIgY/3BizR2Kp/mYeKfpSKkTQnKrLmcOWTI8mGIdrKBD89f0NyTpw==
X-Google-Smtp-Source: AGHT+IH4BJZMpmDBwjTODxEVoRjvrj3wIA0wcVLqavVX3GxXvO9+C4C22HXp1pSwIPrS0jFhWI5imA==
X-Received: by 2002:a05:6a00:1954:b0:76e:885a:c344 with SMTP id d2e1a72fcca58-7702fad491bmr17378055b3a.26.1756236842358;
        Tue, 26 Aug 2025 12:34:02 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:34:01 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 6/7] arm64: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 12:32:57 -0700
Message-ID: <20250826193258.902608-7-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826193258.902608-1-vishal.moola@gmail.com>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EAE2D140004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pe1ketiedujb647mr34fkgnad9yftffu
X-HE-Tag: 1756236843-502780
X-HE-Meta: U2FsdGVkX18/NPXjUghfHWiT8b1y5l0qJf4Z+jkoti7o2uDV0j0siT4TQK25/Fug3k4psC/et3IDMPLADcwQViUP7IBE/ntc3CWTWBhwFc2nsmBRKpTqqbgzz88r6nqZlnRFuIcxQfZvlHiIRz2MGIb22t6sFna0WbA4Qpo0c66lUCcAPmOzh0TmnZoHdv0OYsVOA5zJbm/UEba+jKz2OajLr66Dr2xadhvg4qU9jiXcEgzH3lND+bffGKTNszQmcPTeNd0gcFAvc6NRl5EyU6Dp8kMM3i7fP8V/7w+mE8mzIt2LdZj0DqYUAbVqwjwIsrv4H3K1phRF1/nLa39VjchFcZVB529fPP+Lu6rf1j+8s1TzOBQ1E0AJXJwsDfe5Bmzn+nQXIDXMw7HjG+uzLQUEq7g3y4ORzb4k7LDdU4zDI1zAWOGJoyk2GfsXN3tbHzgta5RZzbLHeUGLxU6JawOVfRN1n3AYtLB3klwXvTanRuF1emzXVWqJ4sbR9v3ZaL10vv4lTX9AGsU6JvmkkxMvu3H5EZ6LVdQs9VdKDt0+tXCC26qIrzyToKmiqqrpQE3HXgv8PiqYwzX/OBSNm2RtHpxVUnN07l8L8b3cqpnh2sCj0o0NbzPmUZ6kaT/GVth3uWdQi+xzzhZYUxngbErpcPlXOxfiRRotG+gieI9JYoCiUfX7rhTaFO9rGzcn46WQhzZKqHnWPmOYoS+4YcAkM4kYMLOjIyvAmcaFTw8lfEzQH3tTI+I+hgLa14EJyIDNuRhXxhpltJL0lGM5J4jEcD7/EJL6Q/n/EfMcdcBEBSd05XisWWrvDq+qp+xkoo5dFtjVC9L46kYnzslC83EDxyqUTmx/gaaYVtaBCGOOqQyLOcSSvI0jrDMAMLB+MgKvlNMReK44lVO6j/gNcw5SueWdhgUF3EOoLzxs3cUBQzbllWZv20hp3rlJVfKPd0hG7uMBu36xcFNwKK1
 ymUyodjb
 9s9FFijZwJuo2svidPAIr+6lOxRvqaWL+yTEBPP7gEA/ORpSfQoYJ0gpvxYm5Wqdl9qg+KcAOtQEvjLwJ87wRJx6jySGUDsbM63/FrMGKcV4WrpWhLyUVcImq8s4c3qaoBUQzemVC4XV1cE0lAGgZvzCIeskncQaY5qYYn8PMa5LXBu+6Om1RFxW4etpAI1OPFSKFTTl5QfWWsg2HCNiOQ4NsKi/0DNfi8Ybb8imEx3K9fRkkZfqKACk9tnFDBpn1GWepmiH8W2u0g1mwGcb5RPR8yuGIg+pvlp/VKhJmV9RzBcYYcxTThqfSrMwrde4XsoEZRPvwxFlecWI43NgW5drRtw4JC1R7++lmEqTRK0VQOBGDu9AcnSIj2/d5nYIwg3G2eakwQJJvISalodZV3YOvE3fDA4xTuM5vRKFPhvjwdi6zjyyFD0ey2whJ2HUdu+8G0TXrebUgLNLgzMEFKWJjpdie+K9S37FgkHFN7SCifsO8UnyawpzxxRwIXQFz+ZLY81pL8DSRhoMbr2kIa47873a3bOyvM76QUwpx3o8gttDXrjMHVLwKfQ==
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


