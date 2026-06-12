Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F05DDCD98D5
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3386B0005; Fri, 12 Jun 2026 02:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363156B0088; Fri, 12 Jun 2026 02:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252A66B008C; Fri, 12 Jun 2026 02:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14F3B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:46:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBA681A03A5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:46:07 +0000 (UTC)
X-FDA: 84870325974.21.356462F
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id E86494000E
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:46:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SzWq4ivU;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781246766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqDd7CCu46FQ8ONM7WEjZvNrKJQRgFQen8hVZWzw+EQ=;
	b=UuS9r2DBW0KUnZnp65eSOBCSs/jpUE6fze2GMBfGcRy9TdwPjiuSsLQbevH5KUjJyCr2tR
	YjMqi5Rv9zKBwlLFWECRv6BdbGnDp8nL/N91LkpZ3NYIzlTGDmNUyYtKI1Txg7DgVta2fq
	KDArhI1OSW6QP+TA7m24O7VLKKENl5Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SzWq4ivU;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781246766;
	b=GBrG6Pq+RQ+j46ZkfoEerb+jtkrjESlDDy3Fd6zTcMV3FIvrcl+zl0cogCrdI2GXqCA6Yu
	qcQzzuZcD4vrqOhdcdVfRQOWq7jwJjFgcooj4MxBpb5ZuskLIU/cQwC3z39gFyTRB3cuOG
	BKkGyLEMzuckqoItNRWgmjVI1Ki1Img=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781246761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tqDd7CCu46FQ8ONM7WEjZvNrKJQRgFQen8hVZWzw+EQ=;
	b=SzWq4ivUXVPN4pB1Cpf3WddSPQPx3UELf13mNC3wAxXbwawJZVYDDZDLu14G7G8JvHS8Lc
	wZAh4erOzArQKan9EQ6jAcRPJ+0vZTAF4010mx6q08ZlHofVAmaxA+4BcnKo3jeKlnDtvY
	higrliLn8LnqYupwpUOBVbAgVlYY28I=
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	linux-mm@kvack.org
Subject: Re: [v2 11/16] mm: handle PMD swap entries in non-present PMD walkers
Date: Fri, 12 Jun 2026 14:45:50 +0800
Message-Id: <20260612064550.54968-1-lance.yang@linux.dev>
In-Reply-To: <20260602142537.198755-12-usama.arif@linux.dev>
References: <20260602142537.198755-12-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E86494000E
X-Stat-Signature: nrpsc6msyzbu5panwka5gz9owc9skrpe
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781246765-808414
X-HE-Meta: U2FsdGVkX19VZm/S9+eWKLkVnzaY/aefvCirBWXLV406lwjNPsa66gpVHN4XfSKz28ZxiOmi932Z+BPvlRhhvS6gC4OkJRKjt4krWOs3k+O6RrPdIi8ZnCuMDrLeHhbree3mvTW9BsZogQo+AGKe6kNJy3CVMMdO3yx2DZwe49rtBrDAsew3wvsngKHnag26UHMxERknOV2++Ii4RUxVpcH2AzMkd55mH+2YAkRB0GeMr38IFzzUQbUzlYL3tiBZLlcRewQOoR8KZoc4ZcXTr0spf/9zl64Vu4JHsGCbKcChbyncdkIEhQ5dYOQ1wUi/i2puGsQSYnDjVjkPnnrt4oYUmpyeCRUuuzZytDiOtVRR6wZ/dyK15XrmdPcs/vj/H2OEFTOOzn6BucErMs9bcR/NLicbU3hW/owajnMrb90IzQYAZkHYgxOjgumEz3sZCYMyu5JSKVnryQnjw3ma2QHtRZ8MiTk3Lvy5SC++1h4JqV8r7cWWI3brJj1dpuOP0DWoZ9N2P1Ynog8VvWOCU6bqjyiHlV5NwAcOEHcNJqQK428PzC6V3lWVp9tigFUTTgWQFPW//GnDzlT7mZzMqOf7e+VASGxv8MqaazaBIIYdXWRjkowu820LmodClQe+ptl9eXn4cZ+tN1YfgrerISDGObyYOj14ARh6m3O3/9/rsK6EDa/BVFReTwwRew4+MpANHJJFNzoTrdXypdEE/z9/X+oj5JhQbMi1J/hs+cVK2Ifj7n7ayysO47BtRZTemCfyCKdl4ATXRUjBKhjG5RVRwyJ5XQsNYARKACOfzxhHP4yGx6WpM4RR0HGq3mX2c9Edkm+1o119S4fs0F59BUyTRq3YepI4Py9NAB5ymlIW9lJNzMTNtz1oi9cW5QpcupXt1BawJDgHbFPgLxh+hP8ZAO9q5ckQuVjDW6FUJvgG1SG04C5u+km5w4RoOvoXTtQrO4U9pJQ58Hs83iw
 Zt7xUK2I
 42b0j1ZlNNcsnk4KRlmn9CYz6rvAgNULsOxusgcFYs1xLGdPG/mLKM0To0Ewl8paG2AlFaZ6i/o+SYilrzHnx4bRdWnrV+M29Tb1o/kCRklbygWl7LijfqArUAUZBo1u+tgcVtxBpLOQEzVR7bM2r8CY9UI8g7PcvGc/k1XSbKgdWUib77CXFURhHB4dpuyXnoJqOurf3GMEvNUoLoPqINeMkbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc linux-mm

Please Cc linux-mm next time. Pretty clearly MM work ...

On Tue, Jun 02, 2026 at 07:24:19AM -0700, Usama Arif wrote:
[...]
>diff --git a/mm/mincore.c b/mm/mincore.c
>index e5d13eea9234..3fee8a7b9d9d 100644
>--- a/mm/mincore.c
>+++ b/mm/mincore.c
>@@ -172,7 +172,19 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> 
> 	ptl = pmd_trans_huge_lock(pmd, vma);
> 	if (ptl) {
>-		memset(vec, 1, nr);
>+		if (pmd_present(*pmd)) {
>+			memset(vec, 1, nr);
>+		} else {
>+			/*
>+			 * Non-present PMD: migration, device-private, or PMD
>+			 * swap entry. Route through mincore_swap() the same way
>+			 * the PTE path does -- the swap entry covers all 512
>+			 * slots, so the whole vec gets the same answer.
>+			 */
>+			softleaf_t entry = softleaf_from_pmd(*pmd);
>+
>+			memset(vec, mincore_swap(entry, false), nr);

Looks buggy ...

That assumes one swap-cache lookup is enough for whole PMD-sized range.
I don't think that always holds ...

See do_huge_pmd_swap_page():

---8<---
	folio = swap_cache_get_folio(swp_entry);
[...]
	/*
	 * Folio should be PMD-sized; if not (e.g. split in swap cache),
	 * split the PMD swap entry and retry at PTE level.
	 */
	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
		folio_unlock(folio);
		folio_put(folio);
		goto split_fallback;
	}
---

it handles the case where swap_cache_get_folio() returns a folio that
is no longer PMD-sized. E.g. because it was split in the swap cache
while the PMD swap entry was installed. Then it split the PMD swap entry
and retries at PTE level :)

unuse_pmd_entry() has the same fallback. Can mincore hit that case?

Maybe the comment right above should say something like:

"
One lookup is enough for a PMD-sized swapcache folio. If the swapcache
was split, check the per-page swap slots.
"

Hopefully, I'm not missing something here :D

Cheers, Lance

