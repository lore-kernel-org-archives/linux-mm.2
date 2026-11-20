Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4ED0606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hfABvtOm
Received: by kanga.kvack.org (Postfix)
	id 8DC256B00EF; Fri, 20 Nov 2026 10:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D046B05B0; Fri, 20 Nov 2026 10:57:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B796B05B3; Fri, 20 Nov 2026 10:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 469816B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:57:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37F484078A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:57:45 +0000 (UTC)
X-FDA: 85455952890.01.A0944E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8C36B100009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:57:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hfABvtOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795190263;
	b=h/eNTY+wApwJ+Xuk/USb8lv6+w9tviW5GXDO6SBvRPTvu5KM47UE40m05wwb70syjEV+Wd
	VlU/j149P6AspXcWgt4tPbLHVAz9dbNH9Av9L2CNgqW1zCKxpKQE9NfwGlEuOz5OeVIeGM
	tXydkHeTqd21KmdF8ySs+gB2W9KpOQ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795190263;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noMk1z2Ae6H7U0tsX7+uE6XcQ/8Lf/7kU/gWjUA31Ww=;
	b=MlK6xVPwXCl92lLknkx01oZ5/dB5tmoqkPQLUBslnIUOaN+vjpaNfpemXA3RCl5421C47S
	cT6PIR57JLZ2GbIDll9x+X7PBGgJbq/R0M/rTbAJ92DylM0OFUVrWf5fE9u7Fip2OYO9JU
	6nDD5dOuTOzNyWUpZWfQcWyrDD9QINw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hfABvtOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19142602BE;
	Fri, 20 Nov 2026 15:57:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4881F000C6;
	Fri, 20 Nov 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190262;
	bh=noMk1z2Ae6H7U0tsX7+uE6XcQ/8Lf/7kU/gWjUA31Ww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hfABvtOmOMna3roJwbNkZoz2ldPF5UUwXR0Ghlje5Mir7EegraqGPxjdm58lo8JWH
	 2kgGwtCzabsO+Ji1kzq8gI5lYS59rhFSWFyuwkVjHsO7mtp0N/0lNZpIEsZiEB7ZaT
	 4hQ6Yq4NNKLPm5JvjmAeWSq5b8JEhA51VwX8ts2/to8P3nw0Dk2Gw0vMnK+wTvIIYw
	 MecTRdkV8kfghC5LpoHVSwUkG0/1L2TmMSDc37JbxcvMpproRXzsj8Y9aljY0IUENi
	 xlz13vaMWptkLEFRDads/iLQMpP3RikzQzh6+/om0DIv+DrvA71KpZwfXa3HbFzwpv
	 E3dBb3gfsODEA==
Message-ID: <sashiko-outbox-225486@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/gup: unshare-check every page of a pte batch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rik van Riel" <riel@surriel.com>, "David Hildenbrand" <david@kernel.org>
Cc: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "John
 Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Lorenzo Stoakes" <ljs@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>
In-Reply-To: <20261119105701.3f57ac54@fangorn>
References: <20261119105701.3f57ac54@fangorn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 15:57:38 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 8C36B100009
X-Stat-Signature: aj9kwqp9upoyyakmq4qt5n9d69ioeip4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795190263-423360
X-HE-Meta: U2FsdGVkX19tGGsyvw/AixCXOZ+mEFyNTgrx2YZPcikSeNUX27v91mVtpazKYDRKfTbIqQaze4GtIc+Ds8pjWmmsjeX+/2DuerlJYDb2COEIAOMfaGStY8N8tHHm1duS4io3R6OwaN7TgAxfM+K34waWpsokcZSqs107WUuKGoOYCpWF1X4ETVSPK4ECgCuOAwG7RpOYVQ5zQAyyfOsdZak/UUP+GsXZGGG5qUaMPzR1p4TlEKN6vn6gSgOGri73bjxJG3xR8Xra5r2MuaqIXT3r3jEOyHXaowSCZrbBaFYJlH1JhehXMW147WgeLETJHEH0p3iJlVsx7cSDlK+CZHUGXhe7Tr/xUYCBaSGVSKTTmfZ9l7HrVOP9sMM51zqSElIcYubGXhn3o+8tpYE52S5OORLC5CmgRy+8zPaKBc53SZcNHP+vwTdZmSr+sp/lNU1VztIEplMT8ERikpKBdIozNVsZ48axTnIUitZ0GxnNxToGqA/d51qnV9eyAD/dqd8icSsVc5I3XlW8F0Ap7rKhjOzpDywrIuC6vekm5DIUQsK82PkQLLHlRCSTa0jPzIG/H8/oFPxjNpp/rf+rUcafKA0SiCPTbrSXZfN9VaiJ2OIqCSfaO3SjjEfMdVmmVPk0R/LyvI0UjvF+cTklSaDFg0acuclwspsDyhVEJqqGL4XFNnuPP/g7h3eJhsVH2Lr2sSCjUZnw4RrmmQwvDc32z5vKIGHMD/1NhWM87RZsRpdvon0vYekbvJ61zhWNmSdtQDQMW+XrsVbeqdKVYmJn/Uw5AUbap4RlMaVIXDrpjiQSN6CpsEUwBkGS4uPyesaaoxGPR0CYtS/NRcy9lfA99H0h0XQowMoRJf9RQ5jR3rRpsuT7+3KBNtkyS6Ceygs6U36ftu0O5fRNRUwBXVBLqhRngfH57I5FLHJNB7n2dX3Z7gS6HF0Zp0GYGUkDk+6xYCINXn8v5lOriLV
 rNwU/E1A
 GNhedyCeIw068w47wl4Twfc9+46ubWE9gktjyYN3iGO2IfNYyo3N1NQEuD1D3zF/FFX47H1Vikpnkyyyj1BULG9xcZADQ5PwGCutJfuzxF1iiA79b1exTeHxNLwYY0mDQEYzHF+zPrETxwK/HiGDDNXOQwvHHuRQiDs/7uWm1ZIoLw79dGTEv1S8CfzHAq/n3FnsQpsu8nkfTFiTco9ekMAmmMW+VPUKd9sn+jrjEAHrMvCH+Qr72ulMZow8tiPpfCuTajYGQfzpMDqaB4KfOYUL9iy15LAuUDle2oEsh6EW9rTLIC6WVF+vHRKYqGXnfHWZfdbPpfwzTMnS9yBi/JVlcxCrjyU5cN8dZmiDWQZMBBgnuvnoRBBY3DbJS4MgAfCTap4B4xas0UYCBvIDJ43Hv7gPQ2G0H7sUeu9JddYQTDalrPv/xtqtYKXvm+nrd6A+OWdYqcybeKdYB5A2n9zT7eAlw6iPM+9ICbTvqkIH2zuB6rtUm8V21gsA//uwrxIoWtmXt1AzO1bA8AE4GJBW4OGr3NYvSVGcpedRo11BR0DMPi+tR+Q4p42rby1q1XV8u56s5q1l1YOp45Hco4wRZIQZtuuOQu7ywFbiQ/hNsZdTl+VkzsyoBTChjFS8rQPOWoLL3qIFuaPkP8NjCLDZj85C7j3I2vsaVV7eAUJDRiM8V/RmVG5SJaNVUwEuNDgnV9e1KEVEPKHaFLvQI8GstazvXF/WST4yPsykHMH+UUXr0NHGHmdyRYDgl+vaaE4br7kIvdg3y4xvR8hB/wVtpM5FfNuBnt9vjDCAUrAzf3B7dPrdni1HkZidGX/S7qMuDrf287UFhU7rDojS5VkBQKoh29WWTXZRO
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
- [Medium] mm/gup: unreachable and broken FOLL_WRITE batch check in
  gup_pages_not_requiring_unshare()
--

commit 69eb6845bb430fc095f06e523cf6406cda8b81b9
Author: Rik van Riel <riel@surriel.com>

mm/gup: unshare-check every page of a pte batch

This commit changes gup_pages_not_requiring_unshare() to only take the
early FOLL_WRITE shortcut when nr_pages =3D=3D 1, so that multi-page FOLL_W=
RITE
calls fall through to the per-page PageAnonExclusive() check.

> diff --git a/mm/gup.c b/mm/gup.c
> index ec0bc99202169..57ad488b4538d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -649,15 +649,25 @@ static unsigned long gup_pages_not_requiring_unshar=
e(
>  {
>  	unsigned int i;
> =20
> +	/* A short term reference does not need the pages to be exclusive. */
> +	if (!(flags & FOLL_PIN))
> +		return nr_pages;
> +
>  	/*
> -	 * FOLL_WRITE is implicitly handled correctly as the page table entry
> -	 * has to be writable -- and if it references (part of) an anonymous
> -	 * folio, that part is required to be marked exclusive.
> +	 * FOLL_WRITE for a single page is checked by the caller, which
> +	 * checked that the page table entry is writable, or FOLL_FORCE
> +	 * on an exclusive anonymous page; if it references (part of) an
> +	 * anonymous folio, that is exclusive.
>  	 */
> -	if ((flags & (FOLL_WRITE | FOLL_PIN)) !=3D FOLL_PIN)
> +	if ((flags & FOLL_WRITE) && nr_pages =3D=3D 1)
>  		return nr_pages;

[Severity: Medium]
Can gup_pages_not_requiring_unshare() ever be reached with FOLL_WRITE and
nr_pages > 1, and is it the right place to validate FOLL_WRITE | FOLL_FORCE
PTE batches?

There are only two callers in the tree: gup_must_unshare(), which passes
nr_pages =3D=3D 1, and gup_fast_pte_range(), which only calls
gup_pages_not_requiring_unshare() when !pte_write(pte) after
pte_access_permitted(pte, flags & FOLL_WRITE) has already rejected
read-only PTEs for FOLL_WRITE:

mm/gup.c:gup_fast_pte_range() {
	...
		if (!pte_access_permitted(pte, flags & FOLL_WRITE))
			goto out;
	...
		if (!pte_write(pte)) {
			nr_batch =3D gup_pages_not_requiring_unshare(NULL, flags, folio, page, n=
r_batch);
	...
}

If a future slow-GUP caller does pass FOLL_WRITE | FOLL_FORCE with
nr_pages > 1 on a read-only PTE batch, checking it here has three issues:

1. Returning !(flags & FOLL_PIN) first skips the per-page
   PageAnonExclusive() check for FOLL_GET | FOLL_WRITE | FOLL_FORCE (such
   as ptrace or /proc/pid/mem writes), allowing writes to non-exclusive
   tail pages without breaking COW, whereas can_follow_write_common()
   requires PageAnon(page) && PageAnonExclusive(page) for all FOLL_WRITE |
   FOLL_FORCE accesses on read-only PTEs.

2. When FOLL_PIN | FOLL_WRITE with nr_pages > 1 falls through into the
   !folio_test_anon(folio) branch below, that branch assumes a read-only
   pin and returns nr_pages whenever !(flags & FOLL_LONGTERM) or
   !vma_is_cow_mapping(vma), whereas can_follow_write_common() rejects
   non-anonymous pages on read-only PTEs.

3. gup_pages_not_requiring_unshare() drives FAULT_FLAG_UNSHARE (-EMLINK),
   which is only valid for read-only pins; triggering an unshare fault when
   FOLL_WRITE is set hits VM_WARN_ON_ONCE(fault_flags & FAULT_FLAG_WRITE)
   in faultin_page() and WARN_ON_ONCE(*flags & FAULT_FLAG_WRITE) (returning
   VM_FAULT_SIGSEGV) in sanitize_fault_flags(), whereas FOLL_WRITE |
   FOLL_FORCE on a non-exclusive page needs a regular FAULT_FLAG_WRITE
   fault via can_follow_write_pte().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119105701.3f57=
ac54@fangorn?part=3D1

