Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21F5C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7B86B0088; Fri, 28 Aug 2026 13:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C779B6B008C; Fri, 28 Aug 2026 13:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66306B0092; Fri, 28 Aug 2026 13:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90B6C6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:07:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F11B1C1CBD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:07:45 +0000 (UTC)
X-FDA: 85151310090.20.F2C1CC1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED62614000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:07:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W35k8M93;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787936863;
	b=l5yQjrVCaqYMq8Bso/p48KGTJ5UqdEtQzxeud3RrrPTzvruPvMf5Sj/McfyAB0TFM+fgBh
	XRpLAcnhig8rW+Os2flCJvROT90xNaq9hKQmTzgsFi6j2l9ZOOIqgDgxy2/A9B3aHYfP0D
	NYZWpUoxmrGpiiM4wWQsUAfveu4uTHM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W35k8M93;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787936863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAJAU9YJYGUoyg965/HE3yqF8wsD/0zAX4fgIluBSvY=;
	b=nMJ6ZgUWK01NdD5NYl5y3kQwrWx+wjL9HVEqxBDoVhFIVzXmRPk1NjkIguTCSNXRLOSsAP
	UxDmn0WnkjaEcCwGWO7lwZocfC5jmYMClqURkEZ6oQje8nmXBBAdoB2w3DEWFMZ/QlBKFG
	a9YVXfvT3DHt+0DAPe1KLEOGG1smjlA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787936862; x=1819472862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MZ8WP2pPfAtwYZgC5kW5edSAbNS7k7xAk0HTmwxHoZM=;
  b=W35k8M93h/yFM+5C9wEysHMJH0YPeF17zp109HGsNl1TmqRBau+jhay2
   e/6sMPD56KFoaBEGs3lQ3Q6jWrUpxJ3S/v7ZO6B3abVk4FAOFzF0z+xfI
   EdP7q9+WzQFIk5lQBm8uNGgWxg8vX09YSRjpp3qChkwrGBKWo5P7lYp0G
   ezF4yl/vYCEn/axB+HPhFb3oDr9ZrFWJjA2KM7twz9G68pfbezu4bG4+N
   mHcX9seKyYPVz76sXH1nw3urH4CLC25LN6BHrJlSQNYvyl0s+p2wPb+HK
   Rn4d2g1iXTWxIRtMX8p7tyHBMzTDp3eYJ9taX4J7W5H7oxWl+Ts0qnROo
   w==;
X-CSE-ConnectionGUID: J+mNYrqNQfaeEHhY9IBklQ==
X-CSE-MsgGUID: Ko30hYEGSTuXwoQAnousiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="75995298"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="75995298"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 10:07:40 -0700
X-CSE-ConnectionGUID: oA/ubusyRCqZ8I8cxhaqiA==
X-CSE-MsgGUID: MDMINixKRPuTY6Tw8KIIAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="263927553"
Received: from cooperst-gp71.amr.corp.intel.com (HELO [10.125.109.188]) ([10.125.109.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 10:07:40 -0700
Message-ID: <3faecf65-7edb-4cec-be7a-e5266dd3a649@intel.com>
Date: Fri, 28 Aug 2026 10:07:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: don't apply va_align to hugetlb mappings on AMD
 F15h
To: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED62614000A
X-Stat-Signature: ei78jab7fw35yxerxgqq5pm6c3o5ef4u
X-Rspam-User: 
X-HE-Tag: 1787936861-43815
X-HE-Meta: U2FsdGVkX18GDA3TdipVyApf9Mf5n+hHwyr8iXKRVTmeD97o3a3hxHUZvVeHjvkgmvWu7LjmuOb+ag++Ar+dIGjJy/S9irXF3Tfc2l16L1RS5actmNo25fcHBOFf88D8ymap+/ubxlcG3++EhkEQDwrOdcY0dpUS4ak5pffJhd70gRkqXYKTlMdqPUH9m3zoSUo7XcyglqM5UW0IkN9hFPxyUtN/pFd6TlCGTta6ZRrcsjDuXUQe61aYPhk9jYug5x2IQidrxQ7VydbS91bwhyZfExdAwPw7He5//3vc5X6Kx2qn1g8nqCgnkvtMAEM04f9sHh1Uh0+iDYd9+Q34n3AvxDS2i0elv8iS6sXbOC+syUSIDKB62JsmW6FTIjh4kk9BXBz6djo38zwQ7zzZa0cuLPOhDEVQuJoCdFnJVxDug2/4sgtUDzt0qd5yYY9DKm25KHKFZeiLkTiUTltZoYpCWHD4YzELcsHOEVorSxSNPp8hbuqM20DPOQqDBGoMcNwa/1wK+vvF95N436223jB5VPIVOZhSrVEhvuEWNLTg5zU35wsP4FLHtDiHSm4D0NinSOZsc4WPttUNo+iu3aKVG2QCRRbLS+nGnw6H+/S7QCK5y4jZtrc0Jm4LogRUBCBF5XA7m5mnzq7dDfCCZD89Khv1yGTMNHwqtiqQ5r8KTlVA6LTMOpIixTU0Y5nYC2m9YRx6u0EXriJUG3UgfBDC/ltMN2kHZD7aq/uAn3t7mDnXOZ+QVkz6K8Tl2bYI5uSM1GFJdJsadVA+wRKUWr389uwv9nLki0GURIzw1RrB1y7gI48e0rtXQPe1cQqfXo+VbMLGAGnmzs+s2yvF1OGadn3ZLtcNtokbJ46fMvFI3yw4FVL4rk8KBYjTaB5SKWIjqQZ5YiZUCjtDqN23bLjrHQJ/SL9yTTcwVwi3AJoxLoWIyHdTNKD+K6nFFmZLCdYO//PCxE3YHPjvMzO
 iFRRf1Sz
 2ugzTHBLwdPkbT03yo+q/OUV/NBlcp5hU7QPBRy2n7expxeFyIwn+40Ly3QOotATNTHnsbpkiJRFXRgmtKI5qtEbQ5d6Zj7Qr4lituQvT3r3hBnuyJVYIZAta9ZoxpLzEZLR3OVdVmxsgUXTXsSVHNLL5T5onF3FGMhVXsUmJJV2+d8KDF1M8AdMEDl0gmEDBJlhjSRblL+eGq30XUceaAC7DCSfrw+3WMmvnUDO3DdR1QzB+Ze6xAU0UaA9RVWV/spIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Boris,

These AMD F15h CPUs are, what, 15 years old now? How bad of a
performance hit *was* this issue? Is this optimization worth keeping around?

On 8/28/26 06:57, Laurent Wandrebeck wrote:
> Commit 1317a5e7f7b1 ("arch/x86: teach arch_get_unmapped_area_vmflags to
> handle hugetlb mappings") taught get_align_mask() to return
> huge_page_mask_align() for a hugetlbfs file, and skipped the pgoff-derived
> align_offset for one. It missed the other write to align_offset:

I'm not crazy about this changelog.

> diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
> index 776ae6fa7f2d..6b2be065304f 100644
> --- a/arch/x86/kernel/sys_x86_64.c
> +++ b/arch/x86/kernel/sys_x86_64.c
> @@ -157,7 +157,8 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
>  	}
>  	if (filp) {
>  		info.align_mask = get_align_mask(filp);
> -		info.align_offset += get_align_bits();
> +		if (!is_file_hugepages(filp))
> +			info.align_offset += get_align_bits();
>  	}

Rather than special-casing hugetlb in two more places, could we just do:

	info.align_mask = get_align_mask(filp);
	info.align_offset += get_align_bits(filp);

and then pass filp through get_align_bits() to get_align_mask()? I think
that would end up masking the troublesome bits out of va_align.bits.

