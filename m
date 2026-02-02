Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88874E7DEF7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 16:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13836B00BA; Mon,  2 Feb 2026 11:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFC86B00BE; Mon,  2 Feb 2026 11:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC076B00BF; Mon,  2 Feb 2026 11:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA28B6B00BA
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:20:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 778E8D3A75
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:20:19 +0000 (UTC)
X-FDA: 84400028958.14.6AD3B7F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id BA284180008
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 16:20:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fckLAv6T;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770049217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfuiVgIDLMR+1uUEEwNNNUhXoIf0QUYUo6uQNrKltOs=;
	b=tjiQCXvyRAN0cKb6lEupyEDcT3zvMNSlfatSJzLfBg0dclNsh8HodsijkwR56FhGKNdd3A
	04jarVVJA9Q37EkBrjzXpYOR2iyOTzqzdYXFa0xE3x/4mEA52apSkzAIDmWCxDiE/qkh/A
	r5RqFvYjTCXMjs9Fyth6hagUdWOmmTE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fckLAv6T;
	spf=pass (imf16.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770049217; a=rsa-sha256;
	cv=none;
	b=DTTsnlRZsGLU5OI9qqtZMTrwP43l9b2mHu2ZMEdAPkMUJhj8E4Fk+gC4yYRucV7useYzfy
	Vp21WmzavDiIDpOfSaLJTfJheWVIYReocmMUcv1azXhS4qzEIev0JwBhvaciFUxmifMq4O
	8wUpWsEoAjCRzU17/Xfki0gOCTZhTG8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770049217; x=1801585217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BqUNHuuS4fu5iC8Ie1ZyL9H3NYhFXNxYeGHx9tpVVrQ=;
  b=fckLAv6TBLNePdl9BdMTeyGLrN51nDByuZzF7ZeXQ1Uap9JD1O1LlASj
   YrI5VBhNpoO3Oqat839C9dl9+/sb1yAoekKwWIx8qSCX/iLupfrE2tc0S
   tEBRHsHOYxNxdUR7Trci5C0fyEIHhrFqdUtDHP5FwoIi3ASHcYC9mTS+X
   +9Q1NKb389zPmazyPL36ZVPOgNMptr902hwVcK7jBM/tBFtMuXuztZ1rn
   MYk/y2nE2a+FkVLze+kruVHmRJG+8IWTu9dTsC7iWwFBIMzCNKduqGKve
   LRVPbVmtM5dgnieWWew2S2f2V/JLRINAoRDvBRUpipCgMRmCLqPpJ2qFc
   Q==;
X-CSE-ConnectionGUID: BcKhmJ5HQyelSxACsnUMCw==
X-CSE-MsgGUID: WI83s0BiRhyBpA1FaU2KrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71263362"
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="71263362"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 08:20:15 -0800
X-CSE-ConnectionGUID: vGtb2QeURBqmGgaBVcjwTA==
X-CSE-MsgGUID: AHy1YBBZQ3e5qR8b6S8+Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,269,1763452800"; 
   d="scan'208";a="214089413"
Received: from spandruv-desk1.amr.corp.intel.com (HELO [10.125.110.145]) ([10.125.110.145])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2026 08:20:15 -0800
Message-ID: <be38af98-e344-4552-a77b-b5345135e382@intel.com>
Date: Mon, 2 Feb 2026 08:20:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless
 page table walkers
To: Lance Yang <lance.yang@linux.dev>, Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260202074557.16544-1-lance.yang@linux.dev>
 <20260202074557.16544-2-lance.yang@linux.dev>
 <20260202094245.GD2995752@noisy.programming.kicks-ass.net>
 <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <0f44dfb7-fce3-44c1-ab25-b013ba18a59b@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: bmhu3b1895tzmbxd17ieshqy34hhco85
X-Rspamd-Queue-Id: BA284180008
X-Rspam-User: 
X-HE-Tag: 1770049216-417422
X-HE-Meta: U2FsdGVkX182ly3Nj8pyNomdTiPShnG2j2G7L48IqnnIBIokgntmPwXmjIQeNzn1QPwe3WURNc082UvXUKaLoZ4rU+T2inGC3GluUjzS6PEiOTNdt+25C7Bk7VzSzYP8B/WDa4gH15QRkZPx5GdrpKG+d4UtrPbqO8e8uGcgs6eHmrs1gpQMap60jRUXYmsrG+g0uaLaMp/rvy4/EXZdlwp1hRd9/Lzx+O0XSpQDoYGkrQYxshZvQ4wWin7asUIbfkcfgfgSRtFAoQgcjyIsA8AsPHSLGc/lx51pQJAUeugqxU+InxigynFKVDaqyqjEqcWC53nGNRp8jBnZNN+Yj6rMF6/DA6cGIz6Shm8BmVVFsnq/o3I5mzo9nIhPRQFPBWakPqe0hR8LVWMemk+PTyprG++KIyazyb6w4UrNG7VN5IxQnKft9Jbgg39iKVXs8GwfdvFJYnIZdI3oCM4egpyqTWtseZoZ1+CK6MDjN4xqbqwykeUpp57DjOon04Zp/FvvVoLBANGi4B1YC0YO9DfYZfu3Bz6oPtbO2Hqjw0mk3huUun6/Sa4Uq+ei1y+LYwvDGUvKQTVh7CC5MPbA+LiK0oBJmBi7EMfMVyB5jnfg6wVy08/TlCt0TTL270TOEY4nXzD7MU8087xV4KDXLP+rM5BdDqQLUfGX45YBGMxf/5xDLUTQR/frW2woSxCHkjp4mgaju8fG1KJxCghs508aLT4N539yWChEEnDvnCJ9o8agnq0LmXO/JQaYYBnX9a1/wrHoGjkeT+b6OQIduPWgOH09UqRWXKSHJGjjdyWkk01BRv9dJVvbqUzUAfWVPAIz/iqpmJjh9nH3l+RBE4X2z+BgXfJEwx4NU1WNgSZT9f/HTCXrK1b/edyUSb/g8+QWk6jtDNR8WicX3PFAW/LRtMi+i6KpjIyARmMePoMvDiPRQAnn4i+N+vc35GFt1XQ9RiTqibYPxvk0foZ
 YzMZe/0D
 LiF5kIxrN4BLK8T91qz1o4micD1wVtw7jsBYfWMVBCbZfZ9qb64XAMWs+zI5Njna9Kj46OJbZHzSzMFnkUjbYrTHedCD3CNOGtSeJbLT9iG+l27J7nH9NZtuHodRlaAtZerQOhd8njtk7nnrT9qKw6I624wyFYJh6EVJUaqFM3RFre9R6fdTkuodVI1M12G6pjXvWm000zaIqX6l0PpuKL+tk2nNn7x3GLc8XO/0r6VWfMREqISB17Rku3IbS7uviuRlF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 04:14, Lance Yang wrote:
>>> Note that the tracking adds ~3% latency to GUP-fast, as measured on a
>>> 64-core system.
>>
>> What architecture, and that is acceptable?
> 
> x86-64.
> 
> I ran ./gup_bench which spawns 60 threads, each doing 500k GUP-fast
> operations (pinning 8 pages per call) via the gup_test ioctl.
> 
> Results for pin pages:
> - Before: avg 1.489s (10 runs)
> - After:  avg 1.533s (10 runs)
> 
> Given we avoid broadcast IPIs on large systems, I think this is a
> reasonable trade-off 🙂

I thought the big databases were really sensitive to GUP-fast latency.
They like big systems, too. Won't they howl when this finally hits their
testing?

Also, two of the "write" side here are:

 * collapse_huge_page() (khugepaged)
 * tlb_remove_table() (in an "-ENOMEM" path)

Those are quite slow paths, right? Shouldn't the design here favor
keeping gup-fast as fast as possible as opposed to impacting those?

