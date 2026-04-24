Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB6EFED3FB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE3B6B00AB; Fri, 24 Apr 2026 15:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27EAF6B00AC; Fri, 24 Apr 2026 15:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DAC6B00AD; Fri, 24 Apr 2026 15:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01DA56B00AB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:41:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F9241602F0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:41:42 +0000 (UTC)
X-FDA: 84694469244.21.6A9DC0A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE02D10000A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:41:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ONmTV7LW;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777059700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCl9Rd+bzw/Sgu+jZ9zyyAbcAlJYiPI0v6GWJ1vN/os=;
	b=QzMTQBBI/7YusuF4EBprmnkvFu/2CdvpLmpdGyJa9J9Ki6AvuRUyOLLT2USOi8djSvQ36g
	efd99UDoI8BHt74ARPgW/Ah03ErXXf2TQfTbvVJIkPPfzZMPIgGflmGzKGLifVmEy4DAN7
	kBRcWRE3kv/8QPrW+Wb/KUcpQ7uWiKI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ONmTV7LW;
	spf=pass (imf05.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777059700; a=rsa-sha256;
	cv=none;
	b=1IEjLapXuzqH7pJX32ZEMThLjTIGJKVSzhSVxsZM+EX3143eHgw1McRS0z8VUgEkgXIuKV
	cdYpOBDbUzPqTs/oB2cIS84NzvGMOTWrr8rJaIHtggmIf8kfGplnq3G3TaRK6jCn+D9qfT
	g9Ixd+BGdMOmODCMFJYzXsVnnAbMcH0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777059700; x=1808595700;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bCl9Rd+bzw/Sgu+jZ9zyyAbcAlJYiPI0v6GWJ1vN/os=;
  b=ONmTV7LWDrZmeZi9kwK9frxWu2nVB8lgo5TBxUz9keJdNzqaeGeHWVq6
   fPeY/ODeDfvcaQhhPfHb9Lk2srC2SaNx74xqQg3VuOho96WA0K5AT3cJf
   psov4Fc3QVvZLep+qMdHPufa4uiPBjftbcCZdwhk3bApn7DEPhvUbIrvr
   HEP3xfrBTCvsmJoHP//i2G/NpJv1jnZwNmW4c0jvkRklVLkYDpMgo44XJ
   anj8OT8E3aRpYrZ4LIhRI+X3O6AMFxq7Jfnb3j+Q4XGSETqLPd201Asz0
   dwzKnTZOIC6kmU4RfKJ7JEnxCqTmHA1TWjY0NBA0IvAq8yt6r1jf5LFds
   A==;
X-CSE-ConnectionGUID: BUWYeuXnTyS/C2d9qVW0gg==
X-CSE-MsgGUID: m2OpEYKCQk+bqjOIV5KKoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="89510076"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="89510076"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 12:41:38 -0700
X-CSE-ConnectionGUID: wnnmg2zNR+qgwu8F7I6MeQ==
X-CSE-MsgGUID: TbbGNCXRR7mJdfyWD9cMkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="226510098"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.73]) ([10.125.108.73])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 12:41:37 -0700
Message-ID: <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
Date: Fri, 24 Apr 2026 12:41:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Linus Walleij <linus.walleij@linaro.org>, Will Deacon
 <willdeacon@google.com>, Quentin Perret <qperret@google.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260424191456.2679717-1-stevensd@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DE02D10000A
X-Rspamd-Server: rspam06
X-Stat-Signature: aic1k86s6g1bmrx7bqr8pqsfky8z34kz
X-HE-Tag: 1777059699-190123
X-HE-Meta: U2FsdGVkX1+SjTuTK0WzERhw0a9V7jgV2F4UcMKUqthiuZXsT1KmTkXAIejC3A+AhbZ5PNnR3PDZsMUHxtIhzDe08EE1AwCydiybE6l3SEkAcThgxQDTciFBXE66zMpkvyjRrDJFl3RMEdMMGtINCsnHTu4cmWNKui2C7InZbQH4q+j12X44TkNxXryL2KCubUPt0fhRxowRwb7F1EcU0LiJ3hfOTI7/mxJDWZSg9/ltCR2dpUzTNXa0Wp2DpD9AUJ2U9lppoHjOmhTqZSnSRxKHYNmnFm4+KYazOx/B9fiF0Zlm//TW70vG7dGokzcZr928Vwpevh1ei488Nhr0qNehtSJFACHVxxV7t0J6X717B2EC0gNffMiEZzayvW9q6hAETDwkPvQTS41b2Kw5jtcVd52SvdmApwRKvJSIzRYDq0lB/qjE6ZWcHmdmpSfZ7Is2oQHK7NTf1xM5kAIGM43kXPbURbV/zM2mXyOqs6Y64d0/bzZzJUujrwKtFxLxdCR8LsI1+tUYvkQM2GpcYH3oQiFHybAeAtW/FXCHh5Qv7yMwdDzN8dKeZZs6VkUVYjzx31GE+9gWrnlkW1MYdfwoWGuVLuC/xxOATPu+7fJL4esoCWetruVntZaOif4YpLRHUswGrRXK6rXdWxHt3QetQgfwdBsIKRVmWsF/vz7L9xmuWmhO21T6uvH9iJgEnYHBoXSL50FF5QBg7ZvGKBfRAlfJfJ8/Q4xGoAa67fAUjnqRBtb/0J9nRMHWFy+XmbePFseJE0hSaU4kOR7X5Vtvvvte9UHDmQOQUXV35gRgAeRE3f9v6IZGrC62b7SnDJ/RN2D0Ru7fKJ5aiWpcTNpLycN8DD6zQhLLxuanDpEu0d4YIf3s/1jMvELiKS0kDrvooNZTn6Zw+PTOWkPgw2HPcxODcaJfHKCuF6q6C6g9c8uwfHlKoiOt1CQYTDb/2AnNuZ+GS2Bsl/J1ats
 OwxDlsTL
 q7szCVyU+t6qDaxThRSCWE8MTgnx6NSpejSskji3g6yCvp9Qe5i0wICX2oDqUYrYS6gN77G5vfGzC7unXVDFhy/MHYPBnjWgAD5yycWNqGjk3d0yxwp/542RzcrvDLtjawgd76vLdwZeQPuQisQ0xrmtDddg1VpaifLxJ/e7YBPSdCQWcmnuzZL0A1xAFHvOI8SYR4V3Jb3X7CDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 12:14, David Stevens wrote:
> The question is then: is this approach something that is fundamentally
> untenable in the kernel

Yes. Fundamentally untenable.

Not allowing stack faults has been a wonderful simplification. It's one
of those things that just plain makes the kernel easier to maintain.
Saving low single digits of system memory is not exactly making me eager
to go back to the harder-to-maintain days.

I seriously doubt that this 1% is the lowest hanging fruit for memory
bloat on these systems. ;)

