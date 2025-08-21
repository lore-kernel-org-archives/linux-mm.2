Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB313CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEA58E0019; Thu, 21 Aug 2025 13:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0AF8E0001; Thu, 21 Aug 2025 13:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066D68E0019; Thu, 21 Aug 2025 13:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E50A08E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:36:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95B61160460
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:36:18 +0000 (UTC)
X-FDA: 83801468436.01.75357B7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 37C021C000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:36:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i1YyGxeG;
	spf=temperror (imf20.hostedemail.com: error in processing during lookup of dave.hansen@intel.com: DNS error) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755797776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ID/S8iMYUxm4VmRcnBgbiaGLo3XtZraX3BW0f/5ajw=;
	b=4Y9E0OYAt0hL62t9dpH170LYZrdoe+2MJYFSM43cUVOElBp0GZT7UjCuLLBoEQfw+/wvxH
	bL9VqHAS3uUMM2sGxpsRbM3WFvVn7+GEL1ahhNjJiJ8+Gm1rlXdUMT4f0GTA0YKjBswPGl
	Od/HKCuEA3UKTHTDZdAh48tg2bLvyGg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=i1YyGxeG;
	spf=temperror (imf20.hostedemail.com: error in processing during lookup of dave.hansen@intel.com: DNS error) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755797776; a=rsa-sha256;
	cv=none;
	b=fXE9hQPHl0vwqAXdg4fasiPvSZ5JjMOcyONMAeF+BKf7nDXk5payY4rkH/jJc+jQRzsVOb
	pnC7/941FeGm3iBMni3CHDZal5EyNvR2G3eUpVFLvWMGqYpRvu7eXgzkwfCPzGvTcEENlO
	QLG2fxqIkbHrvpw58XDOdlUP80xwEgE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755797776; x=1787333776;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vmPUkwIY7xTJbegwgmYK1BrARx4bDlGC/nSbHP79/+M=;
  b=i1YyGxeG9ZfO2jAW/JDfYJjU6wsBObgPW1L3Uj91yp0tRCs2napSPti/
   lKX0p0Q8PjQPSweSd9FRqYHw0bcsg6Z/l6O8rnC2prhFFEwmLllPUbUZy
   ikcaK0wNcTLcM2OIT8kUl92sJOENenKZdZJAyJnM2DKi/kt8qlNSGq4fH
   QjfKkD0hGfXZzaJbd3Qpk2VFXog7FfXg0ktxYNGGJ3BKXC1VTJQOrZkyX
   CtuSN/NKnz+kBjYrg4Ui1f+vpwzgdM+Kkt6Fna//tjYDytbwy/0ErstQF
   Kkw0rUyVbhqR9/6u1X37+oQRfqnsNv0K/QxTsMizypTufD+nbhIgUsP/n
   g==;
X-CSE-ConnectionGUID: /WeEofbgRGm+LrYhRJNrjQ==
X-CSE-MsgGUID: ygAIPbAgTNmiuD6yYeV1DA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="68697586"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="68697586"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 10:36:14 -0700
X-CSE-ConnectionGUID: OeJWtaQ9Sf2wv3oMHTrZHw==
X-CSE-MsgGUID: 3zh/WxAMSy6zdBECMmBLcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="167700499"
Received: from puneetse-mobl.amr.corp.intel.com (HELO [10.125.108.119]) ([10.125.108.119])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 10:36:14 -0700
Message-ID: <3976ef5d-a959-408a-b538-7feba1f0ab7a@intel.com>
Date: Thu, 21 Aug 2025 10:36:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix KASAN build error due to p*d_populate_kernel()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, andreyknvl@gmail.com,
 aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 ardb@kernel.org, arnd@arndb.de, bp@alien8.de, cl@gentwo.org,
 dave.hansen@linux.intel.com, david@redhat.com, dennis@kernel.org,
 dev.jain@arm.com, dvyukov@google.com, glider@google.com,
 gwan-gyeong.mun@intel.com, hpa@zyccr.com, jane.chu@oracle.com,
 jgross@suse.de, jhubbard@nvidia.com, joao.m.martins@oracle.com,
 joro@8bytes.org, kas@kernel.org, kevin.brodsky@arm.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 maobibo@loongson.cn, mhocko@suse.com, mingo@redhat.com, osalvador@suse.de,
 peterx@redhat.com, peterz@infradead.org, rppt@kernel.org,
 ryabinin.a.a@gmail.com, ryan.roberts@arm.com, stable@vger.kernel.org,
 surenb@google.com, tglx@linutronix.de, thuth@redhat.com, tj@kernel.org,
 urezki@gmail.com, vbabka@suse.cz, vincenzo.frascino@arm.com, x86@kernel.org,
 zhengqi.arch@bytedance.com
References: <20250821093542.37844-1-harry.yoo@oracle.com>
 <20250821115731.137284-1-harry.yoo@oracle.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250821115731.137284-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jaypbaig15afi56k5okppztepnocwj8h
X-Rspam-User: 
X-Rspamd-Queue-Id: 37C021C000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1755797776-382039
X-HE-Meta: U2FsdGVkX1+UIxSsBpMFSWqq4vw31c/5ls4BHXFO8HojmZ30qa7J9+FxqILOdpi5cv1kP+/IvD27rI8OTrnhKHVW2Hjf9dW1Dbe8p2BDEzdoprlxKWNj6IEHWma6PyO9zMJRArlyxsFpd35U0lA9P+BkYeui7wKy2fjDY0GUpXa0PxY+6IkRxoaMEivZ2tiV5+93oPyBYpveAkAPvSAGfM8GsH77fOi/raxD/PUnwsrQ3bMe1PXg3ZbUaUcI7nbpUIB+Nezat9fCGOl8CHWK5PbEkap4R2dXps30+bOUKoi+Pxb6BrgHwDnO7IpENfaiPMKmveo1tUIlHI4Q7TEGs/Ups+5wA16ucON+AqboYrs+2/rZj1My5SXmk/mk2L+fiJ9sjmKxEz0xEd2MPKk8tfKLkFvVqDZuKqFN8/bOM9be5A1+ixkz+YopnzbZIM0kaATzYkvMjbeo8qQFKIJmmnsKQj7Mz5dXO1X/4ccCpRaNLVyy6Iw1qTGN2PBPQA3vj2S+RKF+Quks5gHyfiYrFvouUTI9hV1tFh8aSvRSdqN9PNBoHgMqiC2Dg8tunT2FLsQBcu6KJtVWTvF9XbqBJUPkeJRMF2YyotgZhb6o8zh7mNEGGjlnegh3IgXfrVZgeNAvY63qY3zzXfit7TNO8bi/9+upLItMi6npCCA/QAz5/gMXwIG6t4+ASbMzkqS5LqdlA8FdQGARq7Tlj2RntABq2p+bbal4pHPSpG/+li6eYY634gV9DkwmCzbjqHH/rrKGfqJ3abBp6eIzdbFCyeE1fwivMSWM52YhyooQqFUCyL5af4/bEGcNhztWHIUyHjIMtril3aNYh5LFy0W5IIayQL80sQhXFQgiUwHnMmxIUDQS+0Wntt0zduIoLDtt/hBn4GUudLv6yQ8jSbDhvm0x6NzD4pty8+eRBhvHXRWGvPO7qnKZaP+1KkwmrXHQ2bQcI+fv0/rjSfpN1y0
 RytjcltB
 PovbiVjwNppsEb0ZhVBDgBHolS7267SfCfJfiixTE0K/WQrwAp4L2g/NV5oWcMg7MCJFnH7qRDJCxyWNTomRF7I4njj5NuDL40TrcOlHMHzaXdfI03NvnAiQVc7CUFh4IcbszRuc1d2blQpcIZa6BzWTuJcZJMjVnCTRXb7tqTBzkMzI3WWCmzXF4eHUdgSlDOAoLrFux8sL9irhr6ExebBB36CD+kyWMJWPlLh3dTpv5EvRD89UYVAmkXEU0AuZJifOkKuGjZVk1PKWrAC3D+5I65cyFxgw1mNzospE1ujEs32HexlC6Mv2aBWk2rUFXJA1Q63ePND69x0aWhK8fzblYphR+b8ZYVVW1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/25 04:57, Harry Yoo wrote:
> However, {pgd,p4d}_populate_kernel() is defined as a function regardless
> of the number of page table levels, so the compiler may not optimize
> them away. In this case, the following linker error occurs:

This part of the changelog confused me. I think it's focusing on the
wrong thing.

The code that's triggering this is literally:

>                         pgd_populate(&init_mm, pgd,
>                                         lm_alias(kasan_early_shadow_p4d));

It sure _looks_ like it's unconditionally referencing the
'kasan_early_shadow_p4d' symbol. I think it's wrong to hide that with
macro magic and just assume that the macros won't reference it.

If a symbol isn't being defined, it shouldn't be referenced in C code.:q

The right way to do it is to have an #ifdef in a header that avoids
compiling in the reference to the symbol.

But just changing the 'static inline' to a #define seems like a fragile
hack to me.

