Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED3C606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i0CwS4xV
Received: by kanga.kvack.org (Postfix)
	id A80F16B05B9; Thu, 12 Nov 2026 12:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58B46B05BA; Thu, 12 Nov 2026 12:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996026B05BB; Thu, 12 Nov 2026 12:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6273B6B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:57:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBC658068F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:30 +0000 (UTC)
X-FDA: 85427224260.24.F38B65D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 310A240007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:57:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0CwS4xV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794506249;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyG0qYBHQyI3CYpq+xL/6g4RuYeGRoGqGgLrH5WKGj0=;
	b=cEYpMXPMo/rC/gXG86G9XizuWuEgZVt+bvVpf42HEGQPjZLdDnfBu5A8PlcgkBzwrbJshs
	wyvNnsikjLhoMfHYFMMFEMTMbQdBy9ESlYbHjDclRLvyORmd8L5q32PZiC4JzrTSV/C3Yk
	2sUhMdgnijIle+okDQ77DMRNKf69Frg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0CwS4xV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794506249;
	b=u3H6ZkckByeJAZTe6Rnme1SEzaD7ABhm6JWjbqvgvWCPdi8mothmoQ+kZkYewCYgU8O5Il
	uxMW4hzPYdjIX+qsovkx3+zitXhfoDUxSrR+u+eYNhtxb+NBwcEUyG9KE1hqUFW1kkW5MZ
	SyGNkh1BnfVOFJdz6oHrC2gPT6IDozM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FD5C418C9;
	Thu, 12 Nov 2026 17:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB981F000C5;
	Thu, 12 Nov 2026 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794506248;
	bh=CyG0qYBHQyI3CYpq+xL/6g4RuYeGRoGqGgLrH5WKGj0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i0CwS4xVF4VrRAjZOPccBPp4yGeKc6p9c9m+tczQowicbuo/SbtbFFvsYnEaHxr1L
	 Sf4wXBzBfAYxSX6mdS9uI3hBBduCPBdH5wTPuoo2LT724qqpxmUk6pF/CLZJZJaifa
	 exMPqocF2zpRC2se+8Pwd0peCSmHOXD0FTDILV237qbwFllkXBWA8A7UKDOEe5R7ue
	 khwZWDVWMVVu/MN+oa7DomGiySQFB2lvK6jOQkslpj7SVM7hWNACOtXX+VU6nn4P0G
	 0wuSb9HtMzDr4RJfcLkqxRvzmGqwp0ifenM2TAOH849t7pVigRh2zXtuDkdjWIowFa
	 SyyH6uU8dWaVQ==
Message-ID: <sashiko-outbox-211653@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/12] mm/madvise: send UFFD_EVENT_REMOVE when
 installing guard regions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>, "Andrew Morton" <akpm@linux-foundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Peter Xu" <peterx@redhat.com>, "James
 Houghton" <jthoughton@google.com>, "Andrea Arcangeli" <aarcange@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Balbir Singh" <balbirs@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?b?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, "Andrei
 Vagin" <avagin@gmail.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muhammad Usama Anjum" <usama.anjum@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Chris
 Down" <chris@chrisdown.name>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, =?utf-8?b?TWlrb8WCYWogTGVuY3pld3NraQ==?= <miko.lenczewski@arm.com>, "Michal
 Hocko" <mhocko@suse.com>, "Mike Kravetz" <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 17:57:21 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 310A240007
X-Stat-Signature: bacq98ygntchqb8iqs88p6zmfc6uwo8r
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794506249-936756
X-HE-Meta: U2FsdGVkX19y1TUqRdCpClXp5XNc16nQN8xSavMRSNrwvsVk+f3eIsCM6tSj1etsyVg2zJuMG3YTO9pO9DhKTka3MLSHmNc+V2IbkmRtIXTksKMhtlKwyIeiZU85DHYdu6t2JUTncELeJexUcoUqqmQKwdHDmQ2MUKtL1nUmLdCjvmTpDuRmEI9W4xlZHMpGJfNWk0G4gFZgSxeJOVKv+rKw9lWhphRTe97lr5BzsiYv9hsV/zL8uSOhvj4PZMj9E0r2XLpmOruKReX+NnnXmHRvYnbyVS9C5cKZBcFporxUdpLxQRePykwInkBfLT+7Si4PH34CSQJ7axe2K0799DMH3Fs965ehH4rLpQL1JqMBdHARBODAv0KkTqX14fbvJB2gW/NZqlkm7ptVnxlVp94/O59vF3AQjqWyvfGQhhX0A0RuKhCavr71tAdm+biNbgkp1nohL1YOB+xYECc3L7n3a9MLRVgjWq8+SZ47kUsylfpW9vdcYeXJXBJGhxbbqClQIR8S838635Ty3swN8kWg7v7uZe4ga+1YBEcehs1MHiZGxE4UBVo62mzqnCUB9YRvLVqRiq2+VIk27cgT/lMwYUsMzRIs4TnfTnsqGYOWL5qG6b1Nk7ys6KCxKZoEq/yJJDuCT7EzXq1XNk8fyXrNcNqdsIw2ucdSlDuSmRn/NFcqj74FukvZiFcFzPAZbo8IkygYDGwdvbtSAj/9OWHN8Dsgkcfl9VuyknadA9Q99oce6QLk6txB7sVSxDPB6x1uK++uKBuI+E2ezd30bgnMr0a3pPFLKHgp4ZLEaOMabIgNMWqMJtqaK5qIWpIG29ba9x1euhJR7ttoxSSfLXtZLC107YtwTzxLX4LR4UbZLXBD3Q3sFZkoL5VYvc0+6v7VTYMEel4ce/F6NhxNe4bQxX17Byb9/E9ah0xYfau9TS4IR0JJdxSmaCfM4f0a6zj7Q+riexYqcKP9sci
 haajB4fQ
 qALfrIJIyOxncCx/gA3T7+RZsCRJDEhX+nwqyI73CRr4cnebzW5/6rHGL20W+bCovyQao6gnoSOzfeOBepU7RE343xQ0ndNf8MYnvZxzixS3KsN7RMM31dED41ACfcnoGQutQDdAo/JMf55LmvLfUvJjbmUNL1zfkKHomlqBcyxbAv+Ve6iR8gMRYcgtp6zXjTW5Odn5axKJoe5ODQCPQQgL7qr7fK/vuDoqhOMGC0dz7UiA/NSyHIJTkc33UYHvD2dTz6kfEmgxr7yBDMhUC/VNKAyWdTBSEhBwfLIhjp7FXm88z2lDTGrcE7TwnVoYNdpQ8h4isq0wT0ASgwxvt62Jwkqdx5eKY8Oo9tw/hr4qgQSl4bIT3jS4JAWejJzOfzvcQ+KCeOsXzT8zDnJ1le9kVCijM8DolTF8qlhhkgt5nciCze68haHfyunqKH6g9BJLo0ay4u+HaS71baLRG2sRpRUms9F5J/3mr2zIPcWbjeCpdWHHy6KXYCTkSN0liO9LvJsLvcziysPsrPwUNfRTTez5v0NSxiM67bSE6kVD1PLOCExxri8XmU3rAcQ3WySB1J+OJs0FN8I3yMHL76tuX+XO3fvCTDdJMuLKZBEYvCB9E0NNY8Jqpy/3pbMh4hi+X3l8cYmeccSrHwt+X3pe6Dj0Dz7pQrBKsL3Hdw4JLVqO3ob9n3jVFOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/madvise: missing can_madvise_modify() recheck in
  madvise_guard_install()
--

commit 8be4fedce36f0b45069f1f630f0d9241d579512f
Author: Tal Zussman <tz2294@columbia.edu>

mm/madvise: send UFFD_EVENT_REMOVE when installing guard regions

This commit updates madvise_guard_install() to call userfaultfd_remove()
before zapping the target range and re-look up the VMA if the mmap lock
was dropped.

> diff --git a/mm/madvise.c b/mm/madvise.c
> index e8b05dc899f10..6413f0e65381b 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1166,6 +1166,29 @@ static long madvise_guard_install(struct madvise_b=
ehavior *madv_behavior)
>  	if (!is_valid_guard_vma(vma, /* allow_locked =3D */false))
>  		return -EINVAL;
> =20
> +	/*
> +	 * Installing guards zaps the range, so report it to a userfaultfd
> +	 * manager like MADV_DONTNEED does. The VMA can change while the mmap
> +	 * lock is dropped for the event, so look it up again.
> +	 */
> +	if (!userfaultfd_remove(vma, range->start, range->end)) {
> +		mark_mmap_lock_dropped(madv_behavior);
> +		mmap_read_lock(madv_behavior->mm);
> +		madv_behavior->vma =3D vma =3D vma_lookup(madv_behavior->mm,
> +						      range->start);
> +		if (!vma)
> +			return -ENOMEM;
> +		if (!is_valid_guard_vma(vma, /* allow_locked =3D */false))
> +			return -EINVAL;

[Severity: Medium]
Should this also recheck can_madvise_modify(madv_behavior) after looking
up the VMA again?

madvise_vma_behavior() checks can_madvise_modify() before calling
madvise_guard_install().  While mm->mmap_lock is dropped inside
userfaultfd_remove(), another thread can make the VMA read-only via
mprotect(PROT_READ) and seal it with mseal().  Because
is_valid_guard_vma() only checks VMA_LOCKED_BIT, vma_is_mm_backed() and
vma_is_hugetlb(), madvise_guard_install() will then proceed to zap pages
and install guard markers on the sealed read-only VMA instead of
returning -EPERM.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-uffd-state=
-fixes-v1-0-00713d368976@columbia.edu?part=3D11

