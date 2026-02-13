Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C626EDF17C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446E06B0088; Fri, 13 Feb 2026 11:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4986B008A; Fri, 13 Feb 2026 11:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC696B008C; Fri, 13 Feb 2026 11:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBEF6B0088
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:02:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCD61160520
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:02:00 +0000 (UTC)
X-FDA: 84439899600.28.0CBC3E9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf07.hostedemail.com (Postfix) with ESMTP id F01D540014
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:01:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MNstpS/d";
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770998518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZqbdKQI/KtjdYPE9fJgSlb7skvesgNuLEwXssbm3Uc=;
	b=Unk3KOlNvAmanXyiBuxGR+EBDJsnmFK361Xq/Rt1ZOfczZ48iNw19nhQ1LyobAour7sgaF
	vWOfjsvYQ+j+S9SklBk8BL5quihEK5/6ZZdG8oJD1zbgl5CakPmi/uBqV52ZbNNHNKbK8f
	I16joieHm1rkkA/6uuoK1dv8/gyFLT8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="MNstpS/d";
	spf=pass (imf07.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770998518; a=rsa-sha256;
	cv=none;
	b=mzkgX3w181tytZkOULlUOwFOU24O3OvobnkbVjTsvvipFwOg+MSdg/VGU6EndjIvTz+hHW
	k8tFKPwbu67UaY51AYn2bRcq8IhOxfx3LJbUVhDakMaK6QJv8md2fTebYWzYukFPKKkP1Z
	h7A/GY3RAZQy7voXcmBpv0cjVEVaGhw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770998518; x=1802534518;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sk9KjvK2uwH5Wy2OuNRzOTXNoNKxB6910nddhuFsdno=;
  b=MNstpS/dkzoYpz4Fjc8CByppZ+Qx9x0s2BYA8edBQ+9KSHn3+SlTXSet
   B6Pa6MVMxhyJiSvg4AvaeQFPC/m92R3nJrCLUD7cCw4iS27GtrLFq+iBE
   RkdDjbCuNK10ihHHlrwBKStln390rAkO2ra4P5py4gkXoT1VJ+Zm2aRm4
   4gB6uD+fdjgOwMaYv/UzP9YKb+2jtFIRrVmXbbfCcGZoryRrKHgIT+OsC
   NZp23gvMwfyyss+0rtiTSvxkcNVE9PTkv/w28s6U1u4q6tnqW0/Kulqaq
   W6WLahEXYZG62B1H/0cBCeKJSkRSkVlvS3xM8JlRFfYPveP5uXS5TkN2y
   g==;
X-CSE-ConnectionGUID: tSoQ60UeRF6SP8VPk3zdzg==
X-CSE-MsgGUID: QSXrQ+v7ToaqMK1qU67OeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="89772869"
X-IronPort-AV: E=Sophos;i="6.21,288,1763452800"; 
   d="scan'208";a="89772869"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 08:01:56 -0800
X-CSE-ConnectionGUID: pkBQ7NgqTKigdLSSyhEyeg==
X-CSE-MsgGUID: 0Tqpd+JwQy+JBoIm9IsUUw==
X-ExtLoop1: 1
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO [10.125.109.3]) ([10.125.109.3])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 08:01:56 -0800
Message-ID: <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
Date: Fri, 13 Feb 2026 08:01:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260213154838.46567-2-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F01D540014
X-Stat-Signature: ffahy3h39gjaxaxr1q8snp8sy617rhfi
X-Rspam-User: 
X-HE-Tag: 1770998517-397919
X-HE-Meta: U2FsdGVkX18PXyJ1QEqxAJ15YHU54Vf+a1I5ntiKmqQ3Ln+VPNnevri/gnaML/RvOxfZiO7E/K3Nqwiyx97Tpir0J770tbHTBhdeyOdyMkq+aauF/zkLaKhCl9Ty2Yfo2fjlFo4iAz8Q94ZvT+jYU8FrX7u43lpstqhhch++s2fauTt5SJptCDnA4nWrhMw148wl412BZZ5Cu0bayLJ3XZdnJRzH9eIn+dnUyDuPD7Tuy/jYqngKU9j3SOlzdjLlVT/mRM7xRP5CgI1r7efDNHE5JT3ZBFeokEzLkCSRccmpb8qMtr0mnKftuwbE5lbMrwEEayo2yCYSKMGtaL6BOHuhoEbQ+pGxEfAATwMNhN+L9fOA698XKOsseQAkbA2+1Xumx5YysADiDyue4Dqjdvk4EtWK2xHN1IiQS3T/6MESnqi1Wcm80Oes6QOQ+hOLE/0qH4R7TBXdzArLEuuO2ET+47l2YyKjtr095sqwzXBwg9RdBXLErqQ6/u8k9tRpwU5q0Uq5x8yj3h6TDE29m0tyU9ePUDjVL8o6eX3kbUSKYe9Mq21JukKsOPsZlfcjBrSL1Ugs+Zvp7o/ZS/aHiqjkzU2XcfgU7S9pyISr0SoMK3EGuEKhkE1U206MJ75q75sjyOLpkTCXEFr+95EDyL0PbiVJguh9WTN3bDtGBqfCSVnlQtgXqOCgtnLpxxHO/Hg0jPiQ7P8DcqcbXdqrJSmJZ4BTtvbwetM/A/aoG+qwEgpEXYpi6SH9fAnl4sS4+eGMDthI//tJvyksXN5RmndPuhPYIDa1VK9Zom7kmgq+hglGe4s9lyr0cV9jz12A7TQCkgge3sQ7/x7Ei8Y+kKpKnr/PwxBNTAQqDD65iNcsCOkSN6OpNH0r5h5CBUxD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 07:48, Kiryl Shutsemau (Meta) wrote:
>  static __init void reserve_unaccepted(struct efi_unaccepted_memory *unaccepted)
>  {
> -	phys_addr_t start, size;
> +	phys_addr_t start, end;
>  
>  	start = PAGE_ALIGN_DOWN(efi.unaccepted);

Why are we even aligning the start? Isn't *that* the bug?

The memblock code seems to be able to handle arbitrary alignment just fine.

