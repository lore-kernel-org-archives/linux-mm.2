Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CCBCD4F5B
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 02:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3296B0096; Tue, 19 May 2026 22:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AACE6B0098; Tue, 19 May 2026 22:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E72D6B0099; Tue, 19 May 2026 22:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD736B0096
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:48:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06478160121
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:48:59 +0000 (UTC)
X-FDA: 84786265998.11.07EC3C1
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id F0A4640002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:48:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iVWj2ar3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779245337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yR5a/g6E0YQo8Yn47vVbWDxzDy8B4ttLwABPXqZO/PY=;
	b=fKwyrIvH9bDQZBLK+LglHeT4CR2WhzAntmTua0s+JGxuGBgCGWOws7YPczF5Ko4uBgeO2W
	JnzjrllK0sF9FmRrcdwYvAgONczsLuJXHyk90PN1jWgCkKSxNMVf/ls65An3rRuuhrvu9a
	o56cWsyqtffgpZ8InXVEC8uQ/NLdhbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779245337; a=rsa-sha256;
	cv=none;
	b=r6cbbSOPm5O6+iL5j9JXYPeBGkEobHTdLBL8fE6U1MzP3wwMGHkKfSNImGL1d0+EIp7peL
	cgzvKPq3KtbN5fI+eEMaNa/1rchyDvEMnBsRjY+ciEOQoCxWdpMs1+C1hYbZoR8qFXmasP
	HyB2JgXmDTCwqcK4mQ02cpviC5KSpc4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iVWj2ar3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779245334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yR5a/g6E0YQo8Yn47vVbWDxzDy8B4ttLwABPXqZO/PY=;
	b=iVWj2ar3W6DM9iZJ3unqUquzdYaVIuZfx+BLVyEnZvs2xAz49Un9DteKbYuYPovBK1eagB
	F1nWlqfJfQiojq7LeeHnSyGAT7ao4ZEvWlU7b5u4xd9e49Pe+8hGf1KCH6IrmWV2vr4jHy
	b52jkzG7DXAbiNevV1mhiZmnolBAjbA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2] mm/hugetlb: restore reservation on error in
 hugetlb_mfill_atomic_pte() resubmission path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260519230503.121293-1-devnexen@gmail.com>
Date: Wed, 20 May 2026 10:48:17 +0800
Cc: akpm@linux-foundation.org,
 david@kernel.org,
 almasrymina@google.com,
 osalvador@suse.de,
 yuehaibing@huawei.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <24F945C3-3A62-4250-909C-65D0CEB9F182@linux.dev>
References: <20260519230503.121293-1-devnexen@gmail.com>
To: David Carlier <devnexen@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F0A4640002
X-Stat-Signature: 6nh7fu98k6fdd4zgt4i58d8ic7zu5sdb
X-Rspam-User: 
X-HE-Tag: 1779245336-357214
X-HE-Meta: U2FsdGVkX1/+Rj8ujkaPIQNWbxdeH+1F7J2o7vqBXCaVCHXcRPx0AWrHcDhQMbAdpZ9oaIth5eAWGqW3p5KtAa/JyfPxcWQexHiZkIOLVhi94vfeJTj3bdeUrS13bwbFPooqcf/RYUtf6KMohTx/MN6j5OyCx1Cy3W6+FClrbCBOnTIRmGHQiy4tfgP1obeP5Za0nwVt2z4QKdn4qPjAuzfdlNH6CpfwkeHl1gxw+mpGWrV3rYCDVEHfVQMyN750u1lIASpdLXghkoH1WzpQTK4V5QtU3tiDf/LTvVaJWPAyWnKyiX2LSAMkSfVL8sB4+PdO86r5by/0LrjGDf3GquMe7RjaeB/roavffmqdZuqr2BG0I/ndE1NY5TR6GsUqFLWayODYHTbi39bLR06mJzPB0EYFIHuTgMqI5XfXMhsUcT07os5IbD7Je0Xpp6OjpD+YnGKEYctTb5skJJbABRAwwyKXa1Lbkz4krw5xfLP7z9k7+swwJJZUh4XhIOV+CJv06rEPhNSHyjCCGeqpdnrSRXCwVrUn7ZOUldTU3/OQjKX5GfeoDGsEOx2oDwfCMtN9eNnD/5ypfN58IohQ4jS5T3cuhT2zuWD5Xm9z9NoVODm7SZRvEX5qM51ycQF4X+6GNXj8c94x5yGakXISGmZQWYjzai59d+EPqr5yq3SYnvGkzmgiX/V1MGCucnJYJUwNsszrjZzASNmNua/kqveXKT4W44uKOoLMMRtBP9ZtyuOQbFTn50HEvKe/wnMUNU78qDr0x3vcoYm11i7GaQAVIgo3Mn5xNsesnz1MpWL7UQUbTZxgVlJ3pnLYfrljHk9zHAZGHSa9bMZaRzMblvRzkzA2cwzajS0iWNqH+jJOoEaTNlhfRc6zzIwrBtSef1lgmkhaAv8A95yoRN/ApcSApoeyE4ReFhP65O2f4+aWcaMuLCzK82e7Fz3UKUNuSdmD41PD/vCyoRFjbmO
 xKFmlHnp
 0z4gJlSXRk8AYkI93t17NNMbGKFePHoj1OO3PKqYqDg4gyES0Ox2VW5iFJiuQVIPoe5eDsZlskEQ1DK8PJDivA3s1JGpm0uA836ZkvsleKxVYi5k4qTc5z/22IkdX7Pqkd2YXFLS2deBktwyrI1rx464I3Yj5dOcWLLVFpWbyJuXkhJ/TMrrjQ9k5CI6164mAJJkzv1hTrgPDsofBAgzeODx9tfDNU+1YEsu6ub/FItVp9SxDk79cINiI0Awfn+dT/vooMkNgOQRkcQB79+w+WMkgllpdY+JMIeRrHLqAt89xCpnCEhjIwxO1pDg0mpE662U56HWWzvI4K9fio7Aw6/C88xJf1q1OLl5Vz8T2dqnZnIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 20, 2026, at 07:05, David Carlier <devnexen@gmail.com> wrote:
>=20
> When the resubmission path in hugetlb_mfill_atomic_pte() allocates a =
new
> hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is =
consumed.
> If copy_user_large_folio() subsequently fails (e.g. -EHWPOISON when =
the
> source page is hwpoisoned), folio_put() restores the global hugetlb =
pool
> count through free_huge_folio(), but the per-VMA reservation map entry
> is left marked consumed.
>=20
> User-visible effect: on a UFFDIO_COPY into a private hugetlb VMA where
> the resubmission path's copy fails, the reservation for that address =
is
> leaked from the VMA's reserve map. A subsequent fault at the same
> address takes the no-reservation path, and under hugetlb pool pressure
> the task is SIGBUSed at an address it had previously reserved. One map
> entry is leaked per occurrence.
>=20
> Add the missing restore_reserve_on_error() call before folio_put(),
> matching the first-attempt error path which already handles this
> correctly.
>=20
> Fixes: 1cb9dc4b475c ("mm: hwpoison: support recovery from HugePage =
copy-on-write faults")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
> v2:
>  - Add user-visible effects paragraph in changelog (per akpm,
>    required for Cc: stable).
>  - Correct Fixes: tag to 1cb9dc4b475c (per Muchun) -- the failing
>    arm only exists since copy_user_large_folio() became int-returning.
>=20
> Andrew, please drop the v1 currently queued as 270157aef0d1 in
> mm-unstable.
>=20
> v1: =
https://lore.kernel.org/all/20260322052120.14021-1-devnexen@gmail.com/
>=20
> mm/hugetlb.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4b80b167cc9c..c6dee98840db 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6270,6 +6270,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
> 	folio_put(*foliop);
> *	foliop =3D NULL;
> 	if (ret) {
> + 		restore_reserve_on_error(h, dst_vma, dst_addr, folio);

I think you should fix the same problem in copy_hugetlb_page_range()
within this patch as well since both are introduced by the same commit.

Muchun,
Thanks.

> 		folio_put(folio);
> 		goto out;
> 	}
> --=20
> 2.53.0
>=20


