Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F1BCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954DD8E002F; Tue,  2 Sep 2025 11:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905548E0002; Tue,  2 Sep 2025 11:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CCDD8E002F; Tue,  2 Sep 2025 11:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65ACD8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:50:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02FFF160256
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:50:57 +0000 (UTC)
X-FDA: 83844748596.28.C31839F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9500B20008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:50:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjxKiCRh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828255; a=rsa-sha256;
	cv=none;
	b=oIO2HUkzGtQJxNmJRAwyBenoFzQHJNPr5eN4ndGqOOsy1KCmJOFSpc8ZspaIh1tG6blsfn
	IDoBUaFS3DRamUpfxCmk/yfIxFQVpgCiv5SRErKWDPeKinW/FPSQyOymkC24ddQTTCjh12
	apmaGa60rIXMGgSD32XyswL2h/Nv7uo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjxKiCRh;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMZ6mf2tK9fBCnNSLx28XluD73iZYXs57OW1qCMR98w=;
	b=Qs4ihpRB0OnLb/kUUgR1CjVecf2Xx4mbU3fMW+mNzCiHTobfNbzos44n6rKjJn/SUJaYko
	YDMLxIkQXJcMMR6MzS3d2/deocMXm751ykJvJLNusFVucLOeNyMgFr6ib+3kNtfRIAjm8V
	x28Pq5FTVRD0W2xmMmewahOrsKFhXqQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756828255; x=1788364255;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FfmnYnGCJ6/alf7upk5HmPOgxuX1yazLL63I2ZgSwTA=;
  b=YjxKiCRhjO3TFC8H4hai0HMe/o3bsGdE1lrW2Bfi8nZoSIpq1DwPLYyb
   5cqm7PXVo8MS7uvfAwvL8AGWR0Q2uu/A4I5nZdAyuxE09/UNTv3ro1oWH
   Acc1cGIPH4tSlOXjy8vlW3/95br4J/Tn454qV0NQS/Cg2G+ifzYd/H+zf
   bAGSTD/DaodAGHM6wLprj7a2fPWEd+Q01Qy4foIsYgFE99MKl7cGvFBvv
   1KGGgOl0nI7Pe2izKH6uz/MYJ7lQN8D4ikQ04wAeiBcYfIBHKejugflPs
   lHkOifmXMIkEN1EeUL5rGqY97qcgXeZUtP0Wl/8NRr/q9O16JmuFs8B5S
   A==;
X-CSE-ConnectionGUID: yj+Emr4mSE2MAYlIk/m3nQ==
X-CSE-MsgGUID: ktAJO/llTBucSMDbu4IGdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="59177279"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="59177279"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:50:43 -0700
X-CSE-ConnectionGUID: uD1bbWkyTIKsNnH1ivrzQw==
X-CSE-MsgGUID: YS2ip/PNQlOxZwdxrd3WDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="171208827"
Received: from tslove-mobl4.amr.corp.intel.com (HELO [10.125.109.202]) ([10.125.109.202])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 08:50:43 -0700
Message-ID: <913a509d-d985-4520-a879-538a1198b946@intel.com>
Date: Tue, 2 Sep 2025 08:50:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Rik van Riel <riel@surriel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, bp@alien8.de,
 peterz@infradead.org, dave.hansen@linux.intel.com,
 zhengqi.arch@bytedance.com, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 jackmanb@google.com, jannh@google.com, mhklinux@outlook.com,
 andrew.cooper3@citrix.com, Manali.Shukla@amd.com, mingo@kernel.org,
 baolu.lu@intel.com, david.guckian@intel.com, damian.muszynski@intel.com
References: <20250226030129.530345-1-riel@surriel.com>
 <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9500B20008
X-Stat-Signature: 8x1mygzeqsud4ehrioe6xtodj6k4bbmg
X-HE-Tag: 1756828255-531685
X-HE-Meta: U2FsdGVkX18hBBap++09oG3Sad9X4DfOaZjo4wrYgMyOOQIqACWnQONyOHDaHs2wdUD/Al/qrf0e33LKpI2IUmrkI6VVNI7Rm8PCKpVNcYUDV4B7QAGY7RiFVVPNKQuezcmYwxBzYVonktLV67RTorAyEX7cCubP/v9veJKsPBjvudCXHOqgPnKhcQYpp75dqPS9Xl/Qruz5M3heXGw5PTBZz6NXZhds1eXP6/3Jv2sD9NBBN5L+BI3jfhxfb2V+vpaOPGOh6Mz4WPLuGThHdZDUbQoNFSFbXrYRYjq1hfbtRu7ILxKqJt6AwOy9cOFW6hQ7dJ5XpG4X4c7lHXrerXmXS40nQalcqeQNJzQ+lQfCPkxFRzLeCW8boix67oiVJD2x1f0kbyYT9nmJzD2Lu13oFOCuy71qhXMXhICyMo64oTFjtXYsvzfOv6/PNpdXtF6l2p3/evOei4LB2Dtu7VO0E6UlGKtjNuH4czaEWJzbRNCTtjfiAjtm7/BP54D2E9sccJBu7r28hTwEiVwQmBUqlw80T2dDeHLN90LFoPV0rLaJxy8hdsw29ByhQCTmP5lc3D4jkbjk/dQippGgNPjGZ50M7V9EgHAtMX/hFGb+TiF4xvdv6EX5N6dMP8HeLLPSNKe6fjtB8jNkYfEKbYHYwEMtsvDWj7cbbJNzlwEmvqwUb0Ksa0TcSuZ+zZJtOdBp4wh+gVxlFVYc7/m2jfm2N8fTNfBo5twvS0e37PBRD42mylawD+Me8WkWHwqrLKw7Pfa6pHZAP3Dk4YPTS7KCbRUYThm7NOYjbCAXgQ7aWSamlXuq/6jElWLl+deQ06Cv685EAjNGwW1ooa+LL4OieInyeATOSO3tVRflheNz1TT0QjXSt5bDLOo9cTPagwMrotiaFCJRtwSSbUFVv5xEC6UyOcncWQbV1iKq+CIaJEXxm4PQBSVszC/l08f+GiSa5O/zUxL+77EDx8v
 28NxnzyO
 VnB99RxLPZV07r/E3mA+9BjglRIZir4il8U3GfJhr5ieEJgj4a54u4VqyHtoxcTKZnicLjBJAxrbdPjbXKXjKgQbeWnUBlvfj9j/w9KrF/IP8tjL8VZ9++FfbbU2b1D6n5hT1OkR9kNTWFyT8mjRwF37wisjfpBZyBvjNGkYpz/FNZrydZ4YPZxMrup8qr2KhTjjjwnPU0oObK2ZXLNaMim8t1hU1bIBGbSe6f3OVuF25/Wi1LNcGbE2u6NmoDTch7qv1ZGP0ZuYMS2rTu3QM0lvyzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 08:44, Giovanni Cabiddu wrote:
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 39f80111e6f1..e66c7662c254 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -1459,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
>  
>  	put_flush_tlb_info();
>  	put_cpu();
> -	mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, end);
> +	mmu_notifier_arch_invalidate_secondary_tlbs(mm, info->start, info->end);
>  }

That does look like the right solution.

This is the downside of wrapping everything up in that 'info' struct;
it's not obvious that the canonical source of the start/end information
moved from those variables into the structure.

Rik, is that your read on it too?

In any case, Giovanni, do you want to send that as a "real" patch that
we can apply (changelog, SoB, Fixes, Cc:stable@, etc...)?

