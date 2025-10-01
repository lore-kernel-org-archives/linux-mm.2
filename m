Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A80FCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 13:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8000D8E0007; Wed,  1 Oct 2025 09:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7896A8E0002; Wed,  1 Oct 2025 09:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A668E0007; Wed,  1 Oct 2025 09:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42C828E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:52:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD2E1140A40
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:52:06 +0000 (UTC)
X-FDA: 83949684252.22.BE69055
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id CF55F140002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:52:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmIIRdDt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759326724; a=rsa-sha256;
	cv=none;
	b=b28Umv7H1gi+uM/EC+lF0snnG6DCrCPy0k8HFhC5AWTq6jgCeiHOOWVjCjbBbObRVNOmST
	Ogah5LgQBoZchlFZLyU9TClkSSPFO49Sd2UHgz/J32qj/l1aBZltgCBSrEfx764kVbtl/W
	/1XbXVDCHhYjALfqg1C329VkTVU/AkI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HmIIRdDt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759326724;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTnQz2B97Go8SjHIgN1IQAu6SiGkVevP1PQobrwF0MU=;
	b=rgofmbWmS6Q++Q8dKqweAnvWLzpfXdDc8Ngczfhsc6tBg7ROM8xkfFS93PLCvW5nz9cDJ3
	BTgEvD0DXa2GB8F1j4mEzkYgbu9gVGBRalziE0sxmelaft5SgKyPqIlrHnrHZ0zqwEQwrq
	iqsC3dd9xnLbHUkbbh2cikerMbCiryc=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62105d21297so14307444a12.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 06:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759326723; x=1759931523; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTnQz2B97Go8SjHIgN1IQAu6SiGkVevP1PQobrwF0MU=;
        b=HmIIRdDt4fFxThWsna/PvcAir+havnellseKAMIKXcH9LJxEuqXKKrLPqmSJzanLaS
         y8S2UHXEXvtWVVlybbCzKWh2ku7zwbfcn+nU2ca9bIp6o40JQxtjgtA2RhIfBdSTHTCj
         heh8mODUs9nHFfpkXZha1YMsKXVD+90tggP7xbehmDbV3PUuCsoRmR7eyJJr5Mp3Fh+w
         1pg2srSIvYc1mZEQL5LUQSMCY2fgfkrUr02Aw2p8cPsib0Qb+snY8zCBhpMklhsHullK
         4rhaWznjnMC+0U0CVrwh4qhNIGKcNZ2ZpVct80WX18AHQZwhD/i8gt0npNraaq0n7i67
         728g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759326723; x=1759931523;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CTnQz2B97Go8SjHIgN1IQAu6SiGkVevP1PQobrwF0MU=;
        b=c8edcCPiG2L+aHxLizVQ5ytyTygyxtCBjZVuVsQpZ12hT0w6boqKcuXjJHW1YllV2w
         NeJP/WnnHpUlKy1BQwpuRexgUKC/PhBSVEDq1tcSLEg6gO1zF5jeK7hXXGMY0LC+MvUx
         T5kvuLIJadZVAN3jTlETbbv+mYK4lIddD8ro0R9AQDHHNF3eDaKmhdwUEarrnCsjZWZu
         lIvkP/01HRjwUekq54nNTnfusyxsAD3jDJv83PD3I3aRK62Ew7QxGYubZlpVHyAPP/12
         GcdrVgYMb98194sSVHIHHKLt82c6rid+5VV3P9TniDKAQeyeCoOKWQBPVJ8zGNfi+HH8
         DIDA==
X-Forwarded-Encrypted: i=1; AJvYcCWG97ACqU+y0Ubb32+vFkutZGE04s1NcIcAIx/9meTfEsTq7Y1q8xKotc3xc/2K6mhgXranS7+tEw==@kvack.org
X-Gm-Message-State: AOJu0Yz/5j8i/03l7W0iTfcZYW0DPYKyGltcw0TD4lQuDAF/cc6Z+xSD
	A+uvY5Q/2lMVzY647A+kDKNLQEl3QMbnZoZHih9iDp+Zta6s8OjT/afr
X-Gm-Gg: ASbGncv+X+m/86JzrAnGYoV8s4JT77d4SR9KVavb2tMaxaw0S9PyS9q7tviLcqkr+OO
	HPDgIsUqMLimpZmE/Y/HGozrBH7N5OXXpVDRxyj6jt9auJ+s8czEtsvJdTgtFqgCmhXDlCcGKK4
	aECrZ9sUH4hJR4YavNWVssgS/2NwjYrAbSedY+5bGn2lM8YoWnV+oiWkHE05EGYo1hgz+Q7d3xY
	74HTI9XAYAz64leyed6/KSrNd1qIAp40WFtRhJGdCIAaKLAlR19pKDUg0lWhxOVq4cZUFWwy2w7
	mlZuXJY98slH6TOPHDLwAB0oPQ163oTVLZj+R6V6a+QwXHB8FIKC33qFk+/CtdKajkptgLJBhEe
	ZVH+zW07GZMxcoFkg13TWhKaPXtbhyY0++YaUWLOjzMLVR3o/rA==
X-Google-Smtp-Source: AGHT+IFNRbieOT/gTxdexKZNxiO5EyAejMAeg6/o1NCJvpQm6IlPGrWwds2Gzsok2Sgd/21onM1YkQ==
X-Received: by 2002:a05:6402:270c:b0:61c:7090:c7de with SMTP id 4fb4d7f45d1cf-63678bb6f54mr4184514a12.13.1759326722811;
        Wed, 01 Oct 2025 06:52:02 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-634a364fedesm11797486a12.14.2025.10.01.06.52.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 06:52:02 -0700 (PDT)
Date: Wed, 1 Oct 2025 13:52:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
	ioworker0@gmail.com, kirill@shutemov.name,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <20251001135201.fgidcx2w7jnmxinh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
 <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF55F140002
X-Stat-Signature: z3yr4ygi8c66toooojgtp9bqwq63re4o
X-Rspam-User: 
X-HE-Tag: 1759326724-106393
X-HE-Meta: U2FsdGVkX1+unb05yt+wcQsyvYMlrCfS4wBKnlXbTFnBnmrsadLlixNANaLq4BhNbeBhgrvT0KhSCN5MaMNvPiQYUtDynvjabQGxpclrfWzomtnAbFeKHRSS/xQcDx7/x4I7FzFXtRDgbqqIo7zMsqylaZYys5FgCnwOEJ/Ol5z+SDqKb8r2ZnwGlTLKZ65vw27XHmYvHHSx9JMZC3A6PBV9zCIUwJr9uJCLZrzOBWDsGbfoDNmKDozTgrkIQ6wth8JicgpzxHeMVNMUKIjbxq/uV93BHQR/CWq5nowzUvL5lUqz5UQeqTtHqdmrDi9UnC5n+YdPTv4vYwS3XfcTC0hrzTpPt4LdVLIForYJdd3cuX6kQScypWXnS2o1/s+L4qUdsFRcd9jH/EFUXQHkmODglvWjSuF5vkFrCMbnd20rhV/1kvRh2jPO6G+ACpSmWmBj5AFwv8u9FhwUQq+Qplp/pk1sqJGHfQ1vlAOj/bV678sI6ijqkxVIgk45GB5ACrjvIW9lI0VfHvBDXXCe2p5g7tqCSUUm05fMF9r3+b0oWbS9QckJMbb8dqmB3b7L74TQjq1uThytS96KxmSHCe+DfkLN9PVwDzK6ckEM0l1iy97R5/57mTYbbEDuu5GznA7OXVO9vJgtWcASfKEu5vLMmiuYWu4lqJ/zE8Pblg/m6tjtYLoFOQX1Lr4XXCD70sopV6huypEoW5rNy2h3+GygSIj+1X0PBPjgsY8TBRwu/Wx9uui0VUylgYHcwAM8gE6liri8qR/VhhPpiUH3rKr9+TEoKQI14IOm1Kx/zlcA5oZKKcUPu2/EJ/Z8w7eL2t9afztjTWxV/PkZGRATdcui7NqJ8wSQwE6ECUnlBIxxN93pqBU/Zh00ViduYZKrbCavxT3SY94trDC42QduiF3sF0C9COe4WgRf+RcpewWvsdor+cehzegKUoopWPUAKVeciXFDVBk60wTsyYt
 Ymh87gN7
 3yHYIDGT+tdf+Yk4v2PXm/+p3dzq7+27/FGO0JcpEAIbcP4QhujWVz/V8ZHS379V1SU23nBuwQ6syeDvvF/7bgS44ZIhbqKHI4MI3TBQFYh3udwXk7mzkxYMRgePrPBoZGJeO9U/b4ILu2KA77HvVRDAo/xnuoH3qL5934QtVCz0GaG/Z1sI0agvPTWSAcaOqFpVKBBsEV2OQQYty5HThgWe79qlYy+j5w5CCXdIHQ3Lod9yXAXfLFJaLgMk2xuQIHW/5K6hmWPrDpZwZQ9LzMDeHd2C7Fx6ZSZhKf44BVyv6zWkjHgfneL5Dff6GkC7AsHN6DVh6N86yWdHw3G5+UB3Fmac2Y2YhnzCj3FLoh2n85lyanOcVkLZ756Tzxh74FG8vIgjhr/ffvXGg/JpT54u9pnC7MaL5cHVC6Mo/Wo7bi2GxGFEXCRQBKrwfs3l7j6urLerifMOkDSm9tlEsdoFZZ63c4/KY+L4WPeg7O+lMq/vBIpFeeyLu+gJLxW8A/lcK7fzSM6co8MgKvF9b5GIWPrOVX1ENAFBEi1j5XuUHhejIwMoey9kzXIrEBI7uqhMXZYCw0JO25T4YMXJVgCMmT9M830Kq3l7Qao5Dg92XDG/jYgfAiISJspLUz12G2rd7uTYoVLg3XLiS307OOKUt4HjetCyDkDpmxiijy6RICNj14Ib3bmp83ETZU2n5WQdT3e5ngYONJqz+zuv3IaqXi9OJloJJIheZq8oQpY5oGHbshjyp0Pq92nsBK17cHfF9MFY+9Y/0+Dk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 06:05:57PM +0800, Lance Yang wrote:
>
>
>On 2025/10/1 16:54, Wei Yang wrote:
>> On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>> > From: Lance Yang <lance.yang@linux.dev>
>> > 
>> > Currently, special non-swap entries (like migration, hwpoison, or PTE
>> > markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>> > failures deep in the swap-in logic.
>> > 
>> > hpage_collapse_scan_pmd()
>> > `- collapse_huge_page()
>> >      `- __collapse_huge_page_swapin() -> fails!
>> > 
>> > As David suggested[1], this patch skips any such non-swap entries
>> > early. If any one is found, the scan is aborted immediately with the
>> > SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>> > work.
>> > 
>> > [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
>> > [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>> > 
>> > Suggested-by: David Hildenbrand <david@redhat.com>
>> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> > ---
>> > v1 -> v2:
>> > - Skip all non-present entries except swap entries (per David) thanks!
>> > - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>> > 
>> > mm/khugepaged.c | 32 ++++++++++++++++++--------------
>> > 1 file changed, 18 insertions(+), 14 deletions(-)
>> > 
>> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> > index 7ab2d1a42df3..d0957648db19 100644
>> > --- a/mm/khugepaged.c
>> > +++ b/mm/khugepaged.c
>> > @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> > 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> > 	     _pte++, addr += PAGE_SIZE) {
>> > 		pte_t pteval = ptep_get(_pte);
>> > -		if (is_swap_pte(pteval)) {
>> 
>> It looks is_swap_pte() is mis-leading?
>
>Hmm.. not to me, IMO. is_swap_pte() just means:
>
>!pte_none(pte) && !pte_present(pte)
>
>> 
>> > +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>> > +			++none_or_zero;
>> > +			if (!userfaultfd_armed(vma) &&
>> > +			    (!cc->is_khugepaged ||
>> > +			     none_or_zero <= khugepaged_max_ptes_none)) {
>> > +				continue;
>> > +			} else {
>> > +				result = SCAN_EXCEED_NONE_PTE;
>> > +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> > +				goto out_unmap;
>> > +			}
>> > +		} else if (!pte_present(pteval)) {
>> > +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
>> > +				result = SCAN_PTE_NON_PRESENT;
>> > +				goto out_unmap;
>> > +			}
>> > +
>> > 			++unmapped;
>> > 			if (!cc->is_khugepaged ||
>> > 			    unmapped <= khugepaged_max_ptes_swap) {
>> > @@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> > 				 * enabled swap entries.  Please see
>> > 				 * comment below for pte_uffd_wp().
>> > 				 */
>> > -				if (pte_swp_uffd_wp_any(pteval)) {
>> > +				if (pte_swp_uffd_wp(pteval)) {
>> 
>> I am not sure why we want to change this. There is no description in the
>> change log.
>> 
>> Would you mind giving some hint on this?
>
>The reason is that pte_swp_uffd_wp_any(pte) is broader than what
>we need :)
>
>static inline bool pte_swp_uffd_wp_any(pte_t pte)
>{
>#ifdef CONFIG_PTE_MARKER_UFFD_WP
>	if (!is_swap_pte(pte))
>		return false;
>
>	if (pte_swp_uffd_wp(pte))
>		return true;
>
>	if (pte_marker_uffd_wp(pte))
>		return true;
>#endif
>	return false;
>}
>
>In the context within hpage_collapse_scan_pmd(), we are already inside
>an is_swap_pte() block, and we have just handled all non-swap entries
>(which would include pte_marker_uffd_wp()).
>
>So we only need to check if the swap entry itself is write-protected
>for userfaultfd ;)
>
>Hope that explains it. I skipped it in the changelog as it's a tiny
>cleanup ...

Thanks, I got it.

Generally, looks good to me.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

