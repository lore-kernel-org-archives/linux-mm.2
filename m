Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E04CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 20:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432E46B0095; Thu, 15 Oct 2026 16:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4916B0096; Thu, 15 Oct 2026 16:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC806B0098; Thu, 15 Oct 2026 16:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3A776B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:43:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 842774013B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:43:18 +0000 (UTC)
X-FDA: 85326035676.19.52EA70E
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id B03B6160007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:43:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5sH4wee;
	spf=pass (imf08.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792096996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0wSQN4j3y/wqDxcmHCHdz0iAfBFTqdwL5Kj3XHoYIQ=;
	b=okgzeEdJNS8F4S8WqDv8rx0eQaQBMYAo5ovSAxJQG8bmbFNOYT8Fcix4bUhr5yhoxu6PFr
	xX1Nyd2qFoYNo50AQV4RknhbLiBoEpynfPwAgBrNKs18yK1CazVtJM3pW81lK1hCOZPh3H
	ebrYr3cudPDxSvSNGLwK4lnSTkOVmb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792096996;
	b=mo2VJYvUfdGJhVweW4YoZCAl3WZV3dr3DZbJ1vJ9jytiEGlwqTycjkNSRNIpABd6U5C3jB
	c2nUxAPhmSfnTLSGQjUvA4p9Y6pBgi+VZMKN0SO6GDXuIvZxx0ww2NZFBCXhqWBwhKyWV4
	LSpnTsjnt4bLo1HlcgS3xfSsIkRMkYE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X5sH4wee;
	spf=pass (imf08.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc1c9879395so2311452a12.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792096995; x=1792701795; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F0wSQN4j3y/wqDxcmHCHdz0iAfBFTqdwL5Kj3XHoYIQ=;
        b=X5sH4weeqyC0XKfW7wtORfOlaXLmyef7f5ixGVohYoePt03PyzXzLUpaO7EW2jqiwb
         zVpdxn0R0bwgeFVfGvelE5PBejuoGhUr0bZ0w8jWOSGfGZouZYk9A7FCyXPo+JmAQGl+
         asXmvpM40P168sK7/MWCOZBJG1IjxeKPRQ71rr7FcXqitpjgCF8W1C+Ga14Obpk06aSl
         AnsRJPqTVudawqgeAc77PNQ5JY5Ny00sRuNvpzJ556cqzs2thgHkq+0BNfEN72GXc4ZE
         BRW7gnPCx3lDFSIX5YKIvtSAv/WKqkFa9B6RNa+B6fkjZCiAzakQU84qDReY+qJxNfg/
         oWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792096995; x=1792701795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F0wSQN4j3y/wqDxcmHCHdz0iAfBFTqdwL5Kj3XHoYIQ=;
        b=vjYD52l88tnwQgESkUt607Q3t6fkcB+sHcuXD8EH8maXlZC83BTPJvxAgFg4fAOV/Q
         H1X8vlzpWBUJYK8kp/s8J6ephc4ek1KpTzbo9S8vhQ3NhJFtAmnY7b66ccbxgetZN8tF
         Uyxn3OrEEbSjfi/4JV4xAb1j14l4cCABABLdcE7Ice8ACh2cBG06uCQF94WIYzOZnauz
         9zF0guEMYHc6Ve31YXqjPKzSKC3Cw9tDINSnsEsupdwA/RivXKxKAUtqzu+2HqP3Sk7D
         Qq45CvFsMrb4/mXVMCVkV8LjMWk43fzphCA/G/b2XjsHc1cc5gKfD4gTpGds8oXe36FU
         C8qg==
X-Forwarded-Encrypted: i=1; AKwUvByqTXMHI5EOBk6S5Ps14ADoJie6u+wBCLSA0ZcZcZlLiXMjk/t4kHg+if4BaNBIhtE+A6nFe3dEUg==@kvack.org
X-Gm-Message-State: AFq9FYLpZlCeBaiLUmZp/mEJ4PIQG7FO+VobQBtcHHb2ooxSuYseL8ny
	LvaJvhQRdqzxYytl1l8+QhqSJPJlkg7nhnd0aWJXvLi0sa4CYiLD8m6U
X-Gm-Gg: AYBFou0Hr34n1Iuors/EbvV/Vhg5tV/Q438tzICLTZj2R70fvfKj7EMuqYmrU5N98pM
	gak1pfCFqrGPxPWiL0bLi/iMiDniV+y+XWXGw3nHzPDf83h+v4/L/JSIoEFT3SIXPlnMxWgWUO1
	x6qgi5/2v5B592PB7Gm/MP09tz3VAPRdX1uM80BAAmPHj8M2Nel9M3aEHzXRRwWdaWuqIdgz+g6
	LoDnMWKl3xHa2pIyJKDeCrhUPdqzRR6NOd0VBwKrqim95za+Dpf1A77CfwrEIXdDGE3QJzzu0Ab
	R0Rv7CqCzEm1c0suh4iwDVPgYljb03SdisCoOfcUTSAkqri1Auu1CW1BF4apGOYsViZh0I25xnx
	fQx3yR7Xd3iMi6430ypOjP4vWtInxN7G/1D6NnCxf3g7XfNA2Djrsnc79W+d+4x6rg7NeqbuYHQ
	BYfSrLa9UsUhcTCyQ9ZZAHxKKxBVjrfP3Y+xSV/XxTkcjk6UnI0GGT883+un3btBWBmEWU4tVv3
	p7YJJGX1XkkZkSSP+j3ERFNSBXD/xBU65jnOe4/AZS74BUfD8Pnew==
X-Received: by 2002:a17:90b:2681:b0:3a7:250:333e with SMTP id 98e67ed59e1d1-3ab3ac578ddmr16320662a91.11.1792096995407;
        Thu, 15 Oct 2026 13:43:15 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::a891])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc9d266d6sm106429a91.1.2026.10.15.13.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 13:43:13 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	fvdl@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] mm/cma: do not count skipped ranges in cma_declare_contiguous_multi()
Date: Thu, 15 Oct 2026 14:43:09 -0600
Message-ID: <20261015204309.42630-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792032699.git.skunkolee@gmail.com>
References: <cover.1792032699.git.skunkolee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B03B6160007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kt8uij9y3md17ozhio3ts1r6ore1z3ye
X-HE-Tag: 1792096996-88892
X-HE-Meta: U2FsdGVkX19DxwzBneHqVY0GO1a3tOKXCcHbTuVFcTseR7D8J63nCMlhHpqtnuXs2cm49pLjCzHX927Zs4kgXc4RQ4iBZBWfr2aK/Z89IiU6XUXwy07hRnZVK9jTs3VcGL40cx8HFnU0W5J3PjfeFq/OqezbWF5UIU9bIg91Oo3AGHNOtwf/iRLPhfH+guSoVlefnZtSHGwTyYjS5wYxwWm0D6je2eHy1sFsnrQZIN0oDyw/os+hMgueRMmIkI56eAtbr1MKQC+KsFPZipOb/HAf79RxhyibChXbZehojN2vapb5d2uwI/7piFjh2fpCGUiRbu0mymcvzzPy0Mz8LzUGPeW11HmNZRwHWrv/3ePVZu8sLXKYswdDC1UhBzvcm1HWi8KF3JT3Dp4ZIrY7/WWtu3Mo1KnGKOMvi9ib8UltN/tq4DWhCO6K0pzW8JfZz8W6D/yBzMjdZ+ju6x45pCgaqPZwnvj8ResZkOQqSANFbnKbtcFr3jO7wn9xqCR9AC+GIewZP3hjCbCYxy9ElEWkxNxzC7KuE1t5k+6HPDruBvQyX6ETzgYwxp4JSXBt1wo2u5QVV1yqi7tte1SoAEj1Tz5p/Qa7lkboRKLqYOmbrmLnDQPUvKoC8NmGyQg2GzmTyswHWnPphbzeCAtuEBUp3MEMTK17KQRdKHdcGBHByIZTlX0nCw+rttGRDRoGIGAqIGj6l4MljXVig+hIzY+KFtNVx7HaGSEd5rGqB5dCaV28sJ/QSwUdIGK7JJsQ4VnrgOwJVr8nnmDUErDYqZLyr6J66jbuyruc1X5+dSj16DA7pH4queCxulcoEZHL4ZMQDylH7Vec4Fc/QlxRrV1niWoyWGRCopVBIAgXMgAaeBjspttLz0r8THQhB8hTSlDBfliKIG6u7zhK+Sqv3zRSl25gfIUZErHWVzCnDfmgO/01ZTV0NrnU4uQHHiUPgAcsf1yQP9IDh+Tpu2f
 ZLHAXGOx
 w6nrDP7SiN+MGBt1HvQyZXIHySnVdFiLM5XYhISiR+9F6izWzmH6hOHHq3b7qXF8kUJbJD4hae2Rh80cGJ/PeCodShAmOCR1zI8nK/wKFf/86msd1i6FJwXFtXHheY8NrIRQ6daoNHk46K4TUjLeIc/7ySI+sjFx7AE0BFR19ElAO48f6NMTRtElXsPPvgqlofICyP2eh7I5kn1u1onOhzpR3K9kj63lB2Gs/YyQ/aN1+Vq+UaPGYObVSL/uxBmuj3oqTf8IL8LSVBq9lAjUjPY1lEykyqTTCFt+RPJB3r3AjFSbHjJdtFASDzcnt9hC4OupYz96qyu7xyQocAbLi+Qm3ccNloHQqoWfr5FT8N/+X1aWLWwO1sYs//tUHJtlkKhNYEFo5Ac46KI7neO6OqL7gqsY9/yEma8VPzQKqNp7lhw4BaAAe7RVDcqp+qgHLiFKwRH3YutjUe4r7gooWRUP9JEHWrurvCZoNO80WQ1VfXsE+YU6mwHH9SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cma_declare_contiguous_multi() adds the size of every candidate range
to sizesum before deciding whether to record it. Once CMA_MAX_RANGES
ranges are recorded, a candidate smaller than the last recorded one is
skipped, but its size stays in sizesum. The replacement path already
subtracts the evicted range, so sizesum is meant to track recorded
ranges only.

When more than CMA_MAX_RANGES ranges exist and one is skipped, sizesum
can reach total_size while the recorded ranges cannot. The sizesum <
total_size check then passes, the reserve loop ends with sizeleft
nonzero, and the function returns 0 with fewer pages reserved than
requested. cma->count, available_count and totalcma_pages still
reflect the full size, and the final message reports it as reserved.

For example, 8 free ranges of 1G followed by one of 512M with a
request of 8G + 256M reserves 8G and returns 0.

Only count a range once it is recorded.

Found by code inspection with the help of an LLM. No kernel-level
reproducer was produced and this was not tested on hardware or in a
booted kernel. The example above comes from a userspace copy of the
selection loop, written from the source.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Cc: <stable@vger.kernel.org> # 6.15+
Assisted-by: LLM
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
Resend: the first attempt of this patch was blocked by Gmail and was
not delivered to any recipient.

 mm/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 527b2d894f3e..c2cdef953ee9 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -594,7 +594,6 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 		size = ALIGN_DOWN(size, (PAGE_SIZE << order_per_bit));
 		if (!size)
 			continue;
-		sizesum += size;
 
 		pr_debug("consider %016llx - %016llx\n", (u64)start, (u64)end);
 
@@ -620,6 +619,7 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 		}
 		mrp->base = start;
 		mrp->size = size;
+		sizesum += size;
 
 		/*
 		 * Now do a sorted insert.
-- 
2.56.0


