Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936AA606A33B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aEjMa93p
Received: by kanga.kvack.org (Postfix)
	id 94C866B05B2; Tue,  3 Nov 2026 08:31:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9222B6B05B3; Tue,  3 Nov 2026 08:31:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8388B6B05B4; Tue,  3 Nov 2026 08:31:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0716B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:31:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E642EA03AF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:31:43 +0000 (UTC)
X-FDA: 85393895286.19.82A6100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 136E220012
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:31:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aEjMa93p;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793712702;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDjw50u94+mGVh6M3W7bzuL30PRHoxO45FU8kEILcQE=;
	b=OhBQ2c2bbZ8+hlgQISPfcWUIN8h/s9erFukIOXoswHvyntFHoquK3jj9tH0ycfUF60ZlnN
	zdWOI65gCzXB6u+3nbs+xLMED/bU0HnyZ+wQaZp9apIWtIeYh9irQ7zdTxMZtm6w0c0du9
	l3W5joUn62Wq9iQS6KjZ3huo+Yc0hps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793712702;
	b=3k8lFWukUYgaOaK0cF9ui4wV4d9Jezw4hP8jQBD/nYAve6nuNuSYSKTxrLuUmrv4j7QlmG
	JM5+W3QEb+p4Gx2AH3BpVI28kHJLq9OIWwdRCO8SNxstdF+R8MVU+Lczn9CBHSukKs0x/6
	M0OJVhB4aGx/Xdz3Fx0KyNQXf7uelto=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aEjMa93p;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74CC3405E5;
	Tue,  3 Nov 2026 13:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E95E1F00A02;
	Tue,  3 Nov 2026 13:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712700;
	bh=nDjw50u94+mGVh6M3W7bzuL30PRHoxO45FU8kEILcQE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aEjMa93puyhLZb4b3wCZrtwb4qoJvhvVjILtYoVFDYhbbkM5Hu5ZrTHcTNZiodPEy
	 rl1hWznJwKGGHKSP0jRdSs5tNE4t2EAsGwk2G4c01+BOjyAu8TxzV/Yu4ucgnZKev3
	 d883cJr2PPDnGYO6Eil32d1OyED7QYCcROIO0Bu0fZlRKZ6AUeHc1fX82NuOZGnhdU
	 4ncbdvd9XcLCQ0UjU3ipaCNlPAC38hy8whjnrOLCnEvBnqUIDPJriAM4utcrh/JF/F
	 067yE//Z7y4HQFPOrWNp8Or4qhRXmtob1QPG67P5/5CmrCYtTnVZ5jYy1nteWXErgM
	 m7ECWNbmOg33g==
Message-ID: <sashiko-outbox-195353@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] mm: make folio_walk_start()'s locking asserts
 scalable
Reply-To: sashiko-reviews@lists.linux.dev
To: xu.xin@linux.dev
Cc: acme@kernel.org, adrian.hunter@intel.com, "Alexander Gordeev" <agordeev@linux.ibm.com>, akpm@linux-foundation.org, alexander.shishkin@linux.intel.com, apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, byungchul@sk.com, chengming.zhou@linux.dev, david@kernel.org, dev.jain@arm.com, gerald.schaefer@linux.ibm.com, "Vasily
 Gorbik" <gor@linux.ibm.com>, gourry@gourry.net, harry@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, irogers@google.com, james.clark@linaro.org, jannh@google.com, jolsa@kernel.org, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, linux-mm@kvack.org, linux-s390@vger.kernel.org, ljs@kernel.org, mark.rutland@arm.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, mingo@redhat.com, namhyung@kernel.org, nico.pache@linux.dev, oleg@redhat.com, peterz@infradead.org, riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, svens@linux.ibm.com, usama.arif@linux.dev, vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, xialonglong2025@163.com
In-Reply-To: <20261102132927.301921-1-xu.xin@linux.dev>
References: <20261102132416.300084-1-xu.xin@linux.dev>
 <20261102132927.301921-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:31:37 +0000
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: y8hzs5ex4amw9dq8mi8np69jhqmhxqqm
X-Rspamd-Queue-Id: 136E220012
X-Rspam-User: 
X-HE-Tag: 1793712701-807387
X-HE-Meta: U2FsdGVkX18l7pQmqPunxyoOh78uT1GwTzUk+w/6zJ29PAsVNgOJ/JiXAhbOe5kL/hA1CriPFPGBE+qK1KepSzM8JWdfeewZ9W+BIftknlNXgjfAICrmscS6FKrcMdhrq6FvSgxzrCmFVo9O8dMIX/K5vZSa08ixVUhQCkgFe+vm4zN3pEpn7lTKg+q0MeQO9Ia+9IZ2Yb4VoKsvAgoOq8A2OBZoZOoALAdcKHaSxDZnXLVGSaz4ERuVj1/6mzXIxIeWbOu+JXW533yxVq53RcWQSfxiKBAQi69HsvEA7MOGyhXAS+U+k5Q1GTAkqVo84FUUvdjSdGZu99DtN0o8+ackz5Y4cSpMWCH1LoIzBDuuFZQKCWUj8bHxvB8KdqeNM1xGvyj5DYTlc1gr7+iltni83rvRx3ZfNxvpTwDGcsrsIBm2eciGGATP4R01kGhemBWe/Bfx5udsvnoSBM7Fd0E+Ce49E5SiwAcPmGhVWyziIcsLk/wAg7Az3cSRmcp8cSZdBUnJIbovqAPNBG6iK0/OW7mwLresP/QPc/zdzjHMyemcoz+6ltV7+nJ5ZcBsAjqSc7cD6749Ma8IXcZ15B+sS0Evv2JZS/JwPVPRIoMuFOEp3ZB7C6GEf8suryKBCKcoxk2GXAKHvWwwc+Nr27N5MJ5fYxz75+QQRTK/qoyX320br5s/HXAlKgk3d/8X1kquiN9/Dv38J5uAVX/njo7i3AdxSxyTIQZOyFduadsNRPD297rrGuDbfWQFt33nTmH60ZfKdyd9O0rDjuczVHduyN8uckf9OS+F9/WmTWS+hoi5R2HrIhxNo6jb6aCJnX0NIVMaQfsZnz5WMvDm+OCAdfjtKI7MN8axzcHcj1hGrwNAetiQ8JG3YGnx/KiKTvbvNWWV73zH4UNEUUliLgE39DVHXQfc0bM6CwL/iY1oakek6Pb7hkIA/mXonJem/yAjitXr5cvFdmX9gvh
 GG937iTL
 ZSvBSD73uXARtXEUa5tMliDt4nzUlywxePysvV1eMFYlwsUfEioA0CZ9tx9Y1WvXvelzP25r9AcwAOSa8LN2Y6p2mdoA46OwW1mDa1691xgY/Cd161qJurlE/Wugeaw7aYRHi3U7KpXkrnJ7VJZ573OC0vRtalpVgFv+6Un+7pNWS8QiZ59K1LqxCPNHeKOs4Lbt5oKbiHw/3r6P2cO47hokTyVcmIbYCT1plL+hQC3wGMSQQb9e8pBu3cSYbHkvgo3j23gGnHcheyztKlhJIYdmEq/CkHLSOCIgAV14SMPwTumx97qaKKZ1/RW0oqJ3lgLwpR68tBaj6s9+ODCqeW2H+uzcznIeV51Ua1AKC6Ot5zYXEVlWJnHUtQPd4i4Bx2IR+rjiVV8e6I7tEPswwe0cNUEbFXB78xeMm9Zp4r5T3ErT8JAgoha1SiRmE0EOXAK6/2anuN0SriMp5hO0D4AQZKeyI8ZeFdETi/IkyVtJRvblfitza20lU4pj5SwhenU3yfBrLGgsfXztneKEcx1S3pm1yRNI6lU+gYytD+BbEIZ7O8kS6OJQu6f60x6lGPr655anmJeW0MRQStxx4KnFT8VmCMioUwSulhh23b/5lNvA7fQltEwZ2qpcgarSIJj4PmlorCtIolttnzCfRU53wI26EsKBS74XWsX049HEf+VUdww3IRsQ5FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] mm: inaccurate commit message on write-locking in folio_walk_sta=
rt()
- [Low] mm: folio_walk_start() duplicates vma_assert_stabilised() via walk_=
lock
- [Low] mm: missing kernel-doc and private placement for folio_walk::walk_l=
ock
--

commit fbf030fed81b9a0de749bef1b3fa6307e8400b93
Author: Xu Xin <xu.xin@linux.dev>

mm: make folio_walk_start()'s locking asserts scalable

This commit adds a walk_lock member to struct folio_walk and updates
folio_walk_start() and its callers to specify locking assertion modes for
mmap_lock and per-VMA locks.

>     mm: make folio_walk_start()'s locking asserts scalable
>    =20
>     Add an additional member 'walk_lock' to folio_walk to indicate
>     locking requirements for the walk. Similar to commit 49b0638502da0
>     ("mm: enable page walking API to lock vmas during the walk").
>     But no change is made on any existing locking behavior,
>     all existing folio_walk_start() callers are currently still
>     under mmap_read_lock() protection.
>    =20
>     This change is prepared for the later patch to enable VMA locking
>     asserts. folio_walk_start now operate under write-locked mmap_lock.
>     With introduction of vma locks at the next patch, the vmas have to
>     be locked as well during such walks to prevent concurrent page
>     faults in these areas.
>    =20
>     No functional change intended.
>    =20
>     Signed-off-by: Xu Xin <xu.xin@linux.dev>

[Severity: Medium]
The second paragraph states that "folio_walk_start now operate under
write-locked mmap_lock" and that VMAs have to be locked during such walks.
Is this description accurate?

In mm/pagewalk.c, folio_walk_start() only expects PGWALK_RDLOCK or
PGWALK_VMA_RDLOCK_VERIFY and emits a warning on write-lock modes:

	if (fw->walk_lock !=3D PGWALK_RDLOCK && fw->walk_lock !=3D PGWALK_VMA_RDLO=
CK_VERIFY)
		WARN_ONCE(1, "walk_lock is not expected!\n");

Could the commit message be updated to reflect that folio_walk_start() only
verifies read-stabilized mmap or VMA locks?

[ ... ]

> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index 1c397be0d092a..455428eaf1fc0 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -184,6 +184,7 @@ struct folio_walk {
>  	};
>  	/* private */
>  	spinlock_t *ptl;
> +	enum page_walk_lock walk_lock;
>  };

[Severity: Low]
This isn't a bug, but adding walk_lock to struct folio_walk without a
@walk_lock entry in the kernel-doc comment above struct folio_walk triggers=
 a
scripts/kernel-doc warning ("struct member 'walk_lock' not described in
'folio_walk'"), because the /* private */ comment does not use the
/* private: */ syntax recognized by kernel-doc.

Also, since callers of folio_walk_start() are required to initialize
fw.walk_lock before the call, should walk_lock be placed in the public
section of struct folio_walk rather than under /* private */, and should the
kernel-doc for folio_walk_start() in mm/pagewalk.c (which currently states
"@fw: filled with information on success." and "The mmap lock must be held =
in
read mode.") be updated to match?

[ ... ]

> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index e6493bbe6919e..7d85289fcb875 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -910,7 +910,15 @@ struct folio *folio_walk_start(struct folio_walk *fw,
>  	pgd_t *pgdp;
>  	p4d_t *p4dp;
> =20
> -	mmap_assert_locked(vma->vm_mm);
> +	/*
> +	 * Other locking modes except for mmap or vma read locking are not
> +	 * expected.
> +	 */
> +	if (fw->walk_lock !=3D PGWALK_RDLOCK && fw->walk_lock !=3D PGWALK_VMA_R=
DLOCK_VERIFY)
> +		WARN_ONCE(1, "walk_lock is not expected!\n");
> +	process_mm_walk_lock(vma->vm_mm, fw->walk_lock);
> +	process_vma_walk_lock(vma, fw->walk_lock);

[Severity: Low]
If a caller passes an unexpected walk_lock value (such as PGWALK_WRLOCK) or
leaves struct folio_walk uninitialized, folio_walk_start() triggers
WARN_ONCE() here, but then still calls process_mm_walk_lock() and
process_vma_walk_lock(), which for PGWALK_WRLOCK will call
vma_start_write(vma).

More broadly, since folio_walk_start() only permits mmap or VMA read-lock
verification, could folio_walk_start() simply call vma_assert_stabilised(vm=
a)
from include/linux/mmap_lock.h instead of adding walk_lock to struct
folio_walk and requiring every caller to initialize it:

static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
{
	if (IS_ENABLED(CONFIG_LOCKDEP)) {
		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
			return;
	} else {
		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
			return;
	}

	vma_assert_locked(vma);
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102132416.3000=
84-1-xu.xin@linux.dev?part=3D2

