Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A58F44869
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 13:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1266B008A; Fri, 10 Apr 2026 09:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350D46B0092; Fri, 10 Apr 2026 09:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241446B0095; Fri, 10 Apr 2026 09:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6446B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 09:46:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6DD81A0573
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:46:00 +0000 (UTC)
X-FDA: 84642769680.19.BFDE16C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf19.hostedemail.com (Postfix) with ESMTP id F1EDD1A0012
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:45:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YJ3HbNt9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775828758; a=rsa-sha256;
	cv=none;
	b=Px1k1MkfW8Do+9Lbq62hSJ85N119Hh+Lm/ADxwXcU6+aH9FqHGRJri9O79A3unNKOzo6dL
	SOPX8/OrH0RjPYDg0AcSo2Jiqh8YWQAvrQH09wsIuonkFB2ax6aEgqhVTzseuVmaUl5j43
	19jAZT9HFde5wuwRRZsUEkJQfwznM7g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YJ3HbNt9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775828758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UO23niezElZIPksvH1GF8l70Cs5yLVefVLzmUuVpdSQ=;
	b=rKv7lkheP7IHc7D012lms66Z8HnADrSUu41PVp45CKgdk+IXhO9h/eMnYckQv2edF3N2jp
	XxLeAUzuhcPrls6VhdgI3qMsv9rAKLZmyK2p0D+pgMH40PiBhb1Ma4Ej3q18A8moaLMs0C
	9fUab+Ej0K/7w7FWUJlvjyrW/GdM5wM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775828758; x=1807364758;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XhwVNk7AmxnQFYYbofWW0xn2GGcCMLifpnTZm0hI0iw=;
  b=YJ3HbNt9KqVB6c72n0p3I8tV+eLDZ8Pyvh5wkY5xQ80nLKZnDJVlBLVF
   /hWAQZuWIDsV0WzZ3NafaV6PbRU1gbqE03bRNkaV148sKfbtEAW/igX0F
   p3HosWplFkRdknQELLo40Q+VWWm6s0SkUOr9cB6gj0v7QrMlkl8j1EP6B
   QEPe32p1VrBic6WVONIBTy+AhKGOcgJLSEVoXNFsHqpkeFVJRhKHh4Gpb
   EprtxrG4CNlyH98+XlztwbJRkUni6GBzIuFoWPlIOvUPOQzONN1aV4owx
   gK5Jt8h5EaRkh/0/onvfP49+HmHEo3oJPFp2j6q9ni6hd9s9zFXoDX4P+
   Q==;
X-CSE-ConnectionGUID: PzVJnPurRW2osMOCVF6Szg==
X-CSE-MsgGUID: gC8uw58WSI2ScTE/nr/U8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="88229177"
X-IronPort-AV: E=Sophos;i="6.23,171,1770624000"; 
   d="scan'208";a="88229177"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 06:45:56 -0700
X-CSE-ConnectionGUID: 5EGNTPxSQP+GmiqHTb7hcA==
X-CSE-MsgGUID: poU0WXXBR3aVBOf3UOJDiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,171,1770624000"; 
   d="scan'208";a="225932507"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.248.249]) ([10.124.248.249])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 06:45:46 -0700
Message-ID: <9db9515b-08e8-47bd-aced-206ac183195a@linux.intel.com>
Date: Fri, 10 Apr 2026 21:45:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, x86@kernel.org, iommu@lists.linux.dev,
 Arnd Bergmann <arnd@arndb.de>, Michael Grzeschik
 <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: Re: [patch 09/38] iommu/vt-d: Use sched_clock() instead of
 get_cycles()
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.187521447@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20260410120318.187521447@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ik8efro7gyj779rtwt87b5zeywqoodrg
X-Rspamd-Queue-Id: F1EDD1A0012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775828757-855964
X-HE-Meta: U2FsdGVkX18U1Y8nSltDwRK0fhFEOMEvIRFy2qPpR0vl0a0dw4BS8d0hkKEsmPOgFlkZkmlVvYWZ2lheH7r85C/ZFV/7kcyt9ioyMenZK7DEIOGphy68SYk5XOMl800RuAYXYwD4LvubMxPT7gQr6OgzEvqojJsWdt8/g0W00iL149x1l4TBaqBaiVDuvTsc0xnfs18n6otj3NsBMI/XEpvGlLAl9xMGXE5eo8XrpGzH0S9RUAgeYflFE8sYkEa7aAGAZoP81bxCEoUufI3AajXoGuouDECJOPxkfRdglmKzZH8gPvfLeAr0agfVrm7F6OqOxCV7tpt86FZHha4GVWnd2HBMMMQOq/WedgRJDi3EPFW0Y7VbaLDigovO4g4nc+9PcVT7z9XzBXO3MZXJlZ3knFBq/S1Cs/Ew0MMOJ67ORH18yoqKBOxtcnyXHzXsjI1c9bJj9Q5uucuJDOJXCaJQq3FCMCI2eKew0d47iJ6gnOayDig8T9lYirX/G+xQmEjDc73bJ32TN8JtWhfU4C6Yz3D5JMs+Qu86jTB3X+ZQL3NIpDGkKpM6h08ll29V6XY1zZ8VGavJHOLTuZ2gae30N8p7utaSJ/1ZqH6PuK6MAjYJer4JrTgp30Tg0cpOyr9AjP+0WznE0I9gQ/H6F2d96+8forMOITgGa4SeILQlcUb8f7EDsavpGiToLUECc9FazsgyI3LQTIKfsgvTU8+ou3NQwmGWDSFGAWJM8SOZLiq7CBLxByyjrsBQcKQHR3kzHeWJRxvIm/un9Q82orEOZHfH/bTlY+Vj9V8x2I/h4z43fyfPMSN/FOUnV4PezqkhuxukdvC+pcIHekrojwDFhW09ipW4Z327whbKrMAFl4xvWmYFVAEeatAFM+D/aqpF8cIogI6P1PH+6/qUltpAir4hnukKZrwnPcxvt6kNA6jecBvw20aRGrpCzh0R6O2CAP3QAOLc58M8lWR
 DrDQVSjf
 gH0Zfx8wzBYMQON1P2JC7G+xpg/AKdguNbkG/JhnNjB74OJek9nDsu+InY4O8qrrUcVgdI7G1+ZOrxBmfRTqnixipLRCXGPG/gwlUAH6RBZV1v8RTobzcyD/6rGNJPNQHVDnLM3JvCHIBE5Q4M8/2rfridADIbfRgtiVH8lk4q1ImIfJSGNME7s8+Y7Lh/AGX3WvZjULHr4VyZSoSBSdnCEtLxumkEEAsheKzT4ksMjTUWC1XzOr0yOvn/ZXppR2Jh2G7lV9iWKHstMxCyETL0iyYpcuGY73m10RXDHC6TGuyIMkKlq2SEaQiGqXqu2XOyllGdRVW0P4LMFxEQLHzAaT8xDf/62xl/D+lPzZEidKEs/SZXaXp5/KlfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/2026 8:19 PM, Thomas Gleixner wrote:
> Calculating the timeout from get_cycles() is a historical leftover without
> any functional requirement.
> 
> Use ktime_get() instead.

The subject line says "Use sched_clock() ...", but the implementation
actually uses ktime_get(). Is it a typo or anything I misunderstood?

Other parts look good to me,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

> 
> Signed-off-by: Thomas Gleixner<tglx@kernel.org>
> Cc:x86@kernel.org
> Cc: Lu Baolu<baolu.lu@linux.intel.com>
> Cc:iommu@lists.linux.dev
> ---
>   arch/x86/include/asm/iommu.h |    3 ---
>   drivers/iommu/intel/dmar.c   |    4 ++--
>   drivers/iommu/intel/iommu.h  |    8 ++++++--
>   3 files changed, 8 insertions(+), 7 deletions(-)

Thanks,
baolu

