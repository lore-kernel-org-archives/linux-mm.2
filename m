Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15239606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=no2XTcBk
Received: by kanga.kvack.org (Postfix)
	id 1D4996B05B6; Fri, 13 Nov 2026 09:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC586B05B7; Fri, 13 Nov 2026 09:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA616B05B8; Fri, 13 Nov 2026 09:25:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E13C86B05B6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:25:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7019B402B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:25:36 +0000 (UTC)
X-FDA: 85430319072.17.653804C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D877C40004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:25:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=no2XTcBk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794579935;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLDUcu13ptYDqhss1p7Qyq/IvX8mix873ioFC6PBrB4=;
	b=zmHIAqCCBu9fAokxymUpWVb+gKZtplG1Dzp6Yj6i1WfosAGwXMejrjkMQ9TwWt24MpMqK9
	ADFyOls1nAnZnyFwtuFLyEGzrtxcxYvszkVYOoSXOPqLT1MShgMCXmCS4rq5xgPwRLCp4J
	SRWG/r0/4DEw4dvj+y3F6AH9fXtuLTs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=no2XTcBk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794579935;
	b=4TDjPFqbD06sTL+WeTUpkkN6H64E69Ek6PW+STtipLX4QR4Sv1QHRLx1Z3gHwHoYj7NK6s
	FM83wNhcDzlfqytm8Ukke0WDnpNI+8L8jszUh74yu6vZOhZyBZSplYQWUdmHiy7cxxRtaH
	IsOQveT8SUCsH5Lu8dYtkAc3jp401e0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 659E36021D;
	Fri, 13 Nov 2026 14:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660F81F000C5;
	Fri, 13 Nov 2026 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794579934;
	bh=SLDUcu13ptYDqhss1p7Qyq/IvX8mix873ioFC6PBrB4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=no2XTcBkgCbWLnUTzdiJz0lXQPokK8OcsVMSOwtmcX19znogGkjQb0zm+pzjfmyCZ
	 pADvMu9IftHt5W+CPWGgnq3fcUtEK8pMW2xsNaFCZPA/1+WbT44T8HsibiMP0X2Tfk
	 Psa2bh9QYTHtbduN9aV5UYXWuxX0RhplV0brFOqeHJ8rQEEGrRS51trIKC33r3xq9G
	 BvqrSJrSETRmMhnIiEDqHhhV2GgZPzJo+HKEGl42SrQ2HpebHAQS8jGdTqlGG+VLiL
	 HdlCW3mBdlUUVfKayxseUMv26i0DPYRB5EQdndRR7RXIRhpUjRzYDpROKH4HobiFCc
	 WmU7DvU4ckd+g==
Message-ID: <sashiko-outbox-212974@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond
 i_size
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 14:25:32 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D877C40004
X-Stat-Signature: p7uisexa6stuki5phfk699bs8qp8dxd9
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794579934-738402
X-HE-Meta: U2FsdGVkX18Yic/u/F+CuWhVLlRvmm0DOZGfINGSXc3O90Gto7UoAsqSU35BlLGhaEtIfygFsNBKCaeFCO3tf5+8/mTp6msCaEZH4l3ETVoqe1eR9MsfEQhRv7pjKoJt/zLdR4t7di63RN7IsqFx9b55x1X8CnPk1jpXUciPNokJ/u9Z/u+4LTPLdCorXIZuMVbgvBcHtk1lI1NM83bGZRlmKoeWOIqiR6USxKrji8JNPhZXjIgzpHeNAxDJGRiHXTHz+JNOu3ctO9iIIQaxmfuM6hKylXXt6k3cv47PQ8/9F9QMv9AVt2vnO9SgcxN0OhcttFQeHBUTRFWwhLWTi9MvDKsdZWY476n9sTYP4XOgm9ung4K9siqigpoTJ8LSSz2kyfHRyGjrgDp16v28za/kzSSgKlJgltnXgpBw2VPw/Tevc0MCV9RgtUEqnyx8OKGKDRak/0SiRdx7G+STuN0vrRdJl8+967M4qbFdpTdBQpC0vzd/T4UeSuJABtXlbc+isIjP6YYb6Mv1rQlPV8JOb/Ua+bc0WVpSj6vvVD2WzTrFHBbUpYBh1lpDUq0WXUm/0GCRh8R2dCqXLdveeknVJopkIa30R/J7CLOhRQe+pgKb5o/l8MT9dtWlYZVpfTYlvEekDHqHJCGhomSOZ6eQ8e+5xjzNg0j+GcnPxnaTuW5deSv54oE4qD024IRlPkWNGvpkGyLWz5ESCpgQwduWz93SUSq5Gdj2okgcXruEj7tAA5aLDwqVcOHVsNPc+pDjjFNVj9SkOF9H9ajau7LlqcnXrz2MoLyy2RbqwF1rFASjDaYYLTJJtz6u3k+RMZJiPo46z5UiJLbvshXXSOBiIhWrIY6EQxpkhFLdjhCAWk0iKorbVnStNsplXrMtL1PDeNqsXGfOmi9iZJ0zw1cmsbLEx6sJcZXguOw9O00f7GTIjfw/LpjPJAoXAncLwLT0qp9Zly0X3Ih1tGZ
 K95mkh8M
 g/1ohEwb8nfDnuMm215ztD3WTqY648Thm/90OY98dBgmyG12dQRYdAbhJtNZdWKZvy3Oz8cn6AzsKn0anf4elMow278ZbZf1jr8MDNrwU8o3bhd5Ydj9dacKpYUvFBqfRaVDKR6JWKENv/T6CyLitXeYeEWjuYs/fAnsDP2gxbeeiewrhkwgVMBxd04A8MVmvuFMI1V85nmGmQveZqq+Fq9l6OCYwR8q+wYrmDi5waLU0dOCX/cs4uwEsI4V+1aEb2ZhHGkcr3v6sI1bcwm7hdcqXAwLM+s6Od8WB6rRXjK9v/1qgeYvTiite0fjhPqLQy4+oaOfafTfAn0kau71rmI5GpPP/UgD8NExdt3xE2po1LYXlESsWpj6o3rjGbdiQnFkrI6bTHA8r5GuuGU489UiqoFaaEWfdak8vh5ykRv4brbGBEgtj/rKlgKMKY3ASg2VX31zOJnsFwiaasSs/ange/9rVbjlFTodFz6l4zAXi7K6sEYpddqyzZaXC1dX2qxtYzQBtGMCV6Od6tdHy1A3y3mjJq93ottVaC6+I+pMLhBWZCkf1q1EFuRtbt1aBOvWU8Sa50py4emjr6IGOgQHkrY5v/z1rGWAJSClxlJ34pmYtQ69pILZRwFqCOTWscibt7JxfuSzdjoZXbi2oRE8ogyhMb2itR143r0i7E9vVhwJjEskYbqacKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] mm: xarray node memory leak in collapse_file() [1]
--

commit 8b05158695205f614e5dcb777a5926b63afd5388
Author: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

mm/khugepaged: reject shmem collapse ranges beyond i_size

This commit holds the inode i_rwsem in shared mode during shmem collapse in
collapse_file() and rejects ranges extending beyond i_size rounded up to
PAGE_SIZE.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c6d5ba6c88a6d..e0e602e8f87f1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2272,6 +2272,13 @@ static enum scan_result collapse_file(struct mm_st=
ruct *mm, unsigned long addr,
>  	 */
>  	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
>  	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
> +	if (is_shmem)
> +		inode_lock_shared(mapping->host);
> +	if (is_shmem &&
> +	    end > DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE)) {
> +		result =3D SCAN_TRUNCATED;
> +		goto out;
> +	}
> =20
>  	result =3D alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>  	if (result !=3D SCAN_SUCCEED)
> @@ -2703,6 +2710,8 @@ static enum scan_result collapse_file(struct mm_str=
uct *mm, unsigned long addr,
>  out_put:
>  	folio_put(new_folio);
>  out:
> +	if (is_shmem)
> +		inode_unlock_shared(mapping->host);
>  	VM_BUG_ON(!list_empty(&pagelist));
>  	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, f=
ile, HPAGE_PMD_NR, result);
>  	return result;

[Severity: Medium]
This problem wasn't introduced by this patch, but can collapse_file() leak
a preallocated xa_node in xas.xa_alloc [1]?

mm/khugepaged.c:collapse_file() {
	...
	do {
		xas_lock_irq(&xas);
		xas_create_range(&xas);
		if (!xas_error(&xas))
			break;
		xas_unlock_irq(&xas);
		if (!xas_nomem(&xas, GFP_KERNEL)) {
			result =3D SCAN_FAIL;
			goto rollback;
		}
	} while (1);
	...
}

If xas_create_range() fails with -ENOMEM, xas_nomem() drops the lock and
caches a newly allocated xa_node in xas.xa_alloc.  If another thread
populates the XArray range before the lock is retaken, the next
xas_create_range() call succeeds without consuming xas.xa_alloc and breaks
out of the loop.  Because collapse_file() never calls xas_destroy(&xas)
before returning, that xa_node is leaked.

[1] https://sashiko.dev/#/bug/linux-2a262b48-1e7f-4d11-8b87-d5e410ce41f7

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112142335.2749=
597-2-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1

