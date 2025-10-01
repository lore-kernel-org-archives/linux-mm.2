Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61831CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE598E0006; Wed,  1 Oct 2025 15:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5DF8E0003; Wed,  1 Oct 2025 15:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB658E0006; Wed,  1 Oct 2025 15:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6B68E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:54:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A26311930F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:54:48 +0000 (UTC)
X-FDA: 83950598256.21.64882DA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C477C000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:54:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nDas3Dd1;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759348486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yeE2+9nZf16YiL8ezo05/SFlXnPmaGs4bzxlEPj5Qnw=;
	b=5E+u9yGy2ZkB0kp81eQcKDM7lVT0NLzxWDNHovP/kZ8Vs72BEocL3Z9zpDJKaaea43QbF4
	+TO8a2nhGRW8afeYDCob/G1U1fTIrzJVIe1XShiDqIWXPJpXDge1ksgQ5XPXjwq9T9WJLJ
	1ja0UF5cXgeg8Rm2pQLpoZRrGqfMILg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759348486; a=rsa-sha256;
	cv=none;
	b=Wc7gh/gPZGJPlsv8w/nJUBM+gy9KAch46vpHDpJ75ST3QGco+gEUqZana8XLNZqaJWXOQH
	JKTtaz6HCLl5lx63PmU3hneQcB2kGmwEAl/C4fbD2FWBbSDfkuP73r4kDrOc6GubUe/jXA
	0LosU97kxp6iNHNmU3klzoTyOYqEqcU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nDas3Dd1;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759348485; x=1790884485;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yeE2+9nZf16YiL8ezo05/SFlXnPmaGs4bzxlEPj5Qnw=;
  b=nDas3Dd1qEN38TGPXy8Q3WQx6p3XGw2epyEFghqhUyLZosBput3JPh23
   1OhZ1cfjqhf2xYwP8eY1lPuZoe+ZSM14OoC+JGcPJOcx+0V69uMxlIoxC
   QqqBqZX4mc3JVd5Bg80N401kf7Ol28qPBuySBz4W0/lVPbJSZ0DIF3UZ/
   eJucejKQk79PYMmqrgOfVYXEqsdIBi83QwA22oSBwvJ+DYeldwL17cvWC
   k1jKFD6XXhWnQXWn9HFl8/pQfKI25Pqwd1qkZvljzLZYXftUtFmesL1YO
   63UjJtCuL50+bC+RoZ2jc+ceW43Ln9+OTfuQvwxcXHC0sr2uF6NUb0H9T
   g==;
X-CSE-ConnectionGUID: rxKr/uSSQIy0JSRpLAjeEg==
X-CSE-MsgGUID: DeUxWfPsQRywSgcCz1FzLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61799645"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="61799645"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:54:43 -0700
X-CSE-ConnectionGUID: gflq8DulT3KxuMuYwQY0Zg==
X-CSE-MsgGUID: QwqTAaU1TH2tc6KulKdh+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="209587292"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.221]) ([10.125.109.221])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:54:42 -0700
Message-ID: <726d6a45-d732-4c23-a7b7-766d6a62122e@intel.com>
Date: Wed, 1 Oct 2025 12:54:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] mm: ASI direct map management
To: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
 mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
 david@redhat.com, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xdoaxtwejno76srd1eznn8u95n4dkp6z
X-Rspamd-Queue-Id: 3C477C000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759348485-819276
X-HE-Meta: U2FsdGVkX1+CGx/81l/gO51AFKsoJUmLvycGOwmiU5uk0MzeEzLxY5iv9HuII+wQTn0RQPX79g1KJgQcWq0HHZRPWcomxSaNgcyhgEhv7MDBgUJxMeMb+iSLZv3EqYTNMLMmmerep3V2Qvjh2RuIduFTM/XJ/WLR17sW1InFlS72DsAYVSgwfsDpXsZTsKK+6uxu69FqMqiKGH6EbHyOj33qdJ58+oY4ME69XOSR+yLc6tOK4MNlR9eUhXTZwCKCHsiQsd6ufZm7IVOtesM1wtgwO3OqRg9R5sYrRSWUlYq9Qp8NmJXU5i8thjeJfaMtDIuReFTofEyJqgxwDZsiPg31mVEbHjzkxx5aCw0nB+GEeKalYlw8WXQOeS1cLaHJ2cVDuTdtYF+Ckb36nItPCZecWQs6xXWNbc+bAN8lMmYIdTrms5HtujIh8TeJldFYDPeBO2y5kJ6quPOXpFGMaucBJmEZycUlTzUbCJW1SpdX2+o/CYHKIOihoPzzzmMREs6OPTq7BEy2JkatyOrkfKc12n6O3RFhU2CgSixqsluQTvS/ZMVw/blmHMibQTTbOK1f0qNz5kvLHF2UDADjdIxkJLOPKd6vCqn/yEXeQdfTQro8/MOE6wEfj0nXg/yTAETbMIIYfloT5cegaEsCy1jHfspJBfg0P3iaHkuuY6Kcepcu2hB8c0tgBZ0YjZLWnVcOVX2f4husQI+QyHhjCC0dy/LZSM5S6O1vzVYAdciTC1z7WNmnGzIaEHGpnKXG4YO8iS0Tnzcph97lRSlIUn/x3R59x6ZY+URu8EgVyTMa3WuTmutEfoOFY7TPtFlU1vTVrtWKR/zTlkp8GZT+vWuc9a443yNmhWD/Q0ovtwLAZXB0IRXPIDBMZ9V39w7fxuJy0n15LcXtO0NNVCy1GyjGPnKAdMJrTC3763+1aLVKt3URfogpyT/bA6XYRDvigR2NnPZ+LRoghv3k1ut
 vHOEHCBe
 YY3ARzJ5iYPzwZ/WXyf/P5NPmkBQWXj6uXrcPS+fcMSbqmpdaBQ7Fz3mJK3F/CoCjsOuuR3PLRMOFfnqHZAktNI7nmIYDo0YcXK0z05Vqx+pVtK4u3010HtyOZZ4uOuYf2yj0/0ooRx9lcvyrNwqTDbKzdvIGOijC+TLOEKyCS9cn2B1Yaq+E7bvrFdwNAL6BbeHa2UTlQNcdeOuVNBHxET7cb0V6AiN2IleI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 07:59, Brendan Jackman wrote:
> As per [0] I think ASI is ready to start merging. This is the first
> step. The scope of this series is: everything needed to set up the
> direct map in the restricted address spaces.

Brendan!

Generally, we ask that patches get review tags before we consider them
for being merged. Is there a reason this series doesn't need reviews
before it gets merged?

