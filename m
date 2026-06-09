Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B02CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7166B0115; Tue,  9 Jun 2026 15:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E0C6B0117; Tue,  9 Jun 2026 15:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3BA6B0119; Tue,  9 Jun 2026 15:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB6896B0115
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:33:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DD6391552
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:33:46 +0000 (UTC)
X-FDA: 84861374052.18.5187E73
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id 792E6A000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:33:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hY3d7URu;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781033624;
	b=Psx4kX6gUgAZot7bUERBdlam4IaltHK2dqdXv0bdUbcymlsRiItm6S4kLn5bu0IXEpzMcL
	ST2tIzrD9Ggg5YKveY4mQEMahTznYUNLjvcg9pyhVsAVxCxZqecjYV+lJUqDWjfdb+lRxe
	xHO3FO+zLx36UOTYwdo+CQfkm7ttK2c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hY3d7URu;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781033624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+L0qHtqOvk0unXIaJmHaEmDAmTIG92ji9302SOu490o=;
	b=rtKm/IOxaREAq0wYuvFzrSggGSnIlOKEf1I2kNiQFca/apDdieWSiU/ggna98AjvBB1vaI
	106nx5zjdV6WJWbQq4gaS+LlKXD7AO4KsEvKQsNJlTHV/2f3ajPkkbmrbWK9VZpeSHtR8N
	z6pm02rgSiPEWF+RQTu0kYeY6xXIIzY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781033623; x=1812569623;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NGQ4F2zi4qDp+6wLH/46w1O1y8JeWGa6nqwkQJ+vjSM=;
  b=hY3d7URu5Me4Ez8hxpaL6qyiVfHTHmHarL+RzeLHtlHSPKrtXvZ/sz4/
   wFVI7MIY9bhuKWCcUNFQ+WEGVQAh/AyzTZ5PRlJBWe3GreNeuOpf1j3aP
   6WODDfo1M6lI+PbVOWlzR+fixxRD7uk5tqQINFJ0Bv4vSjKUbnvk997yI
   DCFUcfC3W9ZSyCzxaKcNVlbxg/sKZzXdj4phraRyAbwLeXcp/N1ffED1/
   cIdsDGfh8tOLimek1liz4bYJtV2eLXkcdxsa3JzPZhZKrmN1smFO1dOI0
   4deCa31YtMHbKlEJWgezTziXrUhHS66lJuSluO0ibFakSaVYSSK1/Jg0T
   w==;
X-CSE-ConnectionGUID: wmOZmt/RTJ2RAlRPL7T3gg==
X-CSE-MsgGUID: JUNJgy5HRRWnw0ojZn8Y+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="80829075"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="80829075"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 12:33:42 -0700
X-CSE-ConnectionGUID: wx0HztfmSmq73/8euwBJrQ==
X-CSE-MsgGUID: JfXblqslRkKd0hIbCJoqBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="241809357"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.207]) ([10.125.109.207])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 12:33:41 -0700
Message-ID: <930d9121-9176-4a7b-a2d7-8224f94000d3@intel.com>
Date: Tue, 9 Jun 2026 12:33:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 yang@os.amperecomputing.com, jannh@google.com
References: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
 <20260609143801.7917-2-xueyuan.chen21@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260609143801.7917-2-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 792E6A000E
X-Stat-Signature: 5qji6z1ezb5ix7bcxwo9zcne151y615m
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781033623-501634
X-HE-Meta: U2FsdGVkX1/uIbw9avASyP26OHdTOkq+t/jmD6RvmoeqDSMkE8sqQ8RC90IYq1QUYco6lDGS1PGjJAizvefwN7TTptjoi8chBkHwCSt3BEa63muIMdcmfT559RAMqiksH6yewNqZgKmFVQBdydL/qWUhuNl7Yzf1jXs9zQ2JoBe6o4B6vWMg3Dt2HWx50G1m2R3xZTs/0H0wM2hrPzbWg0nXCM7FED5JqAiSbMdvD+uDwvH7MTrZXgjB0OOk/b+NvjIviOwAEAUjdc20diVh49vGhCT6XkXV5gemCIngZ3wuQF6K7N4x4PI0vDGE9eRS9lJGlutz6nz/ogd2PqrizevNSHPpWmBmJYp2Njy1QFppzmEWWL6CjFB0fCNBBpMF/mnvueBhOE4R55mHL2bZSM35Jfp81IJXNMMEoFf3K5uptMBu4vqR5/na7FX5eVzOkOE4UhuN1DzdfbmQ9JGpxwgBxUKD8ZFqTi/TpNuhNx0tmgTo+8In8uTqTpmJJqsHtS7jRHC3vwlroVQi9YGGSxhssqn+H+WgGhzr1OKYIZlDrQ81jb+lMV9J2/SSl5c+SWRBKZLbMhQeiAPjOjd5pz63D+b25iIvhYejBSON221ekqCE5PE9a2aAY3YY7aTPiwekJuo6f7g5Mu5ur6agi+TGVIgZcsK7pwttJcugPLA6WLIfUG2sZUmEoVfwETqmZZQVSfRSxwL2aAkPbYyV4mSrC36rLa+fOu3xRfBesBwgctXYyiG0dYTV5R35WyRNPG0rzHC+3IIee/hZljdMT6lK99biOEGVyo8Vdy3w2zErjWn8cNXBafJ4hSUrw19xM6h3CVg9UlaRuaFuDpR7rsDI39H48zou27o9w993jPDkXPJtFleIwusYd+h29+EBFrtkZR7jv/kaZKiXaleyDy909McnREz38kW82u6H4RcYr6tHqFbPKunOPeqnRKv9zxL/ON3Tnd164pKVfwS
 SJIzVXRP
 a88dbb+ePhc+WtAlsHdvPsfCRwmzB4WkLFIdWJ9LLDhdL4YW/H3Db7FzfzylZoNsrZZBNwu9sBhp/bIqcK/IHhJ8IzkrKeiW/Is4dq5ZQLdpHN//cH1gsaSrme9Nkitg1U8Dyo6zAuWnPIUVE20xTJuUMEUooq71rbm9VcJT07y2Qd96fK6Hqzqr5RCr5w1v/On4nSfz5IondSi89va+fKd28or0+eX6vJixS+JLT1hV7wFBWn33WyHfWXMo4mRmDs+BngtBaSn2v2OZHgGluDszVXnyFL7QWAXVYI+FmDdZU1RLujjWlGcBsEhA21+UIdyvCl40wvp2zyzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 07:37, Xueyuan Chen wrote:
> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
> +{
> +	return false;
> +}

This is a rather wonky function. It's going to cause all kinds of fun if
it is used like this:

	arch_make_pages_readonly(syscall_table, 1);

It's also kinda weird to have it return a bool, and not check that bool
at the single call site. Some things come to mind:

1. This function needs commenting. It needs to say what it does, when
   architectures should override it and what their implementations
   should look like. It needs to be clear that this can't be used for
   anything really important. What should architectures do with alias
   mappings? Are they allowed to touch non-direct map aliases? Are they
   required to?
2. The return type needs to be reconsidered. Is 'bool' even acceptable?
   Should it just be 'void' if callers can't do anything when it fails?
3. What should the naming be? "readonly" vs "ro". Should it have a
   "maybe" since it's kinda optional?
4. Should this new API be folio or page-based in the first place?
5. Is mm/huge_memory.c the right place to define a generic mm function,
   even a stub?



