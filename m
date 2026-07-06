Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64679C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50EE46B00CE; Mon,  6 Jul 2026 04:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6126B00FA; Mon,  6 Jul 2026 04:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE5B6B00FC; Mon,  6 Jul 2026 04:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0199B6B00CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:46:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8DFC71A0335
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:46:55 +0000 (UTC)
X-FDA: 84957721590.07.C737A04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E367280005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:46:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3DTPkDZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aamOsmuHLb37FH1la8uw/6nypO2zKI4knV9R9WdC8zI=;
	b=f/WzW47jUQyAKTI4/yZnG83osOFbKoRuHncPtNhZ0Z5+qbT6N45Vig3amFLDVb/uFiu9va
	5yRdG2+97+dyvYFZc0tcNLxqk0aMVc/dPIhGGzruem10tcc6Fom6BjTIm+iNiDt9mnkgAl
	yhDYEp15JDI5Tcpc4MmLq6KxqclrO+s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3DTPkDZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327613;
	b=DiYhIb0vP2sC+bujQlQCl9CNUaqynaZHiMKB3pmlW5ApprK2nVLxVjD74pMGGtAwbIloSR
	7FqNvSmrWKzX9DQTtTdDMFMOYmYwQi7SmFfoOJ+jf7EtL69KbwKU3C4MXayjr5sgDGBFFy
	/VfK1CefBSXQD9cN2Ymps7Zbdx1cNrE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51CFD6138C;
	Mon,  6 Jul 2026 08:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63991F000E9;
	Mon,  6 Jul 2026 08:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327613;
	bh=aamOsmuHLb37FH1la8uw/6nypO2zKI4knV9R9WdC8zI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L3DTPkDZIUqx8Nk3kg9DUA6JR3HqOcCsSX4NbFsz4WFSgtNVQMdkoN5a41c62uDHv
	 icaF8G3VgRIoGP6n4uD6rhGTP4oP3JqTLGKokoFQU50Q90ccE8OW7ZBi+a78i6djhh
	 OV5Am7CETroE8xw1t6J4CsHdIuLYlbRsI1YALg2ZU9eL5UaEHal9eJxV5DRfSL/M1h
	 B5nZuUCJFgaqeKICeh80D9+yBsHHLKezZHfHDc/raytvewe6gOcTukVLhi0/qQ5r6p
	 LFQtXgKP47EPzEWteN1rHgtc6PM8M7bgUbfSp+oCHMzp6qPzikCzYqLMDhUe80knPC
	 s4xvfwYyVo7Ew==
Message-ID: <2e20d635-6326-48d1-af0b-776b15f47ce8@kernel.org>
Date: Mon, 6 Jul 2026 10:46:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/rmap: use huge_ptep_get() in
 try_to_migrate_one()
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-4-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260703114202.365553-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E367280005
X-Stat-Signature: eq9domg1r3uhtu9ir83tkxu94kp147ng
X-Rspam-User: 
X-HE-Tag: 1783327613-137541
X-HE-Meta: U2FsdGVkX19RgoubQbnNNHYvj43cDJPUQoE3yw6w4GZDkEyEVG5pSt71v6bSJKiq5xKISPNUCkg3uLIFv+xzXdt/+t7cLdL9Z11Lo7tjv+4CymZ9OTAt2g2uU89MUyEZcdB8XR8PWXdNc4rM9wwVUP9u65slOunzpxJcvs31OtqUZqqawDC0o8VyFqx11j7iz7m4YHU8W+8DhoirpNkgrUIe+zELIIW5kdW1/R6vUc0D41Qyd5ZxZXIjMtRMB14uiFGvwo1LnWqTEjaNpr2tRRk2fxdfbPpRQTPkadYGwRP4GF9J34iSkNNUyvbSe57sJeVpptqExk0sf0BvvUkPWLv91Yb9pN/w3FDB8GTewDE2xO/7v8RobQgQYd2EUU6C7Cc0LPnjP5z2zWtT1gWAvC+Sp1C9/w7WyeFLUtcCgAUkkKUKxMaXDyvbUHZ8jnmNe7RjxhwMz+/naVv+TfX/Um5qFIwr4xTdgS5q9DY7L/1Wezq7AF8K817lTpeeqmRMuuTg4SbbrcL5eG2JyVLCpLnKE2oABxZy1eegFbi52W2GEHMiDhr7ztS1Rb5eA5gJf1lMLu88Xv/zCoxkFhqiHTUNR0p7Lo+mCTz4K/e28KVWoTPuN3N2szOKn3smzQTk7DOvPK1VgaVnA7/Tj305wMxirvIgJWYh6Dwg1Jy6vw7oU2tWFT9FQH7F1gGzUR4x/ObmfYo8dbW0a+1sgg9QJGA/b5YjJVD7YIu3XjmbrDurgeQComXtIZ3zArdh5TphDY5V4bidfK52K/gCNoXNbSp99SJsK29C78MLROQnQqBJB21wpT8ZaHUzG5Xl/aSpk2J3HzvWpXyfKtz8ofryRnPY7NHgznVSvbiLnXnnTLi3YzXhg0cDQGv3noBRx/CcEgh9K/3+57qaDuVs0EDG7ZjaL/bb++VAG2kMQBYrpAw3Y/P2x0czKFupkKX3ayhPnDEtyb0gcP0HpAjuOGi
 FaTsMgoi
 2FOhANWcuTNe0IfR15KleSyzZ2RiyLVwrFRMPqLHTW0M0gZ/s4+KktOktWKpOgwenH2DKPuXKmkKDyQIxBsbSj3whVhKQ2cUXNw+T+upFFnZzUxIkgecSFQo/AeqGbNQ0X+ZTg1t6JXPHZ6hriaqkoDE9eflTP9HcgR6GDJ+o1gVOyElof02VfdDjCMPfItGM4WsQ5yM2rva+UEmBVXY69mFqKYSvMVZrbsVepkEz7zffRYAi/r6Y3o8fXx2C+eLTI/D2LivY01Kyo6d//aHzit0JesQeu1hRis68sM2B6s3SdLpKVft9FNWeZ18kudUIv7EobFs39iyXef3b3YqDcrlX+cpCxzrtGLlylhBO1B8uTW0AXJA+zrkqWyx4SQEtpHJAOEkThPrLzdNfBPeJRLS/Wo9ozgn3aBcoekG8Xd/M6iBskYYDWsKqMte3jxfu45nQzsDlNOP/Cvkcwl5SGJcp8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 13:41, Dev Jain wrote:
> try_to_migrate_one() is used by folio migration to replace a present
> mapping with a migration entry. For hugetlb folios, page_vma_mapped_walk()
> returns the pte pointer to the hugetlb folio in pvmw.pte, but the code
> reads the huge pte entry with ptep_get().
> 
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
> etc to misbehave.
> 
> It is not clear whether this has a trivially visible effect to userspace.
> 
> Use huge_ptep_get() to dereference a huge pte pointer.
> 
> Commit a98a2f0c8ce1 copied the bug from try_to_unmap_one into
> try_to_migrate_one.
> 
> Fixes: a98a2f0c8ce1 ("mm/rmap: split migration into its own function")
> Cc: stable@vger.kernel.org
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

