Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2D5606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RhlTASHM
Received: by kanga.kvack.org (Postfix)
	id B9E0C6B05B0; Thu, 12 Nov 2026 02:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E716B05B1; Thu, 12 Nov 2026 02:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D736B05B2; Thu, 12 Nov 2026 02:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 896A96B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:54:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 130058056B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:54:11 +0000 (UTC)
X-FDA: 85425703902.16.596769D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6DB2D40007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:54:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhlTASHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794470049;
	b=xSxE7EYfnBvjrYf/CEj/C2NzXlKP81ZFDImTbzpHfjNUBmrAPNkJ0AQfb+fYkMO1xSr7Lw
	3OITAkM1N0qqSFkK92LhL7JFWWmmtsVdYSdTpsE8UeiV1C8G9B38l2OAu3TrLMYna5Qk+i
	nmCtLCeEKWQxJr2q7RufGlUCIVDeWXw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794470049;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4s6DPtHecaIws8OsEjwA4Nb5nI6DVYgPSkzZcGuLcM=;
	b=tWUHVkIB0cXtfGGaQWSn0jVPc0hME4f4F2AKJQ8dw5EOypCjHA6UAZMg58p4tK8SePe36+
	q+WpqctWB/9ZGNqmuxBFdYY+mYsVi/wl2Eh80y6OvUgB/4+oRBgDIKAcH5bJYUSkkBjecS
	fhAc3bDqyLiFTG2d+7+NbmPb1SDMUd8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhlTASHM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F3B242AE1;
	Thu, 12 Nov 2026 07:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD071F00A05;
	Thu, 12 Nov 2026 07:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794470048;
	bh=+4s6DPtHecaIws8OsEjwA4Nb5nI6DVYgPSkzZcGuLcM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RhlTASHMzabC8bj4fEMXxIGzC6N7xi791Bo2ze7sQ2rLOukIlIefeX4XbztTCvb/v
	 uF8pAVxBjc6hbq/CcfpuWdOdHCIOkv94Ht8jSgl5pc99Lo0sSknoA4gy86VoyBC4yA
	 SpbuQ/kKhUqSKaYDJi/qpv9f4PSf+sFPL7vncH64nf320YaYh1KuZn4Al4qOGQrzSU
	 PWypapSr5E6lhbdYWvxXJ2VtFjRDahrcUQYVvF2mV04MA1zVOpni8+OwnTOsNffHtY
	 YviIPXKVcFI0y5Nn7riJPzx9L4mfLDjYnFAm7lDJ6Kr6FPrGvDZIprK+SWvO2vXPpO
	 UDmKERlWLKYpQ==
Message-ID: <sashiko-outbox-210638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/9] kho: Make bootmem reservations visible to fleet
 monitoring
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>
Cc: "Alexander Graf" <graf@amazon.com>, "Baoquan He" <baoquan.he@linux.dev>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
 <c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 07:54:07 +0000
X-Rspamd-Queue-Id: 6DB2D40007
X-Rspamd-Server: rspam12
X-Stat-Signature: 3ey6wen3spwe3ckg1qodop3xeuwfm4m1
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794470049-86836
X-HE-Meta: U2FsdGVkX190CiF0EArcg0FY5L6zUmjvwHbMD75NrwvCbCKvXt1tWARAbz+ep3VVSxOjavHu5nSy9hX+wYCMGeMYxUQbypT5nTUEYCkPcQo1r1ijFHIG4dDaJtoX9FGy56xWgb92aIg0280X9/aTSqp9zZh0fEABFxXpa/h7hVuCPUWKbk7IYFUfHrNI/RGTzsLs+AJnSp4KbitfpwHSMrE+sGedJf5zVFfJX+9jeIHtcB+473rd3LGugI6OBh/H5dswV5t0JaOv89FdRtmDSYZQjXlKQjbHS86p0cWjXqOTteux2W3NcilI5kadflVcMuCZzVlGzciJYgYdAa8detA0irGBVwXFkohOEK0KitVNEXrHkNNdaiN47VLgELVtd+dEeHhvsiKoe8rbO5AaZ18PatYdaA2Q0s2wZpqT/fmbfikzWKDb/QcGJQ8PcYmni5x4OeGppS/K55xjx443M4G4s9D9FNgwMd9nNGUpnUvDExJj1OPVxWjT8AtMIzbPzbT+c7Vs6cuaDbHyIohdsVlI4sqrJ1i5gImb1ar4GeKf+w8O6ZSrWkBPEqPiQ9L98i0xe/4jfa5jf10pkEFVJm9FjjiUZCXlKiXfhB85XwHbiOGqSESHYthJV1hQuq+bFjCur24Mlk528ajMQ1hSC8AYdoPbEU2JTxM/LYQMSF2sQfKTmAgb8TfFrLNYEYH11WvYeX6JH0fOOcfCs7BZJh+I03ILnRoz+92v1B5iLJmXQLulYVQ7BmrLeBKzX+/kJ7a8GxLPD+I17E0G6JJP+TilIEZvvZqtY/9u4sEYFm1+nIwRDsk8TnMvZXvMx0aT3Xs1iDBVWAJqGTCeJhCAvj95xG83ZzbRbQ5OhLtz5Ezq49eZTb2eV4T48N/D2cdOerxJ8dbx9kDXAbMxTTTCbATgpLxy+AFJ3rDZtW97fxoXpG+U1Mp3rG3ev0nrLQtxR7r1TWkzidsweU85pBp
 qbYdg57b
 Q7wWRZKJfFaHFXAyHylOiXwjFQvu6NPnXyiUhVvJciPLaRpz61sZjRjlKhQbAJc/UyFWQrL6UM25nWulF7dUMzxGja4jbAVIXzN0Dz6amX9AawJD53A1QC0PMYOAPJBOAgJUYWFyiw5DibWzXiPoFqsooHeZtwxbRmtXkau2LzZeKFaZRX65DY3FzEWYwXnlXlmkn6oG/jLr+mY2bB9DroSfbsciYAKILLdkg3p8nvbkDCATyxaLBu8y0zOMWsG7wi9EAm3q9C25UihQ3D6fd8UfcgNRtvNB2QKYvnY5ODlm56OlpiPRkjbG1nwPJfAxMFUE8JzvWOgLcn7dREB8yfd238bBNvowgjrWg++x/5rMNxj4h4q4qm6vH/QHLrA2/mZ/CdVOhIPSwElwzutXacnJDr9spTb+9hQn41t5tQtRAlQiH3/R+hKuBXXRSuTFDw3EEr2KQbVEO3J5AsDH5+kbl0sWdwHt9NC3YL1IxzFFjbZ9FRwfwyQptztMRqeZdzYI0UszYPBfeXMV0ukot2SrWJpBt48cGTkbimw8ldAv3lG9P3tEEVoPzeEqWp6qkfx7cTbx6q6x8W6Uo7hQeGKAx9s13Fjif6sNDefttIOk0l6VLW/exyV7r59JFywgoDIy93x+ZAoZfoWdH4PKUF7ofQbjkwlFwaj2zV9e8gQcq/yFjRCg3VTFrCsoN30d48cv9lYWU2tyl9eXFD/73qTCq5w==
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
- [Critical] kho: scratch memory corruption on error path in kho_init()
  [1]
--

commit 96d77d1af62b4778bf7f34ac023280de65f57337
Author: Chris Down <chris@chrisdown.name>

kho: Make bootmem reservations visible to fleet monitoring

This commit exposes the total KHO bootmem reservation size in bytes via a
new read-only sysfs attribute at /sys/kernel/kexec/kho_bootmem_size.

> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 3046b89e5db49..21d77e29d2bb8 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -942,6 +942,21 @@ static void __init kho_reserve_bootmem(void)
>  	kho_enable =3D false;
>  }
> =20
> +phys_addr_t kho_bootmem_size(void)
> +{
> +	phys_addr_t size =3D 0;
> +	unsigned int i;
> +
> +	/* kho_init() can disable KHO without clearing kho_bootmem_cnt. */
> +	if (!kho_enable)
> +		return 0;
> +
> +	for (i =3D 0; i < kho_bootmem_cnt; i++)
> +		size +=3D kho_bootmem[i].size;
> +
> +	return size;
> +}

[Severity: Critical]
This problem wasn't introduced by this patch, but on the kho_init() error
path referenced by this comment, can err_free_bootmem corrupt active memory
during a KHO kexec boot [1]?

During a KHO boot (when fdt is non-NULL), early memblock allocations are
served from the incoming kho_bootmem regions, and memblock_free_all()
releases the remaining unallocated bootmem pages to the buddy allocator.
While the normal path in kho_init() returns early when fdt is non-NULL
before converting kho_bootmem to CMA, the error path frees every
kho_bootmem region unconditionally:

kernel/liveupdate/kexec_handover.c:kho_init() {
    ...
	if (fdt)
		return 0;
    ...
err_free_bootmem:
	kho_out.fdt =3D NULL;
	for (int i =3D 0; i < kho_bootmem_cnt; i++) {
		void *start =3D __va(kho_bootmem[i].addr);
		void *end =3D start + kho_bootmem[i].size;

		free_reserved_area(start, end, -1, "");
	}
	kho_enable =3D false;
	return err;
}

If an initialization step such as kho_alloc_preserve() fails on a KHO boot,
free_reserved_area() runs on pages that are either in use by early-boot
allocations or already managed by the buddy allocator, causing
use-after-free and double free memory corruption.

[1] https://sashiko.dev/#/bug/linux-5ae80b0f-97ab-4112-a0a4-c767da72f4a8

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794383544.gi=
t.chris@chrisdown.name?part=3D2

