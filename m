Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DD2CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 21:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECDE8E0006; Wed,  1 Oct 2025 17:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4C38E0002; Wed,  1 Oct 2025 17:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DA9C8E0006; Wed,  1 Oct 2025 17:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B43D8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:19:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EFFDE140289
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:19:02 +0000 (UTC)
X-FDA: 83950810524.25.7CE2021
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5C9C81A000F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:19:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d1jAuZP+;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759353541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mT5PdxjtcI1i48v71PO+UPDYOzAaI+Kbtaq6k4yhaTo=;
	b=OVTgd0ln4pKqMNYvIC0KHIBOdbFDPhYFYy5EhetmbVz08Xh3fmV+sWaIbvqRf/o8Kl6Yus
	Q75McdwbKiZjb0e80fbUy6FuvgxmruzLrq/uM1riVs3CplgxwBYWhyWpb49OY9KrnVgtVx
	n0YiWMs4g/fG3OxApNMG48S0BDxw5r8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759353541; a=rsa-sha256;
	cv=none;
	b=ytDE7K3BmDcATYY5DG9bekZ2yaIyFufaE7dFVCe84ElLuRmbxvUr/hRXaIE+01ZHp/WH75
	ycVioA9KmsLTtR1DZxvDKfueMuHNAW1l1yl3/193yrPfT2+upmCMzYNYQbNlISRbLOYLJh
	t11jWz7GlbIn6dSAYgzOufnBbsxaHzo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d1jAuZP+;
	spf=pass (imf19.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759353541; x=1790889541;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hszeVLXsk4QDA1KmLdo7/yU41aGufNbi7fn8qVjcQSE=;
  b=d1jAuZP+lV9ZC6vciuFZ9Qt1ZjMUF9dCVKtwAa5PXLMmgGL8/94/7Msd
   DPIZcaJTp6lKZ8H54HftaYR3z65UwJuRoKxdTlmc75vK/5qlydLMK0YjE
   pDRL/Et/rN4kHW//0YkUg+ofj6+Gy/xj2SOlI72/79PAoyL7HrmU+MtXL
   sHP9M7BOArh4Q7rcnoylDtQ2ovOyqAfTUDm0XYYNKY4In9PAUQSHBh2fQ
   uEPaDpVrmlGNEEyiSSuKV1S/O3LwQHvhyXEyrzXh/u8x0D4a6JpUjYTzv
   om1eKSmtY222XE/zNPPn95vPDds/LxYc+G/Wdse+sSzt8uuk3rRe/j8vj
   A==;
X-CSE-ConnectionGUID: CDrBSwfjS1yo/GDwf+ZXtw==
X-CSE-MsgGUID: pWvN+GwCQXytwsYpb+pRiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61805126"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="61805126"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:18:59 -0700
X-CSE-ConnectionGUID: f5zzIt87SOGwdW4MfswyKg==
X-CSE-MsgGUID: 8PZytHqNTsONmo4Y4mV8ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="209598672"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.221]) ([10.125.109.221])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:18:58 -0700
Message-ID: <fb450443-07c3-438c-888f-30540935da15@intel.com>
Date: Wed, 1 Oct 2025 14:18:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/21] mm/page_alloc: add __GFP_SENSITIVE and always set
 it
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
 yosry.ahmed@linux.dev
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-6-2d861768041f@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250924-b4-asi-page-alloc-v1-6-2d861768041f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ib7p87owdrjhjmz9pndij37h1m8eaaje
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C9C81A000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1759353540-342708
X-HE-Meta: U2FsdGVkX19EFpem8NhuupdGRYd3cMXaOLq+HxjtiM3Fq8W0ctpq0Joj0wVs1c0ZQgX0J2Dh1EUf1uoWQpHNNj0GNUAE1nfRI+1cEVET79+gEAyf0RKT6RHpugHnXev5L0aBzT/L/GXganhPj4IUgdvXN9Zuattp7GF5+0xWVT6xVLY49pNPc7hkZLiPcyelc6y51rDQYeEmEaA9vulMxbxGQZokkQL/1CTcaS4k8c6qeYA2ICRlGFjOlH484Ao4fDE94asqGh49BbeH1CTppIPSwp8DIPlDqF6d7jtSC+m2Ihq6lbQfUSFRkam3LmMycfiBYSwEBe7SermOsrhqXk5Efgle+H7sHnvm59Tueob7ABRC3i8WJ4Qk38VQthm7W5zIfzCIa13kR95M5GYuJZkInmsUecaAppnYb8N9zzxwyYYP3LdTI21WEDABiZBrCLtgvTM1kBl91Mb1WNyrRJMLsLEkShK7wUiVB1DbovWpZbXtSd0xvqaWS6P+oscW+pw/TivmwoVpCkoCvxWJtr9PHZdwPh6MqRF25tRXySmS03ctapMCS05fyhGiaV++2EBvHtkISuIxEH1yDvGkpUuR1oXfM2sH5yeiB4uiYYGubwNv9OJ+Tx7iqtnI+W8cCE/9QebfG5L8L5nXeK6OT+9iSylCZXp62zSKjMZgUxp3sfECcjmuTgVIsMREGDZt4rXhDKFOEzpT2YSTmdfmx2MRrkPCSoaAdXdESfqkcrv8CFPlmHTesWqjx7xB3/ElEnbwbCtXrobMJaYzQ7zG0KFKs2KdhIXOPek7r3UPL5XDoncFt087soKolJ0a3Da3wZbGUZBK5kkt7KD1T3OMEOB1fcHZgemTWB2IQi5mMwPSCloGxXExOUwlJXxzjvFPWcJBkTaatW6dQjjx4r1Gg1iwpPztmundGMlVIiHuhhY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 07:59, Brendan Jackman wrote:
> +#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
> +#define ___GFP_SENSITIVE	BIT(___GFP_SENSITIVE_BIT)
> +#else
> +#define ___GFP_SENSITIVE 0
> +#endif

This is clearly one of the inflection points of the series.

To go any farther with this approach, I think it's critical to get a few
acks on this hunk specifically. Well, maybe not formal acked-by's, but
at least _clear_ agreement from at least one of:

	MEMORY MANAGEMENT - PAGE ALLOCATOR
	M:      Andrew Morton <akpm@linux-foundation.org>
	M:      Vlastimil Babka <vbabka@suse.cz>

... or this approach is dead in the water.



