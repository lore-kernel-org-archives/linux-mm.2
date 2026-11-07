Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5CA5606A331
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=I3yQwc+n
Received: by kanga.kvack.org (Postfix)
	id C80BC6B05B0; Sat,  7 Nov 2026 02:02:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0CA06B05B1; Sat,  7 Nov 2026 02:02:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD32C6B05B2; Sat,  7 Nov 2026 02:02:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 839BD6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:02:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4D46C02A6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:02:17 +0000 (UTC)
X-FDA: 85407429114.07.927C99C
Received: from mta0.migadu.com (out-211.mta0.migadu.com [91.218.175.211])
	by imf14.hostedemail.com (Postfix) with ESMTP id D69FF100002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:02:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3yQwc+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794034936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNyW7L7svCZC+4vm04JJa3Y3COX/LWxh617gbF6SI0E=;
	b=X6cIAD1AIR91tvcuGbPGyjmft0iGQpCZx5PtDyPCZVqfG6wJMnhfCZcd0GxO3oM2TFSvCk
	MWpUb4EojBfWC1LwNnUCiOUmGlWEScmpIP71qFFxtY/CPOOJ9+346SZG4GDK6bKYP9dIpS
	fGBZ+6WSjDQtZ/q8ai48HLC8Xg7a2YU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3yQwc+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.211 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794034936;
	b=oZhsTjNaepMAZEcPkknYN5+3rYsLY13wW4gT4YArBk1cDNH8As6F56/GdGF/cwUaCHz+Sh
	OZYy3fr5MSPLrHgdDg7glzPcRLQRVoePdYe8EtkQ4DAL+KarzRn6biA4CWSO88ICOYz6zF
	jkoNHUpfDnSr4nLdauwQTslha6UIGcc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1eU8LB4FiA31cEPkSs3z/GNpYbcTIlce7/3o/u8t5mo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794034934; v=1; x=1794639734;
 b=I3yQwc+nnr9dZ9rJHoIeeQfQUjIaGc2f/SLqKrFxDV2I480KdIkDlwFLnBpoNmKhbVN3fUXJ
 61MUGbXwbuS+9RE94YjhsGLI1nsOE0EUWlJkqkywRE5Q624MjkvGo6fGlaAjtrHSpshsbklTY2m
 LIEKSxp9znNWy0ITPbV6NfYw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 89d1383c0cbcfc28;
	Sat, 07 Nov 2026 07:02:14 +0000
X-Mizu-Trace-ID: 89d1383c0cbcfc28
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 07/20] hugetlb_vmemmap: Disable HVO sysctl if arch
 doesn't support HVO
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003002123.505555-8-jthoughton@google.com>
Date: Sat, 7 Nov 2026 15:01:47 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2122761A-45AD-4AEC-AE88-B51E92E2CA40@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-8-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D69FF100002
X-Stat-Signature: 7mm7w8m1msjsi7r79gajy7mpeauoe4ze
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794034935-767112
X-HE-Meta: U2FsdGVkX1/ikUryvrdKM73rfCZ2/zYivenZDCHNikhJD63rZn3HnyUgY+K2ipK5vj4123Z2c9bXwryQXiJYAXYcU88Z1FOJGO3NR0xuFVcCwb4BWtpfg5FBxy4qGBw1nDFvCtKYxq77P5S9wLUvpFIUfWtnbQidcP31CIJrZR7z0ZWd6pcaAQCab9cSNslt4qTiYltOUEx3v3IBXd/7LAIhws6jiVRrKryuwBYEsFWbK2XJn5IMjjZSkrlD0O/2TEwXZ8jnwnYk+b1KMw9exbLKAbSuwTglkIXYyOjJ0ITICQwcSAWyriAoqn5gL9yWxHtulgeyxyRj0JMdqkp/xhyYfgJMZmg8vkdPKXUBsQIJYAEyyjQGwUyq9Hu8unxfxmUYuXlnXSvUXg+2iY27MFeaJP7Udh2JkHHUBODy7W1NF7COsN4BLmDY08peE77j/mdIjsMnI5zAomay4fCeAsOp5MfJXWgHCShhW/OujgpRbtagl7Zp6su/VxFWQJ6fj7dTlvmylPgvnt68+ikhbMPgLqLB13XcE3NPIuoK85kUh9KmSfVzPwrV0hBxNCzIXRAMt/MLQaGlNf7dkgfFCwoAoDN99EKYpec/DgPBKnfVIdNt8jgboacjEniRaEkGCUreyu0Qn1nyn+MDcKLVHI56FavG0OFrC7a8AXOdGCDIzbjASz2RNyte3eZZ+57zEvl1jvlpZiojrqPuDelOiNBYADNeytcLmzcy83YkdDwK1E1LJ3Rtkm7ncW/LM7uAROZ6mtHsJ+Z9pzjZf734bf6iZpkY74gvKQG4cLrHKjp7kd2T9vz9+cW90oDLZSPa/ZQFqNbiTswesr74r6QtaUeYUniKEf7dXCI/ESGUKjha4s3leieRummcTZDE5qqP3er9OUauXZGpItFUimmJtt0iqKxT/Vhiit0/iZ56v8/HWWnXqQjNuT3DjtYVv1LwvjpfenlRGWk0fHFORBJ
 CmMhzdKH
 iMmMinxyLbjb8pQm5CWBnQ//tHUBSsL446okBvJkCXpptBkRlH45M+1AOEBSPzdQ+Jv1i8cT9nNbX6034QYrbKFAxJh5+hb8z3Vom5QwFPuSgE1akVeVzqoZuvySy1ZZPMQW9omZDSDeqk/p9DCVyQEsvAAdHx5ohPfky9DOZ7nLVVwq5UwstLn1sEodBq7QHBaDgVtjLCxH/g1NcPwwi0clfqyxPNZbFJ5m7iKFwEw87Y6UQI5pe11Opa+PxbbwRvuJcBjjtNJrT17npVH7UkrXAANxWRE/IOVA2/CtNWmbOOuMqOr6Bgn944slx9r/GtRCvMuxp2eoxzno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>=20
> Do not create the vm.hugetlb_optimize_vmemmap sysctl when the
> architecture lacks support. This serves only to avoid confusion for
> users.
>=20
> arm64 support for HVO is conditional on certain hardware features =
being
> enabled for all online CPUs. By the time hugetlb_vmemmap_init() runs,
> all secondary CPUs will have started, and the system feature set will
> have stabilized, including HVO-through-BBM, which
> arch_hugetlb_vmemmap_optimization_supported() checks for.
>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> mm/hugetlb_vmemmap.c | 15 +++++++++++++++
> 1 file changed, 15 insertions(+)
>=20
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 8596a462fee6..817ce39d4cf3 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -763,6 +763,21 @@ static int __init hugetlb_vmemmap_init(void)
> 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct =
pages */
> 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
>=20
> +	/*
> +	 * Architectures that need to probe CPU support for HVO have =
done
> +	 * such probing now. =
arch_hugetlb_vmemmap_optimization_supported()
> +	 * will return the correct value.
> +	 */
> +	if (!arch_hugetlb_vmemmap_optimization_supported()) {

I'm wondering if we could put this architectural check into =
hugetlb_vmemmap_optimizable(),


> +		if (vmemmap_optimize_enabled)
> +			pr_info("vmemmap optimization not supported by =
hardware\n");

then, we do not need those code. If the current kernel does not support =
HVO,
then the sysctl does not exist. It's already a common case when the size =
of
struct page is not power of two. If users really want to know whether =
HVO
is enabled, they can check via this sysctl file. Therefore, we don't =
need to
print a log line.

Thanks,
Muchun

> +		/*
> +		 * Return early to avoid setting up the hugetlb vmemmap
> +		 * sysctls; HVO is not usable.
> +		 */
> +		return 0;
> +	}
> +
> 	for_each_hstate(h) {
> 		if (hugetlb_vmemmap_optimizable(h)) {
> 			register_sysctl_init("vm", =
hugetlb_vmemmap_sysctls);
> --=20
> 2.56.0.rc1.315.gc6ed9934b7-goog
>=20


