Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA6A0CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 21:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3249B8E0008; Wed,  1 Oct 2025 17:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC138E0002; Wed,  1 Oct 2025 17:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2119F8E0008; Wed,  1 Oct 2025 17:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB788E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:20:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0D4A13A507
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:20:33 +0000 (UTC)
X-FDA: 83950814346.12.D18934E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9DA1780010
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:20:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vsc+rTBM;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759353631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKVpA9G31jKVedOBSYJ/cAfmJyMKXqtENT44BEOmwbw=;
	b=34euIRfFLCIAt/eTXK48HZsENp3NL9VucfER073xtUiHeTblpGi/LTpqurIqY6UNq9E5WC
	JGq0tD02mWyVaRpiK6xPcNp7bTYeT04pjZT5lPgzhRol+lOtzAJUQ18KJ6DGLC8tAtEpB+
	X6GX/jcIEb+9Z5lapehee6BJJsnXHoI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Vsc+rTBM;
	spf=pass (imf30.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759353631; a=rsa-sha256;
	cv=none;
	b=Jqy7g4QjB8aeYzFnHkM1BtX0iCA5BkA8JqVwLnJqzdBYLtTFS9nJpr0RBAWh+PHJ4wc32q
	S7+tQpH3IVboGDvWkOLqTTV0g7fYFYUooFcqgRNjw2wpRc1cy7dgOwUV42yvUSE0Hvs3wz
	52uhR5/o+jNZwZwwVgSyuu7HX7MKuEY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759353632; x=1790889632;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tTCadrNIkPdxAI2P4Lbojs+IXuprB8fMDp/ldr0Onew=;
  b=Vsc+rTBMABLJG+ezrZ+xQe37ZChKAQQzxXcFsJ8bBHdL6WjuG+jg2Kqk
   UfkN6dD62JfYelpLHSdSPkX7hXxgI+gXpz9tq/cdNzZKa3NR849o8dPDC
   +9mMSsoK6u7Z7r8hClCaWXYFwgl4ipgXbs3IK9HwnM4DJr25ScbYt7HNF
   dTFK4Cf6a7BEkEzGdBImgIvpvhCmInBqW0UqgW8345chPIuMklrvixrvq
   l6WMFCVTyp5Zdvl2NgU86GIJ/nQccnx2wHKIGlrNnBkJE4xiumMzPSxJ2
   rhlZnMrUo0wCnM9/QdgetiNSw74tqUuauZ5brMSQ99Rj1kMj+dstvQF7f
   w==;
X-CSE-ConnectionGUID: z0dqgzvnRhajFirKnmumzA==
X-CSE-MsgGUID: gez78V78QXSOE7gmjHxzqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61805200"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="61805200"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:20:31 -0700
X-CSE-ConnectionGUID: ADEPaYJ4RCek9su6GZ6d6g==
X-CSE-MsgGUID: cPzU1CMLRdOuWaGIPbcQUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="209598851"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.221]) ([10.125.109.221])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 14:20:30 -0700
Message-ID: <caee3410-a01b-4e40-9f0c-ff7810caf323@intel.com>
Date: Wed, 1 Oct 2025 14:20:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/21] mm: introduce freetype_t
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
 <20250924-b4-asi-page-alloc-v1-11-2d861768041f@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250924-b4-asi-page-alloc-v1-11-2d861768041f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9DA1780010
X-Stat-Signature: jfrbk8jybfc5be1owwms648979qh6tco
X-HE-Tag: 1759353631-605583
X-HE-Meta: U2FsdGVkX1+ELhzO/Z1revmHypjmJ+biXNTXy9x6SqeOoZFK4LoLch5w3uGZb7xePkiOae0jYo+weLp9tIIPUtkXFt7kauw5Ga0PwlSyPmCwy7y3rfNKwA8xQJfX0MSWfEIUDEJTKZ0jeH6mIHu2Ku2E+NgK2Z/CPMXlRjFFBnHFe1vkM6rPQoJ4f3bG/yKLx0AnkGDU3jEyfxHM7H1FxlnF+ZCx23FwqVD4jTz7VLm4F0MG9+ajkt/bWbofpyYVC+4UOUzk3JfeCQzPcW89WKIB6OdO4Ti8t2ImTFZF9Q7rUA9GOdUI36EhA/ZY+eynr67tKePM8RLmEKGu9GFvMvYH6JLhtf0P49ZqpxRFaSHyRhRLQh7Ky0kOMjtZIIt4ChCB8ZHO26N0U4xbr2PTJ1D1Fav8de2+hprQvFTPCeaTka3XxDtZsfLP+EdUTU7gL3hdWKvgB4kel35Nw88Uxi+3697H2ORWnDsvio/GPFXb2PguUm0ezqTzcgDbuhmM5+w3VUN+bOsi8vWZ0FbhThXk8+7XKXKUDCtZPCzNSonZ7BLt3aV9KvB3Zv3LPUp9cIiGYnrqfwlyj+O32ktGPry5r8JjF6st9Dh/0XtcgXKgzvGP7C5Zr7neFmh2ZOoGLPCkv9N4SEEuUsAjJAPCKlj41pAJ94QoR3CUj38sHR4T+lZ9uXYXty2vCHx4QYHnvArrzuOZ01JHAP2+tWnLm5h0b1ulshqmtdGBmyiMSjtWKVF6OVfrzyRdoQ90y2fYQeen+mWWbdv09qJ2YE3TWcG78uBJJtk6lgFiRWDCsBZB70RhILzT7Nwxf40zFG1uD4B067ViagCKkwdi4ZhwzZiAAO54QlmwTk6Cr9q7elcsvH89WEuc9myTmjL6FQ2OqYTvKbqSTBZoqosHl9EiSaQ0IwSN6/XVf3wFBBKUReYm3vW2GtyqqZ0Feet441U14srPz7suYUqZcONTjJn
 gzVsBxJJ
 csxcbfV8I9ku/RzmfZgePUlDziqPFTo8Ju2Lw0WKylvXSSxXBtcweHNPT3kt0XufDGAJitX4/jtePBqK/nRRQYGIcQZn96hIkJSTmG8kuR7FBuh8S3xtK879qJLReru6HfvuZPsf1SUIjunSu8glLOGxZADVQ7dGWQwDKjGg6w0jp0X1FCoxiVh8nHjJExKtZUVM133T7TYfoTe0Nrd0KV+1Mxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 07:59, Brendan Jackman wrote:
> @@ -2234,7 +2235,7 @@ static bool should_proactive_compact_node(pg_data_t *pgdat)
>  static enum compact_result __compact_finished(struct compact_control *cc)
>  {
>  	unsigned int order;
> -	const int migratetype = cc->migratetype;
> +	const freetype_t freetype = cc->freetype;

Just as I'm scanning this series at a high level, this patch looks too
big to me. There is too much mixing of mechanical changes like this
s/int/freetype_t/ and s/migratetype/freetype/ with new functionality.

I'd be looking for ways to split this up a lot more.

