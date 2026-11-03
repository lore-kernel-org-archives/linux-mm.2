Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD3C606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 07:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZZPo1adm
Received: by kanga.kvack.org (Postfix)
	id 71D5A6B00EF; Tue,  3 Nov 2026 02:44:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6BF6B05B1; Tue,  3 Nov 2026 02:44:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F7B6B05B2; Tue,  3 Nov 2026 02:44:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D91D6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:44:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5EE7A0331
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:44:49 +0000 (UTC)
X-FDA: 85393021098.06.51E8970
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B98520006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:44:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZPo1adm;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793691888;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BIhgQLv2NyDIwD8Fnq6KsXyaH2Z6fedue8NM/mTDEg=;
	b=0lg8A/6jDmDbYC39SU/RXW43IZFVj53ncPEYU4e5sO3Y585pOMwq+y7pGt4BNDJHeTLnB6
	FvVmtlQlx9383ClWdY7zThCnhMmt8B0JXekbyO75sQrR+CP8OruPOWcLnKxYBQAU33cqAB
	+PFjW028OyFRP0pdBzvVC8jxZ6pBPuo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793691888;
	b=0Opoo8FlYdsjzAXrKUBI6UpRY2GOufL8NYJpMId8Bvu8fp3Dz2ZUuSfVpJhJzMcCKEgqAV
	aaqyXp6MYP10ZIaNmvSpaxylz8uPw2rG213eSy57mfcqQ246GkGVIZQrIpk3PosFCkbJFp
	VlV5e40tchVV4y/uM7nlFJEKfU7Obr8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZPo1adm;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF3C540870;
	Tue,  3 Nov 2026 07:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296531F000C1;
	Tue,  3 Nov 2026 07:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793691886;
	bh=/BIhgQLv2NyDIwD8Fnq6KsXyaH2Z6fedue8NM/mTDEg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZZPo1admf4fI5iGR1B2raC9RLxD+VfyTQfrpUNc3pMHo9Y5PNxI0vOf+Kv7Js1tWr
	 QBHEIE8D3x5O0XrjA5pzEYoT+MRXtMaVkKMWRA6OGvVPM/jqSfkbgXV5fI7gTdvbYC
	 FfIPOtCMCZkMqYApI2+aURYEoZMJEcZjhjEYo8l45FvDiIGWAldMM0s1n03T2Mton2
	 gyOPpnn1eFszaKiu75e8ZftfXb83RT3m1uJwPTlK30mJE/4uP5/KSF00JU/Kce3KkT
	 V9vD96oUsM3AUepe+1iDPaq1svCWo4uiYakWxpAt0N5oY7zpSUm3KB9m5/ZOrvMiWX
	 eMSPRQlJVQQug==
Message-ID: <sashiko-outbox-194732@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/vma: fix NULL anon_vma deref in validate_mm() under
 mmap read lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Songsen Yang" <yangsongsen@insta360.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
In-Reply-To: <20261102074414.10902-1-yangsongsen@insta360.com>
References: <20261102074414.10902-1-yangsongsen@insta360.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 07:44:45 +0000
X-Stat-Signature: nug3shaxmj1q3yi37wssh5rcweccs856
X-Rspamd-Queue-Id: 4B98520006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793691888-192812
X-HE-Meta: U2FsdGVkX18gmJZAjTkP5+RAr4wHt/gEF4GzfXu+Bu0rCpf5iqKZFq0UcZcYK1M8Kp+bL9G8A2NmY/pysuT6EIQVtbry2fuffqOePfsn8unwOQ1+7fC4GvfPjlzo5YCaLeBeXbeF1ZwDtqzquSzWrIZ8uDLpTF01x0afUxbf5xw6zVEYm/uXAxqHGDQysmgj3ngMQ5f5ZNjnxyTbiJocrtHCIUzvvDPN66Lwv3wL0PuPngRxAelfHsfsxm8urNi914y+YJlz8X2vUP5zREpOtrB84y5v2gpopN5w1UjWadEAkjrCpBrNArxqZDuDNNrUtS1SrVcMgOJ6g19Ijd0vlORJUD5Z0UHzgllq8NDJA6YitOm9+XEW7NXCjhSA23DE8nQHPzQ0Ry03fZg0dasl/qQh7FJeiexc5Nn0n/h73i4TJOd254WhPmTwGwtr3IGihZjFFJWq/aX18sisHLhykTFOP+dsSG2v19pI3dBHtg3A4RwV96uKYLJGqQ3r+o6WlUPqFKmodYyKIIBiCSKyJ8y7uTUXJhMAkIWTMWjqO7b+Aw9/Wl8bliQw2wc6IQy+dQHaoTaxtaDp2iNZZDqJsf1IsKWn2JZMwxSDFkzWmEAI9x3z0SOUm8EGNW/fsb7XhX4pDx0imUAeBf0o2Xai0KrfczVCLcLEvx1jjRGnr6D7I3nT/eT4/uiPQ/2xKIRBiM63aydmS3m26kr65a2S9+R54TkvP5nT8jAeARI7iMYrcPIclBewvdZ49mGj2h3Y7dOx1kcW3+gAN9KmIBHaYQB1CRtEn7kWA+8hieMNNrHsu6DJhQL139FwJk9GYo5i+Q6M/tC+es+prt48e2TMU/iv3pk/vwFbZqJxif69geaNTDMZxyFh4M0oFamUQqzlcKbftMMWhnkZAkpaHli8QM7zV94L7aM0fWS/adJaEpAKfp23iM7PDPww8lZ3A6eX9NWrNzHTx4fvIDHiV0x
 pqqqV6ij
 QmDNdccL6YRrd0jVAHOVxq1I4tV2nfjwv4QAHdRa5Y/+JEwLoDKBeJ19d7egDcbPMAIgjLvASY9G/2qq8MrOjiVPtFPU8N4oyB4PmdAQcNbevKF0u/eGJ4FpwWwvOBdIyfAUxVyYZFfzTcqT5HlXdanryLvjSdbSPpGiR6OYDQuzYOmclK7mcv/cy2PsdBPxud9oYMgkFr0JOQSmjAr3FdQTvMwwH1M1ZZ01NRQCPdErBNaldZpHEcSUyAdwdorJtLh4TWCIBefOJHYBRkh9cGtcqttHvxZhlFoDMkrEoQoAJmtmKRI9MWo+xx0PQWs2IR80zQ46YDJ3uwaa+fF+PTRy0UsBFXSXE0/W2XC47pltz4/+07Jy1ktFKvBm0vcfjFjQ04yIbIXrIuTiDlWyLdSL6a9LAugwwlKtuH493fcoMWqFZFJCXkXBXdkBlxCXF5gHu/EqaGYZ9LNvog1tYxtQQAeENj1EP/YIISmqrJFWGwZBjx86ROR1Pg0SBec/FZ0taIGgOALK71RuVY+xWRvg2mYcLEovXWLK+OUlxQ76J27CNVkBeHo0eouDNS09k+kytiaBaDQ96C4JwgKExLGopEvHXoIdkWmnA4p/3mPHgKmfkOfw2F+raYlmjQh3PufWmRadh7VU3A0Dnopw9IbUSgKKlKGjsKZ1fuy4aVy6yEVHS5flusBxStm4TqPAbND3gwOJ5M1iid4XuCqyJOfj18+qdVXiMeksESnaxOFpiop/ZMdSHRycZl+BtwoHdj1LN8ACLWLrbSxLqZcXTiHg7x0uuIKcDgiZ5ryU0hZqOw2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/vma: use of data_race() instead of READ_ONCE() in validate_mm=
()
--

commit 3d1c343bc8c8b0bc43d0e0e2048a1459c107a3cf
Author: Songsen Yang <yangsongsen@insta360.com>

mm/vma: fix NULL anon_vma deref in validate_mm() under mmap read lock

This commit changes validate_mm() to read vma->anon_vma into a local variab=
le
with data_race() before checking it and taking anon_vma_lock_read(), avoidi=
ng
a race where a concurrent page fault installs vma->anon_vma under the mmap
read lock between a separate check and lock acquisition.

> diff --git a/mm/vma.c b/mm/vma.c
> index 4672d420521e3..b674c69f720c1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -679,7 +679,7 @@ void validate_mm(struct mm_struct *mm)
>  	mt_validate(&mm->mm_mt);
>  	for_each_vma(vmi, vma) {
>  #ifdef CONFIG_DEBUG_VM_RB
> -		struct anon_vma *anon_vma =3D vma->anon_vma;
> +		struct anon_vma *anon_vma;
>  		struct anon_vma_chain *avc;
>  #endif
>  		unsigned long vmi_start, vmi_end;
> @@ -703,7 +703,13 @@ void validate_mm(struct mm_struct *mm)
>  		}
> =20
>  #ifdef CONFIG_DEBUG_VM_RB
> -		if (vma_has_anon_rmap(vma)) {
> +		/*
> +		 * Callers may hold only the mmap read lock, in which case a
> +		 * concurrent fault can install vma->anon_vma at any time. Read
> +		 * it once, so that the check and the lock use the same value.
> +		 */
> +		anon_vma =3D data_race(vma->anon_vma);
> +		if (anon_vma) {
>  			anon_vma_lock_read(anon_vma);

[Severity: Medium]
Should validate_mm() use READ_ONCE(vma->anon_vma) here instead of
data_race(vma->anon_vma)?

In include/linux/compiler.h, data_race() is a KCSAN annotation that evaluat=
es
its argument as a plain C expression without volatile semantics:

#define data_race(expr)							\
({									\
	__kcsan_disable_current();					\
	disable_context_analysis();					\
	auto __v =3D (expr);						\
	enable_context_analysis();					\
	__kcsan_enable_current();					\
	__v;								\
})

Because data_race() does not prevent compiler reloads, the compiler is still
permitted to reload vma->anon_vma between the NULL check and
anon_vma_lock_read(anon_vma).

In addition, when vms_complete_munmap_vmas() calls validate_mm() after
downgrading the mmap lock to a read lock, a concurrent page fault in
__anon_vma_prepare() publishes vma->anon_vma with release semantics after
initializing anon_vma->root on a SLAB_TYPESAFE_BY_RCU slab:

mm/rmap.c:__anon_vma_prepare() {
	...
		/*
		 * Make anon_vma fields visible before anon_vma is published.
		 * Paired with an address dependency in reusable_anon_vma().
		 */
		smp_store_release(&vma->anon_vma, anon_vma);
	...
}

Unlike vma_has_anon_rmap(), which only tests whether the pointer is non-NUL=
L,
validate_mm() dereferences anon_vma->root->rwsem in anon_vma_lock_read() and
anon_vma_unlock_read(). Without READ_ONCE(), as used by reusable_anon_vma()=
 in
mm/vma.c:

mm/vma.c:reusable_anon_vma() {
	...
		/* Paired with a memory barrier in __anon_vma_prepare(). */
		struct anon_vma *anon_vma =3D READ_ONCE(old->anon_vma);
	...
}

is the address dependency paired with smp_store_release() guaranteed when
dereferencing anon_vma->root?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102074414.1090=
2-1-yangsongsen@insta360.com?part=3D1

