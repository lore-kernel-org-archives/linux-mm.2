Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A353C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8BC6B00D7; Mon,  6 Jul 2026 06:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA90A6B00DA; Mon,  6 Jul 2026 06:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98286B00DB; Mon,  6 Jul 2026 06:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA6A76B00D7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:57:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C77C1C71CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:57:03 +0000 (UTC)
X-FDA: 84958049526.21.2B84230
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E0C3C0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:57:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8agmxFZ;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783335421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TtrHnv/qi4lGfcA8XXpkBAbAwnFcDJBMSEy+F8GNE4=;
	b=jOuPJgkBMZdbAUVEtA8GGJj4gDKmoYtDqvMkMBLBdWaYnCvTD74tHp8K4Lqo7cvY1DJDU+
	B1hE6llGSDAyO6Jie0pdDQtZAZJlfyCDg4gwd4+9j+wOGiCq/P4Avub2sQsIitmoIIRVKz
	YNqLF/GVFmJpQOD6+I3octTR3O6jUp8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8agmxFZ;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783335421;
	b=YD9thvTsI5C+1VS1eh3tMg0hdf0ZryGh7Z9Cnk0JkgbWBBrs6MQ/oSu2T+6wL3MpKsdBxx
	rqmSi6jClFrgycz0hln9Zl2net4zAgbmZf6jy74sB+caQ/1ah/cukt38xpxIOtRyV3TN3r
	oI5tFneIWZDKZyZX1uBdqq9OpKKrwfs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBF7A600DA;
	Mon,  6 Jul 2026 10:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E061F000E9;
	Mon,  6 Jul 2026 10:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783335420;
	bh=9TtrHnv/qi4lGfcA8XXpkBAbAwnFcDJBMSEy+F8GNE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V8agmxFZj4+EhkprkJmhAyZXVvYWq4x2s9TtPvI+aPJ8hGRyPxKHBvIoSKehw29Da
	 1ANy+GCrq2yTMvNHJ0c4MOFTIAChl8fN7PvEpo9iUlCNqtmwUvdSFRSwMB1ubc/nQj
	 7Kl5KyOlqrk9FTmRVfFFJN1F29moAA+DqFyI0hUZHBtIE1Sqm7pIXa3aju8hzvzEzN
	 yz3HU/aqF5kI22n3IWq4tF5c80AmHLNdEy4keV+b962CnuvzXWIYldJkYxyFdhkEZI
	 SPNGHbDXhKh0KHIRsX8Q90irOU45Ew10VuKnzCwgDhU1gvkCqY79zdIrqvMz9lqWfG
	 nl7hGW6N+VV5A==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id B08FEF40068;
	Mon,  6 Jul 2026 06:56:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 06 Jul 2026 06:56:58 -0400
X-ME-Sender: <xms:-olLat-EzM_LJwbXNIQ8m56H0bVx9T6l27AEua0Yr2b4oHBccVmH5g>
    <xme:-olLavV3vjXB-MrU1kPh94pWGUZC8oDxWnWecG0IDU6ewpN5OCz3lisE7yWX6X69I
    B8gNQwswO-9iSguLvYfUnSD4wMqTuQ3gjH6G7-pzTVOj996tqTjpGQ0>
X-ME-Received: <xmr:-olLagn3MWU5IvT919tfLF_S7hWKq6sYItMIdnVuDOnEgecUgbBYerrQTpAMLA>
X-ME-Proxy-Cause: dmFkZTG3EYxLj0L6vaHvG/JQokkQgmlapkgHi3g9IW9kfpTZuouF9wXLqvehvlO32VWfHa
    duqkk97Xe0HKhXsKxrdHqqNxki8kTptiLONgzXROpKLThcjWTWcvktV3WT6NtElSrQ5L7P
    JC+8p1nEl3HCpzViXlrhmV7vSWrcMtCeweeEKVIc0uVTWaL3+3LvWgTvlFqEkSG644EqaC
    oqD3l16HhA91FHOyL7u55F+RtRGyI/+KZDctCzRTvb3v0JOvk8HJd7JFhUMAqaGDdiiTjG
    VJjpfx1J1Owby6wkIkTfqdvO8SvfXk1POhBv4co9Qvufd9gwLSR2FgcbkoO8MgsA+1wnBo
    tz1w0KLGYpnTvNPu2XdlVEYx5zQx2A5k+0L9Vu5OB7grOD46Efooqb9DRDr5hGTPgX7rqR
    9a/DHNcPYA9z16Dok0ztAUvgOMFTW1aqy4hiJ440P6na09coYDUsMlVHK58n8lwLiIrFms
    03p/Vv56bjGS9mOT9oO5JqsJBQ1HDQqo7av2kSyyD+W52JyHMwVlTNRuzzaPHBRR4Izdfb
    C1bOzI0y5MFPEfrRJO0l/gMpuuAAjgxbxNJcFyv/wUIaY/JXRGzw91DPBuh2Q+GlDKB45h
    hznAG9RxPe5JbMCwi9l3NRVHBeAdUiLbY8Hxn33k9Z4QOJeGslOFTfzTA5wg
X-ME-Proxy: <xmx:-olLalFYYTvofYxEUV4s9LShIBvRseh4RZY3l3XwbNim4X8QP7C_-g>
    <xmx:-olLahSww4oFsZkGr0J7Efk-r06k42NJ3jQWsjf9L9DHyvqQtMfM2Q>
    <xmx:-olLasQMu1HWGipJb8c6Gu-6oG-UxEDrU3Z9jjsolCTTatjkCCsuJA>
    <xmx:-olLavcV5UuOm9YI0rEV1Yr6GswCbsa_IihLc5PiVHsX102z7qRLDA>
    <xmx:-olLarBWU9ljjQU2yd1LTse5SOgGNCYTBY51sYKZ4RD3uRE-duKlpfv_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 06:56:58 -0400 (EDT)
Date: Mon, 6 Jul 2026 11:56:57 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Addressing Sashiko AI review
Message-ID: <akuJmbUgGRtjksPr@thinkstation>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E0C3C0005
X-Stat-Signature: tgxp4kg8e1p6f5wttztyty5h8xzk459b
X-HE-Tag: 1783335421-917416
X-HE-Meta: U2FsdGVkX1/4lT7zW9ZTUHlEY41zzv17Pc+AMhTYGoQhmvoA/wD88DfBNLNC+I50jp4I5R/cmelaydY8xhM7s960OGNOcLjnupzN5VCEbEmnYcnplbp7xtiXycv9pwghkX43aWCwaPcm74IhvtJOJJyGdZ7mdWTvEg/gJyMBkwwpdr5+w/VoxkbkOdlj3ez8NkkJyuV2ghFhIIbcVuIzfi7jAlyeEulZz8UeMtegZcN6so8qTIB6VIpn1G4mjofBLCaXI4AxD4k1GyC0KWIdNSUA+P4MB8SuZYl3n4w4UGKB9QImIiy1QY99RMHnw20q96Yn7BS1b1itKiM6lal4BxctssDXEBD6ljozAublEZ8svQbpaJiB5n/CEgvtMTFhLYBh8/dp+4LnKCkJjeMHe3zn/ynVMsHLLW4aCXNLgcaTLYHf6vffMaywYaq/83QhYj4dalQjMJw4qIHDbmIAZArbTMVIuaPcD1zQUKM8S2e1RcE2bzDVvV7uecR58ZAN56r9HdbQzY/VwH8aKi6xORSxUrd1bssoKy1+Z/74UYszQ9sJ6qVlXPTO1BgpSQaCz9Ihr3OOOsw9UzBEghz5zn1jjeT1yFMLTaq8SkwKCBsbNjHVtty5H73Xyp7T6YfeMeGSo5dOrajVs5g+uAlQQ3IED/7KFnTjy2KB4QwCRc9uX4vuKWehPIZm6z373eFHd2wgZrBb8l/PAfyviT7fjtJegtouTVmoPIUck/lWdFc2inxgNJXCW1VBqpHsnWLnkhNoZBN7FUtp4BWAhl6bJl82uH/oPhITyfuVIREShmIx9p2zjDyp9QfgsPDSwpLHJ48gUsehi5/BK5G4ssTlFpKrBeg9m33Q0F2LnzO73XEljXQN7WYwqC+vgLZOEWnior+TWTr286i29m9cuXlVRI0yqlJKalgiEe3ZCIRyuh3HuWzw0a1f2kG66DWYS9myfki+V0cpwjLp1KoD9AW
 oAFopaQM
 UjrVlYTc8iOkjZelYKRxydf2aBQAoyp7MPHdNH4Kr/IbZrByjhyGFYi1+m4tNLg4lyPGerEC84M9IPh2s01hIfwnEFJnyAo9Hje8mNG0GbZZUgqQsbGmfLhwOTsRWiJhXeaEMgRoE+ov1CT0YzmL5T4rQVl8rDh2Ua71unQaW23VD6yDqz4TFmpOzibq0ejtY2UU2PndgHEYoqYvwnP9MXLz/ahwiAZ005kDlulD4dLKF056gL5yJfdhfr7MVLNlZIkT/VbHsuzcg0IJNcOh4f9dwOMPYJu4T8epwJFkRWylvpgKHG1jdcrYRczUGqjDL/NoUdfENUeOmilUZOn6/bDFoWK4UbhfU+RMx9Tt0ak3oWyiU/gw+XJOykA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I went through the Sashiko review of v9. Only one (test-only) patch
needed changes; sent as v9.1 of 14/15 in this thread:

  https://lore.kernel.org/all/20260706104906.36084-1-kirill@shutemov.name/

  - Tolerate EINVAL from madvise(MADV_NOHUGEPAGE) so the suite does not
    abort on CONFIG_TRANSPARENT_HUGEPAGE=n.
  - rwp-mprotect and rwp-fork-pin now assert the marker survived
    (PM_UFFD_WP) before the access that auto-resolves it, so a kernel
    that dropped the marker fails instead of passing vacuously.

The finding against 11/15 is a pre-existing PAGEMAP_SCAN inconsistency,
unrelated to RWP: an unpopulated pte is reported written by the
PAGE_IS_WRITTEN fast path but not by the generic path. Confirmed
reproducible; fixed separately with Fixes:/stable:

  https://lore.kernel.org/all/20260706104308.34741-1-kirill@shutemov.name/

The rest I assessed as false positives:

  - 07/15, move_pages_huge_pmd() corrupting a non-present PMD: a
    non-present source bails (-EAGAIN/-ENOENT) before the RWP re-arm,
    and the post-lock pmd_same() recheck rejects races -- the re-arm
    only runs on a present PMD.
  - 07/15, UFFDIO_MOVE re-arming RWP "destroys resolved state": this is
    intended. A MOVE-installed page starts tracked; the next guest
    access is the working-set event we want (async auto-resolves it).
  - 10/15, hugetlb stale-marker livelock after UFFDIO_UNREGISTER:
    markers are cleared on unregister and on release via
    change_protection(MM_CP_UFFD_RWP_RESOLVE); the rwp-close tests
    exercise this on hugetlb.
  - 13/15, check_stable_address_space() before the VMA walk in
    UFFDIO_SET_MODE: the ioctl holds mmget_not_zero() + mmap_write_lock
    and only takes per-VMA locks, and a ctx on a failed-fork mm is
    never published to userspace.

The 09/15 findings (userfaultfd_clear_vma() touching ptes before
vma_start_write(), the partial-unregister OOM rollback, and UFFDIO_MOVE
dropping uffd-wp markers) are pre-existing and left as-is; pte-level
access there is serialised by the pte lock.

Ping me if any of these assessments seems off.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

