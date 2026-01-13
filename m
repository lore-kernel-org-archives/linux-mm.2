Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D6ED30CC1
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 20:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D0B6B0005; Tue, 13 Jan 2026 15:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17F66B0088; Tue, 13 Jan 2026 15:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916816B0089; Tue, 13 Jan 2026 15:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEB56B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:54:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BEA41AD796
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:54:52 +0000 (UTC)
X-FDA: 84328144824.29.06E3BBA
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CD458000A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:54:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=2jOuqBPd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768337690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iBXCI1NxCm0VpYg1PG7P3767JpLF5L8JaV0ecrmcQTM=;
	b=BDb7tvEVsFyLxgUfw3xa/xCIK79/LxLO+HCtlua5p56M5MdNl5SyXkCgJ+mqdV+aZ71tpP
	UFWVtUCZkEybAD1YsdQSlqCdBP56xoAJtu6PWd+dyWK0rIF5Txz+uON2HH+bOzOR0hOE4P
	pC96oZrPJKOBaZRtsYUag4a7tP+VWX0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=2jOuqBPd;
	spf=none (imf30.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.208.52) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768337690; a=rsa-sha256;
	cv=none;
	b=XOjCvpU7ehLUrGMbhIBfvTkzCWhQTXt0jdEsidfq+IPbHD4zrBEZyequXFJOs3zEumWCMW
	qSfpxt/Lb8qV0RIGfEvBklB0l5e+a2PmgDUDrkV42uJ4xXnkC8ZcfwzGA66ScjBeiufcPc
	yQblUkiP3HaOZWYZVv8nkTdio/si9SE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so2430087a12.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1768337689; x=1768942489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iBXCI1NxCm0VpYg1PG7P3767JpLF5L8JaV0ecrmcQTM=;
        b=2jOuqBPd2xtNK9JfhaUsXl96lf13/cnB+ilOzntAj44Kog5fkOeeEOb7ge2s7gByDc
         UvnYYqAC27dL4ir52NkXK6U07S2Ni2QUmUBzZQRm1VNSeKxfPWYfspSLp6lWH+2uZLxL
         WzEc01jPpMWEy5mkV2l9qiZ3STCXcQY5iHk+OuNHCpUGQtfUinvbLOkSa14zxq+jWD1A
         NTqDUpRH5jiWyoIGX8OAWvz3ajMfATYZamk3QYhbvvBIdCNo0AmrMSp9wmPaaXLdcaSy
         bcuuzoZWv94KO73rfdFndWVGV8kH28gPeuO5nY/jm86JiQVX3Z6DCua4G+TrB0FxRxjy
         zYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768337689; x=1768942489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBXCI1NxCm0VpYg1PG7P3767JpLF5L8JaV0ecrmcQTM=;
        b=wQyyhkD5Ww1Y4lC8M8wtKwJffdMX/W5hMVbMstir7HgcV9USTJoSsT8KNhPXZFIhAU
         dHsSIJF1zo4NnOoRTVWyJSV8g2PinlRxqRR2CE0ZeKUfrSAixq2jKKAKwISMsKEPe377
         YXatcG2k63FLGlAiq33yDsDDm6kg5Ht2JEXteXra6CylXWNcxcDxBALHH8Z/JX5rVvbT
         RcivsahTTvqn6fn7QkMX6yuOSlv6E0D+iwKEhEuFVuiVRBEoi2aQG+z4m+/NYGAPtW1P
         ZN7dHrmLFuaqZ9Buo/hlhUhEQ8QjIzIurZbQ8RVt1n5yH9mPl+qAjOzgymM5SQ6aQg0a
         QvuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPt1q8q+75d/LRIea+sBYLT6KQAlY3Go/4EXKpWzn2P68a+L9ndkCsgT7/ZOxP/lTtVGlmK77EYA==@kvack.org
X-Gm-Message-State: AOJu0Yxgyufn1xmExVF5Tary0CPdmwbdbRQonFKUL/Wupx+AzCPShRfq
	roqlUFKZa+/TWGDixr+hI86vM5BmJkIxJj11jfs04newKiK4o2sWcqviiMoS3JzVDA==
X-Gm-Gg: AY/fxX45XX3EoiJ3E7aJLCT/q9Zgqb8guX1j+uQRI83pRuRvQo+1WxVD0HJnHjNoDMy
	8LWUvHltq/elcIkjDZwHVofSCwW+SB8XuV0Rps1bqV7YcYrWV40YFzXdAVC5eEX+5JKh9/H0c8D
	QI47/UW2QpqHNuSvKxcPv/+LhqJX7HgVFBTvY+xTEyk530Ycda/+bFpz7YeUC8j4QNi2fR2NsTo
	q2TwBXefnTOWXYN49JnX/dtqRXgVOiHKOoQ4baSn6WCFhwWX/P4Qybs4ElbuVhgtb1TBLngXdK+
	avnvPlFlp3tXeBNfsRjWU+nIqg+bcv67XYxBOSTxAxqXmIwIbR/G+iHi6I3ofdzpIAaDnToUZZX
	K5ksjlbC4yp+tk3f9mBkzmH6fGjYI+1D3q4CTPNcCibbU+HnmjdLwqKEG1TTRd0rKxxXnjMAa/o
	EDfCURw5TW/8IcZXbSL3wTx4WDBw3tDiAtKobqL/oICvVnWHUyCZND9ntNtm2NgbyC5pA2algyh
	nP3Pvb7Zy2ONro9Zmxu0gLQB/XnHr2SFP3ibdEf
X-Received: by 2002:a05:6402:2695:b0:64b:48b4:d71f with SMTP id 4fb4d7f45d1cf-653ec109310mr251481a12.7.1768337688812;
        Tue, 13 Jan 2026 12:54:48 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-2712-2470-a5e7-f14a.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:2712:2470:a5e7:f14a])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b8c4484sm21227673a12.7.2026.01.13.12.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 12:54:48 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	boudewijn@delta-utec.com
Subject: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned compound pages
Date: Tue, 13 Jan 2026 21:54:41 +0100
Message-ID: <20260113205441.506897-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8CD458000A
X-Stat-Signature: 5cbf1nxtjd8curstwr6f1hqqmjeex76k
X-HE-Tag: 1768337690-126462
X-HE-Meta: U2FsdGVkX19p0VjpAZmWdOQwBc5yyeR5aH49Qip10VfW4C4RMoJr7vifCh/i2f7XaVhh/8m4wLCtp6Vqah4rMMhebmucFUXe7Cdlytm4aeu+N09bjL7DgW616VT9gCYfO+kurxXjQNfmEOyfhhQfV+6+oxxOjcBOa6UebbJiHaapJzAk8LKXsNk6T96ih61XZ3Rl5BfBATATCyW4p13v7bn3/jlC6wSv8+qkCi5vQ9QV2X70oofbkOzA4i7fzT8WY2GjgTMjccwhP7Fgh+NvKLGqNMe3FI5ODRWZLEvvHxT4gdYF55CkuhummuBvwti4Na6mVV6amvgluNWR+IJi3Xq3OmktTdowVXv16zZQvHIEKjVVfxFGZyb/BBei8ewMFFg80hexEEZn55vZK3IlAGaRzfbnAgQgkwFwc1TzlM/Wo9Vm+oCOWVaFaVT04D7thnn29raguEbzmzUG5Scs5MPEVr0BKOQwbBdN9qK36zdhtzo/vpiwN4RBboioHgNZP4OAhRek5sXVNPbc0lQAw8pzkrokKdyCT4HqY1o6nbAmDPX7lyIUJe92DxXkkP2BXDdGScHaKIsBwcUIthpGOuD6MHCGixsPP/iKzdJNlKu3tX7/vICACYFkbXFJ8mLHwvoiXZjZICa6Ge0XGvhk0YL4JQbt4zRsAXH4kFxsuxo6G8zFellmiMXtXgOQf00j+ztfQfKLohk3SEhy+gj6s5rEsM/0dTINq3yVFmSkHJsJmaNHTS9shwbuFYutesA2AJx5/bQh8XNyd6W6mzyzTPa/TZ/SPZi2EqVnMhlq2iIKSbZvI1eKVOP2ZJuzoQeyuOX2VHpVg0KSDHetkMxRsnNBVBe+SKkohIPm+lgFermziUxt+V0rCyCklyX8hJ3ZtSY+HBPMD+Nd+W/XR0qUkWHUJbx1Q67roHxC500DDpr3AQwEIe86dX7+wZWB22cTbDofdjr5tvyNSzpQ0/g
 j+ocU6YS
 ZGnnCYb2cD/x+9kkLNRMKuV+/5W/oWaSqjO2beFdcXgtPi+v+ZzRDYOdYwMVSLtxd/qqFnvlxFF7mr6IAbjcnJPqme2bjDyd1maFLesDL5dZd2kHyzSl/UqlTldJGvKb867SWVOwDc74Dfoi3ys/1p/JDjohIrATDl8ozKJcLTWQMpaZ7WUmqcQ9K22nbqF9HognALsEy/5PApzq170o7hrsKJuNmO1udxDDz6sFnv3U47Grmt6+CbpPMOGJL0zu64Io8Td3Jp2jK0xXWabGuERUMm3DOel+G8Z6KDxRF8b0NJ+TgN0xFnuFnxZv6BOYbO/DPPASnA+EtoBtZNCR6Z+CIXuwHaK0t7rcgew3ElKGU6SakWOFOTLYsv85g5sBh6XG+rV36tpfbqL9kNwaLYe3L9D1zU1qwfVvl+3TYOizb0JpwX+aCZUM7aEFAuefV8c8sGk0zyFOSolxo4GOhMi1HuBceaEg42j6d+7lsTHs8/X9s7AMLz5WiqILLePQ6Ch/M1wKG2f0h7pQG9tiLE7GSmrh6g9Z6ug26jYY8pOBrBoKZFBCOKAVhX4qOdKRF6FtL+w7At+EQMwWvsoamTNG6fBbPh8VRbHWY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages_prepare() only handles poisoned order-0 pages.
In memory_failure() (hard offline), pages
are poisoned before attempting to split huge pages. If the split fails,
the page remains a compound (order > 0) but is already poisoned. However,
Soft-offline pages are always poisoned as order-0 after migration, so
they are unaffected.

The '!order' check causes these poisoned compound pages to skip
poison handling, leaving them in the buddy allocator.

Worst case, a poisoned compound page could be reallocated,
potentially leading to crashes, silent data corruption,
or unwanted memory containment actions before the poison bit is detected.

This patch removes the '&& !order' restriction. Cleanup functions in the
poison-handling block correctly handle non-zero order pages, making
this change safe.

Fixes: 79f5f8fab482 ("mm,hwpoison: rework soft offline for in-use pages")
Signed-off-by: Boudewijn van der Heide <boudewijn@delta-utec.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c380f063e8b7..64d15e56706c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1344,7 +1344,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 		count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
 	}
 
-	if (unlikely(PageHWPoison(page)) && !order) {
+	if (unlikely(PageHWPoison(page))) {
 		/* Do not let hwpoison pages hit pcplists/buddy */
 		reset_page_owner(page, order);
 		page_table_check_free(page, order);
-- 
2.47.3


