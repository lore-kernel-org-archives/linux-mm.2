Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DB0C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7326A6B009D; Wed, 22 Jul 2026 12:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709B76B009F; Wed, 22 Jul 2026 12:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9C66B00BD; Wed, 22 Jul 2026 12:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACA16B009D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:40:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABE3C12012F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:40:11 +0000 (UTC)
X-FDA: 85016975022.13.4F3834D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5AD521A000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:40:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vv5S7BrF;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784738409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/98dYKgaEjXUHmhDXcXS0PG8tx66UbdoKo0v/OS5kvQ=;
	b=xMwTuVqQWXcM/1+uAkFp/1wr/d7gtpOO8E3YJnh/fNm4tho0+8fXzkkuBpQisn2cpYBsCr
	WWsyiys6tJqA9Soyn15laYmAL8OZm4Patilm8eF+Dvp78BkzMlUuVzyrYk8AiFhDHHgBFU
	RmUDH+c9ilPRqzpNqX+rqphr1GK3/R0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784738409;
	b=L42DVVpkzUG4kmSuwBSH+xJIOMfwkCgdonqDFu6PAGaAs/8DuJC9DQ3nTxg7mMJ80vgUEI
	Q1y2dp42vYM51JXzTtoXG5ybZPLPJMgdlI0D6m8wYqZ21hmBalr3VFNSaDpno6uE7F4ZzV
	nuYVVPWPAt5E32P99XD4dqQMJ0KUghE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vv5S7BrF;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784738408; x=1816274408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/98dYKgaEjXUHmhDXcXS0PG8tx66UbdoKo0v/OS5kvQ=;
  b=Vv5S7BrFIDgLFPf0tcA96awLE39afIFb6LQTTPUfX30uwxJKjGmGrdU/
   /n6MLpj47YsKQekx32XLW9lKLbYn2CWpN1oAzVA185RvVGkxmXDESP04h
   5hl5uNzQKDV8GPoUhPxwdRKgtFvWX5xUOUshcxfmkCaEUPwdmIlqJ4Nke
   1wcHQiZjJo/KtK34O26I3LK04dj+lSZaRknuApB3Q1sX74ul675IYNP2g
   IXQSbMs+cn3KkXZXSwRb7GcAYI+WPNZMq4ZTZHNTzS3BGpt5u8J0kFgoU
   lXYfulU5ZacjXihfwySVN1ciE0gHMlS1FW0hXmZCxJaiHrin1JxgBhT7+
   w==;
X-CSE-ConnectionGUID: YfWVrm1ZTpKLW465Ar0Yrg==
X-CSE-MsgGUID: l+TS88+sTpqInYZr4dIdmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85499630"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="85499630"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 09:40:07 -0700
X-CSE-ConnectionGUID: QDZCp4urSb2T9DOMvZJ/wQ==
X-CSE-MsgGUID: b4+1UeHkQWiP7OyD9JmXeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="253773856"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.58]) ([10.125.110.58])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 09:40:04 -0700
Message-ID: <0143b927-08c5-4e94-ae6e-2a0d7bfe950f@intel.com>
Date: Wed, 22 Jul 2026 09:40:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/20] mm: optimize unnecessary loads due to
 ptep_get() and friends out
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-openrisc@vger.kernel.org
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q91dca43gfx3ei4rad17ajyrnneeohjc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AD521A000B
X-HE-Tag: 1784738408-827871
X-HE-Meta: U2FsdGVkX189H4ITaItOR/ep9K2xb51ORRlV/pwVfIGk76FyhHISEiOQuP53t8Y3L5pAKeXNnNWyBFPRsGy1B1UgP0sqW3HbnNPsWgT5oq4gGu+NMA/w7d7vjh8062x3J/cupPA4y5MjBhEngm46UjXSHV+SubUx7qUA7W7ML2VsMrDS/i6SCKg6TNG2JN/5FtjvN23/GNyzyrHzYOqzDjzAXaKmcGI31AaIjfDfLetPGwOhkdeHyg2fEP+2YgpBKGV5ZdsIb15hCDbAn7vVFZfaIFnLdb5g7ZmcE5QoYZO9nwJS46tyU6wK6D7aPf50+kPvHP5A7Rdz9aZym+bp3lRTlIKXDARXZBhjW3GzE/Vp8g9VRYRupHWkZPcp9lHL8I2RKobNW6HSHyB3i3Wnqz6GT+NjzVHGFV5ljXtNaDQ25ARimeswVUqUr0Fv1vO6Xal+mQPKEdBWRHlrmCxdjFHWDp8rWv6HH+XKBfTq87Bp9XCux90Y6L/l3czy/XFa9vptohSjc+0oDgjuQQy7w5Xi8EHfoAEm6bC9MkPhcUYXLEpt1ZwGn7YRUam2CUmnJek934ub8H+VM8DsvX1CuUccwj2YYo5aCquF8EVEfhNeLCWFbPS9IizRwJPeoOacqcIolSPO7aPnaFm9jd11e58var74duUBkL7ahCbIsr2sC8kg8n7fZA8I8MGQGkEX8Cfbac5/iLGO5ZLDjnIU+LiEuEN7XJAjIdKYnFrOncsWbPk5IjrOQsdtAs2s5rFyqBtHUUh1HZ0/5VIp0W6zSJhmtBZTACp688PhYv+QxgORXxpGrNVSc2Lz2zavkdFZDixH9waiTGYXwZykDwgJ/nh1HMse+C/rqHnDmsSQKWqzPQiitXAXzSckTXiWsjEhUiGvtDQ75nRCQwZJiw86yliqoXaeuG+E1fGZslHbTrgUah6w64fmMzvpRLCK9Mpjnnyb3DmA2y+uCpMlPe5
 i8Z2FHN8
 hyhzf7a3nvUMYiKq2g2mxAysSmh4Zj9BgUGPVYNnTw3deM4gZonr+CFX1i48I5QjgAEO7S++dOb4EKm3pLkfQijIpNfdgWvAJmaRYgfWa0CwstAUuaE5UeSAV5eIcd+FqD0su1QYNPBKaXjH1lFoYVUgkk88ivFqnPZFWZdMAVc9sfbDt+MwIEE65zzp4L073+TzWp770Y+XpLxN6xlNkhxcmninih5igmmzz0smCDx61M1gHnYakejwtu2P7NUVsvkHw4BHL9jgR1PKOIWJjAPWnf8eEOS5S8or6bcEQn/dDIDutgt2YvrFIOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One of my nits about v1 was that it didn't really frame the series
precisely. It talks about "optimization" instead of fundamentally
changing the way that the kernel deals with folded page table levels.

The optimization that this *wants* to talk about kinda falls out of that
refactoring. It's not really the core of the series, IMNHO.

This series effectively changes the rules about where and how folded
page table levels can be manipulated. In doing that, the door is opened
to optimizing out the unnecessary loads.

Oh, and I'm pulling linux-arm-kernel@lists.infradead.org off cc. If
anyone has the juju, please fix it so it stops spamming replies with
"Your message to linux-arm-kernel awaits moderator approval".

