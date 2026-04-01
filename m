Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AE74D3514A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE026B0005; Wed,  1 Apr 2026 03:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20866B0088; Wed,  1 Apr 2026 03:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C17A6B0089; Wed,  1 Apr 2026 03:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 746DB6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:48:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A2D5160683
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:48:02 +0000 (UTC)
X-FDA: 84609208404.26.C122FB6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AF92180005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:47:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eC7iT6qM;
	spf=pass (imf24.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775029680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XA9auQdQyCrvAgPefJTXScmZp4GU2aYW4S5DL3KDZo=;
	b=eUyPWehTitAdVMc+EqzlBTPB3sJ3s6012YOkK/P4LQZO7eREZoyGyy52wGGdx68ZOQ6ogg
	2zIoQ/VLpzXL7tUXD+SoydL+Nj5ScixXCipA/6qAa8+Ec7Oes1AsBoJLmqXWhP9zEsC/5w
	8T73rJdPk0+jliJ6agBF8gwfHRcsb14=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eC7iT6qM;
	spf=pass (imf24.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775029680; a=rsa-sha256;
	cv=none;
	b=x4wVGgB688IHeU2uVjY9sA3opO8ffLFyYRtr4SEIFap6eDyBtIhQUnSZqyc6zo3vSkO5c+
	xu5GWN6dKN8As2mbNk48acDaOQ0eibQh1lGXzi9b6IwNZI8niPrcVXn/IVPuOpjWu+f/az
	FnZlunqF7iLTqYu8nayRKwU1s+nQZNw=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48558d6ef83so65415935e9.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 00:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775029678; x=1775634478; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XA9auQdQyCrvAgPefJTXScmZp4GU2aYW4S5DL3KDZo=;
        b=eC7iT6qMJG8dQo88hghmGTB0ncwi7wxIH/4ouxqiZjvjo0+Vmf7B99GQS+JT1naxVL
         75Y17CTNonHOOTsViWGZ2naJp5t9JoBp/PldHYAoeXM5vmZRO8TwWkTWZYBExJ95+cX0
         i6eqJ7V6BtPxOW3s8l2+gRbgX6klpSVjTVGDV1l76kBS3Byo2SqXhTV55o6lkyTROAzT
         WI4dQwUvRHhMtVKCkIdQZbu3jbJ2rBqim2VWvJYIQ1NP6U9x6PvkC3FUrWydNypG7TCq
         oFm7Msyyu8OMvL9LA5Omp6tPoAHU01jf2mTR04nTV7n4bRM9COtXOCM+648M4g2DqUBg
         dKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775029678; x=1775634478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7XA9auQdQyCrvAgPefJTXScmZp4GU2aYW4S5DL3KDZo=;
        b=MTZ+VHIq5fn7qIRmcNpwETXB+esztjJEKfQikUv/dlxHzm7Kj5ToluSgn/zOdMfW6H
         vRXhVk4p992wugf/qyoW2eyEeSInFq9BMvym3sHKWlWRYvHKB8hDdkbgwHPHVWyxDKB7
         KReAWyLr3hXwZexpet/WgcROEltyNnvJoGFUCOY7lxVMr9yLQvS40a6P09c+AdpsujCS
         4JtPfMAH3dQhXqpbc8r969399gSeGpETJNMO3e/f71H5bGNMKJKP37oKG+2PN8NSLZYD
         93bWiOTvP40Dc6rjrQyxj9Cx2iED55lu/BkmR535QdRU0+Rf+GgN1uYArH/AF6s/VfiO
         L3jw==
X-Forwarded-Encrypted: i=1; AJvYcCXoU2TX0WNcHAW3B7rzA9OveU6zgYpm9+FSEiU1gwOtFgDU8QAdLD6tmP9eHMfFG9d2+KYGtZ8Jrg==@kvack.org
X-Gm-Message-State: AOJu0Yx74SEjtLyknTSieC75ZpwCW3xm6ZpLoQYl0ogB+Km/3OYsY+2L
	Hpp2zqs2/U8oJWKAnH3nUz0LvqTjW3AwmbZ7nuxqSD0NFdo24BsrZqYn
X-Gm-Gg: ATEYQzzCc0WFRh9Oi6Kh/cw5nGATmHL2HhIkI0g6DrXB25P4oebDDKZYGv9AnpJUgDp
	bUbbw3q9FT3tdWMCBU26Ji4k91dErworYP8A17tmC36YcC2gSLphC8siwbr5VETCTrYhgqQ+B6n
	8B0IWVCYwjOKtF4zj7dOZsKWvrB3imjbyu1GN4+x8tTd6mcTNZOtMMVlUbQ/srayEVAhs7KsIAA
	/68XqkWmoK0QkAMe8JCD+IpWstXA/DC+4ZEQNlmIVvlcf7C2TP4QH7ikw9PYRzE03XGzXh8P4WY
	6iRwVFkGGWaX/Dt/4ap6tFF//odNPTV7iHouPLMR6nrbmsr3HxcsPiqAK9FpTozWwNJVhz0ctIO
	vqefa8CiJrXl9uPlEizA3Gou9Co1dTgxUflA5JkkOPEwyZW7wxTwiQ/99o4onjQSDnHcXUWlvyQ
	7UlhAujsNQwogzQPkslWf/FF68DQ8N2nkI7PuwbhYtkrQuRNcJxE0cujLfc1+pibwmKC3xB655D
	uQtOoUQS6EE
X-Received: by 2002:a05:600c:3f14:b0:486:fb69:4960 with SMTP id 5b1f17b1804b1-4888359d919mr39810795e9.19.1775029678179;
        Wed, 01 Apr 2026 00:47:58 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e83e906sm89863085e9.8.2026.04.01.00.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 00:47:56 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Barry Song <21cnbao@gmail.com>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
Date: Wed,  1 Apr 2026 08:47:53 +0100
Message-ID: <20260401074753.238053-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330071229.14614-1-devnexen@gmail.com>
References: <20260330071229.14614-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AF92180005
X-Stat-Signature: c7fd6btzw8sj1rguuxcn6zqpfbd37hry
X-Rspamd-Server: rspam06
X-HE-Tag: 1775029679-662774
X-HE-Meta: U2FsdGVkX184WgW8JwTkqq/Ac5qGMYmSx721dRSe0YFLZiLXefCkT7GlVZlPSnuIXa7gSFcmwiSqDeuS1sGee2jo6bI8GO1oKyQfMLsYWzqcx+jLF7cNXVA3wAq0Ra7qmDAAsVSe4bscn6J0hbhrBjt1DQ0F076T2blQ0avOZhUu5EbcWg61ZujJj3nMhE5iG4tm2302jK1YhUt8CRyjl49kvxbFvXSAMC/BhfX5csUhDaR72PF01OZFIJudAL176IgxP7i7WNr55TgJmB7iCpm/PDllsx69CXSnLyXq8ldorJH7mg7c/HrwNhH7Q2FgRud9vHAAcNjxO9L0GwqvJyeulR8UXQF7txh9tWrIwIzKh1LwC4ZehnZTgggO2kA509I9035WgQ1IZUwkg3XmsvuWPGgR8JJU8ZacUkFHqch5fwtA5Id3h3VMm3+LoGxfkduMCv+Ngo+4qQ1IB/+iSHA1j2R7/uBH60kPmictInRWYminorvJd8dmWEUHAnOO4kmE9/ipkZSnErFVnh5PTSAZ7z/oamfwwyz662eXLmR38RnW2zXA6QtFWjvKkjGWSeXocfoCJltO2VFtFJNgl7iuA7qmS4DZHBAYKI79Q33RBtdr/N4SJVOVHij3jXuyeViJ+9r/23Ig+eW56Mn4TMrmzca6KkXS6UgmkgkgXpId8lH/UkdLIRkZIGzDveScvUV1lpAfFKc8KmyjEIwmhbmAzKH6/59YHDvI8P9BP2mTtTm9r4x8Vl4PwQwo2GaFoRvhKGUTVbC5RNwnMIMG6xXewZlZ/KsD6mi3kIVZg2Ei1xlqLiMR3wsR/DUjjRVmMrBGdVvrDqkk8wBK9sY6aYrWCdUrjZlRVOfqRCCuYVGG6WITVdupZ61q0zYfMMjmGN40E+uxXSUv4DqS6enkSheul5PBs0AfNKE4E7xVlUjLbvaBlJS/XrkC7I4O0HG/wyOvyfCJzzCHjQ/AzAV
 RclKC1YM
 nNdZT8Wdevi6Pde79iNLEIpavy2k+Jmvq0tDTH/aFmaOXnQUyAhmE2jkw4/mTKBEvk6+iwrQ9amZ+G6KuSGNVszzibkyZNwWV4PdZDwt7AK8mh5WDnS1QUh0GoIbKLx8ewOcl9ERW3QAVjcseMUHyLxHpdvEoKBa2W0jWsmMPB3oHVoQoONt5yiazcBf5HeKeW18p3G7YUy9OpJqjJ0X8FsiOvC6BwIfE4H9AQAX7ScLfiY8fjmnlmEpLReAtxyn8Cgv2ACRiBs1CtUxCdpi+JJ/VutXYHmm5tojkjD11N5+1RlQCX6/CsWmkyC/rvadCtdCOFuwA/uBtM5hLL2jBXjQmTc5ScMsR5hOQakIoEu6eUH7MHGAAh/DYAGW/TXdFUGjbStTJh/BzZTNb/2TI60uhWtn2D3OJnv6/p1CAimfQ+RdEVjukiEThoSNRoqxJu3BwnV4SlqYpjgHmGaSjjJ9KqbLqfK/LDw1Lvzjjhv5bfA/icnXsdckMWx8Z2iB6dMfWXPu5FfjVvNHHnyuch3sdZB12y5+zHYk7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sio_read_complete() uses sio->pages to account global PSWPIN vm events,
but sio->pages tracks the number of bvec entries (folios), not base
pages.

While large folios cannot currently reach this path (SWP_FS_OPS and
SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation
is gated on SWP_SYNCHRONOUS_IO), the accounting is semantically
inconsistent with the per-memcg path which correctly uses
folio_nr_pages().

Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
count since sio->len is accumulated via folio_size(folio).

Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/page_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 63b262f4c5a9..1389cd57ca88 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 			folio_mark_uptodate(folio);
 			folio_unlock(folio);
 		}
-		count_vm_events(PSWPIN, sio->pages);
+		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
-- 
2.53.0


