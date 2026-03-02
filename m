Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38577D58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9765B6B0005; Mon,  2 Mar 2026 04:08:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924B36B008C; Mon,  2 Mar 2026 04:08:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826DC6B0092; Mon,  2 Mar 2026 04:08:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 727B06B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:08:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C8BE1B8FA6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:08:07 +0000 (UTC)
X-FDA: 84500546214.28.299479B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 632AA120006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:08:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxdegIGr;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772442485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqA8pWrLTn2daGgqxW0mg2qM3wHa7RtaBj9mNTputgA=;
	b=GKSlLa3S8lWD4PmQNvfgz2Tjkt3qfolpUs7rQ3z7evlsW8hQs81xvwXst60ENybTPafX6Q
	nGCSN2qWnfENLnRyBhKvUZioyv26+5HLMYOOOzjpV6XOr6zjrGkOm/zdBmE57HvOlPcbON
	NOrMEh0WEQFDzKViAkajZDoI2tY8kXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772442485; a=rsa-sha256;
	cv=none;
	b=S9+9d2w4JrC4F7ZY4T8A+C4iuDgi823Ekqc88xp7AFg7pnUhS2dnzCBnMrIYFA9j/CtmMb
	x8F8Q3WaaseSWc5DdYtnCfQLl4ygBYpkDoF1XAVHa/uszFhJFrlAgnOrdQ7lcKlZT2FKz6
	CI0KLMLDU3sD2cnoJ1kT54A00HZ/k+E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxdegIGr;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EA1660018;
	Mon,  2 Mar 2026 09:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12D2C19423;
	Mon,  2 Mar 2026 09:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772442484;
	bh=WKix1w6VLBg/gDg4vRJkY+zCH4JxsvUzp+EQmAzwonY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fxdegIGrNkd+cX69aJMFxp0N5Zvug5H74CNpP97ZzYvt9YRpInSubQ5GWJkZ71rTX
	 lNT7GYrcfaDXCfN10BeRSSsNGMy+o89TQjbMDhh9oZZP1rK4QN+3hyOPVfaDuJtylO
	 m4eQDfzM10HN85HDJT9qwHfGc4DESRK5dVX+vrSfxIxW+A+v4DOnbQmPw0LQ9upPln
	 2DH+gISXJIyzKWXs0LmrLBKr8dugdDbNC/zja84rqdQvqtTkeZI7mHD5j/QEnru5oS
	 CHcVMS2f8y4HU1adWcYPFuU3/9+sfOb+0RYp5WuSdkeNRiRsYZYlFjP23iGb3Uus3J
	 Q5sLtB7fcxjdw==
Message-ID: <be90d12e-304a-4c26-984d-2410a8850293@kernel.org>
Date: Mon, 2 Mar 2026 10:07:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] mm: add a batched helper to clear the young flag
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
 <589d743f4e048dc749002a7e1a1aec5d511c406b.1772185080.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <589d743f4e048dc749002a7e1a1aec5d511c406b.1772185080.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 781zxju98566yqs6k8tioydf8sjpx6jz
X-Rspam-User: 
X-Rspamd-Queue-Id: 632AA120006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772442485-149711
X-HE-Meta: U2FsdGVkX1+8m/DAYtzsVSH7Fpnz21mxdvlTvWPSgryrN9AoLKdHMSFiZKZo3UXco6I7zKYEDb/PvawQ8chhcmzRcDq9Lv5lWbdbFg2zgLRvHJfbiKFh+d7/MT+lgk/FMXtiL+Fp8gC5ocA6oL8NxKqsDBTCxucumhhPhXSsoJtumHEfsNDGSqVLC3SX/nrScT4nZwkch/q3VFt4hySe3ThViWccqz2/ZDJ/im8Cry/ffrZmvc9r8JAmER3E+yA0Uqa35K7d4RNnvS0qqs2+vceKX1s1ueJUUsSJj1T9RrUrffZUwkZECBTK6rQJdBHbj9YstIDefpdYbqWk8hlEv6WNTmO/ViWsJvO1rEVAnwF9gDR9E9rI9r+awwU7rZ9dNvDoHQQdK9+ZEIBtKIEvL2mmeaD3PFDBIT6LQNDiaDXX/vkfcweHpwP013BXURZdhcogsNZMLpvog+WSWDJmpeW0ruNyuZ2TS4O6UqIjQPz3hZq6+wxvOfC+hfSYbF8ENglPxZqVEYQuYvpGrM3xTrlZvR36HoHMZkwKsERTC2VqTqkV71XS80XdwbKz8R6bklvawe6wAkFbfJ8hyXfPpYd1b8YNceSUV/mN4rZFWgeY/ecgyzGqv0n1OhBGiNW3ai4g74Jw5O2q1QKpEuArbGx0fPHDvi2KRDBYSOsxuBT7f1zopxK6lv4lUXexp4zizO7P2aEgp+YFB0is18V1OQclKm11Hte2h/FJCzSQRLWgnhFM/rEo66x0dmFU7uB5IMs7kk14ZRiU6PkrrOHSkc4Oh+d+AwfXk3Z4fzejPsezQVExfCtdhgsTHn8IdLr7pmfVlVz+cg2Y2Z/lq+y2zi590YuLpPqKg7Kz/26vBq4PtxvtmSwiYEccLMB2B7rx6T/q2uyAeIq0K8AY1nvcQxmfyBfB2YFR6ZEIUZ/HuFaBo0wPLPjPdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 10:44, Baolin Wang wrote:
> Currently, MGLRU will call ptep_test_and_clear_young_notify() to check and
> clear the young flag for each PTE sequentially, which is inefficient for
> large folios reclamation.
> 
> Moreover, on Arm64 architecture, which supports contiguous PTEs, the Arm64-
> specific ptep_test_and_clear_young() already implements an optimization to
> clear the young flags for PTEs within a contiguous range. However, this is not
> sufficient. Similar to the Arm64 specific clear_flush_young_ptes(), we can
> extend this to perform batched operations for the entire large folio (which
> might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Thus, we can introduce a new batched helper: test_and_clear_young_ptes() and
> its wrapper test_and_clear_young_ptes_notify() which are consistent with the
> existing functions, to perform batched checking of the young flags for large
> folios, which can help improve performance during large folio reclamation when
> MGLRU is enabled. And it will be overridden by the architecture that implements
> a more efficient batch operation in the following patches.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/pgtable.h | 38 ++++++++++++++++++++++++++++++++++++++
>  mm/internal.h           | 16 +++++++++++-----
>  2 files changed, 49 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 776993d4567b..29bd9fd04e1e 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1103,6 +1103,44 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>  }
>  #endif
>  
> +#ifndef test_and_clear_young_ptes
> +/**
> + * test_and_clear_young_ptes - Mark PTEs that map consecutive pages of the same
> + *			       folio as old
> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @nr: Number of entries to clear access bit.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a simple
> + * loop over ptep_test_and_clear_young().
> + *
> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
> + * some PTEs might be write-protected.
> + *
> + * Context: The caller holds the page table lock.  The PTEs map consecutive
> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
> + *
> + * Returns: whether any PTE was young.
> + */
> +static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
> +					    unsigned long addr, pte_t *ptep,
> +					    unsigned int nr)

Two tabs ...


What happened to using a boolen as return type and for "int young"?

> +{
> +	int young = 0;
> +
> +	for (;;) {
> +		young |= ptep_test_and_clear_young(vma, addr, ptep);
> +		if (--nr == 0)
> +			break;
> +		ptep++;
> +		addr += PAGE_SIZE;
> +	}
> +
> +	return young;
> +}
> +#endif


-- 
Cheers,

David

