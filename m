Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C844C79FBF
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07FC6B008C; Wed,  9 Sep 2026 13:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFFF6B0093; Wed,  9 Sep 2026 13:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C4E6B0095; Wed,  9 Sep 2026 13:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF976B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:11:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDEA8A3073
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:11:11 +0000 (UTC)
X-FDA: 85194864342.08.0372D5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EE84940008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:11:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VmAksmPa;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788973870;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKotk9/whV3BxhLRUceKE5tMwWdNG7b/AXhBJiB9tH8=;
	b=i1VKuVlTK4RYx0/Fq3K4GnFph+3Js91EsJshaU4yAuHq3G/2pMxaR5Xmy7gzkwUlGooHEd
	Mx8qPokUGBMGArb44TQEC75/Dv25ftKVwRnhcx5p0I0mOp7jv4tRhDhTtGDQzXMmwXl7np
	e3stf7VZt+bFn8YWSS0WEmE0QD7fT58=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VmAksmPa;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788973870;
	b=6ZfRt/0/GYkXFQOtpK/7TseIuXsONNr8nuu87imUpDShWd2i55OqnNGGUxTZr+N5WL7+lY
	gQXDS+51s98Lqn3hgZzJq85fnaduGX5xG40eTN47dCBrUpHzLqFBnY9/fNL6mOemljRr9e
	c4InVtr7+ce/KhVG30I9tmvIBEYJ6MQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3305F4450D;
	Wed,  9 Sep 2026 17:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 109AFC2BCFD;
	Wed,  9 Sep 2026 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788973869;
	bh=5nP3SABh7khN0k7YsgDDCUFgWm+k/354IDRR6uf5BpY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VmAksmPaODm6zzhe9HR1j4cII72lhpikhFZxWcW/l60t9hnfbxjdgPSMyR425+YyY
	 RFLityF9xzDPGTya3J3lhi8BZqxxY3POBFMjUXKz6jBzdntVwlpPCxwdWyytdlklqz
	 aH731ahR6rjt7XR4sWl5JIfKAbMcnwFL296V599iAMbwUNsGshp5d5DPPANSCZN/wt
	 KpG8OXysJllfLLf8h3a1kogIxyOGiqvu+xEm2mmqxDZhtpEyzMtXalfKvghWSfseJg
	 0BeMjeWgbx+s6Ok5l29qjezQFysz2zeUNdwPCkNJv2O0uAFVit3MNihZ0NAQ7kpvfq
	 BKHmXiqFAjnwQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E47E9C79FBF;
	Wed,  9 Sep 2026 17:11:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 09 Sep 2026 10:11:01 -0700
Subject: [PATCH v2 2/2] mm: hugetlb: Drop refcount before freeing on memcg
 charge failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-2-4b4a8a19a7f7@google.com>
References: <20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-0-4b4a8a19a7f7@google.com>
In-Reply-To: <20260909-hugetlb-alloc-folio-memcg-charge-error-handling-v2-0-4b4a8a19a7f7@google.com>
To: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Peter Xu <peterx@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, jthoughton@google.com, 
 fvdl@google.com, rientjes@google.com, vannapurve@google.com, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788973868; l=1354;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RCk4FUhHtfR9+WkuFadogmxvoeEME9GEkAvOLYp7r3U=;
 b=gBpcMiO0hmn63lrRPn7N0MR5W2dOzYOn5xT2nETVl+UJrZXPV8t92Dbe0aMohlnvWSzSzqKO6
 Lcdbw5LVxr6DJq6Hl54+GpzcN4ODPHZbPRq6605zAFWp8ctP3310CTf
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE84940008
X-Stat-Signature: 5pt4tkztc4nuitpjyjxhzdt668m5ytn5
X-Rspam-User: 
X-HE-Tag: 1788973869-626158
X-HE-Meta: U2FsdGVkX1/RyJQJDGHI0MGMugXhwoW1MHY3YdsTdq2Hb4k0zifUdPkKI/rUWFRtJuBJwf0SktwIA2MCgfr03JxZ5yB4Yd0t1hmzvt68GtRKsq1W95UMyr7AvLlggCN91NEVjbY31dqGLrUBupGAvqzTY1mUwqJDL3z1R2a1b/7OD4iJG6jz8vydrs0qIBzZxZcAo0Wr1qXFs5hp44T4lHU2O4T6Pg/BJnOj1mWAWq/aY9OUBhl812HG1WfJrSnHpYUJAwhic8B16dg7QO46B8TPWhdEFqvCNpKQ8v2g0hvRyU2zc8wTdMGbmawkZV/aIIQhmmr58eh4VzpPEl8w9sVnZypSlE9BFeAB9ynasBVdHpZoYzwk7e4CjwU3QGQfFp9yAqgAnb8o8wDJBmMIDRY+8II8fL2H4qequmLBEv1ieZxfELJ8VbYXEx1aORSHSyz9kFKVzyhCH5nefhDy17fSeATX5IbspPoYAji2hxWEwR1Pp8LM3kuPvCcJZLxHSFtHVzEYRyXuCocefqt22NtvIl+Row2Gi2YEVQP40/OhQS8C3dGCond9nbUKQaltwp7qUzOlp729EUMOHGPydul1n20TLzekCOMkPUWX0mJ8R/xqebthS2GDS3v0v1CfEPU/mnZxD+gN9DqskJNR0B7CEqXyBPSpWxLX2MJ/ze69B8itRAWoPpsCUUzfGdE1VVArWdZPM1LhXUcv6lZWMx+DNbtJjrWs/CEqjkmvrLsYe0iy/7PWZiwo3LPSwp72i+pxohRm8lOPfKmRmiAi3apjf6Nam3lSJshiYS1M8cMO10xjj0NURuax0GiMZ0UezkfX5Jo6H5peq4J0NfTazqTenvcwBNnAR8Qd9NpAUpc3aDQmd6a3M5B/idW2/zWqPbB2NqfEl3ONR7F3PzUEwYcCqU0dNzd214PPv8sF49LQbGOt3Az43uINljs525ig4c8uuof8uuTT1S1e4ds
 CnLmh4Ey
 sYiToVU2KAgiPtPQhldOXI10vFT3gIUiiX6HHvQKr3FxC7BqhRFpsFVgu5dVzxb14BhFS0AV3FNuF6oNN5r6RqGWV4jxE3spb3/8LcwICG+eYfTzus4DYJylzwJ4Ackxm9O7ClVzqQQw1tDwZqNzxjByf+s82Ga/Qnw8BqQxVeNJ49HQ3Oebq8NkzKCigVg8wNjjND/nBHbDQ58G86Ox7fiiMEHgHfLeMaLWhFstS6oyYxICzgtY2zm5EAjBwbcP7ALCI8olxhPLHCXNaIXO5DPcf9bpJxJM3O6776WfkuyAyTwBO787A+21LoWnRccKVShJAzyYXuOu+Bf1G0FJJziNZVSqTRSmcs5aW/qwVGMQKuiyuGIjQJSAWYT8ET+17yNQ+8h1ZzHIoGYINfVGzDgoyinE/K99uoRaKaGJ9kI4a64Yh8k04YNiIhCtM7FD9wL1IOXX35cHRBF/zsqnEaTLkwrTDzYyJy9sQF7C8iz0ijQ4E5u4f41rAsojxL0BtXQgM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
its refcount set to 1 via folio_ref_unfreeze(folio, 1).

The error path calls free_huge_folio(folio) directly, which expects a
refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
triggered.

Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
the freelist can corrupt allocator state later.

Use folio_put(folio) instead of free_huge_folio(folio) to properly drop the
reference before freeing it.

Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 522487d341841..f5b853a5377c2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2891,7 +2891,7 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
 
 	if (ret == -ENOMEM) {
-		free_huge_folio(folio);
+		folio_put(folio);
 		/*
 		 * Skip uncharging hugetlb_cgroup since the charges
 		 * were committed to the folio and freeing the folio

-- 
2.55.0.1007.g17ff1f9808-goog



