Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42336C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE826B00F1; Tue, 30 Jun 2026 08:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5C86B00F2; Tue, 30 Jun 2026 08:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03166B00F3; Tue, 30 Jun 2026 08:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD76F6B00F1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:01:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30560168115
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:01:47 +0000 (UTC)
X-FDA: 84936439854.06.F418749
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1A73C180003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:01:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1XbjA+P;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782820905;
	b=2z5h5SyxEPbcpA/vWh6ekyoDQYLQPqNgmqAMo8ttO2F/t5tRFsRbmsT9NSsuQ8UjzeYqhM
	XJ7ejiezoLFLHoE3Etwk60gALF+FBvdJozIVDxrdXIA8BxIynq140X2N8NRbUKJWjqTrRn
	rQm/oHD+uTfDmZKG8AymObL5XvOpGuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782820905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBN3h+z9xy1yHoFYSo2ztdKUYrT1IOkpJyl6BOeo5uw=;
	b=tFzvX+DX59s8RDueCZhqmDLtuW07clTAGosNjng7rSJuD7789FzPZiBoV7v16RSL9/5KR4
	+3OI9KojLwAQBpBRh5XYg9rVcD8JfYvnc9mbPiDMU8OBlbQFltSe6Pnd+TicXvbzPZBjia
	AEnHzSl4k55TXK7OIHHcZnUi/0L6zo8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n1XbjA+P;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782820902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wBN3h+z9xy1yHoFYSo2ztdKUYrT1IOkpJyl6BOeo5uw=;
	b=n1XbjA+PlPOt32zEosvdgU+vBAYCy/muv9WwOXfVqY+tr4OFvzach5+18L+vKcF7glyPWo
	eU5C0GgzPbrGmcQkbO3YX+jgJeXzqNRKrWgkBNSCS6WyoggSUWKJD0qZf8/ZDRcHMK+Bn2
	z7fLbXagzLECmEI01Zrt77Edjwx3PMQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: avoid unnecessary TLB flush for empty folio
 list in vmemmap optimize
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260630113857.3319612-1-guanwentao@uniontech.com>
Date: Tue, 30 Jun 2026 20:00:51 +0800
Cc: mike.kravetz@oracle.com,
 osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6FEB0F1B-CFD6-4999-A9D6-CBDEF9951C8A@linux.dev>
References: <20260630113857.3319612-1-guanwentao@uniontech.com>
To: Wentao Guan <guanwentao@uniontech.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: qrbf6e7yx8f6cwuf3z4oxb6ire8jjeau
X-Rspamd-Queue-Id: 1A73C180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782820904-597675
X-HE-Meta: U2FsdGVkX19m05rfakOkLjrd//MKcMGa4W93YftuLbYWASRX43yMbsjqGV/w0CO2TGSvEo22MhZVm5WoUOBc43aCnNanyTc+60i2B+3mE83DFrdoTxRMoAltllbNnOWzosnD5dWUHsEKWl4ak+xhTsotnPquCkejb2gKZBs/6fjf7yBwWEPGwQjMr952WhzAHPJ5dyimJ/tM5XUUrPgISzRYILfuCbfqOH7l8QbGbAJmFeqIa+b8xwzg+vKYOQPiZGYNCXYXUlwF/iJPWzcoqoE6f+5Cu6ysWY9WyPIhT7lVh3qNPiv94vKDQlwazcm2eAzBRpevC/XnKI1aByHMfgKjful/wCX+KtAFQwb/NInCqTwGAVLJpvbS0BsvvcezUTk0rV5sBc5vJA9ufGKz5RwNbKFIURe563K4Ar3GWjOqC1XnEwNPoCFW8CBLk+HTIuxN6bxsjcyea267Ofu96X7/8vXgnCxlrs3p1Qmf83213nsk+SSm3aIFN3GmZhPhFBcVuLwoxn6w3IpdpJa3j5UuuTSXInAKnEp6l31h3uZBn2aKMlIqlR116tiwVeGRsyxJYrU+nya/UrWAPs9WKShIma+RcDbgnf2QVw5yyxFN03CROG3MHu6IVSSyyLAMq69Yq3ceE/YdI6q1IGMReDEwFJVKmOouxvlV8Oidrqj4WSKBLgKraSko6kcR6Fi69MLO2ZR55cyGmq9eOuVgDXDcNdiaU9iF61Sa6A2zaKjAWEeVx/zzro5C+v2qkRQ71W0ukT7XwSUMAp6F1YrQMbIM4ijYa35nsoPxn6+y++rIYq8FF2EA4PmhOg5uWVH9dOkj5NLnsWjFz0U+XCfYD/CZu6FvbHtFfGldhQMJO8MJJpWjBtns/bLbmPSN2DrqwWbyC/yG9JQ9zV2GUH8Q3lDF9iKW2UnTAy+ipZrn/cyIGfNeJhQ4QMwOZtUW00jwWmtCMVGJqFVQ3zBNDrP
 jtf0gaSV
 Yo7IzKY3UyD1CacJfK4GT1z3+qudXV6glOlbAUAPCItlooDjNA9WBOGW9kK47b3TzdmEfeyazU3XqQ6DcGlVcTbQYdMTG9kHM8td8FwrtUSvAVbwjq1ZQ5gkgQ+k9bxSf7I9i+jkHShNvZq7r+IaCLN2wmaVR3aThlrKcUVRbqFMmTxjqMe8cBOz6Kz29H2zpwGFpvAPlxuxH5hquIyaVzw7mTlsxwphmSmCGz7Y/Kbep25MxdMz/3ChxZDlAW0kfHPZo/wDseVIbSOwQevQAJQUViBDgfhUEpcpG+iS5axNqf1u+WvI2QhDgSf5OENjOcq4TEJ5KcYg53OI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 30, 2026, at 19:38, Wentao Guan <guanwentao@uniontech.com> =
wrote:
>=20
> __hugetlb_vmemmap_optimize_folios() unconditionally issues a final
> flush_tlb_all() in its out path.  However, a TLB flush must be paired
> with an actual page table modification.
>=20
> When the input folio list is empty, neither PMD splitting nor PTE
> remapping takes place, so no page tables are modified and the flush is
> pure overhead.  An empty list is reached in common paths such as
> gather_bootmem_prealloc_node() on nodes without bootmem gigantic =
pages,
> hugetlb_pages_alloc_boot_node() when no pages were allocated, and
> runtime allocation failure paths in set_max_huge_pages().
>=20
> Add an early return for empty lists.  This restores the basic =
invariant
> that TLB flushes are only issued when page tables have been modified,
> and it also makes the NULL hstate passed by =
gather_bootmem_prealloc_node()
> on an empty list harmless.
>=20
> Assisted-by: kimi-cli:kimi-k2.7 code
> Assisted-by: Github Copilot:gpt-5.2 #Reported-by
>=20
> Fixes: 79359d6d24df ("hugetlb: perform vmemmap optimization on a list =
of pages")

Actually, this is an optimization, so it doesn't need a bugfix=E2=80=94unl=
ess it's a hot
path or causing a massive performance degradation, that's clearly not =
the case
here.

> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>

I actually have a local optimization that covers this, so LGTM:

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


