Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE92C606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 17:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wu9dP0ze
Received: by kanga.kvack.org (Postfix)
	id 8B45E6B00EF; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8632E6B05B2; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBEE6B00EF; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D93A6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:23:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9613C0A0A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:23:58 +0000 (UTC)
X-FDA: 85383594156.24.623F19D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 021D11C0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:23:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wu9dP0ze;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793467437;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HiabTMz/1RAldfc34SMunp+HSIChlfqjeTxEtO8dyq4=;
	b=K8sPLRB0aBdOqSR7ktevZWx0dX9wax5RWqhJy05OfA2XIbSnN4TldvXrT+BeLC/8qV3Arl
	Qu3PnDd7tG+eywgUyIjGjhoOiQIVVLpiFROHSoAYbfMaMoCQfjPUaNbdok601MZrPmWZcL
	87fS1/4DnPGQo//MXLyHal729ev8Gfo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wu9dP0ze;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793467437;
	b=dq5V3b8Esjk+H3D1zuSFbFdHwnUlUi+PVmxGfxIPblCgvQ5tW4MEA3hW3Juq8UEljsC8SG
	4/ZatqdVHo8ujFN8PTPsIEPfIIy+OB9WUJKdIF0umdJB7FRWbulOTwQXtF8aXCCgQd5o2O
	bU/95Z4OmbogGgTRljWu0jP5vfztS0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B1834163F;
	Sat, 31 Oct 2026 17:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF41D1F000C1;
	Sat, 31 Oct 2026 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793467435;
	bh=HiabTMz/1RAldfc34SMunp+HSIChlfqjeTxEtO8dyq4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wu9dP0zeyi++5BnJyNxUwS/ZZwxW/vZ+Rq3rQlljrDOZbQpcpYTBPhmwFWVq++luZ
	 Q1aC1GIEiKeI+T57fNzCTgvxq0E/m4f2s2UUEOZpoPTNz6l2V8rhdJ8Is9CRhQpBNI
	 Qhqg6E5e8bcajwTgonI76Su8YHUF+GJVZmitkjR5Q8j+JdPN5gCj28u8ByOwPNDEjY
	 y0Fwwy8Jegb7+EedGl4rqiZm0WmUCyek26yNgEPMd6sRxO+bDbFjx++DzvCUJo3xWe
	 RUZgsGNnV7NEXHMjmmBnS5a4MGQxiz4d7T+0iRYmDpViwP8rbp/bWcW50lIlx/2EJ9
	 D9XOUfnYCLwTw==
Message-ID: <sashiko-outbox-192063@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH stable 5.15] mm: move 'mmap_min_addr' logic from callers
 into vm_unmapped_area()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Florian Fainelli" <florian.fainelli@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com, "Linus Torvalds" <torvalds@linux-foundation.org>, "Liam
 R . Howlett" <Liam.Howlett@oracle.com>, "Russell King" <linux@armlinux.org.uk>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Sasha Levin" <sashal@kernel.org>
In-Reply-To: <20261030172216.368052-3-florian.fainelli@broadcom.com>
References: <20261030172216.368052-1-florian.fainelli@broadcom.com>
 <20261030172216.368052-3-florian.fainelli@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 17:23:54 +0000
X-Rspamd-Queue-Id: 021D11C0002
X-Stat-Signature: qbpwjw5yny7bmtf6bmmibf9zqsfr43ty
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793467436-325066
X-HE-Meta: U2FsdGVkX19i26TiM23pE7WENh53PEtN7YLOyN9H5a4Xi0W9HKWdOS4Tpf/V18g7FTOTQ1zroDYNnrRvMSZGmYWsofS/fc1w7tesYEL8bGHLh5ovme8u19cv4mz4cPE6JTTUpcFpzuNuO2woeMPCuzXsAaJJiInwz8ESwnLWJBBzNZs3aJeb8jKt0a6gnpwRSdkxNXXzzU1KWiv0Sn4Md/Hk2d78oZ9JmK4cIP1HKTxClk/y5bYCkgQ37BYe9HIOe6i6oXOAYOm9ji4qFwKMa0aX8PMujwryoglSS/lFMc5b54K+I0BGUDo09Etfn7WaviMrxta+ZwS3/HqoRJ86HNSFqfsRSrQ98upm/ta2nuvdkSKbtCTXV3k5Wra9t07nZcXucYqrNXoPygfmC63YRip676GzTBlZHC0tSBKAXGZnBePf3KJ0jUXqp50BTdbDov0yxhJ+kfG9aqvgdSrCph73Y9E/+KkI9dtORE/17L/Gtbk4Ve4RHa02rQpFp9LSp7C4OA3eg0rx4Rv2D87R2aCGsFr0ow2M39F4xh1HzB86v3kjB7UMXF7lW20LUnWrCI9mJZQC3BRuYg4mOrt5H67m3BI3VmyLd52maerfExktEqvN+AoPzQHNGOjqc5gxf7+WCM/EXcYcpbFJXKgITHBotHHt/CqJizI0CcsI7zLPoYEJ+XoyQDJf141KEFjPlqYAVRmxBhxD7IWn4GE5qWUlf9t4W1z0FIht8aMxVoqKXKQYdJ0gznum0elkM3ceZgF7TO54hr6+4O8KHIrnXvkUvmjghX0nhknTjAZHKoTVbwpEcjNJ3rIjk72fXJFZ35w3tOpzmvnz67Hmq2y1+BkLgzsi3jf7CY1iOiMNxrgvPxEOpRwfX1f39H8GoRVSU9pm3kWnLpGQNkDMNcjW57aHqu0Ax6sP5UA+qYBGDQRSxg/NrS8w5G9+GONHvAoWD6c3xnyiPUgYdPc4/ff
 BRy8DRDK
 gQ/nK0uEOm+8+W9gYZOQmnESqvG6jQP65N+JjBNPbU83bcAsu6emIjpPESUnMZURLmfujITdx7cYdm4sPkSqePuDDcpJCNAfneu24Xik3U6Gdt1ZuhU8zCKzqwUm15jKfKjX+Ga7F6MBOGmA87aULDIlwo0de5YTyeFKETWXmdQ7j78EAu66JPnQxkimtZB7e9RXG1msUaaRDXjYQaqB7BLvAiF9WXuCF1YAeNLez3Dda7xWz3Yrj/vjTi5rl1H55x/E16R21nfXCBurp0X3JSJd+0nKFBthAXQTPCxsljs+uVWqOYNbEvRk/uj3j2CgvQOIMYyHpiFT/mmBhystToabIc/gXCFZWflsC7rYk9RSloeniFAy+yXWtnsUmp0Zqjlutej5ayo4Jh91CrYGpYmgREVJKjXMn7H2vU7oA5ps7ySRPVdRoaECTNSGT96Sr+9blrrZZSOTMycRQgohlyUqXN5b4Sbt6r6L7M5k+/TFNDpLaEGRexqEkU/p1H2QZEH+vTEC6z8o7ccvOU3ijkYx9JO1uynVCBA9pfuycQGNXkeH77yjAFOpzyDQ2/v8lcwoB1v/9AJ1cGyEKJMSgXIDehY06NdjeJ3HI1cRCOlBfeE1/IW8QBBKsAcOBk/ITjhyGE/Pp22MiXev5JD3MIazX+w9anDge3uyDoAaz7zECy6neJtdT3JDsUA5zFRfH7nt5oagc4Hkb+Ncucua4xaLibZosT4ZwkuBJIbStgWHkMd/5ie4rNW9Y9TrcMknH+4NUKXCT20y4eI8TTD4E/gIZMaD3ZD3WqPkLS4HTiJLQheCK5cGliofKnA==
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
- [Medium] mm: unaligned return from unmapped_area() when mmap_min_addr is =
unaligned
--

commit 357809efe869317caba6039aa012c441fb76a0c6
Author: Linus Torvalds <torvalds@linux-foundation.org>

mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()

This commit moves the mmap_min_addr lower-bound clamping out of individual
callers and into unmapped_area() and unmapped_area_topdown() so that
vm_unmapped_area() never returns an address below mmap_min_addr.

Link: https://lkml.kernel.org/r/20230418214009.1142926-1-Liam.Howlett@oracl=
e.com

[ ... ]

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 53fa4f5167dd0..2c22f4bee04ee 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1917,6 +1917,7 @@ static unsigned long unmapped_area(struct vm_unmapp=
ed_area_info *info)
>  	struct mm_struct *mm =3D current->mm;
>  	struct vm_area_struct *vma;
>  	unsigned long length, low_limit, high_limit, gap_start, gap_end;
> +	unsigned long min_addr =3D max(info->low_limit, mmap_min_addr);
> =20
>  	/* Adjust search length to account for worst case alignment overhead */
>  	length =3D info->length + info->align_mask;
> @@ -1928,9 +1929,9 @@ static unsigned long unmapped_area(struct vm_unmapp=
ed_area_info *info)
>  		return -ENOMEM;
>  	high_limit =3D info->high_limit - length;
> =20
> -	if (info->low_limit > high_limit)
> +	if (min_addr > high_limit)
>  		return -ENOMEM;
> -	low_limit =3D info->low_limit + length;
> +	low_limit =3D min_addr + length;
> =20
>  	/* Check if rbtree root looks promising */
>  	if (RB_EMPTY_ROOT(&mm->mm_rb))
> @@ -1996,8 +1997,8 @@ static unsigned long unmapped_area(struct vm_unmapp=
ed_area_info *info)
> =20
>  found:
>  	/* We found a suitable gap. Clip it with the original low_limit. */
> -	if (gap_start < info->low_limit)
> -		gap_start =3D info->low_limit;
> +	if (gap_start < min_addr)
> +		gap_start =3D min_addr;
> =20
>  	/* Adjust gap address to the desired alignment */
>  	gap_start +=3D (info->align_offset - gap_start) & info->align_mask;

[Severity: Medium]
Can unmapped_area() return a non-page-aligned address here when mmap_min_ad=
dr
is not page-aligned?

In security/min_addr.c, mmap_min_addr_handler() updates mmap_min_addr via
proc_doulongvec_minmax() without enforcing page alignment, which is why
round_hint_to_min() in mm/mmap.c explicitly uses PAGE_ALIGN(mmap_min_addr):

mm/mmap.c:round_hint_to_min() {
	if (((void *)hint !=3D NULL) &&
	    (hint < mmap_min_addr))
		return PAGE_ALIGN(mmap_min_addr);
	return hint;
}

In the upstream commit 6b008640db73 ("mm: move 'mmap_min_addr' logic from
callers into vm_unmapped_area()"), vm_unmapped_area() also aligned
mmap_min_addr to a page boundary:

	info->low_limit =3D max(info->low_limit, PAGE_ALIGN(mmap_min_addr));

Here in unmapped_area(), min_addr is computed using the raw mmap_min_addr. =
If
mmap_min_addr is set to a non-page-aligned value above info->low_limit and a
bottom-up search finds a gap with gap_start < min_addr, gap_start is clipped
to the unaligned min_addr. Because info->align_mask has its low page-offset
bits cleared (or is 0), adjusting gap_start with info->align_mask leaves the
non-zero sub-page bits intact (and can also borrow from bit PAGE_SHIFT when
computing higher-order alignment).

Callers of vm_unmapped_area() then see offset_in_page(addr) or
(addr & ~PAGE_MASK) as non-zero and treat the returned address as an error,
causing get_unmapped_area() to fail with -EINVAL or callers checking
VM_BUG_ON(addr !=3D -ENOMEM) to trigger.

Should unmapped_area() and unmapped_area_topdown() use
PAGE_ALIGN(mmap_min_addr) when computing min_addr?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030172216.3680=
52-3-florian.fainelli@broadcom.com?part=3D1

