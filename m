Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D48CF45CE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E7C6B0005; Mon, 12 Jan 2026 15:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C0C6B0088; Mon, 12 Jan 2026 15:28:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E433A6B0089; Mon, 12 Jan 2026 15:28:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D20896B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:28:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D99A160D8F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:28:02 +0000 (UTC)
X-FDA: 84324448404.11.9278EDA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95C2FC0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:27:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HCtjnfm4;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768249680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UB91Rsh68C1UNIlYIFLz5xmnPnEJwjihLfDwgTimA2g=;
	b=cNv8/hnirEeQSV9X47SKP/aphAEyh8ajGZMa8olyhdYrhAFStTr/qA64gv5sEZhsRSPHgV
	d+Oobl9komH/IzMzYMUiL6uNVj1ha4h7On0hWtKxD8GIo1fCXrXb0td4bPZRTKcOQpqJ2u
	bHYm1nx7hNs10DFLWN0yg/8snV+gkng=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HCtjnfm4;
	spf=pass (imf22.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768249680; a=rsa-sha256;
	cv=none;
	b=y+ZBrpd//BYxAM4T4kzeRwiGrUTLb9OakRT78BjP1W2JWWpaxDDauv/73Q6qqLo7P/+AHt
	tr6PyWwGa+8UglHG9JnunxmxhoNklQpyr3/MDA81VB9kbvQWltX4PNqb7iGhAInIHumCkM
	CtHle+3Jrn81Ei8fhqMhRoRpBuWDOLo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768249679; x=1799785679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t2fdhdnYewNpKea12/Gs+AVw/4a8pJY6L//ggFDOvMY=;
  b=HCtjnfm4PHcHpVHOJJolZ2j3DeEDuoEkLRzwG5vaSmKNeTB2GmQbQxn4
   Kr0CTz4oJovJ3fEFOHdYmoVTcVQbYpbWq0rKxAB5aVedpQx0hkpyrjZ9r
   ljgu6TEwNEY3j3igu6uI8ivxv9wV4PTlab/LQLAJ4BNDCO88Gi8/8bziJ
   5hEtrAhARXG4dL6pPi8MCjVeIT8wpvMffZYILGPTD1jZ8LGS1xZdHh+2c
   WbpaqpNAFykYBWM9WsLgA1n+2C3mASbK+/wdQReKKxjPN6LXu242nSWtG
   Yoy8ptPfZ5TGZNHJVaC61JjTWXNmh4JaQWMQzA8nlNeb1vfnE8nMX1+GK
   g==;
X-CSE-ConnectionGUID: lvd1BkzYTGarAamECzYobQ==
X-CSE-MsgGUID: cSuw+B3OR12qzwFLEybViQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69444017"
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="69444017"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 12:27:58 -0800
X-CSE-ConnectionGUID: 3Fkudj2QRTePIWwm3VElwA==
X-CSE-MsgGUID: aaSqAWTbSpSfrO7GygXATQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="208659007"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.110.123]) ([10.125.110.123])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 12:27:56 -0800
Message-ID: <9d78f71b-cbf1-4936-bc72-befa6d6bfe35@intel.com>
Date: Mon, 12 Jan 2026 12:27:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
To: Andrew Morton <akpm@linux-foundation.org>,
 Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: corbet@lwn.net, morbo@google.com, rppt@kernel.org,
 lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com,
 vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org,
 catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org,
 jackmanb@google.com, samuel.holland@sifive.com, glider@google.com,
 osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org,
 Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com,
 thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com,
 axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com,
 bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com,
 urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com,
 andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org,
 vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com,
 samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com,
 surenb@google.com, anshuman.khandual@arm.com, smostafa@google.com,
 yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com,
 kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org,
 bp@alien8.de, ardb@kernel.org, justinstitt@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, x86@kernel.org
References: <cover.1768233085.git.m.wieczorretman@pm.me>
 <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95C2FC0006
X-Stat-Signature: hw7jxmbso6j7ech9hut9zejprf7r6ksk
X-HE-Tag: 1768249679-795748
X-HE-Meta: U2FsdGVkX1/dPHkR54VY8qIaO9+spwKY1TBNKg/3p+joLlzkxY7Tf+EuZsoeSfNB5kea6EowITw1tM2TIC20/WVhnFsG8sH4wEtQibZUv6EPiBtgWo8u3HOcqAJrny6WooQn4QJq95M5VYUzAT3w9WHRIx9OJiceoc3OuuiUpXxuYV6OxSvR0XoTm1vE0L/m+KuMG44vef6cv/qIpvKrXHhTgm3kOLLxGlWaUeOZ5T09Q8l6lTFhUy5J45qsgAyUuhNvaqAa0mUm0W/bw6squaUFmBbZyu1lfTaHDZ+HSNPBk2qq7zx82C+2VpIOVZrqrt7p7+MjO31KVgPOzjjQ/rZgTzjpeps0M7OBUSRDwL3NbvQZ3n3cMd+99R7o+BiHig0tV03eATl61EYETSIJr95bGgYADXvkCTTLbKojsOfNkTpwTwmoQkjbo2VyEeINfMdM2acwB8Xw7H679WQ0SKRAvb57fwXIZN/K8Ixe9ZJKsZ9GQ0EvATmhIozi4MGYXJ+/tdug8085PH+fdKqMSFe6a8SX9Yk6Qv0OwFxRfiH2TvZtvven8gDhjkd1PeUkKc3n8QLrxFLxQoCOljRAteSxKP/O/RrcQMRORV1I48IqbhijnCOuntQn1+sRPYthWo+92AgBDN+B+wUEuFuPRw0ID6EkPW9y2g93tOyH4n33XNAWvU9Ff4ViHKBKKbg/VUm/ZBQpwfvIopA0aonkf9eAYhR7QnD+GRKjTJHqcr5LA+ZkjMzvnrpxx2NIA0X9zTau2wS+0QKYfUhDS12U3746vo9Qfc6tIws6/oIKabWWVw3slQ1R41k8L95lj0RX/uqfILnIguRP5+LDwwOOmwkpYoqMBPlq0Fe3NeK+1omrEV5OXfN68EQM0UswgW11tDtULNKFAdBRVi5sLnG3DklGah4D03qYSed871M7TESvqvhJtqvidW7sRbJ4sqD4kYaYddfjjOkJcGx+VuZ
 nDFMp1f8
 ANk77ja0LZo+fEzQ2dCjwtISda6QbEW+XI8bcKLIqenUbRQHJzoikIWU8GOQ6rqnfzl3HbgnkJVvsDQQyiHkeTkahQWV4Z1dLNIuxzbdytwnhGM4khi/AbJbljhaQQI2yWMJoywibl68vmTtdHzYfymRGehUV4aas+JfT+9PX/ClhM7iCPzvAhaVnYDKX24OMs5AiYieM7pJOBQzzFdaOfb+28Cj//UnKxRv8xXMUR8rtP70qvVFd/p02KTdYAZqa04VAWUOaZqLtSCfS59UfWDi7NNp8Ejdwu8Sbhqgx/BtHKL8vS9DYJ/UEhjaseHYRHkauKQWnKcn/83E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 10:29, Andrew Morton wrote:
> On Mon, 12 Jan 2026 17:26:29 +0000 Maciej Wieczor-Retman <m.wieczorretman@pm.me> wrote:
>> The patchset aims to add a KASAN tag-based mode for the x86 architecture
>> with the help of the new CPU feature called Linear Address Masking
>> (LAM). Main improvement introduced by the series is 2x lower memory
>> usage compared to KASAN's generic mode, the only currently available
>> mode on x86. The tag based mode may also find errors that the generic
>> mode couldn't because of differences in how these modes operate.
> Well this is a hearty mixture of arm, x86 and MM.  I guess that means
> mm.git.
> 
> The review process seems to be proceeding OK so I'll add this to
> mm.git's mm-new branch, which is not included in linux-next.  I'll aim
> to hold it there for a week while people check the patches over and
> send out their acks (please).  Then I hope I can move it into mm.git's
> mm-unstable branch where it will receive linux-next exposure.

Yeah, it'll be good to get it some more testing exposure.

But, we definitely don't want it going upstream until it's more
thoroughly reviewed than it stands. Maciej, this would be a good time to
make sure you have a good idea who needs to review this and go rattle
some cages.

