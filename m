Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ABD2C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 18:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187C56B008C; Thu, 27 Aug 2026 14:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F9F6B0092; Thu, 27 Aug 2026 14:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04EFD6B0098; Thu, 27 Aug 2026 14:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEB5F6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:17:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50D131A0129
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:17:04 +0000 (UTC)
X-FDA: 85147855968.21.E286568
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf20.hostedemail.com (Postfix) with ESMTP id 697151C0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 18:17:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="k/zwWhNy";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787854622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVDMTfuDVLx7uVqlggo3542f1w8eox++6zGai1PxixQ=;
	b=vA+vsIUwBfLg9CJAmX+i7dNc2SX87EY9QEiuTHe6ErvxhdPdvwF4Jn2z3FFad9yNajjp03
	by/ZvMyHPs06Wr3DtfpIwVYKTzEkcLLgb9U6ar0HbvfSW2pvkvfq5GliDtw5D00r3mydDz
	dGvAd7QE5IhBsYu3heju5yp/yqqmG10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787854622;
	b=yccU0SBZiR+iFvZ9mK/QSyRLjMPqNNs1iaF6Gjff+pG/P3BM0EYrDeYg4/6MHkT6U8PHEm
	XzuwklZ4xllqzp4n6AdSmHSiRK+jZSnaNER1ZGVJwaNxnn5W58KGpYfRFA4sDzxlQv+4oa
	4WIuvkQ7zkaTpZl1rE+vNcFchrLB1yU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="k/zwWhNy";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787854622; x=1819390622;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HVDMTfuDVLx7uVqlggo3542f1w8eox++6zGai1PxixQ=;
  b=k/zwWhNygXoIha3o5vrTrC98YCrIgmMTXvbxmEO+otGOR4XnmH/xapq0
   kGtNQ8FPvMmXrfLjAhsoCKX5JQ5ZhPv5ZciuATsJFck/IU7u8DBAhXUOb
   Tp7YjTfzHKM907GX+oYdW3xfkGKxzSdTKROKi9GtML1xkRTGIahVTyCra
   kKnf1qCB6VqV37eK/93kOWd3o7/ETJfGhgaBAOl3iLyDijC6DZ4jt99Ni
   j7TSdnc4G6DVmyREOFlCDoKLDhw2crNoOLrT+9AkYFCG+wSdR3iWPEu7p
   bZj0d+h9CfajWEhTaAblLeVSne6GcENkUXOjnD1EsTGcHsB4pxFEHEwnN
   g==;
X-CSE-ConnectionGUID: LXrg6GWOTUSpXZWblBjNcg==
X-CSE-MsgGUID: DrJ9prskQKiCi2jO14N+uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88286792"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="88286792"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 11:17:00 -0700
X-CSE-ConnectionGUID: eQPmF8lcSF+SYQxndLuFCw==
X-CSE-MsgGUID: uN+GdqPBSAqKphEQRxC5EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="272164505"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.109.108]) ([10.125.109.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 11:16:59 -0700
Message-ID: <9ab4d7b8-6be9-4219-a410-ed26ae25c47e@intel.com>
Date: Thu, 27 Aug 2026 11:17:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 13/25] mm: kpkeys: Introduce early page table
 allocator
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260818-kpkeys-v9-13-743ad31b2c8f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 697151C0002
X-Stat-Signature: xa1pdmtyhn1rei7pu4yynfhffdcmkat6
X-Rspam-User: 
X-HE-Tag: 1787854621-938419
X-HE-Meta: U2FsdGVkX1/BC67REe+84BArnoX4MaJQBhIzbJmEGzJ83bGH7xiOIH31lk9Veq4szFYGmPE5YkzN3A5EO3elsq18iwIQmavhWG6h2vhpLUwlA6lualYBtmeJnfF1qycj/miyJSg0JZQLCFJpD1E95pHqgFh4FL/dV+iK/ja+Y7pt3mbo11iImLyFPNB/jIYMD2YA8rDfVUn5pfhHaW6NsGFuEE0dXDsdrTLwrSaqo5MhWeV6p7hx9aKiXP5A4j1XaABdD7DMYC0wK9DNR/FclQPi/fl1VtVENPkFtlPkZODBwSQjWB0p8n54KmOBSFlhoCVfaEz4xoGrkRFksy6u60CdjpwYRMN6bY11hC4RbueH9Bk3Ydmgnje1YtFBoFExhCvaJk+4aAVf5RdJUHFtLlqZLHWCTBqRrnw6f0ABOIBwCqqQB7UN2hW/C+rOrnvGJgRKzPQKeLQ/LwOhcw0ihRr8NiEDw+qbXfefQcYgy+TV38PQgKdZu1j7ZyGtEW3kqGgpRtMIPee/5oFexuZyFd5Bqo1UIWBAa/4SDdQsrtGpgD2dFdpBciEuQhVry64y67xCCpEtjh3f3soG+oK9HZtLxdni2cJn1TvnLWGWkHY8iO5ab8GRKWnF4NeWdtZ16g7zxmyPr4CIoxbAIZGe4c+fwiD5SL9cmashJdkeJKA/O3bfVqZ9srorZXKLdOjgRG9xFh9070WWaY4EbKn268dVRfK5U6GGB80p5NcwvFK5gcW3t3d+J/tbjSOZURG+D61o30BMhs2Dz682CKX/+TCzp+NcAT4YqMtl7kRagUnffb0KWZBVigC/qZZsqqH/2ufWdS2EvlUzx5b897b51hUrP1fg3LHGkV3FOICS5cLTB+fjQr2R+74WQLiAgtJP6yqz8Lvljy10UW7+6v7BJ9VuZrM9R32HxkHjWz4kwMa3se92tQng+2u/i2NYraYU3U9HNpj1HL2T5Rd5p2G
 JWmo19wf
 AseS8htks6A5jg2r67/rfz1QapKopkss+gKfo+fWdKrrv9rKPXoaejAD5avayUiU4PIOd2ZOi7VqmEE7HVvEQuBQ4b6GnLtkrl/SbLS1qPJLL8GkT0juAjNrtszkOUoSE+qcTQ1mvDH/feMPoemXpid1Bn8iVLU71Qypqmlq8YT23fVgR5djNP2GBIeSIUJCIBtLKmg/+F9t2pNC7dhJ/1TzvueINsl8NhwQC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 07:08, Kevin Brodsky wrote:
> This patch addresses the second category: PTPs allocated via memblock.
> Such PTPs are notably used to create the linear map. Protecting them as
> soon as they are allocated would require modifying the linear map while
> it is being created, which seems at best difficult. Instead, a
> simple allocator is introduced, obtaining pages from memblock and
> keeping track of all allocated ranges to set their pkey once it is
> safe to do so.

What makes setting a pkey on the memory "unsafe"? Is there something
preventing just making access permissive during boot?

