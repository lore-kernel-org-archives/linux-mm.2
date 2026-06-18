Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB904CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 18:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986716B0088; Thu, 18 Jun 2026 14:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9103C6B008A; Thu, 18 Jun 2026 14:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1596B008C; Thu, 18 Jun 2026 14:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3830B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:12:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1E79140211
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:12:15 +0000 (UTC)
X-FDA: 84893827830.07.2E1AFEA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7EA9140009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:12:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W5kNu4Zf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781806333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDVcyVUKLHNCDWusBXm2IInv3Q6pRTNx5v2NHMa+boE=;
	b=W7ZlO1cVISKyawOaMCc+mjGV18Fbu/maIoIhsi0sGYmeC7yW+W6n2sTLeCxlRaACpvKwf7
	uxxV6r7OhUB0gUR0r4j2uUk99F3ziHmVx0JODBXTsyG6TRCvxfkYqtrWXdtctip3dOKoax
	Iw+0Q9T06hzf4qwBhNHcr7c6J4pK6lA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781806333;
	b=6gXJymZauG1iziHCevIFKA8Z87z1jNRTgDQ+wumGQ6r0iaBsxt4X/epqrLUDG5Bn3Knzzk
	B6cUK556Jhvco+EDJ5epJbOSHYLFBcr7aHp8Tkc3KFsC3PYV8jswhhYkXY+G7AVbmuuLJ6
	Dnth0mSQlkYdCatHS8N1lC/Ygj2oXN0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W5kNu4Zf;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781806333; x=1813342333;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KiOrftyVXSm2xYANpVQq31qn6xeMhRpGmJFyi1EtirQ=;
  b=W5kNu4Zf0SUDpYMfhdX6S4IaBhgjuZO2pZGZSDwje+TTzxjtluLlVk/d
   WFlAYe0nQp9D1Ce6Fpa5rJm60Yh9BfKJsHHgosdi7NHnhXI0BGSSmBmcu
   d8yMWN7x2fy5e1P447yindgK+p8FNLpzXj/y9C5irne0gUrdTF5AL0Dxk
   ldZsO4rUeMXtBVmxfkPQ0Qwk2PqiN/h2D3vq63MlISlDutn2C7L5suWWl
   ZIrynZTalJIMXWF0e447+EBC/aQptSjT5LlP9ssPmLLdzVl8aUys1j3UJ
   m4UxXeZcG2eIFE8LcpvAwemaS66UvMKTOG8/kAYQP6xDaOQxDosOmqYly
   A==;
X-CSE-ConnectionGUID: SrWxsRB7QDmZQOydhcWrYQ==
X-CSE-MsgGUID: /JDryhGATCizx8z770VPkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="93301994"
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="93301994"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 11:12:11 -0700
X-CSE-ConnectionGUID: EEHx02poQu2Do1OLp+UeRQ==
X-CSE-MsgGUID: 8x0vdmXVRXmypy68vhLGgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="272130460"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.222]) ([10.125.111.222])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 11:12:10 -0700
Message-ID: <3207a706-354c-4e9d-ba53-dded1abb1842@intel.com>
Date: Thu, 18 Jun 2026 11:12:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Borislav Petkov <bp@alien8.de>, Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrey Konovalov <andreyknvl@gmail.com>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
 <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C7EA9140009
X-Stat-Signature: gmibbt1ou4k31zfmpmqtiy7r8jh1494z
X-HE-Tag: 1781806332-588417
X-HE-Meta: U2FsdGVkX1/h9IORkkCYgbxAMmO2kdwHN5Q6Msye+8BsuxZqT3mvCmt06cHEuaNgDO5Xq/yc1D96+Xkm/kz+85vtyBerl+k4+ALYKmfzZ8nFKI9sShZjfyDXKf6kB78kHWdHfnz97Gn3ZhaAKf4oV+d8XjdeWPdUinTYocaHhEmvsY0Ayh8acUDas7XWlXasQWJLVcqVI1xkuCQrrnQI0HD+B6cyU/uRlk1NBj0/fz+leacAWFyHzzKVBWYzCmHO0rht83X/5193kN4JB6VL+FHWQtEuXOprRFPB0N4JG61m3o9IwN7c7f5tAqyNK4WKE3J3skmDscmNGhJkkiZ/Fq2fA4oN6dcCjxo371aqBb+y60F47o+WiE1ZPR3Ypko3BlyH1mTubB7J3JI6bkjrH1flO0W8StBjsnoDI1fs+AYhb+YVpkAkDrAunEj1s67MJ04yxHVGuBP1Tnjd25H4WqSyuSrEPQe2uGICCS+6UWi9X+Fg6ud8DI4dGW/SaHY3fCza8gZbKi29byxGaVRRota2y6aYpgRx8y3qEbN2RsFu3A5wHqqAgE5qqafvEcG9xkTkp5jIxDlPLeupUAW+AHyHcWkUJNcGG9RbbbIFtcpH+YO5v6bxmRthK4AzWlNxpKx6rTDBYQtSiWhpoR/hZge/6YObxYHwgU7LrhcVm+kJ3uBeHz17nObUpaJsnpfeJzD8Jk1aQ8DE6Dm5ld/NBrn/popiOMkv/p6IhSix3rjuTX9AAfhCNcIPVt7+/D2sD1PS8lK9ZeskpvfOa8kPxtW7FWMOJeQWBGGL4Q9Gr4COqwvDFAd7PltFG2oTvTPj87EUFWvDCWPbQDljqSevc3+6VIDtI5J0Z+Zx2d1sC7mNi91xoRxaf9jKgtFZzXAny9do/7SSlE44IJ4Bk5ezyL7V6bqctaYAkXt+JDfREq41zhdLzHrG5DfNmF0Zuel/JvAIuQkjBRQAjjNR/tF
 vsXMaSqh
 PURTOjrfVew6wiuFT8aFplYRArFFet8uZIhfiUjCoS4oZGQMnvEjkO6EpDxurnqSrlHsPcpnwWFseJ7JXwRZUxAy32XRE1T8qCN0SeYczQ/y6RNQXD7WWNgaIoBUGw+06pd8UBnbN39yXuxYedeO2e8kRpEuIHSP0I2RWvaRwya6l+pHR+h7nUqsdgUgLTnzkP0Pw6fkqHG7Mjklcoe7wl2Mpa4hi6sGd0+KigRvwSm17PrfHeCQN2zEEPvtFR8wtMYCZRa/dbmTGFgxfwHskNQUoU4CiAo1kWjp3H2GWpxMRWUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:09, Borislav Petkov wrote:
> On Wed, Jun 17, 2026 at 03:13:33PM -0700, Ihor Solodrai wrote:
>> So my question to maintainers is what approach seems best?
> The CPUID stuff is being rewritten currently and it should address your issue
> too. If not, then we need to rewrite it better.
> 
> Can you reproduce with this set applied ontop:
> 
> https://lore.kernel.org/r/20260528153923.403473-1-darwi@linutronix.de

Thinking about this a bit more... If Ahmed's series does fix this, I
think it will be accidental. It still uses identify_cpu() and also does
a memset() of the new c->cpuid structure in addition to the old
c->x86_capability structure.

I'm not knocking Ahmed's series by any means. It just probably won't fix
this issue.

In a perfect world early_identify_cpu() and identify_cpu() would either
get consolidated into one thing. Or at least become two discrete things
that initialize two completely disjoint sets of data. That way,
identify_cpu() wouldn't memset() anything.

Isn't that the _real_ fix? Instead of trying to hide the inconsistency
when good data is blown away, we stop blowing it away in the first place?



