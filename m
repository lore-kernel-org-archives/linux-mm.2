Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B339A606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jU+yyG/X
Received: by kanga.kvack.org (Postfix)
	id BDDE86B05B1; Sat,  7 Nov 2026 12:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5EA6B05B4; Sat,  7 Nov 2026 12:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2C16B05B9; Sat,  7 Nov 2026 12:05:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 888EA6B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:05:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C7B5C037E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:05:49 +0000 (UTC)
X-FDA: 85408950018.27.EE98838
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6BB4C1C0008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:05:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jU+yyG/X";
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794071147;
	b=eWOyCRAjF9lZ2xfoxgGz79aZsVjYtstPgTVjlh2kEaf70tqx4mHykbVJTVCRS8bkybLMf0
	4NsKGWAUJA/IBVGc2tcYrwOt5qCrz4ifr90mMm2PWgeDXHfZYr5x5FxnZK4hL8y3DwENZ/
	gAu1+9CixC+qNBRWRXw/ywn23TGzrHw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jU+yyG/X";
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794071147;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJmGchz1AX0vrnO9zoYnlDu0hojN7QEExY5Nx/DdNy0=;
	b=IqzOz0GopY2cBUqcbgt+ZvfbJPQz9NNpr3IxnuMMKSksDX9rfKMz8XP+77NoZxeSionv8D
	YuFWxlZ97Aaj5FrN6sZDJkd80CmeyXPjX+KRLxKvu9Jup4IXE4r4ItbG5vFeJsTI3YOYYY
	qCfDglFFRo4EEw2ibZUFZMPWbXJ7ix8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0B936020A;
	Sat,  7 Nov 2026 17:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEFD1F0089F;
	Sat,  7 Nov 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794071146;
	bh=iJmGchz1AX0vrnO9zoYnlDu0hojN7QEExY5Nx/DdNy0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jU+yyG/X1Uzp0VTQ2A3quFIHuu14tHMl3Pf0hihLFfwdzxrcfX9N9xa9d22lSOVxY
	 /fg5qR9/SPU++x0HAyXzUsN6Ui/H4L7tvWRm+FgCrde3mxfgxlW6ybd66MBb+iD98T
	 dH4pHXyLdOLFUYu4jYqOC1+HvGo8I0SRAw0xr+iETVRjHsQzRnyjOu7A+jv5LhNjnG
	 J0+Uqs1YHFD+N/34Ku5G8C6uVefMmaRod/JgO8+pt97UvInc3B1iq0M04cf9M/460T
	 U/WiWlPPO/MlB+oj7eDZhimuapdqqXD/Wup2hhNNolmBKod8NnKYwlsboprhpogy8w
	 mukvWZnbIVV+A==
Message-ID: <sashiko-outbox-203086@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Khorenko" <khorenko@virtuozzo.com>, "David Hildenbrand" <david@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Alistair Popple" <apopple@nvidia.com>, "Dan
 Williams" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
References: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 17:05:45 +0000
X-Stat-Signature: ck9o7tfum6b5nr5yzxrwjc4ufpuk3ku4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BB4C1C0008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794071147-205848
X-HE-Meta: U2FsdGVkX1+wdlf0Axuuc8nj0aYfbpefVmGvatu/Nn4ID09ElDE02R5yI0L9N28vf8kpQ2I1wqpPplOdUB85OxabaBfnprBb3O9VWeDKdlj5v+eYB6Vg3qbvD15UvRU/UFqU8Zc+9ZNb0M3tbjSDgJtQEcsvU/tDPD3fg/yLLmr/6PSKlCYgycAguienv6HK696VKTqFawHosKkUTFK0iB6KN/4YFiY+a/hxFu68/MaNN98K2KtsuqfEfGguitkU81lznrZ5NbuV1XfH1dY2OdEX/Ylk6YGQIvrQN2pLHBMkabHxBNiDj1LFBDKNDVM2D85Kd7nIT0ZNnz1R2vFQ2KYXwhquA3vg0tr0hQfjbXM6MTetjsVkoncfvioNr176mznS/JLQEkx7JEoBbNRyE/CYM17KtllJHR4FtyVhtXEnBXj7mWzPHeeTFbz9HeleiX3CQRQXsN+f78ZyfD0c0VUXGnHVBaB7z4UoRXss+r5fvFiVqOUxiqJ1uSTkA86iEKRVU8D9/qYbocCfWYe+Eja0B2QxrkOdUUNALELYLrEXBed9c62ezRz2jRk7U7G+ZnZ1eTPvpiinmsEDhW7prRqGtSkr5ZTCULcllRjUcfv6R8KdcxW9ZIZIDKYSd5lCrush8YEb3HnveKmOAvZ7NCNMPd7j8ggiDeYlPIWLxWD+C/ZkBQCLRXeDAH1YMrB3I01I1ZzALOqXGyP3SPB0KBUo4WDW9G+CC/bNa64SNgmk85Wvd8hFcFnXsU4YV2W2KEIR96B2eRcy6RO91Zr4F5a8n/egG7a9IGmXn1MCI1elq9PRQUa52a5JBtZ+jKpaBp028KHepuJlaKl3NrmZKV8c85j8IWRuaREoyZ6XBR5adZ/t5Ph9vvwCyGKx4wVeeOFuOHJuuJ+EBoxYAJfxBdBLlYuJJBHXtkUicZMORJPlavSNzLJmH53RyMh34vMrbPOXqzW3nF4KVZTgSHX
 yVV9qzwG
 Tx/LnskqtAcHNNC9R4xx07UhZFqkToxNZ+xDwGoWt0TOlnb9VpPm5f4JyIknXRZCaNZwrD9iDu1AsRL7f9sHRceFY5S0x43bIkG4AYE6q3+Q17CnwkDjwy1h3os7LEynt5g7/afHD+iNXNbuu5CqPZAlnVnQlrBYIfFcVf3/EdacGrWmgNgsVYSeZpqj0kWJkZT0QHepn1SunpwdalMai8eH6TNUIaZIqwo1bgPJresWpgVlMpgGeJAuwxX7Ufe9NYG6622vid8cgAEK9Cj8Fe22OyHKwGs7ivLtm7LBW2q4UO5Bct5vZmgsWL3CGCzJtPAZnrREeFB+TkuVdY/wd4a7McJ8diDBM3zepgxoYcwzMdBkOJDb0tRwfnB6Me7oHLEGaOfUuHVTqq4FIQUkaSNsteii9YuBWfWRe7ME1AmnmQ0TdpHgR9tQLwfzVda3FTnLtMcuEK9hNLv75rp/0dSNykUX8j8kHs6tN7TZ9C7gcv3OA5EDuFToRZgfyD8HRE1sGVd/9yQxQNS6idf0gq+B7/zCfdS4qCoRzvPD0p4eCXG2Vbu3cmVTU+EKIwjSd0XyBYGpeot36zsahblSgxv3KKf9cDVLr6leUdPJA8Qfu6JrVGNkYIhs8mbG2RVNesDi1oOpHZZBxJRxp1qNnJLv0oTwo0+eceTxv
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
- [Medium] mm: hardware A/D bits discarded for PUD folios in
  zap_huge_pud() [1]
--

commit a6bb79712598f2da7fdcc94c9b1b5f8b9aad8851
Author: Konstantin Khorenko <khorenko@virtuozzo.com>

mm/huge_memory: use folio_dup_file_rmap_pud() in copy_huge_pud()

This commit adds folio_dup_file_rmap_pud() to duplicate file rmap mapcounts
at the PUD level and uses it in copy_huge_pud() instead of
folio_add_file_rmap_pud().

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d0e19d9e6b651..13caf81cb51af 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2100,7 +2100,7 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, s=
truct vm_area_struct *src_vma
>  		 * TODO: once we support anonymous pages, use
>  		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
>  		 */
> -		folio_add_file_rmap_pud(folio, page, dst_vma);
> +		folio_dup_file_rmap_pud(folio, page, dst_vma);
>  		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
>  	}

[Severity: Medium]
This problem wasn't introduced by this patch, but does zap_huge_pud()
discard hardware accessed and dirty bits on the PUD folio [1]?

mm/huge_memory.c:zap_huge_pud() {
	...
	orig_pud =3D pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
	...
	} else {
		...
		page =3D pud_page(orig_pud);
		folio =3D page_folio(page);
		folio_remove_rmap_pud(folio, page, vma);
		add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
	...
}

Unlike zap_huge_pmd(), which checks the cleared entry and calls
folio_mark_accessed() and folio_mark_dirty(), zap_huge_pud() removes the
PUD rmap without propagating the young and dirty bits from orig_pud to the
folio.  When unmapping a refcounted Device DAX PUD mapping, those hardware
A/D bits are lost, leaving the folio with stale access and dirty state.

[1] https://sashiko.dev/#/bug/linux-d2fca843-ce3d-48bf-9ef3-bf87872ea6ec

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-khorenko-v=
stor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com?part=3D1

