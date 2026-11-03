Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CA7606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kg4jc1+Z
Received: by kanga.kvack.org (Postfix)
	id 2E4346B05E9; Tue,  3 Nov 2026 03:13:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDAD6B05EA; Tue,  3 Nov 2026 03:13:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA166B05EB; Tue,  3 Nov 2026 03:13:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB9A66B05E9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:13:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66E0180340
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:13:51 +0000 (UTC)
X-FDA: 85393094262.28.E04FE8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D1380180004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:13:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kg4jc1+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693628;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bT3xxJ3C8hS5tPSHY4eaeuDcPDJiPh2ymq7gkl1q/OU=;
	b=Nnny975R0qWi1X2Fl3W0B/Utejdvl7tpAZTZTlA49hGb+91ekBIxvbWMMXHIQyBa9VCa/q
	3Jp2voV06Q2mGRVhQCpkKKDXpEfpFVvU7IEusgm/GxiLqVYClpUtXg23cMiA/PenskJYvT
	ohnN1btrGPUiYmEAsbY0jYYtHVnl7tw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693628;
	b=tQAK7/oQ9LHcsNHkBZDogpAtPHua6WqbAIH7o1e6lpZ/RtSE2VAOvL8q32KPYW1QwifjQm
	Pnmveajsk+NjllYnXrNI29cAULrUmPv5NqVjsxcWvxgNHAg+9WtZQJLohJuThyGeU9LnLs
	5++4giVIOKLOnGBJznqrjfXBQDoBxrU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kg4jc1+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5681D601EF;
	Tue,  3 Nov 2026 08:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A2F1F0093A;
	Tue,  3 Nov 2026 08:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693628;
	bh=bT3xxJ3C8hS5tPSHY4eaeuDcPDJiPh2ymq7gkl1q/OU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kg4jc1+ZAEAGkStGxhi1E8joz4GlyQSVmAl18OMWWQrKKRtGap9Go4kv5X482bzjJ
	 3DNLfuYTW+d9oiNqUAaWUTS6pXtGLVtSSvBw99v95kCNrBe1QE76BFzXYyaRpWnObq
	 6X/1LU5aAzl6wuCgtbKya9lrYrRoH7em6W1YBpl8DOdMfPwpYdZLJ//FOsDm3uWPjn
	 s1jbHm50SN/QuJFFK6XSgco4b3/iaF0NnhS6+kCvK4JiKc7PIx6QQHVXVAFKI7bBbS
	 F6Q5CSQuUEqKE+3rPfh1P3fFHIOztANF7VrQ0OxnPu8OXwcGJwlMjxj2Y2bIjCE5NB
	 OtCSEVXqACneg==
Message-ID: <sashiko-outbox-194806@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix validation of unsupported HugeTLB
 orders
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Oscar
 Salvador" <osalvador@suse.de>
Cc: "Muchun Song" <muchun.song@linux.dev>, "David Hildenbrand" <david@kernel.org>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Huacai
 Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>, linux-mm@kvack.org
In-Reply-To: <20261103023831.1805473-1-songmuchun@bytedance.com>
References: <20261103023831.1805473-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:13:47 +0000
X-Stat-Signature: yqj9tijph66w7sw6zyq74jici9j6s637
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D1380180004
X-HE-Tag: 1793693628-92335
X-HE-Meta: U2FsdGVkX19Zy8ybUMXV3MblyZDrKTjPgRiKDl6oCOALaQLx8/37hc67m3lWoQT3ZWhOGI3b98x3QghvNbp/9dkAH/PCfiFEJ9xDOTrpqqYqC0E726niNMKllVegqg3p6QxRjmwdcbg7Q8OSRxI+wGd4aQH9eopGKn7CZfHFfM0abUkOFpkCJoMGMSXkf/9XINSBh1yVMQGO8Dpc41euZgXhytUUCcPJN6qN44YfFqELIlXCdsJC4jB0zVuC0sn3dJXN+JmtY9oi70O+9fZcZycYQjA9pqovlAcJPeu+unl57rsD//8DyT231R1+nTYjpVSlk/G/e5MICXQ7jzmHdaSjEgxEiUNvdQtsVoN/IXwHBUKrJWyObry3PTcO8SDcWpjCDJSlK2YRvGwH1lp827J74N1red1YRE8Ia040rzzKCpgkiHJPnNOqnDjrJ+cmletehgMJdy+JH6dA2QlfdREY+22FwQBeUA6UZLPdXlDuVgLiCNYVPKCTslgpy+94xQnguEXJXU+pEsvCOu6OOx6DUxcnFtKzJQG4lJs+qcxunQMNvrXokpRkhSnR8+xpuopKwfo0dzyWpQY8pr57ysLkx9KJFPtLP2W2O8iry5AJOihntYYKyVnVKObsGne4HZfZKo+I8+q0iuJlmXOhkcVs1ayCx2PitcY+pOf8BJcf1jodpYA97Y8oDgWfbEDsDMXJcabRzZnfiVmuxYQmzizutEiZWBeENpa/hphEOKXvg4HuYTlVebTBlGAm+GuayxQFXus+y9j9v7iw4dNZ6Wmsf6JZITnzRVf/r9TJLxRHyzYPH2Rawe0A4FlF7SvACUWyZRVJ8xU+qGktTaJgBYRDbAyi0XRHHlxQbTtA3PFmngrXV8ZZBVUdG7ZmjC+yN2KV7smko1qDfgvJDOR9wqn1g6qcsJ9uH5HVE3uPYCiVXRl2nE7gCPWxcmMN3ucXYXmWfvj1+QT0XLMHn+5
 eMR42lBd
 czFWkYZajHPmPQabY3Iz+9c227INj+MOzo1b4JW/MliA3vhFHrPA01GhKNzSuoiW98Wjyw7jVSwUXSxvQ17CblOJ9+WgOXOefH+Kq4mG9TOqvrh/9iKdBgeTqXhTmwbIFyLHO0wKCSPH1XBGiDhswA9UfpoMpDlEnT8IjMN4sY+9kd8yYU732TnAhV2VBJZwWkzf2E+uOKabI3QOsFkmOnS8p4mpRxPPrpkdlfrF/I8X12Cl5z/xw69tTXU6/nB+oHmjzcxo/tCrvd9DD0rVaxeKqGNgKx5EQ4u/LmhaAS8sJLPTrXmYvTKtHu4i/LYfkvz6VDcqog4MSdr93ywc9KAPhSkWjkFqqc/eCH7fhRYEHGzSER0Cyd58jHYep1cTHdn+wc/YJrdPA0hOMBI7Wtm+4aVVbXtPV9CCRENbtrzOK+Df0rwo4aRD8ifyf725zjmOOzXU/EnJLvqqinYFKUSFJpqVvHQMEFdhL2IRzdVgq+abraF35QaekV4pOZZvJK2F3xWl2ZTalyIvnQaj6DSCHVM0oLzKWRq6wctZIO86dbFJyYpI7F6lFWF2SKLIXSC8F6JL6LvXRgr/3nCAKUzP4SA==
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
- [High] mm/hugetlb: boot BUG_ON() in hugetlb_init() when HPAGE_SHIFT is 0 =
on powerpc
--

commit 83959b12982c256d20ca0de51021b3beae201569
Author: Muchun Song <muchun.song@linux.dev>

mm/hugetlb: fix validation of unsupported HugeTLB orders

This commit replaces BUILD_BUG_ON_INVALID() with MAYBE_BUILD_BUG_ON() in
hugetlb_init() so that configurations where HUGETLB_PAGE_ORDER exceeds
MAX_FOLIO_ORDER are rejected at build time when constant or via BUG_ON() at
runtime otherwise.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ff9dbfbc7a961..e21ac667694bd 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4181,7 +4181,7 @@ static int __init hugetlb_init(void)
> =20
>  	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>  			__NR_HPAGEFLAGS);
> -	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
> +	MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);

[Severity: High]
Will placing MAYBE_BUILD_BUG_ON() before the hugepages_supported() check in
hugetlb_init() trigger a boot BUG_ON() on architectures like PowerPC
Book3S-64 when huge pages are unsupported at runtime?

On CONFIG_PPC_BOOK3S_64, arch/powerpc/include/asm/page.h defines HPAGE_SHIFT
as a runtime unsigned int variable:

    extern unsigned int hpage_shift;
    #define HPAGE_SHIFT hpage_shift
    ...
    #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)

Because hpage_shift is not a compile-time constant, MAYBE_BUILD_BUG_ON()
expands to a runtime BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER).

When huge pages are not supported by the platform or are disabled at boot
(for example, when hugetlbpage_init_defaultsize() in
arch/powerpc/mm/book3s64/hugetlbpage.c finds no supported huge page sizes),
hpage_shift remains 0, which hugepages_supported() checks:

    static inline bool hugepages_supported(void)
    {
            if (hugetlb_disabled)
                    return false;

            return HPAGE_SHIFT !=3D 0;
    }

Evaluating HUGETLB_PAGE_ORDER before checking hugepages_supported() computes
(0U - PAGE_SHIFT) in unsigned int arithmetic, wrapping around to a large
unsigned value that exceeds MAX_FOLIO_ORDER and hits BUG_ON().

Should MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER) be moved
after the if (!hugepages_supported()) block in hugetlb_init(), similar to h=
ow
hugepage_init() in mm/huge_memory.c checks has_transparent_hugepage() before
evaluating MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER > MAX_PAGE_ORDER)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103023831.1805=
473-1-songmuchun@bytedance.com?part=3D1

