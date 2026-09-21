Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 807C8C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A916B009D; Tue, 22 Sep 2026 06:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4396B009E; Tue, 22 Sep 2026 06:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CC06B009F; Tue, 22 Sep 2026 06:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E048E6B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:07:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72E3916044D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:07:27 +0000 (UTC)
X-FDA: 85240970934.22.A1123EF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id A34EC40004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:07:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=meCsEBm4;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.5 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790071645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29HoC4vcwdpquFRhWlhrcMc4ruwpv4l6nUXdMTeyS7k=;
	b=kID2+ut7Ao+cfrITcK24IgJZsHqve3V5+B5rGXQa9HLSHxldnVu0BxyW475yUDJcIAeenv
	HIzdb5D0bUKOHYnJkLsts6xm0lNi0+JOOAjMSR2YtE+NzBecGieWqYCOWUPonL4fIWMxcw
	YyMYd+nxtP0bFQleWM0lWgi/BNHB8uE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=meCsEBm4;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.5 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790071645;
	b=h5gQsDCZA7Hcu6Q+FblRcykzrJeyD+epOZzx+Bn0brT5SXV80It9YWM50Am04180cyBimD
	RQ9K0M4DqqV52BHo0oAVO53Yc/5+JmBrSG4X5VI4g+Y9F+ecCIwc5Ccl+/dRoVCBqz8p/i
	vA/XTRXMBuwFOtV7bW1A1gXLvvzTY8I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790071645; x=1821607645;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=887MquzIHSe/iEOnfLb6yCNYFWPX/CoUsvP1EJyQ5h8=;
  b=meCsEBm45rXPhhBhb83p5ZLrb0eNjqHLZVdUGYSKNZgzud07L4usnxpE
   dRiny2z5tfjbnj3lzYse5a7yYrwraJD74/miAePe+j8XUmwYGLI0W8Gn5
   KpmHyovd+OBZPB4zjj863BPcelLwYGGvKt4uJCbSO2NSe1f8V4t1X69k8
   m23rl49CS85EJQvjbY/WvAIk/U/u1qzaHWExD+7OMvhPyAd0TdM5TD0EI
   6d4LiJE9UXaYvt3LgKpKm38+eS1k2Scc7cO/OnWRVrtdTLFpfQXkqvj+8
   XW+1NEFCzPc6/C8O/y1oa1tdjJNPYhilpGqb8WYBADQWYKzvVzUl0S4E4
   g==;
X-CSE-ConnectionGUID: tVpKcFjiRqKlLdDaLmHK3g==
X-CSE-MsgGUID: +kXRRuBSQcyx52tEp9Advw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="1043762"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="1043762"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa115.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 09:19:29 -0700
X-CSE-ConnectionGUID: tLmR9Ml+Sx+36mkelsPfCg==
X-CSE-MsgGUID: Ymk9WNNWS32bFWMSP/oKtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="3705836"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.109.204]) ([10.125.109.204])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 09:19:30 -0700
Message-ID: <f2e54889-ff66-469c-8144-8a7da2291055@intel.com>
Date: Mon, 21 Sep 2026 09:19:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
To: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>,
 Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
 <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
 <20260829174704.GAapMbGAZMwImcvIN7@fat_crate.local>
 <0B48BE2C-2E72-4961-91D9-35E215F537A9@quelquesmots.fr>
 <20260829185120.GBapMqKFM35KtL0Mod@fat_crate.local>
 <78225f07785ed89e0c3e5def8a8bb1a48e444322.camel@quelquesmots.fr>
 <20260916200247.GFaqr15333nu5IAfjU@fat_crate.local>
 <45dc4a4f62e49107de788b4be9a4039e0d772fa1.camel@quelquesmots.fr>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <45dc4a4f62e49107de788b4be9a4039e0d772fa1.camel@quelquesmots.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A34EC40004
X-Stat-Signature: n3pommptz54x4tujkyz8uj4m56kmwegr
X-Rspam-User: 
X-HE-Tag: 1790071644-704419
X-HE-Meta: U2FsdGVkX1+aJk8IDRrEQEHnWtd3QiNVosVLlsvre2KePJWbcwr86j/0p+AUoTnFo4UMRzu7HhdZLfTvW1fZmWtAymgII9lb/FdfRTr8DHbxv1A64I7FO8R+89Kl2g97Ayc9QIqHZyAVakwS24ijsFzFz5MJ3JfIpFixe/W11V3ALpK7qb5thP7OoaMQ0Ccr/UkUltEhnSadIl3F6Mww0/Dz1q3wOhne32rmPKvebKHz6siFYmnU1N8kFYqRDq69Y+U+DY8QZAjoBnzWywzVAqRSTvsXR/2tXxZdy1v/nQGahy+oDRg0ORm4DnYYfv13q+waEfURNcUga2+0fY8WN3jj0R4TVe+8Uy1vGYfekDgFDfRn0L3wzZhL3hwnCOSrTkHGzRfD3rG5jXQhpKE8mV1HdWDCqSrapEDt3x4PnHiEez9ViaPqWnbsSnR8nfg+bHWU5hqECCiM2QzEZAdB2Xm3gneHwho/tpVr7XGjtX+Xj5I9rc0hB+vwycgESfaao1yZTI1dMrxj+wFT1FZxlCaOpXg+pSLhhefAL9EqqkfXlQIy8r+0US7uq+bJ8Bx3/HvRwsA72gUO9jKaH7wEGE7m8R2dgLkB7A2apbOiRWiUXKAkScwcWa9YXUqswRIUkEfu8WrgkuV1rhRpQwoHGFOsvfykhYArqdadzqjHRQx7+f2PYDAlbcOSEZIJlrQpqy/bVHS95l7dOw4WI6H1/+my8mlvk4Dx5CTNQjCkZfAX4D4rN5dtAq3dxZz2NRIuiUtn9C9d3QGY667rYGrWUJ6FwuWsmeUB8BvXsWmDReNg0YbcvzLuYsWxZjOnu+i3kUrtYca3XHeGC3Fsu4iYRjRbJOb4QWb6tXt/G8BPAni7gO6yGcsOnKybW9fKgrHaaLbkKBwrRQT4ch1Iddr1QpUsALuY8cnfB6uYpy2p6VvsRdqljyhRC7I8djKEavaa5ocFXBVx/9WHNWMo5Aw
 sFM6H8UY
 zILpBnC3C4R74R4MqJvwrbFoAj4o6yfWtgco8z8dYBLhUZnMtcmbZXKn2k070h6APXe1Byujzw3Kc0olIl9nCHUyBvyfIhl1L4Uy91y1nDBZoA4lt7eOHXg7aVrdIxLxQU7hBvtk2T3Dg21xZ90b81NNLo7A9szde46KHgjJ1aq5m5Ldw1b1aaTGMN1ZC4rDV56n5h4QMN6vs/6kE2gAHxJ4CrxIMFpyK71sf8X+TGqRawlSx8TNMKQ3Ndu6cZt2pXkLr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/26 01:47, Laurent Wandrebeck wrote:
>  static unsigned long get_align_mask(struct file *filp)
>  {
> -       if (filp && is_file_hugepages(filp))
> +       if (is_file_hugepages(filp))
>                 return huge_page_mask_align(filp);
>         /* handle 32- and 64-bit case with a single conditional */
>         if (va_align.flags < 0 || !(va_align.flags & (2 - mmap_is_ia32())))

I'd just leave that hunk out for now. It's harmless to leave.

> @@ -50,9 +50,13 @@ static unsigned long get_align_mask(struct file *filp)
>   * value before calling vm_unmapped_area() or ORed directly to the
>   * address.
>   */
> -static unsigned long get_align_bits(void)
> +static unsigned long get_align_bits(struct file *filp)
>  {
> -       return va_align.bits & get_align_mask(NULL);
> +       /* hugetlb mappings must stay on the huge page boundary. */
> +       if (is_file_hugepages(filp))
> +               return 0;

I don't find that comment helpful. The function is kinda misnamed a bit
too. Maybe a comment like this?

	/*
	 * va_align.bits is smaller than the huge page size and will
	 * lead to misaligned huge pages. Ignore it for huge mappings.
	 */

> +       return va_align.bits & get_align_mask(filp);
>  }
>  
>  static int __init control_va_addr_alignment(char *str)
> @@ -157,7 +161,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
>         }
>         if (filp) {
>                 info.align_mask = get_align_mask(filp);
> -               info.align_offset += get_align_bits();
> +               info.align_offset += get_align_bits(filp);
>         }
>  
>         return vm_unmapped_area(&info);
> @@ -222,7 +226,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
>  
>         if (filp) {
>                 info.align_mask = get_align_mask(filp);
> -               info.align_offset += get_align_bits();
> +               info.align_offset += get_align_bits(filp);
>         }

That looks fine too. I would rather this whole mechanism die,
personally. But this is a fine, backportable fix.

