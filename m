Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D6F9F3D61F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 08:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6806B0092; Mon, 30 Mar 2026 04:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE386B0095; Mon, 30 Mar 2026 04:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB5D6B0096; Mon, 30 Mar 2026 04:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3476B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:40:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95F5C16059B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:40:16 +0000 (UTC)
X-FDA: 84602082432.09.18CA84F
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8E01C0004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:40:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RygqOdn1;
	spf=pass (imf10.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774860014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+4CTya/+7YM/m37hyKE0Dev2U0E4yvh45G81O9ViOks=;
	b=yTIGdgVtoSP0v5ye32bAzvA8sinXkX96wHW12A5kFUerc2QDSQKBH5vRfTpEinDwAEdb+H
	NxmqvtmCep5Rpn66Vw8xGnSKBryED1YRDeHDcUgaglbX2MDVeYdMUinPegQgZ2owXmVs6f
	S3Bkswd9MPGlT0CfiJdoy8BcL74RvCY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RygqOdn1;
	spf=pass (imf10.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774860014; a=rsa-sha256;
	cv=none;
	b=3oiOw4F4my5kLb3WK26KUkKHjkDocEbeAyCP8MkJj7PHRNBgQnzRfeRGt0yO8fB8YDpB1d
	SQIGwczOiJwhQhcXTRcYXeac3nZ7ZdX5+uG2GaRYbCCv+BY2CvjYaVOMyw643Z0hRwDYOu
	4j3zp9b6HZC6xV/x6pIggSc7DDvWWek=
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-35d971fb6f1so1285821a91.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774860013; x=1775464813; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+4CTya/+7YM/m37hyKE0Dev2U0E4yvh45G81O9ViOks=;
        b=RygqOdn1y5lMyL3aHJN1pRYhPmCHcLiegnjDztwnklYFa1MFei1XKnQwpaa0gayR1u
         AG+B9L6yB/nqpnv25L1pq/xbxtX11SQ28oL2zMR15v646I0PaMNnS0QVSROBQoeaFu6Y
         mx8d+fPusfyfiwH4QeMRjybCnMNFyyoThzVeiR8sCDiAjYli7YlPeSy+jY4Zr7jrFD83
         YaVTpnb879IU1WUbC5MMUS2SNI113JWiaLYpSEzfw1jauC4f082ld4OGZZSH6CWSa/PR
         FT5STGLv0+7H/ugdu5TuX9BvSxaEmSgcZelxO4JVb2keyrGdLdakjuQTCdNS4V4LOn83
         A7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774860013; x=1775464813;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4CTya/+7YM/m37hyKE0Dev2U0E4yvh45G81O9ViOks=;
        b=ktW5h8eY3lN1N+TMU1qd/58yL0Rxh8xtAi2B5ogqez9AQ/VX66T+5fV8kmdBL+nspf
         pybh0ShRDGZRNi7UCRH/Zis5y7OhGqnsYSyUI5WEQHt65vvNZC8UuExXU5q4ErSZ8+2c
         bL8iUnCyZei3842qPyAQBcm9fBBLzJAq6osjhLASxBwspBCgf0dO+v7UhKx5uYHme5pu
         ZY2Vl0T/nIwawHprpusDNsDZ106KBuibuXQGMdAXTcOqsuPPZZis7ZHGaQFjC4l+UtTY
         O2tza+kGNPxe2Gh2Cj2ph0M/D5XFqETtttlaSI9i3gI5Qvx8ZW3OiMCY6Lw1ss5Jg/er
         LjvA==
X-Gm-Message-State: AOJu0YyN0zVql/d52K6ewN2gJk0Vvi6wQiejyYEpBTNkck96GnCyzq1y
	iH5JFvhGKkIM5B0OD/sNN4oVh8Xfpmp4pWeufCPNtm0r1V1LQHcVTMc3
X-Gm-Gg: ATEYQzys0CUI9VHdHnKOlIf9HxZxMtj/oP4Dh/y/lGlVvKk68JSmLxW3ypLSKMXzFCs
	2tOCZYfMPgq2n2cmyQhGp803xzZ4hu1aY+89RB8bCsAtRYrgTcPtw8w0Wm2IjPeH1/V8X7qMPIP
	be+GNsbzJ0W23OHLnqNp79IJ9xVW6c47s1wTp14+VAu7zgmSvXP2hx8G3ZXZujxkz2ZyvKBLKt8
	M1PolER7ZdJ/SYJddp0QPczyxj3njz7LnOt9i+Ay9GnLVoF6+zo0cu4wFdokpnjXUsLR3U/fWq/
	/Wb1UNOrMHgjVYyXb9WuLDbM5NOi3yal7d7bcHJh9GC7NPIt0kSWivC+qw9CZ1Z+3LJ6laBYEBn
	5eCve8M2Wwxm70tJGloSCcpqIWKe0+nMFygw3al6EAAz9TNrlj0p0UMDkCc0I82O8KywYLr8HQS
	oLVOWwWNmxZ+xgqFWReKLx3FPV/YgkFWwBtTbwz9kOfxl/aPuiok8=
X-Received: by 2002:a17:903:1a67:b0:2b2:51e8:2c20 with SMTP id d9443c01a7336-2b251e831bemr36058165ad.21.1774860013432;
        Mon, 30 Mar 2026 01:40:13 -0700 (PDT)
Received: from SH-PF5NDYD6.Hygon.cn ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24264286fsm75729845ad.14.2026.03.30.01.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 01:40:12 -0700 (PDT)
From: Ke Zhao <ke.zhao.kernel@gmail.com>
Date: Mon, 30 Mar 2026 16:36:19 +0800
Subject: [PATCH] mm, KMSAN: Add missing shadow memory initialization in
 special allocation paths
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAI2ymkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYyNT3bTMCt3s3OLEPN1UI0vDNHNTo0RLE0sloPqColSgJNis6NjaWgD
 yeY6AWwAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ke Zhao <ke.zhao.kernel@gmail.com>, 
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774860009; l=1950;
 i=ke.zhao.kernel@gmail.com; s=20260325; h=from:subject:message-id;
 bh=9oBf2FE0Up2qxJXhKO76c63IMdnX+zedgNnn+/XRlsc=;
 b=9erKfsLmwyKeLrVGjXonYf6sVKX9oGLOHsVfVYEQFL8p6RGCIvyhIleKcqS8PrEc58SD485uJ
 LqG1gtAw6KoBcAEClsigLao/TD9u+3VPs5lkPBl5CmeiMS6zv9Wuow+
X-Developer-Key: i=ke.zhao.kernel@gmail.com; a=ed25519;
 pk=t0w8oqPLx0EV3Oq8QAh4yW+oVJxOabTNVP1OEbkzWIA=
X-Rspamd-Queue-Id: B8E01C0004
X-Stat-Signature: y99a6ybdngp61i1d3srpzmg6zhkkfw87
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774860014-614044
X-HE-Meta: U2FsdGVkX1+pJDp8AMMYt0BpK7dW3mRP3DKKC7T6iaFrgsWXYuOi0rbdUC0IXQ1Eh1fFFrdZClvUymRfAouAf306G4HaOqu3VnWOVew4Pu4G886uChNxPGSsAXvgt69G9oLNfjcDVLSXvRVZbBkXxXgrDc+fv6Hg+Zw0Kc2kHopmjzABqAYSCSMqm2MfMxuIWVA7DAnFFma6THLfMRP6DjRd4Eqkjx9T1U+Bm3Kml4Vae3OPhX3fWBT5n/yGCW1m9VHwZIsjZwf4v0L7+KaUOZdAZUSa2cDYhqk+JoexnMY03RtWLzkHnGbaBA2OqAzD3uJafX7ZlgeU8LLYd9QJ/u9DDOFziI8ocxYmPVrd8U+inJIvV3RiI2R+goV3bMZhaxb0ln1U3XGelaMRKn5Z8Rj7rFuTToNGCJs8Fgi75PWd9vxTc80VjKnrHffbVOtrMR8NyYhUU00Kjw3hN5oAnUkj6XAIUmq7Yhlxjq+gBItsRmBoM+97ZRWOScP6oALoDg3tuD1YsXkQBVKDXnxxKiYcLKT2+NRIfABOAKigIvSBzHbAAI/7fqWS2VzqoJs+TTEUwN+khhqfQ25uPLqN0xcFt+FW0jLqzKaC4Yj3IkQJqqteaErI1sjZOV7nHfjzqvEJMSG5+XynDukfftxj0cdKXX8iylAJ9YXUvFcGqrXcWbW8vU/cqeq15Tv/EPSBbrlWA10/R1VWXMhtUUoKBo5/qDsIRKX+ZuRis0LZ+OCKjx1C8DOK04KNhDgikDzzRsfbDJUQYZc8nyaqXaBoaF+9PH10xkoa1pUQMJxjQ/fwsmKOdS97Z7rHYo4FmSMJRVIXVU49Y5rrtiNQSqDVUZzxhl2fWKR3eg1EO3LT2rd2l0OweXzfhQLPZrlgR14Dio8twpAiXkW9MsUdtU6tUP5MZgpSDmK5KqVwMjOdr7wBk3BKbARN1aSL1xI9FxOqjBqRpTbJ3Q1pOXq5K6f
 Da4FM0uz
 IU1fVWD1oLy2DwKz/fXxiwO1pGKL/SKhxddynfGcfrvfmN3/dhWpZZGZwjkswiin6fUt0QIebRcZcI3yhGOKSpoC7gsVS7NdUIwuCQ5qSMLOlNrSiCAm+4zJS1wgNf9nfFKqCaTw+3cWKaLwecFG817tkDFDvs9XtX13xVpoFYzZ03WUgPHxEHlTvZ87zmQIY0VbN2Jsqnk9JLkkEwIZ1E//sGklTKRB1DdHytH2yjiz0UYomwrAA2BMJTPl66kyl/mdfJluW8M8MPeGNXjGmGzP9Z8pX8Ov+4gKZNdi4jIzs9cOc23jOnZXxP/qQrgFgkVaGV6dhdTkfxwOTyh1w/sBEAzkR9S0YB1d6rU9fq0d2saU18Bes0pN1hvOy+F3PMwBjPM2jxmadVL0xIUtrzFt0IzKMdEaF6wq6qnc3OxAsfCvtV1lza6GIfgI+/jH10CuLJeh4545lPuNv6Ryt93eQMvBLuJhMRmzdDpJGeSXZ521XUQNvJLaNfscTQc/5SFjwlLQaf0bCImeJ4T1VnGImzgWZXTQPl0ND+gR124i7noPXbbtbNbzXaD5O6WvFJ9gFR5SOyDRiAKSyMkH8PGHlEheb54aFT9sp+xS/ltVy2yOpUDjIeQTAexu7ieJrplQ1Ak/EzKjHh1ckbwmGrFsNKUknMQFPq8cCrrV8dAQOHVcMWm7TOvNUtp6gPE/3wErw6Kd9zKKU6gdLrc9vfqvy0aHeaxChuJIXGBBcnmvvE1/nai9F0Nck9GJgNEtRGB2V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some page allocation paths that call post_alloc_hook() but skip
kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
Fix this by explicitly calling kmsan_alloc_page() after they
successfully get new pages.

Reported-by: syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34

Signed-off-by: Ke Zhao <ke.zhao.kernel@gmail.com>
---
 mm/page_alloc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..6435e8708ef4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 		prep_new_page(page, 0, gfp, 0);
 		set_page_refcounted(page);
+
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp);
+
 		page_array[nr_populated++] = page;
 	}
 
@@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
+			/*
+			 * Initialize KMSAN state right after post_alloc_hook().
+			 * This prepares the pages for subsequent outer callers
+			 * that might free sub-pages after the split.
+			 */
+			kmsan_alloc_page(page, order, gfp_mask);
 			if (!order)
 				continue;
 
@@ -7117,6 +7127,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
+
+		trace_mm_page_alloc(page, order, gfp_mask, get_pageblock_migratetype(page));
+		kmsan_alloc_page(page, order, gfp_mask);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",

---
base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
change-id: 20260325-fix-kmsan-e291f752a949

Best regards,
-- 
Ke Zhao <ke.zhao.kernel@gmail.com>


