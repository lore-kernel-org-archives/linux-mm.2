Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4147C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6CD6B0155; Mon, 13 Jul 2026 12:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F24D6B0157; Mon, 13 Jul 2026 12:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30CD26B0159; Mon, 13 Jul 2026 12:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C59696B0155
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:47:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E752D168C2B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:19:55 +0000 (UTC)
X-FDA: 84983962350.03.4954DB9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF969140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:19:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PF9aArZ/";
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ruA9X1M0IOATEuUflOypU9SWti9g9dyJLZAEJT6nBM=;
	b=qjIHgRcfukik+5vDgLVhjCV3e11z8bSWmdcA69yKZPCfQrW38fcIAM6mrUay0N1fMGc/qY
	HfVL1B+5Jxu0lP7B7Vr6ZtTw5LC+3/IVZ/FjlfvVSRsh7ALjIhJ9jJvDxHJKgTAIQ0Yzu1
	9O+QX+TKC4WJm4s8g8gDAdBOHyBYmqE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PF9aArZ/";
	spf=pass (imf26.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952393;
	b=yMeM0Wq4ZyEYAa2629vDmjj07i+aokKKqlpPwNnzRW0GAPAudEFjgFP6Ae3bJ8nxo9pLFT
	Ct3ILSL8qactv6K72eDx0N+bIedLN44e+yTL9UNpCf89yJbsPYAoCxJL4kluJTSzL3dh7e
	Np6eQ6jUUqTknpLNO70e1Ze4XQEfnsE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783952393; x=1815488393;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ACEEsriG9dCD5Makw171QvwlNnRaGMIWxBoV9AUffyw=;
  b=PF9aArZ/c7feJhtAJstOq0HyU1Eh9f6tZKO7S0mm6x5dLWcYF0lNR+E0
   BNbP8K8ydJ9gSaBQxeecnKFDEjQSss644QqDGTEnRNvwX4Sk3koehWBlH
   JU1zhR35973zIObXyrB8pjAUvZlBaXbq0siDgd/UEEFyBT4quzsJBZCl0
   tmhvDypxFVvvCnJ6o/ioaVz/x78PkQZmRKVRcTLQSFiLNZCfV9KG+G8aw
   uoSAOW2F8ei4vWezfLdYH37/Ir8qWBtd6VMoy1jur5Bj3IxVhUxzAg4wA
   2wv/7V2fuhIkj24pzvldV5mV66pGlG99sWoUv5QVKbt0MzYfo0t10QtyL
   Q==;
X-CSE-ConnectionGUID: m1U0qMpHTSO2bldGMmpx5Q==
X-CSE-MsgGUID: /+5rsfm3Q9erPShK7bbHkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="101986163"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="101986163"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 07:19:50 -0700
X-CSE-ConnectionGUID: Bhu909OcTi2Jw8FWWspLNQ==
X-CSE-MsgGUID: etPWERUSRBqiiOVfAtNJ+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="249209989"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.45]) ([10.125.108.45])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 07:19:47 -0700
Message-ID: <c3edfb13-08ec-419c-bc05-8f3f64186b24@intel.com>
Date: Mon, 13 Jul 2026 07:19:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org
Cc: david@kernel.org, linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-11-yeoreum.yun@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260713135614.1618183-11-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF969140009
X-Stat-Signature: r78x7xnqksy1ze4f16jojbppr7mbn5mp
X-HE-Tag: 1783952392-227298
X-HE-Meta: U2FsdGVkX18QobhchGg5AKsk9Fx59qvM5r/UXv7AlfXvBpScHx2bOYlvGCxPhvlvfvDXTLklvE6kHJ7ItRXbicPE98Yw8QbxYMxTNpWYXLedwZLtkLHB8Iyc6hXiwT1f+0SGeLRko0VFlGYjsfUrgfCTSoYzVBKPMlCCgjkXANxIsDUlMmH2mCnG4EP8BSDyrV7eceMIrtt2tg/Z/vyL5Ve+Em7nTuRRATwWi5kJ2B8m7CwAo7SwdJqWwvPgc1zpSlnyVmNYEplCt/4h3iQoBLaStVgmUdrwyOwtqH4zeWexnWETzWlHVwpdhg7oG4vvHVLml+1ADQCzNDOa4/Scx3XsEtF6pOD38a9zmUDNRXpEpaZehlERM/3ayYIq8IVBQ52pSamjqMmsJu7j/omBFEZJaEjqw9LyBGPf4pIwf71f+4PmaN7X63alYcClLV77d6duY9g78WYYqLPeBhscsujvCwwlokTnCapG4qJ6CSNlZxtjlbjGyjeedRjORz3mYnBUcBe6LVaBGsj3wfU2IfpxHy2xJLPY7rUf1PCsPubjU4kSIkmgJBehdzf0l5JZrZfYnifofXUCMmGbMqWIeX+2gWbyubbL7HTp5L0jxTQ1Yg7I15OcVxs3tX/X/HmNcFIQaKiIDyfl7vp3cPSSARH6B9cAiC8E7pSCovapDiAw3MArbbjGdKrVR2VOZsDSiWGEYaKiA2RlD+9cwtmQIfVVNS40BFWWbuQ/byjbgA4vuUnJA4MRfGNuyYHz/qS6wNtS6tZzdj3Qy6ixwQD9FSukqliCn2mT87m/xGOpi2QXc7oZhTjpddC1BAiCvgkuq4QH/5nZZnZb7Eh+B5Ew2Sh0oMyT/BDLN2gygDPmnt86dQiC8uRZX1PHIROoGHbyG+F9jDsWx/wVsbEXHlw4wBKiFGBVTJIkV9Cb8DKlA2it35gji0IwpVvsLutXZtGHniLwYFkuevxfX/+lDvF
 75Bl/0sb
 FCb4sYWvnmgvn5DFInSvRdlXyRUSj+SBuscQFR2bPNoZSbwEEN85cbOYpjHWrRpGoumsdYcqBXwnjNLeFbAkxAn8luashLt2ICvYR2FaIryw9o5pEUkyMkTumO5xcIAPynrSnex6sqiFSIbsm2ECkdhLOGSpByL2gOXDIn1btXx7r8zTlw3kXUx11kSd1HhTlCg3RlRb8r6t3FU4YaKQQvEM8SF4jSIE29TvW2vzPysskqaiDGbMVFDNBvRA1PqOu/Jep68Oz0kGcqBLNBcJcl2fyinmpFA1qdFhsd3GkMoycoRE/CFD7hBcI8zn1DkbUK8m2RpAQ4AuGrEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 06:55, Yeoreum Yun wrote:
> We want to change how pXdp_get() works with generic compile-time folded
> page tables. To prepare for that, rework effective_prot() to ignore any
> folded page tables entries, as it will unconditionally get called by
> ptdump core with pXd_val(pXdp_get()), and we really should be ignoring
> that value for folded entries.
> 
> For this, identify the first real page-table level and
> update effective_prot only when the current entry is not folded.

Nit: could you please clean up the "we's" and move over to imperative
voice for the series? We're picky about it on the x86 side, but I do
think it's generally a good preferred practice across the kernel.

Also I really do think this made the code worse. effective_prot() is a
pretty tidy function. This change more than doubles the size and is also
basically the same block copied and pasted twice.

Further, this does seem like it will stop filling out some of the
st->prot_levels[] entries. That seems like it might break things. It
definitely needs to be covered in the changelog.

So, in the end, I'm not 100% sure what this is doing. Is it "optimizing"
the ptdump code? Or is it preemptively fixing code that will soon be
throwing a compile error?

