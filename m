Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302A0C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD9A6B0095; Wed,  2 Sep 2026 01:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F9F6B0096; Wed,  2 Sep 2026 01:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF246B0098; Wed,  2 Sep 2026 01:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D22176B0095
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:06:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF64F4073D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:06:04 +0000 (UTC)
X-FDA: 85167635448.22.0EC4610
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 55D581C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:06:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THyxJrYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788325563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZqRtga/N01MzEm2VIK8xWzcS/KXDNFvjEktvJJ4jbA=;
	b=h1HRdCb5kNIJC4+FMa/9xB1FSXBdWnRFKcWPRhJNt46JSjuz6MtNeq+B0wLv7YtMN13seN
	6MROv/eKpoqLb2dMT4+jQ7veY8PVJufH54rK2A/dZDAXDhDCUlhkDynoR40+uKW83Z7z6q
	JJbEBDgrYLyI97h2I4fSTHk4w9Lwhvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788325563;
	b=zdluDldspVZ5t+NtLjtBLngoDdTqTfTGCBZGHL5i7RIAC0xcTfi1I8vuiTK3BISsjnaRc3
	MIUEcUqcBozW7vwBYeBFqgYMCPqktwF9Ce9SIli/WEOAiq8wSaS8OBy8xM7HIeQXMPfI/z
	7ng4TRw07jc4K8KdQlZgEOKwrmRFfbs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=THyxJrYU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBBAD600D1;
	Wed,  2 Sep 2026 05:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5134B1F000E9;
	Wed,  2 Sep 2026 05:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788325562;
	bh=kZqRtga/N01MzEm2VIK8xWzcS/KXDNFvjEktvJJ4jbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THyxJrYUAKI1ujF3wzlgGNVxWYaD0HfSyfSyFQ7/lGFr/74XPbm5C2ygoxiV5l8pg
	 W3FtDsDX2ZoVTCbeAqytFtUQxxynOXWnY1W+HgQr0RK1oLMEi5H57tmRurBMvZZnkz
	 TVSzLT4d4MurHoeRHYabmqlRR72mmm62FsmWaeQjTE89wQ+EloWPh6eM1BMxTuccR0
	 r8I7j/eRzfuAPxbHPDdlT39eZjqlHUdgJuPs7ZylQR2tZhuDiIDaE1hqN1+CZEUqdW
	 JVCCB4safmOCEXPfrAxAFLtoz40tt5hy1b6hm6txB7uI5ZIJpYGbk66Tt3jHAoMmIt
	 FYqZqU7xrQwjQ==
From: SJ Park <sj@kernel.org>
To: Krishna Iyer <kiyer@crusoe.ai>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap walkers
Date: Tue,  1 Sep 2026 22:05:54 -0700
Message-ID: <20260902050555.89912-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902025700.17975-3-kiyer@crusoe.ai>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 55D581C0003
X-Stat-Signature: piyb1t9b74n5wqqctyc6rkcn7kpokejo
X-Rspam-User: 
X-HE-Tag: 1788325563-495897
X-HE-Meta: U2FsdGVkX1/9aRhmIx7e35SIplggjvg7HFYbcm1Nm6djwob8MTK1lO38xyKt186YL/1nbVKYY225TFz8aUVg6R2p6ws7gUZtpTtrL3pMX9L7vI2hMLJ64IbzR879y8PoxscNbjO142+AT9wYqVLf+tAF0y2OzBhPN4OAdB35FSCWUG1YDiNfOhAH9Ci8R5b+x+8A7XW3vvMqSEO0hsy3WF2mrM3+s5jbFVpI4xoO6mBGEwB19VOTDZVqfw4XDJDQ/0Hzrj1Pho+iEaZzWzgdL6w4pbAAFQli/buNrLRfkU2SxsIHsKSCkRDzhiTRaZrKdz4wsS8KIvwBxVBD5W1glXsz0Xe05+kWKwxNnv8aj1YzZqZhbmZk0I0OHckXBN/hip9LIQ3w1tfJFUTL45jGUG768n4J0iy2rqqpcHQlL19RQLjWS1rlXhTPKnHjmJGeAtPUSHLpgvCoQZ8vHozHtlwj+Maejea57Gvq4+5loJ0pU5fznnNeNwMbWDZ8qF1NHaIzCj2yE+h3kJku+4ywoxZKLJV235Rds64SEQmmmFg/pf8f2ZAbp16YNUN1hS82S5fMywCiDupNu3XC85Vm1qyb2yq8eB69tkEZmJ5NNVVRZ6XPqF7JL12GIgcA0Mt/JrU4Y/fEwg08sEdxfwbqHGNNiNDwHTwn1Org2hL2qgEgs+amW1pULjz6jL3YiG/7wfWwxdU2S42ANYHifGyDLZqGOqIoL5fLOFhFJcUMUNJABC+2wwsdtqNzxZhHa9ht4s+RFAF9k9lFLBVpFCXmKL3KTyqPo/aVbGN+6d3zu8yQYP7I+GbjpZ/fjRyF+BDFszvgnN4Z4+WA6w15YO+3OaO3fhfaORbglaG7rVLJ13fjWG8JoxfEoXfajj39C3ia+C6nEAmQDRUN/klTOjcWwis/0N4hLlQ6WMYJpvwZHkqdDwZhJMpYLMGAIes8bwC8yqOclzr4/59tKHAaPpq
 m710CDox
 M6UCZ98W/NViqp+fhiJWv+tfuIZRaDIX1YkPeZUdRMTqcAfN6oky1vGOr+B+D7JGqoYXaoJfg7iEWdeihueV4lqPNs6ziVd/OZckiyG93Us5GdLN14/7U/JutMX9NCH61UTwn5oqHdjwAwSG9Ij87IqtlHZGR+0XchzTOhgKijNcYEvvYVkXSh3x2c07uPKiuscyiMLFK7wDlpTpVHTjq7IAg98HmvWsvKHzSnMMx+A4QEps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 19:56:59 -0700 Krishna Iyer <kiyer@crusoe.ai> wrote:

> damon_folio_mkold_one() and damon_folio_young_one() assume the folios
> they walk are mapped by normal PTEs or THP PMDs.  When the folio is a
> hugetlb folio, page_vma_mapped_walk() returns the huge PTE in pvmw.pte
> with its page table lock held, but the walkers treat it as a normal
> PTE: they read and age it with PAGE_SIZE-granularity helpers, which is
> wrong for huge PTEs (up to PUD level), and notify secondary MMUs for
> only PAGE_SIZE of the mapping.
> 
> Add hugetlb branches to both walkers.  The mkold walker reuses
> damon_hugetlb_mkold(), which the virtual address space operations set
> has been using for hugetlb aging: it clears the young bit of the huge
> PTE via set_huge_pte_at() and calls mmu_notifier_clear_young() spanning
> the whole huge page size.  The young walker gets an equivalent new
> helper, damon_hugetlb_young(), which reads the huge PTE with
> huge_ptep_get() and consults the page idle flag and
> mmu_notifier_test_young() like the existing PTE branch.
> 
> Locking mirrors what page_vma_mapped_walk() provides: the huge PTE's
> page table lock is held inside the walk, and for shared hugetlb
> mappings (the only ones subject to huge PMD sharing), rmap_walk_file()
> already holds i_mmap_rwsem, satisfying hugetlb_walk()'s locking
> requirements.
> 
> This is currently dead code: both rmap walkers are only reachable
> through damon_get_folio(), which rejects hugetlb folios since they are
> not on the LRU lists.  A following commit will let the physical address
> space monitoring primitives opt in to hugetlb folios.
> 
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

