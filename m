Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47AD0C61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E96B6B008A; Tue, 25 Aug 2026 12:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A546B008C; Tue, 25 Aug 2026 12:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1FF6B0092; Tue, 25 Aug 2026 12:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBD4F6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:18:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B4BE160495
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:18:06 +0000 (UTC)
X-FDA: 85140298572.06.8DC95AD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id C61D61C0005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:18:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I98o4NkB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787674684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cCqc7oVmR4ctIExSqMB03/LPKofsssdghTgzdOd1co=;
	b=MQj7+eKi7j0UYVk7E2/YWySolc5LqC5hzig3HpEAOHojhbTBk9ejyudYg8P+tu3xskoT8/
	hLKJgYheKGgIX5dnBKSii2AhPrKa1LFnOLgb+K19AmjNSfjDCSYHicCiiatxsh/kucHhob
	LTkABPiKHPFa1lyGRw8xJFLKcQW6oj8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I98o4NkB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787674684;
	b=0YPVWQCS+xNBDSrRbQiuf41E/TnA1gJTUgIm867IVyxtUb7weFL6IvBDHEl70j+O6ANet/
	ll6mkLxqtC/fI81WBRB6vHTzKmuaXx6wnxped3xMmCcioK0ZbbsR33J6dWaE7b24Oh0ZOy
	MYU/A3Wrf3pmAxmIdNqNDiLgkjSDpig=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787674684; x=1819210684;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3U36cbJA9GGbJw+GO8g1uZN1QM2k4wAwzhPSeVBOlXU=;
  b=I98o4NkB/wzKWlFhwfjrVt1P+a/FOx48GnmE4JWc9zqZ5IaUPyoCxWUi
   E22wK6KZI8YkXBd6d7p91uATy0YtCGrib2hqaAhRx1r0+0kfcNB1huoES
   CpxONSEoWFMoVov1uWB469iEe6zHjHYojxDIn5uLyN+jD3D3Q9WOzWweh
   oVDU651NX2x+ksOyXnQSqJokC4NOknxWn602vwYjHeCOey/b6cESHI3gL
   h2zUGFOWKTL+naGYAeDKh4Cq4zsIL2ToFfVbeXsVBnLDAh9H8moDyE8o4
   OmWszlrJoWIcC6IFWWcP+h7xX3j6SWNT2D7lyHjGvADNVYjcH9PkQp8DC
   Q==;
X-CSE-ConnectionGUID: M8CNG2m5T2SPUroedOYtIA==
X-CSE-MsgGUID: 5p1zDt7ITCCw3KYqebojzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="75683614"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="75683614"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:18:02 -0700
X-CSE-ConnectionGUID: IVmEJ8cGTRWmBQlOpXyt3g==
X-CSE-MsgGUID: cI6+c/a6RCu4ERA2CPiKxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="264708705"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.12]) ([10.125.109.12])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 09:18:02 -0700
Message-ID: <2931f8a6-3780-4d6a-b19d-61cbbdad1a3a@intel.com>
Date: Tue, 25 Aug 2026 09:18:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] x86/mm: add set_direct_map_ro_noflush()
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, usama.arif@linux.dev,
 catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rppt@kernel.org, ryan.roberts@arm.com, ziy@nvidia.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>
References: <20260730090647.2401252-1-xueyuan.chen21@gmail.com>
 <20260730090647.2401252-4-xueyuan.chen21@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260730090647.2401252-4-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kpa71pwkkppf3x6yjrgz3ftw1jmfph3s
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C61D61C0005
X-Rspam-User: 
X-HE-Tag: 1787674683-572510
X-HE-Meta: U2FsdGVkX182vq+QhJ/Rk+itjo0P4g7fGbeHmkW0ICw91x4pytrVykBBSjwDMj7koMWqecSp3jDdgojJvBP4NY2g4O3z1aM47dl9lLbT84aP7cpH1AndzW4VpyYZD7Kyi+S2AjEpnApKZ3dnCCW/iZL4MMkhZMTAbbSwiNHftEzpRWHxe4qiecYJMsuapQXJrByRinI22bn1pOLoHY1kzaNT7BJhljNi2GyQD/yzcBn1Zi4+am9BLyzrs17faG/OEEVhCNjS5uZk7pClugVafTZ0Oj+tFJMjsL/v06vvSlHmuTIdKiPyF7IxqMRIfz2uWs+YXAV75mRbHpxXYYX7nGsbstOFMyZzuoP0mKYbUkLvcRcI78IO0SBshkLYfIKo+PNH2JXlD0PJwneCUUWq94oWTyNigeubaCDeODmFkoylIQxq/fp2Maf/zkmex87o60f2wPvxcJz4uERQ7TdwejUxi608DiMjhrbM0wZchK6u8xuiJm+b1Tu6N0JKZd38R/c5X0tLS7hP8RqaeYu0qsAMvz+gwlPnB+WOqHsuC6ldeu3mTTmEq2vkD9sMVwKIG4tbCYAVAaucgqTroEbFm9nvcmbhJ1vAzc9eC82ZEOsMJ7ADUrRPzSQLvbIEPhd5PLqDQMSrcGbefjZ9gfuTwqvOBofJ/23Xn4sGQhrvyqvy2hp/tvFfsA2pcoDXwBBwi7sMarDOs7vYhaU35mPTOZWwVagf7aCnmLYmU1neHCYFUNW8GWOUEHoNF/IObQdxJ/6zAjTRs+qQB5BOnD4brGl2awTjx6YE3SgJLX8sHVPHj+8hocePySe3BxuecJgT1gZMJnc/DNxRuhvjDftk0vRrMxDxZyQKlql1HQ0zfKGt/u7xjqVlJ9ZO6nglRojQ3PqKYNuX3lN0EvSluxOwf8iYTvDdfD532O9XoMgfgOaqBVo/5h+oSiT8ctKU/eGAgKqKnZx4saNO2p0FG+q
 PAYD4qUt
 U927YOK1NJtgTtO8KC5AoWi2OCU12mq6ikttcLP8TvkLKTZIfzp6QTGnyfGrQDW40hTbqD6QNdN9vTnesf0VqE5UmzNXrhPbJF75b5bBKmS3G5R4PTnwN3SrNHOvEYDoy9/qCnUpS3r0/CqeJupUiL6OaoTqNhN/jWL9gPVSVJKfIIflikKLWiDC+gRtY6/F9v1GG2OFurKwhhp6wiAGHwRQg6koXIS+5H3ypDQo0h3W98Q638ss3Hxvy40hNTXbrsbvXBC9xIisOpQIZ7zx6D1H7clumwniPrSbBX2pbPMseBcJFH9z7qkuclzbl6sjdLW+FBVwXvBSBKhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 02:06, Xueyuan Chen wrote:
> +int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
> +{
> +	unsigned long tempaddr = (unsigned long)addr;
> +	struct cpa_data cpa = {
> +		.vaddr = &tempaddr,
> +		.pgd = NULL,
> +		.numpages = nr_pages,
> +		.mask_set = __pgprot(0),
> +		.mask_clr = __pgprot(_PAGE_RW | _PAGE_DIRTY),
> +		.flags = CPA_NO_CHECK_ALIAS,
> +	};
> +
> +	return __change_page_attr_set_clr(&cpa, 1);
> +}

A couple of concerns here.

First, why the "_noflush"? Sure, the "this is a best effort hardening"
function argument can be made, so it doesn't need to be correct. But the
result is a function that's called once and also has some sharp corners
and relatively high potential for misuse. Let's just do the flush.

Second, I see that the other set_direct_map*() callers use
CPA_NO_CHECK_ALIAS. The reasoning behind it dates back to 2008 and I'm
not 100% sure what it is referring to. On one hand, it would be nice to
have all the set_direct_map*() callers be consistent. On the other hand,
there shouldn't *be* any aliases of a 2M page that came out of the page
allocator. We almost want a CPA_ASSERT_NO_ALIASES that goes out and
checks for aliases more than we want to ignore them. (Note: I don't
expect you to fix this, but a simple comment saying that no aliases are
expected would be nice)

Third, what's with the 'tempaddr'? Are you working around the 'const'?
Honestly, I'd rather have no const than have it and subvert it with
casting trickery.

Last:

int set_direct_map_invalid_noflush(struct page *page)
int set_direct_map_default_noflush(struct page *page)
int set_direct_map_valid_noflush(struct page *page, unsigned nr, ...
int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)

Which one of these things is not like the other, despite being named
just like them?

Imagine the fun if someone did:

	set_direct_map_ro_noflush(page, 1);
and
	set_direct_map_default_noflush(page)



