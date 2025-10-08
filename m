Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBE6CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 01:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945238E0005; Tue,  7 Oct 2025 21:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6138E0002; Tue,  7 Oct 2025 21:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4C38E0005; Tue,  7 Oct 2025 21:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69CC98E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:37:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1310C86F62
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:37:07 +0000 (UTC)
X-FDA: 83973233694.05.5C15A20
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0CBC7100006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 01:37:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aGvPEtAG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759887425; a=rsa-sha256;
	cv=none;
	b=WevuC4V+pc0uR8GyOCmVye1oaMsF2hlt7g224zpGKcHWkNVvMPQFg8CH48Dt3KrOVqu/sT
	kAPyLxQ9A9WyVP6gAGyB1aAiaI4bHxfxg6t57lcoc7ZhW7QgYmW1DTz5Zg02zNI/7NG6tl
	ZVDKAnkIeOoYBG7XEDusttOY6lkG7N0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aGvPEtAG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759887425;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTI9bX8kpTx6OwYWzqSJr3x9ShdcNTf18QQbs6hvqeM=;
	b=ZbEMhCIg74cG7rUX3epp+QQlaRKVRnoMVGrfMXNNOSYswTdlsY5BS2+OqG+Pv2xf+4tI6W
	8VIugKyysT6pG9AZnEhgZ9D+ZnQk9FxJbX6+fWQOHC6W+tur0UaQz6NK7RxJYyrzrxQjM5
	bdjEekgbBzBmN16+8xaK6dTLC2avZwU=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-631787faf35so12499716a12.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 18:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759887423; x=1760492223; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTI9bX8kpTx6OwYWzqSJr3x9ShdcNTf18QQbs6hvqeM=;
        b=aGvPEtAG13eXAKdKzcTKxjPJATkaF7nKORfkdcZceHkcwnQ1FEde8gC7uEKAevmnkP
         Wb2irBsWa3bJbZ+LCDB4RtQQxELRrxEHDOPpxk7/Pv9X8Y72/nH3nGRV6F/tkVu/tJVM
         f07gRj1djK8dI+b09mCOCUsufX4/KAP1L67J9tNYarHWCd0anIeQSHWqGCqubcc+ETJr
         JPucyu/QVfk9tJZ/Z0HYn8S3sb3lyYeCWqfm/95oaM9Pvw9eMcDRKmysbmciWoyFjH3y
         aftQXpB2LfFErioJXuY1VILFyPJxbIdNhJOBOQLpPPtx/rkepo2W+mfC98ilYLHPvyHD
         m9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759887423; x=1760492223;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qTI9bX8kpTx6OwYWzqSJr3x9ShdcNTf18QQbs6hvqeM=;
        b=mkZt6ZLQTkt+b58vN0EQ1TNKTYp0iHrm7gTM2Q/3yFx+FhLe+/FChOlLIm11Dt+kfR
         y0mpS9N6edWmejeA9G352hU0IxLCyTGoGsWvFUbDFBQuCAv8H6VwP+IV0SUA/ESqr/ku
         vJQQIlp6rz8/pwZ7BvoSzf1pD++IHlkQJXRuDAhXajlQ5jAKNJ2pg0VviEsUNbCsx7L8
         BuyPrptUBSYry6MJqnQE84hXe6cQLDcdzhQ73/6moWnttOaF9HAcSshnCSarmpLV9Okc
         69CXHRMHUXgEB41ipeTHDXeeb6G4vLaBZJuVrJ3hyNa6SKrJxx+KL7MNt/fpU413T2m+
         WJhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWirDevar4MXXgqayxs4LrEfrLQvLdWQ3tEy3hknqb8ylgEe40/7aWCzQhPgtU3B/t0digNT6qIog==@kvack.org
X-Gm-Message-State: AOJu0YzFvaAK6i0y49qvoVyOjqjvSl4Kn0nmwhtMA20GVK6GcUM6VhMw
	O33NHI+6EJIKRQJI1EEgCBWozxn9FgpDP6cHWuE+Jiq8YlDNbu84wm54
X-Gm-Gg: ASbGncsmuBBVGTjjwYBV3Rb2chMJawkV7u+Sr1FlK8mE3ANUNLG+4euF5uNL9Y2GTgT
	E+ySSM6vn4WFUvyyxxJJyyxFjsUWnNlrtGOtnQZTZ47QBdxnELxiLS6RoYyJlc6v/7i2hGWzpA3
	0uINIPZvPw65AtqFb4l13UMyIJblYUMEfc/GonSLKwJOhzDqtH1YtZMM4gqsNEidhXE5gTM07Ch
	V0i07i+HMAgd9DZiXRCZMAEuTghzaRmFfyhTFu3ip142ZyW46WpfuXiGH+Eqav6h3IUTre2nnf7
	dWn7mne+ckrRSDd2xYRonYQcp/DEP3gsKAQJHhYYdXLJqj8HnyPOYC697kq0vDlcvC6KOKv29iu
	zOn+WPGDFvrMawrmBP8fl38n7/s3JCXzzl5q8B0yXzzmV7nv/CQ==
X-Google-Smtp-Source: AGHT+IHR71uTMt98eJmNaVJuPkc7yPWPra6MlvxsH6EwmRI4ppOh3ZZt/mIIYFoE0vXfD0Nc/DDTHA==
X-Received: by 2002:a17:907:c27:b0:b3e:256:8332 with SMTP id a640c23a62f3a-b50ac6d378amr191888766b.54.1759887423087;
        Tue, 07 Oct 2025 18:37:03 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486a174a6dsm1527786466b.90.2025.10.07.18.37.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Oct 2025 18:37:02 -0700 (PDT)
Date: Wed, 8 Oct 2025 01:37:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
	hughd@google.com, ioworker0@gmail.com, kirill@shutemov.name,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
	ziy@nvidia.com
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <20251008013702.6cjaufazal6zpvga@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
 <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
 <20251005010511.ysek2nqojebqngf3@master>
 <31c3f774-edb7-420a-a6a8-3e21f2abd776@linux.dev>
 <09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com>
 <29742109-13c2-4fa6-a3a1-d12b14641404@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29742109-13c2-4fa6-a3a1-d12b14641404@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: w69afbqt767jigobi45hfhpqrty5fcut
X-Rspamd-Queue-Id: 0CBC7100006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759887424-135591
X-HE-Meta: U2FsdGVkX1+pZr5BQYe4TcFfLFN/jWiUHb0BNTvJ0OD00vJLVZ5d4NC3VMoNbXfgMm3SdV017XLb/PSHJHqN/Rx85c6Asr7P9AC1I2GOqkAfrPj2IJwwudScgdR4h/jyCD16aVie/WUCWtvuB9a2n8E1UnK4djo0prAR3hUTD+1yvlMEcdQJuyTLm4mMWb42ikfhWVxYtSpSKraSGaxpMJAHYglBhGYwJzuuTWcs6zma0yzwvMZTHkx9gpn8TnGL7uAcs1uBPitwcbsc/nWftYz0f+uDllIRXULPAG2PFOnNoxfHXGcfIer7FGwpGAWQUqCRKiOFAN2h4opO4xrsUq3LKAZUq5AoYHeluc/wQ3NeDeIeK5Frmbo0lBg6w5QnkY/B3+PNe+ynJ/Ey1Oc3fhvPouXL7AK8L28hWGE7/IkmzGKv6/+sHZQJZLl5GFyW5WNY/ws4aLylsv4R1NtUr215cOQfV70IHEaixqLuw/nqRJcpBuoVVs+SapKlbOFTMj/eQg3EUfwdYngjl6OAbbrKNfIxAVVIdJ4t4PFwD5j/teoPE2NBPvy3d88dk7zYpkIn7HOAhDwB8ws42Vzc+4+ht+6bqh5DlQHnX6A3cb8f20a7y9+lMlp5ue9xW+D2s5NH+/HEgsxUnGjIJloENz7GMPovkC/7OdfPL2LVr8GUZVi2hOx9kOvvn71nd46C2MIqYRRCBKzmtPSyq2rE7P9XUkLV1lsJtz6g3cEWDkM9v8jD11j26YyHDhLjLKOPQuf44ziIhpj3IzCd2rsczQdDCvHScS6jzFOQf5lA7L3AqbeCgFMYLD8eojLYv5MxkSzwJYPdA2tidpmlx8kP3y+kIas3ppOyD7CR4MeB8tLUnpAlYN+DjqwCF+3lIlI7D4x47jBXPYQZs3wxf1CYZ0SM0Jg5OX8sGpmxvxwTYs5HLLqqE/CbdoSUpmiKtEYqAADCDv2Hg78ZsRnyiPh
 sUKPFvEd
 oQzWVYX4sHy/662bAh/mjUd9hVbzw2v6yQ/jOJkCSqkNyQcGyZHxPlE8UnXTeBFDD8psLpXKWnrnvFr8CiPyZmalZJGCk7++1yZB7P84Vr+mHOKh8D4VoCBfIY5X3718PUFxGDg1q1UaRS6+11vUN/VyHg3VlAsU+8XHRzobVpFaKoUy0Q5u6gorIkNU5Gd/DlROsGWwvVEDfHT4nRIX1cs7oX4nDscs8h/7Bli5HjbNYWBrGgpu6I4184TCothniwz+uhjepKTWwCAstPZ7z2M2L60HsUR+1gX0MXGf0qTvqVXDcMPuHYWv7Yup3yYxiotKGage5VdrvMuPkAbId2MWMl7j8N5VvPfA1FXD/aJdD2fWY6tiU3MY6Rrvi6BLPOVSo8kaj7cx2CnWpvFjueKP3EWTM6LJDIn42i450u7M+Jdx0Mog8V/sPA6BCSNtmhiKL25Ni6hnB4U89i4LmxE5PUntW1WI1gPWaN/KB9QG472freafZGDWlnpi2Lcrq5uS7eZJx8zNA3QqAbJLNnrbN0KvB0OC8uuK3w+LqNstD9t4ob4yaXHq7mnNF6Ll2lpRXE/5cJxoQbvPmb3LDNqhBSpW1bWDjBTGN0MNJmgC48IB+ujAfIIX8XYpQl4BRwNIN9VpgmjTz2HrDmvXMBa/5J3fDJ83oqmEeUWuFvk5aJr4n4VTKVHSrjM2VjASH4jTmMX9OOc5v1V/sM/YqrlQVPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 06:25:13PM +0800, Lance Yang wrote:
>
>
>On 2025/10/6 22:18, David Hildenbrand wrote:
>> On 05.10.25 04:12, Lance Yang wrote:
[...]
>> 
>> I was looking into some possible races with uffd-wp being set before we
>> enter do_swap_page(), but I think it might be okay (although very
>> confusing).
>
>How about the version below?
>
>```
>Currently, special non-swap entries (like PTE markers) are not caught
>early in hpage_collapse_scan_pmd(), leading to failures deep in the
>swap-in logic.
>
>A function that is called __collapse_huge_page_swapin() and documented
>to "Bring missing pages in from swap" will handle other types as well.
>
>As analyzed by David[1], we could have ended up with the following
>entry types right before do_swap_page():
>
>  (1) Migration entries. We would have waited.
>      -> Maybe worth it to wait, maybe not. We suspect we don't stumble
>         into that frequently such that we don't care. We could always
>         unlock this separately later.
>
>  (2) Device-exclusive entries. We would have converted to non-exclusive.
>      -> See make_device_exclusive(), we cannot tolerate PMD entries and
>         have to split them through FOLL_SPLIT_PMD. As popped up during
>         a recent discussion, collapsing here is actually
>         counter-productive, because the next conversion will PTE-map
>         it again.
>      -> Ok to not collapse.
>
>  (3) Device-private entries. We would have migrated to RAM.
>      -> Device-private still does not support THPs, so collapsing right
>         now just means that the next device access would split the
>         folio again.
>      -> Ok to not collapse.
>
>  (4) HWPoison entries
>      -> Cannot collapse
>
>  (5) Markers
>      -> Cannot collapse
>
>First, this patch adds an early check for these non-swap entries. If
>any one is found, the scan is aborted immediately with the
>SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>work.
>
>Second, as Wei pointed out[3], we may have a chance to get a non-swap
>entry, since we will drop and re-acquire the mmap lock before
>__collapse_huge_page_swapin(). To handle this, we also add a
>non_swap_entry() check there.
>
>Note that we can unlock later what we really need, and not account it
>towards max_swap_ptes.
>
>[1] https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com
>[2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>[3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@master
>```
>
>I also think it makes sense to fold the change that adds the
>non_swap_entry() check in __collapse_huge_page_swapin() into
>this patch, rather than creating a new patch just for that :)
>

Agree.

>Hmmm... one thing I'm not sure about: regarding the uffd-wp
>race you mentioned, is the pte_swp_uffd_wp() check needed
>after non_swap_entry()? It seems like it might not be ...
>
>```
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index f4f57ba69d72..bec3e268dc76 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct
>mm_struct *mm,
> 		if (!is_swap_pte(vmf.orig_pte))
> 			continue;
>
>+		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
>+			result = SCAN_PTE_NON_PRESENT;
>+			goto out;
>+		}
>+
> 		vmf.pte = pte;
> 		vmf.ptl = ptl;
> 		ret = do_swap_page(&vmf);
>```
>
>@David does that sound good to you?

-- 
Wei Yang
Help you, Help me

