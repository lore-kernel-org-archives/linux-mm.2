Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6ADCA9EC5
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 00:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758B06B0088; Sat, 10 Oct 2026 20:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7098F6B008A; Sat, 10 Oct 2026 20:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FBD6B008C; Sat, 10 Oct 2026 20:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DDEA6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 20:31:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56D2EC05BE
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 00:31:07 +0000 (UTC)
X-FDA: 85308465774.11.A997A81
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 89F7F180002
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 00:31:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=REpdA0xW;
	spf=pass (imf24.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791678665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ip1A6CngHiq2WamXxahtB2LL7CsCqEsAKWuGP1PVcRQ=;
	b=CWg/oAKuAkvAotrMea42gSrUuabmcFphpyXm0paLgCpwkHsrgE2e26VgINuvVMUshVXU6q
	0PDu+yLdwyPjR7STKDmwp0sGpdQimsExVH/8nPP9shepZKm2nTz7T+TwfB9X+49WLr7ac4
	wkd4JbAXMWyeqCbUnfpHqTUsdwChicM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791678665;
	b=7QRWNMFR63ty65ja1NnW0rH9ZztYb8kxeo8BNNwtaR2QvxVU1ZOWKRR16sehIrtZz/FMcv
	pEzXsP7DUYyHYbfMwkV4iPchkPojtx+gq4nZQRBh22PGO17FA3OwfMyuQGxZX6tj7zQU4i
	SUeHXlszki/B83gBCpFV+w8SWPTNg4Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=REpdA0xW;
	spf=pass (imf24.hostedemail.com: domain of skunkolee@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=skunkolee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so321888a91.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791678664; x=1792283464; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ip1A6CngHiq2WamXxahtB2LL7CsCqEsAKWuGP1PVcRQ=;
        b=REpdA0xWCaelY66Ng2Or2zZHHlxZU3N5kFkQoC1WEIksX/DeVzkEf244V9ZYcLFLoU
         emm33rQsJpLXbB3HMWqhCx/lwV57l67bMeXx4N/wvLrHszcPntKt2mjxgRcDHZyVBVAc
         KsstSnuBO/ZIWwYdkYsSTwFHk3RPJDjklSSvEJC9sPLVCy42oMiBk3opicB1bnmb9S82
         wyTqn6gAHrZP6orMWLJucvfdHaLcI58krkpjkhsHvHHSD6EgkfuO9OSFJLzHcPeUIPHj
         Cx6vGB7QP+EFPj5+SdzuRt8elkyDlkQjOVk3l0qLM7UWxC+qxjIZSEw7wyy9OpZWYq65
         DI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791678664; x=1792283464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ip1A6CngHiq2WamXxahtB2LL7CsCqEsAKWuGP1PVcRQ=;
        b=RYBTEC47/2k8rz1m7gZia9cjavMpuC3xllFon8kICJ8kdXao1iXOpkNuQ1CJgingbU
         vkxjkAh2oT2Y6P3nOWQfGi9V8PJ7VWUUWo/MksujVCh0JmsPgZyC1S8qWRVK7BSze4+u
         f1PnD9lYF5B0Zc8j5N09bQuyFa2Q/SpIik555I5AV1Ys7Et65v+hc7vgSJSn2Iqbelme
         YHxIqNhXiMFQyjt8z7CskCtu9TlKD2f84Dm9FxnUsMUsBhFhJJxvB/7yOV2v0uYo9Zno
         kus7Qic6iWnvSKTvf33zOVXFo5QNG+aDIvuvD4CLMAkZs9nRm0Lui9rzoEYjpj/08dDL
         S9ww==
X-Forwarded-Encrypted: i=1; AKwUvBzA0lQseW8EBJQXsH4HsKPq3+fbuLkd9V+8lU7tRTIz3laMN4u9W5MoG9yiZhhxLkDteYV1E+OqQA==@kvack.org
X-Gm-Message-State: AFq9FYK3PLnlkoNmzVaCTufgmx/v0k/MKD9M3pwTtKb69tAARmh41aQD
	PbyjioHHlGZE0L7hyvPswoJOLhF6g5kgbetPQ4phG36unQR2KuVJ8yfR
X-Gm-Gg: AYBFou0yIJVtjipgOE1U7tQRUT6OpV8X6XLPIhQd+u29g77wA2D3NPb5mV+Ejj0/T3J
	IigfEeLHRelMNySPmEIrqDwlnIEZdpa5cLwSd38qc+DyEtHcE5Zygk8rm+hcQnwcERt6g/+NV78
	lZojpWIbXCXW7EtnFc+EA210sbTqt0DeJINsCuThDgEmEfcxqHPLxoEm8JOSYktDYy/4H1FyQvb
	HPrdAw8xZwXoxqxTuAfzka46MgrW3To5di+zHYvxPIw1N7xuNhTPf+RY5lUyWzb+fyaqynSiNy7
	PJ6ls3PSM3mFIcZ5eXUeqKhnzWYZMlFbFKmG6mbSryvVpe6WC5+3wfO7YjZWk2po4DrjMvanGkJ
	JROU022fHFXc7b7p++HF8Aa72xf6DPAS1h9amrUsDZj2vDximV9j0OgvuKSrErV8gTBe8r+IDgu
	BlUQOVKmHroLKLPP/lcxjh0Qf4iBAcX/RCbhdg573LEGCpqEIWqyki0RUHfohMXmBwpDgeabrnr
	VlMZONPz6WkHYIiswVzUY+DTz6/vK5XailJl1hMpm6U9O21XTeA4qgBGBADBKA=
X-Received: by 2002:a17:90b:4fcd:b0:3a1:8b70:d46b with SMTP id 98e67ed59e1d1-3ab3ad2b1damr4674660a91.42.1791678664191;
        Sat, 10 Oct 2026 17:31:04 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::a891])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm9681761a91.16.2026.10.10.17.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 17:31:03 -0700 (PDT)
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
Subject: [PATCH 1/2] mm/cma: fix list_insert_sorted() ordering
Date: Sat, 10 Oct 2026 18:30:58 -0600
Message-ID: <20261011003059.169430-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 89F7F180002
X-Stat-Signature: cxyd9ci1prxaq1i5iwcputrtuyc6ki17
X-HE-Tag: 1791678665-691184
X-HE-Meta: U2FsdGVkX19dQCmNSRh/B8cylec/BsZNJPlzDujitHBh8F33d5dUUdLGshaDAI1IssrvHIFsyS+I0zGSAbDp+S+Fjl6o4EHgJ4/G4J7eNJ4lqqZj6lTI2gIAw2NaV1WNvzclyFPgMYdtku6OVNFLSk56rloVxiiYVYr1IgqAsbGjNsjjze9WlgxDxkvwG2FXu3ooWDVVh/VJpUmqSt5JFnIWyBo5tsLe6wsB0ElbyhvP30SSu0RMVcABZlFHtlw/j7OHdbnvuy15up7sQvgP/1RHejlW9esKamdKIzK0aPtdD1oBdOsYy96G5h6MjnSIevjjujf0L88mPU2Dr0eDby6L/mXsE46jznYrAk7WIAA1QM6a8foGEW16O/9k4sCsXxa1+qtuFcJtLHOsnU4DQYpHoXuSEJ9i3y7AJnFdRoDp04SQok/Fx+aGLrIUGPVMsY/CdfkqJdIwPrsd2Ku0RX3SVACvHclYqQkZV9yx0Vsk0xPP4XhF9Si49I9JF0Mrrbdiq8aBvFWgbqT4XwdVRuv3INp/J0ZHCEWbLXitNjGf7GWxf5Mdz3WwgSuZ2IvUY6L9t2riev6zOiz8WdJurjoHWZwobjQ10WNdK8MVZkvdTySK/HPnedW5utTT8mxHU2UCFuQvrt84l+00mK/86xzembWYLknnbBK3S9ZBwHh3Au9a0sZnmnWCM+VZ3c0cqOhdx0vCWusRpEkn9SMH++JGbMZS0RhsH+m/4oU8XdeGzFo90YiLCJQ1Kwesi8xiW4BlHd+qkz4sERGNljGAdMYNV6PoZ4H9/gRj+9zXZ+GSO3UXB51KknpHsLaQXTEj1ax/rGGbwkR8Coc1vKydGvr/uJB3na8PSmQvWCdwa6FM1A+CaTzZCOISOcxAgULdhHIi/39z9tiR+lO1GylnbdoBfIGkwwYMnJVN/kW2jpbuEN7FAr51SLGZIFAU5w4JKw2NL1sNwWdK5kAjj2j
 LYhLQAcT
 dojHofgIeo/g2oIvwrCYNQdMAB0jtqhTxZV5OIw7VpiOJaN0QjS2tXz5KeiUWZl3/0ia5lwydfGvH9OX88aFsu5EI+ow0fr24BTJQ3cY+2tK93JO1rZKzfndqqDpwpBgbLChMbJz4GDLgBp52doLiJ85imGvJ/oF0SJt5f1MqELjpmr0TKthtVR9i4TrcZOGInPgdZ/FZa2/QnuLNwRFRQnVDiUranh1d2RfaIdKYvqwjMqOmGICUwOoY+Qex3b9nNgNwLD1itJKF1TDsuahLN2+BvPtOR/SSbYhKwkf1VHMu9KXl3o2SG2Xyx3fRtV3BI1qxiWpHgiOuTCIBfPDxxAxjjdQ1BrfV3zAEpiCmrSkaUUeXGtRW7T1Xxb5ZSZySEGEXMTZUBWT/po3CTLphmZNCXf3BzwGplptXqmoIEAm5RzFLBc/1YHP06wQaJHK3f+ws8I4/CTzkthqeQmTTlp+03osjIrSfEzeuhWe9qSoitOXCTsTXqMZxgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cma_declare_contiguous_multi() uses list_insert_sorted() to keep its
candidate ranges sorted by size, largest first (revsizecmp()), and by
base address, lowest first (basecmp()). Both comparators return true
when the first argument sorts before the second.

The helper stops at the first existing entry for which cmp(entry, new)
is true and inserts the new range before it, which is the reverse of
what is needed. If no entry matches, mlp is left pointing at the last
entry and the new range is inserted before it instead of being
appended. With revsizecmp(), inserting sizes 1 2 3 4 yields 2 3 4 1
and inserting 4 3 2 1 yields 1 2 3 4. The first range inserted always
stays at the tail.

The caller relies on list_last_entry() being the smallest recorded
range when deciding whether to skip or replace a candidate, and on
walking the list largest first when picking the final ranges. With the
list misordered, a candidate larger than some recorded ranges can be
skipped because it is smaller than the first range found, so the
function can fail or reserve less than requested where a valid layout
exists. For example, free ranges of 4G, 7 x 1G and 2G, in address
order, with a request of 12G: the 2G range is dropped instead of
replacing a 1G one.

Insert before the first entry the new range sorts before, and append
when there is none.

Found by code inspection and checked with a userspace copy of the
helper and the selection loop.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Cc: <stable@vger.kernel.org> # 6.15+
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 mm/cma.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261d..527b2d894f3e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -348,16 +348,12 @@ static void __init list_insert_sorted(
 	struct list_head *mp;
 	struct cma_init_memrange *mlp;
 
-	if (list_empty(ranges))
-		list_add(&mrp->list, ranges);
-	else {
-		list_for_each(mp, ranges) {
-			mlp = list_entry(mp, struct cma_init_memrange, list);
-			if (cmp(mlp, mrp))
-				break;
-		}
-		__list_add(&mrp->list, mlp->list.prev, &mlp->list);
+	list_for_each(mp, ranges) {
+		mlp = list_entry(mp, struct cma_init_memrange, list);
+		if (cmp(mrp, mlp))
+			break;
 	}
+	list_add_tail(&mrp->list, mp);
 }
 
 static int __init cma_fixed_reserve(phys_addr_t base, phys_addr_t size)
-- 
2.56.0


