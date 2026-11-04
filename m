Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D8E606D838
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VCsr8u1R
Received: by kanga.kvack.org (Postfix)
	id 1E4016B05B8; Wed,  4 Nov 2026 06:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194986B05B9; Wed,  4 Nov 2026 06:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0842F6B05BA; Wed,  4 Nov 2026 06:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E135E6B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:07:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F0B41C3FCF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:07:08 +0000 (UTC)
X-FDA: 85397159736.15.4D1744F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC48F180009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:07:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCsr8u1R;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fo9bEsW5t26Hc9SH0ejPTKShLNAh7V21GEp0Jx6py20=;
	b=8R9IpFUmUjNzlX7vfm8I0UVJYYuMpLDdKCBZWulA8GeDQhVJsaWZtzIwnzVU8ReEmgaE7H
	EvnX+Vbp8HElwysLu+4BtnlnWXv/t54eZuYtjJ1REvUM5B9yOH1WSHJkrj0fjaigU0nQcb
	bYnJWPL/7cAqtIokzIG16ytftul1ODo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCsr8u1R;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790426;
	b=p8Ig5KhAJLXE69RyV4Mx0YugoZRsBT7i2pAYKpSkR0GTf/lwS73CS6WULn7jdSvmNGQ1Tg
	6Uu16w4CeA956o4lIdUJBWMNBjlsX1XpSX2tEz5C7mjdtO3uf/ob7bJLdqyUkc439aaOEc
	TYax9dTBrIFpmFTtKuwTxsBdcZdOo0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 326F7447C8;
	Wed,  4 Nov 2026 11:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834131F00A15;
	Wed,  4 Nov 2026 11:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793790425;
	bh=fo9bEsW5t26Hc9SH0ejPTKShLNAh7V21GEp0Jx6py20=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=VCsr8u1Ra62dW4YSWnEHydsTVfubqQtSd11B+fhV37dsyWPqT3agEg+tjCNIJ/KIv
	 7iJWhJaTa4fdDb6ogncyOdgwRiK7QIHSntU/yQue6D3w3oMfOUNN/Gy3rt63L2Kdfb
	 3QF7i2wbhHMb9KoLC8tpOcZg0qXSDthXEGEj3g1COl9rrvGmqMhfZDi/UEFj3QwAGE
	 FMb8DnzAPkyExiRjQeYcGtL9YboP086ZsmOlNKzUf+iUgL0//lKks8ic4KnM/CbSex
	 M2EhPZz/JnXJZkt+L+/V6pURniCYTrifPqM3TDZ3mfySnw2RDeLfxX9othgyzdVARY
	 AmIMTrfBp1X2w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261104023510.260766-3-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-3-songmuchun@bytedance.com>
Date: Wed, 04 Nov 2026 13:06:58 +0200
Message-Id: <179379041864.1868318.16588818729228128190.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 6k8pjw6piwgcm6sefkiindyuc5zx4ngg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CC48F180009
X-HE-Tag: 1793790426-180649
X-HE-Meta: U2FsdGVkX193HdPIRPkzdASte/5rMy+Kz1Kes4CdPfeOjPNhTOwzzaxAlySSYM5CidYGHXK2ZYGruMj2kTQ5P/kgaqs2ZKa73BBMfwVvSD0eL9/lcYG5euohI9kH8PU/aYFkJO8jjLkvd5BH/sN0tFtfT7QQkbe9MiFLpaYdI80NrOE4OyCDihkk5wyUUV2XK28VNVWExjS7suOaVYE7R6tFJK2KGx/jKyuDclZ5j2nRvIMeSm7Kzn7iLoPhFoavTs3qJ4y0Acw+nPtMUCfZ9VdWlk/SjtCJDyo3L6L1N0by2Uqtenns9Rn/D4RasWZRdv8w9KYYi8iquhltzWjts07Go5WZbHlS8wBLlwbiRup1lkLN0Yc3uCuFs61rf7AjNbtIJz8xRI7QOquCc5cPkDq7GdlYc5K9NYAXqqEc5pvuBA4vJylantw0aHMgHQVuJlpGHfwLN1fuSy0tcSNUbBU0xPUhEUftMhqa769bjRQgWya4zN+LVnGWrFHF2scAXv7xzBkjKhJgi4JvOSReqBGXMYhB5SuNnZyIjpceHsNcnVUTNuvaDhRN5kM6ZDn0fSOoKZNUaTDsgIuQg6HiiAkNSlHYy5peYA9vcLK2cRxjHlPrl4YSqOtJ/7mJRpm0lF2ekYM3SJaEBzS3Lf7WxAGbkXUYLoKUA2fk96YNyZADXJNTQRNHyjc3KQHfX4pP8mYLOyITbCaoZHlmkgh1X0ArvBl4HT+QOw0xM+l+8kNB+kGvF44CccupWf89bwkJKJqtHGwndbxV8mb0IZA3Lgj6OHrIapdqp0AJScw9d3R6spwNugRasHCdTegBvz2iEY4tzfizpjcMj7lBM+TEeKbUvW3+n2iz+l1cVN9prXDMxDZo3FOHIlUzAfkUbEyIjeOWVbBSeDq6UBwUbDLKcQPgNkUdNVtlkgZeE3s+i6cs7t+1urgu2fL7/n1OlNOSe/z36U5/M1FKPLSmZi0
 zwy6Oy9j
 PYDhFAlux7oG3Ibtb4gPIwmP31OXHVFA7/QAzl7WKiT3skCBYwDS+0pdxoRLNyVuM3XPq7T3BQqgWDqeSl11YwsUBPc2MTT8BVWoM9NpCZiejCziFPuKyIsUKZblLw4MwMO0jbjz9TgMBb46+0/d5bD7OkGiNTYpmowp+o96yW2h/TKVslwNPccYito4JHn/sXHzz8lwLEaJhHScFBacWJAAzuc2ts02+cAUE3CAnct9sapFcarpQuA2XowaQ++jT0LcRk9KCQiQYsy8PD8FPhtmWrs3iHb8KLUnjFP5cH77IOZASI+UfL6LLiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 10:35:00 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
> describe fully independent choices. A split-only walk can defer the
> PMD-split flush to a later global flush, and a remap-only walk can
> defer the final remap flush. However, when a PMD split is followed
> by PTE remapping, the split flush must happen before the PTEs are
> changed, because stale large-page translations must not overlap with
> new small-page translations that map different physical pages.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


