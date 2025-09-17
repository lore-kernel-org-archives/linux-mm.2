Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AAEACAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 18:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666C2280011; Wed, 17 Sep 2025 14:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DDB280002; Wed, 17 Sep 2025 14:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B2C280011; Wed, 17 Sep 2025 14:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 480C4280002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:59:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFCF311AAA6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:59:12 +0000 (UTC)
X-FDA: 83899654944.13.99E07E3
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1DB3680009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 18:59:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LFStaZ8V;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758135551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PBW7HlnBnHXsZV43FxLiqGMyPVmVlz0PSTx6u3WdsDs=;
	b=f8fr75UmwqzabNkLiHjaJlLukqQkJ/ly+QAvr5ii7ezBopaeVf5ciBDROqXFecoZTuVCDe
	ZgJcJt+ZHvZ3liBCdlTAQVOj0mwdT4SslQJxZtAooLi95bDqqsAxzvH2G5/S09GHA10zhd
	+NqkXlrgKhXldoGzauucG2Ng98p6HWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758135551; a=rsa-sha256;
	cv=none;
	b=PXllPMfDZQTghSRNTPzRyC546OlAjH6RMCnYHc5lNARO+Ua1j5sNFOW1/zsfaCLMBnpJTK
	oFcamiodNR1KcRtr23DO0vZzGma2QBkGLbz61X3HckEEFxLs6a+SuiNhcqdY0lGv/p+awf
	gA9m0/Eg7M+Inegm5LgD4lTsp/FphuY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LFStaZ8V;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-578a8bd4bd2so147061e87.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758135549; x=1758740349; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PBW7HlnBnHXsZV43FxLiqGMyPVmVlz0PSTx6u3WdsDs=;
        b=LFStaZ8VAcVANaMyaQJdmGJASeEZboXPy4pwCvPMoOKmPvNiaXnMjCtmj7DgxmeuqG
         GjTyGTS1b3garf29o1ixnFefqHkSKY6jZ8C/dhwsC4Mv0odwCcOqmYf8Dv894dY7ejuY
         bIH32frYQ56AHGue2oNvYTxHx+n17jPRJ7bDRJIM1Ebow6nbsz9aadVPLTG0t7sEqvKz
         j0ac4y42RSVNne9yJRcWesTvztvuL1Na5hZc25H8QlN2rCHADTTww8FLTI3qn4IAYcT4
         b9AwwQkhvUkbGqeTUjc8gJ5y1Kt5DVv6vSJociimeFMqFHQHrUY+km4F2AgIoLQ8mfvj
         8Z/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758135549; x=1758740349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PBW7HlnBnHXsZV43FxLiqGMyPVmVlz0PSTx6u3WdsDs=;
        b=v/TAMyG2iVxehGIVydbWdDVAEOBofCePXKADMCklKtgIe10fsoRj0y//ZIOLzIFlKm
         PaQknkmJCJReg7BjoYk/ldqCEyzQUV7h/4zrLVfRkvh+h7RzEY7stwXcUe97CTCPjA+u
         awKfUbAvzqA9xOR55tYYbLOsKJvK70kD5mKCM3Wn+8FvdqA0daYP04hLTSBccQsaHDQK
         0gacRDKiqR1IjEAMWQIXqdgxt94BlqE70STjOw/6sc93oboLJ2UnWEk/1Kn072SVnolm
         WAG536fanRB1mE6PRVn/SxpkPX7F9qDRbqIKK/YGd4Z22cBkmJg8+LXIkAFXJyiJ+XhC
         DEkg==
X-Gm-Message-State: AOJu0YzQ8E9ptOVyGw7L8J9vxmUKLYed9oP4dn0G3CvUnU/kqN1n8I1s
	O1jDDuGnVFy/kjJqQ7Td/IoFLe/GcxAjCfq+7BUF5zfp4a6FxdZY1OE/xXRMtgSI
X-Gm-Gg: ASbGncsg4QMZ7r78QaWIto0JI9HPEhsyvy5ahJ7zAy2kW6szpyxlOpXL78kYW7DVfhR
	5NalizFekwFR86QXZZ5jAFmU5r9Z86XW+7XdHM2cjqkcqxzsDUo0Ex7K5PkAUb5QHZeybD3NCZZ
	qOzXsiAiwNaUHswfmj15dDBEDW91pbiK+rkUOCQJ1/NGhs+wkCiFGV80VoUDncjEHTNCG/E0468
	WpGOb+TbflAOnY10wQD7//POGCq0ySX4mWR2AOYupB+ugKgbg0s3pIH59Z/6zItIEY+1/ibIR9X
	UFyXGbRwH/i+a7SXL4jp9bialqueaC57r3lyaxAHu1eo5kP/nyE0EbKt5Wi1osQ1F2nKKXP6p42
	Oyq9iWr46d9lqzZiO4dc9/eOCxfOBkPuJLrY=
X-Google-Smtp-Source: AGHT+IGa8vKcBgMPTv3VCQG18vLMJP9gPf1BC7QGZ2WiTb9J1yWYwEmirgaUnxIIH6tWYsC0zdnrrw==
X-Received: by 2002:a05:6512:3b8e:b0:570:a8d4:a7c3 with SMTP id 2adb3069b0e04-577970368femr1384222e87.14.1758135548886;
        Wed, 17 Sep 2025 11:59:08 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-578a5f4472asm80895e87.5.2025.09.17.11.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 11:59:08 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH] mm/vmalloc: Move resched point into alloc_vmap_area()
Date: Wed, 17 Sep 2025 20:59:06 +0200
Message-ID: <20250917185906.1595454-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DB3680009
X-Stat-Signature: kk6xdmc36u5t3iexrag8bn7wkiqn9ebx
X-Rspam-User: 
X-HE-Tag: 1758135550-735125
X-HE-Meta: U2FsdGVkX1/0StCAYwkuJOgdQU/CmdYLiRCM0RYT5b6/zbJemnssTEElIzOZOncfHZJBmtgc66hwl0+pZMv9dg6fhUtPqHnN41PR2Xgq5inMo95wkjDjQHWiHFdS2/JArDB9G3VJXolVpjFt9SR5tMS9uCzwl3rutw2zpXv8sqsKHw68WS99Xma20TVqKla80rRXlw/IiEeAm01Gh1PwXM9XHJlqVthC4X46xaT7XU2tzoC9v3UL0198h0/qKZT1yq8/n+0IBg5ms02bYR39p+97rXbum+Et0rThgWtaoSAnOQKI3j09xoypse5l5V+S4CJAwkIRAjiOH6ADZCVD5H95bkqnVwZhSBS6e8o1HqtD+teiItPpH+pyB0A7ZYvagZhVtOWSdGMQ1LSGc33pxxPkG6hVG+zEmnwiHf+0MCCJt5qWgVASs2HYcsQG5uywFRk4qBG0+qDiC+7naXaFSRt02xTUOmAOLZP7YLtFJFU8Gr2QetwMhZp9sJ6YxTngN5RUodZee1Hpf2VS+JltzU4HUnZvEuFSQXt7Q83UZIS5FvhSV5DGVrLMn/tYSlJKtXV2RUzfoUfsWp4UORD7kOEAYUB6MRk5N17iw8f2JedXC339X5o9cXWWJi22wNH+qNoTTyCpjGKnrVtbVHuj704KIdmB8GS5ZJO5B45ZYKRyXrt8Ax1frhmPQ4+TMop6whU1FZn/flJARGwAk9sKQuYHUuCdHkdXSRANFD55uDc4TuWOf4Gzht8fRDotBgYv5jl/4aMRcCVf9U/qhNyCHhUli+wozGotyIB7PfBcENsGIrQVa/fPKgyV6ZGHk+qB2LBIJ0DuNRJcUCU8uO44eAob33U9QM5yeX9ngMgdc+skgDxBudzrQEaoKfRS4iWoqk3dRqxKU5Lns8OlS9jWiqQdBPxkIV9QTaO0M4jXaROABegR0bmqBWBxwijZDo8mHEAy1RkWsWcoWtRf2mN
 y2mB74Jy
 Z0to1maOGMcI34dOcZthnBNhp8DJT7p8sDLY46rUk+OvaqCLy9qGa8yuZ8wR5V6p5m46ORC6cUI71A7EzCXlMSD1H/r2ltD3B2KzJC/GtRhmvq+47kN1SvvEKwHle/c99SU+LA32tVuVAXOkggl6zhCqZfXOk47sIvOU/SxyKRTU0LBcb1vphH5C8QcaPxiox3B40btEDMwjPHYSbht7t1U/VZL02I9V8DAFmN5RVef9GYvlcJpS6BrtpwmDan/Q5xbNT+qRYCcBU2vya9nYRnrmKHVrDnOokl/Bk4w8sJxFXpSMTIkS3AvV8N/ie28/I5AZ/4bQhINCW0wuLHw+2MVmD1S/MHQFrIgWE0OoESwsgr3TbCnOtxnA0f+JAjJMS3Ii0t+PraXA2BjN0cwyni/ukg1Jf7no7yVIneoMuM6p3lZ+DVVy+NXVuTO7RC5oD+Y3+Khv2l1VRdqbWFf8CWl8GLkd1av/2I7dxIYvKD1HdKNJKuOHtKEgNww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently vm_area_alloc_pages() contains two cond_resched() points.
However, the page allocator already has its own in slow path so an
extra resched is not optimal because it delays the loops.

The place where a CPU time can be stolen is a VA-space search in the
alloc_vmap_area(), especially if the space is really fragmented using
synthetic stress tests, after a fast path falls back to a slow one.

Move a single cond_resched() there, after dropping free_vmap_area_lock
in a slow path. This keeps fairness where it matters while removing
redundant yields from the page-allocation path.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2..58204728123d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2057,6 +2057,13 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 		addr = __alloc_vmap_area(&free_vmap_area_root, &free_vmap_area_list,
 			size, align, vstart, vend);
 		spin_unlock(&free_vmap_area_lock);
+
+		/*
+		 * This is not a fast path. Check if yielding is
+		 * needed. This is the only one reschedule point
+		 * in vmalloc() path.
+		 */
+		cond_resched();
 	}
 
 	trace_alloc_vmap_area(addr, size, align, vstart, vend, IS_ERR_VALUE(addr));
@@ -3622,7 +3629,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			nr_allocated += nr;
-			cond_resched();
 
 			/*
 			 * If zero or pages were obtained partly,
@@ -3664,7 +3670,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		for (i = 0; i < (1U << order); i++)
 			pages[nr_allocated + i] = page + i;
 
-		cond_resched();
 		nr_allocated += 1U << order;
 	}
 
-- 
2.47.3


