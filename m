Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9A5606A33C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 13:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kCzOaLR3
Received: by kanga.kvack.org (Postfix)
	id 52C506B05B3; Tue,  3 Nov 2026 08:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC8D6B05B4; Tue,  3 Nov 2026 08:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC5F6B05B5; Tue,  3 Nov 2026 08:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15DF06B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:31:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FD88C0423
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:31:45 +0000 (UTC)
X-FDA: 85393895370.14.C8A01C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id E707340012
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:31:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kCzOaLR3;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793712704;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RyaWAmGggQYyP6jdmvq5bvsNO1h1kkdUaWxYijyd/60=;
	b=j1w2uDrX/5cuiWQMpxCLPNOMihbpNZtJmx3VT2zRIefPqp8Vry8XOL35msQH2sGHRj7qvW
	z+Xj4l19v/OhEVNFXaHgt+8JjCe7Pb+nxbPyo1VjlczELzEP3/5/vZn+SpVamC4Ri+zLqM
	bgErPtA8AkR53xgK9SuiXHQcBwRrvUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793712704;
	b=Y1P+mLMNBitlYDILOtEkLQBkO7F+miCtmKz4Xxk7/qx5Xw154Keb2fRSIgojP0+gnUsTZY
	wPJxS8Z6QhsgWEZtRVmbHJgd+tPpSBSIWt9LFu5+tR1sRRxJWmEB1pURKU4Yz/wz0//z9K
	c1wBzvps3J0pcoEAKZPwQMggh4eIYNc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kCzOaLR3;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3600443620;
	Tue,  3 Nov 2026 13:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4BE1F0093A;
	Tue,  3 Nov 2026 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712703;
	bh=RyaWAmGggQYyP6jdmvq5bvsNO1h1kkdUaWxYijyd/60=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kCzOaLR3VsJGa/IDgkrfipR5m/FQ+LaefPijqlU2i3hszYY/wsbDvZLgHhDS5e4VH
	 N3gTCGcoJcFlBuhAW1cVuOaNs6vvu+PCIXLssZYpHPlRx7FPxsQqqIgJRSMBbl7GP1
	 7Jk1AI93xjeNmzROgT33mRvZdEmLyLCW7wpF8L3oWd9vY6/C07QQVKaJOja6HK1eDP
	 rV8htJ2Jr9ZaxDAIK8N6yA8VwM93z+2TKwBwprGHR29GtjDlqx6p4PycU0UiZteZC5
	 T4uudYwUVM/qMphNlbWVuDlwgBXnpmWT0Fno5TzA07Dp8JNSSWTdKY8ABrj0eTVbAw
	 TEP4DKamIGMBw==
Message-ID: <sashiko-outbox-195354@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] mm/ksm: make break_ksm() more scalable
Reply-To: sashiko-reviews@lists.linux.dev
To: xu.xin@linux.dev
Cc: acme@kernel.org, adrian.hunter@intel.com, "Alexander Gordeev" <agordeev@linux.ibm.com>, akpm@linux-foundation.org, alexander.shishkin@linux.intel.com, apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, byungchul@sk.com, chengming.zhou@linux.dev, david@kernel.org, dev.jain@arm.com, gerald.schaefer@linux.ibm.com, "Vasily
 Gorbik" <gor@linux.ibm.com>, gourry@gourry.net, harry@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, irogers@google.com, james.clark@linaro.org, jannh@google.com, jolsa@kernel.org, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, linux-mm@kvack.org, linux-s390@vger.kernel.org, ljs@kernel.org, mark.rutland@arm.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, mingo@redhat.com, namhyung@kernel.org, nico.pache@linux.dev, oleg@redhat.com, peterz@infradead.org, riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, svens@linux.ibm.com, usama.arif@linux.dev, vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, xialonglong2025@163.com
In-Reply-To: <20261102132956.302480-1-xu.xin@linux.dev>
References: <20261102132416.300084-1-xu.xin@linux.dev>
 <20261102132956.302480-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:31:40 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E707340012
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tmtcj7e39hr9a579en73q7sfw673atoz
X-Rspam-User: 
X-HE-Tag: 1793712703-59417
X-HE-Meta: U2FsdGVkX1+2pgd92wOXEQjc0T9bK4xHHhy7sil2YyMPTkpTPvd3z4pdwnrR29H8mO1CMfd36SiCxYi4OJRxb+VlfocTz7gBKokqO7cvt/C36nwCNNVm0muSJOoemWvab0iO/GwqZ9M3cLSCtw8vYCkf/Vp2Y0N3/hWCChZ86oMFM8s78K8kAMsPAWn/bkiD6XgV/h480oGaIO2EKfvoaBiNu7stZCg8krVbsDSvCT5+jac9Xh8nSQ4MDv1Q9DYyi1L53wS3tXqHr4lUp9XlXCVjPhiQ1EufJIvvgr2f0+QO0kVTtEXqIGPrHD5gvHHkGjmElYjnJ8Ercrsr+i4zxbnAZ3MHsx5CR8WNMp8moSx6iEF3qH3ukYtxbWCzxa+oCyNrFBNPaGNsBUvGHh2U5ZHncTwR8tnEZBoAoILmCGNtCzmXeA9w8mTkZfVlRxETqBcvkHrJ8sUYpxQ1AvZaiwhfmeqJwkXQ0mgiu2iOVAlIKRpkf/YeggRI6TZhKd6fcPRIy00pAlVGB4hmgGoEehGCcOnHMef2itiD1BtVizNljZaykdNYZHHCouGXpoyBHxLb0EOVxMwIsdF+sVikXm6QnbNnDCEfW+YNOYRzdq7Y3tut/XASQx2eYf5sz3fU2hGGvrTQ+H+ndBjlCPSa0x0zsDfvmNav4iZZ+256cPt+6tgOB62V9vwVO8w7D3ZdsuSwOVFkbwrhU/4mj3LitkN3UQhwbC9Z3l3Wv+Sge11aErGZ38oJ9Svgqplw2+ZEukjd5wSs093SCUOpJOsS5bi4cVUXDtqy8W66VCXQcnczdsk3H7TUdsTEUboHXcWzRYyzRGT+1ve0qRdplq3RqbYVejAvU5nKDW6u7bBYiOqoFH2iZiedPptDisZvyuZe/kzkn9TPVheCjr13bmFaHTbJqADKdgBTlZT8ZiysDmmTaZYCy/2sGmWkPSEC7pnckZxq9vyWdgdu5kzA9xw
 /V9/jUie
 jb7ijrLWnZbzDOdiUS0L+u0eqq+kHYuKSrRVNqVb9T30efMuvN43zRseDNeuJAy+S2+pZvFuUVQg0qrqxdHgGyH51ryrbEGyQYI9nt3ytW++frIOi7SOxaYFaLN4uVQdM9YTn95iSQkni/j60v0hghaLhAHpULKqhTVLavo1qj8eB93uLTIV+YZktrUsOBv7COUbX9kZUCac2jVHw4jpuYB9DnOre74nk4/HA6sxZZ2xlzCYbwzYnEnRy8bxCKLgJVt4UFAWePvDsOjLyb+UXa6QOt6GsgbnQtyA7RsPxtCX9SP79KX0bJ42TXMnYHChwEELFtZAGBN4Fnw/oMRpJJVcpJ6yn1kYZdP1jsZzjehsUdboj6e33gUgAQod8itu9nE1EtNecNBrb94UsPqt0zEp7IfIOrMWPZf0meCk7+vu9ZxYZXNgGopSWY7p+6tJGLSYY6D/Y7A1TAYR88pVQ3b52rmBp4kIjUq5YPHpaTNbNBNnWQFWyCAJmjSCIpyFEvjNiGfyJL7T0GbAFEEcneWFBckK80o1sv5smFiqShUteggLDXBqTWpR6Dxx0a8BvBfGDRNMN4IYk3DIIFCfj/LdoJ78qq/fiLYnSuhM2PZFO9A4+QK+GwfqauxWr3APkvCehybyTt7wlrf2gFQv9CEPZN84ro/jxVzDs5chGJNxF0ALNc+S7gfjOMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] mm/ksm: redundant ksm_walk_lock enum and helper in break_ksm()
- [Low] mm/ksm: non-const stack mm_walk_ops in break_ksm() contradicts comm=
it log
--

commit 05d53e6a6817e77860f887304a4f4cd4936f2c61
Author: Xu Xin <xu.xin@linux.dev>

mm/ksm: make break_ksm() more scalable

This commit replaces the boolean lock_vma parameter of break_ksm() with a
KSM-local enum ksm_walk_lock and constructs struct mm_walk_ops on the stack
instead of selecting between two static const tables.

> diff --git a/mm/ksm.c b/mm/ksm.c
> index d4fc0b0965aa1..84d363dabdc8a 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -661,15 +661,25 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigne=
d long addr, unsigned long en
>  	return found;
>  }
> =20
> -static const struct mm_walk_ops break_ksm_ops =3D {
> -	.pmd_entry =3D break_ksm_pmd_entry,
> -	.walk_lock =3D PGWALK_RDLOCK,
> +/*
> + * Locking contexts in which break_ksm() may walk the page tables.
> + */
> +enum ksm_walk_lock {
> +	/* walk under mmap_read_lock() */
> +	KSM_WALK_MMAP_RDLOCK,
> +	/* walk under mmap_write_lock() */
> +	KSM_WALK_MMAP_WRLOCK,
>  };
> =20
> -static const struct mm_walk_ops break_ksm_lock_vma_ops =3D {
> -	.pmd_entry =3D break_ksm_pmd_entry,
> -	.walk_lock =3D PGWALK_WRLOCK,
> -};
> +static enum page_walk_lock ksm_walk_lock_to_pgwalk(enum ksm_walk_lock lo=
ck)
> +{
> +	switch (lock) {
> +	case KSM_WALK_MMAP_WRLOCK:
> +		return PGWALK_WRLOCK;
> +	default:
> +		return PGWALK_RDLOCK;
> +	}
> +}

[Severity: Low]
This isn't a bug, but is enum ksm_walk_lock and ksm_walk_lock_to_pgwalk()
needed here?

include/linux/pagewalk.h is already included in mm/ksm.c and defines enum
page_walk_lock (PGWALK_RDLOCK, PGWALK_WRLOCK, PGWALK_VMA_RDLOCK_VERIFY),
which is already used directly elsewhere in mm/ksm.c. Since break_ksm() only
uses walk_lock to populate ops.walk_lock, could break_ksm() take enum
page_walk_lock directly instead of introducing a 1:1 wrapper enum and
conversion helper?

Also, the comment on KSM_WALK_MMAP_WRLOCK says "walk under mmap_write_lock(=
)",
whereas mapping it to PGWALK_WRLOCK causes process_vma_walk_lock() to acqui=
re
the VMA write lock via vma_start_write(vma) rather than only asserting that
mmap_write_lock() is held.

>  /*
>   * Though it's very tempting to unmerge rmap_items from stable tree rath=
er
> @@ -697,17 +707,19 @@ static const struct mm_walk_ops break_ksm_lock_vma_=
ops =3D {
>   * protection keys here anyway.
>   */
>  static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
> -		unsigned long end, bool lock_vma)
> +		unsigned long end, enum ksm_walk_lock walk_lock)
>  {
>  	vm_fault_t ret =3D 0;
> -	const struct mm_walk_ops *ops =3D lock_vma ?
> -				&break_ksm_lock_vma_ops : &break_ksm_ops;
> +	struct mm_walk_ops ops =3D {
> +		.pmd_entry =3D break_ksm_pmd_entry,
> +		.walk_lock =3D ksm_walk_lock_to_pgwalk(walk_lock),
> +	};

[Severity: Low]
The commit message states:

  break_ksm() currently takes a boolean 'lock_vma' to select between two
  static mm_walk_ops tables.  This is fragile: the ops struct is full of
  function pointers and making it mutable (to switch walk_lock at runtime)
  turns it into a juicy target for attackers.

  Replace the boolean with a KSM-local enum ksm_walk_lock and build the
  mm_walk_ops on the stack, so the table stays const and there is no
  shared mutable state.

Previously, break_ksm_ops and break_ksm_lock_vma_ops were declared as static
const struct mm_walk_ops in .rodata, whereas this change declares struct
mm_walk_ops ops on the writable stack without const and reinitializes it on
every break_ksm() call.

Does moving the function pointer table from static const storage in .rodata
onto the stack without const match the security rationale in the commit
message, or should break_ksm() either keep selecting between static const
struct mm_walk_ops tables (as done in fs/proc/task_mmu.c) or at least mark
the stack struct const?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102132416.3000=
84-1-xu.xin@linux.dev?part=3D3

