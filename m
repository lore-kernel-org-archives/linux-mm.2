Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFE0606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 09:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LAHQOhdr
Received: by kanga.kvack.org (Postfix)
	id 673026B0208; Wed, 21 Oct 2026 05:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AFF6B020A; Wed, 21 Oct 2026 05:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5607C6B020B; Wed, 21 Oct 2026 05:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2C06B0208
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:54:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79CA01204C6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:54:25 +0000 (UTC)
X-FDA: 85346173290.26.BABA587
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5537040003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:54:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LAHQOhdr;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792576463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ph5jOO1GJkWHfez0YQCFb1ckQjLY8JeVKtFL0PrDBnU=;
	b=iO6olZv8aWlsXXF3JFkE0b+632VfHQm7X1SHuLrzfertihllY/vmvOf/WghpiNgtd88YDR
	WGsvW7WqPgK431pX+4qOXWGczOePZEBQQzX+tR3ZDhJnik6cPtSiCCHkAziN/pDdk4FYVc
	uMbUl2dz/M1bSxW6AqrTsYtdK2UeyB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792576463;
	b=Eyn6wnw4DorHezEAWsPYtsd+b98x6CWU2yrpGeaycx3xS9sFo1b83tl4MMXjP1a5W1+j4y
	Mq/MSGYfEMjioh1aB+ekXnDIjG+GKQO72VoUwE/EPWTSemzByF2JZb1UepYHzpiou50bwB
	d+Gw3bqrWLO5XAiQhupGfNF7vMt/f/E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LAHQOhdr;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mtNnOi1A0NVeWv71nH2FKskD2CAi32/TwrkTagWD074=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792576462; v=1; x=1793181262;
 b=LAHQOhdrACH2uKpTmTwpy2nnJvEuOsPIWIWFykGDycUbPghtcFhl1t35CijPXf67YUiojPN/
 VOQ9emlN5v9k6BxruqAvX8yUBYPZvPuCJ86irQQ2s5NY9LPw9Q8B1ZZUYBmynq48VmEWbhrRjzs
 n4CLIH99Tc41TwqOn9hEdQUc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f8890043187a53cd;
	Wed, 21 Oct 2026 09:54:21 +0000
X-Mizu-Trace-ID: f8890043187a53cd
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 03/20] hugetlb_vmemmap: Always flush TLB if needed upon
 PTE remapping
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261003002123.505555-4-jthoughton@google.com>
Date: Wed, 21 Oct 2026 17:54:06 +0800
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
Message-Id: <B8A44041-1516-4405-976D-534AA2412A49@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-4-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5537040003
X-Stat-Signature: ffj6zw5k6yskdrcyby4ufk9hccg8z9js
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792576463-699271
X-HE-Meta: U2FsdGVkX1/dGXd+4NLOYS2F97uvsH7VaYUz3ou8BMXdRZVLjM12GUIzsBDnaU6EeKeKp3Qs1zwyXUZd/ZrFDJp++E3X4heu1RNpBfucjLAA5piZ4orT/rveIsn833+hh/zc8Z9L5vH5GiaYpa3xqh1Zp+TB9j8RlXR8Ur1IK1T8sIh1BzBxkI+1c7ujZjQZYG8hiuHj1GLVHOG3bmfG20YG2wfjkw58hJz08zM18VYgYm9Yku453Vt1hLeOhrFmWpBQyOAYVB/5YSq5omj6lNPsUmi8Cw4FwWKuSaVBJv0CAGjWINqnYPbuHicje2atbSC9v0pK690QJwtxiBrSjs+bCRnlurRuyaKm2qj8thpzbI9mH2IafazoDp2UYj6kHUFNmfVHKsUksWxeUU5MF28b0PAAn1aZb90CKTE9MEaEgwGUjPqou2oFJSQScbJauP/FEXBNQtt8Nqzed2fhVgVgokshWueC/uUC2CZeZGbQ4hWS5MIm0iOX/LxTqA9VmGqMxJUZwn/x94FL1Yr39ZZ8FPFz040Pnwo5RAvPN9yep08zjK7tlElkGS5rL/vw1eCeYamNLJDNrpYYsCi7xm4igWZfh8afdlO0lTtJKwRlpHE6SraYRZi70tUyE1CyPAVjycSA/AtPSxUArxyYAQVH9xvO06wu2pYRv7VWCCLJnXs0OITDtyz+pbJ+u2qsIAzdfk6OeonWsojaQ0hSpbMA5eHCaP1M08iinPtOTsMOuQ9KNwd6tmoyT/k+p9eZ0ewkAdRZc1A+yYDfX8KTM8ASQz/6sXkgmwEHNw5EFzyZGIWdzJPBhhvRvaDh9HV2A4WBTl4WWQyViU6oZd51MLpHOIE6t/H//cp9KKRb5DdtMoKgvleR8wB2ZXrUH0H6Gi8K619hhxGEgun65ej0Ww9zzZAYWm4WQMrviHhXlXkkROiY3v/6efxzBOp+rX5JwtQS51hcCJRSTzhYi+o
 nRxK7OWW
 nBClDKWGD88+ObI7iQKNOBxIsEcJIVM3SgkHvwMDUVvKNCpwqrk59nDSk+HU7L2o/3bqOeIQJtrE9BBitUB8axtE7dgvcC7MWfsciUdfqQe9LNZrcrzTWMvKWWCOTElpMpIa5XnT1p0Ku5B8udVLAPQIpqzG/+mtIgSn688oHPa+g3WvvvG3sJ0NrkST53afrgyrV3RVBETBcdS90JfnwtUOZ4qBpuotZM1JsDRlDmnkHdqOaHqVecodnslUIjJkrVB5O9+pV4v8/AJ1Sg9NZMnOdAImbv34mNIsufHyZ59FeE/QYNRVSoijC+cMwPuIotMb1FHNjI2n+BDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi James,

> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>=20
> vmemmap_remap_range() can potentially leave the vmemmap in a partially
> optimized state. In this case, a TLB flush should be done if the walk
> caller asked for it, even if the optimization was not fully applied.
>=20
> A follow-up patch will more completely deal with partially-optimized
> folios.

Why are we dealing with partial optimization cases right from
the start?

I know that in patch 12, you try cmpxchg 16 times, and if it
fails, it leads to the partial optimization state. What I want
to ask is, why do we limit the maximum number of attempts? Is
it because during testing you found that this kind of failure
is very common? If we did not limit the number of attempts,
was it because during testing you found that the scheduling
latency caused here is very large? Or is this just defensive
programming? In my view, scenarios with such intense
concurrent access to these struct page structures should be
very rare.

If your testing did not find any problems, my suggestion is
not to set an upper limit on the number of cmpxchg attempts.
This should be able to simplify the design of the initial
version of the code to a certain extent. If we want to
determine whether an upper limit should be added in the
future, I think we can add timing monitoring in the arm64
try_update_vmemmap_pte function and trigger a warning when
the measured time exceeds a certain threshold. If someone
reports this kind of warning to the community in the future,
then I think we can improve it at that time.

What do you think?

Thanks,
Muchun

>=20
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
> mm/hugetlb_vmemmap.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 0057fa2a16a8..1a2645c382ba 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -163,13 +163,11 @@ static int vmemmap_remap_range(unsigned long =
start, unsigned long end,
> 	ret =3D walk_kernel_page_table_range(start, end, =
&vmemmap_remap_ops,
>    					NULL, walk);
> 	mmap_read_unlock(&init_mm);
> - 	if (ret)
> - 		return ret;
>=20
> 	if (walk->remap_pte && !(walk->flags & =
VMEMMAP_REMAP_NO_TLB_FLUSH))
> 		flush_tlb_kernel_range(start, end);
>=20
> - 	return 0;
> + 	return ret;
> }
>=20
> /*
> --=20
> 2.56.0.rc1.315.gc6ed9934b7-goog
>=20


