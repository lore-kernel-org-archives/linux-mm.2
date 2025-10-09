Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9481ECCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9378E00AF; Thu,  9 Oct 2025 15:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9AE8E0002; Thu,  9 Oct 2025 15:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99308E00AF; Thu,  9 Oct 2025 15:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91C8B8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:29:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 640F61A0A73
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:39 +0000 (UTC)
X-FDA: 83979565278.15.04F1E53
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf19.hostedemail.com (Postfix) with ESMTP id 899BF1A0010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:29:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BEpnEZy7;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760038177; a=rsa-sha256;
	cv=none;
	b=u3wtSnw9H3Xx0wMb/Y4HT3ABoKIK8TcfUnyYBJtlZ1J1HwwGuyN7g6TyALa62dlmV8fH9y
	oOzY5NDnYX/bAW0Y3rrwOUbSq2WFiQRCfuozORlPmMBGKzcmdAl980qpvjU3MOosyiIguc
	Et52efMt2+L/EFO9Lv3r5hFcAfmdAdc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BEpnEZy7;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760038177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VEjyNy7tN64B8nrQS8xzAtMWitrLYtXSjniZj3owvA=;
	b=5nth07ovVy3gBVPD0OHYGT9i4nkithJQtS0yAGL484kxT2Q4+Vh6oJkjFyioA+jluqjog4
	m+HmQHFprKPBWEdcz8SsvJyivppXVX5L+pZGIhIZ2e37ZJjzPCxg4qvGmcWsM2WLu0sxLF
	WpvnLb8svZ+hNJrENdMyOAINVgJOTWg=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d60157747so13703847b3.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760038177; x=1760642977; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VEjyNy7tN64B8nrQS8xzAtMWitrLYtXSjniZj3owvA=;
        b=BEpnEZy7CjQIa4cihjzL964TLNpeGRnJsv2TXcODarvTrcJvjeEwZxX7EPxI/9100k
         j8RfYqJsIe/uzwcTKCSCZ9hNJ9Pgz2WQz0vJSPWmoPr9kaulICYMbXNW+/Tnf1SKqhD5
         OidHNgSFgscUVD5caKUamIXORHAG+YCPNMd+sFD5zei8/xnujOSg6wAqT0sS0EHFTYGO
         GKqE05LRjgE+trPB/9l9RFyxSblmiyQXjZlKY+rjZQKDZbMosxmapqPrWLJPuB89zQb3
         qwr10WMufsoj5wyBJjiGRvAngu4pBTkuworf4ByxvFOyHrx0J1jSAgw8RvJJw3yaTuDd
         i+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760038177; x=1760642977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7VEjyNy7tN64B8nrQS8xzAtMWitrLYtXSjniZj3owvA=;
        b=xP/uz7wZC59j0SEXjTjc12rgriYTpCm67A6rGxYcRYG8m375625Euw/sKxnuz9KJhw
         eeN8L8sOLOLYPWx6Zhcd4uZvKwVckI0jslbBZEOYZjZYNAOlqYqKGpt0feeESmUa1P0d
         2AbApBO3l1USk4dggxfMnIde5vtyN0620+NrGHP89dwVwD/i+hQppdLz7InwarKl0PAx
         l+H6RW87ZTzehnSqvYrcTUwCTjjblZt/pzKpiOmeUO5d83GCytCLEIA/660VP1u2dDWx
         EswLQRpgm5g1X9MtxFH4jHb+5XUE0WVWG2Vr6lJ8DQXMfwjGVnqN7/hGBNKmn5qUWEMl
         rEOA==
X-Forwarded-Encrypted: i=1; AJvYcCXX9lQAtFBt3qjaUlZwOV/GBzTxciXm/wR0PlgzRKxOraMjq1/MHZY8slwvAHCUXrY99IGps9lHAw==@kvack.org
X-Gm-Message-State: AOJu0YwvYkAgRykTifHYMnuhDEdZYHJdep2eH/dZmsihirfPZ5+qClbL
	1CjRxuvpp6Q4D+p/CpRPcvYK91W5IN75KXQDlqJqxFrYUG/hu8xdUI2t
X-Gm-Gg: ASbGncvS1KFLpGKPAe1+B/FLw0RoBOOWmKx9Co4QfpL0GLzupT34F+fi6c9rvadXOLm
	JLtFibTLJqxyUS78pfsR45ccs2GC0h9we8NfH5TtCrjOp9v5VNMsHWnLj+2KTfFAXsh4uwBz1Y8
	Ew86579anmkZxHhYD0rvPKB50+NoPqX4axYOnZt5rwGxit0+dIWbtgG1DctLrheGCFv+1UJh9G7
	3DTNSzF4tnf8ih9Zv4DD3yHENq4OpGKk38PvkEg4z+Y8MviVxt83uwAth3FEZ4WXgMPrk1OA6zX
	m2m5LjwdIxwA9bzIEYE5qHRRlBwizvB+sIEkTJuLOsZNimar/Pmwm7dhBeGcdAUtzPJOQd7mwcM
	Nygz8dqlrAdCJgQtD/50QWyChEGCtHAwuHe2yBUSfpTk9t9H4YrP3ic5oZt20HaOaO2bukYnS5+
	FgmnAvceRtyE8H
X-Google-Smtp-Source: AGHT+IEgIaAl0gJP13GfBH3rrO9w0VcepI90WGQQz/0Jf7R5/XJoVA5nO6QCWLHKqqeDofhf8Vg/xA==
X-Received: by 2002:a53:c04e:0:20b0:63c:e0bb:2e96 with SMTP id 956f58d0204a3-63ce0bb3b00mr1965060d50.9.1760038176568;
        Thu, 09 Oct 2025 12:29:36 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:57::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63ceb928a99sm37037d50.18.2025.10.09.12.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 12:29:36 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 1/2] mm/page_alloc: Clarify batch tuning in zone_batchsize
Date: Thu,  9 Oct 2025 12:29:30 -0700
Message-ID: <20251009192933.3756712-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
References: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tynfzppbh4xfsusftr4y1fz8sz8e8sjk
X-Rspamd-Queue-Id: 899BF1A0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760038177-746710
X-HE-Meta: U2FsdGVkX18ep0Z5q26GJ3P/0xJ9m5sihbuckUcEClxNzQ1YHllXsQuARj7+Wu+OpwPvLWCTRTXi/8daGyBYM7IcSfUpTHxc2g6rKLMkXOloeBdzUzAkL0Xc88hVs2CjtDCawGa37Wb+TWJFY9UgnABEG+c8NizJ9tdHSt6STua/cn/p+mtGNjpZbDB+eqEyx2ZowzFr0VIkXdCXrL1AfAXJvlUQPp+HE82NxCS2W41HZ7gZVLVGA5ZZqFwKvR1gnj2jcMsM3SiLq3DmyC+LkzU4q0TKdpzZ6GRXPkA+2XM3pkd7q47IR04ooNj0K1w6Vg6rj3ekUlvlYhXfPihOouRQiFIdKoqcT1+TIUnJEHTzusnmpsPdBVYYuiHvF/WMtEmvbR5M3AaJn3U4+uWpAzVidmzWB/Dfftjf3i93STxZcKs27vxvtPpRAUOor1B00rpWyibOpxmzGp8CFmtaZuNfGqpaLx+L06SDD8dATpufsyAgOdbJq9KRaMrlhATvN8TNkfkAJu8ZdJsRm8WSc38K26Oez4zmNP36ulTCmV7auUabooXtMZud/vnRc70/wWnWw6/BqNxxnl4fvsH+ZZRLskDJ2YRGKFfoaxSWzABGj0uj7UMJC8pA+l1MV9RshcKu32OHUqTqKwAGXXcsc23pz1QYhKjJuZpzRcjhgnI8x7bop/XnC29/JP2fivzz9V/zxVj6R9yTCG64bOuZeDE5kUR38LnrxxNwTRbVzeG08w7W8yTHcCvf7XqItnA9HaXBd93GU/R/yQS5AptrDK3pO8lw9QugOkVD+JMk1RDHgxnB+6GkSh8uKmjweYgVKR2m3s4cNH4yU2PWVHsgLuK3ss1WVAMtkfr3bkLQc/FowfN1DteIBe3N3hONunCqA4RBlcLqeb9/QuBJBXl5axX0TnzMG7pUU4JU5K/kKxfa62+zHRkSj2F9GXSeCU1WjtNS97bAi/+BIPbshj7
 CBoe61fA
 ZGPuvWykM6zqBCQELp9jCRee8/5sMUSCD56N034qOsqjh+0YE1km4J6r5QTqIpxmBq7z2qmusaRzZtYZrIPUH3huuvVVslWkiA4fIC+dmUBA1Mo4vYOgv3HI0x747WWpu2QJd+LGJL4AzjnZKG9T2eRMQ0KXNBTDrziUUIiZeBPlpuROMKrjRO7zcNAS3PqPDRB+M5JYSSzLSXDixgmPmgEbG+8hsVKhBqdprxcwtpooxKbcqRVyw+xIK/f35Arjt4FKmvnBoJ+4L+NVIiKSuI+WSbAY8drv286OUtMirUSh3JGEV9ufr5PBRAaBfh7HCPFoMpXDcUeUT55haWWrt7g8cbzJfLoYyGquTdK/vznzw2zZUgL3upNs6kVQpAANvWgJt3VnM/RzQFuIGtnkcoFVUeRQnKGjIgLSYDcDiX3r/opMBMzHNv50+Q3/oB4PMLZB2+ox9qUFZkXwnZNezlDkoEhJIXfYtYr01tjCXmCsPrqGBOZP2g3mnYfIvW8XPHkqLz4D+3AkK9FK1zLOF/lVzf3bQxgPvfxlS5CiHnFiF5BjVMaZYG4lQAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently while working on another patch about batching
free_pcppages_bulk [1], I was curious why pcp->batch was always 63 on my
machine. This led me to zone_batchsize(), where I found this set of
lines to determine what the batch size should be for the host:

	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
	batch /= 4;		/* We effectively *= 4 below */
	if (batch < 1)
		batch = 1;

All of this is good, except the comment above which says "We effectively
*= 4 below". Nowhere else in the function zone_batchsize(), is there a
corresponding multipliation by 4. Looking into the history of this, it
seems like Dave Hansen had also noticed this back in 2013 [1]. Turns out
there *used* to be a corresponding *= 4, which was turned into a *= 6
later on to be used in pageset_setup_from_batch_size(), which no longer
exists.

Despite this mismatch not being corrected in the comments, it seems that
getting rid of the /= 4 leads to a performance regression on machines
with less than 250G memory and 176 processors. As such, let us preserve
the functionality but clean up the comments.

Fold the /= 4 into the calculation above: bitshift by 10+2=12, and
instead of dividing 1MB, divide 256KB and adjust the comments
accordingly. No functional change intended.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

[1] https://lore.kernel.org/all/20251002204636.4016712-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/linux-mm/20131015203547.8724C69C@viggo.jf.intel.com/
---
 mm/page_alloc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..39368cdc953d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5860,13 +5860,12 @@ static int zone_batchsize(struct zone *zone)
 	int batch;
 
 	/*
-	 * The number of pages to batch allocate is either ~0.1%
-	 * of the zone or 1MB, whichever is smaller. The batch
+	 * The number of pages to batch allocate is either ~0.025%
+	 * of the zone or 256KB, whichever is smaller. The batch
 	 * size is striking a balance between allocation latency
 	 * and zone lock contention.
 	 */
-	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
-	batch /= 4;		/* We effectively *= 4 below */
+	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
 	if (batch < 1)
 		batch = 1;
 
-- 
2.47.3

