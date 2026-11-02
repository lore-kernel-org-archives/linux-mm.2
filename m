Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE78606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=N4f8/RAK
Received: by kanga.kvack.org (Postfix)
	id 3CC5D6B00EF; Mon,  2 Nov 2026 07:29:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4516B05B1; Mon,  2 Nov 2026 07:29:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E14A6B05B2; Mon,  2 Nov 2026 07:29:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05CFD6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:29:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B617160C6B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:29:19 +0000 (UTC)
X-FDA: 85390109238.15.3AE97C3
Received: from mta1.migadu.com (out-95.mta1.migadu.com [95.215.58.95])
	by imf08.hostedemail.com (Postfix) with ESMTP id 81C25160003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:29:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N4f8/RAK";
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.95 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622557;
	b=BkzpY7OGjd4+MEzX8lIAsKr6Ghcu/yxdovZT4Lw3tXTt0A7HOAuZad/2qAV3Ot5lOzJxD5
	r4Pza+n5En9+fDrRvgvnuK3yFMA7x27l2MyuOPZln103JdiDhuFjbiJ0b7KEUZW2vnz4iI
	E85Y0V8hbIoGFekxwz6unPcEcvXbZoQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="N4f8/RAK";
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.95 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5jpm5CuS5hMQjKmVnNP27jSTbTcYAnxBrA5dk6se5s=;
	b=g7iiltheDjArffNlStkJK4yH13hh/2ugFsVYxXxDP6TRJeRPifBwEjqpjPVvPJ5fJT0hBv
	nXJdAiRfcCBujCi5tAcWmT9PmhxkEYPWwJ+wDhnsblL8xQEz/AJupSCbKtnnYh3/MPGeWX
	u1nSrxRd900QN0Ogxnmq/L/B1Omeh30=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lBOQhpowAzDqo4yhRDS5YU2BDNuirwHB1ryB/ebjSfs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793622554; v=1; x=1794227354;
 b=N4f8/RAKVKgzDj0sMXRI2wKidp6iBEGTLilMDBxNotEE13jbz5JJ+Cm33bVE8fAzU2hNd27h
 SItOAxujigfetZnAsyMS49nOaoaLVuXcj7qgfQDUuNka0MJtX84jfK2PYN99A1FJmyYZru/t0I3
 nwh6USvqx0lIj0ME8kNrINcQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1b3ff97483b36a93;
	Mon, 02 Nov 2026 12:29:14 +0000
X-Mizu-Trace-ID: 1b3ff97483b36a93
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <179361471103.1337633.14353990207430443405.b4-review@b4>
Date: Mon, 2 Nov 2026 20:28:56 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B5E261FB-D532-48A2-801C-C8E4F86D7C1F@linux.dev>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-3-songmuchun@bytedance.com>
 <179361471103.1337633.14353990207430443405.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Queue-Id: 81C25160003
X-Stat-Signature: g544483amggpqcyfq7gfn19gyuzoe4e5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793622557-450718
X-HE-Meta: U2FsdGVkX1++1e7v7h2EySIXemvyhsfGeMkHvIVX8dgL8XeiMYxi9ZbUBSZSNm1JkP6yFsrdBDh0qn+SPgV4EU/SoQxRsmlqSyYaUO1nBWjLu9US7Cug8QvEJwNwkxPlZYDLO0hfBwBHIEUKPfZzESKm91HuhrNSYHHLJYBLVH2L6ELdalKIkK+9KyBWeZlMFqVYcReTAqMtviQflk3Gpbck0VBaVEpY7CURBU4sSQf5waEJawAiNpBx8HLhzWpbN3nSaibof4vZnYxoG5QRwW/oSX3l3Mr07aszMPzcL2o5zDiUjaJQmFhyRBzcJt3f/R/ch9NeRSWSMGPSsskXM10ufqLR3rgdx/BmI6FpqSp6lSP3FUtFvW4CzI+tSfGa+FCycVGnUIf2hEPjUkRp20Ix7UYACS+/yoYlaidEYMFdESu4ZLb6SB0WNjCjlalCnQjVSMPDP6gmk35nsCHjbK9qbhuOFeaNSh3YYNzWXHPm58tVoUksIR0UsfLn3MneKpUBLh45gnjNCbDEl7w+r/Qu+suL+oLgQVmkWjmU36mU7Q69S+DFKK1tr8LmSou/qP3dmogKfUsb4t6Rxp1uV0FX/q7aR3YJ4hMZnzHoEJLKFslmpsOlZEeELaSPQnDimzPtLlIlMabRWaueSerza/8brzoMSVv5a0xEzXB713ONlpJuRZZlFVwOUKHRPpW/gZ7n07CUBVWT3PuBVqHyOhYftKbFC70DwqqYAGLe9m+uECGWYj6gTISETwSDd2OrSueRPL+yV5GNCCVNk8MkWu6H2dr1OpqWf12Q1JBaU0E2FKBxSv2uBNDMP/GyDp34S1zxbxzjCx64diKL83hWnkguhFtiGlbjYFkTpSNdjd3jp/HUMmQ43akEAfc8+3gpcRrFX4vLhGAsAr6bGig8Nr3cl6BoXC1H5R8wQ4a7/fjYoF5RS8/rs34XN8wGJuUPrgylnaU5PynlrR5wVVs
 O66y+AGf
 jXUqjEoi6njS+Gk7E+GoNsiytrmE1dSN8Oo1zCHtayIvx0/ZCzbzZYjsoO/8KkYovEk5U2Kn2VWSQL/gmyICDLHVact3dYNPLWeZsy61z9do/ON6zn+bWAn6kd80/77DR+eca5Y236QvZBlqBLxFwhAtrkQcj57vu/AOX6Fx/tWNsEa1fKfyKH76GmYnJKtTRO0iGB1JVDrMRLulX3IINORQMjRIKFT+UyC3etRqG+o0POrrO8uuT71L0WqjL/2MuWL8AG0PfeRIIhpZHRNahxERGCyLyt5T9NqHiAlGLVm5jOuKYnEpv3d8JJbfD2tLGNpW1cvxyfx5WxtHgGkpHJ/bPXFUTdKivj3NOwFfGPVcnLdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 2, 2026, at 18:18, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi,

I didn't realized that I'm not using a plain text in my last mail.
It=E2=80=99s my email client's fault. Let me email it again.

>=20
>> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
>> describe fully independent choices. A split-only walk can defer the
>> PMD-split flush to a later global flush, and a remap-only walk can
>> defer the final remap flush. However, when a PMD split is followed
>> by PTE remapping, the split flush must happen before the PTEs are
>> changed, because stale large-page translations must not overlap with
>> new small-page translations that map different physical pages.
>>=20
>> Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag. The
>> new name reflects that only safely batchable flushes are deferred. =
Keep
>> split-only walks able to defer the flush, but force the split flush
>> whenever a remap_pte callback is present. Callers that batch HVO work
>> can still defer the final remap flush and issue their own global =
flush.
>>=20
>> Current callers keep the same flushing behavior.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v2:
>> - Rename the unified flag to VMEMMAP_DEFER_TLB_FLUSH and update its
>>  comment (suggested by Qi Zheng)
>> - Update the commit message for the new flag name
>> - Collect Reviewed-by from Lance Yang and Qi Zheng
>> ---
>> mm/hugetlb_vmemmap.c | 23 +++++++++++++----------
>> 1 file changed, 13 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 4b73d6ec8dcea..63e899cfaac3a 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
>> struct list_head *vmemmap_pages;
>>=20
>>=20
>> -/* Skip the TLB flush when we split the PMD */
>> -#define VMEMMAP_SPLIT_NO_TLB_FLUSH BIT(0)
>> -/* Skip the TLB flush when we remap the PTE */
>> -#define VMEMMAP_REMAP_NO_TLB_FLUSH BIT(1)
>> +/* Defer safely batchable TLB flushes to the caller. */
>> +#define VMEMMAP_DEFER_TLB_FLUSH BIT(0)
>> unsigned long flags;
>> };
>>=20
>> @@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct =
page *head, unsigned long start,
>> 		/* Make pte visible before pmd. See comment in =
pmd_install(). */
>> 		smp_wmb();
>> 		pmd_populate_kernel(&init_mm, pmd, pgtable);
>> -		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
>> +		/*
>> + 		 * Modern MMUs allow overlapping TLB entries with =
different mapping
>> + 		 * granularities only if they map the same physical =
address. So
>> + 		 * remapping must not proceed without first flushing the =
TLB.
>=20
> Are we certain that *all* modern MMUs for *all* architecures that=20
> support hugetlb are fine with skipping TLB flush after a split?

I think this is the case on architectures that currently enable
ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP. Of course, the point I want to
further clarify is that the "skip" action here is not really a skip,
but rather a "defer"=E2=80=94the TLB is subsequently flushed in a single =
batch.

Thanks for your review.

Muchun.

>=20
> AFAIU, x86::set_memory always flushes TLBs after a large leaf is =
split.
>=20
> --=20
> Sincerely yours,
> Mike.



